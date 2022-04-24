using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Model;

namespace Web.company.client
{
    public partial class client_del : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (mmodel.IsSuperManager || cmService.IsShouQuan(mmodel.Rightstring, "0010") || cmService.IsShouQuan(mmodel.Rightstring, "400000000000"))
                {
                    if (!string.IsNullOrEmpty(Request["gid"]))
                    {

                        clientgroup_del_groupid.Value = Request["gid"];

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
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script type='text/javascript'>window.location.href='/index.html';</script>");
                return;
            }
        }
    }
}