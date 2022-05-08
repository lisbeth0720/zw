<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_arrange.aspx.cs" Inherits="Web.company.program.program_arrange" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-节目单编排</title>
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
        #program_arrange_btn_addsource b{
            padding-left: 20px;
            background: url(/images/tubiao.png) -97px -652px;
            padding: 5px 0 5px 20px;
        }

        #program_arrange_btn_addsource:hover b{
            background: url(/images/tubiao.png) -97px -711px;
        }
        #program_arrange_btn_addcolumn b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -120px -652px;
            padding: 5px 0 5px 20px;
        }
        #program_arrange_btn_addcolumn:hover b {
            background: url(/images/tubiao.png) -120px -711px;
        }
        #program_arrange_btn_pass b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -145px -652px;
            padding: 5px 0 5px 20px;
        }

        #program_arrange_btn_pass:hover b {
            background: url(/images/tubiao.png) -145px -711px;
        }

        #program_arrange_btn_yulan b {
            padding-left: 20px;
            background: url(/images/tubiao.png) -170px -652px;
            padding: 5px 0 5px 20px;
        }

        #program_arrange_btn_yulan:hover b {
            background: url(/images/tubiao.png) -170px -711px;
        }

        #program_arrange_btn_addsave b {
            width: 20px;
            height: 20px;
            display: inline-block;
            background: url(/images/tubiao.png) -192px -652px;
            position: absolute;
            left: 7px;
            top: 0px;
        }

        #program_arrange_btn_addsave:hover b {
           background: url(/images/tubiao.png) -192px -711px;
        }


        #program_arrange_layoutsellist .bt.active, #program_arrange_layoutlist .bt.active {
            /*position: absolute;
            top: 0;
            height: 70px;
            line-height: 70px;*/
            color: red;
            /*background: rgba(108,226,108,.4);*/
            box-sizing: border-box;
            text-align: center;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        #program_arrange_btn_clear b {
            width: 20px;
            height: 20px;
            display: block;
            background: url(/images/tubiao.png) -215px -656px;
            position: absolute;
            top: 3px;
            left: 6px;
        }

        #program_arrange_btn_clear:hover b {
           background: url(/images/tubiao.png) -215px -714px;
        }
        /*编辑节目单窗口样式*/
        #dialog .container {
            width: 100%;
        }

        #dialog .jmd_add_box {
            width: 100%;
        }

            #dialog .jmd_add_box > ul > li {
                width: 100%;
            }
        .sc_list_box .title ul.bt li {
            width: 120px;
            font-size: 14px;
        }
           
    </style>
    <script type="text/javascript">
        var haveloadfrlist = 0;
        var savewindowsname = "";
        var savetype = -1;
        var savecheckflag = -1;
        $(function () {
            getJsonValue();
            var w = document.documentElement.clientWidth;
            //$("#programDiv").css("left", (w - 220) + "px");
            window.onresize = function () {
                var w = document.documentElement.clientWidth;
              //  $("#programDiv").css("left", (w - 220) + "px");
            }
            $("#programDiv").css("display", "block");

            //加载 主屏幕下方的缩略图。
            $("#program_range_selitemlist img").error(function () {//这里暂时为 ,图片的类型为3，图片未加载出来 为其设置缺省属性。其实有些不妥。
                $(this).attr('src', "/images/img_new/default_3_3.png");
            });
            showTypeRecord("jiemudan");
            $(".slideBarItem").mouseover(function () {
                $("#programDiv").animate({ right: "0px" });
            })
            $("#programDiv").mouseleave(function () {
                $("#programDiv").animate({ right: "-200px" });
            })
            ////编排权限
            if ($("#program_arrange_arrright").val() == 1) {//<b></b>空的b标签是按钮的图标，不可以删掉！！！！
                $("#program_arrange_topmenu").append(' <span class="inp_btn"><a href="javascript:void(0)" title=" ' + getLanguageMsg("添加素材项", $.cookie("yuyan")) + '" id="program_arrange_btn_addsource"><b></b>' + getLanguageMsg("添加素材项", $.cookie("yuyan")) + '</a></span><span class="inp_btn"><a href="javascript:void(0)" title="' + getLanguageMsg("添加栏目项", $.cookie("yuyan")) + '" id="program_arrange_btn_addcolumn"><b></b> ' + getLanguageMsg("添加栏目项", $.cookie("yuyan")) + '</a></span>');

            }//审核权限
            if ($("#program_arrange_chright").val() == 1) {//<b></b>空的b标签是按钮的图标，不可以删掉！！！！
                $("#program_arrange_topmenu").append('<span class="inp_btn"><a href="javascript:void(0)" onclick="program_range_checkall()" title="' + getLanguageMsg("全部审核通过", $.cookie("yuyan")) + '" id="program_arrange_btn_pass"><b></b> ' + getLanguageMsg("全部审核通过", $.cookie("yuyan")) + '</a></span><span class="inp_btn"><a href="javascript:void(0)" title=" ' + getLanguageMsg("全屏预览", $.cookie("yuyan")) + '" id="program_arrange_btn_yulan" onclick="Program_arrange_FullView()"><b></b> ' + getLanguageMsg("全屏预览", $.cookie("yuyan")) + '</a></span><span class="inp_btn"><a href="javascript:void(0)" id="program_arrange_btn_addsave" title=" ' + getLanguageMsg("本地分发并下载", $.cookie("yuyan")) + '" style="padding-left:30px;position:relative;"><b></b> ' + getLanguageMsg("本地分发下载", $.cookie("yuyan")) + '</a></span><span class="inp_btn"><a href="javascript:void(0)" title="' + getLanguageMsg("清空节目单", $.cookie("yuyan")) + '" onclick="showDeleteMenuList(<%=gmenuid%>)" id="program_arrange_btn_clear" style="padding-left:30px;position:relative;"><b></b>' + getLanguageMsg("清空节目单", $.cookie("yuyan")) + '</a></span>');
            
            }// //发布权限
            if ($("#program_arrange_pubright").val() == 1) {//<b></b>空的b标签是按钮的图标，不可以删掉！！！！
                $("#program_arrange_topmenu").append('<div class="slide_menu" style="color:#fff;"><p style="padding-left: 50px;margin-top:3px;border-radius: 4px;background: #61c6f8"><b style="display: inline-block;width: 20px;height: 20px;position:absolute;top:8px;left: 41px;background: url(/images/tubiaoa.png) -178px -125px;"></b> ' + getLanguageMsg("分发操作", $.cookie("yuyan")) + '</p><ul style="background: rgb(97, 198, 248);"><li><a href="javascript:void(0)" title=" ' + getLanguageMsg("重新分发节目单", $.cookie("yuyan")) + '" onclick="program_range_resendmenu(1)"> ' + getLanguageMsg("重新分发节目单", $.cookie("yuyan")) + '</a></li><li><a href="javascript:void(0)" title=" ' + getLanguageMsg("停止分发节目单", $.cookie("yuyan")) + '" onclick="program_range_resendmenu(2)"> ' + getLanguageMsg("停止分发节目单", $.cookie("yuyan")) + '</a></li><li><a href="javascript:void(0)" title=" ' + getLanguageMsg("重置节目单分发状态", $.cookie("yuyan")) + '" onclick="program_range_resetmenu()"> ' + getLanguageMsg("重置节目单分发状态", $.cookie("yuyan")) + '</a></li></ul></div>');
            }
            program_arrange_load_h_sourcelist();
            program_arrange_getselFrameLayout();
            program_arrange_showbg();

            // 第一个布局窗口 用红框圈起来
            var a = getLanguageMsg("刷新", $.cookie("yuyan"));
            var b = getLanguageMsg("关闭", $.cookie("yuyan"));
            var c = getLanguageMsg("添加空素材", $.cookie("yuyan"));
            var d = getLanguageMsg("添加栏目项", $.cookie("yuyan"));
            $("#content_dialog").dialog({
                autoOpen: false,
                closeText: getLanguageMsg("关闭", $.cookie("yuyan")),
                zIndex: 8000,
                close: function () {
                    $("#content_dialog").html("");
                    $("#closeWindow").hide();
                },
                open: function () {
                    var butto = $(this).next();
                    butto.find("button:eq(0) span").html(a);
                    butto.find("button:eq(1) span").html(b);
                    butto.find("button:eq(2) span").html(c);
                },
                buttons: {
                    "刷新": function () {
                        $("#content_dialog").load("/common/sourcelist.aspx", { "t": 3 });
                    },
                    "关闭": function () {
                        $("#content_dialog").html("");
                        closethumbPage();//关闭素材预览 弹窗。
                        $("#content_dialog").dialog("close");

                        $("#program_arrange_h_columnlist").fadeOut();
                        program_arrange_load_h_sourcelist();
                    },
                    "添加空素材": function () {//把 0号素材添加进来，用于网页模板  tmodel.html  ...@1@
                        //addsourcetoMenu(id, thumbnail, itemname, contenttype, sourceid, itemtype, exetask)
                        addsourcetoMenu('0', '', getLanguageMsg("空素材", $.cookie("yuyan")), 0, '0', 0, '');
                    }
                },
                width: 800,
                height: 600,
                resizable: true,
                title: getLanguageMsg("添加素材项", $.cookie("yuyan")),
                stack: true,
                appendTo: "body"
            });
            $("#content_dialog2").dialog({
                autoOpen: false,
                closeText: getLanguageMsg("关闭", $.cookie("yuyan")),
                zIndex: 8000,
                close: function () {
                    $("#content_dialog2").html("");
                    $("#closeWindow2").hide();
                },
                buttons: {
                    a: function () {
                        $("#content_dialog2").load("/common/columnlist.aspx", { "t": 4, "r": Math.random(1000) });
                    },
                    b: function () {
                        $("#content_dialog2").html("");
                        $("#content_dialog2").dialog("close");

                        $("#program_arrange_h_sourcelist").fadeOut();
                        program_arrange_load_h_columnlist();
                    }
                },
                width: 800,
                height: 600,
                resizable: true,
                title: d,
                stack: true,
                appendTo: "body"
            });
           /* $("#content_dialog").scroll(function () {
                var totalheight = $(this).children().height() - 50;//这样不行 children().height()是15
                totalheight = $(document).height()-50;//-20
                var scorllheight = $(this).scrollTop() + $(this).height();
              //  $("#ui-id-1").html(totalheight + "|" + scorllheight);
                if (scorllheight >= totalheight) {
                    sc_list_pic_shownext();
                }
            });*/

            /**右侧布局列表显示隐藏********************************/
            $("#program_arrange_btn_showaddlayout").live("click", function () {
                if ($("#programIsFiled").val() == "1") {//节目单归档， 不能插入布局
                    return false;
                }
                $("#program_arrange_layoutlist_div").find("h4").css("color", "#fff");
                $("#program_arrange_layoutlist_div").slideDown();
                $("#program_arrange_layoutsellist_div").slideUp();
                $("#program_arrange_scale_div").slideUp();

                //8/3 为按钮 +  添加事件，为“切换布局”赋值 
                $("#program_arrange_waitlayoutid").val(0);
                $("#program_arrange_waitlayoutposition").val(0);
                $("#program_arrange_waittaskposition").val(0);
                program_arr_LayoutData();
            });
            //为按钮"前插" 添加事件，为“切换布局”赋值 
            $(".insert_before").live("click", function () {
                //debugger;
                if ($("#programIsFiled").val() == "1") {//节目单归档，，不能插入布局。
                    return false;
                }
                dom = $(this);
                $("#program_arrange_layoutlist_div").find("h4").css("color", "#f7f10b");
                //transValue(dom);

                $("#program_arrange_waitlayoutid").val(dom.attr("data-inserted_framelayoutid"));
                $("#program_arrange_waitlayoutposition").val(dom.attr("data-framelayoutposition"));
                $("#program_arrange_waittaskposition").val(dom.attr("data-inserted_position"));
                dom.addClass("current").siblings().removeClass("current");
                $("#program_arrange_layoutlist_div").slideDown();
                $("#program_arrange_layoutsellist_div").slideUp();
                $("#program_arrange_scale_div").slideUp();
                program_arr_LayoutData();

                //8、3为 插入布局按钮 添加  click 事件
                /*setTimeout(function () {
                    $("#insert_btn").click(function () {
                      
                        program_arrange_changelayoutid(0);

                    });

                }, 300);*/
            });
            //选择布局后 为“切换布局” 的赋值，即在“切换布局”页选中了什么 布局。
            $("#program_arrange_layoutlist").live("click", "#program_arrange_layoutlist li span.bt", function (e) {
                if ($("#programIsFiled").val() == "1") {//节目单归档，，不能插入布局。
                    return false;
                }
                dom = $(e.target);
                if (dom.attr("class") == "bt") {
                    $("#program_arrange_layoutlist_div").slideDown();
                    $("#program_arrange_layoutsellist_div").slideUp();
                    $("#program_arrange_scale_div").slideUp();
                    $("#program_arrange_waitneedinsertlayoutid").val(dom.attr("data-add_framelayoutid"));

                    //dom.addClass("active").parent("a").parent("li")
                    //     .siblings()
                    //    .children("a")
                    //    .children(".bt")
                    //    .removeClass("active")
                    // .css({ "background": "rgba(159,26,16,.5)" });
                    //children(".bt") , 不会在子元素 查找 //find(".bt")，会在子元素 查找
                    dom.addClass("active").parent("li")
                         .siblings()
                        .children(".bt")
                        .removeClass("active")
                }
            });

            $("#program_arrange_layoutsellist").live("click", "#program_arrange_layoutlist li span.bt", function (e) {
                dom = $(e.target);
                if (dom.attr("class") == "bt") {
                    //dom.addClass("active").parent("a").parent("li")
                    //   .siblings()
                    //  .children("a")
                    //  .children(".bt")
                    //   .removeClass("active");
                    //children(".bt") , 不会在子元素 查找 //find(".bt")，会在子元素 查找
                    dom.addClass("active").parent("li")
                       .siblings()
                      .children(".bt")
                       .removeClass("active");
                    // .css({ "background": "rgba(159,26,16,.3)" });
                }
            });

            $("#program_arrange_btn_showlayoutlist").click(function () {

                $(this).addClass("current").siblings().removeClass("current");
                $("#program_arrange_layoutsellist_div").slideDown();
                $("#program_arrange_layoutlist_div").slideUp();
                $("#program_arrange_scale_div").slideUp();
            });
            $("#program_arrange_btn_showros").click(function () {
                $(this).addClass("current").siblings().removeClass("current");
                $("#program_arrange_scale_div").slideDown();
                $("#program_arrange_layoutlist_div").slideUp();
                $("#program_arrange_layoutsellist_div").slideUp();
                if ($.cookie("PreviewRos") != null || "0" || "") {
                    var cookie = $.cookie("PreviewRos");
                    console.log(cookie);
                    if (cookie != null) {
                        var cookiearr = cookie.split("|");
                        $("#program_arrange_fbl_width").val(parseInt(cookiearr[0]));
                        $("#program_arrange_fbl_height").val(parseInt(cookiearr[1]));
                    }
                    else {
                        $("#program_arrange_fbl_width").val(1024);
                        $("#program_arrange_fbl_height").val(768);
                    }
                }
            });
            

            


            //删除节目项操作  //$("#program_range_selitemlist li a .del").die().live("click", function (event) {
            $("#program_range_selitemlist li a .del").live("mousedown",function (event) {
                if ($("#programIsFiled").val() == "1") {//节目单归档， 不能删除
                    TopTrip(getLanguageMsg("节目单归档,不能删除节目项！", $.cookie("yuyan")), 2); return false;
                }

                var parentliObj = $(this).parent().parent();
                var taskid = parentliObj.attr("data-pid");
                var currentWindow = parentliObj.attr("data-window").split("-")[1];//当前选择的布局窗口 名称
                $.ajax({
                    type: 'post',
                    url: 'ajax/delmenu.ashx',
                    data: {
                        "menuid": $("#program_arrange_menuid").val(),
                        "taskid": taskid,
                        "myIsFiled": $("#programIsFiled").val()
                    },
                    async: false,
                    dataType: 'text',
                    success: function (data) {
                        //debugger;
                        if (data == -1) {
                            LoginTimeOut();
                        }
                        else if (data > 0) {
                            //删除时，判断如果当前被选中状态，就向前移动1个，tzy
                            if (parentliObj.attr("class") == "current") {
                                //只有一个 节目项，删除了
                                if ($("#program_range_selitemlist li").length == 1) {
                                    //document.getElementById("Program_ArrangeMainFrame").setAttribute("src", "/company/Layout/frame.html");//这样是 重新载入整个布局
                                    //debugger;
                                    //获取当前选择的布局窗口，刷新
                                    //setDefaultWindow(currentWindow);
                                    var frames = document.getElementById('Program_ArrangeMainFrame').contentWindow.frames;
                                    for (var i = 0; i < frames.length; i++) {
                                        if (frames[i].name == currentWindow) {
                                            //frames[i].setAttribute("src","/company/Layout/programBkstyle.htm");
                                            frames[i].location.href = "/company/Layout/programBkstyle.htm";
                                            setDefaultWindow(currentWindow, "yanshi");//删除完 窗口中的素材，不跳转到其他窗口，确保当前选择的窗口。                                       
                                            break;
                                            //setTimeout(function (){
                                            //    frames[i].document.body.style.borderTop = "2px solid rgb(255, 0, 0);";
                                            //    frames[i].click();   //document.getElementById('Program_ArrangeMainFrame').contentWindow.frames[i].document.body.click();
                                            //},3000);                                
                                        }
                                    }                                   
                                }
                                //如果删除的不是第1个元素就向前选择，反之向后选择，tzy
                                if (parentliObj.prev("li").html() == null) {
                                    parentliObj.next("li").mousedown();
                                } else {
                                    parentliObj.prev("li").mousedown();
                                }
                            }
                            //program_arrange_getSouceInfo();
                            parentliObj.remove();
                        }
                        else if (data == "-100") {
                            TopTrip(getLanguageMsg("节目单归档,不能删除节目项！", $.cookie("yuyan")), 2);
                        }
                        else {
                            TopTrip(getLanguageMsg("系统错误，请联系管理员！", $.cookie("yuyan")), 3);
                        }
                    }
                })
                // event.preventDefault();  
                event.stopPropagation();//会触发li 的click事件  //阻止事件冒泡
                //return false;
            });


            //本地分发并下载，节目单
            $("#program_arrange_btn_addsave").click(function () {
                //////////cgi-bin/preparefilecgi.cgi?companyid=wisepeak&maintype=0&subtype=12&groupid=0&clientid=*&value1=1605&merit=5&username=whq123&password=yoaC/EHueDeMo8EM/alIMw==&charset=utf-8
                
                var companyid="<%=Companyid%>";
                var menuid = $("#program_arrange_menuid").val();
                var userid = "<%=userName%>"; var password = "<%=userpassoword%>";
                $.ajax({
                    type: 'post',
                    url: '/cgi-bin/preparefilecgi.cgi?companyid='+companyid+'&maintype=0&subtype=12&groupid=0&clientid=*&value1='+menuid+'&merit=5&username='+userid+'&password='+password+ '&charset=utf-8&utf8=1',
                    async: true,
                    dataType: 'text',
                    success: function (data) {
                        // data = data.substr(0,data.indexOf("<a"));
                        $("#downloadProgram div:first").html("");
                        $("#downloadProgram div:first").append(data.substr(0, data.indexOf("<a")));
                        $("#overlay").fadeIn();
                        $("#downloadProgram").fadeIn();
                        $.ajax({
                            type: 'post',
                            url: 'ajax/downloadMenu.ashx',
                            async: true,
                            data:{"mymenuid":menuid},
                            dataType: 'text',
                            success: function (data) {
                               // debugger;
                                if (data != "-1") {
                                    //'<p align="center"><font color="red" size="4pt"><a href="'+data+'" style="color:blue;">下载节目单</a></font></p>'
                                    $("#downloadProgram div:first").append('<p align="center"><font size="4pt"><a href="' + data + '" style="color:blue;"> ' + getLanguageMsg("下载节目单", $.cookie("yuyan")) + '</a></font></p>');
                                } else { LoginTimeOut(); }
                                //$("#downloadProgram").append(data);
                            }
                        });
                        //$("#downloadProgram").append(data);
                    }
                });
                
            });
            /**左侧窗口列表显示隐藏********************************/
            $("#program_arrange_btn_showwindows").mouseenter(function () {
                $("#program_arrange_windows_div").animate({ "left": 0 })
            });
            $("#program_arrange_windows_div").mouseleave(function () {
                $("#program_arrange_windows_div").animate({ "left": -200 })
            });
            /**分发操作显示隐藏******************************************/
            $(".add_btn .slide_menu").on("mouseenter", function () {
                if ($(this).find("ul").css("display") == "none")
                    $(this).find("ul").slideDown(500);//mouseenter
            });

            $(".add_btn .slide_menu").stop().on("mouseleave", function () {

                $(this).find("ul").slideUp(200);//mouseleave
            });
            /**弹出素材列表窗口**************/
            $("#program_arrange_btn_addsource").click(function () {
                //if ($("#programIsFiled").val()!="1") { 
                ClearSourceListHtml();
                close_ck_icon_right();
                //}
                $("#content_dialog2").dialog("close");
                $("#closeWindow2").hide();
                $("#content_dialog").load("/common/sourcelist.aspx", { "t": 3 });

                $("#content_dialog").dialog("open");
                $("#closeWindow").show();
                setTimeout(function () { //7/31解除绑定
                    $(".thumb").removeAttr("onclick");
                }, 500);
            });
            /**弹出栏目列表窗口**************/
            $("#program_arrange_btn_addcolumn").click(function () {
                ClearColumnListHtml();
                close_ck_icon_right();
                $("#content_dialog").dialog("close");
                $("#closeWindow").hide();
                $("#content_dialog2").load("/common/columnlist.aspx", { "t": 4, "r": Math.random(1000) });
                $("#content_dialog2").dialog("open");
                $("#closeWindow2").show();
            });
            $("#program_range_selitemlist").dragsort({//dragSelectorExclude:"a",
                dragSelector: "li", dragBetween: false, placeHolderTemplate: "<li class='placeHolder'><div></div></li>",
                dragEnd: function () {
                    //debugger;
                    SaveMenuPosition();
                }
            });
            $("input[name=program_arrange_fbl_button]").val(getLanguageMsg("自定义提交", $.cookie("yuyan")));
           // debugger;
            switchLanguage("#zyyProgramArrangeContainer", 1, "program_arrange.aspx");
            
            
        })
        function closeDiv() {
            $("#downloadProgram").fadeOut(function () {
                $("#overlay").fadeOut();
            });
        }
        function closeDialog(dialogType) {
            if (dialogType=='0') {
                $("#content_dialog").html("");
                closethumbPage();//关闭素材预览 弹窗。
                $("#content_dialog").dialog("close");

                $("#program_arrange_h_columnlist").fadeOut();
                program_arrange_load_h_sourcelist();  // /company/source/ajax/getlistdata.ashx  //会走两次？？
            } else if (dialogType=='1') {
                $("#content_dialog2").html("");
                $("#content_dialog2").dialog("close");

                $("#program_arrange_h_sourcelist").fadeOut();
                program_arrange_load_h_columnlist();
            }
        }
        window.onload = function () {//页面加载完成后  
            $("#program_range_selitemlist li:eq(0)").addClass("current");
            if ($("#programIsFiled").val() == "1") {////节目单归档, 显示 锁 图标
                $("#showGuiDang").css("display", "");
            }
        }
        //右侧窗口列表和分辨率展示隐藏方法
        $(".ck_icon_right").die().live("click", function () {
            if ($(this).attr("data-isshow") == 0) {
                $(this).attr("data-isshow", 1);
                $(".layout").animate({ "right": "20px" });
                $(this).children("span").removeClass("one").addClass("two");

                //第一个播放
                //  if ($("#program_arrange_layoutsellist>li:not:eq(0) .bt").hasClass("active")) {
                //      $("#program_arrange_layoutsellist>li:eq(0) .bt").removeClass("active");
                //  }
            }
            else {
                $(this).attr("data-isshow", 0);
                $(".layout").animate({ "right": "-530px" });
                $(this).children("span").removeClass("two").addClass("one");
            }
        });
        //素材列表预览点击事件  //.die().live     // $("#program_range_selitemlist").on("click", "li"
        $("#program_range_selitemlist li").live("mousedown", function (ele) {
            //debugger;
            console.log(ele.currentTarget + "......." + ele.target);
            if (ele.target.outerHTML.indexOf("del") > 0 && ele.target.tagName=="SPAN") return false;//删除操作。。。。

           // if (ele.currentTarget != ele.target) return false; //拖动 也会 执行。。。
            //console.log("click.........."); //之后 添加素材项，也会有click事件
            var myCheckStatus = $(this).attr("data-checkstatus");
            var taskid = $(this).attr("data-pid");
            var itemid = $(this).attr("data-id");
            var sourceid = $(this).attr("data-sourceid");
            var itemname = $(this).attr("data-name");
            var taskname = $(this).attr("data-taskname");
            var duringtime = $(this).attr("data-duringtime");
            var itemtype = $(this).attr("data-itemtype");
            var contenttype = $(this).attr("data-contenttype");
            var tempid = $(this).attr("data-tempid");
            var position = $(this).attr("data-position");
            var window = $(this).attr("data-window");//有的时候，现在在本窗口内的节目项实际窗口名并不是布局内的窗口名（编排后去修改布局内的窗口名了）,此时要重新修改下节目项后就可一致了
            $("#program_arrange_taskid").val(taskid);
            $("#program_arrange_selscid").val(sourceid);
            $("#program_arrange_selct").val(contenttype);
            $("#program_arrange_seltempid").val(tempid);
            if (!$(this).hasClass("current") || window != $("#program_arrange_window").val()) {// 点击时候不重复加载
                program_arrange_getSouceInfo(sourceid, contenttype, window, $("#program_arrange_window").val(), tempid, taskid, 1);
                $(this).addClass("current").siblings("li").removeClass("current");
            }
            //if ($("#h_edit_program_menu_taskid").val() != taskid) { //没有点击同一个节目项
            //    $("#program_arrange_editpage").html("");//重新加载 节目项
            //}
            //编辑节目项 页面，不重复加载
            //if ($("#program_arrange_editpage").text().length > 100 && $("#program_arrange_editpage").css("display") == "none") {
            //    $("#program_arrange_editpage").css("display","block");
            //} else if ($("#program_arrange_editpage").text().length < 100) {
            $("#program_arrange_editpage").load("edit_program_menu.aspx", { "taskid": taskid, "position": position, "taskname": taskname, "itemname": itemname, "menuid": $("#program_arrange_menuid").val(), "type": $("#program_arrange_pagetype").val(), "itemid": itemid, "checkstatus": myCheckStatus, "window": $("#program_arrange_window").val(), "framelayoutid": $("#program_arrange_layoutid").val(), "fposition": $("#program_arrange_layoutposition").val() }, function () {
                $("#program_arrange_editpage").slideDown();//下拉菜单 出现

                //if ($.cookie("ProgramSlide") == "0") {//如果cookie 为0 触发click
                //    $("#edit_menu_add_ex").trigger("click");
                //}
            });
            //}
           // event.preventDefault();
           // event.stopPropagation();
        });
        //关闭右侧展示方法
        function close_ck_icon_right() {
            $(".ck_icon_right").attr("data-isshow", 0);
            $(".layout").animate({ "right": "-530px" });
            $(".ck_icon_right").children("span").removeClass("two").addClass("one");
        }
        //重置节目单状态
        function program_range_resetmenu(type) {
            $.ajax({
                type: 'post',
                url: 'ajax/resetmenu.ashx',
                data: {
                    "menuid": $("#program_arrange_menuid").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else {
                        TopTrip(getLanguageMsg("所有状态设置完毕", $.cookie("yuyan")), 1);
                    }
                }
            })
        }
        //重新分发节目单
        function program_range_resendmenu(type) {
            $.ajax({
                type: 'post',
                url: 'ajax/resendmenu.ashx',
                data: {
                    "type": type,
                    "menuid": $("#program_arrange_menuid").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else if (data == -2) {
                        TopTrip(getLanguageMsg("该节目单或下属素材未通过审核！", $.cookie("yuyan")), 2);
                    } else {
                        $.get("/cgi-bin/preparefilecgi.cgi?" + data + "&charset=utf-8&random" + Math.random(999), function (data) {
                            //var toptext= $(data).find("font").text();
                            TopTrip(getLanguageMsg("操作成功！", $.cookie("yuyan")), 1);
                        });
                    }
                }
            })
        }
        //获取布局块在节目单中位置序号。当insert=0时，表示在节目单中指定位置插入新的layoutid布局
        function program_range_getlayoutposition(position, framelayoutposition, oldlayoutid, layoutid, insert) {
            $.ajax({
                type: 'post',
                url: 'ajax/getlayoutposition.ashx',
                data: {
                    "menuid": $("#program_arrange_menuid").val(),
                    "layoutid": layoutid,
                    "oldlayoutid": oldlayoutid, //之前的 布局id
                    "position": position,
                    "framelayoutposition": framelayoutposition,
                    "insert": insert
                },
                async: false,
                dataType: 'text',
                success: function (data) {
                    var framelayoutposition = data;
                    var taskposition = "0";
                    var loc = data.indexOf("||");
                    if (loc >= 0) {
                        framelayoutposition = data.substring(0, loc);
                        taskposition = data.substring(loc + 2);
                    }
                    if (framelayoutposition == "") framelayoutposition = "0";
                    if (parseInt(framelayoutposition) > 0) {
                        if (data != "") {
                            if (insert == 0) {
                                $("#program_arrange_layoutposition").val(framelayoutposition);
                                $("#program_arrange_layoutid").val(layoutid);
                                if (taskposition != "0") $("#program_arrange_taskposition").val(taskposition);
                                $("#program_arrange_waitlayoutposition").val($("#program_arrange_layoutposition").val());
                                $("#program_arrange_waitlayoutid").val($("#program_arrange_layoutid").val());
                                $("#program_arrange_waittaskposition").val($("#program_arrange_taskposition").val());
                            }
                            else {
                                $("#program_arrange_layoutposition").val(data);
                                $("#program_arrange_layoutid").val(layoutid);
                                $("#program_arrange_waitlayoutposition").val($("#program_arrange_layoutposition").val());
                                $("#program_arrange_waitlayoutid").val($("#program_arrange_layoutid").val());
                            }
                        }
                    }
                    else {
                        //debugger;
                        LoginTimeOut();
                    }
                }
            });
        }
        //审核节目单全部通过
        function program_range_checkall() {
            close_ck_icon_right();
            if ($("#programIsFiled").val() == "1") {//节目单归档， 
                return;
            }
            $.ajax({
                type: 'post',
                url: 'ajax/checkmenu.ashx',
                data: {
                    "menuid": $("#program_arrange_menuid").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    if (data == -1) {
                        LoginTimeOut();
                    }
                    else if (data == "-100") {
                        TopTrip(getLanguageMsg("节目单已归档，不允许修改！", $.cookie("yuyan")), 2);
                    }
                    else {
                        if (data == 0) {
                            TopTrip(getLanguageMsg("系统错误，请联系管理员！", $.cookie("yuyan")), 3)
                        }
                        if (data > 0) {
                            TopTrip(getLanguageMsg("所有节目项审核成功！", $.cookie("yuyan")), 1)
                        }
                    }
                }
            })
        }
        //加载历史素材
        $("#program_arrange_loadhc_btn").die().live("click", function () {
            $(this).parent().siblings().removeClass("current");
            $(this).parent().addClass("current");

            $("#program_arrange_h_sourcelist").fadeOut();
            program_arrange_load_h_columnlist();
            $("#program_arrange_h_columnlist").fadeIn();
        });
        $("#program_arrange_loadhs_btn").die().live("click", function () {
            $(this).parent().siblings().removeClass("current");
            $(this).parent().addClass("current")
            $("#program_arrange_h_columnlist").fadeOut();
            program_arrange_load_h_sourcelist();
            $("#program_arrange_h_sourcelist").fadeIn();
        });
        //页面下方历史素材列表---从cookie获取
        function program_arrange_load_h_sourcelist() {
            ClearSourceListHtml();
            $("#program_arrange_h_sourcelist").load("/company/source/picSourceList.aspx", { "sd": 1, "of": 0, "sort": 0, "t": 3 }, function () {
                $("#program_arrange_h_sourcelist").slideDown();
            });
        }
        //页面下方历史栏目列表---从cookie获取
        function program_arrange_load_h_columnlist() {
            ClearColumnListHtml();
            $("#program_arrange_h_columnlist").load("/company/column/column_piclist.aspx", { "sd": 1, "of": 0, "sort": 0, "t": 4 }, function () {
                $("#program_arrange_h_columnlist").slideDown();
            });
        }
        //右侧加载选中节目单中各布局
        function program_arrange_getselFrameLayout() {
            var havevalue = 0;
            $.ajax({
                type: "post",
                url: '/company/Layout/LayoutHandler.ashx',
                async: false,
                dataType: 'text',
                data: {
                    a: "menulayoutlist",
                    menu: $("#program_arrange_menuid").val()
                },
                success: function (data) {
                    //debugger;
                    if (data == "-1") {
                        //LoginTimeOut();////用户没有‘布局管理’ 权限
                    }
                    else if (data == "-2") {
                        LoginTimeOut();
                    }
                    else {
                        var json = strToJson(data);
                        var html = "";
                        $.each(json.Table, function (idx, item) {//item.framelayoutid  从1 开始，0留给“+”
                            if (idx == 0) {//显示布局顺序 中 第一个布局；
                                $("#program_arrange_layoutid").val(item.framelayoutid);
                                $("#program_arrange_layoutposition").val(item.framelayoutposition);
                                $("#program_arrange_needinsertlayoutid").val(0);
                                $("#program_arrange_taskposition").val(item.postion);
                                $("#program_arrange_waitlayoutid").val(item.framelayoutid);
                                $("#program_arrange_waitlayoutposition").val(item.framelayoutposition);
                                $("#program_arrange_waitneedinsertlayoutid").val(0);
                                $("#program_arrange_waittaskposition").val(item.postion);
                            }

                            html += '<li ><span class=\"bt\" style=\"cursor:pointer\" title="' + item.framelayoutid + "-" + item.framelayout + '" onclick="Program_arrange_SelLayoutRecord(' + item.framelayoutid + ',' + item.postion + ',' + item.framelayoutposition + ')">' + item.framelayoutid + "-" + item.framelayout + '</span><a href="javascript:void(0)">';
                            //html += '<div class="area"><img class="frame_img_bg "  data-frid="' + item.framelayoutid + '"  src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + item.framelayoutid + '_1.jpg"  onerror="find_noimg()"></div><span class=\"bt\" style=\"cursor:pointer\" onclick="Program_arrange_SelLayoutRecord(' + item.framelayoutid + ',' + item.postion + ',' + item.framelayoutposition + ')">' + item.framelayoutid + "-" + item.framelayout + '</span>\r\n<input type="hidden" id="html_' + item.framelayoutid + "_" + item.framelayoutposition + '" value="' + item.htmlstr.replace("\r", "").replace("\n", "") + '" />';// style="border:1px solid red">
                            html += '<div class="area"><img class="frame_img_bg "  data-frid="' + item.framelayoutid + '"  src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + item.framelayoutid + '_5.jpg"  onerror="find_noimg()"></div>\r\n<input type="hidden" id="html_' + item.framelayoutid + "_" + item.framelayoutposition + '" value="' + "" + '" />';
                           // html += '<span class="bt"></span>';//这个有用吗？  挡住“前插”、“删除”按钮了 ，布局的前插、删除。。。。。whq1.31
                            html += '<div class="caozuo">';
                            html += '<span class="insert_before" data-framelayoutposition="' + item.framelayoutposition + '" data-inserted_position="' + item.postion + '" data-inserted_framelayoutid="' + item.framelayoutid + '"> ' + getLanguageMsg("前插", $.cookie("yuyan")) + '</span><span class="caozuo_del" onclick=" DeleteArrangeLayOut(' + item.framelayoutid + ',' + item.framelayoutposition + ')"> ' + getLanguageMsg("删除", $.cookie("yuyan")) + '</span>';
                            html += '</div>';
                            html += '</a></li>';
                            havevalue = 1;
                        });
                        html += '<li id="program_arrange_btn_showaddlayout" data-framelayoutposition="0" data-inserted_position="0" data-inserted_framelayoutid="0"><span class="program_add_layout"> ' + getLanguageMsg("添加布局", $.cookie("yuyan")) + '</span>+</li>';
                        $("#program_arrange_layoutsellist").html("");
                        $("#program_arrange_layoutsellist").html(html);
                    }
                },
                complete: function () {
                    // $(".frame_img_bg").each(function (i, item) {
                    //      item.src = get_img_src($(item).attr("data-frid"), "<%=Companyid%>");
                    //  })
                }
            });
            if (havevalue == 0) {
                //空节目单时，显示缺省全屏布局
                $("#program_arrange_layoutid").val(0);
                $("#program_arrange_layoutposition").val(0);
                $("#program_arrange_needinsertlayoutid").val(0);
                $("#program_arrange_taskposition").val(0);
                $("#program_arrange_waitlayoutid").val(0);
                $("#program_arrange_waitlayoutposition").val(0);
                $("#program_arrange_waitneedinsertlayoutid").val(0);
                $("#program_arrange_waittaskposition").val(0);
                var html = "";
                //var htmlstr = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=gb2312"><title>不分屏__(全屏幕)</title></head>\r\n<frameset rows="*" framespacing="0" border="0" frameborder="0">\r\n<frame name="全屏窗口" marginwidth="5" marginheight="5" scrolling="no" noresize src="../bkstyle.htm">\r\n<noframes>\r\n<body>\r\n<p>Your browser does not support frame.</p>\r\n</body></noframes>\r\n</frameset>\r\n</html>';
                var htmlstr = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=gb2312"><title>' + getLanguageMsg("不分屏__(全屏幕)", $.cookie("yuyan")) + '</title></head>\r\n<frameset rows="*" framespacing="0" border="0" frameborder="0">\r\n<frame name="' + getLanguageMsg("全屏窗口", $.cookie("yuyan")) + '" marginwidth="5" marginheight="5" scrolling="no" noresize src="../bkstyle.htm">\r\n<noframes>\r\n<body>\r\n<p>Your browser does not support frame.</p>\r\n</body></noframes>\r\n</frameset>\r\n</html>';
                html += '<li ><span class=\"bt\" style=\"cursor:pointer\" onclick="Program_arrange_SelLayoutRecord(' + 0 + ',' + 0 + ',' + 0 + ')">' + 0 + "-" +  getLanguageMsg("不分屏__(全屏幕)", $.cookie("yuyan"))  + '</span><a href="javascript:void(0)">';
                html += '<div class="area"><img class="frame_img_bg " data-frid="' + 0 + '" src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + 0 + '_5.jpg"  onerror="find_noimg()"></div>\r\n<input type="hidden" id="html_' + 0 + "_" + 0 + '" value="' + htmlstr.replace("\r", "").replace("\n", ""); + '" />';
                // html += '<span class="bt"></span>';
                html += '</a></li>';
                html += '<li id="program_arrange_btn_showaddlayout" data-framelayoutposition="0" data-inserted_position="0" data-inserted_framelayoutid="0"><span class="program_add_layout">"' + getLanguageMsg("添加布局", $.cookie("yuyan")) + '" </span>+</li>';
                $("#program_arrange_layoutsellist").html("");
                $("#program_arrange_layoutsellist").html(html);
            }
        }
        //右侧加载选中节目单中各布局。同时如果给出参数，则返回比该参数大的第一个layoutposition对应记录信息
        function program_arrange_getselFrameLayoutEx(layoutposition) {
            var retstr = "";
            var havevalue = 0;
            var layoutid = "0";
            var layoutposition = "0";
            var taskposition = "0";
            $.ajax({
                type: "post",
                url: '/company/Layout/LayoutHandler.ashx',
                async: false,
                dataType: 'text',
                data: {
                    a: "menulayoutlist",
                    menu: $("#program_arrange_menuid").val()
                },
                success: function (data) {
                   // debugger;
                    if (data == "-1") {
                        //LoginTimeOut();///用户没有‘布局管理’ 权限
                    }
                    else if (data == "-2") {
                        LoginTimeOut();
                    }
                    else {
                        var json = strToJson(data);
                        var html = "";
                        $.each(json.Table, function (idx, item) {//item.framelayoutid  从1 开始，0留给“+”
                            if (idx == 0) {//显示布局顺序 中 第一个布局；
                                layoutid = (item.framelayoutid);
                                layoutposition = (item.framelayoutposition);
                                taskposition = (item.postion);
                            }
                            else {
                                if (parseInt(item.framelayoutposition) >= parseInt(layoutposition)) {
                                    layoutid = (item.framelayoutid);
                                    layoutposition = (item.framelayoutposition);
                                    taskposition = (item.postion);
                                }
                            }

                            html += '<li ><span class=\"bt\" style=\"cursor:pointer\" onclick="Program_arrange_SelLayoutRecord(' + item.framelayoutid + ',' + item.postion + ',' + item.framelayoutposition + ')">' + item.framelayoutid + "-" + item.framelayout + '</span><a href="javascript:void(0)">';
                            //html += '<div class="area"><img class="frame_img_bg "  data-frid="' + item.framelayoutid + '"  src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + item.framelayoutid + '_1.jpg"  onerror="find_noimg()"></div><span class=\"bt\" style=\"cursor:pointer\" onclick="Program_arrange_SelLayoutRecord(' + item.framelayoutid + ',' + item.postion + ',' + item.framelayoutposition + ')">' + item.framelayoutid + "-" + item.framelayout + '</span>\r\n<input type="hidden" id="html_' + item.framelayoutid + "_" + item.framelayoutposition + '" value="' + item.htmlstr.replace("\r", "").replace("\n", "") + '" />';
                            html += '<div class="area"><img class="frame_img_bg "  data-frid="' + item.framelayoutid + '"  src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + item.framelayoutid + '_5.jpg"  onerror="find_noimg()"></div>\r\n<input type="hidden" id="html_' + item.framelayoutid + "_" + item.framelayoutposition + '" value="' + "" + '" />';
                            //html += '<span class="bt"></span>';
                            html += '<div class="caozuo">';
                            html += '<span class="insert_before" data-framelayoutposition="' + item.framelayoutposition + '" data-inserted_position="' + item.postion + '" data-inserted_framelayoutid="' + item.framelayoutid + '"> ' + getLanguageMsg("前插", $.cookie("yuyan")) + ' </span><span class="caozuo_del" onclick=" DeleteArrangeLayOut(' + item.framelayoutid + ',' + item.framelayoutposition + ')"> ' + getLanguageMsg("删除", $.cookie("yuyan")) + ' </span>';
                            html += '</div>';
                            html += '</a></li>';
                            havevalue = 1;
                        });
                        html += '<li id="program_arrange_btn_showaddlayout" data-framelayoutposition="0" data-inserted_position="0" data-inserted_framelayoutid="0"><span class="program_add_layout">' + getLanguageMsg("添加布局", $.cookie("yuyan")) + ' </span>+</li>';
                        $("#program_arrange_layoutsellist").html("");
                        $("#program_arrange_layoutsellist").html(html);
                    }
                },
                complete: function () {
                    // $(".frame_img_bg").each(function (i, item) {
                    //      item.src = get_img_src($(item).attr("data-frid"), "<%=Companyid%>");
                    //  })
                }
            });
            if (havevalue == 0) {
                //空节目单时，显示缺省全屏布局
                var html = "";
                var htmlstr = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=gb2312"><title>' + getLanguageMsg("不分屏__(全屏幕)", $.cookie("yuyan")) + '</title></head>\r\n<frameset rows="*" framespacing="0" border="0" frameborder="0">\r\n<frame name="' + getLanguageMsg("全屏窗口", $.cookie("yuyan")) + '" marginwidth="5" marginheight="5" scrolling="no" noresize src="../bkstyle.htm">\r\n<noframes>\r\n<body>\r\n<p>Your browser does not support frame.</p>\r\n</body></noframes>\r\n</frameset>\r\n</html>';
                html += '<li ><span class=\"bt\" style=\"cursor:pointer\" onclick="Program_arrange_SelLayoutRecord(' + 0 + ',' + 0 + ',' + 0 + ')">' + 0 + "-" + getLanguageMsg("不分屏__(全屏幕)", $.cookie("yuyan")) + '</span><a href="javascript:void(0)">';
                html += '<div class="area"><img class="frame_img_bg " data-frid="' + 0 + '" src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + 0 + '_5.jpg"  onerror="find_noimg()"></div>\r\n<input type="hidden" id="html_' + 0 + "_" + 0 + '" value="' + htmlstr.replace("\r", "").replace("\n", ""); + '" />';
                //html += '<span class="bt"></span>';
                html += '</a></li>';
                html += '<li id="program_arrange_btn_showaddlayout" data-framelayoutposition="0" data-inserted_position="0" data-inserted_framelayoutid="0"><span class="program_add_layout">' + getLanguageMsg("添加布局", $.cookie("yuyan")) + ' </span>+</li>';
                $("#program_arrange_layoutsellist").html("");
                $("#program_arrange_layoutsellist").html(html);
            }
            retstr = layoutid + "||" + layoutposition + "||" + taskposition;
            return retstr;
        }
        //右侧系统中所有布局记录列表 供选择可视化编排
        function program_arr_LayoutData() {
            if (haveloadfrlist != 0) {
                return;
            }
            else {
                $.ajax({
                    type: "post",
                    url: '/company/Layout/LayoutHandler.ashx',
                    async: false,
                    dataType: 'text',
                    data: {
                        s: 0,
                        a: "menulist",//布局列表
                        keyword: ""
                    },
                    success: function (data) {
                        haveloadfrlist = 1;
                        //debugger;
                        if (data == "-1") {
                            //LoginTimeOut();///用户没有‘布局管理’ 权限
                        }
                        else {
                            if (data == "-2") {
                                LoginTimeOut();
                            }
                            else {
                                var json = strToJson(data);
                                var html = "";
                                $.each(json.Table, function (idx, item) {
                                    html += '<li><span class=\"bt\" title=' + item.framelayoutid + "-" + item.framelayout +  ' style=\"cursor:pointer\" data-add_framelayoutid="' + item.framelayoutid + '">' + item.framelayoutid + '-' + item.framelayout + '</span><a href="javascript:void(0)">';//style="border:1px solid red"
                                    html += '<div class="area" ><img class="frame_img_bg " data-frid="' + item.framelayoutid + '" src="/privatefiles/<%=Companyid%>/thumbnail/other/fr_' + item.framelayoutid + '_5.jpg" onerror="find_noimg()"></div>\r\n<input type="hidden" id="html_' + item.framelayoutid + '" value="' + item.htmlstr.replace("\r", "").replace("\n", "") + '" />';
                                    html += '</a></li>';
                                });
                                $("#program_arrange_layoutlist").html(html);

                                //  $("#program_arrange_layoutsellist>li:eq(0) .bt").addClass("active");
                            }
                        }

                    }

                });
            }
        }

        //右侧布局列表的列表显示方法

        function Program_Arrange_ShowFrame(d, k) {
            var htmlStr = $("#html_" + d).val();

            htmlStr = htmlStr.replace(new RegExp('border="0"', 'g'), 'border="1"').replace(new RegExp('framespacing="1"', 'g'), 'framespacing="1"');
            $(document.getElementById("fr_" + d).contentWindow.document.body).html(htmlStr);
        }
        
       
        //将素材列表预览点击事件结束


        //将素材添加到节目单
        function addsourcetoMenu(id, thumbnail, itemname, contenttype, sourceid, itemtype, exetask) {//添加：exetask
            if ($("#programIsFiled").val() == "1") {
                TopTrip(getLanguageMsg("已归档 节目单 不能修改", $.cookie("yuyan")), 2);
                return;
            }
            close_ck_icon_right();

            var Menuid = parseInt($("#program_arrange_menuid").val(), 10);
            var Framelayoutid = parseInt($("#program_arrange_layoutid").val(), 10);
            var FramelayoutPosition = parseInt($("#program_arrange_layoutposition").val(), 10);
            var Window = $("#program_arrange_window").val();
            var Itemid = id;
            var Itemname = itemname;

            var Itemtype = itemtype;

            var Taskid = 1;      //不用设，自动获取
            var Taskname = ""; //自动获取
            var Descript = ""; //不用设
            var Postion = 20;

            var Templateid = parseInt($("#program_arrange_tempid").val(), 10);
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
            var Bkpic = "";
            var Options = "";
            var Checkreason = "";
            var Openflag = 0;

            var Userid = 0;
            var Checkuserid = 0;//后台自动判断
            var Checkstatus = 0;

            var retstr = ProgramSlideVal.getdata();

            if (retstr.length > 3) {
                var cookiearry = retstr.split(",");
                Myplayer = parseInt(cookiearry[1], 10);
                Triggertype = parseInt(cookiearry[2], 10);
                Duringtime = parseInt(cookiearry[3], 10) * 3600 + parseInt(cookiearry[4], 10) * 60 + parseInt(cookiearry[5], 10);
                Copyto = parseInt(cookiearry[6], 10);
                if (cookiearry[7] == "true") Copyto = Copyto | 0x02;
                Merit = parseInt(cookiearry[8], 10);
                if (cookiearry[9] == "true") Copyto = Copyto | 0x04;
                Circletime = parseInt(cookiearry[10], 10);
                Circleeveryday = parseInt(cookiearry[11], 10);
                Starttime = cookiearry[12];
                Expiretime = cookiearry[13];
                Zorder = parseInt(cookiearry[14], 10);
                Templateid = parseInt(cookiearry[15], 10);
                Postion = parseInt(cookiearry[17], 10);
                if (cookiearry[18] == "true") Openflag = 1;
                //"参数设置"下的input;  
                Exetask = cookiearry[20];//应用程序名/参数：
                Param = cookiearry[21];//选择应用程序名：获得

                Bkpic = cookiearry[32];
                Options = cookiearry[33];
                if (Triggertype == 1)
                    Triggertime = cookiearry[34];
                else if (Triggertype == 2) {
                    Triggertime = cookiearry[35];
                }
            }
            //if (Exetask=="") {
            //    Exetask = exetask;//Exetask  应用程序 的设置(读取素材的 )
            //}
            
            $.ajax({
                type: 'post',
                url: 'ajax/AddMenu.ashx',
                data: {
                    "menuid": Menuid,
                    "itemid": Itemid,
                    "name": Itemname,//素材名称
                    "win": Window,
                    "lay": Framelayoutid,
                    "itemtype": Itemtype,
                    "tempid": Templateid,
                    "layposition": FramelayoutPosition,
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
                    "myIsFiled": $("#programIsFiled").val()
                },
                async: true,
                dataType: 'text',
                success: function (data) {
                    var json = strToJson(data);
                    var myunCheckStr = "";
                    if (json.taskid > 0) {
                        var contenttypestr = ReContentTypeStr(contenttype);
                        var contenttypestr2 = contenttypestr;
                        var myDuringTime = json.duringTime;//3750秒..
                        myDuringTime = sec_to_time(myDuringTime);//"1:2:30"
                        if (itemtype == "1") {//0素材， 1栏目
                            contenttypestr2 = getLanguageMsg("栏目", $.cookie("yuyan"));
                        }
                        if (json.checkstatus!="1") {
                            myunCheckStr = 'style="background-color: #bab823;"';
                        }
                        $("#program_range_selitemlist li").removeClass("current");//checkstatus
                        $("#program_range_selitemlist").append('<li class="current" data-pid="' + json.taskid + '" data-position="' + json.postion
                            + '" data-duringtime="0" data-id="' + id + '" data-name="' + itemname + '" data-taskname="' + json.taskname
                            + '" data-window="' + Window + '" data-sourceid="' + sourceid + '" data-itemtype="' + itemtype + '" data-contenttype="'
                            + contenttypestr + '" data-tempid="' + Templateid + '" data-checkstatus="' + json.checkstatus
                            + '"><a href="javascript:void(0)" title="[' + contenttypestr2 + ']'
                            + itemname + '"><img src="/images/loading1.gif" height="72" width="96"><span class="time" ' + myunCheckStr + '><b style="display: inline-block;width: 20px;height: 20px;position: absolute;left:5px;top:-1px;background: url(/images/tubiaoa.png) -1px -171px;"></b>'
                            + myDuringTime + '</span><span class="del"></span></a></li>');
                        program_arrange_getthumbnal(json.taskid, thumbnail, contenttype);

                        program_arrange_getSouceInfo(id, contenttype, $("#program_arrange_window").val(), $("#program_arrange_window").val(), $("#program_arrange_tempid").val(), json.taskid, 1);
                        TopTrip(getLanguageMsg("素材添加成功", $.cookie("yuyan")), 1);
                        //素材列表预览点击事件  //.die().live
                       /* $("#program_range_selitemlist li.current").live("click", function () {
                            
                            var myCheckStatus = $(this).attr("data-checkstatus");
                            var taskid = $(this).attr("data-pid");
                            var itemid = $(this).attr("data-id");
                            var sourceid = $(this).attr("data-sourceid");
                            var itemname = $(this).attr("data-name");
                            var taskname = $(this).attr("data-taskname");
                            var duringtime = $(this).attr("data-duringtime");
                            var itemtype = $(this).attr("data-itemtype");
                            var contenttype = $(this).attr("data-contenttype");
                            var tempid = $(this).attr("data-tempid");
                            var position = $(this).attr("data-position");
                            var window = $(this).attr("data-window");//有的时候，现在在本窗口内的节目项实际窗口名并不是布局内的窗口名（编排后去修改布局内的窗口名了）,此时要重新修改下节目项后就可一致了
                            $("#program_arrange_taskid").val(taskid);
                            $("#program_arrange_selscid").val(sourceid);
                            $("#program_arrange_selct").val(contenttype);
                            $("#program_arrange_seltempid").val(tempid);
                            if (!$(this).hasClass("current") || window != $("#program_arrange_window").val()) {// 点击时候不重复加载
                                program_arrange_getSouceInfo(sourceid, contenttype, window, $("#program_arrange_window").val(), tempid, taskid, 1);
                                $(this).addClass("current").siblings("li").removeClass("current");

                            }
                            //if ($("#h_edit_program_menu_taskid").val() != taskid) { //没有点击同一个节目项
                            //    $("#program_arrange_editpage").html("");//重新加载 节目项
                            //}
                            //编辑节目项 页面，不重复加载
                            //if ($("#program_arrange_editpage").text().length > 100 && $("#program_arrange_editpage").css("display") == "none") {
                            //    $("#program_arrange_editpage").css("display","block");
                            //} else if ($("#program_arrange_editpage").text().length < 100) {
                            $("#program_arrange_editpage").load("edit_program_menu.aspx", { "taskid": taskid, "position": position, "taskname": taskname, "itemname": itemname, "menuid": $("#program_arrange_menuid").val(), "type": $("#program_arrange_pagetype").val(), "itemid": itemid, "checkstatus": myCheckStatus, "window": $("#program_arrange_window").val(), "framelayoutid": $("#program_arrange_layoutid").val(), "fposition": $("#program_arrange_layoutposition").val() }, function () {
                                $("#program_arrange_editpage").slideDown();//下拉菜单 出现

                                //if ($.cookie("ProgramSlide") == "0") {//如果cookie 为0 触发click
                                //    $("#edit_menu_add_ex").trigger("click");
                                //}
                            });
                            //}

                        });*/
                    }
                    else if (data == "-100") {
                        TopTrip(getLanguageMsg("已归档 节目单 不能修改", $.cookie("yuyan")), 2);
                    }
                    else if (data == -1) {
                        LoginTimeOut();
                    }
                    else {
                        TopTrip(getLanguageMsg("系统错误，请联系管理员！", $.cookie("yuyan")), 3);
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
        //保存节目项排序
        function SaveMenuPosition() {
            if ($("#programIsFiled").val() == "1") {//节目单归档， 不能修改
                return;
            }
            var itemlist = $("#program_range_selitemlist li").map(function () { return $(this).attr("data-pid"); }).get();
            $.ajax({
                type: 'post',
                url: 'ajax/saveposition.ashx',
                async: false,
                data: {
                    "menuid": $("#program_arrange_menuid").val(),
                    "framelayout": $("#program_arrange_layoutid").val(),
                    "framelayoutposition": $("#program_arrange_layoutposition").val(),
                    "window": $("#program_arrange_window").val(),
                    "idlist": "" + itemlist + ""
                },
                dataType: 'text',
                success: function (data) {

                    TopTrip(getLanguageMsg("保存成功!", $.cookie("yuyan")), 1);
                }
            })
        }

        //$("a[name=savemenuposition]").die().live("click", function () {

        //    var type = $(this).attr("data-type");
        //    var newId = $(this).attr("data-id");
        //    if (type == 1) {

        //    }
        //});
        ////重置节目项排序
        //$("a[name=resetmenuposition]").die().live("click", function () {

        //    window.location.reload();
        //});
        //找不到素材图片
        function no_find(contenttype, obj) {
            $(obj).attr('src', "/images/img_new/default_" + contenttype + "_3.png");
        }

        
        //拖动添加素材
        $("#program_arrange_source_list .mod_sclist .nr").die().live("mousedown", function (e) {//鼠标按下，鼠标变移动标志，克隆元素，并确定新克隆元素位置
            $("body").append('<div class="mod_sclist clone">' + $(this).parent().parent(".mod_sclist").html() + '</div>');
            $(".clone .borbg").css({ "background": "#ccc" });
            $("body").css('cursor', 'move');
            $(".clone").css('left', e.pageX - 50);
            $(".clone").css('top', e.pageY - 220);
            $("body").addClass("no_select");
        });
        //拖拽添加栏目
        $("#program_arrange_column_list .mod_sclist .nr").die().live("mousedown", function (e) {//鼠标按下，鼠标变移动标志，克隆元素，并确定新克隆元素位置
            $("body").append('<div class="mod_sclist clone">' + $(this).parent().parent(".mod_sclist").html() + '</div>');
            $(".clone .borbg").css({ "background": "#ccc" });
            $("body").css('cursor', 'move');
            $(".clone").css('left', e.pageX - 50);
            $(".clone").css('top', e.pageY - 220);
            $("body").addClass("no_select");
        });
        //选中节目单中的布局，设置布局开始位置及对应的布局块号。实际上要在插入的时候检测下才对，防止别人修改了。
        function Program_arrange_SelLayoutRecord(id, position, frpositon) {

            $("#program_arrange_waitlayoutid").val(id);
            $("#program_arrange_waitlayoutposition").val(frpositon);
            //$("#program_arrange_waitneedinsertlayoutid").val(0);
            $("#program_arrange_waittaskposition").val(position);

        }
        //显示选中节目单中布局、其内窗口及节目项。如果为空，则显示缺省全屏幕布局（未用）
        function Program_arrange_PreLayoutRecord(id, position, frpositon) {
            if (id == "") {
                id = 0;
            }
            $("#program_arrange_waitneedinsertlayoutid").val(id);
            $("#program_arrange_waitlayoutposition").val(frpositon);
            program_arrange_bindlayoutname();
        }

        //页面装载完毕后，获取节目单中对应位置的布局html
        function Program_arrange_LayoutRecord(id, menuid, position, fposition, add_framelayoutid) {
            close_ck_icon_right();
            
            var haveset = 0;
            if (id == "") {
                id = 0;
            }
            $.ajax({
                type: "post",
                url: '/company/Layout/LayoutHandler.ashx',
                async: false,
                dataType: 'text',
                data: {
                    a: "record",
                    id: id,
                },
                success: function (data) {
                    if (data == "-1") {
                        // LoginTimeOut();//用户没有‘布局管理’ 权限
                    }
                    else if (data == "-2") {
                        LoginTimeOut();
                    }
                    else {
                        var my = data.split('||');
                        var obj = $(document.getElementById('Program_ArrangeMainFrame').contentWindow.document.body);
                        $("#usedLayoutName").val(my[1]);//保存 节目单使用的 布局名称
                        var html = my[4].replace(new RegExp('border="0"', 'g'), 'border="1"').replace(new RegExp('framespacing="10"', 'g'), 'framespacing="0"').replace(new RegExp('../bkstyle.htm', 'g'), 'programBkstyle.htm').replace(new RegExp('../framebk.htm', 'g'), 'programBkstyle.htm');
                        obj.html(html);

                        program_arrange_bindlayoutname();
                        haveset = 1;
                    }
                }
            });
            if (haveset == 0) {
                var fullframelayout = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=gb2312"><title>' + getLanguageMsg("不分屏__(全屏幕)", $.cookie("yuyan")) + '</title></head>\r\n<frameset rows="*" framespacing="0" border="0" frameborder="0">\r\n<frame name= "' + getLanguageMsg("全屏窗口", $.cookie("yuyan")) + '" marginwidth="5" marginheight="5" scrolling="no" noresize src="../bkstyle.htm">\r\n<noframes>\r\n<body>\r\n<p>Your browser does not support frame.</p>\r\n</body></noframes>\r\n</frameset>\r\n</html>';
                fullframelayout = fullframelayout.replace(new RegExp('border="0"', 'g'), 'border="1"').replace(new RegExp('framespacing="10"', 'g'), 'framespacing="0"').replace(new RegExp('../bkstyle.htm', 'g'), 'programBkstyle.htm').replace(new RegExp('../framebk.htm', 'g'), 'programBkstyle.htm');
                $(document.getElementById('Program_ArrangeMainFrame').contentWindow.document.body).html(fullframelayout);
                program_arrange_bindlayoutname();
            }
        }
        //点击布局列表"确定"更换节目单布局
        //insert=0表示插入新布局 insert=1是预览
        function program_arrange_changelayoutid(insert) {
            if ($("#programIsFiled").val() == "1") {//节目单归档， 不能插入布局
                close_ck_icon_right();//关闭右侧
                return;
            }
            if ($("#program_arrange_layoutid").val() == $("#program_arrange_waitlayoutid").val() && $("#program_arrange_taskposition").val() == $("#program_arrange_waittaskposition").val() && $("#program_arrange_layoutposition").val() == $("#program_arrange_waitlayoutposition").val()) {
                if (insert == 0) {//前插时还要判断插入的布局号是否相同，不能判断这个，因为两次可以插入相同布局。不选择则 插入相同 布局id
                    ;//if ($("#program_arrange_needinsertlayoutid").val() == $("#program_arrange_waitneedinsertlayoutid").val()) return;
                }
                else {//没操作 点击 确定 返回
                    close_ck_icon_right();//关闭右侧
                    return;
                }
            }
            var needinsertlayoutid = $("#program_arrange_needinsertlayoutid").val();

            $("#program_arrange_layoutid").val($("#program_arrange_waitlayoutid").val());
            $("#program_arrange_taskposition").val($("#program_arrange_waittaskposition").val());
            $("#program_arrange_layoutposition").val($("#program_arrange_waitlayoutposition").val());
            if (insert == 0) {
                $("#program_arrange_needinsertlayoutid").val($("#program_arrange_waitneedinsertlayoutid").val());
            }
            close_ck_icon_right();//关闭右侧

            var inserted_position = $("#program_arrange_taskposition").val(); //节目单中，选中布局块第一个节目项 postion位置（该布局块中最小的），按postion排过序的
            var framelayoutposition = $("#program_arrange_layoutposition").val();//节目单中，选中布局块对应块排序位置
            var inserted_framelayoutid = $("#program_arrange_layoutid").val();//节目单中，选中布局块对应布局布局id
            var add_framelayoutid = $("#program_arrange_waitneedinsertlayoutid").val();//要向节目单中插入的新布局id

            if ((insert == 0) && (needinsertlayoutid == add_framelayoutid)) {
                //相同位置不能插入相同布局号布局，因为本来就是同一片布局了
                return;
            }
            $("#program_arrange_needinsertlayoutid").val(add_framelayoutid);
            if (insert == 0) {
                program_range_getlayoutposition(inserted_position, framelayoutposition, inserted_framelayoutid, add_framelayoutid, insert);
                framelayoutposition = $("#program_arrange_layoutposition").val();
                add_framelayoutid = $("#program_arrange_layoutid").val();
                inserted_position = $("#program_arrange_taskposition").val();
                Program_arrange_LayoutRecord($("#program_arrange_needinsertlayoutid").val(), $("#program_arrange_menuid").val(), $("#program_arrange_taskposition").val(), $("#program_arrange_layoutposition").val(), $("#program_arrange_needinsertlayoutid").val());
            }
            else
                Program_arrange_LayoutRecord($("#program_arrange_layoutid").val(), $("#program_arrange_menuid").val(), $("#program_arrange_taskposition").val(), $("#program_arrange_layoutposition").val(), $("#program_arrange_needinsertlayoutid").val());
            program_arrange_bindlayoutname();
            if (insert == 0) {
                program_arrange_getselFrameLayout();//添加后更新布局显示
                $("#program_arrange_taskposition").val(inserted_position); //节目单中，选中布局块第一个节目项 postion位置（该布局块中最小的），按postion排过序的
                $("#program_arrange_layoutposition").val(framelayoutposition);//节目单中，选中布局块对应块排序位置
                $("#program_arrange_layoutid").val(add_framelayoutid);//节目单中，选中布局块对应布局布局id
                $("#program_arrange_needinsertlayoutid").val(0);//节目单中，选中布局块对应布局布局id
                $("#program_arrange_waittaskposition").val(inserted_position); //节目单中，选中布局块第一个节目项 postion位置（该布局块中最小的），按postion排过序的
                $("#program_arrange_waitlayoutposition").val(framelayoutposition);//节目单中，选中布局块对应块排序位置
                $("#program_arrange_waitlayoutid").val(add_framelayoutid);//节目单中，选中布局块对应布局布局id
                $("#program_arrange_waitneedinsertlayoutid").val(0);//节目单中，选中布局块对应布局布局id
            }
            //8/1后加切到 布局切换。
            //8.4注释掉放到全局
            $("program_arrange_btn_showlayoutlist").addClass("current").siblings().removeClass("current");
            $("#program_arrange_layoutsellist_div").slideDown();
            $("#program_arrange_layoutlist_div").slideUp();
            $("#program_arrange_scale_div").slideUp();
            //添加、切换布局：编辑节目项--隐藏。
            $("#program_arrange_editpage").slideUp();
            //切换布局之后：第一个节目项 选中。
            if ($("#program_range_selitemlist li").length > 0) {
                $("#program_range_selitemlist li:first").addClass("current").siblings().removeClass("current");
                //$("#program_range_selitemlist li:first").click();// 显示编辑节目项
            }
        }

        //点击节目单中布局列表返回
        function program_arrange_recoverylayoutid() {
            if ($("#programIsFiled").val() == "1") {//节目单归档， 布局不变
                close_ck_icon_right();
                return;
            }
            $("#program_arrange_waitlayoutid").val($("#program_arrange_layoutid").val());
            $("#program_arrange_waittaskposition").val($("#program_arrange_taskposition").val());
            $("#program_arrange_waitlayoutposition").val($("#program_arrange_layoutposition").val());
            $("#program_arrange_waitneedinsertlayoutid").val($("#program_arrange_needinsertlayoutid").val());
            close_ck_icon_right();
            //Program_arrange_LayoutRecord($("#program_arrange_layoutid").val(), $("#program_arrange_menuid").val(), $("#program_arrange_taskposition").val(), $("#program_arrange_layoutposition").val(), $("#program_arrange_needinsertlayoutid").val());
            //后加切到 布局切换。
            $("program_arrange_btn_showlayoutlist").addClass("current").siblings().removeClass("current");
            $("#program_arrange_layoutsellist_div").slideDown();
            $("#program_arrange_layoutlist_div").slideUp();
            $("#program_arrange_scale_div").slideUp();
        }

        //根据布局获布局下的所有窗口
        function program_arrange_bindlayoutname() {
            $("#program_arrange_layout_windows").empty();
            var windownamelist = "";
            var framses = document.getElementById('Program_ArrangeMainFrame').contentWindow.frames;
            var i = 0;
            var windowsname = "";
            if (framses.length == 0) {
                // windowsname = getLanguageMsg("0-全屏窗口", $.cookie("yuyan"));
                windowsname = "0-全屏窗口";
                $("#program_arrange_layout_windows").append('<li data-isext="1"><a href="javascript:void(0)" onclick="changewindowname(\'' + windowsname + '\',0,0)">' + windowsname + '</a></li>');
                i = 1;
                if (windownamelist=="")
                    windownamelist = windowsname;
                else
                    windownamelist = windownamelist + "," + windowsname;
            }
            else {
                for (i = 0; i < framses.length; i++) {
                    $("#program_arrange_layout_windows").append('<li data-isext="1"><a href="javascript:void(0)"  onclick="changewindowname(\'' + i + '-' + framses[i].name + '\',0,0)">' + i + '-' + framses[i].name + '</a></li>');

                    if (i == 0) {
                        windowsname = i + '-' + framses[i].name;
                        program_arrange_getwindowHtml(i + '-' + framses[i].name, 1);
                        if (windownamelist == "")
                            windownamelist = i + '-' + framses[i].name;
                        else
                            windownamelist = windownamelist + "," + i + '-' + framses[i].name;
                    }
                    else {
                        program_arrange_getwindowHtml(i + '-' + framses[i].name, 0);
                        if (windownamelist == "")
                            windownamelist =i + '-' + framses[i].name;
                        else
                            windownamelist = windownamelist + "," + i + '-' + framses[i].name;
                    }
                }
            }
            for (j = 1; j <= 6; j++) {
                $("#program_arrange_layout_windows").append('<li data-isext="0"><a href="javascript:void(0)"  onclick="changewindowname(\'' + (j + i - 1) + '-附加任务窗口' + j + '\',1,0)">' + (j + i - 1) + '-附加任务窗口' + j + '</a>');
                if (windownamelist == "")
                    windownamelist = (j + i - 1) + '-附加任务窗口'+ j;
                else
                    windownamelist = windownamelist + "," + (j + i - 1) + '-附加任务窗口' + j;
            }
            windownamelist = windownamelist + ",0-,";
            $("#program_arrange_indexWindow").html($("#usedLayoutName").val() + "  ,  " + windowsname);
            $("#program_arrange_indexWindow").attr("title", $("#usedLayoutName").val() + "  ,  " + windowsname);
            $("#program_arrange_window").val(windowsname);
            $("#program_arrange_windowlist").val(windownamelist);
            program_arrange_getitemlist(windowsname);
            //if (i > 0) {
            //    setTimeout(function () {//让第一个窗口处于选中状态，在装入html过程中就定位，会报错，这里稍后访问即可
            //        document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowsname))[0].contentWindow.document.body.style.borderTop = "2px solid #f00";
            //        if ($("#program_arrange_selscid").val() == "") $("#program_arrange_selscid").val("0");
            //        if ($("#program_arrange_taskid").val() == "") $("#program_arrange_taskid").val("0");
            //        if ($("#program_arrange_selct").val() == "") $("#program_arrange_selct").val("0");
            //        if ($("#program_arrange_window").val() == "") $("#program_arrange_window").val("0-全屏窗口");
            //        if ($("#program_arrange_seltempid").val() == "") $("#program_arrange_seltempid").val("0");
            //        program_arrange_getSouceInfo($("#program_arrange_selscid").val(), $("#program_arrange_selct").val(), $("#program_arrange_window").val(), $("#program_arrange_seltempid").val(), $("#program_arrange_taskid").val(),1);
            //    }, 300);
            //}

            if ($("#program_arrange_layout_windows").children("li").length >= 10) {
                $("#program_arrange_layout_windows").css({ "overflowY": "scroll" });
            } else {
                $("#program_arrange_layout_windows").css({ "overflowY": "hidden" });
            }
        }

        // if ($.cookie("PreviewRos") == null || "0") {
        //    $.cookie("PreviewRos", "1920" | "1000", { expires: 7 });
        // }
        //改变节目单分辨率 ，自定义

        function program_arrange_changeros() {
            var width = parseInt($("#program_arrange_fbl_width").val(), 10);
            var height = parseInt($("#program_arrange_fbl_height").val(), 10);
            $.cookie("PreviewRos", width + "|" + height, { expires: 7 });
            if (width == "" || height == "") {
                width = 1440;
                height = 900;
            }
            if (height > width) {
                if (height > 560) {
                    width = 560 * width / height;
                    height = 560;
                }//7/31改
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }
                //  else {//7/31改
                //      height=440
                //  }
            }
            else {
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }//7/31改
                if (height > 440) {
                    width = 440 * width / height;
                    height = 440;
                }

            }
           
            //显示区域的大小
            //$("#program_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": -width / 2, "margin-top": -height / 2 });
            $("#program_arrange_area_bg_width").val(width);
            $("#program_arrange_area_bg_height").val(height);
            program_arrange_showbg();
        }
        //重置节目单分辨率
        function program_arrange_resetros() {
            var width = parseInt($("#program_arrange_fbl_width").val(), 10);
            var height = parseInt($("#program_arrange_fbl_height").val(), 10);
            $.cookie("PreviewRos", width + "|" + height, { expires: 7 });
            $("#program_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": -width / 2, "margin-top": -height / 2 });
            $("#program_arrange_area_bg_width").val(width);
            $("#program_arrange_area_bg_height").val(height);
            program_arrange_showbg();
        }
        //临时预览分辨率,单选预览
        $("input[name=program_arrange_fbl_radio]").die().live("click", function () {
            var width = parseInt($(this).val().split("×")[0], 10);
            var height = parseInt($(this).val().split("×")[1], 10);
            $.cookie("PreviewRos", width + "|" + height, { expires: 7 });
            if (height > width) {
                if (height > 560) {
                    width = 560 * width / height;
                    height = 560;
                }
                if (width > 960) {
                    height = 960 * height / width;
                    width = 960;
                }
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
            }
            $("#program_arrange_area_bg_width").val(width);
            $("#program_arrange_area_bg_height").val(height);
            
            program_arrange_showbg();
        });
        //分辨率预览重置 节目单编排窗口的宽高
        function program_arrange_showbg() {
            var width = 960;
            var height = 420;
            if ($("#program_arrange_area_bg_width").val() != "0" && $("#program_arrange_area_bg_width").val() != "" && $("#program_arrange_area_bg_height").val() != "0" && $("#program_arrange_area_bg_height").val() != "") {
                width = parseInt($("#program_arrange_area_bg_width").val(), 10);
                height = parseInt($("#program_arrange_area_bg_height").val(), 10);
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
                $("#program_arrange_area_bg").parent().animate({ "height": height + 20 });
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

            }

            $("#program_arrange_area_bg").animate({ "width": width + "px", "height": height + "px", "margin-left": (-1 * width / 2) + "px", "margin-top": (-1 * height / 2) + "px" });

        }
        //获取某个窗口的节目项对应第一个素材的缩略呈现在编排窗口
        function program_arrange_getwindowHtml(windowsname, changeBorder) {
            var layoutposition = $("#program_arrange_layoutposition").val();
            var menuid = $("#program_arrange_menuid").val();

            $.ajax({
                type: "post",
                url: 'ajax/getfirstitem.ashx',
                async: false,
                dataType: 'text',
                data: {
                    menuid: $("#program_arrange_menuid").val(),
                    layoutid: $("#program_arrange_layoutid").val(),
                    lotpos: layoutposition,
                    windows: windowsname
                },
                success: function (data) {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        program_arrange_getSouceInfo(item.sourceid, item.contenttype, windowsname, windowsname, item.tempid, item.taskid, changeBorder);
                    });
                }
            });
        }
        /**选中或新添加的节目项加载到预览窗口*/
        function program_arrange_getSouceInfo(scid, contenttype, windowname, framewindowsname, tempid, taskid, changeBorder) {
            var selframe = document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(framewindowsname))[0];

            if (selframe != null || selframe != undefined) {
                if (scid == null||scid=="") {
                    selframe.src = "programBkstyle.htm";
                }else{
                    setTimeout(function () {
                        selframe.src = "/company/program/FilePreview.aspx?taskid=" + taskid + "&itemid=" + scid + "&templateid=" + tempid + "&w=" + windowname + "&desript=&cb=" + changeBorder + "&t=" + new Date().getTime();
                    },200);//延迟加载，避免白屏
                }
            }
        }
        //function zyygetStyle() {
        //}
        //获取某窗口的节目项
        function program_arrange_getitemlist(windowsname, taskid) {
            
            $.ajax({
                type: 'post',
                url: 'ajax/getitemlist.ashx',
                data: {
                    "menuid": $("#program_arrange_menuid").val(),
                    "layoutid": $("#program_arrange_layoutid").val(),
                    "lotpos": $("#program_arrange_layoutposition").val(),
                    "windows": windowsname,
                    "windowlist": $("#program_arrange_windowlist").val()
                },
                async: false,
                dataType: 'text',
                success: function (data) {
                    
                    if (data != -1) {
                        var json = strToJson(data);
                        program_arrange_showitemlist(json, windowsname, taskid);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        }
        //某窗口节目项对应素材的展示列表
        function program_arrange_showitemlist(json, windowsname, taskid) {
            
            $("#program_range_selitemlist").empty();
            var typeIcon = '';//节目触发类型， 显示的图标
            var myuncheckstr = "";
            $.each(json.Table, function (idx, item) {
                //do...根据 节目触发类型， 显示不同图标 
                //节目触发类型， 显示的图标
                typeIcon = '<b style="display: inline-block;width: 20px;height: 20px;position: absolute;left:5px;top:-1px;background: icon"></b>';
                switch (parseInt(item.triggertype)) {
                    case 0:
                        typeIcon = typeIcon.replace("icon", "url('/images/tubiaoa.png') repeat scroll -1px -171px");
                        break;
                    case 3:
                        typeIcon = typeIcon.replace("icon", "url('/images/tubiaoa.png') repeat scroll -19px -171px");
                        break;
                    case 1:
                        typeIcon = typeIcon.replace("icon", "url('/images/tubiaoa.png') repeat scroll -39px -171px");
                        break;
                    case 2:
                        typeIcon = typeIcon.replace("icon", "url('/images/tubiaoa.png') repeat scroll -62px -171px");
                        break;
                    case 4:
                        typeIcon = typeIcon.replace("icon", "url('/images/tubiaoa.png') repeat scroll -82px -171px");
                        break;
                    case 5:
                        typeIcon = typeIcon.replace("icon", "url('/images/tubiaoa.png') repeat scroll -104px -171px");
                        break;
                    default:
                        typeIcon = typeIcon.replace('icon', '');
                }
                var juststyle = "";
                //item.triggertype // 0接前任务, 1绝对年月时间, 2每天时间, 3手动, 4空闲, 5暂不触发
                var contenttypestr = ReContentTypeStr(item.contenttype);//triggertype
                var contenttypestr2 = "";
                //item.myplayer  //2操作系统自检测 ,3专用应用程序 ,4远程指令 ,5专用文件传输
                var newTitle = "";
                switch (parseInt(item.myplayer)) {
                    case 2:
                        newTitle = getLanguageMsg("操作系统自检测", $.cookie("yuyan")); break;
                    case 3:
                        newTitle = getLanguageMsg("专用应用程序", $.cookie("yuyan")); break;
                    case 4:
                        newTitle = getLanguageMsg("远程指令", $.cookie("yuyan")); break;
                    case 5:
                        newTitle = getLanguageMsg("专用文件传输", $.cookie("yuyan")); break;
                }
                if (item.itemtype == "0" && newTitle != "") {//0素材， 1栏目
                    contenttypestr2 = "-" + newTitle;
                } else if (item.itemtype == "1") {
                    contenttypestr = getLanguageMsg("栏目", $.cookie("yuyan"));
                    if (newTitle != "") { contenttypestr2 = "-" + newTitle; }
                }
                if (item.window != $("#program_arrange_window").val()) juststyle = "style='background-color:#06ff00;'" + "title='" + item.window + "'";
                if (json.checkstatus != "1" && juststyle=="") {
                    myuncheckstr = 'style="background-color: #bab823;"';
                }
                var triggertimeColor = "";
                //根据时间判断绝对时间出发的节目项目是否有效
                if (item.triggertime != "") {
                    
                    var time1=item.triggertime;
                    var tempdate = new Date();
                    if (item.triggertime.indexOf("-") == -1) { time1 = tempdate.getFullYear() + "-" + (tempdate.getMonth() + 1) + "-" + tempdate.getDate() + " " + time1; }
                    time1 = new Date(time1.replace(/-/g, '/'));
                    if (time1 < tempdate) {//判断触发时间是否过期,如果已经过期就变成灰色
                        triggertimeColor = ' style="background:#F00;"';
                    }
                }

                $("#program_range_selitemlist").append('<li ' + ' data-pid="' + item.taskid + '" data-position="' + item.position + '" data-id="' + item.itemid + '" data-name="' + item.itemname + '" data-taskname="' + item.taskname + '" data-window="' + item.window + '" data-sourceid="' + item.sourceid + '" '
                    + 'data-duringtime="' + item.duringtime + '" data-itemtype="' + item.itemtype + '"'
                    + ' data-checkstatus="' + item.checkstatus + '" data-triggertime="' + item.triggertime + '"' 
                    + ' data-contenttype="' + contenttypestr + '" data-tempid="' + item.tempid + '" >'
                    + '<a   title="[' + contenttypestr + ']' + item.itemname + contenttypestr2 + '"><img src="/images/loading1.gif" height="72" width="96" onerror="no_find(' + item.contenttype + ',this)">'
                    + '<span class="time" ' + juststyle + triggertimeColor+ '>' + typeIcon + formatTime(item.duringtime) + '</span><span class="del"></span></a></li>');
                program_arrange_getthumbnal(item.taskid, item.thumbnail, item.contenttype);
            })
            var $currentLi = $("#program_range_selitemlist li:first");
            if (typeof (taskid) != undefined && taskid != undefined) {
                $currentLi = $("#program_range_selitemlist li[data-pid=" + taskid + "]");
            }
            $("#program_range_taskid").val($currentLi.attr("data-pid"));
            $("#program_arrange_selscid").val($currentLi.attr("data-id"));
            $("#program_arrange_seltempid").val($currentLi.attr("data-tempid"));
            //点击窗口之后：第一个节目项 选中。
            if ($("#program_range_selitemlist li").length > 0) {
                $("#program_range_selitemlist li:first").addClass("current").siblings().removeClass("current");
                //$("#program_range_selitemlist li:first").click();// 显示编辑节目项
            }
            

            //if (juststyle != "") $("#program_range_selitemlist li:first").css("border", "3px solid #ff0;");
        }
        //获取节目编排窗口下方已选择节目项的预览缩略图
        function program_arrange_getthumbnal(taskid, thumbnail, contenttype) {
            $.ajax({
                type: 'post',
                url: '/company/ajax/getthumbnnail.ashx',
                async: false,
                data: {
                    imgname: thumbnail,
                    st: 2,
                    t: contenttype
                },
                dataType: 'text',
                success: function (data) {
                    $("#program_range_selitemlist li[data-pid=" + taskid + "]").children("a").children("img").attr("src", data);
                }
            })
        }
        //窗口名前面加 序号的  去掉序号  只保留窗口名。以-隔开
        function getonlywindowname(indexwindowname) {
            var loc = indexwindowname.indexOf("-");
            if (loc >= 0) {
                return indexwindowname.substring(loc + 1);
            } else {
                return indexwindowname;
            }
        }
        //点击窗口改变窗口事件-----type为1时代表隐藏窗口,checkflag=1表示要检查是否给窗口名前补充序号
        function changewindowname(windowsname, type, checkflag, taskid) {
            if (windowsname == savewindowsname && type == savetype && checkflag == savecheckflag) {
                $("#program_arrange_windows_div").animate({ "left": -200 });
                return;
            }
            savewindowsname = windowsname;
            savetype = type;
            savecheckflag = checkflag;
            if (checkflag == 1) {
                var txtindexvalue = "";
                var tmpstr = "";
                //循环txtindexvalue中值，处理的到
                $("#program_arrange_layout_windows li").each(function () {
                    txtindexvalue = $(this).children("a").text();
                    tmpstr = getonlywindowname(txtindexvalue);
                    if (windowsname == tmpstr) {
                        windowsname = txtindexvalue;
                        //跳出循环
                        return false;
                    }
                });
            }
            $("#program_arrange_indexWindow").html($("#usedLayoutName").val() + "  ,  " + windowsname);
            $("#program_arrange_indexWindow").attr("title", $("#usedLayoutName").val() + "  ,  " + windowsname);
            if (type == 1) {
                $("#program_arrange_window").val(windowsname);
                program_arrange_getitemlist(windowsname, taskid);
                $("#program_arrange_layout_windows li[data-isext=1]").each(function () {
                    var windname = $(this).children("a").text();
                    var othwin = document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windname))[0];
                    if (othwin != null && othwin != undefined) {
                        othwin.contentWindow.document.body.style.borderTop = "none";
                    }
                });
            }
            else {
                $("#program_arrange_window").val(windowsname);
                $("#program_arrange_layout_windows li[data-isext=1]").each(function () {
                    var windname = $(this).children("a").text();
                    var othwin = document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windname))[0];
                    if (othwin != null && othwin != undefined) {
                        othwin.contentWindow.document.body.style.borderTop = "none";
                    }
                });
                //alert(windowsname);
         debugger;
                if (document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowsname)).length > 0)
                    document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowsname))[0].contentWindow.document.body.style.borderTop = "2px solid #f00";

                program_arrange_getitemlist(windowsname, taskid);
            }
            $("#program_arrange_windows_div").animate({ "left": -200 });
        }
        //设置默认窗口 ，顶部 红色边框
        function setDefaultWindow(windowname,isDelay) {
           // debugger;//默认选择第一个。。。。
            var indexwindow = document.getElementById('Program_ArrangeMainFrame').contentWindow.frames[0];
            if (indexwindow.name == windowname) {
                if (document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowname)).length > 0)
                    document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowname))[0].contentWindow.document.body.style.borderTop = "2px solid #f00";
            }
            if (isDelay == "yanshi") {//删除完 窗口中的素材，不跳转到其他窗口，确保当前选择的窗口。
                setTimeout(function () {
                    document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowname))[0].contentWindow.document.body.style.borderTop = "2px solid #f00";
                }, 300);
                
            }
            //var indexwindow = document.getElementById('Program_ArrangeMainFrame').contentWindow.frames;
            //for(var i=0;i<indexwindow.length;i++){
            //    if (indexwindow[i].name == windowname) {
            //        if (document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowname)).length > 0)
            //            document.getElementById('Program_ArrangeMainFrame').contentWindow.document.getElementsByName(getonlywindowname(windowname))[0].contentWindow.document.body.style.borderTop = "2px solid #f00";
            //    } 
            //}
        }

        //全屏预览方法
        function Program_arrange_FullView() {
            var layid = $("#program_arrange_layoutid").val();
            var win = $("#program_arrange_window").val()
            var laypos = $("#program_arrange_layoutposition").val();
            var sourceid = $("#program_arrange_selscid").val();
            var menuid = $("#program_arrange_menuid").val();
            var contenttype = $("#program_arrange_selct").val();
            var tempid = $("#program_arrange_seltempid").val();
            window.open("FullScreenView.aspx?sid=" + sourceid + "&lid=" + layid + "&w=" + win + '&lp=' + laypos + '&mid=' + menuid + "&ct=" + contenttype + "&temp=" + tempid);
        }

        //将秒数转换为时分秒
        function formatTime(seconds) {

            var hour = parseInt(seconds / 3600);

            var minutes = parseInt((seconds % 3600) / 60);
            var ss = (seconds % 3600) % 60;

            return hour + ":" + minutes + ":" + ss;
        }

        //根据素材类型返回素材类型文本
        function ReContentTypeStr(contenttype) {
            var contenttypestr = getLanguageMsg("未知类型", $.cookie("yuyan"));
            if (contenttype == 0) {
                contenttypestr = getLanguageMsg("自适应文件", $.cookie("yuyan"));
            }
            if (contenttype == 1) {
                contenttypestr = getLanguageMsg("文本", $.cookie("yuyan"));
            } if (contenttype == 2) {
                contenttypestr = getLanguageMsg("网页", $.cookie("yuyan"));
            } if (contenttype == 3) {
                contenttypestr = getLanguageMsg("图片", $.cookie("yuyan"));
            } if (contenttype == 4) {
                contenttypestr = getLanguageMsg("通知(静态)", $.cookie("yuyan"));
            } if (contenttype == 5) {
                contenttypestr = getLanguageMsg("通知(向上滚动文本)", $.cookie("yuyan"));
            } if (contenttype == 6) {
                contenttypestr = getLanguageMsg("字幕(向左滚动文本)", $.cookie("yuyan"));
            } if (contenttype == 7) {
                contenttypestr = getLanguageMsg("动画", $.cookie("yuyan"));
            } if (contenttype == 8) {
                contenttypestr = getLanguageMsg("Office文稿", $.cookie("yuyan"));
            } if (contenttype == 9) {
                contenttypestr = getLanguageMsg("音频", $.cookie("yuyan"));
            } if (contenttype == 10) {
                contenttypestr = getLanguageMsg("视频/网络视频/电视", $.cookie("yuyan"));
            } if (contenttype == 11) {
                contenttypestr = getLanguageMsg("操作系统自检测", $.cookie("yuyan"));
            } if (contenttype == 12) {
                contenttypestr = getLanguageMsg("专用应用程序", $.cookie("yuyan"));
            } if (contenttype == 13) {
                contenttypestr = getLanguageMsg("远程命令", $.cookie("yuyan"));
            }
            if (contenttype == 14) {
                contenttypestr = getLanguageMsg("专用文件传输", $.cookie("yuyan"));
            }
            if (contenttype == 15) {
                contenttypestr = getLanguageMsg("栏目", $.cookie("yuyan"));
            }
            //if (contenttype == 14) {
            //    contenttypestr = "栏目";
            //}
            return contenttypestr;
        }

        $(function () {
            //传入menuid
            $("#program_arrange_btn_showlayoutlist").attr("data-menuid", $("#program_arrange_menuid").val());
            /**滚动操作开始********************************/
            $(".next").click(function () {

                var left = parseInt($("#program_range_selitemlist").css("left"));
                var itemcount = $("#program_range_selitemlist li").length;
                if (itemcount > 8) {
                    if (left > (-1 * (itemcount - 8) * 108)) {

                        $("#program_range_selitemlist").animate({ "left": (left - 108) }, { duration: 200, queue: false });
                    }
                    else {
                        $("#program_range_selitemlist").stop().animate({ "left": (-1 * (itemcount - 7) * 108) }, { duration: 200, queue: false });
                    }
                }
            });
            $(".prev").click(function () {
                var left = parseInt($("#program_range_selitemlist").css("left"));
                if (left < 0) {
                    $("#program_range_selitemlist").animate({ "left": (left + 108) }, { duration: 200, queue: false });
                }
                else {
                    $("#program_range_selitemlist").stop().animate({ "left": 0 }, { duration: 200, queue: false });
                }
            });
            /**滚动操作结束********************************/


            // ele.src = get_img_src($(this).attr("data-add_framelayoutid"), "<%= Companyid %>");


            //如果 左侧 弹窗 窗口总数大于10条 才显示滚动条，反之 则隐藏

        });
        //删除节目单中布局块函数 删除按钮  事件
        function DeleteArrangeLayOut(layoutid, layoutposition) {
            if ($("#programIsFiled").val() == "1") {//节目单归档， 不能 删除布局
                return;
            }
            var menuid = $("#program_arrange_menuid").val();
            showDeleteLayoutArrangeTopTrip(menuid, layoutid, layoutposition);//方法在 common.js中，但是处理过程在下面对于TopTripBox .btn的响应处理。
        }

        //删除节目单中布局块函数  需要王总修改
        $(".TopTripBox .btn a").live("click", function () {//注释了，节目单编排审核‘不通过’，弹出框，‘确定’按钮 ---“.TopTripBox .btn a”
           // debugger;
            if ($("#programIsFiled").val() == "1") {//节目单归档， 不能删除布局
                return false;
            }
            if ($(this).attr("data-type") == 0) {
                $("#" + $(this).attr("data-id")).animate({ top: -60 }, 200, function () {
                    $('#' + $(this).attr("data-id")).remove();
                });
            }
            else {
                var tmenuid = $(this).attr("data-menuid");
                var titemid = $(this).attr("data-itemid");//布局号
                var tlayoutposition = $(this).attr("data-layoutposition"); //布局块序号
                var newId = $(this).attr("data-id");
                $.ajax({
                    type: 'post',
                    url: 'ajax/deletelayout.ashx',
                    async: false,
                    data: {
                        type: $(this).attr("data-type"),
                        menuid: tmenuid,
                        layoutid: titemid,
                        layoutposition: tlayoutposition,
                        isFiledMenu: $("#programIsFiled").val()
                    },
                    dataType: 'text',
                    success: function (data) {
                        if (data == "-100") {//节目单归档， 不做处理
                            return;
                        }
                        if (parseInt(data) > 0) {
                            $(".mod_bjlist[data-id=" + titemid + "]").remove();
                        }
                        $("#" + newId).animate({ top: -60 }, 200, function () {
                            $('#' + newId).remove();
                        });
                        var data = "";//返回数据
                        data = program_arrange_getselFrameLayoutEx($("#program_arrange_layoutposition").val());//删除后更新布局显示
                        if (titemid == $("#program_arrange_layoutid").val() && tlayoutposition == $("#program_arrange_layoutposition").val()) {
                            var layoutid = 0;
                            var layoutposition = 0;
                            var taskpostion = 0;
                            //找到第一个大于等于layoutposition记录的layoutposition和layoutid。如果没有则找到第一个记录的layoutposition和layoutid。如果还没有则自动添加全屏布局layoutposition=0，layoutid=0
                            var my = data.split('||');
                            if (my[0] != "") layoutid = parseInt(my[0]);
                            if (my[1] != "") layoutposition = parseInt(my[1]);
                            if (my[2] != "") taskpostion = parseInt(my[2]);
                            //如果删除的正好是当前显示的，则需要更新显示到后一个布局位置。
                            //设置好环境变量
                            $("#program_arrange_layoutposition").val(layoutposition);
                            $("#program_arrange_layoutid").val(layoutid);
                            $("#program_arrange_taskposition").val(taskpostion);
                            $("#program_arrange_waitlayoutposition").val(layoutposition);
                            $("#program_arrange_waitlayoutid").val(layoutid);
                            $("#program_arrange_waitposition").val(taskpostion);
                            program_arrange_changelayoutid(1);
                        }
                    }
                })
            }
        });

        function find_noimg() {
            var theEvent = window.event || arguments.callee.caller.arguments[0];//如果不支持 event 时间FF不支持EVENT

            var srcElement = theEvent.srcElement;

            if (!srcElement) {

                srcElement = theEvent.target;

            }
            srcElement.src = "/images/lay_01.png";
        }

        
    </script>
