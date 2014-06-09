using System;
using System.Runtime.InteropServices;
using OfficeWorks.OWOffice.COMMONWebService;

namespace OfficeWorks.OWOffice.BasicOrganizationalUnits
{
	
	#region BasicOrganizationalUnit interface
	
	/// <summary>
	/// BasicOrganizationalUnit Insterface
	/// </summary>
	[Guid("58E529CB-313E-40e2-B5B2-8A4FFA6643BB"), ComVisible(true)]		
	public interface IBasicOrganizationalUnit 
	{
		int ID { get; }

		string Description { get;}

		int Type { get;}
	}

	#endregion
	
	#region BasicOrganizationalUnit Class
	/// <summary>
	/// BasicOrganizationalUnit definition Class
	/// </summary>
	[Guid("52A7DF50-B218-417b-B5CC-FBD54E36A763"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class BasicOrganizationalUnit : IBasicOrganizationalUnit 
	{
		#region Fields

		/// <summary>
		/// Object identifier
		/// </summary>
		internal int id;

		/// <summary>
		/// Object Description
		/// </summary>
		internal string description;

		/// <summary>
		/// Object Type
		/// </summary>
		internal int type;
		
		#endregion
		
		#region Properties

		/// <summary>
		/// Object identifier
		/// </summary>
		public int ID
		{
			get
			{
				return this.id;
			}
		}

		/// <summary>
		/// Object Description
		/// </summary>
		public string Description
		{
			get
			{
				return this.description;
			}
		}

		/// <summary>
		/// Object Type
		/// </summary>
		public int Type
		{
			get
			{
				return this.type;
			}
		}


		#endregion

		#region Constructors

		/// <summary>
		/// Object Constructor
		/// </summary>
		public BasicOrganizationalUnit()
		{
			this.id = int.MinValue;
			this.description = null;
			this.type = (int) OWApiWebService.OrganizationalUnitTypeEnum.All;			
		}

		#endregion
	}

	#endregion

}
