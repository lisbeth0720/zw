<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_arrange.aspx.cs" Inherits="Web.company.column.column_arrange" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-栏目编排</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/js/jquery-ui/jquery-ui.css" rel="stylesheet" />
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/jquery-ui/jquery-ui.min.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery.dragsort-0.5.2.min.js"></script>
    <script src="/js/jquery.colorpicker.js"></script>
    <script src="/js/ajaxfileupload.js"></script>
    
    <script src="/js/mxjfunction.js"></script>
    <style>
       /* a#column_arrange_tiejia b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -255px -94px;
            background: url(/images/tubiao.png) -105px -647px;
        }*/
        a#column_arrange_tiejia b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -97px -652px;
            padding: 5px 0 5px 20px;
}
        a#column_arrange_tiejia:hover b {
            background: url(/images/tubiao.png) -97px -711px;
        }


        a#column_arrange_quanping b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -170px -652px;
            padding: 5px 0 5px 20px;
        }

        a#column_arrange_quanping:hover b {
            background: url(/images/tubiao.png) -170px -711px;
        }
        /*没图标，还需修改更换图标*/
        a#column_arrange_jiaru b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -5px -652px;
            padding: 5px 0 5px 20px;
        }

        #column_arrange_jiaru:hover b {
            background: url(/images/tubiao.png) -5px -711px;
        }

        a#column_arrange_gengxin b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -30px -652px;
            padding: 5px 0 5px 20px;
        }

        a#column_arrange_gengxin:hover b {
            background: url(/images/tubiao.png) -30px -711px;
        }

        a#column_arrange_chongfa b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -55px -652px;
            padding: 5px 0 5px 20px;
        }

        a#column_arrange_chongfa:hover b {
            background: url(/images/tubiao.png) -55px -711px;
        }

        a#column_arrange_shenhe b {
            padding-left: 20px;
            background: url(/images/tubiaoa.png) 1px -127px;
        }

        a#column_arrange_shenhe:hover b {
            background: url(/images/tubiaoa.png) 1px -106px;
        }
    </style>
    <script type="text/javascript">
        var t;
        $(function () {
            var w = document.documentElement.clientWidth;
            //$("#columnDiv").css("left", (w - 220) + "px");
            window.onresize = function () {
               // var w = document.documentElement.clientWidth;
                //$("#columnDiv").css("left", (w - 220) + "px");
            }
            $("#columnDiv").css("display", "block");
           
            $("#cl_range_selsclist img").error(function () {//这里暂时为 ,图片的类型为3，图片未加载出来 为其设置缺省属性。其实有些不妥。
                $(this).attr('src', "/images/img_new/default_3_3.png");
            });

            //加载页面 栏目
         
            column_arrange_showbg();
            
            $(".label_value").html($("#column_arrange_clid").val());
            //http://192.168.1.145/company/column/column_arrange.aspx?id=446&name=%E6%A0%8F%E7%9B%AE_1756&type=0
            //http://192.168.1.145/company/column/column_arrange.aspx?id=446&name=%E6%A0%8F%E7%9B%AE_1756&type=1
            if (window.location.search != "" && window.location.search.split('type=')[1] == "1") {
                $(".pos a:eq(1)").attr("href", "column_list.aspx?t=3").html("栏目编排审核");
            }

            if ($("#column_arrange_arrright").val() == 1 && $("#column_arrange_pagetype").val() == 0) {
                $("#column_arrange_topmenu").append('<span class="label">当前栏目：</span><span class="label_value"></span><span class="inp_btn"><a href="javascript:void(0)" onclick="column_arrange_selitem()" title="添加素材" id="column_arrange_tiejia"><b></b>添加素材</a></span>');
                column_arrange_loadsource_h_list();
            }
            if ($("#column_arrange_chright").val() == 1 && $("#column_arrange_pagetype").val() == 1) {
                $("#column_arrange_topmenu").append('<span class="inp_btn"><a href="javascript:void(0)" onclick="column_range_checkall()" title="审核全部" id="column_arrange_shenhe"><b></b>审核全部</a></span>');
            }
            if ($("#column_arrange_pubright").val() == 1 && $("#column_arrange_pagetype").val() == 0) {
                $("#column_arrange_topmenu").append('<span class="inp_btn"><a onclick="column_arrange_sendmenu()" href="javascript:void(0)" title="将栏目加入分发列表" id="column_arrange_jiaru"><b></b>将栏目加入分发列表</a></span><span class="inp_btn"><a onclick="column_arrange_resendmenu(1)" href="javascript:void(0)" title="后台更新栏目" id="column_arrange_gengxin"><b></b>后台更新栏目</a></span><span class="inp_btn"><a href="javascript:void(0)" title="重新分发包含本栏目节目单" onclick="column_arrange_resendmenu(2)" id="column_arrange_chongfa"><b></b>重新分发包含本栏目节目单</a></span>');
            }
            $("#column_arrange_topmenu").append('<span class="inp_btn"><a href="javascript:void(0)" onclick="column_arrange_fullscreen()" title="全屏预览" id="column_arrange_quanping"><b></b>全屏预览</a></span>');
            /**拖动添加操作开始********************************/
            $(".arrange_area").mouseup(function (e) {
                if ($(".clone").length > 0) {
                    var ultop = $(".imglist ul").offset().top;
                    var ulleft = $(".imglist ul").offset().left;
                    if (e.pageX > ulleft && e.pageX < (ulleft + 1000) && e.pageY > ultop && e.pageY < (80 + ultop) && $(".clone").length > 0) {
                        var id = $(".clone").children(".borbg").children(".nr").attr("data-id");
                        var itemname = $(".clone").children(".borbg").children(".nr").attr("data-name");
                        var thumbnail = $(".clone").children(".borbg").children(".nr").attr("data-thumb");
                        var contenttype = $(".clone").children(".borbg").children(".nr").attr("data-conttype");
                        var itemtype = $(".clone").children(".borbg").children(".nr").attr("data-itemtype");
                        $("body").css('cursor', 'auto');
                        $(".clone").remove();
                        $(".placeHolder").remove();
                        addsourcetoColumn(id, thumbnail, itemname, contenttype, itemtype);
                    }
                    $("body").css('cursor', 'auto');
                    $(".clone").remove();

                    $("body").removeClass("no_select");
                }
            });
            $(document).mousemove(function (e) {
                if ($(".clone").length > 0) {
                    $(".clone").css('left', e.pageX - 50);
                    $(".clone").css('top', e.pageY - 220);
                    var ultop = $(".imglist ul").offset().top;
                    var ulleft = $(".imglist ul").offset().left;
                    if (e.pageX > ulleft && e.pageX < (ulleft + 1000) && e.pageY > ultop && e.pageY < (80 + ultop) && $(".placeHolder").length <= 0) {
                        $("#cl_range_selsclist").append("<li class='placeHolder'><div></div></li>");
                    }
                }
            });
            /**拖动添加操作结束********************************/
            /**滚动操作开始********************************/
            $(".next").click(function () {
                var left = parseInt($("#cl_range_selsclist").css("left"));
                if (isNaN(left)) { left = 0;}
                var itemcount = $("#cl_range_selsclist li").length;
                if (itemcount > 8) {
                    if (left > (-1 * (itemcount - 8) * 108)) {
                        $("#cl_range_selsclist").animate({ "left": (left - 108) }, { duration: 200, queue: false });
                    }
                    else {
                        $("#cl_range_selsclist").stop().animate({ "left": (-1 * (itemcount - 7) * 108) }, { duration: 200, queue: false });
                    }
                }
            });
            $(".prev").click(function () {
                var left = parseInt($("#cl_range_selsclist").css("left"));
                if (left < 0) {
                    $("#cl_range_selsclist").animate({ "left": (left + 108) }, { duration: 200, queue: false });
                }
                else {
                    $("#cl_range_selsclist").stop().animate({ "left": 0 }, { duration: 200, queue: false });
                }
            });
            /**滚动操作结束********************************/
            /**拖动排序特效********************************/
            $("#cl_range_selsclist").dragsort({ dragSelector: "li .time", dragBetween: false, placeHolderTemplate: "<li class='placeHolder'><div></div></li>", dragEnd: function () { TopMessage(0) } });
            if ($("#column_arrange_scid").val() != ""){
                var scid = $("#column_arrange_scid").val();
                var tempid = $("#cl_range_selsclist li[data-id=" + scid + "]").attr("data-tempid");
                var contenttype = $("#cl_range_selsclist li[data-id=" + scid + "]").attr("data-contenttype");
                column_arrange_getSouceInfo($("#column_arrange_scid").val(), contenttype, tempid);
            }
        })
        function column_arrange_resendmenu(type) {
            $.ajax({
                type: 'post',
                url: 'ajax/resendmenu.ashx',
                data: {
                    "type": type,
                    "menuid": $("#column_arrange_clid").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    //debugger;
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else {
                        $("#column_arrange_resendresult").load("/cgi-bin/preparefilecgi.cgi?" + data + "&charset=utf-8");
                        setTimeout(function () {
                            if ($("#column_arrange_resendresult").text().indexOf("指令发送成功") > 0) { TopTrip("指令发送成功", 1); }
                        },2000);
                    }
                }
            })
        }
        function column_arrange_sendmenu() {
            $.ajax({
                type: 'post',
                url: 'ajax/sendmenu.ashx',
                data: {
                    "menuid": $("#column_arrange_clid").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else {
                        if (data == 0) {
                            TopTrip("系统错误，请联系管理员！", 3)
                        }
                        if (data > 0) {
                            TopTrip("状态设置完毕！", 1)
                        }
                    }
                }
            })

        }
        function column_range_checkall() {
            if ($("#myColFiled").val()=="1") {
                return;
            }
            //审核所有节目项
            $.ajax({
                type: 'post',
                url: 'ajax/checkmenu.ashx',
                data: {
                    "menuid": $("#column_arrange_clid").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    } else if (data == "-100") {
                        TopTrip("归档栏目，不能修改！", 2);
                    }
                    else {
                        if (data == 0) {
                            TopTrip("栏目未编排，请先编排栏目！", 3)//栏目编排，之后 编排审核。
                            //TopTrip("系统错误，请联系管理员！", 3)
                        }
                        if (data > 0) {
                            TopTrip("所有节目项审核成功！", 1)
                        }
                    }
                }
            })

        }
        function column_arrange_loadsource_h_list() {
            ClearSourceListHtml();
            $("#column_arrange_h_sourcelist").load("/company/source/picSourceList.aspx", { "sd": 1, "of": 0, "sort": 1, "t": 2 }, function () {
                $("#column_arrange_h_sourcelist").fadeIn();
            });
        }
        /**获取模板信息方法结束********************************/
        /**将素材添加到列表方法开始********************************/
        function addsourcetoColumn(id, thumbnail, itemname, contenttype, itemtype) {
            
            if ($("#myColFiled").val() == "1") {
                TopTrip("归档栏目，不能修改！", 2);
                return;
            }
            var Exetask = "";    //复制模板的
            var Myplayer = 0;
            var Param = "";
            var Copyto = 1;
            var Triggertype = 0;
            var Triggertime = "";
            var Duringtime = 3600;
            var Circleeveryday = 0;
            var Circletime = 0;
            var Starttime = "";
            var Expiretime = "";
            var Zorder = 1;
            var Merit = 0;
            var Openflag = 0;
            var Bkpic = "";
            var Options = "";

            $.ajax({
                type: 'post',
                url: 'ajax/AddMenu.ashx',
                data: {
                    "cid": $("#column_arrange_clid").val(),
                    "sid": id,
                    "name": itemname,
                    "tempid": $("#column_arrange_tempid").val(),
                    "itemtype": itemtype,
                    "exetask": Exetask,
                    "myplayer": Myplayer,
                    "param": Param,
                    "copyto": Copyto,
                    "triggertype": Triggertype,
                    "triggertime": Triggertime,
                    "duringtime": Duringtime,
                    "circleeveryday": Circleeveryday,
                    "circletime": Circletime,
                    "starttime": Starttime,
                    "expiretime": Expiretime,
                    "zorder": Zorder,
                    "merit": Merit,
                    "bkpic": Bkpic,
                    "options": Options,
                    "openflag": Openflag,
                    "myIsFiled": $("#myColFiled").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else if (data=="-100") {
                        TopTrip("归档栏目，不能修改", 2);
                    }
                    else {
                        var json = strToJson(data);
                        var myUncheckStr = "";//json.checkstatus  style="background-color: #bab823;"
                        if (json.taskid > 0) {
                            var contenttypestr = ReContentTypeStr(contenttype);
                            var contenttypestr2 = contenttypestr;
                            var myDuringTime = json.duringTime;//3750秒..
                            myDuringTime = sec_to_time(myDuringTime);//"1:2:30"
                            if (json.checkstatus!="1") {
                                myUncheckStr = 'style="background-color: #bab823;"';
                            }
                            $("#cl_range_selsclist li").removeClass("current");//选中新添加的 素材
                            $("#cl_range_selsclist").append('<li  class="current" data-pid="' + json.taskid + '" data-position="' + json.position + '" data-id="'
                                + id + '" data-name="' + itemname + '" data-contenttype="' + contenttype + '" data-tempid="'
                                + $("#column_arrange_tempid").val() + '" data-checkstatus="'
                                + json.checkstatus + '"><a href="javascript:void(0)"  title="[' + contenttypestr2 + ']'+itemname+'">'
                                + '<img src="/images/loading1.gif" height="72" width="96"><span class="time" '+myUncheckStr+'><b style="display: inline-block;width: 20px;height: 20px;position: absolute;left:5px;top:-1px;background: url(/images/tubiaoa.png) repeat scroll -1px -171px"></b>' + myDuringTime + '</span><span class="del"></span></a></li>').click();
                            column_arrange_getthumbnal(json.taskid, thumbnail, contenttype);
                            column_arrange_getSouceInfo(id, contenttype, $("#column_arrange_tempid").val());//加载 新添加素材的预览页面。。。
                            $("#cl_range_selsclist").dragsort({ dragSelector: "li .time", dragBetween: false, placeHolderTemplate: "<li class='placeHolder'><div></div></li>" });

                        }
                    }
                }
            })
        }
        //秒数 转换为 时分秒 //3750秒.."1:2:30"
        var sec_to_time = function (s) {
            var t;
            if (s > -1) {
                var hour = Math.floor(s / 3600);
                var min = Math.floor(s / 60) % 60;
                var sec = s % 60;
                t = hour + ":";
                t += min + ":";
                t += sec;//.toFixed(2);
            }
            return t;
        }
        function column_arrange_getthumbnal(taskid, thumbnail, contenttype) {
            $.ajax({
                type: 'post',
                url: '/company/ajax/getthumbnnail.ashx',
                async: true,
                data: {
                    imgname: thumbnail,
                    st: 3,//原来为5
                    t: contenttype
                },
                dataType: 'text',
                success: function (data) {
                    $("#cl_range_selsclist li[data-pid=" + taskid + "]").children("a").children("img").attr("src", data);
                }
            });
        }
        //根据素材类型返回素材类型文本
        function ReContentTypeStr(contenttype) {
            var contenttypestr = "未知类型";
            if (contenttype == 0) {
                contenttypestr = "自适应文件";
            }
            if (contenttype == 1) {
                contenttypestr = "文本";
            } if (contenttype == 2) {
                contenttypestr = "网页";
            } if (contenttype == 3) {
                contenttypestr = "图片";
            } if (contenttype == 4) {
                contenttypestr = "通知(静态)";
            } if (contenttype == 5) {
                contenttypestr = "通知(向上滚动文本)";
            } if (contenttype == 6) {
                contenttypestr = "字幕(向左滚动文本)";
            } if (contenttype == 7) {
                contenttypestr = "动画";
            } if (contenttype == 8) {
                contenttypestr = "Office文稿";
            } if (contenttype == 9) {
                contenttypestr = "音频";
            } if (contenttype == 10) {
                contenttypestr = "视频文件/网络视频/电视";
            } if (contenttype == 11) {
                contenttypestr = "操作系统自检测";
            } if (contenttype == 12) {
                contenttypestr = "专用应用程序";
            } if (contenttype == 13) {
                contenttypestr = "远程命令";
            }//专用文件传输 whq..8.24
            if (contenttype == 14) {
                contenttypestr = "专用文件传输";
            }
            if (contenttype == 15) {
                contenttypestr = "栏目";
            }
            //if (contenttype == 14) {
            //    contenttypestr = "栏目";
            //}
            return contenttypestr;
        }
        //删除节目项 按钮
        $("#cl_range_selsclist li a .del").live("click", function (event) {
            if ($("#myColFiled").val()=="1") {
                TopTrip("归档栏目，不能修改！", 2); return false;
            }
            var parentliObj = $(this).parent().parent();
            var taskid = parentliObj.attr("data-pid");
            $.ajax({
                type: 'post',
                url: 'ajax/delmenu.ashx',
                data: {
                    "menuid": $("#column_arrange_clid").val(),
                    "taskid": taskid,
                    "myIsFiled": $("#myColFiled").val()
                },
                async: false,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else if (data == "-100") {
                        TopTrip("归档栏目，不能修改！", 2);
                    }
                    else if (data > 0) {
                        //删除时，判断如果当前被选中状态，就向前移动1个，tzy
                        if (parentliObj.attr("class").indexOf("current") >= 0) {
                            //只有一个 节目项，删除了
                            if ($("#cl_range_selsclist li").length == 1) {
                                document.getElementById("column_addrange_mainframe").setAttribute("src", "column_arrange_frame.html");
                                //document.getElementById("column_addrange_mainframe").contentWindow.document.body.innerHTML = "";
                            }
                            //如果删除的不是第1个元素就向前选择，反之向后选择，tzy
                            if (parentliObj.prev("li").html() == null) {
                                parentliObj.next("li").click();
                            } else {
                                parentliObj.prev("li").click();
                            }
                        }
                        parentliObj.remove();
                    }
                    else {
                        TopTrip("系统错误，请联系管理员！", 3);
                    }
                }
            });
            event.stopPropagation();//会触发li 的click事件  //阻止事件冒泡
            //return false;
        });
        /**将素材添加到列表方法结束********************************/
        /**将素材列表预览点击事件开始********************************/
        $("#cl_range_selsclist li").live("click", function () {
            var myCheckStatus = $(this).attr("data-checkstatus");
            $(this).addClass("current").siblings("li").attr("data-ishsow", 0).removeClass("current");
            var taskid = $(this).attr("data-pid");
            var sourceid = $(this).attr("data-id");
            var sourcename = $(this).attr("data-name");
            var contenttype = $(this).attr("data-contenttype");
            var tempid = $(this).attr("data-tempid");
            var position = $(this).attr("data-position");
            $("#column_arrange_scid").val(sourceid);

            column_arrange_getSouceInfo(sourceid, contenttype, tempid);
            //$("#column_arrange_edititem_box").load("/company/program/edit_program_menu.aspx", { "taskid": taskid, "position": position, "itemname": sourcename, "menuid": $("#column_arrange_clid").val(), "itemid": sourceid, "checkstatus": myCheckStatus, "type": $("#column_arrange_pagetype").val(), }, function () {//和节目单编排，使用同一个页面。。。。todo......
            if ($("#h_edit_column_tid").val() != taskid) { //没有点击同一个节目项
                $("#column_arrange_edititem_box").html("");//重新加载 节目项
            }
            //编辑节目项 页面，不重复加载
            if ($("#column_arrange_edititem_box").text().length > 100 && $("#column_arrange_edititem_box").css("display") == "none") {
                $("#column_arrange_edititem_box").css("display", "block");
            } else if ($("#column_arrange_edititem_box").text().length < 100) {
                $("#column_arrange_edititem_box").load("edit_column_sc.aspx", { "taskid": taskid, "sid": sourceid, "sname": sourcename, "menuid": $("#column_arrange_clid").val(), "position": position, "checkstatus": myCheckStatus, "type": $("#column_arrange_pagetype").val() }, function () {
                    $("#column_arrange_edititem_box").slideDown();//编辑框下拉
                    // 获得到cookie 触发下拉
                    //if ($.cookie("ColumnArrSlide") == "0") {//如果cookie 为0 触发click   下拉
                    //    $("#edit_menu_add_ex").trigger("click");
                    //}
                });
            }
        });
        
        /**将素材列表预览点击事件结束********************************/
        function column_arrange_changeros() {
            if ($("#myColFiled").val() == "1") {////栏目归档, 
                TopTrip("归档栏目，不能修改！", 2);
                return false;
            }
            var scid = $("#column_arrange_scid").val();
            width = parseInt($("#column_arrange_fbl_width").val(), 10);
            height = parseInt($("#column_arrange_fbl_height").val(), 10);
            if (width > 960) {
                height = 950 * height / width;
                width = 960;
            }
            if (height > 440) {
                width = 440 * width / height;
                height = 440;
            }
            $.cookie("PreviewRos", width + "|" + height, { expires: 7 });
            $("#column_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": -width / 2, "margin-top": -height / 2 });
        }
        function column_arrange_resetros() {
            if ($("#myColFiled").val() == "1") {//栏目归档, 
                //TopTrip("归档栏目，不能修改！", 2);
                return;
            } else {
                width = 960;
                height = 440;
                $("#column_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": -width / 2, "margin-top": -height / 2 });
            }
        }
        $("input[name=column_arrange_fbl_radio]").live("click", function () {
            if ($("#myColFiled").val() == "1") {////栏目归档, 
                TopTrip("归档栏目，不能修改！", 2);
                return false;
            }
            //var scid = $("#column_arrange_scid").val();
            var width = parseInt($(this).val().split("×")[0], 10);
            var height = parseInt($(this).val().split("×")[1], 10);

            if (height > width) {
                if (height > 560) {
                    width = 560 * width / height;
                    height = 560;
                }
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }
                $("#column_arrange_area_bg").parent().animate({ "height": height + 40 });
            }
            else {
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }
                if (height > 440) {

                    width = 440 * width / height;
                    height = 440;
                }
                $("#column_arrange_area_bg").parent().animate({ "height": 480 });
            }
            $("#column_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": (-1 * width / 2) + "px", "margin-top": (-1 * height / 2) + "px" });


        });
        //拷贝节目单编排 预览效果
        function column_arrange_showbg() {
            console.log("进入预览");
            var width = 960;
            var height = 440;
            if ($("#column_arrange_area_bg_width").val() != "0" && $("#column_arrange_area_bg_width").val() != "" && $("#column_arrange_area_bg_height").val() != "0" && $("#column_arrange_area_bg_height").val() != "") {
                width = parseInt($("#column_arrange_area_bg_width").val(), 10);
                height = parseInt($("#column_arrange_area_bg_height").val(), 10);
            }
            if (height > width) {
                if (height > 560) {
                    width = 560 * width / height;
                    height = 560;
                }
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }
                $("#column_arrange_area_bg").parent().animate({ "height": height + 20 });
            }
            else {
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }
                if (height > 440) {

                    width = 440 * width / height;
                    height = 440;
                }
                //$("#column_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": (-1 * width / 2) + "px", "margin-top": (-1 * height / 2) + "px" });
            }

            $("#column_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": (-1 * width / 2) + "px", "margin-top": (-1 * height / 2) + "px" });

        }

        /**分辨率预览事件结束********************************/
        $("#column_arrange_sourcelist .mod_sclist .nr").die().live("mousedown", function (e) {//鼠标按下，鼠标变移动标志，克隆元素，并确定新克隆元素位置
            $("body").append('<div class="mod_sclist clone">' + $(this).parent().parent(".mod_sclist").html() + '</div>');
            $(".clone .borbg").css({ "background": "#ccc" });
            $("body").css('cursor', 'move');
            $(".clone").css('left', e.pageX - 50);
            $(".clone").css('top', e.pageY - 220);
            $("#column_arrange_sourcelist").addClass("no_select");
        });
        ///**获取素材信息方法开始********************************/
        function column_arrange_getSouceInfo(scid, contenttype, tempid) {
            $("#column_addrange_mainframe").attr("src", "FilePreview.aspx?itemid=" + scid + "&templateid=" + tempid + "&desript=&t=" + new Date().getTime());
        }
        /**获取素材信息方法结束********************************/
        $("a[name=savemenuposition]").live("click", function () {
            if ($("#myColFiled").val()=="1") {
                TopTrip("归档栏目，不能修改！", 2); return false;
            }
            var type = $(this).attr("data-type");
            var newId = $(this).attr("data-id");
            if (type == 0) {
                var data = $("#cl_range_selsclist li").map(function () { return $(this).attr("data-pid"); }).get();
                $.ajax({
                    type: 'post',
                    url: 'ajax/saveposition.ashx',
                    async: false,
                    data: {
                        "idlist": "" + data + "",
                        "menuid": $("#column_arrange_clid").val(),
                    },
                    dataType: 'text',
                    success: function (data) {
                        if (data == 1) {
                            $("#" + newId).animate({ top: -60 }, 200, function () {
                                $("#" + newId).remove();
                            })
                        }
                    }
                })
            }
        });
        /**展示素材信息方法结束********************************/
        $(function () {
            //创建弹出窗口
            jQuery("#content_dialog").dialog({
                autoOpen: false,
                closeText: "关闭",
                close: function () {
                    $("#content_dialog").html("");
                    $("#closeWindow").hide();
                },

                buttons: {
                    "刷新": function () {
                        $("#content_dialog").load("/common/sourcelist.aspx", { "t": 2 });
                    //},
                    //"关闭": function () {
                    //    $("#content_dialog").dialog("close");
                    //    $("#content_dialog").html("");
                    }
                },
                width: 770,
                height: 600,
                resizable: true,
                title: "添加素材",
                stack: true,
                appendTo: "body"
            });
            /*$("#content_dialog").scroll(function () {
                debugger;
                var totalheight = $(this).children().height() - 50;////这样不行 children().height()是15
                totalheight = $(document).height()-50;//-20
                var scorllheight = $(this).scrollTop() + $(this).height();
               // $("#ui-id-1").html(totalheight + "|" + scorllheight);
                if (scorllheight >= totalheight) {
                    sc_list_pic_shownext();
                }
            });*/

        });
        //绑定每一个素材的拖拽事件
        $(".mod_sclist").die().live("mouseover", function () {
            $(this).draggable({
                helper: "clone",
                appendTo: "#mark",
                opacity: 0.7,
                revert: "invalid",
                drag: function () {
                    $("#mark").show().height($(window).height());
                },
                stop: function () {
                    $("#mark").hide();
                }
            });
        });
        //绑定拖拽目标IFrame
        $("#column_addrange_mainframe").die().live("mouseover", function () {
            $(this).droppable({
                drop: function (event, ui) {
                    var itemid = ui.draggable.find(".nr").attr("data-sourceid");
                    var itemname = ui.draggable.find(".nr").attr("data-name");
                    var thumbnail = ui.draggable.find(".nr").attr("data-thumb");
                    var contenttype = ui.draggable.find(".nr").attr("data-contenttype");
                    var itemtype = ui.draggable.find(".nr").attr("data-itemtype");

                    addsourcetoColumn(itemid, thumbnail, itemname, contenttype, itemtype);
                    //$(document.getElementById(ifrid).contentWindow.document.body).append(ui.draggable.prop("outerHTML"));

                },
                activeClass: "ui-state-default",
                hoverClass: "ui-state-hover",
                accept: ".mod_sclist"

            });
        });
        //绑定拖拽目标下方素材列表
        $(".small_area li").die().live("mouseover", function () {
            $(this).droppable({
                drop: function (event, ui) {
                    var itemid = ui.draggable.find(".nr").attr("data-sourceid");
                    var itemname = ui.draggable.find(".nr").attr("data-name");
                    var thumbnail = ui.draggable.find(".nr").attr("data-thumb");
                    var contenttype = ui.draggable.find(".nr").attr("data-contenttype");
                    var itemtype = ui.draggable.find(".nr").attr("data-itemtype");
                    addsourcetoColumn(itemid, thumbnail, itemname, contenttype, itemtype);
                },
                activeClass: "ui-state-default",
                hoverClass: "ui-state-hover",
                accept: ".mod_sclist"
            });
        });
        function column_arrange_selitem() {
            ClearSourceListHtml();
            $("#content_dialog").load("/common/sourcelist.aspx", { "t": 2 });
            //8/4mxj
            $("#content_dialog").dialog("open");
            $("#closeWindow").show();
            setTimeout(function () { //7/31解除绑定
                $(".thumb").removeAttr("onclick");
            }, 1000);


            //$("#column_arrange_sourcelist").load("/common/sourcelist.aspx", { "t": 2 }, function () {
            //    $("#column_arrange_sourcelist").slidedown();

            //});
        }
        function column_arrange_fullscreen() {
            var sid = $("#column_arrange_scid").val();
            var tempid = $("#cl_range_selsclist li[data-id=" + sid + "]").attr("data-tempid");
            var contenttype = $("#cl_range_selsclist li[data-id=" + sid + "]").attr("data-contenttype");
            window.open("FullScreenView.aspx?sid=" + sid + "&temp=" + tempid + "&ct=" + contenttype);
        }





        $(".resolution").live("mouseenter", function () {

            if ($(".resolution").css("right") == "-477px") {
                $(".biaoti").css("left", 437);
                $(this).animate({ "right": 0 }, function () {
                    if ($.cookie("PreviewRos") != null) {
                        var cookie = $.cookie("PreviewRos");
                        $("#column_arrange_fbl_width").val(cookie.split("|")[0]);
                        $("#column_arrange_fbl_height").val(cookie.split("|")[1]);
                    }
                });
            }
        });
        //图片加载
        function no_find(contenttype, obj) {
            $(obj).attr('src', "/images/img_new/default_" + contenttype + "_3.png");
        }

    



        $(".resolution").live("mouseleave", function () {
            if ($(".resolution").css("right") == "0px") {
                $(".biaoti").css("left", 0);
                $(".resolution").animate({ "right": -477 });
            }

        });
        showTypeRecord("lanmu");
        
        window.onload = function () {
            if ($("#myColFiled").val() == "1") {////栏目归档, 显示 锁 图标
                $("#showGuiDang").css("display", "");
            }
            $(".slideBarItem").mouseover(function () {
                $("#columnDiv").animate({ right: "0px" });
            })
            $("#columnDiv").mouseleave(function () {
                $("#columnDiv").animate({ right: "-200px" });
            })
          
        }


    </script>

    <style>
        .ui-dialog {
            z-index: 999;
        }
    </style>
