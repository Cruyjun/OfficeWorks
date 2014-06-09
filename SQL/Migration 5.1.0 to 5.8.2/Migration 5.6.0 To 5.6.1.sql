-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.6.0 PARA A VERSÃO 5.6.1
--
-- ---------------------------------------------------------------------------------


PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.6.0 PARA 5.6.1'
PRINT ''
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  970 - Melhorar a performance da pesquisa de documentos
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

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
PRINT N'Creating index [IX_TBLDOCUMENT03] on [OW].[tblDocument]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLDOCUMENT03] ON [OW].[tblDocument] ([Name])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLDOCUMENTVERSION03] on [OW].[tblDocumentVersion]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLDOCUMENTVERSION03] ON [OW].[tblDocumentVersion] ([Pathname])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Defect  970 updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Defect  970 update failed'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  861 - Apagar Localidades e Províncias
-- - Defect  956 - Apagar entidades
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------


-- Limpar dados inconsistentes

-- NOTA: Importante ... O CAST nos updates seguintes pode falhar se os valores não forem inteiros.

-- Localidades (Default: '')
-- SELECT * FROM  [OW].[tblArchInsertVsForm] 
-- WHERE IdField = 7 AND Value <> '' AND NOT EXISTS (SELECT 1 FROM [OW].[tblEntityLocation] WHERE CAST(Value AS INT) = LocationID)	
UPDATE [OW].[tblArchInsertVsForm] SET Value = '' 
WHERE IdField = 7 AND Value <> '' AND NOT EXISTS (SELECT 1 FROM [OW].[tblEntityLocation] WHERE CAST(Value AS INT) = LocationID)	

-- Países (Default: Angola)
-- SELECT * FROM  [OW].[tblArchInsertVsForm] 
-- WHERE IdField = 5 AND NOT EXISTS (SELECT 1 FROM [OW].[tblCountry] WHERE CAST(Value AS INT) = CountryID)	
UPDATE [OW].[tblArchInsertVsForm] SET Value = (SELECT CountryID FROM [OW].[tblCountry] where Description ='Angola') 
WHERE IdField = 5 AND NOT EXISTS (SELECT 1 FROM [OW].[tblCountry] WHERE CAST(Value AS INT) = CountryID)	

-- Distritos (Default: Luanda)
-- SELECT * FROM  [OW].[tblArchInsertVsForm] 
-- WHERE IdField = 9 AND NOT EXISTS (SELECT 1 FROM [OW].[tblDistrict] WHERE CAST(Value AS INT) = DistrictID)	
UPDATE [OW].[tblArchInsertVsForm] SET Value = (SELECT DistrictID FROM [OW].[tblDistrict] where Description ='Luanda') 
WHERE IdField = 9 AND NOT EXISTS (SELECT 1 FROM [OW].[tblDistrict] WHERE CAST(Value AS INT) = DistrictID)	

-- Campos dinamicos do tipo entidade ()
-- A aplicação não mostra entidades que não existam.

