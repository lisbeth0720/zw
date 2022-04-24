<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_list2.aspx.cs" Inherits="Web.company.client.client_list2" %>

<script type="text/javascript">
    var dlevel, clientid, clientmark;
    var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
    var isvirtualgroup = "no";
    $(function () {
        dlevel = $("#client_list2_dlevel").val();
        clientid = $("#client_list2_groupid").val();
        clientmark = $("#client_list2_remark").val();
        $("#client_main_pagemap").html('<a href="javascript:void(0)">播放终端管理</a>><a href="javascript:void(0)">播放终端列表</a>' + $("#client_list2_pageMap").val());
        $("#client_list2_searchkey").focus(function () {
            if ($(this).val() == "请输入关键词") {
                $(this).val("");
                $(this).parent().css("border-color", "#959595");
            }
        });
        var selectClientID = "";
        if (treeObj.getSelectedNodes().length > 0) {                      
            if (treeObj.getSelectedNodes()[0].groupflag == "2") {////点击了‘虚拟组’
                isvirtualgroup = "yes";
            }
            selectClientID = treeObj.getSelectedNodes()[0].id;
        }
        client_list2_getdata("", isvirtualgroup, selectClientID);
    })
    function client_list2_getdata(name,isvirtual,selectID) {
        $.ajax({
            type: 'post',
            url: 'ajax/getngclient.ashx',
            async: true,
            dataType: 'text',
            data: { "name": name,"virtualGroup":isvirtual,"groupid":selectID },
            success: function (data) {
                var json = strToJson(data);//[] //查询无结果。给提示！！
                var i = 0;
                if (json.Table.length<=0) {
                    $("#client_list2_tab").html('<tr><th width="80">序号</th><th width="200">终端名称</th><th width="180">终端地址</th><th width="180">开机时间</th><th width="150">关机时间</th></tr>' + '<tr><td colspan="5">没有数据！</td></tr>');
                } else {
                    client_list2_showdata(json);
                }
                //$.each(json.Table, function (idx, item) {
                    //var json = strToJson(data);
                    //client_list2_showdata(json);
                //});
            }
        });
    }
    function client_list2_showdata(json) {
        $("#client_list2_tab").html('<tr><th width="80">序号</th><th width="200">终端名称</th><th width="180">终端地址</th><th width="180">开机时间</th><th width="150">关机时间</th></tr>');
        var clientnum = 1;

        $.each(json.Table, function (idx, item) {
            //debugger;
            var startTime = item.startuptime;
            if (startTime.indexOf(":") > 0) {
                startTime = startTime.slice(0, 5)
            } else {
                startTime = "";
            }
            var closeTime = item.shutdowntime;
            if (closeTime.indexOf(":") > 0) {
                closeTime = closeTime.slice(0, 5)
            } else {
                closeTime = "";
            }
            $("#client_list2_tab").append('<tr data-id="' + item.clientid + '" title="' + item.clientid + '"><td><input type="checkbox" name="client_list2_client_check" value="' + item.clientid + '">' + clientnum+ '</td>'
                + '<td>' + item.clientname + '</td>'
                + '<td>' + item.ip + '</td>'
                + '<td>' + startTime + '</td>'
                + '<td>' + closeTime + '</td></tr>'
                );
            clientnum = clientnum + 1;
        });
    }
    function client_list2_search() {
        //if ($("#client_list2_searchkey").val() == "") {
        //    $("#client_list2_searchkey").val("请输入关键词");
        //    $("#client_list2_searchkey").parent().css("border-color", "#f00000");
        //    return false;
        //}
        //else {
            var selectClientID = "";
            if (treeObj.getSelectedNodes().length > 0) {
                if (treeObj.getSelectedNodes()[0].groupflag == "2") {////点击了‘虚拟组’
                    isvirtualgroup = "yes";
                }
                selectClientID = treeObj.getSelectedNodes()[0].id;
            }
            client_list2_getdata($("#client_list2_searchkey").val(),isvirtualgroup,selectClientID);
        //}
    }
    $("#client_list2_checkall").click(function () {
        if ($(this).attr("checked") == "checked") {
            $("input[name=client_list2_client_check]").each(function () {
                $(this).attr("checked", true);
            })
        }
        else {
            $("input[name=client_list2_client_check]").each(function () {
                $(this).attr("checked", false);
            })
        }
    });
  
    $("#client_list2_quickadd").click(function () {
        //判断选择终端个数
        if ($("input[name=client_list2_client_check]:checked").length <= 0) {
            TopTrip("选择要引入的终端", 2);
            return;
        }
        $.ajax({
            type: 'post',
            url: 'ajax/IsShouQuan.ashx',
            async: true,
            data: { "mark": $("#client_list2_remark").val() },
            dataType: 'text',
            success: function (data) {
                if (data > 0) {
                    var selid = "";
                    var selname = "";
                    $("input[name=client_list2_client_check]:checked").each(function () {
                        selid = selid + $(this).val() + ",";
                        selname = selname + $(this).parent().next().html() + ",";
                    });
                    if (selid == "") {
                        TopTrip("选择要引入的终端", 2); //ShowSysWarn("您没有选择任何选项");
                        return false;
                    }
                    else {
                        if (treeObj.getSelectedNodes().length > 0) {
                            if (treeObj.getSelectedNodes()[0].groupflag == "2") {////‘虚拟组’ 添加终端。。。
                                isvirtualgroup = "yes";
                            }
                        }
                        $.post("ajax/quickaddclient.ashx", { "selid": selid, "gid": $("#client_list2_groupid").val(), "mark": $("#client_list2_remark").val(), "selname": selname,"isvirtual":isvirtualgroup }, function (data) {
                            var json = strToJson(data);
                            var addlist = json.addlist.split(",");
                            for (var i = 0; i < addlist.length; i++) {
                                if (addlist[i] != "") {
                                    $("tr[data-id=" + addlist[i] + "]").remove();
                                }
                            }

                        })
                        loadParentPage1();
                    }
                }
                else if (data == 0) {
                    TopTrip("您没有该终端组的操作权限!", 2);
                }
                else {
                    LoginTimeOut();
                }
            }
        });
       
    });
    $("#client_list2_quickdelete").click(function () {
        var clientStr = "";
        var clientArr = [];
        //判断选择终端个数
        if ($("input[name=client_list2_client_check]:checked").length <= 0) {
            TopTrip("选择要引入的终端", 2);
            return;
        } else {
            $("input[name=client_list2_client_check]:checked").each(function () {
                clientArr.push($(this).val());
            });
            clientStr = clientArr.join(",");
        }
        $.ajax({
            url: 'ajax/Deletegetngclient.ashx',
            type: 'get',
            dataType: 'json',
            dataType: 'text',
            data: {
                clientid: clientStr
            },
            success: function (data) {
                if (data.toLocaleLowerCase() == "ok") {
                    TopTrip("删除成功！", 1);
                    var selectClientID = "";
                    if (treeObj.getSelectedNodes().length > 0) {
                        if (treeObj.getSelectedNodes()[0].groupflag == "2") {////点击了‘虚拟组’
                            isvirtualgroup = "yes";
                        }
                        selectClientID = treeObj.getSelectedNodes()[0].id;
                    }
                    client_list2_getdata("", isvirtualgroup, selectClientID);
                } else {
                    TopTrip("删除失败！", 2);
                }
                
            }
        })
    })
    function loadParentPage1() {
        if ($.cookie("mySelectNodeID") != "" && $.cookie("mySelectNodeID") != null) {//记录的上次点击的终端(组)
            $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());//, { cache: false })
        } else {
            $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());
            
        }
        client_main_loadright(0, clientid, dlevel, clientmark);
        //$("#client_main_left").load("client_main_left.html");
    }
