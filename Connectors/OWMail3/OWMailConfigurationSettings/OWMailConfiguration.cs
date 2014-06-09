using System;
using System.Collections;
using System.Xml.Serialization;

namespace OfficeWorks
{

	/// <summary>
	/// Mapping Options
	/// </summary>
	public enum  MappingOptions
	{
		NoMapping = 1, // No mapping to do
		EntPrincipal = 2,
		MaisEntidadesOri = 3,
		MaisEntidadesDes = 4,
		Assunto = 5,
		Observacoes = 6,
		DataRegisto = 7,
		DataDocumento = 8
	}

	/// <summary>
	/// Mailbox fields to implement mappings with OfficeWorks fields
	/// </summary>
	public enum enumMailBoxMapping
	{
		From,
		To,
		Cc,
		Subject,
		Body,
		Received,
		ALL
		
	}

	/// <summary>
	/// Configuration settings and management for OWMail 2.0.
	/// The settings of this class instances are serialized and deserialized using OWMail 2.0 Administrator.
	/// </summary>
	[XmlInclude(typeof(OWMailConfiguration.Mailbox))]
	[XmlInclude(typeof(OWMailConfiguration.FromValues))]
	[XmlInclude(typeof(ListItem))]
	[XmlInclude(typeof(OWMailConfiguration.ToValues))]
	[XmlInclude(typeof(OWMailConfiguration.CcValues))]
	[XmlInclude(typeof(OWMailConfiguration.SubjectValues))]
	[XmlInclude(typeof(OWMailConfiguration.BodyValues))]
	[XmlInclude(typeof(OWMailConfiguration.ReceivedValues))]
	public class OWMailConfiguration 
	{
		// FROM
		private FromValues _from;
		public FromValues From
		{
			get
			{
				return _from;
			}
			set
			{
				_from = value;
			}
		}

		public class FromValues
		{
			private long _defaultValue;
			public long DefaultValue
			{
				get
				{
					return _defaultValue;
				}
				set
				{
					_defaultValue = value;
				}
			}

			public override bool Equals(object obj) 
			{
			
				if (obj == null || GetType() != obj.GetType())
				{
					return false;
				}

				FromValues from = (FromValues)obj;
					
				if (this.Values.Count != from.Values.Count)
				{
					return false;
				}

				return true;
				
			}
		
			public override int GetHashCode() 
			{
				return new Random().Next();
			}
			
			private ArrayList _values;
			public ArrayList Values
			{
				get
				{
					return _values;
				}
				set
				{
					_values = value;
				}
			}
		}
		
		//TO
		private ToValues _to;
		public ToValues To
			{
				get
				{
					return _to;
				}
				set
				{
					_to = value;
				}
			}
			public class ToValues
			{
				private long _defaultValue;
				public long DefaultValue
				{
					get
					{
						return _defaultValue;
					}
					set
					{
						_defaultValue = value;
					}
				}

				public override bool Equals(object obj) 
				{
			
					if (obj == null || GetType() != obj.GetType())
					{
						return false;
					}

					ToValues to = (ToValues)obj;
					
					if (this.Values.Count != to.Values.Count)
					{
						return false;
					}

					return true;
				
				}
		
				public override int GetHashCode() 
				{
					return new Random().Next();
				}

				private ArrayList _values;
				public ArrayList Values
				{
					get
					{
						return _values;
					}
					set
					{
						_values = value;
					}
				}
			}

		//CC
		private CcValues _cc;
		public CcValues Cc
		{
			get
			{
				return _cc;
			}
			set
			{
				_cc = value;
			}
		}
		
		public class CcValues
		{
			private long _defaultValue;
			public long DefaultValue
			{
				get
				{
					return _defaultValue;
				}
				set
				{
					_defaultValue = value;
				}
			}

			public override bool Equals(object obj) 
			{
			
				if (obj == null || GetType() != obj.GetType())
				{
					return false;
				}

				CcValues cc = (CcValues)obj;
					
				if (this.Values.Count != cc.Values.Count)
				{
					return false;
				}

				return true;
				
			}
		
			public override int GetHashCode() 
			{
				return new Random().Next();
			}

			private ArrayList _values;
			public ArrayList Values
			{
				get
				{
					return _values;
				}
				set
				{
					_values = value;
				}
			}
		}
		
