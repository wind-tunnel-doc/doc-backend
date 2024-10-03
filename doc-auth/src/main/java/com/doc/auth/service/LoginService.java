package com.doc.auth.service;

import com.doc.auth.factory.UserLoginFactory;
import com.doc.auth.strategy.UserLogin;
import com.doc.common.core.constant.Constants;
import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.constant.UserConstants;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.result.Result;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.redis.service.RedisService;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.dto.LoginDTO;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.RemoteUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 登录校验方法
 * 
 * @author shiliuyinzhen
 */
@Component
public class LoginService {

    @Autowired
    private RemoteUserService remoteUserService;

    @Autowired
    private RecordLogService recordLogService;

    /**
     * 用户退出
     * @param loginName
     */
    public void logout(String loginName)
    {
        recordLogService.recordLogininfor(loginName, Constants.LOGOUT, "退出成功");
    }

    /**
     * 用户注册
     * @param sysUser
     * @return
     */
    public void register(SysUser sysUser) {

        String userName =  sysUser.getUsername();
        String nickName =  sysUser.getNickName();
        String password =  sysUser.getPassword();

        // 用户名或密码为空 错误
        if (StringUtils.isAnyBlank(userName, password)) {
            throw new ServiceException("用户/密码必须填写");
        }
        if (StringUtils.isAnyBlank(nickName, password)) {
            throw new ServiceException("用户昵称必须填写");
        }
        if (userName.length() < UserConstants.USERNAME_MIN_LENGTH
                || userName.length() > UserConstants.USERNAME_MAX_LENGTH) {
            throw new ServiceException("用户名长度必须在2到20个字符之间");
        }
        if (nickName.length() < UserConstants.USERNAME_MIN_LENGTH
                || nickName.length() > UserConstants.USERNAME_MAX_LENGTH) {
            throw new ServiceException("昵称长度必须在2到20个字符之间");
        }
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH) {
            throw new ServiceException("密码长度必须在5到20个字符之间");
        }

        // 注册用户信息
        sysUser.setUsername(userName);
        sysUser.setNickName(nickName);
        sysUser.setPassword(SecurityUtils.encryptPassword(password));
        Result<?> registerResult = remoteUserService.registerUserInfo(sysUser, SecurityConstants.INNER);

        if (Result.FAIL == registerResult.getCode()) {
            throw new ServiceException(registerResult.getMsg());
        }
        recordLogService.recordLogininfor(userName, Constants.REGISTER, "注册成功");
    }
}
