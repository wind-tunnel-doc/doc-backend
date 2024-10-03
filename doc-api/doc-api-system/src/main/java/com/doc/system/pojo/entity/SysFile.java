package com.doc.system.pojo.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 文件信息
 * 
 * @author shiliuyinzhen
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SysFile {

    /**
     * 文件名称
     */
    private String name;

    /**
     * 文件地址
     */
    private String url;

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("name", getName())
            .append("url", getUrl())
            .toString();
    }
}
