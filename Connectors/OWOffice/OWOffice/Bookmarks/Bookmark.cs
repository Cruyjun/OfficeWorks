using System;
using System.Runtime.InteropServices;


namespace OfficeWorks.OWOffice.Bookmarks
{
	
	#region Bookmark interface
	
	/// <summary>
	/// Bookmark Insterface
	/// </summary>
	[Guid("84D70366-6841-4e4d-BF52-4D8263FAA84B"), ComVisible(true)]		
	public interface IBookmark 
	{
		string Name { get; set; }

		string Value { get; set; }
	}

	#endregion
	
	#region Bookmark Class
	/// <summary>
	/// Bookmark definition Class
	/// </summary>
	[Guid("FABAA0D5-5119-4ce2-B815-B2DD5385010E"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class Bookmark : IBookmark 
	{
		#region Fields
		/// <summary>
		/// Bookmark Name
		/// </summary>
		private string name;

		/// <summary>
		/// Bookmark Value
		/// </summary>
		private string valuE;

		#endregion
		
		#region Properies

		/// <summary>
		/// Bookmark Name
		/// </summary>
		public string Name 
		{
			set { this.name = value; }
			get { return this.name; }
		}

		
		/// <summary>
		/// Bookmark Value
		/// </summary>
		public string Value 
		{
			set { this.valuE = value; }
			get { return this.valuE; }
		}

		#endregion

		#region Constructor
		/// <summary>
		/// Class Constructor
		/// </summary>
		public Bookmark()
		{
			this.valuE = "";
			this.name = "";
		}
		#endregion
	}

	#endregion

}
