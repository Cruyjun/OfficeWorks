using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace ToolbarSample
{
	/// <summary>
	/// Summary description for _default.
	/// </summary>
	public class _default : System.Web.UI.Page
	{
		protected OW.Web.UI.Toolbar.Toolbar Toolbar1;
		protected OW.Web.UI.Toolbar.ToolbarButton toolbarButton1;
		protected OW.Web.UI.Toolbar.ToolbarButton toolbarButton2;
		protected OW.Web.UI.Toolbar.ToolbarButton toolbarButton3;
		protected System.Web.UI.WebControls.TextBox TextBox1;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.ValidationSummary ValidationSummary1;
		protected System.Web.UI.WebControls.Button Button1;
		protected OW.Web.UI.Toolbar.ToolbarButton toolbarButton4;
	
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.Toolbar1.ItemPostBack += new OW.Web.UI.Toolbar.ItemEventHandler(this.Toolbar1_ItemPostBack);
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion

		private void Toolbar1_ItemPostBack(OW.Web.UI.Toolbar.ToolbarItem item)
		{
			Response.Write("exec");
		}
	}
}
