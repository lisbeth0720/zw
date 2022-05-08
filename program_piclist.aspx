<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_piclist.aspx.cs" Inherits="Web.company.program.program_piclist" %>

<%--<style>
    #program_pic_list_loadmore a b
    {
        padding-left:20px;
     background: url(/images/tubiaoa.png) -90px -52px;
    }
    #program_pic_list_loadmore a:hover b
    {
        background: url(/images/tubiaoa.png) -90px -80px;
    }
    #program_pic_list_loadmore a:hover
    {
        background-color:#61c6f8;
    }
   
</style>--%>
<script type="text/javascript">
    var pagetype;
    $(function () {
        pagetype = $("#program_picist_hid_type").val();
        //debugger;
        program_list_pic_getdata();
        
        switchLanguage("#program_data_piclist", 1, "program_piclist.aspx");

    })

    //鼠标悬停后显示布局图片
    function showbtn(menuid) {
        $(".mod_sclist[data-itemid=" + menuid + "]").find("img").attr("src", $(".mod_sclist[data-itemid=" + menuid + "]").find("img").attr("frameImg"));
    }
    //鼠标离开后显示节目项缩略图
    function hidebtn(menuid) {
        $(".mod_sclist[data-itemid=" + menuid + "]").find("img").attr("src", $(".mod_sclist[data-itemid=" + menuid + "]").find("img").attr("thumbImg"));
    }
        function program_list_pic_getdata() {
            var key = $("#program_list_pic_qy_sn").val() + "|";
            key += $("#program_list_pic_qy_un").val() + "|";
            key += $("#program_list_pic_qy_cd").val() + "|";
            key += $("#program_list_pic_qy_s").val() + "|";
            key += $("#program_list_pic_qy_us").val() + "|";
            key += $("#program_list_pic_qy_sr").val() + "|";
            key += $("#program_list_pic_qy_isown").val() + "|";
            key += $("#program_list_pic_qy_page").val() + "|";
            key += $("#program_list_pic_qy_dr").val() + "|";
            key += $("#program_list_pic_qy_group").val() + "|";
            key += $("#program_list_pic_qy_isfiled").val();
            $.ajax({
                type: 'post',
                url: '/company/program/ajax/getlistdata.ashx',
                async: true,
                data: {
                    t: pagetype,
                    sd: $("#program_list_pic_ds").val(),
                    key: key,
                    of: $("#program_list_pic_of").val(),
                    sort: $("#program_list_pic_sort").val()

                },
                dataType: 'text',
                success: function (data) {
                    //debugger;
                    var json = eval("(" + data + ")");
                    program_list_pic_show(json);
                }
            })
        }
        function program_list_pic_show(json) {
            var i = 0;
            var isLine = json.UserInfo.split('a');
            var merits = isLine[1];
            isLine = isLine[0];
            $.each(json.Table, function (idx, item) {
                i++;
                //whq8.7
                var statushtm = '<div class="attr_icon css" title="text"></div>';
                var myCss = ""; var myText = "";
                myCss = "notpass";
                var hasEdit = "";
                sts = item.checkstatus;
                switch (parseInt(sts)) {
                    case 2:
                        myText = "费用用完"; break;
                    case 4:
                        myText = "暂停分发"; break;
                    case 8:
                        myText = "信息不符"; break;
                    case 16: myText = "信息过期"; break;
                    case 32: myText = "政治反动"; break;
                    case 64: myText = "宗教"; break;
                    case 128: myText = "色情"; break;
                    case 256: myText = "暴力"; break;
                    case 512: myText = "攻击"; break;
                    case 1024: myText = "恶意"; break;
                    case 2048: myText = "机密"; break;
                    case 4096: myText = "隐私"; break;
                    case 3:
                        myText = "其他"; break;
                }
                if (item.checkstatus == 0) {
                    myCss = "reflesh"; myText = "待审";
                } else if (item.checkstatus == 1) {
                    myCss = "approve"; myText = "通过";
                    if (item.isfiled == 1) {
                        myCss = "filed"; myText = "归档";
                    }
                }

                statushtm = statushtm.replace("css", myCss).replace("text", getLanguageMsg(myText, $.cookie("yuyan")));
                //var statushtm = '<div class="attr_icon approve"></div>';
                //if (item.checkstatus != 1) {

                //    statushtm = '<div class="attr_icon reflesh"></div>';
                //}
                //console.log(itemid);
                //'<li>节目单名称：<a href="/company/program/program_edit.aspx?id=' + item.itemid + '">' + item.itemname + '</a></li>'
                if (merits <= item.merit || $("#arrangeIDs").val().indexOf(',' + item.itemid + ',') >= 0 || $("#arrangeIDs").val().indexOf('all') >= 0) {
                    hasEdit = '<li>' + getLanguageMsg("节目单名称", $.cookie("yuyan")) + '：<a href="/company/program/program_edit.aspx?id=' + item.itemid + '">' + item.itemname + '</a></li>';
                } else { hasEdit = '<li>' + getLanguageMsg("节目单名称", $.cookie("yuyan")) + '：' + item.itemname + '</li>'; }
                $("#program_list_pic_qy_lsid").val(item.itemid);
                $("#program_pic_list").append('<div class="mod_sclist" data-itemid="' + item.itemid + '" " data-itemname="' + item.itemname + '" " data-checkstatus="' + item.checkstatus + '" " data-itemtype="' + item.itemtype + '"><div class="borbg" >'
                + '<div class="pic"><div class="menuover"></div><div class="thumb" ><img src="/images/no_upload_2.jpg" width="200" height="120"></div><div class="lk clearfix"></div></div>'
                + '<div class="nr" title="ID : ' + item.itemid + '" ><ul>'
                + hasEdit
                + '<li>' + getLanguageMsg("更新时间", $.cookie("yuyan")) + '：' + item.modifytime + '</li>'
                + '<li>' + getLanguageMsg("操作员", $.cookie("yuyan")) + '：' + item.username + '</li>'
                + '<li>' + getLanguageMsg("描述", $.cookie("yuyan")) + '：' + item.descript + '</li>'
                + '</ul></div></div>' + statushtm + "</div>");
                //显示图示部分
                //loadProgramThumbHtml(item.itemid);
                program_picist_showfirstsc(item.itemid);
                //操作部分
                pro_pic_List_operHtml(isLine, merits, item.merit, pagetype, item.isfiled, item.itemid, item.itemname, item.itemtype, item.checkstatus);

            });
            if (i < 10) {
                $("#program_pic_list_loadmore").fadeOut();
            }

        }

        function pro_pic_List_operHtml(isLine, merits, ulevel, pagetype, isfiled, itemid, itemname, itemtype, checkstatus) {

            /*$.ajax({
                type: 'post',
                url: '/company/program/ajax/getOperateHtml.ashx',
                async: false,
                data: {
                    pagetype: pagetype,
                    ulevel: ulevel,
                    isfiled: isfiled
                },
                dataType: 'text',
                success: function (data) {*/
            var result = "";
            if (isLine == 1) {
                if (isfiled == 1) {
                    //已归档栏目，所有按钮失效
                    if (pagetype == 0 || pagetype == 1 || pagetype == 5) {
                        result = "0";
                    }
                    else if (pagetype == 2) {
                        result = "0";

                    }
                    else if (pagetype == 3) {
                        result = "0";
                    }
                    else if (pagetype == 4) {
                        result = "1";
                    }
                }
                else {
                    if (pagetype == 0 || pagetype == 1 || pagetype == 5) {
                        if (merits <= ulevel) {
                            result = "1";
                        }
                        else {
                            result = "0";
                        }
                    }
                    else if (pagetype == 2) {
                        result = "1";
                    }
                    else if (pagetype == 3) {
                        if (merits <= ulevel) {
                            result = "1";
                        }
                        else {
                            result = "0";
                        }
                    }
                    else if (pagetype == 4) {
                        result = "1";
                    }
                }
            } else {
                result = "-1";
            }
            var html = "";
            
            var btn_client = '<span class="fl"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '" style="width: 25px;;height: 22px;background: url(/images/tubiaoa.png) -115px -102px;display:inline-block;"></a><a href="javascript:void(0)" onclick="" title="' + getLanguageMsg("查看节目单布局", $.cookie("yuyan")) + '" style="padding-left: 20px;height: 20px;background: url(/images/tubiaoa.png) -222px -102px;display:inline-block;margin-left:10px;" onMouseOver="showbtn(' + itemid + ')" onMouseOut="hidebtn(' + itemid + ')"></a></span>';
            if (result == "1") {
                //查看播放终端按钮
                
                if (pagetype == 0) {// || pagetype == 5
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        window.location.href = "/company/program/program_arrange.aspx?id=" + itemid + "&type=0";
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client
                    + '<span class="fr"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:30px;height:20px;background: url(/images/tubiaoa.png) -271px -51px;display:inline-block;"></a><a href="javascript:void(0)" onclick="program_main_del(' + itemid + ')" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -245px -28px;display:inline-block;"></a></span>').show();
                }
                if (pagetype == 1) {
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        window.location.href = "/company/program/program_edit.aspx?id=" + itemid;
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><select data-itemid="' + itemid + '"  name="program_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>'
                + '<span class="fr"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '" style="width:25px;height: 22px;display:block;background:url(/images/tubiaoa.png) -115px -102px;"></a></span>');

                }
                if (pagetype == 2 || pagetype == 5) {
                   // console.log("221 pagetype=" + pagetype);
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        window.location.href = "/company/program/program_arrange.aspx?id=" + itemid;
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client);
                    if ($("#checkIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding: 0;"><select  data-itemid="' + itemid + '" data-checkstatus="' + checkstatus + '" data-status="' + status + '" name="program_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                    } else if (merits <= ulevel && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding: 0;"><select  data-itemid="' + itemid + '" data-checkstatus="' + checkstatus + '" data-status="' + status + '" name="program_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                    }
                    if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding-right: 0;"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0"  title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -270px -51px;display:inline-block;"></a></span>');
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = '/company/program/program_arrange.aspx?id=' + itemid + '&type=0';
                        })
                    } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding-right: 0;"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0"  title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -270px -51px;display:inline-block;"></a></span>');
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = '/company/program/program_arrange.aspx?id=' + itemid + '&type=0';
                        })
                    }
                    if (merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fr" style="padding-left: 0;padding-right: 0;"><a href="javascript:void(0)" onclick="program_main_del(' + itemid + ')" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -245px -28px;display:inline-block;"></a></span>');
                    }
                 //   //$(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client
                 //+ '<span class="fr"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="编排节目单" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -271px -51px;"></a></span>');
                }
                if (pagetype == 3) {
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        window.location.href = "/company/program/program_arrange.aspx?id=" + itemid;
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client
                  + '<span class="fr"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=1" title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -271px -51px;"></a></span>');
                }
                if (pagetype == 4) {
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        
                        clientmenu_add(itemid, itemname);
                        
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="clientmenu_add(' + itemid + ', \'' + itemname + '\');"><b style="padding-left:20px;background:url(/images/tubiao.png) -255px -125px"></b>' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '</a></span>');
                }

            }
            if (result == "0") {
                if (pagetype == 0) {// || pagetype == 5
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        // window.location.href = "/company/program/program_edit.aspx?filed=1&id=" + itemid;
                        window.location.href = "/company/program/program_arrange.aspx?id=" + itemid + "&type=0";

                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client
                         + '<span class="fr"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0"  title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -270px -51px;display:inline-block;"></a></span>'
                  ).show();
                }
                if (pagetype == 1) {
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        window.location.href = "/company/program/program_edit.aspx?filed=1&id=" + itemid;
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><select disabled="disabled" data-itemid="' + itemid + '" data-checkstatus="' + checkstatus + '" data-status="' + status + '" name="program_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>'
                + '<span class="fr"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '" style="width:25px;height: 22px;display: block;background: url(/images/tubiaoa.png) -115px -102px;"></a></span>');
                }
                if (pagetype == 2 || pagetype == 5) {//program_arrange.aspx?id=' + itemid + '&type=1" ..//type:0编排，1编排审核
                   // console.log("284 pagetype="+pagetype);
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        // window.location.href = "/company/program/program_arrange.aspx?filed=1&id=" + itemid;
                        if (merits <= ulevel && $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0 || $("#arrangeIDs").val().indexOf('all') >= 0) {
                            window.location.href = "/company/program/program_arrange.aspx?id=" + itemid + "&name=" + itemname + "&type=0";
                        } else { TopTrip(getLanguageMsg("您无权限编排该栏目!", $.cookie("yuyan")), 2); }
                    });
                   
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client);
                    if ($("#checkIDs").val().indexOf('all') >= 0 && isfiled == "0") {//超级管理员  ，*--所有节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding: 0;"><select  data-itemid="' + itemid + '" data-checkstatus="' + checkstatus + '" data-status="' + status + '" name="program_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                    } else if (merits <= ulevel && isfiled == "0" && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding: 0;"><select  data-itemid="' + itemid + '" data-checkstatus="' + checkstatus + '" data-status="' + status + '" name="program_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                    }
                    if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding-right: 0;"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0"  title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -270px -51px;display:inline-block;"></a></span>');
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = '/company/program/program_arrange.aspx?id=' + itemid + '&type=0';
                        })
                    } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此节目单
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl" style="padding-right: 0;"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0"  title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -270px -51px;display:inline-block;"></a></span>');
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = '/company/program/program_arrange.aspx?id=' + itemid + '&type=0';
                        })
                    }
                    if (merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fr" style="padding-left: 0;padding-right: 0;"><a href="javascript:void(0)" onclick="program_main_del(' + itemid + ')" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -245px -28px;display:inline-block;"></a></span>');
                    }
                    //$(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                    //    alert("tes22");
                    //    //TopTrip("您无权编排该节目单qqqqqq！", 2);
                    //    //window.location.href = "/company/program/program_edit.aspx?filed=1&id=" + itemid;
                    //});
                   // $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(
                //btn_client + '<span class="fr"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=1" title="编排节目单" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -271px -51px;"></a></span>');
                }
                if (pagetype == 3) {
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        //TopTrip("您无权编排该节目单shenhehsgehh！", 2);
                        window.location.href = "/company/program/program_edit.aspx?filed=1&id=" + itemid;
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html(btn_client
                + '<span class="fr"><a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=1" title="' + getLanguageMsg("编排节目单", $.cookie("yuyan")) + '" style="width:20px;height:20px;background: url(/images/tubiaoa.png) -271px -51px"></a></span>');
                }
                if (pagetype == 4) {
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".menuover").bind("click", function () {
                        //alert("333");
                        clientmenu_add(itemid, itemname);
                    });
                    $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="clientmenu_add(' + itemid + ', \'' + itemname + '\');"><b style="padding-left:20px;background:url(/images/tubiao.png) -255px -125px"></b>' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '</a></span>');
                }
            }

            if (checkstatus != 1) {
                $("select[name=program_sel_status][data-itemid=" + itemid + "]").val("0");
            }
            else {
                $("select[name=program_sel_status][data-itemid=" + itemid + "]").val("1");
            }

            //  }
            //})

        }
        function program_picist_showfirstsc(menuid) {
            //获取指定ID节目单中第一条记录（显示记录触发类型和状态）
            //debugger;
            $.ajax({
                type: 'post',
                url: '/company/program/ajax/getprogrammenu.ashx',
                async: true,
                data: {
                    menuid: menuid,
                    gettype: 0
                },
                dataType: 'text',
                success: function (data) {
                    if (data != -1) {
                        var json = strToJson(data);
                        if (json.Table!=undefined && json.Table.length > 0) {
                            $.each(json.Table, function (idx, item) {
                                $("#cl_pic_list .mod_sclist[data-itemid=" + menuid + "]").attr("data-sourceid", item.itemid);
                                $("#cl_pic_list .mod_sclist[data-itemid=" + menuid + "]").attr("data-contenttype", item.contenttype);
                                //如果是栏目则可以显示栏目图标
                                if (item.Thumbnail != "" && item.Thumbnail != null) {
                                    myResult = item.Thumbnail;
                                    $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").attr("width", "");
                                } else {
                                    myResult = "/images/img_new/default_" + item.contenttype + "_3.png";
                                    $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").attr("width", "");
                                }
                                //如果遇到图片错误则节目单缩略图使用类型图来代替
                                $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").error(function () {
                                    $(this).attr('src', "/images/img_new/default_" + item.contenttype + "_3.png");
                                });
                                $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").attr("src",myResult);
                                $(".mod_sclist[data-itemid=" + menuid + "]").attr("data-thumb", item.Thumbnail);
                                var frameImg = "/privatefiles/<%=companyID %>/thumbnail/other/fr_" + item.framelayoutid + "_1.jpg";
                                var frameImg = "/privatefiles/<%=companyID %>/thumbnail/other/fr_" + item.framelayoutid + "_5.jpg";
                                //$(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").attr("src", frameImg);
                                //alert(frameImg);
                                $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").attr("frameImg",frameImg);
                                $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").find("img").attr("thumbImg", myResult);

                                return false;
                            })
                        }
                    }
                    else if (data == 0)
                    {
                        ;//没有记录
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            })
        }
        //获取节目单的缩略图
        function loadProgramThumbHtml(itemid) {
            $.ajax({
                type: 'post',
                url: '/company/program/ajax/getprogrammenu.ashx',
                async: false,
                data: {
                    menuid: itemid,
                    gettype: 1
                },
                dataType: 'text',
                success: function (data) {
                    if (data != -1) {
                        var json = strToJson(data);
                        if (json.Table.length > 0) {
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").html('<iframe width="200" height="120"  frameborder="no" border="0"  src="PrList_thumb.aspx?lid=' + json.Table[0].framelayoutid + '&mid=' + itemid + '&lp=' + json.Table[0].framelayoutposition + '">');
                        }
                    }
                    else if (data == 0)
                    {
                        ;//没有记录
                    }
                    else {
                        LoginTimeOut();
                    }
                }
            })
        }
        function program_list_pic_shownext() {
            $("#program_list_pic_qy_page").val(parseInt($("#program_list_pic_qy_page").val(), 10) + 1);
            program_list_pic_getdata();
        }
