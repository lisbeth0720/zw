<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="column_edit.aspx.cs" Inherits="Web.company.column.column_edit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-首页</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/bootstrap.css" rel="stylesheet" />
    <link href="/css/zTreeStyle.css" rel="stylesheet" />
    <link href="/css/jquery-ui-1.8.17.custom.css" rel="stylesheet" />
    <link href="/css/jquery-ui-timepicker-addon.css" rel="stylesheet" />
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <link href="/css/simplePagination.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/ckeditor/ckeditor.js"></script>
    <script src="/js/jquery-ui-1.9.2.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/jquery.fileupload.js"></script>
    <script src="/js/jquery.iframe-transport.js"></script>
    <script src="/js/bootstrap.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/jquery.colorpicker.js"></script>
    <script src="/js/jquery.simplePagination.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script src="/js/jquery.ztree.core-3.5.js"></script>
    <script src="/js/ajaxfileupload.js"></script>
    <script src="/js/passwordStrength.js"></script>
    <script src="/js/jquery.dragsort-0.5.2.min.js"></script>
    <script src="/js/raphael-min.js"></script>
    <script type="text/javascript">
        $(function () {
            if ($("#cl_add_sq").val() == "1") {
                $(".savebtn").html("").hide();
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
            });
            if ($("#cl_add_itemid").val() != "0") {//栏目分组：下拉列表。赋值
                $(".intro_font").fadeOut();
                $.ajax({
                    type: 'post',
                    url: 'ajax/getcolumninfo.ashx',
                    async: true,
                    data: { id: $("#cl_add_itemid").val() },
                    dataType: 'text',
                    success: function (data) {
                        //console.log(data);
                        var json = strToJson(data);
                        //var groupValue = "#cl_add_group option[value='!']:first";
                        $.each(json.Table, function (idx, item) {
                            $("#hid_oldname").val(item.itemname);
                            $("#colum_add_name").val(item.itemname);
                            $("#colum_add_descript").val(item.descript);//undefined  descript
                            $("#colum_add_tempname").val(item.template);
                            $("#column_add_tempid").val(item.outid);
                            $("#colum_add_width").val(item.framesizex);
                            $("#colum_add_height").val(item.framesizey); 
                            $("#cl_add_group").val(item.classify1);//
                            $("#cl_add_filed").val(item.isfiled);
                            $("#cl_add_credit").val(item.recommend);
                            //groupValue = groupValue.replace("!", item.classify1);
                            //$(groupValue).prop("selected", true);//.attr("selected", true)
                        });
                        column_add_loadcolumn_list();
                    }
                });

            }

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
                beforeSubmit: function () {
                    if ($("#cl_add_filed").val() == "1") {
                        TopTrip("归档栏目，不能修改!", 2);
                        return false;
                    }
                },
                ajaxPost: true,
                postonce: true,
                callback: function (d) {
                    if (d.status == "y") {
                        TopTrip("栏目保存成功", 1);
                        column_add_loadcolumn_list();
                    }
                    else {
                        if (d.status == "-1") {
                            LoginTimeOut();

                        }
                        else if (d.status == "-100") {
                            TopTrip("归档栏目，不能修改!", 2);
                        }
                        else if (d.status == "-2") {
                            TopTrip("栏目名已存在，请修改后重新保存！", 3);
                        }
                        else {
                            TopTrip("系统错误，请联系管理员", 3);
                        }
                    }
                    $("#overlay").slideUp();
                }
            });
        })
        //关闭‘模板显示’ 页面
        $("#templet_list_closebtn").die().live("click", function () {
            $("#seltemppage").fadeOut(function () {
                $("#overlay").fadeOut();
                $("#seltemppage").empty();
            });
        });
        function column_add_seltemp() {
            //清除模板列表页面内容
            ClearTempListHtml();
            $("#seltemppage").load("/company/templet/templetlist.aspx", { "t": 1 }, function () {
                $("#seltemppage").slideDown();

            });
        }
        function cl_add_edit() {
            if ($("#program_add_filed").val() == "1") {
                TopTrip("归档栏目，不能修改！", 2);
                return;
            }
            $("#cl_add_isedit").val("1");
        }
        function cl_add_copy() {
            $("#cl_add_iscopy").val("1");
        }
        function column_add_loadcolumn_list() {
            ClearColumnListHtml();
            $("#column_add_columnlist").load("column_list.aspx", { "t": 5 }, function () {
                $("#column_add_columnlist").slideDown();
            });
        }
    </script>
    
