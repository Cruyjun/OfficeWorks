using System.Web.UI;
using Infragistics.WebUI.UltraWebNavigator;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWUltraWebMenu.
	/// </summary>
	public class OWUltraWebMenu : UltraWebMenu
	{

		#region Contructors
		
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWUltraWebMenu(){}
		
		#endregion

		#region Public Methods

		/// <summary>
		/// Adição de uma acção no Popup Menu
		/// </summary>
		/// <param name="TagString">Id definido para a acção</param>
		/// <param name="LabelText">Texto da acção</param>
		public void AddAction(string TagString, string LabelText)
		{
			this.AddAction(TagString, LabelText, string.Empty, string.Empty, false, true, false, string.Empty, Infragistics.WebUI.UltraWebNavigator.CheckBoxes.False, false);
		}

		/// <summary>
		/// Adição de uma acção no Popup Menu
		/// </summary>
		/// <param name="TagString">Id definido para a acção</param>
		/// <param name="LabelText">Texto da acção</param>
		/// <param name="ImageUrl">Url da Imagem</param>
		/// <param name="HoverImageUrl">Hover Url da Imagem</param>
		public void AddAction(string TagString, string LabelText, string ImageUrl, string HoverImageUrl)
		{
			this.AddAction(TagString, LabelText, ImageUrl, HoverImageUrl, false, true, false, string.Empty, Infragistics.WebUI.UltraWebNavigator.CheckBoxes.False, false);
		}

		/// <summary>
		/// Adição de uma acção no Popup Menu
		/// </summary>
		/// <param name="TagString">Id definido para a acção</param>
		/// <param name="LabelText">Texto da acção</param>
		/// <param name="ImageUrl">Url da Imagem</param>
		/// <param name="HoverImageUrl">Hover Url da Imagem</param>
		/// <param name="TargetUrl">Url de destino ou javascipt</param>
		public void AddAction(string TagString, string LabelText, string ImageUrl, string HoverImageUrl, string TargetUrl)
		{
			this.AddAction(TagString, LabelText, ImageUrl, HoverImageUrl, false, true, false, TargetUrl, Infragistics.WebUI.UltraWebNavigator.CheckBoxes.False, false);
		}

		/// <summary>
		/// Adição de uma acção no Popup Menu
		/// </summary>
		/// <param name="TagString">Id definido para a acção</param>
		/// <param name="LabelText">Texto da acção</param>
		/// <param name="ImageUrl">Url da imagem</param>
		/// <param name="HoverImageUrl">Hover Url da imagem</param>
		/// <param name="Separator">Separador</param>
		/// <param name="Enabled">Activo</param>
		/// <param name="Hidden">Escondido</param>
		/// <param name="TargetUrl">Url de destino ou javascipt</param>
		/// <param name="CheckBox">CheckBox visível</param>
		/// <param name="Checked">Valor da CheckBox</param>
		public void AddAction
		(
			string TagString,
			string LabelText,
			string ImageUrl,
			string HoverImageUrl,
			bool Separator,
			bool Enabled,
			bool Hidden,
			string TargetUrl,
			CheckBoxes CheckBox,
			bool Checked)
		{	
			//----------------------------------------------------------------
			// Declaração de variáveis
			//----------------------------------------------------------------
			Item item = new Item();

			item.TagString = TagString;

			item.Text = LabelText;

			item.ImageUrl = ImageUrl;

			item.HoverImageUrl = HoverImageUrl;
			
			item.Separator = Separator;

			item.Enabled = Enabled;

			item.Hidden = Hidden;

			item.TargetUrl = TargetUrl;

			item.CheckBox = CheckBox;

			item.Checked = Checked;

			//----------------------------------------------------------------
			// Inserção do item 
			//----------------------------------------------------------------
			this.Items.Add(item);
		}

		#endregion

		#region overrides
		/// <summary>
		/// Override do método OnLoad do Menu
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(HtmlTextWriter writer)
		{
			base.Render(writer);
		}
		#endregion

	}
}
