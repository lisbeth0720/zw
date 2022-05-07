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

namespace Web.company.log
{
    public partial class log_main : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.Right_C_Log) || cmService.IsShouQuan(mmodel, 0, CommonRight.Right_C_Runlog) || cmService.IsShouQuan(mmodel, 0, CommonRight.Right_C_Playlog))
                {
                    StringBuilder htmlStr = new StringBuilder();
                    hid_logtype.Value = Request["type"];
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.Right_C_Log))
                    {
                        htmlStr.Append("<li data-id='0'>操作日志</li>");
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.Right_C_Runlog))
                    {
                        htmlStr.Append("<li data-id='2'>运行日志管理</li>");

                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.Right_C_Playlog))
                    {
                        htmlStr.Append("<li data-id='1'>播放日志管理</li>");
                        htmlStr.Append("<li data-id='3'>终端反馈信息管理</li>");
                    }
                    log_ment_nav.InnerHtml = htmlStr.ToString();
                }
                else
                {
                    Response.Redirect("/login.aspx");
                }
            }
            else
            {
                Response.Redirect("/login.aspx");
            }
        }
    }
}