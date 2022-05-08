<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_list.aspx.cs" Inherits="Web.company.program.program_list" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-节目单编排</title>
    <link href="/css/style.css" rel="stylesheet" />
     <%--<link href="/css/Validatedemo.css" rel="stylesheet" />--%>
    <link href="/css/bootstrap.css" rel="stylesheet" />
    <%--<link href="/css/component.css" rel="stylesheet" />--%>
    <%--<link href="/js/jquery-ui/jquery-ui.css" rel="stylesheet" />--%>
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script src="/js/jquery-ui/jquery-ui.min.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/jquery.simplePagination.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/mxjfunction.js"></script>
    <style>
        .sc_add_box ul li .sc_list th,.sc_add_box ul li .sc_list th td{overflow:hidden;border-right:1px solid #cdcdcd;border-bottom:1px solid #cdcdcd;text-align:center;line-height:25px}
         #add_jiemu table tr td:first-child
        {
            width:200px;
            height:38px;
            line-height:38px;
            text-align:right;
        }
        #add_jiemu table tr td:last-child
        {
            width:200px;
        }
        #add_jiemu table tr td input
        {
            width:150px;
            height:25px;
        }
         .clearfix input[type=text]::-ms-clear {
          display:none
        }
        .sc_list_box .title ul.bt li {
            width:190px;
            font-size:16px;
        }
    </style>
    <script type="text/javascript">
        
        $(function () {
            getJsonValue();
            //$.ajax({
            //    type: 'post',
            //    url: '/company/source/ajax/getgroupinfo.ashx',
            //    async: true,
            //    dataType: 'text',
            //    success: function (data) {
            //        var json = eval("(" + data + ")");
            //        var html = "";
            //        var childlist;

            //        $.each(json.child, function (idx, item) {
            //            if (item.groupflag == 1) {
            //                html += '<option value="' + item.classifyid + '" disabled="">' + item.classifyname + '</option>';
            //            }
            //            else {
            //                html += '<option value="' + item.classifyid + '">' + item.classifyname + '</option>';
            //            }
            //            childlist = item.child;
            //            $.each(childlist, function (idx, item) {

            //                if (item.groupflag == 1) {
            //                    html += '<option value="' + item.classifyid + '" disabled="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
            //                }
            //                else {
            //                    html += '<option value="' + item.classifyid + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
            //                }
            //                var childlist2 = item.child;
            //                $.each(childlist2, function (idx, item) {
            //                    if (item.groupflag == 1) {
            //                        html += '<option value="' + item.classifyid + '" disabled="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
            //                    }
            //                    else {
            //                        html += '<option value="' + item.classifyid + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
            //                    }
            //                });
            //            });
            //        });
            //        $("#program_add_group1").html(html);
            //    }
            //})
            //显示更多筛选条件， 点击变样式
            var show_list = new Mxjfn();
            show_list.showItem(".sc_select_nocommon");
            //alert($("#sc_list_show").val());
            //调用点击回车 搜索功能 
            var keydown = new Mxjfn();
            keydown.key_home(".inp_s", "13");
            //whq //点击菜单，更新导航条
            var colType = window.location.search;//1 节目单审核2 节目单编排 3节目单编排审核
            if (colType != "") {
                var myType = colType.split('t=')[1];
                var aLink = $(".pos a:eq(1)");
                if (myType == "1") {
                    aLink.attr("href", "program_list.aspx?t=1").html(getLanguageMsg("节目单审核", $.cookie("yuyan")));
                } else if (myType == "2") {
                    aLink.attr("href", "program_list.aspx?t=2").html(getLanguageMsg("节目单编排", $.cookie("yuyan")));
                } else if (myType == "3") {
                    aLink.attr("href", "program_list.aspx?t=3").html(getLanguageMsg("节目单编排审核", $.cookie("yuyan")));
                }
            }
            //初始化信息防止页面缓存
            $("#program_list_hid_dr_list_hid_rs").val("");

            $("#program_list_hid_dr_list_hid_dr").val("");
           // $("#program_list_search_sn").val("节目单名称");
           // $("#program_list_search_cd").val("选择开始日期");
            // $("#program_list_search_cd2").val("选择结束日期");
            
            

            //中部工具栏
            if ($("#program_list_hid_type").val() < 4) {
                $("#page_top").show();
                $(".pos_area").show();
                $("#pro_list_showdiv").html('<ul class="l_styles" style="margin-top:0;"><li><a href="javascript:void(0)" id="program_list_pic_list_loadbtn" class="current"><span class="tw_icon" title="' + getLanguageMsg("图形列表", $.cookie("yuyan")) + '"></span></a></li>'
                    + '<li><a href="javascript:void(0)" id="program_list_tab_list_loadbtn"><span class="lb_icon" title="' + getLanguageMsg("详细信息", $.cookie("yuyan")) + '"></span></a></li></ul>');
            }
            else {
                $("#page_top").hide();
                $(".pos_area").hide();
                if ($("#program_list_hid_type").val() == 5) {
                    $("#pro_list_showdiv").html('<ul class="l_styles" style="margin-top:0;"><li><a href="javascript:void(0)" id="program_list_pic_list_loadbtn" class="current"><span class="tw_icon" title="' + getLanguageMsg("图形列表", $.cookie("yuyan")) + '"></span></a></li>'
                    + '<li><a href="javascript:void(0)" id="program_list_tab_list_loadbtn"><span class="lb_icon" title="' + getLanguageMsg("详细信息", $.cookie("yuyan")) + '"></span></a></li></ul>');
                }
                else {
                    $("#pro_list_showdiv").html('<span style="display: inline-block; height: 22px; border: 1px solid rgb(203, 203, 203); line-height: 22px;">'
                        + '<a style="display: block;color: #5ac0ee;font-size: 12px;background: url(../images/icon_jia.png) no-repeat 8px center;padding-left: 25px; padding-right: 8px;" href="javascript:void(0)" onclick="pro_closelistBox()">' + getLanguageMsg("关闭窗口", $.cookie("yuyan")) + '</a></span>'
                        + '<span style="display: inline-block;height: 22px;border: 1px solid #cbcbcb;line-height:22px; margin-left:12px;"><a style="display: block;color: #5ac0ee;font-size: 12px;background: url(../images/icon_jia.png) no-repeat 8px center;padding-left: 25px; padding-right: 8px;" href="javascript:void(0)" id="prolist_seladd">' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '</a></span>'
                        + '<ul class="l_styles" style="margin-top:0;"><li><a href="javascript:void(0)" id="program_list_pic_list_loadbtn" class="current"><span class="tw_icon" title="' + getLanguageMsg("图形列表", $.cookie("yuyan")) + '"></span></a></li>'
                        + '<li><a href="javascript:void(0)" id="program_list_tab_list_loadbtn"><span class="lb_icon" title="' + getLanguageMsg("详细信息", $.cookie("yuyan")) + '"></span></a></li></ul>');
                }
            }
            //加载分组信息
            $.ajax({
                type: 'post',
                url: '/company/source/ajax/getgroupinfo.ashx',
                data: { "grouptype": "2" },
                async: true,
                dataType: 'text',
                success: function (data) {
                    var json = eval("(" + data + ")");
                    var html = "<option value='0'>" + getLanguageMsg("请选择分组", $.cookie("yuyan")) + "</option>";
                    var childlist;
                    $.each(json.child, function (idx, item) {
                        if (item.groupflag == 1) {
                            html += '<option value="' + item.classifyid + '" disabled="">' + item.classifyname + '</option>';
                        }
                        else {
                            html += '<option value="' + item.classifyid + '">' + item.classifyname + '</option>';
                        }
                        childlist = item.child;
                        $.each(childlist, function (idx, item) {
                            if (item.groupflag == 1) {
                                html += '<option value="' + item.classifyid + '" disabled="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                            }
                            else {
                                html += '<option value="' + item.classifyid + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                            }
                            var childlist2 = item.child;
                            $.each(childlist2, function (idx, item) {
                                if (item.groupflag == 1) {
                                    html += '<option value="' + item.classifyid + '" disabled="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                                }
                                else {
                                    html += '<option value="' + item.classifyid + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                                }
                            });
                        });
                    });
                    $("#program_list_search_group").html(html);
                }
            })
            /************三种数据源点击事件*************/
            $("#program_list_btn_ml").click(function () {
                if ($("#program_list_show").val() == "0") {
                    $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                        $("#program_data_piclist").fadeIn();
                    })
                }
                else {
                    $("#program_data_tablist").load("/company/program/program_tablist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                        $("#cl_data_tablist").fadeIn();
                    })
                }
                $(this).parent().addClass("current");
                $(this).parent().siblings("li").removeClass("current");
            });
            $("#program_list_btn_ls").click(function () {
                if ($("#program_list_show").val() == "0") {
                    $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 1, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                        $("#program_data_piclist").fadeIn();
                    })
                }
                else {
                    $("#program_data_tablist").load("/company/program/program_tablist.aspx", { "sd": 1, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                        $("#program_data_tablist").fadeIn();
                    })
                }
                $(this).parent().addClass("current");
                $(this).parent().siblings("li").removeClass("current");
            });
            $("#program_list_btn_cy").click(function () {
                if ($("#program_list_show").val() == "0") {
                    $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                        $("#program_data_piclist").fadeIn();
                    })
                }
                else {
                    $("#program_data_tablist").load("/company/program/program_tablist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                        $("#program_data_tablist").fadeIn();
                    })
                }
                $(this).parent().addClass("current");
                $(this).parent().siblings("li").removeClass("current");
            });
            /************三种数据源点击事件结束*************/
            //页面加载时 默认加载缩略图视图
            $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#program_list_hid_type").val() }, function () {
                $("#program_data_piclist").fadeIn();
            })
            /**切换显示类型**********************/
            $("#program_list_pic_list_loadbtn").die().live("click", function () {
                var sn = "";
                if ($("#program_list_search_sn").val() != ""&&$("#program_list_search_sn").val() != undefined) {
                    sn = $("#program_list_search_sn").val();
                }
                var un = "";
                if ($("#program_list_search_un").val() != "" && $("#program_list_search_un").val() != undefined) {
                    un = $("#program_list_search_un").val();
                }
                var cd = "";
               
                if (new Date($("#program_list_search_cd").val()) != "Invalid Date") {
                    cd = $("#program_list_search_cd").val();
                }
                if (new Date($("#program_list_search_cd2").val()) != "Invalid Date") {
                    cd = cd + "&" + $("#program_list_search_cd2").val();
                }


                //if ($("#program_list_search_sn").val() != "节目单名称") {
                //    sn = $("#program_list_search_sn").val();
                //}
                //var un = "";
                //if ($("#program_list_search_un").val() != "操作员") {
                //    un = $("#program_list_search_un").val();
                //}
                //var cd = "";
                //if ($("#program_list_search_cd").val() != "选择开始日期") {
                //    cd = $("#program_list_search_cd").val();
                //}
                //if ($("#program_list_search_cd2").val() != "选择结束日期") {
                //    cd = cd + "&" + $("#program_list_search_cd2").val();
                //}
                
                var key = sn + "|" + un + "|" + cd;
                key = key + "|" + $("#program_list_hid_checkstatus").val() + "|" + $("#program_list_hid_status").val() + "|" + $("#program_list_hid_rs").val();
                key = key + "|" + $("#program_list_hid_isown").val() + "|1|" + $("#program_list_hid_dr").val() + "|" + $("#program_list_search_group").val() + "|" + $("#program_list_hid_isfiled").val();
                $("#program_list_show").val("0");
                $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "key": key, "t": $("#program_list_hid_type").val() }, function () {
                    $("#program_data_tablist").hide().empty();
                    $("#program_data_piclist").fadeIn();
                })
                $(this).addClass("current");
                $("#program_list_tab_list_loadbtn").removeClass("current");
            });
            $("#program_list_tab_list_loadbtn").die().live("click", function () {

                var sn = "";
                if ($("#program_list_search_sn").val() != "" && $("#program_list_search_sn").val() != undefined) {
                    sn = $("#program_list_search_sn").val();
                }
                var un = "";
                if ($("#program_list_search_un").val() != "" && $("#program_list_search_un").val() != undefined) {
                    un = $("#program_list_search_un").val();
                }
                var cd = "";

                if (new Date($("#program_list_search_cd").val()) != "Invalid Date") {
                    cd = $("#program_list_search_cd").val();
                }
                if (new Date($("#program_list_search_cd2").val()) != "Invalid Date") {
                    cd = cd + "&" + $("#program_list_search_cd2").val();
                }
                var key = sn + "|" + un + "|" + cd;
                key = key + "|" + $("#program_list_hid_checkstatus").val() + "|" + $("#program_list_hid_status").val() + "|" + $("#program_list_hid_rs").val();
                key = key + "|" + $("#program_list_hid_isown").val() + "|1|" + $("#program_list_hid_dr").val() + "|" + $("#program_list_search_group").val() + "|" + $("#program_list_hid_isfiled").val();

                $("#program_list_show").val("1");

                $("#program_data_tablist").load("/company/program/program_tablist.aspx", { "sd": 0, "of": 6, "sort": 1, "key": key, "t": $("#program_list_hid_type").val() }, function () {
                    $("#program_data_piclist").hide().empty();
                    $("#program_data_tablist").fadeIn();
                })

                $(this).addClass("current");
                $("#program_list_pic_list_loadbtn").removeClass("current");
            });
            $.ajax({
                type: 'post',
                url: '/company/source/ajax/getrslist.ashx',
                async: true,
                dataType: 'text',
                success: function (data) {
                    var json = eval("(" + data + ")");
                    $.each(json.Table, function (idx, item) {
                        if (item.resolution != "4:3" && item.resolution != "3:4" && item.resolution != "16:9" && item.resolution != "9:16" && item.resolution != "16:10" && item.resolution != "10:16" && item.resolution != "5:4" && item.resolution != "4:5") {
                            $("#program_list_rs_more").append('<dd><a class="sel_item" href="javascript:void(0)" name="sc_list_resolution"  data-value="' + item.resolution + '" >' + item.resolution + '</a></dd>');
                        }
                    })
                }
            })

            /*搜索框及按钮效果************************************/
            //$("#program_list_search_sn").focus(function () {
            //    if ($(this).val() == "节目单名称") {
            //        $(this).val("");
            //    }
            //});
            //$("#program_list_search_sn").blur(function () {
            //    if ($(this).val() == "") {
            //        $(this).val("节目单名称");
            //    }
            //});
            //$("#program_list_search_un").focus(function () {
            //    if ($(this).val() == "操作员") {
            //        $(this).val("");
            //    }
            //});
            //$("#program_list_search_un").blur(function () {
            //    if ($(this).val() == "") {
            //        $(this).val("操作员");
            //    }
            //});
            debugger;
            switchLanguage("#zyyProgramListContainer", 1, "program_list.aspx");
        })


        /*************搜索条件开始********************************/
        //1.审核状态
        $(".sel_item[name=program_list_checkstatus]").die().live("click", function () {
            if ($("#program_list_hid_checkstatus").val() != $(this).attr("data-value")) {
                //$(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                $("#program_list_hid_checkstatus").val($(this).attr("data-value"));
                $(".sel_item[name=program_list_checkstatus]").removeClass("current");
                $(this).addClass("current");
                program_list_search();
            }
        });
        //2.是否只查看自己的（以后台授权为准）
        $(".sel_item[name=program_list_isshowown]").die().live("click", function () {
            if ($("#program_list_hid_isown").val() == "0") {
                $(this).addClass("current");
                $("#program_list_hid_isown").val("1");
            }
            else {
                $(this).removeClass("current");
                $("#program_list_hid_isown").val("0");
            }
            program_list_search();
        });
        //3.引用状态
        $(".sel_item[name=program_list_status]").die().live("click", function () {
            if ($("#program_list_hid_status").val() != $(this).attr("data-value")) {
                $(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                $("#program_list_hid_status").val($(this).attr("data-value"));
                program_list_search();
            }
        });
        //是否归档
        $(".sel_item[name=program_list_isfiled]").die().live("click", function () {
            if ($("#program_list_hid_isfiled").val() != $(this).attr("data-value")) {
                $(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                $("#program_list_hid_isfiled").val($(this).attr("data-value"));
                program_list_search();
            }
        });
        //4.分辨率
        $(".sel_item[name=program_list_resolution]").die().live("click", function () {

            if ($(this).attr("data-value") == "") {
                if ($("#program_list_hid_rs").val() != "") {
                    $("#program_list_hid_rs").val("");
                    $(".sel_item[name=program_list_resolution]").removeClass("current");
                    $(this).addClass("current");
                }
            }
            else {

                if ($("#program_list_hid_rs").val() != "") {
                    if ($("#program_list_hid_rs").val().indexOf($(this).attr("data-value")) >= 0) {
                        $(this).removeClass("current");
                        $("#program_list_hid_rs").val($("#program_list_hid_rs").val().replace($(this).attr("data-value") + ",", ""));
                    }
                    else {
                        $("#program_list_hid_rs").val($("#program_list_hid_rs").val() + $(this).attr("data-value") + ",");
                        $(this).addClass("current");
                    }

                }
                else {
                    $("#program_list_hid_rs").val($("#program_list_hid_rs").val() + $(this).attr("data-value") + ",");
                    $(".sel_item[name=program_list_resolution]").removeClass("current");
                    $(this).addClass("current");
                }
            }
            if ($("#program_list_hid_rs").val() == "") { $(".sel_item[name=program_list_resolution][data-value='']").addClass("current"); }
            program_list_search();
        });
        //5:时间范围
        $(".sel_item[name=program_list_dr]").die().live("click", function () {
            if ($("#program_list_hid_dr").val() != $(this).attr("data-value")) {
                $(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                $("#program_list_hid_dr").val($(this).attr("data-value"));
                program_list_search();
            }
        });
        function program_list_search() {
            var sn = "";
            if ($("#program_list_search_sn").val() != "" && $("#program_list_search_sn").val() != undefined) {
                sn = $("#program_list_search_sn").val();
            }
            var un = "";
            if ($("#program_list_search_un").val() != "" && $("#program_list_search_un").val() != undefined) {
                un = $("#program_list_search_un").val();
            }
            var cd = "";

            if (new Date($("#program_list_search_cd").val()) != "Invalid Date") {
                cd = $("#program_list_search_cd").val();
            }
            if (new Date($("#program_list_search_cd2").val()) != "Invalid Date") {
                cd = cd + "&" + $("#program_list_search_cd2").val();
            }
            //if ($("#program_list_search_sn").val() != "节目单名称") {
            //    sn = $("#program_list_search_sn").val();
            //}
            //var un = "";
            //if ($("#program_list_search_un").val() != "操作员") {
            //    un = $("#program_list_search_un").val();
            //}
            //var cd = "";
            //if ($("#program_list_search_cd").val() != "选择开始日期") {
            //        cd = $("#program_list_search_cd").val();
            //}
            //if ($("#program_list_search_cd2").val() != "选择结束日期") {
            //    cd = cd + "&" + $("#program_list_search_cd2").val();
            //}
            var key = sn + "|" + un + "|" + cd;
            key = key + "|" + $("#program_list_hid_checkstatus").val() + "|" + $("#program_list_hid_status").val() + "|" + $("#program_list_hid_rs").val();
            key = key + "|" + $("#program_list_hid_isown").val() + "|1|" + $("#program_list_hid_dr").val() + "|" + $("#program_list_search_group").val() + "|" + $("#program_list_hid_isfiled").val();
            //$("#program_list_hid_status").val()//查询条件|拼接：最后一个 应该是‘归档’//150,175,320 $("#program_list_hid_isfiled").val()

            if ($("#program_list_show").val() == "1") {
                $("#program_data_tablist").load("/company/program/program_tablist.aspx", { "sd": 0, "sort": 1, "of": 6, "key": key, "t": $("#program_list_hid_type").val() }, function () {
                    $("#program_data_tablist").fadeIn();
                })
            }
            else {
                $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "key": key, "t": $("#program_list_hid_type").val() }, function () {
                    $("#program_data_piclist").fadeIn();
                    $("#program_data_tablist").fadeOut();
                })
            }
        }
        function program_main_del(itemid) {
            showDeleteProgramTopTrip(itemid);
        }
        //删除操作
        $("a[name=btn_deleteProgram]").die().live("click", function () {
            if ($(this).attr("data-type") == 0) {
                $("#" + $(this).attr("data-id")).animate({ top: -60 }, 200, function () {
                    $('#' + $(this).attr("data-id")).remove();
                });
            }
            else {
                var itemid = $(this).attr("data-itemid");
                var newId = $(this).attr("data-id");
                $.ajax({
                    type: 'post',
                    url: 'ajax/deleteProgram.ashx',
                    async: false,
                    data: {
                        type: $(this).attr("data-type"),
                        id: itemid
                    },
                    dataType: 'text',
                    success: function (data) {
                        $("#" + newId).animate({ top: -60 }, 200, function () {
                            $('#' + newId).remove();
                        });
                        if (data=="-1") {
                            LoginTimeOut();
                        } else if (data=="-100") {
                            //归档节目单，
                        } else if (data == "-200") {//节目单在终端/组上
                            TopTrip(getLanguageMsg("节目单有终端引用，不能删除", $.cookie("yuyan")), 3);
                        } else {
                            $(".mod_sclist[data-itemid=" + itemid + "]").remove();
                            $("#program_tab_list tr[data-itemid=" + itemid + "]").remove();
                        }
                        
                    }
                })
            }
        });
        //归档
        function filedProgram(itemid) {
            $.ajax({
                type: 'post',
                url: 'ajax/FiledProgram.ashx',
                async: false,
                data: {
                    id: itemid
                },
                dataType: 'text',
                success: function (data) {
                    if (parseInt(data) > 0) {
                        TopTrip(getLanguageMsg("归档成功", $.cookie("yuyan")), 1);
                    }
                }
            })
        }
        $("#prolist_seladd").die().live("click", function () {
            var selectidlist = "";
            var selectnamelist = "";
            $("input[name=program_tab_list_check]:checked").each(function () {
                selectidlist = selectidlist + $(this).val() + ","
                selectnamelist = selectnamelist + $(this).parent("td").parent("tr").attr("data-itemname");
            })
            clientmenu_add(selectidlist, selectnamelist);
        });
        function pro_closelistBox() {
            $("#overlay").fadeOut();
            $("#clientmenu_add_menu_list").fadeOut();
        }
        $("select[name=program_sel_status]").die().live("change", function () {
            var itemid = $(this).attr("data-itemid");
            var sel = $(this).val();
            var result = "";
            ShowCheckItemTrip(2, itemid,sel);//无论审核 是否通过，都可以填写原因。。whq3.7
            //if (sel == "0") {
            //    ShowCheckItemTrip(2, itemid);
            //}
            //else {
            //    $.ajax({
            //        type: 'post',
            //        url: '/company/program/ajax/checkitem.ashx',
            //        async: false,
            //        data: {
            //            id: itemid,
            //            status: sel,
            //            reason: ""
            //        },
            //        dataType: 'text',
            //        success: function (data) {
            //            if (data > 0) {
            //                TopTrip("审核完成！", 1);
            //            }
            //            else {
            //                TopTrip("审核失败，请与管理员联系！", 3);
            //            }
            //        }
            //    })
            //}
        })
        $("#sel_check_item").die().live("change", function () {
            var boxId = $(this).attr("data-id");
            var itemid = $(this).attr("data-itemid");
            var itemtype = $(this).attr("data-itemtype");
            var sel = $(this).val();
            //无论审核 是否通过，都可以填写原因。。whq3.7
            //if ($(this).val() == "0") {
            //    $(this).parent().parent().next("div").show();
            //}
            //else {
            //    $(this).parent().parent().next("div").hide();
            //}
        });
        $("#btn_cancheckitem").die().live("click", function () {
            var boxId = $(this).attr("data-id");
            $("#" + boxId).hide();
        });
        $("#btn_checkitem").die().live("click", function () {
            var boxId = $(this).attr("data-id");
            var itemid = $(this).attr("data-itemid");
            var itemtype = $(this).attr("data-itemtype");
            var sel = $("#sel_check_item").val();
            var itemstatus = $(this).attr("data-checkstatus");
            if (itemstatus == "1") {
                sel = "1";
            }
            $.ajax({
                type: 'post',
                url: '/company/program/ajax/checkitem.ashx',
                async: false,
                data: {
                    id: itemid,
                    status: sel,
                    reason: $("#text_checkreason").val()
                },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        $("#" + boxId).hide();
                        TopTrip("审核完成！", 1);

                    } else if (data == "-100") {////节目单已归档，  节目项不能修改。
                        $("#" + boxId).hide();
                        TopTrip(getLanguageMsg("节目单已归档，节目项不能修改！", $.cookie("yuyan")), 2);
                    }
                    else {
                        $("#" + boxId).hide();
                        TopTrip(getLanguageMsg("审核失败，请与管理员联系！", $.cookie("yuyan")), 3);

                    }
                }
            })
        })
        function showProgramQuote(itemid, itemname) {
            $("#overlay").fadeIn();
            $("#program_quote").load("program_quote.aspx", { "id": itemid, "name": itemname }, function () {
                $("#program_quote").slideDown();
            });
        }
        //function add_tanchu() {
        //    $.ajax
        //   ({
        //        type: 'post',
        //        url: 'ajax/saveprogram.ashx',
        //        async: true,
        //        dataType: 'html',//script
        //        data: { "program_add_name": $("#program_add_name1").val(), "program_add_width": $("#program_add_width1").val(), "program_add_height": $("#program_add_height1").val(), "program_add_descript": $("#program_add_descript1").val(),"program_add_recommend":$("#program_add_recommend1").val(),"program_add_group":$("#program_add_group1").val()},
        //        success: function (data) {
        //            eval(data);
        //        }
        //    })
        //}
        function ClearProgramListHtml1() {
            $("#program_add_programlist").html("");
            $("#div_program_list").html("");
        }
        function program_add_loadList() {
            ClearProgramListHtml1();
            $("#program_add_programlist").load("program_list.aspx", { "t": 5 }, function () {
                $("#program_add_programlist").slideDown();
            });
        }
        var mySort = 1;
        // 节目单列表  排序方法  //按‘修改时间’排序
        $("#p_list_sort").live("click", function () {
            $(this).children("i").toggleClass("active");
            if ($("#p_list_sort").children("i").hasClass("active")) {
                mySort = 0;//升序
            } else {
                mySort = 1;//降序
            }
            if ($("#program_list_show").val() == "0") {
                $("#program_data_piclist").load("/company/program/program_piclist.aspx", { "sd": 0, "of": 6, "sort": mySort, "t": $("#program_list_hid_type").val() }, function () {
                    $("#program_data_piclist").fadeIn();
                })
            }
            else {
                $("#program_data_tablist").load("/company/program/program_tablist.aspx", { "sd": 0, "of": 6, "sort": mySort, "t": $("#program_list_hid_type").val() }, function () {
                    $("#cl_data_tablist").fadeIn();
                })
            }
            $(this).parent().addClass("current");
            $(this).parent().siblings("li").removeClass("current");

        })
        //滚动翻页
        $(window).scroll(function () {
            debugger;
            var totalheight = $(document).height() - 20;
            var scorllheight = $(this).scrollTop() + $(this).height();
            if (scorllheight >= totalheight) {
                if ($("#program_list_show").val() == "0") { program_list_pic_shownext(); }
            }
        });
    </script>
