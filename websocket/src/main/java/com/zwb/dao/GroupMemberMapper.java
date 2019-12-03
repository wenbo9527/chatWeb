package com.zwb.dao;

import com.zwb.pojo.GroupMember;

import java.util.List;

public interface GroupMemberMapper {

    //根据主键删除
    int deleteByGroupId(String group_id);
    int deleteByUid(String uid);
    //根据主键选择修改
    int insert(GroupMember record);
    //根据主键查询
    List<GroupMember> selectByPrimaryKey(String group_id);
    //根据用户名查询
    List<GroupMember> selectByUid(String uid);

}
