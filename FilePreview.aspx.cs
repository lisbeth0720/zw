using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using HuiFeng.Common;

namespace Web.company.column
{
    public partial class FilePreview : System.Web.UI.Page
    {
        public string HTMLStr = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            Init();
        }

        private void Init()
        {
            HuiFeng.BLL.CompanyManagerService cmService = new HuiFeng.BLL.CompanyManagerService();
            HuiFeng.Model.CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                int ItemId = 0;
                int TemplateId = 0;
                string outDescript = string.Empty;
                if (Request["itemid"] != null)
                {
                    if (!int.TryParse(Request["itemid"].ToString(), out ItemId))
                    {
                        Response.Write("给出的素材标记有误！");
                        Response.End();
                    }
                }
                else
                {
                    Response.Write("给出的素材标记有误！");
                    Response.End();
                }
                if (Request["templateid"] != null)
                {
                    if (!int.TryParse(Request["templateid"].ToString(), out TemplateId))
                    {
                        //Response.Write("模版参数错误！");
                        //Response.End();
                    }
                }
                else
                {
                    //Response.Write("模版参数错误！");
                    //Response.End();
                }
                if (Request["desript"] != null)
                {
                    outDescript = Request["desript"].ToString();
                }
                HTMLStr = GetHTML(ItemId, TemplateId, outDescript, mmodel.Companyid,"");
            }
        }

        //预览素材,对于栏目类型的显示栏目类型
        private string GetHTML(int ItemId, int TemplateId, string outDescript, string ComId, string windowsname)
        {//节目项ID,模板ID，外部给出的描述（当记录中没有时，用该描述），产品商号
            string inscript = string.Empty;
            string sql = string.Empty;
            string bkpic = string.Empty;
            string bkclr = "#0000ff";
            string fontclr = "#FFFFFF";
            string fontoption = "24";
            string width = "100%";
            string height = "100%";
            int align = 1;
            string alignstr = "align=\"center\"";
            int circle = 1;
            //string circlestr = "loop=\"-1\"";
            int delay = 15;
            string delaystr = "scrollDelay=\"15\"";
            int scrollunit = 1;
            string scrollunitstr = "scrollAmount=\"1\"";
            string fontname = "宋体";
            int fontsize = 24;
            string fontsizestr = string.Empty;
            string fontbold = string.Empty;
            string fontbold1 = string.Empty;
            string fontitalic = string.Empty;
            string fontitalic1 = string.Empty;
            string itemname = string.Empty;
            string contenttype = string.Empty;
            string path = string.Empty;
            string getfilecontent = string.Empty;
            int itemtype = 0;
            string descript = string.Empty;
            string dispmsg = string.Empty;
            string charsetstr = string.Empty;
            string ttempurl = string.Empty;
            string tt = string.Empty;
            int loc = -1;
            string wndclickstr = "";

            if (windowsname.Length > 0) wndclickstr = "onclick=\"window.parent.parent.changewindowname('" + windowsname + "',0,1);\"";

            charsetstr = "";//外面写了 "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";

            StringBuilder sb = new StringBuilder();
            if (ItemId == 0)
            {//内置素材号，用于空素材，提示用户 添加节目项
                fontsize = 18;
                descript = "@#5请添加素材/栏目";
                path = "/images/add_small.jpg";
                ttempurl = "";
                sb.Clear();
                inscript = "<script type=\"text/javascript\" src=\"/js/jquery-1.7.1.min.js\"></script>\r\n";
                inscript += "<script type=\"text/javascript\" src=\"/js/jquery.media.js\"></script>\r\n";

                //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                sb.Append("<head>\r\n");
                sb.Append(charsetstr + "\r\n");
                sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                sb.Append(inscript);
                sb.Append("</head>\r\n");
                sb.Append("<body bgcolor=\"" + "#cecece" + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" " + wndclickstr + ">\r\n");
                if (descript.Substring(0, 1) == "@")
                {
                    //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                    ttempurl = "top='5'";
                    if (descript.Substring(1, 1) == "#")
                    {
                        loc = int.Parse(descript.Substring(2, 1));
                        if (loc >= 0 && loc <= 9)
                        {
                            ttempurl = "top='" + loc * 10 + "%'";
                            tt = descript.Substring(3, (descript.Length - 3));
                        }
                        else
                        {
                            tt = descript.Substring(2, (descript.Length - 2));
                        }

                    }
                    else
                    {
                        tt = descript.Substring(1, (descript.Length - 1));
                    }
                    sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                }
                sb.Append("<center><p valign='middle'>\r\n");
                if (itemtype == 0)
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=\"" + 64 + "\" height=\"" + 64 + "\" onClick='addsucai();' title='添加素材'>&nbsp;<img border=\"0\" src=\"" + path + "\" width=\"" + 64 + "\" height=\"" + 64 + "\" onClick='addlanmu();' title='添加栏目'></div>\r\n");
                else
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=\"" + 64 + "\" height=\"" + 64 + "\" onClick='addsucai();' title='添加素材'>&nbsp;<img border=\"0\" src=\"" + path + "\" width=\"" + 64 + "\" height=\"" + 64 + "\" onClick='addlanmu();' title='添加栏目'></div>\r\n");
                sb.Append("</center>\r\n");
                sb.Append("</body>\r\n");
                sb.Append("</html>\r\n");
                return sb.ToString();
            }
            if (Request["itemtype"] != null)
            {
                tt=Request["itemtype"].ToString();
                tt = tt.Trim();
                if (tt != "")
                {
                    itemtype = int.Parse(tt) % 100;
                }
            }

            if (outDescript.IndexOf("&lt;") >= 0)
            {
                outDescript.Replace("&lt;", "<").Replace("&gt;", ">");
            }
            if (TemplateId > 0)
            {//显示模板样式
                DataTable dt = new HuiFeng.BLL.TempletService().GetOneModel(ComId, TemplateId);
                if (dt.Rows.Count > 0)
                {
                    bkpic = dt.Rows[0]["bkpic"].ToString().Trim();
                    bkclr = "#"+Convert.ToString(Convert.ToInt32(dt.Rows[0]["bkclr"].ToString().Trim()), 16);
                    fontclr = "#" + Convert.ToString(Convert.ToInt32(dt.Rows[0]["fontclr"].ToString().Trim()), 16);
                    fontoption = dt.Rows[0]["fontoption"].ToString().Trim();
                    loc = fontoption.IndexOf(";");//前2个标点在C/S中为逗号,在preparecgi中改成一致的了
                    if (loc>=0)
                    {
                        try
                        {
                            fontsize = int.Parse(fontoption.Substring(0, loc));
                        }
                        catch
                        {
                            fontsize = 24;
                        }

                        fontoption = fontoption.Substring((loc + 1), (fontoption.Length - loc - 1));
                        loc = fontoption.IndexOf(";");
                        if (loc>=0)
                        {
                            fontname = fontoption.Substring(0, loc);
                        }
                        else
                        {
                            fontname = fontoption;
                        }
                    }
                    else
                    {
                        if (fontoption.Trim().Length > 0)
                        {
                            fontsize = int.Parse(fontoption);
                        }
                    }
                    fontoption = fontoption + ";";
                    if (fontoption.ToLower().IndexOf(";b;") >= 0)
                    {
                        fontbold = "<B>";
                        fontbold1 = "</B>";
                    }
                    if (fontoption.ToLower().IndexOf(";i;") >= 0)
                    {
                        fontbold = "<I>";
                        fontbold1 = "</I>";
                    }
                    width = dt.Rows[0]["width"].ToString();
                    height = dt.Rows[0]["height"].ToString();
                    align = int.Parse(dt.Rows[0]["align"].ToString());
                    if (align == 0)
                    {
                        alignstr = "align='left'";
                    }
                    else if (align == 2)
                    {
                        alignstr = "align='right'";
                    }
                    circle = int.Parse(dt.Rows[0]["circle"].ToString());
                    //if (circle == 0)
                    //{
                    //    circlestr = "loop=\"1\"";
                    //}
                    delay = int.Parse(dt.Rows[0]["delay"].ToString());
                    delaystr = "scrollDelay='" + delay + "'";
                    scrollunit = int.Parse(dt.Rows[0]["circle"].ToString());
                    scrollunitstr = "scrollAmount='" + scrollunit + "'";
                }
            }

            DataTable MI = new HuiFeng.BLL.MenuItemService().GetOneMenuItem(ComId, ItemId, 0);
            if (MI.Rows.Count == 0)
            {
                Response.Write("单位ID：" + ComId + "的栏目/节目单中没有找到节目项：" + ItemId + "！");
                Response.End();
            }
            itemname = MI.Rows[0]["itemname"].ToString();
            itemtype = int.Parse(MI.Rows[0]["itemtype"].ToString());
            if (itemtype == 1)
            {
                contenttype = "14";
            }
            else
            {
                contenttype = MI.Rows[0]["contenttype"].ToString().Trim();
            }
            path = MI.Rows[0]["path"].ToString().Trim();
            descript = MI.Rows[0]["descript"].ToString().Trim();
            if (descript.Trim().Length > 0)
            {
                if (descript.IndexOf("&lt;")>=0)
                {
                    descript.Replace("&lt;", "<").Replace("&gt;", ">");
                }
            }
            else
            {
                descript = outDescript;
                if (descript.Trim().Length == 0)
                {
                    descript = itemname;
                }
            }

            //处理path,去掉其中的命令行参数部分
            //从后面查找 空格-
            loc = path.IndexOf(" -");
            if (loc > -1)
            {
                path = path.Substring(0, loc);
            }
            dispmsg = "素材名：" + itemname + " 描述：" + descript + " 类型：";
            if (contenttype == "12")
            {
                dispmsg = dispmsg + "12-专用应用程序 ";
                tt = path.ToLower();
                if (tt.IndexOf(".swf") > 0)
                {
                    contenttype = "7";
                }
                else if ((tt.IndexOf(".ppt") > 0 || tt.IndexOf(".pps") > 0 || tt.IndexOf(".doc") > 0))
                {
                    contenttype = "8";
                }
                else if (tt.IndexOf(".txt") > 0)
                {
                    contenttype = "1";
                }
                else if ((tt.IndexOf(".htm") > 0 || tt.IndexOf(".asp") > 0 || tt.IndexOf(".php") > 0 || tt.IndexOf(".java") > 0))
                {
                    contenttype = "2";
                }
                else if ((tt.IndexOf(".bmp") > 0 || tt.IndexOf(".jpg") > 0 || tt.IndexOf(".gif") > 0 || tt.IndexOf(".pnp") > 0))
                {
                    contenttype = "3";
                }
                else if ((tt.IndexOf(".asf") > 0 || tt.IndexOf(".wmv") > 0 || tt.IndexOf(".wma") > 0 || tt.IndexOf(".mpg") > 0 || tt.IndexOf(".avi") > 0 || tt.IndexOf(".rm") > 0 || tt.IndexOf(".dat") > 0 || tt.IndexOf(".vob") > 0))
                {
                    contenttype = "10";
                }
            }

            inscript = "<script type=\"text/javascript\" src=\"/js/jquery-1.7.1.min.js\"></script>\r\n";
            inscript += "<script type=\"text/javascript\" src=\"/js/jquery.media.js\"></script>\r\n";

            sb.Clear();
            switch (contenttype)
            {
                case "0":
                    dispmsg += "0-自适应";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<table height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<tr height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<td valign=\"middle\"><p " + alignstr + "><span><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span></p></td>\r\n");
                    sb.Append("</tr>\r\n");
                    sb.Append("</tabel>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "1"://和"14"一样
                    if (itemtype == 1)
                    {
                        dispmsg += "14-栏目";
                    }
                    else
                    {
                        dispmsg += "1-文本";
                    }
                    if (path.Length > 0)
                    {
                        getfilecontent = GetContent(path);
                    }
                    if (getfilecontent.Length > 0)
                    {
                        descript = getfilecontent;
                    }
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<table height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<tr height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<td valign=\"middle\" " + alignstr + "><span><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span></td>\r\n");//去掉了<p></p>
                    sb.Append("</tr>\r\n");
                    sb.Append("</tabel>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "14":
                    if (itemtype == 1)
                    {
                        dispmsg += "14-栏目";
                    }
                    else
                    {
                        dispmsg += "1-文本";
                    }
                    if (path.Length > 0)
                    {
                        getfilecontent = GetContent(path);
                    }
                    if (getfilecontent.Length > 0)
                    {
                        descript = getfilecontent;
                    }
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<table height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<tr height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<td valign=\"middle\" " + alignstr + "><span><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span></td>\r\n");
                    sb.Append("</tr>\r\n");
                    sb.Append("</tabel>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "2":
                    dispmsg += "2-网页";
                    //if (path != "")
                    //{
                    //    Response.Redirect(path);
                    //    Response.End();
                    //}
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    if (descript.Substring(0, 1) == "@")
                    {
                        //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                        ttempurl = "top='5'";
                        if (descript.Substring(1, 1) == "#")
                        {
                            loc = int.Parse(descript.Substring(2, 1));
                            if (loc >= 0 && loc <= 9)
                            {
                                ttempurl = "top='" + loc * 10 + "%'";
                                tt = descript.Substring(3, (descript.Length - 3));
                            }
                            else
                            {
                                tt = descript.Substring(2, (descript.Length - 2));
                            }

                        }
                        else
                        {
                            tt = descript.Substring(1, (descript.Length - 1));
                        }
                        sb.Append("<div id=\"mywebpage\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    }
                    sb.Append("<center>\r\n");
                    path = FileHelper.GetThumbnailFilename(path, 5, 0, 2);
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" onload='autosize(this);'></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "3":
                    dispmsg += "3-图片";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    if (descript.Substring(0, 1) == "@")
                    {
                        //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                        ttempurl = "top='5'";
                        if (descript.Substring(1, 1) == "#")
                        {
                            loc = int.Parse(descript.Substring(2, 1));
                            if (loc >= 0 && loc <= 9)
                            {
                                ttempurl = "top='" + loc * 10 + "%'";
                                tt = descript.Substring(3, (descript.Length - 3));
                            }
                            else
                            {
                                tt = descript.Substring(2, (descript.Length - 2));
                            }

                        }
                        else
                        {
                            tt = descript.Substring(1, (descript.Length - 1));
                        }
                        sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    }
                    sb.Append("<center>\r\n");
                    if (itemtype == 0)
                        sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" onload='autosize(this);'></div>\r\n");
                    else
                        sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=\"" + width + "\" height=\"" + height + "\" onload='autosize(this);'></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "4":
                    dispmsg += "4-通知(静态)";
                    if (path.Length > 0)
                    {
                        getfilecontent = GetContent(path);
                    }
                    if (getfilecontent.Length > 0)
                    {
                        descript = getfilecontent;
                    }
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");

                    /*sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\">\r\n");
                    sb.Append("<table height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<tr height=\"100%\" width=\"100%\">\r\n");
                    sb.Append("<td valign=\"middle\" " + alignstr + "><span><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span></td>\r\n");
                    sb.Append("</tr>\r\n");
                    sb.Append("</tabel>\r\n");*/

                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    sb.Append("<p " + alignstr + "><span><font color=\"" + fontclr + "\" style=\font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span></p>\r\n");
                    sb.Append("</center>\r\n");

                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "5":
                    dispmsg += "5-通知(向上滚动文本)";
                    if (path.Length > 0)
                    {
                        getfilecontent = GetContent(path);
                    }
                    if (getfilecontent.Length > 0)
                    {
                        descript = getfilecontent;
                    }
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    sb.Append("<p>\r\n");
                    sb.Append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"100%\"><tr height=\"100%\" width=\"100%\"><td valign=\"middle\" align=\"center\">\r\n");
                    if (itemtype == 0)
                    {
                        sb.Append("<MARQUEE direction=\"up\" " + scrollunitstr + " " + delaystr + ">\r\n");
                        sb.Append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"100%\"><tr height=\"100%\" width=\"100%\"><td valign=\"middle\" " + alignstr + ">\r\n");
                    }
                    else
                    {
                        sb.Append("<MARQUEE direction=\"up\" " + scrollunitstr + " " + delaystr + " width=\"" + width + "\" height=\"" + height + "\">\r\n");
                        sb.Append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"100%\"><tr height=\"100%\" width=\"100%\"><td valign=\"middle\" " + alignstr + " width=\"" + width + "\" height=\"" + height + "\">\r\n");
                    }
                    sb.Append("<span><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span>\r\n");
                    sb.Append("</td></tr></table>\r\n");
                    sb.Append("</MARQUEE>\r\n");
                    sb.Append("</td></tr></table>\r\n");
                    sb.Append("</p>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "6":
                    dispmsg += "6-字幕(向左滚动文本)";
                    if (path.Length > 0)
                    {
                        getfilecontent = GetContent(path);
                    }
                    if (getfilecontent.Length > 0)
                    {
                        descript = getfilecontent;
                    }
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    sb.Append("<p>\r\n");
                    sb.Append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" height=\"100%\"><tr height=\"99%\" width=\"99%\"><td valign=\"middle\" align=\"center\">\r\n");
                    if (itemtype == 0)
                    {
                        sb.Append("<MARQUEE direction=\"left\" " + scrollunitstr + " " + delaystr + " onload='autosize(this);'>\r\n");
                    }
                    else
                    {
                        sb.Append("<MARQUEE direction=\"left\" " + scrollunitstr + " " + delaystr + " width=\"" + width + "\" height=\"" + height + "\"\r\n");
                    }
                    sb.Append("<span><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + descript + fontbold1 + fontitalic1 + "</font></span>\r\n");
                    sb.Append("</td></tr></table>\r\n");
                    sb.Append("</MARQUEE>\r\n");
                    sb.Append("</td></tr></table>\r\n");
                    sb.Append("</p>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "7":
                    dispmsg += "7-动画";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    if (descript.Substring(0, 1) == "@")
                    {
                        //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                        ttempurl = "top='5'";
                        if (descript.Substring(1, 1) == "#")
                        {
                            loc = int.Parse(descript.Substring(2, 1));
                            if (loc >= 0 && loc <= 9)
                            {
                                ttempurl = "top='" + loc * 10 + "%'";
                                tt = descript.Substring(3, (descript.Length - 3));
                            }
                            else
                            {
                                tt = descript.Substring(2, (descript.Length - 2));
                            }
                        }
                        else
                        {
                            tt = descript.Substring(1, (descript.Length - 1));
                        }
                        sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    }
                    sb.Append("<center>\r\n");
                    //显示缩略图
                    path = FileHelper.GetThumbnailFilename(path, 5, 0, 7);
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" onload='autosize(this);'></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    /*sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    if (descript.Substring(0, 1) == "@")
                    {
                        //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                        ttempurl = "top='5'";
                        if (descript.Substring(1, 1) == "#")
                        {
                            loc = int.Parse(descript.Substring(2, 1));
                            if (loc >= 0 && loc <= 9)
                            {
                                ttempurl = "top='" + loc * 10 + "%'";
                                tt = descript.Substring(3, (descript.Length - 3));
                            }
                            else
                            {
                                tt = descript.Substring(2, (descript.Length - 2));
                            }

                        }
                        else
                        {
                            tt = descript.Substring(1, (descript.Length - 1));
                        }
                        sb.Append("<div id=\"myflash\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    }
                    sb.Append("<center>\r\n");
                    sb.Append("<div valign=\"middle\" " + alignstr + ">\r\n");
                    if (itemtype == 0)
                    {
                        sb.Append("<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0\" width=\"100%\" height=\"100%\">\r\n");
                    }
                    else
                    {
                        sb.Append("<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0\" width=\"" + width + "\" height=\"" + height + "\">\r\n");
                    }
                    sb.Append("<param name=\"movie\" value=\"" + path + "\">\r\n");
                    sb.Append("<param name=\"quality\" value=\"high\">\r\n");
                    sb.Append("<param name=\"wmode\" value=\"transparent\">\r\n");
                    sb.Append("<embed quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\"></embed>\r\n");
                    sb.Append("</object>\r\n");
                    sb.Append("</div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");*/
                    break;
                case "8":
                    dispmsg += "8-Office文稿";
                    /*if (path.Trim().Length > 0)
                    {
                        Response.Redirect(path);
                        Response.End();
                    }*/
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    if (descript.Substring(0, 1) == "@")
                    {
                        //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                        ttempurl = "top='5'";
                        if (descript.Substring(1, 1) == "#")
                        {
                            loc = int.Parse(descript.Substring(2, 1));
                            if (loc >= 0 && loc <= 9)
                            {
                                ttempurl = "top='" + loc * 10 + "%'";
                                tt = descript.Substring(3, (descript.Length - 3));
                            }
                            else
                            {
                                tt = descript.Substring(2, (descript.Length - 2));
                            }

                        }
                        else
                        {
                            tt = descript.Substring(1, (descript.Length - 1));
                        }
                        sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    }
                    sb.Append("<center>\r\n");
                    //显示缩略图
                    path = FileHelper.GetThumbnailFilename(path, 5, 0, 8);
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" onload='autosize(this);'></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "9":
                    dispmsg += "9-音频";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    /*if (itemtype == 0)
                    {
                        sb.Append("<p valign=\"middle\" " + alignstr + "><img border=\"0\" dynsrc=\"" + path + "\" start=\"fileopen\" " + circlestr + "></p>\r\n");
                    }
                    else
                    {
                        sb.Append("<p valign=\"middle\" " + alignstr + "><img border=\"0\" dynsrc=\"" + path + "\" width=\"" + width + "\" height=\"" + height + "\" start=\"fileopen\" " + circlestr + "></p>\r\n");
                    }*/
                    //显示缩略图
                    path = FileHelper.GetThumbnailFilename(path, 5, 0, 9);
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" onload='autosize(this);'></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "10":
                    dispmsg += "10-视频文件/网络视频/电视";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" leftMargin=\"0\" topMargin=\"0\" rightMargin=\"0\" bottomMargin=\"0\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    if (descript.Substring(0, 1) == "@")
                    {
                        //后面的一个字节数字给出开始位置在整个高度的十分之几0表示最顶,1表示十分之一高度
                        ttempurl = "top='5'";
                        if (descript.Substring(1, 1) == "#")
                        {
                            loc = int.Parse(descript.Substring(2, 1));
                            if (loc >= 0 && loc <= 9)
                            {
                                ttempurl = "top='" + loc * 10 + "%'";
                                tt = descript.Substring(3, (descript.Length - 3));
                            }
                            else
                            {
                                tt = descript.Substring(2, (descript.Length - 2));
                            }

                        }
                        else
                        {
                            tt = descript.Substring(1, (descript.Length - 1));
                        }
                        sb.Append("<div id=\"myvideo\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    }
                    sb.Append("<center>\r\n");
                    /*string okurl = path;
                    bool dealit = false;
                    sb.Append("<script>\r\n");
                    sb.Append("$(function(){\r\n");
                    sb.Append("$.fn.media.mapFormat(\"flv\",\"winmedia\");\r\n");
                    sb.Append("$.fn.media.mapFormat(\"mp3\",\"winmedia\");\r\n");
                    sb.Append("$.fn.media.mapFormat(\"mp4\",\"winmedia\");\r\n");
                    sb.Append("$(\".media\").media({\r\n");
                    sb.Append("autoplay:1,\r\n");
                    sb.Append("width:$(window).width(),\r\n");
                    sb.Append("height:$(window).height(),\r\n");
                    sb.Append("params:{uiMode:\"none\",\r\n");
                    sb.Append("EnableContextMenu:1,\r\n");
                    sb.Append("enabled:1,\r\n");
                    sb.Append("windowlessVideo:18,\r\n");
                    sb.Append("volume:100,\r\n");
                    sb.Append("PlayCount:9999,\r\n");
                    sb.Append("Loop:1,\r\n");
                    sb.Append("CONTROLS:\"ImageWindow\"\r\n");
                    sb.Append("},\r\n");
                    sb.Append("attrs:{id:\"myplayer\"}\r\n");
                    sb.Append("});\r\n");
                    sb.Append("$(\"#divplayer\").click(function(){\r\n");
                    sb.Append("var videotype=\"" + GetFileSubfix(okurl) + "\";\r\n");
                    sb.Append("if($.fn.media.getPlayerType(videotype)==\"winmedia\"){,\r\n");
                    sb.Append("if(myplayer.uiMode==\"full\"){\r\n");
                    sb.Append("myplayer.uiMode=\"none\";	\r\n");
                    sb.Append("$(this).text(\"显示控制条\");\r\n");
                    sb.Append("}else{\r\n");
                    sb.Append("$(this).text(\"隐藏控制条\");\r\n");
                    sb.Append("myplayer.uiMode=\"full\";\r\n");
                    sb.Append("}\r\n");
                    sb.Append("}else if($.fn.media.getPlayerType(videotype)==\"real\"){ \r\n");
                    sb.Append("if(myplayer.CONTROLS==\"ImageWindow\"){\r\n");
                    sb.Append("myplayer.CONTROLS=\"ImageWindow,ControlPanel\";\r\n");
                    sb.Append("$(this).text(\"隐藏控制条\");\r\n");
                    sb.Append("}else{\r\n");
                    sb.Append("myplayer.CONTROLS=\"ImageWindow\";\r\n");
                    sb.Append("$(this).text(\"显示控制条\");\r\n");
                    sb.Append("}\r\n");
                    sb.Append("}else if($.fn.media.getPlayerType(videotype)==\"quicktime\"){ \r\n");
                    sb.Append("}\r\n");
                    sb.Append("});\r\n");
                    sb.Append("});\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("<div id=\"divplayer\" style=\"position:absolute;top:0;left:0;color:#FFF;font-size:12px;margin:10px;cursor:pointer;\">显示控制条</div>\r\n");
                    sb.Append("<a class=\"media\" href=\"" + okurl + "\" ></a> \r\n");
                    //dealit = true;
                    if (!dealit)
                    {
                        if (itemtype == 0)
                        {
                            sb.Append("<p valign=\"middle\" " + alignstr + "><img border=\"0\" dynsrc=\"" + path + "\" start=\"fileopen\" " + circlestr + "></p>\r\n");
                        }
                        else
                        {
                            sb.Append("<p valign=\"middle\" " + alignstr + "><img border=\"0\" dynsrc=\"" + path + "\" width=\"" + width + "\" height=\"" + height + "\" start=\"fileopen\" " + circlestr + "></p>\r\n");
                        }
                    }*/
                    //显示缩略图
                    path = FileHelper.GetThumbnailFilename(path, 5, 0, 10);
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" onload='autosize(this);'></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "11":
                    dispmsg += "11-操作系统自检测";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    //sb.Append("<p>不支持该类型素材的预览：" + path + "</p>\r\n");
                    ttempurl = "top='88%'";
                    tt = "11-操作系统自检测";
                    sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    path = "/images/img_new/default_11_2.png";
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=64 height=64></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "12":
                    dispmsg += "12-专用应用程序";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    //sb.Append("<p>不支持该类型素材的预览：" + path + "</p>\r\n");
                    ttempurl = "top='88%'";
                    tt = "12-专用应用程序";
                    sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    path = "/images/img_new/default_12_2.png";
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=64 height=64></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                case "13":
                    dispmsg += "13-远程指令";
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    //sb.Append("<p>不支持该类型素材的预览</p>\r\n");
                    ttempurl = "top='88%'";
                    tt = "13-远程指令";
                    sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    path = "/images/img_new/default_13_2.png";
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=64 height=64></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
                default:
                    //sb.Append("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
                    sb.Append("<head>\r\n");
                    sb.Append(charsetstr + "\r\n");
                    sb.Append("<title>Digital Multi-Media Distributing System</title>\r\n");
                    sb.Append(inscript);
                    sb.Append("<script language=\"javascript\">\r\n");
                    sb.Append("function displayinfo(dispstr)\r\n");
                    sb.Append("{\r\n");
                    sb.Append("   alert(dispstr);\r\n");
                    sb.Append("}\r\n");
                    sb.Append("</script>\r\n");
                    sb.Append("</head>\r\n");
                    sb.Append("<body background=\"" + bkpic + "\" bgcolor=\"" + bkclr + "\" ondblclick=\"displayinfo('" + dispmsg + "');\" " + wndclickstr + ">\r\n");
                    sb.Append("<center>\r\n");
                    dispmsg = dispmsg + contenttype;
                    //sb.Append("<p>" + dispmsg + "-未知类型</p>\r\n");
                    ttempurl = "top='88%'";
                    tt = dispmsg + "_未知类型";
                    sb.Append("<div id=\"mypic\" " + alignstr + " style=\"position:absolute;" + ttempurl + ";width='100%';height='100%';\"><font color=\"" + fontclr + "\" style=\"font-size:" + fontsize + "pt\" face=\"" + fontname + "\" style=\"line-height: 130%\">" + fontbold + fontitalic + tt + fontbold1 + fontitalic1 + "</font></div>\r\n");
                    path = "/images/img_new/default_0_2.png";
                    sb.Append("<div " + alignstr + "><img border=\"0\" src=\"" + path + "\" width=64 height=64></div>\r\n");
                    sb.Append("</center>\r\n");
                    sb.Append("</body>\r\n");
                    sb.Append("</html>\r\n");
                    break;
            }
            return sb.ToString();
        }

        //获取字符串类型任务文件内容
        private string GetContent(string filename)
        {
            string fullname = string.Empty;
            StringBuilder sb = new StringBuilder();

            if (filename.Substring(0, 1).Equals("\\") || filename.Substring(0, 1).Equals("/"))
            {
                fullname = Server.MapPath(filename);
            }
            else
            {
                fullname = Server.MapPath("/" + filename);
            }
            try
            {
                StreamReader sr = new StreamReader(fullname, Encoding.Default);
                String line;
                while ((line = sr.ReadLine()) != null)
                {
                    sb.Append(line.ToString());
                }
                sr.Close();
            }
            catch
            {
                sb.Append("定位错误-"+fullname);
            }
            
            return sb.ToString();
        }

        private string GetFileSubfix(string fileName)
        {//获取后缀
            int loc = fileName.IndexOf(".");
            if (loc >= 0)
                return fileName.Substring((loc + 1), fileName.Length-loc-1);
            else
                return "";
        }
    }
}