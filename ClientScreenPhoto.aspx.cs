using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace Web.company.client
{
    public partial class ClientScreenPhoto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //http://192.168.1.145/cgi-bin/preparefilecgi.cgi?companyid=wisepeak&maintype=5&subtype=33&groupid=3&clientid=14&merit=5&ismobile=&fordebug=&commandname=&param=||wisepeak/image/14/0711/0809.jpg
            //if (IsPostBack)
            //{
                /*string imageUrl = "/cgi-bin/preparefilecgi.cgi?";
                //imageUrl += string.Format("companyid={0}&maintype={1}&subtype={2}&groupid={3}&clientid=14&merit=5&ismobile=&fordebug=&commandname=&param=");
                string companyid = Request.QueryString["companyid"];//&charset=utf-8
                string clientid = Request.QueryString["clientid"];
                string maintype = Request.QueryString["maintype"];
                string subtype = Request.QueryString["subtype"];
                string groupid = Request.QueryString["groupid"];
                string merit = Request.QueryString["merit"];
                */
                string param = Request.QueryString["param"];
                string imageAddress = "/sharefiles/" + param.Substring(2);// "/cgi-bin/" + param.Substring(2)
                imageAddress = Server.MapPath(imageAddress);
                DateTime fileTime = File.GetLastWriteTime(imageAddress).AddMinutes(6);
                if (File.Exists(imageAddress) && fileTime >= DateTime.Now)
                {
                    
                    //if (fileTime >= DateTime.Now)//6分钟以内，直接找原来的截图
                    //{
                        //imgShow.Src = imageAddress;
                        //Response.Clear();
                        //Response.Write(imageAddress);
                        //Response.End();
                    imgAddress.Value = imageAddress.Replace("cgi-bin", "sharefiles");//图片路径 sharefiles
                    //}

                }
                else
                {//http://localhost:24956/company/client/ClientScreenPhoto.aspx?companyid=wisepeak&maintype=5&subtype=33&groupid=0&clientid=14&merit=5&ismobile=&fordebug=&commandname=&param=%7C%7Cwisepeak/image/14/1134.jpg
                    string myUrl = Request.Url.OriginalString;//Request.Url.AbsoluteUri;
                    //if (fileTime < DateTime.Now)
                    //{  ////图片不存在，或者时间超过 6 分钟， 重新获取图片。。
                        myUrl = myUrl.Replace("company/client/ClientScreenPhoto.aspx", "cgi-bin/preparefilecgi.cgi");
                        imgAddress.Value = myUrl;
                    //}
                    //else
                    //{
                    //    imgAddress.Value = imageAddress;
                    //}
                    //Response.Redirect(myUrl, true);
                }
                //Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                //Response.Cache.SetNoStore();
           // }


        }
    }
}