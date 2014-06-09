-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.6.1 PARA A VERSÃO 5.7.0
--
-- ---------------------------------------------------------------------------------


PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.6.1 PARA 5.7.0'
PRINT ''
GO

ALTER PROCEDURE [OW].ProcessStageSelectEx01
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
	SET @sql = @sql + 'FROM  OW.tblProcessStage ps LEFT OUTER JOIN '
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




ALTER PROCEDURE [OW].FlowStageSelectEx01
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
		SET @sql = @sql + 'FROM [OW].[tblFlowStage] fs LEFT OUTER JOIN '
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




ALTER PROCEDURE [OW].ProcessEventSelectEx02
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
		SET @sql = @sql + '[OW].[tblProcessStage] ps ON (pe.[ProcessStageID] = ps.[ProcessStageID]) LEFT OUTER JOIN '
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
	SET @sql = @sql + 'OW.tblProcessStage ps ON pe.ProcessStageID = ps.ProcessStageID LEFT OUTER JOIN '
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


ALTER PROCEDURE [OW].ProcessReferenceSelectEx02
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
	SET @sql = @sql + 'OW.tblProcessStage ps ON pe.ProcessStageID = ps.ProcessStageID LEFT OUTER JOIN '
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


UPDATE OW.tblVersion SET version = '5.7.0' WHERE id= 1
GO

PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.6.1 PARA 5.7.0'
PRINT ''
GO
