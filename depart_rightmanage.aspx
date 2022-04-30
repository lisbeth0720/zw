<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="depart_rightmanage.aspx.cs" Inherits="Web.company.depart.depart_rightmanage" %>

<script type="text/javascript">
    $(function () {
        if ($("#depart_right_type").val() == 1) {
            $(".depart_m_btn").html("").hide();
        }
        //获取部门列表
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getMyDepartList.ashx',
            async: false,
            dataType: 'text',
            data: {
                keyword: ""
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);
                    var html = "";
                    var n = 0;
                    $.each(json.Table, function (idx, item) {
                        n++;
                        if (item.departid != $("#dp_add_hid_departid").val()) {
                            html += ' <li><input name="dr_depart_check" id="h'+n+'" type="checkbox" value=' + item.departid + ' data-dlevel=' + item.dlevel + '> <label for="h'+n+'">' + item.department + '</label></li>';
                        }
                    });
                    $("#dr_departlist").html(html);
                }
            }
        });
        if ($("#depart_right_hid_seldepart").val() != "") {
            var json = strToJson($("#depart_right_hid_seldepart").val());
            $.each(json.Table, function (idx, item) {
                //departid //item.Departid 
                $("input[name=dr_depart_check][value='" + item.departid + "']").attr('checked', 'checked');
            });
        }
    })
    function SaveParentDepart() {
        var drseldepart = "";
        $("input[name=dr_depart_check]:checked").each(function () {
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
                type: 7,
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

<input type="hidden" id="depart_right_type" value="0" runat="server" />
<input type="hidden" id="depart_right_hid_seldepart" runat="server" />
<!--权限授权-->
<div class="limit_access">
    <div class="tit">部门经理列表</div>
    <ul class="limitlist clearfix" id="dr_departlist" style="height:500px;overflow-y:scroll">
    </ul>
    <div class="depart_m_btn">
        <span class="bgImage"></span>
    <input class="btn" value="确认" title="确认" onclick="SaveParentDepart()" type="button">
</div>
</div>
