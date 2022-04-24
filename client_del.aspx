<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_del.aspx.cs" Inherits="Web.company.client.client_del" %>

<script type="text/javascript">
    $(function () {
        if ($("#h_clientgroup_view_dlevel").val() == "0") {
            $("#clientgroup_view_dlevel").html("终端组根目录");
        }
        if ($("#h_clientgroup_view_dlevel").val() == "1") {
            $("#clientgroup_view_dlevel").html("一级分组");
        }
        if ($("#h_clientgroup_view_dlevel").val() == "1") {
            $("#clientgroup_view_dlevel").html("二级分组");
        }
        if ($("#h_clientgroup_view_dlevel").val() == "1") {
            $("#clientgroup_view_dlevel").html("三级分组");
        }
        $.ajax({
            type: 'post',
            url: 'client/ajax/getclientgroupinfo.ashx',
            async: true,
            dateType: 'text',
            data: { "gid": $("#clientgroup_view_groupid").val() },
            success: function (data) {
                var json = strToJson(data);
                $.each(json.Table, function (idx, item) {
                    $("#clientgroup_view_mark").html(item.clientmark);
                    $("#clientgroup_view_name").html(item.clientname);
                    $("#clientgroup_view_descript").html(item.descript);
                    $("#clientgroup_view_location").html(item.location);
                    $("#clientgroup_view_recomand").html(item.recommend);
                    if (item.picture == "") {
                        $("#clientgroup_view_picture").html('<img src="/images/no_upload.jpg" width="200" height="113">');
                    }
                    else {
                        $("#clientgroup_view_picture").html('<img src="' + item.picture + '" width="200" height="113">');
                    }
                    $("#clientgroup_view_createtime").html(item.createtime);
                });
            }
        });
    })
    function clientgroup_del(){
        alert($("#clientgroup_del_groupid").val());
    }
</script>
<input type="hidden" id="clientgroup_del_groupid" runat="server" />
<div class="zd_delete">
    <h4>删除后记录将不再可用，确定删除吗？</h4>
    <div class="sc_add_btn clearfix" style="margin-left: 190px;"><span class="inp_btn">
        <input class="btn" value="确定" type="button" onclick="clientgroup_del()"></span><span class="inp_btn"><input class="btn" value="取消" type="button"></span></div>
</div>