</head>
<body>
    <div id="mark" style="position: absolute; width: 100%; height: 100%; top: 0px; left: 0px; border: 1px solid #333; z-index: 9999; display: none; outline: 1px solid #333;"></div>
    <div id="content_dialog" style="padding: 0;">
    </div>
    <div id="closeWindow" style="display:none;width: 25px;height: 25px;left: 1240px;top: 300px;z-index: 80001;position: absolute;cursor: pointer;" title="关闭">
        <img src="/images/err.png" onclick="javascript:$('#content_dialog').dialog('close');"/>

    </div>
    <div class="slideBarItem">
        <img src="/images/slideTwig.png">
    </div>
   <div id="columnDiv">
       <div class="lastSource commonStyle">
            <p><span>最近素材</span></p>
            <div class="lastSourceList ">
            </div>
        </div>
        <div class="lastProgram commonStyle" >
            <p><span>最近节目单</span></p>
            <div class="lastProgramList ">
            </div>
        </div>
        <div class="lastClient">
            <p><span>最近终端</span></p>
            <div class="lastClientList">
            </div>
        </div>
    </div>
    <form id="column_arrange" runat="server">
        <div id="overlay" style="display: none"></div>
        <!-- #include file="/common/top.html" -->
        <input type="hidden" id="column_arrange_clid" runat="server" />
        <input type="hidden" id="myColFiled" runat="server" />
        <input type="hidden" id="column_arrange_scid" runat="server" />
        <input type="hidden" id="column_arrange_arrright" runat="server" />
        <input type="hidden" id="column_arrange_chright" runat="server" />
        <input type="hidden" id="column_arrange_pubright" runat="server" />
        <input type="hidden" id="column_arrange_sclist" runat="server" />
        <input type="hidden" id="column_arrange_tempid" runat="server" />
        <input type="hidden" id="column_arrange_area_bg_width" runat="server" />
        <input type="hidden" id="column_arrange_area_bg_height" runat="server" />
        <input type="hidden" id="column_arrange_pagetype" runat="server" />
        <div id="column_arrange_resendresult" style="display: none;"></div>
        <div class="container clearfixed">
            <div class="pos_area2 clearfix">
                <div class="pos"><a href="column_list.aspx?t=0">栏目管理</a>&gt;<a class="current" href="column_list.aspx?t=2">栏目编排</a>
                     <span id="showGuiDang" style="width:24px;height:24px;display:none;margin-right: -55px;"><a href="javascript:void(0)" title="归档" style="background:url(/images/tubiaoa.png) 30px -74px;width:12px;height:24px;"></a></span>
                    <span class="label_value"></span>
                    <span id="mycheckstatus1" runat="server">审核状态：</span>
                </div>
            </div>
            <%--column_arrange.aspx?t=0--%>
            <div class="column_con">
                <div class="arrange_area">
                    <div class="caption clearfix">
                        <div class="add_btn clearfix" style="clear: both;" id="column_arrange_topmenu">
                        </div>
                    </div>
                    <div class="edit_item">
                        <div class="big_area">
                            <div class="picadd" id="column_arrange_area_bg" style="width: 960px; height: 440px; position: absolute; left: 50%; margin-left: -480px; top: 50%; margin-top: -220px; border: 1px solid #ddd;">
                                <iframe id="column_addrange_mainframe" src="column_arrange_frame.html" frameborder="0" width="100%" height="100%"></iframe>
                            </div>
                            <div class="resolution">
                                <div class="biaoti" id="column_arrange_ros_biaoti" onclick="">
                                    <h4><a>预览分辨率设置</a></h4>
                                </div>
                                <div class="cont" id="column_arrange_ros_setting">
                                    <div class="fbl_seting">
                                        <h4>常见列表</h4>
                                        <div style="height: 240px; overflow-y: scroll;">
                                            <ul class="clearfix" id="previewResolutionList" runat="server">
                                            </ul>
                                            <div class="btn_box">
                                                <input class="inp_s" value="返回" type="button" onclick="column_arrange_resetros();">
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="small_area">
                            <div class="imglist">
                                <ul class="clearfix" style="width: 10000px;">
                                    <li style="width: 9800px;">
                                        <ul id="cl_range_selsclist" style="position: relative" runat="server">
                                        </ul>
                                </ul>
                            </div>
                            <div class="prev"><a href="javascript:void(0);"></a></div>
                            <div class="next"><a href="javascript:void(0);"></a></div>
                        </div>
                    </div>
                    <div class="edit_item_list" id="column_arrange_edititem_box" style="display: none;"></div>
                </div>
            </div>
        </div>
        <div class="list_box">
            <div class="title clearfix">
                <ul class="bt clearfix">
                    <li class="current"><a href="javascript:void(0)">素材列表</a></li>
                </ul>
            </div>
        </div>
        <div id="column_arrange_h_sourcelist" class="list_box" style="background: #edf0f0"></div>
        <div id="column_arrange_sourcelist" style="position: absolute; left: 100px; z-index: 1001; top: 110px; display: none; width: 760px; height: 400px; background: #ffffff; border: 2px solid #333333; -moz-box-shadow: 3px 3px 3px #333333 inset; /* for firefox3.6+ */ -webkit-box-shadow: 3px 3px 3px #333 inset; /* for chrome5+, safari5+ */ box-shadow: 3px 3px 3px #333 inset; /* for latest opera */"></div>
    </form>
</body>
</html>
