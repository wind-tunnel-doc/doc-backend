package com.doc.system.controller;

import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.exception.ServiceException;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.redis.service.RedisService;
import com.doc.common.security.annotation.RequiresLogin;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.mapper.SysUserMapper;
import com.doc.system.pojo.dto.SignDto;
import com.doc.system.pojo.entity.SysUser;
import com.doc.system.utils.SignUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 签到 控制层
 * @author shiliuyinzhen
 */
@Slf4j
@RestController
@RequestMapping("/sign")
@Api(tags = "每日签到相关接口")
public class SignController {
 
    @Autowired
    private SignUtils signUtils;

    @Autowired
    private RedisService redisService;

    @Autowired
    private SysUserMapper sysUserMapper;

    /**
     * 签到
     * @return
     */
    @RequiresLogin
    @PostMapping
    @ApiOperation("签到")
    public  AjaxResult  sign(@RequestBody SignDto signDto){
        return signUtils.sign(signDto) ?
                AjaxResult.success("签到成功") : AjaxResult.error("已经签到");
    }

    /**
     * 签到结果
     * @param signDto
     * @return
     */
    @RequiresLogin
    @GetMapping("/check")
    @ApiOperation("签到结果")
    public AjaxResult checkSignResult(SignDto signDto){
        return signUtils.checkSign(signDto) ?
                AjaxResult.success("已经签到") : AjaxResult.error("未签到");
    }

    /**
     * 本月连续签到次数
     * @param signDto
     * @return
     */
    @RequiresLogin
    @GetMapping("/continue/month")
    @ApiOperation("本月连续签到次数")
    public AjaxResult getContinuousSignCount(SignDto signDto){
        Integer count = signUtils.getContinuousSignCount(signDto);
        Map<String,Integer> map = new HashMap<>();
        map.put("count",count);
        return AjaxResult.success(map);
    }
 
    /**
     * 本月累计签到数
     * @param signDto
     * @return
     */
    @RequiresLogin
    @GetMapping("/sum/month")
    @ApiOperation("本月累计签到数")
    public AjaxResult getSumSignCount(SignDto signDto){
        Map<String,Long> map = new HashMap<>();
        Long count = signUtils.getSumSignCount(signDto);
        map.put("count",count);
        return AjaxResult.success(map);
    }
 
    /**
     * 本月签到信息
     * @param signDto
     * @return
     */
    @RequiresLogin
    @GetMapping("/info/month")
    @ApiOperation("本月签到信息")
    public AjaxResult getSignInfo(SignDto signDto){
        return AjaxResult.success(signUtils.getSignInfo(signDto));
    }


    /**
     * 领取累计签到奖励
     * @param days
     * @return
     */
    @RequiresLogin
    @PostMapping("/getReward/{days}")
    @ApiOperation("领取累计签到奖励")
    public AjaxResult getSevenDayScore(@PathVariable("days")Integer days){
        Long sumSignCount = signUtils.getSumSignCount(new SignDto());
        //如果未达到累计天数
        if (sumSignCount < days){
            throw new ServiceException("未达到奖励领取条件");
        }
        //检查是否已经领取
        Long userId = SecurityUtils.getUserId();
        String signRewardKey = CacheConstants.USER_SIGN_REWARD_KEY + userId + ":" + LocalDate.now() + ":" + days;
        Boolean rewardStatus = redisService.getCacheObject(signRewardKey);
        //如果已经领取
        if (rewardStatus != null &&  rewardStatus == true){
            throw new ServiceException("奖励已经领取");
        }
        //更新用户积分,默认一天2积分
        Integer addScore = days * 2;
        SysUser sysUser = sysUserMapper.selectUserById(userId);
        sysUser.setScore(sysUser.getScore() + addScore);

        int row = sysUserMapper.updateUser(sysUser);
        if (row <= 0){
            throw new ServiceException("更新用户失败");
        }
        //更新redis缓存
        Long expireDays = (long) (LocalDate.now().lengthOfMonth() - LocalDate.now().getDayOfMonth() + 2) ;
        redisService.setCacheObject(signRewardKey,true, expireDays, TimeUnit.DAYS);
        return AjaxResult.success("领取成功");
    }

    /**
     * 领取累计签到奖励
     * @param days
     * @return
     */
    @RequiresLogin
    @GetMapping("/getReward/check/{days}")
    @ApiOperation("获取累计签到奖励领取状态")
    public  AjaxResult checkGetReward(@PathVariable("days")Integer days){
        //检查是否已经领取
        Long userId = SecurityUtils.getUserId();
        String signRewardKey = CacheConstants.USER_SIGN_REWARD_KEY + userId + ":" + LocalDate.now() + ":" + days;
        Boolean rewardStatus = redisService.getCacheObject(signRewardKey);
        //如果已经领取
        if (rewardStatus != null &&  rewardStatus == true){
            return AjaxResult.success("奖励已经领取");
        }
        return AjaxResult.error("奖励未领取");
    }

}