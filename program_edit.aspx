<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_edit.aspx.cs" Inherits="Web.company.program.program_edit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-首页</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
</head>
<body>
    <!-- #include file="/common/top.html" -->
    <form id="program_add" action="ajax/saveprogram.ashx" runat="server"> 
        <div class="container clearfix">
            <input type="hidden" id="hid_oldname" name="hid_oldname" runat="server" value="0" />
            <input type="hidden" id="program_add_itemid" name="program_add_itemid" runat="server" value="0" />
            <input type="hidden" id="program_add_filed" name="program_add_filed" runat="server" value="0" />
            <div class="jmd_add_box">
                <ul class="clearfix">
                    <li><span class="label">节目单名称：</span><input class="inp_t" type="text" id="program_add_name" name="program_add_name" style="width:395px;"><tt>*（如出现名称重复情况，可在末尾加随机数 如"755"）</tt></li>
                    <!--<li><span class="label">节目单组：</span><select class="inp_t" id="program_add_group" name="program_add_group" style="width:167px;padding-left:0;"></select></li>-->
                    <!--<li><span class="label">宽度(像素)：</span><input class="inp_t" id="program_add_width" name="program_add_width" style="width: 120px;" type="text"></li>
                    <li><span class="label">高度(像素)：</span><input class="inp_t" id="program_add_height" name="program_add_height" style="width: 120px;" type="text"></li>-->
                    <li>
                        <span class="label">宽度(像素)：</span><input class="inp_t" id="program_add_width" name="program_add_width" style="width: 120px;" type="text">
                        <span class="label" style="width:97px;">高度(像素)：</span><input class="inp_t" id="program_add_height" name="program_add_height" style="width: 120px;" type="text">
                        <span class="label" style="width:97px;">节目单组：</span><select class="inp_t" id="program_add_group" name="program_add_group" style="width:167px;padding-left:0;"></select>
                    </li>
                    
                    <li><span class="label">描述：</span><div class="intro" style="width: 450px;">
                        <textarea class="txtarea" id="program_add_descript" name="program_add_descript" style="width: 430px;"></textarea>
                    </div>
                    </li>
                    <li><span class="label">推荐度</span><input class="inp_t" id="program_add_recommend" name="program_add_recommend" value="30" style="width: 120px;" type="text"></li>
                </ul>
                <div class="sc_add_btn clearfix" style="margin-left: 190px;">
                    <input type="hidden" id="program_add_isedit" name="program_add_isedit" value="0" />
                    <input type="hidden" id="program_add_iscopy" name="program_add_iscopy" value="0" />
                    <span class="inp_btn pro_genxin colume_positioned">
                        <b></b>
                        <input type="button" value="更新节目单" class="btn" onclick="program_add_edit()" style="padding-left:35px;"/></span> 
                    <span class="inp_btn resetbtn colume_positioned">
                        <b style="left:20px;"></b>
                        <input type="reset" value="重置" class="btn" style="padding-left:48px;"/></span>
                    <span class="inp_btn addbtn colume_positioned">
                        <b style="left:12px;"></b>
                        <input type="button" value="复制添加" class="btn" onclick="program_add_copy()" style="padding-left:35px;"/></span>

                </div>
            </div>
        </div>
         <script type="text/javascript">
             $(function () {
                 if ($("#program_add_filed").val() == 1) {
                     $(".savebtn").html("").hide();
                 }
                 $.ajax({
                     type: 'post',
                     url: '/company/source/ajax/getgroupinfo.ashx',
                     data: { "grouptype": "2" },
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
                         $("#program_add_group").html(html);
                     }
                 });
                 if ($("#program_add_itemid").val() != "0") {
                     $(".intro_font").fadeOut();
                     $.ajax({
                         type: 'post',
                         url: 'ajax/getprograminfo.ashx',
                         async: true,
                         data: { id: $("#program_add_itemid").val() },
                         dataType: 'text',
                         success: function (data) {
                             var json = strToJson(data);

                             $.each(json.Table, function (idx, item) {
                                 $("#program_add_name").val(item.itemname);
                                 $("#program_add_descript").val(item.descript);
                                 $("#program_add_width").val(item.framesizex);
                                 $("#program_add_height").val(item.framesizey);
                                 $("#program_add_group").val(item.classify1);
                                 $("#program_add_filed").val(item.isfiled);
                                 $("#program_add_recommend").val(item.recommend);
                                 $("#hid_oldname").val(item.itemname);
                             });
                             program_add_loadList();
                         }
                     });

                 }
                 //setTimeout(program_add_loadList, 500);

                 //表单验证并提交
                 /*$("#program_add").Validform({
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
                     postonce: true,
                     callback: function (d) {
                         if (d.status == "y") {
                             TopTrip("节目单添加完成！", 1);
                             program_add_loadList();
                         }
                         else {
                             if (d.status == "-1") {
                                 LoginTimeOut();
     
                             }
                             else if (d.status == "-2") {
                                 TopTrip("节目单名已存在", 3);
                             }
                             else {
                                 TopTrip("系统错误，请联系管理员", 3);
                             }
                         }
                     }
                 });*/

             })
             function program_add_edit() {
                 if ($("#program_add_filed").val()=="1") {
                     TopTrip("归档节目单，不能修改！", 2);
                     return;
                 }
                 $("#program_add_isedit").val(1);
                 ajaxEdit();
             }
             function program_add_copy() {
                 $("#program_add_iscopy").val(1);
                 ajaxEdit();
             }
             function program_add_loadList() {
                 ClearProgramListHtml();
                 $("#program_add_programlist").load("program_list.aspx", { "t": 5 }, function () {
                     $("#program_add_programlist").slideDown();
                 });
             }
             function ajaxEdit() {
                 $.ajax
                ({
                    type: 'post',
                    url: 'ajax/saveprogram.ashx',
                    async: true,
                    dataType: 'html',//script
                    data: $("#program_add").serialize(),
                    success: function (data) {
                        eval(data);
                    }
                })
             }
    </script>
    </form>
       <div class="list_box" id="program_add_programlist">
        </div>
</body>
</html>