</head>
<body>
    <input type="hidden" id="program_arrange_taskid" runat="server" />
    <input type="hidden" id="program_arrange_tempid" runat="server" />
    <input type="hidden" id="program_arrange_arrright" runat="server" />
    <input type="hidden" id="program_arrange_chright" runat="server" />
    <input type="hidden" id="program_arrange_pubright" runat="server" />
    <input type="hidden" id="program_arrange_area_bg_width" runat="server" />
    <input type="hidden" id="program_arrange_area_bg_height" runat="server" />
    <input type="hidden" id="programIsFiled" runat="server" />
    <input type="hidden" id="program_arrange_menuid" runat="server" value="0" />
    <input type="hidden" id="program_arrange_layoutid" value="<%=gframelayout%>" />
    <input type="hidden" id="program_arrange_layoutposition" value="0" />
    <input type="hidden" id="program_arrange_needinsertlayoutid" value="0" />
    <input type="hidden" id="program_arrange_taskposition" value="0" />
    <input type="hidden" id="program_arrange_waitlayoutid" value="<%=gframelayout%>" />
    <input type="hidden" id="program_arrange_waitlayoutposition" value="0" />
    <input type="hidden" id="program_arrange_waitneedinsertlayoutid" value="0" />
    <input type="hidden" id="program_arrange_waittaskposition" value="0" />
    <input type="hidden" id="program_arrange_window" value="0-全屏窗口" />
    <input type="hidden" id="program_arrange_windowlist" value="" />
    <input type="hidden" id="usedLayoutName" value="0"/>
    <input type="hidden" id="program_arrange_selscid" value="" />
    <input type="hidden" id="program_arrange_selct" value="" />
    <input type="hidden" id="program_arrange_seltempid" value="" />
    <input type="hidden" id="program_arrange_pagetype" value="" runat="server" />
     <!-- #include file="/common/top.html" -->
