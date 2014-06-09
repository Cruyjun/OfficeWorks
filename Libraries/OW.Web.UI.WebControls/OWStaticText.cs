using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Controlo de texto est�tico
	/// </summary>
	public class OWStaticText : Label
	{
		
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWStaticText(){}

		/// <summary>
		/// Construtor da classe passando como par�metro o texto
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
		/// Implementa��o da propriedade Text
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
		/// Implementa��o do m�todo render do controlo
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Defini��o da css para a Label
			//------------------------------------------------------------
			base.CssClass = "OWStaticText";

			//------------------------------------------------------------
			// Render do conte�do do controlo
			//------------------------------------------------------------
			base.Render(output);
		}

	}
}
