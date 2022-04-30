<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Sys_right.aspx.cs" Inherits="Web.company.depart.Sys_right" %>

<script type="text/javascript">
    var str1 = '';
    var str2 = '';
    $(function () {
        //var sys_right_selAll = new Mxjfn();
        //sys_right_selAll.selectAll("input[value='*']", "#sr_rightlist>li>input[name='sys_right_check']");

        if ($("#sys_right_type").val() == 1) {
            $(".depart_m_btn").html("").hide();
        }
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getSys_rightList.ashx',
            async: false,
            dataType: 'text',
            success: function (data) {
                var json = strToJson(data);
                var isShowSuperTitle = true;
                var n = 0;
                //$.each(json.Table, function (idx, item) {
                //    n++;
                //    if (item.rightid < 65535) {
                //        if (n == 36 || n == 37 || n == 38 || n == 39 || n == 40 || n == 341 || n == 42 || n == 48 || n == 49) {
                //            str2 += "<li style='color:#5ac0ee;'><input checkAll='checkAllBox' type=\"checkbox\" id=\"a" + n + "\" name=\"sys_right_check\" data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\"><label for=\"a" + n + "\">" + item.rightname + "</label></li>";
                          
                //        } else {
                //            str1+="<li><input checkAll='checkAllBox' type=\"checkbox\" id=\"a" + n + "\" name=\"sys_right_check\" data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\"><label for=\"a"+n+"\">" + item.rightname + "</label></li>"
                //        }
                //         if (n == 36 || n == 37 || n == 38 || n == 39 || n == 40 || n == 341 || n == 42 || n == 48 || n == 49) {
                //           $("#a" + n).parent().css("color", "#5ac0ee");
                //         }   
                //    }
                //    else {
                //        if (isShowSuperTitle)
                //        {
                //            $("#sr_rightlist").append("<li class=\"zuqx\"><span class=\"tit\">组权限</span></li>");
                //            isShowSuperTitle=false;
                //        }
                //        $("#sr_rightlist").append("<li><span class=\"con\"><input type=\"checkbox\" id=\"b" + n + "\" name=\"sys_right_check\"  data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\"><label for=\"b" + n + "\">" + item.rightname + "</label></span></li>");
                //    }
                //});
                $.each(json.Table, function (idx, item) {
                    n++;
                    if (item.rightid < 65535) {//  || n == 40    ////制作审核//全部素材/栏目/节目单审核 //---不是编排的节目项-- 
                        if (n == 36 || n == 37 || n == 38 || n == 39 || n == 41 || n == 42 || n == 48 || n == 49) {
                            str2 += "<li style='color:#5ac0ee;'><input checkAll='checkAllBox' type=\"checkbox\" id=\"a" + n + "\" name=\"sys_right_check\" data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\"><label for=\"a" + n + "\">" + item.rightname + "</label></li>";

                        } else {
                            str1 += "<li><input checkAll='checkAllBox' type=\"checkbox\" id=\"a" + n + "\" name=\"sys_right_check\" data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\"><label for=\"a" + n + "\">" + item.rightname + "</label></li>"
                        }     
                    }
                });
                $("#sr_rightlist").append(str1 + str2);
                $.each(json.Table, function (idx, item) {
                    if (item.rightid >= 65535) {
                        if (isShowSuperTitle) {
                            $("#sr_rightlist").append("<li class=\"zuqx\"><span class=\"tit\">组权限</span></li>");
                            isShowSuperTitle = false;
                        }
                        $("#sr_rightlist").append("<li><span class=\"con\"><label><input type=\"checkbox\" id=\"b" + n + "\" name=\"sys_right_check\"  data-rightstring=\"" + item.rightstring + "\" value=\"" + item.rightid + "\">" + item.rightname + "</label></span></li>");
                    }
                })
                var selectedValues = $("#sys_right_hid_sel").val().split(",");
                for (var i = 0; i < selectedValues.length; i++) {
                    if (selectedValues[i] != "") {
                        if (selectedValues[i].split("_")[0] != "p") {//用户的权限。
                            $("input[name=sys_right_check][value='" + selectedValues[i] + "']").prop('checked', 'checked');
                        }
                        else {//p,,用户所在的部门 的权限。。。p_*  ,p_ ,,
                            //debugger;//[value=*] ,,[value='*']
                            $("input[name=sys_right_check][value='" + selectedValues[i].split("_")[1] + "']").prop('checked', 'checked');
                            $("input[name=sys_right_check][value='" + selectedValues[i].split("_")[1] + "']").parent().append("<span style='color:#f00;'>(*)<span>");
                        }
                    }
                } 
                
            }
        });

    })
    function SaveSysRight() {
        var drseldepart = "";
        var querystring = "";

        $("ul input[name=sys_right_check]:checked").each(function () {
            drseldepart = drseldepart + $(this).val() + ",";
            querystring = querystring + $(this).attr("data-rightstring") + ",";
        });
        if ($("#c_all").is(":checked")) {//|| $("#Checkbox2").attr("checked") == "checked"
            drseldepart += "*,";//所有权限(*)
        }
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateAuth.ashx',
            async: false,
            dataType: 'text',
            data: {
                idtype: $("#right_main_idtype").val(),
                authid: $("#right_main_authid").val(),
                type: 0,
                sellist: drseldepart,
                querystring: querystring
            },
            success: function (data) {
                if (data >= 0) {
                    //if ($("#b53").attr("checked") != "checked") {//超级管理员组 ,没有选中。。
                    //    $("#c_all").attr("checked", false);//所有权限(*)   不勾选。。
                    //}
                    TopTrip("更新成功", 1);
                }
                else {
                    TopTrip("系统错误，请联系管理员！", 3);
                }
            }
        });

    }
    function checkedAll() {
       // debugger;
        if ($("#Checkbox2").is(":checked")) {
           
            $("#sr_rightlist").find("input[checkAll=checkAllBox]").not("input[id='a36'],input[id='a37'],input[id='a38'],input[id='a39'],input[id='a40'],input[id='a41'],input[id='a42'],input[id='a48'],input[id='a49']").prop("checked", "checked");
        } else {
            $("#sr_rightlist").find("input[checkAll=checkAllBox]").not("input[id='a36'],input[id='a37'],input[id='a38'],input[id='a39'],input[id='a40'],input[id='a41'],input[id='a42'],input[id='a48'],input[id='a49']").prop("checked", false);
        }
    }
</script>
<style>
   
</style>
<!--权限授权-->
<input type="hidden" id="sys_right_type" value="0" runat="server" />
<input type="hidden" id="sys_right_hid_sel" runat="server" />
<div class="limit_access">

    <div class="tit">
        <div class="leftCheckBox">
            <input type="checkbox" id="Checkbox2" value="*" name="sysAllCheck" data-rightsring="" title="全选" onclick="checkedAll();" />
            <label for="Checkbox2">全选/全不选</label>
        </div>
        <div class="rightCheckBox">
            <span>
                <input type="checkbox" id="c_all" value="*" name="sys_right_check" data-rightsring="" />
                <label for="c_all">所有权限</label>
            </span>
        </div>
        <!-- <span>
            <input type="checkbox" id="Checkbox2" value="*" name="sysAllCheck" data-rightsring="" />
            <label for="cAllCheck">全选</label>
        </span> -->
     </div>
    <ul class="limitlist clearfix" id="sr_rightlist" runat="server" >
    </ul>
    
    <div class="depart_m_btn">
        <span class="bgImage"></span>
        <input class="btn" title="确 认" value="确 认" onclick="SaveSysRight()" type="button">
    </div>
</div>
