package com.doc.auth.strategy;

import com.doc.auth.service.PasswordService;
import com.doc.auth.service.RecordLogService;
import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.constant.Constants;
import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.constant.UserConstants;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.result.Result;
import com.doc.common.core.text.Convert;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.utils.ip.IpUtils;
import com.doc.common.redis.service.RedisService;
import com.doc.system.pojo.dto.LoginDTO;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.RemoteUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 账号密码登录
 * @author shiliuyinzhen
 */
@Component
public class AccountLogin implements UserLogin {

    @Autowired
    private RedisService redisService;

    @Autowired
    private RecordLogService recordLogService;

    @Autowired
    private RemoteUserService remoteUserService;

    @Autowired
    private PasswordService passwordService;

    /**
     * 登录
     *
     * @param loginDTO 用户登录信息
     * @return
     */
    @Override
    public LoginUser login(LoginDTO loginDTO) {

        //获取用户名及密码
        String username =  loginDTO.getUsername();
        String password = loginDTO.getPassword();

        // 用户名或密码为空 错误
        if (StringUtils.isAnyBlank(username, password)) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "用户/密码必须填写");
            throw new ServiceException("用户/密码必须填写");
        }
        // 密码如果不在指定范围内 错误
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "用户密码不在指定范围");
            throw new ServiceException("用户密码不在指定范围");
        }
        // 用户名不在指定范围内 错误
        if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "用户名不在指定范围");
            throw new ServiceException("用户名不在指定范围");
        }

        // IP黑名单校验
        String blackStr = Convert.toStr(redisService.getCacheObject(CacheConstants.SYS_LOGIN_BLACKIPLIST));
        if (IpUtils.isMatchedIp(blackStr, IpUtils.getIp())) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "很遗憾，访问IP已被列入系统黑名单");
            throw new ServiceException("很遗憾，访问IP已被列入系统黑名单");
        }

        // 查询用户信息
        Result<LoginUser> userResult = remoteUserService.getUserInfo(username, SecurityConstants.INNER);
        if (StringUtils.isNull(userResult) || StringUtils.isNull(userResult.getData())) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "登录用户不存在");
            throw new ServiceException("登录用户：" + username + " 不存在");
        }

        if (Result.FAIL == userResult.getCode()) {
            throw new ServiceException(userResult.getMsg());
        }

        //得到用户信息
        LoginUser userInfo = userResult.getData();
        SysUser user = userResult.getData().getSysUser();

        // 检查用户状态并记录登录日志
        UserLogin.checkUserStatusAndLogInfo(user, recordLogService);

        //校验密码
        passwordService.validate(user, password);
        //记录日志
        recordLogService.recordLogininfor(username, Constants.LOGIN_SUCCESS, "登录成功");

        return userInfo;
    }

}
