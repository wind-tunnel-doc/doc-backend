package com.doc.auth.controller;

import com.doc.auth.utils.EmailUtil;
import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.constant.Constants;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.redis.service.RedisService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 邮件 控制层
 * @author shiliuyinzhen
 */
@RestController
@RequestMapping("/email")
@Api(tags = "邮件相关接口")
public class EmailController {

    @Resource
    private EmailUtil emailUtil;

    @Resource
    private RedisService redisService;

    /**
     * 发送验证码
     * @param map
     * @return
     */
    @PostMapping("/code")
    @ApiOperation("发送验证码")
    public AjaxResult sendMailTest(@RequestBody Map<String,String> map) {
        String email = map.get("email");
        if (email == null || email == ""){
            throw new ServiceException("邮箱不能为空");
        }
        //生成6位随机数字验证码
        String code = emailUtil.generateVerificationCode(6);
        //邮件主题
        String subject = "验证码";
        //邮件内容
        String content = "【风洞】验证码：" + code;
        content += "\n用于用户邮箱身份认证，5分钟内有效，请勿泄漏或转发。";
        content += "如非本人操作，请忽略此邮件。";
        //缓存验证码
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + email;
        //放入缓存中
        redisService.setCacheObject(verifyKey, code, Constants.CAPTCHA_EXPIRATION, TimeUnit.MINUTES);
        //发送邮件
        emailUtil.sendSimpleMail(subject, content, email);
        return AjaxResult.success("验证码发送成功");
    }

}

