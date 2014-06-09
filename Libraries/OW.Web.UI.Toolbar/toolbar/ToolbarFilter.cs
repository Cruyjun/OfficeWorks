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
	public class ToolbarFilter : Toolbar
	{
		public ToolbarFilter(){}

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
			//------------------------------------------------------------
			// Configuração da ToolBar
			//------------------------------------------------------------
			this.Width = new Unit(100, UnitType.Percentage);

			this.Height = new Unit(26, UnitType.Pixel);

			this.CssClass = "mytoolbar";

			this.BorderWidth = new Unit(1, UnitType.Pixel);

			this.BorderColor = Color.LightSlateGray;

			this.BackgroundImageUrl = "~/design/image/ActionBar/backgr.gif";

			this.SeparatorCellDistance = new Unit(10, UnitType.Pixel);

			this.SeparatorImageUrl = "~/design/images/separator.gif";

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

			ToolbarButton itemClear = (ToolbarButton)this.Items["Clear"];			

			ToolbarButton itemResult = (ToolbarButton)this.Items["Result"];			

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

			itemBack.ImageUrl = "~/design/image/ActionBar/Back.gif";

			itemBack.ItemCellDistance = new Unit(1,UnitType.Percentage);

			itemBack.HorizontalAlign = HorizontalAlign.Right;

			itemBack.CauseValidation = false;

			itemBack.ClientScript = "goBack();return false;";

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

		/// <summary>
		/// Override o método Render da Toolbar
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(System.Web.UI.HtmlTextWriter writer)
		{
			this.Items["New"].Visible = true && !this.NewHidden;

			base.Render(writer);

			//paulo
			//writer.Write("<br>");
			
			writer.Write("<table width='100%' cellPadding='0px' cellSpacing='0px' border='0px'>");
			writer.Write("<tr>");
			writer.Write("<td valign='center' width='10px'>");
			writer.Write("<img src='" + this.Page.Request.ApplicationPath + "/design/image/actionbar/logofilter.gif'>");
			writer.Write("</img>");
			writer.Write("</td>");
			writer.Write("<td valign='center' class='EPRToolbarFilter'>");
			writer.Write("Condições de pesquisa");
			writer.Write("</td>");
			writer.Write("</tr>");
			writer.Write("</table>");
			
			//paulo
			//writer.Write("<br>");
		}
	}
}
