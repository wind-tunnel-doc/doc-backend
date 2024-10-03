package com.doc.common.security.aspect;

import com.doc.common.security.annotation.RequiresLogin;
import com.doc.common.security.auth.AuthUtil;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;

import java.lang.reflect.Method;

/**
 * 基于 Spring Aop 的注解鉴权
 * @author shiliuyinzhen
 */
public class PreAuthorizeAspect {

    /**
     * 构建
     */
    public PreAuthorizeAspect() { }

    /**
     * 定义AOP签名 (切入所有使用鉴权注解的方法)
     */
    // todo 鉴权注解
    public static final String POINTCUT_SIGN =
            " @annotation(com.doc.common.security.annotation.RequiresLogin) ";

    /**
     * 声明AOP签名
     */
    @Pointcut(POINTCUT_SIGN)
    public void pointcut() { }


    /**
     * 环绕切入
     *
     * @param joinPoint 切面对象
     * @return 底层方法执行后的返回值
     * @throws Throwable 底层方法抛出的异常
     */
    @Around("pointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {

        // 注解鉴权
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        //注解检查，判断是否需要登录
        checkMethodAnnotation(signature.getMethod());
        try {
            // 执行原有逻辑
            Object obj = joinPoint.proceed();
            return obj;
        } catch (Throwable e) {
            throw e;
        }
    }

    /**
     * 对一个Method对象进行注解检查
     */
    public void checkMethodAnnotation(Method method) {

        // 校验 @RequiresLogin 注解
        RequiresLogin requiresLogin = method.getAnnotation(RequiresLogin.class);
        if (requiresLogin != null) {
            AuthUtil.checkLogin();
        }
    }
}
