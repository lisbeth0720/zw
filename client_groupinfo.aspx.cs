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
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu)))
                {
                    Response.Redirect("/login.aspx");
                }
                else
                {
                    client_groupinfo_userlevel.Value = mmodel.Merit.ToString();
                    client_groupinfo_comid.Value = mmodel.Companyid;
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