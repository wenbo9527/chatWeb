<script type="text/javascript">
    var stepId=$("input[name=__stepId]").val();
    var taskId=$("input[name=__taskId]").val();
    var judgeTowards="";
    var hostoption = '';
    var first = "false";
    var temp;

    //页面加载事件
    $(function(){

        controlFileShow();

        uploadXLS();

        $('#tt').css("height",$(document).height());
        $('#tt').css("width",$(document).width());

        //根据选择申请资源类型加载表格
        queryTable("${IT22_resourceType}");
        if((stepId==""&&taskId=="")||(stepId=="1"&&taskId!="")){//申请人环节加载

            /*var IT22_operatingSystem = $('[name^=IT22_operatingSystem＃]');
            for(var i = 0 ; i<$('[name^=IT22_operatingSystem＃]').length ; i++){
                IT22_operatingSystem.onchange();
              }*/

            //判断当前登录人是否能申请
            var ad = $("input[name=_currUserName]").val();
            if(getPosition(ad)==0){
                alert('已限定指定人员申请，请联系IT内各领域组内指定人员申请');
                $('.bpmToolPanel').hide();
            }
            $("input[name=status]").val("");
            //其他环节带出厂家信息
            selectIT22_affiliation("${IT22_affiliation}");
            //设置员工号
            $("input[name=IT22_employeeNumber]").val("${employee.orgEmployee.jobNumber}");
            //设置申请人职位
            getProposerPost();
            //保存申请人
            $("input[name=saveTheApplicant]").val($("input[name=_currUserNickName]").val()+"("+$("input[name=_currUserNum]").val()+")");
            //$("input[name=directLeader]").val(getLeadership($("input[name=_currUserName]").val(),"directLeader"));
            //保存部门总监
            $("input[name=directorNum]").val(getLeadership($("input[name=_currUserName]").val(),"directorNum"));
            //判断资源类型选择，控制显隐
            logic();
            //获取管理员确认人员
            //getAdministrator();
            //获取邮件通知人员邮件地址
            var __nextOwner_0_num=$("input[name=__nextOwner_0_num]").val();
            var email="";
            if(__nextOwner_0_num.indexOf(";")>=0){
                var __nextOwner_0_numArr=__nextOwner_0_num.split(";");
                for(var i=0;i<__nextOwner_0_numArr.length;i++){
                    if(__nextOwner_0_numArr[i]!=""){
                        email+=getEmil(__nextOwner_0_numArr[i]);
                    }
                }
            }else{
                email=getEmil(__nextOwner_0_num);
            }
            $("input[name=save_MailInform]").val(email);
            //获取当前提交时间
            $("input[name=time]").val(new Date().format("yyyy年MM月dd日 hh时mm分ss秒"));
            //$("input[name=__nextOwner_0]").val($("input[name=directLeader]").val().split("(")[0]);
            //$("input[name=__nextOwner_0_num]").val($("input[name=directLeader]").val());
            //加载资源信息表格
            var htr= $("#dynamicRowsIdON tbody tr");
            for(i=0;i<htr.length;i++){
                selectQT(htr[i]);
            }
        }
        setNextNode();
    });

    //控制下一处理人
    function setNextNode(){
        if((stepId == "" && taskId == "")|| (stepId == "1" && taskId !="")){
            var IT22_no = $('[name^=IT22_no]');
            var logo = "N"
            $.each(IT22_no,function(n,val){
                if($(val).prop("checked")){
                    logo = "Y"
                }
            })
            if(logo == "N"){
                $('#noBackup').val("false");
            }else{
                $('#noBackup').val("true");
            }
            var noBackup = $('[name=noBackup]').val();
            var isBackups = $('[name=isBackups]').val();
            //备份管理员
            if(noBackup == "true" && isBackups == "true"){
                var IT22_affiliation = $('[name=IT22_affiliation]').val();
                $("input[name=__nextNodeName_0]").val(nextActivityData[0].activityName);
                $("input[name=__nextNodeId_0]").val(nextActivityData[0].activityBpdId);
                $("input[name=__nextOwner_0_num]").val(getEmpId("IT22_backupManager",IT22_affiliation));
                $("input[name=__nextOwner_0]").val(getEmpId("IT22_backupManager",IT22_affiliation).split("(")[0]+";");
            }else if(noBackup == "false" || isBackups == "false"){//网络管理员
                var IT22_affiliation = $('[name=IT22_affiliation]').val();
                $("input[name=__nextNodeName_0]").val(nextActivityData[1].activityName);
                $("input[name=__nextNodeId_0]").val(nextActivityData[1].activityBpdId);
                $("input[name=__nextOwner_0_num]").val(getEmpId("IT22_network",IT22_affiliation));
                $("input[name=__nextOwner_0]").val(getEmpId("IT22_network",IT22_affiliation).split("(")[0]+";");
            }
        }else if((stepId == "200" || stepId == "500") && taskId != ""){ //备份管理员环节和基础设施环节设置下一处理人
            //保存资源交付环节处理人
            $("input[name=autoStepNum]").val(getEmpId("IT22_resourceDelivery","${IT22_affiliation}"));
            if(getEmpId("IT22_resourceDelivery","${IT22_affiliation}").split("(")[0]!=""){
                $("input[name=autoStepName]").val(getEmpId("IT22_resourceDelivery","${IT22_affiliation}").split("(")[0]+";");
            }
            $("input[name=__nextNodeName_0]").val(__nextNodeName_data_0[0].activityName);
            $("input[name=__nextNodeId_0]").val(__nextNodeName_data_0[0].activityBpdId);
            $("input[name=__nextOwner_0_num]").val($("input[name=__nextOwner_0_num]").val()+getEmpId("IT22_resourceDistribution","${IT22_affiliation}"));
            if(getEmpId("IT22_resourceDistribution","${IT22_affiliation}").split("(")[1]!=""){
                $("input[name=__nextOwner_0]").val($("input[name=__nextOwner_0]").val()+getEmpId("IT22_resourceDistribution","${IT22_affiliation}").split("(")[0]+";");
            }
            //获取邮件通知人员邮件地址
            var __nextOwner_0_num=$("input[name=__nextOwner_0_num]").val();
            var email="";
            if(__nextOwner_0_num.indexOf(";")>=0){
                var __nextOwner_0_numArr=__nextOwner_0_num.split(";");
                for(var i=0;i<__nextOwner_0_numArr.length;i++){
                    if(__nextOwner_0_numArr[i]!=""){
                        email+=getEmil(__nextOwner_0_numArr[i]);
                    }
                }
            }else{
                email=getEmil(__nextOwner_0_num);
            }
            $("input[name=save_MailInform]").val(email);
            //获取当前提交时间
            $("input[name=time]").val(new Date().format("yyyy年MM月dd日 hh时mm分ss秒"));
        }else if(stepId == "300" && taskId != ""){
            var noBackup = $('[name=noBackup]').val();
            if(noBackup != "true"){
                $("input[name=__nextNodeName_0]").val(nextActivityData[0].activityName);
                $("input[name=__nextNodeId_0]").val(nextActivityData[0].activityBpdId);
                $("input[name=__nextOwner_0_num]").val(getEmpId("IT22_network","${IT22_affiliation}"));
                $("input[name=__nextOwner_0]").val(getEmpId("IT22_network","${IT22_affiliation}").split("(")[0]+";");
            }else{
                $("input[name=__nextNodeName_0]").val(nextActivityData[0].activityName);
                $("input[name=__nextNodeId_0]").val(nextActivityData[0].activityBpdId);
                $("input[name=__nextOwner_0_num]").val(getEmpId("IT22_backupManager","${IT22_affiliation}"));
                $("input[name=__nextOwner_0]").val(getEmpId("IT22_backupManager","${IT22_affiliation}").split("(")[0]+";");
            }
        }else if(stepId == "400" && taskId != ""){
            getServerData();
            $("input[name=__nextNodeName_0]").val(__nextNodeName_data_0[0].activityName);
            $("input[name=__nextNodeId_0]").val(__nextNodeName_data_0[0].activityBpdId);
            $("input[name=__nextOwner_0]").val(getMetadata("basedirector").split("(")[0]);
            $("input[name=__nextOwner_0_num]").val(getMetadata("basedirector"));
            //计算资源-新建或者计算资源-变更-网络变更
            if(stepId == "300" &&
                ("${IT22_resourceType}".indexOf("computingresource")>=0 &&
                    ("${IT22_applyType}".indexOf("newconstruction")>=0 ||
                        ("${IT22_applyType}".indexOf("alteration")>=0 && "${IT22_alterationType}".indexOf("networkchanges")>=0)))){
                addRowByIP();
            }
        }else if(stepId == "800" && taskId != ""){
            $("input[name=__nextOwner_0_num]").val($("input[name=__nextOwner_0_num]").val()+getEmpId("IT22_resourceDelivery","${IT22_affiliation}"));
            if(getEmpId("IT22_resourceDelivery","${IT22_affiliation}").split("(")[0]!=""){
                $("input[name=__nextOwner_0]").val($("input[name=__nextOwner_0]").val()+getEmpId("IT22_resourceDelivery","${IT22_affiliation}").split("(")[0]+";");
            }
            //填充资源交付表格
            if("${status}"!="true"){
                var jsonArr=dynamicRowsIdON_ctrl.getDataObj();
                dynamicRowsIdCE_ctrl.removeAllRow();
                for(i=0;i<jsonArr.length;i++){
                    dynamicRowsIdCE_ctrl.addRow();
                    var trobj=$("#dynamicRowsIdCE tbody tr:eq("+i+")");
                    $(trobj).find("[name^=IT22_applicationOfAffiliation]").val(jsonArr[i].IT22_applicationOfAffiliation);//所属应用
                    $(trobj).find("[name^=IT22_applicationEnvironment]").find("option[value='"+jsonArr[i].IT22_applicationEnvironment+"']").attr("selected",true);//应用环境
                    $(trobj).find("[name^=IT22_applicationEnvironmentText]").val(jsonArr[i].IT22_applicationEnvironmentText);//应用环境保存text
                    $(trobj).find("[name^=IT22_useAndFunction]").find("option[value='"+jsonArr[i].IT22_useAndFunction+"']").attr("selected",true);//用途/功能选中
                    $(trobj).find("[name^=IT22_useAndFunctionText]").val(jsonArr[i].IT22_useAndFunctionText);//用途/功能保存text
                    $(trobj).find("[name^=IT22_hostName]").val(jsonArr[i].IT22_hostName.toUpperCase());//主机名后5位
                    $(trobj).find("[name^=IT22_operatingSystem]").find("option[value='"+jsonArr[i].IT22_operatingSystem+"']").attr("selected",true);//操作系统选中
                    $(trobj).find("[name^=IT22_operatingSystemText]").val(jsonArr[i].IT22_operatingSystemText);//操作系统保存text
                    $(trobj).find("[name^=IT22_OS]").val(jsonArr[i].IT22_OS);//操作系统(其他)
                    $(trobj).find("[name^=IT22_region]").val(jsonArr[i].IT22_region);//域
                    $(trobj).find("[name^=IT22_CPU]").find("option[value='"+jsonArr[i].IT22_CPU+"']").attr("selected",true);//CPU(vCPU) 选中
                    $(trobj).find("[name^=IT22_CPUText]").val(jsonArr[i].IT22_CPUText);//CPU(vCPU) 保存Text
                    $(trobj).find("[name^=IT22_memory]").val(jsonArr[i].IT22_memory);//内存(G)
                    $(trobj).find("[name^=IT22_drive1]").val(jsonArr[i].IT22_drive1);//磁盘1
                    $(trobj).find("[name^=IT22_drive2]").val(jsonArr[i].IT22_drive2);//磁盘2
                    $(trobj).find("[name^=IT22_drive3]").val(jsonArr[i].IT22_drive3);//磁盘3
                    $(trobj).find("[name^=IT22_drive4]").val(jsonArr[i].IT22_drive4);//磁盘4
                    $(trobj).find("[name^=IT22_drive5]").val(jsonArr[i].IT22_drive5);//磁盘5
                    $(trobj).find("[name^=IT22_drive6]").val(jsonArr[i].IT22_drive6);//磁盘6
                    $(trobj).find("[name^=IT22_drive7]").val(jsonArr[i].IT22_drive7);//磁盘7
                    $(trobj).find("[name^=IT22_drive8]").val(jsonArr[i].IT22_drive8);//磁盘8
                    $(trobj).find("[name^=IT22_drive9]").val(jsonArr[i].IT22_drive9);//磁盘9
                    $(trobj).find("[name^=IT22_drive10]").val(jsonArr[i].IT22_drive10);//磁盘10
                    $(trobj).find("[name^=IT22_drive11]").val(jsonArr[i].IT22_drive11);//磁盘11
                    $(trobj).find("[name^=IT22_drive12]").val(jsonArr[i].IT22_drive12);//磁盘12
                }
                //$("input[name=status]").val("true");
            }
            var htr= $("#dynamicRowsIdCE tbody tr");
            for(i=0;i<htr.length;i++){
                selectQT(htr[i]);
            }
            //获取邮件通知人员邮件地址
            var __nextOwner_0_num=$("input[name=__nextOwner_0_num]").val();
            var email="";
            if(__nextOwner_0_num.indexOf(";")>=0){
                var __nextOwner_0_numArr=__nextOwner_0_num.split(";");
                for(var i=0;i<__nextOwner_0_numArr.length;i++){
                    if(__nextOwner_0_numArr[i]!=""){
                        email+=getEmil(__nextOwner_0_numArr[i]);
                    }
                }
            }else{
                email=getEmil(__nextOwner_0_num);
            }
            $("input[name=save_MailInform]").val(email);
            //获取当前提交时间
            $("input[name=time]").val(new Date().format("yyyy年MM月dd日 hh时mm分ss秒"));
        }
    }

    //控制必要文件清单显示
    function controlFileShow(){
        var folder = $('[name^=folder]');
        $.each(folder,function(n,v){
            displayAttachment_dl0_(v,$(v).attr('name'));
        })
    }

    //判断当前登录人的职等是否有申请权限
    function getPosition(ad){
        var istrue = 0
        var sql = "select 1 from dual where EXISTS(SELECT 1 FROM AAC_EMPLOYEE WHERE POSITIONLEVEL LIKE '1%' AND AD = '"+ad+"') "
            +"or EXISTS(SELECT 1 FROM DAT_SYSTEM_META d WHERE d.META_CATA_ID = (SELECT CATA_ID FROM DAT_SYSTEM_META_CATA WHERE CATA_NAME = 'IT22_applyMan') and META_VALUE='"+ad+"')";
        $.ajax({
            url : '${pageContext.request.contextPath}/bpmportal/sysmetadatacontroller/getNetadataBySql.action',
            async : false,
            type : "post",
            data : {
                sql : sql
            },
            dataType : "json",
            success : function (result) {
                if(result.length>0){
                    istrue=1
                }
            },
            error : function (XMLHttpRequest, textStatus, errorThrown) {
                returnVal = 'error';
            }
        });
        return istrue;
    }

    //验证盘符大小只能小于等于128G
    function driveSize(obj){
    }

    //验证IP地址
    function f_check_IP(obj){
        var ip = obj.value;
        var re=/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/;//正则表达式
        if(re.test(ip)){
            if( RegExp.$1<256 && RegExp.$2<256 && RegExp.$3<256 && RegExp.$4<256)
                return true;
        }
        alert("IP输入有误");
        obj.value="";
    }

    //验证是否为整数
    function isInteger(obj) {
        var value=obj.value;
        if(value%1 === 0){
            return true;
        }
        alert("请输入整数");
        obj.value="";
    }

    //字母转为大写
    function tolocaleUpperCase(obj){
        obj.value=obj.value.toUpperCase();
    }

    //权限改变事件
    function accountChange(obj) {
        var val = obj.value;
        if (val) {
            if (val.indexOf("aac") != -1 || val.indexOf("-") != 1) {
                $(obj).css("border-color","red");
                alert('账号格式有误，请重新填写');
            }
        }
    }

    //权限改变事件
    function rightChange(obj) {
        $(obj).parent().find('[name^=hid_right]').val($(obj).find('option:selected').text());
    }

    //归纳a-账号
    function collectAccount() {
        var account = $('#Aaccount').find('[name^=account]');
        var zhanghao = '';
        for (var i = 0 ; i < account.length; i++) {
            if (account[i].value) {
                zhanghao += account[i].value + ';';
            }
        }
        $('[name=IT22_guanlizhanghao]').val(zhanghao);
    }

    //修改input名
    function updateName(oldStr,newStr){
        $("#_bpmActivityMeta"+oldStr+"").find("#__nextNodeName_"+oldStr+"").attr("name","__nextNodeName_"+newStr+"");
        $("#_bpmActivityMeta"+oldStr+"").find("#__nextNodeId_"+oldStr+"").attr("name","__nextNodeId_"+newStr+"");
        $("#_bpmActivityMeta"+oldStr+"").find("#__nextOwner_"+oldStr+"").attr("name","__nextOwner_"+newStr+"");
        $("#_bpmActivityMeta"+oldStr+"").find("#__nextOwner_"+oldStr+"_num").attr("name","__nextOwner_"+newStr+"_num");
    }

    //获取申请人岗位
    function getProposerPost(){
        var jobNumber="${employee.orgEmployee.jobNumber}";
        //获取员工信息
        $.post('${pageContext.request.contextPath}/portal/Personal_Z_BPM_HR_GET_INFO.action',
            {
                jobNumber:jobNumber
            },function(data){
                $("input[name=IT22_ziwei]").val(data.ZGZGW);
            },"json");
    }

    //获取邮件地址
    function getEmil(nextOwnerNum){
        var email="";
        if(nextOwnerNum!=""){
            var emp_id=nextOwnerNum;
            var emp_idArry=emp_id.split("(");
            var empNum_x=emp_idArry[1].replace(")","");
            $.ajax({
                url : '${pageContext.request.contextPath}/portal/getMailAddress.action',
                async : false,
                type : "POST",
                data:{empId:empNum_x},
                dataType : "json",
                success : function(data) {
                    email=data.email+";";
                }
            });
        }
        return email;
    }

    //获取树节点所有元数据
    function getMetadata(nodeName){
        var handler="";
        $.ajax({
            url : '${pageContext.request.contextPath}/console/systemMeta/getMetaByNodeName.action',
            type : "post",
            async:false,
            data : {'nodeName':"IT22_ISSup"},
            dataType : "json",
            success : function(data) {
                if(data.state==true){
                    for(i=0;i<data.data.length;i++){
                        if(nodeName==data.data[i].metaName){
                            handler=data.data[i].eaa1;
                        }
                    }
                }
            }
        });
        return handler;
    }

    //选择工厂
    function selectIT22_yyszcq(obj){
        $("input[name=IT22_yyszcqText]").val(obj.options[obj.selectedIndex].text);
    }

    //选中地区带出厂区
    function selectIT22_affiliation(value){
        var IT22_resourceType=$("input[name='IT22_resourceType']");
        if(value=="1004"||value=="1001"||value=="1008"||value=="1007"||value=="1023"){
            $(IT22_resourceType[1]).show();
            $(IT22_resourceType[1]).next().show();
        }else{
            $(IT22_resourceType[1]).removeAttr("checked");
            $(IT22_resourceType[1]).hide();
            $(IT22_resourceType[1]).next().hide();
        }
        clickIT22_resourceType(IT22_resourceType);
        $.ajax({
            url:'${pageContext.request.contextPath}/console/systemMeta/getMetaByWfCode.action',
            type : "post",
            async:false,
            data:{
                nodeName:value,
                wfCode:'${__wfcode}'
            },
            dataType : "json",
            success : function(data) {
                if(data.state==true){
                    var IT22_yyszcq=$("select[name=IT22_yyszcq]");
                    IT22_yyszcq.empty();
                    IT22_yyszcq.append("<option value=''></option>");
                    for(i=0;i<data.data.length;i++){
                        IT22_yyszcq.append("<option value='"+data.data[i].metaName+"'>"+data.data[i].metaValue+"</option>");
                    }
                    $(IT22_yyszcq).find("option[value='"+"${IT22_yyszcq}"+"']").attr("selected",true);
                    logic();
                }
            }
        });
    }

    //控制加载动态表格
    function queryTable(value){
        if(value.indexOf("computingresource")>=0){
            $("#on").show();
            $("#ce").show();
            $("#ne").show();
            if (stepId!='' && stepId!=1 && stepId!=200 && ("${IT22_applyType}".indexOf("newconstruction")>=0 || ("${IT22_applyType}".indexOf("alteration")>=0 && "${IT22_alterationType}".indexOf("networkchanges")>=0))) {
                $('#networkInfo').show();
            } else {
                $('#networkInfo').hide();
            }
            $("#ds").hide();
        }else if(value.indexOf("backupresources")>=0){
            $("#ds").show();
            $("#on").hide();
            $("#ce").hide();
            $("#ne").hide();
        }else{
            $("#on").hide();
            $("#ce").hide();
            $("#ne").hide();
            $("#ds").hide();
        }
    }

    //选中申请资源类型事件
    function clickIT22_resourceType(obj){
        //申请资源类型
        var IT22_resourceType=$("input[name='IT22_resourceType']");
        if(obj.value!=undefined){
            IT22_resourceType.each(function(){
                if($(this).val()==obj.value){
                    $(this).attr("checked",true);
                }else{
                    $(this).attr("checked",false);
                }
            })
        }

        var IT22_affiliation = $('[name=IT22_affiliation]').val();


        //如果计算资源不是备份资源
        if(IT22_resourceType[0].checked&&IT22_resourceType[1].checked==false){
            $('input[name=isBackups]').val("false");
            $("#on").show();
            $("#ce").show();
            $("#ne").show();
            $("#ds").hide();
            $("#jisuanTip").show();
        }else if(IT22_resourceType[0].checked==false&&IT22_resourceType[1].checked){
            $('input[name=isBackups]').val("true");
            $("#ds").show();
            $("#on").hide();
            $("#ce").hide();
            $("#ne").hide();
            $("#jisuanTip").hide();
        }else if(IT22_resourceType[0].checked&&IT22_resourceType[1].checked){
            $("#on").show();
            $("#ce").show();
            $("#ne").show();
            $("#ds").show();
            $("#jisuanTip").show();
        }else{
            $("#on").hide();
            $("#ce").hide();
            $("#ne").hide();
            $("#ds").hide();
            $("#jisuanTip").hide();
        }
        $('#networkInfo').hide();
        logic();
        setNextNode();
    }

    //选中申请类型事件
    function clickIT22_applyType(obj){
        var IT22_applyType=$("input[name='IT22_applyType']");
        IT22_applyType.each(function(){
            if($(this).val()==obj.value){
                $(this).attr("checked",true);
            }else{
                $(this).attr("checked",false);
            }
        })
        logic();
    }

    //选中变更类型事件
    function clickIT22_alterationType(obj){
        logic();
    }

    //判断申请类型逻辑
    function logic(){
        //申请资源类型
        var IT22_resourceType=$("input[name='IT22_resourceType']");
        //申请类型
        var IT22_applyType=$("input[name='IT22_applyType']");
        //变更类型
        var IT22_alterationType=$("input[name='IT22_alterationType']");
        //如果是计算资源不是备份资源
        if(IT22_resourceType[0].checked&&IT22_resourceType[1].checked==false){
            $("#IT22_applyType").show();
            //如果是新增不是变更
            if(IT22_applyType[0].checked&&IT22_applyType[1].checked==false){
                $("#IT22_alterationType").hide();
            }
            //如果不是新增是变更
            else if(IT22_applyType[0].checked==false&&IT22_applyType[1].checked){
                $("#IT22_alterationType").show();
            }else{
                $("#IT22_alterationType").hide();
            }
        }
        //如果不是计算资源是备份资源
        else if(IT22_resourceType[1].checked&&IT22_resourceType[0].checked==false){
            $("#IT22_applyType").hide();
            $("#IT22_alterationType").hide();
        }
        //如果未选中计算资源和备份资源
        else{
            $("#IT22_applyType").hide();
            $("#IT22_alterationType").hide();
        }
    }

    //获取管理员确认处理人
    function getAdministrator(){
        //申请资源类型
        var IT22_resourceType="${IT22_resourceType}";
        //申请类型
        var IT22_applyType="${IT22_applyType}";
        //变更类型
        var IT22_alterationType="${IT22_alterationType}";
        //如果未选中计算资源选中了备份资源
        //如果计算资源不是备份资源
        if(IT22_resourceType[0].checked&&IT22_resourceType[1].checked==false){
            //控制环节隐藏
            $('#_bpmActivityMeta0').hide();
            $('#_bpmActivityMeta1').show();
            $('#_bpmActivityMeta2').show();

            //网络信息管理员
            $("input[name=__nextOwner_1_num]").val(getEmpId("IT22_network",IT22_affiliation));
            $("input[name=__nextOwner_1]").val(getEmpId("IT22_network",IT22_affiliation).split("(")[0]+";");
            //资源管理员
            $("input[name=__nextOwner_2_num]").val(getEmpId("IT22_resource",IT22_affiliation));
            $("input[name=__nextOwner_2]").val(getEmpId("IT22_resource",IT22_affiliation).split("(")[0]+";");

            $('input[name=isBackups]').val("false");
            $("#on").show();
            $("#ce").show();
            $("#ne").show();
            $("#ds").hide();
            $("#jisuanTip").show();
        }else if(IT22_resourceType[0].checked==false&&IT22_resourceType[1].checked){
            //控制并行环节隐藏
            $('#_bpmActivityMeta0').show();
            $('#_bpmActivityMeta1').hide();
            $('#_bpmActivityMeta2').hide();

            $("input[name=__nextOwner_0_num]").val(getEmpId("IT22_backupManager",IT22_affiliation));
            $("input[name=__nextOwner_0]").val(getEmpId("IT22_backupManager",IT22_affiliation).split("(")[0]+";");

            $('#input[name=isBackups]').val("true");
            $("#ds").show();
            $("#on").hide();
            $("#ce").hide();
            $("#ne").hide();
            $("#jisuanTip").hide();
        }else if(IT22_resourceType[0].checked&&IT22_resourceType[1].checked){
            $("#on").show();
            $("#ce").show();
            $("#ne").show();
            $("#ds").show();
            $("#jisuanTip").show();
        }else{

            $("input[name=__nextOwner_0_num]").val("");
            $("input[name=__nextOwner_0]").val("");

            $("#on").hide();
            $("#ce").hide();
            $("#ne").hide();
            $("#ds").hide();
            $("#jisuanTip").hide();
        }
    }

    //获取角色指定地区的empId
    function getEmpId(roleCode,diqusave){
        var personnel="";
        $.ajax({
            url : '${pageContext.request.contextPath}/portal/getEmployeeFromRole.action',
            type : "post",
            async:false,
            data : {'roleCode':roleCode,'district':diqusave},
            dataType : "json",
            success : function(data) {
                if(data.length>0){
                    personnel=data[0].empName+"("+data[0].empNum+");";
                }
            }
        });
        return personnel;
    }

    //应用环境选择事件
    function IT22_applicationEnvironmentSelect(tr){
        $(tr).find("[name^=IT22_applicationEnvironmentText]").val($(tr).find("[name^=IT22_applicationEnvironment]").find("option:selected").text());
    }

    //用途/功能选择事件
    function IT22_useAndFunctionSelect(tr){
        $(tr).find("[name^=IT22_useAndFunctionText]").val($(tr).find("[name^=IT22_useAndFunction]").find("option:selected").text());
    }

    //主机名后5位改变事件
    function hostNameChange(obj) {
        var hostName = $('#dynamicRowsIdON').find('[name^=IT22_hostName]');
        $.each(hostName, function(i, h) {
            if (obj.value==h.value && obj!=h) {
                alert('【主机名后5位】不允许重复！');
                obj.value = '';
                return false;
            }
        });
    }

    //CPU(vCPU)选择事件
    function IT22_CPUSelect(tr){
        $(tr).find("[name^=IT22_CPUText]").val($(tr).find("[name^=IT22_CPU]").find("option:selected").text());
    }

    //选择行项目中操作系统如果是windows 默认为aac.com 否则为空
    function IT22_operatingSystemSelect(tr){
        var value=$(tr).find("[name^=IT22_operatingSystem]").find("option:selected").val();
        if(value=="windowsx64sp"||value=="windowsx64"||value=="ws2016"){
            $(tr).find("[name^=IT22_region]").val("aac.com");
            $(tr).find("[name^=IT22_drive1]").val("C:100");
            $(tr).find("[name^=IT22_drive1]").prop("readonly", true);
            //$(tr).find("[name^=IT22_drive2]").val("D:100");
            $(tr).find("[name^=IT22_drive2]").val("P:50");
            $(tr).find("[name^=IT22_drive2]").prop("readonly", true);
            var jsonArr=dynamicRowsIdON_ctrl.getDataObj();
            var index=$(tr).index();
            $(tr).find("[name^=IT22_drive10]").val(jsonArr[index].IT22_drive10);
            $(tr).find("[name^=IT22_drive11]").val(jsonArr[index].IT22_drive11);
            $(tr).find("[name^=IT22_drive12]").val(jsonArr[index].IT22_drive12);
        }else{
            $(tr).find("[name^=IT22_drive1]").val("100");
            $(tr).find("[name^=IT22_drive1]").prop("readonly", true);
            $(tr).find("[name^=IT22_drive2]").val("");
            $(tr).find("[name^=IT22_drive3]").val("");
            $(tr).find("[name^=IT22_region]").val("");
            var jsonArr=dynamicRowsIdON_ctrl.getDataObj();
            var index=$(tr).index();
            $(tr).find("[name^=IT22_drive10]").val(jsonArr[index].IT22_drive10);
            $(tr).find("[name^=IT22_drive11]").val(jsonArr[index].IT22_drive11);
            $(tr).find("[name^=IT22_drive12]").val(jsonArr[index].IT22_drive12);
        }
        selectQT(tr);
        $(tr).find("[name^=IT22_operatingSystemText]").val($(tr).find("[name^=IT22_operatingSystem]").find("option:selected").text());
    }

    //选择其他操作系统隐藏文本框
    function selectQT(tr){
        var value=$(tr).find("[name^=IT22_operatingSystem]").find("option:selected").val();
        //如果是其他
        if(value=="qt"){
            $(tr).find("[name^=IT22_OS]").show();
        }else{
            $(tr).find("[name^=IT22_OS]").hide();
        }
    }

    //动态表格的必填提示
    function addisDcyNull(arrname,arrmsg,htr,error){
        var i=0;
        var j=0;
        var jq;
        var jqv;
        var msg1 = "";
        for(i=0;i<htr.length;i++){
            //获取该行数据
            var th=$(htr[i]);
            for(j=0;j<arrname.length;j++){
                //循环获取该行所属应用，主机名后五位，内存（G）数据
                jqv = $(th.find("[name^="+arrname[j]+"]"));
                if(jqv[0]!=undefined){
                    var tagName = jqv[0].tagName;

                    var value = "";
                    var msg = "";
                    //如果是select标签
                    if(tagName=="SELECT"){
                        value = jqv.val();
                        if(value==""||value==undefined){
                            $(jqv).css("border-color","red");
                        }else{
                            $(jqv).css("border-color","");
                        }
                    }else if(tagName=="INPUT"){//如果是input标签
                        var type = jqv.attr("type");
                        if(type=="text"||type=="hidden"){
                            value = jqv.val();
                            if(value==""||value==undefined){
                                $(jqv).css("border-color","red");
                            }else{
                                $(jqv).css("border-color","");
                                //主机后五位校验
                                if(arrname[j]=='IT22_hostName'){
                                    var IT22_hostName=jqv.val();
                                    if(IT22_hostName.length!=5){
                                        error += "第"+(i-2)+"行的主机名后五位填写错误<br/>";
                                        msg1 += "第"+(i-2)+"行的主机名后五位填写错误<br/>";
                                        $(jqv).css("border-color","red");
                                    }
                                }
                            }
                        }


                    }else if(tagName=="TEXTAREA"){
                        value = jqv.val();
                        if(value==""||value==undefined){
                            $(jqv).css("border-top-color","red");
                            $(jqv).css("border-left-color","red");
                            $(jqv).css("border-right-color","red");
                            $(jqv).css("border-bottom-color","red");
                        }else{
                            $(jqv).css("border-top-color","");
                            $(jqv).css("border-left-color","");
                            $(jqv).css("border-right-color","");
                            $(jqv).css("border-bottom-color","");
                        }
                    }
                    if(value==""||value==undefined){
                        msg1+=msg+"第"+(i+1)+"行【"+arrmsg[j]+"】<br/>";
                    }
                }
            }
        }
        if(msg1!=""){
            return error;
        }
        return msg1;
    }

    //管理帐号&权限复选框全选
    function allAaccountChecked() {
        var isChecked = $("#selAllAaccount").prop("checked");
        var checkeds = $("input[name^=aselme]");
        if (isChecked) {
            $.each(checkeds, function(i, e) {
                $(e).prop("checked", true);
            });
        } else {
            $.each(checkeds, function(i, e) {
                $(e).prop("checked", false);
            });
        }
    }

    //获取并填充服务器数据
    function getServerData() {
        var hostname = $('#dynamicRowsIdON').find('[name^=IT22_hostName]');
        var server = $('#networkInfo').find('[name^=server]');
        for (var i = 0; i < hostname.length; i++) {
            if (hostname[i].value) {
                hostoption += "<option values='" + hostname[i].value + "'>" + hostname[i].value + "</option>";
            }
        }
        $('#networkInfo').find('[name^=server]').html(hostoption);
        setServer();
    }

    //网络信息-用途改变事件
    function useforChange(obj) {
        if (obj.value != 'dvs_data') {
            $(obj).parent().parent().find('[name^=gateway]').val('-');
            $(obj).parent().parent().find('[name^=gateway]').prop('readonly', true);
        } else {
            if ($(obj).parent().parent().find('[name^=gateway]').val() == '-') {
                $(obj).parent().parent().find('[name^=gateway]').val('');
            }
            $(obj).parent().parent().find('[name^=gateway]').prop('readonly', false);
        }
        if (obj.value != 'dvs_cluster') {
            var alluse = $('#networkInfo').find('[name^=usefor]');
            var allserver = $('#networkInfo').find('[name^=server]');
            var thisServer = $(obj).parent().parent().find('[name^=server]').val();
            msg = '';
            dataNum = 0;
            backupNum = 0;
            heartbeatNum = 0;
            for (var i = 0; i < alluse.length; i++) {
                if (allserver[i].value == thisServer) {
                    switch (alluse[i].value) {
                        case 'dvs_data': dataNum++;break;
                        case 'dvs_backup': backupNum++;break;
                        case 'dvs_heart_beat': heartbeatNum++;break;
                    }
                }
            }
            if (obj.value=='dvs_data' && dataNum!=1) {
                msg += '主机名：' + thisServer + '【网络信息-受理信息-用途】有且必须选择一行“数据”';
            }
            if (obj.value=='dvs_backup' && backupNum>1) {
                msg += '主机名：' + thisServer + '【网络信息-受理信息-用途】最多只能选择一行“备份”';
            }
            if (obj.value=='dvs_heart_beat' && heartbeatNum>1) {
                msg += '主机名：' + thisServer + '【网络信息-受理信息-用途】最多只能选择一行“心跳”';
            }
            if (msg) {
                alert(msg);
                obj.value = '';
                return false;
            }
        }
        return true;
    }

    //归纳服务器
    function collectServer() {
        var server = $('#networkInfo').find('[name^=server]');
        var hid_server = $('#networkInfo').find('[name^=hid_server]');
        var usefor = $('#networkInfo').find('[name^=usefor]');
        var hid_usefor = $('#networkInfo').find('[name^=hid_usefor＃]');
        var hid_usefor_value = $('#networkInfo').find('[name^=hid_usefor_value]');
        for (var i = 0; i < server.length; i++) {
            hid_server[i].value = server[i].value;
            hid_usefor[i].value = $(usefor[i]).find('option:selected').text();
            hid_usefor_value[i].value = $(usefor[i]).find('option:selected').val();
        }
    }

    //设置服务器
    function setServer() {
        var server = $('#networkInfo').find('[name^=server]');
        var hid_server = $('#networkInfo').find('[name^=hid_server]');
        for (var i = 0; i < server.length; i++) {
            server[i].value = hid_server[i].value;
        }
    }

    //网络信息-用途必填校验
    function checkUsefor() {
        var hostname = $('#dynamicRowsIdON').find('[name^=IT22_hostName]');
        var allserver = $('#networkInfo').find('[name^=server]');
        var alluse = $('#networkInfo').find('[name^=usefor]');
        msg = '';
        for (var i = 0; i < hostname.length; i++) {
            dataNum = 0;
            backupNum = 0;
            heartbeatNum = 0;
            for (var j = 0; j < alluse.length; j++) {
                if (hostname[i].value == allserver[j].value) {
                    switch (alluse[j].value) {
                        case 'dvs_data': dataNum++;break;
                        case 'dvs_backup': backupNum++;break;
                        case 'dvs_heart_beat': heartbeatNum++;break;
                    }
                }
            }
            if (dataNum != 1) {
                msg += '主机名：' + hostname[i].value + '【网络信息-受理信息-用途】有且必须有一行数据<br />';
            }
            if (backupNum > 1) {
                msg += '主机名：' + hostname[i].value + '【网络信息-受理信息-用途】有则只能有一行备份<br />';
            }
            if (heartbeatNum > 1) {
                msg += '主机名：' + hostname[i].value + '【网络信息-受理信息-用途】有则只能有一行心跳<br />';
            }
        }
        return msg;
    }

    //信息封装
    function msgPackaging(type){
        var vms = [];
        var server = $('#networkInfo').find('[name^=hid_server]');//服务器
        var ip = $('#networkInfo').find('[name^=ip]');//IP
        var mask = $('#networkInfo').find('[name^=mask]');//掩码
        var gateway = $('#networkInfo').find('[name^=gateway]');//网关
        var vlan = $('#networkInfo').find('[name^=vlan]');//VLAN
        var usefor = $('#networkInfo').find('[name^=hid_usefor_value]');//用途
        var IT22_applicationOfCategory = $('#dynamicRowsIdON').find('[name^=IT22_applicationOfCategory]');//所属领域
        var IT22_applicationOfAffiliation = $('#dynamicRowsIdON').find('[name^=IT22_applicationOfAffiliation]');//所属应用
        var IT22_applicationEnvironmentText = $('#dynamicRowsIdON').find('[name^=IT22_applicationEnvironmentText]');//应用环境
        var IT22_useAndFunctionText = $('#dynamicRowsIdON').find('[name^=IT22_useAndFunctionText]');//用途/功能
        var IT22_hostName = $('#dynamicRowsIdON').find('[name^=IT22_hostName]');//主机名后5位
        var IT22_operatingSystemText = $('#dynamicRowsIdON').find('[name^=IT22_operatingSystemText]');//操作系统
        var IT22_CPUText = $('#dynamicRowsIdON').find('[name^=IT22_CPUText]');//CPU(vCPU)
        var IT22_memory = $('#dynamicRowsIdON').find('[name^=IT22_memory]');//内存(G)
        var IT22_region = $('#dynamicRowsIdON').find('[name^=IT22_region]');//域
        for (var i = 0; i < IT22_hostName.length; i++) {
            var vm = {};
            vm.vm_name = encodeURI(IT22_hostName[i].value);
            vm.env = encodeURI(IT22_applicationEnvironmentText[i].value);
            vm.usage = encodeURI(IT22_useAndFunctionText[i].value);
            var IT22_drive = $('#dynamicRowsIdON tbody tr:eq(' + i + ')').find('[name^=IT22_drive]');//磁盘
            var driverArr = [];
            for (var j = 0; j < IT22_drive.length; j++) {
                if (IT22_drive[j].value) {
                    driverArr.push(IT22_drive[j].value.replace(/[^0-9]/g,''));
                }
            }
            vm.data_disk_size = encodeURI(driverArr.toString());
            vm.template = encodeURI(IT22_operatingSystemText[i].value);
            vm.cpu_cores = encodeURI(IT22_CPUText[i].value);
            vm.memory = encodeURI(IT22_memory[i].value);
            vm.domain = encodeURI(IT22_region[i].value);
            if(type != "check"){
                //用于自动化创建
                vm.belong_field = encodeURI(IT22_applicationOfCategory[i].value);
                vm.belong_app = encodeURI(IT22_applicationOfAffiliation[i].value);
                var nic_data = [];
                for (var j = 0; j < server.length; j++) {
                    if (IT22_hostName[i].value == server[j].value) {
                        var nic = {};
                        nic.ip = encodeURI(ip[j].value);
                        nic.mask = encodeURI(mask[j].value);
                        nic.gateway = encodeURI(gateway[j].value=='-'?'':gateway[j].value);
                        nic.vlan_id = encodeURI(vlan[j].value);
                        nic.net_type = encodeURI(usefor[j].value);
                        nic_data.push(nic);
                    }
                }
                vm.nic_data = nic_data;
            }
            vms.push(vm);
        }
        return vms;
    }

    //校验是否自动化创建
    function checkAuto(){
        var ad_users = [];
        var ad_user_types = [];
        var account = $('#Aaccount').find('[name^=account]');
        var right = $('#Aaccount').find('[name^=right]');
        for (var i = 0; i < account.length; i++) {
            ad_users.push(account[i].value);
            ad_user_types.push(right[i].value);
        }
        var vms = msgPackaging("check");
        url = "http://bkpaas4.aac.com:80/api/c/self-service-api/validate_first_time_test/";
        var data = {
            'applicant_name':$('[name=empName]').val(),
            'bk_app_code': 'auto-delivery',
            'bk_app_secret': 'dec773d4-8bfa-4e71-99ad-8bdb9ed3bef7',
            'bk_username': 'BPM',
            'ad_user_types': encodeURI(ad_user_types.toString()),
            'ad_users': encodeURI(ad_users.toString()),
            'location': encodeURI($('[name=IT22_affiliation]').children('option:selected').text()),
            'factory': encodeURI($('[name=IT22_yyszcq]').children('option:selected').text()),
            'vms': vms
        };
        $.messager.progress({
            title: '校验中',
            msg: '校验中...'
        });
        $.ajax({
            url: '${pageContext.request.contextPath}/IT22/doPost.action',
            type: 'post',
            data: {
                url: url,
                data: JSON.stringify(data)
            },
            dataType : 'json',
            success : function(result) {
                $('[name=isPass]').val(result.result);
                if (!result.pass) {
                    alert(result.message);
                }else{
                    first = "true";
                    $("#btnSubmit").click();
                }
                $.messager.progress("close");
            }
        });
    }

    function autoCreate(){
        var ad_users = [];
        var ad_user_types = [];
        var account = $('#Aaccount').find('[name^=account]');
        var right = $('#Aaccount').find('[name^=right]');
        for (var i = 0; i < account.length; i++) {
            ad_users.push(account[i].value);
            ad_user_types.push(right[i].value);
        }
        var vms = msgPackaging("create");
        var data = {
            'applicant_name':$('[name=empName]').val(),
            'bpm_no':$('[name=orderNum]').text(),
            'bk_app_code': 'auto-delivery',
            'bk_app_secret': 'dec773d4-8bfa-4e71-99ad-8bdb9ed3bef7',
            'bk_username': 'BPM',
            'docid': '${__docuid}',
            'it_url': window.location.pathname,
            'it_no': '${orderNum}',
            'appler': encodeURI('${empName}'),
            'emp_no': encodeURI('${IT22_employeeNumber}'),
            'ad_no': '${IT22_domainAccount}',
            'apply_date': '${createDate}',
            'ad_user_types': encodeURI(ad_user_types.toString()),
            'ad_users': encodeURI(ad_users.toString()),
            'mail_to': '${email}',
            'email': $("input[name=save_MailInform]").val(),
            'delivery_person': encodeURI($("input[name=autoStepName]").val()),
            'delivery_email': $("input[name=save_MailInform]").val(),
            'nagios_person': encodeURI(getEmpId("IT22_resourceDelivery","${IT22_affiliation}").split("(")[0].replace(/;/g,'')),
            'nagios_email': getEmil(getEmpId("IT22_resourceDelivery","${IT22_affiliation}").replace(/;/g,'')),
            'apply_resource_type': encodeURI($('[name=IT22_resourceType]').text()),
            'location': encodeURI($('[name=IT22_affiliation]').text()),
            'factory': encodeURI($('[name=IT22_yyszcqText]').text()),
            'vms': vms
        };
        $.ajax({
            url: '${pageContext.request.contextPath}/IT22/checkAutoCreate.action',
            type: 'post',
            data: {
                data: JSON.stringify(data)
            },
            dataType : 'json',
        });
    }

    //管理帐号&权限新增行
    function addAaccount() {
        var a = Aaccount_ctrl.addRow();
    }

    //管理帐号&权限删除行
    function delAaccount() {
        var selmeChkBox = $("[name^=aselme]:checked");
        $.each(selmeChkBox, function(index, item) {
            var rowgrpId = $(this).parents("tr[rowgroup]").attr("rowgroup");
            if (typeof rowgrpId != "undefined") {
                Aaccount_ctrl.removeRow(rowgrpId);
            }
        });
    }

    //网络信息-受理信息复选框全选
    function allNetworkInfoChecked() {
        var isChecked = $("#selAllNetworkInfo").prop("checked");
        var checkeds = $("input[name^=nselme]");
        if (isChecked) {
            $.each(checkeds, function(i, e) {
                $(e).prop("checked", true);
            });
        } else {
            $.each(checkeds, function(i, e) {
                $(e).prop("checked", false);
            });
        }
    }

    //网络信息-受理信息新增行
    function addNetworkInfo() {
        var a = networkInfo_ctrl.addRow();
        $(a).find('[name^=server]').html(hostoption);
        $(a).find('[name^=usefor]').val('');
    }

    //网络信息-受理信息删除行
    function delNetworkInfo() {
        var selmeChkBox = $("[name^=nselme]:checked");
        $.each(selmeChkBox, function(index, item) {
            var rowgrpId = $(this).parents("tr[rowgroup]").attr("rowgroup");
            if (typeof rowgrpId != "undefined") {
                networkInfo_ctrl.removeRow(rowgrpId);
            }
        });
    }

    //资源信息添加行
    function addResourcesON(){
        var tr=dynamicRowsIdON_ctrl.addRow();
        $(tr).find("select").find("option[value='']").attr("selected",true);
        IT22_operatingSystemSelect(tr);
    }

    //备份需求添加行
    function addrowDS(){
        var tr=dynamicRowsIdDS_ctrl.addRow();
        $(tr).find("select").find("option[value='']").attr("selected",true);
    }

    //资源信息删除行
    function removerowON(){
        var checkbox=$("#dynamicRowsIdON").find("input[name^=dianji]:checked");
        for(i=0;i<checkbox.length;i++){
            var tr=$(checkbox[i]).parent().parent();
            var rowgrpId=tr.attr("rowgroup");
            dynamicRowsIdON_ctrl.removeRow(rowgrpId);
        }
    }

    //资源交付删除行
    function removerowCE(){
        var checkbox=$("#dynamicRowsIdCE").find("input[name^=dianji]:checked");
        for(i=0;i<checkbox.length;i++){
            var tr=$(checkbox[i]).parent().parent();
            var rowgrpId=tr.attr("rowgroup");
            dynamicRowsIdCE_ctrl.removeRow(rowgrpId);
        }
    }

    //备份需求删除行
    function removerowDS(){
        var checkbox=$("#dynamicRowsIdDS").find("input[name^=dianji]:checked");
        for(i=0;i<checkbox.length;i++){
            var tr=$(checkbox[i]).parent().parent();
            var rowgrpId=tr.attr("rowgroup");
            dynamicRowsIdDS_ctrl.removeRow(rowgrpId);
        }
    }

    //资源信息选中所有
    function chlickON(obj){
        var checkbox=$("#dynamicRowsIdON").find("input[name^=dianji]");
        if(obj.value=="全选"){
            for(i=0;i<checkbox.length;i++){
                checkbox[i].checked=true;
            }
            obj.value="取消";
        }else{
            for(i=0;i<checkbox.length;i++){
                checkbox[i].checked=false;
            }
            obj.value="全选";
        }
    }

    //资源交付选中所有
    function chlickCE(obj){
        var checkbox=$("#dynamicRowsIdCE").find("input[name^=dianji]");
        if(obj.value=="全选"){
            for(i=0;i<checkbox.length;i++){
                checkbox[i].checked=true;
            }
            obj.value="取消";
        }else{
            for(i=0;i<checkbox.length;i++){
                checkbox[i].checked=false;
            }
            obj.value="全选";
        }
    }

    //备份需求选中所有
    function chlickDS(obj){
        var checkbox=$("#dynamicRowsIdDS").find("input[name^=dianji]");
        if(obj.value=="全选"){
            for(i=0;i<checkbox.length;i++){
                checkbox[i].checked=true;
            }
            obj.value="取消";
        }else{
            for(i=0;i<checkbox.length;i++){
                checkbox[i].checked=false;
            }
            obj.value="全选";
        }
    }

    //提交页面判断必填方法
    function judgeFun(){
        var msg="";
        var _bpmActivityMeta=$("div[id^='_bpmActivityMeta']");
        for(var i=0;i<_bpmActivityMeta.length;i++){
            if($(_bpmActivityMeta[i]).is(':visible')){
                if($(_bpmActivityMeta[i]).find("input[name^=__nextOwner]").val()==""){
                    if(msg==""){
                        msg+="下个处理人为空请联系管理员</br>";
                    }
                }
            }
        }
        //起草环节验证
        if(stepId==""||stepId=="1"){
            msg+=isNullAndTip("mobile","联系电话");
            msg+=isNullAndTip("email","电子邮件");

            var IT22_serUser = $('#IT22_serUser').val();
            var IT22_techUser = $('#IT22_techUser').val();
            if(IT22_serUser == "")msg+="请选择应用服务负责人<br>";
            if(IT22_techUser == "")msg+="请选择应用技术负责人<br>";

            var IT22_resourceType=$("[name=IT22_resourceType]");
            if(IT22_resourceType[0].checked) {
                collectAccount();
                msg+=addisDcyNull(['account','right'],['账号','权限'],$("#Aaccount tr"),"请完善【管理帐号&权限】<br/>");
                msg+=isNullAndTip("IT22_guanlizhanghao","管理帐号&权限");
                var account = $('[name^=account]');
                var msg_ = "";
                for(var i = 0;i<account.size();i++){
                    var accountText = account.eq(i).val();
                    if(accountText.indexOf("aac") != -1){
                        msg_ = "管理员账号格式有误<br/>";
                        account.eq(i).css("border-color","red");
                    }
                }
                msg += msg_;
            }
            msg+=isNullAndTip("IT22_affiliation","资源归属地区");
            msg+=isNullAndTip("IT22_yyszcq","应用所在厂区");
            msg+=isNullAndTip("IT22_resourceType","申请资源类型");
            msg+=isNullAndTip("IT22_applyType","申请类型");
            msg+=isNullAndTip("IT22_alterationType","变更类型");
            msg+=isNullAndTip("IT22_sqnrjiyy","申请内容及原因");
            if($('#ne').is(':visible')){
                msg+=isNullAndTip("IT22_wangnuoxxyonhuxuq","网络信息-用户需求");
            }
            //判断文件是否上传
            if($('[name=folder1]').length > 0 ){
                msg += "请上传《应用搭建SOP》文件<br>";
            }
            if($('[name=folder2]').length > 0 ){
                msg += "请上传《应用灾难恢复演练记录》文件<br>";
            }
            if($('[name=folder3]').length > 0 ){
                msg += "请上传《资源需求依据/计算方式》文件<br>";
            }
            if($('[name=folder4]').length > 0 ){
                msg += "请上传《网络数据流向图》文件<br>";
            }
            //资源信息验证必填
            if($('#on').is(':visible')){
                var arrname = ["IT22_applicationOfCategory","IT22_applicationOfAffiliation","IT22_hostName","IT22_memory"];
                var arrmsg = ["所属领域","所属应用 ","主机名后5位","内存(G)"];
                var htr = $("#dynamicRowsIdON tr");
                if(htr.length>3){
                    msg+=addisDcyNull(arrname,arrmsg,htr,"请完善资源信息<br/>");
                }else{
                    msg+="请填写资源信息<br/>";
                }
            }
            //验证备份资源必填
            if($('#ds').is(':visible')){
                var arrname = ["IT22_fuwuhuoyy","IT22_Hostname","IT22_shujuIP","IT22_operatingSystem","IT22_OSjibanben","IT22_backupObjects","IT22_route","IT22_backupCycle","IT22_backups","IT22_retentionCycle","IT22_backupWindow"];
                var arrmsg = ["服务或应用 ","Hostname","数据IP","用途/功能 ","OS及版本 ","备份对象 ","路径/实例","备份周期 ","备份方式 ","保存周期","备份窗口"];
                var htr = $("#dynamicRowsIdDS tr");
                if(htr.length>1){
                    msg+=addisDcyNull(arrname,arrmsg,htr,"请完善备份需求<br/>");
                }else{
                    msg+="请填写备份需求<br/>";
                }
                //判断备份IP
                var IT22_no = $('[name^=IT22_no]');
                var IT22_biefIP = $('[name^=IT22_biefIP]');
                $.each(IT22_biefIP,function(n,value){
                    if(!$(IT22_no).prop("checked")){
                        if($(value).val() == "" || $(value).val() == undefined){
                            msg += "第"+(n+1)+"行备份IP请完善<br>";
                        }
                    }
                })
            }
        }else if(stepId=="300"){//验证网络信息-受理信息
            //计算资源-新增 或 计算资源-变更-网络变更
            if ("${IT22_resourceType}".indexOf("computingresource")>=0 && ("${IT22_applyType}".indexOf("newconstruction")>=0 || ("${IT22_applyType}".indexOf("alteration")>=0 && "${IT22_alterationType}".indexOf("networkchanges")>=0))) {
                collectServer();
                msg += checkUsefor();
                msg += addisDcyNull(['server','ip','mask','gateway','vlan','usefor'],['服务器','IP','掩码','网关','VLAN','用途'],$("#networkInfo tr"),"请完善【网络信息-受理信息】<br/>");
            }
        }
        if(msg!=""){
            $.messager.alert({title:"必填提示",msg:msg});
            $("#btnSave").attr("disabled", false);
            $("#btnSubmit").attr("disabled", false);
            $("#btnRollback").attr("disabled", false);
            $("#btnRetake").attr("disabled", false);
            $("#btnTransfer").attr("disabled", false);
            $("#btnOverSign").attr("disabled", false);
            $("#btnPassby").attr("disabled", false);
            $("#btnWfstatus").attr("disabled", false);
            return false;
        }
        if(msg==""){
            $("#btnSave").attr("disabled", true);
            $("#btnSubmit").attr("disabled", true);
            $("#btnRollback").attr("disabled", true);
            $("#btnRetake").attr("disabled", true);
            $("#btnTransfer").attr("disabled", true);
            $("#btnOverSign").attr("disabled", true);
            $("#btnPassby").attr("disabled", true);
            $("#btnWfstatus").attr("disabled", true);
            return true;
        }
    }

    function uploadFile(obj){
        temp = obj;
        $('#upload').find("[type=file]").click();
    }

    function uploadXLS() {
        var uploader = WebUploader.create({
            // 选完文件后，是否自动上传。
            auto: true,
            // swf文件路径
            swf: '${pageContext.request.contextPath}/scripts/webuploader-0.1.5/Uploader.swf',
            // 文件接收服务端。
            server: '${pageContext.request.contextPath}/console/file/upload.action',
            // 选择文件的按钮。可选。
            // 内部根据当前运行是创建，可能是input元素，也可能是flash.
            pick: '#upload',
            // 只允许选择图片文件。
            resize: false,
            duplicate: true,
            formData:{'docUid':$("#__docuid").val(),'folder':"",'encrypt':"disabled"}
        });
        uploader.on('uploadBeforeSend', function (block, data) {
            data.folder = $(temp).attr("name");
        });
        // 文件上传过程中创建进度条实时显示。
        uploader.on('uploadProgress', function(file, percentage) {
            var win = $.messager.progress({
                title: '温馨提示',
                msg: '文件上传中，请稍后。。。'
            });
        });
        uploader.on('uploadSuccess', function(file, response) {
            $.messager.progress('close');
            displayAttachment_dl0_(temp,$(temp).attr("name"));
        });
        uploader.on('uploadError', function(file, reason) {
            $.messager.progress('close');
            alert('上传失败！');
        });
        uploader.on("error", function(type) {
            if (type == "Q_TYPE_DENIED") {
                $.messager.show({
                    title: '温馨提示',
                    msg: '导入请上传xls或者xslx类型，上传扫描件请选择pdf文件'
                });
            }
        });
    }

    function displayAttachment_dl0_(obj,folder){
        $.ajax({'url' : "/console/file/getDownloadAttachment.action",
            type : "post",
            data : {docUid:$('#__docuid').val(),
                folder:folder
            },
            dataType : "json",
            success : function(result) {
                if(result != null && result != "" && result != undefined) {
                    var html = "";
                    html += "<tr><td>"+result[0].fileName+"</td><td>"+result[0].attachmentFolder+"</td><td>";
                    if(stepId == "" || stepId == "1"){
                        html += "<a style='height:100%' href='javascript:void(0)' onclick=\" __delUploadAttachment_dl0('"+result[0].attachmentId+"')\">删除</a>&nbsp;"
                    }
                    html += "<a href=\"/console/file/download.action?attachmentId="+result[0].attachmentId+"\">下载</a></td></tr>";
                    $(obj).parent().html(html);
                }
            }
        });
    }

    function setAutoDist(obj){
        var value = $(obj).find('option:selected').text();
        var autoDist = $(obj).parents('tr').eq(0).find('[name^=IT22_autoDist]');
        if(value == "VMWare"){
            $(autoDist).val("是");
        }else{
            $(autoDist).val("否");
        }
    }

    function showIP(obj){
        var biefIP = $(obj).parents('tr').eq(0).find('[name^=IT22_biefIP]');
        if($(obj).prop("checked")){
            $(biefIP).val("");
            $(biefIP).prop("readonly","readonly");
        }else{
            $(biefIP).prop("readonly","");
        }
        setNextNode();
    }

    //网络信息-受理信息
    function addRowByIP(){
        var rows = $('#dynamicRowsIdON [rowgroup^=rowgrp]');
        //删除默认行
        $('[name=selAllNetworkInfo]').prop("checked","checked");
        allNetworkInfoChecked();
        delNetworkInfo();
        for(var i = 0 ; i < rows.length ; i++){
            var row = $(rows).eq(i);
            var IT22_ipNeed = $(row).find('[name^=IT22_ipNeed]');
            $.each(IT22_ipNeed,function(n,val){
                if($(val).prop("checked")){
                    if($(val).val() == "dvs_cluster"){
                        var num = $(val).nextAll("[name^=IT22_ipNum]").eq(0).val();
                        for(var j = 0;j<num;j++){
                            var temp = networkInfo_ctrl.addRow();
                            $(temp).find('[name^=server]').html(hostoption);
                            $(temp).find('[name^=usefor]').find('[value=dvs_cluster]').prop("selected","selected");
                            $(temp).find('[name^=hid_usefor]').val("群集虚拟");
                            $(temp).find('[name^=hid_usefor_value]').val("dvs_cluster");
                        }
                    }else if($(val).val() != "4"){
                        var temp = networkInfo_ctrl.addRow();
                        $(temp).find('[name^=server]').html(hostoption);
                        $(temp).find('[name^=usefor]').find('[value='+$(val).val()+']').prop("selected","selected");
                        $(temp).find('[name^=hid_usefor]').val($(val).next('span').text());
                        $(temp).find('[name^=hid_usefor_value]').val($(val).val());
                    }
                }
            })
        }
    }

    //提交事件
    function querySubmitFn(){
        if(judgeFun()==true){
            var paramsObj={};
            paramsObj.judgeTowards=judgeTowards;//获取流程判断条件
            Aaccount_ctrl.updateAllRow();
            networkInfo_ctrl.updateAllRow();
            dynamicRowsIdON_ctrl.updateAllRow();
            dynamicRowsIdCE_ctrl.updateAllRow();
            dynamicRowsIdDS_ctrl.updateAllRow();
            setBpmParams(paramsObj);
            if((stepId==""&&taskId=="")||(stepId=="1"&&taskId!="")){
                if($('[name=IT22_resourceType]:checked').val() == "computingresource" && $('[name=IT22_applyType]:checked').val() == "newconstruction"){
                    if(first=="true"){
                        return true;
                    }
                    //第一次校验是否可以自动化创建
                    checkAuto();
                    //autoCreate("first");//第一次调用接口，允许提交后设置first为true，点击提交按钮
                    return false;
                }
            }
            if(((stepId==""&&taskId=="")||(stepId=="1"&&taskId!="")) && $('[name=IT22_resourceType]:checked').val() == "computingresource" && $('[name=IT22_applyType]:checked').val() == "newconstruction"){
                if(first=="true"){
                    return true;
                }
                //第一次校验是否可以自动化创建
                checkAuto();
                //autoCreate("first");//第一次调用接口，允许提交后设置first为true，点击提交按钮
                return false;
            }
            if (stepId=="500" && "${IT22_resourceType}".indexOf("computingresource")>=0 && "${IT22_applyType}".indexOf("newconstruction")>=0) {
                if($('[name=isPass]').val() == "true"){//判断第一次校验是否通过，不通过则直接提交
                    //autoCreate();
                    //autoCreate("second");//调用第二次校验，不通过校验则直接提交，通过校验则调用第三次接口自动化创建
                    return true;
                }
            }
            if (stepId == '800') {
                $('[name=autoStepAd]').val('${_currUserName}');
            }
            if (stepId=='1000' && "${IT22_resourceType}".indexOf("computingresource")>=0 && "${IT22_applyType}".indexOf("newconstruction")>=0) {
                var success = true;
                $('#networkInfo tbody').find('[name^=autoResult]').each(function(i, obj) {
                    if (obj.value != '成功') {
                        success = false;
                        return false;
                    }
                });
                if (!success) {
                    common_recordTask('${autoStepAd}');
                }
            }
            return true;
        }
    }

    //保存
    function querySaveFn(){
        $("#__yourNote").val($("#__yourNote").val());
        if (stepId == "600") {
            collectServer();
        }
        Aaccount_ctrl.updateAllRow();
        networkInfo_ctrl.updateAllRow();
        dynamicRowsIdON_ctrl.updateAllRow();
        dynamicRowsIdCE_ctrl.updateAllRow();
        dynamicRowsIdDS_ctrl.updateAllRow();
        return true;
    }

    //校验转签
    function queryTransferFn(){
        var z=document.getElementById("taTransferReason").value;
        if(z==""||z==null){
            alert("请填写转签原因");
            return false;
        }
        return true;
    }

    //校验加签
    function queryOverSignFn(){
        var j=document.getElementById("taOverSignReason").value;
        if(j==""||j==null){
            alert("请填写加签原因");
            return false;
        }
        return true;
    }

    //校验退回
    function queryRollbackFn(){
        var v=document.getElementById("taRollbackReason").value;
        var rollbackRecord=$('input:radio[name="__rollbackRecord"]:checked').val();
        if(rollbackRecord==null){
            alert("请选择退回人员");
            return false;
        }
        if(v==""||v==null){
            alert("请填写退回原因");
            return false;
        }
        return true;
    }

    //校验取回
    function queryRetakeFn(){
        var j=document.getElementById("taRetakeReason").value;
        if(j==""||j==null){
            alert("请填写取回原因");
            return false;
        }
        return true;
    }

    //校验传阅意见
    function queryPassbyFn(){
        var j=document.getElementById("taPassbyReason").value;
        if(j==""||j==null){
            alert("请填写传阅原因");
            return false;
        }
        return true;
    }

    //处理流程多个分支事件
    function _selectNextActivityTo(){
    }
</script>