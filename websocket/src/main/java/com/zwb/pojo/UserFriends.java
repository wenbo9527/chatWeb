package com.zwb.pojo;

import com.zwb.service.CommonTool;

public class UserFriends {
    private String fid;
    private String uid1;
    private String uid2;

    UserFriends(){
        this.fid = CommonTool.getUUID();
    }

    public String getFid() {
        return fid;
    }

    public String getUid1() {
        return uid1;
    }

    public void setUid1(String uid1) {
        this.uid1 = uid1;
    }

    public String getUid2() {
        return uid2;
    }

    public void setUid2(String uid2) {
        this.uid2 = uid2;
    }
}
