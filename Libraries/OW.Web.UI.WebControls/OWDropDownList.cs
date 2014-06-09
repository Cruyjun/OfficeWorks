using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// System.Web.UI.WebControls.DropDownList extendida
	/// </summary>
	public class OWDropDownList : DropDownList, IEPWebControl
	{
		// ---------------------------------------------------------------------
		// ricardo da Gerreiro em 2006-01-20
		// IMPORTANTE
		// As funcionalidades de Clear, Remove, InsertAt, RemoveAt n�o est�o
		// a prever a existencia do Primeiro Item pelo que poder�o ter comportamentos
		// n�o desejados. � necess�rio rev�r as funcionalidades acima referidas
		// ---------------------------------------------------------------------

		#region Properties

		/// <summary>
		/// Tipo do item inicial da lista
		/// </summary>
		public ItemTypeEnum ItemType
		{
			get
			{
				object obj = this.ViewState["ItemType"];				
				return obj == null ? ItemTypeEnum.itemOnlyData : (ItemTypeEnum)obj;
			}
			set
			{
				this.ViewState["ItemType"] = value;
			}
		}

		/// <summary>
		/// Pesquisa avan�ada de item por digita��o
		/// </summary>
		public bool AdvancedSearch
		{
			get
			{
				object obj = this.ViewState["AdvancedSearch"];				
				return obj == null ? true : (bool)obj;
			}
			set
			{
				this.ViewState["AdvancedSearch"] = value;
			}
		}

		/// <summary>
		/// Indica se o campo est� em modo de consulta
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

		#endregion
		
		#region Overrides


		/// <summary>
		/// Devolve o valor seleccionado no formato inteiro
		/// </summary>
		/// N�O APAGAR. PARA TESTES
//		public int Value
//		{
//			get 
//			{ 
//				return this.SelectedValue == string.Empty ? Common.Configuration.NullValueInt32 : Convert.ToInt32(this.SelectedValue); 
//			}
//			set 
//			{ 
//				this.SelectedValue = value == Common.Configuration.NullValueInt32 ? string.Empty : value.ToString(); 
//			}
//		}

		/// <summary>
		/// Depois do DataBind vai ser criado novamente o primeiro item
		/// </summary>
		public override void DataBind()
		{
			base.DataBind ();

			this.BuildFirstItem();
		}

		/// <summary>
		/// Cria o primeiro item no OnLoad
		/// </summary>
		/// <param name="e"></param>
		protected override void OnLoad(EventArgs e)
		{
			this.BuildFirstItem();

			base.OnLoad (e);
		}

		/// <summary>
		/// Cria o primeiro item no OnInit
		/// </summary>
		/// <param name="e"></param>
		protected override void OnInit(EventArgs e)
		{
			this.BuildFirstItem();

			base.OnInit (e);
		}

		/// <summary>
		/// Implementa��o do Render do controlo
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//--------------------------------------------------------------------
			// Defini��o da classe CSS
			//--------------------------------------------------------------------
			base.CssClass = "OWDropDownList";

			//--------------------------------------------------------------------
			// Implementa��o do comportamento de pesquisa na digita��o
			//--------------------------------------------------------------------
			if (this.AdvancedSearch)
			{
				// O script n�o est� a ser criado
				//this.Attributes.Add("onkeyup", "findString(this,1500)"); 
			}
			
			//--------------------------------------------------------------------
			// Implementa��o do comportamento ReadOnly
			//--------------------------------------------------------------------
			if (this.ReadOnly)
			{
				string CTRLStyle = string.Format("WIDTH:{0}; HEIGHT:{1}", base.Width.ToString(), base.Height.ToString());

				string ReadOnlyLabel = base.SelectedItem == null ? string.Empty : FixStringToBrowser(base.SelectedItem.Text);

				output.Write(string.Format("<SPAN style='{0}' class='{1}'>{2}</SPAN>", CTRLStyle, CssClass, ReadOnlyLabel));
			}			
			else
			{
				base.Render(output);
			}

		}

		#endregion

		#region Methods

		/// <summary>
		/// Limpa o conte�do do campo
		/// </summary>
		public void ClearData()
		{
			if (this.Items.Count > 0) this.SelectedIndex = 0;
		}

		/// <summary>
		/// Constru��o do item inicial da lista
		/// </summary>
		private void BuildFirstItem()
		{
			//--------------------------------------------------------------------
			// Inser��o do Item Inicial
			//--------------------------------------------------------------------
			ListItem li = new ListItem();

			li.Value = string.Empty;

			bool insertLine = true;

			switch (this.ItemType)
			{
				case ItemTypeEnum.itemAll:
					if (this.Items != null && this.Items.Count>0 &&
							// Nota: S� suporta PT e EN (Melhorar)
							(this.Items[0].Text == "<Todos>" ||
							this.Items[0].Text == "<All>"
						)
					)
					{
						if (ResX.GetSelectedCulture().StartsWith("pt"))
							this.Items[0].Text = "<Todos>";
						else 
							this.Items[0].Text = "<All>";

						insertLine = false;
						break;
					}
					if (ResX.GetSelectedCulture().StartsWith("pt"))
						li.Text = "<Todos>";
					else 
						li.Text = "<All>";
					break;

				case ItemTypeEnum.itemSelect: 
					if (this.Items != null && this.Items.Count>0 && 
							// Nota: S� suporta PT e EN (Melhorar)
							(this.Items[0].Text == "<Seleccione>" ||
							this.Items[0].Text == "<Select>"
						)
					)
					{
						if (ResX.GetSelectedCulture().StartsWith("pt"))
							this.Items[0].Text = "<Seleccione>";
						else 
							this.Items[0].Text = "<Select>";
						insertLine = false;
						break;
					}
					if (ResX.GetSelectedCulture().StartsWith("pt"))
						li.Text = "<Seleccione>";
					else 
						li.Text = "<Select>";
					break;

				case ItemTypeEnum.itemEmpty: 
					if (this.Items != null && this.Items.Count>0 && this.Items[0].Text == string.Empty)
					{
						insertLine = false;
						break;
					}
					li.Text = string.Empty;
					break;

				default: 
					insertLine = false;
					break;
			}

			if (insertLine) this.Items.Insert(0, li);
		}
		
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

		#endregion

		#region Enumerations

		/// <summary>
		/// Tipo Enumerado comportamento da lista (Acrescenta uma linha no index = 0)
		/// </summary>
		public enum ItemTypeEnum
		{
			/// <summary>
			/// Mostra somente os dados que s�o carregados
			/// </summary>
			itemOnlyData = 0,

			/// <summary>
			/// Acrescenta uma linha com value = 0 e com texto = "Todos"
			/// </summary>
			itemAll		= 1,

			/// <summary>
			/// Acrescenta uma linha com value = 0 e com texto = "Seleccione"
			/// </summary>
			itemSelect	= 2,

			/// <summary>
			/// Semelhante ao Default
			/// </summary>
			itemEmpty	= 3,
		}

		#endregion

	}
}
