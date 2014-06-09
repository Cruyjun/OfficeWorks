using System.ComponentModel;
using System.Windows.Forms;

namespace OWScan {
	/// <summary>
	/// Summary description for frmPreview.
	/// </summary>
	public class frmPreview : Form {
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private Container components = null;

		public PictureBox picPreview;

		public frmPreview() {
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(frmPreview));
			this.picPreview = new System.Windows.Forms.PictureBox();
			this.SuspendLayout();
			// 
			// picPreview
			// 
			this.picPreview.Location = new System.Drawing.Point(0, 0);
			this.picPreview.Name = "picPreview";
			this.picPreview.Size = new System.Drawing.Size(568, 438);
			this.picPreview.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
			this.picPreview.TabIndex = 4;
			this.picPreview.TabStop = false;
			// 
			// frmPreview
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.AutoScroll = true;
			this.BackColor = System.Drawing.Color.White;
			this.ClientSize = new System.Drawing.Size(792, 566);
			this.Controls.Add(this.picPreview);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.Name = "frmPreview";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Visualizar Documento";
			this.ResumeLayout(false);

		}
		#endregion
	}
}