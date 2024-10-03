package com.doc.system;

import com.doc.common.security.annotation.EnableCustomConfig;
import com.doc.common.security.annotation.EnableDocFeignClients;
import com.doc.common.swagger.annotation.EnableCustomSwagger2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

/**
 * 系统模块
 * 
 * @author shiliuyinzhen
 */
@EnableCustomConfig
@EnableCustomSwagger2
@EnableDocFeignClients(value = "com.doc")
@SpringBootApplication
@ComponentScan(basePackages = "com.doc.**")
public class DocSystemApplication {
    public static void main(String[] args) {
        SpringApplication.run(DocSystemApplication.class, args);
        System.out.println("风洞文档 系统模块 启动成功~");
    }
}
