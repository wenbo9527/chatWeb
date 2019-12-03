package com.zwb.pojo;

import com.zwb.service.CommonTool;

import java.util.Date;
import java.util.Map;

public class Message {

    private String mid;
    private String message;
    private String uid_set;
    private String uid_get;
    private String group_id;
    private Date mtime;
    private boolean status;

    public Message(){
        this.mtime = new Date();
        this.group_id = "0";
        this.mid = CommonTool.getUUID();
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public Date getMtime() {
        return mtime;
    }

    public String getMid() {
        return mid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getUid_set() {
        return uid_set;
    }

    public void setUid_set(String uid_set) {
        this.uid_set = uid_set;
    }

    public String getUid_get() {
        return uid_get;
    }

    public void setUid_get(String uid_get) {
        this.uid_get = uid_get;
    }
}
