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
    public partial class client_right : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)//&& cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client)
            {
                client_right_type.Value = Request["type"];
                int idtype = Convert.ToInt32(Request["idtype"]);
                int authid = Convert.ToInt32(Request["id"]);
                if (!string.IsNullOrEmpty(Request["id"]) && !string.IsNullOrEmpty(Request["idtype"]))
                {
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) || mmodel.Userid == authid)
                    {
                        string companyid = mmodel.Companyid;
                    
                        int type = 2;
                        AuthService aService = new AuthService();
                        DataTable table = new DataTable();
                        table = aService.GetAllRightByAuthID(companyid, authid, type, idtype);
                        string selright = "";
                        if (table.Rows.Count > 0)
                        {
                            foreach (DataRow row in table.Rows)
                            {
                                selright +=  row["itemid"].ToString()+",";
                            }
                        }
                        DepartService dService = new DepartService();
                        if (idtype == 0)
                        {
                            CompanyManager manager = new CompanyManager();
                            manager = cmService.GetManagerInfoByID(authid, mmodel.Companyid);
                            if (manager.Quickcheck.Split(';').Length > 2)
                            {
                                selright += manager.Quickcheck.Split(';')[2] + ",";
                            }
                            Depart depart = dService.GetDepartByID(mmodel.Companyid, Convert.ToInt32(manager.DeptID));

                            if (depart.Departid > 0)
                            {
                                if (depart.QuickCheck.Split(';').Length > 2)
                                {
                                    selright += "p_" + depart.QuickCheck.Split(';')[2] + ",";
                                }
                            }
                            DataTable pTable = aService.GetAllRightByAuthID(manager.Companyid, Convert.ToInt32(manager.DeptID), 2, 1);
                            foreach (DataRow row in pTable.Rows)
                            {
                                selright += "p_" + row["itemid"].ToString() + ",";
                            }
                        }
                        else
                        {
                            Depart depart = dService.GetDepartByID(mmodel.Companyid, authid);
                            selright += depart.QuickCheck.Split(';')[2];
                        }
                        manager_right_hid_seldep.Value = selright;
                    }
                    else
                    {
                        Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                    }
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
            }
        }
    }
}