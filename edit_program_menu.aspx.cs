using System;
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
    public partial class edit_program_menu : System.Web.UI.Page
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

                h_edit_program_menu_pagetype.Value = "0";
                if (!string.IsNullOrEmpty(Request["type"]))
                {
                    h_edit_program_menu_pagetype.Value = Request["type"];                    
                }
                if (!string.IsNullOrEmpty(Request["checkstatus"]))// 节目项 审核状态
                {
                    //checkstatus.Value = Request["checkstatus"];//这是素材的状态
                    //应该获取，编排之后  节目项的状态
                    MenuService menu = new MenuService();
                    var itemDetail= menu.GetMenuDetail(mmodel.Companyid, Convert.ToInt32(Request["menuid"]), Convert.ToInt32(Request["taskid"]));
                    if (itemDetail.Rows.Count>0)
                    {
                        checkstatus.Value = itemDetail.Rows[0]["checkstatus"].ToString();
                    }
                    else
                    {
                        checkstatus.Value = "";
                    }
                }
                // && cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)   // && cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)
                if ((cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menuitem1) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)) &&
                    (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)))
                {//拥有 编排审核权限
                    h_edit_program_menu_right.Value = "1";
                    h_edit_program_menu_taskid.Value = Request["taskid"];
                    t_edit_program_postion.Value = Request["position"];
                    t_edit_program_oldpostion.Value = t_edit_program_postion.Value;
                    h_edit_program_menu_menuid.Value = Request["menuid"];
                    program_menu_itemname.Value = Request["itemname"];
                    program_menu_itemid.Value = Request["itemid"];
                    h_edit_program_window.Value = Request["window"];
                    h_edit_program_framelayoutid.Value = Request["framelayoutid"];
                    h_edit_program_fposition.Value = Request["fposition"];
                }
                else if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menuitem1) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem))// && cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem)
                {//只有编排权限
                    h_edit_program_menu_right.Value = "2";
                    h_edit_program_menu_taskid.Value = Request["taskid"];
                    t_edit_program_postion.Value = Request["position"];
                    t_edit_program_oldpostion.Value = t_edit_program_postion.Value;
                    h_edit_program_menu_menuid.Value = Request["menuid"];
                    program_menu_itemname.Value = Request["itemname"];
                    program_menu_itemid.Value = Request["itemid"];
                    h_edit_program_window.Value = Request["window"];
                    h_edit_program_framelayoutid.Value = Request["framelayoutid"];
                    h_edit_program_fposition.Value = Request["fposition"];
                }
                else if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck))//&& cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)
                {//只有 审核权限
                    h_edit_program_menu_right.Value = "3";
                    h_edit_program_menu_taskid.Value = Request["taskid"];
                    t_edit_program_postion.Value = Request["position"];
                    t_edit_program_oldpostion.Value = t_edit_program_postion.Value;
                    h_edit_program_menu_menuid.Value = Request["menuid"];
                    program_menu_itemname.Value = Request["itemname"];
                    program_menu_itemid.Value = Request["itemid"];
                    h_edit_program_window.Value = Request["window"];
                    h_edit_program_framelayoutid.Value = Request["framelayoutid"];
                    h_edit_program_fposition.Value = Request["fposition"];
                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script type='text/javascript'>window.location.href='/index.html';</script>");
                    return;
                }
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script type='text/javascript'>window.location.href='/index.html';</script>");
                return;
            }
        }
    }
}