		//Subject
		private SubjectValues _subject;
		public SubjectValues Subject
		{
			get
			{
				return _subject;
			}
			set
			{
				_subject = value;
			}
		}
		public class SubjectValues
		{
			private long _defaultValue;
			public long DefaultValue
			{
				get
				{
					return _defaultValue;
				}
				set
				{
					_defaultValue = value;
				}
			}

			public override bool Equals(object obj) 
			{
			
				if (obj == null || GetType() != obj.GetType())
				{
					return false;
				}

				SubjectValues subject = (SubjectValues)obj;
					
				if (this.Values.Count != subject.Values.Count)
				{
					return false;
				}

				return true;
				
			}
		
			public override int GetHashCode() 
			{
				return new Random().Next();
			}

			private ArrayList _values;
			public ArrayList Values
			{
				get
				{
					return _values;
				}
				set
				{
					_values = value;
				}
			}
		}
		//Body
		private BodyValues _body;
		public BodyValues Body
		{
			get
			{
				return _body;
			}
			set
			{
				_body = value;
			}
		}
		public class BodyValues
		{
			private long _defaultValue;
			public long DefaultValue
			{
				get
				{
					return _defaultValue;
				}
				set
				{
					_defaultValue = value;
				}
			}

			public override bool Equals(object obj) 
			{
			
				if (obj == null || GetType() != obj.GetType())
				{
					return false;
				}

				BodyValues body = (BodyValues)obj;
					
				if (this.Values.Count != body.Values.Count)
				{
					return false;
				}

				return true;
				
			}
		
			public override int GetHashCode() 
			{
				return new Random().Next();
			}

			private ArrayList _values;
			public ArrayList Values
			{
				get
				{
					return _values;
				}
				set
				{
					_values = value;
				}
			}
		}

		//Received
		private ReceivedValues _received;
		public ReceivedValues Received
		{
			get
			{
				return _received;
			}
			set
			{
				_received = value;
			}
		}


		public class ReceivedValues
		{
			private long _defaultValue;
			public long DefaultValue
			{
				get
				{
					return _defaultValue;
				}
				set
				{
					_defaultValue = value;
				}
			}

			public override bool Equals(object obj) 
			{
			
				if (obj == null || GetType() != obj.GetType())
				{
					return false;
				}

				ReceivedValues received = (ReceivedValues)obj;
					
				if (this.Values.Count != received.Values.Count)
				{
					return false;
				}

				return true;
				
			}
		
			public override int GetHashCode() 
			{
				return new Random().Next();
			}

			private ArrayList _values;
			public ArrayList Values
			{
				get
				{
					return _values;
				}
				set
				{
					_values = value;
				}
			}
		}
 
		/// <summary>
		/// URL of OWApi installation to use for OfficeWorks communications.
		/// </summary>
		private string _webServiceUrl = string.Empty;
		public string WebServiceUrl
		{
			get
			{
				return _webServiceUrl;
			}
			set
			{
				_webServiceUrl = value;
			}
		}
 
		/// <summary>
		/// Directory path to use for creating temporary directory and files.
		/// </summary>
		private string _tempDirectoryPath = string.Empty;
		public string TempDirectoryPath
		{
			get
			{
				return _tempDirectoryPath;
			}
			set
			{
				_tempDirectoryPath = value;
			}
		}
		/// <summary>
		/// URL of OWApi installation to use for ExchangeServer communications
		/// </summary>
		private string _exchangeServer = string.Empty;
		public string ExchangeServer
		{
			get
			{
				return _exchangeServer;
			}
			set
			{
				_exchangeServer = value;
			}
		}
 
		/// <summary>
		/// List of configurated Mailboxes.
		/// </summary>
		private ArrayList _mailboxes = new ArrayList();
		public ArrayList Mailboxes
		{
			get
			{
				return _mailboxes;
			}
			set
			{
				_mailboxes = value;
			}
		}
 
		/// <summary>
		/// Default constructor.
		/// </summary>
		public OWMailConfiguration()
		{
		}
 
		/// <summary>
		/// Constructs an OWMailConfiguration instance with settings stored in a XML file.
		/// </summary>
		/// <param name="configurationFilePath">OWMail 2.0 configuration file path to use when loading settings.</param>
		public OWMailConfiguration(string configurationFilePath)
		{
			Read(configurationFilePath);
		}
 
