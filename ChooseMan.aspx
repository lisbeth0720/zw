<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChooseMan.aspx.cs" Inherits="Web.company.depart.ChooseMan" %>

<!DOCTYPE html>

<!DOCTYPE html>
<!-------------------------------------------------------------------------李鑫-------------------------------------------------------------------->
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>选择与会人员</title>
    <style>
        .choose_manlist_body {
            width: 100%;
            height: 100%;
        }

        .div {
            width: 100%;
            height: 100%;
            /*width: 64%;*/
            /*height: 600px;*/
            /*position: absolute;*/
            /*left: 50%;*/
            /*top: 50%;*/
            /*transform: translate(-36%,-50%);*/
            /*background-color: pink;*/
        }

        /*.manlist_top {*/
            /*width: 100%;*/
            /*height: 40px;*/
            /*line-height: 40px;*/
            /*background-color: #2e4050;*/
            /*color: #ffffff;*/
            /*font-size: 16px;*/
            /*padding-left: 20px;*/
            /*box-sizing: border-box;*/
        /*}*/

        .manlist_sousuo {
            height: 45px;
            width: 100%;
            background-color: #fff;
            position: relative;
            border: 1px solid #dddddd;
            box-sizing: border-box;
        }

            .manlist_sousuo .sousuo {
                width: 700px;
                height: 27px;
                position: relative;
                transform: translate(-50%,-50%);
                top: 50%;
                left: 50%;
            }

        .checkbox3 {
            visibility: hidden;
        }

            .checkbox3 + label {
                width: 13px;
                height: 13px;
                border: 1px solid #13b5b1;
                border-radius: 30%;
                background-color: #ffffff;
                position: absolute;
                transform: translate(0%,50%);
                /*top: 4.5px;*/
            }

            .checkbox3:checked + label:after {
                content: "";
                /*color: #231815;*/
                position: absolute;
                left: -1px;
                top: -4px;
                width: 13px;
                height: 6px;
                border: 3px solid #ed5d00;
                border-top-color: transparent;
                border-right-color: transparent;
                transform: rotate(-45deg);
                -ms-transform: rotate(-50deg);
                -moz-transform: rotate(-50deg);
                -webkit-transform: rotate(-50deg);
            }

        .manlist_sousuo .sousuo .cm_sousuo {
            width: 190px;
            height: 27px;
            border: 1px solid #13b5b1;
            box-sizing: border-box;
            position: absolute;
            padding-left: 12px;
            padding-right: 37px;
        }

        .manlist_sousuo .sousuo .cm_select {
            width: 100px;
            height: 27px;
            border: 1px solid #13b5b1;
            box-sizing: border-box;
            margin-right: 20px;
            margin-left: 10px;
            padding-left: 5px;
            box-sizing: border-box;
        }

        .manlist_sousuo .sousuo button {
            width: 45px;
            height: 27px;
            border: none;
            background-color: #13b5b1;
            color: #ffffff;
            position: absolute;
        }

        .manlist_center {
            width: 100%;
            height: 515px;
            background-color: #f0f0f0;
        }

            .manlist_center .manlist_index {
                width: 760px;
                height: 515px;
                margin: 0 auto;
            }

        .manlist_index .manlist_left, .manlist_index .manlist_right {
            width: 370px;
            height: 515px;
        }

        .manlist_index .manlist_left {
            float: left;
        }

        .manlist_index .manlist_right {
            float: right;
        }

        .manlist_index .manlist_liebiao {
            width: 370px;
            height: 50px;
            text-align: center;
            line-height: 50px;
            font-size: 16px;
            color: #000000;
            font-weight: 600;
        }

        .manlist_index .liebiao_left {
            width: 370px;
            height: 450px;
            background-color: #ffffff;
        }

            .manlist_index .liebiao_left table {
                width: 370px;
                height: 450px;
                overflow: auto;
                display: block;
            }

        .liebiao_left table tr {
            height: 33px;
            /*width: 370px;*/
            display: table;
            text-align: center;
            cursor: pointer;
        }
        
        .liebiao_left table tr:hover{
            color: #13b5b1;
        }

        .liebiao_left table td:nth-child(1) {
            width: 80px;
        }

        .liebiao_left table td:nth-child(2) {
            width: 90px;
        }

        .liebiao_left table td:nth-child(3) {
            /*width: 200px;*/
            padding-left: 20px;
            box-sizing: border-box;
        }


    </style>
