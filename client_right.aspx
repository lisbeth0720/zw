<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="client_right.aspx.cs" Inherits="Web.company.depart.client_right" %>

<script type="text/javascript">
    var pageSize = 40;
    //var clientPlayStatus = new Array();
    var myPosition = ""; var tes = 0;//whq
    //var myComID = $("#myComId").val();
    var virtualGroupIDs = "";
    var currnode = "";
    var zNodes;//根据已有权限，一次性展开节点，选择节点---所有 不行！！！！用的是ztree的函数。。
    var zTree;
    /*1.全选功能：显示==treeObj.checkAllNodes(true);当展开节点时，再执行treeObj.checkAllNodes(true);。后台提交数据== input--allgroutIDs
        全不选：？？？
    2.页面加载完， 选择、展开已有权限ID；
    显示==遍历 $("#manager_right_hid_seldep").val()，展开、选择节点treeObj.getNodeByParam("id", checkIDs[i])【判断null】;当展开节点时，再执行(遍历、展开、选择节点)【判断null】
    后台提交数据==$("#manager_right_hid_seldep")旧的权限，
    --新选择的ID($("#manager_right_hid_seldep").val()+ID+",")
    --去掉的ID($("#manager_right_hid_seldep").val().replace("ID,",""))
    */
    var zTreeDlevel;
    var expandList = "";
    var setting = {
        async: {
            enable: true, //表示异步加载生效
            url: '/company/client/ajax/getleftdata.ashx', // 异步加载时访问的页面
            autoParam: ["id", "dlevel", "mark", "haveright"], // 异步加载时自动提交的父节点属性的参数
            otherParam: [], //ajax请求时提交的参数
            type: 'post',
            dataType: 'json'
        },
        checkable: true,
        showIcon: true,
        showLine: true, // zTree显示连接线
        data: {  //用pId来标识父子节点的关系
            simpleData: {
                enable: true
            }
        },
        check: {
            enable: true
            ,chkStyle: 'checkbox'
            ,chkboxType: { "Y": "", "N": "" }
        },
        expandSpeed: "", // 设置 zTree 节点展开、折叠的动画速度，默认为"fast"，""表示无动画
        callback: { // 回调函数
            //onClick: LoadClient_Main_Right,
            
            onExpand: onExpand,
            // onCollapse: onCollapse,
            onAsyncSuccess: onAsyncSuccess,
           // onNodeCreated: zTreeOnNodeCreated
        }
        , view: { showIcon: showIconForTree }//whq..8.2
    };
    function onExpand(event, treeId, treeNode, clickFlag) {
        if (treeNode.level < 3) {
            showGroupIcon();//终端组 图标
        }       
    }
    function showIconForTree(treeId, treeNode) {
        if (treeNode.level == 3) {//终端不显示图标
            //console.log("level3333333..."+treeId);
            return false;
        } else {
            return true;
        }
    };
    function zTreeOnNodeCreated(event, treeId, treeNode) {
        //console.log(treeNode.tId + ",vvvvv, " + treeNode.name + ",,,");// + treeNode.chkDisabled
        if ($("#manager_right_hid_seldep").val().indexOf(treeNode.id)>=0) {
            var treeObj = $.fn.zTree.getZTreeObj("client_rightlist");
            treeNode.open = true;//展开节点。。。已有终端组-权限
            treeObj.updateNode(treeNode,false);
        }
    };
    $(function () {
       // var client_right_selAll = new Mxjfn();
        //client_right_selAll.selectAll("input[value='*']", "#client_rightlist>li>input[name='client_right_check']");
        GetCount();
        GetPageData(1);
        if ($("#client_right_type").val() == 1) {
            $(".depart_m_btn").html("").fadeOut();
        }
        
        //Inint1();
        //$.fn.zTree.init($("#client_rightlist"), setting, zNodes);
        
        //var checkNodes=treeObj.getNodesByParam("checked",true,null);
        //treeObj.setting.check.chkboxType = { "Y": "p", "N": "p" };
       // showStatus();//为终端添加节目单，，刷新，终端列表状态。。。
       // showGroupIcon();
       // ShowPageData1();
    })
   
    function GetCount() {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getclientlist.ashx',
            async: false,
            dataType: 'text',
            data: {
                type: 0
            },
            success: function (data) {
                pageSize = data;//表中记录数。。
                //$("#pager").pagination({
                //    items: data,
                //    itemsOnPage: pageSize,
                //    cssStyle: 'light-theme'
                //});
            }
        });
    }
    function GetPageData(indexpage)
    {
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/getclientlist.ashx',
            async: false,
            dataType: 'text',
            data: {
                type: 1,
                indexpage: indexpage,
                pagesize:pageSize
            },
            success: function (data) {
                if (data != -1) {
                    var json = strToJson(data);
                    ShowPageData(json);
                }
                else {
                    LoginTimeOut();
                }
            }
        });
    }
    function ShowPageData1() {
        if ($("#manager_right_hid_seldep").val().indexOf("p_*") >= 0) {
            $("#f_all").parent().append("<span style='color:#f00;'>(*)<span>");
            console.log("hhh*");
        } else if ($("#manager_right_hid_seldep").val().indexOf("*") >= 0) {
            $("#f_all").attr('checked', 'checked');
            console.log("has*");
        }
        var selectedValues = $("#manager_right_hid_seldep").val().split(",");
        var treeObj = $.fn.zTree.getZTreeObj("client_rightlist");
        
        
        for (var i = 0; i < selectedValues.length; i++) {
            
            if (selectedValues[i] != "" && selectedValues[i] != "*") {
                console.log("has id:" + selectedValues[i]);
                if (selectedValues[i].split("_")[0] == "p") {
                    currnode = treeObj.getNodeByParam("id", selectedValues[i].split("_")[1], null);
                    if (currnode == null) { continue;}
                    currnode.name += "&lt;span style='color:#f00;'&gt;(*)&lt;/span&gt;";
                } else {
                    currnode = treeObj.getNodeByParam("id", selectedValues[i], null);
                }
               // debugger;
                currnode.checked = true;
                treeObj.expandNode(currnode, true, false, false);//展开慢，，，，????下次循环开始，还没展开(currnode 就是null)
                treeObj.updateNode(currnode);
            }
        }
        showGroupIcon();
    }
    function Inint1() {
        $.ajax({
            url: '/company/client/ajax/getleftdata.ashx',
            type: 'post',
            dataType: 'json',
            async: false,
            data: { 'ajaxMethod': 'FirstAnsyData' },
            success: function (data) {
                zNodes = data;

            }
        });
    }
    
    //function onCollapse(event, treeId, treeNode, clickFlag) {
    //   // expandList = expandList.replace(treeNode.id + "_", "");
    //   // $.cookie("expandList", expandList);
    //}
    function onAsyncSuccess(event, treeId, treeNode, clickFlag) {
        var treeObj = $.fn.zTree.getZTreeObj("client_rightlist");
        treeObj.expandAll(true);
        var checkIDs = $("#manager_right_hid_seldep").val().split(",");//选择 已有终端组--权限
        for (var i = 0; i < checkIDs.length; i++) {
            var checknode = treeObj.getNodeByParam("id", checkIDs[i]);
            var parent = checknode.getParentNode();

            treeObj.expandNode(parent, true, true);//true,false

            treeObj.checkNode(checknode, true, false);
        }
       /* var treeObj = $.fn.zTree.getZTreeObj("client_rightlist");
        // treeObj.expandAll(true);
        
        treeObj.expandAll(true);
        var yijizu = treeObj.getNodesByParam("level", 0, null);//treeObj.checkAllNodes(true);
        var yi = "";
        for (var j = 0; j < yijizu.length; j++) {//勾选所有checkbox......//选择 所有 终端组--权限
            //yi += "," + yijizu[j].name;

            // treeObj.expandNode(yijizu[j], true, true, false);
            if ($("#Checkbox1").attr("checked") == "checked") {
                treeObj.expandNode(yijizu[j],true,true,false);
            } else {
                treeObj.expandNode(yijizu[j], true, true, false);
            }
        }
        if ($("#manager_right_hid_seldep").val().indexOf("p_*") >= 0) {
            $("#f_all").parent().append("<span style='color:#f00;'>(*)<span>");
            console.log("hhh*");
        } else if ($("#manager_right_hid_seldep").val().indexOf("*") >= 0) {
            $("#f_all").attr('checked', 'checked');
            console.log("has*");
        }
        showGroupIcon();
        var checkIDs = $("#manager_right_hid_seldep").val().split(",");//选择 已有终端组--权限
        for (var i = 0; i < checkIDs.length; i++) {
            var checknode = treeObj.getNodeByParam("id", checkIDs[i], null);
            treeObj.checkNode(checknode, true, false);
        }*/
       // treeObj.expandAll(true);
            //expandNodes(treeNode.children);        
        
       // ShowPageData1();
    }
   
    
    //function expandNodes(nodes) {
    //    var zTree = $.fn.zTree.getZTreeObj("client_rightlist");
    //    for (var i = 0, l = nodes.length; i < l; i++) {
    //        zTree.expandNode(nodes[i], true, false, false);
    //        debugger;
    //        if (nodes[i].children.length>0) {
    //            expandNodes(nodes[i].children);
    //        }
    //    }
    //    //showStatus("expandNodes");
    //}
    function showGroupIcon() {
        ////url(/images/tubiaoa.png) -150px -56px no-repeat
        var myClientGroup = $("#client_rightlist li a.level0").find("span:eq(0)");//终端组
        myClientGroup.css("background", "url(/images/tubiaoa.png)  -150px -56px no-repeat");
        myClientGroup = $("#client_rightlist li a.level1").find("span:eq(0)");
        myClientGroup.css("background", "url(/images/tubiaoa.png)  -150px -56px no-repeat");
        myClientGroup = $("#client_rightlist li a.level2").find("span:eq(0)");
        myClientGroup.css("background", "url(/images/tubiaoa.png)  -150px -56px no-repeat");
        //console.log(virtualGroupIDs+"vvvvvvvvvirtualsssssssss");
       
        //$('#client_rightlist_1 a span:eq(0)').css('background', 'rgba(0, 0, 0, 0) url("/images/tubiaoa.png") no-repeat scroll -152px -80px');
    }
    
    window.onload = function () {
        //showStatus();//终端 图标
      //  showGroupIcon();//终端组 图标
       // ShowPageData1();//勾选授权的终端组。。。。


    }
    function ShowPageData(json)
    {
        $("#client_rightlist").empty();
        var n = 0;
        $.each(json.Table, function (idx, item) {
           // $("#allgroutIDs").val($("#allgroutIDs").val() + "," + item.clientid);
            n++;
            $("#client_rightlist").append("<li><input id=\"g" + n + "\" checkAll='checkAll' type=\"checkbox\" name=\"client_right_check\" value=\"" + item.clientid + "\"><label for=\"g"+n+"\">" + item.clientname + "</label></li>");
        })
        if ($("#manager_right_hid_seldep").val().indexOf("*")>=0) {
            $("input[name=client_right_check]").prop('checked', 'checked');
        }// else {
            var selectedValues = $("#manager_right_hid_seldep").val().split(",");
            for (var i = 0; i < selectedValues.length; i++) {
                if (selectedValues[i] != "") {
                    if (selectedValues[i].split("_")[0] != "p") {
                        $("input[name=client_right_check]:checkbox[value='" + selectedValues[i] + "']").prop('checked', 'checked');
                    }
                    else {//p,,用户所在的部门 的资源授权。。。p_*  ,p_ ,,
                        $("input[name=client_right_check][value='" + selectedValues[i].split("_")[1] + "']").prop('checked', 'checked');
                        $("input[name=client_right_check][value='" + selectedValues[i].split("_")[1] + "']").parent().append("<span style='color:#f00;'>(*)<span>");
                    }
                }
            }
        //}
    }
    function SaveClientRight() {
       
        var drseldepart = "";
        var querystring = "";
        $("ul input[name=client_right_check]:checked").each(function () {
            drseldepart = drseldepart + $(this).val() + ",";
        });
        
        //var treeObj = $.fn.zTree.getZTreeObj("client_rightlist");
        //var checkNodes = treeObj.getNodesByParam("checked", true, null);
        //for (var i = 0; i < checkNodes.length; i++) {
        //    drseldepart = drseldepart + checkNodes[i].id + ",";
        //}
        //if ($("#Checkbox1").attr("checked") == "checked") {
        //    drseldepart = $("#allgroutIDs").val();//全选。。。。保存所有终端组ID
        //}
        if ($("#f_all").is(":checked")) {
            drseldepart += "*,";//所有终端
        }
        $.ajax({
            type: "post",
            url: '/company/depart/ajax/OperateAuth.ashx',
            async: false,
            dataType: 'text',
            data: {
                idtype: $("#right_main_idtype").val(),
                authid: $("#right_main_authid").val(),
                type: 2,
                sellist: drseldepart
            },
            success: function (data) {
                if (data >= 0) {
                    TopTrip("更新成功", 1);
                }
                else {
                    TopTrip("系统错误，请联系管理员", 3);
                }
            }
        });

    }
    //全选
    function checkClientFun() {
        //var treeObj = $.fn.zTree.getZTreeObj("client_rightlist");
        //treeObj.expandAll(true);
        //var yijizu = treeObj.getNodesByParam("level", 0, null);//treeObj.checkAllNodes(true);
        //var yi = "";
        //for (var j = 0; j < yijizu.length; j++) {//勾选所有checkbox......//选择 所有 终端组--权限
        //    //yi += "," + yijizu[j].name;
            
        //   // treeObj.expandNode(yijizu[j], true, true, false);
        //    if ($("#Checkbox1").attr("checked") == "checked") {
        //        treeObj.checkAllNodes(true);
        //    } else {
        //        treeObj.checkAllNodes(false);
        //    }
        //}
        
        if ($("#Checkbox1").is(":checked")) {
            $("#client_rightlist").find("input[checkAll=checkAll]").prop("checked", "checked");
        } else {
            $("#client_rightlist").find("input[checkAll=checkAll]").prop("checked", false);
        }
    }
</script>
<!--权限授权-->
<input type="hidden" id="client_right_type" value="0" runat="server" />
<input type="hidden" id="manager_right_hid_seldep" runat="server" />
<input type="hidden" id="allgroutIDs" />
<div class="limit_access">
    <div class="tit">
        <div class="leftCheckBox">
            <input id="Checkbox1" type="checkbox" value="*" name="clientRightCheck" onclick="checkClientFun()"/>
            <label for="Checkbox1">全选/全不选</label>
        </div>
        <div class="rightCheckBox">
            <span>
                <input id="f_all" type="checkbox" value="*" name="client_right_check" />
                <label for="f_all">所有终端</label>
            </span>
        </div>
    </div>
    <ul class="limitlist clearfix" id="client_rightlist">
    </ul>
   <%-- <div class="zTreeDemoBackground left">
        <ul class="ztree" id="client_rightlist">
        </ul>
    </div>--%>
    <div id="pager"></div>
    <div class="depart_m_btn" title="确认">
        <span class="bgImage"></span>
        <input class="btn" value="确认" title="确认" onclick="SaveClientRight()" type="button">
    </div>
</div>
