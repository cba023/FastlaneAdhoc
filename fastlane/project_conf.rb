# 采集工程信息，包含XCode工程和打包导出配置
class ProjectConf

  @project_name = "<XCode工程名>"
  @app_name = "<App的名字，比如：微信>"


  @@CurTime = Time.now   # 类变量：当前时间

  def self.app_build_time   # 类方法：app开始构建时间
    return @@CurTime.strftime('%Y-%m-%d %H:%M:%S')
  end

  def self.output_year_month # 类方法：app开始构建的年月，用于导出IPA和更新日志时使用
    return @@CurTime.strftime('%Y_%m')
  end

  def self.output_file_build_time # 类方法：存入文件格式的app开始构建的时间，用于存入文件名
    return @@CurTime.strftime('%Y%m%d_%H%M%S')
  end

  def self.project_name  # 工程名get方法
    return @project_name
  end

  def self.app_name # 应用名get方法
    return @app_name
  end

  def self.output_dir  # 输出根目录
    return "/Users/#{`whoami`.chomp}/FastlaneOutput"
  end

  def self.ipa_dir  # 输入ipa文件夹
    return "#{self.output_dir}/Apps/#{ProjectConf.output_year_month}"
  end

  def self.log_dir  # 输出更新日志文件夹
    return "#{self.output_dir}/Logs"
  end

  def self.ipa_name # 输入的ipa文件的文件名
    return "#{self.project_name}_#{ProjectConf.output_file_build_time}.ipa"
  end

  def self.cur_branch  # 项目构建时所在的分支（没有配置Git的情况不会有值）
    return `git rev-parse --abbrev-ref HEAD`.to_s.chomp
  end

  def self.cur_commit_id # 项目构建时Git的Commit ID（没有配置Git的情况不会有值）
    return `git log --pretty=format:"%h" | head -1  | awk '{print $1}'`.to_s.chomp
  end

  def self.pbxproj_path  #  project.pbxproj文件路径，读取工程信息需要读取该文件
    return "../#{self.project_name}.xcodeproj/project.pbxproj"
  end

  def self.app_version # 应用版本信息（如果工程中没有配置则预设为1.0）
    ver = "1.0"
    app_version_line = `sed -n '/MARKETING_VERSION/'p #{self.pbxproj_path}`
    if app_version_line != nil then
      ver = app_version_line[/\= .*;/].delete('"').delete('=').delete(' ').delete(';')
    end
    return ver
  end

  def self.build_version # 应用构建版本信息（如果工程中没有配置则预设为1）
    ver = "1"
    build_version_line = `sed -n '/CURRENT_PROJECT_VERSION/'p #{self.pbxproj_path}`
    if build_version_line != nil then
      ver = build_version_line[/\= .*;/].delete('"').delete('=').delete(' ').delete(';')
    end
    return ver
  end

end