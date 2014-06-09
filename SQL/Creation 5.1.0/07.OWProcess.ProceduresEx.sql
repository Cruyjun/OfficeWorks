IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlertSelectEx01;
GO
CREATE  PROCEDURE [OW].AlertSelectEx01
(
	------------------------------------------------------------------------
	--Devolve a lista de alertas de um utilizador para o Centro de Controlo
	--NOTA: Não usar este select para instaciar um objecto Business Alert,
	--este select não possui todas as colunas necessárias!!!
	--Updated: 24-04-2006 15:03:48
	--Version: 1.0	
	------------------------------------------------------------------------	
	@UserID int = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	
	SELECT AL.AlertID, 
		CASE WHEN AL.ProcessID IS NULL THEN PRS.ProcessNumber ELSE PR.ProcessNumber END ProcessNumber,
		CASE WHEN AL.ProcessID IS NULL THEN PRS.ProcessSubject ELSE PR.ProcessSubject END ProcessSubject,
		Al.SendDateTime,
		AL.ReadDateTime
	FROM OW.tblalert AL 
		LEFT OUTER JOIN OW.tblprocess PR ON (AL.ProcessID = PR.ProcessID)
		LEFT OUTER JOIN OW.tblprocessstage PS ON (AL.ProcessStageID = PS.ProcessStageID)
		LEFT OUTER JOIN OW.tblprocess PRS ON (PS.ProcessID = PRS.ProcessID)
	WHERE		
		(@UserID IS NULL OR [UserID] = @UserID)

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertSelectEx01 Error on Creation'
GO























IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventSelectEx01;
GO

CREATE PROCEDURE [OW].ProcessEventSelectEx01

	------------------------------------------------------------------------	
	--Description: Select all automatic events to complete (used by the OWService)
	--Updated: 22-01-2006 09:17:24
	--Version: 1.1	
	------------------------------------------------------------------------	

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		PE.[ProcessEventID],
		PE.[ProcessStageID],
		PE.[ProcessID],
		PE.[RoutingType],
		PE.[ProcessEventStatus],
		PE.[PreviousProcessEventID],
		PE.[NextProcessEventID],
		PE.[CreationDate],
		PE.[ReadDate],
		PE.[EstimatedDateToComplete],
		PE.[OrganizationalUnitID],
		PE.[ExecutionDate],
		PE.[EndDate],
		PE.[WorkflowActionType],
		PE.[WorkflowInfo],
		PE.[Remarks],
		PE.[InsertedBy],
		PE.[InsertedOn],
		PE.[LastModifiedBy],
		PE.[LastModifiedOn]
	FROM ([OW].[tblProcessEvent] PE INNER JOIN [OW].[tblProcessStage] PS 
		ON (PE.[ProcessStageID] = PS.[ProcessStageID])) INNER JOIN [OW].[tblProcess] PR 
		ON (PS.[ProcessID] = PR.[ProcessID])
	WHERE
		PR.[ProcessStatus] = 1 AND -- Active
		PS.[FlowStageType] <> 1 AND -- WebForm 
		PE.[ProcessEventStatus] IN (1, 2) -- New, Active

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventSelectEx01 Error on Creation'
GO





IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmSelectEx01;
GO

CREATE PROCEDURE [OW].ProcessAlarmSelectEx01
(
	------------------------------------------------------------------------	
	--Updated: 17-02-2006 11:17:24
	--Version: 1.1	
	------------------------------------------------------------------------
	@LaunchDateTime datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1000
		PA.[ProcessAlarmID],
		PA.[FlowID],
		PA.[FlowStageID],
		PA.[ProcessID],
		PA.[ProcessStageID],
		PA.[Occurence],
		PA.[OccurenceOffset],
		PA.[Message],
		PA.[AlertByEMail],
		PA.[AddresseeExecutant],
		PA.[AddresseeFlowOwner],
		PA.[AddresseeProcessOwner],
		PA.[Remarks],
		PA.[InsertedBy],
		PA.[InsertedOn],
		PA.[LastModifiedBy],
		PA.[LastModifiedOn]
	FROM [OW].[tblProcessAlarm] PA INNER JOIN [OW].[tblAlarmQueue] AQ
		ON (PA.ProcessAlarmID = AQ.ProcessAlarmID)
	WHERE
		(@LaunchDateTime IS NULL OR AQ.[LaunchDateTime] <= @LaunchDateTime)

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmSelectEx01 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueSelectEx01;
GO

CREATE PROCEDURE [OW].AlarmQueueSelectEx01
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

	SELECT
		AQ.[AlertQueueID],
		AQ.[LaunchDateTime],
		AQ.[ProcessAlarmID],
		AQ.[Remarks],
		AQ.[InsertedBy],
		AQ.[InsertedOn],
		AQ.[LastModifiedBy],
		AQ.[LastModifiedOn]
	FROM [OW].[tblAlarmQueue] AQ INNER JOIN [OW].[tblProcessAlarm] PA 
		ON (AQ.ProcessAlarmID = PA.ProcessAlarmID)
	WHERE
		(@AlertQueueID IS NULL OR AQ.[AlertQueueID] = @AlertQueueID) AND
		(@LaunchDateTime IS NULL OR AQ.[LaunchDateTime] <= @LaunchDateTime) AND
		(@ProcessAlarmID IS NULL OR AQ.[ProcessAlarmID] = @ProcessAlarmID) AND
		(@Remarks IS NULL OR AQ.[Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR AQ.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR AQ.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR AQ.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR AQ.[LastModifiedOn] = @LastModifiedOn) AND
		(@ProcessID IS NULL OR PA.[ProcessID] = @ProcessID) AND
		(@ProcessStageID IS NULL OR PA.[ProcessStageID] = @ProcessStageID)

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueDeleteEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueDeleteEx01;
GO

CREATE PROCEDURE [OW].AlarmQueueDeleteEx01
(
	------------------------------------------------------------------------	
	--Updated: 22-02-2006 22:33:48
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblAlarmQueue]
	WHERE
		[ProcessAlarmID] = @ProcessAlarmID

	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueDeleteEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueDeleteEx01 Error on Creation'
GO





IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldSelectEx01;
GO

CREATE PROCEDURE [OW].DynamicFieldSelectEx01
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

	SELECT
		DynamicField.DynamicFieldID, 
		DynamicField.[Description], 
		DynamicFieldType.[Description] AS DynamicFieldTypeDescription, 
		DynamicField.[Precision], 
		DynamicField.Scale
	FROM OW.tblDynamicField DynamicField
	INNER JOIN OW.vDynamicFieldType DynamicFieldType
	ON DynamicField.DynamicFieldTypeID = DynamicFieldType.[ID]	
	WHERE
		(@DynamicFieldID IS NULL OR DynamicField.DynamicFieldID = @DynamicFieldID) AND
		(@Description IS NULL OR DynamicField.[Description] LIKE @Description) AND
		(@DynamicFieldTypeID IS NULL OR DynamicFieldType.[ID] LIKE @DynamicFieldTypeID) AND
		(@ListOfValuesID IS NULL OR DynamicField.[ListOfValuesID] LIKE @ListOfValuesID) AND
		(@FlowID IS NULL OR 
			EXISTS (SELECT 1 FROM OW.tblProcessDynamicField ProcessDynamicField 
					WHERE DynamicField.DynamicFieldID = ProcessDynamicField.DynamicFieldID AND
						ProcessDynamicField.FlowID = @FlowID))

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldSelectPagingEx01;
GO

CREATE PROCEDURE [OW].DynamicFieldSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 31-01-2006 15:28:50
	--Version: 1.0	
	------------------------------------------------------------------------
	@DynamicFieldID int = NULL,
	@Description varchar(80) = NULL,
	@DynamicFieldTypeID int = NULL,
	@ListOfValuesID int = NULL,
	@FlowID int = NULL,
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
	
	IF(@DynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '(DynamicField.[DynamicFieldID] = @DynamicFieldID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '(DynamicField.[Description] LIKE @Description) AND '
	IF(@DynamicFieldTypeID IS NOT NULL) SET @WHERE = @WHERE + '(DynamicFieldType.[ID] LIKE @DynamicFieldTypeID) AND '
	IF(@ListOfValuesID IS NOT NULL) SET @WHERE = @WHERE + '(DynamicField.[ListOfValuesID] = @ListOfValuesID) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '(EXISTS (SELECT 1 FROM OW.tblProcessDynamicField ProcessDynamicField 
					WHERE DynamicField.DynamicFieldID = ProcessDynamicField.DynamicFieldID AND
						ProcessDynamicField.FlowID = @FlowID)) AND '
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(DynamicField.[DynamicFieldID]) 
	FROM OW.tblDynamicField DynamicField
	INNER JOIN OW.vDynamicFieldType DynamicFieldType
	ON DynamicField.DynamicFieldTypeID = DynamicFieldType.[ID] 	
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	
	
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@DynamicFieldID int, 
		@Description varchar(80), 
		@DynamicFieldTypeID int, 
		@ListOfValuesID int, 
		@FlowID int,
		@RowCount bigint OUTPUT',
		@DynamicFieldID, 
		@Description, 
		@DynamicFieldTypeID, 
		@ListOfValuesID, 
		@FlowID,
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
	WHERE DynamicField.[DynamicFieldID] IN (
		SELECT TOP ' + @SizeString + ' DynamicField.[DynamicFieldID]
				FROM OW.tblDynamicField DynamicField
				INNER JOIN OW.vDynamicFieldType DynamicFieldType
				ON DynamicField.DynamicFieldTypeID = DynamicFieldType.[ID] 				
			WHERE DynamicField.[DynamicFieldID] NOT IN (
				SELECT TOP ' + @PrevString + ' DynamicField.[DynamicFieldID] 
					FROM OW.tblDynamicField DynamicField
					INNER JOIN OW.vDynamicFieldType DynamicFieldType
					ON DynamicField.DynamicFieldTypeID = DynamicFieldType.[ID] 					
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END

	SET @SELECT = '
	SELECT
		DynamicField.[DynamicFieldID], 
		DynamicField.[Description], 
		DynamicFieldType.[Description] AS DynamicFieldTypeDescription, 
		DynamicField.[Precision], 
		DynamicField.Scale
	FROM OW.tblDynamicField DynamicField
	INNER JOIN OW.vDynamicFieldType DynamicFieldType
	ON DynamicField.DynamicFieldTypeID = DynamicFieldType.[ID] 	
	' + @WPag
	
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldSelectPagingEx01 Error on Creation'
GO








IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('OW.fnGetEntityListIDs') AND sysstat & 0xf = 0)
    DROP FUNCTION OW.fnGetEntityListIDs;
GO


CREATE  FUNCTION OW.fnGetEntityListIDs (@UserID INT)
RETURNS TABLE
AS

RETURN 
(
	------------------------------------------------------------------------
	--Updated: 09-03-2006 10:36:40
	--Version: 1.6
	------------------------------------------------------------------------

SELECT ListID FROM OW.tblEntityList LST
WHERE (
	EXISTS (SELECT 1 FROM OW.tblEntityListAccess LAa
		  WHERE 	
			LAa.ObjectParentID = LST.ListID						
			AND objectID = @UserID
			AND ObjectType = 1 
		 	AND AccessType >= 2)

	OR EXISTS (SELECT 1 FROM OW.tblEntityListAccess LAb
		   WHERE 
			  LAb.ObjectParentID = LST.ListID
			  AND EXISTS (SELECT 1 FROM OW.tblGroupsUsers 
					WHERE GroupID = LAb.objectID 
					AND userID = @UserID)
			  AND ObjectType = 2
			  AND AccessType >= 2)
	OR ([global]=1 AND EXISTS (SELECT ObjectID FROM OW.tblAccess 
					WHERE userID = @UserID
					AND ObjectID >= 2 -- ROLE
					AND ObjectTypeID=1 -- TYPE_PRODUCT
					AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
			   	   ) 
	   )
	)	
  
)
GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnGetEntityListIDs Succeeded'
ELSE PRINT 'Function Creation: [OW].fnGetEntityListIDs Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesSelectEx01;
GO


CREATE  PROCEDURE [OW].EntitiesSelectEx01
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
	WHERE
		(@EntID IS NULL OR ent.[EntID] = @EntID) AND
		(@PublicCode IS NULL OR ent.[PublicCode] LIKE @PublicCode) AND
		(@Name IS NULL OR ent.[Name] LIKE @Name) AND
		(@FirstName IS NULL OR ent.[FirstName] LIKE @FirstName) AND
		(@MiddleName IS NULL OR ent.[MiddleName] LIKE @MiddleName) AND
		(@LastName IS NULL OR ent.[LastName] LIKE @LastName) AND
		(@ListID IS NULL OR ent.[ListID] = @ListID) AND
		(@BI IS NULL OR ent.[BI] LIKE @BI) AND
		(@NumContribuinte IS NULL OR ent.[NumContribuinte] LIKE @NumContribuinte) AND
		(@AssociateNum IS NULL OR ent.[AssociateNum] = @AssociateNum) AND
		(@eMail IS NULL OR ent.[eMail] LIKE @eMail) AND
		(@InternetSite IS NULL OR ent.[InternetSite] = @InternetSite) AND
		(@JobTitle IS NULL OR ent.[JobTitle] LIKE @JobTitle) AND
		(@Street IS NULL OR ent.[Street] LIKE @Street) AND
		(@PostalCodeID IS NULL OR ent.[PostalCodeID] = @PostalCodeID) AND
		(@CountryID IS NULL OR ent.[CountryID] = @CountryID) AND
		(@Phone IS NULL OR ent.[Phone] LIKE @Phone) AND
		(@Fax IS NULL OR ent.[Fax] LIKE @Fax) AND
		(@Mobile IS NULL OR ent.[Mobile] LIKE @Mobile) AND
		(@DistrictID IS NULL OR ent.[DistrictID] = @DistrictID) AND
		(@EntityID IS NULL OR ent.[EntityID] = @EntityID) AND
		(@EntityTypeID IS NULL OR ent.[EntityTypeID] = @EntityTypeID) AND
		(@Active IS NULL OR ent.[Active] = @Active) AND
		(@Type IS NULL OR ent.[Type] = @Type) AND
		(@BIEmissionDate IS NULL OR ent.[BIEmissionDate] = @BIEmissionDate) AND
		(@BIArquiveID IS NULL OR ent.[BIArquiveID] = @BIArquiveID) AND
		(@JobPositionID IS NULL OR ent.[JobPositionID] = @JobPositionID) AND
		(@LocationID IS NULL OR ent.[LocationID] = @LocationID) AND
		(@Contact IS NULL OR ent.[Contact] LIKE @Contact) AND
		(@Remarks IS NULL OR ent.[Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR ent.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR ent.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR ent.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR ent.[LastModifiedOn] = @LastModifiedOn) AND		
		(@UserID IS NULL OR EXISTS(SELECT 1 FROM OW.fnGetEntityListIDs(@UserID) lst WHERE ent.ListID = lst.ListID))

	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesSelectEx01 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesSelectPagingEx01;
GO


CREATE  PROCEDURE [OW].EntitiesSelectPagingEx01
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesSelectPagingEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorSelectEx01;
GO

CREATE PROCEDURE [OW].FlowMailConnectorSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 05-12-2005 10:17:51
	--Version: 1.0	
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

	SELECT
		fmc.[MailConnectorID],
		fmc.[Folder],
		fd.[Description],
		fmc.[Active]
	FROM OW.tblFlowMailConnector fmc
	INNER JOIN OW.tblFlow f
	ON fmc.FlowID = f.FlowID
	INNER JOIN OW.tblFlowDefinition fd
	ON f.FlowDefinitionID = fd.FlowDefinitionID
	WHERE
		(@MailConnectorID IS NULL OR fmc.[MailConnectorID] = @MailConnectorID) AND
		(@Folder IS NULL OR fmc.[Folder] LIKE @Folder) AND
		(@Description IS NULL OR fd.[Description] LIKE @Description) AND
		(@Active IS NULL OR fmc.[Active] = @Active) AND
		(fmc.FlowID = 1) AND (fmc.Active = 0)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorSelectPagingEx01;
GO

CREATE PROCEDURE [OW].FlowMailConnectorSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 05-12-2005 10:17:51
	--Version: 1.0	
	------------------------------------------------------------------------
	@MailConnectorID int = NULL,
	@Folder varchar(255) = NULL,
	@Description varchar(80) = NULL,
	@Active bit = NULL,
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
	
	IF(@MailConnectorID IS NOT NULL) SET @WHERE = @WHERE + '(fmc.[MailConnectorID] = @MailConnectorID) AND '
	IF(@Folder IS NOT NULL) SET @WHERE = @WHERE + '(fmc.[Folder] LIKE @Folder) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '(fd.[Description] LIKE @Description) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '(fmc.[Active] = @Active) AND '
	--Extra
	SET @WHERE = @WHERE + '(fmc.FlowID = 1) AND (fmc.Active = 0) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(fmc.[MailConnectorID]) 
	FROM OW.tblFlowMailConnector fmc
	INNER JOIN OW.tblFlow f
	ON fmc.FlowID = f.FlowID
	INNER JOIN OW.tblFlowDefinition fd
	ON f.FlowDefinitionID = fd.FlowDefinitionID
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@MailConnectorID int, 
		@Folder varchar(255), 
		@Description varchar(80), 
		@Active bit,
		@RowCount bigint OUTPUT',
		@MailConnectorID, 
		@Folder, 
		@Description, 
		@Active,
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
	WHERE fmc.[MailConnectorID] IN (
		SELECT TOP ' + @SizeString + ' fmc.[MailConnectorID]
				FROM OW.tblFlowMailConnector fmc
				INNER JOIN OW.tblFlow f
				ON fmc.FlowID = f.FlowID
				INNER JOIN OW.tblFlowDefinition fd
				ON f.FlowDefinitionID = fd.FlowDefinitionID
			WHERE fmc.[MailConnectorID] NOT IN (
				SELECT TOP ' + @PrevString + ' fmc.[MailConnectorID] 
					FROM OW.tblFlowMailConnector fmc
					INNER JOIN OW.tblFlow f
					ON fmc.FlowID = f.FlowID
					INNER JOIN OW.tblFlowDefinition fd
					ON f.FlowDefinitionID = fd.FlowDefinitionID
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		fmc.MailConnectorID,
		fmc.Folder,
		fd.Description,
		fmc.Active
	FROM OW.tblFlowMailConnector fmc
	INNER JOIN OW.tblFlow f
	ON fmc.FlowID = f.FlowID
	INNER JOIN OW.tblFlowDefinition fd
	ON f.FlowDefinitionID = fd.FlowDefinitionID
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@MailConnectorID int, 
		@Folder varchar(255), 
		@Description varchar(80), 
		@Active bit',
		@MailConnectorID, 
		@Folder, 
		@Description, 
		@Active
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorSelectPagingEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsSelectEx01;
GO

CREATE PROCEDURE [OW].GroupsSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 19-12-2005 15:40:51
	--Version: 1.0	
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

	SELECT
		Groups.[GroupID],
		Groups.[GroupDesc],
		Groups.[ShortName]
	FROM [OW].[tblGroups] Groups INNER JOIN 
		[OW].[tblOrganizationalUnit] OrganizationalUnit 
		ON (Groups.[GroupID] = OrganizationalUnit.[GroupID])
	WHERE
		(@GroupID IS NULL OR Groups.[GroupID] = @GroupID) AND
		(@HierarchyID IS NULL OR Groups.[HierarchyID] = @HierarchyID) AND
		(@ShortName IS NULL OR Groups.[ShortName] LIKE @ShortName) AND
		(@GroupDesc IS NULL OR Groups.[GroupDesc] LIKE @GroupDesc)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsSelectPagingEx01;
GO

CREATE PROCEDURE [OW].GroupsSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 19-12-2005 15:40:51
	--Version: 1.0	
	------------------------------------------------------------------------
	@GroupID int = NULL,
	@HierarchyID int = NULL,
	@ShortName varchar(10) = NULL,
	@GroupDesc varchar(100) = NULL,
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
	
	IF(@GroupID IS NOT NULL) SET @WHERE = @WHERE + '(Groups.[GroupID] = @GroupID) AND '
	IF(@HierarchyID IS NOT NULL) SET @WHERE = @WHERE + '(Groups.[HierarchyID] = @HierarchyID) AND '
	IF(@ShortName IS NOT NULL) SET @WHERE = @WHERE + '(Groups.[ShortName] LIKE @ShortName) AND '
	IF(@GroupDesc IS NOT NULL) SET @WHERE = @WHERE + '(Groups.[GroupDesc] LIKE @GroupDesc) AND '


	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(Groups.[GroupID]) 
	FROM [OW].[tblGroups] Groups INNER JOIN 
		[OW].[tblOrganizationalUnit] OrganizationalUnit 
		ON (Groups.[GroupID] = OrganizationalUnit.[GroupID])
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@GroupID int, 
		@HierarchyID int,
		@ShortName varchar(10),
		@GroupDesc varchar(100), 
		@RowCount bigint OUTPUT',
		@GroupID, 
		@HierarchyID,
		@ShortName,
		@GroupDesc, 
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
	WHERE Groups.[GroupID] IN (
		SELECT TOP ' + @SizeString + ' Groups.[GroupID]
			FROM [OW].[tblGroups] Groups INNER JOIN 
		[OW].[tblOrganizationalUnit] OrganizationalUnit 
		ON (Groups.[GroupID] = OrganizationalUnit.[GroupID])
			WHERE Groups.[GroupID] NOT IN (
				SELECT TOP ' + @PrevString + ' Groups.[GroupID] 
				FROM [OW].[tblGroups] Groups INNER JOIN 
					[OW].[tblOrganizationalUnit] OrganizationalUnit 
					ON (Groups.[GroupID] = OrganizationalUnit.[GroupID])
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		Groups.[GroupID], 
		Groups.[GroupDesc], 
		Groups.[ShortName]
	FROM [OW].[tblGroups] Groups INNER JOIN 
		[OW].[tblOrganizationalUnit] OrganizationalUnit 
		ON (Groups.[GroupID] = OrganizationalUnit.[GroupID])
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsSelectPagingEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesSelectEx01;
GO

CREATE PROCEDURE [OW].ListOfValuesSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 05-12-2005 10:17:51
	--Version: 1.0	
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL,
	@Description varchar(50) = NULL,
	@ListOfValuesTypeDescription varchar(80) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		lov.[ListOfValuesID],
		lov.[Description],
		lovt.[Description] AS ListOfValuesTypeDescription
	FROM OW.tblListOfValues lov
	INNER JOIN OW.vListOfValuesType lovt
	ON lov.Type = lovt.[ID]
	WHERE
		(@ListOfValuesID IS NULL OR lov.[ListOfValuesID] = @ListOfValuesID) AND
		(@Description IS NULL OR lov.[Description] LIKE @Description) AND
		(@ListOfValuesTypeDescription IS NULL OR lovt.[Description] LIKE @ListOfValuesTypeDescription)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesSelectPagingEx01;
GO

CREATE PROCEDURE [OW].ListOfValuesSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 20-12-2005 13:01:51
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL,
	@Description varchar(50) = NULL,
	@ListOfValuesTypeDescription varchar(80) = NULL,
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
	
	IF(@ListOfValuesID IS NOT NULL) SET @WHERE = @WHERE + '(lov.[ListOfValuesID] = @ListOfValuesID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '(lov.[Description] LIKE @Description) AND '
	IF(@ListOfValuesTypeDescription IS NOT NULL) SET @WHERE = @WHERE + '(lovt.[Description] LIKE @ListOfValuesTypeDescription) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(lov.[ListOfValuesID]) 
	FROM OW.tblListOfValues lov
	INNER JOIN OW.vListOfValuesType lovt
	ON lov.Type = lovt.[ID]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ListOfValuesID int, 
		@Description varchar(50), 
		@ListOfValuesTypeDescription varchar(80),
		@RowCount bigint OUTPUT',
		@ListOfValuesID, 
		@Description, 
		@ListOfValuesTypeDescription,
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
	WHERE lov.[ListOfValuesID] IN (
		SELECT TOP ' + @SizeString + ' lov.[ListOfValuesID]
				FROM OW.tblListOfValues lov
				INNER JOIN OW.vListOfValuesType lovt
				ON lov.Type = lovt.[ID]
			WHERE lov.[ListOfValuesID] NOT IN (
				SELECT TOP ' + @PrevString + ' lov.[ListOfValuesID] 
					FROM OW.tblListOfValues lov
					INNER JOIN OW.vListOfValuesType lovt
					ON lov.Type = lovt.[ID]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		lov.[ListOfValuesID],
		lov.[Description],
		lovt.[Description] AS ListOfValuesTypeDescription
	FROM OW.tblListOfValues lov
	INNER JOIN OW.vListOfValuesType lovt
	ON lov.Type = lovt.[ID]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesSelectPagingEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterSelectEx01;
GO

CREATE PROCEDURE [OW].ParameterSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 05-12-2005 10:17:51
	--Version: 1.0	
	------------------------------------------------------------------------
	@ParameterID int = NULL,
	@Description varchar(80) = NULL,
	@Value numeric(18,3) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ParameterID],
		[Description],
		COALESCE (NumericValue, AlphaNumericValue) AS 'Value'
	FROM [OW].[tblParameter]
	WHERE
		(@ParameterID IS NULL OR [ParameterID] = @ParameterID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Value IS NULL OR COALESCE (NumericValue, AlphaNumericValue) = @Value)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterSelectPagingEx01;
GO

CREATE PROCEDURE [OW].ParameterSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 05-12-2005 10:17:51
	--Version: 1.0	
	------------------------------------------------------------------------
	@ParameterID int = NULL,
	@Description varchar(80) = NULL,
	@Value numeric(18,3) = NULL,
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
	
	IF(@ParameterID IS NOT NULL) SET @WHERE = @WHERE + '([ParameterID] = @ParameterID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Value IS NOT NULL) SET @WHERE = @WHERE + '(COALESCE (NumericValue, AlphaNumericValue) = @Value) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ParameterID) 
	FROM [OW].[tblParameter]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ParameterID int, 
		@Description varchar(80), 
		@Value numeric(18,3),
		@RowCount bigint OUTPUT',
		@ParameterID, 
		@Description, 
		@Value,
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
	WHERE ParameterID IN (
		SELECT TOP ' + @SizeString + ' ParameterID
			FROM [OW].[tblParameter]
			WHERE ParameterID NOT IN (
				SELECT TOP ' + @PrevString + ' ParameterID 
				FROM [OW].[tblParameter]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ParameterID], 
		[Description], 
		COALESCE (NumericValue, AlphaNumericValue) AS ''Value''
	FROM [OW].[tblParameter]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterSelectPagingEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceSelectEx01;
GO

CREATE PROCEDURE [OW].ResourceSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 20-01-2006 16:17:51
	--Version: 1.1	
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

	SELECT
		r.[ResourceID],
		r.[ModuleID],
		m.[Description] AS ModuleDescription,
		r.[Description],
		r.[Active]
	FROM OW.tblResource r
	INNER JOIN OW.tblModule m
	ON r.ModuleID = m.ModuleID
	WHERE
		(@ResourceID IS NULL OR r.[ResourceID] = @ResourceID) AND
		(@ModuleID IS NULL OR r.[ModuleID] = @ModuleID) AND
		(@Description IS NULL OR r.[Description] LIKE @Description) AND
		(@Active IS NULL OR r.[Active] = @Active) AND
		(@Remarks IS NULL OR r.[Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR r.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR r.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR r.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR r.[LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceSelectPagingEx01;
GO

CREATE PROCEDURE [OW].ResourceSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 25-01-2006 11:20:51
	--Version: 1.2
	------------------------------------------------------------------------
	@ResourceID int = NULL,
	@ModuleID int = NULL,
	@Description varchar(80) = NULL,
	@Active smallint = NULL,
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
	SET @WHERE = 'WHERE '
	
	IF(@ResourceID IS NOT NULL) SET @WHERE = @WHERE + '(r.[ResourceID] = @ResourceID) AND '
	IF(@ModuleID IS NOT NULL) SET @WHERE = @WHERE + '(r.[ModuleID] = @ModuleID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '(r.[Description] LIKE @Description) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '(r.[Active] = @Active) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '(r.[Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '(r.[InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '(r.[InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '(r.[LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '(r.[LastModifiedOn] = @LastModifiedOn) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(r.ResourceID) 
	FROM [OW].[tblResource] r
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ResourceID int,  
		@ModuleID int, 
		@Description varchar(80), 
		@Active smallint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ResourceID,
		@ModuleID, 
		@Description, 
		@Active, 
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
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE r.ResourceID IN (
		SELECT TOP ' + @SizeString + ' r.ResourceID
			FROM [OW].[tblResource] r
			INNER JOIN OW.tblModule m
			ON r.ModuleID = m.ModuleID
			WHERE r.ResourceID NOT IN (
				SELECT TOP ' + @PrevString + ' r.ResourceID 
				FROM [OW].[tblResource] r
				INNER JOIN OW.tblModule m
				ON r.ModuleID = m.ModuleID
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
		SELECT
		r.[ResourceID],
		r.[ModuleID],
		m.[Description] AS ModuleDescription,
		r.[Description],
		r.[Active]
	FROM OW.tblResource r
	INNER JOIN OW.tblModule m
	ON r.ModuleID = m.ModuleID
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceSelectEx01Paging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceSelectEx01Paging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelectEx01;
GO

CREATE PROCEDURE [OW].UserSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 20-12-2005 14:09:51
	--Version: 1.1	
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

	SELECT DISTINCT
		u.UserID,
		u.UserDesc,
		u.UserMail,
		u.Phone,
		u.Fax,
		u.UserLogin
	FROM OW.tblUser u
	INNER JOIN OW.tblOrganizationalUnit o
	ON u.UserID = o.UserID
	WHERE
		(@UserID IS NULL OR u.[UserID] = @UserID) AND
		(@UserDesc IS NULL OR u.[UserDesc] LIKE @UserDesc) AND
		(@UserMail IS NULL OR u.[UserMail] LIKE @UserMail) AND
		(@Phone IS NULL OR u.[Phone] LIKE @Phone) AND
		(@Fax IS NULL OR u.[Fax] LIKE @Fax) AND
		(@UserLogin IS NULL OR u.[UserLogin] LIKE @UserLogin) AND
		(@PrimaryGroupID IS NULL OR u.[PrimaryGroupID] LIKE @PrimaryGroupID)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectEx01 Error on Creation'
GO





IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelectEx02;
GO

CREATE  PROCEDURE [OW].UserSelectEx02
(
	------------------------------------------------------------------------	
	--Updated: 17-02-2006 14:17:25
	--Version: 1.1	
	--Description: Select all Alarm Destination Users
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @ProcessID INT
	DECLARE @ProcessFlowID INT
	DECLARE @ProcessStageID INT 
	DECLARE @AddresseeExecutant BIT
	DECLARE @AddresseeProcessOwner BIT
	DECLARE @AddresseeFlowOwner BIT
	
	
	-- Get Vars -------------------------------------------------
	SELECT 
		@ProcessID = ProcessID, 
		@ProcessStageID = ProcessStageID,
		@AddresseeExecutant = AddresseeExecutant,
		@AddresseeFlowOwner = AddresseeFlowOwner,
		@AddresseeProcessOwner = AddresseeProcessOwner
	FROM OW.tblProcessAlarm	
	WHERE 	
		ProcessAlarmID = @ProcessAlarmID
	
	SELECT 
		@ProcessFlowID = FlowID
	FROM OW.tblProcess
	WHERE 
		ProcessID = @ProcessID
	--------------------------------------------------------------

	SELECT
		[userID],
		[PrimaryGroupID],
		[userDesc],
		[userMail],
		[Phone],
		[MobilePhone],
		[Fax],
		[NotifyByMail],
		[NotifyBySMS],
		[userLogin],
		[Password],
		[EntityID],
		[TextSignature],
		[GroupHead],
		[userActive],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblUser] USR
	WHERE
		EXISTS(


			
			-- USERS Addressee ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM 			
				OW.tblProcessAlarmAddressee AA INNER JOIN OW.tblOrganizationalUnit OU			
				ON (AA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])			
			WHERE 
				AA.[ProcessAlarmID] = @ProcessAlarmID AND
				OU.[UserID] = USR.[UserID]		
			UNION
			-- GORUP USERS Addressee
			SELECT GU.[UserID] FROM 			
				(OW.tblProcessAlarmAddressee AA 
				INNER JOIN OW.tblOrganizationalUnit OU 
				ON (AA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])) 
			
			INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				AA.[ProcessAlarmID] = @ProcessAlarmID AND
				OU.[UserID] = USR.[UserID] 
				
			
			UNION
			
			
			
			
			-- USERS Executant ---------------------------------------------------------------
			SELECT OU.[UserID] FROM			
				OW.tblProcessEvent PE INNER JOIN OW.tblOrganizationalUnit OU			
				ON (PE.[OrganizationalUnitID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeExecutant = 1 AND
				PE.[ProcessID] = @ProcessID AND 
				(@ProcessStageID IS NULL OR PE.[ProcessStageID] = @ProcessStageID) AND
				PE.[ProcessEventStatus] IN (1,2) AND --(New,Active)
				OU.[UserID] = USR.[UserID]			
			UNION
			-- GORUP USERS Executant
			SELECT GU.[UserID] FROM			
				(OW.tblProcessEvent PE 
				INNER JOIN OW.tblOrganizationalUnit OU 
				ON (PE.[OrganizationalUnitID] = OU.[OrganizationalUnitID]))			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeExecutant = 1 AND
				PE.[ProcessID] = @ProcessID AND
				(@ProcessStageID IS NULL OR PE.[ProcessStageID] = @ProcessStageID) AND
				PE.[ProcessEventStatus] IN (1,2) AND --(New,Active)
				OU.[UserID] = USR.[UserID]
				
			
			
			UNION
			
			
			
			
			
			-- USERS PROCESS OWNER ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM 			
				OW.tblProcess PR INNER JOIN OW.tblOrganizationalUnit OU			
				ON (PR.[ProcessOwnerID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeProcessOwner = 1 AND
				PR.[ProcessID] = @ProcessID AND
				OU.[UserID] = USR.[UserID]			
			UNION
			-- GORUP USERS PROCESS OWNER
			SELECT GU.[UserID] FROM 			
				(OW.tblProcess PR INNER JOIN OW.tblOrganizationalUnit OU 
					ON (PR.[ProcessOwnerID] = OU.[OrganizationalUnitID]))			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeProcessOwner = 1 AND
				PR.[ProcessID] = @ProcessID AND
				OU.[UserID] = USR.[UserID]
				
				

			UNION
			

			
			-- USERS FLOW OWNER ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM			
				OW.tblFlow FL INNER JOIN OW.tblOrganizationalUnit OU			
				ON (FL.[FlowOwnerID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeFlowOwner = 1 AND
				FL.[FlowID] = @ProcessFlowID AND
				OU.[UserID] = USR.[UserID]			
			UNION
			-- GORUP USERS PROCESS OWNER
			SELECT GU.[UserID] FROM 			
				(OW.tblFlow FL INNER JOIN OW.tblOrganizationalUnit OU 
				ON (FL.[FlowOwnerID] = OU.[OrganizationalUnitID])) 			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeFlowOwner = 1 AND
				FL.[FlowID] = @ProcessFlowID AND
				OU.[UserID] = USR.[UserID]
		
		)--ENDEXISTS







	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectEx02 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelectEx03') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelectEx03;
GO

CREATE  PROCEDURE [OW].UserSelectEx03
(
	------------------------------------------------------------------------
	--Updated: 10-04-2006 16:32:23
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int = NULL,
	@Belongs bit = NULL
)
AS


BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	IF @Belongs IS NOT NULL
	BEGIN

		SELECT
			u.UserID,
			u.UserDesc,
			u.UserMail,
			u.Phone,
			u.Fax,
			u.UserLogin
		FROM OW.tblUser u
		WHERE
			u.UserID IN 
				(SELECT gu.UserID 
				FROM OW.tblGroupsUsers gu 
				WHERE gu.GroupID = @GroupID)
		ORDER BY 
			u.UserDesc 

	END
	ELSE
	BEGIN

		SELECT
			u.UserID,
			u.UserDesc,
			u.UserMail,
			u.Phone,
			u.Fax,
			u.UserLogin
		FROM OW.tblUser u
		WHERE
			u.UserID NOT IN 
				(SELECT gu.UserID 
				FROM OW.tblGroupsUsers gu 
				WHERE gu.GroupID = @GroupID)
		ORDER BY 
			u.UserDesc 

	END

	
	SET @Err = @@Error
	RETURN @Err

END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectEx03 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectEx03 Error on Creation'
GO




IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelectPagingEx01;
GO

CREATE PROCEDURE [OW].UserSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 03-01-2006 12:00:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserID int = NULL,
	@UserDesc varchar(100) = NULL,
	@UserMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@UserLogin varchar(50) = NULL,
	@PrimaryGroupID int = NULL,
	@GroupID int = NULL,
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
	
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '(Users.[UserID] = @UserID) AND '
	IF(@UserDesc IS NOT NULL) SET @WHERE = @WHERE + '(Users.[UserDesc] LIKE @UserDesc) AND '
	IF(@UserMail IS NOT NULL) SET @WHERE = @WHERE + '(Users.[UserMail] LIKE @UserMail) AND '
	IF(@Phone IS NOT NULL) SET @WHERE = @WHERE + '(Users.[Phone] LIKE @Phone) AND '
	IF(@Fax IS NOT NULL) SET @WHERE = @WHERE + '(Users.[Fax] LIKE @Fax) AND '
	IF(@UserLogin IS NOT NULL) SET @WHERE = @WHERE + '(Users.[UserLogin] LIKE @UserLogin) AND  '
	IF(@PrimaryGroupID IS NOT NULL) SET @WHERE = @WHERE + '(Users.[PrimaryGroupID] LIKE @PrimaryGroupID) AND '

	IF(@GroupID IS NOT NULL) SET @WHERE = @WHERE + '(EXISTS(SELECT UserID FROM OW.tblGroupsUsers GroupsUsers ONDE GroupID = @GroupID AND GroupsUsers.UserID = Users.UserID)) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(Users.[UserID]) 
	FROM [OW].[tblUser] Users INNER JOIN 
		[OW].[tblOrganizationalUnit] OrganizationalUnit 
		ON (Users.[UserID] = OrganizationalUnit.[UserID])
	' + REPLACE(RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)),'ONDE','WHERE')
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@UserID int, 
		@UserDesc varchar(100), 
		@UserMail varchar(50), 
		@Phone varchar(25), 
		@Fax varchar(25),
		@UserLogin varchar(50),
		@PrimaryGroupID int,
		@GroupID int,
		@RowCount bigint OUTPUT',
		@UserID, 
		@UserDesc, 
		@UserMail, 
		@Phone, 
		@Fax,
		@UserLogin,
		@PrimaryGroupID,
		@GroupID,
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
	WHERE Users.[UserID] IN (
		SELECT TOP ' + @SizeString + ' Users.[UserID]
				FROM [OW].[tblUser] Users INNER JOIN 
					[OW].[tblOrganizationalUnit] OrganizationalUnit 
					ON (Users.[UserID] = OrganizationalUnit.[UserID])
			WHERE Users.[UserID] NOT IN (
				SELECT TOP ' + @PrevString + ' Users.[UserID] 
					FROM [OW].[tblUser] Users INNER JOIN 
						[OW].[tblOrganizationalUnit] OrganizationalUnit 
						ON (Users.[UserID] = OrganizationalUnit.[UserID])
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	

	SET @SELECT = '
	SELECT
		Users.[UserID], 
		Users.[UserDesc], 
		Users.[UserMail], 
		Users.[Phone], 
		Users.[Fax], 
		Users.[UserLogin]
	FROM [OW].[tblUser] Users INNER JOIN
		[OW].[tblOrganizationalUnit] OrganizationalUnit 
		ON (Users.[UserID] = OrganizationalUnit.[UserID])
	' + REPLACE(@WPag,'ONDE','WHERE')
	IF(LEN(RTRIM(@SELECT)) >= 4000)
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT

	EXEC sp_executesql @SELECT, 
		N'@UserID int, 
		@UserDesc varchar(100), 
		@UserMail varchar(50), 
		@Phone varchar(25), 
		@Fax varchar(25), 
		@UserLogin varchar(50),
		@PrimaryGroupID int,
		@GroupID int',
		@UserID, 
		@UserDesc, 
		@UserMail, 
		@Phone, 
		@Fax,
		@UserLogin,
		@PrimaryGroupID,
		@GroupID

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectPagingEx01 Error on Creation'
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[GroupsUsersDeleteEx01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].GroupsUsersDeleteEx01
GO


CREATE  PROCEDURE [OW].GroupsUsersDeleteEx01
(
	------------------------------------------------------------------------
	--Updated: 06-04-2006 17:42:23
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DELETE
	FROM [OW].[tblGroupsUsers]
	WHERE
		[GroupID] = @GroupID

	RETURN @Err
END

GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersDeleteEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUsersDeleteEx01 Error on Creation'
GO



-- Get Organizational Unit for selection
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[OrganizationalUnitSelectEx01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[OrganizationalUnitSelectEx01]
GO


CREATE PROCEDURE [OW].OrganizationalUnitSelectEx01
	------------------------------------------------------------------------
	--Updated: 19-12-2005 10:45:00
	--Version: 1.0	
	------------------------------------------------------------------------
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
		ON ou.UserID=u.UserID

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

	SET @Err = @@Error
	RETURN @Err
END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx01 Error on Creation'
GO



-- Get Organizational Unit for selection using Type and Description
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[OrganizationalUnitSelectEx02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[OrganizationalUnitSelectEx02]
GO

CREATE PROCEDURE [OW].OrganizationalUnitSelectEx02 @Type int, @Description varchar(255)
	------------------------------------------------------------------------
	--Created On: 22-03-2006 14:19:00
	--Created By: ricardo da Gerreiro
	--Version   : 1.0	
	------------------------------------------------------------------------
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @sql nvarchar(4000)

	set @sql = ''

	if (@Type is null or @Type not in (0, 1, 2)) set @Type = 0
	
	if (@Type = 0 or @Type = 1)
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

		if (@Description is not null) set @sql = @sql + ' WHERE u.userDesc like @Description'
	end

	if (@Type = 0) set @sql = @sql + ' UNION '

	if (@Type = 0 or @Type = 2)
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

		if (@Description is not null) set @sql = @sql + ' WHERE g.GroupDesc like @Description'
	end

	set @sql = @sql + ' ORDER BY Description'

	exec sp_executesql @sql, N'@Description varchar(255)', @Description
		
	SET @Err = @@Error
	RETURN @Err
END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Error on Creation'

GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowSelectPagingEx01;
GO

CREATE PROCEDURE [OW].FlowSelectPagingEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Tendo em conta esta alteração:
	--IF(@Status IS NOT NULL) SET @WHERE = @WHERE + '([Status] IN (' + @Status + ')) AND '
	--[StatusType],
	--
	--Updated: 24-03-2006 18:07:07
	--Version: 1.0	
	------------------------------------------------------------------------
	@FlowID int = NULL,
	@Description varchar(80) = NULL,
	@Version varchar(17) = NULL,
	@FlowOwner varchar(100) = NULL,
	@Status varchar(50) = NULL,
	@Adhoc bit = NULL,
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
	SET @WHERE = 'WHERE '
	
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Version IS NOT NULL) SET @WHERE = @WHERE + '([Version] LIKE @Version) AND '
	IF(@FlowOwner IS NOT NULL) SET @WHERE = @WHERE + '([FlowOwner] LIKE @FlowOwner) AND '
	IF(@Status IS NOT NULL) SET @WHERE = @WHERE + '([Status] IN (' + @Status + ')) AND '
	IF(@Adhoc IS NOT NULL) SET @WHERE = @WHERE + '([Adhoc] = @Adhoc) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FlowID) 
	FROM [OW].[vFlowEx01]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@FlowID int, 
		@Description varchar(80), 
		@Version varchar(17), 
		@FlowOwner varchar(100), 
		@Status varchar(50), 
		@Adhoc bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@FlowID, 
		@Description, 
		@Version, 
		@FlowOwner, 
		@Status, 
		@Adhoc,
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
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE FlowID IN (
		SELECT TOP ' + @SizeString + ' FlowID
			FROM [OW].[vFlowEx01]
			WHERE FlowID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowID 
				FROM [OW].[vFlowEx01]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowID], 
		[Description], 
		[Version], 
		[FlowOwner], 
		[StatusType],
		[Adhoc],
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[vFlowEx01]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@FlowID int, 
		@Description varchar(80), 
		@Version varchar(17), 
		@FlowOwner varchar(100), 
		@Status varchar(50), 
		@Adhoc bit,
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowID, 
		@Description, 
		@Version, 
		@FlowOwner, 
		@Status, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowSelectPagingEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelectPagingEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowSelectPagingEx02;
GO

CREATE PROCEDURE [OW].FlowSelectPagingEx02
(
	-------------------------------------------------------------------------
	--Procedimento para paginar os fluxos que o utilizador pode iniciar processos
	--Updated: 13-04-2006 11:07:07
	--Version: 1.1	
	-------------------------------------------------------------------------
	@FlowIDs varchar(4000) = NULL,
	@AutomaticProcessNumberOnly bit = NULL,
	@FlowID int = NULL,
	@Description varchar(80) = NULL,
	@Version varchar(17) = NULL,
	@FlowOwner varchar(100) = NULL,
	@Status varchar(50) = NULL,
	@Adhoc bit = NULL,
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
	SET @WHERE = 'WHERE '
	
	IF(@FlowIDs IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] IN (' + @FlowIDs + ')) AND '
	IF(@AutomaticProcessNumberOnly IS NOT NULL) SET @WHERE = @WHERE + '([ProcessNumberRule] IS NOT NULL) AND '	
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Version IS NOT NULL) SET @WHERE = @WHERE + '([Version] LIKE @Version) AND '
	IF(@FlowOwner IS NOT NULL) SET @WHERE = @WHERE + '([FlowOwner] LIKE @FlowOwner) AND '
	IF(@Status IS NOT NULL) SET @WHERE = @WHERE + '([Status] IN (' + @Status + ')) AND '
	IF(@Adhoc IS NOT NULL) SET @WHERE = @WHERE + '([Adhoc] = @Adhoc) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '

	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FlowID) 
	FROM [OW].[vFlowEx01]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@FlowID int, 
		@Description varchar(80), 
		@Version varchar(17), 
		@FlowOwner varchar(100), 
		@Status varchar(50), 
		@Adhoc bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@FlowID, 
		@Description, 
		@Version, 
		@FlowOwner, 
		@Status, 
		@Adhoc,		
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
		SET @WPag = RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE FlowID IN (
		SELECT TOP ' + @SizeString + ' FlowID
			FROM [OW].[vFlowEx01]
			WHERE FlowID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowID 
				FROM [OW].[vFlowEx01]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowID], 
		[Description], 
		[Version], 
		[FlowOwner], 
		[StatusType],
		[Adhoc],
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[vFlowEx01]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@FlowID int, 
		@Description varchar(80), 
		@Version varchar(17), 
		@FlowOwner varchar(100), 
		@Status varchar(50), 
		@Adhoc bit,
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@FlowID, 
		@Description, 
		@Version, 
		@FlowOwner, 
		@Status, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowSelectPagingEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowSelectPagingEx02 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessSelectEx01;
GO

CREATE PROCEDURE [OW].ProcessAccessSelectEx01
(
	------------------------------------------------------------------------
	--ricardo Oliveira
	--Updated: 09-01-2006 18:20:23
	--Version: 1.0	
	------------------------------------------------------------------------
	@ProcessAccessID int = NULL,
	@FlowID int = NULL,
	@ProcessID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
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
			(@ProcessID IS NULL OR pa.ProcessID = @ProcessID) AND
			(@FlowID IS NULL OR pa.FlowID = @FlowID)) pa 
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
			(@ProcessID IS NULL OR pa.ProcessID = @ProcessID) AND
			(@FlowID IS NULL OR pa.FlowID = @FlowID)) pa
	ON v1.OrganizationalUnitID = pa.OrganizationalUnitID
	
		SET @Err = @@Error
		RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx01 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessSelectEx02;
GO


CREATE  PROCEDURE [OW].ProcessAccessSelectEx02
(
	------------------------------------------------------------------------
	--Updated: 08-03-2006 18:11:13
	--Version: 1.1	
	------------------------------------------------------------------------
	@OrganizationalUnitID  int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT
		[ProcessAccessID],
		[FlowID],
		[OrganizationalUnitID],
		[StartProcess]
	FROM 
		[OW].[tblProcessAccess] pa1
	WHERE
		pa1.[OrganizationalUnitID] = @OrganizationalUnitID AND
		[StartProcess] = 4
		
	
	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx02 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelectEx03') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessSelectEx03;
GO

CREATE  PROCEDURE [OW].ProcessAccessSelectEx03
(
	------------------------------------------------------------------------
	--Updated: 08-03-2006 18:11:13
	--Version: 1.1	
	------------------------------------------------------------------------
	@OrganizationalUnitIDs varchar(4000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT
		[ProcessAccessID],
		[FlowID],
		[OrganizationalUnitID],
		[StartProcess]
	FROM 
		[OW].[tblProcessAccess] pa1
	WHERE
		pa1.[OrganizationalUnitID] IN (SELECT stt.[Item] FROM OW.StringToTable(@OrganizationalUnitIDs,',') stt)
		AND 
		(
			pa1.[StartProcess] = 2 OR
			(pa1.[StartProcess] = 4 AND NOT EXISTS 
				(SELECT 1 FROM [OW].[tblProcessAccess] pa2
				WHERE [OrganizationalUnitID] IN (SELECT stt.[Item] FROM OW.StringToTable(@OrganizationalUnitIDs,',') stt)
				AND pa1.[FlowID] = pa2.[FlowID]
				AND pa2.[StartProcess] = 2)
			)
		)
	
	
	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx03 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelectEx03 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageAccessSelectEx01;
GO

CREATE PROCEDURE [OW].ProcessStageAccessSelectEx01
(
	------------------------------------------------------------------------
	--ricardo Oliveira
	--Updated: 09-01-2006 18:20:23
	--Version: 1.0	
	------------------------------------------------------------------------
	@ProcessStageAccessID int = NULL,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	
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
			(@ProcessStageID IS NULL OR psa.ProcessStageID = @ProcessStageID) AND
			(@FlowStageID IS NULL OR psa.FlowStageID = @FlowStageID)) psa 
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
			(@ProcessStageID IS NULL OR psa.ProcessStageID = @ProcessStageID) AND
			(@FlowStageID IS NULL OR psa.FlowStageID = @FlowStageID)) psa 
	ON v1.OrganizationalUnitID = psa.OrganizationalUnitID
	
		SET @Err = @@Error
		RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectEx01 Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AccessObjectTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AccessObjectTypeSelect;
GO

CREATE PROCEDURE [OW].AccessObjectTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@AccessObject int = NULL,
	@ID int = NULL,
	@Hierarchy int = NULL,
	@Description varchar(29) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[AccessObject],
		[ID],
		[Hierarchy],
		[Description]
	FROM [OW].[vAccessObjectType]
	WHERE
		(@AccessObject IS NULL OR [AccessObject] = @AccessObject) AND
		(@ID IS NULL OR [ID] = @ID) AND
		(@Hierarchy IS NULL OR [Hierarchy] = @Hierarchy) AND
		(@Description IS NULL OR [Description] LIKE @Description)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AccessObjectTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AccessObjectTypeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AccessObjectTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AccessObjectTypeSelectPaging;
GO

CREATE PROCEDURE [OW].AccessObjectTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@AccessObject int = NULL,
	@ID int = NULL,
	@Hierarchy int = NULL,
	@Description varchar(29) = NULL,
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
	
	IF(@AccessObject IS NOT NULL) SET @WHERE = @WHERE + '([AccessObject] = @AccessObject) AND '
	IF(@ID IS NOT NULL) SET @WHERE = @WHERE + '([ID] = @ID) AND '
	IF(@Hierarchy IS NOT NULL) SET @WHERE = @WHERE + '([Hierarchy] = @Hierarchy) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(AccessObject) 
	FROM [OW].[vAccessObjectType]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@AccessObject int, 
		@ID int, 
		@Hierarchy int, 
		@Description varchar(29),
		@RowCount bigint OUTPUT',
		@AccessObject, 
		@ID, 
		@Hierarchy, 
		@Description,
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
	WHERE AccessObject IN (
		SELECT TOP ' + @SizeString + ' AccessObject
			FROM [OW].[vAccessObjectType]
			WHERE AccessObject NOT IN (
				SELECT TOP ' + @PrevString + ' AccessObject 
				FROM [OW].[vAccessObjectType]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[AccessObject], 
		[ID], 
		[Hierarchy], 
		[Description]
	FROM [OW].[vAccessObjectType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@AccessObject int, 
		@ID int, 
		@Hierarchy int, 
		@Description varchar(29)',
		@AccessObject, 
		@ID, 
		@Hierarchy, 
		@Description
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AccessObjectTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AccessObjectTypeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldTypeSelect;
GO

CREATE PROCEDURE [OW].DynamicFieldTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@ID int = NULL,
	@Description varchar(16) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ID],
		[Description]
	FROM [OW].[vDynamicFieldType]
	WHERE
		(@ID IS NULL OR [ID] = @ID) AND
		(@Description IS NULL OR [Description] LIKE @Description)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldTypeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldTypeSelectPaging;
GO

CREATE PROCEDURE [OW].DynamicFieldTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@ID int = NULL,
	@Description varchar(16) = NULL,
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
	
	IF(@ID IS NOT NULL) SET @WHERE = @WHERE + '([ID] = @ID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ID) 
	FROM [OW].[vDynamicFieldType]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ID int, 
		@Description varchar(16),
		@RowCount bigint OUTPUT',
		@ID, 
		@Description,
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
	WHERE ID IN (
		SELECT TOP ' + @SizeString + ' ID
			FROM [OW].[vDynamicFieldType]
			WHERE ID NOT IN (
				SELECT TOP ' + @PrevString + ' ID 
				FROM [OW].[vDynamicFieldType]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ID], 
		[Description]
	FROM [OW].[vDynamicFieldType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ID int, 
		@Description varchar(16)',
		@ID, 
		@Description
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldTypeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStatusTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStatusTypeSelect;
GO

CREATE PROCEDURE [OW].FlowStatusTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@ID int = NULL,
	@Description varchar(13) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ID],
		[Description]
	FROM [OW].[vFlowStatusType]
	WHERE
		(@ID IS NULL OR [ID] = @ID) AND
		(@Description IS NULL OR [Description] LIKE @Description)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStatusTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStatusTypeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStatusTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStatusTypeSelectPaging;
GO

CREATE PROCEDURE [OW].FlowStatusTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@ID int = NULL,
	@Description varchar(13) = NULL,
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
	
	IF(@ID IS NOT NULL) SET @WHERE = @WHERE + '([ID] = @ID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ID) 
	FROM [OW].[vFlowStatusType]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ID int, 
		@Description varchar(13),
		@RowCount bigint OUTPUT',
		@ID, 
		@Description,
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
	WHERE ID IN (
		SELECT TOP ' + @SizeString + ' ID
			FROM [OW].[vFlowStatusType]
			WHERE ID NOT IN (
				SELECT TOP ' + @PrevString + ' ID 
				FROM [OW].[vFlowStatusType]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ID], 
		[Description]
	FROM [OW].[vFlowStatusType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ID int, 
		@Description varchar(13)',
		@ID, 
		@Description
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStatusTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStatusTypeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesTypeSelect;
GO

CREATE PROCEDURE [OW].ListOfValuesTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@ID int = NULL,
	@Description varchar(24) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ID],
		[Description]
	FROM [OW].[vListOfValuesType]
	WHERE
		(@ID IS NULL OR [ID] = @ID) AND
		(@Description IS NULL OR [Description] LIKE @Description)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesTypeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesTypeSelectPaging;
GO

CREATE PROCEDURE [OW].ListOfValuesTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 15:19:21
	--Version: 1.0	
	------------------------------------------------------------------------
	@ID int = NULL,
	@Description varchar(24) = NULL,
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
	
	IF(@ID IS NOT NULL) SET @WHERE = @WHERE + '([ID] = @ID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ID) 
	FROM [OW].[vListOfValuesType]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ID int, 
		@Description varchar(24),
		@RowCount bigint OUTPUT',
		@ID, 
		@Description,
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
	WHERE ID IN (
		SELECT TOP ' + @SizeString + ' ID
			FROM [OW].[vListOfValuesType]
			WHERE ID NOT IN (
				SELECT TOP ' + @PrevString + ' ID 
				FROM [OW].[vListOfValuesType]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ID], 
		[Description]
	FROM [OW].[vListOfValuesType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ID int, 
		@Description varchar(24)',
		@ID, 
		@Description
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesTypeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodSelectEx01;
GO

CREATE      PROCEDURE [OW].WorkingPeriodSelectEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 16:17:00
	--Version: 1.1	
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
	@LastModifiedOn datetime = NULL,
	@WeekDayDescription varchar(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		wp.[WorkingPeriodID],
		wp.[WeekDay],
		wp.[StartHour],
		wp.[StartMinute],
		wp.[FinishHour],
		wp.[FinishMinute],
		wp.[Remarks],
		wp.[InsertedBy],
		wp.[InsertedOn],
		wp.[LastModifiedBy],
		wp.[LastModifiedOn],
		wd.[Description] AS WeekDayDescription
	FROM OW.tblWorkingPeriod wp
	INNER JOIN OW.vWeekDay wd
	ON wp.[WeekDay] = wd.[ID]
	WHERE
		(@WorkingPeriodID IS NULL OR wp.[WorkingPeriodID] = @WorkingPeriodID) AND
		(@WeekDay IS NULL OR wp.[WeekDay] = @WeekDay) AND
		(@StartHour IS NULL OR wp.[StartHour] = @StartHour) AND
		(@StartMinute IS NULL OR wp.[StartMinute] = @StartMinute) AND
		(@FinishHour IS NULL OR wp.[FinishHour] = @FinishHour) AND
		(@FinishMinute IS NULL OR wp.[FinishMinute] = @FinishMinute) AND
		(@Remarks IS NULL OR wp.[Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR wp.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR wp.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR wp.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR wp.[LastModifiedOn] = @LastModifiedOn) AND
		(@WeekDayDescription IS NULL OR wd.[Description] LIKE @WeekDayDescription)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodSelectEx01 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodSelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodSelectPagingEx01;
GO

CREATE     PROCEDURE [OW].WorkingPeriodSelectPagingEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 12-01-2006 16:05:14
	--Version: 1.1	
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
	@LastModifiedOn datetime = NULL,
	@WeekDayDescription varchar(20) = NULL,
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
	
	IF(@WorkingPeriodID IS NOT NULL) SET @WHERE = @WHERE + '(wp.[WorkingPeriodID] = @WorkingPeriodID) AND '
	IF(@WeekDay IS NOT NULL) SET @WHERE = @WHERE + '(wp.[WeekDay] = @WeekDay) AND '
	IF(@StartHour IS NOT NULL) SET @WHERE = @WHERE + '(wp.[StartHour] = @StartHour) AND '
	IF(@StartMinute IS NOT NULL) SET @WHERE = @WHERE + '(wp.[StartMinute] = @StartMinute) AND '
	IF(@FinishHour IS NOT NULL) SET @WHERE = @WHERE + '(wp.[FinishHour] = @FinishHour) AND '
	IF(@FinishMinute IS NOT NULL) SET @WHERE = @WHERE + '(wp.[FinishMinute] = @FinishMinute) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '(wp.[Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '(wp.[InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '(wp.[InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '(wp.[LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '(wp.[LastModifiedOn] = @LastModifiedOn) AND '
	IF(@WeekDayDescription IS NOT NULL) SET @WHERE = @WHERE + '(wd.[Description] LIKE @WeekDayDescription) AND '
	
	IF(@WHERE = 'WHERE ') SET @WHERE = '----' --Not remove
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(wp.[WorkingPeriodID]) 
	FROM [OW].[tblWorkingPeriod] wp
	INNER JOIN OW.vWeekDay wd
	ON wp.[WeekDay] = wd.[ID]
	' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4))
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@WeekDayDescription varchar(20),
		@RowCount bigint OUTPUT',
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
		@LastModifiedOn,
		@WeekDayDescription,
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
	WHERE wp.WorkingPeriodID IN (
		SELECT TOP ' + @SizeString + ' wp.WorkingPeriodID
			FROM [OW].[tblWorkingPeriod] wp
			INNER JOIN OW.vWeekDay wd
			ON wp.[WeekDay] = wd.[ID]

			WHERE wp.WorkingPeriodID NOT IN (
				SELECT TOP ' + @PrevString + ' wp.WorkingPeriodID 
				FROM [OW].[tblWorkingPeriod] wp
				INNER JOIN OW.vWeekDay wd
				ON wp.[WeekDay] = wd.[ID]
				' + RTRIM(LEFT(@WHERE, LEN(@WHERE) - 4)) + @SortField + '
		)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField + '
	)' + RTRIM(REPLACE(LEFT(@WHERE, LEN(@WHERE) - 4),'WHERE',' AND')) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		wp.[WorkingPeriodID], 
		wp.[WeekDay], 
		wp.[StartHour], 
		wp.[StartMinute], 
		wp.[FinishHour], 
		wp.[FinishMinute], 
		wp.[Remarks], 
		wp.[InsertedBy], 
		wp.[InsertedOn], 
		wp.[LastModifiedBy], 
		wp.[LastModifiedOn],
		wd.[Description] AS WeekDayDescription
	FROM [OW].[tblWorkingPeriod] wp
	INNER JOIN OW.vWeekDay wd
	ON wp.[WeekDay] = wd.[ID]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
		@LastModifiedOn datetime,
		@WeekDayDescription varchar(20)',
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
		@LastModifiedOn,
		@WeekDayDescription
	
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodSelectPagingEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleInsertEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ModuleInsertEx01;
GO


CREATE  PROCEDURE [OW].ModuleInsertEx01
(
	------------------------------------------------------------------------
	--Updated: 26-01-2006 15:55:11
	--Version: 1.1	
	------------------------------------------------------------------------
	@ModuleID int,
	@Description varchar(80),
	@Active bit,
	@Remarks varchar(255) = NULL,
	@InsertedBy varchar(50),
	@InsertedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	/* For Insert Modules with especified ID */
	SET IDENTITY_INSERT [OW].[tblModule] ON
	
	INSERT
	INTO [OW].[tblModule]
	(
		[ModuleID],
		[Description],
		[Active],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ModuleID,		
		@Description,
		@Active,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	

	/* Set Value to default */
	SET IDENTITY_INSERT [OW].[tblModule] OFF

	RETURN @@Error
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleInsertEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ModuleInsertEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceAccessSelectEx01;
GO


CREATE  PROCEDURE [OW].ResourceAccessSelectEx01
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
	WHERE
		ra1.[OrganizationalUnitID] IN (SELECT stt.[Item] FROM OW.StringToTable(@OrganizationalUnitIDs,',') stt)
		AND 
		(
			ra1.[AccessType] = 2 OR
			(ra1.[AccessType] = 4 AND NOT EXISTS 
				(SELECT 1 FROM [OW].[tblResourceAccess] ra2
				WHERE [OrganizationalUnitID] IN (SELECT stt.[Item] FROM OW.StringToTable(@OrganizationalUnitIDs,',') stt)
				AND ra1.[ResourceID] = ra2.[ResourceID]
				AND ra2.[AccessType] = 2)
			)
		)
		AND 
		r1.[Active] = 1 AND m1.[Active] = 1 

	SET @Err = @@Error
	RETURN @Err
END


GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceAccessSelectEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelectEx01;
GO


CREATE  PROCEDURE [OW].ProcessDocumentSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 10-02-2006 18:17:24
	--Version: 1.2
	------------------------------------------------------------------------
	@ProcessID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT 
		pd.[ProcessDocumentID],
		pd.[ProcessEventID],
		pd.[DocumentID],
		pe.[ProcessStageID],
		pe.[CreationDate],
		pe.[OrganizationalUnitID]
	FROM [OW].[tblProcessDocument] pd
	INNER JOIN [OW].[tblProcessEvent] pe
	ON pd.[ProcessEventID] = pe.[ProcessEventID]
	WHERE
		(@ProcessID IS NULL OR pe.[ProcessID] = @ProcessID)

	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_NewContactEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_NewContactEx01;
GO

CREATE  PROCEDURE OW.usp_NewContactEx01
(
	------------------------------------------------------------------------
	--Updated: 13-02-2006 18:17:24
	--Version: 1.1
	------------------------------------------------------------------------
	@PublicCode varchar(20),
	@Name varchar(255),
	@ListID numeric (18,0),
	@EntityTypeID numeric (18,0),
	@User varchar(50),
	@Type tinyint=1,
	@EntID NUMERIC OUTPUT /* Return new contact ID */
)
AS

BEGIN

	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

	INSERT
	INTO [OW].[tblEntities]
	(
		[OW].[tblEntities].[PublicCode],
		[OW].[tblEntities].[Name],
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


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_NewContactEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_NewContactEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_SetEntitiesGroupsEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_SetEntitiesGroupsEx01;
GO

CREATE  PROCEDURE [OW].[usp_SetEntitiesGroupsEx01]
(
	------------------------------------------------------------------------
	--Updated: 13-02-2006 18:17:24
	--Version: 1.1
	------------------------------------------------------------------------
	@PublicCode varchar(20),
	@EntID numeric(18,0),
	@Name varchar(255),
	@ListID numeric (18,0),
	@EntityTypeID numeric (18,0),
	@User varchar(50)
)
AS
BEGIN

	SET NOCOUNT ON
	
	UPDATE [OW].[tblEntities]
	SET
		[OW].[tblEntities].[PublicCode] = @PublicCode,		
		[OW].[tblEntities].[Name] = @Name,
		[OW].[tblEntities].[ListID] = @ListID,
		[OW].[tblEntities].[EntityTypeID] = @EntityTypeID,
		[OW].[tblEntities].[LastModifiedBy] = @User,
		[OW].[tblEntities].[LastModifiedOn] = GETDATE()
	WHERE 
		[OW].[tblEntities].[EntID] = @EntID

	RETURN @@Error

END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_SetEntitiesGroupsEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_SetEntitiesGroupsEx01 Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceSelectEx01;
GO


CREATE   PROCEDURE [OW].ProcessReferenceSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 14-02-2006 18:17:24
	--Version: 1.1
	------------------------------------------------------------------------
	@ProcessID int = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
		pr.[ProcessReferenceID],
		pr.[ProcessEventID],
		pr.[ProcessReferedID],
		pr.[ProcessReferenceType],
		pr.[ShareData],
		pe.[ProcessID],
		pe.[ProcessStageID],
		pe.[CreationDate],
		pe.[OrganizationalUnitID]
	FROM [OW].[tblProcessReference] pr
	INNER JOIN [OW].[tblProcessEvent] pe
	ON pr.[ProcessEventID] = pe.[ProcessEventID]
	WHERE
		(@ProcessID IS NULL OR pe.[ProcessID] = @ProcessID)

	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceSelectEx01 Error on Creation'
GO






IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterDeleteEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OWNotifyAgentRegisterDeleteEx01;
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterDeleteEx01
(
	------------------------------------------------------------------------
	--
	--Updated: 24-02-2006 12:12:28
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserID int = NULL,
	@Host varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblOWNotifyAgentRegister]
	WHERE
	    (@UserID IS NULL OR [UserID] = @UserID)	
	AND (@Host IS NULL OR [Host] = @Host)
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterDeleteEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterDeleteEx01 Error on Creation'
GO









IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_GetDocumentReferences') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_GetDocumentReferences;
GO


CREATE PROCEDURE OW.usp_GetDocumentReferences

	(
	@FileID numeric(18)
	)

AS

	SELECT 1 AS RefType, R.RegID AS RefID, (B.Abreviation + '-' + CAST(R.Year AS varchar(4)) + '/' + CAST(R.Number AS varchar(18)) + ' ' + R.Subject) AS Reference , R.Date
	FROM OW.tblRegistry R INNER JOIN OW.tblBooks B ON R.BookID=B.BookID
	WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments RD
				WHERE R.RegID=RD.RegID AND RD.FileID=@FileID)
	UNION
	SELECT 2 AS RefType, P.ProcessID AS RefID, (P.ProcessNumber + ' ' + P.ProcessSubject) AS Reference , P.StartDate
	FROM OW.tblProcess P
	WHERE EXISTS (SELECT 1 FROM OW.tblProcessEvent PE
			WHERE P.ProcessID=PE.ProcessID
			AND EXISTS (SELECT 1 FROM OW.tblProcessDocument PD
				WHERE PE.ProcessEventID=PD.ProcessEventID AND PD.DocumentID=@FileID)
	)
	ORDER BY Date

	
	
	RETURN @@ERROR


GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_GetDocumentReferences Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_GetDocumentReferences Error on Creation'
GO


-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- Procedimentos para verificação de acessos no OWProcess
-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckProcessAccess') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckProcessAccess;
GO

CREATE PROCEDURE [OW].CheckProcessAccess
(
	@ProcessID int,
	@UserID int,
	@ProcessDataAccess tinyint output,
	@DynamicFieldAccess tinyint output,
	@DocumentAccess tinyint output,
	@DispatchAccess tinyint output
)
AS
BEGIN

	declare @HierarchyID int

	declare @PrimaryGroupID int
	declare @OriginatorID int
	declare @ProcessOwnerID int

	declare @Originator bit
	declare @OriginatorGroup bit
	declare @OriginatorHierarchicSuperiors bit
	declare @Intervenient bit

	SET @ProcessDataAccess = COALESCE(@ProcessDataAccess, 1)
	SET @DynamicFieldAccess = COALESCE(@DynamicFieldAccess, 1)
	SET @DocumentAccess = COALESCE(@DocumentAccess, 1)
	SET @DispatchAccess = COALESCE(@DispatchAccess, 1)
	
	-- ----------------------------------------------------------------------------------------------------
	-- Dados do grupo hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID

	-- ----------------------------------------------------------------------------------------------------
	-- Dados dos grupos do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT GroupID INTO #GroupsUsers FROM OW.tblGroupsUsers WHERE UserID = @UserID

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do originador e do dono do processo
	-- ----------------------------------------------------------------------------------------------------
	SELECT @OriginatorID = OriginatorID, @ProcessOwnerID = ProcessOwnerID FROM OW.tblProcess WHERE ProcessID = @ProcessID

	-- ----------------------------------------------------------------------------------------------------
	-- Se o utilizador for dono do processo, então tem acesso a tudo
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT UserID 
                  FROM OW.tblOrganizationalUnit 
                  WHERE OrganizationalUnitID = @ProcessOwnerID
                    AND (UserID = @UserID OR GroupID = @PrimaryGroupID)) OR
	   EXISTS (SELECT OW.tblOrganizationalUnit.OrganizationalUnitID
		   FROM #GroupsUsers INNER JOIN
                        OW.tblOrganizationalUnit ON #GroupsUsers.GroupID = OW.tblOrganizationalUnit.GroupID
		   WHERE OW.tblOrganizationalUnit.OrganizationalUnitID = @ProcessOwnerID)
	BEGIN
		SET @ProcessDataAccess = 4
		SET @DynamicFieldAccess = 4
		SET @DocumentAccess = 4
		SET @DispatchAccess = 4	
		
		RETURN
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do processo 
	-- ----------------------------------------------------------------------------------------------------
	SELECT DISTINCT 
	OW.tblProcess.OriginatorID, 
	OW.tblUser.PrimaryGroupID, 
	OW.tblGroupsUsers.GroupID, 
	OW.tblOrganizationalUnit.UserID
	INTO #Process
	FROM OW.tblProcess INNER JOIN
	     OW.tblUser ON OW.tblProcess.OriginatorID = OW.tblUser.userID INNER JOIN
	     OW.tblProcessEvent ON OW.tblProcess.ProcessID = OW.tblProcessEvent.ProcessID INNER JOIN
	     OW.tblOrganizationalUnit ON
	     OW.tblProcessEvent.OrganizationalUnitID = OW.tblOrganizationalUnit.OrganizationalUnitID LEFT OUTER JOIN
	     OW.tblGroups ON OW.tblUser.PrimaryGroupID = OW.tblGroups.GroupID LEFT OUTER JOIN 
	     OW.tblGroupsUsers ON OW.tblUser.userID = OW.tblGroupsUsers.UserID
	WHERE OW.tblProcess.ProcessID = @ProcessID
	  AND OW.tblOrganizationalUnit.UserID IS NOT NULL

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é originador
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE OriginatorID = @UserID)
		SET @Originator = 1	
	ELSE
		SET @Originator = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é o grupo do originador
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE PrimaryGroupID = @PrimaryGroupID)
		SET @OriginatorGroup = 1	
	ELSE
		SET @OriginatorGroup = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é Superior Hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM OW.tblUser WHERE PrimaryGroupID = @PrimaryGroupID AND GroupHead = 1 AND UserID = @OriginatorID)	
		SET @OriginatorHierarchicSuperiors = 1	
	ELSE
		SET @OriginatorHierarchicSuperiors = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE UserID = @UserID)
		SET @Intervenient = 1	
	ELSE
		SET @Intervenient = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Acessos definidos para o Processo
	-- ----------------------------------------------------------------------------------------------------
	SELECT DISTINCT    
	OW.tblProcessAccess.OrganizationalUnitID, 
	OW.tblOrganizationalUnit.GroupID, 
	OW.tblOrganizationalUnit.UserID, 
	OW.tblProcessAccess.AccessObject, 
	OW.tblProcessAccess.ProcessDataAccess, 
	OW.tblProcessAccess.DynamicFieldAccess, 
	OW.tblProcessAccess.DocumentAccess, 
	OW.tblProcessAccess.DispatchAccess
	INTO #ProcessAccess
	FROM OW.tblProcessEvent INNER JOIN
	     OW.tblProcess ON OW.tblProcessEvent.ProcessID = OW.tblProcess.ProcessID INNER JOIN
	     OW.tblProcessAccess ON OW.tblProcessEvent.ProcessID = OW.tblProcessAccess.ProcessID LEFT OUTER JOIN
	     OW.tblOrganizationalUnit ON OW.tblProcessAccess.OrganizationalUnitID = OW.tblOrganizationalUnit.OrganizationalUnitID
	WHERE OW.tblProcessEvent.ProcessID = @ProcessID


	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso como Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @Originator = 1
	BEGIN
		SELECT 
		@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
		@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessAccess 
		WHERE AccessObject = 2
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Grupo do Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN	
		IF @OriginatorGroup = 1 
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 4
		END
	END
	ELSE RETURN	

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Superior Hierarquico do Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @OriginatorHierarchicSuperiors = 1
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 8
		END	
	END
	ELSE RETURN

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @Intervenient = 1
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 16
		END	
	END
	ELSE RETURN
		
	-- ----------------------------------------------------------------------------------------------------
	-- Verifica os acessos do utilizador
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		SELECT 
		@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
		@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessAccess 
		WHERE AccessObject = 1
		  AND UserID = @UserID
	END
	ELSE RETURN
	
	-- ----------------------------------------------------------------------------------------------------
	-- Verificação hierarquica dos grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN

		SELECT @HierarchyID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
		WHILE @HierarchyID IS NOT NULL
		BEGIN
			IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
			BEGIN
				SELECT 
				@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
				@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
				@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
				@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
				FROM #ProcessAccess 
				WHERE AccessObject = 1
				  AND GroupID = @HierarchyID
		
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
			END
			ELSE RETURN
		END 	
	END
	ELSE RETURN		

	-- ----------------------------------------------------------------------------------------------------
	-- Verificação dos restantes grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		SELECT
		@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
		@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessAccess
		WHERE GroupID IN(SELECT GroupID 
				 FROM OW.tblGroupsUsers 
				 WHERE UserID = @UserID)
	END
	ELSE RETURN

END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessAccess Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessAccess Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckProcessStageAccess') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckProcessStageAccess;
GO

CREATE PROCEDURE [OW].CheckProcessStageAccess
(
	@ProcessStageID int,
	@UserID int,
	@DocumentAccess tinyint output,
	@DispatchAccess tinyint output
)
AS
BEGIN

	declare @ProcessID int

	declare @HierarchyID int

	declare @PrimaryGroupID int
	declare @OriginatorID int
	declare @ProcessOwnerID int

	declare @Originator bit
	declare @OriginatorGroup bit
	declare @OriginatorHierarchicSuperiors bit
	declare @Intervenient bit

	SET @DocumentAccess = COALESCE(@DocumentAccess, 1)
	SET @DispatchAccess = COALESCE(@DispatchAccess, 1)

	-- ----------------------------------------------------------------------------------------------------
	-- Identificador do Processo
	-- ----------------------------------------------------------------------------------------------------
	SELECT @ProcessID = ProcessID FROM OW.tblProcessStage WHERE ProcessStageID = @ProcessStageID

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do grupo hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do originador e do dono do processo
	-- ----------------------------------------------------------------------------------------------------
	SELECT @OriginatorID = OriginatorID, @ProcessOwnerID = ProcessOwnerID FROM OW.tblProcess WHERE ProcessID = @ProcessID

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do grupos do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT GroupID INTO #GroupsUsers FROM OW.tblGroupsUsers WHERE UserID = @UserID

	-- ----------------------------------------------------------------------------------------------------
	-- Se o utilizador for dono do processo, então tem acesso a tudo
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT UserID 
                  FROM OW.tblOrganizationalUnit 
                  WHERE OrganizationalUnitID = @ProcessOwnerID
                    AND (UserID = @UserID OR GroupID = @PrimaryGroupID)) OR
	   EXISTS (SELECT OW.tblOrganizationalUnit.OrganizationalUnitID
		   FROM #GroupsUsers INNER JOIN
                        OW.tblOrganizationalUnit ON #GroupsUsers.GroupID = OW.tblOrganizationalUnit.GroupID
		   WHERE OW.tblOrganizationalUnit.OrganizationalUnitID = @ProcessOwnerID)
	BEGIN
		SET @DocumentAccess = 4
		SET @DispatchAccess = 4	
		
		RETURN
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do processo 
	-- ----------------------------------------------------------------------------------------------------
	SELECT DISTINCT 
	OW.tblProcess.OriginatorID, 
	OW.tblUser.PrimaryGroupID, 
	OW.tblGroupsUsers.GroupID, 
	OW.tblOrganizationalUnit.UserID
	INTO #Process
	FROM OW.tblProcess INNER JOIN
	     OW.tblUser ON OW.tblProcess.OriginatorID = OW.tblUser.userID INNER JOIN
	     OW.tblProcessEvent ON OW.tblProcess.ProcessID = OW.tblProcessEvent.ProcessID INNER JOIN
	     OW.tblOrganizationalUnit ON
	     OW.tblProcessEvent.OrganizationalUnitID = OW.tblOrganizationalUnit.OrganizationalUnitID LEFT OUTER JOIN
	     OW.tblGroups ON OW.tblUser.PrimaryGroupID = OW.tblGroups.GroupID LEFT OUTER JOIN 
	     OW.tblGroupsUsers ON OW.tblUser.userID = OW.tblGroupsUsers.UserID
	WHERE OW.tblProcess.ProcessID = @ProcessID
	  AND OW.tblOrganizationalUnit.UserID IS NOT NULL

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é originador
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE OriginatorID = @UserID)
		SET @Originator = 1	
	ELSE
		SET @Originator = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é o grupo do originador
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE PrimaryGroupID = @PrimaryGroupID)
		SET @OriginatorGroup = 1	
	ELSE
		SET @OriginatorGroup = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é Superior Hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM OW.tblUser WHERE PrimaryGroupID = @PrimaryGroupID AND GroupHead = 1 AND UserID = @OriginatorID)	
		SET @OriginatorHierarchicSuperiors = 1	
	ELSE
		SET @OriginatorHierarchicSuperiors = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE UserID = @UserID)
		SET @Intervenient = 1	
	ELSE
		SET @Intervenient = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Acessos definidos para a etapa
	-- ----------------------------------------------------------------------------------------------------
	SELECT DISTINCT     
	OW.tblProcessStageAccess.OrganizationalUnitID, 
	OW.tblOrganizationalUnit.GroupID, 
	OW.tblOrganizationalUnit.UserID, 
	OW.tblProcessStageAccess.AccessObject, 
	OW.tblProcessStageAccess.DocumentAccess, 
	OW.tblProcessStageAccess.DispatchAccess
	INTO #ProcessStageAccess
	FROM OW.tblProcessEvent INNER JOIN
	     OW.tblProcess ON OW.tblProcessEvent.ProcessID = OW.tblProcess.ProcessID INNER JOIN
	     OW.tblProcessStageAccess ON OW.tblProcessEvent.ProcessStageID = OW.tblProcessStageAccess.ProcessStageID LEFT OUTER JOIN
	     OW.tblOrganizationalUnit ON OW.tblProcessStageAccess.OrganizationalUnitID = OW.tblOrganizationalUnit.OrganizationalUnitID
	WHERE OW.tblProcessEvent.ProcessStageID = @ProcessStageID



	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso como Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @Originator = 1
	BEGIN
		SELECT 
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessStageAccess 
		WHERE AccessObject = 2
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Grupo do Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN	
		IF @OriginatorGroup = 1 
		BEGIN
			SELECT 
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessStageAccess 
			WHERE AccessObject = 4
		END
	END
	ELSE RETURN	

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Superior Hierarquico do Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @OriginatorHierarchicSuperiors = 1
		BEGIN
			SELECT 
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessStageAccess 
			WHERE AccessObject = 8
		END	
	END
	ELSE RETURN

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @Intervenient = 1
		BEGIN
			SELECT 
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessStageAccess 
			WHERE AccessObject = 16
		END	
	END
	ELSE RETURN
		
	-- ----------------------------------------------------------------------------------------------------
	-- Verifica os acessos do utilizador
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		SELECT 
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessStageAccess 
		WHERE AccessObject = 1
		  AND UserID = @UserID
	END
	ELSE RETURN
	
	-- ----------------------------------------------------------------------------------------------------
	-- Verificação hierarquica dos grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN

		SELECT @HierarchyID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
		WHILE @HierarchyID IS NOT NULL
		BEGIN
			IF @DocumentAccess = 1 OR @DispatchAccess = 1
			BEGIN
				SELECT 
				@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
				@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
				FROM #ProcessStageAccess 
				WHERE AccessObject = 1
				  AND GroupID = @HierarchyID
		
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
			END
			ELSE RETURN
		END 	
	END
	ELSE RETURN		

	-- ----------------------------------------------------------------------------------------------------
	-- Verificação dos restantes grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		SELECT
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessStageAccess
		WHERE GroupID IN(SELECT GroupID 
				 FROM OW.tblGroupsUsers 
				 WHERE UserID = @UserID)
	END
	ELSE RETURN

	-- ----------------------------------------------------------------------------------------------------
	-- Verificação dos acessos ao nível do processo
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		exec OW.CheckProcessAccess @ProcessID, @UserID, 4, 4, @DocumentAccess output, @DispatchAccess output
	END

END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessStageAccess Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessStageAccess Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckProcessDocumentAccess') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckProcessDocumentAccess;
GO

CREATE PROCEDURE [OW].CheckProcessDocumentAccess
(
	@DocumentID int,
	@UserID int,
	@DocumentAccess tinyint output
)
AS
BEGIN

	declare @ProcessID int
	declare @ProcessStageID int

	DECLARE c CURSOR FOR 
	SELECT 
	OW.tblProcessEvent.ProcessID,
	OW.tblProcessEvent.ProcessStageID
	FROM OW.tblProcessDocument INNER JOIN
	     OW.tblProcessEvent ON OW.tblProcessDocument.ProcessEventID = OW.tblProcessEvent.ProcessEventID
	WHERE OW.tblProcessDocument.DocumentID = @DocumentID
	ORDER BY ProcessStageID
	
	OPEN c
	
	FETCH NEXT FROM c INTO @ProcessID, @ProcessStageID
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ProcessStageID IS NOT NULL
		BEGIN
			exec OW.CheckProcessStageAccess @ProcessStageID, @UserID, @DocumentAccess output, 4

			IF @DocumentAccess = 4 BREAK
		END
		ELSE
		BEGIN
			exec OW.CheckProcessAccess @ProcessID, @UserID, 4, 4, @DocumentAccess output, 4

			IF @DocumentAccess = 4 BREAK		
		END

		FETCH NEXT FROM c INTO @ProcessID, @ProcessStageID	   
	END
	
	CLOSE c
	DEALLOCATE c

END	   

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessDocumentAccess Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessDocumentAccess Error on Creation'
GO

