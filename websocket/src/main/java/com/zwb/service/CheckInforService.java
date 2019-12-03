package com.zwb.service;

import com.zwb.dao.UserMapper;
import com.zwb.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CheckInforService {

    @Autowired
    private UserMapper userMapper;

    public User loginCheck(String username ,String password){
        User user = userMapper.selectByUserName(username);
        if(password.equals(user.getPassword())){
            return user;
        }else{
            return null;
        }
    }

}
