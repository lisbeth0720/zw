var oldData='';//声明一个变量来存储上一次的数据
var oldURL="";//声明一个变量来存储上一个URL
var oldmenuState="";
var localUrl=window.location.href;
var screenWidth1=document.documentElement.clientWidth;//用于检测横竖屏变化
var timer=0;//轮询的变量
var freshTime=0;
var newurl='';//当前显示端的url
var count=0;
var content1='';
var contentStr=[];
var socket=null;//用于显示进度的socket
var socket1=null;//用于模拟鼠标在显示端操作的socket
var dragStartjt=false;//判断是否要进行拖拽的动作，截图
var dragStart=false;//判断是否要进行拖拽的动作,操控板只进行移动
var dragStart1=false;//判断是否要进行拖拽的动作，操控板状态位
var sendding=false;//用于标志当前指令发送是否成功
var historysendstr="";
var onemousemove=false;
var penFlag=0;//当为0时则认为是单指拖动，为1时则认为是单指画
var screenWidth = window.screen.width;//用来存储要控制终端的宽度
var screenHeight = window.screen.height;//用来存储要控制终端的高度
var windowWidth=window.screen.width;
//声明变量保存canvas的大小，此处使用clientWidth才能获取ios移动端的横竖屏的宽度
var canvaswindowWidth = document.documentElement.clientWidth;
var canvaswindowLeft=0;
var canvaswindowTop=0;
var canvasMarginLeft=0;

var changeFlag=0;//判断此时是否在进行拖动，若进行拖动动作则置为1,不进行数据获取的动作

var oldHref=window.location.href;

//声明全局变量保存最后一次move的操作  
var lastMoveX=0;
var lastMoveY=0;

var lastedMoveX=0;
var lastedMoveY=0;

var prev=0;
var canvasZoom=0;

var currentX=0;
var currentY=0;

var canvas=null;
var tempContext = null; // global variable 2d context  
var started = false;  
var mText_canvas = null;  
var x = 0, y =0;
var btnstate=0;
var targeturlhead="wpsendkeys.asp?wpsendkeys=-mouseevent ";
var targeturlrear="0_0_0";

var oldX=0;
var oldY=0;
var statusMouse=0;
var startTime=0;
var endTime=0;
var statusEnd=0;
var statusEnd1=0;


var volumStatus=0;

var loadpng=$(".loadpng").width();//存储loadpng的宽度
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
var isPrint = 0;//当值为0时则不打印，为1时则打印

browserRedirect();
//每一次点击获取相应的url，通过getData()来获取相应url下的数据

