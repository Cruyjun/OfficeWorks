using System;
using System.ComponentModel;
using System.Windows.Forms;

namespace OWScan {
	/// <summary>
	/// Summary description for frmOptions.
	/// </summary>
	public class frmOptions : Form {
		private Label label1;
		private TextBox txtUrlOfficeWorks;
		private TextBox txtUrlWS;
		private Label label2;
		private Button btnCancel;
		private Button btnOK;
		private Label label3;
		private TextBox txtSubject;
		private Button btnChangeFolder;
		private TextBox txtFolder;
		private Label label4;
		private FolderBrowserDialog folderBrowserDialog1;
		private frmFiles l_obj;
		private Label label5;
		private TextBox txtProxyURL;
		private TextBox txtProxyUser;
		private Label label6;
		private Label label7;
		private TextBox txtProxyDomain;
		private Label label8;
		private TextBox txtProxyUserPass;
		private CheckBox chkUseProxy;
		private GroupBox groupBoxProxy;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private Container components = null;

		public frmOptions(frmFiles obj) {
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			l_obj = obj;
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(frmOptions));
			this.label1 = new System.Windows.Forms.Label();
			this.txtUrlOfficeWorks = new System.Windows.Forms.TextBox();
			this.txtUrlWS = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.btnCancel = new System.Windows.Forms.Button();
			this.btnOK = new System.Windows.Forms.Button();
			this.txtSubject = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.btnChangeFolder = new System.Windows.Forms.Button();
			this.txtFolder = new System.Windows.Forms.TextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
			this.groupBoxProxy = new System.Windows.Forms.GroupBox();
			this.txtProxyURL = new System.Windows.Forms.TextBox();
			this.label5 = new System.Windows.Forms.Label();
			this.txtProxyUser = new System.Windows.Forms.TextBox();
			this.label6 = new System.Windows.Forms.Label();
			this.txtProxyUserPass = new System.Windows.Forms.TextBox();
			this.label7 = new System.Windows.Forms.Label();
			this.txtProxyDomain = new System.Windows.Forms.TextBox();
			this.label8 = new System.Windows.Forms.Label();
			this.chkUseProxy = new System.Windows.Forms.CheckBox();
			this.groupBoxProxy.SuspendLayout();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(24, 16);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(112, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "Endereço do OfficeWorks";
			// 
			// txtUrlOfficeWorks
			// 
			this.txtUrlOfficeWorks.Location = new System.Drawing.Point(168, 16);
			this.txtUrlOfficeWorks.Name = "txtUrlOfficeWorks";
			this.txtUrlOfficeWorks.Size = new System.Drawing.Size(312, 20);
			this.txtUrlOfficeWorks.TabIndex = 0;
			this.txtUrlOfficeWorks.Text = "";
			// 
			// txtUrlWS
			// 
			this.txtUrlWS.Location = new System.Drawing.Point(168, 45);
			this.txtUrlWS.Name = "txtUrlWS";
			this.txtUrlWS.Size = new System.Drawing.Size(312, 20);
			this.txtUrlWS.TabIndex = 1;
			this.txtUrlWS.Text = "";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(24, 45);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(136, 16);
			this.label2.TabIndex = 2;
			this.label2.Text = "Endereço do Web Service";
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(408, 336);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.TabIndex = 6;
			this.btnCancel.Text = "C&ancelar";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnOK
			// 
			this.btnOK.Location = new System.Drawing.Point(320, 336);
			this.btnOK.Name = "btnOK";
			this.btnOK.TabIndex = 5;
			this.btnOK.Text = "&Confirmar";
			this.btnOK.Click += new System.EventHandler(this.btnOK_Click);
			// 
			// txtSubject
			// 
			this.txtSubject.Location = new System.Drawing.Point(168, 74);
			this.txtSubject.Name = "txtSubject";
			this.txtSubject.Size = new System.Drawing.Size(312, 20);
			this.txtSubject.TabIndex = 2;
			this.txtSubject.Text = "";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(24, 74);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(136, 16);
			this.label3.TabIndex = 25;
			this.label3.Text = "Assunto do Registo";
			// 
			// btnChangeFolder
			// 
			this.btnChangeFolder.Cursor = System.Windows.Forms.Cursors.Hand;
			this.btnChangeFolder.Image = ((System.Drawing.Image)(resources.GetObject("btnChangeFolder.Image")));
			this.btnChangeFolder.ImageAlign = System.Drawing.ContentAlignment.BottomCenter;
			this.btnChangeFolder.Location = new System.Drawing.Point(448, 104);
			this.btnChangeFolder.Name = "btnChangeFolder";
			this.btnChangeFolder.Size = new System.Drawing.Size(32, 24);
			this.btnChangeFolder.TabIndex = 4;
			this.btnChangeFolder.Click += new System.EventHandler(this.btnChangeFolder_Click);
			// 
			// txtFolder
			// 
			this.txtFolder.Location = new System.Drawing.Point(168, 103);
			this.txtFolder.Name = "txtFolder";
			this.txtFolder.Size = new System.Drawing.Size(272, 20);
			this.txtFolder.TabIndex = 3;
			this.txtFolder.Text = "";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(24, 103);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(136, 16);
			this.label4.TabIndex = 31;
			this.label4.Text = "Pasta dos documentos";
			// 
			// folderBrowserDialog1
			// 
			this.folderBrowserDialog1.ShowNewFolderButton = false;
			// 
			// groupBoxProxy
			// 
			this.groupBoxProxy.Controls.Add(this.txtProxyDomain);
			this.groupBoxProxy.Controls.Add(this.label8);
			this.groupBoxProxy.Controls.Add(this.txtProxyUserPass);
			this.groupBoxProxy.Controls.Add(this.label7);
			this.groupBoxProxy.Controls.Add(this.txtProxyUser);
			this.groupBoxProxy.Controls.Add(this.label6);
			this.groupBoxProxy.Controls.Add(this.txtProxyURL);
			this.groupBoxProxy.Controls.Add(this.label5);
			this.groupBoxProxy.Location = new System.Drawing.Point(56, 160);
			this.groupBoxProxy.Name = "groupBoxProxy";
			this.groupBoxProxy.Size = new System.Drawing.Size(424, 160);
			this.groupBoxProxy.TabIndex = 32;
			this.groupBoxProxy.TabStop = false;
			this.groupBoxProxy.Text = "Dados do Proxy";
			// 
			// txtProxyURL
			// 
			this.txtProxyURL.Location = new System.Drawing.Point(144, 24);
			this.txtProxyURL.Name = "txtProxyURL";
			this.txtProxyURL.Size = new System.Drawing.Size(248, 20);
			this.txtProxyURL.TabIndex = 26;
			this.txtProxyURL.Text = "";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(48, 24);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(80, 16);
			this.label5.TabIndex = 27;
			this.label5.Text = "URL do Proxy";
			// 
			// txtProxyUser
			// 
			this.txtProxyUser.Location = new System.Drawing.Point(144, 56);
			this.txtProxyUser.Name = "txtProxyUser";
			this.txtProxyUser.Size = new System.Drawing.Size(248, 20);
			this.txtProxyUser.TabIndex = 28;
			this.txtProxyUser.Text = "";
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(48, 56);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(80, 16);
			this.label6.TabIndex = 29;
			this.label6.Text = "Utilizador";
			// 
			// txtProxyUserPass
			// 
			this.txtProxyUserPass.Location = new System.Drawing.Point(144, 88);
			this.txtProxyUserPass.Name = "txtProxyUserPass";
			this.txtProxyUserPass.PasswordChar = '*';
			this.txtProxyUserPass.Size = new System.Drawing.Size(248, 20);
			this.txtProxyUserPass.TabIndex = 30;
			this.txtProxyUserPass.Text = "";
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(48, 88);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(80, 16);
			this.label7.TabIndex = 31;
			this.label7.Text = "Password";
			// 
			// txtProxyDomain
			// 
			this.txtProxyDomain.Location = new System.Drawing.Point(144, 120);
			this.txtProxyDomain.Name = "txtProxyDomain";
			this.txtProxyDomain.Size = new System.Drawing.Size(248, 20);
			this.txtProxyDomain.TabIndex = 32;
			this.txtProxyDomain.Text = "";
			// 
			// label8
			// 
			this.label8.Location = new System.Drawing.Point(48, 120);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(80, 16);
			this.label8.TabIndex = 33;
			this.label8.Text = "Dominio";
			// 
			// chkUseProxy
			// 
			this.chkUseProxy.Location = new System.Drawing.Point(24, 128);
			this.chkUseProxy.Name = "chkUseProxy";
			this.chkUseProxy.Size = new System.Drawing.Size(160, 24);
			this.chkUseProxy.TabIndex = 33;
			this.chkUseProxy.Text = "Usar um Servidor de Proxy";
			this.chkUseProxy.CheckedChanged += new System.EventHandler(this.chkUseProxy_CheckedChanged);
			// 
			// frmOptions
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(496, 371);
			this.Controls.Add(this.chkUseProxy);
			this.Controls.Add(this.groupBoxProxy);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.txtFolder);
			this.Controls.Add(this.txtSubject);
			this.Controls.Add(this.txtUrlWS);
			this.Controls.Add(this.txtUrlOfficeWorks);
			this.Controls.Add(this.btnChangeFolder);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.btnOK);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "frmOptions";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Opções de Configuração";
			this.Load += new System.EventHandler(this.frmOptions_Load);
			this.groupBoxProxy.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		private void btnCancel_Click(object sender, EventArgs e) {
			this.Close();
		}