</head>
<body>
    <form id="program_list" runat="server">
        <div id="page_top">
            <!-- #include file="/common/top.html" -->
        </div>
        <div id="dialog" style="padding: 0;">
    </div>
        <div id="overlay" style="display: none"></div>
        <input type="hidden" id="program_list_hid_type" runat="server" />
        <%--<input type="hidden" id="isSelfCheck" value="" runat="server" />--%>
        <input type="hidden" id="checkIDs" value="" runat="server" />
        <input type="hidden" id="arrangeIDs" value="" runat="server" />
        <div class="container clearfix" id="zyyProgramListContainer">
            <div class="pos_area clearfix">
                <div class="pos"><a href="program_list.aspx?t=0" class="language">节目单管理</a>&gt;<a class="current language" href="program_list.aspx?t=0">节目单列表</a></div>
                <div class="editbtn">
                    <div class="source_edit">
                        <span class="add_icon"><a href="program_add.aspx?t=0" title="添加节目单" class="md-trigger btn-primary btn-sm" data-modal="modal-1"><b style="padding-left:20px;background:url(/images/tubiao.png) -254px -127px;"></b><span class="language">添加节目单</span></a></span>
                    </div>
                </div>
            </div>
            <div class="source_con">
                <div class="sc_search">
                    <ul class="clearfix">
                        <li>
                            <input class="inp_t language" placeholder="节目单名称" value="" id="program_list_search_sn" type="text" autocomplete="off"/></li>
                        <li>
                            <input class="inp_t language" placeholder="操作员" value="" id="program_list_search_un" type="text" autocomplete="off"/></li>
                        <li>
                            <input class="inp_t date_icon language" placeholder="选择开始日期" id="program_list_search_cd" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd',maxDate:new Date() })" autocomplete="off" type="text"/><span class="date_icon"></span>

                        </li>
                       <li>
                            <input class="inp_t date_icon language" placeholder="选择结束日期" id="program_list_search_cd2" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd',maxDate:new Date() })" autocomplete="off" type="text"/><span class="date_icon"></span>

                       </li>
                         <li>
                            <select class="inp_t" style="height: 24px;" id="program_list_search_group"></select><span class="select_icon"></span></li>
                        <li>
                            <input class="inp_s" value="" type="button" onclick="program_list_search()"/></li>

                    </ul>
                </div>
                <div class="sc_select_attr">
                    <input type="hidden" id="program_list_hid_checkstatus" value="" />
                    <input type="hidden" id="program_list_hid_isown" value="0" />
                    <input type="hidden" id="program_list_hid_isfiled" value="" />
                    <dl class="clearfix">
                        <dt class="language">审核状态：<%--<input type="hidden" id="Hidden1" value="" />--%></dt>
                        <dd><a class="sel_item current language" name="program_list_checkstatus" href="javascript:void(0)" data-value="">全部</a></dd>
                        <dd><a class="sel_item language" name="program_list_checkstatus" href="javascript:void(0)" data-value="0">未通过</a></dd>
                        <dd><a class="sel_item language" name="program_list_checkstatus" href="javascript:void(0)" data-value="1">已通过</a></dd>
                        
                        <dt class="language">查看自节目单：<%--<input type="hidden" id="Hidden1" value="0" />--%></dt>
                        <dd><a class="sel_item language" name="program_list_isshowown" href="javascript:void(0)" data-value="0">只查看我自己的</a></dd>
                    </dl>
                    <dl class="clearfix"><input type="hidden" id="program_list_hid_status" value="" />
                        
                        <dt class="language">是否归档：<%--<input type="hidden" id="program_list_hid_isfiled" value="" />--%></dt>
                            <dd><a class="sel_item current language" href="javascript:void(0)" name="program_list_isfiled" data-value="">全部</a></dd>
                            <dd><a class="sel_item language" href="javascript:void(0)" name="program_list_isfiled" data-value="1">归档</a></dd>
                            <dd><a class="sel_item language" href="javascript:void(0)" name="program_list_isfiled" data-value="0">未归档</a></dd>
                    </dl>
                    <div class="sc_select_nocommon language" >
                        更多筛选
                    </div>
                    <div style="display:none" class="no_common_content">
                        <input type="hidden" id="program_list_hid_rs" value="" />
                    <dl class="clearfix">
                        <dt class="language">分辨率：<%--<input type="hidden" id="Hidden1" value="" />--%></dt>
                        <dd><a class="sel_item current language" href="javascript:void(0)" name="program_list_resolution" data-value="">全部</a></dd>
                        <dd>
                            <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="4:3">4:3</a></dd>
                        <dd>
                            <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="3:4">3:4</a>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="16:9">16:9</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="9:16">9:16</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="16:10">16:10</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="10:16">10:16</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="4:5">4:5</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="program_list_resolution" data-value="5:4">5:4</a></dd>
                            <%--                  <dd>
                                <div class="showallbtn"><a href="javascript:void(0)" id="program_list_rs_show">更多</a></div>
                            </dd>--%>
                            <div style="width: 890px; float: right; margin-top: 10px; display: none;" id="sc_list_rs_more"></div>
                    </dl>
                    <dl class="clearfix">
                        <input type="hidden" id="program_list_hid_dr" value="" />
                        <dt class="language">时间范围：<%--<input type="hidden" id="Hidden1" value="" />--%></dt>
                        <dd><a class="sel_item current language" href="javascript:void(0)" name="program_list_dr" data-value="">全部</a></dd>
                        <dd>
                            <a class="sel_item language" href="javascript:void(0)" name="program_list_dr" data-value="1">最近一天</a></dd>
                        <dd>
                            <a class="sel_item language" href="javascript:void(0)" name="program_list_dr" data-value="3">最近三天</a></dd>
                        <dd>
                            <a class="sel_item language" href="javascript:void(0)" name="program_list_dr" data-value="7">最近一周</a></dd>
                        <dd>
                            <a class="sel_item language" href="javascript:void(0)" name="program_list_dr" data-value="30">最近一月</a></dd>
                    </dl>
                    </div>
                </div>
                <div class="sc_list_box">
                    <div class="title clearfix">
                        <ul class="bt clearfix">
                            <li class="current"><a href="javascript:void(0)" id="program_list_btn_ml" class="language">节目单列表</a></li>
                            <li><a href="javascript:void(0)" id="program_list_btn_ls" class="language">历史浏览</a></li>
                            <li><a href="javascript:void(0)" id="program_list_btn_cy" class="language">常用推荐</a></li>
                            <li><a href="javascript:void(0)" id="p_list_sort" class="language">时间排序<i></i></a></li>
                        </ul>
                        <input type="hidden" id="program_list_show" value="0">
                        <div style="width: 270px; float: right; margin-right: 10px; height: 40px; line-height: 40px;" id="pro_list_showdiv">
                        </div>
                         
                    </div>
                </div>
                <div class="sc_result" id="program_data_tablist" style="display: none"></div>
                <div class="sc_result" id="program_data_piclist" style="display: none"></div>
            </div>
        </div>
        <div id="program_quote" style="position: fixed; width: 640px; height: 400px; left: 50%; top: 50%; margin-left: -320px; margin-top: -200px; background: #fff; border: 1px solid #ddd; display: none; z-index: 2229;"></div>
    </form>
     <%--<div>
