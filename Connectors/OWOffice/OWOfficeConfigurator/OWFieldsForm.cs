using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using OfficeWorks.OWOffice.Configuration;

namespace OfficeWorks.OWOffice
{
	/// <summary>
	/// Summary description for OWFieldsForm.
	/// </summary>
	public class OWFieldsForm : System.Windows.Forms.Form
	{	


	
		#region DECLARATIONS
		/********************************************************************************/
		/********************************************************************************/
		/**************************        DECLARATIONS      ****************************/
		/********************************************************************************/
		/********************************************************************************/		


		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.ListBox listOfficeWorksFieldsTMP = null;
		private System.Windows.Forms.ListBox listOfficeWorksFields;		
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.RadioButton radioButton2;
		private System.Windows.Forms.RadioButton radioButton1;
		private System.Windows.Forms.Button btnAdd;
		private System.Windows.Forms.Button btnCancel;
		private System.Windows.Forms.Label Lbls;
		private System.Windows.Forms.TextBox txtBookmark;
		private System.Windows.Forms.Label label1;
		private string _msgbox_title = "";
		private System.Windows.Forms.CheckBox chkRequired;
		
		/// <summary>
		/// OfficeWorks fields to be excluded from list
		/// </summary>		 
		private enumFieldName[] eNotUniqueFields = new enumFieldName[]
			{
				enumFieldName.FieldNameMoreEntities				
			};


		public class FormList
		{
			#region DECLARATIONS
			/********************************************************************************/
			/********************************************************************************/
			/**************************        DECLARATIONS      ****************************/
			/********************************************************************************/
			/********************************************************************************/

			/// <summary>
			/// OfficeWorks fields to be excluded from list
			/// </summary>		 
			private enumFieldName[] eFieldsToBeExclude = new enumFieldName[]
			{
				enumFieldName.FieldNameAccesses,
				enumFieldName.FieldNamePreviousRegistry,
				enumFieldName.FieldNameDistributions,
				enumFieldName.FieldNameFiles,
				enumFieldName.FieldNameBook,
				enumFieldName.FieldNameDocumentType,				
				enumFieldName.FieldNameClassification,
				enumFieldName.FieldNameKeywords,
				enumFieldName.FieldNameFundo,
				enumFieldName.FieldNameSerie,
				enumFieldName.FieldNameBCUnit,
				enumFieldName.FieldNameLocFisica,
				enumFieldName.FieldNameProdEntity,
				enumFieldName.FieldNameActiveDate,
				enumFieldName.FieldNameBCRegistry
			};

			private ListBox _ListBox = null;

			#endregion			
			
			#region CONSTROCTORS
			/********************************************************************************/
			/********************************************************************************/
			/**************************        CONSTROCTORS      ****************************/
			/********************************************************************************/
			/********************************************************************************/
			public FormList(ListBox List)
			{
				_ListBox = List;
			}

			#endregion

			#region PROPERTIES
			/********************************************************************************/
			/********************************************************************************/
			/**************************        PROPERTIES      ******************************/
			/********************************************************************************/
			/********************************************************************************/
			 

			public ListBox.ObjectCollection Items
			{
				get {	return _ListBox.Items;	}
			}



			public bool Sorted
			{
				get {	return _ListBox.Sorted;	}
				set {	_ListBox.Sorted = value;	}
			}
			#endregion

			#region METHODS
			/********************************************************************************/
			/********************************************************************************/
			/**************************        METHODS     **********************************/
			/********************************************************************************/
			/********************************************************************************/
			public void Add(object Item)
			{
				//if is an invalid field exit without adding
				foreach (enumFieldName eField in eFieldsToBeExclude)
					if ((long)eField == (long)((ListViewItem)Item).Tag)
						return;

				_ListBox.Items.Add(Item);
			}




			public void Clear()
			{
				_ListBox.Items.Clear();				
			}


			#endregion

		}
		
		

		#endregion

