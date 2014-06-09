using System.Web.UI;
using System.Web.UI.WebControls;
using OW.Web.UI.WebControls.Common;
using Infragistics.WebUI.WebDataInput;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWTextBoxNumeric.
	/// </summary>
	public class OWWebNumericEdit : WebNumericEdit, IEPWebControl
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebNumericEdit(){}

		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			this.Value = null;
		}

		/// <summary>
		/// Valor inteiro do controlo
		/// </summary>
		new public int ValueInt
		{
			get
			{
				return this.Text.Trim() == string.Empty ? Configuration.NullValueInt32 : base.ValueInt;
			}
			set
			{
				if (value == Configuration.NullValueInt32)
				{
					this.Value = null;
				}
				else
				{
					this.Value = value;
				}
			}
		}

		/// <summary>
		/// Valor long do controlo
		/// </summary>
		new public long ValueLong
		{
			get
			{
				return this.Text.Trim() == string.Empty ? Configuration.NullValueInt64 : base.ValueLong;
			}
			set
			{
				if (value == Configuration.NullValueInt64)
				{
					this.Value = null;
				}
				else
				{
					this.Value = value;
				}
			}
		}

		/// <summary>
		/// Implementação do método render
		/// </summary>
		/// <param name="output"></param>
		protected override void  Render(HtmlTextWriter output)
		{
			if (base.ReadOnly)
			{
				base.HorizontalAlign = HorizontalAlign.Left;
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
