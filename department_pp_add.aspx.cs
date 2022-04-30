using HuiFeng.BLL;
using HuiFeng.Model;
using Maticsoft.Common.DEncrypt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using HuiFeng.Common;

namespace HuiFeng.Web.company.depart
{
    public partial class department_pp_add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine != 1)
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
            else
            {
                if (mmodel.IsSuperManager)
                {
                    for (int i = 0; i < 15; i++)
                    {
                        department_pp_add_dlevel.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }
                    
                }
                else
                {
                    if (!cmService.IsShouQuan(mmodel,0,CommonRight.RIGHT_C_Manager))
                    {
                        Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                    }
                    else
                    {
                        for (int i = Convert.ToInt32(mmodel.Merit); i < 15; i++)
                        {
                             
                            department_pp_add_dlevel.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                        
                    }
                }
                depart_pp_add_parentid.Value = Request["fid"];
 
            }
        }
    }
}