package com.doc.auth.strategy;

import com.doc.auth.service.RecordLogService;
import com.doc.common.core.constant.Constants;
import com.doc.common.core.enums.UserStatus;
import com.doc.common.core.exception.ServiceException;
import com.doc.system.pojo.dto.LoginDTO;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUser;

/**
 * 用户登录
 * @author shiliuyinzhen
 */
public interface UserLogin {

    /**
     * 登录
     *
     * @param loginDTO 用户登录信息
     * @return
     */
    LoginUser login(LoginDTO loginDTO);

    /**
     * 检查用户状态并记录登录日志
     * @param user 用户信息
     * @param recordLogService 记录日志服务
     */
    static void checkUserStatusAndLogInfo(SysUser user, RecordLogService recordLogService) {
        String username = user.getUsername();
        if (UserStatus.DELETED.getCode().equals(user.getDelFlag())) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "对不起，您的账号已被删除");
            throw new ServiceException("对不起，您的账号：" + username + " 已被删除");
        }

        if (UserStatus.DISABLE.getCode().equals(user.getStatus())) {
            recordLogService.recordLogininfor(username, Constants.LOGIN_FAIL, "用户已停用，请联系管理员");
            throw new ServiceException("对不起，您的账号：" + username + " 已停用");
        }
        //记录日志
        recordLogService.recordLogininfor(username, Constants.LOGIN_SUCCESS, "登录成功");
    }
}
