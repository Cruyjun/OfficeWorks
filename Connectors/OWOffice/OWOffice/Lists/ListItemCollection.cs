using System;
using System.Runtime.InteropServices;
using System.Collections;

namespace OfficeWorks.OWOffice.Lists
{
	#region ListItemCollection Interface

	[Guid("993AF913-A05F-4f94-9BA2-7045584C606B"), ComVisible(true)]		
	public interface IListItemCollection 
	{
		void AddItem(long Identifier, string Description);

		void Clear();

		int Count { get; }

		ListItem this[int Index] { get; }

		IEnumerator GetEnumerator();
	}
	#endregion

	#region ListItemCollection Class

	[Guid("9AD09BCE-A7D1-49a4-A9F8-6F5E29CA5BAE"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class ListItemCollection : Common.CollectionBase, IListItemCollection 
	{
		#region Fields
		/// <summary>
		/// List Name
		/// </summary>
		private string listName;

		#endregion

		#region PROPERTIES
		
		/// <summary>
		/// List Name
		/// </summary>
		public string ListName 
		{
			set { this.listName = value; }
			get { return this.listName; }
		}
		
		/// <summary>
		/// Get or Set a Object
		/// </summary>
		public ListItem this[int Index]
		{
			get
			{
				return (ListItem)this.List[Index];
			}
			set
			{
				this.List[Index] = value;
			}
		}

		#endregion

		#region Constructors
		/// <summary>
		/// Class Constructor
		/// </summary>
		public ListItemCollection()
		{
			this.listName = string.Empty;
		}
		#endregion

		#region METHODS

		public void AddItem(long Identifier, string Description) 
		{
			//add a new item to collection
			ListItem NewItem = new ListItem();
			NewItem.Identifier = Convert.ToInt32(Identifier);
			NewItem.Description = Description;
			this.List.Add(NewItem);
		}
		
		#endregion
	}
	#endregion
}
