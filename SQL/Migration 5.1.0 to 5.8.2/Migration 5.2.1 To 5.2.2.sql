-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.2.1 PARA A VERSÃO 5.2.2
--
-- ---------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- Feature 807
-- ------------------------------------------------------------------------------------------------
ALTER TABLE OW.tblDistributionAutomatic ADD 
	FieldBookID numeric(18, 0) NULL,
	FieldClassID numeric(18, 0) NULL,
	FieldDocTypeID numeric(18, 0) NULL
GO

-- Copiar configurações dos Livros já efectuadas
--
UPDATE OW.tblDistributionAutomatic
SET FieldBookID = FieldValue
WHERE FieldID = 10
GO
-- Copiar configurações das Classificações já efectuadas
--
UPDATE OW.tblDistributionAutomatic
SET FieldClassID = FieldValue
WHERE FieldID = 6
GO
-- Copiar configurações dos Tipos de Documentos já efectuadas
--
UPDATE OW.tblDistributionAutomatic
SET FieldDocTypeID = FieldValue
WHERE FieldID = 20
GO
-- Adicionar Constraint 
-- 
ALTER TABLE OW.tblDistributionAutomatic
ADD CONSTRAINT DA_CH3 CHECK
([FieldBookID] is not null or [FieldClassID] is not null or [FieldDocTypeID] is not null)
GO

-- Apagar colunas desnecessárias
--
ALTER TABLE OW.tblDistributionAutomatic DROP COLUMN FieldValue
GO
ALTER TABLE OW.tblDistributionAutomatic DROP COLUMN FieldID
GO





ALTER PROCEDURE OW.usp_GetDistributionAutomatic
	@fieldBookID numeric=null,
	@fieldClassID numeric=null,
	@fieldDocTypeID numeric=null
AS

DECLARE @Query nvarchar(1000)

