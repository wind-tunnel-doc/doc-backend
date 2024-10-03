package com.doc.gateway.config;

import com.doc.gateway.handler.ValidateCodeHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;

/**
 * 路由配置信息,验证码实现逻辑
 * 
 * @author shiliuyinzhen
 */
@Configuration
public class RouterFunctionConfiguration {

    @Autowired
    private ValidateCodeHandler validateCodeHandler;

    /**
     * 响应式编程，拦截验证码
     * webflux是异步非阻塞，可以提高性能和效率
     * @return
     */
    @Bean
    public RouterFunction routerFunction() {
        return RouterFunctions.route(
                RequestPredicates.GET("/captcha").and(RequestPredicates.accept(MediaType.APPLICATION_JSON)),
                validateCodeHandler);
    }

}
