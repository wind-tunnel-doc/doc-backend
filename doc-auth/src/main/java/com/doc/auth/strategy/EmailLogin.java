package com.doc.auth.strategy;

import com.doc.auth.service.LoginService;
import com.doc.auth.service.RecordLogService;
import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.constant.Constants;
import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.exception.captcha.CaptchaException;
import com.doc.common.core.result.Result;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.redis.service.RedisService;
import com.doc.system.pojo.dto.LoginDTO;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.RemoteUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 邮箱验证码登录
 * @author shiliuyinzhen
 */
@Component
public class EmailLogin implements UserLogin {

    @Autowired
    private RedisService redisService;

    @Autowired
    private RecordLogService recordLogService;

    @Autowired
    private RemoteUserService remoteUserService;

    /**
     * 登录
     *
     * @param loginDTO 用户登录信息
     * @return
     */
    @Override
    public LoginUser login(LoginDTO loginDTO) {
        //获取邮箱和验证码
        String email = loginDTO.getEmail();
        String emailCode = loginDTO.getEmailCode();

        //如果是邮箱和验证码登录
        if (email == null || email == ""){
            throw new ServiceException("邮箱不能为空");
        }
        //校验验证码
        if (StringUtils.isEmpty(emailCode)) {
            throw new CaptchaException("验证码不能为空");
        }

        //从缓存中获取邮箱验证码
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + email;
        String captcha = redisService.getCacheObject(verifyKey);

        if (captcha == null || captcha == "") {
            throw new CaptchaException("验证码已失效");
        }

        if (!emailCode.equals(captcha)) {
            throw new CaptchaException("验证码错误");
        }

        //查询用户信息
        Result<LoginUser> userResult = remoteUserService.getUserInfoByEmail(email, SecurityConstants.INNER);
        if (StringUtils.isNull(userResult) || StringUtils.isNull(userResult.getData())) {
            recordLogService.recordLogininfor(email, Constants.LOGIN_FAIL, "登录邮箱不存在");
            throw new ServiceException("登录邮箱：" + email + " 不存在");
        }
        if (Result.FAIL == userResult.getCode()) {
            throw new ServiceException(userResult.getMsg());
        }

        //得到用户信息
        LoginUser userInfo = userResult.getData();
        SysUser user = userResult.getData().getSysUser();
        String username = user.getUsername();

        //检查用户状态并记录登录日志
        UserLogin.checkUserStatusAndLogInfo(user, recordLogService);

        //删除缓存中的验证码
        redisService.deleteObject(verifyKey);

        return userInfo;
    }


}