		/// <summary>
		/// Loads an OWMailConfiguration instance with settings stored in a XML file.
		/// </summary>
		/// <param name="configurationFilePath">OWMail 2.0 configuration file path to use when loading settings.</param>
		public void Read(string configurationFilePath)
		{
			OWMailConfiguration configuration = new OWMailConfiguration();
			configuration = OWMailSerializer.Deserialize(configurationFilePath);
                  
			// As this method could be called at runtime, this call ensures data is actual
			Refresh(configuration);
		}
 
		/// <summary>
		/// Writes an XML file with values stored in a OWMailConfiguration instance.
		/// </summary>
		/// <param name="configurationFilePath">OWMail 2.0 configuration file path to use when writing values.</param>
		public void Write(string configurationFilePath)
		{
			OWMailSerializer.Serialize(this, configurationFilePath);
		}
 
		/// <summary>
		/// Keeps instance data settings synchronized with XML file data values
		/// </summary>
		/// <param name="configuration">An OWMailConfiguration instance to keep synchronized with the XML configuration file.</param>
		private void Refresh(OWMailConfiguration configuration)
		{
			WebServiceUrl = configuration.WebServiceUrl;
			TempDirectoryPath = configuration.TempDirectoryPath;
			Mailboxes = configuration.Mailboxes;
		}
         
