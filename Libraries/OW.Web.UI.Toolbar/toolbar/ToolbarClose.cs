using System;
//using System.Web;
//using System.Web.UI;
using System.Drawing;
//using System.ComponentModel;
using System.Web.UI.WebControls;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Summary description for ToolbarClose.
	/// </summary>
	public class ToolbarClose : Toolbar
	{
		public ToolbarClose(){}

		protected override void OnInit(EventArgs e)
		{
			//------------------------------------------------------------
			// Configuração da ToolBar
			//------------------------------------------------------------
			this.Width = new Unit(100, UnitType.Percentage);

			this.Height = new Unit(26, UnitType.Pixel);

			this.CssClass = "mytoolbar";

			this.BorderWidth = new Unit(1, UnitType.Pixel);

			this.BorderColor = Color.LightSlateGray;

			this.BackgroundImageUrl = "~/design/image/actionbar/backgr.gif";

			this.SeparatorCellDistance = new Unit(10, UnitType.Pixel);

			this.SeparatorImageUrl = "~/design/image/actionbar/separator.gif";

			this.AddDefaultItems();

			base.OnInit (e);
		}

		/// <summary>
		/// Adição dos Items na ToolBar
		/// </summary>
		private void AddDefaultItems()
		{

			//paulo
			ToolbarButton itemNone = (ToolbarButton)this.Items["None"];

			ToolbarButton itemClose = (ToolbarButton)this.Items["Close"];			

			
			//paulo
			//----------------------------------------------------------------
			// ItemNone
			//----------------------------------------------------------------
			if (itemNone == null) 
			{
				itemNone = new ToolbarButton();
				this.Items.Add(itemNone);
			}

			itemNone.LabelText = "";

			itemNone.ItemId = "None";

			itemNone.HorizontalAlign = HorizontalAlign.Right;

			itemNone.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemClose
			//----------------------------------------------------------------
			if (itemClose == null) 
			{
				itemClose = new ToolbarButton();
				this.Items.Add(itemClose);
			}

			itemClose.LabelText = " Fechar";

			itemClose.ItemId = "Close";

			itemClose.ImageUrl = "~/design/image/actionbar/Close.gif";

			itemClose.ItemCellDistance = new Unit(1,UnitType.Percentage);

			itemClose.HorizontalAlign = HorizontalAlign.Right;

			itemClose.CauseValidation = false;

			itemClose.ClientScript = "window.close(); return false;";


		}
	}
}
