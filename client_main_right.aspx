<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_main_right.aspx.cs" Inherits="Web.company.client.client_main_right" %>

<style>
    .cont ul li span:first-child {
        cursor: pointer;
    }

    .title select {
        /**padding:5px 10px;**/
        /* padding:2px 10px;*/
        border-radius: 5px;
        color: #666;
    }

    .sor_dxpic {
        width: 28px;
        height: 26px;
        line-height: 26px;
        vertical-align: sub;
        display: inline-block;
        border: 1px solid #b6aeae;
        background-image: url('/images/tubiao.png');
        background-repeat: no-repeat;
        background-position: -245px -524px;
        position: absolute;
        left: 212px;
        top: 6px;
    }

    .input_hover:hover {
        background: #61c6f8;
    }

    .clien_statues {
        width: 108px;
        display: block;
        float: left;
        margin-left: 5px;
        text-align: left;
    }

    .ukl_box {
        width: 100%;
        margin: 0 auto;
        margin-bottom: 10px;
    }
</style>
<script type="text/javascript">
    var dlevel, clientid, clientmark;
    var clickState = "";
    $(function () {
        getJsonValue();
        dlevel = $("#client_main_right_dlevel").val();
        clientid = $("#client_main_right_clientid").val();
        clientmark = $("#client_main_right_mark").val();//><a href="javascript:void(0)">播放终端列表</a>
        var treeDemo = $.fn.zTree.getZTreeObj("treeDemo");
        //实体组：添加终端、批量引入终端。虚拟组：批量引入终端
        if (treeDemo != null && treeDemo.getSelectedNodes().length > 0) {
            if (treeDemo.getSelectedNodes()[0].groupflag == "2") {////‘虚拟组’ 
                $("#client_groupinfo_clientaddbtn").parent().hide();//“添加终端”按钮隐藏
                $("#client_groupinfo_quickaddbtn span").html("添加终端");
            }
        }

        $("#client_main_pagemap").html('<a href="javascript:void(0)">' + getLanguageMsg("播放终端管理", $.cookie("yuyan")) + '</a>' + $("#client_main_right_pageMap").val());
        $("#myClientmanager").html(getLanguageMsg($("#myClientmanager").html(), $.cookie("yuyan")));
        $("#myMenuSend").html(getLanguageMsg($("#myMenuSend").html(), $.cookie("yuyan")));
        //预加载页面
        //$("#client_main_right_menu li:first").addClass("current").attr("data-isshow", 1);
        loadclientlist($("#client_main_right_menu li:first").attr("data-type"));//
        switchLanguage("#client_main_right", 1, "client_main_right.aspx");
        $("#myclientroot").html(getLanguageMsg($("#myclientroot").html(), $.cookie("yuyan")));
        for (var i = 0; i < $("#client_groupinfo_btnMgr .inp_btn").length; i++) {
            $("#client_groupinfo_btnMgr .inp_btn").eq(i).find("a span").html(getLanguageMsg($("#client_groupinfo_btnMgr .inp_btn").eq(i).find("a span").html(), $.cookie("yuyan")));
            $("#client_groupinfo_btnMgr .inp_btn").eq(i).find("a").attr("title", $("#client_groupinfo_btnMgr .inp_btn").eq(i).find("a span").html());

        }
        for (var i = 0; i < $("#client_groupinfo_btnMenu .inp_btn").length; i++) {
            $("#client_groupinfo_btnMenu .inp_btn").eq(i).find("a span").html(getLanguageMsg($("#client_groupinfo_btnMenu .inp_btn").eq(i).find("a span").html(), $.cookie("yuyan")));
            //debugger;
            $("#client_groupinfo_btnMenu .inp_btn").eq(i).find("a").attr("title", $("#client_groupinfo_btnMenu .inp_btn").eq(i).find("a span").html());

        }
        //页面切换
        $("#client_main_right_menu li").click(function () {
            // $(this).find("a").text()
            $.cookie('slect_tab', $(this).find("a").text());
            $.cookie('slect_tab_dataType', $(this).attr("data-type"));
            if ($(this).attr("data-isshow") == 0) {
                $(this).attr("data-isshow", 1);
                $(this).siblings("li").attr("data-isshow", 0);
                $(this).addClass("current").siblings("li").removeClass("current");
                loadclientlist($(this).attr("data-type"));
            }
        })
        //查看/关闭终端状态界面
        $("#client_groupinfo_reloadbtn").click(function () {
            if ($(".terminal_state").attr("data-isshow") == 0) {
                $(".terminal_state").slideDown();
                $(".terminal_state").attr("data-isshow", 1);
                $(this).val(getLanguageMsg("关闭状态", $.cookie("yuyan")));
                getclientstatus();

            }
            else {
                $(".terminal_state").slideUp();
                $(".terminal_state").attr("data-isshow", 0);
                $(this).val(getLanguageMsg("查看状态", $.cookie("yuyan")));
            }
        })


        //添加终端组操作
        $("#client_groupinfo_addbtn").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        client_main_loadright(1, clientid, dlevel, clientmark);
                    }
                    else if (data == 0) {
                        TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        })
        //编辑终端组操作
        $("#client_groupinfo_edit").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        client_main_loadright(3, clientid, dlevel, clientmark);
                    }
                    else if (data == 0) {
                        TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        });
        //添加终端操作
        $("#client_groupinfo_clientaddbtn").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        client_main_loadright(6, clientid, dlevel, clientmark);
                    }
                    else if (data == 0) {
                        TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        });
        //快速添加终端操作
        $("#client_groupinfo_quickaddbtn").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        client_main_loadright(12, clientid, dlevel, clientmark)
                    }
                    else if (data == 0) {
                        TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        });
        //编辑终端操作
        /*$("#client_edit").click(function () {//编辑组内终端 按钮
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        var sellist = "";
                        $("input[name=client_groupinfo_check]:checked").each(function () {
                            sellist = sellist + $(this).val() + ",";
                        })
                        if (sellist != "") {
                            client_main_loadright(8, sellist, dlevel, clientmark);
                        }
                        else {
                            TopTrip("请选择您要操作的终端!", 2);
                        }
                    }
                    else if (data == 0) {
                        TopTrip("您没有该终端组的操作权限!", 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });

        });*/
        //删除终端组操作
        $("#client_groupinfo_delbtn").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        $.ajax({
                            type: 'post',
                            url: 'ajax/beforeDeleteGroup.ashx',
                            async: true,
                            data: { "mark": clientmark, "id": clientid },
                            dataType: 'text',
                            success: function (data) {
                                if (data == 0) {
                                    TopTrip(getLanguageMsg("该终端组下还有终端组或终端!", $.cookie("yuyan")), 2);
                                }
                                else {
                                    TopDeleteClientGroupMessage($("#client_main_right_clientid").val());
                                }
                            }
                        });
                    }
                    else if (data == 0) {
                        TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        });
        //删除组内终端 ‘按钮’
        $("#client_delbtn").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    if (data > 0) {
                        var sellist = "";
                        $("input[name=client_groupinfo_check]:checked").each(function () {
                            sellist = sellist + $(this).val() + ",";
                        })
                        if (sellist != "") {
                            TopDeleteClientMessage(sellist);
                        }
                        else {
                            TopTrip(getLanguageMsg("请选择您要操作的终端!", $.cookie("yuyan")), 2);
                        }
                    }
                    else if (data == 0) {
                        TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            });
        });
        //添加节目单 '按钮'
        $("#client_groupinfo_sendMenu").click(function () {
            //debugger;
            $.ajax({
                type: 'post',
                url: 'ajax/IsShouQuan.ashx',
                async: true,
                data: { "mark": clientmark },
                dataType: 'text',
                success: function (data) {
                    //if (data > 0) {
                    var sellist = "";
                    $("input[name=ch_client_menu]:checked").each(function () {
                        sellist = sellist + $(this).attr("data-cid") + ",";
                    })
                    sellist = $("#client_main_right_clientid").val();
                    if (sellist == "") {
                        sellist = "*";
                    }
                    client_main_loadright(2, sellist, dlevel, clientmark);

                    //}
                    // else
                    //if (data == 0) {
                    //    TopTrip("您没有该终端组的操作权限!", 2);
                    //}
                    //else {
                    //    LoginTimeOut();
                    //}
                }
            });
        });
        //发送指令
        $("#client_groupinfo_sendCmd").click(function () {
            //if ($("#client_list_tab tr").length > 1 && $("input[name=client_groupinfo_check]:checked").length>0) {
            //只有一个终端，或者 选择了终端
            if ($("#client_list_tab tr").length == 2 || $("input[name=client_groupinfo_check]:checked").length > 0) {              
                $.ajax({
                    type: 'post',
                    url: 'ajax/IsShouQuan.ashx',
                    async: true,
                    data: { "mark": clientmark },
                    dataType: 'text',
                    success: function (data) {
                        if (data > 0) {
                            var sellist = "";
                            var client_ipaddress = "";
                            var client_name = "";

                            var client_ctlip = "";
                            var client_ctlport = "";
                            var client_detail = "";
                            var client_serialmark = "";
                            var client_ctlColor = "";
                            var client_cltoption = "";
                            var client_port = "";

                            if ($("#client_list_tab tr").length == 2) {
                                sellist = $("input[name=client_groupinfo_check]").parent().parent().attr("data-id");//只有一个终端的ID
                                client_name = $("input[name=client_groupinfo_check]").parent().parent().attr("data-name");
                                client_ipaddress = $("input[name=client_groupinfo_check]").parent().parent().attr("data-ipaddress");

                                client_ctlip = $("input[name=client_groupinfo_check]").parent().parent().attr("controlIp");
                                client_ctlport = $("input[name=client_groupinfo_check]").parent().parent().attr("controlIpport");
                                client_detail = $("input[name=client_groupinfo_check]").parent().parent().attr("detail");
                                client_serialmark = $("input[name=client_groupinfo_check]").parent().parent().attr("serialmark");

                                client_ctlColor = $("input[name=client_groupinfo_check]").parent().parent().attr("ctlColor");
                                client_cltoption = $("input[name=client_groupinfo_check]").parent().parent().attr("cltoption");
                                client_port = $("input[name=client_groupinfo_check]").parent().parent().attr("port");
                                //if (client_name == "" && $("input[name=client_groupinfo_check]").length == 1) {//当前只有一个终端
                                //    client_name = $("input[name=client_groupinfo_check]").parent().parent().attr("data-name");
                                //}
                                //if (client_ipaddress == "" && $("input[name=client_groupinfo_check]").length == 1) {//当前只有一个终端
                                //    client_ipaddress = $("input[name=client_groupinfo_check]").parent().parent().attr("data-ipaddress");
                                //}
                            } else {
                                $("input[name=client_groupinfo_check]:checked").each(function () {
                                    sellist = sellist + $(this).val() + ",";
                                    //获取终端名字和IP地址
                                    client_name = $(this).parent().parent().attr("data-name");
                                    client_ipaddress = $(this).parent().parent().attr("data-ipaddress");

                                    client_ctlip = $(this).parent().parent().attr("controlIp");
                                    client_ctlport = $(this).parent().parent().attr("controlIpport");
                                    client_detail = $(this).parent().parent().attr("detail");
                                    client_serialmark = $(this).parent().parent().attr("serialmark");
                                    client_ctlColor = $(this).parent().parent().attr("ctlColor");
                                    client_cltoption = $(this).parent().parent().attr("cltoption");
                                    client_port = $(this).parent().parent().attr("port");
                                });
                            }
                            
                           
                            if (sellist != "") {
                                //if (sellist.lastIndexOf(',')>0) { sellist = sellist.substr(0, sellist.length - 1); }
                                $("#client_main_cmdbox").load("client_cmd.aspx", { "gid": sellist, "dlv": dlevel, "mark": clientmark, client_ipaddress: client_ipaddress, client_name: client_name, "client_ctlip": client_ctlip, "client_ctlport": client_ctlport, "client_detail": client_detail, "client_serialmark": client_serialmark, "client_ctlColor": client_ctlColor, "client_cltoption": client_cltoption, "client_port": client_port}, function () {
                                    $("#overlay").fadeIn();
                                    $("#client_main_cmdbox").fadeIn();
                                });
                            }
                            else {
                                sellist = "*";
                                $("#client_main_cmdbox").load("client_cmd.aspx", { "gid": sellist, "dlv": dlevel, "mark": clientmark, client_ipaddress: client_ipaddress, client_name: client_name, "client_ctlip": client_ctlip, "client_ctlport": client_ctlport, "client_detail": client_detail, "client_serialmark": client_serialmark, "client_ctlColor": client_ctlColor, "client_cltoption": client_cltoption, "client_port": client_port}, function () {
                                    $("#overlay").fadeIn();
                                    $("#client_main_cmdbox").fadeIn();
                                });
                            }
                        }
                        else if (data == 0) {
                            TopTrip(getLanguageMsg("您没有该终端组的操作权限!", $.cookie("yuyan")), 2);
                        }
                        else {
                            LoginTimeOut();
                        }
                    }
                });
            } else {//没有选择终端
                //获取列表中的第一个终端
                // sellist = $("input[name=client_groupinfo_check]").parent().parent().first().attr("data-id");
                TopTrip("请选择要发送指令的终端", 2);
                return;
            }
        });
        //设置开关机时间 按钮
        $("#client_timesbtn").click(function () {//‘终端管理’页面：选择一个或多个终端
            var sellist = "";
            if ($("input[name='client_groupinfo_check']:checked").length > 0) {//勾选了一个或多个终端。。。
                $("input[name='client_groupinfo_check']").each(function (index, item) {
                    if (item.checked) { sellist += item.value + ","; }
                });
                SetShutDownTimes(sellist);
            } else {
                TopTrip(getLanguageMsg("请选择要设置的终端", $.cookie("yuyan")), 3);
            }
            //设置开关机时间：选择一个或多个终端
            //maintype=5&subtype=9&companyid=wisepeak&groupid=0&value1=0&merit=5&clientid=1030,&username=whq&password=C056Dl%2FoStNftflbnO6seQ%3D%3D
        });

        //刷新媒体播放终端状态
        $("#client_refreshbtn").click(function () {
            //debugger;
            //选择终端组、选择一个或多个终端，
            var sellist = "";
            var myid = $("#client_groupinfo_clientid").val();
            var isClient = $(".curSelectedNode").hasClass("level3");
            if ($("input[name='client_groupinfo_check']:checked").length > 0) {//‘终端管理’页面：勾选了一个或多个终端。。。
                $("input[name='client_groupinfo_check']").each(function (index, item) {
                    if (item.checked) { sellist += item.value + ","; }
                });
            }
            if (sellist == "") {//‘终端管理’页面：没有勾选终端。。。
                //树形列表：
                if (isClient == true) {//选择的终端
                    $("input[name='client_groupinfo_check']").each(function (index, item) {
                        sellist += item.value + ",";
                    });
                } else {//选择终端组
                    sellist = "*";
                }
            }
            if (sellist != "") {
                $.ajax({
                    type: 'post',
                    url: 'ajax/getcmdParameter.ashx',
                    async: true, timeout: 3000,
                    dataType: 'text',//maintype=0 --type=6//"subtype": 2
                    data: { "type": 6, "idlist": sellist, "mark": clientmark, "maintype": 4, "subtype": 3, "value1": 0 },
                    success: function (data) {
                        //debugger;
                        // console.log(data);
                        if (data == "-1") {
                            LoginTimeOut();
                        }
                        if (data == "-2") {
                            TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                        }
                        else {
                            $.ajax({
                                type: 'post',
                                url: '/cgi-bin/preparefilecgi.cgi?' + data + "&utf8=2",// + "&charset=utf-8",
                                async: true,
                                dataType: 'text',
                                success: function (data) {
                                    //debugger;
                                    TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                                    setTimeout(function () {
                                        loadclientlist(1);
                                    }, 2000);//刷新页面， 更新分发进度。
                                    //0,1   启动节目单分发 ,,分发完成，更新sendingprocess....todo...在client_view页面更新？？？
                                }
                            });
                        }
                    }
                });
            } else {
                TopTrip(getLanguageMsg("请选择要刷新的终端", $.cookie("yuyan")), 3);
            }// 刷新媒体播放终端状态：选择终端组、选择一个或多个终端，
            // maintype=4&subtype=2&companyid=wisepeak&groupid=1031&value1=0&merit=5&clientid=0&username=whq&password=C056Dl%2FoStNftflbnO6seQ%3D%3D&refreststate=%CB%A2%D0%C2%C3%BD%CC%E5%B2%A5%B7%C5%D6%D5%B6%CB%D7%B4%CC%AC
            //maintype=4&subtype=2&companyid=wisepeak&groupid=0&value1=0&merit=5&clientid=1014,&username=whq&password=C056Dl%2FoStNftflbnO6seQ%3D%3D&refreststate=%CB%A2%D0%C2%C3%BD%CC%E5%B2%A5%B7%C5%D6%D5%B6%CB%D7%B4%CC%AC
        });

        //刷新媒体播放终端列表
        $("#client_refreshList").click(function () {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true, timeout: 5000,
                dataType: 'text',//maintype=0 --type=6
                data: { "type": 6, "idlist": "0", "mark": "", "maintype": 4, "subtype": 0, "value1": 0 },
                success: function (data) {
                    //http://192.168.1.145:8090/cgi-bin/preparefilecgi.cgi?companyid=wisepeak&maintype=4&subtype=0&value1=0&merit=0&groupid=0&clientid=0&username=administrator&password=K6sf1DbzRvJ@dVi4Cedklw==&charset=utf-8&utf8=2
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    }
                    else {
                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&utf8=2",// + "&charset=utf-8",
                            async: true,
                            dataType: 'text',
                            success: function (data) {
                                TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                                //setTimeout(function () {
                                //    loadclientlist(1);
                                //}, 2000);//刷新页面， 
                            }
                        });
                    }
                }
            });
        });

        $(".cont ul li").find("span:eq(0)").click(function () {
            var currSpan = $(this).attr("class");
            if (currSpan != "" && currSpan.indexOf("state") > 0) {
                currSpan = currSpan.replace("icon state_", "");
                switch (currSpan) {
                    case "1":
                        clickState = "0";
                        break;
                    case "2":
                        clickState = "1";
                        break;
                    case "3":
                        clickState = "2";
                        break;
                    case "4":
                        clickState = "3";
                        break;
                    case "5":
                        clickState = "4";
                        break;
                    case "6":
                        clickState = "5";
                        break;
                    case "7":
                        clickState = "6";
                        break;
                    case "8":
                        clickState = "7";
                        break;
                    case "9":
                        clickState = "8";
                        break;
                    case "10":
                        clickState = "9";
                        break;
                    case "11":
                        clickState = "10";
                        break;
                    case "12":
                        clickState = "11";//所有终端。。。
                        break;
                }
            }
            //client_main_loadright(0, gid, dlv, clickState);
            //$("#client_main_right").load("client_groupinfo.aspx", { "gid": 0, "dlv": 0, "mark": clickState, "t": "",sortType:"1" }, function () {
            //    $("#client_main_right").fadeIn();
            //});
            getdataBycheckstatus(clickState);
            //load   client_groupinfo.aspx...
        });
    })
    //定时  刷新媒体播放终端状态  //暂时不用，查询终端分发进度，能获取到状态。
    function refreshStatus() {//树形列表中，当前点击的终端组 包含的终端/点击终端 的状态。。。
        //刷新状态，//从数据库获取--一直获取。5秒查询一次
        var sellist = "";
        var myid = $("#client_groupinfo_clientid").val();
        var isClient = $(".curSelectedNode").hasClass("level3");
        if ($("input[name='client_groupinfo_check']:checked").length > 0) {//‘终端管理’页面：勾选了一个或多个终端。。。
            $("input[name='client_groupinfo_check']").each(function (index, item) {
                if (item.checked) { sellist += item.value + ","; }
            });
        }
        if (sellist == "") {//‘终端管理’页面：没有勾选终端。。。
            //树形列表：
            if (isClient == true) {//选择的终端
                $("input[name='client_groupinfo_check']").each(function (index, item) {
                    sellist += item.value + ",";
                });
            } else {//选择终端组
                sellist = "*";
            }
        }
        if (sellist != "") {
            $.ajax({
                type: 'post',
                url: 'ajax/getcmdParameter.ashx',
                async: true,
                timeout: 3000,
                dataType: 'text',//maintype=0 --type=6
                data: { "type": 6, "idlist": sellist, "mark": clientmark, "maintype": 4, "subtype": 2, "value1": 0 },
                success: function (data) {////刷新状态，

                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    if (data == "-2") {
                        TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                    }
                    else {
                       // console.log(data);
                        $.ajax({
                            type: 'post',
                            url: '/cgi-bin/preparefilecgi.cgi?' + data + "&utf8=2",// + "&charset=utf-8",
                            async: true,
                            dataType: 'text',
                            success: function (data) {
                                //getclientprocessstatus();////从数据库获取
                                //强行异步加载 父节点的子节点  //节点的属性 isParent = false 时，不进行异步加载
                                //从数据库刷新 当前点击的树形的节点
                                var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                                var nodes = treeObj.getSelectedNodes();//点击终端组，刷新 下面的终端状态
                                if (nodes[0].groupflag == "0") {
                                    nodes = nodes[0].getParentNode();//获取当前终端的  父节点
                                    if (nodes != "undefined") {
                                        treeObj.reAsyncChildNodes(nodes, "refresh");//刷新 节点 下面的所有终端状态
                                    }
                                } else {
                                    if (nodes.length > 0) {
                                        treeObj.reAsyncChildNodes(nodes[0], "refresh");
                                    }
                                }
                                setTimeout("showStatus()", 500);// js刷新终端 状态图标
                                //ztree  刷新后，，节点ID会变。！！！！
                                /*
                                treeObj.getSelectedNodes();  //找不到。。。cookie也对不上ID
                                */
                                //从cookie 取值   选中节点  
                                $("#" + $.cookie("mySelectNodeID")).addClass('curSelectedNode');
                            }
                        });
                    }
                }
            });
        }
    }
    function daoxu() {
        var sh = $("#sortby").attr("value");
        if (sh == 1) {
            $("#sortby").attr("value", "0");
            $("#sortby").attr("title", getLanguageMsg("倒序", $.cookie("yuyan")));
            $("#sortby").css("background-position", "-220px -524px");
        } else {
            $("#sortby").attr("value", "1");
            $("#sortby").attr("title", getLanguageMsg("正序", $.cookie("yuyan")));
            $("#sortby").css("background-position", "-245px -524px");
        }
    }
    function getdataBycheckstatus(mycheckstatus) {///根据状态，查询终端
        var sortField = $("#sort").val();//排序字段
        var sortType = 1;//排序类型：0降序， 1 升序
        // sortType = $("#sortby").attr("checked") == "checked" ? 1 : 0;
        sortType = $("#sortby").attr("value");
        if ($("#client_list_tab").length < 1) {
            $("#client_main_right_menu li[data-type=0]").click();//点击‘终端管理’  //待优化。。。。todo..
        }
        if (mycheckstatus == "11") {
            mycheckstatus = "";
        }
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        $.ajax({
            type: 'post',
            url: 'ajax/getclientlist.ashx',
            async: true,
            dataType: 'text',
            data: { "action": "myPlayStatus", "playStatuss": mycheckstatus, "sortField": sortField, "sortType": sortType, "mark": clientmark, clientid: clientid },
            success: function (data) {
                var currentGroup = "";
                var deleteButton = "</td></tr>";
                var deleteFlag = "no";
                if (treeObj.getSelectedNodes().length > 0) {
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
                } var myHtml = "";
                var myLink = "";
                //if (myflag == "2") {//虚拟组，  不能编辑终端属性
                //    isVirtual = "yes";//链接，编辑按钮
                //}
                var json = strToJson(data);
                var mymark = "";
                var myStatus = "";
                var json = strToJson(data);
                var i = 0; var myStatus = "";
                $("#client_list_tab tr[data-type='data']").remove();//清空原来的数据
                $.each(json.Table, function (idx, item) {
                    if (i == 0) {
                        $("#client_list_selectid").val(item.clientid);
                        $("#client_list_selectmark").val(item.clientmark);
                    }
                    //0-11，在线(任务未启动),在线(任务自动执行),在线(任务手动执行),在线(临时信息显示),在线(紧急信息显示),在线(任务执行完毕),在线(任务暂停执行),在线(用户介入),在线(空闲自动执行),远程控制,全部                   
                    i++;
                    if (deleteFlag != "no") {
                        deleteButton = '<a href="javascript:void(0)" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" onclick="TopDeleteClientMessage(' + item.clientid + ')" style="position:relative;top:3px;"><img src="/images/icon_del.png"></a></td></tr>';   //只有点击 3 级终端组/终端，这个按钮才会显示.
                    }

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
                    if (item.clientmark == "" || item.clientmark == null) {
                        mymark = '<a title="' + getLanguageMsg("在虚拟组中", $.cookie("yuyan")) + '" style="background:url(/images/tubiaoa.png) no-repeat scroll -152px -80px;width: 16px;height: 16px;display:inline-block;position:relative;position:relative;top:9px;"></a>';//mymark = "在虚拟组中";
                    } else {
                        mymark = '<a title="' + getLanguageMsg("在实体组中", $.cookie("yuyan")) + '" style="background:url(/images/tubiaoa.png) no-repeat scroll -150px -56px;width: 16px;height: 16px;display:inline-block;position:relative;top:5px;"></a>';//mymark = "在实体组中";
                    }

                    var statushtml = '<span class="icon state_' + (parseInt(item.playstatus) + 1) + '" title="' + getLanguageMsg(myStatus, $.cookie("yuyan")) + '" style="position:relative;left:20px;"></span>';
                    if (item.clientname.length > 8) { client_group = item.clientname.substr(0, 7) + "..." }
                    var client_group = item.clientname;//--whq2.8 实体组、虚拟组： 可以编辑 终端属性。。。。
                    //if (isVirtual=="no") {
                    myHtml = '<a href="javascript:void(0)" title="' + getLanguageMsg("编辑", $.cookie("yuyan")) + '" onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')" style="position:relative;top:3px;margin-right:5px;><img src="/images/icon_edit.png"></a>';//显示编辑按钮
                    myLink = '<a onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')" style="cursor:pointer">' + client_group + '</a>';//终端名称 显示‘超链接’，点击可以编辑。
                    //} else {
                    //    myLink = client_group;//虚拟组下的终端，只显示 ‘终端名称’。不能编辑 --2.8可以编辑
                    //}

                    $("#client_list_tab").append('<tr data-type="data" data-id="' + item.clientid + '" data-name="' + item.clientname + '" data-ipaddress=' + item.ip + '><td><input type="checkbox" value="' + item.clientid + '" name="client_groupinfo_check" style=""><span class="client_gnumber">' + item.clientid + '</span>' + '&nbsp;'+ statushtml + mymark + '</td>'
                        + '<td title="' + item.clientname + '"><a onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')" style="cursor:pointer">' + myLink + '</a></td>'
                        + '<td>' + item.ip + '</td>'
                        + '<td>' + item.startuptime + '</td>'
                        + '<td>' + item.shutdowntime + '</td>'
                        + '<td><div style="width:100px; height:20px; margin:0 5px; background:#ddd;"><div class="process" style="height:20px; color:#fff;display: initial;"><div></div></td>'//<td><div style="width:100px; height:20px;line-height:20px; margin:0 auto; background:#ddd;"><div class="process" style="height:20px;line-height:20px;vertical-align: super; color:#fff"><div></div></td>'

                        + '<td>'
                        + myHtml + deleteButton
                        //+ '<a href="javascript:void(0)" title="编辑" onclick="client_main_loadright(8,\'' + item.clientid + '\',4,\'' + item.clientmark + '\')"><img src="/images/icon_edit.png"></a>'

                        //+ '<a href="javascript:void(0)" title="删除" onclick="TopDeleteClientMessage(' + item.clientid + ')"><img src="/images/icon_del.png"></a></td></tr>'
                    );

                });
                $("#client_groupinfo_reloadbtn").click();
            }
        });
    }
    //删除终端组
    $("body").off("click", "a[name=btn_deleteclientgroup]");
    $("body").on("click", "a[name=btn_deleteclientgroup]", function () {
        var newId = $(this).attr("data-id");
       // alert(clientid + ".."); return;
        $.ajax({
            type: 'post',
            url: 'ajax/delgroup.ashx',
            async: true,
            data: { id: clientid, mark: clientmark },
            dataType: 'text',
            success: function (data) {
                if (data == "-2") {
                    TopTrip(getLanguageMsg("该终端组下还有终端组或终端!", $.cookie("yuyan")), 2);
                }
                if (parseInt(data) >= 1) {
                    loadParentPage();
                }
                $('#' + newId + ' .TopTrip').stop().animate({ top: 0 }, 200).remove();
            }
        });
    });
    //$("a[name=btn_candeleteclient]").off().on("click", function () {
    //    var newId = $(this).attr("data-id");
    //    $('#' + newId + ' .TopTrip').stop().animate({ top: 0 }, 200).remove();
    //});
    //删除弹框：删除、组内删除
    $("body").off("click", "a[name=btn_deleteclient]");
    $("body").on("click", "a[name=btn_deleteclient]", function () {
        //alert(11 + "..");
        //return;
        var newId = $(this).attr("data-id");
        var type = $(this).attr("data-type");//0、1删除、组内删除
        var id = $(this).attr("data-clienid");
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var isvirtualgroup = "no";
        if (treeObj.getSelectedNodes().length > 0) {
            if (treeObj.getSelectedNodes()[0].groupflag == "2") {////‘虚拟组’ 删除终端。。。
                isvirtualgroup = "yes";
            } else if (treeObj.getSelectedNodes()[0].groupflag == "0") {//如果点击终端，client
                isvirtualgroup = "client";
            }
            if (treeObj.getSelectedNodes()[0].id == id) {
                $("#delSelf").val("1"); // 删除 点击的节点。 删除自己，
            }
            // console.log($("#delSelf").val() + "......773");
        }

        $.ajax({
            type: 'post',
            url: 'ajax/delclient.ashx',
            async: true,
            data: { id: id, mark: clientmark, type: type, "isvirtualGroup": isvirtualgroup },
            dataType: 'text',
            success: function (data) {
                if (data == "0" || data == "-1") {
                    LoginTimeOut();
                    //TopTrip(getLanguageMsg("该终端组下还有终端组或终端!", $.cookie("yuyan")), 2);
                }
                if (data == "1") {
                    loadParentPage();
                }
                $('#' + newId + ' .TopTrip').stop().animate({ top: 0 }, 200).remove();
            }
        });
    });
    function loadParentPage() {
        //debugger;//点击终端，删除自己。
        //var mark = clientmark.substring(0, clientmark.lastIndexOf("_"));
        //var dlv = mark.split("_").length - 1;
        //var gid = mark.substring(0, mark.lastIndexOf("_"));

        if ($.cookie("mySelectNodeID") != "" && $.cookie("mySelectNodeID") != null) {//记录的上次点击的终端(组)
            $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());//, { cache: false })
        } else {
            $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());

        }
        //client_main_loadright(0, gid, dlv, mark);
        client_main_loadright(0, clientid, dlevel, clientmark);
    }
    function loadclientlist(type) {

        var zdlb = "client_groupinfo.aspx";
        //if ($.cookie("slect_tab") == "终端管理") {
        //    zdlb = "client_groupinfo.aspx";
        //    type = 0;
        //} else {
        //    zdlb = "client_view.aspx";
        //    type = 1;
        //}
        if ($.cookie('slect_tab_dataType') == "0") {
            zdlb = "client_groupinfo.aspx";
            type = 0;
        } else {
            zdlb = "client_view.aspx";
            type = 1;
        }

        try {
            clearInterval(myInterTimer);

        } catch (exex) {

        }
        try {
            clearInterval(myInterTimerg);

        } catch (ex2) {

        }
        var prag = $("#client_main_right_menu li[data-type=1]");
        var jiemu = $("#client_main_right_menu li[data-type=0]");

        if (type == 0) {
            $("#client_groupinfo_btnMgr").show();
            $("#client_groupinfo_btnMenu").hide();//, "sortField": sortField, "sortType": sortType
            $(".terminal_con").load(zdlb, { "gid": $("#client_main_right_clientid").val(), "dlv": $("#client_main_right_dlevel").val(), "mark": $("#client_main_right_mark").val(), "key": $("#client_main_right_key").val() }, function () {
                $(".terminal_con").fadeIn();
            });
            jiemu.addClass("current");
            jiemu.attr("data-isshow", 1);
            jiemu.siblings("li").attr("data-isshow", 0);
            prag.removeClass("current");

        }
        else {
            $("#client_groupinfo_btnMenu").show();
            $("#client_groupinfo_btnMgr").hide();
            $(".terminal_con").load(zdlb, { "gid": $("#client_main_right_clientid").val(), "dlv": $("#client_main_right_dlevel").val(), "mark": $("#client_main_right_mark").val(), "key": $("#client_main_right_key").val() }, function () {
                $(".terminal_con").fadeIn();
            });
            prag = $("#client_main_right_menu li[data-type=1]")
            prag.addClass("current");
            prag.attr("data-isshow", 1);
            prag.siblings("li").attr("data-isshow", 0);
            jiemu.removeClass("current");

        }
    }
    function client_search() {
        loadclientlist($("#client_main_right_menu li[data-isshow=1]").attr("data-type"));
    }
    //终端状态汇总
    function getclientstatus() {
        $.ajax({
            type: 'post',
            url: 'ajax/getclientstatus.ashx',
            async: true,
            data: { mark: clientmark,clientid:clientid },
            dataType: 'text',
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);
                    var sum = 0;
                    var onLineSum = 0;
                    var onlineRate = 0;
                    $.each(json.Table, function (idx, item) {
                        if (item.playstatus == "0") {
                            $("#client_main_right_status1").text(item.cnum);
                        }
                        if (item.playstatus == "1") {
                            $("#client_main_right_status2").text(item.cnum);
                        }
                        if (item.playstatus == "2") {
                            $("#client_main_right_status3").text(item.cnum);
                        }
                        if (item.playstatus == "3") {
                            $("#client_main_right_status4").text(item.cnum);
                        }
                        if (item.playstatus == "4") {
                            $("#client_main_right_status5").text(item.cnum);
                        }
                        if (item.playstatus == "5") {
                            $("#client_main_right_status6").text(item.cnum);
                        }
                        if (item.playstatus == "6") {
                            $("#client_main_right_status7").text(item.cnum);
                        }
                        if (item.playstatus == "7") {
                            $("#client_main_right_status8").text(item.cnum);
                        }
                        if (item.playstatus == "8") {
                            $("#client_main_right_status9").text(item.cnum);
                        }
                        if (item.playstatus == "9") {
                            $("#client_main_right_status10").text(item.cnum);
                        }
                        if (item.playstatus == "10") {
                            $("#client_main_right_status11").text(item.cnum);
                        }
                        sum = sum + parseInt(item.cnum);
                    });
                    //debugger;
                    onLineSum = sum - parseInt($("#client_main_right_status1").text());
                    var aa = ((onLineSum / sum) * 100).toString();
                    var bb = aa.split(".");
                    if (sum == 0) {
                        onlineRate = 0;
                    } else {
                        if (bb.length > 1) {
                            var rateNum = bb[1];
                            if (rateNum.length > 2) {
                                onlineRate = parseFloat((onLineSum / sum) * 100).toFixed(2);
                            }
                        } else {
                            onlineRate = parseFloat(onLineSum / sum) * 100;
                        }
                    }
                    $("#client_main_right_status12").text(sum);
                    $(".clientOnline").html(getLanguageMsg("在线率：", $.cookie("yuyan")) + onlineRate + "%");
                }
            }
        });
    }
    function client_groupinfo_sendmenucmd(maintype, subtype) {
        var sellist = "";
        var myType = 0; var menuid = 0; var groupID = 0;
        if (maintype != "7") {//maintype=="0"
            myType = 6;
        } else {
            myType = 1;
        }
        //$("input[name=ch_client_menu]:checked").each(function () {
        //    sellist = sellist + $(this).val() + ",";
        //})

        //else {
        var trs = $("#client_menu_tab tr"); var trcount = trs.length;
        for (var i = 1; i < trcount; i++) {
            if (trs[i].innerHTML.indexOf("icon_enabled.png") > 0) {
                menuid = trs[i].getAttribute("data-menuid");//获得 终端 启用的节目单id
                //alert(menuid);
            }
        }
        if ($("#client_menu_tab tr").length >= 2) {//whq...终端\终端组 都能添加节目单。
            sellist = $("#client_menu_tab tr:eq(1)").attr("data-clientid");
        }//
        var dlevels = $("#client_main_right_dlevel").val();
        if (dlevels != "" && parseInt(dlevels) > 3) {//选择的终端

        } else if (dlevels != "" && parseInt(dlevels) <= 3) {//选择的终端组
            sellist = "";
        }
        if (sellist == "") {//终端、终端组，分发指令不同。。。
            sellist = "*";
        }
        //debugger;
        //http://192.168.1.145/cgi-bin/preparefilecgi.cgi?companyid=wisepeak&maintype=0&subtype=1&value1=233&merit=5&groupid=0&clientid=14&username=whq123&password=yoaC/EHueDeMo8EM/alIMw==&charset=utf-8
        $.ajax({
            type: 'post',
            url: 'ajax/getcmdParameter.ashx',
            async: true,
            timeout: 5000,
            dataType: 'text',//maintype=0 --type=6
            data: { "type": myType, "idlist": sellist, "mark": clientmark, "maintype": maintype, "subtype": subtype, "value1": menuid },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }

                if (data == "-2") {
                    TopTrip(getLanguageMsg("您没有权限执行该操作！", $.cookie("yuyan")), 2);
                }
                else if (data == "-3") {
                    TopTrip(getLanguageMsg("该节目单或下属素材未通过审核！", $.cookie("yuyan")), 2);
                } else {
                    //debugger;
                    //若utf8=1  中文字符编码之后请求才可  utf8=2直接传输即可
                   // data = encodeURI(encodeURI(data));
                    $.ajax({
                        type: 'post',
                        url: '/cgi-bin/preparefilecgi.cgi?' + data + "&utf8=2", // + "&charset=utf-8",
                        async: true,
                        dataType: 'text',
                        success: function (data) {
                            TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                            setTimeout(function () {
                                loadclientlist(1);
                            }, 2000);//刷新页面， 更新分发进度。
                            //0,1   启动节目单分发 ,,分发完成，更新sendingprocess....todo...在client_view页面更新？？？
                        }
                    });
                }
            }
        });
        // }width: 748px;
    }

    //设置开关机时间 //发指令
    function SetShutDownTimes(ids) {
        $.ajax({
            type: 'post',
            url: 'ajax/getcmdParameter.ashx',
            async: true, timeout: 5000,
            dataType: 'text',//maintype=0 --type=6
            data: { "type": 6, "idlist": ids, "mark": clientmark, "maintype": 5, "subtype": 9, "value1": 0 },
            success: function (data) {
                //console.log(data);
                if (data == "-1") {
                    LoginTimeOut();
                }
                if (data == "-2") {
                    TopTrip("您没有权限执行该操作！", 2);
                }
                else {
                    $.ajax({
                        type: 'post',
                        url: '/cgi-bin/preparefilecgi.cgi?' + data + "&utf8=2",// + "&charset=utf-8",
                        async: true,
                        dataType: 'text',
                        success: function (data) {
                            TopTrip(getLanguageMsg("发送指令成功！", $.cookie("yuyan")), 1);
                            setTimeout(function () {
                                loadclientlist(1);
                            }, 2000);//刷新页面， 更新分发进度。

                        }
                    });
                }
            }
        });
    }

    //var allclient=$("#client_list_tab tbody tr td :checkbox")
    /*前端，把选中的终端/组的id,以及 其所有上级的id，传到后台，查询出来，组成excel、txt；   有层次关系。？？万一导出所有终端/组？？*/
    function exportData(mytype) {//txt  , xls
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var ids = ""; var clientid = "";
        if (treeObj.getSelectedNodes().length <= 0) {
            TopTrip(getLanguageMsg("请选择要导出的终端/终端组！", $.cookie("yuyan")), 2);
            return;
        }
        var selectNode = treeObj.getSelectedNodes()[0];
        //selectNode.getParentNode().getParentNode().getParentNode().getParentNode().getParentNode()
        var paths = selectNode.getPath();
        for (var i = 0; i < paths.length; i++) {
            //if (paths[i].GroupFlag == "1") {
            //    ids = ids + paths[i].id + ";";
            //} else {
            ids = ids + paths[i].id + ",";

        }

        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        <%--debugger;--%>
        var url = "ajax/getclientlist.ashx?action=exportClient&myType=" + mytype + "&ids=" + ids;// + "&myWhere=" + myWhere1
        var ptop = window.screen.height / 2 - 400;
        var pleft = window.screen.width / 2 - 700;
        var a = window.open(url, "daochu", 'left=' + pleft + ',top=' + ptop + ',height=400,width=700,toolbar=no,menubar=no,scrollbars=no,status=no,location=no,resizable=no');
        a.focus();
        if (a) {
            //console.log("export....ok....");

        }
        /*var allclient = $("#client_list_tab tbody tr td :checkbox");
        var ids = "";
        allclient.each(function (id,item) {
            //console.log(item.value);
            ids = ids  + item.value+ ",";
        });*/
        //console.log("导出的终端id  " + ids);
    }

