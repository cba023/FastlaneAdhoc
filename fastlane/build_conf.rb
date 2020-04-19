# 构建配置数据模型类
class BuildConf

  def self.update_desc
    return @update_desc
  end
  def self.update_desc=(val)
    @update_desc = val
  end

  def self.build_configuration
    return @build_configuration
  end
  def self.build_configuration=(val)
    @build_configuration = val
  end

  def self.app_export_method
    return @app_export_method
  end
  def self.app_export_method=(val)
    @app_export_method = val
  end

  def self.is_upload_to_pgyer
    return @is_upload_to_pgyer
  end
  def self.is_upload_to_pgyer=(val)
    @is_upload_to_pgyer = val
  end

  def self.is_send_to_dingtalk
    return @is_send_to_dingtalk
  end
  def self.is_send_to_dingtalk=(val)
    @is_send_to_dingtalk = val
  end

  def self.is_upload_dSYM_to_bugly
    return @is_upload_dSYM_to_bugly
  end
  def self.is_upload_dSYM_to_bugly=(val)
    @is_upload_dSYM_to_bugly = val
  end

  def self.pgyer_selected_index
    return @pgyer_selected_index
  end
  def self.pgyer_selected_index=(val)
    @pgyer_selected_index= val
  end

  def self.app_sign_seleted_index
    return @app_sign_seleted_index
  end
  def self.app_sign_seleted_index=(val)
    @app_sign_seleted_index= val
  end

  def self.ding_webhook_index
    return @ding_webhook_index
  end
  def self.ding_webhook_index=(val)
    @ding_webhook_index = val
  end

end

# puts BuildConf.update_desc
# puts BuildConf.build_configuration
# puts BuildConf.app_export_method
# puts BuildConf.is_upload_to_pgyer
# puts BuildConf.is_send_to_dingtalk
# puts BuildConf.is_upload_dSYM_to_bugly

