using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.client
{
    public partial class sendview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                {
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script>LoginTimeOut();</script>");
                //Response.Redirect("/login.aspx");
            }
        }
    }
}