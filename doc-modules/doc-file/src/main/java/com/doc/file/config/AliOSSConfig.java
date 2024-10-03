package com.doc.file.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * AliOSS 配置信息
 *
 * @author shiliuyinzhen
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "alioss")
public class AliOSSConfig {

    /**
     * 节点OSS外网访问的地域endpoint
     */
    private String endpoint;

    /**
     * 在创建用户时保存的AccessKey ID
     */
    private String accessKeyId;

    /**
     * 在创建用户时保存的AccessKey Secret
     */
    private String accessKeySecret;

    /**
     * bucket名称
     */
    private String bucketName;
}
