<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_groupinfo.aspx.cs" Inherits="Web.company.client.client_groupinfo" %>

<script type="text/javascript">
    var lastsendnum = 0;
    var lastsendnum2 = 0;
    var lastid = 0;
    var clientid;
    var mark;
    
    try {
        if (typeof (refreshStataus) != "undefined") {//本页面   //定时  刷新媒体播放终端状态
            clearInterval(refreshStataus);
        }
        if (typeof (myInterTimerg) != "undefined") {//本页面   //获取终端/终端组  包含的节目单，传输状态
            clearInterval(myInterTimerg);
        }
        if (typeof (myInterTimer) != "undefined") {
            clearInterval(myInterTimer);
        }
        if (typeof (timerClientStataus) != "undefined") {//本页面   //控制室 2分钟后更新状态( 连线---》在线)。8分钟后更新状态(在线--》离线)
            clearInterval(timerClientStataus);
        }
    } catch (xe) {

    }
    
    var timerClientStataus;//查询 终端状态,定时器
    var refreshStataus;
    //window.onunload = function () {//离开页面，清理定时器
    //    clearInterval(myInterTimerg);
    //}
    //$(window).unload(function () {
    //    clearInterval(myInterTimerg);
    //    clearInterval(myInterTimer);
    //});
    
    $(function () {
        getJsonValue();
        dlevel = $("#client_groupinfo_dlevel").val();
        clientid = $("#client_groupinfo_clientid").val();
        mark = $("#client_groupinfo_mark").val();
        getdata("0");
        $("#client_list_loadmore").click(function () {
            getdata("1");//加载更多
        });
        switchLanguage("#zyyclient_list_tab1", 1, "client_groupinfo.aspx");
        //refreshStataus = setInterval(refreshStatus, 5000);////定时  刷新媒体播放终端状态

        getMenusProcessg();
        //7月12添加全选功能
        function DoCheck() {
            console.log(3);
            var ch = document.getElementsByName("client_groupinfo_check");
            if (document.getElementsByName("allChecked")[0].checked) {
                for (var i = 0; i < ch.length; i++) {
                    ch[i].checked = true;
                }
            } else {
                for (var i = 0; i < ch.length; i++) {
                    ch[i].checked = false;
                }
            }
        }
        $("#allChecked").click(function () {
            DoCheck();
        });



    })
    function getdata(types) {
        var sortField = $("#sort").val();//排序字段
        var sortType = 1;//排序类型：0降序， 1 升序
        //sortType = $("#sortby").attr("checked") == "checked" ? 1 : 0;
        sortType = $("#sortby").attr("value");
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var isvirtualgroup = "no"; 
        if (treeObj.getSelectedNodes().length > 0) {
            if (treeObj.getSelectedNodes()[0].groupflag == "2") {////‘虚拟组’ 显示终端。。。
                isvirtualgroup = "yes";
            } else if (treeObj.getSelectedNodes()[0].groupflag == "0") {//如果点击终端，client
                isvirtualgroup = "client";
            }
        }
        $.ajax({
            type: 'post',
            url: 'ajax/getclientlist.ashx',
            async: true,
            dataType: 'text',
            data: { "gid": clientid, "dlv": dlevel, "mark": mark, "lastid": lastid, "name": $("#client_groupinfo_name").val(), "sortField": sortField, "sortType": sortType, "isvirtual": isvirtualgroup },
            success: function (data) {//旧版B/S：一级终端组 也可以是‘虚拟组’？？？？ 
                //终端组共有3 级，1，2，3   。。。     一级终端组是‘实体组’； 2级、3级终端组可以是‘虚拟组’
                /*1.‘删除组内终端’---按钮(批量删除)。2.终端行记录中的 ‘删除’ 图标。。。
                1.2.只有点击 3 级终端组，这两个按钮才会显示.。。。。
                */
                
                var currentGroup = "";
                var deleteButton = "</td></tr>";
                var deleteFlag = "no";
                if (treeObj.getSelectedNodes().length>0) {
                    currentGroup = treeObj.getSelectedNodes()[0];
                    //if (currentGroup.dlevel == "3") {//点击 3 级终端组
                    if (currentGroup.level == "2") {
                        //if (currentGroup.groupflag == "1") {//groupflag == "1" //点击了‘实体组’
                        //    deleteFlag = "yes";
                        //}                         
                        deleteFlag = "yes";
                    } else if (currentGroup.level == "3") {//点击  终端(实体组、虚拟组下的终端)
                        deleteFlag = "yes";
                    }
                }
               // var myflag = treeObj.getNodesByParam("id", clientid, null)[0].groupflag;//根据 ID 获取 ‘点击的终端组’ 是不是虚拟的
                var isVirtual = "no";
                var myHtml = "";
                var myLink = "";
                //if (myflag == "2") {//虚拟组，  不能编辑终端属性 //因为有 批量修改属性(根据clientmark)
                //    // isVirtual = "yes";//链接，编辑按钮  // 2018.10.31  whq 修改。。。可以编辑
                //}
                var json = strToJson(data);
                var mymark = "";
                var i = 0; var myStatus = "";
                if (types == "0") {//首次加载
                    $("#client_list_tab tr[data-type='data']").remove();
                }
                //$("#client_list_tab tr[data-type='data']").remove();
                $.each(json.Table, function (idx, item) {
                    if (deleteFlag!="no") {
                        deleteButton = '<a href="javascript:void(0)" title="删除" onclick="TopDeleteClientMessage(' + item.clientid + ')" style="position:relative;top:3px;"><img src="/images/icon_del.png"></a></td></tr>';   //只有点击 3 级终端组/终端，这个按钮才会显示.
                    }
                    //if (i == 0) {//好像没用？？
                    //    $("#client_list_selectid").val(item.clientid);
                    //    $("#client_list_selectmark").val(item.clientmark);
                    //}
                    //0-11，在线(任务未启动),在线(任务自动执行),在线(任务手动执行),在线(临时信息显示),在线(紧急信息显示),在线(任务执行完毕),在线(任务暂停执行),在线(用户介入),在线(空闲自动执行),远程控制,全部                   
                    i++;
                    switch (parseInt(item.playstatus)) {
                        case 0: myStatus = "离线"; break;
                        case 1: myStatus = "在线(任务未启动)"; break;
                        case 2: myStatus = "在线(任务自动执行)"; break;
                        case 3: myStatus = "在线(任务手动执行)"; break;
                        case 4: myStatus = "在线(临时信息显示)"; break;
                        case 5: myStatus = "在线(紧急信息显示)"; break;
                        case 6: myStatus = "在线(任务执行完毕)"; break;
                        case 7: myStatus = "在线(任务暂停执行)"; break;
                        case 8: myStatus = "在线(用户介入)"; break;
                        case 9: myStatus = "在线(空闲自动执行)"; break;
                        case 10: myStatus = "远程控制"; break;

                        default: myStatus = "全部";
                    }
                    if (item.clientmark == "" || item.clientmark==null) {
                        mymark = '<a title="' + getLanguageMsg("在虚拟组中", $.cookie("yuyan")) + '" style="background:url(/images/tubiaoa.png) no-repeat scroll -152px -80px;width: 16px;height: 16px;display:inline-block;position:relative;top:9px;"></a>';//mymark = "在虚拟组中";
                    } else {
                        mymark = '<a title="' + getLanguageMsg("在实体组中", $.cookie("yuyan")) + '" style="background:url(/images/tubiaoa.png) no-repeat scroll -150px -56px;width: 16px;height: 16px;display:inline-block;position:relative;top:9px;"></a>';//mymark = "在实体组中";
                    }
                   // mymark = item.clientmark;
                    var statushtml = '<span class="icon state_' + (parseInt(item.playstatus) + 1) + '" title="' + getLanguageMsg(myStatus, $.cookie("yuyan")) + '" style="position:relative;left:26px;"></span>';
                    if (item.clientname.length > 8) { client_group = item.clientname.substr(0, 7) + "..." }
                    var client_group = item.clientname;//--whq2.8 实体组、虚拟组： 可以编辑 终端属性。。。。
                    if (isVirtual=="no") {
                        myHtml = '<a href="javascript:void(0)" title="' + getLanguageMsg("编辑", $.cookie("yuyan")) + '" onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')" style="position:relative;top:3px;"><img src="/images/icon_edit.png"></a>';//显示编辑按钮
                        myLink = '<a onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')" style="cursor:pointer">' + client_group + '</a>';//终端名称 显示‘超链接’，点击可以编辑。
                    } else {
                        myLink = client_group;//虚拟组下的终端，只显示 ‘终端名称’。不能编辑 
                        //--2.8可以编辑  ---//虚拟组，  不能编辑终端属性 //因为有 批量修改属性(根据clientmark)
                    }
                    
                    $("#client_list_tab").append('<tr data-type="data" data-id="' + item.clientid + '" data-name="' + item.clientname + '"  data-ipaddress=' + item.ip + '><td><input type="checkbox" value="' + item.clientid + '" name="client_groupinfo_check" style="position:relative;top:6px;"><span class="client_gnumber">' + item.clientid + '</span>' + '&nbsp;' + statushtml + mymark + '</td>'   //
                        + '<td title="' + item.clientname + '">'+myLink+'</td>'
                        + '<td>' + item.ip + '</td>'
                        + '<td>' + item.startuptime + '</td>'
                        + '<td>' + item.shutdowntime + '</td>'
                        + '<td><div style="width:100px; height:20px; margin:0 5px; background:#ddd;"><div class="process" style="height:20px; color:#fff;display: initial;"><div></div></td>'//‘未找到’ 变成竖着显示。。。。
                        //+ '<td align="center">' + statushtml + '</td>'
                        + '<td>'
                        +myHtml
                       // + '<a href="javascript:void(0)" title="预览" onclick="clientScreen(' + item.clientid + ',' + item.playstatus + ')"><img src="/images/icon_ss.png" /></a>'
                        + deleteButton
                        );
                    //$("#client_list_tab").append();
                    lastid = item.clientid;
                });
                if (i < 8) {
                    $("#client_list_loadmore").hide();//加载更多
                }
                //getclientprocessstatus();//控制室 2分钟后更新状态( 连线---》在线)。8分钟后更新状态(在线--》离线)
                timerClientStataus= setInterval(getclientprocessstatus, 5000);//当终端断网，再上线。。。。
            }
        });
    }
    function clientScreen(clid, playStatus) {//wisepeak/image/14/   0711/0809.jpg
        if (playStatus.toString() == "0") {
            alert(getLanguageMsg("终端离线，不能预览屏幕", $.cookie("yuyan")));
            return false;
        }
        var mycomID = $("#client_groupinfo_comid").val();
       // if (mycomID == "") { mycomID = "wisepeak"; }
        var url = "companyid=" + mycomID + "&maintype=5&subtype=33&groupid=0&clientid=" + clid + "&merit=5&ismobile=&fordebug=&commandname=&utf8=1&param=||" + mycomID + "/image/" + clid + "/";///cgi-bin/preparefilecgi.cgi?
        var time = new Date();
        var hour = time.getHours();
        var minute = time.getMinutes();//IE , "2017/7月14日"
        time = time.toLocaleDateString().replace("年", "/").replace("月", "/").replace("日", "/");

        var imageUrl = time.split('/')[1] + time.split('/')[2] + "/";//711
        if (hour < 10) {
            hour = "0" + hour.toString();
        }
        if (minute < 10) {
            //imageUrl += hour.toString() + "0" + minute.toString();//2017/7/11 10:47
        } else {
            //imageUrl += hour.toString() + minute.toString();
        }
        imageUrl += clid + ".jpg";
        url += imageUrl;
        window.open('/company/client/ClientScreenPhoto.aspx?' + url, 'screenpicwhq', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,resizable=yes,scrollbars=yes', true);

    }
    function getclientprocessstatus() {//点击终端组，查询下面所有终端状态；点击终端，查询 终端状态
        var clientidlist = "";
        var clientnamelist = "";
        $("#client_list_tab tr[data-type=data]").each(function () {
            clientidlist = clientidlist + $(this).attr("data-id") + ",";
            clientnamelist = clientnamelist + $(this).attr("data-name") + ",";
        });
        if (clientidlist.length > 0) {
            clientidlist = clientidlist.substring(0, clientidlist.length - 1);
        }
        var statussendidlist = "";
        var totallength = clientidlist.split(",").length;
        //if (lastsendnum2 == totallength) {
        //    lastsendnum2 = 0;
        //}
        //var forlength = Math.min(lastsendnum2 + 2, totallength);
        for (var i = 0; i < totallength; i++) {// i = lastsendnum2; i < forlength;
            //lastsendnum2++;
            if (clientidlist.split(",")[i] != "") {
                statussendidlist = statussendidlist + clientnamelist.split(",")[i] + ":" + clientidlist.split(",")[i] + ";";
            }
        }
        $.ajax({
            type: 'post',
            url: '/cgi-bin/preparefilecgi.cgi?maintype=4&subtype=92&clientname=' + statussendidlist + '&merit=' + $("#client_groupinfo_userlevel").val() + '&companyid=' + $("#client_groupinfo_comid").val() + "&charset=utf-8&utf8=1",
            async: false,//同步请求
            timeout: 3000,
            dataType: 'text',
            success: function (data) {
                if (data.indexOf("<queryreturn>") > 0) {
                    var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                    var mynodes="";// = treeObj.getNodesByParam("id", cid, null);//根据条件，获取节点。 //终端。
                    //treeObj.updateNode(mynodes[0]);//更新节点
                    var clientStatus = 0;
                    data = data.substring(data.indexOf("<queryreturn>") + 13, data.indexOf("</queryreturn>"));
                    if (data=="") {//2019.1.4//要是没有查到结果呢？？！！
                        //<!--wpbeginmark-->200 OK     <queryreturn></queryreturn>     <!--wpenmark-->

                    }
                    for (var i = 0; i < data.split(";").length-1; i++) {
                        var result = data.split(";")[i];
                        //data //14:598:402000:2017-06-28 15:44:43_0;10:0:0;
                        // 14:706:401100:2017-08-08 09:36:44;
                        //终端1ID:节目单1ID:(传输状态)(前2位状态)后3位传输进度百分数:节目单版本号;终端2ID:(传输状态)(前2位状态)后3位传输进度百分数:节目版本号）
                        //var cid = result = data.split(";")[0];//
                        //var sendstatus = data.split(";")[2][0];//

                        var cid = result.split(":")[0];
                        //未找到终端记录=0,离线=1(曾经有pconnect)，未传输=2，传输中=3，传输完毕=4
                        var sendstatus = result.split(":")[2][0];//4
                        if (sendstatus == 0) {//.icon  --终端树形列表。。
                            //$("#client_list_tab tr[data-id=" + cid + "] td .icon").addClass("state_1");
                            clientStatus = 0;
                            $("#client_list_tab tr[data-id=" + cid + "] td div .process").html(getLanguageMsg("未找到", $.cookie("yuyan"))).css("background", "#ddd");
                        }
                        if (sendstatus == 1) {
                            //$("#client_list_tab tr[data-id=" + cid + "] td .icon").addClass("state_1");
                            clientStatus = 0;
                            $("#client_list_tab tr[data-id=" + cid + "] td div .process").html(getLanguageMsg("离线", $.cookie("yuyan"))).css("background", "#ddd");
                        }
                        if (sendstatus == 2) {//402000
                            //var status = data.split(";")[2].substring(1, 2);
                            var status = result.split(":")[2].substr(1, 2);//02
                            // $("#client_list_tab tr[data-id=" + cid + "] td .icon").addClass("state_" + (parseInt(status)));
                            //clientStatus = parseInt(status);
                            $("#client_list_tab tr[data-id=" + cid + "] td div .process").html(getLanguageMsg("未传输", $.cookie("yuyan"))).css("background", "#ddd");
                        }
                        if (sendstatus == 4) {//sendstatus == 3
                            //var status = data.split(";")[2].substring(1, 2);
                            //var process = data.split(";")[2].substring(1, 2);
                            var status = result.split(":")[2].substr(1, 2);//02 状态
                            var process = result.split(":")[2].substr(3, 3);//000  进度100
                            // $("#client_list_tab tr[data-id=" + cid + "] td .icon").addClass("state_" + (parseInt(status)));
                            clientStatus = parseInt(status);
                            //$("#client_list_tab tr[data-id=" + result.split(":")[0] + "] td div .process").css("background", "#00f80c").animate({ "width": result.split(":")[3] + "%" }).html(result.split(":")[2] + "%");
                            $("#client_list_tab tr[data-id=" + result.split(":")[0] + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(process) + "%" }).html(parseInt(process) + "%");
                            clearInterval(timerClientStataus);//传输完毕,就停止CGI查询。。。。。！！2019.1.4

                            // $("#client_list_tab tr[data-id='14'] td div .process").css("background", "#00f80c")
                            //.animate({ "width": "50%" }).html("50%");    //OK   ..clientid=14
                        }
                        if (sendstatus == 3) {//sendstatus == 4
                            //var status = data.split(";")[2].substring(1, 2);
                            var status = result.split(":")[2].substr(1, 2);
                            //$("#client_list_tab tr[data-id=" + cid + "] td .icon").addClass("state_" + (parseInt(status)));
                            // clientStatus = parseInt(status);
                            $("#client_list_tab tr[data-id=" + cid + "] td div .process").html("传输中").css("background", "#ddd");
                        }
                        mynodes = treeObj.getNodesByParam("id", cid, null);
                        if (mynodes[0].level == 3) {//更新 终端
                            //mynodes = treeObj.getNodesByParam("id", cid, null);
                            mynodes[0].playstatus = clientStatus;
                            treeObj.updateNode(mynodes[0]);//更新节点属性值。。
                            $("#" + mynodes[0].tId + "_a").attr("style", "");
                            $("#" + mynodes[0].tId + "_a span:eq(0)").css("background", "url(/images/tubiao.png)  no-repeat " + clientPlayStatus[clientStatus] + " / 150px 400px");//状态 图标
                            var clientName = $("#" + mynodes[0].tId + "_a span:eq(1)");//...substr(0, 7) + "..."
                            if (clientName.text().length > 7) {
                                clientName.text(clientName.text().substr(0, 7) + "...");
                            }
                        }

                        // mynodes[0].playstatus = clientStatus;//clientStatus  终端状态 图标
                        //mynodes[0].icon = "/images/loading.gif";
                        //treeObj.updateNode(mynodes[0])
                    }
                }
                //setTimeout(getclientprocessstatus, 5000000000);
            },
            error: function () {
                //setTimeout(getclientprocessstatus, 500000000);
            }
        })
    }
    var needqueryg = "0";
    var myInterTimerg;
    //whq, 获取终端/终端组  包含的节目单，传输状态。
    function getMenusProcessg() {
        //终端/终端组的id：$("#client_groupinfo_clientid").val(),,
        var myid = $("#client_groupinfo_clientid").val();
        var isGroup = $(".curSelectedNode").hasClass("level3");
        if (isGroup == true) {
            isGroup = "no";
        } else { isGroup = "yes"; }

        $.ajax({
            type: 'post',
            url: 'ajax/getclientstatus.ashx',
            async: true,
            data: { myaction: "getMenuProcess", myclientid: myid, isgroup: isGroup },
            dataType: 'text',
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    //
                    var json = strToJson(data);
                    var myTable = json.Table[0];
                    if (myTable == undefined) {
                        return;
                    }

                    var mynodes = "";//根据条件，获取节点。 //终端。
                    var clientStatus = 0;
                    if (isGroup == "yes") {//点击终端组，页面只显示（添加给 终端组 的 节目单记录）
                        //$.each(json.Table, function (idx, item) {
                        //});
                        var mysendProcess1 = myTable.sendingprocess;
                        if (myTable.playstatus != "0" && myTable.menuprocess == "100" && (mysendProcess1 != "100" && myTable.bversion != myTable.cversion)) {
                            clientStatus = myTable.playstatus;
                            //在线，上次传输成功，本次传输未完成： 异步查询                            
                            needqueryg = "1";//小图标表示是否在动态查询 loading..
                            $("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text() + '<img src="/images/loading.gif" alt="正在获取数据" style="margin-bottom: -9px;" />');

                        } else {//所有终端的传输进度:每个都要单独处理：传输完了，就停止查询。
                            //-=-=查询到传输sendingprocess=100 or A当前节目单版本=C传输完毕时提交的节目单版本 则停止查询  
                            $.each(json.Table, function (idx, item) {//终端组下，所有终端的传输进度。。
                                clientStatus = item.playstatus;
                                if (mysendProcess1 == "100" || item.bversion == item.cversion) {
                                    needqueryg = "0";
                                    $("#client_list_tab tr[data-id=" + item.clientid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess1) + "%" }).html(parseInt(mysendProcess1) + "%");
                                }
                                if (item.playstatus == "0" || item.menuprocess != "100") {//离线时，不异步查询；menuprocess<>100不异步查询;
                                    needqueryg = "0";
                                    $("#client_list_tab tr[data-id=" + item.clientid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess1) + "%" }).html(parseInt(mysendProcess1) + "%");
                                }
                                $("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text());
                                //var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                                //mynodes = treeObj.getNodesByParam("id", item.clientid, null);
                                //if (mynodes[0].level == 3) {//更新 终端
                                //    //mynodes = treeObj.getNodesByParam("id", item.clientid, null);
                                //    mynodes[0].playstatus = clientStatus;
                                //    treeObj.updateNode(mynodes[0]);//更新节点属性值。。
                                //    $("#" + mynodes[0].tId + "_a").attr("style", "");
                                //    $("#" + mynodes[0].tId + "_a span:eq(0)").css("background", "url(/images/tubiao.png)  no-repeat " + clientPlayStatus[clientStatus] + " / 150px 325px");//状态 图标

                                //    console.log("#" + mynodes[0].tId + "_a");
                                //}
                            });
                        }
                        if (myTable.bversion != myTable.cversion) {
                            $("#client_list_tab tr[data-id=" + myTable.clientid + "] td div .process").css("background", "#f6f645");//A当前节目单版本 +C传输完毕时提交的节目单版本...当A!=C时，分发进度颜色（黄色）
                        }
                    } else {//单条记录（终端/终端组） 包含的节目单 ，第一条是启用的节目单
                        var mysendProcess = myTable.sendingprocess;
                        clientStatus = myTable.playstatus;
                        if (myTable.playstatus != "0" && myTable.menuprocess == "100" && (mysendProcess != "100" && myTable.bversion != myTable.cversion)) {
                            //在线，上次传输成功，本次传输未完成： 异步查询                            
                            needqueryg = "1";//小图标表示是否在动态查询 loading..
                            $("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text() + '<img src="/images/loading.gif" alt="正在获取数据" style="margin-bottom: -9px;" />');
                            // $("#client_list_tab th:eq(5)").text()  <img src="/images/loading.gif" alt="正在获取图片" />
                        } else {

                            //-=-=查询到传输sendingprocess=100 or A当前节目单版本=C传输完毕时提交的节目单版本 则停止查询                            
                            if (mysendProcess == "100" || myTable.bversion == myTable.cversion) {
                                needqueryg = "0";
                                $("#client_list_tab tr[data-id=" + myTable.clientid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess) + "%" }).html(parseInt(mysendProcess) + "%");
                            }
                            if (myTable.playstatus == "0" || myTable.menuprocess != "100") {//离线时，不异步查询；menuprocess<>100不异步查询;
                                needqueryg = "0";
                                $("#client_list_tab tr[data-id=" + myTable.clientid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess) + "%" }).html(parseInt(mysendProcess) + "%");
                            }
                            $("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text());
                            /*--var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                            mynodes = treeObj.getNodesByParam("id", myTable.clientid, null);
                            if (mynodes[0].level == 3) {//更新 终端
                                //mynodes = treeObj.getNodesByParam("id", myTable.clientid, null);
                                mynodes[0].playstatus = clientStatus;
                                treeObj.updateNode(mynodes[0]);//更新节点属性值。。
                                $("#" + mynodes[0].tId + "_a").attr("style", "");
                                $("#" + mynodes[0].tId + "_a span:eq(0)").css("background", "url(/images/tubiao.png)  no-repeat " + clientPlayStatus[clientStatus] + " / 150px 325px");//状态 图标
                                
                                console.log("#" + mynodes[0].tId + "_a");
                            }*/
                        }
                        if (myTable.bversion != myTable.cversion) {
                            $("#client_list_tab tr[data-id=" + myTable.clientid + "] td div .process").css("background", "#f6f645");//A当前节目单版本 +C传输完毕时提交的节目单版本...当A!=C时，分发进度颜色（黄色）
                        }

                    }
                }
            },
            error: function () {
                needqueryg = "0"; //clearInterval(myInterTimerg);//异步查询失败，则停止查询（进度灰色）
                $("a[data-type=0]").parent().parent().parent().find(".process").css("background", "").html(0 + "%");
            }
        });
        if (needqueryg == "1") {//会不会重复   添加定时器？？？？？？
            clearInterval(myInterTimerg);
            myInterTimerg = setInterval(getMenusProcessg, 3000);
            console.log("ggmyinterval......");
            //小图标表示是否在动态查询 loading..
            //$("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text() + '<img src="/images/loading.gif" alt="正在获取数据" />');
        } else {
            //$("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text());
            $("#client_list_tab th:eq(5)").html($("#client_list_tab th:eq(5)").text());
            clearInterval(myInterTimerg);

            console.log("clear....gg..myinterval......");
        }
    }
