using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.column
{
    public partial class column_quote : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subject)
                   || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_MenuItemCheck)
                   || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Subjectitem)
                   || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck)
                   || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck)
                   || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem))
                {
                    if (!string.IsNullOrEmpty(Request["id"]))
                    {
                        int sourceid = Convert.ToInt32(Request["id"]);
                        string name = Request["name"];
                        column_quote_sourceid.Value = sourceid.ToString();
                        column_quote_sourcename.InnerHtml = name;
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
    }
}