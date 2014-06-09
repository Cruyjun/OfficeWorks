using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// System.Web.UI.WebControls.CheckBox extended
	/// </summary>
	public class OWCheckBox : CheckBox, IEPWebControl
	{
		
		#region Properties

		/// <summary>
		/// Indica se o campo está em modo de consulta
		/// </summary>
		public bool ReadOnly
		{
			get
			{
				return !this.Enabled;
			}
			set
			{
				this.Enabled = !value;
			}
		}

		/// <summary>
		/// Coloca o controlo sempre no estado ReadOnly independentemente do valor de ReadOnly
		/// </summary>
		public bool AlwaysReadOnly
		{
			get
			{
				object obj = this.ViewState["AlwaysReadOnly"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["AlwaysReadOnly"] = value;
			}
		}

		#endregion

		#region Overrides

		/// <summary>
		/// Implementação do pre-render do controlo
		/// </summary>
		/// <param name="e"></param>
		protected override void OnPreRender(System.EventArgs e)
		{
			if (this.AlwaysReadOnly) this.Enabled = false;

			base.OnPreRender (e);
		}

		/// <summary>
		/// Implementação do Render do controlo
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//----------------------------------------------------------------
			// Definição da classe
			//----------------------------------------------------------------
			this.CssClass = "OWCheckBox";

			if (this.ReadOnly)
			{
				string Style = string.Format("WIDTH:{0}; HEIGHT:{1}", base.Width.ToString(), base.Height.ToString());

				string LabelDescription;
				string CheckedDescription;

   				CheckedDescription = base.Checked ? ResX.GetString("YES") : ResX.GetString("NO");

				if (base.Text.Trim() != string.Empty)
					LabelDescription = string.Format("{0} ({1})", base.Text, CheckedDescription);
				else
	   				LabelDescription = CheckedDescription;

				output.Write(string.Format("<SPAN style='{0}' class='{1}'>{2}</SPAN>", Style, CssClass, LabelDescription));

			}			
			else
			{
				base.Render(output);
			}
		}

		#endregion

		#region Methods

		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			this.Checked = false;
		}

		#endregion

	}
}
