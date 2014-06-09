
namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// UltraWebTab extendido
	/// </summary>
	public class OWUltraWebTab : Infragistics.WebUI.UltraWebTab.UltraWebTab
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWUltraWebTab(){}

		/// <summary>
		/// Implementa��o do m�todo render
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(System.Web.UI.HtmlTextWriter output)
		{
			base.CssClass = "OWUltraWebTab";

			base.Render(output);
		}
	}
}
