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
    public partial class client_menu_add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                {
                    client_menu_clientid.Value = Request["gid"];
                    client_menu_dlevel.Value = Request["dlv"];
                    string clientmark = Request["mark"];
                    string clientname = ">播放终端根目录";
                    string currName = ""; string oldName = "";
                    client_menu_mark.Value = Request["mark"];
                    string isEdit=Request["t"];
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
                    client_menu_pageMap.Value = clientname;
                    if (!string.IsNullOrEmpty(isEdit))
                    {//加载 已有节目单的设置。
                        client_menu_clientmenuid.Value = isEdit;//编辑 终端的节目单。
                        ClientMenuService myser = new ClientMenuService();
                        var dts = myser.GetClientMenuByIds(mmodel.Companyid, Request["mymenuid"], Convert.ToInt32(Request["myclientid"]));
                        menuData.Value= ConvertHelper<ClientMenu>.DataTable2Json(dts);
                    }
                }
                else
                {
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                }
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