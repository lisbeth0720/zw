<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="department_pp_list.aspx.cs" Inherits="HuiFeng.Web.company.depart.department_pp_list" %>

<script type="text/javascript">
    var pageSize = 10;
    $(function () {
        var searchName = $("#txt_key").val();
        getCount(searchName);
        GetPageData(1);
        //$("a[name=depart_pp_list_del_btn]").unbind().bind("click", function () {
        //    var id = $(this).attr("data-mid");
        //    showDeleteCompanyManager(id);
        //});
        $("body").on("click", "a[name=depart_pp_list_del_btn]", function () {
            var id = $(this).attr("data-mid");
            showDeleteCompanyManager(id);
        });
        $("#txt_key").on("keydown", function (e) {

            if (event.keyCode == "13") {//keyCode=13是回车键
               // debugger;

                search();
            }
            //  e = e || window.event;
        });
    });
    function search()
    {
        var searchName = $("#txt_key").val();
        /*if (searchName == "") {
            TopTrip("请输入查询关键词");
        }
        else {
          
            getCount();
            GetPageData(1);
        }*/
        if (searchName == "") {
            $("#txt_key").parent().css("border", "1px solid #f00");//.val("请输入关键词")
            // return false;
        }
        else {
            GetPageData(1);
            getCount();
        }
        //getCount();
        GetPageData(1);
    }
    function getCount() {

        $.ajax({
            type: "post",
            url: '/company/depart/ajax/GetManagerList.ashx',
            async: false,
            dataType: 'text',
            data: {
                type: 0,
                keyword: $("#txt_key").val()
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {

                    if (data > 0) {
                        var searchName = $("#txt_key").val();
                        $("#pager").pagination({//调用 分页插件
                            items: data,
                            itemsOnPage: pageSize,
                            cssStyle: 'compact-theme',
                            prevText: '上一页',
                            nextText: '下一页'
                            //, onPageClick: function (pageNumber, event) {
                            //    $("#pager").pagination('selectPage', pageNumber);
                            //}
                        });
                        //发送ajax请求的 代码一样(GetPageData).....所以就写在了   js插件中。。。。。
                //应该每个用分页的 页面，写 onPageClick: function(pageNumber, event) {.....}。。指定 点击页码时，发请求的代码。。。 

                        //在  jquery.simplePagination.js 分页js插件中，
                        //设置 点击页码时的，处理代码。
                        /*点击页码，发送ajax请求。。。。
                        onPageClick: function(pageNumber, event) {
				            GetPageData(pageNumber);
				        }
                        */
                        $("#pageDiv").show();
                    } else { $("#pageDiv").hide(); }
                }
            }
        });
    }
    function goNumber() {
        $("#pager").pagination('selectPage', $("#goPage").val());//转到第几页
    }
    //获取 某一页的数据。。。
    function GetPageData(page) {

        $.ajax({
            type: "post",
            url: '/company/depart/ajax/GetManagerList.ashx',
            async: false,
            dataType: 'text',
            data: {
                keyword: $("#txt_key").val(),
                pagesize: pageSize,
                page: page,
                type: 1
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);
                    show(json);
                }
            }
        });
    }
    
    /*
    利用on（）事件绑定 ($(ParentEle).on("click",".thisEle",function(){})

    $("body").on("click", ".newBtn", function() {
              alert('这里是动态元素添加的事件');
          });<br>//这里的 ParentEle 是 thisEle 的父辈元素或者祖先元素，ParentEle可以是document，也可以是body等。<br><br><br>
          //注意：如果此时调用的函数是外部定义好的函数，那在调用的时候不要加（），不然会跳过点击事件直接触发函数

    */
    //$("#btn_deletemanager").unbind("click");
    $("body").off("click", "#btn_deletemanager").on("click", "#btn_deletemanager", function () {// #btn_deletemanager  删除按钮 ..
        var itemid = $(this).attr("data-itemid");
        var newId = $(this).attr("data-id");
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/deletemanager.ashx',
            async: false,
            dataType: 'text',
            data: {
                id: itemid
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else if (data == "-2") {
                    TopTrip("您没有权限执行该操作！");
                }
                else if (data == "1") {

                    $(".tab_list tr[data-id=" + itemid + "]").remove();
                    $("#" + newId).animate({ top: -60 }, 200, function () {
                        $('#' + newId).remove();
                    });
                    TopTrip("删除成功！",1);
                    window.location.reload();//删除一次之后，页面加载， 事件会再次注册。。。
                }
                else {//data=0
                    TopTrip("系统出错误了！");
                }
            }
        });
    });
    function show(data) {
        var html = '<tr style="width:100%"><th width="10%">序号</th> <th width="10%">账户名</th><th width="11%">姓名</th><th width="5%">优先级</th><th width="20%">电子邮箱</th><th width="12%">联系电话</th><th width="10%">状态</th> <th width="12%">描述</th> <th width="10%">操作</th></tr>';
        var isEdit = "";
        var loginMerit = $("#loginMerit").val();//登录用户的优先级
        //用户能看到 比自己优先级高的用户，但是不能修改、删除
        $.each(data.Table, function (idx, item) {
            var status = "";
            isEdit = "";
            if (item.status == "0") {
                status = "正常";
            }
            else if (item.status == "1") {
                status = "修改密码";
            }
            else if (item.status == "2") {
                status = "不能修改密码";
            }
            else if (item.status == "3") {
                status = "禁用";
            }
            //debugger;//超级管理员，可以编辑，删除用户！！！！
            if (item.merit > loginMerit || $("#isSuperManage").val()=="True") {
                isEdit = '<a href="javascript:void(0)" onclick="loadDepartContent(5, ' + item.userid + ')" title="编辑"><img src="../../images/icon_edit.png" ></a><a href="javascript:void(0)" name="depart_pp_list_del_btn" data-mid="' + item.userid + '" title="删除"><img src="../../images/icon_delete.png" ></a>';
            } else if (item.userid == $("#loginUserid").val()) {//可以编辑自己的账号
                isEdit = '<a href="javascript:void(0)" onclick="loadDepartContent(5, ' + item.userid + ')" title="编辑"><img src="../../images/icon_edit.png" ></a>';
            }
            
            html += '<tr data-id="' + item.userid + '"><td width="10%">' + item.userid + '</td>';
            html += '<td width="10%"><a href="#">' + item.username + '</a></td>';
            html += '<td width="11%">' + item.fullname + '</td>';
            html += '<td width="5%">' + item.merit + '</td>';
            html += '<td width="20%">' + item.email + '</td>';
            html += '<td width="12%">' + item.mobile + '</td>';
            html += '<td width="10%">' + status + '</td>';
            html += '<td width="12%" style="text-align:center">' + item.descript + '</td>';
            html += '<td width="10%"><a href="javascript:void(0)" onclick="loadDepartContent(5, ' + item.userid + ')" title="查看"><img src="../../images/icon_look.png" ></a>' + isEdit + '</td></tr>';
        });
        $(".tab_list").html(html);
    }
