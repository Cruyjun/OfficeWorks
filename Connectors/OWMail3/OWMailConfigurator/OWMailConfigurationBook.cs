namespace OfficeWorks
{
	public class OWMailConfigurationBook
	{
		public OWMailConfigurationBook()
		{
		}

		private int id = 0;
		public int Id
		{
			get
			{
				return id;
			}
			set
			{
				id = value;
			}
		}

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
	}
}
