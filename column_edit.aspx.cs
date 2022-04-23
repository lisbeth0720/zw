﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.column
{
    public partial class column_edit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subject))
                {
                    //拥有授权
                    if (!string.IsNullOrEmpty(Request["id"]))
                    {
                        int itemid = Convert.ToInt32(Request["id"]);
                        cl_add_itemid.Value = itemid.ToString();
                        if (!string.IsNullOrEmpty(Request["sq"]))
                        {
                            cl_add_sq.Value = Request["sq"];
                        }
                        CMenuItem cmodel = new CMenuItem();//历史浏览  保存到Cookie
                        cmodel.ItemID = itemid;
                        cmodel.ItemType = 1;
                        cmodel.Status = 1;
                        CookieHelper.SetMenuItemCookie(cmodel, mmodel.Userid.ToString());
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