<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_add.aspx.cs" Inherits="Web.company.client.client_add" %>

<style>
    #client_add_ctlport,#client_add_hostport,#client_add_recomand
    {
        width:100px;
    }
    .prompt_pic
    {
        padding-left:3px;
        padding-top:2px;
    }
   /*#client_addbox .sec_box
    {
        width:90%;
    }*/
    .zd_add_box h6{
    width:795px;
    }
    .zd_add_box ul li span.label {
        width:240px;
    }
    .zd_add_box ul li {
        width:810px;
    }
</style>
<script type="text/javascript">
    var dlevel, clientid, clientmark;
    var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
    var isvirtualgroup = "no";
    $(function () {
        getJsonValue();
        if (treeObj.getSelectedNodes().length > 0) {
            if (treeObj.getSelectedNodes()[0].groupflag == "2") {////‘虚拟组’ 添加终端。。。
                $("#isVirtualGroup").val("yes");
            }
        }
        switchLanguage("#client_add", 1, "client_add.aspx");
        //isVirtualGroup
        dlevel = $("#client_add_dlevel").val();
        clientid = $("#client_add_groupid").val();
        clientmark = $("#client_add_remark").val();//><a href="javascript:void(0)">播放终端列表</a>
        $("#client_main_pagemap").html('<a href="javascript:void(0)">' + getLanguageMsg('播放终端管理', $.cookie("yuyan")) + '</a>' + $("#client_add_pageMap").val());
        $("#myclientroot").html(getLanguageMsg($("#myclientroot").html(), $.cookie("yuyan")));
        $("#client_add_ex1").click(function () {
            if ($(this).attr("data-isshow") == "0") {
                $(this).text(getLanguageMsg("收起", $.cookie("yuyan")));//.removeClass("ex_task").addClass("ex_task2")
                $(this).css({ "border-bottom": "0", "background": "url(/images/icon_ex2.png) no-repeat right center" })
                $(this).next(".section").slideDown();
                $(this).attr("data-isshow", 1);
            }
            else {
                $(this).attr("data-isshow", 0);
                $(this).css({ "border-bottom": "1px solid #ddd", "background": "url(/images/icon_ex.png) no-repeat right center" })
                $(this).text(getLanguageMsg("展开", $.cookie("yuyan")));//.removeClass("ex_task2").addClass("ex_task")
                $(this).next(".section").slideUp();
            }
        });
        $("#client_add_ex2").click(function () {

            if ($(this).attr("data-isshow") == "0") {

                $(this).text(getLanguageMsg("收起", $.cookie("yuyan")));  //.removeClass("ex_task").addClass("ex_task2")
                $(this).next(".section").slideDown();
                $(this).css({ "border-bottom": "0", "background": "url(/images/icon_ex2.png) no-repeat right center" })
                $(this).attr("data-isshow", 1);
            }
            else {
                $(this).attr("data-isshow", 0);
                $(this).css({ "border-bottom": "1px solid #ddd", "background": "url(/images/icon_ex.png) no-repeat right center" })
                $(this).text(getLanguageMsg("展开", $.cookie("yuyan")));  //.removeClass("ex_task2").addClass("ex_task")
                $(this).next(".section").slideUp();
            }
        });
        if ($("#client_add_isedit").val() == "edit") {
            //$("#client_add_name").attr("readonly", "readonly");//修改终端名称
            $("#client_add_onceaddnum").parent("li").hide();
            $.ajax({
                type: 'post',
                url: 'ajax/getclientinfo.ashx',
                async: true,
                dataType: 'text',
                data: { "gid": $("#client_add_groupid").val() },
                success: function (data) {
                    var json = strToJson(data);
                    $.each(json.Table, function (idx, item) {
                        $("#client_add_name").val(item.clientname);
                        $("#client_add_ip").val(item.ip);
                        $("#client_add_port").val(item.port);
                        $("#client_add_postion").val(item.postion);
                        $("#client_add_descript").val(item.descript);
                        $("#client_add_location").val(item.location);
                        $("#client_add_recomand").val(item.recommend);
                        if (item.picture == "") {
                            //$("#client_add_picture").val();
                        }
                        else {
                            $("#client_add_picture").val(item.picture);
                            $("#previewPhotoDiv>img").attr("src", $("#client_add_picture").val());
                        }
                        //$("#client_add_coordx").val(item.coordx);
                        //$("#client_add_coordy").val(item.coordy);
                        $("#sc_add_coordx").val(item.coordx);
                        $("#sc_add_coordy").val(item.coordy);

                        $("#client_add_range").val(item.corange);
                        $("#client_add_clienttype").val(item.clienttype);
                        $("#client_add_mac").val(item.mac);
                        var settings = item.settings.split("");
                        for (var i = 0; i < settings.length; i++) {
                            $("input[name=client_add_settings][value=" + settings[i] + "]").attr("checked", true);
                        }
                        $("#client_add_host").val(item.host);
                        $("#client_add_hostport").val(item.hostport);
                        if (item.startuptime.length >= 5) {

                            $("#client_add_startuptime").val(item.startuptime.substring(0, 5));
                            if (item.startuptime.length == 6) {

                                if (item.startuptime.substring(5, 1) != "_") {
                                    $("#client_add_startupexcept").val(item.startuptime.charAt(5).charCodeAt() - 48);
                                }
                                else {
                                    $("#client_add_waitacktime").val(item.startuptime.substring(6, 7));
                                }
                            }
                            if (item.startuptime.length == 7) {
                                $("#client_add_waitacktime").val(item.startuptime.substring(6, 7));
                            }
                            if (item.startuptime.length == 8) {
                                $("#client_add_startupexcept").val(item.startuptime.charAt(5).charCodeAt() - 48);
                                $("#client_add_waitacktime").val(item.startuptime.substring(7, 8));
                            }
                        }
                        else {
                            if (item.startuptime.length == 1) {
                                $("#client_add_startupexcept").val(item.startuptime.charAt(0).charCodeAt() - 48);
                            }
                            if (item.startuptime.length == 3) {

                                $("#client_add_waitacktime").val(item.startuptime.substring(2, 3));
                            }
                        }

                        if (item.shutdowntime.length >= 5) {
                            $("#client_add_shutdowntime").val(item.shutdowntime.substring(0, 5));
                            $("#client_add_reportinterval").val(item.shutdowntime.substring(5, item.shutdowntime.length));

                        }
                        else {
                            $("#client_add_reportinterval").val(item.shutdowntime);
                        }
                        var ctloptions = item.ctloption.split("");
                        for (var i = 0; i < ctloptions.length; i++) {
                            $("input[name=client_add_ctloption][value=" + ctloptions[i] + "]").attr("checked", true);
                        }//远程控制颜色数
                        $("input[name='client_add_ctlcolor'][value='" + item.ctlcolor + "']").attr("checked", true);
                        $("#client_add_ctlip").val(item.ctlip);
                        $("#client_add_ctlport").val(item.ctlport);
                    });
                }
            });
        }
        $("#client_add_picture_upload").live("change", function () {
            if ($(this).val() != "") {
                $.ajaxFileUpload({
                    url: 'ajax/receivepicture.ashx',
                    type: 'post',
                    secureuri: false, //一般设置为false
                    fileElementId: 'client_add_picture_upload', // 上传文件的id、name属性名
                    dataType: 'text', //返回值类型，一般设置为json、application/json
                    elementIds: "client_add_picture_upload", //传递参数到服务器
                    success: function (data, status) {
                        if (data <= 0) {
                            showError("clientgroup_add_picture", getLanguageMsg("上传错误", $.cookie("yuyan")), 0);
                        }
                        else {
                            if ($(".mod_sucess").length > 0) {
                                $(".mod_sucess").remove();
                            }
                            $("#client_add_picture").val(data);
                            $("#client_add_picture").after("<div class=\"mod_sucess\" style=\"float:none\"><span class=\"sucess_icon\"></span>" + getLanguageMsg("上传成功", $.cookie("yuyan")) + "</div>");
                            $("#previewPhotoDiv>img").attr("src", $("#client_add_picture").val());
                        }
                    },
                    error: function (data, status, e) {
                        alert(e);
                    }
                });
            }
        });
        //errormsg="终端网址不能为空"
        $("#client_add_ip").blur(function () {

            if ($("#settingsa7:checked").length > 0 || $("#client_add_ip").val() != "") {
                $("#ipNull").hide();
            } else {
                $("#ipNull").show();
            }
        });
        $("#settingsa7").change(function () {
            if (this.checked || $("#client_add_ip").val() != "") {
                $("#ipNull").hide();
            } else {
                $("#ipNull").show();
            }
        });
        $("#client_add").Validform({
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
            beforeSubmit: function (curform) {

                //在验证成功后，表单提交前执行的函数，curform参数是当前表单对象。
                //这里明确return false的话表单将不会提交;
                if ($("#templet_add_f_isb").attr("checked") == "checked") {
                    $("#templet_add_width").val($("#templet_add_width").val() + "%");
                }
                if ($("#templet_add_percent_height").attr("checked") == "checked") {
                    $("#templet_add_height").val($("#templet_add_height").val() + "%");
                }
                $("#client_add_name").val($("#client_add_name").val().trim());//终端名称 前后不能有 空格
                if ($("#ipNull").css("display") != "none") { return false; }
                if ($("#hasGroupSet").attr("checked") == "checked") {
                    if (!confirm(getLanguageMsg("您选中了修改本记录同时，修改本组内所有记录的设置吗，确定吗？", $.cookie("yuyan")))) {
                        return false;
                    }
                }
            },
            ajaxPost: true,
            postonce: true,
            callback: function (d) {
                if (d.status == "y") {
                    if ($("#client_add_isedit").val() == "") {
                        TopTrip(getLanguageMsg("终端添加成功", $.cookie("yuyan")), 1);
                    } else {
                        TopTrip(getLanguageMsg("终端修改成功", $.cookie("yuyan")), 1);
                    }
                    //loadParentPage();//
                    //$("#client_main_left").load("client_main_left.html?rnd=" + Math.random());
                    //client_main_loadright(0, clientid, dlevel, clientmark);
                    if ($.cookie("mySelectNodeID") != "" && $.cookie("mySelectNodeID") != null) {//记录的上次点击的终端(组)
                        $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());
                    } else {
                        $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());
                        client_main_loadright(0, clientid, dlevel, clientmark);
                    }
                    //

                }
                else {
                    if (d.info == -1) {
                        TopTrip(getLanguageMsg("终端名已存在", $.cookie("yuyan")), 2);
                    }
                    if (d.info == 0) {
                        TopTrip(getLanguageMsg("系统错误，请联系管理员", $.cookie("yuyan")), 3);
                    }
                }
            }
        });
    })

    function previewPhoto() {
        $("#overlay").fadeIn();
        $("#previewPhotoDiv").fadeIn();
    }
    function closeDiv() {
        $("#previewPhotoDiv").fadeOut(function () {
            $("#overlay").fadeOut();
        });

    }
    //window.onload = function () {
    //    var imgUrl = $("#client_add_picture").val();
    //    //$("#templet_add_uploadbgpic").val(imgUrl.substr(imgUrl.lastIndexOf('/')));//不能给input--file赋值
    //    $("#previewPhotoDiv>img").attr("src", imgUrl);
    //}

    //加载百度地图
    function client_loadBaiduMap() {
        //IE 可以，FireFox不行;
        $("#baidumapdiv").show();//clientbaidumapdiv
    }
    $("#client_btn_copy").click(function () {
        $("#client_add_isedit").val("");
    });
    //$("#client_fanhui").click(function () {
    //    $("#client_add_pageMap").goback("-1")
    //});
    function groupSet() {
        if ($("#hasGroupSet").attr("checked") == "checked") {
            $("#hasGroupSet").val("1");
        } else {
            $("#hasGroupSet").val("0");
        }
    }
