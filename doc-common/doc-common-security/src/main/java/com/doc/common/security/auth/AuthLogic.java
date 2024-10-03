package com.doc.common.security.auth;

import com.doc.common.core.exception.auth.NotLoginException;
import com.doc.common.core.utils.SpringUtils;
import com.doc.common.security.annotation.RequiresLogin;
import com.doc.common.security.service.TokenService;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.entity.LoginUser;

/**
 * Token 权限验证，逻辑实现类
 * 
 * @author shiliuyinzhen
 */
public class AuthLogic {

    /** 所有权限标识 */
    private static final String ALL_PERMISSION = "*:*:*";

    /** 管理员角色权限标识 */
    private static final String SUPER_ADMIN = "admin";

    public TokenService tokenService = SpringUtils.getBean(TokenService.class);

    /**
     * 会话注销
     */
    public void logout() {

        String token = SecurityUtils.getToken();
        if (token == null) {
            return;
        }
        logoutByToken(token);
    }

    /**
     * 会话注销，根据指定Token
     */
    public void logoutByToken(String token)
    {
        tokenService.delLoginUser(token);
    }

    /**
     * 检验用户是否已经登录，如未登录，则抛出异常
     */
    public void checkLogin() {
        getLoginUser();
    }

    /**
     * 获取当前用户缓存信息, 如果未登录，则抛出异常
     * 
     * @return 用户缓存信息
     */
    public LoginUser getLoginUser() {
        String token = SecurityUtils.getToken();
        if (token == null) {
            throw new NotLoginException("未提供token");
        }
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (loginUser == null) {
            throw new NotLoginException("无效的token");
        }
        return loginUser;
    }

    /**
     * 获取当前用户缓存信息, 如果未登录，则抛出异常
     * 
     * @param token 前端传递的认证信息
     * @return 用户缓存信息
     */
    public LoginUser getLoginUser(String token) {
        return tokenService.getLoginUser(token);
    }

    /**
     * 验证当前用户有效期, 如果相差不足120分钟，自动刷新缓存
     * 
     * @param loginUser 当前用户信息
     */
    public void verifyLoginUserExpire(LoginUser loginUser)
    {
        tokenService.verifyToken(loginUser);
    }

    /**
     * 根据注解(@RequiresLogin)鉴权
     * 
     * @param at 注解对象
     */
    public void checkByAnnotation(RequiresLogin at)
    {
        this.checkLogin();
    }
}
