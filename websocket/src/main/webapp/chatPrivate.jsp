<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WebSocket Demo</title>
    <script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
    <style type="text/css">
        html, body{
            margin: 0;
            padding: 0;
        }
        header{
            width: 100%;
            height: 100px;
            text-align: center;
            font-size: 50px;
            line-height: 100px;
            font-family: "微软雅黑";
            border-bottom: 1px solid black;
            margin-bottom: 10px;
        }
        #messages{ padding: 10px; font-size: 20px;}
    </style>
</head>
<body>
<header>
    WebSocket
</header>

<script type="text/javascript">
    var webSocket = null;
    $(function(){
        if('WebSocket' in window){
            startConnect();
        }else{
            alert('你的浏览器不支持WebSocket');
        }
    });
    function startConnect(){
        //记住 是ws开关 是ws开关 是ws开关 ws://IP:端口/项目名/Server.java中的@ServerEndpoint的value
        webSocket = new WebSocket("ws://localhost:8080/websocket_war_exploded/chat");//一个websocket

        webSocket.onerror = function(event) {//websocket的连接失败后执行的方法
            onError(event);
        };
        webSocket.onopen = function(event) {//websocket的连接成功后执行的方法
            onOpen(event)
        };
        webSocket.onmessage = function(event) {//websocket的接收消息时执行的方法
            onMessage(event)
        };
    }
    function colseConnect(){//关闭连接
        webSocket.close();
    }
    function onMessage(event) {
        $("#allMsg").append("<p>" + event.data + "</p>");
    }
    function onOpen(event) {
        console.log("成功连接服务器");
        $("#allMsg").append("<p>已连接至服务器</p>");
    }
    function onError(event) {
        console.log("连接服务器失败");
        $("#allMsg").append("<p>连接服务器发生错误</p>");
    }
    function sendMessage(){
        if(webSocket.readyState != 1){//断了或其他原因连不上，就得重新连接一下
            startConnect();
        }
        webSocket.send(":"+$("#msg").val());//向服务器发送消息
        $("#msg").val("");//清空输入框
    }


</script>
<div id="allMsg"></div>
<input type="text" id="msg"/>
<input type="button" style="width: 100px" value="发送消息" onclick="sendMessage()"/>&nbsp;
<input type="button" style="width: 100px" value="关闭websocket" onclick="colseConnect()"/>
</body>
</html>