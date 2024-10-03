package com.doc.system.controller;

import com.doc.common.core.utils.poi.ExcelUtil;
import com.doc.common.core.web.controller.BaseController;
import com.doc.common.core.web.page.TableDataInfo;
import com.doc.common.core.web.pojo.AjaxResult;
import com.doc.common.log.annotation.Log;
import com.doc.common.log.enums.BusinessType;
import com.doc.common.security.annotation.InnerAuth;
import com.doc.system.pojo.entity.SysOperLog;
import com.doc.system.service.ISysOperLogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 操作日志记录
 * 
 * @author shiliuyinzhen
 */
@RestController
@RequestMapping("/operlog")
@Api(tags = "操作日志相关接口")
public class SysOperlogController extends BaseController {

    @Autowired
    private ISysOperLogService operLogService;

    /**
     * 获取操作日志列表
     * @param operLog
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("获取操作日志列表")
    public TableDataInfo list(SysOperLog operLog) {
        startPage();
        List<SysOperLog> list = operLogService.selectOperLogList(operLog);
        return getDataTable(list);
    }

    /**
     * 导出操作日志
     * @param response
     * @param operLog
     */
    @Log(title = "操作日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    @ApiOperation("导出操作日志")
    public void export(HttpServletResponse response, SysOperLog operLog) {
        List<SysOperLog> list = operLogService.selectOperLogList(operLog);
        ExcelUtil<SysOperLog> util = new ExcelUtil<SysOperLog>(SysOperLog.class);
        util.exportExcel(response, list, "操作日志");
    }

    /**
     * 批量删除操作日志
     * @param operIds
     * @return
     */
    @Log(title = "操作日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{operIds}")
    @ApiOperation("批量删除操作日志")
    public AjaxResult remove(@PathVariable Long[] operIds) {
        return toAjax(operLogService.deleteOperLogByIds(operIds));
    }

    /**
     * 清空操作日志
     * @return
     */
    @Log(title = "操作日志", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean")
    @ApiOperation("清空操作日志")
    public AjaxResult clean() {
        operLogService.cleanOperLog();
        return success();
    }

    /**
     * 新增操作日志
     * @param operLog
     * @return
     */
    @InnerAuth
    @PostMapping
    @ApiOperation("新增操作日志(内部调用)")
    public AjaxResult add(@RequestBody SysOperLog operLog) {
        return toAjax(operLogService.insertOperlog(operLog));
    }
}
