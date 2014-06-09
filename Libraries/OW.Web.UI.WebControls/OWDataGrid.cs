using System;
using System.ComponentModel;
using System.Data;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Classe herdada de DataGrid
	/// </summary>
	public class OWDataGrid : DataGrid
	{
		#region Propriedades

		/// <summary>
		/// Header da DataGrid
		/// </summary>
		public DataGridItem HeaderItem;

		/// <summary>
		/// Footer da DataGrid
		/// </summary>
		public DataGridItem FooterItem;


		/// <summary>
		/// Indica se são sempre mostradas linhas em Lopes para preencher o número de registos da página
		/// </summary>
		public bool AllwaysShowBlankRows
		{
			get
			{
				object obj = this.ViewState["AllwaysShowBlankRows"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["AllwaysShowBlankRows"] = value;
			}
		}


		/// <summary>
		/// Indica se são mostradas linhas em Lopes para preencher o número de registos da página
		/// </summary>
		public bool ShowBlankRows
		{
			get
			{
				object obj = this.ViewState["ShowBlankRows"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["ShowBlankRows"] = value;
			}
		}

		/// <summary>
		/// Indica se é mostrada a mensagem a dizer q não foram encontrados registos
		/// </summary>
		public bool ShowMessageNoRecordsFound
		{
			get
			{
				object obj = this.ViewState["ShowMessageNoRecordsFound"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["ShowMessageNoRecordsFound"] = value;
			}
		}

		/// <summary>
		/// Mensagem a dizer q não foram encontrados registos
		/// </summary>
		public string MessageNoRecordsFound
		{
			get
			{
				object obj = this.ViewState["MessageNoRecordsFound"];				
				return obj == null ? ResX.GetString("MessageNoRecordsFound") : obj.ToString();
			}
			set
			{
				this.ViewState["MessageNoRecordsFound"] = value;
			}
		}
		
		/// <summary>
		/// Indica se o pager é mostrado mesmo quando só tem uma página
		/// </summary>
		public bool PagerAlwaysVisible
		{
			get
			{
				object obj = this.ViewState["PagerAlwaysVisible"];				
				return obj == null ? false : (bool)obj;
			}
			set
			{
				this.ViewState["PagerAlwaysVisible"] = value;
			}
		}

		/// <summary>
		/// Item seleccionado tendo em conta o número de páginas e o número de items por página
		/// </summary>
		public int AbsoluteSelectedIndex
		{
			get
			{
				if (this.AllowPaging)
					return this.CurrentPageIndex * this.PageSize + this.SelectedIndex;
				else
					return this.SelectedIndex;
			}
		}

		/// <summary>
		/// Indica se implementado a paginação do OWDataGrid
		/// </summary>
		public bool BuiltInPaging
		{
			get
			{
				object obj = this.ViewState["BuiltInPaging"];				
				return obj == null ? true : (bool)obj;
			}
			set
			{
				this.ViewState["BuiltInPaging"] = value;
			}
		}

		/// <summary>
		/// Indica se implementado a paginação do OWDataGrid
		/// </summary>
		private int rowCount
		{
			get
			{
				object obj = this.ViewState["rowCount"];				
				return obj == null ? 0 : (int)obj;
			}
			set
			{
				this.ViewState["rowCount"] = value;
			}
		}

		#endregion

		#region Construtores

		/// <summary>
		/// Construtor da classe
		/// </summary>
		public OWDataGrid(){}

		#endregion

		#region Eventos

		/// <summary>
		/// Tratamento do evento de criação de um item
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void OnItemCreated(object sender, DataGridItemEventArgs e)
		{
			if (e != null && e.Item != null)
			{
				//----------------------------------------------------------------
				// Criação de uma referência para o Header da grid
				//----------------------------------------------------------------
				if (e.Item.ItemType == ListItemType.Header)
				{
					this.HeaderItem = e.Item;
				}

				//----------------------------------------------------------------
				// - Criação de uma referência para o Footer da grid
				// - Criação de linhas em Lopes no fim da lista para para preencher
				//   o número de linhas do tamanho da página
				//----------------------------------------------------------------
				if (e.Item.ItemType == ListItemType.Footer)
				{
					this.FooterItem = e.Item;

					if (this.AllwaysShowBlankRows) 
						this.AddBlankRows();
					else
						if (this.ShowBlankRows && this.AllowPaging) this.AddBlankRows();
				}

				//----------------------------------------------------------------
				// Tratamento do item Pager
				//----------------------------------------------------------------
				if ( e.Item.ItemType == ListItemType.Pager && this.BuiltInPaging)
				{
					//Maintable
					HtmlTable maintable = new HtmlTable();
					maintable.Rows.Add(new HtmlTableRow());
					maintable.Width = "100%";

					maintable.Rows[0].Cells.Add(new HtmlTableCell());
					maintable.Rows[0].Cells.Add(new HtmlTableCell());
					maintable.Rows[0].Cells.Add(new HtmlTableCell());

					maintable.Rows[0].Cells[0].Width = "33%";
					maintable.Rows[0].Cells[1].Width = "33%";
					maintable.Rows[0].Cells[2].Width = "33%";

					//Paginator table
					HtmlTable table = new HtmlTable();
					table.Rows.Add(new HtmlTableRow());
					table.Align = "center";
 
					table.Rows[0].Cells.Add(new HtmlTableCell());
					table.Rows[0].Cells.Add(new HtmlTableCell());
					table.Rows[0].Cells.Add(new HtmlTableCell());
					table.Rows[0].Cells.Add(new HtmlTableCell());
					table.Rows[0].Cells.Add(new HtmlTableCell());
					table.Rows[0].Cells.Add(new HtmlTableCell());

					OWLinkButton First = new OWLinkButton();
					OWLinkButton Previous = new OWLinkButton();
					OWLinkButton Next = new OWLinkButton();
					OWLinkButton Last = new OWLinkButton();

					First.CausesValidation = false;
					Previous.CausesValidation = false;
					Next.CausesValidation = false;
					Last.CausesValidation = false;

					First.Click += new EventHandler(this.OnClickFirst);
					Previous.Click += new EventHandler(this.OnClickPrevious);
					Next.Click += new EventHandler(this.OnClickNext);
					Last.Click += new EventHandler(this.OnClickLast);

					First.Text = "<<";
					Previous.Text = "<";
					Next.Text = ">";
					Last.Text = ">>";

					int pageNumber = this.CurrentPageIndex + 1;
					int pageCount = this.PageCount;

					//Show buttons if not in first page
					if(pageNumber > 1)
					{
						table.Rows[0].Cells[0].Controls.Add(First);
						table.Rows[0].Cells[1].Controls.Add(Previous);
					}
					//Pages info
					if (ResX.GetSelectedCulture().StartsWith("pt"))
						table.Rows[0].Cells[2].InnerText = string.Format("Página {0} de {1}", pageNumber,(pageCount==0?1:pageCount));
					else 
						table.Rows[0].Cells[2].InnerText = string.Format("Page {0} of {1}", pageNumber,(pageCount==0?1:pageCount));
					
					//Show buttons if pages exists or not in last page
					if(pageNumber != pageCount && pageCount != 0)
					{
						table.Rows[0].Cells[3].Controls.Add(Next);
						table.Rows[0].Cells[4].Controls.Add(Last);
					}

					//End of paginator table

					//Add paginator table to maintable
					maintable.Rows[0].Cells[1].Controls.Clear();
					maintable.Rows[0].Cells[1].Controls.Add(table);
					
					//Add total of records to maintable
					maintable.Rows[0].Cells[2].InnerText = "Total: " + this.rowCount.ToString();
					maintable.Rows[0].Cells[2].Attributes.Add("align","right");
					
					//Add navigator table
					e.Item.Controls[0].Controls.Clear();
					e.Item.Controls[0].Controls.AddAt(0, maintable);
				}
			}
		}

		/// <summary>
		/// Tratamento do evento de associação do DataSource à Grid
		/// </summary>
		/// <param name="e"></param>
		protected override void OnDataBinding(EventArgs e)
		{
			try
			{
				IListSource ilistsource = (IListSource)this.DataSource;

				if (ilistsource is DataSet)
				{
					if (this.DataMember == string.Empty)
					{
						this.rowCount = ((DataSet)ilistsource).Tables[0].Rows.Count;
					}
					else
					{
						this.rowCount = ((DataSet)ilistsource).Tables[this.DataMember].Rows.Count;
					}
				}
				else
				{
					this.rowCount = ilistsource.GetList().Count;
				}
			}
			catch
			{
				this.rowCount = 0;
			}

			base.OnDataBinding (e);
		}


		/// <summary>
		/// Tratamento do evento de selecção da 1ª página
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void OnClickFirst(object sender, EventArgs e)
		{
			if (this.CurrentPageIndex > 0)
			{
				this.OnPageIndexChanged(new DataGridPageChangedEventArgs(this, 0));
			}
		}

		/// <summary>
		/// Tratamento do evento de selecção da página anterior
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void OnClickPrevious(object sender, EventArgs e)
		{
			if (this.CurrentPageIndex > 0)
			{
				this.OnPageIndexChanged(new DataGridPageChangedEventArgs(this, this.CurrentPageIndex - 1));
			}
		}

		/// <summary>
		/// Tratamento do evento de selecção da página seguinte
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void OnClickNext(object sender, EventArgs e)
		{
			if (this.CurrentPageIndex + 1 < this.PageCount)
			{
				this.OnPageIndexChanged(new DataGridPageChangedEventArgs(this, this.CurrentPageIndex + 1));
			}
		}
				
		/// <summary>
		/// Tratamento do evento de selecção da última página
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void OnClickLast(object sender, EventArgs e)
		{
			if (this.CurrentPageIndex + 1 < this.PageCount)
			{
				this.OnPageIndexChanged(new DataGridPageChangedEventArgs(this, this.PageCount - 1));
			}
		}

		#endregion

		#region Métodos
		/// <summary>
		/// Altera alguns caracteres criticos para o browser
		/// </summary>
		/// <param name="Text">Texto a ser alterado</param>
		/// <returns></returns>
		private string FixStringToBrowser(string Text)
		{
			Text = Text.Replace("\"", "&quot;");
			Text = Text.Replace("<", "&lt;");
			Text = Text.Replace(">", "&gt;");

			return Text;
		}

		/// <summary>
		/// Adicão de linhas em Lopes na grid para preencher o total de linhas da página
		/// </summary>
		private void AddBlankRows()
		{
			//----------------------------------------------------------------
			// Nº de linhas a adicionar
			//----------------------------------------------------------------
			int BlankRowsToAdd = this.PageSize - this.Items.Count;

			//----------------------------------------------------------------
			// Iteração para inserção das linhas
			//----------------------------------------------------------------
			for (int row = 1; row <= BlankRowsToAdd; row++)
			{
				DataGridItem item = new DataGridItem(0, 0, (this.Items.Count + row) % 2 == 1 ? ListItemType.Item : ListItemType.AlternatingItem);

				//----------------------------------------------------------------
				// Mostar a mensagem a dizer q não foram encontrados registos
				//----------------------------------------------------------------
				if(this.Items.Count == 0 && this.ShowMessageNoRecordsFound && row == 1)
				{
					TableCell cell;
					for (int col = 0; col < this.Columns.Count; col++) 
					{
						if (this.Columns[col].Visible) 
						{
							cell = new TableCell();
							cell.Attributes.Add("align", "center");
							cell.Attributes.Add("colspan", (this.Columns.Count - col).ToString());
							cell.Controls.Add(new LiteralControl("<P align='center'><B>" + this.MessageNoRecordsFound + "</B></P>"));
							item.Cells.Add(cell);
							break;
						}
						else 
						{
							cell = new TableCell();
							cell.Controls.Add(new LiteralControl("&nbsp;"));
							item.Cells.Add(cell);
						}
					}
				}
				else
				{
					//------------------------------------------------------------
					// Iteração para inserção das células
					//------------------------------------------------------------
					for (int col = 0; col < this.Columns.Count; col++)
					{
						TableCell cell = new TableCell();
						cell.Controls.Add(new LiteralControl("&nbsp;"));
						item.Cells.Add(cell);
					}
				}
				((Table)this.Controls[0]).Rows.Add(item);
			}
		}

		#endregion

		#region Overrides

		/// <summary>
		/// Override do método OnInit
		/// </summary>
		/// <param name="e"></param>
		protected override void OnInit(EventArgs e)
		{
			this.ItemCreated += new DataGridItemEventHandler(this.OnItemCreated);

			base.OnInit (e);
		}

		/// <summary>
		/// The ItemDataBound event is raised after an item is data bound to the DataGrid
		/// control. This event provides you with the last opportunity to access the data
		/// item before it is displayed on the client. After this event is raised, the data
		/// item is nulled out and no longer available. - .NET Framework Class Library
		/// </summary>
		/// <param name="e"></param>
		protected override void OnItemDataBound(DataGridItemEventArgs e)
		{
			base.OnItemDataBound (e);
 
			switch (e.Item.ItemType)
			{
				case ListItemType.Item:
				case ListItemType.AlternatingItem:
				case ListItemType.EditItem:
				case ListItemType.SelectedItem:
				case ListItemType.Footer:
				case ListItemType.Pager:  

					TableCellCollection cCells = e.Item.Cells;
					foreach (TableCell tc in cCells)
					{
						if (tc.Controls.Count > 0)
						{
							foreach (Control ctrl in tc.Controls)
							{
								if (ctrl is HyperLink)
								{
									HyperLink hLnk = (HyperLink)ctrl;

									if (hLnk.Text.Length > 0)
										hLnk.Text = this.FixStringToBrowser(hLnk.Text);
								}
								else if (ctrl is LinkButton)
								{
									LinkButton lButton = (LinkButton)ctrl;

									if (lButton.Text.Length > 0)
										lButton.Text = this.FixStringToBrowser(lButton.Text);
								}
								else if (ctrl is Button)
								{
									Button cButton = (Button)ctrl;

									if (cButton.Text.Length > 0)
										cButton.Text = this.FixStringToBrowser(cButton.Text);
								}
							}
						} 
						else 
						{              
							// there are no controls in the table cell
							if (tc.Text.Length > 0) 
							{
								if ("&nbsp;" != tc.Text) 
									tc.Text = this.FixStringToBrowser(tc.Text);
							}
						}
					}
					break;
				default:
					break;
			}
		}

		/// <summary>
		/// Override do método Render da Grid
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//------------------------------------------------------------
			// Definição das classes para formatação da DataGrid
			//------------------------------------------------------------
			if(base.CssClass == string.Empty)
				base.CssClass = "OWDataGrid";

			base.SelectedItemStyle.CssClass = "SelectedItemStyle";
			base.EditItemStyle.CssClass = "EditItemStyle";
			base.AlternatingItemStyle.CssClass = "AlternatingItemStyle";
			base.ItemStyle.CssClass = "ItemStyle";
			base.HeaderStyle.CssClass = "HeaderStyle";
			base.FooterStyle.CssClass = "FooterStyle";
			base.PagerStyle.CssClass = "PagerStyle";

			//------------------------------------------------------------
			// Caso as adição de linhas em Lopes não esteja activa, então
			// se a grid não tiver registos é substituída por uma mensagem
			// a informar do sucedido
			//------------------------------------------------------------
			if (this.Items.Count == 0 && !this.ShowBlankRows)
			{
				output.Write("<P align='center'><B>" + this.MessageNoRecordsFound + "</B></P>");
			}
			else
			{
				//------------------------------------------------------------
				// Se só existe uma página, então o item de paginação é escondido
				//------------------------------------------------------------
				this.PagerStyle.Visible = this.PagerAlwaysVisible || this.PageCount > 1;
				
				//------------------------------------------------------------
				// Render base do controlo
				//------------------------------------------------------------
				base.Render(output);
			}
		}

		#endregion
	}
}
