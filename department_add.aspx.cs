using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HuiFeng.Web.company
{
    public partial class department_add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (cmService.IsShouQuan(mmodel,0,CommonRight.RIGHT_C_Depart))
            {
                if (!string.IsNullOrEmpty(Request["id"]))
                {
                    string companyid = mmodel.Companyid;
                    int departid = Convert.ToInt32(Request["id"]);
                    dp_add_hid_departid.Value = departid.ToString();
                    Depart model = new Depart();
                    DepartService dService = new DepartService();
                    model = dService.GetDepartByID(companyid, departid);
                    txt_dpadd_name.Value = model.Department;
                    txt_dpadd_att.Value = model.Attribute;
                    txt_dpadd_att.Style["color"] = model.Attribute;
                    txt_dpadd_des.Value = model.Descript;
                     depart_add_belongto.Value = model.Belongto.ToString();//部门不能嵌套部门
                    ////查询部门负责人   select * from COMPANYMANAGER c where exists (    SELECT functionary  FROM [wisedisplay].[dbo].[DEPART] d  where companyid='wisepeak' and departid=1 and CHARINDEX(','+CONVERT(varchar,c.userid)+',',','+functionary+',')>0)
                     string leader = model.functionary;
                     if (!string.IsNullOrEmpty(leader))
                     {
                         BaseService bll = new BaseService();//根据 负责人ID，找到负责人的信息
                         DataTable dt = bll.GetData(string.Format("select * from COMPANYMANAGER c  where companyid='{0}' and  userid  in({1})", companyid, leader));
                         string names = ""; //string ids = "";
                         foreach (DataRow row in dt.Rows)
                         {
                             names += row["fullname"] + ",";//row["username"] + "," + 
                             //ids += row["userid"] + ",";
                         }
                         depart_leader.InnerHtml = names.TrimEnd(',');//负责人姓名
                         leaderID.Value = leader;//负责人ID
                     }
                }
                else
                {
                    depart_add_belongto.Value = Request["fid"];
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                return;
            }
        }
    }
}