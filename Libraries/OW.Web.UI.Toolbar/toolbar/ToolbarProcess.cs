using System;
using System.Drawing;
using System.Web.UI.WebControls;


namespace OW.Web.UI.Toolbar
{
	/// <summary>
	/// Toolbar para tramitação de processos
	/// </summary>
	public class ToolbarProcess : Toolbar
	{
		public ToolbarProcess(){}

		/// <summary>
		/// Nome do campo do form associado ao Código do Grupo
		/// </summary>
		private string GroupCodeField
		{
			get
			{
				return this.ClientID + "_GroupCode";
			}
		}

		/// <summary>
		/// Nome do campo do form associado ao Código do Membro
		/// </summary>
		private string MemberCodeField
		{
			get
			{
				return this.ClientID + "_MemberCode";
			}
		}

		/// <summary>
		/// Indica se o item Complete está escondido
		/// </summary>
		public bool CompleteHidden
		{
			get { return !this.Items["Complete"].Visible; }
			set { this.Items["Complete"].Visible = !value; }
		}

		/// <summary>
		/// Indica se o item Transfer está escondido
		/// </summary>
		public bool TransferHidden
		{
			get { return !this.Items["Transfer"].Visible; }
			set { this.Items["Transfer"].Visible = !value; }
		}

		/// <summary>
		/// Indica se o item RequestForComments está escondido
		/// </summary>
		public bool RequestForCommentsHidden
		{
			get { return !this.Items["RequestForComments"].Visible; }
			set { this.Items["RequestForComments"].Visible = !value; }
		}

		/// <summary>
		/// Indica se o item Save está escondido
		/// </summary>
		public bool SaveHidden
		{
			get { return !this.Items["Save"].Visible; }
			set { this.Items["Save"].Visible = !value; }
		}

		/// <summary>
		/// Indica se o item Abort está escondido
		/// </summary>
		public bool AbortHidden
		{
			get { return !this.Items["Abort"].Visible; }
			set { this.Items["Abort"].Visible = !value; }
		}

		/// <summary>
		/// Indica se não estamos a considerar um passo
		/// </summary>
		public bool NoStep
		{
			get
			{
				if (ViewState["PageToolbarNoStep"] == null)
				{
					return false;
				}
				else
				{
					return (bool)ViewState["PageToolbarNoStep"];
				}
			}
			set
			{
				ViewState["PageToolbarNoStep"] = value;
			}
		}

		/// <summary>
		/// Indica se o step é redefinivel
		/// </summary>
		public bool IsRedifinable
		{
			get
			{
				if (ViewState["PageToolbarIsRedifinable"] == null)
				{
					return false;
				}
				else
				{
					return (bool)ViewState["PageToolbarIsRedifinable"];
				}
			}
			set
			{
				ViewState["PageToolbarIsRedifinable"] = value;
			}
		}

		/// <summary>
		/// Indica se é o primeiro passo do processo
		/// </summary>
		public bool IsFirstStep
		{
			get
			{
				if (ViewState["PageToolbarIsFirstStep"] == null)
				{
					return false;
				}
				else
				{
					return (bool)ViewState["PageToolbarIsFirstStep"];
				}
			}
			set
			{
				ViewState["PageToolbarIsFirstStep"] = value;
			}
		}

		/// <summary>
		/// Indica se só é possível transferir para o mesmo nível
		/// </summary>
		public bool IsTransferNivel
		{
			get
			{
				if (ViewState["PageToolbarIsTransferNivel"] == null)
				{
					return false;
				}
				else
				{
					return (bool)ViewState["PageToolbarIsTransferNivel"];
				}
			}
			set
			{
				ViewState["PageToolbarIsTransferNivel"] = value;
			}
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

			this.Page.RegisterHiddenField(this.GroupCodeField, "0");

			this.Page.RegisterHiddenField(this.MemberCodeField, "0");

			base.OnInit (e);
		}

		/// <summary>
		/// Código do Grupo seleccionado em Transfer ou RequestForComments
		/// </summary>
		public int GroupCode
		{
			get
			{
				return int.Parse(this.Page.Request.Form[this.GroupCodeField]);
			}
		}

		/// <summary>
		/// Código do Membro seleccionado em Transfer ou RequestForComments
		/// </summary>
		public int MemberCode
		{
			get
			{
				return int.Parse(this.Page.Request.Form[this.MemberCodeField]);
			}
		}

