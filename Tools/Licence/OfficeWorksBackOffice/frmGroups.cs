using System;
using System.Collections.Specialized;
using System.Data;
using System.DirectoryServices;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using OfficeWorks.Access;
using OfficeWorks.Global;
using OfficeWorks.OfficeWorksBackOffice;

namespace OfficeWorks.OfficeWorksBackOffice
{
	/// <summary>
	/// Summary description for frmGroups.
	/// </summary>
	public class frmGroups : System.Windows.Forms.Form
	{
		private System.Windows.Forms.ListBox lstGroups;
		private System.Windows.Forms.Button btnNew;
		private System.Windows.Forms.ComboBox ddDomain;
		private System.Windows.Forms.Label lblDomain;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public frmGroups()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

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

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.lstGroups = new System.Windows.Forms.ListBox();
			this.btnNew = new System.Windows.Forms.Button();
			this.ddDomain = new System.Windows.Forms.ComboBox();
			this.lblDomain = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// lstGroups
			// 
			this.lstGroups.Location = new System.Drawing.Point(24, 64);
			this.lstGroups.Name = "lstGroups";
			this.lstGroups.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
			this.lstGroups.Size = new System.Drawing.Size(440, 290);
			this.lstGroups.TabIndex = 1;
			// 
			// btnNew
			// 
			this.btnNew.Location = new System.Drawing.Point(16, 368);
			this.btnNew.Name = "btnNew";
			this.btnNew.TabIndex = 2;
			this.btnNew.Text = "Inserir";
			this.btnNew.Click += new System.EventHandler(this.btnNew_Click);
			// 
			// ddDomain
			// 
			this.ddDomain.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.ddDomain.Location = new System.Drawing.Point(56, 8);
			this.ddDomain.Name = "ddDomain";
			this.ddDomain.Size = new System.Drawing.Size(376, 21);
			this.ddDomain.TabIndex = 7;
			this.ddDomain.SelectedIndexChanged += new System.EventHandler(this.ddDomain_SelectedIndexChanged);
			// 
			// lblDomain
			// 
			this.lblDomain.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lblDomain.Location = new System.Drawing.Point(0, 8);
			this.lblDomain.Name = "lblDomain";
			this.lblDomain.Size = new System.Drawing.Size(72, 16);
			this.lblDomain.TabIndex = 6;
			this.lblDomain.Text = "Domínio:";
			// 
			// frmGroups
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(488, 413);
			this.Controls.Add(this.ddDomain);
			this.Controls.Add(this.lblDomain);
			this.Controls.Add(this.btnNew);
			this.Controls.Add(this.lstGroups);
			this.Name = "frmGroups";
			this.Text = "OfficeWorks BackOffice";
			this.Load += new System.EventHandler(this.frmGroups_Load);
			this.ResumeLayout(false);

		}
		#endregion


		/// <summary>
		/// Set OfficeWorks Group Users from active directory
		/// </summary>
		private void SetGroupUsers(string GroupName)
		{
			
			
		}


		/// <summary>
		/// Insert new selected groups in OfficeWorks
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnNew_Click(object sender, System.EventArgs e)
		{
			// Add new group
			OfficeWorks.Access.DB oAccess = new OfficeWorks.Access.DB();
			
			if (lstGroups.Items.Count<1)
			{
				MessageBox.Show("Escolha um domínio.");
				return;
			}
			// If no user selected
			if (lstGroups.SelectedItems.Count<1)
			{
				
				MessageBox.Show("Escolha um grupo.");
				return;
			}

			// Add new groups
			for (int i=0; i< lstGroups.SelectedItems.Count;i++)
			{
				string strGroupName = Convert.ToString(lstGroups.SelectedItems[i]);
				// Create the new group
				oAccess.SetGroupInfo(strGroupName,(int) GENERIC_VALUES.NO_VALUE);
			}

			// Add Groups Users
			for (int i=0; i< lstGroups.SelectedItems.Count;i++)
			{
				string strGroupName = Convert.ToString(lstGroups.SelectedItems[i]);
				// Create the new group
				StringCollection GroupUsers= Global.GetGroupMembers(ddDomain.Text,strGroupName);
				string GU = "";
				for (i = 0; i < GroupUsers.Count; i++)
				{
					
					GU +=  GroupUsers[i].ToString();
				}
				//oAccess.SetGroupInfo(strGroupName,(int) GENERIC_VALUES.NO_VALUE);
			}



		}

		/// <summary>
		/// Get active directory groups
		/// </summary>
		private void frmGroups_Load(object sender, System.EventArgs e)
		{
			Global.GetADDomains(ddDomain);
		}

		/// <summary>
		/// Fill groups listbox
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ddDomain_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			this.Cursor = Cursors.WaitCursor;
			GetADGroups(ddDomain.Text);
			this.Cursor = Cursors.Arrow;
		}
	

		/// <summary>
		/// Get groups from a specified domain
		/// </summary>
		private void GetADGroups(string strDomain)
		{
			try
			{
				System.DirectoryServices.DirectoryEntry entry = new System.DirectoryServices.DirectoryEntry("LDAP://" + strDomain);
				entry.AuthenticationType = AuthenticationTypes.Secure;
				System.DirectoryServices.DirectorySearcher mySearcher = 
					new System.DirectoryServices.DirectorySearcher(entry);
				mySearcher.Filter = "(&(objectCategory=group))";

				System.DirectoryServices.SortOption sortOption = new
					System.DirectoryServices.SortOption("name",
					System.DirectoryServices.SortDirection.Ascending);
				mySearcher.Sort = sortOption;
				
				lstGroups.Items.Clear();
				AccessManager objAccess = new AccessManager();
				DataTable objTable = objAccess.GetGroups();
				objTable.DefaultView.Sort = "GroupDesc";

				foreach(System.DirectoryServices.SearchResult resEnt in mySearcher.FindAll())
				{
					try
					{
						System.DirectoryServices.DirectoryEntry de=resEnt.GetDirectoryEntry();

						// Get group name
						string strGroupName = de.Properties["name"].Value.ToString();
						// Verify if group allready exists on OfficeWorks						
						int RowNum = objTable.DefaultView.Find(strGroupName);

						// If group does no exists
						if (RowNum == -1)
						{
							lstGroups.Items.Add(strGroupName);
						}
					}
					catch(Exception ex)
					{
						OfficeWorksException.WriteEventLog(ex.Message);
					}

				}
			}
			catch(Exception ex)
			{
				OfficeWorksException.WriteEventLog(ex.Message);
			}
		}
	}
}
