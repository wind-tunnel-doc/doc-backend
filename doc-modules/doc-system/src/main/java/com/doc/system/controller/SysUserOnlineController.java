package com.doc.system.controller;

import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.core.web.controller.BaseController;
import com.doc.common.core.web.page.TableDataInfo;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.log.annotation.Log;
import com.doc.common.log.enums.BusinessType;
import com.doc.common.redis.service.RedisService;
import com.doc.system.pojo.entity.LoginUser;
import com.doc.system.pojo.entity.SysUserOnline;
import com.doc.system.service.ISysUserOnlineService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

/**
 * 在线用户监控
 * 
 * @author shiliuyinzhen
 */
@RestController
@RequestMapping("/online")
@Api(tags = "在线用户相关接口")
public class SysUserOnlineController extends BaseController {

    @Autowired
    private ISysUserOnlineService userOnlineService;

    @Autowired
    private RedisService redisService;

    /**
     * 获取在线用户列表
     * @param ipaddr
     * @param userName
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("获取在线用户列表")
    public TableDataInfo list(String ipaddr, String userName) {
        Collection<String> keys = redisService.keys(CacheConstants.LOGIN_TOKEN_KEY + "*");
        List<SysUserOnline> userOnlineList = new ArrayList<SysUserOnline>();
        for (String key : keys) {
            LoginUser user = redisService.getCacheObject(key);
            if (StringUtils.isNotEmpty(ipaddr) && StringUtils.isNotEmpty(userName)) {
                userOnlineList.add(userOnlineService.selectOnlineByInfo(ipaddr, userName, user));
            } else if (StringUtils.isNotEmpty(ipaddr)) {
                userOnlineList.add(userOnlineService.selectOnlineByIpaddr(ipaddr, user));
            } else if (StringUtils.isNotEmpty(userName)) {
                userOnlineList.add(userOnlineService.selectOnlineByUserName(userName, user));
            } else {
                userOnlineList.add(userOnlineService.loginUserToUserOnline(user));
            }
        }
        Collections.reverse(userOnlineList);
        userOnlineList.removeAll(Collections.singleton(null));
        return getDataTable(userOnlineList);
    }

    /**
     * 强退用户
     */
    @Log(title = "在线用户", businessType = BusinessType.FORCE)
    @DeleteMapping("/{tokenId}")
    @ApiOperation("强退用户")
    public AjaxResult forceLogout(@PathVariable String tokenId) {
        redisService.deleteObject(CacheConstants.LOGIN_TOKEN_KEY + tokenId);
        return success();
    }
}
