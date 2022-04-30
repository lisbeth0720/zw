<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="department_pp_add.aspx.cs" Inherits="HuiFeng.Web.company.depart.department_pp_add" %>

<script src="/js/Validform_v5.3.2.js"></script>

<script type="text/javascript">
    //密码：必须带 字符，特殊字符和数字。。2-16
    var IllegalString = "[`~!#$^@%&*()=|_{}':;',\\[\\].<>/?~！#￥……&*（）——|{}【】‘；：”“'。，、？]‘’";
    function checkPassword(id) {
        //id   1  2
        var counts = 0;
        var ele = "";
        if (id==1) {
            ele = $("#department_pp_add_password").val();
        } else if (id==2) {
            ele = $("#department_pp_add_password2").val();            
        }
        if (ele.length < 8) {//还么有输入密码，，不用判断 是否包含‘特殊字符’！！！
            return;
        }
        for (var i = 0; i < IllegalString.length; i++) {
            if (ele.indexOf(IllegalString[i])>=0) {
                counts++; break;
            }
        }
        //if ($("#department_pp_add_password").val() != $("#department_pp_add_password2").val() && $("#department_pp_add_password2").val().length >= 8)         {
        //    $("#pass2").html('您两次输入的账号密码不一致！');
        //} else if (!/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/.test(ele)) {//字母、数字
        //    $("#pass" + id).html('密码必须包含字母、数字、特殊字符');
        if (!/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/.test(ele)) {//字母、数字
            $("#pass" + id).html('密码必须包含字母、数字、特殊字符');
        } else if ($("#department_pp_add_password").val() != $("#department_pp_add_password2").val() && counts > 0) {
            $("#pass2").html('您两次输入的账号密码不一致！');// && $("#department_pp_add_password2").val().length >= 8
            $("#pass" + id).html('');
        } else {
            $("#pass2").html('');
            if (counts <= 0 && ele.length >= 8) {
                //alert(counts + "密码必须包含特殊字符");
                $("#pass" + id).html('密码必须包含字母、数字、特殊字符');
            } else {//if (counts > 0)
                $("#pass" + id).html('');
            }
        }
    }
    $(function () {
        
        $("#department_pp_add").Validform({
            //rules: {
            //    department_pp_add_password: "required",
            //    department_pp_add_password2: {
            //        equalTo: "#department_pp_add_password"
            //    }
            //},
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
            usePlugin: {
                passwordstrength: {
                    minLen: 8,//设置密码长度最小值，默认为0;
                    maxLen: 16//设置密码长度最大值，默认为30;

                }
            },
            ajaxPost: true,
            //postonce: true,
            beforeSubmit: function (curform) {
                //在验证成功后，表单提交前执行的函数，curform参数是当前表单对象。
                //这里明确return false的话表单将不会提交;
                $("#department_pp_add_hdpname").val($("input[name=d_pp_add_radio]:checked").attr("data-name"));
                if ($("#pass1").html().length > 0 || $("#pass2").html().length > 0) {
                    return false;//密码必须包含特殊字符
                }
                if ($("#ServicePeople").is(":checked")) {
                    $("#isServicePeople").val("1");
                } else {
                    $("#isServicePeople").val("0");
                }
            },
            callback: function (d) {
                if (d.status == "y") {
                    // loadDepartContent(2);
                    TopTrip("保存成功",1);
                    if ($("#savetype").val()=="save") {
                        if ($(".index").length > 0) {//会议预约，使用
                            $(".index").load("/common/depart_main.aspx?t=2");
                        } else {
                            window.location.reload();
                        }
                    } else {
                        $("#mm2").load("/company/depart/common/depart_left.html");
                    }
                    
                    
                }
                else {
                    if (d.info == "-1") {
                        LoginTimeOut();
                    } else if(d.info=="0") {
                        TopTrip("用户名已存在！",2);
                    }
                }
            }
        });
        //获取部门列表
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getMyDepartList.ashx',
            async: false,
            dataType: 'text',
            data: {
                keyword: ""
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);//可能 没有部门
                    if (json.Table.length >=1) {
                        pp_add_DepartList(json);
                    }

                }
            }
        });
        var val = $("#depart_pp_add_parentid").val();
        $("input[name=d_pp_add_radio]").each(function () {
            if ($(this).val() == val) {
                $(this).attr("checked", true);
            }
        });
    })
    function saveAndAdd(isadd) {
        if (isadd=="") {
            $("#savetype").val("save");
        } else {
            $("#savetype").val("add");
        }
    }

    function pp_add_DepartList(data) {
        var html = "";
        $.each(data.Table, function (idx, item) {
            html += ' <li><label><input name="d_pp_add_radio" type="radio" data-name=' + item.department + '  value=' + item.departid + ' /> ' + item.department + '</label></li>';
        });
        $("#department_pp_add_dlist").html(html);//没有部门时   ，，TypeError: $(...)[0] is undefined
       // $("input[name=d_pp_add_radio]")[0].checked = true;//默认选择第一个部门。。。
        $("input[name=d_pp_add_radio]").eq(0).prop("checked", true);
    }
