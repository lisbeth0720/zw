// JavaScript Document
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

var hrefDownLoad="";
var href="";

var socket=null;//用于显示进度的socket
var socket1=null;//用于模拟鼠标在显示端操作的socket
var dragStartjt=false;//判断是否要进行拖拽的动作，截图
var dragStart=false;//判断是否要进行拖拽的动作，操控板只进行移动
var dragStart1=false;//判断是否要进行拖拽的动作，操控板状态位
var sendding=false;//用于标志当前指令发送是否成功
var historysendstr="";
var onemousemove=false;
var penFlag=0;//当为0时则认为是单指拖动，为1时则认为是
var screenWidth=window.screen.width;//用来存储要控制终端的宽度
var screenHeight=window.screen.height;//用来存储要控制终端的高度
var windowWidth=window.screen.width;
//声明变量保存canvas的大小，此处使用clientWidth才能获取ios移动端的横竖屏的宽度
var canvaswindowWidth=document.documentElement.clientWidth;

var canvaswindowLeft=0;
var canvaswindowTop=0;
var canvasMarginLeft=0;


//声明全局变量保存最后一次move的操作  
var lastMoveX=0;
var lastMoveY=0;
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

var hideSlideTimer = "";//隐藏弹出区域所做的定时

var hideSlideTimer1 = "";//音量条长时间不点击自动消失
var hideSlideTimer2 = "";//隐藏弹出区域所做的定时(预览图片)
var oldchangeVal = $("input[type=range]").val();

var whRate = 0;//计算loadpng长度和宽度的比例

var slideCount = 0;//此处声明一个全局变量是为了执行touchend事件后存储变量
var slideNumber = 0;//此处声明一个全局变量是为了执行touchend事件后在一段时间内刷新界面几次

var clientIndex = 0;//记录当前的终端号，以便于刷新时重新回到此终端
var oldClientIndex = 0;//记录上一次的终端号
var client = 0;
var count1 = 0;

var screenimg = 0;//截屏图片对象
var timeFlag = 0;//设置一个变量存储拖动进度条后再度读取数据的时间 防止拖动时出现进度条跳转回原来位置
var soundFlag = 0;

getClientList(".topClientList");
browserRedirect();

