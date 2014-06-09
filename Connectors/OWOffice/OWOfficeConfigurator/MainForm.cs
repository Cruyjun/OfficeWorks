
using System;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Reflection;
using System.Web.Services.Protocols;
using System.Windows.Forms;
using OfficeWorks.OWOffice.Configurator.OWApiWebService;
using OfficeWorks.OWOffice.Configuration;

namespace OfficeWorks.OWOffice.Configurator
{	
	/// <summary>
	/// Main Form of OWOffice Configurator user interface.
	/// </summary>
	public class MainForm : Form
	{

		#region DECLARATIONS
		//*****************************************************************************

		

		/// <summary>
		/// Required designer variable.
		/// </summary>	
		
		private IContainer components;
		private MainMenu mainMenu1;
		private MenuItem menuItem5;
		private MenuItem menuItem7;
		private MenuItem menuFile;
		private MenuItem menuNewFile;
		private MenuItem menuOpenFile;
		private MenuItem menuCloseFile;
		private MenuItem menuSaveFile;
		private MenuItem menuExit;
		private MenuItem menuHelp;
		private MenuItem menuAbout;
		private TabControl tabControl1;
		private TabPage tabPageGeral;
		private TabPage tabPageMappings;
		private ToolTip toolTipMainForm;
		private OperationMode _activeOperationMode;
		private ListBox listDocumentTypes;
		private ListBox listBooks;
		private Label lblOfficeWorksDocumentType;
		private Label lblOfficeWorksBook;
		private Button cmdDelTemplateName;
		private ListBox listTemplate;
		private TextBox txtNewTemplateName;
		private Button cmdAddTemplateName;
		private Label lblTemplateName;
		private OWFieldsForm frmOWNFields = null;	

		
		//Constants				
		private const string _file_ext = "owc";
		private const string _backupfile = "backup.owc";
		
		private const string kIDENTATION04 = "    ";

		//Variables
		private OWC Configuration = new OWC();
		private OWC ConfigurationCopy = new OWC();

		//A new thread to asynchronously the web service
		System.Threading.Thread thrWebService;
		//When thrWebService thread is calling the service this varible is true
		private bool bCallingWebService=false;
		//While the current WebService Configuration is not verified it is invalid
		private bool bIsWebServiceValid=false;

		/// <summary>
		/// Administrator possible operation state modes.
		/// </summary>
		public enum OperationMode
		{
			Idle,	// No valid file is currently selected
			Edit,	// An existing valid file is beeing edited
			New		// A new blank file is beeing edited
		}


	
		/// <summary>
		/// Configuration file path
		/// </summary>
		private string _filePath = "";


		/// <summary>
		/// Configuration backup file path
		/// </summary>
		private string _backupFilePath = Application.StartupPath + @"\" + _backupfile;
		private System.Windows.Forms.Button btnAddField;
		private System.Windows.Forms.Button btnRemoveField;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.CheckBox chkDefault;
		private System.Windows.Forms.CheckBox chkHAccess;
		private System.Windows.Forms.CheckBox chkAccessRequired;
		private System.Windows.Forms.CheckBox chkPDF;
		private System.Windows.Forms.TextBox txtWebServerUrl;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Panel pnProcessando;
		private System.Windows.Forms.PictureBox pictureBox1;
		private System.Windows.Forms.Label lblMsg;
		private System.Windows.Forms.Button btnCancelWS;
		private System.Windows.Forms.MenuItem menuSaveFileAs;
		
		private OWGrid owGMappFields;
	
		public string BackupFilePath
		{
			get
			{
				return _backupFilePath;
			}
			set
			{
				_backupFilePath = value;
			}
		}
		#endregion//*********************************************************************

