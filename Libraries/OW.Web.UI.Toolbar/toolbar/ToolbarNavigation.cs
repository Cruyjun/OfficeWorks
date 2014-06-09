using System;
//using System.Web;
//using System.Web.UI;
using System.Drawing;
//using System.ComponentModel;
using System.Web.UI.WebControls;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Summary description for ToolbarFilter.
	/// </summary>
	public class ToolbarNavigation : Toolbar
	{
		/// <summary>
		/// Constructor
		/// </summary>
		public ToolbarNavigation(){}

		/// <summary>
		/// Indica se o item Open está escondido
		/// </summary>
		private bool openHidden;

		/// <summary>
		/// Indica se o item Open está escondido
		/// </summary>
		public bool OpenHidden
		{
			get { return this.openHidden; }
			set { this.openHidden = value; }
		}

		/// <summary>
		/// Indica se o item Refresh está escondido
		/// </summary>
		private bool refreshHidden = true;

		/// <summary>
		/// Indica se o item Refresh está escondido
		/// </summary>
		public bool RefreshHidden
		{
			get { return this.refreshHidden; }
			set { this.refreshHidden = value; }
		}
		
		/// <summary>
		/// Indica se o item Remove está escondido
		/// </summary>
		private bool removeHidden;

		/// <summary>
		/// Indica se o item Remove está escondido
		/// </summary>
		public bool RemoveHidden
		{
			get { return this.removeHidden; }
			set { this.removeHidden = value; }
		}

		/// <summary>
		/// Indica se o item Modify está escondido
		/// </summary>
		private bool modifyHidden;

		/// <summary>
		/// Indica se o item Modify está escondido
		/// </summary>
		public bool ModifyHidden
		{
			get { return this.modifyHidden; }
			set { this.modifyHidden = value; }
		}

		/// <summary>
		/// Indica se o item Add está escondido
		/// </summary>
		private bool addHidden;

		/// <summary>
		/// Indica se o item Add está escondido
		/// </summary>
		public bool AddHidden
		{
			get { return this.addHidden; }
			set { this.addHidden = value; }
		}

		/// <summary>
		/// Indica se o item Last está escondido
		/// </summary>
		private bool lastHidden;

		/// <summary>
		/// Indica se o item Last está escondido
		/// </summary>
		public bool LastHidden
		{
			get { return this.lastHidden; }
			set { this.lastHidden = value; }
		}

		/// <summary>
		/// Indica se o item Next está escondido
		/// </summary>
		private bool nextHidden;

		/// <summary>
		/// Indica se o item Next está escondido
		/// </summary>
		public bool NextHidden
		{
			get { return this.nextHidden; }
			set { this.nextHidden = value; }
		}

		/// <summary>
		/// Indica se o item Previous está escondido
		/// </summary>
		private bool previousHidden;

		/// <summary>
		/// Indica se o item Previous está escondido
		/// </summary>
		public bool PreviousHidden
		{
			get { return this.previousHidden; }
			set { this.previousHidden = value; }
		}

		/// <summary>
		/// Indica se o item First está escondido
		/// </summary>
		private bool firstHidden;

		/// <summary>
		/// Indica se o item First está escondido
		/// </summary>
		public bool FirstHidden
		{
			get { return this.firstHidden; }
			set { this.firstHidden = value; }
		}

		/// <summary>
		/// Indica se o item Add causa validação
		/// </summary>
		private bool addCauseValidation = true;

		/// <summary>
		/// Indica se o item Add causa validação
		/// </summary>
		public bool AddCauseValidation
		{
			get { return this.addCauseValidation; }
			set { this.addCauseValidation = value; }
		}

		/// <summary>
		/// Indica se o item Modify causa validação
		/// </summary>
		private bool modifyCauseValidation = true;

		/// <summary>
		/// Indica se o item Modify causa validação
		/// </summary>
		public bool ModifyCauseValidation
		{
			get { return this.modifyCauseValidation; }
			set { this.modifyCauseValidation = value; }
		}


		/// <summary>
		/// Initialize
		/// </summary>
		/// <param name="e"></param>
		protected override void OnInit(EventArgs e)
		{
			//------------------------------------------------------------
			// Configuração da ToolBar
			//------------------------------------------------------------
			this.Width = new Unit(100, UnitType.Percentage);

			this.Height = new Unit(26, UnitType.Pixel);

			this.CssClass = "mytoolbar";

			this.BorderWidth = new Unit(1, UnitType.Pixel);

			this.BorderColor = Color.Gainsboro;

			this.SeparatorCellDistance = new Unit(10, UnitType.Pixel);

			this.AddDefaultItems();

			base.OnInit (e);
		}

		/// <summary>
		/// Adição dos Items na ToolBar
		/// </summary>
		private void AddDefaultItems()
		{

			ToolbarButton itemNone = (ToolbarButton)this.Items["None"];

			ToolbarButton itemOpen = (ToolbarButton)this.Items["Open"];			

			ToolbarButton itemRefresh = (ToolbarButton)this.Items["Refresh"];			

			ToolbarButton itemRemove = (ToolbarButton)this.Items["Remove"];			
			
			ToolbarButton itemModify = (ToolbarButton)this.Items["Modify"];			
			
			ToolbarButton itemAdd = (ToolbarButton)this.Items["Add"];			
			
			ToolbarButton itemLast = (ToolbarButton)this.Items["Last"];			

			ToolbarButton itemNext = (ToolbarButton)this.Items["Next"];			

			ToolbarButton itemPrevious = (ToolbarButton)this.Items["Previous"];			

			ToolbarButton itemFirst = (ToolbarButton)this.Items["First"];			

			//----------------------------------------------------------------
			// ItemNone
			//----------------------------------------------------------------
			if (itemNone == null) 
			{
				itemNone = new ToolbarButton();
				this.Items.Add(itemNone);
			}

			itemNone.ItemId = "None";

			itemNone.LabelText = string.Empty;

			itemNone.HorizontalAlign = HorizontalAlign.Right;

			itemNone.ItemCellMouseOver = "this.className=null;";

			itemNone.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemOpen
			//----------------------------------------------------------------
			if (itemOpen == null) 
			{
				itemOpen = new ToolbarButton();
				this.Items.Add(itemOpen);
			}

			itemOpen.ItemId = "Open";

			itemOpen.LabelText = ResX.GetString("Open");

			itemOpen.ToolTip = ResX.GetString("OpenToolTip");

			itemOpen.ImageUrl = "~/design/image/ActionBar/Open.gif";

			itemOpen.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemOpen.HorizontalAlign = HorizontalAlign.Left;

			itemOpen.CauseValidation = false;

			
			//----------------------------------------------------------------
			// ItemRefresh
			//----------------------------------------------------------------
			if (itemRefresh == null) 
			{
				itemRefresh = new ToolbarButton();
				this.Items.Add(itemRefresh);
			}

			itemRefresh.ItemId = "Refresh";

			itemRefresh.LabelText = ResX.GetString("Refresh");

			itemRefresh.ToolTip = ResX.GetString("RefreshToolTip");

			itemRefresh.ImageUrl = "~/design/image/ActionBar/Refresh.gif";

			itemRefresh.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemRefresh.HorizontalAlign = HorizontalAlign.Left;

			itemRefresh.CauseValidation = false;

			
			//----------------------------------------------------------------
			// Separator
			//----------------------------------------------------------------
			this.Items.Insert(0, new ToolbarSeparator());

			
			//----------------------------------------------------------------
			// ItemRemove
			//----------------------------------------------------------------
			if (itemRemove == null) 
			{
				itemRemove = new ToolbarButton();
				this.Items.Insert(0, itemRemove);
			}

			itemRemove.ItemId = "Remove";

			itemRemove.LabelText = ResX.GetString("Remove");

			itemRemove.ToolTip = ResX.GetString("RemoveToolTip");

			itemRemove.ImageUrl = "~/design/image/ActionBar/Remove.gif";

			itemRemove.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemRemove.HorizontalAlign = HorizontalAlign.Left;

			itemRemove.CauseValidation = false;

			itemRemove.ClientScript = "return window.confirm('"+ ResX.GetString("RemoveClientScriptMsg") + "');";


			//----------------------------------------------------------------
			// ItemModify
			//----------------------------------------------------------------
			if (itemModify == null) 
			{
				itemModify = new ToolbarButton();
				this.Items.Insert(0, itemModify);
			}

			itemModify.ItemId = "Modify";

			itemModify.LabelText = ResX.GetString("Modify");

			itemModify.ToolTip = ResX.GetString("ModifyToolTip");

			itemModify.ImageUrl = "~/design/image/actionbar/Modify.gif";

			itemModify.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemModify.HorizontalAlign = HorizontalAlign.Left;

			itemModify.CauseValidation = modifyCauseValidation;

			
			//----------------------------------------------------------------
			// ItemAdd
			//----------------------------------------------------------------
			if (itemAdd == null) 
			{
				itemAdd = new ToolbarButton();
				this.Items.Insert(0, itemAdd);
			}

			itemAdd.ItemId = "Add";

			itemAdd.LabelText = ResX.GetString("Add");

			itemAdd.ToolTip = ResX.GetString("AddToolTip");

			itemAdd.ImageUrl = "~/design/image/actionbar/Add.gif";

			itemAdd.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemAdd.HorizontalAlign = HorizontalAlign.Left;

			itemAdd.CauseValidation = addCauseValidation;

			
			//----------------------------------------------------------------
			// Separator
			//----------------------------------------------------------------
			this.Items.Insert(0, new ToolbarSeparator());


			//----------------------------------------------------------------
			// ItemLast
			//----------------------------------------------------------------
			if (itemLast == null) 
			{
				itemLast = new ToolbarButton();
				this.Items.Insert(0, itemLast);
			}

			itemLast.ItemId = "Last";

			itemLast.LabelText = string.Empty;

			itemLast.ToolTip = ResX.GetString("LastToolTip");

			itemLast.ImageUrl = "~/design/image/actionbar/Last.gif";

			itemLast.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemLast.HorizontalAlign = HorizontalAlign.Center;

			itemLast.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemNext
			//----------------------------------------------------------------
			if (itemNext == null) 
			{
				itemNext = new ToolbarButton();
				this.Items.Insert(0, itemNext);
			}

			itemNext.ItemId = "Next";

			itemNext.LabelText = string.Empty;

			itemNext.ToolTip = ResX.GetString("NextToolTip");

			itemNext.ImageUrl = "~/design/image/actionbar/Next.gif";

			itemNext.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemNext.HorizontalAlign = HorizontalAlign.Center;

			itemNext.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemPrevious
			//----------------------------------------------------------------
			if (itemPrevious == null) 
			{
				itemPrevious = new ToolbarButton();
				this.Items.Insert(0, itemPrevious);
			}

			itemPrevious.ItemId = "Previous";

			itemPrevious.LabelText = string.Empty;

			itemPrevious.ToolTip = ResX.GetString("PreviousToolTip");

			itemPrevious.ImageUrl = "~/design/image/actionbar/Previous.gif";

			itemPrevious.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemPrevious.HorizontalAlign = HorizontalAlign.Center;

			itemPrevious.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemFirst
			//----------------------------------------------------------------
			if (itemFirst == null) 
			{
				itemFirst = new ToolbarButton();
				this.Items.Insert(0, itemFirst);
			}

			itemFirst.ItemId = "First";

			itemFirst.LabelText = string.Empty;

			itemFirst.ToolTip = ResX.GetString("FirstToolTip");

			itemFirst.ImageUrl = "~/design/image/actionbar/First.gif";

			itemFirst.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemFirst.HorizontalAlign = HorizontalAlign.Center;

			itemFirst.CauseValidation = false;

		}

		/// <summary>
		/// Render do control
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(System.Web.UI.HtmlTextWriter writer)
		{
			this.Items["First"].Visible = true && !this.FirstHidden;
			this.Items["Previous"].Visible = true && !this.PreviousHidden;
			this.Items["Next"].Visible = true && !this.NextHidden;
			this.Items["Last"].Visible = true && !this.LastHidden;
			this.Items["Add"].Visible = true && !this.AddHidden;
			this.Items["Modify"].Visible = true && !this.ModifyHidden;
			this.Items["Remove"].Visible = true && !this.RemoveHidden;
			this.Items["Refresh"].Visible = !this.RefreshHidden;
			this.Items["Open"].Visible = true && !this.OpenHidden;

			base.Render (writer);
		}


	}
}
