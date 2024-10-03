package com.doc.system.service;

import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.constant.ServiceNameConstants;
import com.doc.common.core.result.Result;
import com.doc.system.factory.RemoteLogFallbackFactory;
import com.doc.system.pojo.entity.SysLogininfor;
import com.doc.system.pojo.entity.SysOperLog;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

/**
 * 日志服务
 * 
 * @author shiliuyinzhen
 */
@FeignClient(contextId = "remoteLogService", value = ServiceNameConstants.SYSTEM_SERVICE, fallbackFactory = RemoteLogFallbackFactory.class)
public interface RemoteLogService {

    /**
     * 保存系统日志
     *
     * @param sysOperLog 日志实体
     * @param source 请求来源
     * @return 结果
     */
    @PostMapping("/operlog")
    public Result<Boolean> saveLog(@RequestBody SysOperLog sysOperLog, @RequestHeader(SecurityConstants.FROM_SOURCE) String source) throws Exception;

    /**
     * 保存访问记录
     *
     * @param sysLogininfor 访问实体
     * @param source 请求来源
     * @return 结果
     */
    @PostMapping("/logininfor")
    public Result<Boolean> saveLogininfor(@RequestBody SysLogininfor sysLogininfor, @RequestHeader(SecurityConstants.FROM_SOURCE) String source);
}
