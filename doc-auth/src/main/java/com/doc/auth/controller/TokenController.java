package com.doc.auth.controller;

import com.doc.auth.factory.UserLoginFactory;
import com.doc.auth.service.LoginService;
import com.doc.auth.strategy.UserLogin;
import com.doc.common.core.result.Result;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.utils.jwt.JwtUtils;
import com.doc.common.security.auth.AuthUtil;
import com.doc.common.security.service.TokenService;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.dto.LoginDTO;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * token 控制
 * 
 * @author shiliuyinzhen
 */
@RestController
@Api(tags = "token相关接口")
public class TokenController {

    @Resource
    private TokenService tokenService;

    @Resource
    private LoginService loginService;

    /**
     * 用户登录
     * @param loginDTO
     * @return
     */
    @ApiOperation("用户登录")
    @PostMapping("/login")
    public Result<?> login(@RequestBody LoginDTO loginDTO) {
        //根据不同的登录策略，得到对应的策略对象
        UserLogin userLogin = UserLoginFactory.getUserLogin(loginDTO.getLoginType());
        //用户登录
        LoginUser userInfo = userLogin.login(loginDTO);
        // 获取登录token
        return Result.success(tokenService.createToken(userInfo));
    }

    /**
     * 用户退出
     * @param request
     * @return
     */
    @ApiOperation("用户退出")
    @DeleteMapping("/logout")
    public Result<?> logout(HttpServletRequest request) {
        String token = SecurityUtils.getToken(request);
        if (StringUtils.isNotEmpty(token)) {
            String username = JwtUtils.getUserName(token);
            // 删除用户缓存记录
            AuthUtil.logoutByToken(token);
            // 记录用户退出日志
            loginService.logout(username);
        }
        return Result.success();
    }

    /**
     * 刷新token
     * @param request
     * @return
     */
    @ApiOperation("刷新token")
    @PostMapping("/refresh")
    public Result<Object> refresh(HttpServletRequest request) {
        LoginUser loginUser = tokenService.getLoginUser(request);
        if (StringUtils.isNotNull(loginUser)) {
            // 刷新令牌有效期
            tokenService.refreshToken(loginUser);
            return Result.success();
        }
        return Result.success();
    }

    /**
     * 用户注册
     * @param sysUser
     * @return
     */
    @ApiOperation("用户注册")
    @PostMapping("/register")
    public Result<?> register(@RequestBody SysUser sysUser) {
        // 用户注册
        loginService.register(sysUser);
        return Result.success();
    }
}
