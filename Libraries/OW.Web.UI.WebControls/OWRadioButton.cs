using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for RadioButton.
	/// </summary>
	public class OWRadioButton : RadioButton, IEPWebControl
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWRadioButton(){}

		/// <summary>
		/// Indica se o campo está em modo de consulta
		/// </summary>
		public bool ReadOnly
		{
			get
			{
				object obj = this.ViewState["ReadOnly"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["ReadOnly"] = value;
			}
		}

		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			this.Checked = false;
		}

		/// <summary>
		/// Implementação do método Render
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			base.CssClass = "OWRadioButton";

			if (this.ReadOnly)
			{
				string CTRLStyle = string.Format("WIDTH:{0}; HEIGHT:{1}", base.Width.ToString(), base.Height.ToString());

				string CTRLText;
				string CTRLChecked;

				if (base.Checked)
					CTRLChecked = ResX.GetString("YES");
				else
					CTRLChecked = ResX.GetString("NO");

				if (base.Text != "")
					CTRLText = string.Format("{0} ({1})", base.Text, CTRLChecked);
				else
					CTRLText = CTRLChecked;

				output.Write(string.Format("<SPAN style='{0}' class='{1}'>{2}</SPAN>", CTRLStyle, CssClass, CTRLText));

			}			
			else
			{
				base.Render(output);
			}
		}
	}
}
