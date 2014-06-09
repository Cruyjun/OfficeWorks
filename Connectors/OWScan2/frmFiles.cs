using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net;
using System.Security.Principal;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using AxSHDocVw;
using Microsoft.Web.Services2.Dime;
using OWScan.OWApiNS;

namespace OWScan {
	/// <summary>
	/// Summary description for frmFiles.
	/// </summary>
	public class frmFiles : Form {
		private Panel panel1;
		private Panel panel2;
		private PictureBox pictureBox2;
		private ComboBox drpBooks;
		private ListBox lstFiles;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private Container components = null;

		public static string InitDirectory = String.Empty;
		public static string strUrlOfficeWorks = String.Empty;
		public static string strUrlWebService = String.Empty;
		public static string strSubject = String.Empty;

		public static bool bUseProxy = false;
		public static string strProxyUrl = String.Empty;
		public static string strProxyUser = String.Empty;
		public static string strProxyUserPass = String.Empty;
		public static string strProxyDomain = String.Empty;

		private string strUserName;

		private string strFilePath = String.Empty;
		private ArrayList arrFiles;
		private Label label2;
		private bool bDontFireEvent = false;
		private Image imgPreview;
		private Panel panel3;
		private Button btnMagnify;
		private Button btnExit;
		private Button btnConfig;
		private Button btnRegister;
		private Splitter splitter1;
		private TabControl tabControl1;
		private TabPage tabPageDoc;
		private TabPage tabPageReg;
		public PictureBox picPreview;
		private AxWebBrowser axWebBrowser1;
		private object oTemp;

