package com.zwb.service;

import com.zwb.dao.GroupMemberMapper;
import com.zwb.pojo.GroupMember;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GroupMemberService {

    @Autowired
    public GroupMemberMapper groupMemberMapper;

    public List<GroupMember> getUidByGroupId(String group_id){
        return groupMemberMapper.selectByPrimaryKey(group_id);
    }

}
