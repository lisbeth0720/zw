<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="edit_column_sc.aspx.cs" Inherits="Web.company.column.edit_column_sc" %>
<script type="text/javascript">
    var hh;
    var mm;
    var ss;
    $(function () {
        var mybtnHtml ="";
        var modelright = $("#h_edit_column_right").val();
        if ($("#h_edit_column_pagetype").val() == "0") {
            //class="inp_btn tongguo colume_positioned" 
            $(".sc_add_btn").html(' <span class="inp_btn btn_pass colume_positioned" title="保存" style="margin:5px;"><b style="left:20px;    display: block;width: 20px;height: 20px;position: absolute;left: 9px;background: url(/images/tubiaoa.png) -215px 0px;"></b><input type="submit" value="保存" class="btn" style="padding-left:25px;"/></span><span class="inp_btn resetbtn colume_positioned" title="重置"><b style="left:20px"></b> <input type="reset" value="重置" class="btn" style="padding-left:20px;" /></span> <span class="inp_btn sv_close colume_positioned" title="关闭"><b  style="left:20px;"></b><input type="button" value="关闭" class="btn" onclick="edit_column_sc_close()" style="padding-left:25px;" /></span>');
        }
        else {
            $("input[type=text]").attr("readonly", "readonly");
            $("input[type=radio]").attr("disabled", "disabled");
            $("input[type=check]").attr("disabled", "disabled");
            $("select").attr("disabled", "disabled");
            mybtnHtml = 'btnpass<span class="inp_btn btn_refuse"> <input type="button" value="拒绝" class="btn" /></span>';
            if ($("#checkstatus").val() == "1") {//'已通过' 的节目项，不显示‘通过’按钮
                mybtnHtml = mybtnHtml.replace("btnpass", "");
            } else {
                mybtnHtml = mybtnHtml.replace('btnpass', '<span id="checkSpan" class="inp_btn btn_pass"><input type="button" value="通过" class="btn" /></span>');
            }
            $(".sc_add_btn").html(mybtnHtml);
        }
        /***页面进入控件绑定值时间***********************************/
        $.ajax({
            type: 'post',
            url: 'ajax/getmenudetai.ashx',
            async: true,
            data: {
                menuid: $("#h_edit_column_mid").val(),
                taskid: $("#h_edit_column_tid").val()
            },
            dataType: 'text',
            success: function (data) {

                if (data != "-1") {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        if (data != "-1") {
                            var json = strToJson(data);
                            $.each(json.Table, function (idx, item) {

                                $("#edit_column_taskname").val(item.taskname);
                                if (item.openflag == 1) {
                                    $("input[name=c_edit_column_openflag]").attr("checked", "checked");
                                }

                                var paramStr = item.exetask;
                                $("#s_edit_column_exetask").val(paramStr);
                                $("#sel_edit_column_pro").val(paramStr);
                                var tv = paramStr.indexOf(" ");
                                if (tv > 0) {
                                    var startStr = paramStr.substring(0, tv);

                                    if (startStr.indexOf(".exe") > 0 || startStr.indexOf(":") > 0) {
                                        $("#sel_edit_column_pro").val(startStr);
                                    }
                                }

                                tv = paramStr.indexOf("-w");
                                if (tv > 0) {
                                    var lsStr = paramStr.substring(tv + 3);
                                    tv = lsStr.indexOf(" ");
                                    if (tv > 0) {
                                        lsStr = lsStr.substring(0, tv);
                                    }
                                    if (lsStr != "") {
                                        $("input[name=c_edit_column_param_setloc]").attr("checked", "checked");
                                        $("#s_edit_column_param_window").val(lsStr);
                                    }

                                }
                                tv = paramStr.indexOf("-p");
                                if (tv > 0) {
                                    $("input[name=c_edit_column_param_setpstmsg]").attr("checked", "checked");
                                }
                                tv = paramStr.indexOf("-t");
                                if (tv > 0) {
                                    $("input[name=c_edit_column_param_settopmost]").attr("checked", "checked");
                                }
                                tv = paramStr.indexOf("-m");
                                if (tv > 0) {
                                    $("input[name=c_edit_column_param_setminimize]").attr("checked", "checked");
                                }
                                tv = paramStr.indexOf("-s");
                                if (tv > 0) {
                                    $("input[name=c_edit_column_param_setclose]").attr("checked", "checked");
                                }
                                tv = paramStr.indexOf("-l");
                                var tv2 = paramStr.indexOf("-h");
                                if (tv > 0 || tv2 > 0) {
                                    if (tv > 0) {
                                        $("input[name=r_edit_column_param_settrans][value=1]").attr("checked", "checked");
                                    }
                                    else if (tv2 > 0) {
                                        $("input[name=r_edit_column_param_settrans][value=2]").attr("checked", "checked");
                                    }

                                }
                                else {
                                    $("input[name=r_edit_column_param_settrans][value=0]").attr("checked", "checked");
                                }
                                tv = paramStr.indexOf("-r");
                                tv2 = paramStr.indexOf("-e");
                                if (tv > 0 || tv2 > 0) {
                                    if (tv > 0) {
                                        $("input[name=r_edit_column_param_setmask][value=1]").attr("checked", "checked");
                                    }
                                    else if (tv2 > 0) {
                                        $("input[name=r_edit_column_param_setmask][value=2]").attr("checked", "checked");
                                    }

                                }
                                else {
                                    $("input[name=r_edit_column_param_setmask][value=0]").attr("checked", "checked");
                                }
                                $("#s_edit_column_descript").val(item.descript);
                                $("input[name=s_edit_column_triggertype][value=" + item.triggertype + "]").attr("checked", "checked");
                                if (item.triggertype == 1) {
                                    $("#t_edit_column_triggertime1").val(item.triggertime);
                                    $("#t_edit_column_triggertime1").parent("li").show();
                                }
                                if (item.triggertype == 2) {
                                    $("#t_edit_column_triggertime2").val(item.triggertime);
                                    $("#t_edit_column_triggertime2").parent("li").show();
                                }

                                $("#t_edit_column_duringtime_h").val(parseInt(item.duringtime / 3600, 10));
                                $("#t_edit_column_duringtime_m").val(parseInt((item.duringtime % 3600) / 60));
                                $("#t_edit_column_duringtime_s").val(((item.duringtime % 3600) % 60) % 60);

                                //扩展属性
                                if (item.copyto & 0x02) {
                                    $("input[name=c_edit_column_canreact]").prop("checked", true);
                                }
                                if (item.copyto & 0x04) {
                                    $("input[name=c_edit_column_usesubject]").prop("checked", true);
                                }
                                $("#s_edit_column_merit").val(item.merit);
                                $("input[name=r_edit_column_circleeveryday][value=1]").attr("checked", "checked");
                                $("#t_edit_column_circletime").val(item.circletime);
                                $("#t_edit_column_starttime").val(item.starttime);
                                $("#t_edit_column_expiretime").val(item.expiretime);
                                $("input[@type=radio][name=r_edit_column_copyto][@value=" + (item.copyto & 0x01) + "]").attr("checked", true);
                                $("input[@type=radio][name=r_edit_column_circleeveryday][@value=" + item.circleeveryday + "]").attr("checked", true);
                                $("#t_edit_column_starttime").val(item.starttime);
                                $("#t_edit_column_expiretime2").val(item.expiretime);
                                //$("input[@type=radio][name=r_edit_column_zorder][@value=" + item.zorder + "]").attr("checked", true);
                                $("#s_t_edit_column_postion").val(item.postion);
                                //$("input[name=c_edit_column_myplayer][value=" + item.myplayer + "]").attr("checked", "checked");
                                $("input[@type=radio][name=r_edit_column_myplayer][value=" + item.myplayer + "]").attr("checked", true);
                                edit_column_sc_bindtemplet(item.templateid, item.bkpic, item.options);
                                // $("#checkstatuslist").val(item.checkstatus)
                                $("#checkstatuslist").val($("#checkstatus").val());
                            });
                        }
                        else {
                            LoginTimeOut();
                        }

                    });
                }
                else {
                    LoginTimeOut();
                }
            }
        })

        //s_edit_column_triggertype
        $("input[name=s_edit_column_triggertype]").click(function () {
            editProgramItem("editTriggerType");
        });
        /***页面进入控件绑定值事件结束***********************************/

        $("input[name=s_edit_column_triggertype]").click(function () {
            if ($(this).val() == 1) {
                $("#t_edit_column_triggertime1").val(getNowFormatDate());
                $("#t_edit_column_triggertime1").parent("li").show();
                $("#t_edit_column_triggertime2").parent("li").hide();
            }
            else if ($(this).val() == 2) {
                $("#t_edit_column_triggertime2").val(getNowFormatTime());
                $("#t_edit_column_triggertime2").parent("li").show();
                $("#t_edit_column_triggertime1").parent("li").hide();
            }
            else {
                $("#t_edit_column_triggertime2").parent("li").hide();
                $("#t_edit_column_triggertime1").parent("li").hide();
            }
        });
        $("h6").click(function () {
            $("h6").attr("data-isshow", 0);
            $(this).attr("data-isshow", 1);
            $(".zyyProgramEditContent").hide();
            $(".zyyProgramEditContent" + ($(this).index()+1)).show();
            $("h6").css({
                "background": "#fff",
                "color": "#1ca8dd"
            })
            $(this).css({
                "background": "#1ca8dd",
                "color":"#fff"
            })
        })
        //$("h6").eq(0).click(function () {

        //    $("h6").eq(1).attr("data-isshow", 0);
        //    $(".zyyProgramEditContent2").hide();
        //    $(".zyyProgramEditContent1").show();
        //    $("h6").eq(0).css("boxShadow", "inset 0px -15px 15px -18px #000");
        //    $("h6").eq(1).css("boxShadow", "none");
        //})
        //$("h6").eq(1).click(function () {

        //    $("h6").eq(1).attr("data-isshow", 1);
        //    $(".zyyProgramEditContent1").hide();
        //    $(".zyyProgramEditContent2").show();
        //    $("h6").eq(1).css("boxShadow", "inset 0px -15px 15px -18px #000");
        //    $("h6").eq(0).css("boxShadow", "none");
        //})

        function getNowFormatTime() {
            var date = new Date();

            var currentdate = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
            return currentdate;
        }

         function getNowFormatDate() {
            var date = new Date();
            var seperator1 = "-";
            var seperator2 = ":";
            var month = date.getMonth() + 1;
            var strDate = date.getDate();
            if (month >= 1 && month <= 9) {
                month = "0" + month;
            }
            if (strDate >= 0 && strDate <= 9) {
                strDate = "0" + strDate;
            }
            var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
                    + " " + date.getHours() + seperator2 + date.getMinutes()
                    + seperator2 + date.getSeconds();
            return currentdate;
        }
        //节目目触发类型选择事件
        $("#s_edit_column_triggertype").change(function () {
            if ($(this).val() == "1") {
                $("#t_edit_column_triggertime1").parent("li").slideDown();
                $("#t_edit_column_triggertime2").parent("li").slideUp();
            }
            else if ($(this).val() == "2") {
                $("#t_edit_column_triggertime2").parent("li").slideDown();
                $("#t_edit_column_triggertime1").parent("li").slideUp();
            }
            else {
                $("#t_edit_column_triggertime1").parent("li").slideUp();
                $("#t_edit_column_triggertime2").parent("li").slideUp();
            }
        });

        //表单提交
        $("#eidt_column_sc").Validform({
            tiptype: function (msg, o, cssctl) {
                if (!o.obj.is("form")) {//验证表单元素时o.obj为该表单元素，全部验证通过提交表单时o.obj为该表单对象;
                    var objtip = o.obj.siblings(".Validform_checktip");
                    cssctl(objtip, o.type);
                    objtip.text(msg);
                } else {
                    var objtip = o.obj.find("#msgdemo");
                    cssctl(objtip, o.type);
                    objtip.text(msg);
                }
            },
            beforeSubmit: function () {
                $("#cl_range_selsclist li.current").attr("data-checkstatus", $("#checkstatuslist").val());
                $("#checkstatus").val($("#checkstatuslist").val());
                if ($("#myColFiled").val() == "1") {//栏目归档， 不能修改
                    TopTrip("归档栏目，不能修改", 2); return false;
                }
                if ($("input[name=c_edit_column_openflag]").prop("checked")) {
                    $("input[name=c_edit_column_openflag]").val("on");
                } else { $("input[name=c_edit_column_openflag]").val(""); }
                if ($("input[name=c_edit_column_canreact]").prop("checked")) {
                    $("input[name=c_edit_column_canreact]").val("on");
                } else { $("input[name=c_edit_column_canreact]").val(""); }
                if ($("input[name=c_edit_column_usesubject]").prop("checked")) {
                    $("input[name=c_edit_column_usesubject]").val("on");
                } else { $("input[name=c_edit_column_usesubject]").val(""); }
            },
            ajaxPost: true,
            //postonce: true,

            callback: function (d) {
                if (d.status == "y") {
                    TopTrip("编排完成", 1);
                    //$("#cl_range_selsclist .current").find(".time").text($("#t_edit_column_duringtime_h").val() + ":" + $("#t_edit_column_duringtime_m").val() + ":" + $("#t_edit_column_duringtime_s").val());
                    var hstr = $("#t_edit_column_duringtime_h").val();
                    var mstr = $("#t_edit_column_duringtime_m").val();
                    //if (mstr < 60) { mstr = mstr }
                    var sstr = $("#t_edit_column_duringtime_s").val();
                    //if (sstr < 60) { sstr = sstr }
                    if (hstr == "") hstr = "0";
                    if (mstr == "") mstr = "0";
                    if (sstr == "") sstr = "0";
                    if (hstr == "0" && mstr == "0" && sstr == "0") {
                        hstr = "1";
                        $("#t_edit_column_duringtime_h").val("1");
                    }
                    var oldHtml = $("#cl_range_selsclist .current").find(".time").html();
                    var oldText = $("#cl_range_selsclist .current").find(".time").text();
                    oldHtml = oldHtml.replace(oldText, "");
                    $("#cl_range_selsclist .current").find(".time").html(oldHtml + hstr + ":" + mstr + ":" + sstr);
                    //todo...根据 节目触发类型， 显示不同图标 
                    var typeIcon = 'url("/images/tubiaoa.png") repeat scroll -1px -171px';//节目触发类型， 显示的图标
                    var mytype = $("input[name='s_edit_column_triggertype']:checked").val();
                    //'url("/images/tubiaoa.png") repeat scroll -146px -171px'
                    //'url("/images/tubiaoa.png") repeat scroll -146px -171px'
                    switch (parseInt(mytype)) {//0接前任务, 1绝对年月时间, 2每天时间, 3手动, 4空闲, 5暂不触发
                        case 0:
                            typeIcon = 'url("/images/tubiaoa.png") repeat scroll -1px -171px';
                            break;
                        case 3:
                            typeIcon = 'url("/images/tubiaoa.png") repeat scroll -19px -171px';
                            break;
                        case 1:
                            typeIcon = 'url("/images/tubiaoa.png") repeat scroll -39px -171px';
                            break;
                        case 2:
                            typeIcon = 'url("/images/tubiaoa.png") repeat scroll -62px -171px';
                            break;
                        case 4:
                            typeIcon = 'url("/images/tubiaoa.png") repeat scroll -82px -171px';
                            break;
                        case 5:
                            typeIcon = 'url("/images/tubiaoa.png") repeat scroll -104px -171px';
                            break;

                    }
                    $("#cl_range_selsclist .current").find(".time b")[0].style.background = typeIcon;
                    //2操作系统自检测 ,3专用应用程序 ,4远程指令 ,5专用文件传输
                    var mycType = $("input[name='r_edit_column_myplayer']:checked").val();
                    var oldTitle = $("#cl_range_selsclist .current a").attr("title");
                    oldTitle = oldTitle.split("-")[0];
                    var newTitle = "";
                    switch (parseInt(mycType)) {
                        case 2:
                            newTitle = "操作系统自检测"; break;
                        case 3:
                            newTitle = "专用应用程序"; break;
                        case 4:
                            newTitle = "远程指令"; break;
                        case 5:
                            newTitle = "专用文件传输"; break;

                    }
                    if (newTitle != "") { $("#cl_range_selsclist .current a").attr("title", oldTitle + "-" + newTitle); }
                    //$("#column_arrange_edititem_box").html("").slideUp();
                } else if (d.status=="-100") {
                    TopTrip("归档栏目，不能修改", 2);
                }
                else {
                    if (d.info == "-1") {
                        LoginTimeOut();
                    }
                    else {
                        TopTrip("系统错误，请联系管理员", 3);
                    }
                }
                //$("#column_arrange_edititem_box").slideUp();
            }
        });
        $("#sel_edit_column_pro").change(function () {
            edit_menu_columnchange();
        });
        $("#s_edit_column_exetask").blur(function () {
            //edit_menu_columnchange();//此处注释掉的原因是可以任意修改“s_edit_column_exetask”的值，不依靠于“应用程序名”
        });
        //$("#moreInfo").change(function () {
        //    editcolumnDescriptChange();
        //})
        $("#moreInfoChoise").change(function () {
            moreInfoChoiseChange();
        })
        $("input[name=c_edit_column_param_setloc]").click(function () {
            edit_menu_columnchange();
        });
        $("#s_edit_column_param_window").blur(function () {
            edit_menu_columnchange();
        });
        $("input[name=c_edit_column_param_setpstmsg]").click(function () {
            edit_menu_columnchange();
        });
        $("input[name=c_edit_column_param_settopmost]").click(function () {
            edit_menu_columnchange();
        });
        $("input[name=c_edit_column_param_setminimize]").click(function () {
            edit_menu_columnchange();
        });
        $("input[name=c_edit_column_param_setclose]").click(function () {
            edit_menu_columnchange();
        });
        $("input[name=r_edit_column_param_settrans]").click(function () {
            edit_menu_columnchange();
        });
        $("input[name=r_edit_column_param_setmask]").click(function () {
            edit_menu_columnchange();
        });
        $("#select_addtime").change(function () {
            var unit = $("#select_addtime").find("option:selected").attr("data-unit");
            var type = $("#select_addtime").find("option:selected").attr("data-type");
            var val = $(this).val();
            if (unit == "s") {
                if (type == 1) {
                    $("#t_edit_column_duringtime_s").val(parseInt($("#t_edit_column_duringtime_s").val()) + val);
                }
                if (type == 2) {
                    $("#t_edit_column_duringtime_s").val(parseInt($("#t_edit_column_duringtime_s").val()) - val);
                }
            }
            if (unit == "m") {
                if (type == 1) {
                    $("#t_edit_column_duringtime_m").val(parseInt($("#t_edit_column_duringtime_m").val()) + val);
                }
                if (type == 2) {
                    $("#t_edit_column_duringtime_m").val(parseInt($("#t_edit_column_duringtime_m").val()) - val);
                }
            }
            if (unit == "h") {
                if (type == 1) {
                    $("#t_edit_column_duringtime_h").val(parseInt($("#t_edit_column_duringtime_m").val()) + val);
                }
                if (type == 2) {
                    $("#t_edit_column_duringtime_h").val(parseInt($("#t_edit_column_duringtime_m").val()) - val);
                }
                if (type == 3) {
                    $("#t_edit_column_duringtime_h").val(parseInt($("#edit_column_duringtime_h").val()) * val);
                }

            }
        });


    })
    //审核  通过按钮
    $("#checkSpan .btn_pass").live("click", function () {
        
        if ($("#myColFiled").val()=="1") {
            TopTrip("归档栏目，不能修改！", 2);
            return false;
        }
        $.ajax({
            type: 'post',
            url: 'ajax/checkmenu.ashx',
            data: {
                "menuid": $("#column_arrange_clid").val(),
                "taskid": $("#h_edit_column_tid").val(),
                "checkstatus": 1,
                "reason": ""
            },
            async: true,
            dataType: 'text',
            success: function (data) {
                if (data == -1) {
                    LoginTimeOut();
                }
                else if (data=="-100") {
                    TopTrip("归档栏目，不能修改！", 2);
                }
                else {
                    if (data == 0) {
                        TopTrip("系统错误，请联系管理员！", 3);
                    }
                    if (data > 0) {
                        TopTrip("节目项审核成功！", 1);
                    }
                }
            }
        })
    })
    $(".btn_refuse").live("click", function () {
        if ($("#myColFiled").val() == "1") {
            TopTrip("归档栏目，不能修改！", 2);
            return false;
        } else {
            ShowCheckMenuItemTrip();
        }
    })
    $("#sel_check_item").die().live("change", function () {
        var boxId = $(this).attr("data-id");
        var sel = $(this).val();
        if ($(this).val() == "0") {
            $(this).parent().parent().next("div").show();
        }
        else {
            $(this).parent().parent().next("div").hide();
        }
    });
    $("#btn_cancheckitem").die().live("click", function () {
        var boxId = $(this).attr("data-id");
        $("#" + boxId).hide();
    });
    //栏目审核，弹框中的“确定”按钮
    $("#btn_checkitem").die().live("click", function () {
        if ($("#myColFiled").val() == "1") {
            TopTrip("归档栏目，不能修改！", 2);
            return false;
        }
        var boxId = $(this).attr("data-id");
        var sel = $("#sel_check_item").val();
        $.ajax({
            type: 'post',
            url: 'ajax/checkmenu.ashx',
            data: {
                "menuid": $("#column_arrange_clid").val(),
                "taskid": $("#h_edit_column_tid").val(),
                "checkstatus": sel,
                "reason": $("#text_checkreason").val()
            },
            async: true,
            dataType: 'text',
            success: function (data) {
                if (data == -1) {
                    LoginTimeOut();
                } else if (data == "-100") {
                    TopTrip("归档栏目，不能修改！", 2);
                }
                else {
                    if (data == 0) {
                        $("#" + boxId).hide();
                        TopTrip("审核失败，请与管理员联系！", 3);
                    }
                    if (data > 0) {
                        $("#" + boxId).hide();
                        TopTrip("审核完成！", 1);
                    }
                }
            }
        })
    })
    function edit_menu_columnchange() {
        var param = $("#sel_edit_column_pro").val();
        if (param == "") {
            param = $("#s_edit_column_exetask").val().split("-")[0].trim();
        }
        if ($("input[name=c_edit_column_param_setloc]").attr("checked") == "checked" && $("#s_edit_column_param_window").val() != ""  && param.indexOf("-w")==-1) {
            param = param + " -w " + $("#s_edit_column_param_window").val();
        }
        if ($("input[name=c_edit_column_param_setpstmsg]").attr("checked") == "checked" && param.indexOf("-p")==-1) {
            param = param + " " + "-p";
        }
    if ($("input[name=c_edit_column_param_settopmost]").attr("checked") == "checked" && param.indexOf("-t")==-1) {
            param = param + " " + "-t";
        }
    if ($("input[name=c_edit_column_param_setminimize]").attr("checked") == "checked"  && param.indexOf(" -m ")==-1) {
        param = param + " " + "-m";//param.indexOf("-m")==-1
        }
    if ($("input[name=c_edit_column_param_setclose]").attr("checked") == "checked" && param.indexOf("-s")==-1) {
            param = param + " " + "-s";
        }
    if ($("input[name=r_edit_column_param_settrans]:checked").val() == "1" && param.indexOf("-l")==-1) {
            param = param + " " + "-l";
        }
    if ($("input[name=r_edit_column_param_settrans]:checked").val() == "2" && param.indexOf("-h")==-1){
            param = param + " " + "-h";
        }
    if ($("input[name=r_edit_column_param_setmask]:checked").val() == "1" && param.indexOf("-r")==-1) {
            param = param + " " + "-r";
        }
    if ($("input[name=r_edit_column_param_setmask]:checked").val() == "2"&& param.indexOf("-e")==-1) {
            param = param + " " + "-e";
        }
        $("#s_edit_column_exetask").val(param);
    }
    //播放窗口位置
    function moreInfoChoiseChange() {
        var options = $("#moreInfoChoise option:selected");
        var optionsValue = options.val();
        if (optionsValue != "undefined" && optionsValue!="") {
            //document.getElementById("moreInfo option:selected").value = optionsValue;
            $("#s_edit_column_param_window").val(optionsValue);
             $("[name='c_edit_column_param_setloc']").attr("checked", true);//勾选 ‘播放窗口位置’           
        } else {
            $("#s_edit_column_param_window").val("");
            $("[name='c_edit_column_param_setloc']").attr("checked", false);
            
        }
        edit_menu_columnchange();
        //$("[name='c_edit_column_param_setloc']").click();
    }
    //function editcolumnDescriptChange() {
    //    var options = $("#moreInfo option:selected");
    //    var optionsValue = options.val();
    //    if (optionsValue != "undefined") {
    //        //document.getElementById("moreInfo option:selected").value = optionsValue;
    //        $("#s_edit_column_descript").val(optionsValue);
    //    }
    //}
    $(".btn_ex").die().live("click", function () {
        if ($(this).attr("data-ishsow") == "0") {
            $(this).attr("data-ishsow", "1");
            $(this).addClass("btn_ex2");
            $(".li_ex").show();
        }
        else {
            $(this).attr("data-ishsow", "0");
            $(this).removeClass("btn_ex2");
            $(".li_ex").hide();
        }
    });
    $("#edit_menu_add_ex").die().live("click", function () {
        if ($(this).attr("data-isshow") == "0" || $.cookie("ColumnArrSlide") == "0") {
            $.cookie("ColumnArrSlide", "1");
            $(this).removeClass("ex_task").addClass("ex_task2").text("收起");
            $(this).next(".section").show();
            $(this).attr("data-isshow", 1);
            
        }
        else if ($(this).attr("data-isshow") == "1" || $.cookie("ColumnArrSlide") == "1"){
            $.cookie("ColumnArrSlide", "0");
            $(this).attr("data-isshow", 0);
            $(this).removeClass("ex_task2").addClass("ex_task").text("展开");
            $(this).next(".section").hide();
            
        }
        console.log($.cookie("ColumnArrSlide"));
    })
  
      
       
   

    function edit_column_sc_bindtemplet(tempid, myBkpic, myOptions) {
        if (myBkpic != "" || myOptions != "") {
            $("#t_edit_column_templet").val("自定义设置");
            $("#h_edit_column_templet").val(tempid);
        } else {
            $.ajax({
                type: 'post',
                url: '/company/templet/ajax/gettempinfo.ashx',
                data: {
                    "tempid": tempid
                },
                async: false,
                dataType: 'text',
                success: function (data) {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        $("#t_edit_column_templet").val(item.template);
                        $("#h_edit_column_templet").val(tempid);
                    })
                }
            });
        }
    }
    function edit_column_sc_seltemp() {
        ClearTempListHtml();//    /company/templet/templetlist.aspx
        $("#edit_column_seltemplete").load("/common/templetlist.aspx", { "t": 2 }, function () {
            $("#overlay").show();
            $("#edit_column_seltemplete").fadeIn();
        });
    }
    $("#templet_list_closebtn").die().live("click", function () {
        $("#edit_column_seltemplete").fadeOut(function () {
            $("#overlay").fadeOut();
            $("#edit_column_seltemplete").empty();
        });
    });
    function edit_column_sc_close() {
        $("#column_arrange_edititem_box").slideUp();
    }

    function showMyDialogs(myUrl, myTitle) {
        $("#myDialogs").load(myUrl);
        $("#myDialogs").dialog({
            //autoOpen: false,
            close: function () {
                if ($("#previewPhotoDiv").length > 0) {
                    $("#previewPhotoDiv").fadeOut();
                    $("#overlay").fadeOut();
                }
                $("#myDialogs").html("");
            },
            width: 1200,
            height: 600,
            resizable: true,
            title: myTitle,
            stack: true,
            appendTo: "body"
        });
    }

    //弹出网页编捷页面 zyy添加网页编辑页面
    function zyyEditNet() {
        $(".shadowDiv").css("height", $("body").height() + "px");

        $(".shadowContent1").css("left", (document.documentElement.clientWidth - $(".shadowContent1").width()) / 2);
        $(".addContent").html("");
        $(".shadowDiv").show();
        $(".addUrlContent input[type=text]").val("");
        modelArray = [];
        contentArray = [];
        positions = [];
        var str = "";
        var j = 0;
        var selectStr = "<option></option>";
        var selecturlStr = "<option></option>";
        var taskID = "";
        var url = $("#sourcePath").val();
        var netSourceContent = "";
        var contentName = "";
        var begin = 0;
        var end = 0;
        var getitem = "";
        var contentCount = 0;//当前网页的所有可填项，若可填项小于等于0，则提示“暂无可填项”
        $.ajax({
            url: url,
            dataType: "html",
            scriptCharset: 'GBK',
            type: "GET",
            success: function (data) {
                netSourceContent = data;//获取全字符串，不能以对象的方式处理，若以对象处理会访问实际的文件
                while (netSourceContent != "") {
                    begin = netSourceContent.indexOf("<!--($[0---@1@<");
                    if (begin < 0) break;
                    end = netSourceContent.indexOf(">", begin + 15);
                    if (end < 0) {
                        getitem = netSourceContent.substr(begin + 15, 32);//若没有结束字符，则认为后面全部提取，考虑到不能太长，所以只截取32个字符
                        netSourceContent = "";
                    } else {
                        getitem = netSourceContent.substr(begin + 15, end - (begin + 15));
                        netSourceContent = netSourceContent.substr(end + 1);//截取成功之后，从end后开始等待下次查询
                    }
                    if (getitem != "") {
                        // contentArray.push(getitem, contentCount);
                        contentArray.push(getitem);
                        if (contentCount == 0) {
                            str = "<p style='height:90px'><span style='display:block;width:100px;float:left;text-align:right;'>" + getitem + "：</span><textarea type='text' class='inputText' tabindex ='0' rows='3' style='resize:none;height:80px;width:300px;position:absolute;z-index:30;float:left;box-sizing:border-box;'></textarea><select style='height:80px;position:absolute;float:left;width:318px;'></select><span class='cleartext' style='width:20px;display:none;'><img  /></span></p>";//src='images/source/clear.png'
                        } else {
                            str = "<p style='height:30px;'><span style='display:block;width:100px;float:left;text-align:right;'>" + getitem + "：</span><input type='text' class='inputText' tabindex ='0' style='width:300px;position:absolute;z-index:30;float:left;box-sizing:border-box;'/><select style='position:absolute;float:left;width:318px;'></select><span class='cleartext' style='width:20px;display:none;'><img  /></span></p>";//src='images/source/clear.png'
                        }
                        $(".addContent").append(str);

                        getNetCookie(getitem, contentCount);
                        contentCount++;
                    }
                }
                if (contentCount <= 0) {
                    $(".addContent").append('<p style="text-align:center;line-height:50px;font-size:16px;color:red;">暂时无可填项！</p>');
                }

                $(".submitnet").val("提交");
                $(".yulanBtn").val("取消");

                $(".inputText").keydown(function () {
                    $(this).siblings(".cleartext").css("display", "block");
                })
                $(".inputText").keyup(function () {
                    if ($($(this)).val() == "") {
                        $(this).siblings(".cleartext").css("display", "none");
                    }

                })
                $(".cleartext").click(function () {
                    $(this).siblings(".inputText").val("");
                    if ($(this).siblings(".inputText").val() == "") {
                        $(this).css("display", "none");
                    }
                })
                //点击select标签时将select的数据填充到当前的input中
                $("select").change(function () {
                    changeWindows(this);
                })
                $(".shadowDiv").css("marginTop", ($("body").height() - $(".shadowDiv").height()) / 2);
                // $(".urlContent").css("marginTop", ($(".shadowDiv").height() - 30 - $(".shadowDiv").height() * 0.5 - $(".urlContent").height()) / 2);
               // $(".shadowDiv").css("marginLeft", ($("body").width() - $(".shadowDiv").width()) / 2);
            }

        })
        $(".submitnet").css("marginLeft", ($(".shadowContent1").width() - $(".submitnet").width() * 2 - parseFloat($(".submitnet").css("marginLeft"))) / 2);
        $(".shadowContent1").css("marginTop", (document.documentElement.clientHeight - $(".shadowContent1").height()) / 2);
    }
    //将数据从cookie中读取，并加入到select中
    function getNetCookie(cookieName, i) {
        if ($.cookie("'" + encodeURI(cookieName + "：") + "'") != "" && $.cookie("'" + encodeURI(cookieName + "：") + "'") != null) {
            var cookiename = $.cookie("'" + encodeURI(cookieName + "：") + "'");
            var name = $.cookie("'" + encodeURI(cookieName + "：") + "'");
            var selectStr1 = "<option></option>";

            for (var h = 0; h < decodeURI(name).split(",").length; h++) {
                var newSelectStr = decodeURI(name).split(",")[h];
                if (i == 0) {
                    if (decodeURI(name).split(",")[h].indexOf("<br>") >= 0) {
                        var reg = new RegExp('<br>', "g");
                        var newstr1 = decodeURI(name).split(",")[h].replace(reg, '\n');
                        newSelectStr = newstr1;
                    }
                }
                selectStr1 += "<option value='" + newSelectStr + "'>" + newSelectStr + "</option>";
            }
            $(".inputText").eq(i).siblings("select").html(selectStr1);

        }
    }
    function cancleNet() {
        $(".shadowDiv").hide();
        $(".submitnet").css("marginLeft", "20px");
    }
    //将所有的数据提交，并存入cookie
    function submitnet() {
        var str = '';

        var win = "";
        //存储各个关键词的cookie
        for (var i = 0; i < $(".addContent .inputText").length; i++) {
            var arrys = [];
            if ($.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'") != null) {
                if ($.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'").indexOf(",") >= 0) {
                    var arrysx = $.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'").split(",");
                    //arrys.push(arrysx);
                    arrys = arrysx;
                } else {
                    arrys.unshift($.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'"));
                }
            }
            //若当前关键词不是窗口号并且关键词不是null时就将当前关键词和关键词的value存入cookie,最多能保存三个值，多于三个值删时间最早的那一条
            if ($(".addContent .inputText").eq(i).val() !== "" && $(".addContent .inputText").eq(i).val() !== null) {
                if ($(".addContent .inputText").eq(i).prev().html() != "窗口号：") {
                    //var arrys="arr"+i;
                    if (i == 0) {
                        if ($(".addContent .inputText").eq(i).val().indexOf("\n") >= 0) {
                            var reg = new RegExp('\n', "g");
                            var newstr = $(".addContent .inputText").eq(i).val().replace(reg, '<br>');
                            $(".addContent .inputText").eq(i).val(newstr);
                        }
                    }
                    str += "<" + $(".addContent .inputText").eq(i).prev().html().split("：")[0] + ">" + $(".addContent .inputText").eq(i).val() + "</" + $(".addContent .inputText").eq(i).prev().html().split("：")[0] + ">";

                    if ($.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'") != null) {
                        if ($.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'").indexOf(",") >= 0) {
                            if (arrys.length >= 5) {
                                arrys.pop();
                            }
                        }
                    }
                    if (arrys.includes(encodeURI($(".addContent .inputText").eq(i).val())) || $(".addContent .inputText").eq(i).val() == "") {
                    } else {
                        if (i == 0) {
                            if ($(".addContent .inputText").eq(i).val().indexOf("\n") >= 0) {
                                var reg = new RegExp('\n', "g");
                                var newstr = $(".addContent .inputText").eq(i).val().replace(reg, '<br>');
                                $(".addContent .inputText").eq(i).val(newstr);
                            }
                        }
                        arrys.unshift(encodeURI($(".addContent .inputText").eq(i).val()));
                    }
                    $.cookie("'" + encodeURI($(".addContent .inputText").eq(i).prev().html()) + "'", arrys, { path: "/", expiress: 1, sucue: true });
                }
            }
        }
        var submitStr = "";
        for (var i = 0; i < $(".inputText").length; i++) {
            if ($(".inputText").eq(i).val() != "") {
                if ($(".addContent .inputText").eq(i).val().indexOf("\n") >= 0) {
                    var reg = new RegExp('\n', "g");
                    var newstr = $(".addContent .inputText").eq(i).val().replace(reg, '<br>');
                    // $(".addContent .inputText").eq(i).val(newstr);
                    submitStr += "<" + $(".inputText").eq(i).prev().html().split("：")[0] + ">" + newstr + "</" + $(".inputText").eq(i).prev().html().split("：")[0] + ">"
                } else {
                    submitStr += "<" + $(".inputText").eq(i).prev().html().split("：")[0] + ">" + $(".inputText").eq(i).val() + "</" + $(".inputText").eq(i).prev().html().split("：")[0] + ">"

                }
            }
        }
        $("#s_edit_program_descript").val(submitStr);
        $(".submitnet").css("marginLeft", "20px");
        $(".shadowDiv").css("display", "none");
    }
    //将select选择好的值添加到当前的input中
    function changeWindows(thisWindows) {
        $(thisWindows).prev().val($(thisWindows).val());
        var options = $(thisWindows).find("option:selected");
        var optionsValue = options.val();
        if (optionsValue != "undefined" && optionsValue != "") {
            $(thisWindows).prev().val(optionsValue);
        } else {
            $(thisWindows).prev().val("");
        }

    }

    //whq8.30 添加 按钮功能
    function editProgramItem(oper) {
        var isfile = $("#myColFiled").val();
        
        var myItemId = $("#column_menu_itemid").val();//节目项ID
       // console.log(myItemId+".....");
        myItemId = $("#column_arrange_scid").val();
        var myMenuId = $("#h_edit_column_mid").val();//节目单ID
        var myTaskId = $("#h_edit_column_tid").val();
        //EditColumnItem.ashx  后台  myaction:    操作。。。
        if (isfile == 1) {
            TopTrip("归档栏目，不能修改！", 2);
            return;
        } else {
            if (oper == "editSource") {//编辑素材 //栏目
                //弹出 素材编辑页面，
                //if ($("#cl_range_selsclist li.current").attr("data-itemtype") == "1") {//栏目
                //    showMyDialogs("/common/column_edit.aspx?id=" + myItemId, "编辑栏目");
                //} else {
                showMyDialogs("/common/Source_edit.aspx?id=" + myItemId, "编辑素材");
                //}

                // $("#column_menu_itemname").val();//修改后的 节目项名称
            }
            else if (oper == "editTriggerType") {//节目触发类型
                //0 接前任务,1 绝对年月时间, 2 每天时间, 3 手动 ,4 空闲 ,5 暂不触发          
                var typeValue = $("input[name=s_edit_column_triggertype]:checked").val();
                var myTime = "";
                if (typeValue == "1") {
                    myTime = $("#t_edit_column_triggertime1").val();
                } else if (typeValue == "2") {
                    myTime = $("#t_edit_column_triggertime2").val();
                }
                $.post("ajax/EditColumnItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, triggerType: typeValue, triggerTime: myTime }, function (res) {
                    if (res > 0) {
                        TopTrip("节目触发类型 保存成功！", 1);
                    }
                });
            }
            else if (oper == "editDuringtime") {//editDuringtime 提交持续时间
                var hstr = $("#t_edit_column_duringtime_h").val();
                var mstr = $("#t_edit_column_duringtime_m").val();
                var sstr = $("#t_edit_column_duringtime_s").val();
                var myTime = "";
                myTime = parseInt(hstr) * 3600 + parseInt(mstr) * 60 + parseInt(sstr);
                $.post("ajax/EditColumnItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, myduringTime: myTime }, function (res) {
                    if (res > 0) {
                        TopTrip("持续时间 保存成功！", 1);
                    }
                });
                $("#cl_range_selsclist li.current").attr("data-duringtime", myTime);
                var oldHtml = $("#cl_range_selsclist .current").find(".time").html();
                var oldText = $("#cl_range_selsclist .current").find(".time").text();
                oldHtml = oldHtml.replace(oldText, "");
                $("#cl_range_selsclist .current").find(".time").html(oldHtml + hstr + ":" + mstr + ":" + sstr);
            }
            else if (oper == "resetTemplate") {//resetTemplate 重置为缺省显示模板 
                //[templateid] 设置为0， [bkpic] [options]设置为空。。。前台传值，后台写好。

                $.post("ajax/EditColumnItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, tempid: "0", bkpics: "", optionss: "" }, function (res) {
                    if (res > 0) {
                        TopTrip("模板 保存成功！", 1);
                        $("#t_edit_column_templet").val("缺省显示模板");
                    }
                });
            }
            else if (oper == "mySelfTemplate") {//mySelfTemplate 直接自定义设置显示属性
                //弹出  添加模板页面，模板名称--推荐度不要，，，不保存模板，只更新Menu表([bkpic] ，[options])
                showMyDialogs("/common/templet_add.aspx?itemid=" + myItemId + "&menuid=" + myMenuId + "&taskid=" + myTaskId, "自定义显示属性");
                //$.post("ajax/EditColumnItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, mybkpic: $("#myBkpic").val(), myoptions: $("#myOptions").val() }, function (res) {

                //});
                //t_edit_column_templet   h_edit_column_templet
                $("#t_edit_column_templet").val("自定义设置");//模板名称
                $("#h_edit_column_templet").val("0");//模板ID
            }
            else if (oper == "editPosition") {//editPostion 立即修改节目项排列顺序
                //节目项的顺序，不是连续的，，[postion]====修改可能影响原来的顺序
                $.post("ajax/EditColumnItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, itemPosition: $("#s_t_edit_column_postion").val(), taskName: $("#edit_column_taskname").val() }, function (res) {
                    if (res > 0) {
                        TopTrip("节目项排列顺序 保存成功！", 1);
                    }
                });
            }
            else if (oper == "editStatus") {//editStatus 立即修改节目项状态

                //_menu表更新 审核状态，更新 审核人 ，[checkstatus] [checkuserid]  //[wisepeak_menuitem]表 [checkman]
                $.post("ajax/EditColumnItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, checkStatus: $("#checkstatuslist").val() }, function (res) {
                    if (res > 0) {
                        $("#cl_range_selsclist li.current").attr("data-checkstatus", $("#checkstatuslist").val());
                        TopTrip("状态 保存成功！", 1);
                    }
                });
            }
        }
        
        /*
        options 字段 json数据：
{"tbkclr":"#ff0000","tfontclr":"#ffffff","tfontname":"宋体","tfontsize":"24","tfontb":"","tfonti":"i","twidth":"100%","theight":"100%","talign":"1","tcircle":"1","tdelay":"1","tscrollunit":"15"
,"tother":"0"}*/
    }