		public frmFiles() {
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
		protected override void Dispose(bool disposing) {
			if(disposing) {
				if(components != null) {
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent() {
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(frmFiles));
			this.panel1 = new System.Windows.Forms.Panel();
			this.pictureBox2 = new System.Windows.Forms.PictureBox();
			this.panel2 = new System.Windows.Forms.Panel();
			this.panel3 = new System.Windows.Forms.Panel();
			this.btnMagnify = new System.Windows.Forms.Button();
			this.btnExit = new System.Windows.Forms.Button();
			this.btnConfig = new System.Windows.Forms.Button();
			this.btnRegister = new System.Windows.Forms.Button();
			this.label2 = new System.Windows.Forms.Label();
			this.drpBooks = new System.Windows.Forms.ComboBox();
			this.lstFiles = new System.Windows.Forms.ListBox();
			this.splitter1 = new System.Windows.Forms.Splitter();
			this.tabControl1 = new System.Windows.Forms.TabControl();
			this.tabPageDoc = new System.Windows.Forms.TabPage();
			this.picPreview = new System.Windows.Forms.PictureBox();
			this.tabPageReg = new System.Windows.Forms.TabPage();
			this.axWebBrowser1 = new AxSHDocVw.AxWebBrowser();
			this.panel1.SuspendLayout();
			this.panel2.SuspendLayout();
			this.panel3.SuspendLayout();
			this.tabControl1.SuspendLayout();
			this.tabPageDoc.SuspendLayout();
			this.tabPageReg.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.axWebBrowser1)).BeginInit();
			this.SuspendLayout();
			// 
			// panel1
			// 
			this.panel1.BackColor = System.Drawing.Color.Black;
			this.panel1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("panel1.BackgroundImage")));
			this.panel1.Controls.Add(this.pictureBox2);
			this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
			this.panel1.Location = new System.Drawing.Point(0, 0);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(704, 72);
			this.panel1.TabIndex = 0;
			// 
			// pictureBox2
			// 
			this.pictureBox2.BackColor = System.Drawing.Color.White;
			this.pictureBox2.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox2.Image")));
			this.pictureBox2.Location = new System.Drawing.Point(0, 0);
			this.pictureBox2.Name = "pictureBox2";
			this.pictureBox2.Size = new System.Drawing.Size(288, 72);
			this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			this.pictureBox2.TabIndex = 0;
			this.pictureBox2.TabStop = false;
			// 
			// panel2
			// 
			this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
			this.panel2.Controls.Add(this.panel3);
			this.panel2.Controls.Add(this.label2);
			this.panel2.Controls.Add(this.drpBooks);
			this.panel2.Dock = System.Windows.Forms.DockStyle.Bottom;
			this.panel2.Location = new System.Drawing.Point(0, 477);
			this.panel2.Name = "panel2";
			this.panel2.Size = new System.Drawing.Size(704, 56);
			this.panel2.TabIndex = 1;
			// 
			// panel3
			// 
			this.panel3.Controls.Add(this.btnMagnify);
			this.panel3.Controls.Add(this.btnExit);
			this.panel3.Controls.Add(this.btnConfig);
			this.panel3.Controls.Add(this.btnRegister);
			this.panel3.Dock = System.Windows.Forms.DockStyle.Right;
			this.panel3.Location = new System.Drawing.Point(340, 0);
			this.panel3.Name = "panel3";
			this.panel3.Size = new System.Drawing.Size(360, 52);
			this.panel3.TabIndex = 27;
			// 
			// btnMagnify
			// 
			this.btnMagnify.Cursor = System.Windows.Forms.Cursors.Default;
			this.btnMagnify.Enabled = false;
			this.btnMagnify.Image = ((System.Drawing.Image)(resources.GetObject("btnMagnify.Image")));
			this.btnMagnify.ImageAlign = System.Drawing.ContentAlignment.BottomCenter;
			this.btnMagnify.Location = new System.Drawing.Point(96, 16);
			this.btnMagnify.Name = "btnMagnify";
			this.btnMagnify.Size = new System.Drawing.Size(75, 24);
			this.btnMagnify.TabIndex = 30;
			this.btnMagnify.TabStop = false;
			this.btnMagnify.Click += new System.EventHandler(this.btnMagnify_Click);
			// 
			// btnExit
			// 
			this.btnExit.Location = new System.Drawing.Point(280, 16);
			this.btnExit.Name = "btnExit";
			this.btnExit.TabIndex = 29;
			this.btnExit.TabStop = false;
			this.btnExit.Text = "Sair";
			this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
			// 
			// btnConfig
			// 
			this.btnConfig.Location = new System.Drawing.Point(192, 16);
			this.btnConfig.Name = "btnConfig";
			this.btnConfig.TabIndex = 28;
			this.btnConfig.TabStop = false;
			this.btnConfig.Text = "Configurar";
			this.btnConfig.Click += new System.EventHandler(this.btnConfig_Click);
			// 
			// btnRegister
			// 
			this.btnRegister.Location = new System.Drawing.Point(8, 16);
			this.btnRegister.Name = "btnRegister";
			this.btnRegister.TabIndex = 27;
			this.btnRegister.TabStop = false;
			this.btnRegister.Text = "Registar";
			this.btnRegister.Click += new System.EventHandler(this.btnRegister_Click);
			// 
			// label2
			// 
			this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.label2.Location = new System.Drawing.Point(8, 16);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(32, 16);
			this.label2.TabIndex = 25;
			this.label2.Text = "Livro:";
			// 
			// drpBooks
			// 
			this.drpBooks.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.drpBooks.Location = new System.Drawing.Point(48, 16);
			this.drpBooks.Name = "drpBooks";
			this.drpBooks.Size = new System.Drawing.Size(232, 21);
			this.drpBooks.TabIndex = 5;
			this.drpBooks.TabStop = false;
			// 
			// lstFiles
			// 
			this.lstFiles.Dock = System.Windows.Forms.DockStyle.Left;
			this.lstFiles.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawFixed;
			this.lstFiles.Location = new System.Drawing.Point(0, 72);
			this.lstFiles.Name = "lstFiles";
			this.lstFiles.Size = new System.Drawing.Size(280, 394);
			this.lstFiles.TabIndex = 2;
			this.lstFiles.DrawItem += new System.Windows.Forms.DrawItemEventHandler(this.lstFiles_DrawItem);
			this.lstFiles.SelectedIndexChanged += new System.EventHandler(this.lstFiles_SelectedIndexChanged);
			// 
			// splitter1
			// 
			this.splitter1.Location = new System.Drawing.Point(280, 72);
			this.splitter1.Name = "splitter1";
			this.splitter1.Size = new System.Drawing.Size(3, 405);
			this.splitter1.TabIndex = 7;
			this.splitter1.TabStop = false;
			// 
			// tabControl1
			// 
			this.tabControl1.Controls.Add(this.tabPageDoc);
			this.tabControl1.Controls.Add(this.tabPageReg);
			this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.tabControl1.Location = new System.Drawing.Point(283, 72);
			this.tabControl1.Name = "tabControl1";
			this.tabControl1.SelectedIndex = 0;
			this.tabControl1.Size = new System.Drawing.Size(421, 405);
			this.tabControl1.TabIndex = 8;
			this.tabControl1.TabStop = false;
			// 
			// tabPageDoc
			// 
			this.tabPageDoc.BackColor = System.Drawing.Color.White;
			this.tabPageDoc.Controls.Add(this.picPreview);
			this.tabPageDoc.Location = new System.Drawing.Point(4, 22);
			this.tabPageDoc.Name = "tabPageDoc";
			this.tabPageDoc.Size = new System.Drawing.Size(413, 379);
			this.tabPageDoc.TabIndex = 0;
			this.tabPageDoc.Text = "Documento";
			// 
			// picPreview
			// 
			this.picPreview.BackColor = System.Drawing.Color.White;
			this.picPreview.Dock = System.Windows.Forms.DockStyle.Fill;
			this.picPreview.Location = new System.Drawing.Point(0, 0);
			this.picPreview.Name = "picPreview";
			this.picPreview.Size = new System.Drawing.Size(413, 379);
			this.picPreview.TabIndex = 7;
			this.picPreview.TabStop = false;
			// 
			// tabPageReg
			// 
			this.tabPageReg.BackColor = System.Drawing.Color.White;
			this.tabPageReg.Controls.Add(this.axWebBrowser1);
			this.tabPageReg.Location = new System.Drawing.Point(4, 22);
			this.tabPageReg.Name = "tabPageReg";
			this.tabPageReg.Size = new System.Drawing.Size(413, 379);
			this.tabPageReg.TabIndex = 1;
			this.tabPageReg.Text = "Registo";
			// 
			// axWebBrowser1
			// 
			this.axWebBrowser1.ContainingControl = this;
			this.axWebBrowser1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.axWebBrowser1.Enabled = true;
			this.axWebBrowser1.Location = new System.Drawing.Point(0, 0);
			this.axWebBrowser1.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axWebBrowser1.OcxState")));
			this.axWebBrowser1.Size = new System.Drawing.Size(413, 379);
			this.axWebBrowser1.TabIndex = 8;
			// 
			// frmFiles
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(704, 533);
			this.Controls.Add(this.tabControl1);
			this.Controls.Add(this.splitter1);
			this.Controls.Add(this.lstFiles);
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.panel2);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "frmFiles";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "OWScan";
			this.Resize += new System.EventHandler(this.frmFiles_Resize);
			this.Load += new System.EventHandler(this.frmFiles_Load);
			this.Closed += new System.EventHandler(this.frmFiles_Closed);
			this.panel1.ResumeLayout(false);
			this.panel2.ResumeLayout(false);
			this.panel3.ResumeLayout(false);
			this.tabControl1.ResumeLayout(false);
			this.tabPageDoc.ResumeLayout(false);
			this.tabPageReg.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.axWebBrowser1)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		private static void Main() {
			Application.Run(new frmFiles());
		}

		private void frmFiles_Load(object sender, EventArgs e) {
			try {
				//Parametros de configuração
				ReadConfigFromXML();

				//Lista imagens da pasta seleccionada
				if(InitDirectory == String.Empty) {
					InitDirectory = @"C:\";
				}
				LoadFiles();

				//Utilizador do windows
				strUserName = WindowsIdentity.GetCurrent().Name.ToString();

				//Obtém os livros do utilizador pelo WebService
				getBooks();

				Application.DoEvents();
			}
			catch(Exception ex) {
				MessageBox.Show("Erro na listagem dos ficheiros.\n\n" + ex.Message, "OWScan", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		/// <summary>
		/// Return all books for the current user.
		/// </summary>
		public void getBooks() {
			try {
				//Instancia o web service
				OWApi oWS = new OWApi();
				oWS.Url = strUrlWebService;
				oWS.Credentials = System.Net.CredentialCache.DefaultCredentials;

				//Configura o proxy
				if(bUseProxy) {
					oWS.Proxy = GetWebProxy();
				}

				//Obtém os livros
				stBook[] sB = oWS.GetBook(strUserName, 4);

				oWS.Dispose();

				//Preenche a lista
				DataTable oTbl = new DataTable();
				oTbl.Columns.AddRange(new DataColumn[]{new DataColumn("Id"), new DataColumn("Livro")});

				foreach(stBook book in sB) {
					oTbl.Rows.Add(new object[]{book.BookID.ToString(), book.BookAbreviation.ToString() + " - " + book.BookDescription.ToString()});
				}

				drpBooks.DataSource = oTbl;
				drpBooks.ValueMember = "Id";
				drpBooks.DisplayMember = "Livro";
				if(!btnRegister.Enabled) {
					btnRegister.Enabled = true;
				}
			}
			catch(Exception ex) {
				MessageBox.Show("Não tem permissões para registar em nenhum livro.\n\n" + ex.Message, "OWScan", MessageBoxButtons.OK, MessageBoxIcon.Error);
				btnRegister.Enabled = false;
			}
		}

		/// <summary>
		/// Get proxy for webrequests
		/// </summary>
		/// <returns></returns>
		public static WebProxy GetWebProxy() {
			try {
				//Get proxy url
				string proxyUrl = strProxyUrl;
				//Get User credentials for proxy
				string proxyUser = strProxyUser;
				string proxyUserPass = strProxyUserPass;
				string proxyDomain = strProxyDomain;

				//Create proxy object
				WebProxy proxyObject = new WebProxy(proxyUrl, true);
				//Set proxy credentials
				proxyObject.Credentials = new NetworkCredential(proxyUser, proxyUserPass, proxyDomain);
				//Set sgp webservice proxy				
				return proxyObject;
			}
			catch {}
			WebProxy webProxy = new WebProxy();
			return webProxy;
		} // GetWebProxy

//		/// <summary>
//		/// Upload the document via the WebService
//		/// </summary>
//		public void uploadFilex(string strPath, string strFileToUpload) {
//			//Instancia o proxy do web service
//			UploadFileAttachment oProxy = new UploadFileAttachment(strUrlWebService);
//
//			//Anexa o ficheiro
//			oProxy.RequestSoapContext.Attachments.Add(GetFileAsAttachment(strPath + @"\" + strFileToUpload));
//			oProxy.RequestSoapContext.Attachments[0].Id = strFileToUpload;
//
//			//Envia-o
//			string strRes = oProxy.UploadFile();
//			oProxy.Dispose();
//
//			//Regista o documento
//			registerFile(strRes, strFileToUpload);
//		}

		private DimeAttachment GetFileAsAttachment(string FullPath) {
			FileStream stream = File.OpenRead(FullPath);
			DimeAttachment attach = new DimeAttachment("0", TypeFormat.MediaType, stream);
			return attach;
		}

		/// <summary>
		/// Register the document
		/// </summary>
		private void registerFile(string strPath, string strFileToUpload) {
			try {
				//Instancia o web service
				
				OWApi oWS = new OWApi();
				oWS.Url = strUrlWebService;
				oWS.Credentials = System.Net.CredentialCache.DefaultCredentials;

				//Inicializa a estrutura com o ficheiro a registar
				stRegistry RegistryST = MappOfficeWorksData(strPath, strFileToUpload);

				//Insere o registo
				long lReg_ID = oWS.InsertRegistry(strUserName, "", ref RegistryST);

				//Abre o browser em modo de alteração
				OpenUpdateRegistry(lReg_ID);

				//Apaga o ficheiro local
				if(lReg_ID > 0) {
					DeleteRegistryFile(strPath, strFileToUpload);
				}

				oWS.Dispose();
			}
			catch(Exception ex) {
				MessageBox.Show("Erro a registar o ficheiro no OW.Net: " + ex.Message, "OWScan", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
		}

		private stRegistry MappOfficeWorksData(string strPath, string strFileToUpload) {
			stRegistry RegistryST = new stRegistry();

			RegistryST.Book = new stBook();
			//ArrayList oDynamicFields = new ArrayList(); // ArrayList Aux
			RegistryST.Classification = new stClassification();
			RegistryST.Entity = new stEntity();
			RegistryST.User = new stUser();
			RegistryST.DocumentType = new stDocumentType();

			//Set Book ID
			RegistryST.Book.BookID = Convert.ToInt64(drpBooks.SelectedValue.ToString());

			//Set User login
			RegistryST.User.UserLogin = strUserName;

			//Create a new File struct
			stFile oFile = new stFile();
			//Convert File to byte Array
			oFile.FileArray = FileToArray(strPath + @"\" + strFileToUpload);
			//Get File Path
			oFile.FilePath = strPath + @"\" + strFileToUpload;
			//Get File Name
			oFile.FileName = strFileToUpload;
			//Attach the file
			RegistryST.Files = new stFile[1];
			RegistryST.Files[0] = oFile;

			//Estado
			//stDynamicField NewDynamic = new stDynamicField();
			//NewDynamic.DynamicFieldID = Convert.ToInt64(oMapp.FieldIdentifier);
			//NewDynamic.DynamicFieldName = oMapp.FieldName;
			//NewDynamic.DynamicFieldValue = oMData.Data;
			//oDynamicFields.Add(NewDynamic);

			RegistryST.Subject = strSubject;

			return RegistryST;
		}

		/// <summary>
		/// Convert a File by giving it´s Path to a byte array 
		/// </summary>
		/// <param name="FilePath">File Path</param>
		/// <returns></returns>
		private byte[] FileToArray(string FilePath) {
			//Open the File 						
			FileStream oFile = File.Open(FilePath, FileMode.Open, FileAccess.Read, FileShare.Read);
			//Create a buffer
			byte[] bFile = new byte[oFile.Length];
			//Read File
			oFile.Read(bFile, 0, (int)oFile.Length);
			//Close file
			oFile.Close();
			//Return file array	
			return bFile;
		}

		/// <summary>
		/// Launch the browser in update mode
		/// </summary>
		private void OpenUpdateRegistry(long lReg_ID) {
			//Lança o browser
			//System.Diagnostics.Process.Start(strUrlOfficeWorks + @"/Register/UpdateRegister.aspx?ID=" + lReg_ID.ToString());

			//Abre o html temporário para post dos parametros
			string strHTML = Application.StartupPath + @"\autoRegist.html";
			StreamWriter st = new StreamWriter(strHTML, false);
			st.WriteLine(@"<HTML>");
			st.WriteLine(@"<HEAD>");
			st.WriteLine(@"<TITLE></TITLE>");
			st.WriteLine(@"</HEAD>");
			st.WriteLine(@"<FRAMESET name=""frmMain0"" id=""frmMain0"" border=""0"" frameSpacing=0 rows=""0, *"" frameBorder=""0"">");
			st.WriteLine(@"<FRAME name=""top"" marginWidth=""0"" marginHeight=""0"" scrolling=""no"">");
			st.WriteLine(@"<FRAMESET name=""frmMain"" id=""frmMain"" border=""0"" frameSpacing=""0"" cols=""0, *"" frameBorder=""0"">");
			st.WriteLine(@"<FRAME name=""banner"" marginWidth=""0"" marginHeight=""0"" scrolling=""no"">");
			st.WriteLine(@"<FRAME name=""main"" marginHeight=""0"" marginwidth=""40"" src=""" + strUrlOfficeWorks + @"/Register/UpdateRegister.aspx?owscan=1&ID=" + lReg_ID.ToString() + @""" noResize scrolling=""yes"">");
			st.WriteLine(@"</FRAMESET>");
			st.WriteLine(@"</FRAMESET>");
			st.WriteLine(@"</HTML>");
			st.Close();

			object obj = null;
			axWebBrowser1.Navigate(strHTML,ref obj,ref obj,ref obj,ref obj);

			//axWebBrowser1.Navigate(strUrlOfficeWorks + @"/Register/UpdateRegister.aspx?owscan=1&ID=" + lReg_ID.ToString());

			tabControl1.SelectedIndex = 1;
		}

		private void DeleteRegistryFile(string l_strPath, string l_strFileToUpload) {
			string l_strFilePath = l_strPath + @"\" + l_strFileToUpload;

			bDontFireEvent = true;
			File.SetAttributes(l_strFilePath, FileAttributes.Normal);
			lstFiles.ClearSelected();
			lstFiles.Items.Clear();
			imgPreview.Dispose();
			//picPreview.Image = null;
			Application.DoEvents();
			//File.Delete(l_strFilePath);

			//Verifica se a pasta temporária existe; se não cria-a
			DirectoryInfo di = new DirectoryInfo(l_strPath + @"\temp");
			if(!di.Exists) {
				di.Create();
			}
			if(File.Exists(l_strPath + @"\temp\" + l_strFileToUpload)) {
				File.Delete(l_strPath + @"\temp\" + l_strFileToUpload);
			}
			Application.DoEvents();
			File.Move(l_strFilePath, l_strPath + @"\temp\" + l_strFileToUpload);
			Application.DoEvents();
			if(picPreview.Image != null) {
				imgPreview = new Bitmap(l_strPath + @"\temp\" + l_strFileToUpload);
			}

			LoadFiles();
			lstFiles.SelectedItem = null;
			lstFiles.SelectedIndex = -1;
			bDontFireEvent = false;
		}

		private void btnExit_Click(object sender, EventArgs e) {
			this.Close();
		}

		private void lstFiles_SelectedIndexChanged(object sender, EventArgs e) {
			if(!bDontFireEvent) {
				try {
					//picPreview.Visible = true;
					//axWebBrowser1.Visible = false;
					tabControl1.SelectedIndex = 0;

					if((File.GetAttributes(InitDirectory + @"\" + lstFiles.SelectedItem) &
						FileAttributes.Hidden) == FileAttributes.Hidden) {
						MessageBox.Show("O ficheiro seleccionado está em utilização.", "OWScan", MessageBoxButtons.OK, MessageBoxIcon.Warning);
						bDontFireEvent = true;
						lstFiles.SelectedItem = oTemp;
						bDontFireEvent = false;
						return;
					}

					oTemp = lstFiles.SelectedItem;

					if(strFilePath != String.Empty && File.Exists(strFilePath)) {
						File.SetAttributes(strFilePath, FileAttributes.Normal);
					}
					strFilePath = InitDirectory + @"\" + lstFiles.SelectedItem;
					File.SetAttributes(strFilePath, FileAttributes.Hidden);

					//Preview da imagem
					imgPreview = new Bitmap(strFilePath);
					int h = picPreview.Height;
					int w = imgPreview.Width * picPreview.Height / imgPreview.Height;
					picPreview.Image = new Bitmap(imgPreview, w, h);
					picPreview.Refresh();
					if(!btnMagnify.Enabled) {
						btnMagnify.Enabled = true;
					}

					LoadFiles();
					bDontFireEvent = true;
					lstFiles.SelectedItem = oTemp;
					bDontFireEvent = false;
				}
				catch {
					picPreview.Image = null;
					Process.Start(InitDirectory + @"\" + lstFiles.SelectedItem);
				}
			}

		}

		public void LoadFiles() {
			arrFiles = new ArrayList();
			string searchPattern = "*.*";

			DirectoryInfo di = new DirectoryInfo(InitDirectory);
			lstFiles.Items.Clear();

			if(di.Exists) {
				// Get Files 
				GetFiles(di, searchPattern, ref arrFiles);

				//List Files 
				foreach(string s in arrFiles) {
					lstFiles.Items.Add(s);
				}
			}

		}

		private void GetFiles(DirectoryInfo di, string searchPattern, ref ArrayList MyFiles) {
			string strFileExtension = String.Empty;

			foreach(FileInfo fi in di.GetFiles(searchPattern)) {
				strFileExtension = Path.GetExtension(fi.Name).ToLower();
				if(strFileExtension == ".jpg" ||
					strFileExtension == ".gif" ||
					strFileExtension == ".tif" ||
					strFileExtension == ".bmp" ||
					strFileExtension == ".png") {
					MyFiles.Add(fi.Name);
				}
			}
			// Search in subdirectories 
			//foreach(DirectoryInfo d in di.GetDirectories()) 
			//{ 
			//	GetFiles(d,searchPattern,ref MyFiles); 
			//} 
		}

		private void lstFiles_DrawItem(object sender, DrawItemEventArgs e) {
			//
			// Draw the background of the ListBox control for each item.
			// Create a new Brush and initialize to a Black colored brush by default.
			//
			e.DrawBackground();
			Brush myBrush = Brushes.Black;
			//
			// Determine the color of the brush to draw each item based on 
			// the index of the item to draw.
			//
			if(e.Index >= 0) {
				if((File.GetAttributes(InitDirectory + @"\" + arrFiles[e.Index].ToString()) &
					FileAttributes.Hidden) == FileAttributes.Hidden) {
					myBrush = Brushes.Red;
				}
				else {
					myBrush = Brushes.Black;
				}
				//
				// Draw the current item text based on the current Font and the custom brush settings.
				//
				e.Graphics.DrawString(((ListBox)sender).Items[e.Index].ToString(),
				                      e.Font, myBrush, e.Bounds, StringFormat.GenericDefault);

			}
			//
			// If the ListBox has focus, draw a focus rectangle around the selected item.
			//
			e.DrawFocusRectangle();
		}

		private void btnRegister_Click(object sender, EventArgs e) {
			if(lstFiles.SelectedIndex < 0) {
				MessageBox.Show("Por favor indique o ficheiro a registar.", "OWScan", MessageBoxButtons.OK, MessageBoxIcon.Information);
				return;
			}

			//TESTE
			//Form1 oform = new Form1();
			//oform.ShowDialog(this);

			//Regista o documento no OW.Net
			registerFile(InitDirectory, lstFiles.SelectedItem.ToString());
		}

		private void btnConfig_Click(object sender, EventArgs e) {
			frmOptions oform = new frmOptions(this);
			oform.ShowDialog(this);
		}

		/// <summary>
		/// Store configuration data in a xml file
		/// </summary>
		public static void WriteConfigToXML() {
			XmlTextWriter writer = new XmlTextWriter(Application.StartupPath + @"\Config.xml", Encoding.UTF8);

			//Use automatic indentation for readability.
			writer.Formatting = Formatting.Indented;

			//Write the root element
			writer.WriteStartElement("opcoes");

			//add sub-elements
			writer.WriteElementString("pasta", InitDirectory);
			writer.WriteElementString("OfficeWorks", strUrlOfficeWorks);
			writer.WriteElementString("webservice", strUrlWebService);
			writer.WriteElementString("assunto", strSubject);

			writer.WriteElementString("useProxy", bUseProxy.ToString());
			writer.WriteElementString("proxyUrl", strProxyUrl);
			writer.WriteElementString("proxyUser", strProxyUser);
			writer.WriteElementString("proxyUserPass", Crypt.Encrypt(strProxyUserPass, "DFG$W%&)%$&U!#$"));
			writer.WriteElementString("proxyDomain", strProxyDomain);

			// end the root element
			writer.WriteFullEndElement();

			//Write the XML to file and close the writer
			writer.Close();
		}

		/// <summary>
		/// Read configuration data from a xml file
		/// </summary>
		private static void ReadConfigFromXML() {
			try {
				XmlTextReader reader = new XmlTextReader(Application.StartupPath + @"\Config.xml");
				reader.ReadStartElement("opcoes");

				InitDirectory = reader.ReadElementString("pasta").ToString();
				strUrlOfficeWorks = reader.ReadElementString("OfficeWorks").ToString();
				strUrlWebService = reader.ReadElementString("webservice").ToString();
				strSubject = reader.ReadElementString("assunto").ToString();

				bUseProxy = Convert.ToBoolean(reader.ReadElementString("useProxy").ToString());
				strProxyUrl = reader.ReadElementString("proxyUrl").ToString();
				strProxyUser = reader.ReadElementString("proxyUser").ToString();
				strProxyUserPass = Crypt.Decrypt(reader.ReadElementString("proxyUserPass").ToString(), "DFG$W%&)%$&U!#$");
				strProxyDomain = reader.ReadElementString("proxyDomain").ToString();

				reader.Close();
			}
			catch {}
		}

		private void btnMagnify_Click(object sender, EventArgs e) {
			if(btnMagnify.Enabled && picPreview.Image != null) {
				/*				frmPreview oform = new frmPreview();
				oform.picPreview.Image = imgPreview;
				oform.picPreview.Width = imgPreview.Width;
				oform.picPreview.Height = imgPreview.Height;
				oform.ShowDialog(this);
*/
				Process.Start(InitDirectory + @"\" + lstFiles.SelectedItem);
			}

		}

		private void frmFiles_Resize(object sender, EventArgs e) {
			if(lstFiles.SelectedIndex >= 0) {
				int h = picPreview.Height;
				int w = imgPreview.Width * picPreview.Height / imgPreview.Height;
				picPreview.Image = new Bitmap(imgPreview, w, h);
				picPreview.Refresh();
			}
		}

		private void frmFiles_Closed(object sender, EventArgs e) {
			try {
				imgPreview.Dispose();

				if(File.Exists(InitDirectory + @"\" + lstFiles.SelectedItem)) {
					if((File.GetAttributes(InitDirectory + @"\" + lstFiles.SelectedItem) &
						FileAttributes.Hidden) == FileAttributes.Hidden) {
						File.SetAttributes(InitDirectory + @"\" + lstFiles.SelectedItem, FileAttributes.Normal);
					}
				}

				DirectoryInfo di = new DirectoryInfo(InitDirectory + @"\temp");
				if(di.Exists) {
					foreach(FileInfo fi in di.GetFiles("*.*")) {
						fi.Delete();
					}
				}
			}
			catch {}
			finally {
				Application.Exit();
			}
		}
	}
}