</head>
<body>
    <form id="column_add" action="ajax/savecolumn.ashx">
        <div id="overlay" style="display: none"></div>
        <!-- #include file="/common/top.html" -->
        <div class="container clearfix">
            <input type="hidden" id="cl_add_itemid" name="cl_add_itemid" runat="server" value="0" />
            <input type="hidden" id="cl_add_sq" name="cl_add_sq" runat="server" value="0" />
            <input type="hidden" id="cl_add_filed" name="cl_add_filed" runat="server" value="0" />
            <input type="hidden" id="hid_oldname" name="hid_oldname" />
            <div class="pos_area2 clearfix">
                <div class="pos"><a href="column_list.aspx?t=0">栏目管理</a>&gt;<a class="current" href="column_add.aspx">编辑栏目</a></div>
            </div>
            <div class="column_con">
                <div class="lm_add_box">
                    <ul class="clearfix">
                        <li>
                            <span class="label" style="width: 180px;">栏目名称：</span>
                            <input class="inp_t" type="text" datatype="*" errormsg="名称不能为空" id="colum_add_name" name="colum_add_name" style="width:357px;"><tt class="font_red Validform_checktip">*</tt>

                        </li>
                        <li>
                            <span class="label" style="width: 180px;">推荐度：</span>
                            <input class="inp_t" id="cl_add_credit" name="cl_add_credit" value="30" style="width: 120px;" type="text">
                            <span class="label" style="width: 100px;">预设模板：</span>
                            <input class="inp_t" type="text" id="colum_add_tempname" readonly="readonly" name="colum_add_tempname" style="width:120px;"><input type="hidden" id="column_add_tempid" name="column_add_tempid" />
                            <span class="showallbtn" style="margin-left:37px;"><a href="javascript:void(0)" onclick="column_add_seltemp()">选择</a></span>
                        </li>
                        <li>
                            <span class="label" style="width: 180px;">宽度(像素)：</span>
                            <input class="inp_t" id="colum_add_width" name="colum_add_width" style="width: 120px;" type="text" value="">
                            <span class="label" style="width: 100px;" >高度(像素)：</span>
                            <input class="inp_t" name="colum_add_height" id="colum_add_height" style="width: 120px;" type="text" value="">
                            <span class="label" style="width: 100px;">栏目分组：</span><select class="inp_t" style="width: 127px;" id="cl_add_group" name="cl_add_group">
                            </select>
                        </li>
                        <li>
                            <span class="label" style="width: 180px;">广告服务时长：</span>
                            <input class="inp_t" id="cl_add_opentime" name="cl_add_opentime" value="0" style="width: 120px;" type="text">
                            <span class="label" style="width: 100px;">费率时长：</span>
                            <input class="inp_t" id="cl_add_chargingtime" name="cl_add_chargingtime" value="0" style="width: 120px;" type="text">
                            <span class="label" style="width: 100px;">费率价格：</span>
                            <input class="inp_t" id="cl_add_billtype" name="cl_add_billtype" value="0" style="width: 120px;" type="text">
                        </li>
                        <li>
                            <span class="label" style="width: 180px;">描述：</span><div class="intro" style="width: 450px;">
                                <textarea class="txtarea" style="width: 430px;" id="colum_add_descript" name="colum_add_descript"></textarea>
                            </div>
                        </li>
                    </ul>
                    <div class="sc_add_btn clearfix" style="margin-left: 190px;">
                        <input type="hidden" id="cl_add_isedit" name="cl_add_isedit" value="0" />
                        <input type="hidden" id="cl_add_iscopy" name="cl_add_iscopy" value="0" /> 
                        <span class="inp_btn pro_genxin colume_positioned">
                            <b></b>
                            <input type="submit" value="更新栏目" class="btn" onclick="cl_add_edit()" style="padding-left:40px;"/>
                        </span>
                        <span class="inp_btn resetbtn colume_positioned">
                            <b style="left:20px;"></b>
                            <input type="reset" value="重置" class="btn" style="padding-left:47px"/>
                        </span>
                        <span class="inp_btn addbtn colume_positioned">
                             <b style="left:13px;"></b>
                            <input type="submit" value="复制添加" class="btn" onclick="cl_add_copy()" style="padding-left:37px"/>
                        </span>
                    </div>
                </div>
            </div>
            <div id="seltemppage" class="mb_list_box" style="display: none; position: absolute; z-index: 1000; background: #f7f7f7; top: 240px;"></div>
        </div>
        <div class="list_box" id="column_add_columnlist">
        </div>
    </form>
</body>
</html>
