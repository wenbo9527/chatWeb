package com.zwb.pojo;

import com.zwb.service.CommonTool;

import java.util.UUID;

public class User {

    private String uid;
    private String username;
    private String password;
    private String imagePath;

    User(){
        this.uid = CommonTool.getUUID();
    }

    //密码加密
    public void encryption(String password){
        char[] str = password.toCharArray();
        StringBuffer pwd = new StringBuffer();
        for(int i = 0; i < str.length;i++){
            str[i] += 1;
            pwd.append(str[i]);
        }
        this.password = pwd.toString();
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getUid() {
        return uid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }
}
