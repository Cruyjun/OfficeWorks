using System.Collections;

namespace OfficeWorks
{
	/// <summary>
	/// MailContact lists manager.
	/// </summary>
	public class MailContactHelper
	{
		/// <summary>
		/// Holds a MailContact list.
		/// </summary>
		private ArrayList mailContacts = new ArrayList();
		public ArrayList MailContacts
		{
			get
			{
				return mailContacts;
			}
			set
			{
				mailContacts = value;
			}
		}
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public MailContactHelper()
		{
		}

		/// <summary>
		/// Processes mail message fields from, to and cc fields to create a MailContact list.
		/// </summary>
		/// <param name="from">From field content string.</param>
		/// <param name="to">To field content string.</param>
		/// <param name="cc">Cc field content string.</param>
		/// <returns></returns>
		public ArrayList GetMailContactsList(string from, string to, string cc)
		{
			string[] fromList = from.Split(',');
			string[] toList = to.Split(',');
			string[] ccList = cc.Split(',');
			
			UpdateListFromArray(fromList,enumMailBoxMapping.From);
			UpdateListFromArray(toList, enumMailBoxMapping.To);
			UpdateListFromArray(ccList, enumMailBoxMapping.Cc);
			
			return MailContacts;
		}

		/// <summary>
		/// Loops through an array of strings filling a MailContact list.
		/// </summary>
		/// <param name="array">string array of referred mail message field entities</param>
		private void UpdateListFromArray(string[] array, enumMailBoxMapping type)
		{
			for (int x = 0; x < array.Length; x++)
			{
				string text = array[x];

				if (text.Length > 0)
				{
					MailContact mailContact = GetMailContact(text, type);
					MailContacts.Add(mailContact);
				}
			}
		}

		/// <summary>
		/// Extracts a Name/e-Mail pair from a given entity text.
		/// </summary>
		/// <param name="text">Mail message single entity content string.</param>
		/// <returns>A MailContact instance loaded with a Name/e-Mail.</returns>
		private MailContact GetMailContact(string text, enumMailBoxMapping type)
		{
			string name = string.Empty;
			string mail = string.Empty;
			
			int position = text.IndexOf("<");
			
			// If an occurrence of a Name exists in input text, 
			// extract its text to Name field, otherwise use e-Mail as is
			if (position != -1)
			{
				name = text.Substring(0, position).Trim();
				name = name.Replace("\"", string.Empty);
				
				mail = text.Substring(position).Trim();
				mail = mail.Replace("<", string.Empty);
				mail = mail.Replace(">", string.Empty);
			}
			else
			{
				// Ensure no leading or trailing spaces exist
				mail = text.Trim();
			}

			// Use MailContact constructor to directly return a new MailContact instance
			return new MailContact(name, mail, type);
		}
	}
}
