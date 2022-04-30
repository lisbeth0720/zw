<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_right.aspx.cs" Inherits="Web.company.depart.column_right" %>

<script type="text/javascript">
    var pageSize = 40;
    $(function () {
        //var column_right_selAll = new Mxjfn();
        //column_right_selAll.selectAll("input[value='*']", "#cl_rightlist>li>input[name='column_right_check']");


        if ($("#column_right_type").val() == 1) {
            $(".depart_m_btn").html("").hide();
        }
        GetCount();
        GetPageData(1);
    })
    function GetCount() {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getcolumnlist.ashx',
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
            url: '/company/depart/ajax/getcolumnlist.ashx',
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
            $("#cl_rightlist").append("<li><input id=\"d" + n + "\" checkAll='checkAll' type=\"checkbox\" name=\"column_right_check\" value=\"" + item.itemid + "\"><label for=\"d"+n+"\">" + item.itemname + "</label></li>");
        })
        if ($("#column_right_hid_seldep").val().indexOf("*") >= 0) {
            $("input[name=column_right_check]").prop('checked', 'checked');
        }//else {
            var selectedValues = $("#column_right_hid_seldep").val().split(",");
            for (var i = 0; i < selectedValues.length; i++) {
                if (selectedValues[i] != "") {
                    if (selectedValues[i].split("_")[0] != "p") {
                        $("input[name=column_right_check]:checkbox[value='" + selectedValues[i] + "']").prop('checked', 'checked');
                    }
                    else {//p,,用户所在的部门 的资源授权。。。p_*  ,p_ ,,
                        $("input[name=column_right_check][value='" + selectedValues[i].split("_")[1] + "']").prop('checked', 'checked');
                        $("input[name=column_right_check][value='" + selectedValues[i].split("_")[1] + "']").parent().append("<span style='color:#f00;'>(*)<span>");
                    }
                }
            }
        //}
    }
    function SaveColumnRight() {
        var drseldepart = "";
        var querystring = "";
        $("ul input[name=column_right_check]:checked").each(function () {
            drseldepart = drseldepart + $(this).val() + ",";
        });
        if ($("#d_all").is(":checked")) {
            drseldepart += "*,";//所有栏目
        }
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateAuth.ashx',
            async: false,
            dataType: 'text',
            data: {
                idtype: $("#right_main_idtype").val(),
                authid: $("#right_main_authid").val(),
                type: 1,
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
    function slectAllColumn() {
        if ($("#Checkbox2").is(":checked")) {

            $("#cl_rightlist").find("input[checkAll=checkAll]").prop("checked", "checked");
        } else {
            $("#cl_rightlist").find("input[checkAll=checkAll]").prop("checked", false);
        }
    }
</script>
<!--权限授权-->
<input type="hidden" id="column_right_type" value="0" runat="server" />
<input type="hidden" id="column_right_hid_seldep" runat="server" />
<div class="limit_access">
    <div class="tit">
        <div class="leftCheckBox">
           <input id="Checkbox2" type="checkbox" value="*" name="columnRightCheck" onclick="slectAllColumn()"/>
            <label for="Checkbox2">全选/全不选</label>
        </div>
        <div class="rightCheckBox">
            <span>
                <input id="d_all" type="checkbox" value="*" name="column_right_check" />
                <label for="d_all">所有栏目</label>
            </span>
        </div>
    </div>
    <ul class="limitlist clearfix" id="cl_rightlist" runat="server">
    </ul>
    <div id="pager"></div>
    <div class="depart_m_btn"  title="确认">
        <span class="bgImage"></span>
        <input class="btn" value="确认" title="确认" onclick="SaveColumnRight()" type="button">
        
    </div>
</div>
