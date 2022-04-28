<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_view.aspx.cs" Inherits="Web.company.client.client_view" %>
<style>
    /*#client_menu_tab th:nth-child(1) {
        display: inline-block;
        width: 100%;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }*/
</style>
<script type="text/javascript">
    var lastid = 0;
    var dlevel = "";
    var clientid = "";//$("#client_view_clientid").val()
    var mark = "";
    var lastsendnum = 0;
    var clientidlist = "";
    var menuidlist = "";
    //window.onunload = function () {//离开页面，清理定时器
    //    clearInterval(myInterTimer);
    //}
    //$(window).unload(function () {
    //    clearInterval(myInterTimer);
    //    clearInterval(myInterTimerg);
    //});


    
    try {//typeof(r) != "undefined"
        if (typeof (myInterTimerg) != "undefined") {//myInterTimerg != undefined
            clearInterval(myInterTimerg);
        }
        if (typeof (myInterTimer) != "undefined") {//本页面   //获取终端/终端组  包含的节目单，传输状态
            clearInterval(myInterTimer);
        }
        if (typeof (timerClientStataus) != "undefined") {
            clearInterval(timerClientStataus);
        }
    } catch (ex) {

    }
    window.onload = function () {//不行，页面是load进来的
        
        $("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());
        
       
    }
    $(function () {//$("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());
        getJsonValue();
        dlevel = $("#client_view_dlevel").val();
        clientid = $("#client_view_groupid").val();
        mark = $("#client_view_mark").val();
        getdata("no");
        $("#client_view_copy").click(function () {
            client_main_loadright(8, item.clientid, 4, $("#client_view_mark").val());
        });
        $("#client_menu_loadmore").click(function () {
            getdata("yes");
        });
        getMenusProcess();
        switchLanguage("#client_menu_tab", 1, "client_view.aspx");
    });
    //window.onload = function () {//页面时$.load()进来的。这样写不行。。。
    //    getMenusProcess();
    //}
    /*
    分发进度网页打开时，先查一次数据库，之后根据情况看是否启动异步查询（终端组和终端都异步查询数据库，假设数据库有缓冲和加速机制）

    分发进度页显示终端状态：在线/离线和分发进度（数据库查询结果）（同时有三个节目单版本：A当前节目单版本+B分发准备完毕时节目单版本+C传输完毕时提交的节目单版本）
    当A!=C时，分发进度颜色（黄色）区别于相同的（同时红色显示A和C以提示）

    离线时，不异步查询；menuprocess<>100不异步查询；在线的查，但如果异步查询失败，则停止查询（进度灰色）。查询到传输sendingprocess=100 or A当前节目单版本=C传输完毕时提交的节目单版本 则停止查询。（有个小图标表示是否在动态查询）

    {"needquery":"0","online","0","preprocess":"100","sndprocess":"100","menuversion":"999-2017-09-04 10:10:10","premenuversion":"999-2017-09-04 10:10:10","okmenuversion":"","realmenuversion":"999-2017-09-04 10:10:10"}
    //needquery：是否需要继续异步查询
    //online：终端目前是在线还是离线
    //preprocess：分发是否准备完毕=menuprocess
    //sndprocess：实际分发进度=sendingprocess
    //menuversion：当前节目单最新版本号
    //premenuversion：最近分发准备时用的节目单号
    //okmenuversion：分发完毕后更新的节目单号
    //realmenuversion：当前显示端提交的节目单号（正在播放的）
    
    //单条记录（终端/终端组）
    select a.clientid,a.tempflag,a.sendtime,a.startdate,a.enddate,a.menuprocess,a.filename,a.destname,a.sendingprocess,a.finishedtime,a.flag,b.itemid,b.itemname,b.version as bversion,c.clientname,c.groupflag,c.playstatus,c.menuid as cmenuid,c.version as cversion from wisepeak_clientmenu a left join wisepeak_menuitem b on a.menuid=b.itemid left join wisepeak_client c on a.clientid=c.clientid where a.clientid=11 order by a.flag;
    //终端组下（包括终端组）所有终端/终端组选中分发记录的分发进度
    select a.clientid,a.tempflag,a.sendtime,a.startdate,a.enddate,a.menuprocess,a.filename,a.destname,a.sendingprocess,a.finishedtime,a.flag,b.itemid,b.itemname,b.version as bversion,c.clientname,c.groupflag,c.playstatus,c.menuid as cmenuid,c.version as cversion from wisepeak_clientmenu a left join wisepeak_menuitem b on a.menuid=b.itemid left join wisepeak_client c on a.clientid=c.clientid where a.flag=0 and (a.clientid=3 or a.clientid in (select clientid from wisepeak_clientgroup where groupid=3)) order by a.clientid;

    更新任务分发表的地方有：

    1、控制室分发进程，分发过程中，可以定期更新节目单ID对应的分发表（不管flag字段是否标记是启用还是未启用），以节目单ID为准，可能更新批量（包括终端组）。
    在传输完毕一个文件，或者文件传输进度超过10%后，或者全部分发完毕时。

    中间过程：Update _clientmenu set filename='',sendingprocess= where menuid= and menuprocess=100 and sendingprocess<>100 and flag=0 (注意，如果一个终端对应多个节目单分发，中间filename可能不等于destname)
    传输完毕：Update _clientmenu set destname='',sendingprocess=100 where menuid= and menuprocess=100 and flag=0
    */
    //编辑  终端已有的节目单。
    function editClientMenu(clientmenuid, menuid, clientid) {
        var sellist = "";
        //$("input[name=ch_client_menu]:checked").each(function () {
        //    sellist = sellist + $(this).attr("data-cid") + ",";
        //})
        //if (sellist == "") {
        //    sellist = "*";
        //}
        $("#client_main_right").load("client_menu_add.aspx", { "gid": clientid, "dlv": $("#client_main_right_dlevel").val(), "mark": $("#client_main_right_mark").val(), "t": clientmenuid, "mymenuid": menuid, "myclientid": clientid }, function () {
            $("#client_main_right").fadeIn();
        });
    }
    function resetClientMenu(clientid,menuid) {
        $.ajax({
            type: 'post',
            url: 'ajax/resetClientMenu.ashx',
            async: true,
            dataType: 'text',
            data: { "clientid": clientid, "menuid": menuid },
            success: function (data) {
                if (data!="-1") {
                    TopTrip(getLanguageMsg("分发状态 重置成功!", $.cookie("yuyan")), 1);
                }
            }
        });
    }
    function getdata(isLoadMore) {
        
        $.ajax({
            type: 'post',
            url: 'ajax/clientmenulist.ashx',
            async: true,
            dataType: 'text',
            data: { "gid": clientid, "dlv": dlevel, "mark": mark, "lastid": lastid, "name": $("#client_view_name").val() },
            success: function (data) {
                var myClientName = "";
                var json = strToJson(data);
                var i = 0; var myColor = "#ddd";
                console.log("数据加载更多吗？" + isLoadMore);
                if (isLoadMore=="no") {
                    $("#client_menu_tab tr[data-type='data']").remove();//避免 节目单重复显示。
                }
                if (data=="-1") {
                    return;
                }
                //debugger;
                $.each(json.Table, function (idx, item) {
                    
                    lastid = item.clientmenuid;
                    var flaghtml = '<span><a title="' + getLanguageMsg("已启用", $.cookie("yuyan")) + '" href="javascript:void(0)" name="client_menu_enabled" data-type="0" class="btn_enabled"><img src="/images/icon_enabled.png"></a></span>';
                    if (item.flag == 1) {
                        flaghtml = '<span><a title="' + getLanguageMsg("禁用", $.cookie("yuyan")) + '" href="javascript:void(0)" name="client_menu_enabled" data-type="1" class="btn_enabled"><img src="/images/icon_disabled.png"></a></span>';
                        myColor = "#f5f211";
                    } else {//whq//只保存 启用的节目单，，之后 会获取传输进度
                        clientidlist = clientidlist + item.clientid + ",";
                        menuidlist = menuidlist + item.menuid + ",";
                        myColor = "#ddd";
                    }
                    myClientName = item.clientname;
                    if (myClientName.length>8) {
                        myClientName = myClientName.substr(0,7)+"...";
                    }
                    
                    $("#client_menu_tab").append('<tr data-type="data" data-clientid="' + item.clientid + '" data-menuid="' + item.menuid + '" data-clientname="' + item.clientname + '" data-clientmenuid="' + item.clientmenuid + '">'
                        + '<td title="' + getLanguageMsg("编辑节目单属性", $.cookie("yuyan")) + '"><a href="javascript:void(0)" onclick="editClientMenu(' + item.clientmenuid + ',' + item.menuid + ',' + item.clientid + ')">' + item.clientmenuid + '</td>'   //<input type="checkbox" name="ch_client_menu" data-cid="' + item.clientid + '" value="' + item.clientmenuid + '" class="selChild">
                        + '<td title="' + item.clientid + '-' + item.clientname + '">' + myClientName + '</td>'
                        + '<td title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '"><a href="/company/program/program_arrange.aspx?id=' + item.menuid + '&type=0">' + item.itemname + '</a></td>'
                        + '<td>' + item.sendtime + '</td>'
                        + '<td>' + item.startdate + '</td>'
                        + '<td>' + item.enddate + '</td>'//#ddd 改为黄色 f5f211  禁用的节目单
                        + '<td><div style="width:100px; height:20px; margin:0 auto; background:' + myColor + ';"><div class="process" style=" height:20px;line-height:20px;background:#00f80c;display:inline-block;"><div></div></td>'//<div class="process" style="width:20%;
                        + '<td data-type="operate" class="operate">' + flaghtml + '<a title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" href="javascript:void(0)" onclick="showDeleteClientMenu(' + item.clientmenuid + ')"><img src="/images/icon_del.png"></a><a title="' + getLanguageMsg("重置分发状态", $.cookie("yuyan")) + '" href="javascript:void(0)" onclick="resetClientMenu(' + item.clientid + ',' + item.menuid + ')"><img src="/images/btn_reset.png"></a></td>'
                        + '</tr>');
                    i++;
                    
                });
                if (i < 8) {
                    $("#client_menu_loadmore").fadeOut();
                }
                getclientmenuprocess();//cgi...
            }
        });
    }
    var needquery = "0";
    var myInterTimer;
    //whq, 获取终端/终端组  包含的节目单，传输状态。
    function getMenusProcess() {
        //终端/终端组的id：$("#client_main_right_clientid").val(),,$("#client_view_groupid").val()
        var myid = $("#client_view_groupid").val();
        var isGroup = $(".curSelectedNode").hasClass("level3");
        if (isGroup == true) {
            isGroup = "no";
        } else { isGroup = "yes"; }
        if (myid=="" || myid==null) {
            myid=$("#client_main_right_clientid").val();
        }
        $.ajax({
            type: 'post',
            url: 'ajax/getclientstatus.ashx',
            async: true,
            data: { myaction: "getMenuProcess",myclientid:myid ,isgroup:isGroup},
            dataType: 'text',
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    // --wisepeak_menuitem bversion 是空,,  wisepeak_client cversion 传输完成不更新
                    //myTable.bversion != myTable.cversion 这个判断，就不准确了
                    var json = strToJson(data);
                    var myTable = json.Table[0];
                    if (myTable== undefined) {
                        return;
                    }
                    if (isGroup == "yes") {//点击终端组，页面只显示（添加给 终端组 的 节目单记录）
                        //$.each(json.Table, function (idx, item) {
                        //});
                        var mysendProcess1 = myTable.sendingprocess;
                        if (myTable.playstatus != "0" && myTable.menuprocess == "100" && (mysendProcess1 != "100" || myTable.bversion != myTable.cversion)) {
                            //在线，上次传输成功，本次传输未完成： 异步查询                            
                            needquery = "1";//小图标表示是否在动态查询 loading..
                           // $("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text() + '<img src="/images/loading.gif" alt="正在获取数据" style="margin-bottom: -9px;" />');
                            $("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());

                            // $("#client_menu_tab th:eq(6)").text()  <img src="/images/loading.gif" alt="正在获取图片" />
                        } else {
                            //-=-=查询到传输sendingprocess=100 or A当前节目单版本=C传输完毕时提交的节目单版本 则停止查询                            
                            if (mysendProcess1 == "100" || myTable.bversion == myTable.cversion) {
                                needquery = "0";
                                $("#client_menu_tab tr[data-clientid=" + myTable.clientid + "][data-menuid=" + myTable.itemid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess1) + "%" }).html(parseInt(mysendProcess1) + "%");
                            }
                            if (myTable.playstatus == "0" || myTable.menuprocess != "100") {//离线时，不异步查询；menuprocess<>100不异步查询;
                                needquery = "0";
                                $("#client_menu_tab tr[data-clientid=" + myTable.clientid + "][data-menuid=" + myTable.itemid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess1) + "%" }).html(parseInt(mysendProcess1) + "%");
                            }
                            $("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());
                        }
                        if (myTable.bversion != myTable.cversion) {
                            $("#client_menu_tab tr[data-clientid=" + myTable.clientid + "][data-menuid=" + myTable.itemid + "] td div .process").css("background", "#f6f645");//A当前节目单版本 +C传输完毕时提交的节目单版本...当A!=C时，分发进度颜色（黄色）
                        }
                    } else {//单条记录（终端/终端组） 包含的节目单 ，第一条是启用的节目单
                        var mysendProcess = myTable.sendingprocess;
                        //mysendProcess != "100" || myTable.bversion != myTable.cversion  //2019.1.4 修改
                        if (myTable.playstatus != "0" && myTable.menuprocess == "100" && (mysendProcess != "100" && myTable.bversion != myTable.cversion)) {
                           //在线，上次传输成功，本次传输未完成： 异步查询                            
                            needquery = "1";//小图标表示是否在动态查询 loading..
                            //$("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text() + '<img src="/images/loading.gif" alt="正在获取数据" style="margin-bottom: -9px;" />');
                            $("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());
                            // $("#client_menu_tab th:eq(6)").text()  <img src="/images/loading.gif" alt="正在获取图片" />
                        } else {
                            //-=-=查询到传输sendingprocess=100 or A当前节目单版本=C传输完毕时提交的节目单版本 则停止查询                            
                            if (mysendProcess == "100" || myTable.bversion == myTable.cversion) {                            
                                needquery = "0";
                                $("#client_menu_tab tr[data-clientid=" + myTable.clientid + "][data-menuid=" + myTable.itemid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess) + "%" }).html(parseInt(mysendProcess) + "%");
                            }
                            if (myTable.playstatus == "0" || myTable.menuprocess != "100") {//离线时，不异步查询；menuprocess<>100不异步查询;
                                needquery = "0";
                                $("#client_menu_tab tr[data-clientid=" + myTable.clientid + "][data-menuid=" + myTable.itemid + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(mysendProcess) + "%" }).html(parseInt(mysendProcess) + "%");
                            }
                            $("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());
                        }
                        if (myTable.bversion != myTable.cversion) {
                            $("#client_menu_tab tr[data-clientid=" + myTable.clientid + "][data-menuid=" + myTable.itemid + "] td div .process").css("background", "#f6f645");//A当前节目单版本 +C传输完毕时提交的节目单版本...当A!=C时，分发进度颜色（黄色）
                        }

                    }
                }
            },
            error: function () {
                needquery = "0"; //clearInterval(myInterTimer);//异步查询失败，则停止查询（进度灰色）
                $("a[data-type=0]").parent().parent().parent().find(".process").css("background", "").html(0 + "%");
            }
        });
        if (needquery == "1") {//会不会重复   添加定时器？？？？？？
            clearInterval(myInterTimer);
            myInterTimer = setInterval(getMenusProcess, 3000);
            console.log("myinterval.193.....");
            //小图标表示是否在动态查询 loading..
            //$("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text() + '<img src="/images/loading.gif" alt="正在获取数据" />');
        } else {
            //$("#client_menu_tab th:eq(6)").html($("#client_menu_tab th:eq(6)").text());
            var oldtext = $("#client_menu_tab tr th:eq(6)").text();
          
            //$("#client_menu_tab th:eq(6)").text(oldtext);
            //$("#client_menu_tab th:eq(6)").text("传输进度");
            $("#client_menu_tab tr th:eq(6)").html(getLanguageMsg("传输进度", $.cookie("yuyan")));//没起作用。。。。？？？？
            clearInterval(myInterTimer);
           // getMenusProcess();
            console.log("clear.270.....myinterval......" + $("#client_menu_tab tr th:eq(6)"));
            console.log($("#client_menu_tab tbody tr th:eq(6)").html());
        }
    }
    function getclientmenuprocess() {
        if ($("#client_menu_tab tr[data-type=data]").length <= 0) { return; }
        var isGroup = $(".curSelectedNode").hasClass("level3");
        if (isGroup == true) {
            isGroup = "no";
        } else { isGroup = "yes"; }
        var sendidlist = "";
        var totallength = clientidlist.split(",").length;
        if (lastsendnum == totallength) {
            lastsendnum = 0;
        }
        var clientnamelist = "";
        $("#client_menu_tab tr[data-type=data]").each(function () {
            //clientidlist = clientidlist + $(this).attr("data-clientid") + ",";
            clientnamelist = clientnamelist + $(this).attr("data-clientname") + ",";
        });
        var forlength = Math.min(lastsendnum + 2, totallength);
        for (var i = 0; i < totallength; i++) {//var i = lastsendnum; i < forlength;
            //lastsendnum++;
            if (clientidlist.split(",")[i] != "") {
                sendidlist = sendidlist + clientnamelist.split(",")[i] + ":" + clientidlist.split(",")[i] + ":" + menuidlist.split(",")[i] + ";";//14:233,14:228
            }
        }
        sendidlist = sendidlist.substr(0, sendidlist.length - 1);
        if (sendidlist=="") {//终端没有节目单。
            return;
        }//(终端组)石家庄:207:1518
        //(终端)c_区域:166:1518   //点击终端组，查询组的节目单？？？//组下有多个终端，，显示谁的进度
        //http://192.168.1.145/cgi-bin/preparefilecgi.cgi?companyid=wisepeak&maintype=4&subtype=91&merit=0&commandname=&param=&rnd=1522237992870&clientname=c_%E5%8C%BA%E5%9F%9F%3A166%3A1518&value1=&charset=utf-8&utf8=1&username=whq123&password=yoaC%2FEHueDeMo8EM%2FalIMw%3D%3D
        //console.log("clientidsssss " + sendidlist);
        var oldPassword = "";
        if ($("#myPassword").val() != undefined) oldPassword=$("#myPassword").val();
        oldPassword = oldPassword.replace('+','@');
        $.ajax({
            type: 'post',
            url: '/cgi-bin/preparefilecgi.cgi',
            timeout: 3000,
            async: true,////异步请求
            dataType: 'text',//用户名密码。//"maintype": 5,  //"value1": sendidlist
            data: { "companyid": $("#client_view_comid").val(), "maintype": 4, "subtype": 91, "merit": $("#client_view_userlevel").val(), "commandname": "", "param": "", "rnd": new Date().getTime(), "clientname": sendidlist, "value1": "", "charset": "utf-8", "utf8": "1", "username": $("#myuserName").val(), "password": oldPassword },
            success: function (data) {
                if (data.indexOf("<queryreturn>") > 0) {
                    data = data.substring(data.indexOf("<queryreturn>") + 13, data.indexOf("</queryreturn>"));
                    if (data == "") {//2019.1.4//要是没有查到结果呢？？！！
                        //<!--wpbeginmark-->200 OK     <queryreturn></queryreturn>     <!--wpenmark-->

                    }
                    for (var i = 0; i < data.split(";").length; i++) {
                        var result = data.split(";")[i];
                        var myCid = result.split(":")[0];
                        if (result.split(":")[2] == "undefined" || result.split(":")[2] == undefined) { continue; }
                        var sendstatus = result.split(":")[2][0];//未找到终端记录=0,离线=1(曾经有pconnect)，未传输=2，传输中=3，传输完毕=4
                        if (sendstatus == 2) {
                            $("#client_menu_tab tr[data-clientid=" + myCid + "][data-menuid=" + result.split(":")[1] + "] td div .process").html(getLanguageMsg("未分发", $.cookie("yuyan"))).css("background", "#ddd").css("display", "inline");
                        }
                        var process = result.split(":")[2].substr(3, 3);//402100                        
                        if (parseInt(process) == 100) {
                            sendidlist = sendidlist.replace(myCid, "");//已经传输完的终端，id去掉。没有传输完的终端，再请求CGI ....
                        }
                        if (sendstatus == 4) {
                           // var process = result.split(":")[2].substr(3, 3);//402100
                            
                            $("#client_menu_tab tr[data-clientid=" + myCid + "][data-menuid=" + result.split(":")[1] + "] td div .process").css("background", "#00f80c").animate({ "width": parseInt(process) + "%" }).html(parseInt(process) + "%");
                        }
                        if (sendstatus == 0) {
                            $("#client_menu_tab tr[data-clientid=" + myCid + "][data-menuid=" + result.split(":")[1] + "] td div .process").html(getLanguageMsg("未找到", $.cookie("yuyan"))).css("background", "#ddd").css("display", "inline");
                        }
                        if (sendstatus == 1) {
                            $("#client_menu_tab tr[data-clientid=" + myCid + "][data-menuid=" + result.split(":")[1] + "] td div .process").html(getLanguageMsg("不在线", $.cookie("yuyan"))).css("background", "#ddd").css("display", "inline");
                        }
                        if (sendstatus == 3) {
                            $("#client_menu_tab tr[data-clientid=" + myCid + "][data-menuid=" + result.split(":")[1] + "] td div .process").html(getLanguageMsg("传输中", $.cookie("yuyan"))).css("background", "#ddd").css("display", "inline");
                        }
                    }
                }
                //getclientmenuprocess();//已经传输完的终端，id去掉。没有传输完的终端，再请求CGI ....
                if (needquery=="1" && isGroup == "yes") {//点击 终端组，查询组的节目单 分发进度
                    setTimeout(getclientmenuprocess, 30000);//传输完成 100%
                } 
            },
            error: function () {
                setTimeout(getclientmenuprocess, 50000);
            }
        })
    }
    //启用、禁用  终端包含的节目单
    $("a[name=client_menu_enabled]").die().live("click", function () {
        var flag = $(this).attr("data-type");
        var clientid = $(this).parent("span").parent("td").parent("tr").attr("data-clientid");
        var clientmenuid = $(this).parent("span").parent("td").parent("tr").attr("data-clientmenuid");
        var mymark = $("#client_view_mark").val();
        var obj = $(this);
        //debugger;
        //if (flag == 1) {
            $.ajax({
                type: 'post',
                url: 'ajax/changeflag.ashx',
                async: true,
                dataType: 'text',
                data: { "clientid": clientid, "clientmenuid": clientmenuid, "myflag": flag, "client_menu_mark": mymark },
                success: function (data) {//。。所有的节目单都可以禁用。。
                    if (data == 1) {//flag   1禁用  0启用   //所有节目单‘禁用’，当前节目单‘启用’
                        if (flag == 1) {
                            $(".btn_enabled").attr("data-type", 1).html('<img src="/images/icon_disabled.png">'); 
                            obj.attr("data-type", 0).html('<img src="/images/icon_enabled.png">');
                            $("#client_menu_tab td>div").css("background", "#f5f211");//黄色 f5f211  禁用的节目单
                            obj.parent().parent().prev("td").find(">div").css("background", "#ddd");
                            //$(".btn_enabled [data-type='1']").attr("data-type", 1);
                            //obj.attr("data-type", 0); 
                            clientidlist = clientid;
                            menuidlist = clientmenuid;//whq//设置启用的节目单id
                        } else {//把当前启用的节目单，设为 禁用
                            obj.attr("data-type", 1).html('<img src="/images/icon_disabled.png">');
                        }
                        //是不是  再次启动 分发传输进度的查询。。。
                        getMenusProcess();
                    }
                }
            });
        //}
    });
    //删除终端包含的节目单
    $("#btn_delclientmenu").die().live("click", function () {// 删除框中的 删除按钮
        var obj = $(this);
        var boxId = obj.attr("data-id");
        var clientmenuid = obj.attr("data-itemid");
       // debugger;
        $.ajax({
            type: 'post',
            url: 'ajax/deleteclientmenu.ashx',
            async: true,
            dataType: 'text',
            data: { "clientmenuid": clientmenuid, "client_menu_mark": $("#client_view_mark").val() },
            success: function (data) {
                if (data == 1) {
                    $("#client_menu_tab tr[data-clientmenuid=" + clientmenuid + "]").remove();
                    $("#"+boxId).remove();
                }
            }
        });
    });
