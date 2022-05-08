<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="edit_program_menu.aspx.cs" Inherits="Web.company.program.edit_program_menu" %>

<style>
    .cv_color {
        background-color: #f7f7f7;
        border-radius: 4px;
        border: 1px solid #BEBEBE;
        padding: 3px;
    }

        .cv_color:hover {
            background-color: #61c6f8;
        }

    .colume_positioned {
        margin-right: 10px;
    }

    .bgImg {
        width: 30px;
        height: 30px;
        display: block;
        float: left;
        /*background: url(/images/tubiao.png) 31px 474px;*/
        background: url(/images/tubiao.png) -53px -115px;
    }

    .sync {
        display: inline-block;
        margin: -2px 0 0 20px;
        /* padding-left: 10px; */
        width: 120px;
        height: 20px;
        border: 1px solid #c1c1c1;
        border-radius: 3px;
        /* background: url(/images/icon_ex.png) no-repeat right; */
        color: #a8a8a8;
        line-height: 20px;
        cursor: pointer;
        text-align: center;
    }

        .sync:hover {
            background: #1ca8dd;
            color: #fff;
        }

    .setProgramSync {
        display: none;
        width: 600px;
        height: 280px;
        border: 1px solid #aaa;
        background: #fff;
        background: #fff;
        position: absolute;
        top: 800px;
        margin-left: 300px;
    }

        .setProgramSync ul {
            width: 100%;
            margin-top: 30px;
        }

            .setProgramSync ul li {
                display: block;
                width: 100%;
                padding-bottom: 5px;
                color: #474747;
                font-size: 12px;
            }

                .setProgramSync ul li span.label {
                    float: left;
                    display: block;
                    padding-right: 10px;
                    width: 120px;
                    color: #474747;
                    text-align: right;
                    font-size: 14px;
                    font-size: 12px;
                    line-height: 28px;
                    height: 28px;
                }

                .setProgramSync ul li label {
                    line-height: 28px;
                }

                .setProgramSync ul li .inp_t {
                    float: left;
                    display: block;
                    padding-left: 5px;
                    width: 190px;
                    height: 26px;
                    border: 1px solid #cdcdcd;
                    -moz-border-radius: 3px;
                    border-radius: 3px;
                    color: #666;
                    line-height: 26px;
                }

        .setProgramSync .del {
            position: absolute;
            top: 2px;
            right: 5px;
            z-index: 33;
            display: block;
            width: 20px;
            height: 20px;
            background: url(/images/icon_btn.png) no-repeat;
            background-position: -240px -30px;
        }

    .shadowDiv {
        display: none;
        width: 100%;
        height: 100%;
        position: fixed;
        top: 0;
        left: 0;
        background-color: rgba(43,50,56,0.5);
        z-index: 50;
    }

    .shadowContent1 {
        width: 500px;
        background: #fff;
        margin: 0 auto;
        border-radius: 10px;
        border: 1px solid #aaa;
        box-sizing: border-box;
        min-height: 200px;
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
    .sc_add_box ul li .bfq li {
        width:220px;
    }
    .sc_add_box ul li.li_ex {
        display: block;
        width: 950px;
        text-align: center;
        background: #fff;
        margin-left: 0px;
    }
    .sc_add_box ul li span.label {
        width:180px;
    }
</style>
<script type="text/javascript">
    var oldtime = 0;
    var isfirstadd = true;

    $(function () {
        getJsonValue();
        // $("input[name=c_edit_program_openflag]").prop("checked", true);
        // $("input[name=c_edit_program_canreact]").prop("checked", true);
        //var modelright = $("#h_edit_program_menu_right").val();
        //if (modelright == 2) {////只有编排权限
        //    $("#s_edit_program_checkstatus").attr("disabled", "disabled");
        //}
        //if (modelright == 3) {//只有 审核权限
        //    $("input[type=text]").attr("readonly", "readonly");
        //    $("input[type=checkbox]").attr("disabled", "disabled");
        //}
        var buttonHtml = '<div style="clear:both"><span class="inp_btn client_bianji"  style="position:relative;" title="修改"><b style="left:20px;"></b><input type="submit" name="modifybtn" value="' + getLanguageMsg("修改", $.cookie("yuyan")) + '" class="btn" style="padding-left:20px;"/></span> btnpass<span class="inp_btn copybtn colume_positioned" title="复制添加"><b style="left:12px"></b><input type="button" name="copyadd" value="' + getLanguageMsg("复制添加", $.cookie("yuyan")) + '" class="btn" style="padding-left:35px;"/></span><span class="inp_btn de_shuxing colume_positioned" title="设为缺省属性"><b></b><input type="button" name="setdefaultoption" value="' + getLanguageMsg("设为缺省属性", $.cookie("yuyan")) + '" class="btn" style="padding-left:20px;"/></span><span class="inp_btn de_empty colume_positioned" title="清除缺省属性"><b></b><input type="button" name="nodefaultoption" value="' + getLanguageMsg("清除缺省属性", $.cookie("yuyan")) + '" class="btn" style="padding-left:20px;"/></span><span class="inp_btn resetbtn colume_positioned" title="重置"><b style="left:20px"></b><input type="reset" value="' + getLanguageMsg("重置", $.cookie("yuyan")) + '" class="btn" style="padding-left:25px;"/></span><span class="inp_btn shouqi colume_positioned" title="' + getLanguageMsg("收起", $.cookie("yuyan")) + '"><b></b><input type="button" value="' + getLanguageMsg("收起", $.cookie("yuyan")) + '" class="btn" onclick="edit_program_sc_close()" style="padding-left:20px;"/></span></div>';
        if ($("#h_edit_program_menu_pagetype").val() == "0") {//编排。。。
            if ($("#checkstatus").val() == "1") {//'已通过' 的节目项，不显示‘通过’按钮
                buttonHtml = buttonHtml.replace("btnpass", "");
            } else {
                buttonHtml = buttonHtml.replace('btnpass', '<span class="inp_btn btn_pass" title="通过" ><b style="left:20px;"></b><input type="button" name="checkok" value="' + getLanguageMsg("通过", $.cookie("yuyan")) + '" class="btn" style="padding-left:20px;"/></span>');//class="inp_btn tongguo"
            }
            $(".sc_add_btn").html(buttonHtml);
        }
        else {//编排审核。。。
            buttonHtml = 'btnpass<span class="inp_btn btn_refuse" title="不通过"> <input type="button" value="' + getLanguageMsg("不通过", $.cookie("yuyan")) + '" class="btn" /></span>';//type="reset"
            $("input[type=text]").attr("readonly", "readonly");
            $("input[type=radio]").attr("disabled", "disabled");
            $("input[type=check]").attr("disabled", "disabled");
            $("select").attr("disabled", "disabled");
            if ($("#checkstatus").val() == "1") {
                buttonHtml = buttonHtml.replace("btnpass", "");
            } else {
                //buttonHtml = buttonHtml.replace('btnpass', '<span class="inp_btn btn_pass" title="通过"><input type="button" value="通过" class="btn" /></span>');
                buttonHtml = buttonHtml.replace('btnpass', '<span class="inp_btn btn_pass" title="通过"><b style="left:20px;"></b><input type="button"  name="checkok" value="' + getLanguageMsg("通过", $.cookie("yuyan")) + '" class="btn" /></span>');
            }
            $(".sc_add_btn").html(buttonHtml);
        }
        switchLanguage("#program_arrange_editpage", 1, "program_menu.aspx");
        /***页面进入控件绑定值时间***********************************/
        $.ajax({
            type: 'post',
            url: 'ajax/getmenudetai.ashx',
            async: false,
            data: {
                menuid: $("#h_edit_program_menu_menuid").val(),
                taskid: $("#h_edit_program_menu_taskid").val()
            },
            dataType: 'text',
            success: function (data) {
                if (data != "-1") {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        $("#edit_program_taskname").val(item.taskname);
                        if (item.openflag == 1) {
                            $("input[name=c_edit_program_openflag]").prop("checked", true);
                        }
                        else {
                            $("input[name=c_edit_program_openflag]").prop("checked", false);
                        }
                        var paramStr = item.exetask;
                        $("#s_edit_program_exetask").val(paramStr);
                        $("#sel_edit_program_pro").val(paramStr);
                        var tv = 0;
                        tv = paramStr.indexOf(" ");
                        if (tv > 0) {
                            var startStr = paramStr.substring(0, tv);
                            if (startStr.indexOf(".exe") > 0 || startStr.indexOf(":") > 0) {
                                $("#sel_edit_program_pro").val(startStr);
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
                                $("input[name=c_edit_program_param_setloc]").attr("checked", "checked");
                                $("#s_edit_program_param_window").val(lsStr);
                            }
                        }
                        tv = paramStr.indexOf("-p");
                        if (tv > 0) {
                            $("input[name=c_edit_program_param_setpstmsg]").attr("checked", "checked");
                        }
                        tv = paramStr.indexOf("-t");
                        if (tv > 0) {
                            $("input[name=c_edit_program_param_settopmost]").attr("checked", "checked");
                        }
                        tv = paramStr.indexOf("-m");
                        if (tv > 0) {
                            $("input[name=c_edit_program_param_setminimize]").attr("checked", "checked");
                        }
                        tv = paramStr.indexOf("-s");
                        if (tv > 0) {
                            $("input[name=c_edit_program_param_setclose]").attr("checked", "checked");
                        }
                        tv = paramStr.indexOf("-l");
                        var tv2 = paramStr.indexOf("-h");
                        if (tv > 0 || tv2 > 0) {
                            if (tv > 0) {
                                $("input[name=r_edit_program_param_settrans][value=1]").attr("checked", "checked");
                            }
                            else if (tv2 > 0) {
                                $("input[name=r_edit_program_param_settrans][value=2]").attr("checked", "checked");
                            }
                        }
                        else {
                            $("input[name=r_edit_program_param_settrans][value=0]").attr("checked", "checked");
                        }
                        tv = paramStr.indexOf("-r");
                        tv2 = paramStr.indexOf("-e");
                        if (tv > 0 || tv2 > 0) {
                            if (tv > 0) {
                                $("input[name=r_edit_program_param_setmask][value=1]").attr("checked", "checked");
                            }
                            else if (tv2 > 0) {
                                $("input[name=r_edit_program_param_setmask][value=2]").attr("checked", "checked");
                            }
                        }
                        else {
                            $("input[name=r_edit_program_param_setmask][value=0]").attr("checked", "checked");
                        }
                        $("#s_edit_program_descript").val(item.descript);

                        $("input[name=s_edit_program_triggertype][value=" + item.triggertype + "]").attr("checked", "checked");
                        if (item.triggertype == 1) {
                            $("#t_edit_program_triggertime1").val(item.triggertime);
                            $("#t_edit_program_triggertime1").parent("li").show();
                        }
                        if (item.triggertype == 2) {
                            $("#t_edit_program_triggertime2").val(item.triggertime);
                            $("#t_edit_program_triggertime2").parent("li").show();
                        }
                        $("#t_edit_program_duringtime_h").val(parseInt(item.duringtime / 3600, 10));
                        $("#t_edit_program_duringtime_m").val(parseInt((item.duringtime % 3600) / 60));
                        $("#t_edit_program_duringtime_s").val(((item.duringtime % 3600) % 60) % 60);

                        //扩展属性
                        if (item.copyto & 0x02) {
                            $("input[name=c_edit_program_canreact]").prop("checked", true);
                        }
                        if (item.copyto & 0x04) {
                            $("input[name=c_edit_program_usesubject]").prop("checked", true);
                        }
                        $("#s_edit_program_merit").val(item.merit);
                        $("#t_edit_program_circletime").val(item.circletime);
                        $("input[@type=radio][name=r_edit_program_copyto][value=" + (item.copyto & 0x01) + "]").prop("checked", true);
                        $("input[@type=radio][name=r_edit_program_circleeveryday][value=" + item.circleeveryday + "]").attr("checked", true);
                        $("#t_edit_program_starttime").val(item.starttime);
                        $("#t_edit_program_expiretime2").val(item.expiretime);
                        $("input[@type=radio][name=r_edit_program_zorder][value=" + item.zorder % 6 + "]").attr("checked", true);
                        $("#t_edit_program_postion").val(item.postion);
                        $("#t_edit_program_oldpostion").val(item.postion);
                        $("input[@type=radio][name=r_edit_program_myplayer][value=" + item.myplayer % 6 + "]").attr("checked", true);
                        debugger;
                        $("#t_edit_program_templet").val(item.templateid);
                        $("#h_edit_program_templet_bkpic").val(item.bkpic);
                        $("#h_edit_program_templet_options").val(item.options);
                        edit_program_sc_bindtemplet(item.templateid, item.bkpic, item.options);//,[bkpic],[options]
                        //$("#checkstatus").val(item.checkstatus);
                        $("#checkuserid").val(item.checkuserid);
                        $("#userid").val(item.userid);
                        $("#checkstatuslist").val($("#checkstatus").val());

                        //$("#checkstatuslist").val(item.checkstatus)
                        //console.log("item.myplayer:" + item.myplayer);
                    });
                    //$("#moreInfo").change(function () {
                    //    var options = $("#moreInfo option:selected");
                    //    var optionsValue = options.val();
                    //    if (optionsValue != "undefined") {
                    //        //document.getElementById("moreInfo option:selected").value = optionsValue;
                    //        $("#s_edit_program_descript").val(optionsValue);
                    //    }
                    //})

                }
                else {
                    LoginTimeOut();
                }
            }
        })
        getoldtime();
       // switchLanguage("#program_arrange_editpage", 1, "program_menu.aspx");
        $("input[name=s_edit_program_triggertype]").click(function () {
            if ($(this).val() == 1) {
                $("#t_edit_program_triggertime1").val(getNowFormatDate());
                $("#t_edit_program_triggertime1").parent("li").show();
                $("#t_edit_program_triggertime2").parent("li").hide();
            }
            else if ($(this).val() == 2) {
                $("#t_edit_program_triggertime2").val(getNowFormatTime());
                $("#t_edit_program_triggertime2").parent("li").show();
                $("#t_edit_program_triggertime1").parent("li").hide();
            }
            else {
                $("#t_edit_program_triggertime2").parent("li").hide();
                $("#t_edit_program_triggertime1").parent("li").hide();
            }
        });

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
        //表单提交
        $("#eidt_program_menu").Validform({
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
                $("#program_range_selitemlist li.current").attr("data-checkstatus", $("#checkstatuslist").val());
                $("#checkstatus").val($("#checkstatuslist").val());
                if ($("#programIsFiled").val() == "1") {//节目单归档， 不能修改
                    return false;
                }
                if ($("input[name=c_edit_program_openflag]").prop("checked")) {
                    $("input[name=c_edit_program_openflag]").val("on");
                } else { $("input[name=c_edit_program_openflag]").val(""); }
                if ($("input[name=c_edit_program_canreact]").prop("checked")) {
                    $("input[name=c_edit_program_canreact]").val("on");
                } else { $("input[name=c_edit_program_canreact]").val(""); }
                if ($("input[name=c_edit_program_usesubject]").prop("checked")) {
                    $("input[name=c_edit_program_usesubject]").val("on");
                } else { $("input[name=c_edit_program_usesubject]").val(""); }
            },
            ajaxPost: true,
            // postonce: false,
            callback: function (d) {
                //d = $.parseJSON("'"+d+"'");
                //debugger;
                //console.log(d+"   "+d.status);
                if (d.status == "y") {
                    TopTrip("节目项修改完毕", 1);
                    var hstr = $("#t_edit_program_duringtime_h").val();
                    var mstr = $("#t_edit_program_duringtime_m").val();
                    var sstr = $("#t_edit_program_duringtime_s").val();
                    if (hstr == "") hstr = "0";
                    if (mstr == "") mstr = "0";
                    if (sstr == "") sstr = "0";
                    if (hstr == "0" && mstr == "0" && sstr == "0") {
                        hstr = "1";
                        $("#t_edit_program_duringtime_h").val("1");
                    }
                    var oldHtml = $("#program_range_selitemlist .current").find(".time").html();
                    var oldText = $("#program_range_selitemlist .current").find(".time").text();
                    oldHtml = oldHtml.replace(oldText, "");
                    $("#program_range_selitemlist .current").find(".time").html(oldHtml + hstr + ":" + mstr + ":" + sstr);
                    //todo...根据 节目触发类型， 显示不同图标 
                    var typeIcon = 'url("/images/tubiaoa.png") repeat scroll -1px -171px';//节目触发类型， 显示的图标
                    var mytype = $("input[name='s_edit_program_triggertype']:checked").val();
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
                    $("#program_range_selitemlist .current").find(".time b")[0].style.background = typeIcon;
                    //$("input[name='r_edit_program_myplayer']:checked").val() //2操作系统自检测 ,3专用应用程序 ,4远程指令 ,5专用文件传输
                    var mycType = $("input[name='r_edit_program_myplayer']:checked").val();
                    var oldTitle = $("#program_range_selitemlist .current a").attr("title");
                    oldTitle = oldTitle.split("-")[0];
                    var newTitle = "";
                    switch (parseInt(mycType)) {
                        case 2:
                        
                            newTitle = getLanguageMsg("操作系统自检测", $.cookie("yuyan")); break;
                        case 3:
                            newTitle = getLanguageMsg("专用应用程序", $.cookie("yuyan")); break;
                        case 4:
                            newTitle = getLanguageMsg("远程指令", $.cookie("yuyan")); break;
                        case 5:
                            newTitle = getLanguageMsg("专用文件传输", $.cookie("yuyan")); break;

                    }
                    if (newTitle != "") { $("#program_range_selitemlist .current a").attr("title", oldTitle + "-" + newTitle); }
                    //$("input[name='s_edit_program_triggertype']:checked").val() // 0接前任务, 1绝对年月时间, 2每天时间, 3手动, 4空闲, 5暂不触发
                    //$("#program_arrange_editpage").html("").slideUp();
                }
                else {
                    if (d.info == "-1") {
                        LoginTimeOut();
                    }
                    else if (d.info == "-100") {
                        TopTrip(getLanguageMsg("节目单已归档，不能修改", $.cookie("yuyan")),2);
                    }
                    else {
                        TopTrip(getLanguageMsg("系统错误，请联系管理员", $.cookie("yuyan")),3);
                    }
                }
                //$("#program_arrange_edititem_box").slideUp();
            }
        });
        $("#sel_edit_program_pro").change(function () {
            edit_menu_paramchange();
        });
        //$("#sel_edit_program_pro").click(function () {

        //    edit_menu_paramchange();
        //});
        $("#s_edit_program_exetask").blur(function () {
            // edit_menu_paramchange();//将此处注释掉的原因是当修改“s_edit_program_exetask”时可随意修改，不影响提交的过程
        });
        //$("#moreInfo").change(function () {
        //    editProgramDescriptChange();
        //})
        $("#moreInfoChoise").change(function () {
            moreInfoChoiseChange();
        })
        $("input[name=c_edit_program_param_setloc]").click(function () {
            edit_menu_paramchange();
        });
        $("#s_edit_program_param_window").blur(function () {
            edit_menu_paramchange();
        });
        $("input[name=c_edit_program_param_setpstmsg]").click(function () {
            edit_menu_paramchange();
        });
        $("input[name=c_edit_program_param_settopmost]").click(function () {
            edit_menu_paramchange();
        });
        $("input[name=c_edit_program_param_setminimize]").click(function () {
            edit_menu_paramchange();
        });
        $("input[name=c_edit_program_param_setclose]").click(function () {
            edit_menu_paramchange();
        });
        $("input[name=r_edit_program_param_settrans]").click(function () {
            edit_menu_paramchange();
        });
        $("input[name=r_edit_program_param_setmask]").click(function () {
            edit_menu_paramchange();
        });
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
                    setdotime(getLanguageMsg("还原", $.cookie("yuyan")));
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


        // $("#edit_menu_add_ex").click();//页面第一次加载，，点击 没用。

        //if ($.cookie("ProgramSlide") == "1" && $("#edit_menu_add_ex").attr("data-isshow") == 0) {
        //    $("#edit_menu_add_ex").attr("data-isshow", 1);
        //    $("#edit_menu_add_ex").removeClass("ex_task2").addClass("ex_task").text("收起");
        //    $("#program_slide_cookie").show();//slideUp  slideDown

        //}
        //else if ($.cookie("ProgramSlide") == "0" && $("#edit_menu_add_ex").attr("data-isshow") == 1) {
        //    $("#edit_menu_add_ex").attr("data-isshow", 0);
        //    $("#edit_menu_add_ex").removeClass("ex_task").addClass("ex_task2").text("展开");
        //    $("#program_slide_cookie").hide();

        //}
        $("input[name=s_edit_program_triggertype]").click(function () {
            editProgramItem("editTriggerType");
        });
        $("h6").click(function () {

            $("h6").attr("data-isshow", 0);
            $(this).attr("data-isshow", 1);
            $(".zyyProgramEditContent").hide();
            $(".zyyProgramEditContent" + ($(this).index() + 1)).show();
            $("h6").css({
                "background": "#fff",
                "color": "#1ca8dd"
            })
            $(this).css({
                "background": "#1ca8dd",
                "color": "#fff"
            })
        })
    });
    function edit_menu_paramchange() {

        //var param = $("#sel_edit_program_pro").val();
        param = $("#sel_edit_program_pro").val();
        var exeTask = $("#s_edit_program_exetask").val();
        if (param == "") {
            param = exeTask;
        }

        //var param = $("#s_edit_program_exetask").val();
        //if (param != "" && param.indexOf(" ")>=0) {
        //    param = param.split(" ")[0]
        //}


        // debugger;
        //if ($("#sel_edit_program_pro").val() == "") {

        //    param = exeTask.split('-')[0].trim();
        //} else {//
        //    param = param + " " + exeTask.slice(exeTask.indexOf('-'), exeTask.length);//直播  的参数。
        //}
        //if ($("#sel_edit_program_pro").val() == "") {
        //    param = $("#s_edit_program_exetask").val().split('-')[0].trim();
        //} //$("#s_edit_program_exetask").val()

        if ($("input[name=c_edit_program_param_setloc]").attr("checked") == "checked" && $("#s_edit_program_param_window").val() != "" && param.indexOf("-w") == -1) {

            param = param + " -w " + $("#s_edit_program_param_window").val();
        } //else if ($("input[name=c_edit_program_param_setloc]").attr("checked") != "checked") {
        //    param = param.replace(" -w", "");
        //}
        if ($("input[name=c_edit_program_param_setpstmsg]").attr("checked") == "checked" && param.indexOf("-p") == -1) {
            param = param + " " + "-p";
        } //else  if ($("input[name=c_edit_program_param_setpstmsg]").attr("checked") != "checked"){
        //    param = param.replace(" -p", "");
        //}
        if ($("input[name=c_edit_program_param_settopmost]").attr("checked") == "checked" && param.indexOf("-t") == -1) {
            param = param + " " + "-t";
        } //else if ($("input[name=c_edit_program_param_settopmost]").attr("checked") != "checked") {
        //    param = param.replace(" -t", "");
        //}
        if ($("input[name=c_edit_program_param_setminimize]").attr("checked") == "checked" && param.indexOf("-m") == -1) {
            param = param + " " + "-m";
        } //else if ($("input[name=c_edit_program_param_setminimize]").attr("checked") != "checked") {
        //    param = param.replace(" -m", "");
        //}
        if ($("input[name=c_edit_program_param_setclose]").attr("checked") == "checked" && param.indexOf("-s") == -1) {
            param = param + " " + "-s";
        } //else if ($("input[name=c_edit_program_param_setclose]").attr("checked") != "checked") {
        //    param = param.replace(" -s", "");
        //}
        if ($("input[name=r_edit_program_param_settrans]:checked").val() == "1" && param.indexOf("-l") == -1) {
            param = param + " " + "-l";
        } //else if ($("input[name=r_edit_program_param_settrans]").attr("checked") != "checked") {
        //    param = param.replace(" -l", "");
        //}
        if ($("input[name=r_edit_program_param_settrans]:checked").val() == "2" && param.indexOf("-h") == -1) {
            param = param + " " + "-h";
        } //else if ($("input[name=r_edit_program_param_settrans]").attr("checked") != "checked") {
        //    param = param.replace(" -h", "");
        //}
        if ($("input[name=r_edit_program_param_setmask]:checked").val() == "1" && param.indexOf("-r") == -1) {
            param = param + " " + "-r";
        } //else if ($("input[name=r_edit_program_param_setmask]").attr("checked") != "checked") {
        //    param = param.replace(" -r", "");
        //}
        if ($("input[name=r_edit_program_param_setmask]:checked").val() == "2" && param.indexOf("-e") == -1) {
            param = param + " " + "-e";
        } //else if ($("input[name=r_edit_program_param_setmask]").attr("checked") != "checked") {
        //    param = param.replace(" -e", "");
        //}

        $("#s_edit_program_exetask").val(param);
    }
    //播放窗口位置
    function moreInfoChoiseChange() {

        var options = $("#moreInfoChoise option:selected");
        var optionsValue = options.val();
        if (optionsValue != "undefined" && optionsValue != "") {
            //document.getElementById("moreInfo option:selected").value = optionsValue;
            $("#s_edit_program_param_window").val(optionsValue);
            $("[name='c_edit_program_param_setloc']").attr("checked", true);//勾选 ‘播放窗口位置’ 
        } else {
            $("#s_edit_program_param_window").val("");
            $("[name='c_edit_program_param_setloc']").attr("checked", false);
        }
        edit_menu_paramchange();
        // $("[name='c_edit_program_param_setloc']").click();
    }
    //function editProgramDescriptChange() {
    //    var options = $("#moreInfo option:selected");
    //    var optionsValue = options.val();
    //    if (optionsValue != "undefined") {
    //        //document.getElementById("moreInfo option:selected").value = optionsValue;
    //        $("#s_edit_program_descript").val(optionsValue);
    //    }
    //}
    function is_null(object_name, tishi, word, kongge) {
        var string;
        string = new String(object_name);

        if (string.length == 0) {
            if (tishi == 1) {
                //alert(word);
                TopTrip(word, 3);
            }
            return false;
        }

        if (kongge == 1) {
            string = javaTrim(string);
        }

        if (string.length == 0) {
            if (tishi == 1) {
                //alert(word);
            }
            return false;
        }
        return true;
    }

    function javaTrim(str) {
        var i = 0;
        var j;
        var len = str.length;

        trimstr = "";
        if (j < 0) return trimstr;
        flagbegin = true;
        flagend = true;

        while (flagbegin == true) {
            if (str.charAt(i) == " ") {
                i++;
                flagbegin = true;
            }
            else {
                flagbegin = false;
            }
        }

        j = len - 1;
        var k = 0;
        while (flagend == true) {
            if (str.charAt(j) == " ") {
                j--;
                flagend = true;
                k++;
            }
            else {
                flagend = false;
            }
        }

        if (str.length == i) {
            trimstr = "";
            return trimstr;
        }

        trimstr = str.substring(i, j + 1);
        return trimstr;
    }

    function IsNumric(num) {
        var flag;
        flag = true;
        if (num.length == 0) return false;
        cmp = "0123456789";
        for (var i = 0; i < num.length; i++) {
            tst = num.substring(i, i + 1);
            if (cmp.indexOf(tst) < 0) {
                flag = false;
                return false;
            }
        }
        return flag;
    }

    $(".btn_ex").die().live("click", function () {
        // debugger;
        if ($(this).attr("data-isshow") == "0") {
            $(this).attr("data-isshow", "1");
            $(this).addClass("btn_ex2");
            $(".li_ex").show();
        }
        else {
            $(this).attr("data-isshow", "0");
            $(this).removeClass("btn_ex2");
            $(".li_ex").hide();
        }
    });
    function edit_program_sc_bindtemplet(tempid, myBkpic, myOptions) {

        if (myBkpic != "" || myOptions != "") {
            $("#t_edit_program_templet").val(getLanguageMsg("自定义设置", $.cookie("yuyan")));
            $("#h_edit_program_templet").val(tempid);
        } else {
           // setTimeout(function () {//
                //翻译代码走的慢(按顺序 从上往下),  模板信息获取、赋值后，才走翻译，导致显示错误。所以延时请求模板信息
                $.ajax({
                    type: 'post',
                    url: '/company/templet/ajax/gettempinfo.ashx',
                    async: true,
                    data: {
                        "tempid": tempid
                    },
                    dataType: 'text',
                    success: function (data) {
                        var json = strToJson(data);
                    
                        $.each(json.Table, function (idx, item) {
                            $("#t_edit_program_templet").val(item.template);//数据库中的内容，不用翻译
                            $("#h_edit_program_templet").val(tempid);
                        })
                    }
                });
           // }, 2000);
        }
    }
    function edit_program_menu_seltemp() {
        ClearTempListHtml();//    /company/templet/templetlist.aspx
        $("#edit_program_seltemplete").load("/common/templetlist.aspx", { "t": 3 }, function () {
            $("#overlay").show();
            $("#edit_program_seltemplete").fadeIn();
        });

        var str = $("frame").src;
        var str1 = str.split("/");
        var str2 = str.split("templateid=");
        var str3 = str2[1].split("&")[1];
        var str4 = str2[0] + "templateid=" + $("#h_edit_program_templet").val() + "&" + str3;
        $('frame').src = str4;

    }
    function edit_program_sc_close() {
        $("#program_arrange_editpage").slideUp();
    }
    $("#edit_menu_add_ex").die().live("click", function () {//.die().live  "click", 
        if ($(this).attr("data-isshow") == "0" || $.cookie("ProgramSlide") == "0") {// || $.cookie("ProgramSlide")=="0"
            $(this).removeClass("ex_task").addClass("ex_task2").text(getLanguageMsg("收起", $.cookie("yuyan")));
            $(this).next(".section").show();
            $(this).attr("data-isshow", 1);
            $.cookie("ProgramSlide", 1);//更新cookie
        }
        else if ($(this).attr("data-isshow") == "1" || $.cookie("ProgramSlide") == "1") {// || $.cookie("ProgramSlide") == "1"
            $(this).attr("data-isshow", 0);
            $(this).removeClass("ex_task2").addClass("ex_task").text(getLanguageMsg("展开", $.cookie("yuyan")));
            $(this).next(".section").hide();
            $.cookie("ProgramSlide", 0);//更新cookie
        }// 下拉 和 收起 时候 存 cookie

    });
    $("#t_edit_program_duringtime_h").live("blur", function () {
        var h = $("#t_edit_program_duringtime_h").val();
        var m = $("#t_edit_program_duringtime_m").val();
        var s = $("#t_edit_program_duringtime_s").val();
        var oldHtml = $("#program_range_selitemlist .current").find(".time").html();
        var oldText = $("#program_range_selitemlist .current").find(".time").text();
        oldHtml = oldHtml.replace(oldText, "");
        $("#program_range_selitemlist .current").children("a").children(".time").html(oldHtml + h + ":" + m + ":" + s);
    });
    $("#t_edit_program_duringtime_m").live("blur", function () {
        var h = $("#t_edit_program_duringtime_h").val();
        var m = $("#t_edit_program_duringtime_m").val();
        var s = $("#t_edit_program_duringtime_s").val();
        var oldHtml = $("#program_range_selitemlist .current").find(".time").html();
        var oldText = $("#program_range_selitemlist .current").find(".time").text();
        oldHtml = oldHtml.replace(oldText, "");
        $("#program_range_selitemlist .current").children("a").children(".time").html(oldHtml + h + ":" + m + ":" + s);
    });
    $("#t_edit_program_duringtime_s").live("blur", function () {
        var h = $("#t_edit_program_duringtime_h").val();
        var m = $("#t_edit_program_duringtime_m").val();
        var s = $("#t_edit_program_duringtime_s").val();
        var oldHtml = $("#program_range_selitemlist .current").find(".time").html();
        var oldText = $("#program_range_selitemlist .current").find(".time").text();
        oldHtml = oldHtml.replace(oldText, "");
        $("#program_range_selitemlist .current").children("a").children(".time").html(oldHtml + h + ":" + m + ":" + s);
    });
    $(".btn_pass").die().live("click", function () {
        if ($("#programIsFiled").val() == "1") {//节目单归档， 不能修改
            TopTrip(getLanguageMsg("节目单已归档，不能修改", $.cookie("yuyan")), 2);
            return false;
        }
        $.ajax({
            type: 'post',
            url: 'ajax/checkmenu.ashx',
            data: {
                "menuid": $("#h_edit_program_menu_menuid").val(),
                "taskid": $("#h_edit_program_menu_taskid").val(),
                "checkstatus": 1,
                "reason": ""
            },
            dataType: 'text',
            success: function (data) {
                if (data == -1) {
                    LoginTimeOut();
                }
                else {
                    if (data == 0) {
                        TopTrip(getLanguageMsg("系统错误，请联系管理员！", $.cookie("yuyan")), 3);
                    }
                    if (data > 0) {
                        TopTrip(getLanguageMsg("节目项审核成功！", $.cookie("yuyan")), 1);
                    }
                    if (data == "-100") {
                        TopTrip(getLanguageMsg("节目单归档， 不能修改！", $.cookie("yuyan")), 2);
                    }
                }
            }
        })
    })
    $(".btn_refuse").live("click", function () {
        if ($("#programIsFiled").val() == "1") {//节目单归档， 不能修改
            TopTrip(getLanguageMsg("节目单已归档，不能修改", $.cookie("yuyan")), 2);
            return false;
        } else {
            ShowCheckMenuItemTrip();
        }
    });
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

    $("#btn_checkitem").die().live("click", function () {
        var boxId = $(this).attr("data-id");
        var sel = $("#sel_check_item").val();
        $.ajax({
            type: 'post',
            url: 'ajax/checkmenu.ashx',
            data: {
                "menuid": $("#h_edit_program_menu_menuid").val(),
                "taskid": $("#h_edit_program_menu_taskid").val(),
                "checkstatus": sel,
                "reason": $("#text_checkreason").val()
            },
            dataType: 'text',
            success: function (data) {

                if (data == -1) {
                    LoginTimeOut();
                }
                else {
                    if (data == 0) {
                        TopTrip(getLanguageMsg("系统错误，请联系管理员！", $.cookie("yuyan")), 3);
                    }
                    if (data > 0) {
                        $("#" + boxId).hide();
                        TopTrip(getLanguageMsg("节目项审核成功！", $.cookie("yuyan")), 1);
                    }
                    if (data == "-100") {
                        TopTrip(getLanguageMsg("节目单已归档， 不能修改！", $.cookie("yuyan")), 2);
                    }
                }
            }
        })
    })
    $("#templet_list_closebtn").die().live("click", function () {
        $("#edit_program_seltemplete").fadeOut(function () {
            $("#overlay").fadeOut();
            $("#edit_program_seltemplete").empty();
        });
    });
    function edit_program_sc_close() {
        $("#program_arrange_editpage").slideUp();
    }
    function SetTriggerTime(obj, flag, auto) {
        // debugger;
        if (auto) {//节目触发类型： s_edit_program_triggertype[1]绝对年月时间 ,s_edit_program_triggertype[2]每天时间
            if (document.eidt_program_menu.s_edit_program_triggertype[1].checked) {
                WdatePicker({ el: $dp.$(obj), dateFmt: 'yyyy-MM-dd HH:mm:ss' });
            }
            else if (document.eidt_program_menu.s_edit_program_triggertype[2].checked) {
                WdatePicker({ el: $dp.$(obj), dateFmt: 'HH:mm:ss' });
            }
        } else {
            if (flag == 0) {
                WdatePicker({ el: $dp.$(obj), dateFmt: 'HH:mm:ss' });
            }
            else {
                WdatePicker({ el: $dp.$(obj), dateFmt: 'yyyy-MM-dd HH:mm:ss' });
            }
        }
    }
    function SetTriggerTimeSync(obj, flag, auto) {
        if (auto) {//节目触发类型： s_edit_program_triggertype[1]绝对年月时间 ,s_edit_program_triggertype[2]每天时间
            if (document.eidt_program_menu.s_edit_program_triggertype[1].checked) {
                WdatePicker({ el: document.getElementsByName(obj)[0], dateFmt: 'yyyy-MM-dd HH:mm:ss' });
            }
            else if (document.eidt_program_menu.s_edit_program_triggertype[2].checked) {
                WdatePicker({ el: document.getElementsByName(obj)[0], dateFmt: 'HH:mm:ss' });
            }
        } else {
            if (flag == 0) {
                WdatePicker({ el: document.getElementsByName(obj)[0], dateFmt: 'HH:mm:ss' });
            }
            else {
                WdatePicker({ el: document.getElementsByName(obj)[0], dateFmt: 'yyyy-MM-dd HH:mm:ss' });
            }
        }
    }

    function SetTimeRange(obj, obj2, addday) {
        // debugger;
        var tdate = new Date();
        tdate.setDate(tdate.getDate() + (addday % 10));

        var y = tdate.getFullYear();
        var mo = tdate.getMonth() + 1;
        var mostr = mo;
        if (mo < 10) mostr = "0" + mo;
        var day = tdate.getDate();
        var daystr = day;
        if (day < 10) { daystr = "0" + day }
        var getstr = "";
        if (Math.floor(addday / 10) == 1)//白天
            getstr = y + "-" + mostr + "-" + daystr + " 06:00:01";
        else
            getstr = y + "-" + mostr + "-" + daystr + " 00:00:01";
        document.getElementById(obj).value = getstr;
        if (Math.floor(addday / 10) == 1)//白天
            getstr = y + "-" + mostr + "-" + daystr + " 20:00:00";
        else
            getstr = y + "-" + mostr + "-" + daystr + " 23:59:59";
        document.getElementById(obj2).value = getstr;
    }

    function getoldtime() {
        oldtime = oldtime + parseInt(document.eidt_program_menu.t_edit_program_duringtime_h.value);
        oldtime = oldtime * 60 + parseInt(document.eidt_program_menu.t_edit_program_duringtime_m.value);
        oldtime = oldtime * 60 + parseInt(document.eidt_program_menu.t_edit_program_duringtime_s.value);
        if (oldtime <= 0) oldtime = 3600;
    }
    function setdotime(dotime) {
        if (dotime == "还原") {
            dotime = oldtime;
        }
        document.eidt_program_menu.t_edit_program_duringtime_h.value = Math.floor(dotime / 60 / 60);
        document.eidt_program_menu.t_edit_program_duringtime_m.value = Math.floor(dotime / 60) % 60;
        document.eidt_program_menu.t_edit_program_duringtime_s.value = dotime % 60;
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
        dotime = dotime + parseInt(document.eidt_program_menu.t_edit_program_duringtime_h.value);
        dotime = dotime * 60 + parseInt(document.eidt_program_menu.t_edit_program_duringtime_m.value);
        dotime = dotime * 60 + parseInt(document.eidt_program_menu.t_edit_program_duringtime_s.value);

        //if (isfirstadd && istimes) { dotime = dotime - oldtime; }
        isfirstadd = false;
        if (difftime >= 0) {
            dotime = dotime + difftime;
            document.eidt_program_menu.t_edit_program_duringtime_h.value = Math.floor(dotime / 60 / 60);
            document.eidt_program_menu.t_edit_program_duringtime_m.value = Math.floor(dotime / 60) % 60;
            document.eidt_program_menu.t_edit_program_duringtime_s.value = dotime % 60;
        }
        else {
            if ((dotime + difftime) <= 0)
                dotime = 0;
            else
                dotime = dotime + difftime;
            if (dotime <= 0) dotime = 1;
            document.eidt_program_menu.t_edit_program_duringtime_h.value = Math.floor(dotime / 60 / 60);
            document.eidt_program_menu.t_edit_program_duringtime_m.value = Math.floor(dotime / 60) % 60;
            document.eidt_program_menu.t_edit_program_duringtime_s.value = dotime % 60;
        }
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
    //whq8.28 添加 按钮功能
    function editProgramItem(oper) {
        var myItemId = $("#program_menu_itemid").val();//节目项ID
        var myMenuId = $("#h_edit_program_menu_menuid").val();//节目单ID
        var myTaskId = $("#h_edit_program_menu_taskid").val();
        // var isfile = $("#myColFiled").val();
        var isfile = $("#programIsFiled").val();
        //EditProgramItem.ashx  后台  myaction:    操作。。。
        if (isfile == 1) {
            TopTrip(getLanguageMsg("归档节目单，不能修改！", $.cookie("yuyan")), 2);
            return;
        } else {
            if (oper == "editSource") {//编辑素材 //栏目
                //弹出 素材编辑页面，
                if ($("#program_range_selitemlist li.current").attr("data-itemtype") == "1") {//栏目
                    //showMyDialogs("/common/column_edit.aspx?id=" + myItemId, "编辑栏目");
                    //showMyDialogs("/company/column/column_arrange.aspx?type=0&id=" + myItemId + "&name=" + $("#program_menu_itemname").val(), "编排栏目");
                    window.location.href = "/company/column/column_arrange.aspx?type=0&id=" + myItemId + "&name=" + $("#program_menu_itemname").val();
                } else {
                    showMyDialogs("/common/Source_edit.aspx?id=" + myItemId, getLanguageMsg("编辑素材", $.cookie("yuyan")));
                }

                // $("#program_menu_itemname").val();//修改后的 节目项名称
            }
            else if (oper == "editTriggerType") {//节目触发类型
                //0 接前任务,1 绝对年月时间, 2 每天时间, 3 手动 ,4 空闲 ,5 暂不触发          
                var typeValue = $("input[name=s_edit_program_triggertype]:checked").val();
                var myTime = "";
                if (typeValue == "1") {
                    myTime = $("#t_edit_program_triggertime1").val();
                } else if (typeValue == "2") {
                    myTime = $("#t_edit_program_triggertime2").val();
                }
                $.post("ajax/EditProgramItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, triggerType: typeValue, triggerTime: myTime }, function (res) {
                    if (res > 0) {
                        TopTrip(getLanguageMsg("节目触发类型 保存成功！", $.cookie("yuyan")), 1);
                    }
                });
                //$("#program_range_selitemlist li.current").attr("data-duringtime", myTime);
                //var oldHtml = $("#program_range_selitemlist .current").find(".time").html();
                //var oldText = $("#program_range_selitemlist .current").find(".time").text();
                //oldHtml = oldHtml.replace(oldText, "");
                //$("#program_range_selitemlist .current").find(".time").html(oldHtml + hstr + ":" + mstr + ":" + sstr);
            }
            else if (oper == "editDuringtime") {//editDuringtime 提交持续时间
                var hstr = $("#t_edit_program_duringtime_h").val();
                var mstr = $("#t_edit_program_duringtime_m").val();
                var sstr = $("#t_edit_program_duringtime_s").val();
                var myTime = "";
                myTime = parseInt(hstr) * 3600 + parseInt(mstr) * 60 + parseInt(sstr);
                $.post("ajax/EditProgramItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, myduringTime: myTime }, function (res) {
                    if (res > 0) {
                        TopTrip(getLanguageMsg("持续时间 保存成功！", $.cookie("yuyan")), 1);
                    }
                });
                $("#program_range_selitemlist li.current").attr("data-duringtime", myTime);
                var oldHtml = $("#program_range_selitemlist .current").find(".time").html();
                var oldText = $("#program_range_selitemlist .current").find(".time").text();
                oldHtml = oldHtml.replace(oldText, "");
                $("#program_range_selitemlist .current").find(".time").html(oldHtml + hstr + ":" + mstr + ":" + sstr);
            }
            else if (oper == "resetTemplate") {//resetTemplate 重置为缺省显示模板 
                //[templateid] 设置为0， [bkpic] [options]设置为空。。。前台传值，后台写好。

                $.post("ajax/EditProgramItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, tempid: "0", bkpics: "", optionss: "" }, function (res) {
                    debugger;
                    if (res > 0) {
                        TopTrip(getLanguageMsg("模板 保存成功！", $.cookie("yuyan")), 1);
                        $("#t_edit_program_templet").val(getLanguageMsg("缺省显示模板", $.cookie("yuyan")));
                    }
                });
            }
            else if (oper == "mySelfTemplate") {//mySelfTemplate 直接自定义设置显示属性
                //弹出  添加模板页面，模板名称--推荐度不要，，，不保存模板，只更新Menu表([bkpic] ，[options])
                showMyDialogs("/common/templet_add.aspx?itemid=" + myItemId + "&menuid=" + myMenuId + "&taskid=" + myTaskId, getLanguageMsg("自定义显示属性", $.cookie("yuyan")));
                //$.post("ajax/EditProgramItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, mybkpic: $("#myBkpic").val(), myoptions: $("#myOptions").val() }, function (res) {

                //});
                //
                debugger;
                $("#t_edit_program_templet").val(getLanguageMsg("自定义显示属性", $.cookie("yuyan")));//模板名称
                $("#h_edit_program_templet").val("0");//模板ID
            }
            else if (oper == "editPosition") {//editPostion 立即修改节目项排列顺序
                //节目项的顺序，不是连续的，，[postion]====修改可能影响原来的顺序
                $.post("ajax/EditProgramItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, itemPosition: $("#t_edit_program_postion").val(), layoutid: $("#h_edit_program_framelayoutid").val(), layoutpostion: $("#h_edit_program_fposition").val(), oldPosition: $("#t_edit_program_oldpostion").val() }, function (res) {
                    if (res > 0) {
                        TopTrip(getLanguageMsg("节目项排列顺序 保存成功！", $.cookie("yuyan")), 1);
                    }
                });
            }
            else if (oper == "editStatus") {//editStatus 立即修改节目项状态

                //_menu表更新 审核状态，更新 审核人 ，[checkstatus] [checkuserid]  //[wisepeak_menuitem]表 [checkman]
                $.post("ajax/EditProgramItem.ashx", { myaction: oper, itemid: myItemId, menuid: myMenuId, taskid: myTaskId, checkStatus: $("#checkstatuslist").val() }, function (res) {
                    if (res > 0) {
                        $("#program_range_selitemlist li.current").attr("data-checkstatus", $("#checkstatuslist").val());
                        TopTrip(getLanguageMsg("状态 保存成功！", $.cookie("yuyan")), 1);
                    }
                });
            }
        }

        /*
        options 字段 json数据：
{"tbkclr":"#ff0000","tfontclr":"#ffffff","tfontname":"宋体","tfontsize":"24","tfontb":"","tfonti":"i","twidth":"100%","theight":"100%","talign":"1","tcircle":"1","tdelay":"1","tscrollunit":"15"
,"tother":"0"}*/
    }
    function addSync() {
        var exetaskVal = $("#s_edit_program_exetask").val() + " -o :0:0:60:hhmmss:circletime";
        $("#r_player").attr("checked", "checked");
        $(".li_ex").show();
        $("#s_edit_program_exetask").val(exetaskVal);
        $("#cv_days").attr("checked", "checked");
        //$("#t_edit_program_triggertime2").parent("li").show();
        $("#t_edit_program_starttime").val("");
        $("#t_edit_program_triggertime1").val("06:00:00");
        $("#t_edit_program_expiretime2").val("23:00:00");
    }
    function deleteSync() {
        $("#program_slide_cookie").find("li:eq(3)").show();
        $("#program_term").find("li:eq(19)").find("input[value=0]").attr("checked", "checked");
        $("#t_edit_program_triggertime1").val(" ");
        $("#t_edit_program_expiretime2").val(" ");
        if ($("#s_edit_program_exetask").val().indexOf(" -o") >= 0) {
            var index = $("#s_edit_program_exetask").val().lastIndexOf(" -o");
            $("#s_edit_program_exetask").val($("#s_edit_program_exetask").val().substring(0, index));
        }

        //$("#s_edit_program_exetask").val($("#s_edit_program_exetask").val());
    }
    function setSync() {
        $(".setProgramSync").show();
        var featureSelected = $("#program_term").find("li:eq(2)").find("input[type=radio]:checked").val();
        var triggerSelected = $("#program_term").find("li:eq(19)").find("input[type=radio]:checked").val();
        $(".setProgramSync").find("li:eq(0)").find("input[value=" + featureSelected + "]").attr("checked", "checked");
        $(".setProgramSync").find("li:eq(2)").find("input[value=" + triggerSelected + "]").attr("checked", "checked");
        $("#t_edit_program_triggertime1_sync").val($("#t_edit_program_triggertime1").val());
        $("#s_edit_program_exetask_sync").val($("#s_edit_program_exetask").val());
        $("#t_edit_program_expiretime2_sync").val($("#t_edit_program_expiretime2").val());
    }
    $(".setSelect").change(function () {
        $(".setInput").val($(".setSelect option:selected").text());
    })
    function seto() {

        if ($("#s_edit_program_exetask_sync").val().indexOf(" -o") >= 0) {
            var index = $("#s_edit_program_exetask_sync").val().lastIndexOf(" -o");
            var obj = $("#s_edit_program_exetask_sync").val().substring(0, index);
            $("#s_edit_program_exetask_sync").val(obj);
        } else {
            $("#s_edit_program_exetask_sync").val($("#s_edit_program_exetask_sync").val() + " -o :0:0:60:hhmmss:circletime");
        }
    }
    function setSuccess() {
        $(".setProgramSync").hide();
        var featureSelected = $(".setProgramSync").find("li:eq(0)").find("input[type=radio]:checked").val();
        var triggerSelected = $(".setProgramSync").find("li:eq(2)").find("input[type=radio]:checked").val();
        $("#program_term").find("li:eq(2)").find("input[value=" + featureSelected + "]").attr("checked", "checked");
        $("#program_term").find("li:eq(19)").find("input[value=" + triggerSelected + "]").attr("checked", "checked");
        $("#t_edit_program_triggertime1").val($("#t_edit_program_triggertime1_sync").val());
        $("#s_edit_program_exetask").val($("#s_edit_program_exetask_sync").val());
        $("#t_edit_program_expiretime2").val($("#t_edit_program_expiretime2_sync").val());

    }
    function setCancel() {
        $(".setProgramSync").hide();
        $(".setProgramSync .inp_t").val("");
        // debugger;
        $(".setProgramSync input[name=r_edit_program_myplayer_sync]").attr("checked", false);
        $(".setProgramSync input[name=s_edit_program_triggertype_sync]").attr("checked", false);

    }
    //弹出网页编捷页面
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

                $(".submitnet").val(getLanguageMsg("提交", $.cookie("yuyan")));
                $(".yulanBtn").val(getLanguageMsg("取消", $.cookie("yuyan")));

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
        $(".shadowDiv").css("display", "none");
        $(".submitnet").css("marginLeft", "20px");
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
    //绝对时间上增加时间函数
    //obj=时间输入框id ，type=1
    function add_min(obj, type, value) {
        debugger;
        if (!IsNumric(value) || obj == "" || !IsNumric(type)) { return false; }
        var newtimestr = "";
        var objtime = $("#" + obj).val();
        if (objtime.indexOf("-") == -1) { //判断如果不带长日期自动添加日期
            var tempdate = new Date();
            objtime = tempdate.getFullYear() + "-" + (tempdate.getMonth() + 1) + "-" + tempdate.getDate() + " " + objtime;
        }
        
        if (!(isNaN(objtime) && !isNaN(Date.parse(objtime)))) { return false; }//判断最终格式是否日期格式
        objtime = new Date(objtime.replace(/-/g, '/'));
        if (type == 1) {//在当前输入框中时间的基础上增加时间       
            objtime = new Date(objtime.getTime() + value * 1000);
        } else if (type == 2) {//在当前时间基础上增加时间
            objtime = new Date(new Date().getTime() + value * 1000);
        }
        if ($("#" + obj).val().indexOf("-") >0) {
            newtimestr = objtime.getFullYear() + "-" + (objtime.getMonth() + 1) + "-" + objtime.getDate() + " " + objtime.getHours() + ":" + objtime.getMinutes() + ":" + objtime.getSeconds();
        } else {
            newtimestr = objtime.getHours() + ":" + objtime.getMinutes() + ":" + objtime.getSeconds();
        }
        $("#" + obj).val(newtimestr);
    }
    //关闭窗口
    $(".closeWindow").click(function () {
        $(".setProgramSync").hide();
        $(".setProgramSync .inp_t").val("");

    });
