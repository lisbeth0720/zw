using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.company.program
{
    public partial class PrList_thumb : System.Web.UI.Page
    {
        public string layid;
        protected void Page_Load(object sender, EventArgs e)
        {
            program_thumb_layoutid.Value = Request["lid"];
            program_thumb_layposition.Value = Request["lp"];
            layid = Request["lid"];
            program_thumb_menuid.Value = Request["mid"];

        }
    }
}