$(function(){
    getClientList("#top");
    getFaceDepart(); //获取人脸识别的部门
    var urlq,username,password,xmldata;
    urlq="wpgetxmlids.asp?utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	
    var pLH=$("#tabscreen p").height();
	
    var cmdImg=$(".sendCmd").width()*0.2;
    $(".sendCmd img").css("height",cmdImg);
    $(".smallbtn img").css("height",cmdImg);
    var cmdLi=$(".openOrClose").height();
    var marTopLi=(cmdLi-cmdImg)/2;
    $(".sendCmd img").css("marginTop",marTopLi);
    $(".smallbtn img").css("marginTop",marTopLi);	
    $("#tabscreen p").css("lineHeight", pLH + "px");
    $("#tabscreen p").css("lineHeight", pLH + "px");
    $("#freshPage img").css("lineHeight",pLH+"px");
    $("#freshPage img").css("marginTop",(parseInt($("#tabscreen p").css("height"))-20)/2);
    $("#freshPage").next().css("lineHeight",0 );
    $("#title").css("lineHeight", pLH + "px");
    $(".slider span").css("lineHeight", pLH + "px");
	
    $(".materialSound").click(function(){
        if($("#range2").css("display")=="block"){
            $("#range2").css("display","none");
            $("#value2").css("display","none");
        }else{
            $("#range2").css("display","block");
            $("#value2").css("display","block");
        }
    });
    $(".allSound").click(function(){
        if($(".systemSound").css("display")=="none"){
            $(".systemSound").css("display","block");
        }else{
            $(".systemSound").css("display","none");
        }
    });
    //静音
    $(".noSound").click(function(){
        if ($(this).attr("src") == "images/leftControl/noSound.png") {
            $(this).attr("src", "images/leftControl/quanjuyinliangSelected.png");
            docmd("3028", "20");

        } else {
            $(this).attr("src", "images/leftControl/noSound.png");
            docmd("3028", "10");
        }
    })
    //点击刷新状态的按钮进行刷新
    $("#freshPage img").click(function () {
        getData(newurl, clientIndex);//点击刷新按钮，即对列表进行刷新
    });
    //点击音量图标，音量条显示，点击初次之外的按钮，音量条隐藏
	//调节音量时，不管是全局音量还是局部音量，显示端必须启动才会生效
	$(document).on("click", function (e) {
		//以下两行程序的目的是，点击除了全局音量按钮和局部音量按钮 音量调隐藏
        var target = $(e.target);
		if (target.closest(".allSound").length != 0 || target.closest(".materialSound").length != 0) return;

        $(".systemSound").css("display","none");
        $("#range2").css("display","none");
        $("#value2").css("display","none");
    });
    //点击频道获取获取相应的频道
    $("#changeChannel").click(function(){
		$("#channelBar").slideToggle(600);
		if ($(".getchannelImg").attr("src") == "images/keysImg/channelUp.png") {
			$(".getchannelImg").attr("src", "images/keysImg/channelDown.png")
		} else {
			$(".getchannelImg").attr("src", "images/keysImg/channelUp.png")
		}
        count+=1;
        var channelUrl=$("#tabscreen").attr("src");
        url=channelUrl+"/wpgetxmlids.asp?rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
        getChannelList();
    });
    $("#inpurChannelValue").click(function () {
        if ($("#ulChannelList").css("display") == "none") {
            $("#ulChannelList").slideDown();
        } else {
            $("#ulChannelList").slideUp();
        }
       
    })
   
	//选中哪一个全局控制按钮即更换哪一个的内容和样式
	$(".controlImage img").click(function(){
		for(var i=0;i<$(".controlImage img").length;i++){
			var image=$(".controlImage img").eq(i).attr("src");
			if(image.indexOf("Selected")>0){
				var oldImgSrc=image.split("Selected");
				$(".controlImage img").eq(i).attr("src",oldImgSrc[0]+oldImgSrc[1]);
			}else{
				$(".controlImage img").eq(i).attr("src",image);
			}	
		}
		//点击全部控制的按钮来切换当前按钮的选中状态图标
		var index=$(".controlImage img").index(this)+1; 
		changeTab('bar'+index);
		var imgSrc=$(this).attr("src");
		
		var imgName=imgSrc.split(".");
		var newImageName=imgName[0]+"Selected";
		$(this).attr("src",newImageName+".png");	
	})
	
	//跳转节目单频道按钮
	$("#channelBtn").click(function(){
	    var value = $("#inpurChannelValue").val() + "11";//11表示切换后立即启动节目单播放，69表示进入手动模式
		value=encodeURI(value);
		value="utf-8"+value;
		docmd(73,"'"+ value+"'");
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshi.png");
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemuSelected.png");
		window.setTimeout("getData(newurl,clientIndex)", 1500);//触发加载数据事件
		window.setTimeout("getChannelList();",2500);//触发加载数据事件
		
	});
	//切换并暂停节目单频道按钮
	$("#channelBtnPause").click(function(){
	    var value = $("#inpurChannelValue").val() + "69";//11表示切换后立即启动节目单播放，69表示进入手动模式

		value=encodeURI(value);
		value="utf-8"+value;
		docmd(73,"'"+ value+"'");
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshiSelected.png");
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemu.png");
		window.setTimeout("getData(newurl,clientIndex)", 1500);//触发加载数据事件
		window.setTimeout("getChannelList();",2500);//触发加载数据事件
		
	});
	var topLfetW=$(".topLeft .controlAll").width();
	//做横竖屏的适配，相同的写法均是如此
	if(document.documentElement.clientHeight>=900){
		$(".showRate").css("width","29%");
		$("#div1").css("marginTop","16%");
	}else if(document.documentElement.clientHeight<900){
		$(".showRate").css("width","31%");
		$("#div1").css("marginTop","7%");
	}
	//以下为点击隐藏全局控制按钮所做的适配
	$(".clickMore img").click(function(){
		var topW=$(".top").width();
		if(parseInt($(".topRight").css("right"))!=-parseInt($(".top").width()*0.35)&&parseInt($(".topRight").css("right"))!=-35){
			$(".topRight").animate({"right":"-35%"});
			$(".topRight").css({"display":"none"});
			$(".bigScreen").animate({"marginLeft":"2.5%"});
			$(".topMain").animate({ "width": "80.8%" });
			//$(".topMain .programList .left .leftList").animate({ "width": "82%" });
			if (document.documentElement.clientHeight < 900) {
			   
				$(".topMain .programList .left .bgSpan").animate({width:"5%",height:$(".topMain .programList .left").width()*0.08+"px"});
				$(".topMain .programList .left .leftList").animate({ "width": "92%" });
				$(".startNow .startNowImg").css("width", "2.5rem");
				$(".startNow .startNowImg").css("height", "2.5rem");
				
			} else {
			    $(".topMain .programList .left .leftList").animate({ "width": "88%" });
			    $(".startNow").css("width", "9%");
				$(".topMain .programList .left .bgSpan").animate({width:"9%",height:$(".topMain .programList .left").width()*0.15+"px"});
				$(".topMain .programList .left .leftList span").animate({ "width": "88%" });
				$(".startNow").css("width", "9%");
			}	
		}else{
			$(".topMain").animate({"width":"46.2%"});
			$(".topRight").css({"display":"block"});
			$(".bigScreen").animate({"marginLeft":"1.5%"});
			
			$(".topRight").animate({"right":"0"});
			if (screenWidth1 >= 1000) {
			    $(".topMain .programList .left .leftList").animate({ "width": "88%" });
			    $(".topMain .programList .left .leftList span").animate({ "width": "88%" });
			    $(".startNow .startNowImg").css("width", "1.8rem");
			    $(".startNow .startNowImg").css("height", "1.8rem");
			} else {
			    $(".topMain .programList .left .leftList").animate({ "width": "88%" });
			    $(".topMain .programList .left .leftList span").animate({ "width": "86%" });
			   
			}	
			var cmdImg=$(".sendCmd").width()*0.2;
			var cmdLi=$(".openOrClose").height();
			var marTopLi=(cmdLi-cmdImg)/2;
			$(".sendCmd img").css("height",cmdImg);
			$(".smallbtn img").css("height",cmdImg);
			$(".smallbtn img").css("marginTop",marTopLi);
			var cmdLi=$(".openOrClose").height();
			var marTopLi=(cmdLi-cmdImg)/2;
			$(".sendCmd img").css("marginTop",marTopLi);
			if(document.documentElement.clientHeight<900){
				$(".topMain .programList .left .bgSpan").animate({width:"8%",height:$(".topMain .programList .left").width()*0.05+"px"});
				
			}else{
				$(".topMain .programList .left .bgSpan").animate({width:"9%",height:$(".topMain .programList .left").width()*0.08+"px"});
				
			}
		}	
		$(".controlImage  span").css("width", $(".controlImage img").width());
	});
	$(".handControl").click(function(){//点击手动模式
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshiSelected.png");
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemu.png");
	});
	$(".startProgram").click(function(){//自动播放
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshi.png");
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemuSelected.png");
	});
	$(".touchMouse .closeTouchMouse img").click(function(){
		$(".touchMouse").css("display","none");
	})
    //记住上一次访问的时候是全屏的还是非全屏的
	if ($.cookie("allscreen") == "open") {
	    div1.className = (div1.className == "close1") ? "open1" : "close1";
	    div2.className = (div2.className == "close2") ? "open2" : "close2";
	    var border1 = "1px solid rgba(0,0,0,0.1)";
	    var border2 = "1px solid rgba(0,0,0,0.15)";
	    if (div1.className == "close1") {
	        $(".slider").attr("allscreen", "close");
	        $(".close2").removeAttr("style");
	        $(".close2").animate({
	            left: "0px",
	            top: "0",
	        });
	        $(".close1").animate({ background: "#aaa", border: border2, borderLeft: "transparent" });    
	    } else {
	        $(".slider").attr("allscreen", "open");
	        $(".open2").removeAttr("style");
			$(".open2").animate({
				top: "0px",
				right: "0px"
			});
	    }
	    $.cookie("allscreen", $(".slider").attr("allscreen"));
	}
	setInterval("refreshScreen()", 2000);//定时刷新显示界面的大小，以便于界面大小改变时出现布局混乱的问题

    //此处是为了解决input输入框在移动端不能输入的问题
	$('#SendMSGBar input').click(function () {

        this.selectionStart = 0;

        this.selectionEnd = this.value.length;

	})
	//翻译,如果cookie中没有关于语言的记录，则认为是中文
	if ($.cookie("yuyan") != null && $.cookie("yuyan") != "" && $.cookie("yuyan") != undefined) {
	    if ($.cookie("yuyan") == "en") {
	        $(".changeLanguage img").attr("alt", "English");
	        $(".changeLanguage img").attr("src", "images/allTitle/EN.png");
	    } else {
	        $(".changeLanguage img").attr("alt", "中文");
	        $(".changeLanguage img").attr("src", "images/allTitle/CH.png");
	    }
	    
	} else {
	    $(".changeLanguage img").attr("alt", "中文");
	}
	//切换语言
	$(".changeLanguage img").click(function () {
		
	    if ($(this).attr("alt") == "English") {
	        $.cookie("yuyan", "en", { path: "/" });
	        $(this).attr("alt", "中文");
	        $(this).attr("src", "images/allTitle/EN.png");
			//setTimeout('getbtn("pctrl", 1)',3000);
			switchLanguage(0, "pctrl.html");
		
	    } else {
	        $.cookie("yuyan", "CH", { path: "/" });
	        $(this).attr("alt", "English");
	        $(this).attr("src", "images/allTitle/CH.png");
			//setTimeout('getbtn("pctrl", 0)',3000);
			switchLanguage(1, "pctrl.html");
			
		}		
	    getLanguageMsg("获取数据出错!", $.cookie("yuyan"));
	    $("#downLoad span").html(getLanguageMsg("下载", $.cookie("yuyan")));
	    $("#checkFile span").html(getLanguageMsg("预览", $.cookie("yuyan")));
	    if ($("#Screen .left").length <= 0&&$("#pic img").attr("src").indexOf("fail1")>=0) {
	        $("#Screen").html("<p align='center' style='width:100%;font-size:22px;color:red;'>" + getLanguageMsg("获取数据出错!", $.cookie("yuyan")) + "</p>");
	    }
	});	
})
window.onload=function(){
    //对截屏按钮后 同步按钮进行属性的改变
    $("#div3").click(function(){
        if($(".drawSync").attr("sync")=="sync"){
            $(".drawSync").attr("sync","no");
        }else{
            $(".drawSync").attr("sync","sync");
        }
    })
    $("#div1").css("marginTop", ($(".slider").height() - $("#div1").height() - 2) / 2);
    $(".changeLanguage").css("height", $(".slider").height());
	$(".changeLanguage img").css("marginTop", ($(".changeLanguage").height() - $(".changeLanguage img").width()) / 2);
	//对上次点击的终端进行记录，防止刷新时找不到上次操作的终端，如果cookie中没有记录终端则默认选中第一个终端
    if ($.cookie("clientIndex") == undefined || $.cookie("clientIndex") == "") {
        clientIndex = 0;
    } else {
        clientIndex = ($.cookie("clientIndex"));
    }
    //在页面刚加载时，若当前的终端超过了当前显示区域的大小，则自动滚动到终端的位置
    if ($.cookie("clientIndex") > $("#top").height() / $(".cc").height())
    {
        $('.topLeft .clientList').animate({ scrollTop: parseInt($.cookie("clientIndex")) * $(".cc").height() }, 'slow');
    }
    $("#tabscreen").attr("src", $("#top li:eq(" + clientIndex + ")").attr("src"));
    $("#top").attr("clientname", $("#top li:eq(" + clientIndex + ")").attr("clientname"))
    newurl= $("#tabscreen").attr("src");
	
    getData(newurl, clientIndex);//根据当前是第几个终端，从而显示第几个终端的列表
	//根据选中和未选中的状态来更改背景图
    $(".topLeft .clientList ul li b").css("background","url(../images/computerB.png) 0% 0% / 100% no-repeat");
    $(".topLeft .clientList ul li b").eq(0).css("background","url(../images/computerW.png) 0% 0% / 100% no-repeat");
	//文件上传时，若第一个终端的homeid="home"即当前页面是从显示端访问（且终端列表只有自己）而不是从控制室访问，
	//则提交文件时直接以相对路径提交到本地
	//否则根据当前的终端ip提交到相应的显示端上
	if ($("#top li:eq(0)").attr("homeid") == "home") {
        $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1");
    }else{
        $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1");
    }
    $("#top li:eq(" + clientIndex + ")").css({ "background": "#06afe8", "color": "#fff" })
	
    $("#title").html($("#top li:eq(" + clientIndex + ")").find("span").html());
    $("#tabscreen").attr("macName", $("#top li:eq(" + clientIndex + ")").attr("macname"));
    $("#tabscreen").attr("indexNumber", $("#top li:eq(" + clientIndex + ")").attr("indexclient"));
	//由于调节进度是采用touch事件，所以此处将事件先声明
    changeNowRate();
	//start为节目项是音视频的启动/暂停按钮，若点击播放，则启用轮询获取前端的播放进度
	//若暂停则清除轮询，已节约资源
    $(".start").click(function () {
	   
        var tabWindow=$("#tabscreen").attr("nowWindow");
        if ($(".start").attr("src") == "images/bottomPlay/bofang.png") {
            clearInterval(timer);
            docmdex(3002,tabWindow);
            $(".start").attr("src", "images/bottomPlay/tingzhi.png");

        } else {
            timer = setInterval("getRate(newurl)", 1000);
            docmdex(3003,tabWindow);
            $(".start").attr("src","images/bottomPlay/bofang.png");
        }
		
    })
    $(".closeImg").click(function(){
        $(".loadpng").css("display","none");
        $("#loadmask").css("display","none");
    })
    var clientLiH=$(".clientList ul li").height();
    var topLeftW=$(".topLeft").width();
    $(".topLeft .clientList ul li").css("width",topLeftW);
    $(".clientList ul li").css("lineHeight",clientLiH+"px");
    //点击任意终端进行样式的切换，同时将当前终端的ip和mac地址赋值给tabScreen,每次点击一次终端则去后台读取一次数据
	$(".cc").click(function () {
		
        $(".topLeft .clientList ul li b").css("background","url(../images/computerB.png) no-repeat");
		
        $(this).find("b").css("background","url(../images/computerW.png) no-repeat");
        $(".topLeft .clientList ul li b").css("backgroundSize","100%");
        var ccNum=$(this).attr("indexclient");
        $(".cc").css({"background":"#fff","color":"#000"})
        $(this).css({ "background": "#06afe8", "color": "#ffffff" });
		
		$("#tabscreen").attr("src", $(this).attr("src"));
		
        newurl=$("#tabscreen").attr("src");
        $("#tabscreen").attr("macName",$(this).attr("macname"));
        $("#tabscreen").attr("indexNumber",$(this).attr("indexclient"));
        $("#title").html($(this).find("span").html());
        $("#top").attr("clientName",$(this).attr("clientname"))
		$(".getChannel").html($(this).attr("clientname"));
		//若终端列表有返回中控页字样则表示当前的页面为在终端打开，而不是在控制室端打开
		if ($(this).find("span").text() == "返回中控页") {
            window.location.href="http://"+$(this).attr("src")+":8080"+window.location.href.split(":8080")[1];
        }else{
            getData(newurl,ccNum);
		}
		//文件上传时，若当前终端的homeid="home"即当前页面是从显示端访问（且终端列表只有自己）而不是从控制室访问，
		//则提交文件时直接以相对路径提交到本地
		//否则根据当前的终端ip提交到相应的显示端上
        if ($(this).attr("homeid") == "home") {
            $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1");

        }else{
            $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1");
        }//音量条隐藏
        if ($.cookie("clientIndex") != undefined || $.cookie("clientIndex") != null) {
            oldClientIndex = $.cookie("clientIndex");
        }
       
        $.cookie("clientIndex", ccNum);
		//此时是关闭获取音视频进度和截屏的websocket，防止点击其他终端时，websocket直接饮用上次的数据
		if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
            delete socket1;
            socket1 = null;
        }
        if (socket != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
            delete socket;
            socket = null;
        }   
    });
    showNowPlayScreen();
    whRate = parseInt($(".loadImage")[0].width) / parseInt($(".loadImage")[0].height);
    if ($.cookie("yuyan") == "en") {
        switchLanguage(1, "pctrl.html");
        $(".changeLanguage img").attr("src", "images/allTitle/CH.png");
    } else {
        switchLanguage(0, "pctrl.html");
        $(".changeLanguage img").attr("src", "images/allTitle/EN.png");
	}
	//页面加载时根据屏幕的大小所做的自适应
    if(document.documentElement.clientWidth>=900){
        $("#range2").css("bottom", "160px");
        $("#range2").css("left", "72%");
        $("#value2").css("left", "68%");
        $("#value2").css("bottom", "65px");
        $(".controlBottomTab li b").css("width","60%");
    }else{
        $("#range2").css("bottom","160px");
        $("#range2").css("left","72%");
        $("#value2").css("left", "68%");
        $("#value2").css("bottom", "85px");
        $(".controlBottomTab li b").css("width","100%");
    }
    $(".topLeft .controlAll li img").css("marginTop", ($(".topLeft .controlAll li").height() - 10 - $(".topLeft .controlAll li span").height() - $(".topLeft .controlAll li img").width()) / 2);
    $(".videoTitle img").click(function(){
        $(".videoContent").css("display","none");
    })
	
	$(".videoTK select").change(function () {
		//获取视频源
        var selectVal=$(this).val();
        getVideoSource(selectVal)
    })
    $(".musicTitle img").click(function(){
        $(".musicContent").css("display","none");
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
	//以下为人脸识别部分
	//选择了一个ID后，其他的部分根据ID自动识别，并且将得到的数据添加到指定的位置（添加人脸连识别）
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
	//合并人脸识别时所做的操作
    $(".faceMergeUL select").eq(0).click(function () {

        $(this).next().val($(this).find("option:selected").html());
        var selectStr = $(this).find("option:selected").attr("faceInfo");
        if (selectStr != "") {
            $(this).parents(".faceMergeUL").find("li").eq(1).find("input").val((selectStr.split("_")[1]).split(":")[1]);
            $(this).parents(".faceMergeUL").find("li").eq(2).find("input").val((selectStr.split("_")[2]).split(":")[1]);
            $(this).parents(".faceMergeUL").find("li").eq(3).find("input").val((selectStr.split("_")[3]).split(":")[1]);
        }

    })
   
    $("#checkPictureTitle img").click(function () {
        $("#checkPicture").hide();
    })
    $(".fileTitle img").click(function(){
        $(".fileContent").css("display", "none");
        $(".fileTK").removeClass("current");
        $("#uploadRateLeft").css("width", "0%");
    })

    $(".slideImage").click(function(){
		
        $(".sildeMore").css("right","0");
        hideSlideTimer = setInterval("timeCount()", 1000);
    })
    $(".commonStyle").click(function () {
        if (count != 0) {
            clearInterval(hideSlideTimer);
            count = 0;
            setTimeout('$(".slideImage").click()', 3000);
        }	
    })
    $("#pic").click(function(){
        getScreen();
        //loadPicture(1)
    })
    $("#title").click(function(){
        touchPanel();
    })
	$("#title").css("width","72px");
    $("#localIP").click(function(){
        window.location.href="http://"+$("#freshPage span").attr("localip")+":8080/pctrl.html";
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
        drawImage($("#points").val()*0.05);
    })
    $(".slideImage1").click(function () {

        $(".sildeMore1").css("right", "0");
        hideSlideTimer2 = setInterval("timeCount1()", 1000);
    })

    $("#points1").on('input propertychange', function () {
        getNowSize(this,1);
        if (count1 != 0) {
            clearInterval(hideSlideTimer2);
            count1 = 0;
            setTimeout('$(".slideImage1").click()', 3000);
        }
    })
    $("#points1").on("change", function () {
        drawImage1($("#points1").val() * 0.05);
    })
    $("body *").click(function (e) {
        if ($(e.target).closest('.slideImage').length == 0) {
            $(".sildeMore").css("right", "-60px");
            clearInterval(hideSlideTimer);
            count = 0;
        }
    });
    $("body *").click(function (e) {
        if ($(e.target).closest('.slideImage1').length == 0) {
            $(".sildeMore1").css("right", "-60px");
            clearInterval(hideSlideTimer2);
            count1 = 0;
        }
    });
    //点击音量图标，音量条显示，点击初次之外的按钮，音量条隐藏
    $("body *").on("click", function (e) {
        var target = $(e.target);
        if (target.closest(".allSound").length != 0 || target.closest(".materialSound").length != 0) return;
        $(".systemSound").css("display", "none");
        $("#meterial").css("display", "none");
    });
    $(".topLogin img").click(function () {
        $(".onClickLogin").hide();
        $(".contentLoginMain input[type='text']").val(" ");
    })
    $(".contentLoginTop label").eq(1).click(function () {
        if ($(".contentLoginTop input[type='checkbox']").eq(2).prop("checked") == true) {
            $(".contentLoginTop input[type='checkbox']").eq(2).prop("checked", false)
        }
    })
    $(".contentLoginTop label").eq(2).click(function () {
        if ($(".contentLoginTop input[type='checkbox']").eq(1).prop("checked") == true) {
            $(".contentLoginTop input[type='checkbox']").eq(1).prop("checked", false)
        }
    })
    $(".tipOk").click(function () {
        $(".confirmDiv").css("display", "none");
        $(".topConfirm").attr("messageTip", "ok");
        var functionName = $(".tipContent").attr("fName");
        var functionNum = $(".tipContent").attr("messageNum");
        eval(functionName + "(" +functionNum + ")");
    })
    $(".tipCancle").click(function () {
        $(".topConfirm").attr("messageTip", "");
        $(".confirmDiv").css("display", "none");
        // var functionName = $(".tipContent").attr("fName");
        // eval(functionName + "()");
    })
    $(".windowName img").click(function () {
        $(".playScreenShadow").hide();
    })
    //音频
    //音箱
    $("#tvControlShadow2 li").click(function () {

        var parentIndex = $(this).parent().parent().index();
        var thisIndex = $(this).index();
        var controlNum = "";
        var openNum = "";
        if (parentIndex == 0) {
            openNum = "112";
            controlNum = "109";

        } else if (parentIndex == 1) {
            openNum = "119";
            controlNum = "116";
        } else if (parentIndex == 2) {
            openNum = "120";
            controlNum = "117";
        } else if (parentIndex == 3) {
            openNum = "121";
            controlNum = "118";
        } else if (parentIndex == 4) {
            openNum = "113";
            controlNum = "110";
        } else if (parentIndex == 5) {
            openNum = "105";
            controlNum = "102";
        } else if (parentIndex == 6) {
            openNum = "103";
            controlNum = "100";
        } else if (parentIndex == 7) {
            openNum = "104";
            controlNum = "101";
        } else if (parentIndex == 8) {
            openNum = "111";
            controlNum = "108";
        }
        if (thisIndex == 1) {
            audioNoSound(openNum, "65535");

        } else if (thisIndex == 2) {
            audioNoSound(openNum, "0");
        } else if (thisIndex == 3) {
            changeSound1(controlNum, "1");
            if (parseInt($(this).next().html()) < 84) {
                $(this).next().html(parseInt($(this).next().html()) + 1);
            }

        } else if (thisIndex == 5) {
            changeSound1(controlNum, "0");
            if ($(this).prev().html() > 0) {
                $(this).prev().html(parseInt($(this).prev().html()) - 1);
            }

        }
    })
    //音箱组
    $("#tvControlShadow3 li").click(function () {
        var parentIndex = $(this).parent().parent().index();
        var thisIndex = $(this).index();
        var controlNum1 = "";
        var controlNum2 = "";
        var controlNum3 = "";
        var openNum1 = "";
        var openNum2 = "";
        var openNum3 = "";
        if (parentIndex == 0) {
            controlNum1 = "112";
            controlNum2 = "119";
            openNum1 = "109";
            openNum2 = "116";
        } else if (parentIndex == 1) {
            controlNum1 = "112";
            controlNum2 = "119";
            controlNum3 = "120";
            openNum1 = "109";
            openNum2 = "116";
            openNum3 = "117";
        } else if (parentIndex == 2) {

            controlNum1 = "119";
            controlNum2 = "120";

            openNum1 = "116";
            openNum2 = "117";
        } else if (parentIndex == 3) {
            controlNum1 = "113"
            controlNum2 = "119";
            controlNum3 = "120";
            openNum1 = "110";
            openNum2 = "116";
            openNum3 = "117";
        } else if (parentIndex == 4) {
            controlNum1 = "105"
            controlNum2 = "113";
            openNum1 = "102";
            openNum2 = "110";
        } else if (parentIndex == 5) {
            controlNum1 = "103"
            controlNum2 = "105";
            openNum1 = "100";
            openNum2 = "102";
        } else if (parentIndex == 6) {
            controlNum1 = "103"
            controlNum2 = "104";
            openNum1 = "100";
            openNum2 = "101";
        } else if (parentIndex == 7) {
            controlNum1 = "104"
            controlNum2 = "111";
            openNum1 = "101";
            openNum2 = "108";
        } else if (parentIndex == 8) {
            controlNum1 = "111"
            controlNum2 = "112";
            openNum1 = "108";
            openNum2 = "109";
        }
        if (thisIndex == 1) {//静音
            // changeGroupOrder("65535", openNum1, openNum2,openNum3);
            changeGroupOrder("65535", controlNum1, controlNum2, controlNum3);
        } else if (thisIndex == 2) {//取消静音
            changeGroupOrder("0", controlNum1, controlNum2, controlNum3);
        } else if (thisIndex == 3) {//音量加
            changeGroupSound("1", openNum1, openNum2, openNum3);
        } else if (thisIndex == 5) {//音量减
            changeGroupSound("0", openNum1, openNum2, openNum3);
        }
    })
    //主机/话筒
    $("#tvControlShadow4 li").click(function () {
        var parentIndex = $(this).parent().parent().index();
        var thisIndex = $(this).index();
        var controlNum = "";
        var openNum = "";
        if (parentIndex == 0) {
            controlNum = "437"
            openNum = "439";
        } else {
            controlNum = "436";
            openNum = "438";

        }
        if (thisIndex == 1) {
            audioNoSound(openNum, "65535");
        } else if (thisIndex == 2) {
            audioNoSound(openNum, "0");
        } else if (thisIndex == 3) {
            changeSound1(controlNum, "1");
            if (parseInt($(this).next().html()) < 84) {
                $(this).next().html(parseInt($(this).next().html()) + 1);
            }
        } else if (thisIndex == 5) {
            changeSound1(controlNum, "0");
            if ($(this).prev().html() > 0) {
                $(this).prev().html(parseInt($(this).prev().html()) - 1);
            }
        }
	})
	if ($.cookie("yuyan") == "en") {
		getbtn("pctrl", 1);
	} else if ($.cookie("yuyan") == "CH") {
		getbtn("pctrl", 0);
	} else {
		getbtn("pctrl");
	}
	setTimeout(function () {
		$(".controlImage img").eq(0).click();
	}, 1000)
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
//点击频道获取，根据展开或者收起状态对当前区域进行样式的改变
function changeBorder(){
	var raius="10px 10px 0px 0px";
	if($("#channelBar").css("display")=="none"){
		$("#changeChannel").css("borderRadius","10px");
	}else{
		$("#changeChannel").css("borderRadius",raius);
		
	}
}
//获取数据
function getData(URL, num) {
	showLoading();
	content1='';
	if(URL!=oldURL){//若改变url则将原来url所得到的数据去除
		if(contentStr[num]!=undefined||contentStr[num]!=""){
			$(".programList").children().remove();
			$("#Screen").html(contentStr[parseInt(num)]);
			changeStyle();
		}
	}
	$("#pic").html('<img src="images/loadStatus.gif" class="loadStatus" allscrren="close" style=\"position:relative;left:0px;width:24px;top:25px;margin-right:5px;display:block;\"/>');
	$("#pic img").css("top", ($("#pic").height() - 24) / 2);
	controlIpName = $(".cc").eq(num).find("p").text();
	$("#tabscreen").attr("color", $(".cc").eq(num).attr("color"));
	$("#tabscreen").attr("onlyview", $(".cc").eq(num).attr("onlyview"));
	$("#tabscreen").attr("usegate", $(".cc").eq(num).attr("usegate"));
	$("#tabscreen").attr("gateip", $(".cc").eq(num).attr("gateip"));
	$("#tabscreen").attr("gateport", $(".cc").eq(num).attr("gateport"));
	$("#tabscreen").attr("port", $(".cc").eq(num).attr("port"));
	color = $(".cc").eq(num).attr("color");//颜色值
	onlyview = $(".cc").eq(num).attr("onlyview");//是否是只允许预览
	usegate = $(".cc").eq(num).attr("usegate");//是否是多个服务器进行转发指令
	gateip = $(".cc").eq(num).attr("gateip");//进行转发的多个服务器的ip地址，以;分割
	gateport = $(".cc").eq(num).attr("gateport");//目的服务器的显示端的端口号
	port = $(".cc").eq(num).attr("port");//目的服务器的显示端的端口号
	$.ajax({
		url: URL+"/wpgetxmlids.asp?rnd="+(Math.floor(Math.random()*(9999-1000))+1000)+"&utf8=1",
		dataType: 'xml',
		type: 'GET',		//提交方式
		timeout: 5000,      //失败时间
		error: function(xml)
		{
			hideLoading();
		    $("#pic").html("<img src='images/fail1.png' style=\"position:relative;left:0px;width:24px;margin-right:5px;display:block;\"/>");//top:15px;
			$("#pic img").css("top",($("#pic").height()-24)/2);

			//当数据出错时将原有的数据清除，
			var number=parseInt($("#tabscreen").attr("indexnumber"));
			if(contentStr[number]!=undefined||contentStr[number]!=""){
				$(".programList").children().remove();
				$("#Screen").html(contentStr[parseInt(number)]);
			}
			$("#Screen").html("<p align='center' style='width:100%;font-size:22px;color:red;'>" + getLanguageMsg("获取数据出错!", $.cookie("yuyan")) + "</p>");
			$("#functionButton").hide();
			$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemu.png");
			$(".handControl").find("img").attr("src", "images/leftControl/shoudongmoshi.png");
			$(".topLeft .clientList ul li b").css("background", "url(../images/computerB.png) no-repeat");
			$(".topLeft .clientList ul li b").css("backgroundSize", "100%");
			$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("background", "url(../images/tubiao.png) no-repeat");
			if (xml.statusText == "error") {
			    $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition", "-1px -409px");
			} else if (xml.statusText == "timeout") {
			    $(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("background", "url(../images/allTitle/timeOut.png) no-repeat");
			}
			changeStyle();
			oldData='';	
		},
		success: function(xml)
		{	//if($(xml).text()!)
		    $("#functionButton").css("display", "block");
		    if (oldClientIndex != num) {
		        $(".topLeft .clientList ul li").eq(parseInt(num)).find("b").css("backgroundPosition", "-1px -409px");
		        oldClientIndex = num;
		    }
			//每次请求成功后都将之前所获得的播放列表的数据清除 
			$("#Screen").attr("align","left");      
			
				if($(xml).find("item").length<=0){
				    $(".programList").html("<p align='center'>当前节目单为空！</p>");
				    $("#pic").html("<img src='images/success1.png' style=\"position:relative;left:0px;width:24px;top:25px;margin-right:5px;display:block;\"/>");//top:15px;
                    getLanguageMsg("当前节目单为空!",$.cookie("yuyan"));
				}else{
				    $("#pic").html("<img src='images/success1.png' style=\"position:relative;left:0px;width:24px;top:25px;margin-right:5px;display:block;\"/>");//top:15px;
					$("#pic img").css("top",($("#pic").height()-24)/2);
					$(".programList").children().remove();
					content1="";
				//判断当前请求的数据与上次请求的数据是否不同，若不同执行下面的程序，目的是能将用户新编排的节目单及时的显示到操控页面，
				//与此同时，又不会在不断的获取数据的过程中出现闪屏的现象。
					var clientInfo=$(xml).find("clientInfo");//获得终端信息标签
					var clientName1=$(clientInfo).attr("clientname");//获得终端名称
					var playTask = $(clientInfo).attr("playtask");
					var arrayTask = "";
					var currentTask=""
					if (playTask == undefined || playTask == "" || playTask==null) {
					    arrayTask = "";
					} else {
					    arrayTask = playTask.split("/");
					    currentTask = arrayTask[1];//获得当前播放节目的id
					}
					var playVol = $(clientInfo).attr("playvol");//获得当前的系统音量
					var hostName=$(clientInfo).attr("hostname");//获得当前的计算机名
					var menuPath=$(clientInfo).attr("menupath");//获得当前播放节目单所存储的位置
					var menuInfo=$(clientInfo).attr("menuinfo");//获取当前节目单名
					var localIp = $("#freshPage span").attr("localip", $(clientInfo).attr("controlroom"));
					controlRoom = localIp;
					if ($(clientInfo).attr("scrrate") != null && $(clientInfo).attr("scrrate") != undefined) {
					    screenWidth = parseInt($(clientInfo).attr("scrrate").split("_")[0]);//获得显示端的宽度
					    screenHeight = parseInt($(clientInfo).attr("scrrate").split("_")[1]);//获得显示端的高度
					    widthRate = screenWidth / canvaswindowWidth;//获取显示端宽度和截屏的canvas的比例，以保证截屏截屏操作后点击某一个位置后与前端屏一致
					}
					var playState=$(clientInfo).attr("playstate");
					var playOrPause = "";
					var playStart=""
					if (playState != null && playState != undefined) {
					    playOrPause = playState.split("_");
					    playStart = playOrPause[0];
					}
					//根据当前从后台获取的状态更改操控页面的图标和状态
					changPlayStatus(playStart);					
					var systemSound = "";
					var validValue = 0;
					var objValid = "";
					var objValid2 = "";
					//获取系统音量
					if (playVol != null && playVol != undefined && playVol!="") {
					    //findex = playVol.split("/");
					    objValid=playVol.split("/");
					    systemSound = objValid[0];
					    if (objValid.length > 1) {
					        objValid2 = objValid[1].split("_");
					        if (objValid2 != "" && objValid2.length>1 && objValid2[1] == "1") {
					            validValue = 1;
					        }
					    }
					}
					
					if (true||(validValue == 1)) {
					    var nosoundVao = systemSound & 0x008000;//判断系统有没有静音
					    systemSound = systemSound & ~0x008000;
					    if (nosoundVao == 0x008000) {//判断当前系统是不是静音状态
					        $(".noSound").attr("src", "images/leftControl/noSound.png");
					    } else {
					        $(".noSound").attr("src", "images/leftControl/quanjuyinliangSelected.png");
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
					var playProc1=""
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
                    //showStatus(mainStatus,num)
					if (parseInt(thisStatus) == 1) {
						//后台返回的数据判断当前应显示的状态图标,如果thisStatus为1说明当前的数据改变了，若为0说明数据没有改变
						//只有当数据改变时才重新更改状态图标
						showStatus(mainStatus,num)
					}
					
					$(".cc").eq(num).attr("mainStatus",mainStatus);
					if($("#top li span").text()=="返回中控页"){
						$("#top li").attr("src",$(xml).find("clientInfo").attr("controlroom"));
					}
					var playOrPause ="";
					var playStatus ="";//获得当前节目所处的状态，是暂停还是继续
					if (playState != null && playState != undefined) {
					    playOrPause = playState.split("_");
					    playStatus = playOrPause[0];//获得当前节目所处的状态，是暂停还是继续
					}
					var gGetPlayDuringarr="";
					var gGetPlayDuring = "";
					if ($(clientInfo).attr("playdur") != null && $(clientInfo).attr("playdur") != undefined) {
					   gGetPlayDuringarr = $(clientInfo).attr("playdur").split("_");
					   gGetPlayDuring = parseInt(gGetPlayDuringarr[0]);
					}
				
					$("#rangeRate1").attr("max",gGetPlayDuring);
					var strs=parseFloat($("#rangeRate1").css("width"));
					
					$("#rateProgressValue").html(secondToMinute((playProc1/10000)*strs));
					//playState为音视频播放器播放状态（播放3，暂停2，停止1）,playtask(最前字节为显示端播放任务状态/播放任务号(2字节任务号/1字节栏目内任务号))，
					//playProc为音视频播放进度万分比，playVol为播放机音量/音视频播放程序音量，g_getplayduring音视频文件的总时长，以毫秒为单位
				//判断当前状态是暂停还是继续
					changPlayStatus(playStatus);
					//判断手动还是自动模式
					changeMenuState(menuState);
					
					$(xml).find("item").each(function(i){
						var downLink=$(this).find("downLink").text();
						var itemType=$(this).find("itemType").text();
						var moreInfo=$(this).find("moreInfo");	//其他信息字符串
						var markID = $(this).find("markID").text();		//任务号 素材号-栏目号-主任务号-栏目内任务号
						var Win = $(this).find("win").text();
						var tempMarkID = "";
						var taskID = "";	//任务号
						var moreInfo2 = "";
						
						var windowsNum = "";
						var numberWindows = "";
						var win = "";
						var newMoreInfo = ""

						if (markID != undefined && markID != null) {
                            tempMarkID = markID.split("-");
                            if (parseInt(tempMarkID[1]) > 1) {
                                taskID = parseInt(tempMarkID[2]) + (parseInt(tempMarkID[3]) << 16)  ;//算数符号优先级高于移位优先级
                            } else {
                                taskID = tempMarkID[2];	//任务号
                            }
						     
						     moreInfo2 = moreInfo.text().split("\\027");
						    if (moreInfo2[0] == "") {
								if ($(this).find("taskName").text() != "") {
									moreInfo2[0] = $(this).find("taskName").text();
								} else {
									moreInfo2[0] = "[" + ItemType(itemType, downLink) + "]";
								}
						    }
						   
						     
						     if (moreInfo2[1] != "" && moreInfo2[1] != null && moreInfo2[1] != undefined) {
						         newMoreInfo = moreInfo2[1].split("_")[1];
						     }
						         
						}
						if (Win != undefined && Win != null) {
						    windowsNum = Win.split(":");
						    numberWindows = windowsNum[0].split("-");
						    win = numberWindows[0];
						}
						
						if ($(this).find("iconLink").text().indexOf("$$") >= 0) {
						    iconLink = newurl + "/" + $(this).find("iconLink").text();
						} else {
						    iconLink = "http://" + $("#freshPage span").attr("localip") + ":8080/" + $(this).find("iconLink").text();
						} 
						
						//缩略图
						var randomColor = color16((Win.split(":")[0]).split("-")[0]);
						//docmd(67,'"+taskID+"')
						var imagesrc="<span class='bgSpan' onclick=\"changeSize(this);\"><img src='"+iconLink+"' align='absmiddle' onerror='changeImage(this)'/><span class='bigScreen' style='width:100%;height:100%;margin-top:-100%;'><img src='images/list/bofang.png' style='width:20%;height:20%;'></span></span>"//类型图片
						var inImage="<div class='startNow'  style='width:12%;height:100%;display:block;float:right;position:relative;' onclick=\"startNow(this,'"+taskID+"');\"><img class='startNowImg' src='images/list/startNow.png' style='display:block;width:2rem;height:2rem;float:right;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);'/></div>";//'"docmd(16,"'+taskID+'")"'
						var columnInfoImage ="<div class='startNow'  style='width:12%;height:100%;display:block;float:right;position:relative;'><img  class='getMoreList' src='images/contentTab/gengduoex.png' style='display:block;width:1.5rem!important;height:1.5rem!important;float:right;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%)' onclick='getClickMore(this)'/></div>";
                        //节目项列表
                       //特殊约定：对于不想显示在界面上的节目项，比如跳转指令等，可以通过在任务名前加两个**进行标记，处理程序可根据该标记来决定显示不显示该节目项。
                        if ($(this).find("taskName").text().indexOf("**") >=0 ) {

                        } else {
							if($(this).find("itemType").text() .indexOf("14")>=0 || $(this).find("itemType").text().indexOf("1014")>=0 ){
								content1 += "<div class='left' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2]+">" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "' ><span markID=" + markID + " itemType=" + itemType+" style='padding-left:2%;height:100%;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\" ><p class='programFileName' style='width:90%;'>" + moreInfo2[0] + "</p><p class='timeLong' style='width:90%;font-size:14px;color:#999;margin-top:5px;'><i style='font-size:12px;'><i  style='color:" + randomColor+"'>"+win+"</i>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + columnInfoImage + "</div></div><div class='left1' taskid='" + taskID + "' style='display:none;'></div>";
							}else if($(this).find("downLink").text().slice($(this).find("downLink").text().length-1).indexOf("\\")>=0){
								content1 += "<div class='left' taskid='" + taskID + "'>" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "' ><span markID=" + markID + " itemType=" + itemType+" style='padding-left:2%;height:100%;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\" ><p class='programFileName' style='width:90%;'>" + moreInfo2[0] + "</p><p class='timeLong' style='width:90%;font-size:14px;color:#999;margin-top:5px;'><i style='font-size:12px;'><i  style='color:" + randomColor+"'>"+win+"</i>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + columnInfoImage + "</div></div><div class='left1' taskid='" + taskID + "' style='display:none;'></div>";
							}else{
								if ($(this).find("markID").text().split("-")[1] > 0) {
									content1 += "<div class='left' style='display:none;' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2]+">" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "' ><span markID=" + markID + " itemType=" + itemType+" style='padding-left:2%;height:100%;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\" ><p class='programFileName' style='width:90%;'>" + moreInfo2[0] + "</p><p class='timeLong' style='width:90%;font-size:14px;color:#999;margin-top:5px;'><i style='font-size:12px;'><i  style='color:" + randomColor+"'>"+win+"</i>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + inImage + "</div></div><div class='left1' taskid='" + taskID + "' style='display:none;'></div>";
								}else{
									content1 += "<div class='left' taskid='" + taskID + "'>" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "' ><span markID=" + markID + " itemType=" + itemType+" style='padding-left:2%;height:100%;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\" ><p class='programFileName' style='width:90%;'>" + moreInfo2[0] + "</p><p class='timeLong' style='width:90%;font-size:14px;color:#999;margin-top:5px;'><i style='font-size:12px;'><i  style='color:" + randomColor+"'>"+win+"</i>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + inImage + "</div></div><div class='left1' taskid='" + taskID + "' style='display:none;'></div>";
								}	
							}
                        }
					});
					var strNum=parseInt($("#tabscreen").attr("indexnumber"));
					contentStr[strNum]=content1;
					$("#Screen").html(content1);
					if(conDragScreen){
						dragScreen();
					}
					
					$(".topMain .programList .left:nth-child(2n+1)").find(".leftList span").css("background", "#c9ecfe");
					$(".loadpng").attr("screenWidth",screenWidth);
					$(".loadpng").attr("screenHeight",screenHeight);
					//获得焦点的项目样式改变
					changeStyle();
					//全局控制按钮
                    controlAll = "<ul src='" + URL + "'><li onclick='docmd(69,0)'>手动模式</li><li class='sendCmd' onclick='docmd(11,0)' >启动节目</li><li class='sendCmd' onclick='docmd(70,0)'>停止节目</li><li cmdStr='' title='sound'><input id='range' type='range' min='0' max='255' value='' onchange='change(\"range\",\"value\")'></input>&nbsp;&nbsp;<span id='value'>#</span></li><li class='sendCmd' id='preTask' onClick='docmd(\"before\",0)'>上一节目项</li><li class='sendCmd' id='nextTask' onClick='docmd(\"next\",0)'>下一节目项</li><li class='sendCmd' onclick='docmd(21,0)'>暂停/继续</li></ul>";
					//显示系统音量
					
					if (soundFlag <= 0) {
					    $("#range").val(systemSound);
					    $("#value").html(systemSound);
					    $("#range2").val(mplayVol);
					    $("#value2").html(mplayVol);
					}
					
				    $(".clientName1").html(clientName1);

				    $(".hostName1").html(hostName);
				    $(".menuListName1").html(menuInfo);
					//根据当前的手动还是自动的状态切换图标，点击手动则关闭自动模式，否则开启，默认情况下则开启的是自动模式
					clickChangeMenuState(menuState);
					
					//如果当前没有正在播放的节目，则默认将第一个节目设置为获得焦点的节目
					if (currentTask <= 0) {
					    currentTask = 1;

					    $("#Screen").find(".left").eq(0).find(".leftList span").click();
					} else {
					    for (var i = 0; i < $(".left").length; i++) {
					        if (currentTask == $(".left").eq(i).attr("taskid")) {
					            $(".left").eq(i).find(".leftList span").click();
					        }
					    }
					    for (var k = 0; k < $(".left").length; k++) {
					        if ($(".left").eq(k).attr("taskid") == currentTask) {
					            $(".left").eq(k).find(".timeLong").css("color", "#d11b28");
					        }
					    }
					}
					hideLoading();
					
				}
				//}
			//将新的数据请求完毕之后将新的数据置为旧的数据，方便下次比较
			oldData=$(xml).text();
		}
	});
	//setTimeout("dragScreen()", 2000);
	//将当前的url设置为oldurl,也是为了切换显示端时，让程序进行识别，清除原来的数据
	oldURL=URL;	
}
function getFileFolder(ele,subpath,tasktype){
	$.ajax({
		url:newurl+"/wpdigitalcontent.asp",
		type:"get",
		dataType:"xml",
		data:{
			"type":"0",
			"utf8":"1",
			"pageno":"0",
			"pagesize":"1000",
			"sort":"0",
			"desc":"1",
			"pathindex":"6",
			"subpath":subpath,
			"displaydate":"",
			"tasktype":tasktype
		},success:function(data){
			var content2="";
			if($(data).find("item").length>0){
				var dataStr=$(data).find("item");
				
				for(var i=0;i<dataStr.length;i++){
					var taskID=dataStr.eq(i).find("id").text();
					var iconLink="$$"+subpath+dataStr.eq(i).find("l2").text();
					//docmd(67,'" + taskID + "')
					var imagesrc = "<span class='bgSpan' onclick=\"changeSize(this);\"><img src='" + iconLink + "' align='absmiddle' onerror='changeImage(this)'/></span>"//类型图片
					var downLink=subpath+dataStr.eq(i).find("l1").text();
					var playStatus=$(ele).parent().parent().parent().find(".leftList").attr("playStatus"); 
					var win=0;
					var systemSound=$(ele).parent().parent().parent().find(".leftList").attr("systemSound"); 
					var markID=taskID;
					var fileName=dataStr.eq(i).find("l1").text();
					var mplayVol=$(ele).parent().parent().parent().find(".leftList").attr("mplayVol");
					var Win=$(ele).parent().parent().parent().find(".leftList").attr("windowsnum");
					var randomColor = color16(Win);
                    var otherButton="<div class='programBtn'></div>";
					var  programListInfo = "<div class='programListInfo'><p ><span>" + getLanguageMsg("地址:", $.cookie("yuyan")) + "</span>" + downLink + "</p><p><span>" + getLanguageMsg("布局:", $.cookie("yuyan")) + "</span>" +  + "</p></div>";
					
                    var inImage = "<div class='startNow'  style='width:12%;height:100%;display:block;float:right;position:relative;' onclick=\"startNow(this,'" + taskID +"','"+1+"','"+$(ele).parent().parent().parent().attr('taskid')+"');\"><img class='startNowImg' src='images/list/startNow.png' style='display:block;width:2rem;height:2rem;float:right;position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);'/></div>";
                    var infoProgram = "<span class='infoProgram'>"+$(ele).parent().prev().find(".timeLong").html()+"</span>";
                   
					content2 += "<div class='left folderList' style='display:none;' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2]+">" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' taskId='" + taskID + "' parentid='"+$(ele).parent().parent().parent().attr('taskid')+"' itemType='" + tasktype + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "' ><span markID=" + markID + " itemType=" + tasktype+" style='padding-left:2%;height:100%;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + tasktype + "',this);\" ><p class='programFileName' style='width:90%;'>" + fileName + "</p><p class='timeLong' style='width:90%;font-size:14px;color:#999;margin-top:5px;'>"+infoProgram+"</p></span>" + inImage + "</div></div><div class='left1' taskid='" + taskID + "' style='display:none;'></div>";
				}	
				$(ele).parent().parent().parent().next().after(content2);
				if($(ele).parent().parent().parent().css("background")=="rgb(201, 236, 254) none repeat scroll 0% 0% / auto padding-box border-box"){
					$(".folderList .leftList>span:odd").css("background","rgb(201, 236, 254)")
				 }else{
					$(".folderList .leftList>span:even").css("background","rgb(201, 236, 254)")
				 }
				 changeStyle();
                
			}
		},error:function(a,b,c){

		}
	})
}
//在本机当前图片缩略图的情况下，显示系统默认的缩略图
function changeImage(thisIamge){
	$(thisIamge).attr("src","images/typeb3.png");
}
//处理当前新是否连接到中央控制室所做的样式的判断
function changeMainStatus(num){
	var mainStatus1=$(".cc").eq(num).attr("mainStatus");
	if(mainStatus1==0){
		$(".cc").css("color","#000");
		$(".cc").eq(num).css("color","red");
	}else{
		$(".cc").eq(num).css("color","fff");
	}
}

//声明函数根据后台返回的数据判断当前应显示的状态图标
function showStatus(menuStatus,number){
	var menuStatus=parseInt(menuStatus);
	$(".topLeft .clientList ul li b").css("background","url(../images/computerB.png) no-repeat");
	$(".topLeft .clientList ul li b").css("backgroundSize","100%");
	$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("background","url(../images/tubiao.png) no-repeat");
	if(menuStatus==0){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-1px -409px");
	}else if(menuStatus==1){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-50px -409px");
	}else if(menuStatus==2){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-101px -409px");
	}else if(menuStatus==3){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-152px -409px");
	}else if(menuStatus==4){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-203px -409px");
	}else if(menuStatus==5){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-254px -409px");
	}else if(menuStatus==6){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-1px -445px");
	}else if(menuStatus==7){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-52px -449px");
	}else if(menuStatus==8){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-101px -447px");
	}else if(menuStatus==9){
		$(".topLeft .clientList ul li").eq(parseInt(number)).find("b").css("backgroundPosition","-152px -447px");
	}
}
//音视频暂停/启动图片切换
function changPlayStatus(playStatus1){
	if(playStatus1=="2"){
		$(".start").attr("src","images/bottomPlay/tingzhi.png");
	}else{
		$(".start").attr("src","images/bottomPlay/bofang.png");
	}
}
//页面加载时获取手动模式还是自动模式
function changeMenuState(menuState){
	if(menuState==2){
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemuSelected.png");
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshi.png");
	}else if(menuState==1){
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemu.png");
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshiSelected.png");
	}else{
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemu.png");
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshi.png");
	}
}
//根据当前的手动还是自动的状态切换图标，点击手动则关闭自动模式，否则开启，默认情况下则开启的是自动模式
function clickChangeMenuState(menuState){
	if(menuState==1){
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshiSelected.png");
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemu.png");
	}else{
		$(".handControl").find("img").attr("src","images/leftControl/shoudongmoshi.png");
		$(".startProgram").find("img").attr("src","images/leftControl/qidongjiemuSelected.png");
	}
}
//专门为了获取音视频的播放状态，获取的方式和getData（）相同，只不过不再对其他的数据进行处理
function getRate(URL) {
	if(dragStartjt){return;}//判断是不是要进行拖拽的动作，若是则将获取进度的长连接终止掉
	if(sendding){return;}
	sendding=true;
	if(URL!=oldURL){//若改变url则将原来url所得到的数据去除
		$(".programList").children().remove();
	}
	if (socket != null && socket.readyState == 1) {
		//若socket不是空，则说明已经启用了，所以每次只需要直接发送请求即可
        socket.send("wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000));
	} else {
		//若没有启用scoket，则建立socket连接并且发送一次ajax请求，随后使用websocket发送请求
         connect();
		if(socket!=null&&socket.readyState==1){
            socket.send("wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000));
		   sendding=false;
                   return;
				   
		}
		$.ajax({
            url: URL + "/wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
			dataType: 'xml',
			type: 'GET',		//提交方式
			timeout: 2000,      //失败时间
			//timeout: 0,		//失败时间
			error: function(xml)
			{
			},
			success: function(xml)
			{

				$("#functionButton").css("display","block");
				//每次请求成功后都将之前所获得的播放列表的数据清除
				
				$("#Screen").attr("align","left");      
				var clientInfo=$(xml).find("clientInfo");//获得终端信息标签
				
				var playProc=$(clientInfo).attr("playproc").split("_");
				var playProc1=playProc=parseInt(playProc[0]);
				var playTask=$(clientInfo).attr("playtask");
				var gGetPlayDuringarr=$(clientInfo).attr("playdur").split("_");
				var gGetPlayDuring=parseInt(gGetPlayDuringarr[0]);
				var menuStatearr=playTask.split("\/");
				var menuState = (parseInt(menuStatearr[0]) >> 6) & 0x03;
				var playVol = $(clientInfo).attr("playvol");//获得当前的系统音量
				//var findex = "";
				var systemSound = "";
				var validValue = 0;
				var objValid = "";
				var objValid2 = "";
				var playState = $(clientInfo).attr("playstate");
				var playOrPause = "";
				var playStart = ""
				//每次切换屏幕时都会重新读取当时视频暂停/继续的状态
				if (playState != null && playState != undefined) {
				    playOrPause = playState.split("_");
				    playStart = playOrPause[0];
				}
				changPlayStatus(playStart);
				var arrayTask = "";
				var currentTask = ""
				if (playTask == undefined || playTask == "") {
				    arrayTask = "";
				} else {
				    arrayTask = playTask.split("/");
				    currentTask = arrayTask[1];//获得当前播放节目的id
				  
				    $(".left").eq(parseInt(currentTask)).find(".timeLong").css("color", "#d11b28d");
				}
				changPlayStatus(playStart);
				if (playVol != null && playVol != undefined && playVol != "") {
				    //findex = playVol.split("/");
				    objValid = playVol.split("/");
				    systemSound = objValid[0];
				    if (objValid.length > 1) {
				        objValid2 = objValid[1].split("_");
				        if (objValid2 != "" && objValid2.length > 1 && objValid2[1] == "1") {
				            validValue = 1;
				        }
				    }
				}
				if (true||(validValue == 1)) {
				    var nosoundVao = systemSound & 0x008000;//判断系统有没有静音
				    systemSound = systemSound & ~0x008000;
				    if (nosoundVao == 0x008000) {//判断当前系统是不是静音状态
				        $(".noSound").attr("src", "images/leftControl/noSound.png");
				    } else {
				        $(".noSound").attr("src", "images/leftControl/quanjuyinliangSelected.png");
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
				
				if(menuState!=oldmenuState){
					changeMenuState(menuState);
				}
				oldmenuState=menuState;
				$("#rangeRate1").attr("max",gGetPlayDuring);
				var strs=parseFloat($("#rangeRate1").css("width"));
				if (strs == NaN) {
				    strs = 0;
				}
				$("#rateProgressValue").html(secondToMinute((playProc1 / 10000) * strs));
				//$("#range").val(systemSound);
				//$("#value").html(systemSound);
				$("#range2").val(mplayVol);
				$("#value2").html(mplayVol);
				hideLoading();
			}
		});
	}
	
	sendding=false;
}
var tmpItem="";
//点击立即启动按钮
function startNow(thisItem,taskId,folder,parentId){	
	var winNum=parseInt($("#tabscreen").attr("nowwindow"));
	var itemType=$(thisItem).prev().attr("itemtype").split("-")[1].toLowerCase();
	if(changeSizeCommon(itemType)){
		if(folder==undefined){
			if(tmpItem==""){             
                docmd(16, taskId);
                docmd(winNum*10000+3085, 0);
            }else{
                docmd(16, taskId);
            } 
		}else{
			if(tmpItem==""){
                docmd(16, parentId);
                docmd(winNum*10000+3085, 0);
            }else{
                docmd(16, parentId);
            }  
            docmd(3079+10000*winNum,taskId);
		}
	}else{
		if(folder==undefined){
			if ($("#div1").attr("class")=="open1") {
				docmd(67, taskId);
			} else {
				docmd(16, taskId);
			}
		}else{
			if($("#div1").attr("class")=="open1"){
				docmd(67,parentId);
			}else{
				docmd(16,parentId);
			}
			docmd(3079+10000*parseInt($("#tabscreen").attr("nowwindow")),taskId);
		}
	}	
	tmpItem="";
}
function changeStyle2(){
	if(document.documentElement.clientHeight<900){
		$(".bgSpan").css("width","5%");
		$(".bgSpan").css("height",$(".topMain .programList .left").width()*0.05+"px");
	}else{
		$(".bgSpan").css("width","9%");
		$(".bgSpan").css("height",$(".topMain .programList .left").width()*0.09+"px");
	}	
	var leftListH=$(".leftList").height();
	var leftListspanH=$(".leftList span").height();
	var listImg=$(".leftList img").height();
	var imgLin=(leftListH-listImg)/2;
	var spanImgH=$(".topMain .programList .left .bgSpan").height();
	var spanMargin=(leftListH-spanImgH)/2;
	var bottomH=$(".bottom").height();
	var leftSpanW=$(".topMain .programList .left .leftList").width()*0.78;
	var functionImgH=($(".bottom").width())*0.05;
	var startH=($(".bottom").width())*0.06;
	liSpanH=$(".controlBottomTab li span").height();
	bH=$(".controlBottomTab li b").height();
	$(".topMain .programList .left .leftList span").css("width",leftSpanW);
	$("#functionButton .image").css("marginTop",(bottomH-functionImgH)/2);
	$(".controlBottomTab li b").css("marginTop",(bottomH-liSpanH-bH)/2);
	var bottomImgH=$(".pictures").height();
	var downFileH=$(".downFile b").height();
	$(".bottom .fileName").css("lineHeight",bottomH+"px");
	$(".pictures").css("marginTop",(bottomH-bottomImgH)/2);
	$(".leftList span").css("paddingTop",(leftListH-leftListspanH)/2);
	$(".leftList span").css("paddingBottom",(leftListH-leftListspanH)/2);
	$(".downFile b").css("marginTop",(bottomH-downFileH)/2);
	
	$(".topMain .programList .left .bgSpan").css("marginTop",spanMargin);
	$("#functionButton .start").css("marginTop",(bottomH-startH)/2);
	$(".programFileName").css("lineHeight",$(".programFileName").height()+"px");
	$(".leftList>span").click(function(){
		//点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
		//节目项控制和全局控制的内容也得到相应的改变
		$(".leftList span").css("background","#fff");
		$(".leftList .programFileName").css("color","#000");
		$(".leftList .timeLong").css("color", "#999");
		$(".topMain .programList .left:even").find(".leftList span").css("background", "#c9ecfe");
		$(this).parent().addClass("current");
		$(this).parents().siblings().find(".leftList").removeClass("current");		
		$(".leftList").css("background","");
		$(this).css("background","#06afe8");
		$(this).find("span").css("background","#06afe8");
		$(this).find("p").css("color","#fff");
	   
		var url=$("#tabscreen").attr("src");
		//对当前的节目点击下载按钮
		var downLink=$(".current").attr("downLink");
		//如果节目是存储在本地，需要在连接前添加$$符号
		//以下是用"\\"进行本地文件和线上文件的区分
		if(downLink.indexOf("\\")<0){
		}else{
			downLink="$$"+downLink;
		}
		//将文件的地址转换成线上能运行的地址，同时在地址前增加当前获取数据的显示端地址，来得到一个新的地址。
		href=url+"/"+downLink;//预览
		var arry=href.split("\\");
		downLoadArry=arry[arry.length-1];//此时声明成全局变量是为了接下来在拼接字符串的时候用到这个值，预览的变量同此变量
		//在文件名前加onlydownload,系统就会自动识别为当前的文件为下载文件。
		downLoadArry="onlydownload_\\"+downLoadArry;
		arry[arry.length-1]=downLoadArry;
		hrefDownLoad=arry.join('\\');
		//预览当前文件只需要在预览的按钮添加一个href,href的值为上面所提到的新的组合的地址。
		$("#checkFile").attr("href1",href);
		$("#downLoad").attr("href",hrefDownLoad);
		$(".start").attr("src", "images/bottomPlay/tingzhi.png");
	})
}
//对动态加载进来的数据进行样式的修改
function changeStyle(){	
	changeStyle2();
	//点击当前列表的立即播放按钮，则当前列表的样式跟着改变，焦点定位到当前的点击的列表行
	$(".leftList .startNow .startNowImg").click(function(){
		//点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
	  //节目项控制和全局控制的内容也得到相应的改变
	  $(".leftList span").css("background","#fff");
	  $(".leftList .programFileName").css("color","#000");
	  $(".leftList .timeLong").css("color", "#999");
	  $(".topMain .programList .left:nth-child(2n+1)").find(".leftList span").css("background", "#c9ecfe");
	  $(this).parent().parent().addClass("current");
	  $(this).parent().prev().click();
	  $(this).parents().siblings().find(".leftList").removeClass("current");
	 
	  $(".leftList").css("background","");
	  $(this).parent().parent().find("span").css("background","#06afe8");
	  $(this).parent().parent().find("span p").css("color","#fff");
	  
	  var url=$("#tabscreen").attr("src");
	  //对当前的节目点击下载按钮
	  var downLink=$(".current").attr("downLink");
	  //如果节目是存储在本地，需要在连接前添加$$符号
	  //以下是用"\\"进行本地文件和线上文件的区分
	  if(downLink.indexOf("\\")<0){
	  }else{
		  downLink="$$"+downLink;
	  }
	  //将文件的地址转换成线上能运行的地址，同时在地址前增加当前获取数据的显示端地址，来得到一个新的地址。
	  href=url+"/"+downLink;
	  var arry=href.split("\\");
	  downLoadArry=arry[arry.length-1];
	  //在文件名前加onlydownload,系统就会自动识别为当前的文件为下载文件。
	  downLoadArry="onlydownload_\\"+downLoadArry;
	  arry[arry.length-1]=downLoadArry;
	  hrefDownLoad=arry.join('\\');
	  //预览当前文件只需要在预览的按钮添加一个href,href的值为上面所提到的新的组合的地址。
	  $("#checkFile").attr("href1",href);
	  $("#downLoad").attr("href",hrefDownLoad);
	  $(".start").attr("src", "images/bottomPlay/tingzhi.png");
	});
	changeStyle3();
}
function getClickMore(thisList){
	if($(".folderList").length<=0){
		getFileFolder(thisList,$(thisList).parent().parent().attr("downlink"),$(thisList).parent().parent().attr("itemtype"));		
   }
   if($(thisList).parent().parent().attr("itemtype").indexOf("14")>=0|| $(thisList).parent().parent().attr("itemtype").indexOf("1014")>=0){
	  
		for (var i = 0; i < $(".programList .left").length; i++) {
			if ($(".left").eq(i).attr("columid") == $(thisList).parent().parent().parent().attr("taskid")) {
				if ($(".programList .left").eq(i).find(".leftList").attr("itemtype").indexOf("14")<0&& $(".programList .left").eq(i).find(".leftList").attr("itemtype").indexOf("1014")<0) {
					if ($(".programList .left").eq(i).css("display") == "none") {
						$(".programList .left").eq(i).slideDown("slow");
						$(thisList).attr("src", "images/contentTab/gengduoex1.png");
					} else {
						$(".programList .left").eq(i).slideUp("slow");
						$(thisList).attr("src", "images/contentTab/gengduoex.png");
					}
				}
			}
			
		}
	}else{
		if($(thisList).parent().parent().attr("downlink").slice($(thisList).parent().parent().attr("downlink").length-1).indexOf("\\")>=0){
			if($(".folderList").length<=0){
				$(thisList).attr("src", "images/contentTab/gengduoex1.png");
				setTimeout(function(){
					if($(".folderList").css("display")=="none"){							
						$(".folderList").slideDown("slow");						
					}else{
						$(".folderList").slideUp("slow");
						$(thisList).attr("src", "images/contentTab/gengduoex.png");
					}
				},1000);
			}else{
				if($(".folderList").css("display")=="none"){
					$(".folderList").slideDown("slow");
					$(thisList).attr("src", "images/contentTab/gengduoex1.png");
				}else{
					$(".folderList").slideUp("slow");
					$(thisList).attr("src", "images/contentTab/gengduoex.png");
				}
			}	
		}
	}
}
function changeStyle3(){
//点击全屏播放时，当前的行的样式跟随改变
	$(".bigScreen").click(function(){
		//点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
		//节目项控制和全局控制的内容也得到相应的改变
		$(".leftList span").css("background","#fff");
		$(".leftList .programFileName").css("color","#000");
		$(".leftList .timeLong").css("color","#999");
		$(".leftList").removeClass("current");
		$(".topMain .programList .left:nth-child(4n+1)").find(".leftList span").css("background", "#c9ecfe");
		$(this).parent().next().addClass("current");
		$(this).parent().next().find("span").css("background","#06afe8");
		$(this).parent().next().find("span p").css("color","#fff");
		
		var url=$("#tabscreen").attr("src");
		//对当前的节目点击下载按钮
		var downLink=$(this).parent().next().attr("downLink");
		//如果节目是存储在本地，需要在连接前添加$$符号
		//以下是用"\\"进行本地文件和线上文件的区分
		if(downLink.indexOf("\\")<0){
		}else{
			downLink="$$"+downLink;
		}
		//将文件的地址转换成线上能运行的地址，同时在地址前增加当前获取数据的显示端地址，来得到一个新的地址。
		href=url+"/"+downLink;
		var arry=href.split("\\");
		downLoadArry=arry[arry.length-1];
		//在文件名前加onlydownload,系统就会自动识别为当前的文件为下载文件。
		downLoadArry="onlydownload_\\"+downLoadArry;
		arry[arry.length-1]=downLoadArry;
		hrefDownLoad=arry.join('\\');
		//预览当前文件只需要在预览的按钮添加一个href,href的值为上面所提到的新的组合的地址。
		$("#checkFile").attr("href1",href);
		$("#downLoad").attr("href",hrefDownLoad);
		$(".start").attr("src", "images/bottomPlay/tingzhi.png");
	// getData(newurl);
	})
	if(screenWidth1>=1000){
		$(".leftList").css("width","92%");
		$(".startNow").css("width", "9%");
		$(".leftList span").css("width", "86%")
		$(".startNow .startNowImg").css("width","2.5rem");
		$(".startNow .startNowImg").css("height","2.5rem");
		$(".topMain .programList .left").css("height", "12%");
		$(".cc").css("height", "16%");
		
	}else{
		$(".leftList").css("width","88%");
		$(".startNow").css("width", "9%");
		$(".leftList span").css("width","88%")
		$(".startNow .startNowImg").css("width","1.5rem");
		$(".startNow .startNowImg").css("height", "1.5rem");
		$(".topMain .programList .left").css("height", "10%");
		$(".cc").css("height", "13%");		
	}
	$(".cc").find("b").css("marginTop", (parseInt($(".cc").css("height")) - 28) / 2);
	
	$(".programFileName").css("marginTop", ($(".leftList span").height() - $(".programFileName").height() - 5 - $(".timeLong").height()) / 2);
}
//判断当前的列表是那种类型，根据当前的类型显示不同的操作按钮
function showCtrlBar(barID, taskID, itemtype, thisList) {
	//点击当前节目项时，增加甩屏操作
	//alert(111);
	itemtype=parseInt(itemtype.split("-")[0]);
	var flag = 0;
	var downLink = "";
	rateLeft = 0
	//getRate(newurl);
	// var imageUrl=$(".left").find(".leftList[taskId='"+taskID+"']").prev(".bgSpan").find("img").attr("src");
	// var fileName=$(".left").find(".leftList[taskId='"+taskID+"']").children("span").find("p").eq(0).text();
	// downLink=$(".left").find(".leftList[taskId='"+taskID+"']").attr("downlink");
	var imageUrl=$(thisList).parent().prev(".bgSpan").find("img").attr("src");
	var fileName=$(thisList).find(".programFileName").text();
    downLink = $(".left").find(".leftList[taskId='" + taskID + "']").attr("downlink");
	var nowWindow=$(".left").find(".leftList[taskId='"+taskID+"']").attr("windowsNum");
	$("#tabscreen").attr("nowWindow",nowWindow);
	$("#functionButton .images").attr("src", imageUrl);
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
	//音视频 音视频的时候需要调用websocket 因为需要一直向wiseSendInfo访问进度的数据
	//所以需要启动轮询，但是如果当前的节目项不是音视频，则为了防止多次请求数据，造成资源浪费，停止轮询
	if (itemtype == 10 || itemtype == 1010 || itemtype == 9 || itemtype == 1009 || itemtype == 7 || itemtype==1007)
    {	clearInterval(timer);
		var playOrPause=$("thisList").attr("playStatus");
		changPlayStatus(playOrPause);
		$(".picture").css("display","none");
		$(".ppt").css("display","none");
		$(".musicOrVideo").css("display","block");
		$("#functionButton .fileName1").html(fileName);
		$("#functionButton .fileName1").css("text-align","left");
		var bottomH1=$(".bottom").height();
		var rateH=$("#rateProgress").height();
		var fil1H=$(".fileName1").height();
		var bottomH = $(".bottom").height();
		var range1 = $("#rangeRate1").height();
		var imageMargin=(bottomH1-liSpanH-bH)/2;
	    //$(".showRate").css("marginTop", (bottomH1 - rateH - fil1H - 20) / 2);
		$(".showRate").css("marginTop", (bottomH1 - range1 - fil1H - 20) / 2);
		var str1 = videoStr(hrefDownLoad, href, imageMargin);
		$(".musicOrVideo a").parent().remove();
		$(".musicOrVideo ul").append(str1);
		timer=setInterval("getRate(newurl)",1000);
    }
	else if (itemtype == 8 || itemtype == 1008)//office文档
	{
	    //判断office文件中只有含有ppt和pptx才是ppt文件，其他的不做ppt处理
	    if (downLink != null && (fileName.indexOf(".ppt") >= 0 || fileName.indexOf(".pptx") >= 0 || fileName.indexOf(".pps") >= 0 || fileName.indexOf(".ppsx") >= 0))
	    {
	        clearInterval(timer);
	        $(".picture").css("display","none");
	        $(".musicOrVideo").css("display","none");
	        $(".ppt").css("display","block");
			
	        $("#functionButton .fileName").html(fileName);
	        var bottomH=$(".bottom").height();
	        var imageMargin = (bottomH - liSpanH - bH) / 2;
	        var str3 = pptStr(hrefDownLoad, href, imageMargin);
	        $(".ppt a").parent().remove();
	        $(".ppt ul").append(str3);
	    }else{//除了ppt和pptx的office文档当做图类型处理片
	        clearInterval(timer);
	        $(".musicOrVideo").css("display","none");
	        $(".ppt").css("display","none");
	        $(".picture").css("display","block");
	        $("#functionButton .fileName").html(fileName);
	        var bottomH=$(".bottom").height();
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
	}else{//其他的所有格式都当做图片进行处理
	    	clearInterval(timer);
	    	$(".musicOrVideo").css("display","none");
	    	$(".ppt").css("display","none");
	    	$(".picture").css("display","block");
	    	$("#functionButton .fileName").html(fileName);
	    	var bottomH=$(".bottom").height();
	    	var imageMargin=(bottomH-liSpanH-bH)/2;
	    	var str = picStr(hrefDownLoad, href, imageMargin);
	    	$(".picture a").parent().remove();
	    	$(".picture ul").append(str);
	}
	if(document.documentElement.clientWidth>=1000){
		
		$(".controlBottomTab li b").css("width","50%");
	}else{
		$(".controlBottomTab li b").css("width","90%");
		
	}
	$(".images").css("width",$(".bottom").height()*0.6+"px");
	// if($("#div1").attr("class")=="open1"){
	// 	$(".startUp").attr("onclick","docmd(67,'"+taskID+"')");//跳转到当前任务
	// }else{
	// 	$(".startUp").attr("onclick","docmd(16,'"+taskID+"')");//跳转到当前任务
	// }
	// $(".startUp").removeAttr("onclick");
	// $(".startUp").attr("onclick", "startNow('"+taskID+"','1','"+$(thisList).parent().attr("parentid")+"')");
	$(".startUp").removeAttr("onclick");
	$(".startUp").click(function(){
        $(".current .startNow .startNowImg").click();
    })

	$(".pause").attr("onclick", "docmd(70,'0')");
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
//发送指令函数
function docmd(cmdtype, cmdData) {
	showLoading();
    var screenType = cmdData;
    if ($(".slider").attr("allscreen") == "open") {
        screenType = 3;
    } else {
        screenType = 0;
    }
	var url=$("#tabscreen").attr("src");
	var cmdType = "" + (parseInt($("#tabscreen").attr("nowWindow")) * 10000 + parseInt(cmdtype)) + "";
	var sendcmdurl=url+"/wpsendclientmsg.asp?rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	if(!isNaN(cmdtype)){//执行显示端命令
		cmdstr=cmdtype+"_"+cmdData;
		$.ajax({
		data:{wpsendclientmsg:cmdstr},
		url: sendcmdurl,
		dataType:'html',
		type: 'GET',
		timeout: 15000,		//超时时间
		error:function(xml){
			hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")));
			
		},
		success:function(xml){
			hideLoading();
			if(xml){
				if(xml.indexOf("501")>=0){
					topTrip("平板操控功能为授权！");
				}else{
					if (cmdType.indexOf("3009") < 0 && cmdType.indexOf("29") < 0 && cmdType.indexOf("3001") < 0) {
			       
						topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")));
			       
					}
				}
				
			}
			
		}
		});
	}
	if(cmdtype=="keycode"){//发送键盘动作
	    if (cmdData.indexOf("-keyevent") >= 0) {
			;
		}else{
			cmdData="-keyevent "+cmdData;
		}
		$.ajax({
			data:{wpsendkeys:cmdData},
			url: sendcmdurl,
			dataType:'html',
			type: 'GET',
			timeout: 5000,		//超时时间
			error: function (xml) {
				hideLoading();
					//timeShowMsg("title","发送失败",500);		//失败报错
			    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
				},
			success: function (xml) {
				hideLoading();
				if(xml){
					if(xml.indexOf("501")>=0){
						topTrip("平板操控功能为授权！");
					}else{
						topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
					}
				}
			}
		});
	}
	//点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
	if(cmdtype==13){
	var ele=$(".current").parent().next().next();
	ele.find(".leftList").addClass("current").find("img").click();
	ele.prev().find(".leftList").removeClass('current');
	}
	if(cmdtype==12){
		$(".leftList").removeClass('current');
		$(".leftList").eq(0).addClass("current").find("img").click();
	}
	if(cmdtype==15){
		$(".leftList").removeClass('current');
		$(".leftList").eq($(".leftList").length-1).addClass("current").find("img").click();
	}
	if(cmdtype==14){
		var ele=$(".current").parent().prev().prev();
		ele.find(".leftList").addClass("current").find("img").click();
		ele.next().find(".leftList").removeClass('current');
	}if(cmdType.indexOf("3009")>=0){
		
		timer=setInterval("getRate(newurl)",1000);
	}	
	if(cmdtype==70){
		clearInterval(timer);//停止节目单时，清除轮询，不再占用资源
	}
	if(cmdtype==16){
    }
    if (cmdtype == "before") {
        var ele = $(".current").parent().prev().prev();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.next().find(".leftList").removeClass('current');
    }
    if (cmdtype == "next") {
        var ele = $(".current").parent().next().next();
        ele.find(".leftList").addClass("current").find("img").click();
        ele.prev().find(".leftList").removeClass('current');
    }
	
}

//发送指令函数 当前是当启动了全屏播放后所发送的指令函数
function docmd1(cmdtype, cmdData) {
	showLoading();
    var screenType = cmdData;
    if ($(".slider").attr("allscreen") == "open") {
        screenType = 3;
    } else {
        screenType = 0;
    }
    var url = $("#tabscreen").attr("src");
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
			error: function (xml) {
				hideLoading();
                //timeShowMsg("title","发送失败",500);		//失败报错
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            },
			success: function (xml) {
				hideLoading();
                if (xml) {
					if(xml.indexOf("501")>=0){
						topTrip("平板操控功能为授权！");
					}else{
						 //timeShowMsg("title","发送成功",500);		//发送成功
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
			error: function (xml) {
				hideLoading();
                //timeShowMsg("title","发送失败",500);		//失败报错
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            },
			success: function (xml) {
				hideLoading();
                if (xml) {
					 //timeShowMsg("title","发送成功",500);		//发送成功
                    if (cmdType.indexOf("3009") < 0 && cmdType.indexOf("29") < 0 && cmdType.indexOf("3001") < 0) {
                        
                        topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                    }else{
						//timeShowMsg("title","发送成功",500);		//发送成功
						topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
					}
                    

                }
            }
        });
    }
    //点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
    if (cmdtype == 13) {
        var ele = $(".current").parent().next().next();
        ele.find(".leftList").addClass("current").find("img").click();
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
		var ele = $(".current").parent().prev().prev();
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
		var ele = $(".current").parent().prev().prev();
		tmpItem="before";
		if(ele.length!=0){
			ele.find(".leftList").addClass("current").find("img").click();
			ele.next().find(".leftList").removeClass('current');
		}
       else{
		hideLoading();
	   }
    }
    if (cmdtype == "next") {
		var ele = $(".current").parent().next().next();
		tmpItem="next";
		if(ele.length!=0){
			ele.find(".leftList").addClass("current").find("img").click();
			ele.prev().find(".leftList").removeClass('current');
		}else{
			hideLoading();
		}  
    }
}
//拖动滑动条获取到相应的值(素材音量)
function change(rangex, valuex) {
	coundFlag = 2;
	if ($("#tabscreen").attr("nowwindow") == undefined) {
		$("#tabscreen").attr("nowwindow", "0");
	}
	if (rangex == "range") {
		var value = document.getElementById(rangex).value;
		var nw = parseInt($("#tabscreen").attr("nowwindow"));
		document.getElementById(valuex).innerHTML = value;
		if (document.getElementById('range').value == "0") {
			$(".noSound").attr("src", "images/leftControl/noSound.png")
		} else {
			$(".noSound").attr("src", "images/leftControl/quanjuyinliangSelected.png")
		}
		docmd(29, getSoundNumSlip(document.getElementById(rangex).value));
	} else {
		var value = document.getElementById(rangex).value;
		var nw = parseInt($("#tabscreen").attr("nowwindow"));
		document.getElementById(valuex).innerHTML = value;
		docmd(nw * 10000 + 3001, getSoundNumSlip(document.getElementById(rangex).value));
	} 
}
//毫秒转化成分钟
function secondToMinute(num){
	var num1=0;
	var num2=0
	num=num/1000;
	if(num>=60){
		num1=parseInt(num/60);
		num2=parseInt(num%60);
		
	}else{
		num2=parseInt(num%60);
	}
	num=fillTime(num1)+":"+fillTime(num2);
	return num;
}
//时间格式填充
function fillTime(num){
	if(num<10){
		num="0"+num;
	}else{
		num=num;
	}
	return num;
}

//淡入淡出
function getSoundNumSlip(num){
	num=parseFloat(num);
	tempnum=num;
	if(tempnum<=0){tempnum=0;}
	if(tempnum>=255){tempnum=255;}
	return tempnum;
}
//获取终端频道信息函数
function getChannelList() {
	showLoading();
	var channelListUrl=$("#tabscreen").attr("src");
	var url=channelListUrl+"/wpgetxmlids.asp?utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	$.ajax({
		data:{gettype:"channel"},
		url: url,
		dataType: 'xml',
		type: 'GET',		//提交方式
		timeout: 15000,		//失败时间
		error: function(xml)
		{
			hideLoading();
			$("#title").text("获取频道出错!");
			$("#pic img").attr("src", "images/fail1.png");
			
		},
		success: function(xml)
		{
			//下拉列表的第一项为当前正在播放的节目单，剩下的节目单按照正常的顺序显示
			$("#pic img").attr("src", "images/success1.png");
			
			var channels=$(xml).find("channel");
			var raius="10px 10px 0px 0px";
			$("#channelList").html("");
			$("#ulChannelList").html("");
			channels.each(function(index, element) {
				var name,path,desc;
				name=$(this).find("name").text();
				path=$(this).find("path").text();
				desc = $(this).find("desc").text();	
				if($("#menuPath").val()==path){
				    $("#channelList").append("<option value='" + name + "' selected>" + name + "</option>");
				    $("#ulChannelList").append("<li onclick='changinputvalue(this)'>"+ name +"</li>");
				}else{
				    $("#channelList").append("<option value='" + name + "'>" + name + "</option>");
				    $("#ulChannelList").append("<li onclick='changinputvalue(this)'>" + name + "</li>");
				}
				$("#changeChannel").css("borderRadius","10px");
				if(count%2==0){
					$("#changeChannel").css("borderRadius","10px");
				}else{
					$("#changeChannel").css("borderRadius",raius);
					$("#channelBar").css("borderRadius","0px 0px 10px 10px");
				}
			});
			$("#inpurChannelValue").val($("#channelList").val());
			hideLoading();
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
	showLoading();
    var valueName = $("#inpurChannelValue").val();
		valueName=valueName.split("[");
		valueName="*["+valueName[1]+"11";
	var str='';
	var indexNumber = $("#tabscreen").attr("indexnumber");
	for(var i=0;i<$(".cc").length;i++){
		
	    str += $(".cc").eq(i).attr("clientname") + ";"
	}
	$.ajax({
		url:"wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=73&companyid=wisepeak&utf8=1&cnlist="+str+"&commandparam="+valueName+"&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
		dataType:"text",
		type:"GET",
		success:function(data){
			if (data) {
				hideLoading();
				//timeShowMsg("title","发送成功",500);		//发送成功
			    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
				getData(newurl,indexNumber);
			}
		}, error: function (data) {
			hideLoading();
			//timeShowMsg("title","发送失败",500);		//发送失败
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
	})
}
function allClientChannelHand() {
	showLoading();
    var valueName = $("#inpurChannelValue").val();
		valueName=valueName.split("[");
		valueName="*["+valueName[1]+"69";
	var str = '';
	var indexNumber = $("#tabscreen").attr("indexnumber");
	for(var i=0;i<$(".cc").length;i++){
		
	    str += $(".cc").eq(i).attr("clientname") + ";"
	}
	$.ajax({
		url:"wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=73&companyid=wisepeak&utf8=1&cnlist="+str+"&commandparam="+valueName+"&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
		dataType:"text",
		type:"GET",
		success: function (data) {
			hideLoading();
			if(data){

				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
				getData(newurl, indexNumber);
			}
		}, error: function (xml) {
			hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
	})
	
}
function changeTab(id){ //切换Tab内容
    $(".bar").slideUp(100);
    if (slidebar == 0 && id == "bar2") {
        ;
    } else {
        $("#" + id).slideDown(500);
    }
	
}
//控制灯颜色
function lightChange(url, obj) {
   
	//var index=$("#bar1 .cmdBar .sendCmd").index(obj);
    var index = $("#lightChangeColor .sendCmd").index(obj);
	if(index==0){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
	}
	if (index == 1) {
	    
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#e8072c");
		$(obj).css("color","#fff");
	}else if(index==2){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#06e860");
		$(obj).css("color","#fff");
	}else if(index==3){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#074ae8");
		$(obj).css("color","#fff");
	}else if(index==4){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#e8e807");
		$(obj).css("color","#fff");
	}else if(index==5){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#c307e8");
		$(obj).css("color","#fff");
	}else if(index==6){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#07e8e8");
		$(obj).css("color","#fff");
	}else if(index==7){
        $("#lightChangeColor .sendCmd").css("background","#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color","#999");
		$(obj).css("background","#fff");
		$(obj).css("color","#000");
	}
	var url1=newurl+"/wpcontrolcomm.asp?wpcontrolcomm=";
		$.get(url1+url);
}
//对系统的应用功能按钮发送指令
function getUrl(url) {
	showLoading();
	url=$("#tabscreen").attr("src")+"/"+url+"&utf8=1";
	$.ajax({
		data:{rnd:(Math.floor(Math.random()*(9999-1000))+1000)},
		url: url,
		dataType:'html',
		type: 'GET',
		timeout: 15000,		//超时时间
		error: function (xml) {
			hideLoading();
			topTrip("发送失败",2);
		},
		success: function (xml) {
			hideLoading();
			if(xml){
				
			    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
			}
		}
	});
}
//文件预览，图片除外
function checkFile(){
    var fileSrc = $("#checkFile").attr("href1");
    $("#checkFile").attr("href1", fileSrc);
    window.open(fileSrc, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400, height=400");

}
//当屏幕分辨率改变时，自动刷新页面，防止页面混乱
function refreshScreen(){
	var nowWidth=document.documentElement.clientWidth;
	if (Math.abs(nowWidth - screenWidth1) >= 10) {
		window.location.reload();
		screenWidth1=nowWidth;
	}
}
//关机、重启都调用函数 关机时向终端和控制端都发送指令，防止向终端发送指令是不能关机
function powerOff(clientNum) {
	if ($(".topConfirm").attr("messageTip") == "ok") {
		showLoading();
        var clintName = $("#top").attr("clientname");
        var errorURL = $("#tabscreen").attr("src");
        $.ajax({
            url: errorURL + "/wpsendclientmsg.asp?wpsendclientmsg=" + clientNum + "_"+(1000+parseInt(clientNum))+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'xml',
            type: 'GET',
			success: function (data) {
				hideLoading();
                //timeShowMsg("title","发送成功",500)
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
			error: function (data) {
				hideLoading();
                //timeShowMsg("title","发送失败",500)
                topTrip(getLanguageMsg("发送失败功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            }
        })

        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + clintName + ";&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'text',
            type: 'GET',
			success: function (data) {
				hideLoading();
                //timeShowMsg("title","发送成功",500);
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
			error: function (data) {
				hideLoading();
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
//开机，开机时向控制室端发送两条指令，若第一条指令发送失败不能开机，则向显示端再发送一条
function powerOn() {
	showLoading();
	var clintName=$("#title").text();
	var ClientName = clintName;
	var errorip = $("#tabscreen").attr("src");
	var errorIp = errorip.split("//");
	errorIp = errorIp[1].split(":");
	errorIp = errorIp[0];
	var errorMac = $("#tabscreen").attr("macname");
	var errorStr = "-f " + errorIp + ":" + errorMac + ";";
	//if ($(".topConfirm").attr("messageTip") == "ok") {
	    $.ajax({
	        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + ClientName + ";&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	        dataType: 'text',
	        type: 'GET',
			success: function (data) {
				hideLoading();
	            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
	            $(".topConfirm").attr("messageTip", "");
	        },
	        error: function (data) {
	          
	            $.ajax({
	                url: "wpcontrolcenter.asp?wpcontrolcenter=Turn-On TV&maintype=6&subtype=0&companyid=wisepeak&utf8=1&dohere=1&cnlist=noneed&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	                dataType: 'text',
	                type: 'GET',
					success: function (data) {
						hideLoading();
	                    //timeShowMsg("title","发送成功",500)
	                    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
	                    $(".topConfirm").attr("messageTip", "");
	                },
	                error: function (data, XMLHttpRequest, textStatus, errorThrown) {
						//timeShowMsg("title","发送失败",500);
						hideLoading();
	                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 1);
	                    $(".topConfirm").attr("messageTip", "");
	                }
	            })
	        }
	    })
	//} else {
	//    tipMessage("确定要开机吗?", "powerOn");
	//}    
}

//向下滑动页面刷新
function update(content,way){  
    var _start = 0,   
        _end = 0,   
        _content = $(content)[0]; 
	var slideTop=document.getElementById('Screen').scrollTop; 
	var ua = navigator.userAgent.toLowerCase(); 
	if(slideTop<=0){
		_content.addEventListener("touchstart",touchStart,false);   
		_content.addEventListener("touchmove",touchMove,false);   
		_content.addEventListener("touchend",touchEnd,false);  
		$('<div class="update">松开刷新</div>').prependTo($("body"));  
		$(".update").css({"fontSize":"14px","text-align":"center","padding":"10px"});  
		$(".update").hide();  
	}else{
		$(_content).on('touchstart',touchStart);
		$(_content).on('touchmove',touchMove);
		$(_content).on('touchend',touchEnd);
	}
    function touchStart(event){    
        var touch = event.targetTouches[0];   
        if(way == "x"){    
            _start = touch.pageX;   
        }else{    
            _start = touch.pageY;   
        }  
    }   
    function touchMove(event){    
        var touch = event.targetTouches[0];   
        if(way == "x"){    
            _end = (_start - touch.pageX);   
        }else{    
            _end = (_start - touch.pageY);   
            //下滑才执行操作  
			if(/iphone|ipad|ipod/.test(ua)) { 
				if(_end < -150&&$(document).scrollTop()<0){   
				   $(".update").height((30-_end)+"px")  
				   $(".update").show();                 
	  
				} 
			}else{
				if(_end < -150&&$(document).scrollTop()==0){   
				   $(".update").height((30-_end)+"px")  
				   $(".update").show();                 
	  
				}           
			}
        }   
  
    }   
    function touchEnd(event){ 
	if(/iphone|ipad|ipod/.test(ua)) { 
        if(parseInt(_end) >0){    
        }else if(parseInt(_end)<-150&&$(document).scrollTop()<0){     
            $(".update").text("正在刷新");  
            $(".update").height("30px")  
            location.reload();    
            //刷新成功则   
            //模拟刷新成功进入第三步   
            setTimeout(function(){    
               // slideDownStep3();   
                 $(".update").remove();  
            },2500);   
        } 
	}else{
		if(parseInt(_end) >0){    
        }else if(parseInt(_end)<-150&&$(document).scrollTop()==0){    
            $(".update").text("正在刷新");  
            $(".update").height("30px")  
            location.reload();     
            //刷新成功则   
            //模拟刷新成功进入第三步   
            setTimeout(function(){       
            	$(".update").remove();  
            },2500);   
        } 
	}
    }   
}

//创建模拟鼠标长连接，此处将两个长连接分开，目的是让两个实现的过程互不影响
function connectTouchStart(moveX,moveY){
    var hosturl = "";
    if (newurl == "") {
        hosturl = window.location.href.split("//")[1].split("/")[0];
    } else {
        hosturl = newurl.split("//")[1];
    }
	var host = "ws://"+hosturl+"/"+targeturlhead+"129_"+moveX+"_"+moveY;//"/wpgetxmlids.asp?gettype=9&rnd="+Math.random(99999999);
	try{
		if(socket1==null||socket1.readyState!=1){//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
			if (socket1!=null){					//3-连接已经关闭或者根本没有建立;0-正在连接
				delete socket1;
			}
			socket1 = new WebSocket(host);//建立一个WebSocket
			if(socket1!=null){
				dragStartjt=true;
				dragStart1=true;
			}
		}
		socket1.onopen = function(){//建立连接
			//console.log("Connection established");
		}
		socket1.onmessage = function(data){//接收送服务器端返回的数据
			//console.log(data);
		}
		
		socket1.onclose = function(){
			//console.log("WebSocket closed!");
		}			
			
	} catch(exception){
		//console.log(exception);
	}		
}
//手动刷新截图
function freshCanvas(){
	drawImage(0);
	$(".minusImageSize").attr("src","images/allTitle/minus.png");
	$(".addImageSize").attr("src","images/allTitle/addSize.png");
	clearInterval(freshTime);
	$(".autoFresh input").attr("checked",false);
}
//自动刷新截图
function automaticfreshCanvas(num){
	clearInterval(freshTime);
	freshTime=setInterval("drawImage()",parseInt(num)*1000);
	
}
//创建长连接，该部分的长连接主要用于音视频的进度条
var rateLeft=0;
function connect() {
    var hosturl = "";
    if (newurl == "") {
        hosturl=window.location.href.split("//")[1].split("/")[0];
    }else{
        hosturl=newurl.split("//")[1];
    }
        
    var host = "ws://" + hosturl + "/wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow"))+"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	try{
		if(socket==null||socket.readyState!=1){//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
			if (socket!=null){					//3-连接已经关闭或者根本没有建立;0-正在连接
				delete socket;
			}
			socket = new WebSocket(host);//建立一个WebSocket
		}
		
		socket.onopen = function(){//建立连接
		}
		socket.onmessage = function(data){//接收送服务器端返回的数据
			$("#functionButton").css("display","block");
			//每次请求成功后都将之前所获得的播放列表的数据清除
			timeFlag--;
			if (soundFlag > 0) {
			    soundFlag--;
			}
			
			$("#Screen").attr("align","left");  
			var clientInfo=$($(data.data)[2]).find("clientInfo");//获得终端信息标签
			if(clientInfo==null){
				return;
			}    	
			var playProc=clientInfo.attr("playproc").split("_");
			var playProc1 = playProc = parseInt(playProc[0]);
			console.log(parseInt(clientInfo.attr("playproc").split("_")[1]));
			var playTask=clientInfo.attr("playtask");
			var gGetPlayDuringarr=clientInfo.attr("playdur").split("_");
			var gGetPlayDuring=parseInt(gGetPlayDuringarr[0]);
			var menuStatearr=playTask.split("\/");
			var menuState = (parseInt(menuStatearr[0]) >> 6) & 0x03;

			var playVol = $(clientInfo).attr("playVol");//获得当前的系统音量
			//var findex = "";
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
			changPlayStatus(playStart);
            $("#rangeRate1").attr("max", gGetPlayDuring);
			var arrayTask = "";
			var currentTask = ""
			if (playTask == undefined || playTask == "") {
			    arrayTask = "";
			} else {
			    arrayTask = playTask.split("/");
			    currentTask = arrayTask[1];//获得当前播放节目的id
			   
			    $(".left").eq(parseInt(currentTask)).find(".timeLong").css("color", "#d11b28");
			}
			changPlayStatus(playStart);
			if (playVol != null && playVol != undefined && playVol != "") {
			    //findex = playVol.split("/");
			    objValid = playVol.split("/");
			    systemSound = objValid[0];
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
			        $(".noSound").attr("src", "images/leftControl/noSound.png");
			    } else {
			        $(".noSound").attr("src", "images/leftControl/quanjuyinliangSelected.png");
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
			screenWidth=parseInt(clientInfo.attr("scrRate").split("_")[0]);
			screenHeight=parseInt(clientInfo.attr("scrRate").split("_")[1]);
			if(menuState!=oldmenuState){
				changeMenuState(menuState);
			}
			oldmenuState=menuState;
			
			var reteWidth=parseFloat($("#rangeRate1").css("width"))-parseInt($("#rangeRate2").css("width"));
			var strs=parseFloat($("#rangeRate1").attr("max"));
			
			var dddty=(playProc1/10000)*strs/1000;
			rateLeft=parseFloat(dddty*reteWidth/(strs/1000));
			if(rateLeft>=reteWidth){
				rateLeft=0;
			}
			console.log("1_" + secondToMinute((playProc1 / 10000) * strs));
			if (timeFlag <= 0) {
			    if (clientInfo.attr("playproc").split("_")[1] == "1") {
			        $("#rateProgressValue").html(secondToMinute((playProc1 / 10000) * strs));
			        $("#rangeRate2").css("left", rateLeft);
			        $("#rangeLeft").css("width", rateLeft);
			    } else {
			        $("#rateProgressValue").html("00:00");
			        $("#rangeRate2").css("left", "0px");
			        $("#rangeLeft").css("width", "0px");
			    }
			    
			    console.log("2_" + secondToMinute((playProc1 / 10000) * strs));
			}
			if (soundFlag <= 0) {
			    
			    $("#range2").val(mplayVol);
			    $("#value2").html(mplayVol);
			}
			
		}	
		socket.onclose = function(){
		}					
	} catch(exception){
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
  if(bIsIphoneOs||bIsWM||bIsAndroid||bIsWM){
	  window.location.href=window.location.href.split("/")[0]+"mctrl.html";
  }else{
  }
} 

//只处理move操作，进行当前的操start和end都不发送数据，当连续两次快速的点击时发送end指令即可以实现双击
$(document).ready(function(){
	var ctx=document.getElementById("myCanvas1");
	var tempCtx = ctx.getContext('2d');
	var startX=0;
	var startY=0;
	
	//添加touchStart监听
	ctx.addEventListener('touchstart',function(evt){
		started=evt.clientX+","+evt.clientY;
		//将在平板上读取的坐标以同样的比例放大到显示终端上同样的位置
		var moveX=parseInt(screenWidth/$("#myCanvas1").width()*evt.touches[0].pageX);
		var moveY=parseInt(screenHeight/$("#myCanvas1").height()*evt.touches[0].pageY);
		startX=moveX;
		startY=moveY;
		onemousemove=false;//根据此值来判断是否进行了touchmove操作
        historysendstr="";
		dragStart=true;
		var time=new Date();
		startTime=time.getTime();
		//判断是否长连接已经建立并正在连接中，若是 则将当前的坐标发送给服务器端
		//若不是，则重新连接后再进行一次判断，判断成功后将当前的坐标发送给服务器端
		event.preventDefault(); //阻止滚动
		oldX=moveX;
		oldY=moveY;
		if(socket1!=null&&socket1.readyState==1){
		}else{
			connectTouchMouseStart(0,0);
		}
		
	},false);
	//添加touchmove监听，向服务器端发送指令的过程同touchstart相同
	ctx.addEventListener('touchmove',function(evt){
		if (onemousemove==false){
			onemousemove=true;//将onemousemove置为true，表示将要进行移动的操作
			if(dragStart==true){
				var moveX=parseInt(screenWidth/$("#myCanvas1").width()*evt.touches[0].pageX);
				var moveY=parseInt(screenHeight/$("#myCanvas1").height()*evt.touches[0].pageY);
				var movingx=moveX-oldX;
				var movingY=moveY-oldY;
				oldX=moveX;
				oldY=moveY;
				if(socket1!=null&&socket1.readyState==1){
					lastMoveX=moveX;
					lastMoveY=moveY;
					socket1.send(targeturlhead+(statusMouse+64)+"_"+movingx+"_"+movingY);
				}else{
					connectTouchMouseStart(movingx,movingY);
				}
			}
		}else{
			if(dragStart==true){
				var moveX=parseInt(screenWidth/$("#myCanvas1").width()*evt.touches[0].pageX);
				var moveY=parseInt(screenHeight/$("#myCanvas1").height()*evt.touches[0].pageY);
				var movingx=moveX-oldX;
				var movingY=moveY-oldY;
				oldX=moveX;
				oldY=moveY;
				if(socket1!=null&&socket1.readyState==1){
				}else{
					connectTouchMouseStart(0,0);
				}
				if(socket1!=null&&socket1.readyState==1){
					  lastMoveX=moveX;
					  lastMoveY=moveY;
					  historysendstr=historysendstr+(statusMouse+64)+"_"+movingx+"_"+movingY+";";
					  if (historysendstr.length>0)//每128个字节发送一次
					  {
						 socket1.send(targeturlhead+historysendstr);
						 //发送结束后将字符串清空，以便于下一次发送不受影响
						 historysendstr="";
					  }  
				}
			}
		}
	},false);
	//添加touchend监听，实现方式同上
	ctx.addEventListener('touchend',function(evt){
	    if (dragStart) {
	        
			dragStart=false;
			//抬起时touches不起作用，报错，所以用changedTouches
			var moveX = parseInt(screenWidth / $("#myCanvas1").width() * evt.changedTouches[0].pageX);
			var moveY = parseInt(screenHeight / $("#myCanvas1").height() * evt.changedTouches[0].pageY);
			if (onemousemove == false) {
			    socket1.send(targeturlhead + "129_-1_-1");
			    socket1.send(targeturlhead + "0_-1_-1");
			}
			
		}
		historysendstr="";		
	},false);
});
//状态板块处理，组合键的按下、抬起状态设置
$(document).ready(function(){
	//添加touchStart监听
	var ctx2=document.getElementById("myCanvas2");
	ctx2.addEventListener('touchstart',function(evt){
		event.preventDefault(); //阻止滚动
		dragStart1=true;
		statusMouse=1;
		statusEnd1=1;
		if(socket1!=null&&socket1.readyState==1){
		}else{
			connectTouchStart(-1,-1);
		}
		
		if(socket1!=null&&socket1.readyState==1){
			socket1.send(targeturlhead+"129_-1_-1");//若用moveX,moveY则会有差异
		}
	},false);
	
	//添加touchend监听，实现方式同上
	ctx2.addEventListener('touchend',function(evt){
		statusMouse=0;
		if(dragStart1){
			dragStart1=false;
			//statusEnd1=0;
			if(socket1!=null&&socket1.readyState==1){
				socket1.send(targeturlhead+"0_-1_-1");//若用moveX,moveY则会有差异
				statusEnd1=1;
			}
		}
	},false);
});
//创建模拟操控板长连接，此处将两个长连接分开，目的是让两个实现的过程互不影响
function connectTouchMouseStart(moveX,moveY){
    var hosturl = "";
    if (newurl == "") {
        hosturl = window.location.href.split("//")[1].split("/")[0];
    } else {
        hosturl = newurl.split("//")[1];
    }
	var host = "ws://"+hosturl+"/"+targeturlhead+"64_"+moveX+"_"+moveY;//"/wpgetxmlids.asp?gettype=9&rnd="+Math.random(99999999);
	try{
		if(socket1==null||socket1.readyState!=1){//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
			if (socket1!=null){					//3-连接已经关闭或者根本没有建立;0-正在连接
				delete socket1;
			}
			socket1 = new WebSocket(host);//建立一个WebSocket
			if(socket1!=null){
				dragStart=true;
			}
		}
		socket1.onopen = function(){//建立连接
		}
		socket1.onmessage = function(data){//接收送服务器端返回的数据
		}
		
		socket1.onclose = function(){
		}			
			
	} catch(exception){
	}		
}
//拖动进度条改变进度
function changeNowRate(){
		//拖动进度条
	var rangeRate1 = document.getElementById("rangeRate1");        
	var rangeRate2 = document.getElementById("rangeRate2");  
	var changeFlage=0;
	
	var nowSecond= 0;
	
	rangeRate2.addEventListener('touchstart',function(event){
		changeFlage=1;
		
		clearInterval(timer);
	})             
	rangeRate2.addEventListener('touchmove', function(event) { 
		changeFlage=1 ; 
		//console.log("move"+changeFlage);         
		event.preventDefault();            
		var styles = window.getComputedStyle(rangeRate1,null);            
		var width=styles.width;//灰色块的长度，用于计算红色块最大滑动的距离
		//leftWidth为当前灰色块距离屏幕最左侧的距离
		var leftWidth=parseFloat($(".musicOrVideo img").eq(0).css("width"))+parseFloat((parseFloat($(".musicOrVideo").css("width"))*0.05))+parseFloat($(".musicOrVideo img").eq(1).css("width"))+parseFloat(parseFloat($(".musicOrVideo").css("width"))*0.05)+ parseFloat($(".musicOrVideo img").eq(2).css("width"))+parseFloat($(".musicOrVideo img").eq(3).css("width"))+parseFloat(parseFloat($("#rangeRate1").css("width"))*0.04);       
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
		    var nw = parseInt($("#tabscreen").attr("nowwindow"));
		    rangeRate2.style.left = moveleft + "px";//最后把left值附
		    nowSecond = moveleft * strsMax / reteWidth;
		    $("#rangeLeft").css("width", moveleft);
		    $("#rateProgressValue").html(secondToMinute(nowSecond));
		    console.log($("#rangeRate2").css("left"));
		};
	});
	rangeRate2.addEventListener('touchend',function(event){
		var reteWidth=parseFloat($("#rangeRate1").css("width"))-parseInt($("#rangeRate2").css("width"));
		var strsMax=parseFloat($("#rangeRate1").attr("max"));
		var nw=parseInt($("#tabscreen").attr("nowwindow"));
		nowSecond = moveleft * strsMax / reteWidth;
		timeFlag = 2;
		//docmd(nw*10000+3009,parseInt(nowSecond));
		docmdex(3009,parseInt(nowSecond));
		changeFlage=0;
	})  
}
//重启wisesendInfo
function reStartWiseSendInfo() {
	showLoading();
	var thisLocal=localUrl.split(":8080")[0];
	var restartcnname=$(".clientName").html().split(":")[1];
	$.ajax({
		url:thisLocal+":8080/wpcontrolcenter.asp?wpcontrolcenter=sys internal command30&maintype=6&subtype=0&companyid=wisepeak&utf8=1&cnlist="+restartcnname+"&commandparam=-wisesendinfo restart",
		type:"get",
		dataType:"xml",
		success: function (data) {
			hideLoading();
		    timeShowMsg("title", getLanguageMsg("发送成功", $.cookie("yuyan")), 500);
		},
		error: function (data) {
			hideLoading();
		    timeShowMsg("title", getLanguageMsg("发送失败", $.cookie("yuyan")), 500);
		}
	})
}
//刷新栏目
function refreshColumn(thisNum) {
	showLoading();
    var winNum = (parseInt($(".current").find("i").html().split("-")[0])+1).toString(16);
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=" + thisNum + "_0x" + winNum + "000000",
        type: "get",
        dataType: "xml",
		success: function (data) {
			hideLoading();
            timeShowMsg("title", "发送成功", 500);
        },
		error: function (data) {
			hideLoading();
            timeShowMsg("title", "发送失败", 500);
        }
    })
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
	var borderStyle = "";
	//此处用let声明变量，使i的作用域在for循环中，从而使for循环中的每一个列表都可以被注册事件
	for (let i = 0; i < document.getElementById("Screen").getElementsByClassName("left").length; i++) {
		
		document.getElementsByClassName("leftList")[i].ontouchstart = function (evt) {	
			console.log($(this).find("span"));
			var oDiv = this.children[0];
			thisHeight = window.getComputedStyle(oDiv.parentNode.parentNode).height;
			//获取精确高度，包括小数点，一定要获取精确的值，否则出现和原来的宽高不等的情况
			dragScreenx = 0;
			dragScreeny = 0;
			oldMoveX = $(oDiv).parent().parent().offset().left;
			oldMoveY = $(oDiv).parent().parent().offset().top;
			leftListDragW = window.getComputedStyle(oDiv.parentNode.parentNode).width;
			//获取精确宽度，包括小数点
			leftListDragH = thisHeight;

			$(".dragShadow").show();
			oDiv.parentNode.parentNode.nextSibling.style.display = "block";
			$(".left1").css("height", thisHeight);
			borderStyle = $(oDiv).parent().parent().css("borderBottom");
			var boxRight = 0;
			
			oldMoveX = $(oDiv).parent().parent().offset().left;
			
			oldMoveY = $(oDiv).parent().parent().offset().top;
			oDiv.parentNode.parentNode.style.position = "absolute";
			oDiv.parentNode.parentNode.style.background = "#fff";
			oDiv.parentNode.parentNode.style.zIndex = 1006;
			oDiv.parentNode.parentNode.style.left = oldMoveX + "px";
			boxRight = ($(".top").width() - oldMoveX - parseFloat(leftListDragW));
			oDiv.parentNode.parentNode.style.right = boxRight + "px";
			oDiv.parentNode.parentNode.style.top = oldMoveY + "px";
			oDiv.parentNode.parentNode.style.width = leftListDragW;
			oDiv.parentNode.parentNode.style.height = leftListDragH;

			var startedx = evt.touches[0].clientX;
			var startedy = evt.touches[0].clientY;
			dragScreenx = startedx;
			dragScreeny = startedy;
			oDiv.click();
		},
		document.getElementsByClassName("leftList")[i].ontouchmove = function (evt) {
			var oDiv = this.children[0];

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
			}
			oDiv.parentNode.parentNode.style.right = document.documentElement.clientWidth - parseInt(oDiv.parentNode.parentNode.style.left) - leftListDragW;
			dragScreenx = movex;
			dragScreeny = movey;
		},
		document.getElementsByClassName("leftList")[i].ontouchend = function (evt) {
			var oDiv = this.children[0];

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
			} else if (parseInt(oDiv.parentNode.parentNode.style.top) > document.documentElement.clientHeight - parseFloat(oDiv.parentNode.parentNode.style.height)/2) {
				
				var href = document.getElementById("downLoad");
				window.location = href
				console.log("下载")
			}
			$(".dragShadow").hide();
			oDiv.parentNode.parentNode.style.position = "";
			oDiv.parentNode.parentNode.style.background = "";
			oDiv.parentNode.parentNode.nextSibling.style.display = "none";
			oDiv.parentNode.parentNode.style.left = 0;
			oDiv.parentNode.parentNode.style.right = 0;
			oDiv.parentNode.parentNode.style.zIndex = 0
			oDiv.parentNode.parentNode.removeAttribute("style");
			oDiv.parentNode.parentNode.style.height = thisHeight;
		}	
	}
}




  