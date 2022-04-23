<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_tablist.aspx.cs" Inherits="Web.company.column.column_tablist" %>

<script type="text/javascript">
    var pagetype;
    var tabResult = "";
    $(function () {
        pagetype = $("#column_tablist_hid_type").val();
        $("#cl_tab_list_top th[issort=1]").css("cursor", "pointer");
        cl_list_tab_getdata();
        var w = document.documentElement.clientWidth;
       // $("#columnDiv").css("left", (w - 220) + "px");
        window.onresize = function () {
          //  var w = document.documentElement.clientWidth;
            //$("#columnDiv").css("left", (w - 220) + "px");
        }
        $("#columnDiv").css("display", "block");
       
    })
    function cl_list_tab_getdata() {

        var key = $("#cl_list_tab_qy_sn").val() + "|";
        key += $("#cl_list_tab_qy_un").val() + "|";
        key += $("#cl_list_tab_qy_cd").val() + "|";
        key += $("#cl_list_tab_qy_s").val() + "|";
        key += $("#cl_list_tab_qy_us").val() + "|";
        key += $("#cl_list_tab_qy_sr").val() + "|";
        key += $("#cl_list_tab_qy_isown").val() + "|";
        key += $("#cl_list_tab_qy_page").val() + "|";
        key += $("#cl_list_tab_qy_dr").val() + "|";
        key += $("#cl_list_tab_qy_group").val() + "|";
        key += $("#cl_list_tab_qy_isfiled").val();
        $.ajax({
            type: 'post',
            url: '/company/column/ajax/getlistdata.ashx',
            async: true,
            data: {
                t: pagetype,
                sd: $("#cl_list_tab_ds").val(),
                key: key,
                of: $("#cl_list_tab_of").val(),
                sort: $("#cl_list_tab_sort").val()
            },
            dataType: 'text',
            success: function (data) {
                var json = eval("(" + data + ")");
                cl_list_tab_show(json);
            }
        })
    }
    function cl_list_tab_show(json) {
        var hasEdit = "";
        var hasCheck = "";
        var i = 0;
        var isLine = json.UserInfo.split('a');
        var merits = isLine[1];
        isLine = isLine[0];
        $.each(json.Table, function (idx, item) {
            i++;
            if (merits <= item.merit || $("#arrangeIDs").val().indexOf(',' + item.itemid + ',') >= 0 || $("#arrangeIDs").val().indexOf('all') >= 0) {
                hasEdit = '<a href="/company/column/column_edit.aspx?id=' + item.itemid + '">' + item.itemname + '</a>';
            } else { hasEdit = item.itemname; }

           
            $("#cl_tab_list").append('<tr data-itemid="' + item.itemid + '" data-checkstatus="' + item.checkstatus + '" data-status=' + item.status + ' data-itemid="' + item.itemid + '"  data-thumb="' + item.thumbnail + '" data-itemtype="' + item.itemtype + '" data-itemname="' + item.itemname + '" data-contentype="' + item.contenttype + '">'
                + '<td width="80">' + item.itemid + '</td>'    //<input name="cl_tab_list_check" value="' + item.itemid + '" type="checkbox">
                + '<td width="140">' + hasEdit + '</td>'
                + '<td width="90">' + item.framesizex + '</td>'
                + '<td width="90">' + item.framesizey + '</td>'
                + '<td width="100">' + '</td>'
                + '<td width="125" data-type="oper' + item.itemid + '"></td></tr>'
                );
            column_tabist_showfirstsc(item.itemid);
            tabResult = "0";
            cl_tab_list_operhtml(isLine, merits, item.merit, pagetype, item.isfiled, item.itemid, item.thumbnail, item.itemname, item.itemtype, item.contenttype, item.checkstatus)
        });
        if (i < 8) {
            $("#cl_tab_list_loadmore").fadeOut();
        }

    }
    function cl_tab_list_operhtml(isLine, merits, ulevel, pagetype, isfiled, itemid, thumbnail, itemname, itemtype, contenttype, checkstatus) {
        //$.ajax({
        //    type: 'post',
        //    url: '/company/column/ajax/getOperateHtml.ashx',
        //    async: false,
        //    data: {
        //        pagetype: pagetype,
        //        ulevel: ulevel,
        //        isfiled: isfiled
        //    },
        //    dataType: 'text',
        //    success: function (data) {
        
        if (isLine == "1") {
            if (isfiled == "1") {
                if (pagetype == 0 || pagetype == 1) {
                    tabResult = "0";
                }
                else if (pagetype == 2 || pagetype == 3) {
                    tabResult = "0";
                }
                else if (pagetype == 4) {
                    tabResult = "1";
                }
            } else {//pagetype == 5   添加，编辑栏目时： 可以删除
                if (pagetype == 0 || pagetype == 1 || pagetype == 5) {
                    if (merits <= ulevel) {
                        tabResult = "1";
                    }
                    else {
                        tabResult = "0";
                    }
                }
                else if (pagetype == 2 || pagetype == 4) {
                    tabResult = "1";
                }
                else if (pagetype == 3) {
                    if (merits <= ulevel) {
                        tabResult = "1";
                    }
                    else {
                        tabResult = "0";
                    }
                }

            }
        } else
        { tabResult = "-1"; }
        
        var html = "";
        var isMyFiled = '<a href="javascript:void(0)" onclick="filedColumn(' + itemid + ')" title=\"归档\"><img src="/images/icon_filed.png"  alt="归档"></a>';
        if (tabResult == "1") {//8.15‘已通过’的栏目 才能归档
            if (pagetype == 0) {// || pagetype == 5
                html = '<a href="javascript:void(0)"  title=\"查看引用路径\" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')"><img src="/images/icon_look.png" alt="查看引用路径"></a>isfile<a href=\"column_edit.aspx?id=' + itemid + '\" title=\"编辑\"><img src=\"/images/icon_edit.png\" title=\"编辑栏目\"></a><a href=\"javascript:void(0)\" title="删除" onclick="showDeleteColumnTopTrip(' + itemid + ')"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
            }
            if (pagetype == 1) {
                html = '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a>isfile<a href=\"javascript:void(0)\" onclick="showDeleteColumnTopTrip(' + itemid + ')" title="删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
            }
            if (pagetype == 2 || pagetype == 5) {
                html += '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a>';
                if (checkstatus == 1 && merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                    html += '<a href="javascript:void(0)" onclick="filedColumn(1600)" title="归档"><img src="/images/icon_filed.png" alt="归档"></a>';
                }
                if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有栏目
                    html += '<a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目"><img src="/images/icon_edit_add.png" alt="编排栏目"></a><a href=\"javascript:void(0)\" onclick="showDeleteColumnTopTrip(' + itemid + ')" title="删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
                    
                } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此栏目
                    html += '<a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目"><img src="/images/icon_edit_add.png" alt="编排栏目"></a><a href=\"javascript:void(0)\" onclick="showDeleteColumnTopTrip(' + itemid + ')" title="删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';                    
                }
                
                //html += '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目"><img src="/images/icon_edit_add.png" alt="编排栏目"></a>isfile<a href=\"javascript:void(0)\" onclick="showDeleteColumnTopTrip(' + itemid + ')" title="删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
            }
            if (pagetype == 3) {
                html += '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a><a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=1" title="编排审核栏目"><img src="/images/icon_edit_add.png" alt="编排审核栏目"></a>';
            }
            if (pagetype == 4) {
                html = '<a href="javascript:void(0)"  name="addcolumnMenu"><img src="/images/icoc_sel.png" alt="选择栏目"></a>';
            }
        }
        if (tabResult == "0") {//8.15‘已通过’的栏目 才能归档
            if (pagetype == 0) {// || pagetype == 5
                html = '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a>isfile<a href=\"column_edit.aspx?id=' + itemid + '&sq=1\" title="编辑栏目"><img src=\"/images/icon_edit.png\"  title=\"编辑栏目\"></a><a href=\"javascript:void(0)\" onclick="TopTrip(\'您无权删除该栏目\',2)" title="无权删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
            }
            if (pagetype == 1) {
                html = '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a>isfile<a href=\"javascript:void(0)\" onclick="TopTrip(\'您无权删除该栏目\',2)><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
            }
            if (pagetype == 2 || pagetype == 5) {
                //html += '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a><a href="javascript:void(0)" title="无权编排" onclick="TopTrip(\'您无权编排该栏目\',2)"><img src="/images/icon_edit_add.png" alt="编排栏目"></a>';
                html += '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a>';
                if (checkstatus == 1 && merits <= ulevel && isfiled == "0") {//优先级高于等于 素材创建者。并且未归档
                    html += '<a href="javascript:void(0)" onclick="filedColumn(1600)" title="归档"><img src="/images/icon_filed.png" alt="归档"></a>';
                }
                if ($("#arrangeIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有栏目
                    html += '<a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目"><img src="/images/icon_edit_add.png" alt="编排栏目"></a><a href=\"javascript:void(0)\" onclick="showDeleteColumnTopTrip(' + itemid + ')" title="删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';

                } else if (merits <= ulevel || $("#arrangeIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以编排 此栏目
                    html += '<a href="column_arrange.aspx?id=' + itemid + '&name=' + itemname + '&type=0" title="编排栏目"><img src="/images/icon_edit_add.png" alt="编排栏目"></a><a href=\"javascript:void(0)\" onclick="showDeleteColumnTopTrip(' + itemid + ')" title="删除"><img src=\"/images/icon_delete.png\" alt=\"删除栏目\"></a>';
                }
            }
            if (pagetype == 3) {
                html += '<a href="javascript:void(0)" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')" title="查看引用路径"><img src="/images/icon_look.png" alt="查看引用路径"></a><a href="javascript:void(0)" title="无权编排" onclick="TopTrip(\'您无权编排该栏目\',2)"><img src="/images/icon_edit_add.png" alt="编排审核栏目"></a>';
            }
            if (pagetype == 4) {
                html = '<a href="javascript:void(0)"  name="addcolumnMenu" title="选择栏目"><img src="/images/icoc_sel.png" alt="选择栏目"></a>';
            }
        }
        //if (checkstatus == 1 && isfiled=="0" && merits<=ulevel) {//8.15‘已通过’的栏目、 （优先级判断）才能归档
        //    html = html.replace("isfile", isMyFiled);//显示归档，
        //} else {
        //    html = html.replace("isfile", "");
        //}
        $("#cl_tab_list td[data-type=oper" + itemid + "]").html(html);
        //cl_tab_checkstatus(pagetype, ulevel, isfiled, itemid);
        if (isLine == "1") {
            if (isfiled=="1") {
                tabResult = "0";
            } else {
                if (pagetype == 1) {
                    if (merits <= ulevel) {
                        tabResult = "1";
                    }
                    else {
                        tabResult = "0";
                    }
                }
                else {
                    tabResult = "0";
                }
            }
        } else { tabResult = "-1"; }
        if (pagetype == 2 || pagetype == 5) {//5添加栏目
            var checkstatuss = "";
            var hasCheck = '<select name="column_sel_status" data-itemid="' + itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
           
                    //$("#cl_tab_list tr[data-itemid="+itemid+"] td:eq(4)").html() //审核状态
                    if ($("#checkIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有栏目
                        $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(hasCheck);
                        //$("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(5)").append('<a href="javascript:void(0)"  title=\"查看引用路径\" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')"><img src="/images/icon_look.png" alt="查看引用路径"></a>');
                    } else if (merits <= ulevel && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此栏目
                        $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html(hasCheck);
                       // $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(5)").append('<a href="javascript:void(0)"  title=\"查看引用路径\" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')"><img src="/images/icon_look.png" alt="查看引用路径"></a>');
                    } else {
                        if (checkstatus == "0") {
                            $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html("待审核");
                        } else if (checkstatus == "1") {
                            $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html("已通过");
                        } else {
                            $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html("未通过");
                        }                         
                    }
                    if (checkstatus != "1") {
                        $("select[name=column_sel_status][data-itemid=" + itemid + "]").val("0");
                    }
                    else {
                        $("select[name=column_sel_status][data-itemid=" + itemid + "]").val("1");
                    }
            // $("#cl_tab_list tr[data-itemid="+itemid+"] td:eq(5)").html()  //操作按钮  
                   
          
        } else {
           // $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(5)").append('<a href="javascript:void(0)"  title=\"查看引用路径\" onclick="loadColumnQuote(' + itemid + ',\'' + itemname + '\')"><img src="/images/icon_look.png" alt="查看引用路径"></a>');
            if (checkstatus == "0") {
                $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html("待审核");
            } else if (checkstatus == "1") {
                $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html("已通过");
            } else {
                $("#cl_tab_list tr[data-itemid=" + itemid + "] td:eq(4)").html("未通过");
            }
        }
        /* if ($("#checkIDs").val().indexOf('all') >= 0) {//超级管理员  ，*--所有栏目
        hasCheck = '<select name="column_sel_status" data-itemid="' + item.itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
    } else if (merits <= item.merit && $("#checkIDs").val().indexOf(',' + itemid + ',') >= 0) {//可以审核 此栏目
        hasCheck = '<select name="column_sel_status" data-itemid="' + item.itemid + '"><option value="0">未通过</option><option value="1">已通过</option></select>';
    } else {

    }*/
       /* if (pagetype != 1) {
            $("select[name=column_sel_status]").each(function () {
                if (itemid == $(this).parent("td").parent("tr").attr("data-itemid")) {
                    if ($(this).parent("td").parent("tr").attr("data-checkstatus") != 1) {
                        $(this).val(0);
                    }
                    else {
                        $(this).val(1);
                    }
                    // $(this).attr("disabled", "disabled");
                    if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "0") {
                        $(this).parent("td").html("待审核");
                    } else if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "1") {
                        $(this).parent("td").html("已通过");
                    } else {
                        $(this).parent("td").html("未通过");
                    }
                }
            });
        }
        else {
            if (tabResult == "1") {
                $("select[name=column_sel_status]").each(function () {
                    if (itemid == $(this).parent("td").parent("tr").attr("data-itemid")) {
                        if ($(this).parent("td").parent("tr").attr("data-checkstatus") != 1) {
                            $(this).val(0);
                        }
                        else {
                            $(this).val(1);
                        }
                    }
                });
            }
            else {
                $("select[name=column_sel_status]").each(function () {
                    if (itemid == $(this).parent("td").parent("tr").attr("data-itemid")) {

                        if ($(this).parent("td").parent("tr").attr("data-checkstatus") != 1) {
                            $(this).val(0);
                        }
                        else {
                            $(this).val(1);
                        }
                        // $(this).attr("disabled", "disabled");
                        //if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "0") {
                        //    $(this).parent("td").html("待审核");
                        //} else if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "1") {
                        //    $(this).parent("td").html("已通过");
                        //} else {
                        //    $(this).parent("td").html("未通过");
                        //}
                    }
                });
            }
        }*/
        //  }
        // })
    }
    function column_tabist_showfirstsc(itemid) {
        $.ajax({
            type: 'post',
            url: '/company/column/ajax/getmenufirstthumb.ashx',
            async: true,
            data: {
                id: itemid
            },
            dataType: 'text',
            success: function (data) {
                if (data != 0) {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        $("#cl_tab_list .tr[data-itemid=" + item.menuid + "]").attr("data-sourceid", item.itemid);
                        if (item.Thumbnail != "" && item.Thumbnail != null) {
                            tabResult = item.Thumbnail + "5.jpg";
                        } else {
                            tabResult = "/images/img_new/default_" + item.contenttype + "_5.png";
                        }
                        $("#sc_tab_list td[data-type=thumb" + itemid + "]").children("img").attr("src", tabResult);
                        $("#sc_tab_list tr[data-itemid=" + itemid + "]").attr("data-thumb", tabResult);
                    })
                    // column_tablist_thumb(itemid, item.thumbnail, item.contenttype);
                    
                }
            }
        })
    }
    function column_tablist_thumb(itemid, thumbnail, contenttype) {
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
                $("#sc_tab_list td[data-type=thumb" + itemid + "]").children("img").attr("src", data);
                $("#sc_tab_list tr[data-itemid=" + itemid + "]").attr("data-thumb", data);
            }
        })
    }
    function cl_tab_checkstatus(pagetype, ulevel, isfiled, itemid) {
        $.ajax({
            type: 'post',
            url: '/company/column/ajax/GetStatus.ashx',
            async: true,
            data: {
                pagetype: pagetype,
                ulevel: ulevel,
                isfiled: isfiled
            },
            dataType: 'text',
            success: function (data) {

                if (pagetype != 1) {
                    $("select[name=column_sel_status]").each(function () {
                        if (itemid == $(this).parent("td").parent("tr").attr("data-itemid")) {
                            if ($(this).parent("td").parent("tr").attr("data-checkstatus") != 1) {
                                $(this).val(0);
                            }
                            else {
                                $(this).val(1);
                            }
                            //$(this).attr("disabled", "disabled");
                            
                            if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "0") {
                                $(this).parent("td").html("待审核");
                            } else if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "1") {
                                $(this).parent("td").html("已通过");
                            } else {
                                $(this).parent("td").html("未通过");
                            }
                        }
                    });
                }
                else {
                    if (data == 1) {
                        $("select[name=column_sel_status]").each(function () {
                            if (itemid == $(this).parent("td").parent("tr").attr("data-itemid")) {
                                if ($(this).parent("td").parent("tr").attr("data-checkstatus") != 1) {
                                    $(this).val(0);
                                }
                                else {
                                    $(this).val(1);
                                }
                            }
                        });
                    }
                    else {
                        $("select[name=column_sel_status]").each(function () {
                            if (itemid == $(this).parent("td").parent("tr").attr("data-itemid")) {

                                if ($(this).parent("td").parent("tr").attr("data-checkstatus") != 1) {
                                    $(this).val(0);
                                }
                                else {
                                    $(this).val(1);
                                }
                                //$(this).attr("disabled", "disabled");
                                
                                if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "0") {
                                    $(this).parent("td").html("待审核");
                                } else if ($(this).parent("td").parent("tr").attr("data-checkstatus") == "1") {
                                    $(this).parent("td").html("已通过");
                                } else {
                                    $(this).parent("td").html("未通过");
                                }
                            }
                        });
                    }
                }
            }
        })
    }
    showTypeRecord("lanmu");
    $(".slideBarItem").mouseover(function () {
        $("#columnDiv").animate({ right: "0px" });
    })
    $("#columnDiv").mouseleave(function () {
        $("#columnDiv").animate({ right: "-200px" });
    })
    function cl_list_tab_shownext() {
        $("#cl_list_tab_qy_page").val(parseInt($("#cl_list_tab_qy_page").val(), 10) + 1);
        cl_list_tab_getdata();
    }
    $("#cl_tab_list_top th[issort=1]").die().live("click", function () {
        if ($("#cl_list_tab_sort").val() == "0") {
            $("#cl_list_tab_sort").val("1");
            $(this).children("span").text("↓");
            $(this).siblings("th").children("span").text("");
        }
        else {
            $("#cl_list_tab_sort").val("0");
            $(this).children("span").text("↑");
            $(this).siblings("th").children("span").text("");
        }
        $("#cl_tab_list").html("");
        $("#cl_list_tab_of").val($(this).attr("data-of"));
        cl_list_tab_getdata();
    });
