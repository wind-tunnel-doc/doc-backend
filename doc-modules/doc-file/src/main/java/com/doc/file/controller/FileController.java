package com.doc.file.controller;

import com.doc.common.core.result.Result;
import com.doc.common.core.utils.file.FileUtils;
import com.doc.file.service.FileService;
import com.doc.system.pojo.entity.SysFile;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件请求处理
 * 
 * @author shiliuyinzhen
 */
@RestController
@Api(tags = "文件上传相关接口")
public class FileController {

    private static final Logger log = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private FileService fileService;

    /**
     * 文件上传
     */
    @PostMapping("/upload")
    @ApiOperation("文件上传")
    public Result<SysFile> upload(@RequestBody MultipartFile file) {
        try {
            // 上传并返回访问地址
            String url = fileService.uploadFile(file);
            SysFile sysFile = new SysFile();
            sysFile.setName(FileUtils.getName(url));
            sysFile.setUrl(url);
            return Result.success(sysFile);
        } catch (Exception e) {
            log.error("上传文件失败", e);
            return Result.fail(e.getMessage());
        }
    }
}