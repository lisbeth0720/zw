<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="department_list.aspx.cs" Inherits="HuiFeng.Web.company.department_list" %>

<script type="text/javascript">
   
    $(function () {
        getData("");
        $("#txt_dlist_key").focus(function () {
            $(this).val("");
            $(this).parent().css("border-color", "#959595")
        });
        $("#txt_dlist_key").on("keydown", function (e) {
           
            if (event.keyCode == "13") {//keyCode=13是回车键
               // debugger;
                
                dlsearch();
            }
          //  e = e || window.event;
        });
    })
       
    function getData(serachName) {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getMyDepartList.ashx',
            async: false,
            dataType: 'text',
            data: {
                keyword: serachName
            },
            success: function (data) {
                if (data == "-1") {
                    LoginTimeOut();
                }
                else {
                    var json = strToJson(data);
                    showdldata(json);
                }
            }
        });
    }

    function showdldata(data) {
        var html = '<tr><th style="width:10%;" width="50">序号</th><th width="75" style="width:10%;">部门名称</th><th width="70" style="width:10%;">部门级别</th><th width="80" style="width:10%;">上级部门</th><th width="70" style="width:10%;">部门属性</th><th width="300" style="width:30%;">部门描述</th><th width="105" style="width:20%;">操作</th></tr>';
        $.each(data.Table, function (idx, item) {
            //html += '<tr><td style="width:5%;"><input type="checkbox" value="' + item.departid + '">' + item.departid + '</td>';
            html += '<tr><td style="width:5%;">' + item.departid + '</td>';//去掉复选框
            html += '<td style="width:15%;"><a href="#" class="bumeng">' + item.department + '</a></td>';
            html += '<td style="width:10%;">' + item.dlevel + '</td>';
            html += '<td style="width:10%;">' + item.belongto + '</td>';
            html += '<td style="width:15%;"><p style="width:50px; margin:0 auto; height:15px; background:' + item.attribute + '"></p></td>';
            html += '<td style="text-align:left;width:30%;"><div class="miaoshu">' + item.descript + '</div></td>';
            html += '<td style="width:15%;padding-top:13px;"><a href="javascript:void(0)" onclick="loadDepartContent(4,' + item.departid + ')" title="查看"><img src="../../images/icon_look.png"></a><a href="javascript:void(0)" onclick="loadDepartContent(1,' + item.departid + ')" title="编辑" ><img src="../../images/icon_edit.png" ></a><a href="javascript:void(0)" name="departlist_del_btn" data-did=' + item.departid + ' title="删除"><img src="../../images/icon_delete.png"></a></td></tr>';
        });
        //style="display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width:300px;text-align:center;"
        $("#dl_list").html(html);
    }

    function dlsearch() {
        
        if ($("#txt_dlist_key").val() == "") {
            $("#txt_dlist_key").parent().css("border", "1px solid #f00");//.val("请输入关键词")
           // return false;
        }
        else {
            getData($("#txt_dlist_key").val());
        }
       // getData($("#txt_dlist_key").val());
    }
    //$("a[name=departlist_del_btn]").on("click", function () {
    $("a[name=departlist_del_btn]").unbind("click");
    $("body").on("click", "a[name=departlist_del_btn]", function () {
        var $obj=$(this);
        var departid=$obj.attr("data-did");
        if (confirm("真的要删除吗")) {
            $.ajax({
                url: '/company/depart/ajax/deletedepart.ashx',
                type: 'post',
                dataType: 'text',
                data: {"departid":departid},
                success: function (data) {
                    if (data==-1) {
                        LoginTimeOut();
                    }
                    else if (data == -2)
                    {
                        alert("该部门下有未删除的部门！");
                        return false;
                    }
                    else if (data == -3) {
                        alert("该部门下有未删除的操作员！");
                        return false;
                    }
                    else {
                        $obj.parent().parent().remove();
                        // window.location.reload();
                        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                        var nodes = treeObj.getNodesByParam("id", departid, null);
                        treeObj.removeNode(nodes[0]);//刷新树形部门列表
                    }
                }
            });
         
        }
    });
</script>
<!--<form id="form2" runat="server">-->
    <div class="depart_authorize">
        <div class="sscon">
            <ul class="clearfix">
                <li class="ss_1">
                    <input class="ss_t" type="text" id="txt_dlist_key"  placeholder="请输入部门名称"></li>
                <li>
                    <input class="ss_s" value="查询" type="button" title="查询" onclick="dlsearch()"></li>
            </ul>
        </div>
        <div class="history">
            <div class="title">部门列表</div>
            <div class="cont" style="overflow-y: scroll;height: 500px;
">
                <table class="tab_list" id="dl_list" style="width:100%;">
                </table>
            </div>
        </div>
        <div id="pager">
        </div>
    </div>
<!--</form>-->

