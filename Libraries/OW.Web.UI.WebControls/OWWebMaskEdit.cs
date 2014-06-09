
namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for EPPercentBox.
	/// </summary>
	public class OWWebMaskEdit : Infragistics.WebUI.WebDataInput.WebMaskEdit, IEPWebControl
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebMaskEdit(){}

		/// <summary>
		/// Limpa o conte�do do campo
		/// </summary>
		public void ClearData()
		{
			this.Value = null;
		}

		/// <summary>
		/// Indica se a propriedade Value devolve Null no caso do Texto serem espa�os
		/// </summary>
		public bool TrimToNull
		{
			get
			{
				object obj = this.ViewState["TrimToNull"];				
				return obj == null ? true : (bool)obj;
			}
			set
			{
				this.ViewState["TrimToNull"] = value;
			}
		}

		/// <summary>
		/// Implementa��o da propriedade Value
		/// </summary>
		new public string Value
		{
			get
			{
				if (this.TrimToNull)
				{
					if (base.Value.ToString().Trim() == string.Empty)
					{
						return Common.Configuration.NullValueString;
					}
				}

				return base.Value.ToString();
			}
			set
			{
				base.Value = value;
			}
		}

		/// <summary>
		/// Implementa��o do m�todo render
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(System.Web.UI.HtmlTextWriter output)
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
