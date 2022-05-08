using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.company.program
{
    public partial class thumbpreview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string thumb = Request["thumb"];
            string contenttype = Request["ct"];
            if (thumb != "")
            {
                div_preview.InnerHtml = "<img src=\"" + thumb + "2.jpg\" style=\"width:100%;height:100%;\" />";
            }
            else
            {
                div_preview.InnerHtml = "<img src=\"/images/img/default_" + contenttype + "_2.png\" style=\"width:100%;height:100%;\" />";
            }
        }
    }
}