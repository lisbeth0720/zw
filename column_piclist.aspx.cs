using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Model;

namespace Web.company.column
{
    public partial class column_piclist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                cl_list_pic_ds.Value = Request["sd"];
                cl_list_pic_of.Value = Request["of"];
                column_picist_hid_type.Value = Request["t"];
                cl_list_pic_sort.Value = Request["sort"];
                if (!string.IsNullOrEmpty(Request["key"]))
                {
                    string[] keys = Request["key"].Split('|');
                    cl_list_pic_qy_sn.Value = keys[0];
                    cl_list_pic_qy_un.Value = keys[1];
                    cl_list_pic_qy_cd.Value = keys[2];
                    cl_list_pic_qy_s.Value = keys[3];
                    cl_list_pic_qy_us.Value = keys[4];
                    cl_list_pic_qy_sr.Value = keys[5];
                    cl_list_pic_qy_isown.Value = keys[6];
                    cl_list_pic_qy_page.Value = keys[7];
                    cl_list_pic_qy_dr.Value = keys[8];
                    cl_list_pic_qy_group.Value = keys[9];
                    cl_list_pic_qy_isfiled.Value = keys[10];
                }
                column_picist_hid_type.Value = Request["t"];

            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
            }
        }
    }
}