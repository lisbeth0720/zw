<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_main.aspx.cs" Inherits="Web.company.client.client_main" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-终端属性设置</title>
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <link href="/css/zTreeStyle.css" rel="stylesheet" />
    <link href="/js/jquery-ui/jquery-ui.css" rel="stylesheet" />
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <link href="/css/style.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <%--<script src="/js/jquery-1.9.1.min.js"></script>--%>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/jquery-ui/jquery-ui.min.js"></script>
    <script src="/js/jquery.ztree.core.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/ajaxfileupload.js"></script>
    <script src="/js/mxjfunction.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <%--<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=XBhGCsGU69qqi82s95rX0RoIUaKNvwUG
"></script>
    <script type="text/javascript" src="http://lbsyun.baidu.com/jsdemo/data/points-sample-data.js"></script>--%>
   <%-- <script type="text/javascript" src = 'http://a.amap.com/jsapi_demos/static/citys.js'></script> 
    <script type="text/javascript" src = 'http://webapi.amap.com/maps?v=1.4.6&key=fac151c5ea94b2e9646d3f34d1126d8e'></script>--%>
    <%--fac151c5ea94b2e9646d3f34d1126d8e--个人申请的高德地图key --%>
    <script type="text/javascript">
        $(function () {
            client_main_loadright(0, $("#client_main_groupid").val(), $("#client_main_dlevel").val(), $("#client_main_mark").val());
            $("#client_main_left").load("client_main_left.html?myComID=" + $("#myComId").val() + "&rand=" + Math.random(9999), function () {
                $("#client_main_left").slideDown();
            });
            switchLanguage("#container", 1, "client_main.aspx");
        })
        function client_main_loadright(type, groupid, dlevel, mark) {

            var pageurl = "";
            var edit = "";
            if (type == 0) {
                pageurl = "client_main_right.aspx?clientsort=" + $("#sort").val() + "&clientkey=" + $("#client_main_right_key").val();
            }
            if (type == 1) {
                pageurl = "clientgroup_add.aspx";

            }
            if (type == 2) {
                pageurl = "client_menu_add.aspx";
              
            }
            if (type == 3) {
                pageurl = "clientgroup_add.aspx";
                edit = "edit";
            }
            if (type == 5) {
                pageurl = "client_main_right.aspx";
            }
            if (type == 6) {
                pageurl = "client_add.aspx";
            }
            if (type == 12) {
                pageurl = "client_list2.aspx";
            }
            if (type == 8) {
                pageurl = "client_add.aspx";
                edit = "edit";
            }
            load_main_rightpage(pageurl, groupid, dlevel, mark, edit);
        }
        function load_main_rightpage(pageurl, groupid, dlevel, mark, edit) {
            if (pageurl.indexOf("client_groupinfo") > 0 && myInterTimerg != undefined) {
                clearInterval(myInterTimerg);
            }
            if (pageurl.indexOf("client_view") > 0 && myInterTimer != undefined) {
                clearInterval(myInterTimer);
            }
            $("#client_main_right").load(pageurl, { "gid": groupid, "dlv": dlevel, "mark": mark, "t": edit }, function () {
                $("#client_main_right").fadeIn();
            });
        }
        function showClientMap() {
            $(".showClientNumber").load("/company/ClientMap.aspx");
            $(".showClientNumber").css("display", "block");
        }
        //2021-12月更改为操作下的远程若是pc端就和发送指令下的远程进行对换位置即pc端操作下的远程是程序远程，发送指令下的远程是网页远程，移动端就不需要换位置
        function pcOrMobile() {//判断是移动端还会pc端
            var userAgen = 0;//=0是pc,=1移动
            var sUserAgent = navigator.userAgent.toLowerCase();
            var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
            var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
            var bIsMidp = sUserAgent.match(/midp/i) == "midp";
            var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
            var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
            var bIsAndroid = sUserAgent.match(/android/i) == "android";
            var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
            var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
            if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//移动端
                userAgen = 1;
            }
            return userAgen;
        }
    </script>