-- Mensagens de erro mais detalhadas (Não é grave se desaparecerem do sistema)
EXEC sp_addmessage 50004, 16, N'%ls statement conflicted with %ls %ls %ls - %ls. The conflict occurred in database %ls, table %ls, column %ls. %ls %ls.'
GO


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
PRINT N'Creating [OW].[DistrictDeleteEx01]'
GO
CREATE PROCEDURE [OW].DistrictDeleteEx01
(
	@DistrictID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @FKViolation int

	SELECT @FKViolation = COUNT(*) FROM [OW].[tblArchInsertVsForm] WHERE IDField = 9  AND CAST (Value as int) = @DistrictID
	IF(@FKViolation > 0)
	BEGIN	
	        DECLARE @DatabaseName varchar(30) 
	        SELECT @DatabaseName = db_name()
	        RAISERROR(50004,16,1,N'DELETE', N'COLUMN', N'REFERENCE', N'tblDistrict.DistrictID', N'tblArchInsertVsForm.Value', @DatabaseName, N'tblArchInsertVsForm', N'Value', N'Check spaces with this district', N'')
	        RETURN
	END 	

	DELETE
	FROM [OW].[tblDistrict]
	WHERE
		[DistrictID] = @DistrictID
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
PRINT N'Creating [OW].[CountryDeleteEx01]'
GO
CREATE PROCEDURE [OW].CountryDeleteEx01
(
	@CountryID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @FKViolation int

	SELECT @FKViolation = COUNT(*) FROM [OW].[tblArchInsertVsForm] WHERE IDField = 5  AND CAST (Value as int) = @CountryID
	IF(@FKViolation > 0)
	BEGIN	
	        DECLARE @DatabaseName varchar(30) 
	        SELECT @DatabaseName = db_name()
	        RAISERROR(50004,16,1,N'DELETE', N'COLUMN', N'REFERENCE', N'tblCountry.CountryID', N'tblArchInsertVsForm.Value', @DatabaseName, N'tblArchInsertVsForm', N'Value', N'Check spaces with this country', N'')
	        RETURN
	END 	

	DELETE
	FROM [OW].[tblCountry]
	WHERE
		[CountryID] = @CountryID
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
PRINT N'Creating [OW].[EntitiesDeleteEx01]'
GO
CREATE PROCEDURE [OW].EntitiesDeleteEx01
(
	@EntID numeric(18,0) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @FKViolation int
	 

	SELECT @FKViolation = COUNT(*) FROM [OW].[tblProcessDynamicFieldValue] PDFV
	WHERE CAST (PDFV.NumericFieldValue as int) = @EntID AND
	EXISTS (SELECT 1 FROM [OW].[tblProcessDynamicField] PDF WHERE PDFV.ProcessDynamicFieldID = PDF.ProcessDynamicFieldID AND PDF.Required = 1) 

	BEGIN
	IF(@FKViolation > 0)
		BEGIN	
		        DECLARE @DatabaseName varchar(30) 
		        SELECT @DatabaseName = db_name()
	
			DECLARE @ProcessID varchar(30)
			SELECT TOP 1 @ProcessID = ProcessID FROM [OW].[tblProcessDynamicField] PDF
			INNER JOIN [OW].[tblProcessDynamicFieldValue] PDFV
			ON PDF.ProcessDynamicFieldID = PDFV.ProcessDynamicFieldID
			WHERE CAST (PDFV.NumericFieldValue as int) = @EntID
	
		        RAISERROR(50004,16,1,N'DELETE', N'COLUMN', N'REFERENCE', N'tblEntities.EntityID', N'tblProcessDynamicFieldValue.NumericFieldValue', @DatabaseName, N'tblProcessDynamicFieldValue', N'NumericFieldValue', N'Check process with ProcessID = ', @ProcessID)
		        RETURN
		END
	ELSE

		 UPDATE [OW].[tblProcessDynamicFieldValue] SET NumericFieldValue = 0 
		 WHERE ProcessDynamicFieldValueID IN 
		 (
			 SELECT ProcessDynamicFieldValueID  FROM [OW].[tblProcessDynamicFieldValue] PDFV
			 INNER JOIN [OW].[tblProcessDynamicField] PDF ON PDFV.ProcessDynamicFieldID = PDF.ProcessDynamicFieldID 
			 INNER JOIN [OW].[tblDynamicField] DF  ON PDF.DynamicFieldID = DF.DynamicFieldID
			 WHERE DF.DynamicFieldTypeID = 64 AND PDF.Required = 0 AND CAST (PDFV.NumericFieldValue as int) = @EntID
		)
	END

	DELETE
	FROM [OW].[tblEntities]
	WHERE
		[EntID] = @EntID
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
PRINT N'Altering [OW].[usp_DeleteEntityLocation]'
GO






ALTER PROCEDURE OW.usp_DeleteEntityLocation
( @LocationID numeric(18,0))
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	UPDATE [OW].[tblArchInsertVsForm] SET Value = '' WHERE IdField = 7 AND CAST(Value AS INT) = @LocationID

	DELETE
	FROM [OW].[tblEntityLocation]
	WHERE [LocationID] = @LocationID
	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblRegistry]'
GO
ALTER TABLE [OW].[tblRegistry] WITH NOCHECK ADD
CONSTRAINT [FK_tblRegistry_tblEntities1] FOREIGN KEY ([entID]) REFERENCES [OW].[tblEntities] ([EntID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblRegistryHist]'
GO
ALTER TABLE [OW].[tblRegistryHist] WITH NOCHECK ADD
CONSTRAINT [FK_tblRegistryHist_tblEntities1] FOREIGN KEY ([entID]) REFERENCES [OW].[tblEntities] ([EntID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Defect  861, 956 updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Defect  861, 956 update failed'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  914 - Apagar distribuição por correio electronico não apaga linhas na base de dados
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO
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
PRINT N'Dropping foreign keys from [OW].[tblElectronicMailDestinations]'
GO
ALTER TABLE [OW].[tblElectronicMailDestinations] DROP
CONSTRAINT [FK_tblElectronicMailDestinations_tblElectronicMail]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[RegistryDistributionDelete]'
GO

ALTER PROCEDURE [OW].RegistryDistributionDelete
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

	SET XACT_ABORT ON

	BEGIN TRANSACTION

	DELETE 
	FROM [OW].[tblElectronicMail] 
	WHERE EXISTS
		(SELECT 1 FROM [OW].[tblRegistryDistribution] RD
		 WHERE RD.[ID] = @ID
		 AND RD.[ConnectID] = [OW].[tblElectronicMail].[MailID]
		 AND RD.[Tipo] = 1
		)

	DELETE
	FROM [OW].[tblRegistryDistribution]
	WHERE
		[ID] = @ID
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 

	COMMIT TRANSACTION
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblElectronicMailDestinations]'
GO
ALTER TABLE [OW].[tblElectronicMailDestinations] WITH NOCHECK ADD
CONSTRAINT [FK_tblElectronicMailDestinations_tblElectronicMail] FOREIGN KEY ([MailID]) REFERENCES [OW].[tblElectronicMail] ([MailID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Defect  914 updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Defect  914 update failed'
GO
DROP TABLE #tmpErrors
GO



-- Limpar dados desnecessários

DELETE 
FROM [OW].[tblElectronicMail] 
WHERE NOT EXISTS
	(SELECT 1 FROM [OW].[tblRegistryDistribution] RD 
	 WHERE RD.[ConnectID] = [OW].[tblElectronicMail].[MailID]
	)
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  991 - Erro ao tentar apagar um ou mais registos
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

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
PRINT N'Dropping foreign keys from [OW].[tblRegistryDocuments]'
GO
ALTER TABLE [OW].[tblRegistryDocuments] DROP
CONSTRAINT [FK_tblRegistryDocuments_tblDocument]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblRegistryDocuments]'
GO
ALTER TABLE [OW].[tblRegistryDocuments] WITH NOCHECK ADD
CONSTRAINT [FK_tblRegistryDocuments_tblDocument] FOREIGN KEY ([DocumentID]) REFERENCES [OW].[tblDocument] ([DocumentID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Defect  991 updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Defect  991 update failed'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  562 - Acessos aos Processos
-- - Defect  824 - Carregar página acessos
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO


/*
Script created by SQL Compare from Red Gate Software Ltd at 05-06-2008 16:34:06
Run this script on cygnus.HESE to make [OW].[tblProcessStageAccess] the same as on (local).HESE
Please back up your database before running this script
*/
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
PRINT N'Dropping constraints from [OW].[tblProcessStageAccess]'
GO
ALTER TABLE [OW].[tblProcessStageAccess] DROP CONSTRAINT [PK_TBLPROCESSSTAGEACCESS]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_tblProcessStageAccess01] on [OW].[tblProcessStageAccess]'
GO
CREATE UNIQUE CLUSTERED INDEX [IX_tblProcessStageAccess01] ON [OW].[tblProcessStageAccess] ([FlowStageID], [ProcessStageID], [OrganizationalUnitID], [AccessObject])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_TBLPROCESSSTAGEACCESS] on [OW].[tblProcessStageAccess]'
GO
ALTER TABLE [OW].[tblProcessStageAccess] ADD CONSTRAINT [PK_TBLPROCESSSTAGEACCESS] PRIMARY KEY NONCLUSTERED  ([ProcessStageAccessID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating constraint [CK_tblProcessStageAccess07] on [OW].[tblProcessStageAccess]'
GO
ALTER TABLE [OW].[tblProcessStageAccess] WITH NOCHECK ADD CONSTRAINT [CK_tblProcessStageAccess07] CHECK (([DocumentAccess] <> 1 or [DispatchAccess] <> 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating constraint [CK_tblProcessAccess11] on [OW].[tblProcessAccess]'
GO
ALTER TABLE [OW].[tblProcessAccess] WITH NOCHECK ADD CONSTRAINT [CK_tblProcessAccess11] CHECK (([StartProcess] <> 1 or [ProcessDataAccess] <> 1 or [DynamicFieldAccess] <> 1 or [DocumentAccess] <> 1 or [DocumentEditAccess] <> 1 or [DispatchAccess] <> 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Defect  562, 824 updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Defect  562, 824 update failed'
GO
DROP TABLE #tmpErrors
GO

/*
Script created by SQL Compare from Red Gate Software Ltd at 05-06-2008 16:56:15
Run this script on cygnus.HESE to make it the same as (local).HESE
Please back up your database before running this script
*/
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

PRINT N'Altering [OW].[ProcessAccessSelectEx01]'
GO

ALTER PROCEDURE [OW].ProcessAccessSelectEx01
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Updated: 09-01-2006 18:20:23
	--Version: 1.0
	--Foi feita uma alteracao nesse procedimento para ele passar a usar o indice
	--IX_TBLPROCESSACCESS01	
	------------------------------------------------------------------------------------------------------------------------------------------------
	@ProcessAccessID int = NULL,
	@FlowID int = NULL,
	@ProcessID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	IF @ProcessID IS NOT NULL
	
	SELECT   
		pa.ProcessAccessID, 
		pa.FlowID, 
		pa.ProcessID, 
		NULL AS 'OrganizationalUnitID', 
		vaot.[ID],
		vaot.Hierarchy,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		vaot.[Description] AS 'OrganizationDescription', 
		vaot.AccessObject,
		ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
		ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
		ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
		ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
		ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess',
		pa.Remarks, 
		pa.InsertedBy, 
		pa.InsertedOn, 
		pa.LastModifiedBy, 
		pa.LastModifiedOn 
	FROM         
		OW.vAccessObjectType vaot 
	LEFT OUTER JOIN
		(SELECT *
		FROM          
			OW.tblProcessAccess pa
		WHERE   
			(@ProcessAccessID IS NULL OR pa.ProcessAccessID = @ProcessAccessID) AND
			(pa.ProcessID = @ProcessID) AND
			(pa.FlowID IS NULL)) pa 
	ON vaot.AccessObject = pa.AccessObject
	WHERE     (vaot.AccessObject <> 1)
	
	UNION
	
	SELECT 
		pa.ProcessAccessID, 
		pa.FlowID, 
		pa.ProcessID, 
		v1.OrganizationalUnitID, 
		v1.[ID],
		v1.Hierarchy,
		v1.Type, 
		v1.ImageName,
		v1.[Description] AS 'OrganizationDescription', 
		ISNULL(pa.AccessObject, 1) AS 'AccessObject',
		ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
		ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
		ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
		ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
		ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess', 
		pa.Remarks, 
		pa.InsertedBy, 
		pa.InsertedOn, 
		pa.LastModifiedBy, 
		pa.LastModifiedOn 
	FROM
	(SELECT 
		ou.OrganizationalUnitID, 
		1 AS 'Type',
		'User.gif' AS 'ImageName',
		u.UserID AS ID, 
		u.PrimaryGroupID AS 'Hierarchy',		
		u.UserDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON ou.UserID=u.UserID
	
	UNION
	
	SELECT 
		ou.OrganizationalUnitID,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		g.GroupID AS ID, 
	 	g.HierarchyID AS 'Hierarchy',
		g.GroupDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID) v1
	
	LEFT OUTER JOIN
		(SELECT *
		FROM 
			OW.tblProcessAccess pa
		WHERE
			(@ProcessAccessID IS NULL OR pa.ProcessAccessID = @ProcessAccessID) AND
			(pa.ProcessID = @ProcessID) AND
			(pa.FlowID IS NULL)) pa
	ON v1.OrganizationalUnitID = pa.OrganizationalUnitID

ELSE
	
	SELECT   
		pa.ProcessAccessID, 
		pa.FlowID, 
		pa.ProcessID, 
		NULL AS 'OrganizationalUnitID', 
		vaot.[ID],
		vaot.Hierarchy,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		vaot.[Description] AS 'OrganizationDescription', 
		vaot.AccessObject,
		ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
		ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
		ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
		ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
		ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess',
		pa.Remarks, 
		pa.InsertedBy, 
		pa.InsertedOn, 
		pa.LastModifiedBy, 
		pa.LastModifiedOn 
	FROM         
		OW.vAccessObjectType vaot 
	LEFT OUTER JOIN
		(SELECT *
		FROM          
			OW.tblProcessAccess pa
		WHERE   
			(@ProcessAccessID IS NULL OR pa.ProcessAccessID = @ProcessAccessID) AND
			(pa.ProcessID IS NULL) AND
			(pa.FlowID = @FlowID)) pa 
	ON vaot.AccessObject = pa.AccessObject
	WHERE     (vaot.AccessObject <> 1)
	
	UNION
	
	SELECT 
		pa.ProcessAccessID, 
		pa.FlowID, 
		pa.ProcessID, 
		v1.OrganizationalUnitID, 
		v1.[ID],
		v1.Hierarchy,
		v1.Type, 
		v1.ImageName,
		v1.[Description] AS 'OrganizationDescription', 
		ISNULL(pa.AccessObject, 1) AS 'AccessObject',
		ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
		ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
		ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
		ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
		ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess', 
		pa.Remarks, 
		pa.InsertedBy, 
		pa.InsertedOn, 
		pa.LastModifiedBy, 
		pa.LastModifiedOn 
	FROM
	(SELECT 
		ou.OrganizationalUnitID, 
		1 AS 'Type',
		'User.gif' AS 'ImageName',
		u.UserID AS ID, 
		u.PrimaryGroupID AS 'Hierarchy',		
		u.UserDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON ou.UserID=u.UserID
	
	UNION
	
	SELECT 
		ou.OrganizationalUnitID,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		g.GroupID AS ID, 
	 	g.HierarchyID AS 'Hierarchy',
		g.GroupDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID) v1
	
	LEFT OUTER JOIN
		(SELECT *
		FROM 
			OW.tblProcessAccess pa
		WHERE
			(@ProcessAccessID IS NULL OR pa.ProcessAccessID = @ProcessAccessID) AND
			(pa.ProcessID IS NULL) AND
			(pa.FlowID  = @FlowID)) pa
	ON v1.OrganizationalUnitID = pa.OrganizationalUnitID
		SET @Err = @@Error
		RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx01 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessStageAccessSelectEx01]'
GO
ALTER PROCEDURE [OW].ProcessStageAccessSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 11-04-2008 19:00:00
	--Version: 1.1
	--Foi feita uma alteracao nesse procedimento para ele passar a usar o  
	--indice IX_tblProcessStageAccess01	
	------------------------------------------------------------------------
	@ProcessStageAccessID int = NULL,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	IF @ProcessStageID IS NOT NULL
	
	SELECT   
		psa.ProcessStageAccessID, 
		psa.FlowStageID, 
		psa.ProcessStageID, 
		NULL AS 'OrganizationalUnitID', 
		vaot.[ID],
		vaot.Hierarchy,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		vaot.[Description] AS 'OrganizationDescription', 
		vaot.AccessObject,
		ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess',
		psa.Remarks, 
		psa.InsertedBy, 
		psa.InsertedOn, 
		psa.LastModifiedBy, 
		psa.LastModifiedOn 
	FROM         
		OW.vAccessObjectType vaot 
	LEFT OUTER JOIN
		(SELECT *
		FROM          
			OW.tblProcessStageAccess psa
		WHERE   
			(@ProcessStageAccessID IS NULL OR psa.ProcessStageAccessID = @ProcessStageAccessID) AND
			(psa.ProcessStageID = @ProcessStageID) AND
			(psa.FlowStageID IS NULL)) psa 
	ON vaot.AccessObject = psa.AccessObject
	WHERE     (vaot.AccessObject <> 1)
	
	UNION
	
	SELECT 
		psa.ProcessStageAccessID, 
		psa.FlowStageID, 
		psa.ProcessStageID, 
		v1.OrganizationalUnitID, 
		v1.[ID],
		v1.Hierarchy,
		v1.Type, 
		v1.ImageName,
		v1.[Description] AS 'OrganizationDescription', 
		ISNULL(psa.AccessObject, 1) AS 'AccessObject',
		ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess', 
		psa.Remarks, 
		psa.InsertedBy, 
		psa.InsertedOn, 
		psa.LastModifiedBy, 
		psa.LastModifiedOn 
	FROM
	(SELECT 
		ou.OrganizationalUnitID, 
		1 AS 'Type',
		'User.gif' AS 'ImageName',
		u.UserID AS ID, 
		u.PrimaryGroupID AS 'Hierarchy',		
		u.UserDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON ou.UserID=u.UserID
	
	UNION
	
	SELECT 
		ou.OrganizationalUnitID,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		g.GroupID AS ID, 
	 	g.HierarchyID AS 'Hierarchy',
		g.GroupDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID) v1
	
	LEFT OUTER JOIN
		(SELECT *
		FROM 
			OW.tblProcessStageAccess psa
		WHERE
			(@ProcessStageAccessID IS NULL OR psa.ProcessStageAccessID = @ProcessStageAccessID) AND
			(psa.ProcessStageID = @ProcessStageID) AND
			(psa.FlowStageID IS NULL)) psa 
	ON v1.OrganizationalUnitID = psa.OrganizationalUnitID

	ELSE

	SELECT   
		psa.ProcessStageAccessID, 
		psa.FlowStageID, 
		psa.ProcessStageID, 
		NULL AS 'OrganizationalUnitID', 
		vaot.[ID],
		vaot.Hierarchy,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		vaot.[Description] AS 'OrganizationDescription', 
		vaot.AccessObject,
		ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess',
		psa.Remarks, 
		psa.InsertedBy, 
		psa.InsertedOn, 
		psa.LastModifiedBy, 
		psa.LastModifiedOn 
	FROM         
		OW.vAccessObjectType vaot 
	LEFT OUTER JOIN
		(SELECT *
		FROM          
			OW.tblProcessStageAccess psa
		WHERE   
			(@ProcessStageAccessID IS NULL OR psa.ProcessStageAccessID = @ProcessStageAccessID) AND
			(psa.ProcessStageID IS NULL) AND
			(psa.FlowStageID =  @FlowStageID)) psa 
	ON vaot.AccessObject = psa.AccessObject
	WHERE     (vaot.AccessObject <> 1)
	
	UNION
	
	SELECT 
		psa.ProcessStageAccessID, 
		psa.FlowStageID, 
		psa.ProcessStageID, 
		v1.OrganizationalUnitID, 
		v1.[ID],
		v1.Hierarchy,
		v1.Type, 
		v1.ImageName,
		v1.[Description] AS 'OrganizationDescription', 
		ISNULL(psa.AccessObject, 1) AS 'AccessObject',
		ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
		ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess', 
		psa.Remarks, 
		psa.InsertedBy, 
		psa.InsertedOn, 
		psa.LastModifiedBy, 
		psa.LastModifiedOn 
	FROM
	(SELECT 
		ou.OrganizationalUnitID, 
		1 AS 'Type',
		'User.gif' AS 'ImageName',
		u.UserID AS ID, 
		u.PrimaryGroupID AS 'Hierarchy',		
		u.UserDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON ou.UserID=u.UserID
	
	UNION
	
	SELECT 
		ou.OrganizationalUnitID,
		2 AS 'Type', 
		'Group.gif' AS 'ImageName',
		g.GroupID AS ID, 
	 	g.HierarchyID AS 'Hierarchy',
		g.GroupDesc AS 'Description'
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID) v1
	
	LEFT OUTER JOIN
		(SELECT *
		FROM 
			OW.tblProcessStageAccess psa
		WHERE
			(@ProcessStageAccessID IS NULL OR psa.ProcessStageAccessID = @ProcessStageAccessID) AND
			(psa.ProcessStageID IS NULL) AND
			(psa.FlowStageID =  @FlowStageID)) psa 
	ON v1.OrganizationalUnitID = psa.OrganizationalUnitID
	
	
	
		SET @Err = @@Error
		RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectEx01 Error on Creation'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Creating [OW].[ProcessStageAccessSelectEx02]'
GO
CREATE PROCEDURE [OW].ProcessStageAccessSelectEx02
(
	------------------------------------------------------------------------
	--Created: 13-04-2008 19:00:00
	--Version: 1.0	
	--Description:	Devolve todos acessos hierarquicos de um utilizador ou  
	--		grupo a uma etapa de um fluxo ou de um processo.
	------------------------------------------------------------------------
	@UserID int = NULL,
	@GroupID int = NULL,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @PrimaryGroupID int	
	DECLARE @HierarchyID int
	DECLARE @HierarchyIDs varchar(8000)

	SET @PrimaryGroupID = NULL
	SET @HierarchyID = NULL
	SET @HierarchyIDs = ''

	
	IF @UserID IS NOT NULL
	BEGIN
		-- ----------------------------------------------------------------------------------------------------
		-- Dados do grupo hierarquico de um utilizador
		-- ----------------------------------------------------------------------------------------------------
		SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	END
	
	IF @GroupID  IS NOT NULL
	BEGIN
		-- ----------------------------------------------------------------------------------------------------
		-- Dados de um grupo
		-- ----------------------------------------------------------------------------------------------------
		SET @PrimaryGroupID = @GroupID 
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Dados dos grupos hierarquicos do utilizador ou do proprio grupo
	-- ----------------------------------------------------------------------------------------------------
	SET @HierarchyIDs = @HierarchyIDs + CAST(@PrimaryGroupID AS varchar) + ','

	-- ----------------------------------------------------------------------------------------------------
	-- Dados dos grupos hierarquicos de um utilizador ou de um grupo
	-- ----------------------------------------------------------------------------------------------------
	IF @PrimaryGroupID IS NOT NULL
	BEGIN	

		IF @PrimaryGroupID < 0 
			SELECT @HierarchyID = Hierarchy FROM OW.vAccessObjectType WHERE ID = @PrimaryGroupID
		ELSE
			SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @PrimaryGroupID
		 	
		WHILE @HierarchyID IS NOT NULL
		BEGIN

			SET @HierarchyIDs = @HierarchyIDs + CAST(@HierarchyID AS varchar) + ','

			IF @PrimaryGroupID < 0 
				SELECT @HierarchyID = Hierarchy FROM OW.vAccessObjectType WHERE ID = @HierarchyID
			ELSE
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID

		END 	
	END

	IF @ProcessStageID IS NOT NULL

		-- ----------------------------------------------------------------------------------------------------
		-- Obter os acessos do processo
		-- ----------------------------------------------------------------------------------------------------
		SELECT   
			psa.ProcessStageAccessID, 
			psa.FlowStageID, 
			psa.ProcessStageID, 
			vaot.[ID] AS 'OrganizationalUnitID', 
			vaot.[ID],
			vaot.Hierarchy,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			vaot.[Description] AS 'OrganizationDescription', 
			vaot.AccessObject,
			ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess',
			psa.Remarks, 
			psa.InsertedBy, 
			psa.InsertedOn, 
			psa.LastModifiedBy, 
			psa.LastModifiedOn 
		FROM         
			OW.vAccessObjectType vaot 
		LEFT OUTER JOIN
			(SELECT *
			FROM          
				OW.tblProcessStageAccess psa
			WHERE   
				(psa.ProcessStageID = @ProcessStageID) AND
				(psa.FlowStageID IS NULL)) psa 
		ON vaot.AccessObject = psa.AccessObject
		WHERE     (vaot.AccessObject <> 1 AND vaot.ID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) )
		
		UNION
		
		SELECT 
			psa.ProcessStageAccessID, 
			psa.FlowStageID, 
			psa.ProcessStageID, 
			v1.OrganizationalUnitID, 
			v1.[ID],
			v1.Hierarchy,
			v1.Type, 
			v1.ImageName,
			v1.[Description] AS 'OrganizationDescription', 
			ISNULL(psa.AccessObject, 1) AS 'AccessObject',
			ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess', 
			psa.Remarks, 
			psa.InsertedBy, 
			psa.InsertedOn, 
			psa.LastModifiedBy, 
			psa.LastModifiedOn 
		FROM
		(SELECT 
			ou.OrganizationalUnitID, 
			1 AS 'Type',
			'User.gif' AS 'ImageName',
			u.UserID AS ID, 
			u.PrimaryGroupID AS 'Hierarchy',		
			u.UserDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON (ou.UserID=u.UserID AND u.UserID = @UserID)
		
		UNION
		
		SELECT 
			ou.OrganizationalUnitID,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			g.GroupID AS ID, 
		 	g.HierarchyID AS 'Hierarchy',
			g.GroupDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblGroups g
			ON (ou.GroupID=g.GroupID AND g.GroupID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) ) ) v1
		LEFT OUTER JOIN
			(SELECT *
			FROM 
				OW.tblProcessStageAccess psa
			WHERE
				(psa.ProcessStageID = @ProcessStageID) AND
				(psa.FlowStageID IS NULL)) psa 
			ON v1.OrganizationalUnitID = psa.OrganizationalUnitID
	
	ELSE

	-- ----------------------------------------------------------------------------------------------------
	-- Obter os acessos da etapa do fluxo
	-- ----------------------------------------------------------------------------------------------------

		SELECT   
			psa.ProcessStageAccessID, 
			psa.FlowStageID, 
			psa.ProcessStageID, 
			vaot.[ID] AS 'OrganizationalUnitID', 
			vaot.[ID],
			vaot.Hierarchy,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			vaot.[Description] AS 'OrganizationDescription', 
			vaot.AccessObject,
			ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess',
			psa.Remarks, 
			psa.InsertedBy, 
			psa.InsertedOn, 
			psa.LastModifiedBy, 
			psa.LastModifiedOn 
		FROM         
			OW.vAccessObjectType vaot 
		LEFT OUTER JOIN
			(SELECT *
			FROM          
				OW.tblProcessStageAccess psa
			WHERE   
				(psa.ProcessStageID IS NULL) AND
				(psa.FlowStageID =  @FlowStageID)) psa 
		ON vaot.AccessObject = psa.AccessObject
		WHERE     (vaot.AccessObject <> 1 AND vaot.ID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) )
		
		UNION
		
		SELECT 
			psa.ProcessStageAccessID, 
			psa.FlowStageID, 
			psa.ProcessStageID, 
			v1.OrganizationalUnitID, 
			v1.[ID],
			v1.Hierarchy,
			v1.Type, 
			v1.ImageName,
			v1.[Description] AS 'OrganizationDescription', 
			ISNULL(psa.AccessObject, 1) AS 'AccessObject',
			ISNULL(psa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(psa.DispatchAccess, 1) AS 'DispatchAccess', 
			psa.Remarks, 
			psa.InsertedBy, 
			psa.InsertedOn, 
			psa.LastModifiedBy, 
			psa.LastModifiedOn 
		FROM
		(SELECT 
			ou.OrganizationalUnitID, 
			1 AS 'Type',
			'User.gif' AS 'ImageName',
			u.UserID AS ID, 
			u.PrimaryGroupID AS 'Hierarchy',		
			u.UserDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON (ou.UserID=u.UserID AND u.UserID = @UserID)
		
		UNION
		
		SELECT 
			ou.OrganizationalUnitID,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			g.GroupID AS ID, 
		 	g.HierarchyID AS 'Hierarchy',
			g.GroupDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblGroups g
			ON (ou.GroupID=g.GroupID AND g.GroupID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) ) ) v1
		
		LEFT OUTER JOIN
			(SELECT *
			FROM 
				OW.tblProcessStageAccess psa
			WHERE
				(psa.ProcessStageID IS NULL) AND
				(psa.FlowStageID =  @FlowStageID)) psa 
		ON v1.OrganizationalUnitID = psa.OrganizationalUnitID
	
	
	
		SET @Err = @@Error
		RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectEx02 Error on Creation'

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ProcessAccessSelectEx04]'
GO
CREATE PROCEDURE [OW].ProcessAccessSelectEx04
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Created On :	11-04-2008 14:19:00
	--Version : 	1.0
	--Description:	Devolve todos acessos hierarquicos de um utilizador ou grupo a um fluxo 
	--		ou processo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	@UserID int = NULL,
	@GroupID int = NULL,
	@FlowID int = NULL,
	@ProcessID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	DECLARE @PrimaryGroupID int	
	DECLARE @HierarchyID int
	DECLARE @HierarchyIDs varchar(8000)

	SET @PrimaryGroupID = NULL
	SET @HierarchyID = NULL
	SET @HierarchyIDs = ''

	
	IF @UserID IS NOT NULL
	BEGIN
		-- ----------------------------------------------------------------------------------------------------
		-- Dados do grupo hierarquico de um utilizador
		-- ----------------------------------------------------------------------------------------------------
		SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	END
	
	IF @GroupID  IS NOT NULL
	BEGIN
		-- ----------------------------------------------------------------------------------------------------
		-- Dados de um grupo
		-- ----------------------------------------------------------------------------------------------------
		SET @PrimaryGroupID = @GroupID 
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Dados dos grupos hierarquicos do utilizador ou do proprio grupo
	-- ----------------------------------------------------------------------------------------------------
	SET @HierarchyIDs = @HierarchyIDs + CAST(@PrimaryGroupID AS varchar) + ','

	-- ----------------------------------------------------------------------------------------------------
	-- Dados dos grupos hierarquicos de um utilizador ou de um grupo
	-- ----------------------------------------------------------------------------------------------------
	IF @PrimaryGroupID IS NOT NULL
	BEGIN	

		IF @PrimaryGroupID < 0 
			SELECT @HierarchyID = Hierarchy FROM OW.vAccessObjectType WHERE ID = @PrimaryGroupID
		ELSE
			SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @PrimaryGroupID
		 	
		WHILE @HierarchyID IS NOT NULL
		BEGIN

			SET @HierarchyIDs = @HierarchyIDs + CAST(@HierarchyID AS varchar) + ','

			IF @PrimaryGroupID < 0 
				SELECT @HierarchyID = Hierarchy FROM OW.vAccessObjectType WHERE ID = @HierarchyID
			ELSE
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID

		END 	
	END

	IF @ProcessID IS NOT NULL

		-- ----------------------------------------------------------------------------------------------------
		-- Obter os acessos do processo
		-- ----------------------------------------------------------------------------------------------------
		SELECT   
			pa.ProcessAccessID, 
			pa.FlowID, 
			pa.ProcessID, 
			vaot.[ID] AS 'OrganizationalUnitID', 
			vaot.[ID],
			vaot.Hierarchy,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			vaot.[Description] AS 'OrganizationDescription', 
			vaot.AccessObject,
			ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
			ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
			ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
			ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
			ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess',
			pa.Remarks, 
			pa.InsertedBy, 
			pa.InsertedOn, 
			pa.LastModifiedBy, 
			pa.LastModifiedOn 
		FROM         
			OW.vAccessObjectType vaot 
		LEFT OUTER JOIN
			(SELECT *
			FROM          
				OW.tblProcessAccess pa
			WHERE   
				(pa.ProcessID = @ProcessID) AND
				(pa.FlowID IS NULL)) pa 
		ON vaot.AccessObject = pa.AccessObject
		WHERE     (vaot.AccessObject <> 1 AND vaot.ID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) )

		UNION

		SELECT 
			pa.ProcessAccessID, 
			pa.FlowID, 
			pa.ProcessID, 
			v1.OrganizationalUnitID, 
			v1.[ID],
			v1.Hierarchy,
			v1.Type, 
			v1.ImageName,
			v1.[Description] AS 'OrganizationDescription', 
			ISNULL(pa.AccessObject, 1) AS 'AccessObject',
			ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
			ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
			ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
			ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
			ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess', 
			pa.Remarks, 
			pa.InsertedBy, 
			pa.InsertedOn, 
			pa.LastModifiedBy, 
			pa.LastModifiedOn 
		FROM
		(SELECT 
			ou.OrganizationalUnitID, 
			1 AS 'Type',
			'User.gif' AS 'ImageName',
			u.UserID AS ID, 
			u.PrimaryGroupID AS 'Hierarchy',		
			u.UserDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON (ou.UserID=u.UserID AND u.UserID = @UserID)
	
		UNION
		
		SELECT 
			ou.OrganizationalUnitID,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			g.GroupID AS ID, 
		 	g.HierarchyID AS 'Hierarchy',
			g.GroupDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblGroups g
			ON (ou.GroupID=g.GroupID AND g.GroupID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) ) ) v1
		LEFT OUTER JOIN
			(SELECT *
			FROM 
				OW.tblProcessAccess pa
			WHERE
				(pa.ProcessID = @ProcessID) AND
				(pa.FlowID IS NULL)) pa
			ON v1.OrganizationalUnitID = pa.OrganizationalUnitID

	ELSE

	-- ----------------------------------------------------------------------------------------------------
	-- Obter os acessos do fluxo
	-- ----------------------------------------------------------------------------------------------------

		SELECT   
			pa.ProcessAccessID, 
			pa.FlowID, 
			pa.ProcessID, 
			vaot.[ID] AS 'OrganizationalUnitID', 
			vaot.[ID],
			vaot.Hierarchy,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			vaot.[Description] AS 'OrganizationDescription', 
			vaot.AccessObject,
			ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
			ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
			ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
			ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
			ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess',
			pa.Remarks, 
			pa.InsertedBy, 
			pa.InsertedOn, 
			pa.LastModifiedBy, 
			pa.LastModifiedOn 
		FROM         
			OW.vAccessObjectType vaot 
		LEFT OUTER JOIN
			(SELECT *
			FROM          
				OW.tblProcessAccess pa
			WHERE   
				(pa.ProcessID IS NULL) AND
				(pa.FlowID = @FlowID)) pa 
		ON vaot.AccessObject = pa.AccessObject
		WHERE     (vaot.AccessObject <> 1 AND vaot.ID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) )
	
		UNION

		SELECT 
			pa.ProcessAccessID, 
			pa.FlowID, 
			pa.ProcessID, 
			v1.OrganizationalUnitID, 
			v1.[ID],
			v1.Hierarchy,
			v1.Type, 
			v1.ImageName,
			v1.[Description] AS 'OrganizationDescription', 
			ISNULL(pa.AccessObject, 1) AS 'AccessObject',
			ISNULL(pa.StartProcess, 1) AS 'StartProcess', 
			ISNULL(pa.ProcessDataAccess, 1) AS 'ProcessDataAccess', 
			ISNULL(pa.DynamicFieldAccess, 1) AS 'DynamicFieldAccess', 
			ISNULL(pa.DocumentAccess, 1) AS 'DocumentAccess',
			ISNULL(pa.DocumentEditAccess, 1) AS 'DocumentEditAccess',
			ISNULL(pa.DispatchAccess, 1) AS 'DispatchAccess', 
			pa.Remarks, 
			pa.InsertedBy, 
			pa.InsertedOn, 
			pa.LastModifiedBy, 
			pa.LastModifiedOn 
		FROM
		(SELECT 
			ou.OrganizationalUnitID, 
			1 AS 'Type',
			'User.gif' AS 'ImageName',
			u.UserID AS ID, 
			u.PrimaryGroupID AS 'Hierarchy',		
			u.UserDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON (ou.UserID=u.UserID AND u.UserID = @UserID)
	
		UNION
		
		SELECT 
			ou.OrganizationalUnitID,
			2 AS 'Type', 
			'Group.gif' AS 'ImageName',
			g.GroupID AS ID, 
		 	g.HierarchyID AS 'Hierarchy',
			g.GroupDesc AS 'Description'
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblGroups g
			ON (ou.GroupID=g.GroupID AND g.GroupID IN (SELECT stt.Item FROM OW.StringToTable(@HierarchyIDs, ',') stt ) ) ) v1
		LEFT OUTER JOIN
			(SELECT *
			FROM 
				OW.tblProcessAccess pa
			WHERE
				(pa.ProcessID IS NULL) AND
				(pa.FlowID = @FlowID)) pa
				ON v1.OrganizationalUnitID = pa.OrganizationalUnitID
	
		SET @Err = @@Error
		RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx04 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx04 Error on Creation'

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[OrganizationalUnitSelectEx04]'
GO
CREATE PROCEDURE [OW].OrganizationalUnitSelectEx04
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Created On :	11-04-2008 14:19:00
	--Version : 	1.0
	--Description:	Devolve unidades organizacionais que tenham algum tipo de acesso a um 
	--		fluxo ou a um processo ou a etapas de fluxos ou processos
	-- 		@Type: 0 - All 1 - Users 2 - Groups
	------------------------------------------------------------------------------------------------------------------------------------------------
	@Type int, 
	@FlowID int = NULL,
	@ProcessID int = NULL,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql nvarchar(4000)

	SET @sql = ''

	IF (@Type IS NULL OR @Type NOT IN (0, 1, 2)) SET @Type = 0

	IF (@Type = 0 OR @Type = 2)
	BEGIN
	SET @sql = @sql + '
	SELECT   
		NULL AS OrganizationalUnitID, 
		2 AS Type, 
		vaot.[ID],
		vaot.Hierarchy,
		vaot.[Description] AS Description,
		0 as Ordem
	FROM         
		OW.vAccessObjectType vaot 

	WHERE EXISTS
		(SELECT 1
		 FROM'
			
			IF @ProcessID IS NOT NULL OR @FlowID IS NOT NULL
			BEGIN
				SET @sql = @sql + ' OW.tblProcessAccess pa  WHERE vaot.AccessObject = pa.AccessObject'

				IF @ProcessID IS NOT NULL
					SET @sql = @sql + ' AND (pa.ProcessID = @ProcessID) AND (pa.FlowID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND(pa.ProcessID IS NULL) AND (pa.FlowID = @FlowID)'

				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (StartProcess <> 1 OR ProcessDataAccess <> 1 OR DynamicFieldAccess <> 1 OR DocumentAccess <> 1 OR DocumentEditAccess <> 1 OR DispatchAccess <> 1)'
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' OW.tblProcessStageAccess psa  WHERE vaot.AccessObject = psa.AccessObject'
	
				IF @ProcessStageID IS NOT NULL
					SET @sql = @sql + ' AND (psa.ProcessStageID = @ProcessStageID) AND (psa.FlowStageID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND (psa.ProcessStageID IS NULL) AND (psa.FlowStageID = @FlowStageID)'

				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (DocumentAccess <> 1 OR DispatchAccess <> 1)'
			END
	
		SET @sql = @sql + '
		)
	 AND (vaot.AccessObject <> 1)'
	END

	IF (@Type = 0 or @Type = 2) SET @sql = @sql + ' UNION '
	
	SET @sql = @sql + '
	SELECT 
		v1.OrganizationalUnitID, 
		v1.Type, 
		v1.[ID],
		v1.Hierarchy,
		v1.[Description] AS Description,
		1 as Ordem
	FROM
	('
	
	IF (@Type = 0 or @Type = 1) 
	SET @sql = @sql + '
	SELECT 
		ou.OrganizationalUnitID, 
		1 AS Type,
		u.UserID AS ID, 
		u.PrimaryGroupID AS Hierarchy,		
		u.UserDesc AS Description,
		3 as Ordem
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON ou.UserID=u.UserID'
	
	IF (@Type = 0) SET @sql = @sql + ' UNION '
	
	IF (@Type = 0 or @Type = 2) 
	SET @sql = @sql + '
	SELECT 
		ou.OrganizationalUnitID,
		2 AS Type, 
		g.GroupID AS ID, 
	 	g.HierarchyID AS Hierarchy,
		g.GroupDesc AS Description,
		2 as Ordem
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID'

	SET @sql = @sql +') v1
	
	WHERE EXISTS
		(SELECT 1
		 FROM '
			IF @ProcessID IS NOT NULL OR @FlowID IS NOT NULL
			BEGIN
				SET @sql = @sql + ' OW.tblProcessAccess pa  WHERE v1.OrganizationalUnitID = pa.OrganizationalUnitID'

				IF @ProcessID IS NOT NULL
					SET @sql = @sql + ' AND (pa.ProcessID = @ProcessID) AND (pa.FlowID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND(pa.ProcessID IS NULL) AND (pa.FlowID = @FlowID)'

				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (StartProcess <> 1 OR ProcessDataAccess <> 1 OR DynamicFieldAccess <> 1 OR DocumentAccess <> 1 OR DocumentEditAccess <> 1 OR DispatchAccess <> 1)'
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' OW.tblProcessStageAccess psa  WHERE v1.OrganizationalUnitID = psa.OrganizationalUnitID'
	
				IF @ProcessStageID IS NOT NULL
					SET @sql = @sql + ' AND (psa.ProcessStageID = @ProcessStageID) AND (psa.FlowStageID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND (psa.ProcessStageID IS NULL) AND (psa.FlowStageID = @FlowStageID)'
				
				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (DocumentAccess <> 1 OR DispatchAccess <> 1)'

			END

		SET @sql = @sql + '
		) '

	SET @sql = @sql + ' ORDER BY Ordem Asc, Description Asc'

	EXEC sp_executesql @sql, 
		N'@FlowID int,
		@ProcessID int,
		@FlowStageID int,
		@ProcessStageID int',
		@FlowID,
		@ProcessID,
		@FlowStageID,
		@ProcessStageID
		
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx04 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx04 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[OrganizationalUnitSelectEx05]'
GO
CREATE PROCEDURE [OW].OrganizationalUnitSelectEx05
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Created On :	11-04-2008 14:19:00
	--Version : 	1.0
	--Description:	Devolve todas as unidades organizacionais de um dado tipo. E usado para
	--		mostrar a arvore de unidades organizacionais para definir acessos a um fluxo
	--		ou processo ou etapa de fluxo ou etapa de processo.
	-- 		@Type: 0 - All 1 - Users 2 - Groups
	------------------------------------------------------------------------------------------------------------------------------------------------
	@Type int, 
	@UserActive bit,
	@VisibleGroups bit = null
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @sql nvarchar(4000)

	SET @sql = ''

	IF (@Type IS NULL OR @Type NOT IN (0, 1, 2)) SET @Type = 0

	IF (@Type = 0 OR @Type = 1)
	BEGIN
		SET @sql = '
		SELECT 
			ou.OrganizationalUnitID, 
			1 AS Type,
			u.UserID AS ID, 
			u.PrimaryGroupID AS Hierarchy,		
			u.UserDesc AS Description,
			2 as Ordem
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON ou.UserID=u.UserID'

		IF (@UserActive IS NOT NULL) SET @sql = @sql + ' WHERE u.userActive = @UserActive'
	END

	IF (@Type = 0) SET @sql = @sql + ' UNION '

	IF (@Type = 0 OR @Type = 2)
	BEGIN	
		
		SET @sql = @sql + '
			SELECT   
				NULL AS OrganizationalUnitID, 
				2 AS Type, 
				vaot.[ID] AS ID,
				vaot.Hierarchy AS Hierarchy,
				vaot.[Description] AS Description,
				0 as Ordem
			FROM         
				OW.vAccessObjectType vaot 
			WHERE     (vaot.AccessObject <> 1) UNION '

		SET @sql = @sql + '
			SELECT 
				ou.OrganizationalUnitID,
				2 AS Type, 
				g.GroupID AS ID, 
			 	g.HierarchyID AS Hierarchy,
				g.GroupDesc AS Description,
				1 as Ordem
			FROM OW.tblOrganizationalUnit ou	
				INNER JOIN OW.tblGroups g
				ON ou.GroupID=g.GroupID'

			IF (@VisibleGroups IS NOT NULL) SET @sql = @sql + ' WHERE g.Visible=@VisibleGroups'
	END

	SET @sql = @sql + ' ORDER BY Ordem Asc, Description Asc'

	exec sp_executesql @sql, 
		N'@UserActive bit,
		@VisibleGroups bit',
		@UserActive,
		@VisibleGroups
		
	SET @Err = @@Error
	RETURN @Err
END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx05 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx05 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[OrganizationalUnitSelectEx06]'
GO
CREATE PROCEDURE [OW].OrganizationalUnitSelectEx06
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Created On :	11-04-2008 14:19:00
	--Version : 	1.0
	--Description:	Devolve unidades organizacionais dependentes de  um grupo que tenham 
	--		algum tipo de acesso a um fluxo ou a um processo ou a etapas de fluxos 
	-- 		ou processos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	@GroupID int, 
	@FlowID int = NULL,
	@ProcessID int = NULL,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql nvarchar(4000)

	SET @sql = ''

	BEGIN
	SET @sql = @sql + '
	SELECT   
		NULL AS OrganizationalUnitID, 
		2 AS Type, 
		vaot.[ID],
		vaot.Hierarchy,
		vaot.[Description] AS Description
	FROM         
		OW.vAccessObjectType vaot 

	WHERE EXISTS
		(SELECT 1
		 FROM'
			
			IF @ProcessID IS NOT NULL OR @FlowID IS NOT NULL
			BEGIN
				SET @sql = @sql + ' OW.tblProcessAccess pa  WHERE vaot.AccessObject = pa.AccessObject'

				IF @ProcessID IS NOT NULL
					SET @sql = @sql + ' AND (pa.ProcessID = @ProcessID) AND (pa.FlowID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND(pa.ProcessID IS NULL) AND (pa.FlowID = @FlowID)'

				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (StartProcess <> 1 OR ProcessDataAccess <> 1 OR DynamicFieldAccess <> 1 OR DocumentAccess <> 1 OR DocumentEditAccess <> 1 OR DispatchAccess <> 1)'
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' OW.tblProcessStageAccess psa  WHERE vaot.AccessObject = psa.AccessObject'
	
				IF @ProcessStageID IS NOT NULL
					SET @sql = @sql + ' AND (psa.ProcessStageID = @ProcessStageID) AND (psa.FlowStageID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND (psa.ProcessStageID IS NULL) AND (psa.FlowStageID = @FlowStageID)'

				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (DocumentAccess <> 1 OR DispatchAccess <> 1)'
			END
	
		SET @sql = @sql + '
		)
	AND (vaot.AccessObject <> 1 AND vaot.Hierarchy = @GroupID)'
	END

	SET @sql = @sql + ' UNION '
	
	SET @sql = @sql + '
	SELECT 
		v1.OrganizationalUnitID, 
		v1.Type, 
		v1.[ID],
		v1.Hierarchy,
		v1.[Description] AS Description
	FROM
	('
	
	SET @sql = @sql + '
	SELECT 
		ou.OrganizationalUnitID, 
		1 AS Type,
		u.UserID AS ID, 
		u.PrimaryGroupID AS Hierarchy,		
		u.UserDesc AS Description
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblUser u
		ON ou.UserID=u.UserID
	WHERE 
		u.userActive = 1 AND 
		u.PrimaryGroupID = @GroupID'
	
	SET @sql = @sql + ' UNION '
	
	SET @sql = @sql + '
	SELECT 
		ou.OrganizationalUnitID,
		2 AS Type, 
		g.GroupID AS ID, 
	 	g.HierarchyID AS Hierarchy,
		g.GroupDesc AS Description
	FROM OW.tblOrganizationalUnit ou	
		INNER JOIN OW.tblGroups g
		ON ou.GroupID=g.GroupID
	WHERE 
		g.Visible=1 AND 
		g.HierarchyID = @GroupID'

	SET @sql = @sql +') v1
	
	WHERE EXISTS
		(SELECT 1
		 FROM '
			IF @ProcessID IS NOT NULL OR @FlowID IS NOT NULL
			BEGIN
				SET @sql = @sql + ' OW.tblProcessAccess pa  WHERE v1.OrganizationalUnitID = pa.OrganizationalUnitID'

				IF @ProcessID IS NOT NULL
					SET @sql = @sql + ' AND (pa.ProcessID = @ProcessID) AND (pa.FlowID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND(pa.ProcessID IS NULL) AND (pa.FlowID = @FlowID)'

				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (StartProcess <> 1 OR ProcessDataAccess <> 1 OR DynamicFieldAccess <> 1 OR DocumentAccess <> 1 OR DocumentEditAccess <> 1 OR DispatchAccess <> 1)'
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' OW.tblProcessStageAccess psa  WHERE v1.OrganizationalUnitID = psa.OrganizationalUnitID'
	
				IF @ProcessStageID IS NOT NULL
					SET @sql = @sql + ' AND (psa.ProcessStageID = @ProcessStageID) AND (psa.FlowStageID IS NULL)'
				ELSE
					SET @sql = @sql + ' AND (psa.ProcessStageID IS NULL) AND (psa.FlowStageID = @FlowStageID)'
				
				-- Para apagar qd se criar a constraint
				-- SET @sql = @sql + ' AND (DocumentAccess <> 1 OR DispatchAccess <> 1)'

			END

		SET @sql = @sql + '
		) '

	SET @sql = @sql + ' ORDER BY Description Asc'

	EXEC sp_executesql @sql, 
		N'@GroupID int,
		@FlowID int,
		@ProcessID int,
		@FlowStageID int,
		@ProcessStageID int',
		@GroupID,
		@FlowID,
		@ProcessID,
		@FlowStageID,
		@ProcessStageID
		
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx06 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx06 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[OrganizationalUnitSelectEx07]'
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [OW].OrganizationalUnitSelectEx07
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Created On :	11-04-2008 14:19:00
	--Version : 	1.0
	--Description:	Devolve todas as unidades organizacionais dependentes de  um grupo.
	-- 		Ã‰ usado para expandir as unidades organizacionais de um grupo 
	--		para que se possa definir	acessos a um fluxo ou processo ou etapa de 
	--		fluxo ou etapa de processo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	@GroupID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @sql nvarchar(4000)

	set @sql = ''

	begin
		set @sql = '
		SELECT 
			ou.OrganizationalUnitID, 
			1 AS Type,
			u.UserID AS ID, 
			u.PrimaryGroupID AS Hierarchy,		
			u.UserDesc AS Description
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON ou.UserID=u.UserID'

		set @sql = @sql + ' WHERE u.userActive = 1 AND u.PrimaryGroupID = @GroupID'

	end

	set @sql = @sql + ' UNION '

	begin	
		set @sql = @sql + '
			SELECT 
				ou.OrganizationalUnitID,
				2 AS Type, 
				g.GroupID AS ID, 
			 	g.HierarchyID AS Hierarchy,
				g.GroupDesc AS Description
			FROM OW.tblOrganizationalUnit ou	
				INNER JOIN OW.tblGroups g
				ON ou.GroupID=g.GroupID'

			 set @sql = @sql + ' WHERE g.Visible=1 AND g.HierarchyID = @GroupID'

	end

	set @sql = @sql + ' ORDER BY Description'

	exec sp_executesql @sql, 
		N'@GroupID int',
		@GroupID
		
		
	SET @Err = @@Error
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Defect  562, 824 updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Defect  562, 824 update failed'
GO
DROP TABLE #tmpErrors
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  969 - Melhorar a performance do OWProcess
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Procedimentos Base
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO



	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].LogSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [dbo].LogSelect
GO

CREATE PROCEDURE [dbo].LogSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[LogID] '
		SET @sql = @sql + ',[EventID] '
		SET @sql = @sql + ',[Category] '
		SET @sql = @sql + ',[Priority] '
		SET @sql = @sql + ',[Severity] '
		SET @sql = @sql + ',[Title] '
		SET @sql = @sql + ',[Timestamp] '
		SET @sql = @sql + ',[MachineName] '
		SET @sql = @sql + ',[AppDomainName] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[ProcessName] '
		SET @sql = @sql + ',[ThreadName] '
		SET @sql = @sql + ',[Win32ThreadId] '
		SET @sql = @sql + ',[Message] '
		SET @sql = @sql + ',[FormattedMessage] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [dbo].[Log] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@LogID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LogID] = @LogID AND '
		IF (@EventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EventID] = @EventID AND '
		IF (@Category IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Category] LIKE @Category AND '
		IF (@Priority IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Priority] = @Priority AND '
		IF (@Severity IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Severity] LIKE @Severity AND '
		IF (@Title IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Title] LIKE @Title AND '
		IF (@Timestamp IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Timestamp] = @Timestamp AND '
		IF (@MachineName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MachineName] LIKE @MachineName AND '
		IF (@AppDomainName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AppDomainName] LIKE @AppDomainName AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] LIKE @ProcessID AND '
		IF (@ProcessName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessName] LIKE @ProcessName AND '
		IF (@ThreadName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ThreadName] LIKE @ThreadName AND '
		IF (@Win32ThreadId IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Win32ThreadId] LIKE @Win32ThreadId AND '
		IF (@Message IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Message] LIKE @Message AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [dbo].LogSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [dbo].LogSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].AlarmQueueSelect
GO

CREATE PROCEDURE [OW].AlarmQueueSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@AlertQueueID int = NULL,
		@LaunchDateTime datetime = NULL,
		@ProcessAlarmID int = NULL,
		@RequestAlarmID int = NULL,
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
		
		SET @sql = @sql + '[AlertQueueID] '
		SET @sql = @sql + ',[LaunchDateTime] '
		SET @sql = @sql + ',[ProcessAlarmID] '
		SET @sql = @sql + ',[RequestAlarmID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblAlarmQueue] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@AlertQueueID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlertQueueID] = @AlertQueueID AND '
		IF (@LaunchDateTime IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LaunchDateTime] = @LaunchDateTime AND '
		IF (@ProcessAlarmID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessAlarmID] = @ProcessAlarmID AND '
		IF (@RequestAlarmID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestAlarmID] = @RequestAlarmID AND '
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
		N'@AlertQueueID int, 
		@LaunchDateTime datetime, 
		@ProcessAlarmID int, 
		@RequestAlarmID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@AlertQueueID, 
		@LaunchDateTime, 
		@ProcessAlarmID, 
		@RequestAlarmID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].AlertSelect
GO

CREATE PROCEDURE [OW].AlertSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@AlertID int = NULL,
		@Message varchar(1000) = NULL,
		@UserID int = NULL,
		@AlertType tinyint = NULL,
		@ProcessID int = NULL,
		@ProcessStageID int = NULL,
		@RequestID numeric(18,0) = NULL,
		@ExceptionID int = NULL,
		@SendDateTime datetime = NULL,
		@ReadDateTime datetime = NULL,
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
		
		SET @sql = @sql + '[AlertID] '
		SET @sql = @sql + ',[Message] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[AlertType] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[ProcessStageID] '
		SET @sql = @sql + ',[RequestID] '
		SET @sql = @sql + ',[ExceptionID] '
		SET @sql = @sql + ',[SendDateTime] '
		SET @sql = @sql + ',[ReadDateTime] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblAlert] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@AlertID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlertID] = @AlertID AND '
		IF (@Message IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Message] LIKE @Message AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
		IF (@AlertType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlertType] = @AlertType AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND '
		IF (@ProcessStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageID] = @ProcessStageID AND '
		IF (@RequestID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestID] = @RequestID AND '
		IF (@ExceptionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ExceptionID] = @ExceptionID AND '
		IF (@SendDateTime IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[SendDateTime] = @SendDateTime AND '
		IF (@ReadDateTime IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ReadDateTime] = @ReadDateTime AND '
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
		N'@AlertID int, 
		@Message varchar(1000), 
		@UserID int, 
		@AlertType tinyint, 
		@ProcessID int, 
		@ProcessStageID int, 
		@RequestID numeric(18,0), 
		@ExceptionID int, 
		@SendDateTime datetime, 
		@ReadDateTime datetime, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@AlertID, 
		@Message, 
		@UserID, 
		@AlertType, 
		@ProcessID, 
		@ProcessStageID, 
		@RequestID, 
		@ExceptionID, 
		@SendDateTime, 
		@ReadDateTime, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].AlertSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].OWNotifyAgentRegisterSelect
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@OWNotifyAgentRegisterID int = NULL,
		@UserID int = NULL,
		@Host varchar(50) = NULL,
		@Protocol varchar(20) = NULL,
		@Port int = NULL,
		@Uri varchar(50) = NULL,
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
		
		SET @sql = @sql + '[OWNotifyAgentRegisterID] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[Host] '
		SET @sql = @sql + ',[Protocol] '
		SET @sql = @sql + ',[Port] '
		SET @sql = @sql + ',[Uri] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblOWNotifyAgentRegister] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@OWNotifyAgentRegisterID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OWNotifyAgentRegisterID] = @OWNotifyAgentRegisterID AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
		IF (@Host IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Host] LIKE @Host AND '
		IF (@Protocol IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Protocol] LIKE @Protocol AND '
		IF (@Port IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Port] = @Port AND '
		IF (@Uri IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Uri] LIKE @Uri AND '
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
		N'@OWNotifyAgentRegisterID int, 
		@UserID int, 
		@Host varchar(50), 
		@Protocol varchar(20), 
		@Port int, 
		@Uri varchar(50), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@OWNotifyAgentRegisterID, 
		@UserID, 
		@Host, 
		@Protocol, 
		@Port, 
		@Uri, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchFieldsSelect
GO

CREATE PROCEDURE [OW].ArchFieldsSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdField] '
		SET @sql = @sql + ',[OriginalName] '
		SET @sql = @sql + ',[OriginalDesignation] '
		SET @sql = @sql + ',[OriginalSize] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchFields] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdField IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdField] = @IdField AND '
		IF (@OriginalName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OriginalName] LIKE @OriginalName AND '
		IF (@OriginalDesignation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OriginalDesignation] LIKE @OriginalDesignation AND '
		IF (@OriginalSize IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OriginalSize] = @OriginalSize AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchFieldsSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFieldsVsSpaceSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchFieldsVsSpaceSelect
