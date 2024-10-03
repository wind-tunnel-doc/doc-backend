package com.doc.system.pojo.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * 登录时传递的数据对象
 *
 * @author shiliuyinzhen
 */
@Data
@ApiModel(description = "登录时传递的数据对象")
public class LoginDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户名 */
    @ApiModelProperty("用户名")
    private String username;

    /** 密码 */
    @ApiModelProperty("密码")
    private String password;

    /** 邮箱 */
    @ApiModelProperty("邮箱")
    private String email;

    /** 邮箱验证码 */
    @ApiModelProperty("邮箱验证码")
    private String emailCode;

    /** 登录类型 */
    @ApiModelProperty("登录类型")
    private String loginType;

}
