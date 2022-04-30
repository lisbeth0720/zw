using HuiFeng.BLL;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.Common;

namespace HuiFeng.Web.company.depart
{
    public partial class department_pp_list : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            loginMerit.Value = mmodel.Merit.ToString();
            loginUserid.Value = mmodel.Userid.ToString();
            isSuperManage.Value = mmodel.IsSuperManager.ToString();
            if (mmodel.IsOnLine != 1)
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
            else
            {
                if (!cmService.IsShouQuan(mmodel,0,CommonRight.RIGHT_C_Manager))
                {
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                }
            }
        }
    }
}