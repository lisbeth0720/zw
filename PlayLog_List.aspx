<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PlayLog_List.aspx.cs" Inherits="Web.company.log.PlayLog_List" %>

<script type="text/javascript">

    var pagesize = 15;
    var lastid = 0;
    var where = "|||";
    $(function () {
        //初始化
        
       
        getlogData();
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
        //    //} else {
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
        switchLanguage(".source_con",1, "PlayLog_List.aspx");
    })
    function getlogData() {
        $.ajax({
            type: "post",
            url: 'ajax/getplaylog.ashx',
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
        var i = 0;
        var myclientName = "";
        var myWindow = ""; var oldItemname = "";
        $.each(data.Table, function (idx, item) {
            myclientName = item.clientname;
            if (myclientName.length>4) {
                myclientName = myclientName.substr(0,4)+"...";
            }
            oldItemname = item.itemname;
            if (oldItemname.length>7) {
                oldItemname = oldItemname.substr(0,8)+"...";
            }
            myWindow = item.window;
            if (myWindow.length>7) {
                myWindow = myWindow.substr(0,8)+"...";
            }
            //html += '<tr data-type="data" data-id="' + item.playlogid + '"><td><input type="checkbox" name="ch_log" value="' + item.logid + '">' + item.logid + '</td>';
            html += '<tr data-type="data" data-id="' + item.playlogid + '"><td><input type="checkbox" name="ch_log" id="ch_log' + i + '" value="' + item.playlogid + '"><label for="ch_log' + i + '">' + item.playlogid + '</label></td>';
            html += '<td><a href="javascript:">' + item.logtime + '</a></td>';
            html += '<td>' + item.companyid + '</td>';
            html += '<td title="' + item.clientname + '">' + myclientName + '</td>';
            html += '<td title="' + item.itemname + '">' + oldItemname + '</td>';
            html += '<td title="' + item.window + '">' + myWindow + '</td>';
            html += '<td>' + item.starttime + '</td>';
            html += '<td>' + item.totaltime + '</td>';
            html += '<td>' + item.totalcircle + '</td></tr>';
            //pageid = item.logid;
            lastid = item.playlogid;
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
    $("#plog_date_range dd a").die().live("click", function () {
       
        if ($(this).attr("data-isel") == "0") {
            $(this).attr("data-isel", "1");
          
            $(this).addClass("current").parent("li").siblings().children().removeClass("current");
            $("#hid_daterange").val($(this).attr("data-value"));

        }
        else {
            $(this).attr("data-isel", "0");
            $(this).removeClass("current");
            $("#hid_daterange").val(0);
        }
        search();
    });
    function search() {
        $("#log_list tr[data-type=data]").remove();
        var clientname = "";
        if ($("#log_clientname").val() != "" && $("#log_clientname").val() != $("#log_clientname").attr("no-msg")) {
            clientname = $("#log_clientname").val();
        }
        var itemname = "";
        if ($("#log_itemname").val() != "" && $("#log_itemname").val() != $("#log_itemname").attr("no-msg")) {
            itemname = $("#log_itemname").val();
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
        //if ($("#log_opertime").val() != "" && $("#log_opertime").val() != $("#log_opertime").attr("no-msg") && $("#log_opertime2").val()!="") {
        //    operattime = $("#log_opertime").val() + "&" + $("#log_opertime2").val();
        //}
        where = clientname + "|" + itemname + "|" + operattime + "|" + $("#hid_daterange").val();
        lastid = 0;
        getlogData();
    }
</script>


<div class="sc_search">
    <ul class="clearfix">
        <li>
            <input type="text" class="inp_t language" value="" placeholder="播放终端名" no-msg="播放终端名" id="log_clientname" /></li>
        <li>
            <input type="text" class="inp_t language" placeholder="素材名称" value="" no-msg="素材名称" id="log_itemname" /></li>
        <li>
            <input type="text" class="inp_t date_icon language" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd',maxDate:new Date() })" placeholder="选择开始日期" no-msg="选择开始日期" id="log_opertime" /><span class="date_icon"></span>

        </li>
         <li>
            <input type="text" class="inp_t date_icon language" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd', maxDate: new Date() })" placeholder="选择结束日期" no-msg="选择结束日期" id="log_opertime2" /><span class="date_icon"></span>

        </li>
        <li>
            <input type="button" class="inp_s language" id="log_btn_search" title="搜索" /></li>
    </ul>
</div>
<div class="sc_select_attr">
    <input type="hidden" id="hid_daterange" value="0" />
    <dl class="clearfix" id="plog_date_range">
        <dt class="language">时间范围：</dt>
        <dd><a class="sel_item language" data-isel="0" data-value="1">最近一天</a></dd>
        <dd><a class="sel_item language" data-isel="0" data-value="3">最近三天</a></dd>
        <dd><a class="sel_item language" data-isel="0" data-value="7">最近一周</a></dd>
        <dd><a class="sel_item language" data-isel="0" data-value="14">最近二周</a></dd>
        <dd><a class="sel_item language" data-isel="0" data-value="30">最近一月</a></dd>
    </dl>
</div>
<div class="sc_result">
    <table class="tab_sc_list" id="log_list">
        <tr>
            <th class="language" width="90">序号<input type="checkbox" value="*" name="ch_log" id="checkall" style="margin-left: 9px;" /><label for="checkall">全选</label></th>
            <th class="language" width="130">记录时间</th>
            <th class="language" width="130">所属单位</th>
            <th class="language" width="125">播放终端名称</th>
            <th class="language" width="100">素材标记</th>
            <th class="language" width="120">窗口名</th>
            <th class="language" width="140">启动时间</th>
            <th class="language" width="70">总时间</th>
            <th class="language" width="80">循环次数</th>
        </tr>
    </table>
    <div class="loading_more" id="list_loadmore">
        <a onclick="More_list_shownext()" href="javascript:void(0)" ><b></b><span class="language">加载更多</span></a>
    </div>
</div>