GO

CREATE PROCEDURE [OW].ArchFieldsVsSpaceSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdSpace] '
		SET @sql = @sql + ',[IdField] '
		SET @sql = @sql + ',[Name] '
		SET @sql = @sql + ',[Designation] '
		SET @sql = @sql + ',[Size] '
		SET @sql = @sql + ',[Visible] '
		SET @sql = @sql + ',[Enabled] '
		SET @sql = @sql + ',[Order] '
		SET @sql = @sql + ',[Html] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchFieldsVsSpace] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdSpace IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdSpace] = @IdSpace AND '
		IF (@IdField IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdField] = @IdField AND '
		IF (@Name IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Name] LIKE @Name AND '
		IF (@Designation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Designation] LIKE @Designation AND '
		IF (@Size IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Size] = @Size AND '
		IF (@Visible IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Visible] = @Visible AND '
		IF (@Enabled IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Enabled] = @Enabled AND '
		IF (@Order IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Order] = @Order AND '
		IF (@Html IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Html] LIKE @Html AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@IdSpace int, 
		@IdField int, 
		@Name varchar(50), 
		@Designation varchar(250), 
		@Size int, 
		@Visible bit, 
		@Enabled bit, 
		@Order int, 
		@Html varchar(5000)',
		@IdSpace, 
		@IdField, 
		@Name, 
		@Designation, 
		@Size, 
		@Visible, 
		@Enabled, 
		@Order, 
		@Html
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	GO
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchFieldsVsSpaceSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalAccessTypeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchFisicalAccessTypeSelect
GO

CREATE PROCEDURE [OW].ArchFisicalAccessTypeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdFisicalAccessType] '
		SET @sql = @sql + ',[IdParentFAT] '
		SET @sql = @sql + ',[IdFisicalType] '
		SET @sql = @sql + ',[Order] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchFisicalAccessType] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdFisicalAccessType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdFisicalAccessType] = @IdFisicalAccessType AND '
		IF (@IdParentFAT IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdParentFAT] = @IdParentFAT AND '
		IF (@IdFisicalType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdFisicalType] = @IdFisicalType AND '
		IF (@Order IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Order] = @Order AND '
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchFisicalAccessTypeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalInsertSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchFisicalInsertSelect
GO

CREATE PROCEDURE [OW].ArchFisicalInsertSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdFisicalInsert] '
		SET @sql = @sql + ',[IdParentFI] '
		SET @sql = @sql + ',[IdFisicalAccessType] '
		SET @sql = @sql + ',[IdIdentityCB] '
		SET @sql = @sql + ',[Barcode] '
		SET @sql = @sql + ',[Order] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchFisicalInsert] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdFisicalInsert IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdFisicalInsert] = @IdFisicalInsert AND '
		IF (@IdParentFI IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdParentFI] = @IdParentFI AND '
		IF (@IdFisicalAccessType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdFisicalAccessType] = @IdFisicalAccessType AND '
		IF (@IdIdentityCB IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdIdentityCB] = @IdIdentityCB AND '
		IF (@Barcode IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Barcode] = @Barcode AND '
		IF (@Order IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Order] = @Order AND '
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchFisicalInsertSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchFisicalTypeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchFisicalTypeSelect
GO

CREATE PROCEDURE [OW].ArchFisicalTypeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdFisicalType] '
		SET @sql = @sql + ',[IdSpace] '
		SET @sql = @sql + ',[Abreviation] '
		SET @sql = @sql + ',[Designation] '
		SET @sql = @sql + ',[Order] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchFisicalType] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdFisicalType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdFisicalType] = @IdFisicalType AND '
		IF (@IdSpace IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdSpace] = @IdSpace AND '
		IF (@Abreviation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Abreviation] LIKE @Abreviation AND '
		IF (@Designation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Designation] LIKE @Designation AND '
		IF (@Order IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Order] = @Order AND '
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchFisicalTypeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchInsertVsFormSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchInsertVsFormSelect
GO

CREATE PROCEDURE [OW].ArchInsertVsFormSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdFisicalInsert] '
		SET @sql = @sql + ',[IdSpace] '
		SET @sql = @sql + ',[IdField] '
		SET @sql = @sql + ',[Value] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchInsertVsForm] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdFisicalInsert IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdFisicalInsert] = @IdFisicalInsert AND '
		IF (@IdSpace IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdSpace] = @IdSpace AND '
		IF (@IdField IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdField] = @IdField AND '
		IF (@Value IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Value] LIKE @Value AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@IdFisicalInsert int, 
		@IdSpace int, 
		@IdField int, 
		@Value varchar(5000)',
		@IdFisicalInsert, 
		@IdSpace, 
		@IdField, 
		@Value
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	GO
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchInsertVsFormSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchInsertVsFormSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ArchSpaceSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ArchSpaceSelect
GO

CREATE PROCEDURE [OW].ArchSpaceSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[IdSpace] '
		SET @sql = @sql + ',[OriginalAbreviation] '
		SET @sql = @sql + ',[CodeName] '
		SET @sql = @sql + ',[OriginalDesignation] '
		SET @sql = @sql + ',[Image] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblArchSpace] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdSpace IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdSpace] = @IdSpace AND '
		IF (@OriginalAbreviation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OriginalAbreviation] LIKE @OriginalAbreviation AND '
		IF (@CodeName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CodeName] LIKE @CodeName AND '
		IF (@OriginalDesignation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OriginalDesignation] LIKE @OriginalDesignation AND '
		IF (@Image IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Image] LIKE @Image AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ArchSpaceSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ArchSpaceSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].BooksSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].BooksSelect
GO

CREATE PROCEDURE [OW].BooksSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[bookID] '
		SET @sql = @sql + ',[abreviation] '
		SET @sql = @sql + ',[designation] '
		SET @sql = @sql + ',[automatic] '
		SET @sql = @sql + ',[hierarchical] '
		SET @sql = @sql + ',[Duplicated] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblBooks] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@bookID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[bookID] = @bookID AND '
		IF (@abreviation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[abreviation] LIKE @abreviation AND '
		IF (@designation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[designation] LIKE @designation AND '
		IF (@automatic IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[automatic] = @automatic AND '
		IF (@hierarchical IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[hierarchical] = @hierarchical AND '
		IF (@Duplicated IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Duplicated] = @Duplicated AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].BooksSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].BooksSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ClassificationSelect
GO

CREATE PROCEDURE [OW].ClassificationSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[ClassificationID] '
		SET @sql = @sql + ',[ParentID] '
		SET @sql = @sql + ',[Level] '
		SET @sql = @sql + ',[Code] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Global] '
		SET @sql = @sql + ',[Scope] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblClassification] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ClassificationID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ClassificationID] = @ClassificationID AND '
		IF (@ParentID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ParentID] = @ParentID AND '
		IF (@Level IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Level] = @Level AND '
		IF (@Code IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Code] LIKE @Code AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Global IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Global] = @Global AND '
		IF (@Scope IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Scope] = @Scope AND '
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ClassificationSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ClassificationBooksSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ClassificationBooksSelect
GO

CREATE PROCEDURE [OW].ClassificationBooksSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ClassBookID numeric(18,0) = NULL,
		@ClassID int = NULL,
		@BookID numeric(18,0) = NULL
		
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
		
		SET @sql = @sql + '[ClassBookID] '
		SET @sql = @sql + ',[ClassID] '
		SET @sql = @sql + ',[BookID] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblClassificationBooks] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ClassBookID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ClassBookID] = @ClassBookID AND '
		IF (@ClassID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ClassID] = @ClassID AND '
		IF (@BookID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[BookID] = @BookID AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@ClassBookID numeric(18,0), 
		@ClassID int, 
		@BookID numeric(18,0)',
		@ClassBookID, 
		@ClassID, 
		@BookID
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	GO
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationBooksSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ClassificationBooksSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CountrySelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].CountrySelect
GO

CREATE PROCEDURE [OW].CountrySelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@CountryID int = NULL,
		@Code char(2) = NULL,
		@Description varchar(80) = NULL,
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
		
		SET @sql = @sql + '[CountryID] '
		SET @sql = @sql + ',[Code] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblCountry] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@CountryID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CountryID] = @CountryID AND '
		IF (@Code IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Code] = @Code AND '
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
		N'@CountryID int, 
		@Code char(2), 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@CountryID, 
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
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CountrySelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].CountrySelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DistrictSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].DistrictSelect
GO

CREATE PROCEDURE [OW].DistrictSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@DistrictID int = NULL,
		@CountryID int = NULL,
		@Description varchar(80) = NULL,
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
		
		SET @sql = @sql + '[DistrictID] '
		SET @sql = @sql + ',[CountryID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblDistrict] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@DistrictID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DistrictID] = @DistrictID AND '
		IF (@CountryID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CountryID] = @CountryID AND '
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
		N'@DistrictID int, 
		@CountryID int, 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@DistrictID, 
		@CountryID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DistrictSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].DistrictSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].DocumentSelect
GO

CREATE PROCEDURE [OW].DocumentSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@DocumentID int = NULL,
		@Name varchar(300) = NULL,
		@LastDocumentVersionID int = NULL,
		@CheckOutByUserID int = NULL,
		@CheckOutURL varchar(300) = NULL,
		@FinalVersion bit = NULL,
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
		
		SET @sql = @sql + '[DocumentID] '
		SET @sql = @sql + ',[Name] '
		SET @sql = @sql + ',[LastDocumentVersionID] '
		SET @sql = @sql + ',[CheckOutByUserID] '
		SET @sql = @sql + ',[CheckOutURL] '
		SET @sql = @sql + ',[FinalVersion] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblDocument] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@DocumentID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentID] = @DocumentID AND '
		IF (@Name IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Name] LIKE @Name AND '
		IF (@LastDocumentVersionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[LastDocumentVersionID] = @LastDocumentVersionID AND '
		IF (@CheckOutByUserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CheckOutByUserID] = @CheckOutByUserID AND '
		IF (@CheckOutURL IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CheckOutURL] LIKE @CheckOutURL AND '
		IF (@FinalVersion IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FinalVersion] = @FinalVersion AND '
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
		N'@DocumentID int, 
		@Name varchar(300), 
		@LastDocumentVersionID int, 
		@CheckOutByUserID int, 
		@CheckOutURL varchar(300), 
		@FinalVersion bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@DocumentID, 
		@Name, 
		@LastDocumentVersionID, 
		@CheckOutByUserID, 
		@CheckOutURL, 
		@FinalVersion, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].DocumentSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].DocumentTemplateSelect
GO

CREATE PROCEDURE [OW].DocumentTemplateSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@DocumentTemplateID int = NULL,
		@DocumentCode varchar(20) = NULL,
		@Description varchar(255) = NULL,
		@FileID int = NULL,
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
		
		SET @sql = @sql + '[DocumentTemplateID] '
		SET @sql = @sql + ',[DocumentCode] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[FileID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblDocumentTemplate] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@DocumentTemplateID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentTemplateID] = @DocumentTemplateID AND '
		IF (@DocumentCode IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentCode] LIKE @DocumentCode AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@FileID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FileID] = @FileID AND '
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
		N'@DocumentTemplateID int, 
		@DocumentCode varchar(20), 
		@Description varchar(255), 
		@FileID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@DocumentTemplateID, 
		@DocumentCode, 
		@Description, 
		@FileID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateFieldSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].DocumentTemplateFieldSelect
GO

CREATE PROCEDURE [OW].DocumentTemplateFieldSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@DocumentTemplateFieldID int = NULL,
		@DocumentTemplateID int = NULL,
		@ProcessDynamicFieldID int = NULL,
		@BookmarkName varchar(255) = NULL,
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
		
		SET @sql = @sql + '[DocumentTemplateFieldID] '
		SET @sql = @sql + ',[DocumentTemplateID] '
		SET @sql = @sql + ',[ProcessDynamicFieldID] '
		SET @sql = @sql + ',[BookmarkName] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblDocumentTemplateField] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@DocumentTemplateFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentTemplateFieldID] = @DocumentTemplateFieldID AND '
		IF (@DocumentTemplateID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentTemplateID] = @DocumentTemplateID AND '
		IF (@ProcessDynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDynamicFieldID] = @ProcessDynamicFieldID AND '
		IF (@BookmarkName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[BookmarkName] LIKE @BookmarkName AND '
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
		N'@DocumentTemplateFieldID int, 
		@DocumentTemplateID int, 
		@ProcessDynamicFieldID int, 
		@BookmarkName varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@DocumentTemplateFieldID, 
		@DocumentTemplateID, 
		@ProcessDynamicFieldID, 
		@BookmarkName, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateFieldSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateFieldSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentVersionSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].DocumentVersionSelect
GO

CREATE PROCEDURE [OW].DocumentVersionSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@DocumentVersionID int = NULL,
		@DocumentID int = NULL,
		@VersionNumber tinyint = NULL,
		@Pathname varchar(300) = NULL,
		@Size int = NULL,
		@UserID int = NULL,
		@Comment varchar(300) = NULL,
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
		
		SET @sql = @sql + '[DocumentVersionID] '
		SET @sql = @sql + ',[DocumentID] '
		SET @sql = @sql + ',[VersionNumber] '
		SET @sql = @sql + ',[Pathname] '
		SET @sql = @sql + ',[Size] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[Comment] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblDocumentVersion] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@DocumentVersionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentVersionID] = @DocumentVersionID AND '
		IF (@DocumentID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentID] = @DocumentID AND '
		IF (@VersionNumber IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[VersionNumber] = @VersionNumber AND '
		IF (@Pathname IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Pathname] LIKE @Pathname AND '
		IF (@Size IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Size] = @Size AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
		IF (@Comment IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Comment] LIKE @Comment AND '
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
		N'@DocumentVersionID int, 
		@DocumentID int, 
		@VersionNumber tinyint, 
		@Pathname varchar(300), 
		@Size int, 
		@UserID int, 
		@Comment varchar(300), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@DocumentVersionID, 
		@DocumentID, 
		@VersionNumber, 
		@Pathname, 
		@Size, 
		@UserID, 
		@Comment, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentVersionSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].DocumentVersionSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].DynamicFieldSelect
GO

CREATE PROCEDURE [OW].DynamicFieldSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@DynamicFieldID int = NULL,
		@Description varchar(80) = NULL,
		@DynamicFieldTypeID int = NULL,
		@ListOfValuesID int = NULL,
		@Precision int = NULL,
		@Scale int = NULL,
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
		
		SET @sql = @sql + '[DynamicFieldID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[DynamicFieldTypeID] '
		SET @sql = @sql + ',[ListOfValuesID] '
		SET @sql = @sql + ',[Precision] '
		SET @sql = @sql + ',[Scale] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblDynamicField] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@DynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DynamicFieldID] = @DynamicFieldID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@DynamicFieldTypeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DynamicFieldTypeID] = @DynamicFieldTypeID AND '
		IF (@ListOfValuesID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ListOfValuesID] = @ListOfValuesID AND '
		IF (@Precision IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Precision] = @Precision AND '
		IF (@Scale IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Scale] = @Scale AND '
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
		N'@DynamicFieldID int, 
		@Description varchar(80), 
		@DynamicFieldTypeID int, 
		@ListOfValuesID int, 
		@Precision int, 
		@Scale int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@DynamicFieldID, 
		@Description, 
		@DynamicFieldTypeID, 
		@ListOfValuesID, 
		@Precision, 
		@Scale, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].DynamicFieldSelect Error on Creation'
	GO
	


	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].EntitiesSelect
GO

CREATE PROCEDURE [OW].EntitiesSelect
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].EntitiesSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesTempSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].EntitiesTempSelect
GO

CREATE PROCEDURE [OW].EntitiesTempSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@id numeric(18,0) = NULL,
		@guid nchar(32) = NULL,
		@entityname varchar(400) = NULL,
		@entitytype bit = NULL,
		@ContactID nvarchar(250) = NULL,
		@EntID varchar(100) = NULL
		
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
		
		SET @sql = @sql + '[id] '
		SET @sql = @sql + ',[guid] '
		SET @sql = @sql + ',[entityname] '
		SET @sql = @sql + ',[entitytype] '
		SET @sql = @sql + ',[ContactID] '
		SET @sql = @sql + ',[EntID] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntitiesTemp] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@id IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[id] = @id AND '
		IF (@guid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[guid] = @guid AND '
		IF (@entityname IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[entityname] LIKE @entityname AND '
		IF (@entitytype IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[entitytype] = @entitytype AND '
		IF (@ContactID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ContactID] LIKE @ContactID AND '
		IF (@EntID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EntID] LIKE @EntID AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@id numeric(18,0), 
		@guid nchar(32), 
		@entityname varchar(400), 
		@entitytype bit, 
		@ContactID nvarchar(250), 
		@EntID varchar(100)',
		@id, 
		@guid, 
		@entityname, 
		@entitytype, 
		@ContactID, 
		@EntID
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	GO
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesTempSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].EntitiesTempSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntityTypeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].EntityTypeSelect
GO

CREATE PROCEDURE [OW].EntityTypeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@EntityTypeID int = NULL,
		@Description varchar(80) = NULL,
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
		
		SET @sql = @sql + '[EntityTypeID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblEntityType] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@EntityTypeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EntityTypeID] = @EntityTypeID AND '
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
		N'@EntityTypeID int, 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@EntityTypeID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntityTypeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].EntityTypeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ExceptionManagementSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ExceptionManagementSelect
GO

CREATE PROCEDURE [OW].ExceptionManagementSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ExceptionID int = NULL,
		@Description varchar(80) = NULL,
		@Active bit = NULL,
		@Message varchar(255) = NULL,
		@AlertByEMail bit = NULL,
		@AddresseeExecutant bit = NULL,
		@AddresseeFlowOwner bit = NULL,
		@AddresseeProcessOwner bit = NULL,
		@AddresseeBookManager bit = NULL,
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
		
		SET @sql = @sql + '[ExceptionID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Active] '
		SET @sql = @sql + ',[Message] '
		SET @sql = @sql + ',[AlertByEMail] '
		SET @sql = @sql + ',[AddresseeExecutant] '
		SET @sql = @sql + ',[AddresseeFlowOwner] '
		SET @sql = @sql + ',[AddresseeProcessOwner] '
		SET @sql = @sql + ',[AddresseeBookManager] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblExceptionManagement] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ExceptionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ExceptionID] = @ExceptionID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Active IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Active] = @Active AND '
		IF (@Message IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Message] LIKE @Message AND '
		IF (@AlertByEMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlertByEMail] = @AlertByEMail AND '
		IF (@AddresseeExecutant IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeExecutant] = @AddresseeExecutant AND '
		IF (@AddresseeFlowOwner IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeFlowOwner] = @AddresseeFlowOwner AND '
		IF (@AddresseeProcessOwner IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeProcessOwner] = @AddresseeProcessOwner AND '
		IF (@AddresseeBookManager IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeBookManager] = @AddresseeBookManager AND '
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
		N'@ExceptionID int, 
		@Description varchar(80), 
		@Active bit, 
		@Message varchar(255), 
		@AlertByEMail bit, 
		@AddresseeExecutant bit, 
		@AddresseeFlowOwner bit, 
		@AddresseeProcessOwner bit, 
		@AddresseeBookManager bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ExceptionID, 
		@Description, 
		@Active, 
		@Message, 
		@AlertByEMail, 
		@AddresseeExecutant, 
		@AddresseeFlowOwner, 
		@AddresseeProcessOwner, 
		@AddresseeBookManager, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ExceptionManagementSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ExceptionManagementSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ExceptionManagementAddresseeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ExceptionManagementAddresseeSelect
GO

CREATE PROCEDURE [OW].ExceptionManagementAddresseeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ExceptionManagementAddresseeID int = NULL,
		@ExceptionID int = NULL,
		@OrganizationalUnitID int = NULL,
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
		
		SET @sql = @sql + '[ExceptionManagementAddresseeID] '
		SET @sql = @sql + ',[ExceptionID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblExceptionManagementAddressee] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ExceptionManagementAddresseeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ExceptionManagementAddresseeID] = @ExceptionManagementAddresseeID AND '
		IF (@ExceptionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ExceptionID] = @ExceptionID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
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
		N'@ExceptionManagementAddresseeID int, 
		@ExceptionID int, 
		@OrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ExceptionManagementAddresseeID, 
		@ExceptionID, 
		@OrganizationalUnitID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ExceptionManagementAddresseeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ExceptionManagementAddresseeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FavoriteSearchSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FavoriteSearchSelect
GO

CREATE PROCEDURE [OW].FavoriteSearchSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[FavoriteSearchID] '
		SET @sql = @sql + ',[Type] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Global] '
		SET @sql = @sql + ',[SearchCriteria] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFavoriteSearch] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FavoriteSearchID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FavoriteSearchID] = @FavoriteSearchID AND '
		IF (@Type IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Type] = @Type AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FavoriteSearchSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FavoriteSearchSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FlowSelect
GO

CREATE PROCEDURE [OW].FlowSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@FlowID int = NULL,
		@Code varchar(10) = NULL,
		@Status tinyint = NULL,
		@FlowOwnerID int = NULL,
		@FlowDefinitionID int = NULL,
		@MajorVersion int = NULL,
		@MinorVersion int = NULL,
		@Duration int = NULL,
		@WorkCalendar bit = NULL,
		@ProcessNumberRule varchar(1024) = NULL,
		@HelpAddress varchar(255) = NULL,
		@NotifyRetrocession bit = NULL,
		@WorkflowRule text = NULL,
		@Adhoc bit = NULL,
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
		
		SET @sql = @sql + '[FlowID] '
		SET @sql = @sql + ',[Code] '
		SET @sql = @sql + ',[Status] '
		SET @sql = @sql + ',[FlowOwnerID] '
		SET @sql = @sql + ',[FlowDefinitionID] '
		SET @sql = @sql + ',[MajorVersion] '
		SET @sql = @sql + ',[MinorVersion] '
		SET @sql = @sql + ',[Duration] '
		SET @sql = @sql + ',[WorkCalendar] '
		SET @sql = @sql + ',[ProcessNumberRule] '
		SET @sql = @sql + ',[HelpAddress] '
		SET @sql = @sql + ',[NotifyRetrocession] '
		SET @sql = @sql + ',[WorkflowRule] '
		SET @sql = @sql + ',[Adhoc] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlow] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@Code IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Code] LIKE @Code AND '
		IF (@Status IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Status] = @Status AND '
		IF (@FlowOwnerID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowOwnerID] = @FlowOwnerID AND '
		IF (@FlowDefinitionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowDefinitionID] = @FlowDefinitionID AND '
		IF (@MajorVersion IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MajorVersion] = @MajorVersion AND '
		IF (@MinorVersion IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MinorVersion] = @MinorVersion AND '
		IF (@Duration IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Duration] = @Duration AND '
		IF (@WorkCalendar IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkCalendar] = @WorkCalendar AND '
		IF (@ProcessNumberRule IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessNumberRule] LIKE @ProcessNumberRule AND '
		IF (@HelpAddress IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[HelpAddress] LIKE @HelpAddress AND '
		IF (@NotifyRetrocession IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NotifyRetrocession] = @NotifyRetrocession AND '
		IF (@WorkflowRule IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkflowRule] LIKE @WorkflowRule AND '
		IF (@Adhoc IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Adhoc] = @Adhoc AND '
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
		N'@FlowID int, 
		@Code varchar(10), 
		@Status tinyint, 
		@FlowOwnerID int, 
		@FlowDefinitionID int, 
		@MajorVersion int, 
		@MinorVersion int, 
		@Duration int, 
		@WorkCalendar bit, 
		@ProcessNumberRule varchar(1024), 
		@HelpAddress varchar(255), 
		@NotifyRetrocession bit, 
		@WorkflowRule text,
		@Adhoc bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowID, 
		@Code, 
		@Status, 
		@FlowOwnerID, 
		@FlowDefinitionID, 
		@MajorVersion, 
		@MinorVersion, 
		@Duration, 
		@WorkCalendar, 
		@ProcessNumberRule, 
		@HelpAddress, 
		@NotifyRetrocession, 
		@WorkflowRule, 
		@Adhoc, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FlowSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDefinitionSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FlowDefinitionSelect
GO

CREATE PROCEDURE [OW].FlowDefinitionSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@FlowDefinitionID int = NULL,
		@Description varchar(80) = NULL,
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
		
		SET @sql = @sql + '[FlowDefinitionID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlowDefinition] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FlowDefinitionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowDefinitionID] = @FlowDefinitionID AND '
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
		N'@FlowDefinitionID int, 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowDefinitionID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDefinitionSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FlowDefinitionSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FlowMailConnectorSelect
GO

CREATE PROCEDURE [OW].FlowMailConnectorSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@MailConnectorID int = NULL,
		@Folder varchar(255) = NULL,
		@FlowID int = NULL,
		@FromAddress varchar(50) = NULL,
		@AttachMail bit = NULL,
		@AttachFiles bit = NULL,
		@CompleteStage bit = NULL,
		@Active bit = NULL,
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
		
		SET @sql = @sql + '[MailConnectorID] '
		SET @sql = @sql + ',[Folder] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[FromAddress] '
		SET @sql = @sql + ',[AttachMail] '
		SET @sql = @sql + ',[AttachFiles] '
		SET @sql = @sql + ',[CompleteStage] '
		SET @sql = @sql + ',[Active] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlowMailConnector] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@MailConnectorID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MailConnectorID] = @MailConnectorID AND '
		IF (@Folder IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Folder] LIKE @Folder AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@FromAddress IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FromAddress] LIKE @FromAddress AND '
		IF (@AttachMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AttachMail] = @AttachMail AND '
		IF (@AttachFiles IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AttachFiles] = @AttachFiles AND '
		IF (@CompleteStage IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CompleteStage] = @CompleteStage AND '
		IF (@Active IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Active] = @Active AND '
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
		N'@MailConnectorID int, 
		@Folder varchar(255), 
		@FlowID int, 
		@FromAddress varchar(50), 
		@AttachMail bit, 
		@AttachFiles bit, 
		@CompleteStage bit, 
		@Active bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@MailConnectorID, 
		@Folder, 
		@FlowID, 
		@FromAddress, 
		@AttachMail, 
		@AttachFiles, 
		@CompleteStage, 
		@Active, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowPreBuiltStageSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FlowPreBuiltStageSelect
GO

CREATE PROCEDURE [OW].FlowPreBuiltStageSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@FlowPreBuiltStageID int = NULL,
		@Description varchar(80) = NULL,
		@FlowStageType smallint = NULL,
		@Address varchar(255) = NULL,
		@Method varchar(80) = NULL,
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
		
		SET @sql = @sql + '[FlowPreBuiltStageID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[FlowStageType] '
		SET @sql = @sql + ',[Address] '
		SET @sql = @sql + ',[Method] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlowPreBuiltStage] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FlowPreBuiltStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowPreBuiltStageID] = @FlowPreBuiltStageID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@FlowStageType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageType] = @FlowStageType AND '
		IF (@Address IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Address] LIKE @Address AND '
		IF (@Method IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Method] LIKE @Method AND '
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
		N'@FlowPreBuiltStageID int, 
		@Description varchar(80), 
		@FlowStageType smallint, 
		@Address varchar(255), 
		@Method varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowPreBuiltStageID, 
		@Description, 
		@FlowStageType, 
		@Address, 
		@Method, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowPreBuiltStageSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FlowPreBuiltStageSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FlowRoutingSelect
GO

CREATE PROCEDURE [OW].FlowRoutingSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@FlowRoutingID int = NULL,
		@OrganizationalUnitID int = NULL,
		@StartDate datetime = NULL,
		@EndDate datetime = NULL,
		@FlowID int = NULL,
		@ToOrganizationalUnitID int = NULL,
		@Absence bit = NULL,
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
		
		SET @sql = @sql + '[FlowRoutingID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[StartDate] '
		SET @sql = @sql + ',[EndDate] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[ToOrganizationalUnitID] '
		SET @sql = @sql + ',[Absence] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlowRouting] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FlowRoutingID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowRoutingID] = @FlowRoutingID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@StartDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[StartDate] = @StartDate AND '
		IF (@EndDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EndDate] = @EndDate AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@ToOrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ToOrganizationalUnitID] = @ToOrganizationalUnitID AND '
		IF (@Absence IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Absence] = @Absence AND '
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
		N'@FlowRoutingID int, 
		@OrganizationalUnitID int, 
		@StartDate datetime, 
		@EndDate datetime, 
		@FlowID int, 
		@ToOrganizationalUnitID int, 
		@Absence bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowRoutingID, 
		@OrganizationalUnitID, 
		@StartDate, 
		@EndDate, 
		@FlowID, 
		@ToOrganizationalUnitID, 
		@Absence, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FlowRoutingSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].FlowStageSelect
