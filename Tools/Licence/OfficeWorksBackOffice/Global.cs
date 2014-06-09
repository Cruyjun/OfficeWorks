using System;
using System.Collections.Specialized;
using System.DirectoryServices;
using OfficeWorks.NetworkManager;
using System.Windows.Forms;


namespace OfficeWorks.OfficeWorksBackOffice
{
	/// <summary>
	/// Summary description for Global.
	/// </summary>
	public class Global
	{

		/// <summary>
		/// Class Constructor
		/// </summary>
		public Global()
		{
		}



		/// <summary>
		/// Get all users of a group
		/// </summary>
		/// <param name="strDomain">Domain to access</param>
		/// <param name="strGroup">Group name to get users</param>
		/// <returns></returns>
		public static StringCollection GetGroupMembers(string strDomain, string strGroup)
		{
			StringCollection groupMembers = new StringCollection();
			try
			{
				/*DirectoryEntry Group = new DirectoryEntry("LDAP://DC=" + strDomain + ",DC=com" + ",CN=" + strGroup);

				DirectorySearcher groupMember = new DirectorySearcher
					(Group,"(objectClass=*)",new string[]{"member;Range=0-500"},SearchScope.Base);
				SearchResult result = groupMember.FindOne();*/

				DirectoryEntry group = new DirectoryEntry("LDAP://CN=" + strGroup + ",DC=" + strDomain + ",DC=com");								

				foreach(object dn in group.Properties["member"] )
				{
					groupMembers.Add(dn.ToString());
				}
				
				
				DirectoryEntry ent = new DirectoryEntry("LDAP://,DC=" + strDomain + ",DC=com");
				DirectorySearcher srch = new DirectorySearcher("(CN=" + strGroup + ")");
				srch.Filter = ("(&(objectCategory=person)(objectClass=user))");				
				SearchResultCollection coll = srch.FindAll();
				foreach (SearchResult rs in coll)
				{
					ResultPropertyCollection resultPropColl = rs.Properties;
					groupMembers.Add(resultPropColl["sAMAccountName"][0].ToString());
					// objectcategory; CN=Person
					//for (int i = 0; i < resultPropColl.Count; i++)
					//{	
						//groupMembers.Add(resultPropColl["sAMAccountName"].ToString());
					//}
					/*foreach( Object memberColl in resultPropColl.Values.get)
					{
						DirectoryEntry gpMemberEntry = new DirectoryEntry("LDAP://" + memberColl);
						System.DirectoryServices.PropertyCollection userProps = gpMemberEntry.Properties;
						object obVal = userProps["sAMAccountName"].Value;
						
						//string[] objectclass = (string[]) userProps["objectclass"].Value;
						//if (null != obVal && objectclass[1].ToLower() !="group")

						if (null != obVal)
						{
							groupMemebers.Add(obVal.ToString());
						}
					}*/
				}
			}
			catch (Exception ex)
			{
				throw(ex);
			}
			return groupMembers;
		}						
	


		/// <summary>
		/// Get domains from active directory
		/// </summary>
		public static void GetADDomains(ComboBox ddDomain)
		{
			Servers servers = new Servers();
			servers.Type |= ServerType.DomainEnum;

			ddDomain.Items.Clear();
			ddDomain.Items.Add("");
			foreach (String name in servers)
			{
				ddDomain.Items.Add(name);
			}
		}


	
	}
}
