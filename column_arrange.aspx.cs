using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.column
{
    public partial class column_arrange : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)
                    || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)
                    || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_TaskPush))
                {
                    column_arrange_pagetype.Value = "0";
                    if (!string.IsNullOrEmpty(Request["type"]))
                    {
                        column_arrange_pagetype.Value = Request["type"];
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem))
                    {
                        //编排权限
                        column_arrange_arrright.Value = "1";
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck))
                    {
                        //审核权限
                        column_arrange_chright.Value = "1";
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_TaskPush))
                    {
                        //发布权限
                        column_arrange_pubright.Value = "1";
                    }
                    if (!string.IsNullOrEmpty(Request["id"]))
                    {
                        int menuid = Convert.ToInt32(Request["id"]);
                        CMenuItem cmodel = new CMenuItem();//历史浏览  保存到Cookie
                        cmodel.ItemID = menuid;
                        cmodel.ItemType = 1;
                        cmodel.Status = 1;
                        CookieHelper.SetMenuItemCookie(cmodel, mmodel.Userid.ToString());
                        column_arrange_clid.Value = menuid.ToString();
                        MenuItemService miService = new MenuItemService();
                        string background = string.Empty;
                        Resolution rmodel = new Resolution();
                        rmodel = miService.GetDefaultScale(1);
                        int width = rmodel.Width;
                        int height = rmodel.Height;
                        DataTable columTable = miService.GetOneMenuItem(mmodel.Companyid, menuid, 1);
                        if (columTable.Rows.Count > 0)
                        {
                            if (System.DBNull.Value != columTable.Rows[0]["framesizex"])
                            {
                                width = Convert.ToInt32(columTable.Rows[0]["framesizex"]);
                            }
                            if (System.DBNull.Value != columTable.Rows[0]["framesizey"])
                            {
                                height = Convert.ToInt32(columTable.Rows[0]["framesizey"]);
                            }
                            if (System.DBNull.Value != columTable.Rows[0]["isfiled"])
                            {
                                myColFiled.Value = columTable.Rows[0]["isfiled"].ToString();
                            }

                            if (columTable.Rows[0]["checkstatus"].ToString() != "1")
                            {
                                mycheckstatus1.InnerHtml += "<font color=\"#1ca8dd\">未通过</font>";
                            }
                            else { mycheckstatus1.InnerHtml += "<font color=\"#1ca8dd\">通过</font>"; }
                        }
                        TempletService tService = new TempletService();
                        int templateid = tService.GetDefaultTemp();
                        MenuService mService = new MenuService();
                        DataTable table = new DataTable();
                        table = mService.GetDataByMenuID(mmodel.Companyid, 1, menuid);
                        if (table.Rows.Count > 0)
                        {
                            string html = "";
                            string idlist = "";
                            string myTrigerType = "";
                            string myUncheckHtml = "";
                            for (int i = 0; i < table.Rows.Count; i++)
                            {
                                int itemid = Convert.ToInt32(table.Rows[i]["itemid"]);
                                int duringtime = 0;
                                string duringtimeStr = "00:00:00";
                                if (table.Rows[i]["duringtime"] != DBNull.Value)
                                {
                                    duringtime = Convert.ToInt32(table.Rows[i]["duringtime"]);
                                    duringtimeStr = duringtime / 3600 + ":" + (duringtime % 3600) / 60 + ":" + (duringtime % 3600) % 60;
                                }
                                string thumbnail = table.Rows[i]["thumbnail"].ToString();
                                int taskid = Convert.ToInt32(table.Rows[i]["taskid"]);
                                int position = Convert.ToInt32(table.Rows[i]["postion"]);
                                string itemname = table.Rows[i]["itemname"].ToString();
                                int contenttype = Convert.ToInt32(table.Rows[i]["contenttype"]);
                                int pictype = 3;
                                /*/privatefiles/wisepeak/thumbnail/pic/f50_636373796092180570.gif3.jpg  --ok
                                 *                                               数据库---DB==.gif5.jpg
                                  /privatefiles/wisepeak/thumbnail/pic/f50_636373796092180570.gif5.jpg3.jpg --拼接之后 */
                                if (!string.IsNullOrEmpty(thumbnail)&&!thumbnail.Contains("default_"))
                                {
                                    int num = thumbnail.LastIndexOf(".");
                                    thumbnail = thumbnail.Substring(0, num-1) + pictype + ".jpg";//thumbnail.Substring(0, num)+...
                                }
                                else
                                {
                                    thumbnail = "/images/img_new/default_" + contenttype + "_" + pictype + ".png";
                                }
                                idlist = idlist + itemid + ",";
                                //<b style="display: inline-block;width: 20px;height: 20px;position: absolute;left:5px;top:-1px;background: url(/images/tubiaoa.png) repeat scroll -1px -171px"></b>
                                myTrigerType = "<b style=\"display: inline-block;width: 20px;height: 20px;position: absolute;left:5px;top:-1px;background: icon\"></b>";
                                int myType = Convert.ToInt32(table.Rows[i]["triggertype"]);
                                switch (myType)
                                {
                                    case 0:
                                        myTrigerType = myTrigerType.Replace("icon", "url(/images/tubiaoa.png) repeat scroll -1px -171px");
                                        break;
                                    case 3:
                                        myTrigerType = myTrigerType.Replace("icon", "url(/images/tubiaoa.png) repeat scroll -19px -171px");
                                        break;
                                    case 1:
                                        myTrigerType = myTrigerType.Replace("icon", "url(/images/tubiaoa.png) repeat scroll -39px -171px");
                                        break;
                                    case 2:
                                        myTrigerType = myTrigerType.Replace("icon", "url(/images/tubiaoa.png) repeat scroll -62px -171px");
                                        break;
                                    case 4:
                                        myTrigerType = myTrigerType.Replace("icon", "url(/images/tubiaoa.png) repeat scroll -82px -171px");
                                        break;
                                    case 5:
                                        myTrigerType = myTrigerType.Replace("icon", "url(/images/tubiaoa.png) repeat scroll -104px -171px");
                                        break;
                                    default:
                                        myTrigerType = myTrigerType.Replace("icon", "");
                                        break;
                                }
                                string contenttypestr = ReContentTypeStr(contenttype);//triggertype
                                string contenttypestr2 = "";
                                //item.myplayer  //2操作系统自检测 ,3专用应用程序 ,4远程指令 ,5专用文件传输
                                var newTitle = "";
                                switch (Convert.ToInt32(table.Rows[i]["myplayer"]))
                                {
                                    case 2:
                                        newTitle = "操作系统自检测"; break;
                                    case 3:
                                        newTitle = "专用应用程序"; break;
                                    case 4:
                                        newTitle = "远程指令"; break;
                                    case 5:
                                        newTitle = "专用文件传输"; break;
                                }
                                if (table.Rows[i]["itemtype"].ToString() == "0" && newTitle != "")
                                {//0素材， 1栏目
                                    contenttypestr2 = "-" + newTitle;
                                }
                                if (table.Rows[i]["checkstatus"].ToString()!="1")//1 审核通过
                                {//style=\"background-color: #bab823;\"
                                    myUncheckHtml = " style=\"background-color: #bab823;\"";//未通过的节目项，颜色标示
                                }
                                else
                                {
                                    myUncheckHtml = "";
                                }
                                if (i == 0)
                                {//+ '" data-checkstatus="'+ table.Rows[i]["checkstatus"]
                                    templateid = Convert.ToInt32(table.Rows[i]["templateid"]);
                                    column_arrange_scid.Value = itemid.ToString();
                                    html += "<li class='current' data-isshow='1' data-pid=\"" + taskid + "\" data-position=\"" + position + "\" data-id=\"" + itemid + "\" data-name=\"" + itemname + "\" data-contenttype=\"" + contenttype + "\" data-checkstatus=\"" + table.Rows[i]["checkstatus"] + "\" data-tempid=\"" + table.Rows[i]["templateid"].ToString() + "\"><a href=\"javascript:void(0)\" title=\"[" + contenttypestr + "]" + itemname + contenttypestr2 + "\"><img src=\"" + thumbnail + "\" height=\"72\" width=\"96\"><span class=\"time\" "+myUncheckHtml+">" + myTrigerType + duringtimeStr + "</span><span class=\"del\"></span></a></li>";
                                }
                                else
                                {
                                    html += "<li data-isshow='0' data-pid=\"" + taskid + "\" data-position=\"" + position + "\" data-id=\"" + itemid + "\" data-name=\"" + itemname + "\" data-contenttype=\"" + contenttype + "\" data-checkstatus=\"" + table.Rows[i]["checkstatus"] + "\" data-tempid=\"" + table.Rows[i]["templateid"].ToString() + "\"><a href=\"javascript:void(0)\" title=\"[" + contenttypestr + "]" + itemname + contenttypestr2 + "\"><img src=\"" + thumbnail + "\" height=\"72\" width=\"96\"><span class=\"time\" "+myUncheckHtml+">" + myTrigerType + duringtimeStr + "</span><span class=\"del\"></span></a></li>";
                                }
                            }
                            idlist = idlist.Substring(0, idlist.Length - 1);
                            column_arrange_sclist.Value = idlist;
                            cl_range_selsclist.InnerHtml = html;

                        }
                        column_arrange_tempid.Value = templateid.ToString();
                        column_arrange_area_bg_width.Value = width.ToString();
                        column_arrange_area_bg_height.Value = height.ToString();
                        PreviewResolutionService pService = new PreviewResolutionService();
                        List<Resolution> list = new List<Resolution>();
                        list = pService.GetAllData();
                        string rsHtml = "";
                        foreach (Resolution p in list)
                        {
                            rsHtml += "<li><span class=\"label\">" + p.Width + "×" + p.Height + "(" + p.Scale + ")</span><input class=\"inp_c\" name=\"column_arrange_fbl_radio\" type=\"radio\" value=\"" + p.Width + "×" + p.Height + "\"></li>";
                        }
                        rsHtml += "<li><input class='inp_t' id='column_arrange_fbl_width' type='text' value='1440'>x<input class='inp_p' id='column_arrange_fbl_height' type='text' value='900'><span class='inp_info'></span><input class='inp_p'  name='column_arrange_fbl_radio' value='自定义提交' onclick=" + " 'column_arrange_changeros()' " + "  type='button' style='float: right;display: block;margin-top: 2px;margin-right: 50px;'> ";
                        previewResolutionList.InnerHtml = rsHtml;
                    }
                }
                else
                {
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
            }
            
        }
        //根据素材类型返回素材类型文本
        protected string  ReContentTypeStr(int contenttype) {
            var contenttypestr = "未知类型";
            if (contenttype == 0) {
                contenttypestr = "自适应文件";
            }
            if (contenttype == 1) {
                contenttypestr = "文本";
            } if (contenttype == 2) {
                contenttypestr = "网页";
            } if (contenttype == 3) {
                contenttypestr = "图片";
            } if (contenttype == 4) {
                contenttypestr = "通知(静态)";
            } if (contenttype == 5) {
                contenttypestr = "通知(向上滚动文本)";
            } if (contenttype == 6) {
                contenttypestr = "字幕(向左滚动文本)";
            } if (contenttype == 7) {
                contenttypestr = "动画";
            } if (contenttype == 8) {
                contenttypestr = "Office文稿";
            } if (contenttype == 9) {
                contenttypestr = "音频";
            } if (contenttype == 10) {
                contenttypestr = "视频文件/网络视频/电视";
            } if (contenttype == 11) {
                contenttypestr = "操作系统自检测";
            } if (contenttype == 12) {
                contenttypestr = "专用应用程序";
            } if (contenttype == 13) {
                contenttypestr = "远程命令";
            }//专用文件传输 whq..8.24
            if (contenttype == 14) {
                contenttypestr = "专用文件传输";
            }
            if (contenttype == 15) {
                contenttypestr = "栏目";
            }
            //if (contenttype == 14) {
            //    contenttypestr = "栏目";
            //}
            return contenttypestr;
        }
    }
}