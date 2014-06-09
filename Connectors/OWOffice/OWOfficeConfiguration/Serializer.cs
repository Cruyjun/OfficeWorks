using System;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

namespace OfficeWorks.OWOffice.Configuration
{
	/// <summary>
	/// Serializes/Deserializes Configuration instances to/from XML.
	/// </summary>
	public class Serializer
	{
		#region Static Methods

		/// <summary>
		/// Serialize an OWOfficeConfiguration instance to a XML file on disk.
		/// </summary>
		/// <param name="configuration">An OWOfficeConfiguration instance to serialize.</param>
		/// <param name="configurationFilePath">Full file path for the XML file to be created/saved.</param>
		public static void Serialize(OWC owc, string configurationFilePath)
		{
			XmlTextWriter writer = null;
			
			// Checks permissions before proceeding
			CheckFilePermissions(configurationFilePath);
			writer = new XmlTextWriter(configurationFilePath, Encoding.UTF8);
			XmlSerializer serializer = new XmlSerializer(typeof(OWC));
			serializer.Serialize(writer, owc);
			// Clean up memory
			if (writer != null)				
				writer.Close();
							
		}

		/// <summary>
		/// Deserialize a XML file on disk to an instance of OWOfficeConfiguration.
		/// </summary>
		/// <param name="configurationFilePath">Full file path for the XML file to be read and deserialized.</param>
		/// <returns>A deserialized OWOfficeConfiguration instance.</returns>
		public static OWC DeserializeFromXml(string xmlData)
		{
			OWC owc = null;			
			System.IO.StringReader sr = null;
			try
			{
			
				sr = new System.IO.StringReader(xmlData);

				XmlSerializer serializer = new XmlSerializer(typeof(OWC));
				owc = (OWC)serializer.Deserialize(sr);
				
			}
			catch(Exception ex)
			{
				ex = ex;
			}
			finally
			{
				// Clean up memory
				if (sr != null)
				{
					sr.Close();
				}				
			}
			return owc;
		}

		/// <summary>
		/// Deserialize a XML file on disk to an instance of OWOfficeConfiguration.
		/// </summary>
		/// <param name="configurationFilePath">Full file path for the XML file to be read and deserialized.</param>
		/// <returns>A deserialized OWOfficeConfiguration instance.</returns>
		public static OWC Deserialize(string configurationFilePath, out string xmlData)
		{			
			StreamReader sr = null;	
			xmlData = string.Empty;
			try
			{
			
				CheckFilePermissions(configurationFilePath);
				sr = File.OpenText(configurationFilePath);
				xmlData = sr.ReadToEnd();			
				
			}
			catch(Exception ex)
			{
				ex = ex;
			}
			finally
			{
				// Clean up memory
				if (sr != null)
				{
					sr.Close();
				}				
			}
			return DeserializeFromXml(xmlData);
		}

		/// <summary>
		/// Deserialize a XML file on disk to an instance of OWOfficeConfiguration.
		/// </summary>
		/// <param name="configurationFilePath">Full file path for the XML file to be read and deserialized.</param>
		/// <returns>A deserialized OWOfficeConfiguration instance.</returns>
		public static OWC Deserialize(string configurationFilePath)
		{				
			string xmlData = string.Empty;
			
			return Deserialize(configurationFilePath,out xmlData);
		}

		/// <summary>
		/// Checks if a given file has Normal attribute on, and change it to Normal if not.
		/// </summary>
		/// <param name="configurationFilePath">Full file path to check.</param>
		public static void CheckFilePermissions(string configurationFilePath)
		{
			try
			{
				if (File.Exists(configurationFilePath))
				{
					if (File.GetAttributes(configurationFilePath) != FileAttributes.Normal)
					{
						File.SetAttributes(configurationFilePath, FileAttributes.Normal);
					}
				}
			}
			catch(Exception)
			{}
		}

		#endregion

	}
}
