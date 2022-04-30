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
    public partial class department_list : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine != 1)
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
            else
            {
                if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Depart))
                {
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                    return;
                }
            }
        }
    }
}