<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClientScreenPhoto.aspx.cs" Inherits="Web.company.client.ClientScreenPhoto" %>

<%--<%@ OutputCache Location="None" VaryByParam="None"%>--%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%--<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE1" />--%>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!--禁用缓存部分开始-->
    <meta http-equiv="Expires" content="0" />
    <meta http-equiv="Progma" content="no-cache" />
    <meta http-equiv="cache-control" content="no-cache" />
    <!--禁用缓存部分结束-->
    <title></title>
    <script src="/js/jquery-1.9.1.min.js"></script>
</head>
<body style="background:#edf0f0">
    <form id="form1" runat="server">
        <div style="display: block">
            <span id="photoTime">正在后台传递图片数据，请稍候 ... 还剩 8 秒</span><br />
            <%--<img src="/images/loading.gif" alt="正在获取图片" />--%>

        </div>
        <div style="text-align: center;margin-bottom:10px;">
            <input id="reload" type="button" value="刷新显示图片" />
            <input id="getPhoto" type="button" value="重新获取图片" /><span id="enableButton"></span>
        </div>
        <div>
            <img src="/images/loading.gif" alt="screen photo" id="imgShow" onerror="获取失败，请稍后重试" /> <%--onerror="resetImage()"--%>
            <input type="hidden" name="imgAddress" id="imgAddress" value="" runat="server" />

        </div>
        <div id="datas" style="display: none;"></div>
    </form>
    <script type="text/javascript">
        // window.onload = function () {
        //$.post("ClientScreenPhoto.aspx?"+window.location.search, function () {
        function resetImage() {
            var time = new Date();
            var hour = time.getHours();
            var minute = time.getMinutes();//IE , "2017/7月/14日"
            time = time.toLocaleDateString().replace("年", "/").replace("月", "/").replace("日", "/");
            var mdstr = "/" + time.split('/')[1] + time.split('/')[2] + "/";//711
            var astr = $("#imgAddress").val();
            //alert(astr);//\ sharefiles
            if (astr.indexOf(".cgi") > 0) {//图片不存在，或者时间超过 6 分钟， 重新获取图片。。
                //$("#datas").load(astr.replace("localhost:24956", "192.168.1.145"));
                $.post(astr + "&utf8=1", function () {
                    var imgStr = "/sharefiles/";//"/cgi-bin/"
                    imgStr += astr.split("param=")[1];// ||  %7C%7Cwisepeak/image/14/711/1437.jpg
                    imgStr = imgStr.replace("||", "").replace("%7C", "").replace("%7C", "");
                    //if (imgStr.indexOf("?")<=0) {
                    imgStr = imgStr + "?" + Math.random();
                   // }
                    
                    imgStr = imgStr.replace(mdstr, mdstr);//do..
                    imgStr = imgStr.replace("cgi-bin", "sharefiles");
                    setTimeout(function () {
                        $("#imgShow").attr("src", imgStr);
                        $("#imgAddress").val(imgStr);//do..
                        $("#imgShow").attr("src", $("#imgShow").attr("src"));
                    }, 3000);
                    //alert(mdstr);//window.location.reload();
                });

            }
            else {//D:\wisedisplay\cgi-bin......
                //图片已经存在，直接获取图片。。
                var str = astr.indexOf("\sharefiles");//"\cgi-bin"
                str = "\\" + astr.substr(str);// + "?Math.random()"
                str = str.replace("||", "").replace("%7C", "").replace("%7C", "");
                //if (str.indexOf("?") <= 0) {
                str = str + "?" + Math.random();
                //}
                str = str.replace(mdstr, mdstr);//do..
                str = str.replace("cgi-bin", "sharefiles");
                $("#imgShow").attr("src", str);
                $("#imgAddress").val(str);//do..
                $("#imgShow").attr("src", $("#imgShow").attr("src"));
                //alert(",,," + mdstr);
                //window.location.reload();
            }
        }
        resetImage();
        //});

        //}
        //window.location.reload();
        var showPhoto = 7;
        var clickTime = 30;
        function pageTime() {
            showPhoto = parseInt(showPhoto);
            if (showPhoto > 0) {
                if ($("#imgShow").attr("src") == "" || $("#imgShow").attr("src").indexOf(".cgi") > 0) {
                    $("#photoTime").html("正在后台传递图片数据，请稍候 ... 还剩 " + showPhoto + " 秒");
                    showPhoto--;
                } else {
                    $("#photoTime").html("");
                    $("#photoTime").siblings().css("display", "none");
                }
            } else {
                clearInterval(daojishi);
                $("#photoTime").html("");
                $("#photoTime").siblings().css("display", "none");
            }
        }
        $(function () {
           var daojishi= setInterval(pageTime, 1000); //清 定时器！！！

            //‘重新获取图片’ 点击之后禁用按钮，(向cgi请求截图)，倒计时30秒，启用按钮。。
            $("#getPhoto").click(function () {
                $("#getPhoto").attr('disabled', true);
                //astr = $("#imgAddress").val();
                $.post("/cgi-bin/preparefilecgi.cgi" + window.location.search + "&utf8=1", function () {
                    var imgStr = "/sharefiles/";//"/cgi-bin/"
                    imgStr += window.location.search.split("param=")[1];// ||  %7C%7Cwisepeak/image/14/711/1437.jpg
                   // imgStr = imgStr.replace("||", "").replace("%7C", "").replace("%7C", "") + "?Math.random()";//tt=
                    imgStr = imgStr.replace("||", "").replace("%7C", "").replace("%7C", "");
                    //if (imgStr.indexOf("?") <= 0) {
                    imgStr = imgStr + "?" + Math.random();
                    //}
                    setTimeout(function () {//这样才能获取最新的 截屏，  延迟加载图片
                        //imgStr = imgStr.replace(mdstr, mdstr);//do..
                        imgStr = imgStr.replace("cgi-bin", "sharefiles");
                        $("#imgShow").attr("src", imgStr);
                        $("#imgAddress").val(imgStr);//do..
                        $("#imgShow").attr("src", $("#imgShow").attr("src"));
                    }, 3000);
                    //window.location.reload();
                });
                var btnInter = setInterval(function () {
                    clickTime = parseInt(clickTime);
                    if (clickTime > 0) {
                        $("#enableButton").html("下次获取时间 " + clickTime + " 秒");
                        clickTime--;
                    } else {//
                        clickTime = 30;
                        clearInterval(btnInter);
                        $("#enableButton").html("");
                        $("#getPhoto").attr('disabled', false);
                    }
                }, 1000);
            });
            //window.location.reload();
            $("#reload").click(function () {
                //window.location.href = window.location.href;
                window.location.reload();
            });
        });
    </script>
</body>
</html>