</script>
<div class="depart_authorize">
    <div class="sscon">
        <ul class="clearfix">
            <li class="ss_1">
                <input class="ss_t" type="text" id="txt_key" placeholder="请输入要查询的信息"></li>
            <li>
                <input class="ss_s" value="查询" type="button" onclick="search()"></li>
        </ul>
    </div>
    <input type="hidden" id="loginMerit" name="loginMerit" runat="server" />
    <input type="hidden" id="isSuperManage" name="isSuperManage" runat="server" />
    <input type="hidden" id="loginUserid" name="loginUserid" runat="server" />
    <div class="history">
        <div class="title">操作员列表</div>
        <div class="cont">
            <table class="tab_list" style="width:100%;">
                <tr>
                </tr>
            </table>
        </div>
        <%--$("#pager").pagination('selectPage',4);   $("#pager").pagination('getPagesCount'); --%>
        <div id="pager">
        </div>
        <div id="pageDiv" style="margin-top: -34px;margin-left: 680px;display:none;"><input type="text" name="goPage" id="goPage" style="width: 30px;height: 22px;text-align:center" /><input type="button" name="goPageBtn" id="goPageBtn" value="转到" onclick="goNumber()" style="margin-left:10px;padding:0 15px;height:24px;"/></div>
    </div>
</div>

