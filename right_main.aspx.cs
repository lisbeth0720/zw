using System;
using System.Collections.Generic;
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
    public partial class right_main : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            string isMeeting = "no";
            if (HttpContext.Current.Session["user"]!=null)
            {//会议预约用户 ，，，先把 其他资源权限 去掉：栏目、节目单、布局、终端组--业务授权
                isMeeting = "yes";
            }
            if (HttpContext.Current.Session["Manager"] != null)
            {
                isMeeting = "no";
            }
            if (mmodel.IsOnLine != 1)
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
            }
            else
            {
                if (!string.IsNullOrEmpty(Request["idtype"]))
                {
                    StringBuilder rightnavHtml = new StringBuilder();
                    int idtype = Convert.ToInt32(Request["idtype"]);
                    right_main_idtype.Value = Request["idtype"];
                    int id=Convert.ToInt32(Request["id"]);
                    right_main_authid.Value = Request["id"];
                    int type=0;

                    if (!string.IsNullOrEmpty(Request["type"]))
                    {
                        type = int.Parse(Request["type"]);
                    }
                    if (idtype == 0)
                    {
                        //针对用户授权
                        CompanyManager model = cmService.GetManagerInfoByID(id,mmodel.Companyid);
                        right_main_top.InnerHtml = "<div class=\"title\"><ul><li><span>用户名：</span><span>" + model.Username + "</span></li><li><span>所属部门：</span><span>" + model.DeptName + "<span></li></ul></div>";
                        if (cmService.IsShouQuan(mmodel,0,CommonRight.RIGHT_C_Manager) || Request["id"]==mmodel.Userid.ToString())
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/department_pp_detail.aspx\"><a href=\"javascript:void(0)\">用户信息</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth))
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/depart_right.aspx\"><a href=\"javascript:void(0)\">角色授权</a></li>");//部门授权
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth))
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/sys_right.aspx\"><a href=\"javascript:void(0)\" >权限授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting=="no")
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/frame_right.aspx\"><a href=\"javascript:void(0)\" >布局授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/column_right.aspx\"><a href=\"javascript:void(0)\" >栏目授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/menuitem_right.aspx\"><a href=\"javascript:void(0)\" >节目单授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/client_right.aspx\"><a href=\"javascript:void(0)\" >终端组授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth))
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/MeetingRoom_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >会议室授权</a></li>");
                        }
                        if (mmodel.IsSuperManager)//cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth)
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/depart_rightmanage.aspx\"><a href=\"javascript:void(0)\">经理授权</a></li>");
                        }
                        //////////北京市人民检察院第四分院定制研发需求
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/JCYbusiness_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >业务授权</a></li>");
                        }
                        /////////
                        web_pp_right_nav.InnerHtml = rightnavHtml.ToString();
                    }
                    else if (idtype == 1)
                    {
                        Depart model = new DepartService().GetDepartByID(mmodel.Companyid, id);
                        right_main_top.InnerHtml = "<div class=\"title\"><ul><li><span>部门名称：</span><span>" + model.Department + "</span></li></ul></div>";
                        //针对部门授权
                        if (cmService.IsShouQuan(mmodel, 0,CommonRight.RIGHT_C_Depart))
                        {

                            rightnavHtml.Append("<li  data-pageurl=\"/company/depart/manager_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\">操作员</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0,CommonRight.RIGHT_C_Depart))
                        {
                            rightnavHtml.Append("<li data-type=\"" + type + "\" data-pageurl=\"/company/depart/department.aspx\"><a href=\"javascript:void(0)\">部门信息</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth))
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/sys_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >权限授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/frame_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >布局授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/column_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >栏目授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/menuitem_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >节目单授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/client_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >终端组授权</a></li>");
                        }
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth))
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/MeetingRoom_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >会议室授权</a></li>");
                        }
                        //////////北京市人民检察院第四分院定制研发需求
                        if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Auth) && isMeeting == "no")
                        {
                            rightnavHtml.Append("<li data-pageurl=\"/company/depart/JCYbusiness_right.aspx\" data-type=\"" + type + "\"><a href=\"javascript:void(0)\" >业务授权</a></li>");
                        }
                        /////////
                        web_pp_right_nav.InnerHtml = rightnavHtml.ToString();
                    }
                    else
                    {
                        //非法进入
                        Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                    }
                }
                else
                {
                    //非法进入
                    Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut()</script>");
                }
            }
        }
    }
}