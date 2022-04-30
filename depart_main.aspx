<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="depart_main.aspx.cs" Inherits="HuiFeng.Web.company.depart_main" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-首页</title>
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <link href="/css/zTreeStyle.css" rel="stylesheet" />
    <link href="/css/simplePagination.css" rel="stylesheet" />
    <link href="/css/style.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.simplePagination.js"></script>
    <script src="/js/jquery.ztree.core.js"></script>
    <script src="/js/jquery.ztree.excheck.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/jquery.colorpicker.js"></script>
    <script src="/js/passwordStrength.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/mxjfunction.js"></script>
    <style>
                .mask {
            width: 100%;
            height: 100%;
            min-width: 1200px;
            min-height: 650px;
            position: absolute;
            top: 0px;
            background: rgba(0, 0, 0, 0.5);
            /*padding-left: 18%;*/
            /*box-sizing: border-box;*/
            display: none;
            z-index: 100;
            /*display: flex;*/
            /*justify-content: center;*/
            /*align-items: center;*/
        }

        .mask .flex {
            width: 100%;
            height: 100%;
            box-sizing: border-box;         
            display: webkit-box;
            display: -moz-box;
            display: -ms-flexbox;
            display: webkit-flex;
            display: flex;
            align-items: center;

            -webkit-justify-content: center; 
            -moz-justify-content: center; 
            -ms-justify-content: center; 
            -o-justify-content: center; 
            /*justify-content: center; */
 
        }

            .mask .img {
                float: right;
                cursor: pointer;
                position: relative;
                /*top: -70%;*/
            }
            
        .tanchuang {
            margin: 0 auto;
            color: #000;
            /*width: 61%;*/
            /*height: 80%;*/
            /*height: 600px;*/
            background: #f2f2f0;
         

        }

        .tanchuang .ddbody{
            width: 100%;
            height: 40px;
            line-height: 40px;
            background-color: #2e4050;
            color: #ffffff;
            font-size: 16px;
            padding-left: 20px;
            box-sizing: border-box;
        }

        .tanchuang .ddload{
            width: 100%;
            /*height: 560px;*/
        }

        .tanchuang form {
            width: 100%;
            height: 100%;
        }
    </style>
    <script type="text/javascript">
        $(function () {// //只有部门经理、超级管理员    能添加部门、操作员！
            //$("#depart_main_type").val()  //1，3  //添加部门、操作员 
            //if ($("#depart_main_type").val() == "1" || $("#depart_main_type").val() == "3") {
            if ($("#addUserDepart").val() == "True") {
                $(".source_edit").show();
                //loadDepartContent($("#depart_main_type").val());
            }
            else {
                $(".source_edit").hide();
                //loadDepartContent($("#depart_main_type").val());
            }
            loadDepartContent($("#depart_main_type").val());
        })
        function loadDepartContent(nlink, depart_auth_id) {
            if (nlink == 0) {
                $("#depart_main_webmap").html("<a href='/company/depart/depart_main.aspx?t=0' class='current'>部门列表</a>");
                $("#divdepartlist").load("/company/depart/department_list.aspx", function () {
                    $("#divdepartlist").show().siblings(".w750").html("").hide();
                });
                $("#depart_operate").slideDown();
                $("#depart_oluser_list").html("").slideUp();
            }
            else if (nlink == 1) {
                if (typeof (depart_auth_id) == "undefined") {
                    $("#depart_main_webmap").html("<a href='/company/depart/depart_main.aspx?t=1' class='current' title='添加部门'>添加部门</a>");
                    if ($("#divdepartadd").html() != "") {
                        $("#divdepartadd").show().siblings(".w750").html("").hide();
                    }
                    else {
                        $("#divdepartadd").load("/company/depart/department_add.aspx?fid=" + $("#depart_main_parentdid").val(), function () {
                            $("#divdepartadd").show().siblings(".w750").html("").hide();
                        });
                    }
                }
                else {

                    $("#depart_main_webmap").html("<a href='/company/depart/depart_main.aspx?t=1' class='current' title='添加部门'>添加部门</a>");
                    $("#divdepartadd").load("/company/depart/department_add.aspx", { "id": depart_auth_id, "fid": $("#depart_main_parentdid").val() }, function () {
                        $("#divdepartadd").show().siblings(".w750").html("").hide();
                    });
                }
                $("#depart_oluser_list").slideUp().html("");
                $("#depart_operate").slideDown();

            }
            else if (nlink == 2) {
                $("#depart_main_webmap").html("<a href='/company/depart/depart_main.aspx?t=2' class='current' title='操作员列表'>操作员列表</a>");
                $("#divpplist").load("/company/depart/department_pp_list.aspx", function () {
                    $("#divpplist").show().siblings(".w750").html("").hide();
                    $("#depart_oluser_list").slideUp().html("");
                    $("#depart_operate").slideDown();
                })
            }
            else if (nlink == 3) {
                $("#depart_main_webmap").html("<a href='/company/depart/depart_main.aspx?t=3' class='current' title='添加操作员'>添加操作员</a>");
                if ($("#divppadd").html() != "") {
                    $("#divppadd").show().siblings(".w750").html("").hide();
                }
                else {
                    $("#divppadd").load("/company/depart/department_pp_add.aspx", { "fid": $("#depart_main_parentdid").val() }, function () {
                        $("#divppadd").show().siblings(".w750").html("").hide();
                        $("#depart_oluser_list").slideUp().html("");
                        $("#depart_operate").slideDown();
                    })
                }
            }
            else if (nlink == 4) {
                $("#depart_main_webmap").html('<a href="javascript:void(0)" class="current" title="部门信息">部门信息</a>');
                $("#divdepartment").load("/company/depart/right_main.aspx", { "id": depart_auth_id, "idtype": 1 }, function () {
                    $("#divdepartment").show().siblings(".w750").hide().html("");
                    $("#depart_oluser_list").slideUp().html("");
                    $("#depart_operate").slideDown();
                });
            }
            else if (nlink == 5) {
                $("#depart_main_webmap").html('<a href="javascript:void(0)" class="current" title="用户信息">用户信息</a>');
                $("#divdepartment").load("/company/depart/right_main.aspx", { "id": depart_auth_id, "idtype": 0 }, function () {
                    $("#divdepartment").show().siblings(".w750").hide().html("");
                    $("#depart_oluser_list").slideUp();
                    $("#depart_operate").slideDown();
                });
            }
            /*else if (nlink == 6) {///Import_ExportData.aspx  //批量导入操作员  ///company/depart/depart_main.aspx?t=6
                $("#depart_main_webmap").html("<a href='/company/depart/depart_main.aspx?t=6' class='current' title='批量导入操作员'>批量导入操作员</a>");
                if ($("#divppadd").html() != "") {
                    $("#divppadd").show().siblings(".w750").html("").hide();
                }
                else {
                    $("#divppadd").load("/Import_ExportData.aspx", {}, function () {
                        $("#divppadd").show().siblings(".w750").html("").hide();
                        $("#depart_oluser_list").slideUp().html("");
                        $("#depart_operate").slideDown();
                    })
                }
            }*/
        }
    </script>