</head>
<!-----------------------------------------lixin------------------------------------------->
<body>
    <form id="form1" runat="server">
        <div class="choose_manlist_body">
            <div class="div">
                <!--<div class="manlist_top">选择与会人员</div>-->
                <div class="manlist_sousuo">
                    <div class="sousuo">
                        <button type="button" style="position: relative" id="cmcheck">全选</button>
                        <%--<input type="checkbox" class="checkbox3" id="cmcheck" /><label for="cmcheck"></label><span style="margin-left: 20px;">全选</span>--%>
                        <span style="margin-left: 20px;">选择部门 : </span>
                        <select name="" id="bumen" class="cm_select">
                            <option value="" selected="selected">部门</option>
                        </select>
                        <input type="text" class="cm_sousuo" />
                        <button id="cm_search" type="button" style="left: 436px;">搜索</button>
                        <button id="cm_qingkong" type="button" style="left: 496px;">清空</button>
                        <button id="cm_queding" type="button" style="left: 556px;">确定</button>
                        <button id="cm_quxiao" type="button" style="left: 616px;">取消</button>
                    </div>

                </div>
                <div class="manlist_center">
                    <div class="manlist_index">
                        <div class="manlist_left">
                            <div class="manlist_liebiao">人员列表</div>
                            <div class="liebiao_left">
                                <table id="cm_table">

                                    <!--<tr>-->
                                        <!--<td>王文斌</td>-->
                                        <!--<td>研发部</td>-->
                                        <!--<td>13911126541</td>-->
                                    <!--</tr>-->

                                </table>
                            </div>
                        </div>
                        <div class="manlist_right">
                            <div class="manlist_liebiao">已选人员</div>
                            <div class="liebiao_left">
                                <table id="cm_table2">

                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script>
        var departid = '';
        var telorname = '';
        var cm_html = '';
        var hidden = '';
        var cm_email = '';
        var phone = '';
        var user = '';
        var userid = "";
        $(function () {
            getData();
            $.ajax({
                url: "/company/depart/ajax/getdepartlist.ashx?action=getAllDepart",
                dataType: "text",
                success: function (data) {
                    data = eval("(" + data + ")").Table;
                    for (var i = 0; i < data.length; i++) {
                        $("#bumen").append("<option value='" + data[i].departid + "'>" + data[i].department + "</option>")
                    }
                }

            })

            //下拉框
            $("#bumen").change(function () {
                departid = $(this).val();
                getData2();
            })

            //搜索按钮
            $("#cm_search").click(function () {

                telorname = $(".cm_sousuo").val();
                if ($(".cm_sousuo").val().trim() != "" || $("#bumen").val() != "") {

                    getData2();
                }
            })

            //清空按钮
            $("#cm_qingkong").click(function () {

                $(".cm_sousuo").val("");
                $("#bumen").val("");
                departid = '';
                telorname = '';
                $("#cm_table2").html("");
                getData2();

                //            $("#cm_table2 tr").each(function(){
                //                $("#cm_table tr[special= "+$(this).attr('special')+"]").css("display","");
                //                $(this).remove();
                //            })
            })

            //取消按钮
            $("#cm_quxiao").click(function () {
                closeMask();
            })

            //确定按钮
            $("#cm_queding").click(function () {
                $("#cm_table2 tr").each(function () {
                    //debugger;
                    hidden += $(this).attr("special") + ",";
                    cm_email += $(this).attr("email") + ",";
                    user += $(this).attr("user") + ",";
                    phone += $(this).find("td").eq(2).html() + ",";
                    userid += $(this).attr("userid")+","
                })
                var shuliang = parseInt(hidden.split(",").length);
                if ($("#check1").is(":checked")) {
                    shuliang = shuliang - 1;
                }
                $("#chooseman").val(hidden);
                $("#chooseman").attr("email", cm_email);
                $("#chooseman").attr("phone", phone);
                $("#chooseman").attr("user", user);
                $("#canhuinum").val(shuliang);
                $("#leaderID").val(userid);
                $("#depart_leader").val(user.substr(0,user.length-1));
                closeMask();
            })

            //点击全选按钮，遍历左边获取不隐藏的，拼到右边
            $("#cmcheck").click(function () {
                var html3 = $("#cm_table2 tbody").html();
                $("#cm_table tr").each(function () {
                    if ($(this).css("display") == "none") {

                    } else {
                        html3 = "<tr userid=" + $(this).attr("userid") + " user=" + $(this).attr("user") + " special=" + $(this).attr("special") + " onclick='table_right_Click(this)'>" + $(this).html() + "</tr>" + html3;
                        $(this).css("display", "none");
                    }
                })
                $("#cm_table2").html("");
                $("#cm_table2").prepend(html3);

            })

        })

        //右侧注册的点击事件，点击移除掉
        function table_right_Click(a) {
            $("#cm_table tr[special=" + $(a).attr("special") + "]").css("display", "");
            $(a).remove();
        }
        //页面加载获取数据
        function getData() {
            //alert("ok");
            $.ajax({
                //url: "../AjaxApi/Common.ashx",
                url: "/company/depart/ajax/GetManagerList.ashx?getDepartLeader=yes",
                dateType: "text",
                data: {
                   // "Type": "SelUser",
                    //"NoUser": userid,
                    //                "UserName": "",
                    //                "UserTel": "",
                    //                "TelorName":telorname,
                    //                "DeptID": departid
                },
                success: function (data) {
                   // debugger;
                    $("#cm_table").html("");
                    data = eval("(" + data + ")").Table;
                    for (var i = 0; i < data.length; i++) {
                        $("#cm_table").append("<tr userid='" + data[i].userid + "' user='" + data[i].fullname + "' email='" + data[i].email + "'special='" + data[i].username + "'><td>" + data[i].fullname + "</td><td>" + data[i].deptName + "</td><td>" + data[i].tel + "</td></tr>");
                        //如果右侧有数据就在左侧排除掉
                        if ($("#cm_table2 tr").length > 0) {
                            if ($("#cm_table2 tr[special=" + data[i].username + "]").length == 1) {
                                $("#cm_table tr[special=" + data[i].username + "]").css("display", "none");
                            }
                        }
                    }
                    //左侧点击事件添加到右侧
                    $("#cm_table tr").click(function () {
                        cm_html = "<tr userid='" + $(this).attr("userid") + "' user='" + $(this).attr("user") + "'  special='" + $(this).attr("special") + "' onclick='table_right_Click(this)'>" + $(this).html() + "</tr>";
                        
                        $(this).css("display", "none");
                        $("#cm_table2").prepend(cm_html);
                    })

                    //遍历隐藏域数据
                   // var arr = $("#chooseman").val().split(',');
                    var arr = $("#leaderID").val().split(',');
                   // console.log(arr);
                    for (var j = 0; j < arr.length; j++) {//special
                        if ($("#cm_table tr[userid=" + arr[j] + "]").length > 0) {
                            //alert("ko");
                            $("#cm_table tr[userid=" + arr[j] + "]").click();
                        }
                    }


                }

            })

        }

        //获取上边搜索的数据
        function getData2() {
            $.ajax({
                url: "/company/depart/ajax/GetManagerList.ashx?getDepartLeader=yes",
                dateType: "text",
                data: {
                    //"Type": "SelUser",
                    //"NoUser": userid,
                    //                "UserName": "",
                    //                "UserTel": "",
                    "UserName": telorname,
                    "DeptID": departid
                },
                success: function (data) {
                    
                    $("#cm_table").html("");
                    data = eval("(" + data + ")").Table;
                    //alert("ok");
                    for (var i = 0; i < data.length; i++) {
                        $("#cm_table").append("<tr  userid='" + data[i].userid + "' user='" + data[i].fullname + "' email='" + data[i].email + "' special='" + data[i].username + "'><td>" + data[i].fullname + "</td><td>" + data[i].deptName + "</td><td>" + data[i].tel + "</td></tr>");
                        if ($("#cm_table2 tr").length > 0) {
                            if ($("#cm_table2 tr[special=" + data[i].username + "]").length == 1) {
                                $("#cm_table tr[special=" + data[i].username + "]").css("display", "none");
                            }
                        }
                    }

                    $("#cm_table tr").click(function () {
                        cm_html = "<tr  userid='" + $(this).attr("userid") + "' user='" + $(this).attr("user") + "' special='" + $(this).attr("special") + "' onclick='table_right_Click(this)'>" + $(this).html() + "</tr>";
                        $(this).css("display", "none");
                        $("#cm_table2").prepend(cm_html);
                    })


                }

            })

        }
</script>

</body>

</html>
