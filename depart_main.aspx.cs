using HuiFeng.BLL;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.Common;

namespace HuiFeng.Web.company
{
    public partial class depart_main : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {

                if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Depart) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Manager)))
                {
                    Response.Redirect("/Login.aspx");
                }
                else
                {
                    depart_main_type.Value = Request["t"];//1，3  //添加部门、操作员   
                    // //只有部门经理、超级管理员    能添加部门、操作员！
                    addUserDepart.Value = (mmodel.IsSuperManager || mmodel.Quickcheck.Split(';')[7] == "*").ToString();
                }

            }
            else
            {
                Response.Redirect("/Login.aspx");
            }
        }
    }
}