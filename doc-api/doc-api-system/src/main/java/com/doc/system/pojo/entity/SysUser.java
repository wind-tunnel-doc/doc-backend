package com.doc.system.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.doc.common.core.annotation.Excel;
import com.doc.common.core.annotation.Excel.ColumnType;
import com.doc.common.core.annotation.Excel.Type;
import com.doc.common.core.web.pojo.BaseEntity;
import com.doc.common.core.xss.Xss;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

/**
 * 用户对象  sys_user
 * 
 * @author shiliuyinzhen
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)//解决redis缓存反序列化未知字段问题
public class SysUser extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 用户ID */
    @Excel(name = "用户序号", cellType = ColumnType.NUMERIC, prompt = "用户编号")
    private Long userId;

    /** 用户账号 */
    @Excel(name = "登录名称")
    private String username;

    /** 用户昵称 */
    @Excel(name = "用户名称")
    private String nickName;

    /** 用户邮箱 */
    @Excel(name = "用户邮箱")
    private String email;

    /** 手机号码 */
    @Excel(name = "手机号码")
    private String phone;

    /** QQ号 */
    @Excel(name = "QQ号")
    private String qq;

    /** 微信 */
    @Excel(name = "微信号")
    private String wx;

    /** 用户性别 */
    @Excel(name = "用户性别")
    private String sex;

    /** 用户头像 */
    private String avatar;

    /** 密码 */
    private String password;

    /** 支付密码 */
    private String payPassword;

    /** 帐号状态（1正常 0停用） */
    @Excel(name = "帐号状态", readConverterExp = "1=正常,0=停用")
    private Integer status;

    /** 删除标志（0代表存在 1代表删除） */
    private Integer delFlag;

    /** 最后登录IP */
    @Excel(name = "最后登录IP", type = Type.EXPORT)
    private String loginIp;

    /** 最后登录时间 */
    @Excel(name = "最后登录时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss", type = Type.EXPORT)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", shape = JsonFormat.Shape.STRING)
    private LocalDateTime loginTime;

    /** 等级 */
    private Integer level;

    /** 积分 */
    private Integer score;

    /** 经验值 */
    private Integer experience;

    /** 余额 */
    private Integer balance;

    /** 角色 */
    private Integer role;

    public SysUser(Long userId)
    {
        this.userId = userId;
    }

    public boolean isAdmin()
    {
        return isAdmin(this.userId);
    }

    public static boolean isAdmin(Long userId)
    {
        return userId != null && 999L == userId;
    }


    @Xss(message = "用户昵称不能包含脚本字符")
    @Size(min = 0, max = 30, message = "用户昵称长度不能超过30个字符")
    public String getNickName() {
        return nickName;
    }

    @Xss(message = "用户账号不能包含脚本字符")
    @NotBlank(message = "用户账号不能为空")
    @Size(min = 0, max = 30, message = "用户账号长度不能超过30个字符")
    public String getUsername() {
        return username;
    }

    @Email(message = "邮箱格式不正确")
    @Size(min = 0, max = 50, message = "邮箱长度不能超过50个字符")
    public String getEmail() {
        return email;
    }

    @Size(min = 0, max = 11, message = "手机号码长度不能超过11个字符")
    public String getPhone() {
        return phone;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("userId", getUserId())
                .append("username", getUsername())
                .append("nickName", getNickName())
                .append("email", getEmail())
                .append("phone", getPhone())
                .append("qq", getQq())
                .append("wx", getWx())
                .append("sex", getSex())
                .append("avatar", getAvatar())
                .append("password", getPassword())
                .append("status", getStatus())
                .append("delFlag", getDelFlag())
                .append("loginIp", getLoginIp())
                .append("loginTime", getLoginTime())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .append("level", getLevel())
                .append("score", getScore())
                .append("experience", getExperience())
                .append("balance", getBalance())
                .append("role", getRole())
                .toString();
    }
}
