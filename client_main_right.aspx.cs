using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HuiFeng.BLL;
using HuiFeng.Common;
using HuiFeng.Model;
using Maticsoft.Common.DEncrypt;

namespace Web.company.client
{
    public partial class client_main_right : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CompanyManagerService cmService = new CompanyManagerService();
            CompanyManager mmodel = cmService.GetLoginInfo();
            if (mmodel.IsOnLine == 1)
            {
                if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_RemoteCommands))
                {
                    int dlevel = 0;
                    int clientid = 0;
                    client_main_right_dlevel.Value = "0";
                    if (!string.IsNullOrEmpty(Request["dlv"]))
                    {
                        client_main_right_dlevel.Value = Request["dlv"];
                        dlevel = Convert.ToInt32(Request["dlv"]);
                    }
                    client_main_right_clientid.Value = "0";
                    if (!string.IsNullOrEmpty(Request["gid"]) && Request["gid"] != "undefined")
                    {
                        client_main_right_clientid.Value = Request["gid"];
                        if (Request["gid"].Contains("_"))
                        {
                            string[] ids = Request["gid"].Split('_');
                            clientid = Convert.ToInt32(ids[ids.Length - 1]);
                        }
                        else
                        { clientid = Convert.ToInt32(Request["gid"]); }
                    }
                    string clientmark = Request["mark"];
                    client_main_right_mark.Value = Request["mark"];

                    StringBuilder btnmenuHtml = new StringBuilder();
                    StringBuilder operateBtnList = new StringBuilder();
                    StringBuilder operateBtnList2 = new StringBuilder();
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_Client) || cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_SelfClient))
                    {
                        btnmenuHtml.Append("<li data-type=\"0\" data-isshow=\"1\" ><a id=\"myClientmanager\" href=\"javascript:void(0)\">终端管理</a></li>");
                        string clientname = "><a id='myclientroot' href='javascript:void(0)'>播放终端根目录</a>";
                        string currName = ""; string oldName = "";
                        for (int i = 1; i < clientmark.Split('_').Length; i++)
                        {
                            if (i < GlobalAtt.ClientLevel)//显示到3级终端组，不显示终端，避免导航条过长//i <= GlobalAtt.ClientLevel
                            {
                                oldName = GetClientName(mmodel.Companyid, Convert.ToInt32(clientmark.Split('_')[i]));
                                currName = oldName;
                                //一级终端组，最后一级终端：显示完整名称。中间的 显示4个字符+...加title
                                if (i > 1 && i < clientmark.Split('_').Length - 1)//
                                {
                                    if (oldName.Length > 4)
                                    {
                                        currName = oldName.Substring(0, 4) + "...";
                                        currName = "<a href=\"javascript:void(0)\" title=\"" + oldName + "\">" + currName + "</a>";
                                    }
                                    else
                                    {
                                        currName = "<a href=\"javascript:void(0)\">" + currName + "</a>";
                                    }
                                }
                                else
                                {
                                    currName = "<a href=\"javascript:void(0)\">" + currName + "</a>";
                                }

                                clientname = clientname + ">" + currName;
                            }
                        }
                        client_main_right_pageMap.Value = clientname;
                        if (dlevel <= GlobalAtt.ClientLevel)
                        {

                            if (dlevel == 0)
                            {
                                operateBtnList.Append("<span class=\"inp_btn\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_addbtn\" title=\"添加一级终端组\" class=\"client_tianjia\"><b></b><span>添加一级终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_refreshList\" title=\"刷新媒体播放终端列表\" class=\"client_shuaxinf\" style=\"padding-left:30px;\"><b></b><span>刷新媒体播放终端列表</span></a></span>");
                                //operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_edit\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑组内终端</span></a></span>");
                                //operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_delbtn\" class=\"client_shanchu\" style=\"padding-left:25px;\"><b></b><span>删除组内终端</span></a></span>");
                            }
                            if (dlevel == 1 && dlevel != GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList.Append("<span class=\"inp_btn\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_addbtn\" title=\"添加二级终端组\" class=\"client_tianjia\"><b></b><span>添加二级终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_edit\" title=\"编辑终端组\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_delbtn\" title=\"删除该终端组\" class=\"client_shanchu\" style=\"padding-left:30px;\"><b></b><span>删除该终端组</span></a></span>");
                                // operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_edit\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑组内终端</span></a></span>");
                                // operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_delbtn\" class=\"client_shanchu\" style=\"padding-left:25px;\"><b></b><span>删除组内终端</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_refreshbtn\" title=\"刷新媒体播放终端状态\" class=\"client_shuaxinf\" style=\"padding-left:30px;\"><b></b><span>刷新媒体播放终端状态</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_timesbtn\" title=\"设置开关机时间\" class=\"client_shezhisj\" style=\"padding-left:30px;\"><b></b><span>设置开关机时间</span></a></span>");
                            }
                            if (dlevel == 2 && dlevel != GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList.Append("<span class=\"inp_btn\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_addbtn\" title=\"添加三级终端组\" class=\"client_tianjia\"><b></b><span>添加三级终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_edit\" title=\"编辑终端组\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_delbtn\" title=\"删除该终端组\" class=\"client_shanchu\" style=\"padding-left:30px;\"><b></b><span>删除该终端组</span></a></span>");
                                //operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_edit\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑组内终端</span></a></span>");
                                // operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_delbtn\" class=\"client_shanchu\" style=\"padding-left:25px;\"><b></b><span>删除组内终端</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_refreshbtn\" title=\"刷新媒体播放终端状态\" class=\"client_shuaxinf\" style=\"padding-left:30px;\"><b></b><span>刷新媒体播放终端状态</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_timesbtn\" title=\"设置开关机时间\" class=\"client_shezhisj\" style=\"padding-left:30px;\"><b></b><span>设置开关机时间</span></a></span>");
                            }
                            /*//四级终端组
                            if (dlevel == 3 && dlevel != GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList.Append("<span class=\"inp_btn\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_addbtn\" title=\"添加四级终端组\" class=\"client_tianjia\"><b></b><span>添加四级终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_edit\" title=\"编辑终端组\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_groupinfo_delbtn\" title=\"删除该终端组\" class=\"client_shanchu\" style=\"padding-left:30px;\"><b></b><span>删除该终端组</span></a></span>");
                                //operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_edit\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑组内终端</span></a></span>");
                                // operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_delbtn\" class=\"client_shanchu\" style=\"padding-left:25px;\"><b></b><span>删除组内终端</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_refreshbtn\" title=\"刷新媒体播放终端状态\" class=\"client_shuaxinf\" style=\"padding-left:30px;\"><b></b><span>刷新媒体播放终端状态</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_timesbtn\" title=\"设置开关机时间\" class=\"client_shezhisj\" style=\"padding-left:30px;\"><b></b><span>设置开关机时间</span></a></span>");
                            }
                            */


                            if (dlevel == GlobalAtt.ClientLevel - 1)//终端组有实体、虚拟的。--虚拟组的终端 只能从组中删除
                            {//'删除组内终端' 按钮，(批量删除)。 --只有点击 3 级终端组，这个按钮才会显示.。。。。
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"编辑终端组\" id=\"client_groupinfo_edit\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑终端组</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"删除该终端组\" id=\"client_groupinfo_delbtn\" class=\"client_shanchu\" style=\"padding-left:30px;\"><b></b><span>删除该终端组</span></a></span>");
                                //operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" id=\"client_edit\" class=\"client_bianji\" style=\"padding-left:30px;\"><b></b><span>编辑组内终端</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"删除该终端组\" id=\"client_delbtn\" class=\"client_shanchu\" style=\"padding-left:30px;\"><b></b><span>删除组内终端</span></a></span>");

                                operateBtnList.Append("<span class=\"inp_btn\"><a href=\"javascript:void(0)\" title=\"添加终端\" id=\"client_groupinfo_clientaddbtn\" class=\"client_tianjia\"><b></b><span>添加终端</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn\"><a href=\"javascript:void(0)\" title=\"批量引入终端\" id=\"client_groupinfo_quickaddbtn\"><b></b><span>批量引入终端</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"刷新媒体播放终端状态\" id=\"client_refreshbtn\" class=\"client_shuaxinf\" style=\"padding-left:30px;\"><b></b><span>刷新媒体播放终端状态</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"设置开关机时间\" id=\"client_timesbtn\" class=\"client_shezhisj\" style=\"padding-left:30px;\"><b></b><span>设置开关机时间</span></a></span>");
                            }
                            if (dlevel == GlobalAtt.ClientLevel)
                            {
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"刷新媒体播放终端状态\" id=\"client_refreshbtn\" class=\"client_shuaxinf\" style=\"padding-left:30px;\"><b></b><span>刷新媒体播放终端状态</span></a></span>");
                                operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"设置开关机时间\" id=\"client_timesbtn\" class=\"client_shezhisj\" style=\"padding-left:30px;\"><b></b><span>设置开关机时间</span></a></span>");
                            }
                        }
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_RemoteCommands))
                    {// 是不是应该  点击 三级终端组/终端 时，才会有。。。。？？？
                        operateBtnList.Append("<span class=\"inp_btn client_edit\"><a href=\"javascript:void(0)\" title=\"发送指令\" id=\"client_groupinfo_sendCmd\" style=\"padding-left:25px;\"><b></b><span>发送指令</span></a></span>");
                    }
                    if (cmService.IsShouQuan(mmodel, 0, CommonRight.RIGHT_C_ClientMenu))
                    {

                        btnmenuHtml.Append("<li data-type=\"1\" data-isshow=\"0\" ><a id=\"myMenuSend\" href=\"javascript:void(0)\" title=\"节目单分发管理\">节目单分发管理</span></a></li>");
                        if (!string.IsNullOrEmpty(Request["gid"]) || !string.IsNullOrEmpty(Request["mark"]))
                        { //点击 终端  Request["mark"] 为空
                            operateBtnList2.Append("<span class=\"inp_btn addbtn\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;\" title=\"添加节目单\" id=\"client_groupinfo_sendMenu\"><b style=\"left:34px;\"></b><span>添加节目单</span></a></span>");
                        }
                        if (dlevel <= GlobalAtt.ClientLevel)
                        {
                            if (dlevel == 0)
                            {
                                operateBtnList2.Append("<span class=\"inp_btn start\"><a href=\"javascript:void(0)\" style=\"padding-left:25px;position:relative;\" title=\"开始/继续全部节目单分发\" onclick=\"client_groupinfo_sendmenucmd(5,56)\"><b style=\"left:5px;\"></b><span>开始/继续全部节目单分发</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn resetbtn\"><a href=\"javascript:void(0)\" style=\"padding-left:25px;position:relative;\" title=\"重新开始全部节目单分发\" onclick=\"client_groupinfo_sendmenucmd(5,57)\"><b style=\"left:5px;\"></b><span>重新开始全部节目单分发</span></a></span>");
                            }
                            if (dlevel == 1 && dlevel != GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList2.Append("<span class=\"inp_btn shengji\"><a href=\"javascript:void(0)\" style=\"padding-left:28px;position:relative;\" title=\"分发系统升级文件\" onclick=\"client_groupinfo_sendmenucmd(7,0)\"><b style=\"left:5px;\"></b><span>分发系统升级文件</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn start\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"启动组节目单分发\" onclick=\"client_groupinfo_sendmenucmd(0,1)\"><b style=\"left:5px;\"></b><span>启动组节目单分发</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn tingzhi\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"停止节目单分发\" onclick=\"client_groupinfo_sendmenucmd(1,1)\"><b style=\"left:5px;\"></b><span>停止节目单分发</span></a></span>");
                            }
                            if (dlevel == 2 && dlevel != GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList2.Append("<span class=\"inp_btn shengji\"><a href=\"javascript:void(0)\" style=\"padding-left:28px;position:relative;\" title=\"分发系统升级文件\" onclick=\"client_groupinfo_sendmenucmd(7,0)\"><b style=\"left:5px;\"></b><span>分发系统升级文件</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn start\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"启动组节目单分发\" onclick=\"client_groupinfo_sendmenucmd(0,1)\"><b style=\"left:5px;\"></b><span>启动组节目单分发</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn tingzhi\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"停止节目单分发\" onclick=\"client_groupinfo_sendmenucmd(1,1)\"><b style=\"left:5px;\"></b><span>停止节目单分发</span></a></span>");
                            }


                            /*//四级终端组
                            if (dlevel == 3 && dlevel != GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList2.Append("<span class=\"inp_btn shengji\"><a href=\"javascript:void(0)\" style=\"padding-left:28px;position:relative;\" title=\"分发系统升级文件\" onclick=\"client_groupinfo_sendmenucmd(7,0)\"><b style=\"left:5px;\"></b><span>分发系统升级文件</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn start\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"启动组节目单分发\" onclick=\"client_groupinfo_sendmenucmd(0,1)\"><b style=\"left:5px;\"></b><span>启动组节目单分发</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn tingzhi\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"停止节目单分发\" onclick=\"client_groupinfo_sendmenucmd(1,1)\"><b style=\"left:5px;\"></b><span>停止节目单分发</span></a></span>");
                            }
                            */

                            if (dlevel == GlobalAtt.ClientLevel - 1)
                            {
                                operateBtnList2.Append("<span class=\"inp_btn shengji\"><a href=\"javascript:void(0)\" style=\"padding-left:28px;position:relative;\" title=\"分发系统升级文件\" onclick=\"client_groupinfo_sendmenucmd(7,0)\"><b style=\"left:5px;\"></b><span>分发系统升级文件</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn start\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"启动组节目单分发\" onclick=\"client_groupinfo_sendmenucmd(0,1)\"><b style=\"left:5px;\"></b><span>启动组节目单分发</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn tingzhi\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"停止节目单分发\" onclick=\"client_groupinfo_sendmenucmd(1,1)\"><b style=\"left:5px;\"></b><span>停止节目单分发</span></a></span>");
                            }
                            if (dlevel == GlobalAtt.ClientLevel)
                            {
                                operateBtnList2.Append("<span class=\"inp_btn shengji\"><a href=\"javascript:void(0)\" style=\"padding-left:28px;position:relative;\" title=\"分发系统升级文件\" onclick=\"client_groupinfo_sendmenucmd(7,0)\"><b style=\"left:5px;\"></b><span>分发系统升级文件</span></a></span>");
                                operateBtnList2.Append("<span class=\"inp_btn start\"><a href=\"javascript:void(0)\"  style=\"padding-left:30px;position:relative;\"  title=\"启动节目单分发\" onclick=\"client_groupinfo_sendmenucmd(0,1)\"><b style=\"left:5px;\"></b><span>启动节目单分发</span></a></span>");//(0,1)
                                operateBtnList2.Append("<span class=\"inp_btn resetbtn\"><a href=\"javascript:void(0)\"  style=\"padding-left:30px;position:relative;\" title=\"重启节目单分发\" onclick=\"client_groupinfo_sendmenucmd(0,2)\"><b style=\"left:5px;\"></b><span>重启节目单分发</span></a></span>");//(0,1)
                                operateBtnList2.Append("<span class=\"inp_btn tingzhi\"><a href=\"javascript:void(0)\" style=\"padding-left:30px;position:relative;\" title=\"停止节目单分发\" onclick=\"client_groupinfo_sendmenucmd(1,1)\"><b style=\"left:5px;\"></b><span>停止节目单分发</span></a></span>");
                            }
                        }
                    }
                    client_main_right_menu.InnerHtml = btnmenuHtml.ToString();
                    client_groupinfo_btnMgr.InnerHtml = operateBtnList.ToString();
                    client_groupinfo_btnMenu.InnerHtml = operateBtnList2.ToString();

                }
                else
                {
                    Response.Redirect("/login.aspx");
                }
            }
            else
            {
                Response.Redirect("/login.aspx");
            }
        }
        public string GetClientName(string companyid, int clientid)
        {
            string result = "";
            result = new ClientService().GetOneClient(companyid, clientid).Rows[0]["clientname"].ToString();
            //result = "<a href=\"javascript:void(0)\">" + new ClientService().GetOneClient(companyid, clientid).Rows[0]["clientname"].ToString() + "</span></a>";
            return result;
        }
        public bool IsSq(CompanyManager mmodel, string clientmark)
        {
            bool issql = false;
            string sqlist = string.Empty;
            ClientService cService = new ClientService();
            if (mmodel.IsSuperManager)
            {
                issql = true;
            }
            else
            {
                if (mmodel.Quickcheck.Split(';').Length > 2)
                {
                    if (mmodel.Quickcheck.Split(';')[2] == "*")
                    {
                        issql = true;
                    }
                    else
                    {
                        DataTable authtable = new DataTable();
                        bool isself = false;
                        if (DEncrypt.Andhexstring(mmodel.Rightstring, CommonRight.RIGHT_C_SelfMenuItem) == CommonRight.RIGHT_C_SelfMenuItem)
                        {
                            isself = true;
                        }
                        authtable = cService.GetClientData(mmodel.Companyid, mmodel.Userid, Convert.ToInt32(mmodel.DeptID), isself);
                        foreach (DataRow row in authtable.Rows)
                        {
                            sqlist += row["clientid"].ToString() + ",";
                        }
                        foreach (string mark in clientmark.Split('_'))
                        {
                            if (sqlist.Contains(mark) && mark != "")
                            {
                                issql = true;
                            }
                        }
                    }
                }
                else
                {
                    DataTable authtable = new DataTable();
                    bool isself = false;
                    if (DEncrypt.Andhexstring(mmodel.Rightstring, CommonRight.RIGHT_C_SelfMenuItem) == CommonRight.RIGHT_C_SelfMenuItem)
                    {
                        isself = true;
                    }
                    authtable = cService.GetClientData(mmodel.Companyid, mmodel.Userid, Convert.ToInt32(mmodel.DeptID), isself);
                    foreach (DataRow row in authtable.Rows)
                    {
                        sqlist += row["clientid"].ToString() + ",";
                    }
                    if (clientmark != "")
                    {
                        foreach (string mark in clientmark.Split('_'))
                        {
                            if (sqlist.Contains(mark))
                            {
                                issql = true;
                            }
                        }
                    }
                }
            }
            return issql;
        }
    }
}