<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FullScreenView.aspx.cs" Inherits="Web.company.program.FullScreenView" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        html, body, #program_Full_main {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/common.js"></script>
    <script type="text/javascript">
        //获取布局信息
        function Program_View_LayoutRecord(id) {
            $.ajax({
                type: "post",
                url: '../Layout/LayoutHandler.ashx',
                async: false,
                dataType: 'text',
                data: {
                    a: "record",
                    id: id
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    else if (data == "-2") {
                        LoginTimeOut();
                    }
                    else {
                        var my = data.split('||');
                        var obj = $(document.getElementById('Program_ArrangeMainFrame').contentWindow.document.body);
                        var html = my[4].replace(new RegExp("bk.htm", 'g'), "bk2.htm");
                        obj.html(html);
                    }
                    program_fullview_bindlayoutname();
                }
            });
        }
        //绑定布局窗口名
        function program_fullview_bindlayoutname() {
            var i = 0;
            $(document.getElementById('Program_ArrangeMainFrame').contentWindow.document.body).find("frame").each(function () {
                program_fullview_getwindowHtml(i+"-"+this.name);
                i++;
            });
            //document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName($("#program_full_window").val())[0].style.borderTop = "2px solid #f00";
        }
        //获取第一个素材并显示到窗口
        function program_fullview_getwindowHtml(windowsname) {
           
            var layoutposition = $("#program_full_layposition").val();
            var menuid = $("#program_full_menuid").val();//节目单编排：全屏预览。。
            var owindowsname = $("#program_full_window").val();
            if (windowsname != owindowsname) {//windowsname != $("#program_full_window").val()
                $.ajax({
                    type: "post",
                    url: 'ajax/getfirstitem.ashx',
                    async: false,
                    dataType: 'text',
                    data: {
                        menuid: $("#program_full_menuid").val(),
                        layoutid: $("#program_full_layoutid").val(),
                        lotpos: $("#program_full_layposition").val(),
                        windows: windowsname
                    },
                    success: function (data) {
                        var json = strToJson(data);
                        $.each(json.Table, function (idx, item) {
                            program_fullview_getSouceInfo(item.sourceid, item.contenttype, windowsname, item.tempid);

                        });
                    }
                });
            }
            else {
                program_fullview_getSouceInfo($("#program_full_sourceid").val(), $("#program_full_contenttype").val(), windowsname, $("#program_full_tempid").val());
            }
        }
        //设置窗口素材预览页面url
        function program_fullview_getSouceInfo(scid, contenttype, windowname, tempid) {
            var surl = "../program/FilePreview.aspx?itemid=" + scid + "&templateid=" + tempid + "&w=" + windowname + "&fullscreen=true&desript=&t=" + new Date().getTime();
            windowname = windowname.substr(2);
            $("#Program_ArrangeMainFrame").contents().find("frame[name=" + windowname + "]").attr("src", surl);
            //document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(windowname)[0].src = "../program/FilePreview.aspx?itemid=" + scid + "&templateid=" + tempid + "&w=" + windowname + "&desript=&t=" + new Date().getTime();
        }
    </script>
</head>
<body>
    <div class="add_btn" style="position: absolute; right: 0; top: 0">
        <span class="inp_btn"><a href="javascript:void(0)" onclick="fullScreen()">全屏预览</a></span>
    </div>
    <input type="hidden" id="program_full_menuid" runat="server" />
    <input type="hidden" id="program_full_layoutid" runat="server" />
    <input type="hidden" id="program_full_window" runat="server" />
    <input type="hidden" id="program_full_layposition" runat="server" />
    <input type="hidden" id="program_full_sourceid" runat="server" />
    <input type="hidden" id="program_full_tempid" runat="server" />
        <input type="hidden" id="program_full_contenttype" runat="server" />
    <div id="program_Full_main">
        <iframe id="Program_ArrangeMainFrame" src="../Layout/frame.html" onload="Program_View_LayoutRecord('<%=layid %>')" style="height: 100%; width: 100%; overflow: hidden; border: hidden;"></iframe>
    </div>
</body>
</html>
