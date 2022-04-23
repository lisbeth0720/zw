
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_add.aspx.cs" Inherits="Web.company.column.column_add" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-添加栏目</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery-ui/jquery-ui.js"></script>
    <script src="/js/jquery.fileupload.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script type="text/javascript">
        $(function () {
            column_add_loadcolumn_list();
            if ($.cookie("ColumnAttribute") != null) {
                var cookie = $.cookie("ColumnAttribute");
                console.log(cookie);
                var values = cookie.split("&");
                for (var i = 0; i < values.length; i++) {
                    var key = values[i].split("=")[0];
                    var value = values[i].split("=")[1];
                    if (key == "Credit") {
                        $("#cl_add_credit").val(value);
                        continue;
                    }
                    if (key == "OutId") {
                        $("#column_add_tempid").val(value);
                        continue;
                    }
                    if (key == "TempName" && value != "") {
                        $("#colum_add_tempname").val(value);
                        continue;
                    }
                    if (key == "FramesizeX") {
                        $("#colum_add_width").val(value);
                    }
                    if (key == "FramesizeY") {
                        $("#colum_add_height").val(value); 
                    }
                    if (key == "Descript") {
                        $("#colum_add_descript").val(value);
                    }
                    if (key == "Opentime" && value > 0) {
                        $("#cl_add_opentime").val(value);
                    }
                    if (key == "BillType") {
                        $("#cl_add_billtype").val(value);
                    }
                    if (key == "Chargingtime") {
                        $("#cl_add_chargingtime").val(value);
                    }
                }
            }
            $.ajax({
                type: 'post',
                url: '/company/source/ajax/getgroupinfo.ashx',
                data: { "grouptype": "1" },
                async: true,
                dataType: 'text',
                success: function (data) {
                    var json = eval("(" + data + ")");
                    var html = "";
                    var childlist;
                    $.each(json.child, function (idx, item) {
                        if (item.groupflag == 1) {
                            html += '<option value="' + item.classifyid + '" disabled="">' + item.classifyname + '</option>';
                        }
                        else {
                            html += '<option value="' + item.classifyid + '">' + item.classifyname + '</option>';
                        }
                        childlist = item.child;
                        $.each(childlist, function (idx, item) {

                            if (item.groupflag == 1) {
                                html += '<option value="' + item.classifyid + '" disabled="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                            }
                            else {
                                html += '<option value="' + item.classifyid + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                            }
                            var childlist2 = item.child;
                            $.each(childlist2, function (idx, item) {
                                if (item.groupflag == 1) {
                                    html += '<option value="' + item.classifyid + '" disabled="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                                }
                                else {
                                    html += '<option value="' + item.classifyid + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + item.classifyname + '</option>';
                                }
                            });
                        });
                    });
                    $("#cl_add_group").html(html);
                }
            })

            //添加表单验证
            $("#column_add").Validform({
                tiptype: function (msg, o, cssctl) {
                    //msg：提示信息;
                    //o:{obj:*,type:*,curform:*}, obj指向的是当前验证的表单元素（或表单对象），type指示提示的状态，值为1、2、3、4， 1：正在检测/提交数据，2：通过验证，3：验证失败，4：提示ignore状态, curform为当前form对象;
                    //cssctl:内置的提示信息样式控制函数，该函数需传入两个参数：显示提示信息的对象 和 当前提示的状态（既形参o中的type）;
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
                //postonce: true,//提交一次，，
                callback: function (d) {
                    if (d.status == "y") {
                        TopTrip("栏目保存成功", 1);
                        $("#column_add")[0].reset();//添加栏目之后，清空页面文本框数据。
                        //column_add_loadcolumn_list();//重新加载页面，  显示方式会变成  图形。。
                        if ($("#cl_list_show").val()=="0") {
                            $("#cl_list_pic_list_loadbtn").click();
                        } else {
                            $("#cl_list_tab_list_loadbtn").click();
                        }
                    }
                    else {
                        if (d.info == "-1") {
                            LoginTimeOut();

                        }
                        else {
                            TopTrip("系统错误，请联系管理员", 3);
                        }
                    }
                    $("#overlay").slideUp();
                }
            });
        })

        function column_add_seltemp() {
            //清除模板列表页面内容
            ClearTempListHtml();
            $("#overlay").fadeIn(function () {
                $("#seltemppage").load("/company/templet/templetlist.aspx", { "t": 1 }, function () {
                    $("#seltemppage").fadeIn();
                });
            })
        }
        function cl_add_SaveModelAtt() {
            $("#cl_add_savemodel").val("1");
        }
        function column_add_loadcolumn_list() {
            $("#column_add_columnlist").load("column_list.aspx", { "t": 5 }, function () {
                $("#column_add_columnlist").slideDown();
            });
        }
        $("#templet_list_closebtn").die().live("click", function () {
            $("#seltemppage").fadeOut(function () {
                $("#overlay").fadeOut();
                $("#seltemppage").empty();
            });
        });
    </script>
</head>
<body>
    <form id="column_add" action="ajax/savecolumn.ashx">
        <div id="overlay" style="display: none"></div>
        <!-- #include file="/common/top.html" -->
        <div class="container clearfix">
            <input type="hidden" id="cl_add_itemid" name="cl_add_itemid" runat="server" value="0" />
            <div class="pos_area2 clearfix">
                <div class="pos">
                    <a href="column_list.aspx?t=0">栏目管理</a>&gt;<a class="current" title="添加栏目" href="column_add.aspx">添加栏目</a>
                    <a href="column_list.aspx?t=0" title="栏目列表" class="sorce_add" style="padding-left: 35px;position: relative;"><b style="width:20px;height:20px;display:block;background:url(/images/tubiaoa.png) -60px -125px;position:absolute;top:0;left:11px;"></b>栏目列表</a>
                </div>
            </div>
            <div class="column_con">
                <div class="lm_add_box">
                    <ul class="clearfix">
                        <li><span class="label" style="width: 180px;">栏目名称：</span>
                            <input class="inp_t" type="text" datatype="*" errormsg="*" id="colum_add_name" name="colum_add_name" /><tt class="font_red Validform_checktip">*</tt>

                        </li>
                        <li><span class="label" style="width: 180px;">推荐度：</span>
                            <input class="inp_t" id="cl_add_credit" name="cl_add_credit" value="30" style="width: 120px;" type="text" />
                            <span class="label" style="width: 100px;">预设模板：</span>
                            <input class="inp_t" type="text" id="colum_add_tempname"  value="0" readonly="readonly"  style="width: 120px;" name="colum_add_tempname" /><input type="hidden" id="column_add_tempid" name="column_add_tempid" />
                            <span class="showallbtn"><a href="javascript:void(0)" title="选择" onclick="column_add_seltemp()">选择</a></span>
                        </li>
                        <li><span class="label" style="width: 180px;">宽度(像素)：</span>
                            <input class="inp_t" id="colum_add_width" name="colum_add_width" value="" style="width: 120px;" type="text"  placeholder="不填写为全屏模式"/>
                            <span class="label" style="width: 100px;">高度(像素)：</span>
                            <input class="inp_t" id="colum_add_height"  name="colum_add_height" value="" style="width: 120px;" type="text" placeholder="不填写为全屏模式"/>
                            <span class="label" style="width: 100px;">栏目分组：</span><select class="inp_t" style="width: 120px;" id="cl_add_group" name="cl_add_group">
                            </select>
                        </li>
                        <li><span class="label" style="width: 180px;">广告服务时长：</span>
                            <input class="inp_t" id="cl_add_opentime" name="cl_add_opentime"  value="0" style="width: 120px;" type="text"><tt class="font_red Validform_checktip">(秒)</tt>
                            <span class="label" style="width: 100px;">费率时长：</span>
                            <input class="inp_t" id="cl_add_chargingtime" name="cl_add_chargingtime"  value="0"  style="width: 120px;" type="text"><tt class="font_red Validform_checktip">(秒)</tt>
                            <span class="label" style="width: 100px;">费率价格：</span>
                            <input class="inp_t" id="cl_add_billtype" name="cl_add_billtype"  value="0"  style="width: 120px;" type="text">
                        </li>
                        <li><span class="label" style="width: 180px;">描述：</span><div class="intro" style="width: 450px;">
                            <textarea class="txtarea" style="width: 430px;" id="colum_add_descript" name="colum_add_descript"></textarea>
                        </div>
                        </li>
                    </ul>
                    <div class="sc_add_btn clearfix" style="margin-left: 190px;">
                        <input type="hidden" id="cl_add_savemodel" name="cl_add_savemodel" value="0" />
                        <span class="inp_btn addbtn colume_positioned" style="margin-left:60px;">
                            <b style="left:10px;"></b>
                            <input type="submit" value="添加栏目" title="添加栏目" class="btn" style="padding-left:20px;"/>
                        </span>
                        <span class="inp_btn copybtn colume_positioned" style="display:none;">
                            <b style="left:10px;"></b>
                            <input type="submit" value="保存模板" title="保存模板" class="btn" style="padding-left:20px;" onclick="cl_add_SaveModelAtt()" />
                        </span>
                        <span class="inp_btn resetbtn colume_positioned">
                            <b style="left:20px;"></b>
                            <input type="reset" value="重置" title="重置" class="btn" style="padding-left:18px;"/>
                        </span>
                    </div>
                </div>

            </div>
            <div id="seltemppage" class="mb_list_box" style="display: none; position: absolute; z-index: 1000; background: #f7f7f7; top: 120px;"></div>
        </div>
        <div class="list_box" id="column_add_columnlist">
        </div>
    </form>
</body>
</html>
