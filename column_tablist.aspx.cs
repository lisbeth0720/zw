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
    public partial class column_tablist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                cl_list_tab_ds.Value = Request["sd"];
                cl_list_tab_of.Value = Request["of"];
                cl_list_tab_sort.Value = Request["sort"];
                column_tablist_hid_type.Value = Request["t"];
                if (!string.IsNullOrEmpty(Request["key"]))
                {
                    string[] keys = Request["key"].Split('|');
                    cl_list_tab_qy_sn.Value = keys[0];
                    cl_list_tab_qy_un.Value = keys[1];
                    cl_list_tab_qy_cd.Value = keys[2];
                    cl_list_tab_qy_s.Value = keys[3];
                    cl_list_tab_qy_us.Value = keys[4];
                    cl_list_tab_qy_sr.Value = keys[5];
                    cl_list_tab_qy_isown.Value = keys[6];
                    cl_list_tab_qy_page.Value = keys[7];
                    cl_list_tab_qy_dr.Value = keys[8];
                    cl_list_tab_qy_group.Value = keys[9];
                    cl_list_tab_qy_isfiled.Value = keys[10];
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