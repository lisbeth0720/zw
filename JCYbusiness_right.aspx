<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JCYbusiness_right.aspx.cs" Inherits="Web.company.depart.JCYbusiness_right" %>


<script type="text/javascript">
    $(function () {
        if ($("#sys_right_type").val() == 1) {
            $(".depart_m_btn").html("").hide();
        }
        //获取部门列表
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getSys_rightList.ashx',
            async: false,
            dataType: 'text',
            data: {
                action: "getBusiness"
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);
                    var html = "";
                    var n = 0;
                    //debugger;
                    $.each(json.Table, function (idx, item) {
                        n++;
                        if (item.rightid!="") {//只显示业务授权
                            html += "<li><input checkAll='checkAllBox' type=\"checkbox\" id=\"a" + n + "\" name=\"sys_right_check\" data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\"><label for=\"a" + n + "\">" + item.rightname + "</label></li>";
                        }
                        
                    });
                    $("#dr_departlist").html(html);

                }
            }
        });
        if ($("#sys_right_hid_sel").val() != "") {
            
            var selectedValues = $("#sys_right_hid_sel").val().split(",");
            for (var i = 0; i < selectedValues.length; i++) {
                if (selectedValues[i] != "") {
                    if (selectedValues[i].split("_")[0] != "p") {//用户的权限。
                        $("input[name=sys_right_check][value='" + selectedValues[i] + "']").attr('checked', 'checked');
                    }
                    else {//p,,用户所在的部门 的权限。。。p_*  ,p_ ,,
                        //debugger;//[value=*] ,,[value='*']
                        $("input[name=sys_right_check][value='" + selectedValues[i].split("_")[1] + "']").attr('checked', 'checked');
                        $("input[name=sys_right_check][value='" + selectedValues[i].split("_")[1] + "']").parent().append("<span style='color:#f00;'>(*)<span>");
                    }
                }
            }
        }
    })
    function SaveParentDepart() {
        var drseldepart = "";
        $("input[name=sys_right_check]:checked").each(function () {
            if ($(this).is(":checked")) {
                drseldepart = drseldepart + $(this).val() + ",";
            }
        });
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateAuth.ashx',
            async: false,
            dataType: 'text',
            data: {
                idtype: $("#right_main_idtype").val(),
                authid: $("#right_main_authid").val(),
                type: 8,
                sellist: drseldepart
            },
            success: function (data) {
                if (data < 0) {
                    $(this).attr("checked", !$(this).attr("checked"));
                }
                else {
                    TopTrip("更新成功", 1);
                }
            }
        });
    }
</script>

<input type="hidden" id="sys_right_type" value="0" runat="server" />
<input type="hidden" id="sys_right_hid_sel" runat="server" />
<!--权限授权-->
<div class="limit_access">
    <div class="tit">业务授权列表</div>
    <ul class="limitlist clearfix" id="dr_departlist">
    </ul>
    <div class="depart_m_btn">
        <span class="bgImage"></span>
    <input class="btn" value="确认" title="确认" onclick="SaveParentDepart()" type="button">
</div>
</div>

