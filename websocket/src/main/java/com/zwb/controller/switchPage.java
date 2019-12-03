package com.zwb.controller;


import com.zwb.pojo.User;
import com.zwb.service.CheckInforService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/switchPage")
public class switchPage {

    @Autowired
    private CheckInforService checkInforService;

    @RequestMapping("/regist")
    public String toRegist(){
        return "regist";
    }

//    @RequestMapping("/toLogin")
//    public ModelAndView toLogin(String username, String password, HttpSession session){
//        ModelAndView mv = new ModelAndView();
//        mv.setViewName("login");
//        User user = checkInforService.loginCheck(username,password);
//        if( user != null ){
//            session.setAttribute("user",user);
//            mv.setViewName("redirect:chatPublic");
//            return mv;
//        }else{
//            session.setAttribute("tips","账号不存在或是密码不正确");
//            mv.setViewName("redirect:login");
//            return mv;
//        }
//    }

//    @RequestMapping("/login")
//    public ModelAndView login(HttpSession session, Model model){//判断是否登录，已经登陆则返回主页，否则返回登录页面
//        ModelAndView mv = new ModelAndView();
//        User user = (User) session.getAttribute("user");
//        if(user != null){
//            mv.setViewName("redirect:chatPublic");
//            return mv;
//        }else{
//            String tips = (String)session.getAttribute("tips");
//            if(!StringUtils.isEmpty(tips)){
//                model.addAttribute("tips",tips);
//                session.removeAttribute("tips");
//            }
//            mv.setViewName("login");
//            return mv;
//        }
//    }

    @RequestMapping("/login")
    public ModelAndView login(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("login");
        return mv;
    }

    @RequestMapping("/toLogin")
    public String tologin(
            @RequestParam(value = "username",required = false)String username,
            @RequestParam(value = "password",required = false)String password,
            Model model){
        String error = null;
        if (username != null && password != null) {
            //初始化
            Subject subject = SecurityUtils.getSubject();
            UsernamePasswordToken token = new UsernamePasswordToken(username, password);
            try {
                //登录，即身份校验，由通过Spring注入的UserRealm会自动校验输入的用户名和密码在数据库中是否有对应的值
                subject.login(token);

                return "redirect:/switchPage/chatPublic";
            }catch (Exception e){
                e.printStackTrace();
                error = "未知错误，错误信息：" + e.getMessage();
            }
        } else {
            error = "请输入用户名和密码";
        }
         model.addAttribute("error", error);
         return "login";
    }


    @RequestMapping("chatPublic")
    public ModelAndView toChatPublic(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("chatPublic");
        return mv;
    }

    @RequestMapping("chatPrivate")
    public ModelAndView toChatPrivate(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("chatPrivate");
        return mv;
    }

}
