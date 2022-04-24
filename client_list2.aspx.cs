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
    public partial class client_list2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient))
                {
                    if (!string.IsNullOrEmpty(Request["gid"]) && !string.IsNullOrEmpty(Request["dlv"]))
                    {
                        client_list2_dlevel.Value = Request["dlv"];
                        client_list2_groupid.Value = Request["gid"];
                        client_list2_remark.Value = Request["mark"];
                        string clientname = "播放终端根目录";
                        string clientmark = Request["mark"];
                        for (int i = 1; i < clientmark.Split('_').Length; i++)
                        {
                            if (i <= GlobalAtt.ClientLevel)
                            {
                                clientname = clientname + ">" + GetClientName(mmodel.Companyid, Convert.ToInt32(clientmark.Split('_')[i]));
                            }
                        }
                        client_list2_pageMap.Value = clientname;
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
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
            }
        }
        public string GetClientName(string companyid, int clientid)
        {
            string result = "";
            result = "<a href=\"javascript:void(0)\">" + new ClientService().GetOneClient(companyid, clientid).Rows[0]["clientname"].ToString() + "</a>";
            return result;
        }
    }
}