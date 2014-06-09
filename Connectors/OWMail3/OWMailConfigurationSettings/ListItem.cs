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
		private long _id;
		public long Id
		{
			get
			{
				return _id;
			}
			set
			{
				_id = value;
			}
		}

		/// <summary>
		/// Entry name/Designation
		/// </summary>
		private string _text;
		public string Text
		{
			get
			{
				return _text;
			}
			set
			{
				_text = value;
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
			this._id = id;
			this._text = text;
		}

		public override bool Equals(object obj) 
		{
			if (obj == null || GetType() != obj.GetType())
			{
				return false;
			}

			ListItem item = (ListItem)obj;
                  
			if (this.Id != item.Id || this.Text != item.Text)
			{
				return false;
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
	}
}
