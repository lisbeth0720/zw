<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_cmd.aspx.cs" Inherits="Web.company.client.client_cmd" %>

<script type="text/javascript">
    $(function () {
        getJsonValue();
        $.ajax({
            type: 'post',
            url: 'ajax/getcmdlist.ashx',
            async: true,
            dataType: 'text',
            success: function (data) {
                if (data != "-1") {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        $("#sys_cmdlist").append('<li style="display:block;width:100%">'
                            + '<span><input type="radio" name="r_client_syscmd" data-name="' + item.commandname + '" data-param="' + item.parameter + '" value="' + item.commandid + '">' + item.commandname
                            + '</span><input type="text" value="' + item.parameter + '"></li>');
                    })
                }
                else {
                    LoginTimeOut();
                }
            }
        });
        switchLanguage("#client_main_cmdbox", 1, "client_cmd.aspx");
        $(".clent_cmd_tab li").click(function () {
            $(this).addClass("current").siblings("li").removeClass("current");
            if ($(this).attr("data-type") == 1) {
                $("#div_cmdbox1").show();
                $("#div_cmdbox2").hide();
            }
            if ($(this).attr("data-type") == 2) {
                $("#div_cmdbox2").show();
                $("#div_cmdbox1").hide();
            }
        });
        $(".zd_cmd .cmd_box ul span").css("margin", "4px")
    })
    function DoUserCommand(flag) {
        $.ajax({
            type: 'post',
            url: 'ajax/getcmdParameter.ashx',
            async: true,
            dataType: 'text',
            data: { "type": 0, "flag": flag, "idlist": $("#client_cmd_idlist").val(), "mark": $("#client_cmd_mark").val() },
            success: function (data) {
                debugger;
                if (data == "-1")
                {
                    LoginTimeOut();
                }
                if (data == "-2") {
                    TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                }
                else {
                    data = data + "&merit=" + $("#select_merit").val() + "&commandname=&param=";
                    $.ajax({
                        type: 'post',
                        url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=1",
                        async: true,
                        dataType: 'text',
                        success: function (data) {
                            TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                        }
                    });
                }
            }
        });
    }
    function DoUserCommand1(flag,num) {
        $.ajax({
            type: 'post',
            url: 'ajax/getcmdParameter.ashx',
            async: true,
            dataType: 'text',
            data: { "type": 0, "flag": flag, "idlist": $("#client_cmd_idlist").val(), "mark": $("#client_cmd_mark").val() },
            success: function (data) {
                debugger;
                if (data == "-1") {
                    LoginTimeOut();
                }
                if (data == "-2") {
                    TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                }
                else {
                    data = data + "&merit=" + $("#select_merit").val() + "&fordebug = 1&commandname=&param=" + (100 + parseInt(num));
                    
                    $.ajax({
                        type: 'post',
                        url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=1",
                        async: true,
                        dataType: 'text',
                        success: function (data) {
                            TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                        }
                    });
                }
            }
        });
    }
  
    function DoUserCommandVolEx(flag,type)
    {
        $.ajax({
            type: 'post',
            url: 'ajax/getcmdParameter.ashx',
            async: true,
            dataType: 'text',
            data: { "type": 2, "flag": flag, "idlist": $("#client_cmd_idlist").val(), "mark": $("#client_cmd_mark").val() },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                if (data == "-2") {
                    TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                }
                else {
                    if (type == "0") {//播放音量
                        data = data + "&merit=" + $("#select_merit").val() + "&commandname=&param="+ $("#txt_cmd_vol").val();
                    }
                    else {//麦克风音量
                        data = data + "&merit=" + $("#select_merit").val() + "&commandname=&param=" + $("#txt_cmd_vol").val()<<16;
                    }
                    $.ajax({
                        type: 'post',
                        url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=1",
                        async: true,
                        dataType: 'text',
                        success: function (data) {
                            TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                        }
                    });
                }
            }
        });
    }
    function close_client_cmdBox() {
        $("#overlay").fadeOut(function () {
            $("#client_main_cmdbox").fadeOut();
        });
    }
    //远程控制 tzy
    function DoWiseControl()
    {
        var merit = $("#select_merit").val();
        var ipaddress =  $("#client_ipaddress").val() + ":0 -o 000200 "; //"127.0.0.1:0 -o 000200 ";
        var lastrecname = $("#client_name").val();
        findflag = true;
        commandstr = "wisecontrol";
        //document.ExeForm.commandname.value = escape(commandstr);
        //document.ExeForm.param.value = "-f " + ipaddress;
        if (confirm(getLanguageMsg("指令中包含启动远程桌面查看指令，要先启动本地远程桌面查看客户端吗？\n注意：远程桌面查看客户端WiseCCCPlayer.exe要已经放到Windows目录下。", $.cookie("yuyan")))) {
            var objShell = new ActiveXObject("wscript.shell");
            //注意：程序要放在windows目录下
            objShell.Run("WiseCCCPlayer.exe -f " + ipaddress + " -s -t", 0);
            objShell = null;
        }
        else
            return false;
        //document.ExeForm.submit();
        return true;
        
    }
    function DoWiseVChat() {

    }
    //自定义指令
    function sendCustomCmd() {
        var val = $('input:radio[name="r_client_syscmd"]:checked').val();
        //var flag = 0;
        //$("[name='ch_addparam'][checked]").each(function () {
        //    flag = 1;
        //})
        if (val == null) {
            TopTrip(getLanguageMsg("请选择要执行的命令！", $.cookie("yuyan")), 2);
        }
        else {
            var cmdname = $('input:radio[name="r_client_syscmd"]:checked').attr("data-name");
            var cmdparam = $('input:radio[name="r_client_syscmd"]:checked').attr("data-param");
            var cmdvalue = $('input:radio[name="r_client_syscmd"]:checked').attr("value");
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: { "type": 3, "flag": flag, "idlist": $("#client_cmd_idlist").val(), "mark": $("#client_cmd_mark").val() },
                success: function (data) {
                    //$("input[name=ch_addparam]").is(":checked")==true //传递命令行参数
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    }
                    else {
                        //旧版BS:  merit=5&addparam=&do=%26%23160%3B%D6%B4%26%23160%3B%D0%D0%26%23160%3B&companyid=wisepeak&menuid=0&commandname=%25u7CFB%25u7EDF%25u5185%25u90E8%25u6307%25u4EE4&maintype=6&subtype=0&groupid=0&clientid=4&username=tzy&escapeusername=tzy&password=C056Dl%2FoStNftflbnO6seQ%3D%3D&param=aa&commandidlist=%CF%B5%CD%B3%C4%DA%B2%BF%D6%B8%C1%EE&commandparamlist=aa
                        /*新版BS companyid=wisepeak&menuid=0&maintype=6&subtype=0&groupid=0&clientid=153&username=administrator&password=K6sf1DbzRvJ@dVi4Cedklw==&charset=utf-8&charset=utf-8&utf8=1
cgi参数:   commandname编码-- encodeURI(encodeURI(""))
merit,commandname,commandidlist,commandparamlist
//传递命令行参数 :param

                         */
                        var paramStr = "&merit=" + $("#select_merit").val() + "&commandname" + encodeURI(encodeURI(cmdvalue)) + "&commandidlist=" + encodeURI(cmdname) + "&commandparamlist=" + cmdparam;
                        if ($("input[name=ch_addparam]").is(":checked") == true) {
                            paramStr += "&param=" + cmdparam;//传递命令行参数
                        }
                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=1",
                            async: true,
                            dataType: 'text',
                            success: function (data) {
                                TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                            }
                        });
                    }
                }
            });
        }
    }