//每一次点击获取相应的url，通过getData()来获取相应url下的数据
$(function(){
	var urlq,username,password,xmldata;
	urlq="wpgetxmlids.asp?utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	var pLH=$("#tabscreen p").height();
	$(".moreImage").css("marginTop",($(".topList").height()-$(".moreImage").height())/2);
	$(".controlAll .noSound").css("marginTop", ($(".controlAll").height() - $(".controlAll .noSound").height()) / 2);
	$(".controlAll b").css("marginTop",($(".controlAll").height()-$(".controlAll b").height())/2);
    //var cmdImg=$(".sendCmd").width()*0.15;
	var cmdImg = $(".sendCmd img").width();
	$(".sendCmd img").css("height",cmdImg);
	$(".smallbtn img").css("height",cmdImg);
	var cmdLi=$(".openOrClose").height();
	var marTopLi=(cmdLi-cmdImg)/2;
	$(".sendCmd img").css("marginTop",marTopLi);
	$(".smallbtn img").css("marginTop",marTopLi);
	
	$("#tabscreen p").css("lineHeight",pLH+"px");
	$(".slider span").css("lineHeight",pLH+"px");
	
	//$("#top li").eq(0).click();
	$(".allSound").click(function(){
		if($(".systemSound").css("display")=="none"){
		    $(".systemSound").css("display", "block");
		    //startTimer(".systemSound");
		}else{
			$(".systemSound").css("display","none");
		}
	});
	$("#range").on('input propertychange', function () {
	    
	    if (count1 != 0) {
	        clearInterval(hideSlideTimer1);
	        count1 = 0;
	        setTimeout('startTimer()', 3000);
	    }
	})
	//点击频道获取获取相应的频道
   $("#changeChannel").click(function(){
		$("#channelBar").slideToggle(600);
		count+=1;
		var channelUrl=$("#tabscreen").attr("src");
		url=channelUrl+"/wpgetxmlids.asp?rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
		getChannelList();
	});
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
		var value=$("#channelList").val()+"11";//11表示切换后立即启动节目单播放，69表示进入手动模式
		value=encodeURI(value);
		value="utf-8"+value;
		docmd(73,"'"+ value+"'");
		$(".handControl").attr("src","images/tabImg/shoudongmoshi.png");
		$(".startProgram").attr("src","images/tabImg/qidongjiemuSelected.png");
		window.setTimeout("getData(newurl)",1500);//触发加载数据事件
		window.setTimeout("getChannelList();",2500);//触发加载数据事件
		
	});
	//切换并暂停节目单频道按钮
	$("#channelBtnPause").click(function(){
		var value=$("#channelList").val()+"69";//11表示切换后立即启动节目单播放，69表示进入手动模式
		value=encodeURI(value);
		value="utf-8"+value;
		docmd(73,"'"+ value+"'");
		$(".handControl").attr("src","images/tabImg/shoudongmoshiSelected.png");
		$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
		window.setTimeout("getData(newurl)",1500);//触发加载数据事件
		window.setTimeout("getChannelList();",2500);//触发加载数据事件
		
	});
	//以下为点击隐藏全局控制按钮所做的适配
	$(".clickMore img").click(function(){
		var topW=$(".top").width();
		if(parseInt($(".topRight").css("right"))!=-parseInt($(".top").width()*0.35)&&parseInt($(".topRight").css("right"))!=-35){
			$(".topRight").animate({"right":"-35%"});
			$(".topRight").css({"display":"none"});
			$(".bigScreen").animate({"marginLeft":"2.5%"});
			$(".topMain").animate({"width":"84.8%"});
			if(document.documentElement.clientHeight<900){
				$("#div1").css("marginTop","5%");
				$(".topMain .programList .left .bgSpan").animate({width:"5%",height:$(".topMain .programList .left").width()*0.08+"px"});
				
			}else{
				$("#div1").css("marginTop","16%");
				$(".topMain .programList .left .bgSpan").animate({width:"9%",height:$(".topMain .programList .left").width()*0.15+"px"});
				
			}	
		}else{
			$(".topMain").animate({"width":"50%"});
			$(".topRight").css({"display":"block"});
			$(".bigScreen").animate({"marginLeft":"1.5%"});
			
			$(".topRight").animate({"right":"0"});
			
			$(".topMain .programList .left .leftList").animate({"width":"82%"});
			$(".topMain .programList .left .leftList span").animate({"width":"80%"});
			
			var cmdImg=$(".sendCmd").width()*0.2;
			var cmdLi=$(".openOrClose").height();
			var marTopLi=(cmdLi-cmdImg)/2;
			$(".sendCmd img").css("height",cmdImg);
			$(".smallbtn img").css("height",cmdImg);
			$(".smallbtn img").css("marginTop",marTopLi);
			var cmdLi=$(".openOrClose").height();
			var marTopLi=(cmdLi-cmdImg)/2;
			$(".sendCmd img").css("marginTop",marTopLi);
		}	
	});
	$('#SendMSGBar input').click(function () {
	    
	    //this.selectionStart = 0;

	   // this.selectionEnd = this.value.length;
	    

	})
	$(".moreContent").click(function(){
		$(".moreFunction").animate({"right":"0"});
	})
	$(".his").click(function(){
		$(".moreFunction").animate({"right":"-100%"});
		$(".moreContent").attr("src","images/tabImg/quanjudaohang.png");
	})
	$(".handControl").click(function(){
		$(".handControl").attr("src","images/tabImg/shoudongmoshiSelected.png");
		$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
	});
	$(".startProgram").click(function(){
		$(".handControl").attr("src","images/tabImg/shoudongmoshi.png");
		$(".startProgram").attr("src","images/tabImg/qidongjiemuSelected.png");
	});
	$(".touchMouse .closeTouchMouse img").click(function(){
		$(".touchMouse").css("display","none");
	})
	if ($.cookie("allscreen") == "open") {
	    $(".stopProgram").attr("src", "images/tabImg/qupingSelected.png");
	} else {
	    $(".stopProgram").attr("src", "images/tabImg/quping.png");
	}
    
    $("#pmt2").click(function () {
        if ($("#pmt2").prop("checked") == true) {
            $("#pmt1").prop("checked", false);
        }
    })
    $("#pmt1").click(function () {
        if ($("#pmt1").prop("checked") == true) {
            $("#pmt2").prop("checked", false);
        } 
    })
	setInterval("refreshScreen()",2000);//定时刷新显示界面的大小
	
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
	$(".moreImage").click(function(){
		if($(this).attr("src").indexOf("Selected")>=0){
			$(this).attr("src",$(this).attr("src").split("Selected")[0]+$(this).attr("src").split("Selected")[1]);
				 
		}else{
			var seStr=$(this).attr("src").split(".")[0]+"Selected."+$(this).attr("src").split(".")[1];
			$(this).attr("src",seStr);
			if($(this).attr("class").indexOf("moreClientList")>=0){
				$(".allClientListShade").show();
				$(".allClientList").slideDown("slow");
			}
		}
	})
	setTimeout(function () {
	    window.scrollTo(0, 1)
	}, 0);


	$(".allClientListShade").click(function(){
		$(".allClientList").slideUp("slow");
		$(".allClientListShade").hide();
		$(".moreClientList").attr("src",$(".moreClientList").attr("src").split("Selected")[0]+$(".moreClientList").attr("src").split("Selected")[1]);
	})
	
	if ($.cookie("clientIndex") == undefined || $.cookie("clientIndex") == "") {
	    clientIndex = 0;
	} else {
	    clientIndex = ($.cookie("clientIndex"));
	}
	if ($.cookie("clientIndex") > $("#top").width() / $(".cc").width()) {
	    $('#top').animate({ scrollLeft: parseInt($.cookie("clientIndex")) * $(".cc").width() }, 'slow');
	}
	

	$("#top").attr("clientname", $("#top li:eq(" + clientIndex + ")").attr("clientname"));
	$("#top li:eq(" + clientIndex + ")").css({ "color": "#22559c" });
	$("#tabscreen").attr("src", $("#top li:eq(" + clientIndex + ")").attr("src"));
	$("#tabscreen").attr("macName", $("#top li:eq(" + clientIndex + ")").attr("macname"));
	$("#tabscreen").attr("indexNumber", $("#top li:eq(" + clientIndex + ")").attr("indexclient"));
    newurl= $("#tabscreen").attr("src");
    //getData(newurl, clientIndex);

	if ($("#top li:eq(0)").attr("homeid") == "home") {
	    $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1");
	} else {
	    $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1");
	}
	
	changeNowRate();
	$(".start").click(function(){
		var tabWindow=$("#tabscreen").attr("nowWindow");
		if($(".start").attr("src")=="images/bottomTag/bofang-mian.png"){
			docmd(3003,"'"+tabWindow+"'");
			$(".start").attr("src","images/bottomTag/zantingda.png");
		}else{
			docmd(3002,"'"+tabWindow+"'");
			$(".start").attr("src","images/bottomTag/bofang-mian.png");
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
	$("#moreClient .cc").click(function () {
	   // if (parseInt($(this).attr("indexclient")) > parseInt($(".clientList").width() / $("#top .cc").width())) {
	        $('.topClientList').animate({ scrollLeft: parseInt($(this).attr("indexclient")) * $("#top .cc").width() }, 'slow');
	   // }
	})
	$(".cc").click(function(){
		//$(this).addClass("curentCC");
		
		var ccNum=$(this).attr("indexclient");
		var thisUrl=$(this).attr("src");
		$("#top").attr("clientname",$(this).attr("clientname"));
		  $("#top .cc").css({"color":"#f0f0f0"})
		  if($(this).parent().attr("id")!="top"){
			  for(var i=0;i<$("#top .cc").length;i++){
				  if($("#top .cc").eq(i).attr("src").indexOf(thisUrl)>=0){
					  $("#top .cc").eq(i).css({"color":"#22559c"});
					  break;
				  }
			  }
		  }else{
			  $(this).css({"color":"#22559c"});
		  }
		  
		  $("#tabscreen").attr("src",$(this).attr("src"));
		  newurl=$("#tabscreen").attr("src");
		  $("#tabscreen").attr("macName",$(this).attr("macname"));
		  $("#tabscreen").attr("indexNumber",$(this).attr("indexclient"));
		  if ($(this).find("span").text() == "返回中控页") {
		      window.location.href = "http://" + $(this).attr("src") + ":8080" + window.location.href.split(":8080")[1];
		  } else {
		      getData(newurl, ccNum);
		  }
		  if ($(this).attr("homeid") == "home") {
		      $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1");
		  } else {
		      $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1");
		  }
		  if ($.cookie("clientIndex") != undefined || $.cookie("clientIndex") != null) {
		      oldClientIndex = $.cookie("clientIndex");
		  }
		  $.cookie("clientIndex", ccNum);
		  if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
		      delete socket1;
		      socket1 = null;
		  }
		  if (socket != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接
		      delete socket;
		      socket = null;
		  }
		  showNowPlayScreen();
		  
	});
	
	$(".cc :eq(" + clientIndex + ")").click();//页面加载时，若没有进行其他的选择，默认的给第一条数据设置样式，使其获得焦点
	showNowPlayScreen();
	$(".closeTouchMouse img").click(function () {
	    if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接 关闭触控板鼠标
	        delete socket1;
	        socket1 = null;
	    }
	})
	$(".loadMaskTitle img").click(function () {
	    if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接 关闭截屏鼠标
	        delete socket1;
	        socket1 = null;
	    }
	})
	$(".videoTitle img").click(function(){
		$(".videoContent").css("display","none");
	})
	
	$(".videoTK select").change(function(){
		var selectVal=$(this).val();
		getVideoSource(selectVal)
	})
	$(".musicTitle img").click(function(){
		$(".musicContent").css("display","none");
	})
	$("#checkPictureTitle img").click(function () {
	    $("#checkPicture").hide();
	})
	$(".fileTitle img").click(function () {
	    $(".fileContent").css("display", "none");
	})
	if(document.documentElement.clientHeight<=600){
		
		$("#range2").css("top","-120%");
		$("#range2").css("left","63%");
		$("#value2").css("left", "59%");
		$(".sendCmd img").css("width", "10%");
		$(".sendCmd img").css("height",$(".sendCmd img").css("width"))
		$(".allControl ul li img").css({ "width": "40%", "marginLeft": "30%" });
		$("#points").css({ "width": "100px", "marginTop": "75px", "marginLeft": "-20px" });
		$("#nowSize").css("marginTop", "45px");
	}else{
		$("#range2").css("top","-66%");
		$("#range2").css("left","64%");
		$("#value2").css("left", "60%");
		$(".allControl ul li img").css("width", "60%");
		$(".allControl ul li img").css("marginLeft", "20%");
		$(".sendCmd img").css("width", "15%");
		$(".sendCmd img").css("height", $(".sendCmd img").css("width"));
		$("#points").css({ "width": "150px", "marginTop": "100px", "marginLeft": "-43px" });
	}
	//$(".main").css("height", document.documentElement.clientHeight - $(".top").height() - parseInt($(".main").css("marginTop")) - $(".bottom").height());
	$(".sendCmd img").css("marginTop", ($(".sendCmd").height() - $(".sendCmd img").height())/2);
	$(".stopProgram").click(function(){
	    if ($(".stopProgram").attr("src").indexOf("Selected") < 0) {
	        $(".stopProgram").attr("allscreen","open")
			$(".before").attr("onclick","docmd(14,0)");
			$(".next").attr("onclick","docmd(13,0)");
			$(".cmdBar").find("li").eq(0).attr("onclick","docmd(12,0)");
			$(".cmdBar").find("li").eq(1).attr("onclick","docmd(15,0)");
			$(".cmdBar").find("li").eq(2).attr("onclick","docmd(14,0)");
			$(".cmdBar").find("li").eq(3).attr("onclick","docmd(13,0)");
			//$(".startUp").attr("onclick","docmd(67,'"+taskID+"')");
			$(".stopProgram").attr("src",$(".stopProgram").attr("src").split(".")[0]+"Selected."+$(".stopProgram").attr("src").split(".")[1])
			
	    } else {
	        $(".stopProgram").attr("allscreen", "close");
			$(".before").attr("onclick","docmd(14,3)");
			$(".next").attr("onclick","docmd(13,3)");
			$(".cmdBar").find("li").eq(0).attr("onclick","docmd(12,3)");
			$(".cmdBar").find("li").eq(1).attr("onclick","docmd(15,3)");
			$(".cmdBar").find("li").eq(2).attr("onclick","docmd(14,3)");
			$(".cmdBar").find("li").eq(3).attr("onclick","docmd(13,3)");
			//$(".startUp").attr("onclick","docmd(16,'"+taskID+"')");
			$(".stopProgram").attr("src",$(".stopProgram").attr("src").split("Selected")[0]+$(".stopProgram").attr("src").split("Selected")[1]);
	    }
	    $.cookie("allscreen", $(".stopProgram").attr("allscreen"));
	})
	$(".slideImage").click(function(){
		
		$(".sildeMore").css("right","0");
		hideSlideTimer=setInterval("timeCount()",1000);
	})
	$(".commonStyle").click(function(){
		if (count != 0) {
			clearInterval(hideSlideTimer);
			count=0;
			setTimeout('$(".slideImage").click()',1000);
		}
		
	})
	$("#pic").click(function(){
		getScreen();
	})
	$("#localIP").click(function(){
		window.location.href="http://"+$(".controlAll").attr("localip")+":8080/pctrl.html";
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
    //静音
	$(".noSound").click(function () {
	    if ($(this).attr("src") == "images/leftControl/noSound.png") {
	        $(this).attr("src", "images/leftControl/quanjuyinliangSelected.png");
	        docmd("3028", "20");

	    } else {
	        $(this).attr("src", "images/leftControl/noSound.png");
	        docmd("3028", "10");
	    }
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
	$(".moreLogin img").click(function () {
	    $(".onClickLogin").hide();
	})
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
        eval(functionName + "(" + functionNum + ")");
    })
    $(".tipCancle").click(function () {
        $(".topConfirm").attr("messageTip", "");
        $(".confirmDiv").css("display", "none");
       // var functionName = $(".tipContent").attr("fName");
       // eval(functionName + "()");
    })
    $(".controlBottomTab").height("21px");
    $(".controlBottomTab li img").css("marginTop", "0px");
//    $(".controlBottomTab li img").css("marginTop", ($(".controlBottomTab").height() - $(".controlBottomTab .before").width()) / 2)
    //点击状态按钮即可刷新节目单
    $(".clientStatus").click(function () {
        getData(newurl, $.cookie("clientIndex"));
    })
    $(".windowName img").click(function () {
        $(".playScreenShadow").hide();
    })
    $(".main").css("height", document.documentElement.clientHeight - $(".top").height() - 5 - $(".bottom").height());
}
var count = 0;
var count1 = 0;
//定时器，截屏时点击操作框，若无人再点击则10s后自动隐藏
function timeCount(){
	
	count=count+1;
	console.log(count);
	if(count==10){
		$(".sildeMore").css("right","-60px");
		clearInterval(hideSlideTimer);
		count=0;
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
//获取当前布局的各个窗口
function getAreaWindow() {
    $.ajax({
        url: "",
        type:"get"
    })
}
//获取数据
function getData(URL,num){
    $(".controlAll").append('<img src="images/loadStatus.gif" class="loadStatus" allscrren="close" style="float: right; position:absolute;width:22px;height:22px;right:20px;">');
    $(".getChannel").html($("#top").attr("clientname") + " 频道获取");
    content1 = '';
	$.ajax({
		url: URL+"/wpgetxmlids.asp?gettype=0&rnd="+(Math.floor(Math.random()*(9999-1000))+1000)+"&utf8=1",
		dataType: 'xml',
		type: 'GET',		//提交方式
	    timeout: 5000,      //失败时间
		//timeout: 500,      //失败时间
		error: function (xml)//
		    //第二个参数 String textStatus：返回的是字符串类型，表示返回的状态，根据服务器不同的错误可能返回下面这些信息："timeout"（超时）, "error"（错误）, "abort"(中止), "parsererror"（解析错误），还有可能返回空值。
		{
			$("#pic").html("<img src='images/fail1.png' style=\"position:relative;top:5px;left:-15px;\"/>");
			//当数据出错时将原有的数据清除，
			var number=parseInt($("#tabscreen").attr("indexnumber"));
			if(contentStr[number]!=undefined||contentStr[number]!=""){
				$(".programList").children().remove();
				$("#Screen").html(contentStr[parseInt(number)]);
			}
			$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
			$(".handControl").attr("src", "images/tabImg/shoudongmoshi.png");
			$("#Screen").html("<p align='center' style='font-size:16px;color:red;'>获取数据出错！</p>");
			$(".controlAll").find("b").css("width", $(".controlAll").find("b").css("height"));
			$(".loadStatus").remove();
			if (xml.statusText == "error") {
			    $(".controlAll").find("b").css("background", 'url("../images/tubiaob.png") -1px -328px / 240px 640px no-repeat');
			} else if (xml.statusText == "timeout") {
			    $(".controlAll").find("b").css("background", "url(../images/allTitle/timeOut.png) no-repeat");
			    $(".controlAll").find("b").css("backgroundSize", "100%");
			}
			$("#functionButton").hide();
			changeStyle();
			oldData='';	
		},
		success: function(xml)
		{
		    $(".loadStatus").remove();
			$("#functionButton").css("display","block");
			//每次请求成功后都将之前所获得的播放列表的数据清除 
			$("#Screen").attr("align", "left");
			if (oldClientIndex != num) {
			    $(".controlAll").find("b").css("background", 'url("../images/tubiaob.png") -1px -328px / 240px 640px no-repeat');
			    oldClientIndex = num;
			}
			if(true){
				if($(xml).find("item").length<=0){
					$(".programList").html("<p align='center' style='font-size:14px;'>当前节目单为空！</p>")
				}else{
					$("#pic").html("<img src='images/success1.png' style=\"position:relative;top:5px;left:-15px;\"/>");
					$(".programList").children().remove();
				//判断当前请求的数据与上次请求的数据是否不同，若不同执行下面的程序，目的是能将用户新编排的节目单及时的显示到操控页面，
				//与此同时，又不会在不断的获取数据的过程中出现闪屏的现象。
					var clientInfo=$(xml).find("clientInfo");//获得终端信息标签
					var clientName1=$(clientInfo).attr("clientname");//获得终端名称
					var playTask = $(clientInfo).attr("playtask");
					var arrayTask = "";
					var currentTask=""
					if (playTask == undefined || playTask == "") {
					    arrayTask = "";
					} else {
					    arrayTask = playTask.split("/");
					    currentTask = arrayTask[1];//获得当前播放节目的id
					}
					var playVol=$(clientInfo).attr("playvol");//获得当前的系统音量
					var hostName=$(clientInfo).attr("hostname");//获得当前的计算机名
					var menuPath=$(clientInfo).attr("menupath");//获得当前播放节目单所存储的位置
					var menuInfo=$(clientInfo).attr("menuinfo");//获取当前节目单名
					var localIp=$(".controlAll").attr("localip",$(clientInfo).attr("controlroom"));
					if ($(clientInfo).attr("scrrate") != null && $(clientInfo).attr("scrrate") != undefined) {
					    screenWidth = parseInt($(clientInfo).attr("scrrate").split("_")[0]);//获得显示端的宽度
					    screenHeight = parseInt($(clientInfo).attr("scrrate").split("_")[1]);//获得显示端的高度
					    widthRate = screenWidth / canvaswindowWidth;
					}
					
					var playState=$(clientInfo).attr("playstate");
					var playOrPause = "";
					var playStart=""
					if (playState != null && playState != undefined) {
					    playOrPause = playState.split("_");
					    playStart = playOrPause[0];
					}
					
					var findex = "";
					var systemSound = "";
					var validValue = 0;
					var objValid = "";
					var objValid2 = "";
					if (playVol != null && playVol != undefined && playVol != "") {
					    // findex = playVol.split("/"); 
					    objValid = playVol.split("/");
					    systemSound = objValid[0];
					   
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
					if(parseInt(thisStatus)==1){
						showStatus(mainStatus,num)
						
					}
					$(".cc").eq(num).attr("mainStatus",mainStatus);
					if($("#top li").eq(0).text()=="返回中控页"){
						$("#top li").eq(0).attr("src",$(xml).find("clientInfo").attr("controlroom"));
					}
					
					$(".cc").eq(num).attr("mainStatus",mainStatus);
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
					
					changPlayStatus(playStatus);
					changeMenuState(menuState);
					var clientInfobarHtml="<span>终端名称："+clientName1+"</span><span style='margin-left:2em;'>计算机名："+hostName+"</span>";
					$("#clientInfoBar").html(clientInfobarHtml);
					$(xml).find("item").each(function(i){
						var downLink=$(this).find("downLink").text();
						var itemType=$(this).find("itemType").text();
						var moreInfo=$(this).find("moreInfo");	//其他信息字符串
						var markID=$(this).find("markID").text();		//任务号 素材号-栏目号-主任务号-栏目内任务号
						var tempMarkID=markID.split("-");
						var taskID = tempMarkID[2];	//任务号
						if ($(this).find("iconLink").text().indexOf("$$") >= 0) {
						    iconLink = newurl + "/" + $(this).find("iconLink").text();
						} else {
						    iconLink = "http://" + $(".controlAll").attr("localip") + ":8080/" + $(this).find("iconLink").text();
						}
						
						var moreInfo2=moreInfo.text().split("\\027");
						var Win = $(this).find("win").text();
						if(moreInfo2[0]==""){
							moreInfo2[0]="["+ItemType(itemType,downLink)+"]";
						}
						var windowsNum = "";
						var numberWindows = "";
						var win = "";
                        var newMoreInfo=""
						if (markID != undefined && markID != null) {
						     tempMarkID = markID.split("-");
						     taskID = tempMarkID[2];	//任务号
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
						}
						
						//缩略图
						var otherButton="<div class='programBtn'></div>"
						var imagesrc="<span class='bgSpan' onclick=\"docmd(67,'"+taskID+"');\"><img src='"+iconLink+"' align='absmiddle' onerror='changeImage(this)'/></span>"//类型图片
						var inImage="<div class='startNowBtn'  style='width:18%;height:100%;display:block;float:left;' ><span  class='startNow' onclick=\"startNow('"+taskID+"');\"><img  src='images/contentTab/bofang.png'/></span><span class='otherBtn'><img  src='images/contentTab/gengduo.png' /></span></div>";//'"docmd(16,"'+taskID+'")"'
						//节目项列表
						
						content1 += "<div class='left' taskid='" + taskID + "'>" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' mplayVol='" + mplayVol + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "'  ><span class='spanContent' style='padding-left:2%;display:block;width:75%;height:100%;float:left;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "'," + itemType + ",this);\"><p class='programFileName'>" + moreInfo2[0] + "</p><p class='timeLong' style='margin-top:0px;'><i style='font-size:12px;'>" + Win.split(":")[0] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + inImage + "</div></div>" + otherButton;
						console.log(content1);
					});
					var strNum=parseInt($("#tabscreen").attr("indexnumber"));
					contentStr[strNum]=content1;
					$("#Screen").html(content1);
                    
					$(".main .programList .left:even").css("background", "#c9ecfe");
					$(".loadpng").attr("screenWidth",screenWidth);
					$(".loadpng").attr("screenHeight",screenHeight);
					//获得焦点的项目样式改变
					changeStyle();
					//全局控制按钮
					controlAll="<ul src='"+URL+"'><li onclick='docmd(69,0)'>手动模式</li><li class='sendCmd' onclick='docmd(11,0)' >启动节目</li><li class='sendCmd' onclick='docmd(70,0)'>停止节目</li><li cmdStr='' title='sound'><input id='range' type='range' min='0' max='255' value='' onchange='change(\'range\',\'value\')'></input><span id='value'>5</span></li><li class='sendCmd' id='preTask' onClick='docmd(14,0)'>上一节目项</li><li class='sendCmd' id='nextTask' onClick='docmd(13,0)'>下一节目项</li><li class='sendCmd' onclick='docmd(21,0)'>暂停/继续</li></ul>";
					//显示系统音量
					$("#range").val(systemSound);
					$("#value").html(systemSound);
					$("#range2").val(mplayVol);
					$("#value2").html(mplayVol);
					//$(".getChannel").html(clientName1+" 频道获取");
					//根据当前的手动还是自动的状态切换图标，点击手动则关闭自动模式，否则开启，默认情况下则开启的是自动模式
					clickChangeMenuState(menuState);
					
					//如果当前没有正在播放的节目，则默认将第一个节目设置为获得焦点的节目
					if (currentTask <= 0) {
					    currentTask = 1;
					    $("#Screen").find(".left").eq(0).find(".leftList .spanContent").click();
					} else {
					    for (var i = 0; i < $(".left").length; i++) {
					        if (currentTask == $("#Screen .left").eq(i).attr("taskid")) {
					            $("#Screen .left").eq(i).find(".leftList .spanContent").click();
					        }
					    }
					    for (var k = 0; k < $(".left").length; k++) {
					        if ($(".left").eq(k).attr("taskid") == currentTask) {
					            $(".left").eq(k).find(".timeLong").css("color", "#d11b28");
					        }
					    }
					}
					
				}
			}
			//将新的数据请求完毕之后将新的数据置为旧的数据，方便下次比较
			oldData=$(xml).text();
		}
	});
	
	//将当前的url设置为oldurl,也是为了切换显示端时，让程序进行识别，清除原来的数据
	oldURL=URL;	
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
function ItemType(itemtype, downLink) {
	////音视频
	//if (itemtype == 10 || itemtype == 1010||itemtype==9||itemtype==1009)
    //{	
	//	return "音视频"
    //}
	//else if (itemtype == 8 || itemtype == 1008)//office文档
    //{
	//	 //判断office文件中只有含有ppt和pptx才是ppt文件，其他的不做ppt处理
	//	 if (downLink!=null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".pptx") >= 0))
    //     {
	//		return "Office文档";
	//	 }else{//除了ppt和pptx的office文档当做图类型处理片
	//		return "图片";
	//	 }
	//}//对文档进行处理
	//else if (itemtype == 0 || itemtype == 1000 || itemtype == 12 || itemtype == 1012)
    //{
    //    if (downLink!=null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".pps")|| downLink.indexOf(".pptx") >= 0 || downLink.indexOf(".ppx")>= 0))
    //    {
	//		return "Office文档"
    //    }
    //    else 
    //    {	
	//		return "音视频";
    //    } 
	//}else{//其他的所有格式都当做图片进行处理
	//		return "图片";
    //}
    //音视频
    if (itemtype == 10 || itemtype == 1010 || itemtype == 9 || itemtype == 1009) {
        return "音视频";
        // return changLanguageMsg("音视频:", 0, $.cookie("yuyan"));
    }
    else if (itemtype == 8 || itemtype == 1008)//office文档
    {
        //判断office文件中只有含有ppt和pptx才是ppt文件，其他的不做ppt处理
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".pptx") >= 0)) {
            return "Office文档";
        } else {//除了ppt和pptx的office文档当做图类型处理片
            return "图片";
        }
    }//对文档进行处理
    else if (itemtype == 1 || itemtype == 1001) {
        return "文本";
    }
    else if (itemtype == 12 || itemtype == 1012 || itemtype == 0 || itemtype == 1000 || itemtype == 11 || itemtype == 1011) {
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".xls") >= 0 || downLink.indexOf(".docx") >= 0 || downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".doc") >= 0 || downLink.indexOf(".xlsx") >= 0 || downLink.indexOf(".pps") >= 0 || downLink.indexOf(".pptx") >= 0 || downLink.indexOf(".ppsx") >= 0)) {
            return "Office文档"
        } else if (downLink.indexOf(".txt") >= 0) {
            return "文本"
        } else if (downLink.indexOf(".htm") >= 0 || downLink.indexOf(".html") >= 0 || downLink.indexOf(".asp") >= 0 || downLink.indexOf(".aspx") >= 0 || downLink.indexOf(".php") >= 0 || downLink.indexOf(".jsp") >= 0 || downLink.indexOf(".shtml") >= 0 || downLink.indexOf(".pdf") >= 0) {
            return "网页";
        } else if (downLink.indexOf(".gif") >= 0 || downLink.indexOf(".jpg") >= 0 || downLink.indexOf(".bmp") >= 0 || downLink.indexOf(".png") >= 0 || downLink.indexOf(".tiff") >= 0 || downLink.indexOf(".tif") >= 0 || downLink.indexOf(".jpeg") >= 0|| downLink.indexOf(".ico") >= 0) {
            return "图片"
        } else if (downLink.indexOf(".swf") >= 0) {
            return "动画"
        } else if (downLink.indexOf(".wav") >= 0 || downLink.indexOf(".aif") >= 0 || downLink.indexOf(".mp3") >= 0 || downLink.indexOf(".wma") >= 0 || downLink.indexOf(".cda") >= 0 || downLink.indexOf(".au") >= 0 || downLink.indexOf(".midi") >= 0 || downLink.indexOf(".aac") >= 0 || downLink.indexOf(".ape") >= 0 || downLink.indexOf(".ogg") >= 0) {
            return "音频"
        } else if (downLink.indexOf(".avi") >= 0 || downLink.indexOf(".mpg") >= 0 || downLink.indexOf(".mpeg") >= 0 || downLink.indexOf(".mp4") >= 0 || downLink.indexOf(".wmv") >= 0 || downLink.indexOf(".asf") >= 0 || downLink.indexOf(".vob") >= 0 || downLink.indexOf(".rm") >= 0 || downLink.indexOf(".rmvb") >= 0 || downLink.indexOf(".flv") >= 0 || downLink.indexOf(".f4v") >= 0 || downLink.indexOf(".mov") >= 0 || downLink.indexOf(".dat") >= 0) {
            return "视频"

        } else if (downLink.indexOf(".zip") >= 0 || downLink.indexOf(".rar") >= 0 || downLink.indexOf(".7z") >= 0 || downLink.indexOf(".tar") >= 0 || downLink.indexOf(".xz") >= 0 || downLink.indexOf(".bz2") >= 0) {
            return "压缩文件"
        } else {
            if (itemtype == 11 || itemtype == 1011) {
                return "操作系统自检";
            } else if (itemtype == 12 || itemtype == 1012) {
                return "应用程序"
            } else {
                return "自适应"
            }
        }
    } else if (itemtype == 2 || itemtype == 1002) {//其他的所有格式都当做图片进行处理
        return "网页";

    } else if (itemtype == 3 || itemtype == 1003) {
        return "图片";
    } else if (itemtype == 4 || itemtype == 1004) {
        return "通知(静态)";
    } else if (itemtype == 5 || itemtype == 1005) {
        return "通知(向上滚动)";
    } else if (itemtype == 6 || itemtype == 1006) {
        return "字幕(向左滚动)";
    } else if (itemtype == 7 || itemtype == 1007) {
        return "动画";
    } else if (itemtype == 13 || itemtype == 1013) {
        return "远程指令"
    } else if (itemtype == 14 || itemtype == 1014) {
        return "栏目"
    }
	
}
//音视频暂停/启动图片切换
function changPlayStatus(playStatus){
	if(playStatus=="2"){
		$(".start").attr("src","images/bottomTag/bofang-mian.png");
	}else{
		$(".start").attr("src","images/bottomTag/zantingda.png");
	}
}
//页面加载时获取手动模式还是自动模式
function changeMenuState(menuState){
	if(menuState==2){
		$(".startProgram").attr("src","images/tabImg/qidongjiemuSelected.png");
		$(".handControl").attr("src","images/tabImg/shoudongmoshi.png");
	}else if(menuState==1){
		$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
		$(".handControl").attr("src","images/tabImg/shoudongmoshiSelected.png");
	}else{
		$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
		$(".handControl").attr("src","images/tabImg/shoudongmoshi.png");
	}
}
//根据当前的手动还是自动的状态切换图标，点击手动则关闭自动模式，否则开启，默认情况下则开启的是自动模式
function clickChangeMenuState(menuState){
	if(menuState==1){
		$(".handControl").attr("src","images/tabImg/shoudongmoshiSelected.png");
		$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
	}else{
		$(".handControl").attr("src","images/tabImg/shoudongmoshi.png");
		$(".startProgram").attr("src","images/tabImg/qidongjiemuSelected.png");
	}
}
function meterialSound(thisSound){
	if($(thisSound).parent().parent().next().css("display")=="block"){
		$(thisSound).parent().parent().next().css("display","none");
	}else{
	    $(thisSound).parent().parent().next().css("display", "block");
	}
}
//专门为了获取音视频的播放状态，获取的方式和getData（）相同，只不过不再对其他的数据进行处理
function getRate(URL){
	if(dragStart){return;}//判断是不是要进行拖拽的动作，若是则将获取进度的长连接终止掉
	if(sendding){return;}
	sendding=true;
	if(URL!=oldURL){//若改变url则将原来url所得到的数据去除
		$(".programList").children().remove();
	}
	if(socket!=null&&socket.readyState==1){
		socket.send("wpgetxmlids.asp?gettype=9&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000));
	}else{
        connect();
		if(socket!=null&&socket.readyState==1){
		   socket.send("wpgetxmlids.asp?gettype=9&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000));
		   sendding=false;
                   return;
				   
		}
		$.ajax({
			url: URL+"/wpgetxmlids.asp?gettype=9&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
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
				var gGetPlayDuring=$(clientInfo).attr("playdur").split("_");
					gGetPlayDuring=parseInt(gGetPlayDuring[0]);
				var arrayTask = "";
				var currentTask = ""
				if (playTask == undefined || playTask == "") {
					arrayTask = "";
				} else {
					arrayTask = playTask.split("/");
					currentTask = arrayTask[1];//获得当前播放节目的id
					
					//if (currentTask != $(".current").attr("taskid")) {
					//    $(".left").eq(i).find(".timeLong").css("color", "#F2F2F2");
					//    for (var i = 0; i < $(".left").length; i++) {
					//        if ($(".left").eq(i).attr("taskid") == currentTask) {
					//            $(".left").eq(i).find(".timeLong").css("color", "red");
					//        }
					//    }
				    //}
					//$(".left").eq(parseInt(currentTask)).find(".timeLong").css("color", "#d11b28;");
				}
				
				var menuState=playTask.split("\/");
				menuState = (parseInt(menuState[0]) >> 6) & 0x03;
				var playVol = $(clientInfo).attr("playvol");
				var findex ="";
				var systemSound = "";
				var validValue = 0;
				var objValid = "";
				var objValid2 = "";
				if (playVol != null && playVol != undefined && playVol != "") {
				    //findex = playVol.split("/");
				    objValid = playVol.split("/");
				    systemSound = objValid[0];
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
				//$("#range").val(systemSound);
				//$("#value").html(systemSound);
				//$("#range2").val(mplayVol);
				//$("#value2").html(mplayVol);
				if (objValid[1] != "" && objValid[1] != null) {
				    if (objValid[1].split("_")[1] == "0") {
				        mplayVol = "0";
				    } else {
				        mplayVol = objValid[1].split("_")[0];
				    }

				}
				$("#rateProgress").attr("max",gGetPlayDuring);
				if(menuState!=oldmenuState){
					changeMenuState(menuState);
				}
				
				$("#rangeRate1").attr("max",gGetPlayDuring);
				var strs=parseFloat($("#rangeRate1").css("width"));
				$("#rateProgressValue").html(secondToMinute((playProc1/10000)*strs));
			}
           
		});
	}
	sendding=false;
}
//点击立即启动按钮
function startNow(taskId){
	if($(".stopProgram").attr("src").indexOf("Selected")>=0){
		docmd(67,taskId);
	}else{
		docmd(16,taskId);
	}
}
function fileDownLoad(thisList){
	 var url=$("#tabscreen").attr("src");
	  //对当前的节目点击下载按钮
	  var downLink=$(thisList).parent().parent().attr("downLink");
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
    // $(thisList).parent().parent().next().find("#checkFile").attr("href1",href);
	  $(thisList).parent().parent().parent().next().find("#checkFile").attr("href1", href);
	  $(thisList).parent().parent().parent().next().find("#downLoad").attr("href", hrefDownLoad);
}
//对动态加载进来的数据进行样式的修改
function changeStyle(){
    if (document.documentElement.clientHeight < 450) {
        $(".programList .left").css("height", "25%");
        $(".bgSpan img").css("width", "40%");
        $(".bgSpan img").css("height", $(".bgSpan img").css("width"));
        $(".bgSpan img").css("marginLeft", "30%");
        $(".bgSpan").css("marginTop", ($(".leftList").height() - $(".bgSpan").height()) / 2);
        $(".bgSpan img").css("marginTop", ($(".bgSpan").height() - $(".bgSpan img").height()) / 2);
		$(".startNowBtn img").css("width","40%");
		$(".startNowBtn img").css("marginLeft","30%");
		$(".main").css("marginTop","5px");
		//$("#functionButton .musicOrVideo img").css("width","70%");
		//$(".pptcontrolBottomTab li img").css({"width":"50%","marginLeft":"25%"});
		//$(".picturecontrolBottomTab li img").css({"width":"30%","marginLeft":"35%"});
    } else {
        $(".programList .left").css("height", "13%");
        $(".bgSpan").css("width", "10%");
        $(".bgSpan").css("height", $("#tabscreen .programList .left").width() * 0.1 + "px");
        $(".bgSpan").css("marginTop", ($(".leftList").height() - $(".bgSpan").height()) / 2);
        $(".bgSpan img").css("marginLeft", "10%");
        $(".bgSpan img").css("height", $(".bgSpan img").css("width"));
        $(".bgSpan img").css("marginTop", ($(".bgSpan").height() - $(".bgSpan img").height()) / 2);
		//$(".bgSpan img").css("marginTop",($(".leftList").height()-$(".bgSpan").height())/2);
		$(".startNowBtn img").css("width","60%");
		$(".startNowBtn img").css("marginLeft","20%");
		$(".main").css("marginTop", "3px");
		$(".main").css("height", document.documentElement.clientHeight - $(".top").height() - parseInt($(".main").css("marginTop")) - $(".bottom").height());
		//$("#functionButton .musicOrVideo img").css("width","100%");
		//$(".pptcontrolBottomTab li img").css({"width":"70%","marginLeft":"15%"});
		//$(".picturecontrolBottomTab li img").css({"width":"50%","marginLeft":"25%"});
	}	
	var leftListH=$(".leftList").height();
	var leftListspanH=$(".leftList span").height();
	var listImg=$(".leftList img").height();
	var imgLin=(leftListH-listImg)/2;
	var startImg=(leftListH-$(".startNowBtn img").width())/2;
	var spanImgH=$(".topMain .programList .left .bgSpan").height();
	var spanMargin=(leftListH-spanImgH)/2;
	var bottomH=$(".bottom").height();
	var leftSpanW=$(".topMain .programList .left .leftList").width()*0.78;
	var functionImgH=($(".bottom").width())*0.05;
	var ulHeight=$(".controlBottomTab").height();
	var beforHeight=$(".controlBottomTab .image").height();
	var picBefore=$(".picturecontrolBottomTab .image").height();
	//var startH=($(".bottom").width())*0.06;
	liSpanH=$(".controlBottomTab li span").height();
	bH=$(".controlBottomTab li b").height();
	$(".topMain .programList .left .leftList span").css("width",leftSpanW);
	//$("#functionButton .image").css("marginTop",(bottomH-functionImgH)/2);
	//$(".controlBottomTab li b").css("marginTop",(bottomH-liSpanH-bH)/2);
	var bottomImgH = $(".pictures li img").height();
	var downFileH=$(".downFile b").height();
	var pptH=$(".pptcontrolBottomTab li img").height();
	//$(".picturecontrolBottomTab .image").css("marginTop",(bottomH-picBefore)/2);
	$(".bottom .fileName").css("lineHeight",bottomH+"px");
	
	$(".start").css("marginTop",($(".controlBottomTab").height()-$(".start").height())/2);
	$("#startPPT").css("marginTop",(bottomH-$("#startPPT").height())/2);
	//$(".pictures").css("marginTop",(bottomH-bottomImgH)/2);
	
	$(".startNowBtn img").css("marginTop",startImg);
	//$(".bgSpan img").css("marginTop",(leftListH-$(".bgSpan img").css("width"))/2)
	$(".topMain .programList .left .bgSpan").css("marginTop", spanMargin);
	$(".spanContent .programFileName").css("marginTop", ($(".spanContent").height() - $(".spanContent .programFileName").height() - $(".spanContent .timeLong").height()) / 2+4);
	$(".spanContent .timeLong").css("marginTop", "0px");
	if(document.documentElement.clientHeight<400){
		$(".controlBottomTab").css("marginTop","0px");
	}else{
        ;
	}
	
	//判断当前显示端的名称，若超过10个字符，就截取10个字符后+"..."
	for (var i = 0; i < $("#top .cc").length; i++) {
	    //if ($("#top .cc").eq(i).html().length > 5) {
	    //    $("#top .cc").eq(i).html($("#top .cc").eq(i).html().substring(0,10) + "...");
	    //}
	    var ipyyy = $("#top .cc").eq(i).text();
	    var ipyy1 = ipyyy.split("192");
	    $("#top .cc").eq(i).html(ipyy1[0]);
	}
	
	$(".otherBtn").click(function(){
	    if ($(this).parent().parent().parent().next(".programBtn").css("display") == "none") {
	        $(".programBtn").slideUp("slow");
		    $(this).parent().parent().parent().next(".programBtn").slideDown("slow");
		    $(this).parent().prev().click();
			fileDownLoad(this);
		}else{
			$(this).parent().parent().parent().next(".programBtn").slideUp("slow");
		}
	})
	
	
	$(".leftList .spanContent").click(function(){
	  //点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
	  //节目项控制和全局控制的内容也得到相应的改变
	  $(".leftList .spanContent").css("color","#333");
	  $(".leftList .timeLong").css("color", "#f2f2f2");
	  $(".main .programList .left:even").css("background", "#c9ecfe");
	  $(this).parent().addClass("current");
	  $(this).parents().siblings().find(".leftList").removeClass("current");
	  $(this).css("color","#06afe8");
	  $(".start").attr("src","images/bottomTag/zantingda.png");
	})
	//点击当前列表的立即播放按钮，则当前列表的样式跟着改变，焦点定位到当前的点击的列表行
	$(".leftList .startNow").click(function(){
		//点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
	  //节目项控制和全局控制的内容也得到相应的改变
	  //$(".leftList span").css("background","#fff");
	  $(".leftList .spanContent").css("color","#333");
	  $(".leftList .timeLong").css("color", "#f2f2f2");
	  $(".main .programList .left:even").css("background", "#c9ecfe");
	  $(this).parent().parent().addClass("current");
	  $(this).parents().siblings().find(".leftList").removeClass("current");
	  $(this).parent().prev().click();
	  $(this).parent().parent().find(".spanContent").css("color","#06afe8");
	  $(this).parent().parent().parent().css("color","#fff");
	  $(this).parent().parent().addClass("current");
	  $(this).parents().siblings().find(".leftList").removeClass("current");
	  $(".start").attr("src","images/bottomTag/zantingda.png");
	});
    //点击全屏播放时，当前的行的样式跟随改变
	$(".bgSpan img").click(function () {
	    //点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
	    //节目项控制和全局控制的内容也得到相应的改变
	    $(".leftList .spanContent").css("color", "#333");
	    $(".leftList .timeLong").css("color", "#C9D6D8");
	    $(".main .programList .left:even").css("background", "#f2f2f2");
	    $(this).parent().parent().addClass("current");
	    $(this).parents().siblings().find(".leftList").removeClass("current");
	    $(this).parent().next().find(".spanContent").click();
	    $(this).parent().parent().find(".spanContent").css("color", "#06afe8");
	    $(this).parent().parent().parent().css("color", "#fff");
	    $(this).parent().parent().addClass("current");
	    $(this).parents().siblings().find(".leftList").removeClass("current");
	    $(".start").attr("src", "images/bottomTag/zantingda.png");
	})
	$(".controlBottomTab").height("21px");
	$(".pptcontrolBottomTab li img").css("marginTop", (80 - $(".pptcontrolBottomTab .before").width()) / 2);
	$(".picturecontrolBottomTab li .image").css("marginTop", (80 - $(".picturecontrolBottomTab .before").width()) / 2);
	//$(".controlBottomTab li img").css("marginTop", ($(".controlBottomTab").height() - $(".controlBottomTab .before").width()) / 2)

	$(".showRate .start").css("marginTop", "0px");
}
//判断当前的列表是那种类型，根据当前的类型显示不同的操作按钮
function showCtrlBar(barID,taskID,itemtype,thisList){
	var flag = 0;
	var downLink = "";
	var imageUrl=$(".left").find(".leftList[taskId='"+taskID+"']").prev(".bgSpan").find("img").attr("src");
	var fileName=$(".left").find(".leftList[taskId='"+taskID+"']").children("span").find("p").eq(0).text();
	downLink=$(".left").find(".leftList[taskId='"+taskID+"']").attr("downlink");
	var nowWindow = $(".left").find(".leftList[taskId='" + taskID + "']").attr("windowsNum");
	getRate(newurl);
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
	//音视频
	if (itemtype == 10 || itemtype == 1010||itemtype==9||itemtype==1009||itemtype == 7 || itemtype==1007)
    {	clearInterval(timer);
		var playOrPause=$("thisList").attr("playStatus");
		changPlayStatus(playOrPause);
		$(".picture").css("display","none");
		$(".ppt").css("display","none");
		$(".musicOrVideo").css("display","block");
		$("#functionButton .fileName1").html(fileName);
		var bottomH1=$(".bottom").height();
		var rateH=$("#rateProgress").height();
		var fil1H=$(".fileName1").height();
		var bottomH=$(".bottom").height();
		$(".showRate").css("marginTop",(bottomH1-rateH-50-10)/2);
		var str1=videoStr(hrefDownLoad, href);
		
		$(thisList).parent().parent().next().html(str1);
		$(thisList).parent().parent().next().find("#value2").html($(thisList).attr("mplayVol"));
		timer = setInterval("getRate(newurl)", 1000);
		$(".controlBottomTab li img").css("marginTop", ($(".controlBottomTab").height() - $(".controlBottomTab .before").width()) / 2)

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
			var imageMargin=(bottomH-liSpanH-bH)/2;
			var str1=pptStr(hrefDownLoad, href)
			$(thisList).parent().parent().next().html(str1);
		 }else{//除了ppt和pptx的office文档当做图类型处理片
			 clearInterval(timer);
			$(".musicOrVideo").css("display","none");
			$(".ppt").css("display","none");
			$(".picture").css("display","block");
			$("#functionButton .fileName").html(fileName);
			var bottomH=$(".bottom").height();
			var imageMargin=(bottomH-liSpanH-bH)/2;
			var str1=picStr(hrefDownLoad, href);
			$(thisList).parent().parent().next().html(str1);
		 }
	}//对文档进行处理
	else if (itemtype == 1 || itemtype == 1001 || itemtype == 2 || itemtype == 1002 || itemtype == 4 || itemtype == 1004 || itemtype == 5 || itemtype == 1005 || itemtype == 6 || itemtype == 1006 || itemtype == 7 || itemtype == 1007) {
		clearInterval(timer);
		$(".musicOrVideo").css("display","none");
		$(".ppt").css("display","none");
		$(".picture").css("display","block");
		$("#functionButton .fileName").html(fileName);
		var bottomH=$(".bottom").height();
		var imageMargin=(bottomH-liSpanH-bH)/2;
		var str1=picStr(hrefDownLoad, href);
		$(thisList).parent().parent().next().html(str1);
		
	}else{
		clearInterval(timer);
		$(".musicOrVideo").css("display","none");
		$(".ppt").css("display","none");
		$(".picture").css("display","block");
		$("#functionButton .fileName").html(fileName);
		var bottomH=$(".bottom").height();
		var imageMargin=(bottomH-liSpanH-bH)/2;
		var str1=picStr(hrefDownLoad, href);
		$(thisList).parent().parent().next().html(str1);
	}
	$(".images").css("width",$(".bottom").height()*0.6+"px");
	if($(".stopProgram").attr("src")=="Selected"){
		$(".startUp").attr("onclick","docmd(67,'"+taskID+"')");//跳转到当前任务
	}else{
		$(".startUp").attr("onclick","docmd(16,'"+taskID+"')");//跳转到当前任务
	}
	if(document.documentElement.clientHeight<400){
		$(".programBtn ul li img").css("width","20%");
	}else{
		$(".programBtn ul li img").css("width","30%");
	}
	$(".pictures").css("marginTop", ($(".bottom").height() - $(".pictures").width()) / 2);
	$(".pause").attr("onclick", "docmd(70,'0')");
	$(".picturecontrolBottomTab .image").css("marginTop", (80 - $(".picturecontrolBottomTab .before").width()) / 2);
	$(".pptcontrolBottomTab li img").css("marginTop", (80 - $(".pptcontrolBottomTab .before").width()) / 2);
	$(".controlBottomTab li").css("marginTop", "0px");
	$(".controlBottomTab li").css("marginTop", ($(".controlBottomTab").height() - $(".controlBottomTab .before").width()) / 2)
	$(".controlBottomTab .start").css("marginTop", ($(".controlBottomTab").height() - $(".controlBottomTab .start").width()) / 2);
	$(".showRate .start").css("marginTop", "0px");
}
//PPT的控制按钮
function pptStr(hrefDownLoad1, href1){
    return '<ul><li><img src="../images/contentTab/shouye.png" class="headPage" onclick="docmd(\'keycode\',\'urlplayer%20-keyevent%200xFF50\')"/></li><li><img src="../images/contentTab/weiye.png" class="endPage" onclick="docmd(\'keycode\',\'urlplayer%20-keyevent%200xFF57\')" ></li><li><img src="../images/contentTab/playScreen.png" class="playScreenProgram" onclick="playScreenProgram()"/></li><li><img src="../images/contentTab/tingzhiPlayScreen.png" class="stopScreenProgram" onclick="stopScreenProgram()"/></li><li><img src="../images/contentTab/stopColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,34)"/></li><li><img src="../images/contentTab/startColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,35)"/></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '"><img src="../images/contentTab/yulan.png" class="checkIn"  onclick="checkFile(this)" /></a></li></ul>';
    //return '<ul><li><img src="../images/contentTab/shouye.png" class="headPage" onclick="docmd(\'keycode\',\'urlplayer%20-keyevent%200xFF50\')"/></li><li><img src="../images/contentTab/weiye.png" class="endPage" onclick="docmd(\'keycode\',\'urlplayer%20-keyevent%200xFF57\')" ></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '"><img src="../images/contentTab/yulan.png" class="checkIn" /></a></li></ul>';

}
//音视频的控制按钮
function videoStr(hrefDownLoad1, href1){
    return '<ul><li><img src="../images/contentTab/yinliang.png" class="materialSound soundNum" onclick="meterialSound(this);"/></li><li><img src="../images/contentTab/danru.png" class="soundIn" onclick="docmd(3041,0);" ><li><img src="../images/contentTab/danchu.png" class="soundOut" onclick="docmd(3041,254);"></li><li><img src="../images/contentTab/kongzhi.png" class="controlLab" onclick="docmd(3008,0);" /></li><li><img src="../images/contentTab/playScreen.png" class="playScreenProgram" onclick="playScreenProgram()"/></li><li><img src="../images/contentTab/tingzhiPlayScreen.png" class="stopScreenProgram" onclick="stopScreenProgram()"/></li><li><img src="../images/contentTab/stopColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,34)"/></li><li><img src="../images/contentTab/startColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,35)"/></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '"><img src="../images/contentTab/yulan.png" class="checkIn"  onclick="checkFile(this)" /></a></li></ul><div id="meterial"><input id="range2" type="range" min="0" max="255" value="0" onchange="change(\'range2\',\'value2\')"><span id="value2">5</span></div>';
	//return '<ul><li><img src="../images/contentTab/yinliang.png" class="materialSound soundNum" onclick="meterialSound(this);"/></li><li><img src="../images/contentTab/danru.png" class="soundIn" onclick="docmd(3041,0);" ><li><img src="../images/contentTab/danchu.png" class="soundOut" onclick="docmd(3041,254);"></li><li><img src="../images/contentTab/kongzhi.png" class="controlLab" onclick="docmd(3008,0);" /></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '"><img src="../images/contentTab/yulan.png" class="checkIn"/></a></li></ul><div id="meterial"><input id="range2" type="range" min="0" max="255" value="0" onchange="change(\'range2\',\'value2\')"><span id="value2">5</span></div>';

}
//图片的控制按钮
function picStr(hrefDownLoad1, href1) {
    return '<ul><li><img src="../images/contentTab/shangfan.png" class="page_up" onclick="docmd("keycode","0xFF55")"/></li><li><img src="../images/contentTab/xiafan.png" class="page_down"  onclick="docmd("keycode","0xFF9B")" /></li><li><img src="../images/contentTab/zuiqian.png" class="page_Home" onclick="docmd("keycode","0xFF50")"/></li><li><img src="../images/contentTab/zuihou.png" class="page_End" onclick="docmd("keycode","0xFF57")"/></li><li><img src="../images/contentTab/playScreen.png" class="playScreenProgram" onclick="playScreenProgram()"/></li><li><img src="../images/contentTab/tingzhiPlayScreen.png" class="stopScreenProgram" onclick="stopScreenProgram()"/></li><li><img src="../images/contentTab/stopColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,34)"/></li><li><img src="../images/contentTab/startColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,35)"/></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '" onclick="checkImageFile(this)"><img src="../images/contentTab/yulan.png" class="checkIn"   /></a></li></ul>';
	//return '<ul><li><img src="../images/contentTab/shangfan.png" class="page_up" onclick="docmd("keycode","0xFF55")"/></li><li><img src="../images/contentTab/xiafan.png" class="page_down"  onclick="docmd("keycode","0xFF9B")" /></li><li><img src="../images/contentTab/zuiqian.png" class="page_Home" onclick="docmd("keycode","0xFF50")"/></li><li><img src="../images/contentTab/zuihou.png" class="page_End" onclick="docmd("keycode","0xFF57")"/></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '"><img src="../images/contentTab/yulan.png" class="checkIn"/></a></li></ul>';
}
//根据后台返回的数据判断当前显示端的状态然后将状态的图片显示
function showStatus(menuStatus,number){
	var menuStatus=parseInt(menuStatus);
	
	$(".controlAll").find("b").css("width",$(".controlAll").find("b").css("height"));
	if(menuStatus==0){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -1px -328px / 240px 640px no-repeat');
	}else if(menuStatus==1){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -41px -328px / 240px 640px no-repeat');
	}else if(menuStatus==2){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -81px -328px / 240px 640px no-repeat');
	}else if(menuStatus==3){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -121px -328px / 240px 640px no-repeat');
	}else if(menuStatus==4){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -161px -328px / 240px 640px no-repeat');
	}else if(menuStatus==5){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -201px -328px / 240px 640px no-repeat');
	}else if(menuStatus==6){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -1px -360px / 240px 640px no-repeat');
	}else if(menuStatus==7){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -41px -360px / 240px 640px no-repeat');
	}else if(menuStatus==8){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -81px -360px / 240px 640px no-repeat');
	}else if(menuStatus==9){
		$(".controlAll").find("b").css("background",'url("../images/tubiaob.png") -121px -360px / 240px 640px no-repeat');
	}
}
//发送指令函数
function docmd(cmdtype,cmdData){
	var url=$("#tabscreen").attr("src");
	var cmdType=""+cmdtype+"";
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
				//timeShowMsg("title","发送失败",500);		//失败报错
				topTrip("发送失败",2);
			},
		success:function(xml){
		    if (xml) {
		        if (cmdType.indexOf("3009") < 0 || cmdType.indexOf("29") < 0 || cmdType.indexOf("3001") < 0) {
		            topTrip("发送成功", 1);
		        }
				
				//timeShowMsg("title","发送成功",500);		//发送成功
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
			error:function(xml){
					//timeShowMsg("title","发送失败",500);		//失败报错
					topTrip("发送失败",2);
				},
			success:function(xml){
				if(xml){
					//timeShowMsg("title","发送成功",500);		//发送成功
					topTrip("发送成功",1);
				}
			}
		});
	}
	//点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
	if(cmdtype==13){
	var ele=$(".current").parent().next().next();
	ele.find(".leftList").addClass("current").find(".startNow").click();
	ele.prev().find(".leftList").removeClass('current');
	}
	if(cmdtype==14){
		var ele=$(".current").parent().prev().prev();
		ele.find(".leftList").addClass("current").find(".startNow").click();
		ele.next().find(".leftList").removeClass('current');
	}if(cmdType.indexOf("3009")>=0){
		
   		timer=setInterval("getRate(newurl)",1000);
	}	
	if(cmdtype==70){
		clearInterval(timer);
	}
	if(cmdtype==16){
		//timer=setInterval("getRate(newurl)",1000);
	}
}
//双击
function twoMouse(){
	var mouseUrl=newurl+"/wpsendkeys.asp?wpsendkeys=-mouseevent 129_-1_-1;0_-1_-1"
	$.ajax({
		url: mouseUrl,
		dataType:'html',
		type: 'GET',
		timeout: 5000,		//超时时间
		error:function(xml){
		    topTrip("发送失败", 2);		//失败报错
			},
		success:function(xml){
			if(xml){
				$.ajax({
					url: mouseUrl,
					dataType:'html',
					type: 'GET',
					timeout: 5000,		//超时时间
					error:function(xml){
							//timeShowMsg("title","发送失败",500);		//失败报错
							topTrip("发送失败",2);
						},
					success:function(xml){
						if(xml){
							//timeShowMsg("title","发送成功",500);		//发送成功
							topTrip("发送成功",1);
						}
					}
				});
				//timeShowMsg("title","发送成功",500);		//发送成功
				topTrip("发送成功",1);
			}
		}
		
	})
}
//提示框函数
function timeShowMsg(objID,msgstr,durTime){		//显示加载状态函数
	if(objID==""||durTime==null){return false;}
	if(msgstr==""||durTime==null){return false;}
	if(durTime==""||durTime==null){durTime=500;}
	var tempstr=$("#"+objID).text();
	$("#"+objID).text(msgstr);
	if(msgstr.indexOf("失败")>0){
		$("#"+objID).css("color","red");
	}else if(msgstr.indexOf("成功")>0){
		$("#"+objID).css("color","#aaa");
	}else if(msgstr.indexOf("刷新")>0){
	  $("#"+objID).css("color","#aaa");
	}
	window.setTimeout(function (){
		$("#"+objID).text(tempstr);
		if(tempstr.indexOf("刷新")>0){
	    $("#"+objID).css("color","#aaa");
		}
		//点击按钮，点的太快，‘’失败‘’出现BUG，文字不能还原。
	},durTime);
}
//拖动改变播放进度
function rateProgress(){
  var value = document.getElementById('rateProgress').value ;
  var nw=parseInt($("#tabscreen").attr("nowwindow"));
  document.getElementById('rateProgressValue').innerHTML = secondToMinute(value);
  
  docmd(nw*10000+3009,parseInt(document.getElementById('rateProgress').value));
  //每次拖动一次进度条就发送一次指令，以实时的获取当前的进度
 
  if(parseInt($("#rateProgress").val())>=parseInt($("#rateProgress").attr("max"))){
	$("#rateProgress").val(0);
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
//拖动滑动条获取到相应的值
function change(rangex, valuex) {
    soundFlag = 2;
   if(rangex=="range"){
	   var value = document.getElementById(rangex).value ;
	   var nw = parseInt($("#tabscreen").attr("nowwindow"));
	   document.getElementById(valuex).innerHTML = value;
	   if(document.getElementById('range').value=="0"){
		  $(".noSound").attr("src","images/leftControl/noSound.png")
	   }else{
		   $(".noSound").attr("src","images/leftControl/quanjuyinliangSelected.png")
	   }
	   docmd(29,getSoundNumSlip(document.getElementById(rangex).value));
   } else {
       var value = document.getElementById(rangex).value;
       var nw = parseInt($("#tabscreen").attr("nowwindow"));
	   var value2 = document.getElementById('range2').value ;
	   document.getElementById(valuex).innerHTML = value2;
	   docmd(nw * 10000 +3001,getSoundNumSlip(document.getElementById(rangex).value));
   }
   
  
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
function getChannelList(){
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
			$("#title").text("获取频道出错!");
			$("#pic").html("<img src='image/newOffLine.png' style=\"position:relative;top:2px;left:-15px;\"/>")
		},
		success: function(xml)
		{
			//下拉列表的第一项为当前正在播放的节目单，剩下的节目单按照正常的顺序显示
			var channels=$(xml).find("channel");
			var raius="10px 10px 0px 0px";
			$("#channelList").html("");
			channels.each(function(index, element) {
				var name,path,desc;
				name=$(this).find("name").text();
				path=$(this).find("path").text();
				desc=$(this).find("desc").text();
				if($("#menuPath").val()==path){
					$("#channelList").append("<option value='"+name+"' selected>"+name+"</option>");
				}else{
					$("#channelList").append("<option value='"+name+"'>"+name+"</option>");
				}
				$("#changeChannel").css("borderRadius","10px");
				if(count%2==0){
					$("#changeChannel").css("borderRadius","10px");
				}else{
					$("#changeChannel").css("borderRadius",raius);
					$("#channelBar").css("borderRadius","0px 0px 10px 10px");
				}
			});
		}
	});
		

}
//一键切换所有终端频道 因为每个显示端都由一个配置文件连接到主控端，wiseSendInfo会自动连接到主控端，所以此时可以用相对路径
function allClientChannel(){
	//var valueName=$("#channelList").val()+"11";
	var valueName=$("#channelList").val();
		valueName=valueName.split("[");
		valueName="*["+valueName[1]+"11";
	var str='';
	for (var i = 0; i < $("#top .cc").length; i++) {

	    str += $(".cc").eq(i).attr("clientname") + ";"
	}
	$.ajax({
		url:"wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=73&companyid=wisepeak&utf8=1&cnlist="+str+"&commandparam="+valueName+"&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
		dataType:"text",
		type:"GET",
		success:function(data){
			if(data){
				//timeShowMsg("title","发送成功",500);		//发送成功
				topTrip("发送成功",1);
				getData(newurl);
			}
		},error:function(data){
			//timeShowMsg("title","发送失败",500);		//发送失败
			topTrip("发送失败",2);
		}
	})
	//getData(newurl);
}
//手动全切
function allClientChannelHand(){
	//var valueName=$("#channelList").val()+"69";
	var valueName=$("#channelList").val();
		valueName=valueName.split("[");
		valueName="*["+valueName[1]+"69";
	var str='';
	for (var i = 0; i < $("#top .cc").length; i++) {

	    str += $(".cc").eq(i).attr("clientname") + ";"
	}
	$.ajax({
		url:"wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=73&companyid=wisepeak&utf8=1&cnlist="+str+"&commandparam="+valueName+"&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
		dataType:"text",
		type:"GET",
		success:function(data){
			if(data){
				//timeShowMsg("title","发送成功",500);		//发送成功
				topTrip("发送成功",1);
				getData(newurl);
			}
		},error:function(xml){
			//timeShowMsg("title","发送失败",500);		//发送失败
			topTrip("发送失败",1);
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
function lightChange(url,obj){
	var index=$("#bar1 .cmdBar .sendCmd").index(obj);
	if(index==0){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
	}
	if(index==1){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#e8072c");
		$(obj).css("color","#fff");
	}else if(index==2){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#06e860");
		$(obj).css("color","#fff");
	}else if(index==3){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#074ae8");
		$(obj).css("color","#fff");
	}else if(index==4){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#e8e807");
		$(obj).css("color","#fff");
	}else if(index==5){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#c307e8");
		$(obj).css("color","#fff");
	}else if(index==6){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#07e8e8");
		$(obj).css("color","#fff");
	}else if(index==7){
		$("#bar1 .cmdBar .sendCmd").css("background","#e6e6e6");
		$("#bar1 .cmdBar .sendCmd").css("color","#999");
		$(obj).css("background","#fff");
		$(obj).css("color","#000");
	}
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length-1).css("background","#f3a9a9");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length-2).css("background","#f3a9a9");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length-3).css("background","#f3a9a9");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length - 4).css("background", "#f3a9a9");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length - 5).css("background", "#f3a9a9");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length - 6).css("background", "#f3a9a9");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length-1).css("color","#fff");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length-2).css("color","#fff");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length-3).css("color","#fff");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length - 4).css("color", "#fff");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length - 5).css("color", "#fff");
	$("#bar1 .cmdBar .sendCmd").eq($("#bar1 .cmdBar .sendCmd").length - 6).css("color", "#fff");
	//var url1="http://192.168.1.51:8080/wpcontrolcomm.asp?wpcontrolcomm=";
	var url1=newurl+"/wpcontrolcomm.asp?wpcontrolcomm=";
		$.get(url1+url);
}
//对系统的应用功能按钮发送指令
function getUrl(url){
	url=$("#tabscreen").attr("src")+"/"+url+"&utf8=1";
	$.ajax({
		data:{rnd:(Math.floor(Math.random()*(9999-1000))+1000)},
		url: url,
		dataType:'html',
		type: 'GET',
		timeout: 15000,		//超时时间
		error:function(xml){
			//timeShowMsg("title","发送失败",500);		//失败报错
			topTrip("发送失败",2);
		},
		success:function(xml){
			if(xml){
				//timeShowMsg("title","发送成功",500);		//发送成功
				topTrip("发送成功",1);
			}
		}
	});
}
//文件预览
function checkFile(thishref){
	var fileSrc=$(thishref).parent().attr("href1");
	//var itemType=$(".current").attr("itemType")
	//var content="";
	//$(".file").find("video").remove();
	//$(".file").find("img").remove();
	////根据不同的itemType来使用不同的标签，使素材能正常预览，目前只设置了音/视频，图片两种
	//if(itemType == 10 || itemType == 1010||itemType==9||itemType==1009){
	//	content="<video src='"+fileSrc+"' controls='controls'></video>";
	//} else if (itemType == 3 || itemType == 1003) {
	//	content="<img src='"+fileSrc+"'>";
	//} else if (itemType == 12 || itemType == 1012 || itemType == 0 || itemType == 1000 || itemType == 11 || itemType == 1011) {
	//    if (downLink.indexOf(".gif") >= 0 || downLink.indexOf(".jpg") >= 0 || downLink.indexOf(".bmp") >= 0 || downLink.indexOf(".png") >= 0 || downLink.indexOf(".tiff") >= 0 || downLink.indexOf(".tif") >= 0 || downLink.indexOf(".jpeg" >= 0) || downLink.indexOf(".ico") >= 0) {
	//        content = "<img src='" + fileSrc + "'>";
	//    } else if (downLink.indexOf(".wav") >= 0 || downLink.indexOf(".aif") >= 0 || downLink.indexOf(".mp3") >= 0 || downLink.indexOf(".wma") >= 0 || downLink.indexOf(".cda") >= 0 || downLink.indexOf(".au") >= 0 || downLink.indexOf(".midi") >= 0 || downLink.indexOf(".aac") >= 0 || downLink.indexOf(".ape") >= 0 || downLink.indexOf(".ogg") >= 0) {
	//        content = "<video src='" + fileSrc + "' controls='controls'></video>";
	//    } else if (downLink.indexOf(".avi") >= 0 || downLink.indexOf(".mpg") >= 0 || downLink.indexOf(".mpeg") >= 0 || downLink.indexOf(".mp4") >= 0 || downLink.indexOf(".wmv") >= 0 || downLink.indexOf(".asf") >= 0 || downLink.indexOf(".vob") >= 0 || downLink.indexOf(".rm") >= 0 || downLink.indexOf(".rmvb") >= 0 || downLink.indexOf(".flv") >= 0 || downLink.indexOf(".f4v") >= 0 || downLink.indexOf(".mov") >= 0 || downLink.indexOf(".dat") >= 0) {
	//        content = "<video src='" + fileSrc + "' controls='controls'></video>";
	//    }
	//} else {
	//    window.open(fileSrc, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400, height=400");
	//}

	//$(".file").append(content);
	//$(".file").css("display","block");
	//$(".close").click(function(){
	//	$(".file").css("display","none");
	//	if($("video").length>0){
	//		$("video").remove();
	//	}
	//});
	window.open(fileSrc, "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400, height=400");

}
//当屏幕分辨率改变时，自动刷新页面，防止页面混乱
function refreshScreen(){
    var nowWidth = document.documentElement.clientWidth;
    //alert(nowWidth);
    if (Math.abs(nowWidth- screenWidth1)>=10) {
		window.location.reload();
		screenWidth1=nowWidth;
	}
}
//关机指令为0，重启指令为1
function powerOff(clientNum){
    var ccl = $("#top").attr("clientname");
    if ($(".topConfirm").attr("messageTip") == "ok") {
        var errorURL = $("#tabscreen").attr("src");
        $.ajax({
            url: errorURL + "/wpsendclientmsg.asp?wpsendclientmsg=" + clientNum + "_" + (1000 + parseInt(clientNum)) + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000)+"&utf8=1",
            dataType: 'html',
            type: 'GET',
            success: function (data) {
                //timeShowMsg("title","发送成功",500);
                topTrip("发送成功", 1);
                $(".topConfirm").attr("messageTip", "");
            },
            error: function (data) {
                //timeShowMsg("title","发送失败",500)
                topTrip("发送失败", 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + ccl + ";&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'text',
            type: 'GET',
            success: function (data) {
                timeShowMsg("title", "发送成功", 500);
                $(".topConfirm").attr("messageTip", "");
            },
            error: function (data) {
               
            }
        })
    } else {
        if (clientNum == 1) {
            tipMessage("确定要重启吗?", "powerOff", clientNum);
        } else {
            tipMessage("确定要关机吗?", "powerOff", clientNum);
        }
        
    }
}
//开机
function powerOn(){
	
    var ccl = $("#top").attr("clientname");
    var errorip = $("#tabscreen").attr("src");
    var errorIp = errorip.split("//");
    errorIp = errorIp[1].split(":");
    errorIp = errorIp[0];
    var errorMac = $("#tabscreen").attr("macname");
    var errorStr = "-f " + errorIp + ":" + errorMac + ";";
	
    //if ($(".topConfirm").attr("messageTip") == "ok") {
	    $.ajax({
	        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + ccl + ";&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	        dataType: 'text',
	        type: 'GET',
	        success: function (data) {
	            //timeShowMsg("title","发送成功",500);
	            topTrip("发送成功!", 1);
	            $(".topConfirm").attr("messageTip", "");
	        },
	        error: function (data) {
	           
	            $.ajax({
	                url: "wpcontrolcenter.asp?wpcontrolcenter=Turn-On TV&maintype=6&subtype=0&companyid=wisepeak&utf8=1&dohere=1&cnlist=noneed&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + Math.random(9999),
	                dataType: 'text',
	                type: 'GET',
	                success: function (data) {
	                    //timeShowMsg("title","发送成功",500)
	                    topTrip("发送成功", 1);
	                    $(".topConfirm").attr("messageTip", "");
	                },
	                error: function (data, XMLHttpRequest, textStatus, errorThrown) {
	                    //timeShowMsg("title","发送失败",500);
	                    topTrip("发送失败", 2);
	                    $(".topConfirm").attr("messageTip", "");
	                }
	            })
	        }
	    })
	//} else {
	//  tipMessage("确定要开机吗?", "powerOn");
	//}
	    
	//}
	
}
//创建模拟鼠标长连接，此处将两个长连接分开，目的是让两个实现的过程互不影响
function connectTouchStart(moveX, moveY) {
    var hosturl = "";
    if (newurl == "") {
        hosturl = window.location.href.split("//")[1].split("/")[0];
    } else {
        hosturl = newurl.split("//")[1];
    }
    
	//var hosturl=newurl.split("//")[1];
	var host = "ws://"+hosturl+"/"+targeturlhead+"129_"+moveX+"_"+moveY;//"/wpgetxmlids.asp?gettype=9&rnd="+Math.random(99999999);
	try{
		if(socket1==null||socket1.readyState!=1){//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
			if (socket1!=null){					//3-连接已经关闭或者根本没有建立;0-正在连接
				delete socket1;
			}
			$(".touchMovePanel").show();
			$(".touchMovePanel img").css("marginTop", (document.documentElement.clientHeight - 30) / 2);
			//alert("Connection established__" + (document.documentElement.clientHeight - 30) / 2);
			socket1 = new WebSocket(host);//建立一个WebSocket
			if(socket1!=null){
				dragStart=true;
			}
			//alert("Connection established2__" + (document.documentElement.clientHeight - 30) / 2);
		}
		socket1.onopen = function () {//建立连接
		    $(".touchMovePanel").hide();
		    console.log("Connection established");
		   // alert("Connection established");
		}
		socket1.onmessage = function(data){//接收送服务器端返回的数据
			//console.log(data);
		}
		
		socket1.onclose = function () {
		    $(".touchMovePanel").hide();
			console.log("WebSocket closed!");
		}			
			
	} catch (exception) {
	    $(".touchMovePanel").hide();
	    if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接 关闭触控板鼠标
	        delete socket1;
	        socket1 = null;
	    }
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
	console.log(freshTime);
	
}
//创建长连接，该部分的长连接主要用于音视频的进度条
function connect() {
    var hosturl = "";
    if (newurl == "") {
        hosturl = window.location.href.split("//")[1].split("/")[0];
    } else {
        hosturl = newurl.split("//")[1];
    }
	//var hosturl=newurl.split("//")[1];
	var host = "ws://"+hosturl+"/wpgetxmlids.asp?gettype=9&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	try{
		if(socket==null||socket.readyState!=1){//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
			if (socket!=null){					//3-连接已经关闭或者根本没有建立;0-正在连接
				delete socket;
			}
			socket = new WebSocket(host);//建立一个WebSocket
		}
		
		socket.onopen = function(){//建立连接
			console.log("Connection established");
		}
		socket.onmessage = function (data) {//接收送服务器端返回的数据
		    timeFlag--;
		    if (soundFlag > 0) {
		        soundFlag--;
		    }
			//console.log(data);
			$("#functionButton").css("display","block");
			//每次请求成功后都将之前所获得的播放列表的数据清除
			
			$("#Screen").attr("align","left");  
			var clientInfo=$($(data.data)[2]).find("clientInfo");//获得终端信息标签
			if(clientInfo==null){
				return;
			}    	
			var playProc=clientInfo.attr("playproc").split("_");
			var playProc1=playProc=parseInt(playProc[0]);
			var playTask=clientInfo.attr("playtask");
			var gGetPlayDuring=clientInfo.attr("playdur").split("_");
				gGetPlayDuring=parseInt(gGetPlayDuring[0]);
			var menuState=playTask.split("\/");
			    menuState = (parseInt(menuState[0]) >> 6) & 0x03;
			var arrayTask = "";
			var currentTask = ""
			if (playTask == undefined || playTask == "") {
			    arrayTask = "";
			} else {
			    arrayTask = playTask.split("/");
			    currentTask = arrayTask[1];//获得当前播放节目的id
			    //if (currentTask != $(".current").attr("taskid")) {
			    //    $(".left").eq(i).find(".timeLong").css("color", "#F2F2F2");
			    //    for (var i = 0; i < $(".left").length; i++) {
			    //        if ($(".left").eq(i).attr("taskid") == currentTask) {
			    //            $(".left").eq(i).find(".timeLong").css("color", "red");
			    //        }
			    //    }
			    //}
			    //$(".left").eq(parseInt(currentTask)).find(".timeLong").css("color", "#d11b28");
			}
			screenWidth=parseInt(clientInfo.attr("scrrate").split("_")[0]);
			screenHeight=parseInt(clientInfo.attr("scrrate").split("_")[1]);
			$("#rateProgress").attr("max",gGetPlayDuring);
			if(menuState!=oldmenuState){
				changeMenuState(menuState);
			}
			var playVol = $(clientInfo).attr("playvol");
			var findex = "";
			var systemSound = "";
			var validValue = 0;
			var objValid = "";
			var objValid2 = "";
			if (playVol != null && playVol != undefined && playVol != "") {
	//		    findex = playVol.split("/");
			    objValid = playVol.split("/");
			    systemSound = objValid[0];
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
			//console.log(menuState);
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
			    //$("#range").val(systemSound);
			    //$("#value").html(systemSound);
			    $("#range2").val(mplayVol);
			    $("#value2").html(mplayVol);
			}
			
		}
		
		socket.onclose = function(){
			console.log("WebSocket closed!");
		}			
			
	} catch(exception){
		//console.log(exception);
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
     
  }else{
	  window.location.href=window.location.href.split("/")[0]+"pctrl.html";
  }
}
//链接到资源文件获取页面
 function SourceGet() {
     if (newurl == "") {
        // window.location.href = window.location.href.split("/")[0] + "//" + window.location.href.split("/")[1] + window.location.href.split("/")[2] + "/source.html?typeIp=" + window.location.href.split("/")[0] + "//" +window.location.href.split("/")[2];
         window.location.href = window.location.href.split("/")[0] + "//" + window.location.href.split("/")[1] + window.location.href.split("/")[2] + "/source.html";
     } else {
        // window.location.href = window.location.href.split("/")[0] + "//" + window.location.href.split("/")[1] + window.location.href.split("/")[2] + "/source.html?typeIp="+newurl;
         window.location.href = newurl + "/source.html";
     }
	
}

