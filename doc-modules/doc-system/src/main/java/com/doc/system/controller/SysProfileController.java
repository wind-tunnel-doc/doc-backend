package com.doc.system.controller;

import com.doc.common.core.result.Result;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.utils.file.FileTypeUtils;
import com.doc.common.core.utils.file.MimeTypeUtils;
import com.doc.common.core.web.controller.BaseController;
import com.doc.common.core.web.page.TableDataInfo;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.log.annotation.Log;
import com.doc.common.log.enums.BusinessType;
import com.doc.common.security.annotation.RequiresLogin;
import com.doc.common.security.service.TokenService;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.dto.BindEmailDTO;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysFile;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.ISysUserService;
import com.doc.system.service.RemoteFileService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 个人信息 业务处理
 * 
 * @author shiuyinzhen
 */
@RestController
@RequestMapping("/user/profile")
@Api(tags = "个人信息相关接口")
public class SysProfileController extends BaseController {

    @Resource
    private ISysUserService userService;

    @Resource
    private TokenService tokenService;

    @Resource
    private RemoteFileService remoteFileService;

    /**
     * 获取个人信息
     * @return
     */
    @GetMapping
    @ApiOperation("获取个人信息")
    public AjaxResult profile() {
        String username = SecurityUtils.getUsername();
        SysUser user = userService.selectUserByUserName(username);
        user.setPassword("******");
        user.setPayPassword("******");
        AjaxResult ajax = AjaxResult.success(user);
        return ajax;
    }

    /**
     * 修改个人信息
     * @param user
     * @return
     */
    @Log(title = "个人信息", businessType = BusinessType.UPDATE)
    @PutMapping
    @ApiOperation("修改个人信息")
    public AjaxResult updateProfile(@RequestBody SysUser user) {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        SysUser currentUser = loginUser.getSysUser();
        currentUser.setNickName(user.getNickName());
        currentUser.setEmail(user.getEmail());
        currentUser.setPhone(user.getPhone());
        currentUser.setSex(user.getSex());
        currentUser.setQq(user.getQq());
        currentUser.setWx(user.getWx());
        if (StringUtils.isNotEmpty(user.getPhone()) && !userService.checkPhoneUnique(currentUser)) {
            return error("修改用户'" + loginUser.getUsername() + "'失败，手机号码已存在");
        }
        if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(currentUser)) {
            return error("修改用户'" + loginUser.getUsername() + "'失败，邮箱账号已存在");
        }
        if (userService.updateUserProfile(currentUser) > 0) {
            // 更新缓存用户信息
            tokenService.setLoginUser(loginUser);
            return success();
        }
        return error("修改个人信息异常，请联系管理员");
    }

    /**
     * 修改密码
     * @param oldPassword
     * @param newPassword
     * @return
     */
    @Log(title = "个人信息", businessType = BusinessType.UPDATE)
    @PutMapping("/updatePwd")
    @ApiOperation("修改密码")
    public AjaxResult updatePwd(String oldPassword, String newPassword) {
        String username = SecurityUtils.getUsername();
        SysUser user = userService.selectUserByUserName(username);
        String password = user.getPassword();
        if (!SecurityUtils.matchesPassword(oldPassword, password)) {
            return error("修改密码失败，旧密码错误");
        }
        if (SecurityUtils.matchesPassword(newPassword, password)) {
            return error("新密码不能与旧密码相同");
        }
        newPassword = SecurityUtils.encryptPassword(newPassword);
        if (userService.resetUserPwd(username, newPassword) > 0) {
            // 更新缓存用户密码
            LoginUser loginUser = SecurityUtils.getLoginUser();
            loginUser.getSysUser().setPassword(newPassword);
            tokenService.setLoginUser(loginUser);
            return success();
        }
        return error("修改密码异常，请联系管理员");
    }

    /**
     * 头像上传
     * @param file
     * @return
     */
    @Log(title = "用户头像", businessType = BusinessType.UPDATE)
    @PostMapping("/avatar")
    @ApiOperation("头像上传")
    public AjaxResult avatar(@RequestParam("avatarfile") MultipartFile file) {
        if (!file.isEmpty()) {
            LoginUser loginUser = SecurityUtils.getLoginUser();
            String extension = FileTypeUtils.getExtension(file);
            if (!StringUtils.equalsAnyIgnoreCase(extension, MimeTypeUtils.IMAGE_EXTENSION)) {
                return error("文件格式不正确，请上传" + Arrays.toString(MimeTypeUtils.IMAGE_EXTENSION) + "格式");
            }
            Result<SysFile> fileResult = remoteFileService.upload(file);
            if (StringUtils.isNull(fileResult) || StringUtils.isNull(fileResult.getData())) {
                return error("文件服务异常，请联系管理员");
            }
            String url = fileResult.getData().getUrl();
            if (userService.updateUserAvatar(loginUser.getUsername(), url)) {
                AjaxResult ajax = AjaxResult.success();
                ajax.put("imgUrl", url);
                // 更新缓存用户头像
                loginUser.getSysUser().setAvatar(url);
                tokenService.setLoginUser(loginUser);
                return ajax;
            }
        }
        return error("上传图片异常，请联系管理员");
    }

    /**
     * 绑定邮箱
     * @param bindEmailDTO
     * @return
     */
    @RequiresLogin
    @PostMapping("/bindEmail")
    @ApiOperation("绑定邮箱")
    public AjaxResult bindEmail(@RequestBody BindEmailDTO bindEmailDTO){
        return userService.bindEmail(bindEmailDTO);
    }

}
