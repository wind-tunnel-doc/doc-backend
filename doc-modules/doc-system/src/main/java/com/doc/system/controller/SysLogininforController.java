package com.doc.system.controller;

import com.doc.common.core.constant.CacheConstants;
import com.doc.common.core.utils.poi.ExcelUtil;
import com.doc.common.core.web.controller.BaseController;
import com.doc.common.core.web.page.TableDataInfo;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.log.annotation.Log;
import com.doc.common.log.enums.BusinessType;
import com.doc.common.redis.service.RedisService;
import com.doc.common.security.annotation.InnerAuth;
import com.doc.system.pojo.entity.SysLogininfor;
import com.doc.system.service.ISysLogininforService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 系统访问记录
 * 
 * @author shiliuyinzhen
 */
@RestController
@RequestMapping("/logininfor")
public class SysLogininforController extends BaseController {

    @Autowired
    private ISysLogininforService logininforService;

    @Autowired
    private RedisService redisService;

    @GetMapping("/list")
    public TableDataInfo list(SysLogininfor logininfor) {
        startPage();
        List<SysLogininfor> list = logininforService.selectLogininforList(logininfor);
        return getDataTable(list);
    }

    @Log(title = "登录日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysLogininfor logininfor) {
        List<SysLogininfor> list = logininforService.selectLogininforList(logininfor);
        ExcelUtil<SysLogininfor> util = new ExcelUtil<SysLogininfor>(SysLogininfor.class);
        util.exportExcel(response, list, "登录日志");
    }

    @Log(title = "登录日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{infoIds}")
    public AjaxResult remove(@PathVariable Long[] infoIds) {
        return toAjax(logininforService.deleteLogininforByIds(infoIds));
    }

    @Log(title = "登录日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/clean")
    public AjaxResult clean() {
        logininforService.cleanLogininfor();
        return success();
    }

    @Log(title = "账户解锁", businessType = BusinessType.OTHER)
    @GetMapping("/unlock/{userName}")
    public AjaxResult unlock(@PathVariable("userName") String userName) {
        redisService.deleteObject(CacheConstants.PWD_ERR_CNT_KEY + userName);
        return success();
    }

    @InnerAuth
    @PostMapping
    public AjaxResult add(@RequestBody SysLogininfor logininfor) {
        return toAjax(logininforService.insertLogininfor(logininfor));
    }
}
