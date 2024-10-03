package com.doc.common.core.exception.file;

import com.doc.common.core.exception.base.BaseException;
/**
 * 文件信息异常类
 * 
 * @author shuiliuyinzhen
 */
public class FileException extends BaseException {

    private static final long serialVersionUID = 1L;

    public FileException(String code, Object[] args, String msg)
    {
        super("文件服务模块", code, args, msg);
    }

}
