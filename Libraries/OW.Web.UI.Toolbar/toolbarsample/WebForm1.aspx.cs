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
	/// Summary description for WebForm1.
	/// </summary>
	public class WebForm1 : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Button Button1;
		protected OW.Web.UI.Toolbar.WebToolbarBack WebToolbarBack1;
		protected Infragistics.WebUI.UltraWebToolbar.UltraWebToolbar UltraWebToolbar2;
		protected System.Web.UI.WebControls.ValidationSummary ValidationSummary1;
		protected System.Web.UI.WebControls.TextBox TextBox1;
		protected System.Web.UI.WebControls.RequiredFieldValidator RequiredFieldValidator1;
		protected System.Web.UI.WebControls.Button Button2;
		protected Infragistics.WebUI.WebDataInput.WebTextEdit WebTextEdit1;
		protected System.Web.UI.WebControls.TextBox TextBox2;
		protected Infragistics.WebUI.WebDataInput.WebTextEdit WebTextEdit2;
		protected ToolbarSample.ListAction ListAction1;
		protected ToolbarSample.ListAction ListAction2;
		protected Infragistics.WebUI.UltraWebToolbar.UltraWebToolbar UltraWebToolbar1;
	
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

		}
		#endregion

		private void Button1_Click(object sender, System.EventArgs e)
		{
			object o = this.UltraWebToolbar1;
		}

		private void WebToolbarBack1_ButtonClicked(object sender, Infragistics.WebUI.UltraWebToolbar.ButtonEvent be)
		{
			string x = null;
		}

		private void Button2_Click(object sender, System.EventArgs e)
		{
			this.WebToolbarBack1.HideBack();
		}
	}
}