</script>
<input type="hidden" id="program_picist_hid_type" runat="server" />
<!--数据来源：0：数据库；1：cookie---------->
<input type="hidden" id="program_list_pic_ds" runat="server" value="0" />
<!--排序字段 0:id,1:推荐指数，2：素材名称，3：文件类型,4:操作员，5：状态，6：创建时间---------->
<input type="hidden" id="program_list_pic_of" runat="server" value="0" />
<!--排序方式：0：倒叙；1：使用推荐正序---------->
<input type="hidden" id="program_list_pic_sort" runat="server" value="0" />
<!--查询条件：上次加载的最小ID（为空时第一次加载）---------->
<input type="hidden" id="program_list_pic_qy_page" runat="server" value="1" />
<!--查询条件：是否只查询自己的（0：查询所有的；1：只查询自己的）---------->
<input type="hidden" id="program_list_pic_qy_isown" runat="server" value="0" />
<!--查询条件：节目单名查询（为空时全部）---------->
<input type="hidden" id="program_list_pic_qy_sn" runat="server" value="" />
<!--查询条件：用户名查询---------->
<input type="hidden" id="program_list_pic_qy_un" runat="server" value="" />
<!--查询条件：创建日期查询（为空时全部）---------->
<input type="hidden" id="program_list_pic_qy_cd" runat="server" value="" />
<!--查询条件：审核状态查询（为空时全部）---------->
<input type="hidden" id="program_list_pic_qy_s" runat="server" value="" />
<!--查询条件：调用状态查询（为空时全部）---------->
<input type="hidden" id="program_list_pic_qy_us" runat="server" value="" />
<!--查询条件：分辨率查询（为空时全部）（多选','分割）---------->
<input type="hidden" id="program_list_pic_qy_sr" runat="server" value="" />
<!--查询条件：时间范围查询---------->
<input type="hidden" id="program_list_pic_qy_dr" runat="server" value="" />
<!--查询条件：类型查询（为空时全部）---------->
<input type="hidden" id="program_list_pic_qy_isfiled" runat="server" value="" />
<!--查询条件：分组查询---->
<input type="hidden" id="program_list_pic_qy_group" runat="server" value="" />
<div class="program_pic_list clearfix" id="program_pic_list">
</div>
<div class="loading_more" id="program_pic_list_loadmore"><a href="javascript:void(0)" onclick="program_list_pic_shownext()"><b></b><span class="language">加载更多</span></a></div>

