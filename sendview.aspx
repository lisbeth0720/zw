<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sendview.aspx.cs" Inherits="Web.company.client.sendview" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>慧峰科技-数字媒体信息发布服务平台-分发过程查看</title>
    <link href="/css/style.css" rel="stylesheet" />
    <link href="/css/zTreeStyle.css" rel="stylesheet" />
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/jquery.ztree.core-3.5.js"></script>
    <script src="/js/jquery.ztree.exedit-3.5.js"></script>
    <script src="/js/jquery.cookie.js"></script>
    <script src="/js/jquery.SuperSlide.2.1.js"></script>
    <script src="/js/tab.js"></script>
    <script src="/js/common.js"></script>
    <script type="text/javascript">
        var zNodes;
        var zTree;
        var zTreeDlevel;
        var setting = {
            async: {
                enable: true, //表示异步加载生效
                url: 'ajax/senviewtreedata.ashx', // 异步加载时访问的页面
                autoParam: ['name', 'parentName'], // 异步加载时自动提交的父节点属性的参数
                otherParam: [], //ajax请求时提交的参数
                type: 'post',
                dataType: 'json'
            },
            edit: {
                enable: true,
                showRenameBtn:false,
                showRemoveBtn: true,
                removeTitle : "remove"
            },
            checkable: true,
            showIcon: true,
            showLine: true, // zTree显示连接线
            data: {  //用pId来标识父子节点的关系
                simpleData: {
                    enable: true
                }
            },
            expandSpeed: "", // 设置 zTree 节点展开、折叠的动画速度，默认为"fast"，""表示无动画
            callback: { // 回调函数
                onClick: LoadTree_Right, // 单击鼠标事件
                asyncSuccess: zTreeOnAsyncSuccess, //异步加载成功事件
                beforeRemove: function (treeId, treeNode) {
                    var zTree = $.fn.zTree.getZTreeObj("ul_dirtree");
                    //zTree.selectNode(treeNode);
                    if (confirm("确定要删除 '" + treeNode.name + "' 吗?")) {
                        $.post("ajax/deletedir.ashx", { path: treeNode.parentName }, function (data) {
                            if (data == "1") {
                                return true;
                            }
                            else {
                                return false;
                            }
                        })
                    }
                    else {
                        return false;
                    }
                }
            }
        };
        $(function () {
            Inint();
            $.fn.zTree.init($("#ul_dirtree"), setting, zNodes);
        })

        function Inint() {
            $.ajax({
                url: 'ajax/senviewtreedata.ashx',
                type: 'post',
                dataType: 'json',
                async: false,
                data: { 'ajaxMethod': 'FirstAnsyData' },
                success: function (data) {
                    if (data == "-1") {
                        LoginTimeOut();
                    }
                    else if (data == "") {
                        $("#ul_dirtree").html("<li>待分发节目单目录列表为空</li>");
                        return;
                    }
                    else {
                        zNodes = data;
                    }
                    
                }
            });
        };
   
        function zTreeOnClick(event, treeId, treeNode, clickFlag) {
            var treeValue = treeNode.name;
        };
        function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
            var treeValue = treeNode.name;
        }
        function LoadTree_Right(event, treeId, treeNode, clickFlag) {
            $("#loadServer_name").val(treeNode.name);
            $("#loadServer_pname").val(treeNode.parentName);
            loadFileList(treeNode.name, treeNode.parentName);
        }
        function loadFileList(name, pname) {
            $.ajax({
                url: 'ajax/getFileList.ashx',
                type: 'post',
                dataType: 'json',
                async: false,
                data: { "name": name, "pname": pname },
                success: function (json) {
                    var html = '<tr><th style="width:200px">文件名</th><th style="width:150px">创建时间</th></tr>';
                    $.each(json, function (idx, item) {
                        html += '<tr><td><div style="width:200px">' + item.name + '</div></td><td><div style="width:150px">' + item.createTime + '</div></td></tr>';
                    })
                    $("#fileList").html(html);
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <!-- #include file="/common/top.html" -->
        <div id="container" class="clearfix">
            <div class="pos_area clearfix">
                <div class="pos">
                    <a href="/company/client/client_main.aspx">终端管理</a>&gt;<a href="javascript:void(0)" class="current">分发过程查看</a>
                </div>
            </div>
            <div style="overflow: hidden">
                <div class="server_left">
                    <ul id="ul_dirtree" class="ztree">
                        <li>待分发节目单目录列表为空</li>
                    </ul>
                </div>
                <div class="filelist" style="width: 740px; padding:10px; float: left;">
                    <table id="fileList" width="100%">
                    </table>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
