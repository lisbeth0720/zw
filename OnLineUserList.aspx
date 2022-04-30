<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OnLineUserList.aspx.cs" Inherits="Web.company.depart.OnLineUserList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-首页</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/simplePagination.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "post",
                url: '/company/depart/ajax/GetOnLineUser.ashx',
                async: false,
                dataType: 'text',
                data: {
                    username: $("#txt_name").val(),
                    password: $("#txt_pwd").val(),
                    companyid: $("#sel_company").val(),
                    type: 1
                },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    else {
                        $("#depart_OnLineUser").append(data);
                    }
                }
            });
        })
        function kickUser(userid) {
            $.ajax({
                type: "post",
                url: '/company/depart/ajax/KickOnLineUser.ashx',
                async: false,
                dataType: 'text',
                data: {
                    id: userid
                },
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else if (data == 0) {
                        TopTrip("系统错误，请联系管理员", 2);
                    }
                    else if (data == 1) {
                        $("#depart_OnLineUser tr[data-id=" + userid + "]").remove();
                    } else if (data==2) {//踢出自己。。
                        LoginTimeOut();
                    }
                    else {
                        window.location.href = "/company/usercenter/LogOut.aspx";
                    }

                }
            });
        }
    </script>
</head>
<body>
    <!-- #include file="/common/top.html" -->
    <div class="container clearfix">
        <div class="pos_area clearfix">
            <div class="pos"><a href='/company/depart/depart_main.aspx?t=0'>部门/用户管理</a>><a href="OnLineUserList.aspx" class="current">注册用户列表</a></div>
        </div>
        <table id="depart_OnLineUser" class="tab_list" width="100%">
        </table>
    </div>
</body>
</html>
