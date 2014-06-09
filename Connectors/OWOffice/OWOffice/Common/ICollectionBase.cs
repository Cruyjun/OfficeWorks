using System;
using System.Collections;
using System.Runtime.InteropServices;

namespace OfficeWorks.OWOffice.Common
{
	/// <summary>
	/// Summary description for ICollectionBase.
	/// </summary>
	[Guid("F5B993F5-6461-4d84-B2F6-476425E25584"), ComVisible(true)]
	public interface  ICollectionBase
	{
		void Clear();

		int Count { get; }

		object this[int Index] { get; }

		IEnumerator GetEnumerator();
	}
}
