using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web.company.program
{
    public partial class FullScreenView : System.Web.UI.Page
    {
        public string layid;
        protected void Page_Load(object sender, EventArgs e)
        {
    //            <input type="hidden" id="program_full_itemid" runat="server" />
    //<input type="hidden" id="program_full_sourceid" runat="server" />
    //<input type="hidden" id="program_full_layoutid" runat="server" />
    //<input type="hidden" id="program_full_window" runat="server" />
    //<input type="hidden" id="program_full_layposition" runat="server" />
           
            program_full_layoutid.Value = Request["lid"];
            program_full_window.Value = Request["w"];
            program_full_layposition.Value = Request["lp"];
            layid = Request["lid"];
            program_full_menuid.Value = Request["mid"];
            program_full_contenttype.Value = Request["ct"];
            program_full_sourceid.Value = Request["sid"];
            program_full_tempid.Value = Request["temp"];
        }
    }
}