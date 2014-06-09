
namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for EPCurrencyBox.
	/// </summary>
	public class OWWebCurrencyEdit : Infragistics.WebUI.WebDataInput.WebCurrencyEdit, IEPWebControl
	{
		/// <summary>
		/// Contrutor da classe
		/// </summary>
		public OWWebCurrencyEdit(){}

		/// <summary>
		/// Limpa o conte�do do campo
		/// </summary>
		public void ClearData()
		{
			this.Value = null;
		}

		/// <summary>
		/// Implementa��o do m�todo render
		/// </summary>
		/// <param name="output"></param>
		protected override void  Render(System.Web.UI.HtmlTextWriter output)
		{
			if (base.ReadOnly)
			{
				base.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Left;
				base.CssClass = "OWTextBoxReadOnly";
			}			
			else
			{
				base.CssClass = "OWTextBox";
			}

			base.Render(output);
		}

	}
}
