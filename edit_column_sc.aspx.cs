using System;
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
    public partial class edit_column_sc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                MenuItemService itemBll = new MenuItemService();
                try
                {
                    var dt = itemBll.GetOneMenuItem(mmodel.Companyid, Convert.ToInt16(Request["itemid"]), 0);
                    sourcePath.Value = dt.Rows[0]["path"].ToString();
                }
                catch (Exception ex)
                {

                }

                h_edit_column_pagetype.Value = "0";
                if (!string.IsNullOrEmpty(Request["type"]))
                {
                    h_edit_column_pagetype.Value = Request["type"];
                }
                if (!string.IsNullOrEmpty(Request["checkstatus"]))// 节目项 审核状态
                {
                   // checkstatus.Value = Request["checkstatus"];
                    //应该获取，编排之后  节目项的状态
                    MenuService menu = new MenuService();
                    var itemDetail = menu.GetMenuDetail(mmodel.Companyid, Convert.ToInt32(Request["menuid"]), Convert.ToInt32(Request["taskid"]));
                    if (itemDetail.Rows.Count > 0)
                    {
                        checkstatus.Value = itemDetail.Rows[0]["checkstatus"].ToString();
                    }
                    else
                    {
                        checkstatus.Value = "";
                    }
                }
                if ((cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)) && (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)))
                {
                    //既有编排权限又有审核权限
                    //column_arrange_right.Value = "1";
                    BindData();
                    h_edit_column_right.Value = "1";
                }
                else if ((cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)) || (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)))
                {
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem))
                    {
                        //编排权限
                        h_edit_column_right.Value = "2";
                        BindData();

                    }
                    else
                    {
                        //审核权限
                        h_edit_column_right.Value = "3";
                        BindData();
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
        public void BindData()
        {
            column_menu_itemid.Value = Request["sid"];
            h_edit_column_mid.Value = Request["menuid"];
            h_edit_column_tid.Value = Request["taskid"];
            //s_edit_column_scname.InnerHtml = Request["sname"];
            column_menu_itemname.Value=Request["sname"];
            TempletService tService = new TempletService();
            s_t_edit_column_postion.Value = Request["position"];
            h_edit_column_templet.Value = tService.GetDefaultTemp().ToString();
        }
    }
}