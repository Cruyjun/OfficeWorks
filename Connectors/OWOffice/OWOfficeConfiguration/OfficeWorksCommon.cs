using System;

namespace OfficeWorks.OWOffice
{
	#region enumEntityType

	/// <summary>
	/// Enumerator for OfficeWorks Entity Types
	/// </summary>
	public enum enumEntityType
	{
		EntityTypeDestiny = 0,
		EntityTypeOrigin = 1
	}

	#endregion

	#region enumFieldName

	/// <summary>
	/// Enumerator for OfficeWorks Name Fields
	/// </summary>
	public enum enumFieldName : short
	{
		FieldNameYear = 1,
		FieldNameNumber = 2,
		FieldNameRegistryDate = 3,
		FieldNameDocumentDate = 4,
		FieldNameEntity = 5,
		FieldNameClassification = 6,
		FieldNameSubject = 7,
		FieldNameObservations = 8,
		FieldNameKeywords = 9,
		FieldNameBook = 10,
		FieldNameReference = 11,
		FieldNameQuote = 12,
		FieldNameProcess = 13,
		FieldNameBlock = 14,
		FieldNameAccesses = 15,
		FieldNamePreviousRegistry = 16,
		FieldNameDistributions = 17,
		FieldNameFiles = 18,
		FieldNameMoreEntities = 19,
		FieldNameDocumentType = 20,
		FieldNameValue = 21,
		FieldNameCoin = 22,

		//Campos do OWArchive
		FieldNameFundo = 23,
		FieldNameSerie = 24,
		FieldNameBCUnit = 25,
		FieldNameLocFisica = 26,
		FieldNameProdEntity = 27,
		FieldNameActiveDate = 28,
		FieldNameBCRegistry = 29,

		FieldNameDinamic = 30
	}

	#endregion
}
