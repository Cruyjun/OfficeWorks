using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Extensão do HTMLContainerControl com possibilidade de desenho de borders
	/// </summary>
	public class OWPanel :Panel
	{
		/// <summary>
		/// Contrutor da classe
		/// </summary>
		public OWPanel()
		{
			//
			// TODO: Add constructor logic here
			//
		}


		/// <summary>
		/// Render do control para a página
		/// </summary>
		protected override void Render(HtmlTextWriter output)
		{
			if (ShowBorders)
			{

				//Tentativa de definir o tamanho
				//output.Write("<TABLE cellSpacing='0' cellPadding='0' border='0' width=" + base.Width + ">");

				output.Write("<TABLE cellSpacing='0' cellPadding='0' border='0'>");
				output.Write("<TR><TD class='OWPanelTopLeftTile'>&nbsp;</TD><TD class='OWPanelTopCenterTile'>&nbsp;</TD><TD class='OWPanelTopRightTile'>&nbsp;</TD></TR>");
				output.Write("<TR><TD class='OWPanelMiddleLeftTile'>&nbsp;</TD><TD class='OWPanelMiddleTile'>");
			}
			
			base.Render(output);

			
			if (ShowBorders)
			{
				output.Write("</TD><TD class='OWPanelMiddleRightTile'>&nbsp;</TD></TR>");
				output.Write("<TR><TD class='OWPanelBottomLeftTile'>&nbsp;</TD><TD class='OWPanelBottomCenterTile'>&nbsp;</TD><TD class='OWPanelBottomRightTile'>&nbsp;</TD></TR>");
				output.Write("</TABLE>");
			}

		}

		/// <summary>
		/// Indica se é desenhado o border no control. Variável privada associada a ShowBorders
		/// </summary>
		private bool _ShowBorders;
		
		/// <summary>
		/// Indica se é desenhado o border no control
		/// </summary>
		[Bindable(true)]
		public bool ShowBorders
		{
			get
			{
				return this._ShowBorders;
			}
			set
			{
				this._ShowBorders = value;
			}
		}
	}
}
