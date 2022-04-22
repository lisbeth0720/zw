var faceInfoArr = [];//声明数组来存储cookie,最多只能存储5条
var isPrint = 0;
var controlRoom = "";
var controlIpName = "";
var color = "";//颜色值
var onlyview = "";//是否是只允许预览
var usegate = "";//是否是多个服务器进行转发指令
var gateip = "";//进行转发的多个服务器的ip地址，以;分割
var gateport = "";//目的服务器的显示端的端口号
var port = "";
//特殊播放器
var itemTypeArr=['mscefurlplayer','hscefurlplayer','rscefurlplayer','msnbplayer','hsnbplayer','rsnbplayer','msimageplayer','hsimageplayer','rsimageplayer','msav4player','hsav4player','rsav4player','msurlplayer','hsurlplayer','rsurlplayer','mstoolbarplayer','hstoolbarplayer','rstoolbarplayer','msairecogplayer','hsairecogplayer','rsairecogplayer'];
//以下变量为对配置文件的设置对应的变量
var conDragScreen=true;
var conTranslation=true;
var conMoreBtn=true;


getConfig();
//弹出对人脸识别的设置页面
function addFace() {   
    getCookieFace();
    $(".searchFaceID").hide();
    $(".faceDetectionContent").css("display", "flex");
    $(".faceDetectionContent").find("input[type=button]").eq(0).attr("onclick", "addFaceOperatorSubmit(this,'addface')"); 
    $(".faceDetectionContent").find("input[type=button]").eq(2).attr("onclick", "addFacePic(this,'snapface')");
    $(".faceDetectionContent").find("input[type=button]").eq(2).val(getLanguageMsg("录入人脸", $.cookie("yuyan")));
    $(".faceULCommon li input").width($(".faceULCommon li select").width() - 40);
    if ($.cookie("faceInfo") != "" && $.cookie("faceInfo") != undefined) {
        faceInfoArr = $.cookie("faceInfo").split(",");
    }
    $(".addFaceOperation").find("input[type=button]").eq(0).attr("onclick", "addFaceOperatorSubmit(this, 'addface')");
    $(".faceDetectionTitle span").html(getLanguageMsg("添加人脸识别标记", $.cookie("yuyan")))
    $(".faceDetectionUL ").css("height", $(".faceDetection").height() - $(".addFaceOperation").height() - $(".faceDetectionTitle").height())
}
//增加人脸
function addFaceOperatorSubmit(thisInfo, type) {
    showLoading();
    var typeMsg = "";
    if ($(".addfaceID ").val() == ""||$(".addfaceID ").val() == " ") {
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")));
        $(".addfaceID ").focus();
        return false;
    }
    if ($(".addfacename").val() == ""||$(".addfacename").val() == " ") {
        topTrip(getLanguageMsg("名字为必填项", $.cookie("yuyan")));
        $(".addfacename  ").focus();
        return false;
    }
    $.ajax({
        url: "wpreccommand.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpreccommand": type,
            "faceid": $(thisInfo).parent().parent().prev().find(".addfaceID").val(),
            "faceinfo": $(thisInfo).parent().parent().prev().find(".addfacejobnumber").val().trim() + "/" + $(thisInfo).parent().parent().prev().find(".addfacename").val().trim() + "/" + $(thisInfo).parent().parent().prev().find(".addfacedepart").val().trim(),
            "utf8":"1"
        }, success: function () {
            hideLoading();
            addCookieName();
        }, error: function () {
            hideLoading();
        }
    })
    addCookieFace();
}
//重置人脸
function resetFace(thisInfo) {
    $(".faceCommon").find("input[type=text]").val("");
}
//更新人脸
function updateFace() {
    //addFace();
    getCookieFace();
    $(".searchFaceID").show();
    $(".faceDetectionContent").css("display", "flex");
    $(".faceDetectionContent").find("input[type=button]").eq(0).attr("onclick", "addFaceOperatorSubmit(this,'updateface')");
    $(".faceDetectionContent").find("input[type=button]").eq(2).attr("onclick", "updateFacerPic(this,'resnapface')");
    $(".faceDetectionContent").find("input[type=button]").eq(2).val(getLanguageMsg("更新人脸", $.cookie("yuyan")))
    $(".faceULCommon li input").width($(".faceULCommon li select").width() - 40);
    if ($.cookie("faceInfo") != "" && $.cookie("faceInfo") != undefined) {
        faceInfoArr = $.cookie("faceInfo").split(",");
    }
   
    $(".faceDetectionUL ").css("height", $(".faceDetection").height() - $(".addFaceOperation").height() - $(".faceDetectionTitle").height());
    $(".faceDetectionTitle span").html(getLanguageMsg("更新人脸识别标记", $.cookie("yuyan")))
   
}
//将新增加的数据添加到cookie中，最多可增加5条，若大于5条将当前数据的最前一条删除
function addCookieFace() {
    faceInfoArr.unshift("ID:" + $(".faceDetectionUL").find(".addfaceID").val() + "_" + "code:" + $(".faceDetectionUL").find(".addfacejobnumber").val() + "_" + "name:" + $(".faceDetectionUL").find(".addfacename").val() + "_depart:" + $(".faceDetectionUL").find(".addfacedepart").val());
    if (faceInfoArr != "" && faceInfoArr != undefined) {  
        if (faceInfoArr.length >= 6) {
            faceInfoArr.pop();
        }  
    } 
    $.cookie("faceInfo", faceInfoArr);
    topTrip(getLanguageMsg("提交成功", $.cookie("yuyan")));
    $(".faceDetectionContent").hide();
    $(".faceDetection").find("input[type=text]").val(" ");
}
//页面加载时调用cookie
function getCookieFace() {
    var faceCookieID = "";
    var str = "<option></option>";
    if ($.cookie("faceInfo") != "" && $.cookie("faceInfo") != undefined) {
        for (var i = 0; i < $.cookie("faceInfo").split(",").length; i++) {
            faceCookieID = $.cookie("faceInfo").split(",")[i].split("_")[0].split(":")[1];
            str += "<option value=" + faceCookieID + " faceInfo=" + $.cookie("faceInfo").split(",")[i]+">" + faceCookieID + "</option>";
        }
        $(".addfaceID").parent().find("select").html(str);
       
    } 
}
//合并人脸
function mergeFace() {
    $(".searchFaceID").hide();
    $(".faceMergeContent").css("display", "flex");
    $(".faceMergeUL  li input").width($(".faceMergeUL  li select").width() - 40);
    $(".faceMerge  input[type=button]").eq(0).attr("onclick", "MergeFaceOperatorSubmit(this)");
    $(".faceDetectionUL ").css("height", $(".faceDetection").height() - $(".addFaceOperation").height() - $(".faceDetectionTitle").height());
    $(".faceMergeTitle span").html(getLanguageMsg("合并人脸识别标记", $.cookie("yuyan")))
    $(".faceMergeUL li span").html(getLanguageMsg("合并ID:", $.cookie("yuyan"))); 
   
    $(".mergefaceID").attr("placeholder", getLanguageMsg("请输入要合并的ID", $.cookie("yuyan")))
}
function MergeFaceOperatorSubmit(thisInfo) {
    showLoading();
    if ($(".mergefaceID ").val() == ""||$(".mergefaceID ").val() == " ") {
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")));
        $(".mergefaceID ").focus();
        return false;
    }
    $(".faceMergeContent").hide();
    $.ajax({
        url: "wpreccommand.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpreccommand": "unionface",
            "faceid": $(thisInfo).parent().parent().prev().find(".mergefaceID").val(),
            "utf8": "1"
        },
        success: function (data) {
            hideLoading();
            topTrip(getLanguageMsg("提交成功", $.cookie("yuyan")));
            $(".faceMergeContent").find("input[type=text]").val(" ");
        }
    })
}
function MergeFaceOperatorCancel(thisInfo) {
    $(".faceMergeUL ").find("input[type=text]").val(" ");
}
//删除人脸
function deleteFace() {
    $(".searchFaceID").hide();
    $(".faceMergeContent").css("display", "flex");
    $(".faceMergeUL  li input").width($(".faceMergeUL  li select").width() - 40);
    $(".faceMergeUL  li span").html(getLanguageMsg("删除ID:", $.cookie("yuyan"))); 
    //debugger;
    
    $(".faceMerge  input[type=button]").eq(0).attr("onclick", "MergeFaceOperatorDelete(this)");
    $(".faceDetectionUL ").css("height", $(".faceDetection").height() - $(".addFaceOperation").height() - $(".faceDetectionTitle").height())

    $(".faceMergeTitle span").html(getLanguageMsg("删除人脸识别标记", $.cookie("yuyan")));
    $(".mergefaceID").attr("placeholder", getLanguageMsg("请输入要删除的ID", $.cookie("yuyan")))
   
}
function MergeFaceOperatorDelete(thisInfo, id) {
	if ($(".faceMergeUL  .mergefaceID").val() == ""||$(".faceMergeUL  .mergefaceID").val() == " ") {
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")))
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")));
        $(".faceMergeUL  .mergefaceID").focus();
        $(".deleteFaceDiv").css("display", "none");
        return false;
    }
    deleteFaceMsg();
    
}
//打开叫号模板
function gotoPage(num) {
    
    $(".pageModelContent").html("");
    $(".pageLoadContent").css("display", "flex");
    $(".pageModelContent").load("menu" + num+".html");
}
//点击删除后弹出的提示框
function deleteFaceMsg() {
   
    var delateFaceStr = '<div class=deleteFaceDiv><div class="deleteFaceContent"><p class="deleteFaceTitle">确定要删除吗</p><div class="deleteFaceBtn"><div class="deleteFaceBtnDiv"><input type="button" value="' + getLanguageMsg("确定", $.cookie("yuyan")) + '" class="submitDelete" onclick="submitDelete()"/><input type="button" value="' + getLanguageMsg("取消", $.cookie("yuyan")) +'" class="cancleDelete" onclick="cancleDelete()"/></div></div></div></div>';
    $("body").append(delateFaceStr);
    $(".deleteFaceDiv").css("display", "flex");
}
function submitDelete() {
    showLoading();
    if ($(".mergefaceID ").val() == ""||$(".mergefaceID ").val() == " ") {
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")));
        $(".mergefaceID ").focus();
        return false;
    }
    $(".deleteFaceDiv").css("display", "none");
    $(".faceMergeContent").css("display", "none");  
    $.ajax({
        url: "wpreccommand.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpreccommand": "delface",
            "faceid": $(".faceMergeUL  .mergefaceID").val(),
            "utf8": "1"
        }, success: function (data) {
            hideLoading();
            $(".faceMergeUL  .mergefaceID").val("");


        }, error: function (data) {
            hideLoading();
        }
    })
}
function cancleDelete() {
    $(".deleteFaceDiv").css("display", "none");
}
function searchFaceInfo(thisInfo) {
    if ($(thisInfo).parent().find(".addfaceID").val() == "" || $(thisInfo).parent().find(".addfaceID").val() == " ") {
        return false;
    }
    showLoading();
    $.ajax({
        url: "wpreccommand.asp",
        type: "get",
        dataType: "html",
        data: {
            "wpreccommand": "queryface",
            "faceid": $(thisInfo).parent().find(".addfaceID").val(),
            "utf8": 1
        }, success: function (data) {
            t = $(data).find("wpretstr").text();
            if (t.indexOf("200 OK") >= 0) {
                var faceStr = (t.split("200 OK ")[1].split("/"));
                var workNum = "";
                if (faceStr.length >= 1) workNum = faceStr[0];
                var name = "";
                if (faceStr.length >= 2) name = faceStr[1];
                var depart = "";
                if (faceStr.length >= 3) depart = faceStr[2];
                $(thisInfo).parent().parent().find("li").eq(1).find("input[type=text]").val(name);
                $(thisInfo).parent().parent().find("li").eq(2).find("input[type=text]").val(workNum);
                $(thisInfo).parent().parent().find("li").eq(3).find("input[type=text]").val(depart);
            } else {
                topTrip(t, 2);
            }
            hideLoading();
        }, error: function (a, b, c) {
            hideLoading();
            console.log(a, b, c)
        }
    })
}
//获取部门列表
function getFaceDepart() {
    showLoading();
    $.ajax({
        url: "faceDepart.xml",
        type: "get",
        dataType: "xml",
        success: function (xml) {
            var str = "<option></option>";
            $(xml).find("item").each(function (i) {
                var deaprtName = $(this).find("name").text();
                str += "<option value=" + deaprtName + ">" + deaprtName + "</option>";
            })
            $(".faceDetectionUL select").eq(1).html(str);
            hideLoading();
        }, error: function (data) {
            hideLoading();
        }
    })
}
//录入人脸照片
function addFacePic(thisInfo) {
   
    if ($(thisInfo).parent().parent().prev().find(".addfaceID").val() == "" || $(thisInfo).parent().parent().prev().find(".addfaceID").val() == " ") {
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")));
        $(thisInfo).parent().parent().prev().find(".addfaceID").focus();
        return false;
    }
    showLoading();
    $.ajax({
        url: "wpreccommand.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpreccommand": "snapface",
            "faceid": $(thisInfo).parent().parent().prev().find(".addfaceID").val(),
            "faceinfo": $(thisInfo).parent().parent().prev().find(".addfacejobnumber").val().trim() + "/" + $(thisInfo).parent().parent().prev().find(".addfacename").val().trim() + "/" + $(thisInfo).parent().parent().prev().find(".addfacedepart").val().trim(),
            "utf8": "1"
        }, success: function () {
            hideLoading();
            topTrip(getLanguageMsg("提交成功", $.cookie("yuyan")));
            addCookieFace();
        }, error: function () {
            hideLoading();
        }
    })
   
}
//更新人脸照片
function updateFacerPic(thisInfo) {
    if ($(thisInfo).parent().parent().prev().find(".addfaceID").val() == "" || $(thisInfo).parent().parent().prev().find(".addfaceID").val() == " ") {
        topTrip(getLanguageMsg("ID为必填项", $.cookie("yuyan")));
        $(thisInfo).parent().parent().prev().find(".addfaceID").focus();
        return false;
    }
    showLoading();
    $.ajax({
        url: "wpreccommand.asp",
        type: "get",
        dataType: "xml",
        data: {
            "wpreccommand": "resnapface",
            "faceid": $(thisInfo).parent().parent().prev().find(".addfaceID").val(),
            "faceinfo": $(thisInfo).parent().parent().prev().find(".addfacejobnumber").val().trim() + "/" + $(thisInfo).parent().parent().prev().find(".addfacename").val().trim() + "/" + $(thisInfo).parent().parent().prev().find(".addfacedepart").val().trim(),
            "utf8": "1"
        }, success: function () {
            hideLoading();
            topTrip(getLanguageMsg("提交成功", $.cookie("yuyan")))
        }, error: function () {
            hideLoading();
        }
    })
}
//打印、上传功能合并，根据参数不同显示不同的操作按钮
function showPrint(isPrint) {
    if (isPrint == "0") {//只上传不打印
        $("input[name=sPrint]").hide();
        $("input[name=postName]").css("width", "70%");
        $(".programPrintBtn").hide();

    } else if (isPrint == "1") {
        $("input[name=sPrint]").show();
        $("input[name=postName]").css("width", "30%");
        $(".programPrintBtn").show();
    }
}
//显示加载图标
function showLoading() {
    $(".loadingShadow").show();
}
//隐藏加载图标
function hideLoading() {
    $(".loadingShadow").hide();
}
//调用远程控制页面
function getScreen() {
    debugger;
    var href = window.location.href.split("\/")[window.location.href.split("\/").length - 2];
    var controlIp = "";
    debugger;
    if (usegate == "0") {
        controlIp = controlIpName.trim() + ":" + port
    } else {
        controlIp = gateip + controlIpName.trim() + ":" + port
    } 
    gateport = gateport == "0" ? "10001" : gateport;
    //var port = "8080";
    if (color == "0" || color == "2") {
        color = "8"
    } else if (color == "3") {
        color = "24"
    } else if (color == "1") {
        color="16"
    }
    window.open('http://' + href + "/wphttpcontrol.html?host=" + controlIp + "&port=" + gateport + "&color=" + color + "&onlyview=" + onlyview
    );
}
var btnJson = "";
function changeValue1(ele) {
    for (var i = 0; i < $(".controlImage img").length; i++) {
        var image = $(".controlImage img").eq(i).attr("src");
        if (image.indexOf("Selected") > 0) {
            var oldImgSrc = image.split("Selected");
            $(".controlImage img").eq(i).attr("src", oldImgSrc[0] + oldImgSrc[1]);
        } else {
            $(".controlImage img").eq(i).attr("src", image);
        }
    }
    //点击全部控制的按钮来切换当前按钮的选中状态图标
    var index = $(".controlImage img").index(ele) + 1;
    changeTab('bar' + index);
    var imgSrc = $(ele).attr("src");

    var imgName = imgSrc.split(".");
    var newImageName = imgName[0] + "Selected";
    $(ele).attr("src", newImageName + ".png");
}

