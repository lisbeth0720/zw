<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_menu_add.aspx.cs" Inherits="Web.company.client.client_menu_add" %>

<style>
    .sync {
        display: inline-block;
        margin: -2px 0 0 20px;
        /* padding-left: 10px; */
        width: 100px;
        height: 20px;
        border: 1px solid #c1c1c1;
        border-radius: 3px;
        /* background: url(/images/icon_ex.png) no-repeat right; */
        color: #a8a8a8;
        line-height: 20px;
        cursor: pointer;
        text-align: center;
    }

        .sync:hover {
            background: #1ca8dd;
            color: #fff;
        }
</style>
<script type="text/javascript">
    var dlevel, clientid, clientmark;
    $(function () {
        getJsonValue();
        dlevel = $("#client_menu_dlevel").val();
        clientid = $("#client_menu_clientid").val();
        clientmark = $("#client_menu_mark").val();
        switchLanguage(".clientmenu_addbox", 1, "client_menu_add.aspx");
        //dlevel = $("#client_view_dlevel").val();
        //clientid = $("#client_view_groupid").val();
        //clientmark = $("#client_view_mark").val();
        if ($("#menuData").val() != "") {
            $("#addButton").val(getLanguageMsg("修改", $.cookie("yuyan")));
            $("#showStatus").css("display", "block");
            var datas = strToJson($("#menuData").val());//将已有节目单设置 ，显示在页面。
            datas = datas.Table[0];
            $("#clientmenu_add_menuid").val(datas.menuid);
            $("#clientmenu_add_name").val(datas.itemname);
            $("input[name=clientmenu_add_tempflag][value=" + datas.tempflag + "]").attr("checked", "checked");
            $("input[name=clientmenu_add_ctrlflag]").each(function () {
                if (datas.ctrlflag.indexOf(this.value) >= 0) {
                    $(this).attr("checked", "checked");
                }
            });
            debugger;
            $("input[name=clientmenu_add_flag][value=" + datas.flag + "]").attr("checked", "checked");
            if(datas.startdate.length==6&&datas.enddate.length==6){
                 $("#clientmenu_add_startdate").val("");
                 $("#clientmenu_add_enddate").val("");

                 $("#zyy_start_week").val(datas.startdate);
                 $("#zyy_end_week").val(datas.enddate);
                 var stattIndexZyy=parseInt(datas.startdate);
                 var endIndexZyy=parseInt(datas.enddate);
                $("#zyyStartWeek label").find("input[type='checkbox']").prop("checked",false);
                $("#zyyEndWeek label").find("input[type='checkbox']").prop("checked",false);
                $("#zyyStartWeek label").find("input[type='checkbox']").eq(stattIndexZyy).prop("checked",true);
                $("#zyyEndWeek label").find("input[type='checkbox']").eq(endIndexZyy).prop("checked",true);
            }else{
                  $("#clientmenu_add_startdate").val(datas.startdate);
                  $("#clientmenu_add_enddate").val(datas.enddate);
                  $("#zyy_start_week").val("");
                  $("#zyy_end_week").val("");
            }
          
            $("#clientmenu_add_sendtime").val(datas.sendtime);
            if (datas.sendingprocess == "0") {//分发状态//finishedtime
                $("#sendstatus").html(getLanguageMsg('未分发，自动检测分发过程会对其进行分发', $.cookie("yuyan")));
            } else {
                $("#sendstatus").html(getLanguageMsg('已分发  ', $.cookie("yuyan")) + datas.finishedtime);
                //+ '<br /><font color="red">(提示：在节目单变动或者终端组变动完毕后，重置该状态才能参与自动分发)</font>'
            }
        } else {
            $("#addButton").val(getLanguageMsg("添加", $.cookie("yuyan")));
            $("#showStatus").css("display", "none");
            $("input[name=clientmenu_add_ctrlflag][value=1]").attr("checked", true);//分发前停止节目播放
            $("input[name=clientmenu_add_ctrlflag][value=2]").attr("checked", true);//分发后重启节目播放
        }
        //$("#client_menu_clientmenuid").val("11");
        $("#client_menu_add").Validform({
            tiptype: function (msg, o, cssctl) {
                if (!o.obj.is("form")) {//验证表单元素时o.obj为该表单元素，全部验证通过提交表单时o.obj为该表单对象;
                    var objtip = o.obj.siblings(".Validform_checktip");
                    cssctl(objtip, o.type);
                    objtip.text(msg);
                } else {
                    var objtip = o.obj.find("#msgdemo");
                    cssctl(objtip, o.type);
                    objtip.text(msg);
                }
            },
            beforeSubmit: function (curform) {
                //记录 点击了哪一个终端。。
                $.cookie("mySelectNodeID", $(".curSelectedNode").attr("id"), { path: '/company/' });
                $.cookie("mySelectNodeName", $(".curSelectedNode").attr("title"), { path: '/company/' });
                if ($("#clientmenu_add_menuid").val() == "") {
                    TopTrip(getLanguageMsg("您还未选择节目单！", $.cookie("yuyan")), 2);
                    return false;
                }
            },
            ajaxPost: true,
            postonce: true,
            callback: function (d) {
                if (d.status == "y") {
                    TopTrip($("#addButton").val() + getLanguageMsg("成功", $.cookie("yuyan")), 1);
                    loadParentPage();
                }
                else {
                    LoginTimeOut();
                }
            }
        });
        
        var a = getLanguageMsg("刷新", $.cookie("yuyan"));
        var b = getLanguageMsg("关闭", $.cookie("yuyan"));
        var c = getLanguageMsg("选择节目单", $.cookie("yuyan"));
        $("#content_dialog").dialog({
            autoOpen: false,
            close: function () {
                $("#content_dialog").html("");
            },
            buttons: {
                a: function () {
                    $("#content_dialog").load("/common/programlist.aspx", { "t": 4 });
                },
                b: function () {
                    $("#content_dialog").html("");
                    $("#content_dialog").dialog("close");
                    $("#program_arrange_h_columnlist").fadeOut();
                    //program_arrange_load_h_sourcelist();
                }
            },
            open: function () {
                var butto = $(this).next();
                butto.find("button:eq(0) span").html(a);
                butto.find("button:eq(1) span").html(b);
            },
            width: 770,
            height: 600,
            resizable: true,
            title: c,
            stack: true,
            appendTo: "body"
        });
    })
    $("#zyyStartWeek label").click(function () {
       
       
        if ($(this).find("input[type='checkbox']").prop("checked") == true) {
            $(this).find("input[type='checkbox']").prop("checked", false);
        } else {
            $("#zyyStartWeek label input[type='checkbox']").not($(this).find("input[type='checkbox']")).prop("checked", false);
            $(this).find("input[type='checkbox']").prop("checked", true);
            $("#clientmenu_add_startdate").val("");
        }
        
    })
    $("#zyyEndWeek label").click(function () {
       

        if ($(this).find("input[type='checkbox']").prop("checked") == true) {
            $(this).find("input[type='checkbox']").prop("checked", false);
        } else {
            $("#zyyEndWeek label input[type='checkbox']").not($(this).find("input[type='checkbox']")).prop("checked", false);
            $(this).find("input[type='checkbox']").prop("checked", true);
            $("#clientmenu_add_enddate").val("");
           // $("#zyy_end_week").val()
        }
        
    })
     $("#zyyStartWeek label input[type='checkbox']").click(function () {
       
       
        if ($(this).prop("checked") == true) {
            $(this).prop("checked", false);
        } else {
            $("#zyyStartWeek label input[type='checkbox']").not($(this)).prop("checked", false);
            $(this).prop("checked", true);
            $("#clientmenu_add_startdate").val("");
        }
        
    })
    $("#zyyEndWeek label input[type='checkbox']").click(function () {
       

        if ($(this).prop("checked") == true) {
            $(this).prop("checked", false);
        } else {
            $("#zyyEndWeek label input[type='checkbox']").not($(this)).prop("checked", false);
            $(this).prop("checked", true);
            $("#clientmenu_add_enddate").val("");
           // $("#zyy_end_week").val()
        }
        
    })
    $("#addButton").click(function () {
        var startFlag = 0;
        var startIndex = -1;
        var endIndex = -1;
        debugger;
        for (var i = 0; i < $("#zyyStartWeek label").find("input[type='checkbox']").length; i++) {
            if( $("#zyyStartWeek label").find("input[type='checkbox']").eq(i).prop("checked")==true){
                startIndex = i;
                break;
            }
        }
        for (var j = 0; j < $("#zyyEndWeek label").find("input[type='checkbox']").length; j++) {
            if ($("#zyyEndWeek label").find("input[type='checkbox']").eq(j).prop("checked") == true) {
                endIndex = j;
                break;
            }
        }

        if (startIndex ==-1) {
            startIndex = endIndex;
        }
        if (endIndex == -1) {
            endIndex = startIndex;
        }
        if (startIndex == -1 && endIndex == -1) {
            $("#zyy_start_week").val("");
            $("#zyy_end_week").val("");
        } else {
            $("#zyy_start_week").val("00000" + startIndex);
            $("#zyy_end_week").val("00000" + endIndex);
        }

       
    })
    function cancelAdd() {//取消 按钮
        client_main_loadright(0, clientid, dlevel, clientmark);
    }
    function clientmenu_add_selpro() {
        $("#content_dialog").load("/common/programlist.aspx", { "t": 4 });
        $("#content_dialog").dialog("open");
        //$("#overlay").fadeIn(function () {
        //    $("#clientmenu_add_menu_list").load("/company/program/program_list.aspx", { "t": 4 }, function () {
        //        $("#clientmenu_add_menu_list").fadeIn();
        //    });
        //});
    }
    function loadParentPage() {
        debugger;
        client_main_loadright(0, clientid, dlevel, clientmark);
       // $("#client_main_left").load("client_main_left.html?rn=" + Math.random());
        //$("#treeDemo_12_a").addClass("curSelectedNode")
    }
    //将节目单添加到 终端
    function clientmenu_add(menuid, menuname) {//只能添加一个节目单
        //var selval = $("#clientmenu_add_menuid").val();
        //if (selval.indexOf(menuid + ",") < 0) {
        //    $("#clientmenu_add_name").val($("#clientmenu_add_name").val() + menuname + ",");
        //    $("#clientmenu_add_menuid").val($("#clientmenu_add_menuid").val() + menuid + ",");
        //}
        $("#clientmenu_add_name").val(menuname);
        $("#clientmenu_add_menuid").val(menuid);
        $("#content_dialog").dialog("close");
        TopTrip(getLanguageMsg("节目添加成功", $.cookie("yuyan")), 1);
    }
    function IsNumric(num) {
        var flag;
        flag = true;
        if (num.length == 0) return false;
        cmp = "0123456789";
        for (var i = 0; i < num.length; i++) {
            tst = num.substring(i, i + 1);
            if (cmp.indexOf(tst) < 0) {
                flag = false;
                return false;
            }
        }
        return flag;
    }
    //绝对时间上增加时间函数
    //obj=时间输入框id ，type=1
    function add_min(obj, type, value) {
        if (!IsNumric(value) || obj == "" || !IsNumric(type)) { return false; }
        var newtimestr = "";
        var objtime = $("#" + obj).val();
        debugger;
        if (objtime.indexOf("-") == -1) { //判断如果不带长日期自动添加日期
            var tempdate = new Date();
            objtime = tempdate.getFullYear() + "-" + (tempdate.getMonth() + 1) + "-" + tempdate.getDate() + " " + objtime;
        }

        if (!(isNaN(objtime) && !isNaN(Date.parse(objtime)))) { return false; }//判断最终格式是否日期格式
        objtime = new Date(objtime.replace(/-/g, '/'));
        if (type == 1) {//在当前输入框中时间的基础上增加时间       
            objtime = new Date(objtime.getTime() + value * 1000);
        } else if (type == 2) {//在当前时间基础上增加时间
            objtime = new Date(new Date().getTime() + value * 1000);
        }
        //if ($("#" + obj).val().indexOf("-") > 0) {
            newtimestr = objtime.getFullYear() + "-" + (objtime.getMonth() + 1) + "-" + objtime.getDate() + " " + objtime.getHours() + ":" + objtime.getMinutes() + ":" + objtime.getSeconds();
        //} else {
        //    newtimestr = objtime.getHours() + ":" + objtime.getMinutes() + ":" + objtime.getSeconds();
        //}
        $("#" + obj).val(newtimestr);
    }
