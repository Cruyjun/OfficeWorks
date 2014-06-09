using System.Collections;
using System.DirectoryServices;

namespace OfficeWorks.OWOffice
{
	/// <summary>
	/// Encapsulates Active Directory related funcionalities.
	/// </summary>
	public class ActiveDirectoryReader
	{
		/// <summary>
		/// Stores Active Directory domain controller name to use.
		/// </summary>
		private string domain = string.Empty;
		public string Domain
		{
			get
			{
				return domain;
			}
			set
			{
				domain = value;
			}
		}
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public ActiveDirectoryReader()
		{
		}

		/// <summary>
		/// Parameterized constructor allows domain name assignment within same call.
		/// </summary>
		/// <param name="domain"></param>
		public ActiveDirectoryReader(string domain)
		{
			this.domain = domain;
		}

		/// <summary>
		/// Builds a list with a requested property found in a given Active Directory object.
		/// </summary>
		/// <param name="objectClass">ObjectClass to search for. E.g.: "User".</param>
		/// <param name="propertyName">Name of property to list.</param>
		/// <returns>An ArrayList built from all property entries found.</returns>
		public ArrayList GetValuesList(string objectClass, string propertyName)
		{
			DirectoryEntry entry = new DirectoryEntry("LDAP://" + Domain);
			DirectorySearcher search = new DirectorySearcher(entry);
			// Filtering criteria before searching makes it faster
			search.Filter = "(&(objectClass=" + objectClass + "))";
			SearchResultCollection searchResults = search.FindAll();

			ArrayList list = new ArrayList();
		
			for (int x = 0; x < searchResults.Count; x++)
			{
				if (searchResults[x].Properties.Contains(propertyName))
				{
					list.Add(searchResults[x].Properties[propertyName][0].ToString());
				}
			}

			return list;
		}
	}
}
