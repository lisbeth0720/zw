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


browserRedirect();

//每一次点击获取相应的url，通过getData()来获取相应url下的数据
$(function(){
	var urlq,username,password,xmldata;
	urlq="wpgetxmlids.asp?utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	var pLH=$("#tabscreen p").height();
	$(".moreImage").css("marginTop",($(".topList").height()-$(".moreImage").height())/2);
	$(".controlAll .noSound").css("marginTop", ($(".controlAll").height() - $(".controlAll .noSound").height()) / 2);
	$(".controlAll b").css("marginTop",($(".controlAll").height()-$(".controlAll b").height())/2);
	var cmdImg = $(".sendCmd img").width();
	$(".sendCmd img").css("height",cmdImg);
	$(".smallbtn img").css("height",cmdImg);
	var cmdLi=$(".openOrClose").height();
	var marTopLi=(cmdLi-cmdImg)/2;
	$(".sendCmd img").css("marginTop",marTopLi);
	
	$("#tabscreen p").css("lineHeight",pLH+"px");
	$(".slider span").css("lineHeight", pLH + "px");
	//获取终端列表
	getClientList(".topClientList");
	//获取人脸识别部门列表
    getFaceDepart();
    getSound1();//获取音箱初始音量
    setTimeout("getSound2()", 3000);//获取主机与麦克的初始音量
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
    $("#tvControlShadow1 li").click(function () {
        debugger;
        var strNum = 0;
        var indexNum = $(this).parent().parent().index();
        if (parseInt(indexNum) >= 0 && parseInt(indexNum) <= 24) {
            strNum = 24 - parseFloat(indexNum);
        } else if (i >= 25 && i <= 29) {
            strNum = 54 - parseFloat(indexNum);
        }
        var stringNum = (200 + strNum);
        if ($(this).index() == 0) {
            if (strNum >= 221 && strNum <= 224) {
                sendAudioOrder(stringNum, "6");
            } else if (strNum >= 219 && strNum <= 220) {
                sendAudioOrder(stringNum, "7");
            } else if (strNum >= 216 && strNum <= 218) {
                sendAudioOrder(stringNum, "8");
            } else if (strNum >= 211 && strNum <= 215) {
                sendAudioOrder(stringNum, "9");
            } else if (strNum >= 208 && strNum <= 210) {
                sendAudioOrder(stringNum, "10");
            } else if (strNum >= 203 && strNum <= 207) {
                sendAudioOrder(stringNum, "11");
            } else if ((strNum >= 200 && strNum <= 202) || strNum == 229) {
                sendAudioOrder(stringNum, "12");
            } else {
                sendAudioOrder(stringNum, "13");
            }
        } else if ($(this).index() == 1) {
            audioNoSound(stringNum, "65535");
        } else if ($(this).index() == 2) {
            audioNoSound(stringNum, "0");
        } else if ($(this).index() == 3) {
            changeSound(stringNum, "1");
        }
        else if ($(this).index() == 5) {
            changeSound(stringNum, "0");
        }
    })
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
	setInterval("refreshScreen()",2000);//定时刷新显示界面的大小
    if ($.cookie("yuyan") != null && $.cookie("yuyan") != "" && $.cookie("yuyan") != undefined) {
        if ($.cookie("yuyan") == "en") {
            $(".changeLanguage").attr("alt", "English");
            $(".changeLanguage").attr("src", "images/allTitle/EN.png");
        } else {
            $(".changeLanguage").attr("alt", "中文");
            $(".changeLanguage").attr("src", "images/allTitle/CH.png");
        }

    } else {
        $(".changeLanguage").attr("alt", "中文");
    }
    $(".changeLanguage").click(function () {
		debugger;
        if ($(this).attr("alt") == "English") {
            $.cookie("yuyan", "en", { path: "/" });
            $(this).attr("alt", "中文");
            $(this).attr("src", "images/allTitle/EN.png");
            // debugger;
            switchLanguage(0, "newmctrl.html");
        } else {
            $.cookie("yuyan", "CH", { path: "/" });
            $(this).attr("alt", "English");
            $(this).attr("src", "images/allTitle/CH.png");
            //  debugger;
            switchLanguage(1, "newmctrl.html");


        }
        getLanguageMsg("获取数据出错!", $.cookie("yuyan"));
        $("#downLoad span").html(getLanguageMsg("下载", $.cookie("yuyan")));
        $("#checkFile span").html(getLanguageMsg("预览", $.cookie("yuyan")));
        if ($("#Screen .left").length <= 0) {//&& $(".clientStatus").attr("src").indexOf("fail1") >= 0
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
	//加载节目项的更多控制按钮
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
	
	/*if ($.cookie("clientIndex") == undefined || $.cookie("clientIndex") == "") {
	    clientIndex = 0;
	} else {
	    clientIndex = ($.cookie("clientIndex"));
	}*/
	//界面加载时自动将上次选中的终端列表选中，若选中的终端超出页面显示终端的长度，则自动滚动到选中终端的位置
	/*if ($.cookie("clientIndex") > $("#top").width() / $(".cc").width()) {
	    $('#top').animate({ scrollLeft: parseInt($.cookie("clientIndex")) * $(".cc").width() }, 'slow');
	}*/
	

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
	
	changeNowRate();//调节进度对touch事件进行声明
	$(".start").click(function(){
		var tabWindow=$("#tabscreen").attr("nowWindow");
		if($(".start").attr("src")=="images/bottomTag/bofang-mian.png"){
            docmdex(3003, parseInt(tabWindow));
			$(".start").attr("src","images/bottomTag/zantingda.png");
		}else{
			docmdex(3002,parseInt(tabWindow));
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
        $(".allClientListShade").hide();
        $(this).parent().parent().hide();
	})
	$(".cc").click(function(){
		
		var ccNum=$(this).attr("indexclient");
		var thisUrl=$(this).attr("src");
		$("#top").attr("clientname",$(this).attr("clientname"));
		  $("#top .cc").css({"color":"#f0f0f0"})
		  if($(this).parent().attr("id")!="top"){
			  for(var i=0;i<$("#top .cc").length;i++){
				  if($("#top .cc").eq(i).attr("src").indexOf(thisUrl)>=0){
                      $("#top .cc").eq(i).css({ "color":"#F06060"});
					  break;
				  }
			  }
		  }else{
              $(this).css({ "color":"#F06060"});
		  }
		  
		$("#tabscreen").attr("src", $(this).attr("src"));
		$("#tabscreen").attr("src", $(this).attr("src"));
		$("#tabscreen").attr("color", $(this).attr("color"));
		$("#tabscreen").attr("onlyview", $(this).attr("onlyview"));
		$("#tabscreen").attr("usegate", $(this).attr("usegate"));
		$("#tabscreen").attr("gateip", $(this).attr("gateip"));
		$("#tabscreen").attr("gateport", $(this).attr("gateport"));
		$("#tabscreen").attr("port", $(this).attr("port"));
		color = $(this).attr("color");//颜色值
		onlyview = $(this).attr("onlyview");//是否是只允许预览
		usegate = $(this).attr("usegate");//是否是多个服务器进行转发指令
		gateip = $(this).attr("gateip");//进行转发的多个服务器的ip地址，以;分割
		gateport = $(this).attr("gateport");//目的服务器的显示端的端口号
		port = $(this).attr("port");//目的服务器的显示端的端口号
		newurl=$("#tabscreen").attr("src");
		$("#tabscreen").attr("macName",$(this).attr("macname"));
        $("#tabscreen").attr("indexNumber", $(this).attr("indexclient"));
        var thislistIndex = $(this).find("span").attr("countnum");
        currentNum = thislistIndex;
        clientAudio(thislistIndex);
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
		  /*if ($.cookie("clientIndex") != undefined || $.cookie("clientIndex") != null) {
		      oldClientIndex = $.cookie("clientIndex");*/
//		}
		//选中终端后将页面中的webscoket关闭
		 // $.cookie("clientIndex", ccNum);
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
    if ($.cookie("yuyan") == "en") {
        switchLanguage(1, "newmctrl.html");
        $(".changeLanguage").attr("src", "images/allTitle/CH.png");
    } else {
        switchLanguage(0, "newmctrl.html");
        $(".changeLanguage").attr("src", "images/allTitle/EN.png");
    }
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
   


	$("#checkPictureTitle img").click(function () {
	    $("#checkPicture").hide();
	})
	$(".fileTitle img").click(function () {
	    $(".fileContent").css("display", "none");
	    $("#uploadRateLeft").css("width", "0%");
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
	
	$(".sendCmd img").css("marginTop", ($(".sendCmd").height() - $(".sendCmd img").height())/2);
	$(".stopProgram").click(function(){
	    if ($(".stopProgram").attr("src").indexOf("Selected") < 0) {
	        $(".stopProgram").attr("allscreen","open")
            $(".before").attr("onclick","docmd('before',0)");
			$(".next").attr("onclick","docmd('next',0)");
			$(".cmdBar").find("li").eq(0).attr("onclick","docmd(12,0)");
			$(".cmdBar").find("li").eq(1).attr("onclick","docmd(15,0)");
            $(".cmdBar").find("li").eq(2).attr("onclick","docmd('before',0)");
			$(".cmdBar").find("li").eq(3).attr("onclick","docmd('next',0)");
			$(".stopProgram").attr("src",$(".stopProgram").attr("src").split(".")[0]+"Selected."+$(".stopProgram").attr("src").split(".")[1])
			
	    } else {
	        $(".stopProgram").attr("allscreen", "close");
            $(".before").attr("onclick","docmd('before',3)");
			$(".next").attr("onclick","docmd('next',3)");
			$(".cmdBar").find("li").eq(0).attr("onclick","docmd(12,3)");
			$(".cmdBar").find("li").eq(1).attr("onclick","docmd(15,3)");
            $(".cmdBar").find("li").eq(2).attr("onclick","docmd('before',3)");
			$(".cmdBar").find("li").eq(3).attr("onclick","docmd('next',3)");
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
		window.location.href="http://"+$(".controlAll").attr("localip")+":8080/newmctrl.html";
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
    //点击音量图标，音量条显示，点击除此之外的按钮，音量条隐藏
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
     
    })
    $(".controlBottomTab").height("21px");
    $(".controlBottomTab li img").css("marginTop", "0px");
    //点击状态按钮即可刷新节目单
    $(".clientStatus").click(function () {
        //getData(newurl, $.cookie("clientIndex"));
		getData(newurl,clientIndex);
    })
    $(".windowName img").click(function () {
        $(".playScreenShadow").hide();
    })
    $(".main").css("height", document.documentElement.clientHeight - $(".top").height() - 5 - $(".bottom").height());
	if ($.cookie("yuyan") == "en") {
		getbtn("newmctrl", 1);
	} else if ($.cookie("yuyan") == "CH") {
		getbtn("newmctrl", 0);
	} else {
		getbtn("newmctrl");
	}
	setTimeout(function () {
		$(".controlImage img").eq(0).click();
	}, 1000)
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
function getData(URL, num) {
	var num=0;
	showLoading();
	controlIpName = $(".screenList").eq(num).attr("src").split("\/")[2].split(":")[0];
    $(".controlAll").append('<img src="images/loadStatus.gif" class="loadStatus" allscrren="close" style="float: right; position:absolute;width:22px;height:22px;right:20px;">');
    $(".getChannel").html($("#top").attr("clientname") + getLanguageMsg(" 频道获取", $.cookie("yuyan")));
    content1 = '';
	$.ajax({
        url: URL + "/wpgetxmlids.asp?gettype=0&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&rnd="+(Math.floor(Math.random()*(9999-1000))+1000)+"&utf8=1",
		dataType: 'xml',
		type: 'GET',		//提交方式
	    timeout: 5000,      //失败时间
		//timeout: 500,      //失败时间
		error: function (xml)//
		    //第二个参数 String textStatus：返回的是字符串类型，表示返回的状态，根据服务器不同的错误可能返回下面这些信息："timeout"（超时）, "error"（错误）, "abort"(中止), "parsererror"（解析错误），还有可能返回空值。
		{
			hideLoading();
			$("#pic").html("<img src='images/fail1.png' style=\"position:relative;top:5px;left:-15px;\"/>");
			//当数据出错时将原有的数据清除，
			var number=parseInt($("#tabscreen").attr("indexnumber"));
			if(contentStr[number]!=undefined||contentStr[number]!=""){
				$(".programList").children().remove();
				$("#Screen").html(contentStr[parseInt(number)]);
			}
			$(".startProgram").attr("src","images/tabImg/qidongjiemu.png");
			$(".handControl").attr("src", "images/tabImg/shoudongmoshi.png");
            $("#Screen").html("<p align='center' style='font-size:16px;color:red;'>" + getLanguageMsg("获取数据出错！", $.cookie("yuyan"))+"</p>");
			$(".controlAll").find("b").css("width", $(".controlAll").find("b").css("height"));
			$(".loadStatus").remove();
			if (xml.statusText == "error") {
			    $(".controlAll").find("b").css("background", 'url("../images/tubiaob.png") -1px -328px / 240px 640px no-repeat');
			} else if (xml.statusText == "timeout") {
			    $(".controlAll").find("b").css("background", "url(../images/allTitle/timeOut.png) no-repeat");
			    $(".controlAll").find("b").css("backgroundSize", "100%");
			}
			$("#functionButton").hide();
			
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
                    var menuPath = $(clientInfo).attr("menupath");//获得当前播放节目单所存储的位置
                    $("#changeChannel").attr("menuPath",menuPath);
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
					changPlayStatus(playStart);
					var findex = "";
					var systemSound = "";
					var validValue = 0;
					var objValid = "";
					var objValid2 = "";
					if (playVol != null && playVol != undefined && playVol != "") {
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
					//如果当前页面是在终端打开时，将控制室的地址赋值当前终端，方便后屋可以返回到总体的控制页面
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
					
					changPlayStatus(playStatus);//判断音视频的播放状态
					changeMenuState(menuState);//判断手动模式还是自动模式
                    var clientInfobarHtml = "<span>终端名称：" + clientName1 + "</span><span style='margin-left:2em;'>" + getLanguageMsg("计算机名：", $.cookie("yuyan"))+""+hostName+"</span>";
					$("#clientInfoBar").html(clientInfobarHtml);
					$(xml).find("item").each(function(i){
						var downLink=$(this).find("downLink").text();
						var itemType=$(this).find("itemType").text();
						var moreInfo=$(this).find("moreInfo");	//其他信息字符串
						var markID=$(this).find("markID").text();		//任务号 素材号-栏目号-主任务号-栏目内任务号

                        var tempMarkID = markID.split("-");
                        var taskID = "";	//任务号
                        
                        
						if ($(this).find("iconLink").text().indexOf("$$") >= 0) {
						    iconLink = newurl + "/" + $(this).find("iconLink").text();
						} else {
						    iconLink = "http://" + $(".controlAll").attr("localip") + ":8080/" + $(this).find("iconLink").text();
						}
						
						var moreInfo2=moreInfo.text().split("\\027");
						var Win = $(this).find("win").text();
						if(moreInfo2[0]==""){
							if ($(this).find("taskName").text() != "") {
								moreInfo2[0] = $(this).find("taskName").text();
							} else {
								moreInfo2[0] = "[" + ItemType(itemType, downLink) + "]";
							}
						}
						var windowsNum = "";
						var numberWindows = "";
						var win = "";
                        var newMoreInfo=""
						if (markID != undefined && markID != null) {
						     tempMarkID = markID.split("-");
                            taskID = tempMarkID[2];	//任务号
                            if (parseInt(tempMarkID[1]) > 1) {
                                taskID = parseInt(tempMarkID[2]) + (parseInt(tempMarkID[3]) << 16);;
                            } else {
                                taskID = tempMarkID[2];	//任务号
                            }
						     moreInfo2 = moreInfo.text().split("\\027");
						    if (moreInfo2[0] == "") {
								if ($(this).find("taskName") != "") {
									moreInfo2[0] = $(this).find("taskName");
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
						
						//缩略图
                        var randomColor = color16(win);
						var otherButton="<div class='programBtn'></div>"
						var imagesrc="<span class='bgSpan' onclick=\"changeSize(this)\"><img src='"+iconLink+"' align='absmiddle' onerror='changeImage(this)'/></span>"//类型图片docmd(67,'"+taskID+"');
                        var inImage = "<div class='startNowBtn'  style='width:18%;height:100%;display:block;float:left;' ><span  class='startNow' onclick=\"startNow(this,'" + taskID + "');\"><img  src='images/contentTab/bofang.png' class='playNowprogram'/></span><span class='otherBtn' onclick='getMoreList(this)'><img  src='images/contentTab/gengduo.png' /></span></div>";//'"docmd(16,"'+taskID+'")"'
                        var columnInfoImage = "<div class='startNowBtn'  style='width:18%;height:100%;display:block;float:left;' ><span class='otherBtn' style='float:right;' onclick='getMoreList(this)'><img  src='images/contentTab/gengduoex.png' /></span></div>";//'"docmd(16,"'+taskID+'")"'
                        var columnInfoStr = "<div class='programBtn'></div>";//声明变量存储栏目下的节目项
                        //节目项列表
                        //特殊约定：对于不想显示在界面上的节目项，比如跳转指令等，可以通过在任务名前加两个**进行标记，处理程序可根据该标记来决定显示不显示该节目项。
                        if ($(this).find("taskName").text().indexOf("**") >= 0) {

                        } else {
                            if ($(this).find("itemType").text().indexOf("14")>=0|| $(this).find("itemType").text().indexOf("1014")>=0) {
								content1 += "<div class='left' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + ">" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' mplayVol='" + mplayVol + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "'  ><span class='spanContent' style='padding-left:2%;display:block;width:75%;height:100%;float:left;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\"><p class='programFileName'>" + moreInfo2[0] + "</p><p class='timeLong' style='margin-top:0px;'><i style='font-size:12px;' class='infoProgram'><span  style='color:" + randomColor + "'>" + win + "</span>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + columnInfoImage + "</div></div><div class='left1' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + " style='display:none'></div>";
							} else if($(this).find("downLink").text().slice($(this).find("downLink").text().length-1).indexOf("\\")>=0){
								//var folderList="";

								content1 += "<div class='left' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + ">" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' mplayVol='" + mplayVol + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "'  ><span class='spanContent' style='padding-left:2%;display:block;width:75%;height:100%;float:left;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\"><p class='programFileName'>" + moreInfo2[0] + "</p><p class='timeLong' style='margin-top:0px;'><i style='font-size:12px;'><span style='color:" + randomColor + "'>" + win + "</span >-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + columnInfoImage + "</div></div><div class='left1' taskid='" + taskID + "' style='display:none'></div>";
								//var aaa=""
								console.log($(this).find("downLink").text()+"_"+itemType+"_"+getFileFolder($(this).find("downLink").text(),itemType))
								// getFileFolder($(this).find("downLink").text(),itemType);	
							}else {
                                if ($(this).find("markID").text().split("-")[1] > 0) {
									content1 += "<div style='display:none;' class='left' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + ">" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' mplayVol='" + mplayVol + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "'  ><span class='spanContent' style='padding-left:2%;display:block;width:75%;height:100%;float:left;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\"><p class='programFileName'>" + moreInfo2[0] + "</p><p class='timeLong' style='margin-top:0px;'><i style='font-size:12px;' class='infoProgram'><span  style='color:" + randomColor + "'>" + win + "</span>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + inImage + "</div></div>" + otherButton + "<div class='left1' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + " style='display:none'></div>";
                                } else {
									content1 += "<div class='left' taskid='" + taskID + "'>" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' mplayVol='" + mplayVol + "' taskId='" + taskID + "' itemType='" + itemType + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "'  ><span class='spanContent' style='padding-left:2%;display:block;width:75%;height:100%;float:left;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + itemType + "',this);\"><p class='programFileName'>" + moreInfo2[0] + "</p><p class='timeLong' style='margin-top:0px;'><i style='font-size:12px;' class='infoProgram'><span  style='color:" + randomColor + "'>" + win + "</span>-" + Win.split(":")[0].split("-")[1] + "&nbsp;&nbsp;</i>" + newMoreInfo + "</p></span>" + inImage + "</div></div>" + otherButton + "<div class='left1' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + " style='display:none'></div>";
                                }
                                
                            }
                        }
                       
					});
					var strNum=parseInt($("#tabscreen").attr("indexnumber"));
					contentStr[strNum]=content1;
					$("#Screen").html(content1);
					
					$(".loadpng").attr("screenWidth",screenWidth);
					$(".loadpng").attr("screenHeight",screenHeight);
					//获得焦点的项目样式改变
					changeStyle();
					if(conDragScreen){
						dragScreen();
					}//甩屏 在此处调用原因是：当前页面节目项列表刚好加载完成，甩屏的事件也正是在节目项上绑定的
					//全局控制按钮
                    controlAll = "<ul src='" + URL + "'><li onclick='docmd(69,0)'>手动模式</li><li class='sendCmd' onclick='docmd(11,0)' >" + getLanguageMsg("启动节目", $.cookie("yuyan")) + "</li><li class='sendCmd' onclick='docmd(70,0)'>" + getLanguageMsg("停止节目", $.cookie("yuyan")) + "</li><li cmdStr='' title='sound'><input id='range' type='range' min='0' max='255' value='' onchange='change(\'range\',\'value\')'></input><span id='value'>5</span></li><li class='sendCmd' id='preTask' onClick='docmd(\'before\',0)'>" + getLanguageMsg("上一节目项", $.cookie("yuyan")) + "</li><li class='sendCmd' id='nextTask' onClick='docmd(\'next\',0)'>" + getLanguageMsg("下一节目项", $.cookie("yuyan")) + "</li><li class='sendCmd' onclick='docmd(21,0)'>" + getLanguageMsg("暂停/继续", $.cookie("yuyan"))+"</li></ul>";
					//显示系统音量
					$("#range").val(systemSound);
					$("#value").html(systemSound);
					$("#range2").val(mplayVol);
					$("#value2").html(mplayVol);
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
			hideLoading();
			//将新的数据请求完毕之后将新的数据置为旧的数据，方便下次比较
			oldData=$(xml).text();
		}
	});
	
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
					//docmd(67,'"+taskID+"');
					var imagesrc="<span class='bgSpan' onclick=\"changeSize(this)\"><img src='"+iconLink+"' align='absmiddle' onerror='changeImage(this)'/></span>"//类型图片
					var downLink=subpath+dataStr.eq(i).find("l1").text();
					var playStatus=$(ele).parent().parent().parent().find(".leftList").attr("playStatus"); 
					var win=0;
					var systemSound=$(ele).parent().parent().parent().find(".leftList").attr("systemSound"); 
					var markID=taskID;
					var fileName=dataStr.eq(i).find("l1").text();
					var mplayVol=$(ele).parent().parent().parent().find(".leftList").attr("mplayVol");
					var win=$(ele).parent().parent().parent().find(".leftList").attr("windowsnum");
					var randomColor = color16(win);
					var otherButton="<div class='programBtn'></div>";
					var infoProgram = "<span class='infoProgram'>"+$(ele).parent().prev().find(".timeLong").html()+"</span>";
					var inImage = "<div class='startNowBtn'  style='width:18%;height:100%;display:block;float:left;' ><span  class='startNow' onclick=\"startNow(this,'" + taskID +"','"+1+"','"+$(ele).parent().parent().parent().attr('taskid')+"');\"><img  src='images/contentTab/bofang.png' class='playNowprogram'/></span><span class='otherBtn' onclick='getMoreList(this)'><img  src='images/contentTab/gengduo.png' /></span></div>";
					content2 += "<div style='display:none;' class='left folderList' taskid='" + taskID + "'>" + imagesrc + "<div class='leftList' iconLink='" + iconLink + "' mplayVol='" +  mplayVol+ "' taskId='" + taskID + "' parentid='"+$(ele).parent().parent().parent().attr('taskid')+"' itemType='" + tasktype + "' downLink='" + downLink + "' playStatus='" + playStatus + "' windowsNum='" + win + "'systemSound='" + systemSound + "'  ><span class='spanContent' style='padding-left:2%;display:block;width:75%;height:100%;float:left;color:#fff;' onclick=\"showCtrlBar('ctrlBar" + markID + "','" + taskID + "','" + tasktype + "',this);\"><p class='programFileName'>" + fileName+ "</p><p class='timeLong' style='margin-top:0px;'><i style='font-size:12px;'>"+infoProgram+"</i></p></span>" + inImage + "</div></div>" + otherButton+"<div class='left1' taskid='" + taskID + "' columId=" + $(this).find("markID").text().split("-")[2] + " style='display:none'></div>";
				}	
				 $(ele).parent().parent().parent().next().after(content2);
				//  if($(ele).parent().parent().parent().css("background")=="rgb(201, 236, 254) none repeat scroll 0% 0% / auto padding-box border-box"){
				// 	$(".folderList:odd").css("background","rgb(201, 236, 254)")
				// }else{
				// 	$(".folderList:even").css("background","rgb(201, 236, 254)")
				// }
				changeStyle2();
				changeStyle3();
				
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
//素材音量的显示还是隐藏
function meterialSound(thisSound){
	if($(thisSound).parent().parent().next().css("display")=="block"){
		$(thisSound).parent().parent().next().css("display","none");
	}else{
	    $(thisSound).parent().parent().next().css("display", "block");
	}
}
//专门为了获取音视频的播放状态，获取的方式和getData（）相同，只不过不再对其他的数据进行处理
function getRate(URL) {
	
	if(dragStart){return;}//判断是不是要进行拖拽的动作，若是则将获取进度的长连接终止掉
	if(sendding){return;}
	sendding=true;
	if(URL!=oldURL){//若改变url则将原来url所得到的数据去除
		$(".programList").children().remove();
	}
	if(socket!=null&&socket.readyState==1){
        socket.send("wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000));
	}else{
        connect();
		if(socket!=null&&socket.readyState==1){
            socket.send("wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000));
		   sendding=false;
                   return;
				   
		}
		//showLoading();
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
				var gGetPlayDuring=$(clientInfo).attr("playdur").split("_");
					gGetPlayDuring=parseInt(gGetPlayDuring[0]);
				var arrayTask = "";
				var currentTask = ""
				if (playTask == undefined || playTask == "") {
					arrayTask = "";
				} else {
					arrayTask = playTask.split("/");
					currentTask = arrayTask[1];//获得当前播放节目的id
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
				
				if (objValid[1] != "" && objValid[1] != null) {
				    if (objValid[1].split("_")[1] == "0") {
				        mplayVol = "0";
				    } else {
				        mplayVol = objValid[1].split("_")[0];
				    }

				}
				var playState = $(clientInfo).attr("playstate");
				var playOrPause = "";
				var playStart = ""
				if (playState != null && playState != undefined) {
					playOrPause = playState.split("_");
					playStart = playOrPause[0];
				}
				changPlayStatus(playStart);
				$("#rateProgress").attr("max",gGetPlayDuring);
				if(menuState!=oldmenuState){
					changeMenuState(menuState);
				}
				
				$("#rangeRate1").attr("max",gGetPlayDuring);
				var strs=parseFloat($("#rangeRate1").css("width"));
				$("#rateProgressValue").html(secondToMinute((playProc1 / 10000) * strs));
			//	hideLoading();
			}
           
		});
	}
	sendding=false;
}
var tmpItem="";//特殊标记，标记是否点击了上一项下一项
//点击立即启动按钮
function startNow(thisItem,taskId,folder,parentId){
	var winNum=parseInt($("#tabscreen").attr("nowwindow"));
	var itemType=$(thisItem).parent().parent().attr("itemtype").split("-")[1].toLowerCase();
	if(changeSizeCommon(itemType)){
		if(folder==undefined){
			if(tmpItem==""){
				docmd(16,taskId);
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
			if($(".stopProgram").attr("src").indexOf("Selected")>=0){
				docmd(67,taskId);
			}else{
				docmd(16,taskId);
			}
		}else{
			if($(".stopProgram").attr("src").indexOf("Selected")>=0){
				docmd(67,parentId);		
			}else{
				docmd(16,parentId);
			}
			docmd(3079+10000*parseInt($("#tabscreen").attr("nowwindow")),taskId);
		}
	}
	tmpItem=""
}
//给下载和预览的按钮赋值
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
function changeStyle2(){
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
		
    } else {
        $(".programList .left").css("height", "13%");
        $(".bgSpan").css("width", "10%");
        $(".bgSpan").css("height", $("#tabscreen .programList .left").width() * 0.1 + "px");
        $(".bgSpan").css("marginTop", ($(".leftList").height() - $(".bgSpan").height()) / 2);
        $(".bgSpan img").css("marginLeft", "10%");
        $(".bgSpan img").css("height", $(".bgSpan img").css("width"));
        $(".bgSpan img").css("marginTop", ($(".bgSpan").height() - $(".bgSpan img").height()) / 2);
		$(".startNowBtn img").css("width","60%");
		$(".startNowBtn img").css("marginLeft","20%");
		$(".main").css("marginTop", "3px");
		$(".main").css("height", document.documentElement.clientHeight - $(".top").height() - parseInt($(".main").css("marginTop")) - $(".bottom").height());
		
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
	liSpanH=$(".controlBottomTab li span").height();
	bH=$(".controlBottomTab li b").height();
	$(".topMain .programList .left .leftList span").css("width",leftSpanW);
	
	var bottomImgH = $(".pictures li img").height();
	var downFileH=$(".downFile b").height();
	var pptH=$(".pptcontrolBottomTab li img").height();
	$(".bottom .fileName").css("lineHeight",bottomH+"px");
	
	$(".start").css("marginTop",($(".controlBottomTab").height()-$(".start").height())/2);
	$("#startPPT").css("marginTop",(bottomH-$("#startPPT").height())/2);
	
	$(".startNowBtn img").css("marginTop",startImg);
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
	    var ipyyy = $("#top .cc").eq(i).find("span").text();
	    var ipyy1 = ipyyy.split("192");
	    $("#top .cc").eq(i).find("span").html(ipyy1[0]);
	}
}
//对动态加载进来的数据进行样式的修改
function changeStyle(){
	changeStyle2();
		//显示更多操作选项
	changeStyle3();
}
function getMoreList(thisList){
	
}
function getMoreList(thisList){
	if($(".folderList").length<=0){
		getFileFolder(thisList,$(thisList).parent().parent().attr("downlink"),$(thisList).parent().parent().attr("itemtype"));		
	}
	if ($(thisList).parent().parent().attr("itemtype").indexOf("14")>=0|| $(thisList).parent().parent().attr("itemtype").indexOf("1014")>=0) {
		for (var i = 0; i < $(".left").length; i++) {
			if ($(".left").eq(i).attr("columid") == $(thisList).parent().parent().parent().attr("taskid")) {
				if ($(".left").eq(i).find(".leftList").attr("itemtype").indexOf("14")<0&& $(".left").eq(i).find(".leftList").attr("itemtype").indexOf("1014")<0) {
					if ($(".left").eq(i).css("display") == "none") {
						$(".left").eq(i).slideDown("slow");
						$(thisList).find("img").attr("src", "images/contentTab/gengduoex1.png");
					} else {
						$(".left").eq(i).slideUp("slow");
						$(thisList).find("img").attr("src", "images/contentTab/gengduoex.png");
					}
				}
			}
		}
	} else {
		if($(thisList).parent().parent().attr("downlink").slice($(thisList).parent().parent().attr("downlink").length-1).indexOf("\\")>=0){
			if($(".folderList").length<=0){
				$(thisList).find("img").attr("src", "images/contentTab/gengduoex1.png");
				setTimeout(function(){
					if($(".folderList").css("display")=="none"){							
						$(".folderList").slideDown("slow");						
					}else{
						$(".folderList").slideUp("slow");
						$(thisList).find("img").attr("src", "images/contentTab/gengduoex.png");
					}
				},1000);
			}else{
				if($(".folderList").css("display")=="none"){
					$(".folderList").slideDown("slow");
					$(thisList).find("img").attr("src", "images/contentTab/gengduoex1.png");
				}else{
					$(".folderList").slideUp("slow");
					$(thisList).find("img").attr("src", "images/contentTab/gengduoex.png");
				}
			}	
		}else{
			if ($(thisList).parent().parent().parent().next(".programBtn").css("display") == "none") {
				$(".programBtn").slideUp("slow");
				$(thisList).parent().parent().parent().next(".programBtn").slideDown("slow");
				$(thisList).parent().prev().click();
				fileDownLoad(thisList);
			} else {
				$(thisList).parent().parent().parent().next(".programBtn").slideUp("slow");
			}
		}
		
	}
}
function changeStyle3(){
	$(".leftList .spanContent").click(function(){
		//点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
		//节目项控制和全局控制的内容也得到相应的改变
		$(".leftList .spanContent").css("color","#fff");
		$(".leftList .timeLong").css("color", "#f2f2f2");
	    //$(".main .programList .left:even").css("background", "#c9ecfe");
		$(this).parent().addClass("current");
		$(this).parents().siblings().find(".leftList").removeClass("current");
		  $(this).css("color","#846eff");
		$(".start").attr("src","images/bottomTag/zantingda.png");
	  })
	  //点击当前列表的立即播放按钮，则当前列表的样式跟着改变，焦点定位到当前的点击的列表行
	  $(".leftList .startNow").click(function(){
		  //点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
		//节目项控制和全局控制的内容也得到相应的改变
		//$(".leftList span").css("background","#fff");
		$(".leftList .spanContent").css("color","#fff");
		$(".leftList .timeLong").css("color", "#f2f2f2");
	   // $(".main .programList .left:even").css("background", "#c9ecfe");
		$(this).parent().parent().addClass("current");
		$(this).parents().siblings().find(".leftList").removeClass("current");
		$(this).parent().prev().click();
		  $(this).parent().parent().find(".spanContent").css("color","#846eff");
		$(this).parent().parent().parent().css("color","#fff");
		$(this).parent().parent().addClass("current");
		$(this).parents().siblings().find(".leftList").removeClass("current");
		$(".start").attr("src","images/bottomTag/zantingda.png");
	  });
	  //点击全屏播放时，当前的行的样式跟随改变
	  $(".bgSpan img").click(function () {
		  //点击切换节目时，会将正在点击的节目项添加'current'类名，同时将其他节目的'current'去掉，同时将正在点击的节目设置样式。
		  //节目项控制和全局控制的内容也得到相应的改变
		  $(".leftList .spanContent").css("color", "#fff");
		  $(".leftList .timeLong").css("color", "#C9D6D8");
		 // $(".main .programList .left:even").css("background", "#f2f2f2");
		  $(this).parent().parent().addClass("current");
		  $(this).parents().siblings().find(".leftList").removeClass("current");
		  $(this).parent().next().find(".spanContent").click();
		  $(this).parent().parent().find(".spanContent").css("color", "#846eff");
		  $(this).parent().parent().parent().css("color", "#fff");
		  $(this).parent().parent().addClass("current");
		  $(this).parents().siblings().find(".leftList").removeClass("current");
		  $(".start").attr("src", "images/bottomTag/zantingda.png");
	  })
	  $(".controlBottomTab").height("21px");
	  $(".pptcontrolBottomTab li img").css("marginTop", (80 - $(".pptcontrolBottomTab .before").width()) / 2);
	  $(".picturecontrolBottomTab li .image").css("marginTop", (80 - $(".picturecontrolBottomTab .before").width()) / 2);
	  
  
	  $(".showRate .start").css("marginTop", "0px");
}
//判断当前的列表是那种类型，根据当前的类型显示不同的操作按钮
function showCtrlBar(barID,taskID,itemtype,thisList){
	itemtype=parseInt(itemtype.split("-")[0]);
	var flag = 0;
	var downLink = "";
	
	var imageUrl=$(thisList).parent().prev(".bgSpan").find("img").attr("src");
	var fileName=$(thisList).find(".programFileName").text();
	downLink=$(thisList).parent().attr("downlink");
	var nowWindow = $(".left").find(".leftList[taskId='" + taskID + "']").attr("windowsNum");
	getRate(newurl);
	$("#tabscreen").attr("nowWindow",nowWindow);
	$("#functionButton .images").attr("src", imageUrl);
	//切换时先将之前的socket清除，防止之前的socket一致连接影响接下来的操作
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
    if (itemtype == 10 || itemtype == 1010 || itemtype == 9 || itemtype == 1009 || itemtype == 7 || itemtype == 1007) {
        clearInterval(timer);
        var playOrPause = $("thisList").attr("playStatus");
        changPlayStatus(playOrPause);
        $(".picture").css("display", "none");
        $(".ppt").css("display", "none");
        $(".musicOrVideo").css("display", "block");
        $("#functionButton .fileName1").html(fileName);
        var bottomH1 = $(".bottom").height();
        var rateH = $("#rateProgress").height();
        var fil1H = $(".fileName1").height();
        var bottomH = $(".bottom").height();
        $(".showRate").css("marginTop", (bottomH1 - rateH - 50 - 10) / 2);
        var str1 = videoStr(hrefDownLoad, href);

        $(thisList).parent().parent().next().html(str1);
        $(thisList).parent().parent().next().find("#value2").html($(thisList).attr("mplayVol"));
        timer = setInterval("getRate(newurl)", 1000);
        $(".controlBottomTab li img").css("marginTop", ($(".controlBottomTab").height() - $(".controlBottomTab .before").width()) / 2)

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
            var bottomH = $(".bottom").height();
            var imageMargin = (bottomH - liSpanH - bH) / 2;
            var str1 = pptStr(hrefDownLoad, href)
            $(thisList).parent().parent().next().html(str1);
        } else {//除了ppt和pptx的office文档当做图类型处理片
            clearInterval(timer);
            $(".musicOrVideo").css("display", "none");
            $(".ppt").css("display", "none");
            $(".picture").css("display", "block");
            $("#functionButton .fileName").html(fileName);
            var bottomH = $(".bottom").height();
            var imageMargin = (bottomH - liSpanH - bH) / 2;
            var str1 = picStr(hrefDownLoad, href);
            $(thisList).parent().parent().next().html(str1);
        }
    }//对文档进行处理
    else if (itemtype == 1 || itemtype == 1001 || itemtype == 2 || itemtype == 1002 || itemtype == 5 || itemtype == 1005 || itemtype == 6 || itemtype == 1006 || itemtype == 7 || itemtype == 1007) {
        clearInterval(timer);
        $(".musicOrVideo").css("display", "none");
        $(".ppt").css("display", "none");
        $(".picture").css("display", "block");
        $("#functionButton .fileName").html(fileName);
        var bottomH = $(".bottom").height();
        var imageMargin = (bottomH - liSpanH - bH) / 2;
        var str1 = picStr(hrefDownLoad, href);
        $(thisList).parent().parent().next().html(str1);

    } else if (itemtype == 14 || itemtype == 1014) {//指令
        $(".musicOrVideo").css("display", "none");
        $(".ppt").css("display", "none");
        $(".picture").css("display", "none");
    } else {
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
	
	$(".startUp").removeAttr("onclick");
	// $(".startUp").attr("onclick", "startNow('"+taskID+"','1','"+$(thisList).parent().attr("parentid")+"')");
	$(".startUp").click(function(){
        $(".current .playNowprogram").click();
    })
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
    

}
//音视频的控制按钮
function videoStr(hrefDownLoad1, href1){
    return '<ul><li><img src="../images/contentTab/yinliang.png" class="materialSound soundNum" onclick="meterialSound(this);"/></li><li><img src="../images/contentTab/danru.png" class="soundIn" onclick="docmdex(3041,0);" ><li><img src="../images/contentTab/danchu.png" class="soundOut" onclick="docmdex(3041,254);"></li><li><img src="../images/contentTab/kongzhi.png" class="controlLab" onclick="docmdex(3008,0);" /></li><li><img src="../images/contentTab/playScreen.png" class="playScreenProgram" onclick="playScreenProgram()"/></li><li><img src="../images/contentTab/tingzhiPlayScreen.png" class="stopScreenProgram" onclick="stopScreenProgram()"/></li><li><img src="../images/contentTab/stopColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,34)"/></li><li><img src="../images/contentTab/startColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,35)"/></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '"><img src="../images/contentTab/yulan.png" class="checkIn"  onclick="checkFile(this)" /></a></li></ul><div id="meterial"><input id="range2" type="range" min="0" max="255" value="0" onchange="change(\'range2\',\'value2\')"><span id="value2">5</span></div>';
   

}
//图片的控制按钮
function picStr(hrefDownLoad1, href1) {
   
    return '<ul><li><img src="../images/contentTab/shangfan.png" class="page_up" onclick="docmd("keycode","0xFF55")"/></li><li><img src="../images/contentTab/xiafan.png" class="page_down"  onclick="docmd("keycode","0xFF9B")" /></li><li><img src="../images/contentTab/zuiqian.png" class="page_Home" onclick="docmd("keycode","0xFF50")"/></li><li><img src="../images/contentTab/zuihou.png" class="page_End" onclick="docmd("keycode","0xFF57")"/></li><li><img src="../images/contentTab/playScreen.png" class="playScreenProgram" onclick="playScreenProgram()"/></li><li><img src="../images/contentTab/tingzhiPlayScreen.png" class="stopScreenProgram" onclick="stopScreenProgram()"/></li><li><img src="../images/contentTab/stopColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,34)"/></li><li><img src="../images/contentTab/startColumn.png" class="stopScreenProgram" onclick="refreshColumn(this,35)"/></li><li><a id="downLoad" class="downFile" href="' + hrefDownLoad1 + '"><img src="../images/contentTab/xiazai.png" class="downLoad"/></a></li><li><a id="checkFile" class="downFile" href1="' + href1 + '" onclick="checkImageFile(this)"><img src="../images/contentTab/yulan.png" class="checkIn"   /></a></li></ul>';
	
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
function docmd(cmdtype, cmdData) {
	showLoading();
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
			error: function (xml) {
				hideLoading();
					//timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);		//失败报错
				topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")),2);
			},
			success: function (xml) {
				hideLoading();
				if (xml) {
					if(xml.indexOf("501")>=0){
						topTrip("平板操控功能未授权")
					}else{
						 if (cmdType.indexOf("3009") < 0 || cmdType.indexOf("29") < 0 || cmdType.indexOf("3001") < 0) {
							topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
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
					//timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);		//失败报错
					topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")),2);
				},
			success: function (xml) {
				hideLoading();
				if(xml){
					if(xml.indexOf("501")>=0){
						topTrip("平板操控功能未授权")
					}else{
						topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
					}
					
				}
			}
		});
	}
	//点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
	if(cmdtype==13){
	var ele=$(".current").parent().next().next().next();
	ele.find(".leftList").addClass("current").find(".startNow").click();
	ele.prev().find(".leftList").removeClass('current');
	}
	if(cmdtype==14){
		var ele=$(".current").parent().prev().prev().prev();
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
    if (cmdtype == "before") {
		var ele = $(".current").parent().prev().prev().prev();
		tmpItem="before";
		if(ele.length!=0){
			ele.find(".leftList").addClass("current").find(".startNow").click();
			ele.next().find(".leftList").removeClass('current');
		}  else{
			hideLoading();
		}
    }
    if (cmdtype == "next") {
		var ele = $(".current").parent().next().next().next();
		tmpItem="next";
		if(ele.length!=0){
			ele.find(".leftList").addClass("current").find(".startNow").click();
			ele.prev().find(".leftList").removeClass('current');
		} else{
			hideLoading();
		} 
    }
}
//发送指令函数 只要是针对全屏播放时
function docmd1(cmdtype, cmdData) {
    showLoading();
    var screenType = cmdData;
    if ($(".allScreenBtn").attr("allscreen") == "open") {
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
            error: function (a, b, c) {
                hideLoading();
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                } else {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                }
            },
            success: function (xml) {
                hideLoading();
                if (xml) {
                    //timeShowMsg("title","发送成功",500);		//发送成功
					if(xml.indexOf("501")>=0){
						topTrip("平板操控功能未授权")
					}else{
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
                hideLoading();
                if (b == "timeout") {
                    getLanguageMsg("请求超时,请重试");
                } else {
                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                }
            },
            success: function (xml) {
                hideLoading();
                if (xml) {
					if(xml.indexOf("501")>=0){
						topTrip("平板操控功能未授权")
					}else{
						//timeShowMsg("title","发送成功",500);		//发送成功
						topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
					}
                }
            }
        });
    }
    
    //点击上一节目项，下一节目项，将当前节目的'current'去掉，将上一节目项/下一节目项添加上'current'
	if(cmdtype==13){
		var ele=$(".current").parent().next().next().next();
		ele.find(".leftList").addClass("current").find(".startNow").click();
		ele.prev().find(".leftList").removeClass('current');
	}
	if(cmdtype==14){
		var ele=$(".current").parent().prev().prev().prev();
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
	if (cmdtype == "before") {
		var ele = $(".current").parent().prev().prev().prev();
		tmpItem="before";
		if(ele.length!=0){
			ele.find(".leftList").addClass("current").find(".startNow").click();
			ele.next().find(".leftList").removeClass('current');
		}  else{
			hideLoading();
		}
	}
	if (cmdtype == "next") {
		var ele = $(".current").parent().next().next().next();
		tmpItem="next";
		if(ele.length!=0){
			ele.find(".leftList").addClass("current").find(".startNow").click();
			ele.prev().find(".leftList").removeClass('current');
		} else{
			hideLoading();
		} 
	}
}
//双击
function twoMouse() {
	showLoading();
	var mouseUrl=newurl+"/wpsendkeys.asp?wpsendkeys=-mouseevent 129_-1_-1;0_-1_-1"
	$.ajax({
		url: mouseUrl,
		dataType:'html',
		type: 'GET',
		timeout: 5000,		//超时时间
		error: function (xml) {
			hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);		//失败报错
		},
		success:function(xml){
			if(xml){
				$.ajax({
					url: mouseUrl,
					dataType:'html',
					type: 'GET',
					timeout: 5000,		//超时时间
					error:function(xml){
							//timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);		//失败报错
							topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")),2);
						},
					success:function(xml){
						if(xml){
							if(xml.indexOf("501")>=0){
								topTrip("平板操控功能未授权")
							}else{
								topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
							}
						}
					}
				});
				if(xml.indexOf("501")>=0){
					topTrip("平板操控功能未授权")
				}else{
					topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
				}
			}
			hideLoading();
		}
		
	})
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
	   //var value2 = document.getElementById('range2').value ;
	  // document.getElementById(valuex).innerHTML = value2;
	   document.getElementById(valuex).innerHTML = value;
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
                if ($("#changeChannel").attr("menuPath")==path){
                   
                    if (index == 0) {
                        $("#channelList").append("<option value='" + name + "' selected>[**当前节目]" + name + "</option>");
                    } else {
                        $("#channelList").append("<option value='" + name + "' selected>" + name + "</option>");
                    }
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
			hideLoading();
		}
	});
		

}
//点击选择频道的li给input赋值
function changinputvalue(thisList) {
    $("#inpurChannelValue").val($(thisList).html().indexOf("[**当前节目]") >= 0 ? $(thisList).html().split("[**当前节目]")[1] : $(thisList).html());
    $("#ulChannelList").hide();
}
//一键切换所有终端频道 因为每个显示端都由一个配置文件连接到主控端，wiseSendInfo会自动连接到主控端，所以此时可以用相对路径
function allClientChannel() {
	showLoading();
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
		success: function (data) {
			hideLoading();
			if(data){
				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
				getData(newurl);
			}
		}, error: function (data) {
			hideLoading();
			topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")),2);
		}
	})
}
//手动全切
function allClientChannelHand() {
	showLoading();
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
		success: function (data) {
			hideLoading();
			if(data){
				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
				getData(newurl);
			}
		}, error: function (xml) {
			hideLoading();
			topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")),1);
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
    var index = $("#lightChangeColor .sendCmd").index(obj);
    if (index == 0) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
    }
    if (index == 1) {

        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#e8072c");
        $(obj).css("color", "#fff");
    } else if (index == 2) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#06e860");
        $(obj).css("color", "#fff");
    } else if (index == 3) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#074ae8");
        $(obj).css("color", "#fff");
    } else if (index == 4) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#e8e807");
        $(obj).css("color", "#fff");
    } else if (index == 5) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#c307e8");
        $(obj).css("color", "#fff");
    } else if (index == 6) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#07e8e8");
        $(obj).css("color", "#fff");
    } else if (index == 7) {
        $("#lightChangeColor .sendCmd").css("background", "#e6e6e6");
        $("#lightChangeColor .sendCmd").css("color", "#999");
        $(obj).css("background", "#fff");
        $(obj).css("color", "#000");
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
			//timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);		//失败报错
			topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")),2);
		},
		success: function (xml) {
			hideLoading();
			if(xml){
				if(xml.indexOf("501")>=0){
					topTrip("平板操控功能未授权")
				}else{
					topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
				}
			}
		}
	});
}
//文件预览 图片在页面中预览 可以放大和缩小也可以拖动，其他格式的素材预览需要新打开一个页面，这样保证不会受浏览器的限制不能预览素材
function checkFile(thishref){
	var fileSrc=$(thishref).parent().attr("href1");
	
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
function powerOff(clientNum) {
	
    var ccl = $("#top").attr("clientname");
	if ($(".topConfirm").attr("messageTip") == "ok") {
		showLoading();
        var errorURL = $("#tabscreen").attr("src");
        $.ajax({
            url: errorURL + "/wpsendclientmsg.asp?wpsendclientmsg=" + clientNum + "_" + (1000 + parseInt(clientNum)) + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000)+"&utf8=1",
            dataType: 'html',
            type: 'GET',
			success: function (data) {
				hideLoading();
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
			error: function (data) {
				hideLoading();
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + ccl + ";&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
            dataType: 'text',
            type: 'GET',
			success: function (data) {
				hideLoading();
                timeShowMsg("title", getLanguageMsg("发送成功", $.cookie("yuyan")), 500);
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
	
    if ($(".topConfirm").attr("messageTip") == "ok") {
		showLoading();
	    $.ajax({
	        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + ccl + ";&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	        dataType: 'text',
	        type: 'GET',
			success: function (data) {
				hideLoading();
	            topTrip("发送成功!", 1);
	            $(".topConfirm").attr("messageTip", "");
	        },
	        error: function (data) {
	           
	            $.ajax({
	                url: "wpcontrolcenter.asp?wpcontrolcenter=Turn-On TV&maintype=6&subtype=0&companyid=wisepeak&utf8=1&dohere=1&cnlist=noneed&commandparam=-f " + errorIp + ":" + errorMac + "&rnd=" + Math.random(9999),
	                dataType: 'text',
	                type: 'GET',
					success: function (data) {
						hideLoading();
	                    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
	                    $(".topConfirm").attr("messageTip", "");
	                },
					error: function (data, XMLHttpRequest, textStatus, errorThrown) {
						hideLoading();
	                    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
	                    $(".topConfirm").attr("messageTip", "");
	                }
	            })
	        }
	    })
	} else {
	  tipMessage("确定要开机吗?", "powerOn");
	}
	
}
//创建模拟鼠标长连接，此处将两个长连接分开，目的是让两个实现的过程互不影响
function connectTouchStart(moveX, moveY) {
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
	
}
//创建长连接，该部分的长连接主要用于音视频的进度条
function connect() {
    var hosturl = "";
    if (newurl == "") {
        hosturl = window.location.href.split("//")[1].split("/")[0];
    } else {
        hosturl = newurl.split("//")[1];
	}
	if ($("#tabscreen").attr("nowwindow") == undefined) {
		$("#tabscreen").attr("nowwindow", 0);
	}
    var host = "ws://" + hosturl + "/wpgetxmlids.asp?gettype=9&win=" + parseInt($("#tabscreen").attr("nowwindow")) +"&utf8=1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
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
            $("#rangeRate1").attr("max", gGetPlayDuring);
			var reteWidth=parseFloat($("#rangeRate1").css("width"))-parseInt($("#rangeRate2").css("width"));
			var strs=parseFloat($("#rangeRate1").attr("max"));
			
			var dddty=(playProc1/10000)*strs/1000;
			rateLeft=parseFloat(dddty*reteWidth/(strs/1000));
			if(rateLeft>=reteWidth){
				rateLeft=0;
			}
			var playState = $(clientInfo).attr("playstate");
			var playOrPause = "";
			var playStart = ""
			if (playState != null && playState != undefined) {
				playOrPause = playState.split("_");
				playStart = playOrPause[0];
			}
			changPlayStatus(playStart);
			//console.log("1_" + secondToMinute((playProc1 / 10000) * strs));
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
			    
			}
			if (soundFlag <= 0) {
			  
			    $("#range2").val(mplayVol);
			    $("#value2").html(mplayVol);
			}
			
		}
		
		socket.onclose = function(){
			console.log("WebSocket closed!");
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
     
  }else{
	 //window.location.href=window.location.href.split("/")[0]+"newpctrl.html";
	 window.location.href = window.location.href.split("newmctrl")[0]+"newpctrl"+window.location.href.split("newmctrl")[1];

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
	   // console.log(exception);
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
			//console.log($("#rangeRate2").css("left"));            
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
function reStartWiseSendInfo() {
	showLoading();
	var thisLocal=localUrl.split(":8080")[0];
	var restartcnname=$("#top").attr("clientname");
	$.ajax({
		url:thisLocal+":8080/wpcontrolcenter.asp?wpcontrolcenter=sys internal command30&maintype=6&subtype=0&companyid=wisepeak&utf8=1&cnlist="+restartcnname+"&commandparam=-wisesendinfo restart",
		type:"get",
		dataType:"xml",
		success: function (data) {
			hideLoading();
			if(data.indexOf("501")>=0){
				topTrip("平板操控功能未授权")
			}else{
				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
			}
		},
		error: function (data) {
			hideLoading();
			timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);
		}
	})
}
//刷新、停止栏目
function refreshColumn(thisWin, num) {
	showLoading();
    var winId = (parseInt($(thisWin).parents(".programBtn").prev().find(".timeLong i").html().split("-")[0]) + 1).toString(16);
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=" + num + "_0x" + winId+"000000",
        type: "get",
        dataType: "xml",
		success: function (data) {
			hideLoading();
            if(data.indexOf("501")>=0){
				topTrip("平板操控功能未授权")
			}else{
				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
			}
        },
		error: function (data) {
			hideLoading();
            timeShowMsg("title", getLanguageMsg("发送失败", $.cookie("yuyan")), 500);
        }
    })
}

//全开
function openAll(type) {
	if ($(".topConfirm").attr("messageTip") == "ok") {
		showLoading();
		var str = '';
		var ipstr = "";
		for (var i = 0; i < $("#top .screenList").length; i++) {
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
				hideLoading();
				topTrip(getLanguageMsg(getLanguageMsg("发送成功", $.cookie("yuyan")), $.cookie("yuyan")), 1);
				$(".topConfirm").attr("messageTip", "");
			},
			error: function (data) {
				hideLoading();
				//timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);
				topTrip(getLanguageMsg(getLanguageMsg("发送失败", $.cookie("yuyan")), $.cookie("yuyan")), 2);
				$(".topConfirm").attr("messageTip", "");
			}
		})
    } else {
        tipMessage("确定要全开吗?", "openAll");
    }

}
//全关
function closeAll(type) {
	showLoading();
    var str1 = '';
    for (var i = 0; i < $("#top .screenList").length; i++) {
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
				hideLoading();
                //timeShowMsg("title",getLanguageMsg("发送成功", $.cookie("yuyan")),500);
                topTrip(getLanguageMsg(getLanguageMsg("发送成功", $.cookie("yuyan")), $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
			error: function (data) {
				hideLoading();
                //timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);
                topTrip(getLanguageMsg(getLanguageMsg("发送失败", $.cookie("yuyan")), $.cookie("yuyan")), 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
    } else {
        tipMessage(getLanguageMsg("确定要全关吗?", $.cookie("yuyan")), "closeAll");
    }

    //}

}

//一键开
function openClientAll() {
	if ($(".topConfirm").attr("messageTip") == "ok") {
		showLoading();
		
		$.ajax({
			//url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + str6 + "&commandparam=-f " + ipstr + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
			url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=*&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),			
data:{},
			dataType: 'html',
			type: 'GET',
			success: function (data) {
				hideLoading();
				topTrip(getLanguageMsg(getLanguageMsg("发送成功", $.cookie("yuyan")), $.cookie("yuyan")), 1);
				$(".topConfirm").attr("messageTip", "");
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
alert(XMLHttpRequest.readyState);
				hideLoading();
				//timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);
				topTrip(getLanguageMsg(getLanguageMsg("发送失败", $.cookie("yuyan")), $.cookie("yuyan")), 2);
				$(".topConfirm").attr("messageTip", "");
			}
		})
    } else {
        tipMessage("确定要全开吗?", "openClientAll");
    }

}
//一键关
function closeClientAll() {
	if ($(".topConfirm").attr("messageTip") == "ok") {
		showLoading();
		
		//var truthBeTold = window.confirm("确定要关机吗?");
		//if (truthBeTold) {
	
        $.ajax({
            //url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + str5 + "&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
		url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=*&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),		
data:{},            
dataType: 'html',
            type: 'GET',
			success: function (data) {
				hideLoading();
                //timeShowMsg("title",getLanguageMsg("发送成功", $.cookie("yuyan")),500);
                topTrip(getLanguageMsg(getLanguageMsg("发送成功", $.cookie("yuyan")), $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            },
			error: function (data) {
				hideLoading();
                //timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);
                topTrip(getLanguageMsg(getLanguageMsg("发送失败", $.cookie("yuyan")), $.cookie("yuyan")), 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
    } else {
        tipMessage(getLanguageMsg("确定要全关吗?", $.cookie("yuyan")), "closeClientAll");
    }

}

//全关
// function closeClientAll() {
// 	showLoading();
//     var str1 = '';
//     for (var i = 0; i < $("#top .screenList").length; i++) {
//         str1 += $(".screenList").eq(i).attr("clientname") + ";"
//     }
//     //var truthBeTold = window.confirm("确定要关机吗?");
//     //if (truthBeTold) {
//     if ($(".topConfirm").attr("messageTip") == "ok") {
//         $.ajax({
//             url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + str1 + "&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
//             dataType: 'text',
//             type: 'GET',
// 			success: function (data) {
// 				hideLoading();
//                 //timeShowMsg("title",getLanguageMsg("发送成功", $.cookie("yuyan")),500);
//                 topTrip(getLanguageMsg(getLanguageMsg("发送成功", $.cookie("yuyan")), $.cookie("yuyan")), 1);
//                 $(".topConfirm").attr("messageTip", "");
//             },
// 			error: function (data) {
// 				hideLoading();
//                 //timeShowMsg("title",getLanguageMsg("发送失败", $.cookie("yuyan")),500);
//                 topTrip(getLanguageMsg(getLanguageMsg("发送失败", $.cookie("yuyan")), $.cookie("yuyan")), 2);
//                 $(".topConfirm").attr("messageTip", "");
//             }
//         })
//     } else {
//         tipMessage(getLanguageMsg("确定要全关吗?", $.cookie("yuyan")), "closeAll");
//     }

//     //}

// }



//发送指令函数,用来处理和窗口号有关的指令
function docmdex(cmdtype, cmdData) {
    var cmdTypeNum = 10000 * parseInt($("#tabscreen").attr("nowwindow")) + cmdtype;
    docmd(cmdTypeNum, cmdData);
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
       // window.location.href = window.location.href.split("/")[0] + "newmctrl.html";
    } else {
         window.location.href = window.location.href.split("/")[0] + "newpctrl.html";
    }
}
//拍照
function takePhoto() {
	showLoading();
    var photourl = $("#tabscreen").attr("src");
    photourl = photourl + "/wpsendclientmsg.asp?wpsendclientmsg=3049_1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
    $.ajax({
        url: photourl,
        dataType: 'text',
        type: 'GET',
        timeout: "3000",
		success: function (data) {
			hideLoading();
            if(data.indexOf("501")>=0){
				topTrip("平板操控功能未授权")
			}else{
				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")),1);
			}
        },
		error: function (a, b, c) {
			hideLoading();
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg(getLanguageMsg("发送失败", $.cookie("yuyan")), $.cookie("yuyan")), 2);
            }
        }
    })
}
//实现滑动实现甩屏播放功能
function dragScreen() {
	var oDiv = "";
	var dragScreenx = 0;
	var dragScreeny = 0;
	var oldMoveX = 0;
	var oldMoveY = 0;
	var leftListDragW = 0;
	var leftListDragH = 0;
	var bgColor = "";
	var oldHeight = "";
	var thisHeight = 0;
	//此处用let声明变量，使i的作用域在for循环中，从而使for循环中的每一个列表都可以被注册事件
	for (let i = 0; i < document.getElementsByClassName("leftList").length; i++) {
		// if (i % 2 == 0) {
		document.getElementsByClassName("leftList")[i].getElementsByClassName("spanContent")[0].ontouchstart = function (evt) {
			//console.log($(this).find("span"));
			var oDiv = this;
			thisHeight = $(oDiv).parent().parent().height();
			bgColor = $(this).parent().css("background");
			oldHeight = $(this).parent().css("height");
			dragScreenx = 0;
			dragScreeny = 0;
			oldMoveX = $(oDiv).parent().parent().offset().left;
			oldMoveY = $(oDiv).parent().parent().offset().top;
			leftListDragW = $(".programList").width();
			leftListDragH = ($(".programList").height()) * 0.13;
			$(".dragShadow").show();
			//oDiv.parentNode.parentNode.nextSibling.nextSibling.style.display = "block";
			$(".left1").css("height", thisHeight);
			var boxRight = 0;
			oldMoveX = $(oDiv).parent().parent().offset().left;
			oldMoveY = $(oDiv).parent().parent().offset().top;
			oDiv.parentNode.parentNode.style.position = "absolute";
			//oDiv.parentNode.parentNode.style.background = bgColor == "" ? "#fff" : bgColor;
			oDiv.parentNode.parentNode.style.zIndex = 1006;
			oDiv.parentNode.parentNode.style.left = oldMoveX + "px";
			boxRight = ($(".top").width() - oldMoveX - leftListDragW);
			oDiv.parentNode.parentNode.style.right = boxRight + "px";
			oDiv.parentNode.parentNode.style.top = oldMoveY + "px";
			oDiv.parentNode.parentNode.style.width = leftListDragW + "px";
			oDiv.parentNode.parentNode.style.height = leftListDragH + "px";

			var startedx = evt.touches[0].clientX;
			var startedy = evt.touches[0].clientY;
			dragScreenx = startedx;
			dragScreeny = startedy;
			oDiv.click();
		},
		document.getElementsByClassName("leftList")[i].getElementsByClassName("spanContent")[0].ontouchmove = function (evt) {
			var oDiv = this;

			var deLeft = 0;
			var deTop = 0;
			oDiv.parentNode.parentNode.nextSibling.nextSibling.style.display = "block";
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
				//alert(oDiv.parentNode.parentNode.style.top);
			}
			oDiv.parentNode.parentNode.style.right = document.documentElement.clientWidth - parseInt(oDiv.parentNode.parentNode.style.left) - leftListDragW;
			dragScreenx = movex;
			dragScreeny = movey;
		},
		document.getElementsByClassName("leftList")[i].getElementsByClassName("spanContent")[0].ontouchend = function (evt) {
			var oDiv = this;

			var endx = evt.changedTouches[0].clientX;
			var endy = evt.changedTouches[0].clientY;
			//获取当前元素的taskid方便后面传值
			var thisDragId = oDiv.parentNode.getAttribute("taskid");

			if (parseInt(oDiv.parentNode.parentNode.style.top) <= 0) {//向上
				//startNow(thisDragId);
				playScreenContent("0-全屏窗口", thisDragId);
			} else if (parseInt(oDiv.parentNode.parentNode.style.left) <= -50) {
				$("#upload_File").click();
				console.log("打印");
				showPrint("1")
			} else if (parseInt(oDiv.parentNode.parentNode.style.left) > document.documentElement.clientWidth - parseFloat(oDiv.parentNode.parentNode.style.width) + 50) {
				$("#upload_File").click();
				console.log("上传");
				showPrint("0")
			} else if (parseInt(oDiv.parentNode.parentNode.style.top) > document.documentElement.clientHeight - parseFloat(oDiv.parentNode.parentNode.style.height)/2) {
				
				$(oDiv).next().find(".otherBtn").click();
				$(".programBtn").hide();
				var downHref = $(oDiv).parent().parent().next().find("#downLoad").attr("href");
				
				window.location = downHref;
			}
			$(".dragShadow").hide();
			oDiv.parentNode.parentNode.style.position = "";
			//oDiv.parentNode.parentNode.style.background = "";
			oDiv.parentNode.parentNode.nextSibling.nextSibling.style.display = "none";
			oDiv.parentNode.parentNode.style.left = 0;
			oDiv.parentNode.parentNode.style.right = 0;
			oDiv.parentNode.parentNode.style.zIndex = 0
			//增加此句会
			oDiv.parentNode.parentNode.removeAttribute("style");
			//oDiv.parentNode.parentNode.style.background = bgColor;
			oDiv.parentNode.parentNode.style.height=oldHeight
			if (Math.abs(endx - dragScreenx) <= 10 && Math.abs(endy - dragScreeny) <= 10) {
				oDiv.click();
			}
		}
	//}
	}
}


