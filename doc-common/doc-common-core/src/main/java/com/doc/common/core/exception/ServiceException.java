package com.doc.common.core.exception;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 业务异常
 * 
 * @author shiliuyinzhen
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public final class ServiceException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    /**
     * 错误码
     */
    private Integer code;

    /**
     * 错误提示
     */
    private String message;

    /**
     * 错误明细，内部调试错误
     *
     * 和 {@link CommonResult#getDetailMessage()} 一致的设计
     */
    private String detailMessage;

    public ServiceException(String message) {
        this.message = message;
    }

    public ServiceException(String message, Integer code) {
        this.message = message;
        this.code = code;
    }

    @Override
    public String getMessage()
    {
        return message;
    }

    public Integer getCode()
    {
        return code;
    }
}