package com.doc.common.security.auth;

import com.doc.system.pojo.entity.LoginUser;

/**
 * Token 权限验证工具类
 * 
 * @author shiliuyinzhen
 */
public class AuthUtil {

    /**
     * 底层的 AuthLogic 对象
     */
    public static AuthLogic authLogic = new AuthLogic();

    /**
     * 会话注销
     */
    public static void logout()
    {
        authLogic.logout();
    }

    /**
     * 会话注销，根据指定Token
     * 
     * @param token 指定token
     */
    public static void logoutByToken(String token)
    {
        authLogic.logoutByToken(token);
    }

    /**
     * 检验当前会话是否已经登录，如未登录，则抛出异常
     */
    public static void checkLogin() {
        authLogic.checkLogin();
    }

    /**
     * 获取当前登录用户信息
     * 
     * @param token 指定token
     * @return 用户信息
     */
    public static LoginUser getLoginUser(String token) {
        return authLogic.getLoginUser(token);
    }

    /**
     * 验证当前用户有效期
     * 
     * @param loginUser 用户信息
     */
    public static void verifyLoginUserExpire(LoginUser loginUser)
    {
        authLogic.verifyLoginUserExpire(loginUser);
    }
}