<div id="zyyProgramArrangeContainer">
    <div class="slideBarItem">
        <img src="/images/slideTwig.png">
    </div>
    <div id="programDiv">
        <div class="lastcolumn commonStyle">
            <p><span class="language">最近栏目</span></p>
            <div class="lastcolumnList ">
            </div>
        </div>
            <div class="lastSource commonStyle" >
            <p><span class="language">最近素材</span></p>
            <div class="lastSourceList ">
            </div>
        </div>
            <div class="lastClient">
            <p><span class="language">最近终端</span></p>
            <div class="lastClientList">
            </div>
        </div>
    </div>
    <form id="program_arrange" runat="server">
        <div id="overlay"></div>
        <div id="downloadProgram" style="display:none;left:50%;transform:translateX(-50%);padding:25px;position:absolute;background-color:#fff;z-index:2001;">
            <div></div>
            <div style="position: absolute; right: 0; top: 0; width: 30px; height: 30px; cursor: pointer;">
                        <img src="/images/icon_closeBox.png" onclick="closeDiv()" />
            </div>
        </div>
        <div id="mark" style="position: absolute; width: 100%; height: 100%; top: 0px; left: 0px; border: 1px solid #333; z-index: 9999; display: none; outline: 1px solid #333;"></div>
        <div id="content_dialog" style="padding: 0;">
        </div>
        <div id="content_dialog2" style="padding: 0;">
        </div>

        <div id="closeWindow" style="display:none;width: 25px;left: 1290px;top: 300px;z-index: 80001;position: absolute;cursor: pointer;background-color:#fbf8f8" title="关闭">
         <img src="/images/err.png" onclick="closeDialog('0')"/><span style="font-size: 25px;" class="language">关闭</span>
        </div>
        <div id="closeWindow2" style="display:none;width: 25px;height: 25px;left: 1280px;top: 300px;z-index: 80001;position: absolute;cursor: pointer;" title="关闭">
         <img src="/images/err.png" onclick="closeDialog('1')"/>
        </div>

       
        <div id="program_arrange_resendresult" style="display: none;"></div>

        <div class="container clearfixed" >
            <%--添加导航栏--%>
            <div class="pos_area2 clearfix">
                <div class="pos">
                    <a href="program_list.aspx?t=0" class="language">节目单管理</a>&gt;<a class="current language" href="program_list.aspx?t=2">节目单编排</a> >
                    <span id="showGuiDang" class="label_value" style="width: 24px; height: 24px; display: none; margin-right: -11px;"><a href="javascript:void(0)" title="归档" style="background: url(/images/tubiaoa.png) 30px -74px; width: 12px; height: 24px;" class="language"></a></span>
                    <span class="label_value"><a href="#" id="menunContent"><%=gmenuid%>-<%=gmenuName%></a></span><a href="#" id="menuRefer"><img src="/images/icon_group_2.png" border="0" title="节目单被引用情况查看" class="language"></a><span id="program_arrange_indexWindow" class="label_value"></span>
                    <div class="editbtn">
                    <div class="source_edit">
                        <span class="add_icon"><a href="/company/source/Source_Add.aspx"><b style="padding-left: 20px; background: url(/images/tubiao.png) -254px -126px;"></b><span class="language" title="添加素材" >添加素材</span></a></span>
                    </div>
                </div>
                </div>
                
            </div>
            <div class="ny_content" style="border: 0;">
                <div class="program_con">
                    <div class="arrange_area">
                        <div class="add_btn clearfix" id="program_arrange_topmenu"></div>

                        <div class="edit_item">

                            <div class="big_area" style="height: 480px">

                                <div class="area" id="program_arrange_area_bg" style="width: 800px; height: 400px; position: absolute; left: 50%; margin-left: -400px; top: 50%; margin-top: -200px; border: 1px solid #ddd;">
                                    <iframe id="Program_ArrangeMainFrame" src="/company/Layout/frame.html" frameborder="0" onload="Program_arrange_LayoutRecord('<%=gframelayout%>','<%=gmenuid%>','<%=gposition%>','<%=gframelayoutposition%>','<%=gframelayout%>');" width="100%" height="100%"></iframe>
                                </div>
                                <div class="layout">
                                    <div class="tab_tit">
                                        <ul class="clearfix">
                                            <!--<li id="program_arrange_btn_showaddlayout1" isshow="0" class="current"><span class="icon">
                                                <img src="/images/pro_icon_bj_1.png"></span>插入布局</li>-->
                                            <li id="program_arrange_btn_showlayoutlist" isshow="0" class="current" data-framelayoutposition="0" data-inserted_position="0" data-inserted_framelayoutid="0" data-add_framelayoutid="0"><span class="icon">
                                                <img src="/images/pro_icon_bj_2.png"></span><span class="language">切换布局</span></li>
                                            <li id="program_arrange_btn_showros" isshow="0"><span class="icon">
                                                <img src="/images/pro_icon_bj_3.png"></span><span class="language">预览分辨率</span></li>

                                        </ul>

                                    </div>
                                    <div class="cont" id="program_arrange_showDiv">
                                        <div class="layout_switch" id="program_arrange_layoutlist_div" style="display: none">
                                            <h4 class="language">布局列表</h4>
                                            <div>
                                                <ul class="clearfix" id="program_arrange_layoutlist" style="height: 240px; overflow-y: scroll;">
                                                </ul>
                                                <div class="btn_box">
                                                    <input class="inp_s language" value="确定" type="button" id="insert_btn" onclick="program_arrange_changelayoutid(0)"><input class="inp_s language" value="返回" type="button" onclick="program_arrange_recoverylayoutid()">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="layout_switch" id="program_arrange_layoutsellist_div" style="display: block;">
                                            <h4 class="language">布局顺序</h4>
                                            <div>
                                                <ul class="clearfix" id="program_arrange_layoutsellist" style="height: 240px; overflow-y: scroll;">
                                                </ul>
                                                <div class="btn_box">
                                                    <input class="inp_s language" value="确定" type="button" onclick="program_arrange_changelayoutid(1)"><input class="inp_s language" value="返回" type="button" onclick="    program_arrange_recoverylayoutid()">
                                                    <!--<input class="inp_s" value="确定" type="button" onclick="program_arrange_recoverylayoutid()"><input class="inp_s" value="返回" type="button" onclick="program_arrange_recoverylayoutid()"> -->
                                                </div>
                                            </div>
                                        </div>
                                        <div class="fbl_seting" id="program_arrange_scale_div" style="display: none;">
                                            <h4 class="language">常见列表</h4>
                                            <div style="height: 240px; overflow-y: scroll;">
                                                <ul class="clearfix" id="program_arrange_scalelist" runat="server">
                                                </ul>
                                                <div class="btn_box">
                                                    <input class="inp_s language" value="返回" type="button" onclick="    program_arrange_recoverylayoutid()">
                                                </div>
                                            </div>
                                            <!-- <div class="fbl_defined">
                                                <p>自定义</p>
                                                <div class="clearfix">
                                                    <span>
                                                        <input class="inp_t" type="text" id="program_arrange_fbl_width"></span>
                                                    <span>X</span>
                                                    <span>
                                                        <input class="inp_t" type="text" id="program_arrange_fbl_height">
                                                        <input class="inp_s" value="预览" type="button" onclick="program_arrange_changeros()">
                                                    </span>
                                                    <span class="fr">
                                                        <input class="inp_s" value="返回" type="button" onclick="program_arrange_resetros()">
                                                    </span>

                                                </div>
                                            </div>-->
                                        </div>
                                    </div>
                                </div>
                                <div class="windowlist">
                                    <div class="ck_icon" id="program_arrange_btn_showwindows"><span></span></div>
                                    <div class="ck_list" id="program_arrange_windows_div">
                                        <h4 class="language">窗口列表</h4>
                                        <ul id="program_arrange_layout_windows">
                                        </ul>
                                    </div>
                                </div>
                                <div class="ck_icon_right" data-isshow="0"><span class="one"></span></div>
                            </div>
                            <div class="small_area">
                                <div class="imglist">
                                    <ul class="clearfix" style="position:relative; left:0px;" id="program_range_selitemlist" runat="server">
                                    </ul>
                                </div>
                                <div class="prev"><a href="javascript:void(0);"></a></div>
                                <div class="next"><a href="javascript:void(0);"></a></div>
                            </div>
                        </div>
                        <div class="edit_item_list" id="program_arrange_editpage">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="list_box">
            <div class="sc_list_box">
                <div class="title clearfix">
                    <ul class="bt clearfix">
                        <li class="current"><a href="javascript:void(0)" id="program_arrange_loadhs_btn"  class="language">素材列表</a></li>
                        <li><a href="javascript:void(0)" id="program_arrange_loadhc_btn" class="language">栏目列表</a></li>
                    </ul>
                </div>
            </div>
            <div class="sc_list_box" id="program_arrange_h_sourcelist" style="background: #edf0f0"></div>
            <div class="sc_list_box" id="program_arrange_h_columnlist" style="background: #edf0f0"></div>
            <div class="sc_list_box" id="program_arrange_source_list" style="position: absolute; left: 100px; z-index: 1001; top: 110px; display: none; width: 760px; height: 400px; overflow-y: scroll; background: #ffffff; border: 2px solid #333333; -moz-box-shadow: 3px 3px 3px #333333 inset; /* for firefox3.6+ */ -webkit-box-shadow: 3px 3px 3px #333 inset; /* for chrome5+, safari5+ */ box-shadow: 3px 3px 3px #333 inset; /* for latest opera */"></div>
            <div class="sc_list_box" id="program_arrange_column_list" style="position: absolute; left: 100px; z-index: 1001; top: 110px; display: none; width: 760px; height: 400px; overflow-y: scroll; background: #ffffff; border: 2px solid #333333; -moz-box-shadow: 3px 3px 3px #333333 inset; /* for firefox3.6+ */ -webkit-box-shadow: 3px 3px 3px #333 inset; /* for chrome5+, safari5+ */ box-shadow: 3px 3px 3px #333 inset; /* for latest opera */"></div>
        </div>
        <div id="program_quote" style="position: fixed; width: 640px; height: 400px; left: 50%; top: 50%; margin-left: -320px; margin-top: -200px; background: #fff; border: 1px solid #ddd; display: none; z-index: 2229;">
        </div>
    </form>
