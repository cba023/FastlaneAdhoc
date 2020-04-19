require './build_conf'

class UserSetting
# 初始化数据，
  def self.initData
    # 更新描述信息，每一项用`；`隔开
    BuildConf.update_desc = "更新了A功能；优化了B功能；修复了C问题；"
    BuildConf.build_configuration = "Release"
    BuildConf.app_export_method = "ad-hoc"
    BuildConf.is_upload_to_pgyer = true
    BuildConf.is_send_to_dingtalk = true
    BuildConf.is_upload_dSYM_to_bugly = true
    # pgyer_selected_index, app_sign_seleted_index, ding_webhook_index的索引值选择请参照DataSource类
    BuildConf.pgyer_selected_index = 2
    BuildConf.app_sign_seleted_index = 0
    BuildConf.ding_webhook_index = 3
  end
end