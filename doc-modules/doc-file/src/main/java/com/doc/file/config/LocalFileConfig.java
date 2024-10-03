package com.doc.file.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

/**
 * 通用映射配置
 * 
 * @author shiliuyinzhen
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "local")
public class LocalFileConfig implements WebMvcConfigurer {

    /**
     * 上传文件存储在本地的根路径
     */
    private String path;

    /**
     * 资源映射路径 前缀
     */
    public String prefix;

    /**
     * 域名或本机访问地址
     */
    public String domain;


    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        /** 本地文件上传路径 */
        registry.addResourceHandler(prefix + "/**")
                .addResourceLocations("file:" + path + File.separator);
    }
    
    /**
     * 开启跨域
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // 设置允许跨域的路由
        registry.addMapping(prefix  + "/**")
                // 设置允许跨域请求的域名
                .allowedOrigins("*")
                // 设置允许的方法
                .allowedMethods("GET");
    }
}