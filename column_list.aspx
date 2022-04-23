<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_list.aspx.cs" Inherits="Web.company.column.column_list" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-首页</title>
    <link href="/css/style.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/mxjfunction.js"></script>
    <script type="text/javascript">
        $(function () {
            //显示更多筛选条件， 点击变样式
            var show_list = new Mxjfn();
            show_list.showItem(".sc_select_nocommon");
            //alert($("#sc_list_show").val());
            //调用点击回车 搜索功能 
            var keydown = new Mxjfn();
            keydown.key_home(".inp_s", "13");
            //whq //点击菜单，更新导航条
            var colType = window.location.search;//1 栏目审核2 栏目编排 3栏目编排审核
            if (colType != "" && colType.split('t=').length>1) {
                var myType = colType.split('t=')[1];
                var aLink = $(".pos a:eq(1)");
                if (myType.indexOf("1")>=0) {//colType.split('t=')[1].indexOf("1")
                    aLink.attr("href", "column_list.aspx?t=1").html("栏目审核");
                } else if (myType.indexOf("2") >= 0) {
                    aLink.attr("href", "column_list.aspx?t=2").html("栏目编排");
                } else if (myType.indexOf("3") >= 0) {
                    aLink.attr("href", "column_list.aspx?t=3").html("栏目编排审核");
                }
            }
            /**加载分组信息开始*********************************************/
            $.ajax({
                type: 'post',
                url: '/company/source/ajax/getgroupinfo.ashx',
                data: { "grouptype": "1" },
                async: true,
                dataType: 'text',
                success: function (data) {
                    var json = eval("(" + data + ")");
                    var html = "<option value='0'>请选择分组</option>";
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
                    $("#cl_list_search_group").html(html);
                }
            })
            /**加载分组信息结束*********************************************/
            /************三种数据源点击事件*************/
            $("#cl_list_btn_ml").click(function () {
                if ($("#cl_list_show").val() == "0") {
                    $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                        $("#cl_data_piclist").fadeIn();
                    })
                }
                else {
                    $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                        $("#cl_data_tablist").fadeIn();
                    })
                }
                $(this).parent().addClass("current");
                $(this).parent().siblings("li").removeClass("current");
            });
            $("#cl_list_btn_ls").click(function () {
                if ($("#cl_list_show").val() == "0") {
                    $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 1, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                        $("#cl_data_piclist").fadeIn();
                    })
                }
                else {
                    $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 1, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                        $("#cl_data_tablist").fadeIn();
                    })
                }
                $(this).parent().addClass("current");
                $(this).parent().siblings("li").removeClass("current");
            });
            $("#cl_list_btn_cy").click(function () {
                if ($("#cl_list_show").val() == "0") {
                    $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                        $("#cl_data_piclist").fadeIn();
                    })
                }
                else {
                    $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                        $("#cl_data_tablist").fadeIn();
                    })
                }
                $(this).parent().addClass("current");
                $(this).parent().siblings("li").removeClass("current");
            });
            if ($("#column_list_hid_type").val() <= 3) {
                $("#page_top").show();
                $(".pos_area").show();
                $("#columnlist_showdiv").html('<ul class="l_styles" style="margin-top:0;"><li><a href="javascript:void(0)" id="cl_list_pic_list_loadbtn" class="current"><span class="tw_icon" title="图形列表"></span></a></li><li><a href="javascript:void(0)" id="cl_list_tab_list_loadbtn"><span class="lb_icon" title="详细信息"></span></a></li></ul>');
            }
            else {
                $("#page_top").hide();
                $(".pos_area").hide();
                if ($("#column_list_hid_type").val() == 5) {
                    $("#columnlist_showdiv").html('<ul class="l_styles" style="margin-top:0;"><li><a href="javascript:void(0)" id="cl_list_pic_list_loadbtn" class="current"><span class="tw_icon" title="图形列表"></span></a></li><li><a href="javascript:void(0)" id="cl_list_tab_list_loadbtn"><span class="lb_icon" title="详细信息"></span></a></li></ul>');
                }
                else {
                    $("#columnlist_showdiv").html('<span style="display: inline-block; height: 22px; border: 1px solid rgb(203, 203, 203); line-height: 22px;"><a style="display: block;color: #5ac0ee;font-size: 12px;background: url(../images/icon_jia.png) no-repeat 8px center;padding-left: 25px; padding-right: 8px;" href="javascript:void(0)" onclick="columnlist_closelistBox()">关闭窗口</a></span><span style="display: inline-block;height: 22px;border: 1px solid #cbcbcb;line-height:22px; margin-left:12px;"><a style="display: block;color: #5ac0ee;font-size: 12px;background: url(../images/icon_jia.png) no-repeat 8px center;padding-left: 25px; padding-right: 8px;" href="javascript:void(0)" id="columnlist_seladd">添加到节目单</a></span><ul class="l_styles" style="margin-top:0;"><li><a href="javascript:void(0)" id="cl_list_pic_list_loadbtn" class="current"><span class="tw_icon" title="图形列表"></span></a></li><li><a href="javascript:void(0)" id="cl_list_tab_list_loadbtn"><span class="lb_icon" title="详细信息"></span></a></li></ul>');
                }
            }
            $("#columnlist_seladd").click(function () {
                var itemid = "";
                var itemname = "";
                var itemthumb = "";
                var itemtype = "";
                var contenttype = "";
                var sourceid = "";
                $("#cl_tab_list input[name='cl_tab_list_check']:checked").each(function () {
                    itemid = itemid + $(this).val() + ",";
                    itemname = itemname + $(this).parent("td").attr("data-itemname") + ",";
                    contenttype = contenttype + $(this).parent("td").attr("data-contentype") + ",";
                    itemthumb = itemthumb + $(this).parent("td").attr("data-thumb") + ",";
                    itemtype = itemtype + $(this).parent("td").attr("data-itemtype") + ",";
                    sourceid = sourceid + $(this).parent("td").attr("data-sourceid") + ",";
                });
                if (itemid.length > 0) {
                    itemid = itemid.substring(0, itemid.length - 1);
                    var itemidlist = itemid.split(",");
                    for (var i = 0; i < itemidlist.length; i++) {
                        addsourcetoMenu(itemidlist[i], itemthumb.split(",")[i], itemname.split(",")[i], contenttype.split(",")[i], sourceid.split(",")[i], itemtype.split(",")[i]);
                    }
                }
            });
            /************三种数据源点击事件结束*************/
            //页面加载时 默认加载缩略图视图
            //$("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 0, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
            //    $("#cl_data_piclist").fadeIn();
            //})
            if ($("#cl_list_show").val() == "0") {//点击tab列表，，刷新页面， 继续显示tab列表 视图。
                $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_piclist").fadeIn();
                    $("#cl_data_tablist").fadeOut();
                });
            }
            else {

                $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 0, "sort": 1, "of": 6, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_tablist").fadeIn();
                });
            }
            /**切换显示类型**********************/
            $("#cl_list_pic_list_loadbtn").die().live("click", function () {
                var sn = "";
                if ($("#cl_list_search_sn").val() != "栏目名称") {
                    sn = $("#cl_list_search_sn").val();
                }
                var un = "";
                if ($("#cl_list_search_un").val() != "操作员") {
                    un = $("#cl_list_search_un").val();
                }
                var cd = "";
                if ($("#cl_list_search_cd").val() != "选择开始日期") {
                    cd = $("#cl_list_search_cd").val();
                }
                if ($("#cl_list_search_cd2").val() != "选择结束日期") {
                    cd = cd + "&" + $("#cl_list_search_cd2").val();
                }
                
                var key = sn + "|" + un + "|" + cd;
                key = key + "|" + $("#cl_list_hid_checkstatus").val() + "|" + $("#cl_list_hid_status").val() + "|" + $("#cl_list_hid_rs").val();
                key = key + "|" + $("#cl_list_hid_isown").val() + "|1|" + $("#cl_list_hid_dr").val() + "|" + $("#cl_list_search_group").val() + "|" + $("#cl_list_hid_isfiled").val();
                $("#cl_list_show").val("0");
                //$("#column_list_hid_type").val("0");
                $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "key": key, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_tablist").hide().empty();
                    $("#cl_data_piclist").fadeIn();
                })
                $(this).addClass("current");
                $("#cl_list_tab_list_loadbtn").removeClass("current");
            });
            $("#cl_list_tab_list_loadbtn").die().live("click", function () {

                var sn = "";
                if ($("#cl_list_search_sn").val() != "栏目名称") {
                    sn = $("#cl_list_search_sn").val();
                }
                var un = "";
                if ($("#cl_list_search_un").val() != "操作员") {
                    un = $("#cl_list_search_un").val();
                }
                var cd = "";
                if ($("#cl_list_search_cd").val() != "选择开始日期") {
                    cd = $("#cl_list_search_cd").val();
                }
                if ($("#cl_list_search_cd2").val() != "选择结束日期") {
                    cd = cd + "&" + $("#cl_list_search_cd2").val();
                }
              

                var key = sn + "|" + un + "|" + cd;
                key = key + "|" + $("#cl_list_hid_checkstatus").val() + "|" + $("#cl_list_hid_status").val() + "|" + $("#cl_list_hid_rs").val();
                key = key + "|" + $("#cl_list_hid_isown").val() + "|1|" + $("#cl_list_hid_dr").val() + "|" + $("#cl_list_search_group").val() + "|" + $("#cl_list_hid_isfiled").val();

                $("#cl_list_show").val("1");

                //$("#column_list_hid_type").val("1");
                $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 0, "of": 6, "sort": 1, "key": key, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_piclist").hide().empty();
                    $("#cl_data_tablist").fadeIn();
                })
                $(this).addClass("current");
                $("#cl_list_pic_list_loadbtn").removeClass("current");
            });
            /**切换显示结束**********************/
            //加载分辨率数据
            $.ajax({
                type: 'post',
                url: '/company/source/ajax/getrslist.ashx',
                async: true,
                dataType: 'text',
                success: function (data) {
                    var json = eval("(" + data + ")");
                    var mydd = ""; var fla = 1;
                    $.each(json.Table, function (idx, item) {
                        if (item.resolution != "4:3" && item.resolution != "3:4" && item.resolution != "16:9" && item.resolution != "" && item.resolution != "9:16" && item.resolution != "16:10" && item.resolution != "10:16" && item.resolution != "5:4" && item.resolution != "4:5" && item.resolution != "1:1") {
                            mydd = '<dd style="left;top;"><a class="sel_item" href="javascript:void(0)" name="cl_list_resolution"  data-value="' + item.resolution + '" >' + item.resolution + '</a></dd>';
                            if (parseInt(fla) == 4) {
                                //mydd = mydd.replace("left;", "margin-left: 160px;").replace("top;", "margin-top: 5px;");//whq..更多分辨率，显示样式。
                                mydd = mydd.replace("left;", "margin-left: 0px;").replace("top;", "margin-top: 0px;");//whq..更多分辨率，显示样式。
                            } else if (parseInt(fla) < 4) {
                                mydd = mydd.replace("top;", "").replace("left;", "");
                            }
                            else {
                                mydd = mydd.replace("left;", "").replace("top;", "margin-top: 5px;");
                            }
                            fla = parseInt(fla) + 1;
                            $("#cl_list_rs_more").append(mydd);
                        }
                    })
                }
            })
            ////显示更多分辨率
            //$("#cl_list_rs_show").click(function () {
            //    if ($(this).text() == "更多") {
            //        $(this).text("收起")
            //        $("#cl_list_rs_more").slideDown();
            //    }
            //    else {
            //        $(this).text("更多")
            //        $("#cl_list_rs_more").slideUp();
            //    }
            //});
            /*搜索框及按钮效果************************************/
            $("#cl_list_search_sn").focus(function () {
                if ($(this).val() == "栏目名称") {
                    $(this).val("");
                }
            });
            $("#cl_list_search_sn").blur(function () {
                if ($(this).val() == "") {
                    $(this).val("栏目名称");
                }
            });
            $("#cl_list_search_un").focus(function () {
                if ($(this).val() == "操作员") {
                    $(this).val("");
                }
            });
            $("#cl_list_search_un").blur(function () {
                if ($(this).val() == "") {
                    $(this).val("操作员");
                }
            });
            //页面加载时让所有的全部按钮默认为选中状态
            $(".sel_item[data-value='']").addClass("current");
            /*************搜索条件开始,tzy修改重写********************************/
            //1.审核状态
            $(".sel_item[name=cl_list_checkstatus]").die().live("click", function () {
                if ($("#cl_list_hid_checkstatus").val() != $(this).attr("data-value")) {
                    $(".sel_item[name=cl_list_checkstatus]").removeClass("current");
                    $(this).addClass("current");
                    $("#cl_list_hid_checkstatus").val($(this).attr("data-value"));
                    cl_list_search();
                }
            });
            //2.是否只查看自己的（以后台授权为准）
            $(".sel_item[name=cl_list_isshowown]").die().live("click", function () {
                if ($("#cl_list_hid_isown").val() == "0") {
                    $(this).addClass("current");
                    $("#cl_list_hid_isown").val("1");
                }
                else {
                    $(this).removeClass("current");
                    $("#cl_list_hid_isown").val("0");
                }
                cl_list_search();
            });
            //3.引用状态
            $(".sel_item[name=cl_list_status]").die().live("click", function () {
                if ($("#cl_list_hid_status").val() != $(this).attr("data-value")) {                 
                    $(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                    $("#cl_list_hid_status").val($(this).attr("data-value"));
                    cl_list_search();
                }
            });
            //是否归档
            $(".sel_item[name=cl_list_isfiled]").die().live("click", function () {
                if ($("#cl_list_hid_isfiled").val() != $(this).attr("data-value")) {                
                    $(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                    $("#cl_list_hid_isfiled").val($(this).attr("data-value"));
                    cl_list_search();
                }
            });
            //4.分辨率
            $(".sel_item[name=cl_list_resolution]").die().live("click", function () {
                if ($(this).attr("data-value") == "") {
                    if ($("#cl_list_hid_rs").val() != "") {
                        $("#cl_list_hid_rs").val("");
                        $(".sel_item[name=cl_list_resolution]").removeClass("current");//#div_column_list 
                        $(this).addClass("current");
                    }
                }
                else {
                    if ($("#cl_list_hid_rs").val() != "") {
                        if ($("#cl_list_hid_rs").val().indexOf($(this).attr("data-value")) >= 0) {
                            $(this).removeClass("current");
                            $("#cl_list_hid_rs").val($("#cl_list_hid_rs").val().replace($(this).attr("data-value") + ",", ""));
                        }
                        else {
                            $("#cl_list_hid_rs").val($("#cl_list_hid_rs").val() + $(this).attr("data-value") + ",");//分辨率 ：多选。
                           // $(".sel_item[name=cl_list_resolution]").removeClass("current");
                            $(this).addClass("current");
                        }
                    }
                    else {
                        $("#cl_list_hid_rs").val($("#cl_list_hid_rs").val() + $(this).attr("data-value") + ",");
                        $(".sel_item[name=cl_list_resolution]").removeClass("current");//#div_column_list 
                        $(this).addClass("current");
                    }
                }
                if ($("#cl_list_hid_rs").val() == "") { $(".sel_item[name=cl_list_resolution][data-value='']").addClass("current"); }
                cl_list_search();
            });
            //5:时间范围
            $(".sel_item[name=cl_list_dr]").die().live("click", function () {
                if ($("#cl_list_hid_dr").val() != $(this).attr("data-value")) {
                    $(this).addClass("current").parent().siblings("dd").children(".sel_item").removeClass("current");
                    $("#cl_list_hid_dr").val($(this).attr("data-value"));
                    cl_list_search();
                }
            });

        })
        function cl_list_search() {
            var sn = "";
            if ($("#cl_list_search_sn").val() != "栏目名称") {
                sn = $("#cl_list_search_sn").val();
            }
            var un = "";
            if ($("#cl_list_search_un").val() != "操作员") {
                un = $("#cl_list_search_un").val();
            }
            var cd = "";
            if ($("#cl_list_search_cd").val() != "选择开始日期") {
                cd = $("#cl_list_search_cd").val();
            }
            if ($("#cl_list_search_cd2").val() != "选择结束日期") {
                cd = cd + "&" + $("#cl_list_search_cd2").val();
            }
            var key = sn + "|" + un + "|" + cd;
            key = key + "|" + $("#cl_list_hid_checkstatus").val() + "|" + $("#cl_list_hid_status").val() + "|" + $("#cl_list_hid_rs").val();// + "|"
            key = key + "|" + $("#cl_list_hid_isown").val() + "|1|" + $("#cl_list_hid_dr").val() + "|" + $("#cl_list_search_group").val() + "|" + $("#cl_list_hid_isfiled").val();
            //alert($("#cl_list_show").val() + ", " + $("#column_list_hid_type").val());
            if ($("#cl_list_show").val() == "0") {
                $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 6, "sort": 1, "key": key, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_piclist").fadeIn();
                    $("#cl_data_tablist").fadeOut();
                });
            }
            else {
                
                $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 0, "sort": 1, "of":6, "key": key, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_tablist").fadeIn();
                });
            }
        }
        //关闭选择栏目窗口
        function columnlist_closelistBox() {
            $("#program_arrange_column_list").html("").slideUp();
            program_arrange_load_h_sourcelist();
        }
        //$("a[name=addcolumnMenu]").die().live("click", function () {
        //    var itemid, itemname, contentype, sourceid, thumb, itemtype;
        //    if ($("#cl_list_show").val() == "0") {
        //        itemid = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-itemid");
        //        itemname = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-itemname");
        //        contentype = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-contenttype");
        //        sourceid = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-sourceid");
        //        thumb = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-thumb");
        //        itemtype = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-itemtype");
        //    }
        //    else {
        //        itemid = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-itemid");
        //        itemname = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-itemname");
        //        contentype = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-contentype");
        //        sourceid = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-sourceid");
        //        thumb = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-thumb");
        //        itemtype = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-itemtype");
        //    }
        //    if ($("#column_list_hid_type").val() == 4) {
        //        addsourcetoMenu(itemid, thumb, itemname, contentype, sourceid, itemtype);
        //    }
        //})


        //删除操作
        $("a[name=btn_deleteColumn]").die().live("click", function () {
            var selectElement = $("[name='cl_tab_list_check']:checked");
            var itemIDs = "";
            var itemIDs = [];
            if (selectElement.length > 0) {//批量删除8.10
                $.each(selectElement, function (i, item) {
                    itemIDs.push(item.value);

                })
            }
            else {
                itemIDs.push($(this).attr("data-itemid"));
            }
            itemIDs = itemIDs.toString();
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
                    url: '/company/column/ajax/deleteColumn.ashx',
                    async: false,
                    data: {
                        type: $(this).attr("data-type"),
                        id: itemIDs
                    },
                    dataType: 'text',
                    success: function (data) {
                        //$(".mod_sclist[data-itemid=" + itemid + "]").remove();
                        $("#" + newId).animate({ top: -60 }, 200, function () {
                            $('#' + newId).remove();
                        });
                        //刷新页面
                       // window.location.reload();
                        if ($("#cl_list_show").val() == "0") {
                            $("#cl_list_pic_list_loadbtn").click();
                        } else {
                            $("#cl_list_tab_list_loadbtn").click();
                        }
                        //var pageUrl = window.location.href;
                        //if (pageUrl.indexOf("?") > 0) {
                        //    //window.location.href = pageUrl + "&st=" + $("#cl_list_show").val();//$("#column_list_hid_type").val()
                        //} else {
                        //    //window.location.href = pageUrl + "?st=" + $("#cl_list_show").val();
                        //}
                        //$("#column_list_hid_type").val($("#cl_list_show").val());
                    }
                })
            }
        });
        //归档
        function filedColumn(itemid) {
            $.ajax({
                type: 'post',
                url: '/company/column/ajax/FiledColumn.ashx',
                async: false,
                data: {
                    id: itemid
                },
                dataType: 'text',
                success: function (data) {
                    if (parseInt(data) > 0) {
                        TopTrip("归档成功", 1);
                    }
                }
            })
        }
        function loadColumnQuote(itemid, itemname) {
            $("#overlay").fadeIn();
            $("#column_quote").load("column_quote.aspx", { "id": itemid, "name": itemname }, function () {
                $("#column_quote").slideDown();
            });
        }
        $("select[name=column_sel_status]").live("change", function () {
            var itemid = $(this).attr("data-itemid");
            var sel = $(this).val();
            var result = "";
            ShowCheckItemTrip(2, itemid,sel);//无论审核 是否通过，都可以填写原因。。whq3.7
            //if (sel == "0") {
            //    ShowCheckItemTrip(1, itemid);
            //}
            //else {
            //    $.ajax({
            //        type: 'post',
            //        url: '/company/column/ajax/checkitem.ashx',
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
                url: '/company/column/ajax/checkitem.ashx',
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
                        //window.location.reload();
                    }
                    else {
                        $("#" + boxId).hide();
                        TopTrip("审核失败，请与管理员联系！", 3);

                    }
                }
            })
        });
        var mySort = 1;
        // 栏目列表  排序方法  //按‘修改时间’排序
        $("#cl_list_sort").live("click", function () {
            $(this).children("i").toggleClass("active");
            if ($("#cl_list_sort").children("i").hasClass("active")) {
                mySort = 0;//升序
            } else {
                mySort = 1;//降序
            }
            if ($("#cl_list_show").val() == "0") {
                $("#cl_data_piclist").load("column_piclist.aspx", { "sd": 0, "of": 6, "sort": mySort, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_piclist").fadeIn();
                })
            }
            else {
                $("#cl_data_tablist").load("column_tablist.aspx", { "sd": 0, "of": 6, "sort": mySort, "t": $("#column_list_hid_type").val() }, function () {
                    $("#cl_data_tablist").fadeIn();
                })
            }
            $(this).parent().addClass("current");
            $(this).parent().siblings("li").removeClass("current");
        })
        window.onload = function () {
            var picShow = $("#cl_data_piclist");
            var tabShow = $("#cl_data_tablist");//alert(picShow.css("display"));
            if (picShow.css("display") == "none") { $("#cl_list_pic_list_loadbtn").removeClass("current"); $("#cl_list_tab_list_loadbtn").addClass("current"); }
            if (tabShow.css("display") == "none") { $("#cl_list_tab_list_loadbtn").removeClass("current"); $("#cl_list_pic_list_loadbtn").addClass("current"); }
        }
        function cl_list_pic_shownext() {
            $("#cl_list_pic_qy_page").val(parseInt($("#cl_list_pic_qy_page").val(), 10) + 1);
            cl_list_pic_getdata();
        }
        //滚动翻页
        $(window).scroll(function () {
            var totalheight = $(document).height() - 20;
            var scorllheight = $(this).scrollTop() + $(this).height();
            if (scorllheight >= totalheight) {
                if ($("#cl_list_show").val() == "0") { cl_list_pic_shownext(); }
            }
        });
    </script>
    <style>
       .clearfix input[type=text]::-ms-clear {
          display:none
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="page_top">
            <!-- #include file="/common/top.html" -->
        </div>
        <div id="overlay" style="display: none"></div>
        <input type="hidden" id="column_list_hid_type" runat="server" />

        <%--<input type="hidden" id="isSelfCheck" value="" runat="server" />--%>
        <input type="hidden" id="checkIDs" value="" runat="server" />
        <input type="hidden" id="arrangeIDs" value="" runat="server" />

        <div class="container clearfix">
            <div class="pos_area clearfix">
                <div class="pos"><a href="column_list.aspx?t=0">栏目管理</a>&gt;<a class="current" href="column_list.aspx?t=0">栏目列表</a></div>
                <div class="editbtn">
                    <div class="source_edit">
                        <span class="add_icon"><a href="/company/column/column_add.aspx" title="添加栏目"><b  style="padding-left:20px;background:url(/images/tubiao.png) -254px -128px;"></b>添加栏目</a></span>
                    </div>
                </div>
            </div>
            <div class="source_con">
                <div class="sc_search">
                    <ul class="clearfix">
                        <li>
                            <input class="inp_t" value="栏目名称" type="text" id="cl_list_search_sn" autocomplete="off"/></li>
                        <li>
                            <input class="inp_t" value="操作员" type="text" id="cl_list_search_un" autocomplete="off"/></li>
                        <li>
                           <input class="inp_t date_icon" value="选择开始日期" type="text" id="cl_list_search_cd" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd', maxDate: new Date() })" autocomplete="off"/><span class="date_icon"></span>

                        </li>
                        <li>
                            <input class="inp_t date_icon" value="选择结束日期" type="text" id="cl_list_search_cd2" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd', maxDate: new Date() })" autocomplete="off"/><span class="date_icon"></span>

                        </li>
                        <li>
                            <select class="inp_t" style="height: 24px;" id="cl_list_search_group"></select><span class="select_icon"></span></li>
                        <li>
                            <input class="inp_s" value="" type="button" onclick="cl_list_search()"/></li>
                    </ul>
                </div>
                <div class="sc_select_attr">
                    <dl class="clearfix">
                        <dt>审核状态：<input type="hidden" id="cl_list_hid_checkstatus" value="" /></dt>
                        <dd><a class="sel_item" name="cl_list_checkstatus" href="javascript:void(0)" data-value="">全部</a></dd>
                        <dd><a class="sel_item" name="cl_list_checkstatus" href="javascript:void(0)" data-value="0">未通过</a></dd>
                        <dd><a class="sel_item" name="cl_list_checkstatus" href="javascript:void(0)" data-value="1">已通过</a></dd>
                        <dt>查看自栏目：<input type="hidden" id="cl_list_hid_isown" value="0" /></dt>
                        <dd><a class="sel_item" name="cl_list_isshowown" href="javascript:void(0)" data-value="0">只查看我自己的</a></dd>
                    </dl>
                    <dl class="clearfix">
                        <input type="hidden" id="cl_list_hid_status" value="" />
                        <dt>是否归档：<input type="hidden" id="cl_list_hid_isfiled" value="" /></dt>
                        <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_isfiled" data-value="">全部</a></dd>
                            <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_isfiled" data-value="1">归档</a></dd>
                            <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_isfiled" data-value="0">未归档</a></dd>
                    </dl>
                    <%--归档、引用状态：影响-显示。1.分开：归档、引用状态；2.点击之后，清空 另一个值。 --%>
                    <%--<dl class="clearfix">
                        <dt>是否归档：<input type="hidden" id="cl_list_hid_isfiled" value="" /></dt>
                            <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_isfiled" data-value="1">归档</a></dd>
                            <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_isfiled" data-value="0">未归档</a></dd>
                    </dl>--%> 
                    <div class="sc_select_nocommon" >
                        更多筛选
                    </div>
                    <div style="display:none" class="no_common_content">
                        <dl class="clearfix" id="cl_list_rs_more">
                            <dt>分辨率：<input type="hidden" id="cl_list_hid_rs" value="" /></dt>
                            <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="">全部</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="4:3">4:3</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="3:4">3:4</a></dd>
                                <dd>
                                    <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="16:9">16:9</a></dd>
                                <dd>
                                    <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="9:16">9:16</a></dd>
                                <dd>
                                    <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="16:10">16:10</a></dd>
                                <dd>
                                    <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="10:16">10:16</a></dd>
                                <dd>
                                    <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="4:5">4:5</a></dd>
                                <dd>
                                    <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="5:4">5:4</a></dd>
                              <!--  <dd>
                                    <div class="showallbtn"><a href="javascript:void(0)" id="cl_list_rs_show">更多</a></div>
                                </dd>-->
                                <dd>
                                     <a class="sel_item" href="javascript:void(0)" name="cl_list_resolution" data-value="1:1">1:1</a>
                                </dd>
                                <!--<div style="width: 890px; float: right; margin-top: 10px; display: none;" id="cl_list_rs_more"></div>-->
                        </dl>
                        <dl class="clearfix">
                            <dt>时间范围：<input type="hidden" id="cl_list_hid_dr" value="" /></dt>
                            <dd><a class="sel_item" href="javascript:void(0)" name="cl_list_dr" data-value="">全部</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="cl_list_dr" data-value="1">最近一天</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="cl_list_dr" data-value="3">最近三天</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="cl_list_dr" data-value="7">最近一周</a></dd>
                            <dd>
                                <a class="sel_item" href="javascript:void(0)" name="cl_list_dr" data-value="30">最近一月</a></dd>
                        </dl>
                    </div>
                </div>
                <div class="sc_list_box">
                    <div class="title clearfix">
                        <ul class="bt clearfix">
                            <li class="current"><a href="javascript:void(0)" id="cl_list_btn_ml">栏目列表</a></li>
                            <li><a href="javascript:void(0)" id="cl_list_btn_ls">历史浏览</a></li>
                            <li><a href="javascript:void(0)" id="cl_list_btn_cy">常用推荐</a></li>
                            <li><a href="javascript:void(0)" id="cl_list_sort">时间排序<i></i></a></li>
                        </ul>
                        <input type="hidden" id="cl_list_show" runat="server" value="0"/>
                        <div style="width: 270px; float: right; margin-right: 10px; height: 40px; line-height: 40px;" id="columnlist_showdiv">
                        </div>
                    </div>
                </div>
                <div class="sc_result" id="cl_data_tablist" style="display: none"></div>
                <div class="sc_result" id="cl_data_piclist" style="display: none"></div>
            </div>
        </div>
        <div id="column_quote" style="position: fixed; width: 640px; height: 400px; left: 50%; top: 50%; margin-left: -320px; margin-top: -200px; background: #fff; border: 1px solid #ddd; display: none; z-index: 1001"></div>
    </form>
</body>
</html>