</script>
<div id="overlay" style="display: none"></div>
    <div id="previewPhotoDiv" style="display:none;position:absolute;padding:25px;background-color:#fff;z-index:2001;">
       <img src="#" style="max-width:800px;max-height:600px;" />
        <div style="position: absolute; right: 0; top: 0; width: 30px; height: 30px; cursor: pointer;">
                    <img src="/images/icon_closeBox.png" onclick="closeDiv()" />
        </div>
    </div>
<form id="client_add" action="ajax/saveclient.ashx" method="post" style="overflow:hidden;">
    <input type="hidden" id="client_add_dlevel" name="client_add_dlevel" runat="server" />
    <input type="hidden" id="client_add_groupid" name="client_add_groupid" runat="server" />
    <input type="hidden" id="client_add_remark" name="client_add_remark" runat="server" />
    <input type="hidden" id="client_add_idlist" name="client_add_idlist" runat="server" />
    <input type="hidden" id="client_add_isedit" name="client_add_isedit" runat="server" />
    <input type="hidden" id="client_add_pageMap" runat="server" />

    <input type="hidden" id="isVirtualGroup" name="isVirtualGroup" value="no" />
    <div id="baidumapdiv" style="position: fixed; top: 30px; width: 820px; height: 520px; left: 20px; z-index: 9999; display: none;">
        <iframe src="/company/source/BaiduMap.aspx" width="820" height="520" frameborder="0" style="padding: 0;"></iframe><%--id="clientbaidumapdiv"，BaiDuMap.html--%>
    </div>
    <div class="zd_add_box" id="client_addbox" style="width: 978px; border: none;padding:0;"><%--padding为0是去掉上面10px的白色距离--%>
       <%-- <h6>播放终端<tt class="Validform_checktip">(*为必填字段)</tt></h6>--%>
        <div class="section sec_box">
            <ul class="clearfix">
                <li><span class="label language">终端名称：</span><input class="inp_t" id="client_add_name" name="client_add_name" datatype="*" errormsg="终端名称不能为空" type="text"><tt class="Validform_checktip language">*唯一标记，最长64字节。</tt></li>
                <li style="display: none"><span class="label language">终端内部吗：</span><input class="inp_t" id="client_add_mark" readonly="readonly" name="client_add_mark" runat="server"></li>
                <li><span class="label language">播放终端网址：</span><input class="inp_t" id="client_add_ip" name="client_add_ip" type="text"><span style="display:none;color:red;margin-left:8px;" id="ipNull" class="language">*终端网址不能为空</span><span style="height:30px;line-height:30px;margin-left:15px;"><input type="checkbox" id="settingsa7" name="client_add_settings" value="7" /><label for="settingsa7" class="language">自动获取IP地址</label></span></li>
                <li><span class="label language">播放终端端口号：</span><input class="inp_t" style="width: 100px;" id="client_add_port" name="client_add_port" type="text">
                    <span class="label language" style="width:120px;margin-left:115px;">节目单分发顺序：</span><input class="inp_t" style="width: 100px;" id="client_add_postion" name="client_add_postion" type="text" value="0"></li>
                <li><span class="label language">描述（最多1024汉字）：</span><div class="intro" style="width: 490px;">
                    <textarea class="txtarea" id="client_add_descript" name="client_add_descript" style="width: 475px;"></textarea>
                </div>
                    
                </li>
                <li>
                    <span class="label language">MAC地址：</span><input class="inp_t" id="client_add_mac" name="client_add_mac" type="text">
                    <span class="label language" style="width:115px;">推荐度：</span><input class="inp_t" id="client_add_recomand" name="client_add_recomand" datatype="n" errormsg="必须为1-100数字" type="text" value="30"><tt class="Validform_checktip"></tt>
                </li>
                <li>
                    <label style="color:red;padding-left:120px;" title="批量修改扩展属性">
                        <input type="checkbox" name="hasGroupSet" id="hasGroupSet" value="0" onclick="groupSet()" /><span class="language">修改本记录 同时，将记录所在组内其他记录也进行相同修改</span></label>
                </li>
                <%--<li><span class="label">推荐度：</span><input class="inp_t" id="client_add_recomand" name="client_add_recomand" datatype="n" errormsg="必须为1-100数字" type="text" value="30"><tt class="Validform_checktip"></tt></li>--%>
                <li><span class="label language">每天开机时间：</span><input class="inp_t" style="width: 100px;" onclick="WdatePicker({ dateFmt: 'HH:mm' })" id="client_add_startuptime" name="client_add_startuptime" type="text">
                    <span class="prompt">
                        <select name="client_add_startupexcept" id="client_add_startupexcept" class="inp_t" style="width:120px;">
                            <option value="0" selected="" class="language">0-没有例外</option>
                            <option value="1" class="language">1-周一不开</option>
                            <option value="2" class="language">2-周二不开</option>
                            <option value="3" class="language">3-周三不开</option>
                            <option value="4" class="language">4-周四不开</option>
                            <option value="5" class="language">5-周五不开</option>
                            <option value="6" class="language">6-周六不开</option>
                            <option value="7" class="language">7-周日不开</option>
                            <option value="8" class="language">8-周六、周日不开</option>
                            <option value="9" class="language">9-自定义例外1</option>
                            <option value="10" class="language">10-自定义例外2</option>
                            <option value="11" class="language">11-自定义例外3</option>
                            <option value="12" class="language">12-自定义例外4</option>
                            <option value="13" class="language">13-自定义例外5</option>
                            <option value="14" class="language">14-自定义例外6</option>
                            <option value="15" class="language">15-自定义例外7</option>
                            <option value="16" class="language">16-自定义例外8</option>
                            <option value="17" class="language">17-自定义例外9</option>
                            <option value="18" class="language">18-自定义例外10</option>
                            <option value="19" class="language">19-自定义例外11</option>
                            <option value="20" class="language">20-自定义例外12</option>
                        </select></span></li>
                <li><span class="label language">每天关机时间：</span><input class="inp_t" style="width: 100px;" onclick="WdatePicker({ dateFmt: 'HH:mm' })" id="client_add_shutdowntime" name="client_add_shutdowntime" type="text">
                    <!--<span class="prompt">
                        <select name="client_add_waitacktime" id="client_add_waitacktime">
                            <option value="0" selected="">0-不等待应答</option>
                            <option value="1">1-每个数据均等待应答</option>
                            <option value="2">2-每2个数据等待应答</option>
                            <option value="3">3-每3个数据等待应答</option>
                            <option value="4">4-每4个数据等待应答</option>
                            <option value="5">5-每5个数据等待应答</option>
                            <option value="6">6-每6个数据等待应答</option>
                            <option value="7">7-每7个数据等待应答</option>
                        </select></span>--><input type="hidden" name="client_add_waitacktime" id="client_add_waitacktime" value="0" /></li>
            </ul>
        </div>
        <h6 class="language">区域属性</h6>
        <span class="ex_task language" id="client_add_ex1" data-isshow="0">展开</span>
        <div class="section" style="display: none;">
            <ul class="clearfix">
                <li><span class="label language">位置说明：</span><input class="inp_t" id="client_add_location" name="client_add_location" type="text"></li>

                <li>
                    <span class="label language">现场图片：</span><input style="display:none;" class="inp_t" id="client_add_picture" name="client_add_picture" runat="server" type="text">
                     <input type="file" name="client_add_picture_upload" style=" float: left;height:25px;width:228px;" id="client_add_picture_upload" />
                    <div class="showallbtn">
                        <a style="display:grid" href="javascript:void(0)"  onclick="previewPhoto()" class="language">预览</a>
                       
                    </div>
                </li>
                <li><span class="label language">地理坐标(经度)：</span><input class="inp_t" style="width: 100px;" id="sc_add_coordx" name="sc_add_coordx" value="0.0" type="text" readonly="readonly">
                    <!--margin-left:54px;-->
                    <span class="label language" style="margin-left:30px;">地理坐标(纬度)：</span><input class="inp_t" style="width: 100px;" id="sc_add_coordy" name="sc_add_coordy" value="0.0" type="text" readonly="readonly"><span class="prompt prompt_pic"><img src="/images/baidumap.png" alt="定位" onclick="client_loadBaiduMap()" style="cursor: pointer" /></span></li>
                <li><span class="label language">适用半径范围(米)：</span><input class="inp_t" style="width: 100px;" id="client_add_range" name="client_add_range" datatype="n" errormsg="必须为数字" type="text" value="1000"><tt class="Validform_checktip"></tt><span class="prompt language">比如：1000米</span>
                    <span class="label language" style="width: 140px;">显示屏类型：</span><select name="client_add_clienttype" id="client_add_clienttype" class="inp_t" style="width:120px;">
                        <option value="0" selected="" class="language">0-单横屏</option>
                        <option value="1" class="language">1-单竖屏</option>
                        <option value="100" class="language">2-双横屏</option>
                        <option value="101" class="language">3-双竖屏</option>
                        <option value="102" class="language">4-横竖组合屏</option>
                        <option value="10" class="language">5-高清单横屏</option>
                        <option value="11" class="language">6-高清单竖屏</option>
                        <option value="110" class="language">7-高清双横屏</option>
                        <option value="111" class="language">8-高清双竖屏</option>
                        <option value="112" class="language">9-高清横竖组合屏</option>
                    </select></li>
            </ul>
        </div>
        <h6 class="language">扩展属性</h6>
        <span class="ex_task language" id="client_add_ex2" data-isshow="0">展开</span>
        <div class="section" style="display: none;padding-bottom:0;">
            <ul class="clearfix">
               <%-- <li><span class="label">MAC地址：</span><input class="inp_t" id="client_add_mac" name="client_add_mac" type="text"></li>--%>
                <li><span class="label language">设置信息：</span><p style="width: 490px; padding: 10px; border: 1px solid #cdcdcd; border-radius: 3px; float: left;">
                    <span class="label" style="width: 80px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="1" id="settingsa1"><label for="settingsa1" class="language">自动播放</label></span>
                    <span class="label" style="width: 80px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="2" id="settingsa2"><label for="settingsa2" class="language">循环播放</label></span>
                    <span class="label" style="width: 130px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="3" id="settingsa3"><label for="settingsa3" class="language">分发前清空目录</label></span>
                    <span class="label" style="width: 150px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="4" id="settingsa4"><label for="settingsa4" class="language">连接后自动分发任务</label></span>
                    <span class="label" style="width: 130px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="5" id="settingsa5"><label for="settingsa5" class="language">空闲时播放缺省任务</label></span>
                    <span class="label" style="width: 100px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="6" id="settingsa6"><label for="settingsa6" class="language">上报播放信息</label></span>
                    <span class="label" style="width: 120px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="8" id="settingsa8"><label for="settingsa8" class="language">网址不可直接访问</label></span>
                    <span class="label" style="width: 100px; text-align: left">
                        <input name="client_add_settings" type="checkbox" value="9" id="settingsa9"><label for="settingsa9" class="language">重启代替关机</label></span>
                </p>
                </li>
                <li><span class="label language">播放日志上报周期：</span><input class="inp_t" style="width: 100px;" value="30" id="client_add_reportinterval" data-type="n" errormsg="必须为数字" name="client_add_reportinterval" type="text"><tt class="Validform_checktip"></tt><span class="prompt language">经过多少个查询周期(每周期缺省150秒)上报一次</span></li>
                <li><span class="label language">控制室网址：</span><input class="inp_t" id="client_add_host" name="client_add_host" type="text"></li>
                <li><span class="label language">控制室端口号：</span><input class="inp_t" id="client_add_hostport" name="client_add_hostport" type="text" value="0" data-type="n" errormsg="必须为数字"><tt class="Validform_checktip"></tt></li>
                <li><span class="label language">控制服务器地址：</span><input class="inp_t" id="client_add_ctlip" name="client_add_ctlip" type="text"></li>
                <li><span class="label language">控制服务器端口号：</span><input class="inp_t" id="client_add_ctlport" name="client_add_ctlport" type="text"><span class="label" style="text-align: left;margin-left:15px;"><input type="checkbox" name="client_add_ctloption" value="8" id="ctloptioncc"/><label for="ctloptioncc" class="language">启用控制服务器</label></span></li>
                <li><span class="label language">远程控制属性：</span><p style="width: 460px; float: left;">
                    <span class="label" style="width: 110px; text-align: left">
                        <input name="client_add_ctloption" type="checkbox" value="1" id="ctloption1"><label for="ctloption1" class="language">共享控制</label></span>
                    <span class="label" style="width: 170px; text-align: left">
                        <input name="client_add_ctloption" type="checkbox" value="2" id="ctloption2"><label for="ctloption2" class="language">连接后最小化</label></span>
                    <span class="label" style="width: 150px; text-align: left">
                        <input name="client_add_ctloption" type="checkbox" value="3" id="ctloption3"><label for="ctloption3" class="language">只浏览不控制</label></span>
                </p>
                </li>
                <li><span class="label language">远程控制颜色数：</span><p style="width: 460px; float: left;">
                    <span class="label" style="width: 75px; text-align: left">
                        <input name="client_add_ctlcolor" value="0" type="radio" id="ctlcolor_aa"><label for="ctlcolor_aa" class="language">2色</label></span>
                    <span class="label" style="width: 75px; text-align: left">
                        <input name="client_add_ctlcolor" value="1" type="radio" id="ctlcolor_bb"><label for="ctlcolor_bb" class="language">16色</label></span>
                    <span class="label" style="width: 85px; text-align: left">
                        <input name="client_add_ctlcolor" value="2" type="radio" id="ctlcolor_cc"><label for="ctlcolor_cc" class="language">256色</label></span>
                    <span class="label" style="width: 85px; text-align: left">
                        <input name="client_add_ctlcolor" value="3" type="radio" id="ctlcolor_dd"><label for="ctlcolor_dd" class="language">真彩色</label></span>
                </p>
                </li>
                <%--  <li><span class="label">推荐度：</span><input class="inp_t" id="client_add_recomand" name="client_add_recomand" datatype="n" errormsg="必须为1-100数字" type="text" value="30"><tt class="Validform_checktip"></tt></li>--%>

                <li><span class="label language">连续添加播放终端数量：</span><input class="inp_t" style="width: 100px;" value="1" id="client_add_onceaddnum" name="client_add_onceaddnum" type="text"><span class="prompt language">最大一次添加200条</span></li>
            </ul>
        </div>
        <div class="sc_add_btn clearfix" style="margin-left: 190px; float: left;">
            <span class="inp_btn addbtn" style="position:relative;">
                <b style="left:20px;"></b>
                <input class="btn language" value="保存" type="submit" style="padding-left:20px;"></span>
            <span class="inp_btn resetbtn" style="position:relative;">
                <b style="left:25px;"></b>
                <input class="btn language" value="重置" type="reset" style="padding-left:30px;"></span>
            <span class="inp_btn copybtn" style="position:relative;">
                <b style="left:10px;"></b>
                <input class="btn language" value="复制添加" id="client_btn_copy" type="submit" style="padding-left:20px;"></span>
            <span class="inp_btn fanhui" style="position:relative;">
                <b style="left:20px;"></b>
                <input class="btn language" value="返回" id="client_fanhui" type="button" onclick="client_main_loadright(0, clientid, dlevel, clientmark);" style="padding-left:25px;"></span>
        </div>
    </div>
</form>