</script>
<style>
    .zyylist{
         width:100%;
    }
     .zyylist span{
         width:50px;
         display:block;
         float:left;
    }
    .zd_cmd{
        height:425px;
    }
    #client_main_cmdbox{
        height:450px;
    }
</style>
<form id="client_cmd" runat="server">
    <input type="hidden" id="client_cmd_dlevel" name="client_cmd_dlevel" runat="server" />
    <input type="hidden" id="client_cmd_groupid" name="client_cmd_groupid" runat="server" />
    <input type="hidden" id="client_cmd_mark" name="client_cmd_mark" runat="server" />
    <input type="hidden" id="client_cmd_idlist" name="client_cmd_idlist" runat="server" />
    <input type="hidden" id="client_name" name="client_name" runat="server" />
    <input type="hidden" id="client_ipaddress" name="client_ipaddress" runat="server" />
    <div style="position: absolute; right: 0; top: 0; z-index: 2002; width: 30px; height: 30px; cursor: pointer;">
        <img src="/images/icon_closeBox.png" onclick="close_client_cmdBox()" />
    </div>
    <div style="height: 30px; line-height: 30px;"><span class="language">指令优先级：</span><select id="select_merit" runat="server"></select>
        <input type="checkbox" name="ch_addparam" checked="checked" />
        <span class="language">传递命令行参数 </span></div>
    <div class="zd_cmd">
        <ul class="clent_cmd_tab clearfix">
            <li class="current language" data-type="1">系统指令</li>
            <li data-type="2" class="language">自定义指令</li>
        </ul>
        <div id="div_cmdbox1" class="cmd_box" style="display: block;">
            <ul class="clearfix">
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(45)">远程开机</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(0)">远程关机</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(1)">远程重启</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(31)">软件重启</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(11)">开始播放节目</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(20)">停止播放节目</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoWiseControl()">远程监控</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoWiseVChat()">远程视频</a></span></li>
               <%-- <li><span class="inp_btn"><a href="javascript:void(0)" onclick="DoUserCommand(25)">启动临时节目</a></span></li>
                <li><span class="inp_btn"><a href="javascript:void(0)" onclick="DoUserCommand(27)">启动紧急节目</a></span></li>--%>
                <li><span class="inp_btn" style="font-size:12px;height:88px;"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(26)">停止临时/紧急节目</a></span></li>
               <%-- <li><span class="inp_btn"><a href="javascript:void(0)" onclick="DoUserCommand(28)">停止紧急节目</a></span></li>--%>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUpdateCommand(0)">系统升级</a></span></li>
                <li><span class="inp_btn" style="height:44px;"><a class="language" href="javascript:void(0)" onclick="DoUpdateCommand(1)">系统升级（兼容）</a></span></li>
                <%--<li><span class="inp_btn"><a href="javascript:void(0)" onclick="DoUserCommand(19)">清空终端节目单目录</a></span></li>--%>
                <li><span class="inp_btn" style="height:44px;"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(19)">清空终端目录</a></span></li>
                <li><span class="inp_btn"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(48)">上报播放日志</a></span></li>
                <li><span class="inp_btn" style="height:44px;"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(49)">今天不自动关机</a></span></li>
                <li><span class="inp_btn" style="height:88px;"><a class="language" href="javascript:void(0)" onclick="DoUserCommand(50)">取消不自动关机</a></span></li>
              
                <li class="zyylist" style="width:100%;">
                    <span style="width:75px;margin:0;padding:0;margin-left:10px;" class="language">启动临时预案</span>
                    <span class="inp_btn" style="min-width:50px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(60,1)">1</a></span>
                    <span class="inp_btn" style="min-width:50px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(60,2)">2</a></span>
                    <span class="inp_btn" style="min-width:50px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(60,3)">3</a></span>
                    <span class="inp_btn" style="min-width:50px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(60,4)">4</a></span>
                    <span class="inp_btn" style="min-width:50px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(60,5)">5</a></span>
                    <span class="inp_btn" style="min-width:50px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(60,6)">6</a></span>
                    <span class="inp_btn" style="min-width:146px; margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand(25)" class="language">临时节目</a></span>
                </li>
                <li class="zyylist" style="width:100%;">
                    <span style="width:75px;margin:0;padding:0;margin-left:10px;" class="language">启动紧急预案</span>
                    <span class="inp_btn" style="min-width:50px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(61,1)">1</a></span>
                    <span class="inp_btn" style="min-width:50px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(61,2)">2</a></span>
                    <span class="inp_btn" style="min-width:50px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(61,3)">3</a></span>
                    <span class="inp_btn" style="min-width:50px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(61,4)">4</a></span>
                    <span class="inp_btn" style="min-width:50px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(61,5)">5</a></span>
                    <span class="inp_btn" style="min-width:50px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand1(61,6)">6</a></span>
                    <span class="inp_btn" style="min-width:146px;margin:8px"><a href="javascript:void(0)" onclick="DoUserCommand(27)" class="language">紧急节目</a></span>
                </li>
            </ul>
            
                <span id="volum" style="display:inline-block;width:255px ;padding:0;margin:0" ></span>&nbsp;<input type="text" name="name" placeholder="0-255"  style="width:50px;font-size:18px" id="txt_cmd_vol" value=""/>
            <ul>
                <li style="width:170px;"><span class="inp_btn"><a href="javascript:void(0)" onclick="DoUserCommandVolEx(29,0)" class="language">设置播放音量</a></span></li>
                <li style="width:170px;"><span class="inp_btn"><a href="javascript:void(0)" onclick="DoUserCommandVolEx(29,1)" class="language">设置录音音量</a></span></li>
            </ul>
        </div>
        <div id="div_cmdbox2" class="cmd_box">
            <ul id="sys_cmdlist" class="clearfix">
            </ul>
            <span class="inp_btn" style="float: right;"><a href="javascript:void(0)" onclick="sendCustomCmd()" class="language">执行</a></span>
        </div>
    </div>
    
</form>
<script>
    //jquery ui 音量控制
    $("#volum").slider({
        orientation: "horizontal",
        range: "max",
        max: 255,
        value: 127,
        change: refreshSwatch,
    })
    $("#txt_cmd_vol").val(parseFloat($("#volum").slider("value")));
    function refreshSwatch() {
        if ($("#txt_cmd_vol").val() != "") {
            $("#txt_cmd_vol").val(parseFloat($("#volum").slider("value")));
        } else {
            $("#txt_cmd_vol").val("0");
            $("#txt_cmd_vol").value="0";
        }
    }

    $("#txt_cmd_vol").change(function () {
        if ($("#txt_cmd_vol").val() != "") {
            $("#volum").slider({
                value: parseFloat($("#txt_cmd_vol").val())
            });
        }
        else {
            $("#volum").slider({
                value:0
            });
        }
    });
  
   
</script>
