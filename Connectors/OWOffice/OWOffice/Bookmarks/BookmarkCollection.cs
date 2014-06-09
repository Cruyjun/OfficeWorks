using System;
using System.Runtime.InteropServices;
using System.Collections;


namespace OfficeWorks.OWOffice.Bookmarks
{
	#region BookmarkCollation Interface

	[Guid("6BAE7F40-FA79-4828-B97C-D610CDE3C58B"), ComVisible(true)]		
	public interface IBookmarkCollation
	{
		void AddMapping(string BookmarkName, string BookmarkValue);

		void Clear();

		int Count { get; }

		Bookmark this[int Index] { get; }

		IEnumerator GetEnumerator();
	}

	#endregion

	#region BookmarkCollation Class

	[Guid("BCB685D9-CB4C-4bf3-AB7F-E275964E57C3"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class BookmarkCollation : Common.CollectionBase , IBookmarkCollation 
	{
		#region Properties

		/// <summary>
		/// Get or Set a Object
		/// </summary>
		public Bookmark this[int Index]
		{
			get
			{
				return (Bookmark)this.List[Index];
			}
			set
			{
				this.List[Index] = value;
			}
		}

		#endregion

		#region Methods
		public void AddMapping(string BookmarkName, string BookmarkValue) 
		{
			//Create a New bookmark
			Bookmark NewBookmark = new Bookmark();
			NewBookmark.Name = BookmarkName;
			NewBookmark.Value = BookmarkValue;

			//Add Bookmark to collation
			this.List.Add(NewBookmark);
		}	
		#endregion

	}
	#endregion
}