</head>
<body>
    <div id="overlay"></div>
    <!-- #include file="/common/top.html" -->

    <input type="hidden" id="delSelf" value="0"/>

    <input type="hidden" id="client_main_dlevel" runat="server" />
    <input type="hidden" id="client_main_groupid" runat="server" />
    <input type="hidden" id="client_main_mark" runat="server" />
    <input type="hidden" id="client_main_edit" runat="server" />
    <input type="hidden" id="myComId" runat="server" />
    <div id="container" class="clearfix">
        <div class="pos_area clearfix">
            <div class="pos" id="client_main_pagemap" style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" runat="server">
            </div>
            <!--<input class="clientPoint" value="终端点位分布图" title="终端点位分布图" type="button" onclick="showClientMap();"/>-->
        </div>
        <!--<div class="showClientNumber">
           
        </div>-->
        <div class="ny_content clearfix">
            <div class="w210" id="client_main_left" style="overflow:auto;height:730px">
                <!--include file="client_main_left.html"-->
            </div>
            <div class="w750" id="client_main_right" style="position: relative;">
                <form id="form1" runat="server">
                    <div class="terminal_state" data-isshow="0" style="display: none; width: 748px; position: absolute; top: 84px; left: 0; z-index: 1000; background: #f7f7f7;">
                        <div class="title"><span class="language">播放终端状态查看</span><span class="inp_btn"><a href="javascript:void(0)" onclick="getclientstatus()" class="language">刷新状态统计</a></span></div>
                        <div class="cont">
                            <ul class="clearfix">
                                <li><span class="icon state_1" title="离线"></span><span class="num" id="client_main_right_status1"></span></li>
                                <li><span class="icon state_2" title="在线(任务未启动)"></span><span class="num" id="client_main_right_status2">0</span></li>
                                <li><span class="icon state_3" title="在线(任务自动执行)"></span><span class="num" id="client_main_right_status3">0</span></li>
                                <li><span class="icon state_4" title="在线(任务手动执行)"></span><span class="num" id="client_main_right_status4">0</span></li>
                                <li><span class="icon state_5" title="在线(临时信息显示)"></span><span class="num" id="client_main_right_status5">0</span></li>
                                <li><span class="icon state_6" title="在线(紧急信息显示)"></span><span class="num" id="client_main_right_status6">0</span></li>
                                <li><span class="icon state_7" title="在线(任务执行完毕)"></span><span class="num" id="client_main_right_status7"></span></li>
                                <li><span class="icon state_8" title="在线(任务暂停执行)"></span><span class="num" id="client_main_right_status8">0</span></li>
                                <li><span class="icon state_9" title="在线(用户介入)"></span><span class="num" id="client_main_right_status9">0</span></li>
                                <li><span class="icon state_10" title="在线(空闲自动执行)"></span><span class="num" id="client_main_right_status10">0</span></li>
                                <li><span class="icon state_11" title="远程控制"></span><span class="num" id="client_main_right_status11">0</span></li>
                                <li><span class="icon state_12" title="全部"></span><span class="num" id="client_main_right_status12">0</span></li>
                            </ul>
                        </div>
                    </div>
                    <div class="terminal_info">
                        <div class="title">
                            <ul>
                                <li>
                                    <input class="ss_t" type="text" id="client_main_right_key"/></li>
                                <li>
                                    <input class="ss_s language" value="查询" title="查询" type="button" onclick="client_search()"/></li>
                                <li> <%--onclick="client_search()"--%>
                                    <input class="ss_s language" value="查看状态" title="查看状态" type="button" id="client_groupinfo_reloadbtn"/></li>
                            </ul>
                        </div>
                    </div>
                    <div class="add_btn clearfix" id="client_groupinfo_btnMgr" runat="server" style="padding: 0; display: none">
                    </div>
                    <div class="add_btn clearfix" id="client_groupinfo_btnMenu" runat="server" style="padding: 0; display: none">
                    </div>
                    <div class="client_main_right_menu" style="height:600px;overflow:auto">
                        <div class="item">
                            <ul class="clearfix" id="client_main_right_menu" runat="server">
                            </ul>
                        </div>
                        <div class="terminal_con">
                        </div>
                    </div>
                    <div id="client_main_cmdbox" style="display: none"></div>
                </form>
            </div>
        </div>
    </div>
    <div class="sc_list_box" id="clientmenu_add_menu_list" style="position: absolute; left: 100px; z-index: 1001; top: 110px; display: none; width: 760px; height: 400px; overflow-y: scroll; background: #ffffff; border: 2px solid #333333; -moz-box-shadow: 3px 3px 3px #333333 inset; /* For Firefox3.6+ */ -webkit-box-shadow: 3px 3px 3px #333 inset; /* For Chrome5+, Safari5+ */ box-shadow: 3px 3px 3px #333 inset; /* For Latest Opera */">
    </div>
</body>
</html>
