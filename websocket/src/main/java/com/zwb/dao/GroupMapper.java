package com.zwb.dao;

import com.zwb.pojo.Group;

import java.util.List;

public interface GroupMapper {

    //根据主键删除
    int deleteByGroupId(String group_id);
    //根据主键选择修改
    int insert(Group record);
    //根据主键查询
    Group selectByPrimaryKey(String group_id);
    //根据用户名查询
    List<Group> selectByGroupName(String group_name);

}
