using System.Collections;

namespace OfficeWorks
{
	public class OWMailConfigurationMailbox
	{
		private string name = string.Empty;
		public string Name
		{
			get
			{
				return name;
			}
			set
			{
				name = value;
			}
		}

		private ArrayList books = new ArrayList();
		public ArrayList Books
		{
			get
			{
				return books;
			}
			set
			{
				books = value;
			}
		}

		private ArrayList documentTypes = new ArrayList();
		public ArrayList DocumentTypes
		{
			get
			{
				return documentTypes;
			}
			set
			{
				documentTypes = value;
			}
		}

		private ArrayList users = new ArrayList();
		public ArrayList Users
		{
			get
			{
				return users;
			}
			set
			{
				users = value;
			}
		}

		public OWMailConfigurationMailbox()
		{
		}
	}
}
