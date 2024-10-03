package com.doc.auth.service;

import com.doc.common.core.constant.Constants;
import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.utils.ip.IpUtils;
import com.doc.system.pojo.entity.SysLogininfor;
import com.doc.system.service.RemoteLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 记录日志方法
 * 
 * @author shiliuyinzhen
 */
@Component
public class RecordLogService {

    @Autowired
    private RemoteLogService remoteLogService;

    /**
     * 记录登录信息
     * 
     * @param username 用户名
     * @param status 状态
     * @param message 消息内容
     * @return
     */
    public void recordLogininfor(String username, String status, String message) {
        SysLogininfor sysLogininfor = new SysLogininfor();
        sysLogininfor.setUserName(username);
        sysLogininfor.setIpaddr(IpUtils.getIp());
        sysLogininfor.setMsg(message);
        // 日志状态
        if (StringUtils.equalsAny(status, Constants.LOGIN_SUCCESS, Constants.LOGOUT, Constants.REGISTER)) {
            sysLogininfor.setStatus(Constants.LOGIN_SUCCESS_STATUS);
        } else if (Constants.LOGIN_FAIL.equals(status)) {
            sysLogininfor.setStatus(Constants.LOGIN_FAIL_STATUS);
        }
        remoteLogService.saveLogininfor(sysLogininfor, SecurityConstants.INNER);
    }
}