</script>
<input type="hidden" id="column_tablist_hid_type" runat="server" />
<!--数据来源：0：数据库；1：cookie---------->
<input type="hidden" id="cl_list_tab_ds" runat="server" value="0" />
<!--排序字段 0:id,1:推荐指数，2：栏目名称，3：文件类型,4:操作员，5：状态，6：创建时间---------->
<input type="hidden" id="cl_list_tab_of" runat="server" value="0" />
<!--排序方式：0：倒叙；1：使用推荐正序---------->
<input type="hidden" id="cl_list_tab_sort" runat="server" value="0" />
<!--查询条件：素材名查询（为空时全部）---------->
<input type="hidden" id="cl_list_tab_qy_sn" runat="server" value="" />
<!--查询条件：用户名查询---------->
<input type="hidden" id="cl_list_tab_qy_un" runat="server" value="" />
<!--查询条件：创建日期查询（为空时全部）---------->
<input type="hidden" id="cl_list_tab_qy_cd" runat="server" value="" />
<!--查询条件：审核状态查询（为空时全部）---------->
<input type="hidden" id="cl_list_tab_qy_s" runat="server" value="" />
<!--查询条件：调用状态查询（为空时全部）---------->
<input type="hidden" id="cl_list_tab_qy_us" runat="server" value="" />
<!--查询条件：是否只查询自己的（0：查询所有的；1：只查询自己的）---------->
<input type="hidden" id="cl_list_tab_qy_isown" runat="server" value="0" />
<!--查询条件：分辨率查询（为空时全部）（多选','分割）---------->
<input type="hidden" id="cl_list_tab_qy_sr" runat="server" value="" />
<!--查询条件：时间范围查询---------->
<input type="hidden" id="cl_list_tab_qy_dr" runat="server" value="" />
<!--查询条件：上次加载的最后ID（为空时第一次加载）---------->
<input type="hidden" id="cl_list_tab_qy_page" runat="server" value="1" />
<!--查询条件：上次加载的最小ID（为空时第一次加载）---------->
<input type="hidden" id="cl_list_tab_qy_group" runat="server" value="" />
<!--查询条件：是否归档---------->
<input type="hidden" id="cl_list_tab_qy_isfiled" runat="server" value="" />
<div class="slideBarItem">
    <img src="/images/slideTwig.png">
