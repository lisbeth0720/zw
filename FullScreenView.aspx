<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FullScreenView.aspx.cs" Inherits="Web.company.column.FullScreenView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <style type="text/css">
        html, body, #column_Full_main { width: 100%; height: 100%; margin: 0; padding: 0; }
    </style>
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript">
        $(function () {
            var scid = $("#column_full_scid").val();
            var tempid = $("#column_full_temp").val();
            $("#column_fullview_mainframe").attr("src", "FilePreview.aspx?itemid=" + scid + "&templateid=" + tempid + "&desript=&t=" + new Date().getTime());
        });
        function fullScreen() {
            elem = document.body;
            if (elem.webkitRequestFullScreen) {
                elem.webkitRequestFullScreen();
            } else if (elem.mozRequestFullScreen) {
                elem.mozRequestFullScreen();
            } else if (elem.requestFullScreen) {
                elem.requestFullscreen();
            } else {
                //浏览器不支持全屏API或已被禁用
            }
        }

    </script>
</head>
<body>
    <div class="add_btn" style="position: absolute; right: 0; top: 0">
        <span class="inp_btn"><a href="javascript:void(0)" onclick="fullScreen()">全屏预览</a></span>
    </div>
    <input type="hidden" id="column_full_scid" runat="server" />
    <input type="hidden" id="column_full_temp" runat="server" />
    <input type="hidden" id="column_full_ct" runat="server" />
    <div id="column_Full_main">
        <iframe id="column_fullview_mainframe" src="column_arrange_frame.html" frameborder="0" width="100%" height="100%"></iframe>
    </div>
</body>
</html>
