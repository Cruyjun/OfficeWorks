-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.7.2 PARA A VERSÃO 5.8.0
--
-- ---------------------------------------------------------------------------------


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.7.2 PARA 5.8.0'
PRINT ''
GO

IF EXISTS (SELECT * FROM TEMPDB..sysobjects WHERE name = N'##VariaveisGlobais')
BEGIN
	DROP TABLE [OW].[##VariaveisGlobais]
END
GO

CREATE TABLE [OW].[##VariaveisGlobais] (InsertedBy varchar(50),InsertedOn datetime,LastModifiedBy varchar(50),LastModifiedOn datetime)
INSERT INTO [OW].[##VariaveisGlobais] (InsertedBy,InsertedOn) VALUES('Administrador OfficeWorks',getdate())
UPDATE  [OW].[##VariaveisGlobais] SET LastModifiedBy = InsertedBy, LastModifiedOn = InsertedOn
GO

-- ---------------------------------------------------------------------------------
-- TABELA DOS PARAMETROS DO OfficeWorks
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT N'TABELA DOS PARAMETROS DO OfficeWorks'
PRINT ''
GO
ALTER TABLE [OW].[tblParameter] DROP CONSTRAINT [CK_tblParameter01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblParameter] ADD CONSTRAINT [CK_tblParameter01] CHECK (([ParameterID] >= 1 and [ParameterID] <= 20))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy=InsertedBy, @InsertedOn=InsertedOn, @LastModifiedBy=LastModifiedBy, @LastModifiedOn=LastModifiedOn FROM [OW].[##VariaveisGlobais]

INSERT INTO OW.tblParameter (ParameterID, [Description], ParameterType, Required, NumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
VALUES (15, 'UI: Pesquisa de entidades expandida', 8, 0, 0, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
INSERT INTO OW.tblParameter (ParameterID, [Description], ParameterType, Required, NumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
VALUES (16, 'UI: Pesquisa de processos expandida', 8, 0, 0, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
INSERT INTO OW.tblParameter (ParameterID, [Description], ParameterType, Required, NumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
VALUES (17, 'UI: Pesquisa de documentos expandida', 8, 0, 0, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
INSERT INTO OW.tblParameter (ParameterID, [Description], ParameterType, Required, NumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
VALUES (18, 'UI: Pesquisa de registos expandida', 8, 0, 0, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
INSERT INTO OW.tblParameter (ParameterID, [Description], ParameterType, Required, NumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
VALUES (19, 'Entidades: Código público automático seleccionado', 8, 0, 0, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
INSERT INTO OW.tblParameter (ParameterID, [Description], ParameterType, Required, NumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
VALUES (20, 'Entidades: Impedir números de contribuinte repetidos', 8, 0, 0, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- ---------------------------------------------------------------------------------
-- TABELA DE ENTIDADES
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT N'TABELA DE ENTIDADES'
PRINT ''
GO

PRINT N'Altering [OW].[tblEntities]'
GO
ALTER TABLE [OW].[tblEntities] ADD
[Notes] [varchar] (1024) COLLATE Latin1_General_CI_AS NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- ---------------------------------------------------------------------------------
-- TABELAS DE CONFIGURACAO DE ENTIDADES
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT N'TABELAS DE CONFIGURACAO DE ENTIDADES'
PRINT ''
GO

PRINT N'Altering [OW].[tblEntityLocation]'
GO
ALTER TABLE [OW].[tblEntityLocation] ADD
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InsertedOn] [datetime] NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LastModifiedOn] [datetime] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[tblEntityBIArquive]'
GO
ALTER TABLE [OW].[tblEntityBIArquive] ADD
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InsertedOn] [datetime] NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LastModifiedOn] [datetime] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[tblEntityJobPosition]'
GO
ALTER TABLE [OW].[tblEntityJobPosition] ADD
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InsertedOn] [datetime] NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LastModifiedOn] [datetime] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[tblEntityList]'
GO
ALTER TABLE [OW].[tblEntityList] ADD
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InsertedOn] [datetime] NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LastModifiedOn] [datetime] NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy=InsertedBy, @InsertedOn=InsertedOn, @LastModifiedBy=LastModifiedBy, @LastModifiedOn=LastModifiedOn FROM [OW].[##VariaveisGlobais]

UPDATE [OW].[tblEntityLocation] SET InsertedBy=@InsertedBy, InsertedOn=@InsertedOn, LastModifiedBy=@LastModifiedBy, LastModifiedOn=@LastModifiedOn
UPDATE [OW].[tblEntityBIArquive] SET InsertedBy=@InsertedBy, InsertedOn=@InsertedOn, LastModifiedBy=@LastModifiedBy, LastModifiedOn=@LastModifiedOn
UPDATE [OW].[tblEntityJobPosition] SET InsertedBy=@InsertedBy, InsertedOn=@InsertedOn, LastModifiedBy=@LastModifiedBy, LastModifiedOn=@LastModifiedOn
UPDATE [OW].[tblEntityList] SET InsertedBy=@InsertedBy, InsertedOn=@InsertedOn, LastModifiedBy=@LastModifiedBy, LastModifiedOn=@LastModifiedOn
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

ALTER TABLE [OW].[tblEntityLocation] ALTER COLUMN InsertedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityLocation] ALTER COLUMN InsertedOn datetime NOT NULL
ALTER TABLE [OW].[tblEntityLocation] ALTER COLUMN LastModifiedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityLocation] ALTER COLUMN LastModifiedOn datetime NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

ALTER TABLE [OW].[tblEntityBIArquive] ALTER COLUMN InsertedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityBIArquive] ALTER COLUMN InsertedOn datetime NOT NULL
ALTER TABLE [OW].[tblEntityBIArquive] ALTER COLUMN LastModifiedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityBIArquive] ALTER COLUMN LastModifiedOn datetime NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

ALTER TABLE [OW].[tblEntityJobPosition] ALTER COLUMN InsertedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityJobPosition] ALTER COLUMN InsertedOn datetime NOT NULL
ALTER TABLE [OW].[tblEntityJobPosition] ALTER COLUMN LastModifiedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityJobPosition] ALTER COLUMN LastModifiedOn datetime NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

ALTER TABLE [OW].[tblEntityList] ALTER COLUMN InsertedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityList] ALTER COLUMN InsertedOn datetime NOT NULL
ALTER TABLE [OW].[tblEntityList] ALTER COLUMN LastModifiedBy varchar(50) NOT NULL
ALTER TABLE [OW].[tblEntityList] ALTER COLUMN LastModifiedOn datetime NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- ---------------------------------------------------------------------------------
-- ALTERACAO DE PROCEDIMENTOS
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT N'ALTERACAO DE PROCEDIMENTOS'
PRINT ''
GO

PRINT N'Altering [OW].[EntitiesUpdate]'
GO
ALTER PROCEDURE [OW].EntitiesUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-04-2006 15:43:14
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntID numeric(18,0),
	@PublicCode varchar(20) = NULL,
	@Name varchar(255),
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(300) = NULL,
	@LastName varchar(50) = NULL,
	@ListID numeric(18,0) = NULL,
	@BI varchar(30) = NULL,
	@NumContribuinte varchar(30) = NULL,
	@AssociateNum numeric(18,0) = NULL,
	@eMail varchar(300) = NULL,
	@InternetSite varchar(80) = NULL,
	@JobTitle varchar(100) = NULL,
	@Street varchar(500) = NULL,
	@PostalCodeID int = NULL,
	@CountryID int = NULL,
	@Phone varchar(20) = NULL,
	@Fax varchar(20) = NULL,
	@Mobile varchar(20) = NULL,
	@DistrictID int = NULL,
	@EntityID numeric(18,0) = NULL,
	@EntityTypeID int,
	@Active bit,
	@Type tinyint,
	@BIEmissionDate smalldatetime = NULL,
	@BIArquiveID numeric(18,0) = NULL,
	@JobPositionID numeric(18,0) = NULL,
	@LocationID numeric(18,0) = NULL,
	@Contact varchar(255) = NULL,
	@Notes varchar(1024) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblEntities]
	SET
		[PublicCode] = @PublicCode,
		[Name] = @Name,
		[FirstName] = @FirstName,
		[MiddleName] = @MiddleName,
		[LastName] = @LastName,
		[ListID] = @ListID,
		[BI] = @BI,
		[NumContribuinte] = @NumContribuinte,
		[AssociateNum] = @AssociateNum,
		[eMail] = @eMail,
		[InternetSite] = @InternetSite,
		[JobTitle] = @JobTitle,
		[Street] = @Street,
		[PostalCodeID] = @PostalCodeID,
		[CountryID] = @CountryID,
		[Phone] = @Phone,
		[Fax] = @Fax,
		[Mobile] = @Mobile,
		[DistrictID] = @DistrictID,
		[EntityID] = @EntityID,
		[EntityTypeID] = @EntityTypeID,
		[Active] = @Active,
		[Type] = @Type,
		[BIEmissionDate] = @BIEmissionDate,
		[BIArquiveID] = @BIArquiveID,
		[JobPositionID] = @JobPositionID,
		[LocationID] = @LocationID,
		[Contact] = @Contact,
		[Notes] = @Notes,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[EntID] = @EntID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[EntitiesInsert]'
GO

ALTER PROCEDURE [OW].EntitiesInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-04-2006 15:43:14
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntID numeric(18,0) = NULL OUTPUT,
	@PublicCode varchar(20) = NULL,
	@Name varchar(255),
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(300) = NULL,
	@LastName varchar(50) = NULL,
	@ListID numeric(18,0) = NULL,
	@BI varchar(30) = NULL,
	@NumContribuinte varchar(30) = NULL,
	@AssociateNum numeric(18,0) = NULL,
	@eMail varchar(300) = NULL,
	@InternetSite varchar(80) = NULL,
	@JobTitle varchar(100) = NULL,
	@Street varchar(500) = NULL,
	@PostalCodeID int = NULL,
	@CountryID int = NULL,
	@Phone varchar(20) = NULL,
	@Fax varchar(20) = NULL,
	@Mobile varchar(20) = NULL,
	@DistrictID int = NULL,
	@EntityID numeric(18,0) = NULL,
	@EntityTypeID int,
	@Active bit,
	@Type tinyint,
	@BIEmissionDate smalldatetime = NULL,
	@BIArquiveID numeric(18,0) = NULL,
	@JobPositionID numeric(18,0) = NULL,
	@LocationID numeric(18,0) = NULL,
	@Contact varchar(255) = NULL,
	@Notes varchar(1024) = NULL,
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
	INTO [OW].[tblEntities]
	(
		[PublicCode],
		[Name],
		[FirstName],
		[MiddleName],
		[LastName],
		[ListID],
		[BI],
		[NumContribuinte],
		[AssociateNum],
		[eMail],
		[InternetSite],
		[JobTitle],
		[Street],
		[PostalCodeID],
		[CountryID],
		[Phone],
		[Fax],
		[Mobile],
		[DistrictID],
		[EntityID],
		[EntityTypeID],
		[Active],
		[Type],
		[BIEmissionDate],
		[BIArquiveID],
		[JobPositionID],
		[LocationID],
		[Contact],
		[Notes],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@PublicCode,
		@Name,
		@FirstName,
		@MiddleName,
		@LastName,
		@ListID,
		@BI,
		@NumContribuinte,
		@AssociateNum,
		@eMail,
		@InternetSite,
		@JobTitle,
		@Street,
		@PostalCodeID,
		@CountryID,
		@Phone,
		@Fax,
		@Mobile,
		@DistrictID,
		@EntityID,
		@EntityTypeID,
		@Active,
		@Type,
		@BIEmissionDate,
		@BIArquiveID,
		@JobPositionID,
		@LocationID,
		@Contact,
		@Notes,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @EntID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Altering [OW].[EntitiesSelect]'
GO

ALTER PROCEDURE [OW].EntitiesSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@EntID numeric(18,0) = NULL,
		@FirstName varchar(50) = NULL,
		@MiddleName varchar(300) = NULL,
		@LastName varchar(50) = NULL,
		@ListID numeric(18,0) = NULL,
		@BI varchar(30) = NULL,
		@NumContribuinte varchar(30) = NULL,
		@AssociateNum numeric(18,0) = NULL,
		@eMail varchar(300) = NULL,
		@JobTitle varchar(100) = NULL,
		@Street varchar(500) = NULL,
		@PostalCodeID int = NULL,
		@CountryID int = NULL,
		@Phone varchar(20) = NULL,
		@Fax varchar(20) = NULL,
		@Mobile varchar(20) = NULL,
		@DistrictID int = NULL,
		@EntityID numeric(18,0) = NULL,
		@Active bit = NULL,
		@Type tinyint = NULL,
		@BIEmissionDate smalldatetime = NULL,
		@BIArquiveID numeric(18,0) = NULL,
		@JobPositionID numeric(18,0) = NULL,
		@LocationID numeric(18,0) = NULL,
		@PublicCode varchar(20) = NULL,
		@Name varchar(255) = NULL,
		@InternetSite varchar(80) = NULL,
		@Contact varchar(255) = NULL,
		@EntityTypeID int = NULL,
		@Notes varchar(1024) = NULL,
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[EntID] '
		SET @sql = @sql + ',[FirstName] '
		SET @sql = @sql + ',[MiddleName] '
		SET @sql = @sql + ',[LastName] '
		SET @sql = @sql + ',[ListID] '
		SET @sql = @sql + ',[BI] '
		SET @sql = @sql + ',[NumContribuinte] '
		SET @sql = @sql + ',[AssociateNum] '
		SET @sql = @sql + ',[eMail] '
		SET @sql = @sql + ',[JobTitle] '
		SET @sql = @sql + ',[Street] '
		SET @sql = @sql + ',[PostalCodeID] '
		SET @sql = @sql + ',[CountryID] '
		SET @sql = @sql + ',[Phone] '
		SET @sql = @sql + ',[Fax] '
		SET @sql = @sql + ',[Mobile] '
		SET @sql = @sql + ',[DistrictID] '
		SET @sql = @sql + ',[EntityID] '
		SET @sql = @sql + ',[Active] '
		SET @sql = @sql + ',[Type] '
		SET @sql = @sql + ',[BIEmissionDate] '
		SET @sql = @sql + ',[BIArquiveID] '
		SET @sql = @sql + ',[JobPositionID] '
		SET @sql = @sql + ',[LocationID] '
		SET @sql = @sql + ',[PublicCode] '
		SET @sql = @sql + ',[Name] '
		SET @sql = @sql + ',[InternetSite] '
		SET @sql = @sql + ',[Contact] '
		SET @sql = @sql + ',[EntityTypeID] '
		SET @sql = @sql + ',[Notes] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntities] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@EntID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EntID] = @EntID AND '
		IF (@FirstName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FirstName] LIKE @FirstName AND '
		IF (@MiddleName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MiddleName] LIKE @MiddleName AND '
		IF (@LastName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastName] LIKE @LastName AND '
		IF (@ListID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ListID] = @ListID AND '
		IF (@BI IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[BI] LIKE @BI AND '
		IF (@NumContribuinte IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NumContribuinte] LIKE @NumContribuinte AND '
		IF (@AssociateNum IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AssociateNum] = @AssociateNum AND '
		IF (@eMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[eMail] LIKE @eMail AND '
		IF (@JobTitle IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[JobTitle] LIKE @JobTitle AND '
		IF (@Street IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Street] LIKE @Street AND '
		IF (@PostalCodeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[PostalCodeID] = @PostalCodeID AND '
		IF (@CountryID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CountryID] = @CountryID AND '
		IF (@Phone IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Phone] LIKE @Phone AND '
		IF (@Fax IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Fax] LIKE @Fax AND '
		IF (@Mobile IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Mobile] LIKE @Mobile AND '
		IF (@DistrictID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DistrictID] = @DistrictID AND '
		IF (@EntityID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EntityID] = @EntityID AND '
		IF (@Active IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Active] = @Active AND '
		IF (@Type IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Type] = @Type AND '
		IF (@BIEmissionDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[BIEmissionDate] = @BIEmissionDate AND '
		IF (@BIArquiveID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[BIArquiveID] = @BIArquiveID AND '
		IF (@JobPositionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[JobPositionID] = @JobPositionID AND '
		IF (@LocationID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LocationID] = @LocationID AND '
		IF (@PublicCode IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[PublicCode] LIKE @PublicCode AND '
		IF (@Name IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Name] LIKE @Name AND '
		IF (@InternetSite IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InternetSite] LIKE @InternetSite AND '
		IF (@Contact IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Contact] LIKE @Contact AND '
		IF (@EntityTypeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EntityTypeID] = @EntityTypeID AND '
		IF (@Notes IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Notes] LIKE @Notes AND '
		IF (@Remarks IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Remarks] LIKE @Remarks AND '
		IF (@InsertedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedBy] LIKE @InsertedBy AND '
		IF (@InsertedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedOn] = @InsertedOn AND '
		IF (@LastModifiedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedBy] LIKE @LastModifiedBy AND '
		IF (@LastModifiedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedOn] = @LastModifiedOn AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@EntID numeric(18,0), 
		@FirstName varchar(50), 
		@MiddleName varchar(300), 
		@LastName varchar(50), 
		@ListID numeric(18,0), 
		@BI varchar(30), 
		@NumContribuinte varchar(30), 
		@AssociateNum numeric(18,0), 
		@eMail varchar(300), 
		@JobTitle varchar(100), 
		@Street varchar(500), 
		@PostalCodeID int, 
		@CountryID int, 
		@Phone varchar(20), 
		@Fax varchar(20), 
		@Mobile varchar(20), 
		@DistrictID int, 
		@EntityID numeric(18,0), 
		@Active bit, 
		@Type tinyint, 
		@BIEmissionDate smalldatetime, 
		@BIArquiveID numeric(18,0), 
		@JobPositionID numeric(18,0), 
		@LocationID numeric(18,0), 
		@PublicCode varchar(20), 
		@Name varchar(255), 
		@InternetSite varchar(80), 
		@Contact varchar(255), 
		@EntityTypeID int, 
		@Notes varchar(1024), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@EntID, 
		@FirstName, 
		@MiddleName, 
		@LastName, 
		@ListID, 
		@BI, 
		@NumContribuinte, 
		@AssociateNum, 
		@eMail, 
		@JobTitle, 
		@Street, 
		@PostalCodeID, 
		@CountryID, 
		@Phone, 
		@Fax, 
		@Mobile, 
		@DistrictID, 
		@EntityID, 
		@Active, 
		@Type, 
		@BIEmissionDate, 
		@BIArquiveID, 
		@JobPositionID, 
		@LocationID, 
		@PublicCode, 
		@Name, 
		@InternetSite, 
		@Contact, 
		@EntityTypeID, 
		@Notes, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
		
		
		SET @Err = @@Error
		RETURN @Err
	END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[EntitiesSelectEx01]'
GO


ALTER  PROCEDURE [OW].EntitiesSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 11:00:00
	--Version: 2.0
	------------------------------------------------------------------------
	
	@EntID numeric(18,0) = NULL,
	@PublicCode varchar(20) = NULL,
	@Name varchar(255) = NULL,
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(300) = NULL,
	@LastName varchar(50) = NULL,
	@ListID numeric(18,0) = NULL,
	@BI varchar(30) = NULL,
	@NumContribuinte varchar(30) = NULL,
	@AssociateNum numeric(18,0) = NULL,
	@eMail varchar(300) = NULL,
	@InternetSite char(80) = NULL,
	@JobTitle varchar(100) = NULL,
	@Street varchar(500) = NULL,
	@PostalCodeID int = NULL,
	@CountryID int = NULL,
	@Phone varchar(20) = NULL,
	@Fax varchar(20) = NULL,
	@Mobile varchar(20) = NULL,
	@DistrictID int = NULL,
	@EntityID numeric(18,0) = NULL,
	@EntityTypeID int = NULL,
	@Active bit = NULL,
	@Type tinyint = NULL,
	@BIEmissionDate smalldatetime = NULL,
	@BIArquiveID numeric(18,0) = NULL,
	@JobPositionID numeric(18,0) = NULL,
	@LocationID numeric(18,0) = NULL,
	@Contact varchar(255) = NULL,
	@UserID int = NULL,
	@Notes varchar(1024) = NULL,
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
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'ent.[EntID] '
	SET @sql = @sql + ',ent.[PublicCode] '
	SET @sql = @sql + ',ent.[Name] '
	SET @sql = @sql + ',ent.[ListID] '
	SET @sql = @sql + ',entlist.[Description] AS List '
	SET @sql = @sql + ',ent.[BI] '
	SET @sql = @sql + ',ent.[NumContribuinte] '
	SET @sql = @sql + ',ent.[AssociateNum] '
	SET @sql = @sql + ',ent.[EntityTypeID] '
	SET @sql = @sql + ',enttype.[Description] AS EntityType '
	SET @sql = @sql + ',ent.[LocationID] '
	SET @sql = @sql + ',entloc.[Description] AS Location '
	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblEntities] ent INNER JOIN '
	SET @sql = @sql + '[OW].[tblEntityType] enttype ON ent.[EntityTypeID] = enttype.[EntityTypeID] INNER JOIN '
	SET @sql = @sql + '[OW].[tblEntityList] entlist ON ent.[ListID] = entlist.[ListID] LEFT OUTER JOIN '
	SET @sql = @sql + '[OW].[tblEntityLocation] entloc ON ent.[LocationID] = entloc.[LocationID] '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@EntID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[EntID] = @EntID AND '
	IF (@PublicCode IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[PublicCode] LIKE @PublicCode AND '
	IF (@Name IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Name] LIKE @Name AND '
	IF (@FirstName IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[FirstName] LIKE @FirstName AND '
	IF (@MiddleName IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[MiddleName] LIKE @MiddleName AND '
	IF (@LastName IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[LastName] LIKE @LastName AND '
	IF (@ListID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[ListID] = @ListID AND '
	IF (@BI IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[BI] LIKE @BI AND '
	IF (@NumContribuinte IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[NumContribuinte] LIKE @NumContribuinte AND '
	IF (@AssociateNum IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[AssociateNum] = @AssociateNum AND '
	IF (@eMail IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[eMail] LIKE @eMail AND '
	IF (@InternetSite IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[InternetSite] LIKE @InternetSite AND '
	IF (@JobTitle IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[JobTitle] LIKE @JobTitle AND '
	IF (@Street IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Street] LIKE @Street AND '
	IF (@PostalCodeID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[PostalCodeID] = @PostalCodeID AND '
	IF (@CountryID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[CountryID] = @CountryID AND '
	IF (@Phone IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Phone] LIKE @Phone AND '
	IF (@Fax IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Fax] LIKE @Fax AND '
	IF (@Mobile IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Mobile] LIKE @Mobile AND '
	IF (@DistrictID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[DistrictID] = @DistrictID AND '
	IF (@EntityID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[EntityID] = @EntityID AND '
	IF (@EntityTypeID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[EntityTypeID] = @EntityTypeID AND '
	IF (@Active IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Active] = @Active AND '
	IF (@Type IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Type] = @Type AND '
	IF (@BIEmissionDate IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[BIEmissionDate] = @BIEmissionDate AND '
	IF (@BIArquiveID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[BIArquiveID] = @BIArquiveID AND '
	IF (@JobPositionID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[JobPositionID] = @JobPositionID AND '
	IF (@LocationID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[LocationID] = @LocationID AND '
	IF (@Contact IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Contact] LIKE @Contact AND '
	IF (@Notes IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Notes] LIKE @Notes AND '
	IF (@Remarks IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[Remarks] LIKE @Remarks AND '
	IF (@InsertedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[InsertedBy] LIKE @InsertedBy AND '
	IF (@InsertedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[InsertedOn] = @InsertedOn AND '
	IF (@LastModifiedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[LastModifiedBy] LIKE @LastModifiedBy AND '
	IF (@LastModifiedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ent.[LastModifiedOn] = @LastModifiedOn AND '
	IF (@UserID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'EXISTS(SELECT 1 FROM OW.fnGetEntityListIDs(@UserID) lst WHERE ent.ListID = lst.ListID) AND '
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@EntID numeric(18,0),
	@PublicCode varchar(20),
	@Name varchar(255),
	@FirstName varchar(50),
	@MiddleName varchar(300),
	@LastName varchar(50),
	@ListID numeric(18,0),
	@BI varchar(30),
	@NumContribuinte varchar(30),
	@AssociateNum numeric(18,0),
	@eMail varchar(300),
	@InternetSite char(80),
	@JobTitle varchar(100),
	@Street varchar(500),
	@PostalCodeID int,
	@CountryID int,
	@Phone varchar(20),
	@Fax varchar(20),
	@Mobile varchar(20),
	@DistrictID int,
	@EntityID numeric(18,0),
	@EntityTypeID int,
	@Active bit,
	@Type tinyint,
	@BIEmissionDate smalldatetime,
	@BIArquiveID numeric(18,0),
	@JobPositionID numeric(18,0),
	@LocationID numeric(18,0),
	@Contact varchar(255),
	@UserID int,
	@Notes varchar(1024),
	@Remarks varchar(255),
	@InsertedBy varchar(50),
	@InsertedOn datetime,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime',
	@EntID,
	@PublicCode,
	@Name,
	@FirstName,
	@MiddleName,
	@LastName,
	@ListID,
	@BI,
	@NumContribuinte,
	@AssociateNum,
	@eMail,
	@InternetSite,
	@JobTitle,
	@Street,
	@PostalCodeID,
	@CountryID,
	@Phone,
	@Fax,
	@Mobile,
	@DistrictID,
	@EntityID,
	@EntityTypeID,
	@Active,
	@Type,
	@BIEmissionDate,
	@BIArquiveID,
	@JobPositionID,
	@LocationID,
	@Contact,
	@UserID,
	@Notes,
	@Remarks,
	@InsertedBy,
	@InsertedOn,
	@LastModifiedBy,
	@LastModifiedOn
	
	
	SET @Err = @@Error
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[EntitiesSelectPaging]'
GO

ALTER PROCEDURE [OW].EntitiesSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-04-2006 15:43:14
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntID numeric(18,0) = NULL,
	@PublicCode varchar(20) = NULL,
	@Name varchar(255) = NULL,
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(300) = NULL,
	@LastName varchar(50) = NULL,
	@ListID numeric(18,0) = NULL,
	@BI varchar(30) = NULL,
	@NumContribuinte varchar(30) = NULL,
	@AssociateNum numeric(18,0) = NULL,
	@eMail varchar(300) = NULL,
	@InternetSite varchar(80) = NULL,
	@JobTitle varchar(100) = NULL,
	@Street varchar(500) = NULL,
	@PostalCodeID int = NULL,
	@CountryID int = NULL,
	@Phone varchar(20) = NULL,
	@Fax varchar(20) = NULL,
	@Mobile varchar(20) = NULL,
	@DistrictID int = NULL,
	@EntityID numeric(18,0) = NULL,
	@EntityTypeID int = NULL,
	@Active bit = NULL,
	@Type tinyint = NULL,
	@BIEmissionDate smalldatetime = NULL,
	@BIArquiveID numeric(18,0) = NULL,
	@JobPositionID numeric(18,0) = NULL,
	@LocationID numeric(18,0) = NULL,
	@Contact varchar(255) = NULL,
	@Notes varchar(1024) = NULL,
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
	
	IF(@EntID IS NOT NULL) SET @WHERE = @WHERE + '([EntID] = @EntID) AND '
	IF(@PublicCode IS NOT NULL) SET @WHERE = @WHERE + '([PublicCode] LIKE @PublicCode) AND '
	IF(@Name IS NOT NULL) SET @WHERE = @WHERE + '([Name] LIKE @Name) AND '
	IF(@FirstName IS NOT NULL) SET @WHERE = @WHERE + '([FirstName] LIKE @FirstName) AND '
	IF(@MiddleName IS NOT NULL) SET @WHERE = @WHERE + '([MiddleName] LIKE @MiddleName) AND '
	IF(@LastName IS NOT NULL) SET @WHERE = @WHERE + '([LastName] LIKE @LastName) AND '
	IF(@ListID IS NOT NULL) SET @WHERE = @WHERE + '([ListID] = @ListID) AND '
	IF(@BI IS NOT NULL) SET @WHERE = @WHERE + '([BI] LIKE @BI) AND '
	IF(@NumContribuinte IS NOT NULL) SET @WHERE = @WHERE + '([NumContribuinte] LIKE @NumContribuinte) AND '
	IF(@AssociateNum IS NOT NULL) SET @WHERE = @WHERE + '([AssociateNum] = @AssociateNum) AND '
	IF(@eMail IS NOT NULL) SET @WHERE = @WHERE + '([eMail] LIKE @eMail) AND '
	IF(@InternetSite IS NOT NULL) SET @WHERE = @WHERE + '([InternetSite] LIKE @InternetSite) AND '
	IF(@JobTitle IS NOT NULL) SET @WHERE = @WHERE + '([JobTitle] LIKE @JobTitle) AND '
	IF(@Street IS NOT NULL) SET @WHERE = @WHERE + '([Street] LIKE @Street) AND '
	IF(@PostalCodeID IS NOT NULL) SET @WHERE = @WHERE + '([PostalCodeID] = @PostalCodeID) AND '
	IF(@CountryID IS NOT NULL) SET @WHERE = @WHERE + '([CountryID] = @CountryID) AND '
	IF(@Phone IS NOT NULL) SET @WHERE = @WHERE + '([Phone] LIKE @Phone) AND '
	IF(@Fax IS NOT NULL) SET @WHERE = @WHERE + '([Fax] LIKE @Fax) AND '
	IF(@Mobile IS NOT NULL) SET @WHERE = @WHERE + '([Mobile] LIKE @Mobile) AND '
	IF(@DistrictID IS NOT NULL) SET @WHERE = @WHERE + '([DistrictID] = @DistrictID) AND '
	IF(@EntityID IS NOT NULL) SET @WHERE = @WHERE + '([EntityID] = @EntityID) AND '
	IF(@EntityTypeID IS NOT NULL) SET @WHERE = @WHERE + '([EntityTypeID] = @EntityTypeID) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '([Active] = @Active) AND '
	IF(@Type IS NOT NULL) SET @WHERE = @WHERE + '([Type] = @Type) AND '
	IF(@BIEmissionDate IS NOT NULL) SET @WHERE = @WHERE + '([BIEmissionDate] = @BIEmissionDate) AND '
	IF(@BIArquiveID IS NOT NULL) SET @WHERE = @WHERE + '([BIArquiveID] = @BIArquiveID) AND '
	IF(@JobPositionID IS NOT NULL) SET @WHERE = @WHERE + '([JobPositionID] = @JobPositionID) AND '
	IF(@LocationID IS NOT NULL) SET @WHERE = @WHERE + '([LocationID] = @LocationID) AND '
	IF(@Contact IS NOT NULL) SET @WHERE = @WHERE + '([Contact] LIKE @Contact) AND '
	IF(@Notes IS NOT NULL) SET @WHERE = @WHERE + '([Notes] LIKE @Notes) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(EntID) 
	FROM [OW].[tblEntities]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@EntID numeric(18,0), 
		@PublicCode varchar(20), 
		@Name varchar(255), 
		@FirstName varchar(50), 
		@MiddleName varchar(300), 
		@LastName varchar(50), 
		@ListID numeric(18,0), 
		@BI varchar(30), 
		@NumContribuinte varchar(30), 
		@AssociateNum numeric(18,0), 
		@eMail varchar(300), 
		@InternetSite varchar(80), 
		@JobTitle varchar(100), 
		@Street varchar(500), 
		@PostalCodeID int, 
		@CountryID int, 
		@Phone varchar(20), 
		@Fax varchar(20), 
		@Mobile varchar(20), 
		@DistrictID int, 
		@EntityID numeric(18,0), 
		@EntityTypeID int, 
		@Active bit, 
		@Type tinyint, 
		@BIEmissionDate smalldatetime, 
		@BIArquiveID numeric(18,0), 
		@JobPositionID numeric(18,0), 
		@LocationID numeric(18,0), 
		@Contact varchar(255), 
		@Notes varchar(1024), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@EntID, 
		@PublicCode, 
		@Name, 
		@FirstName, 
		@MiddleName, 
		@LastName, 
		@ListID, 
		@BI, 
		@NumContribuinte, 
		@AssociateNum, 
		@eMail, 
		@InternetSite, 
		@JobTitle, 
		@Street, 
		@PostalCodeID, 
		@CountryID, 
		@Phone, 
		@Fax, 
		@Mobile, 
		@DistrictID, 
		@EntityID, 
		@EntityTypeID, 
		@Active, 
		@Type, 
		@BIEmissionDate, 
		@BIArquiveID, 
		@JobPositionID, 
		@LocationID, 
		@Contact, 
		@Notes, 
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
	WHERE EntID IN (
		SELECT TOP ' + @SizeString + ' EntID
			FROM [OW].[tblEntities]
			WHERE EntID NOT IN (
				SELECT TOP ' + @PrevString + ' EntID 
				FROM [OW].[tblEntities]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[EntID], 
		[PublicCode], 
		[Name], 
		[FirstName], 
		[MiddleName], 
		[LastName], 
		[ListID], 
		[BI], 
		[NumContribuinte], 
		[AssociateNum], 
		[eMail], 
		[InternetSite], 
		[JobTitle], 
		[Street], 
		[PostalCodeID], 
		[CountryID], 
		[Phone], 
		[Fax], 
		[Mobile], 
		[DistrictID], 
		[EntityID], 
		[EntityTypeID], 
		[Active], 
		[Type], 
		[BIEmissionDate], 
		[BIArquiveID], 
		[JobPositionID], 
		[LocationID], 
		[Contact], 
		[Notes], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblEntities]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@EntID numeric(18,0), 
		@PublicCode varchar(20), 
		@Name varchar(255), 
		@FirstName varchar(50), 
		@MiddleName varchar(300), 
		@LastName varchar(50), 
		@ListID numeric(18,0), 
		@BI varchar(30), 
		@NumContribuinte varchar(30), 
		@AssociateNum numeric(18,0), 
		@eMail varchar(300), 
		@InternetSite varchar(80), 
		@JobTitle varchar(100), 
		@Street varchar(500), 
		@PostalCodeID int, 
		@CountryID int, 
		@Phone varchar(20), 
		@Fax varchar(20), 
		@Mobile varchar(20), 
		@DistrictID int, 
		@EntityID numeric(18,0), 
		@EntityTypeID int, 
		@Active bit, 
		@Type tinyint, 
		@BIEmissionDate smalldatetime, 
		@BIArquiveID numeric(18,0), 
		@JobPositionID numeric(18,0), 
		@LocationID numeric(18,0), 
		@Contact varchar(255), 
		@Notes varchar(1024), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@EntID, 
		@PublicCode, 
		@Name, 
		@FirstName, 
		@MiddleName, 
		@LastName, 
		@ListID, 
		@BI, 
		@NumContribuinte, 
		@AssociateNum, 
		@eMail, 
		@InternetSite, 
		@JobTitle, 
		@Street, 
		@PostalCodeID, 
		@CountryID, 
		@Phone, 
		@Fax, 
		@Mobile, 
		@DistrictID, 
		@EntityID, 
		@EntityTypeID, 
		@Active, 
		@Type, 
		@BIEmissionDate, 
		@BIArquiveID, 
		@JobPositionID, 
		@LocationID, 
		@Contact, 
		@Notes, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[EntitiesSelectPagingEx01]'
GO


ALTER  PROCEDURE [OW].EntitiesSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 11-04-2006 11:25:40
	--Version: 1.7
	------------------------------------------------------------------------
	@EntID numeric(18,0) = NULL,
	@PublicCode varchar(20) = NULL,
	@Name varchar(255) = NULL,
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(300) = NULL,
	@LastName varchar(50) = NULL,
	@ListID numeric(18,0) = NULL,
	@BI varchar(30) = NULL,
	@NumContribuinte varchar(30) = NULL,
	@AssociateNum numeric(18,0) = NULL,
	@eMail varchar(300) = NULL,
	@InternetSite char(80) = NULL,
	@JobTitle varchar(100) = NULL,
	@Street varchar(500) = NULL,
	@PostalCodeID int = NULL,
	@CountryID int = NULL,
	@Phone varchar(20) = NULL,
	@Fax varchar(20) = NULL,
	@Mobile varchar(20) = NULL,
	@DistrictID int = NULL,
	@EntityID numeric(18,0) = NULL,
	@EntityTypeID int = NULL,
	@Active bit = NULL,
	@Type tinyint = NULL,
	@BIEmissionDate smalldatetime = NULL,
	@BIArquiveID numeric(18,0) = NULL,
	@JobPositionID numeric(18,0) = NULL,
	@LocationID numeric(18,0) = NULL,
	@Contact varchar(255) = NULL,
	@UserID int = NULL,
	@Notes varchar(1024) = NULL,
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
	
	IF(@EntID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[EntID] = @EntID) AND '
	IF(@PublicCode IS NOT NULL) SET @WHERE = @WHERE + '(ent.[PublicCode] LIKE @PublicCode) AND '
	IF(@Name IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Name] LIKE @Name) AND '
	IF(@FirstName IS NOT NULL) SET @WHERE = @WHERE + '(ent.[FirstName] LIKE @FirstName) AND '
	IF(@MiddleName IS NOT NULL) SET @WHERE = @WHERE + '(ent.[MiddleName] LIKE @MiddleName) AND '
	IF(@LastName IS NOT NULL) SET @WHERE = @WHERE + '(ent.[LastName] LIKE @LastName) AND '
	IF(@ListID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[ListID] = @ListID) AND '
	IF(@BI IS NOT NULL) SET @WHERE = @WHERE + '(ent.[BI] LIKE @BI) AND '
	IF(@NumContribuinte IS NOT NULL) SET @WHERE = @WHERE + '(ent.[NumContribuinte] LIKE @NumContribuinte) AND '
	IF(@AssociateNum IS NOT NULL) SET @WHERE = @WHERE + '(ent.[AssociateNum] = @AssociateNum) AND '
	IF(@eMail IS NOT NULL) SET @WHERE = @WHERE + '(ent.[eMail] LIKE @eMail) AND '
	IF(@InternetSite IS NOT NULL) SET @WHERE = @WHERE + '(ent.[InternetSite] = @InternetSite) AND '
	IF(@JobTitle IS NOT NULL) SET @WHERE = @WHERE + '(ent.[JobTitle] LIKE @JobTitle) AND '
	IF(@Street IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Street] LIKE @Street) AND '
	IF(@PostalCodeID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[PostalCodeID] = @PostalCodeID) AND '
	IF(@CountryID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[CountryID] = @CountryID) AND '
	IF(@Phone IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Phone] LIKE @Phone) AND '
	IF(@Fax IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Fax] LIKE @Fax) AND '
	IF(@Mobile IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Mobile] LIKE @Mobile) AND '
	IF(@DistrictID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[DistrictID] = @DistrictID) AND '
	IF(@EntityID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[EntityID] = @EntityID) AND '
	IF(@EntityTypeID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[EntityTypeID] = @EntityTypeID) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Active] = @Active) AND '
	IF(@Type IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Type] = @Type) AND '
	IF(@BIEmissionDate IS NOT NULL) SET @WHERE = @WHERE + '(ent.[BIEmissionDate] = @BIEmissionDate) AND '
	IF(@BIArquiveID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[BIArquiveID] = @BIArquiveID) AND '
	IF(@JobPositionID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[JobPositionID] = @JobPositionID) AND '
	IF(@LocationID IS NOT NULL) SET @WHERE = @WHERE + '(ent.[LocationID] = @LocationID) AND '
	IF(@Contact IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Contact] LIKE @Contact) AND '
	IF(@Notes IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Notes] LIKE @Notes) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '(ent.[Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '(ent.[InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '(ent.[InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '(ent.[LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '(ent.[LastModifiedOn] = @LastModifiedOn) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '(EXISTS(SELECT 1 FROM OW.fnGetEntityListIDs ('+ CAST(@UserID AS VARCHAR(18)) +') lst WHERE ent.ListID = lst.ListID)) AND '
	

	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)

	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ent.EntID) 
	FROM [OW].[tblEntities] ent
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@EntID numeric(18,0), 
		@PublicCode varchar(20), 
		@Name varchar(255), 
		@FirstName varchar(50), 
		@MiddleName varchar(300), 
		@LastName varchar(50), 
		@ListID numeric(18,0), 
		@BI varchar(30), 
		@NumContribuinte varchar(30), 
		@AssociateNum numeric(18,0), 
		@eMail varchar(300), 
		@InternetSite char(80), 
		@JobTitle varchar(100), 
		@Street varchar(500), 
		@PostalCodeID int, 
		@CountryID int, 
		@Phone varchar(20), 
		@Fax varchar(20), 
		@Mobile varchar(20), 
		@DistrictID int, 
		@EntityID numeric(18,0), 
		@EntityTypeID int, 
		@Active bit, 
		@Type tinyint, 
		@BIEmissionDate smalldatetime, 
		@BIArquiveID numeric(18,0), 
		@JobPositionID numeric(18,0), 
		@LocationID numeric(18,0), 
		@Contact varchar(255),
		@UserID int, 
		@Notes varchar(1024), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@EntID, 
		@PublicCode, 
		@Name, 
		@FirstName, 
		@MiddleName, 
		@LastName, 
		@ListID, 
		@BI, 
		@NumContribuinte, 
		@AssociateNum, 
		@eMail, 
		@InternetSite, 
		@JobTitle, 
		@Street, 
		@PostalCodeID, 
		@CountryID, 
		@Phone, 
		@Fax, 
		@Mobile, 
		@DistrictID, 
		@EntityID, 
		@EntityTypeID, 
		@Active, 
		@Type, 
		@BIEmissionDate, 
		@BIArquiveID, 
		@JobPositionID, 
		@LocationID, 
		@Contact,
		@UserID, 
		@Notes, 
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
	WHERE ent.EntID IN (
		SELECT TOP ' + @SizeString + ' ent.EntID
			FROM [OW].[tblEntities] ent
			INNER JOIN [OW].[tblEntityType] enttype
			ON ent.[EntityTypeID] = enttype.[EntityTypeID]
			INNER JOIN [OW].[tblEntityList] entlist
			ON ent.[ListID] = entlist.[ListID]			
			LEFT OUTER JOIN [OW].[tblEntityLocation] entloc
			ON ent.[LocationID] = entloc.[LocationID]
			WHERE ent.EntID NOT IN (
				SELECT TOP ' + @PrevString + ' ent.EntID 
				FROM [OW].[tblEntities] ent
				INNER JOIN [OW].[tblEntityType] enttype
				ON ent.[EntityTypeID] = enttype.[EntityTypeID]
				INNER JOIN [OW].[tblEntityList] entlist
				ON ent.[ListID] = entlist.[ListID]
				LEFT OUTER JOIN [OW].[tblEntityLocation] entloc
				ON ent.[LocationID] = entloc.[LocationID]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		ent.[EntID],
		ent.[PublicCode],
		ent.[Name],
		ent.[ListID],
		entlist.[Description] AS List,
		ent.[BI],
		ent.[NumContribuinte],
		ent.[AssociateNum],
		ent.[EntityTypeID],
		enttype.[Description] AS EntityType,
		ent.[LocationID],
		entloc.[Description] AS Location
	FROM [OW].[tblEntities] ent
	INNER JOIN [OW].[tblEntityType] enttype
	ON ent.[EntityTypeID] = enttype.[EntityTypeID]
	INNER JOIN [OW].[tblEntityList] entlist
	ON ent.[ListID] = entlist.[ListID]
	LEFT OUTER JOIN [OW].[tblEntityLocation] entloc
	ON ent.[LocationID] = entloc.[LocationID]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@EntID numeric(18,0), 
		@PublicCode varchar(20), 
		@Name varchar(255), 
		@FirstName varchar(50), 
		@MiddleName varchar(300), 
		@LastName varchar(50), 
		@ListID numeric(18,0), 
		@BI varchar(30), 
		@NumContribuinte varchar(30), 
		@AssociateNum numeric(18,0), 
		@eMail varchar(300), 
		@InternetSite char(80), 
		@JobTitle varchar(100), 
		@Street varchar(500), 
		@PostalCodeID int, 
		@CountryID int, 
		@Phone varchar(20), 
		@Fax varchar(20), 
		@Mobile varchar(20), 
		@DistrictID int, 
		@EntityID numeric(18,0), 
		@EntityTypeID int, 
		@Active bit, 
		@Type tinyint, 
		@BIEmissionDate smalldatetime, 
		@BIArquiveID numeric(18,0), 
		@JobPositionID numeric(18,0), 
		@LocationID numeric(18,0), 
		@Contact varchar(255), 
		@UserID int,
		@Notes varchar(1024), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@EntID, 
		@PublicCode, 
		@Name, 
		@FirstName, 
		@MiddleName, 
		@LastName, 
		@ListID, 
		@BI, 
		@NumContribuinte, 
		@AssociateNum, 
		@eMail, 
		@InternetSite, 
		@JobTitle, 
		@Street, 
		@PostalCodeID, 
		@CountryID, 
		@Phone, 
		@Fax, 
		@Mobile, 
		@DistrictID, 
		@EntityID, 
		@EntityTypeID, 
		@Active, 
		@Type, 
		@BIEmissionDate, 
		@BIArquiveID, 
		@JobPositionID, 
		@LocationID, 
		@Contact, 
		@UserID,
		@Notes, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Altering [OW].[usp_GetDistributionAutomaticReport]'
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
			WHEN TypeID='1' THEN 'Correio Electrónico'
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[usp_GetEntityLocation]'
GO

ALTER  PROCEDURE OW.usp_GetEntityLocation
(
	@LocationID numeric(18,0) = null,
	@Description varchar(250) = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	IF @LocationID is not null and @LocationID <> -2147483648
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
		FROM [OW].[tblEntityLocation] order by [Description]
	END
	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- ---------------------------------------------------------------------------------
-- NOVOS DE PROCEDIMENTOS
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT N'NOVOS PROCEDIMENTOS'
PRINT ''
GO

PRINT N'Creating [OW].[BIArquiveDelete]'
GO
CREATE PROCEDURE [OW].BIArquiveDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@BIArquiveID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityBIArquive]
	WHERE
		[BIArquiveID] = @BIArquiveID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[BIArquiveInsert]'
GO




CREATE PROCEDURE [OW].BIArquiveInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@BIArquiveID int = NULL OUTPUT,
	@Description varchar(250),
	@Global bit = NULL,
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
	INTO [OW].[tblEntityBIArquive]
	(
		[Description],
		[Global],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@Global,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @BIArquiveID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[BIArquiveUpdate]'
GO

CREATE PROCEDURE [OW].BIArquiveUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@BIArquiveID int,
	@Description varchar(250),
	@Global bit, 
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblEntityBIArquive]
	SET
		[Description] = @Description,
		[Global] = @Global,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[BIArquiveID] = @BIArquiveID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[BIArquiveSelect]'
GO

CREATE PROCEDURE [OW].BIArquiveSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.0	
		------------------------------------------------------------------------
		
		@BIArquiveID int = NULL,
		@Description varchar(250) = NULL,
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[BIArquiveID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Global] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntityBIArquive] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@BIArquiveID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[BIArquiveID] = @BIArquiveID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Global IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Global] = @Global AND '
		IF (@Remarks IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Remarks] LIKE @Remarks AND '
		IF (@InsertedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedBy] LIKE @InsertedBy AND '
		IF (@InsertedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedOn] = @InsertedOn AND '
		IF (@LastModifiedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedBy] LIKE @LastModifiedBy AND '
		IF (@LastModifiedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedOn] = @LastModifiedOn AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@BIArquiveID int, 
		@Description varchar(250), 
		@Global bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@BIArquiveID, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[BIArquiveSelectPaging]'
GO

CREATE PROCEDURE [OW].BIArquiveSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@BIArquiveID int = NULL,
	@Description varchar(250) = NULL,
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
	
	IF(@BIArquiveID IS NOT NULL) SET @WHERE = @WHERE + '([BIArquiveID] = @BIArquiveID) AND '
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
	SELECT @RowCount = COUNT(BIArquiveID) 
	FROM [OW].[tblEntityBIArquive]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@BIArquiveID int, 
		@Description varchar(250), 
		@Global bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@BIArquiveID, 
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
	WHERE BIArquiveID IN (
		SELECT TOP ' + @SizeString + ' BIArquiveID
			FROM [OW].[tblEntityBIArquive]
			WHERE BIArquiveID NOT IN (
				SELECT TOP ' + @PrevString + ' BIArquiveID 
				FROM [OW].[tblEntityBIArquive]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[BIArquiveID], 
		[Description],
		[Global], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblEntityBIArquive]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@BIArquiveID int, 
		@Description varchar(250), 
		@Global bit,
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@BIArquiveID, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Creating [OW].[EntityListDelete]'
GO
CREATE PROCEDURE [OW].EntityListDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@ListID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityList]
	WHERE
		[ListID] = @ListID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[EntityListInsert]'
GO




CREATE PROCEDURE [OW].EntityListInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@ListID int = NULL OUTPUT,
	@Description varchar(250),
	@Global bit = NULL,
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
	INTO [OW].[tblEntityList]
	(
		[Description],
		[Global],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@Global,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ListID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[EntityListUpdate]'
GO



CREATE PROCEDURE [OW].EntityListUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@ListID int,
	@Description varchar(250),
	@Global bit, 
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblEntityList]
	SET
		[Description] = @Description,
		[Global] = @Global,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ListID] = @ListID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[EntityListSelect]'
GO




CREATE PROCEDURE [OW].EntityListSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.0	
		------------------------------------------------------------------------
		
		@ListID int = NULL,
		@Description varchar(250) = NULL,
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[ListID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Global] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntityList] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ListID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ListID] = @ListID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Global IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Global] = @Global AND '
		IF (@Remarks IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Remarks] LIKE @Remarks AND '
		IF (@InsertedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedBy] LIKE @InsertedBy AND '
		IF (@InsertedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedOn] = @InsertedOn AND '
		IF (@LastModifiedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedBy] LIKE @LastModifiedBy AND '
		IF (@LastModifiedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedOn] = @LastModifiedOn AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@ListID int, 
		@Description varchar(250), 
		@Global bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ListID, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[EntityListSelectPaging]'
GO



CREATE PROCEDURE [OW].EntityListSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@ListID int = NULL,
	@Description varchar(250) = NULL,
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
	
	IF(@ListID IS NOT NULL) SET @WHERE = @WHERE + '([ListID] = @ListID) AND '
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
	SELECT @RowCount = COUNT(ListID) 
	FROM [OW].[tblEntityList]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ListID int, 
		@Description varchar(250), 
		@Global bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ListID, 
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
	WHERE ListID IN (
		SELECT TOP ' + @SizeString + ' ListID
			FROM [OW].[tblEntityList]
			WHERE ListID NOT IN (
				SELECT TOP ' + @PrevString + ' ListID 
				FROM [OW].[tblEntityList]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ListID], 
		[Description],
		[Global], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblEntityList]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ListID int, 
		@Description varchar(250), 
		@Global bit,
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ListID, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Creating [OW].[JobPositionDelete]'
GO
CREATE PROCEDURE [OW].JobPositionDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@JobPositionID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityJobPosition]
	WHERE
		[JobPositionID] = @JobPositionID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[JobPositionInsert]'
GO




CREATE PROCEDURE [OW].JobPositionInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@JobPositionID int = NULL OUTPUT,
	@Description varchar(250),
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
	INTO [OW].[tblEntityJobPosition]
	(
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @JobPositionID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[JobPositionUpdate]'
GO



CREATE PROCEDURE [OW].JobPositionUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@JobPositionID int,
	@Description varchar(250),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblEntityJobPosition]
	SET
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[JobPositionID] = @JobPositionID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[JobPositionSelect]'
GO




CREATE PROCEDURE [OW].JobPositionSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.0	
		------------------------------------------------------------------------
		
		@JobPositionID int = NULL,
		@Description varchar(250) = NULL,
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[JobPositionID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntityJobPosition] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@JobPositionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[JobPositionID] = @JobPositionID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Remarks IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Remarks] LIKE @Remarks AND '
		IF (@InsertedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedBy] LIKE @InsertedBy AND '
		IF (@InsertedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedOn] = @InsertedOn AND '
		IF (@LastModifiedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedBy] LIKE @LastModifiedBy AND '
		IF (@LastModifiedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedOn] = @LastModifiedOn AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@JobPositionID int, 
		@Description varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@JobPositionID, 
		@Description, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[JobPositionSelectPaging]'
GO



CREATE PROCEDURE [OW].JobPositionSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@JobPositionID int = NULL,
	@Description varchar(250) = NULL,
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
	
	IF(@JobPositionID IS NOT NULL) SET @WHERE = @WHERE + '([JobPositionID] = @JobPositionID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(JobPositionID) 
	FROM [OW].[tblEntityJobPosition]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@JobPositionID int, 
		@Description varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@JobPositionID, 
		@Description, 
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
	WHERE JobPositionID IN (
		SELECT TOP ' + @SizeString + ' JobPositionID
			FROM [OW].[tblEntityJobPosition]
			WHERE JobPositionID NOT IN (
				SELECT TOP ' + @PrevString + ' JobPositionID 
				FROM [OW].[tblEntityJobPosition]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[JobPositionID], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblEntityJobPosition]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@JobPositionID int, 
		@Description varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@JobPositionID, 
		@Description, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Creating [OW].[LocationDelete]'
GO
CREATE PROCEDURE [OW].LocationDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@LocationID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityLocation]
	WHERE
		[LocationID] = @LocationID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[LocationInsert]'
GO




CREATE PROCEDURE [OW].LocationInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@LocationID int = NULL OUTPUT,
	@Description varchar(250),
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
	INTO [OW].[tblEntityLocation]
	(
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @LocationID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[LocationUpdate]'
GO



CREATE PROCEDURE [OW].LocationUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@LocationID int,
	@Description varchar(250),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblEntityLocation]
	SET
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[LocationID] = @LocationID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50002,16,1)                       	
	END 	
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[LocationSelect]'
GO




CREATE PROCEDURE [OW].LocationSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.0	
		------------------------------------------------------------------------
		
		@LocationID int = NULL,
		@Description varchar(250) = NULL,
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[LocationID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntityLocation] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@LocationID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LocationID] = @LocationID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Remarks IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Remarks] LIKE @Remarks AND '
		IF (@InsertedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedBy] LIKE @InsertedBy AND '
		IF (@InsertedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[InsertedOn] = @InsertedOn AND '
		IF (@LastModifiedBy IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedBy] LIKE @LastModifiedBy AND '
		IF (@LastModifiedOn IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastModifiedOn] = @LastModifiedOn AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@LocationID int, 
		@Description varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@LocationID, 
		@Description, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[LocationSelectPaging]'
GO



CREATE PROCEDURE [OW].LocationSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 22-02-2011 19:30:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@LocationID int = NULL,
	@Description varchar(250) = NULL,
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
	
	IF(@LocationID IS NOT NULL) SET @WHERE = @WHERE + '([LocationID] = @LocationID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(LocationID) 
	FROM [OW].[tblEntityLocation]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@LocationID int, 
		@Description varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@LocationID, 
		@Description, 
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
	WHERE LocationID IN (
		SELECT TOP ' + @SizeString + ' LocationID
			FROM [OW].[tblEntityLocation]
			WHERE LocationID NOT IN (
				SELECT TOP ' + @PrevString + ' LocationID 
				FROM [OW].[tblEntityLocation]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[LocationID], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblEntityLocation]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@LocationID int, 
		@Description varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@LocationID, 
		@Description, 
		@Remarks, 
		@InsertedBy, 
		@InsertedOn, 
		@LastModifiedBy, 
		@LastModifiedOn
	
	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Creating [OW].[CheckNifUniqueness]'
GO
CREATE PROCEDURE [OW].CheckNifUniqueness
(
	@EntID int = NULL,
	@Nif varchar(30) = NULL,
	@IsUnique tinyint output
)
AS
BEGIN

	IF @EntID IS NOT NULL
	BEGIN
		IF EXISTS(SELECT 1 FROM OW.tblEntities WHERE NumContribuinte = @Nif AND EntId <> @EntID)
		  	SET @IsUnique = 0		
		ELSE
		  	SET @IsUnique = 1		
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM OW.tblEntities WHERE NumContribuinte = @Nif)
		  	SET @IsUnique = 0		
		ELSE
		  	SET @IsUnique = 1		
	END

	RETURN
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO


PRINT N'Altering [OW].[usp_DeleteDistributionTemp]'
GO
ALTER PROCEDURE OW.usp_DeleteDistributionTemp
	(
		@tmpID numeric,
		@logonUser varchar(50)
	)
AS
	DELETE FROM OW.tblDistribTemp WHERE tmpID = @tmpID

	IF (@@ERROR <> 0)
		RETURN 1
	ELSE 
	RETURN 0

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSAO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.8.0' WHERE id=1
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO


IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.7.2 PARA 5.8.0'
PRINT ''
COMMIT TRANSACTION
END
ELSE PRINT 'O update da base de dados falhou.'
GO
DROP TABLE #tmpErrors
GO

--Dependendo dos dados pode levar algum tempo
--Index keys

PRINT N'Creating index [IX_tblRegistry_Entity] on [OW].[tblRegistry]'
GO
CREATE NONCLUSTERED INDEX [IX_tblRegistry_Entity] ON [OW].[tblRegistry] ([entID])
GO

PRINT N'Creating index [IX_tblRegistry_ProdEntity] on [OW].[tblRegistry]'
GO
CREATE NONCLUSTERED INDEX [IX_tblRegistry_ProdEntity] ON [OW].[tblRegistry] ([ProdEntityID])
GO

PRINT N'Creating index [IX_tblUser] on [OW].[tblUser]'
GO
CREATE NONCLUSTERED INDEX [IX_tblUser] ON [OW].[tblUser] ([EntityID])
GO

-- ---------------------------------------------------------------------------------
--
-- FIM DO UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.7.2 PARA A VERSÃO 5.8.0
--
-- ---------------------------------------------------------------------------------
