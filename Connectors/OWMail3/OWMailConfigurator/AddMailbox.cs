using System;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;

namespace OfficeWorks
{
	/// <summary>
	/// Summary description for AddMailbox.
	/// </summary>
	public class AddMailbox : Form
	{
		private Button btnConfirm;
		private Button btnCancel;
		private ToolTip toolTipAddMailbox;
		private Label lblMailboxList;
		private ListBox listMailboxAdd;
		private IContainer components;

		public AddMailbox()
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
			this.components = new System.ComponentModel.Container();
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(AddMailbox));
			this.btnConfirm = new System.Windows.Forms.Button();
			this.btnCancel = new System.Windows.Forms.Button();
			this.lblMailboxList = new System.Windows.Forms.Label();
			this.toolTipAddMailbox = new System.Windows.Forms.ToolTip(this.components);
			this.listMailboxAdd = new System.Windows.Forms.ListBox();
			this.SuspendLayout();
			// 
			// btnConfirm
			// 
			this.btnConfirm.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnConfirm.Location = new System.Drawing.Point(328, 48);
			this.btnConfirm.Name = "btnConfirm";
			this.btnConfirm.TabIndex = 0;
			this.btnConfirm.Text = "&Confirmar";
			this.toolTipAddMailbox.SetToolTip(this.btnConfirm, "Adciona o nome indicado à lista de contas de correio");
			this.btnConfirm.Click += new System.EventHandler(this.btnConfirm_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.btnCancel.Location = new System.Drawing.Point(328, 80);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.TabIndex = 1;
			this.btnCancel.Text = "C&ancelar";
			this.toolTipAddMailbox.SetToolTip(this.btnCancel, "Cancela a operação de adicionar conta e volta ao écran principal");
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// lblMailboxList
			// 
			this.lblMailboxList.AutoSize = true;
			this.lblMailboxList.Location = new System.Drawing.Point(8, 8);
			this.lblMailboxList.Name = "lblMailboxList";
			this.lblMailboxList.Size = new System.Drawing.Size(96, 16);
			this.lblMailboxList.TabIndex = 3;
			this.lblMailboxList.Text = "Contas de Correio";
			// 
			// listMailboxAdd
			// 
			this.listMailboxAdd.Location = new System.Drawing.Point(8, 24);
			this.listMailboxAdd.Name = "listMailboxAdd";
			this.listMailboxAdd.Size = new System.Drawing.Size(312, 82);
			this.listMailboxAdd.TabIndex = 4;
			this.toolTipAddMailbox.SetToolTip(this.listMailboxAdd, "Lista de contas de correio do Active Directory do domínio");
			// 
			// AddMailbox
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.btnCancel;
			this.ClientSize = new System.Drawing.Size(410, 112);
			this.ControlBox = false;
			this.Controls.Add(this.listMailboxAdd);
			this.Controls.Add(this.lblMailboxList);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.btnConfirm);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "AddMailbox";
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "Adicionar Conta de Correio";
			this.Load += new System.EventHandler(this.AddMailbox_Load);
			this.ResumeLayout(false);

		}
		#endregion

		private void btnCancel_Click(object sender, EventArgs e)
		{
			this.Close();
		}

		/// <summary>
		/// Create Event Sink Registration
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void btnConfirm_Click(object sender, EventArgs e)
		{
			// If a mailbox was selected
			if (listMailboxAdd.SelectedIndex != -1)
			{
				string mailboxName = listMailboxAdd.SelectedItem.ToString();
				/*Splasher.Status = MainForm._addMailbox;
				Splasher.Show();							*/
				if (!MailboxNameExists(mailboxName))
				{
					if (mailboxName.Length > 0)
					{
						// If mailbox allready has an event associated...
						if (((MainForm)Owner).ExchangeRegistrationProcessor(ExchangeOperation.List, mailboxName))
						{
							// Delete the old event
							
							((MainForm)Owner).ExchangeRegistrationProcessor(ExchangeOperation.Delete, mailboxName);
						}
						
						// Register a new event sink
						if (((MainForm)Owner).ExchangeRegistrationProcessor(ExchangeOperation.Create, mailboxName))
						{
							OWMailConfiguration.Mailbox mailbox = new OWMailConfiguration.Mailbox();
							mailbox.MailboxName = listMailboxAdd.SelectedItem.ToString();;
							((MainForm)Owner).Configuration.Mailboxes.Add(mailbox);
							// Faz com que o form volte a forma inicial.
							//((MainForm)Owner).ResetFields(false);
							((MainForm)Owner).GetConfigurationValues();
							//Splasher.Close();
							this.Close();
						}
						else
						{
							//Splasher.Close();
							MessageBox.Show("Não foi possível registar o evento no Servidor de Exchange", "Erro no registo do evento");
						}
					}
					else
					{
						//Splasher.Close();
						MessageBox.Show("O nome da conta de correio que indicou não é válido", "Conta de correio inválida");
					}
				}
				else
				{
					//Splasher.Close();
					MessageBox.Show("O nome da conta de correio que indicou já existe na lista", "Conta de correio já existente");
				}
			}
			else
			{
				//Splasher.Close();
				MessageBox.Show("Seleccione a conta de correio que pretende adicionar à lista", "Conta de correio inválida");
			}
		}

		private bool MailboxNameExists(string mailboxName)
		{
			bool exists = false;

			foreach (OWMailConfiguration.Mailbox mailbox in ((MainForm)Owner).Configuration.Mailboxes)
			{
				if (mailbox.MailboxName == mailboxName)
				{
					exists = true;
					break;
				}
			}

			return exists;
		}
		/// <summary>
		/// Event fired when AddMailbox form is activated
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void AddMailbox_Load(object sender, EventArgs e)
		{
			lblMailboxList.Text += " do domínio " + ((MainForm)Owner).ActiveDirectoryDomain;

			ArrayList mailsList = ((MainForm)Owner).ActiveDirectoryMailsList;

			if (mailsList != null && mailsList.Count > 0)
			{
				listMailboxAdd.Items.AddRange((string[])mailsList.ToArray(typeof(string)));
			}
		}
		
	}
}
