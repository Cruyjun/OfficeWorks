using System;
using System.ComponentModel;
using System.Data;
using System.DirectoryServices;
using System.Windows.Forms;
using OfficeWorks.Access;
using OfficeWorks.Global;

namespace OfficeWorks.OfficeWorksBackOffice
{
	/// <summary>
	/// OfficeWorks BackOffice Main Form.
	/// </summary>
	public class frmMain : Form
	{
		private ListBox lstUsers;
		private Button btnNewUser;
		private Button btnExit;
		private MainMenu mainMenu1;
		private MenuItem menuItem1;
		private MenuItem menuItem2;
		private MenuItem menuItem3;
		private MenuItem menuItem4;
		private Label lblDomain;
		private ComboBox ddDomain;
		private Button btnClean;
		private MenuItem menuItem5;
		private Button btnNext;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private Container components = null;

		public frmMain()
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
				if (components != null) 
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(frmMain));
			this.lstUsers = new System.Windows.Forms.ListBox();
			this.btnNewUser = new System.Windows.Forms.Button();
			this.btnExit = new System.Windows.Forms.Button();
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.menuItem4 = new System.Windows.Forms.MenuItem();
			this.menuItem2 = new System.Windows.Forms.MenuItem();
			this.menuItem3 = new System.Windows.Forms.MenuItem();
			this.lblDomain = new System.Windows.Forms.Label();
			this.ddDomain = new System.Windows.Forms.ComboBox();
			this.btnClean = new System.Windows.Forms.Button();
			this.btnNext = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// lstUsers
			// 
			this.lstUsers.Location = new System.Drawing.Point(0, 32);
			this.lstUsers.Name = "lstUsers";
			this.lstUsers.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple;
			this.lstUsers.Size = new System.Drawing.Size(440, 290);
			this.lstUsers.TabIndex = 0;
			// 
			// btnNewUser
			// 
			this.btnNewUser.Location = new System.Drawing.Point(8, 328);
			this.btnNewUser.Name = "btnNewUser";
			this.btnNewUser.TabIndex = 2;
			this.btnNewUser.Text = "Inserir";
			this.btnNewUser.Click += new System.EventHandler(this.btnNewUser_Click);
			// 
			// btnExit
			// 
			this.btnExit.Location = new System.Drawing.Point(360, 328);
			this.btnExit.Name = "btnExit";
			this.btnExit.TabIndex = 3;
			this.btnExit.Text = "Sair";
			this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem1,
																					  this.menuItem2});
			// 
			// menuItem1
			// 
			this.menuItem1.Index = 0;
			this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem5,
																					  this.menuItem4});
			this.menuItem1.Text = "&Ficheiro";
			// 
			// menuItem5
			// 
			this.menuItem5.Index = 0;
			this.menuItem5.Text = "&Grupos";
			this.menuItem5.Click += new System.EventHandler(this.menuItem5_Click);
			// 
			// menuItem4
			// 
			this.menuItem4.Index = 1;
			this.menuItem4.Text = "Sair";
			this.menuItem4.Click += new System.EventHandler(this.menuItem4_Click);
			// 
			// menuItem2
			// 
			this.menuItem2.Index = 1;
			this.menuItem2.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuItem3});
			this.menuItem2.Text = "&Ajuda";
			// 
			// menuItem3
			// 
			this.menuItem3.Index = 0;
			this.menuItem3.Text = "&Sobre";
			this.menuItem3.Click += new System.EventHandler(this.menuItem3_Click);
			// 
			// lblDomain
			// 
			this.lblDomain.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lblDomain.Location = new System.Drawing.Point(0, 8);
			this.lblDomain.Name = "lblDomain";
			this.lblDomain.Size = new System.Drawing.Size(72, 16);
			this.lblDomain.TabIndex = 4;
			this.lblDomain.Text = "Domínio:";
			// 
			// ddDomain
			// 
			this.ddDomain.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.ddDomain.Location = new System.Drawing.Point(56, 8);
			this.ddDomain.Name = "ddDomain";
			this.ddDomain.Size = new System.Drawing.Size(376, 21);
			this.ddDomain.TabIndex = 5;
			this.ddDomain.SelectedIndexChanged += new System.EventHandler(this.ddDomain_SelectedIndexChanged);
			// 
			// btnClean
			// 
			this.btnClean.Location = new System.Drawing.Point(88, 328);
			this.btnClean.Name = "btnClean";
			this.btnClean.TabIndex = 6;
			this.btnClean.Text = "Limpar";
			this.btnClean.Click += new System.EventHandler(this.btnClean_Click);
			// 
			// btnNext
			// 
			this.btnNext.Location = new System.Drawing.Point(280, 328);
			this.btnNext.Name = "btnNext";
			this.btnNext.TabIndex = 7;
			this.btnNext.Text = "Seguinte >>";
			this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
			// 
			// frmMain
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(440, 353);
			this.Controls.Add(this.btnNext);
			this.Controls.Add(this.btnClean);
			this.Controls.Add(this.ddDomain);
			this.Controls.Add(this.lblDomain);
			this.Controls.Add(this.btnExit);
			this.Controls.Add(this.btnNewUser);
			this.Controls.Add(this.lstUsers);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Menu = this.mainMenu1;
			this.Name = "frmMain";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "OfficeWorks BackOffice";
			this.Load += new System.EventHandler(this.frmMain_Load);
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new frmMain());
		}

		private void btnGetUsers_Click(object sender, EventArgs e)
		{
				GetADDomainUsers("OWDEV");
		}


		/// <summary>
		/// Get users from a specified domain
		/// </summary>
		private void GetADDomainUsers(string strDomain)
		{
			try
			{
				DirectoryEntry entry = new DirectoryEntry("LDAP://" + strDomain);
				entry.AuthenticationType = AuthenticationTypes.Secure;
				DirectorySearcher mySearcher = new DirectorySearcher(entry);
				mySearcher.SearchScope = SearchScope.Subtree;
				mySearcher.Filter = ("(&(objectCategory=person)(objectClass=user))");
				// Fix: Without this line, only 1000 users were returned 
				// by the search
				mySearcher.PageSize = 10;
				//mySearcher.SizeLimit = 0;							
				SortOption sortOption = new
				SortOption("sAMAccountName",
					           SortDirection.Ascending);
				mySearcher.Sort = sortOption;

				lstUsers.Items.Clear();
				User objUser = null;
				DataTable objTable = null;

				SearchResultCollection UsersColl = mySearcher.FindAll();
				foreach(SearchResult resEnt in UsersColl)
				{
					try
					{
						DirectoryEntry de=resEnt.GetDirectoryEntry();

						//Check user
						string strUser = de.Properties["sAMAccountName"].Value.ToString();

						objUser = new User();
						objUser.UserDomain = strDomain;
						objUser.UserLogin = strUser;
						objTable = objUser.GetUser();
						
						if (objTable.Rows.Count == 0)
							lstUsers.Items.Add(strUser);
						
						objTable = null;
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

		private void btnNewUser_Click(object sender, EventArgs e)
		{
			if (lstUsers.Items.Count<1)
			{
				MessageBox.Show("Escolha um domínio.");
				return;
			}
			// If no user selected
			if (lstUsers.SelectedItems.Count<1)
			{
				
				MessageBox.Show("Escolha um utilizador.");
				return;
			}
			for (int i=0; i< lstUsers.SelectedItems.Count;i++)
			{

				string strUser = Convert.ToString(lstUsers.SelectedItems[i]);
				GetADUser(ddDomain.Text,strUser);
			}
		}


		/// <summary>
		/// Get user information
		/// </summary>
		private void GetADUser(string strDomain, string strUser)
		{
			DirectoryEntry myDirEntry;
			//WindowsImpersonationContext impersonationContext;
			//WindowsIdentity currentWindowsIdentity;

			/*currentWindowsIdentity = (System.Security.Principal.WindowsIdentity) User.Identity;
			impersonationContext = currentWindowsIdentity.Impersonate();*/

			try
			{
				// trying to connect
				myDirEntry = new DirectoryEntry();
				myDirEntry.Path = "WinNT://" + strDomain + "/" + strUser;
				myDirEntry.AuthenticationType = AuthenticationTypes.Secure;

				User objUser = new User();
				objUser.UserDomain = strDomain;
				objUser.UserLogin = strUser;
				objUser.UserDesc = myDirEntry.Properties["FullName"].Value.ToString();
				objUser.UserMail = strUser;
				objUser.UserActive = true;
				objUser.NewUser();
			}
			catch (Exception ex)
			{
				OfficeWorksException.WriteEventLog(ex.Message);
			}
			finally
			{
			//	impersonationContext.Undo();
			}
		}

		/// <summary>
		/// Exit from application
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnExit_Click(object sender, EventArgs e)
		{
			ExitApplication();
		}

		/// <summary>
		/// Exit from application
		/// </summary>
		private void ExitApplication()
		{
			ExitApplication();
		}

		/// <summary>
		/// Exit from application
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuItem4_Click(object sender, EventArgs e)
		{
			try
			{
				this.Close();
			}
			catch
			{
				

			}
		}

		/// <summary>
		/// Do some initialization stuff
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void frmMain_Load(object sender, EventArgs e)
		{
			Global.GetADDomains(ddDomain);
		}

		/// <summary>
		/// Event fired when the user selects a domain
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ddDomain_SelectedIndexChanged(object sender, EventArgs e)
		{
			this.Cursor = Cursors.WaitCursor;
			GetADDomainUsers(ddDomain.Text);
			this.Cursor = Cursors.Arrow;
		}

		/// <summary>
		/// Limpar a selecção dos utilizadores
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnClean_Click(object sender, EventArgs e)
		{
				lstUsers.Items.Clear();
				ddDomain.SelectedIndex=0;
		}

		private void menuItem3_Click(object sender, EventArgs e)
		{
			MessageBox.Show("OfficeWorks BackOffice Versão 1.0)");
		}

		/// <summary>
		/// Show the groups dialog
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuItem5_Click(object sender, EventArgs e)
		{
			ShowGroupsForm();
		}

		/// <summary>
		/// Show the groups dialog
		/// </summary>
		private static void ShowGroupsForm()
		{
			frmGroups frmGroup = new frmGroups();
			frmGroup.Show();
		}

		/// <summary>
		/// Show the groups dialog
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnNext_Click(object sender, EventArgs e)
		{
			ShowGroupsForm();
		}



	}
}
