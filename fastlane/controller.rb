# Fastlane的数据配置和方法调用文件
# 注: 该文件所在文件夹可以用RubyMine以工程形式打开调试

require 'fileutils'
require 'net/http'
require 'json'
require './data_source'
require './project_conf'
require './build_conf'
require './code_conf'
require './user_setting'

# 控制器类
class Controller
  def self.initConf
    # 从UserSetting类中初始化数组配置
    UserSetting.initData  # 首先通过UserSetting类去预设构建配置
    # 是否可以自切环境的中文描述
    @is_mutable_enviroment_desc = CodeConf.is_mutable_enviroment == true ? "可切换" : "不可切换"
    # 以下几项是更具BuildConf中配置的索引值去取DataSource类中数据源配置，也是要在UserSetting中预设
    @pgyer_conf = DataSource.pgyer_configs.at(BuildConf.pgyer_selected_index)
    @app_sign_conf = DataSource.app_signs.at(BuildConf.app_sign_seleted_index)
    @ding_webhook_conf = DataSource.ding_webhooks.at(BuildConf.ding_webhook_index)
  end

  def self.pgyer_conf
    return @pgyer_conf
  end

  def self.app_sign_conf
    return @app_sign_conf
  end

  def self.ding_webhook_conf
    return @ding_webhook_conf
  end

  # 打印构建配置
  def self.print_configs
    puts("\n⬇︎ 蒲公英配置 ⬇︎\napi_key: #{@pgyer_conf["api_key"]}\nuser_key: #{@pgyer_conf["user_key"]}\napp_url: #{@pgyer_conf["app_url"]}\napp_icon: #{@pgyer_conf["app_icon"]}")
    puts("\n⬇︎ 签名配置 ⬇︎\nbundle_id: #{@app_sign_conf["bundle_id"]}\nprovisioning_profile: #{@app_sign_conf["provisioning_profile"]}")
    puts("\n⬇︎ 钉消息配置 ⬇︎\n钉消息目标群: #{@ding_webhook_conf["name"]}\nwebhook URL: #{@ding_webhook_conf["url"]}")
    puts "\n"
    puts "\n⬇︎ markdown消息配置 ⬇︎\n#{self.ding_release_note}"
  end

  # 格式化更新信息（规则：中英文分号或分号带空格通通转换成中文分号间隔）
  def self.formated_update_desc
    # 更新内容规范化
    formated_desc = BuildConf.update_desc.gsub(/； |; |;/, "；").chomp
    if formated_desc[-1, 1] == "；" then
      formated_desc.chop!
    end
    if formated_desc.length == 0 then
      formated_desc = "<暂无记录>"
    end
    return formated_desc
  end

  # 通过格式化后的更新信息 => 更新信息数组（规则：利用分号分割）
  def self.updates
    updates = self.formated_update_desc.split("；")
    return updates
  end

  # 生成本次构建信息项目通用哈希数组
  def self.build_items
    items = Array[
        {"item" => "应用版本", "value" => ProjectConf.app_version + "(build #{ProjectConf.app_version})"},
        {"item" => "构建时间", "value" => ProjectConf.app_build_time},
        {"item" => "构建环境", "value" => "#{CodeConf.enviroment}(#{@is_mutable_enviroment_desc})"},
        {"item" => "构建途径", "value" => "#{BuildConf.build_configuration} => #{BuildConf.app_export_method}"},
        {"item" => "构建分支", "value" => "#{ProjectConf.cur_branch}(#{ProjectConf.cur_commit_id})"},
        {"item" => "应用签名", "value" => @app_sign_conf["bundle_id"]}
    ]
    return items
  end

  # 生成更新描述的markdown格式的无需列表字符串（用途：发送钉消息；存入本地更新日志；蒲公英更新项也采用此方案，换行 + `*`）
  def self.md_update_content
    content = String.new
    (0..updates.count - 1).each { |i|
      content += "* " + updates[i] + "\n"
    }
    return content
  end

  # 生成构建信息项信息：用于存入markdown无序列表
  def self.md_build_content
    content = String.new
    (0..self.build_items.length - 1).each { |i|
      content += "* #{self.build_items[i]["item"]}: #{self.build_items[i]["value"]}\n"
    }
    return content
  end

  # 生成构建项信息：用于写入到上传蒲公英的描述中
  def self.pyger_build_content
    content = String.new
    (0..self.build_items.length - 1).each { |i|
      content += "#{self.build_items[i]["item"]}: #{self.build_items[i]["value"]}\n"
    }
    return content
  end

  # 生成蒲公英工程上传时的描述信息
  def self.pgyer_build_article
    return self.pyger_build_content + "更新描述：\n" + self.md_update_content
  end

  # 用于写入本地日志文件的更新内容
  def self.logs_release_note
    release_note = "\n## v#{ProjectConf.app_version} (#{ProjectConf.ipa_name})\n\n" + "> 构建信息\n\n" + "#{self.md_build_content}\n" + "> 更新描述\n\n" + "#{self.md_update_content}\n" + "------------------------------\n"
    return release_note
  end

  # 用于发送钉钉webhook消息的更新内容
  def self.ding_release_note
    msg_title = "发现#{ProjectConf.app_name}(iOS)新版本!\n"
    release_note = "### #{msg_title}\n" +
        "![#{@pgyer_conf["app_icon"]}](#{@pgyer_conf["app_icon"]})\n\n" +
        "###### *链接*: [#{@pgyer_conf["app_url"]}](#{@pgyer_conf["app_url"]})\n\n" +
        "------------------------------\n\n" + "> 构建信息\n\n" + "#{self.md_build_content}\n" + "> 更新描述\n\n" + "#{self.md_update_content}\n"
    return release_note
  end

  # 写入更新日志到本地
  def self.write_to_local_logs
    # puts "\nself.md_build_content\n"
    # puts "\nself.md_update_content\n"
    release_note_path = "#{ProjectConf.log_dir}/#{ProjectConf.app_name}_iOS_#{ProjectConf.output_year_month}更新记录.md"
    r_n_path_temp = "#{ProjectConf.log_dir}/.latest_log.tmp"
    # 如果本次构建有更新，则写入更新日志（先要检测Log文件夹是否存在，不存在则需要创建）
    FileUtils.mkpath "#{ProjectConf.log_dir}"
    if File::exists?(release_note_path) == false then
      # 如果文件不存在，创建文件并写入内容
      `touch #{release_note_path}`
      `echo "# #{ProjectConf.app_name}(iOS) #{ProjectConf.output_year_month}更新记录\n\n" >> #{release_note_path}`
    end
    # 写入本次更新内容
    `echo "#{self.logs_release_note}" >  "#{r_n_path_temp}"` # 先将本次更新内容存入到缓存文件
    `sed -i '' '/更新记录/r #{r_n_path_temp}' #{release_note_path}` # 将缓存文件的内容插入到`release_note_path`文件的`更新记录`所在行的下一行
    `rm -rf #{r_n_path_temp}`  # 删除缓存文件
    puts "\n------------------------------\n"
    puts "✅ 已经成功写入更新日志到:#{release_note_path} ✅"
  end

  # 发送更新信息到钉钉群
  def self.send_ding_msg
    msg_title = "发现#{ProjectConf.app_name}(iOS)新版本!\n"
    markdown = {
        "msgtype": "markdown",
        "markdown": {title: msg_title, text: ding_release_note}
    }

    # 发起发送请求
    uri = URI.parse(@ding_webhook_conf["url"])
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/json')
    request.body = markdown.to_json

    response = https.request(request)
    puts "------------------------------"
    puts "Response #{response.code} #{response.message}: #{response.body}"
    if response.code == "200" then
      puts "✅ 已发送钉消息 ==> #{@ding_webhook_conf["name"]}(url: #{@ding_webhook_conf["url"]}) ✅"
    else
      puts "❎ 钉消息发送失败 ❎"
    end
  end

  # 上传符号表到bugly
  def self.upload_dSYM_to_bugly
    bugly_app_id = "<bugly的app_id，这里其实也可以抽取到数据源配置类中>"
    bugly_app_key = "<bugly的app_key，可以抽取到数据源配置类中>"
    dSYM_name = "#{ProjectConf.project_name}_#{ProjectConf.output_file_build_time}.app.dSYM.zip"
    dSYM_path = "#{ProjectConf.ipa_dir}/#{dSYM_name}"
    channel = "default"

    bugly_desc = "⬇︎ Bugly符号表配置 ⬇︎\n" +
        "bugly_app_id: #{bugly_app_id}\n" +
        "bugly_app_key: #{bugly_app_key}\n" +
        "dSYM_path: #{dSYM_path}\n" +
        "channel: #{channel}\n"
    puts bugly_desc
    `curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=#{bugly_app_key}&app_id=#{bugly_app_id}" --form "api_version=1" --form "app_id=#{bugly_app_id}" --form "app_key=#{bugly_app_key}" --form "symbolType=2"  --form "bundleId=#{@app_sign_conf["bundle_id"]}" --form "productVersion=#{ProjectConf.app_version}" --form "channel=#{channel}" --form "fileName=#{dSYM_name}" --form "file=@#{dSYM_path}" --verbose`
  end
end

# 这里是需要调用控制器自己的initConf方法，作为Fastfile引入Controller类时调用栈中最先执行的方法
Controller.initConf
Controller.print_configs