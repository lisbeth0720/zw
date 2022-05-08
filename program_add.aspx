<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="program_add.aspx.cs" Inherits="Web.company.program.program_add" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>数字媒体信息发布服务平台-添加节目单</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/Validatedemo.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/date/WdatePicker.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script src="/js/Validform_v5.3.2.js"></script>
    <script type="text/javascript">
        $(function () {
            switchLanguage("#zyyProgramaddContainer", 1, "program_add.aspx");
            program_add_loadList();
            
           
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
                            $("#program_add_descript").val(item.descript);
                            $("#program_add_width").val(item.framesizex);
                            $("#program_add_height").val(item.framesizey);
                            $("#program_add_group").val(item.classify1);
                            $("#program_add_recommend").val(item.recommend);
                        });
                    }
                })
            }
            else {
                if ($.cookie("ProgramAttribute") != null) {

                    var cookie = $.cookie("ProgramAttribute");
                    var values = cookie.split("&");
                    for (var i = 0; i < values.length; i++) {
                        var key = values[i].split("=")[0];
                        var value = values[i].split("=")[1];
                        if (key == "FramesizeX") {
                            $("#program_add_width").val(value);
                            continue;
                        }
                        if (key == "FramesizeY") {
                            $("#program_add_height").val(value);
                            continue;
                        }
                        if (key == "Descript" && value != "") {
                            $("#program_add_descript").val(value);
                            continue;
                        }
                        if (key == "Recommend") {
                            $("#program_add_recommend").val(value);
                        }
                        if (key == "Classify1") {
                            $("#program_add_group").val(value);
                        }
                    }
                }
            }
            $("#program_add_name").blur(function () {
                if ($(this).val() == "" || $(this).val() == null) {
                    $("#nameNull").css("display","block");
                } else {
                    $("#nameNull").css("display", "none");
                }
            });
            //表单验证并提交
          //$("#program_add").Validform({
          //      tiptype: function (msg, o, cssctl) {
          //          if (!o.obj.is("form")) {
          //              var objtip = o.obj.siblings(".Validform_checktip");
          //              cssctl(objtip, o.type);
          //              objtip.text(msg);
          //          } else {
          //              var objtip = o.obj.find("#msgdemo");
          //              cssctl(objtip, o.type);
          //              objtip.text(msg);
          //          }
          //      },
          //      ajaxPost: true,
          //      //postonce: true,
          //      callback: function (d) {
          //          if (d.status == "y") {
          //              TopTrip("节目单添加完成！", 1);
          //              program_add_loadList();
          //          }
          //          else {
          //              if (d.info == "-1") {
          //                  LoginTimeOut();

          //              }
          //              else {
          //                  TopTrip("系统错误，请联系管理员", 3);
          //              }
          //          }
          //      }
          //  });
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
            })
           
        })
        function program_add_SaveModelAtt() {
            $("#program_add_savemodel").val(1);
            ajaxEdit();
        }
        function program_add_Save() {
            ajaxEdit();
        }
        function program_add_loadList() {
            ClearProgramListHtml();
            $("#program_add_programlist").load("program_list.aspx", { "t": 5 }, function () {
                $("#program_add_programlist").slideDown();
            });
        }
        function ajaxEdit() {
            if ($("#program_add_name").val() == "" || $("#program_add_name").val() == null) {
                $("#nameNull").css("display", "block");
                return false;
            } 
            $.ajax({
               type: 'post',
               url: 'ajax/saveprogram.ashx',
               async: true,
               dataType: 'html',//script
               data: $("#program_add").serialize(),
               success: function (data) {
                   eval(data);
               }
           });
        }
    </script>
</head>
<body>
    <form id="program_add" action="ajax/saveprogram.ashx" runat="server">
        <div id="overlay" style="display: none"></div>
        <!-- #include file="/common/top.html" -->
        <div class="container clearfix" id="zyyProgramaddContainer">
            <input type="hidden" id="program_add_itemid" name="program_add_itemid" runat="server" value="0" />
            <div class="pos_area2 clearfix">
                <div class="pos">
                    <a href="program_list.aspx?t=0" class="language">节目单管理</a>&gt;<a class="current language" title="添加节目单" href="program_add.aspx">添加节目单</a>
                    <a href="program_list.aspx?t=0" class="sorce_add language" title="节目单列表" style="padding-left: 35px;position: relative;"><b style="width:20px;height:20px;display:block;background:url(/images/tubiaoa.png) -60px -125px;position:absolute;top:0;left:11px;"></b><span class="language">节目单列表</span></a>
                </div>
            </div>
            <div class="jmd_add_box">
                <ul class="clearfix">
                    <li><span class="label language">节目单名称：</span><input class="inp_t" type="text" datatype="*"  errormsg="*" nullmsg="*" id="program_add_name" name="program_add_name"><tt>*</tt><span id="nameNull" style="display:none;color:red" class="language">节目单名称不能为空</span></li>
                    <li><span class="label language">节目单组：</span><select class="inp_t" id="program_add_group" name="program_add_group"></select></li>
                    <li><span class="label language">对应屏幕宽度(像素)：</span><input class="inp_t" id="program_add_width" name="program_add_width" value="1024" style="width: 120px;"  type="text"/></li>
                    <li><span class="label language">对应屏幕高度(像素)：</span><input class="inp_t" id="program_add_height" name="program_add_height" value="768" style="width: 120px;"  type="text"/></li>
                    <li><span class="label language">描述：</span><div class="intro" style="width: 450px;">
                        <textarea class="txtarea" id="program_add_descript" name="program_add_descript"  style="width: 430px;"></textarea>
                    </div>
                    </li>
                    <li><span class="label language">推荐度</span><input class="inp_t" id="program_add_recommend" name="program_add_recommend" value="30" style="width: 120px;" type="text"/></li>
                </ul>
                <div class="sc_add_btn clearfix" style="margin-left: 190px;">
                    <input type="hidden" id="program_add_savemodel" name="program_add_savemodel" value="0" />
                    <span class="inp_btn addbtn colume_positioned" style="margin-left:60px;">
                        <b></b>
                        <input type="button" value="添加节目单" title="添加节目单" class ="btn colume_save language" onclick="program_add_Save()" /></span>
                    <span class="inp_btn copybtn colume_positioned" style="display:none;">
                        <b style="left:10px;"></b>
                        <input type="button" value="保存模板" class="btn language" title="保存模板" onclick="program_add_SaveModelAtt()" style="padding-left:40px;"/></span>
                    <span class="inp_btn resetbtn colume_positioned">
                        <b style="left:20px"></b>
                        <input type="reset" value="重置" title="重置" class="btn language" style="padding-left:46px;"/></span>

                </div>
            </div>
        </div>
        <div class="list_box" id="program_add_programlist">
        </div>
    </form>
</body>
</html>