GO

CREATE PROCEDURE [OW].FlowStageSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@FlowStageID int = NULL,
		@FlowID int = NULL,
		@Number smallint = NULL,
		@Description varchar(50) = NULL,
		@Duration int = NULL,
		@Address varchar(255) = NULL,
		@Method varchar(50) = NULL,
		@FlowStageType smallint = NULL,
		@DocumentTemplateID int = NULL,
		@OrganizationalUnitID int = NULL,
		@CanAssociateProcess bit = NULL,
		@Transfer tinyint = NULL,
		@RequestForComments tinyint = NULL,
		@AttachmentRequired bit = NULL,
		@EditDocuments tinyint = NULL,
		@HelpAddress varchar(255) = NULL,
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
		
		SET @sql = @sql + '[FlowStageID] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[Number] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Duration] '
		SET @sql = @sql + ',[Address] '
		SET @sql = @sql + ',[Method] '
		SET @sql = @sql + ',[FlowStageType] '
		SET @sql = @sql + ',[DocumentTemplateID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[CanAssociateProcess] '
		SET @sql = @sql + ',[Transfer] '
		SET @sql = @sql + ',[RequestForComments] '
		SET @sql = @sql + ',[AttachmentRequired] '
		SET @sql = @sql + ',[EditDocuments] '
		SET @sql = @sql + ',[HelpAddress] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlowStage] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FlowStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageID] = @FlowStageID AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@Number IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Number] = @Number AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Duration IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Duration] = @Duration AND '
		IF (@Address IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Address] LIKE @Address AND '
		IF (@Method IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Method] LIKE @Method AND '
		IF (@FlowStageType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageType] = @FlowStageType AND '
		IF (@DocumentTemplateID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentTemplateID] = @DocumentTemplateID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@CanAssociateProcess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CanAssociateProcess] = @CanAssociateProcess AND '
		IF (@Transfer IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Transfer] = @Transfer AND '
		IF (@RequestForComments IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestForComments] = @RequestForComments AND '
		IF (@AttachmentRequired IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AttachmentRequired] = @AttachmentRequired AND '
		IF (@EditDocuments IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EditDocuments] = @EditDocuments AND '
		IF (@HelpAddress IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[HelpAddress] LIKE @HelpAddress AND '
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
		N'@FlowStageID int, 
		@FlowID int, 
		@Number smallint, 
		@Description varchar(50), 
		@Duration int, 
		@Address varchar(255), 
		@Method varchar(50), 
		@FlowStageType smallint, 
		@DocumentTemplateID int, 
		@OrganizationalUnitID int, 
		@CanAssociateProcess bit, 
		@Transfer tinyint, 
		@RequestForComments tinyint, 
		@AttachmentRequired bit, 
		@EditDocuments tinyint, 
		@HelpAddress varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowStageID, 
		@FlowID, 
		@Number, 
		@Description, 
		@Duration, 
		@Address, 
		@Method, 
		@FlowStageType, 
		@DocumentTemplateID, 
		@OrganizationalUnitID, 
		@CanAssociateProcess, 
		@Transfer, 
		@RequestForComments, 
		@AttachmentRequired, 
		@EditDocuments, 
		@HelpAddress, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStageSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].FlowStageSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].GroupsSelect
GO

CREATE PROCEDURE [OW].GroupsSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@GroupID int = NULL,
		@GroupDesc varchar(100) = NULL,
		@ShortName varchar(10) = NULL,
		@External bit = NULL,
		@HierarchyID int = NULL,
		@Visible bit = NULL,
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
		
		SET @sql = @sql + '[GroupID] '
		SET @sql = @sql + ',[GroupDesc] '
		SET @sql = @sql + ',[ShortName] '
		SET @sql = @sql + ',[External] '
		SET @sql = @sql + ',[HierarchyID] '
		SET @sql = @sql + ',[Visible] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblGroups] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@GroupID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[GroupID] = @GroupID AND '
		IF (@GroupDesc IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[GroupDesc] LIKE @GroupDesc AND '
		IF (@ShortName IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ShortName] LIKE @ShortName AND '
		IF (@External IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[External] = @External AND '
		IF (@HierarchyID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[HierarchyID] = @HierarchyID AND '
		IF (@Visible IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Visible] = @Visible AND '
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
		N'@GroupID int, 
		@GroupDesc varchar(100), 
		@ShortName varchar(10), 
		@External bit, 
		@HierarchyID int, 
		@Visible bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@GroupID, 
		@GroupDesc, 
		@ShortName, 
		@External, 
		@HierarchyID, 
		@Visible, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].GroupsSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUsersSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].GroupsUsersSelect
GO

CREATE PROCEDURE [OW].GroupsUsersSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@GroupID int = NULL,
		@UserID int = NULL,
		@GroupsUserID int = NULL,
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
		
		SET @sql = @sql + '[GroupID] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[GroupsUserID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblGroupsUsers] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@GroupID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[GroupID] = @GroupID AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
		IF (@GroupsUserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[GroupsUserID] = @GroupsUserID AND '
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
		N'@GroupID int, 
		@UserID int, 
		@GroupsUserID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@GroupID, 
		@UserID, 
		@GroupsUserID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].GroupsUsersSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].HolidaySelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].HolidaySelect
GO

CREATE PROCEDURE [OW].HolidaySelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@HolidayID int = NULL,
		@HolidayDate datetime = NULL,
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
		
		SET @sql = @sql + '[HolidayID] '
		SET @sql = @sql + ',[HolidayDate] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblHoliday] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@HolidayID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[HolidayID] = @HolidayID AND '
		IF (@HolidayDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[HolidayDate] = @HolidayDate AND '
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
		N'@HolidayID int, 
		@HolidayDate datetime, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@HolidayID, 
		@HolidayDate, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].HolidaySelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].HolidaySelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].IdentityCBSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].IdentityCBSelect
GO

CREATE PROCEDURE [OW].IdentityCBSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@IdIdentityCB int = NULL,
		@Designation varchar(50) = NULL
		
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
		
		SET @sql = @sql + '[IdIdentityCB] '
		SET @sql = @sql + ',[Designation] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblIdentityCB] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@IdIdentityCB IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdIdentityCB] = @IdIdentityCB AND '
		IF (@Designation IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Designation] LIKE @Designation AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@IdIdentityCB int, 
		@Designation varchar(50)',
		@IdIdentityCB, 
		@Designation
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	GO
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].IdentityCBSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].IdentityCBSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ListOfValuesSelect
GO

CREATE PROCEDURE [OW].ListOfValuesSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ListOfValuesID int = NULL,
		@Description varchar(50) = NULL,
		@Type tinyint = NULL,
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
		
		SET @sql = @sql + '[ListOfValuesID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Type] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblListOfValues] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ListOfValuesID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ListOfValuesID] = @ListOfValuesID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Type IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Type] = @Type AND '
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
		N'@ListOfValuesID int, 
		@Description varchar(50), 
		@Type tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ListOfValuesID, 
		@Description, 
		@Type, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ListOfValuesSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesItemSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ListOfValuesItemSelect
GO

CREATE PROCEDURE [OW].ListOfValuesItemSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ListOfValuesItemID int = NULL,
		@ListOfValuesID int = NULL,
		@ItemCode varchar(70) = NULL,
		@ItemOrder int = NULL,
		@ItemDescription varchar(800) = NULL,
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
		
		SET @sql = @sql + '[ListOfValuesItemID] '
		SET @sql = @sql + ',[ListOfValuesID] '
		SET @sql = @sql + ',[ItemCode] '
		SET @sql = @sql + ',[ItemOrder] '
		SET @sql = @sql + ',[ItemDescription] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblListOfValuesItem] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ListOfValuesItemID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ListOfValuesItemID] = @ListOfValuesItemID AND '
		IF (@ListOfValuesID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ListOfValuesID] = @ListOfValuesID AND '
		IF (@ItemCode IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ItemCode] LIKE @ItemCode AND '
		IF (@ItemOrder IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ItemOrder] = @ItemOrder AND '
		IF (@ItemDescription IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ItemDescription] LIKE @ItemDescription AND '
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
		N'@ListOfValuesItemID int, 
		@ListOfValuesID int, 
		@ItemCode varchar(70), 
		@ItemOrder int, 
		@ItemDescription varchar(800), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ListOfValuesItemID, 
		@ListOfValuesID, 
		@ItemCode, 
		@ItemOrder, 
		@ItemDescription, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesItemSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ListOfValuesItemSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ModuleSelect
GO

CREATE PROCEDURE [OW].ModuleSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ModuleID int = NULL,
		@Description varchar(80) = NULL,
		@Active bit = NULL,
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
		
		SET @sql = @sql + '[ModuleID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Active] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblModule] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ModuleID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ModuleID] = @ModuleID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Active IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Active] = @Active AND '
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
		N'@ModuleID int, 
		@Description varchar(80), 
		@Active bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ModuleID, 
		@Description, 
		@Active, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ModuleSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OrganizationalUnitSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].OrganizationalUnitSelect
GO

CREATE PROCEDURE [OW].OrganizationalUnitSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@OrganizationalUnitID int = NULL,
		@GroupID int = NULL,
		@UserID int = NULL,
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
		
		SET @sql = @sql + '[OrganizationalUnitID] '
		SET @sql = @sql + ',[GroupID] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblOrganizationalUnit] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@GroupID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[GroupID] = @GroupID AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
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
		N'@OrganizationalUnitID int, 
		@GroupID int, 
		@UserID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@OrganizationalUnitID, 
		@GroupID, 
		@UserID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ParameterSelect
GO

CREATE PROCEDURE [OW].ParameterSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ParameterID int = NULL,
		@Description varchar(80) = NULL,
		@ParameterType tinyint = NULL,
		@Required bit = NULL,
		@NumericValue numeric(18,3) = NULL,
		@AlphaNumericValue varchar(255) = NULL,
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
		
		SET @sql = @sql + '[ParameterID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[ParameterType] '
		SET @sql = @sql + ',[Required] '
		SET @sql = @sql + ',[NumericValue] '
		SET @sql = @sql + ',[AlphaNumericValue] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblParameter] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ParameterID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ParameterID] = @ParameterID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@ParameterType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ParameterType] = @ParameterType AND '
		IF (@Required IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Required] = @Required AND '
		IF (@NumericValue IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NumericValue] = @NumericValue AND '
		IF (@AlphaNumericValue IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlphaNumericValue] LIKE @AlphaNumericValue AND '
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
		N'@ParameterID int, 
		@Description varchar(80), 
		@ParameterType tinyint, 
		@Required bit, 
		@NumericValue numeric(18,3), 
		@AlphaNumericValue varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ParameterID, 
		@Description, 
		@ParameterType, 
		@Required, 
		@NumericValue, 
		@AlphaNumericValue, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ParameterSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].PostalCodeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].PostalCodeSelect
GO

CREATE PROCEDURE [OW].PostalCodeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@PostalCodeID int = NULL,
		@Code varchar(10) = NULL,
		@Description varchar(100) = NULL,
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
		
		SET @sql = @sql + '[PostalCodeID] '
		SET @sql = @sql + ',[Code] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblPostalCode] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@PostalCodeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[PostalCodeID] = @PostalCodeID AND '
		IF (@Code IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Code] LIKE @Code AND '
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
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].PostalCodeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].PostalCodeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessSelect
GO

