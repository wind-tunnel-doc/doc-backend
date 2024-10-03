package com.doc.auth.utils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Random;

/**
 * 邮件 工具类
 * @author shiliuyinzhen
 */
@Component
public class EmailUtil {

    /** 发件人邮箱 */
    @Value("${spring.mail.username}")
    private String from;

    /** 发送邮件服务 */
    @Resource
    private JavaMailSender javaMailSender;

    /**
     * 发送简单文本邮件
     * @param subject 主题
     * @param content 内容
     * @param to      收件人列表
     * @author shiliuyinzhen
     */
    public void sendSimpleMail(String subject, String content, String... to) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(from);
        message.setSubject(subject);
        message.setText(content);
        message.setTo(to);
        javaMailSender.send(message);
    }

    /**
     * 生成指定长度的验证码
     * @param codeLength
     * @return
     */
    public String generateVerificationCode(int codeLength) {
        // 定义验证码字符集
        String codeChars = "0123456789";
        // 使用StringBuilder来拼接验证码
        StringBuilder verificationCode = new StringBuilder();
        // 创建Random对象
        Random random = new Random();
        // 循环生成指定长度的验证码
        for (int i = 0; i < codeLength; i++) {
            // 从字符集中随机选择一个字符
            char randomChar = codeChars.charAt(random.nextInt(codeChars.length()));
            // 将选定的字符追加到验证码中
            verificationCode.append(randomChar);
        }
        // 返回生成的验证码字符串
        return verificationCode.toString();
    }

}