</script>
<form id="eidt_program_menu" name="eidt_program_menu" method="post" action="ajax/savemenu.ashx">
    <input type="hidden" id="h_edit_program_menu_taskid" name="h_edit_program_menu_taskid" runat="server" />
    <input type="hidden" id="h_edit_program_menu_menuid" name="h_edit_program_menu_menuid" runat="server" />
    <input type="hidden" id="h_edit_program_menu_right" name="h_edit_program_menu_right" runat="server" />
    <input type="hidden" id="h_edit_program_menu_pagetype" runat="server" />
    <input type="hidden" id="h_edit_program_window" name="h_edit_program_window" runat="server" />
    <input type="hidden" id="h_edit_program_framelayoutid" name="h_edit_program_framelayoutid" runat="server" />
    <input type="hidden" id="h_edit_program_fposition" name="h_edit_program_fposition" runat="server" />
    <input type="hidden" id="myBkpic" name="myBkpic" value="" />
    <input type="hidden" id="myOptions" name="myOptions" value="" />
    <div id="myDialogs" style="display: none; padding: 0;">
    </div>
    <div class="sc_add_box" style="background: #fff;">
        <h6 style="width: 250px; cursor: pointer; border-right: 1px solid #ddd; background: #1ca8dd; color: #fff;"><span class="language">节目项属性</span><tt class="language">(*为必填字段)</tt></h6>
        <h6 style="width: 115px; cursor: pointer; padding-left: 20px;" class="language">扩展属性</h6>
        <h6 style="width: 110px; cursor: pointer; padding-left: 20px;" class="language">参数设置</h6>
        <div class="zyyProgramEditContent1 zyyProgramEditContent">
            <div class="section">
                <ul class="clearfix" id="program_term">
                    <li><span class="label language">节目项名称：</span><input type="text" class="inp_t" style="width: 230px;" id="edit_program_taskname" name="edit_program_taskname" value="" runat="server" datatype="*1-64" errormsg="节目项名称不能为空，请输入节目项名称！" /></li>
                    <li><span class="label language">对应素材或栏目：</span><input type="text" class="inp_t" style="width: 230px;" readonly="readonly" runat="server" id="program_menu_itemname" name="program_menu_itemname" /><input type="hidden" id="program_menu_itemid" name="program_menu_itemid" value="0" runat="server" />
                        <!--<a href="javascript:void(0)" title="编辑素材" style="margin-left: 10px;" onclick="editProgramItem('editSource')"><img src="/images/shezhi.png" border="0" width="26"></a>-->
                        <a href="javascript:void(0)" title="编辑素材" style="margin-left: 10px;" onclick="editProgramItem('editSource')"><span class="language" title="编辑素材"></span><b class="bgImg"></b></a>
                    </li>
                    <li style="float: left; margin-right: 10px;line-height:33px;">
                        <span class="label language">专用特色设置：</span>
                        <input type="radio" name="r_edit_program_myplayer" value="0" checked id="r_wu" /><label for="r_wu" class="language">无</label>
                        <input type="radio" name="r_edit_program_myplayer" value="1" id="r_player" /><label for="r_player" class="language">内置专用播放器</label>
                        <input type="radio" name="r_edit_program_myplayer" value="2" id="r_zjc" /><label for="r_zjc" class="language">操作系统自检测</label>
                        <input type="radio" name="r_edit_program_myplayer" value="3" id="r_program" /><label for="r_program" class="language">专用应用程序</label>
                        <label style="display: none;">
                            <input type="radio" name="r_edit_program_myplayer" value="4" id="r_instr" class="language"/>远程指令</label>
                        <%--<input type="radio" name="r_edit_program_myplayer" value="4" id="r_instr" /><label for="r_instr">远程指令</label>--%>
                        <input type="radio" name="r_edit_program_myplayer" value="5" id="r_tra" /><label for="r_tra" class="language">专用文件传输</label>&nbsp;&nbsp;<%--<span class="btn_ex" data-isshow="0" id="date_set_btn">参数设置</span>--%>
                    </li>
                    <%-- <li class="li_ex"><span class="label">更多描述：</span><input class="inp_t" style="width: 480px;" id="s_edit_program_descript" name="s_edit_program_descript" type="text" /></li>--%>

                    <li style="float: left; margin-right: 10px; height: 20px; padding-top: 5px;">
                        <span class="label language" style="height: 15px; line-height: 15px;">节目触发类型：</span>
                        <input type="radio" name="s_edit_program_triggertype" value="0" id="cv_remwu" checked /><label for="cv_remwu" class="language">接前任务</label>
                        <input type="radio" name="s_edit_program_triggertype" value="1" id="cv_times" /><label for="cv_times" class="language">绝对年月时间</label>
                        <input type="radio" name="s_edit_program_triggertype" value="2" id="cv_days" /><label for="cv_days" class="language">每天时间</label>
                        <input type="radio" name="s_edit_program_triggertype" value="3" id="cv_shou" /><label for="cv_shou" class="language">手动</label>
                        <input type="radio" name="s_edit_program_triggertype" value="4" id="cv_empty" /><label for="cv_empty" class="language">空闲</label>
                        <input type="radio" name="s_edit_program_triggertype" value="5" id="cv_chufa" /><label for="cv_chufa" class="language">暂不触发</label>
                        <span id="addSync" class="sync language" onclick="addSync();">添加同步</span>
                        <span id="deleteSync" class="sync language" onclick="deleteSync();">取消同步</span>
                        <span id="setSync" class="sync language" onclick="setSync();">设置同步</span>
                    </li>
                    <li style="display: none;"><span class="label language">触发时间：</span><input class="inp_t" style="width: 150px;" type="text" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss', onpicked: function myfunction() { editProgramItem('editTriggerType'); } })" readonly="readonly" id="t_edit_program_triggertime1" name="t_edit_program_triggertime1"><span  class="sync" onclick="add_min('t_edit_program_triggertime1',2,60);">Now+1min</span><span  class="sync" onclick="add_min('t_edit_program_triggertime1',2,120);">Now+2min</span><span  class="sync" onclick="add_min('t_edit_program_triggertime1',2,300);">Now+5min</span><span  class="sync" onclick="add_min('t_edit_program_triggertime1',2,480);">Now+8min</span><span  class="sync" onclick="add_min('t_edit_program_triggertime1',1,30);">+30sec</span></li>
                    <li style="display: none;"><span class="label language">触发时间：</span><input class="inp_t" style="width: 150px;" type="text" onclick="WdatePicker({ dateFmt: 'HH:mm:ss', onpicked: function myfunction() { editProgramItem('editTriggerType'); } })" readonly="readonly" id="t_edit_program_triggertime2" name="t_edit_program_triggertime2"><span class="sync" onclick="add_min('t_edit_program_triggertime2',2,60);">Now+1min</span><span class="sync" onclick="add_min('t_edit_program_triggertime2',2,120);">Now+2min</span><span class="sync" onclick="add_min('t_edit_program_triggertime2',2,300);">Now+5min</span><span  class="sync" onclick="add_min('t_edit_program_triggertime2',1,30);">+30sec</span></li>
                    <li><span class="label language">持续时间：</span>
                        <span style="width: 95px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <input type="text" class="inp_t" style="width: 35px; text-align: center;" id="t_edit_program_duringtime_h" name="t_edit_program_duringtime_h" value="1" datatype="n" errormsg="持续小时字段要求输入数字！" />&nbsp;<span class="language">时</span></span>
                        <span style="width:95px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <input type="text" class="inp_t" style="width: 35px; text-align: center;" id="t_edit_program_duringtime_m" name="t_edit_program_duringtime_m" value="0" datatype="n" errormsg="持续分钟字段要求输入数字！" />&nbsp;<span class="language">分</span></span>
                        <span style="width: 105px; display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <input type="text" class="inp_t" style="width: 35px; text-align: center;" id="t_edit_program_duringtime_s" name="t_edit_program_duringtime_s" value="0" datatype="n" errormsg="持续秒字段要求输入数字！" />&nbsp;<span class="language">秒</span></span>
                        <span style="display: inline-block; float: left; height: 28px; line-height: 28px; margin-right: 30px;">
                            <!--<a href="javascript:void(0)" title="立即提交持续时间" onclick="editProgramItem('editDuringtime')" style="display: inline-block;">
                                <img src="/images/shezhi.png" width="26" border="0" style="margin-left: 15px;"></a>-->
                            <a href="javascript:void(0)" title="立即提交持续时间" onclick="editProgramItem('editDuringtime')" style="display: inline-block;">
                                <span class="language" title="立即提交持续时间"></span><b class="bgImg"></b></a>
                        </span>
                        <span style="display: inline-block; float: left; height: 28px; line-height: 28px;">
                            <select id="select_addtime" class="inp_t" style="width: 80px;">
                                <option data-unit="h" data-type="0" value="5" selected class="language">还原</option>
                                <option data-unit="s" data-type="0" value="5" class="language">5 秒</option>
                                <option data-unit="s" data-type="0" value="10" class="language">10 秒</option>
                                <option data-unit="s" data-type="0" value="15" class="language">15 秒</option>
                                <option data-unit="s" data-type="0" value="30" class="language">30 秒</option>
                                <option data-unit="s" data-type="0" value="60" class="language">1 分钟</option>
                                <option data-unit="s" data-type="0" value="3600" class="language">60 分钟</option>
                            </select>
                            <!--<a href="javascript:void(0)" onclick="adddotime(5);" class="edit_plustimes" style="margin-left:10px;background:url('/images/tubiao.png') -223px -328px"></a>&nbsp;&nbsp;<a href="javascript:void(0)" class="edit_plustimes" onclick="adddotime(-5);" style="background:url('/images/tubiao.png') -247px -328px"></a>&nbsp;&nbsp;<a href="javascript:void(0)" class="edit_plustimes" onclick="adddotime('x2');" style="background:url('/images/tubiao.png') -243px -363px"></a> <a href="javascript:void(0)" class="edit_plustimes" onclick="adddotime('x5');" style="background:url('/images/tubiao.png') -267px -364px"></a>-->
                            <a href="javascript:void(0)" onclick="adddotime(5);" class="edit_plustimes edit_dftimes">+5s</a><a href="javascript:void(0)" class="edit_plustimes edit_dftimes" onclick="adddotime(-5);">-5s</a><a href="javascript:void(0)" class="edit_plustimes edit_dftimes" onclick="adddotime('x1');">1h</a><a href="javascript:void(0)" class="edit_plustimes edit_dftimes" onclick="adddotime('x2');">2h</a>

                        </span>
                    </li>
                </ul>
            </div>

        </div>
        <div class="zyyProgramEditContent2 zyyProgramEditContent" style="display: none;">

            <%--<span class="ex_task" id="edit_menu_add_ex" data-isshow="0">展开</span>--%>
            <div class="section" id="program_slide_cookie">
                <%--style="display: none;"--%>
                <ul class="clearfix">
                    <li style="float: left; margin-right: 10px;"><span class="label language" title="复制文件到终端：">复制文件到终端：</span>
                        <input name="r_edit_program_copyto" type="radio" value="0" id="r_no" style="height: 28px; line-height: 28px; margin-right: 8px;" /><label for="r_no" style="margin-right: 20px;" class="language">否</label>
                        <input name="r_edit_program_copyto" type="radio" value="1" id="r_yes" style="height: 28px; line-height: 28px; margin-right: 8px;" checked /><label for="r_yes" style="margin-right: 8px;" class="language">是</label>
                        <input type="checkbox" name="c_edit_program_canreact" id="c_edit_program_canreact" style="height: 28px; line-height: 28px; margin-left: 8px;" /><label for="c_edit_program_canreact" style="margin-right: 8px;" class="language">允许前端交互反馈</label>
                        <input class="inp_c" name="c_edit_program_openflag" type="checkbox" id="c_edit_program_openflag"><label for="c_edit_program_openflag" class="language">不让外部用户看到该素材</label>
                    </li>
                    <li><span class="label language">播放优先级：</span>
                        <select class="inp_tsmall inp_t" id="s_edit_program_merit" name="s_edit_program_merit" style="width: 45px;">
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
                        <div class="bfq">
                            &nbsp;<input type="checkbox" name="c_edit_program_usesubject" value="0" id="c_edit_program_usesubject" /><label for="c_edit_program_usesubject" style="font-size: 12px; color: #474747;" class="language">栏目内的节目项均使用本处循环及模板设置</label>
                        </div>
                    </li>
                    <li><span class="label language">循环播放次数：</span>
                        <input type="text" class="inp_t" style="width: 40px" id="t_edit_program_circletime" value="0" name="t_edit_program_circletime" runat="server" datatype="n" errormsg="参与循环播放次数要求输入数字！" />
                        <span class="label language" style="width: 280px;">每天重置循环播放次数：</span>
                        <input name="r_edit_program_circleeveryday" type="radio" value="0" id="r_fou" style="height: 28px; margin-right: 8px;" checked /><label for="r_fou" style="margin-right: 20px;" class="language">否</label>
                        <input name="r_edit_program_circleeveryday" type="radio" value="1" id="r_ok" style="margin-right: 8px;" /><label for="r_ok" style="margin-right: 20px;" class="language">是</label>
                    </li>
                    <li><span class="label language">循环开始时间：</span>
                        <!--<input name="t_edit_program_starttime" class="inp_t" style="width: 180px" id="t_edit_program_starttime" maxlength="19" onclick="SetTriggerTime('t_edit_program_starttime');">-->
                        <input name="t_edit_program_starttime" class="inp_t" style="width: 180px" id="t_edit_program_starttime" maxlength="19">
                        &nbsp;
                     <input name="settime" type="button" value="短时间" class="cv_color language" onclick="SetTriggerTime('t_edit_program_starttime', 0);" />
                        &nbsp;
                     <input name="settime1" type="button" value="长时间" class="cv_color language" onclick="SetTriggerTime('t_edit_program_starttime', 1);" />&nbsp;&nbsp;<input name="todaytime" id="todaytime" type="button" class="cv_color language" value="今天全天" onclick="    SetTimeRange('t_edit_program_starttime', 't_edit_program_expiretime2', 0);" />&nbsp;&nbsp;<input class="language" name="nextdaytime" id="nextdaytime" type="button" class="cv_color" value="明天全天" onclick="    SetTimeRange('t_edit_program_starttime', 't_edit_program_expiretime2', 1);" />
                    </li>
                    <li><span class="label language">循环结束时间：</span>
                        <!--<input name="t_edit_program_expiretime2" id="t_edit_program_expiretime2" class="inp_t" style="width: 180px" maxlength="19" value="" onclick="SetTriggerTime('t_edit_program_expiretime2');">-->
                        <input name="t_edit_program_expiretime2" id="t_edit_program_expiretime2" class="inp_t" style="width: 180px" maxlength="19" value="">
                        &nbsp;
                <input name="esettime" type="button" class="cv_color language" value="短时间" onclick="SetTriggerTime('t_edit_program_expiretime2', 0);" />
                        &nbsp;
                <input name="esettime1" type="button" class="cv_color language" value="长时间" onclick="SetTriggerTime('t_edit_program_expiretime2', 1);" />&nbsp;&nbsp;<input name="etodaytime" id="etodaytime" type="button" class="cv_color language" value="今天白天" onclick="    SetTimeRange('t_edit_program_starttime', 't_edit_program_expiretime2', 10);" />&nbsp;&nbsp;<input name="enextdaytime" id="enextdaytime" type="button" class="cv_color language" value="明天白天" onclick="    SetTimeRange('t_edit_program_starttime', 't_edit_program_expiretime2', 11);" />
                    </li>
                    <li><span class="label language">窗口显示状态：</span>
                        <div class="bfq">
                            <input type="radio" name="r_edit_program_zorder" value="0" id="r_size"><label for="r_size" class="language">缺省大小</label>
                            <input type="radio" name="r_edit_program_zorder" value="1" checked id="r_zd"><label for="r_zd" class="language">最大</label>
                            <input type="radio" name="r_edit_program_zorder" value="2" id="r_zx"><label for="r_zx" class="language">最小</label>
                            <input type="radio" name="r_edit_program_zorder" value="3" id="r_zq"><label for="r_zq" class="language">最前</label>
                            <input type="radio" name="r_edit_program_zorder" value="4" id="r_zqzd"><label for="r_zqzd" class="language">最前最大</label>
                            <input type="radio" name="r_edit_program_zorder" value="5" id="r_zqzx"><label for="r_zqzx" class="language">最前最小</label>
                        </div>
                    </li>

                    <li><span class="label language">模板：</span><input class="inp_t" style="width: 150px;" name="t_edit_program_templet" id="t_edit_program_templet" type="text" readonly="readonly" value="默认模板"><input type="hidden" id="h_edit_program_templet" name="h_edit_program_templet" value="0" runat="server" /><input type="hidden" id="h_edit_program_templet_bkpic" name="h_edit_program_templet_bkpic" value="" runat="server" /><input type="hidden" id="h_edit_program_templet_options" name="h_edit_program_templet_options" value="" runat="server" />
                        <div>
                            <a href="javascript:void(0)" onclick="edit_program_menu_seltemp()" title="选择显示模板" style="display: inline-block;">
                                <img src="/images/icon_yulan.png" width="26" border="0" style="margin-left: 10px;"></a>&nbsp;
                            <a href="javascript:void(0)" style="display: inline-block; width: 26px; height: 26px; background: url(/images/tubiaoa.png) -268px -102px;" onclick="editProgramItem('resetTemplate')" title="重置为缺省显示模板"></a>&nbsp;
                            <a href="javascript:void(0)" style="display: inline-block; width: 26px; height: 26px; background: url(/images/tubiaoa.png) -268px -136px;" title="直接自定义设置显示属性" onclick="editProgramItem('mySelfTemplate')"></a>
                        </div>
                    </li>
                    <li>
                        <span class="label language">节目项排列顺序：</span>
                        <input class="inp_tsmall inp_t" value="1" type="text" style="width: 40px" id="t_edit_program_postion" name="t_edit_program_postion" runat="server" datatype="n" errormsg="节目项排列顺序要求输入数字！" />&nbsp;
                        <!--<a href="javascript:void(0)" title="立即修改节目项排列顺序" style="display: inline-block;" onclick="editProgramItem('editPosition')">
                            <img src="/images/shezhi.png" width="26" border="0" style="margin-left: 5px;"></a>-->
                        <a href="javascript:void(0)" title="立即修改节目项排列顺序" style="display: inline-block;" onclick="editProgramItem('editPosition')">
                            <b class="bgImg"></b>
                        </a>
                        <input value="1" type="hidden" id="t_edit_program_oldpostion" name="t_edit_program_oldpostion" runat="server"></li>
                    <li><span class="label language">节目项状态：</span><select style="width: 115px" name="checkstatuslist" id="checkstatuslist" class="inp_t">
                        <option value="0" selected="" class="language">未审核
                        </option>
                        <option value="1" class="language">审核通过
                        </option>
                        <option value="4" class="language">暂停分发
                        </option>
                        <option value="2" class="language">欠费
                        </option>         
                        <option value="8" class="language">信息不符
                        </option>
                        <option value="16" class="language">信息过期
                        </option>
                        <option value="32" class="language">政治反动
                        </option>
                        <option value="64" class="language">宗教
                        </option>
                        <option value="128" class="language">色情暴力
                        </option>
                        <option value="256" class="language">恶意攻击
                        </option>
                        <option value="512" class="language">机密
                        </option>
                        <option value="1024" class="language">隐私
                        </option>
                        <option value="2048" class="language">病毒
                        </option>
                        <option value="4096" class="language">发布修改
                        </option>
                        <option value="8192" class="language">发布删除
                        </option>
                        <option value="16384" class="language">其它
                        </option>
                    </select>
                        <a href="javascript:void(0)" title="立即修改节目项状态" style="display: inline-block;" onclick="editProgramItem('editStatus')">
                            <!--<img src="/images/shezhi.png" width="26" border="0" style="margin-left: 15px;"></a>-->
                            <b class="bgImg"></b></a>
                        &nbsp;<input class="inp_tsmall inp_t" value="" type="hidden" style="width: 40px" id="checkstatus" name="checkstatus" runat="server" /><input class="inp_tsmall inp_t" value="" type="hidden" style="width: 40px" id="checkuserid" name="checkuserid" runat="server" /><input class="inp_tsmall inp_t" value="" type="hidden" style="width: 40px" id="userid" name="userid" runat="server" /></li>
                </ul>
            </div>
        </div>
        <div class="zyyProgramEditContent zyyProgramEditContent3" style="display: none;">
            <div class="section">
                <ul class="clearfix">
                    <li class="li_ex" style="padding-top: 10px;"><span class="label language">应用程序名/参数：</span><input class="inp_t" style="width: 230px;" id="s_edit_program_exetask" name="s_edit_program_exetask" type="text" />&nbsp;
                         <span class="label language">选择应用程序名：</span>
                        <select name="prgnamelist" id="sel_edit_program_pro" class="inp_t" style="width: 180px;">
                            <option value=""></option>
                            <option value="NBPlayer.exe" class="language">0-通用音视频/电视播放器</option>
                            <option value="TVPlayer.exe" class="language">1-电视播放/换台器</option>
                            <option value="AV4Player.exe" class="language">2-WMV音视频播放器</option>
                            <option value="UrlPlayer.exe" class="language">3-网页播放器</option>
                            <option value="FlashPlayer.exe" class="language">4-动画播放器</option>
                            <option value="MultiCastVideoPlayer.exe" class="language">5-音视频广播接收器</option>
                            <option value="HKVideoPlayer.exe" class="language">6-HK高清编码器播放器</option>
                            <option value="WiseCCCPlayer.exe" class="language">7-远程桌面查看器</option>
                            <option value="PptView.exe" class="language">8-幻灯片播放器</option>
                            <option value="PowerPnt.exe" class="language">9-幻灯片编辑器</option>
                            <option value="RecordPlayer.exe" class="language">10-记录浏览器</option>
                            <option value="RS232Commander.exe" class="language">11-串口/指令发送器</option>
                            <option value="WiseSendInfo.exe" class="language">12-智能数据处理器</option>
                            <option value="UrlToMyHtm.exe" class="language">13-网页下载转换器</option>
                            <option value="KillProcess.exe" class="language">14-进程清理器</option>
                            <option value="-o :0:0:60:hhmmss:circletime" class="language">15-视频同步参数</option>
                            <option value="ClockPlayer.exe" class="language">16-表盘时钟显示</option>
                            <option value="TimePmtPlayer.exe" class="language">17-数字时钟显示</option>
                        </select>
                    </li>
                    <li class="li_ex"><span class="label">
                        <input type="checkbox" name="c_edit_program_param_setloc" value="1" /><span class="language">播放窗口位置：</span></span>
                        <select name="moreInfoChoiseList" id="moreInfoChoise" class="inp_t" style="width: 237px; height: 28px;">
                            <option value=""></option>
                            <option value=" 20,0,120,100 -m1 -l -t" class="language">数字时钟左上角</option>
                            <option value=" 20,0,600,100 -mf -l -t" class="language">数字时钟左上角(长)</option>
                            <option value=" 1760,0,120,100 -m1 -l -t" class="language">数字时钟右上角</option>
                            <option value=" 1320,0,600,100 -mf -l -t" class="language">数字时钟右上角(长)</option>
                            <option value=" 20,980,120,100 -m1 -l -t" class="language">数字时钟左下角</option>
                            <option value=" 20,980,600,100 -mf -l -t" class="language">数字时钟左下角(长)</option>
                            <option value=" 1760,980,120,100 -m1 -l -t" class="language">数字时钟右下角</option>
                            <option value=" 1320,980,600,100 -mf -l -t" class="language">数字时间右上角(长)</option>
                            <option value=" 0,1020,1920,60 -t -l" class="language">滚动字幕</option>
                            <option value=" 0,1020,1920,60 -t -l" class="language">滚动字幕(log)</option>
                            <option value=" 40,1020,1840,60 -t -l" class="language">滚动字幕 (区域)</option>
                            <option value=" 40,1020,1840,60 -t -l" class="language">滚动字幕log (区域)</option>
                            <option value=" 0,0,1920,1080 -t" class="language">通知（向上滚动，标题不参与滚动）</option>
                        </select>
                        <input class="inp_t" style="width: 213px; position: relative; margin-left: -237px;" id="s_edit_program_param_window" name="s_edit_program_param_window" type="text" />
                        <tt class="language">（给出顶点位置坐标及宽度高度，用逗号隔开。如0,0,80,80）</tt>

                    </li>
                    <li class="li_ex">
                        <ul class="bfq">
                            <li>
                                <input type="checkbox" name="c_edit_program_param_setpstmsg" value="1" id="c_edit_program_param_setpstmsg" /><label for="cv_tongzhi" class="language">播放完毕后通知系统</label></li>
                            <li>
                                <input type="checkbox" name="c_edit_program_param_settopmost" value="1" id="c_edit_program_param_settopmost" /><label for="cv_zuiqian" class="language">窗口总在最前显示</label></li>
                            <li>
                                <input type="checkbox" name="c_edit_program_param_setminimize" value="1" id="c_edit_program_param_setminimize" /><label for="cv_zuixiao" class="language">播放时最小化窗口</label></li>
                            <li>
                                <input type="checkbox" name="c_edit_program_param_setclose" value="1" id="c_edit_program_param_setclose" /><label for="cv_cancal" class="language">播放完毕后自动退出</label></li>
                        </ul>
                    </li>
                    <li class="li_ex">
                        <span class="label language">透明：</span>
                        <ul class="bfq">
                            <li>
                                <input type="radio" name="r_edit_program_param_settrans" value="0" id="r_edit_program_param_settrans" /><label for="r_trans" class="language">不透明显示</label></li>
                            <li>
                                <input type="radio" name="r_edit_program_param_settrans" value="1" id="r_edit_program_param_settrans" /><label for="r_display" class="language">透明显示</label></li>
                            <li>
                                <input type="radio" name="r_edit_program_param_settrans" value="2" id="r_edit_program_param_settrans" /><label for="r_half" class="language">半透明显示</label></li>
                        </ul>
                    </li>
                    <li class="li_ex">
                        <span class="label language">罩子形状：</span>
                        <ul class="bfq">
                            <li>
                                <input type="radio" name="r_edit_program_param_setmask" value="0" id="r_edit_program_param_setmask" /><label for="r_normal" class="language">无</label></li>
                            <li>
                                <input type="radio" name="r_edit_program_param_setmask" value="1" id="r_edit_program_param_setmask" /><label for="r_pic" class="language">由镂空图片给出</label></li>
                            <li>
                                <input type="radio" name="r_edit_program_param_setmask" value="2" id="r_edit_program_param_setmask" /><label for="r_wenzi" class="language">由显示文字给出</label></li>
                        </ul>
                    </li>
                    <li class="li_ex moreInfoControl">
                        <input type="hidden" id="sourcePath" name="sourcePath" value="" runat="server" />
                        <span class="label language">更多描述：</span>
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
                        <input class="inp_t" style="width: 480px; position: relative; height: 24px;" id="s_edit_program_descript" name="s_edit_program_descript" type="text" /><%--top:-26px;--%>
                        <span id="zyyEditNet" onclick="zyyEditNet()" class="label language" style="width: 80px; margin-left: 10px; text-align: center; background: #f5f5f5; padding: 0; border: 1px solid #c1c1c1; border-radius: 5px; color: #a8a8a8; height: 24px; line-height: 24px;">网页模板</span>

                    </li>
                </ul>
            </div>
            <div class="shadowDiv">
                <div class="shadowContent1">
                    <p class="urlTitle language">网页模板</p>
                    <img class="closeNetImg"><%-- src="images/allTitle/closeImg.png" --%>
                    <div class="shadowContent">

                        <div class="addContent">
                        </div>
                        <input class="sumitBtn submitnet language" type="submit" value="提交" onclick="submitnet()" />
                        <input class="sumitBtn yulanBtn language" type="button" value="取消" onclick="cancleNet()" />
                    </div>
                </div>
            </div>

        </div>

        <div class="sc_add_btn clearfix" style="margin-left: 125px;">
        </div>
        <div id="edit_program_seltemplete" class="mb_list_box" style="display: none; position: fixed; z-index: 9999; background: #f7f7f7; top: 120px;"></div>
        <div class="setProgramSync">
            <span class="del closeWindow"></span>
            <ul class="clearfix">
                <li style="float: left; margin-right: 10px;">
                    <span class="label language">专用特色设置：</span>
                    <input type="radio" name="r_edit_program_myplayer_sync" value="0" id="r_wu_sync" checked /><label for="r_wu_sync" class="language">无</label>
                    <input type="radio" name="r_edit_program_myplayer_sync" value="1" id="r_player_sync" /><label for="r_player_sync" class="language">内置专用播放器</label>
                    <input type="radio" name="r_edit_program_myplayer_sync" value="2" id="r_zjc_sync" /><label for="r_zjc_sync" class="language">操作系统自检测</label>
                    <input type="radio" name="r_edit_program_myplayer_sync" value="3" id="r_program_sync" /><label for="r_program_sync" class="language">专用应用程序</label>
                    <!--<label style="display:none;"><input type="radio" name="r_edit_program_myplayer" value="4" id="Radio11" />远程指令</label>-->
                    <input type="radio" name="r_edit_program_myplayer" value="5" id="r_tra_sync" /><label for="r_tra_sync" class="language">专用文件传输</label>
                </li>

                <li class="li_ex" style="float: left; margin-right: 10px; height: 28px; padding-top: 5px;"><span class="label language">应用程序名/参数：</span><input class="inp_t setInput" style="width: 230px;" id="s_edit_program_exetask_sync" name="s_edit_program_exetask_sync" type="text" />&nbsp;
                <!--<span class="label">选择应用程序名：</span>-->
                    <span class='seto sync language' onclick="seto();" style="margin-top: 4px;">+/- 同步参数</span>

                </li>

                <li style="float: left; margin-right: 10px; height: 20px; padding-top: 5px;">
                    <span class="label language" style="height: 25px; line-height: 25px;">节目触发类型：</span>
                    <input type="radio" name="s_edit_program_triggertype_sync" value="0" id="cv_remwu_sync" checked /><label for="cv_remwu_sync" class="language">接前任务</label>
                    <input type="radio" name="s_edit_program_triggertype_sync" value="1" id="cv_times_sync" /><label for="cv_times_sync" class="language">绝对年月时间</label>
                    <input type="radio" name="s_edit_program_triggertype_sync" value="2" id="cv_days_sync" /><label for="cv_days_sync" class="language">每天时间</label>
                    <input type="radio" name="s_edit_program_triggertype_sync" value="3" id="cv_shou_sync" /><label for="cv_shou_sync" class="language">手动</label>
                    <input type="radio" name="s_edit_program_triggertype_sync" value="4" id="cv_empty_sync" /><label for="cv_empty_sync" class="language">空闲</label>
                    <input type="radio" name="s_edit_program_triggertype_sync" value="5" id="cv_chufa_sync" /><label for="cv_chufa_sync" class="language">暂不触发</label>
                </li>
                <li style="float: left; margin-right: 10px; height: 28px; padding-top: 5px;">
                    <span class="label language">触发时间：</span><input class="inp_t" style="width: 150px;" type="text" onclick="WdatePicker({ dateFmt: 'HH:mm:ss' })" readonly="readonly" id="t_edit_program_triggertime1_sync" name="t_edit_program_triggertime1_sync">
                </li>
                <li style="float: left; margin-right: 10px; height: 20px; padding-top: 5px;">
                    <span class="label language">循环结束时间：</span>
                    <input name="t_edit_program_expiretime2_sync" id="t_edit_program_expiretime2_sync" class="inp_t" style="width: 180px" maxlength="19" value="">
                    &nbsp;
                <input name="esettime" type="button" class="cv_color language" value="短时间" onclick="SetTriggerTimeSync('t_edit_program_expiretime2_sync', 0);" />
                </li>
            </ul>
            <div style="margin: 20px 0 0 110px;">
                <span class='setSuccess sync language' onclick="setSuccess();">确定</span>
                <span class='setCancel sync language' onclick="setCancel();">取消</span>
            </div>
        </div>
</form>


