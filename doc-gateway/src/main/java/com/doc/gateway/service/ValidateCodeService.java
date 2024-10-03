package com.doc.gateway.service;

import com.doc.common.core.exception.captcha.CaptchaException;
import com.doc.common.core.web.pojo.AjaxResult;

import java.io.IOException;

/**
 * 验证码处理
 *
 * @author shiliuyinzhen
 */
public interface ValidateCodeService {

    /**
     * 生成验证码
     */
    public AjaxResult createCaptcha() throws IOException, CaptchaException;

    /**
     * 校验验证码
     */
    public void checkCaptcha(String key, String value) throws CaptchaException;
}
