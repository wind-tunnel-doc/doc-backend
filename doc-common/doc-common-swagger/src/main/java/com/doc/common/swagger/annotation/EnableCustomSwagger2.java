package com.doc.common.swagger.annotation;

import com.doc.common.swagger.config.SwaggerAutoConfiguration;
import org.springframework.context.annotation.Import;

import java.lang.annotation.*;

/**
 * 自动配置 swagger 接口文档
 * @author shiliuyinzhen
 */
@Documented
@Inherited // 可以被继承
@Target({ ElementType.TYPE }) //只能加到类上
@Retention(RetentionPolicy.RUNTIME) // 作用于运行时
@Import({ SwaggerAutoConfiguration.class })
public @interface EnableCustomSwagger2 {

}
