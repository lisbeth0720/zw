using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.company.depart
{
    public partial class depart_rightmanage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (!string.IsNullOrEmpty(Request["id"]) && !string.IsNullOrEmpty(Request["idtype"]))
                {
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Manager))
                    {
                        string companyid = mmodel.Companyid;
                        int idtype = Convert.ToInt32(Request["idtype"]);
                        int id = Convert.ToInt32(Request["id"]);
                        if (!string.IsNullOrEmpty(Request["type"]))
                        {
                            depart_right_type.Value = Request["type"];
                        }

                        if (idtype == 0)
                        {
                            DepartService dService = new DepartService();
                            //dService.GetChildList(id, 0, 4, mmodel.Companyid);//4 //获得用户授权的部门。。。
                            List<Depart> list = dService.GetChildList(id, 0, 7, mmodel.Companyid);//7 //获得用户的 部门经理授权。。。
                            depart_right_hid_seldepart.Value = ConvertHelper<Depart>.ListToJson(list);

                        }
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "loginTimeOut", "<script type='text/javascript'>window.location.href='/index.html';</script>");
                        return;
                    }
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
        }
    }
}