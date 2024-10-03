package com.doc.file.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件上传接口
 * 
 * @author shiliuyinzhen
 */
@Service
public interface FileService {

    /**
     * 文件上传接口
     * 
     * @param file 上传的文件
     * @return 访问地址
     * @throws Exception
     */
    public String uploadFile(MultipartFile file) throws Exception;

}
