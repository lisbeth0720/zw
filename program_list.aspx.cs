using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;
using System.Data;

namespace Web.company.program
{
    public partial class program_list : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (!string.IsNullOrEmpty(Request["t"]))
                {//控制操作按钮。。看到 不一定能 编辑、编排、删除
                    string idlist = ",";
                    //审核 栏目id
                    if (mmodel.Quickcheck.Split(';').Length > 1)//判断自审核，权限---//添加栏目时，自动有授权
                    {
                        if (!(mmodel.IsSuperManager || mmodel.Quickcheck.Split(';')[1] == "*"))
                        {
                            AuthService aService = new AuthService();
                            DataTable aTable = aService.GetAllRightByAuthID(mmodel.Companyid, mmodel.Userid, 5, 0);

                            foreach (DataRow aRow in aTable.Rows)//获取 授权给用户的栏目
                            {
                                if (!idlist.Contains("," + aRow["itemid"].ToString() + ","))
                                {
                                    idlist = idlist + aRow["itemid"].ToString() + ",";
                                }

                            }

                        }
                        else
                        {
                            idlist += "all";//所有栏目
                        }
                    }
                    else
                    {
                        idlist = ",";
                        if (!mmodel.IsSuperManager)
                        {

                            AuthService aService = new AuthService();
                            DataTable aTable = aService.GetAllRightByAuthID(mmodel.Companyid, mmodel.Userid, 5, 0);
                            foreach (DataRow aRow in aTable.Rows)
                            {
                                if (!idlist.Contains("," + aRow["itemid"].ToString() + ","))
                                {
                                    idlist = idlist + aRow["itemid"].ToString() + ",";
                                }
                            }
                        }
                        else
                        {
                            idlist += "all";
                        }
                    }
                    checkIDs.Value = "," + idlist;//用户能够审核的  栏目ID ----（用户不是超级管理员，也不能管理所有栏目）
                    idlist = ",";
                    if (mmodel.Quickcheck.Split(';').Length > 1)
                    {//添加用户时：Quickcheck 默认 ;;;16个;分号
                        if (!(mmodel.IsSuperManager || mmodel.Quickcheck.Split(';')[1] == "*"))
                        {//1.‘栏目编排’、1.‘节目单编排’==2.‘自编排管理’==
                            //有1.并且有2. 只能看授权的栏目、节目单。。//有1.没有2. 能看所有的栏目、节目单
                            // if (DEncrypt.Andhexstring(mmodel.Rightstring, CommonRight.RIGHT_C_SelfSubjectitem) == CommonRight.RIGHT_C_SelfSubjectitem)//用户有‘自编排管理’的权限： 只能管理自己的栏目、节目单。 但是 还是有授权的栏目、节目单
                            // {//用户添加栏目、节目单时，自动拥有管理的权限(自动授权)
                            // qmodel.UserID = mmodel.Userid.ToString();//自己的栏目、节目单。
                            // 自己的栏目节目单： 在添加时自动授权了。。todo..
                            AuthService aService = new AuthService();
                            //应该在显示页面、后台判断，==有'自编排'，自己的和授权的栏目就显示 --编排按钮。否则不显示编排按钮。。。
                            DataTable aTable = aService.GetAllRightByAuthID(mmodel.Companyid, mmodel.Userid, 5, 0);
                            foreach (DataRow aRow in aTable.Rows)
                            {//授权的栏目、节目单
                                if (!idlist.Contains("," + aRow["itemid"].ToString() + ","))
                                {
                                    idlist = idlist + aRow["itemid"].ToString() + ",";
                                }
                            }
                            //if (idlist.Length > 0)
                            //{
                            //    idlist = idlist.Substring(0, idlist.Length - 1);
                            //}
                            // }//else 不用管。不会有‘编排菜单’

                        }
                        else
                        {
                            idlist += "all";
                        }
                    }
                    else
                    {
                        if (!mmodel.IsSuperManager)
                        {
                            idlist = ",";
                            //if (DEncrypt.Andhexstring(mmodel.Rightstring, CommonRight.RIGHT_C_SelfSubjectitem) == CommonRight.RIGHT_C_SelfSubjectitem)
                            //{//页面没有这个权限？？？
                            //qmodel.UserID = mmodel.Userid.ToString();
                            AuthService aService = new AuthService();
                            DataTable aTable = aService.GetAllRightByAuthID(mmodel.Companyid, mmodel.Userid, 5, 0);
                            foreach (DataRow aRow in aTable.Rows)
                            {
                                if (!idlist.Contains("," + aRow["itemid"].ToString() + ","))
                                {
                                    idlist = idlist + aRow["itemid"].ToString() + ",";
                                }
                            }
                            //if (idlist.Length > 0)
                            //{
                            //    idlist = idlist.Substring(0, idlist.Length - 1);
                            //}
                            //}

                        }
                        else
                        {
                            idlist += "all";
                        }
                    }
                    arrangeIDs.Value = "," + idlist;//用户能够 编排的  栏目ID ----（用户不是超级管理员，也不能管理所有栏目）




                    int type = Convert.ToInt32(Request["t"]);
                    program_list_hid_type.Value = type.ToString();
                    if (type == 0 || type == 5)// || type == 5  //0 列表、添加， 5编辑节目单
                    {
                        if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menu))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 1)//节目单审核
                    {
                        if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_MenuItemCheck))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 2)//节目单编排
                    {

                        if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Menuitem1) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfSubjectitem) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu)))
                        {
                           // Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 3)//节目单编排审核
                    {
                        if (!(cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_PublistCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfPublishCheck) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu)))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
                    }
                    else if (type == 4)//终端添加节目单
                    {
                        if (!cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                        {
                            Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
                        }
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
            else
            {
                Page.RegisterStartupScript("loginTimeOut", "<script>LoginTimeOut();</script>");
            }
        }
    }
}