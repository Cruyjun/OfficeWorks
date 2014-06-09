using System;
using System.Collections;
using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OW.Web.UI.WebControls
{
	/// <summary>
	/// Summary description for OWTabStrip.
	/// </summary>
	[DefaultProperty("Text"), ToolboxData("<{0}:OWTabStrip runat=server></{0}:OWTabStrip>")]
	public class OWTabStrip : WebControl, INamingContainer 
	{

		//[Serializable]public delegate void EPTabSelectEventHandler(object sender, EPTabSelectedEventArgs e);


		/// <summary>
		/// Evento correspondente � selec��o de um Tab
		/// </summary>
		public event EventHandler TabSelected;


		/// <summary>
		/// Controlo base do OWTabStrip
		/// </summary>
		HtmlGenericControl div;
		

		/// <summary>
		/// Colec��o de items do controlo
		/// </summary>
		private OWTabStripItemCollection _TabStripItems;


		[DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
		public OWTabStripItemCollection TabStripItems
		{
			get
			{
				//if (_TabStripItems == null) _TabStripItems = new OWTabStripItemCollection();
				return _TabStripItems;
			}
			set
			{
				_TabStripItems = value;
			}
		}

		
		/// <summary>
		/// Cria��o dos controlos filhos do OWTabStrip 
		/// </summary>
		protected override void CreateChildControls()
		{

			if (TabStripItems != null)
			{
				if (TabStripItems.Count > 0)
				{
					
					div = new HtmlGenericControl("div"); 
					
					div.Attributes.Add("class", "taMenu");
					
					this.Controls.Add(div);

					HtmlGenericControl ul = new HtmlGenericControl("ul"); 

					div.Controls.Add(ul);

					foreach (OWTabStripItem item in TabStripItems)
					{
						HtmlGenericControl li = new HtmlGenericControl("li");

						ul.Controls.Add(li);
						
						if (item.Selected) li.ID = "current"; else li.ID = "";

						OWLinkButton link = new OWLinkButton();
						
						link.Click += new EventHandler(this.TabClick);
						
						li.Controls.Add(link);

						HtmlGenericControl span = new HtmlGenericControl("span");

						span.InnerText = item.Description;

						link.Controls.Add(span);

					}

				}

			}

		}


		/// <summary> 
		/// Render this control to the output parameter specified.
		/// </summary>
		/// <param name="output"> The HTML writer to write out to </param>
		protected override void Render(HtmlTextWriter output)
		{
			
			if (TabStripItems != null)
			{
				if (TabStripItems.Count > 0)
				{
					div.RenderControl(output);
				}
				else output.Write(ResX.GetString("NoTabDefined"));
			}
			else output.Write(ResX.GetString("NoTabDefined"));
		}


		/// <summary>
		/// Event Handler para a ac��o Send
		/// </summary>
		/// <remarks>
		/// Permite activar os eventos OnSetComplete, OnTransfer ou OnRequestForComments
		/// consoante a op��o seleccionada 
		/// </remarks>
		protected void TabClick(object sender, EventArgs e)
		{
			TabSelected.Invoke(this, e);
		}

	}

	/// <summary>
	/// Item do controlo TabStrip
	/// </summary>
	[Serializable]public class OWTabStripItem
	{
		public string Description;

		public bool Selected;

		public Control AssociatedControl;
	}

	[Serializable]public class OWTabStripItemCollection : CollectionBase
	{
		/// <summary>
		/// Implementa��o do metodo Add
		/// </summary>
		/// <param name="newItem">
		/// Objecto do tipo ePRForwarding
		/// </param>
		public void Add(OWTabStripItem newItem)
		{
			this.List.Add(newItem);
		}
		
		/// <summary>
		/// Implementa��o do metodo Insert
		/// </summary>
		/// <param name="index">
		/// ind�ce onde se quer inserir o item
		/// </param>
		/// <param name="newItem">
		/// Objecto do tipo OWTabStripItem
		/// </param>
		public void Insert(int index, OWTabStripItem newItem)
		{
			this.List.Insert(index,newItem);
		}

		/// <summary>
		/// Implementa��o do m�todo Remove
		/// </summary>
		/// <param name="index">
		/// Inteiro que referencia o indice do objecto a remover na colec��o.
		/// </param>
		public void Remove(int index)
		{
			this.List.RemoveAt(index);
		}

		/// <summary>
		/// Implementa��o da propriedade Item, que nos permite aceder aos objectos guardados na colec��o
		/// </summary>
		/// <param name="index">
		/// Inteiro que referencia o indice do objecto que queremos consultar
		/// </param>
		/// <returns>
		/// Objecto do tipo ePRForwarding que � referenciado pelo indice passado como parametro
		/// </returns>
		public OWTabStripItem Item(int index)
		{
			return (OWTabStripItem) this.List[index];
		}
	}

	public sealed class EPTabSelectedEventArgs : EventArgs
	{
		public OWTabStripItem Item;
	}

}