SET @Query = '
SELECT 
	AutoDistribID as DistribID,
	TypeID as Tipo,
	WayID as radioVia,
	SendFiles as chkFile,
	DistribObs,
	DistribTypeID,
	DispatchID as dispatch,
	getdate() as DistribDate,
	'''' as UserDesc,
	1 as State,
	AddresseeType as addresseeType,
	AddresseeID as addresseeID,
	FieldBookID as fieldBookID,
	FieldClassID as fieldClassID,
	FieldDocTypeID as fieldDocTypeID
FROM 
	OW.tblDistributionAutomatic
WHERE'

IF (@fieldBookID IS NULL) 
	SET @Query = @Query + ' FieldBookID IS NULL'
ELSE
	SET @Query = @Query + ' FieldBookID = ' + CAST (@fieldBookID AS NVARCHAR)


IF (@fieldClassID IS NULL) 
	SET @Query = @Query + ' AND FieldClassID IS NULL'
ELSE
	SET @Query = @Query + ' AND FieldClassID = ' + CAST (@fieldClassID AS NVARCHAR)


IF (@fieldDocTypeID IS NULL) 
	SET @Query = @Query + ' AND FieldDocTypeID IS NULL'
ELSE
	SET @Query = @Query + ' AND FieldDocTypeID = ' + CAST (@fieldDocTypeID AS NVARCHAR)


EXEC sp_ExecuteSQL @Query

GO







ALTER PROCEDURE OW.usp_GetDistributionAutomaticReport

As 

	DECLARE @NULLVALUEUP varchar(10)
	DECLARE @NULLVALUEDOWN varchar(10)

	SET @NULLVALUEUP = '__________'
	SET @NULLVALUEDOWN = 'ZZZZZZZZZ'

	SELECT 
		AutoDistribID,
		FieldBookID,
		CASE 
			WHEN FieldBookID IS NOT NULL THEN tb.designation ELSE ''
		END 
		AS FieldBookIDDesc,
		CASE 
			WHEN FieldBookID IS NOT NULL THEN tb.designation ELSE @NULLVALUEDOWN
		END 
		AS FieldBookIDDescHidden,
		FieldClassID,
		CASE 
			WHEN FieldClassID IS NOT NULL THEN OW.fnGetClassificationLevelById(tc.ClassificationID) ELSE ''
		END 
		AS FieldClassIDDesc,
		CASE 
			WHEN FieldClassID IS NOT NULL THEN OW.fnGetClassificationLevelById(tc.ClassificationID) ELSE CASE WHEN FieldDocTypeID IS NOT NULL THEN @NULLVALUEDOWN ELSE @NULLVALUEUP END
		END 
		AS FieldClassIDDescHidden,
		FieldDocTypeID,
		CASE 
			WHEN FieldDocTypeID IS NOT NULL THEN tdt.designation ELSE ''
		END 
		AS FieldDocTypeIDDesc,
		CASE 
			WHEN FieldDocTypeID IS NOT NULL THEN tdt.designation ELSE @NULLVALUEUP
		END 
		AS FieldDocTypeIDDescHidden,
		CASE 
			WHEN TypeID='1' THEN 'Correio Electónico'
			WHEN TypeID='2' THEN 'Outras Vias'
			WHEN TypeID='6' THEN 'Processos'
		END 
		AS DistribType
	FROM 
		OW.tblDistributionAutomatic LEFT JOIN OW.tblbooks tb ON (fieldbookid=bookid)
		LEFT JOIN OW.tblDocumentType tdt ON (fielddoctypeid=doctypeid)
		LEFT JOIN OW.tblClassification tc ON (fieldclassid=classificationid)
	ORDER BY 
		FieldBookIDDescHidden, FieldClassIDDescHidden, FieldDocTypeIDDescHidden

GO





ALTER PROCEDURE OW.usp_NewDistributionAutomaticToTemporary

	@bookID numeric = null,
	@classificationID numeric = null,
	@documentTypeID numeric = null,
	@guid nchar(32),
	@userID numeric

AS


DECLARE @DISTRIBUTION_OTHER_WAYS NUMERIC
SET @DISTRIBUTION_OTHER_WAYS = 2
DECLARE @SQLCommand nvarchar(2000)
DECLARE @WhereClause nvarchar(1000)

SET XACT_ABORT ON

BEGIN TRANSACTION



SET @SQLCommand = N'
INSERT INTO OW.tblDistribTemp 
	(GUID, Tipo, DistribObs, radioVia, chkFile, DistribTypeID, 
	regID, DistribDate, UserID, OLD, State, ConnectID, ID, dispatch, 
	AutoDistrib, AutoDistribID, AddresseeType, AddresseeID)
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
FROM 
	OW.tblDistributionAutomatic
WHERE '

-- Get distributions for book
IF @bookID IS NOT NULL AND @classificationID IS NULL AND @documentTypeID IS NULL
BEGIN
	SET @WhereClause = 'FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL'
END

-- Get distributions for classification
IF @bookID IS NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NULL
BEGIN

	SET @WhereClause = 'FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL'

END

-- Get distributions for documenttype
IF @bookID IS NULL AND @classificationID IS NULL AND @documentTypeID IS NOT NULL
BEGIN

	SET @WhereClause = 'FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID'

END


-- Get distributions for book and classification
IF @bookID IS NOT NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NULL
BEGIN
	SET @WhereClause = '
	(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
	(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
	(FieldBookID = @bookID AND FieldClassID = @classificationID)'

END

-- Get distributions for book and documenttype
IF @bookID IS NOT NULL AND @classificationID IS NULL AND @documentTypeID IS NOT NULL
BEGIN
	SET @WhereClause = '
	(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
	(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID) OR
	(FieldBookID = @bookID AND FieldDocTypeID = @documentTypeID)'

END

-- Get distributions for classification and documenttype
IF @bookID IS NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NOT NULL
BEGIN
	SET @WhereClause = '
	(FieldBookID IS NULL AND FieldClassID = @ClassificationID AND FieldDocTypeID IS NULL) OR
	(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID) OR
	(FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID)'

END

-- Get distributions for book and classification and documenttype
IF @bookID IS NOT NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NOT NULL
BEGIN
	SET @WhereClause = '
	(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
	(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
	(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID) OR
	(FieldBookID = @bookID AND FieldClassID = @classificationID) OR
	(FieldBookID = @bookID AND FieldDocTypeID = @documentTypeID) OR
	(FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID) OR
	(FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID)'
END

SET @SQLCommand = @SQLCommand + @WhereClause
EXEC sp_ExecuteSQL @SQLCommand, 
	N'@bookID numeric, @classificationID numeric, @documentTypeID numeric, @guid nchar(32), @userID numeric',
	@bookID, @classificationID, @documentTypeID, @guid, @userID

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











ALTER PROCEDURE OW.usp_SetDistributionAutomatic
(
	@typeID		numeric,
	@wayID		varchar(20) = null,
	@sendFiles	bit = 0,
	@distribObs	nvarchar(250) = '',
	@distribTypeID	numeric = null,
	@dispatchID	numeric = null,	
	@addresseeType	char(1) = null,
	@addresseeID	numeric = null,
	@fieldBookID	numeric = null,
	@fieldClassID	numeric = null,
	@fieldDocTypeID	numeric = null,
	@EntIds text = null
)
AS

	BEGIN TRANSACTION
	
	DECLARE @AutomaticDistribID NUMERIC
	DECLARE @Value varchar(4000)
	
	INSERT INTO tblDistributionAutomatic
		(TypeID, WayID, SendFiles, DistribObs, DistribTypeID, DispatchID, AddresseeType, AddresseeID, FieldBookID, FieldClassID, FieldDocTypeID)
	VALUES 
		(@typeID, @wayID, @sendFiles, @distribObs, @distribTypeID, @dispatchID, @addresseeType, @addresseeID, @fieldBookID, @fieldClassID, @fieldDocTypeID)

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END

	SET @AutomaticDistribID = @@IDENTITY

	/* Entities exists */ 
	IF (@EntIds IS NOT NULL)
	BEGIN
			
		DECLARE EntsID_cursor CURSOR
		FOR SELECT value FROM OW.fnlisttotable(@EntIds,',')
	
		OPEN EntsID_cursor
		FETCH NEXT FROM EntsID_cursor INTO @Value
	
		WHILE @@FETCH_STATUS=0
		BEGIN
			
			/* INSERTS THE AUTOMATIC DISTRIBUTION ENTITIES */
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

	COMMIT TRANSACTION

	RETURN 0


GO


ALTER PROCEDURE OW.usp_SetDistributionAutomaticEntity

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



DROP FUNCTION OW.fnDistributionReport
GO


CREATE FUNCTION OW.fnGetClassificationLevelById(@ClassificationID int)
RETURNS VARCHAR(500)
AS  
BEGIN 

	DECLARE @ReturnValue varchar(500)
	
	SET @ReturnValue = ''
	
	IF @ClassificationID > 0
	BEGIN

		SELECT @ReturnValue = ISNULL(tc.level1,'') + CASE WHEN LEN(tc.level2) > 0 THEN '\' ELSE '' END + 
			ISNULL(tc.level2,'') + CASE WHEN LEN(tc.level3) > 0 THEN '\' ELSE '' END + 
			ISNULL(tc.level3,'') + CASE WHEN LEN(tc.level4) > 0 THEN '\' ELSE '' END + 
			ISNULL(tc.level4,'') + CASE WHEN LEN(tc.level5) > 0 THEN '\' ELSE '' END + 
			ISNULL(tc.level5,'')
		FROM OW.fnClassificationOldById(@ClassificationID) tc
	END

	RETURN @ReturnValue
END

GO




-- Feature 568
/*==============================================================*/
/* Table: tblFavoriteSearch                                     */
/*==============================================================*/
create table OW.tblFavoriteSearch (
   FavoriteSearchID	int                  identity,
   Type		        int                  not null
	constraint CK_tblFavoriteSearch01 check ( Type in (1,2,3,4,5) ), -- 1-Registo, 2-Requisições, 3-Entidades, 4-Processos, 5-Documentos
   UserID               int                  null,
   Description          varchar(100)         not null
	constraint CK_tblFavoriteSearch02 check ( Description<>'' ),
   Global	        bit		     not null,
   SearchCriteria       text                 not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFavoriteSearch primary key  (FavoriteSearchID),
   constraint CK_tblFavoriteSearch03 check ( (Global=1 OR UserID is not null) AND (Global=0 OR UserID is null) ),
   constraint IX_tblFavoriteSearch01 unique (Type, UserID, Description)
)
go



alter table OW.tblFavoriteSearch
   add constraint FK_tblFavoriteSearch_tblUser foreign key (UserID)
      references OW.tblUser (UserID)on delete cascade
go











DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SET @InsertedBy='Administrador OfficeWorks'
SET @InsertedOn=getdate()

SET @LastModifiedBy=@InsertedBy
SET @LastModifiedOn=@InsertedOn


insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7127, 7, 'Configuração - Pesquisas Favoritas Globais : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7128, 7, 'Configuração - Pesquisas Favoritas Globais : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7129, 7, 'Configuração - Pesquisas Favoritas Globais : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

go

















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FavoriteSearchSelect;
GO

CREATE PROCEDURE [OW].FavoriteSearchSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 14-09-2006 12:29:19
	--Version: 1.2	
	------------------------------------------------------------------------
	@FavoriteSearchID int = NULL,
	@Type int = NULL,
	@UserID int = NULL,
	@Description varchar(100) = NULL,
	@Global bit = NULL,
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
		[FavoriteSearchID],
		[Type],
		[UserID],
		[Description],
		[Global],
		[SearchCriteria],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFavoriteSearch]
	WHERE
		(@FavoriteSearchID IS NULL OR [FavoriteSearchID] = @FavoriteSearchID) AND
		(@Type IS NULL OR [Type] = @Type) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Global IS NULL OR [Global] = @Global) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FavoriteSearchSelectPaging;
GO

CREATE PROCEDURE [OW].FavoriteSearchSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 14-09-2006 12:29:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@FavoriteSearchID int = NULL,
	@Type int = NULL,
	@UserID int = NULL,
	@Description varchar(100) = NULL,
	@Global bit = NULL,
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
	
	IF(@FavoriteSearchID IS NOT NULL) SET @WHERE = @WHERE + '([FavoriteSearchID] = @FavoriteSearchID) AND '
	IF(@Type IS NOT NULL) SET @WHERE = @WHERE + '([Type] = @Type) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '([UserID] = @UserID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Global IS NOT NULL) SET @WHERE = @WHERE + '([Global] = @Global) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FavoriteSearchID) 
	FROM [OW].[tblFavoriteSearch]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@FavoriteSearchID int, 
		@Type int, 
		@UserID int, 
		@Description varchar(100), 
		@Global bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@FavoriteSearchID, 
		@Type, 
		@UserID, 
		@Description, 
		@Global, 
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
	WHERE FavoriteSearchID IN (
		SELECT TOP ' + @SizeString + ' FavoriteSearchID
			FROM [OW].[tblFavoriteSearch]
			WHERE FavoriteSearchID NOT IN (
				SELECT TOP ' + @PrevString + ' FavoriteSearchID 
				FROM [OW].[tblFavoriteSearch]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FavoriteSearchID], 
		[Type], 
		[UserID], 
		[Description], 
		[Global], 
		[SearchCriteria], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFavoriteSearch]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@FavoriteSearchID int, 
		@Type int, 
		@UserID int, 
		@Description varchar(100), 
		@Global bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FavoriteSearchID, 
		@Type, 
		@UserID, 
		@Description, 
		@Global, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FavoriteSearchUpdate;
GO

CREATE PROCEDURE [OW].FavoriteSearchUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 14-09-2006 12:29:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@FavoriteSearchID int,
	@Type int,
	@UserID int = NULL,
	@Description varchar(100),
	@Global bit,
	@SearchCriteria text,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFavoriteSearch]
	SET
		[Type] = @Type,
		[UserID] = @UserID,
		[Description] = @Description,
		[Global] = @Global,
		[SearchCriteria] = @SearchCriteria,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[FavoriteSearchID] = @FavoriteSearchID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FavoriteSearchInsert;
GO

CREATE PROCEDURE [OW].FavoriteSearchInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 14-09-2006 12:29:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@FavoriteSearchID int = NULL OUTPUT,
	@Type int,
	@UserID int = NULL,
	@Description varchar(100),
	@Global bit,
	@SearchCriteria text,
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
	INTO [OW].[tblFavoriteSearch]
	(
		[Type],
		[UserID],
		[Description],
		[Global],
		[SearchCriteria],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Type,
		@UserID,
		@Description,
		@Global,
		@SearchCriteria,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @FavoriteSearchID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FavoriteSearchDelete;
GO

CREATE PROCEDURE [OW].FavoriteSearchDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 14-09-2006 12:29:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@FavoriteSearchID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFavoriteSearch]
	WHERE
		[FavoriteSearchID] = @FavoriteSearchID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchDelete Error on Creation'
GO




IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FavoriteSearchSelectEx01;
GO


------------------------------------------------------------------------
-- Devolve as pesquisas favoritas de um utilizador para um módulo ou para
-- os módulos todos.
-- 
------------------------------------------------------------------------
CREATE PROCEDURE [OW].FavoriteSearchSelectEx01
(

	@Type int = NULL,
	@UserID int

)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[FavoriteSearchID],
		[Type],
		[UserID],
		[Description],
		[Global],
		[SearchCriteria],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFavoriteSearch]
	WHERE
		(@Type IS NULL OR [Type] = @Type) 
		AND
		([Global]=1 OR [UserID] = @UserID) 
	ORDER BY [Type], [Global], [Description]

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchSelectEx01 Error on Creation'
GO




-- ------------------------------------------------------------------------------------------------
-- Defect 860
-- ------------------------------------------------------------------------------------------------

update [OW].[tblEntityLocation]
set Description = Description + cast(LocationID as varchar)
where Description in (
	select Description from [OW].[tblEntityLocation]
	group by Description
	having count(Description)> 1 )
GO

ALTER TABLE [OW].[tblEntityLocation] 
	ADD CONSTRAINT [IX_tblEntityLocation01] UNIQUE 
	(
		[Description]
	)  ON [PRIMARY] 
GO







update [OW].[tblDistrict]
set [OW].[tblDistrict].Description = [OW].[tblDistrict].Description + cast(DistrictID as varchar)
from
	(
	select CountryID, Description from [OW].[tblDistrict]
	group by CountryID, Description
	having count(Description)> 1 
	) AS DUPLICADOS
where [OW].[tblDistrict].CountryID=DUPLICADOS.CountryID 
and  [OW].[tblDistrict].Description=DUPLICADOS.Description
GO

ALTER TABLE [OW].[tblDistrict] 
	ADD CONSTRAINT [IX_tblDistrict01] UNIQUE 
	(
		[CountryID],[Description]
	)  ON [PRIMARY] 
GO






update [OW].[tblCountry]
set Description = Description + cast(CountryID as varchar)
where Description in (
	select Description from [OW].[tblCountry]
	group by Description
	having count(Description)> 1 )
GO

-- Verificar manualmente que não existem países com códigos iguais
-- Se existirem então proceder à correcção
Declare @RowCount int

select @RowCount=Count(*) from [OW].[tblCountry]
	group by Code
	having count(Code)> 1

IF (@RowCount > 0) 
	BEGIN
		SELECT 'Corrigir os países com código iguais:'
		select Code from [OW].[tblCountry]
		group by Code
		having count(Code)> 1
	END
GO

ALTER TABLE [OW].[tblCountry] 
	ADD CONSTRAINT [IX_tblCountry01] UNIQUE 
	(
		[Code]
	)  ON [PRIMARY] 
GO
ALTER TABLE [OW].[tblCountry] 
	ADD CONSTRAINT [IX_tblCountry02] UNIQUE 
	(
		[Description]
	)  ON [PRIMARY] 
GO


update [OW].[tblEntityJobPosition]
set Description = Description + cast(JobPositionID as varchar)
where Description in (
	select Description from [OW].[tblEntityJobPosition]
	group by Description
	having count(Description)> 1 )
GO

ALTER TABLE [OW].[tblEntityJobPosition] 
	ADD CONSTRAINT [IX_tblEntityJobPosition01] UNIQUE 
	(
		[Description]
	)  ON [PRIMARY] 
GO


update [OW].[tblEntityBIArquive]
set Description = Description + cast(BIArquiveID as varchar)
where Description in (
	select Description from [OW].[tblEntityBIArquive]
	group by Description
	having count(Description)> 1 )
GO

ALTER TABLE [OW].[tblEntityBIArquive] 
	ADD CONSTRAINT [IX_tblEntityBIArquive01] UNIQUE 
	(
		[Description]
	)  ON [PRIMARY] 
GO





-- Grupos de Distribuição
update [OW].[tblEntities]
set [OW].[tblEntities].Name = [OW].[tblEntities].Name + cast(EntID as varchar)
from
	(
	select Name from [OW].[tblEntities]
	where type=2 -- Grupos de Distribuição
	group by Name
	having count(Name)> 1 
	) AS DUPLICADOS
where  [OW].[tblEntities].Name=DUPLICADOS.Name
GO




ALTER    PROCEDURE OW.usp_NewContactEx01
(
	------------------------------------------------------------------------
	--Updated: 11-09-2006 18:17:24
	--Version: 1.1
	------------------------------------------------------------------------
	@PublicCode varchar(20),
	@Name varchar(255),
	@FirstName varchar(50),
	@MiddleName varchar(300),
	@LastName varchar(50),
	@ListID numeric (18,0),
	@EntityTypeID numeric (18,0),
	@Type tinyint = 1,
	@User varchar(50),
	@EntID NUMERIC OUTPUT /* Return new contact ID */
)
AS

BEGIN

	DECLARE 
	@_InsertedOn datetime,
	@RowCount int

	SET @_InsertedOn = GETDATE()

	IF ( @Type=2 ) -- Distribution Groups
	BEGIN
		-- Check for duplicated records
		SELECT @RowCount = Count(*) FROM [OW].[tblEntities]
		WHERE Type = 2 AND Name = @Name

		IF (@RowCount > 0 )
		BEGIN
			RAISERROR(50001,16,1)
			RETURN -1;
		END
			
	END

	INSERT
	INTO [OW].[tblEntities]
	(
		[OW].[tblEntities].[PublicCode],
		[OW].[tblEntities].[Name],
		[OW].[tblEntities].[FirstName],
		[OW].[tblEntities].[MiddleName],
		[OW].[tblEntities].[LastName],
		[OW].[tblEntities].[ListID],
		[OW].[tblEntities].[EntityTypeID],
		[OW].[tblEntities].[Active],
		[OW].[tblEntities].[Type],
		[OW].[tblEntities].[InsertedBy],
		[OW].[tblEntities].[InsertedOn],
		[OW].[tblEntities].[LastModifiedBy],
		[OW].[tblEntities].[LastModifiedOn]
	)
	VALUES
	(
		@PublicCode,
		@Name,
		@FirstName,
		@MiddleName,
		@LastName,
		@ListID,
		@EntityTypeID,
		1,
		@Type,
		@User,
		@_InsertedOn,
		@User,
		@_InsertedOn
	)

	IF (@@ERROR <> 0)
		return @@ERROR
	
	SET @EntID=@@IDENTITY
	
	RETURN @@ERROR

END
GO













ALTER    PROCEDURE [OW].[usp_SetEntitiesGroupsEx01]
(
	------------------------------------------------------------------------
	--Updated: 11-09-2006 18:17:24
	--Version: 1.1
	------------------------------------------------------------------------
	@PublicCode varchar(20),
	@EntID numeric(18,0),
	@Name varchar(255),
	@FirstName varchar(50),
	@MiddleName varchar(300),
	@LastName varchar(50),
	@ListID numeric (18,0),
	@EntityTypeID numeric (18,0),
	@Type tinyint = 1,
	@User varchar(50)
)
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @RowCount int


	IF ( @Type=2 ) -- Distribution Groups
	BEGIN
		-- Check for duplicated records
		SELECT @RowCount = Count(*) FROM [OW].[tblEntities]
		WHERE Type = 2 AND Name = @Name AND EntID <> @EntID

		IF (@RowCount > 0 )
		BEGIN
			RAISERROR(50002,16,1)
			RETURN -1;
		END
			
	END

	UPDATE [OW].[tblEntities]
	SET
		[OW].[tblEntities].[PublicCode] = @PublicCode,		
		[OW].[tblEntities].[Name] = @Name,
		[OW].[tblEntities].[FirstName] = @FirstName,
		[OW].[tblEntities].[MiddleName] = @MiddleName,
		[OW].[tblEntities].[LastName] = @LastName,
		[OW].[tblEntities].[ListID] = @ListID,
		[OW].[tblEntities].[EntityTypeID] = @EntityTypeID,
		[OW].[tblEntities].[Type] = @Type,
		[OW].[tblEntities].[LastModifiedBy] = @User,
		[OW].[tblEntities].[LastModifiedOn] = GETDATE()
	WHERE 
		[OW].[tblEntities].[EntID] = @EntID

	RETURN @@Error

END
GO




ALTER  PROCEDURE OW.usp_GetEntitiesGroups

	AS
	
	SELECT
		OW.tblEntities.EntID, 
		OW.tblEntities.PublicCode,
		OW.tblEntities.Name, 
		OW.tblEntities.FirstName, 
		OW.tblEntities.MiddleName, 
		OW.tblEntities.LastName, 
		OW.tblEntities.ListID,
		OW.tblEntityList.Description,
		OW.tblEntities.EntityTypeID,
		OW.tblEntities.Type
	FROM    
		OW.tblEntities INNER JOIN OW.tblEntityList ON 

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




-- ------------------------------------------------------------------------------------------------
-- Defect 877
-- ------------------------------------------------------------------------------------------------
update [OW].[tblClassification]
set [OW].[tblClassification].Code = [OW].[tblClassification].Code + cast(ClassificationID as varchar)
from
	(
	select ParentID, Code from [OW].[tblClassification]
	group by ParentID, Code
	having count(*)> 1  
	) AS DUPLICADOS
where  [OW].[tblClassification].Code=DUPLICADOS.Code
GO


ALTER TABLE [OW].[tblClassification] 
	ADD CONSTRAINT [IX_tblClassification01] UNIQUE 
	(
		[ParentID], [Code]
	)  ON [PRIMARY] 
GO



ALTER  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel1]
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
	from OW.tblClassification c
	left outer join OW.tblClassificationBooks cb on c.ClassificationID = cb.ClassID
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







ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel2]
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
	from OW.tblClassification a1 
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		left outer join OW.tblClassificationBooks cb on a2.ClassificationID = cb.ClassID
	where a1.level = 1 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a2.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))
	




	order by Level1, Level2 asc


	SET @Err = @@Error

	RETURN @Err
END

GO











ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel3]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		left outer join OW.tblClassificationBooks cb on a3.ClassificationID = cb.ClassID
	where a1.level = 2 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a3.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))




	order by Level1, Level2, Level3 asc


	SET @Err = @@Error

	RETURN @Err
END
GO






ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel4]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		left outer join OW.tblClassificationBooks cb on a4.ClassificationID = cb.ClassID
	where a1.level = 3 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a4.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4 asc


	SET @Err = @@Error

	RETURN @Err
END
GO









ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel5]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
		left outer join OW.tblClassificationBooks cb on a5.ClassificationID = cb.ClassID
	where a1.level = 4 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a5.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))

	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END
GO




















ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel2]
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
	from OW.tblClassification a1 
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		left outer join OW.tblClassificationBooks cb on a2.ClassificationID = cb.ClassID
	where a1.level = 1 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a2.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))
	




	order by Level1, Level2 asc


	SET @Err = @@Error

	RETURN @Err
END
GO








ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel3]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		left outer join OW.tblClassificationBooks cb on a3.ClassificationID = cb.ClassID
	where a1.level = 2 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a3.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))



	order by Level1, Level2, Level3 asc


	SET @Err = @@Error

	RETURN @Err
END
GO









ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel4]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		left outer join OW.tblClassificationBooks cb on a4.ClassificationID = cb.ClassID
	where a1.level = 3 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a4.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4 asc


	SET @Err = @@Error

	RETURN @Err
END
GO












ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel5]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
		left outer join OW.tblClassificationBooks cb on a5.ClassificationID = cb.ClassID
	where a1.level = 4 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a5.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END
GO




-- ------------------------------------------------------------------------------------------------
-- Defect 912
-- ------------------------------------------------------------------------------------------------

ALTER FUNCTION OW.CheckRegistryDocumentAccess
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
					( 
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
	) 


	RETURN @HaveAccess
END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[OW].[OrganizationalUnitSelectEx03]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[OrganizationalUnitSelectEx03]
GO

CREATE  PROCEDURE [OW].OrganizationalUnitSelectEx03
(
	------------------------------------------------------------------------
	--Updated: 10-10-2006 10:45:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@BookID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT 
		ou.OrganizationalUnitID, 
		1 AS Type,
		u.UserID AS ID, 
		u.PrimaryGroupID AS Hierarchy,		
		u.UserDesc AS Description
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON (ou.UserID=u.UserID )
		INNER JOIN OW.tblAccess a 
		ON (a.userID = ou.userID)
	WHERE
		ObjectParentID=1
	AND 
		ObjectTypeID = 2
	AND 
		ObjectID = @BookID
	AND 
		ObjectType=1 

	UNION

	SELECT 
		ou.OrganizationalUnitID,
		2 AS Type, 
		g.GroupID AS ID, 
	 	g.HierarchyID AS Hierarchy,
		g.GroupDesc AS Description
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID
		INNER JOIN OW.tblAccess a 
		ON (a.userID = ou.GroupID)
	WHERE
		ObjectParentID = 1 
	AND 
		ObjectTypeID = 2
	AND 
		ObjectID = @BookID 
	AND 
		ObjectType=2 
	order by description
	SET @Err = @@Error
	RETURN @Err
END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx03 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx03 Error on Creation'
GO








ALTER  PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel1]
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
	from OW.tblClassification c
	left outer join OW.tblClassificationBooks cb on c.ClassificationID = cb.ClassID
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







ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel2]
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
	from OW.tblClassification a1 
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		left outer join OW.tblClassificationBooks cb on a2.ClassificationID = cb.ClassID
	where a1.level = 1 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a2.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))
	




	order by Level1, Level2 asc


	SET @Err = @@Error

	RETURN @Err
END

GO











ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel3]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		left outer join OW.tblClassificationBooks cb on a3.ClassificationID = cb.ClassID
	where a1.level = 2 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a3.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))




	order by Level1, Level2, Level3 asc


	SET @Err = @@Error

	RETURN @Err
END
GO






ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel4]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		left outer join OW.tblClassificationBooks cb on a4.ClassificationID = cb.ClassID
	where a1.level = 3 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a4.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4 asc


	SET @Err = @@Error

	RETURN @Err
END
GO









ALTER PROCEDURE [OW].[ClassificationSelectByClassificationIDBookIDLevel5]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
		left outer join OW.tblClassificationBooks cb on a5.ClassificationID = cb.ClassID
	where a1.level = 4 and
		(@ClassificationID IS NULL OR a1.[ClassificationID] = @ClassificationID) and
		((a5.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))

	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END
GO




















ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel2]
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
	from OW.tblClassification a1 
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		left outer join OW.tblClassificationBooks cb on a2.ClassificationID = cb.ClassID
	where a1.level = 1 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a2.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))
	




	order by Level1, Level2 asc


	SET @Err = @@Error

	RETURN @Err
END
GO








ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel3]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		left outer join OW.tblClassificationBooks cb on a3.ClassificationID = cb.ClassID
	where a1.level = 2 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a3.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))



	order by Level1, Level2, Level3 asc


	SET @Err = @@Error

	RETURN @Err
END
GO









ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel4]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		left outer join OW.tblClassificationBooks cb on a4.ClassificationID = cb.ClassID
	where a1.level = 3 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a4.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4 asc


	SET @Err = @@Error

	RETURN @Err
END
GO












ALTER PROCEDURE [OW].[ClassificationSelectByClassificationParentIDLevel5]
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
	from OW.tblClassification a1
		inner join OW.tblClassification a2 on a2.ClassificationID = a1.ParentId
		inner join OW.tblClassification a3 on a3.ClassificationID = a2.ParentId
		inner join OW.tblClassification a4 on a4.ClassificationID = a3.ParentId
		inner join OW.tblClassification a5 on a5.ClassificationID = a4.ParentId
		left outer join OW.tblClassificationBooks cb on a5.ClassificationID = cb.ClassID
	where a1.level = 4 and
		(@ClassificationID IS NULL OR a1.[ParentID] = @ClassificationID) and
		((a5.[Global] = 1) or
		(@BookID IS NULL) OR
		((cb.BookID = @BookID)))


	order by Level1, Level2, Level3, Level4, Level5 asc


	SET @Err = @@Error

	RETURN @Err
END
GO






-- ------------------------------------------------------------------------------------------------
-- Defect 912
-- ------------------------------------------------------------------------------------------------

ALTER FUNCTION OW.CheckRegistryDocumentAccess
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
					( 
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
	) 


	RETURN @HaveAccess
END
GO








IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[OW].[OrganizationalUnitSelectEx03]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[OrganizationalUnitSelectEx03]
GO



CREATE  PROCEDURE [OW].OrganizationalUnitSelectEx03
(
	------------------------------------------------------------------------
	--Updated: 10-10-2006 10:45:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@BookID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT 
		ou.OrganizationalUnitID, 
		1 AS Type,
		u.UserID AS ID, 
		u.PrimaryGroupID AS Hierarchy,		
		u.UserDesc AS Description
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON (ou.UserID=u.UserID )
		INNER JOIN OW.tblAccess a 
		ON (a.userID = ou.userID)
	WHERE
		ObjectParentID=1
	AND 
		ObjectTypeID = 2
	AND 
		ObjectID = @BookID
	AND 
		ObjectType=1 

	UNION

	SELECT 
		ou.OrganizationalUnitID,
		2 AS Type, 
		g.GroupID AS ID, 
	 	g.HierarchyID AS Hierarchy,
		g.GroupDesc AS Description
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID
		INNER JOIN OW.tblAccess a 
		ON (a.userID = ou.GroupID)
	WHERE
		ObjectParentID = 1 
	AND 
		ObjectTypeID = 2
	AND 
		ObjectID = @BookID 
	AND 
		ObjectType=2 
	order by description
	SET @Err = @@Error
	RETURN @Err
END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx03 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx03 Error on Creation'
GO







-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.2.2' WHERE id= 1
GO