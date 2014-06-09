using System.Collections;
using System.Xml.Serialization;

namespace OfficeWorks.OWOffice.Configuration
{
	/// <summary>
	/// Templates configuration
	/// </summary>	
	[XmlInclude(typeof(MappedField))]
	public class TemplateCfg
	{
		#region Fields
		/// <summary>
		/// Name of template.
		/// </summary>
		private string templateName;

		/// <summary>
		/// Book Abreviation (Identifier of Book).
		/// </summary>
		private string bookAbreviation;
		
		/// <summary>
		/// Book Description
		/// </summary>
		private string bookDescription;

		/// <summary>
		/// DocumentType Abreviation (Identifier of DocumentType).
		/// </summary>
		private string documentTypeAbreviation;
		
		/// <summary>
		/// DocumentType Description
		/// </summary>
		private string documentTypeDescription;

		/// <summary>
		/// Configured Accesses Riquired
		/// </summary>		
		private bool accessesRiquired;

		/// <summary>
		/// Template Hierarchic Access
		/// </summary>
		private bool hierarchicAccess;

		/// <summary>
		/// Show Registry (default)
		/// </summary>
		private bool showRegistryDefault;

		/// <summary>
		/// Convert Attached Document to PDF
		/// </summary>		
		private bool pdfConvert;

		/// <summary>
		/// Mappings for template.
		/// </summary>
		private ArrayList mappedFields;

		#endregion		

		#region PROPERTIES

		/// <summary>
		/// Name of template.
		/// </summary>		
		public string TemplateName
		{
			get
			{
				return this.templateName;
			}
			set
			{
				this.templateName = value;
			}
		}
			

		/// <summary>
		/// Abreviation (Identifier of Book)
		/// </summary>		
		public string BookAbreviation
		{
			get
			{
				return this.bookAbreviation;
			}
			set
			{
				this.bookAbreviation = value;
			}
		}
 

		/// <summary>
		/// Book Description
		/// </summary>	
		public string BookDescription
		{
			get
			{
				return this.bookDescription;
			}
			set
			{
				this.bookDescription = value;
			}
		}
 

		/// <summary>
		/// Book Abreviation (Identifier of DocumentType)
		/// </summary>		
		public string DocumentTypeAbreviation
		{
			get
			{
				return this.documentTypeAbreviation;
			}
			set
			{
				this.documentTypeAbreviation = value;
			}
		}
 

		/// <summary>
		/// DocumentType Description
		/// </summary>	
		public string DocumentTypeDescription
		{
			get
			{
				return this.documentTypeDescription;
			}
			set
			{
				this.documentTypeDescription = value;
			}
		}
 
		/// <summary>
		/// Configured Accesses Riquired
		/// </summary>		
		public bool AccessesRiquired
		{			
			get { return this.accessesRiquired; }
			set { this.accessesRiquired = value; }
		}
 
		/// <summary>
		/// Template Hierarchic Access
		/// </summary>		
		public bool HierarchicAccess
		{
			get
			{
				return this.hierarchicAccess;
			}
			set
			{
				this.hierarchicAccess = value;
			}
		}


		/// <summary>
		/// Show Registry (default)
		/// </summary>		
		public bool ShowRegistryDefault
		{
			get
			{
				return this.showRegistryDefault;
			}
			set
			{
				this.showRegistryDefault = value;
			}
		}


		
		/// <summary>
		/// Convert Attached Document to PDF
		/// </summary>		
		public bool PDFConvert
		{
			get
			{
				return this.pdfConvert;
			}
			set
			{
				this.pdfConvert = value;
			}
		}


		/// <summary>
		/// Mappings for template.
		/// </summary>		
		public ArrayList MappedFields
		{
			get
			{
				return this.mappedFields;
			}
			set
			{
				this.mappedFields = value;
			}
		}

		#endregion

		#region Constructor

		/// <summary>
		/// Cass Constructor
		/// </summary>
		public TemplateCfg()
		{
			this.templateName = string.Empty;
			this.bookAbreviation = string.Empty;
			this.bookDescription = string.Empty;
			this.documentTypeAbreviation = string.Empty;
			this.documentTypeDescription = string.Empty;
			this.hierarchicAccess = false;
			this.showRegistryDefault = true;
			this.pdfConvert = false;
			this.mappedFields = new ArrayList();
		}
		#endregion
	}

}
