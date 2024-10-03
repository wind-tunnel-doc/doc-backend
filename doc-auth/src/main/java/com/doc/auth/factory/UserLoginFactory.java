package com.doc.auth.factory;

import com.doc.auth.config.LoginTypeProperties;
import com.doc.auth.strategy.UserLogin;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import java.util.concurrent.ConcurrentHashMap;

/**
 * 用户登录工厂
 * @author shiliuyinzhen
 */
@Component
public class UserLoginFactory implements ApplicationContextAware {

    @Autowired
    private LoginTypeProperties loginTypeProperties;

    /**
     * 存储登录策略
     */
    private static ConcurrentHashMap<String,UserLogin> userLoginMap = new ConcurrentHashMap<>();

    /**
     * 从配置文件中读取查询策略的信息
     * {
     *     account: accountLogin 账号密码登录
     *     email: emailLogin 邮箱验证码登录
     * }
     * @param applicationContext
     * @throws BeansException
     */
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        loginTypeProperties.getType().forEach((k,v) -> {
            userLoginMap.put(k,(UserLogin) applicationContext.getBean(v));
        });
    }

    /**
     * 通过不同的登录类型，返回对应的策略对象
     * @param loginType 登录类型,需要和配置文件保持一致
     * @return 具体登录策略对象
     */
    public static UserLogin getUserLogin(String loginType) {
        return userLoginMap.get(loginType);
    }

}
