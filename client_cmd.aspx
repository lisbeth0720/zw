<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_cmd.aspx.cs" Inherits="Web.company.client.client_cmd" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-远程指令</title>
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
                        $.each(json.Table,
                            function (idx, item) {
                                $("#sys_cmdlist").append('<li style="display:block;width:100%">' +
                                    '<span title: "' +
                                    item.commandid +
                                    '"><input type="radio" name="r_client_syscmd"  data-name= " ' +
                                    item.commandname +
                                    '" data-param="' +
                                    item.parameter +
                                    '" value="' +
                                    item.commandid +
                                    ' ">' +
                                    item.commandname +
                                    '</span><input type="text" value="' +
                                    item.parameter +
                                    '"></li>');
                            });
                    } else {
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
            $(".zd_cmd .cmd_box ul span").css("margin", "4px");
        });

        function DoUserCommand(flag) {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": 0,
                    "flag": flag,
                    "idlist": $("#client_cmd_idlist").val(),
                    "mark": $("#client_cmd_mark").val()
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    } else {
                        data = data + "&merit=" + $("#select_merit").val() + "&commandname=&param=";

                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
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

        function DoUserCommand1(flag, num) {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": 0,
                    "flag": flag,
                    "idlist": $("#client_cmd_idlist").val(),
                    "mark": $("#client_cmd_mark").val()
                },
                success: function (data) {

                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    } else {
                        data = data +
                            "&merit=" +
                            $("#select_merit").val() +
                            "&fordebug = 1&commandname=&param=" +
                            (100 + parseInt(num));

                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
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

        function DoUserCommand2(flag,num,type) {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": type,
                    "flag": flag,
                    "idlist": $("#client_cmd_idlist").val(),
                    "mark": $("#client_cmd_mark").val()
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    } else {
                        if (num == "0") {
                            data = data + "&merit=0&commandname=Sys Internal Command--CheckPoint&param=";
                        } else if (num == "1"){
                            data = data + "&merit=0&commandname=System Confirm Save&param=c: -commit";
                        }
                        

                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
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

        function DoUserCommandVolEx(flag, type) {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": 2,
                    "flag": flag,
                    "idlist": $("#client_cmd_idlist").val(),
                    "mark": $("#client_cmd_mark").val()
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    } else {
                        if (type == "0") { //播放音量
                            data = data +
                                "&merit=" +
                                $("#select_merit").val() +
                                "&commandname=&param=" +
                                Math.ceil($("#volum").slider("value") * 255.0 / 100.0);
                        } else { //麦克风音量
                            data = data +
                                "&merit=" +
                                $("#select_merit").val() +
                                "&commandname=&param=" +
                                Math.ceil($("#volum").slider("value") * 255.0 / 100.0);
                        }
                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
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

        function DoUpdateCommand(flag) //升级首先需要分发文件，然后自动执行更新指令
        {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": 1,
                    "flag": flag,
                    "idlist": $("#client_cmd_idlist").val(),
                    "mark": $("#client_cmd_mark").val()
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    } else {

                        //if (flag == 0) {
                        //    var
                        //        data = data + "&merit=" + $("#select_merit").val() + "&commandname=System Update&param=";
                        //} else {
                        //    data = data + "&merit=" + $("#select_merit").val() + "&commandname=指令5&param=";
                        //}
                        //value1是更新目录  \privatefiles\wisepeak\sysupdate
                        ///cgi-bin/preparefilecgi.cgi?maintype=7&subtype=0&companyid=wisepeak&groupid=0&clientid=0&value1=D:/wisedisplay/privatefiles/wisepeak/sysupdate/&merit=5&ctrlflag=64&username=tzy&password=13.8
                        var dataTemp = '/cgi-bin/preparefilecgi.cgi?' + data + '&merit=2&value1=<%=sysupdateFile%>&ctrlflag=64';//D:\wisedisplay\privatefiles\wisepeak\sysupdate
                        // '/cgi-bin/preparefilecgi.cgi?' + data + '&merit=2&value1=replace(Application("WebRoot"), "\","     / ") & " / privatefiles / " & companyid & " / sysupdate / "&ctrlflag=64';
                        $.ajax({//执行系统命令升级程序
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&merit=2&charset=utf-8&utf8=2",
                            async: true,
                            dataType: 'text',
                            success: function (data) {
                                TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                                // window.location.href = dataTemp;//执行更新指令
                                var windowname = "window_sysupdate";
                                var ptop = window.screen.height / 2 - 400;
                                var pleft = window.screen.width / 2 - 700;
                                var a2 = window.open(dataTemp, windowname, 'left=' + pleft + ',top=' + ptop + ',height=400,width=840,toolbar=no,menubar=no,scrollbars=no,status=no,location=no,resizable=no');
                                a2.focus();
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
       
        //远程控制   //2019年12月29日16:20:46 fangkai 修改：本地打开WiseCCCPlayer，被控制端打开WiseThrough
        //2021-12月更改为操作下的远程若是pc端就和发送指令下的远程进行对换位置即pc端操作下的远程是程序远程，发送指令下的远程是网页远程，移动端就不需要换位置
        function DoWiseControl() {
            if (pcOrMobile() == 1) {//移动端
                var cltoption = $("#client_cltoption").val();
                var clientServerIp = "DEFAULTADDRESS;DEFAULTLINK:0";//
                var clientServerPort = $("#client_ctlport").val();//控制服务器端口号
                if (cltoption.indexOf("4") > -1) {//如果勾选了启用服务器，则serverIp等于控制服务器地址，未勾选则是"DEFAULTADDRESS;DEFAULTLINK:0"
                    var clientServerIpStr = $("#client_ctlip").val();
                    if (clientServerIpStr.length > 0 && clientServerIpStr.charAt(clientServerIpStr.length - 1) == ';') {
                        clientServerIpStr = clientServerIpStr.substring(0, clientServerIpStr.length - 1);
                    }
                    if (clientServerIpStr.indexOf(";") > -1) {//含有";"取分号后面的
                        var clientServerIpArry = clientServerIpStr.split(";");
                        clientServerIpArry = clientServerIpArry.filter(function (n) {
                            return n;
                        })
                        clientServerIp = clientServerIpArry[clientServerIpArry.length - 1] + ";DEFAULTLINK:" + clientServerPort;
                    }
                    else {
                        clientServerIp = clientServerIpStr + ";DEFAULTLINK:" + clientServerPort;
                    }
                }
                //var cltoption = $("#client_cltoption").val();
                if (cltoption.indexOf("4") > -1) {
                    $.ajax({
                        type: 'post',
                        url: 'ajax/getcmdParameter.ashx',
                        async: true,
                        dataType: 'text',
                        data: {
                            "type": 4,
                            "flag": 0,
                            "idlist": $("#client_cmd_idlist").val(),
                            "mark": $("#client_cmd_mark").val()
                        },
                        success: function (data) {
                            if (data == "-1") {
                                LoginTimeOut();
                            }
                            if (data == "-2") {
                                TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                            } else {
                                //data = data + "&merit=" + $("#select_merit").val() + "&commandname=WiseControl&param=" + $("#client_ipaddress").val() + ":" + $("#client_port").val() + ",DEFAULTADDRESS;DEFAULTLINK:0";
                                data = data + "&merit=" + $("#select_merit").val() + "&commandname=WiseControl&param=" + $("#client_ipaddress").val() + ":" + $("#client_port").val() + "," + clientServerIp;

                                $.ajax({
                                    type: 'post',
                                    url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
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
                var clientname = $("#client_name").val();
                clientname = clientname.replaceAll(' ', '%20');
                if (clientname.indexOf("~~") < 0) {
                    clientname += "~~" + $("#client_serialmark").val();
                }
                var str = "";
                var ctlColor = $("#client_ctlColor").val();

                if (!(cltoption == "0" || cltoption == "4")) {
                    if (cltoption.indexOf("1") > -1) {
                        str += "1";
                    } else {
                        str += "0";
                    }
                    if (cltoption.indexOf("2") > -1) {
                        str += "1";
                    } else {
                        str += "0";
                    }
                    if (cltoption.indexOf("3") > -1) {
                        str += "1";
                    } else {
                        str += "0";
                    }
                } else {
                    str = "000";
                }
                str += ctlColor;
           <%-- var ctrlip = "";
            if (cltoption.indexOf("4") > -1) {
                ctrlip = "," + $("#client_ctlip").val() + ":" + $("#client_ctlport").val();
            }
            var url = "WiseRemoteControl:-f " + $("#client_ipaddress").val() + ":0" + ctrlip + ";" + $("#client_serialmark").val() + ":" + $("#client_ctlport").val() + "," + $("#client_remoteip").val() + "," + ($("#client_detail").val() != "" ? $("#client_detail").val().substring($("#client_detail").val().lastIndexOf('&') + 1) : "") + " -o " + str + "003" +<%=authNum %>+" -s -e " + clientname + "/*0,0*/";//-t 总抢最前没法操作--%>
                var ctrlip = "";
                var client_ctlip = $("#client_ctlip").val();
                if (client_ctlip.length > 0 && client_ctlip.charAt(client_ctlip.length - 1) == ';') {
                    client_ctlip = client_ctlip.substring(0, client_ctlip.length - 1);
                }
                if (cltoption.indexOf("4") > -1) {//若果有代理服务器，则写上代理服务器地址
                    ctrlip = "," + client_ctlip + ":" + $("#client_ctlport").val() + ";" + $("#client_serialmark").val() + ":" + $("#client_ctlport").val()
                }
                else
                    ctrlip = ","
                var url = "WiseRemoteControl:-f " + $("#client_ipaddress").val() + ":0" + ctrlip + "," + $("#client_remoteip").val() + "," + ($("#client_detail").val() != "" ? $("#client_detail").val().substring($("#client_detail").val().lastIndexOf('&') + 1) : "") + " -o " + str + "003" +<%=authNum %>+" -s -e " + clientname + "/*0,0*/";//-t 总抢最前没法操作--%>
                window.location.href = url;
                return true;
            } else {//pc
                var ele = $("input[type='checkbox']:checked");
                if ($("#client_list_tab tbody tr").length == 2) {
                    ele = $("#client_list_tab tbody tr td input");
                }
                sendMessageToControlRoom(ele);
                //host给出连接的代理网关地址:端口号,和目标受控端地址:端口号。中间通过分号隔开。如果前面有多个代理网关，则通过分号连接起来。如果没有特殊的网关（网关就是本网页本身），则可以直接写目标受控端地址即可。
                //port为第一级网关使用端口号，可以写在port参数位置，也可以写在地址: 端口号部分（优先级高）
                //color = 0表示远程界面用2色，=1表示用16位色，=2表示用256色，=3表示用真彩色
                //onlyview = 1表示只能浏览远程界面，不能操作
                debugger;
                var defaultCIp = window.location.hostname;//默认控制服务器地址
                var wphttpcontrolproxy = '<%=string.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["wphttpcontrolproxy"])?"":System.Configuration.ConfigurationManager.AppSettings["wphttpcontrolproxy"].ToString()%>';
                if (wphttpcontrolproxy.length > 0 && wphttpcontrolproxy.charAt(wphttpcontrolproxy.length - 1) == ';') {
                    wphttpcontrolproxy = wphttpcontrolproxy.substring(0, wphttpcontrolproxy.length - 1);
                }
                var controlIp = "";
                var controlPort = "";
                var controlIpStatus = false;
                var host = $(ele).parent().parent().attr("data-ipaddress");//显示端ip
                var hostport = $(ele).parent().parent().attr("port");//显示端端口号
                var color = $(ele).parent().parent().attr("ctlcolor");//显示端颜色值
                var ctloptionSeeting = $(ele).parent().parent().attr("isnetworkseetings");//服务器控制端口号和远程控制属性组合
                var cltoption = $(ele).parent().parent().attr("cltoption");
                var viewonly = "";//是否只预览
                if (cltoption.indexOf("1") >= 0) {
                    viewonly = "0";
                } else if (cltoption.indexOf("3") >= 0) {
                    viewonly = "1";
                }
                var detail = $(ele).parent().parent().attr("detail");
                if (detail.indexOf("_#") >= 0) {
                    detail = detail.split("_#")[1];
                    if (detail.indexOf("_") > 0) {
                        detail = detail.split("_")[0];
                    }

                }
                var serialmark = $(ele).parent().parent().attr("serialmark");
                var controlIp = "";
                var controlNet = 0;//是否网址不可访问，如果不可访问直接访问连入地址
                if (ctloptionSeeting.indexOf("4") >= 0) {
                    controlNet = 0;//网址不可访问
                } else {
                    controlNet = 1;
                }
                var connectip = $(ele).parent().parent().attr("connectip");//连入地址

                var networksetting = $(ele).parent().parent().attr("isNetworkSeetings");
                var clientServerIpStr = $(ele).parent().parent().attr("controlIp");
                if (clientServerIpStr.length > 0 && clientServerIpStr.charAt(clientServerIpStr.length - 1) == ';') {
                    clientServerIpStr = clientServerIpStr.substring(0, clientServerIpStr.length - 1);
                }
                if (cltoption.indexOf("4") >= 0) {
                    controlIpStatus = 1;
                    controlIp = clientServerIpStr == "" ? defaultCIp : clientServerIpStr;//控制服务器地址，端口为10001
                    if (controlIp.length > 0 && controlIp.charAt(controlIp.length - 1) == ';') {
                        controlIp = controlIp.substring(0, controlIp.length-1);
                    }
                } else {
                    controlIpStatus = 0;
                    controlIp = "";
                }
                var newHref = "";
                if ((cltoption.indexOf("4") < 0) && wphttpcontrolproxy != "") {
                    if (wphttpcontrolproxy.substr(0, 11) == "websitehost") {
                        wphttpcontrolproxy = defaultCIp + wphttpcontrolproxy.substr(11);
                    }
                    newHref = "/company/client/wphttpcontrol.html?host=" + wphttpcontrolproxy + ";" + host + ":" + hostport + "&port=10001&color=" + color + "&onlyview=" + viewonly + "&connectip=" + connectip + "&networkSetting=" + controlNet + "&controlIp=" + controlIp + "&controlIpStatus=" + controlIpStatus + "&playDetail=" + serialmark;
                }
                else {
                    newHref = "/company/client/wphttpcontrol.html?host=" + host + ":8080;" + host + ":" + hostport + "&port=10001&color=" + color + "&onlyview=" + viewonly + "&connectip=" + connectip + "&networkSetting=" + controlNet + "&controlIp=" + controlIp + "&controlIpStatus=" + controlIpStatus + "&playDetail=" + serialmark;
                }
                window.open(newHref, "_blank");
            
            }
        }

        function sendMessageToControlRoom(ele) {
            //debugger;
            var cltoption = $(ele).parent().parent().attr("cltoption");
            var clientServerIp = "DEFAULTADDRESS;DEFAULTLINK:0";//
            var clientServerPort = "0";//控制服务器端口号
            if (cltoption.indexOf("4") > -1) {//如果勾选了启用服务器，则serverIp等于控制服务器地址，未勾选则是"DEFAULTADDRESS;DEFAULTLINK:0"
                var clientServerIpStr = $(ele).parent().parent().attr("controlIp");
                if (clientServerIpStr.length > 0 && clientServerIpStr.charAt(clientServerIpStr.length - 1) == ';') {
                    clientServerIpStr = clientServerIpStr.substring(0, clientServerIpStr.length - 1);
                }
                if (clientServerIpStr != "") {
                    if (clientServerIpStr.indexOf(";") > -1) {//含有";"取分号后面的
                        var clientServerIpArry = clientServerIpStr.split(";");
                        clientServerIpArry = clientServerIpArry.filter(function (n) {
                            return n;
                        })
                        clientServerIp = clientServerIpArry[clientServerIpArry.length - 1] + ";DEFAULTLINK:" + clientServerPort;
                    } else {
                        clientServerIp = clientServerIpStr + ";DEFAULTLINK:" + clientServerPort;
                    }
                }
            }
            var clientId = $(ele).parent().parent().attr("data-id");
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": 4,
                    "flag": 0,
                    "idlist": clientId,
                    "mark": ""
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    } else {
                        //data = data + "&merit=5&commandname=WiseControl&param=" + $(ele).parent().parent().attr("data-ipaddress") + ":" + $(ele).parent().parent().attr("port") +",DEFAULTADDRESS;DEFAULTLINK:0";
                        data = data + "&merit=5&commandname=WiseControl&param=" + $(ele).parent().parent().attr("data-ipaddress") + ":" + $(ele).parent().parent().attr("port") + "," + clientServerIp;
                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
                            async: true,
                            dataType: 'text',
                            success: function (data) {
                                TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                            }
                        });
                    }
                }
            });
            return true;
        }
        //2019年12月30日09:40:50 fangkai修改：由于WiseVChat.exe暂不可解析参数，该功能暂不可用，直接提示“无权限”
        //TODO:等以后参数解析修改后，需要在发送指令窗口增加一个获取本地cliend_name的下拉菜单，因为WiseVChat.exe的参数需要两端的client_name
        function DoWiseVChat() {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                dataType: 'text',
                data: {
                    "type": 5,
                    "flag": 0,
                    "idlist": $("#client_cmd_idlist").val(),
                    "mark": $("#client_cmd_mark").val()
                },
                success: function (data) {
                    // TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    }
                    else {
                        var local_ip = window.location.host;
                        var local_name = $("#client_name").val();
                        var cmd_para = "-f " + local_name + ",*,192.168.1.145,9810,0,1,0,1,0,0,0,0,0 -t -w 820,6,400,400,0";
                        data = data + "&merit=" + $("#select_merit").val() + "&commandname=WiseVChat&param=" + cmd_para;
                        //debugger;
                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
                            async: true,
                            dataType: 'text',
                            success: function (data) {
                                TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);

                            }
                        });
                    }
                }
            });
            return true;
        }

        //2019年12月26日16:22:27 fangkai修改：为注册表调起程序的时候传入参数
        $("#wise_remote_control").click(function () {

        //var url = "WiseRemoteControl:-f " + $("#client_ipaddress").val() + ":0 -o 000200 -s -t";//+ ":" + $("#client_ctlport").val()

        //-f 192.168.1.250: 0 - o 10130001 - w 724, 0, 500, 300 - e / * 330, 150, 500, 400 * /    --注意：使用时去掉*和斜杠间空格
        //    - f 192.168.1.2: 0 - o 10130001 - w 724, 0, 500, 300 - e / * 0, 0 * /

        //其中 - f 部分给出要抓取的受控端地址和端口号，端口号0表示使用系统缺省的端口号(9901) 。

        //-o 为控制字符串7字节，格式为：xxxxxxx，每个字节用数字表示，0表示不启用，1表示启用
        //第一个字节：是否共享控制
        //第二个字节：是否最小化
        //第三个字节：是否只浏览
        //第四个字节：颜色数0（2色）、1（16色）、2（256色）、 3（全彩）
        //第五个字节：是否不显示工具条，当有标题条显示时才生效（不能单独显示），0显示，1不显示，2显示同时强制显示标题条，3不显示同时强制显示标题条（主要是防止有 - w参数）
        //第六个字节：是否隐藏滚动条（如果远程监视的画面大小大于本窗口大小）
        //第七个字节：自动刷新远程桌面频率。0表示不自动刷新，1表示刷新间隔200毫秒，2表示刷新间隔500毫秒，3表示刷新间隔1000毫秒，4表示刷新间隔2000毫秒，5表示刷新间隔5000毫秒，6表示刷新间隔100毫秒，7表示刷新间隔50毫秒，8表示刷新间隔25毫秒，9表示刷新间隔16毫秒
        //增加第八个字节：0表示启动本程序, 没有远程控制功能(一定只浏览), 1表示有远程功能授权(根据传入的第三字节来定可不可以操作), 0x02 + 0x01表示要启动多窗口的中央控制室程序(具有远程控制权限, 根据传入的第三字节来定可不可以操作). 0x02 + 0x00表示启动启动多窗口的中央控制室程序但无远程控制授权(该情况认为不应该出现--即多窗口一定要有远程控制授权)

        //移到DoWiseControl方法中
        <%--var clientname = $("#client_name").val();
        clientname = clientname.replaceAll(' ', '%20');
        if (clientname.indexOf("~~") < 0) {
            clientname += "~~" + $("#client_serialmark").val();
        }
        var url = "WiseRemoteControl:-f " + $("#client_ipaddress").val() + ":0" + "," + $("#client_ctlip").val() + ":" + $("#client_ctlport").val() + ";" + $("#client_serialmark").val() + ":" + $("#client_ctlport").val() + "," + $("#client_remoteip").val() + "," + ($("#client_detail").val() != "" ? $("#client_detail").val().substring($("#client_detail").val().lastIndexOf('&') + 1) : "") + " -o 0002003"+<%=authNum %>+" -s -e " + clientname+"/*0,0*/";//-t 总抢最前没法操作
        window.location.href = url;--%>

            // alert(url); console.log(url);

            // var windowname = "window_remote_control";       
            //var ptop = window.screen.height / 2 - 400;
            //var pleft = window.screen.width / 2 - 700;
            //var a1 = window.open(url, windowname, 'left=' + pleft + ',top=' + ptop + ',height=400,width=840,toolbar=no,menubar=no,scrollbars=no,status=no,location=no,resizable=no');
            //a1.focus();
        });
        //2019年12月30日09:40:50 fangkai修改：由于WiseVChat.exe暂不可解析参数，该功能暂不可用
        $("#wise_video_chat").click(function () {
            var url = "WiseVideoChat:-f *," +
                $("#client_name").val() +
                ",192.168.1.145,9810,0,1,0,1,0,0,0,0,0 -t -w 820,6,800,800,0";
            var local = window.location.host;
            //debugger;
            //window.location.href = url;
        });


        //自定义指令
        function sendCustomCmd() { //重点在于commandname = id;  
            var val = $('input:radio[name="r_client_syscmd"]:checked').val();
            if (val == null) {
                TopTrip(getLanguageMsg("请选择要执行的命令！", $.cookie("yuyan")), 2);
            } else {
                var cmdparam = $('input:radio[name="r_client_syscmd"]:checked').attr("data-param");
                var cmdvalue = $('input:radio[name="r_client_syscmd"]:checked').attr("value");

                $.ajax({
                    type: 'post',
                    url: 'ajax/getcmdParameter.ashx',
                    async: true,
                    dataType: 'text',
                    data: {
                        "type": 3,
                        "flag": 0,
                        "idlist": $("#client_cmd_idlist").val(),
                        "mark": $("#client_cmd_mark").val()
                    },
                    success: function (data) {
                        //$("input[name=ch_addparam]").is(":checked")==true //传递命令行参数
                        if (data == "-1") {
                            LoginTimeOut();
                        }
                        if (data == "-2") {
                            TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                        } else {
                            //旧版BS:  merit=5&addparam=&do=%26%23160%3B%D6%B4%26%23160%3B%D0%D0%26%23160%3B&companyid=wisepeak&menuid=0&commandname=%25u7CFB%25u7EDF%25u5185%25u90E8%25u6307%25u4EE4&maintype=6&subtype=0&groupid=0&clientid=4&username=tzy&escapeusername=tzy&password=C056Dl%2FoStNftflbnO6seQ%3D%3D&param=aa&commandidlist=%CF%B5%CD%B3%C4%DA%B2%BF%D6%B8%C1%EE&commandparamlist=aa
                            /*新版BS companyid=wisepeak&menuid=0&maintype=6&subtype=0&groupid=0&clientid=153&username=administrator&password=K6sf1DbzRvJ@dVi4Cedklw==&charset=utf-8&charset=utf-8&utf8=2
    cgi参数:   commandname编码-- encodeURI(encodeURI(""))
    merit,commandname,commandidlist,commandparamlist
    //传递命令行参数 :param
    
                             */
                            var paramStr = "&merit=" + $("#select_merit").val() + "&commandname=" + cmdvalue + "&para=";
                            if ($("input[name=ch_addparam]").is(":checked")) {
                                paramStr += cmdparam; //传递命令行参数
                            }
                            data += paramStr;

                            $.ajax({
                                type: 'post',
                                url: '/cgi-bin/preparefilecgi.cgi?' + data + "&charset=utf-8&utf8=2",
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
        .zyylist {
            width: 100%;
        }

            .zyylist span {
                display: block;
                float: left;
                width: 38px;
            }

        .zd_cmd {
            height: 400px;
            width: 600px;
        }

        #client_main_cmdbox {
            height: 430px;
            width: 600px;
        }
    </style>
</head>
<body>
    <form id="client_cmd" runat="server">
        <input type="hidden" id="client_cmd_dlevel" name="client_cmd_dlevel" runat="server" />
        <input type="hidden" id="client_cmd_groupid" name="client_cmd_groupid" runat="server" />
        <input type="hidden" id="client_cmd_mark" name="client_cmd_mark" runat="server" />
        <input type="hidden" id="client_cmd_idlist" name="client_cmd_idlist" runat="server" />
        <input type="hidden" id="client_name" name="client_name" runat="server" />
        <input type="hidden" id="client_ipaddress" name="client_ipaddress" runat="server" />
        <input type="hidden" id="client_ctlColor" name="client_ctlColor" runat="server" />
        <input type="hidden" id="client_cltoption" name="client_cltoption" runat="server" />
        <input type="hidden" id="client_port" name="client_port" runat="server" />
        <input type="hidden" id="client_ctlip" name="client_ctlip" runat="server" />
        <input type="hidden" id="client_ctlport" name="client_ctlport" runat="server" />
        <input type="hidden" id="client_detail" name="client_detail" runat="server" />
        <input type="hidden" id="client_serialmark" name="client_serialmark" runat="server" />
        <input type="hidden" id="client_remoteip" name="client_remoteip" runat="server" />

        <div style="cursor: pointer; height: 30px; position: absolute; right: 0; top: 0; width: 30px; z-index: 2002;">
            <img src="/images/icon_closeBox.png" onclick="close_client_cmdBox()" alt="" />
        </div>
        <div style="height: 30px; line-height: 30px;">
            <span class="language">指令优先级：</span><select id="select_merit" runat="server"></select>
            <input type="checkbox" name="ch_addparam" checked="checked" />
            <span class="language">传递命令行参数 </span>
        </div>
        <div class="zd_cmd">
            <ul class="clent_cmd_tab clearfix">
                <li class="current language" data-type="1">系统指令</li>
                <li data-type="2" class="language">自定义指令</li>
            </ul>
            <div id="div_cmdbox1" class="cmd_box" style="display: block;">
                <ul class="clearfix">
                    <li style="height: 10px; width: 600px;"></li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(45)">远程开机</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(0)">远程关机</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(1)">远程重启</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(31)">软件重启</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(11)">开始播放节目</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(20)">停止播放节目</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoWiseControl()" id="wise_remote_control">远程监控</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoWiseVChat()" id="wise_video_chat">远程视频</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn" style="height: 58px; line-height: 58px;">
                            <a class="language" href="javascript:void(0)" onclick="DoUserCommand(26)">停止临时/紧急节目</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(19)">清空终端节目单目录</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUpdateCommand(0)">系统升级</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUpdateCommand(1)">系统升级（兼容）</a>
                        </span>
                    </li>

                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(48)">上报播放日志</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(49)">今天不自动关机</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="language" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand(50)">取消不自动关机</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand2(7,0,0)">时间同步</a>
                        </span>
                    </li>
                    <li>
                        <span class="inp_btn">
                            <a class="" style="width: 120px" href="javascript:void(0)" onclick="DoUserCommand2(0,1,3)">嵌入PC保存更改</a>
                        </span>
                    </li>
                    <li style="height: 10px; width: 600px;"></li>
                    <li class="zyylist" style="width: 100%;">
                        <span style="line-height: 24px; margin: 0; margin-left: 10px; padding: 0; width: 75px;" class="language">启动临时预案</span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(60, 1)">1</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(60, 2)">2</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(60, 3)">3</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(60, 4)">4</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(60, 5)">5</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(60, 6)">6</a>
                        </span>
                        <span class="inp_btn" style="margin: 15px; min-width: 120px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand(25)" class="language">临时节目</a>
                        </span>
                    </li>
                    <li class="zyylist" style="width: 100%;">
                        <span style="line-height: 24px; margin: 0; margin-left: 10px; padding: 0; width: 75px;" class="language">启动紧急预案</span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(61, 1)">1</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(61, 2)">2</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(61, 3)">3</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(61, 4)">4</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(61, 5)">5</a>
                        </span>
                        <span class="inp_btn" style="margin: 8px; min-width: 50px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand1(61, 6)">6</a>
                        </span>
                        <span class="inp_btn" style="margin: 15px; width: 120px;">
                            <a href="javascript:void(0)" onclick="DoUserCommand(27)" class="language">紧急节目</a>
                        </span>
                    </li>
                </ul>
                <li style="height: 20px; width: 600px;"></li>
                <span id="volum" style="display: inline-block; margin-left: 8px; padding: 0; width: 300px;"></span>&nbsp;<input type="text" name="name" placeholder="0-100" style="font-size: 18px; text-align: center; width: 50px;" id="txt_cmd_vol" value="" />
                <ul>
                    <li style="margin: 10px; width: 120px;">
                        <span class="inp_btn">
                            <a href="javascript:void(0)" onclick="DoUserCommandVolEx(29, 0)" class="language">设置播放音量</a>
                        </span>
                    </li>
                    &nbsp;&nbsp;
                <li style="margin: 10px; width: 120px;">
                    <span class="inp_btn">
                        <a href="javascript:void(0)" onclick="DoUserCommandVolEx(29, 1)" class="language">设置录音音量</a>
                    </span>
                </li>
                </ul>
            </div>
            <div id="div_cmdbox2" class="cmd_box" style="height: 350px; overflow-x: auto; overflow-y: auto; width: 600px;">
                <ul id="sys_cmdlist" class="clearfix"></ul>
                <div>
                    <span class="inp_btn" style="bottom: 0px; float: right; position: absolute; right: 20px;">
                        <a href="javascript:void(0)" onclick="sendCustomCmd()" class="language">执行</a>
                    </span>
                </div>
            </div>
        </div>

    </form>
    <script>
        //jquery ui 音量控制
        $("#volum").slider({
            orientation: "horizontal",
            range: "max",
            max: 100,
            value: 52,
            step: 1,
            change: refreshSwatch
        });
        $("#txt_cmd_vol").val(parseFloat($("#volum").slider("value")));

        function refreshSwatch() {
            if ($("#txt_cmd_vol").val() !== "") {
                $("#txt_cmd_vol").val(parseFloat($("#volum").slider("value")));
            } else {
                $("#txt_cmd_vol").val("0");
                $("#txt_cmd_vol").value = "0";
            }
        }

        $("#txt_cmd_vol").change(function () {
            if ($("#txt_cmd_vol").val() !== "") {
                $("#volum").slider({
                    value: parseFloat($("#txt_cmd_vol").val())
                });
            } else {
                $("#volum").slider({
                    value: 0
                });
            }
        });


    </script>
</body>
</html>
