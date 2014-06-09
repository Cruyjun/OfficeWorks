using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Controlo de texto estático
	/// </summary>
	public class OWStaticText : Label
	{
		
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWStaticText(){}

		/// <summary>
		/// Construtor da classe passando como parâmetro o texto
		/// </summary>
		public OWStaticText(object Value)
		{
			this.Value = Value;
		}

		/// <summary>
		/// Valor do controlo
		/// </summary>
		public object Value
		{
			get
			{
				return this.ViewState["Value"];				
			}
			set
			{
				this.Text = value == null ? string.Empty : value.ToString();
				this.ViewState["Value"] = value;
			}
		}

		/// <summary>
		/// Implementação da propriedade Text
		/// </summary>
		public override string Text
		{
			get
			{
				return base.Text;
			}
			set
			{
				base.Text = value;

				this.ViewState["Value"] = value;
			}
		}

		/// <summary>
		/// Implementação do método render do controlo
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Definição da css para a Label
			//------------------------------------------------------------
			base.CssClass = "OWStaticText";

			//------------------------------------------------------------
			// Render do conteúdo do controlo
			//------------------------------------------------------------
			base.Render(output);
		}

	}
}
