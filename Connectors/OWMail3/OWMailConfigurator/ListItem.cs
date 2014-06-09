using System;

namespace OfficeWorks
{
	/// <summary>
	/// Represents a name/value pair entry, useful in Listbox form objects.
	/// </summary>
	public class ListItem
	{
		/// <summary>
		/// Identifier of entry.
		/// </summary>
		private long id;
		public long Id
		{
			get
			{
				return id;
			}
			set
			{
				id = value;
			}
		}

		/// <summary>
		/// Entry name/Designation
		/// </summary>
		private string text;
		public string Text
		{
			get
			{
				return text;
			}
			set
			{
				text = value;
			}
		}

		/// <summary>
		/// Default constructor.
		/// </summary>
		public ListItem()
		{
		}
		
		/// <summary>
		/// A parameterized constructor allows to fill local members in a single call.
		/// </summary>
		/// <param name="id"></param>
		/// <param name="text"></param>
		public ListItem(long id, string text)
		{
			this.id = id;
			this.text = text;
		}
	}
}
