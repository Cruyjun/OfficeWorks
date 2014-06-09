using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Lista de Selecção
	/// </summary>
	public class OWListBox : ListBox, IEPWebControl
	{
		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWListBox(){}

		/// <summary>
		/// Indica se o modo de selecção dos items é por check-box
		/// </summary>
		public bool RenderItemsAsCheckBoxes
		{
			get
			{
				object obj = this.ViewState["RenderItemsAsCheckBoxes"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["RenderItemsAsCheckBoxes"] = value;
			}
		}

		/// <summary>
		/// Limpa o valor do campo
		/// </summary>
		public void ClearData()
		{
		}

		/// <summary>
		/// 
		/// </summary>
		public bool ReadOnly
		{
			get
			{
				object obj = this.ViewState["ReadOnly"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["ReadOnly"] = value;
			}
		}

		/// <summary>
		/// Implementação do evento Render
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Definição da classe para este tipo de controlo
			//------------------------------------------------------------
			base.CssClass = "OWListBox";

			if (RenderItemsAsCheckBoxes)
			{
				HtmlTable itemTable = new HtmlTable();

				itemTable.Width = this.Width.ToString();
				itemTable.CellPadding = 0;
				itemTable.CellSpacing = 0;
				itemTable.Border= 0;

				for (int i=0;i <= this.Items.Count-1;i++)
				{
					itemTable.Rows.Add(new HtmlTableRow());
					
					HtmlTableCell cell = new HtmlTableCell();
					itemTable.Rows[i].Cells.Add(cell);

					OWCheckBox chkValue = new OWCheckBox();
					//chkValue.Enabled = !this.ReadOnly;
					chkValue.ReadOnly = this.ReadOnly;

					if (this.Items[i].Selected)
					{
						chkValue.Checked = true;
					}
					else
						chkValue.Checked = false;

					chkValue.Text = this.Items[i].Value;

					cell.Controls.Add(chkValue);
				}
				itemTable.RenderControl(output);
			}
			else
				base.Render(output);
		}
	}
}
