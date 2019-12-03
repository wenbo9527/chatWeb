<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WebSocket Demo</title>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/vue.min.js"></script>
    <script src="https://cdn.staticfile.org/vue-resource/1.5.1/vue-resource.min.js"></script>

</head>
<style type="text/css">
    tr{height: 50px}
    td{text-align: left}
    a{border: 1px solid #2e3238}
    .backgroud{ position: absolute;width: 100%;height: 100%;z-index: -999;top: 0px;left: 0px}
    .backgroud img{width: 100%;height: 100%}
    .main_login{position: absolute;right: 350px;top:150px;width: 300px;height:300px;text-align: center;background-color:transparent;}
</style>
<body>
<div id="backgroud" class="backgroud" name="backgroud">
    <!--<img src="${pageContext.request.contextPath}/images/main.png">-->
</div>
<div id="main_login" class="main_login">
    <form id="form1" action="/switchPage/toLogin" method="post">
        <p>网页登陆</p>
        <table>
            <tr>
                <td>用户名:</td>
                <td><input type="text" v-model="username" name="username" id="username" autocomplete="off"></td>
            </tr>
            <tr>
                <td>密&ensp;&ensp;码:</td>
                <td>
                    <input v-model="password" v-show="showPwd" type="password" name="password" autocomplete="off">
                    <input v-model="password" v-show="!showPwd" type="text" autocomplete="off">
                    <img v-on:mouseenter="showPwd = false" v-on:mouseleave=" showPwd = true"  src="${pageContext.request.contextPath}/images/eye.png">
                </td>
            </tr>
        </table>
        <p><button type="submit" id="login" name="login" v-on:click = "tologin">登陆</button>&ensp;
            <button type="submit" id="regist" name="regist" v-on:click = "toregist">注册</button></p>
    </form>
</div>

<script>
    var tips = "${param.tips}";
    
    var vue = new Vue({
        el: '#main_login',
        data: {
            username: "",
            password: "",
            showPwd: true
        },
        mounted:function(event) {
            if(tips != "" && tips != undefined) {
                alert(tips);
            }
        },
        methods: {
            switchPwd: function(event){
                this.showPwd = !this.showPwd;
            },
            tologin: function(event){
                if(this.username == "" || this.password == "") {
                    alert("请输入完整的账号密码！！！");
                    $('#form1').attr("action","#");
                }
                <%--else{--%>
                <%--    this.$http.post('${pageContext.request.contextPath}/switchPage/login',--%>
                <%--        {--%>
                <%--            username:this.username,--%>
                <%--            password:this.password--%>
                <%--        },{emulateJSON:true}).then(function(res){--%>
                <%--        $(location).attr("href",res.url);--%>
                <%--    },function(){--%>
                <%--        console.log('请求失败处理');--%>
                <%--    });--%>
                <%--}--%>
            },
            toregist: function(event){
                $('#form1').attr("action","${pageContext.request.contextPath}/switchPage/regist");
            }
        },
        watch: {
            password: function(val){

            }
        }
    });
</script>
</body>
</html>