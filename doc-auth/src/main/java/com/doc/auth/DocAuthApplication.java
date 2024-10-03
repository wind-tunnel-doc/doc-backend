package com.doc.auth;

import com.doc.common.security.annotation.EnableDocFeignClients;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;

/**
 * 认证授权中心
 * 
 * @author shiliuyinzhen
 */
@EnableDocFeignClients(value = "com.doc")
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
@ComponentScan(basePackages = "com.doc.**")
public class DocAuthApplication {
    public static void main(String[] args) {
        SpringApplication.run(DocAuthApplication.class, args);
        System.out.println("认证授权中心 启动成功~");
    }
}
