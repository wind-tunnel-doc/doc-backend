package com.doc.system.pojo.entity;

import com.doc.system.pojo.entity.SysUser;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 用户信息
 *
 * @author shiliuyinzhen
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LoginUser implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 用户唯一标识
     */
    private String token;

    /**
     * 用户名id
     */
    private Long userId;

    /**
     * 用户名
     */
    private String username;

    /**
     * 登录时间
     */
    private Long loginTime;

    /**
     * 过期时间
     */
    private Long expireTime;

    /**
     * 登录IP地址
     */
    private String loginIp;

    /**
     * 用户信息
     */
    private SysUser sysUser;
}
