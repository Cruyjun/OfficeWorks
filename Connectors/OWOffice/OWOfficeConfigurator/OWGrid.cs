using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Windows.Forms;

namespace OfficeWorks.OWOffice
{	

	/// <summary>
	/// Summary description for OWGrid.
	/// </summary>
	public class OWGrid : System.Windows.Forms.UserControl
	{
		#region DECLARATION
		//******************************************************************************
		
		#region ListViewItemComparer SUBCLASS

		/// <summary>
		/// Implements the manual sorting of items by columns.
		/// </summary>
		class ListViewItemComparer : IComparer
		{	
			
			private int col;
			public ListViewItemComparer() 
			{
				col=0;
			}
			public ListViewItemComparer(int column) 
			{
				col=column;
			}
			public int Compare(object x, object y) 
			{
				return String.Compare(((ListViewItem)x).SubItems[col].Text, ((ListViewItem)y).SubItems[col].Text);
			}
		}
		#endregion


		#region ValidateEditedLabelArgs SUBCLASS
		public class ValidateEditedLabelArgs
		{
			private string _Label = "";
			public string Label 
			{
				set{	_Label = value;	}
				get{	return _Label;	}
			}
			private bool _Cancel = false;
			public bool Cancel
			{
				set {	_Cancel = value;	}
				get {	return _Cancel;		}
			}
			private int _Index = -1;
			public int Index
			{				
				set {	_Index = value;		}
				get {	return _Index;		}
			}
		}
		#endregion

		public delegate void RowEventHandler(int Index, OWGrid Grid);
		public delegate void ValidateEditedLabelHandler(ValidateEditedLabelArgs e);
		public event ValidateEditedLabelHandler onRowEdit;//Validates the Label when it is edited
		public event RowEventHandler onRowInsert;
		public event RowEventHandler onRowClick;
		public event RowEventHandler onRowDelete;				
		
		#region ItemOrganizerEnum SUBCLASS
		//***************************************************************************

		public class ItemOrganizerEnum : IEnumerator
		{
			private ListView _oView = null;
			public ItemOrganizerEnum(ListView oView)
			{
				_oView = oView;
			}

			#region IEnumerator Members			
			int _iIndex = -1;
			

			public void Reset()
			{
				// TODO:  Add ItemOrganizer.Reset implementation
				_iIndex = -1;
			}

			public object Current
			{
				get
				{
					// TODO:  Add ItemOrganizer.Current getter implementation					
					if (_iIndex < 0 || _iIndex >= _oView.Items.Count)
						return null;					
					
					return _oView.Items[_iIndex].Tag;
				}
			}

			public bool MoveNext()
			{
				// TODO:  Add ItemOrganizer.MoveNext implementation
				_iIndex++;
				
				if (_iIndex < 0 || _iIndex >= _oView.Items.Count)					
					return false;
								
				return true;
			}

			#endregion

		}


		#endregion//*****************************************************************

		#region ItemOrganizer SUBCLASS
		//***************************************************************************

		public class ItemOrganizer
		{
			private ListView _oView = null;
			public ItemOrganizer(ListView oView)
			{
				_oView = oView;
			}

			public object this [int Index]
			{
				get{return _oView.Items[Index].Tag;}
				set{_oView.Items[Index].Tag = value;}
			}

			public int Count
			{
				get {return _oView.Items.Count;}
			}

			public IEnumerator GetEnumerator()
			{
				return new ItemOrganizerEnum(_oView);
			}
			
		}


		#endregion//*****************************************************************
				
		private ListView oView = null;
		private ToolTip oToolTip = null;
		private ArrayList oRowBag = new ArrayList();		
		private ItemOrganizer _ObjectItems = null;
		public ItemOrganizer ObjectItems 
		{
			get{return _ObjectItems;}							
		}


		


		#endregion//*******************************************************************


		#region CONSTROCTORS 
		//*****************************************************************************

		public OWGrid()
		{
			// This call is required by the Windows.Forms Form Designer.
			InitializeComponent();

			// TODO: Add any initialization after the InitializeComponent call			
			oView = new ListView();
			_ObjectItems = new ItemOrganizer(oView);
		}


		#endregion//*******************************************************************

		
		#region Component Designer generated code
		/// <summary> 
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		/// <summary> 
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}


