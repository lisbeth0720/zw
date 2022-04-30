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

namespace Web.company.depart
{
    public partial class manager_right : System.Web.UI.Page
    {
        protected string deptID = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            deptID = mmodel.DeptID;
            if (mmodel.IsOnLine == 1)
            {
                if (!string.IsNullOrEmpty(Request["id"]) && !string.IsNullOrEmpty(Request["idtype"]))
                {//没有权限，也可以看到部门有   哪些 人员！！！！！6.21 whq
                    //if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Manager))
                    //{//查看 a部门 下的操作员， 
                        string companyid = mmodel.Companyid;
                        int idtype = Convert.ToInt32(Request["idtype"]);
                        int id = Convert.ToInt32(Request["id"]);
                        deptID = id.ToString();
                        string selid = string.Empty;
                        /* AuthService aService = new AuthService();//查询 授权部门为‘a’的所有操作员。。。。默认：操作员的 授权部门为 自己所在部门。。
                         DataTable table = aService.GetChildList(mmodel.Companyid, id, 4);
                         //string selid = mmodel.Userid.ToString() + ",";//添加  当前登录用户，  不对吧。。。。
                         
                         if (table.Rows.Count > 0)
                         {
                             foreach (DataRow row in table.Rows)
                             {
                                 selid += row["authid"].ToString() + ",";
                             }
                         }
                         manager_right_hid_seldep.Value = selid;*/
                        DataTable mytable = cmService.GetManagerByDepartID(mmodel.Companyid,id.ToString());
                        if (mytable.Rows.Count > 0)////获取 某个部门 下的所有操作员
                        {
                            foreach (DataRow row in mytable.Rows)
                            {
                                selid += row["userid"].ToString() + ",";
                            }
                        }
                        manager_right_hid_seldep.Value = selid;
                        
                    //}
                    //else
                    //{
                    //    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                    //}
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
        }
    }
}