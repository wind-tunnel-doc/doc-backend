package com.doc.common.security.interceptor;

import com.doc.common.core.constant.SecurityConstants;
import com.doc.common.core.context.SecurityContextHolder;
import com.doc.common.core.utils.ServletUtils;
import com.doc.common.core.utils.StringUtils;
import com.doc.common.security.auth.AuthUtil;
import com.doc.common.security.utils.SecurityUtils;
import com.doc.system.pojo.entity.LoginUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.AsyncHandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 自定义请求头拦截器，将Header数据封装到线程变量中方便获取
 * 注意：此拦截器会同时验证当前用户有效期自动刷新有效期
 *
 * @author shiliuyinzhen
 */
public class HeaderInterceptor implements AsyncHandlerInterceptor {

    private static Logger log = LoggerFactory.getLogger(HeaderInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        SecurityContextHolder.setUserId(ServletUtils.getHeader(request, SecurityConstants.DETAILS_USER_ID));
        SecurityContextHolder.setUsername(ServletUtils.getHeader(request, SecurityConstants.DETAILS_USERNAME));
        SecurityContextHolder.setUserKey(ServletUtils.getHeader(request, SecurityConstants.USER_KEY));

        String token = SecurityUtils.getToken();
        log.info("token="+token);
        if (StringUtils.isNotEmpty(token)) {
            LoginUser loginUser = AuthUtil.getLoginUser(token);
            if (StringUtils.isNotNull(loginUser)) {
                AuthUtil.verifyLoginUserExpire(loginUser);
                SecurityContextHolder.set(SecurityConstants.LOGIN_USER, loginUser);
                log.info("用户信息：" + loginUser);
                SecurityContextHolder.set(SecurityConstants.DETAILS_USERNAME, loginUser.getUsername());
                SecurityContextHolder.set(SecurityConstants.DETAILS_USER_ID,loginUser.getUserId());
            }
        }
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        SecurityContextHolder.remove();
    }
}