</script>
<input type="hidden" id="client_groupinfo_userlevel" runat="server" />
<input type="hidden" id="client_groupinfo_comid" runat="server" />
<input type="hidden" id="client_groupinfo_dlevel" runat="server" />
<input type="hidden" id="client_groupinfo_clientid" runat="server" />
<input type="hidden" id="client_groupinfo_mark" runat="server" />
<input type="hidden" id="client_groupinfo_name" runat="server" />
<input type="hidden" id="load_clientidlist" />
<input type="hidden" id="load_clientnamelist" runat="server" />
<div id="zyyclient_list_tab1">
<table class="tab_zl_list" id="client_list_tab">
    <tr>
        <th width="200">
            <input type="checkbox" value="*" name="allChecked" id="allChecked" />
            <span class="language">终端ID</span></th>
        <th width="200" class="language">终端名称</th>
        <th width="150" class="language">网络地址</th>
        <th width="150" class="language">开机时间</th>
        <th width="150" class="language">关机时间</th>
        <th width="100" class="language">进度</th>
        <%-- <th width="40">状态</th>--%>
        <th width="150" id="client_right_operate">
            <span style="background: url(/images/menu.png) no-repeat right center #f5f5f5; display: inline-block; width: 50px; padding-right: 45px;" class="language">操作</span>
        </th>
    </tr>
</table>
<div class="add_btn clearfix" style="text-align: center; margin-top: 30px">
    <span class="inp_btn" id="client_list_loadmore" style="border: none"><a href="javascript:void(0)"><b></b><span class="language">加载更多</span></a></span>
</div>
</div>




