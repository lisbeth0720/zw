<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_list.aspx.cs" Inherits="Web.company.client.client_list" %>
<script type="text/javascript">
    $(function () {
        $.ajax({
            type: 'post',
            url: 'client/ajax/getclientlist.ashx',
            async: true,
            dateType: 'text',
            data: { "gid": $("#client_list_groupid").val(), "dlv": $("#client_list_dlevel").val() },
            success: function (data) {
                var json = strToJson(data);
                var i = 0;
                $.each(json.Table, function (idx, item) {
                    var selHtml = '<span class="noselect"></span>';
                    if (i == 0) {
                        $("#client_list_selectid").val(item.clientid);
                        $("#client_list_selectmark").val(item.clientmark);
                        selHtml = '<span class="select"></span>';
                    }
                    i++;
                    $("#client_list_box").append('<div class="mod_fflist" data-clientid="' + item.clientid + '">'
                        + '<div class="ff_tit"><span class="state"></span><span class="bt">' + item.clientid + '  ' + item.clientname + '</span>' + selHtml + '</div>'
                        + '<div class="ff_item">'
                        + '<h5><span class="font_blue">节目单分发</span> 1/2</h5>'
                        + '<ul>'
                        + '<li><span class="icon_state have_distrib"></span><span class="bt">012  XXXX节目单</span></li>'
                        + '<li><span class="icon_state no_distrib"></span><span class="bt">012  XXXX节目单</span></li>'
                        + '<li><span class="icon_state be_distrib"></span><span class="bt">012  XXXX节目单</span><div class="jindu">'
                        + '<div class="jindu_per" style="width: 99%">99%</div>'
                        + '</div></ul></div>'
                        + '<div class="ff_btn clearfix">'
                        + '<span class="rizhi fl"><a href="javascript:void(0)" onclick="client_main_loadright(11,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')">日志</a></span>'
                        + '<span class="xiugai fr"><a href="javascript:void(0)" onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')">修改</a></span>'
                        +'</div></div>'
                        );
                    
                });
            }
        });
        $("#client_list_del").click(function () {
            var clientid = $("#client_list_selectid").val();
            var dlevel = 4;
            var mark = $("#client_list_selectmark").val();
            client_main_loadright(7, clientid, dlevel, mark)
        })
        $("#client_list_program").click(function () {
            var clientid = $("#client_list_selectid").val();
            var dlevel = 4;
            var mark = $("#client_list_selectmark").val();
            client_main_loadright(9, clientid, dlevel, mark)
        })
        $("#client_list_cmd").click(function () {
            var clientid = $("#client_list_selectid").val();
            var dlevel = 4;
            var mark = $("#client_list_selectmark").val();
            client_main_loadright(10, clientid, dlevel, mark)
        })
    })
    
    $(".mod_fflist").live("click", function () {
        $("#client_list_selectid").val($(this).attr("clientid"));
        $(this).children(".ff_tit").children().last().addClass("select").removeClass("noselect");
        $(this).siblings().children(".ff_tit").children().last().addClass("noselect").removeClass("select");
    });
</script>
<input type="hidden" id="client_list_groupid" runat="server" />
<input type="hidden" id="client_list_dlevel" runat="server" />
<input type="hidden" id="client_list_selectid" runat="server" />
<input type="hidden" id="client_list_selectmark" runat="server" />
<div class="history">
    <div class="title">终端列表</div>
    <div class="cont">
        <div class="zd_list clearfix" id="client_list_box">
        </div>
        <div class="oprat">
            <span><a id="client_list_del" href="javascript:void(0)">删除</a></span>
            <span><a id="client_list_program" href="javascript:void(0)">节目单分发</a></span>
            <span><a id="client_list_cmd" href="javascript:void(0)">远程指令</a></span>
        </div>
    </div>
</div>
