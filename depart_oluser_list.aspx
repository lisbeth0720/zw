<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="depart_oluser_list.aspx.cs" Inherits="Web.company.depart.depart_oluser_list" %>

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
                url: '/company/depart/ajax/getcustomlist.ashx',
                async: false,
                dataType: 'text',
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    else {
                        var json = strToJson(data);
                        $.each(json.Table, function (idx, item) {
                            $("#depart_oluser_list_tab").append('<tr>'
                                + '<td><input type="checkbox" name="dp_olu_lst_check" value="' + item.userid + '">' + item.userid + '</td>'
                                + '<td>' + item.username + '</td>'
                                + '<td>' + item.fullname + '</td>'
                                + '<td>' + item.email + '</td>'
                                + '<td>' + item.mobile + '</td>'
                                + '<td><select name="depart_userlist_select" data-userid="' + item.userid + '" data-status="' + item.status + '"><option value="100">未审核</option><option value="0">审核通过</option><option value="1">过期</option><option value="2">禁用</option><option value="3">注销</option></select></td>'
                                + '<td>' + item.logondate + '</td>'
                                + '</tr>');
                            $("select[name=depart_userlist_select][data-userid=" + item.userid + "]").val(item.status);

                        })

                    }
                }
            });
            $("select[name=depart_userlist_select]").change(function () {
                var userid = $(this).attr("data-userid");
                var status = $(this).val();
                $.ajax({
                    type: "post",
                    url: '/company/depart/ajax/editcustom.ashx',
                    async: false,
                    data: { "id": userid, "s": status },
                    dataType: 'text',
                    success: function (data) {
                        if (data > 0) {
                            TopTrip("审核成功！",1);
                        }
                        else {
                            TopTrip("系统错误，请稍后再试", 3);
                        }
                    }
                })
            });
        })
    </script>
</head>
<body>
    <!-- #include file="/common/top.html" -->
    <div class="container clearfix">
        <div class="pos_area clearfix">
            <div class="pos"><a href='depart_main.aspx?t=0'>部门/用户管理</a>><a href="depart_oluser_list.aspx" class="current">在线用户列表</a></div>
        </div>
        <table id="depart_oluser_list_tab" class="tab_list" width="100%">
            <tr>
                <th>序号</th>
                <th>用户名</th>
                <th>真实姓名</th>
                <th>邮箱</th>
                <th>手机</th>
                <th>状态</th>
                <th>最近登录</th>
            </tr>
        </table>
    </div>
</body>
</html>
