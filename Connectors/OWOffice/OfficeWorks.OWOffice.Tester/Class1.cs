using System;
using OfficeWorks.OWOffice;

namespace OfficeWorks.OWOffice.Tester
{
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	class Class1
	{
		private static void TestRequestForUserSignature(OfficeWorks.OWOffice.Template oTemplate)
		{
			//''Insert request for signature
			oTemplate.RequestForUserSignature ("ASSDOC", "Pedido de assinatura de XXX" , oTemplate.AttachedFilesForSignature);
		    			
			//''Save file to attach
			string sFileToAttach = @"D:\vss\OfficeWorks\Versão 5.0.0\Sources\Connectors\OWOffice\DefaultTemplate\TemplateY.dot";
		    
			//''Attach Active Document to process for signature
			oTemplate.AttachedFilesForSignature.AddFile (sFileToAttach);
		    
			//''Attach file to process
			oTemplate.AddProcessFiles( Convert.ToInt32(oTemplate.InsertedProcessID), oTemplate.AttachedFilesForSignature, false);
		    
			//''Clear files collection
			oTemplate.AttachedFilesForSignature.Clear();
		}

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main()
		{

			OfficeWorks.OWOffice.Template oTemplate = new Template();

			//ini Mapper Configuration object
			try
			{
				oTemplate.LoadConfiguration (@"C:\vss\OfficeWorks\Versão 5.0.0\Sources\Connectors\OWOffice\DefaultTemplate\Template.owc", "", "");
			}
			catch(Exception ex)
			{
				Console.WriteLine(ex.Message);
			}

			// Teste pedir assinatura
			TestRequestForUserSignature(oTemplate);
		    
			BasicOrganizationalUnits.BasicOrganizationalUnitCollation bouc = oTemplate.GetOrganizationalUnitsByBook();

			foreach (BasicOrganizationalUnits.BasicOrganizationalUnit bou in bouc)
			{				
				Console.WriteLine(bou.ID.ToString() + "=" + bou.Description);
				oTemplate.Accesses.Add(bou);
			}
			
			oTemplate.Bookmarks.AddMapping ("ASSUNTO", "12345");
			oTemplate.Bookmarks.AddMapping ("OBSERVACOES", "OBS");
		    
		    oTemplate.ShowRegistry = false;
			//Insert Registry data
			oTemplate.InsertRegistry();

			//Add File
			oTemplate.AttachedFiles.AddFile(@"c:\Doc1.doc");
			
			//Update Registry
			oTemplate.ShowRegistry = true;
			oTemplate.AddRegistryFiles();

		    Console.WriteLine(oTemplate.InsertedRegistryNumber);
			Console.WriteLine(oTemplate.InsertedRegistryYear);
			Console.WriteLine(oTemplate.BookAbreviation);
			Console.WriteLine(oTemplate.BookDescription);

			Console.ReadLine();
		}
	}
}
