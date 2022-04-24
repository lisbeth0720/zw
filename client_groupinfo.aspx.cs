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
    public partial class client_groupinfo : System.Web.UI.Page
    {
        public string authStr = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (mmodel.IsSuperManager || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_RemoteCon))
                {
                    authStr = "onclick=\"oncmd(this)\"";
                }

                if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu)))
                {
                    ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script>LoginTimeOut();</script>");
                    //Response.Redirect("/login.aspx");
                }
                else
                {
                    client_groupinfo_userlevel.Value = mmodel.Merit.ToString();
                    //client_groupinfo_comid.Value = mmodel.Companyid;
                    client_groupinfo_dlevel.Value = Request["dlv"];
                    client_groupinfo_clientid.Value = Request["gid"];
                    client_groupinfo_mark.Value = Request["mark"];
                    client_groupinfo_name.Value ="";
                    if (!string.IsNullOrEmpty(Request["key"]))
                    {
                        client_groupinfo_name.Value = Request["key"];
                    }
                }
            }
        }
    }
}