# 用户配置的数据源
class DataSource
    # 蒲公英配置数组, 可以配置多组数据，构建时选其一
    @pgyer_configs  = Array[
        {
            "api_key" => "xxxxxxxxxxx",
            "user_key" => "xxxxxxxxxxx",
            "app_url" => "https://www.pgyer.com/xxxx",
            "app_icon" => "https://www.pgyer.com/app/qrcode/xxxx"
        },
        {
            "api_key" => "xxxxxxxxxxx",
            "user_key" => "xxxxxxxxxxx",
            "app_url" => "https://www.pgyer.com/xxxx",
            "app_icon" => "https://www.pgyer.com/app/qrcode/xxxx"
        },
        {
            "api_key" => "xxxxxxxxxxx",
            "user_key" => "xxxxxxxxxxx",
            "app_url" => "https://www.pgyer.com/xxxx",
            "app_icon" => "https://www.pgyer.com/app/qrcode/xxxx"
        }
    ]

    # 应用配置签名数组(构建时选其一)
    @app_signs = Array[
        {"bundle_id" => "<bundle id1>", "provisioning_profile" => "<描述文件名1>"},
        {"bundle_id" => "<bundle id2>", "provisioning_profile" => "<描述文件名2>"},
    ]

    # 钉钉webhook链接数组
    @ding_webhooks = Array[
        {"name" => "<钉钉群1>", "url" => "https://oapi.dingtalk.com/robot/send?access_token=xxxxx"},
        {"name" => "<钉钉群2>", "url" => "https://oapi.dingtalk.com/robot/send?access_token=xxxxx"},
        {"name" => "<钉钉群3>", "url" => "https://oapi.dingtalk.com/robot/send?access_token=xxxxx"},
        {"name" => "<钉钉群4>", "url" => "https://oapi.dingtalk.com/robot/send?access_token=xxxxx"}
    ]

    def self.pgyer_configs
        return @pgyer_configs
    end

    def self.app_signs
        return @app_signs
    end

    def self.ding_webhooks
        return @ding_webhooks
    end
end