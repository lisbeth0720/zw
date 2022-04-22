var windowHeight = document.documentElement.clientHeight;
var windowWidth = document.documentElement.clientWidth;
var screenWidth1 = document.documentElement.clientWidth;//用于检测横竖屏变化
var timer = 0;//轮询的变量
var content1 = '';
var newurl = '';//当前显示端的url
var oldData = '';//声明一个变量来存储上一次的数据
var oldURL = "";//声明一个变量来存储上一个URL
var contentStr = [];
var socket = null;//用于显示进度的socket
var socket1 = null;//用于模拟鼠标在显示端操作的socket
var dragStartjt = false;//判断是否要进行拖拽的动作，截图
var dragStart = false;//判断是否要进行拖拽的动作,操控板只进行移动
var dragStart1 = false;//判断是否要进行拖拽的动作，操控板状态位
var sendding = false;//用于标志当前指令发送是否成功
var timeFlag = 0;//设置一个变量存储拖动进度条后再度读取数据的时间 防止拖动时出现进度条跳转回原来位置
var oldmenuState = "";
var onlyoneCutScreen = 0;
var screenimg = 0;//截屏图片对象
var penFlag = 0;//当为0时则认为是单指拖动，为1时则认为是单指画
var screenWidth = window.screen.width;//用来存储要控制终端的宽度
var screenHeight = window.screen.height;//用来存储要控制终端的高度
var windowWidth = window.screen.width;
//声明变量保存canvas的大小，此处使用clientWidth才能获取ios移动端的横竖屏的宽度
var canvaswindowWidth = document.documentElement.clientWidth;
var changeFlag = 0;//判断此时是否在进行拖动，若进行拖动动作则置为1,不进行数据获取的动作
//声明全局变量保存最后一次move的操作  
var lastMoveX = 0;
var lastMoveY = 0;

var lastedMoveX = 0;
var lastedMoveY = 0;

var prev = 0;
var canvasZoom = 0;

var currentX = 0;
var currentY = 0;

var canvas = null;
var tempContext = null; // global variable 2d context  
var started = false;
var mText_canvas = null;
var x = 0, y = 0;
var btnstate = 0;
var targeturlhead = "wpsendkeys.asp?wpsendkeys=-mouseevent ";
var targeturlrear = "0_0_0";

var oldX = 0;
var oldY = 0;
var statusMouse = 0;
var startTime = 0;
var endTime = 0;
var statusEnd = 0;
var statusEnd1 = 0;
var volumStatus = 0;

var loadpng = $(".loadpng").width();//存储loadpng的宽度
var loadpngH = $(".loadpng").height();

var hideSlideTimer = "";//隐藏弹出区域所做的定时

var hideSlideTimer1 = "";//音量条长时间不点击自动消失

var hideSlideTimer2 = "";//隐藏弹出区域所做的定时(预览图片)

var oldchangeVal = $("input[type=range]").val();

var slideCount = 0;//此处声明一个全局变量是为了执行touchend事件后存储变量
var slideNumber = 0;//此处声明一个全局变量是为了执行touchend事件后在一段时间内刷新界面几次
var whRate = 0;//计算loadpng长度和宽度的比例
var clientIndex = 0;//记录当前的终端号，以便于刷新时重新回到此终端
var oldClientIndex = 0;//记录上一次的终端号
var client = 0;
var screenimg = 0;//截屏图片对象
var count = 0;
var count1 = 0;

var timeFlag = 0;//设置一个变量存储拖动进度条后再度读取数据的时间 防止拖动时出现进度条跳转回原来位置
var soundFlag = 0;