		#region Windows Form Designer generated code
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
			this.listOfficeWorksFields = new System.Windows.Forms.ListBox();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.radioButton2 = new System.Windows.Forms.RadioButton();
			this.radioButton1 = new System.Windows.Forms.RadioButton();
			this.btnAdd = new System.Windows.Forms.Button();
			this.btnCancel = new System.Windows.Forms.Button();
			this.txtBookmark = new System.Windows.Forms.TextBox();
			this.Lbls = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.chkRequired = new System.Windows.Forms.CheckBox();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// listOfficeWorksFields
			// 
			this.listOfficeWorksFields.DisplayMember = "Text";
			this.listOfficeWorksFields.Location = new System.Drawing.Point(16, 32);
			this.listOfficeWorksFields.Name = "listOfficeWorksFields";
			this.listOfficeWorksFields.Size = new System.Drawing.Size(224, 160);
			this.listOfficeWorksFields.TabIndex = 74;
			this.listOfficeWorksFields.SelectedIndexChanged += new System.EventHandler(this.listOfficeWorksFields_SelectedIndexChanged);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.radioButton2);
			this.groupBox1.Controls.Add(this.radioButton1);
			this.groupBox1.Enabled = false;
			this.groupBox1.Location = new System.Drawing.Point(24, 200);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(216, 48);
			this.groupBox1.TabIndex = 77;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Tipo de Entidade";
			// 
			// radioButton2
			// 
			this.radioButton2.Location = new System.Drawing.Point(112, 16);
			this.radioButton2.Name = "radioButton2";
			this.radioButton2.Size = new System.Drawing.Size(64, 24);
			this.radioButton2.TabIndex = 78;
			this.radioButton2.Text = "Destino";
			// 
			// radioButton1
			// 
			this.radioButton1.Checked = true;
			this.radioButton1.Location = new System.Drawing.Point(32, 16);
			this.radioButton1.Name = "radioButton1";
			this.radioButton1.Size = new System.Drawing.Size(64, 24);
			this.radioButton1.TabIndex = 77;
			this.radioButton1.TabStop = true;
			this.radioButton1.Text = "Origem";
			// 
			// btnAdd
			// 
			this.btnAdd.Location = new System.Drawing.Point(48, 336);
			this.btnAdd.Name = "btnAdd";
			this.btnAdd.TabIndex = 78;
			this.btnAdd.Text = "&Confirmar";
			this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(136, 336);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.TabIndex = 79;
			this.btnCancel.Text = "C&ancelar";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// txtBookmark
			// 
			this.txtBookmark.Location = new System.Drawing.Point(24, 296);
			this.txtBookmark.Name = "txtBookmark";
			this.txtBookmark.Size = new System.Drawing.Size(216, 20);
			this.txtBookmark.TabIndex = 80;
			this.txtBookmark.Text = "";						
			this.txtBookmark.Validating += new CancelEventHandler(this.txtBookmark_Validating);
			
