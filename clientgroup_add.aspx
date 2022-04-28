<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="clientgroup_add.aspx.cs" Inherits="Web.company.client.clientgroup_add" %>

<script type="text/javascript">
    var dlevel, clientid, clientmark;
    $(function () {
        getJsonValue();
        dlevel = $("#clientgroup_add_dlevel").val();
        clientid = $("#clientgroup_add_groupid").val();
        clientmark = $("#clientgroup_add_mark").val();//><a href="javascript:void(0)">播放终端列表</a>
        $("#client_main_pagemap").html('<a href="javascript:void(0)">' + getLanguageMsg('播放终端管理', $.cookie("yuyan")) + '</a>' + $("#client_group_add_pageMap").val());

        $("#myclientroot").html(getLanguageMsg($("#myclientroot").html(), $.cookie("yuyan")));
        if ($("#clientgroup_add_dlevel").val() == "0") {
            $("#clientgroup_addbox ul li:first").show();
        }
        //编辑 修改终端组
        if ($("#clientgroup_add_isedit").val() == "edit") {
            $("#clientgroup_add_mark").attr("readonly", "readonly");
            $(".btn[type='submit']").val(getLanguageMsg("保存", $.cookie("yuyan")));
            //$("#clientgroup_add_name").attr("readonly", "readonly");
            $.ajax({
                type: 'post',
                url: 'ajax/getclientgroupinfo.ashx',
                async: true,
                dataType: 'text',
                data: { "gid": $("#clientgroup_add_groupid").val() },
                success: function (data) {
                    var json = strToJson(data);

                    $.each(json.Table, function (idx, item) {

                        $("#clientgroup_add_mark").val(item.clientmark);
                        $("#clientgroup_add_name").val(item.clientname);
                        $("#clientgroup_add_descript").html(item.descript);
                        $("#clientgroup_add_location").val(item.location);
                        $("#clientgroup_add_recomand").val(item.recommend);
                        $("#clientgroup_add_picture").val(item.picture);
                        if (item.groupflag == "2") {//1是实体组,2为虚拟组
                            $("[name='clientgroup_add_groupflg'][value=2]").attr("checked", "checked");
                            $("#clientgroup_add_groupflg1").css("display", "none");
                            $("#clientgroup_add_groupflg2").css("display", "inline");
                        } else if (item.groupflag == "1") {
                            $("[name='clientgroup_add_groupflg'][value=1]").attr("checked", "checked");
                            $("#clientgroup_add_groupflg2").css("display", "none");
                            $("#clientgroup_add_groupflg1").css("display", "inline");
                        }
                        $("#previewPhotoDiv>img").attr("src", $("#clientgroup_add_picture").val());
                    });
                }
            });
        } else {//添加 终端组   //whq2.8
            console.log(clientid + " real or virtual");
            if (clientid == "0") {//播放终端根目录 //要添加 一级终端组.。。。。//一级终端组 也可以是虚拟的。
                $("#clientgroup_add_groupflg2").css("display", "inline");      //隐藏‘虚拟组’ 单选按钮
                $("#clientgroup_add_groupflg1").css("display", "inline");
                $("[name='clientgroup_add_groupflg'][value=1]").attr("checked", "checked");
            } else {
                var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                var myflag = treeObj.getNodesByParam("id", clientid, null);//根据 ID 获取 ‘点击的终端组’ 是不是虚拟的
                if (myflag.length > 0) {
                    if (myflag[0].groupflag == "2") {//1是实体组,2为虚拟组
                        $("#clientgroup_add_groupflg1").css("display", "none");//隐藏‘实体组’ 单选按钮
                        $("#clientgroup_add_groupflg2").css("display", "inline");
                        $("[name='clientgroup_add_groupflg'][value=2]").attr("checked", "checked");
                    } else if (myflag[0].groupflag == "1") {////显示  ‘实体组’、‘虚拟组’ 单选按钮
                        $("#clientgroup_add_groupflg1").css("display", "inline");
                        $("#clientgroup_add_groupflg2").css("display", "inline");
                    }
                }
            }


        }
        switchLanguage("#clientgroup_addbox", 1, "clientgroup_add.aspx");
        $("#clientgroup_add_picture_upload").live("change", function () {
            //console.log("upload...." + $(this).val());
            //debugger;
            var filename = $(this).val();
            filename = filename.split('\\')[filename.split('\\').length - 1];
            if ($(this).val() != "") {
                $.ajaxFileUpload({
                    url: 'ajax/receivepicture.ashx',
                    type: 'post',
                    secureuri: false, //一般设置为false
                    fileElementId: 'clientgroup_add_picture_upload', // 上传文件的id、name属性名
                    dataType: 'text', //返回值类型，一般设置为json、application/json
                    elementIds: "clientgroup_add_picture_upload", //传递参数到服务器
                    success: function (data, status) {
                        //debugger;
                        if (data <= 0) {
                            showError("clientgroup_add_picture", getLanguageMsg("上传错误", $.cookie("yuyan")), 0);
                        }
                        else {
                            if ($(".mod_sucess").length > 0) {
                                $(".mod_sucess").remove();
                            }
                            $("#clientgroup_add_picture").val(data);
                            //$("#clientgroup_add_picture_upload").after('<span style="float: left;padding-top: 5px;">'+ filename + '</span>');
                            $("#clientgroup_add_picture_upload").after('<span style="float: left;padding-top: 5px;">' + filename + '</span>' + "<div class=\"mod_sucess\"><span class=\"sucess_icon\"></span>" + getLanguageMsg("上传成功", $.cookie("yuyan")) + "</div>");
                            $("#previewPhotoDiv>img").attr("src", $("#clientgroup_add_picture").val());
                        }
                    },
                    error: function (data, status, e) {
                        alert(e);
                    }
                });
            }
        });
        $("#clientgroup_add").Validform({
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
            ajaxPost: true,
            //postonce: true,
            callback: function (d) {
                if (d.status == "y") {
                    if ($("#clientgroup_add_isedit").val() == "") {
                        TopTrip(getLanguageMsg("添加完成", $.cookie("yuyan")), 1);
                    } else { TopTrip(getLanguageMsg("修改完成", $.cookie("yuyan")), 1); }
                    loadParentPage1();
                }
                else {
                    if (d.info == -1) {
                        TopTrip(getLanguageMsg("终端组已存在", $.cookie("yuyan")), 2);
                    }
                    if (d.info == 0) {
                        TopTrip(getLanguageMsg("系统错误，请联系管理员", $.cookie("yuyan")), 3);
                    }
                }
            }
        });
    })
    //添加终端组，刷新页面。。。。备用。whq.
    function loadParentPage1() {
        debugger;
        if ($.cookie("mySelectNodeID") != "" && $.cookie("mySelectNodeID") != null) {//记录的上次点击的终端(组)
            $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());
        } else {
            $("#client_main_left").load("client_main_left.html?rnd=" + Math.random());
            client_main_loadright(0, clientid, dlevel, clientmark);
        }
        // $("#client_main_left").load("client_main_left.html");
    }

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
    //    var imgUrl = $("#clientgroup_add_picture").val();

    //    $("#previewPhotoDiv>img").attr("src", imgUrl);
    //}
