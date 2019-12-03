package com.zwb.websocket;


import com.alibaba.fastjson.JSONObject;
import com.zwb.pojo.GroupMember;
import com.alibaba.fastjson.JSON;
import com.zwb.service.GroupMemberService;
import com.zwb.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat/{userId}")
public class WebSocketServer {

    private static int onlineCount = 0;  
    private static Map<String, WebSocketServer> clients = new ConcurrentHashMap<String, WebSocketServer>();
    private Session session;
    private String userId;
    private static int id = 0;

    @Autowired
    private MessageService messageService;
    @Autowired
    private GroupMemberService groupMemberService;

    /**
     * 打开连接，保存连接的用户
     * @param session
     * @param userId
     * @throws IOException
     */
    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userId) throws IOException {
        this.session = session;
        this.userId = userId;
        addOnlineCount();  
        clients.put(userId, this);
    }

    /**
     * 关闭连接，删除用户
     * @throws IOException
     */
    @OnClose
    public void onClose() throws IOException {
        clients.remove(this.userId);
        subOnlineCount();  
    }

    /**
     * 发送消息
     * @param message
     * @throws IOException
     */
    @OnMessage
    public void onMessage(String message) throws IOException {
        //解析json字符串
        Map<String,Object> map = jsonToMap(message);
        String sendUid = (String) map.get("sendUid");
        String getUid = (String) map.get("getUid");
        String group_id = (String ) map.get("group_id");
        String messageContent = (String) map.get("messageContent");
        if(StringUtils.isEmpty(group_id)){
            sendMessageTo(messageContent, sendUid, getUid);
        }else{
            sendMessageGroup(messageContent,sendUid,group_id);
        }
    }

    /**
     * 错误打印
     * @param session
     * @param error
     */
    @OnError
    public void onError(Session session, Throwable error) {
        error.printStackTrace();  
    }

    /**
     * 消息发送给用户
     * @param message
     * @param getUid
     * @throws IOException
     */
    public void sendMessageTo(String message,String sendUid, String getUid) throws IOException {
        WebSocketServer item = clients.get(getUid);
        if(item != null) {
            Map<String, Object> map = new HashMap<String, Object>();
            //消息内容包括发送者，接受者和消息内容
            map.put("sendUser", sendUid);
            map.put("message", message);
            map.put("getUser", getUid);
            JSONObject jsonObject = new JSONObject(map);
            item.session.getAsyncRemote().sendText(jsonObject.toString());
        }
        messageService.saveMessageWithUid(sendUid,getUid,message);
    }

    /**
     * 群聊发送消息
     * @param message
     * @throws IOException
     */
    public void sendMessageGroup(String message,String uid_set,String group_id) {
        Map<String, Object> map = new HashMap();
        //消息内容包括发送者，接受者和消息内容
        map.put("sendUser", uid_set);
        map.put("message", message);
        map.put("grou_id", group_id);
        JSONObject jsonObject = new JSONObject(map);
        List<GroupMember> groupMembers = groupMemberService.getUidByGroupId(group_id);
        for(GroupMember groupMember : groupMembers){
            WebSocketServer item = clients.get(groupMember.getUid());
            item.session.getAsyncRemote().sendText(jsonObject.toString());
        }
    }

    /**
     * 获取当前在线人数，线程安全
     * @return
     */
    public static synchronized int getOnlineCount() {
        return onlineCount;  
    }

    /**
     * 添加当前在线人数
     */
    public static synchronized void addOnlineCount() {
        WebSocketServer.onlineCount++;
    }

    /**
     * 减少当前在线人数
     */
    public static synchronized void subOnlineCount() {
        WebSocketServer.onlineCount--;
    }

    /**
     *
     * @return
     */
    public static synchronized Map<String, WebSocketServer> getClients() {
        return clients;  
    }

    //解析json数据
    public Map<String,Object> jsonToMap(String jsonStr){
        Map<String,Object> map =  JSON.parseObject(jsonStr);
        return map;
    }

    public List<?> jsonToList(String jsonStr){
        List<?> list = JSON.parseArray(jsonStr);
        return list;
    }

}
