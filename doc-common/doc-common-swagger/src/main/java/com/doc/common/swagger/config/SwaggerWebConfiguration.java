package com.doc.common.swagger.config;

import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * swagger 资源映射路径
 * 
 * @author shiliuyinzhen
 */
public class SwaggerWebConfiguration implements WebMvcConfigurer {

    /**
     * 设置静态资源映射，主要是访问接口文档(html、js、css)
     * 注：如果不设置静态资源映射，会被认为是一个请求，会报 404
     * @param registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        /** swagger-ui 地址 */
        registry.addResourceHandler("/swagger-ui/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/springfox-swagger-ui/");

        /** knife4j 接口文档 */
        registry.addResourceHandler("/doc.html")
                .addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
}