function getbtn(filtype, c) {
    if (c == null || c == "") {
        c = 0;
    }
    var oldStr=$("#bar4").html();
    if (btnJson == "" || btnJson == undefined) {
        $.ajax({
            url: "js/btn"+searchName+".json",
            type: "get",
            dataType: "json",
            async: 'false',
            success: function (data) {
                btnJson = data;
                var data = data[c];
                var dataStr = data.content.btntype;
                var titleStr = "";
                var totoalBarStr = "";
               
                for (var i = 0; i < dataStr.length; i++) {
                    var thisBarStr = "";

                    titleStrName = dataStr[i].name;
                    for (var m = 0; m < dataStr[i].fil.length; m++) {
                        if (dataStr[i].fil[m].filname == filtype) {
                            if (filtype == "newpctrl") {
                                titleStr += '<li class="open" onclick="changeValue1(this)"><img src = "' + dataStr[i].fil[m].imgsrc + '"/><span class="commonImageText">' + dataStr[i].name + '</span></li >';
                            } else {
                                titleStr += '<li class="open"><img src = "' + dataStr[i].fil[m].imgsrc + '"  onclick="changeValue1(this)"/><span class="commonImageText">' + dataStr[i].name + '</span></li >';
                            }
                            
                        }
                    }
                    for (var j = 0; j < dataStr[i].btncontent.length; j++) {
                        var barStr = "";
                        var barTitle = dataStr[i].btncontent[j].title;
                        if (dataStr[i].btncontent.length > 0) {
                            for (var k = 0; k < dataStr[i].btncontent[j].typecontent.length; k++) {
                                barStr += '<li class="sendCmd" onclick="' + dataStr[i].btncontent[j].typecontent[k].evtlistener + '">' + dataStr[i].btncontent[j].typecontent[k].word + '</li >'
                            }
							
                            thisBarStr += '<span class="" style="margin-left:5%;color:#d11b28;display:block;width:95%;clear:both;">' + barTitle + '</span><ul class="cmdBar">' + barStr + '</ul>';
                        }
                    }
                    if(filtype == "newpctrl"&&i==3){
                        totoalBarStr+='<div class="bar" id="bar4">'+oldStr+'</div>';
                    }else{
                        totoalBarStr += '<div class="bar" aaa="aaa" id="bar' + (i + 1) + '">' + thisBarStr + '</div>'
                    } 
                }
                $(".controlImage").html(titleStr);
                
                $(".applies").html(totoalBarStr);
            }, error: function (data) {
                data;
            }
        })
    } else {
        var data = btnJson[c];
        var dataStr = data.content.btntype;
        var titleStr = "";
        var totoalBarStr = "";
        for (var i = 0; i < dataStr.length; i++) {
            var thisBarStr = "";
            titleStrName = dataStr[i].name;
            for (var m = 0; m < dataStr[i].fil.length; m++) {
                if (dataStr[i].fil[m].filname == filtype) {
                    if (filtype == "newpctrl") {
                                titleStr += '<li class="open" onclick="changeValue1(this)"><img src = "' + dataStr[i].fil[m].imgsrc + '"/><span class="commonImageText">' + dataStr[i].name + '</span></li >';
                            } else {
                                titleStr += '<li class="open" ><img src = "' + dataStr[i].fil[m].imgsrc + '"  onclick="changeValue1(this)"/><span class="commonImageText">' + dataStr[i].name + '</span></li >';
                            }
                   // titleStr += '<li class="open" ><img src = "' + dataStr[i].fil[m].imgsrc + '" onclick="changeValue1(this)"/><span class="commonImageText">' + dataStr[i].name + '</span></li >';
                }
            }
            for (var j = 0; j < dataStr[i].btncontent.length; j++) {
                var barStr = "";
                var barTitle = dataStr[i].btncontent[j].title;
                if (dataStr[i].btncontent.length > 0) {
                    for (var k = 0; k < dataStr[i].btncontent[j].typecontent.length; k++) {
                        barStr += '<li class="sendCmd" onclick="' + dataStr[i].btncontent[j].typecontent[k].evtlistener + '">' + dataStr[i].btncontent[j].typecontent[k].word + '</li >'
                    }
                    thisBarStr += '<span class="" style="margin-left:5%;color:#d11b28;display:block;width:95%;clear:both;">' + barTitle + '</span><ul class="cmdBar">' + barStr + '</ul>';
                }
            }
            if(filtype == "newpctrl"&&i==3){
                totoalBarStr+='<div class="bar" id="bar4">'+oldStr+'</div>';
            }else{
                totoalBarStr += '<div class="bar" aaa="aaa" id="bar' + (i + 1) + '">' + thisBarStr + '</div>'
            } 
        }
        $(".controlImage").html(titleStr);
        $(".applies").html(totoalBarStr);
    }

}
function newPadControl(){
   var gourl=window.location.href;
   if(gourl.indexOf("new")>=0){
        window.location.href=gourl.replace("new","");
   }else{
        var newurlArr=gourl.split(":");
        var newurl2Arr=newurlArr[2].split("\/");
        var newurl2=newurl2Arr[1];
        var newurl3Arr=newurl2.split(".");
        newurl3Arr[0]="new"+newurl3Arr[0];
        newurl3Arr.join(".");
        newurl2Arr[1]=newurl3Arr.join(".");
        newurlArr[2]=newurl2Arr.join("\/");
        var gotonewurl=newurlArr.join(":");
        window.location.href=gotonewurl;
   }
}
//封装公共函数用于调用tcp/udp/comm指令
//格式为sendCommonOrder("http://192.168.1.145:8080","tcp","1000_10291828393034","10.19.153.36","12500")
//不设置的可传""
//第二个参数为指令类型
//tcp：tcp指令
//udp:udp指令
//comm：串口指令
function sendCommonOrder(tagIp,orderType,orderStr,orderport,orderip){
    var url="";
    if(orderType=="tcp"){
        if(tagIp=="new"){
            url=newurl+"/wpsend"+orderType+"data.asp?wpsend"+orderType+"data=" + orderStr + "&destip=" + orderip+"&destport=" + orderport+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }else if(tagIp==""){
            url="wpsend"+orderType+"data.asp?wpsend"+orderType+"data=" + orderStr + "&destip=" + orderip+"&destport=" + orderport+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }else{
            url=tagIp+"/wpsend"+orderType+"data.asp?wpsend"+orderType+"data=" + orderStr + "&destip=" + orderip+"&destport=" + orderport+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }
    }else if(orderType=="comm"){
        if(tagIp=="new"){
            url=newurl + "/wpcontrol"+orderType+".asp?wpcontrol"+orderType+"=1000_" + orderStr + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }else if(tagIp==""){
            url="wpcontrol"+orderType+".asp?wpcontrol"+orderType+"=1000_" + orderStr + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }else{
            url=tagIp + "/wpcontrol"+orderType+".asp?wpcontrol"+orderType+"=1000_" + orderStr + "&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }
    }else if(orderType=="udp"){
        if(tagIp=="new"){
            url=newurl+"/wpsend"+orderType+"data.asp?wpsend"+orderType+"data="+orderStr+"&destip="+orderip+"&destport="+orderport+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }else if(tagIp==""){
            url="wpsend"+orderType+"data.asp?wpsend"+orderType+"data="+orderStr+"&destip="+orderip+"&destport="+orderport+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }else{
            url=tagIp+"/wpsend"+orderType+"data.asp?wpsend"+orderType+"data="+orderStr+"&destip="+orderip+"&destport="+orderport+"&rnd=" + (Math.floor(Math.random() * (9999 - 1000)) + 1000);
        }
    }
    $.ajax({
        url: url,
        dataType: 'html',
        type: 'GET',
        timeout: 15000,		//超时时间
       
        error: function (xml) {
            topTrip("发送失败", 2);
        },
        success: function (xml) {
            if (xml) {
                topTrip("发送成功", 1);
            }
        }
    });
}
//封装公共函数用于同时调用多个指令 并有时间间隔
function sendSomeOrder(func,orderArr,time){
    for(var i=0;i<orderArr.length;i++){
        
        (function(i){
            setTimeout(function(){
                var tagIp=orderArr[i].split("_")[0];
                var orderType=orderArr[i].split("_")[1];
                var orderStr=orderArr[i].split("_")[2];
                var orderport=orderArr[i].split("_")[3];
                var orderip=orderArr[i].split("_")[4];
                func(tagIp,orderType,orderStr,orderport,orderip);
            },i*1000*time)
        })(i)
    }
}
function ItemType(itemtype, downLink) {
    var newtype=parseInt(itemtype.split("-")[0]);
    //音视频
    if (newtype == 10 || newtype == 1010 || newtype == 9 || newtype == 1009) {
        return getLanguageMsg("音视频", $.cookie("yuyan"));
    }
    else if (newtype == 8 || newtype == 1008)//office文档
    {
        //判断office文件中只有含有ppt和pptx才是ppt文件，其他的不做ppt处理
        if (downLink != null && (downLink.indexOf(".ppt") >= 0 || downLink.indexOf(".pptx") >= 0)) {
            return getLanguageMsg("Office文档", $.cookie("yuyan"));
        } else {//除了ppt和pptx的office文档当做图类型处理片
            return getLanguageMsg("图片", $.cookie("yuyan"));
        }
    }//对文档进行处理
    else if (newtype == 1 || newtype == 1001) {
        return getLanguageMsg("文本", $.cookie("yuyan"));
    }
    else if (newtype == 0 || newtype == 1000 || newtype == 11 || newtype == 1011) {
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
            if (newtype == 11 || newtype == 1011) {
                return getLanguageMsg("操作系统自检", $.cookie("yuyan"));
            }else {
                return getLanguageMsg("自适应", $.cookie("yuyan"))
            }
        }
    } else if (newtype == 2 || newtype == 1002) {//其他的所有格式都当做图片进行处理
        return getLanguageMsg("网页", $.cookie("yuyan"));

    } else if (newtype == 3 || newtype == 1003) {
        return getLanguageMsg("图片", $.cookie("yuyan"));
    } else if (newtype == 4 || newtype == 1004) {
        return getLanguageMsg("通知(静态)", $.cookie("yuyan"));
    } else if (newtype == 5 || newtype == 1005) {
        return getLanguageMsg("通知(向上滚动)", $.cookie("yuyan"));
    } else if (newtype == 6 || newtype == 1006) {
        return getLanguageMsg("字幕(向左滚动)", $.cookie("yuyan"));
    } else if (newtype == 7 || newtype == 1007) {
        return getLanguageMsg("动画", $.cookie("yuyan"));
    } else if (newtype == 13 || newtype == 1013) {
        return getLanguageMsg("远程指令", $.cookie("yuyan"))
    } else if (newtype == 14 || newtype == 1014) {
        return getLanguageMsg("栏目", $.cookie("yuyan"))
    }else if(newtype == 12 || newtype == 1012){
        
        return getExeName(itemtype);
    }
}
//根据应用程序名显示名称
function getExeName(itemType){
    var getArr=["AiRecogPlayer.exe","AV4Player.exe","AVPlayer.exe","CefUrlPlayer.exe","ClockPlayer.exe",
                "FlashPlayer.exe","FullPPTPlayer.exe","HKVideoPlayer.exe","Htmlsnap.exe","ImagePlayer.exe",
                "ImageSPlayer.exe","killprocess.exe","MeterPlayer.exe","MultiCastVideoPlayer.exe",
                "NBPlayer.exe","NOTEPAD.exe","P2PClientIf.exe","pmtplayer.exe","PowerPnt.exe","PptView.exe",
                "ProgControl.exe","QRPlayer.exe","RecordPlayer.exe","RS232Commander.exe","ScrollTxtPlayer.exe",
                "SoundVolume.exe","TimePmtPlayer.exe","TimerClockPlayer.exe","TimerPaint.exe","ToolBarPlayer.exe",
                "TVPlayer.exe","UpdateSys.exe","UrlPlayer.exe","UrlToMyHtm.exe","WiseAudio.exe","WiseCCCPlayer.exe",
                "WiseDisplayClient.exe","WiseDisplayServer.exe","WisePing.exe","WiseRecScreen.exe","WiseRouter.exe",
                "WiseScreenSnap.exe","WiseSendInfo.exe","WiseSignPlayer.exe","WordToHtml.exe"];
    var sendArr=["人工智能识别","音视频","音视频","网页","表盘时钟","动画","演讲稿播放器","网络流媒体","网页截图",
                "图片","图片","进程清理","仪表盘","广播音视频","音视频/电视","记事本","P2P快速分发","音乐及歌词",
                "讲稿","讲稿","程序运行管理","二维码","记录列表","串口/指令","同步LED字幕","音量方案设置","数字时钟",
                "多功能计时器","键盘鼠标活动监视器","便捷工具条","电视播放/换台","系统更新助手","网页","网页下载","语音通讯",
                "远程桌面","显示端","控制端","网络在线/断线检测","慧易录","控制代理服务器","截图工具","边缘计算中心","慧指签名",
                "office文档转网页"];
    for(var i=0;i<getArr.length;i++){
        if(itemType.indexOf(getArr[i])>=0){
            return getLanguageMsg(sendArr[i], $.cookie("yuyan"));
        }
    } 
}
//放大或全屏播放

