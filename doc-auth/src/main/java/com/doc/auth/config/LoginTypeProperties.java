package com.doc.auth.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.Map;

/**
 * 登录类型配置文件
 * @author shiliuyinzhen
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "login")
public class LoginTypeProperties {

    private Map<String,String> type;

}
