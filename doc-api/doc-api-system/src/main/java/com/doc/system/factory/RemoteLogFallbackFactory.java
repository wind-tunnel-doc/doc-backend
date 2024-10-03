package com.doc.system.factory;

import com.doc.common.core.result.Result;
import com.doc.system.pojo.entity.SysLogininfor;
import com.doc.system.pojo.entity.SysOperLog;
import com.doc.system.service.RemoteLogService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

/**
 * 日志服务降级处理
 * 
 * @author shiliuyinzhen
 */
@Component
public class RemoteLogFallbackFactory implements FallbackFactory<RemoteLogService> {

    private static final Logger log = LoggerFactory.getLogger(RemoteLogFallbackFactory.class);

    @Override
    public RemoteLogService create(Throwable throwable) {
        log.error("日志服务调用失败:{}", throwable.getMessage());
        return new RemoteLogService() {
            @Override
            public Result<Boolean> saveLog(SysOperLog sysOperLog, String source) {
                return Result.fail("保存操作日志失败:" + throwable.getMessage());
            }

            @Override
            public Result<Boolean> saveLogininfor(SysLogininfor sysLogininfor, String source) {
                return Result.fail("保存登录日志失败:" + throwable.getMessage());
            }
        };

    }
}
