package com.zwb.service;

import com.zwb.dao.UserMapper;
import com.zwb.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public User findByName(String userName){
        return userMapper.selectByUserName(userName);
    }

    public User insert(User user){
        return null;
    }

    public User updata(User user){
        return null;
    }

}
