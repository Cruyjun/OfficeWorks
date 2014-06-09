-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.8.1 PARA A VERSÃO 5.8.2
--
-- ---------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
--
-- NOTA IMPORTANTE:
--
-- ---------------------------------------------------------------------------------------------------------
-- . Esta versão actualiza dados baseados em dados dos CTT: http://www.ctt.pt
-- . A actualização desses dados faz sentido sobretudo em clientes de PORTUGAL.
-- . Esta versão necessita que se crie uma pasta C:\CTT com os ficheiros disponibilizados nesta versão 
--   na pasta CTT (todos_cp.txt e distritos.txt) para que a script de Sql execute sem problemas.
------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------
--
-- Tabela Códigos Postais (Todos_CP) 
-- Source: http://www.ctt.pt
--
-- --------------------------------------------------------------------------------------- 

CREATE TABLE [dbo].[todos_cp](
	[Código do Distrito] [varchar](50) NULL,
	[Código do Concelho] [varchar](50) NULL,
	[Código da localidade] [varchar](50) NULL,
	[Nome da localidade] [varchar](50) NULL,
	[Código da Artéria] [varchar](50) NULL,
	[Artéria - Tipo (Rua, Praça, etc)] [varchar](50) NULL,
	[Primeira preposição] [varchar](50) NULL,
	[Artéria - Titulo (Doutor, Engº, Professor, etc)] [varchar](50) NULL,
	[Segunda preposição] [varchar](50) NULL,
	[Artéria - Designação] [varchar](100) NULL,
	[Artéria - Informação do Local-Zona] [varchar](100) NULL,
	[Descrição do troço] [varchar](100) NULL,
	[Número da porta do cliente] [varchar](50) NULL,
	[Nome do cliente] [varchar](100) NULL,
	[Nº do código postal] [varchar](50) NULL,
	[Extensão do nº do código postal] [varchar](50) NULL,
	[Designação Postal] [varchar](50) NULL
) ON [PRIMARY]
GO


BULK INSERT [dbo].[todos_cp] 
    FROM 'C:\CTT\Todos_CP.txt' 
    WITH 
    ( 
        FIRSTROW = 2, 
        MAXERRORS = 0,
        CODEPAGE =  'ACP',
        KEEPIDENTITY,
        FIELDTERMINATOR = ';', 
        ROWTERMINATOR = '\n' 
    )
GO


-- ---------------------------------------------------------------------------------------
--
-- Tabela Distritos (Distritos) 
-- Source: http://www.ctt.pt
--
-- --------------------------------------------------------------------------------------- 

CREATE TABLE [dbo].[distritos](
	[Código do Distrito] [varchar](50) NULL,
	[Designação do Distrito] [varchar](50) NULL
) ON [PRIMARY]
GO


BULK INSERT [dbo].[distritos] 
    FROM 'C:\CTT\distritos.txt' 
    WITH 
    ( 
        FIRSTROW = 2, 
        MAXERRORS = 0,
        CODEPAGE =  'ACP',
        KEEPIDENTITY,
        FIELDTERMINATOR = ';', 
        ROWTERMINATOR = '\n' 
    )
 GO
    
    
-- ---------------------------------------------------------------------------------------
--
-- Passo opcional
--
-- Correr a seguinte instrução apenas se o cliente tiver a base de dados vazia ou se a 
-- tablela de códigos postais do OfficeWorks não tiver dados significativos.
-- ATENCAO : : : PARA O HESE, Não correr !!!
-- --------------------------------------------------------------------------------------- 

INSERT INTO [OW].[tblPostalCode]
(
	 [Code]
	,[Description]
	,[InsertedBy]
	,[InsertedOn]
	,[LastModifiedBy]
	,[LastModifiedOn]
)          
SELECT 
  Distinct
	 CP.[Nº do código postal] + '-' + CP.[Extensão do nº do código postal]
	,CP.[Designação Postal]
	,'Administrador OfficeWorks'
	,GETDATE()
	,'Administrador OfficeWorks'
	,GETDATE()
FROM [dbo].[todos_cp] CP
WHERE NOT EXISTS (SELECT 1 FROM [OW].[tblPostalCode] P WHERE P.Code = CP.[Nº do código postal] + '-' + CP.[Extensão do nº do código postal] and P.[Description] = CP.[Designação Postal])
ORDER BY CP.[Nº do código postal] + '-' + CP.[Extensão do nº do código postal]
GO