</script>

<input type="hidden" id="client_groupinfo_comid" runat="server" />
<input type="hidden" id="client_main_right_dlevel" runat="server" />
<input type="hidden" id="client_main_right_clientid" runat="server" />
<input type="hidden" id="client_main_right_mark" runat="server" />
<%--文本--播放终端根目录--%>
<input type="hidden" id="client_main_right_pageMap" runat="server" /><!-- #f7f7f7  84-->
<div class="terminal_state" data-isshow="0" style="display: none; width: 872px; position: absolute; top: 77px; left: 0; z-index: 1000; background: #d4d2d2">
    <div class="title"><span class="language">播放终端状态查看</span><span class="inp_btn input_hover" style="padding-left: 1px;"><a href="javascript:void(0)" onclick="getclientstatus()" class="language">刷新状态统计</a></span>&nbsp;&nbsp;<span class="clientOnline"></span></div>
    <div class="cont" style="width: 100%;">
        <ul class="clearfix ukl_box">
            <li><span class="icon state_1" title="离线"></span><span class="num" id="client_main_right_status1">0</span><span class="clien_statues language">离线</span></li>
            <li><span class="icon state_2" title="在线(任务未启动)"></span><span class="num" id="client_main_right_status2">0</span><span class="clien_statues language">在线(任务未启动)</span></li>

            <li><span class="icon state_3" title="在线(任务自动执行)"></span><span class="num" id="client_main_right_status3">0</span><span class="clien_statues language">在线(任务自动执行)</span></li>

            <li><span class="icon state_4" title="在线(任务手动执行)"></span><span class="num" id="client_main_right_status4">0</span><span class="clien_statues language">在线(任务手动执行)</span></li>
            <li><span class="icon state_5" title="在线(临时信息显示)"></span><span class="num" id="client_main_right_status5">0</span><span class="clien_statues language">在线(临时信息显示)</span></li>
            <li><span class="icon state_6" title="在线(紧急信息显示)"></span><span class="num" id="client_main_right_status6">0</span><span class="clien_statues language">在线(紧急信息显示)</span></li>
            <li><span class="icon state_7" title="在线(任务执行完毕)"></span><span class="num" id="client_main_right_status7">0</span><span class="clien_statues language">在线(任务执行完毕)</span></li>
            <li><span class="icon state_8" title="在线(任务暂停执行)"></span><span class="num" id="client_main_right_status8">0</span><span class="clien_statues language">在线(任务暂停执行)</span></li>
            <li><span class="icon state_9" title="在线(用户介入)"></span><span class="num" id="client_main_right_status9">0</span><span class="clien_statues language">在线(用户介入)</span></li>
            <li><span class="icon state_10" title="在线(空闲自动执行)"></span><span class="num" id="client_main_right_status10">0</span><span class="clien_statues language">在线(空闲自动执行)</span></li>
            <li><span class="icon state_11" title="远程控制"></span><span class="num" id="client_main_right_status11">0</span><span class="clien_statues language">远程控制</span></li>
            <li><span class="icon state_12" title="全部"></span><span class="num" id="client_main_right_status12">0</span><span class="clien_statues language">全部</span></li>
        </ul>
    </div>
