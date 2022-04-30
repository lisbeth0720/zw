<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frame_right.aspx.cs" Inherits="Web.company.depart.frame_right" %>

<script type="text/javascript">
    var pageSize = 40;
    $(function () {
       // var frame_right_selAll = new Mxjfn();
        //frame_right_selAll.selectAll("input[value='*']", "#fl_rightlist>li>input[name='frame_right_check']");

        GetCount();
        GetPageData(1);
        if ($("#frame_right_type").val() == 1) {
            $(".depart_m_btn").html("").hide();
        }
    })
    function GetCount() {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getframelist.ashx',
            async: false,
            dataType: 'text',
            data: {
                type: 0
            },
            success: function (data) {
                pageSize = data;//表中记录数。。
                //$("#pager").pagination({
                //    items: data,
                //    itemsOnPage: pageSize,
                //    cssStyle: 'light-theme'
                //});
            }
        });
    }
    function GetPageData(page) {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getframelist.ashx',
            async: false,
            dataType: 'text',
            data: {
                type: 1,
                indexpage: page,
                pagesize: pageSize
            },
            success: function (data) {
                if (data != -1) {
                    var json = strToJson(data);
                    ShowPageData(json);
                }
                else {
                    LoginTimeOut();
                }
            }
        });
    }
    function ShowPageData(json) {
        $("#fl_rightlist").empty();
        var n = 0;
        $.each(json.Table, function (idx, item) {
            n++;
            $("#fl_rightlist").append("<li><input id=\"c" + n + "\" checkAll='checkAll' type=\"checkbox\" name=\"frame_right_check\" value=\"" + item.framelayoutid + "\"><label for=\"c"+n+"\">" + item.framelayout + "</label></li>");
        })
        if ($("#frame_right_hid_seldep").val().indexOf("*")>=0) {//所有资源授权。。。直接全选页面的‘复选框’
            $("input[name=frame_right_check]").prop('checked', 'checked');
            
        }//else{
            var selectedValues = $("#frame_right_hid_seldep").val().split(",");
            for (var i = 0; i < selectedValues.length; i++) {
                if (selectedValues[i] != "") {
                    if (selectedValues[i].split("_")[0] != "p") {
                        $("input[name=frame_right_check]:checkbox[value='" + selectedValues[i] + "']").prop('checked', 'checked');
                    }
                    else {//p,,用户所在的部门 的资源授权。。。p_*  ,p_ ,,
                        $("input[name=frame_right_check][value='" + selectedValues[i].split("_")[1] + "']").prop('checked', 'checked');
                        $("input[name=frame_right_check][value='" + selectedValues[i].split("_")[1] + "']").parent().append("<span style='color:#f00;'>(*)<span>");
                    }
                }
            }
       // }
    }
    function SaveColumnRight() {
        var drseldepart = "";
        var querystring = "";
        $("ul input[name=frame_right_check]:checked").each(function () {
            drseldepart = drseldepart + $(this).val() + ",";
        });
        if ($("#a_all").is(":checked")) {
            drseldepart += "*,";//所有布局
        }
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateAuth.ashx',
            async: false,
            dataType: 'text',
            data: {
                idtype: $("#right_main_idtype").val(),
                authid: $("#right_main_authid").val(),
                type: 3,
                sellist: drseldepart
            },
            success: function (data) {
                if (data >= 0) {
                    TopTrip("更新成功", 1);
                }
                else {
                    TopTrip("系统错误，请联系管理员", 3);
                }
            }
        });

    }
    function selectAllFrameFun() {
        if ($("#selectAllFrame").is(":checked")) {

            $("#fl_rightlist").find("input[checkAll=checkAll]").prop("checked", "checked");
        } else {
            $("#fl_rightlist").find("input[checkAll=checkAll]").prop("checked", false);
        }
    }
</script>
<!--权限授权-->
<input type="hidden" id="frame_right_type" value="0" runat="server" />
<input type="hidden" id="frame_right_hid_seldep" runat="server" />
<div class="limit_access">
    <div class="tit">
        <div class="leftCheckBox">
            <input type="checkbox" id="selectAllFrame" value="*" name="allFrame" onclick="selectAllFrameFun()">
            <label for="selectAllFrame">全选/全不选</label>
        </div>
        <div class="rightCheckBox">
            <span>
                <input type="checkbox" id="a_all" value="*" name="frame_right_check" />
                <label for="a_all">所有布局</label>
            </span>
        </div>
    </div>
    <ul class="limitlist clearfix" id="fl_rightlist">
    </ul>
    <div id="pager"></div>
    <div class="depart_m_btn"  title="确认">
        <span class="bgImage"></span>
        <input class="btn" value="确认" title="确认" onclick="SaveColumnRight()" type="button">
    </div>
</div>
