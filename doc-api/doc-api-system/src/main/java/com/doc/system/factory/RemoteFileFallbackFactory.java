package com.doc.system.factory;

import com.doc.common.core.result.Result;
import com.doc.system.pojo.entity.SysFile;
import com.doc.system.service.RemoteFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件服务降级处理
 * 
 * @author shiliuyinzhen
 */
@Component
public class RemoteFileFallbackFactory implements FallbackFactory<RemoteFileService> {

    private static final Logger log = LoggerFactory.getLogger(RemoteFileFallbackFactory.class);

    @Override
    public RemoteFileService create(Throwable throwable) {
        log.error("文件服务调用失败:{}", throwable.getMessage());
        return new RemoteFileService() {
            @Override
            public Result<SysFile> upload(MultipartFile file) {
                return Result.fail("上传文件失败:" + throwable.getMessage());
            }
        };
    }
}
