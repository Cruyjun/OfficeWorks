using System.Collections;
using System.Xml.Serialization;

namespace OfficeWorks.OWOffice.Configuration
{
	/// <summary>
	/// Represent a Mapped Field configuration
	/// </summary>
	public class MappedField
	{
		#region Fields
		/// <summary>
		/// Name of Bookmark.
		/// </summary>
		private string bookmarkName;

		/// <summary>
		/// Identifier of OfficeWorks Field (Just for Fixed Fields).
		/// </summary>
		private int fieldIdentifier;
		
		/// <summary>
		/// Identifier of OfficeWorks Field (Just for Dynamic Fields).
		/// </summary>
		private string fieldName;

		/// <summary>
		/// Valid Field status.
		/// </summary>
		private bool validField;

		/// <summary>
		/// Is required field ?
		/// </summary>
		private bool requiredField;

		/// <summary>
		/// If is a entity source 
		/// </summary>
		private enumEntityType entityType;

		#endregion		

		#region PROPERTIES

		/// <summary>
		/// Name of Bookmark.
		/// </summary>		
		public string BookmarkName
		{
			get
			{
				return this.bookmarkName;
			}
			set
			{
				this.bookmarkName = value;
			}
		}
		
		
		/// <summary>
		/// Identifier of OfficeWorks Field (Description).
		/// </summary>		
		public int FieldIdentifier
		{
			get
			{
				return this.fieldIdentifier;
			}
			set
			{
				this.fieldIdentifier = value;
			}
		}

		/// <summary>
		/// Identifier of OfficeWorks Field (Description).
		/// </summary>		
		public string FieldName
		{
			get
			{
				return this.fieldName;
			}
			set
			{
				this.fieldName = value;
			}
		}


		/// <summary>
		/// Valid Field status.
		/// </summary>
		public bool ValidField
		{
			get
			{
				return this.validField;
			}
			set
			{
				this.validField = value;
			}
		}


		/// <summary>
		/// Is required field ?
		/// </summary>		
		public bool RequiredField
		{
			get
			{
				return this.requiredField;
			}
			set
			{
				this.requiredField = value;
			}
		}
		

		/// <summary>
		/// If is a entity source 
		/// </summary>		
		public enumEntityType EntityType
		{
			get
			{
				return this.entityType;
			}
			set
			{
				this.entityType = value;
			}
		}


		#endregion

		#region Constructor

		/// <summary>
		/// Class Constructor
		/// </summary>
		public MappedField()
		{
			this.bookmarkName = string.Empty;			
			this.fieldIdentifier = 0;
			this.fieldName = string.Empty;
			this.validField = true;
			this.requiredField = false;
			this.entityType = enumEntityType.EntityTypeOrigin;
		}

		#endregion
	}
}
