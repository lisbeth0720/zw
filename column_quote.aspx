<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_quote.aspx.cs" Inherits="Web.company.column.column_quote" %>
<script type="text/javascript">
    $(function () {
        $.ajax({
            type: 'post',
            url: '/company/source/ajax/getmenulist.ashx',
            async: true,
            data: {
                sourceid: $("#column_quote_sourceid").val(),
                menutype: 2
            },
            dataType: 'text',
            success: function (data) {
                var json = eval("(" + data + ")");
                $.each(json.Table, function (idx, item) {
                    $("#column_qoute_proglist").append('<li>' + item.itemname + '</li>');//<input name="column_quote_progcheck" type="checkbox" value="' + item.menuid + '">
                });
            }
        })
        $("#column_quote_progcheckall").click(function () {
            $("input[name=column_quote_progcheck]").attr("checked", $(this).attr("checked"));
        });
       
    })
    function closeColumnQuoteBox() {
        $("#column_quote").fadeOut(function () {
            $("#overlay").fadeOut();
            $("#column_quote").empty();
        });
    }
</script>
<input type="hidden" id="column_quote_sourceid" runat="server" />
<div style="position: absolute; right: 0; top: 0; width: 30px; height: 30px; cursor: pointer;">
    <img src="/images/icon_closeBox.png" onclick="closeColumnQuoteBox()" />
</div>
<div class="source_con">
    <div class="sc_quote">
        <div class="bt_tit" id="column_quote_sourcename" runat="server"></div>
        <div class="mod_quote">
            <div class="title clearfix">
                <h4>所在节目单</h4>
                <div class="selectd">
                    <input type="checkbox" id="column_quote_progcheckall">全选<div class="icon_z_2"></div>
                </div>
            </div>
            <div class="cont" style="height:260px;overflow:auto;">
                <ul class="checklist clearfix" id="column_qoute_proglist">
                </ul>
            </div>
        </div>
    </div>
</div>