------------------------------------------------------------------------
-- Criacao da tabela de moradas
-- ATENCAO: 
-- 	  Actualizar dados depois de importar tabelas
-- 	  distritos e todos_cp dos CTT
------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [OW].[tblAddress](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[PostalDesignation] [varchar](100) NOT NULL,
	[DistrictCode] [varchar](5) NOT NULL,
	[DistrictDesignation] [varchar](50) NOT NULL,
	[Description] [varchar](500) NULL,
	[Remarks] [varchar](255) NULL,
	[InsertedBy] [varchar](50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_tblAddress] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC 
)
-- Em SQL 2000 a linha seguinte tem que ser comentada
--WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE NONCLUSTERED INDEX [IX_tblAddress] ON [OW].[tblAddress] ([PostalCode], [PostalDesignation])
GO

SET ANSI_PADDING OFF
GO


-- ---------------------------------------------------------------------------------------
--
-- Passos opcionais
--
-- Correr a seguinte instrução apenas se o cliente tiver a base de dados vazia ou se a 
-- tablela de códigos postais do OfficeWorks não tiver dados significativos.
-- ATENCAO : : : PARA O HESE, Não correr !!!
-- --------------------------------------------------------------------------------------- 



INSERT INTO [OW].[tblAddress]
(
	 [PostalCode]
	,[PostalDesignation]
	,[DistrictCode]
	,[DistrictDesignation]	
	,[Description]
	,[InsertedBy]
	,[InsertedOn]
	,[LastModifiedBy]
	,[LastModifiedOn]
)          
SELECT 
	 CP.[Nº do código postal] + '-' + CP.[Extensão do nº do código postal]
	,CP.[Designação Postal]
	,CP.[Código do Distrito]
	,D.[Designação do Distrito]
	,RTRIM(LTRIM(REPLACE(REPLACE(ISNULL(LTRIM(RTRIM(CP.[Artéria - Tipo (Rua, Praça, etc)])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Primeira preposição])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Artéria - Titulo (Doutor, Engº, Professor, etc)])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Segunda preposição])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Artéria - Designação])) + ' ','') + 
	ISNULL(LTRIM(RTRIM(CP.[Artéria - Informação do Local-Zona])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Descrição do troço])) + ' ','') + 
	ISNULL(LTRIM(RTRIM(CP.[Número da porta do cliente])) + ' ','') + 
	ISNULL(LTRIM(RTRIM(CP.[Nome do cliente])),''),'  ',' '),'  ',' ')))
	,'Administrador OfficeWorks'
	,GETDATE()
	,'Administrador OfficeWorks'
	,GETDATE()
FROM [dbo].[todos_cp] CP INNER JOIN 
[dbo].[distritos] D on CP.[Código do Distrito] = D.[Código do Distrito]
ORDER BY CP.[Nº do código postal]+ '-' + CP.[Extensão do nº do código postal]
GO
--(306476 row(s) affected)


UPDATE [OW].[tblAddress] SET [Description] = CP.[Nome da localidade]
FROM [dbo].[todos_cp] CP
WHERE 
	[Description] = '' AND
	RTRIM(LTRIM(REPLACE(REPLACE(ISNULL(LTRIM(RTRIM(CP.[Artéria - Tipo (Rua, Praça, etc)])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Primeira preposição])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Artéria - Titulo (Doutor, Engº, Professor, etc)])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Segunda preposição])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Artéria - Designação])) + ' ','') + 
	ISNULL(LTRIM(RTRIM(CP.[Artéria - Informação do Local-Zona])) + ' ','') +
	ISNULL(LTRIM(RTRIM(CP.[Descrição do troço])) + ' ','') + 
	ISNULL(LTRIM(RTRIM(CP.[Número da porta do cliente])) + ' ','') + 
	ISNULL(LTRIM(RTRIM(CP.[Nome do cliente])),''),'  ',' '),'  ',' '))) = ''
GO
-- (34189 row(s) affected)


------------------------------------------------------------------------
--
-- Procedimentos de moradas
--
------------------------------------------------------------------------

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AddressSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AddressSelect;
GO

CREATE PROCEDURE [OW].AddressSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2012 18:59:34
	--Version: 1.2	
	------------------------------------------------------------------------
	@AddressID int = NULL,
	@PostalCode varchar(10) = NULL,
	@PostalDesignation varchar(100) = NULL,
	@DistrictCode varchar(5) = NULL,
	@DistrictDesignation varchar(50) = NULL,
	@Description varchar(500) = NULL,
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
		[AddressID],
		[PostalCode],
		[PostalDesignation],
		[DistrictCode],
		[DistrictDesignation],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblAddress]
	WHERE
		(@AddressID IS NULL OR [AddressID] = @AddressID) AND
		(@PostalCode IS NULL OR [PostalCode] LIKE @PostalCode) AND
		(@PostalDesignation IS NULL OR [PostalDesignation] LIKE @PostalDesignation) AND
		(@DistrictCode IS NULL OR [DistrictCode] LIKE @DistrictCode) AND
		(@DistrictDesignation IS NULL OR [DistrictDesignation] LIKE @DistrictDesignation) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AddressSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AddressSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AddressSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AddressSelectPaging;