</script>
<style>
.bgImg{
    width: 30px;
    height: 30px;
    display: block;
    float: left;
    background: url(/images/tubiao.png) -53px -115px;
}
.shadowDiv {
        display: none;
        width: 100%;
        height: 100%;
        position: fixed;
        top: 0;
        left:0;
        background-color: rgba(43,50,56,0.5);
        z-index: 3003;
    }
    .shadowContent1 {
        width: 500px;
        background: #fff;
        margin: 0 auto;
        border-radius: 10px;
        border: 1px solid #aaa;
        box-sizing: border-box;
        min-height:200px;
        position: fixed;
        padding-bottom: 20px;
    }
    .urlTitle {
        height: 40px;
        border-bottom: 1px solid #aaa;
        line-height: 40px;
        text-align: center;
        font-size: 16px;
        font-weight: bold;
    }
    .shadowDiv .sumitBtn {
        display: block;
        width: 60px;
        height: 30px;
        line-height: 30px;
        margin-left: 20px;
        margin-top: 10px;
        float: left;
        background: #eee;
        border: 1px solid #ddd;
    }
    .sc_add_box ul li.li_ex {
        display:block;
        width: 800px;
        text-align: center;
        background: #fff; 
       
         margin-left:0px; 
    }
</style>
<form id="eidt_column_sc" name="eidt_column_sc" action="ajax/savemenu.ashx">
    <input type="hidden" id="h_edit_column_tid" name="h_edit_column_tid" runat="server" />
    <input type="hidden" id="h_edit_column_mid" name="h_edit_column_mid" runat="server" />
    <input type="hidden" id="h_edit_column_right" name="h_edit_column_right" runat="server" />
    <input type="hidden" id="h_edit_column_pagetype" name="h_edit_column_pagetype" runat="server" />
    <input type="hidden" id="column_menu_itemid" name="column_menu_itemid" runat="server"/>
    <div id="myDialogs" style="display:none;padding:0;">

    </div>
    <div class="sc_add_box sc_add0">
        <h6 style="width:160px;cursor: pointer;border-right:1px solid #ddd;background:#1ca8dd;color:#fff;">节目项属性<tt>(*为必填字段)</tt></h6>
        <h6 style="width:100px;cursor: pointer;padding-left:20px;">扩展属性</h6>
        <h6 style="width:100px;cursor: pointer;padding-left:20px;">参数设置</h6>
        <div class="zyyProgramEditContent1 zyyProgramEditContent">
            <div class="section">
                <ul class="clearfix">
                    <li><span class="label">节目项名称：</span><input type="text" class="inp_t" style="width: 230px;" id="edit_column_taskname" name="edit_column_taskname" runat="server" />
                        </li>
                    <li><span class="label">对应素材名称：</span><%--<span class="addxx" style="width: 230px;" id="s_edit_column_scname" runat="server"></span>--%>
                        <input type="text" class="inp_t" style="width: 230px;" readonly="readonly" runat="server" id="column_menu_itemname" name="column_menu_itemname" /><!--<a href="javascript:void(0)" title="编辑素材" style="margin-left: 10px;" onclick="editProgramItem('editSource')"><img src="/images/shezhi.png" border="0" width="26"></a>-->
                        <a href="javascript:void(0)" title="编辑素材" style="margin-left: 10px;" onclick="editProgramItem('editSource')"><b class="bgImg"></b></a>
                    </li>
                    <li style="float: left; margin-right: 10px;">
                        <span class="label">专用特色设置：</span>
                        <input type="radio" name="r_edit_column_myplayer" value="0" checked id="r_wu" /><label for="r_wu">无</label>
                        <input type="radio" name="r_edit_column_myplayer" value="1" id="r_player" /><label for="r_player">内置专用播放器</label>
                        <input type="radio" name="r_edit_column_myplayer" value="2" id="r_zjc" /><label for="r_zjc">操作系统自检测</label>
                        <input type="radio" name="r_edit_column_myplayer" value="3" id="r_column" /><label for="r_column">专用应用程序</label>
                        <label style="display:none;"><input type="radio" name="r_edit_column_myplayer" value="4" id="r_instr" />远程指令</label>
                        <%--<input type="radio" name="r_edit_column_myplayer" value="4" id="r_instr" /><label for="r_instr">远程指令</label>--%>
                        <input type="radio" name="r_edit_column_myplayer" value="5" id="r_tra" /><label for="r_tra">专用文件传输</label>&nbsp;&nbsp;<%--<span class="btn_ex" data-isshow="0" id="date_set_btn">参数设置</span>--%>
                    </li>
                    <%-- <li class="li_ex"><span class="label">更多描述：</span><input class="inp_t" style="width: 480px;" id="s_edit_column_descript" name="s_edit_column_descript" type="text" /></li>--%>
                    
                    <li style="float: left; margin-right: 10px; padding: 10px 0; height: 20px;">
                        <span class="label" style="height: 15px; line-height: 15px;">节目触发类型：</span>
                        <input type="radio" name="s_edit_column_triggertype" value="0" id="cv_remwu" checked /><label for="cv_remwu">接前任务</label>
                        <input type="radio" name="s_edit_column_triggertype" value="1" id="cv_times" /><label for="cv_times">绝对年月时间</label>
                        <input type="radio" name="s_edit_column_triggertype" value="2" id="cv_days" /><label for="cv_days">每天时间</label>
                        <input type="radio" name="s_edit_column_triggertype" value="3" id="cv_shou" /><label for="cv_shou">手动</label>
                        <input type="radio" name="s_edit_column_triggertype" value="4" id="cv_empty" /><label for="cv_empty">空闲</label>
                        <input type="radio" name="s_edit_column_triggertype" value="5" id="cv_chufa" /><label for="cv_chufa">暂不触发</label>
                    </li>
                    <li style="display: none;"><span class="label">触发时间：</span><input class="inp_t" style="width: 150px;" type="text" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd', onpicked: function myfunction() { editProgramItem('editTriggerType'); } })" readonly="readonly" id="t_edit_column_triggertime1" name="t_edit_column_triggertime1"></li>
                    <li style="display: none;"><span class="label">触发时间：</span><input class="inp_t" style="width: 150px;" type="text" onclick="WdatePicker({ dateFmt: 'HH:mm:ss', onpicked: function myfunction() { editProgramItem('editTriggerType'); } })" readonly="readonly" id="t_edit_column_triggertime2" name="t_edit_column_triggertime2"></li>
                    <li style="padding-bottom:10px;">
                        <span class="label">持续时间：</span>
                        <span style="width: 75px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <input type="text" class="inp_t" style="width:35px;text-align:center;margin-right:11px;" id="t_edit_column_duringtime_h" name="edit_column_duringtime_h" value="1" />时</span>
                        <span style="width: 75px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <input type="text" class="inp_t" style="width:35px;text-align:center;margin-right:11px;" id="t_edit_column_duringtime_m" name="edit_column_duringtime_m" value="0" />分</span>
                        <span style="width: 75px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <input type="text" class="inp_t" style="width:35px;text-align:center;margin-right:11px;" id="t_edit_column_duringtime_s" name="edit_column_duringtime_s" value="0" />秒</span>.
                        <%--<span class="label">增加/减少时长：</span> <span style="width: 80px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <select id="select_addtime">
                                <option data-unit="s" data-type="1" value="5">+5 秒</option>
                                <option data-unit="s" data-type="2" value="5">-5 秒</option>
                                <option data-unit="h" data-type="3" value="2">+2 倍</option>
                                <option data-unit="h" data-type="3" value="5">+5 倍</option>
                            </select></span>--%>
                         <span  style="display: inline-block; float: left; height: 28px; line-height: 28px;margin-right:30px;">
                                <!-- <a href="javascript:void(0)" title="立即提交持续时间" onclick="editProgramItem('editDuringtime')" style="display: inline-block;">
                            <img src="/images/shezhi.png" width="26" border="0"></a>-->
                             <a href="javascript:void(0)" title="立即提交持续时间" onclick="editProgramItem('editDuringtime')" style="display: inline-block;">
                            <b class="bgImg"></b></a>
                          </span>
                         <span style="display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <select id="select_addtime" class="inp_t" style="width: 80px;">
                                <option data-unit="h" data-type="0" value="5" selected>还原</option>
                                <option data-unit="s" data-type="0" value="5">5 秒</option>
                                <option data-unit="s" data-type="0" value="10">10 秒</option>
                                <option data-unit="s" data-type="0" value="15">15 秒</option>
                                <option data-unit="s" data-type="0" value="30">30 秒</option>
                                <option data-unit="s" data-type="0" value="60">1 分钟</option>
                                <option data-unit="s" data-type="0" value="3600">60 分钟</option>
                            </select><%--+5秒  -5秒  +2倍 +5倍--%>
                            <!--<a href="javascript:void(0)" onclick="adddotime(5);" class="edit_plustimes" style="margin-left:10px;background:url('/images/tubiao.png') -223px -328px"></a><a href="javascript:void(0)" class="edit_plustimes" onclick="adddotime(-5);" style="background:url('/images/tubiao.png') -247px -328px"></a><a href="javascript:void(0)" class="edit_plustimes" onclick="adddotime('x2');" style="background:url('/images/tubiao.png') -243px -363px"></a><a href="javascript:void(0)" class="edit_plustimes" onclick="adddotime('x5');" style="background:url('/images/tubiao.png') -267px -364px"></a>-->
                             <a href="javascript:void(0)" onclick="adddotime(5);" class="edit_plustimes edit_dftimes">+5s</a><a href="javascript:void(0)" class="edit_plustimes edit_dftimes" onclick="adddotime(-5);">-5s</a><a href="javascript:void(0)" class="edit_plustimes edit_dftimes" onclick="adddotime('x1');">1h</a><a href="javascript:void(0)" class="edit_plustimes edit_dftimes" onclick="adddotime('x2');">2h</a>
                        </span>
                    </li>
                </ul>
            </div>
            
        </div>
        <div class="zyyProgramEditContent2 zyyProgramEditContent" style="display:none;">
        <%--<h6>扩展属性</h6>
        <span class="ex_task" id="edit_menu_add_ex" data-isshow="0">展开</span>--%>
            <div class="section" id="column_slide_cookie">
                <ul>
                    <li>
                        <span class="label">复制文件到终端：</span>
                                <input name="r_edit_column_copyto" type="radio" value="0" id="cv_nos"/><label for="cv_nos">否</label>
                                <input name="r_edit_column_copyto" type="radio" value="1" id="cv_yes"/><label for="cv_yes">是</label>
                                <input type="checkbox" name="c_edit_column_canreact" id="c_edit_column_canreact"/><label for="c_edit_column_canreact">允许前端交互反馈</label>
                                <input class="inp_c" name="c_edit_column_openflag" type="checkbox" id="cv_sucai"><label for="cv_sucai">不让外部用户看到该素材</label>&nbsp;
                   
                    </li>
                    <li><span class="label">播放优先级：</span>
                        <select class="inp_tsmall inp_t" id="s_edit_column_merit" name="s_edit_column_merit" style="width:45px;">
                            <option value="0">0</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                        </select>
                        <div class="bfq"><input type="checkbox" name="c_edit_column_usesubject" value="1" id="cv_lam"/><label for="cv_lam" style="font-size:12px;color:#474747;">下面循环及模板设置使用节目单中本栏目项的</label></div>
                    </li>
                    <li><span class="label">循环播放次数：</span>
                        <input type="text" class="inp_t" style="width: 40px" id="t_edit_column_circletime" value="0" name="t_edit_column_circletime" />

                        <div class="bfq">
                            <input name="r_edit_column_circleeveryday" type="radio" value="1" id="cv_noes"/><label for="cv_noes">否</label>
                    <input name="r_edit_column_circleeveryday" type="radio" value="0" id="cv_ok"/><label for="cv_ok">是</label>
                        </div>
                    </li>
                    <li><span class="label">循环开始时间：</span>
                        <input type="text" class="inp_t" style="width: 150px" id="t_edit_column_starttime" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" name="t_edit_column_starttime" />
                    </li>
                    <li><span class="label">循环结束时间：</span>
                        <input type="text" class="inp_t" style="width: 150px" id="t_edit_column_expiretime2" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" name="t_edit_column_expiretime2" />
                    </li>
                    <%--<li><span class="label">窗口显示状态：</span>
                        <div class="bfq">
                            <input type="radio" name="r_edit_column_zorder" value="0" id="cv_size"><label for="cv_size">缺省大小</label>
                          
                        <input type="radio" name="r_edit_column_zorder" value="1" checked="" id="cv_zuida"><label for="cv_zuida">最大</label>  
                        <input type="radio" name="r_edit_column_zorder" value="2" id="cv_zx"><label for="cv_zx">最小</label>
                        <input type="radio" name="r_edit_column_zorder" value="3" id="cv_zq"><label for="cv_zq">最前</label>  
                        <input type="radio" name="r_edit_column_zorder" value="4" id="cv_zqzd"><label for="cv_zqzd">最前最大</label>
                        <input type="radio" name="r_edit_column_zorder" value="5" id="cv_zqzx"><label for="cv_zqzx">最前最小</label>
                        </div>
                    </li>--%>
                    <li><span class="label">模板：</span><input class="inp_t" style="width: 150px;" id="t_edit_column_templet" name="t_edit_column_templet"type="text" readonly="readonly" value="默认模板"><input type="hidden" id="h_edit_column_templet" name="h_edit_column_templet" value="1" runat="server" /><div><a href="javascript:void(0)" onclick="edit_column_sc_seltemp()" title="选择显示模板" style="display:inline-block;"><img src="/images/icon_yulan.png" width="26" border="0" style="margin-left:10px;"></a><a href="javascript:void(0)" style="display:inline-block;width: 26px;height: 26px;background: url(/images/tubiaoa.png) -268px -102px;margin-left:10px;" onclick="editProgramItem('resetTemplate')"  title="重置为缺省显示模板" ></a>&nbsp;<a href="javascript:void(0)" style="display:inline-block;width: 26px;height: 26px;background: url(/images/tubiaoa.png) -268px -136px;" title="直接自定义设置显示属性" onclick="editProgramItem('mySelfTemplate')"></a></div>
                    </li>
                    <li><span class="label">节目项排列顺序：</span><input class="inp_t" value="1" style="width:40px;" type="text" id="s_t_edit_column_postion" name="s_t_edit_column_postion" runat="server">
                        <!--<a href="javascript:void(0)" title="立即修改节目项排列顺序" style="display: inline-block;" onclick="editProgramItem('editPosition')">
                            <img src="/images/shezhi.png" width="26" border="0" style="margin-left:5px;"></a>-->
                        <a href="javascript:void(0)" title="立即修改节目项排列顺序" style="display: inline-block;" onclick="editProgramItem('editPosition')">
                            <b class="bgImg"></b></a>
                        <input value="1" type="hidden" id="t_edit_column_oldpostion" name="t_edit_column_oldpostion" runat="server">
                    </li>
                    <li><span class="label">节目项状态：</span><select style="width: 115px" name="checkstatuslist" id="checkstatuslist" class="inp_t">
			    <option value="0" selected="">未审核
			    </option><option value="1">审核通过
			    </option><option value="4">暂停分发
			    </option><option value="2">欠费
			    </option><option value="8">信息不符
			    </option><option value="16">信息过期
			    </option><option value="32">政治反动
			    </option><option value="64">宗教
			    </option><option value="128">色情暴力
			    </option><option value="256">恶意攻击
			    </option><option value="512">机密
			    </option><option value="1024">隐私
			    </option><option value="2048">病毒
			    </option><option value="4096">发布修改
                </option><option value="8192">发布删除
                </option><option value="16384">其它
			    </option></select>
                    <!--<a href="javascript:void(0)" title="立即修改节目项状态" style="display: inline-block;" onclick="editProgramItem('editStatus')">
                            <img src="/images/shezhi.png" width="26" border="0" style="margin-left:15px;"></a>-->
                        <a href="javascript:void(0)" title="立即修改节目项状态" style="display: inline-block;" onclick="editProgramItem('editStatus')">
                            <b class="bgImg"></b></a>
                        &nbsp;<input class="inp_tsmall inp_t" value="" type="hidden" style="width: 40px" id="checkstatus" name="checkstatus" runat="server" /><input class="inp_tsmall inp_t" value="" type="hidden" style="width: 40px" id="checkuserid" name="checkuserid" runat="server" /><input class="inp_tsmall inp_t" value="" type="hidden" style="width: 40px" id="userid" name="userid" runat="server" /></li>
                </ul>
            </div>
        </div>
        <div class="zyyProgramEditContent zyyProgramEditContent3" style="display:none;">
            <div class="section">
                <ul class="clearfix">
                    <li class="li_ex" style="padding-top: 10px;"><span class="label">应用程序名/参数：</span><input class="inp_t" style="width: 230px;" id="s_edit_column_exetask" name="s_edit_column_exetask" type="text" />&nbsp;
                         <span class="label">选择应用程序名：</span>
                        <select name="prgnamelist" id="sel_edit_column_pro" class="inp_t" style="width: 180px;">
                            <option value=""></option>
                            <option value="NBPlayer.exe">0-通用音视频/电视播放器</option>
                            <option value="TVPlayer.exe">1-电视播放/换台器</option>
                            <option value="AV4Player.exe">2-WMV音视频播放器</option>
                            <option value="UrlPlayer.exe">3-网页播放器</option>
                            <option value="FlashPlayer.exe">4-动画播放器</option>
                            <option value="MultiCastVideoPlayer.exe">5-音视频广播接收器</option>
                            <option value="HKVideoPlayer.exe">6-HK高清编码器播放器</option>
                            <option value="WiseCCCPlayer.exe">7-远程桌面查看器</option>
                            <option value="PptView.exe">8-幻灯片播放器</option>
                            <option value="PowerPnt.exe">9-幻灯片编辑器</option>
                            <option value="RecordPlayer.exe">10-记录浏览器</option>
                            <option value="RS232Commander.exe">11-串口/指令发送器</option>
                            <option value="WiseSendInfo.exe">12-智能数据处理器</option>
                            <option value="UrlToMyHtm.exe">13-网页下载转换器</option>
                            <option value="KillProcess.exe">14-进程清理器</option>
                            <option value="-o :0:0:60:hhmmss:circletime">15-视频同步参数</option>
                            <option value="ClockPlayer.exe">16-表盘时钟显示</option>
                            <option value="TimePmtPlayer.exe">17-数字时钟显示</option>
                        </select>
                    </li>
                    <li class="li_ex"><span class="label">
                        <input type="checkbox" name="c_edit_column_param_setloc" value="1" />播放窗口位置：</span>
                        <select name="moreInfoChoiseList" id="moreInfoChoise" class="inp_t" style="width: 237px;height:28px;">
                            <option value=""></option>
                            <option value=" 20,0,120,100 -m1 -l -t">数字时钟左上角</option> 
                            <option value=" 20,0,600,100 -mf -l -t">数字时钟左上角(长)</option>
                            <option value=" 1760,0,120,100 -m1 -l -t">数字时钟右上角</option>
                            <option value=" 1320,0,600,100 -mf -l -t">数字时钟右上角(长)</option>
                            <option value=" 20,980,120,100 -m1 -l -t">数字时钟左下角</option>
                            <option value=" 20,980,600,100 -mf -l -t">数字时钟左下角(长)</option>
                            <option value=" 1760,980,120,100 -m1 -l -t">数字时钟右下角</option>
                            <option value=" 1320,980,600,100 -mf -l -t">数字时间右上角(长)</option>
                            <option value=" 0,1020,1920,60 -t -l">滚动字幕</option>
                            <option value=" 0,1020,1920,60 -t -l">滚动字幕(log)</option>
                            <option value=" 40,1020,1840,60 -t -l">滚动字幕 (区域)</option>
                            <option value=" 40,1020,1840,60 -t -l">滚动字幕log (区域)</option>
                            <option value=" 0,0,1920,1080 -t">通知（向上滚动，标题不参与滚动）</option>
                        </select>
                        <input class="inp_t" style="width: 213px;position:relative;margin-left:-237px;" id="s_edit_column_param_window" name="s_edit_column_param_window" type="text" />
                        <tt>（给出顶点位置坐标及宽度高度，用逗号隔开。如0,0,80,80）</tt>

                    </li>
                    <li class="li_ex">
                        <ul class="bfq">
                            <li>
                                <input type="checkbox" name="c_edit_column_param_setpstmsg" value="1" id="cv_tongzhi" /><label for="cv_tongzhi">播放完毕后通知系统</label></li>
                            <li>
                                <input type="checkbox" name="c_edit_column_param_settopmost" value="1" id="cv_zuiqian" /><label for="cv_zuiqian">窗口总在最前显示</label></li>
                            <li>
                                <input type="checkbox" name="c_edit_column_param_setminimize" value="1" id="cv_zuixiao" /><label for="cv_zuixiao">播放时最小化窗口</label></li>
                            <li>
                                <input type="checkbox" name="c_edit_column_param_setclose" value="1" id="cv_cancal" /><label for="cv_cancal">播放完毕后自动退出</label></li>
                        </ul>
                    </li>
                    <li class="li_ex">
                        <span class="label">透明：</span>
                        <ul class="bfq">
                            <li>
                                <input type="radio" name="r_edit_column_param_settrans" value="0" id="r_trans" /><label for="r_trans">不透明显示</label></li>
                            <li>
                                <input type="radio" name="r_edit_column_param_settrans" value="1" id="r_display" /><label for="r_display">透明显示</label></li>
                            <li>
                                <input type="radio" name="r_edit_column_param_settrans" value="2" id="r_half" /><label for="r_half">半透明显示</label></li>
                        </ul>
                    </li>
                    <li class="li_ex">
                        <span class="label">罩子形状：</span>
                        <ul class="bfq">
                            <li>
                                <input type="radio" name="r_edit_column_param_setmask" value="0" id="r_normal" /><label for="r_normal">无</label></li>
                            <li>
                                <input type="radio" name="r_edit_column_param_setmask" value="1" id="r_pic" /><label for="r_pic">由镂空图片给出</label></li>
                            <li>
                                <input type="radio" name="r_edit_column_param_setmask" value="2" id="r_wenzi" /><label for="r_wenzi">由显示文字给出</label></li>
                        </ul>
                    </li>
                    <li class="li_ex moreInfoControl">
                        <input type="hidden" id="sourcePath" name="sourcePath" value=""  runat="server"/>
                        <span class="label">更多描述：</span>
                        <%--<select name="moreInfoList" id="moreInfo" class="inp_t" style="width: 504px;">
                            <option value=""></option>
                            <option value="-f udp://@224.224.1.1:5004">视频广播 频道1</option>
                        
                            <option value="-f rtsp://admin:12345@192.168.1.221/h264/ch1/main/av_stream">音视频编码器直播</option>
                            <option value="-f rtsp://192.168.1.200:554/Devicehc8://192.168.1.201:8000:1:0?username=admin&password=12345">流媒体服务器直播</option>
                            <option value="-f c9;s0">电视 中央一台</option>
                            <option value="-w -120,10,112,36 -m -l -t">时钟标参数</option>
                            <option value="-o :0:0:60:hhmmss:circletime">视频同步播放参数</option>
                            <option value="-f 192.168.1.2:0 -o 1013000 -e /*0,0*/">远程桌面查看参数</option>
                            <option value="-yesmoni">网页显示守护</option>
                        </select>--%>
                        <input class="inp_t" style="width: 480px;position:relative;height:24px;" id="s_edit_column_descript" name="s_edit_column_descript" type="text" /><%--top:-26px;--%>
                        <span id="zyyEditNet()" onclick="zyyEditNet()"class="label" style="width:80px;margin-left:10px;text-align:center;background:#f5f5f5;padding:0;border:1px solid #c1c1c1;border-radius:5px;color:#a8a8a8;height:24px;line-height:24px;">网页编辑</span>

                    </li>
                </ul>
                <div class="shadowDiv">
                <div class="shadowContent1">
                    <p class="urlTitle">网页编辑</p>
	                <img class="closeNetImg"><%-- src="images/allTitle/closeImg.png" --%>
	                <div class="shadowContent">
    	
    	                <div class="addContent">
                        </div>
                        <input class="sumitBtn submitnet" type="submit" value="提交" onclick="submitnet()"/>
                        <input class="sumitBtn yulanBtn" type="button" value="取消" onclick="cancleNet()"/>
                    </div>
                </div>
                </div>
            </div>        
        </div>
        <div class="sc_add_btn clearfix" style="margin-left:125px;clear:both;"><!-- style="margin-left: 190px;"-->
        </div>
    </div>
