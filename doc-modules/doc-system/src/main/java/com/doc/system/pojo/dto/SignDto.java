package com.doc.system.pojo.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 签到 传递参数
 * @author shiliuyinzhen
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SignDto {

    /** 签到日期 */
    @JsonFormat(pattern = "yyyy-MM-dd", shape = JsonFormat.Shape.STRING)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date date;
}