GO

CREATE PROCEDURE [OW].AddressSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2012 18:59:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@AddressID int = NULL,
	@PostalCode varchar(10) = NULL,
	@PostalDesignation varchar(100) = NULL,
	@DistrictCode varchar(5) = NULL,
	@DistrictDesignation varchar(50) = NULL,
	@Description varchar(500) = NULL,
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
	
	IF(@AddressID IS NOT NULL) SET @WHERE = @WHERE + '([AddressID] = @AddressID) AND '
	IF(@PostalCode IS NOT NULL) SET @WHERE = @WHERE + '([PostalCode] LIKE @PostalCode) AND '
	IF(@PostalDesignation IS NOT NULL) SET @WHERE = @WHERE + '([PostalDesignation] LIKE @PostalDesignation) AND '
	IF(@DistrictCode IS NOT NULL) SET @WHERE = @WHERE + '([DistrictCode] LIKE @DistrictCode) AND '
	IF(@DistrictDesignation IS NOT NULL) SET @WHERE = @WHERE + '([DistrictDesignation] LIKE @DistrictDesignation) AND '
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
	SELECT @RowCount = COUNT(AddressID) 
	FROM [OW].[tblAddress]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@AddressID int, 
		@PostalCode varchar(10), 
		@PostalDesignation varchar(100), 
		@DistrictCode varchar(5), 
		@DistrictDesignation varchar(50), 
		@Description varchar(500), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@AddressID, 
		@PostalCode, 
		@PostalDesignation, 
		@DistrictCode, 
		@DistrictDesignation, 		
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
	WHERE AddressID IN (
		SELECT TOP ' + @SizeString + ' AddressID
			FROM [OW].[tblAddress]
			WHERE AddressID NOT IN (
				SELECT TOP ' + @PrevString + ' AddressID 
				FROM [OW].[tblAddress]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[AddressID], 
		[PostalCode], 
		[PostalDesignation], 
		[DistrictCode], 
		[DistrictDesignation], 		
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblAddress]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@AddressID int, 
		@PostalCode varchar(10), 
		@PostalDesignation varchar(100), 
		@DistrictCode varchar(5), 
		@DistrictDesignation varchar(50), 
		@Description varchar(500), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@AddressID, 
		@PostalCode, 
		@PostalDesignation, 
		@DistrictCode,
		@DistrictDesignation,
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AddressSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AddressSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AddressUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AddressUpdate;
GO

CREATE PROCEDURE [OW].AddressUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2012 18:59:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@AddressID int,
	@PostalCode varchar(10),
	@PostalDesignation varchar(100),
	@DistrictCode varchar(5) = NULL,
	@DistrictDesignation varchar(50) = NULL,
	@Description varchar(500) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblAddress]
	SET
		[PostalCode] = @PostalCode,
		[PostalDesignation] = @PostalDesignation,
		[DistrictCode] = @DistrictCode,
		[DistrictDesignation] = @DistrictDesignation,
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[AddressID] = @AddressID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AddressUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AddressUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AddressInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AddressInsert;
GO

CREATE PROCEDURE [OW].AddressInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2012 18:59:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@AddressID int,
	@PostalCode varchar(10),
	@PostalDesignation varchar(100),
	@DistrictCode varchar(5) = NULL,
	@DistrictDesignation varchar(50) = NULL,
	@Description varchar(500) = NULL,
	@Remarks varchar(255) = NULL,
	@InsertedBy varchar(50),
	@InsertedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblAddress]
	(
		[AddressID],
		[PostalCode],
		[PostalDesignation],
		[DistrictCode],
		[DistrictDesignation],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@AddressID,
		@PostalCode,
		@PostalDesignation,
		@DistrictCode,
		@DistrictDesignation,
		@Description,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AddressInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AddressInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AddressDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AddressDelete;
GO

CREATE PROCEDURE [OW].AddressDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-01-2012 18:59:34
	--Version: 1.1	
	------------------------------------------------------------------------
	@AddressID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblAddress]
	WHERE
		[AddressID] = @AddressID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AddressDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AddressDelete Error on Creation'
