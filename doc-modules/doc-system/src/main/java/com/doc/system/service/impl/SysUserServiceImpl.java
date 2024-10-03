package com.doc.system.service.impl;

import com.doc.common.core.constant.*;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.exception.captcha.CaptchaException;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.utils.bean.BeanValidators;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.redis.service.RedisService;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.mapper.*;
import com.doc.system.pojo.dto.BindEmailDTO;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.service.ISysUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.validation.Validator;
import java.util.List;

/**
 * 用户 业务层处理
 * 
 * @author shiliuyinzhen
 */
@Service
public class SysUserServiceImpl implements ISysUserService {

    private static final Logger log = LoggerFactory.getLogger(SysUserServiceImpl.class);

    @Autowired
    private SysUserMapper userMapper;

    @Autowired
    protected Validator validator;

    @Autowired
    private RedisService redisService;

    /**
     * 根据条件分页查询用户列表
     * 
     * @param user 用户信息
     * @return 用户信息集合信息
     */
    @Override
    public List<SysUser> selectUserList(SysUser user) {
        return userMapper.selectUserList(user);
    }

    /**
     * 通过用户名查询用户
     * 
     * @param userName 用户名
     * @return 用户对象信息
     */
    @Override
    public SysUser selectUserByUserName(String userName) {
        return userMapper.selectUserByUserName(userName);
    }

    /**
     * 通过用户ID查询用户
     * 
     * @param userId 用户ID
     * @return 用户对象信息
     */
    @Override
    public SysUser selectUserById(Long userId) {
        return userMapper.selectUserById(userId);
    }

