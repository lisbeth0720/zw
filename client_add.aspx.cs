using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.client
{
    public partial class client_add : System.Web.UI.Page
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
                        client_add_dlevel.Value = Request["dlv"];
                        string idlist = Request["gid"];
                        client_add_groupid.Value = idlist;
                        client_add_idlist.Value = idlist;
                        if (Request["mark"] == "")
                        {
                            client_add_remark.Value = "";
                        }
                        else
                        {
                            client_add_remark.Value = Request["mark"];
                            client_add_mark.Value = Request["mark"];
                        }
                        if (!string.IsNullOrEmpty(Request["t"]))
                        {
                            if (Request["t"] == "edit")
                            {
                                client_add_isedit.Value = Request["t"];
                              
                                if (idlist.Contains("*"))
                                {
                                    //编辑组内终端
                                    client_add_groupid.Value = GetTopClient(mmodel.Companyid,Request["mark"]).ToString();
                                }
                                else
                                {
                                    client_add_groupid.Value = idlist.Split(',')[0];
                                }
                            }
                        }
                        string clientmark = Request["mark"];
                        string clientname = "><a id=\"myclientroot\" href='javascript:void(0)'>播放终端根目录</a>";
                        string currName = ""; string oldName = "";
                        for (int i = 1; i < clientmark.Split('_').Length; i++)
                        {
                            if (i <= GlobalAtt.ClientLevel)// <=
                            {
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
                                // clientname = clientname + ">" + GetClientName(mmodel.Companyid, Convert.ToInt32(clientmark.Split('_')[i]));
                            }
                        }
                        client_add_pageMap.Value = clientname;
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
        public int GetTopClient(string companyid, string clientmark)
        {
            int clientid = 0;
            DataTable table = new DataTable();
            table = new ClientService().GetTopClient(companyid, clientmark);
            if (table.Rows.Count > 0)
            {
                clientid = Convert.ToInt32(table.Rows[0]["clientid"]);
            }
            return clientid;
        }
        public string GetClientName(string companyid, int clientid)
        {
            string result = "";
            result = new ClientService().GetOneClient(companyid, clientid).Rows[0]["clientname"].ToString();
            return result;
        }
    }
}