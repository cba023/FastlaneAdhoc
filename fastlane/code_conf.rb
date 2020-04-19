# require './project_conf'  # 如果有依赖项，则要引入其他的类（默认没有引入）
# require './build_conf'

# 从项目代码中读取配置的类,日常构建项目时不需要更改该文件
class CodeConf
  # 从项目代码中读取当前工程的网络环境
  def self.enviroment
    return 'div'
  end

  # 通过代码读取当前工程是否支持用户自切网络环境
  def self.is_mutable_enviroment
    return false
  end
end

# puts "网络环境 => #{CodeConf.enviroment}"
# puts "是否可自切换网络环境 => #{CodeConf.is_mutable_enviroment}"