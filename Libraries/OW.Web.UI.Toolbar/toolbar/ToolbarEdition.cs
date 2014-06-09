using System;
//using System.Web;
//using System.Web.UI;
using System.Drawing;
//using System.ComponentModel;
using System.Web.UI.WebControls;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Summary description for ToolbarEdition.
	/// </summary>
	public class ToolbarEdition : Toolbar
	{
		public ToolbarEdition(){}

		/// <summary>
		/// Modo de edição da toolbar
		/// </summary>
		//private ToolbarEditionMode editionMode;

		/// <summary>
		/// Modo de edição da toolbar
		/// </summary>
		public ToolbarEditionMode EditionMode
		{
			get 
			{
				if (ViewState["EditionMode"] == null) 
					return ToolbarEditionMode.View;
				else
					return (ToolbarEditionMode)ViewState["EditionMode"];
			}
			set 
			{ 
				ViewState["EditionMode"] = value; 
			}
		}

		/// <summary>
		/// Indica se o item Insert está escondido
		/// </summary>
		private bool insertHidden;

		/// <summary>
		/// Indica se o item Insert está escondido
		/// </summary>
		public bool InsertHidden
		{
			get { return this.insertHidden; }
			set { this.insertHidden = value; }
		}

		/// <summary>
		/// Indica se o item Edit está escondido
		/// </summary>
		private bool editHidden;

		/// <summary>
		/// Indica se o item Edit está escondido
		/// </summary>
		public bool EditHidden
		{
			get { return this.editHidden; }
			set { this.editHidden = value; }
		}

		/// <summary>
		/// Indica se o item Save está escondido
		/// </summary>
		private bool saveHidden;

		/// <summary>
		/// Indica se o item Save está escondido
		/// </summary>
		public bool SaveHidden
		{
			get { return this.saveHidden; }
			set { this.saveHidden = value; }
		}

		/// <summary>
		/// Indica se o item Delete está escondido
		/// </summary>
		private bool deleteHidden;

		/// <summary>
		/// Indica se o item Delete está escondido
		/// </summary>
		public bool DeleteHidden
		{
			get { return this.deleteHidden; }
			set { this.deleteHidden = value; }
		}

		/// <summary>
		/// Indica se o item New está escondido
		/// </summary>
		private bool newHidden;

		/// <summary>
		/// Indica se o item New está escondido
		/// </summary>
		public bool NewHidden
		{
			get { return this.newHidden; }
			set { this.newHidden = value; }
		}

		protected override void OnInit(EventArgs e)
		{
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

			ToolbarButton itemDelete = (ToolbarButton)this.Items["Delete"];			

			ToolbarButton itemSave = (ToolbarButton)this.Items["Save"];			

			ToolbarButton itemEdit = (ToolbarButton)this.Items["Edit"];			

			ToolbarButton itemInsert = (ToolbarButton)this.Items["Insert"];			

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
			// ItemDelete
			//----------------------------------------------------------------
			if (itemDelete == null) 
			{
				itemDelete = new ToolbarButton();
				this.Items.Insert(0, itemDelete);
			}

			itemDelete.LabelText = " Apagar";

			itemDelete.ItemId = "Delete";

			itemDelete.ImageUrl = "~/design/image/actionbar/Delete.gif";

			itemDelete.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemDelete.HorizontalAlign = HorizontalAlign.Left;

			itemDelete.CauseValidation = false;

			itemDelete.ClientScript = "return window.confirm('Deseja eliminar o registo?');";

			//----------------------------------------------------------------
			// ItemSave
			//----------------------------------------------------------------
			if (itemSave == null) 
			{
				itemSave = new ToolbarButton();
				this.Items.Insert(0, itemSave);
			}

			itemSave.LabelText = " Gravar";

			itemSave.ItemId = "Save";

			itemSave.ImageUrl = "~/design/image/actionbar/Save.gif";

			itemSave.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemSave.HorizontalAlign = HorizontalAlign.Left;

			itemSave.CauseValidation = true;

			//----------------------------------------------------------------
			// ItemEdit
			//----------------------------------------------------------------
			if (itemEdit == null) 
			{
				itemEdit = new ToolbarButton();
				this.Items.Insert(0, itemEdit);
			}

			itemEdit.LabelText = " Editar";

			itemEdit.ItemId = "Edit";

			itemEdit.ImageUrl = "~/design/image/actionbar/Edit.gif";

			itemEdit.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemEdit.HorizontalAlign = HorizontalAlign.Left;

			itemEdit.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemInsert
			//----------------------------------------------------------------
			if (itemInsert == null) 
			{
				itemInsert = new ToolbarButton();
				this.Items.Insert(0, itemInsert);
			}

			itemInsert.LabelText = " Inserir";

			itemInsert.ItemId = "Insert";

			itemInsert.ImageUrl = "~/design/image/actionbar/Insert.gif";

			itemInsert.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemInsert.HorizontalAlign = HorizontalAlign.Left;

			itemInsert.CauseValidation = true;

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

			itemNew.CauseValidation = false;

		}

		protected override void CreateChildControls()
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
	
			base.CreateChildControls ();
		}


		/// <summary>
		/// Override o método render do controlo
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(System.Web.UI.HtmlTextWriter writer)
		{
			switch(this.EditionMode)
			{
				case ToolbarEditionMode.View:
					this.Items["New"].Visible = true && !this.NewHidden;
					this.Items["Insert"].Visible = false;
					this.Items["Edit"].Visible = true && !this.EditHidden;
					this.Items["Save"].Visible = false;
					this.Items["Delete"].Visible = true && !this.DeleteHidden;
					break;
				case ToolbarEditionMode.Insert:
					this.Items["New"].Visible = false;
					this.Items["Insert"].Visible = true && !this.InsertHidden;
					this.Items["Edit"].Visible = false;
					this.Items["Save"].Visible = false;
					this.Items["Delete"].Visible = false;
					break;
				case ToolbarEditionMode.Modify:
					this.Items["New"].Visible = false;
					this.Items["Insert"].Visible = false;
					this.Items["Edit"].Visible = false;
					this.Items["Save"].Visible = true && !this.SaveHidden;
					this.Items["Delete"].Visible = false;
					break;
			}

			base.Render (writer);
		}

	}
}