</script>
<input type="hidden" id="client_view_userlevel" runat="server" />
<input type="hidden" id="client_view_comid" runat="server" />
<input type="hidden" id="client_view_groupid" runat="server" />
<input type="hidden" id="client_view_mark" runat="server" />
<input type="hidden" id="client_view_dlevel" runat="server" />
<input type="hidden" id="client_view_name" runat="server" />
<input type="hidden" id="myuserName" runat="server" />
<input type="hidden" id="myPassword" runat="server" />
<table class="tab_zl_list" id="client_menu_tab">
    <tr>
        <th style="width:120px" class="language">分发ID</th>     <%--<input type="checkbox" value="*" data-cid="*" name="ch_client_menu" id="faSel">--%>
        <th style="width:145px" class="language">终端名称</th>
        <th style="width:180px" class="language">节目单名称</th>
        <th style="width:120px" class="language">传输时间</th>
        <th style="width:120px" class="language">开始时间</th>
        <th style="width:120px" class="language">结束时间</th>
        <th style="width:120px" class="language">传输进度</th>
        <th style="width:120px" class="language">操作
        </th>
        
    </tr>
</table>
<div class="add_btn clearfix" style="text-align: center; margin-top: 30px">
    <span class="inp_btn" id="client_menu_loadmore" style="border: none"><a href="javascript:void(0)" class="language">加载更多</a></span>
</div>
<script>
    $(function () {  //全选
        var selAll = new Mxjfn();
        selAll.selectAll("#faSel", ".selChild");
    })
   
</script>
