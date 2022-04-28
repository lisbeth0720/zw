using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.client
{
    public partial class client_main : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
           
            if (mmodel.IsOnLine == 1)
            {
                myComId.Value = mmodel.Companyid;
                if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_RemoteCommands)))
                {
                    Response.Redirect("/login.aspx");
                }
                else
                {

                    client_main_dlevel.Value = "0";
                    if (!string.IsNullOrEmpty(Request["dlv"]))
                    {
                        client_main_dlevel.Value = Request["dlv"];
                    }
                    client_main_mark.Value = "";
                    if (!string.IsNullOrEmpty(Request["mark"]))
                    {
                        client_main_mark.Value = Request["mark"];
                    }
                    client_main_edit.Value = "";
                    if (!string.IsNullOrEmpty(Request["edit"]))
                    {
                        client_main_edit.Value = Request["edit"];
                    }
                    client_main_groupid.Value = "";
                    if (!string.IsNullOrEmpty(Request["gid"]))
                    {
                        client_main_groupid.Value = Request["gid"];
                    }
                }
            }
        }
    }
}