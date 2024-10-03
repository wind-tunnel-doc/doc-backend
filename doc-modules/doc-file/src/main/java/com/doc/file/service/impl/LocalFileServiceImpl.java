package com.doc.file.service.impl;

import com.doc.file.config.LocalFileConfig;
import com.doc.file.service.FileService;
import com.doc.file.utils.FileUploadUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * 本地文件存储
 * 
 * @author shiliuyinzhen
 */
//@Primary
@Service
public class LocalFileServiceImpl implements FileService {

    @Autowired
    private LocalFileConfig localFileConfig;

    /**
     * 本地文件上传接口
     * 
     * @param file 上传的文件
     * @return 访问地址
     * @throws Exception
     */
    @Override
    public String uploadFile(MultipartFile file) throws Exception {
        String name = FileUploadUtils.upload(localFileConfig.getPath(), file);
        String url = localFileConfig.getDomain() + localFileConfig.getPrefix() + name;
        return url;
    }
}
