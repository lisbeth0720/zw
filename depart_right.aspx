<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="depart_right.aspx.cs" Inherits="HuiFeng.Web.company.depart.depart_right" %>

<script type="text/javascript">
    $(function () {
        if ($("#depart_right_type").val() == 1)
        {
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
                            html += ' <li><input name="dr_depart_check" id="a'+n+'" type="checkbox" value=' + item.departid + ' data-dlevel=' + item.dlevel + '><label for="a'+n+'"> ' + item.department + '</label></li>';
                        }
                    });
                    $("#dr_departlist").html(html);
                }
            }
        });
        if ($("#depart_right_hid_seldepart").val() != "") {
            var json = strToJson($("#depart_right_hid_seldepart").val());
            if ($("#depart_right_hid_seldepart").val().indexOf("*")>=0) {
                $("#allDepartCheck").prop("checked",true);
            }
            $.each(json.Table, function (idx, item) {
             
                $("input[name=dr_depart_check][value='" + item.departid + "']").prop('checked', 'checked');
            });
        }
        if ($("#userDepartID").val()!="") {//选中 用户自己所在部门。
            $("input[name=dr_depart_check][value='" + $("#userDepartID").val() + "']").prop('checked', 'checked');
        }
    })
    function SaveParentDepart() {
        var drseldepart = ",";
        $("input[name=dr_depart_check]:checked").each(function () {
            if ($(this).is(":checked")) {
                drseldepart = drseldepart+$(this).val() + ",";
            }
        });
        if ($("#allDepartCheck").is(":checked")) {
            drseldepart += "*,";//所有部门
        }
        if (drseldepart.indexOf(","+$("#userDepartID").val()+",") < 0) {//添加 用户自己所在部门。
            drseldepart = drseldepart + $("#userDepartID").val() + ",";
        }
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateAuth.ashx',
            async: false,
            dataType: 'text',
            data: {
                idtype: $("#right_main_idtype").val(),
                authid: $("#right_main_authid").val(),
                type: 4,
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
<input type="hidden" id="userDepartID" runat="server" />
<!--权限授权-->
<div class="limit_access">
    <div style="width:100%;overflow:hidden;border-bottom: 1px solid #e2e2e2;">
        <div class="tit" style="float:left;">部门列表</div>
        <div class="rightCheckBox" style="width:95px;line-height: 30px;">
                <span>
                    <input type="checkbox" id="allDepartCheck" value="*" name="allDepartCheck" />
                    <label for="allDepartCheck" style="font-size:14px">所有部门</label>

                </span>
        </div>
    </div>
      <ul class="limitlist clearfix" id="dr_departlist" style="height:500px;overflow-y:scroll">
      </ul>
    <div class="depart_m_btn">
     <span class="bgImage"></span>
    <input class="btn" value="确认" onclick="SaveParentDepart()" type="button">
    </div>
</div>

