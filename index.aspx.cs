using HuiFeng.BLL;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.Common;

namespace Web.company.control
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (!(mmodel.IsOnLine == 1 && cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_RemoteSta)))//mmodel.IsSuperManager
            {////启动/重启控制室端   //还是‘超级管理员’
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
            else
            {
                companyid.Value = mmodel.Companyid;
                username.Value = mmodel.Username.ToString();
                password.Value = mmodel.Password;
            }
        }
    }
}