CREATE PROCEDURE [OW].ProcessSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessID int = NULL,
		@FlowID int = NULL,
		@ProcessNumber varchar(50) = NULL,
		@Year int = NULL,
		@ProcessSubject varchar(255) = NULL,
		@PriorityID int = NULL,
		@ProcessOwnerID int = NULL,
		@StartDate datetime = NULL,
		@EndDate datetime = NULL,
		@EstimatedDateToComplete datetime = NULL,
		@ProcessStatus int = NULL,
		@Duration int = NULL,
		@WorkCalendar bit = NULL,
		@NotifyRetrocession bit = NULL,
		@WorkflowRule text = NULL,
		@OriginatorID int = NULL,
		@Adhoc bit = NULL,
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
		
		SET @sql = @sql + '[ProcessID] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[ProcessNumber] '
		SET @sql = @sql + ',[Year] '
		SET @sql = @sql + ',[ProcessSubject] '
		SET @sql = @sql + ',[PriorityID] '
		SET @sql = @sql + ',[ProcessOwnerID] '
		SET @sql = @sql + ',[StartDate] '
		SET @sql = @sql + ',[EndDate] '
		SET @sql = @sql + ',[EstimatedDateToComplete] '
		SET @sql = @sql + ',[ProcessStatus] '
		SET @sql = @sql + ',[Duration] '
		SET @sql = @sql + ',[WorkCalendar] '
		SET @sql = @sql + ',[NotifyRetrocession] '
		SET @sql = @sql + ',[WorkflowRule] '
		SET @sql = @sql + ',[OriginatorID] '
		SET @sql = @sql + ',[Adhoc] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcess] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@ProcessNumber IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessNumber] LIKE @ProcessNumber AND '
		IF (@Year IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Year] = @Year AND '
		IF (@ProcessSubject IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessSubject] LIKE @ProcessSubject AND '
		IF (@PriorityID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[PriorityID] = @PriorityID AND '
		IF (@ProcessOwnerID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessOwnerID] = @ProcessOwnerID AND '
		IF (@StartDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[StartDate] = @StartDate AND '
		IF (@EndDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EndDate] = @EndDate AND '
		IF (@EstimatedDateToComplete IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EstimatedDateToComplete] = @EstimatedDateToComplete AND '
		IF (@ProcessStatus IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStatus] = @ProcessStatus AND '
		IF (@Duration IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Duration] = @Duration AND '
		IF (@WorkCalendar IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkCalendar] = @WorkCalendar AND '
		IF (@NotifyRetrocession IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NotifyRetrocession] = @NotifyRetrocession AND '
		IF (@WorkflowRule IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkflowRule] LIKE @WorkflowRule AND '
		IF (@OriginatorID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OriginatorID] = @OriginatorID AND '
		IF (@Adhoc IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Adhoc] = @Adhoc AND '
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
		N'@ProcessID int, 
		@FlowID int, 
		@ProcessNumber varchar(50), 
		@Year int, 
		@ProcessSubject varchar(255), 
		@PriorityID int, 
		@ProcessOwnerID int, 
		@StartDate datetime, 
		@EndDate datetime, 
		@EstimatedDateToComplete datetime, 
		@ProcessStatus int, 
		@Duration int, 
		@WorkCalendar bit, 
		@NotifyRetrocession bit, 
		@WorkflowRule text,
		@OriginatorID int, 
		@Adhoc bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessID, 
		@FlowID, 
		@ProcessNumber, 
		@Year, 
		@ProcessSubject, 
		@PriorityID, 
		@ProcessOwnerID, 
		@StartDate, 
		@EndDate, 
		@EstimatedDateToComplete, 
		@ProcessStatus, 
		@Duration, 
		@WorkCalendar, 
		@NotifyRetrocession, 
		@WorkflowRule, 
		@OriginatorID, 
		@Adhoc, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessAccessSelect
GO

CREATE PROCEDURE [OW].ProcessAccessSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessAccessID int = NULL,
		@FlowID int = NULL,
		@ProcessID int = NULL,
		@OrganizationalUnitID int = NULL,
		@AccessObject tinyint = NULL,
		@StartProcess tinyint = NULL,
		@ProcessDataAccess tinyint = NULL,
		@DynamicFieldAccess tinyint = NULL,
		@DocumentAccess tinyint = NULL,
		@DocumentEditAccess tinyint = NULL,
		@DispatchAccess tinyint = NULL,
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
		
		SET @sql = @sql + '[ProcessAccessID] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[AccessObject] '
		SET @sql = @sql + ',[StartProcess] '
		SET @sql = @sql + ',[ProcessDataAccess] '
		SET @sql = @sql + ',[DynamicFieldAccess] '
		SET @sql = @sql + ',[DocumentAccess] '
		SET @sql = @sql + ',[DocumentEditAccess] '
		SET @sql = @sql + ',[DispatchAccess] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessAccess] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessAccessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessAccessID] = @ProcessAccessID AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND [FlowID] IS NULL AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@AccessObject IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AccessObject] = @AccessObject AND '
		IF (@StartProcess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[StartProcess] = @StartProcess AND '
		IF (@ProcessDataAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDataAccess] = @ProcessDataAccess AND '
		IF (@DynamicFieldAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DynamicFieldAccess] = @DynamicFieldAccess AND '
		IF (@DocumentAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentAccess] = @DocumentAccess AND '
		IF (@DocumentEditAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentEditAccess] = @DocumentEditAccess AND '
		IF (@DispatchAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DispatchAccess] = @DispatchAccess AND '
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
		N'@ProcessAccessID int, 
		@FlowID int, 
		@ProcessID int, 
		@OrganizationalUnitID int, 
		@AccessObject tinyint, 
		@StartProcess tinyint, 
		@ProcessDataAccess tinyint, 
		@DynamicFieldAccess tinyint, 
		@DocumentAccess tinyint, 
		@DocumentEditAccess tinyint, 
		@DispatchAccess tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessAccessID, 
		@FlowID, 
		@ProcessID, 
		@OrganizationalUnitID, 
		@AccessObject, 
		@StartProcess, 
		@ProcessDataAccess, 
		@DynamicFieldAccess, 
		@DocumentAccess, 
		@DocumentEditAccess, 
		@DispatchAccess, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessAlarmSelect
GO

CREATE PROCEDURE [OW].ProcessAlarmSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessAlarmID int = NULL,
		@AlarmType tinyint = NULL,
		@FlowID int = NULL,
		@FlowStageID int = NULL,
		@ProcessID int = NULL,
		@ProcessStageID int = NULL,
		@Occurence tinyint = NULL,
		@OccurenceOffset int = NULL,
		@AlarmDatetime datetime = NULL,
		@Message varchar(255) = NULL,
		@AlertByEMail bit = NULL,
		@AddresseeExecutant bit = NULL,
		@AddresseeFlowOwner bit = NULL,
		@AddresseeProcessOwner bit = NULL,
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
		
		SET @sql = @sql + '[ProcessAlarmID] '
		SET @sql = @sql + ',[AlarmType] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[FlowStageID] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[ProcessStageID] '
		SET @sql = @sql + ',[Occurence] '
		SET @sql = @sql + ',[OccurenceOffset] '
		SET @sql = @sql + ',[AlarmDatetime] '
		SET @sql = @sql + ',[Message] '
		SET @sql = @sql + ',[AlertByEMail] '
		SET @sql = @sql + ',[AddresseeExecutant] '
		SET @sql = @sql + ',[AddresseeFlowOwner] '
		SET @sql = @sql + ',[AddresseeProcessOwner] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessAlarm] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessAlarmID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessAlarmID] = @ProcessAlarmID AND '
		IF (@AlarmType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlarmType] = @AlarmType AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@FlowStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageID] = @FlowStageID AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND '
		IF (@ProcessStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageID] = @ProcessStageID AND '
		IF (@Occurence IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Occurence] = @Occurence AND '
		IF (@OccurenceOffset IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OccurenceOffset] = @OccurenceOffset AND '
		IF (@AlarmDatetime IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlarmDatetime] = @AlarmDatetime AND '
		IF (@Message IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Message] LIKE @Message AND '
		IF (@AlertByEMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlertByEMail] = @AlertByEMail AND '
		IF (@AddresseeExecutant IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeExecutant] = @AddresseeExecutant AND '
		IF (@AddresseeFlowOwner IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeFlowOwner] = @AddresseeFlowOwner AND '
		IF (@AddresseeProcessOwner IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeProcessOwner] = @AddresseeProcessOwner AND '
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
		N'@ProcessAlarmID int, 
		@AlarmType tinyint, 
		@FlowID int, 
		@FlowStageID int, 
		@ProcessID int, 
		@ProcessStageID int, 
		@Occurence tinyint, 
		@OccurenceOffset int, 
		@AlarmDatetime datetime, 
		@Message varchar(255), 
		@AlertByEMail bit, 
		@AddresseeExecutant bit, 
		@AddresseeFlowOwner bit, 
		@AddresseeProcessOwner bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessAlarmID, 
		@AlarmType, 
		@FlowID, 
		@FlowStageID, 
		@ProcessID, 
		@ProcessStageID, 
		@Occurence, 
		@OccurenceOffset, 
		@AlarmDatetime, 
		@Message, 
		@AlertByEMail, 
		@AddresseeExecutant, 
		@AddresseeFlowOwner, 
		@AddresseeProcessOwner, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmAddresseeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessAlarmAddresseeSelect
GO

CREATE PROCEDURE [OW].ProcessAlarmAddresseeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessAlarmAddresseeID int = NULL,
		@ProcessAlarmID int = NULL,
		@OrganizationalUnitID int = NULL,
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
		
		SET @sql = @sql + '[ProcessAlarmAddresseeID] '
		SET @sql = @sql + ',[ProcessAlarmID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessAlarmAddressee] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessAlarmAddresseeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessAlarmAddresseeID] = @ProcessAlarmAddresseeID AND '
		IF (@ProcessAlarmID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessAlarmID] = @ProcessAlarmID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
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
		N'@ProcessAlarmAddresseeID int, 
		@ProcessAlarmID int, 
		@OrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessAlarmAddresseeID, 
		@ProcessAlarmID, 
		@OrganizationalUnitID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessCounterSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessCounterSelect
GO

CREATE PROCEDURE [OW].ProcessCounterSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessCounterID int = NULL,
		@Year int = NULL,
		@Acronym varchar(50) = NULL,
		@NextValue int = NULL,
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
		
		SET @sql = @sql + '[ProcessCounterID] '
		SET @sql = @sql + ',[Year] '
		SET @sql = @sql + ',[Acronym] '
		SET @sql = @sql + ',[NextValue] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessCounter] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessCounterID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessCounterID] = @ProcessCounterID AND '
		IF (@Year IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Year] = @Year AND '
		IF (@Acronym IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Acronym] LIKE @Acronym AND '
		IF (@NextValue IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NextValue] = @NextValue AND '
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
		N'@ProcessCounterID int, 
		@Year int, 
		@Acronym varchar(50), 
		@NextValue int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessCounterID, 
		@Year, 
		@Acronym, 
		@NextValue, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessCounterSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessCounterSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessDocumentSelect
GO

CREATE PROCEDURE [OW].ProcessDocumentSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessDocumentID int = NULL,
		@ProcessEventID int = NULL,
		@DocumentVersionID int = NULL,
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
		
		SET @sql = @sql + '[ProcessDocumentID] '
		SET @sql = @sql + ',[ProcessEventID] '
		SET @sql = @sql + ',[DocumentVersionID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessDocument] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessDocumentID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDocumentID] = @ProcessDocumentID AND '
		IF (@ProcessEventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessEventID] = @ProcessEventID AND '
		IF (@DocumentVersionID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentVersionID] = @DocumentVersionID AND '
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
		N'@ProcessDocumentID int, 
		@ProcessEventID int, 
		@DocumentVersionID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessDocumentID, 
		@ProcessEventID, 
		@DocumentVersionID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessDynamicFieldSelect
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessDynamicFieldID int = NULL,
		@DynamicFieldID int = NULL,
		@FlowID int = NULL,
		@ProcessID int = NULL,
		@FieldOrder smallint = NULL,
		@MultiSelection bit = NULL,
		@Required bit = NULL,
		@Lookup bit = NULL,
		@Address varchar(255) = NULL,
		@Method varchar(50) = NULL,
		@Field varchar(50) = NULL,
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
		
		SET @sql = @sql + '[ProcessDynamicFieldID] '
		SET @sql = @sql + ',[DynamicFieldID] '
		SET @sql = @sql + ',[FlowID] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[FieldOrder] '
		SET @sql = @sql + ',[MultiSelection] '
		SET @sql = @sql + ',[Required] '
		SET @sql = @sql + ',[Lookup] '
		SET @sql = @sql + ',[Address] '
		SET @sql = @sql + ',[Method] '
		SET @sql = @sql + ',[Field] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessDynamicField] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessDynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDynamicFieldID] = @ProcessDynamicFieldID AND '
		IF (@DynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DynamicFieldID] = @DynamicFieldID AND '
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowID] = @FlowID AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND [FlowID] IS NULL AND '
		IF (@FieldOrder IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FieldOrder] = @FieldOrder AND '
		IF (@MultiSelection IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MultiSelection] = @MultiSelection AND '
		IF (@Required IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Required] = @Required AND '
		IF (@Lookup IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Lookup] = @Lookup AND '
		IF (@Address IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Address] LIKE @Address AND '
		IF (@Method IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Method] LIKE @Method AND '
		IF (@Field IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Field] LIKE @Field AND '
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
		N'@ProcessDynamicFieldID int, 
		@DynamicFieldID int, 
		@FlowID int, 
		@ProcessID int, 
		@FieldOrder smallint, 
		@MultiSelection bit, 
		@Required bit, 
		@Lookup bit, 
		@Address varchar(255), 
		@Method varchar(50), 
		@Field varchar(50), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessDynamicFieldID, 
		@DynamicFieldID, 
		@FlowID, 
		@ProcessID, 
		@FieldOrder, 
		@MultiSelection, 
		@Required, 
		@Lookup, 
		@Address, 
		@Method, 
		@Field, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldValueSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessDynamicFieldValueSelect
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldValueSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessDynamicFieldValueID int = NULL,
		@ProcessDynamicFieldID int = NULL,
		@AlphaNumericFieldValue varchar(1024) = NULL,
		@NumericFieldValue numeric(18,3) = NULL,
		@DateTimeFieldValue datetime = NULL,
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
		
		SET @sql = @sql + '[ProcessDynamicFieldValueID] '
		SET @sql = @sql + ',[ProcessDynamicFieldID] '
		SET @sql = @sql + ',[AlphaNumericFieldValue] '
		SET @sql = @sql + ',[NumericFieldValue] '
		SET @sql = @sql + ',[DateTimeFieldValue] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessDynamicFieldValue] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessDynamicFieldValueID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDynamicFieldValueID] = @ProcessDynamicFieldValueID AND '
		IF (@ProcessDynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDynamicFieldID] = @ProcessDynamicFieldID AND '
		IF (@AlphaNumericFieldValue IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlphaNumericFieldValue] LIKE @AlphaNumericFieldValue AND '
		IF (@NumericFieldValue IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NumericFieldValue] = @NumericFieldValue AND '
		IF (@DateTimeFieldValue IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DateTimeFieldValue] = @DateTimeFieldValue AND '
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
		N'@ProcessDynamicFieldValueID int, 
		@ProcessDynamicFieldID int, 
		@AlphaNumericFieldValue varchar(1024), 
		@NumericFieldValue numeric(18,3), 
		@DateTimeFieldValue datetime, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessDynamicFieldValueID, 
		@ProcessDynamicFieldID, 
		@AlphaNumericFieldValue, 
		@NumericFieldValue, 
		@DateTimeFieldValue, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessEventSelect
GO

CREATE PROCEDURE [OW].ProcessEventSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessEventID int = NULL,
		@ProcessStageID int = NULL,
		@ProcessID int = NULL,
		@RoutingType tinyint = NULL,
		@ProcessEventStatus tinyint = NULL,
		@PreviousProcessEventID int = NULL,
		@NextProcessEventID int = NULL,
		@CreationDate datetime = NULL,
		@ReadDate datetime = NULL,
		@EstimatedDateToComplete datetime = NULL,
		@OrganizationalUnitID int = NULL,
		@ExecutionDate datetime = NULL,
		@EndDate datetime = NULL,
		@WorkflowActionType tinyint = NULL,
		@WorkflowInfo varchar(1000) = NULL,
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
		
		SET @sql = @sql + '[ProcessEventID] '
		SET @sql = @sql + ',[ProcessStageID] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[RoutingType] '
		SET @sql = @sql + ',[ProcessEventStatus] '
		SET @sql = @sql + ',[PreviousProcessEventID] '
		SET @sql = @sql + ',[NextProcessEventID] '
		SET @sql = @sql + ',[CreationDate] '
		SET @sql = @sql + ',[ReadDate] '
		SET @sql = @sql + ',[EstimatedDateToComplete] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[ExecutionDate] '
		SET @sql = @sql + ',[EndDate] '
		SET @sql = @sql + ',[WorkflowActionType] '
		SET @sql = @sql + ',[WorkflowInfo] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessEvent] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessEventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessEventID] = @ProcessEventID AND '
		IF (@ProcessStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageID] = @ProcessStageID AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND '
		IF (@RoutingType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RoutingType] = @RoutingType AND '
		IF (@ProcessEventStatus IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessEventStatus] = @ProcessEventStatus AND '
		IF (@PreviousProcessEventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[PreviousProcessEventID] = @PreviousProcessEventID AND '
		IF (@NextProcessEventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NextProcessEventID] = @NextProcessEventID AND '
		IF (@CreationDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CreationDate] = @CreationDate AND '
		IF (@ReadDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ReadDate] = @ReadDate AND '
		IF (@EstimatedDateToComplete IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EstimatedDateToComplete] = @EstimatedDateToComplete AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@ExecutionDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ExecutionDate] = @ExecutionDate AND '
		IF (@EndDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EndDate] = @EndDate AND '
		IF (@WorkflowActionType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkflowActionType] = @WorkflowActionType AND '
		IF (@WorkflowInfo IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkflowInfo] LIKE @WorkflowInfo AND '
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
		N'@ProcessEventID int, 
		@ProcessStageID int, 
		@ProcessID int, 
		@RoutingType tinyint, 
		@ProcessEventStatus tinyint, 
		@PreviousProcessEventID int, 
		@NextProcessEventID int, 
		@CreationDate datetime, 
		@ReadDate datetime, 
		@EstimatedDateToComplete datetime, 
		@OrganizationalUnitID int, 
		@ExecutionDate datetime, 
		@EndDate datetime, 
		@WorkflowActionType tinyint, 
		@WorkflowInfo varchar(1000), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessEventID, 
		@ProcessStageID, 
		@ProcessID, 
		@RoutingType, 
		@ProcessEventStatus, 
		@PreviousProcessEventID, 
		@NextProcessEventID, 
		@CreationDate, 
		@ReadDate, 
		@EstimatedDateToComplete, 
		@OrganizationalUnitID, 
		@ExecutionDate, 
		@EndDate, 
		@WorkflowActionType, 
		@WorkflowInfo, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessEventSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventNotificationSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessEventNotificationSelect
GO

CREATE PROCEDURE [OW].ProcessEventNotificationSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessEventNotificationID int = NULL,
		@ProcessEventID int = NULL,
		@UserID int = NULL,
		@NotificationDate datetime = NULL,
		@MessageID varchar(50) = NULL,
		@Status tinyint = NULL,
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
		
		SET @sql = @sql + '[ProcessEventNotificationID] '
		SET @sql = @sql + ',[ProcessEventID] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[NotificationDate] '
		SET @sql = @sql + ',[MessageID] '
		SET @sql = @sql + ',[Status] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessEventNotification] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessEventNotificationID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessEventNotificationID] = @ProcessEventNotificationID AND '
		IF (@ProcessEventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessEventID] = @ProcessEventID AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
		IF (@NotificationDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NotificationDate] = @NotificationDate AND '
		IF (@MessageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MessageID] LIKE @MessageID AND '
		IF (@Status IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Status] = @Status AND '
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
		N'@ProcessEventNotificationID int, 
		@ProcessEventID int, 
		@UserID int, 
		@NotificationDate datetime, 
		@MessageID varchar(50), 
		@Status tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessEventNotificationID, 
		@ProcessEventID, 
		@UserID, 
		@NotificationDate, 
		@MessageID, 
		@Status, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventNotificationSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessEventNotificationSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessPrioritySelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessPrioritySelect
GO

CREATE PROCEDURE [OW].ProcessPrioritySelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessPriorityID int = NULL,
		@Description varchar(255) = NULL,
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
		
		SET @sql = @sql + '[ProcessPriorityID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessPriority] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessPriorityID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessPriorityID] = @ProcessPriorityID AND '
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
		N'@ProcessPriorityID int, 
		@Description varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessPriorityID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessPrioritySelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessPrioritySelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessReferenceSelect
GO

CREATE PROCEDURE [OW].ProcessReferenceSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessReferenceID int = NULL,
		@ProcessEventID int = NULL,
		@ProcessReferedID int = NULL,
		@ProcessReferenceType tinyint = NULL,
		@ShareData bit = NULL,
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
		
		SET @sql = @sql + '[ProcessReferenceID] '
		SET @sql = @sql + ',[ProcessEventID] '
		SET @sql = @sql + ',[ProcessReferedID] '
		SET @sql = @sql + ',[ProcessReferenceType] '
		SET @sql = @sql + ',[ShareData] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessReference] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessReferenceID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessReferenceID] = @ProcessReferenceID AND '
		IF (@ProcessEventID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessEventID] = @ProcessEventID AND '
		IF (@ProcessReferedID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessReferedID] = @ProcessReferedID AND '
		IF (@ProcessReferenceType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessReferenceType] = @ProcessReferenceType AND '
		IF (@ShareData IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ShareData] = @ShareData AND '
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
		N'@ProcessReferenceID int, 
		@ProcessEventID int, 
		@ProcessReferedID int, 
		@ProcessReferenceType tinyint, 
		@ShareData bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessReferenceID, 
		@ProcessEventID, 
		@ProcessReferedID, 
		@ProcessReferenceType, 
		@ShareData, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessStageSelect
GO

CREATE PROCEDURE [OW].ProcessStageSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessStageID int = NULL,
		@ProcessID int = NULL,
		@Number smallint = NULL,
		@Description varchar(50) = NULL,
		@Duration int = NULL,
		@Address varchar(255) = NULL,
		@Method varchar(50) = NULL,
		@FlowStageType smallint = NULL,
		@DocumentTemplateID int = NULL,
		@OrganizationalUnitID int = NULL,
		@CanAssociateProcess bit = NULL,
		@Transfer tinyint = NULL,
		@RequestForComments tinyint = NULL,
		@AttachmentRequired bit = NULL,
		@EditDocuments tinyint = NULL,
		@HelpAddress varchar(255) = NULL,
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
		
		SET @sql = @sql + '[ProcessStageID] '
		SET @sql = @sql + ',[ProcessID] '
		SET @sql = @sql + ',[Number] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Duration] '
		SET @sql = @sql + ',[Address] '
		SET @sql = @sql + ',[Method] '
		SET @sql = @sql + ',[FlowStageType] '
		SET @sql = @sql + ',[DocumentTemplateID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[CanAssociateProcess] '
		SET @sql = @sql + ',[Transfer] '
		SET @sql = @sql + ',[RequestForComments] '
		SET @sql = @sql + ',[AttachmentRequired] '
		SET @sql = @sql + ',[EditDocuments] '
		SET @sql = @sql + ',[HelpAddress] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessStage] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageID] = @ProcessStageID AND '
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessID] = @ProcessID AND '
		IF (@Number IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Number] = @Number AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Duration IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Duration] = @Duration AND '
		IF (@Address IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Address] LIKE @Address AND '
		IF (@Method IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Method] LIKE @Method AND '
		IF (@FlowStageType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageType] = @FlowStageType AND '
		IF (@DocumentTemplateID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentTemplateID] = @DocumentTemplateID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@CanAssociateProcess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CanAssociateProcess] = @CanAssociateProcess AND '
		IF (@Transfer IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Transfer] = @Transfer AND '
		IF (@RequestForComments IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestForComments] = @RequestForComments AND '
		IF (@AttachmentRequired IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AttachmentRequired] = @AttachmentRequired AND '
		IF (@EditDocuments IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EditDocuments] = @EditDocuments AND '
		IF (@HelpAddress IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[HelpAddress] LIKE @HelpAddress AND '
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
		N'@ProcessStageID int, 
		@ProcessID int, 
		@Number smallint, 
		@Description varchar(50), 
		@Duration int, 
		@Address varchar(255), 
		@Method varchar(50), 
		@FlowStageType smallint, 
		@DocumentTemplateID int, 
		@OrganizationalUnitID int, 
		@CanAssociateProcess bit, 
		@Transfer tinyint, 
		@RequestForComments tinyint, 
		@AttachmentRequired bit, 
		@EditDocuments tinyint, 
		@HelpAddress varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessStageID, 
		@ProcessID, 
		@Number, 
		@Description, 
		@Duration, 
		@Address, 
		@Method, 
		@FlowStageType, 
		@DocumentTemplateID, 
		@OrganizationalUnitID, 
		@CanAssociateProcess, 
		@Transfer, 
		@RequestForComments, 
		@AttachmentRequired, 
		@EditDocuments, 
		@HelpAddress, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessStageSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessStageAccessSelect
GO

CREATE PROCEDURE [OW].ProcessStageAccessSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessStageAccessID int = NULL,
		@FlowStageID int = NULL,
		@ProcessStageID int = NULL,
		@OrganizationalUnitID int = NULL,
		@AccessObject tinyint = NULL,
		@DocumentAccess tinyint = NULL,
		@DispatchAccess tinyint = NULL,
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
		
		SET @sql = @sql + '[ProcessStageAccessID] '
		SET @sql = @sql + ',[FlowStageID] '
		SET @sql = @sql + ',[ProcessStageID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[AccessObject] '
		SET @sql = @sql + ',[DocumentAccess] '
		SET @sql = @sql + ',[DispatchAccess] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessStageAccess] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessStageAccessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageAccessID] = @ProcessStageAccessID AND '
		IF (@FlowStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageID] = @FlowStageID AND '
		IF (@ProcessStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageID] = @ProcessStageID AND [FlowStageID] IS NULL AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@AccessObject IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AccessObject] = @AccessObject AND '
		IF (@DocumentAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DocumentAccess] = @DocumentAccess AND '
		IF (@DispatchAccess IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DispatchAccess] = @DispatchAccess AND '
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
		N'@ProcessStageAccessID int, 
		@FlowStageID int, 
		@ProcessStageID int, 
		@OrganizationalUnitID int, 
		@AccessObject tinyint, 
		@DocumentAccess tinyint, 
		@DispatchAccess tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessStageAccessID, 
		@FlowStageID, 
		@ProcessStageID, 
		@OrganizationalUnitID, 
		@AccessObject, 
		@DocumentAccess, 
		@DispatchAccess, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDynamicFieldSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ProcessStageDynamicFieldSelect
GO

CREATE PROCEDURE [OW].ProcessStageDynamicFieldSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ProcessStageDynamicFieldID int = NULL,
		@ProcessDynamicFieldID int = NULL,
		@ProcessStageID int = NULL,
		@FlowStageID int = NULL,
		@Behavior tinyint = NULL,
		@CampoParaInteraccaoWS smallint = NULL,
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
		
		SET @sql = @sql + '[ProcessStageDynamicFieldID] '
		SET @sql = @sql + ',[ProcessDynamicFieldID] '
		SET @sql = @sql + ',[ProcessStageID] '
		SET @sql = @sql + ',[FlowStageID] '
		SET @sql = @sql + ',[Behavior] '
		SET @sql = @sql + ',[CampoParaInteraccaoWS] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessStageDynamicField] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessStageDynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageDynamicFieldID] = @ProcessStageDynamicFieldID AND '
		IF (@ProcessDynamicFieldID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessDynamicFieldID] = @ProcessDynamicFieldID AND '
		IF (@ProcessStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProcessStageID] = @ProcessStageID AND '
		IF (@FlowStageID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FlowStageID] = @FlowStageID AND [ProcessStageID] IS NULL AND '
		IF (@Behavior IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Behavior] = @Behavior AND '
		IF (@CampoParaInteraccaoWS IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[CampoParaInteraccaoWS] = @CampoParaInteraccaoWS AND '
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
		N'@ProcessStageDynamicFieldID int, 
		@ProcessDynamicFieldID int, 
		@ProcessStageID int, 
		@FlowStageID int, 
		@Behavior tinyint, 
		@CampoParaInteraccaoWS smallint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessStageDynamicFieldID, 
		@ProcessDynamicFieldID, 
		@ProcessStageID, 
		@FlowStageID, 
		@Behavior, 
		@CampoParaInteraccaoWS, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].RegistrySelect
GO