		/// <summary>
		/// Returns the configured From for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>From ID identifier integer</returns>
		public MappingOptions GetFromMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions) mailbox.FromDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}

		/// <summary>
		/// Returns the configured To for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>To ID identifier integer</returns>
		public MappingOptions GetToMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions) mailbox.ToDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}

		/// <summary>
		/// Returns the configured Cc for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>Cc ID identifier integer</returns>
		public MappingOptions GetCcMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions) mailbox.CcDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}
		/// <summary>
		/// Returns the configured Bcc for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>Bcc ID identifier integer</returns>
		public MappingOptions GetBccMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions) mailbox.BccDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}

		/// <summary>
		/// Returns the configured Subject for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>Subject ID identifier integer</returns>
		public MappingOptions GetSubjectMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions)mailbox.SubjectDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}
		/// <summary>
		/// Returns the configured Body for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>Body ID identifier integer</returns>
		public MappingOptions GetBodyMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions) mailbox.BodyDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}


		/// <summary>
		/// Returns the configured Received for a given mailbox
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>Received ID identifier integer</returns>
		public MappingOptions GetReceivedMappingByMailboxName(string mailboxName)
		{
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					return (MappingOptions) mailbox.ReceivedDefault;
					//break;
				}
			}
			return MappingOptions.NoMapping;
		}
		
		/// <summary>
		/// Returns the configured BookId for a given mailbox.
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>BookId identifier integer</returns>
		public int GetBookIdByMailboxName(string mailboxName)
		{
			int bookId = 0;
 
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					bookId = mailbox.BookId;
					break;
				}
			}
                  
			return bookId;
		}
 
		/// <summary>
		/// Returns the configured DocumentTypeId for a given mailbox.
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>DocumentTypeId identifier integer</returns>
		public int GetDocumentTypeIdByMailboxName(string mailboxName)
		{
			int documentTypeId = 0;
 
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.ToLower() == mailboxName.ToLower())
				{
					documentTypeId = mailbox.DocumentTypeId;
					break;
				}
			}
                  
			return documentTypeId;
		}
 
		/// <summary>
		/// Returns the configured User Login for a given mailbox.
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>User Login string</returns>
		public string GetUserLoginByMailboxName(string mailboxName)
		{
			string userLogin = string.Empty;
 
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName == mailboxName)
				{
					userLogin = mailbox.UserLogin;
					break;
				}
			}
 
			return userLogin;
		}

		public string GetUserLoginByMailboxName(string mailboxName, char split)
		{
			string userLogin = string.Empty;
 
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName.Split(split)[0] == mailboxName)
				{
					userLogin = mailbox.UserLogin;
					break;
				}
			}
 
			return userLogin;
		}


		public string GetMailboxNameByUserLogin(string UserLogin)
		{
			string mailboxName = string.Empty;
 
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.UserLogin == UserLogin)
				{
					mailboxName = mailbox.MailboxName;
					break;
				}
			}
 
			return mailboxName;
		}
 
		/// <summary>
		/// Returns the configured Extract Attachments option for a given mailbox.
		/// </summary>
		/// <param name="mailboxName">Mailbox name to search for in the configuration.</param>
		/// <returns>TRUE if it's ok to extract attachments, otherwise returns FALSE</returns>
		public bool GetExtractAttachmentsByMailboxName(string mailboxName)
		{
			bool extract = false;
 
			foreach (Mailbox mailbox in Mailboxes)
			{
				if (mailbox.MailboxName == mailboxName)
				{
					extract = mailbox.ExtractAttachments;
					break;
				}
			}
 
			return extract;
		}
 
		/// <summary>
		/// Overrides Equals to allow checking configuration changes.
		/// </summary>
		/// <param name="obj">An OWMailConfiguration instance that will be compared against current instance.</param>
		/// <returns>TRUE in case objects compared are Equal, otherwise FALSE will be returned.</returns>
		public override bool Equals(object obj) 
		{

			if (obj == null || GetType() != obj.GetType())
			{
				return false;
			}
 
			OWMailConfiguration configuration = (OWMailConfiguration)obj;
                  
			if (this.WebServiceUrl != configuration.WebServiceUrl)
			{
				return false;
			}
  
			if (this.TempDirectoryPath != configuration.TempDirectoryPath)
			{
				return false;
			}
 
		
			 
			if (!this.From.Equals(configuration.From))
			{
				return false;
			}

			for (int x = 0; x < From.Values.Count; x++)
			{
				if (!((FromValues)this.From).Values[x].Equals(((FromValues)configuration.From).Values[x]))
				{
					return false;
				}
 			}

			if (!this.To.Equals(configuration.To))
			{
				return false;
			}

			for (int x = 0; x < To.Values.Count; x++)
			{
				if (!((ToValues)this.To).Values[x].Equals(((ToValues)configuration.To).Values[x]))
				{
					return false;
				}
			}

			if (!this.Cc.Equals(configuration.Cc))
			{
				return false;
			}

			for (int x = 0; x < Cc.Values.Count; x++)
			{
				if (!((CcValues)this.Cc).Values[x].Equals(((CcValues)configuration.Cc).Values[x]))
				{
					return false;
				}
			}
			
			if (!this.Subject.Equals(configuration.Subject))
			{
				return false;
			}

			for (int x = 0; x < Subject.Values.Count; x++)
			{
				if (!((SubjectValues)this.Subject).Values[x].Equals(((SubjectValues)configuration.Subject).Values[x]))
				{
					return false;
				}
			}
			if (!this.Body.Equals(configuration.Body))
			{
				return false;
			}

			for (int x = 0; x < Body.Values.Count; x++)
			{
				if (!((BodyValues)this.Body).Values[x].Equals(((BodyValues)configuration.Body).Values[x]))
				{
					return false;
				}
			}
			if (!this.Received.Equals(configuration.Received))
			{
				return false;
			}

			if (this.Mailboxes.Count != configuration.Mailboxes.Count)
			{
				return false;
			}

			for (int x = 0; x < Received.Values.Count; x++)
			{
				if (!((ReceivedValues)this.Received).Values[x].Equals(((ReceivedValues)configuration.Received).Values[x]))
				{
					return false;
				}
			}
			
			for (int x = 0; x < Mailboxes.Count; x++)
			{
				if (((Mailbox)this.Mailboxes[x]).BookId != ((Mailbox)configuration.Mailboxes[x]).BookId)
				{
					return false;
				}
 
				if (((Mailbox)this.Mailboxes[x]).DocumentTypeId != ((Mailbox)configuration.Mailboxes[x]).DocumentTypeId)
				{
					return false;
				}
 
				if (((Mailbox)this.Mailboxes[x]).MailboxName != ((Mailbox)configuration.Mailboxes[x]).MailboxName)
				{
					return false;
				}
 
				if (((Mailbox)this.Mailboxes[x]).UserLogin != ((Mailbox)configuration.Mailboxes[x]).UserLogin)
				{
					return false;
				}
 
				if (((Mailbox)this.Mailboxes[x]).ExtractAttachments != ((Mailbox)configuration.Mailboxes[x]).ExtractAttachments)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).FromDefault != ((Mailbox)configuration.Mailboxes[x]).FromDefault)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).ToDefault != ((Mailbox)configuration.Mailboxes[x]).ToDefault)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).CcDefault != ((Mailbox)configuration.Mailboxes[x]).CcDefault)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).BccDefault != ((Mailbox)configuration.Mailboxes[x]).BccDefault)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).SubjectDefault != ((Mailbox)configuration.Mailboxes[x]).SubjectDefault)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).BodyDefault != ((Mailbox)configuration.Mailboxes[x]).BodyDefault)
				{
					return false;
				}

				if (((Mailbox)this.Mailboxes[x]).ReceivedDefault != ((Mailbox)configuration.Mailboxes[x]).ReceivedDefault)
				{
					return false;
				}


			}
 
			return true;
		}
            

		/// <summary>
		/// GetHashCode override is needed when implementing Equals.
		/// It allows a given instance to have a unique identifier so it can be distinguished when doing the comparison.
		/// </summary>
		/// <returns>An uniquely identifier integer</returns>
		public override int GetHashCode() 
		{
			return new Random().Next();
		}
 
		/// <summary>
		/// As Mailboxes are a PART OF a OWMailConfiguration, a nested class was used.
		/// ICompararer is implemented to allow checking of a duplicate mailbox when 
		/// inserting into configuration.
		/// </summary>
		public class Mailbox : IComparer
		{
			/// <summary>
			/// Name of mailbox.
			/// </summary>
			private string _mailboxName = string.Empty;
			public string MailboxName
			{
				get
				{
					return _mailboxName;
				}
				set
				{
					_mailboxName = value;
				}
			}
			/// <summary>
			/// Identifier of Book to use when saving OfficeWorks records.
			/// </summary>
			private int _bookId = 0;
			public int BookId
			{
				get
				{
					return _bookId;
				}
				set
				{
					_bookId = value;
				}
			}
 

			/// <summary>
			/// Identifier of DocumentType to use when saving OfficeWorks records.
			/// </summary>
			private int _documentTypeId = 0;
			public int DocumentTypeId
			{
				get
				{
					return _documentTypeId;
				}
				set
				{
					_documentTypeId = value;
				}
			}
 

			/// <summary>
			/// User login to use when saving OfficeWorks records.
			/// </summary>
			private string _userLogin = string.Empty;
			public string UserLogin
			{
				get
				{
					return _userLogin;
				}
				set
				{
					_userLogin = value;
				}
			}

 
			/// <summary>
			/// Flag is TRUE if OWMail should save 
			/// message attachments separately or FALSE otherwise.
			/// </summary>
			private bool _extractAttachments = false;
			public bool ExtractAttachments

			{
				get
				{
					return _extractAttachments;
				}
				set
				{
					_extractAttachments = value;
				}
			}

			private long _fromDefault = 1;
			public long FromDefault
			{
				get {return _fromDefault; }
				set { _fromDefault = value; }
			}
			
			private long _toDefault = 1;
			public long ToDefault
			{
				get {return _toDefault;}
				set { _toDefault = value; }
			}

			private long _ccDefault = 1;
			public long CcDefault
			{
				get {return _ccDefault;}
				set { _ccDefault = value;}
			}

			private long _bccDefault = 1;
			public long BccDefault 
			{
				get { return _bccDefault;}
				set { _bccDefault = value; }
			}

			private long _subjectDefault = 1;
			public long SubjectDefault 
			{
				get { return _subjectDefault;}
				set { _subjectDefault = value;}
			}

			private long _bodyDefault = 1;
			public long BodyDefault
			{
				get { return _bodyDefault;}
				set { _bodyDefault = value;}
			}

			private long _receivedDefault = 1;
			public long ReceivedDefault 
			{
				get { return _receivedDefault;}
				set { _receivedDefault = value; }
			}


			/// <summary>
			/// Compares two objects.
			/// </summary>
			/// <param name="x">First object to compare.</param>
			/// <param name="y">Secofg object to compatre,</param>
			/// <returns></returns>
			public int Compare(object x, object y)
			{
				Mailbox mailbox1 = (Mailbox)x;
				Mailbox mailbox2 = (Mailbox)y;
				return mailbox1.MailboxName.CompareTo(mailbox2.MailboxName);
			}
		}
	}
}

 

 
