-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.4.0 PARA A VERSÃO 5.5.0
--
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.4.0 PARA 5.5.0'
PRINT ''
GO

ALTER PROCEDURE [OW].ListOfValuesSelectEx01
(
	------------------------------------------------------------------------
	--Updated: 03-10-2007 19:00:00
	--Version: 1.1	
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
		lovt.[ID] AS ListOfValuesTypeID,
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




ALTER PROCEDURE [OW].ListOfValuesSelectPagingEx01
(
	------------------------------------------------------------------------
	--Updated: 03-10-2007 19:00:00
	--Version: 1.2	
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL,
	@Description varchar(50) = NULL,
	@ListOfValuesTypeID tinyint = NULL, 
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
	IF(@ListOfValuesTypeID IS NOT NULL) SET @WHERE = @WHERE + '(lovt.[ID] = @ListOfValuesTypeID) AND '
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
		@ListOfValuesTypeID tinyint,
		@ListOfValuesTypeDescription varchar(80),
		@RowCount bigint OUTPUT',
		@ListOfValuesID, 
		@Description, 
		@ListOfValuesTypeID,
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
		lovt.[ID] AS ListOfValuesTypeID,
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
		@ListOfValuesTypeID tinyint,
		@ListOfValuesTypeDescription varchar(80)',
		@ListOfValuesID, 
		@Description,
		@ListOfValuesTypeID,
		@ListOfValuesTypeDescription
	
	SET @Err = @@Error
	RETURN @Err
END
GO



ALTER PROCEDURE [OW].DynamicFieldSelectEx01
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
		DynamicFieldType.[ID] AS DynamicFieldTypeID, 
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



ALTER PROCEDURE [OW].DynamicFieldSelectPagingEx01
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
		DynamicFieldType.[ID] AS DynamicFieldTypeID, 
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




ALTER  PROCEDURE [OW].FlowSelectPagingEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Tendo em conta esta alteração:
	--IF(@Status IS NOT NULL) SET @WHERE = @WHERE + '([Status] IN (' + @Status + ')) AND '
	--[StatusType],
	--E agora devolve + o [Status]
	--Updated: 04-10-2007 19:00:00
	--Version: 1.1	
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
		[Status],
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


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.5.0' WHERE id= 1
GO


PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.4.0 PARA 5.5.0'
PRINT ''
GO

