package com.zwb.service;

import com.zwb.dao.UserFriendsMapper;
import com.zwb.pojo.User;
import com.zwb.pojo.UserFriends;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserFriendsService {

    @Autowired
    public UserFriendsMapper userFriendsMapper;

    public List<User> getAllFriends(String uid){
        List<UserFriends> userFriends = userFriendsMapper.selectByUid(uid);
        return null;
    }

}