var indexNumber = "";//获取第几个终端
browserRedirect();
$(function () {
    getJsonValue();//为了防止多次向发送请求，将读取过的数据存储在页面中
    $(".controlAllBtn img").click(function () {
        if ($(".controlAll").height() > 0) {
            $(".controlAll").animate({ height: "0px" });
            $(".clientList").css("height", $(".topLeft").height() - $(".logo").height() - $(".controlAllBtn").height() - 0);
            $(this).attr("src", "images/kongzhi/xiangshang.png");
        } else {
            $(".controlAll").animate({ height: "280px" });
            $(".clientList").css("height", $(".topLeft").height() - $(".logo").height() - $(".controlAllBtn").height() - 280);

            $(this).attr("src", "images/kongzhi/xiangxia.png");
        }
    })
    getClientList("#clientList");
    getFaceDepart();//获取人脸识别的部门列表
    $("#top").css("height", windowHeight - $("#functionButton").height() - 5);
    $(".controlBottomBtn").click(function () {
        if ($("#bottom").css("bottom") == "0px") {
            $("#bottom").animate({
                "bottom": "-300px"
            })
            $(".controlBottomBtn img").attr("src", "images/dibubofang/quanjukongzhi.png");
        } else {
            $("#bottom").animate({
                "bottom": "0px"
            })
            $(".controlBottomBtn img").attr("src", "images/dibubofang/quanju-xiangxia.png");
        }
    })
    //选中哪一个全局控制按钮即更换哪一个的内容和样式
    $(".otherFunctionBtn li").click(function () {
        //点击全部控制的按钮来切换当前按钮的选中状态图标
        $(".otherFunctionBtn li").css("background", "#26254d");
        $(this).css("background", "#f06060");

        var index = $(".otherFunctionBtn li").index(this) + 1;
        changeTab('bar' + index);
    })
    $(".otherFunctionContent").css("width", ($("#otherFunction").width() - $(".otherFunctionBtn").width()) + "px");
    //切换语言
    $(".changeLanguage").click(function () {
        if ($(this).attr("src") == "images/liebiao/EN.png") {
            $.cookie("yuyan", "en", { path: "/" });
            $("#top .topRight .rightTitle .programTitle").css("fontSize", "12px")
            $("#otherFunction .otherFunctionBtn ul li span").css("marginLeft", "0px");
            $("#otherFunction .otherFunctionBtn ul li").eq(2).find("span").css("lineHeight", "30px");
            $(this).attr("src", "images/liebiao/CH.png");
            $(".controlBottomTab li span").hide();
            $(".controlBottomBtn span").hide();

            switchLanguage(1, "newpctrl.html");
        } else {
            $.cookie("yuyan", "CH", { path: "/" });
            $("#top .topRight .rightTitle .programTitle").css("fontSize", "16px");
            $("#otherFunction .otherFunctionBtn ul li span").css("marginLeft", "20px");
            $("#otherFunction .otherFunctionBtn ul li").eq(2).find("span").css("lineHeight", "60px");
            $(this).attr("src", "images/liebiao/EN.png");
            $(".controlBottomTab li span").show();
            $(".controlBottomBtn span").show();
            switchLanguage(0, "newpctrl.html");

        }
        getLanguageMsg("获取数据出错!", $.cookie("yuyan"));
        $("#downLoad span").html(getLanguageMsg("下载", $.cookie("yuyan")));
        $("#checkFile span").html(getLanguageMsg("预览", $.cookie("yuyan")));

    });
    $("#bar4 .keys").click(function () {
        var keyCode = ("0X" + (parseInt($(this).attr("data-kid")).toString(16).length > 1 ? parseInt($(this).attr("data-kid")).toString(16) : "0" + parseInt($(this).attr("data-kid")).toString(16))).toUpperCase();
        docmd('keycode', keyCode);
    })
    $("#bar4 .keysCmd ").click(function () {
        var keyCode = ("0XFF" + (parseInt($(this).attr("data-kid")).toString(16).length > 1 ? parseInt($(this).attr("data-kid")).toString(16) : "0" + parseInt($(this).attr("data-kid")).toString(16))).toUpperCase();
        docmd('keycode', keyCode);
    })
    $("#bar4 .keysPPT").click(function () {
        var keyCode = "urlplayer%20-keyevent%200xFF" + ((parseInt($(this).attr("data-kid")).toString(16).length > 1 ? parseInt($(this).attr("data-kid")).toString(16) : "0" + parseInt($(this).attr("data-kid")).toString(16))).toUpperCase();
        docmd('keycode', keyCode);
    })
    $(".materialSound").click(function () {
        $(".mSoundShadow").show();
        $("#range2").css("display", "block");
        $("#value2").css("display", "block");
    });
    setInterval("refreshScreen()", 2000);//定时刷新显示界面的大小

})
window.onload = function () {

    $(".clientList").css("height", $(".topLeft").height() - $(".logo").height() - $(".controlAll").height() - $(".controlAllBtn").height());
    $(".topRight").css("width", document.documentElement.clientWidth - $(".topLeft").width() - parseInt($(".topRight").css("marginLeft")));
    if ($(".rightTitle").height()==0) {
        $(".topRight").css("height", $("#top").height() - $(".topLeft").height());
    }
    $(".programList").css("height", $(".topRight").height() - $(".rightTitle").height());
    if ($.cookie("clientIndex") == undefined || $.cookie("clientIndex") == "" || (parseInt($.cookie("clientIndex")) > $(".screenList").length)) {
        clientIndex = 0;
    } else {
        clientIndex = ($.cookie("clientIndex"));
    }
    //若当前的终端超过了当前显示区域的大小，则自动滚动到终端的位置
    if ($.cookie("clientIndex") > $("#top").height() / $(".screenList").height()) {
        $('.topLeft .clientList').animate({ scrollTop: parseInt($.cookie("clientIndex")) * $(".screenList").height() }, 'slow');
    }
    $("#top").attr("src", $("#top li:eq(" + clientIndex + ")").attr("src"));
    $("#clientList").attr("clientname", $("#top li:eq(" + clientIndex + ")").attr("clientname"));
    newurl = $("#top").attr("src");

    getData(newurl, clientIndex);
    $("#top").attr("macName", $("#top li").eq(clientIndex).attr("macname"));
    $("#top").attr("indexNumber", $("#top li").eq(clientIndex).attr("indexclient"));
    $("#top").attr("clientName", $("#top li").eq(clientIndex).attr("clientname"));
    if ($("#top li:eq(0)").attr("homeid") == "home") {
        $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1");
    } else {
        $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1");
    }
    changeNowRate();//调节进度，因为是touch事件，所以需要提前声明
    if ($(".screenList").length > 0) {
        $(".screenList").eq(clientIndex).find(".screenType").attr("src", $(".screenList").eq(clientIndex).find(".screenType").attr("src").split(".").join("-xuanzhong."));
        $(".screenList").eq(clientIndex).css({ "background": "#33325a", "color": "#f06060" });
    }

    $(".controlAll ul li span").click(function () {
        $(".controlAll ul li").css("background", "#26254d");
        $(this).parent().css("background", "#f06060");
    })
    $(".systemSound span").click(function () {
        $(".systemSoundShadow").show();
        $(this).parent().css("background", "#f06060");
        $("#range").css({
            "marginLeft": ($(".systemSoundShadow").width() - $("#range").width() - $(".systemSoundShadowValue").width()) / 2,
            "marginTop": ($(".systemSoundShadow").height() - $("#range").height()) / 2
        })
        $(".systemSoundShadowValue").css("lineHeight", $(".systemSoundShadow").height() + "px");
    })
    $(".systemSound img").click(function () {
        if ($(this).attr("src") == "images/kongzhi/noSound.png") {
            $(this).attr("src", "images/kongzhi/tingzhibofang.png");
            docmd("3028", "20");

        } else {
            $(this).attr("src", "images/kongzhi/noSound.png");
            docmd("3028", "10");
        }
    })
    //点击刷新状态的按钮进行刷新
    $("#refreshProgram img").click(function () {
        getData(newurl, clientIndex);
    });
    $(".controlAll ul .systemSound img").click(function () {
        $(".controlAll ul li").css("background", "#26254d");
        $(this).parent().css("background", "#f06060");
    })
    $(document).click(function (e) {
        if (($(e.target).closest('.systemSound span').length == 0 && $(e.target).closest('#range').length == 0) || ($(e.target).closest('.systemSound span').length == 0 && $(e.target).closest('#range').length == 0)) {
            $(".systemSoundShadow").hide();
        }
    });
    $(document).click(function (e) {
        if (($(e.target).closest('.materialSound').length == 0 && $(e.target).closest('#range2').length == 0) || ($(e.target).closest('.materialSound ').length == 0 && $(e.target).closest('#range2').length == 0)) {
            $(".mSoundShadow").hide();
        }
    });
    //点击任意终端进行样式的切换，同时将当前终端的ip和mac地址赋值给tabScreen,每次点击一次终端则去后台读取一次数据
    $(".clientName").click(function () {
        for (var i = 0; i < $(".screenList").length; i++) {
            if ($(".screenList").eq(i).find(".screenType").attr("src").indexOf("xuanzhong") >= 0) {
                $(".screenList").eq(i).find(".screenType").attr("src", $(".screenList").eq(i).find(".screenType").attr("src").split("-xuanzhong").join(""));
            }

        }
        if ($(this).parent().find(".screenType").attr("src").indexOf("xuanzhong") >= 0) {
        } else {
            $(this).parent().find(".screenType").attr("src", $(this).parent().find(".screenType").attr("src").split(".").join("-xuanzhong."));
        }

        var ccNum = $(this).parent().attr("indexclient");
        $(".screenList").css({ "background": "none", "color": "#fff" });
        $(this).parent().css({ "background": "#33325a", "color": "#f06060" });

        $("#top").attr("src", $(this).parent().attr("src"));
        newurl = $("#top").parent().attr("src");
        $("#top").attr("macName", $(this).parent().attr("macname"));
        $("#top").attr("indexNumber", $(this).parent().attr("indexclient"));
        $("#top").attr("clientName", $(this).parent().attr("clientname"));
        newurl = $("#top").attr("src");
        //如果当前的终端 名字有返回中控页字样时，则返回到控制室的平板操控页
        if ($(this).text() == "返回中控页") {
            window.location.href = "http://" + $(this).parent().attr("src") + ":8080" + window.location.href.split(":8080")[1];
        } else {
            getData(newurl, ccNum);
        }
        //如果当前页面是早终端打开，则在上传文件时的地址为相对地址，否则为绝对地址
        if ($(this).parent().attr("homeid") == "home") {
            $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1");
        } else {
            $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1");
        }//音量条隐藏
        if ($.cookie("clientIndex") != undefined || $.cookie("clientIndex") != null) {
            oldClientIndex = $.cookie("clientIndex");
        }
        $.cookie("clientIndex", ccNum);
        //每次点击一个终端时都将其他终端启动的websocket关闭，防止影响当前终端
        if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
            delete socket1;
            socket1 = null;
        }
        if (socket != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
            delete socket;
            socket = null;
        }

    });
    //点击终端下的更多按钮，加载更多关于终端的内容
    $(".moreIp").click(function () {
        for (var i = 0; i < $(".moreIp").length; i++) {
            $(".moreIp").attr("src", $(".moreIp").attr("src").split("-xuanzhong").join(""));
        }

        if ($(this).parent().next().css("display") == "block") {
            $(this).parent().next().hide();
            $(this).parent().next().css("background", "none");
        } else {
            $(this).attr("src", $(this).attr("src").split(".").join("-xuanzhong."));
            $(".moreIp").parent().next().hide();
            $(this).parent().next().show();
            $(this).parent().next().css("background", "#33325a");
        }
    })
    $(".refreshProgram").click(function () {
        getData(newurl, clientIndex);
    })
    $(".videoTitle img").click(function () {
        $(".videoContent").css("display", "none");
    })
    $(".musicTitle img").click(function () {
        $(".musicContent").css("display", "none");
    })
    $("#checkPictureTitle img").click(function () {
        $("#checkPicture").hide();
    })
    $(".closeImg").click(function () {
        $(".loadpng").css("display", "none");
        $("#loadmask").css("display", "none");
    })
    $(".touchMouse .closeTouchMouse img").click(function () {
        $(".touchMouse").css("display", "none");
    })
    $(".fileTitle img").click(function () {
        $(".fileContent").css("display", "none");
        $(".fileTK").removeClass("current");
    })
    //点击刷新状态的按钮进行刷新
    $("#freshPage img").click(function () {
        getData(newurl, clientIndex);
    });
    //加载页面时，当前节目是正常播放还是全屏播放与加载前保持一致
    if ($.cookie("allscreen") == "open") {
        $(".allScreenBtn img").attr("src", "images/liebiao/quanpingboSelected.png");
        $(".allScreenBtn").attr("allscreen", "open");
    } else {
        $(".allScreenBtn img").attr("src", "images/liebiao/quanpingbo.png");
        $(".allScreenBtn").attr("allscreen", "close");
    }
    //点击加载截屏更多操作的按钮，若10s内不再对按钮以及隐藏的功能按钮进行操作，则隐藏的功能按钮自动隐藏
    $(".slideImage").click(function () {
        $(".sildeMore").css("right", "0");
        hideSlideTimer = setInterval("timeCount()", 1000);
    })
    $("#points").on('input propertychange', function () {
        getNowSize(this);
        if (count != 0) {
            clearInterval(hideSlideTimer);
            count = 0;
            setTimeout('$(".slideImage").click()', 3000);
        }
    })
    $("#points").on("change", function () {
        drawImage($("#points").val() * 0.05);
    })
    $(".slideImage1").click(function () {

        $(".sildeMore1").css("right", "0");
        hideSlideTimer2 = setInterval("timeCount1()", 1000);
    })
    $("#localIP").click(function () {
        window.location.href = "http://" + $("#localIP").parent().attr("src") + ":8080/newpctrl.html";
    })
    $("#points1").on('input propertychange', function () {
        getNowSize(this, 1);
        if (count1 != 0) {
            clearInterval(hideSlideTimer2);
            count1 = 0;
            setTimeout('$(".slideImage1").click()', 3000);
        }
    })
    $("#points1").on("change", function () {
        drawImage1($("#points1").val() * 0.05);
    })
    $(".commonStyle").click(function () {
        if (count != 0) {
            clearInterval(hideSlideTimer);
            count = 0;
            setTimeout('$(".slideImage").click()', 3000);
        }
    })
    $("body *").click(function (e) {
        if ($(e.target).closest('.slideImage').length == 0) {
            $(".sildeMore").css("right", "-60px");
            clearInterval(hideSlideTimer);
            count = 0;
        }
    });
    $(".allScreenBtn img").click(function () {
        if ($(".allScreenBtn img").attr("src").indexOf("Selected") >= 0) {
            $(".allScreenBtn").attr("allscreen", "close");
            $(".before").attr("onclick", "docmd1('before',0)");
            $(".next").attr("onclick", "docmd1('next',0)");
            $("#bar3").find("li").eq(4).attr("onclick", "docmd1(12,0)");
            $("#bar3").find("li").eq(5).attr("onclick", "docmd1(15,0)");
            $("#bar3").find("li").eq(6).attr("onclick", "docmd1('before',0)");
            $("#bar3").find("li").eq(7).attr("onclick", "docmd1('next',0)");
            $(".allScreenBtn img").attr("src", $(".allScreenBtn img").attr("src").split("Selected")[0] + $(".allScreenBtn img").attr("src").split("Selected")[1]);


        } else {

            $(".allScreenBtn").attr("allscreen", "open");
            $(".before").attr("onclick", "docmd1('before',3)");
            $(".next").attr("onclick", "docmd1('next',3)");
            $("#bar3").find("li").eq(4).attr("onclick", "docmd1(12,3)");
            $("#bar3").find("li").eq(5).attr("onclick", "docmd1(15,3)");
            $("#bar3").find("li").eq(6).attr("onclick", "docmd1('before',3)");
            $("#bar3").find("li").eq(7).attr("onclick", "docmd1('next',3)");
            $(".allScreenBtn img").attr("src", $(".allScreenBtn img").attr("src").split(".")[0] + "Selected." + $(".allScreenBtn img").attr("src").split(".")[1])

        }
        $.cookie("allscreen", $(".allScreenBtn").attr("allscreen"));
    })
    //点击频道获取获取相应的频道
    $(".channelGet").click(function () {
        $(".channelChange").slideToggle(600);
        count += 1;
        var channelUrl = $("#top").attr("src");
        url = channelUrl + "/wpgetxmlids.asp?rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        getChannelList();
    });
    $("#inpurChannelValue").click(function () {
        if ($("#ulChannelList").css("display") == "none") {
            $("#ulChannelList").slideDown();
        } else {
            $("#ulChannelList").slideUp();
        }

    })
    //跳转节目单频道按钮
    $("#channelBtn").click(function () {

        var value = $("#inpurChannelValue").val() + "11";//11表示切换后立即启动节目单播放，69表示进入手动模式
        value = encodeURI(value);
        value = "utf-8" + value;
        docmd(73, "'" + value + "'");
        $(".handControl").find("img").attr("src", "images/leftControl/shoudongmoshi.png");
        $(".startProgram").find("img").attr("src", "images/leftControl/qidongjiemuSelected.png");
        window.setTimeout("getData(newurl,clientIndex)", 1500);//触发加载数据事件
        window.setTimeout("getChannelList();", 2500);//触发加载数据事件
        $(".channelChange").hide();

    });
    //切换并暂停节目单频道按钮
    $("#channelBtnPause").click(function () {
        var value = $("#inpurChannelValue").val() + "69";//11表示切换后立即启动节目单播放，69表示进入手动模式

        value = encodeURI(value);
        value = "utf-8" + value;
        docmd(73, "'" + value + "'");
        //window.setTimeout("$('#title').click();",1500);//触发加载数据事件
        $(".handControl").find("img").attr("src", "images/leftControl/shoudongmoshiSelected.png");
        $(".startProgram").find("img").attr("src", "images/leftControl/qidongjiemu.png");
        window.setTimeout("getData(newurl,clientIndex)", 1500);//触发加载数据事件
        window.setTimeout("getChannelList();", 2500);//触发加载数据事件
        $(".channelChange").hide();
    });
    $(".windowName img").click(function () {
        $(".playScreenShadow").hide();
    })
    showNowPlayScreen();
    //横竖屏适配
    if (canvaswindowWidth > 770) {
        $(".bar .cmdBar li").css("width", "170px");
        $(".sendCmd span").css("width", "120px");
    } else {
        $(".bar .cmdBar li").css("width", "150px");
        $(".sendCmd span").css("width", "100px");
    }
    //判断当前是什么语言，如果cookie汇总没有记录，则默认为是中文
    if ($.cookie("yuyan") != null && $.cookie("yuyan") != "" && $.cookie("yuyan") != undefined) {
        if ($.cookie("yuyan") == "en") {
            switchLanguage(1, "newpctrl.html");
            $(".changeLanguage").attr("src", "images/liebiao/CH.png");
            $(".controlBottomTab li span").hide();
            $(".controlBottomBtn span").hide();
            $("#otherFunction .otherFunctionBtn ul li span").css("marginLeft", "0px");
            $("#otherFunction .otherFunctionBtn ul li").eq(2).find("span").css("lineHeight", "30px");
            $("#top .topRight .rightTitle .programTitle").css("fontSize", "12px");
        } else {
            switchLanguage(0, "newpctrl.html");
            $(".changeLanguage").attr("src", "images/liebiao/EN.png");
            $(".controlBottomTab li span").show();
            $(".controlBottomBtn span").show();
            $("#otherFunction .otherFunctionBtn ul li span").css("marginLeft", "20px");
            $("#otherFunction .otherFunctionBtn ul li").eq(2).find("span").css("lineHeight", "60px");
            $("#top .topRight .rightTitle .programTitle").css("fontSize", "16px");
        }

    } else {
        switchLanguage(0, "newpctrl.html");
        $(".changeLanguage img").attr("src", "images/allTitle/CH.png");
    }
    $(".tipOk").click(function () {
        $(".confirmDiv").css("display", "none");
        $(".topConfirm").attr("messageTip", "ok");
        var functionName = $(".tipContent").attr("fName");
        var functionNum = $(".tipContent").attr("messageNum");
        eval(functionName + "(" + functionNum + ")");
    })
    $(".tipCancle").click(function () {
        $(".topConfirm").attr("messageTip", "");
        $(".confirmDiv").css("display", "none");

    })
    $(".faceDetectionContent img").click(function () {

        $(".faceDetectionContent").hide();
        $(".faceDetection").find("input[type=text]").val(" ");
    })
    $(".faceMergeContent img").click(function () {
        $(".faceMergeUL ").find("input[type=text]").val(" ");
        $(".faceMergeContent").hide();
    })
    $(".pageLoadContent img").click(function () {

        $(".pageLoadContent").hide();

    })

    $(".faceDetectionUL select").eq(0).click(function () {

        $(this).next().val($(this).find("option:selected").html());
        var selectStr = $(this).find("option:selected").attr("faceInfo");
        if (selectStr != "") {
            $(this).parents(".faceDetectionUL").find("li").eq(1).find("input").val((selectStr.split("_")[1]).split(":")[1]);
            $(this).parents(".faceDetectionUL").find("li").eq(2).find("input").val((selectStr.split("_")[2]).split(":")[1]);
            $(this).parents(".faceDetectionUL").find("li").eq(3).find("input").val((selectStr.split("_")[3]).split(":")[1]);
        }

    })
    $(".faceDetectionUL select").eq(1).click(function () {

        $(this).next().val($(this).find("option:selected").html());
    })
    $(".faceMergeUL select").click(function () {

        $(this).next().val($(this).find("option:selected").html());
        var selectStr = $(this).find("option:selected").attr("faceInfo");
        if (selectStr != "") {
            $(this).parents(".faceMergeUL").find("li").eq(1).find("input").val((selectStr.split("_")[1]).split(":")[1]);
            $(this).parents(".faceMergeUL").find("li").eq(2).find("input").val((selectStr.split("_")[2]).split(":")[1]);
            $(this).parents(".faceMergeUL").find("li").eq(3).find("input").val((selectStr.split("_")[3]).split(":")[1]);
        }

    })



}
//定时器，截屏时点击操作框，若无人再点击则10s后自动隐藏
function timeCount() {
    if ($(".sildeMore").css("right") == "0px") {
        count = count + 1;
        console.log(count);
        if (count == 10) {
            $(".sildeMore").css("right", "-60px");
            clearInterval(hideSlideTimer);
            count = 0;
        }
    }


}
//定时器，截屏时点击操作框，若无人再点击则10s后自动隐藏
function timeCount1() {
    if ($(".sildeMore1").css("right") == "0px") {
        count1 = count1 + 1;
        console.log(count1);
        if (count1 == 10) {
            $(".sildeMore1").css("right", "-60px");
            clearInterval(hideSlideTimer2);
            count1 = 0;
        }
    }
}
function getData(URL, num) {
    content1 = '';
    if (URL != oldURL) {//若改变url则将原来url所得到的数据去除
        if (contentStr[num] != undefined || contentStr[num] != "") {
            $(".programList").children().remove();
            $("#Screen").html(contentStr[parseInt(num)]);
            // changeStyle();
        }
    }
    $.ajax({
        url: URL + "/wpgetxmlids.asp?rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000) + "&utf8=1",
        dataType: 'xml',
        type: "GET",
        timeout: 5000,
        error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {

            }
            $("#functionButton").hide();

        }, success: function (xml) {
            $("#functionButton").css("display", "block");
            if ($(xml).find("item").length <= 0) {
                $(".programList").html("<p align='center'>" + getLanguageMsg("当前节目单为空！", $.cookie("yuyan")) + "</p>")
            } else {
                var clientInfo = $(xml).find("clientInfo");//获得终端信息标签
                var clientName1 = $(clientInfo).attr("clientname");//获得终端名称
                var playTask = $(clientInfo).attr("playtask");
                var arrayTask = "";
                var currentTask = "";
                var programListInfo = "";
                if (playTask == undefined || playTask == "" || playTask == null) {
                    arrayTask = "";
                } else {
                    arrayTask = playTask.split("/");
                    currentTask = arrayTask[1];//获得当前播放节目的id
                }
                var playVol = $(clientInfo).attr("playvol");//获得当前的系统音量
                var hostName = $(clientInfo).attr("hostname");//获得当前的计算机名
                var menuPath = $(clientInfo).attr("menupath");//获得当前播放节目单所存储的位置
                var menuInfo = $(clientInfo).attr("menuinfo");//获取当前节目单名
                var localIp = $(".refreshProgram img").attr("localip", $(clientInfo).attr("controlroom"));
                if ($(clientInfo).attr("scrrate") != null && $(clientInfo).attr("scrrate") != undefined) {
                    screenWidth = parseInt($(clientInfo).attr("scrrate").split("_")[0]);//获得显示端的宽度

                    screenHeight = parseInt($(clientInfo).attr("scrrate").split("_")[1]);//获得显示端的高度
                    widthRate = screenWidth / canvaswindowWidth;
                }
                var playState = $(clientInfo).attr("playstate");
                var playOrPause = "";
                var playStart = ""
                if (playState != null && playState != undefined) {
                    playOrPause = playState.split("_");
                    playStart = playOrPause[0];
                }
                changPlayStatus(playStart);//根据获取到的数据改变页面中播放的状态
                var findex = "";
                var systemSound = "";
                var validValue = 0;
                var objValid = "";
                var objValid2 = "";

                if (playVol != null && playVol != undefined && playVol != "") {
                    findex = playVol.split("/");
                    systemSound = findex[0];
                    objValid = playVol.split("/");
                    if (objValid.length > 1) {
                        objValid2 = objValid[1].split("_");
                        if (objValid2 != "" && objValid2.length > 1 && objValid2[1] == 1) {
                            validValue = 1;
                        }
                    }
                }
                if (true || (validValue == 1)) {
                    var nosoundVao = systemSound & 0x008000;//判断系统有没有静音
                    systemSound = systemSound & ~0x008000;
                    if (nosoundVao == 0x008000) {//判断当前系统是不是静音状态
                        $(".noSound").attr("src", "images/kongzhi/noSound.png");
                    } else {
                        $(".noSound").attr("src", "images/kongzhi/tingzhibofang.png");
                    }
                }
                var mplayVol = "";
                if (objValid[1] != "" && objValid[1] != null) {
                    if (objValid[1].split("_")[1] == "0") {
                        mplayVol = "0";
                    } else {
                        mplayVol = objValid[1].split("_")[0];
                    }

                }

                var playProc = "";
                var playProc1 = ""
                if ($(clientInfo).attr("playproc") != null && $(clientInfo).attr("playproc") != undefined) {
                    playProc = $(clientInfo).attr("playproc").split("_");
                    playProc1 = playProc = parseInt(playProc[0]);//读取当前视频播放进度的万分比
                }
                var menuStatearr = "";
                var menuState = "";
                var thisStatus = "";
                var mainStatus = "";//值为0-10，共十种状态
                if (playTask != null && playTask != undefined) {
                    menuStatearr = playTask.split("\/");
                    menuState = (parseInt(menuStatearr[0]) >> 6) & 0x03;
                    thisStatus = menuStatearr[2].split("_")[1];
                    mainStatus = parseInt(menuStatearr[0]) & 0x03f;//值为0-10，共十种状态
                }
                if (parseInt(thisStatus) == 1) {
                    showStatus(mainStatus, num)
                }
                //如果当前页面是在终端打开时，将控制室的地址赋值当前终端，方便后屋可以返回到总体的控制页面
                if ($("#clientList li span").text() == "返回中控页") {
                    $("#clientList li").attr("src", $(xml).find("clientInfo").attr("controlroom"));
                }
                var playOrPause = "";
                var playStatus = "";//获得当前节目所处的状态，是暂停还是继续
                if (playState != null && playState != undefined) {
                    playOrPause = playState.split("_");
                    playStatus = playOrPause[0];//获得当前节目所处的状态，是暂停还是继续
                }
                var gGetPlayDuringarr = "";
                var gGetPlayDuring = "";

                if ($(clientInfo).attr("playdur") != null && $(clientInfo).attr("playdur") != undefined) {
                    gGetPlayDuringarr = $(clientInfo).attr("playdur").split("_");
                    gGetPlayDuring = parseInt(gGetPlayDuringarr[0]);
                }

                $("#rangeRate1").attr("max", gGetPlayDuring);//当前获取的音视频的总长
                var strs = parseFloat($("#rangeRate1").css("width"));
                // $("#alltotalValue").html(secondToMinute(strs));
                $("#alltotalValue").html(secondToMinute(gGetPlayDuring));
                $("#rateProgressValue").html(secondToMinute((playProc1 / 10000) * strs));
                //playState为音视频播放器播放状态（播放3，暂停2，停止1）,playtask(最前字节为显示端播放任务状态/播放任务号(2字节任务号/1字节栏目内任务号))，
                //playProc为音视频播放进度万分比，playVol为播放机音量/音视频播放程序音量，g_getplayduring音视频文件的总时长，以毫秒为单位

                changPlayStatus(playStatus);
                changeMenuState(menuState);
                setTimeout("changeMenuState(" + menuState + ")", 1000);

                if (findex >= 0) {

                    playVol = playVol.substr(0, findex);
                    findex = playVol.indexOf("/");
                    if (findex >= 0) {
                        mplayVol = playVol.substr(findex + 1, playVol.length - findex - 1);
                        playVol = playVol.substr(0, findex);
                    }
                }
                $(xml).find("item").each(function (i) {
                    var downLink = $(this).find("downLink").text();
                    var itemType = $(this).find("itemType").text();
                    var moreInfo = $(this).find("moreInfo");	//其他信息字符串
                    var markID = $(this).find("markID").text();		//任务号 素材号-栏目号-主任务号-栏目内任务号
                    var Win = $(this).find("win").text();
                    var tempMarkID = "";
                    var taskID = "";	//任务号
                    var moreInfo2 = "";

                    var windowsNum = "";
                    var numberWindows = "";
                    var win = "";
                    var layOutName = ""
                    var newMoreInfo = ""

                    if (markID != undefined && markID != null) {
                        tempMarkID = markID.split("-");

                        if (parseInt(tempMarkID[1]) > 1) {
                            taskID = parseInt(tempMarkID[2]) + (parseInt(tempMarkID[3]) << 16);
                        } else {
                            taskID = tempMarkID[2];	//任务号
                        }
                        moreInfo2 = moreInfo.text().split("\\027");
                        if (moreInfo2[0] == "") {
                            moreInfo2[0] = "[" + ItemType(itemType, downLink) + "]";
                        }


                        if (moreInfo2[1] != "" && moreInfo2[1] != null && moreInfo2[1] != undefined) {
                            newMoreInfo = moreInfo2[1].split("_")[1];
                        }

                    }
                    if (Win != undefined && Win != null) {
                        windowsNum = Win.split(":");
                        numberWindows = windowsNum[0].split("-");
                        win = numberWindows[0];
                        layOutName = numberWindows[1];
                    }

                    if ($(this).find("iconLink").text().indexOf("$$") >= 0) {
                        iconLink = newurl + "/" + $(this).find("iconLink").text();
                    } else {
                        iconLink = "http://" + $(".refreshProgram img").attr("localip") + ":8080/" + $(this).find("iconLink").text();
                    }

                    //缩略图
                    var randomColor = color16(win);
                    programListInfo = "<div class='programListInfo'><p ><span>" + getLanguageMsg("地址:", $.cookie("yuyan")) + "</span>" + downLink + "</p><p><span>" + getLanguageMsg("布局:", $.cookie("yuyan")) + "</span>" + layOutName + "</p></div>"

                    var imagesrc = "<span class='bgSpan' onclick=\"docmd(67,'" + taskID + "');\"><img src='" + iconLink + "' align='absmiddle' onerror='changeImage(this)'/></span>"//类型图片
                    var inImage = "<div class='startNow'><img  src='images/liebiao/bofang.png' class='playNowprogram' onclick=\"startNow('" + taskID + "');\"/><img class='moreProgramInfo' src='images/liebiao/gengduo.png' /></div>";//'"docmd(16,"'+taskID+'")"'
                    var infoProgram = "<span class='infoProgram'>" + ItemType(itemType, downLink) + "/" + newMoreInfo + "/<span '><i  style='color:" + randomColor + "'>" + win + "</i>-" + Win.split(":")[0].split("-")[1] + "</span></span>";
                    //节目项列表，itemType=14的为指令，不需要显示在页面中
                    if (itemType != "14") {
                        content1 += "<div class='left' taskid='" + taskID + "'>" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "' ><span class='programListSpan' markID=" + markID + " itemType=" + itemType + " style='' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "'," + itemType + ",this);\" ><p class='programFileName' style='width:90%;'>" + moreInfo2[0] + "</p><p class='timeLong' style='width:90%;font-size:14px;color:#fff;margin-top:5px;'>" + infoProgram + "</p></span>" + inImage + "</div></div>" + programListInfo + "<div class='left1' taskid='" + taskID + "' style='display:none;'></div>";
                    }
                });
                var strNum = parseInt($("#top").attr("indexnumber"));
                contentStr[strNum] = content1;
                $(".programList").html(content1);
                dragScreen();
                $(".leftList").css("width", $(".left").width() - $(".bgSpan").width() - parseFloat($(".bgSpan").css("marginLeft")) - parseFloat($(".bgSpan").css("marginRight")) - 1);
                $(".programListSpan").css("width", $(".leftList").width() - $(".startNow").width() - parseFloat($(".startNow").css("marginLeft")) - parseFloat($(".startNow").css("marginRight")));
                $(".programFileName").css("marginTop", ($(".programListSpan").height() - $(".programFileName").height() - $(".timeLong").height() - parseFloat($(".timeLong").css("marginTop"))) / 2);

                $(".logo").attr("screenWidth", screenWidth);//将获取到前端屏的宽高存储，方便在截屏时使用
                $(".logo").attr("screenHeight", screenHeight);
                //获得焦点的项目样式改变
                changeStyle();

                //显示系统音量
                if (soundFlag <= 0) {
                    $("#range").val(systemSound);
                    $("#value").html(systemSound);
                    $("#range2").val(mplayVol);
                    $("#value2").html(mplayVol);
                }
                //根据当前的手动还是自动的状态切换图标，点击手动则关闭自动模式，否则开启，默认情况下则开启的是自动模式
                $(".computerName").html("<span>" + getLanguageMsg("计算机名:", $.cookie("yuyan")) + "</span>" + hostName);
                $(".clientNameInfo").html("<span>" + getLanguageMsg("终端名:", $.cookie("yuyan")) + "</span>" + clientName1);

                //如果当前没有正在播放的节目，则默认将第一个节目设置为获得焦点的节目
                if (currentTask <= 0) {
                    currentTask = 1;

                    $(".programList").find(".left").eq(0).find(".leftList span").click();
                } else {
                    for (var i = 0; i < $(".left").length; i++) {
                        if (currentTask == $(".left").eq(i).attr("taskid")) {
                            $(".left").eq(i).find(".leftList span").click();
                        }
                    }
                    for (var k = 0; k < $(".left").length; k++) {
                        if ($(".left").eq(k).attr("taskid") == currentTask) {
                            $(".left").eq(k).find(".timeLong .infoProgram").css("color", "#d11b28");
                        }
                    }
                }

            }
            //将新的数据请求完毕之后将新的数据置为旧的数据，方便下次比较
            oldData = $(xml).text();
        }
    });
    //将当前的url设置为oldurl,也是为了切换显示端时，让程序进行识别，清除原来的数据
    oldURL = URL;
}
//判断当前的列表是那种类型，根据当前的类型显示不同的操作按钮
function showCtrlBar(barID, taskID, itemtype, thisList) {
    var flag = 0;
    var downLink = "";
    rateLeft = 0;
    var imageUrl = $(".left").find(".leftList[taskId='" + taskID + "']").prev(".bgSpan").find("img").attr("src");
    var fileName = $(".left").find(".leftList[taskId='" + taskID + "']").children("span").find("p").eq(0).text() + "<br><span style='font-size:12px;color:#b3b3b3;'>" + $(".left").find(".leftList[taskId='" + taskID + "']").children("span").find("p").eq(1).find("span").text() + "</span>";
    downLink = $(".left").find(".leftList[taskId='" + taskID + "']").attr("downlink");
    var nowWindow = $(".left").find(".leftList[taskId='" + taskID + "']").attr("windowsNum");
    $("#top").attr("nowWindow", nowWindow);
    $("#functionButton .images").attr("src", imageUrl);
    href = $("#top").attr("src") + "/$$" + downLink;//预览
    if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
        delete socket1;
        socket1 = null;
    }
    if (socket != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
        delete socket;
        socket = null;
    }
    if (itemtype == 12 || itemtype == 1012 || itemtype == 0 || itemtype == 1000 || itemtype == 11 || itemtype == 1011) {
        itemtype = checkFileType(itemtype, downLink);
    }
    //音视频时建立轮询，启用socket,其他的时候关闭socket，清除轮询
    if (itemtype == 10 || itemtype == 1010 || itemtype == 9 || itemtype == 1009 || itemtype == 7 || itemtype == 1007) {
        clearInterval(timer);
        var playOrPause = $("thisList").attr("playStatus");
        changPlayStatus(playOrPause);
        $(".picture").css("display", "none");
        $(".ppt").css("display", "none");
        $(".musicOrVideo").css("display", "block");
        $("#functionButton .fileName1").html(fileName);
        $("#functionButton .fileName1").css("text-align", "left");
        var bottomH1 = $(".bottom").height();
        var rateH = $("#rateProgress").height();
        var fil1H = $(".fileName1").height();
        var bottomH = $("#bottom").height();
        var range1 = $("#rangeRate1").height();
        var imageMargin = (bottomH1 - liSpanH - bH) / 2;
        var str1 = videoStr(hrefDownLoad, href, imageMargin);
        $(".musicOrVideo a").parent().remove();
        $(".musicOrVideo ul").append(str1);
        $(".musicOrVideo .controlBottomTab li b").css("width", "40%");
        $(".showRate").css("width", $(".musicOrVideo").width() - $(".musicOrVideo img").eq(0).width() - parseFloat($(".musicOrVideo img").eq(0).css("marginLeft")) - parseFloat($(".musicOrVideo img").eq(0).css("marginRight")));
        $("#rangeRate1").css("width", $(".showRate").width() - $("#rateProgressValue").width() * 2 - parseFloat($("#rateProgressValue").css("marginLeft")) - parseFloat($("#alltotalValue").css("marginRight")));
        timer = setInterval("getRate(newurl)", 1000);
    }
    else if (itemtype == 8 || itemtype == 1008)//office文档
    {
        //判断office文件中只有含有ppt和pptx才是ppt文件，其他的不做ppt处理
        if (downLink != null && (fileName.indexOf(".ppt") >= 0 || fileName.indexOf(".pptx") >= 0 || fileName.indexOf(".pps") >= 0 || fileName.indexOf(".ppsx") >= 0)) {
            clearInterval(timer);
            $(".picture").css("display", "none");
            $(".musicOrVideo").css("display", "none");
            $(".ppt").css("display", "block");

            $("#functionButton .fileName").html(fileName);
            var bottomH = $("#bottom").height();
            var imageMargin = (bottomH - liSpanH - bH) / 2;
            var str3 = pptStr(hrefDownLoad, href, imageMargin);
            $(".ppt a").parent().remove();
            $(".ppt ul").append(str3);
        } else {//除了ppt和pptx的office文档当做图类型处理片
            clearInterval(timer);
            $(".musicOrVideo").css("display", "none");
            $(".ppt").css("display", "none");
            $(".picture").css("display", "block");
            $("#functionButton .fileName").html(fileName);
            var bottomH = $(".bottom").height();
            var imageMargin = (bottomH - liSpanH - bH) / 2;
            var str = picStr(hrefDownLoad, href, imageMargin);
            $(".picture a").parent().remove();
            $(".picture ul").append(str);
        }
    } else if (itemtype == 1 || itemtype == 1001 || itemtype == 2 || itemtype == 1002 || itemtype == 4 || itemtype == 1004 || itemtype == 5 || itemtype == 1005 || itemtype == 6 || itemtype == 1006 || itemtype == 7 || itemtype == 1007) {
        clearInterval(timer);
        $(".musicOrVideo").css("display", "none");
        $(".ppt").css("display", "none");
        $(".picture").css("display", "block");
        $("#functionButton .fileName").html(fileName);
        var bottomH = $(".bottom").height();
        var imageMargin = (bottomH - liSpanH - bH) / 2;
        var str = picStr(hrefDownLoad, href, imageMargin);
        $(".picture a").parent().remove();
        $(".picture ul").append(str);
    } else {//其他的所有格式都当做图片进行处理
        clearInterval(timer);
        $(".musicOrVideo").css("display", "none");
        $(".ppt").css("display", "none");
        $(".picture").css("display", "block");
        $("#functionButton .fileName").html(fileName);
        var bottomH = $(".bottom").height();
        var imageMargin = (bottomH - liSpanH - bH) / 2;
        var str = picStr(hrefDownLoad, href, imageMargin);
        $(".picture a").parent().remove();
        $(".picture ul").append(str);
    }
    if (document.documentElement.clientWidth >= 1000) {

        $(".bottomPPTFunctionBtn .controlBottomTab").css("width", "200%");
    } else {
        $(".bottomPPTFunctionBtn .controlBottomTab").css("width", "700%");

    }
    if (document.documentElement.clientWidth >= 1000) {

        $(".picture .otherbottomFunction .controlBottomTab").css("width", "200%");
    } else {
        $(".picture .otherbottomFunction .controlBottomTab").css("width", "700%");

    }
    if (document.documentElement.clientWidth >= 1000) {

        $(".musicOrVideo .otherbottomFunction .controlBottomTab").css("width", "200%");
    } else {
        $(".musicOrVideo .otherbottomFunction .controlBottomTab").css("width", "700%");

    }
    if ($("#div1").attr("class") == "open1") {
        $(".startUp").attr("onclick", "docmd(67,'" + taskID + "')");//跳转到当前任务
    } else {
        $(".startUp").attr("onclick", "docmd(16,'" + taskID + "')");//跳转到当前任务
    }
    liSpanH = $(".controlBottomTab li span").height()
    $(".bottomPPTFunctionBtn li b").css("marginTop", ($(".bottomPPTFunctionBtn li").height() - liSpanH - bH) / 2);
    $(".otherbottomFunction li b").css("marginTop", ($(".otherbottomFunction li").height() - liSpanH - bH) / 2);
    $(".pause").attr("onclick", "docmd(70,'0')");
    if ($.cookie("yuyan") == "en") {
        $(".downFile span").hide();
    } else {
        $(".downFile span").show();
    }
}
//专门为了获取音视频的播放状态，获取的方式和getData（）相同，只不过不再对其他的数据进行处理
function getRate(URL) {
    if (dragStartjt) { return; }//判断是不是要进行拖拽的动作，若是则将获取进度的长连接终止掉
    if (sendding) { return; }
    sendding = true;
    if (URL != oldURL) {//若改变url则将原来url所得到的数据去除
        $(".programList").children().remove();
    }
    //没有socket建立socket,已经有socket则直接发送数据即可
    if (socket != null && socket.readyState == 1) {
        socket.send("wpgetxmlids.asp?gettype=9&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000));
    } else {
        connect();
        if (socket != null && socket.readyState == 1) {
            socket.send("wpgetxmlids.asp?gettype=9&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000));
            sendding = false;
            return;

        }
        $.ajax({
            url: URL + "/wpgetxmlids.asp?gettype=9&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'xml',
            type: 'GET',		//提交方式
            timeout: 2000,      //失败时间
            //timeout: 0,		//失败时间
            error: function (a, b, c) {
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                }
            },
            success: function (xml) {
                $("#functionButton").css("display", "block");
                //每次请求成功后都将之前所获得的播放列表的数据清除

                var clientInfo = $(xml).find("clientInfo");//获得终端信息标签

                var playProc = $(clientInfo).attr("playproc").split("_");
                var playProc1 = playProc = parseInt(playProc[0]);
                var playTask = $(clientInfo).attr("playtask");
                var gGetPlayDuringarr = $(clientInfo).attr("playdur").split("_");
                var gGetPlayDuring = parseInt(gGetPlayDuringarr[0]);
                var menuStatearr = playTask.split("\/");
                var menuState = (parseInt(menuStatearr[0]) >> 6) & 0x03;
                var playVol = $(clientInfo).attr("playvol");//获得当前的系统音量
                var findex = "";
                var systemSound = "";
                var validValue = 0;
                var objValid = "";
                var objValid2 = "";
                var playState = $(clientInfo).attr("playstate");
                var playOrPause = "";
                var playStart = ""
                if (playState != null && playState != undefined) {
                    playOrPause = playState.split("_");
                    playStart = playOrPause[0];
                }
                if (playVol != null && playVol != undefined && playVol != "") {
                    findex = playVol.split("/");
                    systemSound = findex[0];
                    objValid = playVol.split("/");
                    if (objValid.length > 1) {
                        objValid2 = objValid[1].split("_");
                        if (objValid2 != "" && objValid2.length > 1 && objValid2[1] == 1) {
                            validValue = 1;
                        }
                    }
                }
                if (true || (validValue == 1)) {
                    var nosoundVao = systemSound & 0x008000;//判断系统有没有静音
                    systemSound = systemSound & ~0x008000;
                    if (nosoundVao == 0x008000) {//判断当前系统是不是静音状态
                        $(".noSound").attr("src", "images/kongzhi/noSound.png");
                    } else {
                        $(".noSound").attr("src", "images/kongzhi/tingzhibofang.png");
                    }
                }
                var mplayVol = "";
                if (objValid[1] != "" && objValid[1] != null) {
                    if (objValid[1].split("_")[1] == "0") {
                        mplayVol = "0";
                    } else {
                        mplayVol = objValid[1].split("_")[0];
                    }

                }

                if (menuState != oldmenuState) {
                    changeMenuState(menuState);
                }
                oldmenuState = menuState;
                $("#rangeRate1").attr("max", gGetPlayDuring);
                var strs = parseFloat($("#rangeRate1").css("width"));
                if (strs == NaN) {
                    strs = 0;
                }
                $("#rateProgressValue").html(secondToMinute((playProc1 / 10000) * strs));
                $("#alltotalValue").html(secondToMinute(gGetPlayDuring));
                $("#range").val(systemSound);
                $("#value").html(systemSound);
            }
        });
    }
    sendding = false;
}
//建立长连接 
function connect() {
    var hosturl = "";
    if (newurl == "") {
        hosturl = window.location.href.split("//")[1].split("/")[0];
    } else {
        hosturl = newurl.split("//")[1];
    }
    var win = "";
    if ($("#top").attr("nowwindow") != "" && $("#top").attr("nowwindow") != undefined && $("#top").attr("nowwindow") != null) {
        win = $("#top").attr("nowwindow");
    } else {
        win = 0;
    }
    var host = "ws://" + hosturl + "/wpgetxmlids.asp?gettype=9&utf8=1&win=" + win + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
    try {
        if (socket == null || socket.readyState != 1) {//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
            if (socket != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
                delete socket;
            }
            socket = new WebSocket(host);//建立一个WebSocket
        }

        socket.onopen = function () {//建立连接
        }
        socket.onmessage = function (data) {//接收送服务器端返回的数据
            timeFlag--;
            if (soundFlag > 0) {
                soundFlag--;
            }
            console.log(data);
            $("#functionButton").css("display", "block");
            //每次请求成功后都将之前所获得的播放列表的数据清除

            //$("#Screen").attr("align", "left");
            var clientInfo = $($(data.data)[2]).find("clientInfo");//获得终端信息标签
            if (clientInfo == null) {
                return;
            }
            var playProc = clientInfo.attr("playProc").split("_");
            var playProc1 = playProc = parseInt(playProc[0]);
            var playTask = clientInfo.attr("playTask");
            var gGetPlayDuringarr = clientInfo.attr("playDur").split("_");
            var gGetPlayDuring = parseInt(gGetPlayDuringarr[0]);
            var menuStatearr = playTask.split("\/");
            var menuState = (parseInt(menuStatearr[0]) >> 6) & 0x03;

            var playVol = $(clientInfo).attr("playVol");//获得当前的系统音量
            var findex = "";
            var systemSound = "";
            var validValue = 0;
            var objValid = "";
            var objValid2 = "";
            var playState = $(clientInfo).attr("playstate");
            var playOrPause = "";
            var playStart = ""
            if (playState != null && playState != undefined) {
                playOrPause = playState.split("_");
                playStart = playOrPause[0];
            }
            var arrayTask = "";
            var currentTask = ""
            if (playTask == undefined || playTask == "") {
                arrayTask = "";
            } else {
                arrayTask = playTask.split("/");
                currentTask = arrayTask[1];//获得当前播放节目的id
            }
            $("#rangeRate1").attr("max", gGetPlayDuring);
            if (playVol != null && playVol != undefined && playVol != "") {
                systemSound = findex[0];
                objValid = playVol.split("/");
                if (objValid.length > 1) {
                    objValid2 = objValid[1].split("_");
                    if (objValid2 != "" && objValid2.length > 1 && objValid2[1] == "1") {
                        validValue = 1;
                    }
                }
            }

            if (true || (validValue == 1)) {
                var nosoundVao = systemSound & 0x008000;//判断系统有没有静音
                systemSound = systemSound & ~0x008000;
                if (nosoundVao == 0x008000) {//判断当前系统是不是静音状态
                    $(".noSound").attr("src", "images/kongzhi/noSound.png");
                } else {
                    $(".noSound").attr("src", "images/kongzhi/tingzhibofang.png");
                }
            }
            var mplayVol = "";
            if (objValid[1] != "" && objValid[1] != null) {
                if (objValid[1].split("_")[1] == "0") {
                    mplayVol = "0";
                } else {
                    mplayVol = objValid[1].split("_")[0];
                }

            }
            screenWidth = parseInt(clientInfo.attr("scrRate").split("_")[0]);
            screenHeight = parseInt(clientInfo.attr("scrRate").split("_")[1]);
            if (menuState != oldmenuState) {
                // setTimeout("changeMenuState(" + menuState + ")", 1000);
                changeMenuState(menuState);
            }
            oldmenuState = menuState;

            var reteWidth = parseFloat($("#rangeRate1").css("width")) - parseInt($("#rangeRate2").css("width"));
            var strs = parseFloat($("#rangeRate1").attr("max"));

            var dddty = (playProc1 / 10000) * strs / 1000;
            rateLeft = parseFloat(dddty * reteWidth / (strs / 1000));
            if (rateLeft >= reteWidth) {
                rateLeft = 0;
            }
            var gGetPlayDuringarr = "";
            var gGetPlayDuring = "";
            if ($(clientInfo).attr("playdur") != null && $(clientInfo).attr("playdur") != undefined) {
                gGetPlayDuringarr = $(clientInfo).attr("playdur").split("_");
                gGetPlayDuring = parseInt(gGetPlayDuringarr[0]);
            }
            if (timeFlag <= 0) {
                if (clientInfo.attr("playproc").split("_")[1] == "1") {
                    $("#rateProgressValue").html(secondToMinute((playProc1 / 10000) * strs));
                    $("#alltotalValue").html(secondToMinute(gGetPlayDuring));
                    $("#rangeRate2").css("left", rateLeft);
                    $("#rangeLeft").css("width", rateLeft);
                } else {
                    $("#rateProgressValue").html("00:00");
                    $("#rangeRate2").css("left", "0px");
                    $("#rangeLeft").css("width", "0px");
                }

                console.log("2_" + secondToMinute((playProc1 / 10000) * strs));
            }

        }

        socket.onclose = function () {
        }

    } catch (exception) {
    }

}
function ItemType(itemtype, downLink) {
    //音视频
    if (itemtype == 10 || itemtype == 1010 || itemtype == 9 || itemtype == 1009) {
        return getLanguageMsg("音视频", $.cookie("yuyan"));
    }
    else if (itemtype == 8 || itemtype == 1008)//office文档
    {
        //判断office文件中只有含有ppt和pptx才是ppt文件，其他的不做ppt处理
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".pptx") >= 0)) {
            return getLanguageMsg("Office文档", $.cookie("yuyan"));
        } else {//除了ppt和pptx的office文档当做图类型处理片
            return getLanguageMsg("图片", $.cookie("yuyan"));
        }
    }//对文档进行处理
    else if (itemtype == 1 || itemtype == 1001) {
        return getLanguageMsg("文本", $.cookie("yuyan"));
    }
    else if (itemtype == 12 || itemtype == 1012 || itemtype == 0 || itemtype == 1000 || itemtype == 11 || itemtype == 1011) {
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".xls") >= 0 || downLink.indexOf(".docx") >= 0 || downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".doc") >= 0 || downLink.indexOf(".xlsx") >= 0 || downLink.indexOf(".pps") >= 0 || downLink.indexOf(".pptx") >= 0 || downLink.indexOf(".ppsx") >= 0)) {
            return getLanguageMsg("Office文档", $.cookie("yuyan"));
        } else if (downLink.indexOf(".txt") >= 0) {
            return getLanguageMsg("文本", $.cookie("yuyan"));
        } else if (downLink.indexOf(".htm") >= 0 || downLink.indexOf(".html") >= 0 || downLink.indexOf(".asp") >= 0 || downLink.indexOf(".aspx") >= 0 || downLink.indexOf(".php") >= 0 || downLink.indexOf(".jsp") >= 0 || downLink.indexOf(".shtml") >= 0 || downLink.indexOf(".pdf") >= 0) {
            return getLanguageMsg("网页", $.cookie("yuyan"));
        } else if (downLink.indexOf(".gif") >= 0 || downLink.indexOf(".jpg") >= 0 || downLink.indexOf(".bmp") >= 0 || downLink.indexOf(".png") >= 0 || downLink.indexOf(".tiff") >= 0 || downLink.indexOf(".tif") >= 0 || downLink.indexOf(".jpeg" >= 0) || downLink.indexOf(".ico") >= 0) {
            return getLanguageMsg("图片", $.cookie("yuyan"))
        } else if (downLink.indexOf(".swf") >= 0) {
            return getLanguageMsg("动画", $.cookie("yuyan"))
        } else if (downLink.indexOf(".wav") >= 0 || downLink.indexOf(".aif") >= 0 || downLink.indexOf(".mp3") >= 0 || downLink.indexOf(".wma") >= 0 || downLink.indexOf(".cda") >= 0 || downLink.indexOf(".au") >= 0 || downLink.indexOf(".midi") >= 0 || downLink.indexOf(".aac") >= 0 || downLink.indexOf(".ape") >= 0 || downLink.indexOf(".ogg") >= 0) {
            return getLanguageMsg("音频", $.cookie("yuyan"))
        } else if (downLink.indexOf(".avi") >= 0 || downLink.indexOf(".mpg") >= 0 || downLink.indexOf(".mpeg") >= 0 || downLink.indexOf(".mp4") >= 0 || downLink.indexOf(".wmv") >= 0 || downLink.indexOf(".asf") >= 0 || downLink.indexOf(".vob") >= 0 || downLink.indexOf(".rm") >= 0 || downLink.indexOf(".rmvb") >= 0 || downLink.indexOf(".flv") >= 0 || downLink.indexOf(".f4v") >= 0 || downLink.indexOf(".mov") >= 0 || downLink.indexOf(".dat") >= 0) {
            return getLanguageMsg("视频", $.cookie("yuyan"))

        } else if (downLink.indexOf(".zip") >= 0 || downLink.indexOf(".rar") >= 0 || downLink.indexOf(".7z") >= 0 || downLink.indexOf(".tar") >= 0 || downLink.indexOf(".xz") >= 0 || downLink.indexOf(".bz2") >= 0) {
            return getLanguageMsg("压缩文件", $.cookie("yuyan"))
        } else {
            if (itemtype == 11 || itemtype == 1011) {
                return getLanguageMsg("操作系统自检", $.cookie("yuyan"));
            } else if (itemtype == 12 || itemtype == 1012) {
                return getLanguageMsg("应用程序", $.cookie("yuyan"))
            } else {
                return getLanguageMsg("自适应", $.cookie("yuyan"))
            }
        }
    } else if (itemtype == 2 || itemtype == 1002) {//其他的所有格式都当做图片进行处理
        return getLanguageMsg("网页", $.cookie("yuyan"));

    } else if (itemtype == 3 || itemtype == 1003) {
        return getLanguageMsg("图片", $.cookie("yuyan"));
    } else if (itemtype == 4 || itemtype == 1004) {
        return getLanguageMsg("通知(静态)", $.cookie("yuyan"));
    } else if (itemtype == 5 || itemtype == 1005) {
        return getLanguageMsg("通知(向上滚动)", $.cookie("yuyan"));
    } else if (itemtype == 6 || itemtype == 1006) {
        return getLanguageMsg("字幕(向左滚动)", $.cookie("yuyan"));
    } else if (itemtype == 7 || itemtype == 1007) {
        return getLanguageMsg("动画", $.cookie("yuyan"));
    } else if (itemtype == 13 || itemtype == 1013) {
        return getLanguageMsg("远程指令", $.cookie("yuyan"))
    } else if (itemtype == 14 || itemtype == 1014) {
        return getLanguageMsg("栏目", $.cookie("yuyan"))
    }

}
//根据文件名
function checkFileType(itemtype, downLink) {
    if (itemtype == 12 || itemtype == 1012 || itemtype == 0 || itemtype == 1000 || itemtype == 11 || itemtype == 1011) {
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".xls") >= 0 || downLink.indexOf(".docx") >= 0 || downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".doc") >= 0 || downLink.indexOf(".xlsx") >= 0 || downLink.indexOf(".pps") >= 0 || downLink.indexOf(".pptx") >= 0 || downLink.indexOf(".ppsx") >= 0)) {
            return parseInt(itemtype / 1000) * 1000 + 8;
        } else if (downLink.indexOf(".txt") >= 0) {
            return parseInt(itemtype / 1000) * 1000 + 1
        } else if (downLink.indexOf(".htm") >= 0 || downLink.indexOf(".html") >= 0 || downLink.indexOf(".asp") >= 0 || downLink.indexOf(".aspx") >= 0 || downLink.indexOf(".php") >= 0 || downLink.indexOf(".jsp") >= 0 || downLink.indexOf(".shtml") >= 0 || downLink.indexOf(".pdf") >= 0) {
            return parseInt(itemtype / 1000) * 1000 + 2;
        } else if (downLink.indexOf(".gif") >= 0 || downLink.indexOf(".jpg") >= 0 || downLink.indexOf(".bmp") >= 0 || downLink.indexOf(".png") >= 0 || downLink.indexOf(".tiff") >= 0 || downLink.indexOf(".tif") >= 0 || downLink.indexOf(".jpeg") >= 0 || downLink.indexOf(".ico") >= 0) {
            return parseInt(itemtype / 1000) * 1000 + 3
        } else if (downLink.indexOf(".swf") >= 0) {
            return parseInt(itemtype / 1000) * 1000 + 7
        } else if (downLink.indexOf(".wav") >= 0 || downLink.indexOf(".aif") >= 0 || downLink.indexOf(".mp3") >= 0 || downLink.indexOf(".wma") >= 0 || downLink.indexOf(".cda") >= 0 || downLink.indexOf(".au") >= 0 || downLink.indexOf(".midi") >= 0 || downLink.indexOf(".aac") >= 0 || downLink.indexOf(".ape") >= 0 || downLink.indexOf(".ogg") >= 0) {
            return parseInt(itemtype / 1000) * 1000 + 9
        } else if (downLink.indexOf(".avi") >= 0 || downLink.indexOf(".mpg") >= 0 || downLink.indexOf(".mpeg") >= 0 || downLink.indexOf(".mp4") >= 0 || downLink.indexOf(".wmv") >= 0 || downLink.indexOf(".asf") >= 0 || downLink.indexOf(".vob") >= 0 || downLink.indexOf(".rm") >= 0 || downLink.indexOf(".rmvb") >= 0 || downLink.indexOf(".flv") >= 0 || downLink.indexOf(".f4v") >= 0 || downLink.indexOf(".mov") >= 0 || downLink.indexOf(".dat") >= 0) {
            return parseInt(itemtype / 1000) * 1000 + 10
        } else if (downLink.indexOf(".zip") >= 0 || downLink.indexOf(".rar") >= 0 || downLink.indexOf(".7z") >= 0 || downLink.indexOf(".tar") >= 0 || downLink.indexOf(".xz") >= 0 || downLink.indexOf(".bz2") >= 0) {
            return itemtype;
        } else {
            if (itemtype == 11 || itemtype == 1011) {
                return itemtype;
            } else if (itemtype == 12 || itemtype == 1012) {
                return itemtype;
            } else {
                return itemtype;
            }
        }

    }
}
function changeStyle() {
    $(".leftList .programListSpan").click(function () {

        clickProList(this);
    })
    $(".leftList .startNow img").click(function () {
        clickProList($(this).parent());
        $(this).parent().prev().click();
    })
    $(".bgSpan img").click(function () {
        clickProList(this);
        $(this).parent().next().find(".programListSpan").click();
    })
    $(".moreProgramInfo").click(function () {


        var boderStyle = "8px 8px 0px 0px";
        if ($(this).parent().parent().parent().next().height() <= 0) {
            $(".programListInfo").css("height", "0px");
            $(this).parent().parent().parent().next().animate({

                height: "80px",

            })
            $(".left").css("borderRadius", "8px");
            $(".left").css("borderBottom", "0");
            $(this).parent().parent().parent().css("borderRadius", boderStyle)
            $(this).parent().parent().parent().css("borderBottom", "1px solid #eee");
        } else {
            $(this).parent().parent().parent().next().animate({

                height: "0px",

            })
            $(this).parent().parent().parent().css("borderRadius", "8px")
            $(this).parent().parent().parent().css("borderBottom", "0");
        }

    })
    $(".musicOrVideo .otherbottomFunction").css("height", $(".musicOrVideo").height() - $(".showRate").height() - parseFloat($(".showRate").css("marginTop")));
    $("#functionButton").css("width", $("#bottom").width() - $(".controlBottomBtn").width() - parseFloat($(".controlBottomBtn").css("marginRight")));
    $(".bottomPPTFunctionBtn").css("width", $("#functionButton").width() - $(".ppt img").eq(0).width() - parseFloat($(".ppt img").eq(0).css("marginLeft")) - $(".ppt .fileName").width() - parseFloat($(".fileName").css("marginLeft")) - $(".ppt .image").width() * 2 - $("#startPPT").width() - parseFloat($(".bottomPPTFunctionBtn").css("marginLeft")) - parseFloat($(".bottomPPTFunctionBtn").css("marginRight")) - 30 - 2);
    if ($("#top .topRight .rightTitle").height() != 0) {
        $(".otherbottomFunction").css("width", $(".bottomPPTFunctionBtn").width());
        $(".otherbottomFunction").css("width", $("#functionButton").width() - $(".musicOrVideo img").eq(0).width() - parseFloat($(".musicOrVideo img").eq(0).css("marginLeft")) - $(".musicOrVideo .fileName1").width() - parseFloat($(".fileName1").css("marginLeft")) - $(".musicOrVideo .image").width() * 2 - $(".startmusic").width() - parseFloat($(".otherbottomFunction").css("marginLeft")) - parseFloat($(".otherbottomFunction").css("marginRight")) - 30 - 4 - 40);
    } else {
        $(".otherbottomFunction").css("width", "75px");
    }
  


    liSpanH = $(".controlBottomTab li span").height();
    bH = $(".controlBottomTab li b").height();
}
//拼接ppt控制按钮的字符串
function pptStr(hrefDownLoad1, href1, imageMargin1) {
    return '<li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><b class="downLoad" style="margin-top:' + imageMargin1 + 'px;"></b><span>' + getLanguageMsg("下载", $.cookie("yuyan")) + '</span></a></li><li><a id="checkFile" onclick="checkFile()"  class="downFile" href1="' + href1 + '"><b class="checkIn" onclick="checkFile()" style="margin-top:' + imageMargin1 + 'px;"></b><span>' + getLanguageMsg("预览", $.cookie("yuyan")) + '</span></a></li>';


}
//拼接音视频控制按钮的字符串
function videoStr(hrefDownLoad1, href1, imageMargin1) {
    return '<li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><b class="downLoad" style="margin-top:' + imageMargin1 + 'px;"></b><span>' + getLanguageMsg("下载", $.cookie("yuyan")) + '</span></a></li><li><a id="checkFile" onclick="checkFile()" class="downFile" href1="' + href1 + '" ><b class="checkIn"  style="margin-top:' + imageMargin1 + 'px;"></b><span>' + getLanguageMsg("预览", $.cookie("yuyan")) + '</span></a></li>';
}
//拼接图片控制按钮的字符串
function picStr(hrefDownLoad1, href1, imageMargin1) {
    return '<li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><b class="downLoad" style="margin-top:' + imageMargin1 + 'px;"></b><span>' + getLanguageMsg("下载", $.cookie("yuyan")) + '</span></a></li><li><a id="checkFile" onclick="checkImageFile(this)" class="downFile" href1="' + href1 + '" ><b class="checkIn" style="margin-top:' + imageMargin1 + 'px;"></b><span>' + getLanguageMsg("预览", $.cookie("yuyan")) + '</span></a></li>';

}
function clickProList(thisname) {
    $(".left").css("background", "#33325a");
    $(thisname).parent().parent().css({
        "background": "-webkit-linear-gradient(left, #856dff,#3396fb)",

    })
    $(thisname).parent().parent().css({
        "background": "-ms-linear-gradient(left, #856dff, #3396fb)",

    })
    if ($(thisname).parent()[0].outerHTML.indexOf("bgSpan") >= 0) {
        $(thisname).next().addClass("current");
        $(thisname).next().siblings().find(".leftList").removeClass("current");
    } else {
        $(thisname).parent().addClass("current");
        $(thisname).parents().siblings().find(".leftList").removeClass("current");
    }


    var url = $("#top").attr("src");
    //对当前的节目点击下载按钮
    var downLink = $(".current").attr("downLink");
    //如果节目是存储在本地，需要在连接前添加$$符号
    //以下是用"\\"进行本地文件和线上文件的区分
    if (downLink.indexOf("\\") < 0) {
    } else {
        downLink = "$$" + downLink;
    }
    //将文件的地址转换成线上能运行的地址，同时在地址前增加当前获取数据的显示端地址，来得到一个新的地址。
    href = url + "/" + downLink;//预览
    var arry = href.split("\\");
    downLoadArry = arry[arry.length - 1];//此时声明成全局变量是为了接下来在拼接字符串的时候用到这个值，预览的变量同此变量
    //在文件名前加onlydownload,系统就会自动识别为当前的文件为下载文件。
    downLoadArry = "onlydownload_\\" + downLoadArry;
    arry[arry.length - 1] = downLoadArry;
    hrefDownLoad = arry.join('\\');
    //预览当前文件只需要在预览的按钮添加一个href,href的值为上面所提到的新的组合的地址。
    $("#checkFile").attr("href1", href);
    $("#downLoad").attr("href", hrefDownLoad);
    //$(".start").attr("src", "images/bottomPlay/tingzhi.png");
}
//声明函数根据后台返回的数据判断当前应显示的状态图标
function showStatus(menuStatus, number) {
    var menuStatus = parseInt(menuStatus);
    $(".topLeft .clientList ul li b").css("background", "url(../images/computerB.png) no-repeat");
    $(".topLeft .clientList ul li b").css("backgroundSize", "100%");
    $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("background", "url(../images/tubiao.png) no-repeat");
    if (menuStatus == 0) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-1px -409px");
    } else if (menuStatus == 1) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-50px -409px");
    } else if (menuStatus == 2) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-101px -409px");
    } else if (menuStatus == 3) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-152px -409px");
    } else if (menuStatus == 4) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-203px -409px");
    } else if (menuStatus == 5) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-254px -409px");
    } else if (menuStatus == 6) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-1px -445px");
    } else if (menuStatus == 7) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-52px -449px");
    } else if (menuStatus == 8) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-101px -447px");
    } else if (menuStatus == 9) {
        $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-152px -447px");
    }
}
//页面加载时获取手动模式还是自动模式
function changeMenuState(menuState) {
    if (menuState == 2) {
        $(".autoPlay").css("background", "#F06060");
        $(".handPlay").css("background", "#26254d");
    } else if (menuState == 1) {
        $(".handPlay").css("background", "#F06060");
        $(".autoPlay").css("background", "#26254d");
    } else {
        $(".handPlay").css("background", "#26254d");
        $(".autoPlay").css("background", "#26254d");
    }
}
//在本机当前图片缩略图的情况下，显示系统默认的缩略图
function changeImage(thisIamge) {
    $(thisIamge).attr("src", "images/typeb3.png");
}
//点击立即启动按钮
function startNow(taskId) {
    if ($(".allScreenBtn img").attr("src").indexOf("Selected") >= 0) {
        docmd(67, taskId);
    } else {
        docmd(16, taskId);
    }
}
//音视频暂停/启动图片切换
function changPlayStatus(playStatus1) {
    if (playStatus1 == "2") {
        $(".startmusic").attr("src", "images/dibubofang/pause.png");
    } else {
        $(".startmusic").attr("src", "images/dibubofang/bofang.png");
    }
}
//发送指令函数
function docmd(cmdtype, cmdData) {
    var url = $("#top").attr("src");
    var cmdType = "" + cmdtype + "";
    var sendcmdurl = url + "/wpsendclientmsg.asp?rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
    if (!isNaN(cmdtype)) {//执行显示端命令
        cmdstr = cmdtype + "_" + cmdData;
        $.ajax({
            data: { wpsendclientmsg: cmdstr },
            url: sendcmdurl,
            dataType: 'html',
            type: 'GET',
            timeout: 15000,		//超时时间
            error: function (a, b, c) {
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                } else {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                }
            },
            success: function (xml) {
                if (xml) {
                    //timeShowMsg("title","发送成功",500);		//发送成功
                    if (xml.indexOf("501") >= 0) {
                        topTrip("平板操控功能未授权")
                    } else {
                        if (cmdType.indexOf("3009") < 0 && cmdType.indexOf("29") < 0 && cmdType.indexOf("3001") < 0) {
                            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                        }
                    }

                }
            }
        });
    }
    if (cmdtype == "keycode") {//发送键盘动作
        if (cmdData.indexOf("-keyevent") >= 0) {
            ;
        } else {

            cmdData = "-keyevent " + cmdData;
        }
        $.ajax({
            data: { wpsendkeys: cmdData },
            url: sendcmdurl,
            dataType: 'html',
            type: 'GET',
            timeout: 5000,		//超时时间
            error: function (a, b, c) {
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                } else {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                }
            },
            success: function (xml) {
                if (xml) {
                    if (xml.indexOf("501") >= 0) {
                        topTrip("平板操控功能未授权")
                    } else {
                        //timeShowMsg("title","发送成功",500);		//发送成功
                        topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                    }


                }
            }
        });
    }
    //点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
    if (cmdtype == 13) {
        var ele = $(".current").parent().next().next().next();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.prev().find(".leftList").removeClass('current');
    }
    if (cmdtype == 12) {
        $(".leftList").removeClass('current');
        $(".leftList").eq(0).addClass("current").find("img").click();
    }
    if (cmdtype == 11) {
    }
    if (cmdtype == 69) {
    }
    if (cmdtype == 15) {
        $(".leftList").removeClass('current');
        $(".leftList").eq($(".leftList").length - 1).addClass("current").find("img").click();
    }
    if (cmdtype == 14) {
        var ele = $(".current").parent().prev().prev().prev();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.next().find(".leftList").removeClass('current');
    } if (cmdType.indexOf("3009") >= 0) {

        timer = setInterval("getRate(newurl)", 1000);
    }
    if (cmdtype == 70) {
        clearInterval(timer);
    }
    if (cmdtype == 16) {
    }
    if (cmdtype == "before") {
        var ele = $(".current").parent().prev().prev().prev();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.next().find(".leftList").removeClass('current');
    }
    if (cmdtype == "next") {
        var ele = $(".current").parent().next().next().next();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.prev().find(".leftList").removeClass('current');
    }

}
//发送指令函数 只要是针对全屏播放时
function docmd1(cmdtype, cmdData) {
    var screenType = cmdData;
    if ($(".allScreenBtn").attr("allscreen") == "open") {
        screenType = 3;
    } else {
        screenType = 0;
    }
    var url = $("#top").attr("src");
    var cmdType = "" + cmdtype + "";
    var sendcmdurl = url + "/wpsendclientmsg.asp?rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
    if (!isNaN(cmdtype)) {//执行显示端命令
        cmdstr = cmdtype + "_" + screenType;
        $.ajax({
            data: { wpsendclientmsg: cmdstr },
            url: sendcmdurl,
            dataType: 'html',
            type: 'GET',
            timeout: 15000,		//超时时间
            error: function (a, b, c) {
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                } else {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                }
            },
            success: function (xml) {
                if (xml) {
                    //timeShowMsg("title","发送成功",500);		//发送成功
                    if (xml.indexOf("501") >= 0) {
                        topTrip("平板操控功能未授权")
                    } else {
                        if (cmdType.indexOf("3009") < 0 && cmdType.indexOf("29") < 0 && cmdType.indexOf("3001") < 0) {

                            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                        }
                    }

                }
            }
        });
    }
    if (cmdtype == "keycode") {//发送键盘动作
        if (cmdData.indexOf("-keyevent") >= 0) {
            ;
        } else {

            cmdData = "-keyevent " + cmdData;
        }
        $.ajax({
            data: { wpsendkeys: cmdData },
            url: sendcmdurl,
            dataType: 'html',
            type: 'GET',
            timeout: 5000,		//超时时间
            error: function (a, b, c) {
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                } else {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                }
            },
            success: function (xml) {
                if (xml) {
                    if (xml.indexOf("501") >= 0) {
                        topTrip("平板操控功能未授权")
                    } else {
                        //timeShowMsg("title","发送成功",500);		//发送成功
                        topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                    }


                }
            }
        });
    }
    //点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
    if (cmdtype == 13) {
        var ele = $(".current").parent().next().next().next();
        ele.find(".leftList").addClass("current").find(".programListSpan").click();
        ele.prev().find(".leftList").removeClass('current');
    }
    if (cmdtype == 12) {
        $(".leftList").removeClass('current');
        $(".leftList").eq(0).addClass("current").find("img").click();
    }
    if (cmdtype == 15) {
        $(".leftList").removeClass('current');
        $(".leftList").eq($(".leftList").length - 1).addClass("current").find("img").click();
    }
    if (cmdtype == 14) {
        var ele = $(".current").parent().prev().prev().prev();
        ele.find(".leftList").addClass("current").find(".programListSpan").click();
        ele.next().find(".leftList").removeClass('current');
    } if (cmdType.indexOf("3009") >= 0) {

        timer = setInterval("getRate(newurl)", 1000);
    }
    if (cmdtype == 70) {
        clearInterval(timer);
    }
    if (cmdtype == 16) {
    }
    if (cmdtype == "before") {
        var ele = $(".current").parent().prev().prev().prev();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.next().find(".leftList").removeClass('current');
    }
    if (cmdtype == "next") {
        var ele = $(".current").parent().next().next().next();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.prev().find(".leftList").removeClass('current');
    }

}
//提示框函数
function topTrip(title, status) {
    $(".topTrip").show();
    setTimeout('$(".topTrip").hide()', 1000);
    $(".topTripContent").css("marginTop", ($(".topTrip").height() - $(".topTripContent").height()) / 2);
    if (status == 1) {
        $(".sendMessageImage").attr("src", "images/allTitle/sendMessage.png");

    } else if (status == 2) {
        $(".sendMessageImage").attr("src", "images/allTitle/sendFail.png");
    }
    $(".topTrip").css("marginLeft", ($("#top").width() - $(".topTrip").width()) / 2);
    $(".sendMessageStatus").html(title);
    $(".sendMessageImage").css("marginTop", ($(".topTripContent").height() - $(".sendMessageImage").height() - $(".sendMessageStatus").height()) / 2);
    $(".sendMessageImage").css("marginLeft", ($(".topTripContent").width() - $(".sendMessageImage").height()) / 2);
    $(".sendMessageStatus").css("lineHeight", $(".sendMessageStatus").height() + "px");
}
//毫秒转化成分钟
function secondToMinute(num) {
    var num1 = 0;
    var num2 = 0
    num = num / 1000;
    if (num >= 60) {
        num1 = parseInt(num / 60);
        num2 = parseInt(num % 60);

    } else {
        num2 = parseInt(num % 60);
    }
    num = fillTime(num1) + ":" + fillTime(num2);
    return num;
}
//时间格式填充
function fillTime(num) {
    if (num < 10) {
        num = "0" + num;
    } else {
        num = num;
    }
    return num;
}
//拖动滑动条获取到相应的值
function change(idnname, spanid) {
    //alert($("#" + idnname).val());
    var value = document.getElementById(idnname).value;
    // alert(value);
    var nw = parseInt($("#top").attr("nowwindow"));
    document.getElementById(spanid).innerHTML = value;

    if (idnname == "range") {
        docmd(nw * 10000 + 29, getSoundNumSlip(document.getElementById(idnname).value));
    } else if (idnname == "range2") {
        docmd(nw * 10000 + 3001, getSoundNumSlip(document.getElementById(idnname).value));
    }

}
//淡入淡出
function getSoundNumSlip(num) {
    num = parseFloat(num);
    tempnum = num;
    if (tempnum <= 0) { tempnum = 0; }
    if (tempnum >= 255) { tempnum = 255; }
    return tempnum;
}
//拖动进度条改变进度
function changeNowRate() {
    //拖动进度条
    var rangeRate1 = document.getElementById("rangeRate1");
    var rangeRate2 = document.getElementById("rangeRate2");
    var changeFlage = 0;

    var nowSecond = 0;

    rangeRate2.addEventListener('touchstart', function (event) {
        changeFlage = 1;

        clearInterval(timer);
    })
    rangeRate2.addEventListener('touchmove', function (event) {
        changeFlage = 1;

        var styles = window.getComputedStyle(rangeRate1, null);
        var width = styles.width;//灰色块的长度，用于计算红色块最大滑动的距离
        //leftWidth为当前灰色块距离屏幕最左侧的距离

        var leftWidth = parseFloat($(".musicOrVideo img").eq(0).css("width")) + parseFloat($(".musicOrVideo img").eq(0).css("marginLeft")) + $("#rateProgressValue").width() + parseFloat($("#rateProgressValue").css("marginLeft")) + parseFloat($("#rangeRate2").css("width"));
        if (event.targetTouches.length == 1) {
            var touch = event.targetTouches[0];
            //计算红色块的left值，pageX是相对于整个页面的坐标，减去10（红色块长度的一半）是为了让鼠标点显示在中间，
            //可以更改值看看效果，如果灰色块不是紧挨着屏幕，那还需要计算灰色块距离左屏幕的距离，应为pageX！！！                
            moveleft = touch.pageX - leftWidth - 10;
            if (moveleft <= 0) {//红色块的left值最小是0；                    
                moveleft = 0;
            };
            if (moveleft >= parseFloat(width) - 20) {////红色块的left值最小是灰色块的width减去红色块的width；                    
                moveleft = parseFloat(width) - 20;
            }
            var reteWidth = parseFloat($("#rangeRate1").css("width")) - parseInt($("#rangeRate2").css("width"));
            var strsMax = parseFloat($("#rangeRate1").attr("max"));
            var nw = parseInt($("#top").attr("nowwindow"));
            rangeRate2.style.left = moveleft + "px";//最后把left值附
            nowSecond = moveleft * strsMax / reteWidth;
            $("#rangeLeft").css("width", moveleft);
            $("#rateProgressValue").html(secondToMinute(nowSecond));
            console.log($("#rangeRate2").css("left"));
        };
    });
    rangeRate2.addEventListener('touchend', function (event) {
        var reteWidth = parseFloat($("#rangeRate1").css("width")) - parseInt($("#rangeRate2").css("width"));
        var strsMax = parseFloat($("#rangeRate1").attr("max"));
        var nw = parseInt($("#top").attr("nowwindow"));
        nowSecond = moveleft * strsMax / reteWidth;
        timeFlag = 2;
        docmd(nw * 10000 + 3009, parseInt(nowSecond));
        changeFlage = 0;
    })
}
//文件预览
function checkFile() {
    var fileSrc = $("#checkFile").attr("href1");
    $("#checkFile").attr("href1", fileSrc);
    window.open(fileSrc, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400, height=400");
}
function changeTab(id) { //切换Tab内容
    $(".bar").hide();
    $("#" + id).show();
}
//对系统的应用功能按钮发送指令
function getUrl(url) {
    url = $("#top").attr("src") + "/" + url + "&utf8=1";
    $.ajax({
        data: { rnd: (Math.floor(Math.random() * (9999 - 1000)) + 1000) },
        url: url,
        dataType: 'html',
        type: 'GET',
        timeout: 15000,		//超时时间
        error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        },
        success: function (xml) {
            if (xml) {
                if (xml.indexOf("501") >= 0) {
                    topTrip("平板操控功能未授权")
                } else {
                    //timeShowMsg("title","发送成功",500);		//发送成功
                    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                }

            }
        }
    });
}
//控制灯颜色
function lightChange(url, obj) {
    var url1 = newurl + "/wpcontrolcomm.asp?wpcontrolcomm=";
    $.get(url1 + url);
}
//开机 开机时发送两次指令 保证指令有效
function powerOn() {
    var clintName = $("#top").attr("clientname");
    var ClientName = clintName;
    var errorip = $("#top").attr("src");
    var errorIp = errorip.split("//");
    errorIp = errorIp[1].split(":");
    errorIp = errorIp[0];
    var errorMac = $("#top").attr("macname");
    var errorStr = "-f " + errorIp + ":" + errorMac + ";";
    $.ajax({
        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + ClientName + ";&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'text',
        type: 'GET',
        success: function (data) {
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".topConfirm").attr("messageTip", "");
        },
        error: function (data) {

            $.ajax({
                url: "wpcontrolcenter.asp?wpcontrolcenter=Turn-On TV&maintype=6&subtype=0&companyid=wisepeak&utf8=1&dohere=1&cnlist=noneed&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
                dataType: 'text',
                type: 'GET',
                success: function (data) {
                    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                    $(".topConfirm").attr("messageTip", "");
                },
                error: function (data, XMLHttpRequest, textStatus, errorThrown) {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 1);
                    $(".topConfirm").attr("messageTip", "");
                }
            })
        }
    })
}
//关机 从终端不能关闭时，就向控制室发指令
function powerOff(clientNum) {
    if ($(".topConfirm").attr("messageTip") == "ok") {
        var clintName = $("#top").attr("clientname");
        var errorURL = $("#top").attr("src");
        $.ajax({
            url: errorURL + "/wpsendclientmsg.asp?wpsendclientmsg=" + clientNum + "_" + (1000 + parseInt(clientNum)) + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'xml',
            type: 'GET',
            success: function (data) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
            error: function (data) {
                topTrip(getLanguageMsg("发送失败功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            }
        })

        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + clintName + ";&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'text',
            type: 'GET',
            success: function (data) {
                //timeShowMsg("title","发送成功",500);
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
            error: function (data) {
            }
        })
    } else {
        if (clientNum == 1) {
            tipMessage(getLanguageMsg("确定要重启吗?", $.cookie("yuyan")), "powerOff", clientNum);
        } else {
            tipMessage(getLanguageMsg("确定要关机吗?", $.cookie("yuyan")), "powerOff", clientNum);
        }
    }
}
//全开
function openAll() {
    var str = '';
    var ipstr = "";
    for (var i = 0; i < $("#clientList .screenList").length; i++) {
        var ttstrarr;
        var ttstr = "";
        var ttmac = "";
        str += $(".screenList").eq(i).attr("clientname") + ";"
        ttstrarr = $(".screenList").eq(i).attr("src").split("://");
        if (ttstrarr.length > 1) {
            ttstr = ttstrarr[1];
            ttstrarr = ttstr.split(":");
            if (ttstrarr.length > 1) {
                ttstr = ttstrarr[0];
            }
        }
        ttmac = $(".screenList").eq(i).attr("macname");
        ipstr += (ttstr + ":" + ttmac) + ";";
    }

    $.ajax({
        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + str + "&commandparam=-f " + ipstr + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        data: "text",
        dataType: 'text',
        type: 'GET',
        success: function (data) {
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".topConfirm").attr("messageTip", "");
        },
        error: function (data) {
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            $(".topConfirm").attr("messageTip", "");
        }
    })
}
//全关 全关时直接向控制室发指令
function closeAll() {
    var str1 = '';
    for (var i = 0; i < $("#clientList .screenList").length; i++) {
        str1 += $(".screenList").eq(i).attr("clientname") + ";"
    }
    //var truthBeTold = window.confirm("确定要关机吗?");
    //if (truthBeTold) {
    if ($(".topConfirm").attr("messageTip") == "ok") {
        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + str1 + "&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'text',
            type: 'GET',
            success: function (data) {
                //timeShowMsg("title","发送成功",500);
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
            error: function (data) {
                //timeShowMsg("title","发送失败",500);
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
    } else {
        tipMessage(getLanguageMsg("确定要全关吗?", $.cookie("yuyan")), "closeAll");
    }
}


//当放大倍数改变时应执行的操作
function getNowSize(thisInput, num) {

    if (num != undefined) {
        drawResizeImage(parseInt($(thisInput).val()) * (0.05), num);
        $("#nowPictureSize").html($(thisInput).val());
    } else {
        drawResizeImage(parseInt($(thisInput).val()) * (0.05));
        $("#nowSize").html($(thisInput).val());
    }

}
//调节缩放后的大小
function drawResizeImage(size, numSize) {
    canvaswindowWidth = document.documentElement.clientWidth * (1 + size);
    if (numSize != undefined) {
        $(".loadpng" + numSize).css("width", canvaswindowWidth + "px");
        $(".loadpng" + numSize).css("height", (canvaswindowWidth / whRate) + "px");
        resizeCanvasSize1(canvaswindowWidth, size);
    } else {
        $(".loadpng").css("width", canvaswindowWidth + "px");
        $(".loadpng").css("height", (canvaswindowWidth / whRate) + "px");
        resizeCanvasSize(canvaswindowWidth, size);
    }


}



//拍照
function takePhoto() {
    var photourl = $("#top").attr("src");
    photourl = photourl + "/wpsendclientmsg.asp?wpsendclientmsg=3049_1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
    $.ajax({
        url: photourl,
        dataType: 'text',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            if (xml.indexOf("501") >= 0) {
                topTrip("平板操控功能未授权")
            } else {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            }
        },
        error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
}

//获取终端频道信息函数
function getChannelList() {
    var channelListUrl = $("#top").attr("src");
    var url = channelListUrl + "/wpgetxmlids.asp?utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
    $.ajax({
        data: { gettype: "channel" },
        url: url,
        dataType: 'xml',
        type: 'GET',		//提交方式
        timeout: 15000,		//失败时间
        error: function (xml) {
            $("#title").text(getLanguageMsg("获取频道出错!", $.cookie("yuyan")));
            $("#pic").html("<img src='images/fail1.png' style=\"position:relative;left:0px;\"/>")//top:15px;
            $("#pic img").css("top", ($("#pic").parent().height() - 38) / 2);
        },
        success: function (xml) {
            //下拉列表的第一项为当前正在播放的节目单，剩下的节目单按照正常的顺序显示
            $("#pic").html("<img src='images/success1.png' style=\"position:relative;left:0px;\"/>")//top:15px;
            $("#pic img").css("top", ($("#pic").parent().height() - 38) / 2);
            var channels = $(xml).find("channel");
            var raius = "10px 10px 0px 0px";
            $("#channelList").html("");
            $("#ulChannelList").html("");
            channels.each(function (index, element) {
                var name, path, desc;
                name = $(this).find("name").text();
                path = $(this).find("path").text();
                desc = $(this).find("desc").text();

                if ($("#menuPath").val() == path) {
                    $("#channelList").append("<option value='" + name + "' selected>" + name + "</option>");
                    $("#ulChannelList").append("<li onclick='changinputvalue(this)'>" + name + "</li>");
                } else {
                    $("#channelList").append("<option value='" + name + "'>" + name + "</option>");
                    $("#ulChannelList").append("<li onclick='changinputvalue(this)'>" + name + "</li>");
                }
                $("#changeChannel").css("borderRadius", "10px");
                if (count % 2 == 0) {
                    $("#changeChannel").css("borderRadius", "10px");
                } else {
                    $("#changeChannel").css("borderRadius", raius);
                    $("#channelBar").css("borderRadius", "0px 0px 10px 10px");
                }
            });
            $("#inpurChannelValue").val($("#channelList").val());
        }
    });
}
//点击选择频道的li给input赋值
function changinputvalue(thisList) {
    $("#inpurChannelValue").val($(thisList).html());
    $("#ulChannelList").hide();
}
//一键切换所有终端频道 因为每个显示端都由一个配置文件连接到主控端，wiseSendInfo会自动连接到主控端，所以此时可以用相对路径
function allClientChannel() {
    var valueName = $("#inpurChannelValue").val();
    valueName = valueName.split("[");
    valueName = "*[" + valueName[1] + "11";
    var str = '';
    var indexNumber = $("#top").attr("indexnumber");
    for (var i = 0; i < $(".screenList").length; i++) {

        str += $(".screenList").eq(i).attr("clientname") + ";"
    }
    $.ajax({
        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=73&companyid=wisepeak&utf8=1&cnlist=" + str + "&commandparam=" + valueName + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: "text",
        type: "GET",
        timeout: "3000",
        success: function (data) {
            if (data) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                getData(newurl, indexNumber);
            }
        }, error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
    $(".channelChange").hide();
}
function allClientChannelHand() {
    var valueName = $("#inpurChannelValue").val();
    valueName = valueName.split("[");
    valueName = "*[" + valueName[1] + "69";
    var str = '';
    var indexNumber = $("#top").attr("indexnumber");
    for (var i = 0; i < $(".screenList").length; i++) {

        str += $(".screenList").eq(i).attr("clientname") + ";"
    }
    $.ajax({
        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=73&companyid=wisepeak&utf8=1&cnlist=" + str + "&commandparam=" + valueName + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: "text",
        type: "GET",
        timeout: "3000",
        success: function (data) {
            if (data) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                getData(newurl, indexNumber);
            }
        }, error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
    $(".channelChange").hide();
}
//切换语言
function switchLanguage(index, pagename) {
    var url = "js/language.json";//多语言数据路径
    $.ajax({
        url: url,
        type: "get",
        dataType: "text",
        timeout: "5000",
        success: function (data) {
            var data = eval("(" + data + ")");
            for (var i = 0; i < data[index].content[pagename].length; i++) {
                var json = data[index].content[pagename][i];
                var obj = $(".language:eq(" + i + ")");
                if (obj.prop("tagName") == "INPUT" || obj.prop("tagName") == "TEXTAREA") {
                    if (obj.attr("type") == "button" || obj.attr("type") == "submit") {
                        obj.val(json.word);
                    } else {
                        obj.attr("placeholder", json.word);
                    }

                } else {
                    obj.html(json.word);
                }
            }

            $(".bar .cmdBar li img").css("marginTop", ($(".bar .cmdBar li").height() - $(".bar .cmdBar li img").height()) / 2);
        }, error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }

    })
}
//将获取的数据直接保存在页面中，防止多次请求数据
function getJsonValue() {
    var url = "js/language.json";//多语言数据路径
    var returnMsg = "";
    $.ajax({
        url: url,
        type: "get",
        dataType: "text",
        async: false,
        setTimeout: "3000",
        success: function (data) {
            $("#top").attr("jsonValue", data);
        }, error: function (a, b, c) {
            console.log(a, b, c);
            returnMsg = a;
        }
    })
    return returnMsg;
}
//对js的数据进行翻译
function getLanguageMsg(a, c) {

    //var url = "/js/language.json";//多语言数据路径
    var returnMsg = "";
    var h = 0;
    if (c == null || c == "") {
        c = "CH";
    }
    if ($("#top").attr("jsonValue") != undefined) {
        var data = $.parseJSON($("#top").attr("jsonValue"));
        for (var i = 0; i < data[0].msg.length; i++) {

            if (data[0].msg[i].message == a) {
                for (var j = 0; j < data.length; j++) {
                    if (c != null && c != undefined & c != "") {
                        if (data[j].language == c.toUpperCase() && h == 0) {
                            h++;
                            returnMsg = data[j].msg[i].message;
                            // break;
                        }
                    }

                }
            }
        }

    } else {
        var url = "js/language.json";//多语言数据路径
        $.ajax({
            url: url,
            type: "get",
            dataType: "text",
            async: false,
            success: function (data) {
                var data = eval("(" + data + ")");
                for (var i = 0; i < data[0].msg.length; i++) {

                    if (data[0].msg[i].message == a) {
                        for (var j = 0; j < data.length; j++) {
                            if (c != null && c != undefined & c != "") {
                                if (data[j].language == c.toUpperCase() && h == 0) {
                                    h++;
                                    returnMsg = data[j].msg[i].message;
                                    // break;
                                }
                            }

                        }
                    }
                }
            }

        })
    }
    return returnMsg;
}
//显示当前终端当前布局下的所有窗口
function showNowPlayScreen() {
    $.ajax({
        url: newurl + "/wpgetxmlids.asp?gettype=2",
        type: "get",
        dataType: "xml",
        timeout: "3000",
        success: function (data) {
            var strs = "";
            var winLen = $(data).find("window").length;
            if (winLen >= 0) {
                for (var i = 0; i < winLen; i++) {
                    strs += "<li onclick='playScreenShadowContent(this)'>" + $(data).find("window").eq(i).find("name").html() + "</li>";
                }
                $(".playScreenShadowContent ul").html(strs);
            }

        }, error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
}
//显示选择窗口页面
function playScreenProgram() {
    $(".playScreenShadow").show();
}
function playScreenShadowContent(thisContentWindow) {
    var playWindow = $(thisContentWindow).text();
    var playWinTask = $(".current").attr("taskid");
    playScreenContent(playWindow, playWinTask);
}
//播放节目单里的内容到指定窗口
function playScreenContent(win, id) {
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=80_-starttemptask%20<id>" + id + "</id><tmpid>" + (91000 + parseInt(id)) + "</tmpid><dur>10800</dur><win>" + win + "</win>&utf8=1",
        type: "get",
        dataType: "text",
        timeout: "3000",
        success: function (data) {
            if (data.indexOf("501") >= 0) {
                topTrip("平板操控功能未授权")
            } else {
                //timeShowMsg("title","发送成功",500);		//发送成功
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            }
            // topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".playScreenShadow").hide();
        }, error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
}

function refreshColumn(thisNum) {
    var winNum = (parseInt(($(".current").find("。infoProgram").html().split("\/")[2]).split("-")[0]) + 1).toString(16);
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=" + thisNum + "_0x" + winNum + "000000",
        type: "get",
        dataType: "xml",
        timeout: "3000",
        success: function (data) {
            if (data.indexOf("501") >= 0) {
                topTrip("平板操控功能未授权")
            } else {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            }
        },
        error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
}
//链接到资源文件获取页面
function SourceGet() {
    if (newurl == "") {
        window.location.href = window.location.href.split("/")[0] + "//" + window.location.href.split("/")[1] + window.location.href.split("/")[2] + "/source.html";
    } else {
        window.location.href = newurl + "/source.html";
    }
}
//开关机提示信息
function tipMessage(message, functionName, messageNum) {
    $(".confirmDiv").css("display", "block");
    $(".confirmDiv").css("marginTop", (document.documentElement.clientHeight - $(".confirmDiv").height()) / 2);
    $(".tipOk").css("marginLeft", ($(".tipContent1").width() - $(".tipOk").width() * 2 - 20) / 2);
    $(".tipContent").html(message);
    $(".tipContent").css("lineHeight", $(".tipContent").height() + "px");

    $(".tipContent").attr("fName", functionName);
    $(".tipContent").attr("messageNum", messageNum);
}
//当屏幕分辨率改变时，自动刷新页面，防止页面混乱
function refreshScreen() {
    var nowWidth = document.documentElement.clientWidth;
    if (Math.abs(nowWidth - screenWidth1) >= 10) {
        window.location.reload();
        screenWidth1 = nowWidth;
    }
}
//修改音视频暂停还是继续的状态
function changeMusicStatus() {
    clearInterval(timer);
    var tabWindow = $("#top").attr("nowWindow");
    if ($(".startmusic").attr("src") == "images/dibubofang/bofang.png") {
        clearInterval(timer);
        docmdex(3002, tabWindow);
        $(".startmusic").attr("src", "images/dibubofang/pause.png");

    } else {
        timer = setInterval("getRate(newurl)", 1000);
        docmdex(3003, tabWindow);
        $(".startmusic").attr("src", "images/dibubofang/bofang.png");
    }
}
//此处根据设备的内核判断是手机端或者pc或者pad，然后跳转到相应的链接中
function browserRedirect() {
    var sUserAgent = navigator.userAgent.toLowerCase();
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
    var bIsAndroid = sUserAgent.match(/android/i) == "android";
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
    if (bIsIphoneOs || bIsWM || bIsAndroid || bIsWM) {
       //window.location.href = window.location.href.split("/")[0] + "newmctrl.html";
    } else {
        //window.location.href=window.location.href.split("/")[0]+"pctrl.html";
    }
}

//滑动实现甩屏播放功能
function dragScreen(thisItem) {
    var oDiv = "";
    var dragScreenx = 0;
    var dragScreeny = 0;
    var oldMoveX = 0;
    var oldMoveY = 0;
    var leftListDragW = 0;
    var leftListDragH = 0;
    var thisHeight = 0;
    var oldStyle = $(".current").parent().attr("style");
    var oldMarginLeft = 0;//声明一个全局变量用来存储偏移量，来保证抬起手指时当前模块还能回到原来的位置
    //此处用let声明变量，使i的作用域在for循环中，从而使for循环中的每一个列表都可以被注册事件
    for (let i = 0; i < document.getElementById("scroll").getElementsByClassName("left").length; i++) {
        // if (i % 2 == 0) {
        document.getElementsByClassName("leftList")[i].getElementsByClassName("programListSpan")[0].ontouchstart = function (evt) {
            console.log($(this).find("span"));
            var oDiv = this;
            thisHeight = $(oDiv).parent().parent().height();

            dragScreenx = 0;
            dragScreeny = 0;
            oldMoveX = $(oDiv).parent().parent().offset().left;
            oldMoveY = $(oDiv).parent().parent().offset().top;
            leftListDragW = $(oDiv).parent().parent().width();
            leftListDragH = thisHeight;

            $(".dragShadow").show();
            oDiv.parentNode.parentNode.nextSibling.nextSibling.style.display = "block";
            $(".left1").css("height", thisHeight);
            var boxRight = 0;
            oldMarginLeft = parseFloat($(oDiv).parent().parent().css("marginLeft"));
            var oldMarginTop = parseFloat($(oDiv).parent().parent().css("marginTop"));

            oDiv.parentNode.parentNode.style.position = "absolute";
            $(oDiv).parent().parent().css("marginLeft", "0");
            oDiv.parentNode.parentNode.style.background = "#fff";
            oDiv.parentNode.parentNode.style.zIndex = 1006;
            oDiv.parentNode.parentNode.style.left = oldMoveX + "px";
            boxRight = ($("#top").width() - oldMoveX - leftListDragW);
            oDiv.parentNode.parentNode.style.right = boxRight + "px";
            oDiv.parentNode.parentNode.style.top = (oldMoveY - oldMarginTop) + "px";
            oDiv.parentNode.parentNode.style.width = leftListDragW + "px";
            oDiv.parentNode.parentNode.style.height = leftListDragH + "px";

            var startedx = evt.touches[0].clientX;
            var startedy = evt.touches[0].clientY;
            dragScreenx = startedx;
            dragScreeny = startedy;
            oDiv.click();
        },
            document.getElementsByClassName("leftList")[i].getElementsByClassName("programListSpan")[0].ontouchmove = function (evt) {
                var oDiv = this;

                var deLeft = 0;
                var deTop = 0;

                var movex = evt.touches[0].clientX;
                var movey = evt.touches[0].clientY;

                if (movex > dragScreenx) {
                    deLeft = movex - dragScreenx;
                    oDiv.parentNode.parentNode.style.left = (parseFloat(oDiv.parentNode.parentNode.style.left) + deLeft) + "px";
                } else {
                    deLeft = dragScreenx - movex;
                    oDiv.parentNode.parentNode.style.left = (parseFloat(oDiv.parentNode.parentNode.style.left) - deLeft) + "px";

                }
                if (movey > dragScreeny) {
                    deTop = movey - dragScreeny;

                    oDiv.parentNode.parentNode.style.top = (parseFloat(oDiv.parentNode.parentNode.style.top) + deTop) + "px";

                } else {
                    deTop = dragScreeny - movey;

                    oDiv.parentNode.parentNode.style.top = (parseFloat(oDiv.parentNode.parentNode.style.top) - deTop) + "px";
                }
                if (parseFloat(oDiv.parentNode.parentNode.style.top) >= document.documentElement.clientHeight) {
                    //  alert(oDiv.parentNode.parentNode.style.top);
                }
                oDiv.parentNode.parentNode.style.right = document.documentElement.clientWidth - parseInt(oDiv.parentNode.parentNode.style.left) - leftListDragW;
                dragScreenx = movex;
                dragScreeny = movey;
            },
            document.getElementsByClassName("leftList")[i].getElementsByClassName("programListSpan")[0].ontouchend = function (evt) {
                var oDiv = this;

                var endx = evt.changedTouches[0].clientX;
                var endy = evt.changedTouches[0].clientY;
                //获取当前元素的taskid方便后面传值
                var thisDragId = oDiv.parentNode.getAttribute("taskid");
                var thisMarkId = oDiv.getAttribute("markID");
                var thisitemType = oDiv.getAttribute("itemType");
                if (parseInt(oDiv.parentNode.parentNode.style.top) <= 0) {//向上
                    //startNow(thisDragId);
                    playScreenContent("0-全屏窗口", thisDragId);
                } else if (parseInt(oDiv.parentNode.parentNode.style.left) <= 0) {
                    $("#upload_File").click();
                    showPrint("1")
                    console.log("打印");
                } else if (parseInt(oDiv.parentNode.parentNode.style.left) > document.documentElement.clientWidth - parseFloat(oDiv.parentNode.parentNode.style.width) + 20) {
                    $("#upload_File").click();
                    showPrint("0")
                    console.log("上传");
                } else if (parseInt(oDiv.parentNode.parentNode.style.top) > document.documentElement.clientHeight - parseFloat(oDiv.parentNode.parentNode.style.height) - 200) {

                    var href = document.getElementById("downLoad");
                    // alert(href);
                    //window.open(href);
                    window.location = href
                    console.log("下载")
                }
                $(".dragShadow").hide();
                oDiv.parentNode.parentNode.style.position = "";
                oDiv.parentNode.parentNode.nextSibling.nextSibling.style.display = "none";
                oDiv.parentNode.parentNode.style.left = 0;
                oDiv.parentNode.parentNode.style.right = 0;
                //oDiv.parentNode.parentNode.style.top = 0;
                oDiv.parentNode.parentNode.style.zIndex = 0
                oDiv.parentNode.parentNode.removeAttribute("style");
                $(oDiv).parent().parent().css("marginLeft", oldMarginLeft + "px");
                oDiv.parentNode.parentNode.style.background = "-webkit-linear-gradient(left, rgb(133, 109, 255), rgb(51, 150, 251))";
                oDiv.parentNode.parentNode.style.height = thisHeight + "px";
            }
    }
}
