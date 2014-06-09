using System.ComponentModel;
using System.Windows.Forms;

namespace OfficeWorks
{
	/// <summary>
	/// Summary description for SplashForm.
	/// </summary>
	public class SplashForm : Form
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private Container components = null;
		private PictureBox pictureBox1;
		private Label lblMsg;
		private Panel panel1;



		/// <summary>
		/// Initialize component
		/// </summary>
		public SplashForm()
		{
			InitializeComponent();
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


		/// <summary>
		/// Information about status
		/// </summary>
		private string _StatusInfo = "";
		public string StatusInfo 
		{
			set 
			{
				_StatusInfo = value;
				ChangeStatusText();
			}
			get 
			{
				return _StatusInfo;
			}
		}


		/// <summary>
		/// 
		/// </summary>
		public void ChangeStatusText() 
		{
			try 
			{
				if (this.InvokeRequired) 
				{
					this.Invoke(new MethodInvoker(this.ChangeStatusText));
					return;
				}
				lblMsg.Text = _StatusInfo;
			}
			catch 
			{
			}
		}

		
		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(SplashForm));
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.lblMsg = new System.Windows.Forms.Label();
			this.panel1 = new System.Windows.Forms.Panel();
			this.panel1.SuspendLayout();
			this.SuspendLayout();
			// 
			// pictureBox1
			// 
			this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
			this.pictureBox1.Location = new System.Drawing.Point(59, -42);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(104, 64);
			this.pictureBox1.TabIndex = 0;
			this.pictureBox1.TabStop = false;
			// 
			// lblMsg
			// 
			this.lblMsg.BackColor = System.Drawing.Color.Transparent;
			this.lblMsg.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.lblMsg.ForeColor = System.Drawing.SystemColors.Highlight;
			this.lblMsg.Location = new System.Drawing.Point(8, 32);
			this.lblMsg.Name = "lblMsg";
			this.lblMsg.Size = new System.Drawing.Size(208, 16);
			this.lblMsg.TabIndex = 1;
			this.lblMsg.Text = "Processando o Pedido...";
			this.lblMsg.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			// 
			// panel1
			// 
			this.panel1.Controls.Add(this.pictureBox1);
			this.panel1.Controls.Add(this.lblMsg);
			this.panel1.Location = new System.Drawing.Point(0, 0);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(224, 63);
			this.panel1.TabIndex = 2;
			// 
			// SplashForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(224, 64);
			this.Controls.Add(this.panel1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			this.IsMdiContainer = true;
			this.Name = "SplashForm";
			this.Opacity = 0.5;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "SplashForm";
			this.TransparencyKey = System.Drawing.Color.Transparent;
			this.panel1.ResumeLayout(false);
			this.ResumeLayout(false);

		}
		#endregion

		
	}
}
