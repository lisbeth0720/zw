<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FilePreview.aspx.cs" Inherits="Web.company.column.FilePreview" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<style type="text/css">
        html, body {
        margin:0; padding:0; height:100%;}
</style>
<script type="text/javascript">
    function autosize(obj) {
        var width = $(window).width();
        var height = $(window).height();
        obj.style.width = width;
        obj.style.height = height;
        obj.width = width;
        obj.height = height;
    }
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%=HTMLStr%>