//只处理move操作，进行当前的操start和end都不发送数据，当连续两次快速的点击时发送end指令即可以实现双击
$(document).ready(function(){
	//resetCanvas();
	var ctx=document.getElementById("myCanvas1");
	var tempCtx=ctx.getContext('2d');
	var startX=0;
	var startY=0;
	
	//添加touchStart监听
	ctx.addEventListener('touchstart',function(evt){
		started=evt.touches[0].clientX+","+evt.touches[0].clientY;
		//将在平板上读取的坐标以同样的比例放大到显示终端上同样的位
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
		oldY = moveY;
		if(socket1!=null&&socket1.readyState==1){
		} else {
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
		if(dragStart){
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
    try {
		if(socket1==null||socket1.readyState!=1){//1-连接成功建立，可以通信；2-连接正在进行关闭握手，即将关闭；
			if (socket1!=null){					//3-连接已经关闭或者根本没有建立;0-正在连接
			    delete socket1;
			    socket1 = null;
			}
			$(".touchMovePanel").show();
			$(".touchMovePanel img").css("marginTop", (document.documentElement.clientHeight - 30) / 2);
			
			socket1 = new WebSocket(host);//建立一个WebSocket
			if(socket1!=null){
				dragStart=true;
			}
		}
		socket1.onopen = function () {//建立连接
		    $(".touchMovePanel").hide();
			console.log("Connection established");
		}
		socket1.onmessage = function(data){//接收送服务器端返回的数据
			//console.log(data);
		}
		
		socket1.onclose = function () {
		    $(".touchMovePanel").hide();
			console.log("WebSocket closed!");
		}			
			
	} catch (exception) {
	    $(".touchMovePanel").hide();
	    console.log(exception);
	    if (socket1 != null) {					//3-连接已经关闭或者根本没有建立;0-正在连接 关闭触控板鼠标
	        delete socket1;
	        socket1 = null;
	    }
	}		
}
//拖动进度条改变音视频的进度
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
		//var leftWidth=parseFloat($(".musicOrVideo img").eq(0).css("width"))+parseFloat((parseFloat($(".musicOrVideo").css("width"))*0.05))+parseFloat($(".musicOrVideo img").eq(1).css("width"))+parseFloat(parseFloat($(".musicOrVideo").css("width"))*0.05)+ parseFloat($(".musicOrVideo img").eq(2).css("width"))+parseFloat($(".musicOrVideo img").eq(3).css("width"))+parseFloat(parseFloat($("#rangeRate1").css("width"))*0.04);       
       	var leftWidth=parseFloat($(".musicOrVideo img").eq(0).css("width"))+parseFloat($(".musicOrVideo").css("width"))*0.04;
		if (event.targetTouches.length == 1) {                
			var touch = event.targetTouches[0];                
			//计算红色块的left值，pageX是相对于整个页面的坐标，减去10（红色块长度的一半）是为了让鼠标点显示在中间，
			//可以更改值看看效果，如果灰色块不是紧挨着屏幕，那还需要计算灰色块距离左屏幕的距离，应为pageX！！！                
			moveleft = touch.pageX-leftWidth-10;                
			if(moveleft<=0){//红色块的left值最小是0；                    
				moveleft=0;                
			};                
			if(moveleft>=parseFloat(width)-20){////红色块的left值最小是灰色块的width减去红色块的width；                    
				moveleft=parseFloat(width)-20;                
			}                
			rangeRate2.style.left = moveleft + "px";//最后把left值附
			var reteWidth = parseFloat($("#rangeRate1").css("width")) - parseInt($("#rangeRate2").css("width"));
			var strsMax = parseFloat($("#rangeRate1").attr("max"));
			var nw = parseInt($("#tabscreen").attr("nowwindow"));
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
		nowSecond = moveleft * strsMax / reteWidth
		timeFlag = 2;
		docmd(nw*10000+3009,parseInt(nowSecond));
		changeFlage=0;
	})  
}
//重启wisesendInfo
function reStartWiseSendInfo(){
	var thisLocal=localUrl.split(":8080")[0];
	var restartcnname=$("#top").attr("clientname");
	$.ajax({
		url:thisLocal+":8080/wpcontrolcenter.asp?wpcontrolcenter=sys internal command30&maintype=6&subtype=0&companyid=wisepeak&utf8=1&cnlist="+restartcnname+"&commandparam=-wisesendinfo restart",
		type:"get",
		dataType:"xml",
		success:function(data){
			timeShowMsg("title","发送成功",500);
		},
		error:function(data){
			timeShowMsg("title","发送失败",500);
		}
	})
}
//刷新、停止栏目
function refreshColumn(thisWin,num) {
    var winId = (parseInt($(thisWin).parents(".programBtn").prev().find(".timeLong i").html().split("-")[0]) + 1).toString(16);
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=" + num + "_0x" + winId+"000000",
        type: "get",
        dataType: "xml",
        success: function (data) {
            timeShowMsg("title", "发送成功", 500);
        },
        error: function (data) {
            timeShowMsg("title", "发送失败", 500);
        }
    })
}


