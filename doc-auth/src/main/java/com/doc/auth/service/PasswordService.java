package com.doc.auth.service;

import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.constant.Constants;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.redis.service.RedisService;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.entity.SysUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 登录密码方法
 * 
 * @author shiliuyinzhen
 */
@Component
public class PasswordService {

    @Autowired
    private RedisService redisService;

    private int maxRetryCount = CacheConstants.PASSWORD_MAX_RETRY_COUNT;

    private Long lockTime = CacheConstants.PASSWORD_LOCK_TIME;

    @Autowired
    private RecordLogService recordLogService;

    /**
     * 登录账户密码错误次数缓存键名
     * 
     * @param username 用户名
     * @return 缓存键key
     */
    private String getCacheKey(String username)
    {
        return CacheConstants.PWD_ERR_CNT_KEY + username;
    }

    /**
     * 密码校验
     * @param sysUser
     * @param password
     */
    public void validate(SysUser sysUser, String password) {

        String username = sysUser.getUsername();

        Integer retryCount = redisService.getCacheObject(getCacheKey(username));

        if (retryCount == null) {
            retryCount = 0;
        }

        if (retryCount >= Integer.valueOf(maxRetryCount).intValue()) {
            String errMsg = String.format("密码输入错误%s次，帐户锁定%s分钟", maxRetryCount, lockTime);
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL,errMsg);
            throw new ServiceException(errMsg);
        }

        if (!matches(sysUser, password)) {
            retryCount = retryCount + 1;
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, String.format("密码输入错误%s次", retryCount));
            redisService.setCacheObject(getCacheKey(username), retryCount, lockTime, TimeUnit.MINUTES);
            throw new ServiceException("用户不存在/密码错误");
        } else {
            clearLoginRecordCache(username);
        }
    }

    /**
     * 密码匹配
     * @param sysUser
     * @param rawPassword
     * @return
     */
    public boolean matches(SysUser sysUser, String rawPassword) {
        return SecurityUtils.matchesPassword(rawPassword, sysUser.getPassword());
    }

    /**
     * 清除登录缓存
     * @param loginName
     */
    public void clearLoginRecordCache(String loginName) {
        if (redisService.hasKey(getCacheKey(loginName))) {
            redisService.deleteObject(getCacheKey(loginName));
        }
    }
}