GO


------------------------------------------------------------------------
---
--- Alteracao de PostalCodeSelectPaging
---
------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [OW].[PostalCodeSelectPaging]
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-02-2012 15:00:00
	--Version: 1.2	
	------------------------------------------------------------------------
	@PostalCodeID int = NULL,
	@Code varchar(10) = NULL,
	@Description varchar(100) = NULL,
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
	
	IF(@PostalCodeID IS NOT NULL) SET @WHERE = @WHERE + '(P.[PostalCodeID] = @PostalCodeID) AND '
	IF(@Code IS NOT NULL) SET @WHERE = @WHERE + '(P.[Code] LIKE @Code) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '(P.[Description] LIKE @Description) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '(P.[Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '(P.[InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '(P.[InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '(P.[LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '(P.[LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(PostalCodeID) 
	FROM [OW].[tblPostalCode] P
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@PostalCodeID int, 
		@Code varchar(10), 
		@Description varchar(100), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@PostalCodeID, 
		@Code, 
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
	WHERE PostalCodeID IN (
		SELECT TOP ' + @SizeString + ' P.PostalCodeID
			FROM [OW].[tblPostalCode] P
			WHERE P.PostalCodeID NOT IN (
				SELECT TOP ' + @PrevString + ' P.PostalCodeID 
				FROM [OW].[tblPostalCode] P
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END

	SET @SELECT = '
		SELECT
		DISTINCT
		P.[PostalCodeID], 
		P.[Code], 
		P.[Description], 
		CASE WHEN (SELECT count(A.AddressID) FROM [OW].[tblAddress] A WHERE P.[Code] = A.PostalCode AND P.[Description] = A.[PostalDesignation]) > 1 THEN '''' ELSE  A.[Description] END As [Address],
		A.[DistrictDesignation], 
		(SELECT count(A.AddressID) FROM [OW].[tblAddress] A WHERE P.[Code] = A.PostalCode AND P.[Description] = A.[PostalDesignation]) AS iCount,
		P.[Remarks], 
		P.[InsertedBy], 
		P.[InsertedOn], 
		P.[LastModifiedBy], 
		P.[LastModifiedOn]
	FROM [OW].[tblPostalCode] P
	LEFT OUTER JOIN [OW].[tblAddress] A ON P.Code = A.[PostalCode] AND P.[Description] = A.[PostalDesignation]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@PostalCodeID int, 
		@Code varchar(10), 
		@Description varchar(100), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@PostalCodeID, 
		@Code, 
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

-- Display the status of Proc Change
IF (@@Error = 0) PRINT 'Procedure Modification: [OW].PostalCodeSelectPaging Succeeded'
ELSE PRINT 'Procedure Modification: [OW].PostalCodeSelectPaging Error on Modification'
GO



ALTER  PROCEDURE [OW].ProcessDocumentSelectEx01
(
	------------------------------------------------------------------------
	-- Devolve a ultima versão de cada documento de um processo
	------------------------------------------------------------------------
	@ProcessID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT 
		PD.ProcessDocumentID,
		PD.ProcessEventID,
		PD.DocumentVersionID,
		PE.ProcessStageID,
		PE.CreationDate,
		PE.OrganizationalUnitID,
		PS.Number as StageNumber
	FROM OW.tblProcessEvent PE 
	LEFT OUTER JOIN OW.tblProcessStage PS ON PS.ProcessStageID = PE.ProcessStageID
	INNER JOIN OW.tblProcessDocument PD ON PD.ProcessEventID = PE.ProcessEventID
	INNER JOIN OW.tblDocument D ON PD.DocumentVersionID = D.LastDocumentVersionID
	WHERE PE.ProcessID = @ProcessID

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc Change
IF (@@Error = 0) PRINT 'Procedure Modification: [OW].ProcessDocumentSelectEx01 Succeeded'
ELSE PRINT 'Procedure Modification: [OW].ProcessDocumentSelectEx01 Error on Modification'
GO




-- ---------------------------------------------------------------------------------
-- -- ALTERAR A VERSAO DA BASE DE DADOS
-- ---------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.8.2' WHERE id=1
GO

--
-- Limpar dados 
--
-- DROP TABLE dbo.Todos_CP
-- DROP TABLE dbo.Distritos

-- ---------------------------------------------------------------------------------
--
-- FIM DO UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.8.1 PARA A VERSÃO 5.8.2
--
-- ---------------------------------------------------------------------------------