		#region Windows Form Designer generated code
		//***************************************************************************************



		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			if (MainForm.RunningInstance() != null)
			{
				MessageBox.Show("O OWOffice já está em execução.", MsgboxTitle, MessageBoxButtons.OK,MessageBoxIcon.Error);
				
			}
			else
			{
				Application.Run(new MainForm());
			}
		}


		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public static Process RunningInstance() 
		{ 
			Process current = Process.GetCurrentProcess(); 
			Process[] processes = Process.GetProcessesByName (current.ProcessName); 
			//Loop through the running processes in with the same name 
			foreach (Process process in processes) 
			{ 
				//Ignore the current process 
				if (process.Id != current.Id) 
				{ 
					//Make sure that the process is running from the exe file. 
					if (Assembly.GetExecutingAssembly().Location.Replace("/", "\\") == current.MainModule.FileName) 
					{  
						//Return the other process instance.  
						return process; 
					}  
				}  
			} 
			//No other instance was found, return null.  
			return null;  
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

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(MainForm));
			this.mainMenu1 = new System.Windows.Forms.MainMenu();
			this.menuFile = new System.Windows.Forms.MenuItem();
			this.menuNewFile = new System.Windows.Forms.MenuItem();
			this.menuOpenFile = new System.Windows.Forms.MenuItem();
			this.menuCloseFile = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.menuSaveFile = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.menuExit = new System.Windows.Forms.MenuItem();
			this.menuHelp = new System.Windows.Forms.MenuItem();
			this.menuAbout = new System.Windows.Forms.MenuItem();
			this.toolTipMainForm = new System.Windows.Forms.ToolTip(this.components);
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPageGeral = new System.Windows.Forms.TabPage();
			this.txtWebServerUrl = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.pnProcessando = new System.Windows.Forms.Panel();
			this.btnCancelWS = new System.Windows.Forms.Button();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.lblMsg = new System.Windows.Forms.Label();
			this.tabPageMappings = new System.Windows.Forms.TabPage();
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.chkAccessRequired = new System.Windows.Forms.CheckBox();
			this.chkPDF = new System.Windows.Forms.CheckBox();
			this.chkDefault = new System.Windows.Forms.CheckBox();
			this.chkHAccess = new System.Windows.Forms.CheckBox();
			this.owGMappFields = new OfficeWorks.OWOffice.OWGrid();
			this.btnRemoveField = new System.Windows.Forms.Button();
			this.btnAddField = new System.Windows.Forms.Button();
			this.cmdDelTemplateName = new System.Windows.Forms.Button();
			this.listTemplate = new System.Windows.Forms.ListBox();
			this.txtNewTemplateName = new System.Windows.Forms.TextBox();
			this.cmdAddTemplateName = new System.Windows.Forms.Button();
			this.lblTemplateName = new System.Windows.Forms.Label();
			this.listDocumentTypes = new System.Windows.Forms.ListBox();
			this.listBooks = new System.Windows.Forms.ListBox();
			this.lblOfficeWorksDocumentType = new System.Windows.Forms.Label();
			this.lblOfficeWorksBook = new System.Windows.Forms.Label();
			this.menuSaveFileAs = new System.Windows.Forms.MenuItem();
			this.tabControl1.SuspendLayout();
			this.tabPageGeral.SuspendLayout();
			this.pnProcessando.SuspendLayout();
			this.tabPageMappings.SuspendLayout();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuFile,
																					  this.menuHelp});
			this.mainMenu1.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("mainMenu1.RightToLeft")));
			// 
			// menuFile
			// 
			this.menuFile.Enabled = ((bool)(resources.GetObject("menuFile.Enabled")));
			this.menuFile.Index = 0;
			this.menuFile.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					 this.menuNewFile,
																					 this.menuOpenFile,
																					 this.menuCloseFile,
																					 this.menuItem5,
																					 this.menuSaveFile,
																					 this.menuSaveFileAs,
																					 this.menuItem7,
																					 this.menuExit});
			this.menuFile.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuFile.Shortcut")));
			this.menuFile.ShowShortcut = ((bool)(resources.GetObject("menuFile.ShowShortcut")));
			this.menuFile.Text = resources.GetString("menuFile.Text");
			this.menuFile.Visible = ((bool)(resources.GetObject("menuFile.Visible")));
			// 
			// menuNewFile
			// 
			this.menuNewFile.Enabled = ((bool)(resources.GetObject("menuNewFile.Enabled")));
			this.menuNewFile.Index = 0;
			this.menuNewFile.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuNewFile.Shortcut")));
			this.menuNewFile.ShowShortcut = ((bool)(resources.GetObject("menuNewFile.ShowShortcut")));
			this.menuNewFile.Text = resources.GetString("menuNewFile.Text");
			this.menuNewFile.Visible = ((bool)(resources.GetObject("menuNewFile.Visible")));
			this.menuNewFile.Click += new System.EventHandler(this.menuNewFile_Click);
			// 
			// menuOpenFile
			// 
			this.menuOpenFile.Enabled = ((bool)(resources.GetObject("menuOpenFile.Enabled")));
			this.menuOpenFile.Index = 1;
			this.menuOpenFile.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuOpenFile.Shortcut")));
			this.menuOpenFile.ShowShortcut = ((bool)(resources.GetObject("menuOpenFile.ShowShortcut")));
			this.menuOpenFile.Text = resources.GetString("menuOpenFile.Text");
			this.menuOpenFile.Visible = ((bool)(resources.GetObject("menuOpenFile.Visible")));
			this.menuOpenFile.Click += new System.EventHandler(this.menuOpenFile_Click);
			// 
			// menuCloseFile
			// 
			this.menuCloseFile.Enabled = ((bool)(resources.GetObject("menuCloseFile.Enabled")));
			this.menuCloseFile.Index = 2;
			this.menuCloseFile.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuCloseFile.Shortcut")));
			this.menuCloseFile.ShowShortcut = ((bool)(resources.GetObject("menuCloseFile.ShowShortcut")));
			this.menuCloseFile.Text = resources.GetString("menuCloseFile.Text");
			this.menuCloseFile.Visible = ((bool)(resources.GetObject("menuCloseFile.Visible")));
			this.menuCloseFile.Click += new System.EventHandler(this.menuCloseFile_Click);
			// 
			// menuItem5
			// 
			this.menuItem5.Enabled = ((bool)(resources.GetObject("menuItem5.Enabled")));
			this.menuItem5.Index = 3;
			this.menuItem5.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuItem5.Shortcut")));
			this.menuItem5.ShowShortcut = ((bool)(resources.GetObject("menuItem5.ShowShortcut")));
			this.menuItem5.Text = resources.GetString("menuItem5.Text");
			this.menuItem5.Visible = ((bool)(resources.GetObject("menuItem5.Visible")));
			// 
			// menuSaveFile
			// 
			this.menuSaveFile.Enabled = ((bool)(resources.GetObject("menuSaveFile.Enabled")));
			this.menuSaveFile.Index = 4;
			this.menuSaveFile.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuSaveFile.Shortcut")));
			this.menuSaveFile.ShowShortcut = ((bool)(resources.GetObject("menuSaveFile.ShowShortcut")));
			this.menuSaveFile.Text = resources.GetString("menuSaveFile.Text");
			this.menuSaveFile.Visible = ((bool)(resources.GetObject("menuSaveFile.Visible")));
			this.menuSaveFile.Click += new System.EventHandler(this.menuSaveFile_Click);
			// 
			// menuItem7
			// 
			this.menuItem7.Enabled = ((bool)(resources.GetObject("menuItem7.Enabled")));
			this.menuItem7.Index = 6;
			this.menuItem7.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuItem7.Shortcut")));
			this.menuItem7.ShowShortcut = ((bool)(resources.GetObject("menuItem7.ShowShortcut")));
			this.menuItem7.Text = resources.GetString("menuItem7.Text");
			this.menuItem7.Visible = ((bool)(resources.GetObject("menuItem7.Visible")));
			// 
			// menuExit
			// 
			this.menuExit.Enabled = ((bool)(resources.GetObject("menuExit.Enabled")));
			this.menuExit.Index = 7;
			this.menuExit.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuExit.Shortcut")));
			this.menuExit.ShowShortcut = ((bool)(resources.GetObject("menuExit.ShowShortcut")));
			this.menuExit.Text = resources.GetString("menuExit.Text");
			this.menuExit.Visible = ((bool)(resources.GetObject("menuExit.Visible")));
			this.menuExit.Click += new System.EventHandler(this.menuExit_Click);
			// 
			// menuHelp
			// 
			this.menuHelp.Enabled = ((bool)(resources.GetObject("menuHelp.Enabled")));
			this.menuHelp.Index = 1;
			this.menuHelp.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					 this.menuAbout});
			this.menuHelp.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuHelp.Shortcut")));
			this.menuHelp.ShowShortcut = ((bool)(resources.GetObject("menuHelp.ShowShortcut")));
			this.menuHelp.Text = resources.GetString("menuHelp.Text");
			this.menuHelp.Visible = ((bool)(resources.GetObject("menuHelp.Visible")));
			// 
			// menuAbout
			// 
			this.menuAbout.Enabled = ((bool)(resources.GetObject("menuAbout.Enabled")));
			this.menuAbout.Index = 0;
			this.menuAbout.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuAbout.Shortcut")));
			this.menuAbout.ShowShortcut = ((bool)(resources.GetObject("menuAbout.ShowShortcut")));
			this.menuAbout.Text = resources.GetString("menuAbout.Text");
			this.menuAbout.Visible = ((bool)(resources.GetObject("menuAbout.Visible")));
			this.menuAbout.Click += new System.EventHandler(this.menuAbout_Click);
			// 
			// tabControl1
			// 
			this.tabControl1.AccessibleDescription = resources.GetString("tabControl1.AccessibleDescription");
			this.tabControl1.AccessibleName = resources.GetString("tabControl1.AccessibleName");
			this.tabControl1.Alignment = ((System.Windows.Forms.TabAlignment)(resources.GetObject("tabControl1.Alignment")));
			this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tabControl1.Anchor")));
			this.tabControl1.Appearance = ((System.Windows.Forms.TabAppearance)(resources.GetObject("tabControl1.Appearance")));
			this.tabControl1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tabControl1.BackgroundImage")));
			this.tabControl1.Controls.Add(this.tabPageGeral);
			this.tabControl1.Controls.Add(this.tabPageMappings);
			this.tabControl1.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("tabControl1.Dock")));
			this.tabControl1.Enabled = ((bool)(resources.GetObject("tabControl1.Enabled")));
			this.tabControl1.Font = ((System.Drawing.Font)(resources.GetObject("tabControl1.Font")));
			this.tabControl1.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("tabControl1.ImeMode")));
			this.tabControl1.ItemSize = ((System.Drawing.Size)(resources.GetObject("tabControl1.ItemSize")));
			this.tabControl1.Location = ((System.Drawing.Point)(resources.GetObject("tabControl1.Location")));
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.Padding = ((System.Drawing.Point)(resources.GetObject("tabControl1.Padding")));
			this.tabControl1.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("tabControl1.RightToLeft")));
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.ShowToolTips = ((bool)(resources.GetObject("tabControl1.ShowToolTips")));
			this.tabControl1.Size = ((System.Drawing.Size)(resources.GetObject("tabControl1.Size")));
			this.tabControl1.TabIndex = ((int)(resources.GetObject("tabControl1.TabIndex")));
			this.tabControl1.Text = resources.GetString("tabControl1.Text");
			this.toolTipMainForm.SetToolTip(this.tabControl1, resources.GetString("tabControl1.ToolTip"));
			this.tabControl1.Visible = ((bool)(resources.GetObject("tabControl1.Visible")));
			this.tabControl1.SelectedIndexChanged += new System.EventHandler(this.tabControl1_SelectedIndexChanged);
			// 
			// tabPageGeral
			// 
			this.tabPageGeral.AccessibleDescription = resources.GetString("tabPageGeral.AccessibleDescription");
			this.tabPageGeral.AccessibleName = resources.GetString("tabPageGeral.AccessibleName");
			this.tabPageGeral.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tabPageGeral.Anchor")));
			this.tabPageGeral.AutoScroll = ((bool)(resources.GetObject("tabPageGeral.AutoScroll")));
			this.tabPageGeral.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("tabPageGeral.AutoScrollMargin")));
			this.tabPageGeral.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("tabPageGeral.AutoScrollMinSize")));
			this.tabPageGeral.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tabPageGeral.BackgroundImage")));
			this.tabPageGeral.Controls.Add(this.txtWebServerUrl);
			this.tabPageGeral.Controls.Add(this.label1);
			this.tabPageGeral.Controls.Add(this.pnProcessando);
			this.tabPageGeral.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("tabPageGeral.Dock")));
			this.tabPageGeral.Enabled = ((bool)(resources.GetObject("tabPageGeral.Enabled")));
			this.tabPageGeral.Font = ((System.Drawing.Font)(resources.GetObject("tabPageGeral.Font")));
			this.tabPageGeral.ImageIndex = ((int)(resources.GetObject("tabPageGeral.ImageIndex")));
			this.tabPageGeral.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("tabPageGeral.ImeMode")));
			this.tabPageGeral.Location = ((System.Drawing.Point)(resources.GetObject("tabPageGeral.Location")));
			this.tabPageGeral.Name = "tabPageGeral";
			this.tabPageGeral.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("tabPageGeral.RightToLeft")));
			this.tabPageGeral.Size = ((System.Drawing.Size)(resources.GetObject("tabPageGeral.Size")));
			this.tabPageGeral.TabIndex = ((int)(resources.GetObject("tabPageGeral.TabIndex")));
			this.tabPageGeral.Text = resources.GetString("tabPageGeral.Text");
			this.toolTipMainForm.SetToolTip(this.tabPageGeral, resources.GetString("tabPageGeral.ToolTip"));
			this.tabPageGeral.ToolTipText = resources.GetString("tabPageGeral.ToolTipText");
			this.tabPageGeral.Visible = ((bool)(resources.GetObject("tabPageGeral.Visible")));
			// 
			// txtWebServerUrl
			// 
			this.txtWebServerUrl.AccessibleDescription = resources.GetString("txtWebServerUrl.AccessibleDescription");
			this.txtWebServerUrl.AccessibleName = resources.GetString("txtWebServerUrl.AccessibleName");
			this.txtWebServerUrl.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("txtWebServerUrl.Anchor")));
			this.txtWebServerUrl.AutoSize = ((bool)(resources.GetObject("txtWebServerUrl.AutoSize")));
			this.txtWebServerUrl.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("txtWebServerUrl.BackgroundImage")));
			this.txtWebServerUrl.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("txtWebServerUrl.Dock")));
			this.txtWebServerUrl.Enabled = ((bool)(resources.GetObject("txtWebServerUrl.Enabled")));
			this.txtWebServerUrl.Font = ((System.Drawing.Font)(resources.GetObject("txtWebServerUrl.Font")));
			this.txtWebServerUrl.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("txtWebServerUrl.ImeMode")));
			this.txtWebServerUrl.Location = ((System.Drawing.Point)(resources.GetObject("txtWebServerUrl.Location")));
			this.txtWebServerUrl.MaxLength = ((int)(resources.GetObject("txtWebServerUrl.MaxLength")));
			this.txtWebServerUrl.Multiline = ((bool)(resources.GetObject("txtWebServerUrl.Multiline")));
			this.txtWebServerUrl.Name = "txtWebServerUrl";
			this.txtWebServerUrl.PasswordChar = ((char)(resources.GetObject("txtWebServerUrl.PasswordChar")));
			this.txtWebServerUrl.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("txtWebServerUrl.RightToLeft")));
			this.txtWebServerUrl.ScrollBars = ((System.Windows.Forms.ScrollBars)(resources.GetObject("txtWebServerUrl.ScrollBars")));
			this.txtWebServerUrl.Size = ((System.Drawing.Size)(resources.GetObject("txtWebServerUrl.Size")));
			this.txtWebServerUrl.TabIndex = ((int)(resources.GetObject("txtWebServerUrl.TabIndex")));
			this.txtWebServerUrl.Text = resources.GetString("txtWebServerUrl.Text");
			this.txtWebServerUrl.TextAlign = ((System.Windows.Forms.HorizontalAlignment)(resources.GetObject("txtWebServerUrl.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.txtWebServerUrl, resources.GetString("txtWebServerUrl.ToolTip"));
			this.txtWebServerUrl.Visible = ((bool)(resources.GetObject("txtWebServerUrl.Visible")));
			this.txtWebServerUrl.WordWrap = ((bool)(resources.GetObject("txtWebServerUrl.WordWrap")));
			// 
			// label1
			// 
			this.label1.AccessibleDescription = resources.GetString("label1.AccessibleDescription");
			this.label1.AccessibleName = resources.GetString("label1.AccessibleName");
			this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label1.Anchor")));
			this.label1.AutoSize = ((bool)(resources.GetObject("label1.AutoSize")));
			this.label1.BackColor = System.Drawing.Color.Transparent;
			this.label1.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label1.Dock")));
			this.label1.Enabled = ((bool)(resources.GetObject("label1.Enabled")));
			this.label1.Font = ((System.Drawing.Font)(resources.GetObject("label1.Font")));
			this.label1.Image = ((System.Drawing.Image)(resources.GetObject("label1.Image")));
			this.label1.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label1.ImageAlign")));
			this.label1.ImageIndex = ((int)(resources.GetObject("label1.ImageIndex")));
			this.label1.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label1.ImeMode")));
			this.label1.Location = ((System.Drawing.Point)(resources.GetObject("label1.Location")));
			this.label1.Name = "label1";
			this.label1.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label1.RightToLeft")));
			this.label1.Size = ((System.Drawing.Size)(resources.GetObject("label1.Size")));
			this.label1.TabIndex = ((int)(resources.GetObject("label1.TabIndex")));
			this.label1.Text = resources.GetString("label1.Text");
			this.label1.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label1.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label1, resources.GetString("label1.ToolTip"));
			this.label1.Visible = ((bool)(resources.GetObject("label1.Visible")));
			// 
			// pnProcessando
			// 
			this.pnProcessando.AccessibleDescription = resources.GetString("pnProcessando.AccessibleDescription");
			this.pnProcessando.AccessibleName = resources.GetString("pnProcessando.AccessibleName");
			this.pnProcessando.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("pnProcessando.Anchor")));
			this.pnProcessando.AutoScroll = ((bool)(resources.GetObject("pnProcessando.AutoScroll")));
			this.pnProcessando.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("pnProcessando.AutoScrollMargin")));
			this.pnProcessando.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("pnProcessando.AutoScrollMinSize")));
			this.pnProcessando.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("pnProcessando.BackgroundImage")));
			this.pnProcessando.Controls.Add(this.btnCancelWS);
			this.pnProcessando.Controls.Add(this.pictureBox1);
			this.pnProcessando.Controls.Add(this.lblMsg);
			this.pnProcessando.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("pnProcessando.Dock")));
			this.pnProcessando.Enabled = ((bool)(resources.GetObject("pnProcessando.Enabled")));
			this.pnProcessando.Font = ((System.Drawing.Font)(resources.GetObject("pnProcessando.Font")));
			this.pnProcessando.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("pnProcessando.ImeMode")));
			this.pnProcessando.Location = ((System.Drawing.Point)(resources.GetObject("pnProcessando.Location")));
			this.pnProcessando.Name = "pnProcessando";
			this.pnProcessando.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("pnProcessando.RightToLeft")));
			this.pnProcessando.Size = ((System.Drawing.Size)(resources.GetObject("pnProcessando.Size")));
			this.pnProcessando.TabIndex = ((int)(resources.GetObject("pnProcessando.TabIndex")));
			this.pnProcessando.Text = resources.GetString("pnProcessando.Text");
			this.toolTipMainForm.SetToolTip(this.pnProcessando, resources.GetString("pnProcessando.ToolTip"));
			this.pnProcessando.Visible = ((bool)(resources.GetObject("pnProcessando.Visible")));
			// 
			// btnCancelWS
			// 
			this.btnCancelWS.AccessibleDescription = resources.GetString("btnCancelWS.AccessibleDescription");
			this.btnCancelWS.AccessibleName = resources.GetString("btnCancelWS.AccessibleName");
			this.btnCancelWS.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnCancelWS.Anchor")));
			this.btnCancelWS.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnCancelWS.BackgroundImage")));
			this.btnCancelWS.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnCancelWS.Dock")));
			this.btnCancelWS.Enabled = ((bool)(resources.GetObject("btnCancelWS.Enabled")));
			this.btnCancelWS.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnCancelWS.FlatStyle")));
			this.btnCancelWS.Font = ((System.Drawing.Font)(resources.GetObject("btnCancelWS.Font")));
			this.btnCancelWS.Image = ((System.Drawing.Image)(resources.GetObject("btnCancelWS.Image")));
			this.btnCancelWS.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnCancelWS.ImageAlign")));
			this.btnCancelWS.ImageIndex = ((int)(resources.GetObject("btnCancelWS.ImageIndex")));
			this.btnCancelWS.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnCancelWS.ImeMode")));
			this.btnCancelWS.Location = ((System.Drawing.Point)(resources.GetObject("btnCancelWS.Location")));
			this.btnCancelWS.Name = "btnCancelWS";
			this.btnCancelWS.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnCancelWS.RightToLeft")));
			this.btnCancelWS.Size = ((System.Drawing.Size)(resources.GetObject("btnCancelWS.Size")));
			this.btnCancelWS.TabIndex = ((int)(resources.GetObject("btnCancelWS.TabIndex")));
			this.btnCancelWS.Text = resources.GetString("btnCancelWS.Text");
			this.btnCancelWS.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnCancelWS.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnCancelWS, resources.GetString("btnCancelWS.ToolTip"));
			this.btnCancelWS.Visible = ((bool)(resources.GetObject("btnCancelWS.Visible")));
			this.btnCancelWS.Click += new System.EventHandler(this.btnCancelWS_Click);
			// 
			// pictureBox1
			// 
			this.pictureBox1.AccessibleDescription = resources.GetString("pictureBox1.AccessibleDescription");
			this.pictureBox1.AccessibleName = resources.GetString("pictureBox1.AccessibleName");
			this.pictureBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("pictureBox1.Anchor")));
			this.pictureBox1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("pictureBox1.BackgroundImage")));
			this.pictureBox1.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("pictureBox1.Dock")));
			this.pictureBox1.Enabled = ((bool)(resources.GetObject("pictureBox1.Enabled")));
			this.pictureBox1.Font = ((System.Drawing.Font)(resources.GetObject("pictureBox1.Font")));
			this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
			this.pictureBox1.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("pictureBox1.ImeMode")));
			this.pictureBox1.Location = ((System.Drawing.Point)(resources.GetObject("pictureBox1.Location")));
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("pictureBox1.RightToLeft")));
			this.pictureBox1.Size = ((System.Drawing.Size)(resources.GetObject("pictureBox1.Size")));
			this.pictureBox1.SizeMode = ((System.Windows.Forms.PictureBoxSizeMode)(resources.GetObject("pictureBox1.SizeMode")));
			this.pictureBox1.TabIndex = ((int)(resources.GetObject("pictureBox1.TabIndex")));
			this.pictureBox1.TabStop = false;
			this.pictureBox1.Text = resources.GetString("pictureBox1.Text");
			this.toolTipMainForm.SetToolTip(this.pictureBox1, resources.GetString("pictureBox1.ToolTip"));
			this.pictureBox1.Visible = ((bool)(resources.GetObject("pictureBox1.Visible")));
			// 
			// lblMsg
			// 
			this.lblMsg.AccessibleDescription = resources.GetString("lblMsg.AccessibleDescription");
			this.lblMsg.AccessibleName = resources.GetString("lblMsg.AccessibleName");
			this.lblMsg.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("lblMsg.Anchor")));
			this.lblMsg.AutoSize = ((bool)(resources.GetObject("lblMsg.AutoSize")));
			this.lblMsg.BackColor = System.Drawing.Color.Transparent;
			this.lblMsg.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("lblMsg.Dock")));
			this.lblMsg.Enabled = ((bool)(resources.GetObject("lblMsg.Enabled")));
			this.lblMsg.Font = ((System.Drawing.Font)(resources.GetObject("lblMsg.Font")));
			this.lblMsg.ForeColor = System.Drawing.SystemColors.Highlight;
			this.lblMsg.Image = ((System.Drawing.Image)(resources.GetObject("lblMsg.Image")));
			this.lblMsg.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblMsg.ImageAlign")));
			this.lblMsg.ImageIndex = ((int)(resources.GetObject("lblMsg.ImageIndex")));
			this.lblMsg.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("lblMsg.ImeMode")));
			this.lblMsg.Location = ((System.Drawing.Point)(resources.GetObject("lblMsg.Location")));
			this.lblMsg.Name = "lblMsg";
			this.lblMsg.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("lblMsg.RightToLeft")));
			this.lblMsg.Size = ((System.Drawing.Size)(resources.GetObject("lblMsg.Size")));
			this.lblMsg.TabIndex = ((int)(resources.GetObject("lblMsg.TabIndex")));
			this.lblMsg.Text = resources.GetString("lblMsg.Text");
			this.lblMsg.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblMsg.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.lblMsg, resources.GetString("lblMsg.ToolTip"));
			this.lblMsg.Visible = ((bool)(resources.GetObject("lblMsg.Visible")));
			// 
			// tabPageMappings
			// 
			this.tabPageMappings.AccessibleDescription = resources.GetString("tabPageMappings.AccessibleDescription");
			this.tabPageMappings.AccessibleName = resources.GetString("tabPageMappings.AccessibleName");
			this.tabPageMappings.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tabPageMappings.Anchor")));
			this.tabPageMappings.AutoScroll = ((bool)(resources.GetObject("tabPageMappings.AutoScroll")));
			this.tabPageMappings.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("tabPageMappings.AutoScrollMargin")));
			this.tabPageMappings.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("tabPageMappings.AutoScrollMinSize")));
			this.tabPageMappings.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tabPageMappings.BackgroundImage")));
			this.tabPageMappings.Controls.Add(this.groupBox1);
			this.tabPageMappings.Controls.Add(this.owGMappFields);
			this.tabPageMappings.Controls.Add(this.btnRemoveField);
			this.tabPageMappings.Controls.Add(this.btnAddField);
			this.tabPageMappings.Controls.Add(this.cmdDelTemplateName);
			this.tabPageMappings.Controls.Add(this.listTemplate);
			this.tabPageMappings.Controls.Add(this.txtNewTemplateName);
			this.tabPageMappings.Controls.Add(this.cmdAddTemplateName);
			this.tabPageMappings.Controls.Add(this.lblTemplateName);
			this.tabPageMappings.Controls.Add(this.listDocumentTypes);
			this.tabPageMappings.Controls.Add(this.listBooks);
			this.tabPageMappings.Controls.Add(this.lblOfficeWorksDocumentType);
			this.tabPageMappings.Controls.Add(this.lblOfficeWorksBook);
			this.tabPageMappings.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("tabPageMappings.Dock")));
			this.tabPageMappings.Enabled = ((bool)(resources.GetObject("tabPageMappings.Enabled")));
			this.tabPageMappings.Font = ((System.Drawing.Font)(resources.GetObject("tabPageMappings.Font")));
			this.tabPageMappings.ImageIndex = ((int)(resources.GetObject("tabPageMappings.ImageIndex")));
			this.tabPageMappings.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("tabPageMappings.ImeMode")));
			this.tabPageMappings.Location = ((System.Drawing.Point)(resources.GetObject("tabPageMappings.Location")));
			this.tabPageMappings.Name = "tabPageMappings";
			this.tabPageMappings.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("tabPageMappings.RightToLeft")));
			this.tabPageMappings.Size = ((System.Drawing.Size)(resources.GetObject("tabPageMappings.Size")));
			this.tabPageMappings.TabIndex = ((int)(resources.GetObject("tabPageMappings.TabIndex")));
			this.tabPageMappings.Tag = "342";
			this.tabPageMappings.Text = resources.GetString("tabPageMappings.Text");
			this.toolTipMainForm.SetToolTip(this.tabPageMappings, resources.GetString("tabPageMappings.ToolTip"));
			this.tabPageMappings.ToolTipText = resources.GetString("tabPageMappings.ToolTipText");
			this.tabPageMappings.Visible = ((bool)(resources.GetObject("tabPageMappings.Visible")));
			// 
			// groupBox1
			// 
			this.groupBox1.AccessibleDescription = resources.GetString("groupBox1.AccessibleDescription");
			this.groupBox1.AccessibleName = resources.GetString("groupBox1.AccessibleName");
			this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("groupBox1.Anchor")));
			this.groupBox1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("groupBox1.BackgroundImage")));
			this.groupBox1.Controls.Add(this.chkAccessRequired);
			this.groupBox1.Controls.Add(this.chkPDF);
			this.groupBox1.Controls.Add(this.chkDefault);
			this.groupBox1.Controls.Add(this.chkHAccess);
			this.groupBox1.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("groupBox1.Dock")));
			this.groupBox1.Enabled = ((bool)(resources.GetObject("groupBox1.Enabled")));
			this.groupBox1.Font = ((System.Drawing.Font)(resources.GetObject("groupBox1.Font")));
			this.groupBox1.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("groupBox1.ImeMode")));
			this.groupBox1.Location = ((System.Drawing.Point)(resources.GetObject("groupBox1.Location")));
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("groupBox1.RightToLeft")));
			this.groupBox1.Size = ((System.Drawing.Size)(resources.GetObject("groupBox1.Size")));
			this.groupBox1.TabIndex = ((int)(resources.GetObject("groupBox1.TabIndex")));
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = resources.GetString("groupBox1.Text");
			this.toolTipMainForm.SetToolTip(this.groupBox1, resources.GetString("groupBox1.ToolTip"));
			this.groupBox1.Visible = ((bool)(resources.GetObject("groupBox1.Visible")));
			// 
			// chkAccessRequired
			// 
			this.chkAccessRequired.AccessibleDescription = resources.GetString("chkAccessRequired.AccessibleDescription");
			this.chkAccessRequired.AccessibleName = resources.GetString("chkAccessRequired.AccessibleName");
			this.chkAccessRequired.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("chkAccessRequired.Anchor")));
			this.chkAccessRequired.Appearance = ((System.Windows.Forms.Appearance)(resources.GetObject("chkAccessRequired.Appearance")));
			this.chkAccessRequired.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("chkAccessRequired.BackgroundImage")));
			this.chkAccessRequired.CheckAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkAccessRequired.CheckAlign")));
			this.chkAccessRequired.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("chkAccessRequired.Dock")));
			this.chkAccessRequired.Enabled = ((bool)(resources.GetObject("chkAccessRequired.Enabled")));
			this.chkAccessRequired.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("chkAccessRequired.FlatStyle")));
			this.chkAccessRequired.Font = ((System.Drawing.Font)(resources.GetObject("chkAccessRequired.Font")));
			this.chkAccessRequired.Image = ((System.Drawing.Image)(resources.GetObject("chkAccessRequired.Image")));
			this.chkAccessRequired.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkAccessRequired.ImageAlign")));
			this.chkAccessRequired.ImageIndex = ((int)(resources.GetObject("chkAccessRequired.ImageIndex")));
			this.chkAccessRequired.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("chkAccessRequired.ImeMode")));
			this.chkAccessRequired.Location = ((System.Drawing.Point)(resources.GetObject("chkAccessRequired.Location")));
			this.chkAccessRequired.Name = "chkAccessRequired";
			this.chkAccessRequired.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("chkAccessRequired.RightToLeft")));
			this.chkAccessRequired.Size = ((System.Drawing.Size)(resources.GetObject("chkAccessRequired.Size")));
			this.chkAccessRequired.TabIndex = ((int)(resources.GetObject("chkAccessRequired.TabIndex")));
			this.chkAccessRequired.Text = resources.GetString("chkAccessRequired.Text");
			this.chkAccessRequired.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkAccessRequired.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.chkAccessRequired, resources.GetString("chkAccessRequired.ToolTip"));
			this.chkAccessRequired.Visible = ((bool)(resources.GetObject("chkAccessRequired.Visible")));
			this.chkAccessRequired.Click += new System.EventHandler(this.chkAccessRequired_Click);
			// 
			// chkPDF
			// 
			this.chkPDF.AccessibleDescription = resources.GetString("chkPDF.AccessibleDescription");
			this.chkPDF.AccessibleName = resources.GetString("chkPDF.AccessibleName");
			this.chkPDF.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("chkPDF.Anchor")));
			this.chkPDF.Appearance = ((System.Windows.Forms.Appearance)(resources.GetObject("chkPDF.Appearance")));
			this.chkPDF.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("chkPDF.BackgroundImage")));
			this.chkPDF.CheckAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkPDF.CheckAlign")));
			this.chkPDF.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("chkPDF.Dock")));
			this.chkPDF.Enabled = ((bool)(resources.GetObject("chkPDF.Enabled")));
			this.chkPDF.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("chkPDF.FlatStyle")));
			this.chkPDF.Font = ((System.Drawing.Font)(resources.GetObject("chkPDF.Font")));
			this.chkPDF.Image = ((System.Drawing.Image)(resources.GetObject("chkPDF.Image")));
			this.chkPDF.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkPDF.ImageAlign")));
			this.chkPDF.ImageIndex = ((int)(resources.GetObject("chkPDF.ImageIndex")));
			this.chkPDF.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("chkPDF.ImeMode")));
			this.chkPDF.Location = ((System.Drawing.Point)(resources.GetObject("chkPDF.Location")));
			this.chkPDF.Name = "chkPDF";
			this.chkPDF.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("chkPDF.RightToLeft")));
			this.chkPDF.Size = ((System.Drawing.Size)(resources.GetObject("chkPDF.Size")));
			this.chkPDF.TabIndex = ((int)(resources.GetObject("chkPDF.TabIndex")));
			this.chkPDF.Text = resources.GetString("chkPDF.Text");
			this.chkPDF.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkPDF.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.chkPDF, resources.GetString("chkPDF.ToolTip"));
			this.chkPDF.Visible = ((bool)(resources.GetObject("chkPDF.Visible")));
			this.chkPDF.Click += new System.EventHandler(this.chkPDF_Click);
			// 
			// chkDefault
			// 
			this.chkDefault.AccessibleDescription = resources.GetString("chkDefault.AccessibleDescription");
			this.chkDefault.AccessibleName = resources.GetString("chkDefault.AccessibleName");
			this.chkDefault.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("chkDefault.Anchor")));
			this.chkDefault.Appearance = ((System.Windows.Forms.Appearance)(resources.GetObject("chkDefault.Appearance")));
			this.chkDefault.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("chkDefault.BackgroundImage")));
			this.chkDefault.CheckAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkDefault.CheckAlign")));
			this.chkDefault.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("chkDefault.Dock")));
			this.chkDefault.Enabled = ((bool)(resources.GetObject("chkDefault.Enabled")));
			this.chkDefault.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("chkDefault.FlatStyle")));
			this.chkDefault.Font = ((System.Drawing.Font)(resources.GetObject("chkDefault.Font")));
			this.chkDefault.Image = ((System.Drawing.Image)(resources.GetObject("chkDefault.Image")));
			this.chkDefault.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkDefault.ImageAlign")));
			this.chkDefault.ImageIndex = ((int)(resources.GetObject("chkDefault.ImageIndex")));
			this.chkDefault.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("chkDefault.ImeMode")));
			this.chkDefault.Location = ((System.Drawing.Point)(resources.GetObject("chkDefault.Location")));
			this.chkDefault.Name = "chkDefault";
			this.chkDefault.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("chkDefault.RightToLeft")));
			this.chkDefault.Size = ((System.Drawing.Size)(resources.GetObject("chkDefault.Size")));
			this.chkDefault.TabIndex = ((int)(resources.GetObject("chkDefault.TabIndex")));
			this.chkDefault.Text = resources.GetString("chkDefault.Text");
			this.chkDefault.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkDefault.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.chkDefault, resources.GetString("chkDefault.ToolTip"));
			this.chkDefault.Visible = ((bool)(resources.GetObject("chkDefault.Visible")));
			this.chkDefault.Click += new System.EventHandler(this.chkDefault_Click);
			// 
			// chkHAccess
			// 
			this.chkHAccess.AccessibleDescription = resources.GetString("chkHAccess.AccessibleDescription");
			this.chkHAccess.AccessibleName = resources.GetString("chkHAccess.AccessibleName");
			this.chkHAccess.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("chkHAccess.Anchor")));
			this.chkHAccess.Appearance = ((System.Windows.Forms.Appearance)(resources.GetObject("chkHAccess.Appearance")));
			this.chkHAccess.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("chkHAccess.BackgroundImage")));
			this.chkHAccess.CheckAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkHAccess.CheckAlign")));
			this.chkHAccess.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("chkHAccess.Dock")));
			this.chkHAccess.Enabled = ((bool)(resources.GetObject("chkHAccess.Enabled")));
			this.chkHAccess.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("chkHAccess.FlatStyle")));
			this.chkHAccess.Font = ((System.Drawing.Font)(resources.GetObject("chkHAccess.Font")));
			this.chkHAccess.Image = ((System.Drawing.Image)(resources.GetObject("chkHAccess.Image")));
			this.chkHAccess.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkHAccess.ImageAlign")));
			this.chkHAccess.ImageIndex = ((int)(resources.GetObject("chkHAccess.ImageIndex")));
			this.chkHAccess.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("chkHAccess.ImeMode")));
			this.chkHAccess.Location = ((System.Drawing.Point)(resources.GetObject("chkHAccess.Location")));
			this.chkHAccess.Name = "chkHAccess";
			this.chkHAccess.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("chkHAccess.RightToLeft")));
			this.chkHAccess.Size = ((System.Drawing.Size)(resources.GetObject("chkHAccess.Size")));
			this.chkHAccess.TabIndex = ((int)(resources.GetObject("chkHAccess.TabIndex")));
			this.chkHAccess.Text = resources.GetString("chkHAccess.Text");
			this.chkHAccess.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkHAccess.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.chkHAccess, resources.GetString("chkHAccess.ToolTip"));
			this.chkHAccess.Visible = ((bool)(resources.GetObject("chkHAccess.Visible")));
			this.chkHAccess.Click += new System.EventHandler(this.chkHAccess_Click);
			// 
			// owGMappFields
			// 
			this.owGMappFields.AccessibleDescription = resources.GetString("owGMappFields.AccessibleDescription");
			this.owGMappFields.AccessibleName = resources.GetString("owGMappFields.AccessibleName");
			this.owGMappFields.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("owGMappFields.Anchor")));
			this.owGMappFields.AutoScroll = ((bool)(resources.GetObject("owGMappFields.AutoScroll")));
			this.owGMappFields.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("owGMappFields.AutoScrollMargin")));
			this.owGMappFields.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("owGMappFields.AutoScrollMinSize")));
			this.owGMappFields.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("owGMappFields.BackgroundImage")));
			this.owGMappFields.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("owGMappFields.Dock")));
			this.owGMappFields.EditAttribute = "";
			this.owGMappFields.Enabled = ((bool)(resources.GetObject("owGMappFields.Enabled")));
			this.owGMappFields.Font = ((System.Drawing.Font)(resources.GetObject("owGMappFields.Font")));
			this.owGMappFields.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("owGMappFields.ImeMode")));
			this.owGMappFields.LabelEdit = true;
			this.owGMappFields.Location = ((System.Drawing.Point)(resources.GetObject("owGMappFields.Location")));
			this.owGMappFields.Name = "owGMappFields";
			this.owGMappFields.OrderByHeaderClick = true;
			this.owGMappFields.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("owGMappFields.RightToLeft")));
			this.owGMappFields.SelectedIndex = -1;
			this.owGMappFields.Size = ((System.Drawing.Size)(resources.GetObject("owGMappFields.Size")));
			this.owGMappFields.TabIndex = ((int)(resources.GetObject("owGMappFields.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.owGMappFields, resources.GetString("owGMappFields.ToolTip"));
			this.owGMappFields.Visible = ((bool)(resources.GetObject("owGMappFields.Visible")));
			this.owGMappFields.onRowInsert += new OfficeWorks.OWOffice.OWGrid.RowEventHandler(this.owGMappFields_onRowInsert);
			this.owGMappFields.onRowDelete += new OfficeWorks.OWOffice.OWGrid.RowEventHandler(this.owGMappFields_onRowDelete);
			this.owGMappFields.onRowEdit += new OfficeWorks.OWOffice.OWGrid.ValidateEditedLabelHandler(this.owGMappFields_onRowEdit);
			this.owGMappFields.onRowClick += new OfficeWorks.OWOffice.OWGrid.RowEventHandler(this.owGMappFields_onRowClick);
			// 
			// btnRemoveField
			// 
			this.btnRemoveField.AccessibleDescription = resources.GetString("btnRemoveField.AccessibleDescription");
			this.btnRemoveField.AccessibleName = resources.GetString("btnRemoveField.AccessibleName");
			this.btnRemoveField.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnRemoveField.Anchor")));
			this.btnRemoveField.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnRemoveField.BackgroundImage")));
			this.btnRemoveField.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnRemoveField.Dock")));
			this.btnRemoveField.Enabled = ((bool)(resources.GetObject("btnRemoveField.Enabled")));
			this.btnRemoveField.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnRemoveField.FlatStyle")));
			this.btnRemoveField.Font = ((System.Drawing.Font)(resources.GetObject("btnRemoveField.Font")));
			this.btnRemoveField.Image = ((System.Drawing.Image)(resources.GetObject("btnRemoveField.Image")));
			this.btnRemoveField.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnRemoveField.ImageAlign")));
			this.btnRemoveField.ImageIndex = ((int)(resources.GetObject("btnRemoveField.ImageIndex")));
			this.btnRemoveField.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnRemoveField.ImeMode")));
			this.btnRemoveField.Location = ((System.Drawing.Point)(resources.GetObject("btnRemoveField.Location")));
			this.btnRemoveField.Name = "btnRemoveField";
			this.btnRemoveField.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnRemoveField.RightToLeft")));
			this.btnRemoveField.Size = ((System.Drawing.Size)(resources.GetObject("btnRemoveField.Size")));
			this.btnRemoveField.TabIndex = ((int)(resources.GetObject("btnRemoveField.TabIndex")));
			this.btnRemoveField.Text = resources.GetString("btnRemoveField.Text");
			this.btnRemoveField.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnRemoveField.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnRemoveField, resources.GetString("btnRemoveField.ToolTip"));
			this.btnRemoveField.Visible = ((bool)(resources.GetObject("btnRemoveField.Visible")));
			this.btnRemoveField.Click += new System.EventHandler(this.btnRemoveField_Click);
			// 
			// btnAddField
			// 
			this.btnAddField.AccessibleDescription = resources.GetString("btnAddField.AccessibleDescription");
			this.btnAddField.AccessibleName = resources.GetString("btnAddField.AccessibleName");
			this.btnAddField.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnAddField.Anchor")));
			this.btnAddField.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnAddField.BackgroundImage")));
			this.btnAddField.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnAddField.Dock")));
			this.btnAddField.Enabled = ((bool)(resources.GetObject("btnAddField.Enabled")));
			this.btnAddField.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnAddField.FlatStyle")));
			this.btnAddField.Font = ((System.Drawing.Font)(resources.GetObject("btnAddField.Font")));
			this.btnAddField.Image = ((System.Drawing.Image)(resources.GetObject("btnAddField.Image")));
			this.btnAddField.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnAddField.ImageAlign")));
			this.btnAddField.ImageIndex = ((int)(resources.GetObject("btnAddField.ImageIndex")));
			this.btnAddField.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnAddField.ImeMode")));
			this.btnAddField.Location = ((System.Drawing.Point)(resources.GetObject("btnAddField.Location")));
			this.btnAddField.Name = "btnAddField";
			this.btnAddField.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnAddField.RightToLeft")));
			this.btnAddField.Size = ((System.Drawing.Size)(resources.GetObject("btnAddField.Size")));
			this.btnAddField.TabIndex = ((int)(resources.GetObject("btnAddField.TabIndex")));
			this.btnAddField.Text = resources.GetString("btnAddField.Text");
			this.btnAddField.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnAddField.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnAddField, resources.GetString("btnAddField.ToolTip"));
			this.btnAddField.Visible = ((bool)(resources.GetObject("btnAddField.Visible")));
			this.btnAddField.Click += new System.EventHandler(this.btnAddField_Click);
			// 
			// cmdDelTemplateName
			// 
			this.cmdDelTemplateName.AccessibleDescription = resources.GetString("cmdDelTemplateName.AccessibleDescription");
			this.cmdDelTemplateName.AccessibleName = resources.GetString("cmdDelTemplateName.AccessibleName");
			this.cmdDelTemplateName.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmdDelTemplateName.Anchor")));
			this.cmdDelTemplateName.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmdDelTemplateName.BackgroundImage")));
			this.cmdDelTemplateName.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmdDelTemplateName.Dock")));
			this.cmdDelTemplateName.Enabled = ((bool)(resources.GetObject("cmdDelTemplateName.Enabled")));
			this.cmdDelTemplateName.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("cmdDelTemplateName.FlatStyle")));
			this.cmdDelTemplateName.Font = ((System.Drawing.Font)(resources.GetObject("cmdDelTemplateName.Font")));
			this.cmdDelTemplateName.Image = ((System.Drawing.Image)(resources.GetObject("cmdDelTemplateName.Image")));
			this.cmdDelTemplateName.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("cmdDelTemplateName.ImageAlign")));
			this.cmdDelTemplateName.ImageIndex = ((int)(resources.GetObject("cmdDelTemplateName.ImageIndex")));
			this.cmdDelTemplateName.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmdDelTemplateName.ImeMode")));
			this.cmdDelTemplateName.Location = ((System.Drawing.Point)(resources.GetObject("cmdDelTemplateName.Location")));
			this.cmdDelTemplateName.Name = "cmdDelTemplateName";
			this.cmdDelTemplateName.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmdDelTemplateName.RightToLeft")));
			this.cmdDelTemplateName.Size = ((System.Drawing.Size)(resources.GetObject("cmdDelTemplateName.Size")));
			this.cmdDelTemplateName.TabIndex = ((int)(resources.GetObject("cmdDelTemplateName.TabIndex")));
			this.cmdDelTemplateName.Text = resources.GetString("cmdDelTemplateName.Text");
			this.cmdDelTemplateName.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("cmdDelTemplateName.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.cmdDelTemplateName, resources.GetString("cmdDelTemplateName.ToolTip"));
			this.cmdDelTemplateName.Visible = ((bool)(resources.GetObject("cmdDelTemplateName.Visible")));
			this.cmdDelTemplateName.Click += new System.EventHandler(this.cmdDelTemplateName_Click);
			// 
			// listTemplate
			// 
			this.listTemplate.AccessibleDescription = resources.GetString("listTemplate.AccessibleDescription");
			this.listTemplate.AccessibleName = resources.GetString("listTemplate.AccessibleName");
			this.listTemplate.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listTemplate.Anchor")));
			this.listTemplate.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listTemplate.BackgroundImage")));
			this.listTemplate.ColumnWidth = ((int)(resources.GetObject("listTemplate.ColumnWidth")));
			this.listTemplate.DisplayMember = "Text";
			this.listTemplate.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listTemplate.Dock")));
			this.listTemplate.Enabled = ((bool)(resources.GetObject("listTemplate.Enabled")));
			this.listTemplate.Font = ((System.Drawing.Font)(resources.GetObject("listTemplate.Font")));
			this.listTemplate.HorizontalExtent = ((int)(resources.GetObject("listTemplate.HorizontalExtent")));
			this.listTemplate.HorizontalScrollbar = ((bool)(resources.GetObject("listTemplate.HorizontalScrollbar")));
			this.listTemplate.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listTemplate.ImeMode")));
			this.listTemplate.IntegralHeight = ((bool)(resources.GetObject("listTemplate.IntegralHeight")));
			this.listTemplate.ItemHeight = ((int)(resources.GetObject("listTemplate.ItemHeight")));
			this.listTemplate.Location = ((System.Drawing.Point)(resources.GetObject("listTemplate.Location")));
			this.listTemplate.Name = "listTemplate";
			this.listTemplate.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listTemplate.RightToLeft")));
			this.listTemplate.ScrollAlwaysVisible = ((bool)(resources.GetObject("listTemplate.ScrollAlwaysVisible")));
			this.listTemplate.Size = ((System.Drawing.Size)(resources.GetObject("listTemplate.Size")));
			this.listTemplate.TabIndex = ((int)(resources.GetObject("listTemplate.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listTemplate, resources.GetString("listTemplate.ToolTip"));
			this.listTemplate.Visible = ((bool)(resources.GetObject("listTemplate.Visible")));
			this.listTemplate.KeyUp += new System.Windows.Forms.KeyEventHandler(this.listTemplate_KeyUp);
			this.listTemplate.Click += new System.EventHandler(this.listTemplate_Click);
			// 
			// txtNewTemplateName
			// 
			this.txtNewTemplateName.AccessibleDescription = resources.GetString("txtNewTemplateName.AccessibleDescription");
			this.txtNewTemplateName.AccessibleName = resources.GetString("txtNewTemplateName.AccessibleName");
			this.txtNewTemplateName.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("txtNewTemplateName.Anchor")));
			this.txtNewTemplateName.AutoSize = ((bool)(resources.GetObject("txtNewTemplateName.AutoSize")));
			this.txtNewTemplateName.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("txtNewTemplateName.BackgroundImage")));
			this.txtNewTemplateName.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("txtNewTemplateName.Dock")));
			this.txtNewTemplateName.Enabled = ((bool)(resources.GetObject("txtNewTemplateName.Enabled")));
			this.txtNewTemplateName.Font = ((System.Drawing.Font)(resources.GetObject("txtNewTemplateName.Font")));
			this.txtNewTemplateName.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("txtNewTemplateName.ImeMode")));
			this.txtNewTemplateName.Location = ((System.Drawing.Point)(resources.GetObject("txtNewTemplateName.Location")));
			this.txtNewTemplateName.MaxLength = ((int)(resources.GetObject("txtNewTemplateName.MaxLength")));
			this.txtNewTemplateName.Multiline = ((bool)(resources.GetObject("txtNewTemplateName.Multiline")));
			this.txtNewTemplateName.Name = "txtNewTemplateName";
			this.txtNewTemplateName.PasswordChar = ((char)(resources.GetObject("txtNewTemplateName.PasswordChar")));
			this.txtNewTemplateName.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("txtNewTemplateName.RightToLeft")));
			this.txtNewTemplateName.ScrollBars = ((System.Windows.Forms.ScrollBars)(resources.GetObject("txtNewTemplateName.ScrollBars")));
			this.txtNewTemplateName.Size = ((System.Drawing.Size)(resources.GetObject("txtNewTemplateName.Size")));
			this.txtNewTemplateName.TabIndex = ((int)(resources.GetObject("txtNewTemplateName.TabIndex")));
			this.txtNewTemplateName.Text = resources.GetString("txtNewTemplateName.Text");
			this.txtNewTemplateName.TextAlign = ((System.Windows.Forms.HorizontalAlignment)(resources.GetObject("txtNewTemplateName.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.txtNewTemplateName, resources.GetString("txtNewTemplateName.ToolTip"));
			this.txtNewTemplateName.Visible = ((bool)(resources.GetObject("txtNewTemplateName.Visible")));
			this.txtNewTemplateName.WordWrap = ((bool)(resources.GetObject("txtNewTemplateName.WordWrap")));
			// 
			// cmdAddTemplateName
			// 
			this.cmdAddTemplateName.AccessibleDescription = resources.GetString("cmdAddTemplateName.AccessibleDescription");
			this.cmdAddTemplateName.AccessibleName = resources.GetString("cmdAddTemplateName.AccessibleName");
			this.cmdAddTemplateName.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmdAddTemplateName.Anchor")));
			this.cmdAddTemplateName.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmdAddTemplateName.BackgroundImage")));
			this.cmdAddTemplateName.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmdAddTemplateName.Dock")));
			this.cmdAddTemplateName.Enabled = ((bool)(resources.GetObject("cmdAddTemplateName.Enabled")));
			this.cmdAddTemplateName.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("cmdAddTemplateName.FlatStyle")));
			this.cmdAddTemplateName.Font = ((System.Drawing.Font)(resources.GetObject("cmdAddTemplateName.Font")));
			this.cmdAddTemplateName.Image = ((System.Drawing.Image)(resources.GetObject("cmdAddTemplateName.Image")));
			this.cmdAddTemplateName.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("cmdAddTemplateName.ImageAlign")));
			this.cmdAddTemplateName.ImageIndex = ((int)(resources.GetObject("cmdAddTemplateName.ImageIndex")));
			this.cmdAddTemplateName.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmdAddTemplateName.ImeMode")));
			this.cmdAddTemplateName.Location = ((System.Drawing.Point)(resources.GetObject("cmdAddTemplateName.Location")));
			this.cmdAddTemplateName.Name = "cmdAddTemplateName";
			this.cmdAddTemplateName.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmdAddTemplateName.RightToLeft")));
			this.cmdAddTemplateName.Size = ((System.Drawing.Size)(resources.GetObject("cmdAddTemplateName.Size")));
			this.cmdAddTemplateName.TabIndex = ((int)(resources.GetObject("cmdAddTemplateName.TabIndex")));
			this.cmdAddTemplateName.Text = resources.GetString("cmdAddTemplateName.Text");
			this.cmdAddTemplateName.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("cmdAddTemplateName.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.cmdAddTemplateName, resources.GetString("cmdAddTemplateName.ToolTip"));
			this.cmdAddTemplateName.Visible = ((bool)(resources.GetObject("cmdAddTemplateName.Visible")));
			this.cmdAddTemplateName.Click += new System.EventHandler(this.cmdAddTemplateName_Click);
			// 
			// lblTemplateName
			// 
			this.lblTemplateName.AccessibleDescription = resources.GetString("lblTemplateName.AccessibleDescription");
			this.lblTemplateName.AccessibleName = resources.GetString("lblTemplateName.AccessibleName");
			this.lblTemplateName.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("lblTemplateName.Anchor")));
			this.lblTemplateName.AutoSize = ((bool)(resources.GetObject("lblTemplateName.AutoSize")));
			this.lblTemplateName.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("lblTemplateName.Dock")));
			this.lblTemplateName.Enabled = ((bool)(resources.GetObject("lblTemplateName.Enabled")));
			this.lblTemplateName.Font = ((System.Drawing.Font)(resources.GetObject("lblTemplateName.Font")));
			this.lblTemplateName.Image = ((System.Drawing.Image)(resources.GetObject("lblTemplateName.Image")));
			this.lblTemplateName.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblTemplateName.ImageAlign")));
			this.lblTemplateName.ImageIndex = ((int)(resources.GetObject("lblTemplateName.ImageIndex")));
			this.lblTemplateName.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("lblTemplateName.ImeMode")));
			this.lblTemplateName.Location = ((System.Drawing.Point)(resources.GetObject("lblTemplateName.Location")));
			this.lblTemplateName.Name = "lblTemplateName";
			this.lblTemplateName.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("lblTemplateName.RightToLeft")));
			this.lblTemplateName.Size = ((System.Drawing.Size)(resources.GetObject("lblTemplateName.Size")));
			this.lblTemplateName.TabIndex = ((int)(resources.GetObject("lblTemplateName.TabIndex")));
			this.lblTemplateName.Text = resources.GetString("lblTemplateName.Text");
			this.lblTemplateName.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblTemplateName.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.lblTemplateName, resources.GetString("lblTemplateName.ToolTip"));
			this.lblTemplateName.Visible = ((bool)(resources.GetObject("lblTemplateName.Visible")));
			// 
			// listDocumentTypes
			// 
			this.listDocumentTypes.AccessibleDescription = resources.GetString("listDocumentTypes.AccessibleDescription");
			this.listDocumentTypes.AccessibleName = resources.GetString("listDocumentTypes.AccessibleName");
			this.listDocumentTypes.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listDocumentTypes.Anchor")));
			this.listDocumentTypes.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listDocumentTypes.BackgroundImage")));
			this.listDocumentTypes.ColumnWidth = ((int)(resources.GetObject("listDocumentTypes.ColumnWidth")));
			this.listDocumentTypes.DisplayMember = "Text";
			this.listDocumentTypes.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listDocumentTypes.Dock")));
			this.listDocumentTypes.Enabled = ((bool)(resources.GetObject("listDocumentTypes.Enabled")));
			this.listDocumentTypes.Font = ((System.Drawing.Font)(resources.GetObject("listDocumentTypes.Font")));
			this.listDocumentTypes.HorizontalExtent = ((int)(resources.GetObject("listDocumentTypes.HorizontalExtent")));
			this.listDocumentTypes.HorizontalScrollbar = ((bool)(resources.GetObject("listDocumentTypes.HorizontalScrollbar")));
			this.listDocumentTypes.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listDocumentTypes.ImeMode")));
			this.listDocumentTypes.IntegralHeight = ((bool)(resources.GetObject("listDocumentTypes.IntegralHeight")));
			this.listDocumentTypes.ItemHeight = ((int)(resources.GetObject("listDocumentTypes.ItemHeight")));
			this.listDocumentTypes.Location = ((System.Drawing.Point)(resources.GetObject("listDocumentTypes.Location")));
			this.listDocumentTypes.Name = "listDocumentTypes";
			this.listDocumentTypes.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listDocumentTypes.RightToLeft")));
			this.listDocumentTypes.ScrollAlwaysVisible = ((bool)(resources.GetObject("listDocumentTypes.ScrollAlwaysVisible")));
			this.listDocumentTypes.Size = ((System.Drawing.Size)(resources.GetObject("listDocumentTypes.Size")));
			this.listDocumentTypes.TabIndex = ((int)(resources.GetObject("listDocumentTypes.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listDocumentTypes, resources.GetString("listDocumentTypes.ToolTip"));
			this.listDocumentTypes.Visible = ((bool)(resources.GetObject("listDocumentTypes.Visible")));
			this.listDocumentTypes.KeyUp += new System.Windows.Forms.KeyEventHandler(this.listDocumentTypes_KeyUp);
			this.listDocumentTypes.Click += new System.EventHandler(this.listDocumentTypes_Click);
			// 
			// listBooks
			// 
			this.listBooks.AccessibleDescription = resources.GetString("listBooks.AccessibleDescription");
			this.listBooks.AccessibleName = resources.GetString("listBooks.AccessibleName");
			this.listBooks.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listBooks.Anchor")));
			this.listBooks.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listBooks.BackgroundImage")));
			this.listBooks.ColumnWidth = ((int)(resources.GetObject("listBooks.ColumnWidth")));
			this.listBooks.DisplayMember = "Text";
			this.listBooks.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listBooks.Dock")));
			this.listBooks.Enabled = ((bool)(resources.GetObject("listBooks.Enabled")));
			this.listBooks.Font = ((System.Drawing.Font)(resources.GetObject("listBooks.Font")));
			this.listBooks.HorizontalExtent = ((int)(resources.GetObject("listBooks.HorizontalExtent")));
			this.listBooks.HorizontalScrollbar = ((bool)(resources.GetObject("listBooks.HorizontalScrollbar")));
			this.listBooks.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listBooks.ImeMode")));
			this.listBooks.IntegralHeight = ((bool)(resources.GetObject("listBooks.IntegralHeight")));
			this.listBooks.ItemHeight = ((int)(resources.GetObject("listBooks.ItemHeight")));
			this.listBooks.Location = ((System.Drawing.Point)(resources.GetObject("listBooks.Location")));
			this.listBooks.Name = "listBooks";
			this.listBooks.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listBooks.RightToLeft")));
			this.listBooks.ScrollAlwaysVisible = ((bool)(resources.GetObject("listBooks.ScrollAlwaysVisible")));
			this.listBooks.Size = ((System.Drawing.Size)(resources.GetObject("listBooks.Size")));
			this.listBooks.TabIndex = ((int)(resources.GetObject("listBooks.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listBooks, resources.GetString("listBooks.ToolTip"));
			this.listBooks.Visible = ((bool)(resources.GetObject("listBooks.Visible")));
			this.listBooks.KeyUp += new System.Windows.Forms.KeyEventHandler(this.listBooks_KeyUp);
			this.listBooks.Click += new System.EventHandler(this.listBooks_Click);
			// 
			// lblOfficeWorksDocumentType
			// 
			this.lblOfficeWorksDocumentType.AccessibleDescription = resources.GetString("lblOfficeWorksDocumentType.AccessibleDescription");
			this.lblOfficeWorksDocumentType.AccessibleName = resources.GetString("lblOfficeWorksDocumentType.AccessibleName");
			this.lblOfficeWorksDocumentType.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("lblOfficeWorksDocumentType.Anchor")));
			this.lblOfficeWorksDocumentType.AutoSize = ((bool)(resources.GetObject("lblOfficeWorksDocumentType.AutoSize")));
			this.lblOfficeWorksDocumentType.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("lblOfficeWorksDocumentType.Dock")));
			this.lblOfficeWorksDocumentType.Enabled = ((bool)(resources.GetObject("lblOfficeWorksDocumentType.Enabled")));
			this.lblOfficeWorksDocumentType.Font = ((System.Drawing.Font)(resources.GetObject("lblOfficeWorksDocumentType.Font")));
			this.lblOfficeWorksDocumentType.Image = ((System.Drawing.Image)(resources.GetObject("lblOfficeWorksDocumentType.Image")));
			this.lblOfficeWorksDocumentType.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblOfficeWorksDocumentType.ImageAlign")));
			this.lblOfficeWorksDocumentType.ImageIndex = ((int)(resources.GetObject("lblOfficeWorksDocumentType.ImageIndex")));
			this.lblOfficeWorksDocumentType.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("lblOfficeWorksDocumentType.ImeMode")));
			this.lblOfficeWorksDocumentType.Location = ((System.Drawing.Point)(resources.GetObject("lblOfficeWorksDocumentType.Location")));
			this.lblOfficeWorksDocumentType.Name = "lblOfficeWorksDocumentType";
			this.lblOfficeWorksDocumentType.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("lblOfficeWorksDocumentType.RightToLeft")));
			this.lblOfficeWorksDocumentType.Size = ((System.Drawing.Size)(resources.GetObject("lblOfficeWorksDocumentType.Size")));
			this.lblOfficeWorksDocumentType.TabIndex = ((int)(resources.GetObject("lblOfficeWorksDocumentType.TabIndex")));
			this.lblOfficeWorksDocumentType.Text = resources.GetString("lblOfficeWorksDocumentType.Text");
			this.lblOfficeWorksDocumentType.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblOfficeWorksDocumentType.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.lblOfficeWorksDocumentType, resources.GetString("lblOfficeWorksDocumentType.ToolTip"));
			this.lblOfficeWorksDocumentType.Visible = ((bool)(resources.GetObject("lblOfficeWorksDocumentType.Visible")));
			// 
			// lblOfficeWorksBook
			// 
			this.lblOfficeWorksBook.AccessibleDescription = resources.GetString("lblOfficeWorksBook.AccessibleDescription");
			this.lblOfficeWorksBook.AccessibleName = resources.GetString("lblOfficeWorksBook.AccessibleName");
			this.lblOfficeWorksBook.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("lblOfficeWorksBook.Anchor")));
			this.lblOfficeWorksBook.AutoSize = ((bool)(resources.GetObject("lblOfficeWorksBook.AutoSize")));
			this.lblOfficeWorksBook.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("lblOfficeWorksBook.Dock")));
			this.lblOfficeWorksBook.Enabled = ((bool)(resources.GetObject("lblOfficeWorksBook.Enabled")));
			this.lblOfficeWorksBook.Font = ((System.Drawing.Font)(resources.GetObject("lblOfficeWorksBook.Font")));
			this.lblOfficeWorksBook.Image = ((System.Drawing.Image)(resources.GetObject("lblOfficeWorksBook.Image")));
			this.lblOfficeWorksBook.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblOfficeWorksBook.ImageAlign")));
			this.lblOfficeWorksBook.ImageIndex = ((int)(resources.GetObject("lblOfficeWorksBook.ImageIndex")));
			this.lblOfficeWorksBook.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("lblOfficeWorksBook.ImeMode")));
			this.lblOfficeWorksBook.Location = ((System.Drawing.Point)(resources.GetObject("lblOfficeWorksBook.Location")));
			this.lblOfficeWorksBook.Name = "lblOfficeWorksBook";
			this.lblOfficeWorksBook.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("lblOfficeWorksBook.RightToLeft")));
			this.lblOfficeWorksBook.Size = ((System.Drawing.Size)(resources.GetObject("lblOfficeWorksBook.Size")));
			this.lblOfficeWorksBook.TabIndex = ((int)(resources.GetObject("lblOfficeWorksBook.TabIndex")));
			this.lblOfficeWorksBook.Text = resources.GetString("lblOfficeWorksBook.Text");
			this.lblOfficeWorksBook.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblOfficeWorksBook.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.lblOfficeWorksBook, resources.GetString("lblOfficeWorksBook.ToolTip"));
			this.lblOfficeWorksBook.Visible = ((bool)(resources.GetObject("lblOfficeWorksBook.Visible")));
			// 
			// menuSaveFileAs
			// 
			this.menuSaveFileAs.Enabled = ((bool)(resources.GetObject("menuSaveFileAs.Enabled")));
			this.menuSaveFileAs.Index = 5;
			this.menuSaveFileAs.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuSaveFileAs.Shortcut")));
			this.menuSaveFileAs.ShowShortcut = ((bool)(resources.GetObject("menuSaveFileAs.ShowShortcut")));
			this.menuSaveFileAs.Text = resources.GetString("menuSaveFileAs.Text");
			this.menuSaveFileAs.Visible = ((bool)(resources.GetObject("menuSaveFileAs.Visible")));
			this.menuSaveFileAs.Click += new System.EventHandler(this.menuSaveAs_Click);
			// 
			// MainForm
			// 
			this.AccessibleDescription = resources.GetString("$this.AccessibleDescription");
			this.AccessibleName = resources.GetString("$this.AccessibleName");
			this.AutoScaleBaseSize = ((System.Drawing.Size)(resources.GetObject("$this.AutoScaleBaseSize")));
			this.AutoScroll = ((bool)(resources.GetObject("$this.AutoScroll")));
			this.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("$this.AutoScrollMargin")));
			this.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("$this.AutoScrollMinSize")));
			this.BackColor = System.Drawing.SystemColors.Control;
			this.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("$this.BackgroundImage")));
			this.ClientSize = ((System.Drawing.Size)(resources.GetObject("$this.ClientSize")));
			this.Controls.Add(this.tabControl1);
			this.Enabled = ((bool)(resources.GetObject("$this.Enabled")));
			this.Font = ((System.Drawing.Font)(resources.GetObject("$this.Font")));
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.HelpButton = true;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("$this.ImeMode")));
			this.Location = ((System.Drawing.Point)(resources.GetObject("$this.Location")));
			this.MaximizeBox = false;
			this.MaximumSize = ((System.Drawing.Size)(resources.GetObject("$this.MaximumSize")));
			this.Menu = this.mainMenu1;
			this.MinimumSize = ((System.Drawing.Size)(resources.GetObject("$this.MinimumSize")));
			this.Name = "MainForm";
			this.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("$this.RightToLeft")));
			this.StartPosition = ((System.Windows.Forms.FormStartPosition)(resources.GetObject("$this.StartPosition")));
			this.Tag = "";
			this.Text = resources.GetString("$this.Text");
			this.toolTipMainForm.SetToolTip(this, resources.GetString("$this.ToolTip"));
			this.Closing += new System.ComponentModel.CancelEventHandler(this.MainForm_Closing);
			this.Load += new System.EventHandler(this.MainForm_Load);
			this.tabControl1.ResumeLayout(false);
			this.tabPageGeral.ResumeLayout(false);
			this.pnProcessando.ResumeLayout(false);
			this.tabPageMappings.ResumeLayout(false);
			this.groupBox1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion//*****************************************************************************

		#region PROPERTIES
		//***************************************************************************************
		
		/// <summary>
		/// Active operation
		/// </summary>
		public OperationMode ActiveOperationMode
		{
			get
			{
				return _activeOperationMode;
			}
			set
			{
				_activeOperationMode = value;
			}
		}
		
		public static string ApplicationTitle
		{
			get
			{
				AssemblyName appName = Assembly.GetExecutingAssembly().GetName();
				return appName.Name + " " + ApplicationVersion;

			}
		}

		public static string ApplicationVersion
		{
			get
			{
				AssemblyName appName = Assembly.GetExecutingAssembly().GetName();
				return appName.Version.Major.ToString() + "." + appName.Version.Minor.ToString();

			}
		}

		public static string MsgboxTitle
		{
			get
			{
				AssemblyName appName = Assembly.GetExecutingAssembly().GetName();
				
				return appName.Name;

			}
		}

		#endregion//*****************************************************************************

		#region CONSTRUCTORS
		//***************************************************************************************

		/// <summary>
		/// Default constructor.
		/// </summary>
		public MainForm()
		{			
			InitializeComponent();
			
		}
		
		#endregion//*****************************************************************************

		#region FORM_EVENTS
		//***************************************************************************************
		
		private void btnCancelWS_Click(object sender, System.EventArgs e)
		{
			thrWebService.Abort();
			lblMsg.Text = "A cancelar ligação a Web Service...";
		}

		private void txtWebServiceUrl_TextChanged(object sender, System.EventArgs e)
		{
			//Set bIsWebServiceValid to false to be tested again
			bIsWebServiceValid = false;
		}

		private void tabControl1_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			//Call Web Service asynchronously, and if it is Available then get Books
			if (tabControl1.SelectedIndex==1 && !bIsWebServiceValid)	
			{
				CallWebService();
				tabControl1.SelectedIndex=0;	
			}					
		}

		private void btnAddField_Click(object sender, System.EventArgs e)
		{			
			frmOWNFields.ShowDialog(this);	
			
		}

		private void btnRemoveField_Click(object sender, System.EventArgs e)
		{
			if (MessageBox.Show("Tem a certeza que quer remover?", MsgboxTitle, MessageBoxButtons.YesNo)== DialogResult.No)
				return;			
			owGMappFields.RemoveSelectedRow();
			btnRemoveField.Enabled=false;
			//Revalidate the mapping fields (mark invalid rows)
			RevalidateMappGrid();
		}
		

		private void chkHAccess_Click(object sender, System.EventArgs e)
		{
			if (listTemplate.SelectedItem !=null)
			{
				TemplateCfg oTemplate = (TemplateCfg)((ListViewItem) listTemplate.SelectedItem).Tag;
				oTemplate.HierarchicAccess = chkHAccess.Checked;
			}
		}

		private void chkAccessRequired_Click(object sender, System.EventArgs e)
		{
			
			if (listTemplate.SelectedItem !=null)
			{
				TemplateCfg oTemplate = (TemplateCfg)((ListViewItem) listTemplate.SelectedItem).Tag;
				oTemplate.AccessesRiquired = chkAccessRequired.Checked;
			}
		}

		private void chkDefault_Click(object sender, System.EventArgs e)
		{
			if (listTemplate.SelectedItem !=null)
			{
				TemplateCfg oTemplate = (TemplateCfg)((ListViewItem) listTemplate.SelectedItem).Tag;
				oTemplate.ShowRegistryDefault = chkDefault.Checked;
			}
		}	


		private void chkPDF_Click(object sender, System.EventArgs e)
		{
			if (listTemplate.SelectedItem !=null)
			{
				TemplateCfg oTemplate = (TemplateCfg)((ListViewItem) listTemplate.SelectedItem).Tag;
				oTemplate.PDFConvert = chkPDF.Checked;
			}
		}	

		private void listBooks_KeyUp(object sender, KeyEventArgs e)
		{
			listBooks_Click(sender, new EventArgs());
		}


		/// <summary>
		/// Select a book on listbox
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listBooks_Click(object sender, EventArgs e)
		{
			if (listTemplate.SelectedIndices.Count==0)
			{
				MessageBox.Show("Seleccione um Template da lista!", MsgboxTitle);
				return;
			}

			if (listTemplate.SelectedIndex!=-1)
				btnAddField.Enabled = true;
			else
				btnAddField.Enabled = false;

			//Set new book id for selected template
			int iIdx = GetListSelectedIndex(listTemplate);
			if(iIdx>=0)
			{				
				TemplateCfg oConfigAux = SetTemplateConfigAux(iIdx);
				oConfigAux.BookAbreviation = ((stBook)((ListViewItem)listBooks.SelectedItem).Tag).BookAbreviation;
				oConfigAux.BookDescription = ((stBook)((ListViewItem)listBooks.SelectedItem).Tag).BookDescription;
				SetValuesToTemplateConfigArray(iIdx, oConfigAux);
				GetDocumentTypes();
				ValidateAndSelectDocumentTypes(iIdx);
				GetOfficeWorksFields();
			}
			//Revalidate the mapping fields (mark invalid rows)
			RevalidateMappGrid();
		}


		private void listDocumentTypes_KeyUp(object sender, KeyEventArgs e)
		{
			listDocumentTypes_Click(sender, new EventArgs());
		}

		/// <summary>
		/// Select Document type on listbox
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listDocumentTypes_Click(object sender, EventArgs e)
		{
			//Set new document type id for selected template
			int iIdx = GetListSelectedIndex(listTemplate);
			if(iIdx >= 0 && listDocumentTypes.SelectedItem != null)
			{
				TemplateCfg oConfigAux = SetTemplateConfigAux(iIdx);
				oConfigAux.DocumentTypeAbreviation = ((stDocumentType)((ListViewItem)listDocumentTypes.SelectedItem).Tag).DocumentTypeAbreviation;				
				oConfigAux.DocumentTypeDescription = ((stDocumentType)((ListViewItem)listDocumentTypes.SelectedItem).Tag).DocumentTypeDescription;				
				SetValuesToTemplateConfigArray(iIdx, oConfigAux);
			}
			
		}

		
		/// <summary>
		/// Vrify if webservice url changed
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void WebServiceUrlChanged(object sender, System.EventArgs e)
		{			
			//Call Web Service asynchronously, and if it is Available then get Books			
			//System.Threading.Thread WebService = new System.Threading.Thread(new System.Threading.ThreadStart(WebServiceIsAvailable));
			//WebService.Start();
			//WebService = null;			
		}

		private void owGMappFields_onRowInsert(int Index, OWGrid Grid)
		{
			RefreshTemplateCollection(Grid);
		}

		private void owGMappFields_onRowClick(int Index, OWGrid Grid)
		{			
			if (owGMappFields.SelectedIndex!=-1)
				btnRemoveField.Enabled=true;
			else
				btnRemoveField.Enabled=false;
		}
		
		private void owGMappFields_onRowDelete(int Index, OWGrid Grid)
		{			
			RefreshTemplateCollection(Grid);				
		}

		private void owGMappFields_onRowEdit(OWGrid.ValidateEditedLabelArgs e)
		{				
			string sCopyLable = e.Label;
			string sOldLable = ((MappedField)owGMappFields.ObjectItems[e.Index]).BookmarkName;
			//if the field is a Entity then add [origem] [destino] at the end of edited lable
			switch (Convert.ToInt64(((MappedField)owGMappFields.ObjectItems[e.Index]).FieldIdentifier))
			{				
				case (long) enumFieldName.FieldNameMoreEntities:
				{
					e.Label += (((MappedField)owGMappFields.ObjectItems[e.Index]).EntityType == OfficeWorks.OWOffice.enumEntityType.EntityTypeOrigin	?	" [Origem]" : " [Destino]");
					sOldLable += (((MappedField)owGMappFields.ObjectItems[e.Index]).EntityType == OfficeWorks.OWOffice.enumEntityType.EntityTypeOrigin	?	" [Origem]" : " [Destino]");
					break;
				}
			}	

			// Test if the lable contains invalid chars
			if (sCopyLable.ToUpper() != OWFieldsForm.FormatBookmarkName(sCopyLable))
			{
				MessageBox.Show("A Bookmark escolhida contém caracteres inválidos!",MsgboxTitle);				
				//if invalid data set label to the old
				e.Label = sOldLable;
				e.Cancel = true;
				return;
			}			

			// Test if the lable already exists
			for(int iX=0 ; iX < owGMappFields.ObjectItems.Count ; iX++)			
				if (((MappedField)owGMappFields.ObjectItems[iX]).BookmarkName == sCopyLable &&  iX != e.Index)
				{					
					MessageBox.Show("Bookmark já existente!", MsgboxTitle);
					//if invalid data set label to the old
					e.Label = sOldLable;
					e.Cancel = true;
					return;
				}			
		}		


		/// <summary>
		/// Load Main Form
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void MainForm_Load(object sender, EventArgs e)
		{
			Initialize();			
			
			//owGMappFields
			owGMappFields.EditAttribute = "BookmarkName";
			owGMappFields.SetColumns(new string[]{"Bookmarks","Campos OfficeWorks"});
			owGMappFields.SetColumnWidth(0,210);
			owGMappFields.SetColumnWidth(1,210);									
			//Create an instance of OWFieldsForm linked to owGMappFields grid
			frmOWNFields = new OWFieldsForm(owGMappFields,MsgboxTitle);			
			
		}


		/// <summary>
		/// Close form
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void MainForm_Closing(object sender, CancelEventArgs e)
		{			
			if(!ExitApplication())			
				e.Cancel=true;						
			else				
			{	if (thrWebService != null)
					thrWebService.Abort();
			}
			
		}

		/// <summary>
		/// Create a new file
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuNewFile_Click(object sender, EventArgs e)
		{

			CreateFile();
		}


		/// <summary>
		/// Open a existing file
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuOpenFile_Click(object sender, EventArgs e)
		{
			OpenFile();
		}


		/// <summary>
		/// Close a file
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuCloseFile_Click(object sender, EventArgs e)
		{
			CloseFile();			
		}


		/// <summary>
		/// Save a file
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuSaveFile_Click(object sender, EventArgs e)
		{
			SaveFile();
		}


		/// <summary>
		/// Exit application
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuExit_Click(object sender, EventArgs e)
		{
			ExitApplication();
		}

		
		/// <summary>
		/// About application info
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuAbout_Click(object sender, EventArgs e)
		{
			ShowCopyright();
		}





		/// <summary>
		/// Add a template to listbox
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void cmdAddTemplateName_Click(object sender, EventArgs e)
		{			
			if(ValidateNewTemplateName(txtNewTemplateName.Text))
			{
				//Reset Template Child Objects
				ResetTemplateChildObjects();

				//New Template
				TemplateCfg oNewTemplate = new TemplateCfg();
				oNewTemplate.TemplateName = txtNewTemplateName.Text;
				oNewTemplate.MappedFields = new ArrayList();								
				//New Item for the Template
				ListViewItem oNewItem = new ListViewItem(oNewTemplate.TemplateName);				
				oNewItem.Tag = oNewTemplate;
				//Add Item
				listTemplate.Items.Add(oNewItem);							

				//Select the New Template
				listTemplate.SetSelected((listTemplate.Items.Count-1),true);
				txtNewTemplateName.Text="";			
			}
		}


		/// <summary>
		/// Delete a template to listbox
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void cmdDelTemplateName_Click(object sender, EventArgs e)
		{
			if(listTemplate.SelectedItems.Count > 0)
			{
				if (MessageBox.Show("Tem a certeza que quer remover?", MsgboxTitle, MessageBoxButtons.YesNo)== DialogResult.No)
					return;

				listTemplate.Items.Remove(listTemplate.SelectedItem);				
				//Reset Template Child Objects
				ResetTemplateChildObjects();
			}
			else
			{
				MessageBox.Show("Seleccione um Template da lista!", MsgboxTitle);
			}
		}

	
		private void listTemplate_KeyUp(object sender, KeyEventArgs e)
		{				
			listTemplate_Click(sender, new EventArgs());		
		}

		/// <summary>
		/// Template index change
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listTemplate_Click(object sender, EventArgs e)
		{			
			
			//Se não existirem livros não selecciona nada
			if(listBooks.Items.Count>0)
			{
				//Select book for template
				SelectBookForTemplate();
				//Select document type for template
				//SelectDocumentType();		
				//Get template mappings
				SelectMappingsForTempalte();
				//Revalidate the mapping fields (mark invalid rows)
				RevalidateMappGrid();
				
				//Enable Checks if any template selected
				if (listTemplate.SelectedItem!=null)
				{	
					
					chkDefault.Enabled = true;
					chkPDF.Enabled = true;
					chkHAccess.Enabled = true;
					chkAccessRequired.Enabled = true;
					chkDefault.Checked = ((TemplateCfg) ((ListViewItem) listTemplate.SelectedItem).Tag).ShowRegistryDefault;
					chkPDF.Checked = ((TemplateCfg) ((ListViewItem) listTemplate.SelectedItem).Tag).PDFConvert;
					chkHAccess.Checked = ((TemplateCfg) ((ListViewItem) listTemplate.SelectedItem).Tag).HierarchicAccess;
					chkAccessRequired.Checked = ((TemplateCfg) ((ListViewItem) listTemplate.SelectedItem).Tag).AccessesRiquired;
				}
			}
		}


		#endregion//*****************************************************************************

		#region METHODS
		//***************************************************************************************
		/// <summary>
		/// Set initial operation mode
		/// </summary>
		private void Initialize()
		{
			SetOperationMode(OperationMode.Idle);
		}


		/// <summary>
		/// Initialize a new OWOffice Configuration
		/// </summary>
		private void InitializeNewConfiguration()
		{
			Configuration = new OWC();			
			ConfigurationCopy = new OWC();			
		}


		/// <summary>
		/// Initialize an OWOffice Configuration from a file
		/// </summary>
		private void InitializeConfiguration()
		{
			Configuration = Serializer.Deserialize(_filePath);
			ConfigurationCopy = Serializer.Deserialize(_filePath);
		}


		/// <summary>
		/// Check if a valid configuration instance is available before proceeding.
		/// </summary>
		/// <returns>TRUE if a valid configuration was found, otherwise FALSE is returned.</returns>
		private bool IsValidConfiguration()
		{
			if (Configuration != null)
			{
				return true;
			}
			return false;
		}


		/// <summary>
		/// Read Configuration from a file
		/// </summary>
		private void ReadConfiguration()
		{
			InitializeConfiguration();
			if (IsValidConfiguration())
			{
				GetConfigurationValues();
				SetOperationMode(OperationMode.Edit);
			}
			else
			{				
				SetOperationMode(OperationMode.Idle);
				MessageBox.Show("O ficheiro de configuração não é válido", MsgboxTitle);
			}
		}


		/// <summary>
		/// Create a new file for OWOffice Configuration
		/// </summary>
		private void CreateFile()
		{
			//close the current file
			if (!CloseFile())
				return;

			ResetConfiguration();
			_filePath = string.Empty;			
			SetOperationMode(OperationMode.New);
		}

		
		/// <summary>
		/// Open an OWOffice Configuration file
		/// </summary>
		private void OpenFile()
		{
			ResetConfiguration();
			OpenFileDialog openFileDialog = new OpenFileDialog();
			openFileDialog.Filter = string.Format("Ficheiro de configuração do OWOffice {0}|{1}", ApplicationVersion,"*." + _file_ext);
			openFileDialog.Title = "Abrir";
			if (openFileDialog.ShowDialog() == DialogResult.OK)
			{				
				_filePath = openFileDialog.FileName;
				ReadConfiguration();				
			}
		}


		/// <summary>
		/// Close an OWOffice Configuration file
		/// Returns true if it close the file
		/// </summary>		
		private bool CloseFile()
		{				
			//Synchronize Configuration Class with Form's data
			UpdateConfiguration();
			
			//Compare the current Configuration with a copy.. if any changes then ask for save!!
			if(!ConfigurationCopy.Compare(Configuration))
			{
				DialogResult result = MessageBox.Show("A configuração foi alterada. Pretende gravar as alterações efectuadas?", MsgboxTitle, MessageBoxButtons.YesNoCancel);
				switch (result)
				{
					case (DialogResult.Yes)://Yes I want to save and close
					{					
						SaveConfiguration();
						SetOperationMode(OperationMode.Idle);				
						return true;						
					}
					case (DialogResult.No)://No I don't want to save but close the file
					{
						SetOperationMode(OperationMode.Idle);
						return true;						
					}				
					default:// Cancel the operation
					{
						break;
					}
				}
			}
			else //close the file
			{
				SetOperationMode(OperationMode.Idle);
				return true;
			}
			
			return false;
		}


		/// <summary>
		/// Exit from application
		/// </summary>
		private bool ExitApplication()
		{
			if(ActiveOperationMode!=OperationMode.Idle)
			{				
				if(CloseFile())				
					Application.Exit();				
				else
					return false;
			}
			else
				Application.Exit();

			return true;
		}


		/// <summary>
		/// Save OWOffice Configuration file
		/// </summary>
		private void SaveFile()
		{
			
			UpdateConfiguration();
			SaveConfiguration();
		
		}


		/// <summary>
		/// Save OWOffice Configuration
		/// </summary>
		private void SaveConfiguration()
		{
			switch (ActiveOperationMode)
			{
				case OperationMode.Edit:
				{
					SaveConfigurationToFile();
					break;
				}
				case OperationMode.New:
				{
					SaveFileDialog saveFileDialog = new SaveFileDialog();
					saveFileDialog.Filter = string.Format("Ficheiro de configuração do OWOffice {0}|{1}",ApplicationVersion ,"*." + _file_ext);
					saveFileDialog.Title = "Guardar";
					saveFileDialog.ShowDialog();
					if (saveFileDialog.FileName.Length > 0)
					{
						_filePath = saveFileDialog.FileName;
						SaveConfigurationToFile();
						SetOperationMode(OperationMode.Edit);
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}

		
		/// <summary>
		/// Save OWOffice Configuration to a file
		/// </summary>
		private void SaveConfigurationToFile()
		{
			//Backup old config file
			BackupRestoreConfigurationFile(_filePath,BackupFilePath);
			//Write file with configuration	
			
			if(WriteConfigurationToFile(_filePath))
			{
				MessageBox.Show("A nova configuração foi guardada com sucesso", MsgboxTitle);
				ResetInitialConfigurationValues();
			}
			else
			{
				MessageBox.Show("Não foi possível guardar a nova configuração", MsgboxTitle);
				//Restore configuration file
				BackupRestoreConfigurationFile(BackupFilePath,_filePath);
			}
		}


		/// <summary>
		/// Show Copyright Info
		/// </summary>
		private void ShowCopyright()
		{
			Copyright copyright = new Copyright();
			copyright.ShowDialog(this);
		}


		/// <summary>
		/// Get OWOffice Configuration values to form controls
		/// </summary>
		public void GetConfigurationValues()
		{				
			//WebServerUrl
			txtWebServerUrl.Text = Configuration.WebServerUrl;
			//Templates
			//FillTemplateCfgStruct();
			GetTemplates();
						
			//Call Web Service asynchronously, and if it is Available then get Books							
			CallWebService();
			
		}

		/// <summary>
		/// Reset initial configuration values to saved values
		/// </summary>
		private void ResetInitialConfigurationValues()
		{			
			InitializeConfiguration();
		}
		

		/// <summary>
		/// Reset OWOffice Configuration
		/// </summary>
		private void ResetConfiguration()
		{
			InitializeNewConfiguration();
			ResetFields();
		}

		/// <summary>
		/// Reset form fields
		/// </summary>
		public void ResetFields()
		{			
			//WebServerUrl
			txtWebServerUrl.Text = "";			
			//Templates
			listTemplate.Items.Clear();
			//Books
			listBooks.Items.Clear();
			//DocumentTypes
			listDocumentTypes.Items.Clear();			
			//OfficeWorksFields
			if (frmOWNFields!=null)			
				frmOWNFields.Fields.Clear();
			//Mapping Fields
			owGMappFields.Clear();
			//Add/Remove Mapping
			btnAddField.Enabled = false;
			btnRemoveField.Enabled = false;

			tabControl1.SelectedIndex = 0;
			tabControl1.Enabled = false;			

			//Template check boxs
			chkDefault.Checked = false;
			chkHAccess.Checked = false;
			chkAccessRequired.Checked = false;
			chkPDF.Checked = false;
			chkDefault.Enabled = false;
			chkHAccess.Enabled = false;
			chkAccessRequired.Enabled = false;
			chkPDF.Enabled = false;

		}


		/// <summary>
		/// Set operation mode
		/// </summary>
		/// <param name="mode"></param>
		private void SetOperationMode(OperationMode mode)
		{
			ActiveOperationMode = mode;
			switch (mode)
			{
				case OperationMode.Idle:
				{
					Text = ApplicationTitle;
					menuNewFile.Enabled = true;
					menuOpenFile.Enabled = true;
					menuCloseFile.Enabled = false;
					menuSaveFile.Enabled = false;	
					menuSaveFileAs.Enabled = false;			
					txtWebServerUrl.Enabled = false;					
					ResetConfiguration();
					break;
				}
				case OperationMode.Edit:
				{
					Text = "Editar - " + ApplicationTitle;
					menuNewFile.Enabled = true;
					menuOpenFile.Enabled = false;
					menuCloseFile.Enabled = true;
					menuSaveFile.Enabled = true;	
					menuSaveFileAs.Enabled = true;				
					txtWebServerUrl.Enabled = true;					
					tabControl1.Enabled=true;																
					break;
				}
				case OperationMode.New:
				{
					Text = "Novo - " + ApplicationTitle;
					menuNewFile.Enabled = true;
					menuOpenFile.Enabled = false;
					menuCloseFile.Enabled = true;
					menuSaveFile.Enabled = true;										
					menuSaveFileAs.Enabled = true;
					txtWebServerUrl.Enabled = true;					
					tabControl1.Enabled=true;										
					break;
				}
				default:
				{
					break;
				}
			}
		}		
		

		/// <summary>
		/// Ask user for sva changes
		/// </summary>
		/// <returns></returns>
		private void ResultForAskSaveChanges()
		{			
			DialogResult result = MessageBox.Show("A configuração foi alterada. Pretende gravar as alterações efectuadas?", MsgboxTitle, MessageBoxButtons.YesNoCancel);
			switch (result)
			{
				case (DialogResult.Yes):
				{					
					SaveConfiguration();
					SetOperationMode(OperationMode.Idle);				
					break;
				}
				case (DialogResult.No):
				{
					SetOperationMode(OperationMode.Idle);
					break;
				}				
				default:
				{
					break;
				}
			}
		}
		/// <summary>
		/// Call Web Service asynchronously, and if it is Available then get Books
		/// </summary>
		private void CallWebService()
		{
			//if already running return and do nothing
			if (bCallingWebService)
				return;

			//create a web service thread			
			thrWebService = new System.Threading.Thread(new System.Threading.ThreadStart(WebServiceIsAvailable));
			thrWebService.IsBackground = true;
			thrWebService.ApartmentState = System.Threading.ApartmentState.STA;
			thrWebService.Start();
		}
	
		/// <summary>
		/// Verify if url for webservice is available=?=?
		/// </summary>
		/// <param name="url"></param>
		/// <returns></returns>
		private void WebServiceIsAvailable()
		{				
			pnProcessando.Visible = true;
			bCallingWebService = true;	
			tabControl1.SelectedIndex = 0;
			
			lblMsg.Text = "A contactar Web Service ...";			

			try
			{				
				
				WebRequest request = WebRequest.Create(txtWebServerUrl.Text + OWC.kWEBSERVICE_OWApi);
				request.Credentials = CredentialCache.DefaultCredentials;
				WebResponse response = request.GetResponse();

				if (response != null && response is HttpWebResponse && ((HttpWebResponse)response).StatusCode == HttpStatusCode.OK)
				{		
					GetBooks();										
					bIsWebServiceValid = true;
					tabControl1.SelectedIndex=1;
				}
				else
				{					
					if (thrWebService.ThreadState != System.Threading.ThreadState.AbortRequested)
						MessageBox.Show(this,"Não foi possível contactar o serviço web do OfficeWorks", MsgboxTitle);
				}				
			}
			catch(Exception ex)
			{	
				if (ex.Message.IndexOf("(401)") > -1)
					MessageBox.Show(this,"Não tem permissões para aceder ao Serviço Web!", MsgboxTitle);
				else
					if (thrWebService.ThreadState != System.Threading.ThreadState.AbortRequested)
				{
					MessageBox.Show(this, ex.Message, MsgboxTitle);
					MessageBox.Show(this,"Não foi possível contactar o serviço web do OfficeWorks", MsgboxTitle);
				}
				
					
			}
			finally
			{				
				pnProcessando.Visible = false;
				bCallingWebService = false;	
			}
		}


		private void RefreshTemplateCollection(OWGrid Grid)
		{
			//Get the Selected Item in listTemplate
			ListViewItem oItem = (ListViewItem)listTemplate.SelectedItem;
			//Get Template object of Tag Item
			TemplateCfg oTemplate = (TemplateCfg) oItem.Tag;

			//REFRESH template's collection			
			oTemplate.MappedFields.Clear();
			//Add a new Mapping to the template's collection			
			foreach( MappedField oMapp in Grid.ObjectItems)
				oTemplate.MappedFields.Add(oMapp);
				
			//set the updated template object to item list
			oItem.Tag = oTemplate;
			//Update Item List
			listTemplate.SelectedItem = oItem ;		
		}		
			

		/// <summary>
		/// Set OfficeWorks Web Service
		/// </summary>
		/// <returns></returns>
		private OWApi SetOWApi()
		{
			OWApi OWApi = new OWApi();
			OWApi.Credentials = CredentialCache.DefaultCredentials;
			OWApi.Url = txtWebServerUrl.Text + OWC.kWEBSERVICE_OWApi;
			return OWApi;
		}


		/// <summary>
		/// Get select index form a listbox
		/// </summary>
		/// <param name="oList"></param>
		/// <returns></returns>
		private int GetListSelectedIndex(ListBox oList)
		{
			return oList.SelectedIndex;
		}


		/// <summary>
		/// Get a template configuration
		/// </summary>
		/// <param name="iIdx"></param>
		/// <returns></returns>
		private TemplateCfg SetTemplateConfigAux(int iIdx)
		{
			return (TemplateCfg)((ListViewItem)listTemplate.Items[iIdx]).Tag;
		}


		/// <summary>
		/// Set values for a template configuration
		/// </summary>
		/// <param name="iIdx"></param>
		/// <param name="oConfigAux"></param>
		private void SetValuesToTemplateConfigArray(int iIdx, TemplateCfg oConfigAux)
		{					
			ListViewItem Item =	(ListViewItem) listTemplate.Items[iIdx];
			Item.Tag=oConfigAux;
			listTemplate.Items[iIdx]=Item;
		}
		

		/// <summary>
		/// Get template to fill listbox
		/// </summary>
		private void GetTemplates()
		{
			listTemplate.Items.Clear();			
			foreach (object oTemplate in Configuration.Templates)							
			{
				ListViewItem oNewItem = new ListViewItem(((TemplateCfg)oTemplate).TemplateName);
				oNewItem.Tag = oTemplate;
				listTemplate.Items.Add(oNewItem);				
			}
		}


		/// <summary>
		/// Get books to fill listbox
		/// </summary>
		private void GetBooks()
		{
			try
			{
				if (txtWebServerUrl.Text.Length > 0)
				{
					OWApi OWApi = SetOWApi();					
					stBook[] books = OWApi.GetAllBooks();
					listBooks.Items.Clear();
					listDocumentTypes.Items.Clear();					
					frmOWNFields.Fields.Clear();
					string sValueText = "";
					ListViewItem oNewItem = null;
					for (int x = 0; x < books.Length; x++)
					{
						sValueText = "" + books[x].BookAbreviation + " (" +  books[x].BookDescription + ")";
						oNewItem = new ListViewItem(sValueText);
						oNewItem.Tag = books[x];
						listBooks.Items.Add(oNewItem);
					}
				}
			}
			catch(SoapException)
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", MsgboxTitle);
			}
		}


		/// <summary>
		/// Get document types for selected book to fill listbox
		/// </summary>
		private void GetDocumentTypes()
		{
			try
			{
				if (txtWebServerUrl.Text.Length > 0)
				{
					long bookId = -1;
					if(listBooks.SelectedItems.Count > 0)
					{
						bookId=((stBook)((ListViewItem)listBooks.SelectedItem).Tag).BookID;
					}
					OWApi OWApi = SetOWApi();
					stDocumentType[] documentTypes = OWApi.GetDocumentTypesByBook(bookId);
					listDocumentTypes.Items.Clear();
					string sValueText="";					
					ListViewItem oNewItem = null;
					for (int x = 0; x < documentTypes.Length; x++)
					{
						sValueText = "" + documentTypes[x].DocumentTypeAbreviation+ " (" +  documentTypes[x].DocumentTypeDescription + ")";
						oNewItem = new ListViewItem(sValueText);
						oNewItem.Tag = documentTypes[x];
						listDocumentTypes.Items.Add(oNewItem);
					}
				}
			}
			catch(SoapException)
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", MsgboxTitle);
			}
		}


		/// <summary>
		/// Get OfficeWorks fields for selected book to fill listbox
		/// </summary>
		private void GetOfficeWorksFields()
		{
			try
			{
				if (txtWebServerUrl.Text.Length > 0)
				{
					long bookId = -1;
					if(listBooks.SelectedItems.Count > 0)
					{
						bookId=((stBook)((ListViewItem)listBooks.SelectedItem).Tag).BookID;
					}
					OWApi OWApi = SetOWApi();
					stDynamicField[] OfficeWorksFields = OWApi.GetBookFields(bookId);
					frmOWNFields.Fields.Clear();					
					ListViewItem oNewItem = null;
					for (int x = 0; x < OfficeWorksFields.Length; x++)
					{					
						oNewItem = new ListViewItem(OfficeWorksFields[x].DynamicFieldName);
						oNewItem.Tag = OfficeWorksFields[x].DynamicFieldID;
						frmOWNFields.Fields.Add(oNewItem);
					}
					frmOWNFields.Fields.Sorted = true;
				}
			}
			catch(SoapException)
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", MsgboxTitle);
			}
		}

		/// <summary>
		/// Validate if new template already exists on listbox
		/// </summary>
		/// <param name="sNewName"></param>
		/// <returns></returns>
		private bool ValidateNewTemplateName(string sNewName)
		{
			if(sNewName.Trim()=="")
			{
				MessageBox.Show("Indique o Template a adicionar à lista!", MsgboxTitle);
				return false;
			}
			else
			{
				for(int i=0;i<listTemplate.Items.Count;i++)
				{
					if(sNewName.ToUpper()==((ListViewItem)listTemplate.Items[i]).Text.ToUpper())
					{
						MessageBox.Show("Template já existente na lista!", MsgboxTitle);
						return false;
					}
				}
			}
			return true;
		}

		
		private void ResetTemplateChildObjects()
		{
			//Clear Old Childs Lists
			listBooks.ClearSelected();
			btnAddField.Enabled = false;
			listDocumentTypes.Items.Clear();
			frmOWNFields.Fields.Clear();
			owGMappFields.Clear();
			btnRemoveField.Enabled = false;
			//Disable Checks
			chkDefault.Checked = false;
			chkHAccess.Checked = false;
			chkAccessRequired.Checked = false;
			chkPDF.Checked = false;
			chkDefault.Enabled = false;
			chkHAccess.Enabled = false;		
			chkAccessRequired.Enabled = false;
			chkPDF.Enabled = false;
		}


		/// <summary>
		/// Select the book id for selected template
		/// </summary>
		private void SelectBookForTemplate()
		{
			//Reset Template Child Objects
			ResetTemplateChildObjects();

			int iIdx = GetListSelectedIndex(listTemplate);
			if(iIdx>=0)
			{
				TemplateCfg oConfigAux = SetTemplateConfigAux(iIdx);
				if(oConfigAux.BookAbreviation.Length > 0)
				{
					string BookAbreviation = oConfigAux.BookAbreviation;
					for(int i=0;i<listBooks.Items.Count;i++)
					{
						if(((stBook)((ListViewItem)listBooks.Items[i]).Tag).BookAbreviation == BookAbreviation)
						{
							listBooks.SetSelected(i,true);
							listBooks_Click(listBooks,new System.EventArgs());
							break;
						}
					}
				}
			}
		}


		private void RevalidateMappGrid()
		{
			MappedField oMap = null;			
			owGMappFields.ToolTip = "";

			for(int iX = 0; iX<owGMappFields.ObjectItems.Count; iX++)
			{				
				oMap = (MappedField)owGMappFields.ObjectItems[iX];
				oMap.ValidField = false;
				
				foreach (ListViewItem oItem in frmOWNFields.Fields.Items)
				{	
					if (oItem.Text.ToLower() == oMap.FieldName.ToLower())
					{
						//Update ID
						oMap.FieldIdentifier = Convert.ToInt32(oItem.Tag);
						oMap.ValidField = true;
						break;
					}				
				}
				//Change Row color background
				owGMappFields.MarkRow(iX,!oMap.ValidField,oMap.RequiredField);
				if (!oMap.ValidField)
					owGMappFields.ToolTip = "A lista contém campos inválidos para o livro seleccionado!";

				owGMappFields.ObjectItems[iX] = oMap;
			}
			
					
		}


		/// <summary>
		/// Select docment type id for selected template
		/// </summary>
		private void SelectDocumentType()
		{
			
			int iIdx = GetListSelectedIndex(listTemplate);
			if (iIdx>=0)
			{
				ValidateAndSelectDocumentTypes(iIdx);
			}
		}


		/// <summary>
		/// Select mappings for selected template
		/// </summary>
		private void SelectMappingsForTempalte()
		{
			owGMappFields.Clear();
			btnRemoveField.Enabled = false;

			int iIdx = GetListSelectedIndex(listTemplate);
			if(iIdx>=0)
			{
				TemplateCfg oConfigAux = SetTemplateConfigAux(iIdx);
				string sBookmarkSuffix = "";
				foreach (MappedField Mapp in oConfigAux.MappedFields)				
				{
					sBookmarkSuffix = "";
					//if the field is a Entity then add [origem] [destino] at the end of bookmark lable
					switch (Convert.ToInt64(Mapp.FieldIdentifier))
					{						
						case (long)enumFieldName.FieldNameMoreEntities:
						{
							sBookmarkSuffix = (Mapp.EntityType == enumEntityType.EntityTypeOrigin ? " [Origem]" : " [Destino]");
							break;
						}					
					}					
					//add mapping row
					owGMappFields.AddRow(new string[]{Mapp.BookmarkName + sBookmarkSuffix,Mapp.FieldName},Mapp,false);				
				}
				
			}
		}
		

		/// <summary>
		/// Validate and select document type for select if book change
		/// </summary>
		/// <param name="iIdx"></param>
		private void ValidateAndSelectDocumentTypes(int iIdx)
		{
			TemplateCfg oConfigAux = SetTemplateConfigAux(iIdx);			
			if(oConfigAux.DocumentTypeAbreviation.Length >0)
			{
				string docTypeAbreviation = oConfigAux.DocumentTypeAbreviation;
				oConfigAux.DocumentTypeAbreviation = string.Empty;
				for(int i=0;i<listDocumentTypes.Items.Count;i++)
				{
					if(((stDocumentType)((ListViewItem)listDocumentTypes.Items[i]).Tag).DocumentTypeAbreviation == docTypeAbreviation)
					{
						listDocumentTypes.SetSelected(i,true);
						oConfigAux.DocumentTypeAbreviation = docTypeAbreviation;
						break;
					}
				}
			}			
			SetValuesToTemplateConfigArray(iIdx, oConfigAux);
		}
		
		/// <summary>
		/// Synchronize Configuration Class with Form's data
		/// </summary>
		private void UpdateConfiguration()
		{						
			Configuration.WebServerUrl = txtWebServerUrl.Text;
			//try to fix string 
			Configuration.WebServerUrl = Configuration.WebServerUrl.Replace("\\","/");
			if (Configuration.WebServerUrl.Length>0 && Configuration.WebServerUrl.LastIndexOf("/")==(Configuration.WebServerUrl.Length-1))
				Configuration.WebServerUrl = Configuration.WebServerUrl.Remove(Configuration.WebServerUrl.LastIndexOf("/"),1);
			txtWebServerUrl.Text = Configuration.WebServerUrl;

			
			Configuration.Templates.Clear();
			foreach (ListViewItem Item in listTemplate.Items)
			{
				TemplateCfg Template = (TemplateCfg) Item.Tag;
				Configuration.Templates.Add(Template);			
			}		
		}		

		/// <summary>
		/// Create a backup or restore a file for owoffice configuration
		/// </summary>
		/// <returns></returns>
		private bool BackupRestoreConfigurationFile(string sFileFrom, string sFileTo)
		{
			try
			{
				// Checks permissions before proceeding if file exists
				Serializer.CheckFilePermissions(sFileTo);
				File.Copy(sFileFrom,sFileTo,true);
				return true;
			}
			catch(Exception)
			{
				return false;
			}
		}


		/// <summary>
		/// Write configuration to a file
		/// </summary>
		/// <param name="configFilePath"></param>
		private bool WriteConfigurationToFile(string configurationFilePath)
		{
			try
			{
				Serializer.Serialize(Configuration,_filePath);
				return true;
			}
			catch(Exception)
			{				
				return false;
			}
		}		

		#endregion//*****************************************************************************			

		private void menuSaveAs_Click(object sender, System.EventArgs e)
		{
			SetOperationMode(OperationMode.New);
			SaveFile();
		}

	}

}
