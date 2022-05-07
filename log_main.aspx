<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="log_main.aspx.cs" Inherits="Web.company.log.log_main" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-首页</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/simplePagination.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/raphael-min.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script type="text/javascript">
        
        $(function () {

            if ($("#jsonValue").val() == "") {
                getJsonValue();
            }
            switchLanguage(".container", 1, "log_main.aspx");
            $.ajaxSetup({
                cache: false //close AJAX cache
            });
            loadLogPage($("#hid_logtype").val());
            //if ($.cookie("yuyan") != null && $.cookie("yuyan") != "" && $.cookie("yuyan") != undefined) {
            //    if ($.cookie("yuyan") == "en") {
            //        $(".changeLanguage img").attr("alt", "English");
            //        $(".changeLanguage img").attr("src", "images/allTitle/EN.png");
            //    } else {
            //        $(".changeLanguage img").attr("alt", "Chinese");
            //        $(".changeLanguage img").attr("src", "images/allTitle/CH.png");
            //    }

            //} else {
            //    $(".changeLanguage img").attr("alt", "中文");
            //}
            //$(".changeLanguage img").click(function () {
            //    if ($(this).attr("alt") == "English") {
            //        $.cookie("yuyan", "en", { path: "/" });
            //        $(this).attr("alt", "中文");
            //        $(this).attr("src", "images/allTitle/CH.png");
            //        // debugger;
            //        switchLanguage(1, "pctrl.html");
            //    } else {
            //        $.cookie("yuyan", "CH", { path: "/" });
            //        $(this).attr("alt", "English");
            //        $(this).attr("src", "images/allTitle/EN.png");
            //        //  debugger;
            //        switchLanguage(0, "pctrl.html");


            //    }
            //    getLanguageMsg("获取数据出错!", $.cookie("yuyan"));
            //    $("#downLoad span").html(getLanguageMsg("下载", $.cookie("yuyan")));
            //    $("#checkFile span").html(getLanguageMsg("预览", $.cookie("yuyan")));
            //    if ($("#Screen .left").length <= 0 && $("#pic img").attr("src").indexOf("fail1") >= 0) {
            //        $("#Screen").html("<p align='center' style='width:100%;font-size:22px;color:red;'>" + getLanguageMsg("获取数据出错!", $.cookie("yuyan")) + "</p>");
            //    }
            //});
            
        })
        function loadLogPage(type) {
            $("#log_ment_nav li[data-id=" + type + "]").addClass("current").siblings().removeClass("current");
            var rd = Math.random();
          
            if (type == 0) {
                $(".pos").html('<a href="javascript:" onclick="loadLohPage(0)">' + getLanguageMsg("日志管理", $.cookie("yuyan")) + '</a>><a class="current" onclick="loadLohPage(0)">' + getLanguageMsg("操作日志管理", $.cookie("yuyan")) + '</a>');
                $(".source_con").load("Log_List.aspx", { "rd": rd, "aaa": "111" }, function () {
                    $(".source_con").fadeIn();
                });
            }
            if (type == 1) {
                $(".pos").html('<a href="javascript:" onclick="loadLohPage(1)">' + getLanguageMsg("日志管理", $.cookie("yuyan")) + '</a>><a class="current" onclick="loadLohPage(1)">' + getLanguageMsg("播放日志管理", $.cookie("yuyan")) + '</a>');
                $(".source_con").load("PlayLog_List.aspx", { "rd": rd }, function () {
                    $(".source_con").fadeIn();
                });
            }
            if (type == 2) {
                $(".pos").html('<a href="javascript:" onclick="loadLohPage(2)">' + getLanguageMsg("日志管理", $.cookie("yuyan")) + '</a>><a class="current" onclick="loadLohPage(2)">' + getLanguageMsg("运行日志管理", $.cookie("yuyan")) + '</a>');
                $(".source_con").load("RunLog_List.aspx", { "rd": rd }, function () {
                    $(".source_con").fadeIn();
                });
            }
            if (type == 3) {
                $(".pos").html('<a href="javascript:" onclick="loadLohPage(3)">' + getLanguageMsg("日志管理", $.cookie("yuyan")) + '</a>><a class="current" onclick="loadLohPage(3)">' + getLanguageMsg("终端反馈信息管理", $.cookie("yuyan")) + '</a>');
                $(".source_con").load("RectLog_List.aspx", { "rd": rd }, function () {
                    $(".source_con").fadeIn();
                });
            }

        }
        $("#log_ment_nav li").live("click", function () {
           // loadLogPage($(this).attr("data-id"));
            $("#hid_logtype").val($(this).attr("data-id"));
            window.location.href = window.location.href.replace(window.location.search, "?type=" + $(this).attr("data-id"));
        });
        function DeleteLog() {
            var sellist = "";
            $("input[name=ch_log]:checkbox").each(function () {
                if ($(this).attr("checked")) {
                    sellist += $(this).val() + ",";
                }
            });
            if (sellist == "") {
                TopTrip(getLanguageMsg("请选择您要删除的日志", $.cookie("yuyan")), 2);
            }
            else {
                showDeleteLogTrip($("#hid_logtype").val(), sellist);
            }
        }
        $("#checkall").die().live("click", function () {

            if ($(this).attr("checked")) {
                $("input[name=ch_log][value!=all]").attr("checked", "checked");
            }
            else {
                $("input[name=ch_log]").removeAttr("checked");
            }
        });
        //$("a[name=btn_delLog]").die().live("click", function () {
        //    var idlist = $(this).attr("data-logid");
        //    var type = $(this).attr("data-logtype");
        //    $.ajax({
        //        type: "post",
        //        url: 'ajax/getplaylog.ashx',
        //        async: false,
        //        dataType: 'text',
        //        data: {
        //            where: where,
        //            pagesize: pagesize,
        //            lastid: lastid
        //        },
        //        success: function (data) {
        //            if (data > 0) {
        //                TopTrip("删除成功！", 1);
        //                window.location.reload();
        //            }
        //            else {
        //                TopTrip("删除失败！", 2);
        //            }
        //        }
        //    });
        //});
        $("a[name=btn_delLog]").die().live("click", function () {
            var idlist = $(this).attr("data-logid");
            var type = $(this).attr("data-logtype");
            var boxId = $(this).attr("data-id");
            $("#" + boxId).remove();
            $.ajax({
                type: "post",
                url: 'ajax/dellog.ashx',
                async: false,
                dataType: 'text',
                data: {
                    type: type,
                    idlist: idlist
                },
                success: function (data) {
                    if (data > 0) {
                        TopTrip(getLanguageMsg("删除成功！", $.cookie("yuyan")), 1);
                        //$("#log_ment_nav li[data-id=" + boxId + "]").click();也可以，，如果地址栏 网址有问题
                        window.location.reload();
                    }
                    else {
                        TopTrip(getLanguageMsg("删除失败！", $.cookie("yuyan")), 2);
                    }

                }
            });
        });
        $("a[name=btn_candel]").die().live("click", function () {
            var boxId = $(this).attr("data-id");//0 操作日志, 1 播放日志管理,  2 运行日志管理, 3 终端反馈信息管理
            $("#" + boxId).remove();
        });
        //导出日志
        function exportData(type) {
            var pageLog = $("#log_ment_nav li.current").attr("data-id");
            var url = "ajax/getloglist.ashx";
            switch (pageLog) {
                case "1":
                    url = "ajax/getplaylog.ashx"; break;
                case "2":
                    url = "ajax/getrunloglist.ashx"; break;
                case "3":
                    url = "ajax/getrectlog.ashx"; break;
            }
           // url = url+"?myWhere="+searchWhere(pageLog);
            var myWhere1 = searchWhere(pageLog);
            
            url += "?action=ExportData&myType="+type+"&myWhere="+myWhere1;
            var ptop = window.screen.height / 2 - 400;
            var pleft = window.screen.width / 2 - 700;
            var a = window.open(url, "daochu", 'left=' + pleft + ',top=' + ptop + ',height=400,width=700,toolbar=no,menubar=no,scrollbars=no,status=no,location=no,resizable=no');
            a.focus();
            var loadTimer = setInterval(function () {
                if (a.closed) {
                    clearInterval(loadTimer);
                    $("#log_btn_search").click();// 刷新下面列表，才能看到数据。。
                }
            }, 500);
            //if (a) {
            //    console.log("export....ok....");
            //   // $("#log_ment_nav li.current").click();
            //}
            //$.post(url, { "action": "ExportData", "myType": type, "myWhere": myWhere1 }, function (da) {
            //    console.log(da);
            //});
        }
        //拼接查询条件
        function searchWhere(stype) {//0 1 2 3
            $("#log_list tr[data-type=data]").remove();
            var username = ""; var tablename = "";
            var selName = ""; var selTabName = "";
            var sqlWhere = "";
            switch (stype) {
                case "0":
                    selName = "log_username"; selTabName = "log_tablename"; break;
                case "1":
                    selName = "log_clientname"; selTabName = "log_itemname"; break;
                case "2":
                    selName = "log_clientname"; selTabName = ""; break;
                case "3":
                    selName = "log_clientname"; selTabName = ""; break;

            }
            if ($("#" + selName).val() != "" && $("#" + selName).val() != $("#" + selName).attr("no-msg")) {
                username = $("#" + selName).val();
            }            
            if (selTabName!="" && $("#" + selTabName).val() != "" && $("#" + selTabName).val() != $("#" + selTabName).attr("no-msg")) {
                tablename = $("#" + selTabName).val();
            }
            var operattime = "";
            if ($("#log_opertime").val() != "选择开始日期" && new Date($("#log_opertime").val()) != "Invalid Date") {
                operattime = $("#log_opertime").val();
            }
            if ($("#log_opertime2").val() != "选择结束日期" && new Date($("#log_opertime2").val()) != "Invalid Date") {
                operattime = operattime + "&" + $("#log_opertime2").val();
            }
            if (selTabName == "") {//没有第二个文本框，查询条件。
                if ($("#hid_dealstatus").length > 0) {//终端反馈信息。。
                    return username + "|" + operattime + "|" + $("#hid_dealstatus").val() + "|" + $("#hid_daterange").val();
                }
                return username + "|" + operattime + "|" + $("#hid_daterange").val();
            } else { //不一样，有的页面 条件多。。
                
                return username + "|" + tablename + "|" + operattime + "|" + $("#hid_daterange").val();
            }
        }
    </script>
    <style>
        #log_list a{
            color:#666;
        }
            #log_list a:hover {
                text-decoration:none;
            }
        .clearfix input[type=text]::-ms-clear {
          display:none
        }
    </style>