</div>
<%--搜索查询--%>
<div class="terminal_info">
    <div class="title">
        <ul>
            <li><%---- clientid   clientname  playdetail   descript    clientmark   playstatus   postion--%>
                <select name="sort" id="sort" runat="server" style="width: 180px; height: 30px; line-height: 30px;">
                    <option value="clientname" class="language">终端名称排序</option>
                    <option value="clientid" class="language">终端标记排序</option>
                    <option value="playdetail" class="language">终端版本号排序</option>
                    <option value="descript" class="language">终端描述排序</option>
                    <option value="clientmark" class="language">终端所属排序</option>
                    <option value="playstatus" class="language">终端状态排序</option>
                    <option value="postion" class="language">终端分发顺序排序</option>
                    <option value="createtime" >终端添加时间排序</option>
                    <option value="ip" >终端地址排序</option>
                </select>
                <!--<input id="sortby" name="sortby" value="1" type="checkbox" style="display:none;"><label for="sortby">倒序</label> margin-left: 1px;margin-top:4px;padding-left:27px;-->
                <a class="sor_dxpic" id="sortby" value="0" title="倒序" onclick="daoxu()"></a>
            </li>
            <li style="margin-left: 20px;">
                <span style="float: left; margin-left: 20px;" class="language">终端名称：</span><input class="ss_t" type="text" placeholder="终端名称/IP" id="client_main_right_key" runat="server" style="width: 160px; line-height: 25px; height: 25px; margin-left: 0;"></li>
            <li>
                <input class="ss_s language" value="查询" title="查询" type="button" onclick="client_search()"></li>
            <li>
                <input class="ss_s language" value="查看状态" title="查看状态" type="button" id="client_groupinfo_reloadbtn"></li>
            <%--<li>

                <a href="JavaScript:void(0)" title="导出TXT" onclick="exportData('txt')">
                    <img src="/images/txt.png" /></a>
                <a href="JavaScript:void(0)" title="导出Excel" onclick="exportData('xls')">
                    <img src="/images/xls.png" /></a>
            </li>--%>
        </ul>
    </div>
</div>
<%--操作按钮--%>
<%--终端管理--%>
<div class="add_btn clearfix" id="client_groupinfo_btnMgr" runat="server" style="padding: 0; display: none">
</div>
<%--节目单分发管理--%>
<div class="add_btn clearfix" id="client_groupinfo_btnMenu" runat="server" style="padding: 0; display: none">
</div>
<%--内容--%>
<div class="client_main_right_menu" style="height:640px;overflow:auto">
    <div class="item">
        <ul class="clearfix" id="client_main_right_menu" runat="server">
        </ul>
    </div>
    <div class="terminal_con">
    </div>
</div>
<div id="client_main_cmdbox" style="display: none"></div>
