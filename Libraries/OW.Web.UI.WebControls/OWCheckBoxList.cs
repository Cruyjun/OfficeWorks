using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWCheckBoxList.
	/// </summary>
	[ValidationProperty("Text")]
	public class OWCheckBoxList : CheckBoxList, IEPWebControl, IRepeatInfoUser
	{
		private CheckBox controlToRepeat;
		
		#region Properties
		/// <summary>
		/// Valor do Controlo
		/// </summary>
		public string Text
		{
			get
			{
				int count = 0;
				foreach (ListItem l in this.Items)
				{
					if (l.Selected) count++;
				}
				return (count>0?count.ToString():string.Empty);
			}
		}

		/// <summary>
		/// Indica se o campo está em modo de consulta
		/// </summary>
		public bool ReadOnly
		{
			get
			{
				return !this.Enabled;
			}
			set
			{
				this.Enabled = !value;
			}
		}
		#endregion

		#region Constructors
		/// <summary>
		/// Constructor
		/// </summary>
		public OWCheckBoxList()
		{
			this.controlToRepeat = new CheckBox();
			this.controlToRepeat.ID = "0";
			this.controlToRepeat.EnableViewState = false;
			this.Controls.Add(this.controlToRepeat);
		}
		#endregion

		#region Overrides
		/// <summary>
		/// Override do SaveViewState
		/// </summary>
		/// <returns></returns>
		protected override object SaveViewState()
		{
			// Create an object array with one element for the CheckBoxList's
			// ViewState contents, and one element for each ListItem in CheckBoxList
			object [] state = new object[this.Items.Count + 1];

			object baseState = base.SaveViewState();
			state[0] = baseState;

			// Now, see if we even need to save the view state
			bool itemHasAttributes = false;
			for (int i = 0; i < this.Items.Count; i++)
			{
				if (this.Items[i].Attributes.Count > 0)
				{
					itemHasAttributes = true;
					
					// Create an array of the item's Attribute's keys and values
					object [] attribKV = new object[this.Items[i].Attributes.Count * 2];
					int k = 0;
					foreach(string key in this.Items[i].Attributes.Keys)
					{
						attribKV[k++] = key;
						attribKV[k++] = this.Items[i].Attributes[key];
					}

					state[i+1] = attribKV;
				}
			}

			// return either baseState or state, depending on whether or not
			// any ListItems had attributes
			if (itemHasAttributes)
				return state;
			else
				return baseState;
		}

		/// <summary>
		/// Override do LoadViewState
		/// </summary>
		/// <param name="savedState"></param>
		protected override void LoadViewState(object savedState)
		{
			if (savedState == null) return;

			// see if savedState is an object or object array
			if (savedState is object[])
			{
				// we have an array of items with attributes
				object [] state = (object[]) savedState;
				base.LoadViewState(state[0]);	// load the base state

				for (int i = 1; i < state.Length; i++)
				{
					if (state[i] != null)
					{
						// Load back in the attributes
						object [] attribKV = (object[]) state[i];
						for (int k = 0; k < attribKV.Length; k += 2)
							this.Items[i-1].Attributes.Add(attribKV[k].ToString(), attribKV[k+1].ToString());
					}
				}
			}
			else
				// we have just the base state
				base.LoadViewState(savedState);
		}

		/// <summary>
		/// OnPreRender
		/// </summary>
		/// <param name="e"></param>
		protected override void OnPreRender(EventArgs e)
		{
			this.controlToRepeat.AutoPostBack = this.AutoPostBack;
			if (this.Page != null)
			{
				for (int num1 = 0; num1 < this.Items.Count; num1++)
				{
					this.controlToRepeat.ID = num1.ToString(NumberFormatInfo.InvariantInfo);
					this.Page.RegisterRequiresPostBack(this.controlToRepeat);
					// Adicionar nos atributos quando o item está seleccionado.
					if (this.Items[num1].Selected) this.Items[num1].Attributes.Add(num1.ToString(),this.Items[num1].Selected.ToString());
					// Quando está definido nos atributos o item fica seleccionado.
					if (this.Items[num1].Attributes.Count>0) 
						foreach(string key in this.Items[num1].Attributes.Keys)
						{
							if (key == num1.ToString() && (Convert.ToBoolean(this.Items[num1].Attributes[key])==true))
								this.Items[num1].Selected=true;
						}
				}
			}
		}

		/// <summary>
		/// Render do controlo
		/// </summary>
		/// <param name="writer"></param>
		protected override void Render(HtmlTextWriter writer)
		{
			base.CssClass = "OWCheckBoxList";
			RepeatInfo info1 = new RepeatInfo();
			Style style1 = base.ControlStyleCreated ? base.ControlStyle : null;
			short num1 = this.TabIndex;
			bool flag1 = false;
			this.controlToRepeat.TabIndex = num1;
			if (num1 != 0)
			{
				if (!this.ViewState.IsItemDirty("TabIndex"))
				{
					flag1 = true;
				}
				this.TabIndex = 0;
			}
			info1.RepeatColumns = this.RepeatColumns;
			info1.RepeatDirection = this.RepeatDirection;
			info1.RepeatLayout = this.RepeatLayout;
			info1.RenderRepeater(writer, this, style1, this);
			if (num1 != 0)
			{
				this.TabIndex = num1;
			}
			if (flag1)
			{
				this.ViewState.SetItemDirty("TabIndex", false);
			}
		}
		#endregion

		#region Methods
		/// <summary>
		/// Limpa o conteúdo do campo
		/// </summary>
		public void ClearData()
		{
			foreach (ListItem l in this.Items)
			{
				l.Selected = false;
			}
		}
		#endregion

		#region IRepeatInfoUser Members
		public bool HasHeader
		{
			get
			{
				// TODO:  Add CheckBoxList.HasHeader getter implementation
				return false;
			}
		}

		public bool HasSeparators
		{
			get
			{
				// TODO:  Add CheckBoxList.HasSeparators getter implementation
				return false;
			}
		}

		public bool HasFooter
		{
			get
			{
				// TODO:  Add CheckBoxList.HasFooter getter implementation
				return false;
			}
		}

		public void RenderItem(System.Web.UI.WebControls.ListItemType itemType, int repeatIndex, RepeatInfo repeatInfo, HtmlTextWriter writer)
		{
			this.controlToRepeat.ID = repeatIndex.ToString(NumberFormatInfo.InvariantInfo);
			this.controlToRepeat.Text = this.Items[repeatIndex].Text;
			this.controlToRepeat.TextAlign = this.TextAlign;
			this.controlToRepeat.Checked = this.Items[repeatIndex].Selected;
			this.controlToRepeat.Enabled = this.Enabled;
			this.controlToRepeat.Attributes.Clear();
			foreach (string key in this.Items[repeatIndex].Attributes.Keys)
				this.controlToRepeat.Attributes.Add(key, this.Items[repeatIndex].Attributes[key]);
			this.controlToRepeat.RenderControl(writer);
		}

		public Style GetItemStyle(System.Web.UI.WebControls.ListItemType itemType, int repeatIndex)
		{
			// TODO:  Add CheckBoxList.GetItemStyle implementation
			return null;
		}

		public int RepeatedItemCount
		{
			get
			{
				// TODO:  Add CheckBoxList.RepeatedItemCount getter implementation
				return this.Items.Count;
			}
		}
		#endregion
	}
}
