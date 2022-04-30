<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="Web.company.control.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>重启控制中心</title>
    <link href="../../css/style.css" rel="stylesheet" />
    <script src="../../js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="../../js/common.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#btn_start").click(function () {
                if (confirm("您真的要重启控制中心程序吗？")) {
                    $(".container").load("/cgi-bin/preparefilecgi.cgi?menuid=0&param=&commandname=&maintype=5&subtype=101&groupid=0&clientid=1&companyid=" + $("#companyid").val() + "&menuid=0&username=" + $("#username").val()+"&password="+$("#password").val()+"&charset=utf-8");
                }
            });
            $("#btn_start2").click(function () {
                if (confirm("您真的要重启控制中心程序吗？")) {
                    $(".container").load("/cgi-bin/preparefilecgi.cgi?menuid=0&param=&commandname=&maintype=5&subtype=102&groupid=0&clientid=1&companyid=" + $("#companyid").val() + "&menuid=0&username=" + $("#username").val() + "&password=" + $("#password").val()+"&charset=utf-8");
                }
            });
            //中央控制室服务器状态查看    //!!! /serverStatusCgi/serverStatusCgi.aspx 页面已经有了。。。
            //$.ajax({
            //    type: 'post',
            //    url: '/cgi-bin/preparefilecgi.cgi?maintype=5&subtype=100&merit=5&commandname=&param=&charset=utf-8&utf8=1',
            //    async: true,
            //    dataType: 'text',
            //    success: function (data) {
            //       // console.log("ddddkkkkk");
            //        $("div.serverStatus").html($(data).children().not('input'));
            //    }
            //});
            $.ajax({
                type: 'GET',
                url: '/cgi-bin/preparefilecgi.cgi?maintype=5&subtype=100&merit=5&commandname=&param=&charset=utf-8',
                async: true,
                dataType: 'html',
                timeout: 4000,      //超时时间
                success: function (data) {
                   // alert(data)
                    if (data != "") {
                        $("#serverStatusCgi_control").html($(data).not('br,p'));
                    }

                }
            });

        })
    </script>
    <style>
        .control_state
        {
            width:80%;
            margin:0 auto;
            color: #555;
            font-size: 14px;
            line-height: 32px;
        }
        .control_left
        {
            display:inline-block;
            width:50%;
            height:32px;
            text-align:right;
        }


        /***---------*/
        #serverInfo div {
            padding: 20px;
        }

        #serverInfo_tab {
            width: 100%;
        }

        #serverInfo_tab td {
            font-size: 14px;
            padding: 5px;
            border-top: none;
            border-left: none;
            border-right: none;
            border-bottom: 1px solid #999;
            width: 50%;
        }

        #serverInfo .serverInfo_title {
            font-size: 2em;
        }

        .serverInfo_tdTitle {
            text-align: left;
        }

        .serverInfo_tdContent {
            text-align: left;
        }

        .serverStatus {
            line-height: 2em;
            padding: 10px;
            /*background: #EDF0F0 none repeat scroll 0% 0%;**/
            font-size: 14px;
        }

            .serverStatus div {
                margin: 10px;
                border-bottom: #999 solid 1px;
            }

                .serverStatus div div {
                    margin: 0px;
                    border: none;
                }

        .serverStatus_dataLink .notlink {
            color: #F00;
        }

        .serverStatus img {
            margin-left: 0.5em;
            margin-right: 0.5em;
            margin-top: 0.5em;
        }

        .serverStatus_Title {
            text-align: center;
            font-size: 1.5em;
            border-bottom: #999 solid 1px;
        }

        .serverStatus .serverStatus_backbtn {
            text-align: center;
            border: none;
        }

        .serverStatus_listener input {
            font-size: 14px;
            width: 70px;
            height: 30px;
            font-weight: bold;
            margin: 5px;
        }
        .reqi_bt
        {
            display: inline-block;
            width: 150px;
            height: 30px;
            background: #5ac0ee;
        }
            .reqi_bt:hover
            {
                background:#1ca8dd;
            }
        /**
            #serverStatusCgi_control
        {
            height:650px;
            overflow:hidden;
        }*/
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- #include file="/common/top.html" -->
        <div class="container" style="display: block;">
            <input type="hidden" id="companyid" runat="server" value=''/>
            <input type="hidden" id="username" runat="server"  value=""/>
            <input type="hidden" id="password" runat="server"  value=""/>
            <div class="pos_area clearfix">
                <div class="pos"><a href="control_center.html">控制中心管理</a></div>
                <div class="editbtn">
                </div>
            </div>
            <div class="ny_content">
                <div class="control_center_con">
                    <div class="control_con_1">
                        <h4>无法建立于控制中心的链接，请检测控制中心是否启动!</h4>
                    </div>
                    <%--<div class="serverStatus" style="line-height: 2;text-align: center;">
                    
                    </div>--%>  <%--class="container"--%>
                      <div id="serverStatusCgi_control" class="clearfix"></div>
                    <div class="control_state" style="display:none">
                        <ul style="border:1px solid red;">
                            <li><span class="control_left">中央控制室启动时间：</span><span>2018-03-24 19:57:23。已运行时长：6天16时46分52秒</span></li>
                            <li><span class="control_left">中央控制室服务器V1600：</span><span></span></li>
                            <li><span class="control_left">授权序列号：</span><span></span></li>
                            <li><span class="control_left">正在进行文件分发线程数：</span><span></span></li>
                            <li><span class="control_left">数据库连接1(终端状态更新，新终端记录自动添加)：</span><span></span></li>
                            <li><span class="control_left">数据库连接2(运行日志，反馈信息)：</span><span></span></li>
                            <li><span class="control_left">数据库连接3(播放日志记录)：</span><span></span></li>
                            <li><span class="control_left">数据库访问方式：</span><span></span></li>
                            <li><span class="control_left">数据库连接字符串：</span><span></span></li>
                            <li><span class="control_left">是否使用存储过程：</span><span></span></li>
                            <li><span class="control_left">网站根目录：</span><span></span></li>
                            <li><span class="control_left">登录用单位号：</span><span></span></li>
                            <li><span class="control_left">自动文件分发：</span><span></span></li>
                            <li><span class="control_left">网络广播辅助分发：</span><span></span></li>
                            <li><span class="control_left">分块P2P文件传输：</span><span></span></li>
                            <li><span class="control_left">网络监听服务：</span><span></span></li>
                        </ul>
                    </div>
                    <div class="control_con_2">
                        <h4 style="color:#555;">启动/重新启动控制中心</h4>
                        <div class="txt">
                            <p style="padding-top:5px;border-bottom:1px solid #999;">当控制中心没有启动，或者没有响应的时候，可以通过指令启动/重新启动控制中心程序, 如果是超级管理员(administrator)，还可以重新启动控制中心服务器主机。</p>
                            <p style="padding-top:5px;border-bottom:1px solid #999;margin-left:0" class="font_red">注意：要实现功能，要求控制中心主机上运行着守护程序(RunMonitor.exe)。</p>
                        </div>
                        <div class="sc_add_btn clearfix" style="margin-top:15px;">
                            <span class="reqi_bt"><%-- class="inp_btn"--%>
                                <input class="btn" value="重启控制中心程序" id="btn_restart" type="button" style="color:#fff;line-height:30px;"></span>
                            <span class="reqi_bt"><%-- class="inp_btn"--%>
                                <input class="btn" id="btn_restart2" value="重启控制中心主机" type="button" style="color:#fff;line-height:30px;"></span>
                            <%-- <span class="inp_btn"><input class="btn" value="返回" type="button"></span></div>--%>
                        </div>
                    </div>
                </div>
            </div>
    </form>
</body>
</html>
