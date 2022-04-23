<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_piclist.aspx.cs" Inherits="Web.company.column.column_piclist" %>

<%--<style>
     #cl_pic_list_loadmore a b
    {
        padding-left:20px;
     background: url(/images/tubiaoa.png) -90px -52px;
    }
    #cl_pic_list_loadmore a:hover b
    {
        background: url(/images/tubiaoa.png) -90px -80px;
    }
    #cl_pic_list_loadmore a:hover
    {
        background-color:#61c6f8;
    }
</style>--%>
<script type="text/javascript">
//栏目管理里的栏目列表。图标列表显示
    var pagetype;
    var myResult = "";
    $(function () {
        getJsonValue();
        pagetype = $("#column_picist_hid_type").val();//图形方式还是列表方式
        cl_list_pic_getdata();
        switchLanguage("#cl_pic_list_loadmore", 1, "column_piclist.aspx");
    })
    window.onload = function () {
        
    }
    function cl_list_pic_getdata() {
        //获取栏目记录。传入筛选方式
        var key = $("#cl_list_pic_qy_sn").val() + "|";
        key += $("#cl_list_pic_qy_un").val() + "|";
        key += $("#cl_list_pic_qy_cd").val() + "|";
        key += $("#cl_list_pic_qy_s").val() + "|";
        key += $("#cl_list_pic_qy_us").val() + "|";
        key += $("#cl_list_pic_qy_sr").val() + "|";
        key += $("#cl_list_pic_qy_isown").val() + "|";
        key += $("#cl_list_pic_qy_page").val() + "|";
        key += $("#cl_list_pic_qy_dr").val() + "|";
        key += $("#cl_list_pic_qy_group").val() + "|";
        key += $("#cl_list_pic_qy_isfiled").val();
        $.ajax({
            type: 'post',
            url: '/company/column/ajax/getlistdata.ashx',
            async: false,
            data: {
                t:pagetype,
                sd: $("#cl_list_pic_ds").val(),
                key: key,
                of: $("#cl_list_pic_of").val(),
                sort: $("#cl_list_pic_sort").val()
            },
            dataType: 'text',
            success: function (data) {
                var json = eval("(" + data + ")");
                cl_list_pic_show(json);
            }
        })
    }
    function cl_list_pic_show(json) {

        var i = 0;
        var isLine = json.UserInfo.split('a');
        var merits = isLine[1];
        isLine = isLine[0];
        $.each(json.Table, function (idx, item) {
            i++;
            //whq7.31
  
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
                    myCss = "filed"; myText = "归档"
                }
            }
            statushtm = statushtm.replace("css", myCss).replace("text", getLanguageMsg(myText, $.cookie("yuyan")));
            //var statushtm = '<div class="attr_icon approve"></div>';
            //if (item.checkstatus != 1) {
                
            //    statushtm = '<div class="attr_icon reflesh"></div>';
            //}
            if (merits <= item.merit || $("#arrangeIDs").val().indexOf(',' + item.itemid + ',') >= 0 || $("#arrangeIDs").val().indexOf('all') >= 0) {
                hasEdit = '<li>' + getLanguageMsg("栏目名：", $.cookie("yuyan")) + '<a href="/company/column/column_edit.aspx?id=' + item.itemid + '">' + item.itemname + '</a></li>';
            } else { hasEdit = '<li>' + getLanguageMsg("栏目名：", $.cookie("yuyan")) +  item.itemname + '</li>'; }
            $("#cl_list_pic_qy_lsid").val(item.itemid);
            $("#cl_pic_list").append('<div class="mod_sclist" data-itemid="' + item.itemid + '" '
            + 'data-itemname="' + item.itemname + '" '
            + 'data-thumb="' + item.thumbnail + '" '
            + 'data-contenttype="' + item.contenttype + '" '
            + 'data-itemtype="' + item.itemtype + '" '
            + '><div class="borbg"><div class="pic"><div class="thumb"><img src="/images/no_upload_2.jpg"  width="200" height="120" ></div>'
            + '<div class="lk clearfix"></div></div>'
            + '<div class="nr" title="ID : ' + item.itemid + '" ><ul>'
            + hasEdit
            + '<li>' + getLanguageMsg("更新时间：", $.cookie("yuyan")) + item.modifytime + '</li>'
            
            + '<li>' + getLanguageMsg("操作员：", $.cookie("yuyan")) + item.username + '</li>'
            + '<li>' + getLanguageMsg("描述：", $.cookie("yuyan")) + item.descript + '</li>'
            + '</ul></div></div>' + statushtm + "</div>");
            column_picist_showfirstsc(item.itemid);
            myResult = "0";
            cl_pic_list_operhtml(isLine,merits,item.merit, pagetype, item.isfiled, item.itemid, item.thumbnail, item.itemname, item.itemtype, item.contenttype, item.checkstatus);

        });
        $("a[name=addcolumnMenu]").die().live("click", function () {
           
            var itemid, itemname, contentype, sourceid, thumb, itemtype;
           // if ($("#cl_list_show").val() == "0") {
                itemid = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-itemid");
                itemname = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-itemname");
                contentype = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-contenttype");
                sourceid = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-sourceid");
                thumb = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-thumb");
                itemtype = $(this).parent(".fl").parent(".lk").parent(".pic").parent(".borbg").parent(".mod_sclist").attr("data-itemtype");
            //}
            //else {
            //    itemid = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-itemid");
            //    itemname = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-itemname");
            //    contentype = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-contentype");
            //    sourceid = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-sourceid");
            //    thumb = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-thumb");
            //    itemtype = $(this).parent(".btn").parent("td").parent("tr").children().eq(0).attr("data-itemtype");
            //}
            //if ($("#column_list_hid_type").val() == 4) {
                addsourcetoMenu(itemid, thumb, itemname, contentype, sourceid, itemtype);
            //}
        })
        if (i < 10) {
            $("#cl_pic_list_loadmore").fadeOut();
        }
      
    }
    function column_main_del(itemid) {
        showDeleteColumnTopTrip(itemid);
    }
    function cl_pic_list_operhtml(isLine, merits, ulevel, pagetype, isfiled, itemid, thumbnail, itemname, itemtype, contenttype, checkstatus) {
        //$.ajax({
        //    type: 'post',
        //    url: '/company/column/ajax/getOperateHtml.ashx',
        //    async: false,
        //    data: {
        //        pagetype: pagetype,
        //        ulevel: ulevel,
        //        isfiled: isfiled
        //    },aaaaa
        //    dataType: 'text',
        //    success: function (data) {
        //debugger;
        if (isLine=="1") {
            if (isfiled =="1") {
                if (pagetype == 0 || pagetype == 1) {
                    myResult = "0";
                }
                else if (pagetype == 2 || pagetype == 3) {
                    myResult = "0";
                }                
                else if (pagetype == 4) {
                    myResult = "1";
                }
            } else {
                if (pagetype == 0 || pagetype == 1) {
                    if (merits <= ulevel) {
                        myResult = "1";
                    }
                    else {
                        myResult = "0";
                    }
                }
                else if (pagetype == 2 || pagetype == 4) {
                    myResult = "1";
                }
                else if (pagetype == 3) {
                    if (merits <= ulevel) {
                        myResult = "1";
                    }
                    else {
                        myResult = "0";
                    }
                }
                
            }
        } else { myResult = "-1";}
                var html = "";
                if (myResult == "1") {
                    if (pagetype == 0) {//||pagetype==5
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () { 
                            window.location.href = "column_arrange.aspx?id=" + itemid + "&name=" + itemname + "&type=0";
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看引用路径", $.cookie("yuyan")) + '" style="width:20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;"></a></span><span class="fr"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="' + getLanguageMsg("编排栏目", $.cookie("yuyan")) + '" style="display:inline-block;height:20px;width:30px;background: url(/images/tubiaoa.png) -271px -52px;"></a><a href="javascript:void(0)" onclick="column_main_del(' + itemid + ')" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" style="display:inline-block;height:20px;width:20px;background: url(/images/tubiaoa.png) -245px -28px;"></a></span>').show();
                    }
                    if (pagetype == 1) {//栏目审核
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = "column_edit.aspx?id=" + itemid;
                            //loadColumnContent(7, itemid);//column_main.aspx
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><select data-itemid="' + itemid + '"  data-checkstatus=' + checkstatus + ' name="column_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span></span><span class="fr"><a href="javascript:void(0)" onclick="column_main_del(' + itemid + ')" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -245px -28px;"></a></span>').show();
                    }
                    if (pagetype == 2 || pagetype == 5) {//2编排、5添加栏目
                        //console.log("11111  "+224);
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看引用路径", $.cookie("yuyan")) + '" style="width:20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;;"></a></span>');
                        if ($("#checkIDs").val().indexOf('all') >= 0 && isfiled == "0") {//超级管理员  ，*--所有栏目
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><select data-itemid="' + itemid + '"  data-checkstatus=' + checkstatus + ' name="column_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                        } else if (merits <= ulevel && isfiled == "0" && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此栏目
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><select data-itemid="' + itemid + '"  data-checkstatus=' + checkstatus + ' name="column_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                        }
                        if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有栏目
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="' + getLanguageMsg("编排栏目", $.cookie("yuyan")) + '" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -52px;"></a></span>');
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                                window.location.href = 'column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0';
                            })
                        } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此栏目
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="' + getLanguageMsg("编排栏目", $.cookie("yuyan")) + '" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -52px;"></a></span>');
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                                window.location.href = 'column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0';
                            })
                        }
                        if (merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fr" style="padding-left: 2px;"><a href="javascript:void(0)" onclick="column_main_del(' + itemid + ')" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -245px -28px;"></a></span>');
                        }
                        
                       // $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径" style="width:20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;;"></a></span><span class="fr"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -52px;"></a></span>');
                    }
                    if (pagetype == 3) {
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = 'column_arrange.aspx?id=' + itemid + '&name=' + itemname+'&type=1';
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看引用路径", $.cookie("yuyan")) + '"  style="width: 20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;;"></a></span><span class="fr"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=1" title="' + getLanguageMsg("编排栏目审核", $.cookie("yuyan")) + '" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -270px -3px;"></a></span>');
                    }
                    if (pagetype == 4) {
                       
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" name="addcolumnMenu"><b style="padding-left:20px;background: url(/images/tubiao.png) -255px -124px;"></b>' + getLanguageMsg("添加到节目单", $.cookie("yuyan")) + '</a></span>');
                    }
                }
                if (myResult == "0") {
                    if (pagetype == 0) {//||pagetype==5
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            // window.location.href = "column_edit.aspx?id=" + itemid+"&sq=1";
                            window.location.href = "column_arrange.aspx?id=" + itemid + "&name=" + itemname + "&type=0";
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看引用路径", $.cookie("yuyan")) + '" style="width: 20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;;"></a></span><span class="fr"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="' + getLanguageMsg("编排栏目", $.cookie("yuyan")) + '" style="display:inline-block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -51px;"></a></span>').show();
                    }
                    if (pagetype == 1) {
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            window.location.href = "column_edit.aspx?id=" + itemid + "&sq=1";
                            //loadColumnContent(7, itemid, 1);//column_main.aspx
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><select data-itemid="' + itemid + '" disabled="disabled"  data-checkstatus=' + checkstatus + ' name="column_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>').show();
                    }
                    if (pagetype == 2 || pagetype == 5) {//优先级低，或者栏目归档； 不能审核、编排、删除
                        //console.log("0000000  "+275);
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            if (merits <= ulevel && $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0 || $("#arrangeIDs").val().indexOf('all') >= 0) {
                                window.location.href = "column_arrange.aspx?id=" + itemid + "&name=" + itemname + "&type=0";
                            } else { TopTrip('您无权限编排该栏目!', 2); }
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径" style="width: 20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;"></a></span>');
                        if (merits <= ulevel && isfiled == "0" && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//isfiled=="0"
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><select data-itemid="' + itemid + '"  data-checkstatus=' + checkstatus + ' name="column_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                        } else if ($("#arrangeIDs").val().indexOf('all') >= 0 && isfiled == "0") {
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><select data-itemid="' + itemid + '"  data-checkstatus=' + checkstatus + ' name="column_sel_status"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select></span>');
                        }
                        if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//$("#arrangeIDs").val().length <= 2
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -52px;"></a></span>');
                        } else if ($("#arrangeIDs").val().indexOf('all') >= 0) {
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fl"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -52px;"></a></span>');
                        }
                        if (merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                            $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").append('<span class="fr" style="padding-left: 2px;"><a href="javascript:void(0)" onclick="column_main_del(' + itemid + ')" title="删除" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -245px -28px;"></a></span>');
                        }
                        //$(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径" style="width: 20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;"></a></span><span class="fr"><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目" style="display:block;height:20px;width:20px;background: url(/images/tubiaoa.png) -271px -51px;"></a></span>');
                    }
                    if (pagetype == 3) {
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").bind("click", function () {
                            TopTrip('您无权限编排该栏目!', 2);
                        })
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径" style="width: 20px;height: 22px;display: block;background: url(/images/tubiaoa.png) -173px -54px;"></a></span>');
                    }
                    if (pagetype == 4) {
                        $(".mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".lk").html('<span class="fl"><a href="javascript:void(0)" name="addcolumnMenu"><b style="padding-left:20px;background: url(/images/tubiao.png) -255px -124px;"></b>' + getLanguageMsg("添加到节目单", $.cookie("yuyan")) + '</a></span>');
                    }
                }
                if (checkstatus != 1) {
                    $("select[name=column_sel_status][data-itemid=" + itemid + "]").val("0");
                }
                else {
                    $("select[name=column_sel_status][data-itemid=" + itemid + "]").val("1");
                }
            //}
        //})
    }
    function column_picist_showfirstsc(menuid) {
        //获取指定ID栏目中第一条记录（显示记录触发类型和状态）
        $.ajax({
            type: 'post',
            url: '/company/column/ajax/getmenufirstthumb.ashx',
            async: true,
            data: {
                id: menuid
            },
            dataType: 'text',
            success: function (data) {
          
                if (data != 0) {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        $("#cl_pic_list .mod_sclist[data-itemid=" + menuid + "]").attr("data-sourceid", item.itemid);
                        $("#cl_pic_list .mod_sclist[data-itemid=" + menuid + "]").attr("data-contenttype", item.contenttype);
                        if (item.Thumbnail != "" && item.Thumbnail!=null) {
                            myResult = item.Thumbnail;
                        } else {
                            myResult = "/images/img_new/default_" + item.contenttype + "_3.png";
                        }

                        $("#cl_pic_list .mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").html('<img src="' + myResult + '">');
                        $("#cl_pic_list .mod_sclist[data-itemid=" + menuid + "]").attr("data-thumb", item.Thumbnail);
                        //如果遇到图片错误则节目单缩略图使用类型图来代替
                        $(".mod_sclist[data-itemid=" + menuid + "]").children(".borbg").children(".pic").children(".thumb").children("img").error(function () {
                            $(this).attr('src', "/images/img_new/default_" + item.contenttype + "_3.png");
                        });
                        return false;
                    })
                }
            }
        })
    }
    function column_piclist_thumb(itemid, thumbnail, contenttype) {
        $.ajax({
            type: 'post',
            url: '/company/ajax/getthumbnnail.ashx',
            async: true,
            data: {
                imgname: thumbnail,
                st: 5,
                t: contenttype
            },
            dataType: 'text',
            success: function (data) {
                $("#cl_pic_list .mod_sclist[data-itemid=" + itemid + "]").children(".borbg").children(".pic").children(".thumb").html('<img src="' + data + '">');
                $("#cl_pic_list .mod_sclist[data-itemid=" + itemid + "]").attr("data-thumb", thumbnail);
            }
        })
    }
    function cl_list_pic_shownext() {
        $("#cl_list_pic_qy_page").val(parseInt($("#cl_list_pic_qy_page").val(), 10) + 1);
        cl_list_pic_getdata();
    }
    function loadColumnContent(nlink, editid, editname) {
        if (nlink == 0) {
            $("#column_web_link").text(getLanguageMsg("栏目列表", $.cookie("yuyan")));
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 0 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();

            });
        }
        else if (nlink == 1) {
            $("#column_web_link").text(getLanguageMsg("栏目列表", $.cookie("yuyan")));
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 1 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 2) {
            $("#column_web_link").text(getLanguageMsg("栏目列表", $.cookie("yuyan")));
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 2 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 3) {
            $("#column_web_link").text(getLanguageMsg("栏目编排", $.cookie("yuyan")));
            $("#div_column_arrange").load("column/column_arrange.aspx", { "id": editid, "name": editname }, function () {
                $("#div_column_arrange").fadeIn();
                $("#div_column_list").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 4) {
            $("#column_web_link").text(getLanguageMsg("编排审核", $.cookie("yuyan")));
            $("#div_column_arrange").load("column/column_review.aspx", { "id": editid, "name": editname }, function () {
                $("#div_column_arrange").fadeIn();
                $("#div_column_list").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
        else if (nlink == 5) {
            $("#column_web_link").text(getLanguageMsg("栏目引用记录", $.cookie("yuyan")));
            $("#div_column_quote").load("column/column_quote.aspx", { "id": editid, "name": editname }, function () {
                $("#overlay").fadeIn();
                $("#div_column_quote").fadeIn();
            });
        }
        else if (nlink == 6) {
            $("#column_web_link").text(getLanguageMsg("添加栏目", $.cookie("yuyan")));
            if (typeof (editid) != "undefined") {
                $("#div_column_add").load("column/column_add.aspx", { "id": editid }, function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                    $("#div_column_quote").fadeOut();
                });
            }
            else {
                $("#div_column_add").load("column/column_add.aspx", function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                });
            }
        }
        else if (nlink == 7) {
            if (typeof (editname) != "undefined") {
                $("#column_web_link").text(getLanguageMsg("编辑栏目", $.cookie("yuyan")));
                $("#div_column_add").load("column/column_edit.aspx", { "id": editid, "sq": editname }, function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                    $("#div_column_quote").fadeOut();
                });
            }
            else {
                $("#column_web_link").text(getLanguageMsg("编辑栏目", $.cookie("yuyan")));
                $("#div_column_add").load("column/column_edit.aspx", { "id": editid }, function () {
                    $("#div_column_add").fadeIn();
                    $("#div_column_list").fadeOut();
                    $("#div_column_arrange").fadeOut();
                    $("#div_column_quote").fadeOut();
                });
            }
        }
        else if (nlink == 8) {
            $("#column_web_link").text(getLanguageMsg("栏目列表", $.cookie("yuyan")));
            ClearColumnListHtml();
            $("#div_column_list").load("column/column_list.aspx", { "t": 3 }, function () {
                $("#div_column_list").fadeIn();
                $("#div_column_arrange").fadeOut();
                $("#div_column_add").fadeOut();
                $("#div_column_quote").fadeOut();
            });
        }
    }
</script>
<input type="hidden" id="column_picist_hid_type" runat="server" />
<!--数据来源：0：数据库；1：cookie---------->
<input type="hidden" id="cl_list_pic_ds" runat="server" value="0" />
<!--排序字段 0:id,1:推荐指数，2：栏目名称，3：文件类型,4:操作员，5：状态，6：创建时间---------->
<input type="hidden" id="cl_list_pic_of" runat="server" value="0" />
<!--排序方式：0：倒叙；1：使用推荐正序---------->
<input type="hidden" id="cl_list_pic_sort" runat="server" value="0" />
<!--查询条件：上次加载的最小ID（为空时第一次加载）---------->
<input type="hidden" id="cl_list_pic_qy_page" runat="server" value="1" />
<!--查询条件：是否只查询自己的（0：查询所有的；1：只查询自己的）---------->
<input type="hidden" id="cl_list_pic_qy_isown" runat="server" value="0" />
<!--查询条件：素材名查询（为空时全部）---------->
<input type="hidden" id="cl_list_pic_qy_sn" runat="server" value="" />
<!--查询条件：用户名查询---------->
<input type="hidden" id="cl_list_pic_qy_un" runat="server" value="" />
<!--查询条件：创建日期查询（为空时全部）---------->
<input type="hidden" id="cl_list_pic_qy_cd" runat="server" value="" />
<!--查询条件：审核状态查询（为空时全部）---------->
<input type="hidden" id="cl_list_pic_qy_s" runat="server" value="" />
<!--查询条件：调用状态查询（为空时全部）---------->
<input type="hidden" id="cl_list_pic_qy_us" runat="server" value="" />
<!--查询条件：分辨率查询（为空时全部）（多选','分割）---------->
<input type="hidden" id="cl_list_pic_qy_sr" runat="server" value="" />
<!--查询条件：时间范围查询---------->
<input type="hidden" id="cl_list_pic_qy_dr" runat="server" value="" />
<!--查询条件：是否归档----------------------->
<input type="hidden" id="cl_list_pic_qy_isfiled" runat="server" value="" />
<!--查询条件：分组查询---->
<input type="hidden" id="cl_list_pic_qy_group" runat="server" value="" />
<div class="sc_pic_list clearfix" id="cl_pic_list"></div>
<div class="loading_more" id="cl_pic_list_loadmore"><a href="javascript:void(0)" onclick="cl_list_pic_shownext()"><b></b><span class="language">加载更多</span></a></div>


