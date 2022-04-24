<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="clientgroup_view.aspx.cs" Inherits="Web.company.client.clientgroup_view" %>

<script type="text/javascript">
    $(function () {
        if ($("#h_clientgroup_view_dlevel").val() == "0") {
            $("#clientgroup_view_dlevel").html("终端组根目录");
        }
        if ($("#h_clientgroup_view_dlevel").val() == "1") {
            $("#clientgroup_view_dlevel").html("一级分组");
        }
        if ($("#h_clientgroup_view_dlevel").val() == "2") {
            $("#clientgroup_view_dlevel").html("二级分组");
        }
        if ($("#h_clientgroup_view_dlevel").val() == "3") {
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
</script>
<input type="hidden" id="clientgroup_view_groupid" runat="server" />
<input type="hidden" id="h_clientgroup_view_dlevel" runat="server" />
<div class="zd_add_box" id="clientgroup_viewbox">
    <ul class="clearfix">
        <li style="display: none"><span class="label">终端内部码：</span><span class="addxx" id="clientgroup_view_mark"></span></li>
        <li><span class="label">终端组名称：</span><span class="addxx" id="clientgroup_view_name"></span></li>
        <li><span class="label">终端组级别：</span><span class="addxx" id="clientgroup_view_dlevel"></span></li>
        <li><span class="label">描述：</span>
            <span class="addxx" id="clientgroup_view_descript"></span>
        </li>
        <li><span class="label">位置说明：</span><span class="addxx" id="clientgroup_view_location"></span></li>
        <li><span class="label">推荐度：</span><span class="addxx" id="clientgroup_view_recomand"></span></li>
        <li><span class="label">现场图片：</span>
            <span class="addxx" id="clientgroup_view_picture"></span>
        </li>
        <li><span class="label">创建时间：</span>
            <span class="addxx" id="clientgroup_view_createtime"></span>
        </li>
    </ul>
    
</div>

