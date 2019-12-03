package com.zwb.controller;

import com.zwb.dao.UserFriendsMapper;
import com.zwb.pojo.User;
import com.zwb.pojo.UserFriends;
import com.zwb.service.UserFriendsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("UserFriendsController")
public class UserFriendsController {

    @Autowired
    public UserFriendsService userFriendsService;

    @RequestMapping("getAllFriends")
    @ResponseBody
    public List<User> getAllFriends(String uid){
        return userFriendsService.getAllFriends(uid);
    }
}
