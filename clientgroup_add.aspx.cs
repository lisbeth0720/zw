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
    public partial class clientgroup_add : System.Web.UI.Page
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
                        clientgroup_add_dlevel.Value = Request["dlv"];
                        clientgroup_add_groupid.Value = Request["gid"];
                        clientgroup_add_mark.Value = Request["mark"];
                        string clientmark = Request["mark"];
                        if (!string.IsNullOrEmpty(Request["t"]))
                        {
                            if (Request["t"] == "edit")
                            {
                                clientgroup_add_isedit.Value = Request["t"];
                            }
                        }
                        string clientname = "><a id=\"myclientroot\" href=\"javascript:void(0)\">播放终端根目录</a>";
                        string currName = ""; string oldName = "";
                        for (int i = 1; i < clientmark.Split('_').Length; i++)
                        {
                            if (i < GlobalAtt.ClientLevel)//<= 
                            {
                                //clientname = clientname + ">" + GetClientName(mmodel.Companyid, Convert.ToInt32(clientmark.Split('_')[i]));
                                oldName = GetClientName(mmodel.Companyid, Convert.ToInt32(clientmark.Split('_')[i]));
                                currName = oldName;
                                //一级终端组，最后一级终端：显示完整名称。中间的 显示4个字符+...加title
                                if (i > 1 && i < clientmark.Split('_').Length - 1)//
                                {
                                    if (oldName.Length > 4)
                                    {
                                        currName = oldName.Substring(0, 4) + "...";
                                        currName = "<a href=\"javascript:void(0)\" title=\"" + oldName + "\">" + currName + "</a>";
                                    }
                                    else
                                    {
                                        currName = "<a href=\"javascript:void(0)\">" + currName + "</a>";
                                    }
                                }
                                else
                                {
                                    currName = "<a href=\"javascript:void(0)\">" + currName + "</a>";
                                }

                                clientname = clientname + ">" + currName;
                            }
                        }
                        client_group_add_pageMap.Value = clientname;
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
            result = new ClientService().GetOneClient(companyid, clientid).Rows[0]["clientname"].ToString();
            return result;
        }
    }
}