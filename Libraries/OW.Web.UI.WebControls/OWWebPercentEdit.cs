
namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for EPPercentBox.
	/// </summary>
	public class OWWebPercentEdit : Infragistics.WebUI.WebDataInput.WebPercentEdit, IEPWebControl
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebPercentEdit(){}

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
