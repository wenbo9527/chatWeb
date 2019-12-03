package com.zwb.dao;

import com.zwb.pojo.UserFriends;

import java.util.List;

public interface UserFriendsMapper {

    //根据主键删除
    int deleteByMid(String mid);
    //插入数据
    int deleteByUid_set(String uid_set);
    //根据选择插入数据
    int deleteByUid_get(String  uid_get);
    //根据主键选择修改
    int insert(UserFriends record);
    //根据主键修改
    int insertSelective(UserFriends record);
    //根据主键查询
    UserFriends selectByPrimaryKey(String mid);
    //根据用户名查询
    List<UserFriends> selectByUid(String uid_set);

}