</script>
<style>
.zyyCommonWeek {
    height: 28px;
    display: block;
    line-height: 28px;
}
.zyyCommonWeek label{
    width: 54px;
    display: block;
    float: left;
    margin-left: 5px;
}
#zyyStartWeek label input[type="checkbox"] {
    margin-top:0px;
}
#zyyEndWeek label input[type="checkbox"] {
    margin-top:0px;
}
.clientmenu_addbox {
    left:33%;
}
.clientmenu_addbox ul li {
    width:970px;
}
.clientmenu_addbox ul li span.label {
    width:180px;
}
.zyyCommonWeek label {
    width:73px;
}
</style>
<form id="client_menu_add" action="ajax/saveclientmenu.ashx" method="post">
    <input type="hidden" id="client_menu_pageMap" runat="server" />
    <input type="hidden" id="client_menu_dlevel" name="client_menu_dlevel" runat="server" />
    <input type="hidden" id="client_menu_clientid" name="client_menu_clientid" runat="server" />
    <input type="hidden" id="client_menu_mark" name="client_menu_mark" runat="server" />
    <input type="hidden" id="client_menu_clientmenuid" name="client_menu_clientmenuid" runat="server" value="0" />
    <input type="hidden" id="zyy_start_week" name="zyy_start_week" runat="server" value="" />
    <input type="hidden" id="zyy_end_week" name="zyy_end_week" runat="server" value="" />
    <input type="hidden" id="menuData" name="menuData" runat="server" value="" />
    <div id="content_dialog" style="padding: 0;">
    </div>
    <div class="clientmenu_addbox">
        <ul class="clearfix">
            <li><span class="label language">节目单：</span>
                <input class="inp_t" id="clientmenu_add_name" datatype="*" errormsg="选择节目单" name="clientmenu_add_name" value="" readonly="readonly" type="text">
                <div class="showallbtn">
                    <a href="javascript:void(0)" onclick="clientmenu_add_selpro()" class="language">选择节目单</a>
                    <input type="hidden" name="clientmenu_add_menuid" id="clientmenu_add_menuid" value="" />
                </div>
            </li>
            <li><span class="label language">任务类型：</span>
                <span class="label" style="text-align: left; width: 500px;">
                    <input type="radio" name="clientmenu_add_tempflag" value="0" checked="checked" /><span class="language">正常任务---日常正常播放</span>
                <input type="radio" name="clientmenu_add_tempflag" value="1" /><span class="language">临时插播</span>
                <input type="radio" name="clientmenu_add_tempflag" value="3" /><span class="language">紧急插播</span></span>
            </li>
            <li><span class="label language">控制字段：</span>
                <p style="width: 460px; padding: 10px; border: 1px solid #cdcdcd; border-radius: 3px; float: left;">
                    <span class="label" style="width: 140px; text-align: left">
                        <input name="clientmenu_add_ctrlflag" type="checkbox"  value="1"><span class="language">分发前停止节目播放</span></span>
                    <span class="label" style="width: 140px; text-align: left">
                        <input name="clientmenu_add_ctrlflag" type="checkbox"  value="2"><span class="language">分发后重启节目播放</span></span>
                    <span class="label" style="width: 140px; text-align: left">
                        <input name="clientmenu_add_ctrlflag" type="checkbox" value="3"><span class="language">分发后重启计算机</span></span>
                    <span class="label" style="width: 140px; text-align: left">
                        <input name="clientmenu_add_ctrlflag" type="checkbox" value="4"><span class="language">分发后关闭计算机</span></span>
                    <span class="label" style="width: 140px; text-align: left">
                        <input name="clientmenu_add_ctrlflag" type="checkbox" value="5"><span class="language">删除以前分发的节目单</span></span>
                </p>
            </li>
            <li id="showStatus"><span class="label language">分发状态：</span><span class="label" id="sendstatus" style="width:255px"></span>
            </li>
            <li><span class="label language">启用控制：</span>
                <span class="label" style="text-align: left; width: 500px;">
                    <input type="radio" name="clientmenu_add_flag" value="0" checked="checked" /><span class="language">启用该节目单设置&nbsp;&nbsp;&nbsp;&nbsp;</span>
                <input type="radio" name="clientmenu_add_flag" value="1" /><span class="language">暂不启用该节目单设置</span></span>
            </li>
            <%--<li><span class="label">节目单类型：</span>
                <span class="label" style="width: 140px; text-align: left">
                    <input name="clientmenu_add_menutype" type="checkbox" value="5">临时节目单</span>
            </li>--%><%--表中没有对应字段--%>
            <li><span class="label language">节目单生效日期：</span><input class="inp_t" autocomplete="off" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH' })" id="clientmenu_add_startdate" name="clientmenu_add_startdate" type="text"><span id="zyyStartWeek" class="zyyCommonWeek"><label for="szyy0"><input type="checkbox" value="000000" id="szyy0"/><span class="language">星期日</span></label><label for="szyy1"><input type="checkbox" value="000001" id="szyy1" /><span class="language">星期一</span></label><label for="szyy2"><input type="checkbox" value="000002" id="szyy2"/><span class="language">星期二</span></label><label for="szyy3"><input type="checkbox" value="000003" id="szyy3" /><span class="language">星期三</span></label><label for="szyy4"><input type="checkbox" value="000004" id="szyy4" /><span class="language">星期四</span></label><label for="szyy5"><input type="checkbox" value="000005" id="szyy5"/><span class="language">星期五</span></label><label for="szyy6"><input type="checkbox" value="000006" id="szyy6" /><span class="language">星期六</span></label></span></li>
            <li><span class="label language">节目单失效日期：</span><input class="inp_t" autocomplete="off" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH' })" id="clientmenu_add_enddate" name="clientmenu_add_enddate" type="text"><span id="zyyEndWeek" class="zyyCommonWeek"><label for="ezyy0"><input type="checkbox" value="000000" id="ezyy0" /><span class="language">星期日</span></label><label for="ezyy1"><input type="checkbox" value="000001"id="ezyy1" /><span class="language">星期一</span></label><label for="ezyy2"><input type="checkbox" value="000002" id="ezyy2"/><span class="language">星期二</span></label><label for="ezyy3"><input type="checkbox" value="000003" id="ezyy3"/><span class="language">星期三</span></label><label for="ezyy4"><input type="checkbox" value="000004" id="ezyy4" /><span class="language">星期四</span></label><label for="ezyy5"><input type="checkbox" value="000005" id="ezyy5"/><span class="language">星期五</span></label><label for="ezyy6"><input type="checkbox" value="000006" id="ezyy6" /><span class="language">星期六</span></label></span></li>
            <li><span class="label language">预约分发时间：</span><input class="inp_t" autocomplete="off" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" id="clientmenu_add_sendtime" name="clientmenu_add_sendtime" type="text"><span  class="sync" onclick="add_min('clientmenu_add_sendtime',2,30);">+30sec</span><span  class="sync" onclick="add_min('clientmenu_add_sendtime',2,60);">Now+1min</span><span  class="sync" onclick="add_min('clientmenu_add_sendtime',2,120);">Now+2min</span><span  class="sync" onclick="add_min('clientmenu_add_sendtime',2,300);">Now+5min</span></li>
        </ul>
        <div class="sc_add_btn clearfix" style="margin-left: 190px;">
            <span class="inp_btn">
                <input class="btn language" id="addButton" value="添加" type="submit"></span><span class="inp_btn"><input onclick="cancelAdd()" class="btn language" value="取消" type="button"></span>
        </div>
    </div>

</form>
