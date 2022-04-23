<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_main.aspx.cs" Inherits="Web.company.column.column_main" %>

<script type="text/javascript">
    function loadColumnContent(nlink, editid, editname) {
        if (nlink == 0) {
            $("#column_web_link").text("栏目列表");
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 0 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();

            });
        }
        else if (nlink == 1) {
            $("#column_web_link").text("栏目列表");
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 1 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 2) {
            $("#column_web_link").text("栏目列表");
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 2 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 3) {
            $("#column_web_link").text("栏目编排");
            $("#div_column_arrange").load("column/column_arrange.aspx", { "id": editid, "name": editname }, function () {
                $("#div_column_arrange").fadeIn();
                $("#div_column_list").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 4) {
            $("#column_web_link").text("编排审核");
            $("#div_column_arrange").load("column/column_review.aspx", { "id": editid, "name": editname }, function () {
                $("#div_column_arrange").fadeIn();
                $("#div_column_list").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 5) {
            $("#column_web_link").text("栏目引用记录");
            $("#div_column_quote").load("column/column_quote.aspx", { "id": editid, "name": editname }, function () {
                $("#overlay").fadeIn();
                $("#div_column_quote").fadeIn();
            });
        }
        else if (nlink == 6) {
            $("#column_web_link").text("添加栏目");
            if (typeof (editid) != "undefined") {
                $("#div_column_add").load("column/column_add.aspx", { "id": editid }, function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                    $("#div_column_quote").fadeOut();
                });
            }
            else {
                $("#div_column_add").load("column/column_add.aspx", function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                });
            }
        }
        else if (nlink == 7) {
            if (typeof (editname) != "undefined") {
                $("#column_web_link").text("编辑栏目");
                $("#div_column_add").load("column/column_edit.aspx", { "id": editid, "sq": editname }, function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                    $("#div_column_quote").fadeOut();
                });
            }
            else {
                $("#column_web_link").text("编辑栏目");
                $("#div_column_add").load("column/column_edit.aspx", { "id": editid }, function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                    $("#div_column_quote").fadeOut();
                });
            }
        }
        else if (nlink == 8) {
            $("#column_web_link").text("栏目列表");
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 3 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
    }
</script>
<form id="column_main" runat="server">
    <div class="pos_area clearfix">
        <div class="pos"><a href="column.html">栏目管理</a>&gt;<a class="current" id="column_web_link">栏目信息列表</a></div>
        <div class="editbtn">
            <div class="source_edit">
                <%--<span class="add_icon"><a href="javascript:void(0)" onclick="column_main_loadAdd()">添加</a></span>--%>
            </div>
        </div>
    </div>
    <div class="ny_content" id="div_column_add"></div>
    <div class="ny_content" id="div_column_list"></div>
    <div class="ny_content" id="div_column_arrange"></div>
    <div id="div_column_quote" style="position: absolute; width: 640px; height: 400px; left: 50%; top: 50%; margin-left: -320px; margin-top: -200px; background: #fff; border: 1px solid #ddd; display: none; z-index: 1001"></div>
</form>