</head>
<body>
    <!-- #include file="/common/top.html" -->
    <div class="container clearfix" style="display: block">
        <input type="hidden" id="hid_logtype" runat="server" />

        <div class="pos_area clearfix">
            <div class="pos"></div>
            <div class="editbtn">
                <div class="source_edit">
                    <span>
                        <a href="JavaScript:void(0)" title="导出TXT" onclick="exportData('txt')"><img src="/images/txt.png" /></a>
                        <a href="JavaScript:void(0)" title="导出Excel" onclick="exportData('xls')"><img src="/images/xls.png" /></a>
                    </span>
                    <span>
                        <input type="checkbox" name="ch_log" value="all" id="alldelete"/><label for="alldelete" class="language">所有</label></span>
                    <span><a href="JavaScript:void(0)" title="删除" onclick="DeleteLog()" class="language">删除</a></span>
                    <%--<ul class="l_export">
                        <li><a href="#"><span class="txt_icon"></span></a></li>
                        <li><a href="#"><span class="exe_icon"></span></a></li>
                    </ul>--%>
                </div>
            </div>
        </div>
        <div class="ny_content">
            <div class="log_tab_tit">
                <ul class="clearfix" id="log_ment_nav" runat="server">
                </ul>
            </div>
            <div class="source_con">
            </div>
        </div>
    </div>
</body>
</html>