<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="department_pp_detail.aspx.cs" Inherits="HuiFeng.Web.company.depart.department_pp_detail" %>

<script type="text/javascript">
    //密码：必须带 字符，特殊字符和数字。。2-16
    var IllegalString = "[`~!#$^@%&*()=|_{}':;',\\[\\].<>/?~！#￥……&*（）——|{}【】‘；：”“'。，、？]‘’";
    function checkPassword(id) {
        //$("#department_pp_add_password").val("?????????h");
        //$("#department_pp_add_password2").val("?????????h");
        //修改用户，可以不修改密码。。。
        if ($("#department_pp_add_password").val()=="?????????h" && $("#department_pp_add_password2").val()=="?????????h") {
            $("#pass1").html('');
            $("#pass2").html('');
            return;
        }
        //id   1  2
        var counts = 0;
        var ele = "";
        if (id == 1) {
            ele = $("#department_pp_add_password").val();
        } else if (id == 2) {
            ele = $("#department_pp_add_password2").val();
        }
        if (ele.length < 8) {//还么有输入密码，，不用判断 是否包含‘特殊字符’！！！
            return;
        }
        for (var i = 0; i < IllegalString.length; i++) {
            if (ele.indexOf(IllegalString[i]) >= 0) {
                counts++; break;
            }
        }
        

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
    function showeditppdiv() {
        $("#editppdiv").slideDown();

    }

    $(function () {
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
                    var json = strToJson(data);
                    pp_add_DepartList(json);

                }
            }
        });
        $("#department_pp_detail").Validform({
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
            beforeSubmit: function (curform) {
                //在验证成功后，表单提交前执行的函数，curform参数是当前表单对象。
                //这里明确return false的话表单将不会提交;
                if ($("#department_pp_add_password").val() != $("#department_pp_add_password2").val()) {
                    TopTrip("您两次输入的账号密码不一致！", 2);
                    return false;
                }
                if ($("#pass1").html().length > 0 || $("#pass2").html().length > 0) {
                    return false;//密码必须包含特殊字符
                }
                if ($("#oldMerit").val() < $("#loginMerit").val()) {
                    //自己优先级低于  - 要编辑用户的优先级
                    TopTrip("您无权限修改", 3);
                    return false;
                }
                $("#department_pp_add_hdpname").val($("input[name=d_pp_add_radio]:checked").attr("data-name"));
                if ($("#ServicePeople").is(":checked")) {
                    $("#isServicePeople").val("1");
                } else {
                    $("#isServicePeople").val("0");
                }
            },
            usePlugin: {
                passwordstrength: {
                    minLen: 8,//设置密码长度最小值，默认为0;
                    maxLen: 16//设置密码长度最大值，默认为30;

                }
            },
            ajaxPost: true,
           // postonce: true,
            callback: function (d) {
                console.log(d);
                if (d.status == "y") {
                    $("#d_pp_detail_s_fullname").text($("#d_pp_detail_t_fullname").val());
                    $("#d_pp_detail_s_dlevel").text($("#d_pp_detail_t_dlevel option:selected").text());
                    $("#d_pp_detail_s_email").text($("#d_pp_detail_t_email").val());
                    $("#d_pp_detail_s_mobile").text($("#d_pp_detail_t_mobile").val());
                    $("#d_pp_detail_s_status").text($("#d_pp_detail_t_status option:selected").text());
                    $("#d_pp_detail_s_descript").text($("#d_pp_detail_t_descript").val());
                    TopTrip("修改成功", 1);
                    //$("#editppdiv").slideUp();
                    //window.location.reload();
                }
                else {
                    if (d.info == "-1") {
                        LoginTimeOut();
                    } else if (d.info=="-100") {
                        TopTrip("您无权限修改", 3);
                    }
                }
            }
        });
    })
    function pp_add_DepartList(data) {
        var num = 0;
        var html = "";
        $.each(data.Table, function (idx, item) {
            num++;
            if (item.departid == $("#depart_pp_detail_depid").val()) {
                html += ' <li><input name="d_pp_add_radio" type="radio" id="cv_'+num+'" data-name=' + item.department + '  value=' + item.departid + ' checked=checked><label for="cv_'+num+'"> ' + item.department + '</label></li>';
            }
            else {
                html += ' <li><input name="d_pp_add_radio" type="radio" id="fv_' + num + '" data-name=' + item.department + '  value=' + item.departid + '> <label for="fv_' + num + '"> ' + item.department + '</label></li>';
            }
        });
        $("#department_pp_add_dlist").html(html);
    }
    $(function () {
        //console.log("pppppasswords");
        $("#department_pp_add_password").val("?????????h");
        $("#department_pp_add_password2").val("?????????h");
       // $("#department_pp_add_password").val("<%=password%>");//MD5的结果。。。。不行
       // $("#department_pp_add_password2").val("<%=password%>");
        //$("#department_pp_add_password").click();
        $("#department_pp_add_password").focus();
        $("#department_pp_add_password").blur();
        if ($("#oldMerit").val() < $("#loginMerit").val()) {
            //自己优先级低于  - 要编辑用户的优先级
            $("#department_pp_add_dlist [type='radio']").attr("disabled", true);
            $(".btn").attr("disabled", "disabled");
        }
    })
</script>

