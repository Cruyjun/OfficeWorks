using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Windows.Forms;

namespace OfficeWorks.OWOffice.Configurator
{
	/// <summary>
	/// Summary description for Copyright.
	/// </summary>
	public class Copyright : Form
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private Container components = null;
		private Button button1;
		private LinkLabel linkLabel1;
		private Label label2;
		private System.Windows.Forms.PictureBox pictureBox1;
		private Label lblAboutTitle;


		/// <summary>
		/// Initiale component
		/// </summary>
		public Copyright()
		{
			InitializeComponent();
			lblAboutTitle.Text= MainForm.ApplicationTitle;
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(Copyright));
			this.button1 = new System.Windows.Forms.Button();
			this.lblAboutTitle = new System.Windows.Forms.Label();
			this.linkLabel1 = new System.Windows.Forms.LinkLabel();
			this.label2 = new System.Windows.Forms.Label();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.SuspendLayout();
			// 
			// button1
			// 
			this.button1.BackColor = System.Drawing.SystemColors.ActiveBorder;
			this.button1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.button1.ForeColor = System.Drawing.Color.FromArgb(((System.Byte)(2)), ((System.Byte)(88)), ((System.Byte)(97)));
			this.button1.Location = new System.Drawing.Point(128, 104);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(72, 23);
			this.button1.TabIndex = 1;
			this.button1.Text = "Ok";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// lblAboutTitle
			// 
			this.lblAboutTitle.BackColor = System.Drawing.Color.Transparent;
			this.lblAboutTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lblAboutTitle.ForeColor = System.Drawing.Color.FromArgb(((System.Byte)(2)), ((System.Byte)(88)), ((System.Byte)(97)));
			this.lblAboutTitle.Location = new System.Drawing.Point(16, 6);
			this.lblAboutTitle.Name = "lblAboutTitle";
			this.lblAboutTitle.Size = new System.Drawing.Size(304, 18);
			this.lblAboutTitle.TabIndex = 2;
			this.lblAboutTitle.Text = "Configuração do OWOffice";
			this.lblAboutTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// linkLabel1
			// 
			this.linkLabel1.ActiveLinkColor = System.Drawing.Color.FromArgb(((System.Byte)(236)), ((System.Byte)(64)), ((System.Byte)(45)));
			this.linkLabel1.BackColor = System.Drawing.Color.Transparent;
			this.linkLabel1.LinkColor = System.Drawing.Color.FromArgb(((System.Byte)(151)), ((System.Byte)(179)), ((System.Byte)(186)));
			this.linkLabel1.Location = new System.Drawing.Point(16, 80);
			this.linkLabel1.Name = "linkLabel1";
			this.linkLabel1.Size = new System.Drawing.Size(304, 16);
			this.linkLabel1.TabIndex = 3;
			this.linkLabel1.TabStop = true;
			this.linkLabel1.Text = "http://www.Magnetik.pt";
			this.linkLabel1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			this.linkLabel1.VisitedLinkColor = System.Drawing.Color.FromArgb(((System.Byte)(2)), ((System.Byte)(88)), ((System.Byte)(97)));
			this.linkLabel1.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLabel1_LinkClicked);
			// 
			// label2
			// 
			this.label2.BackColor = System.Drawing.Color.Transparent;
			this.label2.ForeColor = System.Drawing.Color.FromArgb(((System.Byte)(59)), ((System.Byte)(117)), ((System.Byte)(128)));
			this.label2.Location = new System.Drawing.Point(16, 27);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(304, 16);
			this.label2.TabIndex = 4;
			this.label2.Text = "Todos os direitos reservados";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// pictureBox1
			// 
			this.pictureBox1.BackColor = System.Drawing.Color.Transparent;
			this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
			this.pictureBox1.Location = new System.Drawing.Point(136, 56);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(64, 24);
			this.pictureBox1.TabIndex = 8;
			this.pictureBox1.TabStop = false;
			// 
			// Copyright
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.BackColor = System.Drawing.Color.FromArgb(((System.Byte)(230)), ((System.Byte)(236)), ((System.Byte)(238)));
			this.ClientSize = new System.Drawing.Size(330, 135);
			this.ControlBox = false;
			this.Controls.Add(this.pictureBox1);
			this.Controls.Add(this.lblAboutTitle);
			this.Controls.Add(this.button1);
			this.Controls.Add(this.linkLabel1);
			this.Controls.Add(this.label2);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "Copyright";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Acerca";
			this.ResumeLayout(false);

		}
		#endregion


		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void button1_Click(object sender, EventArgs e)
		{
			this.Close();
		}


		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
		{
			Process.Start("http://www.Magnetik.pt");
		}
	}
}
