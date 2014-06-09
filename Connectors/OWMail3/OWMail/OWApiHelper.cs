using System;
using System.Collections;
using System.IO;
using CDO;
using OWMail.OWApiWebService;

namespace OfficeWorks
{
	/// <summary>
	/// Wrapper client caller for OWApi web service.
	/// </summary>
	public class OWApiHelper
	{
		/// <summary>
		/// Default constructor.
		/// </summary>
		public OWApiHelper()
		{
		}

		/// <summary>
		/// Makes a call to OWApi web service InsertRegistry method given some OWMailConfiguration parameters.
		/// </summary>
		/// <param name="userLogin">OWApi web service user login.</param>
		/// <param name="password">OWApi web service password.</param>
		/// <param name="contacts">MailContact list.</param>
		/// <param name="configuration">OWMailConfiguration instance to assign local variables.</param>
		/// <param name="guid">System.Guid string to name temporary attachments directory.</param>
		/// <param name="directoryName">Temporary attachments directory name.</param>
		/// <param name="filePath">File path for mail message file.</param>
		/// <param name="attachments">IBodyParts collection of mail message attachments.</param>
		/// <param name="subject">Mail message subject string.</param>
		/// <param name="mailDate">Mail message received time.</param>
		/// <param name="body">Mail messge body content string.</param>
		/// <returns>An integer corresponding to a created record id in tblRegistry or zero if record creation does not succeeds</returns>
		public static int InsertRegistry(string userLogin, 
										 string password, 
		                                 ArrayList contacts, 
										 OWMailConfiguration configuration, 
										 string guid, 
										 string directoryName, 
										 string filePath, 
		                                 IBodyParts attachments, 
										 string subject, 
		                                 DateTime mailDate, 
										 string body
										)
		{
			int result = 0;
			OWApi OWApi = null;
			stRegistry registry = null;
			
			try
			{
				// Initializes and loads values for a stRegistry instance and all its nested types
				registry = new stRegistry();

				// Assigns stUser instance data
				registry.User = new stUser();
				registry.User.UserLogin = userLogin;
				//registry.User.UserMail = ((MailContact)contacts[1]).Mail;
				registry.User.UserMail =  configuration.GetMailboxNameByUserLogin(userLogin);
				registry.Year = DateTime.Now.Year;

				// If insert subject
				if (configuration.GetSubjectMappingByMailboxName(registry.User.UserMail)==MappingOptions.Assunto)
				{
					if (subject.Length >= 250)
					{
						registry.Subject = string.Format("{0}(...)",subject.Substring(0,245));
					}
					else
					{
						registry.Subject = subject;
					}
				}
				// if Insert mailDate
				if (configuration.GetReceivedMappingByMailboxName(registry.User.UserMail) == MappingOptions.DataDocumento)
				{
					registry.DocumentDate = mailDate; 
				}
				else if (configuration.GetReceivedMappingByMailboxName(registry.User.UserMail) == MappingOptions.DataRegisto)
				{
					registry.RegistryDate = mailDate;
				}
				
				//if Insert Body
				if (configuration.GetBodyMappingByMailboxName(registry.User.UserMail) == MappingOptions.Observacoes)
				{
					if (body.Length >= 250)
					{
						registry.Observations = string.Format("{0}(...)",body.Substring(0,245));	
					}
					else
					{
						registry.Observations = body;	
					}
				}
					
				int attachmentsCount = 0;
				
				// If message has attachments then keep track of its number to use in extracting loop below
				if (attachments != null && attachments.Count > 0)
				{
					attachmentsCount = attachments.Count;
				}

				
				// Mail message file itself always will be stored as an attachment to the new OfficeWorks record 
				registry.Files = new stFile[attachmentsCount + 1];
				registry.Files[0] = new stFile();
				FileStream fsFile = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
				// This is hard-coded by convention. Could come from a const.
				registry.Files[0].FileName = "Mail.eml";
				registry.Files[0].FileArray = new byte[fsFile.Length];
				fsFile.Read(registry.Files[0].FileArray, 0, (int)fsFile.Length);
				// Clean up unmanaged resources.
				fsFile.Close();
					
				// Gets extract attachments flag from configuration. 
				// This funcionality is implemented but was not made available for OWMail 2.0.
				bool extract = configuration.GetExtractAttachmentsByMailboxName(((MailContact)contacts[0]).Mail);
				
				// If there are attachments
				if (attachments != null && extract)
				{
					int counter = 0;
					
					// Loop through attachments collection and save each one to its file in message temporary directory
					foreach (IBodyPart attachment in attachments)
					{
						// Checks for a good working environment before trying to use resources from it
						if (Directory.Exists(directoryName))
						{
							string fileName = attachment.FileName;
							string path = directoryName + @"\" + fileName;

							attachment.SaveToFile(path);
					
							counter ++;

							// Stores each attachment in a stFile instance
							registry.Files[counter] = new stFile();
							FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read);
							registry.Files[counter].FileName = fs.Name;
							registry.Files[counter].FileArray = new byte[fs.Length];
							fs.Read(registry.Files[counter].FileArray, 0, (int)fs.Length);
							// Cleans up unmanaged resources memory
							fs.Close();
						}
					}
				}

				
				// Assigns stBook instance data
				registry.Book = new stBook();
				registry.Book.BookID = configuration.GetBookIdByMailboxName(registry.User.UserMail);
				
				// Assigns stDocumentType instance data
				registry.DocumentType = new stDocumentType();
				registry.DocumentType.DocumentTypeID = configuration.GetDocumentTypeIdByMailboxName(registry.User.UserMail);
				




				// If there is more than one contact then stRegistry will contain
				// an array of MoreEntities which will be also recorded and shown
				if (contacts.Count > 1) /* + Entidades. */
				{
					ArrayList arrmoreEntities = new ArrayList();
					
					// Loops through all contacts in list
					for (int x = 0; x < contacts.Count; x++)
					{
						
						//moreEntities[x] = new stEntity();
						stEntity contactEntity = new stEntity();

						switch (((MailContact)contacts[x]).Type)
						{
							
							case enumMailBoxMapping.Cc:
								if(configuration.GetCcMappingByMailboxName(registry.User.UserMail) == MappingOptions.MaisEntidadesDes) 
								{
									contactEntity.EntityName = ((MailContact)contacts[x]).Name;
									contactEntity.EntityExchangeID = ((MailContact)contacts[x]).Mail;
									contactEntity.EntityType = enumEntityType.EntityTypeDestiny;
									arrmoreEntities.Add(contactEntity);
								}
								break;

							case enumMailBoxMapping.From:
								if(configuration.GetFromMappingByMailboxName(registry.User.UserMail) == MappingOptions.MaisEntidadesOri)
								{
									contactEntity.EntityName = ((MailContact)contacts[x]).Name;
									contactEntity.EntityExchangeID = ((MailContact)contacts[x]).Mail;
									contactEntity.EntityType = enumEntityType.EntityTypeOrigin;
									arrmoreEntities.Add(contactEntity);
								}
								else if (configuration.GetFromMappingByMailboxName(registry.User.UserMail) == MappingOptions.EntPrincipal)
								{
									// Assigns main stEntity instance data /*EntidadePrincipal*/
									registry.Entity = new stEntity();
									registry.Entity.EntityName = ((MailContact)contacts[x]).Name;
									registry.Entity.EntityExchangeID = ((MailContact)contacts[x]).Mail;
									registry.Entity.EntityType = enumEntityType.EntityTypeOrigin;
								}
								break;

							case enumMailBoxMapping.To:
								if(configuration.GetToMappingByMailboxName(registry.User.UserMail) == MappingOptions.MaisEntidadesDes) 
								{
									contactEntity.EntityName = ((MailContact)contacts[x]).Name;
									contactEntity.EntityExchangeID = ((MailContact)contacts[x]).Mail;
									contactEntity.EntityType = enumEntityType.EntityTypeDestiny;
									arrmoreEntities.Add(contactEntity);
								}
								break;

							
						}
					}

					// Assigns the extracted list of stEntities to stRegistry.MoreEntities property
					registry.MoreEntities = (stEntity[]) arrmoreEntities.ToArray(typeof(stEntity));
				}

				OWApi = new OWApi();
				// Override OWApi proxy with URL value from configuration before making the call
				OWApi.Url = configuration.WebServiceUrl;

				// Call OWApi web service and gets returned integer
				result = (int)OWApi.InsertRegistry(userLogin, password, ref registry);
			}
			catch (Exception ex)
			{
				throw ex;
			}

			return result;
		}
	}
}