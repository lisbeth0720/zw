<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="right_main.aspx.cs" Inherits="Web.company.depart.right_main" %>

<script type="text/javascript">
    $(function () {
        $("#web_pp_right_nav li:first").addClass("current");
        var defaultrightpage = $("#web_pp_right_nav li:first").attr("data-pageurl");
        var type = $("#web_pp_right_nav li:first").attr("data-type");
        $("#web_pp_right_rightpage").load(defaultrightpage, { "type": type, "idtype": $("#right_main_idtype").val(), "id": $("#right_main_authid").val() }, function () {
            $("#web_pp_right_rightpage").fadeIn();
        });
        $("#web_pp_right_nav li").click(function () {
            defaultrightpage = $(this).attr("data-pageurl");
            $(this).addClass("current").siblings().removeClass("current");
            type = $(this).attr("data-type");
            $("#web_pp_right_rightpage").load(defaultrightpage, { "type": type, "idtype": $("#right_main_idtype").val(), "id": $("#right_main_authid").val() }, function () {
                $("#web_pp_right_rightpage").fadeIn();
            });
        });
    })

</script>
<form id="right_main" runat="server">
    <input type="hidden" id="right_main_idtype" runat="server" />
    <input type="hidden" id="right_main_authid" runat="server" />
    <div class="depart_authorize">
        <div id="right_main_top" runat="server"></div>
        <div class="item">
            <ul class="clearfix" id="web_pp_right_nav" runat="server">
            </ul>
        </div>
        <div class="limitcon" id="web_pp_right_rightpage">
        </div>
    </div>

</form>

