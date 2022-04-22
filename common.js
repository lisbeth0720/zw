// JavaScript Document
//获取终端列表
var expreDate = 7;
var onlyoneCutScreen = 0;
//声明变量存储一键登录的cookie
var loginName = [];
//声明变量存储文字二维码的cookie
var loginName1 = [];
var loginNameStr = "";
var slidebar = 1;//设置一个标记，若当前的标记为0时，则应用下的按钮不显示
var widthRate = 0;//声明变量用来存储终端与移动设备的宽度的比率
var heightRate = 0;
var wholeSize = 0;
var touchStartTime1 = "";//双击事件第一次抬起的时间
var touchStartTime1 = "";//双击事件第二次按下的时间 
//获取终端列表
function getClientList(divClient) {
    showLoading();
	$.ajax({
		url:"clientList.xml?rnd="+(Math.floor(Math.random()*(9999-1000))+1000)+"&utf8=1",
		dataType:"xml",
		type:'GET',
        success: function (xml) {

			$(xml).find("item").each(function(i){
				var clientName=$(this).find("name").text();
                var ipName = $(this).find("ip").text();
                var port = $(this).find("port").text();
                var color = $(this).find("color").text();//颜色值
                var onlyview = $(this).find("onlyview").text();//是否是只允许预览
                var usegate = $(this).find("usegate").text();//是否是多个服务器进行转发指令
                var gateip = $(this).find("gateip").text();//进行转发的多个服务器的ip地址，以;分割
                var gateport = $(this).find("gateport").text();//目的服务器的显示端的端口号
				if(ipName.indexOf(":")>0){
					ipName="http://"+ipName;
				}else{
					ipName="http://"+ipName+":8080";
				}    
				var macName=$(this).find("mac").text();
				var clientNameListStr='';
				var strIp = " ";
                if (divClient == "#top") {
                    strIp = '<p style="clear:both; color:#b9b9b9;font-size:12px;text-align:center;position:relative;top:-46px;text-align:right;">' + ipName.split("://")[1].split(":")[0] + '&nbsp;</p>';
                    clientNameListStr = '<li class="cc" port="' + port+'" color="' + color + '" onlyview="' + onlyview + '" usegate="' + usegate + '" gateip="' + gateip + '" gateport="' + gateport+'" src="' + ipName + '" indexClient="' + i + '" macname="' + macName + '" clientname="' + clientName + '"><b style="height: 28px;width:28px;display:block;float:left;margin-left:5px;margin-right:5px;"></b><span style="display:block;float:left;text-overflow: ellipsis;overflow: hidden;">' + clientName + '</span>' + strIp + '</li>';
					
				}else{
                    clientNameListStr = '<li class="cc" port="' + port +'" color="' + color + '" onlyview="' + onlyview + '" usegate="' + usegate + '" gateip="' + gateip + '" gateport="' + gateport +'" src="' + ipName + '" indexClient="' + i + '" macname="' + macName + '" clientname="' + clientName + '"><p>' + clientName +"<br>" + ipName.split("://")[1].split(":")[0] + '</p></li>';
				}
				$(divClient).append(clientNameListStr);
				$(".cc").eq(i).find("span").css("maxWidth",parseInt($(".cc").eq(i).css("width"))-28);
				$(".cc").eq(i).find("b").css("marginTop",(parseInt($(".cc").eq(i).css("height"))-28)/2);
				if (divClient == "#top") {
				    $(".cc span").css("maxWidth", (parseInt($(".cc").width()) - 20 - parseInt($(".cc b").width())) + "px");
				}
            });
            hideLoading();
			
        }, error: function (a, b, c) {
            //当没有终端列表时，则认为是只访问当前显示端的内容
            hideLoading();
			if(c=="Not Found"){
				if(divClient=="#top"){
					clientNameListStr='<li class="cc" homeid="home" src="" indexClient="" macname="" clientname=""><b style="height: 28px;width:28px;display:block;float:left;"></b><span id="localIP" style="display:block;float:left;text-overflow: ellipsis;overflow: hidden;">返回中控页</span></li>';
					
				}else{
                    clientNameListStr = '<li class="cc" id="localIP" homeid="home" src="" indexClient="" macname="" clientname="">返回中控页</li>';
				}
				$(divClient).html(clientNameListStr)
				$(".cc").find("span").css("maxWidth",parseInt($(".cc").css("width"))-28);
				$(".cc").find("b").css("marginTop",(parseInt($(".cc").css("height"))-28)/2);	
			}
		}
	});
	
}
//点击触控板盘
function touchPanel(){
	$(".touchMouse").css("display","block");
	$("#myCanvas2 span").css("lineHeight",$("#myCanvas2").height()+"px");
	$(".canvas3 .left").css("lineHeight",$(".canvas3 .left").height()+"px");
	$(".right span").css("marginTop", ($(".rightBottom").height() - $(".rightBottom span").height()) / 2);
	$(".right span p").css("lineHeight", $(".right span").height() + "px");
	$(".closeTouchMouse img").css("marginTop", ($(".closeTouchMouse").height() - $(".closeTouchMouse img").height()) / 2);
	$(".touchMouseTitle").css("lineHeight", $(".closeTouchMouse").height() + "px");
	$(".touchMouseTitle").css("marginLeft", ($(".closeTouchMouse").width() - $(".touchMouseTitle").width()) / 2)
}
//打开浏览器
function openClient() {
    showLoading();
	$.ajax({
		url:newurl+"/wpsendclientmsg.asp?wpsendclientmsg=102_http://www.satall.cn",
		dataType:'text',
		type: 'GET',
        success: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
		},
        error: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
		
    });
}
//关闭浏览器
function closeClient() {
    showLoading();
	$.ajax({
		url:newurl+"/wpsendclientmsg.asp?wpsendclientmsg=103",
		dataType:'text',
		type: 'GET',
        success: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);;
		},
        error: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
		
	});
}
//打开/关闭软键盘
function openKeyBoard() {
    showLoading();
	$.ajax({
		url:newurl+"/wpsendclientmsg.asp?wpsendclientmsg=101",
		dataType:'text',
		type: 'GET',
        success: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
		},
        error: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
		
	});
}
//新增紧急通知、紧急疏散、重启临时任务、停止临时任务、触发数据获取
function emergentInform(tasknum) {
    showLoading();
	$.ajax({
		url:newurl+"/wpsendclientmsg.asp?wpsendclientmsg="+tasknum,
		dataType:'text',
		type: 'GET',
        success: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
		},
        error: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
		
	});
}
//全开
function openAll() {
    showLoading();
    var str = '';
    var ipstr = "";
	for(var i=0;i<$("#top .cc").length;i++){
	    var ttstrarr;
	    var ttstr = "";
        var ttmac = "";
        if ($(".cc").eq(i).attr("clientname").indexOf("!$") < 0) {
            str += $(".cc").eq(i).attr("clientname") + ";"
        }
	    ttstrarr = $(".cc").eq(i).attr("src").split("://");
	    if (ttstrarr.length > 1) {
	        ttstr = ttstrarr[1];
	        ttstrarr = ttstr.split(":");
	        if (ttstrarr.length > 1) {
	            ttstr = ttstrarr[0];
	        }
	    }
	    ttmac = $(".cc").eq(i).attr("macname");
	    ipstr += (ttstr + ":" + ttmac) + ";";
	}
	$.ajax({
	    url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=45&companyid=wisepeak&utf8=1&cnlist=" + str + "&commandparam=-f " + ipstr + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	    data: "text",
	    dataType: 'text',
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
}
//控制室分发
function controlRoomDistribute() {
    showLoading();
    $.ajax({
        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=98&companyid=wisepeak&utf8=1&cnlist=",
        data: "text",
        dataType: 'text',
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
}
//全关
function closeAll() {   
	var str1='';
    for (var i = 0; i < $("#top .cc").length; i++){
        if ($(".cc").eq(i).attr("clientname").indexOf("!$") < 0) {
            str1 += $(".cc").eq(i).attr("clientname") + ";"
        }	
	}
    if ($(".topConfirm").attr("messageTip") == "ok") {
        showLoading();
	    $.ajax({
	        url: "wpcontrolcenter.asp?wpcontrolcenter=&maintype=5&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + str1 + "&commandparam=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	        dataType: 'text',
	        type: 'GET',
            success: function (data) {
                hideLoading();
	            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
	            $(".topConfirm").attr("messageTip", "");
	        },
            error: function (data) {
                hideLoading();
	            //timeShowMsg("title","发送失败",500);
	            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
	            $(".topConfirm").attr("messageTip", "");
	        }
	    })
	} else {
	    tipMessage(getLanguageMsg("确定要全关吗?", $.cookie("yuyan")), "closeAll");
	}
}
//LED开
function openLED(){
	var str='';
	for(var i=0;i<$("#top .cc").length;i++){
		
		str+=$(".cc").eq(i).attr("clientname")+";"
	}
    if ($(".topConfirm").attr("messageTip") == "ok") {
        showLoading();
	    $.ajax({
	        url: "wpsendudpdata.asp?wpsendudpdata=1000_0X3A0X300X300X310X300X300X300X420X300X300X300X300X310X300X300X300X310X330X450X0D0X0A&destip=&destport=6666&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	        data: "text",
	        dataType: 'text',
	        type: 'GET',
            success: function (data) {
                hideLoading();
	            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
	            $(".topConfirm").attr("messageTip", "")
	        },
            error: function (data) {
                hideLoading();
	            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
	            $(".topConfirm").attr("messageTip", "")
	        }
	    })
	} else {
	    tipMessage("确定要打开LED吗?", "openLED");
	}
} 
//LED关
function closeLED(){
	var str1='';
	for(var i=0;i<$(".cc").length;i++){	
		str1+=$(".cc").eq(i).attr("clientname")+";"
	}
    if ($(".topConfirm").attr("messageTip") == "ok") {
        showLoading();
	    $.ajax({
	        url: "wpsendudpdata.asp?wpsendudpdata=1000_0X3A0X300X300X310X300X300X300X420X300X300X300X300X310X300X300X300X320X330X440X0D0X0A&destip=&destport=6666&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
	        dataType: 'text',
	        type: 'GET',
            success: function (data) {
                hideLoading();
	            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
	            $(".topConfirm").attr("messageTip", "")
	        },
            error: function (data) {
                hideLoading();
	            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
	            $(".topConfirm").attr("messageTip","")
	        }
	    })
	} else {
	    tipMessage(getLanguageMsg("确定要关闭LED吗?", $.cookie("yuyan")), "closeLED");
	}
}
//LCD开
function openOrCloseLCD(type) {
    showLoading();
    var cn = $("#top").attr("clientname");
    $.ajax({
        url: "wpcontrolcenter.asp?wpcontrolcenter=" + type + "&maintype=6&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + cn + "&commandparam=-must&dohere=0",
        type: "get",
        dataType: "text",
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//发二维码
function SendMSGBar(id, type) {
    var arrys = [];
    var cookieStr = "";
    var selectcodeStr = "";
    
    var isShow = $("#" + id).css("display");
    var lastCode = $.cookie("codeContent");
	if(type=="show"){  //弹出输入框
	    $("#" + id).css({ left: ($(document).width() / 2) - ($("#" + id).width() / 2) });
	    $("#" + id).css("top", ($("body").height() - $("#SendMSGBar").height()) / 2);
	    $("#" + id).slideDown(200);
	    if (lastCode != null && lastCode != undefined && lastCode != "") {
	        if (lastCode.indexOf(",") >= 0) {
	            cookieStr = $.cookie("codeContent").split(",");
	            loginName1 = cookieStr;
	            for (var i = 0; i < cookieStr.length; i++) {
	                selectcodeStr += "<option value=" + cookieStr[i] + ">" + cookieStr[i] + "</option>";
	            }
	        } else {
	            loginName1.push($.cookie("codeContent"));
	            cookieStr = $.cookie("codeContent");
	            selectcodeStr += "<option value=" + cookieStr + ">" + cookieStr + "</option>"
	        }


	        $("#selectCode").html("<option value=''></option>" + selectcodeStr + "<option id='clearCookie' value='' onclick='clearCookie(\"codeContent\")'>清除</option>");
	    }
	}else if (type == "send" || type == "send1") {		//发送信息
	    //http://localhost:8081/wpsubmitmsg.asp?wpsubmitmsg=我爱你&icon=0&sid=过客&pmt= 
	    //wpsubmitmsg为发布的内容，icon为选择的头像0-30，sid为发布人自己标记，pmt为是否也在屏上悬浮显示（=0只参与网页中滚动显示，〉1表示消息在屏上显示）。
	
	    var wpsubmitmsg = $("#wpsubmitmsg").val();
	    var icon=$("#icon").val();
	    var sid=$("#sid").val();
	    var pmt = $("#pmt").prop('checked');
	    var pmtType1 = $("#pmt1").prop('checked');
	    var pmtType2 = $("#pmt2").prop('checked');
	    var pmtType = 0;
	    if(pmt==true){
		    pmt=1;
	    }else{
		    pmt=0;
	    }
	    if (pmtType1 == true) {
	        pmtType = 1;
	        $("#pmt2").prop('checked', false);
	    }
	    if (pmtType2 == true) {
	        pmtType = 2;
	        $("#pmt1").prop('checked', false);
	    }
        var url="";
        if (type == "send") {
            url = newurl + "wpsubmitmsg.asp?wpsubmitmsg=" + wpsubmitmsg + "&icon=" + icon + "&sid=" + sid + "&pmt=" + pmt + "&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
           
        } else {
            if (sid == "") {
                url = "wpdispqrmsg.asp?wpdispqrmsg=" + wpsubmitmsg + "&wpstyle=" + pmtType + "&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);

            } else {
                url = "wpdispqrmsg.asp?wpdispqrmsg=" + wpsubmitmsg + "&wpstyle=" + pmtType + "&utf8=1&wpdispjustmsg=" + sid + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
            }
           
        }
        getUrl(url);
	    //以下程序为存储cookie,最后一次的字符串存在第一位，cookie所存储的长度大于3个时，则将最先的一位去掉然后重新存储
        //例：取的值为 11,22,33， 此时输入44,则数组变为["44","11","22"],然后将此数组转成字符串后存储到cookie中，各个字符串以“,”分隔
        var newCookieArry = [];
        if ($.cookie("codeContent") != null && $.cookie("codeContent") != "" && $.cookie("codeContent") != undefined) {
            if ($.cookie("codeContent").indexOf(",") >= 0) {//则表明当前的cookie的 数据至少有两条
                var cookieName = $.cookie("codeContent").split(",");
                for (var i = 0; i < cookieName.length; i++) {//声明一个新的数组，如果新添加的数据和当前cookie的数组有不同的则正常添加至cookie,若有相同的则不向新数组中添加
                    if (cookieName[i] != $("#wpsubmitmsg").val()) {
                        newCookieArry.push(cookieName[i]);
                    } else {
                    }
                }

                if (newCookieArry.length > loginName1.length) {
                    loginName1 = newCookieArry;
                } else if (newCookieArry.length < loginName1.length) {//当新的数据与原有的数据有重合时用以下方式处理
                    newCookieArry.unshift($("#wpsubmitmsg").val());//此处的处理是就算数组中已有新添加的数据，则会将数组中的数据删除，将新添加的数据在最前显示
                    loginName1 = newCookieArry;
                } else if (newCookieArry.length = loginName1.length) {//当新的数据与原有数据没有重合时
                    loginName1.unshift($("#wpsubmitmsg").val());
                }
                if (loginName1.length > 3) {//如果数据的长度大于3则删除数组最后的一个元素即最开始添加的一条数据
                    loginName1.pop()
                }
                loginNameStr = loginName1.join(",");
                $.cookie("codeContent", loginNameStr);
            } else {
                if ($.cookie("codeContent") != $("#wpsubmitmsg").val()) {
                    loginName1.unshift($("#wpsubmitmsg").val());
                    loginNameStr = loginName1.join(",");
                    $.cookie("codeContent", loginNameStr);
                }
                
            }

        } else {
            $.cookie("codeContent", $("#wpsubmitmsg").val());
        }
	    $("#wpsubmitmsg").val("");
	    $("#" + id).slideUp(200);

	}else if(type=="cancel"){	//取消发送关闭窗口
		$("#"+id).slideUp(200);
	}
}
function changeContent() {
    if ($("#selectCode").val() == "") {
        clearCookie("codeContent");
    } else {
        $("#wpsubmitmsg").val($("#selectCode").val());
    }
   
}
//拍照
function takePhoto() {
    showLoading();
	var photourl=$("#tabscreen").attr("src");
		photourl=photourl+"/wpsendclientmsg.asp?wpsendclientmsg=3049_1&rnd="+(Math.floor(Math.random()*(9999-1000))+1000);
	$.ajax({
		url:photourl,
		dataType:'text',
		type: 'GET',
        success: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
		},
        error: function (data) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		}
	})
}
//启动显示端
function openOwnerClient() {
    showLoading();
	$.ajax({
		url: newurl+"/wpsendclientmsg.asp?wpsendclientmsg=31",
		dataType:'html',
		type: 'GET',
		timeout: 5000,		//超时时间
        error: function (xml) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		},
        success: function (xml) {
            hideLoading();
			if(xml){
			    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
			}
		}
		
	})
}
//重启显示端
function reopenClient() {
    showLoading();
	$.ajax({
		url: newurl+"/wpsendclientmsg.asp?wpsendclientmsg=31_31",
		dataType:'html',
		type: 'GET',
		timeout: 5000,		//超时时间
        error: function (xml) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		},
        success: function (xml) {
            hideLoading();
			if(xml){
			    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
			}
		}
		
	})
}
//右键
function rightMouse() {
    showLoading();
	var mouseUrl=newurl+"/wpsendkeys.asp?wpsendkeys=-mouseevent 132_-1_-1;0_-1_-1";
	$.ajax({
		url: mouseUrl,
		dataType:'html',
		type: 'GET',
		timeout: 5000,		//超时时间
        error: function (xml) {
            hideLoading();
				//timeShowMsg("title","发送失败",500);		//失败报错
		    topTrip(getLanguageMsg("发送是啊比", $.cookie("yuyan")), 2);
		},
        success: function (xml) {
            hideLoading();
			if(xml){
			    timeShowMsg("title", getLanguageMsg("发送成功", $.cookie("yuyan")), 500);		//发送成功
			    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
				
			}
		}
		
	})
}
//双击 连续发送两次左键
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
                    error: function (xml) {
                        hideLoading();
						topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
					},
                    success: function (xml) {
                        hideLoading();
						if(xml){
						    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
						}
					}
				});
				topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 2);
			}
		}
		
	})
}
//提示信息弹框
function topTrip(title,status){
    $(".topTrip").show();
    setTimeout('$(".topTrip").hide()', 1000);
    $(".topTripContent").css("marginTop", ($(".topTrip").height() - $(".topTripContent").height()) / 2);
	if(status==1){
	    $(".sendMessageImage").attr("src", "images/allTitle/sendMessage.png");
	    
	}else if(status==2){
	    $(".sendMessageImage").attr("src", "images/allTitle/sendFail.png");
	}
	$(".topTrip").css("marginLeft", ($(".top").width() - $(".topTrip").width()) / 2);
	$(".sendMessageStatus").html(title);
	$(".sendMessageImage").css("marginTop", ($(".topTripContent").height() - $(".sendMessageImage").height() - $(".sendMessageStatus").height()) / 2);
	$(".sendMessageImage").css("marginLeft", ($(".topTripContent").width() - $(".sendMessageImage").height()) / 2);
	$(".sendMessageStatus").css("lineHeight", $(".sendMessageStatus").height()+"px");
}
//打开选择视频源选项
function changeVideo(){
	$(".videoContent").css("display","block");
	$(".videoTK").css("marginTop",($(".videoContent").height()-$(".videoTK").height())/2);
	$(".commonSelect").css("marginTop",($(".videoTK").height()-$(".videoTitle").height()-1-$(".recScreen p").height()*2-$(".localCam").height()-2)/4);
	$(".recScreen p").css("marginTop",($(".videoTK").height()-$(".videoTitle").height()-1-$(".recScreen p").height()*2-$(".localCam").height()-2)/4);
	getIPName();
}
//打开选择音频源选项
function changeSound(){
	$(".musicContent").css("display","block");
	$(".musicTK").css("marginTop",($(".musicContent").height()-$(".musicTK").height())/2);
	$(".recScreen p").css("marginTop",($(".musicTK").height()-$(".musicTitle").height()-1-$(".recScreen p").height()*2-4)/3);
}
//选择视频源
function getVideoSource(thisValue) {
    showLoading();
	if(thisValue==99){
		$(".videoContent").css("display","none");
	}
	$.ajax({
		url:$("#tabscreen").attr("src")+"/wpplaycontrol.asp?wpplaycontrol=WiseRecScreen&command=33&utf8=1",
		data:{
			param:parseInt(thisValue)
		},
		type:"GET",
		dataType:"html",
		timeout: 15000,
        error: function (a, b, c) {
            hideLoading();
		    topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
		},
        success: function (xml) {
            hideLoading();
			if(xml){
			    topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
				$(".videoContent").css("display","none");
				
			}
		}
	})
}
//选择网络摄像头
function getIPName() {
    showLoading();
	$.ajax({
		url:"ipName.xml?rnd="+(Math.floor(Math.random()*(9999-1000))+1000)+"&utf8=1",		
		type:"GET",
		dataType:"xml",
		timeout: 15000,
        error: function (data) {
            hideLoading();
			topTrip("发送失败",2);
		},
		success:function(data){
			if(data){
				var str=""
				$(data).find("item").each(function(i){
					
					var valArr=$(this).find("val").text().split(".");
					var val1=parseInt(valArr[0]);
					var val2=parseInt(valArr[1]);
					var chxx=parseInt($(this).find("chxx").text());
					var val=val1<<24|val2<<16|(100+chxx);
					var name=$(this).find("des").text();
					str+='<option value="'+val+'">'+name+'</option>';
					
				})
				$(".netArr").html('<option value="" disabled selected hidden>'+getLanguageMsg("网络摄像头", $.cookie("yuyan"))+'</option>' + str);
            }
            hideLoading();
		}
	})
}
//当放大倍数改变时应执行的操作
function getNowSize(thisInput,num) { 
    if (num != undefined) {
        drawResizeImage(parseInt($(thisInput).val()) * (0.05), num); 
        $("#nowPictureSize").html($(thisInput).val());
    } else {
        drawResizeImage(parseInt($(thisInput).val()) * (0.05));
        $("#nowSize").html($(thisInput).val());
    }
    
}
//将放大的canvas显示到页面中
function drawResizeImage(size,numSize) {
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
//当canvas图片大小改变时，调用此函数
//size为放大缩小的倍数，float型，当页面第一次加载次函数时，size=0;可正负，负表示缩小
//当num==2时，说明当前函数是鼠标抬起时调用的
function drawImage(size,num) {
    if (onlyoneCutScreen == 0) {
        onlyoneCutScreen = 1;
    } else {
        return;
    }
    /*
        此处显示动态加载图片
    */
    $(".loadingDiv").css({
        "display": "block",
        "marginTop": (document.documentElement.clientHeight - 30) / 2
    });
    wholeSize = size;//将现在放大的倍数赋值给全局变量，方便以后使用
    $(".loadpng").css("display","block");
    $("#loadmask").css("display", "block");
    $(".slideImage").css("top", ($("#loadmask").height() - $(".slideImage").height() - $(".moreDrag").height() - $(".moreKeyBoard").height()) / 2);
    $(".moreDrag").css("top", parseFloat($(".slideImage").css("top")) + $(".slideImage").height());
    $(".moreKeyBoard").css("top", parseFloat($(".slideImage").css("top")) + $(".slideImage").height() + $(".moreDrag").height() + parseFloat($(".moreDrag").css("marginTop")));
    var ua = navigator.userAgent.toLowerCase();
   
    //对canvas图片动态装载的处理
    //对图片放大缩小时不对图片重新装载，如果之前在缓存中已经有一张截图也不进行重新装载
    if (size!=0 && screenimg != undefined && screenimg != 0) {
        var imgW = "";
        var imgH = "";
        var tmpscreenimg = screenimg;
            imgW = tmpscreenimg.width;
            imgH = tmpscreenimg.height;
        if (size != undefined) {
            if (Math.abs(size) == 0.1) {
                //allWidth为网页显示区域的宽度
                canvaswindowWidth = allWidth + (allWidth * size)
            } else {
                if (size == 0 && $("#points").val() != 0) {
                } else {
                    canvaswindowWidth = document.documentElement.clientWidth * (1 + size);
                }

            }
            allWidth = canvaswindowWidth;
        }
        document.getElementsByClassName("loadImage")[1].width = canvaswindowWidth;
        document.getElementsByClassName("loadImage")[1].height = imgH * canvaswindowWidth / imgW;
           
        /*
            此时图片加载完成，去掉动态加载图
        */
        $(".loadingDiv").css("display", "none");
        resizeCanvasSize(canvaswindowWidth, size);
        tempContext.drawImage(tmpscreenimg, 0, 0, canvaswindowWidth, imgH * canvaswindowWidth / imgW);
    }
    else {
        var tmpscreenimg = new Image();
        tmpscreenimg.src = newurl + "/wpgetscreen$.jpg?rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        var imgW = "";
        var imgH = "";
        tmpscreenimg.onload = function () {
            imgW = tmpscreenimg.width;
            imgH = tmpscreenimg.height;
            if (size != undefined) {
                if (Math.abs(size) == 0.1) {
                    //allWidth为网页显示区域的宽度
                    canvaswindowWidth = allWidth + (allWidth * size)
                } else {
                    if (size == 0 && $("#points").val() != 0) {
                    } else {
                        canvaswindowWidth = document.documentElement.clientWidth * (1 + size);
                    }

                }
                allWidth = canvaswindowWidth;
            }
            document.getElementsByClassName("loadImage")[1].width = canvaswindowWidth;
            document.getElementsByClassName("loadImage")[1].height = imgH * canvaswindowWidth / imgW;
            /*
                此时图片加载完成，去掉动态加载图
            */
            $(".loadingDiv").css("display", "none");
            resizeCanvasSize(canvaswindowWidth, size);
            tempContext.drawImage(tmpscreenimg, 0, 0, canvaswindowWidth, imgH * canvaswindowWidth / imgW);
            //图片的大小和canvas的大小保持一致
            if (screenimg != undefined && screenimg != 0) {
                delete screenimg;
                screenimg = tmpscreenimg;
            }
            else {
                screenimg = tmpscreenimg;
            }
        }
    }
    widthRate = screenWidth / $(".loadImage").eq(1).width();
    heightRate = screenHeight / $(".loadImage").eq(1).height();
    onlyoneCutScreen = 0;
}
//截屏，在平板上模拟鼠标在显示端的操作
// function getScreen(){
//     drawImage(0);
//     loadPicture(1);
//     canvaswindowWidth = document.documentElement.clientWidth;
//     $("#points").val(0);
//     $(".loadpng").css("left", "0px");
//     $("#nowSize").html("0");
// } 
function getLen(v){
	return Math.sqrt(v.x * v.x + v.y * v.y)
}
//笔触和拖动切换
//拖动不能在前端进行操作，但是可以实现点击的事件
//笔触可以在显示端操作在canvas的轨迹
function changeFlage(){
	if($(".moreDrag").attr("pentype")=="pen"){
		$(".moreDrag").attr("pentype","pendrag");
		  penFlag=1;
		$(".moreDrag").val("笔触");
		$(".moreDrag span").text("笔触");
		
	}else{
		$(".moreDrag").attr("pentype","pen");
		$(".moreDrag").val("拖动");
		penFlag=0;
		$(".moreDrag span").text("拖动");
	}
}
//放大截屏
function addSize(thisIndex){
	drawImage(0.1);
	$(thisIndex).attr("src","images/allTitle/addSelected.png");
	$(thisIndex).parent().next().find("img").attr("src","images/allTitle/minus.png");
}
//减小截屏
function minusSize(thisIndex){
	drawImage(-0.1);
	$(thisIndex).attr("src","images/allTitle/minusSelected.png");
	$(thisIndex).parent().prev().find("img").attr("src","images/allTitle/addSize.png");
}
//窗口尺寸相应改变（修改canvas大小）
function resizeCanvasSize(cwidth, csize) {//, cheight, csize
    $(".loadpng").css("width", cwidth);
	if(csize!=undefined){
	    //if(Math.abs(csize)>=0.1){
	    if (Math.abs(csize) >0) {
		    canvaswindowLeft = ($("#loadmask").width() - canvaswindowWidth) / 2;
		}else{
			canvaswindowLeft=parseInt($(".loadpng").css("left"))+(document.documentElement.clientWidth*(-csize))/2;
		//此处用这种方式写left的值是为了移动的时候可以准确算出当前的left值
		}
		canvaswindowTop = parseInt($(".loadpng").css("top"));
	} else {
	    canvaswindowLeft = ($("#loadmask").width() - cwidth) / 2;
	    canvaswindowTop == parseInt($(".loadpng").css("top")) - (cheight - loadpngH) / 2;
	    $(".loadpng").css("top", canvaswindowTop);
	    loadpngH = cheight;
	}
	//设置canvas的偏移量以便于在显示端精确定位到目前操作的坐标
	$(".loadpng").css("left", canvaswindowLeft);	
};

//窗口尺寸相应改变（修改canvas大小）
function resizeCanvasSize1(cwidth, csize) {//, cheight, csize
    $(".loadpng1").css("width", cwidth);
    if (csize != undefined) {
        if (Math.abs(csize) > 0) {
            canvaswindowLeft = ($("#checkPicture").width() - canvaswindowWidth) / 2;
        } else if (Math.abs(csize) == 0) {
            canvaswindowLeft = 0;
        }
        else {
            canvaswindowLeft = parseInt($(".loadpng1").css("left")) + (document.documentElement.clientWidth * (-csize)) / 2;
            //此处用这种方式写left的值是为了移动的时候可以准确算出当前的left值
        }
        canvaswindowTop = parseInt($(".loadpng1").css("top"));
    } else {
        canvaswindowLeft = ($("#checkPicture").width() - cwidth) / 2;
        canvaswindowTop == parseInt($(".loadpng1").css("top")) - (cheight - loadpngH) / 2;
        $(".loadpng1").css("top", canvaswindowTop);
        loadpngH = cheight;
    }
    //设置canvas的偏移量以便于在显示端精确定位到目前操作的坐标
    $(".loadpng1").css("left", canvaswindowLeft);
};

//将所截取的图片重新绘制到canvas中
function resetCanvas(number){
    canvas = document.getElementsByClassName("loadImage")[number];
	tempContext=canvas.getContext('2d');
}
//打开360->木马防火墙->系统防护->驱动防护（防止木马加载驱动获得系统权限）点关闭
//上述方法可防止模拟鼠标点击屏幕时不能点击的现象,若上述方式还是不能点击桌面，则需要手动关闭360，关闭后可点击
//$(document).ready(function(){
var date = new Date()
var date1 = 0;
var date2 = 0;
var doubleTouchStartX = 0;
var doubleTouchStartY = 0;
function loadPicture(num) {
    var oDiv = document.getElementsByClassName("loadpng")[1];
    var x = 0;
    var y = 0;
    var d = 0;
    var s = 1;
    var oldS1 = s;
    var startMoveX = 0;
    var startMoveY = 0;
    
    resetCanvas(num);
    //添加touchStart监听
    var _x_start, _y_start, _x_move, _y_move, _x_end, _y_end, left_start, top_start, moveleft, moveright;
    canvas.addEventListener('touchstart', function (evt) {
        var oldX1 = x;
        var oldY1 = y;
        var oldD1 = d;
        date = new Date();
       // $(".freshCanvas").html(date.getTime());
        date2 = date.getTime();
        //getS(evt)
        started = event.touches[0].clientX + "," + event.touches[0].clientY;
        //将在平板上读取的坐标以同样的比例放大到显示终端上同样的位置
        //此处使用screenX，使用clientX会出现误差
        //var moveX=parseInt((screenWidth/$(".loadImage").width())*(event.touches[0].screenX-canvaswindowLeft));
        var moveX = parseInt(widthRate * (event.touches[0].screenX - canvaswindowLeft));
        //此处减40目的是减去canvas距离包含canvas的div的头部的距离

        //var moveY = parseInt((screenHeight / $(".loadImage").height()) * (event.touches[0].clientY - canvaswindowTop));
        var moveY = parseInt(heightRate * (event.touches[0].clientY - canvaswindowTop));
        //var moveY = parseInt((screenHeight / $(".loadImage").height()) * (event.touches[0].screenY - canvaswindowTop));
        oldX = moveX;
        oldY = moveY;
        onemousemove = false;//根据此值来判断是否进行了touchmove操作
        historysendstr = "";
        //判断是否长连接已经建立并正在连接中，若是 则将当前的坐标发送给服务器端
        //若不是，则重新连接后再进行一次判断，判断成功后将当前的坐标发送给服务器端
        event.preventDefault(); //阻止滚动
        if (socket1 != null && socket1.readyState == 1) {//长连接已经连接
            dragStartjt = true;
            //将最后一个位置取出来,用lastMoveX和lastMoveY保存坐标
            lastMoveX = moveX;
            lastMoveY = moveY;
            startMoveX = lastMoveX;
            startMoveY = lastMoveY;
            if (event.targetTouches.length <= 1) {//单指
                if (penFlag == 0) {//单指拖拽
                    //里面实现拖拽的代码
                    dragStartjt = false;
                    _x_start = event.touches[0].screenX;
                    _y_start = event.touches[0].screenY;
                    left_start = $(".loadpng").css("left");
                    top_start = $(".loadpng").css("top");

                    //结束发送指令的操作
                } else {
                    socket1.send(targeturlhead + "129_" + moveX + "_" + moveY);//"129"为要执行touchStart事件，"1"为执行touchMove事件，"0"为执行touchEnd事件
                    //判断当前是否是需要同步画笔，以下进行此判断作用均是如此
                    if ($(".drawSync").attr("sync") == "sync") {
                        //同步画笔，实现显示端和平板书写的内容一致，以下此写法均是如此
                        tempContext.beginPath();
                        tempContext.moveTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);

                    }
                }
            } else if (event.targetTouches.length == 2) {//双指
                //alert(event.targetTouches.length);
                v = { x: event.touches[1].screenX - event.touches[0].screenX, y: event.touches[1].screenY - event.touches[0].screenY };
                prev = getLen(v);
                //var downS = getS(evt);
                dragStartjt = false;
                socket1.send(targeturlhead + historysendstr + "0_" + lastMoveX + "_" + lastMoveY);
            }
           
        } else {//长连接未连接
            dragStartjt = false;
            connectTouchStart(moveX, moveY);
            if (dragStartjt) {
                lastMoveX = moveX;
                lastMoveY = moveY;
                startMoveX = lastMoveX;
                startMoveY = lastMoveY
                if (event.targetTouches.length <= 1) {
                    if (penFlag == 0) {//单指拖动
                        //单指拖动执行的
                        dragStartjt = false;
                        //alert("bbbb");
                        _x_start = event.touches[0].screenX;
                        _y_start = event.touches[0].screenY;
                        left_start = $(".loadpng").css("left");
                        top_start = $(".loadpng").css("top");
                    } else {
                        socket1.send(targeturlhead + "129_" + moveX + "_" + moveY);//"129"为要执行touchStart事件，"1"为执行touchMove事件，"0"为执行touchEnd事件
                        //判断当前是否是需要同步画笔，以下进行此判断作用均是如此
                        if ($(".drawSync").attr("sync") == "sync") {
                            //同步画笔，实现显示端和平板书写的内容一致，以下此写法均是如此
                            tempContext.beginPath();
                            tempContext.moveTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);

                        }
                    }
                } else if (event.targetTouches.length == 2) {
                    v = { x: event.touches[1].screenX - event.touches[0].screenX, y: event.touches[1].screenY - event.touches[0].screenY };
                    prev = getLen(v);
                    //var downS = getS(evt);
                    dragStartjt = false;
                    socket1.send(targeturlhead + historysendstr + "0_" + lastMoveX + "_" + lastMoveY);
                }
            }
        }
    }, false);
    var reduceCount = 0;
    //添加touchmove监听，向服务器端发送指令的过程同touchstart相同
    canvas.addEventListener('touchmove', function (evt) {
        //var moveX=parseInt((screenWidth/$(".loadImage").width())*(event.touches[0].screenX-canvaswindowLeft));
        //var moveY = parseInt((screenHeight / $(".loadImage").height()) * (event.touches[0].clientY - canvaswindowTop));
        var moveX = parseInt(widthRate * (event.touches[0].screenX - canvaswindowLeft));
        var moveY = parseInt(heightRate * (event.touches[0].clientY - canvaswindowTop));
        //var moveY = parseInt((screenHeight / $(".loadImage").height()) * (event.touches[0].screenY - canvaswindowTop));

        //$("#test").html(moveX);
        lastedMoveX = lastMoveX;
        lastedMoveY = lastMoveY;
        lastMoveX = moveX;
        lastMoveY = moveY;
        currentX = event.touches[0].screenX;
        currentY = event.touches[0].screenY;

        if (true) {//表示当前是单指操作并且要执行画的动作
            if (event.targetTouches.length <= 1) {//到目前为止都是单指操作

                if (penFlag == 0) {//单指拖动
                    //拖动中识别单指的按下和抬起，考虑到手会轻微移动导致按下和抬起位置不一样，中间产生了move操作,这里对轻微的操作不认为是移动
                    if (onemousemove == false) {
                        if (Math.abs(startMoveX - moveX) <= 4 && Math.abs(startMoveY - moveY) <= 4) {
                            ;
                        }
                        else {
                            onemousemove = true;
                        }
                    }

                    dragStartjt = false;
                    var loadpngLeft = parseInt($(".loadpng").css("left"));//marginLeft  
                  
                    var offsetLeft = document.getElementsByClassName("loadpng")[0].offsetLeft;
                    _x_move = event.touches[0].screenX;
                    _y_move = event.touches[0].screenY;
                    // console.log("move",_x_move)
                    moveleft = parseFloat(_x_move) - parseFloat(_x_start) + parseFloat(left_start);
                    //moveright=
                    $(".loadpng").css("left", parseFloat(_x_move) - parseFloat(_x_start) + parseFloat(left_start) + "px");
                    $(".loadpng").css("right", (parseInt(document.documentElement.clientWidth) - canvaswindowWidth - parseInt($(".loadpng").css("left"))) - 2 + "px");

                    $(".loadpng").css("top", parseFloat(_y_move) - parseFloat(_y_start) + parseFloat(top_start) + "px");
                    //socket1.send(targeturlhead+historysendstr+"0_"+lastMoveX+"_"+lastMoveY);
                } else {
                    onemousemove = true;//将onemousemove置为true，表示将要进行移动的操作
                    if (dragStartjt == true) {//判断是否要进行拖拽的动作，截图
                        socket1.send(targeturlhead + "1_" + moveX + "_" + moveY);
                        if ($(".drawSync").attr("sync") == "sync") {
                            //tempContext.lineTo(event.touches[0].clientX-canvaswindowLeft,event.touches[0].clientY-canvaswindowTop-40);  
                            tempContext.lineTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);

                            tempContext.stroke();
                        }
                    } else {
                        if (dragStart == true) {//判断是否要进行拖拽的动作,操控板只进行移动
                            if (socket1 != null && socket1.readyState == 1) {
                                historysendstr = historysendstr + "1_" + moveX + "_" + moveY + ";";
                                if (historysendstr.length > 0)//每128个字节发送一次
                                {
                                    socket1.send(targeturlhead + historysendstr);
                                    //发送结束后将字符串清空，以便于下一次发送不受影响
                                    historysendstr = "";
                                }
                                if ($(".drawSync").attr("sync") == "sync") {
                                    //tempContext.lineTo(event.touches[0].clientX-canvaswindowLeft,event.touches[0].clientY-canvaswindowTop-40);  
                                    tempContext.lineTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);
                                    tempContext.stroke();
                                }
                            }
                        }
                    }
                }
            }
            //else if (event.targetTouches.length == 2) {//双指放大的操作，暂时不需要，双指放大会出现放大后像素改变的问题
            //	if(onemousemove==true){//此时判断的情况是当一个手机点击后移动，另一个手指又放上，此时认为是单指操作
            //		if(penFlag==0){//单指拖动
            //			dragStartjt=false;
            //			_x_move=event.touches[0].screenX;
            //			_y_move=event.touches[0].screenY;
            //			// console.log("move",_x_move)
            //			$(".loadpng").css("left",parseFloat(_x_move)-parseFloat(_x_start)+parseFloat(left_start)+"px");
            //			$(".loadpng").css("right",(parseInt(document.documentElement.clientWidth)-canvaswindowWidth-parseInt($(".loadpng").css("left")))-2+"px");

            //			$(".loadpng").css("top",parseFloat(_y_move)-parseFloat(_y_start)+parseFloat(top_start)+"px");
            //			socket1.send(targeturlhead+historysendstr+"0_"+lastMoveX+"_"+lastMoveY);
            //		}else{
            //			if(dragStartjt==true){//判断是否要进行拖拽的动作，截图
            //				socket1.send(targeturlhead+"1_"+moveX+"_"+moveY);
            //				if($(".drawSync").attr("sync")=="sync"){
            //					//tempContext.lineTo(event.touches[0].clientX-canvaswindowLeft,event.touches[0].clientY-canvaswindowTop-40);  
            //					tempContext.lineTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);

            //					tempContext.stroke();
            //				}
            //			}else{
            //				if(dragStart==true){//判断是否要进行拖拽的动作,操控板只进行移动
            //					if(socket1!=null&&socket1.readyState==1){
            //						  historysendstr=historysendstr+"1_"+moveX+"_"+moveY+";";
            //						  if (historysendstr.length>128)//每128个字节发送一次
            //						  {
            //							 socket1.send(targeturlhead+historysendstr);
            //							 //发送结束后将字符串清空，以便于下一次发送不受影响
            //							 historysendstr="";
            //						  }
            //						  if($(".drawSync").attr("sync")=="sync"){
            //							 // tempContext.lineTo(event.touches[0].clientX-canvaswindowLeft,event.touches[0].clientY-canvaswindowTop-40);  
            //							  tempContext.lineTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);

            //							  tempContext.stroke();
            //						  }
            //					}
            //				}
            //			}
            //		}
            //	}else{//当前判断是为了满足正常双指操作做所进行的判断
            //		dragStartjt=false;
            //		v={x:event.touches[1].screenX-event.touches[0].screenX,y:event.touches[1].screenY-event.touches[0].screenY};  
            //		canvasZoom=parseFloat(getLen(v),3)/parseFloat(prev,3);	
            //		/*s = oldS * getS(ev) / downS;
            //    	oDiv.style.WebkitTransform = 'scale(' + s + ')';//translate(' + x + 'px,' + y + 'px) */


            //	    /* oDiv.style.WebkitTransform = 'scale(' + s + ')';//translate(' + x + 'px,' + y + 'px)*/
            //		s = oldS1 * getLen(v) / prev;
            //		s = parseFloat(s.toString().substr(0, 3));
            //		//socket1.send(targeturlhead + historysendstr + "ssss_" + s);
            //		//return;
            //		//oDiv.style.WebkitTransform = 'scale(' + s + ')';
            //		//alert("oooo" + s);
            //		socket1.send(targeturlhead+historysendstr+"0_"+lastMoveX+"_"+lastMoveY);			
            //	}
            //}
        } else {//onemousemove=true的时候说明当时进行的一定是第一个手指单指画的动作，
            //var moveX=parseInt((screenWidth/$(".loadImage").width())*(event.touches[0].screenX-canvaswindowLeft));
            //var moveY = parseInt((screenHeight / $(".loadImage").height()) * (event.touches[0].clientY - canvaswindowTop));

            var moveX = parseInt(widthRate * (event.touches[0].screenX - canvaswindowLeft));
            var moveY = parseInt(heightRate * (event.touches[0].clientY - canvaswindowTop));
            //var moveY=parseInt((screenHeight/$(".loadImage").height())*(event.touches[0].screenY-canvaswindowTop));

            lastMoveX = moveX;
            lastMoveY = moveY;
            if (event.targetTouches.length == 1) {//不管是单指还是双指，强制执行单指的操作
                if (dragStartjt == true) {//判断是否要进行拖拽的动作，截图
                    socket1.send(targeturlhead + "1_" + moveX + "_" + moveY);
                    if ($(".drawSync").attr("sync") == "sync") {
                        //tempContext.lineTo(event.touches[0].clientX-canvaswindowLeft,event.touches[0].clientY-canvaswindowTop-40);  
                        var moveY = parseInt((screenHeight / $(".loadImage").height()) * (event.touches[0].screenY - canvaswindowTop));

                        tempContext.stroke();
                    }
                } else {
                    if (dragStart == true) {//判断是否要进行拖拽的动作,操控板只进行移动
                        if (socket1 != null && socket1.readyState == 1) {
                            historysendstr = historysendstr + "1_" + moveX + "_" + moveY + ";";
                            if (historysendstr.length > 0)//每128个字节发送一次
                            {
                                socket1.send(targeturlhead + historysendstr);
                                //发送结束后将字符串清空，以便于下一次发送不受影响
                                historysendstr = "";
                            }
                            if ($(".drawSync").attr("sync") == "sync") {
                                //tempContext.lineTo(event.touches[0].clientX-canvaswindowLeft,event.touches[0].clientY-canvaswindowTop-40);  
                                tempContext.lineTo(event.touches[0].clientX - canvaswindowLeft, event.touches[0].clientY - canvaswindowTop);

                                tempContext.stroke();
                            }
                        }
                    }
                }
            }

        }
    }, false);
    //添加touchend监听，实现方式同上
    canvas.addEventListener('touchend', function (evt) {
        
        if (event.targetTouches.length == 1) {//判断当前有两个手指在区域上

            if (onemousemove == true) {//进行了单指画的动作，就算有两个手指依然默认为是单指画的操作
                if (dragStartjt) {

                    dragStartjt = false;
                    //var moveX=parseInt((screenWidth/$(".loadImage").width())*(event.changedTouches[0].screenX-canvaswindowLeft));
                    var moveX = parseInt(widthRate * (event.changedTouches[0].screenX - canvaswindowLeft));
                    setTimeout('socket1.send(targeturlhead+historysendstr+"0_"+lastMoveX+"_"+lastMoveY)', 10);
                }
            } else {//当前进行的判断是有两个手指但是并没有执行move的操作
                /*if(canvasZoom<=0.9||canvasZoom>=1.2){
					
					var sizeNum=(canvasZoom-1)/2;
					setTimeout("drawImage("+sizeNum+")",300);
					canvasZoom=1;
					moveX=moveY=null;
					
				}*/
                //
                //alert("sss"+oldS1);
                //		s = oldS1 * getLen(v) / prev;
                //alert("ssss1__" + document.getElementsByClassName("loadImage")[0].style.webkitTransform);

                //var ssss = document.getElementsByClassName("loadImage")[0].getBoundingClientRect().width;


                // $(".loadpng").attr("windowWidth", ssss);
                //// alert("333_" +  $(".loadpng").attr("windowWidth"));
                // $(".loadpng").css("width",canvaswindowWidth);
                //setTimeout("drawImage("+s+")",300); 
                //alert("ssss1__" + ssss);
                //s = parseFloat(s.toString().substr(0, 3));
                var t = s - 1;
                s = parseFloat(t.toString().substr(0, 3));

            }
            socket1.send(targeturlhead + historysendstr + "0_" + lastMoveX + "_" + lastMoveY);
        } else if (event.targetTouches.length == 0) {//当前进行的操作是单指或者双指同时抬起
            if (penFlag == 0) {
              
                if (onemousemove == false) {//当不进行move操作时，则认为是进行了单指点击的事件，模拟start事件向后台发送指令
                    if (date2 - date1 > 0 && date2- date1 < 500) {
                      
                        socket1.send(targeturlhead + "129_" + doubleTouchStartX + "_" + doubleTouchStartY + ";" + "0_" + doubleTouchStartX + "_" + doubleTouchStartY);
                    } else {
                        socket1.send(targeturlhead + "129_" + startMoveX + "_" + startMoveY + ";" + "0_" + startMoveX + "_" + startMoveY);
                    }
                    
                    setTimeout("drawImage(0,2)", 900);
                    doubleTouchStartX = startMoveX;
                    doubleTouchStartY = startMoveY;
                } else {
                    resizeCanvasSize(canvaswindowWidth, 0);
                }

            } else {
                if (dragStartjt) {
                    dragStartjt = false;
                    onemousemove = false;
                   
                    var moveX = parseInt(widthRate * (event.changedTouches[0].screenX - canvaswindowLeft));
                    var moveY = parseInt(heightRate * (event.changedTouches[0].clientY - canvaswindowTop));
                  
                    if (socket1 != null && socket1.readyState == 1) {

                        socket1.send(targeturlhead + historysendstr + "0_" + lastMoveX + "_" + lastMoveY);
                        //若用moveX,moveY则会有差异
                        //抬起鼠标后，操控界面自动刷新，回显当前显示端的界面显示
                        //当前设置延时900ms是防止指令没有发送完毕就重新回显了页面，出现误差
                        setTimeout("drawImage(0,2)", 900);

                    }
                }
            }
        }
        date = new Date();
        date1 = date.getTime();

    }, false);
}
$('body').on('touchmove', function (event) { event.preventDefault(); });
//打开上传文件的选项
function uploadFile(thistagename) {
    $(".fileContent").css("display", "block");
    $(".fileTK").css("marginTop", ($(".fileContent").height() - $(".fileTK").height()) / 2);
    if (document.documentElement.clientHeight < 400) {
        $(".recScreen1").css("height", "34px");
    } 
    
    $(".recScreen1").css("marginTop", ($(".fileTK").height() - $(".recScreen1").height() * 2 - $(".fileTitle").height()) / 3);
    $("#fileSubmit").css("display", "block");
    $("#proTask").css("display", "none");
    $("#hideUploadFile").val("");
    if ($.cookie("yuyan") == "" || $.cookie("yuyan") == undefined || $.cookie("yuyan") == null) {
        $("#chooseFile").val("选择文件");
    } else {
        $("#chooseFile").val(getLanguageMsg("选择文件", $.cookie("yuyan")));
    }
    
}
//点击页面上的选择文件按钮，模拟点击input=file的按钮
function chooseotherFile(thistext) {
    $("#hideUploadFile").click();
}
//根据上传的文件的类型，显示相应的控制按钮
function showProCtrl(type, desc) {
    var str1 = "";
    
    if (type =="0") {
        str1 = '<div class="programBtn" style="background:#fff; box-shadow: 0px 1px 5px 5px #e0dede;"><ul class="moreFunction"><li><img src="../images/bottomPlay/page_up.png" class="page_up" onclick="docmd(\'keycode\',\'0xFF55\',0)" style="height:100%;"/></li><li><img style="height:100%;" src="../images/bottomPlay/page_down.png" class="page_down"  onclick="docmd(\'keycode\',\'0xFF9B\',0)" /></li></ul></div>';
    }else if (type == "1") {
        str1 = '<div class="programBtn" style="background:#fff; box-shadow: 0px 1px 5px 5px #e0dede;"><div class="playRate" style="height:40px;width:100%;"><div class="startProTask"  onclick="pauseprotask()"><img class="start" style="height:75%;margin-top:7.5%;" src="images/bottomPlay/tingzhi.png" /></div><div class="showRate" style="width:90%"><span class="fileName1" style="font-size:14px;line-height:20px;width:100%;"></span><div id="rangeRate1" class="clearfix11" style="width:80%"><div id="rangeLeft"></div> <div id="rangeRate2"></div></div> <span id="rateProgressValue" style="font-size:16px;display:block;float:left;width:15%;margin-left:1%;margin-top:5px;height:20px;line-height:20px;">00:00</span></div></div><div class="proSound"><div style="display:block;float:left;width:10%;height:100%;"><img src="images/leftControl/quanjuyinliang.png"></div><div class="proSystemSound" style="display: block;"><input id="prorange" class="prorange" type="range" min="0" max="255" value="" onchange="change(\'prorange\',\'provalue\')"><span id="provalue" clas="provalue" style="line-height:25px;display:block;float:left;width:10%;">128</span></div></div></div>';
    } else if (type == "2") {
        str1 = '<div class="programBtn" style="background:#fff; box-shadow: 0px 1px 5px 5px #e0dede;"><div class="playRate" style="height:40px;width:100%;"><div class="startProTask"  onclick="pauseprotask()"><img class="start" style="height:75%;margin-top:7.5%;" src="images/bottomPlay/tingzhi.png" /></div><div class="showRate" style="width:90%"><span class="fileName1" style="font-size:14px;line-height:20px;width:100%;"></span><div id="rangeRate1" class="clearfix11" style="width:80%"><div id="rangeLeft"></div> <div id="rangeRate2"></div></div> <span id="rateProgressValue" style="font-size:16px;display:block;float:left;width:15%;margin-left:1%;margin-top:5px;height:20px;line-height:20px;">00:00</span></div></div><div class="proSound"><div style="display:block;float:left;width:10%;height:100%;"><img src="images/leftControl/quanjuyinliang.png"></div><div class="proSystemSound" style="display: block;"><input id="prorange" class="prorange" type="range" min="0" max="255" value="" onchange="change(\'prorange\',\'provalue\')"><span id="provalue" class="provalue" style="line-height:25px;display:block;float:left;width:10%;">128</span></div></div></div>';
    } else if (type = "3") {
        str1 = '<div class="programBtn" style="background:#fff; box-shadow: 0px 1px 5px 5px #e0dede;"><ul class="moreFunction"><li><img style="height:100%;" src="../images/bottomPlay/shangyiye.png" class="page_up" onclick="docmd(\'keycode\',\'0xFF55\',0)"/></li><li><img style="height:100%;" src="../images/bottomPlay/xiayiye.png" class="page_down"  onclick="docmd(\'keycode\',\'0xFF9B\',0)" /></li></ul></div>';
    } else if (type = "4") {
        str1 = '<div class="programBtn" style="background:#fff; box-shadow: 0px 1px 5px 5px #e0dede;margin-bottom:10px;"><ul class="moreFunction"><li><img style="height:100%;" class="beforePage image" src="../images/bottomPlay/shangyiye.png" onclick="docmd(\'keycode\',\'screenClass -keyevent 0xFF55\',0)"/></li><li><img class="nextPage image" style="height:100%;" src="../images/bottomPlay/xiayiye.png"  onclick="docmd(\'keycode\',\'screenClass -keyevent 0xFF9B\',0)" /></li></ul></div>';
    }
    $(".proOperBtn").html(str1);
    $(".proOperBtn .programBtn").append('<ul class="programPrintBtn"><li class="wordPrint" onclick="printReceipt()">小票打印</li><li class="wordPrint" onclick="printPictutre(\'4寸图片打印模板\')">4寸图片</li><li class="wordPrint" onclick="printPictutre(\'6寸图片打印模板\')">6寸图片</li><li class="wordPrint" onclick="printDefault()">默认模板</li></ul>');
    $(".fileTK .programBtn").css("display", "block");
    if (document.documentElement.clientHeight < 700) {
        
        $(".proSound img").css("height", "45%");
        $(".startProTask .start").css("height", "45%");
        $(".proOperBtn .start").css("marginTop", ($(".proOperBtn .playRate").height() - $(".proOperBtn .start").height()) / 2);
        $(".proOperBtn .showRate").css("marginTop", ($(".proOperBtn .playRate").height() - $(".proOperBtn .showRate").height()) / 2)
        $(".proSound img").css("marginTop", ($(".proSound .proSystemSound").height() - $(".proSound img").height()) / 2);
        $("#rateProgressValue").css("fontSize", "12px");
        $("#provalue").css("fontSize", "12px");
        //$("#rangeRate1").css("marginLeft", "0px");
        $(".fileTitle").css("fontSize", "16px");
        $(".proName").css({ "fontSize": "16px", "lineHeight": $(".playTask").height() + "px" });
        if (document.documentElement.clientHeight < 400) {
            $(".fileTK").css("height", "50%");
        }
    }
    changeUploadRate();
    $(".moreProTask span").css("marginLeft", (parseInt($(".moreProTask").width()) - parseInt($(".moreProTask span").width()))/2)
}
function changeUploadRate() {
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
        //console.log("move"+changeFlage);         
        //event.preventDefault();            
        var styles = window.getComputedStyle(rangeRate1, null);
        var width = styles.width;//灰色块的长度，用于计算红色块最大滑动的距离
        //leftWidth为当前灰色块距离屏幕最左侧的距离

        var leftWidth = parseFloat($(".fileTK").css("marginLeft")) + parseFloat($("#proTask").css("marginLeft")) + $(".startProTask").width() + parseFloat($("#rangeRate1").css("marginLeft"));
        //var leftWidth = parseFloat($("#functionButton .images").width()) + parseFloat($(".musicOrVideo").css("width")) * 0.04;
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
            rangeRate2.style.left = moveleft + "px";//最后把left值附
            var reteWidth = parseFloat($("#rangeRate1").css("width")) - parseInt($("#rangeRate2").css("width"));
            var strsMax = parseFloat($("#rangeRate1").attr("max"));
            var nw = parseInt($("#tabscreen").attr("nowwindow"));
            nowSecond = moveleft * strsMax / reteWidth;
            $("#rangeLeft").css("width", moveleft);
            $("#rateProgressValue").html(secondToMinute(nowSecond));
        };
    });
    rangeRate2.addEventListener('touchend', function (event) {
        var reteWidth = parseFloat($("#rangeRate1").css("width")) - parseInt($("#rangeRate2").css("width"));
        var strsMax = parseFloat($("#rangeRate1").attr("max"));
        var nw = parseInt($("#tabscreen").attr("nowwindow"));
        nowSecond = moveleft * strsMax / reteWidth
        timeFlag = 2;
        docmd(nw * 10000 + 3009, parseInt(nowSecond));
        changeFlage = 0;
    }) 
}
//点击启动按钮进行插播，为临时任务
function startUp(thisContent) {
    showLoading();
    var contentName = "";
	var suntType=1;
    var des = "";
    var URL = window.location.href.split("/")[0];
    $(".programBtn").removeClass("current");
    $(thisContent).parent().parent().parent().addClass("current");
    var itemType = $(thisContent).parent().attr("tasktype");
    if ($(thisContent).parent().attr("taskType")=="1") {
        clearInterval(timer);
        itemType = "1010";
        des = $(thisContent).parent().attr("proTaskDesc");
        contentName = $(thisContent).parent().attr("proTaskPath") + des;
        suntType=1;
        timer = setInterval("getRate()", 1000);
    } else if ($(thisContent).parent().attr("taskType") == "2") {
        clearInterval(timer);
        itemType = "1009"
        des = $(thisContent).parent().attr("proTaskDesc");
        contentName = $(thisContent).parent().attr("proTaskPath") + des;
		suntType=1;
        timer = setInterval("getRate()", 1000);
    } else if ($(thisContent).parent().attr("taskType") == "4") {
        itemType = "1008";
        des = $(thisContent).parent().attr("proTaskDesc");
        contentName = $(thisContent).parent().attr("proTaskPath") + des;
		suntType=1;
        clearInterval(timer);
    } else if($(thisContent).parent().attr("taskType") == "3"){
        itemType = "1003";
        des = $(thisContent).parent().attr("proTaskDesc");
        contentName = $(thisContent).parent().attr("proTaskPath") + des;
		suntType=0;
        clearInterval(timer);
    }else{
		itemType = "1003";
        des = $(thisContent).parent().attr("proTaskDesc");
        contentName = $(thisContent).parent().attr("proTaskPath") + des;
		suntType=0;
        clearInterval(timer);
	}
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=76_-starttemptask <id>32769</id><sunt>" + suntType + "</sunt><sdly>15</sdly><des>" + des + "</des><url>" + contentName + " -t</url><ttype>" + itemType + "</ttype><dur>36000</dur><win>全屏窗口/0</win><wstate>100</wstate><loop>1</loop>&utf8=1",
        dataType: "text",
        type: 'GET',
        success: function () {
            //$(".current span").css("color", "#000");
            //$(".current span").css("background", "#fff");
            //$(".proName").css("background", "#f5f5f5");
            hideLoading();
            if (itemType == "1009" || itemType == "1010") {
                $(".start").attr("src", "images/bottomPlay/bofang.png");
            }
        },
        error: function () {
            hideLoading();
        }
    })
}
function pauseprotask() {
    if ($(".start").attr("src") == "images/bottomPlay/bofang.png") {
        docmd(3002);
        $(".start").attr("src", "images/bottomPlay/tingzhi.png");
    } else {
        docmd(3003);
        $(".start").attr("src", "images/bottomPlay/bofang.png");
    }
}
//点击关闭的按钮，音量条即隐藏
function closesound(thidSound) {
    $(".closesound").parent().hide();
}
//根据文件名
function checkFileType(itemtype,downLink) {
    if (itemtype == 12 || itemtype == 1012||itemtype==0||itemtype==1000||itemtype == 11 || itemtype == 1011) {
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".xls") >= 0 ||downLink.indexOf(".docx") >= 0 ||downLink.indexOf(".ppt") >= 0 ||downLink.indexOf(".doc") >= 0||downLink.indexOf(".xlsx") >= 0||downLink.indexOf(".pps")>=0 || downLink.indexOf(".pptx") >= 0 || downLink.indexOf(".ppsx") >= 0)) {
            return parseInt(itemtype/1000)*1000+8;
        } else if (downLink.indexOf(".txt") >= 0) {
            return parseInt(itemtype/1000)*1000+1
        } else if (downLink.indexOf(".htm") >= 0 || downLink.indexOf(".html") >= 0 || downLink.indexOf(".asp") >= 0 || downLink.indexOf(".aspx") >= 0 || downLink.indexOf(".php") >= 0 || downLink.indexOf(".jsp") >= 0 || downLink.indexOf(".shtml") >= 0 || downLink.indexOf(".pdf") >= 0) {
            return parseInt(itemtype/1000)*1000+2;
        } else if (downLink.indexOf(".gif") >= 0 || downLink.indexOf(".jpg") >= 0 || downLink.indexOf(".bmp") >= 0 || downLink.indexOf(".png") >= 0 || downLink.indexOf(".tiff") >= 0 || downLink.indexOf(".tif") >= 0 || downLink.indexOf(".jpeg") >= 0 || downLink.indexOf(".ico") >= 0) {
            return parseInt(itemtype/1000)*1000+3
        } else if (downLink.indexOf(".swf") >= 0) {
            return parseInt(itemtype/1000)*1000+7
        } else if (downLink.indexOf(".wav") >= 0 || downLink.indexOf(".aif") >= 0 || downLink.indexOf(".mp3") >= 0 || downLink.indexOf(".wma") >= 0 || downLink.indexOf(".cda") >= 0 || downLink.indexOf(".au") >= 0 || downLink.indexOf(".midi") >= 0 || downLink.indexOf(".aac") >= 0 || downLink.indexOf(".ape") >= 0 || downLink.indexOf(".ogg") >= 0) {
            return parseInt(itemtype/1000)*1000+9
        } else if (downLink.indexOf(".avi") >= 0 || downLink.indexOf(".mpg") >= 0 || downLink.indexOf(".mpeg") >= 0 || downLink.indexOf(".mp4") >= 0 || downLink.indexOf(".wmv") >= 0 || downLink.indexOf(".asf") >= 0 || downLink.indexOf(".vob") >= 0 || downLink.indexOf(".rm") >= 0 || downLink.indexOf(".rmvb") >= 0 || downLink.indexOf(".flv") >= 0 || downLink.indexOf(".f4v") >= 0 || downLink.indexOf(".mov") >= 0 || downLink.indexOf(".dat") >= 0) {
            return parseInt(itemtype/1000)*1000+10
        } else if (downLink.indexOf(".zip") >= 0 || downLink.indexOf(".rar") >= 0 || downLink.indexOf(".7z") >= 0 || downLink.indexOf(".tar") >=0 ||downLink.indexOf(".xz") >= 0||downLink.indexOf(".bz2") >= 0) {
            return itemtype;
        }else{
            if (itemtype == 11 || itemtype == 1011) {
                return itemtype;
            }else if(itemtype == 12 || itemtype == 1012){
                return itemtype;
            }else{
                return itemtype;
            }
        } 
			
	}
}

