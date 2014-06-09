using System.Web.UI;
using System.Web.UI.WebControls;
using Infragistics.WebUI.WebDataInput;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for EPDateTimeBox.
	/// </summary>
	public class OWWebDateTimeEdit : WebDateTimeEdit, IEPWebControl
	{

		/// <summary>
		/// Campo para selecção da data
		/// </summary>
		private OWWebDateChooser DateChooser;

		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebDateTimeEdit()
		{
			//-----------------------------------------------------------
			// Inicializar o objecto do tipo OWWebDateChooser do controlo
			//-----------------------------------------------------------
			DateChooser = new OWWebDateChooser();
		}

		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			this.Value = null;
		}

		/// <summary>
		/// Indica se é adicionado um campo para edição da hora e minuto
		/// </summary>
		public bool ShowDateChooser
		{
			get
			{
				object obj = this.ViewState["ShowDateChooser"];			
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["ShowDateChooser"] = value;
			}
		}

		/// <summary>
		/// Tamanho do campo DateChooser
		/// </summary>
		public Unit DateChooserWidth
		{
			get
			{
				object obj = this.ViewState["DateChooserWidth"];			
				return obj == null ? new Unit(100, UnitType.Pixel) : (Unit)obj;
			}
			set
			{
				this.ViewState["DateChooserWidth"] = value;
			}
		}

		/// <summary>
		/// Criação dos controlos na página
		/// </summary>
		protected override void CreateChildControls()
		{
			this.DateChooser = new OWWebDateChooser();
	
			this.DateChooser.ID = this.ID + "DateChooser";

			this.DateChooser.Width = this.DateChooserWidth;

			this.DateChooser.Visible = this.ShowDateChooser;

			this.DateChooser.ReadOnly = this.ReadOnly;

			this.ClientSideEvents.ValueChange = "OnValueChange";

			this.Controls.Add(this.DateChooser);

			//------------------------------------------------------------
			// Definição dos eventos do DateChooser
			//------------------------------------------------------------
			this.SetDateChooserEvent();

			base.CreateChildControls ();
		}		
		
		/// <summary>
		/// Implementação do método render
		/// </summary>
		/// <param name="output"></param>
		protected override void  Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Definição das classes
			//------------------------------------------------------------
			base.CssClass = base.ReadOnly ? "OWTextBoxReadOnly" : "OWTextBox";

			//------------------------------------------------------------
			// Atribuição de valor ao DateChooser
			//------------------------------------------------------------
			this.DateChooser.Value = this.Value;

			//------------------------------------------------------------
			// Render dos controlos
			//------------------------------------------------------------
			output.Write("<table border=0 cellpadding=0 cellspacing=0><tr><td>");

			this.DateChooser.RenderControl(output);

			output.Write("</td><td>&nbsp;</td><td>");

			base.Render(output);

			output.Write("</td></tr></table>");
		}

		/// <summary>
		/// Define o evento cliente para selecção de uma data no DateChooser
		/// </summary>
		private void SetDateChooserEvent()
		{
			string functionName = this.DateChooser.ID + "OnValueChanged";

			this.DateChooser.ClientSideEvents.ValueChanged = functionName; 

			string script; 

			script = "<script language=\"javascript\" type=\"text/javascript\">"; 
			
			script += "function " + functionName + "(oDateChooser, newValue, oEvent){"; 
			
			script += "if (newValue == null) dt = null; else{";

			script += "var dt = igedit_getById('" + this.ClientID + "').getDate();";

			script += "if (dt == null) dt = new Date(0, 0, 0, 0, 0, 0, 0);";
			
			script += "dt.setUTCFullYear(newValue.getUTCFullYear());";
			script += "dt.setUTCMonth(newValue.getUTCMonth());";
			script += "dt.setUTCDate(newValue.getUTCDate());}";
			
			script += "igedit_getById('" + this.ClientID + "').setDate(dt);";

			script += "}</script>"; 

			if (!this.Page.IsClientScriptBlockRegistered(functionName))
			{
				this.Page.RegisterClientScriptBlock(functionName, script); 
			}
		}

	}
}
