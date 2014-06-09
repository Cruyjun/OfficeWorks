using System.Web.UI;
using Infragistics.WebUI.Misc;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWWebPanel.
	/// </summary>
	public class OWWebPanel : WebPanel
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWWebPanel(){}


		/// <summary>
		/// Implementação do método render
		/// </summary>
		/// <param name="output"></param>
		protected override void  Render(HtmlTextWriter output)
		{
			base.Header.TextAlignment = TextAlignment.Left;

			base.Header.CollapsedAppearance.Style.CssClass = "OWWebPanel";
			
			base.Header.ExpandedAppearance.Style.CssClass = "OWWebPanel";

			base.Render(output);
		}
	}
}
