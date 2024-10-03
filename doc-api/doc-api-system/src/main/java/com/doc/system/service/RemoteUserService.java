package com.doc.system.service;

import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.constant.ServiceNameConstants;
import com.doc.common.core.result.Result;
import com.doc.system.factory.RemoteUserFallbackFactory;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 用户服务
 * 
 * @author shiliuyinzhen
 */
@FeignClient(contextId = "remoteUserService", value = ServiceNameConstants.SYSTEM_SERVICE, fallbackFactory = RemoteUserFallbackFactory.class)
public interface RemoteUserService {

    /**
     * 通过用户名查询用户信息
     *
     * @param username 用户名
     * @param source 请求来源
     * @return 结果
     */
    @GetMapping("/user/info/{username}")
    Result<LoginUser> getUserInfo(@PathVariable("username") String username, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    /**
     * 注册用户信息
     *
     * @param sysUser 用户信息
     * @param source 请求来源
     * @return 结果
     */
    @PostMapping("/user/register")
    Result<Boolean> registerUserInfo(@RequestBody SysUser sysUser, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    /**
     * 修改用户登录信息
     * @param sysUser
     * @param source
     */
    @PostMapping("/user/updateLoginInfo")
    Result<Boolean> updateUserLoginInfo(@RequestBody SysUser sysUser, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);

    /**
     * 根据邮箱获取用户信息
     * @param email
     * @param source
     * @return
     */
    @GetMapping("/user/getUserByEmail")
    Result<LoginUser> getUserInfoByEmail(@RequestParam("email") String email, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);
}