</head>
<body>
    <!-- #include file="/common/top.html" -->
    <div id="container" class="clearfix">
        <input type="hidden" id="addUserDepart" runat="server" />
        <input type="hidden" id="depart_main_type" runat="server" />
        <input type="hidden" value="0" id="depart_main_parentdid" />
        <div class="pos_area clearfix">
            <div class="pos"><a href="/company/depart/depart_main.aspx?t=0">部门/用户管理</a>><span id="depart_main_webmap"></span></div>
            <%-- <div class="editbtn">
                <div class="depart_edit">
                    <ul>
                        <li id="depart_main_li_adddepart"><a href="javascript:void(0)" onclick="loadDepartContent(1)">添加部门</a></li>
                        <li id="depart_main_li_addmanager"><a href="javascript:void(0)" onclick="loadDepartContent(3)">添加操作员</a></li>
                    </ul>
                </div>
            </div>--%>
            <div class="editbtn">
                <div class="source_edit">
                    <span class="add_icon"><a href="/company/depart/depart_main.aspx?t=1" title="添加部门"><b style="padding-left: 20px; background: url(/images/tubiao.png) -254px -128px;"></b>添加部门</a></span>
                    <span class="add_icon"><a href="/company/depart/depart_main.aspx?t=3" title="添加操作员"><b style="padding-left: 20px; background: url(/images/tubiao.png) -254px -128px;"></b>添加操作员</a></span>
                    <span class="add_icon"><a href="/Import_ExportData.aspx" title="批量导入操作员"><b style="padding-left: 20px; background: url(/images/tubiao.png) -254px -127px;"></b>批量导入操作员</a></span>
                </div>
            </div>
        </div>
        <div class="ny_content clearfix" id="depart_operate">
            <div class="w210" id="mm2">
                <!-- #include file="common/depart_left.html" -->
            </div>
            <div class="w750" id="divdepartlist"></div>
            <div class="w750" id="divdepartadd"></div>
            <div class="w750" id="divpplist"></div>
            <div class="w750" id="divppadd"></div>
            <div class="w750" id="divdepartment"></div>
        </div>
    </div>
     <div id="mask" class="mask">
        <div class="flex">
            <%--<div class="img" onclick="closeMask()">--%>
                        <%--<img src="../Images/close2.png" alt="" /></div>--%>
            <div class="tanchuang">
                <div class="ddbody"><span></span><img class="img" src="/Meeting/Images/close2.png" alt="" onclick="closeMask()"/></div>
                <div class="ddload"></div>
            </div>
        </div>

    </div>
</body>
</html>
