using HuiFeng.BLL;
using HuiFeng.Model;
using Maticsoft.Common.DEncrypt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.Common;

namespace HuiFeng.Web.company.depart
{
    public partial class department_pp_detail : System.Web.UI.Page
    {
        protected string password = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel,0,CommonRight.RIGHT_C_Manager)||mmodel.Userid.ToString()==Request["id"])
                {

                    string companyid = mmodel.Companyid;
                    int managerid = 0;
                    if (!string.IsNullOrEmpty(Request["t"]))
                    {
                        //depart_member_info_type.Value = Request["t"];
                    }
                    if (!string.IsNullOrEmpty(Request["id"]))
                    {
                        managerid=  Convert.ToInt32(Request["id"]);
                    }
                    d_pp_detail_hid_userid.Value = managerid.ToString();
                    CompanyManager model = new CompanyManager();
                    model = cmService.GetManagerInfoByID(managerid, companyid);
                    int myMerit = Convert.ToInt32(mmodel.Merit);
                    //旧版B/S，登录用户 只能查看 低于自己优先级的用户。。
                    for (int i = 0; i < 16; i++)//Convert.ToInt32(mmodel.Merit)
                    {//mmodel 当前登录用户，，，，model查看 编辑的用户。。。
                        if (mmodel.Userid == model.Userid)
                        {//1.编辑自己账号，//显示 用户的优先级 
                            d_pp_detail_t_dlevel.Items.Add(new ListItem(model.Merit.ToString(), model.Merit.ToString()));
                            break;
                        }
                        if (myMerit>=model.Merit)
                        {//2.自己优先级低于-等于- 要编辑用户的优先级 //显示 用户的优先级 
                            d_pp_detail_t_dlevel.Items.Add(new ListItem(model.Merit.ToString(), model.Merit.ToString()));
                            break;
                            //d_pp_detail_t_dlevel.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                        //自己优先级高于 要编辑用户的优先级，，可以编辑。。。
                        if (i > myMerit && myMerit < model.Merit)//自己优先级 要编辑用户的优先级。等于-一样 ？？？
                        {//显示 自己以下的优先级 
                            d_pp_detail_t_dlevel.Items.Add(new ListItem(i.ToString(), i.ToString()));
                        }
                       // d_pp_detail_t_dlevel.Attributes[""]="";//disabled..readonly 
                    }
                    if (myMerit>model.Merit)//自己优先级低于- 要编辑用户的优先级 
                    {//不能修改
                        d_pp_detail_t_fullname.Attributes["readonly"] = "readonly";
                        department_pp_add_password.Attributes["readonly"] = "readonly";
                        department_pp_add_password2.Attributes["readonly"] = "readonly";
                        d_pp_detail_t_dlevel.Attributes["readonly"] = "readonly";
                        d_pp_detail_t_email.Attributes["readonly"] = "readonly";
                        d_pp_detail_t_mobile.Attributes["readonly"] = "readonly";
                        d_pp_detail_t_tel.Attributes["readonly"] = "readonly";
                        d_pp_detail_t_status.Attributes["readonly"] = "readonly";
                        d_pp_detail_t_descript.Attributes["readonly"] = "readonly";
                        ServicePeople.Attributes["readonly"] = "readonly";
                    }
                   // d_pp_detail_s_username.InnerText = model.Username;
                    if (model.DeptName != "")
                    {
                     //   d_pp_detail_s_department.InnerText = model.DeptName;
                    }
                    else
                    {
                        if (model.Username == "administrator")
                        {
                          //  d_pp_detail_s_department.InnerText = "超级管理员";
                        }
                        else
                        {
                          //  d_pp_detail_s_department.InnerText = "外部注册用户";
                        }
                    }
                    d_pp_detail_t_username.Value = model.Username;
                    //d_pp_detail_s_fullname.InnerText = model.Fullname;
                    d_pp_detail_t_fullname.Value = model.Fullname;
                    //d_pp_detail_s_dlevel.InnerText = model.Merit.ToString();
                    d_pp_detail_t_dlevel.Value = model.Merit.ToString();
                    oldMerit.Value = model.Merit.ToString();
                    loginMerit.Value = mmodel.Merit.ToString();
                    //d_pp_detail_s_email.InnerHtml = model.Email;
                    d_pp_detail_t_email.Value = model.Email;
                    //d_pp_detail_s_mobile.InnerHtml = model.Mobile;
                    d_pp_detail_t_mobile.Value = model.Mobile;
                    //d_pp_detail_s_tel.InnerHtml = model.Tel;
                    d_pp_detail_t_tel.Value = model.Tel;
                    password = mmodel.Password;
                    department_pp_add_password.Value = "?????????h";
                    department_pp_add_password2.Value = "?????????h";
                    //d_pp_detail_s_crdate.InnerHtml = Convert.ToDateTime(model.Createtime).ToString("yyyy-MM-dd HH:mm:ss");
                    if (model.Status == 0)
                    {
                        //0正常，1登录时修改密码，2不能修改密码，3禁用*/
                        //d_pp_detail_s_status.InnerText = "正常状态";
                    }
                    else if (model.Status == 1)
                    {
                        //d_pp_detail_s_status.InnerText = "登录时修改密码";
                    }
                    else if (model.Status == 2)
                    {
                       // d_pp_detail_s_status.InnerText = "不能修改密码";
                    }
                    else if (model.Status == 3)
                    {
                        //d_pp_detail_s_status.InnerText = "禁用状态";
                    }
                    d_pp_detail_t_status.Value = model.Status.ToString();
                   // d_pp_detail_s_descript.InnerText = model.Descript;
                    d_pp_detail_t_descript.Value = model.Descript;
                    depart_pp_detail_depid.Value = model.DeptID;
                    department_pp_add_hdpname.Value = model.DeptName;
                    if (model.Usertype==1)
                    {
                        ServicePeople.Checked = true;
                    }
                }
                else
                {
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                }
            }
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
        }
    }
}