</form>

<div class="source_con" id="edit_column_seltemplete" style=" background: #f7f7f7; padding-top: 10px; position: fixed; margin-left: -500px; left: 50%; z-index: 1000; max-height: 687px; top: 100px; border: 1px solid #dddddd; display: none;"></div>
<script type="text/javascript">
    var oldtime = 0;
    var isfirstadd = true;
    $(function () {
        //if ($.cookie("ColumnArrSlide") == "0" && $("#column_slide_cookie").css("display") == "none") {//如果cookie 为0 触发click
        //if ($.cookie("ColumnArrSlide") != $("#edit_menu_add_ex").attr("data-isshow")) {
        //    //$("#column_slide_cookie").css("display","block");//
        //    $("#edit_menu_add_ex").click();
        //}
        if ($.cookie("ColumnArrSlide") == "1" && $("#edit_menu_add_ex").attr("data-isshow") == 0) {
            $("#edit_menu_add_ex").attr("data-isshow", 1);
            $("#edit_menu_add_ex").removeClass("ex_task").addClass("ex_task2").text("收起");
            $("#column_slide_cookie").show();//slideUp  slideDown

        }
        else if ($.cookie("ColumnArrSlide") == "0" && $("#edit_menu_add_ex").attr("data-isshow") == 1) {
            $("#edit_menu_add_ex").attr("data-isshow", 0);
            $("#edit_menu_add_ex").removeClass("ex_task2").addClass("ex_task").text("展开");
            $("#column_slide_cookie").hide();

        }

    }),
            $("#select_addtime").click(function () {
                var unit = $("#select_addtime").find("option:selected").attr("data-unit");
                var type = $("#select_addtime").find("option:selected").attr("data-type");
                var val = parseInt($(this).val());
                if (unit == "s") {
                    if (type == 0) {
                        setdotime(val);
                    }
                    if (type == 1) {
                        adddotime(val);
                    }
                    if (type == 2) {
                        adddotime(-val);
                    }
                }
                if (unit == "h") {
                    if (type == 0) {
                        setdotime('还原');
                    }
                    if (type == 1) {
                        adddotime('x1');
                    }
                    if (type == 2) {
                        adddotime('x2');
                    }
                    if (type == 3) {
                        adddotime('x10');
                    }
                }
            });
    function setdotime(dotime) {
        if (dotime == "还原") {
            dotime = oldtime;
        }
        document.eidt_column_sc.t_edit_column_duringtime_h.value = Math.floor(dotime / 60 / 60);
        document.eidt_column_sc.t_edit_column_duringtime_m.value = Math.floor(dotime / 60) % 60;
        document.eidt_column_sc.t_edit_column_duringtime_s.value = dotime % 60;
    }
    function adddotime(difftime) {
        var istimes = false;
        if (difftime == "x1") {
            // difftime = oldtime + 3600;
            difftime = 3600;
            istimes = true;
        }
        if (difftime == "x2") {
            //difftime = oldtime + 3600*2;
            difftime = 3600 * 2;
            istimes = true;
        }
        if (difftime == "x10") {
            difftime = oldtime * 10;
            istimes = true;
        }

        var dotime;
        dotime = 0;
        dotime = dotime + parseInt(document.eidt_column_sc.t_edit_column_duringtime_h.value);
        dotime = dotime * 60 + parseInt(document.eidt_column_sc.t_edit_column_duringtime_m.value);
        dotime = dotime * 60 + parseInt(document.eidt_column_sc.t_edit_column_duringtime_s.value);

        //if (isfirstadd && istimes) { dotime = dotime - oldtime; }
        isfirstadd = false;
        if (difftime >= 0) {
            dotime = dotime + difftime;
            document.eidt_column_sc.t_edit_column_duringtime_h.value = Math.floor(dotime / 60 / 60);
            document.eidt_column_sc.t_edit_column_duringtime_m.value = Math.floor(dotime / 60) % 60;
            document.eidt_column_sc.t_edit_column_duringtime_s.value = dotime % 60;
        }
        else {
            if ((dotime + difftime) <= 0)
                dotime = 0;
            else
                dotime = dotime + difftime;
            if (dotime <= 0) dotime = 1;
            document.eidt_column_sc.t_edit_column_duringtime_h.value = Math.floor(dotime / 60 / 60);
            document.eidt_column_sc.t_edit_column_duringtime_m.value = Math.floor(dotime / 60) % 60;
            document.eidt_column_sc.t_edit_column_duringtime_s.value = dotime % 60;
        }
    }
</script>
