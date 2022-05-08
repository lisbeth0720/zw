<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_quote.aspx.cs" Inherits="Web.company.program.program_quote" %>
<script type="text/javascript">
    $(function () {
        $.ajax({
            type: 'post',
            url: 'ajax/getclientlist.ashx',
            async: true,
            data: {
                menuid: $("#program_quote_sourceid").val(),
                menutype: 2
            },
            dataType: 'text',
            success: function (data) {
                var json = eval("(" + data + ")");
                $.each(json.Table, function (idx, item) {
                    $("#program_qoute_proglist").append('<li>' + item.clientname + '</li>');    //<input name="column_quote_progcheck" type="checkbox" value="' + item.groupflag + '">
                });
            }
        })
        switchLanguage(".mod_quote", 1, "program_quote.aspx");
        //$("#column_quote_progcheckall").click(function () {
        //    $("input[name=column_quote_progcheck]").attr("checked", $(this).attr("checked"));
        //});

    })
    function closeProgramQuoteBox() {
        $("#program_quote").fadeOut(function () {
            $("#overlay").fadeOut();
            $("#program_quote").empty();
        });
    }

</script>
<input type="hidden" id="program_quote_sourceid" runat="server" />
<div style="position: absolute; right: 0; top: 0; width: 30px; height: 30px; cursor: pointer;">
    <img src="/images/icon_closeBox.png" onclick="closeProgramQuoteBox()" />
</div>
<div class="source_con">
    <div class="sc_quote">
        <div class="bt_tit" id="program_quote_sourcename" runat="server"></div>
        <div class="mod_quote">
            <div class="title clearfix">
                <h4 class="language">所在终端</h4>
            </div>
            <div class="cont">
                <ul class="checklist clearfix" id="program_qoute_proglist" style="height:260px;overflow:auto;">
                </ul>
            </div>
        </div>
    </div>
</div>

