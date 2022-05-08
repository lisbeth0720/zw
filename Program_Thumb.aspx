<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Program_Thumb.aspx.cs" Inherits="Web.company.program.Program_Thumb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        html, body,form {
       margin:0;
       padding:0;
        }
        form {
        width:200px; height:120px;}
    </style>
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/common.js"></script>

    <script type="text/javascript">
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
                        var html = my[4].replace(new RegExp("programBkstyle.htm", 'g'), "programBkstyle.htm");
                        obj.html(html);
                      
                    }
                    program_thumbview_bindlayoutname();
                }
            });
        }
        function program_thumbview_bindlayoutname() {

            $(document.getElementById('Program_ArrangeMainFrame').contentWindow.document.body).find("frame").each(function () {
                program_thumbview_getwindowHtml(this.name);
            });
        }
        function program_thumbview_getwindowHtml(windowsname) {
            var layoutposition = $("#program_thumb_layposition").val();
            var menuid = $("#program_thumb_menuid").val();

            $.ajax({
                type: "post",
                url: 'ajax/getfirstitem.ashx',
                async: false,
                dataType: 'text',
                data: {
                    menuid: $("#program_thumb_menuid").val(),
                    layoutid: $("#program_thumb_layoutid").val(),
                    lotpos: $("#program_thumb_layposition").val(),
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
        function program_fullview_getSouceInfo(scid, contenttype, windowname, tempid) {
            document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(windowname)[0].src = "../program/FilePreview.aspx?itemid=" + scid + "&templateid=" + tempid + "&w=" + windowname + "&desript=&t=" + new Date().getTime();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="program_thumb_menuid" runat="server" />
        <input type="hidden" id="program_thumb_layoutid" runat="server" />
        <input type="hidden" id="program_thumb_layposition" runat="server" />
        <div id="program_lay_main" style="width: 200px; height: 120px; overflow:hidden">
            <iframe id="Program_ArrangeMainFrame" src="../Layout/frame.html" onload="Program_View_LayoutRecord('<%=layid %>')" style="height: 100%; width: 100%; overflow: hidden; border: hidden;"></iframe>
        </div>
    </form>
</body>
</html>