		/// <summary> 
		/// Required method for Designer support - do not modify 
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			// 
			// OWGrid
			// 
			this.Name = "OWGrid";
			this.Size = new System.Drawing.Size(192, 80);
			this.Load += new System.EventHandler(this.OWGrid_Load);
			this.SizeChanged += new System.EventHandler(this.OWGrid_Resize);

		}
		#endregion


		#region PROPERTIES
		//******************************************************************************
		
		private bool _OrderByHeaderClick = true;
		public bool OrderByHeaderClick
		{
			set {_OrderByHeaderClick = value;}
			get {return _OrderByHeaderClick;}
		}


		private string _EditAttribute = "";
		public string EditAttribute
		{
			set {_EditAttribute = value;}
			get {return _EditAttribute;}
		}
		
		

		public int SelectedIndex
		{
			set
			{
				if (value!=-1)
				oView.Items[value].Selected=true;
			}
			get
			{
				return (oView.SelectedIndices.Count==0?-1:oView.SelectedIndices.Count);
			}
		}
		

		public bool LabelEdit
		{
			set{oView.LabelEdit = value;}
			get{return oView.LabelEdit;}
		}



		public bool InvalidRows
		{
			set{oToolTip.Active = value;}
			get{return oToolTip.Active;}
		}		



		public string ToolTip
		{
			set
			{				
				oToolTip.SetToolTip(oView,value);
				oToolTip.Active = (value.Trim().Length>0);					
			}			
		}		

		#endregion//****************************************************************************


		#region METHODS
		//*******************************************************************************




		private void OWGrid_Load(object sender, System.EventArgs e)
		{
			// Set the view to show details.
			oView.View = View.Details;
			// Allow the user to edit item text.
			oView.LabelEdit = true;
			// Allow the user to rearrange columns.
			oView.AllowColumnReorder = false;
			// Display check boxes.
			oView.CheckBoxes = false;
			// Select the item and subitems when selection is made.
			oView.FullRowSelect = true;
			// Display grid lines.
			oView.GridLines = true;
			// Sort the items in the list in ascending order.
			oView.Sorting = SortOrder.None;								

			oView.SelectedIndexChanged += new EventHandler(this.oView_SelectedIndexChanged);
			
			// Grid Size
			oView.Width=this.Width;
			oView.Height=this.Height;
			
			// Grid Edit Handlers
			oView.AfterLabelEdit += new System.Windows.Forms.LabelEditEventHandler(this.oView_AfterLabelEdit);												
			oView.BeforeLabelEdit +=new System.Windows.Forms.LabelEditEventHandler(this.oView_BeforeLabelEdit);	
			oView.KeyDown +=new System.Windows.Forms.KeyEventHandler (this.oView_KeyDown);	

			// For the order by column
			oView.ColumnClick += new ColumnClickEventHandler(this.oView_ColumnClick);

			//Create a Tooltip
			oToolTip = new ToolTip();

			this.Controls.Add(oView);

		}


		private void OWGrid_Resize(object sender, System.EventArgs e)
		{
			// Grid Size
			oView.Width=this.Width;
			oView.Height=this.Height;							
		}
		
		
		private void oView_SelectedIndexChanged(object sender, EventArgs e )
		{
			onRowClick((oView.SelectedIndices.Count==0?-1:oView.SelectedIndices[0]),this);
		}

		
		private void oView_ColumnClick(object sender, ColumnClickEventArgs e )
		{
			Sort(e.Column);			
		}

		public void Sort(int ColumnIndex)
		{	
			if (oView.Columns.Count!=0)
			{
				//Clear order Mark
				foreach(ColumnHeader oCol in oView.Columns)
					oCol.Text = oCol.Text.Replace ("  ^","");
				//set Order Mark			
				oView.Columns[ColumnIndex].Text += "  ^";
			}
			//Sort the view
			oView.ListViewItemSorter = new ListViewItemComparer(ColumnIndex);
			oView.Sorting = SortOrder.None;
			oView.Sort();			
		}

		private void oView_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e )
		{
			if (e.KeyCode == Keys.F2 && oView.SelectedIndices.Count!=0)
				oView.Items[oView.SelectedIndices[0]].BeginEdit();
		}
		private void oView_BeforeLabelEdit(object sender, System.Windows.Forms.LabelEditEventArgs e )
		{				
			if (_EditAttribute.Length > 0)
			{//object is a class
				System.Reflection.PropertyInfo oPInf = oView.Items[e.Item].Tag.GetType().GetProperty(_EditAttribute);		
				if (oView.Items[e.Item].SubItems[0].Text != (string) oPInf.GetValue(oView.Items[e.Item].Tag,null))
				{
					oView.Items[e.Item].SubItems[0].Text = (string) oPInf.GetValue(oView.Items[e.Item].Tag,null);									
					SendKeys.Send(oView.Items[e.Item].SubItems[0].Text + "+{HOME}");
				}				
			}
		
		}


		private void oView_AfterLabelEdit(object sender, System.Windows.Forms.LabelEditEventArgs e )
		{	
			System.Reflection.PropertyInfo oPInf = null ;
			string sOldLabel = "";

			e.CancelEdit = true;//cancel allways, let me control the changes						
			
			//Get Old label
			if (_EditAttribute.Length > 0)
			{//object is a class
				oPInf = oView.Items[e.Item].Tag.GetType().GetProperty(_EditAttribute);			
				sOldLabel = (string) oPInf.GetValue(oView.Items[e.Item].Tag,null);
			}
			else//object is a string
				sOldLabel = (string) oView.Items[e.Item].Tag;

			// validate Label text. raise event onRowEdit
			ValidateEditedLabelArgs Mye = new ValidateEditedLabelArgs();
			Mye.Label = (e.Label == null || e.Label.Length == 0 ? sOldLabel : e.Label);
			Mye.Index = e.Item;
			onRowEdit(Mye);	//raise event
			
			//change the lable manualy (set the old value if case)
			oView.Items[e.Item].Text = Mye.Label;

			//if cancel then exit
			if (Mye.Cancel)				
				return;					
			

			//Upadate Object data Tag for the current Row
			if (_EditAttribute.Length > 0)
				oPInf.SetValue(oView.Items[e.Item].Tag,	(e.Label==null || e.Label.Length==0 ?	sOldLabel	:	e.Label	)	,null);	//object is a class
			else
				oView.Items[e.Item].Tag = (e.Label==null || e.Label.Length==0 ?	sOldLabel	:	e.Label	);			//object is a string
			//Sort List
			oView.Sort();
		}



		/// <summary>
		/// Clear the all items from the Grid
		/// </summary>
		public  void Clear()
		{			
			oView.Items.Clear();
		}

		

		public void AddRow(string[] sValues, object oToSave, bool bRaiseRowInsertEvent)
		{	
			ListViewItem  oItem = new ListViewItem(sValues[0]);			
			for(int iX=1;iX<sValues.Length;iX++)			
				oItem.SubItems.Add(sValues[iX]);
			
			//Object tobe saved in Grid's Row
			oItem.Tag = oToSave;
			//Add Row
			oView.Items.Add(oItem);				
			
			if (bRaiseRowInsertEvent)
				onRowInsert(oView.Items.IndexOf(oItem),this);
		}		


		public void SetColumnWidth(int iColIndex, int iColWidth)
		{
			oView.Columns[iColIndex].Width=iColWidth;		
		}


		public void SetColumns(string[] sColumns)
		{
			oView.Columns.Add(sColumns[0], -2, HorizontalAlignment.Center);			
			for(int iX=1;iX<sColumns.Length;iX++)
			{
				// Create columns for the items and subitems.				
				oView.Columns.Add(sColumns[iX], -2, HorizontalAlignment.Center);
			}

			foreach(ColumnHeader oCol in oView.Columns)
				oCol.Width=(oView.Width/oView.Columns.Count);

			// Set the sort order by first column
			Sort(0);
		}


		public void RemoveSelectedRow()
		{
			foreach(ListViewItem oItem in oView.SelectedItems)
			{
				oView.Items.Remove(oItem);
				onRowDelete(oItem.Index,this);								
			}
		}


		public void MarkRow(int iIndex, bool bBGMark, bool bTextMark)
		{
            if (oView.Items.Count <= iIndex)
				return;
			oView.Items[iIndex].BackColor = (bBGMark ? System.Drawing.Color.Red : System.Drawing.Color.White);
			oView.Items[iIndex].ForeColor = (bTextMark ? System.Drawing.Color.Blue : System.Drawing.Color.Black);									
		}





		#endregion//***************************************************************************

	}
}
