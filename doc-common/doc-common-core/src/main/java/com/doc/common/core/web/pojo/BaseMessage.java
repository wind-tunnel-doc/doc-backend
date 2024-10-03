package com.doc.common.core.web.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

/**
 * 消息 基本类
 * @author shiliuyinzhen
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class BaseMessage extends BaseEntity {

    /** 消息标题 */
    private String title;

    /** 消息类型 */
    private Integer typeId;

    /** 发送者id */
    private Long senderId;

    /** 发送者名 */
    private String senderName;

    /** 接收者id */
    private Long getterId;

    /** 消息内容 */
    private String content;

    /** 地址 */
    private String url;
}