//全屏播放
function changeSize(thisItem){
    var itemType=$(thisItem).next().attr("itemtype").split("-")[1].toLowerCase();
    var taskid=$(thisItem).next().attr("taskid");
    var winNum=parseInt($(thisItem).next().attr("windowsnum"));
    if(changeSizeCommon(itemType)){   
        docmd(16,taskid);
        docmd(winNum*10000+3086,0)
    }  else{      
       docmd(67,taskid);
    }
  
}
//判断是否有特殊标记
function changeSizeCommon(itemType){
    var sameType=false;
    if(itemType.indexOf("_")>=0){
        itemType=itemType.split("_")[1].split(".")[0];
    }
    for(var i=0;i<itemTypeArr.length;i++){
        if(itemType==itemTypeArr[i]){         
            sameType=true;
            break;
        }
    }
    return sameType;
}
//将选择后的文件添加到页面中的文本框中
function changevalue() {

    if ($("#hideUploadFile").val() == "") {
        // $("#chooseFile").val("选择文件");
        $("#chooseFile").val(getLanguageMsg("选择文件", $.cookie("yuyan")));
    } else {
        var showFileValue = $("#hideUploadFile").val().split("\\")[$("#hideUploadFile").val().split("\\").length - 1];
        $("#chooseFile").val(showFileValue);
    }
    $("#postName").val($("#hideUploadFile").val());
}
var uploadInterval = "";
//上传文件时判断是否为空
function onCmdOk() {
    var rndomStr = Math.floor(Math.random() * 100000);
    $("input[name=rndmark]").val(rndomStr);
    $(".uploadRateShadow").css("height", $(".fileTK").height() - $(".fileTitle").height());
    $(".uploadRateShadow").css("top", parseInt($(".fileTK").css("marginTop")) + parseInt($(".fileTitle").height()));  
    if ($("#hideUploadFile").val() == "") {
        //alert("请选择要上传的文件");
        return false;
    } else {
        if ($(".screenList").eq(0).attr("homeid") == "home") {
            $("#fileSubmit").attr("action", "wpfileupload.asp?utf8=1&rndmark=" + rndomStr);

        } else {
            $("#fileSubmit").attr("action", newurl + "/wpfileupload.asp?utf8=1&rndmark=" + rndomStr);
        }
        $(".uploadRateShadow").show();
    }
    $("#uploadRate").css("marginTop", ($(".uploadRateShadow").height() - $("#uploadRate").height()) / 2);
    $("#uploadValue").css("marginTop", ($(".uploadRateShadow").height() - $("#uploadValue").height()) / 2)
    //setTimeout("getUpProgress()",500);
    uploadInterval = setInterval("getUpProgress()", 1000);
    return true;
}
//获取上传进度
function getUpProgress() {
    var dataRate = 0;
    if ($("form").attr("uploadResult") == "ok") {
        clearInterval(uploadInterval);
        $("form").attr("uploadResult", "no");
        $(".uploadRateShadow").hide();
        $("#uploadRateLeft").css("width", "100%");
        $("#uploadValue").html(dataRate + "100%");
    }
    if ($("#proTask").css("display") == "block") {
        $(".uploadRateShadow").hide();
        $("#uploadRateLeft").css("width", "100%");
        $("#uploadValue").html(dataRate + "%");
    }

    $.ajax({
        url: newurl + "/wpuploadprocess.asp",
        type: "get",
        dataType: "html",
        timeout: "3000",
        data: {
            "wpuploadprocess": $("input[name=rndmark]").val(),
            "utf8": "1",
            "json": "1"
        },
        scriptCharset: "utf-8",
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        success: function (data) {
            var data=eval("("+data+")");
            var status=data.result;
            if (status=="200 OK") {
                dataRate = parseInt(data.value);
                $("#uploadRateLeft").css("width", dataRate + "%");
                $("#uploadRateLeft").css("width", dataRate + "%");
                $("#uploadValue").html(dataRate + "%");
            }else if(status.indexOf("201")>=0){
                $(".uploadRateShadow").hide();
                $("#uploadRateLeft").css("width", "100%");
                //$("#uploadValue").html(dataRate + "100%");
            }else if (status.indexOf("301") >= 0) {
                $(".uploadRateShadow").hide();
                $("#uploadRateLeft").css("width", "0%");
                $("#uploadValue").html(dataRate + "0%");
            }
            console.log(data);
            // if(data)
        }, error: function (a, b, c) {
            if (b == "timeout") {
                getLanguageMsg("请求超时,请重试");
            } else {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
            }
        }
    })
}
//当数据上传成功后，需要在上传数据的弹出框中显示对当前上传数据的播放操作按钮。
function showplay() {
    $("#fileSubmit").css("display", "none");
    $("#proTask").css("display", "block");
    $(".proName").css("width", $(".playTask").width() - 60);

    $(".proPrintBtn").show();
    $(".uploadRateShadow").hide();
    clearInterval(uploadInterval);
}
//语音识别调用
function getSoundStr(str){
    if(str.indexOf("跳")>=0||str.indexOf("跳转")>=0||str.indexOf("播放")>=0||str.indexOf("播")>=0){
        var str1 = str;
        var num = str1.replace(/[^\d]/g,'');
        var num1=0;
        if(!isNaN(parseInt(num))){
            num1=parseInt(num);              
        }else{
            num1 = changeNum(str); 
        }
        if(num1!=0){
            if(num1<=0||num1>$(".left").length){
            }else{
                $(".left").eq(num1-1).find(".playNowprogram").click(); 
            }             
        }else{
           return;
        }       
    }else if(str.indexOf("手动播放")>=0||str.indexOf("手动模式")>=0){
        $(".handControl").click();
    }else if(str.indexOf("自动播放")>=0||str.indexOf("自动模式")>=0){
        $(".startProgram").click();
    }else if($(".current").attr("downlink").indexOf(".ppt") >= 0||$(".current").attr("downlink").indexOf(".pptx") >= 0||$(".current").attr("downlink").indexOf(".ppsx") >= 0){
        if(str.indexOf("上一页")>=0){
            $(".before").click();
        }else if(str.indexOf("下一页")>=0){
            $(".next").click();
        }
    }else{       
        for(var i=0;i<$(".sendCmd").length;i++){
            if(str.indexOf($(".sendCmd").eq(i).text())>=0||$(".sendCmd").eq(i).text().indexOf(str)>=0){
                $(".sendCmd").eq(i).click();
                break;
            }
        }
    }
}
//将中文汉字转换成数字
function changeNum(str){
    for(var i=0;i<str.length;i++){
        switch(str[i]){
            case "一":
                return 1;
                break;
            case "二":
                return 2;
                break;
            case "三":
                return32;
                break;
            case "四":
                return 4;
                break;
            case "五":
                return 5;
                break;
            case "六":
                return 6;
                break;
            case "七":
                return 7;
                break;
            case "八":
                return 8;
                break;
            case "九":
                return 9;
                break;
            case "十":
                return 10;
                break;
        }
    }
}
//链接到资源文件获取页面
function SourceGet() {
    if (newurl == "") {
        window.location.href = window.location.href.split("/")[0] + "//" + window.location.href.split("/")[1] + window.location.href.split("/")[2] + "/source.html";
    } else {
        window.location.href = newurl + "/source.html";
    }
    $.cookie("reseturl", window.location.href);
}
//获取配置文件信息
function getConfig(){
    $.ajax({
        url:"js/config.json",
        type:"get",
        dataType:"text",
        success:function(data){
            var data=eval("("+data+")");
            data=data[0];
            if(data.dragScreen!=undefined){
                conDragScreen=data.dragScreen;
            }
            if(data.translation!=undefined){
                conTranslation=data.translation;
                if(!conTranslation){
                    $(".changeLanguage").hide();
                    $.cookie("yuyan","CH");
                }else{
                    $(".changeLanguage").show();
                }
            }
            if(data.morebtn!=undefined){
                if(!data.morebtn){
                    $(".commonMoreBtn").hide();
                }else{
                    $(".commonMoreBtn").show()
                }
                conMoreBtn=data.morebtn;
            }
        }
    })
}
//LCD开
function openOrCloseLCD(type) {
    if ($(".topConfirm").attr("messageTip") == "ok") {
       if(type=="Turn-On TV"){
            openLCD();
       }else{
            closeLCD();
       }
    } else {
        if(type=="Turn-On TV"){
            tipMessage("确定要打开LED吗?", "openLCD");
       }else{
            tipMessage("确定要关闭LED吗?", "closeLCD");
       }
    }
}
function openLCD(){
    //if ($(".topConfirm").attr("messageTip") == "ok") {
        var cn = $("#top").attr("clientname");
        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=Turn-On TV&maintype=6&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + cn + "&commandparam=-must&dohere=0",
            type: "get",
            dataType: "text",
            success: function (data) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            }, error: function (data) {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
        
    // } else{
    //     tipMessage("确定要打开LED吗?", "openLCD");
    // }
}
function closeLCD(){
   // if ($(".topConfirm").attr("messageTip") == "ok") {
        var cn = $("#top").attr("clientname");
        $.ajax({
            url: "wpcontrolcenter.asp?wpcontrolcenter=Turn-Off TV&maintype=6&subtype=0&companyid=wisepeak&utf8=1&cnlist=" + cn + "&commandparam=-must&dohere=0",
            type: "get",
            dataType: "text",
            success: function (data) {
                topTrip(getLanguageMsg("发送成功", $.cookie("yuyan")), 1);
                $(".topConfirm").attr("messageTip", "");
            }, error: function (data) {
                topTrip(getLanguageMsg("发送失败", $.cookie("yuyan")), 2);
                $(".topConfirm").attr("messageTip", "");
            }
        })
       
    // } else{
    //     tipMessage("确定要关闭LED吗?", "closeLCD");
    // }
}
//将选择后的文件添加到页面中的文本框中
//function changevalue() {
//    if ($("#hideUploadFile").val() == "") {
//        $("#chooseFile").val(getLanguageMsg("选择文件", $.cookie("yuyan")));
//    } else {
//        var showFileValue = $("#hideUploadFile").val().split("\\")[$("#hideUploadFile").val().split("\\").length - 1];
//        $("#chooseFile").val(showFileValue);
//    }
//    $("#postName").val($("#hideUploadFile").val());
//}

