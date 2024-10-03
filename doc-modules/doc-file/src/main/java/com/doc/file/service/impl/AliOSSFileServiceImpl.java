package com.doc.file.service.impl;

import com.aliyun.oss.*;
import com.doc.file.config.AliOSSConfig;
import com.doc.file.service.FileService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;

/**
 * aliOSS 文件上传
 * @author shiliuyinzhen
 */
@Primary
@Slf4j
@Service
public class AliOSSFileServiceImpl implements FileService {

    @Autowired
    private AliOSSConfig aliossConfig;

    /**
     * 文件上传
     * @param file 上传的文件
     * @return
     * @throws Exception
     */
    @Override
    public String uploadFile(MultipartFile file) throws Exception {

        //获取文件流
        InputStream inputStream = file.getInputStream();
        //得到上传文件的原始文件名
        String originalFilename = file.getOriginalFilename();
        //得到原始文件的后缀名
        String suffixName = originalFilename.substring(originalFilename.lastIndexOf("."));
        //构建新的文件名
        String fileName = UUID.randomUUID().toString() + suffixName;

        //获取配置信息
        String bucketName = aliossConfig.getBucketName();
        String endpoint = aliossConfig.getEndpoint();
        String accessKeyId = aliossConfig.getAccessKeyId();
        String accessKeySecret = aliossConfig.getAccessKeySecret();

        //创建aliOSS客户端
        OSS ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);

        try {
            // 创建PutObject请求
            ossClient.putObject(bucketName, fileName, inputStream);
        } catch (OSSException oe) {
            System.out.println("Caught an OSSException, which means your request made it to OSS, "
                    + "but was rejected with an error response for some reason.");
            System.out.println("Error Message:" + oe.getErrorMessage());
            System.out.println("Error Code:" + oe.getErrorCode());
            System.out.println("Request ID:" + oe.getRequestId());
            System.out.println("Host ID:" + oe.getHostId());
        } catch (ClientException ce) {
            System.out.println("Caught an ClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with OSS, "
                    + "such as not being able to access the network.");
            System.out.println("Error Message:" + ce.getMessage());
        } finally {
            if (ossClient != null) {
                ossClient.shutdown();
            }
        }

        //文件访问路径规则 https://BucketName.Endpoint/ObjectName
        StringBuilder stringBuilder = new StringBuilder("https://");
        stringBuilder.append(bucketName)
                .append(".")
                .append(endpoint)
                .append("/")
                .append(fileName);
        log.info("文件上传到:{}", stringBuilder);
        return stringBuilder.toString();
    }
}
