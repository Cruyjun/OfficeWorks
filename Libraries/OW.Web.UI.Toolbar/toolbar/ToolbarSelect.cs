using System;
//using System.Web;
//using System.Web.UI;
using System.Drawing;
//using System.ComponentModel;
using System.Web.UI.WebControls;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Summary description for ToolbarSelect.
	/// </summary>
	public class ToolbarSelect : Toolbar
	{
		public ToolbarSelect(){}

		/// <summary>
		/// Indica se o item Select está escondido
		/// </summary>
		private bool selectHidden;

		/// <summary>
		/// Indica se o item Select está escondido
		/// </summary>
		public bool SelectHidden
		{
			get { return this.selectHidden; }
			set { this.selectHidden = value; }
		}

		/// <summary>
		/// Indica se o item Result está escondido
		/// </summary>
		private bool resultHidden;

		/// <summary>
		/// Indica se o item Result está escondido
		/// </summary>
		public bool ResultHidden
		{
			get { return this.resultHidden; }
			set { this.resultHidden = value; }
		}

		/// <summary>
		/// Indica se o item Clear está escondido
		/// </summary>
		private bool clearHidden;

		/// <summary>
		/// Indica se o item Clear está escondido
		/// </summary>
		public bool ClearHidden
		{
			get { return this.clearHidden; }
			set { this.clearHidden = value; }
		}

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
			
			ToolbarButton itemClear = (ToolbarButton)this.Items["Clear"];			

			ToolbarButton itemResult = (ToolbarButton)this.Items["Result"];			

			ToolbarButton itemSelect = (ToolbarButton)this.Items["Select"];			

			
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

			itemClose.ClientScript = "window.close();return false;";

			//----------------------------------------------------------------
			// ItemClear
			//----------------------------------------------------------------
			if (itemClear == null) 
			{
				itemClear = new ToolbarButton();
				this.Items.Insert(0, itemClear);
			}

			itemClear.LabelText = " Limpar";

			itemClear.ItemId = "Clear";

			itemClear.ImageUrl = "~/design/image/ActionBar/Clear.gif";

			itemClear.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemClear.HorizontalAlign = HorizontalAlign.Left;

			itemClear.CauseValidation = false;


			//----------------------------------------------------------------
			// ItemResult
			//----------------------------------------------------------------
			if (itemResult == null) 
			{
				itemResult = new ToolbarButton();
				this.Items.Insert(0, itemResult);
			}

			itemResult.LabelText = " Resultados";

			itemResult.ItemId = "Result";

			itemResult.ImageUrl = "~/design/image/actionbar/Result.gif";

			itemResult.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemResult.HorizontalAlign = HorizontalAlign.Left;

			itemResult.CauseValidation = true;


			//----------------------------------------------------------------
			// ItemSelect
			//----------------------------------------------------------------
			if (itemSelect == null) 
			{
				itemSelect = new ToolbarButton();
				this.Items.Insert(0, itemSelect);
			}

			itemSelect.LabelText = " Seleccionar";

			itemSelect.ItemId = "Select";

			itemSelect.ImageUrl = "~/design/image/actionbar/Select.gif";

			itemSelect.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemSelect.HorizontalAlign = HorizontalAlign.Left;

			itemSelect.CauseValidation = true;

		}
	}
}
