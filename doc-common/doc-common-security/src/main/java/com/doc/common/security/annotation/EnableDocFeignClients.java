package com.doc.common.security.annotation;

import org.springframework.cloud.openfeign.EnableFeignClients;

import java.lang.annotation.*;

/**
 * @author shiliuyinzhen
 */
@Documented
@EnableFeignClients
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface EnableDocFeignClients {

    String[] value() default {};

    String[] basePackages() default { "com.doc" };

    Class<?>[] basePackageClasses() default {};

    Class<?>[] defaultConfiguration() default {};

    Class<?>[] clients() default {};
}
