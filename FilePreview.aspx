<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FilePreview.aspx.cs" Inherits="Web.company.program.FilePreview" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<style type="text/css">
        html, body {
        margin:0; padding:0; height:100%;}
</style>
<script type="text/javascript">
    var frameName = window.frameElement && window.frameElement.name || '';
    window.onload = function () {
        if(GetQueryString("fullscreen")!="true"){
            window.parent.parent.setDefaultWindow(frameName);
        }
        var cb=<%=cb%>; 
        if(cb==1)
        {
            document.getElementsByTagName("body")[0].style.borderTop="2px solid #f00";
        }
    };
    window.onclick = function () {
        if(GetQueryString("fullscreen")!="true"){
            window.parent.parent.changewindowname(frameName,0,1,<%=TaskID%>);
        }
    };
    //找不到素材图片
    function no_find(contenttype, obj) {
        $(obj).attr('src', "/images/img_new/default_" + contenttype + "_3.png");
    }
    function autosize(obj) {
        var width = $(window).width();
        var height = $(window).height();
        obj.style.width = width;
        obj.style.height = height;
        obj.width = width;
        obj.height = height;
    }
    function addsucai()
    {
        window.parent.parent.ClearSourceListHtml();
        window.parent.parent.close_ck_icon_right();
        window.parent.parent.$("#content_dialog2").dialog("close");
        window.parent.parent.$("#content_dialog").load("/common/sourcelist.aspx", { "t": 3 });
        window.parent.parent.$("#content_dialog").dialog("open");
        setTimeout(function () { //7/31解除绑定
            $(".thumb").removeAttr("onclick");
        }, 500);
   ;
    }
    /**弹出栏目列表窗口**************/
    function addlanmu()
    {
        window.parent.parent.ClearColumnListHtml();
        window.parent.parent.close_ck_icon_right();
        window.parent.parent.$("#content_dialog").dialog("close");
        window.parent.parent.$("#content_dialog2").load("/common/columnlist.aspx", { "t": 4, "r": Math.random(1000) });
        window.parent.parent.$("#content_dialog2").dialog("open");
        setTimeout(function () { //7/31解除绑定
            $(".thumb").removeAttr("onclick");
        }, 500);
    }
    //获取url中的参数
    function GetQueryString(name) {
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if(r!=null)return  unescape(r[2]); return null;
    }
    function JudgeBroswer() { 
        if($.browser.msie) { 
            return "ie"; //IE
        } 
        else if($.browser.safari) 
        { 
            return "safari"; //Safari 
        } 
        else if($.browser.mozilla) 
        { 
            return "firefox";  //Firefox
        } 
        else if($.browser.opera) { 
            return "opera";     //Opera
        } 
    }
    
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%=HTMLStr%>