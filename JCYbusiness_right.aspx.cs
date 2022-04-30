using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.company.depart
{
    public partial class JCYbusiness_right : System.Web.UI.Page
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
                    int idtype = Convert.ToInt32(Request["idtype"]);
                    StringBuilder innHtml = new StringBuilder();
                    string companyid = mmodel.Companyid;
                    RightDefService rService = new RightDefService();
                    DataTable table = new DataTable();
                    table = rService.GetAllData();
                    if (!string.IsNullOrEmpty(Request["type"]))
                    {
                        sys_right_type.Value = Request["type"];
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) || mmodel.Userid == authid)
                    {

                        AuthService aService = new AuthService();
                        string selright = "";
                        DepartService dService = new DepartService();
                        DataTable aTable = aService.GetAllRightByAuthID(mmodel.Companyid, authid, 8, idtype);
                        foreach (DataRow row in aTable.Rows)//用户(部门)的所有权限 _auth表
                        {
                            if (!selright.Contains("," + row["itemid"].ToString() + ","))
                            { selright += row["itemid"].ToString() + ","; }
                        }
                        if (idtype == 0)//0用户，1部门
                        {
                            CompanyManager manager = cmService.GetManagerInfoByID(authid, mmodel.Companyid);
                            //权限id不重复添加。。。。
                            if (manager.Quickcheck.Split(';').Length > 0)
                            {
                                selright += manager.Quickcheck.Split(';')[0] + ",";//companymanager用户表 ，快捷权限
                            }
                            Depart depart = dService.GetDepartByID(mmodel.Companyid, Convert.ToInt32(manager.DeptID));
                            if (depart.Departid > 0)
                            {
                                if (depart.QuickCheck.Split(';').Length > 0)//用户所在部门,--Depart部门表 ，快捷权限
                                {
                                    selright += "p_" + depart.QuickCheck.Split(';')[0] + ",";
                                }
                            }
                            DataTable pTable = aService.GetAllRightByAuthID(manager.Companyid, Convert.ToInt32(manager.DeptID), 8, 1);
                            foreach (DataRow row in pTable.Rows)//用户所在部门的所有权限 _auth表
                            {
                                //if (!selright.Contains(row["itemid"].ToString()+","))
                                //{
                                    selright += "p_" + row["itemid"].ToString() + ",";
                               // }
                               
                            }
                        }
                        else
                        {

                            Depart depart = dService.GetDepartByID(mmodel.Companyid, authid);                            
                            selright += depart.QuickCheck.Split(';')[0];//Depart部门表 ，快捷权限
                            
                        }
                        sys_right_hid_sel.Value = selright;
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