</div>
<div id="columnDiv">
    <div class="lastSource commonStyle">
        <p><span>最近素材</span></p>
        <div class="lastSourceList ">
        </div>
    </div>
    <div class="lastProgram commonStyle" >
        <p><span>最近节目单</span></p>
        <div class="lastProgramList ">
        </div>
    </div>
    <div class="lastClient">
        <p><span>最近终端</span></p>
        <div class="lastClientList">
        </div>
    </div>
</div>
<div class="sc_result">
   <%-- <input type="checkbox" name="allChecked" value="" id="allChecked" style="margin-top: 15px;position: absolute;margin-left: 25px;" />--%>
    <table class="tab_sc_list" id="cl_tab_list_top">
        <tbody>
            <tr>
                <th width="80" issort="1" data-of="0">
                    序号<span>↑</span>

                </th>
                <th width="140" issort="1" data-of="2">栏目名称<span></span></th>
                <th width="90">宽度</th>
                <th width="90">高度</th>
                <th width="100" issort="1" data-of="5">状态<span></span></th>
                <th width="125">操作</th>
            </tr>
        </tbody>
    </table>
    
    <table class="tab_sc_list" id="cl_tab_list">
    </table>
    <div class="loading_more" id="cl_tab_list_loadmore"><a href="javascript:void(0)" onclick="cl_list_tab_shownext()"><b></b>加载更多</a></div>
</div>
<script>
    $(function () {
        function DoCheck() {

            var ch = document.getElementsByName("cl_tab_list_check");
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

        //结束
    })
</script>