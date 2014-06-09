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
		// As funcionalidades de Clear, Remove, InsertAt, RemoveAt não estão
		// a prever a existencia do Primeiro Item pelo que poderão ter comportamentos
		// não desejados. É necessário revêr as funcionalidades acima referidas
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
		/// Pesquisa avançada de item por digitação
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
		/// Indica se o campo está em modo de consulta
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
		/// NÃO APAGAR. PARA TESTES
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
		/// Implementação do Render do controlo
		/// </summary>
		/// <param name="output"></param>
		protected override void Render(HtmlTextWriter output)
		{
			//--------------------------------------------------------------------
			// Definição da classe CSS
			//--------------------------------------------------------------------
			base.CssClass = "OWDropDownList";

			//--------------------------------------------------------------------
			// Implementação do comportamento de pesquisa na digitação
			//--------------------------------------------------------------------
			if (this.AdvancedSearch)
			{
				// O script não está a ser criado
				//this.Attributes.Add("onkeyup", "findString(this,1500)"); 
			}
			
			//--------------------------------------------------------------------
			// Implementação do comportamento ReadOnly
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
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			if (this.Items.Count > 0) this.SelectedIndex = 0;
		}

		/// <summary>
		/// Construção do item inicial da lista
		/// </summary>
		private void BuildFirstItem()
		{
			//--------------------------------------------------------------------
			// Inserção do Item Inicial
			//--------------------------------------------------------------------
			ListItem li = new ListItem();

			li.Value = string.Empty;

			bool insertLine = true;

			switch (this.ItemType)
			{
				case ItemTypeEnum.itemAll:
					if (this.Items != null && this.Items.Count>0 &&
							// Nota: Só suporta PT e EN (Melhorar)
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
							// Nota: Só suporta PT e EN (Melhorar)
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
			/// Mostra somente os dados que são carregados
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