</div>
    <div id="dialog">
    </div>

    <div id="client_add_view" style="position: fixed; width: 800px; height: 600px; left: 50%; top: 7%; margin-left: -400px; display: none; z-index: 2001; background: #fff;"></div>

    <script>
        $("#menunContent").click(function () {
            if ($("#programIsFiled").val() == "1") {//节目单归档， 
                return false;
            }
            $("#dialog").empty();
            close_ck_icon_right();
            $("#content_dialog2").dialog("close");
            $("#content_dialog").dialog("close");
            $("#dialog").load("/common/program_edit.aspx?id=<%=gmenuid%>&&filed=" + $("#programIsFiled").val());

            $("#dialog").dialog("open");
            setTimeout(function () { //7/31解除绑定
                $("#sc_pic_list").die();
            }, 1000);
        });
        $("#dialog").dialog({
            autoOpen: false,
            zIndex: 8000,
            close: function () {
                $("#content_dialog").html("");
            },

            width: 770,
            height: 500,
            resizable: true,
            title: "编辑节目单",
            stack: true,
            appendTo: "body"
        });

        //清空节目单 的方法 结束后重新装载
        $("a[name=btn_deleteMenuItem]").die().live("click", function () {
            if ($("#programIsFiled").val() == "1") {//节目单归档， 
                $('#' + $(this).attr("data-id")).remove();
                return false;
            }
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
                        act: "clearmenuitem",
                        type: $(this).attr("data-type"),
                        id: itemid,
                        myIsFile: $("#programIsFiled").val()
                    },
                    dataType: 'text',
                    success: function (data) {
                        if (data != "-100") {
                            $(".mod_sclist[data-itemid=" + itemid + "]").remove();
                            $("#program_tab_list tr[data-itemid=" + itemid + "]").remove();
                            $("#" + newId).animate({ top: -60 }, 200, function () {
                                $('#' + newId).remove();
                            });
                        }
                    }
                });
                window.location.reload();
            }
        });

        //cookie 记录input 状态
        var ProgramSlideVal = {
            pagedata: [],
            cookiedata: null,
            cookiearry: [],
            fatherSelector: $("#program_slide_cookie"),
            getdata: function () {
                if (this.cookiedata != null || "") {
                    //如果有cookie 则有标示
                    this.hascookieflag();
                    return this.cookiedata;//返回值给添加素材部分
                } else {
                    this.hascookieflag();//如果没有cookie 则有标示
                    return "";
                }
            },
            postdata: function () {//如果为空为 cookie“赋值”
                //收集要存的cookie
                this.pagedata[0] = "<%=Userid%>";
                this.pagedata[1] = this.getinputVal("r_edit_program_myplayer");
                //$("[name='r_edit_program_myplayer']").val();
                this.pagedata[2] = this.getinputVal("s_edit_column_triggertype");
                //$("[name='s_edit_column_triggertype']").val();
                this.pagedata[3] = $("[name='t_edit_program_duringtime_h']").val();
                this.pagedata[4] = $("[name='t_edit_program_duringtime_m']").val();
                this.pagedata[5] = $("[name='t_edit_program_duringtime_s']").val();
                this.pagedata[6] = this.getinputVal("r_edit_program_copyto");
                //$("[name='r_edit_program_copyto'][checked]").val();
                this.pagedata[7] = $("[name='c_edit_program_canreact']").prop("checked");
                this.pagedata[8] = $("[name='s_edit_program_merit']").val();
                this.pagedata[9] = $("[name='c_edit_program_usesubject']").prop("checked");
                this.pagedata[10] = $("[name='t_edit_program_circletime']").val();
                this.pagedata[11] = this.getinputVal("r_edit_program_circleeveryday");
                //$("[name='r_edit_program_circleeveryday']").val();
                this.pagedata[12] = $("[name='t_edit_program_starttime']").val();
                this.pagedata[13] = $("[name='t_edit_program_expiretime2']").val();
                this.pagedata[14] = this.getinputVal("r_edit_program_zorder");
                //$("[name='r_edit_program_zorder']").val();
                this.pagedata[15] = $("[name='t_edit_program_templet']").val();
                this.pagedata[16] = $("[name='h_edit_program_templet']").val();
                this.pagedata[17] = $("[name='t_edit_program_postion']").val();
                this.pagedata[18] = $("[name='c_edit_program_openflag']").prop("checked");
                this.pagedata[19] = $("[name='t_edit_program_oldpostion']").val();
                // this.pagedata[20] = $("#edit_menu_add_ex").attr("data-isshow");// 记录展开 还是 关闭
                //"参数设置"下的input;      
                this.pagedata[20] = $("[name='s_edit_program_exetask']").val();//应用程序名/参数：
                this.pagedata[21] = $("[name='prgnamelist']").val(); //选择应用程序名：获得
                this.pagedata[22] = $("[name='prgnamelist']").html(); //选择应用程序名：获得html
                this.pagedata[23] = $("[name='c_edit_program_param_setloc']").prop("checked");//checked
                this.pagedata[24] = $("[name='s_edit_program_param_window']").val();//播放窗口位置：
                this.pagedata[25] = $("[name='c_edit_program_param_setpstmsg']").prop("checked");//播放完毕后通知系统
                this.pagedata[26] = $("[name='c_edit_program_param_settopmost']").prop("checked");//窗口总在最前显示
                this.pagedata[27] = $("[name='c_edit_program_param_setminimize']").prop("checked");//播放时最小化窗口
                this.pagedata[28] = $("[name='c_edit_program_param_setclose']").prop("checked");//播放完毕后自动退出
                this.pagedata[29] = this.getinputVal("r_edit_program_param_settrans");//透明
                this.pagedata[30] = this.getinputVal("r_edit_program_param_setmask");//罩子形状： 
                this.pagedata[31] = $("[name='s_edit_program_descript']").val();//更多描述：
                this.pagedata[32] = $("[name='h_edit_program_templet_bkpic']").val();
                this.pagedata[33] = $("[name='h_edit_program_templet_options']").val();
                this.pagedata[34] = $("[name='t_edit_program_triggertime1']").val();
                this.pagedata[35] = $("[name='t_edit_program_triggertime2']").val();
                //播放完毕后自动退出
                var str = this.pagedata.join(",");
                this.cookiedata = $.cookie("ProgramSlideVal" + "<%=Userid%>", str);
                //  console.log($.cookie("SourseSlide"));
                // console.log(this.cookiedata);
            },
            getinputVal: function (radioName) {
                var obj = document.getElementsByName(radioName);

                for (var i = 0; i < obj.length; i++) {
                    if (obj[i].checked) {
                        return obj[i].value;
                    }
                }
            },
            updateinput: function (radioName, value) {
                $("[name=" + radioName + "]:eq(" + value + ")").attr("checked", "true");
            },
            hascookieflag: function () {// 有无cookie标示
                if ($.cookie("ProgramSlideVal" + "<%=Userid%>") == null) {
                    console.log("无cookie");
                    $(".de_shuxing b").css({ "background": "url(/images/tubiaoa.png) -27px -147px" });
                }
                else {
                    console.log("有cookie");
                    $(".de_shuxing b").css({ "background": "url(/images/tubiaoa.png) -124px -172px" });
                }
            }

        }
        //cookie 存储 input值
        $("[name='setdefaultoption']").live("click", function () {
            ProgramSlideVal.postdata();
            TopTrip("缺省属性以保存！", 1);
            //有cookie标示
            ProgramSlideVal.hascookieflag();
        });
        $("[name='nodefaultoption']").live("click", function () {
            $.cookie("ProgramSlideVal" + "<%=Userid%>", null);
            // ProgramSlideVal.cookiedata = null;
            //window.location.reload();
            TopTrip("缺省属性已清空！", 1);
            ProgramSlideVal.hascookieflag();
        });
        //有问题 第一次点击   不触发下边的窗口
        $("[name='r_edit_program_myplayer'][value='3']").live("click", function () {
            $("#date_set_btn").trigger("click");

        });
        // 节目单引用情况移植。 
        function showProgramQuote(itemid, itemname) {
            $("#overlay").fadeIn();
            $("#program_quote").load("program_quote.aspx", { "id": itemid, "name": itemname }, function () {
                $("#program_quote").slideDown();
            });

        }
        $("#menuRefer").live("click", function () {
            showProgramQuote("<%=gmenuid%>", "<%=gmenuName%>");
        });

    </script>
</body>
</html>