<%--<div class="depart_member_info">
    <input type="hidden" id="depart_member_info_type" runat="server" />
    <ul class="clearfix">
        <li><span class="label">账户名：</span><span class="info" id="d_pp_detail_s_username" runat="server"></span></li>
        <li><span class="label">所属部门：</span><span class="info" id="d_pp_detail_s_department" runat="server"></span></li>
        <li><span class="label">姓名：</span><span class="info" id="d_pp_detail_s_fullname" runat="server"></span></li>
        <li><span class="label">管理优先级：</span><span class="info" id="d_pp_detail_s_dlevel" runat="server">1</span></li>
        <li><span class="label">电子邮箱：</span><span class="info" id="d_pp_detail_s_email" runat="server"></span></li>
        <li><span class="label">联系方式：</span><span class="info" id="d_pp_detail_s_mobile" runat="server"></span></li>
        <li><span class="label">其它联系方式：</span><span class="info" id="d_pp_detail_s_tel" runat="server"></span></li>
        <li><span class="label">状态：</span><span class="info" id="d_pp_detail_s_status" runat="server"></span></li>
        <li><span class="label">创建时间：</span><span class="info" id="d_pp_detail_s_crdate" runat="server"></span></li>
        <li style="width: 750px;"><span class="label">描述：</span><span class="info" id="d_pp_detail_s_descript" runat="server"></span></li>
    </ul>
    <div class="depart_m_btn2">
        <input class="btn" value="修改" onclick="showeditppdiv()" type="button">
    </div>
</div>--%>
<form id="department_pp_detail" action="/company/depart/ajax/editManager.ashx" method="post">
    <input type="hidden" id="d_pp_detail_hid_userid" runat="server" />
    <input type="hidden" id="oldMerit" name="oldMerit" runat="server" />
    <input type="hidden" id="loginMerit" name="loginMerit" runat="server" />
    <div class="depart_member_info" id="editppdiv">
        <ul class="clearfix">
            <li><span class="label">账户名：</span><input class="inp_t" id="d_pp_detail_t_username" runat="server" readonly="readonly" value="" type="text"><span><input type="checkbox" id="ServicePeople" name="ServicePeople" value="1" runat="server" />服务人员</span>
                <input type="hidden" id="isServicePeople" name="isServicePeople" value="0" />

            </li>
            <li><span class="label">姓名：</span><input class="inp_t" id="d_pp_detail_t_fullname" runat="server" datatype="*" sucmsg="" errormsg="用户姓名不能为空" value="" type="text"><span class="font_red Validform_checktip"></span></li>
            <li style="width:850px"><span class="label">密码：</span><input class="inp_t" type="password"  datatype="*8-16" errormsg="密码长度8-16之间" id="department_pp_add_password" plugin="passwordStrength" onblur="checkPassword(1)" runat="server" value=""><span class="font_red Validform_checktip"></span> <span id="pass1" class="font_red">*密码必须包含字母、数字、特殊字符</span></li>
            <li><span class="label">密码强度：</span><div class="passwordStrength"><span style="line-height: 18px;">弱</span><span style="line-height: 18px;">中</span><span style="line-height: 18px;" class="last">强</span></div>
            </li>
            <li><span class="label">确认密码：</span><input class="inp_t" type="password" datatype="*8-16" nullmsg="请再输入一次密码！" errormsg="您两次输入的账号密码不一致！"   onblur="checkPassword(2)" id="department_pp_add_password2" name="department_pp_add_password2" runat="server" value=""><span id="pass2" class="font_red" >*密码必须包含字母、数字、特殊字符</span></li>
            <%--密码 ?????????h  errormsg="您两次输入的账号密码不一致！" recheck="department_pp_add_password" datatype="s6-16"--%>
            <li><span class="label">管理优先级：</span><select class="inp_t" id="d_pp_detail_t_dlevel" runat="server">
                
            </select></li>
            <li><span class="label">电子邮箱：</span><input class="inp_t" id="d_pp_detail_t_email" datatype="e" errormsg="邮箱输入不正确" runat="server" value="" type="text"><span class="font_red Validform_checktip"></span></li>
            <li><span class="label">联系方式：</span><input class="inp_t" id="d_pp_detail_t_mobile" datatype="/^[1][3-9][0-9]{9}$/" errormsg="手机输入不正确" runat="server" value="" type="text"><span class="font_red Validform_checktip"></span></li>
            <li><span class="label">其它联系方式：</span><input class="inp_t" id="d_pp_detail_t_tel" runat="server" value="" type="text"></li>
            <li><span class="label">状态：</span><select id="d_pp_detail_t_status" runat="server" class="inp_t"><option value="0">正常状态</option>
                <option value="1">登陆修改密码</option>
                <option value="2">不能修改密码</option>
                <option value="3">禁用状态</option>
            </select></li>
            <li><span class="label">隶属部门：<p class="font_red ">(可以修改部门)</p></span>
                <div class="check_area" style="overflow-y: scroll;height: 200px;width: 500px;
">
                    <ul class="clearfix" id="department_pp_add_dlist" style="margin-left:40px;">
                    </ul>
                    <input type="hidden" id="depart_pp_detail_depid" runat="server" />
                    <input type="hidden" id="department_pp_add_hdpname" runat="server" />
                </div>
                </li>
            <li style="width: 750px;"><span class="label">描述：</span><input class="inp_t" id="d_pp_detail_t_descript" runat="server" style="width: 560px;" value="" type="text"></li>
    </ul>
        <div class="depart_m_btn">
            <span class="bgImage btn1"></span>
            <input class="btn"  title="确认" value="确认" type="submit">
            <span class="bgImage btn2"></span>
            <input class="btn" title="重置" value="重置" type="reset">
        </div>
    </div>
</form>
<%--<div class="depart_authorize" id="div_right_page">
</div>--%>


