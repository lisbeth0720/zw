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
    public partial class client_view : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            myuserName.Value = mmodel.Username;
            myPassword.Value = mmodel.Password;
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                {
                    if (!string.IsNullOrEmpty(Request["gid"]) && !string.IsNullOrEmpty(Request["dlv"]))
                    {
                        client_view_userlevel.Value = mmodel.Merit.ToString();
                        client_view_comid.Value = mmodel.Companyid;
                        client_view_groupid.Value = Request["gid"];
                        client_view_mark.Value = Request["mark"];
                        client_view_dlevel.Value = Request["dlv"];
                        if (!string.IsNullOrEmpty(Request["key"]))
                        {
                            client_view_name.Value = Request["key"];
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
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script type='text/javascript'>window.location.href='/index.html';</script>");
                return;
            }
        }
    }
}