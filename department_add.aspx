<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="department_add.aspx.cs" Inherits="HuiFeng.Web.company.department_add" %>

<style>
    #depart_add_departlist li {
        width: 135px;
        float: left;
        font-size: 12px;
        display: block;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

</style>
<script type="text/javascript">
    var isExsit = true;
    function getMask(url, width, height, title) {
        $("#mask").show();
        $(".ddload").load(url);
        $(".tanchuang").css("width", width + "%");
        $(".tanchuang").css("height", (height + 40) + "px");
        $(".ddload").css("height", height);
        $(".ddbody span").html(title);
    }
    function closeMask() {
        $(".ddload").html("");
        $("#mask").hide();

    }
    $(function () {
        $("#chooseMan").click(function () {
            getMask("/company/depart/ChooseMan.aspx", 60, 560, "选择部门负责人");
        })
        if ($("#dp_add_hid_departid").val() != 0) {
            //$("#txt_dpadd_name").attr("readonly", "readonly");//不能编辑： 部门名称
           // $("#depart_add_btndiv .addbtn").removeClass("addbtn").addClass("savebtn").val("更新");
        }
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
                    Depart_Add_DepartList(json);
                }
            }
        });
        //搜索框
        
        $("#txt_dpadd_name").blur(function () {
            $(".mod_error").remove();
            if ($(this).val() == "") {
                showError("txt_dpadd_name", "部门名称不能为空", 0);
            }
            else {
                //验证是否重复
                if ($("#dp_add_hid_departid").val() == 0) {
                    $.ajax({
                        type: 'post',
                        url: '/company/depart/ajax/DepartExsit.ashx',
                        async: true,
                        data: {
                            dname: $(this).val()
                        },
                        dataType: 'text',
                        success: function (data) {
                            if (data == "1") {
                                showError("txt_dpadd_name", "部门名称已存在", 0);
                            }
                            else if (data == "0") {
                                isExsit = false;
                                $(".mod_error").remove();
                            }
                            else if (data == "-1") {
                                window.location.href = "../login.html";
                            }
                        }
                    });
                }
            }
        });
       
        $("#txt_dpadd_att").colorpicker({
            fillcolor: true,
            success: function (o, color) {
                $(o).css("color", color);
            }
        });
        //编辑时绑定radio
    
        if ($("#depart_add_belongto").val() != "") {

            var val = $("#depart_add_belongto").val();
            $("input[name=dp_add_radio]").each(function () {
                if ($(this).val() == val) {
                    $(this).attr("checked", true);
                }
            });
        }
    })
    function Depart_Add_DepartList(data) {
        var html = "";
        $.each(data.Table, function (idx, item) {
            if (item.departid != $("#dp_add_hid_departid").val()) {
                html += ' <li><label><input name="dp_add_radio" type="radio" value=' + item.departid + ' data-dlevel=' + item.dlevel + ' /> ' + item.department + '</label></li>';
            }
        });
        $("#depart_add_departlist").html(html);
    }
    function resetvalue() {
        $("input[type=text]").val("");
        $("#txt_dpadd_des").val("");
    }
    function chDpAddMessage(isadd) {
        if ($("#dp_add_hid_departid").val() == 0) {
            if (isExsit) {
                showError("txt_dpadd_name", "部门名称已存在", 0);
                return false;
            }
        }
        if ($("#txt_dpadd_att").val() == "") {
            showError("txt_dpadd_att", "请选择部门颜色", 0);
            return false;
        }
        if ($("#txt_dpadd_des").val() == "") {
            showError("txt_dpadd_des", "请添加部门描述", 0);
            return false;
        }
        else {
            var belongto = 0;
            var dlevel = 0;
            var val = $("input[name=dp_add_radio]:checked").val();
            if (val != null) {
                belongto = val;
                dlevel = parseInt($("input[name=dp_add_radio]:checked").attr("data-dlevel")) + 1;
            }

            $.ajax({
                type: "post",
                url: '/company/depart/ajax/adddepart.ashx',
                async: false,
                dataType: 'text',
                data: {
                    name: $("#txt_dpadd_name").val(),
                    att: $("#txt_dpadd_att").val(),
                    des: $("#txt_dpadd_des").val(),
                    belongto: belongto,
                    dlevel: dlevel,
                    leaderID: $("#leaderID").val(),//负责人ID
                    departid: $("#dp_add_hid_departid").val()
                },
                success: function (data) {
                    if (data > 0) {
                        if ($("#dp_add_hid_departid").val() == "0") {
                            TopTrip("部门添加完成", 1);
                        } else {
                            TopTrip("部门修改完成", 1);
                        }
                        //修改部门名称，刷新‘树形 部门列表’，修改‘相应节点’即可。。。。。
                       // $(".curSelectedNode span:eq(1)").html($("#txt_dpadd_name").val());
                        $("#divdepartlist").html("");
                        //loadDepartContent(0);
                        if (isadd='') {
                            if ($(".index").length > 0) {//会议预约，使用
                                $(".index").load("/common/depart_main.aspx?t=0");
                            } else {
                                window.location.reload();
                            }
                        } else {
                            $("#mm2").load("/company/depart/common/depart_left.html");
                        }
                    }
                    else if (data == "-1") {
                        LoginTimeOut();
                    }
                    else {
                        TopTrip("系统错误，请联系管理员", 3);
                    }
                }
            });
        }
    }
</script>
<div class="depart_add_box">
    <input type="hidden" id="dp_add_hid_departid" value="0" runat="server" />
    <ul class="clearfix">
        <li><span class="label">部门名称：</span><input type="text" class="inp_t" id="txt_dpadd_name" runat="server" /></li>
        <li><span class="label">部门代表色：</span><input type="text" class="inp_t" id="txt_dpadd_att" runat="server" /></li>
        <li><span class="label">部门描述：</span><textarea class="txtarea" id="txt_dpadd_des" runat="server"></textarea></li>
        <li><span class="label">所属部门：</span><div class="check_area" style="overflow-y: scroll;height: 200px;width: 500px;
">
            <ul class="clearfix" id="depart_add_departlist">
            </ul>
            <input type="hidden" id="depart_add_belongto" runat="server" />
        </div>
        </li><%--部门不能嵌套部门--%>
        <li><span class="label">部门负责人：</span>
            <textarea id="depart_leader" style="margin: 0px; height: 105px; width: 300px;" runat="server">
            </textarea>
            <input type="button" id="chooseMan" name="chooseMan" value="选择部门负责人" />
            <input type="hidden" name="leaderID" id="leaderID" value="" runat="server"/>
        </li>
    </ul>

    <div id="depart_add_btndiv" style="text-align: center">
        <span class="inp_btn addbtn colume_positioned" title="保 存">
            <b style="padding-left: 1px; "></b>
            <input class="btn" type="button" style="padding-left:20px;" value="保 存" onclick="chDpAddMessage('')" />

        </span>
        <span class="inp_btn addbtn colume_positioned" title="保存后继续添加" style="width:120px">
            <b style="padding-left:1px;"></b>
            <input class="btn" type="button" style="padding-left:30px;" value="保存后继续添加" onclick="chDpAddMessage('add')" />

        </span>
        <span class="inp_btn resetbtn colume_positioned" title="重 置">
            <b style="left:20px;"></b>
            <input type="button" class="btn colume_save" style="padding-left:20px;" value="重 置" onclick="resetvalue()" /></span>
    </div>
</div>


