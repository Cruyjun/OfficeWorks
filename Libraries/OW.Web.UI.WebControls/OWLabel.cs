using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWLabel.
	/// </summary>
	public class OWLabel : Label
	{
		
		private string cssClassWarning = "OWLabelWarning";

		/// <summary>
		/// Indica se � visualizada a marca de campo obrigat�rio
		/// </summary>
		public bool Required
		{
			get
			{
				object obj = this.ViewState["Required"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["Required"] = value;
			}
		}

		/// <summary>
		/// Classe associada � indica��o de campo obrigat�rio
		/// </summary>
		public string CssClassWarning
		{
			get { return cssClassWarning; }
		}

		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWLabel(){}

		/// <summary>
		/// Construtor da classe passando a descri��o da label
		/// </summary>
		public OWLabel(string Text)
		{
			base.Text = Text;
		}

		/// <summary>
		/// Tratamento do evento render do controlo
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Defini��o da css para a Label
			//------------------------------------------------------------
			base.CssClass = "OWLabel";

			//------------------------------------------------------------
			// Render do conte�do do controlo
			//------------------------------------------------------------
			base.Render(output);

			//------------------------------------------------------------
			// Caso o campo seja obrigat�rio, adicionar um asterisco
			//------------------------------------------------------------
			if (this.Required)
			{
				output.Write("<span  class=\"" + this.CssClassWarning +  "\"> *</span>");
			}
		}
	}
}