    /**
     * 校验用户名称是否唯一
     * 
     * @param user 用户信息
     * @return 结果
     */
    @Override
    public boolean checkUserNameUnique(SysUser user) {
        Long userId = StringUtils.isNull(user.getUserId()) ? -1L : user.getUserId();
        SysUser info = userMapper.checkUserNameUnique(user.getUsername());
        if (StringUtils.isNotNull(info) && info.getUserId().longValue() != userId.longValue()) {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * 校验手机号码是否唯一
     *
     * @param user 用户信息
     * @return
     */
    @Override
    public boolean checkPhoneUnique(SysUser user) {
        Long userId = StringUtils.isNull(user.getUserId()) ? -1L : user.getUserId();
        SysUser info = userMapper.checkPhoneUnique(user.getPhone());
        if (StringUtils.isNotNull(info) && info.getUserId().longValue() != userId.longValue()) {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * 校验email是否唯一
     *
     * @param user 用户信息
     * @return
     */
    @Override
    public boolean checkEmailUnique(SysUser user) {
        Long userId = StringUtils.isNull(user.getUserId()) ? -1L : user.getUserId();
        SysUser info = userMapper.checkEmailUnique(user.getEmail());
        if (StringUtils.isNotNull(info) && info.getUserId().longValue() != userId.longValue()) {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    /**
     * 校验用户是否允许操作
     * 
     * @param user 用户信息
     */
    @Override
    public void checkUserAllowed(SysUser user) {
        if (StringUtils.isNotNull(user.getUserId()) && user.isAdmin()) {
            throw new ServiceException("不允许操作超级管理员用户");
        }
    }

    /**
     * 新增保存用户信息
     * 
     * @param sysUser 用户信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertUser(SysUser sysUser) {
        // 新增用户信息
        int row = userMapper.insertUser(sysUser);
        return row;
    }

    /**
     * 注册用户信息
     * 
     * @param sysUser 用户信息
     * @return 结果
     */
    @Override
    public boolean registerUser(SysUser sysUser) {
        return userMapper.insertUser(sysUser) > 0;
    }

    /**
     * 修改保存用户信息
     * 
     * @param user 用户信息
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateUser(SysUser user) {
        Long userId = user.getUserId();
        return userMapper.updateUser(user);
    }

    /**
     * 修改用户状态
     * 
     * @param user 用户信息
     * @return 结果
     */
    @Override
    public int updateUserStatus(SysUser user) {
        return userMapper.updateUser(user);
    }

    /**
     * 修改用户基本信息
     * 
     * @param user 用户信息
     * @return 结果
     */
    @Override
    public int updateUserProfile(SysUser user) {
        return userMapper.updateUser(user);
    }

    /**
     * 修改用户头像
     * 
     * @param userName 用户名
     * @param avatar 头像地址
     * @return 结果
     */
    @Override
    public boolean updateUserAvatar(String userName, String avatar) {
        return userMapper.updateUserAvatar(userName, avatar) > 0;
    }

    /**
     * 重置用户密码
     * 
     * @param user 用户信息
     * @return 结果
     */
    @Override
    public int resetPwd(SysUser user) {
        return userMapper.updateUser(user);
    }

    /**
     * 重置用户密码
     * 
     * @param userName 用户名
     * @param password 密码
     * @return 结果
     */
    @Override
    public int resetUserPwd(String userName, String password) {
        return userMapper.resetUserPwd(userName, password);
    }

    /**
     * 通过用户ID删除用户
     * 
     * @param userId 用户ID
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteUserById(Long userId) {
        return userMapper.deleteUserById(userId);
    }

    /**
     * 批量删除用户信息
     * 
     * @param userIds 需要删除的用户ID
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteUserByIds(Long[] userIds) {
        for (Long userId : userIds) {
            checkUserAllowed(new SysUser(userId));
        }
        return userMapper.deleteUserByIds(userIds);
    }

    /**
     * 导入用户数据
     * 
     * @param userList 用户数据列表
     * @param isUpdateSupport 是否更新支持，如果已存在，则进行更新数据
     * @param operName 操作用户
     * @return 结果
     */
    @Override
    public String importUser(List<SysUser> userList, Boolean isUpdateSupport, String operName) {
        if (StringUtils.isNull(userList) || userList.size() == 0) {
            throw new ServiceException("导入用户数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        //默认密码
        String password = PasswordConstant.DEFAULT_PASSWORD;
        for (SysUser user : userList) {
            try {
                // 验证是否存在这个用户
                SysUser u = userMapper.selectUserByUserName(user.getUsername());
                if (StringUtils.isNull(u)) {
                    BeanValidators.validateWithException(validator, user);
                    user.setPassword(SecurityUtils.encryptPassword(password));
                    user.setCreateBy(operName);
                    userMapper.insertUser(user);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、账号 " + user.getUsername() + " 导入成功");
                } else if (isUpdateSupport) {
                    BeanValidators.validateWithException(validator, user);
                    checkUserAllowed(u);
                    user.setUserId(u.getUserId());
                    user.setUpdateBy(operName);
                    userMapper.updateUser(user);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、账号 " + user.getUsername() + " 更新成功");
                } else {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、账号 " + user.getUsername() + " 已存在");
                }
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + failureNum + "、账号 " + user.getUsername() + " 导入失败：";
                failureMsg.append(msg + e.getMessage());
                log.error(msg, e);
            }
        }
        if (failureNum > 0) {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        } else {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }
        return successMsg.toString();
    }

    /**
     * 根据邮箱获取用户信息
     * @param email
     * @return
     */
    @Override
    public SysUser getUserByEmail(String email) {
        return userMapper.getUserByEmail(email);
    }

    /**
     * 绑定邮箱
     * @param bindEmailDTO
     * @return
     */
    @Override
    public AjaxResult bindEmail(BindEmailDTO bindEmailDTO) {
        String email = bindEmailDTO.getEmail();
        String emailCode = bindEmailDTO.getEmailCode();
        //如果是邮箱和验证码登录
        if (email == null || email == ""){
            throw new ServiceException("邮箱不能为空");
        }
        //校验验证码
        if (StringUtils.isEmpty(emailCode)) {
            throw new CaptchaException("验证码不能为空");
        }
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + email;
        String captcha = redisService.getCacheObject(verifyKey);

        if (captcha == null || captcha == "") {
            throw new CaptchaException("验证码已失效");
        }
        if (!emailCode.equals(captcha)) {
            throw new CaptchaException("验证码错误");
        }
        //查询用户信息
        SysUser user = userMapper.getUserByEmail(email);
        if (user != null) {
            throw new ServiceException("邮箱：" + email + " 已被绑定");
        }
        //删除验证码缓存
        redisService.deleteObject(verifyKey);
        //更新用户信息
        Long userId = SecurityUtils.getUserId();
        return userMapper.updateUserEmail(userId,email) > 0 ?
                AjaxResult.success("绑定成功") : AjaxResult.error("绑定失败");
    }

}
