package com.doc.system.service;

import com.doc.common.core.constant.ServiceNameConstants;
import com.doc.common.core.result.Result;
import com.doc.system.factory.RemoteFileFallbackFactory;
import com.doc.system.pojo.entity.SysFile;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件服务
 * 
 * @author shiliuyinzhen
 */
@FeignClient(contextId = "remoteFileService", value = ServiceNameConstants.FILE_SERVICE, fallbackFactory = RemoteFileFallbackFactory.class)
@Api(tags = "文件服务")
public interface RemoteFileService {

    /**
     * 上传文件
     *
     * @param file 文件信息
     * @return 结果
     */
    @ApiOperation("上传文件")
    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<SysFile> upload(@RequestPart(value = "file") MultipartFile file);

}
