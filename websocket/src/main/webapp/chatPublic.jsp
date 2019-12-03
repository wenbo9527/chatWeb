<%--
  Created by IntelliJ IDEA.
  User: 60055859
  Date: 2019/7/3
  Time: 11:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/vue.min.js"></script>
    <style>
        /*#body{border: 1px solid black;width:900px;margin-left:350px;height:100%}*/
        /*#leftList{position: absolute;width: 300px;border: 1px solid black;height: 100%;float: left; overflow:auto;background: #2e3238}*/
        /*#chatContent{position: relative;margin-left:300px; width: 600px;border: 1px solid black;height: 100%;}*/
        /*#showMsg{position: relative;height: 600px;width: 100%;top:0px}*/
        /*#writeMsg{position: relative;height: 200px;width: 100%;top: 0px;border-top-style:solid;border-top-color: black}*/
        /*#writeMsg textarea{width: 100%;height: 100%}*/

        /*#search,#info{position:relative;left:30px;width: 200px;height: 50px;text-align: center;padding-top: 10px;}*/
        /*#personInfo{color: white;width: 100%;height: 50px;position: absolute;top: 0px;}*/
        /*#personChat{color: white;width: 100%;height: 50px;position: absolute;top: 60px; }*/
        /*#info div{float: left;}*/

        .subject{height: 100%;margin: 0px auto;max-width: 1000px;min-width: 800px;}
        .person{position: relative;float: left;width:280px;height: 100%;background: #2e3238}
        .message{position: relative;background-color: #eee;height: 100%;overflow: hidden;}
        .person-user{position: relative;padding: 18px;}
        .person-user div{display: table-cell;vertical-align: middle;}
        .person-user .avatar{padding-right: 10px}
        .person-user .infor{width: 200px;word-wrap: break-word;word-break: break-all;}
        person-other {overflow: hidden}
        .head-portrait{width: 40px;height: 40px;}
        .username{display: inline-block;font-weight: 400;width: 156px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;word-wrap: normal;color: #fff;font-size: 18px;vertical-align: top;line-height: 31px;text-decoration: none;}
        .search_bar{position: relative;width: 244px;margin: 0 auto 6px;}
        .image_search_bar{position: absolute;z-index: 101;top: 1px;}
        .search_context{width: 214px;height: 32px;line-height: 32px;border: 0;background-color: #26292e;color: #fff;padding-left: 30px;font-size: 12px;}
        .tab{overflow: hidden;position: relative;padding-bottom: 4px;height: 35px;border-bottom: 1px solid black}
        .chat_item{position: relative;padding: 18px;cursor:pointer;border-bottom: 1px solid black;}
        .chat_item .avatar{float: left;margin-right: 10px;position: relative;}
        .chat_item .infor{overflow: hidden;}
        .message .chat-name{position:relative;width: 100%;height: 10%;text-align: center;}
        .message .message-show{position:relative;width: 100%;height: 60%;border-top: 1px solid #2e3238;border-bottom: 1px solid #2e3238}
        .message .message-write{position: relative;width: 100%;height: 20%;overflow: auto;}
        .message .message-write textarea{position: relative;margin-top:10px;width: 100%;height: 10em;border:none;overflow: auto;background-color: #eee;outline: none;font-size: 14px;white-space: pre-wrap;}
        .message .button{position: relative;width: 100%;height: 10%;text-align: right;margin-top: 5px;}
        .message .button a{width: 50px;height: 20px;text-decoration:none;background-color: #fff;color: #222;padding-left: 30px;padding-right: 30px;border: 1px solid #c1c1c1;}
        .message .message-show .message-left{position: relative;width: 100%;height: 20px;text-align: left;}
        .message .message-show .message-right{position: relative;width: 100%;height: 20px;text-align: right;color: cadetblue}


    </style>
    <script type="text/javascript">
        var webSocket = null;
        var userId = '${user.uid}';
        $(function(){
            if('WebSocket' in window){
                startConnect();
            }else{
                alert('你的浏览器不支持WebSocket');
            }
        });

        function startConnect(){
            //记住 是ws开关 是ws开关 是ws开关 ws://IP:端口/项目名/Server.java中的@ServerEndpoint的value
            webSocket = new WebSocket("ws://localhost:8080/websocket_war_exploded/chat/"+userId);//一个websocket

            webSocket.onerror = function(event) {//websocket的连接失败后执行的方法
                onError(event);
            };
            webSocket.onopen = function(event) {//websocket的连接成功后执行的方法
                onOpen(event);
            };
            webSocket.onmessage = function(event) {//websocket的接收消息时执行的方法
                onMessage(event)
            };
        }
        function colseConnect(){//关闭连接
            webSocket.close();
        }
        function onMessage(event) {
            var json = event.data;
            var message = JSON.parse(json).message;debugger;
            $('#message-show').append("<p class='message-left'>"+message+"</p>");
            //$("#allMsg").append("<p>" + event.data + "</p>");
        }
        function onOpen(event) {
            console.log("连接服务器成功");
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
            var messageContent = $("#write").val();
            $("#write").val("");
            var getUid = $("#uid").val();
            var sendUid = userId;
            var message = {
                getUid:getUid,
                sendUid:sendUid,
                messageContent:messageContent
            }
            webSocket.send(JSON.stringify(message));//向服务器发送消息
            $('#message-show').append("<p class='message-right'>"+messageContent+"</p>");
        }



    </script>
</head>
<body>
<div class="subject">
    <div class="person">
        <div class="person-user">
            <div class="avatar">${user.imagePath}
                <img src="${pageContext.request.contextPath}/images/head.jpg" class="head-portrait">
            </div>
            <div class="infor">
                <span class="username">${user.username}</span>
            </div>
        </div>
        <div class="search_bar">
            <i class="image_search_bar"></i>
            <input type="text" placeholder="搜索" class="search_context">
        </div>
        <div class="tab">

        </div>
        <div class="person-other">
            <div class="chat_item">
                <div class="avatar">
                    <img src="${pageContext.request.contextPath}/images/head.jpg" class="head-portrait">
                </div>
                <div class="infor">
                    <span class="username">${user.username}</span>
                </div>
            </div>
        </div>
    </div>
    <div class="message">
        <div class="chat-name">
            <input type="hidden" id="uid" value="${user.uid}" >
            <h3>${user.username}</h3>
        </div>
        <div id="message-show" class="message-show">
<%--            <p class="message-left">hello</p>--%>
<%--            <p class="message-right">hello</p>--%>
        </div>
        <div class="message-write">
            <textarea id="write" class="write"></textarea>
        </div>
        <div class="button">
            <a href="javascript:void(0)" id="sendMsg" onclick="sendMessage()">发送</a>
        </div>
    </div>
</div>
</body>
</html>
