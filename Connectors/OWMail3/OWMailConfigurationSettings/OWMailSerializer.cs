using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

namespace OfficeWorks
{
	/// <summary>
	/// Serializes/Deserializes OWMailConfiguration instances to/from XML.
	/// </summary>
	public class OWMailSerializer
	{
		/// <summary>
		/// Serialize an OWMailConfiguration instance to a XML file on disk.
		/// </summary>
		/// <param name="configuration">An OWMailConfiguration instance to serialize.</param>
		/// <param name="configurationFilePath">Full file path for the XML file to be created/saved.</param>
		public static void Serialize(OWMailConfiguration configuration, string configurationFilePath)
		{
			// Checks permissions before proceeding
			if (File.Exists(configurationFilePath))
			{
				CheckFilePermissions(configurationFilePath);
			}
				
			XmlTextWriter writer = null;
				
			try
			{
				writer = new XmlTextWriter(configurationFilePath, Encoding.UTF8);
		
				XmlSerializer serializer = new XmlSerializer(typeof(OWMailConfiguration));
				serializer.Serialize(writer, configuration);
			}
			finally
			{
				// Clean up memory
				if (writer != null)
				{
					writer.Close();
				}
			}
		}

		/// <summary>
		/// Deserialize a XML file on disk to an instance of OWMailConfiguration.
		/// </summary>
		/// <param name="configurationFilePath">Full file path for the XML file to be read and deserialized.</param>
		/// <returns>A deserialized OWMailConfiguration instance.</returns>
		public static OWMailConfiguration Deserialize(string configurationFilePath)
		{
			OWMailConfiguration configuration = null;
			
			if (File.Exists(configurationFilePath))
			{
				FileStream stream = null;
				XmlReader reader = null;
				
				try
				{
					CheckFilePermissions(configurationFilePath);
				
					stream = new FileStream(configurationFilePath, FileMode.Open, FileAccess.ReadWrite);
					reader = new XmlTextReader(stream);

					XmlSerializer serializer = new XmlSerializer(typeof(OWMailConfiguration));
					configuration = (OWMailConfiguration)serializer.Deserialize(reader);
				}
				finally
				{
					// Clean up memory
					if (stream != null)
					{
						stream.Close();
					}

					if (reader != null)
					{
						reader.Close();
					}
				}
			}

			return configuration;
		}

		/// <summary>
		/// Checks if a given file has Normal attribute on and change it to be Normal in case it is not so.
		/// </summary>
		/// <param name="configurationFilePath">Full file path to check.</param>
		private static void CheckFilePermissions(string configurationFilePath)
		{
			if (File.GetAttributes(configurationFilePath) != FileAttributes.Normal)
			{
				File.SetAttributes(configurationFilePath, FileAttributes.Normal);
			}
		}
	}
}
