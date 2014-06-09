using System;
using System.Runtime.InteropServices;
using System.Collections;


namespace OfficeWorks.OWOffice.BasicOrganizationalUnits
{
	#region BasicOrganizationalUnitCollection Interface

	[Guid("0CB999C4-5952-4fe1-81F2-DE9E558C97B3"), ComVisible(true)]		
	public interface IBasicOrganizationalUnitCollation
	{		
		
		int Count { get; }

		BasicOrganizationalUnit this[int Index] { get; }

		IEnumerator GetEnumerator();

		void Add(int ID, string Description, int Type);
	}

	#endregion

	#region BasicOrganizationalUnitCollation Class

	[Guid("6B1EA19F-8B5D-4fe2-A74E-99C9BCE84AB2"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class BasicOrganizationalUnitCollation : Common.CollectionBase , IBasicOrganizationalUnitCollation 
	{
		#region Properties

		/// <summary>
		/// Get or Set a Object
		/// </summary>
		public BasicOrganizationalUnit this[int Index]
		{
			get
			{
				return (BasicOrganizationalUnit)this.List[Index];
			}
			set
			{
				this.List[Index] = value;
			}
		}

		#endregion

		#region Methods
		public void Add(BasicOrganizationalUnit BasicOUnit) 
		{
			//Add Bookmark to collation
			this.List.Add(BasicOUnit);
		}	

		public void Add(int ID, string Description, int Type)
		{
			BasicOrganizationalUnit org = new BasicOrganizationalUnit();
			org.id = ID;
			org.description = Description;
			org.type = Type;
			this.Add(org);
		}
		#endregion

	}
	#endregion
}
