<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_main.aspx.cs" Inherits="Web.company.program.program_main" %>

<script type="text/javascript">
    $(function () {
        switchLanguage(".source_con", 1, "program_main.aspx");
    })
    function loadProgramContent(nlink, editid, att3) {
        if (nlink == 0) {
            $("#program_web_link").text(getLanguageMsg("添加节目单", $.cookie("yuyan")));
            if (typeof (editid) == "undefined") {
                $("#div_program_add").load("program/program_add.aspx", function () {
                    $(".ny_content").slideUp();
                    $("#div_program_add").slideDown();
                });
            }
            else {
                $("#div_program_add").load("program/program_add.aspx", { "id": editid }, function () {
                    $(".ny_content").slideUp();
                    $("#div_program_add").slideDown();
                });
            }
        }
        if (nlink == 1) {
            $("#program_web_link").text(getLanguageMsg("节目单列表", $.cookie("yuyan")));
            ClearProgramListHtml();
            $("#div_program_list").load("program/program_list.aspx", { "t": 0 }, function () {
                $(".ny_content").slideUp();
                $("#div_program_list").slideDown();
            });
        }


        if (nlink == 2) {
            $("#program_web_link").text(getLanguageMsg("节目单列表", $.cookie("yuyan")));
            ClearProgramListHtml();
            $("#div_program_list").load("program/program_list.aspx", { "t": 1 }, function () {
                $(".ny_content").slideUp();
                $("#div_program_list").slideDown();
            });
        }
        if (nlink == 3) {
            $("#program_web_link").text(getLanguageMsg("节目单编排", $.cookie("yuyan")));
            $("#div_program_list").load("program/program_list.aspx", { "t": 2 }, function () {
                $(".ny_content").slideUp();
                $("#div_program_list").slideDown();
            });
        }
        if (nlink == 4) {
            $("#program_web_link").text(getLanguageMsg("编辑节目单", $.cookie("yuyan")));
            if (typeof (att3) != "undefined") {
                $("#div_program_add").load("program/program_edit.aspx", { "id": editid,"filed":1 }, function () {
                    $(".ny_content").slideUp();
                    $("#div_program_add").slideDown();
                });
            }
            else {
                $("#div_program_add").load("program/program_edit.aspx", { "id": editid }, function () {
                    $(".ny_content").slideUp();
                    $("#div_program_add").slideDown();
                });
            }
        }
        if (nlink == 5) {
            $("#div_program_arrange").load("program/program_arrange.aspx", { "id": editid }, function () {
                $(".ny_content").slideUp();
                $("#div_program_arrange").slideDown();
            });
        }
    }

</script>
<form id="program_main" runat="server">
    <div class="pos_area clearfix">
        <div class="pos"><a href="program.html" class="language">节目单管理</a>&gt;<a class="current language" id="program_web_link">添加节目单</a></div>
        <div class="editbtn">
            <!--<div class="source_edit">
            	<span><input type="checkbox" />全选</span>
                <span><a href="#">引用情况</a></span>
            </div>-->
        </div>
    </div>
    <div class="ny_content" id="div_program_add" style="display: none"></div>
    <div class="ny_content" id="div_program_list" style="display: none"></div>
    <div class="ny_content" id="div_program_arrange" style="display: none"></div>
</form>
