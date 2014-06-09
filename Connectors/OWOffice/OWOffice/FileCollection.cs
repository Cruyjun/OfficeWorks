using System.Runtime.InteropServices;
using System.IO;
using OfficeWorks.OWOffice.OWApiWebService;
using OfficeWorks.OWOffice.Common;
using System.Collections;

namespace OfficeWorks.OWOffice
{	
	#region FileCollection Interface

	/// <summary>
	/// OWOfficeMapper Class Interface Declaration
	/// </summary>
	[Guid("8FCD52F3-FD62-46fd-84B8-5EA4E35CDF6D"), ComVisible(true)]	
	public interface IFileCollection
	{
		void AddFile(string FilePath);

		void Clear();

		int Count { get; }		

		IEnumerator GetEnumerator();
	}

	#endregion

	#region FileCollection Class

	[Guid("6313443A-CA9D-4e5f-96E2-C71CEA30955F"), ClassInterface(ClassInterfaceType.None), ComVisible(true)]	
	public class FileCollection :Common.CollectionBase, IFileCollection
	{
		#region Properties

		/// <summary>
		/// Get or Set a Object
		/// </summary>
		public stFile this[int Index]
		{
			get
			{
				return (stFile)this.List[Index];
			}
			set
			{
				this.List[Index] = value;
			}
		}

		#endregion

		#region METHODS		

		/// <summary>
		/// Add a File to collection
		/// </summary>
		/// <param name="FilePath"></param>
		public void AddFile(string FilePath) 
		{
			//Test if File Exists
			if(!File.Exists(FilePath)) 
			{
				throw new OWOfficeException(OWOfficeException.enumExceptionsID.FileNotFOUND, FilePath);
			}

			//Create a new File struct
			stFile oFile = new stFile();

			//Convert File to byte Array			
			oFile.FileArray = FileToArray(FilePath);

			//Get File Path
			oFile.FilePath = FilePath;
			//Get File Name
			string[] Aux = FilePath.Split('\\');
			oFile.FileName = Aux[Aux.Length - 1];

			//Add File struct To Global Array List 
			this.List.Add(oFile);
		}		


		/// <summary>
		/// Convert a File by giving it´s Path to a byte array 
		/// </summary>
		/// <param name="FilePath">File Path</param>
		/// <returns></returns>
		private byte[] FileToArray(string FilePath) 
		{
			//Open the File 						
			FileStream oFile = File.Open(FilePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
			//Create a buffer
			byte[] bFile = new byte[oFile.Length];
			//Read File
			oFile.Read(bFile, 0, (int)oFile.Length);
			//Close file
			oFile.Close();
			
			//Return file array	
			return bFile;
		}


		#endregion
	}

	#endregion
}
