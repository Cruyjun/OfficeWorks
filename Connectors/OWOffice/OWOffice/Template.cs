using System;
using OfficeWorks.OWOffice.Bookmarks;
using OfficeWorks.OWOffice.BasicOrganizationalUnits;
using OfficeWorks.OWOffice.Common;
using OfficeWorks.OWOffice.OWApiWebService;
using OfficeWorks.OWOffice.COMMONWebService;
using System.Runtime.InteropServices;
using System.Security.Principal;
using OfficeWorks.OWOffice.Configuration;
using OfficeWorks.OWOffice.Lists;
using System.Diagnostics;
using System.Collections;
using System.Net;
using System.Web;
using System.Web.Services.Protocols;

namespace OfficeWorks.OWOffice
{

	#region Template Interface
	
	/// <summary>
	/// ITemplate Interface
	/// </summary>
	[Guid("46E4471B-F53F-420c-95C9-ED10A78B63B7"), ComVisible(true)]		
	public interface ITemplate
	{
		FileCollection AttachedFiles { get; }
		BookmarkCollation Bookmarks { get; }
		bool IsLoaded { get;}
		bool ShowRegistry {get; set; }
		string BookAbreviation { get;}
		string BookDescription { get;}
		string InsertedRegistryYear { get;}
		string InsertedRegistryNumber { get;}			
		string WebServerURL  { get;}
		string WebServiceAPIURL { get;}		
		string WebServiceCommonURL { get;}		
		string WebServiceProcessURL { get;}
		string ConfigurationFile { get;}
		string ConfigurationXML { get;}
		bool Convert2PDF { get;}
		string TemplateName { get;}		
		FileCollection AttachedFilesForSignature { get; }		
		BasicOrganizationalUnitCollation Accesses{ get; }
		string InsertedProcessID { get;}		
		string InsertedProcessNumber { get;}		
		FileCollection AttachedFilesForProcess { get; }
		
		void LoadConfiguration(string ConfigurationFile, string TemplateName, string AlternativeWebServerURL);
		bool InsertRegistry();	
		bool AddRegistryFiles();
		void ClearData();
		ListItemCollection GetListItems(string ListName);
		BookmarkCollation GetFields(bool JustRequiredFields);
		ListItemCollection GetUserSignaturesAccesses();
		byte[] GetUserSignature(int userID);
		BasicOrganizationalUnitCollation SearchOrganizationalUnits(string Description, int Type);
		BasicOrganizationalUnitCollation GetOrganizationalUnitsByBook();
		bool RequestForUserSignature(string flowCode, string subject, FileCollection files);
		bool ValidateUserLogin(string sPassword);
		bool AddProcessFiles(int processID, FileCollection files, bool newProcessEvent);
		string GetProcessStageCode(int userID, int processID);
	}

	#endregion

	#region Template Class