</script>
<style>
    .zd_remote .editcon span.delete {
    display: inline-block;
    height: 18px;
    border: 1px solid #cbcbcb;
    border-radius: 3px;
    line-height: 18px;
}
    .zd_remote .editcon span.delete a {
    display: block;
    padding-right: 18.5px;
    padding-left: 18.5px;
    /*background: url(../images/icon_jia.png) no-repeat 8px center;*/
    /* color: #5ac0ee; */
    color: #0596f3;
    font-size: 12px;
}
</style>
<input type="hidden" id="client_list2_dlevel" name="client_list2_dlevel" runat="server" />
<input type="hidden" id="client_list2_groupid" name="client_list2_groupid" runat="server" />
<input type="hidden" id="client_list2_remark" name="client_list2_remark" runat="server" />
<input type="hidden" id="client_list2_pageMap" name="client_list2_pageMap" runat="server" />

<div class="zd_remote">
    <div class="sscon">
        <ul class="clearfix">
            <li class="ss_1">
                <input class="ss_t" type="text"　placeholder="终端名称、终端IP" id="client_list2_searchkey"></li>
            <li>
                <input class="ss_s" value="查询"  type="button" onclick="client_list2_search()"></li>
        </ul>
    </div>
    <table class="tab_zl_list" id="client_list2_tab" style="margin-top:20px;">
    </table>
    <div class="editcon">
        <span class="select">
            <input type="checkbox" id="client_list2_checkall">全选</span>
        <span class="add"><a href="javascript:void(0)" id="client_list2_quickadd">添加</a></span>
        <span class="delete"><a href="javascript:void(0)" id="client_list2_quickdelete">删除</a></span>
    </div>
</div>