			// 
			// Lbls
			// 
			this.Lbls.Location = new System.Drawing.Point(24, 280);
			this.Lbls.Name = "Lbls";
			this.Lbls.Size = new System.Drawing.Size(100, 16);
			this.Lbls.TabIndex = 81;
			this.Lbls.Text = "Bookmark:";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(16, 16);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(100, 16);
			this.label1.TabIndex = 82;
			this.label1.Text = "Campos OfficeWorks:";
			// 
			// chkRequired
			// 
			this.chkRequired.Location = new System.Drawing.Point(64, 256);
			this.chkRequired.Name = "chkRequired";
			this.chkRequired.Size = new System.Drawing.Size(120, 24);
			this.chkRequired.TabIndex = 83;
			this.chkRequired.Text = "Campo Obrigatório";
			// 
			// OWFieldsForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(258, 367);
			this.Controls.Add(this.chkRequired);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.Lbls);
			this.Controls.Add(this.txtBookmark);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.btnAdd);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.listOfficeWorksFields);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.Name = "OWFieldsForm";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "OWFieldsForm";
			this.Load += new System.EventHandler(this.OWFieldsForm_Load);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		#region CONSTROCTORS
		/********************************************************************************/
		/********************************************************************************/
		/**************************        CONSTROCTORS      ****************************/
		/********************************************************************************/
		/********************************************************************************/


		public OWFieldsForm(OWGrid OfficeWorksMappGrid, string msgbox_title)
		{			
			InitializeComponent();			

			//SET Mapping Grid
			_MappingGrid = OfficeWorksMappGrid;
			
			//SET MessageBox Title
			_msgbox_title = msgbox_title;			
			
			//SET _FormList Class to control the listOfficeWorksFields ListBox
			listOfficeWorksFieldsTMP = new ListBox();
			_FormList =  new FormList(listOfficeWorksFieldsTMP);	
		}



		#endregion

		#region PROPERTIES
		/********************************************************************************/
		/********************************************************************************/
		/**************************        PROPERTIES      ******************************/
		/********************************************************************************/
		/********************************************************************************/



		private FormList _FormList = null;
		public FormList Fields
		{
			get {return _FormList;}
		}




		
		private OWGrid _MappingGrid = null;
		public OWGrid MappingGrid
		{
			set {_MappingGrid = value;}
			get {return _MappingGrid;}
		}

		#endregion	

		#region METHODS


		/********************************************************************************/
		/********************************************************************************/
		/**************************        METHODS     **********************************/
		/********************************************************************************/
		/********************************************************************************/


		private void btnCancel_Click(object sender, System.EventArgs e)
		{		
			ResetForm();
			this.Hide();
		}


		private void btnAdd_Click(object sender, System.EventArgs e)
		{
			string BookmarkCaption = ""; //text that appears in bookmark list


			//Validate source data
			
			//have to select List Item
			if (listOfficeWorksFields.SelectedItem==null)
			{
				MessageBox.Show("Tem que seleccionar um campo da lista!",_msgbox_title);
				return;
			}
			//have to select Bookmark
			if (txtBookmark.Text.Trim().Length==0)
			{
				MessageBox.Show("O campo Bookmark é obrigatório!",_msgbox_title);
				return;
			}
			//Bookmark already in use
			if (IsBookMarkInMappGrid(txtBookmark.Text))
			{
				MessageBox.Show("Bookmark já existente!",_msgbox_title);
				return;
			}
			
			//Insert New Item
			MappedField oNewMapping = new MappedField();
			oNewMapping.BookmarkName = txtBookmark.Text;	
			BookmarkCaption = oNewMapping.BookmarkName;
			oNewMapping.FieldIdentifier = Convert.ToInt32(((ListViewItem)listOfficeWorksFields.SelectedItem).Tag);
			oNewMapping.FieldName = ((ListViewItem)listOfficeWorksFields.SelectedItem).Text;
			oNewMapping.RequiredField = chkRequired.Checked;
			
			//if Entity field then set the Entity Type			
			if (groupBox1.Enabled)
			{
				oNewMapping.EntityType = (radioButton1.Checked	?	enumEntityType.EntityTypeOrigin	:	enumEntityType.EntityTypeDestiny);
				BookmarkCaption += " [" + (radioButton1.Checked? "Origem" : "Destino") + "]";
			}
			
			//Add Row
			_MappingGrid.AddRow(new string[]{BookmarkCaption, oNewMapping.FieldName},oNewMapping,true);
			
			//set row RequiredField color
			 _MappingGrid.MarkRow((_MappingGrid.ObjectItems.Count-1), false, oNewMapping.RequiredField);

			//reset Form
			ResetForm();
			//Hide me
			this.Hide();
		}


		private void listOfficeWorksFields_SelectedIndexChanged(object sender, System.EventArgs e)
		{

			if (listOfficeWorksFields.SelectedItem!=null)
			{
				ListViewItem oItem = (ListViewItem) listOfficeWorksFields.SelectedItem;
				//Format Bookmark Name only alfa chars and no spaces
				txtBookmark.Text = FormatBookmarkName(oItem.Text);				

				if ((long)oItem.Tag == (long)enumFieldName.FieldNameMoreEntities)
				{
					radioButton1.Checked=true;
					groupBox1.Enabled = true;					
				}
				else
				{
					radioButton1.Checked=true;
					groupBox1.Enabled = false;
				}				
			}
		}		
		
		/// <summary>
		/// Format Bookmark Name only alfa chars and no spaces
		/// </summary>
		/// <param name="BookmarkName">BookmarkName</param>
		/// <returns>Formated BookmarkName string</returns>
		public static string FormatBookmarkName( string BookmarkName)
		{
			BookmarkName = BookmarkName.ToUpper();
			//A
			BookmarkName = BookmarkName.Replace("Á","A");
			BookmarkName = BookmarkName.Replace("À","A");
			BookmarkName = BookmarkName.Replace("Â","A");
			BookmarkName = BookmarkName.Replace("Ã","A");
			BookmarkName = BookmarkName.Replace("Ä","A");
			//E
			BookmarkName = BookmarkName.Replace("É","E");
			BookmarkName = BookmarkName.Replace("È","E");
			BookmarkName = BookmarkName.Replace("Ê","E");			
			BookmarkName = BookmarkName.Replace("Ë","E");
			//I
			BookmarkName = BookmarkName.Replace("Í","I");
			BookmarkName = BookmarkName.Replace("Ì","I");
			BookmarkName = BookmarkName.Replace("Î","I");			
			BookmarkName = BookmarkName.Replace("Ï","I");
			//O
			BookmarkName = BookmarkName.Replace("Ó","O");
			BookmarkName = BookmarkName.Replace("Ò","O");
			BookmarkName = BookmarkName.Replace("Ô","O");
			BookmarkName = BookmarkName.Replace("Õ","O");
			BookmarkName = BookmarkName.Replace("Ö","O");
			//U
			BookmarkName = BookmarkName.Replace("Ú","U");
			BookmarkName = BookmarkName.Replace("Ù","U");
			BookmarkName = BookmarkName.Replace("Û","U");			
			BookmarkName = BookmarkName.Replace("Ü","U");

			//Ç
			BookmarkName = BookmarkName.Replace("Ç","C");

			
			//Remove all non alfa chars
			foreach(char c in BookmarkName)			
				if (!char.IsLetter(c))
					BookmarkName = BookmarkName.Replace(c.ToString(),"");
			
			return BookmarkName;
		
		}



		private void OWFieldsForm_Load(object sender, System.EventArgs e)
		{
			OfficeWorksFielsFilter();						
		}


		private void txtBookmark_Validating(object sender, CancelEventArgs e)
		{
			if (txtBookmark.Text.ToUpper() != FormatBookmarkName(txtBookmark.Text))
			{
				MessageBox.Show("A Bookmark escolhida contém caracteres inválidos!",_msgbox_title);
				e.Cancel = true;		
			}
		}
		
		
		/// <summary>
		/// Reset all Form data
		/// </summary>
		private void ResetForm()
		{		
			//Clear Objects
			listOfficeWorksFields.ClearSelected();
			txtBookmark.Text="";
			radioButton1.Checked=true;
			groupBox1.Enabled = false;
			chkRequired.Checked = false;
		}
				

		/// <summary>
		/// Filter all the fields in OfficeWorksFields List that already exists in Mapping Grid and aren´t Unique
		/// </summary>
		private void OfficeWorksFielsFilter()
		{		
			//Reset List Items
			listOfficeWorksFields.Items.Clear();
			bool bIsUnique = true;
			bool bIsInMappGrid = false;
			foreach (ListViewItem oItem in listOfficeWorksFieldsTMP.Items)
			{
				bIsUnique = true;
				
				//if the Mapping List is empty, all the fiels are valid				
				bIsUnique = IsUniqueField((long) oItem.Tag);					
				bIsInMappGrid = IsFieldInMappGrid((long) oItem.Tag);					

				//if isn't Unique or doesn't exist in MappGrid, add to list
				if (!bIsUnique || (bIsUnique && !bIsInMappGrid))
					listOfficeWorksFields.Items.Add(oItem);
			}
		}



		/// <summary>
		/// Test if Fields ID already exists in Mapping Grid return true
		/// </summary>
		/// <param name="lFieldID">Fields ID to test</param>
		/// <returns>bool</returns>
		private bool IsFieldInMappGrid(long lFieldID)
		{			
			foreach (MappedField oMapping in _MappingGrid.ObjectItems)								 				
				if (Convert.ToInt64(oMapping.FieldIdentifier) == lFieldID)				
					return true;
			return false;
		}


		/// <summary>
		/// Test if sBookMark already exists in Mapping Grid return true
		/// </summary>
		/// <param name="sBookMark">BookMark to test</param>
		/// <returns>bool</returns>
		private bool IsBookMarkInMappGrid(string sBookMark)
		{			
			foreach (MappedField oMapping in _MappingGrid.ObjectItems)								 				
				if (oMapping.BookmarkName.ToUpper().Trim() == sBookMark.ToUpper().Trim())				
					return true;
			return false;
		}


		/// <summary>
		/// Test if the Fields ID is Unique
		/// </summary>
		/// <param name="lFieldID">Fields ID to test</param>
		/// <returns></returns>
		private bool IsUniqueField(long lFieldID)
		{
			foreach (enumFieldName eField in eNotUniqueFields)						
				if (lFieldID == (long) eField)					
					return false;
				
			return true;
		}

		
		
		

		#endregion

		
		
		




	}
}
