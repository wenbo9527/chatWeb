package com.zwb.dao;

import com.zwb.pojo.Message;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageMapper {

    //根据主键删除
    int deleteByMid(String mid);
    //插入数据
    int deleteByUid(String uid_set,String uid_get);

    //根据主键选择修改
    int insert(Message record);
    //根据主键查询
    Message selectByPrimaryKey(String mid);
    //查询两人的聊天消息记录
    List<Message> selectByUid(String uid_set, String uid_get);
    //查询群里所有的聊天内容
    List<Message> selectByGroupId(String group_id);
    //模糊查询
    List<Message> selectByMessageAndUid(String message,String uid_set,String uid_get);
    List<Message> selectByMessageAndGroupId(String message,String group_id);
}
