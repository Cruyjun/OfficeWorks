using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Runtime.InteropServices;
using System.Web.Services.Protocols;
using System.Windows.Forms;
using ADODB;
using OWMailConfigurator.OWApiWebService;
using OfficeWorks.Global;
using System.Reflection;
using stBook = OWMailConfigurator.OWApiWebService.stBook;
using stDocumentType = OWMailConfigurator.OWApiWebService.stDocumentType;

namespace OfficeWorks
{	
	/// <summary>
	/// Main Form of OWMail 2.0 Administrator user interface.
	/// </summary>
	public class MainForm : Form
	{
		private IContainer components;
	
		private MainMenu mainMenu1;
		private MenuItem menuFile;
		private MenuItem menuOpen;
		private MenuItem menuClose;
		private MenuItem menuNew;
		private MenuItem menuItem5;
		private MenuItem menuSave;
		private MenuItem menuItem7;
		private MenuItem menuExit;
		private MenuItem menuHelp;
		private MenuItem menuAbout;
		private MenuItem menuItem1;

			/// <summary>
		/// Name of Xml file storing configuration settings would 
		/// be hard-coded anyway, therefore a CONST is used.
		/// </summary>
		private const string _file = "OWMailConfiguration.xml";
		private const string _version = "";

		private const string _readConfiguration = "Lendo Configurações...";
		private const string _verifyWS = "Conectando o WebService...";
		public const string _addMailbox = "Adicionando/Removendo Mailbox...";

