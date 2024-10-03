package com.doc.common.core.exception.captcha;

/**
 * 验证码错误异常类
 * 
 * @author shiliuyinzhen
 */
public class CaptchaException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public CaptchaException(String msg)
    {
        super(msg);
    }
}
