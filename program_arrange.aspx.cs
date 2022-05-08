using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.program
{
    public partial class program_arrange : System.Web.UI.Page
    {//选择节目单后，进入节目单编辑部分
        public string gframelayout="0";
        public int gmenuid = 0;
        public string gmenuName = "";
        public int gposition = 0;
        public int gframelayoutposition=0;
        public string Companyid = "";
        public string Userid = "";
        public string userName = "";
        public string userpassoword = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            Companyid = mmodel.Companyid;
            Userid = mmodel.Userid.ToString();
            userName = mmodel.Username;
            userpassoword = mmodel.Password;
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menuitem1) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)
                    || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)
                    || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                {
                    program_arrange_pagetype.Value = "0";
                    if (!string.IsNullOrEmpty(Request["type"]))
                    {//是缩略图显示还是列表显示
                        program_arrange_pagetype.Value = Request["type"];
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menuitem1) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem))
                    {//编排权限
                        program_arrange_arrright.Value = "1";
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck))
                    {//审核权限
                        program_arrange_chright.Value = "1";
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                    { //发布权限
                        program_arrange_pubright.Value = "1";
                    }
                    //拥有授权
                    if (!string.IsNullOrEmpty(Request["id"]))
                    {//通过节目单ID获取信息
                        
                        int menuid = Convert.ToInt32(Request["id"]);
                        CMenuItem cmodel = new CMenuItem();//历史浏览  保存到Cookie
                        cmodel.ItemID = menuid;
                        cmodel.ItemType = 2;
                        cmodel.Status = 1;
                        CookieHelper.SetMenuItemCookie(cmodel, mmodel.Userid.ToString());
                        gmenuid = menuid;
                        MenuItemService miService = new MenuItemService();
                        Resolution rmodel = new Resolution();
                        rmodel = miService.GetDefaultScale(2);//缺省分辨率
                        int width = rmodel.Width;
                        int height = rmodel.Height;
                        TempletService tService = new TempletService();
                        int templateid = tService.GetDefaultTemp();//缺省显示模板号
                        HuiFeng.BLL.FrameLayout fService = new HuiFeng.BLL.FrameLayout();
                        string lastframeLayoutidstr = fService.GetLastLayOut(mmodel.Companyid, menuid);//返回三个值，分号隔开 
                        int lastframeLayoutid = 0;
                        int loc = lastframeLayoutidstr.IndexOf(":");
                        if (loc >= 0)
                        {
                            lastframeLayoutid = Convert.ToInt32(lastframeLayoutidstr.Substring(0,loc));
                            lastframeLayoutidstr = lastframeLayoutidstr.Substring(loc + 1);
                            loc = lastframeLayoutidstr.IndexOf(":");
                            if (loc >= 0)
                            {
                                gposition = Convert.ToInt32(lastframeLayoutidstr.Substring(0, loc));
                                gframelayoutposition = Convert.ToInt32(lastframeLayoutidstr.Substring(loc + 1));
                            }
                            else
                                gposition = Convert.ToInt32(lastframeLayoutidstr);
                        }
                        else
                        {
                            lastframeLayoutid=Convert.ToInt32(lastframeLayoutidstr);
                        }
                        if (lastframeLayoutid != 0)
                        {
                            gframelayout = lastframeLayoutid.ToString();
                        }
                        DataTable programTable = miService.GetOneMenuItem(mmodel.Companyid, menuid, 2);
                        if (programTable.Rows.Count > 0)
                        {//节目单缺省设置的宽和高
                            if (System.DBNull.Value != programTable.Rows[0]["framesizex"])
                            {
                                width = Convert.ToInt32(programTable.Rows[0]["framesizex"]);
                            }
                            if (System.DBNull.Value != programTable.Rows[0]["framesizey"])
                            {
                                height = Convert.ToInt32(programTable.Rows[0]["framesizey"]);
                            }
                            if (System.DBNull.Value != programTable.Rows[0]["itemname"])
                            {
                                gmenuName = programTable.Rows[0]["itemname"].ToString();
                            }
                            //programIsFiled
                            if (System.DBNull.Value != programTable.Rows[0]["isfiled"])
                            {
                                programIsFiled.Value = programTable.Rows[0]["isfiled"].ToString();
                            }
                            if (width == 0)
                                width = 1024;
                            else if (width < 256)
                            {
                                width = 256;
                            }
                            if (height == 0)
                                height = 768;
                            else if (height < 128)
                            {
                                height = 128;
                            }
                        }

                        program_arrange_menuid.Value = menuid.ToString();
                        program_arrange_tempid.Value = templateid.ToString();
                        program_arrange_area_bg_width.Value = width.ToString();//
                        program_arrange_area_bg_height.Value = height.ToString();
                        PreviewResolutionService pService = new PreviewResolutionService();
                        List<Resolution> list = new List<Resolution>();
                        list = pService.GetAllData();
                        string rsHtml = "";
                        int num = 0;
                        int flag = 0;
                        foreach (Resolution p in list)
                        {
                            num++;
                            if (Convert.ToInt32(programTable.Rows[0]["framesizex"]) == p.Width && Convert.ToInt32(programTable.Rows[0]["framesizey"]) == p.Height)
                            {//选中 当前节目单的分辨率
                                flag = 1;
                                rsHtml += "<li><input id=\"fbl" + num + "\" class=\"inp_c\" name=\"program_arrange_fbl_radio\" checked=\"checked\"  type=\"radio\" value=\"" + p.Width + "×" + p.Height + "\"><label for=\"fbl" + num + "\" class=\"label\">" + p.Width + "×" + p.Height + "(" + p.Scale + ")</label></li>";
                            }
                            else
                            {
                                rsHtml += "<li><input id=\"fbl" + num + "\" class=\"inp_c\" name=\"program_arrange_fbl_radio\" type=\"radio\" value=\"" + p.Width + "×" + p.Height + "\"><label for=\"fbl" + num + "\" class=\"label\">" + p.Width + "×" + p.Height + "(" + p.Scale + ")</label></li>";
                            }
                        }
                        if (flag == 0)
                        {//是自定义的分辨率
                            rsHtml += "<li><input class='inp_p'  name='program_arrange_fbl_button' value='自定义提交' onclick=" + " 'program_arrange_changeros()' " + "  type='button' style='float: right;display: block;margin-top: 2px;margin-right: 50px;'><input class='inp_t' id='program_arrange_fbl_width' type='text' value='" + programTable.Rows[0]["framesizex"] + "'>x<input class='inp_p' id='program_arrange_fbl_height' type='text' value='" + programTable.Rows[0]["framesizey"] + "'><span class='inp_info'></span> ";
                        }
                        else
                        {
                            rsHtml += "<li><input class='inp_p'  name='program_arrange_fbl_button' value='自定义提交' onclick=" + " 'program_arrange_changeros()' " + "  type='button' style='float: right;display: block;margin-top: 2px;margin-right: 50px;'><input class='inp_t' id='program_arrange_fbl_width' type='text' value='1440'>x<input class='inp_p' id='program_arrange_fbl_height' type='text' value='900'><span class='inp_info'></span> ";
                        }
                        program_arrange_scalelist.InnerHtml = rsHtml;
                        if (gframelayout == "")
                        {
                            gframelayout = "0";
                        }
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
    }
}