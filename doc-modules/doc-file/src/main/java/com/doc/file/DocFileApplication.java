package com.doc.file;

import com.doc.common.swagger.annotation.EnableCustomSwagger2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;

/**
 * 文件服务
 * 
 * @author shiliuyinzhen
 */
@EnableCustomSwagger2
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class })
@ComponentScan("com.doc.**")
public class DocFileApplication {
    public static void main(String[] args) {
        SpringApplication.run(DocFileApplication.class, args);
        System.out.println("文件服务模块 启动成功~");
    }
}