	/// <summary>
	/// Template Class
	/// </summary>
	[Guid("1F0DD547-A8A4-4a62-9902-19840715A5F1"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class Template : ITemplate 
	{		

		#region Fields
		
		/// <summary>
		/// class instance that supports the Mapping configuration
		/// </summary>
		private OWC owc;

		/// <summary>
		/// class instance that supports the OfficeWorks WebService API Connection
		/// </summary>
		private OWApi webServiceAPI;

		/// <summary>
		/// class instance that supports the OfficeWorks WebService Common Connection
		/// </summary>
		private COMMONWebService.Common webServiceCommon;

		/// <summary>
		/// class instance that supports the OfficeWorks WebService Process Connection
		/// </summary>
		private PROCESSWebService.Process webServiceProcess;

		/// <summary>
		/// Current Logon User Name
		/// </summary>
		private string currentUserName;

		/// <summary>
		/// Collection of Attached Files
		/// </summary>
		private FileCollection attachedFiles;

		
		/// <summary>
		/// Collection of BasicOrganizationalUnits with registry access
		/// </summary>
		private BasicOrganizationalUnitCollation accesses;

		/// <summary>
		/// Collection of Bookmarks
		/// </summary>
		private BookmarkCollation bookmarks;
		
		/// <summary>
		/// Show Register when inserted
		/// </summary>
		private bool showRegistry;

		/// <summary>
		/// Template Configuration file path
		/// </summary>
		private string configurationFile;
		
		/// <summary>
		/// Template Configuration Object
		/// </summary>
		private TemplateCfg templateCfg;

		/// <summary>
		/// Book ID (Identifier of Book).
		/// </summary>
		private long bookID;

		/// <summary>
		/// DocumentType ID (Identifier of DocumentType).
		/// </summary>
		private int documentTypeID;

		/// <summary>
		/// Struct with dynamic fields
		/// </summary>
		private stDynamicField[] dynamicFields;

		/// <summary>
		/// Configured Book Abreviation
		/// </summary>		
		private string bookAbreviation; 

		/// <summary>
		/// Configured Book Description
		/// </summary>		
		private string bookDescription; 

		/// <summary>
		/// Last Inserted Registry Year
		/// </summary>		
		private string insertedRegistryYear; 

		/// <summary>
		/// Last Inserted Registry Number
		/// </summary>				
		private string insertedRegistryNumber; 
		
		/// <summary>
		/// Current Registry Data
		/// </summary>
		private stRegistry registryData;

		/// <summary>
		/// Collection of Attached Files for signature
		/// </summary>
		private FileCollection attachedFilesForSignature;

		/// <summary>
		/// Inserted Process ID for signature
		/// </summary>				
		private string insertedProcessID; 

		/// <summary>
		/// Inserted Process Number for signature
		/// </summary>				
		private string insertedProcessNumber; 

		/// <summary>
		/// Collection of Attached Files for process
		/// </summary>
		private FileCollection attachedFilesForProcess;

		#endregion

		#region Properties

		/// <summary>
		/// Collection of Attached Files
		/// </summary>
		public FileCollection AttachedFiles 
		{
			get { return this.attachedFiles; }
		}

		/// <summary>
		/// Collection of Bookmarks
		/// </summary>
		public BookmarkCollation Bookmarks 
		{
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}
				return this.bookmarks; 
			}
		}

		
		/// <summary>
		/// Collection of BasicOrganizationalUnits with registry access
		/// </summary>
		public BasicOrganizationalUnitCollation Accesses
		{
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}
				return this.accesses; 
			}
		}

		/// <summary>
		/// Tests if the method Load Configuration was executed
		/// </summary>
		public bool IsLoaded
		{
			get { return (this.configurationFile.Trim().Length > 0); }
		}

		/// <summary>
		/// Show Register when inserted
		/// </summary>
		public bool ShowRegistry 
		{			
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}
				return this.showRegistry; 
			}
			set { this.showRegistry = value; }
		}


		
		/// <summary>
		/// Template configuration file path
		/// </summary>		
		public string ConfigurationFile
		{			
			get 
			{ 
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}
				return this.configurationFile; 
			}
		}


		/// <summary>
		/// Template configuration XML
		/// </summary>		
		public string ConfigurationXML
		{			
			get 
			{ 
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}

				return this.owc.OwcXMLData; 
			}
		}

		/// <summary>
		/// Configured Book Abreviation
		/// </summary>		
		public string BookAbreviation
		{			
			get { return this.bookAbreviation; }
		}

		/// <summary>
		/// Configured Book Description
		/// </summary>		
		public string BookDescription
		{			
			get { return this.bookDescription; }
		}

		/// <summary>
		/// Last Inserted Registry Year
		/// </summary>		
		public string InsertedRegistryYear
		{			
			get { return this.insertedRegistryYear; }
		}

		/// <summary>
		/// Last Inserted Registry Number
		/// </summary>		
		public string InsertedRegistryNumber
		{			
			get { return this.insertedRegistryNumber; }
		}

		
		/// <summary>
		/// Configure the template's name 
		/// </summary>		
		public string WebServerURL 
		{
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}

				return this.owc.WebServerUrl;
			}
		}


		/// <summary>
		/// Get WebService API URL 
		/// </summary>		
		public string WebServiceAPIURL 
		{
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}

				return this.webServiceAPI.Url;
			}
		}


		/// <summary>
		/// Get WebService Common URL 
		/// </summary>		
		public string WebServiceCommonURL 
		{
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}

				return this.webServiceCommon.Url;
			}
		}


		/// <summary>
		/// Get WebService Process URL 
		/// </summary>		
		public string WebServiceProcessURL 
		{
			get 
			{
				//validate Configuration file
				if(this.configurationFile.Trim().Length == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
				}

				return this.webServiceProcess.Url;
			}
		}

		/// <summary>
		/// Return template's name 
		/// </summary>		
		public string TemplateName 
		{			
			get { return (this.templateCfg == null || this.templateCfg.TemplateName == null? "" :this.templateCfg.TemplateName); }
		}		

		/// <summary>
		/// Convert Word Document to PDF?
		/// </summary>
		public bool Convert2PDF 
		{
			get { return this.templateCfg.PDFConvert; }
		}

		
		/// <summary>
		/// Returns current Registry Data
		/// </summary>
		private stRegistry RegistryData
		{
			get
			{
				if (this.registryData == null)
					this.registryData = this.MappOfficeWorksData();

				return this.registryData;
			}
		}

		/// <summary>
		/// Collection of Attached Files for Signature
		/// </summary>
		public FileCollection AttachedFilesForSignature 
		{
			get { return this.attachedFilesForSignature; }
		}

		/// <summary>
		/// Inserted Process ID for signature
		/// </summary>		
		public string InsertedProcessID
		{			
			get { return this.insertedProcessID; }
		}
		
		/// <summary>
		/// Inserted Process Number for signature
		/// </summary>		
		public string InsertedProcessNumber
		{			
			get { return this.insertedProcessNumber; }
		}

		/// <summary>
		/// Collection of Attached Files for Process
		/// </summary>
		public FileCollection AttachedFilesForProcess 
		{
			get { return this.attachedFilesForProcess; }
		}

		#endregion

		#region Constructors
		public Template()
		{			
			this.owc = null;			
			this.webServiceAPI = null;	
			this.webServiceCommon = null;
			this.webServiceProcess = null;
			this.currentUserName = string.Empty;
			this.attachedFiles = new FileCollection();
			this.accesses = new BasicOrganizationalUnitCollation();			
			this.bookmarks = new BookmarkCollation();
			this.showRegistry = false;
			this.configurationFile = string.Empty;
			this.templateCfg = null;
			this.bookAbreviation = string.Empty;
			this.bookDescription = string.Empty;
			this.insertedRegistryYear = string.Empty;
			this.insertedRegistryNumber = string.Empty;
			this.registryData = null;
			this.attachedFilesForSignature = new FileCollection();
			this.insertedProcessID = string.Empty;
			this.insertedProcessNumber = string.Empty;
			this.attachedFilesForProcess = new FileCollection();
		}
		#endregion

		#region Methods
		
		#region Configuration File

		/// <summary>
		/// Load Configuration File (OWC)
		/// </summary>
		/// <param name="ConfigurationFile"></param>
		/// <param name="TemplateName"></param>
		public void LoadConfiguration(string ConfigurationFile, string TemplateName, string AlternativeWebServerURL)
		{
			try 
			{							
				//save Configuration File Path 
				this.configurationFile = ConfigurationFile;				

				//ini configuration class
				this.owc = new OWC(this.configurationFile);

				//Set Alternative URL
				if (AlternativeWebServerURL != null && AlternativeWebServerURL.Trim().Length>0)
					this.owc.WebServerUrl = AlternativeWebServerURL;

				//ini WebService class
				this.webServiceAPI = new OWApi();
				this.webServiceAPI.Credentials = CredentialCache.DefaultCredentials;
				this.webServiceAPI.Url = this.owc.WebServerUrl + OWC.kWEBSERVICE_OWApi;				
				
				//ini WebService Common Class
				this.webServiceCommon = new OfficeWorks.OWOffice.COMMONWebService.Common();
				this.webServiceCommon.Credentials = CredentialCache.DefaultCredentials;
				this.webServiceCommon.Url = this.owc.WebServerUrl + OWC.kWEBSERVICE_COMMON;		
		
				//ini WebService Process Class
				this.webServiceProcess = new PROCESSWebService.Process();
				this.webServiceProcess.Credentials = CredentialCache.DefaultCredentials;
				this.webServiceProcess.Url = this.WebServerURL + OWC.kWEBSERVICE_PROCESS;

				//ini current UserName varible
				this.currentUserName = WindowsIdentity.GetCurrent().Name;

				//Load Template Configuration
				foreach(TemplateCfg oTemplate in owc.Templates)
				{
					//If no template name exists get the first on configuration file
					if(TemplateName.Trim().Length == 0)
					{
						this.templateCfg = oTemplate;
						break;
					}
					else
					{
						//Find template name to get configuration file
						if(oTemplate.TemplateName.ToUpper().Trim() == TemplateName.ToUpper().Trim()) 					
						{
							this.templateCfg = oTemplate;
							break;
						}
					}
				}

				//Validate templateCfg
				if(this.templateCfg == null) 				
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.TemplateNotFOUND, TemplateName);
				}

				//Set ShowRegistry Property
				this.showRegistry = this.templateCfg.ShowRegistryDefault;
				//Set BookAbreviation Property
				this.bookAbreviation = this.templateCfg.BookAbreviation;
				//Set BookDescription Property
				this.bookDescription = this.templateCfg.BookDescription;

				//TestWebServices
				this.TestWebServices();

				//Get BookID by BookAbreviation
				stBook[] arrBooks = this.webServiceAPI.GetAllBooks();
				foreach (stBook book in arrBooks)				
					if (book.BookAbreviation.Trim().ToLower() == this.templateCfg.BookAbreviation.Trim().ToLower())
					{
						this.bookID = book.BookID;
						break;
					}

				//Validate the Template's book configuration
				if(this.bookID == 0) 
				{
					throw new OWOfficeException(OWOfficeException.enumExceptionsID.BookNotFOUND, this.TemplateName);
				}
				

				//Get DocumentTypeID by BookID and DocumentAbreviation
				stDocumentType[] arrDocType = this.webServiceAPI.GetDocumentTypesByBook(this.bookID);
				foreach (stDocumentType docType in arrDocType)
				{
					if (docType.DocumentTypeAbreviation.Trim().ToLower() == this.templateCfg.DocumentTypeAbreviation.Trim().ToLower())
					{
						this.documentTypeID = (int) docType.DocumentTypeID;
						break;
					}
				}
				
				//Test All Configuration			
				this.TestConfigurationFile(this.TemplateName);
				
			}
			catch(OWOfficeException ex)
			{
				throw ex;
			}
			catch(Exception) 
			{				
				//reset objects
				this.owc = null;
				this.webServiceAPI = null;
				this.webServiceProcess = null;
				this.webServiceCommon = null;
				this.currentUserName = string.Empty;
				this.configurationFile = string.Empty;
				// Report Error
				this.TestConfigurationFile(TemplateName);
			}			

		}


		/// <summary>
		/// Test All Configuration
		/// </summary>
		/// <param name="TemplateName">Template Name</param>
		private void TestConfigurationFile(string TemplateName) 
		{
			//validate Configuration file
			if(this.configurationFile.Trim().Length == 0) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingConfigurationFilePath);
			}

			
			//bad configuration file
			if(this.owc == null) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.ConfigurationFileERROR, this.configurationFile);
			}


			//validate this.templateCfg OBJECT
			if(this.templateCfg == null) // if Template notfound then throw exception				
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.TemplateNotFOUND, TemplateName);
			}	

			//bad login
			if(this.currentUserName == null || this.currentUserName.Trim().Length == 0) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.LoginERROR);
			}
			
			// Test Just Web Services
			this.TestWebServices();
			
		}

		/// <summary>
		/// Test Just Web Services
		/// </summary>
		private void TestWebServices() 
		{
			//bad service
			try
			{
				string JustToTest = this.webServiceAPI.GetVersion();
			}
			catch(Exception)
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.ServiceNotFOUND, this.WebServerURL);
			}			
		}
		#endregion

		#region Registry Operations

		/// <summary>
		/// Test if the a Value is numeric
		/// </summary>
		/// <param name="Value">value to test</param>
		/// <returns></returns>
		private bool IsNumeric(string Value) 
		{
			try 
			{
				double Val = Convert.ToDouble(Value);
				return true;
			}
			catch(Exception) 
			{
				return false;
			}
		}


		/// <summary>
		/// Test if a Value is a date
		/// </summary>
		/// <param name="Value">Value to test</param>
		/// <returns></returns>
		private bool IsDate(string Value) 
		{
			try 
			{
				DateTime Val = DateTime.Parse(Value);
				return true;
			}
			catch(Exception) 
			{
				return false;
			}
		}


		/// <summary>
		/// Search for required fields that was not supplied and throw an RequiredFields exception!
		/// </summary>
		private void TestRequiredFields() 
		{
			//validate Configuration file	
			//AND
			//validate Template name
			// if this method becomes public
			//.. assuming that's true

			//VALIDATE this.templateCfg OBJECT
			if(this.templateCfg == null) // if Template notfound then throw exception				
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.TemplateNotFOUND);
			}

			

			//Find required fields
			string sBookmaks = "";
			foreach(MappedField oMapp in this.templateCfg.MappedFields) 
			{
				//if it is a required field
				if(oMapp.RequiredField) 
				{
					bool bFound = false;
					foreach(Bookmark oBookMark in this.Bookmarks) 
					{
						if(oBookMark.Name.Split('_')[0].ToUpper().Trim() == oMapp.BookmarkName.ToUpper().Trim() && oBookMark.Value != null && oBookMark.Value.Trim().Length > 0) 
						{
							bFound = true;
						}
					}

					//if not found and 
					sBookmaks += (!bFound ? "\n\r" + oMapp.BookmarkName : "");
				}
			}
			
			// Test Required Accesses
			sBookmaks += (this.Accesses.Count == 0 && this.templateCfg.AccessesRiquired ? "\n\r ACESSOS" : "");				

			if(sBookmaks.Length > 0) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.RequiredFields, sBookmaks);
			}
		}


		/// <summary>
		/// Mapp all Bookmarks to a stRegistry to be inserted
		/// </summary>		
		/// <returns></returns>
		private stRegistry MappOfficeWorksData() 
		{
			// INI stRegistry
			stRegistry RegistryST = new stRegistry();
			ArrayList oDynamicFields = new ArrayList(); // ArrayList Aux			
			RegistryST.Entity = new stEntity();
			RegistryST.Book = new stBook();
			RegistryST.User = new stUser();
			RegistryST.DocumentType = new stDocumentType();
			ArrayList oKeywords = new ArrayList(); // ArrayList Aux
			ArrayList oMoreEntities = new ArrayList(); // ArrayList Aux			
			// **************

			

			//Set Book ID
			RegistryST.Book.BookID = this.bookID;
			//Set Document Type
			RegistryST.DocumentType.DocumentTypeID = this.documentTypeID;

			foreach(Bookmark oBookmark in this.Bookmarks) 
			{
				foreach(MappedField oMapp in this.templateCfg.MappedFields) 
				{
					//split WordBookmark for special cases ex: Classification_ID, Classification_AB1; DE_FULL, DE_FIRSTNAME, DE_LASTNAME etc..
					//if is a valid Mapp Field and bookmark exists in mapping configuration
					if(oMapp.ValidField && oBookmark.Name.Split('_')[0].ToUpper().Trim() == oMapp.BookmarkName.ToUpper().Trim()) 
					{
						//Ignore no data
						if(oBookmark.Value != null && oBookmark.Value.Trim().Length > 0) 
						{
							switch((enumFieldName)Convert.ToInt16(oMapp.FieldIdentifier)) 
							{
									/*case enumFieldName.FieldNameAccesses: NOT USED
										{
											break;
										}*/
								case enumFieldName.FieldNameBlock: //FieldNameBlock
								{
									RegistryST.Block = oBookmark.Value;
									break;
								}
									/*case enumFieldName.FieldNameBook: NOT USED
										{
											break;
										}*/
								case enumFieldName.FieldNameClassification: //Classification
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.Classification.ClassificationID = Convert.ToInt64(oBookmark.Value);
									break;
								}
								case enumFieldName.FieldNameCoin: //FieldNameCoin
								{
									RegistryST.Coin = oBookmark.Value;
									break;

								}
									/*case enumFieldName.FieldNameDistributions: NOT USED
										{
											break;
							
										}*/
								case enumFieldName.FieldNameDocumentDate: //FieldNameDocumentDate
								{
									//if not Date throw error type
									if(!IsDate(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.DocumentDate = DateTime.Parse(oBookmark.Value);
									break;

								}
									/*case enumFieldName.FieldNameDocumentType: NOT USED
										{
											break;
							
										}*/
								case enumFieldName.FieldNameEntity: //FieldNameEntity
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.Entity.EntityID = Convert.ToInt64(oBookmark.Value);
									break;
								}
									/*case enumFieldName.FieldNameFiles: NOT USED
										{
											break;
							
										}*/
								case enumFieldName.FieldNameKeywords: //FieldNameKeywords
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									stKeyword stKeyword = new stKeyword();
									stKeyword.KeywordID = Convert.ToInt64(oBookmark.Value);
									oKeywords.Add(stKeyword);
									break;
								}
								case enumFieldName.FieldNameMoreEntities: //FieldNameMoreEntities
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}
									
									stEntity oEntity = new stEntity();
									oEntity.EntityID = Convert.ToInt64(oBookmark.Value);
									if (oMapp.EntityType == OfficeWorks.OWOffice.enumEntityType.EntityTypeDestiny)
										oEntity.EntityType = OWOffice.OWApiWebService.enumEntityType.EntityTypeDestiny;								
									else
										oEntity.EntityType = OWOffice.OWApiWebService.enumEntityType.EntityTypeOrigin;									
									oMoreEntities.Add(oEntity);
									break;
								}
								case enumFieldName.FieldNameNumber: //FieldNameNumber
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.Number = Convert.ToInt64(oBookmark.Value);
									break;

								}
								case enumFieldName.FieldNameObservations: //FieldNameObservations
								{
								
									RegistryST.Observations = oBookmark.Value;
									break;

								}
									/*case enumFieldName.FieldNamePreviousRegistry: NOT USED
										{
											break;
							
										}*/
								case enumFieldName.FieldNameProcess: //FieldNameProcess
								{
									RegistryST.Process = oBookmark.Value;
									break;

								}
								case enumFieldName.FieldNameQuote: //FieldNameQuote
								{
									RegistryST.Quote = oBookmark.Value;
									break;

								}
								case enumFieldName.FieldNameReference: //FieldNameReference
								{
									RegistryST.Reference = oBookmark.Value;
									break;

								}
								case enumFieldName.FieldNameRegistryDate: //FieldNameRegistryDate
								{
									//if not Date throw error type
									if(!IsDate(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.RegistryDate = DateTime.Parse(oBookmark.Value);
									break;

								}
								case enumFieldName.FieldNameSubject: //FieldNameSubject
								{
									RegistryST.Subject = oBookmark.Value;
									break;

								}
								case enumFieldName.FieldNameValue: //FieldNameValue
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.Value = Convert.ToDouble(oBookmark.Value);
									break;

								}
								case enumFieldName.FieldNameYear: //FieldNameYear
								{
									//if not numeric throw error type
									if(!IsNumeric(oBookmark.Value)) 
									{
										throw new OWOfficeException(OWOfficeException.enumExceptionsID.TypeERROR, oBookmark.Name + " = " + oBookmark.Value);
									}

									RegistryST.Year = Convert.ToInt64(oBookmark.Value);
									break;

								}
								default: //Dynamic Field
								{
									//Get Dynamic Field By Name
									stDynamicField NewDynamic = this.GetDynamicFieldByName(oMapp.FieldName);
									if(NewDynamic != null)
									{
										//Set value
										NewDynamic.DynamicFieldValue = oBookmark.Value;
										//Add Dynamic field
										oDynamicFields.Add(NewDynamic);
									}
									break;
								}
							} //switch

						} //if no data

						break; //Next oBookmark from Word Template
					} //if is a valid field and bookmark exists in mappingconfiguration

				} //foreach		
			} //foreach

			//copy aux info			
			if(oDynamicFields.Count != 0) 
			{
				RegistryST.DynamicFields = new stDynamicField[oDynamicFields.Count];
				for(int iX = 0; iX < oDynamicFields.Count; iX++) 
				{
					RegistryST.DynamicFields[iX] = (stDynamicField)oDynamicFields[iX];
				}
			}
			if(oKeywords.Count != 0) 
			{
				RegistryST.Keywords = new stKeyword[oKeywords.Count];
				for(int iX = 0; iX < oKeywords.Count; iX++) 
				{
					RegistryST.Keywords[iX] = (stKeyword)oKeywords[iX];
				}
			}
			if(oMoreEntities.Count != 0) 
			{
				RegistryST.MoreEntities = new stEntity[oMoreEntities.Count];
				for(int iX = 0; iX < oMoreEntities.Count; iX++) 
				{
					RegistryST.MoreEntities[iX] = (stEntity)oMoreEntities[iX];
				}
			}

			return RegistryST;
		}


		/// <summary>
		/// Get Field By Field Name
		/// </summary>
		/// <param name="FieldName">Field Name</param>
		/// <returns></returns>
		private stDynamicField GetDynamicFieldByName(string FieldName)
		{
			if (this.dynamicFields == null)
				this.dynamicFields = this.webServiceAPI.GetBookFields(this.bookID);

			foreach(stDynamicField Field in this.dynamicFields)
				if (Field.DynamicFieldName.Trim().ToLower() == FieldName.Trim().ToLower())
					return Field;

			//Field Not Found!!
			return null;
		}


		/// <summary>
		/// Insert OfficeWorksMappingData in OfficeWorks using OfficeWorks Web Service
		/// </summary>		
		/// <returns>true if insert ok, false if any error</returns>
		public bool InsertRegistry() 
		{
			this.TestConfigurationFile(this.TemplateName);

			//validate required fields
			this.TestRequiredFields();
						
			//*********************************
			// Attach Files to Registry
			//*********************************
			this.RegistryData.Files = new stFile[this.AttachedFiles.Count];						
			for(int iX = 0; iX < this.AttachedFiles.Count; iX ++) 
			{				
				this.RegistryData.Files[iX] = this.AttachedFiles[iX];
			}
			

			//*********************************
			// Add Registry Accesses
			//*********************************				
			if (this.templateCfg.AccessesRiquired || this.Accesses.Count != this.GetOrganizationalUnitsByBook().Count)
			{
				//Set Registry accesses***********
				this.RegistryData.Accesses = new OWApiWebService.BasicOrganizationalUnit[this.Accesses.Count];						
				for(int iX = 0; iX < this.Accesses.Count; iX ++) 
				{				
					OWApiWebService.BasicOrganizationalUnit bou = new OWApiWebService.BasicOrganizationalUnit();
					bou.Description = this.Accesses[iX].Description;
					bou.ID = this.Accesses[iX].ID;
					bou.Type = (OWApiWebService.OrganizationalUnitTypeEnum) this.Accesses[iX].type;
					this.RegistryData.Accesses[iX] = bou;
				}
			}
			else
			{
				//Set default book accesses***********
				this.RegistryData.Accesses = new OWApiWebService.BasicOrganizationalUnit[0];
			}
			

			//Set Current User Name
			this.RegistryData.User.UserLogin = this.currentUserName;

			//Insert Registry Data
			long lReg_ID = this.webServiceAPI.InsertRegistry(this.currentUserName, "", ref this.registryData);
		
			//Get Registry Number
			this.insertedRegistryNumber = this.RegistryData.Number.ToString();
			//Get Registry Year
			this.insertedRegistryYear = this.RegistryData.Year.ToString();	
			//Get RegistryID
			this.RegistryData.RegistryID = lReg_ID;

			//HierarchicAccess if config.
			if(this.templateCfg.HierarchicAccess) 
			{
				this.webServiceAPI.SetHierarchicalAccess(lReg_ID, this.currentUserName, enumAccessObject.User);
			}

			//Show Registry Page
			if(this.ShowRegistry) 
			{
				string sRegistryUrl = "";
				
				string qString = string.Empty;
				if (this.RegistryData.Process!= null && this.RegistryData.Process != string.Empty && this.RegistryData.Process.StartsWith("&ADHOCFLOWDISTRIBS="))
					qString = this.RegistryData.Process;

				//Get Url
				sRegistryUrl = this.owc.WebServerUrl + "/Register/ShowRegister.aspx?WCI=MostraRegisto&ShowBackButton=FALSE&id=" + lReg_ID.ToString() + qString;
				
				//Show			
				Process.Start(sRegistryUrl);				
			}

			return true;
		}


		/// <summary>
		/// Modify OfficeWorksMappingData in OfficeWorks using OfficeWorks Web Service
		/// </summary>		
		/// <returns>true if insert ok, false if any error</returns>
		public bool AddRegistryFiles() 
		{
			//There isn't any data to modify
			if (this.registryData != null && this.registryData.RegistryID == 0)
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.MissingInsertMethod);

			//Attach Files to Registry
			if(this.AttachedFiles.Count > 0) 
			{
				this.RegistryData.Files = new stFile[this.AttachedFiles.Count];
				for(int iX = 0; iX < this.AttachedFiles.Count; iX ++) 
				{					
					this.RegistryData.Files[iX] = this.AttachedFiles[iX];
				}
			}

			this.webServiceAPI.AttachFiles(ref this.registryData);
			
			//Show Registry Page
			if(this.ShowRegistry) 
			{
				string sRegistryUrl = "";

				string qString = string.Empty;
				if (this.RegistryData.Process!= null && this.RegistryData.Process != string.Empty && this.RegistryData.Process.StartsWith("&ADHOCFLOWDISTRIBS="))
					qString = this.RegistryData.Process;

				//Get Url
				sRegistryUrl = this.owc.WebServerUrl + "/Register/ShowRegister.aspx?WCI=MostraRegisto&ShowBackButton=FALSE&id=" + this.registryData.RegistryID.ToString() + qString;

				//Show			
				Process.Start(sRegistryUrl);				
			}

			return true;
		}


		/// <summary>
		/// Clear all data that belongs to a registry info
		/// </summary>
		public void ClearData()
		{			
			this.attachedFiles = new FileCollection();
			this.bookmarks = new BookmarkCollation();	
			this.accesses = new BasicOrganizationalUnitCollation();
			this.insertedRegistryYear = string.Empty;
			this.insertedRegistryNumber = string.Empty;
			this.registryData = null;
		}


		/// <summary>
		/// Get All items from a given Name List
		/// </summary>
		/// <param name="ListName">List Name</param>
		/// <returns></returns>
		public ListItemCollection GetListItems(string ListName) 
		{
			this.TestConfigurationFile(this.TemplateName);

			try 
			{
				ListItemCollection oNewList = new ListItemCollection();

				//get Items
				stItem[] Items = this.webServiceAPI.GetRegistryListValues(ListName);

				//for (int iX = 0 ; iX < Items.Length ; iX++)
				foreach(stItem oItem in Items) 
				{
					oNewList.AddItem(oItem.Identifier, oItem.Value);
				}

				return oNewList;
			}
			catch(Exception) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.ServiceNotFOUND, this.owc.WebServerUrl);
			}

		}

		/// <summary>
		/// Get All items from a given Name List
		/// </summary>
		/// <param name="Description"></param>
		/// <param name="Type"></param>
		/// <returns></returns>
		public BasicOrganizationalUnitCollation SearchOrganizationalUnits(string Description, int Type)
		{
			
			this.TestConfigurationFile(this.TemplateName);

			try 
			{
				
			
				COMMONWebService.OrganizationalUnitFilter Filter = new OrganizationalUnitFilter();

				Filter.Description = Description.Trim();
				Filter.OrganizationalUnitType = Type; //0 = all ; 1 = user ; 2 = Group
				
				
				//-----------------------------------
				// Get OrganizationalUnits collection
				//-----------------------------------
				COMMONWebService.BasicOrganizationalUnit[] ous = webServiceCommon.GetOrganizationalUnits(Filter);
				BasicOrganizationalUnitCollation bous = new BasicOrganizationalUnitCollation();

				foreach (COMMONWebService.BasicOrganizationalUnit ou in ous)
				{
					OWOffice.BasicOrganizationalUnits.BasicOrganizationalUnit bou = new OfficeWorks.OWOffice.BasicOrganizationalUnits.BasicOrganizationalUnit();
					bou.description = ou.Description;
					bou.id = ou.ID;
					bou.type = (int)ou.Type;
					//-------------------
					// Add Collection
					//-------------------
					bous.Add(bou);
				}

				return bous;
			}
			catch(Exception) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.ServiceNotFOUND, this.owc.WebServerUrl);
			}

		}




		/// <summary>
		/// Get Organizational units that have access in current bookid
		/// </summary>
		/// <returns></returns>
		public BasicOrganizationalUnitCollation GetOrganizationalUnitsByBook()
		{
			
			this.TestConfigurationFile(this.TemplateName);

			try 
			{				
				//-----------------------------------
				// Get OrganizationalUnits collection
				//-----------------------------------
				COMMONWebService.BasicOrganizationalUnit[] ous = webServiceCommon.GetBasicOrganizationalUnitsByRegistryBook(Convert.ToInt32(this.bookID));
				BasicOrganizationalUnitCollation bous = new BasicOrganizationalUnitCollation();

				foreach (COMMONWebService.BasicOrganizationalUnit ou in ous)
				{
					OWOffice.BasicOrganizationalUnits.BasicOrganizationalUnit bou = new OfficeWorks.OWOffice.BasicOrganizationalUnits.BasicOrganizationalUnit();
					bou.description = ou.Description;
					bou.id = ou.ID;
					bou.type = (int)ou.Type;
					//-------------------
					// Add Collection
					//-------------------
					bous.Add(bou);
				}

				return bous;
			}
			catch(Exception) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.ServiceNotFOUND, this.owc.WebServerUrl);
			}

		}


		/// <summary>
		/// Get the All/just the required fields configured in OWC
		/// </summary>
		/// <param name="JustRequiredFields">All/just the required fields flag</param>
		/// <returns></returns>
		public BookmarkCollation GetFields(bool JustRequiredFields) 
		{
			this.TestConfigurationFile(this.TemplateName);

			BookmarkCollation BookMarks = new BookmarkCollation();

			//Fill oOWMapps Class with OfficeWorks required fields
			foreach(MappedField oMapp in this.templateCfg.MappedFields) 
			{
				if ((JustRequiredFields && oMapp.RequiredField) || !JustRequiredFields)
					BookMarks.AddMapping(oMapp.BookmarkName, "");
			}

			return BookMarks;
		}

		#endregion

		#region Signature Operations

		/// <summary>
		/// Get users for select signatures
		/// </summary>
		/// <returns></returns>
		public ListItemCollection GetUserSignaturesAccesses()
		{
			try 
			{
				ListItemCollection oNewList = new ListItemCollection();
				
				//get users
				PROCESSWebService.stUser[] users = this.webServiceProcess.GetUserSignaturesAccesses();
			
				foreach(PROCESSWebService.stUser user in users) 
				{
					oNewList.AddItem(user.UserID, user.UserDescription);
				}

				return oNewList;
			}
			catch(Exception) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, "Não foi possível obter os utilizadores para escolher a assinatura");
			}
		}

		/// <summary>
		/// Get user signature
		/// </summary>
		/// <param name="userID"></param>
		/// <returns></returns>
		public byte[] GetUserSignature(int userID)
		{
			try 
			{				
				//get user signature				
				return this.webServiceProcess.GetUserSignature(userID);
			}
			catch(Exception) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, "Não foi possível obter a assinatura do utilizador");
			}		
		}

		/// <summary>
		/// Request for user signature
		/// </summary>
		/// <param name="flowCode"></param>
		/// <param name="subject"></param>
		/// <returns></returns>
		public bool RequestForUserSignature(string flowCode, string subject, FileCollection files)
		{
			try 
			{				
				PROCESSWebService.stFile[] filesws = new OfficeWorks.OWOffice.PROCESSWebService.stFile[files.Count];
				for(int iX = 0; iX < files.Count; iX++)
				{
					filesws[iX] = new PROCESSWebService.stFile();
					filesws[iX].FileName = files[iX].FileName;
					filesws[iX].FileArray = files[iX].FileArray;
				}

				//Insert process
				PROCESSWebService.ProcessSummary psws = this.webServiceProcess.StartProcessAndSave(flowCode, subject, filesws);
				
				//Get Process ID and Number
				this.insertedProcessID = psws.ID.ToString();
				this.insertedProcessNumber = psws.ProcessNumber;

				return true;
			}
			catch(SoapException soapex)
			{
				string message = "Não foi possível efectuar o pedido de assinatura";
				if(soapex.Code.Name != "Other")
					message = HttpUtility.HtmlDecode(soapex.Message);

				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, message);
			}
			catch(Exception)
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, "Não foi possível efectuar o pedido de assinatura");
			}		
		}

		/// <summary>
		/// Add files to process
		/// </summary>
		/// <param name="processID"></param>
		/// <param name="files"></param>
		/// <returns></returns>
		public bool AddProcessFiles(int processID, FileCollection files, bool newProcessEvent)
		{
			try
			{
				
				PROCESSWebService.stFile[] filesws = new OfficeWorks.OWOffice.PROCESSWebService.stFile[files.Count];
				for(int iX = 0; iX < files.Count; iX++)
				{
					filesws[iX] = new PROCESSWebService.stFile();
					filesws[iX].FileName = files[iX].FileName;
					filesws[iX].FileArray = files[iX].FileArray;
				}
			
				//Add files to process
				PROCESSWebService.ProcessSummary psws = this.webServiceProcess.AddProcessFiles(processID, filesws, newProcessEvent);

				return true;
			}
			catch(SoapException soapex)
			{
				string message = "Não foi possível anexar o documento ao processo";
				if(soapex.Code.Name != "Other")
					message = HttpUtility.HtmlDecode(soapex.Message);

				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, message);
			}
			catch(Exception)
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, "Não foi possível anexar o documento ao processo");
			}				
		}

		/// <summary>
		/// Get current process stage code tag to associate with document bookmark signature
		/// </summary>
		/// <param name="userID"></param>
		/// <param name="processID"></param>
		/// <returns></returns>
		public string GetProcessStageCode(int userID, int processID)
		{
			try 
			{				
				return this.webServiceProcess.GetProcessStageCode(userID, processID);
			}
			catch(Exception) 
			{
				return string.Empty;
			}
		}

		/// <summary>
		/// Validate user on webservice
		/// </summary>
		/// <param name="sPassword"></param>
		/// <returns></returns>
		public bool ValidateUserLogin(string sPassword)
		{
			try 
			{				
				//Initialize webservice
				PROCESSWebService.Process testPWS = new PROCESSWebService.Process();
				testPWS.Credentials = new NetworkCredential(this.currentUserName.Split('\\')[1], sPassword, this.currentUserName.Split('\\')[0]);
				testPWS.Url = this.WebServerURL + OWC.kWEBSERVICE_PROCESS;

				//Connect to web service
				testPWS.GetVersion();
				
				return true;
			}
			catch(Exception ex) 
			{
				string message = "Não foi possível validar a senha do utilizador";
				if(ex.Message.IndexOf("401") > -1)
					message = "Senha do utilizador inválida.";

				throw new OWOfficeException(OWOfficeException.enumExceptionsID.GenericMenssage, message);
			}
		}

		#endregion

		#endregion
	}
	
	#endregion

}
