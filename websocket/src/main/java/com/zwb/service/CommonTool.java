package com.zwb.service;

import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class CommonTool {

    public static String getUUID(){
        return UUID.randomUUID().toString().replace("-","").toLowerCase();
    }

}
