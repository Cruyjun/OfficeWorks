using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{

	/// <summary>
	/// Summary description for OWRadioButtonList.
	/// </summary>
	public class OWRadioButtonList : RadioButtonList
	{

		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWRadioButtonList()
		{
		}

		/// <summary>
		/// Override do método Render para que, no caso do control estar disabled,
		/// mostre apenas uma label com o texto do item seleccionado
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{

			base.CssClass = "OWRadioButtonList";

			if (!base.Enabled)
			{
				if (base.SelectedItem == null)
					output.Write(ResX.GetString("NoItemSelected"));
				else
					output.Write(base.SelectedItem.Text);
			}
			else base.Render(output);
		}

	}
}