		private void btnOK_Click(object sender, EventArgs e) {
			frmFiles.strUrlOfficeWorks = txtUrlOfficeWorks.Text;
			frmFiles.strSubject = txtSubject.Text;

			frmFiles.bUseProxy = chkUseProxy.Checked;
			frmFiles.strProxyUrl = txtProxyURL.Text;
			frmFiles.strProxyUser = txtProxyUser.Text;
			frmFiles.strProxyUserPass = txtProxyUserPass.Text;
			frmFiles.strProxyDomain = txtProxyDomain.Text;

			//if (txtUrlWS.Text != frmFiles.strUrlWebService)
			//{
			frmFiles.strUrlWebService = txtUrlWS.Text;
			//	l_obj.getBooks();
			//}

			if(txtFolder.Text != frmFiles.InitDirectory) {
				frmFiles.InitDirectory = txtFolder.Text;
				l_obj.picPreview.Image = null;
				l_obj.LoadFiles();
			}

			l_obj.getBooks();
			frmFiles.WriteConfigToXML();
			this.Close();
		}

		private void frmOptions_Load(object sender, EventArgs e) {
			txtUrlOfficeWorks.Text = frmFiles.strUrlOfficeWorks;
			txtUrlWS.Text = frmFiles.strUrlWebService;
			txtSubject.Text = frmFiles.strSubject;
			txtFolder.Text = frmFiles.InitDirectory;

			chkUseProxy.Checked = frmFiles.bUseProxy;
			if(chkUseProxy.Checked) {
				groupBoxProxy.Enabled = true;
				txtProxyURL.Focus();
			}
			else {
				groupBoxProxy.Enabled = false;
			}

			txtProxyURL.Text = frmFiles.strProxyUrl;
			txtProxyUser.Text = frmFiles.strProxyUser;
			txtProxyUserPass.Text = frmFiles.strProxyUserPass;
			txtProxyDomain.Text = frmFiles.strProxyDomain;
			folderBrowserDialog1.SelectedPath = txtFolder.Text;
		}

		private void btnChangeFolder_Click(object sender, EventArgs e) {
			if(folderBrowserDialog1.ShowDialog() == DialogResult.OK) {
				txtFolder.Text = folderBrowserDialog1.SelectedPath;
			}
		}

		private void chkUseProxy_CheckedChanged(object sender, EventArgs e) {
			if(chkUseProxy.Checked) {
				groupBoxProxy.Enabled = true;
				txtProxyURL.Focus();
			}
			else {
				groupBoxProxy.Enabled = false;
			}
		}
	}
}