</script>
<style>
    .zd_add_box ul li span.label {
        width: 240px;
    }
</style>
<div id="overlay" style="display: none"></div>
<div id="previewPhotoDiv" style="display: none; position: absolute; padding: 25px; background-color: #fff; z-index: 2001;">
    <img src="#" style="max-width: 800px; max-height: 600px;" />
    <div style="position: absolute; right: 0; top: 0; width: 30px; height: 30px; cursor: pointer;">
        <img src="/images/icon_closeBox.png" onclick="closeDiv()" />
    </div>
</div>
<form id="clientgroup_add" runat="server" method="post" action="ajax/addclient_group.ashx">
    <input type="hidden" id="clientgroup_add_dlevel" name="clientgroup_add_dlevel" runat="server" />
    <input type="hidden" id="clientgroup_add_groupid" name="clientgroup_add_groupid" runat="server" />
    <input type="hidden" id="clientgroup_add_isedit" name="clientgroup_add_isedit" runat="server" />
    <input type="hidden" id="client_group_add_pageMap" name="client_group_add_pageMap" runat="server" />
    <div class="zd_add_box" id="clientgroup_addbox">
        <ul class="clearfix">

            <li><span class="label language">终端组名称：</span><input class="inp_t" id="clientgroup_add_name" name="clientgroup_add_name" datatype="*" errormsg="终端名称不能为空" type="text"><tt class="Validform_checktip language">*唯一标记，最长64字节。</tt></li>
            <li style="display: none"><span class="label language">终端内部码：</span><input class="inp_t" id="clientgroup_add_mark" errormsg="终端内部码不能为空" name="clientgroup_add_mark" value="" runat="server" type="text"><%--datatype="*"  <tt class="Validform_checktip">*任意四位数字。</tt>--%></li>
            <li><span class="label language">终端组类别：</span><span class="label" style="text-align: left;">
                <span id="clientgroup_add_groupflg1" style="display: none;">
                    <input name="clientgroup_add_groupflg" value="1" type="radio" checked="checked"><span class="language">实体组</span></span>
                <span id="clientgroup_add_groupflg2" style="display: none;">
                    <input name="clientgroup_add_groupflg" type="radio" value="2"><span class="language">虚拟组</span></span>

            </span></li>
            <li><span class="label language" style="width: 240px;">描述（最多1024汉字）：</span><div class="intro" style="width: 450px;">
                <textarea class="txtarea" id="clientgroup_add_descript" name="clientgroup_add_descript" style="width: 430px;"></textarea>
            </div>
            </li>
            <li><span class="label language">位置说明：</span><input class="inp_t" id="clientgroup_add_location" name="clientgroup_add_location" type="text"></li>
            <li><span class="label language">推荐度：</span><input class="inp_t" id="clientgroup_add_recomand" name="clientgroup_add_recomand" type="text" value="30"></li>
            <li><span class="label language">现场图片：</span><input class="inp_t" style="display: none;" id="clientgroup_add_picture" name="clientgroup_add_picture" runat="server" type="text">
                <input type="file" name="clientgroup_add_picture_upload" style="float: left" id="clientgroup_add_picture_upload" />
                <div class="showallbtn">
                    <a href="javascript:void(0)" onclick="previewPhoto()" class="language">预览</a>

                </div>
            </li>
        </ul>
        <div class="sc_add_btn clearfix" style="margin-left: 190px;">
            <span class="inp_btn">
                <input class="btn language" value="添加" type="submit"></span><span class="inp_btn"><input class="btn language" value="取消" type="button" onclick="client_main_loadright(0, clientid, dlevel, clientmark);" /></span>
        </div>
    </div>
</form>

