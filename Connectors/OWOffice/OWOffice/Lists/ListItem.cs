using System;
using System.Runtime.InteropServices;

namespace OfficeWorks.OWOffice.Lists
{
	#region ListItem Interface

	[Guid("2D0EACF1-9AE6-4436-AAE0-92D43C3DFB37"), ComVisible(true)]	
	public interface IListItem 
	{
		int Identifier { set; get; }

		string Description { get; set; }
	}

	#endregion
	
	#region ListItem Class

	[Guid("FD9E8613-9500-4d32-9843-96BE3735A409"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class ListItem : IListItem 
	{
		#region PROPERTIES
		private int _Identifier;
		public int Identifier 
		{
			set { _Identifier = value; }
			get { return _Identifier; }
		}
		private string _Description;
		public string Description 
		{
			set { _Description = value; }
			get { return _Description; }
		}
		#endregion
	}
	#endregion
}
