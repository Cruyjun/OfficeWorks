-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.7.0 PARA A VERSÃO 5.7.1
--
-- ---------------------------------------------------------------------------------


PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.7.0 PARA 5.7.1'
PRINT ''
GO

CREATE PROCEDURE OW.usp_GetRegistersByProperties
(
	------------------------------------------------------------------------	
	--Created: 20-12-2009 19:00:00
	--Version: 1.0	
	--Description: Select registers by entityNIF
	------------------------------------------------------------------------
	@userLogin varchar(50) = NULL,
	@entityNIF varchar(30) = NULL,
	@applicationUrl varchar(256) = NULL
)
AS
BEGIN 
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @userID AS INT

	SELECT @userID = UserID FROM  OW.tblUser WHERE upper(userLogin)=upper(@userLogin)

	IF (@userID IS NOT NULL AND @entityNIF IS NOT NULL AND @entityNIF <> '')
	BEGIN 
	SELECT DISTINCT   
		OW.tblRegistry.BookID, 
		OW.tblBooks.Abreviation,
		OW.tblBooks.Designation,
		OW.tblRegistry.RegID,  
		OW.tblRegistry.Number,  
		OW.tblRegistry.Year,  
		OW.tblRegistry.Subject,  
		OW.tblRegistry.Date,
		@applicationUrl + Cast(OW.tblRegistry.RegID as varchar(20)) AS ShowRegisterUrl
	
	FROM 
		OW.tblBooks, 
		OW.tblRegistry 
	WHERE  
		
		OW.tblRegistry.bookid=OW.tblBooks.bookid AND
		OW.tblRegistry.entID IN ( SELECT EntID FROM OW.tblEntities WHERE NumContribuinte = @entityNIF) AND
		OW.tblRegistry.bookID IN (
			SELECT BookID FROM  OW.tblBooks 
			WHERE (BookID NOT IN 
				(SELECT DISTINCT ObjectID FROM  OW.tblAccess WHERE ObjectTypeID=2 AND ObjectParentID=1) OR BookID IN 
				(SELECT DISTINCT ObjectID FROM  OW.tblAccess WHERE ((userID = @userID) AND ObjectType=1 AND ObjectTypeID=2 AND ObjectParentID=1) OR (UserID IN 
				(SELECT DISTINCT GroupID FROM  OW.tblGroupsUsers WHERE UserID = @userID) AND ObjectType=2 AND ObjectTypeID=2 AND ObjectParentID=1) AND (BookID NOT IN 
				(SELECT DISTINCT ObjectID FROM  OW.tblAccess WHERE ObjectTypeID=2 AND ObjectParentID=1 AND ObjectType=1 AND userid = @userID )))) 
		) AND
		(OW.tblRegistry.regID NOT IN (
			SELECT objectID FROM   OW.tblAccessReg) OR OW.tblRegistry.regID IN (
			SELECT objectID FROM OW.tblAccessReg WHERE ((userID IN (@userID) AND ObjectType=1 ) OR (UserID IN(
			SELECT GroupID FROM  OW.tblGroupsUsers WHERE UserID IN (@userID)) AND ObjectType=2 )))) 
			ORDER BY Year, number
	END

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_GetRegistersByProperties Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_GetRegistersByProperties Error on Creation'


GO



UPDATE OW.tblVersion SET version = '5.7.1' WHERE id= 1
GO

PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.7.0 PARA 5.7.1'
PRINT ''
GO
