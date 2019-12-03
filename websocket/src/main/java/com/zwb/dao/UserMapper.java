package com.zwb.dao;

import com.zwb.pojo.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface UserMapper {
    //根据主键删除
    int deleteByPrimaryKey(String uid);
    //插入数据
    int insert(User record);
    //根据选择插入数据
    int insertSelective(User record);
    //根据主键选择修改
    int updateByPrimaryKeySelective(User record);
    //根据主键修改
    int updateByPrimaryKey(User record);
    //根据主键查询
    User selectByPrimaryKey(Integer uid);
    //根据用户名查询
    User selectByUserName(String username);
}