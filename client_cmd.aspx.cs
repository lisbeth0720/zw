using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.company.client
{
    public partial class client_cmd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_RemoteCommands))
                {
                    client_cmd_dlevel.Value = Request["dlv"];
                    client_cmd_groupid.Value = Request["gid"];
                    client_cmd_idlist.Value = Request["gid"];
                    client_cmd_mark.Value = Request["mark"];
                    client_ipaddress.Value = Request["client_ipaddress"];
                    client_name.Value = Request["client_name"];
                    for (int i = Convert.ToInt32(mmodel.Merit); i < 15; i++)
                    {
                        select_merit.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }
                }
                else
                {
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
            }

        }
    }
}