//显示一键登录的模块
function onClickLogin() {
    $(".onClickLogin").show();
    $(".onClickLogin").css("marginTop", (document.documentElement.clientHeight - $(".onClickLogin").height()) / 2);
    $(".contentLogin").css("width", $(".onClickLogin").width() - 40);
    $(".contentLoginMain p input[type='text']").css("width", $(".contentLoginMain p").width() - $(".topleftlogin").width() - $(".contentLoginMain p input[type='button']").width()*2-25);
    $(".contentLoginMain p input[type='password']").css("width", $(".contentLoginMain p").width() - $(".topleftlogin").width() - $(".contentLoginMain p input[type='button']").width()*2 - 25);
    
    $(".inputNameValue").width($(".contentLoginMain p input[type='text']").width() - 20);
    if (document.documentElement.clientWidth < 768) {
        $("#saveName").css("width", $(".inputNameValue").width() + 25);
    } else {
        $("#saveName").css("width", $(".inputNameValue").width() + 30);
    }
    
    $(".contentLoginBottom input[type='button']:last").css("marginRight", "0px");
    $(".contentLoginBottom input[type='button']").css("width", ($(".contentLoginBottom").width() - 40) / 5);
    showNameCookie();

}
//一键登录的单个提交事件
function submitLogin(thisvalue, ops) {
    showLoading();
    var op1 = $(".contentLoginTop input").eq(0).prop("checked") ? 1 : 0;
    var op2 = $(".contentLoginTop input").eq(1).prop("checked") ? 1 : 0;
    var op3 = $(".contentLoginTop input").eq(2).prop("checked") ? 1 : 0;
    var op4 = ops;
    var submitVal=$(thisvalue).parent().find(".inputvalue").val();
    $.ajax({
        url: newurl + "/wpinputstring.asp",
        type: "get",
        dataType: "html",
        data: {
            wpinputstring: encodeURI(submitVal),
            op: op1.toString() + op2.toString() + op3.toString() + "1" + op4.toString(),
            ret: "0",
            utf8:"1"
        }, success: function (data) {
            var t = $(data).find("wpretstr").text();
           
            if (t.indexOf("200 OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                saveSelectNameCookie();
                setTimeout("drawImage(0,2)", 900);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
            hideLoading();
            //loginName
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//提交+Tab
function submitLogin1(thisVal) {
    showLoading();
    var op1 = $(".contentLoginTop input").eq(0).prop("checked") ? 1 : 0;
    var op2 = $(".contentLoginTop input").eq(1).prop("checked") ? 1 : 0;
    var op3 = $(".contentLoginTop input").eq(2).prop("checked") ? 1 : 0;
    var op4 = $(".contentLoginTop input").eq(3).prop("checked") ? 1 : 0;
    $.ajax({
        url: newurl + "/wpinputstring.asp",
        type: "get",
        dataType: "html",
        data: {
            wpinputstring: encodeURI($(thisvalue).prev().val()),
            op: op1.toString() + op2.toString() + op3.toString() + "1" + op4.toString(),
            ret: "0",
            utf8: "1"
        }, success: function (data) {
            hideLoading();
            var t = $(data).find("wpretstr").text();
            if (t.indexOf("200 OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                saveSelectNameCookie();
                setTimeout("drawImage(0,2)", 900);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//一键登录
function submitAll() {
    showLoading();
    var op1 = $(".contentLoginTop input").eq(0).prop("checked") ? 1 : 0;
    var op2 = $(".contentLoginTop input").eq(1).prop("checked") ? 1 : 0;
    var op3 = $(".contentLoginTop input").eq(2).prop("checked") ? 1 : 0;
    var op4 = $(".contentLoginTop input").eq(3).prop("checked") ? 1 : 0;
    var strq = $(".contentLoginMain p").eq(0).find("input[type='text']").val() + String.fromCharCode(0x1b) + $(".contentLoginMain p").eq(1).find("input[type='password']").val() + String.fromCharCode(0x1b) + $(".contentLoginMain p").eq(2).find("input[type='text']").val();
    $.ajax({
        url: newurl + "/wpinputstring.asp",
        type: "get",
        dataType: "html",
        data: {
            wpinputstring: encodeURI(strq),
            op: op1.toString() + op2.toString() + op3.toString() + "1" + op4.toString(),
            ret: "1",
            utf8:"1"
        }, success: function (data) {
            hideLoading();
            var t = $(data).find("wpretstr").text();
            if (t.indexOf("200 OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                saveSelectNameCookie();
                setTimeout("drawImage(0,2)", 900);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//从cookie中读取数据后在select中显示
function showNameCookie() {
    var optionLoginStr = '<option value=" "></option>';
    var cookieStr = "";
    if ($.cookie("loginName") != null && $.cookie("loginName") != undefined && $.cookie("loginName") != "") {
        if ($.cookie("loginName").indexOf(";") >= 0) {
            cookieStr = $.cookie("loginName").split(";");
            loginName = cookieStr;
            for (var i = 0; i < cookieStr.length; i++) {
                optionLoginStr += "<option value=" + cookieStr[i] + ">"+cookieStr[i]+"</option>";
            }
        } else {
            loginName.push($.cookie("loginName"));
            cookieStr = $.cookie("loginName");
            optionLoginStr += "<option value=" + cookieStr + ">"+cookieStr+"</option>"
        } 
        $("#saveName").html(optionLoginStr);
      
    }
}
//点击提交按钮后存储cookie
function saveSelectNameCookie() {
    var newCookieArry = [];
    if ($.cookie("loginName") != null && $.cookie("loginName") != "" && $.cookie("loginName") != undefined) {
        if ($.cookie("loginName").indexOf(";") >= 0) {//则表明当前的cookie的 数据至少有两条
            var cookieName = $.cookie("loginName").split(";");
            for (var i = 0; i < cookieName.length; i++) {//声明一个新的数组，如果新添加的数据和当前cookie的数组有不同的则正常添加至cookie,若有相同的则不向新数组中添加
                if (cookieName[i] != $(".inputvalue").val()) {
                    newCookieArry.push(cookieName[i]);
                } else {
                }
            }
            
            if (newCookieArry.length > loginName.length) {
                loginName = newCookieArry;
            } else if (newCookieArry.length < loginName.length) {//当新的数据与原有的数据有重合时用以下方式处理
                newCookieArry.unshift($(".inputvalue").val());//此处的处理是就算数组中已有新添加的数据，则会将数组中的数据删除，将新添加的数据在最前显示
                loginName = newCookieArry;
            } else if (newCookieArry.length = loginName.length) {//当新的数据与原有数据没有重合时
                loginName.unshift($(".inputvalue").val());
            }
            if (loginName.length > 5) {//如果数据的长度大于5则删除数组最后的一个元素即最开始添加的一条数据
                loginName.pop()
            }
            loginNameStr = loginName.join(";");
            $.cookie("loginName", loginNameStr);
        } else {
            loginName.unshift($(".inputvalue").val());
            loginNameStr = loginName.join(";");
            $.cookie("loginName", loginNameStr);
        }

    } else {
        $.cookie("loginName", $(".inputvalue").val()); 
    }
    showNameCookie();//存储cookie立马存储到select中，这样在展开select的时候不会出现延迟的情况
}
//将下拉框选中的内容填充到输入框中
function selectLoginName() {
    $(".inputNameValue").val($("#saveName").val());
}
//开关机提示信息
function tipMessage(message,functionName,messageNum) {
    $(".confirmDiv").css("display", "block");
    $(".confirmDiv").css("marginTop", (document.documentElement.clientHeight - $(".confirmDiv").height()) / 2);
    $(".tipOk").css("marginLeft", ($(".tipContent1").width() - $(".tipOk").width() * 2 - 20) / 2);
    $(".tipContent").html(message);
    $(".tipContent").css("lineHeight", $(".tipContent").height()+"px");
    
    $(".tipContent").attr("fName", functionName);
    $(".tipContent").attr("messageNum", messageNum);
    // functionName + "()";
   
}
//ios启动停止投屏
function startScreen(typeNum) {
    showLoading();
    $.ajax( {
        url: newurl + "/wpplaycontrol.asp?wpplaycontrol=airplayer&command=" + typeNum + "&param=0&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        type: "get",
        dataType: "html",
        success: function (xml) {
            hideLoading();
            if (xml.indexOf("OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
   
}
//其他方式投屏
function otherScreen(typeScreen) {
    showLoading();
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=" + typeScreen + "&utf8=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        type: "get",
        dataType: "html",
        success: function (xml) {
            hideLoading();
            var xml = eval("(" + xml + ")");
            if (xml.indexOf("OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//启动禁用usb
function startusb(typeusbNum) {
    showLoading();
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=" + typeusbNum+"&rnd="+(Math.floor(Math.random()*(9999-1000))+1000),
        type: "get",
        dataType: "html",
        success: function (xml) {
            hideLoading();
            if (xml.indexOf("OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//切换分辨率
function getScreenSize(screenSize) {
    showLoading();
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=107_" + screenSize + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        type: "get",
        dataType: "html",
        success: function (xml) {
            hideLoading();
            var xml = eval("(" + xml + ")");
            if (xml.indexOf("OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//切换HDMI
function changeHDMI(hNum) {
    showLoading();
    $.ajax({
        url: newurl + "/wpcontrolcomm.asp?wpcontrolcomm=1000_" + hNum + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        type: "get",
        dataType: "html",
        success: function (xml) {
            hideLoading();
            if (t.indexOf("OK") >= 0) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//切换语言
function switchLanguage(index, pagename) {    
    var url = "js/language.json";//多语言数据路径
    $.ajax({
        url: url,
        type: "get",
        dataType: "text",
        async:'false',
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
            if (index ==1) {
                $(".bar .cmdBar li").css("height","80px");
            } else {
                $(".bar .cmdBar li").css("height","40px");
            }
            $(".bar .cmdBar li img").css("marginTop", ($(".bar .cmdBar li").height() - $(".bar .cmdBar li img").height()) / 2);
        }, error: function (a, b, c) {
            console.log(a, b, c);
        } 
    }).done(function(e){
        getbtn(pagename.split(".html")[0], index);
        setTimeout(function () {
            $(".controlImage img").eq(0).click();
        }, 1000)
    })
   
}
//预览图片
function checkImageFile(thisHref) {
    loadPicture1(0)
    $("#checkPicture").show();
    $("#checkPictureTitle .screentitle").css("marginLeft", ($("#checkPictureTitle").width() - $(".screentitle").width()) / 2);
    $("#top").attr("imgSrc", $(thisHref).attr("href1"));
   
    drawImage1(0);
    canvaswindowWidth = document.documentElement.clientWidth;
    $("#points1").val(0);
    $(".loadpng1").css("left", "0px");
    $("#nowPictureSize").html("0");
    
  
}
//当canvas图片大小改变时，调用此函数
//size为放大缩小的倍数，float型，当页面第一次加载次函数时，size=0;可正负，负表示缩小
//当num==2时，说明当前函数是鼠标抬起时调用的
function drawImage1(size, num) {
    if (onlyoneCutScreen == 0) {
        onlyoneCutScreen = 1;
    } else {
        return;
    }
    /*
        此处显示动态加载图片
    */
    $(".loadingDiv").css({
        "display": "block",
        "marginTop": (document.documentElement.clientHeight - 30) / 2
    });
    //$(".screentitle").css("marginLeft", ($("#loadmask").width() - $(".screentitle").width()) / 2)
    wholeSize = size;//将现在放大的倍数赋值给全局变量，方便以后使用
    $(".loadpng1").css("display", "block");
    $("#checkPicture").css("display", "block");
    var ua = navigator.userAgent.toLowerCase();
    //对canvas图片动态装载的处理
    //对图片放大缩小时不对图片重新装载，如果之前在缓存中已经有一张截图也不进行重新装载

    var tmpscreenimg = new Image();
    var newImageUrl=$("#top").attr("imgSrc")
    tmpscreenimg.src =newImageUrl ;
    var imgW = "";
    var imgH = "";
    tmpscreenimg.onload = function () {
        imgW = tmpscreenimg.width;
        imgH = tmpscreenimg.height;
        if (size != undefined) {
            if (Math.abs(size) == 0.1) {
                //allWidth为网页显示区域的宽度
                canvaswindowWidth = allWidth + (allWidth * size)
            } else {
                if (size == 0 && $("#points1").val() != 0) {
                } else {
                    canvaswindowWidth = document.documentElement.clientWidth * (1 + size);
                }

            }
            allWidth = canvaswindowWidth;
        }
        document.getElementsByClassName("loadImage")[0].width = canvaswindowWidth;
        document.getElementsByClassName("loadImage")[0].height = imgH * canvaswindowWidth / imgW;
        whRate = document.getElementsByClassName("loadImage")[0].width / document.getElementsByClassName("loadImage")[0].height;
        /*
            此时图片加载完成，去掉动态加载图
        */
        $(".loadingDiv").css("display", "none");
        resizeCanvasSize1(canvaswindowWidth, size);
        tempContext.drawImage(tmpscreenimg, 0, 0, canvaswindowWidth, imgH * canvaswindowWidth / imgW);
        //图片的大小和canvas的大小保持一致
        if (screenimg != undefined && screenimg != 0) {
            delete screenimg;
            screenimg = tmpscreenimg;
        }
        else {
            screenimg = tmpscreenimg;
        }
    }
    widthRate = screenWidth / $(".loadImage").eq(0).width();
    heightRate = screenHeight / $(".loadImage").eq(0).height();
    onlyoneCutScreen = 0;
}
//拖动预览的图片
function loadPicture1(num) {
    var oDiv = document.getElementsByClassName("loadpng")[0];
    var x = 0;
    var y = 0;
    var d = 0;
    var s = 1;
    var oldS1 = s;
    var startMoveX = 0;
    var startMoveY = 0;
    resetCanvas(num);
    //添加touchStart监听
    var _x_start, _y_start, _x_move, _y_move, _x_end, _y_end, left_start, top_start, moveleft, moveright;
    canvas.addEventListener('touchstart', function (evt) {
        _x_start = event.touches[0].screenX;
        _y_start = event.touches[0].screenY;
        left_start = $(".loadpng1").css("left");
        top_start = $(".loadpng1").css("top");
    }, false);
    var reduceCount = 0;
    //添加touchmove监听，向服务器端发送指令的过程同touchstart相同
    canvas.addEventListener('touchmove', function (evt) {
        evt.preventDefault();// 此句是为了滑动当前层时禁止底层滑动
        var moveX = parseInt(widthRate * (event.touches[0].screenX - canvaswindowLeft));
        var moveY = parseInt(heightRate * (event.touches[0].clientY - canvaswindowTop));
       
        lastedMoveX = lastMoveX;
        lastedMoveY = lastMoveY;
        lastMoveX = moveX;
        lastMoveY = moveY;
        currentX = event.touches[0].screenX;
        currentY = event.touches[0].screenY;   
        var loadpngLeft = parseInt($(".loadpng1").css("left"));//marginLeft  
        var offsetLeft = document.getElementsByClassName("loadpng1")[0].offsetLeft;
        _x_move = event.touches[0].screenX;
        _y_move = event.touches[0].screenY;
      
        moveleft = parseFloat(_x_move) - parseFloat(_x_start) + parseFloat(left_start);
       
        $(".loadpng1").css("left", parseFloat(_x_move) - parseFloat(_x_start) + parseFloat(left_start) + "px");
        $(".loadpng1").css("right", (parseInt(document.documentElement.clientWidth) - canvaswindowWidth - parseInt($(".loadpng1").css("left"))) - 2 + "px");

        $(".loadpng1").css("top", parseFloat(_y_move) - parseFloat(_y_start) + parseFloat(top_start) + "px");
             
            
            
    }, false);
    //添加touchend监听，实现方式同上
    canvas.addEventListener('touchend', function (evt) {
       
    }, false);
}
$('body').on('touchmove', function (event) { event.preventDefault(); });
function showNowPlayScreen() {
    showLoading();
    $.ajax({
        url: newurl + "/wpgetxmlids.asp?gettype=2",
        type: "get",
        dataType: "xml",
        success: function (data) {
            var strs = "";
            var winLen = $(data).find("window").length;
            if (winLen >= 0) {
                for (var i = 0; i < winLen; i++) {
                    strs += "<li onclick='playScreenShadowContent(this)'>" + $(data).find("window").eq(i).find("name").html() + "</li>";
                }
                $(".playScreenShadowContent ul").html(strs);
            }
            hideLoading();

        }, error: function () {
            hideLoading();
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
    showLoading();
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=80_-starttemptask%20<id>" + id + "</id><tmpid>" + (91000+parseInt(id))+ "</tmpid><dur>10800</dur><win>" + win + "</win>&utf8=1",
        type: "get",
        dataType: "text",
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".playScreenShadow").hide();
        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);

        }
    })
}
//停止指定窗口的临时任务
function stopScreenProgram() {
    showLoading();
    var stopWindowNum = $(".current").find(".timeLong i").text().split("-")[0];
    $.ajax({
        url: newurl + "/wpsendclientmsg.asp?wpsendclientmsg=28_" + stopWindowNum,
        type: "get",
        dataType: "text",
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);

        }, error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
function getLanguageMsg(a,c) {
    var url = "js/language.json";//多语言数据路径
    var returnMsg = "";
    var h = 0;
    if (c == null || c == "") {
        c = "ch";
    }
    $.ajax({
        url: url,
        type: "get",
        dataType: "text",
        async: false,
        setTimeout:"3000",
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
        }, error: function (a, b, c) {
            console.log(a, b, c);
            returnMsg = a;
        }
    })
    return returnMsg;
}
//音频控制
function closethisAudio(thisdiv) {
    $(thisdiv).hide();
}
function openTVControl(thisdiv) {
    $(thisdiv).css("display", "flex");
}
//静音,取消静音
function audioNoSound(controlNum, type) {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_CS0X20" + controlNum + "0X20" + type + "0X0D&destip=&destport=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'text',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".topConfirm").attr("messageTip", "")
        },
        error: function (a, b, c) {
            hideLoading();
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            }
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            $(".topConfirm").attr("messageTip", "")
        }
    })
}
//音箱音量加、减
function changeSound1(num, type) {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_CC0X20" + num + "0X20" + type + "0X207800X0D&destip=&destport=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'text',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            hideLoading();
            //timeShowMsg("title","发送成功",500);
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".topConfirm").attr("messageTip", "")
        },
        error: function (a, b, c) {
            hideLoading();
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            }
            //timeShowMsg("title","发送失败",500);
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            $(".topConfirm").attr("messageTip", "")
        }
    })
}
//音响组静音/取消静音
function changeGroupOrder(type, outputNum1, outputNum2, outputNum3) {
    showLoading();
    var str = "";
    if (outputNum3 != "") {
        str = "0X20" + outputNum1 + "0X20" + type + "0X200X0DfxxfCS0X20" + outputNum2 + "0X20" + type + "0X200X0DfxxfCS0X20" + outputNum3 + "0X20" + type + "0X200X0D";
    } else {
        str = "0X20" + outputNum1 + "0X20" + type + "0X200X0DfxxfCS0X20" + outputNum2 + "0X20" + type + "0X200X0D";
    }
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_CS" + str + "&destip=&destport=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'text',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".topConfirm").attr("messageTip", "")
        },
        error: function (a, b, c) {
            hideLoading();
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            }
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            $(".topConfirm").attr("messageTip", "")
        }
    })
}
//音箱组音量加、减
function changeGroupSound(type, outputNum1, outputNum2, outputNum3) {
    showLoading();
    var str = "";
    if (outputNum3 != "") {
        str = "0X20" + outputNum1 + "0X20" + type + "0X207800X0DfxxfCC0X20" + outputNum2 + "0X20" + type + "0X207800X0DfxxfCC0X20" + outputNum3 + "0X20" + type + "0X207800X0D";
    } else {
        str = "0X20" + outputNum1 + "0X20" + type + "0X207800X0DfxxfCC0X20" + outputNum2 + "0X20" + type + "0X207800X0D";
    }
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_CC" + str + "&destip=&destport=&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'text',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            $(".topConfirm").attr("messageTip", "")
        },
        error: function (a, b, c) {
            hideLoading();
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            }
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            $(".topConfirm").attr("messageTip", "")
        }
    })
}
/**
 * 返回值格式：200 OK <result>%s</result>
 * URL参数中增加 needret=1，表示要有返回值
http://localhost:8080/wpsendudpdata.asp?wpsendudpdata=1000_0X3A0X300X300X310X300X300X300X420X300X300X300X300X310X300X300X300X310X330X450X0D0X0A&destip=192.168.1.254&destport=6666&app=0&close=&sleep=30&needret=

 * */
function getSound1() {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_GSB20X201000X20200X0D&destip=&destport=&app=0&close=&sleep=30&needret=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'html',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            var data1 = data;
            //var data1=$(data);
            if ($(data1).find("wpretstr").text().indexOf("200") >= 0) {
                var str = $(data1).find("wpretstr").find("result").text();
                $.cookie("yinxiang", str)
                var strArr = "";
                if (str != "") {
                    strArr = str.split(";");

                    for (var i = 0; i < strArr.length; i++) {
                        if (strArr[i].indexOf("=") >= 0) {
                            var controlNum = "";

                            var controlG = strArr[i].split("=");
                            var soundNum = controlG[1];
                            if (controlG[0].indexOf("#") >= 0) {
                                controlNum = (controlG[0].split("#"))[1];
                                if (i == 2) {
                                    ($("#tvControlShadow2").find(".tv").eq(6)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 3) {
                                    ($("#tvControlShadow2").find(".tv").eq(7)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 4) {
                                    ($("#tvControlShadow2").find(".tv").eq(5)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 10) {
                                    ($("#tvControlShadow2").find(".tv").eq(8)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 11) {
                                    ($("#tvControlShadow2").find(".tv").eq(0)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 12) {
                                    ($("#tvControlShadow2").find(".tv").eq(4)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 18) {
                                    ($("#tvControlShadow2").find(".tv").eq(1)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 19) {
                                    ($("#tvControlShadow2").find(".tv").eq(2)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 20) {
                                    ($("#tvControlShadow2").find(".tv").eq(3)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                }
                            }
                        }



                    }
                }
            }
            hideLoading();
        },
        error: function (a, b, c) {
            if ($.cookie("xinxiang") != "" && $.cookie("xinxiang") != null) {
                var strArr = "";
                var str = $.cookie("xinxiang");
                if (str != "") {
                    strArr = str.split(";");
                    for (var i = 0; i < strArr.length; i++) {
                        if (strArr[i].indexOf("=") >= 0) {
                            var controlNum = "";

                            var controlG = strArr[i].split("=");
                            var soundNum = controlG[1];
                            if (controlG[0].indexOf("#") >= 0) {
                                controlNum = (controlG[0].split("#"))[1];
                                if (i == 2) {
                                    ($("#tvControlShadow2").find(".tv").eq(6)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 3) {
                                    ($("#tvControlShadow2").find(".tv").eq(7)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 4) {
                                    ($("#tvControlShadow2").find(".tv").eq(5)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 10) {
                                    ($("#tvControlShadow2").find(".tv").eq(8)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 11) {
                                    ($("#tvControlShadow2").find(".tv").eq(0)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 12) {
                                    ($("#tvControlShadow2").find(".tv").eq(4)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 18) {
                                    ($("#tvControlShadow2").find(".tv").eq(1)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 19) {
                                    ($("#tvControlShadow2").find(".tv").eq(2)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 20) {
                                    ($("#tvControlShadow2").find(".tv").eq(3)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                }
                            }
                        }
                    }
                }

            }
            hideLoading();
        }
    })
}
function getSound2() {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_GSB20X204380X2020X0D&destip=&destport=&app=0&close=&sleep=30&needret=1&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        dataType: 'html',
        type: 'GET',
        timeout: "3000",
        success: function (data) {
            var data1 = data;
            if ($(data1).find("wpretstr").text().indexOf("200") >= 0) {
                var str = $(data1).find("wpretstr").find("result").text();
                $.cookie("zhuji", str);
                var strArr = "";
                if (str != "") {
                    strArr = str.split(";");
                    for (var i = 0; i < strArr.length; i++) {
                        var controlG = "";
                        var controlNum = "";
                        var soundNum = "";
                        if (strArr[i].indexOf("=") >= 0) {
                            controlG = strArr[i].split("=");

                            if (controlG[0].indexOf("#") >= 0) {
                                controlNum = (controlG[0].split("#"))[1];
                                soundNum = controlG[1];
                                if (i == 2) {
                                    ($("#tvControlShadow4").find(".tv").eq(1)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 3) {
                                    ($("#tvControlShadow4").find(".tv").eq(0)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                }
                            }
                        }
                    }

                }
            }
            hideLoading();
        },
        error: function (a, b, c) {
            if ($.cookie("zhuji") != "" && $.cookie("zhuji") != null) {
                var strArr = "";
                var str = $.cookie("zhuji");
                if (str != "") {
                    strArr = str.split(";");
                    for (var i = 0; i < strArr.length; i++) {
                        var controlG = "";
                        var controlNum = "";
                        var soundNum = "";
                        if (strArr[i].indexOf("=") >= 0) {
                            controlG = strArr[i].split("=");

                            if (controlG[2].indexOf("#") >= 0) {
                                controlNum = (controlG[0].split("#"))[1];
                                soundNum = controlG[1];
                                if (i == 3) {
                                    ($("#tvControlShadow4").find(".tv").eq(1)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                } else if (i == 1) {
                                    ($("#tvControlShadow4").find(".tv").eq(0)).find("li").eq(4).html(Math.round(parseInt(soundNum) / 780));
                                }
                            }
                        }
                    }

                }
            }
            hideLoading();
        }
    })
}
//一键打开年轮灯
function openAllGrowthRing() {
    lightChange('1000_0X550X010XA00X000X010XA0', 0);
    setTimeout("lightChange('1000_0X550X010XA00X000X020XA3', 1)", 1000);
    setTimeout("lightChange('1000_0X550X010XA00X000X030XA2', 2)", 2000);
    setTimeout("lightChange('1000_0X550X010XA00X000X040XA5', 3)", 3000);
    setTimeout("lightChange('1000_0X550X010XA00X000X050XA4', 4)", 4000);


}
//一键关闭年轮灯
function closeAllGrowthRing() {
    lightChange('1000_0X550X010XA10X000X010XA1', 0);
    lightChange('1000_0X550X010XA10X000X020XA2', 1);
    lightChange('1000_0X550X010XA10X000X030XA3', 2);
    lightChange('1000_0X550X010XA10X000X040XA4', 3);
    lightChange('1000_0X550X010XA10X000X050XA5', 4);
}
//窗帘开
function opencurtain() {
    var url1 = "/wpcontrolcomm.asp?wpcontrolcomm=1000_0X550X000X000X030X010XE90X3C";
    $.get(url1);

}
//开窗帘指令
function opencurtainIns(port) {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_0X550X120X340X030X010XAD0X8A&destip=&destport=" + port + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        data: "text",
        dataType: 'text',
        type: 'GET',
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
        },
        error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
function closecurtain() {
    var url1 = "/wpcontrolcomm.asp?wpcontrolcomm=1000_0X550X000X000X030X020XA90X3D";
    $.get(url1);
}
//关窗帘指令
function closecurtainIns(port) {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_0X550X120X340X030X020XED0X8B&destip=&destport=" + port + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        data: "text",
        dataType: 'text',
        type: 'GET',
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
        },
        error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
function pausecurtain() {
    var url1 = "/wpcontrolcomm.asp?wpcontrolcomm=1000_0X550X000X000X030X030X380XE5";
    $.get(url1);
}
//暂停窗帘指令
function pausecurtainIns(port) {
    showLoading();
    $.ajax({
        url: "wpsendudpdata.asp?wpsendudpdata=1000_0X550X120X340X030X030X2C0X4B&destip=&destport=" + port + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000),
        data: "text",
        dataType: 'text',
        type: 'GET',
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
        },
        error: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        }
    })
}
//关闭区域1
function openArea2() {
    lightChange('1000_0XF50X010XFF0XD30X280X000XFF0X11', 1);
    //存放发送第一条节目项所对应的终端的url,格式："http://192.168.1.10:8080",有几个终端调用以下函数几次
    setTimeout('clickFirstPro("http://192.168.1.103:8080")', 1000);
    setTimeout('clickFirstPro("http://192.168.1.103:8080")', 2000);
    setTimeout('stopPPT("http://192.168.1.103:8080")', 3000);

    setTimeout('clickFirstPro("http://192.168.1.104:8080")', 4000);
    setTimeout('clickFirstPro("http://192.168.1.104:8080")', 5000);
    setTimeout('stopPPT("http://192.168.1.104:8080")', 6000);

    setTimeout('clickFirstPro("http://192.168.1.105:8080")', 6000);
    setTimeout('clickFirstPro("http://192.168.1.105:8080")', 7000);
    setTimeout('stopPPT("http://192.168.1.105:8080")', 8000);

    setTimeout('clickFirstPro("http://192.168.1.106:8080")', 10000);
    setTimeout('clickFirstPro("http://192.168.1.106:8080")', 11000);
    setTimeout('stopPPT("http://192.168.1.106:8080")', 12000);

    setTimeout('clickFirstPro("http://192.168.1.107:8080")', 12000);
    setTimeout('clickFirstPro("http://192.168.1.107:8080")', 13000);
    setTimeout('stopPPT("http://192.168.1.107:8080")', 14000);

    setTimeout('clickFirstPro("http://192.168.1.108:8080")', 14000);
    setTimeout('clickFirstPro("http://192.168.1.108:8080")', 15000);
    setTimeout('stopPPT("http://192.168.1.108:8080")', 16000);

    setTimeout('clickFirstPro("http://192.168.1.109:8080")', 17000);
    setTimeout('clickFirstPro("http://192.168.1.109:8080")', 18000);
    setTimeout('stopPPT("http://192.168.1.109:8080")', 19000);

    setTimeout('clickFirstPro("http://192.168.1.110:8080")', 20000);
    setTimeout('clickFirstPro("http://192.168.1.110:8080")', 20000);
    setTimeout('stopPPT("http://192.168.1.110:8080")', 21000);
}
//关闭区域2
function openArea3() {
    lightChange('1000_0XF50X010XFF0XD30X280X010XFF0X10', 2);
    //存放发送第一条节目项所对应的终端的url,格式："http://192.168.1.10:8080",有几个终端调用以下函数几次
    setTimeout('clickFirstPro("http://192.168.1.101:8080")', 2000);
    setTimeout('clickFirstPro("http://192.168.1.102:8080")', 4000);
    setTimeout('clickFirstPro("http://192.168.1.111:8080")', 6000);
}
//关闭区域3
function closeArea3() {
    lightChange('1000_0XF50X010XFF0XD30X280X020XFF0X0F', 3);

    //存放发送第一条节目项所对应的终端的url,格式："http://192.168.1.10:8080",有几个终端调用以下函数几次

    setTimeout('clickFirstPro("http://192.168.1.112:8080")', 1000);
    setTimeout('clickFirstPro("http://192.168.1.112:8080")', 2000);
    setTimeout('stopPPT("http://192.168.1.112:8080")', 3000);

    setTimeout('clickFirstPro("http://192.168.1.113:8080")', 4000);
    setTimeout('clickFirstPro("http://192.168.1.113:8080")', 5000);
    setTimeout('stopPPT("http://192.168.1.113:8080")', 6000);

    setTimeout('clickFirstPro("http://192.168.1.114:8080")', 7000);
    setTimeout('clickFirstPro("http://192.168.1.114:8080")', 8000);
    setTimeout('stopPPT("http://192.168.1.114:8080")', 9000);

    setTimeout('clickFirstPro("http://192.168.1.115:8080")', 10000);
    setTimeout('clickFirstPro("http://192.168.1.115:8080")', 11000);
    setTimeout('stopPPT("http://192.168.1.115:8080")', 12000);

    setTimeout('clickFirstPro("http://192.168.1.116:8080")', 13000);
    setTimeout('clickFirstPro("http://192.168.1.116:8080")', 14000);
    setTimeout('stopPPT("http://192.168.1.116:8080")', 15000);

    setTimeout('clickFirstPro("http://192.168.1.117:8080")', 16000);
    setTimeout('clickFirstPro("http://192.168.1.117:8080")', 17500);
    setTimeout('stopPPT("http://192.168.1.117:8080")', 18000);

    setTimeout('clickFirstPro("http://192.168.1.118:8080")', 19000);
    setTimeout('clickFirstPro("http://192.168.1.118:8080")', 20000);
    setTimeout('stopPPT("http://192.168.1.118:8080")', 21000);
}
function clickFirstPro(firstURL) {
    showLoading();
    var url = firstURL;

    var sendcmdurl = url + "/wpsendclientmsg.asp?rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);

    $.ajax({
        data: { wpsendkeys: 'urlplayer%20-keyevent%200xFF50' },
        url: sendcmdurl,
        dataType: 'html',
        type: 'GET',
        async: true,
        timeout: 5000,  //超时时间
        error: function (xml) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        },
        success: function (xml) {
            hideLoading();
            if (xml) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            }
        }
    });
}
//暂停ppt
function stopPPT(url) {
    showLoading();
    $.ajax({
        data: { wpsendkeys: 'urlplayer%20-keyevent%200x53' },
        url: url,
        dataType: 'html',
        type: 'GET',
        async: true,
        timeout: 5000,  //超时时间
        error: function (xml) {
            hideLoading();
            topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
        },
        success: function (xml) {
            hideLoading();
            if (xml) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
            }
        }
    });
}
//发送指令函数,用来处理和窗口号有关的指令
function docmdex(cmdtype, cmdData) {
    var cmdTypeNum = "";
    if ($("#tabscreen").attr("nowwindow") == undefined || $("#tabscreen").attr("nowwindow") == "") {
        $("#tabscreen").attr("nowwindow", "0");
    }
    if ($("#top").attr("nowwindow") != undefined) {
        cmdTypeNum = 10000 * parseInt($("#top").attr("nowwindow")) + cmdtype;
    } else {
        cmdTypeNum = 10000 * parseInt($("#tabscreen").attr("nowwindow")) + cmdtype;
    } 
    docmd(cmdTypeNum, cmdData);
}
//转到新版本
function newPadControl(){
	window.location.href=window.location.href.split(":8080")[0]+":8080/newpctrl.html"
}
//十六进制颜色随机
function color16(winNum) {
	var color="";
    if (winNum == 1) {
        color = "#ffbf02";
    } else if (winNum == 2) {
        color = "#61ff02";
    } else if (winNum == 3) {
        color = "#02ffde";
    } else if (winNum == 4) {
        color = "#027dff";
    }else if (winNum == 5) {
        color = "#7102ff";
    } else if (winNum == 6) {
        color = "#ff02f5";
    } else if (winNum == 7) {
        color = "#ff0269";
    }
    return color;
}
//小票打印
function printReceipt() {
    showLoading();
    //打印上传的文件
    $.ajax({
        url: newurl+"/wpprintdata.asp",
        type: "get",
        dataType: 'xml',
        data: {
            "wpprintdata": "小票打印模板",
            "utf8": 1,
            "value1": "$(needreplacevalue1)",
            "value2": "$(needreplacevalue2)",
            "value3": "$(needreplacevalue3)",
            "value4": "$(needreplacevalue4)",
            "value5": "$(needreplacevalue5)",
            "value6": "",
            "value7": "",
            "value8": "",
            "value9": "",
            "value10": ""
        },
        success: function (data) {
            hideLoading();
            topTrip("小票打印成功!");
        }, error: function (a, b, c) {
            hideLoading();
            topTrip("小票打印失败!");
        }
    })
    topTrip("暂未开通打印功能");
}
//打印照片照片
function printPictutre(pictureSize) {
    showLoading();
    $.ajax({
        url: newurl + "/wpprintdata.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpprintdata": pictureSize,
            "utf8": "1",
            "value1": $("#proTask .playTask").attr("protaskdesc")
        }, success: function (data) {
            hideLoading();
            topTrip("打印成功");
        }, error: function (data) {
            hideLoading();
            topTrip("打印失败");
        }
    })
}
//打印默认模板
function printDefault() {
    showLoading();
    $.ajax({
        url: newurl + "/wpprintdata.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpprintdata": "默认文件打印模板",
            "utf8": "1",
            "value1": $("#proTask .playTask").attr("protaskdesc")
        }, success: function (data) {
            hideLoading();
            topTrip("打印成功");
        }, error: function (data) {
            hideLoading();
            topTrip("打印失败");
        }
    })
}
//上传并打印
function sPrint1() {
    $("#hideSubmit").click();
    printDefault();
}

//删除数组中的指定元素
Array.prototype.indexOf = function (val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};
Array.prototype.remove = function (val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
}; 