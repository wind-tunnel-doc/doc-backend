package com.doc.system.controller;

import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.result.Result;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.utils.poi.ExcelUtil;
import com.doc.common.core.web.controller.BaseController;
import com.doc.common.core.web.page.TableDataInfo;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.log.annotation.Log;
import com.doc.common.log.enums.BusinessType;
import com.doc.common.security.annotation.InnerAuth;
import com.doc.common.security.annotation.RequiresLogin;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.*;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 用户信息
 * 
 * @author shiliuyinzhen
 */
@RestController
@RequestMapping("/user")
@Api(tags = "用户相关接口")
public class SysUserController extends BaseController {

    @Resource
    private ISysUserService userService;

    /**
     * 获取用户列表
     */
    @GetMapping("/list")
    @ApiOperation("获取用户列表")
    public TableDataInfo list(SysUser user) {
        startPage();
        List<SysUser> list = userService.selectUserList(user);
        return getDataTable(list);
    }

    @Log(title = "用户管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysUser user) {
        List<SysUser> list = userService.selectUserList(user);
        ExcelUtil<SysUser> util = new ExcelUtil<SysUser>(SysUser.class);
        util.exportExcel(response, list, "用户数据");
    }

    @Log(title = "用户管理", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception {
        ExcelUtil<SysUser> util = new ExcelUtil<SysUser>(SysUser.class);
        List<SysUser> userList = util.importExcel(file.getInputStream());
        String operName = SecurityUtils.getUsername();
        String message = userService.importUser(userList, updateSupport, operName);
        return success(message);
    }

    /**
     *
     * @param response
     * @throws IOException
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) throws IOException {
        ExcelUtil<SysUser> util = new ExcelUtil<SysUser>(SysUser.class);
        util.importTemplateExcel(response, "用户数据");
    }

    /**
     * 获取当前用户信息
     */
    @InnerAuth
    @GetMapping("/info/{username}")
    @ApiOperation("获取当前用户信息(内部访问)")
    public Result<LoginUser> info(@PathVariable("username") String username) {
        SysUser sysUser = userService.selectUserByUserName(username);
        if (StringUtils.isNull(sysUser)) {
            return Result.fail("用户名或密码错误");
        }
        LoginUser sysUserVo = new LoginUser();
        sysUserVo.setSysUser(sysUser);
        return Result.success(sysUserVo);
    }

    /**
     * 注册用户信息
     */
    @InnerAuth
    @PostMapping("/register")
    @ApiOperation("注册用户信息(内部访问)")
    public Result<Boolean> register(@RequestBody SysUser user) {
        String username = user.getUsername();
//        if (!("true".equals(configService.selectConfigByKey("sys.account.registerUser")))) {
//            return Result.fail("当前系统没有开启注册功能！");
//        }
        if (!userService.checkUserNameUnique(user)) {
            return Result.fail("保存用户'" + username + "'失败，注册账号已存在");
        }
        user.setCreateBy(SecurityUtils.getUsername());
        user.setUpdateBy(SecurityUtils.getUsername());
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        return Result.success(userService.registerUser(user));
    }

    /**
     * 获取用户信息
     * 
     * @return 用户信息
     */
    @GetMapping("/getInfo")
    @ApiOperation("获取用户信息")
    public AjaxResult getInfo() {
        SysUser user = userService.selectUserById(SecurityUtils.getUserId());
        AjaxResult ajax = AjaxResult.success();
        ajax.put("user", user);
        return ajax;
    }

    /**
     * 根据用户编号获取详细信息
     */
    @GetMapping(value = { "/", "/{userId}" })
    @ApiOperation("根据用户编号获取详细信息")
    public AjaxResult getInfo(@PathVariable(value = "userId", required = false) Long userId) {

        AjaxResult ajax = AjaxResult.success();
        if (StringUtils.isNotNull(userId)) {
            SysUser sysUser = userService.selectUserById(userId);
            ajax.put(AjaxResult.DATA_TAG, sysUser);
        }
        return ajax;
    }

    /**
     * 新增用户
     */
    @Log(title = "用户管理", businessType = BusinessType.INSERT)
    @PostMapping
    @ApiOperation("新增用户")
    public AjaxResult add(@Validated @RequestBody SysUser user) {
        if (!userService.checkUserNameUnique(user)) {
            return error("新增用户'" + user.getUsername() + "'失败，登录账号已存在");
        } else if (StringUtils.isNotEmpty(user.getPhone()) && !userService.checkPhoneUnique(user)) {
            return error("新增用户'" + user.getUsername() + "'失败，手机号码已存在");
        } else if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user)) {
            return error("新增用户'" + user.getUsername() + "'失败，邮箱账号已存在");
        }
        user.setCreateBy(SecurityUtils.getUsername());
        user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        user.setUpdateBy(SecurityUtils.getUsername());
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        return toAjax(userService.insertUser(user));
    }

    /**
     * 修改用户
     * @param user
     * @return
     */
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    @PutMapping
    @ApiOperation("修改用户")
    public AjaxResult edit(@Validated @RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        if (!userService.checkUserNameUnique(user)) {
            return error("修改用户'" + user.getUsername() + "'失败，登录账号已存在");
        } else if (StringUtils.isNotEmpty(user.getPhone()) && !userService.checkPhoneUnique(user)) {
            return error("修改用户'" + user.getUsername() + "'失败，手机号码已存在");
        }
        else if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user)) {
            return error("修改用户'" + user.getUsername() + "'失败，邮箱账号已存在");
        }
        user.setUpdateBy(SecurityUtils.getUsername());
        user.setUpdateTime(LocalDateTime.now());
        return toAjax(userService.updateUser(user));
    }

    /**
     * 删除用户
     */
    @Log(title = "用户管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{userIds}")
    @ApiOperation("删除用户")
    public AjaxResult remove(@PathVariable Long[] userIds) {
        if (ArrayUtils.contains(userIds, SecurityUtils.getUserId())) {
            return error("当前用户不能删除");
        }
        return toAjax(userService.deleteUserByIds(userIds));
    }

    /**
     * 重置密码
     */
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    @PutMapping("/resetPwd")
    @ApiOperation("重置密码")
    public AjaxResult resetPwd(@RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        user.setUpdateBy(SecurityUtils.getUsername());
        user.setUpdateTime(LocalDateTime.now());
        return toAjax(userService.resetPwd(user));
    }

    /**
     * 状态修改
     * @param user
     * @return
     */
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    @ApiOperation("状态修改")
    public AjaxResult changeStatus(@RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        user.setUpdateBy(SecurityUtils.getUsername());
        user.setUpdateTime(LocalDateTime.now());
        return toAjax(userService.updateUserStatus(user));
    }

    /**
     * 修改用户登录信息
     * @param user
     */
    @InnerAuth
    @PostMapping("/updateLoginInfo")
    @ApiOperation("修改用户登录信息(内部访问)")
    public Result<Boolean> updateLoginInfo(@RequestBody SysUser user){
        return Result.success(userService.updateUser(user) > 0);
    }

    /**
     * 校验密码
     * @param map
     * @return
     */
    private SysUser checkPassword(Map<String, String> map) {
        String password = map.get("password");
        Long userId = SecurityUtils.getUserId();
        SysUser sysUser = userService.selectUserById(userId);
        //如果密码为空
        if (StringUtils.isEmpty(password)){
            throw new ServiceException("密码不能为空");
        }
        //如果密码错误
        if (!SecurityUtils.matchesPassword(password,sysUser.getPassword())){
            throw new ServiceException("密码错误");
        }
        return sysUser;
    }

    /**
     * 设置用户支付密码
     * @param map
     * @return
     */
    @RequiresLogin
    @PostMapping("/pay/password")
    @Log(title = "用户服务",businessType = BusinessType.INSERT)
    @ApiOperation("设置用户支付密码")
    public AjaxResult setPayPassword(@RequestBody Map<String,String> map){
        SysUser sysUser = checkPassword(map);
        userService.checkUserAllowed(sysUser);
        //如果支付密码不为空
        if (StringUtils.isNotEmpty(sysUser.getPayPassword())){
            throw new ServiceException("支付密码已经存在");
        }
        String payPassword = map.get("payPassword");
        if (StringUtils.isEmpty(payPassword)){
            throw new ServiceException("支付密码不能为空");
        }
        sysUser.setPayPassword(SecurityUtils.encryptPassword(payPassword));
        return toAjax(userService.updateUser(sysUser));
    }

    /**
     * 修改支付密码
     * @param map
     * @return
     */
    @PutMapping("/pay/password")
    @Log(title = "用户支付密码",businessType = BusinessType.UPDATE)
    @ApiOperation("修改支付密码")
    public AjaxResult updatePayPassword(@RequestBody Map<String,String> map){
        SysUser sysUser = checkPassword(map);
        String oldPayPassword = sysUser.getPayPassword();
        String newPayPassword = map.get("payPassword");
        if (StringUtils.isEmpty(newPayPassword)){
            throw new ServiceException("支付密码不能为空");
        }
        //如果和旧支付密码相同
        if (SecurityUtils.matchesPassword(newPayPassword,oldPayPassword)){
            throw new ServiceException("不能和旧支付密码相同");
        }
        //更新支付密码
        sysUser.setPayPassword(SecurityUtils.encryptPassword(newPayPassword));
        return toAjax(userService.updateUser(sysUser));
    }

    /**
     * 根据邮箱获取用户信息(内部访问)
     * @param email
     * @return
     */
    @InnerAuth
    @GetMapping("/getUserByEmail")
    @ApiOperation("根据邮箱获取用户信息(内部访问)")
    Result<LoginUser> getUserByEmail(@RequestParam("email")String email){
        SysUser sysUser = userService.getUserByEmail(email);
        if (StringUtils.isNull(sysUser)) {
            return Result.fail("邮箱不存在");
        }
        LoginUser sysUserVo = new LoginUser();
        sysUserVo.setSysUser(sysUser);
        return Result.success(sysUserVo);
    }
}
