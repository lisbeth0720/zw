<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_tablist.aspx.cs" Inherits="Web.company.program.program_tablist" %>

<script type="text/javascript">
    var pagetype;
    $(function () {
        pagetype = $("#program_tabist_hid_type").val();
        program_list_tab_getdata();
        var w = document.documentElement.clientWidth;
       // $("#programDiv").css("left", (w - 220) + "px");
        window.onresize = function () {
            var w = document.documentElement.clientWidth;
            //$("#programDiv").css("left", (w - 220) + "px");
        }
        $("#programDiv").css("display", "block");
        debugger;
        
        switchLanguage(".sc_result", 1, "program_tablelist.aspx");
      
        
    })
    function program_list_tab_getdata() {
        var key = $("#program_list_tab_qy_sn").val() + "|";
        key += $("#program_list_tab_qy_un").val() + "|";
        key += $("#program_list_tab_qy_cd").val() + "|";
        key += $("#program_list_tab_qy_s").val() + "|";
        key += $("#program_list_tab_qy_us").val() + "|";
        key += $("#program_list_tab_qy_sr").val() + "|";
        key += $("#program_list_tab_qy_isown").val() + "|";
        key += $("#program_list_tab_qy_page").val() + "|";
        key += $("#program_list_tab_qy_dr").val() + "|";
        key += $("#program_list_tab_qy_group").val() + "|";
        key += $("#program_list_tab_qy_isfiled").val();
        $.ajax({
            type: 'post',
            url: '/company/program/ajax/getlistdata.ashx',
            async: true,
            data: {
                t: pagetype,
                sd: $("#program_list_tab_ds").val(),
                key: key,
                of: $("#program_list_tab_of").val(),
                sort: $("#program_list_tab_sort").val()
            },
            dataType: 'text',
            success: function (data) {
                var json = eval("(" + data + ")");
                program_list_tab_show(json);
            }
        })
    }
    function program_list_tab_show(json) {
        var i = 0;
        var hasEdit = "";
        var isLine = json.UserInfo.split('a');
        var merits = isLine[1];
        isLine = isLine[0];
        $.each(json.Table, function (idx, item) {
            i++;
            if (merits <= item.merit || $("#arrangeIDs").val().indexOf(',' + item.itemid + ',') >= 0 || $("#arrangeIDs").val().indexOf('all') >= 0) {
                hasEdit = '<a href="/company/program/program_edit.aspx?id=' + item.itemid + '">' + item.itemname + '</a>';
            } else { hasEdit = item.itemname; }
            $("#program_tab_list").append('<tr data-itemid="' + item.itemid + '" data-itemname="' + item.itemname + '" data-checkstatus="' + item.checkstatus + '" data-status=' + item.status + '><td width="80">' + item.itemid + '</td>'  //<input name="program_tab_list_check" value="' + item.itemid + '" type="checkbox">
                  + '<td width="140">' + hasEdit + '</td>'
                  + '<td width="90">' + item.framesizex + '</td>'
                  + '<td width="90">' + item.framesizey + '</td>'
                  + '<td width="100" data-type="check' + item.itemid + '"></td>'//<select disabled="disabled" name="program_sel_status" data-itemid="'+item.itemid+'"><option value="0">未通过</option><option value="1">已通过</option></select>
                  + '<td width="125" data-type="oper' + item.itemid + '"></td></tr>'
                  );
            pro_tab_List_operHtml(merits,item.merit, pagetype, item.isfiled, item.itemid, item.thumbnail, item.itemname, item.itemtype, item.contenttype, item.checkstatus)
            
        });
        if (i < 8) {
            $("#program_pic_list_loadmore").fadeOut();
        }

    }
    function pro_tab_List_operHtml(merits,ulevel, pagetype, isfiled, itemid, thumbnail, itemname, itemtype, contenttype, checkstatus) {
        $.ajax({
            type: 'post',
            url: 'ajax/getOperateHtml.ashx',
            async: false,
            data: {
                pagetype: pagetype,
                ulevel: ulevel,
                isfiled: isfiled
            },
            dataType: 'text',
            success: function (data) {
                var statushtml = "";
                var operatehtml = "";
                var isMyFiled = '<a href="javascript:void(0)" title="' + getLanguageMsg("归档", $.cookie("yuyan")) + '"><img src="/images/icon_filed.png" onclick="filedProgram(' + itemid + ')" alt="' + getLanguageMsg("归档", $.cookie("yuyan")) + '"></a>';
                if (checkstatus == "1") {
                    $("#program_tab_list td[data-type=check" + itemid + "]").html(getLanguageMsg("通过", $.cookie("yuyan")));
                } else {
                    $("#program_tab_list td[data-type=check" + itemid + "]").html(getLanguageMsg("未通过", $.cookie("yuyan")));
                }
                if (data == 1) {//8.15‘已通过’的节目单 才能归档
                    if (pagetype == 0) {// || pagetype == 5
                        operatehtml = 'isfile<a href="/company/program/program_edit.aspx?id=' + itemid + '" title="' + getLanguageMsg("编辑", $.cookie("yuyan")) + '"><img src="/images/icon_edit.png" alt="' + getLanguageMsg("编辑节目单", $.cookie("yuyan")) + '"></a><a href="javascript:void(0)" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" onclick="showDeleteProgramTopTrip(' + itemid + ')"><img src="/images/icon_delete.png" alt="' + getLanguageMsg("删除节目单", $.cookie("yuyan")) + '"></a>';
                    }
                    if (pagetype == 1) {//节目单审核
                        //$("#program_tab_list td[data-type=check" + itemid + "]").children("select").removeAttr("disabled");
                        //<select disabled="disabled" name="program_sel_status" data-itemid="'+itemid+'"><option value="0">未通过</option><option value="1">已通过</option></select>
                        $("#program_tab_list td[data-type=check" + itemid + "]").html('<select name="program_sel_status" data-itemid="' + itemid + '"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select>');
                        operatehtml = 'isfile<a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"><img src="/images/icon_look.png" alt="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"></a>';
                    }
                    if (pagetype == 2 || pagetype == 5) {
                        //operatehtml = '<a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="节目单编排"><img src="/images/icon_edit_add.png" alt="节目单编排"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="查看播放终端"><img src="/images/icon_look.png" alt="查看播放终端"></a>';
                        operatehtml = '<a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"><img src="/images/icon_look.png" alt="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"></a>';
                        //if (checkstatus == 1 && merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                        //    operatehtml += '<a href="javascript:void(0)" title="归档"><img src="/images/icon_filed.png" onclick="filedProgram('+itemid+')" alt="归档"></a>';
                        //}
                        //if ($("#checkIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                        //    operatehtml += '<select name="program_sel_status" data-itemid="' + itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
                        //} else if (merits <= ulevel && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此节目单
                        //    operatehtml += '<select name="program_sel_status" data-itemid="' + itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
                        //}
                        if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                            operatehtml += '<a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"><img src="/images/icon_edit_add.png" alt="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"></a>';
                            
                        } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此节目单
                            operatehtml += '<a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"><img src="/images/icon_edit_add.png" alt="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"></a>';
                        }
                        if (checkstatus == 1 && merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                            operatehtml += '<a href="javascript:void(0)" title="' + getLanguageMsg("归档", $.cookie("yuyan")) + '"><img src="/images/icon_filed.png" onclick="filedProgram(' + itemid + ')" alt="' + getLanguageMsg("归档", $.cookie("yuyan")) + '"></a>';
                        }
                        if (merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                            operatehtml += '<a href="javascript:void(0)" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" onclick="showDeleteProgramTopTrip(' + itemid + ')"><img src="/images/icon_delete.png" alt="' + getLanguageMsg("删除节目单", $.cookie("yuyan")) + '"></a>';
                        }
                    }
                    if (pagetype == 3) {
                        operatehtml = '<a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=1" title="' + getLanguageMsg("节目单编排审核", $.cookie("yuyan")) + '"><img src="/images/icon_edit_add.png" alt="' + getLanguageMsg("节目单编排审核", $.cookie("yuyan")) + '"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"><img src="/images/icon_look.png" alt="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"></a>';
                    }
                    if (pagetype == 4) {
                        operatehtml = '<a href="javascript:void(0)" onclick="clientmenu_add(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '"><img src="/images/icoc_sel.png" alt="' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '"></a>';
                    }
                }
                if (data == 0) {//8.15‘已通过’的节目单 才能归档
                    if (pagetype == 0) {// || pagetype == 5
                        operatehtml = 'isfile<a href="/company/program/program_edit.aspx?filed=1&id=' + itemid + '" title="' + getLanguageMsg("编辑", $.cookie("yuyan")) + '"><img src="/images/icon_edit.png" alt="' + getLanguageMsg("编辑栏目", $.cookie("yuyan")) + '" ></a><a href="javascript:void(0)" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" onclick="TopTrip(\'' + getLanguageMsg("您无权限删除！", $.cookie("yuyan")) + '\',2)"><img src="/images/icon_delete.png" alt="' + getLanguageMsg("删除栏目", $.cookie("yuyan")) + '"></a>';
                    }
                    if (pagetype == 1) {
                        operatehtml = 'isfile<a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"><img src="/images/icon_look.png" alt="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"></a>';
                    }
                    if (pagetype == 2 || pagetype == 5) {
                        //operatehtml = '<a href="javascript:void(0)" onclick="TopTrip(\'您无权限编排或该节目单已归档！\',2)" title="节目单编排"><img src="/images/icon_edit_add.png" alt="节目单编排"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="查看播放终端"><img src="/images/icon_look.png" alt="查看播放终端"></a>';
                        operatehtml = '<a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"><img src="/images/icon_look.png" alt="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"></a>';
                     
                        
                            if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                                operatehtml += '<a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"><img src="/images/icon_edit_add.png" alt="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"></a>';
                            
                            } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此节目单
                                operatehtml += '<a href="/company/program/program_arrange.aspx?id=' + itemid + '&type=0" title="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"><img src="/images/icon_edit_add.png" alt="' + getLanguageMsg("节目单编排", $.cookie("yuyan")) + '"></a>';
                            }
                            if (checkstatus == 1 && merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                                operatehtml += '<a href="javascript:void(0)" title="' + getLanguageMsg("归档", $.cookie("yuyan")) + '"><img src="/images/icon_filed.png" onclick="filedProgram(' + itemid + ')" alt="' + getLanguageMsg("归档", $.cookie("yuyan")) + '"></a>';
                            }
                            if (merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                                operatehtml += '<a href="javascript:void(0)" title="' + getLanguageMsg("删除", $.cookie("yuyan")) + '" onclick="showDeleteProgramTopTrip(' + itemid + ')"><img src="/images/icon_delete.png" alt="' + getLanguageMsg("删除节目单", $.cookie("yuyan")) + '"></a>';
                            }



                    }
                    if (pagetype == 3) {
                        operatehtml = '<a href="javascript:void(0)" onclick="TopTrip(\'' + getLanguageMsg("您无权限审核或该节目单已归档！", $.cookie("yuyan")) + '\',2)" title="' + getLanguageMsg("节目单编排审核", $.cookie("yuyan")) + '"><img src="/images/icon_edit_add.png" alt="' + getLanguageMsg("节目单编排审核", $.cookie("yuyan")) + '"><a href="javascript:void(0)" onclick="showProgramQuote(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"><img src="/images/icon_look.png" alt="' + getLanguageMsg("查看播放终端", $.cookie("yuyan")) + '"></a>';
                    }
                    if (pagetype == 4) {
                        operatehtml = '<a href="javascript:void(0)" onclick="clientmenu_add(' + itemid + ',\'' + itemname + '\')" title="' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '"><img src="/images/icoc_sel.png" alt="' + getLanguageMsg("添加到终端", $.cookie("yuyan")) + '"></a>';
                    }
                }

                //if ($("#checkIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有节目单
                //    operatehtml += '<select name="program_sel_status" data-itemid="' + itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
                //} else if (merits <= ulevel && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此节目单
                //    operatehtml += '<select name="program_sel_status" data-itemid="' + itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
                //}
                
                
                if (pagetype == 2 || pagetype == 5) {
                    var hasCheck = '<select name="program_sel_status" data-itemid="' + itemid + '"><option value="0">' + getLanguageMsg("未通过", $.cookie("yuyan")) + '</option><option value="1">' + getLanguageMsg("已通过", $.cookie("yuyan")) + '</option></select>';
                    
                    if ($("#checkIDs").val().indexOf('all') >= 0 && isfiled=="0") {//超级管理员  ，*--所有节目单
                        $("#program_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(hasCheck);
                    } else if (merits <= ulevel && isfiled == "0" && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此节目单
                        $("#program_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(hasCheck);
                    } else {
                        if (checkstatus == "0") {
                            $("#program_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(getLanguageMsg("待审核", $.cookie("yuyan")));
                        } else if (checkstatus == "1") {
                            $("#program_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(getLanguageMsg("已通过", $.cookie("yuyan")));
                        } else {
                            $("#program_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(getLanguageMsg("未通过", $.cookie("yuyan")));
                        }
                    }
                    //if (checkstatus == 1 && merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                    //    operatehtml += '<a href="javascript:void(0)" title="归档"><img src="/images/icon_filed.png" onclick="filedProgram(' + itemid + ')" alt="归档"></a>';
                    //}
                    //console.log("shenhe..."+checkstatus);
                    if (checkstatus!="1") {//未通过                  
                        $("select[name=program_sel_status][data-itemid=" + itemid + "]").val("0");                       
                    }
                    else {                        
                        $("select[name=program_sel_status][data-itemid=" + itemid + "]").val("1");

                    }
                } else {
                    if (checkstatus != 1) {//未通过                  
                        $("select[name=program_sel_status][data-itemid=" + itemid + "]").val("0");
                        operatehtml = operatehtml.replace("isfile", "");
                    }
                    else {
                        //8.15‘已通过’的节目单 才能归档
                        $("select[name=program_sel_status][data-itemid=" + itemid + "]").val("1");
                        operatehtml = operatehtml.replace("isfile", isMyFiled);//显示归档，
                    }
                }
                $("#program_tab_list td[data-type=oper" + itemid + "]").html(operatehtml);
            }
        })
    }
    function program_list_tab_shownext() {
        $("#program_list_tab_qy_page").val(parseInt($("#program_list_tab_qy_page").val(), 10) + 1);
        program_list_tab_getdata();
    }
    showTypeRecord("jiemudan");
    $(".slideBarItem").mouseover(function () {
        $("#programDiv").animate({ right: "0px" });
    })
    $("#programDiv").mouseleave(function () {
        $("#programDiv").animate({ right: "-200px" });
    })
</script>
<input type="hidden" id="program_tabist_hid_type" runat="server" />
<!--数据来源：0：数据库；1：cookie---------->
<input type="hidden" id="program_list_tab_ds" runat="server" value="0" />
<!--排序字段 0:id,1:推荐指数，2：素材名称，3：文件类型,4:操作员，5：状态，6：创建时间---------->
<input type="hidden" id="program_list_tab_of" runat="server" value="0" />
<!--排序方式：0：倒叙；1：使用推荐正序---------->
<input type="hidden" id="program_list_tab_sort" runat="server" value="0" />
<!--查询条件：上次加载的最小ID（为空时第一次加载）---------->
<input type="hidden" id="program_list_tab_qy_page" runat="server" value="1" />
<!--查询条件：是否只查询自己的（0：查询所有的；1：只查询自己的）---------->
<input type="hidden" id="program_list_tab_qy_isown" runat="server" value="0" />
<!--查询条件：节目单名查询（为空时全部）---------->
<input type="hidden" id="program_list_tab_qy_sn" runat="server" value="" />
<!--查询条件：用户名查询---------->
<input type="hidden" id="program_list_tab_qy_un" runat="server" value="" />
<!--查询条件：创建日期查询（为空时全部）---------->
<input type="hidden" id="program_list_tab_qy_cd" runat="server" value="" />
<!--查询条件：审核状态查询（为空时全部）---------->
<input type="hidden" id="program_list_tab_qy_s" runat="server" value="" />
<!--查询条件：调用状态查询（为空时全部）---------->
<input type="hidden" id="program_list_tab_qy_us" runat="server" value="" />
<!--查询条件：分辨率查询（为空时全部）（多选','分割）---------->
<input type="hidden" id="program_list_tab_qy_sr" runat="server" value="" />
<!--查询条件：时间范围查询---------->
<input type="hidden" id="program_list_tab_qy_dr" runat="server" value="" />
<!--查询条件：类型查询（为空时全部）---------->
<input type="hidden" id="program_list_tab_qy_isfiled" runat="server" value="" />
<!--查询条件：分组查询---->
<input type="hidden" id="program_list_tab_qy_group" runat="server" value="" />

<div class="slideBarItem">
    <img src="/images/slideTwig.png">
</div>
<div id="programDiv">
   <div class="lastcolumn commonStyle">
        <p><span class="language">最近栏目</span></p>
        <div class="lastcolumnList ">
        </div>
    </div>
    <div class="lastSource commonStyle" >
        <p><span class="language">最近素材</span></p>
        <div class="lastSourceList ">
        </div>
    </div>
    <div class="lastClient">
        <p><span class="language">最近终端</span></p>
        <div class="lastClientList">
        </div>
    </div>
</div>
<div class="sc_result">
    <table class="tab_sc_list" id="program_tab_list_top">
        <tbody>
            <tr>
                <th width="80" issort="1" data-of="0" class="language">
                   <%-- <input name="allchecked_out" id="allchecked_out" type="checkbox" value="">--%>
                    序号<!--<span>↑</span>-->
                </th>
                <th width="140" issort="1" data-of="2"><span class="language">节目单名称</span><span></span></th>
                <th width="90" class="language">宽度</th>
                <th width="90" class="language">高度</th>
                <th width="100" issort="1" data-of="5"><span class="language">状态</span><span></span></th>
                <th width="125" class="language">操作</th>
            </tr>
        </tbody>
    </table>
    <table class="tab_sc_list" id="program_tab_list">
    </table>
    <div class="loading_more" id="program_tab_list_loadmore"><a href="javascript:void(0)" onclick="program_list_tab_shownext()"><b></b><span class="language">加载更多</span></a></div>
</div>
<script>
    $(function () {
        function Checked() {
            var ch = document.getElementsByName("program_tab_list_check");
            
            if (document.getElementsByName("allchecked_out")[0].checked) {
                for (var i = 0; i < ch.length; i++) {
                    ch[i].checked = true;
                }
            } else {
                for (var i = 0; i < ch.length; i++) {
                    ch[i].checked = false;
                }
            }
        }
        $("#allchecked_out").click(function () {
            Checked()
        });

        //结束
    })
</script>