CREATE PROCEDURE [OW].RegistrySelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[regid] '
		SET @sql = @sql + ',[doctypeid] '
		SET @sql = @sql + ',[bookid] '
		SET @sql = @sql + ',[year] '
		SET @sql = @sql + ',[number] '
		SET @sql = @sql + ',[date] '
		SET @sql = @sql + ',[originref] '
		SET @sql = @sql + ',[origindate] '
		SET @sql = @sql + ',[subject] '
		SET @sql = @sql + ',[observations] '
		SET @sql = @sql + ',[processnumber] '
		SET @sql = @sql + ',[cota] '
		SET @sql = @sql + ',[bloco] '
		SET @sql = @sql + ',[classid] '
		SET @sql = @sql + ',[userID] '
		SET @sql = @sql + ',[AntecedenteID] '
		SET @sql = @sql + ',[entID] '
		SET @sql = @sql + ',[UserModifyID] '
		SET @sql = @sql + ',[DateModify] '
		SET @sql = @sql + ',[historic] '
		SET @sql = @sql + ',[field1] '
		SET @sql = @sql + ',[field2] '
		SET @sql = @sql + ',[activeDate] '
		SET @sql = @sql + ',[IdIdentityCB] '
		SET @sql = @sql + ',[Barcode] '
		SET @sql = @sql + ',[ProdEntityID] '
		SET @sql = @sql + ',[FundoID] '
		SET @sql = @sql + ',[SerieID] '
		SET @sql = @sql + ',[FisicalID] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblRegistry] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@regid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[regid] = @regid AND '
		IF (@doctypeid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[doctypeid] = @doctypeid AND '
		IF (@bookid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[bookid] = @bookid AND '
		IF (@year IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[year] = @year AND '
		IF (@number IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[number] = @number AND '
		IF (@date IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[date] = @date AND '
		IF (@originref IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[originref] LIKE @originref AND '
		IF (@origindate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[origindate] = @origindate AND '
		IF (@subject IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[subject] LIKE @subject AND '
		IF (@observations IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[observations] LIKE @observations AND '
		IF (@processnumber IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[processnumber] LIKE @processnumber AND '
		IF (@cota IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[cota] LIKE @cota AND '
		IF (@bloco IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[bloco] LIKE @bloco AND '
		IF (@classid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[classid] = @classid AND '
		IF (@userID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userID] = @userID AND '
		IF (@AntecedenteID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AntecedenteID] = @AntecedenteID AND '
		IF (@entID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[entID] = @entID AND '
		IF (@UserModifyID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserModifyID] = @UserModifyID AND '
		IF (@DateModify IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DateModify] = @DateModify AND '
		IF (@historic IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[historic] = @historic AND '
		IF (@field1 IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[field1] = @field1 AND '
		IF (@field2 IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[field2] LIKE @field2 AND '
		IF (@activeDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[activeDate] = @activeDate AND '
		IF (@IdIdentityCB IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdIdentityCB] = @IdIdentityCB AND '
		IF (@Barcode IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Barcode] = @Barcode AND '
		IF (@ProdEntityID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProdEntityID] = @ProdEntityID AND '
		IF (@FundoID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FundoID] = @FundoID AND '
		IF (@SerieID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[SerieID] = @SerieID AND '
		IF (@FisicalID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FisicalID] = @FisicalID AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].RegistrySelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDistributionSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].RegistryDistributionSelect
GO

CREATE PROCEDURE [OW].RegistryDistributionSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[ID] '
		SET @sql = @sql + ',[RegID] '
		SET @sql = @sql + ',[userID] '
		SET @sql = @sql + ',[DistribDate] '
		SET @sql = @sql + ',[DistribObs] '
		SET @sql = @sql + ',[Tipo] '
		SET @sql = @sql + ',[radioVia] '
		SET @sql = @sql + ',[chkFile] '
		SET @sql = @sql + ',[DistribTypeID] '
		SET @sql = @sql + ',[txtEntidadeID] '
		SET @sql = @sql + ',[state] '
		SET @sql = @sql + ',[ConnectID] '
		SET @sql = @sql + ',[dispatch] '
		SET @sql = @sql + ',[AddresseeType] '
		SET @sql = @sql + ',[AddresseeID] '
		SET @sql = @sql + ',[AutoDistrib] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblRegistryDistribution] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ID] = @ID AND '
		IF (@RegID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RegID] = @RegID AND '
		IF (@userID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userID] = @userID AND '
		IF (@DistribDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DistribDate] = @DistribDate AND '
		IF (@DistribObs IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DistribObs] LIKE @DistribObs AND '
		IF (@Tipo IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Tipo] = @Tipo AND '
		IF (@radioVia IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[radioVia] LIKE @radioVia AND '
		IF (@chkFile IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[chkFile] = @chkFile AND '
		IF (@DistribTypeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DistribTypeID] = @DistribTypeID AND '
		IF (@txtEntidadeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[txtEntidadeID] = @txtEntidadeID AND '
		IF (@state IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[state] = @state AND '
		IF (@ConnectID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ConnectID] = @ConnectID AND '
		IF (@dispatch IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[dispatch] = @dispatch AND '
		IF (@AddresseeType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeType] = @AddresseeType AND '
		IF (@AddresseeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeID] = @AddresseeID AND '
		IF (@AutoDistrib IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AutoDistrib] = @AutoDistrib AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@ID numeric(18,0), 
		@RegID numeric(18,0), 
		@userID int, 
		@DistribDate datetime, 
		@DistribObs nvarchar(250), 
		@Tipo numeric(18,0), 
		@radioVia varchar(20), 
		@chkFile bit, 
		@DistribTypeID numeric(18,0), 
		@txtEntidadeID numeric(18,0), 
		@state tinyint, 
		@ConnectID numeric(18,0), 
		@dispatch numeric(18,0), 
		@AddresseeType char(1), 
		@AddresseeID numeric(18,0), 
		@AutoDistrib bit',
		@ID, 
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
		
		
		SET @Err = @@Error
		RETURN @Err
	END
	GO
	
	-- Display the status of Proc creation
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDistributionSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].RegistryDistributionSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryHistSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].RegistryHistSelect
GO

CREATE PROCEDURE [OW].RegistryHistSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
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
		DECLARE @sql NVARCHAR(4000)		
		DECLARE @sql_WHERE NVARCHAR(4000)
		
		

		-- SELECT -----------------------------
		SET @sql = 'SELECT '
		
		-- FIELDS ENUM ------------------------
		
		SET @sql = @sql + '[regid] '
		SET @sql = @sql + ',[doctypeid] '
		SET @sql = @sql + ',[bookid] '
		SET @sql = @sql + ',[year] '
		SET @sql = @sql + ',[number] '
		SET @sql = @sql + ',[date] '
		SET @sql = @sql + ',[originref] '
		SET @sql = @sql + ',[origindate] '
		SET @sql = @sql + ',[subject] '
		SET @sql = @sql + ',[observations] '
		SET @sql = @sql + ',[processnumber] '
		SET @sql = @sql + ',[cota] '
		SET @sql = @sql + ',[bloco] '
		SET @sql = @sql + ',[classid] '
		SET @sql = @sql + ',[userID] '
		SET @sql = @sql + ',[AntecedenteID] '
		SET @sql = @sql + ',[entID] '
		SET @sql = @sql + ',[UserModifyID] '
		SET @sql = @sql + ',[DateModify] '
		SET @sql = @sql + ',[historic] '
		SET @sql = @sql + ',[field1] '
		SET @sql = @sql + ',[field2] '
		SET @sql = @sql + ',[activeDate] '
		SET @sql = @sql + ',[IdIdentityCB] '
		SET @sql = @sql + ',[Barcode] '
		SET @sql = @sql + ',[ProdEntityID] '
		SET @sql = @sql + ',[FundoID] '
		SET @sql = @sql + ',[SerieID] '
		SET @sql = @sql + ',[FisicalID] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblRegistryHist] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@regid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[regid] = @regid AND '
		IF (@doctypeid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[doctypeid] = @doctypeid AND '
		IF (@bookid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[bookid] = @bookid AND '
		IF (@year IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[year] = @year AND '
		IF (@number IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[number] = @number AND '
		IF (@date IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[date] = @date AND '
		IF (@originref IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[originref] LIKE @originref AND '
		IF (@origindate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[origindate] = @origindate AND '
		IF (@subject IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[subject] LIKE @subject AND '
		IF (@observations IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[observations] LIKE @observations AND '
		IF (@processnumber IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[processnumber] LIKE @processnumber AND '
		IF (@cota IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[cota] LIKE @cota AND '
		IF (@bloco IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[bloco] LIKE @bloco AND '
		IF (@classid IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[classid] = @classid AND '
		IF (@userID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userID] = @userID AND '
		IF (@AntecedenteID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AntecedenteID] = @AntecedenteID AND '
		IF (@entID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[entID] = @entID AND '
		IF (@UserModifyID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserModifyID] = @UserModifyID AND '
		IF (@DateModify IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[DateModify] = @DateModify AND '
		IF (@historic IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[historic] = @historic AND '
		IF (@field1 IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[field1] = @field1 AND '
		IF (@field2 IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[field2] LIKE @field2 AND '
		IF (@activeDate IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[activeDate] = @activeDate AND '
		IF (@IdIdentityCB IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[IdIdentityCB] = @IdIdentityCB AND '
		IF (@Barcode IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Barcode] = @Barcode AND '
		IF (@ProdEntityID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ProdEntityID] = @ProdEntityID AND '
		IF (@FundoID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FundoID] = @FundoID AND '
		IF (@SerieID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[SerieID] = @SerieID AND '
		IF (@FisicalID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FisicalID] = @FisicalID AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryHistSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].RegistryHistSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RequestAlarmSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].RequestAlarmSelect
GO

CREATE PROCEDURE [OW].RequestAlarmSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@RequestAlarmID int = NULL,
		@RequestID numeric(18,0) = NULL,
		@Occurence tinyint = NULL,
		@OccurenceOffset int = NULL,
		@Message varchar(255) = NULL,
		@AlertByEMail bit = NULL,
		@AddresseeRequestOwner bit = NULL,
		@AddresseeLastModifyUser bit = NULL,
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
		
		SET @sql = @sql + '[RequestAlarmID] '
		SET @sql = @sql + ',[RequestID] '
		SET @sql = @sql + ',[Occurence] '
		SET @sql = @sql + ',[OccurenceOffset] '
		SET @sql = @sql + ',[Message] '
		SET @sql = @sql + ',[AlertByEMail] '
		SET @sql = @sql + ',[AddresseeRequestOwner] '
		SET @sql = @sql + ',[AddresseeLastModifyUser] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblRequestAlarm] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@RequestAlarmID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestAlarmID] = @RequestAlarmID AND '
		IF (@RequestID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestID] = @RequestID AND '
		IF (@Occurence IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Occurence] = @Occurence AND '
		IF (@OccurenceOffset IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OccurenceOffset] = @OccurenceOffset AND '
		IF (@Message IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Message] LIKE @Message AND '
		IF (@AlertByEMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AlertByEMail] = @AlertByEMail AND '
		IF (@AddresseeRequestOwner IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeRequestOwner] = @AddresseeRequestOwner AND '
		IF (@AddresseeLastModifyUser IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AddresseeLastModifyUser] = @AddresseeLastModifyUser AND '
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
		N'@RequestAlarmID int, 
		@RequestID numeric(18,0), 
		@Occurence tinyint, 
		@OccurenceOffset int, 
		@Message varchar(255), 
		@AlertByEMail bit, 
		@AddresseeRequestOwner bit, 
		@AddresseeLastModifyUser bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@RequestAlarmID, 
		@RequestID, 
		@Occurence, 
		@OccurenceOffset, 
		@Message, 
		@AlertByEMail, 
		@AddresseeRequestOwner, 
		@AddresseeLastModifyUser, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RequestAlarmSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].RequestAlarmSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RequestAlarmAddresseeSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].RequestAlarmAddresseeSelect
GO

CREATE PROCEDURE [OW].RequestAlarmAddresseeSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@RequestAlarmAddresseeID int = NULL,
		@RequestAlarmID int = NULL,
		@OrganizationalUnitID int = NULL,
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
		
		SET @sql = @sql + '[RequestAlarmAddresseeID] '
		SET @sql = @sql + ',[RequestAlarmID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblRequestAlarmAddressee] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@RequestAlarmAddresseeID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestAlarmAddresseeID] = @RequestAlarmAddresseeID AND '
		IF (@RequestAlarmID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[RequestAlarmID] = @RequestAlarmID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
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
		N'@RequestAlarmAddresseeID int, 
		@RequestAlarmID int, 
		@OrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@RequestAlarmAddresseeID, 
		@RequestAlarmID, 
		@OrganizationalUnitID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RequestAlarmAddresseeSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].RequestAlarmAddresseeSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ResourceSelect
GO

CREATE PROCEDURE [OW].ResourceSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ResourceID int = NULL,
		@ModuleID int = NULL,
		@Description varchar(80) = NULL,
		@Active smallint = NULL,
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
		
		SET @sql = @sql + '[ResourceID] '
		SET @sql = @sql + ',[ModuleID] '
		SET @sql = @sql + ',[Description] '
		SET @sql = @sql + ',[Active] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblResource] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ResourceID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ResourceID] = @ResourceID AND '
		IF (@ModuleID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ModuleID] = @ModuleID AND '
		IF (@Description IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
		IF (@Active IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Active] = @Active AND '
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
		N'@ResourceID int, 
		@ModuleID int, 
		@Description varchar(80), 
		@Active smallint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ResourceID, 
		@ModuleID, 
		@Description, 
		@Active, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ResourceSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].ResourceAccessSelect
GO

CREATE PROCEDURE [OW].ResourceAccessSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@ResourceAccessID int = NULL,
		@OrganizationalUnitID int = NULL,
		@ResourceID int = NULL,
		@AccessType tinyint = NULL,
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
		
		SET @sql = @sql + '[ResourceAccessID] '
		SET @sql = @sql + ',[OrganizationalUnitID] '
		SET @sql = @sql + ',[ResourceID] '
		SET @sql = @sql + ',[AccessType] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblResourceAccess] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ResourceAccessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ResourceAccessID] = @ResourceAccessID AND '
		IF (@OrganizationalUnitID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[OrganizationalUnitID] = @OrganizationalUnitID AND '
		IF (@ResourceID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ResourceID] = @ResourceID AND '
		IF (@AccessType IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[AccessType] = @AccessType AND '
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
		N'@ResourceAccessID int, 
		@OrganizationalUnitID int, 
		@ResourceID int, 
		@AccessType tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ResourceAccessID, 
		@OrganizationalUnitID, 
		@ResourceID, 
		@AccessType, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].ResourceAccessSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].UserSelect
GO

CREATE PROCEDURE [OW].UserSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@userID int = NULL,
		@userLogin varchar(50) = NULL,
		@userDesc varchar(50) = NULL,
		@userMail varchar(50) = NULL,
		@userActive bit = NULL,
		@TextSignature varchar(300) = NULL,
		@PrimaryGroupID int = NULL,
		@Phone varchar(25) = NULL,
		@MobilePhone varchar(25) = NULL,
		@Fax varchar(25) = NULL,
		@NotifyByMail bit = NULL,
		@NotifyBySMS bit = NULL,
		@Password varchar(50) = NULL,
		@EntityID numeric(18,0) = NULL,
		@GroupHead bit = NULL,
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
		
		SET @sql = @sql + '[userID] '
		SET @sql = @sql + ',[userLogin] '
		SET @sql = @sql + ',[userDesc] '
		SET @sql = @sql + ',[userMail] '
		SET @sql = @sql + ',[userActive] '
		SET @sql = @sql + ',[TextSignature] '
		SET @sql = @sql + ',[PrimaryGroupID] '
		SET @sql = @sql + ',[Phone] '
		SET @sql = @sql + ',[MobilePhone] '
		SET @sql = @sql + ',[Fax] '
		SET @sql = @sql + ',[NotifyByMail] '
		SET @sql = @sql + ',[NotifyBySMS] '
		SET @sql = @sql + ',[Password] '
		SET @sql = @sql + ',[EntityID] '
		SET @sql = @sql + ',[GroupHead] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblUser] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@userID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userID] = @userID AND '
		IF (@userLogin IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userLogin] LIKE @userLogin AND '
		IF (@userDesc IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userDesc] LIKE @userDesc AND '
		IF (@userMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userMail] LIKE @userMail AND '
		IF (@userActive IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[userActive] = @userActive AND '
		IF (@TextSignature IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[TextSignature] LIKE @TextSignature AND '
		IF (@PrimaryGroupID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[PrimaryGroupID] = @PrimaryGroupID AND '
		IF (@Phone IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Phone] LIKE @Phone AND '
		IF (@MobilePhone IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[MobilePhone] LIKE @MobilePhone AND '
		IF (@Fax IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Fax] LIKE @Fax AND '
		IF (@NotifyByMail IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NotifyByMail] = @NotifyByMail AND '
		IF (@NotifyBySMS IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[NotifyBySMS] = @NotifyBySMS AND '
		IF (@Password IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[Password] LIKE @Password AND '
		IF (@EntityID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[EntityID] = @EntityID AND '
		IF (@GroupHead IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[GroupHead] = @GroupHead AND '
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
		N'@userID int, 
		@userLogin varchar(50), 
		@userDesc varchar(50), 
		@userMail varchar(50), 
		@userActive bit, 
		@TextSignature varchar(300), 
		@PrimaryGroupID int, 
		@Phone varchar(25), 
		@MobilePhone varchar(25), 
		@Fax varchar(25), 
		@NotifyByMail bit, 
		@NotifyBySMS bit, 
		@Password varchar(50), 
		@EntityID numeric(18,0), 
		@GroupHead bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@userID, 
		@userLogin, 
		@userDesc, 
		@userMail, 
		@userActive, 
		@TextSignature, 
		@PrimaryGroupID, 
		@Phone, 
		@MobilePhone, 
		@Fax, 
		@NotifyByMail, 
		@NotifyBySMS, 
		@Password, 
		@EntityID, 
		@GroupHead, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].UserSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].UserSignatureSelect
GO

CREATE PROCEDURE [OW].UserSignatureSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@UserSignatureID int = NULL,
		@UserID int = NULL,
		@SignatureFilename varchar(250) = NULL,
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
		
		SET @sql = @sql + '[UserSignatureID] '
		SET @sql = @sql + ',[UserID] '
		SET @sql = @sql + ',[Signature] '
		SET @sql = @sql + ',[SignatureFilename] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblUserSignature] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@UserSignatureID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserSignatureID] = @UserSignatureID AND '
		IF (@UserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserID] = @UserID AND '
		IF (@SignatureFilename IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[SignatureFilename] LIKE @SignatureFilename AND '
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
		N'@UserSignatureID int, 
		@UserID int, 
		@SignatureFilename varchar(250), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@UserSignatureID, 
		@UserID, 
		@SignatureFilename, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].UserSignatureSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureAccessSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].UserSignatureAccessSelect
GO

CREATE PROCEDURE [OW].UserSignatureAccessSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@UserSignatureAccessID int = NULL,
		@FromUserID int = NULL,
		@ToUserID int = NULL,
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
		
		SET @sql = @sql + '[UserSignatureAccessID] '
		SET @sql = @sql + ',[FromUserID] '
		SET @sql = @sql + ',[ToUserID] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblUserSignatureAccess] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@UserSignatureAccessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[UserSignatureAccessID] = @UserSignatureAccessID AND '
		IF (@FromUserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FromUserID] = @FromUserID AND '
		IF (@ToUserID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[ToUserID] = @ToUserID AND '
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
		N'@UserSignatureAccessID int, 
		@FromUserID int, 
		@ToUserID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@UserSignatureAccessID, 
		@FromUserID, 
		@ToUserID, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureAccessSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].UserSignatureAccessSelect Error on Creation'
	GO
	
	
	
	IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodSelect') AND sysstat & 0xf = 4)
		DROP PROCEDURE [OW].WorkingPeriodSelect
GO

CREATE PROCEDURE [OW].WorkingPeriodSelect
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.4	
		------------------------------------------------------------------------
		
		@WorkingPeriodID int = NULL,
		@WeekDay int = NULL,
		@StartHour int = NULL,
		@StartMinute int = NULL,
		@FinishHour int = NULL,
		@FinishMinute int = NULL,
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
		
		SET @sql = @sql + '[WorkingPeriodID] '
		SET @sql = @sql + ',[WeekDay] '
		SET @sql = @sql + ',[StartHour] '
		SET @sql = @sql + ',[StartMinute] '
		SET @sql = @sql + ',[FinishHour] '
		SET @sql = @sql + ',[FinishMinute] '
		SET @sql = @sql + ',[Remarks] '
		SET @sql = @sql + ',[InsertedBy] '
		SET @sql = @sql + ',[InsertedOn] '
		SET @sql = @sql + ',[LastModifiedBy] '
		SET @sql = @sql + ',[LastModifiedOn] '
	
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblWorkingPeriod] '
		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@WorkingPeriodID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WorkingPeriodID] = @WorkingPeriodID AND '
		IF (@WeekDay IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[WeekDay] = @WeekDay AND '
		IF (@StartHour IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[StartHour] = @StartHour AND '
		IF (@StartMinute IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[StartMinute] = @StartMinute AND '
		IF (@FinishHour IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FinishHour] = @FinishHour AND '
		IF (@FinishMinute IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + '[FinishMinute] = @FinishMinute AND '
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
		N'@WorkingPeriodID int, 
		@WeekDay int, 
		@StartHour int, 
		@StartMinute int, 
		@FinishHour int, 
		@FinishMinute int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@WorkingPeriodID, 
		@WeekDay, 
		@StartHour, 
		@StartMinute, 
		@FinishHour, 
		@FinishMinute, 
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
	IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodSelect Succeeded'
	ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodSelect Error on Creation'
	GO
	
	
	
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Procedimentos Extendidos
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO


/*
Script created by SQL Compare from Red Gate Software Ltd at 03-07-2008 12:09:20
Run this script on cygnus.HESE to make it the same as cygnus.HESE
Please back up your database before running this script
*/
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

PRINT N'Creating [OW].[ProcessStageSelectEx01]'
GO

CREATE PROCEDURE [OW].ProcessStageSelectEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Version: 1.4	
	------------------------------------------------------------------------
	
	@ProcessID int = NULL
	
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
	
	SET @sql = @sql + 'ps.[ProcessStageID] '
	SET @sql = @sql + ',ps.[ProcessID] '
	SET @sql = @sql + ',ps.[Number] '
	SET @sql = @sql + ',ps.[Description] '
	SET @sql = @sql + ',ps.[Duration] '
	SET @sql = @sql + ',ps.[Address] '
	SET @sql = @sql + ',ps.[Method] '
	SET @sql = @sql + ',ps.[FlowStageType] '
	SET @sql = @sql + ',ps.[DocumentTemplateID] '
	SET @sql = @sql + ',ps.[OrganizationalUnitID] '
	SET @sql = @sql + ',ps.[CanAssociateProcess] '
	SET @sql = @sql + ',ps.[Transfer] '
	SET @sql = @sql + ',ps.[RequestForComments] '
	SET @sql = @sql + ',ps.[AttachmentRequired] '
	SET @sql = @sql + ',ps.[EditDocuments] '
	SET @sql = @sql + ',ps.[HelpAddress] '
	SET @sql = @sql + ',ps.[Remarks] '
	SET @sql = @sql + ',ps.[InsertedBy] '
	SET @sql = @sql + ',ps.[InsertedOn] '
	SET @sql = @sql + ',ps.[LastModifiedBy] '
	SET @sql = @sql + ',ps.[LastModifiedOn] '
	SET @sql = @sql + ',case when ou.UserID is not null then u.UserDesc else g.GroupDesc end AS OrganizationalUnitDescription '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM  OW.tblProcessStage ps INNER JOIN '
        	SET @sql = @sql + 'OW.tblOrganizationalUnit ou ON ou.OrganizationalUnitID = ps.OrganizationalUnitID LEFT OUTER JOIN '
	SET @sql = @sql + 'OW.tblGroups g ON g.GroupID = ou.GroupID LEFT OUTER JOIN '
        	SET @sql = @sql + 'OW.tblUser u ON u.UserID = ou.UserID '

	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@ProcessID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'ps.[ProcessID] = @ProcessID AND '
	
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@ProcessID int',
	@ProcessID
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageSelectEx01 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Altering [OW].[AlertSelectEx01]'
GO

ALTER   PROCEDURE [OW].AlertSelectEx01
(
	------------------------------------------------------------------------
	--Devolve a lista de alertas de um utilizador para o Centro de Controlo
	--NOTA: Nao usar este select para instanciar um objecto Business Alert,
	--este select nao possui todas as colunas necessarias!!!
	--Updated: 22-03-2007 19:00:00
	--Version: 1.1	
	------------------------------------------------------------------------	
	@UserID int = NULL,
	@Read tinyint = NULL,
	@NotRead tinyint = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	
	SELECT 
		AL.AlertID, 
		AL.AlertType,		
		CASE WHEN AL.AlertType = 1 THEN
			CASE WHEN AL.ProcessID IS NULL THEN PRS.ProcessNumber ELSE PR.ProcessNumber END
		ELSE
			NULL
		END ProcessNumber,
		CASE WHEN AL.AlertType = 1 THEN
			CASE WHEN AL.ProcessID IS NULL THEN PRS.ProcessSubject ELSE PR.ProcessSubject END
		ELSE
			NULL
		END ProcessSubject,
		CASE WHEN AL.AlertType = 2 THEN 
			CAST(RQ.Year AS VARCHAR(4)) + '/' + CAST(RQ.Number AS VARCHAR(10))
		ELSE
			NULL
		END RequestNumber,
		CASE WHEN AL.AlertType = 4 THEN
			EM.Description
		ELSE
			NULL
		END ExceptionDescription,
		Al.SendDateTime,
		AL.ReadDateTime
	FROM 
		OW.tblalert AL 
		LEFT OUTER JOIN OW.tblprocess PR ON (AL.ProcessID = PR.ProcessID)
		LEFT OUTER JOIN OW.tblprocessstage PS ON (AL.ProcessStageID = PS.ProcessStageID)
		LEFT OUTER JOIN OW.tblprocess PRS ON (PS.ProcessID = PRS.ProcessID)
		LEFT OUTER JOIN OW.tblrequest RQ ON (AL.RequestID = RQ.RequestID)
		LEFT OUTER JOIN OW.tblexceptionmanagement EM ON (AL.ExceptionID = EM.ExceptionID)
	WHERE		

		(AL.UserID = @UserID) AND
		(@Read IS NULL OR AL.ReadDateTime IS NOT NULL) AND
		(@NotRead IS NULL OR AL.ReadDateTime IS NULL)

	SET @Err = @@Error
	RETURN @Err
END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertSelectEx01 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ResourceAccessSelectEx01]'
GO


ALTER    PROCEDURE [OW].ResourceAccessSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 20-03-2006 18:11:13
	--Version: 1.2	
	------------------------------------------------------------------------
	@OrganizationalUnitIDs varchar(4000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		ra1.[ResourceAccessID],
		ra1.[OrganizationalUnitID],
		ra1.[ResourceID],
		ra1.[AccessType],
		ra1.[Remarks],
		ra1.[InsertedBy],
		ra1.[InsertedOn],
		ra1.[LastModifiedBy],
		ra1.[LastModifiedOn]
	FROM [OW].[tblResourceAccess] ra1
	INNER JOIN [OW].[tblResource] r1 ON ra1.[ResourceID] = r1.[ResourceID]
	INNER JOIN [OW].[tblModule] m1 ON r1.[ModuleID] = m1.[ModuleID]
	INNER JOIN (SELECT stt.[Item] FROM OW.StringToTable(@OrganizationalUnitIDs,',') stt) taux1 ON ra1.[OrganizationalUnitID] = taux1.[Item] 
	WHERE
	(
		ra1.[AccessType] = 2 OR
		(ra1.[AccessType] = 4 AND
		 	NOT EXISTS (SELECT 1 
			FROM [OW].[tblResourceAccess] ra2
			INNER JOIN (SELECT stt.[Item] FROM OW.StringToTable(@OrganizationalUnitIDs,',') stt) taux2 ON ra2.[OrganizationalUnitID] = taux2.[Item] 
			WHERE  ra1.[ResourceID] = ra2.[ResourceID] AND ra2.[AccessType] = 2
			)
		)
	)
	AND r1.[Active] = 1 AND m1.[Active] = 1

	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Altering [OW].[AlarmQueueSelectEx01]'
GO

ALTER   PROCEDURE [OW].AlarmQueueSelectEx01
(
	------------------------------------------------------------------------	
	--Updated: 15-02-2006 19:03:48
	--Version: 1.2	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL,
	@LaunchDateTime datetime = NULL,
	@ProcessAlarmID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
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
		
	SET @sql = @sql + 'AQ.[AlertQueueID] '
	SET @sql = @sql + ',AQ.[LaunchDateTime] '
	SET @sql = @sql + ',AQ.[ProcessAlarmID] '
	SET @sql = @sql + ',AQ.[RequestAlarmID] '
	SET @sql = @sql + ',AQ.[Remarks] '
	SET @sql = @sql + ',AQ.[InsertedBy] '
	SET @sql = @sql + ',AQ.[InsertedOn] '
	SET @sql = @sql + ',AQ.[LastModifiedBy] '
	SET @sql = @sql + ',AQ.[LastModifiedOn] '

	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblAlarmQueue] AQ INNER JOIN '
	SET @sql = @sql + '[OW].[tblProcessAlarm] PA ON (AQ.ProcessAlarmID = PA.ProcessAlarmID) '

	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''

	IF (@AlertQueueID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[AlertQueueID] = @AlertQueueID AND '
	IF (@LaunchDateTime IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LaunchDateTime] <= @LaunchDateTime AND '
	IF (@ProcessAlarmID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[ProcessAlarmID] = @ProcessAlarmID AND '
	IF (@Remarks IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[Remarks] LIKE @Remarks AND '
	IF (@InsertedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[InsertedBy] LIKE @InsertedBy AND '
	IF (@InsertedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[InsertedOn] = @InsertedOn AND '
	IF (@LastModifiedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LastModifiedBy] LIKE @LastModifiedBy AND '
	IF (@LastModifiedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LastModifiedOn] = @LastModifiedOn AND '
	IF (@ProcessID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'PA.[ProcessID] = @ProcessID AND '
	IF (@ProcessStageID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'PA.[ProcessStageID] = @ProcessStageID AND '


	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@AlertQueueID int,
	@LaunchDateTime datetime,
	@ProcessAlarmID int,
	@ProcessID int,
	@ProcessStageID int,
	@Remarks varchar(255),
	@InsertedBy varchar(50),
	@InsertedOn datetime,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime',
	@AlertQueueID,
	@LaunchDateTime,
	@ProcessAlarmID,
	@ProcessID,
	@ProcessStageID,
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx01 Error on Creation'

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlarmQueueSelectEx02]'
GO




ALTER    PROCEDURE [OW].AlarmQueueSelectEx02
(
	------------------------------------------------------------------------	
	--Updated: 21-03-2007 19:00:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL,
	@LaunchDateTime datetime = NULL,
	@RequestAlarmID int = NULL,
	@RequestID numeric(18,0)= NULL,
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
		
	SET @sql = @sql + 'AQ.[AlertQueueID] '
	SET @sql = @sql + ',AQ.[LaunchDateTime] '
	SET @sql = @sql + ',AQ.[ProcessAlarmID] '
	SET @sql = @sql + ',AQ.[RequestAlarmID] '
	SET @sql = @sql + ',AQ.[Remarks] '
	SET @sql = @sql + ',AQ.[InsertedBy] '
	SET @sql = @sql + ',AQ.[InsertedOn] '
	SET @sql = @sql + ',AQ.[LastModifiedBy] '
	SET @sql = @sql + ',AQ.[LastModifiedOn] '

	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblAlarmQueue] AQ INNER JOIN '
	SET @sql = @sql + '[OW].[tblRequestAlarm] RA ON (AQ.RequestAlarmID = RA.RequestAlarmID) '

	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''

	
	IF (@AlertQueueID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[AlertQueueID] = @AlertQueueID AND '
	IF (@LaunchDateTime IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LaunchDateTime] <= @LaunchDateTime AND '
	IF (@RequestAlarmID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[RequestAlarmID] = @RequestAlarmID AND '
	IF (@Remarks IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[Remarks] LIKE @Remarks AND '
	IF (@InsertedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[InsertedBy] LIKE @InsertedBy AND '
	IF (@InsertedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[InsertedOn] = @InsertedOn AND '
	IF (@LastModifiedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LastModifiedBy] LIKE @LastModifiedBy AND '
	IF (@LastModifiedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LastModifiedOn] = @LastModifiedOn AND '
	IF (@RequestID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'RA.[RequestID] = @RequestID AND '
		
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@AlertQueueID int,
	@LaunchDateTime datetime,
	@RequestAlarmID int,
	@RequestID numeric(18,0),
	@Remarks varchar(255),
	@InsertedBy varchar(50),
	@InsertedOn datetime,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime',
	@AlertQueueID,
	@LaunchDateTime,
	@RequestAlarmID,
	@RequestID,
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx02 Error on Creation'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ArchFisicalInsertSelectEx01]'
GO

ALTER    PROCEDURE [OW].ArchFisicalInsertSelectEx01
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
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT DISTINCT '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'fi.[IdFisicalInsert] '
	SET @sql = @sql + ',fi.[IdParentFI] '
	SET @sql = @sql + ',fi.[IdFisicalAccessType] '
	SET @sql = @sql + ',fat.[IdFisicalType] '
	SET @sql = @sql + ',s.[IdSpace] '
	SET @sql = @sql + ',fvs.[IdField] '
	SET @sql = @sql + ',(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS Abreviation '
	SET @sql = @sql + ',(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS Name '
	SET @sql = @sql + ',fvs.[Name] AS InternalName '
	SET @sql = @sql + ',fvs.[Designation] AS InternalDesignation '
	SET @sql = @sql + ',ivf.[Value] AS InternalText '
	SET @sql = @sql + ',s.[CodeName] '
	SET @sql = @sql + ',s.[Image] '
	SET @sql = @sql + ',fi.[IdIdentityCB] '
	SET @sql = @sql + ',fi.[Barcode] '
	SET @sql = @sql + ',fi.[Order] '
	SET @sql = @sql + ',fi.[InsertedBy] '
	SET @sql = @sql + ',fi.[InsertedOn] '
	SET @sql = @sql + ',fi.[LastModifiedBy] '
	SET @sql = @sql + ',fi.[LastModifiedOn] '


	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblArchFisicalInsert] fi INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchFisicalAccessType] fat ON fi.[IdFisicalAccessType] = fat.[IdFisicalAccessType] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchInsertVsForm] ivf ON fi.[IdFisicalInsert] = ivf.[IdFisicalInsert] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchFieldsVsSpace] fvs ON ivf.[IdSpace] = fvs.[IdSpace] AND ivf.[IdField] = fvs.[IdField] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchSpace] s ON fvs.[IdSpace] = s.[IdSpace] '


	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''

	IF (@IdFisicalInsert IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[IdFisicalInsert] = @IdFisicalInsert AND '

	BEGIN
	IF(@IdParentFI IS NULL OR @IdParentFI <= 0)
		SET @sql_WHERE = @sql_WHERE + '(fi.[IdParentFI] IS NULL OR fi.[IdParentFI] <= @IdParentFI) AND '
	ELSE
	IF (@IdParentFI IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[IdParentFI] = @IdParentFI AND '
	END

	IF (@IdSpace IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 's.[IdSpace] = @IdSpace AND '
	IF (@IdField IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fvs.[IdField] = @IdField AND '
	IF (@InsertedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[InsertedBy] LIKE @InsertedBy AND '
	IF (@InsertedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[InsertedOn] = @InsertedOn AND '
	IF (@LastModifiedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[LastModifiedBy] LIKE @LastModifiedBy AND '
	IF (@LastModifiedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[LastModifiedOn] = @LastModifiedOn AND '


	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)

	
	-- SORT CLAUSE
	SET @sql = @sql + ' ORDER BY Name '
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@IdFisicalInsert int, 
	@IdParentFI int, 
	@IdSpace int, 
	@IdField int, 
	@InsertedBy varchar(150), 
	@InsertedOn datetime, 
	@LastModifiedBy varchar(150), 
	@LastModifiedOn datetime',
	@IdFisicalInsert, 
	@IdParentFI, 
	@IdSpace, 
	@IdField, 
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
PRINT N'Altering [OW].[ArchFisicalInsertSelectEx02]'
GO



ALTER      PROCEDURE [OW].ArchFisicalInsertSelectEx02
(
	@IdFisicalInsert int = NULL,
	@IdField int = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT DISTINCT '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'fi.[IdFisicalInsert] '
	SET @sql = @sql + ',fi.[IdParentFI] '
	SET @sql = @sql + ',fi.[IdFisicalAccessType] '
	SET @sql = @sql + ',fat.[IdFisicalType] '
	SET @sql = @sql + ',s.[IdSpace] '
	SET @sql = @sql + ',fvs.[IdField] '
	SET @sql = @sql + ',(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS Abreviation '
	SET @sql = @sql + ',(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS Name '
	SET @sql = @sql + ',fvs.[Name] AS InternalName '
	SET @sql = @sql + ',fvs.[Designation] AS InternalDesignation '
	SET @sql = @sql + ',ivf.[Value] AS InternalText '
	SET @sql = @sql + ',s.[CodeName] '
	SET @sql = @sql + ',s.[Image] '
	SET @sql = @sql + ',fi.[IdIdentityCB] '
	SET @sql = @sql + ',fi.[Barcode] '
	SET @sql = @sql + ',fi.[Order] '
	SET @sql = @sql + ',fn.[Expanded] '
	SET @sql = @sql + ',fn.[Selected] '
	SET @sql = @sql + ',fi.[InsertedBy] '
	SET @sql = @sql + ',fi.[InsertedOn] '
	SET @sql = @sql + ',fi.[LastModifiedBy] '
	SET @sql = @sql + ',fi.[LastModifiedOn] '
	SET @sql = @sql + ',fn.[ChildOrder] '


	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblArchFisicalInsert] fi INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchFisicalAccessType] fat ON fi.[IdFisicalAccessType] = fat.[IdFisicalAccessType] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchInsertVsForm] ivf ON fi.[IdFisicalInsert] = ivf.[IdFisicalInsert] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchFieldsVsSpace] fvs ON ivf.[IdSpace] = fvs.[IdSpace] AND ivf.[IdField] = fvs.[IdField] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchSpace] s ON fvs.[IdSpace] = s.[IdSpace] INNER JOIN '
	SET @sql = @sql + '[OW].fnFisicalInsertById(@IdFisicalInsert) fn ON fn.[IdFisicalInsert] = fi.[IdFisicalInsert] '


	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''

	IF (@IdField IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fvs.[IdField] = @IdField AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)

	
	-- SORT CLAUSE
	SET @sql = @sql + ' ORDER BY fn.ChildOrder DESC '
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@IdFisicalInsert int, 
	@IdField int',
	@IdFisicalInsert, 
	@IdField


	SET @Err = @@Error
	RETURN @Err
END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ArchFisicalInsertSelectEx03]'
GO


ALTER     PROCEDURE [OW].ArchFisicalInsertSelectEx03
(
	@IdFisicalInsert int = NULL,
	@IdParentFI int = NULL,
	@IdSpace int = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT DISTINCT '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'fi.[IdFisicalInsert] '
	SET @sql = @sql + ',fi.[IdParentFI] '
	SET @sql = @sql + ',fi.[IdFisicalAccessType] '
	SET @sql = @sql + ',fat.[IdFisicalType] '
	SET @sql = @sql + ',s.[IdSpace] '
	SET @sql = @sql + ',(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS Abreviation '
	SET @sql = @sql + ',(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS Name '
	SET @sql = @sql + ',s.[CodeName] '


	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblArchFisicalInsert] fi INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchFisicalAccessType] fat ON fi.[IdFisicalAccessType] = fat.[IdFisicalAccessType] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchInsertVsForm] ivf ON fi.[IdFisicalInsert] = ivf.[IdFisicalInsert] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchFieldsVsSpace] fvs ON ivf.[IdSpace] = fvs.[IdSpace] AND ivf.[IdField] = fvs.[IdField] INNER JOIN '
	SET @sql = @sql + '[OW].[tblArchSpace] s ON fvs.[IdSpace] = s.[IdSpace] '


	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''

	IF (@IdFisicalInsert IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[IdFisicalInsert] = @IdFisicalInsert AND '
	IF (@IdParentFI IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fi.[IdParentFI] = @IdParentFI AND '
	IF (@IdSpace IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 's.[IdSpace] = @IdSpace AND '


	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)


	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@IdFisicalInsert int, 
	@IdParentFI int, 
	@IdSpace int',
	@IdFisicalInsert, 
	@IdParentFI, 
	@IdSpace

	SET @Err = @@Error
	RETURN @Err
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[DynamicFieldSelectEx01]'
GO





ALTER   PROCEDURE [OW].DynamicFieldSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 30-01-2006 10:32:00
	--Version: 1.1
	------------------------------------------------------------------------
	@DynamicFieldID int = NULL,
	@Description varchar(80) = NULL,
	@DynamicFieldTypeID int = NULL,
	@ListOfValuesID int = NULL,
	@FlowID int = NULL
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

	SET @sql = @sql + 'DynamicField.DynamicFieldID '
	SET @sql = @sql + ',DynamicField.[Description] '
	SET @sql = @sql + ',DynamicFieldType.[ID] AS DynamicFieldTypeID '
	SET @sql = @sql + ',DynamicFieldType.[Description] AS DynamicFieldTypeDescription '
	SET @sql = @sql + ',DynamicField.[Precision] '
	SET @sql = @sql + ',DynamicField.Scale '


	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblDynamicField] DynamicField INNER JOIN '
	SET @sql = @sql + '[OW].[vDynamicFieldType] DynamicFieldType ON DynamicField.DynamicFieldTypeID = DynamicFieldType.[ID] '

	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''

	IF (@DynamicFieldID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'DynamicField.DynamicFieldID = @DynamicFieldID AND '
	IF (@Description IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'DynamicField.[Description] = @Description AND '
	IF (@DynamicFieldTypeID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'DynamicFieldType.[ID] = @DynamicFieldTypeID AND '
	IF (@ListOfValuesID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'DynamicField.[ListOfValuesID] = @ListOfValuesID AND '
	IF (@FlowID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'EXISTS (SELECT 1 FROM OW.tblProcessDynamicField ProcessDynamicField WHERE DynamicField.DynamicFieldID = ProcessDynamicField.DynamicFieldID AND ProcessDynamicField.FlowID = @FlowID) AND '

	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)


	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@DynamicFieldID int, 
	@Description varchar(80), 
	@DynamicFieldTypeID int, 
	@ListOfValuesID int, 
	@FlowID int',
	@DynamicFieldID, 
	@Description, 
	@DynamicFieldTypeID, 
	@ListOfValuesID, 
	@FlowID

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldSelectEx01 Error on Creation'



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
PRINT N'Altering [OW].[FavoriteSearchSelectEx01]'
GO


------------------------------------------------------------------------
-- Devolve as pesquisas favoritas de um utilizador para um módulo ou para
-- os módulos todos.
-- 
------------------------------------------------------------------------
ALTER  PROCEDURE [OW].FavoriteSearchSelectEx01
(
	@Type int = NULL,
	@UserID int
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
	
	SET @sql = @sql + '[FavoriteSearchID] '
	SET @sql = @sql + ',[Type] '
	SET @sql = @sql + ',[UserID] '
	SET @sql = @sql + ',[Description] '
	SET @sql = @sql + ',[Global] '
	SET @sql = @sql + ',[SearchCriteria] '
	SET @sql = @sql + ',[Remarks] '
	SET @sql = @sql + ',[InsertedBy] '
	SET @sql = @sql + ',[InsertedOn] '
	SET @sql = @sql + ',[LastModifiedBy] '
	SET @sql = @sql + ',[LastModifiedOn] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblFavoriteSearch] '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@Type IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[Type]=@Type AND '

	SET @sql_WHERE = @sql_WHERE + '([Global]=1 OR [UserID]=@UserID) AND '

	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)

	-- SORT CLAUSE ------------------------
	SET @sql_WHERE = @sql_WHERE + ' ORDER BY [Type], [Global], [Description] ' 

		
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@Type int, 
	@UserID int',
	@Type, 
	@UserID
	
	
	SET @Err = @@Error
	RETURN @Err
END
	

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[FlowMailConnectorSelectEx01]'
GO



ALTER   PROCEDURE [OW].FlowMailConnectorSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 10:17:51
	--Version: 2.0	
	------------------------------------------------------------------------
	
	@MailConnectorID int = NULL,
	@Folder varchar(255) = NULL,
	@Description varchar(80) = NULL,
	@Active smallint = NULL	
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
	
	SET @sql = @sql + 'fmc.[MailConnectorID] '
	SET @sql = @sql + ',fmc.[Folder] '
	SET @sql = @sql + ',fd.[Description] '
	SET @sql = @sql + ',fmc.[Active] '
	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM OW.tblFlowMailConnector fmc INNER JOIN '
	SET @sql = @sql + 'OW.tblFlow f ON fmc.FlowID = f.FlowID INNER JOIN '
	SET @sql = @sql + 'OW.tblFlowDefinition fd ON f.FlowDefinitionID = fd.FlowDefinitionID '

	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@MailConnectorID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fmc.[MailConnectorID] = @MailConnectorID AND '
	IF (@Folder IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fmc.[Folder] LIKE @Folder AND '
	IF (@Description IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fd.[Description] = @Description AND '
	IF (@Active IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'fmc.[Active] = @Active AND '
	SET @sql_WHERE = @sql_WHERE + '(fmc.FlowID = 1) AND (fmc.Active = 0) AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@MailConnectorID int, 
	@Folder varchar(255), 
	@Description varchar(80), 
	@Active smallint',
	@MailConnectorID, 
	@Folder, 
	@Description, 
	@Active
	
	
	SET @Err = @@Error
	RETURN @Err
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[GroupsSelectEx01]'
GO


ALTER  PROCEDURE [OW].GroupsSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 15:40:51
	--Version: 2.0	
	------------------------------------------------------------------------
	
	@GroupID int = NULL,
	@HierarchyID int = NULL,
	@ShortName varchar(10) = NULL,
	@GroupDesc varchar(100) = NULL
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
	
	SET @sql = @sql + 'Groups.[GroupID] '
	SET @sql = @sql + ',Groups.[GroupDesc] '
	SET @sql = @sql + ',Groups.[ShortName] '
	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblGroups] Groups INNER JOIN '
	SET @sql = @sql + '[OW].[tblOrganizationalUnit] OrganizationalUnit ON (Groups.[GroupID] = OrganizationalUnit.[GroupID]) '

	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@GroupID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'Groups.[GroupID] = @GroupID AND '
	IF (@HierarchyID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'Groups.[HierarchyID] = @HierarchyID AND '
	IF (@ShortName IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[ShortName] LIKE @ShortName AND '
	IF (@GroupDesc IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[GroupDesc] LIKE @GroupDesc AND '
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@GroupID int, 
	@HierarchyID int, 
	@ShortName varchar(10), 
	@GroupDesc varchar(100)',
	@GroupID, 
	@HierarchyID, 
	@ShortName, 
	@GroupDesc	
	
	SET @Err = @@Error
	RETURN @Err
END
	

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ListOfValuesSelectEx01]'
GO


ALTER  PROCEDURE [OW].ListOfValuesSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 19:00:00
	--Version: 2.0
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL,
	@Description varchar(50) = NULL,
	@ListOfValuesTypeDescription varchar(80) = NULL
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
	
	SET @sql = @sql + 'lov.[ListOfValuesID] '
	SET @sql = @sql + ',lov.[Description] '
	SET @sql = @sql + ',lovt.[ID] AS ListOfValuesTypeID '
	SET @sql = @sql + ',lovt.[Description] AS ListOfValuesTypeDescription '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblListOfValues] INNER JOIN '
	SET @sql = @sql + 'OW.vListOfValuesType lovt ON lov.Type = lovt.[ID] '	

	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@ListOfValuesID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'lov.[ListOfValuesID] = @ListOfValuesID AND '
	IF (@Description IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'lov.[Description] LIKE @Description AND '
	IF (@ListOfValuesTypeDescription IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'lovt.[Description] LIKE @ListOfValuesTypeDescription AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@ListOfValuesID int, 
	@Description varchar(50), 
	@ListOfValuesTypeDescription varchar(80)',
	@ListOfValuesID, 
	@Description, 
	@ListOfValuesTypeDescription
	
	
	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ParameterSelectEx01]'
GO


ALTER  PROCEDURE [OW].ParameterSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 10:17:51
	--Version: 2.0	
	------------------------------------------------------------------------
	@ParameterID int = NULL,
	@Description varchar(80) = NULL,
	@Value numeric(18,3) = NULL
	
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
	
	SET @sql = @sql + '[ParameterID] '
	SET @sql = @sql + ',[Description] '
	SET @sql = @sql + ',COALESCE (NumericValue, AlphaNumericValue) AS Value '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblParameter] '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@ParameterID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[ParameterID] = @ParameterID AND '
	IF (@Description IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[Description] LIKE @Description AND '
	IF (@Value IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'COALESCE (NumericValue, AlphaNumericValue) = @Value AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@ParameterID int, 
	@Description varchar(80), 
	@Value numeric(18,3)',
	@ParameterID, 
	@Description, 
	@Value
	
	
	SET @Err = @@Error
	RETURN @Err
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmSelectEx01]'
GO



ALTER   PROCEDURE [OW].ProcessAlarmSelectEx01
(
	------------------------------------------------------------------------	
	--Updated: 01-07-2008 11:17:24
	--Version: 2.0
	------------------------------------------------------------------------
	@LaunchDateTime datetime = NULL
	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT TOP 1000 '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'PA.[ProcessAlarmID] '
	SET @sql = @sql + ',PA.[AlarmType] '
	SET @sql = @sql + ',PA.[FlowID] '
	SET @sql = @sql + ',PA.[FlowStageID] '
	SET @sql = @sql + ',PA.[ProcessID] '
	SET @sql = @sql + ',PA.[ProcessStageID] '
	SET @sql = @sql + ',PA.[AlarmDatetime] '
	SET @sql = @sql + ',PA.[Occurence] '
	SET @sql = @sql + ',PA.[OccurenceOffset] '
	SET @sql = @sql + ',PA.[Message] '
	SET @sql = @sql + ',PA.[AlertByEMail] '
	SET @sql = @sql + ',PA.[AddresseeExecutant] '
	SET @sql = @sql + ',PA.[AddresseeFlowOwner] '
	SET @sql = @sql + ',PA.[AddresseeProcessOwner] '
	SET @sql = @sql + ',PA.[Remarks] '
	SET @sql = @sql + ',PA.[InsertedBy] '
	SET @sql = @sql + ',PA.[InsertedOn] '
	SET @sql = @sql + ',PA.[LastModifiedBy] '
	SET @sql = @sql + ',PA.[LastModifiedOn] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblProcessAlarm] PA INNER JOIN '
	SET @sql = @sql + '[OW].[tblAlarmQueue] AQ ON (PA.ProcessAlarmID = AQ.ProcessAlarmID) '

	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@LaunchDateTime IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LaunchDateTime] <= @LaunchDateTime AND '
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@LaunchDateTime datetime',
	@LaunchDateTime
	
	
	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessReferenceSelectEx01]'
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [OW].ProcessReferenceSelectEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Version: 1.0
	------------------------------------------------------------------------
	
	@ProcessID int = NULL
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
	
	SET @sql = @sql + 'pr.[ProcessReferenceID] '
	SET @sql = @sql + ',pr.[ProcessEventID] '
	SET @sql = @sql + ',pr.[ProcessReferedID] '
	SET @sql = @sql + ',pr.[ProcessReferenceType] '
	SET @sql = @sql + ',pr.[ShareData] '
	SET @sql = @sql + ',pe.[ProcessID] '
	SET @sql = @sql + ',pe.[ProcessStageID] '
	SET @sql = @sql + ',pe.[CreationDate] '
	SET @sql = @sql + ',pe.[OrganizationalUnitID] '
	SET @sql = @sql + ',case when ou.UserID is not null then u.UserDesc else g.GroupDesc end AS OrganizationalUnitDescription '
	SET @sql = @sql + ',ps.[Number] AS ProcessStageNumber '
	SET @sql = @sql + ',ps.[Description] AS ProcessStageDescription '
	SET @sql = @sql + ',p.[ProcessNumber] + '' - '' + fd.description AS ProcessNumberAndDescription '


	-- FROM --------------------------------
	SET @sql = @sql + 'FROM OW.tblProcessReference pr INNER JOIN '
	SET @sql = @sql + 'OW.tblProcess p ON p.ProcessID = pr.ProcessReferedID INNER JOIN '
	SET @sql = @sql + 'OW.tblFlow f ON f.FlowID = p.FlowID INNER JOIN '
	SET @sql = @sql + 'OW.tblFlowDefinition fd ON fd.FlowDefinitionID = f.FlowDefinitionID INNER JOIN '
	SET @sql = @sql + 'OW.tblProcessEvent pe ON pr.ProcessEventID = pe.ProcessEventID LEFT OUTER JOIN  '
	SET @sql = @sql + 'OW.tblProcessStage ps ON pe.ProcessStageID = ps.ProcessStageID INNER JOIN '
	SET @sql = @sql + 'OW.tblOrganizationalUnit ou ON ou.OrganizationalUnitID = pe.OrganizationalUnitID LEFT OUTER JOIN '
	SET @sql = @sql + 'OW.tblGroups g ON g.GroupID = ou.GroupID LEFT OUTER JOIN '
	SET @sql = @sql + 'OW.tblUser u ON u.UserID = ou.UserID '


	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@ProcessID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'pe.[ProcessID] = @ProcessID AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@ProcessID int',
	@ProcessID

	SET @Err = @@Error
	RETURN @Err
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessReferenceSelectEx02]'
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	 PROCEDURE [OW].ProcessReferenceSelectEx02
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Version: 1.0
	------------------------------------------------------------------------
	
	@ProcessID int = NULL
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
	
	SET @sql = @sql + 'pr.[ProcessReferenceID] '
	SET @sql = @sql + ',pr.[ProcessEventID] '
	SET @sql = @sql + ',pr.[ProcessReferedID] '
	SET @sql = @sql + ',pr.[ProcessReferenceType] '
	SET @sql = @sql + ',pr.[ShareData] '
	SET @sql = @sql + ',pe.[ProcessID] '
	SET @sql = @sql + ',pe.[ProcessStageID] '
	SET @sql = @sql + ',pe.[CreationDate] '
	SET @sql = @sql + ',pe.[OrganizationalUnitID] '
	SET @sql = @sql + ',case when ou.UserID is not null then u.UserDesc else g.GroupDesc end AS OrganizationalUnitDescription '
	SET @sql = @sql + ',ps.[Number] AS ProcessStageNumber '
	SET @sql = @sql + ',ps.[Description] AS ProcessStageDescription '
	SET @sql = @sql + ',p.[ProcessNumber] + '' - '' + fd.description AS ProcessNumberAndDescription '

	-- FROM --------------------------------
	SET @sql = @sql + 'FROM OW.tblProcessReference pr INNER JOIN '
	SET @sql = @sql + 'OW.tblProcessEvent pe ON pr.ProcessEventID = pe.ProcessEventID INNER JOIN '
	SET @sql = @sql + 'OW.tblProcess p ON p.ProcessID = pe.ProcessID INNER JOIN '
	SET @sql = @sql + 'OW.tblFlow f ON f.FlowID = p.FlowID INNER JOIN '
	SET @sql = @sql + 'OW.tblFlowDefinition fd ON fd.FlowDefinitionID = f.FlowDefinitionID LEFT OUTER JOIN '
	SET @sql = @sql + 'OW.tblProcessStage ps ON pe.ProcessStageID = ps.ProcessStageID INNER JOIN '
	SET @sql = @sql + 'OW.tblOrganizationalUnit ou ON ou.OrganizationalUnitID = pe.OrganizationalUnitID LEFT OUTER JOIN '
	SET @sql = @sql + 'OW.tblGroups g ON g.GroupID = ou.GroupID LEFT OUTER JOIN '
	SET @sql = @sql + 'OW.tblUser u ON u.UserID = ou.UserID '


	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@ProcessID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'pr.[ProcessReferedID] = @ProcessID AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@ProcessID int',
	@ProcessID

	SET @Err = @@Error
	RETURN @Err
END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[RegistrySelectEx01]'
GO


ALTER  PROCEDURE [OW].RegistrySelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 11:48:38
	--Version: 2.0	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@FisicalID int = NULL,
	@Table varchar(1) = NULL,
	@abreviation nvarchar(20) = NULL,
	@Number varchar(15) = NULL,
	@subject nvarchar(250) = NULL,
	@date datetime = NULL,
	@DocumentID numeric(18,0) = NULL
	
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
	
	SET @sql = @sql + '[regid] '
	SET @sql = @sql + ',[FisicalID] '
	SET @sql = @sql + ',[Table] '
	SET @sql = @sql + ',[abreviation] '
	SET @sql = @sql + ',[number] '
	SET @sql = @sql + ',[subject] '
	SET @sql = @sql + ',[date] '
	SET @sql = @sql + ',[DocumentID] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[VREGISTRYEX01] '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@regid IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[regid] = @regid AND '
	IF (@FisicalID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[FisicalID] = @FisicalID AND '
	IF (@Table IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[Table] LIKE @Table AND '
	IF (@abreviation IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[abreviation] LIKE @abreviation AND '
	IF (@Number IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[number] LIKE @Number AND '
	IF (@subject IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[subject] LIKE @subject AND '
	IF (@date IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[date] = @date AND '
	IF (@DocumentID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[DocumentID] = @DocumentID AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@regid numeric(18,0),
	@FisicalID int,
	@Table varchar(1),
	@abreviation nvarchar(20),
	@Number varchar(15),
	@subject nvarchar(250),
	@date datetime,
	@DocumentID numeric(18,0)',
	@regid,
	@FisicalID,
	@Table,
	@abreviation,
	@Number,
	@subject,
	@date,
	@DocumentID
	
	
	SET @Err = @@Error
	RETURN @Err
END
	

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[RegistrySelectEx02]'
GO



ALTER   PROCEDURE [OW].RegistrySelectEx02
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 10:04:42
	--Version: 2.0	
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
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'r.[RegID] '
	SET @sql = @sql + ',r.[BookID] '
	SET @sql = @sql + ',b.[Abreviation] '
	SET @sql = @sql + ',r.[Year] '
	SET @sql = @sql + ',r.[Number] '
	SET @sql = @sql + ',r.[Date] '
	SET @sql = @sql + ',r.[Subject] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblregistry] r INNER JOIN '
	SET @sql = @sql + '[OW].[tblBooks] b ON r.bookid = b.bookID '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@regid IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[regid] = @regid AND '
	IF (@bookid IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[bookid] = @bookid AND '
	IF (@year IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[year] = @year AND '
	IF (@number IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[number] = @number AND '
	IF (@date IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[date] = @date AND '
	IF (@subject IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[subject] LIKE @subject AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@regid numeric(18,0), 
	@bookid numeric(18,0), 
	@year int, 
	@number int, 
	@date datetime, 
	@subject nvarchar(250)',
	@regid, 
	@bookid, 
	@year, 
	@number, 
	@date, 
	@subject
	
	SET @Err = @@Error
	RETURN @Err
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[RequestAlarmSelectEx01]'
GO


ALTER  PROCEDURE [OW].RequestAlarmSelectEx01
(
	------------------------------------------------------------------------	
	--Updated: 01-07-2009 19:00:00
	--Version: 2.0	
	------------------------------------------------------------------------
	@LaunchDateTime datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT TOP 1000 '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'RA.[RequestAlarmID] '
	SET @sql = @sql + ',RA.[RequestID] '
	SET @sql = @sql + ',RA.[Occurence] '
	SET @sql = @sql + ',RA.[OccurenceOffset] '
	SET @sql = @sql + ',RA.[Message] '
	SET @sql = @sql + ',RA.[AlertByEMail] '
	SET @sql = @sql + ',RA.[AddresseeRequestOwner] '
	SET @sql = @sql + ',RA.[AddresseeLastModifyUser] '
	SET @sql = @sql + ',RA.[Remarks] '
	SET @sql = @sql + ',RA.[InsertedBy] '
	SET @sql = @sql + ',RA.[InsertedOn] '
	SET @sql = @sql + ',RA.[LastModifiedBy] '
	SET @sql = @sql + ',RA.[LastModifiedOn] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblRequestAlarm] RA INNER JOIN '
	SET @sql = @sql + '[OW].[tblAlarmQueue] AQ ON (RA.RequestAlarmID = AQ.RequestAlarmID) '

	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@LaunchDateTime IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'AQ.[LaunchDateTime] <= @LaunchDateTime AND '
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@LaunchDateTime datetime',
	@LaunchDateTime
	
	
	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[RequestAlarmSelectEx02]'
GO


ALTER  PROCEDURE [OW].RequestAlarmSelectEx02
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 17:23:00
	--Version: 2.0	
	------------------------------------------------------------------------
	@RequestAlarmID int = NULL	
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
	
	SET @sql = @sql + '[RequestAlarmID] '
	SET @sql = @sql + ',[RequestID] '
	SET @sql = @sql + ',[Occurence] '
	SET @sql = @sql + ',[OccurenceOffset] '
	SET @sql = @sql + ',[Message] '
	SET @sql = @sql + ',[AlertByEMail] '
	SET @sql = @sql + ',[AddresseeRequestOwner] '
	SET @sql = @sql + ',[AddresseeLastModifyUser] '
	SET @sql = @sql + ',[Remarks] '
	SET @sql = @sql + ',[InsertedBy] '
	SET @sql = @sql + ',[InsertedOn] '
	SET @sql = @sql + ',[LastModifiedBy] '
	SET @sql = @sql + ',[LastModifiedOn] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblRequestAlarm] '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@RequestAlarmID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[RequestAlarmID] = @RequestAlarmID AND '
	SET @sql_WHERE = @sql_WHERE + '[RequestID] IS NULL AND '
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@RequestAlarmID int',
	@RequestAlarmID
	
	
	SET @Err = @@Error
	RETURN @Err
END
	

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ResourceSelectEx01]'
GO


ALTER  PROCEDURE [OW].ResourceSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 16:17:51
	--Version: 2.0	
	------------------------------------------------------------------------
	@ResourceID int = NULL,
	@ModuleID int = NULL,
	@Description varchar(80) = NULL,
	@Active smallint = NULL,
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
	
	SET @sql = @sql + 'r.[ResourceID] '
	SET @sql = @sql + ',r.[ModuleID] '
	SET @sql = @sql + ',m.[Description] AS ModuleDescription '
	SET @sql = @sql + ',r.[Description] '
	SET @sql = @sql + ',r.[Active] '
	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblResource] r INNER JOIN '
	SET @sql = @sql + 'OW.tblModule m ON r.ModuleID = m.ModuleID '

	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@ResourceID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[ResourceID] = @ResourceID AND '
	IF (@ModuleID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[ModuleID] = @ModuleID AND '
	IF (@Description IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[Description] LIKE @Description AND '
	IF (@Active IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[Active] = @Active AND '
	IF (@Remarks IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[Remarks] LIKE @Remarks AND '
	IF (@InsertedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[InsertedBy] LIKE @InsertedBy AND '
	IF (@InsertedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[InsertedOn] = @InsertedOn AND '
	IF (@LastModifiedBy IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[LastModifiedBy] LIKE @LastModifiedBy AND '
	IF (@LastModifiedOn IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'r.[LastModifiedOn] = @LastModifiedOn AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@ResourceID int, 
	@ModuleID int, 
	@Description varchar(80), 
	@Active smallint, 
	@Remarks varchar(255), 
	@InsertedBy varchar(50), 
	@InsertedOn datetime, 
	@LastModifiedBy varchar(50), 
	@LastModifiedOn datetime',
	@ResourceID, 
	@ModuleID, 
	@Description, 
	@Active, 
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
PRINT N'Altering [OW].[UserSelectEx01]'
GO


ALTER  PROCEDURE [OW].UserSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 01-07-2008 14:09:51
	--Version: 2.0	
	------------------------------------------------------------------------
	@UserID int = NULL,
	@UserDesc varchar(100) = NULL,
	@UserMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@UserLogin varchar(50) = NULL,
	@PrimaryGroupID int = NULL,
	@GroupID int = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT DISTINCT '
	
	-- FIELDS ENUM ------------------------
	
	SET @sql = @sql + 'u.[userID] '
	SET @sql = @sql + ',u.[userDesc] '
	SET @sql = @sql + ',u.[userMail] '
	SET @sql = @sql + ',u.[Phone] '
	SET @sql = @sql + ',u.[Fax] '
	SET @sql = @sql + ',u.[userLogin] '

	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblUser] u INNER JOIN '
	SET @sql = @sql + 'OW.tblOrganizationalUnit o ON u.UserID = o.UserID '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@userID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[userID] = @userID AND '
	IF (@userDesc IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[userDesc] LIKE @userDesc AND '
	IF (@userMail IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[userMail] LIKE @userMail AND '
	IF (@Phone IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[Phone] LIKE @Phone AND '
	IF (@Fax IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[Fax] LIKE @Fax AND '
	IF (@userLogin IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[userLogin] LIKE @userLogin AND '
	IF (@PrimaryGroupID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + 'u.[PrimaryGroupID] = @PrimaryGroupID AND '

	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@userID int, 
	@userDesc varchar(50), 
	@userMail varchar(50), 
	@Phone varchar(25), 
	@Fax varchar(25), 
	@userLogin varchar(50), 
	@PrimaryGroupID int, 
	@GroupID int',
	@userID, 
	@userDesc, 
	@userMail, 
	@Phone, 
	@Fax, 
	@userLogin, 
	@PrimaryGroupID,
	@GroupID


	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[usp_GetUser]'
GO
ALTER PROCEDURE [OW].usp_GetUser
(
	/* Users */
	@userID numeric(18,0) = NULL,
	@userLogin varchar(900) = NULL,
	@userDesc varchar(300) = NULL,
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL
		
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @sql NVARCHAR(4000)		
	DECLARE @sql_WHERE NVARCHAR(4000)
	
	

	-- SELECT -----------------------------
	SET @sql = 'SELECT * '
	
	-- FROM --------------------------------
	SET @sql = @sql + 'FROM [OW].[tblUser] '
	
	-- WHERE CLAUSE ------------------------
	SET @sql_WHERE = ''
	
	IF (@userID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[userID] = @userID AND '
	IF (@userLogin IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[userLogin] = @userLogin AND '
	IF (@userDesc IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[userDesc] = @userDesc AND '
	IF (@userMail IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[userMail] = @userMail AND '
	IF (@userActive IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[userActive] = @userActive AND '
	IF (@TextSignature IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[TextSignature] = @TextSignature AND '
	IF (@PrimaryGroupID IS NOT NULL)
		SET @sql_WHERE = @sql_WHERE + '[PrimaryGroupID] = @PrimaryGroupID AND '
	
	-- ADD WHERE AND REMOVE LAST 'AND' ---------
	IF (LEN(@sql_WHERE) > 0)
		SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)

	-- SORT CLAUSE ---------
	SET @sql = @sql + ' ORDER BY userLogin '
	
	-- EXECUTE SQL --------------------------
	EXEC sp_executesql @sql,
	N'@userID int, 
	@userLogin varchar(50), 
	@userDesc varchar(50), 
	@userMail varchar(50), 
	@userActive bit, 
	@TextSignature varchar(300), 
	@PrimaryGroupID int',
	@userID, 
	@userLogin, 
	@userDesc, 
	@userMail, 
	@userActive, 
	@TextSignature, 
	@PrimaryGroupID
	
	SET @Err = @@Error
	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[FlowStageSelectEx01]'
GO
CREATE PROCEDURE [OW].FlowStageSelectEx01
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.0	
		------------------------------------------------------------------------
		@FlowID int = NULL
		
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
		
		SET @sql = @sql + 'fs.[FlowStageID] '
		SET @sql = @sql + ',fs.[FlowID] '
		SET @sql = @sql + ',fs.[Number] '
		SET @sql = @sql + ',fs.[Description] '
		SET @sql = @sql + ',fs.[Duration] '
		SET @sql = @sql + ',fs.[Address] '
		SET @sql = @sql + ',fs.[Method] '
		SET @sql = @sql + ',fs.[FlowStageType] '
		SET @sql = @sql + ',fs.[DocumentTemplateID] '
		SET @sql = @sql + ',fs.[OrganizationalUnitID] '
		SET @sql = @sql + ',fs.[CanAssociateProcess] '
		SET @sql = @sql + ',fs.[Transfer] '
		SET @sql = @sql + ',fs.[RequestForComments] '
		SET @sql = @sql + ',fs.[AttachmentRequired] '
		SET @sql = @sql + ',fs.[EditDocuments] '
		SET @sql = @sql + ',fs.[HelpAddress] '
		SET @sql = @sql + ',fs.[Remarks] '
		SET @sql = @sql + ',fs.[InsertedBy] '
		SET @sql = @sql + ',fs.[InsertedOn] '
		SET @sql = @sql + ',fs.[LastModifiedBy] '
		SET @sql = @sql + ',fs.[LastModifiedOn] '
		SET @sql = @sql + ',case when ou.UserID is not null then u.UserDesc else g.GroupDesc end AS OrganizationalUnitDescription '

	
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblFlowStage] fs INNER JOIN '
        		SET @sql = @sql + 'OW.tblOrganizationalUnit ou ON ou.OrganizationalUnitID = fs.OrganizationalUnitID LEFT OUTER JOIN '
		SET @sql = @sql + 'OW.tblGroups g ON g.GroupID = ou.GroupID LEFT OUTER JOIN '
        		SET @sql = @sql + 'OW.tblUser u ON u.UserID = ou.UserID '

		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@FlowID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + 'fs.[FlowID] = @FlowID AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@FlowID int',
		@FlowID
		
		SET @Err = @@Error
		RETURN @Err
	END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ProcessEventSelectEx02]'
GO
CREATE PROCEDURE [OW].ProcessEventSelectEx02
	(
		------------------------------------------------------------------------
		--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
		--Version: 1.0
		------------------------------------------------------------------------
		
		@ProcessID int = NULL
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
		
		SET @sql = @sql + 'pe.[ProcessEventID] '
		SET @sql = @sql + ',pe.[ProcessStageID] '
		SET @sql = @sql + ',pe.[ProcessID] '
		SET @sql = @sql + ',pe.[RoutingType] '
		SET @sql = @sql + ',pe.[ProcessEventStatus] '
		SET @sql = @sql + ',pe.[PreviousProcessEventID] '
		SET @sql = @sql + ',pe.[NextProcessEventID] '
		SET @sql = @sql + ',pe.[CreationDate] '
		SET @sql = @sql + ',pe.[ReadDate] '
		SET @sql = @sql + ',pe.[EstimatedDateToComplete] '
		SET @sql = @sql + ',pe.[OrganizationalUnitID] '
		SET @sql = @sql + ',pe.[ExecutionDate] '
		SET @sql = @sql + ',pe.[EndDate] '
		SET @sql = @sql + ',pe.[WorkflowActionType] '
		SET @sql = @sql + ',pe.[WorkflowInfo] '
		SET @sql = @sql + ',pe.[Remarks] '
		SET @sql = @sql + ',pe.[InsertedBy] '
		SET @sql = @sql + ',pe.[InsertedOn] '
		SET @sql = @sql + ',pe.[LastModifiedBy] '
		SET @sql = @sql + ',pe.[LastModifiedOn] '
		SET @sql = @sql + ',case when ou.UserID is not null then u.UserDesc else g.GroupDesc end AS OrganizationalUnitDescription '
		SET @sql = @sql + ',ps.[Number] AS ProcessStageNumber '
		SET @sql = @sql + ',ps.[Description] AS ProcessStageDescription '
		SET @sql = @sql + ',ps.[FlowStageType] '
		SET @sql = @sql + ',ps.[Duration] AS ProcessStageDuration '
		
		-- FROM --------------------------------
		SET @sql = @sql + 'FROM [OW].[tblProcessEvent] pe INNER JOIN '
		SET @sql = @sql + '[OW].[tblProcessStage] ps ON (pe.[ProcessStageID] = ps.[ProcessStageID]) INNER JOIN '
		SET @sql = @sql + 'OW.tblOrganizationalUnit ou ON ou.OrganizationalUnitID = pe.OrganizationalUnitID LEFT OUTER JOIN '
		SET @sql = @sql + 'OW.tblGroups g ON g.GroupID = ou.GroupID LEFT OUTER JOIN '
        		SET @sql = @sql + 'OW.tblUser u ON u.UserID = ou.UserID '

		
		-- WHERE CLAUSE ------------------------
		SET @sql_WHERE = ''
		
		IF (@ProcessID IS NOT NULL)
			SET @sql_WHERE = @sql_WHERE + 'pe.[ProcessID] = @ProcessID AND '

		
		-- ADD WHERE AND REMOVE LAST 'AND' ---------
		IF (LEN(@sql_WHERE) > 0)
			SET @sql = @sql + 'WHERE ' + LEFT(@sql_WHERE, LEN(@sql_WHERE) - 4)
		
		-- EXECUTE SQL --------------------------
		EXEC sp_executesql @sql,
		N'@ProcessID int',
		@ProcessID

		SET @Err = @@Error
		RETURN @Err
	END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Creating [OW].[UserSelectEx06]'
GO
CREATE PROCEDURE [OW].UserSelectEx06
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--Created On :	11-04-2008 14:19:00
	--Version : 	1.0
	--Description:	Devolve os ids das unidades organizacionais de  um utilizador.
	--Used By: 	GetOrganizationalUnitIDsForUser in C#
	------------------------------------------------------------------------------------------------------------------------------------------------
	@UserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
	SELECT OrganizationalUnitID 
	FROM OW.tblOrganizationalUnit 
	WHERE UserID = @UserID
	
	UNION
	
	SELECT OrganizationalUnitID 
	FROM OW.tblOrganizationalUnit 
	WHERE UserID is NULL 
	AND GroupID = (SELECT PrimaryGroupID FROM OW.tblUser where UserID = @UserID)
	
	UNION
	
	SELECT OrganizationalUnitID 
	FROM OW.tblOrganizationalUnit 
	WHERE UserID is NULL 
	AND GroupID IN (SELECT GroupID FROM OW.tblGroupsUsers WHERE UserID = @UserID)

		
	SET @Err = @@Error
	RETURN @Err
END

GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckProcessOwner') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckProcessOwner;
GO
CREATE PROCEDURE [OW].CheckProcessOwner
(
	@ProcessID int = NULL,
	@ProcessEventID int = NULL,
	@UserID int,
	@Owner tinyint output
)
AS
BEGIN

	declare @ProcessOwnerID int
	declare @PrimaryGroupID int

	SET @Owner = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do grupo hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
	-- ----------------------------------------------------------------------------------------------------
	-- Dados do originador e do dono do processo
	-- ----------------------------------------------------------------------------------------------------
	IF (@ProcessID IS NOT NULL)
		SELECT @ProcessOwnerID = ProcessOwnerID FROM OW.tblProcess WHERE ProcessID = @ProcessID
	ELSE
		IF (@ProcessEventID IS NOT NULL)
			SELECT @ProcessOwnerID = ProcessOwnerID FROM OW.tblProcessEvent pe INNER JOIN OW.tblProcess p ON(pe.ProcessId = p.ProcessId) WHERE pe.ProcessEventID = @ProcessEventID

	-- ----------------------------------------------------------------------------------------------------
	-- Se o utilizador for dono do processo, então tem acesso a tudo
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT UserID 
	          FROM OW.tblOrganizationalUnit 
	          WHERE OrganizationalUnitID = @ProcessOwnerID
	            AND (UserID = @UserID OR GroupID = @PrimaryGroupID))
	BEGIN
		SET @Owner = 1		
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT OW.tblOrganizationalUnit.OrganizationalUnitID
		   FROM OW.tblGroupsUsers gu INNER JOIN
		        OW.tblOrganizationalUnit ON (gu.GroupID = OW.tblOrganizationalUnit.GroupID AND gu.UserID = @UserID)
		   WHERE OW.tblOrganizationalUnit.OrganizationalUnitID = @ProcessOwnerID)
		BEGIN
			SET @Owner = 1		
		END
	END

	RETURN
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessOwner Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessOwner Error on Creation'
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

PRINT N'Altering [OW].[ProcessDeleteEx01]'
GO

ALTER PROCEDURE [OW].ProcessDeleteEx01
(
	@ProcessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	SET XACT_ABORT ON

	BEGIN TRANSACTION

	/* Eliminação das Referências para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessReference]
	WHERE
		[ProcessReferedID] = @ProcessID

	/* Eliminação das Referências do processo a eliminar */
	DELETE 
	FROM [OW].[tblProcessReference] 
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessEvent] PE
		 WHERE PE.[ProcessID] = @ProcessID
		 AND PE.[processEventID] = [OW].[tblProcessReference].[processEventID]
		)

	/* Eliminação dos alertas associados ao processo */
	DELETE
	FROM [OW].[tblAlert]
	WHERE
		[ProcessID] = @ProcessID

	/* Eliminação dos endereçamentos dos alarmes associados ao processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAlarmAddressee]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessAlarm] PA
		 WHERE 	PA.[ProcessID] = @ProcessID
		 AND PA.[ProcessAlarmID] = [OW].[tblProcessAlarmAddressee].[ProcessAlarmID]
		)

	/* Eliminação dos alarmes em queue */
	DELETE
	FROM [OW].[tblAlarmQueue]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessAlarm] PA
		 WHERE 	PA.[ProcessID] = @ProcessID 
		 AND PA.[ProcessAlarmID] = [OW].[tblAlarmQueue].[ProcessAlarmID]
		)	

	/* Eliminação dos alarmes para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE
		[ProcessID] = @ProcessID

	/* Eliminação das Referências para as etapas do processo a eliminar (Pelo comando anterior, não seria necessário efectuar) */
	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessStage] PS
		 WHERE PS.[ProcessID] = @ProcessID
		 AND PS.[ProcessStageID] = [OW].[tblProcessAlarm].[ProcessStageID]
		)

	/* Eliminação dos acessos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAccess]
	WHERE
		[ProcessID] = @ProcessID


	/* Eliminação dos documentos para o processo a eliminar */
	
	-- Obter documentos do processo
	select Distinct DocumentID 
	into #DocumentsToDelete
	from OW.tblDocumentVersion DV
	where exists (  select 1 from OW.tblProcessDocument PD
			where DV.DocumentVersionID = PD.DocumentVersionID
			and
			exists (select 1 from OW.tblProcessEvent PE
				where PD.ProcessEventID = PE.ProcessEventID
				and PE.ProcessID = @ProcessID
				)
			)

	-- Apagar referencias para os documentos
	DELETE
	FROM [OW].[tblProcessDocument]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessEvent] PE
		 WHERE PE.[ProcessID] = @ProcessID
		 AND PE.[ProcessEventID] = [OW].[tblProcessDocument].[ProcessEventID]
		)

	-- Apagar documentos do processo
	delete from OW.tblDocument
	where exists   (  
			select 1 from #DocumentsToDelete
			where OW.tblDocument.DocumentID = #DocumentsToDelete.DocumentID 
			)

	/* Eliminação das notificações para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessEventNotification]
	WHERE exists		
		(SELECT 1 FROM [OW].[tblProcessEvent] PE
		 WHERE PE.[ProcessID] = @ProcessID
		 AND PE.[ProcessEventID] = [OW].[tblProcessEventNotification].[ProcessEventID]
		)

	/* Eliminação dos campos do template associado aos campos do processo a eliminar */
	DELETE
	FROM [OW].[tblDocumentTemplateField]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessDynamicField] PDF
		 WHERE PDF.[ProcessID] = @ProcessID
		 AND PDF.[ProcessDynamicFieldID] = [OW].[tblDocumentTemplateField].[ProcessDynamicFieldID]
		)	

	/* Eliminação dos valores dos campos definidos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDynamicFieldValue]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessDynamicField] PDF
		 WHERE PDF.[ProcessID] = @ProcessID
		 AND PDF.[ProcessDynamicFieldID] = [OW].[tblProcessDynamicFieldValue].[ProcessDynamicFieldID]
		)	

	/* Eliminação das configurações dos campos nas etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStageDynamicField]
	WHERE exists
		(SELECT 1 FROM [OW].[tblProcessDynamicField]  PDF
		 WHERE PDF.[ProcessID] = @ProcessID
		 AND PDF.[ProcessDynamicFieldID] = [OW].[tblProcessStageDynamicField].[ProcessDynamicFieldID]
		)	

	/* Eliminação dos campos associados ao processo a eliminar*/
	DELETE
	FROM [OW].[tblProcessDynamicField]
	WHERE
		[ProcessID] = @ProcessID

	/* Eliminação dos eventos associados ao processo a eliminar */
	DELETE
	FROM [OW].[tblProcessEvent]
	WHERE
		[ProcessID] = @ProcessID


	/* Eliminação dos acessos definidos para as etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStageAccess]
	WHERE exists
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage] PS
		 WHERE PS.[ProcessID] = @ProcessID
		 AND PS.[ProcessStageID] = [OW].[tblProcessStageAccess].[ProcessStageID]
		)

	/* Eliminação das etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStage]
	WHERE
		[ProcessID] = @ProcessID
	
	/* Eliminação do processo */
	DELETE
	FROM [OW].[tblProcess]
	WHERE
		[ProcessID] = @ProcessID
		AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	
	/* Valida se foi encontrado o processo para eliminação */
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END

	COMMIT TRANSACTION 	
	RETURN @Err
END

GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO


IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'Extended procedures updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'Extended procedures update failed'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Indices
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

-- Added Indexes for [OW].tblAccess
-- Recomendado pela Microsoft
CREATE NONCLUSTERED INDEX [tblAccess_MS_01] ON [OW].[tblAccess] 
(
	[ObjectID] ASC,
	[UserID] ASC,
	[ObjectTypeID] ASC,
	[ObjectParentID] ASC,
	[ObjectType] ASC
)
go

CREATE NONCLUSTERED INDEX [tblAccess_MS_02] ON [OW].[tblAccess] 
(
	[ObjectID] ASC,
	[ObjectTypeID] ASC,
	[ObjectParentID] ASC,
	[ObjectType] ASC,
	[UserID] ASC
)
go

CREATE NONCLUSTERED INDEX [tblAccess_MS_03] ON [OW].[tblAccess] 
(
	[ObjectTypeID] ASC,
	[ObjectParentID] ASC,
	[ObjectType] ASC,
	[UserID] ASC,
	[ObjectID] ASC
)
go


-- Indexes for [OW].AlarmQueue
-- FALTA verificar para as FK mas não são usados

-- Indexes for [OW].Alert
-- Recomendado pela Microsoft
CREATE NONCLUSTERED INDEX [IX_TBLALERT05] ON [OW].[tblAlert] 
(
	[ProcessID] ASC,
	[ProcessStageID] ASC,
	[AlertID] ASC,
	[SendDateTime] ASC,
	[ReadDateTime] ASC,
	[UserID] ASC
)
go


-- Indexes for [OW].OWNotifyAgentRegister
-- NOT NEEDED

-- Indexes for [OW].ArchFields
-- NOT NEEDED

-- Indexes for [OW].ArchFieldsVsSpace
-- NOT NEEDED

-- Indexes for [OW].ArchFisicalAccessType
-- NOT NEEDED

-- Indexes for [OW].ArchFisicalInsert
-- NOT NEEDED

-- Indexes for [OW].ArchFisicalType
-- NOT NEEDED

-- Indexes for [OW].ArchInsertVsForm
-- NOT NEEDED

-- Indexes for [OW].ArchSpace
-- NOT NEEDED

-- Indexes for [OW].Books
-- NOT NEEDED

-- Indexes for [OW].Classification
-- NOT NEEDED

-- Indexes for [OW].ClassificationBooks
-- NOT NEEDED

-- Indexes for [OW].Country
-- NOT NEEDED

-- Added Indexes for [OW].DistribTemp
-- Recomendado pela Microsoft

CREATE NONCLUSTERED INDEX [tblDistribTemp_MS_01] ON [OW].[tblDistribTemp] 
(
	[GUID] ASC,
	[ID] ASC,
	[TmpID] ASC,
	[AutoDistribID] ASC,
	[AutoDistrib] ASC,
	[tipo] ASC
)
go


-- Indexes for [OW].District
-- NOT NEEDED

-- Indexes for [OW].Document
-- NOT NEEDED

-- Indexes for [OW].DocumentTemplate
CREATE NONCLUSTERED INDEX IX_tblDocumentTemplate03 ON OW.tblDocumentTemplate
(
	FileID
) 
GO

-- Indexes for [OW].DocumentTemplateField
-- NOT NEEDED

-- Indexes for [OW].DocumentVersion
-- NOT NEEDED

-- Indexes for [OW].DynamicField
CREATE NONCLUSTERED INDEX IX_tblDynamicField02 ON OW.tblDynamicField
(
	ListOfValuesID
) 
GO

-- Indexes for [OW].Entities
-- FALTA verificar para todas as FKs
-- Recomendado pela Microsoft

CREATE CLUSTERED INDEX [tblEntities_MS_01] ON [OW].[tblEntities] 
(
	[EntID] ASC,
	[Active] ASC
)
go


-- Indexes for [OW].EntitiesTemp
-- NOT NEEDED

-- Indexes for [OW].EntityType
-- NOT NEEDED

-- Indexes for [OW].ExceptionManagement
-- NOT NEEDED

-- Indexes for [OW].ExceptionManagementAddressee
-- NOT NEEDED

-- Indexes for [OW].FavoriteSearch
-- NOT NEEDED

-- Indexes for [OW].Flow
-- FALTA verificar para as FK FK_tblFlow_tblFlowDefinition e FK_tblFlow_tblOrganizationalUnit

-- Indexes for [OW].FlowDefinition
-- NOT NEEDED

-- Indexes for [OW].FlowMailConnector
-- NOT USED

-- Indexes for [OW].FlowPreBuiltStage
-- NOT USED

-- Indexes for [OW].FlowRouting
-- FALTA verificar para as FK FK_tblFlowDelegation_tblFlow, FK_tblFlowDelegation_tblOrganizationalUnit01 e FK_tblFlowDelegation_tblOrganizationalUnit02

-- Indexes for [OW].FlowStage
CREATE NONCLUSTERED INDEX IX_TBLFLOWSTAGE02 ON OW.tblFlowStage
(
	DocumentTemplateID
) 
GO

-- Indexes for [OW].Groups
-- NOT NEEDED

-- Indexes for [OW].GroupsUsers
-- NOT NEEDED (Ignorada a da Microsoft)

-- Indexes for [OW].Holiday
-- NOT NEEDED

-- Indexes for [OW].IdentityCB
-- NOT NEEDED

-- Indexes for [OW].ListOfValues
-- NOT NEEDED

-- Indexes for [OW].ListOfValuesItem
-- NOT NEEDED

-- Indexes for [OW].Module
-- NOT NEEDED

-- Indexes for [OW].OrganizationalUnit
-- NOT NEEDED

-- Indexes for [OW].Parameter
-- NOT NEEDED

-- Indexes for [OW].PostalCode
-- NOT NEEDED

-- Indexes for [OW].Process
-- FALTA verificar para as FK todas

-- Recomendado pela Microsoft
CREATE NONCLUSTERED INDEX [tblProcess_MS_01] ON [OW].[tblProcess] 
(
	[ProcessID] ASC,
	[ProcessNumber] ASC,
	[ProcessSubject] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcess_MS_02] ON [OW].[tblProcess] 
(
	[ProcessStatus] ASC,
	[FlowID] ASC,
	[ProcessID] ASC
)
go


-- Indexes for [OW].ProcessAccess
-- NOT NEEDED

-- Recomendado pela microsoft
CREATE NONCLUSTERED INDEX [tblProcessAccess_MS_01] ON [OW].[tblProcessAccess] 
(
	[OrganizationalUnitID] ASC,
	[ProcessAccessID] ASC,
	[FlowID] ASC,
	[ProcessID] ASC,
	[Remarks] ASC,
	[InsertedBy] ASC,
	[InsertedOn] ASC,
	[LastModifiedBy] ASC,
	[LastModifiedOn] ASC,
	[StartProcess] ASC,
	[ProcessDataAccess] ASC,
	[DynamicFieldAccess] ASC,
	[DocumentAccess] ASC,
	[DispatchAccess] ASC,
	[AccessObject] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcessAccess_MS_02] ON [OW].[tblProcessAccess] 
(
	[ProcessDataAccess] ASC,
	[AccessObject] ASC,
	[ProcessID] ASC
)
go


-- Indexes for [OW].ProcessAlarm
-- NOT NEEDED

-- Indexes for [OW].ProcessAlarmAddressee
CREATE NONCLUSTERED INDEX IX_TBLPROCESSALARMADDRESSEES02 ON OW.tblProcessAlarmAddressee
(
	OrganizationalUnitID
) 
GO

-- Indexes for [OW].ProcessCounter
-- NOT NEEDED

-- Indexes for [OW].ProcessDocument
-- NOT NEEDED

-- Indexes for [OW].ProcessDynamicField

drop index OW.tblProcessDynamicField.IX_TBLDYNAMICFIELDSETVALUEITEM01
GO

create unique  index IX_TBLPROCESSDYNAMICFIELD01 on OW.tblProcessDynamicField (
FlowID,
ProcessID,
DynamicFieldID,
FieldOrder
)
go

-- Indexes for [OW].ProcessDynamicFieldValue

create index IX_TBLPROCESSDYNAMICFIELDVALUE01 on OW.tblProcessDynamicFieldValue (ProcessDynamicFieldID)
GO

-- Indexes for [OW].ProcessEvent
-- FALTA verificar para as FK

create index IX_TBLPROCESSEVENT01 on OW.tblProcessEvent (
ProcessID
)
go

-- Recomendado pela Microsoft
CREATE NONCLUSTERED INDEX [tblProcessEvent_MS_01] ON [OW].[tblProcessEvent] 
(
	[OrganizationalUnitID] ASC,
	[ProcessEventStatus] ASC,
	[ProcessEventID] ASC,
	[ProcessStageID] ASC,
	[ProcessID] ASC,
	[CreationDate] ASC,
	[PreviousProcessEventID] ASC,
	[ReadDate] ASC,
	[ExecutionDate] ASC,
	[EndDate] ASC,
	[EstimatedDateToComplete] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcessEvent_MS_02] ON [OW].[tblProcessEvent] 
(
	[CreationDate] DESC,
	[ProcessEventStatus] ASC,
	[OrganizationalUnitID] ASC,
	[ProcessEventID] ASC,
	[ProcessStageID] ASC,
	[ProcessID] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcessEvent_MS_03] ON [OW].[tblProcessEvent] 
(
	[ProcessEventStatus] ASC,
	[OrganizationalUnitID] ASC,
	[ProcessStageID] ASC,
	[ProcessID] ASC,
	[ProcessEventID] ASC,
	[CreationDate] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcessEvent_MS_04] ON [OW].[tblProcessEvent] 
(
	[ProcessEventID] ASC,
	[ProcessStageID] ASC,
	[CreationDate] ASC,
	[OrganizationalUnitID] ASC,
	[ProcessID] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcessEvent_MS_05] ON [OW].[tblProcessEvent] 
(
	[ProcessEventStatus] ASC,
	[OrganizationalUnitID] ASC,
	[ProcessStageID] ASC,
	[ProcessID] ASC
)
go


-- Indexes for [OW].ProcessEventNotification
CREATE NONCLUSTERED INDEX IX_tblProcessEventNotification02 ON OW.tblProcessEventNotification
(
	UserID
) 
GO

-- Indexes for [OW].ProcessPriority
-- NOT NEEDED

-- Indexes for [OW].ProcessReference

create index IX_TBLPROCESSREFERENCE01 on OW.tblProcessReference (
ProcessEventID
)
go

create index IX_TBLPROCESSREFERENCE02 on OW.tblProcessReference (
ProcessReferedID
)
go

-- Indexes for [OW].ProcessStage
-- FALTA verificar para algumas FK

-- Recomendado pela Microsoft
CREATE NONCLUSTERED INDEX [tblProcessStage_MS_01] ON [OW].[tblProcessStage] 
(
	[ProcessStageID] ASC,
	[FlowStageType] ASC
)
go

CREATE NONCLUSTERED INDEX [tblProcessStage_MS_02] ON [OW].[tblProcessStage] 
(
	[FlowStageType] ASC,
	[ProcessStageID] ASC
)
go


-- Indexes for [OW].ProcessStageAccess
-- NOT NEEDED

-- Indexes for [OW].ProcessStageDynamicField

drop index OW.tblProcessStageDynamicField.IX_TBLPROCESSSTAGEDYNAMICFIELD01
GO
create unique  index IX_TBLPROCESSSTAGEDYNAMICFIELD01 on OW.tblProcessStageDynamicField (
ProcessStageID,
FlowStageID,
ProcessDynamicFieldID
)
go

create NONCLUSTERED  index IX_TBLPROCESSSTAGEDYNAMICFIELD02 on OW.tblProcessStageDynamicField (
ProcessDynamicFieldID
)
go

-- Indexes for [OW].Registry
-- FALTA verificar para todas as FK

-- Indexes for [OW].RegistryDistribution
-- FALTA verificar para todas as FK

-- Indexes for [OW].RegistryHist
-- FALTA verificar para todas as FK

-- Indexes for [OW].RequestAlarm
-- NOT NEEDED

-- Indexes for [OW].RequestAlarmAddressee
-- NOT NEEDED

-- Indexes for [OW].Resource
CREATE NONCLUSTERED INDEX IX_TBLRESOURCE02 ON OW.tblResource (
		ModuleID
) 
GO

-- Indexes for [OW].ResourceAccess

CREATE  INDEX [IX_TBLRESOURCEACCESS02] ON [OW].[tblResourceAccess]([OrganizationalUnitID])
GO


-- Indexes for [OW].User
-- FALTA verificar para as FK FK_tblUser_tblEntities e FK_tblUser_tblGroups (tblUser_MS_03 ou 04 resolve este)

-- Recomendado pela Microsoft
CREATE NONCLUSTERED INDEX [tblUser_MS_01] ON [OW].[tblUser] 
(
	[userID] ASC,
	[userLogin] ASC
)
go

CREATE NONCLUSTERED INDEX [tblUser_MS_02] ON [OW].[tblUser] 
(
	[userID] ASC,
	[userActive] ASC
)
go

CREATE NONCLUSTERED INDEX [tblUser_MS_03] ON [OW].[tblUser] 
(
	[userID] ASC,
	[PrimaryGroupID] ASC,
	[userDesc] ASC
)
go

CREATE NONCLUSTERED INDEX [tblUser_MS_04] ON [OW].[tblUser] 
(
	[userID] ASC,
	[PrimaryGroupID] ASC,
	[GroupHead] ASC
)
go

-- Indexes for [OW].UserSignature
-- NOT NEEDED

-- Indexes for [OW].UserSignatureAccess
-- NOT NEEDED

-- Indexes for [OW].WorkingPeriod
-- NOT NEEDED



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - SigmaNet
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO



ALTER PROCEDURE OW.usp_SetDistributionTemp
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
	DECLARE @DISTRIBUTION_ELECTRONIC_MAIL  	numeric
	DECLARE @DISTRIBUTION_OTHER_WAYS 		numeric
	DECLARE @DISTRIBUTION_SAP 			numeric
	DECLARE @DISTRIBUTION_ULTIMUS 			numeric
	DECLARE @DISTRIBUTION_WORKFLOW		numeric
	DECLARE @DISTRIBUTION_SGP			numeric
	DECLARE @DISTRIBUTION_EPROCESS		numeric
	DECLARE @DISTRIBUTION_SIGMANET		numeric
	
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
	SET @DISTRIBUTION_SIGMANET = 9

	BEGIN TRANSACTION
	
	/* ELECTRONIC MAIL */ /* WORKFLOW */ /* EPROCESS */ /*SIGMANET*/ 
	IF (@TypeID = @DISTRIBUTION_ELECTRONIC_MAIL )  OR (@TypeID = @DISTRIBUTION_WORKFLOW)  OR (@TypeID = @DISTRIBUTION_EPROCESS)  OR (@TypeID = @DISTRIBUTION_SIGMANET)
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

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - End SigmaNet
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Optimizações finais
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

-- Estes  comandos podem levar algum tempo

-- Exec sp_MSforeachtable 'dbcc dbreindex("?")'

-- exec sp_updatestats



DELETE FROM OW.tblProcessAccess 
WHERE 
flowid IS NOT NULL AND 
processid IS NULL AND 
StartProcess = 1 AND
ProcessDataAccess = 1 AND
DynamicFieldAccess = 1 AND
DocumentAccess = 1 AND
DocumentEditAccess = 1 AND
DispatchAccess = 1

DELETE FROM OW.tblProcessAccess 
WHERE 
flowid IS NULL AND 
processid IS NOT NULL AND 
ProcessDataAccess = 1 AND
DynamicFieldAccess = 1 AND
DocumentAccess = 1 AND
DocumentEditAccess = 1 AND
DispatchAccess = 1

DELETE
FROM         OW.tblProcessStageAccess
WHERE     (DocumentAccess = 1) AND (DispatchAccess = 1)

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

UPDATE OW.tblVersion SET version = '5.6.1' WHERE id= 1
GO

PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.6.0 PARA 5.6.1'
PRINT ''
GO
