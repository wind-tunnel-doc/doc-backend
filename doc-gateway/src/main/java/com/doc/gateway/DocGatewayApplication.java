package com.doc.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;

/**
 * 网关
 * 
 * @author shiliuyinzhen
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
@ComponentScan("com.doc.**")
public class DocGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(DocGatewayApplication.class, args);
        System.out.println("风洞文档 网关 启动成功~");
    }
}