		/// <summary>
		/// Adição dos Items na ToolBar
		/// </summary>
		private void AddDefaultItems()
		{

			//paulo
			ToolbarButton itemNone = (ToolbarButton)this.Items["None"];

			ToolbarButton itemBack = (ToolbarButton)this.Items["Back"];			

			ToolbarButton itemAbort = (ToolbarButton)this.Items["Abort"];			

			ToolbarButton itemSave = (ToolbarButton)this.Items["Save"];			

			ToolbarButton itemRequestForComments = (ToolbarButton)this.Items["RequestForComments"];			

			ToolbarButton itemTransfer = (ToolbarButton)this.Items["Transfer"];			

			ToolbarButton itemComplete = (ToolbarButton)this.Items["Complete"];			


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

			itemNone.HorizontalAlign = HorizontalAlign.Left;

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
			// ItemAbort
			//----------------------------------------------------------------
			if (itemAbort == null) 
			{
				itemAbort = new ToolbarButton();
				this.Items.Insert(0, itemAbort);
			}

			itemAbort.LabelText = " Abortar";

			itemAbort.ItemId = "Abort";

			itemAbort.ImageUrl = "~/design/image/actionbar/Abort.gif";

			itemAbort.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemAbort.HorizontalAlign = HorizontalAlign.Left;

			itemAbort.CauseValidation = false;

			itemAbort.ClientScript = "return window.confirm('Deseja abortar o processo?');";

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

			itemSave.CauseValidation = false;

			itemSave.ClientScript = "return window.confirm('Deseja gravar a informação da actividade?');";

			//----------------------------------------------------------------
			// ItemRequestForComments
			//----------------------------------------------------------------
			if (itemRequestForComments == null) 
			{
				itemRequestForComments = new ToolbarButton();
				this.Items.Insert(0, itemRequestForComments);
			}

			itemRequestForComments.LabelText = " Parecer";

			itemRequestForComments.ItemId = "RequestForComments";

			itemRequestForComments.ImageUrl = "~/design/image/actionbar/RequestForComments.gif";

			itemRequestForComments.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemRequestForComments.HorizontalAlign = HorizontalAlign.Left;

			itemRequestForComments.CauseValidation = false;

			//----------------------------------------------------------------
			// ItemTransfer
			//----------------------------------------------------------------
			if (itemTransfer == null) 
			{
				itemTransfer = new ToolbarButton();
				this.Items.Insert(0, itemTransfer);
			}

			itemTransfer.LabelText = " Tranferir";

			itemTransfer.ItemId = "Transfer";

			itemTransfer.ImageUrl = "~/design/image/actionbar/Transfer.gif";

			itemTransfer.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemTransfer.HorizontalAlign = HorizontalAlign.Left;

			itemTransfer.CauseValidation = false;

			itemTransfer.ClientScript = "var ret=selectGroupMember();if(ret==null) return false;";

			//----------------------------------------------------------------
			// ItemComplete
			//----------------------------------------------------------------
			if (itemComplete == null) 
			{
				itemComplete = new ToolbarButton();
				this.Items.Insert(0, itemComplete);
			}

			itemComplete.LabelText = " Completar";

			itemComplete.ItemId = "Complete";

			itemComplete.ImageUrl = "~/design/image/actionbar/Complete.gif";

			itemComplete.ItemCellDistance = new Unit(1, UnitType.Percentage);

			itemComplete.HorizontalAlign = HorizontalAlign.Left;

			itemComplete.CauseValidation = true;

			itemComplete.ClientScript = "return window.confirm('Deseja completar a actividade?');";

		}

		/// <summary>
		/// Configuração do Workflow da Toolbar consoante a Actividade
		/// </summary>
		public void SetToolbarWorkflow()
		{
			if (this.NoStep)
			{
				this.HideWorkflowActions();
			}
			else
			{
				//--------------------------------------------------------------------
				// Se o step não for definivel então Tranfer e RequestForComments ficam escondidos
				//--------------------------------------------------------------------
				this.Items["Transfer"].Visible = this.IsRedifinable;
				this.Items["RequestForComments"].Visible = this.IsRedifinable;

				//--------------------------------------------------------------------
				// Se for o primeiro passo do processo, então o Abort fica escondido
				//--------------------------------------------------------------------
				if (this.IsFirstStep) 
				{
					this.Items["Abort"].Visible = false;
				}
				else
				{
					this.Items["Abort"].Visible = true;
				}

				//--------------------------------------------------------------------
				// Verifica se a janela da selecção do Grupo/Membro apenas tem o grupo 
				// do utilizador corrente.
				// O argumento da função selectGroupmember é true ou false
				//--------------------------------------------------------------------
				((ToolbarButton)this.Items["Transfer"]).ClientScript = "var ret=selectGroupMember(" + this.IsTransferNivel.ToString().ToLower() + "); if(ret==null) return false; else {" + this.GroupCodeField + ".value = ret.GroupCode; " + this.MemberCodeField + ".value = ret.MemberCode;}";
				((ToolbarButton)this.Items["RequestForComments"]).ClientScript = "var ret=selectGroupMember(" + this.IsTransferNivel.ToString().ToLower() + "); if(ret==null) return false; else {" + this.GroupCodeField + ".value = ret.GroupCode; " + this.MemberCodeField + ".value = ret.MemberCode;}";
			}
		}

		/// <summary>
		/// Esconde as acções de Workflow da toolbar
		/// </summary>
		public void HideWorkflowActions()
		{
			this.Items["Abort"].Visible = false;			

			this.Items["Save"].Visible = false;		

			this.Items["RequestForComments"].Visible = false;			

			this.Items["Transfer"].Visible = false;		

			this.Items["Complete"].Visible = false;		
		}
	}
}
