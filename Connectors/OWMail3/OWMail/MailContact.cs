using System;

namespace OfficeWorks
{
	/// <summary>
	/// Defines a mail message contact as showing in from, to, cc and bcc message fields.
	/// </summary>
	public class MailContact
	{

		private enumMailBoxMapping _type;
		public enumMailBoxMapping Type
		{
			get { return _type;}
			set {_type = value;}
		}

		/// <summary>
		/// Contact name
		/// </summary>
		private string _name = string.Empty;
		public string Name
		{
			get
			{
				return _name;
			}
			set
			{
				_name = value;
			}
		}
		
		/// <summary>
		/// Contact e-Mail
		/// </summary>
		private string _mail = string.Empty;
		public string Mail
		{
			get
			{
				return _mail;
			}
			set
			{
				_mail = value;
			}
		}
		
		/// <summary>
		/// Default constructor
		/// </summary>
		public MailContact()
		{
		}

		/// <summary>
		/// Constructor to ease the creation of contacts
		/// </summary>
		/// <param name="name">Contact name</param>
		/// <param name="mail">Contact e-Mail</param>
		public MailContact(string name, string mail, enumMailBoxMapping type )
		{
			Name = name;
			Mail = mail;
			Type = type;
		}

		/// <summary>
		/// Equals override to allow checking if two given objects are equal.
		/// Equality here was assumed to happen when all objects fields return the same value.
		/// This was implemented to avoid repeating objects in the same list 
		/// (e.g., when the same entity is present in a from and a to fields).
		/// </summary>
		/// <param name="obj">Instance to compare with current object</param>
		/// <returns>TRUE if objects are equal, otherwise FALSE is returned</returns>
		public override bool Equals(object obj) 
		{
			// Checks input object validity for equality operation
			if (obj == null || GetType() != obj.GetType())
			{
				return false;
			}

			// Cast input object to a proper MailContact
			MailContact mailContact = (MailContact)obj;
			
			// Compares MailContact public fields
			if (this.Name != mailContact.Name || this._mail != mailContact.Mail)
			{
				return false;
			}

			// If it gets here, objects are equal
			return true;
		}

		/// <summary>
		/// GetHashCode override is needed when implementing Equals.
		/// It allows a given instance to have a unique identifier so it can be distinguished when doing the comparison.
		/// </summary>
		/// <returns>An uniquely identifier integer</returns>
		public override int GetHashCode() 
		{
			return new Random().Next();
		}
	}
}
