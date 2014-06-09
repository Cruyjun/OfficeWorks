using System;
using System.Collections;
using System.Diagnostics;
using System.EnterpriseServices;
using System.IO;
using System.Runtime.InteropServices;
using ADODB;
using CDO;
using Stream = ADODB.Stream;

namespace OfficeWorks
{
	/// <summary>
	/// OWMail 2.0 is a COM+ application component. Listens for Saving/Deleting events to occur in Exchange Server
	/// mailboxes that registered this component using OWMail 2.0 Administrator. 
	/// ServicedComponent class is inherited to allow registration of component in COM+ Application Catalog.
	/// IExStoreSyncEvents interface is implemented to allow subscribing of Exchange Server message events.
	/// COM+ components are required to have a GUID in order to register successfully.
	/// Construction is enabled (TRUE) to allow overriding of default activation settings: check Construct 
	/// method implementation for details on this override.
	/// ConfigurationFilePath construction (activation) parameter is used to locate OWMailConfiguration.xml
	/// Path can change without recompiling: change activation settings and restart OWMail COM+ application.
	/// </summary>
	[Guid("1EB5F38E-E31E-4aaa-B51E-CC6B0C7F1D13")]
	[ConstructionEnabled(Enabled = true, Default = @"ConfigurationFilePath=C:\Program Files\Magnetik\OWMail\OWMailConfiguration.xml")]
	public class OWMail : ServicedComponent, IExStoreSyncEvents
	{
		/// <summary>
		/// COM+ needs unique identifiers for these members 
		/// </summary>
		public string ClassID = "F92EFC3A-FDD8-4225-B005-13FD3D5D54D1";
		public string InterfaceId = "704A413F-F8FE-476B-9206-69AB6300D752";
		public string EventsId = "DCC71BD5-6627-4FBF-BB5A-DB8FEA1EB177";

		/// <summary>
		/// Path of OWMail 2.0 Configuration XML file. Default path it is the same used in activation settings
		/// </summary>
		private string configurationFilePath = @"c:\Program Files\Magnetik\OWMail\OWMailConfiguration.xml";
		public string ConfigurationFilePath
		{
			get
			{
				return configurationFilePath;
			}
			set
			{
				configurationFilePath = value;
			}
		}

		/// <summary>
		/// Default constructor
		/// </summary>
		public OWMail()
		{
		}

		/// <summary>
		/// Overriding Construct method allows manipulation of activation settings in a COM+ application
		/// </summary>
		/// <param name="constructorString">String to use when activating OWMail 2.0 COM+ application</param>
		protected override void Construct(string constructorString) 
		{     
			if (constructorString.Length > 0)
			{
				string[] settings = constructorString.Split(';');

				// Loop through all constructor settings and assign respective local members
				for (int x = 0; x < settings.Length; x++)
				{
					int keyPosition = settings[x].IndexOf("=");
					
					if (settings[x].Length > 0 && keyPosition != -1)
					{
						string key = settings[x].Substring(0, keyPosition).ToLower();
						string _value = settings[x].Substring(keyPosition + 1);
						
						// This is implemented as a SWITCH instead of an IF to make it easier to extend
						switch (key)
						{
							case "configurationfilepath":
							{								
								ConfigurationFilePath = _value;
								break;
							}
							default:
							{
								break;
							}
						}
					}
				}
			}
		}