</script>
<form id="department_pp_add" action="/company/depart/ajax/AddManager.ashx" method="post">
    <input type="hidden" id="depart_pp_add_parentid" value="0" runat="server" />
    <div class="depart_add_box">
        <ul class="clearfix">
            <li><span class="label">账户名：</span><input class="inp_t" id="department_pp_add_name" type="text" ajaxurl="/company/depart/ajax/CheckName.ashx" datatype="s2-16" errormsg="用户名长度2-16" sucmsg="用户名可以使用" runat="server"><span class="font_red Validform_checktip">*</span><span><input type="checkbox" id="ServicePeople" name="ServicePeople" value="1" runat="server" />服务人员</span>
                <input type="hidden" id="isServicePeople" name="isServicePeople" value="0" />
            </li>
            <li><span class="label">姓名：</span><input class="inp_t" type="text" id="department_pp_add_fullname" runat="server" datatype="*" errormsg="用户姓名不能为空"><span class="font_red Validform_checktip">*</span></li>
            <li style="width:850px"><span class="label">密码：</span><input class="inp_t" type="password" datatype="*8-16" errormsg="密码长度8-16之间" id="department_pp_add_password" name="department_pp_add_password" value="" onblur="checkPassword(1)" plugin="passwordStrength" runat="server"><span class="font_red Validform_checktip"></span> <span id="pass1" class="font_red">*密码必须包含字母、数字、特殊字符</span></li>
            <li><span class="label">密码强度：</span><div class="passwordStrength"><span style="line-height: 18px;">弱</span><span style="line-height: 18px;">中</span><span style="line-height: 18px;" class="last">强</span></div>
            </li>
            <li><span class="label">确认密码：</span><input class="inp_t" type="password" datatype="*8-16" nullmsg="请再输入一次密码！"  id="department_pp_add_password2" name="department_pp_add_password2" onblur="checkPassword(2)"  runat="server"><span class="font_red Validform_checktip"></span><span id="pass2" class="font_red" >*密码必须包含字母、数字、特殊字符</span></li><%--recheck="department_pp_add_password"  datatype="s6-16"   errormsg="您两次输入的账号密码不一致！"--%>
            <li><span class="label">管理优先级：</span><select class="inp_t" id="department_pp_add_dlevel" name="department_pp_add_dlevel" runat="server" style="width:307px">
            </select><span class="font_red ">数字越小优先级越高</span></li>
            <li><span class="label">电子邮箱：</span><input class="inp_t" type="text" id="department_pp_add_email" datatype="e" errormsg="邮箱输入不正确" runat="server"><span class="font_red Validform_checktip">*</span></li>
            <li><span class="label">手机：</span><input class="inp_t" type="text" datatype="/[1][3-9][0-9]{9}$/ " errormsg="手机输入不正确" id="department_pp_add_mobile" runat="server"><span class="font_red Validform_checktip">*</span></li>
            <li><span class="label">其他联系方式：</span><input class="inp_t" type="text" id="department_pp_add_tel" runat="server"></li>
            <li><span class="label">描述：</span><input class="inp_t" type="text" id="department_pp_add_descript" runat="server"></li>
            <li><span class="label">隶属部门：<p class="font_red ">(可以修改部门)</p></span>
                <div class="check_area" style="overflow-y: scroll;height: 200px;width: 500px;
">
                    <ul class="clearfix" id="department_pp_add_dlist">
                    </ul>
                </div>
           
                <input type="hidden" id="department_pp_add_hdpname" name="department_pp_add_hdpname"  />
            </li>
        </ul>
        <div style="text-align: center">
            <span class="inp_btn addbtn colume_positioned">
                <b style="left:20px;"></b>
                <input type="submit" class="btn" title="添加" value="添加" style="padding-left:10px;" onclick="saveAndAdd('')"/>
            </span>
            <input type="hidden" name="savetype" id="savetype" value="save" />
            <span class="inp_btn addbtn colume_positioned" style="width:120px">
                <b style="padding-left: 1px;"></b>
                <input type="submit" class="btn" title="保存后继续添加" value="保存后继续添加" style="padding-left:30px;" onclick="saveAndAdd('add')"/>
            </span>
            <span class="inp_btn resetbtn colume_positioned">
                <b style="left:20px;"></b>
                <input class="btn" style="padding-left:10px;" title="重置" value="重置" onclick="reset()" type="reset">
            </span>
        </div>
    </div>
</form>
