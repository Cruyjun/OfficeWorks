using System;
using System.Collections;
using System.ComponentModel;
using System.Configuration.Install;
using System.EnterpriseServices;
using System.IO;

namespace OfficeWorks
{
	/// <summary>
	/// Ensures OWMail 2.0 component gets automatically registered in COM+ application catalog during its setup.
	/// </summary>
	[RunInstaller(true)]
	public class OWMailInstaller : Installer
	{
		private Container components = null;

		/// <summary>
		/// Default constructor. Calls its base constructor.
		/// </summary>
		public OWMailInstaller() : base()
		{
			InitializeComponent();
		}

		/// <summary>
		/// Override Install method to allow custom actions during OWMail 2.0 setup.
		/// </summary>
		/// <param name="stateSaver">An IDictionary that contains the context information associated with the installation.</param>
		public override void Install(IDictionary stateSaver)
		{
			try
			{
				string AppID = null;
				string TypeLib = null;

				// Get the location of the current assembly
				string Assembly = GetType().Assembly.Location;

				// Install the application
				RegistrationHelper rh = new RegistrationHelper();
				rh.InstallAssembly(Assembly, ref AppID, ref TypeLib, InstallationFlags.FindOrCreateTargetApplication);

				//RegistrationConfig configuration = new RegistrationConfig();

				// Save the state - you will need this for the uninstall
				stateSaver.Add("AppID", AppID);
				stateSaver.Add("Assembly", Assembly);
			}
			catch (Exception ex)
			{
				StreamWriter sw = File.AppendText(@"c:\OWMailInstallerErrors.log");
				sw.WriteLine ("Uninstall Error: {0}", ex.Message);
				sw.Close();
			}
		}

		/// <summary>
		/// Override Uninstall method to allow custom actions during OWMail 2.0 uninstall.
		/// </summary>
		/// <param name="savedState">An IDictionary that contains the context information associated with the installation.</param>
		public override void Uninstall(IDictionary savedState)
		{
			try
			{
				// Get the state created when the COM+ application was installed
				string AppID = (string)savedState["OWMail"];
				string Assembly = (string)savedState["Assembly"];

				// Uninstall the COM+ application
				RegistrationHelper rh = new RegistrationHelper();
				rh.UninstallAssembly(Assembly, AppID);
			}
			catch (Exception ex)
			{
				// Don't allow unhandled exceptions during uninstall
				StreamWriter sw = File.AppendText(@"c:\OWMailInstallerErrors.log");
				sw.WriteLine ("Uninstall Error: {0}", ex.Message);
				sw.Close();
			}
		}


		/// <summary> 
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if (disposing )
			{
				if (components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}


		#region Component Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			components = new System.ComponentModel.Container();
		}
		#endregion
	}
}
