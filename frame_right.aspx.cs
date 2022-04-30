using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;

namespace Web.company.depart
{
    public partial class frame_right : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (!string.IsNullOrEmpty(Request["id"]) && !string.IsNullOrEmpty(Request["idtype"]))
                {
                    int authid = Convert.ToInt32(Request["id"]);
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth)||authid==mmodel.Userid)
                    {
                        if (!string.IsNullOrEmpty(Request["type"]))
                        {
                            frame_right_type.Value = Request["type"];
                        }
                        AuthService aService = new AuthService();
                        int idtype = Convert.ToInt32(Request["idtype"]);
                        string selright = "";
                        DataTable aTable = aService.GetAllRightByAuthID(mmodel.Companyid, authid, 3, idtype);
                        foreach (DataRow row in aTable.Rows)
                        {
                            selright += row["itemid"].ToString() + ",";//部门/用户授权的布局
                        }
                        DepartService dService = new DepartService();
                        if (idtype == 0)
                        {
                            CompanyManager manager = new CompanyManager();
                            manager = cmService.GetManagerInfoByID(authid, mmodel.Companyid);
                            if (manager.Quickcheck.Split(';').Length > 3)
                            {
                                selright += manager.Quickcheck.Split(';')[3] + ",";
                            }
                            Depart depart = dService.GetDepartByID(mmodel.Companyid, Convert.ToInt32(manager.DeptID));
                            if (depart.QuickCheck.Split(';').Length > 3)//用户所在部门  是否拥有-所有布局权限
                            {
                                selright += "p_" + depart.QuickCheck.Split(';')[3] + ",";
                            }
                            DataTable pTable = aService.GetAllRightByAuthID(manager.Companyid, Convert.ToInt32(manager.DeptID), 3, 1);
                            foreach (DataRow row in pTable.Rows)//用户所在部门 所有授权的布局
                            {
                                selright += "p_" + row["itemid"].ToString() + ",";
                            }
                        }
                        else
                        {
                            Depart depart = dService.GetDepartByID(mmodel.Companyid, authid);
                            selright += depart.QuickCheck.Split(';')[3];
                        }
                        frame_right_hid_seldep.Value = selright;
                    }
                    else
                    {
                        Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
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