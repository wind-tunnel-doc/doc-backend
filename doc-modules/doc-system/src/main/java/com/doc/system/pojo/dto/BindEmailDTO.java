package com.doc.system.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 绑定邮箱
 * @author shiliuyinzhen
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BindEmailDTO {

    /** 邮箱 */
    private String email;

    /** 邮箱验证码 */
    private String emailCode;

}
