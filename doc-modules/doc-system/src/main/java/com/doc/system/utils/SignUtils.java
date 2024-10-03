package com.doc.system.utils;
 
import cn.hutool.core.date.DateUtil;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.dto.SignDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.BitFieldSubCommands;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 签到 工具类
 * @author shiliuyinzhen
 */
@Component
public class SignUtils {
 
    @Autowired
    private StringRedisTemplate stringRedisTemplate;

//    @Resource
//    private RemoteScoreTaskLogService remoteScoreTaskLogService;

    /**
     * 签到
     * @param signDto
     */
    public Boolean sign(SignDto signDto){
        //获取日期
        Date date = getDate(signDto);
        //如果已经签到
        if (checkSign(new SignDto(date))){
            return false;
        }
//        //更新积分任务记录
//        ScoreTaskLog scoreTaskLog = ScoreTaskLog.builder()
//                .taskId(ScoreTaskConstant.USER_SIGN)
//                .userId(SecurityUtils.getUserId())
//                .finishTime(LocalDateTime.now())
//                .build();
//        AjaxResult ajaxResult =
//                remoteScoreTaskLogService.addScoreTaskLog(scoreTaskLog, SecurityConstants.INNER);
//        if (ajaxResult.isError()){
//            throw new ServiceException("更新积分任务记录失败");
//        }
        //签到
        String key = buildSignKey(SecurityUtils.getUserId(), date);
        int dayOfMonth = DateUtil.dayOfMonth(date);
        stringRedisTemplate.opsForValue().setBit(key,dayOfMonth - 1,true);
        return true;
    }
 
    /**
     * 获取连续签到次数
     * @param signDto
     * @return
     */
    public Integer getContinuousSignCount(SignDto signDto){
        //获取日期
        Date date = getDate(signDto);
        String key = buildSignKey(SecurityUtils.getUserId(), date);
        int dayOfMonth = DateUtil.dayOfMonth(date);
        //获取用户从当前日期开始到1号的签到状态
        List<Long> list = stringRedisTemplate.opsForValue().bitField(
          key,
          BitFieldSubCommands.create().get(BitFieldSubCommands.BitFieldType.unsigned(dayOfMonth)).valueAt(0)
        );
        if (list == null || list.isEmpty()){
            return 0;
        }
        //连续签到计数器
        int signCount = 0;
        long v = list.get(0) == null ? 0 : list.get(0);
        //位移运算连续签到次数
        for (int i = dayOfMonth; i > 0; i--){
            //i表示位移操作的次数，右移再左移如果等于自己说明最低位是0，表示未签到
            if (v >> 1 << 1 == v){
                //用户可能还未签到，所以要排除是否是当天的可能性
                if (i != dayOfMonth) break;
            }else {
                //右移再左移，如果不等于自己说明最低位是1，表示签到
                signCount++;
            }
            v >>= 1;
        }
        return signCount;
    }
 
    /**
     * 获取本月累计签到数
     * @param signDto
     * @return
     */
    public Long getSumSignCount(SignDto signDto){
        //获取日期
        Date date = getDate(signDto);
        String key = buildSignKey(SecurityUtils.getUserId(), date);
        int dayOfMonth = DateUtil.dayOfMonth(date);
        return stringRedisTemplate.execute((RedisCallback<Long>) connection -> connection.bitCount(key.getBytes()));
    }
 
    /**
     * 查询当天是否有签到
     * @return
     */
    public boolean checkSign(SignDto signDto){
        //获取日期
        Date date = getDate(signDto);
        String key = buildSignKey(SecurityUtils.getUserId(), date);
        int dayOfMonth = DateUtil.dayOfMonth(date);
        return stringRedisTemplate.opsForValue().getBit(key,dayOfMonth - 1);
    }
 
    /**
     * 获取本月签到信息
     * @return
     */
    public Map<String,String> getSignInfo(SignDto signDto){
        //获取日期
        Date date = getDate(signDto);
        String key = buildSignKey(SecurityUtils.getUserId(), date);
        int dayOfMonth = DateUtil.dayOfMonth(date);
        Map<String,String> signMap = new LinkedHashMap<>(dayOfMonth);
        //获取BitMap中的bit数组，并以十进制返回
        List<Long> bitFieldList = (List<Long>) stringRedisTemplate.execute((RedisCallback<List<Long>>) cbk
                -> cbk.bitField(key.getBytes(), BitFieldSubCommands.create().get(BitFieldSubCommands.BitFieldType.unsigned(dayOfMonth)).valueAt(0)));
        if (bitFieldList != null && bitFieldList.size() > 0){
            Long valueDec = bitFieldList.get(0) != null ? bitFieldList.get(0) : 0;
            //使用i--,从最低位开始处理
            for (int i = dayOfMonth; i > 0; i--) {
                LocalDate tempDayOfMonth = LocalDate.now().withDayOfMonth(i);
                //valueDec先右移一位再左移以为得到一个新值，这个新值最低位的二进制为0，再与valueDec做比较，如果相等valueDec的最低位是0，否则是1
                if (valueDec >> 1 << 1 != valueDec){
                    signMap.put(tempDayOfMonth.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),"1");
                }else {
                    signMap.put(tempDayOfMonth.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),"0");
                }
                //每次处理完右移一位
                valueDec >>= 1;
            }
        }
        return signMap;
    }

    /**
     * 获取日期
     * @param signDto
     * @return
     */
    public Date getDate(SignDto signDto) {
        Date date = signDto.getDate();
        if (date == null){
            date = new Date();
        }
        return date;
    }

    /**
     * 构建redis Key  user:sign:userId:yyyyMM
     * @param userId 用户id
     * @param date 日期
     * @return
     */
    public String buildSignKey(Long userId,Date date){
        return String.format("user:sign:%s:%s",userId, DateUtil.format(date,"yyyyMM"));
    }
}