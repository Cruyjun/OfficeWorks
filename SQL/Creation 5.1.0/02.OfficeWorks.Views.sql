/*==============================================================*/
/* View: VREGISTRYEX01 */
/* - Para o HESE (esta view deve ser optimizada futuramente)*/
/*==============================================================*/
CREATE  VIEW OW.VREGISTRYEX01 AS
	--tblRegistry
	SELECT     		
		r.regid, 
		r.FisicalID, 
		'R' As 'Table',
		b.abreviation, 
		CAST(r.[year] AS varchar(4)) + '/' + CAST(r.number AS varchar(10)) As 'Number',
		r.subject, 
		CONVERT(varchar(10), r.[date], 101) As 'Date',
		rd.FileID
	FROM    
		OW.tblRegistry r
	INNER JOIN
		OW.tblBooks b
	ON 
		r.bookid = b.bookID 
	LEFT JOIN
		OW.tblRegistryDocuments rd
	ON r.regid = rd.RegID
UNION
	--tblRegistryHist
	SELECT     		
		r.regid, 
		r.FisicalID, 
		'H' As 'Table',
		b.abreviation, 
		CAST(r.[year] AS varchar(4)) + '/' + CAST(r.number AS varchar(10)) As 'Number', 
		r.subject, 
		CONVERT(varchar(10), r.[date], 101) As 'Date',		
		rd.FileID
	FROM    
		OW.tblRegistryHist r
	INNER JOIN
		OW.tblBooks b
	ON 
		r.bookid = b.bookID 
	LEFT JOIN
		OW.tblRegistryDocuments rd
	ON r.regid = rd.RegID

GO