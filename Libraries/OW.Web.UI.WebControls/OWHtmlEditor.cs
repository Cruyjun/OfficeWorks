using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWHtmlEditor.
	/// </summary>
	public class OWHtmlEditor : WebControl ,INamingContainer 
	{

		private HtmlTextArea TextArea;
		private HtmlGenericControl DivArea;

		public override bool Enabled
		{
			get
			{
                return base.Enabled;
			}
			set
			{
				if (!value)
				{
				}
				else
				{
					this.DivArea.Attributes.Add("contenteditable","true" );
					this.DivArea.Attributes.Add("unselectable","off");
				}
				base.Enabled = value;
			}
		}

	/*	/// <summary>
		/// Indica se ContextMenuPlugin está disponível
		/// </summary>
		private bool _ContextMenuPlugin;
		/// <summary>
		/// Modo do controlo da acção Escolher e Fechar 
		/// </summary>
		public bool ContextMenuPlugin
		{
			get 
			{
				//------------------------------------------------------------------------
				// Caso ocorra erro na leitura do ViewState, então o modo escolhido será false
				//------------------------------------------------------------------------
				try
				{
					_ContextMenuPlugin = false;
					_ContextMenuPlugin = (bool)this.ViewState[string.Format("{0}.ContextMenuPlugin", this.UniqueID)]; 
				}
				catch{}

				return _ContextMenuPlugin;
			}
			set 
			{
				_ContextMenuPlugin = value;

				this.ViewState.Add(string.Format("{0}.ContextMenuPlugin", this.UniqueID), _ContextMenuPlugin);

				this.Controls.Clear();

				this.ChildControlsCreated = false;

				this.EnsureChildControls();

			}
		}
*/
		/// <summary>
		/// Indica se ContextMenuPlugin está disponível
		/// </summary>
		private bool _Disabled;
		/// <summary>
		/// Modo do controlo da acção Escolher e Fechar 
		/// </summary>
		public bool Disabled
		{
			get 
			{
				//------------------------------------------------------------------------
				// Caso ocorra erro na leitura do ViewState, então o modo escolhido será false
				//------------------------------------------------------------------------
				try
				{
					_Disabled = false;
					_Disabled = (bool)this.ViewState[string.Format("{0}.Disabled", this.UniqueID)]; 
				}
				catch{}

				return _Disabled;
			}
			set 
			{
				_Disabled = value;

				this.ViewState.Add(string.Format("{0}.Disabled", this.UniqueID), _Disabled);

				this.Controls.Clear();

				this.ChildControlsCreated = false;

				this.EnsureChildControls();
				try
				{
					_Text = "";
					_Text = (string)this.ViewState[string.Format("{0}.Text", this.UniqueID)]; 
				}
				catch{}
				this.TextArea.Value=_Text;
				this.DivArea.InnerHtml=_Text;

			}
		}

		private string _Text;
		public string Text
		{
			get 
			{
				//------------------------------------------------------------------------
				// Caso ocorra erro na leitura do ViewState, então o modo escolhido será false
				//------------------------------------------------------------------------
				this.EnsureChildControls();
				if (!this.Disabled)
				{
					_Text = this.TextArea.InnerText;
					
					this.ViewState.Add(string.Format("{0}.Text", this.UniqueID), _Text);
				}
				return _Text;
			}
			set 
			{
				this.EnsureChildControls();
				this.TextArea.Value =value;
				this.DivArea.InnerHtml = value;
				_Text = value;
				this.ViewState.Add(string.Format("{0}.Text", this.UniqueID), _Text);
			}
		}
		public OWHtmlEditor()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		protected override void CreateChildControls()
		{
			
			TextArea = new HtmlTextArea();
			DivArea = new HtmlGenericControl("DIV");
			this.DivArea.Attributes.Add("contenteditable","false" );
			this.DivArea.Attributes.Add("unselectable","on");
			this.TextArea.Style.Add("Width", this.Width.ToString());
			this.TextArea.Style.Add("Height", this.Height.ToString());
			this.TextArea.ID="TextArea";

			if (this.Disabled)
				this.Controls.Add(this.DivArea);
			else
				this.Controls.Add(this.TextArea);

			if(!this.Page.IsClientScriptBlockRegistered("TextAreaScript1"))
			{
				this.Page.RegisterClientScriptBlock("TextAreaScript1","<script type='text/javascript'>  _editor_url = '/aspnet_client/OWWebControls/htmlarea/';   _editor_lang = 'en';</script>");
			}
			if(!this.Page.IsClientScriptBlockRegistered("TextAreaScript2"))
			{
				this.Page.RegisterClientScriptBlock("TextAreaScript2","<script type='text/javascript' src='/aspnet_client/OWWebControls/htmlarea/htmlarea.js'></script>");
			}
			if(!this.Page.IsClientScriptBlockRegistered("TextAreaScript3"))
			{
				this.Page.RegisterClientScriptBlock("TextAreaScript3","<script type='text/javascript' src='/aspnet_client/OWWebControls/htmlarea/gasAddon.js'></script>");
			}
		}
		


		protected override void OnPreRender(EventArgs e)
		{
			if (!this.Disabled)
			{
				this.Page.RegisterClientScriptBlock("TextAreaScript_" +  this.TextArea.ClientID,"<script type='text/javascript' defer='1'> initEditor('" + this.TextArea.ClientID + "');</script>");
			}
			else
			{
				this.Page.RegisterClientScriptBlock("TextAreaScript_" +  this.TextArea.ClientID,"<script type='text/javascript' defer='1'></script>");
			}

			base.OnPreRender (e);
		}



	}
}
