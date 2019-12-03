package com.zwb.service;

import com.zwb.dao.MessageMapper;
import com.zwb.pojo.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageService {

    @Autowired
    public MessageMapper messageMapper;

    //保存发送的信息
    public void saveMessageWithUid(String uid_set,String uid_get,String messageContent){
        Message message = new Message();
        message.setUid_set(uid_set);
        message.setUid_get(uid_get);
        message.setMessage(messageContent);
        messageMapper.insert(message);
    }

    //保存发送的信息
    public void saveMessageWithGroupId(String uid_set,String group_id,String messageContent){
        Message message = new Message();
        message.setUid_set(uid_set);
        message.setGroup_id(group_id);
        message.setMessage(messageContent);
        messageMapper.insert(message);
    }

}
