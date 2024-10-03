package com.doc.system.factory;

import com.doc.common.core.result.Result;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.RemoteUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

/**
 * 用户服务降级处理
 * 
 * @author shiliuyinzhen
 */
@Component
public class RemoteUserFallbackFactory implements FallbackFactory<RemoteUserService> {

    private static final Logger log = LoggerFactory.getLogger(RemoteUserFallbackFactory.class);

    @Override
    public RemoteUserService create(Throwable throwable) {
        log.error("用户服务调用失败:{}", throwable.getMessage());
        return new RemoteUserService() {
            @Override
            public Result<LoginUser> getUserInfo(String username, String source) {
                return Result.fail("获取用户失败:" + throwable.getMessage());
            }

            @Override
            public Result<Boolean> registerUserInfo(SysUser sysUser, String source) {
                return Result.fail("注册用户失败:" + throwable.getMessage());
            }

            @Override
            public Result<Boolean> updateUserLoginInfo(SysUser sysUser, String source){
                return Result.fail("修改用户登录信息失败:" + throwable.getMessage());
            }

            @Override
            public Result<LoginUser> getUserInfoByEmail(String email, String source) {
                return Result.fail("根据邮箱获取用户信息失败:" + throwable.getMessage());
            }
        };
    }
}
