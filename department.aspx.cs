using HuiFeng.BLL;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.Common;
using System.Data;

namespace HuiFeng.Web.company
{
    public partial class department : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1 && cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Depart))
            {
                if (!string.IsNullOrEmpty(Request["id"]))
                {
                    string companyid = mmodel.Companyid;
                    int departid = Convert.ToInt32(Request["id"]);
                    department_hid_departid.Value = departid.ToString();
                    DepartService dService = new DepartService();
                    Depart model = new Depart();
                    model = dService.GetDepartByID(companyid, departid);
                    department_departname.InnerHtml = model.Department;
                    department_departdes.InnerHtml = model.Descript;
                    department_departcolor.InnerHtml = "<p style='width:78px; height:15px; background:" + model.Attribute + "'></p>";
                    department_departedit.InnerHtml = "<span class='btn' onclick='editDepart(" + departid.ToString() + ")'><a href='javascript:void(0)' >修改</a></span>";
                    //<span class='btn' style='margin-left:50px;'><a href="#">修改</a></span>
                    //查询部门负责人   select * from COMPANYMANAGER c where exists (    SELECT functionary  FROM [wisedisplay].[dbo].[DEPART] d  where companyid='wisepeak' and departid=1 and CHARINDEX(','+CONVERT(varchar,c.userid)+',',','+functionary+',')>0)
                    string leader = model.functionary;
                    if (!string.IsNullOrEmpty(leader))
                    {
                        BaseService bll = new BaseService();//根据 负责人ID，找到负责人的信息
                        DataTable dt = bll.GetData(string.Format("select * from COMPANYMANAGER c  where companyid='{0}' and  userid  in({1})", companyid, leader));
                        string names = "";
                        foreach (DataRow row in dt.Rows)
                        {
                            names += row["fullname"] + ",";//row["username"] + "," + 
                        }
                        depart_leader.InnerHtml = names.TrimEnd(',');
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