<div class="md-modal md-effect-1" id="modal-1">
    <div class="md-content" style="background:#cce2ec;">
      <h3>添加节目单</h3>
      <div id="add_jiemu">
          <table>
              <tr>
                  <td>节目单名称：</td>
                   <td><input type="text" datatype="*"  errormsg="*" nullmsg="*" id="program_add_name1" name="program_add_name"/><tt>*</tt></td>
              </tr>
              <tr>
                  <td>节目单组：</td>
                   <td><select id="program_add_group1" name="program_add_group"></select></td>
              </tr>
              <tr>
                  <td>对应屏幕宽度(像素)：</td>
                   <td><input id="program_add_width1" name="program_add_width" type="text"/></td>
              </tr>
              <tr>
                  <td>对应屏幕高度(像素)：</td>
                   <td><input id="program_add_height1" name="program_add_height" type="text"/></td>
              </tr>
              <tr>
                  <td>描述：</td>
                   <td>
                     <div>
                        <textarea id="program_add_descript1" name="program_add_descript" style="height:80px;width:250px;"></textarea>
                    </div>
                   </td>
              </tr>
              <tr>
                  <td>推荐度：</td>
                   <td><input id="program_add_recommend1" name="program_add_recommend" value="30" type="text"/></td>
              </tr>
              <tr>
                  <td> <button onclick="add_tanchu()">保存</button></td>
                   <td><button class="md-close btn-sm btn-primary">Close me!</button></td>
              </tr>
          </table>
           
      </div>
    </div>
  </div>
   <div class="md-overlay"></div>
</div>--%>
</body>
   <%-- <script src="/js/modalEffects.js"></script>
    <script src="/js/classie.js"></script>--%>
</html>
