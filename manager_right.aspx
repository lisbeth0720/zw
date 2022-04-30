<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manager_right.aspx.cs" Inherits="Web.company.depart.manager_right" %>

<script type="text/javascript">
    var pageSize = 40;
    $(function () {
         GetCount();//去掉分页？？
        GetPageData();

    })
    function GetCount() {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/GetManagerList.ashx',
            async: false,
            dataType: 'text',
            data: {
                type: 0,
                keyword: "",
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    pageSize = data;//表中记录数。。
                    //var searchName = $("#txt_key").val();
                    //$("#pager").pagination({
                    //    items: data,
                    //    itemsOnPage: pageSize,
                    //    cssStyle: 'compact-theme'
                    //});
                }
            }
        });
    }
    function GetPageData(indexpage) {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/GetManagerList.ashx',
            async: false,
            dataType: 'text',
            data: {
                keyword: "",
                pagesize: pageSize,//不分页显示。。
                page: indexpage,
                type: 1,
                deptid:"<%=deptID%>"
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    //loadDepartContent(3);  //
                    var json = strToJson(data);
                    if (json.Table.length==0) {//点击的 部门 下没有操作员，--- 并且 没有所属部门的操作员为空
                        loadDepartContent(3);//直接 跳转到  ‘添加操作员’ 页面
                    }

                    var html = "";
                    $.each(json.Table, function (idx, item) {
                        html += ' <li><label><input name="mr_manager_check" type="checkbox" value=' + item.userid + ' data-dlevel=' + item.merit + '> ' + item.fullname + '</label></li>';

                    });
                    $("#mr_managerlist").html(html);
                }
            }
        });
        if ($("#manager_right_hid_seldep").val() != "") {
            var selvalues = $("#manager_right_hid_seldep").val().split(",");
            for (var i = 0; i < selvalues.length; i++) {
                $("input[name=mr_manager_check]:checkbox[value='" + selvalues[i] + "']").attr('checked', 'true');
            }

        }
    }
    function SaveDepartManager() {
        //已有操作员 "114,92,70,"
        var sel = ",";//新选择的操作员"114,92,83,34,35,"
        var adduser = ",";
        //01有添加，02有修改
        $("input[name=mr_manager_check]").each(function () {
            debugger;//this.checked
            if ($(this).is(":checked")) {//操作员 有分页。。。。。只能获取当前页面 选择的操作员。。。要不去掉分页？？？
                sel = sel + $(this).val() + ",";
            } 
        });
        var ids = "";
        var delUsers = ",";
        var flag = "deluser";//部门下有操作员, 没有勾选的操作员 从部门中将其移除。
        //sel  ,oldUser  //136,49,  //49, --
        var oldUser = $("#manager_right_hid_seldep").val().split(",");
        for (var i = 0; i < oldUser.length; i++) {
            if (sel.indexOf("," + oldUser[i] + ",") < 0 && oldUser[i]!="") {//新选择的操作员ID,不包含 已有操作员ID，---就是要从部门中将其移除。
                delUsers += oldUser[i]+",";
            }
            
        }
        //debugger;
        sel = sel.split(",");
        for (var j = 0; j < sel.length; j++) {
            if (("," + $("#manager_right_hid_seldep").val()).indexOf("," + sel[j] + ",") < 0 && sel[j]!="") {
                adduser = adduser + sel[j] + ",";
            }
        }
        if (delUsers=="" && adduser=="") {
            TopTrip("未更新数据", 2);
            return;//不用更新数据
        }
        //ids = delUsers;
        //$("#manager_right_hid_seldep").val().length==0    ,部门下没有操作员，如果勾选 操作员，后台判断操作员部门ID、Name是否空，为空 就修改。。。
        //if ($("#manager_right_hid_seldep").val().length == 0) {
        //    flag = "adduser";
        //    ids = sel;
        //}
        //if (delUsers=="") {
        //    TopTrip("更新成功", 1);
        //    return;
        //}
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var deptname = treeObj.getNodeByParam("id", $("#right_main_authid").val(), null).name;
        deptname = deptname.split('[')[0];
        console.log("ddddddddeleteuuuu111"+delUsers);
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateDepartManager.ashx',
            async: false,
            dataType: 'text',
            data: {
                myflag: flag,
                deptName:deptname,
                authid: $("#right_main_authid").val(),
                idtype: 0,
                type: 4,
                sellist: delUsers,//sel
                addusers:adduser
            },
            success: function (data) {
                console.log("ddddddddeleteuuuu222" + data);
                if (data == "-1") {
                    LoginTimeOut();
                } else if (data=="" || data==0) {
                    TopTrip("未更新数据", 2);//未更新数据
                }
                else {
                    if (data > 0) {
                        TopTrip("更新成功", 1);
                        $('#mm2').load('/company/depart/common/depart_left.html');
                    }
                    else {
                        TopTrip("系统错误，请联系管理员", 3);
                    }
                }
            }
        });
    }
</script>
<input type="hidden" id="manager_right_hid_seldep" runat="server" />
<div class="limit_access">
    <div class="tit">操作员列表</div>
    <ul class="limitlist clearfix" id="mr_managerlist">
    </ul>
    <div id="pager"></div>
    <div class="depart_m_btn"  title="确认">
        <span class="bgImage"></span>
        <input class="btn" value="确 认" title="确认" onclick="SaveDepartManager()" type="button">
    </div>
</div>