		/// <summary>
		/// 
		/// </summary>
		private string _fileName = _file;
		public string FileName
		{
			get
			{
				return _fileName;
			}
			set
			{
				_fileName = value;
			}
		}
		/// <summary>
		/// 
		/// </summary>
		private string _exchangeServer = string.Empty;
		public string ExchangeServer
		{
			get
			{
				return _exchangeServer;
			}
			set
			{
				_exchangeServer = value;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private ArrayList _activeDirectoryMailsList = null;
		public ArrayList ActiveDirectoryMailsList
		{
			get
			{
				return _activeDirectoryMailsList;
			}
			set
			{
				_activeDirectoryMailsList = value;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private string _activeDirectoryDomain = string.Empty;
		public string ActiveDirectoryDomain
		{
			get
			{
				return _activeDirectoryDomain;
			}
			set
			{
				_activeDirectoryDomain = value;
			}
		}
	
		/// <summary>
		/// 
		/// </summary>
		private string _filePath = Application.StartupPath + @"\" + _file;
		public string FilePath
		{
			get
			{
				return _filePath;
			}
			set
			{
				_filePath = value;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private OperationMode _activeOperationMode;
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

		private ToolTip toolTipMainForm;

	
		/// <summary>
		/// 
		/// </summary>
		private OWMailConfiguration configuration = null;
		private TabControl tabControl1;
		private TabPage tpGlobal;
		private TabPage tpdetail;
		private TabPage tpConfig;
		private TextBox txtWebServiceUrl;
		private TextBox txtTempDirectoryPath;
		private Label lblTempDirectoryPath;
		private Label label1;
		private Label label2;
		private Label label5;
		private Label label4;
		private Label label3;
		private CheckBox chkExtractAttachments;
		private ListBox listUser;
		private ListBox listBook;
		private Button btnDeleteMailbox;
		private Button btnAddMailbox;
		private ListBox listMailbox;
		private ListBox listDocumentType;
		private CheckBox chkShowRegistrationMessages;
		private Label label6;
		private Label label7;
		private Label label8;
		private Label label9;
		private Label label11;
		private Label label12;
		private Button btnFindDirTemp;
		private Label label13;
		private ListBox lstMailBoxConfig;
		private Button btnDefault;
		private ComboBox cmbTo;
		private ComboBox cmbCc;
		private ComboBox cmbSubject;
		private ComboBox cmbBody;
		private ComboBox cmbReceive;
		private ComboBox cmbFrom;
		private ImageList imageList1;
		private MenuExtender.MenuExtender menuExtender1;
		private System.Windows.Forms.Label label10;
		private System.Windows.Forms.Label label14;
		private System.Windows.Forms.TextBox txtExchange;
	
		public OWMailConfiguration Configuration
		{
			get
			{
				return configuration;
			}
			set
			{
				configuration = value;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private ArrayList _mailboxes = new ArrayList();
		public ArrayList Mailboxes
		{
			get
			{
				return _mailboxes;
			}
			set
			{
				_mailboxes = value;
			}
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public MainForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();
			//
			// TODO: Add any constructor code after InitializeComponent call
			//
			
		}

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
					if (Assembly.GetExecutingAssembly().Location.
						Replace("/", "\\") == current.MainModule.FileName) 
 
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

		#region Windows Form Designer generated code
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
			this.menuNew = new System.Windows.Forms.MenuItem();
			this.menuOpen = new System.Windows.Forms.MenuItem();
			this.menuClose = new System.Windows.Forms.MenuItem();
			this.menuItem5 = new System.Windows.Forms.MenuItem();
			this.menuSave = new System.Windows.Forms.MenuItem();
			this.menuItem7 = new System.Windows.Forms.MenuItem();
			this.menuExit = new System.Windows.Forms.MenuItem();
			this.menuHelp = new System.Windows.Forms.MenuItem();
			this.menuAbout = new System.Windows.Forms.MenuItem();
			this.menuItem1 = new System.Windows.Forms.MenuItem();
			this.toolTipMainForm = new System.Windows.Forms.ToolTip(this.components);
			this.txtWebServiceUrl = new System.Windows.Forms.TextBox();
			this.txtTempDirectoryPath = new System.Windows.Forms.TextBox();
			this.chkExtractAttachments = new System.Windows.Forms.CheckBox();
			this.listUser = new System.Windows.Forms.ListBox();
			this.listBook = new System.Windows.Forms.ListBox();
			this.btnDeleteMailbox = new System.Windows.Forms.Button();
			this.btnAddMailbox = new System.Windows.Forms.Button();
			this.listDocumentType = new System.Windows.Forms.ListBox();
			this.chkShowRegistrationMessages = new System.Windows.Forms.CheckBox();
			this.listMailbox = new System.Windows.Forms.ListBox();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tpGlobal = new System.Windows.Forms.TabPage();
			this.label10 = new System.Windows.Forms.Label();
			this.btnFindDirTemp = new System.Windows.Forms.Button();
			this.lblTempDirectoryPath = new System.Windows.Forms.Label();
			this.label1 = new System.Windows.Forms.Label();
			this.tpdetail = new System.Windows.Forms.TabPage();
			this.label2 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.tpConfig = new System.Windows.Forms.TabPage();
			this.cmbReceive = new System.Windows.Forms.ComboBox();
			this.cmbBody = new System.Windows.Forms.ComboBox();
			this.cmbSubject = new System.Windows.Forms.ComboBox();
			this.cmbCc = new System.Windows.Forms.ComboBox();
			this.cmbTo = new System.Windows.Forms.ComboBox();
			this.cmbFrom = new System.Windows.Forms.ComboBox();
			this.btnDefault = new System.Windows.Forms.Button();
			this.lstMailBoxConfig = new System.Windows.Forms.ListBox();
			this.label13 = new System.Windows.Forms.Label();
			this.label12 = new System.Windows.Forms.Label();
			this.label11 = new System.Windows.Forms.Label();
			this.label9 = new System.Windows.Forms.Label();
			this.label8 = new System.Windows.Forms.Label();
			this.label7 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.imageList1 = new System.Windows.Forms.ImageList(this.components);
			this.menuExtender1 = new MenuExtender.MenuExtender(this.components);
			this.label14 = new System.Windows.Forms.Label();
			this.txtExchange = new System.Windows.Forms.TextBox();
			this.tabControl1.SuspendLayout();
			this.tpGlobal.SuspendLayout();
			this.tpdetail.SuspendLayout();
			this.tpConfig.SuspendLayout();
			this.SuspendLayout();
			// 
			// mainMenu1
			// 
			this.mainMenu1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					  this.menuFile,
																					  this.menuHelp,
																					  this.menuItem1});
			this.mainMenu1.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("mainMenu1.RightToLeft")));
			// 
			// menuFile
			// 
			this.menuFile.Enabled = ((bool)(resources.GetObject("menuFile.Enabled")));
			this.menuFile.Index = 0;
			this.menuFile.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
																					 this.menuNew,
																					 this.menuOpen,
																					 this.menuClose,
																					 this.menuItem5,
																					 this.menuSave,
																					 this.menuItem7,
																					 this.menuExit});
			this.menuFile.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuFile.Shortcut")));
			this.menuFile.ShowShortcut = ((bool)(resources.GetObject("menuFile.ShowShortcut")));
			this.menuFile.Text = resources.GetString("menuFile.Text");
			this.menuFile.Visible = ((bool)(resources.GetObject("menuFile.Visible")));
			// 
			// menuNew
			// 
			this.menuNew.Enabled = ((bool)(resources.GetObject("menuNew.Enabled")));
			this.menuExtender1.SetExtEnable(this.menuNew, true);
			this.menuExtender1.SetImageIndex(this.menuNew, 6);
			this.menuNew.Index = 0;
			this.menuNew.OwnerDraw = true;
			this.menuNew.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuNew.Shortcut")));
			this.menuNew.ShowShortcut = ((bool)(resources.GetObject("menuNew.ShowShortcut")));
			this.menuNew.Text = resources.GetString("menuNew.Text");
			this.menuNew.Visible = ((bool)(resources.GetObject("menuNew.Visible")));
			this.menuNew.Click += new System.EventHandler(this.menuNew_Click);
			// 
			// menuOpen
			// 
			this.menuOpen.Enabled = ((bool)(resources.GetObject("menuOpen.Enabled")));
			this.menuExtender1.SetExtEnable(this.menuOpen, true);
			this.menuExtender1.SetImageIndex(this.menuOpen, 4);
			this.menuOpen.Index = 1;
			this.menuOpen.OwnerDraw = true;
			this.menuOpen.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuOpen.Shortcut")));
			this.menuOpen.ShowShortcut = ((bool)(resources.GetObject("menuOpen.ShowShortcut")));
			this.menuOpen.Text = resources.GetString("menuOpen.Text");
			this.menuOpen.Visible = ((bool)(resources.GetObject("menuOpen.Visible")));
			this.menuOpen.Click += new System.EventHandler(this.menuOpen_Click);
			// 
			// menuClose
			// 
			this.menuClose.Enabled = ((bool)(resources.GetObject("menuClose.Enabled")));
			this.menuExtender1.SetExtEnable(this.menuClose, true);
			this.menuExtender1.SetImageIndex(this.menuClose, 3);
			this.menuClose.Index = 2;
			this.menuClose.OwnerDraw = true;
			this.menuClose.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuClose.Shortcut")));
			this.menuClose.ShowShortcut = ((bool)(resources.GetObject("menuClose.ShowShortcut")));
			this.menuClose.Text = resources.GetString("menuClose.Text");
			this.menuClose.Visible = ((bool)(resources.GetObject("menuClose.Visible")));
			this.menuClose.Click += new System.EventHandler(this.menuClose_Click);
			// 
			// menuItem5
			// 
			this.menuItem5.Enabled = ((bool)(resources.GetObject("menuItem5.Enabled")));
			this.menuExtender1.SetImageIndex(this.menuItem5, -1);
			this.menuItem5.Index = 3;
			this.menuItem5.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuItem5.Shortcut")));
			this.menuItem5.ShowShortcut = ((bool)(resources.GetObject("menuItem5.ShowShortcut")));
			this.menuItem5.Text = resources.GetString("menuItem5.Text");
			this.menuItem5.Visible = ((bool)(resources.GetObject("menuItem5.Visible")));
			// 
			// menuSave
			// 
			this.menuSave.Enabled = ((bool)(resources.GetObject("menuSave.Enabled")));
			this.menuExtender1.SetExtEnable(this.menuSave, true);
			this.menuExtender1.SetImageIndex(this.menuSave, 5);
			this.menuSave.Index = 4;
			this.menuSave.OwnerDraw = true;
			this.menuSave.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuSave.Shortcut")));
			this.menuSave.ShowShortcut = ((bool)(resources.GetObject("menuSave.ShowShortcut")));
			this.menuSave.Text = resources.GetString("menuSave.Text");
			this.menuSave.Visible = ((bool)(resources.GetObject("menuSave.Visible")));
			this.menuSave.Click += new System.EventHandler(this.menuSave_Click);
			// 
			// menuItem7
			// 
			this.menuItem7.Enabled = ((bool)(resources.GetObject("menuItem7.Enabled")));
			this.menuExtender1.SetImageIndex(this.menuItem7, -1);
			this.menuItem7.Index = 5;
			this.menuItem7.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuItem7.Shortcut")));
			this.menuItem7.ShowShortcut = ((bool)(resources.GetObject("menuItem7.ShowShortcut")));
			this.menuItem7.Text = resources.GetString("menuItem7.Text");
			this.menuItem7.Visible = ((bool)(resources.GetObject("menuItem7.Visible")));
			// 
			// menuExit
			// 
			this.menuExit.Enabled = ((bool)(resources.GetObject("menuExit.Enabled")));
			this.menuExtender1.SetExtEnable(this.menuExit, true);
			this.menuExtender1.SetImageIndex(this.menuExit, 1);
			this.menuExit.Index = 6;
			this.menuExit.OwnerDraw = true;
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
			this.menuExtender1.SetExtEnable(this.menuAbout, true);
			this.menuExtender1.SetImageIndex(this.menuAbout, 2);
			this.menuAbout.Index = 0;
			this.menuAbout.OwnerDraw = true;
			this.menuAbout.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuAbout.Shortcut")));
			this.menuAbout.ShowShortcut = ((bool)(resources.GetObject("menuAbout.ShowShortcut")));
			this.menuAbout.Text = resources.GetString("menuAbout.Text");
			this.menuAbout.Visible = ((bool)(resources.GetObject("menuAbout.Visible")));
			this.menuAbout.Click += new System.EventHandler(this.menuAbout_Click);
			// 
			// menuItem1
			// 
			this.menuItem1.Enabled = ((bool)(resources.GetObject("menuItem1.Enabled")));
			this.menuItem1.Index = 2;
			this.menuItem1.Shortcut = ((System.Windows.Forms.Shortcut)(resources.GetObject("menuItem1.Shortcut")));
			this.menuItem1.ShowShortcut = ((bool)(resources.GetObject("menuItem1.ShowShortcut")));
			this.menuItem1.Text = resources.GetString("menuItem1.Text");
			this.menuItem1.Visible = ((bool)(resources.GetObject("menuItem1.Visible")));
			// 
			// txtWebServiceUrl
			// 
			this.txtWebServiceUrl.AccessibleDescription = resources.GetString("txtWebServiceUrl.AccessibleDescription");
			this.txtWebServiceUrl.AccessibleName = resources.GetString("txtWebServiceUrl.AccessibleName");
			this.txtWebServiceUrl.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("txtWebServiceUrl.Anchor")));
			this.txtWebServiceUrl.AutoSize = ((bool)(resources.GetObject("txtWebServiceUrl.AutoSize")));
			this.txtWebServiceUrl.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("txtWebServiceUrl.BackgroundImage")));
			this.txtWebServiceUrl.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("txtWebServiceUrl.Dock")));
			this.txtWebServiceUrl.Enabled = ((bool)(resources.GetObject("txtWebServiceUrl.Enabled")));
			this.txtWebServiceUrl.Font = ((System.Drawing.Font)(resources.GetObject("txtWebServiceUrl.Font")));
			this.txtWebServiceUrl.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("txtWebServiceUrl.ImeMode")));
			this.txtWebServiceUrl.Location = ((System.Drawing.Point)(resources.GetObject("txtWebServiceUrl.Location")));
			this.txtWebServiceUrl.MaxLength = ((int)(resources.GetObject("txtWebServiceUrl.MaxLength")));
			this.txtWebServiceUrl.Multiline = ((bool)(resources.GetObject("txtWebServiceUrl.Multiline")));
			this.txtWebServiceUrl.Name = "txtWebServiceUrl";
			this.txtWebServiceUrl.PasswordChar = ((char)(resources.GetObject("txtWebServiceUrl.PasswordChar")));
			this.txtWebServiceUrl.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("txtWebServiceUrl.RightToLeft")));
			this.txtWebServiceUrl.ScrollBars = ((System.Windows.Forms.ScrollBars)(resources.GetObject("txtWebServiceUrl.ScrollBars")));
			this.txtWebServiceUrl.Size = ((System.Drawing.Size)(resources.GetObject("txtWebServiceUrl.Size")));
			this.txtWebServiceUrl.TabIndex = ((int)(resources.GetObject("txtWebServiceUrl.TabIndex")));
			this.txtWebServiceUrl.Text = resources.GetString("txtWebServiceUrl.Text");
			this.txtWebServiceUrl.TextAlign = ((System.Windows.Forms.HorizontalAlignment)(resources.GetObject("txtWebServiceUrl.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.txtWebServiceUrl, resources.GetString("txtWebServiceUrl.ToolTip"));
			this.txtWebServiceUrl.Visible = ((bool)(resources.GetObject("txtWebServiceUrl.Visible")));
			this.txtWebServiceUrl.WordWrap = ((bool)(resources.GetObject("txtWebServiceUrl.WordWrap")));
			this.txtWebServiceUrl.Validating += new System.ComponentModel.CancelEventHandler(this.txtWebServiceUrl_Validating);
			// 
			// txtTempDirectoryPath
			// 
			this.txtTempDirectoryPath.AccessibleDescription = resources.GetString("txtTempDirectoryPath.AccessibleDescription");
			this.txtTempDirectoryPath.AccessibleName = resources.GetString("txtTempDirectoryPath.AccessibleName");
			this.txtTempDirectoryPath.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("txtTempDirectoryPath.Anchor")));
			this.txtTempDirectoryPath.AutoSize = ((bool)(resources.GetObject("txtTempDirectoryPath.AutoSize")));
			this.txtTempDirectoryPath.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("txtTempDirectoryPath.BackgroundImage")));
			this.txtTempDirectoryPath.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("txtTempDirectoryPath.Dock")));
			this.txtTempDirectoryPath.Enabled = ((bool)(resources.GetObject("txtTempDirectoryPath.Enabled")));
			this.txtTempDirectoryPath.Font = ((System.Drawing.Font)(resources.GetObject("txtTempDirectoryPath.Font")));
			this.txtTempDirectoryPath.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("txtTempDirectoryPath.ImeMode")));
			this.txtTempDirectoryPath.Location = ((System.Drawing.Point)(resources.GetObject("txtTempDirectoryPath.Location")));
			this.txtTempDirectoryPath.MaxLength = ((int)(resources.GetObject("txtTempDirectoryPath.MaxLength")));
			this.txtTempDirectoryPath.Multiline = ((bool)(resources.GetObject("txtTempDirectoryPath.Multiline")));
			this.txtTempDirectoryPath.Name = "txtTempDirectoryPath";
			this.txtTempDirectoryPath.PasswordChar = ((char)(resources.GetObject("txtTempDirectoryPath.PasswordChar")));
			this.txtTempDirectoryPath.ReadOnly = true;
			this.txtTempDirectoryPath.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("txtTempDirectoryPath.RightToLeft")));
			this.txtTempDirectoryPath.ScrollBars = ((System.Windows.Forms.ScrollBars)(resources.GetObject("txtTempDirectoryPath.ScrollBars")));
			this.txtTempDirectoryPath.Size = ((System.Drawing.Size)(resources.GetObject("txtTempDirectoryPath.Size")));
			this.txtTempDirectoryPath.TabIndex = ((int)(resources.GetObject("txtTempDirectoryPath.TabIndex")));
			this.txtTempDirectoryPath.Text = resources.GetString("txtTempDirectoryPath.Text");
			this.txtTempDirectoryPath.TextAlign = ((System.Windows.Forms.HorizontalAlignment)(resources.GetObject("txtTempDirectoryPath.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.txtTempDirectoryPath, resources.GetString("txtTempDirectoryPath.ToolTip"));
			this.txtTempDirectoryPath.Visible = ((bool)(resources.GetObject("txtTempDirectoryPath.Visible")));
			this.txtTempDirectoryPath.WordWrap = ((bool)(resources.GetObject("txtTempDirectoryPath.WordWrap")));
			// 
			// chkExtractAttachments
			// 
			this.chkExtractAttachments.AccessibleDescription = resources.GetString("chkExtractAttachments.AccessibleDescription");
			this.chkExtractAttachments.AccessibleName = resources.GetString("chkExtractAttachments.AccessibleName");
			this.chkExtractAttachments.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("chkExtractAttachments.Anchor")));
			this.chkExtractAttachments.Appearance = ((System.Windows.Forms.Appearance)(resources.GetObject("chkExtractAttachments.Appearance")));
			this.chkExtractAttachments.BackColor = System.Drawing.Color.Transparent;
			this.chkExtractAttachments.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("chkExtractAttachments.BackgroundImage")));
			this.chkExtractAttachments.CheckAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkExtractAttachments.CheckAlign")));
			this.chkExtractAttachments.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("chkExtractAttachments.Dock")));
			this.chkExtractAttachments.Enabled = ((bool)(resources.GetObject("chkExtractAttachments.Enabled")));
			this.chkExtractAttachments.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("chkExtractAttachments.FlatStyle")));
			this.chkExtractAttachments.Font = ((System.Drawing.Font)(resources.GetObject("chkExtractAttachments.Font")));
			this.chkExtractAttachments.Image = ((System.Drawing.Image)(resources.GetObject("chkExtractAttachments.Image")));
			this.chkExtractAttachments.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkExtractAttachments.ImageAlign")));
			this.chkExtractAttachments.ImageIndex = ((int)(resources.GetObject("chkExtractAttachments.ImageIndex")));
			this.chkExtractAttachments.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("chkExtractAttachments.ImeMode")));
			this.chkExtractAttachments.Location = ((System.Drawing.Point)(resources.GetObject("chkExtractAttachments.Location")));
			this.chkExtractAttachments.Name = "chkExtractAttachments";
			this.chkExtractAttachments.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("chkExtractAttachments.RightToLeft")));
			this.chkExtractAttachments.Size = ((System.Drawing.Size)(resources.GetObject("chkExtractAttachments.Size")));
			this.chkExtractAttachments.TabIndex = ((int)(resources.GetObject("chkExtractAttachments.TabIndex")));
			this.chkExtractAttachments.Text = resources.GetString("chkExtractAttachments.Text");
			this.chkExtractAttachments.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkExtractAttachments.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.chkExtractAttachments, resources.GetString("chkExtractAttachments.ToolTip"));
			this.chkExtractAttachments.Visible = ((bool)(resources.GetObject("chkExtractAttachments.Visible")));
			// 
			// listUser
			// 
			this.listUser.AccessibleDescription = resources.GetString("listUser.AccessibleDescription");
			this.listUser.AccessibleName = resources.GetString("listUser.AccessibleName");
			this.listUser.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listUser.Anchor")));
			this.listUser.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listUser.BackgroundImage")));
			this.listUser.ColumnWidth = ((int)(resources.GetObject("listUser.ColumnWidth")));
			this.listUser.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listUser.Dock")));
			this.listUser.Enabled = ((bool)(resources.GetObject("listUser.Enabled")));
			this.listUser.Font = ((System.Drawing.Font)(resources.GetObject("listUser.Font")));
			this.listUser.HorizontalExtent = ((int)(resources.GetObject("listUser.HorizontalExtent")));
			this.listUser.HorizontalScrollbar = ((bool)(resources.GetObject("listUser.HorizontalScrollbar")));
			this.listUser.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listUser.ImeMode")));
			this.listUser.IntegralHeight = ((bool)(resources.GetObject("listUser.IntegralHeight")));
			this.listUser.ItemHeight = ((int)(resources.GetObject("listUser.ItemHeight")));
			this.listUser.Location = ((System.Drawing.Point)(resources.GetObject("listUser.Location")));
			this.listUser.Name = "listUser";
			this.listUser.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listUser.RightToLeft")));
			this.listUser.ScrollAlwaysVisible = ((bool)(resources.GetObject("listUser.ScrollAlwaysVisible")));
			this.listUser.Size = ((System.Drawing.Size)(resources.GetObject("listUser.Size")));
			this.listUser.TabIndex = ((int)(resources.GetObject("listUser.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listUser, resources.GetString("listUser.ToolTip"));
			this.listUser.Visible = ((bool)(resources.GetObject("listUser.Visible")));
			this.listUser.SelectedIndexChanged += new System.EventHandler(this.listUser_SelectedIndexChanged);
			// 
			// listBook
			// 
			this.listBook.AccessibleDescription = resources.GetString("listBook.AccessibleDescription");
			this.listBook.AccessibleName = resources.GetString("listBook.AccessibleName");
			this.listBook.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listBook.Anchor")));
			this.listBook.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listBook.BackgroundImage")));
			this.listBook.ColumnWidth = ((int)(resources.GetObject("listBook.ColumnWidth")));
			this.listBook.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listBook.Dock")));
			this.listBook.Enabled = ((bool)(resources.GetObject("listBook.Enabled")));
			this.listBook.Font = ((System.Drawing.Font)(resources.GetObject("listBook.Font")));
			this.listBook.HorizontalExtent = ((int)(resources.GetObject("listBook.HorizontalExtent")));
			this.listBook.HorizontalScrollbar = ((bool)(resources.GetObject("listBook.HorizontalScrollbar")));
			this.listBook.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listBook.ImeMode")));
			this.listBook.IntegralHeight = ((bool)(resources.GetObject("listBook.IntegralHeight")));
			this.listBook.ItemHeight = ((int)(resources.GetObject("listBook.ItemHeight")));
			this.listBook.Location = ((System.Drawing.Point)(resources.GetObject("listBook.Location")));
			this.listBook.Name = "listBook";
			this.listBook.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listBook.RightToLeft")));
			this.listBook.ScrollAlwaysVisible = ((bool)(resources.GetObject("listBook.ScrollAlwaysVisible")));
			this.listBook.Size = ((System.Drawing.Size)(resources.GetObject("listBook.Size")));
			this.listBook.TabIndex = ((int)(resources.GetObject("listBook.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listBook, resources.GetString("listBook.ToolTip"));
			this.listBook.Visible = ((bool)(resources.GetObject("listBook.Visible")));
			this.listBook.SelectedIndexChanged += new System.EventHandler(this.listBook_SelectedIndexChanged);
			// 
			// btnDeleteMailbox
			// 
			this.btnDeleteMailbox.AccessibleDescription = resources.GetString("btnDeleteMailbox.AccessibleDescription");
			this.btnDeleteMailbox.AccessibleName = resources.GetString("btnDeleteMailbox.AccessibleName");
			this.btnDeleteMailbox.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnDeleteMailbox.Anchor")));
			this.btnDeleteMailbox.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnDeleteMailbox.BackgroundImage")));
			this.btnDeleteMailbox.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnDeleteMailbox.Dock")));
			this.btnDeleteMailbox.Enabled = ((bool)(resources.GetObject("btnDeleteMailbox.Enabled")));
			this.btnDeleteMailbox.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnDeleteMailbox.FlatStyle")));
			this.btnDeleteMailbox.Font = ((System.Drawing.Font)(resources.GetObject("btnDeleteMailbox.Font")));
			this.btnDeleteMailbox.Image = ((System.Drawing.Image)(resources.GetObject("btnDeleteMailbox.Image")));
			this.btnDeleteMailbox.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnDeleteMailbox.ImageAlign")));
			this.btnDeleteMailbox.ImageIndex = ((int)(resources.GetObject("btnDeleteMailbox.ImageIndex")));
			this.btnDeleteMailbox.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnDeleteMailbox.ImeMode")));
			this.btnDeleteMailbox.Location = ((System.Drawing.Point)(resources.GetObject("btnDeleteMailbox.Location")));
			this.btnDeleteMailbox.Name = "btnDeleteMailbox";
			this.btnDeleteMailbox.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnDeleteMailbox.RightToLeft")));
			this.btnDeleteMailbox.Size = ((System.Drawing.Size)(resources.GetObject("btnDeleteMailbox.Size")));
			this.btnDeleteMailbox.TabIndex = ((int)(resources.GetObject("btnDeleteMailbox.TabIndex")));
			this.btnDeleteMailbox.Text = resources.GetString("btnDeleteMailbox.Text");
			this.btnDeleteMailbox.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnDeleteMailbox.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnDeleteMailbox, resources.GetString("btnDeleteMailbox.ToolTip"));
			this.btnDeleteMailbox.Visible = ((bool)(resources.GetObject("btnDeleteMailbox.Visible")));
			this.btnDeleteMailbox.Click += new System.EventHandler(this.btnDeleteMailbox_Click);
			// 
			// btnAddMailbox
			// 
			this.btnAddMailbox.AccessibleDescription = resources.GetString("btnAddMailbox.AccessibleDescription");
			this.btnAddMailbox.AccessibleName = resources.GetString("btnAddMailbox.AccessibleName");
			this.btnAddMailbox.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnAddMailbox.Anchor")));
			this.btnAddMailbox.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnAddMailbox.BackgroundImage")));
			this.btnAddMailbox.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnAddMailbox.Dock")));
			this.btnAddMailbox.Enabled = ((bool)(resources.GetObject("btnAddMailbox.Enabled")));
			this.btnAddMailbox.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnAddMailbox.FlatStyle")));
			this.btnAddMailbox.Font = ((System.Drawing.Font)(resources.GetObject("btnAddMailbox.Font")));
			this.btnAddMailbox.Image = ((System.Drawing.Image)(resources.GetObject("btnAddMailbox.Image")));
			this.btnAddMailbox.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnAddMailbox.ImageAlign")));
			this.btnAddMailbox.ImageIndex = ((int)(resources.GetObject("btnAddMailbox.ImageIndex")));
			this.btnAddMailbox.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnAddMailbox.ImeMode")));
			this.btnAddMailbox.Location = ((System.Drawing.Point)(resources.GetObject("btnAddMailbox.Location")));
			this.btnAddMailbox.Name = "btnAddMailbox";
			this.btnAddMailbox.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnAddMailbox.RightToLeft")));
			this.btnAddMailbox.Size = ((System.Drawing.Size)(resources.GetObject("btnAddMailbox.Size")));
			this.btnAddMailbox.TabIndex = ((int)(resources.GetObject("btnAddMailbox.TabIndex")));
			this.btnAddMailbox.Text = resources.GetString("btnAddMailbox.Text");
			this.btnAddMailbox.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnAddMailbox.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnAddMailbox, resources.GetString("btnAddMailbox.ToolTip"));
			this.btnAddMailbox.Visible = ((bool)(resources.GetObject("btnAddMailbox.Visible")));
			this.btnAddMailbox.Click += new System.EventHandler(this.btnAddMailbox_Click);
			// 
			// listDocumentType
			// 
			this.listDocumentType.AccessibleDescription = resources.GetString("listDocumentType.AccessibleDescription");
			this.listDocumentType.AccessibleName = resources.GetString("listDocumentType.AccessibleName");
			this.listDocumentType.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listDocumentType.Anchor")));
			this.listDocumentType.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listDocumentType.BackgroundImage")));
			this.listDocumentType.ColumnWidth = ((int)(resources.GetObject("listDocumentType.ColumnWidth")));
			this.listDocumentType.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listDocumentType.Dock")));
			this.listDocumentType.Enabled = ((bool)(resources.GetObject("listDocumentType.Enabled")));
			this.listDocumentType.Font = ((System.Drawing.Font)(resources.GetObject("listDocumentType.Font")));
			this.listDocumentType.HorizontalExtent = ((int)(resources.GetObject("listDocumentType.HorizontalExtent")));
			this.listDocumentType.HorizontalScrollbar = ((bool)(resources.GetObject("listDocumentType.HorizontalScrollbar")));
			this.listDocumentType.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listDocumentType.ImeMode")));
			this.listDocumentType.IntegralHeight = ((bool)(resources.GetObject("listDocumentType.IntegralHeight")));
			this.listDocumentType.ItemHeight = ((int)(resources.GetObject("listDocumentType.ItemHeight")));
			this.listDocumentType.Location = ((System.Drawing.Point)(resources.GetObject("listDocumentType.Location")));
			this.listDocumentType.Name = "listDocumentType";
			this.listDocumentType.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listDocumentType.RightToLeft")));
			this.listDocumentType.ScrollAlwaysVisible = ((bool)(resources.GetObject("listDocumentType.ScrollAlwaysVisible")));
			this.listDocumentType.Size = ((System.Drawing.Size)(resources.GetObject("listDocumentType.Size")));
			this.listDocumentType.TabIndex = ((int)(resources.GetObject("listDocumentType.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listDocumentType, resources.GetString("listDocumentType.ToolTip"));
			this.listDocumentType.Visible = ((bool)(resources.GetObject("listDocumentType.Visible")));
			this.listDocumentType.SelectedIndexChanged += new System.EventHandler(this.listDocumentType_SelectedIndexChanged);
			// 
			// chkShowRegistrationMessages
			// 
			this.chkShowRegistrationMessages.AccessibleDescription = resources.GetString("chkShowRegistrationMessages.AccessibleDescription");
			this.chkShowRegistrationMessages.AccessibleName = resources.GetString("chkShowRegistrationMessages.AccessibleName");
			this.chkShowRegistrationMessages.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("chkShowRegistrationMessages.Anchor")));
			this.chkShowRegistrationMessages.Appearance = ((System.Windows.Forms.Appearance)(resources.GetObject("chkShowRegistrationMessages.Appearance")));
			this.chkShowRegistrationMessages.BackColor = System.Drawing.Color.Transparent;
			this.chkShowRegistrationMessages.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("chkShowRegistrationMessages.BackgroundImage")));
			this.chkShowRegistrationMessages.CheckAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkShowRegistrationMessages.CheckAlign")));
			this.chkShowRegistrationMessages.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("chkShowRegistrationMessages.Dock")));
			this.chkShowRegistrationMessages.Enabled = ((bool)(resources.GetObject("chkShowRegistrationMessages.Enabled")));
			this.chkShowRegistrationMessages.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("chkShowRegistrationMessages.FlatStyle")));
			this.chkShowRegistrationMessages.Font = ((System.Drawing.Font)(resources.GetObject("chkShowRegistrationMessages.Font")));
			this.chkShowRegistrationMessages.Image = ((System.Drawing.Image)(resources.GetObject("chkShowRegistrationMessages.Image")));
			this.chkShowRegistrationMessages.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkShowRegistrationMessages.ImageAlign")));
			this.chkShowRegistrationMessages.ImageIndex = ((int)(resources.GetObject("chkShowRegistrationMessages.ImageIndex")));
			this.chkShowRegistrationMessages.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("chkShowRegistrationMessages.ImeMode")));
			this.chkShowRegistrationMessages.Location = ((System.Drawing.Point)(resources.GetObject("chkShowRegistrationMessages.Location")));
			this.chkShowRegistrationMessages.Name = "chkShowRegistrationMessages";
			this.chkShowRegistrationMessages.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("chkShowRegistrationMessages.RightToLeft")));
			this.chkShowRegistrationMessages.Size = ((System.Drawing.Size)(resources.GetObject("chkShowRegistrationMessages.Size")));
			this.chkShowRegistrationMessages.TabIndex = ((int)(resources.GetObject("chkShowRegistrationMessages.TabIndex")));
			this.chkShowRegistrationMessages.Text = resources.GetString("chkShowRegistrationMessages.Text");
			this.chkShowRegistrationMessages.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("chkShowRegistrationMessages.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.chkShowRegistrationMessages, resources.GetString("chkShowRegistrationMessages.ToolTip"));
			this.chkShowRegistrationMessages.Visible = ((bool)(resources.GetObject("chkShowRegistrationMessages.Visible")));
			// 
			// listMailbox
			// 
			this.listMailbox.AccessibleDescription = resources.GetString("listMailbox.AccessibleDescription");
			this.listMailbox.AccessibleName = resources.GetString("listMailbox.AccessibleName");
			this.listMailbox.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("listMailbox.Anchor")));
			this.listMailbox.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("listMailbox.BackgroundImage")));
			this.listMailbox.ColumnWidth = ((int)(resources.GetObject("listMailbox.ColumnWidth")));
			this.listMailbox.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("listMailbox.Dock")));
			this.listMailbox.Enabled = ((bool)(resources.GetObject("listMailbox.Enabled")));
			this.listMailbox.Font = ((System.Drawing.Font)(resources.GetObject("listMailbox.Font")));
			this.listMailbox.HorizontalExtent = ((int)(resources.GetObject("listMailbox.HorizontalExtent")));
			this.listMailbox.HorizontalScrollbar = ((bool)(resources.GetObject("listMailbox.HorizontalScrollbar")));
			this.listMailbox.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("listMailbox.ImeMode")));
			this.listMailbox.IntegralHeight = ((bool)(resources.GetObject("listMailbox.IntegralHeight")));
			this.listMailbox.ItemHeight = ((int)(resources.GetObject("listMailbox.ItemHeight")));
			this.listMailbox.Location = ((System.Drawing.Point)(resources.GetObject("listMailbox.Location")));
			this.listMailbox.Name = "listMailbox";
			this.listMailbox.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("listMailbox.RightToLeft")));
			this.listMailbox.ScrollAlwaysVisible = ((bool)(resources.GetObject("listMailbox.ScrollAlwaysVisible")));
			this.listMailbox.Size = ((System.Drawing.Size)(resources.GetObject("listMailbox.Size")));
			this.listMailbox.TabIndex = ((int)(resources.GetObject("listMailbox.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.listMailbox, resources.GetString("listMailbox.ToolTip"));
			this.listMailbox.Visible = ((bool)(resources.GetObject("listMailbox.Visible")));
			this.listMailbox.SelectedIndexChanged += new System.EventHandler(this.listMailbox_SelectedIndexChanged);
			// 
			// tabControl1
			// 
			this.tabControl1.AccessibleDescription = resources.GetString("tabControl1.AccessibleDescription");
			this.tabControl1.AccessibleName = resources.GetString("tabControl1.AccessibleName");
			this.tabControl1.Alignment = ((System.Windows.Forms.TabAlignment)(resources.GetObject("tabControl1.Alignment")));
			this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tabControl1.Anchor")));
			this.tabControl1.Appearance = ((System.Windows.Forms.TabAppearance)(resources.GetObject("tabControl1.Appearance")));
			this.tabControl1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tabControl1.BackgroundImage")));
			this.tabControl1.Controls.Add(this.tpGlobal);
			this.tabControl1.Controls.Add(this.tpdetail);
			this.tabControl1.Controls.Add(this.tpConfig);
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
			// 
			// tpGlobal
			// 
			this.tpGlobal.AccessibleDescription = resources.GetString("tpGlobal.AccessibleDescription");
			this.tpGlobal.AccessibleName = resources.GetString("tpGlobal.AccessibleName");
			this.tpGlobal.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tpGlobal.Anchor")));
			this.tpGlobal.AutoScroll = ((bool)(resources.GetObject("tpGlobal.AutoScroll")));
			this.tpGlobal.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("tpGlobal.AutoScrollMargin")));
			this.tpGlobal.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("tpGlobal.AutoScrollMinSize")));
			this.tpGlobal.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tpGlobal.BackgroundImage")));
			this.tpGlobal.Controls.Add(this.txtExchange);
			this.tpGlobal.Controls.Add(this.label14);
			this.tpGlobal.Controls.Add(this.label10);
			this.tpGlobal.Controls.Add(this.btnFindDirTemp);
			this.tpGlobal.Controls.Add(this.txtWebServiceUrl);
			this.tpGlobal.Controls.Add(this.txtTempDirectoryPath);
			this.tpGlobal.Controls.Add(this.lblTempDirectoryPath);
			this.tpGlobal.Controls.Add(this.label1);
			this.tpGlobal.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("tpGlobal.Dock")));
			this.tpGlobal.Enabled = ((bool)(resources.GetObject("tpGlobal.Enabled")));
			this.tpGlobal.Font = ((System.Drawing.Font)(resources.GetObject("tpGlobal.Font")));
			this.tpGlobal.ImageIndex = ((int)(resources.GetObject("tpGlobal.ImageIndex")));
			this.tpGlobal.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("tpGlobal.ImeMode")));
			this.tpGlobal.Location = ((System.Drawing.Point)(resources.GetObject("tpGlobal.Location")));
			this.tpGlobal.Name = "tpGlobal";
			this.tpGlobal.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("tpGlobal.RightToLeft")));
			this.tpGlobal.Size = ((System.Drawing.Size)(resources.GetObject("tpGlobal.Size")));
			this.tpGlobal.TabIndex = ((int)(resources.GetObject("tpGlobal.TabIndex")));
			this.tpGlobal.Text = resources.GetString("tpGlobal.Text");
			this.toolTipMainForm.SetToolTip(this.tpGlobal, resources.GetString("tpGlobal.ToolTip"));
			this.tpGlobal.ToolTipText = resources.GetString("tpGlobal.ToolTipText");
			this.tpGlobal.Visible = ((bool)(resources.GetObject("tpGlobal.Visible")));
			// 
			// label10
			// 
			this.label10.AccessibleDescription = resources.GetString("label10.AccessibleDescription");
			this.label10.AccessibleName = resources.GetString("label10.AccessibleName");
			this.label10.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label10.Anchor")));
			this.label10.AutoSize = ((bool)(resources.GetObject("label10.AutoSize")));
			this.label10.BackColor = System.Drawing.Color.Transparent;
			this.label10.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label10.Dock")));
			this.label10.Enabled = ((bool)(resources.GetObject("label10.Enabled")));
			this.label10.Font = ((System.Drawing.Font)(resources.GetObject("label10.Font")));
			this.label10.Image = ((System.Drawing.Image)(resources.GetObject("label10.Image")));
			this.label10.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label10.ImageAlign")));
			this.label10.ImageIndex = ((int)(resources.GetObject("label10.ImageIndex")));
			this.label10.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label10.ImeMode")));
			this.label10.Location = ((System.Drawing.Point)(resources.GetObject("label10.Location")));
			this.label10.Name = "label10";
			this.label10.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label10.RightToLeft")));
			this.label10.Size = ((System.Drawing.Size)(resources.GetObject("label10.Size")));
			this.label10.TabIndex = ((int)(resources.GetObject("label10.TabIndex")));
			this.label10.Text = resources.GetString("label10.Text");
			this.label10.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label10.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label10, resources.GetString("label10.ToolTip"));
			this.label10.Visible = ((bool)(resources.GetObject("label10.Visible")));
			// 
			// btnFindDirTemp
			// 
			this.btnFindDirTemp.AccessibleDescription = resources.GetString("btnFindDirTemp.AccessibleDescription");
			this.btnFindDirTemp.AccessibleName = resources.GetString("btnFindDirTemp.AccessibleName");
			this.btnFindDirTemp.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnFindDirTemp.Anchor")));
			this.btnFindDirTemp.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnFindDirTemp.BackgroundImage")));
			this.btnFindDirTemp.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnFindDirTemp.Dock")));
			this.btnFindDirTemp.Enabled = ((bool)(resources.GetObject("btnFindDirTemp.Enabled")));
			this.btnFindDirTemp.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnFindDirTemp.FlatStyle")));
			this.btnFindDirTemp.Font = ((System.Drawing.Font)(resources.GetObject("btnFindDirTemp.Font")));
			this.btnFindDirTemp.Image = ((System.Drawing.Image)(resources.GetObject("btnFindDirTemp.Image")));
			this.btnFindDirTemp.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnFindDirTemp.ImageAlign")));
			this.btnFindDirTemp.ImageIndex = ((int)(resources.GetObject("btnFindDirTemp.ImageIndex")));
			this.btnFindDirTemp.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnFindDirTemp.ImeMode")));
			this.btnFindDirTemp.Location = ((System.Drawing.Point)(resources.GetObject("btnFindDirTemp.Location")));
			this.btnFindDirTemp.Name = "btnFindDirTemp";
			this.btnFindDirTemp.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnFindDirTemp.RightToLeft")));
			this.btnFindDirTemp.Size = ((System.Drawing.Size)(resources.GetObject("btnFindDirTemp.Size")));
			this.btnFindDirTemp.TabIndex = ((int)(resources.GetObject("btnFindDirTemp.TabIndex")));
			this.btnFindDirTemp.Text = resources.GetString("btnFindDirTemp.Text");
			this.btnFindDirTemp.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnFindDirTemp.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnFindDirTemp, resources.GetString("btnFindDirTemp.ToolTip"));
			this.btnFindDirTemp.Visible = ((bool)(resources.GetObject("btnFindDirTemp.Visible")));
			this.btnFindDirTemp.Click += new System.EventHandler(this.btnFindDirTemp_Click);
			// 
			// lblTempDirectoryPath
			// 
			this.lblTempDirectoryPath.AccessibleDescription = resources.GetString("lblTempDirectoryPath.AccessibleDescription");
			this.lblTempDirectoryPath.AccessibleName = resources.GetString("lblTempDirectoryPath.AccessibleName");
			this.lblTempDirectoryPath.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("lblTempDirectoryPath.Anchor")));
			this.lblTempDirectoryPath.AutoSize = ((bool)(resources.GetObject("lblTempDirectoryPath.AutoSize")));
			this.lblTempDirectoryPath.BackColor = System.Drawing.Color.Transparent;
			this.lblTempDirectoryPath.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("lblTempDirectoryPath.Dock")));
			this.lblTempDirectoryPath.Enabled = ((bool)(resources.GetObject("lblTempDirectoryPath.Enabled")));
			this.lblTempDirectoryPath.Font = ((System.Drawing.Font)(resources.GetObject("lblTempDirectoryPath.Font")));
			this.lblTempDirectoryPath.Image = ((System.Drawing.Image)(resources.GetObject("lblTempDirectoryPath.Image")));
			this.lblTempDirectoryPath.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblTempDirectoryPath.ImageAlign")));
			this.lblTempDirectoryPath.ImageIndex = ((int)(resources.GetObject("lblTempDirectoryPath.ImageIndex")));
			this.lblTempDirectoryPath.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("lblTempDirectoryPath.ImeMode")));
			this.lblTempDirectoryPath.Location = ((System.Drawing.Point)(resources.GetObject("lblTempDirectoryPath.Location")));
			this.lblTempDirectoryPath.Name = "lblTempDirectoryPath";
			this.lblTempDirectoryPath.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("lblTempDirectoryPath.RightToLeft")));
			this.lblTempDirectoryPath.Size = ((System.Drawing.Size)(resources.GetObject("lblTempDirectoryPath.Size")));
			this.lblTempDirectoryPath.TabIndex = ((int)(resources.GetObject("lblTempDirectoryPath.TabIndex")));
			this.lblTempDirectoryPath.Text = resources.GetString("lblTempDirectoryPath.Text");
			this.lblTempDirectoryPath.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("lblTempDirectoryPath.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.lblTempDirectoryPath, resources.GetString("lblTempDirectoryPath.ToolTip"));
			this.lblTempDirectoryPath.Visible = ((bool)(resources.GetObject("lblTempDirectoryPath.Visible")));
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
			// tpdetail
			// 
			this.tpdetail.AccessibleDescription = resources.GetString("tpdetail.AccessibleDescription");
			this.tpdetail.AccessibleName = resources.GetString("tpdetail.AccessibleName");
			this.tpdetail.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tpdetail.Anchor")));
			this.tpdetail.AutoScroll = ((bool)(resources.GetObject("tpdetail.AutoScroll")));
			this.tpdetail.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("tpdetail.AutoScrollMargin")));
			this.tpdetail.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("tpdetail.AutoScrollMinSize")));
			this.tpdetail.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tpdetail.BackgroundImage")));
			this.tpdetail.Controls.Add(this.label2);
			this.tpdetail.Controls.Add(this.label5);
			this.tpdetail.Controls.Add(this.label4);
			this.tpdetail.Controls.Add(this.label3);
			this.tpdetail.Controls.Add(this.chkExtractAttachments);
			this.tpdetail.Controls.Add(this.listUser);
			this.tpdetail.Controls.Add(this.listBook);
			this.tpdetail.Controls.Add(this.btnDeleteMailbox);
			this.tpdetail.Controls.Add(this.btnAddMailbox);
			this.tpdetail.Controls.Add(this.listMailbox);
			this.tpdetail.Controls.Add(this.listDocumentType);
			this.tpdetail.Controls.Add(this.chkShowRegistrationMessages);
			this.tpdetail.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("tpdetail.Dock")));
			this.tpdetail.Enabled = ((bool)(resources.GetObject("tpdetail.Enabled")));
			this.tpdetail.Font = ((System.Drawing.Font)(resources.GetObject("tpdetail.Font")));
			this.tpdetail.ImageIndex = ((int)(resources.GetObject("tpdetail.ImageIndex")));
			this.tpdetail.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("tpdetail.ImeMode")));
			this.tpdetail.Location = ((System.Drawing.Point)(resources.GetObject("tpdetail.Location")));
			this.tpdetail.Name = "tpdetail";
			this.tpdetail.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("tpdetail.RightToLeft")));
			this.tpdetail.Size = ((System.Drawing.Size)(resources.GetObject("tpdetail.Size")));
			this.tpdetail.TabIndex = ((int)(resources.GetObject("tpdetail.TabIndex")));
			this.tpdetail.Text = resources.GetString("tpdetail.Text");
			this.toolTipMainForm.SetToolTip(this.tpdetail, resources.GetString("tpdetail.ToolTip"));
			this.tpdetail.ToolTipText = resources.GetString("tpdetail.ToolTipText");
			this.tpdetail.Visible = ((bool)(resources.GetObject("tpdetail.Visible")));
			// 
			// label2
			// 
			this.label2.AccessibleDescription = resources.GetString("label2.AccessibleDescription");
			this.label2.AccessibleName = resources.GetString("label2.AccessibleName");
			this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label2.Anchor")));
			this.label2.AutoSize = ((bool)(resources.GetObject("label2.AutoSize")));
			this.label2.BackColor = System.Drawing.Color.Transparent;
			this.label2.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label2.Dock")));
			this.label2.Enabled = ((bool)(resources.GetObject("label2.Enabled")));
			this.label2.Font = ((System.Drawing.Font)(resources.GetObject("label2.Font")));
			this.label2.Image = ((System.Drawing.Image)(resources.GetObject("label2.Image")));
			this.label2.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label2.ImageAlign")));
			this.label2.ImageIndex = ((int)(resources.GetObject("label2.ImageIndex")));
			this.label2.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label2.ImeMode")));
			this.label2.Location = ((System.Drawing.Point)(resources.GetObject("label2.Location")));
			this.label2.Name = "label2";
			this.label2.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label2.RightToLeft")));
			this.label2.Size = ((System.Drawing.Size)(resources.GetObject("label2.Size")));
			this.label2.TabIndex = ((int)(resources.GetObject("label2.TabIndex")));
			this.label2.Text = resources.GetString("label2.Text");
			this.label2.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label2.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label2, resources.GetString("label2.ToolTip"));
			this.label2.Visible = ((bool)(resources.GetObject("label2.Visible")));
			// 
			// label5
			// 
			this.label5.AccessibleDescription = resources.GetString("label5.AccessibleDescription");
			this.label5.AccessibleName = resources.GetString("label5.AccessibleName");
			this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label5.Anchor")));
			this.label5.AutoSize = ((bool)(resources.GetObject("label5.AutoSize")));
			this.label5.BackColor = System.Drawing.Color.Transparent;
			this.label5.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label5.Dock")));
			this.label5.Enabled = ((bool)(resources.GetObject("label5.Enabled")));
			this.label5.Font = ((System.Drawing.Font)(resources.GetObject("label5.Font")));
			this.label5.Image = ((System.Drawing.Image)(resources.GetObject("label5.Image")));
			this.label5.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label5.ImageAlign")));
			this.label5.ImageIndex = ((int)(resources.GetObject("label5.ImageIndex")));
			this.label5.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label5.ImeMode")));
			this.label5.Location = ((System.Drawing.Point)(resources.GetObject("label5.Location")));
			this.label5.Name = "label5";
			this.label5.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label5.RightToLeft")));
			this.label5.Size = ((System.Drawing.Size)(resources.GetObject("label5.Size")));
			this.label5.TabIndex = ((int)(resources.GetObject("label5.TabIndex")));
			this.label5.Text = resources.GetString("label5.Text");
			this.label5.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label5.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label5, resources.GetString("label5.ToolTip"));
			this.label5.Visible = ((bool)(resources.GetObject("label5.Visible")));
			// 
			// label4
			// 
			this.label4.AccessibleDescription = resources.GetString("label4.AccessibleDescription");
			this.label4.AccessibleName = resources.GetString("label4.AccessibleName");
			this.label4.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label4.Anchor")));
			this.label4.AutoSize = ((bool)(resources.GetObject("label4.AutoSize")));
			this.label4.BackColor = System.Drawing.Color.Transparent;
			this.label4.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label4.Dock")));
			this.label4.Enabled = ((bool)(resources.GetObject("label4.Enabled")));
			this.label4.Font = ((System.Drawing.Font)(resources.GetObject("label4.Font")));
			this.label4.Image = ((System.Drawing.Image)(resources.GetObject("label4.Image")));
			this.label4.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label4.ImageAlign")));
			this.label4.ImageIndex = ((int)(resources.GetObject("label4.ImageIndex")));
			this.label4.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label4.ImeMode")));
			this.label4.Location = ((System.Drawing.Point)(resources.GetObject("label4.Location")));
			this.label4.Name = "label4";
			this.label4.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label4.RightToLeft")));
			this.label4.Size = ((System.Drawing.Size)(resources.GetObject("label4.Size")));
			this.label4.TabIndex = ((int)(resources.GetObject("label4.TabIndex")));
			this.label4.Text = resources.GetString("label4.Text");
			this.label4.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label4.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label4, resources.GetString("label4.ToolTip"));
			this.label4.Visible = ((bool)(resources.GetObject("label4.Visible")));
			// 
			// label3
			// 
			this.label3.AccessibleDescription = resources.GetString("label3.AccessibleDescription");
			this.label3.AccessibleName = resources.GetString("label3.AccessibleName");
			this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label3.Anchor")));
			this.label3.AutoSize = ((bool)(resources.GetObject("label3.AutoSize")));
			this.label3.BackColor = System.Drawing.Color.Transparent;
			this.label3.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label3.Dock")));
			this.label3.Enabled = ((bool)(resources.GetObject("label3.Enabled")));
			this.label3.Font = ((System.Drawing.Font)(resources.GetObject("label3.Font")));
			this.label3.Image = ((System.Drawing.Image)(resources.GetObject("label3.Image")));
			this.label3.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label3.ImageAlign")));
			this.label3.ImageIndex = ((int)(resources.GetObject("label3.ImageIndex")));
			this.label3.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label3.ImeMode")));
			this.label3.Location = ((System.Drawing.Point)(resources.GetObject("label3.Location")));
			this.label3.Name = "label3";
			this.label3.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label3.RightToLeft")));
			this.label3.Size = ((System.Drawing.Size)(resources.GetObject("label3.Size")));
			this.label3.TabIndex = ((int)(resources.GetObject("label3.TabIndex")));
			this.label3.Text = resources.GetString("label3.Text");
			this.label3.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label3.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label3, resources.GetString("label3.ToolTip"));
			this.label3.Visible = ((bool)(resources.GetObject("label3.Visible")));
			// 
			// tpConfig
			// 
			this.tpConfig.AccessibleDescription = resources.GetString("tpConfig.AccessibleDescription");
			this.tpConfig.AccessibleName = resources.GetString("tpConfig.AccessibleName");
			this.tpConfig.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("tpConfig.Anchor")));
			this.tpConfig.AutoScroll = ((bool)(resources.GetObject("tpConfig.AutoScroll")));
			this.tpConfig.AutoScrollMargin = ((System.Drawing.Size)(resources.GetObject("tpConfig.AutoScrollMargin")));
			this.tpConfig.AutoScrollMinSize = ((System.Drawing.Size)(resources.GetObject("tpConfig.AutoScrollMinSize")));
			this.tpConfig.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("tpConfig.BackgroundImage")));
			this.tpConfig.Controls.Add(this.cmbReceive);
			this.tpConfig.Controls.Add(this.cmbBody);
			this.tpConfig.Controls.Add(this.cmbSubject);
			this.tpConfig.Controls.Add(this.cmbCc);
			this.tpConfig.Controls.Add(this.cmbTo);
			this.tpConfig.Controls.Add(this.cmbFrom);
			this.tpConfig.Controls.Add(this.btnDefault);
			this.tpConfig.Controls.Add(this.lstMailBoxConfig);
			this.tpConfig.Controls.Add(this.label13);
			this.tpConfig.Controls.Add(this.label12);
			this.tpConfig.Controls.Add(this.label11);
			this.tpConfig.Controls.Add(this.label9);
			this.tpConfig.Controls.Add(this.label8);
			this.tpConfig.Controls.Add(this.label7);
			this.tpConfig.Controls.Add(this.label6);
			this.tpConfig.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("tpConfig.Dock")));
			this.tpConfig.Enabled = ((bool)(resources.GetObject("tpConfig.Enabled")));
			this.tpConfig.Font = ((System.Drawing.Font)(resources.GetObject("tpConfig.Font")));
			this.tpConfig.ImageIndex = ((int)(resources.GetObject("tpConfig.ImageIndex")));
			this.tpConfig.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("tpConfig.ImeMode")));
			this.tpConfig.Location = ((System.Drawing.Point)(resources.GetObject("tpConfig.Location")));
			this.tpConfig.Name = "tpConfig";
			this.tpConfig.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("tpConfig.RightToLeft")));
			this.tpConfig.Size = ((System.Drawing.Size)(resources.GetObject("tpConfig.Size")));
			this.tpConfig.TabIndex = ((int)(resources.GetObject("tpConfig.TabIndex")));
			this.tpConfig.Text = resources.GetString("tpConfig.Text");
			this.toolTipMainForm.SetToolTip(this.tpConfig, resources.GetString("tpConfig.ToolTip"));
			this.tpConfig.ToolTipText = resources.GetString("tpConfig.ToolTipText");
			this.tpConfig.Visible = ((bool)(resources.GetObject("tpConfig.Visible")));
			// 
			// cmbReceive
			// 
			this.cmbReceive.AccessibleDescription = resources.GetString("cmbReceive.AccessibleDescription");
			this.cmbReceive.AccessibleName = resources.GetString("cmbReceive.AccessibleName");
			this.cmbReceive.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmbReceive.Anchor")));
			this.cmbReceive.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmbReceive.BackgroundImage")));
			this.cmbReceive.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmbReceive.Dock")));
			this.cmbReceive.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbReceive.Enabled = ((bool)(resources.GetObject("cmbReceive.Enabled")));
			this.cmbReceive.Font = ((System.Drawing.Font)(resources.GetObject("cmbReceive.Font")));
			this.cmbReceive.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmbReceive.ImeMode")));
			this.cmbReceive.IntegralHeight = ((bool)(resources.GetObject("cmbReceive.IntegralHeight")));
			this.cmbReceive.ItemHeight = ((int)(resources.GetObject("cmbReceive.ItemHeight")));
			this.cmbReceive.Location = ((System.Drawing.Point)(resources.GetObject("cmbReceive.Location")));
			this.cmbReceive.MaxDropDownItems = ((int)(resources.GetObject("cmbReceive.MaxDropDownItems")));
			this.cmbReceive.MaxLength = ((int)(resources.GetObject("cmbReceive.MaxLength")));
			this.cmbReceive.Name = "cmbReceive";
			this.cmbReceive.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmbReceive.RightToLeft")));
			this.cmbReceive.Size = ((System.Drawing.Size)(resources.GetObject("cmbReceive.Size")));
			this.cmbReceive.TabIndex = ((int)(resources.GetObject("cmbReceive.TabIndex")));
			this.cmbReceive.Text = resources.GetString("cmbReceive.Text");
			this.toolTipMainForm.SetToolTip(this.cmbReceive, resources.GetString("cmbReceive.ToolTip"));
			this.cmbReceive.Visible = ((bool)(resources.GetObject("cmbReceive.Visible")));
			this.cmbReceive.SelectedIndexChanged += new System.EventHandler(this.cmbReceive_SelectedIndexChanged);
			// 
			// cmbBody
			// 
			this.cmbBody.AccessibleDescription = resources.GetString("cmbBody.AccessibleDescription");
			this.cmbBody.AccessibleName = resources.GetString("cmbBody.AccessibleName");
			this.cmbBody.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmbBody.Anchor")));
			this.cmbBody.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmbBody.BackgroundImage")));
			this.cmbBody.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmbBody.Dock")));
			this.cmbBody.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbBody.Enabled = ((bool)(resources.GetObject("cmbBody.Enabled")));
			this.cmbBody.Font = ((System.Drawing.Font)(resources.GetObject("cmbBody.Font")));
			this.cmbBody.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmbBody.ImeMode")));
			this.cmbBody.IntegralHeight = ((bool)(resources.GetObject("cmbBody.IntegralHeight")));
			this.cmbBody.ItemHeight = ((int)(resources.GetObject("cmbBody.ItemHeight")));
			this.cmbBody.Location = ((System.Drawing.Point)(resources.GetObject("cmbBody.Location")));
			this.cmbBody.MaxDropDownItems = ((int)(resources.GetObject("cmbBody.MaxDropDownItems")));
			this.cmbBody.MaxLength = ((int)(resources.GetObject("cmbBody.MaxLength")));
			this.cmbBody.Name = "cmbBody";
			this.cmbBody.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmbBody.RightToLeft")));
			this.cmbBody.Size = ((System.Drawing.Size)(resources.GetObject("cmbBody.Size")));
			this.cmbBody.TabIndex = ((int)(resources.GetObject("cmbBody.TabIndex")));
			this.cmbBody.Text = resources.GetString("cmbBody.Text");
			this.toolTipMainForm.SetToolTip(this.cmbBody, resources.GetString("cmbBody.ToolTip"));
			this.cmbBody.Visible = ((bool)(resources.GetObject("cmbBody.Visible")));
			this.cmbBody.SelectedIndexChanged += new System.EventHandler(this.cmbBody_SelectedIndexChanged);
			// 
			// cmbSubject
			// 
			this.cmbSubject.AccessibleDescription = resources.GetString("cmbSubject.AccessibleDescription");
			this.cmbSubject.AccessibleName = resources.GetString("cmbSubject.AccessibleName");
			this.cmbSubject.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmbSubject.Anchor")));
			this.cmbSubject.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmbSubject.BackgroundImage")));
			this.cmbSubject.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmbSubject.Dock")));
			this.cmbSubject.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbSubject.Enabled = ((bool)(resources.GetObject("cmbSubject.Enabled")));
			this.cmbSubject.Font = ((System.Drawing.Font)(resources.GetObject("cmbSubject.Font")));
			this.cmbSubject.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmbSubject.ImeMode")));
			this.cmbSubject.IntegralHeight = ((bool)(resources.GetObject("cmbSubject.IntegralHeight")));
			this.cmbSubject.ItemHeight = ((int)(resources.GetObject("cmbSubject.ItemHeight")));
			this.cmbSubject.Location = ((System.Drawing.Point)(resources.GetObject("cmbSubject.Location")));
			this.cmbSubject.MaxDropDownItems = ((int)(resources.GetObject("cmbSubject.MaxDropDownItems")));
			this.cmbSubject.MaxLength = ((int)(resources.GetObject("cmbSubject.MaxLength")));
			this.cmbSubject.Name = "cmbSubject";
			this.cmbSubject.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmbSubject.RightToLeft")));
			this.cmbSubject.Size = ((System.Drawing.Size)(resources.GetObject("cmbSubject.Size")));
			this.cmbSubject.TabIndex = ((int)(resources.GetObject("cmbSubject.TabIndex")));
			this.cmbSubject.Text = resources.GetString("cmbSubject.Text");
			this.toolTipMainForm.SetToolTip(this.cmbSubject, resources.GetString("cmbSubject.ToolTip"));
			this.cmbSubject.Visible = ((bool)(resources.GetObject("cmbSubject.Visible")));
			this.cmbSubject.SelectedIndexChanged += new System.EventHandler(this.cmbSubject_SelectedIndexChanged);
			// 
			// cmbCc
			// 
			this.cmbCc.AccessibleDescription = resources.GetString("cmbCc.AccessibleDescription");
			this.cmbCc.AccessibleName = resources.GetString("cmbCc.AccessibleName");
			this.cmbCc.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmbCc.Anchor")));
			this.cmbCc.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmbCc.BackgroundImage")));
			this.cmbCc.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmbCc.Dock")));
			this.cmbCc.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbCc.Enabled = ((bool)(resources.GetObject("cmbCc.Enabled")));
			this.cmbCc.Font = ((System.Drawing.Font)(resources.GetObject("cmbCc.Font")));
			this.cmbCc.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmbCc.ImeMode")));
			this.cmbCc.IntegralHeight = ((bool)(resources.GetObject("cmbCc.IntegralHeight")));
			this.cmbCc.ItemHeight = ((int)(resources.GetObject("cmbCc.ItemHeight")));
			this.cmbCc.Location = ((System.Drawing.Point)(resources.GetObject("cmbCc.Location")));
			this.cmbCc.MaxDropDownItems = ((int)(resources.GetObject("cmbCc.MaxDropDownItems")));
			this.cmbCc.MaxLength = ((int)(resources.GetObject("cmbCc.MaxLength")));
			this.cmbCc.Name = "cmbCc";
			this.cmbCc.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmbCc.RightToLeft")));
			this.cmbCc.Size = ((System.Drawing.Size)(resources.GetObject("cmbCc.Size")));
			this.cmbCc.TabIndex = ((int)(resources.GetObject("cmbCc.TabIndex")));
			this.cmbCc.Text = resources.GetString("cmbCc.Text");
			this.toolTipMainForm.SetToolTip(this.cmbCc, resources.GetString("cmbCc.ToolTip"));
			this.cmbCc.Visible = ((bool)(resources.GetObject("cmbCc.Visible")));
			this.cmbCc.SelectedIndexChanged += new System.EventHandler(this.cmbCc_SelectedIndexChanged);
			// 
			// cmbTo
			// 
			this.cmbTo.AccessibleDescription = resources.GetString("cmbTo.AccessibleDescription");
			this.cmbTo.AccessibleName = resources.GetString("cmbTo.AccessibleName");
			this.cmbTo.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmbTo.Anchor")));
			this.cmbTo.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmbTo.BackgroundImage")));
			this.cmbTo.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmbTo.Dock")));
			this.cmbTo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbTo.Enabled = ((bool)(resources.GetObject("cmbTo.Enabled")));
			this.cmbTo.Font = ((System.Drawing.Font)(resources.GetObject("cmbTo.Font")));
			this.cmbTo.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmbTo.ImeMode")));
			this.cmbTo.IntegralHeight = ((bool)(resources.GetObject("cmbTo.IntegralHeight")));
			this.cmbTo.ItemHeight = ((int)(resources.GetObject("cmbTo.ItemHeight")));
			this.cmbTo.Location = ((System.Drawing.Point)(resources.GetObject("cmbTo.Location")));
			this.cmbTo.MaxDropDownItems = ((int)(resources.GetObject("cmbTo.MaxDropDownItems")));
			this.cmbTo.MaxLength = ((int)(resources.GetObject("cmbTo.MaxLength")));
			this.cmbTo.Name = "cmbTo";
			this.cmbTo.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmbTo.RightToLeft")));
			this.cmbTo.Size = ((System.Drawing.Size)(resources.GetObject("cmbTo.Size")));
			this.cmbTo.TabIndex = ((int)(resources.GetObject("cmbTo.TabIndex")));
			this.cmbTo.Text = resources.GetString("cmbTo.Text");
			this.toolTipMainForm.SetToolTip(this.cmbTo, resources.GetString("cmbTo.ToolTip"));
			this.cmbTo.Visible = ((bool)(resources.GetObject("cmbTo.Visible")));
			this.cmbTo.SelectedIndexChanged += new System.EventHandler(this.cmbTo_SelectedIndexChanged);
			// 
			// cmbFrom
			// 
			this.cmbFrom.AccessibleDescription = resources.GetString("cmbFrom.AccessibleDescription");
			this.cmbFrom.AccessibleName = resources.GetString("cmbFrom.AccessibleName");
			this.cmbFrom.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("cmbFrom.Anchor")));
			this.cmbFrom.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("cmbFrom.BackgroundImage")));
			this.cmbFrom.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("cmbFrom.Dock")));
			this.cmbFrom.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbFrom.Enabled = ((bool)(resources.GetObject("cmbFrom.Enabled")));
			this.cmbFrom.Font = ((System.Drawing.Font)(resources.GetObject("cmbFrom.Font")));
			this.cmbFrom.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("cmbFrom.ImeMode")));
			this.cmbFrom.IntegralHeight = ((bool)(resources.GetObject("cmbFrom.IntegralHeight")));
			this.cmbFrom.ItemHeight = ((int)(resources.GetObject("cmbFrom.ItemHeight")));
			this.cmbFrom.Location = ((System.Drawing.Point)(resources.GetObject("cmbFrom.Location")));
			this.cmbFrom.MaxDropDownItems = ((int)(resources.GetObject("cmbFrom.MaxDropDownItems")));
			this.cmbFrom.MaxLength = ((int)(resources.GetObject("cmbFrom.MaxLength")));
			this.cmbFrom.Name = "cmbFrom";
			this.cmbFrom.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("cmbFrom.RightToLeft")));
			this.cmbFrom.Size = ((System.Drawing.Size)(resources.GetObject("cmbFrom.Size")));
			this.cmbFrom.TabIndex = ((int)(resources.GetObject("cmbFrom.TabIndex")));
			this.cmbFrom.Text = resources.GetString("cmbFrom.Text");
			this.toolTipMainForm.SetToolTip(this.cmbFrom, resources.GetString("cmbFrom.ToolTip"));
			this.cmbFrom.Visible = ((bool)(resources.GetObject("cmbFrom.Visible")));
			this.cmbFrom.SelectedIndexChanged += new System.EventHandler(this.cmbFrom_SelectedIndexChanged);
			// 
			// btnDefault
			// 
			this.btnDefault.AccessibleDescription = resources.GetString("btnDefault.AccessibleDescription");
			this.btnDefault.AccessibleName = resources.GetString("btnDefault.AccessibleName");
			this.btnDefault.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("btnDefault.Anchor")));
			this.btnDefault.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnDefault.BackgroundImage")));
			this.btnDefault.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("btnDefault.Dock")));
			this.btnDefault.Enabled = ((bool)(resources.GetObject("btnDefault.Enabled")));
			this.btnDefault.FlatStyle = ((System.Windows.Forms.FlatStyle)(resources.GetObject("btnDefault.FlatStyle")));
			this.btnDefault.Font = ((System.Drawing.Font)(resources.GetObject("btnDefault.Font")));
			this.btnDefault.Image = ((System.Drawing.Image)(resources.GetObject("btnDefault.Image")));
			this.btnDefault.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnDefault.ImageAlign")));
			this.btnDefault.ImageIndex = ((int)(resources.GetObject("btnDefault.ImageIndex")));
			this.btnDefault.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("btnDefault.ImeMode")));
			this.btnDefault.Location = ((System.Drawing.Point)(resources.GetObject("btnDefault.Location")));
			this.btnDefault.Name = "btnDefault";
			this.btnDefault.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("btnDefault.RightToLeft")));
			this.btnDefault.Size = ((System.Drawing.Size)(resources.GetObject("btnDefault.Size")));
			this.btnDefault.TabIndex = ((int)(resources.GetObject("btnDefault.TabIndex")));
			this.btnDefault.Text = resources.GetString("btnDefault.Text");
			this.btnDefault.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("btnDefault.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.btnDefault, resources.GetString("btnDefault.ToolTip"));
			this.btnDefault.Visible = ((bool)(resources.GetObject("btnDefault.Visible")));
			this.btnDefault.Click += new System.EventHandler(this.btnDefault_Click);
			// 
			// lstMailBoxConfig
			// 
			this.lstMailBoxConfig.AccessibleDescription = resources.GetString("lstMailBoxConfig.AccessibleDescription");
			this.lstMailBoxConfig.AccessibleName = resources.GetString("lstMailBoxConfig.AccessibleName");
			this.lstMailBoxConfig.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("lstMailBoxConfig.Anchor")));
			this.lstMailBoxConfig.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("lstMailBoxConfig.BackgroundImage")));
			this.lstMailBoxConfig.ColumnWidth = ((int)(resources.GetObject("lstMailBoxConfig.ColumnWidth")));
			this.lstMailBoxConfig.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("lstMailBoxConfig.Dock")));
			this.lstMailBoxConfig.Enabled = ((bool)(resources.GetObject("lstMailBoxConfig.Enabled")));
			this.lstMailBoxConfig.Font = ((System.Drawing.Font)(resources.GetObject("lstMailBoxConfig.Font")));
			this.lstMailBoxConfig.HorizontalExtent = ((int)(resources.GetObject("lstMailBoxConfig.HorizontalExtent")));
			this.lstMailBoxConfig.HorizontalScrollbar = ((bool)(resources.GetObject("lstMailBoxConfig.HorizontalScrollbar")));
			this.lstMailBoxConfig.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("lstMailBoxConfig.ImeMode")));
			this.lstMailBoxConfig.IntegralHeight = ((bool)(resources.GetObject("lstMailBoxConfig.IntegralHeight")));
			this.lstMailBoxConfig.ItemHeight = ((int)(resources.GetObject("lstMailBoxConfig.ItemHeight")));
			this.lstMailBoxConfig.Location = ((System.Drawing.Point)(resources.GetObject("lstMailBoxConfig.Location")));
			this.lstMailBoxConfig.Name = "lstMailBoxConfig";
			this.lstMailBoxConfig.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("lstMailBoxConfig.RightToLeft")));
			this.lstMailBoxConfig.ScrollAlwaysVisible = ((bool)(resources.GetObject("lstMailBoxConfig.ScrollAlwaysVisible")));
			this.lstMailBoxConfig.Size = ((System.Drawing.Size)(resources.GetObject("lstMailBoxConfig.Size")));
			this.lstMailBoxConfig.TabIndex = ((int)(resources.GetObject("lstMailBoxConfig.TabIndex")));
			this.toolTipMainForm.SetToolTip(this.lstMailBoxConfig, resources.GetString("lstMailBoxConfig.ToolTip"));
			this.lstMailBoxConfig.Visible = ((bool)(resources.GetObject("lstMailBoxConfig.Visible")));
			this.lstMailBoxConfig.SelectedIndexChanged += new System.EventHandler(this.lstMailBoxConfig_SelectedIndexChanged);
			// 
			// label13
			// 
			this.label13.AccessibleDescription = resources.GetString("label13.AccessibleDescription");
			this.label13.AccessibleName = resources.GetString("label13.AccessibleName");
			this.label13.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label13.Anchor")));
			this.label13.AutoSize = ((bool)(resources.GetObject("label13.AutoSize")));
			this.label13.BackColor = System.Drawing.Color.Transparent;
			this.label13.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label13.Dock")));
			this.label13.Enabled = ((bool)(resources.GetObject("label13.Enabled")));
			this.label13.Font = ((System.Drawing.Font)(resources.GetObject("label13.Font")));
			this.label13.Image = ((System.Drawing.Image)(resources.GetObject("label13.Image")));
			this.label13.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label13.ImageAlign")));
			this.label13.ImageIndex = ((int)(resources.GetObject("label13.ImageIndex")));
			this.label13.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label13.ImeMode")));
			this.label13.Location = ((System.Drawing.Point)(resources.GetObject("label13.Location")));
			this.label13.Name = "label13";
			this.label13.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label13.RightToLeft")));
			this.label13.Size = ((System.Drawing.Size)(resources.GetObject("label13.Size")));
			this.label13.TabIndex = ((int)(resources.GetObject("label13.TabIndex")));
			this.label13.Text = resources.GetString("label13.Text");
			this.label13.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label13.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label13, resources.GetString("label13.ToolTip"));
			this.label13.Visible = ((bool)(resources.GetObject("label13.Visible")));
			// 
			// label12
			// 
			this.label12.AccessibleDescription = resources.GetString("label12.AccessibleDescription");
			this.label12.AccessibleName = resources.GetString("label12.AccessibleName");
			this.label12.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label12.Anchor")));
			this.label12.AutoSize = ((bool)(resources.GetObject("label12.AutoSize")));
			this.label12.BackColor = System.Drawing.Color.Transparent;
			this.label12.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label12.Dock")));
			this.label12.Enabled = ((bool)(resources.GetObject("label12.Enabled")));
			this.label12.Font = ((System.Drawing.Font)(resources.GetObject("label12.Font")));
			this.label12.Image = ((System.Drawing.Image)(resources.GetObject("label12.Image")));
			this.label12.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label12.ImageAlign")));
			this.label12.ImageIndex = ((int)(resources.GetObject("label12.ImageIndex")));
			this.label12.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label12.ImeMode")));
			this.label12.Location = ((System.Drawing.Point)(resources.GetObject("label12.Location")));
			this.label12.Name = "label12";
			this.label12.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label12.RightToLeft")));
			this.label12.Size = ((System.Drawing.Size)(resources.GetObject("label12.Size")));
			this.label12.TabIndex = ((int)(resources.GetObject("label12.TabIndex")));
			this.label12.Text = resources.GetString("label12.Text");
			this.label12.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label12.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label12, resources.GetString("label12.ToolTip"));
			this.label12.Visible = ((bool)(resources.GetObject("label12.Visible")));
			// 
			// label11
			// 
			this.label11.AccessibleDescription = resources.GetString("label11.AccessibleDescription");
			this.label11.AccessibleName = resources.GetString("label11.AccessibleName");
			this.label11.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label11.Anchor")));
			this.label11.AutoSize = ((bool)(resources.GetObject("label11.AutoSize")));
			this.label11.BackColor = System.Drawing.Color.Transparent;
			this.label11.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label11.Dock")));
			this.label11.Enabled = ((bool)(resources.GetObject("label11.Enabled")));
			this.label11.Font = ((System.Drawing.Font)(resources.GetObject("label11.Font")));
			this.label11.Image = ((System.Drawing.Image)(resources.GetObject("label11.Image")));
			this.label11.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label11.ImageAlign")));
			this.label11.ImageIndex = ((int)(resources.GetObject("label11.ImageIndex")));
			this.label11.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label11.ImeMode")));
			this.label11.Location = ((System.Drawing.Point)(resources.GetObject("label11.Location")));
			this.label11.Name = "label11";
			this.label11.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label11.RightToLeft")));
			this.label11.Size = ((System.Drawing.Size)(resources.GetObject("label11.Size")));
			this.label11.TabIndex = ((int)(resources.GetObject("label11.TabIndex")));
			this.label11.Text = resources.GetString("label11.Text");
			this.label11.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label11.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label11, resources.GetString("label11.ToolTip"));
			this.label11.Visible = ((bool)(resources.GetObject("label11.Visible")));
			// 
			// label9
			// 
			this.label9.AccessibleDescription = resources.GetString("label9.AccessibleDescription");
			this.label9.AccessibleName = resources.GetString("label9.AccessibleName");
			this.label9.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label9.Anchor")));
			this.label9.AutoSize = ((bool)(resources.GetObject("label9.AutoSize")));
			this.label9.BackColor = System.Drawing.Color.Transparent;
			this.label9.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label9.Dock")));
			this.label9.Enabled = ((bool)(resources.GetObject("label9.Enabled")));
			this.label9.Font = ((System.Drawing.Font)(resources.GetObject("label9.Font")));
			this.label9.Image = ((System.Drawing.Image)(resources.GetObject("label9.Image")));
			this.label9.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label9.ImageAlign")));
			this.label9.ImageIndex = ((int)(resources.GetObject("label9.ImageIndex")));
			this.label9.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label9.ImeMode")));
			this.label9.Location = ((System.Drawing.Point)(resources.GetObject("label9.Location")));
			this.label9.Name = "label9";
			this.label9.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label9.RightToLeft")));
			this.label9.Size = ((System.Drawing.Size)(resources.GetObject("label9.Size")));
			this.label9.TabIndex = ((int)(resources.GetObject("label9.TabIndex")));
			this.label9.Text = resources.GetString("label9.Text");
			this.label9.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label9.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label9, resources.GetString("label9.ToolTip"));
			this.label9.Visible = ((bool)(resources.GetObject("label9.Visible")));
			// 
			// label8
			// 
			this.label8.AccessibleDescription = resources.GetString("label8.AccessibleDescription");
			this.label8.AccessibleName = resources.GetString("label8.AccessibleName");
			this.label8.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label8.Anchor")));
			this.label8.AutoSize = ((bool)(resources.GetObject("label8.AutoSize")));
			this.label8.BackColor = System.Drawing.Color.Transparent;
			this.label8.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label8.Dock")));
			this.label8.Enabled = ((bool)(resources.GetObject("label8.Enabled")));
			this.label8.Font = ((System.Drawing.Font)(resources.GetObject("label8.Font")));
			this.label8.Image = ((System.Drawing.Image)(resources.GetObject("label8.Image")));
			this.label8.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label8.ImageAlign")));
			this.label8.ImageIndex = ((int)(resources.GetObject("label8.ImageIndex")));
			this.label8.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label8.ImeMode")));
			this.label8.Location = ((System.Drawing.Point)(resources.GetObject("label8.Location")));
			this.label8.Name = "label8";
			this.label8.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label8.RightToLeft")));
			this.label8.Size = ((System.Drawing.Size)(resources.GetObject("label8.Size")));
			this.label8.TabIndex = ((int)(resources.GetObject("label8.TabIndex")));
			this.label8.Text = resources.GetString("label8.Text");
			this.label8.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label8.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label8, resources.GetString("label8.ToolTip"));
			this.label8.Visible = ((bool)(resources.GetObject("label8.Visible")));
			// 
			// label7
			// 
			this.label7.AccessibleDescription = resources.GetString("label7.AccessibleDescription");
			this.label7.AccessibleName = resources.GetString("label7.AccessibleName");
			this.label7.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label7.Anchor")));
			this.label7.AutoSize = ((bool)(resources.GetObject("label7.AutoSize")));
			this.label7.BackColor = System.Drawing.Color.Transparent;
			this.label7.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label7.Dock")));
			this.label7.Enabled = ((bool)(resources.GetObject("label7.Enabled")));
			this.label7.Font = ((System.Drawing.Font)(resources.GetObject("label7.Font")));
			this.label7.Image = ((System.Drawing.Image)(resources.GetObject("label7.Image")));
			this.label7.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label7.ImageAlign")));
			this.label7.ImageIndex = ((int)(resources.GetObject("label7.ImageIndex")));
			this.label7.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label7.ImeMode")));
			this.label7.Location = ((System.Drawing.Point)(resources.GetObject("label7.Location")));
			this.label7.Name = "label7";
			this.label7.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label7.RightToLeft")));
			this.label7.Size = ((System.Drawing.Size)(resources.GetObject("label7.Size")));
			this.label7.TabIndex = ((int)(resources.GetObject("label7.TabIndex")));
			this.label7.Text = resources.GetString("label7.Text");
			this.label7.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label7.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label7, resources.GetString("label7.ToolTip"));
			this.label7.Visible = ((bool)(resources.GetObject("label7.Visible")));
			// 
			// label6
			// 
			this.label6.AccessibleDescription = resources.GetString("label6.AccessibleDescription");
			this.label6.AccessibleName = resources.GetString("label6.AccessibleName");
			this.label6.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label6.Anchor")));
			this.label6.AutoSize = ((bool)(resources.GetObject("label6.AutoSize")));
			this.label6.BackColor = System.Drawing.Color.Transparent;
			this.label6.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label6.Dock")));
			this.label6.Enabled = ((bool)(resources.GetObject("label6.Enabled")));
			this.label6.Font = ((System.Drawing.Font)(resources.GetObject("label6.Font")));
			this.label6.Image = ((System.Drawing.Image)(resources.GetObject("label6.Image")));
			this.label6.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label6.ImageAlign")));
			this.label6.ImageIndex = ((int)(resources.GetObject("label6.ImageIndex")));
			this.label6.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label6.ImeMode")));
			this.label6.Location = ((System.Drawing.Point)(resources.GetObject("label6.Location")));
			this.label6.Name = "label6";
			this.label6.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label6.RightToLeft")));
			this.label6.Size = ((System.Drawing.Size)(resources.GetObject("label6.Size")));
			this.label6.TabIndex = ((int)(resources.GetObject("label6.TabIndex")));
			this.label6.Text = resources.GetString("label6.Text");
			this.label6.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label6.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label6, resources.GetString("label6.ToolTip"));
			this.label6.Visible = ((bool)(resources.GetObject("label6.Visible")));
			// 
			// imageList1
			// 
			this.imageList1.ColorDepth = System.Windows.Forms.ColorDepth.Depth32Bit;
			this.imageList1.ImageSize = ((System.Drawing.Size)(resources.GetObject("imageList1.ImageSize")));
			this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
			this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
			// 
			// menuExtender1
			// 
			this.menuExtender1.Font = null;
			this.menuExtender1.ImageList = this.imageList1;
			this.menuExtender1.SystemFont = true;
			// 
			// label14
			// 
			this.label14.AccessibleDescription = resources.GetString("label14.AccessibleDescription");
			this.label14.AccessibleName = resources.GetString("label14.AccessibleName");
			this.label14.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("label14.Anchor")));
			this.label14.AutoSize = ((bool)(resources.GetObject("label14.AutoSize")));
			this.label14.BackColor = System.Drawing.Color.Transparent;
			this.label14.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("label14.Dock")));
			this.label14.Enabled = ((bool)(resources.GetObject("label14.Enabled")));
			this.label14.Font = ((System.Drawing.Font)(resources.GetObject("label14.Font")));
			this.label14.Image = ((System.Drawing.Image)(resources.GetObject("label14.Image")));
			this.label14.ImageAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label14.ImageAlign")));
			this.label14.ImageIndex = ((int)(resources.GetObject("label14.ImageIndex")));
			this.label14.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("label14.ImeMode")));
			this.label14.Location = ((System.Drawing.Point)(resources.GetObject("label14.Location")));
			this.label14.Name = "label14";
			this.label14.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("label14.RightToLeft")));
			this.label14.Size = ((System.Drawing.Size)(resources.GetObject("label14.Size")));
			this.label14.TabIndex = ((int)(resources.GetObject("label14.TabIndex")));
			this.label14.Text = resources.GetString("label14.Text");
			this.label14.TextAlign = ((System.Drawing.ContentAlignment)(resources.GetObject("label14.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.label14, resources.GetString("label14.ToolTip"));
			this.label14.Visible = ((bool)(resources.GetObject("label14.Visible")));
			// 
			// txtExchange
			// 
			this.txtExchange.AccessibleDescription = resources.GetString("txtExchange.AccessibleDescription");
			this.txtExchange.AccessibleName = resources.GetString("txtExchange.AccessibleName");
			this.txtExchange.Anchor = ((System.Windows.Forms.AnchorStyles)(resources.GetObject("txtExchange.Anchor")));
			this.txtExchange.AutoSize = ((bool)(resources.GetObject("txtExchange.AutoSize")));
			this.txtExchange.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("txtExchange.BackgroundImage")));
			this.txtExchange.Dock = ((System.Windows.Forms.DockStyle)(resources.GetObject("txtExchange.Dock")));
			this.txtExchange.Enabled = ((bool)(resources.GetObject("txtExchange.Enabled")));
			this.txtExchange.Font = ((System.Drawing.Font)(resources.GetObject("txtExchange.Font")));
			this.txtExchange.ImeMode = ((System.Windows.Forms.ImeMode)(resources.GetObject("txtExchange.ImeMode")));
			this.txtExchange.Location = ((System.Drawing.Point)(resources.GetObject("txtExchange.Location")));
			this.txtExchange.MaxLength = ((int)(resources.GetObject("txtExchange.MaxLength")));
			this.txtExchange.Multiline = ((bool)(resources.GetObject("txtExchange.Multiline")));
			this.txtExchange.Name = "txtExchange";
			this.txtExchange.PasswordChar = ((char)(resources.GetObject("txtExchange.PasswordChar")));
			this.txtExchange.RightToLeft = ((System.Windows.Forms.RightToLeft)(resources.GetObject("txtExchange.RightToLeft")));
			this.txtExchange.ScrollBars = ((System.Windows.Forms.ScrollBars)(resources.GetObject("txtExchange.ScrollBars")));
			this.txtExchange.Size = ((System.Drawing.Size)(resources.GetObject("txtExchange.Size")));
			this.txtExchange.TabIndex = ((int)(resources.GetObject("txtExchange.TabIndex")));
			this.txtExchange.Text = resources.GetString("txtExchange.Text");
			this.txtExchange.TextAlign = ((System.Windows.Forms.HorizontalAlignment)(resources.GetObject("txtExchange.TextAlign")));
			this.toolTipMainForm.SetToolTip(this.txtExchange, resources.GetString("txtExchange.ToolTip"));
			this.txtExchange.Visible = ((bool)(resources.GetObject("txtExchange.Visible")));
			this.txtExchange.WordWrap = ((bool)(resources.GetObject("txtExchange.WordWrap")));
			this.txtExchange.Validating += new System.ComponentModel.CancelEventHandler(this.txtExchange_Validating);
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
			this.Text = resources.GetString("$this.Text");
			this.toolTipMainForm.SetToolTip(this, resources.GetString("$this.ToolTip"));
			this.Closing += new System.ComponentModel.CancelEventHandler(this.MainForm_Closing);
			this.Load += new System.EventHandler(this.frmOWMailConfiguration_Load);
			this.tabControl1.ResumeLayout(false);
			this.tpGlobal.ResumeLayout(false);
			this.tpdetail.ResumeLayout(false);
			this.tpConfig.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			if (MainForm.RunningInstance() != null)
			{
				MessageBox.Show("O OWMail já está em execução.","Erro", MessageBoxButtons.OK,MessageBoxIcon.Error);
				
			}
			else
			{
				Application.Run(new MainForm());
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void frmOWMailConfiguration_Load(object sender, EventArgs e)
		{
			Initialize();
		}

		/// <summary>
		/// 
		/// </summary>
		private void Initialize()
		{
			btnAddMailbox.Focus();
			SetOperationMode(OperationMode.Idle);
			
			try
			{
				if (IsValidConfiguration())
				{
					SetOperationMode(OperationMode.Edit);
					ReadConfiguration();
				}
				else
				{
					SetOperationMode(OperationMode.Idle);
				}
			}
			catch (Exception ex)
			{
				throw ex;				
			}
		}

		
		/// <summary>
		/// Check if a valid configuration instance is available before proceeding.
		/// </summary>
		/// <returns>TRUE if a valid configuration was found, otherwise FALSE is returned.</returns>
		private bool IsValidConfiguration()
		{
			bool valid = false;
			
			if (Configuration != null)
			{
				valid = true;
			}

			return valid;
		}

		/// <summary>
		/// 
		/// </summary>
		private void OpenFile()
		{
			OpenFileDialog openFileDialog = new OpenFileDialog();
			openFileDialog.Filter = string.Format("Ficheiro de configuração do OWMail {0}|{1}", _version,FileName);
			openFileDialog.Title = "Abrir";

			if (openFileDialog.ShowDialog() == DialogResult.OK)
			{
				FilePath = openFileDialog.FileName;
				
				Splasher.Status = _readConfiguration;
				Splasher.Show();
				ReadConfiguration();
				
				if (IsValidConfiguration())
				{
					SetOperationMode(OperationMode.Edit);

					if (Configuration.Mailboxes.Count > 0)
					{
						listMailbox.SelectedItem = listMailbox.Items[0];
					}
				}
				Splasher.Close();
			
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private void SaveFile()
		{
			
			if (IsValidConfiguration())
			{
				SaveConfiguration();
			}
			
		}

		/// <summary>
		/// 
		/// </summary>
		private void ReadConfiguration()
		{
			Configuration = OWMailSerializer.Deserialize(FilePath);
			
			if (IsValidConfiguration())
			{
				GetConfigurationValues();
			}
			else
			{
				MessageBox.Show("O ficheiro de configuração não é válido", "Ficheiro inválido");
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private void SaveConfiguration()
		{
			if (IsValidConfiguration())
			{
				
				switch (ActiveOperationMode)
				{
					case OperationMode.Edit:
					{
						SetConfigurationValues();
						OWMailSerializer.Serialize(Configuration, FilePath);
						MessageBox.Show("A configuração foi guardada com sucesso", "Guardar configuração");

						break;
					}
					case OperationMode.New:
					{
						SaveFileDialog saveFileDialog = new SaveFileDialog();
						saveFileDialog.Filter = string.Format("Ficheiro de configuração do OWMail {0}|{1}",_version ,FileName);
						saveFileDialog.Title = "Guardar";

						DialogResult result = saveFileDialog.ShowDialog();

						if (saveFileDialog.FileName.Length > 0)
						{
							FilePath = saveFileDialog.FileName;

							SetConfigurationValues();
							OWMailSerializer.Serialize(Configuration, FilePath);
							MessageBox.Show("A nova configuração foi guardada com sucesso", "Guardar configuração");
						}

						break;
					}
					default:
					{
						break;
					}
				}
			}
			ActiveOperationMode = OperationMode.Edit;
		}

		/// <summary>
		/// 
		/// </summary>
		private void CloseFile()
		{
			switch (ActiveOperationMode)
			{
				case OperationMode.Edit:
				{
					if (!CheckConfigurationChanges())
					{
						ResetConfiguration();
						SetOperationMode(OperationMode.Idle);
					}

					break;
				}
				case OperationMode.New:
				{
					if (Configuration.Equals(new OWMailConfiguration()))
					{
						ResetConfiguration();
						SetOperationMode(OperationMode.Idle);
					}
					else
					{
						DialogResult result = MessageBox.Show("A configuração foi alterada. Pretende gravar as alterações efectuadas?", string.Format("OWMail {0}",_version), MessageBoxButtons.YesNoCancel);

						switch (result)
						{
							case (DialogResult.Yes):
							{
								SaveConfiguration();
								ResetConfiguration();
								SetOperationMode(OperationMode.Idle);

								break;
							}
							case (DialogResult.No):
							{
								ResetConfiguration();
								SetOperationMode(OperationMode.Idle);

								break;
							}
							case (DialogResult.Cancel):
							{
								break;
							}
							default:
							{
								break;
							}
						}
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
		/// 
		/// </summary>
		private void CreateFile()
		{
			FilePath = string.Empty;
			Configuration = new OWMailConfiguration();
			SetOperationMode(OperationMode.New);
			initializeDefaltValues();
			GetValues();
			
		}

		/// <summary>
		/// 
		/// </summary>
		private void ShowCopyright()
		{
			Copyright copyright = new Copyright();
			copyright.ShowDialog(this);
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuNew_Click(object sender, EventArgs e)
		{
			CreateFile();
			tabControl1.Enabled = true;
						
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuOpen_Click(object sender, EventArgs e)
		{
			OpenFile();
			tabControl1.Enabled = true;

			
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuClose_Click(object sender, EventArgs e)
		{
			CloseFile();
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuSave_Click(object sender, EventArgs e)
		{
			SaveFile();
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuExit_Click(object sender, EventArgs e)
		{
			if (!CheckConfigurationChanges())
			{
				Application.Exit();
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void menuAbout_Click(object sender, EventArgs e)
		{
			ShowCopyright();
		}

		/// <summary>
		/// 
		/// </summary>
		public void GetConfigurationValues()
		{
			Splasher.Show();
			tabControl1.Enabled = true;
			string url = string.Empty;
			if (Configuration.WebServiceUrl.IndexOf("http://") != -1) 
			{
				url = Configuration.WebServiceUrl.Substring(7);
				Configuration.WebServiceUrl = Configuration.WebServiceUrl.Substring(7);
				txtWebServiceUrl.Text = Configuration.WebServiceUrl;
				txtExchange.Text = Configuration.ExchangeServer;
			}
			else
			{
				url = Configuration.WebServiceUrl;
				txtWebServiceUrl.Text = Configuration.WebServiceUrl;
			}
			txtTempDirectoryPath.Text = Configuration.TempDirectoryPath;

			GetlistMailBox(listMailbox);
			

			if (WebServiceIsAvailable(url))
			{
				GetUsers();
				GetBooks();
				GetDocumentTypes();
			}
				
			GetValues();
			GetlistMailBox(lstMailBoxConfig);	
			Splasher.Close();
		}

		/// <summary>
		/// Preenche uma listBox com os valores da MailBox
		/// </summary>
		/// <param name="lst">ListBox que irá receber os valores</param>
		private void GetlistMailBox(ListBox lst)
		{
			if (Configuration.Mailboxes.Count > 0)
			{
				lst.Items.Clear();
				Configuration.Mailboxes.Sort(new OWMailConfiguration.Mailbox());
					
				foreach (OWMailConfiguration.Mailbox mailbox in Configuration.Mailboxes)
				{
					lst.Items.Add(mailbox.MailboxName);
				}

				if ( lst.Items.Count != -1) lst.SelectedIndex = 0;
			}
		}

		private void GetValues()
		{
			GetFromValues();
			GetToValues();
			GetCcValues();
			GetSubjectValues();
			GetBodyValues();
			GetReceivedValues();
		}

		private void GetFromValues()
		{
			cmbFrom.Items.Clear();

			if (Configuration.From != null && Configuration.From.Values.Count != 0)
			{
				cmbFrom.DisplayMember = "Text";
				foreach (ListItem item in Configuration.From.Values)
				{
					cmbFrom.Items.Add(new ListItem(item.Id, item.Text));
				}
				FindByValue(cmbFrom, Configuration.From.DefaultValue);
			}
		}

		private void GetToValues()
		{
			cmbTo.Items.Clear();
			cmbTo.DisplayMember = "Text";
			foreach (ListItem item in Configuration.To.Values)
			{
				
				cmbTo.Items.Add(new ListItem(item.Id, item.Text));
				
			}

			FindByValue(cmbTo, Configuration.To.DefaultValue);
			
		}

		private void GetCcValues()
		{
			cmbCc.Items.Clear();
			cmbCc.DisplayMember = "Text";
			foreach (ListItem item in Configuration.Cc.Values)
			{
				cmbCc.Items.Add(new ListItem(item.Id, item.Text));
			}

			FindByValue(cmbCc, Configuration.Cc.DefaultValue);
			
		}
		
		private void GetSubjectValues()
		{
			cmbSubject.Items.Clear();
			cmbSubject.DisplayMember = "Text";
			foreach ( ListItem item in Configuration.Subject.Values)
			{
				
				cmbSubject.Items.Add(new ListItem(item.Id,item.Text));
			}
			FindByValue(cmbSubject, configuration.Subject.DefaultValue);
		}

		private void GetBodyValues()
		{
			cmbBody.Items.Clear();
			cmbBody.DisplayMember = "Text";
			foreach ( ListItem item in Configuration.Body.Values)
			{
				
				cmbBody.Items.Add(new ListItem(item.Id,item.Text));
			}
			FindByValue(cmbBody, configuration.Body.DefaultValue);
		}

		private void GetReceivedValues()
		{
			cmbReceive.Items.Clear();
			cmbReceive.DisplayMember = "Text";
			foreach ( ListItem item in Configuration.Received.Values)
			{
				cmbReceive.Items.Add(new ListItem(item.Id,item.Text));
			}
			FindByValue(cmbReceive, configuration.Received.DefaultValue);
		}

		
		/// <summary>
		/// Select the item from Combobox by Id
		/// </summary>
		/// <param name="cmb">COMBOBOX OBJECT</param>
		/// <param name="id">ID TO FIND</param>
		private void FindByValue( ComboBox cmb, long id )
		{
			cmb.SelectedIndex = -1;
			for(int i=0; i<cmb.Items.Count; i++)
			{
				if (((ListItem)cmb.Items[i]).Id == id)
				{
					cmb.SelectedIndex=i;
					break;
				}
			}
		}
		

		private void initializeDefaltValues()
		{
			
			Configuration.WebServiceUrl = txtWebServiceUrl.Text;
			Configuration.TempDirectoryPath = txtTempDirectoryPath.Text;
			
			SetDefaultFromValues();
			SetDefaultToValues();
			SetDefaultCcValues();
			SetDefaultSubjectValues();
			SetDefaultBodyValues();
			SetDefaultReceivedValues();
			
		}

		private void SetDefaultReceivedValues()
		{
			ArrayList list = new ArrayList();
			OWMailConfiguration.ReceivedValues received = new OWMailConfiguration.ReceivedValues();
			list.Add(new ListItem((long)MappingOptions.NoMapping, ""));
			list.Add(new ListItem((long)MappingOptions.DataRegisto, "Data Registo"));
			list.Add(new ListItem((long)MappingOptions.DataDocumento, "Data Documento"));
			received.Values = list;
			received.DefaultValue = 1;
			Configuration.Received = received;
		}

		private void SetDefaultBodyValues()
		{
			ArrayList list = new ArrayList();
			OWMailConfiguration.BodyValues body = new OWMailConfiguration.BodyValues();
			list.Add(new ListItem((long)MappingOptions.NoMapping, ""));
			list.Add(new ListItem((long)MappingOptions.Observacoes, "Observações"));
			body.Values = list;
			body.DefaultValue = 1;
			Configuration.Body = body;
		}

		private void SetDefaultSubjectValues()
		{
			ArrayList list = new ArrayList();
			OWMailConfiguration.SubjectValues subject = new OWMailConfiguration.SubjectValues();
			list.Add(new ListItem((long)MappingOptions.NoMapping, ""));
			list.Add(new ListItem((long)MappingOptions.Assunto, "Assunto"));
			subject.Values = list;
			subject.DefaultValue = 1;
			Configuration.Subject = subject;
		}

		private void SetDefaultFromValues()
		{
			ArrayList list = new ArrayList();
			OWMailConfiguration.FromValues from = new OWMailConfiguration.FromValues();
			list.Add(new ListItem((long)MappingOptions.NoMapping, ""));
			list.Add(new ListItem((long)MappingOptions.EntPrincipal, "Entidade Principal"));
			list.Add(new ListItem((long)MappingOptions.MaisEntidadesOri, "Mais Entidades (origem)"));
			from.Values = list;
			from.DefaultValue = 1;
			Configuration.From = from;
		}

		private void SetDefaultToValues()
		{
			ArrayList list = new ArrayList();
			OWMailConfiguration.ToValues to = new OWMailConfiguration.ToValues();
			list.Add(new ListItem((long)MappingOptions.NoMapping, ""));
			list.Add(new ListItem((long)MappingOptions.MaisEntidadesDes, "Mais Entidades (destino)"));
			to.Values = list;
			to.DefaultValue = 1;
			Configuration.To = to;
		}
		private void SetDefaultCcValues()
		{
			ArrayList list = new ArrayList();
			list.Add(new ListItem((long)MappingOptions.NoMapping, ""));
			list.Add(new ListItem((long)MappingOptions.MaisEntidadesDes, "Mais Entidades (destino)"));
			OWMailConfiguration.CcValues cc = new OWMailConfiguration.CcValues();
			cc.Values = list;
			cc.DefaultValue = 1;
			Configuration.Cc = cc;
		}

		
		/// <summary>
		/// 
		/// </summary>
		private void SetConfigurationValues()
		{
			Configuration.WebServiceUrl =  string.Format("http://{0}",txtWebServiceUrl.Text);
			Configuration.TempDirectoryPath = txtTempDirectoryPath.Text;
			Configuration.ExchangeServer = txtExchange.Text;
			setAllComboBox();
		}

		/// <summary>
		/// Guarda a informação de todas as Bombobox
		/// </summary>
		private void setAllComboBox()
		{

			Configuration.From.DefaultValue = cmbFrom.SelectedIndex != -1 ?((ListItem)cmbFrom.SelectedItem).Id : (long)MappingOptions.NoMapping;
			Configuration.To.DefaultValue = cmbTo.SelectedIndex != -1 ? ((ListItem) cmbTo.SelectedItem).Id : (long)MappingOptions.NoMapping;
			Configuration.Cc.DefaultValue = cmbCc.SelectedIndex != -1 ? ((ListItem) cmbCc.SelectedItem).Id : (long)MappingOptions.NoMapping;
			Configuration.Subject.DefaultValue = cmbSubject.SelectedIndex != -1 ? ((ListItem) cmbSubject.SelectedItem).Id : (long)MappingOptions.NoMapping;
			Configuration.Body.DefaultValue = cmbBody.SelectedIndex != -1 ? ((ListItem) cmbBody.SelectedItem).Id : (long)MappingOptions.NoMapping;
			Configuration.Received.DefaultValue = cmbReceive.SelectedIndex != -1 ? ((ListItem) cmbReceive.SelectedItem).Id : (long)MappingOptions.NoMapping;
		}
		/// <summary>
		/// 
		/// </summary>
		private void ResetConfiguration()
		{
			Configuration = null;
			ResetFields(true);
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="includeGlobalFields"></param>
		public void ResetFields(bool includeGlobalFields)
		{
			if (includeGlobalFields)
			{
				txtWebServiceUrl.Text = string.Empty;
				txtTempDirectoryPath.Text = string.Empty;
				txtExchange.Text = string.Empty;
			}

			btnFindDirTemp.Enabled = false;	
			chkExtractAttachments.Checked = false;
			listMailbox.Items.Clear();
			listUser.Items.Clear();
			listBook.Items.Clear();
			listDocumentType.Items.Clear();
			lstMailBoxConfig.Items.Clear();
			cmbFrom.Items.Clear(); 
			cmbTo.Items.Clear(); 
			cmbCc.Items.Clear(); 
			cmbSubject.Items.Clear(); 
			cmbBody.Items.Clear(); 
			cmbReceive.Items.Clear(); 
			tabControl1.SelectedIndex = 0;
			tabControl1.Enabled = false;
			
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="mode"></param>
		private void SetOperationMode(OperationMode mode)
		{
			ActiveOperationMode = mode;
			string title = string.Format("Configuração do OWMail {0}",_version);

			switch (mode)
			{
				case OperationMode.Idle:
				{
					Text = title;
					
					menuNew.Enabled = true;
					menuOpen.Enabled = true;
					menuClose.Enabled = false;
					menuSave.Enabled = false;

					txtWebServiceUrl.Enabled = false;

					txtTempDirectoryPath.Enabled = false;
					

					break;
				}
				case OperationMode.Edit:
				{
					Text = "Editar - " + title;
					
					menuNew.Enabled = false;
					menuOpen.Enabled = false;
					menuClose.Enabled = true;
					menuSave.Enabled = true;
					
					txtWebServiceUrl.Enabled = true;
					txtTempDirectoryPath.Enabled = true;
					

					break;
				}
				case OperationMode.New:
				{
					Text = "Novo - " + title;

					menuNew.Enabled = false;
					menuOpen.Enabled = false;
					menuClose.Enabled = true;
					menuSave.Enabled = true;
					
					txtWebServiceUrl.Enabled = true;
					txtTempDirectoryPath.Enabled = true;
					

					break;
				}
				default:
				{
					break;
				}
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnDeleteMailbox_Click(object sender, EventArgs e)
		{
			DeleteMailbox();
		}
		private void AuxDeleteMailbox(string mailboxName)
		{
			RemoveMailboxByMailboxName(mailboxName);

			if (Configuration.Mailboxes.Count > 0)
			{
				listMailbox.SelectedItem = listMailbox.Items[0];
				lstMailBoxConfig.SelectedItem = lstMailBoxConfig.Items[0];
			}
			if (listMailbox.Items.Count == 0)
			{
				listUser.Items.Clear();
				listBook.Items.Clear();
				listDocumentType.Items.Clear();
			}
			else
			{
				GetUsers();
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// 
		private void DeleteMailbox()
		{
			if (listMailbox.SelectedItem != null)
			{
				DialogResult result = MessageBox.Show("Confirma que pretende remover a conta de correio seleccionada?", 
					"Remover conta de correio", 
					MessageBoxButtons.OKCancel);

				if (result == DialogResult.OK)
				{
					string mailboxName = listMailbox.SelectedItem.ToString();
					
					if (!ExchangeRegistrationProcessor(ExchangeOperation.Delete, mailboxName))
					{
						MessageBox.Show("Não foi possível remover a conta de correio seleccionada", "Remover conta de correio");
					}
					AuxDeleteMailbox(mailboxName);
				}
			}
			else
			{
				if (listMailbox.Items.Count > 0)
				{
					MessageBox.Show("Seleccione a conta de correio que pretende remover", "Remover conta de correio");
				}
			}
			//listMailbox.Items.Clear();

		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="mailboxName"></param>
		/// <returns></returns>
		private bool RemoveMailboxByMailboxName(string mailboxName)
		{
			bool success = false;
			int selected = -1;
			try 
			{
				for (int x = 0; x < Configuration.Mailboxes.Count; x++)
				{
					if (((OWMailConfiguration.Mailbox)Configuration.Mailboxes[x]).MailboxName == mailboxName)
					{
						selected = x;
						break;
					}
				}

				if (selected != -1)
				{
				
					Configuration.Mailboxes.RemoveAt(selected);
					listMailbox.Items.RemoveAt(selected);
					lstMailBoxConfig.Items.RemoveAt(selected);
					success = true;
				}
			}
			catch ( Exception ex)
			{
				Debug.Write(ex.Message);
			}

			return success;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void MainForm_Closing(object sender, CancelEventArgs e)
		{
			if (CheckConfigurationChanges())
			{
				e.Cancel = true;				
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		private bool CheckConfigurationChanges()
		{
			bool cancel = false;
			
			if (IsValidConfiguration())
			{
				SetConfigurationValues();
			
				if (ConfigurationHasChanged())
				{
					DialogResult result = MessageBox.Show("A configuração foi alterada. Pretende gravar as alterações efectuadas?", "OWMail 3.0", MessageBoxButtons.YesNoCancel);

					switch (result)
					{
						case (DialogResult.Yes):
						{
							SaveConfiguration();

							break;
						}
						case (DialogResult.No):
						{
							break;
						}
						case (DialogResult.Cancel):
						{
							cancel = true;
						
							break;
						}
						default:
						{
							break;
						}
					}
				}
			}

			return cancel;
		}
		
		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		private bool ConfigurationHasChanged()
		{
			bool hasChanged = true;

			if (Configuration != null)
			{
				switch (ActiveOperationMode)
				{
					case OperationMode.New:
					{
						if (Configuration.Equals(new OWMailConfiguration()))
						{
							hasChanged = false;
						}

						break;
					}
					case OperationMode.Edit:
					{
						if (Configuration.Equals(OWMailSerializer.Deserialize(FilePath)))
						{
							hasChanged = false;
						}

						break;
					}
					default:
					{
						break;
					}
				}
			}

			return hasChanged;
		}

		/// <summary>
		/// 
		/// </summary>
		private void GetUsers()
		{
			try
			{
				if (Configuration != null && 
					Configuration.WebServiceUrl.Length > 0 && 
					Configuration.Mailboxes.Count > 0)
				{
					OWApi OWApi = new OWApi();
					OWApi.Url = string.Format("http://{0}",Configuration.WebServiceUrl);

					stUser[] users = OWApi.GetUsersByProduct(enumObjectType.OBJ_PRODUCT_REGISTRY, true);

					listUser.Items.Clear();
				
					for (int x = 0; x < users.Length; x++)
					{
						listUser.Items.Insert(x, users[x].UserLogin);

						if (listMailbox.SelectedItem != null && Configuration.GetUserLoginByMailboxName(listMailbox.SelectedItem.ToString()) == users[x].UserLogin)
						{
							chkExtractAttachments.Checked = Configuration.GetExtractAttachmentsByMailboxName(listMailbox.SelectedItem.ToString());
							listUser.SelectedIndex = x;
							GetBooks();
						}

					}
				}
			}
			catch (SoapException)
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", "Serviço web indisponível");
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private void GetBooks()
		{
			try
			{
				if (Configuration != null && 
					Configuration.WebServiceUrl.Length > 0 && 
					Configuration.Mailboxes.Count > 0 &&
					listUser.SelectedItem != null)
				{
					string userLogin = listUser.SelectedItem.ToString();
				
					OWApi OWApi = new OWApi();
					OWApi.Url = string.Format("http://{0}",Configuration.WebServiceUrl);
					stBook[] books = OWApi.GetBook(userLogin, 1);

					listBook.Items.Clear();
					listDocumentType.Items.Clear();

					for (int x = 0; x < books.Length; x++)
					{
						listBook.DisplayMember = "Text";
						listBook.Items.Insert(x, new ListItem(books[x].BookID, books[x].BookDescription));

						if (listMailbox.SelectedItem != null && Configuration.GetBookIdByMailboxName(listMailbox.SelectedItem.ToString()) == (int)books[x].BookID)
						{
							listBook.SelectedIndex = x;
							GetDocumentTypes();
						}
					}
				}
			}
			catch (SoapException)
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", "Serviço web indisponível");
			}
		}

		/// <summary>
		/// 
		/// </summary>
		private void GetDocumentTypes()
		{
			try
			{
				if (Configuration != null && 
					Configuration.WebServiceUrl.Length > 0 && 
					Configuration.Mailboxes.Count > 0 &&
					listBook.SelectedItem != null)
				{
					OWApi OWApi = new OWApi();
					OWApi.Url = string.Format("http://{0}",Configuration.WebServiceUrl);

					long bookId = ((ListItem)listBook.SelectedItem).Id;

					stDocumentType[] documentTypes = OWApi.GetDocumentTypesByBook(bookId);
				
					listDocumentType.Items.Clear();

					for (int x = 0; x < documentTypes.Length; x++)
					{
						listDocumentType.DisplayMember = "Text";
						listDocumentType.Items.Insert(x, new ListItem(documentTypes[x].DocumentTypeID, documentTypes[x].DocumentTypeDescription));

						if (listMailbox.SelectedItem != null && Configuration.GetDocumentTypeIdByMailboxName(listMailbox.SelectedItem.ToString()) == (int)documentTypes[x].DocumentTypeID)
						{
							listDocumentType.SelectedIndex = x;
						}
					}
				}
			}
			catch (SoapException)
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", "Serviço web indisponível");
			}
			
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listMailbox_SelectedIndexChanged(object sender, EventArgs e)
		{
			GetUsers();
			UpdateConfigurationChanges(enumMailBoxMapping.ALL);
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listUser_SelectedIndexChanged(object sender, EventArgs e)
		{
			GetBooks();
			UpdateConfigurationChanges(enumMailBoxMapping.ALL);
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listBook_SelectedIndexChanged(object sender, EventArgs e)
		{
			GetDocumentTypes();
			UpdateConfigurationChanges(enumMailBoxMapping.ALL);
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void listDocumentType_SelectedIndexChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.ALL);
		}

		/// <summary>
		/// 
		/// </summary>
		private void UpdateConfigurationChanges(enumMailBoxMapping Mba)
		{

			switch (Mba)
			{
				case enumMailBoxMapping.From :
					if (lstMailBoxConfig.SelectedIndex != -1 && cmbFrom.SelectedIndex != -1)
					{
						((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).FromDefault = ((ListItem)cmbFrom.SelectedItem).Id;
					}
					break;

				case enumMailBoxMapping.To:
					if (lstMailBoxConfig.SelectedIndex != -1 && cmbTo.SelectedIndex != -1)
					{
						((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).ToDefault = ((ListItem)cmbTo.SelectedItem).Id;
					}
					break;

				case enumMailBoxMapping.Cc:
					if (lstMailBoxConfig.SelectedIndex != -1 && cmbCc.SelectedIndex != -1)
					{
						((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).CcDefault = ((ListItem)cmbCc.SelectedItem).Id;
					}
					break;

				
				case enumMailBoxMapping.Subject :
					if (lstMailBoxConfig.SelectedIndex != -1 && cmbSubject.SelectedIndex != -1)
					{
						((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).SubjectDefault = ((ListItem)cmbSubject.SelectedItem).Id;
					}
					break;

				case enumMailBoxMapping.Body :
					if (lstMailBoxConfig.SelectedIndex != -1 && cmbBody.SelectedIndex != -1)
					{
						((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).BodyDefault = ((ListItem)cmbBody.SelectedItem).Id;
					}
					break;

				case enumMailBoxMapping.Received:
					if (lstMailBoxConfig.SelectedIndex != -1 && cmbReceive.SelectedIndex != -1)
					{
						((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).ReceivedDefault = ((ListItem)cmbReceive.SelectedItem).Id;
					}
					break;

				case enumMailBoxMapping.ALL:

					if (Configuration != null)
					{
						if (listMailbox.SelectedIndex != -1)
						{
							((OWMailConfiguration.Mailbox)Configuration.Mailboxes[listMailbox.SelectedIndex]).ExtractAttachments = chkExtractAttachments.Checked;
						}

						if (listMailbox.SelectedIndex != -1 && listUser.SelectedIndex != -1)
						{
							((OWMailConfiguration.Mailbox)Configuration.Mailboxes[listMailbox.SelectedIndex]).UserLogin = listUser.SelectedItem.ToString();
						}

						if (listMailbox.SelectedIndex != -1 && listBook.SelectedIndex != -1)
						{
							((OWMailConfiguration.Mailbox)Configuration.Mailboxes[listMailbox.SelectedIndex]).BookId = (int)((ListItem)listBook.SelectedItem).Id;
						}

						if (listMailbox.SelectedIndex != -1 && listDocumentType.SelectedIndex != -1)
						{
							((OWMailConfiguration.Mailbox)Configuration.Mailboxes[listMailbox.SelectedIndex]).DocumentTypeId = (int)((ListItem)listDocumentType.SelectedItem).Id;
						}
				
					}
					break;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnAddMailbox_Click(object sender, EventArgs e)
		{
			if (ActiveDirectoryIsAvailable())
			{
				AddMailbox addMailbox = new AddMailbox();
				addMailbox.ShowDialog(this);
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		private bool ActiveDirectoryIsAvailable()
		{
			bool available = false;
			
			try
			{
				ActiveDirectoryMailsList = GetMailsList();
				available = true;
			}
			catch (COMException)
			{
				MessageBox.Show("O servidor de Active Directory não estava disponível", "Servidor de AD indisponível");
			}

			return available;
		}
		

		
		/// <summary>
		/// 
		/// </summary>
		/// <param name="url"></param>
		/// <returns></returns>
		private bool WebServiceIsAvailable(string url)
		{
			bool available = false;
			
			WebRequest request = null;
			WebResponse response = null;
			
			try
			{
				Splasher.Show();
				url = string.Format("http://{0}",url);
				request = WebRequest.Create(url);
				response = request.GetResponse();

				if (response != null && response is HttpWebResponse && ((HttpWebResponse)response).StatusCode == HttpStatusCode.OK)
				{
					available = true;
				}
				else
				{
					Splasher.Close();
					MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", "Serviço web indisponível");
					
				}
			}
			catch (Exception)
			{
				Splasher.Close();
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks", "Serviço web indisponível");
				
			}
			Splasher.Close();
			return available;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void txtWebServiceUrl_TextChanged(object sender, EventArgs e)
		{
			if (Configuration != null)
			{
				Configuration.WebServiceUrl = txtWebServiceUrl.Text;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		private ArrayList GetMailsList()
		{
			ActiveDirectoryDomain = GetExchangeServer();// GetCurrentDomain();
			ArrayList mailsList = new ArrayList();

			try
			{
				if (ActiveDirectoryDomain.Length > 0)
				{
					ActiveDirectoryReader ad = new ActiveDirectoryReader(ActiveDirectoryDomain);
					mailsList = ad.GetValuesList("user", "mail");
					mailsList.Sort();
				}
			}
			catch (COMException ex)
			{
				throw ex;
			}

			return mailsList;
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		private string GetExchangeServer()
		{
			/*string userName = WindowsIdentity.GetCurrent().Name;
			string domain = string.Empty;
			int position = userName.IndexOf(@"\");
			
			if (position != -1)
			{
				domain = userName.Substring(0, position);
			}
			return domain;
			*/
			return Configuration.ExchangeServer;
			
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void chkExtractAttachments_CheckedChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.ALL);
		}

		/// <summary>
		/// Registers events in a mailbox found in an available Exchange Server.
		/// </summary>
		/// <param name="operation">Exchange operation type to register. See correspondant enum above for details.</param>
		/// <param name="mailbox">Mailbox name to be the event registration target.</param>
		/// <returns>TRUE if event is succefully registered, otherwise FALSE is returned.</returns>
		public bool ExchangeRegistrationProcessor(ExchangeOperation operation, string mailbox)
		{
			bool success = false;
			bool showOutput = chkShowRegistrationMessages.Checked;
			string output = string.Empty;
			
			if (mailbox.Length > 0)
			{
				string serverName = GetExchangeServer();//GetCurrentDomain();
				string[] mailboxNameParts = mailbox.Split('@');
				string mailboxName = mailboxNameParts[0];
				string fileName = "cscript.exe";
				string arguments = string.Empty;
				string message = string.Empty;
				string inbox=string.Empty; // Inbox name to connect to exchange

				string errorMessage = string.Empty;
				if (TestConnectionString(serverName, mailboxName,MailBoxType.Inbox,ref errorMessage ))
					inbox="Inbox";
				else if (TestConnectionString(serverName, mailboxName,MailBoxType.A_Receber,ref errorMessage))
					inbox="A Receber";
				else 
				{
					string er = "Não é possível ligar ao servidor de exchange (Inbox/A Receber não encontada)";
					if (chkShowRegistrationMessages.Checked)
					{
						er = string.Format("{0}\n\n{1}",er,errorMessage);
					}
					MessageBox.Show(er);
					return false;
				}

				switch (operation)
				{
					case ExchangeOperation.Create:
					{
						arguments = "//Nologo RegEvent.vbs Add OnSyncSave OfficeWorks.OWMail \"http://" + serverName + "/exchange/" + mailboxName + "/" + inbox +  "/OWMail\"";
						break;
					}
					case ExchangeOperation.Delete:
					{
						arguments = "//Nologo RegEvent.vbs Delete \"http://" + serverName + "/exchange/" + mailboxName + "/" + inbox +  "/OWMail\"";
						break;
					}
					case ExchangeOperation.List:
					{
						arguments = "//Nologo RegEvent.vbs Enum \"http://" + serverName + "/exchange/" + mailboxName + "/" + inbox + "/OWMail\"";
						break;
					}
					default:
					{
						break;
					}
				}
				
				Process process = new Process();
				process.StartInfo.FileName = fileName;
				process.StartInfo.Arguments = arguments;
				process.StartInfo.UseShellExecute = false;
				process.StartInfo.RedirectStandardOutput = true;
				process.StartInfo.CreateNoWindow = true;
				process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
				
				bool runOk = process.Start();

				if (runOk)
				{
					output = process.StandardOutput.ReadToEnd();
				}
				else
				{					
					OfficeWorksException.WriteEventLog("Error Launching Process for regEnvent.vbs");
				}
				
				if (runOk && !output.Trim().ToUpper().StartsWith("ERROR"))
				{
					switch (operation)
					{
						case ExchangeOperation.Create:
						{
							if (output.Trim().ToUpper().StartsWith("NEW EVENT BINDING CREATED"))
							{
								success = true;
							}
							else
							{
								
								OfficeWorksException.WriteEventLog("Error Registering New Event Sink:\n" + output);
							}

							message = "O evento foi registado com sucesso";
							
							if (showOutput && success)
							{
								//MessageBox.Show(message + "\n\n" + output, "Registar evento");
							}
							else if (!showOutput && success)
							{
								//MessageBox.Show(message, "Registar evento");
							}

							break;
						}
						case ExchangeOperation.Delete:
						{
							if (output.Trim().ToUpper().StartsWith("DELETING"))
							{
								success = true;
								message = "O evento foi removido com sucesso";
							}
							else if (output.Length == 0)
							{
								message = "Não existe um evento registado para a conta de correio seleccionada";
								MessageBox.Show(message, "Registar evento");
							}
							else
							{
								message = "Não foi possível registar o evento para a conta de correio seleccionada";
								MessageBox.Show(message, "Registar evento");
							}
							
							if (showOutput && success)
							{
								//MessageBox.Show(message + "\n\n" + output, "Registar evento");
							}
							else if (!showOutput && success)
							{
								//MessageBox.Show(message, "Registar evento");
							}

							break;
						}
						case ExchangeOperation.List:
						{
							if (output.Trim().ToUpper().IndexOf("OfficeWorks.OWMAIL") != -1)
							{
								success = true;
							}
							
							break;
						}
						default:
						{
							break;
						}
					}
				}
				else if (showOutput)
				{
					OfficeWorksException.WriteEventLog(string.Format("Error {0} Event Sink:\n{1}" ,operation.ToString(),output));
					MessageBox.Show("Erro ao executar a operação no servidor de Exchange\n\n" + output, "Erro no registo do evento");
				}
				else if (!showOutput)
				{
					OfficeWorksException.WriteEventLog(string.Format("Error {0} Event Sink:\n{1}" ,operation.ToString(),output));
					MessageBox.Show("Erro ao executar a operação no servidor de Exchange", "Erro no registo do evento");
				}
			}

			return success;
		}

		/// <summary>
		/// Test Connection string to Exchange Server
		/// </summary>
		/// <param name="serverName">Exchange Server</param>
		/// <param name="mailboxName">MailBox to connect</param>
		/// <param name="mbxType">Mailbox type to try connection</param>
		/// <param name="errorMessage">Error Message return when trying the connection to Mailbox</param>
		/// <returns>True if connection string is valid or false otherwise</returns>
		private bool TestConnectionString(string serverName, string mailboxName,MailBoxType mbxType, ref string errorMessage)
		{
			string ConnectionString="http://" + serverName + "/exchange/" + mailboxName + "/" + mbxType.ToString().Replace("_"," ");
			Connection Conn = new Connection();
			Recordset oRs = new Recordset();
			try
			{
				Conn.Provider = "ExOledb.Datasource";
				Conn.CommandTimeout=30;
				Conn.Open (ConnectionString, "", "", -1);
				if(Conn.State != 1) 
				{
					return false;
				}
	
				string strSql = "select ";
				strSql += " \"urn:schemas:mailheader:content-class\"";
				strSql += ", \"DAV:href\" ";
				strSql += ", \"urn:schemas:mailheader:content-class\" ";
				strSql += ", \"DAV:displayname\"";
				strSql += " from scope ('shallow traversal of " + "\"";
				strSql += ConnectionString + "\"') ";
				strSql += " WHERE \"DAV:ishidden\" = false";
				strSql += " AND \"DAV:isfolder\" = false";
	
	
				oRs.Open(strSql, Conn, 
				         CursorTypeEnum.adOpenUnspecified, 
				         LockTypeEnum.adLockOptimistic, 1);
				return true;
			}
			catch (Exception ex)
			{				
				errorMessage = ex.Message;
				return false;
			}
			finally
			{
				if (oRs!=null && (ConnectionState)oRs.State==ConnectionState.Open)
					oRs.Close();
				if (Conn!=null && (ConnectionState)Conn.State==ConnectionState.Open)
					Conn.Close();
				oRs=null;
				Conn = null;
			}			
		}

		private void txtWebServiceUrl_Validating(object sender, CancelEventArgs e)
		{
			
			if (txtWebServiceUrl.Text.Length != 0)
			{
				if (!WebServiceIsAvailable(txtWebServiceUrl.Text.Trim()))
				{
					e.Cancel = true;
				} 
				else 
				{
					configuration.WebServiceUrl = txtWebServiceUrl.Text.Trim();
				}
			}
			else
			{
				MessageBox.Show("Não foi possível contactar o serviço web do OfficeWorks\n Campo não preenchido", "Serviço web indisponível");
				e.Cancel = true;
			}
			
		}

		private void btnFindDirTemp_Click(object sender, EventArgs e)
		{
			FolderBrowserDialog folder = new FolderBrowserDialog();
			
			if (folder.ShowDialog() == DialogResult.OK)
			{
				txtTempDirectoryPath.Text = folder.SelectedPath;
				Configuration.TempDirectoryPath = folder.SelectedPath;
			}
		}
		/// <summary>
		/// Guarda os valores das ComboBox no XML para configurações futuras.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnDefault_Click(object sender, EventArgs e)
		{
			setAllComboBox();
		}

		private void lstMailBoxConfig_SelectedIndexChanged(object sender, EventArgs e)
		{

			
			//MailboxName
			FindByValue(cmbFrom,((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).FromDefault);
			FindByValue(cmbTo,((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).ToDefault);
			FindByValue(cmbCc,((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).CcDefault);
			FindByValue(cmbSubject,((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).SubjectDefault);
			FindByValue(cmbBody,((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).BodyDefault);
			FindByValue(cmbReceive,((OWMailConfiguration.Mailbox)Configuration.Mailboxes[lstMailBoxConfig.SelectedIndex]).ReceivedDefault);
		
		}

		private void cmbFrom_SelectedIndexChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.From);
		}

		private void cmbTo_SelectedIndexChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.To);
		}

		private void cmbCc_SelectedIndexChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.Cc);
		}
		
		private void cmbSubject_SelectedIndexChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.Subject);
		}

		private void cmbBody_SelectedIndexChanged(object sender, EventArgs e)
		{
			
			UpdateConfigurationChanges(enumMailBoxMapping.Body);
		}

		private void cmbReceive_SelectedIndexChanged(object sender, EventArgs e)
		{
			UpdateConfigurationChanges(enumMailBoxMapping.Received);
		}

		private void txtExchange_Validating(object sender, System.ComponentModel.CancelEventArgs e)
		{
			Configuration.ExchangeServer = txtExchange.Text;
		}

		

	}
	/// <summary>
	/// Mailbox type.
	/// </summary>
	public enum MailBoxType
	{
		A_Receber,
		Inbox
	}

	

	

	/// <summary>
	/// OWMail 2.0 Administrator possible operation state modes.
	/// </summary>
	public enum OperationMode
	{
		Idle,	// No valid file is currently selected
		Edit,	// An existing valid file is beeing edited
		New		// A new blank file is beeing edited
	}

	/// <summary>
	/// Exchange Server possible operation state modes.
	/// </summary>
	public enum ExchangeOperation
	{
		Create,	// Creates a new event registration
		Delete,	// Deletes an existing event registration
		List	// Lists all registered events
	}


}
