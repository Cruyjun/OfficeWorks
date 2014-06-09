using System;


namespace OfficeWorks.OWOffice.Common
{
	/// <summary>
	/// Summary description for CollectionBase.
	/// </summary>
	public class CollectionBase: System.Collections.CollectionBase
	{

		#region Properties

		
		

		#endregion

		#region Constructors

		public CollectionBase()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		#endregion
		
		#region Methods
		

		/// <summary>
		/// Add a Object to collection
		/// </summary>
		/// <param name="obj"></param>
		public void Add(object obj)
		{
            this.List.Add(obj);			
		}	
		

		/// <summary>
		/// Remove Object from collection at Index Position
		/// </summary>
		/// <param name="Index"></param>
		public void Remove(int Index)
		{
			this.List.RemoveAt(Index);
		}

		/// <summary>
		/// Insert a Object At Index Position
		/// </summary>
		/// <param name="Index">Index Position</param>
		/// <param name="Obj">Object to insert</param>
		public void Insert(int Index, object Obj)
		{
			this.List.Insert(Index, Obj);
		}
		
		
		#endregion
	}
}
