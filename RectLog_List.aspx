<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RectLog_List.aspx.cs" Inherits="Web.company.log.RectLog_List" %>

<script type="text/javascript">

    var pagesize = 15;
    var lastid = 0;
    var where = "|||";
    $(function () {
     
        getlogData();
        switchLanguage(".source_con", 1, "RectLog_List.aspx");
    })
    function getlogData() {
        $.ajax({
            type: "post",
            url: 'ajax/getrectlog.ashx',
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
        $.each(data.Table, function (idx, item) {
            var type = "";
            var status = "";
            if (item.reacttype == 0)
            {
                type = "看到了";
            }
            if (item.reacttype == 1) {
                type = "感兴趣";
            }
            if (item.reacttype == 2) {
                type = "请联系我";
            }
            if (item.reacttype == 3) {
                type = "请上门洽谈";
            }
            if (item.reacttype == 4) {
                type = "申请优惠券";
            }
            if (item.dealstatus == 0)
            {
                status = "未处理";
            }
            if (item.dealstatus == 1) {
                status = "处理完毕,不感兴趣";
            }
            if (item.dealstatus == 2) {
                status = "处理完毕,感兴趣";
            }
            if (item.dealstatus == 3) {
                status = "处理完毕,很感兴趣";
            }
            if (item.dealstatus == 4) {
                status = "处理完毕,合作成功";
            }
            if (item.dealstatus == 5) {
                status = "处理完毕,无效反馈/举报/评级";
            }
            if (item.dealstatus == 6) {
                status = "处理完毕,信息有误";
            }
            
            html += '<tr data-type="data" data-id="' + item.reactlogid + '"><td><input type="checkbox" name="ch_log" id="ch_log' + i + '" value="' + item.reactlogid + '"><label for="ch_log' + i + '">' + item.reactlogid + '</label></td>';
            html += '<td><a href="javascript:">' + item.logtime + '</a></td>';
            html += '<td>' + item.companyid + '</td>';
            html += '<td>' + item.clientname + '</td>';
            html += '<td>' + item.itemid + '</td>';
            html += '<td>' + item.reactpoint + '</td>';
            html += '<td>' + type + '</td>';
            html += '<td>' + item.reactinfo + '</td>';
            html += '<td>' + status + '</td>';
            //pageid = item.reactlogid;//item.logid;
            lastid = item.reactlogid;
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
    $("#rlog_date_range dd a").die().live("click", function () {
        
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
    $("#log_dealstatus dd a").die().live("click", function () {
       
        if ($(this).attr("data-issel") == "0") {
            $(this).attr("data-issel", "1");
            $(this).addClass("current").parent("li").siblings().children().removeClass("current");
            $("#hid_dealstatus").val($(this).attr("data-value"));

        }
        else {
            $(this).attr("data-issel", "0");
            $(this).removeClass("current");
            $("#hid_dealstatus").val("");
        }
        search();
    });
    function search() {
        $("#log_list tr[data-type=data]").remove();
        var clientname = "";
        var operattime = "";
        if ($("#log_clientname").val() != "" && $("#log_clientname").val() != $("#log_clientname").attr("no-msg")) {
            clientname = $("#log_clientname").val();
        }
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
        //if ($("#log_opertime").val() != "" && $("#log_opertime").val() != $("#log_opertime").attr("no-msg") && $("#log_opertime2").val() != "") {
        //    operattime = $("#log_opertime").val() + "&" + $("#log_opertime2").val();
        //}
        where = clientname + "|" + operattime + "|" + $("#hid_dealstatus").val() + "|" + $("#hid_daterange").val();
        lastid = 0;
        getlogData();
    }
</script>


<div class="sc_search">
    <ul class="clearfix">
        <li>
            <input type="text" class="inp_t language" placeholder="播放终端名" value="" no-msg="播放终端名" id="log_clientname" /></li>

        <li>
            <input type="text" class="inp_t date_icon language" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd',maxDate:new Date })" value="选择开始日期" no-msg="选择开始日期" onfocus="{if(this.value=='选择开始日期'){this.value='';}}" id="log_opertime" /><span class="date_icon"></span>

        </li>
         <li>
            <input type="text" class="inp_t date_icon language" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd', maxDate: new Date })" value="选择结束日期" no-msg="选择结束日期" onfocus="{if(this.value=='选择结束日期'){this.value='';}}" id="log_opertime2" /><span class="date_icon"></span>

        </li>
        <li>
            <input type="button" class="inp_s language" id="log_btn_search" title="搜索" /></li>
    </ul>
</div>
<div class="sc_select_attr">
    <input type="hidden" id="hid_dealstatus" value="" />
    <dl class="clearfix" id="log_dealstatus">
        <dt class="language">处理状态：</dt>
        <dd><a class="sel_item language" data-issel="0" data-value="0">未处理</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="1">不感兴趣</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="2">感兴趣</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="3">很感兴趣</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="4">合作成功</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="5">无效反馈</a></dd>
        <dd><a class="sel_item language" data-issel="0" data-value="6">信息有误</a></dd>
    </dl>
    <input type="hidden" id="hid_daterange" value="0" />
    <dl class="clearfix" id="rlog_date_range">
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
            <th class="language" width="75">序号<input type="checkbox" value="*" name="ch_log" id="checkall" style="margin-left: 6px;" /><label for="checkall" class="language">全选</label></th>
            <th class="language" width="100">添加时间</th>
            <th class="language" width="110">所属单位</th>
            <th class="language" width="120">播放终端名称</th>
            <th class="language" width="80">素材标记</th>
            <th class="language" width="100">反馈时间</th>
            <th class="language" width="90">反馈类型</th>
            <th class="language" width="100">反馈信息</th>
            <th class="language" width="80">状态</th>
        </tr>
    </table>
    <div class="loading_more" id="list_loadmore">
        <a onclick="More_list_shownext()" href="javascript:void(0)"><b></b><span class="language">加载更多</span></a>
    </div>
</div>
