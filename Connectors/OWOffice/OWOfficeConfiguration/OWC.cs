

using System.Collections;
using System.Xml.Serialization;

namespace OfficeWorks.OWOffice.Configuration
{	

	/// <summary>
	/// OWOffice Configuration Class
	/// </summary>	
	[XmlInclude(typeof(TemplateCfg))]	
	public class OWC
	{	

		#region Constants

		//URL para o webservice OWApi
		public const string kWEBSERVICE_OWApi = @"/WebServices/OWApi/OWApi.asmx";
		//URL para o process webservice
		public const string kWEBSERVICE_PROCESS = @"/WebServices/OWProcess/process.asmx";
		//URL para o common webservice
		public const string kWEBSERVICE_COMMON = @"/WebServices/OWProcess/common.asmx";

		#endregion

		#region Fields
		
		
		/// <summary>
		/// This object serialized
		/// </summary>
		private string owcXMLData;

		/// <summary>
		/// URL of OfficeWorks Site installation
		/// </summary>
		private string webServerUrl;

		/// <summary>
		/// Directory path to use for creating temporary directory and files.
		/// </summary>
		private string tempDirectoryPath;

		/// <summary>
		/// List of configurated Templates.
		/// </summary>
		private ArrayList templates;

		#endregion		

		#region PROPERTIES

		/// <summary>
		/// This object serialized
		/// </summary>
		public string OwcXMLData
		{
			get
			{
				return this.owcXMLData;
			}			
		}

		/// <summary>
		/// URL of OfficeWorks Site installation
		/// </summary>		
		public string WebServerUrl
		{
			get
			{
				return this.webServerUrl;
			}
			set
			{
				this.webServerUrl = value;
			}
		}
 

		/// <summary>
		/// Directory path to use for creating temporary directory and files.
		/// </summary>		
		public string TempDirectoryPath
		{
			get
			{
				return this.tempDirectoryPath;
			}
			set
			{
				this.tempDirectoryPath = value;
			}
		}
 

		/// <summary>
		/// List of configurated Templates.
		/// </summary>			
		public ArrayList Templates
		{
			get
			{
				return this.templates;
			}
			set
			{
				this.templates = value;
			}
		}
		

		#endregion

		#region Constructor		
		
		/// <summary>
		/// Constructs an OWC instance with settings stored in a XML file.
		/// </summary>
		/// <param name="configurationData">OWOffice configuration file path or xml data to use when loading settings.</param>
		public OWC(string configurationData)
		{
			this.Read(configurationData);
		}

		/// <summary>
		/// Class Constructor
		/// </summary>
		public OWC()
		{			
			this.webServerUrl = string.Empty;
			this.tempDirectoryPath = string.Empty;
			this.templates = new ArrayList();
			this.owcXMLData = string.Empty;
		}

		#endregion

		#region METHODS


		/// <summary>
		/// Compare 2 Objects Data. if there are equal retrurs true
		/// </summary>
		/// <param name="obj">Object to compare</param>
		/// <returns></returns>
		public bool Compare(object obj)
		{			
			//create MemoryStream objects
			System.IO.MemoryStream oS1 = new System.IO.MemoryStream() ;			
			System.IO.MemoryStream oS2 = new System.IO.MemoryStream() ;
			//create XmlSerializer object typeof OWOfficeConfiguration
			XmlSerializer oSer = new XmlSerializer(typeof(OWC));
			//Serialize obj
			oSer.Serialize(oS1,(OWC) obj);
			//Serialize this instance
			oSer.Serialize(oS2,(OWC) this);
			//Get Serialized data into byte arrays
			byte[] oA1 = oS1.ToArray();
			byte[] oA2 = oS2.ToArray();
			//Compare arrays length
			if (oA1.LongLength!=oA2.LongLength)
				return false;
			//Compare arrays data
			for (long lX=0; lX<oA1.LongLength;lX++)
				if (oA1[lX]!=oA2[lX])//if any diffrence then return false
					return false;
			
			//objects are identical
			return	true;
		}

		
		/// <summary>
		/// Loads an OWOfficeConfiguration instance with settings stored in a XML file.
		/// </summary>
		/// <param name="configurationData">OWOffice configuration file path to use when loading settings.</param>
		public void Read(string configurationData)
		{
			OWC owc = new OWC();
			//Test if it is a xml document
			if (configurationData.IndexOf("<?xml")!= -1)
				owc = Serializer.DeserializeFromXml(configurationData);
			else//else is a xml file
				owc = Serializer.Deserialize(configurationData, out this.owcXMLData);
                  
			// As this method could be called at runtime, this call ensures data is actual
			this.Refresh(owc);
		} 
		

		/// <summary>
		/// Writes an XML file with values stored in a OWOfficeConfiguration instance.
		/// </summary>
		/// <param name="configurationFilePath">OWOffice configuration file path to use when writing values.</param>
		public void Write(string configurationFilePath)
		{
			Serializer.Serialize(this, configurationFilePath);
		}
 

		/// <summary>
		/// Keeps instance data settings synchronized with XML file data values
		/// </summary>
		/// <param name="configuration">An OWC instance to keep synchronized with the XML configuration file.</param>
		private void Refresh(OWC owc)
		{			
			this.WebServerUrl = owc.WebServerUrl;			
			this.TempDirectoryPath = owc.TempDirectoryPath;
			this.Templates = owc.Templates;			
		}


		#endregion
	}		
}
