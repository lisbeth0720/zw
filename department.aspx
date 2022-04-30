<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="department.aspx.cs" Inherits="HuiFeng.Web.company.department" %>

<script type="text/javascript">
    function editDepart(departid) {
        loadDepartContent(1, departid);
    }
</script>
<form id="department" runat="server">
    <input type="hidden" id="department_hid_departid" runat="server" />
    <div class="depart_add_box">
        <ul class="clearfix" style="width:70%;margin:0 auto;">
            <li><span class="label">部门名称：</span><span class="font_blue" id="department_departname" runat="server"></span></li>
            <li><span class="label">部门代表色：</span><span class="b_red" style="float:left; margin-top:6px;" id="department_departcolor" runat="server"></span></li>
            <li><span class="label">部门描述：</span><span id="department_departdes" runat="server"></span></li>
            <li><span class="label">部门负责人：</span><span id="depart_leader" runat="server"></span></li>
            <li class="last" id="department_departedit" title="修 改" runat="server"><span class="btn" style="margin-left:50px;" runat="server"><a href="#">修 改</a></span></li>
        </ul>
        
    </div>
</form>
