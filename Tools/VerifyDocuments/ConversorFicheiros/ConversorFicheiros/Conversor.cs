using System;
using System.Diagnostics;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Win32;
using System.IO;

namespace ConversorFicheiros
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class FrmConversor : System.Windows.Forms.Form
	{
		private String strConnectionString;

		private System.Windows.Forms.Button btnInit;
		private System.Windows.Forms.ProgressBar pb1;
		private System.Windows.Forms.StatusBar statusBar1;
		private System.Windows.Forms.Button btnCancel;
		private System.Windows.Forms.Button btnDup;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		/// <summary>
		/// Constructor
		/// </summary>
		public FrmConversor()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//

			
			//Obtém a connection string do registry
			setDBConnectionString();
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
			this.btnInit = new System.Windows.Forms.Button();
			this.pb1 = new System.Windows.Forms.ProgressBar();
			this.statusBar1 = new System.Windows.Forms.StatusBar();
			this.btnCancel = new System.Windows.Forms.Button();
			this.btnDup = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// btnInit
			// 
			this.btnInit.Location = new System.Drawing.Point(16, 8);
			this.btnInit.Name = "btnInit";
			this.btnInit.TabIndex = 0;
			this.btnInit.Text = "Normalizar";
			this.btnInit.Click += new System.EventHandler(this.btnInit_Click);
			// 
			// pb1
			// 
			this.pb1.Location = new System.Drawing.Point(0, 48);
			this.pb1.Minimum = 1;
			this.pb1.Name = "pb1";
			this.pb1.Size = new System.Drawing.Size(424, 23);
			this.pb1.Step = 1;
			this.pb1.TabIndex = 1;
			this.pb1.Value = 1;
			// 
			// statusBar1
			// 
			this.statusBar1.Location = new System.Drawing.Point(0, 70);
			this.statusBar1.Name = "statusBar1";
			this.statusBar1.Size = new System.Drawing.Size(424, 24);
			this.statusBar1.SizingGrip = false;
			this.statusBar1.TabIndex = 2;
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(247, 8);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.TabIndex = 3;
			this.btnCancel.Text = "Cancelar";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnDup
			// 
			this.btnDup.Location = new System.Drawing.Point(109, 8);
			this.btnDup.Name = "btnDup";
			this.btnDup.Size = new System.Drawing.Size(120, 23);
			this.btnDup.TabIndex = 4;
			this.btnDup.Text = "Eliminar Duplicados";
			this.btnDup.Click += new System.EventHandler(this.btnDup_Click);
			// 
			// FrmConversor
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(424, 94);
			this.Controls.Add(this.btnDup);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.statusBar1);
			this.Controls.Add(this.pb1);
			this.Controls.Add(this.btnInit);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
			this.MaximizeBox = false;
			this.Name = "FrmConversor";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "Conversor de ficheiros";
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new FrmConversor());
		}


		
		/// <summary>
		/// Normaliza os ficheiros
		/// </summary>
		private void btnInit_Click(object sender, System.EventArgs e)
		{
			btnInit.Enabled = false;
			btnDup.Enabled = false;
			Application.DoEvents();

			readFiles();

			btnInit.Enabled = true;
			btnDup.Enabled = true;
		}


		/// <summary>
		/// Elimina duplicados
		/// </summary>
		private void btnDup_Click(object sender, System.EventArgs e)
		{
			btnDup.Enabled = false;
			btnInit.Enabled = false;
			Application.DoEvents();

			eraseDuplicateRecords();

			btnInit.Enabled = true;
			btnDup.Enabled = true;
		}


		/// <summary>
		/// Cancela a operação
		/// </summary>
		private void btnCancel_Click(object sender, System.EventArgs e)
		{
			if (MessageBox.Show("Pretende cancelar a operação?","Conversor de ficheiros",
				MessageBoxButtons.YesNo,MessageBoxIcon.Question,
				MessageBoxDefaultButton.Button2,MessageBoxOptions.ServiceNotification)==DialogResult.Yes)
				Process.GetCurrentProcess().Kill();
		}






		/// <summary>
		/// Get connection values from the windows registry
		/// </summary>
		private void setDBConnectionString()
		{
			String strAux = String.Empty;
			String strBux = String.Empty;

			RegistryKey key = Registry.LocalMachine.OpenSubKey( "Software\\OW");

			strAux = key.GetValue("Server").ToString();
			strBux = key.GetValue("DB").ToString();

			strConnectionString = "server=" + strAux + ";database=" + strBux + ";integrated security=SSPI; connection timeout=0;";

			Registry.LocalMachine.Close();
		}



		/// <summary>
		/// Read the file manager table
		/// </summary>
		private void readFiles()
		{
			SqlConnection oConnection = null;
			DataSet oDataSet = new DataSet();

			SqlCommand oCommand = null;
			String strSql = String.Empty;

			String strFileID = String.Empty;
			String strFileName = String.Empty;
			String strFilePath = String.Empty;

			String strAux = String.Empty;
			String strBux = String.Empty;
			String strTxt = String.Empty;


			try
			{

				this.statusBar1.Text = "A ler ficheiros da base de dados ...";
				Application.DoEvents();

				//Obtém os registos da BD
				oConnection = new SqlConnection(strConnectionString);
				oConnection.Open();
				strSql = "select FileID, FileName, FilePath from OW.tblFileManager";
				SqlDataAdapter oDataAdapter = new SqlDataAdapter(); 
				oDataAdapter.SelectCommand = new SqlCommand(strSql, oConnection);
				oDataAdapter.SelectCommand.CommandTimeout = 0;
				oDataAdapter.Fill(oDataSet, "tblFileManager");

				DataTable oDataTable = oDataSet.Tables["tblFileManager"];

				this.pb1.Maximum = oDataTable.Rows.Count;
				
				if (oDataTable != null)
				{

					//Abre o txt de log
					strTxt = Application.StartupPath + @"\MissingFiles.txt";
					StreamWriter st = new StreamWriter(strTxt, false);

					long i = 0;
					foreach (DataRow oRow in oDataTable.Rows)
					{
						this.statusBar1.Text = "A processar ficheiro " + (++i) + " de " + this.pb1.Maximum;
						Application.DoEvents();

						strFileID = oRow["FileID"].ToString();
						strFileName = oRow["FileName"].ToString();
						strFilePath = oRow["FilePath"].ToString();

						if (strFileName.LastIndexOf('.') >= 0)
						{
							strAux = strFileName.Substring(strFileName.LastIndexOf('.'));

							//Se o ficheiro não tem extensão (ou está errada) na BD, adiciona-a
							if (strFilePath.LastIndexOf('.') < 0 || strFilePath.Substring(strFilePath.LastIndexOf('.')) != strAux)
							{
								strFilePath += strAux;

								strSql = "update OW.tblFileManager set FilePath = '" + strFilePath.Replace("'", "''") + "'"
									+ " where FileID = " + strFileID;
								oCommand = new SqlCommand(strSql, oConnection);
								oCommand.CommandTimeout = 0;
								oCommand.ExecuteNonQuery();
							}

							//Verifica se o ficheiro existe sem extensão e faz o rename
							if (!File.Exists(strFilePath))
								if (File.Exists(strFilePath.Substring(0, strFilePath.LastIndexOf('.'))))
								{
									File.Move(strFilePath.Substring(0, strFilePath.LastIndexOf('.')), strFilePath);
								}
								else
								{
									strBux = strFileID + "; " + strFileName + "; " + strFilePath;
									st.WriteLine(strBux);
								}
						}

						this.pb1.PerformStep();
						Application.DoEvents();
					}
					st.Close();
				}
				this.statusBar1.Text = "Operação concluída.";

			}
			catch (Exception oE)
			{
				MessageBox.Show("Erro na normalização: [" + oE.ToString() + "]");
			}
			finally
			{
				//clear the inmemory data in the dataset, and close the database
				// connection, if it's open.
				if (oDataSet != null) oDataSet.Clear();
				if (oConnection!= null)
					if (oConnection.State == ConnectionState.Open)
						oConnection.Close();
			}
		}


		
		/// <summary>
		/// Erase duplicate records from table tblFileManager
		/// </summary>
		private void eraseDuplicateRecords()
		{
			
			SqlConnection oConnection = null;
			DataSet oDataSet = new DataSet();

			SqlTransaction oSqlTrans = null;
			SqlCommand oCommand = null;
			String strSql = String.Empty;

			String strFileID = String.Empty;
			String strFileName = String.Empty;
			String strFilePath = String.Empty;
			String strCreateDate = String.Empty;
			String strCreateUserId = String.Empty;

			String strAux = String.Empty;
			String strTxt = String.Empty;

			try
			{

				this.statusBar1.Text = "A verificar registos duplicados ...";
				Application.DoEvents();

				//Obtém os registos da BD
				oConnection = new SqlConnection(strConnectionString);
				oConnection.Open();
				oSqlTrans = oConnection.BeginTransaction();

				strSql = "select fileId, [fileName], filePath, createDate, createUserId from OW.tblFileManager";
				strSql += " group by fileId, [fileName], filePath, createDate, createUserId having count(*)>1";

				SqlDataAdapter oDataAdapter = new SqlDataAdapter(); 
				oDataAdapter.SelectCommand = new SqlCommand(strSql, oConnection);
				oDataAdapter.SelectCommand.Transaction = oSqlTrans;
				oDataAdapter.SelectCommand.CommandTimeout = 0;
				oDataAdapter.Fill(oDataSet, "tblFileManagerDup");
				DataTable oDataTable = oDataSet.Tables["tblFileManagerDup"];

				this.pb1.Minimum = 1;
				this.pb1.Maximum = oDataTable.Rows.Count;
				
				if (oDataTable != null)
				{
					//Abre o ficheiro txt
					strTxt = Application.StartupPath + @"\tblFileManagerDupApagados.txt";
					StreamWriter st = new StreamWriter(strTxt, true);

					long i = 0;
					foreach (DataRow oRow in oDataTable.Rows)
					{
						this.statusBar1.Text = "A eliminar duplicado " + (++i) + " de " + this.pb1.Maximum;
						Application.DoEvents();

						strFileID = oRow["FileID"].ToString();
						strFileName = oRow["FileName"].ToString();
						strFilePath = oRow["FilePath"].ToString();
						strCreateDate = oRow["createDate"].ToString();
						strCreateUserId = oRow["createUserId"].ToString();
						
						//Guarda o registo, que contém duplicados, no txt
						strAux = strFileID + "; " + strFileName + "; " + strFilePath + "; " + strCreateDate + "; " + strCreateUserId;
						st.WriteLine(strAux);
						
						//Apaga os duplicados da base de dados
						strSql = "delete from OW.tblFileManager where FileID = " + strFileID;
						oCommand = new SqlCommand(strSql, oConnection);
						oCommand.Transaction = oSqlTrans;
						oCommand.CommandTimeout = 0;
						oCommand.ExecuteNonQuery();

						//Copia novamente o original
						strSql = "set identity_insert OW.tblFileManager on";
						strSql += " insert into OW.tblFileManager (fileId, [fileName], filePath, createDate, createUserId)";
						strSql += " values (";
						strSql += strFileID + ",";
						strSql += "'" + strFileName.Replace("'", "''") + "',";
						strSql += "'" + strFilePath.Replace("'", "''") + "',";
						if (strCreateDate.Trim().Length > 0)
						{
							strSql += "'" + strCreateDate + "',";
						}
						else
						{
							strSql += "null,";
							
						}
						if (strCreateUserId.Trim().Length > 0)
						{
							strSql += strCreateDate;
						}
						else
						{
							strSql += "null";
							
						}
						strSql += ")";
						strSql += " set identity_insert OW.tblFileManager off";
						oCommand = new SqlCommand(strSql, oConnection);
						oCommand.Transaction = oSqlTrans;
						oCommand.CommandTimeout = 0;
						oCommand.ExecuteNonQuery();


						this.pb1.PerformStep();
						Application.DoEvents();
					}

					st.Close();
				}

				oSqlTrans.Commit();


				this.statusBar1.Text = "A verificar duplicados activos ...";
				Application.DoEvents();

				//Copia os ID's duplicados para um txt
				getDuplicateIDs();

				this.pb1.PerformStep();
				this.statusBar1.Text = "Operação concluída.";
				Application.DoEvents();

			}
			catch (Exception oE)
			{
				oSqlTrans.Rollback();
				MessageBox.Show("Erro na eliminação de duplicados: [" + oE.ToString() + "]");
			}
			finally
			{
				//clear the inmemory data in the dataset, and close the database
				// connection, if it's open.
				if (oDataSet != null) oDataSet.Clear();
				if (oConnection!= null)
					if (oConnection.State == ConnectionState.Open)
						oConnection.Close();
			}


		}



		/// <summary>
		/// Get duplicate ID's from table tblFileManager
		/// </summary>
		private void getDuplicateIDs()
		{
			
			SqlConnection oConnection = null;
			DataSet oDataSet = new DataSet();
			String strSql = String.Empty;

			String strFileID = String.Empty;
			String strFileName = String.Empty;
			String strFilePath = String.Empty;
			String strCreateDate = String.Empty;
			String strCreateUserId = String.Empty;

			String strAux = String.Empty;
			
			String strTxt = String.Empty;

			try
			{
				//Obtém os registos da BD
				oConnection = new SqlConnection(strConnectionString);
				oConnection.Open();

				strSql = "select fileId, [fileName], filePath, createDate, createUserId from OW.tblFileManager"
						+ " where fileid in"
						+ " (select fileid from OW.tblFileManager"
						+ " group by fileid"
						+ " having count(fileid)>1)";

				SqlDataAdapter oDataAdapter = new SqlDataAdapter(); 
				oDataAdapter.SelectCommand = new SqlCommand(strSql, oConnection);
				oDataAdapter.SelectCommand.CommandTimeout = 0;
				oDataAdapter.Fill(oDataSet, "tblFileManagerDup");
				DataTable oDataTable = oDataSet.Tables["tblFileManagerDup"];

				if (oDataTable != null)
				{
					//Abre o ficheiro txt
					strTxt = Application.StartupPath + @"\tblFileManagerDupActivos.txt";
					StreamWriter st = new StreamWriter(strTxt, false);

					foreach (DataRow oRow in oDataTable.Rows)
					{
						strFileID = oRow["FileID"].ToString();
						strFileName = oRow["FileName"].ToString();
						strFilePath = oRow["FilePath"].ToString();
						strCreateDate = oRow["createDate"].ToString();
						strCreateUserId = oRow["createUserId"].ToString();
						
						//Guarda o registo no txt
						strAux = strFileID + "; " + strFileName + "; " + strFilePath + "; " + strCreateDate + "; " + strCreateUserId;
						st.WriteLine(strAux);
					}

					st.Close();
				}
			}
			catch (Exception oE)
			{
				throw;
			}
			finally
			{
				//clear the inmemory data in the dataset, and close the database
				// connection, if it's open.
				if (oDataSet != null) oDataSet.Clear();
				if (oConnection!= null)
					if (oConnection.State == ConnectionState.Open)
						oConnection.Close();
			}
		}


	}
}
