﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.program
{
    public partial class program_tablist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                program_list_tab_ds.Value = Request["sd"];
                program_list_tab_of.Value = Request["of"];
                program_tabist_hid_type.Value = Request["t"];
                program_list_tab_sort.Value = Request["sort"];
                if (!string.IsNullOrEmpty(Request["key"]))
                {
                    string[] keys = Request["key"].Split('|');
                    program_list_tab_qy_sn.Value = keys[0];
                    program_list_tab_qy_un.Value = keys[1];
                    program_list_tab_qy_cd.Value = keys[2];
                    program_list_tab_qy_s.Value = keys[3];
                    program_list_tab_qy_us.Value = keys[4];
                    program_list_tab_qy_sr.Value = keys[5];
                    program_list_tab_qy_isown.Value = keys[6];
                    program_list_tab_qy_page.Value = keys[7];
                    program_list_tab_qy_dr.Value = keys[8];
                    program_list_tab_qy_group.Value = keys[9];
                    program_list_tab_qy_isfiled.Value = keys[10];
                }
                if (!string.IsNullOrEmpty(Request["t"]))
                {
                    int type = Convert.ToInt32(Request["t"]);
                    if (type == 0)
                    {
                        if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menu))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 1)
                    {
                        if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_MenuItemCheck))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 2)
                    {
                        if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menuitem1) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu)))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 3)
                    {
                        if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu)))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 4)
                    {
                        if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
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
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script type='text/javascript'>window.location.href='/Company/index.aspx';</script>");
                return;
            }
        }
    }
}