		/// <summary>
		/// Implementation of a Synchronous Event. This event will be triggered every time a
		/// mail message arrives at the mailbox where it is registered. It is synchronous because 
		/// message will wait for the code here implemented to end execution before beeing available in mailbox. 
		/// </summary>
		/// <param name="pEventInfo">A pointer to an IExStoreEventInfo interface that can be used to obtain further information related to the event.</param>
		/// <param name="bstrURLItem">A string containing the URL of the item on which the event is occurring.</param>
		/// <param name="lFlags">Bitwise AND flag gives further information about the save event.</param>
		public void OnSyncSave(IExStoreEventInfo pEventInfo, string bstrURLItem, int lFlags)
		{
			// Initialize local variables
			OWMailConfiguration configuration = null;
			EventLog log = null;
			Stream stream = null;
			Record recItem = null;
			
			try
			{
				// These values are checked to identify a saving event before beeing commited
				// Exchange Server SDK value and Exchange Server 2003 have presented different values
				// so both were included in this implementation. The enum is also checked here, just in case...
				if (lFlags == 33554440 || lFlags == 33554432 || lFlags == (int)EVT_SINK_FLAGS.EVT_SYNC_COMMITTED) 
				{

					// These two must have the same value
					string sourceApplication = "OWMail";
					//string logName = "OWMail";
			
					// If Event Viewer entry does not exists (e.g., first time), then create it
					if (!EventLog.SourceExists(sourceApplication))
					{
						EventLog.CreateEventSource(sourceApplication, sourceApplication);
					}

					log = new EventLog(sourceApplication);
					log.Log = sourceApplication;
					log.Source = sourceApplication;

					// Get settings from OWMail 2.0 XML configuration file
					configuration = new OWMailConfiguration(ConfigurationFilePath);


					// Get a ADO Record object from pEventInfo parameter
					IExStoreDispEventInfo pDispEventInfo = (IExStoreDispEventInfo)pEventInfo;
					recItem = (Record)pDispEventInfo.EventRecord;

					// Get a ADO Stream object from ADO Record
					stream = new StreamClass();
					stream.Open(recItem, ConnectModeEnum.adModeRead, StreamOpenOptionsEnum.adOpenStreamFromRecord, string.Empty, string.Empty);

					// Creates a new Guid to use when saving message and attachments to TEMP directory.
					// TEMP directory path is stored in configuration file.
					string guid = Guid.NewGuid().ToString();
					string filePath = configuration.TempDirectoryPath + @"\" + guid + ".eml";

					// Saves the ADO Stream to TEMP directory
					stream.SaveToFile(filePath, SaveOptionsEnum.adSaveCreateNotExist);
				
					// Creates a CDO Message object
					Message message = new MessageClass();
					// Gets message data loaded from ADO Record object
					message.DataSource.OpenObject(recItem, "_Record");

					// Assigns local variables from loaded message fields
					string from = message.From;
					string to = message.To;
					string cc = message.CC;
					string subject = (string)message.Fields["urn:schemas:httpmail:normalizedsubject"].Value;
					DateTime mailDate = message.ReceivedTime;
					string body = (string)message.Fields["urn:schemas:httpmail:textdescription"].Value;

					// Use event source URL to extract mailbox name
					string[] urlElements = bstrURLItem.Split('/');
					string mailboxName = urlElements[urlElements.Length - 3];
					
					// Use mailbox name to extract its operation settings from configuration
					string userLogin = configuration.GetUserLoginByMailboxName(mailboxName,'@');
					
					// OWApi Web Service accepts blank credentials
					string password = string.Empty;
					//string entityName = string.Empty;

					// This list will hold all message entities encapsulated in MailContact objects
					ArrayList list = new ArrayList();
					
					// This object has functions to ease the extraction of message entity fields 
					MailContactHelper mailContactHelper = new MailContactHelper();
					// Get a list with all entities referred in FROM, TO, CC, BCC message fields
					list = mailContactHelper.GetMailContactsList(from, to, cc);
			
					// Directory name to be created in case Extract Attachments option is activated
					string directoryName = configuration.TempDirectoryPath + @"\" + guid;
					
					// OWApiHelper is a wrapper for OWApi Web Service InsertRegistry method.
					// If call is successfull, result will contain the ID of record created in tblEntities
					int result = OWApiHelper.InsertRegistry(userLogin, password, list, configuration, directoryName, guid, filePath, message.Attachments, subject, mailDate, body);
					
					//Not Register
					if (result==0)
					{
						throw new Exception("Não é possivel inserir o registo.");
					}
						

					// Clean up temporary message file
					if (File.Exists(filePath))
					{
						File.Delete(filePath);
					}

					// Clean up temporary attachments directory
					if (Directory.Exists(directoryName))
					{
						Directory.Delete(directoryName, true);
					}
				}
			}
			catch (Exception ex)
			{
				Exception ex2=null;
				log.WriteEntry(ex.Message + " " + ex.StackTrace, EventLogEntryType.Error);
				ex2 = ex.InnerException;
				while (ex2!=null)
				{
					log.WriteEntry(ex2.Message + " " + ex2.StackTrace, EventLogEntryType.Error);
					ex2 = ex.InnerException;
				}				
				throw ex;
			}
			finally
			{
				// Always cleans up unmanaged resources
				if (stream != null)
				{
					stream.Close();
				}

				if (recItem != null)
				{
					recItem.Close();
				}
			}
		}

		/// <summary>
		/// Called by a store when an item is being deleted.
		/// NOTE: This method is not used in this implementation. It is included here only to respect interface contract.
		/// </summary>
		/// <param name="pEventInfo">A pointer to an IExStoreEventInfo Interface that can be used to obtain additional information related to the event.</param>
		/// <param name="bstrURLItem">A string containing a URL to the item that will be deleted upon successful completion of all synchronous events. When the transaction is open, this variable is unlocked.</param>
		/// <param name="lFlags">Bitwise AND flag gives further information about the delete event.</param>
		public void OnSyncDelete(IExStoreEventInfo pEventInfo, string bstrURLItem, int lFlags)
		{
		}
	}
}