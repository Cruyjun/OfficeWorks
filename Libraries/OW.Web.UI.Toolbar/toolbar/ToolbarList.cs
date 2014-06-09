using System;
//using System.Web;
//using System.Web.UI;
using System.Drawing;
//using System.ComponentModel;
using System.Web.UI.WebControls;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Summary description for ToolbarList.
	/// </summary>
	public class ToolbarList : Toolbar
	{
		public ToolbarList(){}

		/// <summary>
		/// Indica se o item New está escondido
		/// </summary>
		public bool NewHidden
		{
			get { return !this.Items["New"].Visible; }
			set { this.Items["New"].Visible = !value; }
		}

		/// <summary>
		/// Indica se o item View está escondido
		/// </summary>
		public bool ViewHidden
		{
			get { return !this.Items["View"].Visible; }
			set { this.Items["View"].Visible = !value; }
		}

		/// <summary>
		/// Indica se o item Filter está escondido
		/// </summary>
		public bool FilterHidden
		{
			get { return !this.Items["Filter"].Visible; }
			set { this.Items["Filter"].Visible = !value; }
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

			this.SeparatorImageUrl = "~/design/image/separator.gif";

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

			ToolbarButton itemBack = (ToolbarButton)this.Items["Back"];			

			ToolbarButton itemRefresh = (ToolbarButton)this.Items["Refresh"];			

			ToolbarButton itemFilter = (ToolbarButton)this.Items["Filter"];			

			ToolbarButton itemView = (ToolbarButton)this.Items["View"];			

			ToolbarButton itemNew = (ToolbarButton)this.Items["New"];			


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
			// ItemBack
			//----------------------------------------------------------------
			if (itemBack == null) 
			{
				itemBack = new ToolbarButton();
				this.Items.Add(itemBack);
			}

			itemBack.LabelText = " Voltar";

			itemBack.ItemId = "Back";

			itemBack.ImageUrl = "~/design/image/actionbar/Back.gif";

			itemBack.ItemCellDistance = new Unit(1,UnitType.Percentage);

			itemBack.HorizontalAlign = HorizontalAlign.Right;

			itemBack.CauseValidation = false;

			itemBack.ClientScript = "goBack();return false;";


			//----------------------------------------------------------------
			// ItemRefresh
			//----------------------------------------------------------------
			if (itemRefresh == null) 
			{
				itemRefresh = new ToolbarButton();
				this.Items.Insert(0, itemRefresh);
			}

			itemRefresh.LabelText = " Refrescar";

			itemRefresh.ItemId = "Refresh";

			itemRefresh.ImageUrl = "~/design/image/actionbar/Refresh.gif";

			itemRefresh.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemRefresh.HorizontalAlign = HorizontalAlign.Left;

			itemRefresh.CauseValidation = true;

			//----------------------------------------------------------------
			// ItemFilter
			//----------------------------------------------------------------
			if (itemFilter == null) 
			{
				itemFilter = new ToolbarButton();
				this.Items.Insert(0, itemFilter);
			}

			itemFilter.LabelText = " Filtrar";

			itemFilter.ItemId = "Filter";

			itemFilter.ImageUrl = "~/design/image/actionbar/Filter.gif";

			itemFilter.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemFilter.HorizontalAlign = HorizontalAlign.Left;

			itemFilter.CauseValidation = true;


			//----------------------------------------------------------------
			// ItemView
			//----------------------------------------------------------------
			if (itemView == null) 
			{
				itemView = new ToolbarButton();
				this.Items.Insert(0, itemView);
			}

			itemView.LabelText = " Consultar";

			itemView.ItemId = "View";

			itemView.ImageUrl = "~/design/image/actionbar/View.gif";

			itemView.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemView.HorizontalAlign = HorizontalAlign.Left;

			itemView.CauseValidation = true;


			//----------------------------------------------------------------
			// ItemNew
			//----------------------------------------------------------------
			if (itemNew == null) 
			{
				itemNew = new ToolbarButton();
				this.Items.Insert(0, itemNew);
			}

			itemNew.LabelText = " Novo";

			itemNew.ItemId = "New";

			itemNew.ImageUrl = "~/design/image/actionbar/New.gif";

			itemNew.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemNew.HorizontalAlign = HorizontalAlign.Left;

			itemNew.CauseValidation = true;

		}
	}
}
