package com.zwb.filter;

import com.zwb.pojo.User;
import com.zwb.service.UserService;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.util.Map;

public class UserFormAuthenticationFilter extends FormAuthenticationFilter {

    @Autowired
    private UserService userService;

    @Override
    public boolean onLoginSuccess(AuthenticationToken token, Subject subject, ServletRequest request, ServletResponse response) throws Exception{
        User user = userService.findByName(subject.getPrincipals().toString());

        System.out.println(WebUtils.getSavedRequest(request).getRequestURI());
        subject.getSession().setAttribute("user",user);
        return super.onLoginSuccess(token,subject,request,response);
    }

    protected void issueSuccessRedirect(ServletRequest request, ServletResponse response) throws Exception {
        WebUtils.issueRedirect(request, response, this.getSuccessUrl(), null, true);
    }

}
