<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Log_List.aspx.cs" Inherits="Web.company.log.Log_List" %>

<style>
    #list_loadmore a:hover
    {
     background:#61c6f8;
    }
    #list_loadmore > a > b
    {padding-left:20px;
     background:url(/images/tubiaoa.png) -90px -52px;
    }
    #list_loadmore a:hover b
    { background:url(/images/tubiaoa.png) -90px -80px;
    }
</style>
<script type="text/javascript">

    var pagesize = 15;
    var lastid = 0;
    var where = "|||";
    $(function () {
        getlogData();
        if ($.cookie("yuyan") != null && $.cookie("yuyan") != "" && $.cookie("yuyan") != undefined) {
            //if ($.cookie("yuyan") == "en") {
            //    $(".changeLanguage img").attr("alt", "English");
            //    $(".changeLanguage img").attr("src", "images/allTitle/EN.png");
            //} else {
            //    $(".changeLanguage img").attr("alt", "Chinese");
            //    $(".changeLanguage img").attr("src", "images/allTitle/CH.png");
            //}

        } else {
            //$(".changeLanguage img").attr("alt", "中文");
        }
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
        
        switchLanguage(".source_con",1, "Log_List.aspx");
       
    })
    function getlogData() {
        $.ajax({
            type: "post",
            url: 'ajax/getloglist.ashx',
            async: false,
            dataType: 'text',
            data: {
                where: where,
                pagesize: pagesize,
                lastid: lastid
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);
                    showlogdata(json);
                }
            }
        });
    }
    function showlogdata(data) {
        var html;
        var i=0;
        $.each(data.Table, function (idx, item) {
            html += '<tr data-type="data" data-id="' + item.logid + '"><td><input type="checkbox" name="ch_log" id="ch_log' + i + '" value="' + item.logid + '"><label for="ch_log' + i + '">' + item.logid + '</label></td>';
            html += '<td><a href="javascript:">' + item.companyid + '</a></td>';
            html += '<td>' + item.username + '</td>';
            html += '<td>' + item.opertime.replace(/\//g, '-'); + '</td>';//"2017/9/11 16:46:00"  ---"2017-9-11 16:46:00"
            html += '<td>' + item.tablename + '</td>';
            html += '<td>' + item.type + '</td>';
            html += '<td>' + item.descript + '</td></tr>';
            //pageid = item.logid;
            lastid = item.logid;
            i++;
        });
        $("#log_list").append(html);
    }

    function More_list_shownext() {
        getlogData();
    }
    $("#log_btn_search").die().live("click", function () {
        search();
    });
    $("#mlog_date_range dd a").die().live("click", function () {
        
        if ($(this).attr("data-issel") == "0") {
            $(this).attr("data-issel", "1");
            $(this).addClass("current").parent("li").siblings().children().removeClass("current");
            $("#hid_daterange").val($(this).attr("data-value"));

        }
        else {
            $(this).attr("data-issel", "0");
            $(this).removeClass("current");
            $("#hid_daterange").val(0);
        }
        search();
    });
    function search() {
        $("#log_list tr[data-type=data]").remove();
        var username = "";
        if ($("#log_username").val() != "" && $("#log_username").val() != $("#log_username").attr("no-msg")) {
            username = $("#log_username").val();
        }
        var tablename = "";
        if ($("#log_tablename").val() != "" && $("#log_tablename").val() != $("#log_tablename").attr("no-msg")) {
            tablename = $("#log_tablename").val();
        }
        var operattime = "";
        if (new Date($("#log_opertime").val()) != "Invalid Date") {
            operattime = $("#log_opertime").val();
        }
        if (new Date($("#log_opertime2").val()) != "Invalid Date") {
            operattime = operattime + "&" + $("#log_opertime2").val();
        }
        //if ($("#log_opertime").val() != "选择开始日期") {
        //    operattime = $("#log_opertime").val();
        //}
        //if ($("#log_opertime2").val() != "选择结束日期") {
        //    operattime = operattime + "&" + $("#log_opertime2").val();
        //}
        //if ($("#log_opertime").val() != "" && $("#log_opertime").val() != $("#log_opertime").attr("no-msg" && $("#log_opertime2").val() != "")) {
        //    operattime = $("#log_opertime").val() + "&" + $("#log_opertime2").val();
        //}
        where = username + "|" + tablename + "|" + operattime + "|" + $("#hid_daterange").val();
        lastid = 0;
        getlogData();
    }
</script>


<div class="sc_search">
    <ul class="clearfix">
        <li>
            <input type="text" class="inp_t language" value="" placeholder="操作员" no-msg="操作员"  id="log_username" /></li>
        <li>
            <input type="text" class="inp_t language" placeholder="操作表" value="" no-msg="操作表" id="log_tablename" /></li>
        <li>
            <input type="text" class="inp_t date_icon language" placeholder="选择开始日期" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd' })" value="选择开始日期"  placeholder="选择开始日期" no-msg="选择开始日期"  id="log_opertime" />

        </li>
         <li>
            <input type="text" class="inp_t date_icon language" placeholder="选择结束日期" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd' })" value="选择结束日期" placeholder="选择结束日期" no-msg="选择结束日期"  id="log_opertime2" />

        </li>
        <li>
            <input type="button" class="inp_s" id="log_btn_search" title="搜索" /></li>
    </ul>
</div>
<div class="sc_select_attr">
    <input type="hidden" id="hid_daterange" value="0" />
    <dl class="clearfix" id="mlog_date_range">
        <dt class="language">时间范围：</dt>
        <dd><a class="sel_item language" data-issel="0" data-value="1">最近一天</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="3">最近三天</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="7">最近一周</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="14">最近二周</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="30">最近一月</a></dd>
    </dl>
</div>
<div class="sc_result">
    <table class="tab_sc_list" id="log_list">
        <tr>
            <th width="80" class="language">序号<input type="checkbox" value="*" name="ch_log" id="checkall" style="margin-left: 10px;" />全选</th>
            <th width="140" class="language">单位</th>
            <th width="100" class="language">操作者</th>
            <th width="140" class="language">操作时间</th>
            <th width="150" class="language">操作表</th>
            <th width="100" class="language">类型</th>
            <th width="180" class="language">描述</th>
        </tr>
    </table>
    <div class="loading_more" id="list_loadmore">
        <a onclick="More_list_shownext()" href="javascript:void(0)"><b></b><span  class="language">加载更多</span></a>
    </div>
</div>
