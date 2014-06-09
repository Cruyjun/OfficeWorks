/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_SetEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_SetEntitiesGroups]
GO
/* NOVO */
GO
CREATE PROCEDURE [OW].[usp_SetEntitiesGroups]
(
	@EntID numeric(18,0),
	@FirstName varchar(50),
	@ListID numeric (18,0)
)
AS
	SET NOCOUNT ON
	
	UPDATE [OW].[tblEntities]
	SET
		[OW].[tblEntities].[FirstName] = @FirstName,
		[OW].[tblEntities].[ListID] = @ListID
	WHERE 
		[OW].[tblEntities].[EntID] = @EntID

	RETURN @@Error

GO

-- Remover usp_GetEntitiesGroups
/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_GetEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_GetEntitiesGroups]
GO

-- Criar usp_GetEntitiesGroups
GO
/* NOVO */
CREATE  PROCEDURE OW.usp_GetEntitiesGroups

	AS
	
	SELECT
	     	OW.tblEntities.EntID, 
		OW.tblEntities.PublicCode,
		OW.tblEntities.Name, 
		OW.tblEntities.Type,
		OW.tblEntityList.Description,
		OW.tblEntities.ListID,
		OW.tblEntities.EntityTypeID
	FROM    
		OW.tblEntities INNER JOIN
                OW.tblEntityList ON 
		OW.tblEntities.ListID = OW.tblEntityList.ListID
	WHERE
		OW.tblEntities.Type = 2
	ORDER BY 
		OW.tblEntities.Name
	
	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0
GO

/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_DeleteEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_DeleteEntitiesGroups]
GO

/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_DelEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_DelEntitiesGroups]
GO

/* NOVO */
CREATE PROCEDURE [OW].[usp_DelEntitiesGroups]
(
	@EntID numeric(18,0)
)
AS
	SET NOCOUNT ON

	DELETE 
	FROM   [OW].[tblEntities]
	WHERE  
		[OW].[tblEntities].[EntID] = @EntID

	RETURN @@Error

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_GetGroupsEntities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_GetGroupsEntities]
GO

CREATE   PROCEDURE OW.usp_GetGroupsEntities
(
	@ENTID numeric(18,0)=null,
	@Description varchar(255)=null
)

AS

IF ( @ENTID is null and @Description is null)
BEGIN
		SELECT ENTID, NAME, TYPE 
		FROM OW.tblentities
		where type=2
END
ELSE
BEGIN 
	IF (@ENTID is not null and @Description is null)
	BEGIN
		SELECT ENTID, NAME, TYPE 
		FROM OW.tblentities 
		WHERE EXISTS (SELECT 1 
					  FROM OW.tblGroupsEntities tge
					  WHERE tge.EntID = @ENTID AND
							tge.ObjectID=OW.tblentities.EntID) 
	END
	ELSE
	BEGIN
		IF (@ENTID is null and @Description is not null)
		BEGIN
				SELECT ENTID, NAME, TYPE 
				FROM OW.tblentities 
				WHERE Name like @Description
				AND type=2 
		END
		ELSE
		BEGIN  -- Both are not null
			SELECT ENTID, NAME, TYPE 
			FROM OW.tblentities 
			WHERE (Name like @Description
				AND type=2) OR
			EXISTS (SELECT 1 
					FROM OW.tblGroupsEntities tge
					WHERE tge.EntID = @ENTID AND
					tge.ObjectID=OW.tblentities.EntID) 		
		END
	END
END

RETURN @@ERROR

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_DelGroupsEntities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_DelGroupsEntities]
GO


CREATE PROCEDURE OW.usp_DelGroupsEntities
	(
		@EntID numeric,
		@ObjectId as numeric
	)
AS


	SET XACT_ABORT ON

	BEGIN TRANSACTION
		
		DELETE FROM [OW].[tblGroupsEntities]
		WHERE 
			EntID = @EntID
			AND ObjectId = @ObjectId
		
				
	COMMIT TRANSACTION
	RETURN 0


GO


if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_NewGroupsEntities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_NewGroupsEntities]
GO

CREATE PROCEDURE OW.usp_NewGroupsEntities
	(
		@EntID numeric,
		@list as ntext
	)
AS


	SET XACT_ABORT ON

	BEGIN TRANSACTION

		IF @list is not null
		BEGIN
			INSERT OW.tblGroupsEntities (EntID,ObjectID)
			SELECT @EntID,ObjectID FROM
			(SELECT cast (value as numeric) As ObjectID
			FROM OW.fnListToTable(@list,',') ) as tObjectIDs
			WHERE not exists (SELECT 1 FROM OW.tblGroupsEntities as tge WHERE 
			tge.EntID=@EntID AND 
		  	tge.ObjectID = tObjectIDs.ObjectID )
		END
		
	COMMIT TRANSACTION
	RETURN 0

/*******************************************************************************************************************/
GO


CREATE PROCEDURE OW.SetContactField
	(
		@Desc varchar(50),
		@ID numeric
	)
AS
	SET NOCOUNT ON 
	UPDATE OW.tblFields SET Description=@Desc
	WHERE FieldID=@ID
	return @@ERROR
GO



/* **************************************************************************************** */
/*                                    Webservice                                            */
/* **************************************************************************************** */


CREATE PROCEDURE OW.usp_SetEntity
 
@firstName varchar(50),
@middleName varchar(300) = '',
@lastName varchar(50) = '',
@eMail varchar(300),
@listId int,
@active int = 1,
@type int = 1
 
AS
 
declare @result int 
declare @EntID numeric
set @result = 0
 
 
 
select @result = count(*) from OW.tblEntities where eMail = @eMail
 
if (@result = 0)
begin
 
 insert into OW.tblEntities (FirstName, MiddleName, LastName, eMail, ListID, Active, Type) values (@firstName, @middleName, @lastName, @eMail, @listId, @active, @type)
 SET @EntID = @@identity
end
else
begin
 
 SELECT @EntID=EntID FROM OW.tblEntities WHERE eMail = @eMail and active <> 1
 
 IF (@EntID>0 )
 BEGIN
   UPDATE OW.tblEntities  SET active=1
   WHERE eMail = @eMail and active <> 1
 END
 ELSE
 BEGIN
  select @EntID=EntID from OW.tblEntities where eMail = @eMail and active=1
 END
END
 
 SELECT @EntID As EntID
 return @@error
GO





CREATE PROCEDURE OW.usp_AddFileToRegistry
    (
        @RegID numeric,
        @FileName varchar(300),
        @FilePath varchar(300),
        @UserID numeric(18,0)
    )
AS

    SET NOCOUNT ON

SET XACT_ABORT ON
BEGIN TRANSACTION
    DECLARE @TempPath varchar(15)
    DECLARE @FileExtension int
    DECLARE @TempNumber int

    DECLARE @NextNumber numeric(18,0)
    
INSERT INTO OW.tblFileManager (FileName,FilePath,CreateDate,CreateUserID) 
	VALUES (@FileName,' ',GetDate(),@UserID)    
    
    SET @NextNumber=@@IDENTITY
                
    SET @FileExtension = LEN(@FileName)
    SET @TempNumber = @NextNumber
    SET @TempPath = ''

    WHILE (@TempNumber > 0)
    BEGIN
        SET @TempPath = @TempPath + (
        CASE (@TempNumber % 16)
            WHEN 0 THEN '0'
            WHEN 1 THEN '1'
            WHEN 2 THEN '2'
            WHEN 3 THEN '3'
            WHEN 4 THEN '4'
            WHEN 5 THEN '5'
            WHEN 6 THEN '6'
            WHEN 7 THEN '7'
            WHEN 8 THEN '8'
            WHEN 9 THEN '9'
            WHEN 10 THEN 'A'
            WHEN 11 THEN 'B'
            WHEN 12 THEN 'C'
            WHEN 13 THEN 'D'
            WHEN 14 THEN 'E'
            WHEN 15 THEN 'F'
        END)
        SET @TempNumber = @TempNumber / 16
    END
    SET @TempPath = '00000000' + REVERSE(@TempPath)
    SET @TempPath = SUBSTRING(@TempPath, LEN(@TempPath) - 7, LEN(@TempPath))
    SET @TempPath = '\' + SUBSTRING(@TempPath, 1, 2) + '\' + SUBSTRING(@TempPath, 3, 2) + '\' + SUBSTRING(@TempPath, 5, 2) + '\' + SUBSTRING(@TempPath, 7, 2)

    SET @FilePath = @FilePath + @TempPath

    WHILE (@FileExtension > 0)
    BEGIN
        IF SUBSTRING(@FileName, @FileExtension, 1) = '.'
        BEGIN
            SET @FilePath = @FilePath + SUBSTRING(@FileName, @FileExtension, (LEN(@FileName) + 1) - @FileExtension)
            BREAK
        END
        SET @FileExtension = @FileExtension - 1
    END


	-- Update file path	
	UPDATE  OW.tblFileManager SET FilePath=@FilePath
	WHERE FileID=@NextNumber
	
	-- Set registry association
INSERT INTO OW.tblRegistryDocuments (RegID,FileID) VALUES
(@RegID,@NextNumber)	
	
/*
    INSERT INTO OW.tblFileManager ([FileID], [RegID], [FileName], [FilePath])
    VALUES (@NextNumber, @RegID, @FileName, @FilePath)
*/    
    IF @@ERROR = 0
        SELECT @NextNumber AS RegFileID
    ELSE
        SELECT 0 AS RegFileID
COMMIT TRANSACTION
GO

/****** Object:  Stored Procedure OW.usp_GetEntityID    Script Date: 28-07-2004 18:18:03 ******/
GO

CREATE PROCEDURE OW.usp_GetEntityID
    (
        @Name varchar(200) = Null,
        @ContactID nvarchar(250) = Null
    )
AS
SET NOCOUNT ON

SET CONCAT_NULL_YIELDS_NULL OFF

SELECT EntID FROM OW.tblEntities 
WHERE (RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' ')))) LIKE @NAME

RETURN @@ERROR


GO





/****** Object:  Stored Procedure OW.usp_GetDocTypeID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDocTypeID
    (
        @abreviation nvarchar(20) = Null,
        @designation nvarchar(100) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @DocTypeID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(300)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT DocTypeID FROM OW.tblDocumentType'

    IF LEN(@abreviation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'abreviation like ''' + @abreviation + ''''
        END

    IF LEN(@designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'designation like ''' + @designation + ''''
        END

    EXEC sp_ExecuteSQL @Query


GO


/****** Object:  Stored Procedure OW.usp_GetBookID    Script Date: 12/4/2003 15:36:46 ******/

CREATE  PROCEDURE OW.usp_GetBookID
    (
		@login VARCHAR(900),
		@role  NUMERIC,
        @abreviation nvarchar(20)  = Null,
        @designation nvarchar(100)  = Null,
        @BookID numeric(18,0) = null
    )
AS

    SET NOCOUNT ON    
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(4000)
	DECLARE @USERID NUMERIC
	SET @USERID = (SELECT userID FROM OW.tblUser WHERE userLogin=@login)


    SET @NumberOfParameters = 0
    SET @Query = 'SELECT BookID FROM OW.tblBooks'

    IF (@BookID is null) AND LEN(@abreviation) > 0 
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'abreviation like ''' + @abreviation + ''''
        END

    IF (@BookID is null)  AND LEN(@designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'designation like ''' + @designation + ''''
        END


	IF @BookID is not null 
	BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'BookID=' + cast (@BookID as varchar)
	END


   IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
   SET @NumberOfParameters = @NumberOfParameters + 1   
   IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '

   SET @Query = @Query + 
   ' (BookID IN (SELECT DISTINCT ObjectID ' +
			   ' FROM  OW.tblAccess ' +
			   ' WHERE (userID = ' + cast (@USERID as varchar) + 
			   ' AND ObjectType=1 AND ObjectTypeID=2 ' +
			   ' AND ObjectParentID=1 AND AccessType >=' + cast(@role as varchar) + ') ' + 
			   ' OR (UserID IN (SELECT DISTINCT GroupID FROM  OW.tblGroupsUsers ' + 
			 				 ' WHERE UserID = ' + cast(@USERID as varchar) + ' ) ' +
							 ' AND ObjectType=2 AND ObjectTypeID=2 AND ObjectParentID=1) ' + 
						     ' AND (BookID NOT IN (SELECT DISTINCT ObjectID ' +
							  				     ' FROM  OW.tblAccess ' + 
												 ' WHERE ObjectTypeID=2 AND ObjectParentID=1 ' + 
												 ' AND ObjectType=1 ' + 
												 'AND userid=' + cast (@USERID as varchar) + ')) ' + 
												 ' AND AccessType >=' + cast(@role as varchar) + '))'		
		

EXEC sp_ExecuteSQL @Query

GO

/****** Object:  Stored Procedure OW.usp_GetClassificationID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetClassificationID
    (
        @Level1 nvarchar(50) = Null,
        @Level2 nvarchar(50) = Null,
        @Level3 nvarchar(50) = Null,
        @Level4 nvarchar(50) = Null,
        @Level5 nvarchar(50) = Null,
        @Level1Designation nvarchar(100) = Null,
        @Level2Designation nvarchar(100) = Null,
        @Level3Designation nvarchar(100) = Null,
        @Level4Designation nvarchar(100) = Null,
        @Level5Designation nvarchar(100) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @ClassificationID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(1000)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT ClassID FROM OW.tblClassification'

    IF LEN(@Level1) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level1 like ''' + @Level1 + ''''
        END
    ELSE
        IF @Level1 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level1 is NULL'
            END

    IF LEN(@Level2) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level2 like ''' + @Level2 + ''''
        END
    ELSE
        IF @Level2 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level2 is NULL'
            END

    IF LEN(@Level3) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level3 like ''' + @Level3 + ''''
        END
    ELSE
        IF @Level3 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level3 is NULL'
            END

    IF LEN(@Level4) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level4 like ''' + @Level4 + ''''
        END
    ELSE
        IF @Level4 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level4 is NULL'
            END

    IF LEN(@Level5) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level5 like ''' + @Level5 + ''''
        END
    ELSE
        IF @Level5 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level5 is NULL'
            END

    IF LEN(@Level1Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level1Desig like ''' + @Level1Designation + ''''
        END
    ELSE
        IF @Level1Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level1Desig is NULL'
            END

    IF LEN(@Level2Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level2Desig like ''' + @Level2Designation + ''''
        END
    ELSE
        IF @Level2Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level2Desig is NULL'
            END

    IF LEN(@Level3Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level3Desig like ''' + @Level3Designation + ''''
        END
    ELSE
        IF @Level3Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level3Desig is NULL'
            END

    IF LEN(@Level4Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level4Desig like ''' + @Level4Designation + ''''
        END
    ELSE
        IF @Level4Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level4Desig is NULL'
            END

    IF LEN(@Level5Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level5Desig like ''' + @Level5Designation + ''''
        END
    ELSE
        IF @Level5Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level5Desig is NULL'
            END

    EXEC sp_ExecuteSQL @Query

GO

/****** Object:  Stored Procedure OW.usp_GetUserID    Script Date: 28-07-2004 18:18:04 ******/
GO

CREATE PROCEDURE OW.usp_GetUserID
    (
        @UserLogin varchar(900) = Null,
        @UserDesc varchar(300) = Null,
        @UserMail varchar(200) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @UserID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(700)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT UserID,userLogin FROM OW.tblUser'

    IF LEN(@userLogin) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'userLogin like ''' + @userLogin + ''''
        END

    IF LEN(@userDesc) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'userDesc like ''' + @userDesc + ''''
        END

    IF LEN(@userMail) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'userMail like ''' + @userMail + ''''
        END

    EXEC sp_ExecuteSQL @Query

GO

/****** Object:  Stored Procedure OW.usp_InsertFullRegistry    Script Date: 28-07-2004 18:18:04 ******/
GO

CREATE PROCEDURE OW.usp_InsertFullRegistry
    (
        @DocTypeAbreviation nvarchar(20),
        @DocTypeDesignation nvarchar(100),
        @BookAbreviation nvarchar(20),
        @BookDesignation nvarchar(100),
        @Year numeric,
        @Number numeric,
        @Date datetime,
        @OriginRef varchar(30),
        @OriginDate datetime,
        @Subject nvarchar(250),
        @Observations nvarchar(250),
        @ProcessNumber nvarchar(50),
        @Cota nvarchar(50),
        @Bloco nvarchar(50),
        @Level1 nvarchar(50),
        @Level2 nvarchar(50),
        @Level3 nvarchar(50),
        @Level4 nvarchar(50),
        @Level5 nvarchar(50),
        @Level1Designation nvarchar(100),
        @Level2Designation nvarchar(100),
        @Level3Designation nvarchar(100),
        @Level4Designation nvarchar(100),
        @Level5Designation nvarchar(100),
        @UserLogin varchar(900),
        @UserDesc varchar(300),
        @UserMail varchar(200),
        @AntecedenteID numeric = NULL,
        @EntityName varchar(200),
        @EntityContactID nvarchar(250),
        @UserModifyLogin varchar(900),
        @UserModifyDesc varchar(300),
        @UserModifyMail varchar(200),
        @DateModify datetime = NULL,
        @Historic bit = 0,
        @Field1 float,
        @Field2 nvarchar(50)	
    )
AS
    SET NOCOUNT ON
    DECLARE @DocTypeID numeric
    DECLARE @BookID numeric
    DECLARE @ClassificationID numeric
    DECLARE @UserID numeric
    DECLARE @EntityID numeric
    DECLARE @UserModifyID numeric



    EXEC @DocTypeID = OW.usp_GetDocTypeID @DocTypeAbreviation, @DocTypeDesignation
    if(@@ERROR <> 0) return(1)
    EXEC @BookID = OW.usp_GetBookID @BookAbreviation, @BookDesignation
    if(@@ERROR <> 0) return(1)
    EXEC @ClassificationID = OW.usp_GetClassificationID @Level1, @Level2, @Level3, @Level4, @Level5, @Level1Designation, @Level2Designation, @Level3Designation, @Level4Designation, @Level5Designation
    if(@@ERROR <> 0) return(1)
    EXEC @UserID = OW.usp_GetUserID @UserLogin, @UserDesc, @UserMail
    if(@@ERROR <> 0) return(1)
    EXEC @EntityID = OW.usp_GetEntityID @EntityName, @EntityContactID
    if(@@ERROR <> 0) return(1)
    EXEC @UserModifyID = OW.usp_GetUserID @UserModifyLogin, @UserModifyDesc, @UserModifyMail
    if(@@ERROR <> 0) return(1)





GO









/***********************************************************************************************/
/*                                        Log SPS                                              */
/***********************************************************************************************/
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].LogSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [dbo].LogSelect;
GO

CREATE PROCEDURE [dbo].LogSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-12-2005 11:34:48
	--Version: 1.0	
	------------------------------------------------------------------------
	@LogID int = NULL,
	@EventID int = NULL,
	@Category nvarchar(64) = NULL,
	@Priority int = NULL,
	@Severity nvarchar(32) = NULL,
	@Title nvarchar(256) = NULL,
	@Timestamp datetime = NULL,
	@MachineName nvarchar(32) = NULL,
	@AppDomainName nvarchar(2048) = NULL,
	@ProcessID nvarchar(256) = NULL,
	@ProcessName nvarchar(2048) = NULL,
	@ThreadName nvarchar(2048) = NULL,
	@Win32ThreadId nvarchar(128) = NULL,
	@Message nvarchar(2048) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[LogID],
		[EventID],
		[Category],
		[Priority],
		[Severity],
		[Title],
		[Timestamp],
		[MachineName],
		[AppDomainName],
		[ProcessID],
		[ProcessName],
		[ThreadName],
		[Win32ThreadId],
		[Message],
		[FormattedMessage]
	FROM [dbo].[Log]
	WHERE
		(@LogID IS NULL OR [LogID] = @LogID) AND
		(@EventID IS NULL OR [EventID] = @EventID) AND
		(@Category IS NULL OR [Category] LIKE @Category) AND
		(@Priority IS NULL OR [Priority] = @Priority) AND
		(@Severity IS NULL OR [Severity] LIKE @Severity) AND
		(@Title IS NULL OR [Title] LIKE @Title) AND
		(@Timestamp IS NULL OR [Timestamp] = @Timestamp) AND
		(@MachineName IS NULL OR [MachineName] LIKE @MachineName) AND
		(@AppDomainName IS NULL OR [AppDomainName] LIKE @AppDomainName) AND
		(@ProcessID IS NULL OR [ProcessID] LIKE @ProcessID) AND
		(@ProcessName IS NULL OR [ProcessName] LIKE @ProcessName) AND
		(@ThreadName IS NULL OR [ThreadName] LIKE @ThreadName) AND
		(@Win32ThreadId IS NULL OR [Win32ThreadId] LIKE @Win32ThreadId) AND
		(@Message IS NULL OR [Message] LIKE @Message)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [dbo].LogSelect Succeeded'
ELSE PRINT 'Procedure Creation: [dbo].LogSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].LogSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [dbo].LogSelectPaging;
GO

CREATE PROCEDURE [dbo].LogSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-12-2005 11:34:48
	--Version: 1.0	
	------------------------------------------------------------------------
	@LogID int = NULL,
	@EventID int = NULL,
	@Category nvarchar(64) = NULL,
	@Priority int = NULL,
	@Severity nvarchar(32) = NULL,
	@Title nvarchar(256) = NULL,
	@Timestamp datetime = NULL,
	@MachineName nvarchar(32) = NULL,
	@AppDomainName nvarchar(2048) = NULL,
	@ProcessID nvarchar(256) = NULL,
	@ProcessName nvarchar(2048) = NULL,
	@ThreadName nvarchar(2048) = NULL,
	@Win32ThreadId nvarchar(128) = NULL,
	@Message nvarchar(2048) = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@LogID IS NOT NULL) SET @WHERE = @WHERE + '([LogID] = @LogID) AND '
	IF(@EventID IS NOT NULL) SET @WHERE = @WHERE + '([EventID] = @EventID) AND '
	IF(@Category IS NOT NULL) SET @WHERE = @WHERE + '([Category] LIKE @Category) AND '
	IF(@Priority IS NOT NULL) SET @WHERE = @WHERE + '([Priority] = @Priority) AND '
	IF(@Severity IS NOT NULL) SET @WHERE = @WHERE + '([Severity] LIKE @Severity) AND '
	IF(@Title IS NOT NULL) SET @WHERE = @WHERE + '([Title] LIKE @Title) AND '
	IF(@Timestamp IS NOT NULL) SET @WHERE = @WHERE + '([Timestamp] = @Timestamp) AND '
	IF(@MachineName IS NOT NULL) SET @WHERE = @WHERE + '([MachineName] LIKE @MachineName) AND '
	IF(@AppDomainName IS NOT NULL) SET @WHERE = @WHERE + '([AppDomainName] LIKE @AppDomainName) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] LIKE @ProcessID) AND '
	IF(@ProcessName IS NOT NULL) SET @WHERE = @WHERE + '([ProcessName] LIKE @ProcessName) AND '
	IF(@ThreadName IS NOT NULL) SET @WHERE = @WHERE + '([ThreadName] LIKE @ThreadName) AND '
	IF(@Win32ThreadId IS NOT NULL) SET @WHERE = @WHERE + '([Win32ThreadId] LIKE @Win32ThreadId) AND '
	IF(@Message IS NOT NULL) SET @WHERE = @WHERE + '([Message] LIKE @Message) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(LogID) 
	FROM [dbo].[Log]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@LogID int, 
		@EventID int, 
		@Category nvarchar(64), 
		@Priority int, 
		@Severity nvarchar(32), 
		@Title nvarchar(256), 
		@Timestamp datetime, 
		@MachineName nvarchar(32), 
		@AppDomainName nvarchar(2048), 
		@ProcessID nvarchar(256), 
		@ProcessName nvarchar(2048), 
		@ThreadName nvarchar(2048), 
		@Win32ThreadId nvarchar(128), 
		@Message nvarchar(2048),
		@RowCount bigint OUTPUT',
		@LogID, 
		@EventID, 
		@Category, 
		@Priority, 
		@Severity, 
		@Title, 
		@Timestamp, 
		@MachineName, 
		@AppDomainName, 
		@ProcessID, 
		@ProcessName, 
		@ThreadName, 
		@Win32ThreadId, 
		@Message,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE LogID IN (
		SELECT TOP ' + @SizeString + ' LogID
			FROM [dbo].[Log]
			WHERE LogID NOT IN (
				SELECT TOP ' + @PrevString + ' LogID 
				FROM [dbo].[Log]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[LogID], 
		[EventID], 
		[Category], 
		[Priority], 
		[Severity], 
		[Title], 
		[Timestamp], 
		[MachineName], 
		[AppDomainName], 
		[ProcessID], 
		[ProcessName], 
		[ThreadName], 
		[Win32ThreadId], 
		[Message], 
		[FormattedMessage]
	FROM [dbo].[Log]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@LogID int, 
		@EventID int, 
		@Category nvarchar(64), 
		@Priority int, 
		@Severity nvarchar(32), 
		@Title nvarchar(256), 
		@Timestamp datetime, 
		@MachineName nvarchar(32), 
		@AppDomainName nvarchar(2048), 
		@ProcessID nvarchar(256), 
		@ProcessName nvarchar(2048), 
		@ThreadName nvarchar(2048), 
		@Win32ThreadId nvarchar(128), 
		@Message nvarchar(2048)',
		@LogID, 
		@EventID, 
		@Category, 
		@Priority, 
		@Severity, 
		@Title, 
		@Timestamp, 
		@MachineName, 
		@AppDomainName, 
		@ProcessID, 
		@ProcessName, 
		@ThreadName, 
		@Win32ThreadId, 
		@Message
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [dbo].LogSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [dbo].LogSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].LogUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [dbo].LogUpdate;
GO

CREATE PROCEDURE [dbo].LogUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-12-2005 11:34:48
	--Version: 1.0	
	------------------------------------------------------------------------
	@LogID int,
	@EventID int = NULL,
	@Category nvarchar(64),
	@Priority int,
	@Severity nvarchar(32),
	@Title nvarchar(256),
	@Timestamp datetime,
	@MachineName nvarchar(32),
	@AppDomainName nvarchar(2048),
	@ProcessID nvarchar(256),
	@ProcessName nvarchar(2048),
	@ThreadName nvarchar(2048) = NULL,
	@Win32ThreadId nvarchar(128) = NULL,
	@Message nvarchar(2048) = NULL,
	@FormattedMessage ntext = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [dbo].[Log]
	SET
		[EventID] = @EventID,
		[Category] = @Category,
		[Priority] = @Priority,
		[Severity] = @Severity,
		[Title] = @Title,
		[Timestamp] = @Timestamp,
		[MachineName] = @MachineName,
		[AppDomainName] = @AppDomainName,
		[ProcessID] = @ProcessID,
		[ProcessName] = @ProcessName,
		[ThreadName] = @ThreadName,
		[Win32ThreadId] = @Win32ThreadId,
		[Message] = @Message,
		[FormattedMessage] = @FormattedMessage
	WHERE
		[LogID] = @LogID
	
	SET @Err = @@Error
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50002,16,1)		
	END	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [dbo].LogUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [dbo].LogUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].LogInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [dbo].LogInsert;
GO

CREATE PROCEDURE [dbo].LogInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-12-2005 11:34:48
	--Version: 1.0	
	------------------------------------------------------------------------
	@LogID int = NULL OUTPUT,
	@EventID int = NULL,
	@Category nvarchar(64),
	@Priority int,
	@Severity nvarchar(32),
	@Title nvarchar(256),
	@Timestamp datetime,
	@MachineName nvarchar(32),
	@AppDomainName nvarchar(2048),
	@ProcessID nvarchar(256),
	@ProcessName nvarchar(2048),
	@ThreadName nvarchar(2048) = NULL,
	@Win32ThreadId nvarchar(128) = NULL,
	@Message nvarchar(2048) = NULL,
	@FormattedMessage ntext = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [dbo].[Log]
	(
		[EventID],
		[Category],
		[Priority],
		[Severity],
		[Title],
		[Timestamp],
		[MachineName],
		[AppDomainName],
		[ProcessID],
		[ProcessName],
		[ThreadName],
		[Win32ThreadId],
		[Message],
		[FormattedMessage]
	)
	VALUES
	(
		@EventID,
		@Category,
		@Priority,
		@Severity,
		@Title,
		@Timestamp,
		@MachineName,
		@AppDomainName,
		@ProcessID,
		@ProcessName,
		@ThreadName,
		@Win32ThreadId,
		@Message,
		@FormattedMessage
	)
	SET @Err = @@Error
	SELECT @LogID = SCOPE_IDENTITY()
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50001,16,1)		
	END	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [dbo].LogInsert Succeeded'
ELSE PRINT 'Procedure Creation: [dbo].LogInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].LogDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [dbo].LogDelete;
GO

CREATE PROCEDURE [dbo].LogDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-12-2005 11:34:48
	--Version: 1.0	
	------------------------------------------------------------------------
	@LogID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [dbo].[Log]
	WHERE
		[LogID] = @LogID
	SET @Err = @@Error
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50003,16,1)
	END	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [dbo].LogDelete Succeeded'
ELSE PRINT 'Procedure Creation: [dbo].LogDelete Error on Creation'
GO





/***********************************************************************************************/
/*                                      Registry SPS                                           */
/***********************************************************************************************/

go


/****** Object:  User Defined Function OW.usp_GetFieldOrderByProfileID  ******/
GO
CREATE PROCEDURE OW.usp_GetFieldOrderByProfileID
	(
		@FormFieldKey numeric,
		@ProfileId numeric
	)
AS
	

	select FormFieldOrder from OW.tblProfilesFields 
	where ProfileId = @ProfileId
	and FormFieldKey = @FormFieldKey




	RETURN @@ERROR
	
GO


go

CREATE PROCEDURE OW.usp_DeleteApplicationAccess
(
	@objectParentID numeric(18),
	@userID numeric(18) = 0
)
AS
	if @userID > 0 
	begin
		DELETE FROM OW.tblAccess
		WHERE userID = @userID
		AND objectTypeID = 1 --Constante TYPE_PRODUCT=1
		AND objectParentID = @objectParentID
	end 
	else
	begin
		DELETE FROM OW.tblAccess
		WHERE objectTypeID = 1 --Constante TYPE_PRODUCT=1
		AND objectParentID = @objectParentID
	end			

	RETURN @@ERROR


GO


CREATE PROCEDURE OW.GetContactNameByID
	(
		@ID numeric
	)
AS
-- Used By: GetContactNameByID in C#
SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF
	
SELECT RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) As [Name]
FROM OW.tblEntities 
WHERE  EntID=@ID
	
RETURN @@ERROR
go

CREATE PROCEDURE OW.usp_SetApplicationAccess
(
	@userID numeric,
	@objectID numeric,
	@objectParentID numeric
)
AS

	insert into OW.tblAccess (UserID, objectParentID, objectID, objectTypeID, AccessType, objectType)
	values (@userID, @objectParentID, @objectID, 1, null, 1)


	RETURN @@ERROR

go


CREATE PROCEDURE OW.usp_GetUsersAndRolesByProduct
	(
		@Product numeric(18,0),
		@Active bit = null
	)
AS

IF @Active is null
BEGIN
	SELECT cast(a.userID as varchar) + '|' + cast(a.ObjectID as varchar) as userID, u.userDesc + ' ['  + 
	case 
		when a.ObjectID = 2 then 'Utilizador' 
		when a.ObjectID = 7 then 'Gestor' 

	end + ']' as userDesc,
	u.userActive as userActive
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID 
	ORDER BY  u.userDesc
END
ELSE
BEGIN
	SELECT cast(a.userID as varchar) + '|' + cast(a.ObjectID as varchar) as userID, u.userDesc + ' ['  + 
	case 
		when a.ObjectID = 2 then 'Utilizador' 
		when a.ObjectID = 7 then 'Gestor' 

	end + ']' as userDesc,
	u.userActive as userActive
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID
	AND u.userActive=@Active
	ORDER BY  u.userDesc

END

RETURN @@ERROR
GO


CREATE PROCEDURE OW.usp_GetUsersInactiveByProduct

	(
	@Product numeric(18)
	)

AS

	SELECT u.userID, u.userLogin, u.userDesc, u.userMail, u.userActive
	FROM OW.tbluser u
	--where u.userActive = 1
	where not exists (
		select 1 from OW.tblAccess a
		where a.userID = u.userID
		and a.ObjectParentID= @Product 
		And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	)
	ORDER BY  u.userDesc
	
	
	RETURN @@ERROR
GO



/****** Object:  User Defined Function OW.fnDateValidator    Script Date: 28-07-2004 18:18:06 ******/
GO

-- select OW.fnDateValidator(getdate(), '1979-05-02', null)

CREATE FUNCTION OW.fnDateValidator
(
	@todayDate_i datetime,
	@startDate_i datetime,
	@endDate_i datetime

)
RETURNS INT
AS
BEGIN
	
	--if (@todayDate_i is null) return 1
	
	DECLARE @ret int
	DECLARE @date datetime
	DECLARE @eDate datetime
	DECLARE @sDate datetime

	SET @date = @todayDate_i

	if (@endDate_i is null) SET @eDate = @date
	else SET @eDate = @endDate_i

	if (@startDate_i is null) SET @sDate = @date
	else SET @sDate = @startDate_i

	if ( @eDate >= @date and @sDate <= @date)
		SET @ret=1
	else
		SET  @ret=0
	if (DATEDIFF(day,@date,@eDate)=0) and (DATEDIFF(day,@date,@sDate)=0)
		SET @ret=1
	RETURN @ret
END 

GO


/****** Object:  User Defined Function OW.fnListToTable    Script Date: 28-07-2004 18:18:06 ******/
GO


CREATE FUNCTION OW.fnListToTable
                    (@list      ntext,
                     @delimiter nchar(1) = N',')
         RETURNS @tbl TABLE (listpos int IDENTITY(1, 1) NOT NULL,
                             value     varchar(4000)) AS

   BEGIN
      DECLARE @pos      int,
              @textpos  int,
              @chunklen smallint,
              @tmpstr   nvarchar(4000),
              @leftover nvarchar(4000),
              @tmpval   nvarchar(4000)
              
      SET @textpos = 1
      SET @leftover = ''
      
      WHILE @textpos <= datalength(@list) / 2
      BEGIN
         SET @chunklen = 4000 - datalength(@leftover) / 2
         SET @tmpstr = @leftover + substring(@list, @textpos, @chunklen)
        
         SET @textpos = @textpos + @chunklen

         SET @pos = charindex(@delimiter, @tmpstr)

         WHILE @pos > 0
         BEGIN
            SET @tmpval = ltrim(rtrim(left(@tmpstr, @pos - 1)))
            INSERT @tbl (value) VALUES(@tmpval)
            SET @tmpstr = substring(@tmpstr, @pos + 1, len(@tmpstr))
            SET @pos = charindex(@delimiter, @tmpstr)
         END

         SET @leftover = @tmpstr
      END

      INSERT @tbl(value) VALUES (ltrim(rtrim(@leftover)))
   RETURN
   END

GO

/****** Object:  User Defined Function OW.fnUsersLoginToTable    Script Date: 28-07-2004 18:18:06 ******/
GO

CREATE FUNCTION OW.fnUsersLoginToTable(@list text)
      RETURNS @tbl TABLE (listpos int NOT NULL, value  varchar(4000)  NOT NULL) 
      AS
   BEGIN

	declare @id int
	declare @value varchar(4000)

	declare userLogin_cursor cursor 
	for select  *  from OW.fnListToTable(@list, ',')

	open userLogin_cursor
	fetch next from userLogin_cursor into @id, @value

	while @@fetch_status = 0
	begin
		insert @tbl select userID, userLogin from OW.tblUser where OW.tblUser.userLogin like @value
		fetch next from userLogin_cursor into @id, @value
	end	

	close userLogin_cursor
	deallocate userLogin_cursor

      RETURN
   END

GO



/****** Object:  Stored Procedure OW.sp_deleteTemp    Script Date: 12/4/2003 15:36:45 ******/

CREATE PROCEDURE OW.sp_deleteTemp
AS
Delete from tblDistribTemp Where datediff(day,distribDate,getdate()) > 3 





GO






/****** Object:  Stored Procedure OW.usp_AddDistribution    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddDistribution
    (
        @RegID numeric = Null,
        @UserID numeric,
        @DistribDate datetime = Null,
        @DistribObs nvarchar(250) = Null,
        @Tipo numeric = Null,
        @RadioVia varchar(2) = Null,
        @ChkFile bit = Null,
        @DistribTypeID numeric = Null,
        @State tinyint = Null
    )
AS
    SET NOCOUNT ON
    SET DATEFORMAT dmy

    IF @DistribDate IS NULL
        SET @DistribDate = GETDATE()

    INSERT INTO OW.tblRegistryDistribution ([RegID], [UserID], [DistribDate], [DistribObs], [Tipo], [RadioVia], [ChkFile], [DistribTypeID], [txtEntidadeID], [State], [ConnectID], [Dispatch])
    VALUES (@RegID, @UserID, @DistribDate, @DistribObs, @Tipo, @RadioVia, @ChkFile, @DistribTypeID, NULL, @State, NULL, NULL)
    IF @@ERROR = 0
        SELECT @@IDENTITY AS DistribID
    ELSE
        SELECT 0 AS DistribID





GO



/****** Object:  Stored Procedure OW.usp_AddEntityToDistribution    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddEntityToDistribution    Script Date: 12/4/2003 15:36:45 ******/
CREATE PROCEDURE OW.usp_AddEntityToDistribution
    (
        @DistribID numeric,
        @RegID numeric,
        @EntID numeric
    )
AS

	PRINT 'OW.usp_AddEntityToDistribution'
	PRINT         @DistribID
	PRINT         @RegID 
	PRINT         @EntID 
	

    SET NOCOUNT ON
    INSERT INTO OW.tblDistributionEntities ([DistribID], [RegID], [EntID], [Tmp])
    VALUES (@DistribID, @RegID, @EntID, 0)
    IF @@ERROR = 0
        SELECT 1 AS DistribEntID
    ELSE
        SELECT 0 AS DistribEntID





GO



/****** Object:  Stored Procedure OW.usp_AddEntityToRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddEntityToRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddEntityToRegistry
    (
        @RegID numeric,
        @EntID numeric,
        @Type char(1) = '0'
    )
AS

    /*	OLD VERSION 
    *
    *	SET NOCOUNT ON
    *
    * INSERT INTO OW.tblRegistryEntities ([RegID], [EntID], [Type])
    * VALUES (@RegID, @EntID, @Type) */

  SET NOCOUNT ON
INSERT INTO OW.tblRegistryEntities ([RegID], [Type], [EntID])
Select @RegID, @Type, EntID from 
	(
	SELECT ObjectID as EntID FROM OW.tblGroupsEntities where EntID = @ENTID
		UNION
	SELECT EntID FROM OW.tblEntities where EntID = @ENTID and TYPE<>2 -- /*type<>2 because type 2 is Groups*/
	) as tEntID 
		/* WHERE EXISTS (SELECT ENTiD FROM OW.tblRegistryEntities WHERE NOT EXISTS
		(	SELECT ObjectID as EntID FROM OW.tblGroupsEntities where EntID = @ENTID
				UNION
			SELECT EntID FROM OW.tblEntities where EntID = @ENTID and TYPE=@Type
		) AND REGID = @REGID) */

/*    IF @@ERROR = 0 */
        SELECT @@IDENTITY AS RegEntID
/*    ELSE 
        SELECT 0 AS RegEntID */


GO


/****** Object:  Stored Procedure OW.usp_AddFieldToRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO

CREATE PROCEDURE OW.usp_AddFieldToRegistry
    (
        @RegID numeric,
        @BookID numeric,
        @FormFieldKey numeric,
        @DynFldTypeID numeric,
        @Value varchar(4000) 
    )
AS

    SET NOCOUNT ON
    SET DATEFORMAT dmy

    IF @DynFldTypeID = 1 AND LEN(@Value) > 500
        BEGIN
            INSERT INTO OW.tblTexts ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, @Value)
        END
    IF @DynFldTypeID = 1 AND LEN(@Value) <= 500
        BEGIN
            INSERT INTO OW.tblStrings ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(varchar(500), @Value))
        END
    IF @DynFldTypeID = 2
        BEGIN
            INSERT INTO OW.tblIntegers ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(decimal(38,0), @Value))
        END
    IF @DynFldTypeID = 3
        BEGIN
            INSERT INTO OW.tblFloats ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(float, @Value))
        END
    IF @DynFldTypeID = 4
        BEGIN
            INSERT INTO OW.tblDates ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(smalldatetime, @Value))
        END
    IF @DynFldTypeID = 5
        BEGIN
            INSERT INTO OW.tblDateTimes ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(smalldatetime, @Value))
        END
        
    IF @DynFldTypeID = 7
        BEGIN
            INSERT INTO OW.tblRegistryLists ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(numeric(18,0), @Value))
        END
        
        
    IF @@ERROR = 0
        SELECT 1 AS RegFieldID
    ELSE
        SELECT 0 AS RegFieldID
GO



/****** Object:  Stored Procedure OW.usp_AddKeywordToRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddKeywordToRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddKeywordToRegistry
    (
        @RegID numeric,
        @KeyID numeric
    )
AS

    SET NOCOUNT ON
    INSERT INTO OW.tblRegistryKeywords ([RegID], [KeyID])
    VALUES (@RegID, @KeyID)
    IF @@ERROR = 0
        SELECT 1 AS RegKeyID
    ELSE
        SELECT 0 AS RegKeyID





GO


/****** Object:  Stored Procedure OW.usp_AddListOptionsValues    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_AddListOptionsValues
(
		@Description varchar(100) = NULL
)

AS
	Insert InTo OW.tblListOptionsValues values (@Description)
	
	
	RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_AddRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE  PROCEDURE OW.usp_AddRegistry
    (
        @DocTypeID numeric = Null,
        @BookID numeric,
        @Year numeric = Null,
        @Number numeric = Null,
        @Date varchar(15) = Null,
        @OriginRef varchar(30) = Null,
        @OriginDate varchar(15) = Null,
        @Subject nvarchar(250) = Null,
        @Observations nvarchar(250) = Null,
        @ProcessNumber nvarchar(50) = Null,
        @Cota nvarchar(50) = Null,
        @Bloco nvarchar(50) = Null,
        @ClassificationID numeric = Null,
        @UserID numeric = Null,
        @AntecedenteID numeric = Null,
        @EntityID numeric = Null,
        @UserModifyID numeric = Null,
        @DateModify varchar(15) = Null,
        @Historic bit = 0,
        @Field1 float = Null,
        @Field2 nvarchar(50) = Null	
    )
AS
    SET NOCOUNT ON
    SET DATEFORMAT dmy

    DECLARE @automatic bit
    DECLARE @NextNumber numeric

    IF @Date IS NULL
        SET @Date = CAST(DAY(GETDATE()) AS VARCHAR(2)) + '-' + CAST(MONTH(GETDATE()) AS VARCHAR(2)) + '-' + CAST(YEAR(GETDATE()) AS VARCHAR(4))

    IF @Year = 0 OR @Year IS NULL
        SET @Year = YEAR(GETDATE())

    SELECT @automatic = automatic FROM OW.tblBooks
    WHERE BookID = @BookID
    IF @automatic = 1 OR @Number = 0 OR @Number IS NULL
        SELECT @NextNumber = MAX(NextNumber) + 1 FROM
        (SELECT MAX(number) AS NextNumber FROM OW.tblRegistry
         WHERE [BookID] = @BookID AND [Year] = @Year
         UNION
         SELECT MAX(number) AS NextNumber FROM OW.tblRegistryHist
         WHERE [BookID] = @BookID AND [Year] = @Year
        ) AS TblMaxNumber
    ELSE
        SELECT @NextNumber = @Number

    IF @NextNumber IS NULL SET @NextNumber = 1

    INSERT INTO OW.tblRegistry ([DocTypeID], [BookID], [Year], [Number], [Date], [OriginRef], [OriginDate], [Subject], [Observations], [ProcessNumber], [Cota], [Bloco], [ClassID], [UserID], [AntecedenteID], [EntID], [UserModifyID], [DateModify], [Historic], [Field1], [Field2])
    VALUES (@DocTypeID, @BookID, @Year, @NextNumber, @Date, @OriginRef, @OriginDate, @Subject, @Observations, @ProcessNumber, @Cota, @Bloco, @ClassificationID, @UserID, @AntecedenteID, @EntityID, @UserModifyID, @DateModify, @Historic, @Field1, @Field2)
    IF @@ERROR = 0
        SELECT @@IDENTITY AS RegID
    ELSE
        SELECT 0 AS RegID



GO




/****** Object:  Stored Procedure OW.usp_CheckUserBookAccess    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_CheckUserBookAccess    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_CheckUserBookAccess
    (
        @BookID numeric,
        @UserID numeric
    )
AS

    SET NOCOUNT ON
    SELECT BookID FROM OW.tblBooks
    WHERE BookID = @BookID
    -- Verifica livros sem acessos definidos
    AND(BookID NOT IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                       WHERE ObjectTypeID = 2 AND ObjectParentID = 1)
        -- Verifica se o utilizador tem acesso
        OR BookID IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                      WHERE (UserID = @UserID
                             AND ObjectType = 1
                             AND ObjectTypeID = 2
                             AND ObjectParentID = 1
                             AND AccessType > 3)
                      -- Verifica se o grupo tem acesso
                      OR (UserID IN (SELECT DISTINCT GroupID FROM OW.tblGroupsUsers WHERE UserID = @UserID)
                          AND ObjectType = 2
                          AND ObjectTypeID = 2
                          AND ObjectParentID = 1)
                      AND (BookID NOT IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                                          WHERE ObjectTypeID = 2
                                          AND ObjectParentID = 1 
                                          AND ObjectType = 1
                                          AND userid= @UserID))
                      AND AccessType > 3))





GO


/****** Object:  Stored Procedure OW.usp_CreateClassification    Script Date: 28-07-2004 18:18:01 ******/
GO


/*
CREATE    PROCEDURE OW.usp_CreateClassification
	(
		@Level1 VARCHAR(50),
		@Level2 VARCHAR(50),
		@Level3 VARCHAR(50),
		@Level4 VARCHAR(50),
		@Level5 VARCHAR(50),
		@Level1Desig VARCHAR(100),
		@Level2Desig VARCHAR(100),
		@Level3Desig VARCHAR(100),
		@Level4Desig VARCHAR(100),
		@Level5Desig VARCHAR(100),
		@Tipo VARCHAR(50),
		@Books VARCHAR(4000)
	)
AS
	DECLARE @currLevel NUMERIC
	

	DECLARE @BookID VARCHAR(10), 
			@Pos NUMERIC,
			@ClassID NUMERIC

	BEGIN TRANSACTION
			
	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1) = 0
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Tipo)
		VALUES (@Level1, @Level1Desig, @Tipo)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
		
		--PRINT 'Tipo = ' + @Tipo
		--apagar primeiro os livros associados e colocar os novos...
		IF @Tipo = 'Private'
		BEGIN
			SET @Books = LTRIM(RTRIM(@Books))+ ','
			SET @Pos = CHARINDEX(',', @Books, 1)
			
			SELECT @ClassID = @@IDENTITY
			
			IF REPLACE(@Books, ',', '') <> ''
			BEGIN
				WHILE @Pos > 0
				BEGIN
					SET @BookID = LTRIM(RTRIM(LEFT(@Books, @Pos - 1)))
					IF @Books <> ''
					BEGIN
						--Print BookID
						INSERT INTO OW.tblClassificationBooks (ClassID, BookID)
						VALUES (@ClassID, CAST(@BookID as NUMERIC))

						IF @@ERROR <> 0
						BEGIN
							ROLLBACK TRANSACTION
							RETURN @@ERROR
						END

					END
					SET @Books = RIGHT(@Books, LEN(@Books) - @Pos)
					SET @Pos = CHARINDEX(',', @Books, 1)
				END
			END	
		END
	END

	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2) = 0 AND @Level2 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END

	END
		
	
	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2 AND Level3 = @Level3) = 0 AND @Level3 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig, Level3, Level3Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig, @Level3, @Level3Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2 AND Level3 = @Level3 AND Level4 = @Level4) = 0 AND @Level4 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig, Level3, Level3Desig, Level4, Level4Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig, @Level3, @Level3Desig, @Level4, @Level4Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END

	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2 AND Level3 = @Level3 AND Level4 = @Level4 AND Level5 = @Level5) = 0 AND @Level5 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig, Level3, Level3Desig, Level4, Level4Desig, Level5, Level5Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig, @Level3, @Level3Desig, @Level4, @Level4Desig, @Level5, @Level5Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END 

	COMMIT TRANSACTION
		
	RETURN @@ERROR




*/
GO





/****** Object:  Stored Procedure OW.usp_DelListOptionsValues    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_DelListOptionsValues 
	(
		@ID numeric
	)
AS
	
	DELETE FROM tblListOptionsValues WHERE ListID = @ID
	
	RETURN @@ERROR	



GO



/****** Object:  Stored Procedure OW.usp_DeleteAutomaticDistribution    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteAutomaticDistribution    Script Date: 12/4/2003 15:36:45 ******/
CREATE PROCEDURE OW.usp_DeleteAutomaticDistribution
	(
		@tmpID numeric
	)
AS
SET XACT_ABORT ON

BEGIN TRANSACTION
	DELETE FROM OW.tblDistributionAutomaticEntities WHERE AutoDistribID = @tmpID
	DELETE FROM OW.tblDistributionAutomatic WHERE AutoDistribID = @tmpID
COMMIT TRANSACTION

RETURN @@ERROR




GO
/*********************** OW.usp_GetDistributionAutomaticEntities ******************************/
GO
CREATE PROCEDURE OW.usp_GetDistributionAutomaticEntities
	(
		@DistribID numeric
	)

AS
	
SELECT 
	b.entid, 
	RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) as name, 
	c.entid as contactid
FROM 
	OW.tblDistributionAutomatic a
	LEFT JOIN OW.tblDistributionAutomaticEntities b ON a.[AutoDistribid]=b.AutoDistribId
	LEFT JOIN OW.tblEntities c ON (b.EntID = c.EntID)
WHERE 
	a.[AutoDistribID]=@DistribID
	
	
RETURN @@ERROR
GO


/****** Object:  Stored Procedure OW.usp_DeleteBook    Script Date: 7/5/2004 15:36:46 ******/


CREATE PROCEDURE OW.usp_DeleteBook
	(
		@bookid numeric
	)
AS

	SET XACT_ABORT ON

	BEGIN TRANSACTION

	DELETE FROM tblFieldsBooksPosition WHERE BookID = @BookID

	DELETE FROM tblClassificationBooks WHERE BookID = @BookID
 
	DELETE FROM tblBooksDocumentType WHERE BookID = @BookID

	DELETE FROM tblBooksKeyword WHERE BookID =  @BookID

	DELETE FROM tblFormfieldsBooks WHERE BookID =  @BookID

	DELETE FROM tblFieldsBookConfig WHERE BookID =  @BookID

	DELETE FROM tblBooks WHERE BookID =  @BookID
	
	COMMIT TRANSACTION
	RETURN 0


GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDispatch    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDispatch    Script Date: 15/4/2004 15:36:46 ******/

/*** DELETES A DOCUMENT TYPE  FROM A BOOK***/

CREATE PROCEDURE OW.usp_DeleteBookDispatch
	(
		@bookid numeric
	)
AS
	DELETE 
	FROM
		OW.tblDispatchBook
	WHERE
		bookid=@bookid
	
	
RETURN @@ERROR	
	


GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDocumentType    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDocumentType    Script Date: 15/4/2004 15:36:46 ******/

/*** DELETES THE  DOCUMENT TYPES OF A BOOK***/

CREATE PROCEDURE OW.usp_DeleteBookDocumentType
	(
		@bookid numeric
	)
AS
	DELETE 
	FROM
		OW.tblBooksDocumentType
	WHERE
		bookid=@bookid
	
	
RETURN @@ERROR	
	


GO



/****** Object:  Stored Procedure OW.usp_DeleteBookKeyword    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteBookKeyword    Script Date: 6/4/2004 15:36:46 ******/

/*** DELETES A KEYWORD FROM A BOOK***/

CREATE PROCEDURE OW.usp_DeleteBookKeyword
	(
		@bookid numeric
	)
AS
	DELETE 
	FROM
		OW.tblBooksKeyword
	WHERE
		bookid=@bookid
	
	
RETURN @@ERROR	
	


GO



/****** Object:  Stored Procedure OW.usp_DeleteClassification    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteClassification    Script Date: 12/4/2003 15:36:45 ******/

/*
CREATE PROCEDURE OW.usp_DeleteClassification
(
	@ClassID Numeric
)
AS
	DECLARE @Level1 varchar(50),
		    @Level2 varchar(50),
		    @Level3 varchar(50),
		    @Level4 varchar(50),
		    @Level5 varchar(50)
	
	DECLARE @currLevel numeric
	
	SELECT  @Level1 = Level1, @Level2 = Level2, @Level3 = Level3, @Level4 = Level4, @Level5 = Level5
		FROM OW.tblClassification 
		WHERE ClassID = @ClassID
	
	IF @Level2 IS NULL --level1
	BEGIN
		SET @currLevel = 1
	END
	ELSE
	BEGIN
		IF @Level3 IS NULL --level2
		BEGIN
			SET @currLevel = 2
		END
		ELSE
		BEGIN
			IF @Level4 IS NULL --level3
			BEGIN
				SET @currLevel = 3
			END
			ELSE
			BEGIN
				IF @Level5 IS NULL --level4
				BEGIN
					SET @currLevel = 4
				END
				ELSE --level5
				BEGIN
					SET @currLevel = 5	
				END
			END
		END
	END

	BEGIN TRANSACTION
	
	IF @currLevel = 1
	BEGIN
		DELETE FROM OW.tblClassificationBooks 
		WHERE ClassID = @ClassID
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
		
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 2
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 3
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	
		AND Level3 = @Level3

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 4
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	
		AND Level3 = @Level3	
		AND Level4 = @Level4	

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 5
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	
		AND Level3 = @Level3	
		AND Level4 = @Level4	
		AND Level5 = @Level5

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @@ERROR = 0
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION
		
	RETURN @@ERROR




*/
GO



/****** Object:  Stored Procedure OW.usp_DeleteDispatch    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_DeleteDispatch
	(
		@dispatchID numeric
	)
AS
	DELETE FROM OW.tblDispatch WHERE dispatchID = @dispatchID

	IF (@@ERROR <> 0)
		RETURN 1
	ELSE 
	RETURN 0



GO



/****** Object:  Stored Procedure OW.usp_DeleteDispatchFromBook    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDispatchFromBook    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_DeleteDispatchFromBook
	(
		@dispatchid numeric,	
		@bookid numeric
	)

AS

DELETE

FROM
	OW.tblDispatchBook
WHERE
	OW.tblDispatchBook.dispatchid = @dispatchid
AND	
	OW.tblDispatchBook.bookid = @bookid


IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0



GO



/****** Object:  Stored Procedure OW.usp_DeleteDistributionTemp    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDistributionTemp    Script Date: 12/4/2003 15:36:45 ******/



CREATE PROCEDURE OW.usp_DeleteDistributionTemp
	(
		@tmpID numeric
	)
AS
	DELETE FROM OW.tblDistribTemp WHERE tmpID = @tmpID

	IF (@@ERROR <> 0)
		RETURN 1
	ELSE 
	RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_DeleteDistributionTempEntity    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDistributionTempEntity    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_DeleteDistributionTempEntity
	(
		@tmpid NUMERIC,
		@entid NUMERIC
	)
AS
	DELETE 
	
	FROM OW.tblDistributionEntities

	WHERE (distribID = @tmpID) AND (entID = @entid) AND (tmp=1)

	RETURN @@Error



GO



/********************************* usp_GetBookFields ************************************/
GO
CREATE  PROCEDURE OW.usp_GetBookFields
    (
        @bookID numeric
    )
AS

    SELECT ff.formfieldKey, ff.fieldname, ff.DynFldTypeID 
    FROM OW.tblFormFields ff LEFT OUTER JOIN OW.tblFieldsBookConfig fbc 
	ON(ff.formfieldKey = fbc.formfieldKey)
    WHERE ff.global=1 OR (ff.visible=0) OR fbc.bookid = @bookID

    RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_DeleteDocumentType   Script Date: 12/4/2004 15:36:46 ******/
GO
/*** DELETES A DOCUMENT TYPE ***/

CREATE PROCEDURE OW.usp_DeleteDocumentType
	(
		@doctypeID numeric	
	)

AS
		BEGIN TRANSACTION
		
		/*** DELETES THE ASSOCIATION WITH ANY BOOK ***/
		DELETE
			OW.tblBooksDocumentType
		WHERE 
			OW.tblBooksDocumentType.documenttypeid = @doctypeid
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			
		
		/*** DELETES THE KEYWORD ***/			
		DELETE 
			OW.tblDocumentType
		WHERE 
			OW.tblDocumentType.doctypeid = @doctypeid
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			

		IF @@ERROR = 0
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION
				
RETURN @@ERROR	

GO
/****** Object:  Stored Procedure OW.usp_DeleteKeyword    Script Date: 6/4/2004 15:36:46 ******/

/*** DELETES A KEYWORD ***/

CREATE PROCEDURE OW.usp_DeleteKeyword
	(
		@keyID numeric	
	)

AS
		BEGIN TRANSACTION
		
		/*** DELETES THE ASSOCIATION WITH ANY BOOK ***/
		DELETE
			OW.tblBooksKeyword
		WHERE 
			OW.tblBooksKeyword.keywordID = @keyID 
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			
		
		/*** DELETES THE KEYWORD ***/			
		DELETE 
			OW.tblKeywords
		WHERE 
			OW.tblKeywords.keyID = @keyID 
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			

		IF @@ERROR = 0
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION
				
RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_DeleteList    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteList    Script Date: 12/4/2003 15:36:46 ******/


CREATE PROCEDURE OW.usp_DeleteList
	(
		@ListID numeric
	)
AS
	DELETE OW.tblEntityList
	WHERE ListID=@ListID
	RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_DeletePostalCode    Script Date: 28-07-2004 18:18:01 ******/
GO



CREATE PROCEDURE OW.usp_DeletePostalCode
	(
		@PostalCodeID numeric
	)
AS
	SET NOCOUNT ON 
	DELETE OW.tblPostalCode 
	WHERE PostalCodeID=@PostalCodeID
	RETURN @@ERROR


GO

/****** Object:  Stored Procedure OW.usp_DeleteProfile   Script Date: 22/4/2004 15:36:46 ******/

/*** DELETES A PROFILE ***/

CREATE PROCEDURE OW.usp_DeleteProfile
	(
		@profileid numeric	
	)

AS
		/*** DELETES THE KEYWORD ***/			
		DELETE 
			OW.tblProfiles
		WHERE 
			OW.tblProfiles.profileid = @profileid
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			
				
RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_DeleteUserPersistence    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteUserPersistence    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_DeleteUserPersistence

	(
		@UserID numeric,
		@formFieldKEY numeric
	)
AS
	DELETE FROM OW.tblUserPersistence
	WHERE UserID=@UserID AND formFieldKEY=@formFieldKEY
			
	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_DeleteUserPersistenceAll    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteUserPersistenceAll    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_DeleteUserPersistenceAll

	(@UserID numeric)
AS
	DELETE FROM OW.tblUserPersistence
	WHERE UserID=@UserID
			
	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_GetAllClassification    Script Date: 28-07-2004 18:18:01 ******/
GO



/****** Object:  Stored Procedure OW.usp_GetAllClassification    Script Date: 12/4/2003 15:36:46 ******/
CREATE  PROCEDURE OW.usp_GetAllClassification
(
	@ClassCode1 varchar(50),
	@ClassCode2 varchar(50),
	@ClassCode3 varchar(50),
	@ClassCode4 varchar(50),
	@ClassCode5 varchar(50),
	@ClassDesc1 varchar(100),
	@ClassDesc2 varchar(100),
	@ClassDesc3 varchar(100),
	@ClassDesc4 varchar(100),
	@ClassDesc5 varchar(100),
	@SearchLevel numeric	
)

AS

	DECLARE @Select NVARCHAR(1500)
	DECLARE @Where NVARCHAR(1000)
	DECLARE @From NVARCHAR(500)
	DECLARE @strSQL NVARCHAR(3000)
	DECLARE @OrderBy NVARCHAR(200)

	
	SET @Select = ' SELECT ClassID, Tipo=CASE WHEN Tipo IS NULL THEN '''' ELSE Tipo END, '
	SET @Where = ' WHERE '
	SET @From = ''
	

	--first level (always exist)
	SET @Select = @Select + ' ''Level1'' = CASE WHEN Level1 IS NULL THEN ''-'' WHEN LTRIM(Level1) = '''' THEN ''-'' ELSE Level1 END, ''level1Desig'' = CASE WHEN level1Desig IS NULL THEN ''-'' WHEN LTRIM(level1Desig)='''' THEN ''-'' ELSE level1Desig END, '
	IF @ClassDesc1 = '' AND @ClassCode1 <> ''
	BEGIN
		SET @Where = @Where + ' Level1 LIKE ''' + @ClassCode1 + ''' AND '
	END
	ELSE IF @ClassDesc1 <> ''
	BEGIN
		SET @Where = @Where + ' Level1Desig LIKE ''' +  @ClassDesc1 + ''' AND '
	END
	SET @OrderBy = ' ORDER BY Level1, Level1Desig '
	
	--second level
	IF @SearchLevel >= 2
	BEGIN
		SET @Select = @Select + ' ''Level2'' = CASE WHEN Level2 IS NULL THEN ''-'' WHEN LTRIM(Level2) = '''' THEN ''-'' ELSE Level2 END, ''level2Desig'' = CASE WHEN level2Desig IS NULL THEN ''-'' WHEN LTRIM(level2Desig)='''' THEN ''-'' ELSE level2Desig END, '
		--SET @Select = @Select + ' Level2 , level2Desig, '
		IF @ClassDesc2 = '' AND @ClassCode2 <> ''
		BEGIN
			SET @Where = @Where + ' Level2 LIKE ''' + @ClassCode2 + ''' AND '
		END
		ELSE IF @ClassDesc2 <> ''
		BEGIN
			SET @Where = @Where + ' Level2Desig LIKE ''' +  @ClassDesc2 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level2, Level2Desig '
	END	
	
	--third level
	IF @SearchLevel >= 3
	BEGIN
		SET @Select = @Select + ' ''Level3'' = CASE WHEN Level3 IS NULL THEN ''-'' WHEN LTRIM(Level3) = '''' THEN ''-'' ELSE Level3 END, ''level3Desig'' = CASE WHEN level3Desig IS NULL THEN ''-'' WHEN LTRIM(level3Desig)='''' THEN ''-'' ELSE level3Desig END, '
		--SET @Select = @Select + ' Level3 , level3Desig, '
		IF @ClassDesc3 = '' AND @ClassCode3 <> ''
		BEGIN
			SET @Where = @Where + ' Level3 LIKE ''' + @ClassCode3 + ''' AND '
		END
		ELSE IF @ClassDesc3 <> ''
		BEGIN
			SET @Where = @Where + ' Level3Desig LIKE ''' +  @ClassDesc3 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level3, Level3Desig '
	END	
	
	--fourth level
	IF @SearchLevel >= 4
	BEGIN
		SET @Select = @Select + ' ''Level4'' = CASE WHEN Level4 IS NULL THEN ''-'' WHEN LTRIM(Level4) = '''' THEN ''-'' ELSE Level4 END, ''level4Desig'' = CASE WHEN level4Desig IS NULL THEN ''-'' WHEN LTRIM(level4Desig)='''' THEN ''-'' ELSE level4Desig END, '
		--SET @Select = @Select + ' Level4 , level4Desig, '
		IF @ClassDesc4 = '' AND @ClassCode4 <> ''
		BEGIN
			SET @Where = @Where + ' Level4 LIKE ''' + @ClassCode4 + ''' AND '
		END
		ELSE IF @ClassDesc4 <> ''
		BEGIN
			SET @Where = @Where + ' Level4Desig LIKE ''' + @ClassDesc4 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level4, Level4Desig '
	END	
	
	--fourth level
	IF @SearchLevel = 5
	BEGIN
		SET @Select = @Select + ' ''Level5'' = CASE WHEN Level5 IS NULL THEN ''-'' WHEN LTRIM(Level5) = '''' THEN ''-'' ELSE Level5 END, ''level5Desig'' = CASE WHEN level5Desig IS NULL THEN ''-'' WHEN LTRIM(level5Desig)='''' THEN ''-'' ELSE level5Desig END, '
		--SET @Select = @Select + ' Level5 , level5Desig, '
		IF @ClassDesc5 = '' AND @ClassCode5 <> ''
		BEGIN
			SET @Where = @Where + ' Level5 LIKE ''' + @ClassCode5 + ''' AND '
		END
		ELSE IF @ClassDesc5 <> ''
		BEGIN
			SET @Where = @Where + ' Level5Desig LIKE ''' + @ClassDesc5 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level5, Level5Desig '
	END	
	
	--retirar a virgula e o espaço e adicionar um espaço
	SET @Select = SUBSTRING(@Select, 1, LEN(@SELECT) - 1) + ' '
			
	IF @SearchLevel = 1
		SET @Where = @Where + ' Level2 IS NULL '
	ELSE IF @SearchLevel = 2
		SET @Where = @Where + ' Level3 IS NULL AND Level2 IS NOT NULL '
	ELSE IF @SearchLevel = 3
		SET @Where = @Where + ' Level4 IS NULL AND Level3 IS NOT NULL '
	ELSE IF @SearchLevel = 4
		SET @Where = @Where + ' Level5 IS NULL AND Level4 IS NOT NULL '
	ELSE IF @SearchLevel = 5
		SET @Where = @Where + ' Level5 IS NOT NULL '
	

	--SET @OrderBy = ' ORDER BY Level1, Level2, Level3, Level4, Level5 '
	-- PSilva Fetter --

	--define the from tables
	SET @From  = ' FROM OW.tblClassification '
	
	SET @strSQL = @Select + @From + @Where + @OrderBy
	
	--print @strSQL
	
	exec sp_executeSQL @strSQL
	
	Return @@ERROR


GO


/****** Object:  Stored Procedure OW.usp_GetBook    Script Date: 28-07-2004 18:18:01 ******/
GO



CREATE PROCEDURE OW.usp_GetBook
	(
		@id numeric
	)
	AS
	
	SELECT
		*
	FROM
		OW.tblBooks 
	WHERE 
		OW.tblBooks.bookid=@id
	
	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0


GO



/****** Object:  Stored Procedure OW.usp_GetBookDispatch    Script Date: 28-07-2004 18:18:01 ******/
GO





/****** Object:  Stored Procedure OW.usp_GetBookDispatch    Script Date: 19/4/2004 15:36:46 ******/

/*** GETS A KEYWORD FROM A BOOK***/

CREATE   PROCEDURE OW.usp_GetBookDispatch
	(
		@bookID  numeric
		--,@mode numeric    /* 0 - DISPATCHES IN THE BOOK INCLUDING GLOBAL ONES, 1 - DOCUMENT TYPES NOT IN THE BOOK  */
	)
AS

	SELECT     
		OW.tblDispatch.*, OW.tblDispatchBook.bookID
	FROM    
		OW.tblDispatch LEFT OUTER JOIN
		OW.tblDispatchBook ON OW.tblDispatch.dispatchid = OW.tblDispatchBook.dispatchID 
		AND OW.tblDispatchBook.bookID = @bookID 
	Where 
		Global = 0

	/*if (@mode=0)
		-- GETS DISPATCHES IN THE BOOK INCLUDING GLOBAL  DISPATCHES 
		BEGIN
			SELECT 
				OW.tblDispatch.*
			FROM
				OW.tblDispatch
			WHERE 
				EXISTS (SELECT 1 FROM  OW.tblDispatchBook tbk WHERE tbk.DispatchId = OW.tblDispatch.DispatchID AND	tbk.bookID = @bookID ) 
				OR global=1
		END

	if (@mode=1)
		-- GETS DISPATCHES NOT IN THE BOOK. DOES NOT INCLUDE GLOBAL  DISPATCHES 
		BEGIN
			SELECT 
				OW.tblDispatch.*
			FROM
				OW.tblDispatch
			WHERE 
				NOT EXISTS (SELECT 1 FROM  OW.tblDispatchBook tbk WHERE tbk.DispatchId = OW.tblDispatch.DispatchID AND	tbk.bookID = @bookID ) 
			AND global=0
		END*/

Return @@ERROR
GO
/****** Object:  Stored Procedure OW.usp_GetDocumentTypes    Script Date: 6/4/2004 15:36:46 ******/
CREATE PROCEDURE OW.usp_GetBookDocumentTypes
	(
		@bookID numeric,
		@Global bit = null
	)
AS
IF (@Global is null)
-- ALL DOCUMENTE TYPES
BEGIN
	SELECT  doctypeID, 
		abreviation, 
		designation, 
		[Global]
	FROM  OW.tblDocumentType
	WHERE [Global]=1 OR
	EXISTS (SELECT 1 
		FROM OW.tblBooksDocumentType  tbd
		WHERE tbd.documenttypeID= OW.tblDocumentType.doctypeID AND bookid=@bookID) 
	ORDER BY OW.tblDocumentType.designation
END
ELSE
BEGIN
-- BY PARAM GLOBAL
	SELECT  OW.tblDocumentType.doctypeID, 
		OW.tblDocumentType.abreviation, 
		OW.tblDocumentType.designation, 
        	OW.tblDocumentType.[Global], 
		OW.tblBooksDocumentType.bookID
	FROM    OW.tblDocumentType LEFT OUTER JOIN
        	OW.tblBooksDocumentType ON OW.tblDocumentType.doctypeID = OW.tblBooksDocumentType.documenttypeID AND 
	        OW.tblBooksDocumentType.bookID = @bookID
	WHERE OW.tblDocumentType.[Global] = @Global
	ORDER BY OW.tblDocumentType.designation
END
Return @@ERROR
GO	





GO



/****** Object:  Stored Procedure OW.usp_GetBookFieldName    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_GetBookFieldName    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_GetBookFieldName
(
    @formFieldKEY as numeric(18,0)
)
AS
    SELECT fieldName FROM OW.tblFormFields 
    WHERE formFieldKEY = @formFieldKEY

    RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetBookHierarchicalById    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_GetBookHierarchicalById

	@bookID numeric

AS

select hierarchical from OW.tblBooks where bookID = @bookID


GO


/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 22/2/2006 15:36:46 ******/
GO
--  GETS A KEYWORD 
-- Já existia !!! andre
/* 
CREATE PROCEDURE OW.usp_GetKeywords
	(
		@keyID numeric=null,
		@designation varchar(50)=null,
		@global bit=null
	)
AS

DECLARE @sSQL varchar(8000)
DECLARE @sSQLWhere varchar(8000)
DECLARE @sSQLOrderBY varchar(4000)

SET @sSQLWhere=''

SET @sSQL='SELECT keyID,keyDescription,[Global] FROM OW.tblKeywords'

IF (@keyID is not null) SET  @sSQLWhere = ' keyID=' + CAST(@keyID as VARCHAR)+ ' AND '
IF (@designation is not null) SET @sSQLWhere=@sSQLWhere + ' keyDescription like ''' + @designation + ''' AND '
IF (@global is not null) SET  @sSQLWhere=@sSQLWhere + ' [Global]=' + CAST(@global as VARCHAR) + ' AND '
print @sSQLWhere
-- Remove last AND
IF LEN(@sSQLWhere)>0
BEGIN
SET @sSQLWhere = LEFT(@sSQLWhere,LEN(@sSQLWhere)-3)
SET @sSQLWhere = ' WHERE ' +  @sSQLWhere 
END


SET  @sSQLOrderBY= ' ORDER BY keyDescription'

EXEC (@sSQL + @sSQLWhere + @sSQLOrderBY)
Return @@ERROR
*/
GO


/****** Object:  Stored Procedure OW.usp_GetBookKeywords    Script Date: 22/2/2006 15:36:46 ******/
CREATE   PROCEDURE OW.usp_GetBookKeywords
	(
		@bookID numeric,
		@Global bit=null,
		@KeyDescription NVARCHAR(50)=null
	)
AS

DECLARE @SELECT AS NVARCHAR(4000)

IF (@Global is null)
BEGIN
	SET @SELECT = 'SELECT keyID, keyDescription, [Global] 
			FROM OW.tblKeywords WHERE ([Global]=1 OR 
			EXISTS (SELECT 1 FROM OW.tblBooksKeyword tbk 
			WHERE tbk.keywordID = OW.tblKeywords.keyID AND bookid=' + CAST(@bookID AS VARCHAR(10))+ '))'
	IF @KeyDescription IS NOT NULL SET @SELECT = @SELECT + ' AND KeyDescription Like ''' + @KeyDescription + ''''
	SET @SELECT = @SELECT + ' ORDER BY keyDescription'
	print @select
END
ELSE
BEGIN
	SET @SELECT = 'SELECT
		OW.tblBooksKeyword.bookID, 
		OW.tblKeywords.keyID, 
		OW.tblKeywords.keyDescription, 
		OW.tblKeywords.[Global]
		FROM    
		OW.tblKeywords LEFT OUTER JOIN
			OW.tblBooksKeyword ON OW.tblKeywords.keyID = OW.tblBooksKeyword.keywordID 
		AND OW.tblBooksKeyword.bookID = ' + CAST(@bookID AS VARCHAR(10)) + ' WHERE (OW.tblKeywords.[Global] = ' + CAST(@global AS CHAR(1))+ ')'
	IF @KeyDescription IS NOT NULL SET @SELECT = @SELECT + ' AND KeyDescription Like ''' + @KeyDescription +''''
	SET @SELECT = @SELECT + ' ORDER BY keyDescription'
END

exec sp_executesql @SELECT
	
Return @@ERROR
GO

/****** Object:  Stored Procedure OW.usp_GetBooks    Script Date: 12/4/2003 15:36:46 ******/

CREATE PROCEDURE OW.usp_GetBooks
( @login VARCHAR(900) = null,
  @role  NUMERIC = null,
  @abreviation VARCHAR(20) = null,
  @designation VARCHAR(100) = null
)
AS

DECLARE @USERID NUMERIC
SET @USERID = (SELECT userID FROM OW.tblUser WHERE userLogin=@login)

IF (@abreviation is not null AND @designation is not null) /*** GETS INFO NO A GIVEN BOOK ***/
	SELECT
		*
	FROM
		OW.tblBooks
	WHERE
		@abreviation = abreviation AND  @designation=designation
	ORDER BY abreviation,designation
	
ELSE
	IF (@login is null or @role is null)
	BEGIN
		SELECT	*
		FROM OW.tblBooks 
		ORDER BY abreviation,designation
	END
	ELSE 
	BEGIN
		if @role < 4 begin
		
			SELECT	*
					FROM OW.tblBooks
					WHERE
			 (BookID IN (SELECT DISTINCT ObjectID 
						    FROM  OW.tblAccess 
						    WHERE (userID = cast (@USERID as varchar) 
						    AND ObjectType=1 AND ObjectTypeID=2 
						    AND ObjectParentID=1 AND AccessType >= cast(@role as varchar)) 
						    OR (UserID IN (SELECT DISTINCT GroupID FROM  OW.tblGroupsUsers 
						 				  WHERE UserID = cast(@USERID as varchar) ) 
										  AND ObjectType=2 AND ObjectTypeID=2 AND ObjectParentID=1) 
									      AND (BookID NOT IN (SELECT DISTINCT ObjectID 
										  				      FROM  OW.tblAccess 
															  WHERE ObjectTypeID=2 AND ObjectParentID=1 
															  AND ObjectType=1 
															 AND userid= cast (@USERID as varchar) )) 
															  AND AccessType >=cast(@role as varchar) ))
			OR BookID NOT IN (SELECT DISTINCT ObjectID 
											FROM  OW.tblAccess 
											WHERE ObjectTypeID=2 
											AND ObjectParentID=1)
			ORDER BY abreviation,designation
		
		end else begin
		
			SELECT	*
					FROM OW.tblBooks
					WHERE
			 (BookID IN (SELECT DISTINCT ObjectID 
						    FROM  OW.tblAccess 
						    WHERE (userID = cast (@USERID as varchar) 
						    AND ObjectType=1 AND ObjectTypeID=2 
						    AND ObjectParentID=1 AND AccessType >= cast(@role as varchar)) 
						    OR (UserID IN (SELECT DISTINCT GroupID FROM  OW.tblGroupsUsers 
						 				  WHERE UserID = cast(@USERID as varchar) ) 
										  AND ObjectType=2 AND ObjectTypeID=2 AND ObjectParentID=1) 
									      AND (BookID NOT IN (SELECT DISTINCT ObjectID 
										  				      FROM  OW.tblAccess 
															  WHERE ObjectTypeID=2 AND ObjectParentID=1 
															  AND ObjectType=1 
															 AND userid= cast (@USERID as varchar) )) 
															  AND AccessType >=cast(@role as varchar) ))
			ORDER BY abreviation,designation
		
		end
	END

Return @@ERROR
GO


/****** Object:  Stored Procedure OW.usp_GetBooksClassifications    Script Date: 12/4/2003 15:36:46 ******/
GO

CREATE PROCEDURE OW.usp_GetBooksClassifications
	(
		@ClassID NUMERIC
	)
AS
	SELECT * , 1 'Exists'
FROM OW.tblBooks
WHERE BOOKID IN 
	(SELECT BOOKID
	FROM OW.tblClassificationBooks 
	WHERE ClassID = @ClassID)
UNION
SELECT * , 0
FROM OW.tblBooks
WHERE BOOKID NOT IN 
	(SELECT BOOKID
	FROM OW.tblClassificationBooks 
	WHERE ClassID = @ClassID)

	RETURN @@Error





GO



/****** Object:  Stored Procedure OW.usp_GetChildClassifications    Script Date: 28-07-2004 18:18:02 ******/
GO




/****** Object:  Stored Procedure OW.usp_GetChildClassifications    Script Date: 12/4/2003 15:36:46 ******/


/*
CREATE PROCEDURE OW.usp_GetChildClassifications
	(
		@ClassID numeric
	)

AS
	DECLARE @Level1 varchar(50)
	DECLARE @Level2 varchar(50)
	DECLARE @Level3 varchar(50)
	DECLARE @Level4 varchar(50)
	DECLARE @Level5 varchar(50)
	DECLARE @CurrentLevel numeric
	
	SELECT @Level1 = Level1,
	@Level2 = Level2,
	@Level3 = Level3,
	@Level4 = Level4,
	@Level5 = Level5
	FROM OW.tblClassification
	WHERE ClassID = @ClassID
	ORDER BY Level1, Level2, Level3, Level4, Level5

	IF (@Level2 IS NULL)
	BEGIN
		SET @CurrentLevel = 1
	END
	ELSE
	BEGIN
		IF (@Level3 IS NULL)
		BEGIN
			SET @CurrentLevel = 2
		END
		ELSE
		BEGIN
			IF (@Level4 IS NULL)
			BEGIN
				SET @CurrentLevel = 3
			END
			ELSE
			BEGIN
				IF (@Level5 IS NULL)
				BEGIN
					SET @CurrentLevel = 4
				END
				ELSE
				BEGIN
					SET @CurrentLevel = 5
				END
			END
		END
	END
	
	IF (@CurrentLevel = 1)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 IS NOT NULL
		AND Level3 IS NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
		
	END
	IF (@CurrentLevel = 2)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 = @Level2 
		AND Level3 IS NOT NULL
		AND Level4 IS NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
	END
	IF (@CurrentLevel = 3)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 = @Level2 
		AND Level3 = @Level3 
		AND Level4 IS NOT NULL
		AND Level5 IS NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
	END
	IF (@CurrentLevel = 4)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 = @Level2 
		AND Level3 = @Level3 
		AND Level4 = @Level4 
		AND Level5 IS NOT NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
	END
	IF (@CurrentLevel = 5)
	BEGIN
		SELECT * FROM OW.tblClassification Where ClassID = -1 ORDER BY Level1, Level2, Level3, Level4, Level5
	END

	--print cast(@CurrentLevel as varchar)
	RETURN @@ERROR




*/
GO




/****** Object:  Stored Procedure OW.usp_GetClassification    Script Date: 12/4/2003 15:36:46 ******/
GO
/*
CREATE    PROCEDURE OW.usp_GetClassification
 
 (
  @ClassCode1 varchar(50),
  @ClassCode2 varchar(50),
  @ClassCode3 varchar(50),
  @ClassCode4 varchar(50),
  @ClassCode5 varchar(50),
  @ClassDesc1 varchar(100),
  @ClassDesc2 varchar(100),
  @ClassDesc3 varchar(100),
  @ClassDesc4 varchar(100),
  @ClassDesc5 varchar(100),
  @BookID numeric,
  @SearchLevel numeric 
 )
 
AS
 
 DECLARE @Select NVARCHAR(1500)
 DECLARE @Where NVARCHAR(1000)
 DECLARE @From NVARCHAR(500)
 DECLARE @strSQL NVARCHAR(3000)
 DECLARE @OrderBy NVARCHAR(200)
 
 SET @Select = ' SELECT ClassID, Tipo=CASE WHEN Tipo IS NULL THEN '''' ELSE Tipo END, '
 SET @Where = ' WHERE '
 SET @From = ''
 
 
 --first level (always exist)
 SET @Select = @Select + ' ''Level1'' = CASE WHEN Level1 IS NULL THEN ''-'' WHEN LTRIM(Level1) = '''' THEN ''-'' ELSE Level1 END, ''level1Desig'' = CASE WHEN level1Desig IS NULL THEN ''-'' WHEN LTRIM(level1Desig)='''' THEN ''-'' ELSE level1Desig END,'
 
 IF @ClassCode1 <> ''
 BEGIN
  SET @Where = @Where + ' Level1 LIKE ''' + @ClassCode1 + ''' AND '
 END
 
 IF @ClassDesc1 <> ''
 BEGIN
  SET @Where = @Where + ' Level1Desig LIKE ''' +  @ClassDesc1 + ''' AND '
 END
 
 SET @OrderBy = ' ORDER BY Level1, Level1Desig '
 
 --second level
 IF @SearchLevel >= 2
 BEGIN
  SET @Select = @Select + ' ''Level2'' = CASE WHEN Level2 IS NULL THEN ''-'' WHEN LTRIM(Level2) = '''' THEN ''-'' ELSE Level2 END, ''level2Desig'' = CASE WHEN level2Desig IS NULL THEN ''-'' WHEN LTRIM(level2Desig)='''' THEN ''-'' ELSE level2Desig END, '
  --SET @Select = @Select + ' Level2 , level2Desig, '
  IF  @ClassCode2 <> ''
  BEGIN
   SET @Where = @Where + ' Level2 LIKE ''' + @ClassCode2 + ''' AND '
  END
  IF @ClassDesc2 <> ''
  BEGIN
   SET @Where = @Where + ' Level2Desig LIKE ''' +  @ClassDesc2 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level2, Level2Desig '
 END 
 
 --third level
 IF @SearchLevel >= 3
 BEGIN
  SET @Select = @Select + ' ''Level3'' = CASE WHEN Level3 IS NULL THEN ''-'' WHEN LTRIM(Level3) = '''' THEN ''-'' ELSE Level3 END, ''level3Desig'' = CASE WHEN level3Desig IS NULL THEN ''-'' WHEN LTRIM(level3Desig)='''' THEN ''-'' ELSE level3Desig END, '
  --SET @Select = @Select + ' Level3 , level3Desig, '
  IF @ClassCode3 <> ''
  BEGIN
   SET @Where = @Where + ' Level3 LIKE ''' + @ClassCode3 + ''' AND '
  END
  IF @ClassDesc3 <> ''
  BEGIN
   SET @Where = @Where + ' Level3Desig LIKE ''' +  @ClassDesc3 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level3, Level3Desig '
 END 
 
 --fourth level
 IF @SearchLevel >= 4
 BEGIN
  SET @Select = @Select + ' ''Level4'' = CASE WHEN Level4 IS NULL THEN ''-'' WHEN LTRIM(Level4) = '''' THEN ''-'' ELSE Level4 END, ''level4Desig'' = CASE WHEN level4Desig IS NULL THEN ''-'' WHEN LTRIM(level4Desig)='''' THEN ''-'' ELSE level4Desig END, '
  --SET @Select = @Select + ' Level4 , level4Desig, '
  IF @ClassCode4 <> ''
  BEGIN
   SET @Where = @Where + ' Level4 LIKE ''' + @ClassCode4 + ''' AND '
  END
  IF @ClassDesc4 <> ''
  BEGIN
   SET @Where = @Where + ' Level4Desig LIKE ''' + @ClassDesc4 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level4, Level4Desig '
 END 
 
 --fourth level
 IF @SearchLevel = 5
 BEGIN
  SET @Select = @Select + ' ''Level5'' = CASE WHEN Level5 IS NULL THEN ''-'' WHEN LTRIM(Level5) = '''' THEN ''-'' ELSE Level5 END, ''level5Desig'' = CASE WHEN level5Desig IS NULL THEN ''-'' WHEN LTRIM(level5Desig)='''' THEN ''-'' ELSE level5Desig END, '
  --SET @Select = @Select + ' Level5 , level5Desig, '
  IF @ClassCode5 <> ''
  BEGIN
   SET @Where = @Where + ' Level5 LIKE ''' + @ClassCode5 + ''' AND '
  END
  IF @ClassDesc5 <> ''
  BEGIN
   SET @Where = @Where + ' Level5Desig LIKE ''' + @ClassDesc5 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level5, Level5Desig '
 END 
 
 --retirar a virgula e o espaço e adicionar um espaço
 SET @Select = SUBSTRING(@Select, 1, LEN(@SELECT) - 1) + ' '
   
 IF @SearchLevel = 1
  SET @Where = @Where + ' Level2 IS NULL '
 ELSE IF @SearchLevel = 2
  SET @Where = @Where + ' Level3 IS NULL AND Level2 IS NOT NULL '
 ELSE IF @SearchLevel = 3
  SET @Where = @Where + ' Level4 IS NULL AND Level3 IS NOT NULL '
 ELSE IF @SearchLevel = 4
  SET @Where = @Where + ' Level5 IS NULL AND Level4 IS NOT NULL '
 ELSE IF @SearchLevel = 5
  SET @Where = @Where + ' Level5 IS NOT NULL '
 
 --only select global classifications and classifications of that book
 IF @BookID > 0
 BEGIN
  --SET @Where = @Where + ' AND (ClassID IN (SELECT ClassID FROM OW.tblClassificationBooks WHERE BookID=' + Convert(nvarchar,@BookID) + ') OR Tipo like ''Global'' OR Tipo IS NULL) '
 
  -- Acessos
  SET @Where = @Where + ' AND  (level1 IN (   '
  SET @Where = @Where + ' SELECT level1 '
  SET @Where = @Where + ' FROM OW.tblClassification '
  SET @Where = @Where + ' WHERE ClassID IN (SELECT ClassID '
  SET @Where = @Where + ' FROM OW.tblClassificationBooks '
  SET @Where = @Where + '  WHERE BookID=' + Convert(nvarchar,@BookID)   + ')'       
  SET @Where = @Where + ' OR tipo=''Global'' ))'
 END
 
 ELSE
  SET @OrderBy = ' ORDER BY Level1, Level2, Level3, Level4, Level5 '
 
 --define the from tables
 SET @From  = ' FROM OW.tblClassification '
 
 SET @strSQL = @Select + @From + @Where + @OrderBy
 
 print @strSQL
 print @OrderBy
 exec sp_executeSQL @strSQL
 
 Return @@ERROR







*/
GO



/****** Object:  Stored Procedure OW.usp_GetClassificationAdmin    Script Date: 12/4/2003 15:36:46 ******/
GO

/*
CREATE PROCEDURE OW.usp_GetClassificationAdmin

AS
	SELECT ClassID, Level1, Level2, Level3, Level4, Level5,
		'Designation' =
		CASE 
			WHEN Level5 IS NOT NULL THEN Level5Desig
			WHEN Level4 IS NOT NULL THEN Level4Desig
			WHEN Level3 IS NOT NULL THEN Level3Desig
			WHEN Level2 IS NOT NULL THEN Level2Desig
			ELSE Level1Desig
		END,
		Tipo
		FROM OW.tblClassification
		ORDER BY Level1, Level2, Level3, Level4, Level5
			
	RETURN @@Error




*/
GO


/****** Object:  Stored Procedure OW.usp_GetClassificationByCode    Script Date: 12/4/2003 15:36:46 ******/
GO
/*
CREATE PROCEDURE OW.usp_GetClassificationByCode

	(
		@ActLevel NUMERIC, -- Actual level used for the search 
		@BookID NUMERIC, -- ID of the book where the classification should be associated
		@Level1 NVARCHAR(50), -- Level1 code
		@Level2 NVARCHAR(50), -- Level2 code
		@Level3 NVARCHAR(50), -- Level3 code
		@Level4 NVARCHAR(50), -- Level4 code
		@Level5 NVARCHAR(50), -- Level5 code
		@ClassID NUMERIC OUTPUT, -- Return classification ID
		@Description NVARCHAR(100) OUTPUT -- Return classification description
	)

AS
	DECLARE @Params NVARCHAR(200)
	DECLARE @Query NVARCHAR(1000)
	DECLARE @RetVal INT
	
	IF @BookID = 0
		IF (SELECT count(*) FROM  tblClassification 
				INNER JOIN tblClassificationBooks 
				ON tblClassificationBooks.ClassID = tblClassification.ClassID 
			WHERE Level1= @Level1 AND Level2 IS NULL  
				AND (tblClassification.Tipo LIKE 'Global' OR tblClassification.Tipo IS NULL)) = 0
	
				SET @RetVal = 1
	ELSE
	BEGIN
		IF(SELECT count(*) FROM tblClassification 
				INNER JOIN tblClassificationBooks 
				ON tblClassificationBooks.ClassID = tblClassification.ClassID 
			WHERE Level1= @Level1 AND Level2 IS NULL  
				AND tblClassificationBooks.bookID = @BookID) = 0	
		BEGIN
			SET @RetVal = 1
		END
	END

	SET @Query = ' SELECT @CID = ClassID, @Desc = Description FROM tblClassification ' 	 

	IF @ActLevel = 1 
	BEGIN
		SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 IS NULL '
	END
	ELSE
	BEGIN
		IF @ActLevel = 2 
		BEGIN
			SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 IS NULL '
		END
		ELSE
		BEGIN
			IF @ActLevel = 3 
			BEGIN
				SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 LIKE ''' + @Level3 + ''' AND Level4 IS NULL '
			END
			ELSE
			BEGIN
				IF @ActLevel = 4 
				BEGIN
					SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 LIKE ''' + @Level3 + ''' AND Level4 LIKE ''' + @Level4 + ''' AND Level5 IS NULL '
				END
				ELSE
				BEGIN
					IF @ActLevel = 5 
					BEGIN
						SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 LIKE ''' + @Level3 + ''' AND Level4 LIKE ''' + @Level4 + ''' AND Level5 LIKE ''' + @Level5 + ''' '
					END --level5 
				END --level4 (else)
			END --level3 (else)
		END -- level2 (else)
	END --level1 (else)

	SET @Params = '@CID NUMERIC OUTPUT, @Desc NVARCHAR(100) OUTPUT'

	EXEC sp_ExecuteSQL @Query,
					@Params,
					@CID = @ClassID output, 
					@Desc = @Description output;
	
	IF @RetVal <> 0
	BEGIN
		Return @RetVal
	END
	ELSE
		Return @@ERROR




*/
GO


/****** Object:  Stored Procedure OW.usp_GetClassificationByID    Script Date: 28-07-2004 18:18:02 ******/
GO
/*
CREATE PROCEDURE OW.usp_GetClassificationByID
	(
		@ClassID numeric	
	)
AS
	SELECT ClassID, Level1, Level2, Level3, Level4, Level5,
			Level1Desig, Level2Desig, Level3Desig, Level4Desig, Level5Desig, Tipo
	FROM OW.tblClassification
	WHERE ClassID = @ClassID
	
	RETURN @@ERROR
*/
GO


/****** Object:  Stored Procedure OW.usp_GetClassificationInfo    Script Date: 28-07-2004 18:18:02 ******/
GO
/*
CREATE PROCEDURE OW.usp_GetClassificationInfo
    (
        @BookID numeric
    )
AS

SELECT level1, level2, level3, level4, level5, 'Designation' =
CASE 
    WHEN Level5 IS NOT NULL THEN Level5Desig
    WHEN Level4 IS NOT NULL THEN Level4Desig
    WHEN Level3 IS NOT NULL THEN Level3Desig
    WHEN Level2 IS NOT NULL THEN Level2Desig
    ELSE Level1Desig
END
FROM OW.tblClassification
WHERE (level1 IN (SELECT level1 
				  FROM OW.tblClassification 
				  WHERE ClassID IN (SELECT ClassID 
									FROM OW.tblClassificationBooks 
									WHERE BookID=@BookID)
				  OR tipo='Global'))
ORDER BY level1, level2, level3, level4, level5




*/
GO


/****** Object:  Stored Procedure OW.usp_GetContact    Script Date: 28-07-2004 18:18:02 ******/
GO




/****** Object:  Stored Procedure OW.usp_GetContact    Script Date: 12/4/2003 15:36:46 ******/


CREATE PROCEDURE OW.usp_GetContact
	(@EntID numeric=null,
	@FirstName varchar(50)=null, 
	@MiddleName varchar(300)=null,
	@LastName varchar(50)=null, 
	@ListID numeric=null,
	@BI numeric=null, 
	@NumContribuinte numeric=null, 
	@AssociateNum numeric=null,
	@eMail varchar(300)=null,
	@JobTitle varchar(100)=null, 
	@Street  varchar(500)=null,
	@PostalCodeID numeric=null,	
	@CountryID numeric=null,
	@Phone  varchar(20)=null, 
	@Fax  varchar(20)=null, 
	@Mobile  varchar(20)=null,
	@DistrictID numeric=null,
	@Full bit=0,
	@NAME varchar(400)=null,
	@EntityID numeric=null,
	@user varchar(900),
	@Access numeric,
	@Active bit=null
	)

AS

SET CONCAT_NULL_YIELDS_NULL OFF

IF @FULL=1
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, tblEntities.ListID,
		BI, NumContribuinte, AssociateNum,eMail,JobTitle, Street,
		tblPostalCode.PostalCodeID,tblPostalCode.Code As PostalCode, 
		tblPostalCode.Description As PostalCodeDesc, 
		tblCountry.CountryID, tblCountry.Description As CountryDesc, tblEntities.Phone, tblEntities.Fax, Mobile, 
		tblDistrict.DistrictID, tblDistrict.Description As DistrictDesc,
		tblEntityList.Description As ContactListDescription, tblEntities.EntityID,Active, 
		tblUser.UserDesc As CreatedBy, tblEntities.InsertedOn,tblUserMod.UserDesc As ModifiedBy, tblEntities.LastModifiedOn
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)
		 LEFT JOIN OW.tblPostalCode tblPostalCode ON (tblEntities.PostalCodeID=tblPostalCode.PostalCodeID)
		 LEFT JOIN OW.tblCountry tblCountry ON (tblEntities.CountryID=tblCountry.CountryID)
		 LEFT JOIN OW.tblDistrict tblDistrict ON (tblEntities.DistrictID=tblDistrict.DistrictID)
		 LEFT JOIN OW.tblUser tblUser ON (tblUser.UserID=1) --(tblUser.UserID=tblEntities.CreatedBy)
		 LEFT JOIN OW.tblUser tblUserMod ON (tblUserMod.UserID=1) --(tblUserMod.UserID=tblEntities.ModifiedBy)
	WHERE (EntID = @EntID or @EntID is null)
	AND (FirstName  LIKE @FirstName OR @FirstName is null)
	AND (MiddleName LIKE @MiddleName OR @MiddleName is null)
	AND (LastName LIKE @LastName OR @LastName is null)
	AND (tblEntities.ListID = @ListID OR @ListID is null)
	AND (BI=@BI OR @BI is null)
	AND (NumContribuinte=@NumContribuinte OR @NumContribuinte is null)
	AND (AssociateNum=@AssociateNum OR @AssociateNum is null)
	AND (eMail LIKE @eMail OR @eMail is null)
	AND (JobTitle LIKE @JobTitle OR @JobTitle is null)
	AND (Street LIKE @Street OR @Street is null)
	AND (tblEntities.PostalCodeID=@PostalCodeID OR @PostalCodeID is null)
	AND (tblEntities.CountryID=@CountryID OR @CountryID is null)
	AND (tblEntities.Phone LIKE @Phone OR @Phone is null)
	AND (tblEntities.Fax LIKE @Fax OR @Fax is null)
	AND (Mobile LIKE @Mobile OR @Mobile is null)
	AND (tblEntities.DistrictID=@DistrictID OR @DistrictID is null)
	AND (tblEntities.EntityID=@EntityID OR @EntityID is null)
	AND ((RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' ')))) LIKE @NAME OR @NAME is null)
	AND (Active=@Active OR @Active is null)
	AND (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR tblEntities.ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID IN (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
			AND ObjectID >= @Access -- ROLE
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
						) 
			)
       )		
END
ELSE
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, Active,
		tblEntityList.Description As ContactListDescription
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)
	WHERE (EntID = @EntID or @EntID is null)
	AND (FirstName  LIKE @FirstName OR @FirstName is null)
	AND (MiddleName LIKE @MiddleName OR @MiddleName is null)
	AND (LastName LIKE @LastName OR @LastName is null)
	AND (tblEntities.ListID = @ListID OR @ListID is null)
	AND (BI=@BI OR @BI is null)
	AND (NumContribuinte=@NumContribuinte OR @NumContribuinte is null)
	AND (AssociateNum=@AssociateNum OR @AssociateNum is null)
	AND (eMail LIKE @eMail OR @eMail is null)
	AND (JobTitle LIKE @JobTitle OR @JobTitle is null)
	AND (Street LIKE @Street OR @Street is null)
	AND (PostalCodeID=@PostalCodeID OR @PostalCodeID is null)
	AND (CountryID=@CountryID OR @CountryID is null)
	AND (Phone LIKE @Phone OR @Phone is null)
	AND (Fax LIKE @Fax OR @Fax is null)
	AND (Mobile LIKE @Mobile OR @Mobile is null)
	AND (DistrictID=@DistrictID OR @DistrictID is null)
	AND (EntityID=@EntityID OR @EntityID is null)
	AND (RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) LIKE @NAME OR @NAME is null)
	AND (Active=@Active OR @Active is null)
    AND (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID    
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR tblEntities.ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
				OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID IN (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
			AND ObjectID >= @Access -- ROLE
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
						) 
			)
		)	
END
	RETURN @@ERROR


GO


/****** Object:  Stored Procedure OW.usp_GetContactByID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactByID
	(
		@ID text,
		@Access numeric,
		@user varchar(900),
		@ReturnEntity bit
	)
AS
	SET NOCOUNT ON
	SET CONCAT_NULL_YIELDS_NULL OFF
	
IF (@ReturnEntity=0)
BEGIN
SELECT RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) As [Name], 
		EntID,FirstName, MiddleName,LastName, tblEntities.ListID,
		BI, NumContribuinte, AssociateNum,eMail,JobTitle, Street,
		tblPostalCode.PostalCodeID,tblPostalCode.Code As PostalCode, 
		tblPostalCode.Description As PostalCodeDesc, 
		tblCountry.CountryID, tblCountry.Description As CountryDesc, tblEntities.Phone, tblEntities.Fax, Mobile, 
		tblDistrict.DistrictID, tblDistrict.Description As DistrictDesc,
		tblEntityList.Description As ContactListDescription, tblEntities.EntityID,Active, 
		tblUser.UserDesc As CreatedBy, tblEntities.InsertedOn,tblUserMod.UserDesc As ModifiedBy, tblEntities.LastModifiedOn
FROM OW.tblEntities tblEntities
INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
LEFT JOIN OW.tblPostalCode tblPostalCode ON (tblEntities.PostalCodeID=tblPostalCode.PostalCodeID)
LEFT JOIN OW.tblCountry tblCountry ON (tblEntities.CountryID=tblCountry.CountryID)
LEFT JOIN OW.tblDistrict tblDistrict ON (tblEntities.DistrictID=tblDistrict.DistrictID)
LEFT JOIN OW.tblUser tblUser ON (tblUser.UserID=1)--(tblUser.UserID=tblEntities.CreatedBy)
LEFT JOIN OW.tblUser tblUserMod ON (tblUserMod.UserID=1) --(tblUserMod.UserID=tblEntities.ModifiedBy)
WHERE  EXISTS (SELECT 1 FROM OW.fnListToTable(@ID,',') WHERE value=EntID)
AND tblEntities.Active=1 
AND  (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID
			 FROM OW.tblEntityListAccess
			 WHERE objectID IN (SELECT userID
					FROM OW.tbluser
					WHERE userLogin LIKE @user
					AND useractive=1)
			 AND ObjectType=1
			 AND AccessType >= @Access
			)
OR tblEntities.ListID IN (SELECT ObjectParentID
			  FROM OW.tblEntityListAccess
			  WHERE objectID IN (SELECT DISTINCT GroupID
					 FROM OW.tblGroupsUsers
					 WHERE  userID IN (SELECT UserID
							   FROM OW.tblUser
							   WHERE UserLogin LIKE @user
							   AND useractive=1)
					)
			 AND ObjectType=2
			 AND AccessType >= @Access)		
OR ([global]=1
 	AND EXISTS (SELECT ObjectID
		FROM OW.tblAccess
		WHERE userID IN (SELECT UserID
				FROM OW.tblUser
				WHERE UserLogin LIKE @user
				AND useractive=1)
			AND ObjectID >= @Access -- ROLE=2
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY				
		)
	)
) 	
ORDER BY tblEntities.EntID
END
ELSE
BEGIN
SELECT RTRIM(LTRIM(Replace(tblEntities.FirstName + ' ' + tblEntities.MiddleName + ' ' + tblEntities.LastName,'  ',' '))) As [Name], 
		tblEntities.EntID,tblEntities.FirstName, tblEntities.MiddleName,tblEntities.LastName, tblEntities.ListID,
		tblEntities.BI, tblEntities.NumContribuinte, tblEntities.AssociateNum,tblEntities.eMail,
		tblEntities.JobTitle, tblEntities.Street,
		tblPostalCode.PostalCodeID,tblPostalCode.Code As PostalCode, 
		tblPostalCode.Description As PostalCodeDesc, 
		tblCountry.CountryID, tblCountry.Description As CountryDesc, tblEntities.Phone, tblEntities.Fax, 
		tblEntities.Mobile, tblDistrict.DistrictID, tblDistrict.Description As DistrictDesc,
		tblEntityList.Description As ContactListDescription, tblEntities.EntityID,tblEntities.Active, 
		RTRIM(LTRIM(Replace(tEnt.FirstName + ' ' + tEnt.MiddleName + ' ' + tEnt.LastName,'  ',' '))) As [EntityName], 
		tblUser.UserDesc As CreatedBy, tblEntities.InsertedOn,tblUserMod.UserDesc As ModifiedBy, tblEntities.LastModifiedOn
FROM OW.tblEntities tblEntities
INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
LEFT JOIN OW.tblEntities as tEnt ON (tblEntities.EntityID=tEnt.EntID)	
LEFT JOIN OW.tblPostalCode tblPostalCode ON (tblEntities.PostalCodeID=tblPostalCode.PostalCodeID)
LEFT JOIN OW.tblCountry tblCountry ON (tblEntities.CountryID=tblCountry.CountryID)
LEFT JOIN OW.tblDistrict tblDistrict ON (tblEntities.DistrictID=tblDistrict.DistrictID)
LEFT JOIN OW.tblUser tblUser ON (tblUser.UserID=1) --(tblUser.UserID=tblEntities.CreatedBy)
LEFT JOIN OW.tblUser tblUserMod ON (tblUserMod.UserID=1) --(tblUserMod.UserID=tblEntities.ModifiedBy)
WHERE  EXISTS (SELECT 1 FROM OW.fnListToTable(@ID,',') WHERE value=tblEntities.EntID)
AND tblEntities.Active=1 
AND  (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID
			 FROM OW.tblEntityListAccess
			 WHERE objectID IN (SELECT userID
					FROM OW.tbluser
					WHERE userLogin LIKE @user
					AND useractive=1)
			 AND ObjectType=1
			 AND AccessType >= @Access
			)
OR tblEntities.ListID IN (SELECT ObjectParentID
			  FROM OW.tblEntityListAccess
			  WHERE objectID IN (SELECT DISTINCT GroupID
					 FROM OW.tblGroupsUsers
					 WHERE  userID IN (SELECT UserID
							   FROM OW.tblUser
							   WHERE UserLogin LIKE @user
							   AND useractive=1)
					)
			 AND ObjectType=2
			 AND AccessType >= @Access)		
OR ([global]=1
 	AND EXISTS (SELECT ObjectID
		FROM OW.tblAccess
		WHERE userID IN (SELECT UserID
				FROM OW.tblUser
				WHERE UserLogin LIKE @user
				AND useractive=1)
			AND ObjectID >= @Access -- ROLE
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY				
		)
	)
) 	
ORDER BY tblEntities.EntID
END	
	
RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_GetContactFields    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactFields
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	SELECT FieldID, Description,TypeID, [Size],[Unique], Empty,[GLobal]
	FROM OW.tblFields
	WHERE visible=1
	ORDER BY [ORDER]
	RETURN @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_GetContactListRole    Script Date: 28-07-2004 18:18:02 ******/
GO




CREATE PROCEDURE OW.usp_GetContactListRole
	(
		@user varchar(900),
		@ID numeric
	)
AS
	IF ((SELECT [global] FROM OW.tblEntityList WHERE ListID=@ID) =1) 
	BEGIN
		SELECT ObjectID As Role
		FROM OW.tblAccess 
		WHERE userID IN (SELECT DISTINCT UserID 
				FROM OW.tblUser 
				WHERE UserLogin LIKE @user
				AND useractive=1)
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
	END
	ELSE
	BEGIN
		SELECT TOP 1 AccessType As Role
		FROM OW.tblEntityListAccess
		WHERE (objectID IN (SELECT DISTINCT userID 
				   FROM OW.tbluser 
				   WHERE userLogin LIKE @user
				   AND useractive=1)
			AND ObjectType=1
			AND ObjectParentID=@ID)
		OR 
		 (objectID IN (SELECT DISTINCT GroupID 
				 FROM OW.tblGroupsUsers 
				 WHERE  userID IN (SELECT DISTINCT UserID 
						   FROM OW.tblUser 
						   WHERE UserLogin LIKE @user
						   AND useractive=1)
				)
		 AND ObjectParentID=@ID
		 AND ObjectType=2)
		ORDER BY ObjectType ASC


	END
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetContactLists    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactLists
	(
		@ListID numeric=null,
		@Global bit=null,
		@user varchar(900)=null,
		@Access numeric=null
	)
AS
IF (@user is null)
BEGIN
	IF (@ListID is null AND @Global is NULL)
	BEGIN
		SELECT ListID, Description, [global] 
		FROM OW.tblEntityList
		ORDER BY Description
	END
	ELSE 
		IF (@ListID is not null AND @Global is NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			ORDER BY Description	
		END
	ELSE 
		IF (@ListID is null AND @Global is not NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE ([global]=@Global)
			ORDER BY Description	
		END
	ELSE -- (@ListID!=null AND @Global!=NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			AND ([global]=@Global)
			ORDER BY Description	
		END
END
ELSE -- @all=0
BEGIN
IF (@ListID is null AND @Global is NULL)
	BEGIN
		SELECT ListID, Description, [global]
		FROM OW.tblEntityList
		WHERE (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
				OR ([global]=1
					AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  
		ORDER BY Description
	END
	ELSE 
		IF (@ListID is not null AND @Global is NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			AND (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  

		ORDER BY Description	
		END
	ELSE 
		IF (@ListID is null AND @Global is not NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE ([global]=@Global)
			AND (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access

						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  
		
			ORDER BY Description	
		END
	ELSE -- (@ListID!=null AND @Global!=NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			AND ([global]=@Global)
			AND (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  
		
			ORDER BY Description	
		END
END	
	RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetContactProfilesFields    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetContactProfilesFields
	(
		@profileID numeric,
		@mode numeric    /* 0 - FIELDS IN PROFILE, 1 - FIELDS NOT IN PROFILE  */
	)
AS
	if (@mode=0)
		/* GETS FIELDS IN THE PROFILE */
		BEGIN
			SELECT 
				OW.tblFields.FieldID, 
				OW.tblFields.Description,
				OW.tblProfilesFields.fieldmaxchars
			FROM
				OW.tblFields, OW.tblProfilesFields
			WHERE 
				OW.tblProfilesFields.formfieldKey = OW.tblFields.FieldID AND 
				OW.tblProfilesFields.profileid = @profileID
			ORDER BY FormFieldOrder
		END

	if (@mode=1)
		/* GETS FIELDS NOT IN THE PROFILE */
		BEGIN
			SELECT 
				OW.tblFields.FieldID, 
				OW.tblFields.Description
			FROM
				OW.tblFields
			WHERE 
				NOT EXISTS  (SELECT 1 
							 FROM  OW.tblProfilesFields tbk 
							 WHERE tbk.formfieldKey = OW.tblFields.FieldID 
							 AND tbk.profileID = @profileID) 
			ORDER BY Description
		END

Return @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_GetContactsDuplicated    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactsDuplicated
	(
		@BI numeric=null, 
		@NumContribuinte numeric=null, 
		@AssociateNum numeric=null,
		@CountryID numeric,
		@ID numeric=null
	)
AS
IF @ID is null
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, Active,		
		tblEntityList.Description As ContactListDescription
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
	WHERE ((BI=@BI AND @BI is not null) OR
		  (NumContribuinte=@NumContribuinte AND @NumContribuinte is not null) OR
		  (AssociateNum=@AssociateNum AND @AssociateNum is not null)) AND 
		  CountryID=@CountryID
END
ELSE
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, Active,		
		tblEntityList.Description As ContactListDescription
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
	WHERE ((BI=@BI AND @BI is not null) OR
		  (NumContribuinte=@NumContribuinte AND @NumContribuinte is not null) OR
		  (AssociateNum=@AssociateNum AND @AssociateNum is not null)) AND 
		  CountryID=@CountryID AND
		  EntID <> @ID

END
	return @@ERROR




GO

/****** Object:  Stored Procedure OW.usp_GetCountry    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetCountry
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	/* SET NOCOUNT ON */
	SELECT CountryID, Code, Description 
	FROM OW.tblCountry
	ORDER BY Description
	RETURN @@ERROR




GO

/****** Object:  Stored Procedure OW.usp_GetDescriptionListOptionsValues    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDescriptionListOptionsValues
	(
		@ListID numeric
	)

AS
Select Description from OW.tblListOptionsValues where ListID = @ListID
	
	/* SET NOCOUNT ON */
	RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_GetDispatch    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatch
	(
		@abreviation nvarchar(20)
	)
AS
	IF  (@abreviation = '')
		SELECT
			*
		FROM
			OW.tblDispatch
	ELSE
		SELECT
			*
		FROM
			OW.tblDispatch
		WHERE
			abreviation=@abreviation
	
	IF (@@ERROR <> 0)
		Return 1
	ELSE
		Return 0



GO


/****** Object:  Stored Procedure OW.usp_GetDispatchFromID    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDispatchFromID
	(
		@id numeric
	)
AS

SELECT
*
FROM
OW.tblDispatch
WHERE
@id=dispatchid

IF (@@ERROR <> 0)
    Return 1
ELSE
    Return 0





GO

/****** Object:  Stored Procedure OW.usp_GetDispatchFull    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatchFull
AS

SELECT
*
FROM
OW.tblDispatch

IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0





GO

/****** Object:  Stored Procedure OW.usp_GetDispatchNotInBook    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatchNotInBook
	(
	@bookid numeric
	)

AS

select 	OW.tblDispatch.*
from 	OW.tblDispatch
where	OW.tblDispatch.dispatchid NOT IN
	(select OW.tbldispatchbook.dispatchid 
	 from OW.tbldispatchbook
	 where OW.tblDispatchBook.bookid = @bookid) and OW.tblDispatch.global  = '0'
ORDER BY
	OW.tblDispatch.abreviation


IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0



GO

/****** Object:  Stored Procedure OW.usp_GetDispatchbyBook    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatchbyBook
	(
	@bookid numeric
	)

AS

(SELECT
	OW.tblDispatch.dispatchid, 
	OW.tblDispatch.abreviation,
	OW.tblDispatch.designation,
	OW.tblDispatch.[global]
FROM
	OW.tblDispatch
WHERE
	OW.tblDispatch.global ='1'

UNION 

SELECT
	OW.tblDispatch.dispatchid, 
	OW.tblDispatch.abreviation,
	OW.tblDispatch.designation,
	OW.tblDispatch.[global]
FROM
	OW.tblDispatchBook,
	OW.tblDispatch
WHERE
	OW.tblDispatchBook.dispatchid = OW.tblDispatch.dispatchid
AND	
	OW.tblDispatchBook.bookid = @bookid AND OW.tblDispatch.[global] ='0')
ORDER BY
	OW.tblDispatch.abreviation

IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0



GO



/****** Object:  Stored Procedure OW.usp_GetDistribTypeID    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistribTypeID
    (
        @DistribTypeCode nvarchar(50)  = Null,
        @DistribTypeDesc varchar(250)  = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(400)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT DistribTypeID FROM OW.tblDistributionType'

    IF LEN(@DistribTypeCode) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'GetDistribCode like ''' + @DistribTypeCode + ''''
        END

    IF LEN(@DistribTypeDesc) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'DistribTypeDesc like ''' + @DistribTypeDesc + ''''
        END

    EXEC sp_ExecuteSQL @Query





GO



/****** Object:  Stored Procedure OW.usp_GetDistribution    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistribution
	(
		@RegID numeric
	)

AS

	SET DATEFORMAT dmy;

	SELECT
		a.[ID] as distribID,
		a.regID,
		convert(varchar,a.distribdate,105) as distribdate,
		a.userid,
		c.userdesc,
		a.distribtypeID,
		b.distribtypedesc,
		a.tipo,
		a.radiovia,
		a.state,
		a.connectid,
		a.chkfile,
		a.distribObs,
		a.dispatch,
		a.addresseetype,
		a.addresseeid
	FROM
		OW.tblRegistryDistribution a 
		LEFT JOIN OW.tblDistributionType b ON  (a.DistribTypeID=b.DistribTypeID) 
		LEFT JOIN  OW.tblUser c ON (a.UserID=c.UserID)
	WHERE 
		a.RegID=@RegID 
	ORDER BY 
		a.[ID] 
	

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN 1
			
	RETURN 0





GO

/****** Object:  Stored Procedure OW.usp_GetDistributionOWFlowIntervenientsById    Script Date: 28-07-2004 18:18:02 ******/
GO


CREATE PROCEDURE OW.usp_GetDistributionOWFlowIntervenientsById

	@owflowIdsList text 

AS

select RegID from OW.tblRegistryDistribution rdis where exists
(select 1 from OW.fnListToTable(@owflowIdsList,',') 
where value = rdis.ConnectID
AND Tipo=6)

GO




/****** Object:  Stored Procedure OW.usp_GetDistributionEMailByLogin    Script Date: 28-07-2004 18:18:02 ******/
GO


CREATE PROCEDURE OW.usp_GetDistributionEMailByLogin
            @usersList text,
            @iHist int
AS

--Obtém os Id's dos utilizadores e grava-os numa tabela temporária
declare @tbl table (uid int)
insert @tbl
select listpos from OW.fnUsersLoginToTable(@usersList) 
 
--Obtém os registos, com distribuição por correio electrónico, cujos utilizadores sejam distribuidores ou destinatários
declare @tbAux table (regID numeric)
 
--Activos
if @iHist = 1 or @iHist = 3 
begin
            insert @tbAux
            select regid from OW.tblRegistry r where exists 
            (
                        select regId from OW.tblRegistryDistribution d 
                        where d.userId in (select uid from @tbl) and d.regId = r.regId and d.tipo = 1
            )
            or exists
            (
                        select regId from OW.tblRegistryDistribution d1 
                        inner join OW.tblElectronicMailDestinations e on e.userId in (select uid from @tbl) and e.mailId = d1.connectId
                        where d1.regId = r.regId and d1.tipo = 1
            )
end

--Histórico
if @iHist = 2 or @iHist = 3 

begin
            insert @tbAux
            select regid from OW.tblRegistryHist r where exists 
            (
                        select regId from OW.tblRegistryDistribution d 
                        where d.userId in (select uid from @tbl) and d.regId = r.regId and d.tipo = 1
            )
            or exists
            (
                        select regId from OW.tblRegistryDistribution d1 
                        inner join OW.tblElectronicMailDestinations e on e.userId in (select uid from @tbl) and e.mailId = d1.connectId
                        where d1.regId = r.regId and d1.tipo = 1
            )
end

select regID from @tbAux

GO


/****** Object:  Stored Procedure OW.usp_GetDistributionEntities    Script Date: 28-07-2004 18:18:02 ******/
GO





CREATE PROCEDURE OW.usp_GetDistributionEntities
	(
		@DistribID	numeric
	)

AS
	
SET CONCAT_NULL_YIELDS_NULL OFF

SELECT 
	b.entid, 
	RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) as name, 
	c.entid as contactid
FROM 
	OW.tblRegistryDistribution a
	LEFT JOIN OW.tblDistributionEntities b ON a.[id]=b.distribid
	LEFT JOIN OW.tblEntities c ON (b.EntID = c.EntID)
WHERE 
	a.[id]=@DistribID
	
RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_GetDistributionFromID    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionFromID
	(
		@ID numeric
	)

AS

	SELECT
		a.[ID],
		a.regID,
		a.userid,
		c.userdesc,
		a.distribtypeID,
		b.distribtypedesc,
		a.tipo,
		a.radiovia,
		a.distribobs,
		a.distribdate,
		a.state,
		a.connectid,
		a.chkfile,
		a.addresseetype,
		a.addresseeid
	FROM
		OW.tblRegistryDistribution a 
		LEFT JOIN OW.tblDistributionType b ON  (a.DistribTypeID=b.DistribTypeID) 
		LEFT JOIN  OW.tblUser c ON (a.UserID=c.UserID)
	WHERE 
		a.[ID]=@ID 
	
	IF (@@ERROR <> 0) 
		RETURN 1	
	ELSE		
		RETURN 0

GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTemp    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistributionTemp
	(
		@GUID nchar(32) 
	)

AS

	SET DATEFORMAT dmy;

	SELECT
		a.tmpid as distribID,
		a.regID,
		convert(varchar,a.distribdate,105) as distribdate,
		a.userid,
		c.userdesc,
		a.distribtypeID,
		b.distribtypedesc,
		a.tipo,
		a.radiovia,
		a.state,
		a.connectid,
		a.chkfile,
		a.distribObs,
		a.tmpid,
		a.old,
		a.guid,
		a.dispatch,
		a.addresseetype,
		a.addresseeid
	FROM
		OW.tblDistribTemp a 
		LEFT JOIN OW.tblDistributionType b ON  (a.DistribTypeID=b.DistribTypeID) 
		LEFT JOIN  OW.tblUser c ON (a.UserID=c.UserID)
	WHERE 
		a.GUID=@GUID
	ORDER BY 
		a.DistribDate 
	
	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN 1
	ELSE		
		RETURN 0





GO


/****** Object:  Stored Procedure OW.usp_GetDistributionTempCount    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionTempCount
	(
		@GUID nchar(32),
		@COUNT numeric OUTPUT 
	)

AS

	SELECT
		 @COUNT = count(*)
	FROM
		OW.tblDistribTemp a 
	WHERE 
		a.GUID=@GUID
	
	-- Save any nonzero @@ERROR value.
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTempEntities    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionTempEntities
	(
		@TmpID	numeric
	)

AS
	
SET CONCAT_NULL_YIELDS_NULL OFF	

SELECT 
	b.entid, 
	RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) as name, 
	c.entid as contactid
FROM 
	OW.tblDistribTemp a
	LEFT JOIN OW.tblDistributionEntities b ON a.tmpid=b.distribid
	LEFT JOIN OW.tblEntities c ON (b.EntID = c.EntID)
WHERE 
	a.tmpid=@TmpID and tmp=1

-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.

RETURN @@ERROR 	



GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTypeDescription    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionTypeDescription
	(
		@TypeID as numeric
	)

AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0
	
	SELECT 
		*
	FROM 
		tblDistributionType
	WHERE
		DistribTypeID = @TypeID
		
	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN





GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTypes    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistributionTypes

AS
	SELECT 
		distribtypeid, distribtypedesc
	FROM
		OW.tblDistributionType

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
		RETURN 1
	ELSE
		RETURN 0





GO


/****** Object:  Stored Procedure OW.usp_GetDistributionAddressee ******/
CREATE  PROCEDURE OW.usp_GetDistributionAddressee
(
	@addresseeType char(1),
	@addresseeID numeric(18,0)
)
AS

IF (@addresseeType = 'U')
BEGIN
	SELECT userid, userlogin, userdesc as AddresseeDesc
	FROM OW.tblUser
	WHERE userID = @addresseeID
END
ELSE
BEGIN
	SELECT groupid, groupdesc as AddresseeDesc
	FROM OW.tblGroups
	WHERE groupID = @addresseeID
END	
RETURN @@ERROR
GO




/****** Object:  Stored Procedure OW.usp_GetDistrict    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistrict
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	SELECT DistrictID, Description
	FROM OW.tblDistrict
	ORDER BY Description
	RETURN @@ERROR
GO

/****** Object:  Stored Procedure OW.usp_GetDocumentType    Script Date: 28-07-2004 18:18:03 ******/
GO

/*** GETS A DOCUMENT TYPE ***/
CREATE  PROCEDURE OW.usp_GetDocumentType

	(
		@doctypeID numeric=null,
		@abreviation varchar(20)=null,
		@designation varchar(100)=null,
		@global bit=null
	)

AS
	
	SELECT 
		td.doctypeID,td.abreviation,td.designation,td.global
	FROM 
		OW.tblDocumentType td
	WHERE (doctypeID=@doctypeID or @doctypeID is null) 
	AND (abreviation=@abreviation or @abreviation is null)
	AND (designation=@designation or @designation is null)
	AND (global=@global or @global is null)
	ORDER BY abreviation
		
Return @@ERROR


GO

/****** Object:  Stored Procedure OW.usp_GetBooks    Script Date: 12/4/2003 15:36:46 ******/

ALTER   PROCEDURE OW.usp_GetBooks
( @login VARCHAR(900) = null,
  @role  NUMERIC = null,
  @abreviation VARCHAR(20) = null,
  @designation VARCHAR(100) = null
)
AS

DECLARE @USERID NUMERIC
SET @USERID = (SELECT userID FROM OW.tblUser WHERE userLogin=@login)

IF (@abreviation is not null AND @designation is not null) /*** GETS INFO NO A GIVEN BOOK ***/
	SELECT
		*
	FROM
		OW.tblBooks
	WHERE
		@abreviation = abreviation AND  @designation=designation
	ORDER BY abreviation,designation
	
ELSE
	IF (@login is null or @role is null)
	BEGIN
		SELECT	*
		FROM OW.tblBooks 
		ORDER BY abreviation,designation
	END
	ELSE 
	BEGIN
		if @role < 4 begin
		
			SELECT	*
					FROM OW.tblBooks
					WHERE
			 (BookID IN (SELECT DISTINCT ObjectID 
						    FROM  OW.tblAccess 
						    WHERE (userID = cast (@USERID as varchar) 
						    AND ObjectType=1 AND ObjectTypeID=2 
						    AND ObjectParentID=1 AND AccessType >= cast(@role as varchar)) 
						    OR (UserID IN (SELECT DISTINCT GroupID FROM  OW.tblGroupsUsers 
						 				  WHERE UserID = cast(@USERID as varchar) ) 
										  AND ObjectType=2 AND ObjectTypeID=2 AND ObjectParentID=1) 
									      AND (BookID NOT IN (SELECT DISTINCT ObjectID 
										  				      FROM  OW.tblAccess 
															  WHERE ObjectTypeID=2 AND ObjectParentID=1 
															  AND ObjectType=1 
															 AND userid= cast (@USERID as varchar) )) 
															  AND AccessType >=cast(@role as varchar) ))
			OR BookID NOT IN (SELECT DISTINCT ObjectID 
											FROM  OW.tblAccess 
											WHERE ObjectTypeID=2 
											AND ObjectParentID=1)
			ORDER BY abreviation,designation
		
		end else begin
		
			SELECT	*
					FROM OW.tblBooks
					WHERE
			 (BookID IN (SELECT DISTINCT ObjectID 
						    FROM  OW.tblAccess 
						    WHERE (userID = cast (@USERID as varchar) 
						    AND ObjectType=1 AND ObjectTypeID=2 
						    AND ObjectParentID=1 AND AccessType >= cast(@role as varchar)) 
						    OR (UserID IN (SELECT DISTINCT GroupID FROM  OW.tblGroupsUsers 
						 				  WHERE UserID = cast(@USERID as varchar) ) 
										  AND ObjectType=2 AND ObjectTypeID=2 AND ObjectParentID=1) 
									      AND (BookID NOT IN (SELECT DISTINCT ObjectID 
										  				      FROM  OW.tblAccess 
															  WHERE ObjectTypeID=2 AND ObjectParentID=1 
															  AND ObjectType=1 
															 AND userid= cast (@USERID as varchar) )) 
															  AND AccessType >=cast(@role as varchar) ))
			ORDER BY abreviation,designation
		
		end
	END

Return @@ERROR
GO


/****** Object:  Stored Procedure OW.usp_GetElectronicMail    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetElectronicMail
	(
		@MailID numeric(18,0)
	)
AS
	
SELECT tm.MailID, tm.FromUserID, tm.Subject, tm.SendDate, tm.Message, tmd.Origin,tmd.Type,tmd.UserID,
tu.userID AS ToUserID,
(select userDesc from OW.tblUser where userID = tm.FromUserID) as FromUserDesc,
tu.UserMail,
(CASE WHEN tmd.Origin='U' THEN tu.userlogin
	ELSE tmu.eMail END) MailUser
FROM OW.tblElectronicMail tm 
	INNER JOIN OW.tblElectronicMailDestinations tmd ON (tm.MailID=tmd.MailID)
	LEFT JOIN OW.tblElectronicMailUsers tmu ON (tmd.UserID=tmu.MailUserID)
	LEFT JOIN OW.tblUser tu ON (tmd.UserID=tu.UserID)
WHERE tm.MailID=@MailID 	
ORDER BY tm.MailID

-- Ficheiros do mail
SELECT tf.FileID,tf.FileName,tf.FilePath
FROM OW.tblFileManager tf
WHERE EXISTS (SELECT 1 FROM OW.tblElectronicMailDocuments tmd
			  WHERE tmd.MailID=@MailID
			  AND tmd.FileID=tf.FileID
			  )

RETURN @@ERROR
	

GO


/****** Object:  Stored Procedure OW.usp_GetFieldIDAndType    Script Date: 28-07-2004 18:18:03 ******/
GO

CREATE PROCEDURE OW.usp_GetFieldIDAndType
    (
        @fieldName nvarchar(50) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(150)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT formFieldKEY, DynFldTypeID FROM OW.tblFormFields'

    IF LEN(@fieldName) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'fieldName like ''' + @fieldName + ''''
        END

    EXEC sp_ExecuteSQL @Query





GO

/****** Object:  Stored Procedure OW.usp_GetFieldsType    Script Date: 28-07-2004 18:18:03 ******/
GO
CREATE PROCEDURE OW.usp_GetFieldsType
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS


select 
	*
from 
	OW.tblFormFieldsType
order by description ASC
RETURN 

GO

/****** Object:  Stored Procedure OW.usp_GetFile    Script Date: 28-07-2004 18:18:03 ******/
GO
CREATE PROCEDURE OW.usp_GetFile
	(
		@FileID numeric(18,0)
	)
AS

	SELECT tfm.FileID, tfm.FileName, tfm.FilePath, tfm.CreateDate, tfm.CreateUserID, tu.userDesc
	FROM OW.tblFileManager tfm INNER JOIN OW.tbluser tu ON (tfm.CreateUserID = tu.userID)
	WHERE tfm.FileID=@FileID

RETURN @@ERROR	

GO


/****** Object:  Stored Procedure OW.usp_GetFormFields    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetFormFields
(
	@All bit=null
)
AS
	IF ( @All = 1 )
		SELECT 
			f.* , t.[description]
		FROM 
			OW.tblformfields f 
		LEFT JOIN OW.tblformfieldstype t  
			on (f.dynfldTypeID=t.dynfldTypeID) 
		ORDER BY f.fieldName
	ELSE
		SELECT 
			f.* , t.[description]
		FROM 
			OW.tblformfields f 
		LEFT JOIN OW.tblformfieldstype t  
			on (f.dynfldTypeID=t.dynfldTypeID) 
		WHERE
			Visible=1

		ORDER BY f.fieldName	
		
RETURN @@ERROR

GO



/****** Object:  Stored Procedure OW.usp_GetFormFieldsTypes    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE PROCEDURE OW.usp_GetFormFieldsTypes
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS


select 
	*
from 
	OW.tblFormFieldsType
order by description ASC
RETURN 


GO



/****** Object:  Stored Procedure OW.usp_GetGroups    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetGroups
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	SELECT * 
	FROM OW.tblgroups 
	ORDER BY GroupDesc
	RETURN @@ERROR
	


GO



/****** Object:  Stored Procedure OW.usp_GetKeywordID    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetKeywordID
    (
        @keyDescription nvarchar(50) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(150)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT keyID FROM OW.tblKeywords'

    IF LEN(@keyDescription) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'keyDescription like ''' + @keyDescription + ''''
        END

    EXEC sp_ExecuteSQL @Query





GO



/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 28-07-2004 18:18:03 ******/
GO



/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 6/4/2004 15:36:46 ******/

/*** GETS A KEYWORD ***/

CREATE PROCEDURE OW.usp_GetKeywords
	(
		@keyID numeric=null,
		@designation varchar(50)=null,
		@global bit=null
	)
AS

DECLARE @sSQL varchar(8000)
DECLARE @sSQLWhere varchar(8000)
DECLARE @sSQLOrderBY varchar(4000)

SET @sSQLWhere=''

SET @sSQL='SELECT keyID,keyDescription,[Global] FROM OW.tblKeywords'

IF (@keyID is not null) SET  @sSQLWhere = ' keyID=' + CAST(@keyID as VARCHAR)+ ' AND '
IF (@designation is not null) SET @sSQLWhere=@sSQLWhere + ' keyDescription=''' + @designation + ''' AND '
IF (@global is not null) SET  @sSQLWhere=@sSQLWhere + ' [Global]=' + CAST(@global as VARCHAR) + ' AND '
print @sSQLWhere
-- Remove last AND
IF LEN(@sSQLWhere)>0
BEGIN
SET @sSQLWhere = LEFT(@sSQLWhere,LEN(@sSQLWhere)-3)
SET @sSQLWhere = ' WHERE ' +  @sSQLWhere 
END


SET  @sSQLOrderBY= ' ORDER BY	keyDescription'

EXEC (@sSQL + @sSQLWhere + @sSQLOrderBY)
Return @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_GetKeywordsByID    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetKeywordsByID
	(
		@keyID text
	)
AS

	
SELECT keyID,keyDescription,[Global] 
FROM OW.tblKeywords
WHERE EXISTS (SELECT 1 FROM OW.fnListToTable(@keyID,',') WHERE value=keyID)

RETURN @@ERROR


GO



/****** Object:  Stored Procedure OW.usp_GetListOptionsValues    Script Date: 28-07-2004 18:18:03 ******/
GO






CREATE     PROCEDURE OW.usp_GetListOptionsValues

	(
		@like varchar(100) = null
	)

AS

Declare @strQuery varchar(8000)

set @strQuery = 'Select ListID, Description from OW.tblListOptionsValues '

	if @like is null
	BEGIN
		PRINT '== Null'
		Select ListID, Description from OW.tblListOptionsValues 
		Order by Description
	END
	ELSE
	BEGIN
		Print '<> Null'
		Select ListID, Description from OW.tblListOptionsValues
		Where Description Like @Like 
		Order by Description
	END
	

	/* SET NOCOUNT ON */
	RETURN @@ERROR






GO


/****** Object:  Stored Procedure OW.usp_GetListUsersAndGroups    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetListUsersAndGroups

	(
		@ObjectParentID numeric,
		@userActive bit=1
	)

AS	
	SELECT userID, userDesc AS Description, 1 As ObjectType, AccessType
	FROM OW.tblUser tu INNER JOIN OW.tblEntityListAccess ta ON (tu.userID=ta.ObjectID)
	WHERE (userActive=@userActive)
	AND (ObjectParentID=@ObjectParentID and ObjectType=1)
	UNION 
	SELECT GroupID AS userID, GroupDesc AS Description, 2 AS ObjectType, AccessType
	FROM OW.tblGroups tg INNER JOIN OW.tblEntityListAccess ta ON (tg.GroupID=ta.ObjectID)
	WHERE ObjectParentID=@ObjectParentID and ObjectType=2
	ORDER BY 2 
		
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetListValues    Script Date: 28-07-2004 18:18:03 ******/
GO







CREATE     PROCEDURE OW.usp_GetListValues
(
		@id numeric
)
	AS
	SELECT DISTINCT 
		OW.tblListOptionsValues.Description, 
		OW.tblListValues.FormFieldKey, 
		OW.tblListOptionsValues.ListID
	FROM    
		OW.tblListOptionsValues LEFT OUTER JOIN
                OW.tblListValues ON OW.tblListOptionsValues.ListID = OW.tblListValues.ListID 
		AND OW.tblListValues.FormFieldKey = @ID	
	ORDER BY OW.tblListOptionsValues.[Description]
	
	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0





GO


/****** Object:  Stored Procedure OW.usp_GetListValuesbyID    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE  PROCEDURE OW.usp_GetListValuesbyID  

(
		@id numeric,
		@like varchar(100) = null
)
AS


Declare @strQuery varchar(8000)


	if @like is null
	BEGIN

		SELECT OW.tblListValues.ListID, OW.tblListValues.FormFieldKey, OW.tblListOptionsValues.Description
		FROM   OW.tblListValues INNER JOIN
	               OW.tblListOptionsValues ON OW.tblListValues.ListID = OW.tblListOptionsValues.ListID
		WHERE OW.tblListValues.FormFieldKey = @id
		Order by OW.tblListOptionsValues.Description
	END
	ELSE
	BEGIN

		SELECT OW.tblListValues.ListID, OW.tblListValues.FormFieldKey, OW.tblListOptionsValues.Description
		FROM   OW.tblListValues INNER JOIN
	               OW.tblListOptionsValues ON OW.tblListValues.ListID = OW.tblListOptionsValues.ListID
		WHERE OW.tblListValues.FormFieldKey = @id
		And OW.tblListOptionsValues.Description Like @Like 	
		Order by OW.tblListOptionsValues.Description
	END




	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0

		


GO



/****** Object:  Stored Procedure OW.usp_GetLists    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE PROCEDURE OW.usp_GetLists
	AS
	
	SELECT
		*
	FROM
		OW.tblFormFields 
	WHERE 
		DYNFLDTYPEID = 7
	ORDER BY 
		 FieldName

	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0

GO




/****** Object:  Stored Procedure OW.usp_GetNonListUsersAndGroups    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetNonListUsersAndGroups

	(
		@ObjectParentID numeric,
		@userActive bit=1
	)

AS
	SELECT userID, userDesc AS Description, 1 As ObjectType
	FROM OW.tblUser 
	WHERE (userActive=@userActive)
	AND (userID NOT IN (SELECT ObjectID 
						FROM OW.tblEntityListAccess 
						WHERE ObjectParentID=@ObjectParentID and ObjectType=1))
	UNION 
	SELECT GroupID AS userID, GroupDesc AS Description, 2 AS ObjectType
	FROM OW.tblGroups 
	WHERE (GroupID NOT IN (SELECT ObjectID 
						FROM OW.tblEntityListAccess 
						WHERE ObjectParentID=@ObjectParentID and ObjectType=2))
	ORDER BY 2 
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetOtherWays    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetOtherWays
	(
		@code nvarchar(50)		
	)
AS

	SELECT 
		*
	FROM
		OW.tblDistributionType
	WHERE
		@code=GetDistribCode

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
		RETURN 1
	ELSE
		RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_GetOtherWaysFull    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetOtherWaysFull
AS

	SELECT 
		*
	FROM
		OW.tblDistributionType

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
		RETURN 1
	ELSE
		RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_GetPostalCode    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetPostalCode
	(
		@ID numeric=null,
		@Code varchar(10)=null,
		@Desc varchar(100)=null
	)
AS
	SET NOCOUNT ON 
		
	IF (@ID is not null) AND (@Code is null) AND (@Desc is null)
		BEGIN
			SELECT PostalCodeID,Code,Description
			FROM OW.tblPostalCode
			WHERE PostalCodeID=@ID 
		END
	ELSE
	BEGIN 
		IF (@ID is null) AND (@Code is null) AND (@Desc is null)
			BEGIN
				SELECT PostalCodeID,Code,Description
				FROM OW.tblPostalCode
				ORDER BY Code
			END
		ELSE 
			BEGIN
				SELECT PostalCodeID,Code,Description
				FROM OW.tblPostalCode
				WHERE (PostalCodeID=@ID OR @ID is null)
				AND   (Code=@Code OR @Code is null)
				AND   (Description=@Desc OR @Desc is null)
				ORDER BY Code
			END
	END
		
	RETURN @@ERROR






GO


CREATE PROCEDURE OW.usp_GetProfiles

	@profileID numeric,
	@profileType varchar(20)

AS

if (@profileID is null and @profileType is null)

	begin
		SELECT * FROM OW.tblProfiles ORDER BY ProfileDesc 
	end

else

	begin

			declare @whereCondition varchar(255)
			set @whereCondition = ''
			
			if (@profileID is not null)
			begin
				set @whereCondition = @whereCondition + ' ProfileID = ' + cast(@profileID as varchar)
			end

			if (@profileType is not null)
			begin
				
					if (@whereCondition != '')
						begin
							set @whereCondition = @whereCondition + ' AND '
						end
						
					set @whereCondition = @whereCondition + ' ProfileType IN( ' + cast(@profileType as varchar) +')'

			end
			
			if (@whereCondition != '')
				begin
					exec('SELECT * FROM OW.tblProfiles WHERE ' + @whereCondition + ' ORDER BY ProfileDesc')
				end
			else
				begin
					SELECT * FROM OW.tblProfiles ORDER BY ProfileDesc
				end

	end


GO


/****** Object:  Stored Procedure OW.usp_GetProfilesFields    Script Date: 28-07-2004 18:18:03 ******/
GO






/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 6/4/2004 15:36:46 ******/

/*** GETS A KEYWORD FROM A BOOK***/

CREATE    PROCEDURE OW.usp_GetProfilesFields
	(
	@profileID numeric
	)
AS
-- @mode numeric    /* 0 - FIELDS IN PROFILE, 1 - FIELDS NOT IN PROFILE  */
SELECT 
	OW.tblProfilesFields.ProfileId, 
	OW.tblFormFields.FormFieldKey, 
	OW.tblProfilesFields.FormFieldOrder, 
        OW.tblProfilesFields.FieldMaxChars, 
	OW.tblFormFields.fieldName
FROM    
	OW.tblFormFields LEFT OUTER JOIN
        OW.tblProfilesFields ON OW.tblFormFields.formFieldKEY = OW.tblProfilesFields.FormFieldKey AND 
        OW.tblProfilesFields.ProfileId = @profileID 
	order by OW.tblProfilesFields.formFieldOrder

Return @@ERROR
	






GO


/****** Object:  Stored Procedure OW.usp_GetRegIDFromCircMailID    Script Date: 28-07-2004 18:18:03 ******/
GO




-- APAGAR !? --andre
CREATE PROCEDURE OW.usp_GetRegIDFromCircMailID
	(@MailID numeric)
AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0
	
	SELECT 
		regid 
	FROM 
		OW.tblRegistryDistribution
	WHERE 
		ConnectID=@MailID
	
	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN 		

GO



/****** Object:  Stored Procedure OW.usp_GetRegistry    Script Date: 28-07-2004 18:18:03 ******/

CREATE PROCEDURE OW.usp_GetRegistry
	(
		@regID numeric
	)
AS

	SELECT
		*, OW.tblBooks.abreviation, OW.tblBooks.designation
	FROM
		OW.tblRegistry,  OW.tblBooks
	Where 
		OW.tblRegistry.regID = @regid AND  OW.tblRegistry.bookid = OW.tblBooks.bookid  

	IF (@@ERROR <> 0)
		Return 1
	ELSE
		Return 0




GO


/****** Object:  Stored Procedure OW.usp_GetRegistryFiles    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetRegistryFiles
	(
		@RegID numeric(18,0),
		@FileID numeric(18,0)=null		
	)
AS

IF @FileID is null 
	BEGIN
		SELECT tfm.FileID, tfm.FileName, tfm.FilePath 
		FROM OW.tblFileManager tfm
		WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments trd 
					WHERE trd.FileID=tfm.FileID
					AND trd.RegiD=@RegID)
	END
ELSE
	BEGIN
		SELECT tfm.FileID, tfm.FileName, tfm.FilePath 
		FROM OW.tblFileManager tfm
		WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments trd 
					WHERE trd.FileID=tfm.FileID
					AND trd.RegiD=@RegID
					AND trd.FileID=@FileID)

	END	
	RETURN @@ERROR	


GO











/****** Object:  Stored Procedure OW.usp_GetTempEntities    Script Date: 28-07-2004 18:18:03 ******/
GO






CREATE PROCEDURE OW.usp_GetTempEntities
	(
		@GUID	nvarchar(250),
		@EntityName nvarchar(250),
		@EntityType bit,
        @EntityContactID nvarchar(250)
	)
AS
	 If @EntityContactID = ''
	 BEGIN
		 If @EntityName = ''
			BEGIN
				SELECT EntID,entityName, entityType, ContactID FROM  tblEntitiesTemp WHERE Guid Like @GUID
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RETURN @@ERROR
				END
			END
		ELSE
			BEGIN			
				 SELECT EntID,entityName, entityType, ContactID FROM  tblEntitiesTemp WHERE Guid Like @GUID  AND entityName=@EntityName AND EntityType=@EntityType
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RETURN @@ERROR
				END
			END
	END
	ELSE
		BEGIN
			 SELECT EntID,entityName, entityType, ContactID FROM tblEntitiesTemp WHERE Guid Like @GUID AND ContactID Like @EntityContactID AND EntityType=@EntityType
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
		END
	
	COMMIT TRANSACTION
	RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_GetTextSign    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE PROCEDURE OW.usp_GetTextSign
	(
		@login varchar(900)
	)
AS
	SET NOCOUNT ON 
	
	SELECT TextSignature
	FROM OW.tblUser
	WHERE userlogin =@login 
	return @@ERROR	



GO

CREATE PROCEDURE OW.usp_GetUserInfo
AS
    SELECT userLogin, userDesc, userMail, userActive FROM OW.tblUser
    ORDER BY userLogin





GO



/****** Object:  Stored Procedure OW.usp_GetUserPersistence    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_GetUserPersistence
	(
		@UserID numeric
	)
AS
	/* SET NOCOUNT ON */
	SELECT
		 formFieldKEY,fieldValue, 
		formFieldKEY,fieldValue2 
	FROM 
		OW.tblUserPersistence
	WHERE 
		UserID=@UserID

	RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_GetUserPersistenceConfigOthers    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_GetUserPersistenceConfigOthers
(@UserID numeric)
AS

	SELECT formFieldKEY
	FROM OW.tblUserPersistenceConfig
	WHERE (formFieldKEY=1 OR formFieldKEY=2 OR formFieldKEY=3 OR formFieldKEY=10)
	AND UserID=@UserID

	RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetUserPersistenceKeep    Script Date: 28-07-2004 18:18:04 ******/
GO

CREATE PROCEDURE OW.usp_GetUserPersistenceKeep
	(@UserID numeric)
AS
	SELECT a.formFieldKEY, f.FieldName
	FROM OW.tblUserPersistenceConfig a LEFT JOIN OW.tblFormFields f ON 
		(a.formFieldKEY=f.formFieldKEY)
	WHERE  a.UserID=@UserID

	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_GetUserPersistenceNotKeep    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_GetUserPersistenceNotKeep
	(@UserID numeric)
AS
	SELECT formFieldKEY, FieldName
	FROM OW.tblFormFields
	WHERE formFieldKEY NOT IN (SELECT formFieldKEY 
							   FROM OW.tblUserPersistenceConfig
							   WHERE UserID=@UserID)
	RETURN @@ERROR

GO






/****** Object:  Stored Procedure OW.usp_GetUserRoles    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_GetUserRoles
	(
		@UserID numeric(18)
	)
AS

	SELECT UserID, ObjectParentID, ObjectID, ObjectTypeID
	FROM OW.tblaccess a
	WHERE UserID = @UserID
	And ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	ORDER BY ObjectParentID

	RETURN @@ERROR


GO

/*********************** PROCEDURE OW.usp_GetUsersByGroup **************************/ 
GO
CREATE   PROCEDURE OW.usp_GetUsersByGroup (
	@GroupID as numeric
)
AS

SELECT     OW.tblGroupsUsers.GroupID, OW.tblUser.*
FROM       OW.tblGroupsUsers RIGHT OUTER JOIN
           OW.tblUser ON 
	   OW.tblGroupsUsers.UserID = OW.tblUser.userID AND 
	   OW.tblGroupsUsers.GroupID = @GroupID 
	   ORDER BY OW.tblUser.userDesc

GO



/****** Object:  Stored Procedure OW.usp_GetUsersById    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_GetUsersById

	@usersList text

AS

select * from OW.tblUser usr where exists 
(select 1 from OW.fnListToTable(@usersList, ',') list where usr.userID = list.value)

GO


/****** Object:  Stored Procedure OW.usp_GetUsersByProduct    Script Date: 28-07-2004 18:18:04 ******/
GO
CREATE PROCEDURE OW.usp_GetUsersByProduct
	(
		@Product numeric(18,0),
		@Active bit = null
	)
AS

IF @Active is null
BEGIN
	SELECT a.ObjectID as Role, a.userID, u.userLogin, u.userDesc, u.userMail 
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID 
	ORDER BY  u.userDesc
END
ELSE
BEGIN
	SELECT a.ObjectID as Role, a.userID, u.userLogin, u.userDesc, u.userMail 
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID
	AND u.userActive=@Active
	ORDER BY  u.userDesc

END

RETURN @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_GetUsersPrimaryGroup    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_GetUsersPrimaryGroup

	@mode bit

AS

	if (@mode = 1) /***Users with a primary group assigned ***/

		begin
			SELECT 
				usr.userid,
				usr.userdesc,
				grp.GroupID,
				grp.Groupdesc,
				(select distinct 1 from OW.tblAccessReg reg where reg.HierarchicalUserID = usr.UserID) as HasHierarchicalAccess
			FROM
				OW.tblUser usr, 
				OW.tblGroups grp
			WHERE 
				usr.PrimaryGroupID IS NOT NULL  
				AND usr.PrimaryGroupID = grp.GroupID
 		end

	ELSE /***Users that do NOT have a primary group assigned ***/

		begin
			
			SELECT 
				usr.userid,
				usr.userdesc,
				grp.GroupID,
				grp.Groupdesc,
				(select distinct 1 from OW.tblAccessReg reg where reg.HierarchicalUserID = usr.UserID) as HasHierarchicalAccess
			FROM
				OW.tblUser usr, 
				OW.tblGroups grp
			WHERE 
				usr.PrimaryGroupID IS NOT NULL  
		end
	
Return @@ERROR

GO







/****** Object:  Stored Procedure OW.usp_ModifyClassification    Script Date: 28-07-2004 18:18:04 ******/
GO




/*
CREATE PROCEDURE OW.usp_ModifyClassification
	(
		@ClassID numeric,
		@LevelCode varchar(50),
		@LevelDesc varchar(100),
		@Tipo varchar(50),
		@Level numeric,
		@Books varchar(4000)
	)
AS
	DECLARE @strSQL varchar(250)
	DECLARE @CustomError bit			
	DECLARE @Pos NUMERIC
	DECLARE @BookID varchar(10)

	
	SET @CustomError = 0
	
	BEGIN TRANSACTION
	
	IF @Level = 1
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level1 = @LevelCode AND ClassID <> @ClassID AND Level2 IS NULL) = 0
		BEGIN
			--fazer o update
			UPDATE OW.tblClassification 
			SET Level1Desig = @LevelDesc,
			Level1 = @LevelCode
			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
			UPDATE OW.tblClassification
			SET	Tipo = @Tipo
			WHERE ClassID = @ClassID

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
			--apagar os livros associados
			DELETE FROM OW.tblClassificationBooks WHERE ClassID = @ClassID
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
			--inserir novamente os livros apenas se for 'private'
			IF @Tipo = 'Private'
			BEGIN
				SET @Books = LTRIM(RTRIM(@Books))+ ','
				SET @Pos = CHARINDEX(',', @Books, 1)
				
				IF REPLACE(@Books, ',', '') <> ''
				BEGIN
					WHILE @Pos > 0
					BEGIN
						SET @BookID = LTRIM(RTRIM(LEFT(@Books, @Pos - 1)))
						IF @Books <> ''
						BEGIN
							--Print BookID
							INSERT INTO OW.tblClassificationBooks (ClassID, BookID)
							VALUES (@ClassID, CAST(@BookID as NUMERIC))

							IF @@ERROR <> 0
							BEGIN
								ROLLBACK TRANSACTION
								RETURN @@ERROR
							END
						END
						SET @Books = RIGHT(@Books, LEN(@Books) - @Pos)
						SET @Pos = CHARINDEX(',', @Books, 1)
					END
				END	
			END
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END
	END
	
	IF @Level = 2
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level2 = @LevelCode AND ClassID <> @ClassID AND Level3 IS NULL
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level2Desig = @LevelDesc,
			Level2 = @LevelCode
			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END
	END
	IF @Level = 3
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level3 = @LevelCode AND ClassID <> @ClassID AND Level4 IS NULL
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level3Desig = @LevelDesc,
			Level3 = @LevelCode
			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)
		END
		ELSE
		BEGIN
			print 'entrou no 3'
			SET @CustomError = 1
		END	
	END
	IF @Level = 4
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level4 = @LevelCode AND ClassID <> @ClassID AND Level5 IS NULL
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level4Desig = @LevelDesc,
			Level4 = @LevelCode

			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level4 = (SELECT Level4 FROM OW.tblClassification WHERE ClassID = @ClassID)
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END	
	END
	IF @Level = 5
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level5 = @LevelCode AND ClassID <> @ClassID
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level4 = (SELECT Level4 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level5Desig = @LevelDesc,
			Level5 = @LevelCode
			WHERE ClassID = @ClassID
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END	
	END

	IF @CustomError = 0
	BEGIN
		IF @@ERROR = 0
		BEGIN
			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION
		END
		RETURN @@ERROR
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Já existe classificação com esse código.', 11, 1)
	END

*/
GO

/****** Object:  Stored Procedure OW.usp_MoveDistributionsToTable    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_MoveDistributionsToTable

	(
		@REGID numeric,
		@GUID varchar(32)
	)

AS
	BEGIN TRANSACTION

	-- DELETES THE EXISTING DISTRIBUTIONS FROM THE DISTRIBUTION TABLE
	DELETE FROM OW.tblRegistryDistribution WHERE RegID= @regID 

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END

	-- TRANSFER THE TEMPORARY DISTRIBUTIONS TO THE DISTRIBUTION TABLE
	INSERT INTO 
		OW.tblRegistryDistribution (regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, state, ConnectID, AddresseeType, AddresseeID) 
	SELECT 
		regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, state, ConnectID, AddresseeType, AddresseeID
	FROM 
		OW.tblDistribTemp
	WHERE GUID=@GUID

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	-- DELETES THE EXISTING TEMPORARY DISTRIBUTIONS FROM THE TEMPORARY DISTRIBUTION TABLE
	DELETE FROM OW.tblDistribTemp WHERE GUID= @GUID 

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 3
	END

	/*-- Create temporary entities
	INSERT INTO  
		OW.tblDistributionEntities (DistribID, EntID, Tmp)
	SELECT  
		d.tmpid as DistribID,e.EntID, 1 As Tmp
	FROM 
		OW.tblDistribTemp d INNER JOIN OW.tblDistributionEntities e ON (d.id=e.DistribID)
	WHERE 
		e.DistribID IN (SELECT ID FROM OW.tblRegistryDistribution WHERE regid=@REGID )

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END*/

	--COMMIT TRANSACTION
	COMMIT TRANSACTION
	RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_MoveDistributionsToTemp    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_MoveDistributionsToTemp
	(
		@REGID numeric,
		@GUID varchar(32)
	)
AS
    --  Is there any distribution?
    IF (	SELECT 
				COUNT(*) As Tot 
			FROM 
				OW.tblRegistryDistribution 
			WHERE 
				RegID= @regID ) >0 
		BEGIN	

			BEGIN TRANSACTION

			-- Transfer distributions to temporary table	
			INSERT INTO 
				OW.tblDistribTemp	(ID,OLD,GUID,regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, txtEntidadeID, state, ConnectID, Dispatch, AddresseeType, AddresseeID) 
			SELECT 
				ID,1 as OLD, @GUID as GUID, regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, txtEntidadeID, state, ConnectID, Dispatch, AddresseeType, AddresseeID
			FROM 
				OW.tblRegistryDistribution 
			WHERE RegID= @regID
			
			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RETURN 1
			END

			/*-- Create temporary entities
			INSERT INTO  
				OW.tblDistributionEntities (DistribID, EntID, Tmp)
			SELECT  
				d.tmpid as DistribID,e.EntID, 1 As Tmp
			FROM 
				OW.tblDistribTemp d INNER JOIN OW.tblDistributionEntities e ON (d.id=e.DistribID)
			WHERE 
				e.DistribID IN (SELECT ID FROM OW.tblRegistryDistribution WHERE regid=@REGID )*/

			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RETURN 2
			END

			--COMMIT TRANSACTION
			COMMIT TRANSACTION
			RETURN 0
		END
	ELSE
		RETURN 0





GO
/*** INSERTS A NEWBOOK***/

CREATE  PROCEDURE OW.usp_NewBook
(
		@Abreviation varchar(50) = NULL,
		@Designation varchar(100) = NULL,
		@Automatic bit = 1,
		@hierarchical bit = 1,
		@Duplicated bit = 0,
		@BookID int output
)

AS
	INSERT INTO
		OW.tblBooks (Abreviation,Designation, Automatic, hierarchical, Duplicated) 
	VALUES
		(@Abreviation, @Designation, @Automatic, @hierarchical, @Duplicated) 
	
	SET @BookID = @@IDENTITY

	RETURN @@ERROR	

GO

CREATE PROCEDURE OW.usp_NewContact

	(@FirstName varchar(50)='', 
	@MiddleName varchar(300)='',
	@LastName varchar(50)='', 
	@ListID numeric=null,
	@BI numeric=null, 
	@NumContribuinte numeric=null, 
	@AssociateNum numeric=null,
	@eMail varchar(300)='',
	@JobTitle varchar(100)='', 
	@Street  varchar(500)='',
	@PostalCodeID numeric=null,	
	@CountryID numeric=null,
	@Phone  varchar(20)='', 
	@Fax  varchar(20)='', 
	@Mobile  varchar(20)='',
	@DistrictID numeric=null,
	@EntityID numeric = null,
	@User varchar(900),
	@EntID NUMERIC OUTPUT, /* Return new contact ID */
	@type tinyint=1
	)

AS

DECLARE @UID numeric

SELECT @UID=userid from OW.tblUser where upper(userLogin)=upper(@User)

	INSERT INTO OW.tblEntities (FirstName, MiddleName,LastName, ListID,
									 BI, NumContribuinte, AssociateNum,eMail,JobTitle, Street,
									 PostalCodeID, CountryID, Phone, Fax, Mobile, DistrictID,EntityID,active, type)
	VALUES (ltrim(rtrim(@FirstName)), ltrim(rtrim(@MiddleName)),ltrim(rtrim(@LastName)), 
			@ListID, @BI, @NumContribuinte, @AssociateNum, ltrim(rtrim(@eMail)), 
			ltrim(rtrim(@JobTitle)), ltrim(rtrim(@Street)), @PostalCodeID, @CountryID, 
			ltrim(rtrim(@Phone)), ltrim(rtrim(@Fax)), ltrim(rtrim(@Mobile)),
			@DistrictID,@EntityID,1,@type)
	IF (@@ERROR <> 0)
		return @@ERROR
	
	SET @EntID=@@IDENTITY
	
	RETURN @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_NewContactList    Script Date: 28-07-2004 18:18:04 ******/
GO




CREATE PROCEDURE OW.usp_NewContactList
	(
	 @Desc varchar(100),
	 @global bit
	 )
AS
	INSERT INTO OW.tblEntityList (Description,global)
	VALUES (@Desc,@global)
	RETURN @@ERROR
	 

GO

CREATE PROCEDURE OW.usp_GetDistributionAutomatic

	@fieldID numeric=null,
	@fieldValue numeric=null

AS

SELECT 
AutoDistribID as DistribID,
TypeID as Tipo,
FieldID,
FieldValue,
WayID as radioVia,
SendFiles as chkFile,
DistribObs,
DistribTypeID,
DispatchID as dispatch,
getdate() as DistribDate,
'' as UserDesc,
1 as State,
AddresseeType as addresseeType,
AddresseeID as addresseeID
FROM OW.tblDistributionAutomatic
WHERE (FieldID = @fieldID OR @fieldID is null) AND
(FieldValue = @fieldValue OR @fieldValue is null)


GO


CREATE PROCEDURE OW.usp_GetDistributionAutomaticReport

As 

SET CONCAT_NULL_YIELDS_NULL OFF

/*
	Procedimento para converter resultados que envolvão a tabela antiga de classificações
	Serve temporáriamente para alguns procedimentos antigos.
*/

/*
SELECT 
CASE WHEN fieldID=10 THEN 'Livro'
WHEN fieldID=20 THEN 'Tipo Documento' 
WHEN fieldID=6 THEN 'Classificação' 
END as Campo,
CASE WHEN fieldID=10 THEN tb.designation
WHEN fieldID=20 THEN  tdt.designation
--WHEN fieldID=6 THEN  --tc.level1 + ' ' + tc.level2 + ' ' +  tc.level3 + ' ' +  tc.level4 + ' ' +  tc.level5
END as Designação,
COUNT(*) as Quantidade,
CASE WHEN TypeID='1' then 'Correio Electónico'
WHEN TypeID='2' then 'Outras Vias'
--WHEN TypeID='3' then 'SAP'
--WHEN TypeID='4' then 'ULTIMUS'
--WHEN TypeID='5' then 'WorkFlow'
WHEN TypeID='6' then 'Processos'
--WHEN TypeID='7' then 'SGP'
--WHEN TypeID='8' then 'eProcess'
END as Tipo
FROM OW.tblDistributionAutomatic LEFT JOIN OW.tblbooks tb ON (fieldValue=bookid AND fieldID=10)
LEFT JOIN OW.tblDocumentType tdt ON (fieldValue=doctypeid AND fieldID=20)
LEFT JOIN OW.tblClassification tc ON (classificationid=fieldValue AND fieldID=6)
GROUP BY FieldID,fieldValue,tb.designation,tdt.designation, TypeID--,tc.level1,tc.level2,tc.level3,tc.level4,tc.level5,TypeID
HAVING fieldValue > 0
ORDER BY Campo,Designação
*/
SELECT *
FROM OW.fnDistributionReport()

RETURN @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_NewDistributionAutomaticToTemporary    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_NewDistributionAutomaticToTemporary

	@bookID numeric = null,
	@classificationID numeric = null,
	@documentTypeID numeric = null,
	@guid nchar(32),
	@userID numeric

AS


DECLARE @DISTRIBUTION_OTHER_WAYS NUMERIC
SET @DISTRIBUTION_OTHER_WAYS = 2

SET XACT_ABORT ON

BEGIN TRANSACTION

INSERT INTO OW.tblDistribTemp 
(GUID, Tipo, DistribObs, radioVia, chkFile, DistribTypeID, 
regID, DistribDate, UserID, OLD, State, ConnectID, ID, dispatch, AutoDistrib,AutoDistribID,AddresseeType,AddresseeID)

SELECT 
@guid,			-- GUID
TypeID,			-- Tipo
DistribObs,		-- DistribObs
WayID,			-- radioVia
SendFiles,		-- chkFile
DistribTypeID,		-- DistribTypeID
0,			-- regID
getdate(),		-- DistribDate
@userID,		-- UserID
0,			-- OLD
1,			-- State
null,			-- ConnectID
null,			-- ID
DispatchID,		-- dispatch
1,			-- AutoDistrib
AutoDistribID,		-- AutoDistribID
AddresseeType,		-- AddresseeType
AddresseeID		-- AddresseeID
FROM OW.tblDistributionAutomatic
WHERE ((FieldValue = @bookID and FieldID = 10) or 
	(FieldValue = @classificationID and FieldID = 6) or 
	(FieldValue = @documentTypeID and FieldID = 20))


-- Copy Other Ways Entities
INSERT INTO OW.tblDistributionEntities (DistribID,EntID,Tmp)
SELECT TmpID, EntID, 1
FROM OW.tblDistributionAutomaticEntities  dae 
	INNER JOIN OW.tblDistribTemp dt ON (dae.AutoDistribID=dt.AutoDistribID)
WHERE AutoDistrib=1 
AND guid=@guid
AND tipo=@DISTRIBUTION_OTHER_WAYS

COMMIT TRANSACTION




GO



/****** Object:  Stored Procedure OW.usp_NewDocumentType    Script Date: 28-07-2004 18:18:04 ******/
GO


/****** Object:  Stored Procedure OW.usp_NewDocumentType   Script Date: 12/4/2004 16:36:46 ******/

/*** INSERTS A NEW DOCUMENT TYPE ***/

CREATE PROCEDURE OW.usp_NewDocumentType

	(
		@abreviation varchar(50) = NULL,
		@designation varchar(50) = NULL,
		@global bit = 1
	)

AS
	INSERT INTO
		OW.tblDocumentType	 (abreviation, designation, [global])
	VALUES
		(@abreviation, @designation,  @global )
	

RETURN @@ERROR

GO



/****** Object:  Stored Procedure OW.usp_NewElectronicMail    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_NewElectronicMail
	(
		@FromUserID numeric(18,0),
		@Subject varchar(500),
		@Message Text,
		@FileID Text=null,
		@DestUserIDTo Text=null,
		@DestUserIDCc Text=null,
		@DestUserMailTo Text=null,
		@DestUserMailCc Text=null,
		@MID numeric(18,0) output
	)
AS
DECLARE @MailID numeric(18,0)
DECLARE @MailUserID numeric(18,0)
DECLARE @ID int
DECLARE @Value varchar(4000)

SET XACT_ABORT ON

BEGIN TRANSACTION

-- ********************** Main Table Data ***********************************
	INSERT INTO OW.tblElectronicMail (FromUserID,Subject,Message)	
	VALUES (@FromUserID,@Subject,@Message)
	SET @MailID=@@IDENTITY

-- ****************************** Files *************************************
IF (@FileID is not null)
BEGIN
	DECLARE FilesID_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@FileID,',')

	OPEN FilesID_cursor
	FETCH NEXT FROM FilesID_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
		INSERT INTO OW.tblElectronicMailDocuments (MailID, FileID)
		VALUES (@MailID,Cast(@Value as numeric(18,0)))	
		FETCH NEXT FROM FilesID_cursor INTO @ID,@Value
	END
	CLOSE FilesID_cursor
	DEALLOCATE FilesID_cursor
END
-- ************************** Destinations To***********************************
IF (@DestUserIDTo is not null)
BEGIN

	DECLARE DestUsersIDTo_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserIDTo,',')

	OPEN DestUsersIDTo_cursor
	FETCH NEXT FROM DestUsersIDTo_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (Cast(@Value as numeric(18,0)),@MailID,'U','T')	
		
		FETCH NEXT FROM DestUsersIDTo_cursor INTO @ID,@Value
	END
	CLOSE DestUsersIDTo_cursor
	DEALLOCATE DestUsersIDTo_cursor
END


-- Hand writen eMail
IF (@DestUserMailTo is not null)
BEGIN

	DECLARE DestUsersMailTo_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserMailTo,',')

	OPEN DestUsersMailTo_cursor
	FETCH NEXT FROM DestUsersMailTo_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		IF NOT EXISTS (SELECT MailUserID FROM OW.tblElectronicMailUsers 
					WHERE eMail=CAST(@Value AS VARCHAR(500)))
			BEGIN
				INSERT INTO OW.tblElectronicMailUsers (eMail)
				VALUES (CAST(@Value AS VARCHAR(500)))
				SET @MailUserID=@@IDENTITY		
			END
		ELSE
			BEGIN
				SELECT @MailUserID=MailUserID FROM OW.tblElectronicMailUsers 
					WHERE eMail=CAST(@Value AS VARCHAR(500))
			END

			INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (@MailUserID,@MailID,'M','T')	
		FETCH NEXT FROM DestUsersMailTo_cursor INTO @ID,@Value
	END
	CLOSE DestUsersMailTo_cursor
	DEALLOCATE DestUsersMailTo_cursor
END
-- ************************** Destinations Cc ***********************************
IF (@DestUserIDCc is not null)
BEGIN
	DECLARE DestUsersIDCc_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserIDCc,',')

	OPEN DestUsersIDCc_cursor
	FETCH NEXT FROM DestUsersIDCc_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (Cast(@Value as numeric(18,0)),@MailID,'U','C')	
		
		FETCH NEXT FROM DestUsersIDCc_cursor INTO @ID,@Value
	END
	CLOSE DestUsersIDCc_cursor
	DEALLOCATE DestUsersIDCc_cursor
END

-- Hand writen eMail
-- @DestUserMail Text
IF (@DestUserMailCc is not null)
BEGIN
	DECLARE DestUsersMailCc_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserMailCc,',')

	OPEN DestUsersMailCc_cursor
	FETCH NEXT FROM DestUsersMailCc_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
			IF NOT EXISTS (SELECT MailUserID FROM OW.tblElectronicMailUsers 
					WHERE eMail=CAST(@Value AS VARCHAR(500)))
		BEGIN
			INSERT INTO OW.tblElectronicMailUsers (eMail)
			VALUES (CAST(@Value AS VARCHAR(500)))
			SET @MailUserID=@@IDENTITY		
		END
		ELSE
		BEGIN
			SELECT @MailUserID=MailUserID FROM OW.tblElectronicMailUsers 
				WHERE eMail=CAST(@Value AS VARCHAR(500))
		END
		
		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (@MailUserID,@MailID,'M','C')	
		FETCH NEXT FROM DestUsersMailCc_cursor INTO @ID,@Value
	END
	CLOSE DestUsersMailCc_cursor
	DEALLOCATE DestUsersMailCc_cursor
END
SET @MID=@MailID
COMMIT TRANSACTION
RETURN @@ERROR


GO



/****** Object:  Stored Procedure OW.usp_NewFile    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_NewFile
	(
		@Name varchar(300),		
		@FileServer as varchar(4000),
		@UserID numeric(18,0),
		@Extension varchar(10)=null
	)
AS
DECLARE @FileID numeric(18,0)
DECLARE @lFileID bigint
DECLARE @hexstring varchar(20)
DECLARE @vb varbinary(10)
DECLARE @strPathName as varchar(500)

BEGIN TRANSACTION

	INSERT INTO OW.tblFileManager (FileName,FilePath,CreateDate,CreateUserID) 
	VALUES (@Name,' ',GetDate(),@UserID)

SET @FileID=@@IDENTITY

SELECT @lFileID=CAST(@FileID as bigint)
SELECT @vb=CAST(@lFileID as varbinary)
EXEC master.dbo.xp_varbintohexstr @vb, @hexstring OUT

SET @hexstring=SUBSTRING(@hexstring,LEN(@hexstring)-7,LEN(@hexstring))
SET @strPathName=SUBSTRING(@hexstring,1,2) + '\'
SET @strPathName= @strPathName + SUBSTRING(@hexstring,3,2) + '\'
SET @strPathName= @strPathName + SUBSTRING(@hexstring,5,2) + '\'
SET @strPathName= @strPathName + SUBSTRING(@hexstring,7,2) 

IF (@Extension IS NULL)
BEGIN
	UPDATE  OW.tblFileManager SET FilePath=@FileServer + '\' + @strPathName
	WHERE FileID=@FileID
	
	SELECT @FileServer + '\' + @strPathName  As PathName, @FileID as FileID
END
ELSE
BEGIN
	UPDATE  OW.tblFileManager SET FilePath=@FileServer + '\' + @strPathName + @Extension
	WHERE FileID=@FileID
	SELECT @FileServer + '\' + @strPathName + @Extension As PathName, @FileID as FileID
END


COMMIT TRANSACTION

	RETURN @@ERROR
	

GO



/****** Object:  Stored Procedure OW.usp_NewKeyword    Script Date: 28-07-2004 18:18:04 ******/
GO


/****** Object:  Stored Procedure OW.usp_NewKeyword   Script Date: 6/4/2004 16:36:46 ******/

/*** INSERTS A NEW KEYWORD ***/

CREATE PROCEDURE OW.usp_NewKeyword

	(
		@designation varchar(50) = NULL,
		@global bit = 1
	)

AS
	INSERT INTO
		OW.tblKeywords	 (keydescription, [global])
	VALUES
		(@designation,  @global )
	

RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_NewListValues    Script Date: 28-07-2004 18:18:04 ******/
GO



CREATE  PROCEDURE OW.usp_NewListValues
	(
		@FormFieldKey numeric,
		@list as ntext
	)
AS

	SET XACT_ABORT ON

	BEGIN TRANSACTION

		DELETE FROM OW.tblListValues  WHERE FormFieldKey = @FormFieldKey
		IF @list is not null
		BEGIN
			INSERT OW.tblListValues Select cast(value as numeric), @FormFieldKey from OW.fnListToTable(@list, ',')
		END
		
	COMMIT TRANSACTION
	RETURN 0


GO



/****** Object:  Stored Procedure OW.usp_NewPostalCode    Script Date: 28-07-2004 18:18:04 ******/
GO



CREATE PROCEDURE OW.usp_NewPostalCode
	(
		@Code varchar(10),
		@Desc varchar(100)
	)
AS
	SET NOCOUNT ON 
	
	INSERT OW.tblpostalcode (code, Description)
	VALUES (@Code,@Desc)
	return @@ERROR
	


GO



/*** INSERTS A NEW Profile ***/

CREATE PROCEDURE OW.usp_NewProfile

	(
		@profiledesc varchar(100) = NULL,
		@NumOfDistrib numeric = 0 , 
		@NumOfStages numeric = 0 , 
		@NumOfSecundaryEntities numeric = 0 , 
		@profileType numeric = 1 
	)
AS
	INSERT INTO
		OW.tblProfiles	 (profiledesc, NumOfDistrib, NumOfStages, NumOfSecundaryEntities, profileType)
	VALUES
		(@profiledesc, @NumOfDistrib, @NumOfStages, @NumOfSecundaryEntities, @profileType)
	

RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_SetBook    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATED A  Book ***/

CREATE PROCEDURE OW.usp_SetBook
		(
		@bookID numeric,
		@Abreviation varchar(20) = NULL,
		@Designation varchar(100) = NULL,
		@Automatic bit = 0,
		@hierarchical bit = 0,
		@Duplicated bit = 0
	)

AS
	UPDATE 
		OW.tblBooks
	SET
		Abreviation=@Abreviation, Designation=@Designation, Automatic=@Automatic, hierarchical=@hierarchical, Duplicated=@Duplicated 
	WHERE
		bookID=@bookID
	
	
	RETURN @@ERROR	


GO

--usp_GetBooksWithDuplicated
CREATE PROCEDURE OW.usp_GetBooksWithDuplicated
AS 
	 SELECT  *  FROM  OW.tblBooks
	 WHERE
	  Duplicated = 1
	 ORDER BY abreviation
GO

--usp_GetBooksFieldsForDuplicated
CREATE PROCEDURE OW.usp_GetBookFieldsForDuplicated
(
	@BookID NUMERIC(18)
)
AS

	SELECT FRF.* FROM OW.tblFieldsBookDuplicated FBD INNER JOIN OW.tblFormFields FRF 
			ON (FBD.formFieldKEY = FRF.formFieldKEY)
	WHERE 
		FBD.BookID = @BookID
	ORDER BY FRF.fieldName
GO

--usp_GetBooksFieldsNotForDuplicated
CREATE PROCEDURE OW.usp_GetBookFieldsNotForDuplicated
(
	@BookID NUMERIC(18)
)
AS
	SELECT FRF.* FROM OW.tblFormFields FRF LEFT OUTER JOIN OW.tblFieldsBookConfig FBC
			ON (FRF.formFieldKEY = FBC.formFieldKEY)
	WHERE
		(FBC.BookID = @BookID OR FRF.Global = 1 OR FRF.visible = 0)
	AND
		NOT EXISTS(SELECT 1 FROM OW.tblFieldsBookDuplicated FBD
				WHERE 
					FBD.BookID = @BookID
				AND 
					(FBD.formFieldKEY = FRF.formFieldKEY)
			  )
	AND 
		FRF.formFieldKEY NOT IN (10,15,17,18)
	ORDER BY FRF.fieldName
GO

--usp_SetBooksFieldsForDuplicated
CREATE PROCEDURE OW.usp_SetBookFieldsForDuplicated
(
	@BookID NUMERIC(18),
	@FormFieldsIds VARCHAR(8000)
)
AS
	--Verify if the request book is configured for Duplicated validation
	IF (NOT EXISTS( SELECT 1 FROM OW.tblBooks WHERE BookID = @BookID AND Duplicated = 1))
		RETURN -1

	SET XACT_ABORT ON

	BEGIN TRANSACTION

	--DELETE tblFieldsBookDuplicated FOR @Book
	DELETE OW.tblFieldsBookDuplicated 
	WHERE 
		BookID = @BookID


	--INSERT tblFieldsBookDuplicated FOR @Book
	INSERT INTO OW.tblFieldsBookDuplicated 
		SELECT @BookID BookID, FRF.formFieldKEY FROM 
			OW.tblFormFields FRF LEFT OUTER JOIN OW.tblFieldsBookConfig FBC 
			ON (FRF.formFieldKEY = FBC.formFieldKEY)
		WHERE 
			(FBC.BookID = @BookID OR FRF.Global = 1 OR FRF.Visible = 0)
		AND
			FRF.formFieldKEY IN (SELECT item FROM OW.StringToTable(@FormFieldsIds,','))

	COMMIT TRANSACTION

	RETURN @@ERROR
GO


--usp_GetTempSearchEntities
CREATE PROCEDURE OW.usp_GetTempSearchEntities
(	
	@SearchTempGUID NVARCHAR(64)
)
AS
	SELECT * FROM OW.tblEntitiesTemp tmp
	WHERE 
		tmp.guid = @SearchTempGUID
GO


/****** Object:  Stored Procedure OW.usp_SetBookDocumentType    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATES A DOCUMENT TYPE OF A BOOK***/

CREATE PROCEDURE OW.usp_SetBookDocumentType
	(
		@doctypeID numeric,
		@bookid numeric
	)

AS
	/** ADDS THE DOCUMENT TYPE TH THE GIVEN BOOK **/
	INSERT INTO
		OW.tblBooksDocumentType (documentTypeID,bookid) 
	VALUES 
		(@doctypeID , @bookid)
	

	RETURN @@ERROR	


GO


/****** Object:  Stored Procedure OW.usp_SetBookKeyword    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATES A  KEYWORD OF A BOOK***/
GO
CREATE PROCEDURE OW.usp_SetBookKeyword
	(
		@keyID numeric,
		@bookid numeric
	)

AS
	/** ADDS THE KEYWORD TH THE GIVEN BOOK **/
	INSERT INTO
		OW.tblBooksKeyword (keywordID,bookid) 
	VALUES 
		(@keyid,@bookid)
	

	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetContact    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetContact
	(@EntID numeric,
	@FirstName varchar(50)='', 
	@MiddleName varchar(300)='',
	@LastName varchar(50)='', 
	@ListID numeric=null,
	@BI numeric=null, 
	@NumContribuinte numeric=null, 
	@AssociateNum numeric=null,
	@eMail varchar(300)='',
	@JobTitle varchar(100)='', 
	@Street  varchar(500)='',
	@PostalCodeID numeric=null,	
	@CountryID numeric=null,
	@Phone  varchar(20)='', 
	@Fax  varchar(20)='', 
	@Mobile  varchar(20)='',
	@DistrictID numeric=null,
	@EntityID numeric=null,
	@User varchar(900),
	@Active bit=1
	)

AS

DECLARE @UID numeric

SELECT @UID=userid from OW.tblUser where upper(userLogin)=upper(@User)

	UPDATE OW.tblEntities 
	SET FirstName=ltrim(rtrim(@FirstName)), 
		MiddleName=ltrim(rtrim(@MiddleName)),LastName=ltrim(rtrim(@LastName)), 
		ListID=@ListID, BI=@BI, NumContribuinte=@NumContribuinte, 
		AssociateNum=@AssociateNum,eMail=ltrim(rtrim(@eMail)),
		JobTitle=ltrim(rtrim(@JobTitle)), 
		Street=ltrim(rtrim(@Street)),PostalCodeID=@PostalCodeID, CountryID=@CountryID, 
		Phone=ltrim(rtrim(@Phone)), Fax=ltrim(rtrim(@Fax)), Mobile=ltrim(rtrim(@Mobile)), 
		DistrictID=@DistrictID, EntityID=@EntityID,
		active=@Active --, ModifiedBy=@UID, ModifiedDate=getdate()
	WHERE EntID=@EntID

	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_SetContactState    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetContactState
	(
		@EntID numeric,
		@State bit
	)
AS
	UPDATE OW.tblEntities
	SET Active=@State
	WHERE EntID=@EntID
	RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_SetDispatch    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetDispatch
	(
		@abreviation nvarchar(20),
		@designation nvarchar(100),
		@global bit
	)
AS
 
	INSERT INTO tblDispatch
		 (abreviation, designation, [global]) 
	VALUES 
		(@abreviation, @designation, @global)
    
	RETURN



GO

/****** Object:  Stored Procedure OW.usp_SetDispatchBook    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetDispatchBook
	(
		@bookID numeric,
		@dispatchID numeric
	)
AS
 
	INSERT INTO tblDispatchBook
		 (bookID, dispatchID) 
	VALUES 
		(@bookID, @dispatchID)
    
	RETURN



GO

/*************************** OW.usp_SetDistributionAutomaticEntity ****************************/
CREATE PROCEDURE OW.usp_SetDistributionAutomaticEntity

	(	
		@AutoDistribID numeric,
		@entID numeric
	)

AS			
	if (select count(*) from OW.tblDistributionAutomaticEntities where AutoDistribID = @AutoDistribID and EntID = @entID) = 0 
	BEGIN
		INSERT INTO tblDistributionAutomaticEntities (AutoDistribID, EntID) VALUES (@AutoDistribID,@entID)
	END

	RETURN @@ERROR
GO

/****** Object:  Stored Procedure OW.usp_SetDistributionAutomatic    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetDistributionAutomatic
(
	@fieldID	numeric,
	@fieldValue	numeric,
	@typeID		numeric,
	@distribTypeID	numeric = null,
	@dispatchID	numeric = null,	
	@wayID		varchar(20),
	@sendFiles	bit = null,
	@distribObs	nvarchar(250) = '',
	@EntIds text = null,
	@addresseeType	char(1) = null,
	@addresseeID	numeric = null
)
AS

	DECLARE @DISTRIBUTION_ELECTRONIC_MAIL  	numeric
	DECLARE @DISTRIBUTION_OTHER_WAYS 	numeric
	DECLARE @DISTRIBUTION_SAP 		numeric
	DECLARE @DISTRIBUTION_ULTIMUS 		numeric
	DECLARE @DISTRIBUTION_WORKFLOW		numeric
	DECLARE @DISTRIBUTION_SGP		numeric
	DECLARE @DISTRIBUTION_EPROCESS		numeric
	
	DECLARE @ENTITYNAME 	NVARCHAR(100)
	DECLARE @ENTITYID 	NUMERIC
	DECLARE @DistribID 	NUMERIC
	DECLARE @Pos 		NUMERIC
	
	DECLARE @AutomaticDistribID NUMERIC
	DECLARE @Value varchar(4000)
	
	SET @DISTRIBUTION_ELECTRONIC_MAIL = 1
	SET @DISTRIBUTION_OTHER_WAYS = 2
	SET @DISTRIBUTION_SAP = 3
	SET @DISTRIBUTION_ULTIMUS = 4
	SET @DISTRIBUTION_WORKFLOW = 6
	SET @DISTRIBUTION_SGP = 7
	SET @DISTRIBUTION_EPROCESS = 8

	BEGIN TRANSACTION
	
	/* ELECTRONIC MAIL */ /* WORKFLOW */ /* EPROCESS */ 
	IF (@TypeID = @DISTRIBUTION_ELECTRONIC_MAIL )  OR (@TypeID = @DISTRIBUTION_WORKFLOW)  OR (@TypeID = @DISTRIBUTION_EPROCESS)
	BEGIN
		INSERT INTO tblDistributionAutomatic
			(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs)
		VALUES 
			(@typeID, @fieldID, @fieldValue, null, null, @wayID, @sendFiles, @distribObs)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	/* SGP */ 
	IF (@TypeID = @DISTRIBUTION_SGP)
	BEGIN
		INSERT INTO tblDistributionAutomatic
			(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs, AddresseeType, AddresseeID)
		VALUES 
			(@typeID, @fieldID, @fieldValue, null, null, null, @sendFiles, @distribObs, @addresseeType, @addresseeID)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	/* OTHER WAYS */ 
	ELSE IF (@TypeID = @DISTRIBUTION_OTHER_WAYS) 
		BEGIN
			/* INSERTS THE CURRENT DISTRIBUTION */
			INSERT INTO tblDistributionAutomatic
				(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs)
			VALUES 
				(@typeID, @fieldID, @fieldValue, @distribTypeID, @dispatchID, null, null, @distribObs)
		
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 2
		END
	END
	/* SAP AND ULTIMUS */ 
	ELSE IF (@DistribTypeID = @DISTRIBUTION_SAP OR @DistribTypeID = @DISTRIBUTION_ULTIMUS ) 
	BEGIN
		INSERT INTO tblDistributionAutomatic
			(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs)
		VALUES 
			(@typeID, @fieldID, @fieldValue, null, null, @wayID, @sendFiles, @distribObs)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 3
		END
	END

	SET @AutomaticDistribID = @@IDENTITY

	/* OTHER WAYS */ 
	IF (@TypeID = @DISTRIBUTION_OTHER_WAYS AND (@EntIds is not null)) 
	BEGIN
			
		DECLARE EntsID_cursor CURSOR
		FOR SELECT value FROM OW.fnlisttotable(@EntIds,',')
	
		OPEN EntsID_cursor
		FETCH NEXT FROM EntsID_cursor INTO @Value
	
		WHILE @@FETCH_STATUS=0
		BEGIN
			
			/* INSERTS THE AUTOMATIC DISTRIBUTION OTHER WAYS ENTITIES */
			INSERT INTO OW.tblDistributionAutomaticEntities
				(AutoDistribID,EntID)
			VALUES 
				(@AutomaticDistribID, CAST(@Value AS numeric))
		
			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RETURN 2
			END

			FETCH NEXT FROM EntsID_cursor INTO @Value
		END
		CLOSE EntsID_cursor
		DEALLOCATE EntsID_cursor			
	END
	
	SELECT @AutomaticDistribID AS TMPID
	-- COMMIT TRANSACTION
	COMMIT TRANSACTION

	RETURN 0
GO

/****** Object:  Stored Procedure OW.usp_SetDistributionState    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetDistributionState

	(
		@ID numeric,
		@state numeric
	)

AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		tblRegistryDistribution
    SET 
		state = @state
	WHERE 
		ID = @ID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN 		




GO



/****** Object:  Stored Procedure OW.usp_SetDistributionTemp    Script Date: 28-07-2004 18:18:05 ******/
GO


CREATE PROCEDURE OW.usp_SetDistributionTemp
		(
		@GUID			nvarchar(250),
		@UserID			numeric,
		@RegID			numeric,
		@TypeID			numeric,		
		@DistribTypeID		numeric,
		@RadioVia		nvarchar(250),
		@ChkFile		numeric,
		@Obs			nvarchar(250),
		@Entities		nvarchar(1000),
		@Dispatch		numeric,
		@addresseeType		char(1),
		@addresseeID		numeric
		)

AS
	DECLARE @DISTRIBUTION_ELECTRONIC_MAIL  		numeric
	DECLARE @DISTRIBUTION_OTHER_WAYS 		numeric
	DECLARE @DISTRIBUTION_SAP 			numeric
	DECLARE @DISTRIBUTION_ULTIMUS 			numeric
	DECLARE @DISTRIBUTION_WORKFLOW			numeric
	DECLARE @DISTRIBUTION_SGP			numeric
	DECLARE @DISTRIBUTION_EPROCESS			numeric
	
	DECLARE @ENTITYNAME 		NVARCHAR(100)
	DECLARE @ENTITYID 		NUMERIC
	DECLARE @DistribID 		NUMERIC
	DECLARE @Pos 			NUMERIC
	
	SET @DISTRIBUTION_ELECTRONIC_MAIL = 1
	SET @DISTRIBUTION_OTHER_WAYS = 2
	SET @DISTRIBUTION_SAP = 3
	SET @DISTRIBUTION_ULTIMUS = 4
	SET @DISTRIBUTION_WORKFLOW = 6
	SET @DISTRIBUTION_SGP = 7
	SET @DISTRIBUTION_EPROCESS = 8

	BEGIN TRANSACTION
	
	/* ELECTRONIC MAIL */ /* WORKFLOW */ /* EPROCESS */ 
	IF (@TypeID = @DISTRIBUTION_ELECTRONIC_MAIL )  OR (@TypeID = @DISTRIBUTION_WORKFLOW)  OR (@TypeID = @DISTRIBUTION_EPROCESS)
	BEGIN
		INSERT INTO tblDistribTemp
			(GUID,	tipo, radioVia, chkFile, DistribDate, UserID, OLD, state, DistribObs, ConnectID, RegID)
		VALUES 
			(@GUID,  @TypeID, @RadioVia, @ChkFile, getdate(), @UserID, 0, 1, @Obs, 0, @RegID)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	/* SGP */ 
	IF (@TypeID = @DISTRIBUTION_SGP)
	BEGIN
		INSERT INTO tblDistribTemp
			(GUID,	tipo, radioVia, chkFile, DistribDate, UserID, OLD, state, DistribObs, ConnectID, RegID, AddresseeType, AddresseeID)
		VALUES 
			(@GUID,  @TypeID, @RadioVia, @ChkFile, getdate(), @UserID, 0, 1, @Obs, 0, @RegID, @addresseeType, @addresseeID)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	/* OTHER WAYS */ 
	ELSE IF (@TypeID = @DISTRIBUTION_OTHER_WAYS) 
		BEGIN
			/* INSERTS THE CURRENT DISTRIBUTION */
			INSERT INTO tblDistribTemp
				(GUID, Tipo, DistribTypeID, DistribDate, UserID, OLD, state, DistribObs, RegID, Dispatch)
			VALUES
				(@GUID, @TypeID, @DistribTypeID, getdate(), @UserID, 0, 1, @Obs, @RegID, @Dispatch)
		
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 2
		END
	END
	/* SAP AND ULTIMUS */ 
	ELSE IF (@DistribTypeID = @DISTRIBUTION_SAP OR @DistribTypeID = @DISTRIBUTION_ULTIMUS ) 
	BEGIN
		INSERT INTO tblDistribTemp
			(GUID, Tipo, DistribDate, UserID, OLD, state, RegID)
		VALUES
			 (@GUID, @TypeID, getdate(), @UserID, 0, 2, @RegID)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 3
		END
	END

	SELECT @@IDENTITY AS TMPID

	-- COMMIT TRANSACTION
	COMMIT TRANSACTION

	RETURN 0




GO

/****** Object:  Stored Procedure OW.usp_SetDistributionTempGUID    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetDistributionTempGUID
	(
	@OldGUID nvarchar(32),
	@NewGUID nvarchar(32)
	)
AS
	UPDATE OW.tblDistribTemp 
	SET GUID=@NewGUID
	WHERE GUID=@OldGUID
			
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_SetDistributionType    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetDistributionType
	(
		@DistribTypeID numeric,
		@DistribTypeDesc nvarchar(250),
		@DistribTypeCode nvarchar(50)
	)
AS
 
	INSERT INTO OW.tblDistributionType
		 (DistribTypeID,DistribTypeDesc,GetDistribCode) 
	VALUES 
		(@DistribTypeID, @DistribTypeDesc, @DistribTypeCode)
    
	RETURN @@ERROR




GO


/****** Object:  Stored Procedure OW.usp_SetDocumentType    Script Date: 28-07-2004 18:18:05 ******/
GO



/****** Object:  Stored Procedure OW.usp_SetDocumentType  Script Date: 12/4/2004 16:36:46 ******/

/*** UPDATED A  DOCUMENT TYPE ***/

CREATE PROCEDURE OW.usp_SetDocumentType
	(
		@doctypeID numeric,
		@abreviation varchar(50),
		@designation varchar(50),
		@global bit=1
	)

AS
	UPDATE 
		OW.tblDocumentType
	SET
		abreviation=@abreviation, designation=@designation, [global]=@global
	WHERE
		doctypeID=@doctypeid
	
	
	RETURN @@ERROR	


GO


/****** Object:  Stored Procedure OW.usp_SetEntityDistribution    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetEntityDistribution

	(	
		@distribID numeric,
		@entID numeric
	)

AS			
	if (select count(*) from tblDistributionEntities where DistribID = @distribID and EntID = @entID and Tmp = 1) = 0 begin

		INSERT INTO tblDistributionEntities  (DistribID, EntID, Tmp) VALUES (@distribID,@entID, 1)
	end

	IF @@ERROR <> 0
			RETURN 1
	ELSE
		 RETURN 0
GO









GO

/****** Object:  Stored Procedure OW.usp_SetEntityTemp    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetEntityTemp

	(	
		@GUID nvarchar(250),
		@EntityName nvarchar(250),
		@EntityType bit,
		@EntityContactID nvarchar(250),
		@EntityCode numeric
	)

AS
			
	INSERT INTO tblEntitiesTemp (guid, EntityName, EntityType, ContactID, EntID) VALUES (@GUID, @EntityName, @EntityType, @EntityContactID, @EntityCode)

	IF @@ERROR <> 0
			RETURN 1
	ELSE
		 RETURN 0
GO

/****** Object:  Stored Procedure OW.usp_SetHierarchicalAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetHierarchicalAccess

	@regID numeric,
	@objectID numeric,
	@objectType numeric

AS

set XACT_ABORT on

declare @bookID numeric
select @bookID = BookID from OW.tblBooks books where exists
(select 1 from OW.tblRegistry registry 
where books.BookID = registry.BookID 
and registry.regID = @regID
and books.hierarchical = 1)

-- If the Book has Hierarchical Accesses active
if (@bookID is not null)
	begin

		begin transaction

		if (@objectType = 1)
			begin

				declare @groupID numeric
				select @groupID = PrimaryGroupID from OW.tblUser where userID = @objectID

				if (@groupID is not null)
					begin
						delete from OW.tblAccessReg where UserID = @groupID and ObjectID = @regID and ObjectType = 2
						insert into OW.tblAccessReg (UserID, ObjectID, ObjectType, HierarchicalUserID) 
						values (@groupID, @regID, 2, @objectID)
					end

			end

		else

			begin

				if (@objectType = 2)
					begin

						delete from OW.tblAccessReg where UserID = @groupID and ObjectID = @regID and ObjectType = 2
						insert into OW.tblAccessReg (UserID, ObjectID, ObjectType, HierarchicalUserID) 
						values (@groupID, @regID, 2, 0)

					end

			end

		commit transaction

end

GO

/****** Object:  Stored Procedure OW.usp_SetKeyword    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATED A  KEYWORD ***/
GO
CREATE PROCEDURE OW.usp_SetKeyword
	(
		@keyID numeric,
		@designation varchar(50),
		@global bit=1
	)

AS
	UPDATE 
		OW.tblKeywords
	SET
		keydescription=@designation, [global]=@global
	WHERE
		keyID=@keyid
	
	
	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetList    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetList

	(
	 @ListID numeric,
	 @Desc varchar(100),
	 @global bit
	 )

AS
	UPDATE OW.tblEntityList SET Description=@Desc,global=@global
	WHERE  ListID=@ListID
	return @@ERROR
	RETURN




GO

/****** Object:  Stored Procedure OW.usp_SetListAccess    Script Date: 28-07-2004 18:18:05 ******/
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_SetListAccess]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_SetListAccess]
GO

CREATE PROCEDURE OW.usp_SetListAccess
	(
		@List numeric,
		@Access text
	)
AS
DECLARE @RET_VAL numeric
SET @RET_VAL = 0 -- No ERROR

DECLARE @pos int,
@textpos  int,
@chunklen smallint,
@str      varchar(8000),
@tmpstr   varchar(8000),
@leftover varchar(8000),
@posInsert int,
@posInsertOld int,
@v1 numeric,
@v2 numeric,
@v3 numeric

-- Start Transaction
BEGIN TRANSACTION SetListAccessTRANS
	
-- Delete old list access

DELETE FROM OW.tblEntityListAccess
WHERE ObjectParentID=@List

	IF (@@ERROR <> 0) 
	BEGIN
		SET @RET_VAL=@@ERROR
		GOTO OnError
	END

      SET @textpos = 1
      SET @leftover = ''
      WHILE @textpos <= datalength(@Access) / 2
      BEGIN
         SET @chunklen = 8000 - datalength(@leftover) / 2
         SET @tmpstr = ltrim(@leftover + substring(@Access, @textpos, @chunklen))
         SET @textpos = @textpos + @chunklen

         SET @pos = charindex(',', @tmpstr)
         WHILE @pos > 0
         BEGIN
            SET @str = substring(@tmpstr, 1, @pos - 1)
	    -- split to get values
	    SET @posInsertOld=charindex('|', @str)
	    SET @v1 = convert(numeric,substring(@str, 1, @posInsertOld - 1))
	    SET @posInsertOld=@posInsertOld+1
	    SET @posInsert=charindex('|', @str,@posInsertOld)
	    SET @v2 = convert(numeric,substring(@str, @posInsertOld, (@posInsert - @posInsertOld)))
	    SET @posInsert=@posInsert+1
	    SET @v3 = convert(numeric,substring(@str, @posInsert, len(@str)))
	    
	    INSERT INTO OW.tblEntityListAccess (ObjectID, ObjectParentID,AccessType, ObjectType )
	    VALUES (@v1,@List,@v3,@v2)
		IF (@@ERROR <> 0) 
		BEGIN
			SET @RET_VAL=@@ERROR
			GOTO OnError
		END
            SET @tmpstr = ltrim(substring(@tmpstr, @pos + 1, len(@tmpstr)))
            SET @pos = charindex(',', @tmpstr)
         END

         SET @leftover = @tmpstr
      END

      IF ltrim(rtrim(@leftover)) <> ''
      BEGIN
         --INSERT @tbl (number) VALUES(convert(int, @leftover))
	    -- split to get values
	    SET @posInsertOld=charindex('|', @leftover)
	    SET @v1 = convert(numeric,substring(@leftover, 1, @posInsertOld - 1))
	    SET @posInsertOld=@posInsertOld+1
	    SET @posInsert=charindex('|', @leftover,@posInsertOld)
	    SET @v2 = convert(numeric,substring(@leftover, @posInsertOld, (@posInsert - @posInsertOld)))
	    SET @posInsert=@posInsert+1
	    SET @v3 = convert(numeric,substring(@leftover, @posInsert, len(@leftover)))
	    
	    INSERT INTO OW.tblEntityListAccess (ObjectID, ObjectParentID,AccessType, ObjectType )
	    VALUES (@v1,@List,@v3,@v2)
		IF (@@ERROR <> 0) 
		BEGIN
			SET @RET_VAL=@@ERROR
			GOTO OnError
		END

      END

COMMIT TRANSACTION SetListAccessTRANS
goto OnExit
	
OnError:
-- rollback
ROLLBACK TRANSACTION SetListAccessTRANS

OnExit:
RETURN @RET_VAL





GO

/****** Object:  Stored Procedure OW.usp_SetListOptionsValues    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetListOptionsValues
(
		@ID numeric,
		@Description varchar(50) = NULL
		
	)

AS
	UPDATE 
		OW.tblListOptionsValues
	SET
		Description=@Description
	WHERE
		ListID=@ID
	
	
	RETURN @@ERROR	



GO

/****** Object:  Stored Procedure OW.usp_SetMoreEnitiesTempGUID    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetMoreEnitiesTempGUID
	(
	@OldGUID nvarchar(32),
	@NewGUID nvarchar(32)
	)
AS
	UPDATE OW.tblEntitiesTemp 
	SET guid=@NewGUID
	WHERE guid=@OldGUID
		
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_SetMoreEntitiesTempGUID    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetMoreEntitiesTempGUID
	(
	@OldGUID nvarchar(32),
	@NewGUID nvarchar(32)
	)
AS
	UPDATE 
		OW.tblEntitiesTemp 
	SET 
		guid=@NewGUID
	WHERE 
		guid=@OldGUID
		
	
	IF (@@ERROR <> 0)
	BEGIN
		RETURN @@ERROR
	END
	
	RETURN 0





GO

/****** Object:  Stored Procedure OW.usp_SetPostalCode    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetPostalCode
	(
		@Code varchar(10),
		@Desc varchar(100),
		@ID numeric
	)
AS
	SET NOCOUNT ON 
	UPDATE OW.tblPostalCode SET Code=@Code, Description=@Desc
	WHERE PostalCodeID=@ID
	return @@ERROR
	


GO



/****** Object:  Stored Procedure OW.usp_SetProfile    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetProfile
	(
		@profileID numeric,
		@profiledesc varchar(100) = NULL,
		@NumOfDistrib numeric = 0 , 
		@NumOfStages numeric = 0 , 
		@NumOfSecundaryEntities numeric = 0 , 
		@profileType numeric = 1
	)

AS
	UPDATE 
		OW.tblProfiles
	SET
		profiledesc=@profiledesc, NumOfDistrib=@NumOfDistrib, NumOfStages=@NumOfStages, NumOfSecundaryEntities=@NumOfSecundaryEntities, profileType=@profileType
	WHERE
		profileID=@profileID
	
	
	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetProfilesField    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetProfilesField
	(
		@ProfileID numeric, 
		@FormfieldKey numeric, 
		@FormfieldOrder numeric, 
		@FieldMaxChars numeric  
	)

AS
	/** ADDS THE FIELD TO THE GIVEN PROFILE **/
	INSERT INTO
		OW.tblProfilesFields (ProfileID, FormfieldKey, FormfieldOrder, FieldMaxChars) 
	VALUES 
		(@ProfileID, @formfieldkey, @FormfieldOrder, @FieldMaxChars) 
	

	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetRegistryAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetRegistryAccess

	@regID numeric,
	@userIDList text,
	@userTypeList text,
	@hierarchicalUserIDList text

AS

set XACT_ABORT on

begin transaction

declare @tmp table (RowID numeric, UserID numeric, ObjectID numeric, ObjectType smallint, HierarchicalUserID numeric)

insert @tmp (RowID, UserID) select listpos, value from OW.fnListToTable(@userIDList, ',')
update @tmp set ObjectType = value from OW.fnListToTable(@userTypeList, ',') where RowID = listpos
update @tmp set HierarchicalUserID = value from OW.fnListToTable(@hierarchicalUserIDList, ',') where RowID = listpos
update @tmp set ObjectID = @regID

delete from OW.tblAccessReg where ObjectID = @regID
insert OW.tblAccessReg select UserID, ObjectID, ObjectType, HierarchicalUserID from @tmp

commit transaction

GO

/****** Object:  Stored Procedure OW.usp_SetRegistryHierarchicalAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetRegistryHierarchicalAccess

	@userID numeric,
	@groupID numeric

AS

update OW.tblAccessReg set UserID = @groupID where HierarchicalUserID = @userID


GO

/****** Object:  Stored Procedure OW.usp_SetRegistryIntegration    Script Date: 28-07-2004 18:18:05 ******/
GO

/* Set the integration with the registry  AND sets the state to sucssess
	RECEIVES   :	connectid -> Mail ID, distribID -> Distribution ID
	RETURNS    :
*/
GO
CREATE PROCEDURE OW.usp_SetRegistryIntegration

	(
		@distribID numeric,
		@connectID numeric
	)

AS
	UPDATE 
		OW.tblRegistryDistribution
	SET
		OW.tblRegistryDistribution.connectid = @connectID
	WHERE
		OW.tblRegistryDistribution.ID = @distribID
	RETURN 


GO

/****** Object:  Stored Procedure OW.usp_SetRegistryRestrictAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetRegistryRestrictAccess

	@newUserID numeric

AS

set xact_abort on

begin transaction

-- Change Hierarchical Access to Restrict
declare cursorAccessReg cursor 
for select * from OW.tblAccessReg where hierarchicalUserID=@newUserID

declare @userID numeric
declare @objectID numeric
declare @objectType smallint
declare @hierarchicalUserID numeric 

open cursorAccessReg
fetch next from cursorAccessReg into @userID, @objectID, @objectType, @hierarchicalUserID  

while @@fetch_status = 0
begin
	-- Is Restrict Access already defined?
	if ((select count(*) from OW.tblAccessReg where UserID = @userID and ObjectID = @objectID and ObjectType = @objectType and hierarchicalUserID = 0) > 0)
	begin
		-- Delete Hierarchical Access
		delete from OW.tblAccessReg where UserID = @userID and ObjectID = @objectID 
		and ObjectType = @objectType and hierarchicalUserID = @hierarchicalUserID
	end
	else
	begin
		-- Convert to Restrict Access
		update OW.tblAccessReg set hierarchicalUserID = 0 
		where UserID = @userID and ObjectID = @objectID 
		and ObjectType = @objectType and hierarchicalUserID = @hierarchicalUserID
	end

	fetch next from cursorAccessReg into @userID, @objectID, @objectType, @hierarchicalUserID
end

close cursorAccessReg
deallocate cursorAccessReg

commit transaction

GO

/****** Object:  Stored Procedure OW.usp_SetTextSignature    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetTextSignature
	(
		@Login varchar(900),
		@TextSignature varchar(300)
	)
AS
	SET NOCOUNT ON 
	UPDATE OW.tbluser
	SET TextSignature=@TextSignature
	WHERE userlogin=@Login
	return @@ERROR




GO

/****** Object:  Stored Procedure OW.usp_SetUserPersistence    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetUserPersistence

	(
		@UserID numeric,
		@formFieldKEY numeric,
		@fieldValue varchar(4000),
		@fieldValue2 varchar(4000)
	)
AS
	
	INSERT INTO OW.tblUserPersistence (
		UserID,
		formFieldKEY,
		fieldValue, 
		fieldValue2) 
	VALUES (
		@UserID,
		@formFieldKEY,
		@fieldValue,
		@fieldValue2)
		
	RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_SetUserPersistenceAdmin    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetUserPersistenceAdmin

	(
		@UserID numeric,
		@formFieldKEY numeric
	)
AS
	BEGIN TRANSACTION
	
	DELETE FROM OW.tblUserPersistenceConfig
	WHERE UserID=@UserID
	
	IF @@ERROR<>0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END
	
	INSERT INTO OW.tblUserPersistenceConfig (UserID,formFieldKEY)
	VALUES (@UserID,@formFieldKEY) 

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION
		END
		
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_SetUserPrimaryGroup    Script Date: 28-07-2004 18:18:05 ******/
GO
/*** SETS A USER PRIMARY GROUP ***/
GO
CREATE PROCEDURE OW.usp_SetUserPrimaryGroup
	(
		@userID numeric,
		@groupID numeric
	)
AS
 
	UPDATE 
		OW.tblUser
	SET 
		PrimaryGroupID = @groupID
	WHERE 
		userID = @userID
    
	RETURN @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_UpdateDispatch    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_UpdateDispatch
	(
		@DispatchID	numeric,
		@abreviation	nvarchar(20),
		@designation	nvarchar(100),
		@global bit
	)

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDispatch
	SET 
		abreviation=@abreviation, designation=@designation, [global]=@global
	WHERE
		dispatchID=@dispatchID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave



GO

/****** Object:  Stored Procedure OW.usp_UpdateEMailDistribution    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_UpdateEMailDistribution

	(
		@TmpID numeric,
		@Obs nvarchar(250)	
	)

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistribTemp
	SET 
		distribobs = @Obs 
	WHERE
		tmpID=@TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave





GO

/****** Object:  Stored Procedure OW.usp_UpdateEMailDistributionAutomatic    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_UpdateEMailDistributionAutomatic

	@TmpID numeric,
	@Obs nvarchar(250)	

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistributionAutomatic
	SET 
		distribobs = @Obs 
	WHERE
		AutoDistribID = @TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave
GO
/****** Object:  Stored Procedure OW.usp_UpdateOWDistribution    Script Date: 28-07-2004 18:18:06 ******/
GO
CREATE PROCEDURE OW.usp_UpdateOWDistribution
	(
		@TmpID				numeric,
		@Obs					nvarchar(250)	,
		@DistribTypeID	numeric,
		@Dispatch			numeric
	)

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistribTemp
	SET 
		distribobs = @Obs, DistribTypeID= @DistribTypeID,  Dispatch=@Dispatch
	WHERE
		tmpID=@TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave





GO

/************************ OW.usp_DeleteDistributionAutomaticEntity **********************************/
CREATE PROCEDURE OW.usp_DeleteDistributionAutomaticEntity
	(
		@AutoDistribID NUMERIC,
		@entid NUMERIC
	)
AS
	DELETE 	FROM OW.tblDistributionAutomaticEntities
	WHERE (AutoDistribID = @AutoDistribID) AND (entID = @entid)

	RETURN @@Error
GO


/****** Object:  Stored Procedure OW.usp_UpdateOWDistributionAutomatic    Script Date: 28-07-2004 18:18:06 ******/
GO

CREATE PROCEDURE OW.usp_UpdateOWDistributionAutomatic
	
	@TmpID			numeric,
	@Obs			nvarchar(250),
	@DistribTypeID	numeric,
	@Dispatch		numeric

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistributionAutomatic
	SET 
		DistribObs = @Obs, 
		DistribTypeID = @DistribTypeID, 
		DispatchID = @Dispatch
	WHERE
		AutoDistribID = @TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave

GO












CREATE    PROCEDURE OW.usp_GetProfilesFieldsByProfileId
	(
	@profileID numeric
	)
AS
SELECT 
	OW.tblProfilesFields.ProfileId, 
	OW.tblFields.FieldId as FormFieldKey, 
	OW.tblProfilesFields.FormFieldOrder, 
        OW.tblProfilesFields.FieldMaxChars, 
	OW.tblFields.Description As fieldName
FROM    
	OW.tblFields LEFT OUTER JOIN
        OW.tblProfilesFields ON OW.tblFields.FieldId = OW.tblProfilesFields.FormFieldKey AND 
        OW.tblProfilesFields.ProfileId = @profileID 
	order by OW.tblProfilesFields.formFieldOrder

Return @@ERROR

GO

/* Users */
Create PROCEDURE OW.usp_GetUser
(
	@userID numeric(18,0) = NULL,
	@userLogin varchar(900) = NULL,
	@userDesc varchar(300) = NULL,
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL)
AS

IF (@userID is not null)
BEGIN
	SELECT *
	FROM OW.tblUser
	WHERE userID = @userID
	ORDER BY userLogin
END
ELSE
BEGIN
	SELECT *
	FROM OW.tblUser
	WHERE (LOWER(userlogin) = LOWER(@UserLogin) OR @UserLogin is null)
	AND (LOWER(userDesc) = LOWER(@userDesc) OR @userDesc is null)
	AND (LOWER(userMail) = LOWER(@userMail) OR @userMail is null)
	AND (userActive = @userActive OR @userActive is null)
	AND (LOWER(TextSignature) = LOWER(@TextSignature) OR @TextSignature is null)
	AND (PrimaryGroupID = @PrimaryGroupID OR @PrimaryGroupID is null)
	ORDER BY userLogin
END	
RETURN @@ERROR



GO

CREATE PROCEDURE OW.usp_GetProduct
AS
	select ObjectTypeID, productName from OW.tblProduct order by productId
	
	RETURN @@ERROR
GO


CREATE PROCEDURE OW.usp_NewUser
(
	@userID numeric(18,0) = NULL output,
	@userLogin varchar(900),
	@userDesc varchar(300),
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL
)
AS
	INSERT
	INTO OW.tblUser
	(
		[userLogin],
		[userDesc],
		[userMail],
		[userActive],
		[TextSignature],
		[PrimaryGroupID]
	)
	VALUES
	(
		@userLogin,
		@userDesc,
		@userMail,
		@userActive,
		@TextSignature,
		@PrimaryGroupID
	)
	

	SELECT @userID = SCOPE_IDENTITY()

	RETURN @@ERROR

GO


CREATE PROCEDURE OW.usp_DeleteUser
	(
		@userID numeric
	)
AS
	DELETE FROM OW.tblUser
	WHERE userID = @userID
	RETURN @@ERROR
GO


CREATE PROCEDURE OW.usp_SetUser
(
	@userID numeric(18,0),
	@userLogin varchar(900) = null,
	@userDesc varchar(300) = null,
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL
)
AS
	UPDATE OW.tblUser
	SET
		userLogin = case when @userLogin is null then userLogin else @userLogin end,
		userDesc = case when @userDesc is null then userDesc else @userDesc end,
		userMail = case when @userMail is null then userMail else @userMail end,
		userActive = case when @userActive is null then userActive else @userActive end,
		TextSignature = case when @TextSignature is null then TextSignature else @TextSignature end,
		PrimaryGroupID = case when @PrimaryGroupID is null then PrimaryGroupID else @PrimaryGroupID end
	WHERE
		userID = @userID
	

	RETURN @@ERROR

GO
/************************** GetFormFieldIdentifier *****************************/
GO

CREATE PROCEDURE OW.GetFormFieldIdentifier
	(
		@FieldName nvarchar(50)
	)
AS
		SELECT formfieldkey
		FROM OW.tblformfields f 
		WHERE f.[fieldName] = @FieldName
		ORDER BY f.fieldName	
		
RETURN @@ERROR

GO

CREATE PROCEDURE OW.usp_GetUsersByGroupID(
	@GroupID as numeric
)
AS

/* Retorna os usuários que pertencem ao grupo id
 *
 */

SELECT     OW.tblGroupsUsers.GroupID, OW.tblUser.*
FROM       OW.tblGroupsUsers INNER JOIN
           OW.tblUser ON 
	   OW.tblGroupsUsers.UserID = OW.tblUser.userID AND 
	   OW.tblGroupsUsers.GroupID = @GroupID ORDER BY OW.tblUser.userDesc 


GO






/****************************************************************************************************************/
/* Procedures Archive */ 
/****************************************************************************************************************/
CREATE PROCEDURE [OW].usp_DeleteRequest
(
	@RequestID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequest]
	WHERE
		[RequestID] = @RequestID
	SET @Err = @@Error

	RETURN @Err
END


GO


/****** Object:  Stored Procedure OW.usp_DeleteRequestDestructionType    Script Date: 23-11-2005 14:06:13 ******/

CREATE PROCEDURE [OW].usp_DeleteRequestDestructionType
(
	@DestructionID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequestDestructionType]
	WHERE
		[DestructionID] = @DestructionID
	SET @Err = @@Error

	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_DeleteRequestMotionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_DeleteRequestMotionType
(
	@MotionID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequestMotionType]
	WHERE
		[MotionID] = @MotionID
	SET @Err = @@Error

	RETURN @Err
END


GO


/****** Object:  Stored Procedure OW.usp_DeleteRequestMotiveConsult    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_DeleteRequestMotiveConsult
(
	@MotiveID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequestMotiveConsult]
	WHERE
		[MotiveID] = @MotiveID
	SET @Err = @@Error

	RETURN @Err
END


GO


/****** Object:  Stored Procedure OW.usp_DeleteRequestType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_DeleteRequestType
(
	@RequestID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequestType]
	WHERE
		[RequestID] = @RequestID
	SET @Err = @@Error

	RETURN @Err
END


GO


/****** Object:  Stored Procedure OW.usp_GetAllArchFundo    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetAllArchFundo

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	
	-- Obtém o Fundo
	select FundoID, [Global], 
		Code as Fundo, null as Seccao, null as SubSeccao, [Description], 
		[Description] as FundoDescription, null as SeccaoDescription, null as SubSeccaoDescription,
		null as ParentID, [Level]
	from OW.tblArchFundo
	where level = 0
	
	union
	
	-- Obtém a Secção
	select a1.FundoID, a1.Global,
		a2.Code as Fundo, a1.Code as Seccao, null as SubSeccao, a1.Description, 
		a2.Description as FundoDescription, a1.Description as SeccaoDescription, null as SubSeccaoDescription,
		a1.ParentID, a1.Level
	from OW.tblArchFundo a1
	inner join OW.tblArchFundo a2 on a2.FundoID = a1.ParentId
	where a1.level = 1
	
	union
	
	-- Obtém a Sub-Secção
	select a1.FundoID, a1.Global,
		a3.Code as Fundo, a2.Code as Seccao, a1.Code as SubSeccao, a1.Description, 
		a3.Description as FundoDescription, a2.Description as SeccaoDescription, a1.Description as SubSeccaoDescription,
		a1.ParentID, a1.Level
	from OW.tblArchFundo a1
	inner join OW.tblArchFundo a2 on a2.FundoID = a1.ParentId
	inner join OW.tblArchFundo a3 on a3.FundoID = a2.ParentId
	where a1.level = 2
	
	order by Fundo, Seccao, SubSeccao asc


	SET @Err = @@Error

	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetAllArchSerie    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetAllArchSerie


as
begin
	set nocount on
	declare @Err int	
	
	-- Obtém as séries
	select SerieId, [Global], Code as Serie, null as SubSerie, [Description],
		[Description] as SerieDescription, null as SubSerieDescription, 
		ActiveYears, ActiveMonths, ActiveFixed, SemiActiveYears, SemiActiveMonths, SemiActiveFixed, ReturnMonths,
		ReturnDays, ReturnFixed, DestinationID, DestinationFixed, null as ParentID
	from OW.tblArchSerie
	where level = 0
	--and serieId not in (select distinct parentId from OW.tblArchSerie where parentId is not null)

	union

	-- Obtém as séries com as respectivas sub-séries
	select a1.SerieId, a1.Global, a2.Code as Serie, a1.Code as SubSerie, a1.Description,
		a2.Description as SerieDescription, a1.Description as SubSerieDescription, 
		a1.ActiveYears, a1.ActiveMonths, a1.ActiveFixed, a1.SemiActiveYears, a1.SemiActiveMonths, a1.SemiActiveFixed, 
		a1.ReturnMonths, a1.ReturnDays, a1.ReturnFixed, a1.DestinationID, a1.DestinationFixed, a1.ParentId as ParentID
	from OW.tblArchSerie a1
	inner join OW.tblArchSerie a2 on a2.SerieId = a1.ParentId
	where a1.level = 1

	order by Serie, SubSerie asc


	set @Err = @@Error

	return @Err
end

GO


/****** Object:  Stored Procedure OW.usp_GetArchFundoByCode    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetArchFundoByCode
(
	@Code varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	SELECT
		[FundoID],
		[Level],
		[ParentID],
		[Code],
		[Description],
		[Global]
	FROM [OW].[tblArchFundo]
	WHERE
		[Code] = @Code

	SET @Err = @@Error
	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetArchPackageUnit    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetArchPackageUnit
(
	@PackageUnitID decimal(18,0) = null,
	@Description varchar(250) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	IF 
	(
	 	@PackageUnitID is null
	  AND 
	@Description is null
	)
	BEGIN
		SELECT 
		
			PackageUnitID,Description
		FROM [OW].[tblArchPackageUnit]	
	END
	ELSE
	BEGIN
		SELECT
          [PackageUnitID],
          [Description]
		FROM [OW].[tblArchPackageUnit]
		WHERE
			([PackageUnitID] = isnull(@PackageUnitID,[PackageUnitID])) AND
			([Description] like isnull(@Description,[Description]))

	END
	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  Stored Procedure OW.usp_GetArchSerieByCode    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetArchSerieByCode
(
	@Code varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	SELECT
	          [SerieID],
	          [Level],
	          [ParentID],
	          [Code],
	          [Description],
	          [Global],
	          [ActiveYears],
	          [ActiveMonths],
	          [ActiveFixed],
	          [SemiActiveYears],
	          [SemiActiveMonths],
	          [SemiActiveFixed],
	          [ReturnMonths],
	          [ReturnDays],
	          [ReturnFixed],
	          [DestinationID],
	          [DestinationFixed]
	FROM [OW].[tblArchSerie]
	WHERE
		[Code] = @Code

	SET @Err = @@Error

	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetArchSerieByRegistry    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetArchSerieByRegistry
(
	@Code varchar(50) = null,
	@Description varchar(250) = null
	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	select SerieId, [Global], Code as Serie, null as SubSerie, [Description],
		[Description] as SerieDescription, null as SubSerieDescription, 
		ActiveYears, ActiveMonths, ActiveFixed, SemiActiveYears, SemiActiveMonths, SemiActiveFixed, ReturnMonths,
		ReturnDays, ReturnFixed, DestinationID, DestinationFixed, null as ParentID
	FROM [OW].[tblArchSerie]
	WHERE
		(([Code] like @Code) OR
		([Description] like @Description)) AND
		([Global] = 1) 
	
	SET @Err = @@Error

	RETURN @Err
END

GO
/****** Object:  Stored Procedure OW.usp_GetArchiveParent    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetArchiveParent
(
	@ArchiveParentID decimal(18,0) = null,
	@Description varchar(250) = null,
	@Size decimal(18,0) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	IF (@ArchiveParentID is null AND @Description is null  AND @Size is null)
	BEGIN
		SELECT ArchiveParentID, [Description], [Size]
		FROM [OW].[tblArchiveParent]	
	END
	ELSE
	BEGIN
		SELECT [ArchiveParentID], [Description], [Size]
		FROM [OW].[tblArchiveParent]
		WHERE
			([ArchiveParentID] = isnull(@ArchiveParentID,[ArchiveParentID])) AND
			([Description] like isnull(@Description,[Description])) AND
			([Size] = isnull(@Size,[Size]))

	END
	SET @Err = @@Error

	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetOWArchiveConfig    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE OW.usp_GetOWArchiveConfig

AS
	SELECT TOP 1 * FROM OW.tblOWArchiveConfig
	

GO
/****** Object:  Stored Procedure OW.usp_GetRequest    Script Date: 23-11-2005 14:06:13 ******/
CREATE  PROCEDURE [OW].usp_GetRequest
(
	@RequestID numeric(18,0) = null,
	@Number numeric(18,0) = null,
	@Year numeric(18,0) = null,
	@RequestDate datetime = null,
	@EntID numeric(18,0) = null,
	@Reference varchar(50) = null,
	@ReferenceYear numeric(18,0) = null,
	@MotionID numeric(18,0) = null,
	@MotiveID numeric(18,0) = null,
	@RequestTypeID numeric(18,0) = null,
	@Origin int = null,
	@LimitDate datetime = null,
	@DevolutionDate datetime = null,
	@State int = null,
	@Observation varchar(500) = null,
	@Subject varchar(250) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	IF 
	(
 	@RequestID is null
	  AND 
	@Number is null
	  AND 
	@Year is null
	  AND 
	@RequestDate is null
	  AND 
	@EntID is null
	  AND 
	@Reference is null
	  AND 
	@ReferenceYear is null
	  AND 
	@MotionID is null
	  AND 
	@MotiveID is null
	  AND 
	@RequestTypeID is null
	  AND 
	@Origin is null
	  AND 
	@LimitDate is null
	  AND 
	@DevolutionDate is null
	  AND 
	@State is null
	  AND 
	@Observation is null
	  AND 
	@Subject is null
	)
	BEGIN
		SELECT
		      OW.tblRequest.RequestID, OW.tblRequest.Number, OW.tblRequest.[Year], 
		      '<a href="ViewRequest.aspx?RequestId=' + CAST(OW.tblRequest.[RequestID] AS varchar(5)) + '">' + 
		      CAST(OW.tblRequest.[Year] AS varchar(5)) + '/' + CAST(OW.tblRequest.Number AS varchar(5)) + 
		      '</a>'	
		      AS YearNumber,
		      OW.tblRequest.RequestDate, OW.tblRequest.EntID, OW.tblRequest.Reference, 
		      OW.tblRequest.ReferenceYear, OW.tblRequest.MotionID, OW.tblRequest.MotiveID, 
		      OW.tblRequest.RequestTypeID, OW.tblRequest.Origin, OW.tblRequest.LimitDate, 
		      OW.tblRequest.DevolutionDate, OW.tblRequest.State, OW.tblRequest.Observation, 
		      OW.tblRequest.CreatedByID, OW.tblRequest.CreatedDate, OW.tblRequest.ModifiedByID, 
		      OW.tblRequest.ModifiedDate, OW.tblRequest.Subject, OW.tblUser.userDesc, 
		      OW.tblUser.userLogin
		FROM  
		      OW.tblRequest INNER JOIN
                      OW.tblUser ON OW.tblRequest.EntID = OW.tblUser.userID
	END
	ELSE
	BEGIN
		
		SELECT
			OW.tblRequest.RequestID, OW.tblRequest.Number, OW.tblRequest.[Year], 
			'<a href="ViewRequest.aspx?RequestId=' + CAST(OW.tblRequest.[RequestID] AS varchar(5)) + '">' + 
			CAST(OW.tblRequest.[Year] AS varchar(5)) + '/' + CAST(OW.tblRequest.Number AS varchar(5)) + 
		      	'</a>'	
		      	AS YearNumber,
			OW.tblRequest.RequestDate, OW.tblRequest.EntID, OW.tblRequest.Reference, 
		      	OW.tblRequest.ReferenceYear, OW.tblRequest.MotionID, OW.tblRequest.MotiveID, 
		      	OW.tblRequest.RequestTypeID, OW.tblRequest.Origin, OW.tblRequest.LimitDate, 
		      	OW.tblRequest.DevolutionDate, OW.tblRequest.State, OW.tblRequest.Observation, 
		      	OW.tblRequest.CreatedByID, OW.tblRequest.CreatedDate, OW.tblRequest.ModifiedByID, 
		      	OW.tblRequest.ModifiedDate, OW.tblRequest.Subject, OW.tblUser.userDesc, 
		      	OW.tblUser.userLogin
		FROM  
		      OW.tblRequest INNER JOIN
                      OW.tblUser ON OW.tblRequest.EntID = OW.tblUser.userID

		WHERE
			--([RequestID] = isnull(@RequestID,[RequestID])) AND
			([Number] = isnull(@Number,[Number])) AND
			([Year] = isnull(@Year,[Year])) AND
			([RequestDate] = isnull(@RequestDate,[RequestDate])) AND
			([EntID] = isnull(@EntID,[EntID])) AND
			([Reference] like isnull(@Reference,[Reference])) AND
			([ReferenceYear] = isnull(@ReferenceYear,[ReferenceYear])) AND
			([MotionID] = isnull(@MotionID,[MotionID])) AND
			([MotiveID] = isnull(@MotiveID,[MotiveID])) AND
			([RequestTypeID] = isnull(@RequestTypeID,[RequestTypeID])) AND
			([Origin] = isnull(@Origin,[Origin])) AND
			([LimitDate] = isnull(@LimitDate,[LimitDate])) AND
			([DevolutionDate] = isnull(@DevolutionDate,[DevolutionDate])) AND
			([State] = isnull(@State,[State])) AND
			([Observation] like isnull(@Observation,[Observation])) AND
			([Subject] like isnull(@Subject,[Subject]))

	END
	SET @Err = @@Error

	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetRequestByID    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetRequestByID
(
	@IdsList varchar(8000)
)
AS
BEGIN
	SET NOCOUNT ON
	SET DATEFORMAT dmy
	DECLARE @Err int	
		SET @Err = @@Error

	SELECT     
		OW.tblRequest.*, OW.tblRequestMotionType.Description AS MotionType, OW.tblRequestMotiveConsult.Description AS MotiveConsult,
        OW.tblRequestType.Description AS RequestType,
		OW.tblEntities.Name AS EntityName,
        '<a href=ViewRequest.aspx?RequestId=' + CAST(OW.tblRequest.RequestID AS varchar(5)) + '>' + CAST(OW.tblRequest.[Year] AS varchar(5)) + '/' + CAST(OW.tblRequest.Number AS varchar(5)) + '</a>' AS YearNumber, 
        OW.tblRegistry.[year] AS RegYear,
		OW.tblRegistry.number AS RegNumber, OW.tblRequest.ModifiedDate , OW.tblRequest.Subject
	FROM         
		OW.tblRequest INNER JOIN
        OW.tblRequestMotionType ON OW.tblRequest.MotionID = OW.tblRequestMotionType.MotionID INNER JOIN
        OW.tblRequestMotiveConsult ON OW.tblRequest.MotiveID = OW.tblRequestMotiveConsult.MotiveID INNER JOIN
        OW.tblRequestType ON OW.tblRequest.RequestTypeID = OW.tblRequestType.RequestID INNER JOIN
        OW.tblEntities ON OW.tblEntities.EntID = OW.tblRequest.EntID LEFT OUTER JOIN
        OW.tblRegistry ON OW.tblRequest.RegID = OW.tblRegistry.regid 
	WHERE 
		OW.tblRequest.RequestID in (SELECT Item FROM OW.StringToTable(@IdsList,','))


	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_DevolutionRequest    Script Date: 24-03-2006 15:40:10 ******/

CREATE  PROCEDURE OW.usp_DevolutionRequest
(
	@RequestID as numeric(18,0),
	@DevolutionDate datetime,
	@State int,
	@ModifiedByID int = NULL	
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int
	--SET DATEFORMAT dmy
	DECLARE @NUM INT

	UPDATE [OW].tblRequest 
	SET DevolutionDate = @DevolutionDate, State = @State, ModifiedByID = @ModifiedByID
	WHERE RequestID = @RequestID

	SET @Err = @@Error
	SELECT @RequestID = SCOPE_IDENTITY()
	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetGuide    Script Date: 24-03-2006 15:40:10 ******/

CREATE   PROCEDURE OW.usp_GetGuide
(
	@RequestID numeric(18,0) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	SELECT 	TOP 1 
		OW.tblRequest.RequestID, OW.tblEntities.EntID,OW.tblRequest.Origin,
		OW.tblRequest.Number, OW.tblRequest.Year,
		OW.tblEntities.Name AS EntityName, 
		OW.tblEntities.BI, OW.tblEntities.NumContribuinte, OW.tblEntities.Street, OW.tblEntities.Phone, 
	        OW.tblEntities.BIEmissionDate, OW.tblEntityBIArquive.Description AS BIArquive, OW.tblEntityJobPosition.Description AS Job, 
	        OW.tblCountry.Description AS ASCountry, OW.tblEntityLocation.Description AS Location, OW.tblPostalCode.Code AS PostalCode, 
	        OW.tblRequest.RequestDate, OW.tblRequest.Observation, OW.tblRequestMotiveConsult.Description AS MOtiveType
	FROM    
		OW.tblPostalCode RIGHT OUTER JOIN
	        OW.tblEntities ON OW.tblPostalCode.PostalCodeID = OW.tblEntities.PostalCodeID LEFT OUTER JOIN
	        OW.tblCountry ON OW.tblEntities.CountryID = OW.tblCountry.CountryID LEFT OUTER JOIN
	        OW.tblEntityBIArquive ON OW.tblEntities.BIArquiveID = OW.tblEntityBIArquive.BIArquiveID LEFT OUTER JOIN
	        OW.tblEntityLocation ON OW.tblEntities.LocationID = OW.tblEntityLocation.LocationID LEFT OUTER JOIN
	        OW.tblEntityJobPosition ON OW.tblEntities.JobPositionID = OW.tblEntityJobPosition.JobPositionID LEFT OUTER JOIN
	        OW.tblRequestMotiveConsult RIGHT OUTER JOIN
	        OW.tblRequest ON OW.tblRequestMotiveConsult.MotiveID = OW.tblRequest.MotiveID ON 
	        OW.tblEntities.EntID = OW.tblRequest.EntID
	WHERE
		OW.tblRequest.RequestID = @RequestID

	SET @Err = @@Error

	RETURN @Err
END

GO


/****** Object:  Stored Procedure OW.usp_GetRequestDestructionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetRequestDestructionType
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	SELECT DestructionID, Description
		FROM [OW].[tblRequestDestructionType]	
	ORDER BY Description

	SET @Err = @@Error
	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_GetRequestMotionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetRequestMotionType
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[MotionID],
		[Description]
	FROM [OW].[tblRequestMotionType]
	ORDER BY [Description]

	SET @Err = @@Error

	RETURN @Err
END


GO
/****** Object:  Stored Procedure OW.usp_GetRequestMotiveConsult    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_GetRequestMotiveConsult
(
	@MotiveID numeric(18,0) = null,
	@Description varchar(100) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[MotiveID],
		[Description]
	FROM [OW].[tblRequestMotiveConsult]
	Order BY [Description]

	SET @Err = @@Error

	RETURN @Err
END


GO
/****** Object:  Stored Procedure OW.usp_GetRequestType    Script Date: 23-11-2005 14:06:13 ******/
CREATE  PROCEDURE [OW].usp_GetRequestType
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[RequestID],
		[Description]
	FROM [OW].[tblRequestType]
	ORDER BY [Description]
	SET @Err = @@Error

	RETURN @Err
END
GO
/****** Object:  Stored Procedure OW.usp_NewArchFundo    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewArchFundo
(
	@FundoID decimal(18,0) = NULL output,
	@Level smallint,
	@ParentID decimal(18,0) = NULL,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	if @ParentID = 0 begin
		set @ParentID = null
	end

	INSERT
	INTO [OW].[tblArchFundo]
	(
		[Level],
		[ParentID],
		[Code],
		[Description],
		[Global]
	)
	VALUES
	(
		@Level,
		@ParentID,
		@Code,
		@Description,
		@Global
	)

	SET @Err = @@Error

	SELECT @FundoID = SCOPE_IDENTITY()

	RETURN @Err
END

GO
CREATE PROCEDURE [OW].usp_SetArchFundo
(
	@FundoID decimal(18,0),
	@Level smallint,
	@ParentID decimal(18,0) = NULL,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblArchFundo]
	SET
		[Level] = @Level,
		[ParentID] = @ParentID,
		[Code] = @Code,
		[Description] = @Description,
		[Global] = @Global
	WHERE
		[FundoID] = @FundoID


	SET @Err = @@Error


	RETURN @Err
END


GO

/****** Object:  Stored Procedure OW.usp_NewArchSerie    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewArchSerie
(
	@SerieID decimal(18,0) = NULL output,
	@Level smallint,
	@ParentID decimal(18,0) = NULL,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit,
	@ActiveYears int = NULL,
	@ActiveMonths int = NULL,
	@ActiveFixed bit = NULL,
	@SemiActiveYears int = NULL,
	@SemiActiveMonths int = NULL,
	@SemiActiveFixed bit = NULL,
	@ReturnMonths int = NULL,
	@ReturnDays int = NULL,
	@ReturnFixed bit = NULL,
	@DestinationID decimal(18,0) = NULL,
	@DestinationFixed bit = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	if @ParentID = 0 begin
		set @ParentID = null
	end

	INSERT
	INTO [OW].[tblArchSerie]
	(
		[Level],
		[ParentID],
		[Code],
		[Description],
		[Global],
		[ActiveYears],
		[ActiveMonths],
		[ActiveFixed],
		[SemiActiveYears],
		[SemiActiveMonths],
		[SemiActiveFixed],
		[ReturnMonths],
		[ReturnDays],
		[ReturnFixed],
		[DestinationID],
		[DestinationFixed]
	)
	VALUES
	(
		@Level,
		@ParentID,
		@Code,
		@Description,
		@Global,
		@ActiveYears,
		@ActiveMonths,
		@ActiveFixed,
		@SemiActiveYears,
		@SemiActiveMonths,
		@SemiActiveFixed,
		@ReturnMonths,
		@ReturnDays,
		@ReturnFixed,
		@DestinationID,
		@DestinationFixed
	)

	SET @Err = @@Error

	SELECT @SerieID = SCOPE_IDENTITY()

	RETURN @Err
END

GO
CREATE PROCEDURE [OW].usp_SetArchSerie
(
	@SerieID decimal(18,0),
	@Level smallint,
	@ParentID decimal(18,0) = NULL,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit,
	@ActiveYears int = NULL,
	@ActiveMonths int = NULL,
	@ActiveFixed bit = NULL,
	@SemiActiveYears int = NULL,
	@SemiActiveMonths int = NULL,
	@SemiActiveFixed bit = NULL,
	@ReturnMonths int = NULL,
	@ReturnDays int = NULL,
	@ReturnFixed bit = NULL,
	@DestinationID decimal(18,0) = NULL,
	@DestinationFixed bit = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblArchSerie]
	SET
		[Level] = @Level,
		[ParentID] = @ParentID,
		[Code] = @Code,
		[Description] = @Description,
		[Global] = @Global,
		[ActiveYears] = @ActiveYears,
		[ActiveMonths] = @ActiveMonths,
		[ActiveFixed] = @ActiveFixed,
		[SemiActiveYears] = @SemiActiveYears,
		[SemiActiveMonths] = @SemiActiveMonths,
		[SemiActiveFixed] = @SemiActiveFixed,
		[ReturnMonths] = @ReturnMonths,
		[ReturnDays] = @ReturnDays,
		[ReturnFixed] = @ReturnFixed,
		[DestinationID] = @DestinationID,
		[DestinationFixed] = @DestinationFixed
	WHERE
		[SerieID] = @SerieID


	SET @Err = @@Error


	RETURN @Err
END



GO
/****** Object:  Stored Procedure OW.usp_NewRequest    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewRequest
(
	@RequestID numeric(18,0) = NULL output,
	@Year numeric(18,0),
	@SerieID numeric(18,0) = NULL,
	@RequestDate varchar(20),
	@EntID numeric(18,0),
	@RegID numeric(18,0) = NULL,
	@Reference varchar(50) = NULL,
	@ReferenceYear numeric(18,0) = NULL,
	@MotionID numeric(18,0),
	@MotiveID numeric(18,0),
	@RequestTypeID numeric(18,0),
	@Origin int,
	@LimitDate varchar(20) = NULL,
	@DevolutionDate varchar(20) = NULL,
	@State int,
	@Observation varchar(500) = NULL,
	@Subject varchar(250) = NULL,
	@CreatedByID int

)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int
	SET DATEFORMAT dmy
	DECLARE @NUM INT
	

	SET @NUM = (SELECT ISNULL(MAX(NUMBER),0) + 1  FROM [OW].[tblRequest] WHERE [YEAR] = @Year)

	INSERT
	INTO [OW].[tblRequest]
	(
		[Number],[Year], [RequestDate], [EntID], [Reference], [ReferenceYear],
		[MotionID], [MotiveID], [RequestTypeID], [Origin], [LimitDate],
		[DevolutionDate], [State], [Observation], [Subject], [CreatedByID],[CreatedDate],
		[SerieID], [RegId]
	)
	VALUES
	(
		@Num,
		@Year,
		@RequestDate,
		@EntID,
		@Reference,
		@ReferenceYear,
		@MotionID,
		@MotiveID,
		@RequestTypeID,
		@Origin,
		@LimitDate,
		@DevolutionDate,
		@State,
		@Observation,
		@Subject,
		@CreatedByID,
		GETDATE(),
		@SerieID,
		@RegID
	)

	SET @Err = @@Error

	SELECT @RequestID = SCOPE_IDENTITY()

	RETURN @Err
END


GO



/****** Object:  Stored Procedure OW.usp_NewRequestDestructionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewRequestDestructionType
(
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblRequestDestructionType]
	(
		[Description]
	)
	VALUES
	(
		@Description
	)

	SET @Err = @@Error
	RETURN @Err
END

GO

/****** Object:  Stored Procedure OW.usp_NewRequestMotionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewRequestMotionType
(
	@MotionID numeric(18,0) = NULL output,
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblRequestMotionType]
	(
		[Description]
	)
	VALUES
	(
		@Description
	)

	SET @Err = @@Error

	SELECT @MotionID = SCOPE_IDENTITY()

	RETURN @Err
END


GO
/****** Object:  Stored Procedure OW.usp_NewRequestMotiveConsult    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewRequestMotiveConsult
(
	@MotiveID numeric(18,0) = NULL output,
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblRequestMotiveConsult]
	(
		[Description]
	)
	VALUES
	(
		@Description
	)

	SET @Err = @@Error

	SELECT @MotiveID = SCOPE_IDENTITY()

	RETURN @Err
END


GO
/****** Object:  Stored Procedure OW.usp_NewRequestType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewRequestType
(
	@RequestID numeric(18,0) = NULL output,
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblRequestType]
	(
		[Description]
	)
	VALUES
	(
		@Description
	)

	SET @Err = @@Error

	SELECT @RequestID = SCOPE_IDENTITY()

	RETURN @Err
END


GO
/****** Object:  Stored Procedure OW.usp_SetOWArchiveConfig    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE OW.usp_SetOWArchiveConfig

	(
	@DelevutionDate numeric (18),
	@Fix bit,
	@SendingGuide varchar(50),
	@DeletingGuide varchar(50),
	@RequestIn varchar(50),
	@RequestOut varchar(50),
	@EntityDescription varchar(50),
	@EntityPlace varchar(50),
	@UserID int
	)

AS
	DECLARE @EXIST int
	
	SET @EXIST = (SELECT COUNT(*) FROM OW.tblOWArchiveConfig)
	
	IF @EXIST = 0 
	BEGIN

		INSERT INTO OW.tblOWArchiveConfig
		(DelevutionDate, Fix, SendingGuide, DeletingGuide, RequestIn, RequestOut, UserID, [DATE], EntityDescription, EntityPlace ) 
		VALUES
		(@DelevutionDate, @Fix, @SendingGuide, @DeletingGuide, @RequestIn, @RequestOut, @UserID, GETDATE(), @EntityDescription, @EntityPlace)
	END
	ELSE
	BEGIN

		UPDATE OW.tblOWArchiveConfig
		SET
			DelevutionDate = @DelevutionDate,
			Fix = @Fix,
			SendingGuide = @SendingGuide, 
			DeletingGuide = @DeletingGuide, 
			RequestIn = @RequestIn,
			RequestOut =@RequestOut,
			UserID = @UserID, 
			[DATE] = GETDATE(),
			EntityDescription = @EntityDescription, 
			EntityPlace = @EntityPlace
	
	END

GO
/****** Object:  Stored Procedure OW.usp_SetRequest    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_SetRequest
(
	@RequestID numeric(18,0),
	@Number numeric(18,0),
	@Year numeric(18,0),
	@RequestDate varchar(20),
	@EntID numeric(18,0),
	@Reference varchar(50) = NULL,
	@ReferenceYear numeric(18,0) = NULL,
	@MotionID numeric(18,0),
	@MotiveID numeric(18,0),
	@RequestTypeID numeric(18,0),
	@Origin int,
	@LimitDate varchar(20) = NULL,
	@DevolutionDate varchar(20) = NULL,
	@State int,
	@Observation varchar(500) = NULL,
	@ModifiedByID int = NULL,
	@Subject varchar(250) = NULL,
	@SerieID numeric(18,0) = null,
	@RegID numeric(18,0) = NULL

)
AS
BEGIN

	SET NOCOUNT ON
	SET DATEFORMAT dmy
	DECLARE @Err int

	UPDATE [OW].[tblRequest]
	SET
		[Number] = @Number,
		[Year] = @Year,
		[RequestDate] = @RequestDate,
		[EntID] = @EntID,
		[Reference] = @Reference,
		[ReferenceYear] = @ReferenceYear,
		[MotionID] = @MotionID,
		[MotiveID] = @MotiveID,
		[RequestTypeID] = @RequestTypeID,
		[Origin] = @Origin,
		[LimitDate] = @LimitDate,
		[DevolutionDate] = @DevolutionDate,
		[State] = @State,
		[Observation] = @Observation,
		[ModifiedByID] = @ModifiedByID,
		[ModifiedDate] = GETDATE(),
		[Subject] = @Subject,
		[SerieID] = @SerieID,
		[RegId] = @RegID

	WHERE
		[RequestID] = @RequestID


	SET @Err = @@Error


	RETURN @Err
END

GO


/****** Object:  Stored Procedure OW.usp_SetRequestDestructionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_SetRequestDestructionType
(
	@DestructionID numeric(18,0),
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblRequestDestructionType]
	SET
		[Description] = @Description
	WHERE
		[DestructionID] = @DestructionID

	SET @Err = @@Error
	RETURN @Err
END

GO
/****** Object:  Stored Procedure OW.usp_SetRequestMotionType    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_SetRequestMotionType
(
	@MotionID numeric(18,0),
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblRequestMotionType]
	SET
		[Description] = @Description
	WHERE
		[MotionID] = @MotionID


	SET @Err = @@Error


	RETURN @Err
END
GO

/****** Object:  Stored Procedure OW.usp_SetRequestMotiveConsult    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_SetRequestMotiveConsult
(
	@MotiveID numeric(18,0),
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblRequestMotiveConsult]
	SET
		[Description] = @Description
	WHERE
		[MotiveID] = @MotiveID


	SET @Err = @@Error


	RETURN @Err
END


GO

/****** Object:  Stored Procedure OW.usp_SetRequestState    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_SetRequestState
AS
BEGIN
/*
  Job que deve ser executado para redefinir os estados das requisições que
  estão expiradas na data da entrega.
 */
     UPDATE [OW].[tblRequest]
     Set [state] = 3 -- 3 = Expirado
     WHERE [LimitDate] < GetDate() AND
           [DevolutionDate] IS NULL
  
  
END
GO

CREATE PROCEDURE [OW].usp_DeleteArchFundo
(
	@FundoID decimal(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchFundo]
	WHERE
		[FundoID] = @FundoID
	SET @Err = @@Error

	RETURN @Err
END
GO

CREATE PROCEDURE [OW].usp_DeleteArchSerie
(
	@SerieID decimal(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchSerie]
	WHERE
		[SerieID] = @SerieID
	SET @Err = @@Error

	RETURN @Err
END
GO

CREATE PROCEDURE [OW].usp_GetArchClassification
(
	@ClassificationID decimal(18,0) = null,
	@Level smallint = null,
	@ParentID decimal(18,0) = null,
	@Code varchar(50) = null,
	@Description varchar(250) = null,
	@Global bit = null,
	@Scope smallint = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	IF 
	(
	 	@ClassificationID is null
	  AND 
	@Level is null
	  AND 
	@ParentID is null
	  AND 
	@Code is null
	  AND 
	@Description is null
	  AND 
	@Global is null
	  AND 
	@Scope is null
	)
	BEGIN
		SELECT 

			ClassificationID
			, 
Level
			, 
ParentID
			, 
Code
			, 
Description
			, 
Global
			, 
Scope
		FROM [OW].[tblArchClassification]	
	END
	ELSE
	BEGIN
		SELECT
          [ClassificationID],
          [Level],
          [ParentID],
          [Code],
          [Description],
          [Global],
          [Scope]
		FROM [OW].[tblArchClassification]
		WHERE
			([ClassificationID] = isnull(@ClassificationID,[ClassificationID])) AND
			([Level] = isnull(@Level,[Level])) AND
			([ParentID] = isnull(@ParentID,[ParentID])) AND
			([Code] like isnull(@Code,[Code])) AND
			([Description] like isnull(@Description,[Description])) AND
			([Global] = isnull(@Global,[Global])) AND
			([Scope] = isnull(@Scope,[Scope]))

	END
	SET @Err = @@Error

	RETURN @Err
END


GO

CREATE   PROCEDURE [OW].usp_GetArchFundo
(
	@FundoID decimal(18,0) = null,
	@Level smallint = null,
	@ParentID decimal(18,0) = null,
	@Code varchar(50) = null,
	@Description varchar(250) = null,
	@Global bit = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	IF 
	(
	 	@FundoID is null
	  AND 
	@Level is null
	  AND 
	@ParentID is null
	  AND 
	@Code is null
	  AND 
	@Description is null
	  AND 
	@Global is null
	)
	BEGIN
		SELECT 

			FundoID
			, 
Level
			, 
ParentID
			, 
Code
			, 
Description
			, 
Global
		FROM [OW].[tblArchFundo]	
	END

	ELSE IF (( @FundoID is null AND @Level is null AND @ParentID is null) 
		AND (@Code is NOT null OR @Description is NOT null ))
	BEGIN
		SELECT 

			FundoID, Level, ParentID, Code, Description, Global
		FROM [OW].[tblArchFundo]	
		WHERE
			([Code] like isnull(@Code,[Code])) AND
			([Description] like isnull(@Description,[Description]))

	END

	ELSE	

	BEGIN
		SELECT
          [FundoID],
          [Level],
          [ParentID],
          [Code],
          [Description],
          [Global]
		FROM [OW].[tblArchFundo]
		WHERE
			([FundoID] = isnull(@FundoID,[FundoID])) AND
			([Level] = isnull(@Level,[Level])) AND
			([ParentID] = isnull(@ParentID,[ParentID])) AND
			([Code] like isnull(@Code,[Code])) AND
			([Description] like isnull(@Description,[Description])) AND
			([Global] = isnull(@Global,[Global]))

	END
	SET @Err = @@Error

	RETURN @Err
END




GO
CREATE   PROCEDURE [OW].usp_GetArchSerie
(
	@SerieID decimal(18,0) = null,
	@Level smallint = null,
	@ParentID decimal(18,0) = null,
	@Code varchar(50) = null,
	@Description varchar(250) = null,
	@Global bit = null,
	@ActiveYears int = null,
	@ActiveMonths int = null,
	@ActiveFixed bit = null,
	@SemiActiveYears int = null,
	@SemiActiveMonths int = null,
	@SemiActiveFixed bit = null,
	@ReturnMonths int = null,
	@ReturnDays int = null,
	@ReturnFixed bit = null,
	@DestinationID decimal(18,0) = null,
	@DestinationFixed bit = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	IF 
	(
	 	@SerieID is null
	  AND 
	@Level is null
	  AND 
	@ParentID is null
	  AND 
	@Code is null
	  AND 
	@Description is null
	  AND 
	@Global is null
	  AND 
	@ActiveYears is null
	  AND 
	@ActiveMonths is null
	  AND 
	@ActiveFixed is null
	  AND 
	@SemiActiveYears is null
	  AND 
	@SemiActiveMonths is null
	  AND 
	@SemiActiveFixed is null
	  AND 
	@ReturnMonths is null
	  AND 
	@ReturnDays is null
	  AND 
	@ReturnFixed is null
	  AND 
	@DestinationID is null
	  AND 
	@DestinationFixed is null
	)
	BEGIN
		SELECT 

			SerieID
			, 
[Level]
			, 
ParentID
			, 
Code
			, 
[Description]
			, 
[Global]
			, 
ActiveYears
			, 
ActiveMonths
			, 
ActiveFixed
			, 
SemiActiveYears
			, 
SemiActiveMonths
			, 
SemiActiveFixed
			, 
ReturnMonths
			, 
ReturnDays
			, 
ReturnFixed
			, 
DestinationID
			, 
DestinationFixed
		FROM [OW].[tblArchSerie]	
	END
	ELSE if (
		(@SerieID is null AND 
		@Level is null AND 
		@ParentID is null AND 
		@ActiveYears is null AND 
		@ActiveMonths is null AND 
		@ActiveFixed is null AND 
		@SemiActiveYears is null AND 
		@SemiActiveMonths is null AND 
		@SemiActiveFixed is null AND 
		@ReturnMonths is null AND 
		@ReturnDays is null AND 
		@ReturnFixed is null AND 
		@DestinationID is null AND 
		@DestinationFixed is null ) 
		AND 
		(@Code is not null OR @Description is not null)
		)
	BEGIN
		SELECT
          [SerieID],
          [Level],
          [ParentID],
          [Code],
          [Description],
          [Global],
          [ActiveYears],
          [ActiveMonths],
          [ActiveFixed],
          [SemiActiveYears],
          [SemiActiveMonths],
          [SemiActiveFixed],
          [ReturnMonths],
          [ReturnDays],
          [ReturnFixed],
          [DestinationID],
          [DestinationFixed]
		FROM [OW].[tblArchSerie]
		WHERE
			([Code] like isnull(@Code,[Code])) AND
			([Description] like isnull(@Description,[Description]))

	END
	ELSE
	BEGIN
		SELECT
          [SerieID],
          [Level],
          [ParentID],
          [Code],
          [Description],
          [Global],
          [ActiveYears],
          [ActiveMonths],
          [ActiveFixed],
          [SemiActiveYears],
          [SemiActiveMonths],
          [SemiActiveFixed],
          [ReturnMonths],
          [ReturnDays],
          [ReturnFixed],
          [DestinationID],
          [DestinationFixed]
		FROM [OW].[tblArchSerie]
		WHERE
			([SerieID] = isnull(@SerieID,[SerieID])) AND
			([Level] = isnull(@Level,[Level])) AND
			([ParentID] = isnull(@ParentID,[ParentID])) AND
			([Code] like isnull(@Code,[Code])) AND
			([Description] like isnull(@Description,[Description])) AND
			([Global] = isnull(@Global,[Global])) AND
			([ActiveYears] = isnull(@ActiveYears,[ActiveYears])) AND
			([ActiveMonths] = isnull(@ActiveMonths,[ActiveMonths])) AND
			([ActiveFixed] = isnull(@ActiveFixed,[ActiveFixed])) AND
			([SemiActiveYears] = isnull(@SemiActiveYears,[SemiActiveYears])) AND
			([SemiActiveMonths] = isnull(@SemiActiveMonths,[SemiActiveMonths])) AND
			([SemiActiveFixed] = isnull(@SemiActiveFixed,[SemiActiveFixed])) AND
			([ReturnMonths] = isnull(@ReturnMonths,[ReturnMonths])) AND
			([ReturnDays] = isnull(@ReturnDays,[ReturnDays])) AND
			([ReturnFixed] = isnull(@ReturnFixed,[ReturnFixed])) AND
			([DestinationID] = isnull(@DestinationID,[DestinationID])) AND
			([DestinationFixed] = isnull(@DestinationFixed,[DestinationFixed]))

	END
	SET @Err = @@Error

	RETURN @Err
END
GO

CREATE  PROCEDURE OW.usp_GetEntityLocation
(
	@LocationID numeric(18,0) = null,
	@Description varchar(250) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	IF @LocationID is not null
	BEGIN
		SELECT	[LocationID], [Description]
		FROM [OW].[tblEntityLocation]
		WHERE [LocationID] = @LocationID
	END
	ELSE IF @Description is not null
	BEGIN
	
		SELECT	[LocationID], [Description]
		FROM [OW].[tblEntityLocation]
		WHERE [Description] LIKE @Description
	END
	ELSE 
	BEGIN

		SELECT	[LocationID], [Description]
		FROM [OW].[tblEntityLocation]
	END
	SET @Err = @@Error

	RETURN @Err
END
GO


create PROCEDURE OW.usp_GetEntityBIArquive
(
	@BIArquiveID numeric(18,0) = null,
	@Description varchar(255) = null,
	@Global bit = null
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	IF ( @BIArquiveID is null AND
	     @Description is null AND
	     @Global is null)
	BEGIN
		SELECT	[BIArquiveID],
			[Description],
			[Global]
		FROM [OW].[tblEntityBIArquive]
	END
	ELSE
	BEGIN

		SELECT	[BIArquiveID],
			[Description],
			[Global]
		FROM [OW].[tblEntityBIArquive]
		WHERE
			[BIArquiveID] = isnull(@BIArquiveID, BIArquiveID) AND
			[Description] like isnull(@Description, [Description]) AND
			[Global] = isnull(@Global,[Global])
	END
	SET @Err = @@Error

	RETURN @Err
END

GO

create PROCEDURE OW.usp_GetEntityJobPosition
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	SELECT JobPositionID, [Description]
	FROM [OW].[tblEntityJobPosition]	
	ORDER BY [Description]

	SET @Err = @@Error

	RETURN @Err
END

GO

create PROCEDURE OW.usp_GetEntityListBIArquiveAssociation
(
	@ListID numeric
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	SELECT  OW.tblEntityBIArquive.*, OW.tblEntityListBIArquiveAssociation.ListID
	FROM    
		OW.tblEntityBIArquive LEFT OUTER JOIN
		OW.tblEntityListBIArquiveAssociation ON OW.tblEntityBIArquive.BIArquiveID = OW.tblEntityListBIArquiveAssociation.BIArquiveID 
		AND OW.tblEntityListBIArquiveAssociation.ListID = @ListID 
	ORDER BY description
	SET @Err = @@Error

	RETURN @Err
END

GO



CREATE PROCEDURE OW.usp_DeleteEntityBIArquive
(
	@BIArquiveID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityBIArquive]
	WHERE
		[BIArquiveID] = @BIArquiveID
	SET @Err = @@Error

	RETURN @Err
END

GO




CREATE PROCEDURE OW.usp_DeleteEntityJobPosition
(
	@JobPositionID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityJobPosition]
	WHERE
		[JobPositionID] = @JobPositionID
	SET @Err = @@Error

	RETURN @Err
END

GO




CREATE PROCEDURE OW.usp_DeleteEntityListBIArquiveAssociations
(
	@ListID numeric
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE FROM [OW].[tblEntityListBIArquiveAssociation]
	WHERE [ListID] = @ListID

	SET @Err = @@Error
	RETURN @Err
END

GO






CREATE PROCEDURE OW.usp_DeleteEntityLocation
( @LocationID numeric(18,0))
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityLocation]
	WHERE [LocationID] = @LocationID
	SET @Err = @@Error

	RETURN @Err
END

GO




CREATE PROCEDURE [OW].usp_NewArchClassification
(
	@ClassificationID decimal(18,0) = NULL output,
	@Level smallint,
	@ParentID decimal(18,0) = NULL,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit,
	@Scope smallint
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	if @ParentID = 0 begin
		set @ParentID = null
	end

	INSERT
	INTO [OW].[tblArchClassification]
	(
		[Level],
		[ParentID],
		[Code],
		[Description],
		[Global],
		[Scope]
	)
	VALUES
	(
		@Level,
		@ParentID,
		@Code,
		@Description,
		@Global,
		@Scope
	)

	SET @Err = @@Error

	SELECT @ClassificationID = SCOPE_IDENTITY()

	RETURN @Err
END

GO
create PROCEDURE OW.usp_NewEntityBIArquive
(
	@Description varchar(255),
	@Global bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblEntityBIArquive]
	(
		[Description],
		[Global]
	)
	VALUES
	(
		@Description,
		@Global
	)

	SET @Err = @@Error


	RETURN @Err
END

GO

create PROCEDURE OW.usp_NewEntityJobPosition
(
	@Description varchar(250) 
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblEntityJobPosition]
	(
		[Description]
	)
	VALUES
	(
		@Description
	)

	SET @Err = @@Error


	RETURN @Err
END

GO

create PROCEDURE OW.usp_NewEntityListBIArquiveAssociation
(
	@ListID numeric,
	@BIArquiveID numeric
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int


	INSERT
	INTO [OW].[tblEntityListBIArquiveAssociation]
	(
		[BIArquiveID], [ListID]
	)
	VALUES
	(
		@BIArquiveID, @ListID
	)
	SET @Err = @@Error
	RETURN @Err
END

GO

create PROCEDURE OW.usp_NewEntityLocation
(
	@Description varchar(250)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	INSERT
	INTO [OW].[tblEntityLocation] ([Description])
	VALUES ( @Description)

	SET @Err = @@Error


	RETURN @Err
END

GO

create PROCEDURE OW.usp_PostponeRequest
(
	@RequestID as numeric(18,0),
	@LimitDate datetime,
	@State int	
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int
	SET DATEFORMAT dmy
	DECLARE @NUM INT

	UPDATE [OW].tblRequest 
	SET LimitDate = @LimitDate, State = @State
	WHERE RequestID = @RequestID

	SET @Err = @@Error
	SELECT @RequestID = SCOPE_IDENTITY()
	RETURN @Err
END

GO

CREATE PROCEDURE [OW].usp_SetArchClassification
(
	@ClassificationID decimal(18,0),
	@Level smallint,
	@ParentID decimal(18,0) = NULL,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit,
	@Scope smallint
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblArchClassification]
	SET
		[Level] = @Level,
		[ParentID] = @ParentID,
		[Code] = @Code,
		[Description] = @Description,
		[Global] = @Global,
		[Scope] = @Scope
	WHERE
		[ClassificationID] = @ClassificationID


	SET @Err = @@Error


	RETURN @Err
END


GO


create PROCEDURE OW.usp_SetEntityBIArquive
(
	@BIArquiveID numeric(18,0),
	@Description varchar(255),
	@Global bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblEntityBIArquive]
	SET
		[Description] = @Description,
		[Global] = @Global
	WHERE
		[BIArquiveID] = @BIArquiveID


	SET @Err = @@Error


	RETURN @Err
END

GO
create PROCEDURE OW.usp_SetEntityJobPosition
(
	@JobPositionID numeric(18,0),
	@Description varchar(250)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblEntityJobPosition]
	SET
		[Description] = @Description
	WHERE
		[JobPositionID] = @JobPositionID


	SET @Err = @@Error


	RETURN @Err
END

GO

create PROCEDURE OW.usp_SetEntityLocation
(
	@LocationID numeric(18,0),
	@Description varchar(250)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblEntityLocation]
	SET [Description] = @Description
	WHERE [LocationID] = @LocationID

	SET @Err = @@Error
	RETURN @Err
END

GO

CREATE PROCEDURE [OW].usp_SetRequestType
(
	@RequestID numeric(18,0),
	@Description varchar(100)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblRequestType]
	SET
		[Description] = @Description
	WHERE
		[RequestID] = @RequestID


	SET @Err = @@Error


	RETURN @Err
END


GO


CREATE PROCEDURE [OW].usp_GetAllArchClassification

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	
	-- Obtém as Classificações de 1º nível
	select ClassificationID, [Global], 
		Code as Level1, null as Level2, null as Level3, null as Level4, null as Level5, [Description], 
		[Description] as Level1Description, null as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		Scope, null as ParentID, [Level]
	from OW.tblArchClassification
	where level = 0
	
	union
	
	-- Obtém as Classificações de 2º nível
	select a1.ClassificationID, a1.Global,
		a2.Code as Level1, a1.Code as Level2, null as Level3, null as Level4, null as Level5, a1.Description, 
		a2.Description as Level1Description, a1.Description as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblArchClassification a1
	inner join OW.tblArchClassification a2 on a2.ClassificationID = a1.ParentId
	where a1.level = 1
	
	union
	
	-- Obtém as Classificações de 3º nível
	select a1.ClassificationID, a1.Global,
		a3.Code as Level1, a2.Code as Level2, a1.Code as Level3, null as Level4, null as Level5, a1.Description, 
		a3.Description as Level1Description, a2.Description as Level2Description, a1.Description as Level3Description, null as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblArchClassification a1
	inner join OW.tblArchClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblArchClassification a3 on a3.ClassificationID = a2.ParentId
	where a1.level = 2
	
	union
	
	-- Obtém as Classificações de 4º nível
	select a1.ClassificationID, a1.Global,
		a4.Code as Level1, a3.Code as Level2, a2.Code as Level3, a1.Code as Level4, null as Level5, a1.Description, 
		a4.Description as Level1Description, a3.Description as Level2Description, a2.Description as Level3Description, a1.Description as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblArchClassification a1
	inner join OW.tblArchClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblArchClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblArchClassification a4 on a4.ClassificationID = a3.ParentId
	where a1.level = 3
	
	union
	
	-- Obtém as Classificações de 5º nível
	select a1.ClassificationID, a1.Global,
		a5.Code as Level1, a4.Code as Level2, a3.Code as Level3, a2.Code as Level4, a1.Code as Level5, a1.Description, 
		a5.Description as Level1Description, a4.Description as Level2Description, a3.Description as Level3Description, a2.Description as Level4Description, a1.Description as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblArchClassification a1
	inner join OW.tblArchClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblArchClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblArchClassification a4 on a4.ClassificationID = a3.ParentId
	inner join OW.tblArchClassification a5 on a5.ClassificationID = a4.ParentId
	where a1.level = 4
	
	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END

GO



CREATE PROCEDURE [OW].usp_GetArchClassificationByCode
(
	@Code varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	SELECT
	          [ClassificationID],
	          [Level],
	          [ParentID],
	          [Code],
	          [Description],
	          [Global],
	          [Scope]
	FROM [OW].[tblArchClassification]
	WHERE
		[Code] = @Code

	SET @Err = @@Error

	RETURN @Err
END

GO

CREATE PROCEDURE [OW].usp_DeleteArchClassification
(
	@ClassificationID decimal(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchClassification]
	WHERE
		[ClassificationID] = @ClassificationID
	SET @Err = @@Error

	RETURN @Err
END

GO

/****************************************************************************************************************/
/* Procedures OfficeWorks.Data.OWArchive */ 
/****************************************************************************************************************/

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsDelete;
GO


CREATE PROCEDURE [OW].ArchFieldsDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchFields]
	WHERE
		[IdField] = @IdField
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsInsert;
GO

CREATE PROCEDURE [OW].ArchFieldsInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int = NULL OUTPUT,
	@OriginalName varchar(50),
	@OriginalDesignation varchar(250),
	@OriginalSize int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchFields]
	(
		[OriginalName],
		[OriginalDesignation],
		[OriginalSize]
	)
	VALUES
	(
		@OriginalName,
		@OriginalDesignation,
		@OriginalSize
	)	
	SELECT @IdField = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsSelect;
GO

CREATE PROCEDURE [OW].ArchFieldsSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:36
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int = NULL,
	@OriginalName varchar(50) = NULL,
	@OriginalDesignation varchar(250) = NULL,
	@OriginalSize int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdField],
		[OriginalName],
		[OriginalDesignation],
		[OriginalSize]
	FROM [OW].[tblArchFields]
	WHERE
		(@IdField IS NULL OR [IdField] = @IdField) AND
		(@OriginalName IS NULL OR [OriginalName] LIKE @OriginalName) AND
		(@OriginalDesignation IS NULL OR [OriginalDesignation] LIKE @OriginalDesignation) AND
		(@OriginalSize IS NULL OR [OriginalSize] = @OriginalSize)

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsSelectPaging;
GO


CREATE PROCEDURE [OW].ArchFieldsSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int = NULL,
	@OriginalName varchar(50) = NULL,
	@OriginalDesignation varchar(250) = NULL,
	@OriginalSize int = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@IdField IS NOT NULL) SET @WHERE = @WHERE + '([IdField] = @IdField) AND '
	IF(@OriginalName IS NOT NULL) SET @WHERE = @WHERE + '([OriginalName] LIKE @OriginalName) AND '
	IF(@OriginalDesignation IS NOT NULL) SET @WHERE = @WHERE + '([OriginalDesignation] LIKE @OriginalDesignation) AND '
	IF(@OriginalSize IS NOT NULL) SET @WHERE = @WHERE + '([OriginalSize] = @OriginalSize) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(IdField) 
	FROM [OW].[tblArchFields]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@IdField int, 
		@OriginalName varchar(50), 
		@OriginalDesignation varchar(250), 
		@OriginalSize int,
		@RowCount bigint OUTPUT',
		@IdField, 
		@OriginalName, 
		@OriginalDesignation, 
		@OriginalSize,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE IdField IN (
		SELECT TOP ' + @SizeString + ' IdField
			FROM [OW].[tblArchFields]
			WHERE IdField NOT IN (
				SELECT TOP ' + @PrevString + ' IdField 
				FROM [OW].[tblArchFields]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[IdField], 
		[OriginalName], 
		[OriginalDesignation], 
		[OriginalSize]
	FROM [OW].[tblArchFields]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@IdField int, 
		@OriginalName varchar(50), 
		@OriginalDesignation varchar(250), 
		@OriginalSize int',
		@IdField, 
		@OriginalName, 
		@OriginalDesignation, 
		@OriginalSize
	
	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsSelectPaging Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsUpdate;
GO


CREATE PROCEDURE [OW].ArchFieldsUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int,
	@OriginalName varchar(50),
	@OriginalDesignation varchar(250),
	@OriginalSize int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchFields]
	SET
		[OriginalName] = @OriginalName,
		[OriginalDesignation] = @OriginalDesignation,
		[OriginalSize] = @OriginalSize
	WHERE
		[IdField] = @IdField
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsVsSpaceDelete;
GO


CREATE PROCEDURE [OW].ArchFieldsVsSpaceDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int = NULL,
	@IdSpace int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchFieldsVsSpace]
	WHERE
		[IdField] = @IdField AND
		[IdSpace] = @IdSpace
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsVsSpaceInsert;
GO


CREATE PROCEDURE [OW].ArchFieldsVsSpaceInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int,
	@IdField int,
	@Name varchar(50),
	@Designation varchar(250),
	@Size int = NULL,
	@Visible bit,
	@Enabled bit,
	@Order int,
	@Html varchar(5000) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchFieldsVsSpace]
	(
		[IdSpace],
		[IdField],
		[Name],
		[Designation],
		[Size],
		[Visible],
		[Enabled],
		[Order],
		[Html]
	)
	VALUES
	(
		@IdSpace,
		@IdField,
		@Name,
		@Designation,
		@Size,
		@Visible,
		@Enabled,
		@Order,
		@Html
	)	
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsVsSpaceSelect;
GO


CREATE PROCEDURE [OW].ArchFieldsVsSpaceSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int = NULL,
	@IdField int = NULL,
	@Name varchar(50) = NULL,
	@Designation varchar(250) = NULL,
	@Size int = NULL,
	@Visible bit = NULL,
	@Enabled bit = NULL,
	@Order int = NULL,
	@Html varchar(5000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdSpace],
		[IdField],
		[Name],
		[Designation],
		[Size],
		[Visible],
		[Enabled],
		[Order],
		[Html]
	FROM [OW].[tblArchFieldsVsSpace]
	WHERE
		(@IdSpace IS NULL OR [IdSpace] = @IdSpace) AND
		(@IdField IS NULL OR [IdField] = @IdField) AND
		(@Name IS NULL OR [Name] LIKE @Name) AND
		(@Designation IS NULL OR [Designation] LIKE @Designation) AND
		(@Size IS NULL OR [Size] = @Size) AND
		(@Visible IS NULL OR [Visible] = @Visible) AND
		(@Enabled IS NULL OR [Enabled] = @Enabled) AND
		(@Order IS NULL OR [Order] = @Order) AND
		(@Html IS NULL OR [Html] LIKE @Html)

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsVsSpaceUpdate;
GO


CREATE PROCEDURE [OW].ArchFieldsVsSpaceUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int,
	@IdField int,
	@Name varchar(50),
	@Designation varchar(250),
	@Size int = NULL,
	@Visible bit,
	@Enabled bit,
	@Order int,
	@Html varchar(5000) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchFieldsVsSpace]
	SET
		[Name] = @Name,
		[Designation] = @Designation,
		[Size] = @Size,
		[Visible] = @Visible,
		[Enabled] = @Enabled,
		[Order] = @Order,
		[Html] = @Html
	WHERE
		[IdField] = @IdField
	AND	[IdSpace] = @IdSpace
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeDelete;
GO


CREATE PROCEDURE [OW].ArchFisicalAccessTypeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalAccessType int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchFisicalAccessType]
	WHERE
		[IdFisicalAccessType] = @IdFisicalAccessType
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeInsert;
GO


CREATE PROCEDURE [OW].ArchFisicalAccessTypeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalAccessType int = NULL OUTPUT,
	@IdParentFAT int = NULL,
	@IdFisicalType int,
	@Order int,
	@InsertedBy varchar(150),
	@InsertedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchFisicalAccessType]
	(
		[IdParentFAT],
		[IdFisicalType],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@IdParentFAT,
		@IdFisicalType,
		@Order,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @IdFisicalAccessType = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeSelect;
GO


CREATE PROCEDURE [OW].ArchFisicalAccessTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalAccessType int = NULL,
	@IdParentFAT int = NULL,
	@IdFisicalType int = NULL,
	@Order int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdFisicalAccessType],
		[IdParentFAT],
		[IdFisicalType],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblArchFisicalAccessType]
	WHERE
		(@IdFisicalAccessType IS NULL OR [IdFisicalAccessType] = @IdFisicalAccessType) AND
		(@IdParentFAT IS NULL OR [IdParentFAT] = @IdParentFAT) AND
		(@IdFisicalType IS NULL OR [IdFisicalType] = @IdFisicalType) AND
		(@Order IS NULL OR [Order] = @Order) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeSelectPaging;
GO


CREATE PROCEDURE [OW].ArchFisicalAccessTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalAccessType int = NULL,
	@IdParentFAT int = NULL,
	@IdFisicalType int = NULL,
	@Order int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@IdFisicalAccessType IS NOT NULL) SET @WHERE = @WHERE + '([IdFisicalAccessType] = @IdFisicalAccessType) AND '
	IF(@IdParentFAT IS NOT NULL) SET @WHERE = @WHERE + '([IdParentFAT] = @IdParentFAT) AND '
	IF(@IdFisicalType IS NOT NULL) SET @WHERE = @WHERE + '([IdFisicalType] = @IdFisicalType) AND '
	IF(@Order IS NOT NULL) SET @WHERE = @WHERE + '([Order] = @Order) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(IdFisicalAccessType) 
	FROM [OW].[tblArchFisicalAccessType]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@IdFisicalAccessType int, 
		@IdParentFAT int, 
		@IdFisicalType int, 
		@Order int, 
		@InsertedBy varchar(150), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(150), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@IdFisicalAccessType, 
		@IdParentFAT, 
		@IdFisicalType, 
		@Order, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE IdFisicalAccessType IN (
		SELECT TOP ' + @SizeString + ' IdFisicalAccessType
			FROM [OW].[tblArchFisicalAccessType]
			WHERE IdFisicalAccessType NOT IN (
				SELECT TOP ' + @PrevString + ' IdFisicalAccessType 
				FROM [OW].[tblArchFisicalAccessType]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[IdFisicalAccessType], 
		[IdParentFAT], 
		[IdFisicalType], 
		[Order], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblArchFisicalAccessType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@IdFisicalAccessType int, 
		@IdParentFAT int, 
		@IdFisicalType int, 
		@Order int, 
		@InsertedBy varchar(150), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(150), 
		@LastModifiedOn datetime',
		@IdFisicalAccessType, 
		@IdParentFAT, 
		@IdFisicalType, 
		@Order, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelectPaging Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeUpdate;
GO


CREATE PROCEDURE [OW].ArchFisicalAccessTypeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalAccessType int,
	@IdParentFAT int = NULL,
	@IdFisicalType int,
	@Order int,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchFisicalAccessType]
	SET
		[IdParentFAT] = @IdParentFAT,
		[IdFisicalType] = @IdFisicalType,
		[Order] = @Order,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[IdFisicalAccessType] = @IdFisicalAccessType
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertDelete;
GO


CREATE PROCEDURE [OW].ArchFisicalInsertDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchFisicalInsert]
	WHERE
		[IdFisicalInsert] = @IdFisicalInsert
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertInsert;
GO


CREATE PROCEDURE [OW].ArchFisicalInsertInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int = NULL OUTPUT,
	@IdParentFI int = NULL,
	@IdFisicalAccessType int,
	@IdIdentityCB int,
	@Barcode uniqueidentifier,
	@Order int,
	@InsertedBy varchar(150),
	@InsertedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchFisicalInsert]
	(
		[IdParentFI],
		[IdFisicalAccessType],
		[IdIdentityCB],
		[Barcode],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@IdParentFI,
		@IdFisicalAccessType,
		@IdIdentityCB,
		@Barcode,
		@Order,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @IdFisicalInsert = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertSelect;
GO


CREATE PROCEDURE [OW].ArchFisicalInsertSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int = NULL,
	@IdParentFI int = NULL,
	@IdFisicalAccessType int = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@Order int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdFisicalInsert],
		[IdParentFI],
		[IdFisicalAccessType],
		[IdIdentityCB],
		[Barcode],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblArchFisicalInsert]
	WHERE
		(@IdFisicalInsert IS NULL OR [IdFisicalInsert] = @IdFisicalInsert) AND
		(@IdParentFI IS NULL OR [IdParentFI] = @IdParentFI) AND
		(@IdFisicalAccessType IS NULL OR [IdFisicalAccessType] = @IdFisicalAccessType) AND
		(@IdIdentityCB IS NULL OR [IdIdentityCB] = @IdIdentityCB) AND
		(@Barcode IS NULL OR [Barcode] = @Barcode) AND
		(@Order IS NULL OR [Order] = @Order) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertSelectPaging;
GO


CREATE PROCEDURE [OW].ArchFisicalInsertSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int = NULL,
	@IdParentFI int = NULL,
	@IdFisicalAccessType int = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@Order int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@IdFisicalInsert IS NOT NULL) SET @WHERE = @WHERE + '([IdFisicalInsert] = @IdFisicalInsert) AND '
	IF(@IdParentFI IS NOT NULL) SET @WHERE = @WHERE + '([IdParentFI] = @IdParentFI) AND '
	IF(@IdFisicalAccessType IS NOT NULL) SET @WHERE = @WHERE + '([IdFisicalAccessType] = @IdFisicalAccessType) AND '
	IF(@IdIdentityCB IS NOT NULL) SET @WHERE = @WHERE + '([IdIdentityCB] = @IdIdentityCB) AND '
	IF(@Barcode IS NOT NULL) SET @WHERE = @WHERE + '([Barcode] = @Barcode) AND '
	IF(@Order IS NOT NULL) SET @WHERE = @WHERE + '([Order] = @Order) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(IdFisicalInsert) 
	FROM [OW].[tblArchFisicalInsert]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@IdFisicalInsert int, 
		@IdParentFI int, 
		@IdFisicalAccessType int, 
		@IdIdentityCB int, 
		@Barcode uniqueidentifier, 
		@Order int, 
		@InsertedBy varchar(150), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(150), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@IdFisicalInsert, 
		@IdParentFI, 
		@IdFisicalAccessType, 
		@IdIdentityCB, 
		@Barcode, 
		@Order, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE IdFisicalInsert IN (
		SELECT TOP ' + @SizeString + ' IdFisicalInsert
			FROM [OW].[tblArchFisicalInsert]
			WHERE IdFisicalInsert NOT IN (
				SELECT TOP ' + @PrevString + ' IdFisicalInsert 
				FROM [OW].[tblArchFisicalInsert]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[IdFisicalInsert], 
		[IdParentFI], 
		[IdFisicalAccessType], 
		[IdIdentityCB], 
		[Barcode], 
		[Order], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblArchFisicalInsert]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@IdFisicalInsert int, 
		@IdParentFI int, 
		@IdFisicalAccessType int, 
		@IdIdentityCB int, 
		@Barcode uniqueidentifier, 
		@Order int, 
		@InsertedBy varchar(150), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(150), 
		@LastModifiedOn datetime',
		@IdFisicalInsert, 
		@IdParentFI, 
		@IdFisicalAccessType, 
		@IdIdentityCB, 
		@Barcode, 
		@Order, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelectPaging Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertUpdate;
GO


CREATE PROCEDURE [OW].ArchFisicalInsertUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int,
	@IdParentFI int = NULL,
	@IdFisicalAccessType int,
	@IdIdentityCB int,
	@Barcode uniqueidentifier,
	@Order int,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchFisicalInsert]
	SET
		[IdParentFI] = @IdParentFI,
		[IdFisicalAccessType] = @IdFisicalAccessType,
		[IdIdentityCB] = @IdIdentityCB,
		[Barcode] = @Barcode,
		[Order] = @Order,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[IdFisicalInsert] = @IdFisicalInsert
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeDelete;
GO


CREATE PROCEDURE [OW].ArchFisicalTypeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalType int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchFisicalType]
	WHERE
		[IdFisicalType] = @IdFisicalType
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeInsert;
GO


CREATE PROCEDURE [OW].ArchFisicalTypeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalType int = NULL OUTPUT,
	@IdSpace int,
	@Abreviation varchar(5),
	@Designation varchar(50),
	@Order int,
	@InsertedBy varchar(150),
	@InsertedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchFisicalType]
	(
		[IdSpace],
		[Abreviation],
		[Designation],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@IdSpace,
		@Abreviation,
		@Designation,
		@Order,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @IdFisicalType = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeSelect;
GO


CREATE PROCEDURE [OW].ArchFisicalTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalType int = NULL,
	@IdSpace int = NULL,
	@Abreviation varchar(5) = NULL,
	@Designation varchar(50) = NULL,
	@Order int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdFisicalType],
		[IdSpace],
		[Abreviation],
		[Designation],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblArchFisicalType]
	WHERE
		(@IdFisicalType IS NULL OR [IdFisicalType] = @IdFisicalType) AND
		(@IdSpace IS NULL OR [IdSpace] = @IdSpace) AND
		(@Abreviation IS NULL OR [Abreviation] LIKE @Abreviation) AND
		(@Designation IS NULL OR [Designation] LIKE @Designation) AND
		(@Order IS NULL OR [Order] = @Order) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeSelectPaging;
GO


CREATE PROCEDURE [OW].ArchFisicalTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalType int = NULL,
	@IdSpace int = NULL,
	@Abreviation varchar(5) = NULL,
	@Designation varchar(50) = NULL,
	@Order int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@IdFisicalType IS NOT NULL) SET @WHERE = @WHERE + '([IdFisicalType] = @IdFisicalType) AND '
	IF(@IdSpace IS NOT NULL) SET @WHERE = @WHERE + '([IdSpace] = @IdSpace) AND '
	IF(@Abreviation IS NOT NULL) SET @WHERE = @WHERE + '([Abreviation] LIKE @Abreviation) AND '
	IF(@Designation IS NOT NULL) SET @WHERE = @WHERE + '([Designation] LIKE @Designation) AND '
	IF(@Order IS NOT NULL) SET @WHERE = @WHERE + '([Order] = @Order) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(IdFisicalType) 
	FROM [OW].[tblArchFisicalType]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@IdFisicalType int, 
		@IdSpace int, 
		@Abreviation varchar(5), 
		@Designation varchar(50), 
		@Order int, 
		@InsertedBy varchar(150), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(150), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@IdFisicalType, 
		@IdSpace, 
		@Abreviation, 
		@Designation, 
		@Order, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE IdFisicalType IN (
		SELECT TOP ' + @SizeString + ' IdFisicalType
			FROM [OW].[tblArchFisicalType]
			WHERE IdFisicalType NOT IN (
				SELECT TOP ' + @PrevString + ' IdFisicalType 
				FROM [OW].[tblArchFisicalType]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[IdFisicalType], 
		[IdSpace], 
		[Abreviation], 
		[Designation], 
		[Order], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblArchFisicalType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@IdFisicalType int, 
		@IdSpace int, 
		@Abreviation varchar(5), 
		@Designation varchar(50), 
		@Order int, 
		@InsertedBy varchar(150), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(150), 
		@LastModifiedOn datetime',
		@IdFisicalType, 
		@IdSpace, 
		@Abreviation, 
		@Designation, 
		@Order, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelectPaging Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeUpdate;
GO


CREATE PROCEDURE [OW].ArchFisicalTypeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalType int,
	@IdSpace int,
	@Abreviation varchar(5),
	@Designation varchar(50),
	@Order int,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchFisicalType]
	SET
		[IdSpace] = @IdSpace,
		[Abreviation] = @Abreviation,
		[Designation] = @Designation,
		[Order] = @Order,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[IdFisicalType] = @IdFisicalType
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchInsertVsFormDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchInsertVsFormDelete;
GO


CREATE PROCEDURE [OW].ArchInsertVsFormDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdField int = NULL,
	@IdFisicalInsert int = NULL,
	@IdSpace int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchInsertVsForm]
	WHERE
		[IdField] = @IdField AND
		[IdFisicalInsert] = @IdFisicalInsert AND
		[IdSpace] = @IdSpace
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchInsertVsFormDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchInsertVsFormDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchInsertVsFormInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchInsertVsFormInsert;
GO


CREATE PROCEDURE [OW].ArchInsertVsFormInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int,
	@IdSpace int,
	@IdField int,
	@Value varchar(5000) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchInsertVsForm]
	(
		[IdFisicalInsert],
		[IdSpace],
		[IdField],
		[Value]
	)
	VALUES
	(
		@IdFisicalInsert,
		@IdSpace,
		@IdField,
		@Value
	)	
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchInsertVsFormInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchInsertVsFormInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchInsertVsFormSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchInsertVsFormSelect;
GO


CREATE PROCEDURE [OW].ArchInsertVsFormSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int = NULL,
	@IdSpace int = NULL,
	@IdField int = NULL,
	@Value varchar(5000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdFisicalInsert],
		[IdSpace],
		[IdField],
		[Value]
	FROM [OW].[tblArchInsertVsForm]
	WHERE
		(@IdFisicalInsert IS NULL OR [IdFisicalInsert] = @IdFisicalInsert) AND
		(@IdSpace IS NULL OR [IdSpace] = @IdSpace) AND
		(@IdField IS NULL OR [IdField] = @IdField) AND
		(@Value IS NULL OR [Value] LIKE @Value)

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchInsertVsFormSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchInsertVsFormSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchInsertVsFormUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchInsertVsFormUpdate;
GO


CREATE PROCEDURE [OW].ArchInsertVsFormUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int,
	@IdSpace int,
	@IdField int,
	@Value varchar(5000) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchInsertVsForm]
	SET
		[Value] = @Value
	WHERE
		[IdField] = @IdField
	AND	[IdFisicalInsert] = @IdFisicalInsert
	AND	[IdSpace] = @IdSpace
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchInsertVsFormUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchInsertVsFormUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchSpaceDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchSpaceDelete;
GO


CREATE PROCEDURE [OW].ArchSpaceDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblArchSpace]
	WHERE
		[IdSpace] = @IdSpace
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchSpaceDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchSpaceDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchSpaceInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchSpaceInsert;
GO


CREATE PROCEDURE [OW].ArchSpaceInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int = NULL OUTPUT,
	@OriginalAbreviation varchar(3),
	@CodeName varchar(50),
	@OriginalDesignation varchar(50),
	@Image varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblArchSpace]
	(
		[OriginalAbreviation],
		[CodeName],
		[OriginalDesignation],
		[Image]
	)
	VALUES
	(
		@OriginalAbreviation,
		@CodeName,
		@OriginalDesignation,
		@Image
	)	
	SELECT @IdSpace = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchSpaceInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchSpaceInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchSpaceSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchSpaceSelect;
GO


CREATE PROCEDURE [OW].ArchSpaceSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int = NULL,
	@OriginalAbreviation varchar(3) = NULL,
	@CodeName varchar(50) = NULL,
	@OriginalDesignation varchar(50) = NULL,
	@Image varchar(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdSpace],
		[OriginalAbreviation],
		[CodeName],
		[OriginalDesignation],
		[Image]
	FROM [OW].[tblArchSpace]
	WHERE
		(@IdSpace IS NULL OR [IdSpace] = @IdSpace) AND
		(@OriginalAbreviation IS NULL OR [OriginalAbreviation] LIKE @OriginalAbreviation) AND
		(@CodeName IS NULL OR [CodeName] LIKE @CodeName) AND
		(@OriginalDesignation IS NULL OR [OriginalDesignation] LIKE @OriginalDesignation) AND
		(@Image IS NULL OR [Image] LIKE @Image)

	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchSpaceSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchSpaceSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchSpaceSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchSpaceSelectPaging;
GO


CREATE PROCEDURE [OW].ArchSpaceSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int = NULL,
	@OriginalAbreviation varchar(3) = NULL,
	@CodeName varchar(50) = NULL,
	@OriginalDesignation varchar(50) = NULL,
	@Image varchar(50) = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@IdSpace IS NOT NULL) SET @WHERE = @WHERE + '([IdSpace] = @IdSpace) AND '
	IF(@OriginalAbreviation IS NOT NULL) SET @WHERE = @WHERE + '([OriginalAbreviation] LIKE @OriginalAbreviation) AND '
	IF(@CodeName IS NOT NULL) SET @WHERE = @WHERE + '([CodeName] LIKE @CodeName) AND '
	IF(@OriginalDesignation IS NOT NULL) SET @WHERE = @WHERE + '([OriginalDesignation] LIKE @OriginalDesignation) AND '
	IF(@Image IS NOT NULL) SET @WHERE = @WHERE + '([Image] LIKE @Image) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(IdSpace) 
	FROM [OW].[tblArchSpace]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@IdSpace int, 
		@OriginalAbreviation varchar(3), 
		@CodeName varchar(50), 
		@OriginalDesignation varchar(50), 
		@Image varchar(50),
		@RowCount bigint OUTPUT',
		@IdSpace, 
		@OriginalAbreviation, 
		@CodeName, 
		@OriginalDesignation, 
		@Image,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE IdSpace IN (
		SELECT TOP ' + @SizeString + ' IdSpace
			FROM [OW].[tblArchSpace]
			WHERE IdSpace NOT IN (
				SELECT TOP ' + @PrevString + ' IdSpace 
				FROM [OW].[tblArchSpace]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[IdSpace], 
		[OriginalAbreviation], 
		[CodeName], 
		[OriginalDesignation], 
		[Image]
	FROM [OW].[tblArchSpace]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@IdSpace int, 
		@OriginalAbreviation varchar(3), 
		@CodeName varchar(50), 
		@OriginalDesignation varchar(50), 
		@Image varchar(50)',
		@IdSpace, 
		@OriginalAbreviation, 
		@CodeName, 
		@OriginalDesignation, 
		@Image
	
	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchSpaceSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchSpaceSelectPaging Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchSpaceUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchSpaceUpdate;
GO


CREATE PROCEDURE [OW].ArchSpaceUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdSpace int,
	@OriginalAbreviation varchar(3),
	@CodeName varchar(50),
	@OriginalDesignation varchar(50),
	@Image varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblArchSpace]
	SET
		[OriginalAbreviation] = @OriginalAbreviation,
		[CodeName] = @CodeName,
		[OriginalDesignation] = @OriginalDesignation,
		[Image] = @Image
	WHERE
		[IdSpace] = @IdSpace
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchSpaceUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchSpaceUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].IdentityCBDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].IdentityCBDelete;
GO


CREATE PROCEDURE [OW].IdentityCBDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdIdentityCB int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblIdentityCB]
	WHERE
		[IdIdentityCB] = @IdIdentityCB
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].IdentityCBDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].IdentityCBDelete Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].IdentityCBInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].IdentityCBInsert;
GO


CREATE PROCEDURE [OW].IdentityCBInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdIdentityCB int = NULL OUTPUT,
	@Designation varchar(50)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblIdentityCB]
	(
		[Designation]
	)
	VALUES
	(
		@Designation
	)	
	SELECT @IdIdentityCB = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].IdentityCBInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].IdentityCBInsert Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].IdentityCBSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].IdentityCBSelect;
GO


CREATE PROCEDURE [OW].IdentityCBSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdIdentityCB int = NULL,
	@Designation varchar(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[IdIdentityCB],
		[Designation]
	FROM [OW].[tblIdentityCB]
	WHERE
		(@IdIdentityCB IS NULL OR [IdIdentityCB] = @IdIdentityCB) AND
		(@Designation IS NULL OR [Designation] LIKE @Designation)

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].IdentityCBSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].IdentityCBSelect Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].IdentityCBSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].IdentityCBSelectPaging;
GO


CREATE PROCEDURE [OW].IdentityCBSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdIdentityCB int = NULL,
	@Designation varchar(50) = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = 'WHERE '
	
	IF(@IdIdentityCB IS NOT NULL) SET @WHERE = @WHERE + '([IdIdentityCB] = @IdIdentityCB) AND '
	IF(@Designation IS NOT NULL) SET @WHERE = @WHERE + '([Designation] LIKE @Designation) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(IdIdentityCB) 
	FROM [OW].[tblIdentityCB]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@IdIdentityCB int, 
		@Designation varchar(50),
		@RowCount bigint OUTPUT',
		@IdIdentityCB, 
		@Designation,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE IdIdentityCB IN (
		SELECT TOP ' + @SizeString + ' IdIdentityCB
			FROM [OW].[tblIdentityCB]
			WHERE IdIdentityCB NOT IN (
				SELECT TOP ' + @PrevString + ' IdIdentityCB 
				FROM [OW].[tblIdentityCB]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[IdIdentityCB], 
		[Designation]
	FROM [OW].[tblIdentityCB]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@IdIdentityCB int, 
		@Designation varchar(50)',
		@IdIdentityCB, 
		@Designation
	
	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].IdentityCBSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].IdentityCBSelectPaging Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].IdentityCBUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].IdentityCBUpdate;
GO


CREATE PROCEDURE [OW].IdentityCBUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2006 11:02:38
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdIdentityCB int,
	@Designation varchar(50)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblIdentityCB]
	SET
		[Designation] = @Designation
	WHERE
		[IdIdentityCB] = @IdIdentityCB
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].IdentityCBUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].IdentityCBUpdate Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceInsertEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsVsSpaceInsertEx01;
GO

CREATE PROCEDURE [OW].ArchFieldsVsSpaceInsertEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'	
	------------------------------------------------------------------------
	@IdSpace int,
	@IdField int,
	@Name varchar(50) = NULL,
	@Designation varchar(250) = NULL,
	@Size int = NULL,
	@Visible bit,
	@Enabled bit,
	@Order int,
	@Html varchar(5000) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

 	-- Verifica [OriginalName], [OriginalDesignation]
	DECLARE @OriginalName varchar(50), @OriginalDesignation varchar(250), @OriginalSize int
	IF(@Name IS NULL OR @Designation IS NULL OR @Size IS NULL)
	BEGIN
        SELECT
            @OriginalName = OriginalName,
            @OriginalDesignation = OriginalDesignation,
            @OriginalSize = OriginalSize
        FROM OW.tblArchFields
        WHERE IdField = @IdField
	END
	-- fim

	INSERT
	INTO [OW].[tblArchFieldsVsSpace]
	(
		[IdSpace],
		[IdField],
		[Name],
		[Designation],
		[Size],
		[Visible],
		[Enabled],
		[Order],
		[Html]
	)
	VALUES
	(
		@IdSpace,
		@IdField,
		ISNULL(@Name, @OriginalName),
		ISNULL(@Designation, @OriginalDesignation),
		ISNULL(@Size, @OriginalSize),
		@Visible,
		@Enabled,
		@Order,
		@Html
	)
	SET @Err = @@Error
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50001,16,1)		
	END	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceInsertEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceInsertEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceUpdateEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFieldsVsSpaceUpdateEx01;
GO

CREATE PROCEDURE [OW].ArchFieldsVsSpaceUpdateEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'	
	------------------------------------------------------------------------
	@IdSpace int,
	@IdField int,
	@Name varchar(50) = NULL,
	@Designation varchar(250) = NULL,
	@Size int = NULL,
	@Visible bit,
	@Enabled bit,
	@Order int,
	@Html varchar(5000) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

  -- Verifica [OriginalName], [OriginalDesignation]
  DECLARE @OriginalName varchar(50), @OriginalDesignation varchar(250), @OriginalSize int
  IF(@Name IS NULL OR @Designation IS NULL OR @Size IS NULL)
  BEGIN
      SELECT
          @OriginalName = OriginalName,
          @OriginalDesignation = OriginalDesignation,
          @OriginalSize = OriginalSize
      FROM OW.tblArchFields
      WHERE IdField = @IdField
	END
	-- fim
	
	UPDATE [OW].[tblArchFieldsVsSpace]
	SET
		[Name] = ISNULL(@Name, @OriginalName),
		[Designation] = ISNULL(@Designation, @OriginalDesignation),
		[Size] = ISNULL(@Size, @OriginalSize),
		[Visible] = @Visible,
		[Enabled] = @Enabled,
		[Order] = @Order,
		[Html] = @Html
	WHERE
		[IdSpace] = @IdSpace
	AND	[IdField] = @IdField
	
	SET @Err = @@Error
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50002,16,1)		
	END	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceUpdateEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceUpdateEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeSelectEx01;
GO

CREATE    PROCEDURE [OW].ArchFisicalAccessTypeSelectEx01
(
	@IdFisicalAccessType int = null,
	@IdParentFAT int = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

    -- Todos
	IF (
		@IdFisicalAccessType IS NULL AND
		@IdParentFAT IS NULL
	)
	BEGIN	
	SELECT
        fat.IdFisicalAccessType,
        fat.IdParentFAT,
        fat.IdFisicalType,
        ft.IdSpace,
        ft.Abreviation,
        ft.Designation,
        fat.[Order],
        s.Image,
	s.CodeName,
        fat.InsertedBy,
        fat.InsertedOn,
        fat.LastModifiedBy,
        fat.LastModifiedOn
    FROM    OW.tblArchSpace s INNER JOIN
            OW.tblArchFisicalType ft ON
            (s.IdSpace = ft.IdSpace) INNER JOIN
            OW.tblArchFisicalAccessType fat ON
            (ft.IdFisicalType = fat.IdFisicalType)	
	END
	ELSE IF (@IdParentFAT IS NOT NULL) AND (@IdParentFAT <= 0) -- Root [NULL ou <= 0]
	BEGIN
    SELECT
        fat.IdFisicalAccessType,
        fat.IdParentFAT,
        fat.IdFisicalType,
        ft.IdSpace,
        ft.Abreviation,
        ft.Designation,
        fat.[Order],
        s.Image,
	s.CodeName,
        fat.InsertedBy,
        fat.InsertedOn,
        fat.LastModifiedBy,
        fat.LastModifiedOn
    FROM    OW.tblArchSpace s INNER JOIN
            OW.tblArchFisicalType ft ON
            (s.IdSpace = ft.IdSpace) INNER JOIN
            OW.tblArchFisicalAccessType fat ON
            (ft.IdFisicalType = fat.IdFisicalType)
    WHERE (fat.IdFisicalAccessType = ISNULL(@IdFisicalAccessType, fat.IdFisicalAccessType)) AND
			(fat.IdParentFAT IS NULL) OR (fat.IdParentFAT <= @IdParentFAT)
	END
	ELSE IF (@IdParentFAT IS NOT NULL) -- Qualquer @IdFisicalAccessType sendo o @IdParentFAT NULL
	BEGIN
    SELECT
        fat.IdFisicalAccessType,
        fat.IdParentFAT,
        fat.IdFisicalType,
        ft.IdSpace,
        ft.Abreviation,
        ft.Designation,
        fat.[Order],
        s.Image,
	s.CodeName,
        fat.InsertedBy,
        fat.InsertedOn,
        fat.LastModifiedBy,
        fat.LastModifiedOn
    FROM    OW.tblArchSpace s INNER JOIN
            OW.tblArchFisicalType ft ON
            (s.IdSpace = ft.IdSpace) INNER JOIN
            OW.tblArchFisicalAccessType fat ON
            (ft.IdFisicalType = fat.IdFisicalType)
    WHERE (fat.IdFisicalAccessType = ISNULL(@IdFisicalAccessType, fat.IdFisicalAccessType)) AND
            (fat.IdParentFAT = @IdParentFAT)
	END
	ELSE	
	BEGIN	
    -- Qualquer @IdFisicalAccessType
    SELECT
        fat.IdFisicalAccessType,
        fat.IdParentFAT,
        fat.IdFisicalType,
        ft.IdSpace,
        ft.Abreviation,
        ft.Designation,
        fat.[Order],
        s.Image,
	s.CodeName,
        fat.InsertedBy,
        fat.InsertedOn,
        fat.LastModifiedBy,
        fat.LastModifiedOn
    FROM    OW.tblArchSpace s INNER JOIN
            OW.tblArchFisicalType ft ON
            (s.IdSpace = ft.IdSpace) INNER JOIN
            OW.tblArchFisicalAccessType fat ON
            (ft.IdFisicalType = fat.IdFisicalType)
    WHERE  (fat.IdFisicalAccessType = ISNULL(@IdFisicalAccessType, fat.IdFisicalAccessType))

	END
	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelectEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalAccessTypeSelectEx02;
GO

CREATE PROCEDURE [OW].ArchFisicalAccessTypeSelectEx02
(
	@IdFisicalAccessType int = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	SELECT
		fat.IdFisicalAccessType,
		fat.IdParentFAT,
		fat.IdFisicalType,
		ft.IdSpace,
		ft.Abreviation,
		ft.Designation,
		fat.[Order],
		s.Image,
		s.CodeName,
		fn.Expanded, 
		fn.Selected,
		fat.InsertedBy,
		fat.InsertedOn,
		fat.LastModifiedBy,
		fat.LastModifiedOn
	FROM    OW.tblArchSpace s INNER JOIN
	    OW.tblArchFisicalType ft ON
	    (s.IdSpace = ft.IdSpace) INNER JOIN
	    OW.tblArchFisicalAccessType fat ON
	    (ft.IdFisicalType = fat.IdFisicalType)
	INNER JOIN OW.fnFisicalAccessTypeById(@IdFisicalAccessType) fn
	ON fn.IdFisicalAccessType = fat.IdFisicalAccessType
	ORDER BY fat.IdFisicalAccessType

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelectEx02 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertSelectEx01;
GO

CREATE   PROCEDURE [OW].ArchFisicalInsertSelectEx01
(
	@IdFisicalInsert int = NULL,
	@IdParentFI int, --Não pode ser nulo
	@IdSpace int = NULL,
	@IdField int = NULL,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	IF(@IdParentFI IS NULL OR @IdParentFI <= 0)
	BEGIN
	SELECT DISTINCT     
		fi.IdFisicalInsert, 
		fi.IdParentFI, 
		fi.IdFisicalAccessType, 
		s.IdSpace, 
		fvs.IdField, 		
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS 'Abreviation', 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS 'Name', 
		fvs.[Name] AS 'InternalName', 
		fvs.Designation AS 'InternalDesignation', 
		ivf.[Value] AS 'InternalText',
		s.CodeName, 
		s.[Image], 
		fi.IdIdentityCB,
		fi.Barcode, 
		fi.[Order], 
		fi.InsertedBy, 
		fi.InsertedOn, 
		fi.LastModifiedBy, 
		fi.LastModifiedOn
	FROM         
		OW.tblArchFisicalInsert fi
	INNER JOIN
		OW.tblArchInsertVsForm ivf
	ON 
		fi.IdFisicalInsert = ivf.IdFisicalInsert 
	INNER JOIN
		OW.tblArchFieldsVsSpace fvs
	ON 
		ivf.IdSpace = fvs.IdSpace 
	AND 
		ivf.IdField = fvs.IdField 
	INNER JOIN
		OW.tblArchSpace s
	ON 
		fvs.IdSpace = s.IdSpace
	WHERE		
		(@IdFisicalInsert IS NULL OR fi.[IdFisicalInsert] = @IdFisicalInsert) AND
		(fi.[IdParentFI] IS NULL OR fi.[IdParentFI] <= @IdParentFI) AND
		(@IdSpace IS NULL OR s.[IdSpace] = @IdSpace) AND
		(@IdField IS NULL OR fvs.[IdField] = @IdField) AND
		(@InsertedBy IS NULL OR fi.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR fi.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR fi.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR fi.[LastModifiedOn] = @LastModifiedOn)
	END
	ELSE
	BEGIN
	SELECT DISTINCT     
		fi.IdFisicalInsert, 
		fi.IdParentFI, 
		fi.IdFisicalAccessType, 
		s.IdSpace, 
		fvs.IdField, 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS 'Abreviation', 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS 'Name', 
		fvs.[Name] AS 'InternalName', 
		fvs.Designation AS 'InternalDesignation', 
		ivf.[Value] AS 'InternalText',
		s.CodeName, 
		s.[Image], 
		fi.IdIdentityCB,
		fi.Barcode, 
		fi.[Order], 
		fi.InsertedBy, 
		fi.InsertedOn, 
		fi.LastModifiedBy, 
		fi.LastModifiedOn
	FROM         
		OW.tblArchFisicalInsert fi
	INNER JOIN
		OW.tblArchInsertVsForm ivf
	ON 
		fi.IdFisicalInsert = ivf.IdFisicalInsert 
	INNER JOIN
		OW.tblArchFieldsVsSpace fvs
	ON 
		ivf.IdSpace = fvs.IdSpace 
	AND 
		ivf.IdField = fvs.IdField 
	INNER JOIN
		OW.tblArchSpace s
	ON 
		fvs.IdSpace = s.IdSpace
	WHERE		
		(@IdFisicalInsert IS NULL OR fi.[IdFisicalInsert] = @IdFisicalInsert) AND
		(@IdParentFI IS NULL OR fi.[IdParentFI] = @IdParentFI) AND
		(@IdSpace IS NULL OR s.[IdSpace] = @IdSpace) AND
		(@IdField IS NULL OR fvs.[IdField] = @IdField) AND
		(@InsertedBy IS NULL OR fi.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR fi.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR fi.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR fi.[LastModifiedOn] = @LastModifiedOn)
	END

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelectEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalInsertSelectEx02;
GO

CREATE  PROCEDURE [OW].ArchFisicalInsertSelectEx02
(
	@IdFisicalInsert int = NULL,
	@IdField int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

	SELECT DISTINCT     
		fi.IdFisicalInsert, 
		fi.IdParentFI, 
		fi.IdFisicalAccessType, 
		s.IdSpace, 
		fvs.IdField, 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS 'Abreviation', 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS 'Name', 
		fvs.[Name] AS 'InternalName', 
		fvs.Designation AS 'InternalDesignation', 
		ivf.[Value] AS 'InternalText',
		s.CodeName, 
		s.[Image], 
		fi.IdIdentityCB,
		fi.Barcode, 
		fi.[Order],
		fn.Expanded, 
		fn.Selected, 
		fi.InsertedBy, 
		fi.InsertedOn, 
		fi.LastModifiedBy, 
		fi.LastModifiedOn
	FROM         
		OW.tblArchFisicalInsert fi
	INNER JOIN
		OW.tblArchInsertVsForm ivf
	ON 
		fi.IdFisicalInsert = ivf.IdFisicalInsert 
	INNER JOIN
		OW.tblArchFieldsVsSpace fvs
	ON 
		ivf.IdSpace = fvs.IdSpace 
	AND 
		ivf.IdField = fvs.IdField 
	INNER JOIN
		OW.tblArchSpace s
	ON 
		fvs.IdSpace = s.IdSpace
	INNER JOIN 
		OW.fnFisicalInsertById(@IdFisicalInsert) fn
	ON 
		fn.IdFisicalInsert = fi.IdFisicalInsert
	WHERE
		(@IdField IS NULL OR fvs.[IdField] = @IdField)
	ORDER BY fi.IdFisicalInsert

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelectEx02 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeInsertEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeInsertEx01;
GO

CREATE PROCEDURE [OW].ArchFisicalTypeInsertEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'	
	------------------------------------------------------------------------
	@IdFisicalType int = NULL OUTPUT,
	@IdSpace int,
	@Abreviation varchar(5) = NULL,
	@Designation varchar(50) = NULL,
	@Order int,
	@InsertedBy varchar(150) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	-- Verifica [OriginalAbreviation], [OriginalDesignation]
	DECLARE @OriginalAbreviation varchar(3), @OriginalDesignation varchar(50)
	IF(@Abreviation IS NULL OR @Designation IS NULL)
	BEGIN
        SELECT
            @OriginalAbreviation = OriginalAbreviation,
            @OriginalDesignation = OriginalDesignation
        FROM OW.tblArchSpace
        WHERE IdSpace = @IdSpace
	END
	-- fim

	INSERT
	INTO [OW].[tblArchFisicalType]
	(
		[IdSpace],
		[Abreviation],
		[Designation],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@IdSpace,
		ISNULL(@Abreviation, @OriginalAbreviation),
		ISNULL(@Designation, @OriginalDesignation),
		@Order,
		ISNULL(@InsertedBy, CURRENT_USER),
		COALESCE(@InsertedOn, GETDATE()),
		ISNULL(@LastModifiedBy, CURRENT_USER),
		COALESCE(@LastModifiedOn, GETDATE())
	)
	SET @Err = @@Error
	SELECT @IdFisicalType = SCOPE_IDENTITY()
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50001,16,1)		
	END	
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeInsertEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeInsertEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeSelectEx01;
GO



CREATE PROCEDURE [OW].ArchFisicalTypeSelectEx01
(
	@IdFisicalType int = null,
	@PageIndex int = null,
	@PageSize int = null,
	@SortField varchar(100) = null,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	

    DECLARE @Where AS VARCHAR(1000)
    DECLARE @WhereKey AS VARCHAR(1000)
    DECLARE @SizeString AS VARCHAR(10)
    DECLARE @PrevString AS VARCHAR(10)

    SET @SizeString = CONVERT(VARCHAR, @PageSize)
    SET @PrevString = CONVERT(VARCHAR, @PageSize * (@PageIndex - 1))

    SELECT @RowCount = COUNT(ft.IdFisicalType)
    FROM    OW.tblArchFisicalType ft INNER JOIN
            OW.tblArchSpace s ON
            (ft.IdSpace = s.IdSpace)

    -- @PrimaryKey
    IF(@IdFisicalType IS NULL OR @IdFisicalType = -1)
    BEGIN
        SET @WhereKey = ''
    END
    ELSE
    BEGIN
        SET @WhereKey = ' AND ft.IdFisicalType = ' + CONVERT(VARCHAR, @IdFisicalType)
    END

    -- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END

    -- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
        SET @Where = ''
    END
    ELSE
    BEGIN
        SET @Where = 
        'WHERE ft.IdFisicalType IN (
            SELECT TOP ' + @SizeString + ' ft.IdFisicalType
            FROM    OW.tblArchFisicalType ft INNER JOIN
                    OW.tblArchSpace s ON
                    (ft.IdSpace = s.IdSpace)
            WHERE ft.IdFisicalType NOT IN (
                SELECT TOP ' + @PrevString + ' ft.IdFisicalType
                FROM    OW.tblArchFisicalType ft INNER JOIN
                        OW.tblArchSpace s ON
                        (ft.IdSpace = s.IdSpace)
                ' + @SortField + '
            )
            ' + @SortField + '
        )
        '

    END

    EXEC(
        'SELECT
            ft.IdFisicalType,
            ft.IdSpace,
            s.OriginalAbreviation,
            s.CodeName,
            s.OriginalDesignation,
            s.Image,
            ft.Abreviation,
            ft.Designation,
            ft.[Order],
            ft.InsertedBy,
            ft.InsertedOn,
            ft.LastModifiedBy,
            ft.LastModifiedOn
        FROM    OW.tblArchFisicalType ft INNER JOIN
                OW.tblArchSpace s ON
                (ft.IdSpace = s.IdSpace)
        ' + @Where + @WhereKey + @SortField
    )
                
	SET @Err = @@Error
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelectEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeUpdateEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchFisicalTypeUpdateEx01;
GO


CREATE PROCEDURE [OW].ArchFisicalTypeUpdateEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'	
	------------------------------------------------------------------------
	@IdFisicalType int,
	@IdSpace int,
	@Abreviation varchar(5) = NULL,
	@Designation varchar(50) = NULL,
	@Order int,
	@InsertedBy varchar(150),
	@InsertedOn datetime,
	@LastModifiedBy varchar(150) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

  -- Verifica [OriginalAbreviation], [OriginalDesignation]
  DECLARE @OriginalAbreviation varchar(3), @OriginalDesignation varchar(50)
  IF(@Abreviation IS NULL OR @Designation IS NULL)
  BEGIN
      SELECT
          @OriginalAbreviation = OriginalAbreviation,
          @OriginalDesignation = OriginalDesignation
      FROM OW.tblArchSpace
      WHERE IdSpace = @IdSpace
	END
	-- fim
	
	UPDATE [OW].[tblArchFisicalType]
	SET
		[IdSpace] = @IdSpace,
		[Abreviation] = ISNULL(@Abreviation, @OriginalAbreviation),
		[Designation] = ISNULL(@Designation, @OriginalDesignation),
		[Order] = @Order,
		[InsertedBy] = @InsertedBy,
		[InsertedOn] = @InsertedOn,
		[LastModifiedBy] = ISNULL(@LastModifiedBy, CURRENT_USER),
		[LastModifiedOn] = GETDATE()
	WHERE
		[IdFisicalType] = @IdFisicalType
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	
	SET @Err = @@Error
	IF(@@ROWCOUNT = 0)
	BEGIN
		RAISERROR(50002,16,1)		
	END	
	RETURN @Err
END


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeUpdateEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeUpdateEx01 Error on Creation'
GO
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchInsertVsFormSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ArchInsertVsFormSelectEx01;
GO

CREATE PROCEDURE OW.ArchInsertVsFormSelectEx01
(
		@IdFisicalInsert int = 0,
		@IdSpace int = 0
)
AS
BEGIN
	SET NOCOUNT ON 
	SET ANSI_WARNINGS OFF 

	DECLARE @_Columns varchar(1000), @_Values varchar(8000)
	DECLARE @_IdFisicalInsert int, @_IdSpace int, @_IdField int, @_Size int, @_Name varchar(50), @_Designation varchar(250), @_Value varchar(5000)
	
	DECLARE cursor1 CURSOR FOR   
	SELECT	ivf.IdFisicalInsert, 
					ivf.IdSpace, 
					ivf.IdField, 
					fvs.Size, 
					fvs.Name, 
					fvs.Designation, 
					ivf.Value
	FROM	OW.tblArchInsertVsForm ivf INNER JOIN
				OW.tblArchFieldsVsSpace fvs ON 
				ivf.IdSpace = fvs.IdSpace AND ivf.IdField = fvs.IdField
	WHERE     (ivf.IdFisicalInsert = @IdFisicalInsert) AND (ivf.IdSpace = @IdSpace)
	ORDER BY ivf.IdFisicalInsert, ivf.IdSpace

	OPEN cursor1
	FETCH NEXT FROM cursor1
	INTO @_IdFisicalInsert, @_IdSpace, @_IdField, @_Size, @_Name, @_Designation, @_Value

	-- First
	SET @_Columns = ''
	SET @_Values = ''''
	
	DECLARE @FETCH int
	SET @FETCH = @@FETCH_STATUS
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @_Columns = @_Columns + @_Name + ' varchar(' + CAST(@_Size AS varchar(8)) + '), '
		SET @_Values = @_Values + @_Value + ''', '''

		FETCH NEXT FROM cursor1
		INTO @_IdFisicalInsert, @_IdSpace, @_IdField, @_Size, @_Name, @_Designation, @_Value
	END

	CLOSE cursor1
	DEALLOCATE cursor1
	
	IF(@FETCH = 0)
	BEGIN
		DECLARE @CreateTable varchar(8000)
		DECLARE @InsertTable varchar(8000)
		
		SET @CreateTable = 'CREATE TABLE ##tmp (IdFisicalInsert int, IdSpace int, ' + LEFT(@_Columns, LEN(@_Columns) - 1) + ')'
		SET @InsertTable = 'INSERT INTO ##tmp VALUES (' + CAST(@_IdFisicalInsert AS varchar(8)) + ', ' + CAST(@_IdSpace AS varchar(8)) + ', ' + LEFT(@_Values, LEN(@_Values) - 3) + ')'
				
		EXEC(@CreateTable)
		EXEC(@InsertTable)
		
		SELECT * FROM ##tmp
		
		DROP TABLE ##tmp
	END
	
	SET ANSI_WARNINGS ON
	SET NOCOUNT OFF

RETURN @@ERROR

END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchInsertVsFormSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ArchInsertVsFormSelectEx01 Error on Creation'
GO

/****************************************************************************************************************/
/* (END)Procedures Archive */ 
/****************************************************************************************************************/

/****************************************************************************************************************/
/* Funções Archive */ 
/****************************************************************************************************************/

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[fnFisicalAccessTypeById]') and xtype in (N'FN', N'IF', N'TF'))
drop function [OW].[fnFisicalAccessTypeById]
GO

CREATE FUNCTION OW.fnFisicalAccessTypeById(@Id int)
RETURNS @Result TABLE (IdFisicalAccessType int, Expanded bit, Selected bit)
AS
BEGIN 
	DECLARE @_Id int, @_IdParent int
	
	DECLARE cTOC CURSOR FOR
		SELECT IdFisicalAccessType
		FROM [OW].[tblArchFisicalAccessType]
		WHERE IdFisicalAccessType = @Id
	FOR READ ONLY
	
	OPEN cTOC
	
	FETCH NEXT FROM cTOC
	INTO @_Id
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	   SET @_IdParent = @_Id
	   INSERT INTO @Result VALUES(@_IdParent, 0, 1)
	   WHILE (@_IdParent > 1)
	   BEGIN
		SELECT @_IdParent = IdParentFAT
		FROM [OW].[tblArchFisicalAccessType]
		WHERE IdFisicalAccessType = @_IdParent
	
		INSERT INTO @Result VALUES(@_IdParent, 1, 0)
	   END
	   FETCH NEXT FROM cTOC
	   INTO @_Id
	END
	
	CLOSE cTOC
	DEALLOCATE cTOC	
	RETURN
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnFisicalAccessTypeById Succeeded'
ELSE PRINT 'Function Creation: [OW].fnFisicalAccessTypeById Error on Creation'
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[fnFisicalInsertById]') and xtype in (N'FN', N'IF', N'TF'))
drop function [OW].[fnFisicalInsertById]
GO

CREATE FUNCTION OW.fnFisicalInsertById(@IdFisicalInsert int)
RETURNS @Result TABLE (IdFisicalInsert int, Expanded bit, Selected bit)
AS
BEGIN 
	DECLARE @_Id int, @_IdParent int
	
	DECLARE cTOC CURSOR FOR
		SELECT IdFisicalInsert
		FROM [OW].[tblArchFisicalInsert]
		WHERE IdFisicalInsert = @IdFisicalInsert
	FOR READ ONLY
	
	OPEN cTOC
	
	FETCH NEXT FROM cTOC
	INTO @_Id
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	   SET @_IdParent = @_Id
	   INSERT INTO @Result VALUES(@_IdParent, 0, 1)
	   WHILE (@_IdParent > 1)
	   BEGIN
		SELECT @_IdParent = IdParentFI
		FROM [OW].[tblArchFisicalInsert]
		WHERE IdFisicalInsert = @_IdParent
	
		INSERT INTO @Result VALUES(@_IdParent, 1, 0)
	   END
	   FETCH NEXT FROM cTOC
	   INTO @_Id
	END
	
	CLOSE cTOC
	DEALLOCATE cTOC	
	RETURN
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnFisicalInsertById Succeeded'
ELSE PRINT 'Function Creation: [OW].fnFisicalInsertById Error on Creation'
GO

/****************************************************************************************************************/
/* (END)Funções Archive */
/****************************************************************************************************************/

/****************************************************************************************************************/
/* Registo de valores Iniciais Archive */ 
/****************************************************************************************************************/

--Space
EXEC OW.ArchSpaceInsert 1, 'ARQ', 'Arquivo', 'Arquivo', '/imagens/fisico/arq.gif'
GO
EXEC OW.ArchSpaceInsert 2, 'EDI', 'Edificio', 'Edifício', '/imagens/fisico/edi.gif'
GO
EXEC OW.ArchSpaceInsert 3, 'PIS', 'Piso', 'Piso', '/imagens/fisico/pis.gif'
GO
EXEC OW.ArchSpaceInsert 4, 'SAL', 'Sala', 'Sala', '/imagens/fisico/sal.gif'
GO
EXEC OW.ArchSpaceInsert 5, 'COR', 'Corredor', 'Corredor', '/imagens/fisico/cor.gif'
GO
EXEC OW.ArchSpaceInsert 6, 'ARM', 'Armario', 'Armário', '/imagens/fisico/arm.gif'
GO
EXEC OW.ArchSpaceInsert 7, 'EST', 'Estante', 'Estante', '/imagens/fisico/est.gif'
GO
EXEC OW.ArchSpaceInsert 8, 'PRA', 'Prateleira', 'Prateleira', '/imagens/fisico/pra.gif'
GO
EXEC OW.ArchSpaceInsert 9, 'PAS', 'Pasta', 'Pasta', '/imagens/fisico/pas.gif'
GO
EXEC OW.ArchSpaceInsert 10, 'UI', 'UnidadeInstalacao', 'Unidade de Instalação', '/imagens/fisico/ui.gif'
GO

--Fields
EXEC OW.ArchFieldsInsert NULL,'Abreviation','Abreviatura','5'
GO
EXEC OW.ArchFieldsInsert NULL,'Name','Nome','250'
GO
EXEC OW.ArchFieldsInsert NULL,'Description','Descrição','500'
GO
EXEC OW.ArchFieldsInsert NULL,'Observation','Observações','5000'
GO
EXEC OW.ArchFieldsInsert NULL,'Country','País','2'
GO
EXEC OW.ArchFieldsInsert NULL,'Address','Morada','300'
GO
EXEC OW.ArchFieldsInsert NULL,'Local','Localidade','250'
GO
EXEC OW.ArchFieldsInsert NULL,'Region','Concelho','250'
GO
EXEC OW.ArchFieldsInsert NULL,'District','Distrito','250'
GO
EXEC OW.ArchFieldsInsert NULL,'PostalCode','Código Postal','4'
GO

--Arquivo
EXEC OW.ArchFieldsVsSpaceInsertEx01 1,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 1,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 1,4,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 1,5,NULL,NULL,NULL,1,1,0,NULL
GO
--Edifício
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,4,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,6,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,7,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,8,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,9,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 2,10,NULL,NULL,NULL,1,1,0,NULL
GO
--Piso
EXEC OW.ArchFieldsVsSpaceInsertEx01 3,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 3,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 3,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 3,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Sala
EXEC OW.ArchFieldsVsSpaceInsertEx01 4,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 4,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 4,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 4,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Corredor
EXEC OW.ArchFieldsVsSpaceInsertEx01 5,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 5,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 5,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 5,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Armário
EXEC OW.ArchFieldsVsSpaceInsertEx01 6,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 6,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 6,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 6,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Estante
EXEC OW.ArchFieldsVsSpaceInsertEx01 7,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 7,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 7,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 7,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Prateleira
EXEC OW.ArchFieldsVsSpaceInsertEx01 8,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 8,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 8,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 8,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Pasta
EXEC OW.ArchFieldsVsSpaceInsertEx01 9,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 9,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 9,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 9,4,NULL,NULL,NULL,1,1,0,NULL
GO
--Unidade de Instalação
EXEC OW.ArchFieldsVsSpaceInsertEx01 10,1,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 10,2,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 10,3,NULL,NULL,NULL,1,1,0,NULL
GO
EXEC OW.ArchFieldsVsSpaceInsertEx01 10,4,NULL,NULL,NULL,1,1,0,NULL
GO

--FisicalType
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 1, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 2, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 3, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 4, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 5, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 6, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 7, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 8, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 9, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO
EXEC OW.ArchFisicalTypeInsertEx01 DEFAULT, 10, DEFAULT, DEFAULT, 0, DEFAULT, DEFAULT, DEFAULT, DEFAULT
GO

--IdentityCB
EXEC OW.IdentityCBInsert 1, 'Registo'
GO
EXEC OW.IdentityCBInsert 2, 'FisicalSpaces'
GO
/****************************************************************************************************************/
/* (END) Registo de valores Iniciais Archive */ 
/****************************************************************************************************************/




--*************************************************************
--     
-- Name: StringToTable 
-- Description:
-- Converts all items of a string delimited by a character into 
-- table rows.
--
-- Inputs:
-- String - string to convert in format {item [<delimiter> item] }.
-- Delimiter - character that delimit each item
--
-- Returns:
-- A table with a row for each item found between 
-- the delimiter specified
-- 
-- Example:
-- select * from Split('20,31,14,abc',',')
-- ID Item
-- 1  20
-- 2  31
-- 3  14
-- 4  abc
--*************************************************************

CREATE FUNCTION OW.StringToTable (@String varchar(8000), @Delimiter char(1))
RETURNS @Results TABLE (ID numeric(18) IDENTITY, Item varchar(8000))
AS

BEGIN

    DECLARE @Index INT
    DECLARE @Item varchar(8000)
   

    IF @String IS NULL OR LEN(@String)=0
	RETURN

    -- Set @Index to a value differente of zero to go inside the loop for the first time
    SELECT @Index = -1

    WHILE @Index !=0
    BEGIN	

        -- Get the Index of the first occurence of the Delimiter
        SELECT @Index = CHARINDEX(@Delimiter, @String )

        -- Get the Item until Delimiter
        IF @Index !=0
        	SELECT @Item = LEFT(@String ,@Index - 1)
        ELSE
        	SELECT @Item = @String  -- Last time

        -- Put the Item into the results set
        INSERT INTO @Results(Item) VALUES(@Item )

        -- Remove the Item from the String
        SELECT @String = RIGHT(@String ,LEN(@String ) - @Index )

        -- Break the loop if no more Items
        IF LEN(@String ) = 0 BREAK

    END
    RETURN
END
GO



/****************************************************************************************************************/
/* Procedures OfficeWorks.Data.OWRegistry */ 
/****************************************************************************************************************/

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationBooksSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationBooksSelect;
GO

CREATE PROCEDURE [OW].ClassificationBooksSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-03-2006 17:26:08
	--Version: 1.2	
	------------------------------------------------------------------------
	@ClassBookID numeric(18,0) = NULL,
	@ClassID numeric(18,0) = NULL,
	@BookID numeric(18,0) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ClassBookID],
		[ClassID],
		[BookID]
	FROM [OW].[tblClassificationBooks]
	WHERE
		(@ClassBookID IS NULL OR [ClassBookID] = @ClassBookID) AND
		(@ClassID IS NULL OR [ClassID] = @ClassID) AND
		(@BookID IS NULL OR [BookID] = @BookID)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationBooksSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationBooksSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationBooksSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationBooksSelectPaging;
GO

CREATE PROCEDURE [OW].ClassificationBooksSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-03-2006 17:26:08
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassBookID numeric(18,0) = NULL,
	@ClassID numeric(18,0) = NULL,
	@BookID numeric(18,0) = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)	
	SET @WHERE = ''
	
	IF(@ClassBookID IS NOT NULL) SET @WHERE = @WHERE + '([ClassBookID] = @ClassBookID) AND '
	IF(@ClassID IS NOT NULL) SET @WHERE = @WHERE + '([ClassID] = @ClassID) AND '
	IF(@BookID IS NOT NULL) SET @WHERE = @WHERE + '([BookID] = @BookID) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ClassBookID) 
	FROM [OW].[tblClassificationBooks]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ClassBookID numeric(18,0), 
		@ClassID numeric(18,0), 
		@BookID numeric(18,0),
		@RowCount bigint OUTPUT',
		@ClassBookID, 
		@ClassID, 
		@BookID,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE ClassBookID IN (
		SELECT TOP ' + @SizeString + ' ClassBookID
			FROM [OW].[tblClassificationBooks]
			WHERE ClassBookID NOT IN (
				SELECT TOP ' + @PrevString + ' ClassBookID 
				FROM [OW].[tblClassificationBooks]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ClassBookID], 
		[ClassID], 
		[BookID]
	FROM [OW].[tblClassificationBooks]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ClassBookID numeric(18,0), 
		@ClassID numeric(18,0), 
		@BookID numeric(18,0)',
		@ClassBookID, 
		@ClassID, 
		@BookID
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationBooksSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationBooksSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationBooksUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationBooksUpdate;
GO

CREATE PROCEDURE [OW].ClassificationBooksUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-03-2006 17:26:08
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassBookID numeric(18,0),
	@ClassID numeric(18,0),
	@BookID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblClassificationBooks]
	SET
		[ClassID] = @ClassID,
		[BookID] = @BookID
	WHERE
		[ClassBookID] = @ClassBookID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationBooksUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationBooksUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationBooksInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationBooksInsert;
GO

CREATE PROCEDURE [OW].ClassificationBooksInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-03-2006 17:26:08
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassBookID numeric(18,0) = NULL OUTPUT,
	@ClassID numeric(18,0),
	@BookID numeric(18,0)
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblClassificationBooks]
	(
		[ClassID],
		[BookID]
	)
	VALUES
	(
		@ClassID,
		@BookID
	)	
	SELECT @ClassBookID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationBooksInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationBooksInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationBooksDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationBooksDelete;
GO

CREATE PROCEDURE [OW].ClassificationBooksDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-03-2006 17:26:08
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassBookID numeric(18,0) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblClassificationBooks]
	WHERE
		[ClassBookID] = @ClassBookID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationBooksDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationBooksDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].BooksSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].BooksSelect;
GO

CREATE PROCEDURE [OW].BooksSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:33
	--Version: 1.2	
	------------------------------------------------------------------------
	@bookID numeric(18,0) = NULL,
	@abreviation nvarchar(20) = NULL,
	@designation nvarchar(100) = NULL,
	@automatic bit = NULL,
	@hierarchical bit = NULL,
	@Duplicated bit = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[bookID],
		[abreviation],
		[designation],
		[automatic],
		[hierarchical],
		[Duplicated]
	FROM [OW].[tblBooks]
	WHERE
		(@bookID IS NULL OR [bookID] = @bookID) AND
		(@abreviation IS NULL OR [abreviation] LIKE @abreviation) AND
		(@designation IS NULL OR [designation] LIKE @designation) AND
		(@automatic IS NULL OR [automatic] = @automatic) AND
		(@hierarchical IS NULL OR [hierarchical] = @hierarchical) AND
		(@Duplicated IS NULL OR [Duplicated] = @Duplicated)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].BooksSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].BooksSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].BooksSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].BooksSelectPaging;
GO

CREATE PROCEDURE [OW].BooksSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@bookID numeric(18,0) = NULL,
	@abreviation nvarchar(20) = NULL,
	@designation nvarchar(100) = NULL,
	@automatic bit = NULL,
	@hierarchical bit = NULL,
	@Duplicated bit = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)	
	SET @WHERE = ''
	
	IF(@bookID IS NOT NULL) SET @WHERE = @WHERE + '([bookID] = @bookID) AND '
	IF(@abreviation IS NOT NULL) SET @WHERE = @WHERE + '([abreviation] LIKE @abreviation) AND '
	IF(@designation IS NOT NULL) SET @WHERE = @WHERE + '([designation] LIKE @designation) AND '
	IF(@automatic IS NOT NULL) SET @WHERE = @WHERE + '([automatic] = @automatic) AND '
	IF(@hierarchical IS NOT NULL) SET @WHERE = @WHERE + '([hierarchical] = @hierarchical) AND '
	IF(@Duplicated IS NOT NULL) SET @WHERE = @WHERE + '([Duplicated] = @Duplicated) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(bookID) 
	FROM [OW].[tblBooks]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@bookID numeric(18,0), 
		@abreviation nvarchar(20), 
		@designation nvarchar(100), 
		@automatic bit, 
		@hierarchical bit, 
		@Duplicated bit,
		@RowCount bigint OUTPUT',
		@bookID, 
		@abreviation, 
		@designation, 
		@automatic, 
		@hierarchical, 
		@Duplicated,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE bookID IN (
		SELECT TOP ' + @SizeString + ' bookID
			FROM [OW].[tblBooks]
			WHERE bookID NOT IN (
				SELECT TOP ' + @PrevString + ' bookID 
				FROM [OW].[tblBooks]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[bookID], 
		[abreviation], 
		[designation], 
		[automatic], 
		[hierarchical], 
		[Duplicated]
	FROM [OW].[tblBooks]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@bookID numeric(18,0), 
		@abreviation nvarchar(20), 
		@designation nvarchar(100), 
		@automatic bit, 
		@hierarchical bit, 
		@Duplicated bit',
		@bookID, 
		@abreviation, 
		@designation, 
		@automatic, 
		@hierarchical, 
		@Duplicated
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].BooksSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].BooksSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].BooksUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].BooksUpdate;
GO

CREATE PROCEDURE [OW].BooksUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@bookID numeric(18,0),
	@abreviation nvarchar(20),
	@designation nvarchar(100),
	@automatic bit,
	@hierarchical bit,
	@Duplicated bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblBooks]
	SET
		[abreviation] = @abreviation,
		[designation] = @designation,
		[automatic] = @automatic,
		[hierarchical] = @hierarchical,
		[Duplicated] = @Duplicated
	WHERE
		[bookID] = @bookID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].BooksUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].BooksUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].BooksInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].BooksInsert;
GO

CREATE PROCEDURE [OW].BooksInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@bookID numeric(18,0) = NULL OUTPUT,
	@abreviation nvarchar(20),
	@designation nvarchar(100),
	@automatic bit,
	@hierarchical bit,
	@Duplicated bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblBooks]
	(
		[abreviation],
		[designation],
		[automatic],
		[hierarchical],
		[Duplicated]
	)
	VALUES
	(
		@abreviation,
		@designation,
		@automatic,
		@hierarchical,
		@Duplicated
	)	
	SELECT @bookID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].BooksInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].BooksInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].BooksDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].BooksDelete;
GO

CREATE PROCEDURE [OW].BooksDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@bookID numeric(18,0) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblBooks]
	WHERE
		[bookID] = @bookID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].BooksDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].BooksDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationSelect;
GO

CREATE PROCEDURE [OW].ClassificationSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.2	
	------------------------------------------------------------------------
	@ClassificationID int = NULL,
	@ParentID int = NULL,
	@Level smallint = NULL,
	@Code varchar(50) = NULL,
	@Description varchar(250) = NULL,
	@Global bit = NULL,
	@Scope smallint = NULL,
	@Remarks varchar(255) = NULL,
	@InsertedBy varchar(50) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(50) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ClassificationID],
		[ParentID],
		[Level],
		[Code],
		[Description],
		[Global],
		[Scope],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblClassification]
	WHERE
		(@ClassificationID IS NULL OR [ClassificationID] = @ClassificationID) AND
		(@ParentID IS NULL OR [ParentID] = @ParentID) AND
		(@Level IS NULL OR [Level] = @Level) AND
		(@Code IS NULL OR [Code] LIKE @Code) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Global IS NULL OR [Global] = @Global) AND
		(@Scope IS NULL OR [Scope] = @Scope) AND
		(@Remarks IS NULL OR [Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationSelectPaging;
GO

CREATE PROCEDURE [OW].ClassificationSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassificationID int = NULL,
	@ParentID int = NULL,
	@Level smallint = NULL,
	@Code varchar(50) = NULL,
	@Description varchar(250) = NULL,
	@Global bit = NULL,
	@Scope smallint = NULL,
	@Remarks varchar(255) = NULL,
	@InsertedBy varchar(50) = NULL,
	@InsertedOn datetime = NULL,
	@LastModifiedBy varchar(50) = NULL,
	@LastModifiedOn datetime = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)	
	SET @WHERE = ''
	
	IF(@ClassificationID IS NOT NULL) SET @WHERE = @WHERE + '([ClassificationID] = @ClassificationID) AND '
	IF(@ParentID IS NOT NULL) SET @WHERE = @WHERE + '([ParentID] = @ParentID) AND '
	IF(@Level IS NOT NULL) SET @WHERE = @WHERE + '([Level] = @Level) AND '
	IF(@Code IS NOT NULL) SET @WHERE = @WHERE + '([Code] LIKE @Code) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Global IS NOT NULL) SET @WHERE = @WHERE + '([Global] = @Global) AND '
	IF(@Scope IS NOT NULL) SET @WHERE = @WHERE + '([Scope] = @Scope) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ClassificationID) 
	FROM [OW].[tblClassification]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ClassificationID int, 
		@ParentID int, 
		@Level smallint, 
		@Code varchar(50), 
		@Description varchar(250), 
		@Global bit, 
		@Scope smallint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ClassificationID, 
		@ParentID, 
		@Level, 
		@Code, 
		@Description, 
		@Global, 
		@Scope, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE ClassificationID IN (
		SELECT TOP ' + @SizeString + ' ClassificationID
			FROM [OW].[tblClassification]
			WHERE ClassificationID NOT IN (
				SELECT TOP ' + @PrevString + ' ClassificationID 
				FROM [OW].[tblClassification]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ClassificationID], 
		[ParentID], 
		[Level], 
		[Code], 
		[Description], 
		[Global], 
		[Scope], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblClassification]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ClassificationID int, 
		@ParentID int, 
		@Level smallint, 
		@Code varchar(50), 
		@Description varchar(250), 
		@Global bit, 
		@Scope smallint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ClassificationID, 
		@ParentID, 
		@Level, 
		@Code, 
		@Description, 
		@Global, 
		@Scope, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationUpdate;
GO

CREATE PROCEDURE [OW].ClassificationUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassificationID int,
	@ParentID int = NULL,
	@Level smallint,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit,
	@Scope smallint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblClassification]
	SET
		[ParentID] = @ParentID,
		[Level] = @Level,
		[Code] = @Code,
		[Description] = @Description,
		[Global] = @Global,
		[Scope] = @Scope,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ClassificationID] = @ClassificationID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationInsert;
GO

CREATE PROCEDURE [OW].ClassificationInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassificationID int = NULL OUTPUT,
	@ParentID int = NULL,
	@Level smallint,
	@Code varchar(50),
	@Description varchar(250),
	@Global bit,
	@Scope smallint,
	@Remarks varchar(255) = NULL,
	@InsertedBy varchar(50),
	@InsertedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblClassification]
	(
		[ParentID],
		[Level],
		[Code],
		[Description],
		[Global],
		[Scope],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ParentID,
		@Level,
		@Code,
		@Description,
		@Global,
		@Scope,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ClassificationID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationDelete;
GO

CREATE PROCEDURE [OW].ClassificationDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@ClassificationID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblClassification]
	WHERE
		[ClassificationID] = @ClassificationID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelect;
GO

CREATE PROCEDURE [OW].RegistrySelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.2	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0) = NULL,
	@year numeric(18,0) = NULL,
	@number numeric(18,0) = NULL,
	@date datetime = NULL,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit = NULL,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[regid],
		[doctypeid],
		[bookid],
		[year],
		[number],
		[date],
		[originref],
		[origindate],
		[subject],
		[observations],
		[processnumber],
		[cota],
		[bloco],
		[classid],
		[userID],
		[AntecedenteID],
		[entID],
		[UserModifyID],
		[DateModify],
		[historic],
		[field1],
		[field2],
		[activeDate],
		[IdIdentityCB],
		[Barcode],
		[ProdEntityID],
		[FundoID],
		[SerieID],
		[FisicalID]
	FROM [OW].[tblRegistry]
	WHERE
		(@regid IS NULL OR [regid] = @regid) AND
		(@doctypeid IS NULL OR [doctypeid] = @doctypeid) AND
		(@bookid IS NULL OR [bookid] = @bookid) AND
		(@year IS NULL OR [year] = @year) AND
		(@number IS NULL OR [number] = @number) AND
		(@date IS NULL OR [date] = @date) AND
		(@originref IS NULL OR [originref] LIKE @originref) AND
		(@origindate IS NULL OR [origindate] = @origindate) AND
		(@subject IS NULL OR [subject] LIKE @subject) AND
		(@observations IS NULL OR [observations] LIKE @observations) AND
		(@processnumber IS NULL OR [processnumber] LIKE @processnumber) AND
		(@cota IS NULL OR [cota] LIKE @cota) AND
		(@bloco IS NULL OR [bloco] LIKE @bloco) AND
		(@classid IS NULL OR [classid] = @classid) AND
		(@userID IS NULL OR [userID] = @userID) AND
		(@AntecedenteID IS NULL OR [AntecedenteID] = @AntecedenteID) AND
		(@entID IS NULL OR [entID] = @entID) AND
		(@UserModifyID IS NULL OR [UserModifyID] = @UserModifyID) AND
		(@DateModify IS NULL OR [DateModify] = @DateModify) AND
		(@historic IS NULL OR [historic] = @historic) AND
		(@field1 IS NULL OR [field1] = @field1) AND
		(@field2 IS NULL OR [field2] LIKE @field2) AND
		(@activeDate IS NULL OR [activeDate] = @activeDate) AND
		(@IdIdentityCB IS NULL OR [IdIdentityCB] = @IdIdentityCB) AND
		(@Barcode IS NULL OR [Barcode] = @Barcode) AND
		(@ProdEntityID IS NULL OR [ProdEntityID] = @ProdEntityID) AND
		(@FundoID IS NULL OR [FundoID] = @FundoID) AND
		(@SerieID IS NULL OR [SerieID] = @SerieID) AND
		(@FisicalID IS NULL OR [FisicalID] = @FisicalID)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectPaging;
GO

CREATE PROCEDURE [OW].RegistrySelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0) = NULL,
	@year numeric(18,0) = NULL,
	@number numeric(18,0) = NULL,
	@date datetime = NULL,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit = NULL,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)	
	SET @WHERE = ''
	
	IF(@regid IS NOT NULL) SET @WHERE = @WHERE + '([regid] = @regid) AND '
	IF(@doctypeid IS NOT NULL) SET @WHERE = @WHERE + '([doctypeid] = @doctypeid) AND '
	IF(@bookid IS NOT NULL) SET @WHERE = @WHERE + '([bookid] = @bookid) AND '
	IF(@year IS NOT NULL) SET @WHERE = @WHERE + '([year] = @year) AND '
	IF(@number IS NOT NULL) SET @WHERE = @WHERE + '([number] = @number) AND '
	IF(@date IS NOT NULL) SET @WHERE = @WHERE + '([date] = @date) AND '
	IF(@originref IS NOT NULL) SET @WHERE = @WHERE + '([originref] LIKE @originref) AND '
	IF(@origindate IS NOT NULL) SET @WHERE = @WHERE + '([origindate] = @origindate) AND '
	IF(@subject IS NOT NULL) SET @WHERE = @WHERE + '([subject] LIKE @subject) AND '
	IF(@observations IS NOT NULL) SET @WHERE = @WHERE + '([observations] LIKE @observations) AND '
	IF(@processnumber IS NOT NULL) SET @WHERE = @WHERE + '([processnumber] LIKE @processnumber) AND '
	IF(@cota IS NOT NULL) SET @WHERE = @WHERE + '([cota] LIKE @cota) AND '
	IF(@bloco IS NOT NULL) SET @WHERE = @WHERE + '([bloco] LIKE @bloco) AND '
	IF(@classid IS NOT NULL) SET @WHERE = @WHERE + '([classid] = @classid) AND '
	IF(@userID IS NOT NULL) SET @WHERE = @WHERE + '([userID] = @userID) AND '
	IF(@AntecedenteID IS NOT NULL) SET @WHERE = @WHERE + '([AntecedenteID] = @AntecedenteID) AND '
	IF(@entID IS NOT NULL) SET @WHERE = @WHERE + '([entID] = @entID) AND '
	IF(@UserModifyID IS NOT NULL) SET @WHERE = @WHERE + '([UserModifyID] = @UserModifyID) AND '
	IF(@DateModify IS NOT NULL) SET @WHERE = @WHERE + '([DateModify] = @DateModify) AND '
	IF(@historic IS NOT NULL) SET @WHERE = @WHERE + '([historic] = @historic) AND '
	IF(@field1 IS NOT NULL) SET @WHERE = @WHERE + '([field1] = @field1) AND '
	IF(@field2 IS NOT NULL) SET @WHERE = @WHERE + '([field2] LIKE @field2) AND '
	IF(@activeDate IS NOT NULL) SET @WHERE = @WHERE + '([activeDate] = @activeDate) AND '
	IF(@IdIdentityCB IS NOT NULL) SET @WHERE = @WHERE + '([IdIdentityCB] = @IdIdentityCB) AND '
	IF(@Barcode IS NOT NULL) SET @WHERE = @WHERE + '([Barcode] = @Barcode) AND '
	IF(@ProdEntityID IS NOT NULL) SET @WHERE = @WHERE + '([ProdEntityID] = @ProdEntityID) AND '
	IF(@FundoID IS NOT NULL) SET @WHERE = @WHERE + '([FundoID] = @FundoID) AND '
	IF(@SerieID IS NOT NULL) SET @WHERE = @WHERE + '([SerieID] = @SerieID) AND '
	IF(@FisicalID IS NOT NULL) SET @WHERE = @WHERE + '([FisicalID] = @FisicalID) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(regid) 
	FROM [OW].[tblRegistry]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@regid numeric(18,0), 
		@doctypeid numeric(18,0), 
		@bookid numeric(18,0), 
		@year numeric(18,0), 
		@number numeric(18,0), 
		@date datetime, 
		@originref varchar(30), 
		@origindate datetime, 
		@subject nvarchar(250), 
		@observations nvarchar(250), 
		@processnumber nvarchar(50), 
		@cota nvarchar(50), 
		@bloco nvarchar(50), 
		@classid int, 
		@userID int, 
		@AntecedenteID numeric(18,0), 
		@entID numeric(18,0), 
		@UserModifyID int, 
		@DateModify datetime, 
		@historic bit, 
		@field1 float, 
		@field2 nvarchar(50), 
		@activeDate datetime, 
		@IdIdentityCB int, 
		@Barcode uniqueidentifier, 
		@ProdEntityID numeric(18,0), 
		@FundoID decimal(18,0), 
		@SerieID decimal(18,0), 
		@FisicalID int,
		@RowCount bigint OUTPUT',
		@regid, 
		@doctypeid, 
		@bookid, 
		@year, 
		@number, 
		@date, 
		@originref, 
		@origindate, 
		@subject, 
		@observations, 
		@processnumber, 
		@cota, 
		@bloco, 
		@classid, 
		@userID, 
		@AntecedenteID, 
		@entID, 
		@UserModifyID, 
		@DateModify, 
		@historic, 
		@field1, 
		@field2, 
		@activeDate, 
		@IdIdentityCB, 
		@Barcode, 
		@ProdEntityID, 
		@FundoID, 
		@SerieID, 
		@FisicalID,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE regid IN (
		SELECT TOP ' + @SizeString + ' regid
			FROM [OW].[tblRegistry]
			WHERE regid NOT IN (
				SELECT TOP ' + @PrevString + ' regid 
				FROM [OW].[tblRegistry]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[regid], 
		[doctypeid], 
		[bookid], 
		[year], 
		[number], 
		[date], 
		[originref], 
		[origindate], 
		[subject], 
		[observations], 
		[processnumber], 
		[cota], 
		[bloco], 
		[classid], 
		[userID], 
		[AntecedenteID], 
		[entID], 
		[UserModifyID], 
		[DateModify], 
		[historic], 
		[field1], 
		[field2], 
		[activeDate], 
		[IdIdentityCB], 
		[Barcode], 
		[ProdEntityID], 
		[FundoID], 
		[SerieID], 
		[FisicalID]
	FROM [OW].[tblRegistry]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@regid numeric(18,0), 
		@doctypeid numeric(18,0), 
		@bookid numeric(18,0), 
		@year numeric(18,0), 
		@number numeric(18,0), 
		@date datetime, 
		@originref varchar(30), 
		@origindate datetime, 
		@subject nvarchar(250), 
		@observations nvarchar(250), 
		@processnumber nvarchar(50), 
		@cota nvarchar(50), 
		@bloco nvarchar(50), 
		@classid int, 
		@userID int, 
		@AntecedenteID numeric(18,0), 
		@entID numeric(18,0), 
		@UserModifyID int, 
		@DateModify datetime, 
		@historic bit, 
		@field1 float, 
		@field2 nvarchar(50), 
		@activeDate datetime, 
		@IdIdentityCB int, 
		@Barcode uniqueidentifier, 
		@ProdEntityID numeric(18,0), 
		@FundoID decimal(18,0), 
		@SerieID decimal(18,0), 
		@FisicalID int',
		@regid, 
		@doctypeid, 
		@bookid, 
		@year, 
		@number, 
		@date, 
		@originref, 
		@origindate, 
		@subject, 
		@observations, 
		@processnumber, 
		@cota, 
		@bloco, 
		@classid, 
		@userID, 
		@AntecedenteID, 
		@entID, 
		@UserModifyID, 
		@DateModify, 
		@historic, 
		@field1, 
		@field2, 
		@activeDate, 
		@IdIdentityCB, 
		@Barcode, 
		@ProdEntityID, 
		@FundoID, 
		@SerieID, 
		@FisicalID
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryUpdate;
GO

CREATE PROCEDURE [OW].RegistryUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0),
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0),
	@year numeric(18,0),
	@number numeric(18,0),
	@date datetime,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblRegistry]
	SET
		[doctypeid] = @doctypeid,
		[bookid] = @bookid,
		[year] = @year,
		[number] = @number,
		[date] = @date,
		[originref] = @originref,
		[origindate] = @origindate,
		[subject] = @subject,
		[observations] = @observations,
		[processnumber] = @processnumber,
		[cota] = @cota,
		[bloco] = @bloco,
		[classid] = @classid,
		[userID] = @userID,
		[AntecedenteID] = @AntecedenteID,
		[entID] = @entID,
		[UserModifyID] = @UserModifyID,
		[DateModify] = @DateModify,
		[historic] = @historic,
		[field1] = @field1,
		[field2] = @field2,
		[activeDate] = @activeDate,
		[IdIdentityCB] = @IdIdentityCB,
		[Barcode] = @Barcode,
		[ProdEntityID] = @ProdEntityID,
		[FundoID] = @FundoID,
		[SerieID] = @SerieID,
		[FisicalID] = @FisicalID
	WHERE
		[regid] = @regid
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryInsert;
GO

CREATE PROCEDURE [OW].RegistryInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL OUTPUT,
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0),
	@year numeric(18,0),
	@number numeric(18,0),
	@date datetime,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblRegistry]
	(
		[doctypeid],
		[bookid],
		[year],
		[number],
		[date],
		[originref],
		[origindate],
		[subject],
		[observations],
		[processnumber],
		[cota],
		[bloco],
		[classid],
		[userID],
		[AntecedenteID],
		[entID],
		[UserModifyID],
		[DateModify],
		[historic],
		[field1],
		[field2],
		[activeDate],
		[IdIdentityCB],
		[Barcode],
		[ProdEntityID],
		[FundoID],
		[SerieID],
		[FisicalID]
	)
	VALUES
	(
		@doctypeid,
		@bookid,
		@year,
		@number,
		@date,
		@originref,
		@origindate,
		@subject,
		@observations,
		@processnumber,
		@cota,
		@bloco,
		@classid,
		@userID,
		@AntecedenteID,
		@entID,
		@UserModifyID,
		@DateModify,
		@historic,
		@field1,
		@field2,
		@activeDate,
		@IdIdentityCB,
		@Barcode,
		@ProdEntityID,
		@FundoID,
		@SerieID,
		@FisicalID
	)	
	SELECT @regid = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryDelete;
GO

CREATE PROCEDURE [OW].RegistryDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRegistry]
	WHERE
		[regid] = @regid
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistSelect;
GO

CREATE PROCEDURE [OW].RegistryHistSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.2	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0) = NULL,
	@year numeric(18,0) = NULL,
	@number numeric(18,0) = NULL,
	@date datetime = NULL,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit = NULL,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[regid],
		[doctypeid],
		[bookid],
		[year],
		[number],
		[date],
		[originref],
		[origindate],
		[subject],
		[observations],
		[processnumber],
		[cota],
		[bloco],
		[classid],
		[userID],
		[AntecedenteID],
		[entID],
		[UserModifyID],
		[DateModify],
		[historic],
		[field1],
		[field2],
		[activeDate],
		[IdIdentityCB],
		[Barcode],
		[ProdEntityID],
		[FundoID],
		[SerieID],
		[FisicalID]
	FROM [OW].[tblRegistryHist]
	WHERE
		(@regid IS NULL OR [regid] = @regid) AND
		(@doctypeid IS NULL OR [doctypeid] = @doctypeid) AND
		(@bookid IS NULL OR [bookid] = @bookid) AND
		(@year IS NULL OR [year] = @year) AND
		(@number IS NULL OR [number] = @number) AND
		(@date IS NULL OR [date] = @date) AND
		(@originref IS NULL OR [originref] LIKE @originref) AND
		(@origindate IS NULL OR [origindate] = @origindate) AND
		(@subject IS NULL OR [subject] LIKE @subject) AND
		(@observations IS NULL OR [observations] LIKE @observations) AND
		(@processnumber IS NULL OR [processnumber] LIKE @processnumber) AND
		(@cota IS NULL OR [cota] LIKE @cota) AND
		(@bloco IS NULL OR [bloco] LIKE @bloco) AND
		(@classid IS NULL OR [classid] = @classid) AND
		(@userID IS NULL OR [userID] = @userID) AND
		(@AntecedenteID IS NULL OR [AntecedenteID] = @AntecedenteID) AND
		(@entID IS NULL OR [entID] = @entID) AND
		(@UserModifyID IS NULL OR [UserModifyID] = @UserModifyID) AND
		(@DateModify IS NULL OR [DateModify] = @DateModify) AND
		(@historic IS NULL OR [historic] = @historic) AND
		(@field1 IS NULL OR [field1] = @field1) AND
		(@field2 IS NULL OR [field2] LIKE @field2) AND
		(@activeDate IS NULL OR [activeDate] = @activeDate) AND
		(@IdIdentityCB IS NULL OR [IdIdentityCB] = @IdIdentityCB) AND
		(@Barcode IS NULL OR [Barcode] = @Barcode) AND
		(@ProdEntityID IS NULL OR [ProdEntityID] = @ProdEntityID) AND
		(@FundoID IS NULL OR [FundoID] = @FundoID) AND
		(@SerieID IS NULL OR [SerieID] = @SerieID) AND
		(@FisicalID IS NULL OR [FisicalID] = @FisicalID)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistSelectPaging;
GO

CREATE PROCEDURE [OW].RegistryHistSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0) = NULL,
	@year numeric(18,0) = NULL,
	@number numeric(18,0) = NULL,
	@date datetime = NULL,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit = NULL,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)	
	SET @WHERE = ''
	
	IF(@regid IS NOT NULL) SET @WHERE = @WHERE + '([regid] = @regid) AND '
	IF(@doctypeid IS NOT NULL) SET @WHERE = @WHERE + '([doctypeid] = @doctypeid) AND '
	IF(@bookid IS NOT NULL) SET @WHERE = @WHERE + '([bookid] = @bookid) AND '
	IF(@year IS NOT NULL) SET @WHERE = @WHERE + '([year] = @year) AND '
	IF(@number IS NOT NULL) SET @WHERE = @WHERE + '([number] = @number) AND '
	IF(@date IS NOT NULL) SET @WHERE = @WHERE + '([date] = @date) AND '
	IF(@originref IS NOT NULL) SET @WHERE = @WHERE + '([originref] LIKE @originref) AND '
	IF(@origindate IS NOT NULL) SET @WHERE = @WHERE + '([origindate] = @origindate) AND '
	IF(@subject IS NOT NULL) SET @WHERE = @WHERE + '([subject] LIKE @subject) AND '
	IF(@observations IS NOT NULL) SET @WHERE = @WHERE + '([observations] LIKE @observations) AND '
	IF(@processnumber IS NOT NULL) SET @WHERE = @WHERE + '([processnumber] LIKE @processnumber) AND '
	IF(@cota IS NOT NULL) SET @WHERE = @WHERE + '([cota] LIKE @cota) AND '
	IF(@bloco IS NOT NULL) SET @WHERE = @WHERE + '([bloco] LIKE @bloco) AND '
	IF(@classid IS NOT NULL) SET @WHERE = @WHERE + '([classid] = @classid) AND '
	IF(@userID IS NOT NULL) SET @WHERE = @WHERE + '([userID] = @userID) AND '
	IF(@AntecedenteID IS NOT NULL) SET @WHERE = @WHERE + '([AntecedenteID] = @AntecedenteID) AND '
	IF(@entID IS NOT NULL) SET @WHERE = @WHERE + '([entID] = @entID) AND '
	IF(@UserModifyID IS NOT NULL) SET @WHERE = @WHERE + '([UserModifyID] = @UserModifyID) AND '
	IF(@DateModify IS NOT NULL) SET @WHERE = @WHERE + '([DateModify] = @DateModify) AND '
	IF(@historic IS NOT NULL) SET @WHERE = @WHERE + '([historic] = @historic) AND '
	IF(@field1 IS NOT NULL) SET @WHERE = @WHERE + '([field1] = @field1) AND '
	IF(@field2 IS NOT NULL) SET @WHERE = @WHERE + '([field2] LIKE @field2) AND '
	IF(@activeDate IS NOT NULL) SET @WHERE = @WHERE + '([activeDate] = @activeDate) AND '
	IF(@IdIdentityCB IS NOT NULL) SET @WHERE = @WHERE + '([IdIdentityCB] = @IdIdentityCB) AND '
	IF(@Barcode IS NOT NULL) SET @WHERE = @WHERE + '([Barcode] = @Barcode) AND '
	IF(@ProdEntityID IS NOT NULL) SET @WHERE = @WHERE + '([ProdEntityID] = @ProdEntityID) AND '
	IF(@FundoID IS NOT NULL) SET @WHERE = @WHERE + '([FundoID] = @FundoID) AND '
	IF(@SerieID IS NOT NULL) SET @WHERE = @WHERE + '([SerieID] = @SerieID) AND '
	IF(@FisicalID IS NOT NULL) SET @WHERE = @WHERE + '([FisicalID] = @FisicalID) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(regid) 
	FROM [OW].[tblRegistryHist]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@regid numeric(18,0), 
		@doctypeid numeric(18,0), 
		@bookid numeric(18,0), 
		@year numeric(18,0), 
		@number numeric(18,0), 
		@date datetime, 
		@originref varchar(30), 
		@origindate datetime, 
		@subject nvarchar(250), 
		@observations nvarchar(250), 
		@processnumber nvarchar(50), 
		@cota nvarchar(50), 
		@bloco nvarchar(50), 
		@classid int, 
		@userID int, 
		@AntecedenteID numeric(18,0), 
		@entID numeric(18,0), 
		@UserModifyID int, 
		@DateModify datetime, 
		@historic bit, 
		@field1 float, 
		@field2 nvarchar(50), 
		@activeDate datetime, 
		@IdIdentityCB int, 
		@Barcode uniqueidentifier, 
		@ProdEntityID numeric(18,0), 
		@FundoID decimal(18,0), 
		@SerieID decimal(18,0), 
		@FisicalID int,
		@RowCount bigint OUTPUT',
		@regid, 
		@doctypeid, 
		@bookid, 
		@year, 
		@number, 
		@date, 
		@originref, 
		@origindate, 
		@subject, 
		@observations, 
		@processnumber, 
		@cota, 
		@bloco, 
		@classid, 
		@userID, 
		@AntecedenteID, 
		@entID, 
		@UserModifyID, 
		@DateModify, 
		@historic, 
		@field1, 
		@field2, 
		@activeDate, 
		@IdIdentityCB, 
		@Barcode, 
		@ProdEntityID, 
		@FundoID, 
		@SerieID, 
		@FisicalID,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE regid IN (
		SELECT TOP ' + @SizeString + ' regid
			FROM [OW].[tblRegistryHist]
			WHERE regid NOT IN (
				SELECT TOP ' + @PrevString + ' regid 
				FROM [OW].[tblRegistryHist]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[regid], 
		[doctypeid], 
		[bookid], 
		[year], 
		[number], 
		[date], 
		[originref], 
		[origindate], 
		[subject], 
		[observations], 
		[processnumber], 
		[cota], 
		[bloco], 
		[classid], 
		[userID], 
		[AntecedenteID], 
		[entID], 
		[UserModifyID], 
		[DateModify], 
		[historic], 
		[field1], 
		[field2], 
		[activeDate], 
		[IdIdentityCB], 
		[Barcode], 
		[ProdEntityID], 
		[FundoID], 
		[SerieID], 
		[FisicalID]
	FROM [OW].[tblRegistryHist]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@regid numeric(18,0), 
		@doctypeid numeric(18,0), 
		@bookid numeric(18,0), 
		@year numeric(18,0), 
		@number numeric(18,0), 
		@date datetime, 
		@originref varchar(30), 
		@origindate datetime, 
		@subject nvarchar(250), 
		@observations nvarchar(250), 
		@processnumber nvarchar(50), 
		@cota nvarchar(50), 
		@bloco nvarchar(50), 
		@classid int, 
		@userID int, 
		@AntecedenteID numeric(18,0), 
		@entID numeric(18,0), 
		@UserModifyID int, 
		@DateModify datetime, 
		@historic bit, 
		@field1 float, 
		@field2 nvarchar(50), 
		@activeDate datetime, 
		@IdIdentityCB int, 
		@Barcode uniqueidentifier, 
		@ProdEntityID numeric(18,0), 
		@FundoID decimal(18,0), 
		@SerieID decimal(18,0), 
		@FisicalID int',
		@regid, 
		@doctypeid, 
		@bookid, 
		@year, 
		@number, 
		@date, 
		@originref, 
		@origindate, 
		@subject, 
		@observations, 
		@processnumber, 
		@cota, 
		@bloco, 
		@classid, 
		@userID, 
		@AntecedenteID, 
		@entID, 
		@UserModifyID, 
		@DateModify, 
		@historic, 
		@field1, 
		@field2, 
		@activeDate, 
		@IdIdentityCB, 
		@Barcode, 
		@ProdEntityID, 
		@FundoID, 
		@SerieID, 
		@FisicalID
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistUpdate;
GO

CREATE PROCEDURE [OW].RegistryHistUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:35
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0),
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0),
	@year numeric(18,0),
	@number numeric(18,0),
	@date datetime,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblRegistryHist]
	SET
		[doctypeid] = @doctypeid,
		[bookid] = @bookid,
		[year] = @year,
		[number] = @number,
		[date] = @date,
		[originref] = @originref,
		[origindate] = @origindate,
		[subject] = @subject,
		[observations] = @observations,
		[processnumber] = @processnumber,
		[cota] = @cota,
		[bloco] = @bloco,
		[classid] = @classid,
		[userID] = @userID,
		[AntecedenteID] = @AntecedenteID,
		[entID] = @entID,
		[UserModifyID] = @UserModifyID,
		[DateModify] = @DateModify,
		[historic] = @historic,
		[field1] = @field1,
		[field2] = @field2,
		[activeDate] = @activeDate,
		[IdIdentityCB] = @IdIdentityCB,
		[Barcode] = @Barcode,
		[ProdEntityID] = @ProdEntityID,
		[FundoID] = @FundoID,
		[SerieID] = @SerieID,
		[FisicalID] = @FisicalID
	WHERE
		[regid] = @regid
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistInsert;
GO

CREATE PROCEDURE [OW].RegistryHistInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:35
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0),
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0),
	@year numeric(18,0),
	@number numeric(18,0),
	@date datetime,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classid int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@IdIdentityCB int = NULL,
	@Barcode uniqueidentifier = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblRegistryHist]
	(
		[regid],
		[doctypeid],
		[bookid],
		[year],
		[number],
		[date],
		[originref],
		[origindate],
		[subject],
		[observations],
		[processnumber],
		[cota],
		[bloco],
		[classid],
		[userID],
		[AntecedenteID],
		[entID],
		[UserModifyID],
		[DateModify],
		[historic],
		[field1],
		[field2],
		[activeDate],
		[IdIdentityCB],
		[Barcode],
		[ProdEntityID],
		[FundoID],
		[SerieID],
		[FisicalID]
	)
	VALUES
	(
		@regid,
		@doctypeid,
		@bookid,
		@year,
		@number,
		@date,
		@originref,
		@origindate,
		@subject,
		@observations,
		@processnumber,
		@cota,
		@bloco,
		@classid,
		@userID,
		@AntecedenteID,
		@entID,
		@UserModifyID,
		@DateModify,
		@historic,
		@field1,
		@field2,
		@activeDate,
		@IdIdentityCB,
		@Barcode,
		@ProdEntityID,
		@FundoID,
		@SerieID,
		@FisicalID
	)	
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistDelete;
GO

CREATE PROCEDURE [OW].RegistryHistDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-02-2006 15:57:35
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRegistryHist]
	WHERE
		[regid] = @regid
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistDelete Error on Creation'
GO


/****************************************************************************************************************/
/* Procedures OfficeWorks.Data.OWRegistry Extensão*/ 
/****************************************************************************************************************/

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationSelectEx01;
GO

CREATE   PROCEDURE [OW].ClassificationSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 16-02-2006 15:34:15
	--Version: 1.2	
	------------------------------------------------------------------------
	@ClassificationID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		c.[ClassificationID],		
		c.[ParentID],
		fn.[Level],
		c.[Code],
		c.[Description],
		c.[Global],
		c.[Scope],
		fn.[Expanded],
		fn.[Selected],
		c.[Remarks],
		c.[InsertedBy],
		c.[InsertedOn],
		c.[LastModifiedBy],
		c.[LastModifiedOn]
	FROM [OW].[tblClassification] c
	INNER JOIN OW.fnClassificationById(@ClassificationID) fn
	ON c.[ClassificationID] = fn.[ClassificationID]
	ORDER BY fn.[Level]

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ClassificationSelectEx02;
GO

/*
Procedimento Temporário enquanto existir o form UI actual das classificações
Actualizem o OfficeWorks.Data quando eliminarem esta treta...
*/
CREATE  PROCEDURE [OW].ClassificationSelectEx02

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	
	-- Obtém as Classificações de 1º nível
	select ClassificationID, [Global], 
		Code as Level1, null as Level2, null as Level3, null as Level4, null as Level5, [Description], 
		[Description] as Level1Description, null as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		Scope, null as ParentID, [Level]
	from OW.tblClassification
	where level = 0
	
	union
	
	-- Obtém as Classificações de 2º nível
	select a1.ClassificationID, a1.Global,
		a2.Code as Level1, a1.Code as Level2, null as Level3, null as Level4, null as Level5, a1.Description, 
		a2.Description as Level1Description, a1.Description as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	where a1.level = 1
	
	union
	
	-- Obtém as Classificações de 3º nível
	select a1.ClassificationID, a1.Global,
		a3.Code as Level1, a2.Code as Level2, a1.Code as Level3, null as Level4, null as Level5, a1.Description, 
		a3.Description as Level1Description, a2.Description as Level2Description, a1.Description as Level3Description, null as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	where a1.level = 2
	
	union
	
	-- Obtém as Classificações de 4º nível
	select a1.ClassificationID, a1.Global,
		a4.Code as Level1, a3.Code as Level2, a2.Code as Level3, a1.Code as Level4, null as Level5, a1.Description, 
		a4.Description as Level1Description, a3.Description as Level2Description, a2.Description as Level3Description, a1.Description as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
	where a1.level = 3
	
	union
	
	-- Obtém as Classificações de 5º nível
	select a1.ClassificationID, a1.Global,
		a5.Code as Level1, a4.Code as Level2, a3.Code as Level3, a2.Code as Level4, a1.Code as Level5, a1.Description, 
		a5.Description as Level1Description, a4.Description as Level2Description, a3.Description as Level3Description, a2.Description as Level4Description, a1.Description as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
	inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
	where a1.level = 4
	
	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectEx02 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistUpdateEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistUpdateEx01;
GO

CREATE  PROCEDURE [OW].RegistryHistUpdateEx01
(
	------------------------------------------------------------------------
	--Updated: 08-02-2006 17:30:26
	--Version: 1.1	
	------------------------------------------------------------------------
	@FisicalID int
)
AS
BEGIN

	SET NOCOUNT ON

	UPDATE [OW].[tblRegistryHist]
	SET
		[FisicalID] = NULL
	WHERE
		[FisicalID] = @FisicalID
	
	RETURN @@Error
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistUpdateEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistUpdateEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistUpdateEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryHistUpdateEx02;
GO

CREATE    PROCEDURE [OW].RegistryHistUpdateEx02
(
	------------------------------------------------------------------------
	--Procedimento para dar suporte à adição da localização física aos 
	--registos passados por querystring, por parte do Registo.
	--Updated: 10-02-2006 16:41:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@FisicalID int
)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE [OW].[tblRegistryHist]
	SET
		[FisicalID] = @FisicalID
	WHERE
		(@regid IS NULL OR [regid] = @regid)

	RETURN @@Error
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistUpdateEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryHistUpdateEx02 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryInsertEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryInsertEx01;
GO

/*
***** Object:  UPDATED FROM OLD PROCEDURE 
OW.usp_AddRegistry    Script Date: 17/02/2006 15:36:45 *****
*/

CREATE    PROCEDURE OW.RegistryInsertEx01
(
	@regid numeric(18,0) = NULL OUTPUT,
	@doctypeid numeric(18,0) = NULL,
	@bookid numeric(18,0) = NULL,
	@year numeric(18,0) = NULL,
	@number numeric(18,0) = NULL,
	@date datetime = NULL,
	@originref varchar(30) = NULL,
	@origindate datetime = NULL,
	@subject nvarchar(250) = NULL,
	@observations nvarchar(250) = NULL,
	@processnumber nvarchar(50) = NULL,
	@cota nvarchar(50) = NULL,
	@bloco nvarchar(50) = NULL,
	@classID int = NULL,
	@userID int = NULL,
	@AntecedenteID numeric(18,0) = NULL,
	@entID numeric(18,0) = NULL,
	@UserModifyID int = NULL,
	@DateModify datetime = NULL,
	@historic bit = NULL,
	@field1 float = NULL,
	@field2 nvarchar(50) = NULL,
	@activeDate datetime = NULL,
	@ProdEntityID numeric(18,0) = NULL,
	@FundoID decimal(18,0) = NULL,
	@SerieID decimal(18,0) = NULL,
	@FisicalID int = NULL
)
AS
	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	SET DATEFORMAT dmy
	
	DECLARE @automatic bit
	DECLARE @NextNumber numeric
	
	IF @Date IS NULL
	SET @Date = CAST(DAY(@_InsertedOn) AS VARCHAR(2)) + '-' + CAST(MONTH(@_InsertedOn) AS VARCHAR(2)) + '-' + CAST(YEAR(@_InsertedOn) AS VARCHAR(4))
	
	IF @Year = 0 OR @Year IS NULL
	SET @Year = YEAR(@_InsertedOn)
	
	SELECT @automatic = automatic FROM OW.tblBooks
	WHERE BookID = @BookID
	IF @automatic = 1 OR @Number = 0 OR @Number IS NULL
	SELECT @NextNumber = MAX(NextNumber) + 1 FROM
	(SELECT MAX(number) AS NextNumber FROM OW.tblRegistry
	 WHERE [BookID] = @BookID AND [Year] = @Year
	 UNION
	 SELECT MAX(number) AS NextNumber FROM OW.tblRegistryHist
	 WHERE [BookID] = @BookID AND [Year] = @Year
	) AS TblMaxNumber
	ELSE
	SELECT @NextNumber = @Number
	
	IF @NextNumber IS NULL SET @NextNumber = 1

   	INSERT
	INTO [OW].[tblRegistry]
	(
		[doctypeid],
		[bookid],
		[year],
		[number],
		[date],
		[originref],
		[origindate],
		[subject],
		[observations],
		[processnumber],
		[cota],
		[bloco],
		[classID],
		[userID],
		[AntecedenteID],
		[entID],
		[UserModifyID],
		[DateModify],
		[historic],
		[field1],
		[field2],
		[activeDate],
		[IdIdentityCB],
		[Barcode],
		[ProdEntityID],
		[FundoID],
		[SerieID],
		[FisicalID]
	)
	VALUES
	(
		@doctypeid,
		@bookid,
		@year,
		@NextNumber,
		@date,
		@originref,
		@origindate,
		@subject,
		@observations,
		@processnumber,
		@cota,
		@bloco,
		@classID,
		@userID,
		@AntecedenteID,
		@entID,
		@UserModifyID,
		@DateModify,
		@historic,
		@field1,
		@field2,
		@activeDate,
		1,
		DEFAULT,
		@ProdEntityID,
		@FundoID,
		@SerieID,
		@FisicalID
	)
    
	SELECT @regid = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err


GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryInsertEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryInsertEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectEx01;
GO

CREATE   PROCEDURE [OW].RegistrySelectEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 08-02-2006 11:48:38
	--Version: 1.0	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@FisicalID int = NULL,
	@Table varchar(1) = NULL,
	@abreviation nvarchar(20) = NULL,
	@Number varchar(15) = NULL,
	@subject nvarchar(250) = NULL,
	@date datetime = NULL,
	@FileID numeric(18,0) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[regid],
		[FisicalID],
		[Table],
		[abreviation],
		[Number],
		[subject],
		[date],
		[FileID]
	FROM [OW].[VREGISTRYEX01]
	WHERE
		(@regid IS NULL OR [regid] = @regid) AND
		(@FisicalID IS NULL OR [FisicalID] = @FisicalID) AND
		(@Table IS NULL OR [Table] LIKE @Table) AND
		(@abreviation IS NULL OR [abreviation] LIKE @abreviation) AND
		(@Number IS NULL OR [Number] LIKE @Number) AND
		(@subject IS NULL OR [subject] LIKE @subject) AND
		(@date IS NULL OR [date] = @date) AND
		(@FileID IS NULL OR [FileID] = @FileID)

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectEx02;
GO

CREATE  PROCEDURE [OW].RegistrySelectEx02
(
	------------------------------------------------------------------------
	--Updated: 30-03-2006 10:04:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@RegID numeric(18,0) = NULL,
	@BookID numeric(18,0) = NULL,
	@Year int = NULL,
	@Number int = NULL,
	@Date datetime = NULL,
	@Subject nvarchar(250) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		r.[RegID], 
		r.[BookID],
		b.[Abreviation], 
		r.[Year],		
		r.[Number], 
		r.[Date],
		r.[Subject]
	FROM 
		[OW].[tblregistry] r 
		INNER JOIN OW.tblBooks b
		ON r.bookid = b.bookID 
	WHERE
		(@RegID IS NULL OR r.[RegID] = @RegID) AND
		(@BookID IS NULL OR r.[BookID] = @BookID) AND
		(@Year IS NULL OR r.[Year] = @Year) AND
		(@Number IS NULL OR r.[Number] = @Number) AND
		(@Date IS NULL OR r.[Date] = @Date) AND
		(@Subject IS NULL OR r.[Subject] LIKE @Subject)


	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectEx02 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectPagingEx01;
GO

CREATE   PROCEDURE [OW].RegistrySelectPagingEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 08-02-2006 11:48:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@FisicalID int = NULL,
	@Table varchar(1) = NULL,
	@abreviation nvarchar(20) = NULL,
	@Number varchar(15) = NULL,
	@subject nvarchar(250) = NULL,
	@date datetime = NULL,
	@FileID numeric(18,0) = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = ''
	
	IF(@regid IS NOT NULL) SET @WHERE = @WHERE + '([regid] = @regid) AND '
	IF(@FisicalID IS NOT NULL) SET @WHERE = @WHERE + '([FisicalID] = @FisicalID) AND '
	IF(@Table IS NOT NULL) SET @WHERE = @WHERE + '([Table] LIKE @Table) AND '
	IF(@abreviation IS NOT NULL) SET @WHERE = @WHERE + '([abreviation] LIKE @abreviation) AND '
	IF(@Number IS NOT NULL) SET @WHERE = @WHERE + '([Number] LIKE @Number) AND '
	IF(@subject IS NOT NULL) SET @WHERE = @WHERE + '([subject] LIKE @subject) AND '
	IF(@date IS NOT NULL) SET @WHERE = @WHERE + '([date] = @date) AND '
	IF(@FileID IS NOT NULL) SET @WHERE = @WHERE + '([FileID] = @FileID) AND '
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(regid) 
	FROM [OW].[VREGISTRYEX01]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@regid numeric(18,0), 
		@FisicalID int, 
		@Table varchar(1), 
		@abreviation nvarchar(20), 
		@Number varchar(15), 
		@subject nvarchar(250), 
		@date datetime, 
		@FileID numeric(18,0),
		@RowCount bigint OUTPUT',
		@regid, 
		@FisicalID, 
		@Table, 
		@abreviation, 
		@Number, 
		@subject, 
		@date, 
		@FileID,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE regid IN (
		SELECT TOP ' + @SizeString + ' regid
			FROM [OW].[VREGISTRYEX01]
			WHERE regid NOT IN (
				SELECT TOP ' + @PrevString + ' regid 
				FROM [OW].[VREGISTRYEX01]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[regid], 
		[FisicalID], 
		[Table], 
		[abreviation], 
		[Number], 
		[subject], 
		[date], 
		[FileID]
	FROM [OW].[VREGISTRYEX01]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@regid numeric(18,0), 
		@FisicalID int, 
		@Table varchar(1), 
		@abreviation nvarchar(20), 
		@Number varchar(15), 
		@subject nvarchar(250), 
		@date datetime, 
		@FileID numeric(18,0)',
		@regid, 
		@FisicalID, 
		@Table, 
		@abreviation, 
		@Number, 
		@subject, 
		@date, 
		@FileID
	
	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectPagingEx01 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectPagingEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectPagingEx02;
GO

CREATE  PROCEDURE [OW].RegistrySelectPagingEx02
(
	------------------------------------------------------------------------
	--Updated: 21-04-2006 16:37:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@RegID numeric(18,0) = NULL,
	@BookID numeric(18,0) = NULL,
	@Year int = NULL,
	@Number int = NULL,
	@Date datetime = NULL,
	@Subject nvarchar(250) = NULL,
	@PageIndex int = NULL,
	@PageSize int = NULL,
	@SortField varchar(4000) = NULL,
	@RowCount bigint OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @WPag AS varchar(4000)
    DECLARE @SizeString AS varchar(10)
    DECLARE @PrevString AS varchar(10)

    SET @SizeString = CAST(@PageSize AS varchar)
    SET @PrevString = CAST(@PageSize * (@PageIndex - 1) AS varchar)
	IF(LEN(RTRIM(@SortField)) >= 4000)
	BEGIN
		RAISERROR('Len of SortField is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	
	DECLARE @WHERE nvarchar(4000)
	SET @WHERE = ''
	
	IF(@RegID IS NOT NULL) SET @WHERE = @WHERE + '(r.[RegID] = @RegID) AND '
	IF(@BookID IS NOT NULL) SET @WHERE = @WHERE + '(r.[BookID] = @BookID) AND '
	IF(@Year IS NOT NULL) SET @WHERE = @WHERE + '(r.[Year] = @Year) AND '
	IF(@Number IS NOT NULL) SET @WHERE = @WHERE + '(r.[Number] = @Number) AND '
	IF(@Date IS NOT NULL) SET @WHERE = @WHERE + '(r.[Date] = @Date) AND '
	IF(@Subject IS NOT NULL) SET @WHERE = @WHERE + '(r.[Subject] LIKE @Subject) AND '
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(r.RegID) 
	FROM [OW].[tblRegistry] r
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@RegID numeric(18,0),
		@BookID numeric(18,0),
		@Year int,
		@Number int,
		@Date datetime,
		@Subject nvarchar(250),
		@RowCount bigint OUTPUT',
		@RegID, 
		@BookID, 
		@Year, 
		@Number, 
		@Date, 
		@Subject,
		@RowCount = @RowCount OUTPUT

	-- @SortField
    IF(@SortField IS NULL OR @SortField = '')
    BEGIN
        SET @SortField = ''
    END
    ELSE
    BEGIN
        SET @SortField = ' ORDER BY ' + @SortField
    END
	
	-- @PageIndex, @PageSize
    IF(@PageIndex IS NULL OR @PageIndex = 0 OR @PageSize IS NULL OR @PageSize = 0)
    BEGIN
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE r.RegID IN (
		SELECT TOP ' + @SizeString + ' r.RegID
			FROM [OW].[tblRegistry] r
			WHERE r.RegID NOT IN (
				SELECT TOP ' + @PrevString + ' r.RegID 
				FROM [OW].[tblRegistry] r
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		r.[RegID], 
		r.[BookID],
		b.[Abreviation], 
		r.[Year],		
		r.[Number], 
		r.[Date],
		r.[Subject]
	FROM 
		[OW].[tblregistry] r 
		INNER JOIN OW.tblBooks b
		ON r.bookid = b.bookID 
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@RegID numeric(18,0),
		@BookID numeric(18,0),
		@Year int,
		@Number int,
		@Date datetime,
		@Subject nvarchar(250)',
		@RegID, 
		@BookID, 
		@Year, 
		@Number, 
		@Date, 
		@Subject
	
	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectPagingEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectPagingEx02 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryUpdateEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryUpdateEx01;
GO

CREATE  PROCEDURE [OW].RegistryUpdateEx01
(
	------------------------------------------------------------------------
	--Updated: 07-02-2006 16:41:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@FisicalID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	UPDATE [OW].[tblRegistry]
	SET
		[FisicalID] = NULL
	WHERE
		[FisicalID] = @FisicalID

	RETURN @@Error
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryUpdateEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryUpdateEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryUpdateEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryUpdateEx02;
GO

CREATE     PROCEDURE [OW].RegistryUpdateEx02
(
	------------------------------------------------------------------------
	--Procedimento para dar suporte à adição da localização física aos 
	--registos passados por querystring, por parte do Registo.
	--Updated: 10-02-2006 16:41:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@FisicalID int
)
AS
BEGIN

	SET NOCOUNT ON

	UPDATE [OW].[tblRegistry]
	SET
		[FisicalID] = @FisicalID
	WHERE
		(@regid IS NULL OR [regid] = @regid)

	RETURN @@Error
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryUpdateEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryUpdateEx02 Error on Creation'
GO

/****************************************************************************************************************/
/* (END)Procedures OfficeWorks.Data.OWRegistry */ 
/****************************************************************************************************************/

/****************************************************************************************************************/
/* Funções OfficeWorks.Data.OWRegistry */ 
/****************************************************************************************************************/

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[fnClassificationById]') and xtype in (N'FN', N'IF', N'TF'))
drop function [OW].[fnClassificationById]
GO

CREATE   FUNCTION OW.fnClassificationById(@ClassificationID int)
RETURNS @Result TABLE (ClassificationID int, Level smallint, Expanded bit, Selected bit)
AS  
BEGIN 
	DECLARE @_Id int, @_IdParent int, @_Level smallint
	
	DECLARE cTOC CURSOR FOR
		SELECT ClassificationID
		FROM [OW].[tblClassification]
		WHERE ClassificationID = @ClassificationID
	FOR READ ONLY
	
	OPEN cTOC
	
	FETCH NEXT FROM cTOC
	INTO @_Id
	
	SET @_Level = 0
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @_IdParent = @_Id
		INSERT INTO @Result VALUES(@_IdParent, @_Level, 0, 1)
		WHILE (@_IdParent > 1)
		BEGIN
			SELECT @_IdParent = ParentID
			FROM [OW].[tblClassification]
			WHERE ClassificationID = @_IdParent
			
			SET @_Level = @_Level - 1
			IF @_IdParent IS NOT NULL
				INSERT INTO @Result VALUES(@_IdParent, @_Level, 1, 0)
		END
		FETCH NEXT FROM cTOC
		INTO @_Id
	END
	
	CLOSE cTOC
	DEALLOCATE cTOC	
	RETURN
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnClassificationById Succeeded'
ELSE PRINT 'Function Creation: [OW].fnClassificationById Error on Creation'
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[fnClassificationOldById]') and xtype in (N'FN', N'IF', N'TF'))
drop function [OW].[fnClassificationOldById]
GO

/*
	Função para converter a tabela actual na tabela antiga de classificações
	Serve temporáriamente para alguns procedimentos antigos.
*/
CREATE   FUNCTION OW.fnClassificationOldById(@ClassificationID int)
RETURNS @Result TABLE(	
	[classID] [numeric](18, 0),
	[level1] [nvarchar] (50),
	[level2] [nvarchar] (50),
	[level3] [nvarchar] (50),
	[level4] [nvarchar] (50),
	[level5] [nvarchar] (50),
	[level1desig] [nvarchar] (100),
	[level2desig] [nvarchar] (100),
	[level3desig] [nvarchar] (100),
	[level4desig] [nvarchar] (100),
	[level5desig] [nvarchar] (100),
	[Tipo] [varchar] (50))
AS
BEGIN 
	DECLARE @_ClassificationID int, @_IdParent int, @_Code varchar(50), @_Level smallint, @_Description varchar(250)
	DECLARE @_Level1 nvarchar(50), @_Level2 nvarchar(50), @_Level3 nvarchar(50), @_Level4 nvarchar(50), @_Level5 nvarchar(50)
	DECLARE @_Level1desig nvarchar(100), @_Level2desig nvarchar(100), @_Level3desig nvarchar(100), @_Level4desig nvarchar(100), @_Level5desig nvarchar(100)

	DECLARE cTOC CURSOR FOR
		SELECT 
			[ClassificationID],
			[Code],
			[Description],
			[Level]
		FROM [OW].[tblClassification]
		WHERE ClassificationID = @ClassificationID
	FOR READ ONLY
	
	OPEN cTOC
	
	FETCH NEXT FROM cTOC
	INTO @_ClassificationID, @_Code, @_Description, @_Level
	
	IF(@@FETCH_STATUS = 0)
	BEGIN
	-- Insert values 
	INSERT INTO @Result VALUES(
		@_ClassificationID,
		@_Level1,
		@_Level2,
		@_Level3,
		@_Level4,
		@_Level5,
		@_Level1desig,
		@_Level2desig,
		@_Level3desig,
		@_Level4desig,
		@_Level5desig,
		NULL)

	UPDATE @Result SET level1 = @_Code, level1desig = @_Description WHERE @_Level = 0
	UPDATE @Result SET level2 = @_Code, level2desig = @_Description WHERE @_Level = 1
	UPDATE @Result SET level3 = @_Code, level3desig = @_Description WHERE @_Level = 2
	UPDATE @Result SET level4 = @_Code, level4desig = @_Description WHERE @_Level = 3
	UPDATE @Result SET level5 = @_Code, level5desig = @_Description WHERE @_Level = 4
	END
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	   SET @_IdParent = @_ClassificationID
	   WHILE (@_IdParent > 1)
	   BEGIN
		SELECT 
			@_IdParent = ParentID,
			@_Code = Code, 
			@_Description = [Description], 
			@_Level = [Level]
		FROM [OW].[tblClassification]
		WHERE ClassificationID = @_IdParent

		UPDATE @Result SET level1 = @_Code, level1desig = @_Description WHERE @_Level = 0
		UPDATE @Result SET level2 = @_Code, level2desig = @_Description WHERE @_Level = 1
		UPDATE @Result SET level3 = @_Code, level3desig = @_Description WHERE @_Level = 2
		UPDATE @Result SET level4 = @_Code, level4desig = @_Description WHERE @_Level = 3
		UPDATE @Result SET level5 = @_Code, level5desig = @_Description WHERE @_Level = 4
	   END
	   FETCH NEXT FROM cTOC
	   INTO @_ClassificationID, @_Code, @_Description, @_Level
	END

	CLOSE cTOC
	DEALLOCATE cTOC
	RETURN
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnClassificationOldById Succeeded'
ELSE PRINT 'Function Creation: [OW].fnClassificationOldById Error on Creation'
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[fnDistributionReport]') and xtype in (N'FN', N'IF', N'TF'))
drop function [OW].[fnDistributionReport]
GO

CREATE FUNCTION OW.fnDistributionReport()
RETURNS @Result TABLE (Campo varchar(50), Designação varchar(500), Quantidade int, Tipo varchar(50))
AS  
BEGIN 
	DECLARE @Campo varchar(50), @Designação varchar(500), @Quantidade int, @Tipo varchar(50), @ClassificationID int
	
	DECLARE cTOC CURSOR FOR
	SELECT 
		CASE 
			WHEN fieldID=10 THEN 'Livro'
			WHEN fieldID=20 THEN 'Tipo Documento' 
			WHEN fieldID=6 THEN 'Classificação' 
		END AS Campo,
		CASE 
			WHEN fieldID=10 THEN tb.designation
			WHEN fieldID=20 THEN  tdt.designation
		END AS Designação,
		COUNT(AutoDistribID) AS Quantidade,
		CASE 
			WHEN TypeID='1' THEN 'Correio Electónico'
			WHEN TypeID='2' THEN 'Outras Vias'
			WHEN TypeID='6' THEN 'Processos'
			END AS Tipo,
		ClassificationID
		FROM OW.tblDistributionAutomatic LEFT JOIN OW.tblbooks tb ON (fieldValue=bookid AND fieldID=10)
		LEFT JOIN OW.tblDocumentType tdt ON (fieldValue=doctypeid AND fieldID=20)
		LEFT JOIN OW.tblClassification tc ON (classificationid=fieldValue AND fieldID=6)
		GROUP BY FieldID,fieldValue,tb.designation,tdt.designation,TypeID,ClassificationID
		HAVING fieldValue > 0
		ORDER BY Campo, Designação
	FOR READ ONLY
	
	OPEN cTOC
	
	FETCH NEXT FROM cTOC
	INTO @Campo, @Designação, @Quantidade, @Tipo, @ClassificationID
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	   IF @ClassificationID > 0
		SELECT @Designação = 	tc.level1 + CASE WHEN LEN(tc.level2) > 0 THEN '\' ELSE '' END + 
					tc.level2 + CASE WHEN LEN(tc.level3) > 0 THEN '\' ELSE '' END + 
					tc.level3 + CASE WHEN LEN(tc.level4) > 0 THEN '\' ELSE '' END + 
					tc.level4 + CASE WHEN LEN(tc.level5) > 0 THEN '\' ELSE '' END + 
					tc.level5
		FROM OW.fnClassificationOldById(@ClassificationID) tc
		
	   INSERT INTO @Result VALUES(@Campo, @Designação, @Quantidade, @Tipo)

	   FETCH NEXT FROM cTOC
	   INTO @Campo, @Designação, @Quantidade, @Tipo, @ClassificationID
	END
	
	CLOSE cTOC
	DEALLOCATE cTOC	
	RETURN
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnDistributionReport Succeeded'
ELSE PRINT 'Function Creation: [OW].fnDistributionReport Error on Creation'
GO

/****************************************************************************************************************/
/* (END) Funções OfficeWorks.Data.OWRegistry */ 
/****************************************************************************************************************/





















































/* ********************** GENERIC ACCESSES  ********************************/

CREATE PROCEDURE OW.usp_GetUsersAndGroupsByProduct
	(
		@Product numeric(18,0), 
		@Type char
	)
AS

	IF (UPPER(@Type)='A')--ALL Users and Groups
	BEGIN
		SELECT a.userID ID, u.userLogin LOGIN, u.userDesc name, 'U' Type
		FROM OW.tblaccess a INNER JOIN OW.tbluser u ON(u.userID=a.UserID)
		WHERE 
		(
			a.ObjectParentID=@Product-- Get only the request product 
			OR
			a.ObjectParentID>(CASE @Product WHEN 0 THEN @Product ELSE 1000 END)--Get all if @Product=0
		)
		AND a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
		UNION
		SELECT g.GroupID ID, '' LOGIN, g.GroupDesc name, 'G' Type
		FROM OW.tblgroups g
		ORDER BY type desc,name
		RETURN @@ERROR
	END


	IF (UPPER(@Type)='U')--Users
	BEGIN
		SELECT DISTINCT a.userID ID, u.userLogin LOGIN, u.userDesc name, 'U' Type
		FROM OW.tblaccess a INNER JOIN OW.tbluser u ON(u.userID=a.UserID)
		WHERE 
		(
			a.ObjectParentID=@Product-- Get only the request product 
			OR
			a.ObjectParentID>(CASE @Product WHEN 0 THEN @Product ELSE 1000 END)--Get all if @Product=0
		)
		AND a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
		ORDER BY type desc,name
		RETURN @@ERROR
	END

	IF (UPPER(@Type)='G')--Groups
	BEGIN		
		SELECT g.GroupID ID, '' LOGIN, g.GroupDesc name, 'G' Type
		FROM OW.tblgroups g
		ORDER BY type desc,name
		RETURN @@ERROR
	END
	
	RETURN @@ERROR
GO


/* ***************************************************************************/
/* ********************** HESE CLASSIFICATION  ********************************/
/* ***************************************************************************/
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationBooksDeleteByClassification]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationBooksDeleteByClassification]
GO

CREATE PROCEDURE [OW].[ClassificationBooksDeleteByClassification]
(
	@ClassID numeric(18,0) = NULL
)
AS
BEGIN

	DELETE
	FROM [OW].[tblClassificationBooks]
	WHERE
		[ClassID] = @ClassID
END

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationIDBookIDLevel1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationIDBookIDLevel1]
GO

CREATE  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel1]
(
	@ClassificationID int = NULL,
	@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	
	-- Obtém as Classificações de 1º nível
	select distinct ClassificationID, [Global], 
		Code as Level1, null as Level2, null as Level3, null as Level4, null as Level5,
		[Description] as Level1Description, null as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		null as ParentID, [Level]
	from OW.tblClassification c, OW.tblClassificationBooks cb
	--inner join OW.tblClassificationBooks cb on c.ClassificationID = cb.ClassID
	where level = 0 and
	(@ClassificationID IS NULL OR [ClassificationID] = @ClassificationID) and
	(([Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = c.ClassificationID and
	(cb.BookID = @BookID)))

	
	order by Level1 asc


	SET @Err = @@Error

	RETURN @Err
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationIDBookIDLevel2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationIDBookIDLevel2]
GO

CREATE  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel2]
(
	@ClassificationID int = NULL,
@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	-- Obtém as Classificações de 2º nível
	select distinct a1.ClassificationID, a1.Global,
		a2.Code as Level1, a1.Code as Level2, null as Level3, null as Level4, null as Level5, 
		a2.Description as Level1Description, a1.Description as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb, OW.tblClassification a1 
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	where a1.level = 1 and
	(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID)
	and
	(( a2.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a2.ClassificationID and
	(cb.BookID = @BookID)))
	




	order by Level1, Level2 asc


	SET @Err = @@Error

	RETURN @Err
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationIDBookIDLevel3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationIDBookIDLevel3]
GO

CREATE  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel3]
(
	@ClassificationID int = NULL,
@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	

	
	-- Obtém as Classificações de 3º nível
	select distinct a1.ClassificationID, a1.Global,
		a3.Code as Level1, a2.Code as Level2, a1.Code as Level3, null as Level4, null as Level5, 
		a3.Description as Level1Description, a2.Description as Level2Description, a1.Description as Level3Description, null as Level4Description, null as Level5Description,
		a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb,OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	where a1.level = 2
	and
	(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID)
	and
	(( a3.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a3.ClassificationID and
	(cb.BookID = @BookID)))



	order by Level1, Level2, Level3 asc


	SET @Err = @@Error

	RETURN @Err
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationIDBookIDLevel4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationIDBookIDLevel4]
GO
CREATE  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel4]
(
	@ClassificationID int = NULL,
@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	

	-- Obtém as Classificações de 4º nível
	select distinct a1.ClassificationID, a1.Global,
		a4.Code as Level1, a3.Code as Level2, a2.Code as Level3, a1.Code as Level4, null as Level5,
		a4.Description as Level1Description, a3.Description as Level2Description, a2.Description as Level3Description, a1.Description as Level4Description, null as Level5Description,
		a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb,OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
	where a1.level = 3
	and
	(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID)
	and
	(( a4.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a4.ClassificationID and
	(cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4 asc


	SET @Err = @@Error

	RETURN @Err
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationIDBookIDLevel5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationIDBookIDLevel5]
GO

CREATE  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel5]
(
@ClassificationID int = NULL,
	@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	
	-- Obtém as Classificações de 5º nível
	select distinct a1.ClassificationID, a1.Global,
		a5.Code as Level1, a4.Code as Level2, a3.Code as Level3, a2.Code as Level4, a1.Code as Level5,
		a5.Description as Level1Description, a4.Description as Level2Description, a3.Description as Level3Description, a2.Description as Level4Description, a1.Description as Level5Description,
		a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb,OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
	inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
	where a1.level = 4
	and
	(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID)
	and
	(( a5.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a5.ClassificationID and
	(cb.BookID = @BookID)))

	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationParentIDLevel2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationParentIDLevel2]
GO

CREATE  PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel2]
(
	@ClassificationID int = NULL,
@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	-- Obtém as Classificações de 2º nível
	select distinct a1.ClassificationID, a1.Global,
		a2.Code as Level1, a1.Code as Level2, null as Level3, null as Level4, null as Level5, a1.Description, 
		a2.Description as Level1Description, a1.Description as Level2Description, null as Level3Description, null as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb, OW.tblClassification a1 
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	where a1.level = 1 and
	(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID)
	and
	(( a2.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a2.ClassificationID and
	(cb.BookID = @BookID)))
	




	order by Level1, Level2 asc


	SET @Err = @@Error

	RETURN @Err
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationParentIDLevel3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationParentIDLevel3]
GO

CREATE PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel3]
(
	@ClassificationID int = NULL,
@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	

	
	-- Obtém as Classificações de 3º nível
	select distinct a1.ClassificationID, a1.Global,
		a3.Code as Level1, a2.Code as Level2, a1.Code as Level3, null as Level4, null as Level5, a1.Description, 
		a3.Description as Level1Description, a2.Description as Level2Description, a1.Description as Level3Description, null as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb,OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	where a1.level = 2
	and
	(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID)
	and
	(( a3.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a3.ClassificationID and
	(cb.BookID = @BookID)))



	order by Level1, Level2, Level3 asc


	SET @Err = @@Error

	RETURN @Err
END
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationParentIDLevel4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationParentIDLevel4]
GO

create  PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel4]
(
	@ClassificationID int = NULL,
@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	

	-- Obtém as Classificações de 4º nível
	select distinct a1.ClassificationID, a1.Global,
		a4.Code as Level1, a3.Code as Level2, a2.Code as Level3, a1.Code as Level4, null as Level5, a1.Description, 
		a4.Description as Level1Description, a3.Description as Level2Description, a2.Description as Level3Description, a1.Description as Level4Description, null as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb,OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
	where a1.level = 3
	and
	(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID)
	and
	(( a4.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a4.ClassificationID and
	(cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4 asc


	SET @Err = @@Error

	RETURN @Err
END
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationParentIDLevel5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationParentIDLevel5]
GO

Create  PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel5]
(
@ClassificationID int = NULL,
	@BookID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	
	-- Obtém as Classificações de 5º nível
	select distinct a1.ClassificationID, a1.Global,
		a5.Code as Level1, a4.Code as Level2, a3.Code as Level3, a2.Code as Level4, a1.Code as Level5, a1.Description, 
		a5.Description as Level1Description, a4.Description as Level2Description, a3.Description as Level3Description, a2.Description as Level4Description, a1.Description as Level5Description,
		a1.Scope, a1.ParentID, a1.Level
	from OW.tblClassificationBooks cb,OW.tblClassification a1
	inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
	inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
	inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
	inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
	where a1.level = 4
	and
	(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID)
	and
	(( a5.[Global] = 1) or
	(@BookID IS NULL) OR
	(cb.ClassID = a5.ClassificationID and
	(cb.BookID = @BookID)))

	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END
GO










-- Checks if User has access to a Document in Registry Module.
-- User has access if he has access to a registry with that document.
CREATE FUNCTION OW.CheckRegistryDocumentAccess
	(
	@UserID int,
	@FileID numeric(18)
	)
RETURNS bit
AS

BEGIN

	DECLARE @HaveAccess bit
	
	SET @HaveAccess = 0


	SELECT @HaveAccess = 1 FROM OW.tblRegistryDocuments RD 
	WHERE RD.FileID=@FileID
	AND 
	EXISTS
	(
		SELECT 1 
		FROM OW.tblRegistry R 
		WHERE RD.RegID=R.RegID 
		AND 
		EXISTS 
		(
			SELECT 1 
			FROM OW.tblBooks B 
			WHERE R.BookID=B.BookID 
			AND 
			( 
				NOT EXISTS 
				( 
					SELECT 1 
					FROM OW.tblAccess 
					WHERE  ObjectID=B.BookID AND ObjectTypeID=2 AND ObjectParentID=1 
				) 
				OR 
				EXISTS 
				( 
					SELECT 1 
					FROM  OW.tblAccess 
					WHERE ObjectID=B.BookID AND ObjectTypeID=2 AND ObjectParentID=1 
					AND 
					( 
						( ObjectType=1 AND UserID = @UserID ) 
						OR 
						( ObjectType=2 AND EXISTS( SELECT 1 
									   FROM  OW.tblGroupsUsers 
									   WHERE UserID=GroupID AND UserID = @UserID
									) 
						) 
					) 
				) 
			) 
		) 
		AND 
		( 
			NOT EXISTS ( SELECT 1 FROM  OW.tblAccessReg AC Where AC.ObjectID=R.RegID) 
			OR 
			EXISTS 
			( 
				SELECT 1 FROM   OW.tblAccessReg AC 
				WHERE 
				( 
					AC.ObjectID=R.RegID 
					AND 
					(AC.ObjectType=1 AND AC.userID = @UserID ) 
					OR 
					(AC.ObjectType=2 AND EXISTS ( SELECT 1 FROM  OW.tblGroupsUsers GU 
									WHERE AC.UserID=GU.GroupID AND GU.UserID = @UserID
								) 
					) 
				) 
			) 
		) 
	) 


	RETURN @HaveAccess
END
GO




















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDistributionSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryDistributionSelect;
GO

CREATE PROCEDURE [OW].RegistryDistributionSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-04-2006 17:20:50
	--Version: 1.2	
	------------------------------------------------------------------------
	@ID numeric(18,0) = NULL,
	@RegID numeric(18,0) = NULL,
	@userID int = NULL,
	@DistribDate datetime = NULL,
	@DistribObs nvarchar(250) = NULL,
	@Tipo numeric(18,0) = NULL,
	@radioVia varchar(20) = NULL,
	@chkFile bit = NULL,
	@DistribTypeID numeric(18,0) = NULL,
	@txtEntidadeID numeric(18,0) = NULL,
	@state tinyint = NULL,
	@ConnectID numeric(18,0) = NULL,
	@dispatch numeric(18,0) = NULL,
	@AddresseeType char(1) = NULL,
	@AddresseeID numeric(18,0) = NULL,
	@AutoDistrib bit = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ID],
		[RegID],
		[userID],
		[DistribDate],
		[DistribObs],
		[Tipo],
		[radioVia],
		[chkFile],
		[DistribTypeID],
		[txtEntidadeID],
		[state],
		[ConnectID],
		[dispatch],
		[AddresseeType],
		[AddresseeID],
		[AutoDistrib]
	FROM [OW].[tblRegistryDistribution]
	WHERE
		(@ID IS NULL OR [ID] = @ID) AND
		(@RegID IS NULL OR [RegID] = @RegID) AND
		(@userID IS NULL OR [userID] = @userID) AND
		(@DistribDate IS NULL OR [DistribDate] = @DistribDate) AND
		(@DistribObs IS NULL OR [DistribObs] LIKE @DistribObs) AND
		(@Tipo IS NULL OR [Tipo] = @Tipo) AND
		(@radioVia IS NULL OR [radioVia] LIKE @radioVia) AND
		(@chkFile IS NULL OR [chkFile] = @chkFile) AND
		(@DistribTypeID IS NULL OR [DistribTypeID] = @DistribTypeID) AND
		(@txtEntidadeID IS NULL OR [txtEntidadeID] = @txtEntidadeID) AND
		(@state IS NULL OR [state] = @state) AND
		(@ConnectID IS NULL OR [ConnectID] = @ConnectID) AND
		(@dispatch IS NULL OR [dispatch] = @dispatch) AND
		(@AddresseeType IS NULL OR [AddresseeType] = @AddresseeType) AND
		(@AddresseeID IS NULL OR [AddresseeID] = @AddresseeID) AND
		(@AutoDistrib IS NULL OR [AutoDistrib] = @AutoDistrib)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDistributionSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryDistributionSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDistributionUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryDistributionUpdate;
GO

CREATE PROCEDURE [OW].RegistryDistributionUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-04-2006 17:20:50
	--Version: 1.1	
	------------------------------------------------------------------------
	@ID numeric(18,0),
	@RegID numeric(18,0) = NULL,
	@userID int,
	@DistribDate datetime,
	@DistribObs nvarchar(250) = NULL,
	@Tipo numeric(18,0),
	@radioVia varchar(20) = NULL,
	@chkFile bit = NULL,
	@DistribTypeID numeric(18,0) = NULL,
	@txtEntidadeID numeric(18,0) = NULL,
	@state tinyint = NULL,
	@ConnectID numeric(18,0) = NULL,
	@dispatch numeric(18,0) = NULL,
	@AddresseeType char(1) = NULL,
	@AddresseeID numeric(18,0) = NULL,
	@AutoDistrib bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblRegistryDistribution]
	SET
		[RegID] = @RegID,
		[userID] = @userID,
		[DistribDate] = @DistribDate,
		[DistribObs] = @DistribObs,
		[Tipo] = @Tipo,
		[radioVia] = @radioVia,
		[chkFile] = @chkFile,
		[DistribTypeID] = @DistribTypeID,
		[txtEntidadeID] = @txtEntidadeID,
		[state] = @state,
		[ConnectID] = @ConnectID,
		[dispatch] = @dispatch,
		[AddresseeType] = @AddresseeType,
		[AddresseeID] = @AddresseeID,
		[AutoDistrib] = @AutoDistrib
	WHERE
		[ID] = @ID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDistributionUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryDistributionUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDistributionInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryDistributionInsert;
GO

CREATE PROCEDURE [OW].RegistryDistributionInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-04-2006 17:20:50
	--Version: 1.1	
	------------------------------------------------------------------------
	@ID numeric(18,0) = NULL OUTPUT,
	@RegID numeric(18,0) = NULL,
	@userID int,
	@DistribDate datetime,
	@DistribObs nvarchar(250) = NULL,
	@Tipo numeric(18,0),
	@radioVia varchar(20) = NULL,
	@chkFile bit = NULL,
	@DistribTypeID numeric(18,0) = NULL,
	@txtEntidadeID numeric(18,0) = NULL,
	@state tinyint = NULL,
	@ConnectID numeric(18,0) = NULL,
	@dispatch numeric(18,0) = NULL,
	@AddresseeType char(1) = NULL,
	@AddresseeID numeric(18,0) = NULL,
	@AutoDistrib bit
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblRegistryDistribution]
	(
		[RegID],
		[userID],
		[DistribDate],
		[DistribObs],
		[Tipo],
		[radioVia],
		[chkFile],
		[DistribTypeID],
		[txtEntidadeID],
		[state],
		[ConnectID],
		[dispatch],
		[AddresseeType],
		[AddresseeID],
		[AutoDistrib]
	)
	VALUES
	(
		@RegID,
		@userID,
		@DistribDate,
		@DistribObs,
		@Tipo,
		@radioVia,
		@chkFile,
		@DistribTypeID,
		@txtEntidadeID,
		@state,
		@ConnectID,
		@dispatch,
		@AddresseeType,
		@AddresseeID,
		@AutoDistrib
	)	
	SELECT @ID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDistributionInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryDistributionInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDistributionDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryDistributionDelete;
GO

CREATE PROCEDURE [OW].RegistryDistributionDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-04-2006 17:20:50
	--Version: 1.1	
	------------------------------------------------------------------------
	@ID numeric(18,0) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRegistryDistribution]
	WHERE
		[ID] = @ID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDistributionDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryDistributionDelete Error on Creation'
GO
