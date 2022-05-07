<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RunLog_List.aspx.cs" Inherits="Web.company.log.RunLog_List" %>

<script type="text/javascript">

    var pagesize = 15;
    var lastid = 0;
    var where = "||";
    $(function () {
        $(".sel_item").attr("data-issel",0);
        getlogData();
        switchLanguage(".source_con", 1, "RunLog_List.aspx");
    })
    function getlogData() {
        $.ajax({
            type: "post",
            url: 'ajax/getrunloglist.ashx',
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
            html += '<tr data-type="data" data-id="' + item.runlogidrunlogid + '"><td><input type="checkbox" name="ch_log" id="checkbox' + i + '" value="' + item.runlogid + '"><label for="checkbox' + i + '">' + item.runlogid + '</label></td>';
            html += '<td><a href="javascript:">' + item.logtime + '</a></td>';
            html += '<td>' + item.companyid + '</td>';
            html += '<td>' + item.clientname + '</td>';
            html += '<td>' + item.cpu + '</td>';
            html += '<td>' + item.diskspace + '</td>';
            html += '<td>' + item.ip + '</td>';
            html += '<td>' + item.descript + '</td></tr>';
            //pageid = item.runlogid;
            lastid = item.runlogid;
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
    $("#rulog_date_range dd a").die().live("click", function () {
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
        var clientname = "";
        if ($("#log_clientname").val() != "" && $("#log_clientname").val() != $("#log_clientname").attr("no-msg")) {
            clientname = $("#log_clientname").val();
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
        //if ($("#log_opertime").val() != "" && $("#log_opertime").val() != $("#log_opertime").attr("no-msg") && $("#log_opertime2").val() != "") {
        //    operattime = $("#log_opertime").val()+"&"+$("#log_opertime2").val() ;
        //}
        where = clientname + "|" + operattime + "|" + $("#hid_daterange").val();
        lastid=0;
        getlogData();
    }
</script>
<div class="sc_search">
    <ul class="clearfix">
        <li>
            <input type="text" class="inp_t language" placeholder="播放终端名" value="" no-msg="播放终端名" id="log_clientname" /></li>
        <li>
            <input type="text" class="inp_t date_icon language" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd',maxDate:new Date() })" placeholder="选择开始日期" value="选择开始日期" no-msg="选择开始日期" onfocus="{if(this.value=='选择开始日期'){this.value='';}}" id="log_opertime" /><span class="date_icon"></span>

        </li>
        <li>
            <input type="text" class="inp_t date_icon language" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd', maxDate: new Date() })"  placeholder="选择结束日期" value="选择结束日期" no-msg="选择结束日期" onfocus="{if(this.value=='选择结束日期'){this.value='';}}" id="log_opertime2" /><span class="date_icon"></span>

        </li>
        <li>
            <input type="button" class="inp_s language" id="log_btn_search" title="搜索" /></li>
    </ul>
</div>
<div class="sc_select_attr">
    <input type="hidden" id="hid_daterange" value="0">
    <dl class="clearfix" id="rulog_date_range">
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
            <th class="language" width="80">序号<input type="checkbox" value="*" name="ch_log" id="checkall" style="margin-left: 7px;" /><label for="checkall">全选</label></th>
            <th class="language" width="140">记录时间</th>
            <th class="language" width="140">所属单位</th>
            <th class="language" width="140">播放终端名称</th>
            <th class="language" width="100">CPU使用百分比</th>
            <th class="language" width="100">剩余磁盘空间</th>
            <th class="language" width="120">IP地址</th>
            <th class="language" width="100">其他信息</th>
        </tr>
    </table>
    <div class="loading_more" id="list_loadmore">
        <a onclick="More_list_shownext()" href="javascript:void(0)"><b></b><span  class="language">加载更多</span></a>
    </div>
</div>
