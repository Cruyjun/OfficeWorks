


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueSelect;
GO

CREATE PROCEDURE [OW].AlarmQueueSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:14
	--Version: 1.2	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL,
	@LaunchDateTime datetime = NULL,
	@ProcessAlarmID int = NULL,
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
		[AlertQueueID],
		[LaunchDateTime],
		[ProcessAlarmID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblAlarmQueue]
	WHERE
		(@AlertQueueID IS NULL OR [AlertQueueID] = @AlertQueueID) AND
		(@LaunchDateTime IS NULL OR [LaunchDateTime] = @LaunchDateTime) AND
		(@ProcessAlarmID IS NULL OR [ProcessAlarmID] = @ProcessAlarmID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueSelectPaging;
GO

CREATE PROCEDURE [OW].AlarmQueueSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL,
	@LaunchDateTime datetime = NULL,
	@ProcessAlarmID int = NULL,
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
	
	IF(@AlertQueueID IS NOT NULL) SET @WHERE = @WHERE + '([AlertQueueID] = @AlertQueueID) AND '
	IF(@LaunchDateTime IS NOT NULL) SET @WHERE = @WHERE + '([LaunchDateTime] = @LaunchDateTime) AND '
	IF(@ProcessAlarmID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessAlarmID] = @ProcessAlarmID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(AlertQueueID) 
	FROM [OW].[tblAlarmQueue]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@AlertQueueID int, 
		@LaunchDateTime datetime, 
		@ProcessAlarmID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@AlertQueueID, 
		@LaunchDateTime, 
		@ProcessAlarmID, 
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
	WHERE AlertQueueID IN (
		SELECT TOP ' + @SizeString + ' AlertQueueID
			FROM [OW].[tblAlarmQueue]
			WHERE AlertQueueID NOT IN (
				SELECT TOP ' + @PrevString + ' AlertQueueID 
				FROM [OW].[tblAlarmQueue]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[AlertQueueID], 
		[LaunchDateTime], 
		[ProcessAlarmID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblAlarmQueue]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@AlertQueueID int, 
		@LaunchDateTime datetime, 
		@ProcessAlarmID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@AlertQueueID, 
		@LaunchDateTime, 
		@ProcessAlarmID, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueUpdate;
GO

CREATE PROCEDURE [OW].AlarmQueueUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int,
	@LaunchDateTime datetime,
	@ProcessAlarmID int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblAlarmQueue]
	SET
		[LaunchDateTime] = @LaunchDateTime,
		[ProcessAlarmID] = @ProcessAlarmID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[AlertQueueID] = @AlertQueueID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueInsert;
GO

CREATE PROCEDURE [OW].AlarmQueueInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL OUTPUT,
	@LaunchDateTime datetime,
	@ProcessAlarmID int,
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
	INTO [OW].[tblAlarmQueue]
	(
		[LaunchDateTime],
		[ProcessAlarmID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@LaunchDateTime,
		@ProcessAlarmID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @AlertQueueID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlarmQueueDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlarmQueueDelete;
GO

CREATE PROCEDURE [OW].AlarmQueueDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblAlarmQueue]
	WHERE
		[AlertQueueID] = @AlertQueueID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlertSelect;
GO

CREATE PROCEDURE [OW].AlertSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.2	
	------------------------------------------------------------------------
	@AlertID int = NULL,
	@Message varchar(100) = NULL,
	@UserID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
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

	SELECT
		[AlertID],
		[Message],
		[UserID],
		[ProcessID],
		[ProcessStageID],
		[SendDateTime],
		[ReadDateTime],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblAlert]
	WHERE
		(@AlertID IS NULL OR [AlertID] = @AlertID) AND
		(@Message IS NULL OR [Message] LIKE @Message) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@SendDateTime IS NULL OR [SendDateTime] = @SendDateTime) AND
		(@ReadDateTime IS NULL OR [ReadDateTime] = @ReadDateTime) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlertSelectPaging;
GO

CREATE PROCEDURE [OW].AlertSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertID int = NULL,
	@Message varchar(100) = NULL,
	@UserID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@SendDateTime datetime = NULL,
	@ReadDateTime datetime = NULL,
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
	
	IF(@AlertID IS NOT NULL) SET @WHERE = @WHERE + '([AlertID] = @AlertID) AND '
	IF(@Message IS NOT NULL) SET @WHERE = @WHERE + '([Message] LIKE @Message) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '([UserID] = @UserID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@SendDateTime IS NOT NULL) SET @WHERE = @WHERE + '([SendDateTime] = @SendDateTime) AND '
	IF(@ReadDateTime IS NOT NULL) SET @WHERE = @WHERE + '([ReadDateTime] = @ReadDateTime) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(AlertID) 
	FROM [OW].[tblAlert]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@AlertID int, 
		@Message varchar(100), 
		@UserID int, 
		@ProcessID int, 
		@ProcessStageID int, 
		@SendDateTime datetime, 
		@ReadDateTime datetime, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@AlertID, 
		@Message, 
		@UserID, 
		@ProcessID, 
		@ProcessStageID, 
		@SendDateTime, 
		@ReadDateTime, 
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
	WHERE AlertID IN (
		SELECT TOP ' + @SizeString + ' AlertID
			FROM [OW].[tblAlert]
			WHERE AlertID NOT IN (
				SELECT TOP ' + @PrevString + ' AlertID 
				FROM [OW].[tblAlert]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[AlertID], 
		[Message], 
		[UserID], 
		[ProcessID], 
		[ProcessStageID], 
		[SendDateTime], 
		[ReadDateTime], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblAlert]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@AlertID int, 
		@Message varchar(100), 
		@UserID int, 
		@ProcessID int, 
		@ProcessStageID int, 
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
		@ProcessID, 
		@ProcessStageID, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlertUpdate;
GO

CREATE PROCEDURE [OW].AlertUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertID int,
	@Message varchar(100),
	@UserID int,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@SendDateTime datetime,
	@ReadDateTime datetime = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblAlert]
	SET
		[Message] = @Message,
		[UserID] = @UserID,
		[ProcessID] = @ProcessID,
		[ProcessStageID] = @ProcessStageID,
		[SendDateTime] = @SendDateTime,
		[ReadDateTime] = @ReadDateTime,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[AlertID] = @AlertID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlertInsert;
GO

CREATE PROCEDURE [OW].AlertInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertID int = NULL OUTPUT,
	@Message varchar(100),
	@UserID int,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@SendDateTime datetime,
	@ReadDateTime datetime = NULL,
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
	INTO [OW].[tblAlert]
	(
		[Message],
		[UserID],
		[ProcessID],
		[ProcessStageID],
		[SendDateTime],
		[ReadDateTime],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Message,
		@UserID,
		@ProcessID,
		@ProcessStageID,
		@SendDateTime,
		@ReadDateTime,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @AlertID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].AlertDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].AlertDelete;
GO

CREATE PROCEDURE [OW].AlertDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblAlert]
	WHERE
		[AlertID] = @AlertID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OWNotifyAgentRegisterSelect;
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.2	
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

	SELECT
		[OWNotifyAgentRegisterID],
		[UserID],
		[Host],
		[Protocol],
		[Port],
		[Uri],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblOWNotifyAgentRegister]
	WHERE
		(@OWNotifyAgentRegisterID IS NULL OR [OWNotifyAgentRegisterID] = @OWNotifyAgentRegisterID) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@Host IS NULL OR [Host] LIKE @Host) AND
		(@Protocol IS NULL OR [Protocol] LIKE @Protocol) AND
		(@Port IS NULL OR [Port] = @Port) AND
		(@Uri IS NULL OR [Uri] LIKE @Uri) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OWNotifyAgentRegisterSelectPaging;
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
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
	
	IF(@OWNotifyAgentRegisterID IS NOT NULL) SET @WHERE = @WHERE + '([OWNotifyAgentRegisterID] = @OWNotifyAgentRegisterID) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '([UserID] = @UserID) AND '
	IF(@Host IS NOT NULL) SET @WHERE = @WHERE + '([Host] LIKE @Host) AND '
	IF(@Protocol IS NOT NULL) SET @WHERE = @WHERE + '([Protocol] LIKE @Protocol) AND '
	IF(@Port IS NOT NULL) SET @WHERE = @WHERE + '([Port] = @Port) AND '
	IF(@Uri IS NOT NULL) SET @WHERE = @WHERE + '([Uri] LIKE @Uri) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(OWNotifyAgentRegisterID) 
	FROM [OW].[tblOWNotifyAgentRegister]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE OWNotifyAgentRegisterID IN (
		SELECT TOP ' + @SizeString + ' OWNotifyAgentRegisterID
			FROM [OW].[tblOWNotifyAgentRegister]
			WHERE OWNotifyAgentRegisterID NOT IN (
				SELECT TOP ' + @PrevString + ' OWNotifyAgentRegisterID 
				FROM [OW].[tblOWNotifyAgentRegister]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[OWNotifyAgentRegisterID], 
		[UserID], 
		[Host], 
		[Protocol], 
		[Port], 
		[Uri], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblOWNotifyAgentRegister]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OWNotifyAgentRegisterUpdate;
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@OWNotifyAgentRegisterID int,
	@UserID int,
	@Host varchar(50),
	@Protocol varchar(20),
	@Port int,
	@Uri varchar(50),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblOWNotifyAgentRegister]
	SET
		[UserID] = @UserID,
		[Host] = @Host,
		[Protocol] = @Protocol,
		[Port] = @Port,
		[Uri] = @Uri,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[OWNotifyAgentRegisterID] = @OWNotifyAgentRegisterID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OWNotifyAgentRegisterInsert;
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@OWNotifyAgentRegisterID int = NULL OUTPUT,
	@UserID int,
	@Host varchar(50),
	@Protocol varchar(20),
	@Port int,
	@Uri varchar(50),
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
	INTO [OW].[tblOWNotifyAgentRegister]
	(
		[UserID],
		[Host],
		[Protocol],
		[Port],
		[Uri],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@UserID,
		@Host,
		@Protocol,
		@Port,
		@Uri,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @OWNotifyAgentRegisterID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OWNotifyAgentRegisterDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OWNotifyAgentRegisterDelete;
GO

CREATE PROCEDURE [OW].OWNotifyAgentRegisterDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@OWNotifyAgentRegisterID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblOWNotifyAgentRegister]
	WHERE
		[OWNotifyAgentRegisterID] = @OWNotifyAgentRegisterID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OWNotifyAgentRegisterDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CountrySelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CountrySelect;
GO

CREATE PROCEDURE [OW].CountrySelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.2	
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

	SELECT
		[CountryID],
		[Code],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblCountry]
	WHERE
		(@CountryID IS NULL OR [CountryID] = @CountryID) AND
		(@Code IS NULL OR [Code] = @Code) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CountrySelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CountrySelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CountrySelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CountrySelectPaging;
GO

CREATE PROCEDURE [OW].CountrySelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@CountryID int = NULL,
	@Code char(2) = NULL,
	@Description varchar(80) = NULL,
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
	
	IF(@CountryID IS NOT NULL) SET @WHERE = @WHERE + '([CountryID] = @CountryID) AND '
	IF(@Code IS NOT NULL) SET @WHERE = @WHERE + '([Code] = @Code) AND '
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
	SELECT @RowCount = COUNT(CountryID) 
	FROM [OW].[tblCountry]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@CountryID int, 
		@Code char(2), 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@CountryID, 
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
	WHERE CountryID IN (
		SELECT TOP ' + @SizeString + ' CountryID
			FROM [OW].[tblCountry]
			WHERE CountryID NOT IN (
				SELECT TOP ' + @PrevString + ' CountryID 
				FROM [OW].[tblCountry]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[CountryID], 
		[Code], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblCountry]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CountrySelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CountrySelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CountryUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CountryUpdate;
GO

CREATE PROCEDURE [OW].CountryUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@CountryID int,
	@Code char(2),
	@Description varchar(80),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblCountry]
	SET
		[Code] = @Code,
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[CountryID] = @CountryID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CountryUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CountryUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CountryInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CountryInsert;
GO

CREATE PROCEDURE [OW].CountryInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@CountryID int = NULL OUTPUT,
	@Code char(2),
	@Description varchar(80),
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
	INTO [OW].[tblCountry]
	(
		[Code],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Code,
		@Description,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @CountryID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CountryInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CountryInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CountryDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CountryDelete;
GO

CREATE PROCEDURE [OW].CountryDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@CountryID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CountryDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CountryDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DistrictSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DistrictSelect;
GO

CREATE PROCEDURE [OW].DistrictSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.2	
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

	SELECT
		[DistrictID],
		[CountryID],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDistrict]
	WHERE
		(@DistrictID IS NULL OR [DistrictID] = @DistrictID) AND
		(@CountryID IS NULL OR [CountryID] = @CountryID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DistrictSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DistrictSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DistrictSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DistrictSelectPaging;
GO

CREATE PROCEDURE [OW].DistrictSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DistrictID int = NULL,
	@CountryID int = NULL,
	@Description varchar(80) = NULL,
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
	
	IF(@DistrictID IS NOT NULL) SET @WHERE = @WHERE + '([DistrictID] = @DistrictID) AND '
	IF(@CountryID IS NOT NULL) SET @WHERE = @WHERE + '([CountryID] = @CountryID) AND '
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
	SELECT @RowCount = COUNT(DistrictID) 
	FROM [OW].[tblDistrict]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@DistrictID int, 
		@CountryID int, 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@DistrictID, 
		@CountryID, 
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
	WHERE DistrictID IN (
		SELECT TOP ' + @SizeString + ' DistrictID
			FROM [OW].[tblDistrict]
			WHERE DistrictID NOT IN (
				SELECT TOP ' + @PrevString + ' DistrictID 
				FROM [OW].[tblDistrict]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[DistrictID], 
		[CountryID], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblDistrict]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DistrictSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DistrictSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DistrictUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DistrictUpdate;
GO

CREATE PROCEDURE [OW].DistrictUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DistrictID int,
	@CountryID int,
	@Description varchar(80),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblDistrict]
	SET
		[CountryID] = @CountryID,
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[DistrictID] = @DistrictID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DistrictUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DistrictUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DistrictInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DistrictInsert;
GO

CREATE PROCEDURE [OW].DistrictInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DistrictID int = NULL OUTPUT,
	@CountryID int,
	@Description varchar(80),
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
	INTO [OW].[tblDistrict]
	(
		[CountryID],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@CountryID,
		@Description,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @DistrictID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DistrictInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DistrictInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DistrictDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DistrictDelete;
GO

CREATE PROCEDURE [OW].DistrictDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DistrictID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DistrictDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DistrictDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateSelect;
GO

CREATE PROCEDURE [OW].DocumentTemplateSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.2	
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

	SELECT
		[DocumentTemplateID],
		[DocumentCode],
		[Description],
		[FileID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDocumentTemplate]
	WHERE
		(@DocumentTemplateID IS NULL OR [DocumentTemplateID] = @DocumentTemplateID) AND
		(@DocumentCode IS NULL OR [DocumentCode] LIKE @DocumentCode) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@FileID IS NULL OR [FileID] = @FileID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateSelectPaging;
GO

CREATE PROCEDURE [OW].DocumentTemplateSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateID int = NULL,
	@DocumentCode varchar(20) = NULL,
	@Description varchar(255) = NULL,
	@FileID int = NULL,
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
	
	IF(@DocumentTemplateID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentTemplateID] = @DocumentTemplateID) AND '
	IF(@DocumentCode IS NOT NULL) SET @WHERE = @WHERE + '([DocumentCode] LIKE @DocumentCode) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@FileID IS NOT NULL) SET @WHERE = @WHERE + '([FileID] = @FileID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(DocumentTemplateID) 
	FROM [OW].[tblDocumentTemplate]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@DocumentTemplateID int, 
		@DocumentCode varchar(20), 
		@Description varchar(255), 
		@FileID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@DocumentTemplateID, 
		@DocumentCode, 
		@Description, 
		@FileID, 
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
	WHERE DocumentTemplateID IN (
		SELECT TOP ' + @SizeString + ' DocumentTemplateID
			FROM [OW].[tblDocumentTemplate]
			WHERE DocumentTemplateID NOT IN (
				SELECT TOP ' + @PrevString + ' DocumentTemplateID 
				FROM [OW].[tblDocumentTemplate]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[DocumentTemplateID], 
		[DocumentCode], 
		[Description], 
		[FileID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblDocumentTemplate]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateUpdate;
GO

CREATE PROCEDURE [OW].DocumentTemplateUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateID int,
	@DocumentCode varchar(20),
	@Description varchar(255),
	@FileID int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblDocumentTemplate]
	SET
		[DocumentCode] = @DocumentCode,
		[Description] = @Description,
		[FileID] = @FileID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[DocumentTemplateID] = @DocumentTemplateID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateInsert;
GO

CREATE PROCEDURE [OW].DocumentTemplateInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateID int = NULL OUTPUT,
	@DocumentCode varchar(20),
	@Description varchar(255),
	@FileID int,
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
	INTO [OW].[tblDocumentTemplate]
	(
		[DocumentCode],
		[Description],
		[FileID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@DocumentCode,
		@Description,
		@FileID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @DocumentTemplateID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateDelete;
GO

CREATE PROCEDURE [OW].DocumentTemplateDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblDocumentTemplate]
	WHERE
		[DocumentTemplateID] = @DocumentTemplateID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateFieldSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateFieldSelect;
GO

CREATE PROCEDURE [OW].DocumentTemplateFieldSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.2	
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

	SELECT
		[DocumentTemplateFieldID],
		[DocumentTemplateID],
		[ProcessDynamicFieldID],
		[BookmarkName],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDocumentTemplateField]
	WHERE
		(@DocumentTemplateFieldID IS NULL OR [DocumentTemplateFieldID] = @DocumentTemplateFieldID) AND
		(@DocumentTemplateID IS NULL OR [DocumentTemplateID] = @DocumentTemplateID) AND
		(@ProcessDynamicFieldID IS NULL OR [ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND
		(@BookmarkName IS NULL OR [BookmarkName] LIKE @BookmarkName) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateFieldSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateFieldSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateFieldSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateFieldSelectPaging;
GO

CREATE PROCEDURE [OW].DocumentTemplateFieldSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateFieldID int = NULL,
	@DocumentTemplateID int = NULL,
	@ProcessDynamicFieldID int = NULL,
	@BookmarkName varchar(255) = NULL,
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
	
	IF(@DocumentTemplateFieldID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentTemplateFieldID] = @DocumentTemplateFieldID) AND '
	IF(@DocumentTemplateID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentTemplateID] = @DocumentTemplateID) AND '
	IF(@ProcessDynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND '
	IF(@BookmarkName IS NOT NULL) SET @WHERE = @WHERE + '([BookmarkName] LIKE @BookmarkName) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(DocumentTemplateFieldID) 
	FROM [OW].[tblDocumentTemplateField]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@DocumentTemplateFieldID int, 
		@DocumentTemplateID int, 
		@ProcessDynamicFieldID int, 
		@BookmarkName varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@DocumentTemplateFieldID, 
		@DocumentTemplateID, 
		@ProcessDynamicFieldID, 
		@BookmarkName, 
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
	WHERE DocumentTemplateFieldID IN (
		SELECT TOP ' + @SizeString + ' DocumentTemplateFieldID
			FROM [OW].[tblDocumentTemplateField]
			WHERE DocumentTemplateFieldID NOT IN (
				SELECT TOP ' + @PrevString + ' DocumentTemplateFieldID 
				FROM [OW].[tblDocumentTemplateField]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[DocumentTemplateFieldID], 
		[DocumentTemplateID], 
		[ProcessDynamicFieldID], 
		[BookmarkName], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblDocumentTemplateField]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateFieldSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateFieldSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateFieldUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateFieldUpdate;
GO

CREATE PROCEDURE [OW].DocumentTemplateFieldUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateFieldID int,
	@DocumentTemplateID int,
	@ProcessDynamicFieldID int,
	@BookmarkName varchar(255),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblDocumentTemplateField]
	SET
		[DocumentTemplateID] = @DocumentTemplateID,
		[ProcessDynamicFieldID] = @ProcessDynamicFieldID,
		[BookmarkName] = @BookmarkName,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[DocumentTemplateFieldID] = @DocumentTemplateFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateFieldUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateFieldUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateFieldInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateFieldInsert;
GO

CREATE PROCEDURE [OW].DocumentTemplateFieldInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateFieldID int = NULL OUTPUT,
	@DocumentTemplateID int,
	@ProcessDynamicFieldID int,
	@BookmarkName varchar(255),
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
	INTO [OW].[tblDocumentTemplateField]
	(
		[DocumentTemplateID],
		[ProcessDynamicFieldID],
		[BookmarkName],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@DocumentTemplateID,
		@ProcessDynamicFieldID,
		@BookmarkName,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @DocumentTemplateFieldID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateFieldInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateFieldInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentTemplateFieldDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentTemplateFieldDelete;
GO

CREATE PROCEDURE [OW].DocumentTemplateFieldDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:15
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentTemplateFieldID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblDocumentTemplateField]
	WHERE
		[DocumentTemplateFieldID] = @DocumentTemplateFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentTemplateFieldDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentTemplateFieldDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldSelect;
GO

CREATE PROCEDURE [OW].DynamicFieldSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
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

	SELECT
		[DynamicFieldID],
		[Description],
		[DynamicFieldTypeID],
		[ListOfValuesID],
		[Precision],
		[Scale],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDynamicField]
	WHERE
		(@DynamicFieldID IS NULL OR [DynamicFieldID] = @DynamicFieldID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@DynamicFieldTypeID IS NULL OR [DynamicFieldTypeID] = @DynamicFieldTypeID) AND
		(@ListOfValuesID IS NULL OR [ListOfValuesID] = @ListOfValuesID) AND
		(@Precision IS NULL OR [Precision] = @Precision) AND
		(@Scale IS NULL OR [Scale] = @Scale) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldSelectPaging;
GO

CREATE PROCEDURE [OW].DynamicFieldSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
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
	
	IF(@DynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([DynamicFieldID] = @DynamicFieldID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@DynamicFieldTypeID IS NOT NULL) SET @WHERE = @WHERE + '([DynamicFieldTypeID] = @DynamicFieldTypeID) AND '
	IF(@ListOfValuesID IS NOT NULL) SET @WHERE = @WHERE + '([ListOfValuesID] = @ListOfValuesID) AND '
	IF(@Precision IS NOT NULL) SET @WHERE = @WHERE + '([Precision] = @Precision) AND '
	IF(@Scale IS NOT NULL) SET @WHERE = @WHERE + '([Scale] = @Scale) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(DynamicFieldID) 
	FROM [OW].[tblDynamicField]
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
		@Precision int, 
		@Scale int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE DynamicFieldID IN (
		SELECT TOP ' + @SizeString + ' DynamicFieldID
			FROM [OW].[tblDynamicField]
			WHERE DynamicFieldID NOT IN (
				SELECT TOP ' + @PrevString + ' DynamicFieldID 
				FROM [OW].[tblDynamicField]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[DynamicFieldID], 
		[Description], 
		[DynamicFieldTypeID], 
		[ListOfValuesID], 
		[Precision], 
		[Scale], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblDynamicField]
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldUpdate;
GO

CREATE PROCEDURE [OW].DynamicFieldUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@DynamicFieldID int,
	@Description varchar(80),
	@DynamicFieldTypeID int,
	@ListOfValuesID int = NULL,
	@Precision int,
	@Scale int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblDynamicField]
	SET
		[Description] = @Description,
		[DynamicFieldTypeID] = @DynamicFieldTypeID,
		[ListOfValuesID] = @ListOfValuesID,
		[Precision] = @Precision,
		[Scale] = @Scale,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[DynamicFieldID] = @DynamicFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldInsert;
GO

CREATE PROCEDURE [OW].DynamicFieldInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@DynamicFieldID int = NULL OUTPUT,
	@Description varchar(80),
	@DynamicFieldTypeID int,
	@ListOfValuesID int = NULL,
	@Precision int,
	@Scale int,
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
	INTO [OW].[tblDynamicField]
	(
		[Description],
		[DynamicFieldTypeID],
		[ListOfValuesID],
		[Precision],
		[Scale],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@DynamicFieldTypeID,
		@ListOfValuesID,
		@Precision,
		@Scale,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @DynamicFieldID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DynamicFieldDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DynamicFieldDelete;
GO

CREATE PROCEDURE [OW].DynamicFieldDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@DynamicFieldID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblDynamicField]
	WHERE
		[DynamicFieldID] = @DynamicFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DynamicFieldDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DynamicFieldDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesSelect;
GO

CREATE PROCEDURE [OW].EntitiesSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-04-2006 15:43:14
	--Version: 1.2	
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
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblEntities]
	WHERE
		(@EntID IS NULL OR [EntID] = @EntID) AND
		(@PublicCode IS NULL OR [PublicCode] LIKE @PublicCode) AND
		(@Name IS NULL OR [Name] LIKE @Name) AND
		(@FirstName IS NULL OR [FirstName] LIKE @FirstName) AND
		(@MiddleName IS NULL OR [MiddleName] LIKE @MiddleName) AND
		(@LastName IS NULL OR [LastName] LIKE @LastName) AND
		(@ListID IS NULL OR [ListID] = @ListID) AND
		(@BI IS NULL OR [BI] LIKE @BI) AND
		(@NumContribuinte IS NULL OR [NumContribuinte] LIKE @NumContribuinte) AND
		(@AssociateNum IS NULL OR [AssociateNum] = @AssociateNum) AND
		(@eMail IS NULL OR [eMail] LIKE @eMail) AND
		(@InternetSite IS NULL OR [InternetSite] LIKE @InternetSite) AND
		(@JobTitle IS NULL OR [JobTitle] LIKE @JobTitle) AND
		(@Street IS NULL OR [Street] LIKE @Street) AND
		(@PostalCodeID IS NULL OR [PostalCodeID] = @PostalCodeID) AND
		(@CountryID IS NULL OR [CountryID] = @CountryID) AND
		(@Phone IS NULL OR [Phone] LIKE @Phone) AND
		(@Fax IS NULL OR [Fax] LIKE @Fax) AND
		(@Mobile IS NULL OR [Mobile] LIKE @Mobile) AND
		(@DistrictID IS NULL OR [DistrictID] = @DistrictID) AND
		(@EntityID IS NULL OR [EntityID] = @EntityID) AND
		(@EntityTypeID IS NULL OR [EntityTypeID] = @EntityTypeID) AND
		(@Active IS NULL OR [Active] = @Active) AND
		(@Type IS NULL OR [Type] = @Type) AND
		(@BIEmissionDate IS NULL OR [BIEmissionDate] = @BIEmissionDate) AND
		(@BIArquiveID IS NULL OR [BIArquiveID] = @BIArquiveID) AND
		(@JobPositionID IS NULL OR [JobPositionID] = @JobPositionID) AND
		(@LocationID IS NULL OR [LocationID] = @LocationID) AND
		(@Contact IS NULL OR [Contact] LIKE @Contact) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesSelectPaging;
GO

CREATE PROCEDURE [OW].EntitiesSelectPaging
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesUpdate;
GO

CREATE PROCEDURE [OW].EntitiesUpdate
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesInsert;
GO

CREATE PROCEDURE [OW].EntitiesInsert
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntitiesDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntitiesDelete;
GO

CREATE PROCEDURE [OW].EntitiesDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-04-2006 15:43:14
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntID numeric(18,0) = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntitiesDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntitiesDelete Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntityTypeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntityTypeSelect;
GO

CREATE PROCEDURE [OW].EntityTypeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
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

	SELECT
		[EntityTypeID],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblEntityType]
	WHERE
		(@EntityTypeID IS NULL OR [EntityTypeID] = @EntityTypeID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntityTypeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntityTypeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntityTypeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntityTypeSelectPaging;
GO

CREATE PROCEDURE [OW].EntityTypeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntityTypeID int = NULL,
	@Description varchar(80) = NULL,
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
	
	IF(@EntityTypeID IS NOT NULL) SET @WHERE = @WHERE + '([EntityTypeID] = @EntityTypeID) AND '
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
	SELECT @RowCount = COUNT(EntityTypeID) 
	FROM [OW].[tblEntityType]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@EntityTypeID int, 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@EntityTypeID, 
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
	WHERE EntityTypeID IN (
		SELECT TOP ' + @SizeString + ' EntityTypeID
			FROM [OW].[tblEntityType]
			WHERE EntityTypeID NOT IN (
				SELECT TOP ' + @PrevString + ' EntityTypeID 
				FROM [OW].[tblEntityType]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[EntityTypeID], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblEntityType]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntityTypeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntityTypeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntityTypeUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntityTypeUpdate;
GO

CREATE PROCEDURE [OW].EntityTypeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntityTypeID int,
	@Description varchar(80),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblEntityType]
	SET
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[EntityTypeID] = @EntityTypeID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntityTypeUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntityTypeUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntityTypeInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntityTypeInsert;
GO

CREATE PROCEDURE [OW].EntityTypeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntityTypeID int = NULL OUTPUT,
	@Description varchar(80),
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
	INTO [OW].[tblEntityType]
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
	SELECT @EntityTypeID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntityTypeInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntityTypeInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].EntityTypeDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].EntityTypeDelete;
GO

CREATE PROCEDURE [OW].EntityTypeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@EntityTypeID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblEntityType]
	WHERE
		[EntityTypeID] = @EntityTypeID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].EntityTypeDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].EntityTypeDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowSelect;
GO

CREATE PROCEDURE [OW].FlowSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
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

	SELECT
		[FlowID],
		[Code],
		[Status],
		[FlowOwnerID],
		[FlowDefinitionID],
		[MajorVersion],
		[MinorVersion],
		[Duration],
		[WorkCalendar],
		[ProcessNumberRule],
		[HelpAddress],
		[NotifyRetrocession],
		[WorkflowRule],
		[Adhoc],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFlow]
	WHERE
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@Code IS NULL OR [Code] LIKE @Code) AND
		(@Status IS NULL OR [Status] = @Status) AND
		(@FlowOwnerID IS NULL OR [FlowOwnerID] = @FlowOwnerID) AND
		(@FlowDefinitionID IS NULL OR [FlowDefinitionID] = @FlowDefinitionID) AND
		(@MajorVersion IS NULL OR [MajorVersion] = @MajorVersion) AND
		(@MinorVersion IS NULL OR [MinorVersion] = @MinorVersion) AND
		(@Duration IS NULL OR [Duration] = @Duration) AND
		(@WorkCalendar IS NULL OR [WorkCalendar] = @WorkCalendar) AND
		(@ProcessNumberRule IS NULL OR [ProcessNumberRule] LIKE @ProcessNumberRule) AND
		(@HelpAddress IS NULL OR [HelpAddress] LIKE @HelpAddress) AND
		(@NotifyRetrocession IS NULL OR [NotifyRetrocession] = @NotifyRetrocession) AND
		(@WorkflowRule IS NULL OR [WorkflowRule] LIKE @WorkflowRule) AND
		(@Adhoc IS NULL OR [Adhoc] = @Adhoc) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowSelectPaging;
GO

CREATE PROCEDURE [OW].FlowSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
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
	
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@Code IS NOT NULL) SET @WHERE = @WHERE + '([Code] LIKE @Code) AND '
	IF(@Status IS NOT NULL) SET @WHERE = @WHERE + '([Status] = @Status) AND '
	IF(@FlowOwnerID IS NOT NULL) SET @WHERE = @WHERE + '([FlowOwnerID] = @FlowOwnerID) AND '
	IF(@FlowDefinitionID IS NOT NULL) SET @WHERE = @WHERE + '([FlowDefinitionID] = @FlowDefinitionID) AND '
	IF(@MajorVersion IS NOT NULL) SET @WHERE = @WHERE + '([MajorVersion] = @MajorVersion) AND '
	IF(@MinorVersion IS NOT NULL) SET @WHERE = @WHERE + '([MinorVersion] = @MinorVersion) AND '
	IF(@Duration IS NOT NULL) SET @WHERE = @WHERE + '([Duration] = @Duration) AND '
	IF(@WorkCalendar IS NOT NULL) SET @WHERE = @WHERE + '([WorkCalendar] = @WorkCalendar) AND '
	IF(@ProcessNumberRule IS NOT NULL) SET @WHERE = @WHERE + '([ProcessNumberRule] LIKE @ProcessNumberRule) AND '
	IF(@HelpAddress IS NOT NULL) SET @WHERE = @WHERE + '([HelpAddress] LIKE @HelpAddress) AND '
	IF(@NotifyRetrocession IS NOT NULL) SET @WHERE = @WHERE + '([NotifyRetrocession] = @NotifyRetrocession) AND '
	IF(@WorkflowRule IS NOT NULL) SET @WHERE = @WHERE + '([WorkflowRule] LIKE @WorkflowRule) AND '
	IF(@Adhoc IS NOT NULL) SET @WHERE = @WHERE + '([Adhoc] = @Adhoc) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FlowID) 
	FROM [OW].[tblFlow]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE FlowID IN (
		SELECT TOP ' + @SizeString + ' FlowID
			FROM [OW].[tblFlow]
			WHERE FlowID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowID 
				FROM [OW].[tblFlow]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowID], 
		[Code], 
		[Status], 
		[FlowOwnerID], 
		[FlowDefinitionID], 
		[MajorVersion], 
		[MinorVersion], 
		[Duration], 
		[WorkCalendar], 
		[ProcessNumberRule], 
		[HelpAddress], 
		[NotifyRetrocession], 
		[WorkflowRule], 
		[Adhoc], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFlow]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowUpdate;
GO

CREATE PROCEDURE [OW].FlowUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowID int,
	@Code varchar(10),
	@Status tinyint,
	@FlowOwnerID int,
	@FlowDefinitionID int = NULL,
	@MajorVersion int,
	@MinorVersion int,
	@Duration int,
	@WorkCalendar bit,
	@ProcessNumberRule varchar(1024) = NULL,
	@HelpAddress varchar(255) = NULL,
	@NotifyRetrocession bit,
	@WorkflowRule text,
	@Adhoc bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFlow]
	SET
		[Code] = @Code,
		[Status] = @Status,
		[FlowOwnerID] = @FlowOwnerID,
		[FlowDefinitionID] = @FlowDefinitionID,
		[MajorVersion] = @MajorVersion,
		[MinorVersion] = @MinorVersion,
		[Duration] = @Duration,
		[WorkCalendar] = @WorkCalendar,
		[ProcessNumberRule] = @ProcessNumberRule,
		[HelpAddress] = @HelpAddress,
		[NotifyRetrocession] = @NotifyRetrocession,
		[WorkflowRule] = @WorkflowRule,
		[Adhoc] = @Adhoc,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[FlowID] = @FlowID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowInsert;
GO

CREATE PROCEDURE [OW].FlowInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowID int = NULL OUTPUT,
	@Code varchar(10),
	@Status tinyint,
	@FlowOwnerID int,
	@FlowDefinitionID int = NULL,
	@MajorVersion int,
	@MinorVersion int,
	@Duration int,
	@WorkCalendar bit,
	@ProcessNumberRule varchar(1024) = NULL,
	@HelpAddress varchar(255) = NULL,
	@NotifyRetrocession bit,
	@WorkflowRule text,
	@Adhoc bit,
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
	INTO [OW].[tblFlow]
	(
		[Code],
		[Status],
		[FlowOwnerID],
		[FlowDefinitionID],
		[MajorVersion],
		[MinorVersion],
		[Duration],
		[WorkCalendar],
		[ProcessNumberRule],
		[HelpAddress],
		[NotifyRetrocession],
		[WorkflowRule],
		[Adhoc],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @FlowID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowDelete;
GO

CREATE PROCEDURE [OW].FlowDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFlow]
	WHERE
		[FlowID] = @FlowID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDefinitionSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowDefinitionSelect;
GO

CREATE PROCEDURE [OW].FlowDefinitionSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
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

	SELECT
		[FlowDefinitionID],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFlowDefinition]
	WHERE
		(@FlowDefinitionID IS NULL OR [FlowDefinitionID] = @FlowDefinitionID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDefinitionSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowDefinitionSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDefinitionSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowDefinitionSelectPaging;
GO

CREATE PROCEDURE [OW].FlowDefinitionSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowDefinitionID int = NULL,
	@Description varchar(80) = NULL,
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
	
	IF(@FlowDefinitionID IS NOT NULL) SET @WHERE = @WHERE + '([FlowDefinitionID] = @FlowDefinitionID) AND '
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
	SELECT @RowCount = COUNT(FlowDefinitionID) 
	FROM [OW].[tblFlowDefinition]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@FlowDefinitionID int, 
		@Description varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@FlowDefinitionID, 
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
	WHERE FlowDefinitionID IN (
		SELECT TOP ' + @SizeString + ' FlowDefinitionID
			FROM [OW].[tblFlowDefinition]
			WHERE FlowDefinitionID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowDefinitionID 
				FROM [OW].[tblFlowDefinition]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowDefinitionID], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFlowDefinition]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDefinitionSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowDefinitionSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDefinitionUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowDefinitionUpdate;
GO

CREATE PROCEDURE [OW].FlowDefinitionUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowDefinitionID int,
	@Description varchar(80),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFlowDefinition]
	SET
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[FlowDefinitionID] = @FlowDefinitionID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDefinitionUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowDefinitionUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDefinitionInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowDefinitionInsert;
GO

CREATE PROCEDURE [OW].FlowDefinitionInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowDefinitionID int = NULL OUTPUT,
	@Description varchar(80),
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
	INTO [OW].[tblFlowDefinition]
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
	SELECT @FlowDefinitionID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDefinitionInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowDefinitionInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowDefinitionDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowDefinitionDelete;
GO

CREATE PROCEDURE [OW].FlowDefinitionDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowDefinitionID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFlowDefinition]
	WHERE
		[FlowDefinitionID] = @FlowDefinitionID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowDefinitionDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowDefinitionDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorSelect;
GO

CREATE PROCEDURE [OW].FlowMailConnectorSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
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

	SELECT
		[MailConnectorID],
		[Folder],
		[FlowID],
		[FromAddress],
		[AttachMail],
		[AttachFiles],
		[CompleteStage],
		[Active],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFlowMailConnector]
	WHERE
		(@MailConnectorID IS NULL OR [MailConnectorID] = @MailConnectorID) AND
		(@Folder IS NULL OR [Folder] LIKE @Folder) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@FromAddress IS NULL OR [FromAddress] LIKE @FromAddress) AND
		(@AttachMail IS NULL OR [AttachMail] = @AttachMail) AND
		(@AttachFiles IS NULL OR [AttachFiles] = @AttachFiles) AND
		(@CompleteStage IS NULL OR [CompleteStage] = @CompleteStage) AND
		(@Active IS NULL OR [Active] = @Active) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorSelectPaging;
GO

CREATE PROCEDURE [OW].FlowMailConnectorSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
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
	
	IF(@MailConnectorID IS NOT NULL) SET @WHERE = @WHERE + '([MailConnectorID] = @MailConnectorID) AND '
	IF(@Folder IS NOT NULL) SET @WHERE = @WHERE + '([Folder] LIKE @Folder) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@FromAddress IS NOT NULL) SET @WHERE = @WHERE + '([FromAddress] LIKE @FromAddress) AND '
	IF(@AttachMail IS NOT NULL) SET @WHERE = @WHERE + '([AttachMail] = @AttachMail) AND '
	IF(@AttachFiles IS NOT NULL) SET @WHERE = @WHERE + '([AttachFiles] = @AttachFiles) AND '
	IF(@CompleteStage IS NOT NULL) SET @WHERE = @WHERE + '([CompleteStage] = @CompleteStage) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '([Active] = @Active) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(MailConnectorID) 
	FROM [OW].[tblFlowMailConnector]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE MailConnectorID IN (
		SELECT TOP ' + @SizeString + ' MailConnectorID
			FROM [OW].[tblFlowMailConnector]
			WHERE MailConnectorID NOT IN (
				SELECT TOP ' + @PrevString + ' MailConnectorID 
				FROM [OW].[tblFlowMailConnector]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[MailConnectorID], 
		[Folder], 
		[FlowID], 
		[FromAddress], 
		[AttachMail], 
		[AttachFiles], 
		[CompleteStage], 
		[Active], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFlowMailConnector]
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorUpdate;
GO

CREATE PROCEDURE [OW].FlowMailConnectorUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@MailConnectorID int,
	@Folder varchar(255),
	@FlowID int,
	@FromAddress varchar(50) = NULL,
	@AttachMail bit = NULL,
	@AttachFiles bit = NULL,
	@CompleteStage bit = NULL,
	@Active bit = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFlowMailConnector]
	SET
		[Folder] = @Folder,
		[FlowID] = @FlowID,
		[FromAddress] = @FromAddress,
		[AttachMail] = @AttachMail,
		[AttachFiles] = @AttachFiles,
		[CompleteStage] = @CompleteStage,
		[Active] = @Active,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[MailConnectorID] = @MailConnectorID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorInsert;
GO

CREATE PROCEDURE [OW].FlowMailConnectorInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@MailConnectorID int = NULL OUTPUT,
	@Folder varchar(255),
	@FlowID int,
	@FromAddress varchar(50) = NULL,
	@AttachMail bit = NULL,
	@AttachFiles bit = NULL,
	@CompleteStage bit = NULL,
	@Active bit = NULL,
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
	INTO [OW].[tblFlowMailConnector]
	(
		[Folder],
		[FlowID],
		[FromAddress],
		[AttachMail],
		[AttachFiles],
		[CompleteStage],
		[Active],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Folder,
		@FlowID,
		@FromAddress,
		@AttachMail,
		@AttachFiles,
		@CompleteStage,
		@Active,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @MailConnectorID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowMailConnectorDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowMailConnectorDelete;
GO

CREATE PROCEDURE [OW].FlowMailConnectorDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@MailConnectorID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFlowMailConnector]
	WHERE
		[MailConnectorID] = @MailConnectorID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowMailConnectorDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowMailConnectorDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowPreBuiltStageSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowPreBuiltStageSelect;
GO

CREATE PROCEDURE [OW].FlowPreBuiltStageSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
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

	SELECT
		[FlowPreBuiltStageID],
		[Description],
		[FlowStageType],
		[Address],
		[Method],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFlowPreBuiltStage]
	WHERE
		(@FlowPreBuiltStageID IS NULL OR [FlowPreBuiltStageID] = @FlowPreBuiltStageID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@FlowStageType IS NULL OR [FlowStageType] = @FlowStageType) AND
		(@Address IS NULL OR [Address] LIKE @Address) AND
		(@Method IS NULL OR [Method] LIKE @Method) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowPreBuiltStageSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowPreBuiltStageSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowPreBuiltStageSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowPreBuiltStageSelectPaging;
GO

CREATE PROCEDURE [OW].FlowPreBuiltStageSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
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
	
	IF(@FlowPreBuiltStageID IS NOT NULL) SET @WHERE = @WHERE + '([FlowPreBuiltStageID] = @FlowPreBuiltStageID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@FlowStageType IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageType] = @FlowStageType) AND '
	IF(@Address IS NOT NULL) SET @WHERE = @WHERE + '([Address] LIKE @Address) AND '
	IF(@Method IS NOT NULL) SET @WHERE = @WHERE + '([Method] LIKE @Method) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FlowPreBuiltStageID) 
	FROM [OW].[tblFlowPreBuiltStage]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@FlowPreBuiltStageID int, 
		@Description varchar(80), 
		@FlowStageType smallint, 
		@Address varchar(255), 
		@Method varchar(80), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@FlowPreBuiltStageID, 
		@Description, 
		@FlowStageType, 
		@Address, 
		@Method, 
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
	WHERE FlowPreBuiltStageID IN (
		SELECT TOP ' + @SizeString + ' FlowPreBuiltStageID
			FROM [OW].[tblFlowPreBuiltStage]
			WHERE FlowPreBuiltStageID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowPreBuiltStageID 
				FROM [OW].[tblFlowPreBuiltStage]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowPreBuiltStageID], 
		[Description], 
		[FlowStageType], 
		[Address], 
		[Method], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFlowPreBuiltStage]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowPreBuiltStageSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowPreBuiltStageSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowPreBuiltStageUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowPreBuiltStageUpdate;
GO

CREATE PROCEDURE [OW].FlowPreBuiltStageUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowPreBuiltStageID int,
	@Description varchar(80),
	@FlowStageType smallint,
	@Address varchar(255) = NULL,
	@Method varchar(80) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFlowPreBuiltStage]
	SET
		[Description] = @Description,
		[FlowStageType] = @FlowStageType,
		[Address] = @Address,
		[Method] = @Method,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[FlowPreBuiltStageID] = @FlowPreBuiltStageID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowPreBuiltStageUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowPreBuiltStageUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowPreBuiltStageInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowPreBuiltStageInsert;
GO

CREATE PROCEDURE [OW].FlowPreBuiltStageInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowPreBuiltStageID int = NULL OUTPUT,
	@Description varchar(80),
	@FlowStageType smallint,
	@Address varchar(255) = NULL,
	@Method varchar(80) = NULL,
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
	INTO [OW].[tblFlowPreBuiltStage]
	(
		[Description],
		[FlowStageType],
		[Address],
		[Method],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@FlowStageType,
		@Address,
		@Method,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @FlowPreBuiltStageID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowPreBuiltStageInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowPreBuiltStageInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowPreBuiltStageDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowPreBuiltStageDelete;
GO

CREATE PROCEDURE [OW].FlowPreBuiltStageDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowPreBuiltStageID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFlowPreBuiltStage]
	WHERE
		[FlowPreBuiltStageID] = @FlowPreBuiltStageID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowPreBuiltStageDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowPreBuiltStageDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingSelect;
GO

CREATE PROCEDURE [OW].FlowRoutingSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.2	
	------------------------------------------------------------------------
	@FlowRoutingID int = NULL,
	@OrganizationalUnitID int = NULL,
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@FlowID int = NULL,
	@ToOrganizationalUnitID int = NULL,
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
		[FlowRoutingID],
		[OrganizationalUnitID],
		[StartDate],
		[EndDate],
		[FlowID],
		[ToOrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFlowRouting]
	WHERE
		(@FlowRoutingID IS NULL OR [FlowRoutingID] = @FlowRoutingID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@StartDate IS NULL OR [StartDate] = @StartDate) AND
		(@EndDate IS NULL OR [EndDate] = @EndDate) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@ToOrganizationalUnitID IS NULL OR [ToOrganizationalUnitID] = @ToOrganizationalUnitID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowRoutingSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingSelectPaging;
GO

CREATE PROCEDURE [OW].FlowRoutingSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowRoutingID int = NULL,
	@OrganizationalUnitID int = NULL,
	@StartDate datetime = NULL,
	@EndDate datetime = NULL,
	@FlowID int = NULL,
	@ToOrganizationalUnitID int = NULL,
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
	
	IF(@FlowRoutingID IS NOT NULL) SET @WHERE = @WHERE + '([FlowRoutingID] = @FlowRoutingID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@StartDate IS NOT NULL) SET @WHERE = @WHERE + '([StartDate] = @StartDate) AND '
	IF(@EndDate IS NOT NULL) SET @WHERE = @WHERE + '([EndDate] = @EndDate) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@ToOrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([ToOrganizationalUnitID] = @ToOrganizationalUnitID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FlowRoutingID) 
	FROM [OW].[tblFlowRouting]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@FlowRoutingID int, 
		@OrganizationalUnitID int, 
		@StartDate datetime, 
		@EndDate datetime, 
		@FlowID int, 
		@ToOrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@FlowRoutingID, 
		@OrganizationalUnitID, 
		@StartDate, 
		@EndDate, 
		@FlowID, 
		@ToOrganizationalUnitID, 
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
	WHERE FlowRoutingID IN (
		SELECT TOP ' + @SizeString + ' FlowRoutingID
			FROM [OW].[tblFlowRouting]
			WHERE FlowRoutingID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowRoutingID 
				FROM [OW].[tblFlowRouting]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowRoutingID], 
		[OrganizationalUnitID], 
		[StartDate], 
		[EndDate], 
		[FlowID], 
		[ToOrganizationalUnitID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFlowRouting]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@FlowRoutingID int, 
		@OrganizationalUnitID int, 
		@StartDate datetime, 
		@EndDate datetime, 
		@FlowID int, 
		@ToOrganizationalUnitID int, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowRoutingSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingUpdate;
GO

CREATE PROCEDURE [OW].FlowRoutingUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:16
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowRoutingID int,
	@OrganizationalUnitID int,
	@StartDate datetime,
	@EndDate datetime,
	@FlowID int = NULL,
	@ToOrganizationalUnitID int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFlowRouting]
	SET
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[StartDate] = @StartDate,
		[EndDate] = @EndDate,
		[FlowID] = @FlowID,
		[ToOrganizationalUnitID] = @ToOrganizationalUnitID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[FlowRoutingID] = @FlowRoutingID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowRoutingUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingInsert;
GO

CREATE PROCEDURE [OW].FlowRoutingInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowRoutingID int = NULL OUTPUT,
	@OrganizationalUnitID int,
	@StartDate datetime,
	@EndDate datetime,
	@FlowID int = NULL,
	@ToOrganizationalUnitID int,
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
	INTO [OW].[tblFlowRouting]
	(
		[OrganizationalUnitID],
		[StartDate],
		[EndDate],
		[FlowID],
		[ToOrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@OrganizationalUnitID,
		@StartDate,
		@EndDate,
		@FlowID,
		@ToOrganizationalUnitID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @FlowRoutingID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowRoutingInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingDelete;
GO

CREATE PROCEDURE [OW].FlowRoutingDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowRoutingID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFlowRouting]
	WHERE
		[FlowRoutingID] = @FlowRoutingID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowRoutingDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStageSelect;
GO

CREATE PROCEDURE [OW].FlowStageSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[FlowStageID],
		[FlowID],
		[Number],
		[Description],
		[Duration],
		[Address],
		[Method],
		[FlowStageType],
		[DocumentTemplateID],
		[OrganizationalUnitID],
		[CanAssociateProcess],
		[Transfer],
		[RequestForComments],
		[AttachmentRequired],
		[HelpAddress],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblFlowStage]
	WHERE
		(@FlowStageID IS NULL OR [FlowStageID] = @FlowStageID) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@Number IS NULL OR [Number] = @Number) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Duration IS NULL OR [Duration] = @Duration) AND
		(@Address IS NULL OR [Address] LIKE @Address) AND
		(@Method IS NULL OR [Method] LIKE @Method) AND
		(@FlowStageType IS NULL OR [FlowStageType] = @FlowStageType) AND
		(@DocumentTemplateID IS NULL OR [DocumentTemplateID] = @DocumentTemplateID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@CanAssociateProcess IS NULL OR [CanAssociateProcess] = @CanAssociateProcess) AND
		(@Transfer IS NULL OR [Transfer] = @Transfer) AND
		(@RequestForComments IS NULL OR [RequestForComments] = @RequestForComments) AND
		(@AttachmentRequired IS NULL OR [AttachmentRequired] = @AttachmentRequired) AND
		(@HelpAddress IS NULL OR [HelpAddress] LIKE @HelpAddress) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStageSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStageSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStageSelectPaging;
GO

CREATE PROCEDURE [OW].FlowStageSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
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
	@HelpAddress varchar(255) = NULL,
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
	
	IF(@FlowStageID IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageID] = @FlowStageID) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@Number IS NOT NULL) SET @WHERE = @WHERE + '([Number] = @Number) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Duration IS NOT NULL) SET @WHERE = @WHERE + '([Duration] = @Duration) AND '
	IF(@Address IS NOT NULL) SET @WHERE = @WHERE + '([Address] LIKE @Address) AND '
	IF(@Method IS NOT NULL) SET @WHERE = @WHERE + '([Method] LIKE @Method) AND '
	IF(@FlowStageType IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageType] = @FlowStageType) AND '
	IF(@DocumentTemplateID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentTemplateID] = @DocumentTemplateID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@CanAssociateProcess IS NOT NULL) SET @WHERE = @WHERE + '([CanAssociateProcess] = @CanAssociateProcess) AND '
	IF(@Transfer IS NOT NULL) SET @WHERE = @WHERE + '([Transfer] = @Transfer) AND '
	IF(@RequestForComments IS NOT NULL) SET @WHERE = @WHERE + '([RequestForComments] = @RequestForComments) AND '
	IF(@AttachmentRequired IS NOT NULL) SET @WHERE = @WHERE + '([AttachmentRequired] = @AttachmentRequired) AND '
	IF(@HelpAddress IS NOT NULL) SET @WHERE = @WHERE + '([HelpAddress] LIKE @HelpAddress) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(FlowStageID) 
	FROM [OW].[tblFlowStage]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@HelpAddress varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
		@HelpAddress, 
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
	WHERE FlowStageID IN (
		SELECT TOP ' + @SizeString + ' FlowStageID
			FROM [OW].[tblFlowStage]
			WHERE FlowStageID NOT IN (
				SELECT TOP ' + @PrevString + ' FlowStageID 
				FROM [OW].[tblFlowStage]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[FlowStageID], 
		[FlowID], 
		[Number], 
		[Description], 
		[Duration], 
		[Address], 
		[Method], 
		[FlowStageType], 
		[DocumentTemplateID], 
		[OrganizationalUnitID], 
		[CanAssociateProcess], 
		[Transfer], 
		[RequestForComments], 
		[AttachmentRequired], 
		[HelpAddress], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblFlowStage]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStageSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStageSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStageUpdate;
GO

CREATE PROCEDURE [OW].FlowStageUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowStageID int,
	@FlowID int,
	@Number smallint,
	@Description varchar(50),
	@Duration int,
	@Address varchar(255) = NULL,
	@Method varchar(50) = NULL,
	@FlowStageType smallint,
	@DocumentTemplateID int = NULL,
	@OrganizationalUnitID int = NULL,
	@CanAssociateProcess bit,
	@Transfer tinyint,
	@RequestForComments tinyint,
	@AttachmentRequired bit,
	@HelpAddress varchar(255) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblFlowStage]
	SET
		[FlowID] = @FlowID,
		[Number] = @Number,
		[Description] = @Description,
		[Duration] = @Duration,
		[Address] = @Address,
		[Method] = @Method,
		[FlowStageType] = @FlowStageType,
		[DocumentTemplateID] = @DocumentTemplateID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[CanAssociateProcess] = @CanAssociateProcess,
		[Transfer] = @Transfer,
		[RequestForComments] = @RequestForComments,
		[AttachmentRequired] = @AttachmentRequired,
		[HelpAddress] = @HelpAddress,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[FlowStageID] = @FlowStageID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStageUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStageUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStageInsert;
GO

CREATE PROCEDURE [OW].FlowStageInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowStageID int = NULL OUTPUT,
	@FlowID int,
	@Number smallint,
	@Description varchar(50),
	@Duration int,
	@Address varchar(255) = NULL,
	@Method varchar(50) = NULL,
	@FlowStageType smallint,
	@DocumentTemplateID int = NULL,
	@OrganizationalUnitID int = NULL,
	@CanAssociateProcess bit,
	@Transfer tinyint,
	@RequestForComments tinyint,
	@AttachmentRequired bit,
	@HelpAddress varchar(255) = NULL,
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
	INTO [OW].[tblFlowStage]
	(
		[FlowID],
		[Number],
		[Description],
		[Duration],
		[Address],
		[Method],
		[FlowStageType],
		[DocumentTemplateID],
		[OrganizationalUnitID],
		[CanAssociateProcess],
		[Transfer],
		[RequestForComments],
		[AttachmentRequired],
		[HelpAddress],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
		@HelpAddress,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @FlowStageID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStageInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStageInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStageDelete;
GO

CREATE PROCEDURE [OW].FlowStageDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowStageID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblFlowStage]
	WHERE
		[FlowStageID] = @FlowStageID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowStageDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowStageDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsSelect;
GO

CREATE PROCEDURE [OW].GroupsSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
	------------------------------------------------------------------------
	@GroupID int = NULL,
	@HierarchyID int = NULL,
	@ShortName varchar(10) = NULL,
	@GroupDesc varchar(100) = NULL,
	@External bit = NULL,
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
		[GroupID],
		[HierarchyID],
		[ShortName],
		[GroupDesc],
		[External],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblGroups]
	WHERE
		(@GroupID IS NULL OR [GroupID] = @GroupID) AND
		(@HierarchyID IS NULL OR [HierarchyID] = @HierarchyID) AND
		(@ShortName IS NULL OR [ShortName] LIKE @ShortName) AND
		(@GroupDesc IS NULL OR [GroupDesc] LIKE @GroupDesc) AND
		(@External IS NULL OR [External] = @External) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsSelectPaging;
GO

CREATE PROCEDURE [OW].GroupsSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int = NULL,
	@HierarchyID int = NULL,
	@ShortName varchar(10) = NULL,
	@GroupDesc varchar(100) = NULL,
	@External bit = NULL,
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
	
	IF(@GroupID IS NOT NULL) SET @WHERE = @WHERE + '([GroupID] = @GroupID) AND '
	IF(@HierarchyID IS NOT NULL) SET @WHERE = @WHERE + '([HierarchyID] = @HierarchyID) AND '
	IF(@ShortName IS NOT NULL) SET @WHERE = @WHERE + '([ShortName] LIKE @ShortName) AND '
	IF(@GroupDesc IS NOT NULL) SET @WHERE = @WHERE + '([GroupDesc] LIKE @GroupDesc) AND '
	IF(@External IS NOT NULL) SET @WHERE = @WHERE + '([External] = @External) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(GroupID) 
	FROM [OW].[tblGroups]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
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
		@External bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@GroupID, 
		@HierarchyID, 
		@ShortName, 
		@GroupDesc, 
		@External, 
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
	WHERE GroupID IN (
		SELECT TOP ' + @SizeString + ' GroupID
			FROM [OW].[tblGroups]
			WHERE GroupID NOT IN (
				SELECT TOP ' + @PrevString + ' GroupID 
				FROM [OW].[tblGroups]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[GroupID], 
		[HierarchyID], 
		[ShortName], 
		[GroupDesc], 
		[External], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblGroups]
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
		@GroupDesc varchar(100), 
		@External bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@GroupID, 
		@HierarchyID, 
		@ShortName, 
		@GroupDesc, 
		@External, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsUpdate;
GO

CREATE PROCEDURE [OW].GroupsUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int,
	@HierarchyID int = NULL,
	@ShortName varchar(10),
	@GroupDesc varchar(100),
	@External bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblGroups]
	SET
		[HierarchyID] = @HierarchyID,
		[ShortName] = @ShortName,
		[GroupDesc] = @GroupDesc,
		[External] = @External,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[GroupID] = @GroupID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsInsert;
GO

CREATE PROCEDURE [OW].GroupsInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int = NULL OUTPUT,
	@HierarchyID int = NULL,
	@ShortName varchar(10),
	@GroupDesc varchar(100),
	@External bit,
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
	INTO [OW].[tblGroups]
	(
		[HierarchyID],
		[ShortName],
		[GroupDesc],
		[External],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@HierarchyID,
		@ShortName,
		@GroupDesc,
		@External,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @GroupID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsDelete;
GO

CREATE PROCEDURE [OW].GroupsDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblGroups]
	WHERE
		[GroupID] = @GroupID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUsersSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsUsersSelect;
GO

CREATE PROCEDURE [OW].GroupsUsersSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
	------------------------------------------------------------------------
	@GroupsUserID int = NULL,
	@UserID int = NULL,
	@GroupID int = NULL,
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
		[GroupsUserID],
		[UserID],
		[GroupID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblGroupsUsers]
	WHERE
		(@GroupsUserID IS NULL OR [GroupsUserID] = @GroupsUserID) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@GroupID IS NULL OR [GroupID] = @GroupID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUsersSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUsersSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsUsersSelectPaging;
GO

CREATE PROCEDURE [OW].GroupsUsersSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupsUserID int = NULL,
	@UserID int = NULL,
	@GroupID int = NULL,
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
	
	IF(@GroupsUserID IS NOT NULL) SET @WHERE = @WHERE + '([GroupsUserID] = @GroupsUserID) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '([UserID] = @UserID) AND '
	IF(@GroupID IS NOT NULL) SET @WHERE = @WHERE + '([GroupID] = @GroupID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(GroupsUserID) 
	FROM [OW].[tblGroupsUsers]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@GroupsUserID int, 
		@UserID int, 
		@GroupID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@GroupsUserID, 
		@UserID, 
		@GroupID, 
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
	WHERE GroupsUserID IN (
		SELECT TOP ' + @SizeString + ' GroupsUserID
			FROM [OW].[tblGroupsUsers]
			WHERE GroupsUserID NOT IN (
				SELECT TOP ' + @PrevString + ' GroupsUserID 
				FROM [OW].[tblGroupsUsers]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[GroupsUserID], 
		[UserID], 
		[GroupID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblGroupsUsers]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@GroupsUserID int, 
		@UserID int, 
		@GroupID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@GroupsUserID, 
		@UserID, 
		@GroupID, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUsersSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUsersUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsUsersUpdate;
GO

CREATE PROCEDURE [OW].GroupsUsersUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupsUserID int,
	@UserID int,
	@GroupID int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblGroupsUsers]
	SET
		[UserID] = @UserID,
		[GroupID] = @GroupID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[GroupsUserID] = @GroupsUserID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUsersUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUsersInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsUsersInsert;
GO

CREATE PROCEDURE [OW].GroupsUsersInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupsUserID int = NULL OUTPUT,
	@UserID int,
	@GroupID int,
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
	INTO [OW].[tblGroupsUsers]
	(
		[UserID],
		[GroupID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@UserID,
		@GroupID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @GroupsUserID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUsersInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].GroupsUsersDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].GroupsUsersDelete;
GO

CREATE PROCEDURE [OW].GroupsUsersDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupsUserID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblGroupsUsers]
	WHERE
		[GroupsUserID] = @GroupsUserID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].GroupsUsersDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].GroupsUsersDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].HolidaySelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].HolidaySelect;
GO

CREATE PROCEDURE [OW].HolidaySelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[HolidayID],
		[HolidayDate],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblHoliday]
	WHERE
		(@HolidayID IS NULL OR [HolidayID] = @HolidayID) AND
		(@HolidayDate IS NULL OR [HolidayDate] = @HolidayDate) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].HolidaySelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].HolidaySelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].HolidaySelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].HolidaySelectPaging;
GO

CREATE PROCEDURE [OW].HolidaySelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@HolidayID int = NULL,
	@HolidayDate datetime = NULL,
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
	
	IF(@HolidayID IS NOT NULL) SET @WHERE = @WHERE + '([HolidayID] = @HolidayID) AND '
	IF(@HolidayDate IS NOT NULL) SET @WHERE = @WHERE + '([HolidayDate] = @HolidayDate) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(HolidayID) 
	FROM [OW].[tblHoliday]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@HolidayID int, 
		@HolidayDate datetime, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@HolidayID, 
		@HolidayDate, 
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
	WHERE HolidayID IN (
		SELECT TOP ' + @SizeString + ' HolidayID
			FROM [OW].[tblHoliday]
			WHERE HolidayID NOT IN (
				SELECT TOP ' + @PrevString + ' HolidayID 
				FROM [OW].[tblHoliday]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[HolidayID], 
		[HolidayDate], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblHoliday]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].HolidaySelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].HolidaySelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].HolidayUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].HolidayUpdate;
GO

CREATE PROCEDURE [OW].HolidayUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@HolidayID int,
	@HolidayDate datetime,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblHoliday]
	SET
		[HolidayDate] = @HolidayDate,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[HolidayID] = @HolidayID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].HolidayUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].HolidayUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].HolidayInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].HolidayInsert;
GO

CREATE PROCEDURE [OW].HolidayInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@HolidayID int = NULL OUTPUT,
	@HolidayDate datetime,
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
	INTO [OW].[tblHoliday]
	(
		[HolidayDate],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@HolidayDate,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @HolidayID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].HolidayInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].HolidayInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].HolidayDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].HolidayDelete;
GO

CREATE PROCEDURE [OW].HolidayDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@HolidayID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblHoliday]
	WHERE
		[HolidayID] = @HolidayID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].HolidayDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].HolidayDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesSelect;
GO

CREATE PROCEDURE [OW].ListOfValuesSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[ListOfValuesID],
		[Description],
		[Type],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblListOfValues]
	WHERE
		(@ListOfValuesID IS NULL OR [ListOfValuesID] = @ListOfValuesID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Type IS NULL OR [Type] = @Type) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesSelectPaging;
GO

CREATE PROCEDURE [OW].ListOfValuesSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL,
	@Description varchar(50) = NULL,
	@Type tinyint = NULL,
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
	
	IF(@ListOfValuesID IS NOT NULL) SET @WHERE = @WHERE + '([ListOfValuesID] = @ListOfValuesID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Type IS NOT NULL) SET @WHERE = @WHERE + '([Type] = @Type) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ListOfValuesID) 
	FROM [OW].[tblListOfValues]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ListOfValuesID int, 
		@Description varchar(50), 
		@Type tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ListOfValuesID, 
		@Description, 
		@Type, 
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
	WHERE ListOfValuesID IN (
		SELECT TOP ' + @SizeString + ' ListOfValuesID
			FROM [OW].[tblListOfValues]
			WHERE ListOfValuesID NOT IN (
				SELECT TOP ' + @PrevString + ' ListOfValuesID 
				FROM [OW].[tblListOfValues]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ListOfValuesID], 
		[Description], 
		[Type], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblListOfValues]
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesUpdate;
GO

CREATE PROCEDURE [OW].ListOfValuesUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesID int,
	@Description varchar(50),
	@Type tinyint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblListOfValues]
	SET
		[Description] = @Description,
		[Type] = @Type,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ListOfValuesID] = @ListOfValuesID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesInsert;
GO

CREATE PROCEDURE [OW].ListOfValuesInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL OUTPUT,
	@Description varchar(50),
	@Type tinyint,
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
	INTO [OW].[tblListOfValues]
	(
		[Description],
		[Type],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Description,
		@Type,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ListOfValuesID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesDelete;
GO

CREATE PROCEDURE [OW].ListOfValuesDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblListOfValues]
	WHERE
		[ListOfValuesID] = @ListOfValuesID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesItemSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesItemSelect;
GO

CREATE PROCEDURE [OW].ListOfValuesItemSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[ListOfValuesItemID],
		[ListOfValuesID],
		[ItemCode],
		[ItemOrder],
		[ItemDescription],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblListOfValuesItem]
	WHERE
		(@ListOfValuesItemID IS NULL OR [ListOfValuesItemID] = @ListOfValuesItemID) AND
		(@ListOfValuesID IS NULL OR [ListOfValuesID] = @ListOfValuesID) AND
		(@ItemCode IS NULL OR [ItemCode] LIKE @ItemCode) AND
		(@ItemOrder IS NULL OR [ItemOrder] = @ItemOrder) AND
		(@ItemDescription IS NULL OR [ItemDescription] LIKE @ItemDescription) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesItemSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesItemSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesItemSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesItemSelectPaging;
GO

CREATE PROCEDURE [OW].ListOfValuesItemSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
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
	
	IF(@ListOfValuesItemID IS NOT NULL) SET @WHERE = @WHERE + '([ListOfValuesItemID] = @ListOfValuesItemID) AND '
	IF(@ListOfValuesID IS NOT NULL) SET @WHERE = @WHERE + '([ListOfValuesID] = @ListOfValuesID) AND '
	IF(@ItemCode IS NOT NULL) SET @WHERE = @WHERE + '([ItemCode] LIKE @ItemCode) AND '
	IF(@ItemOrder IS NOT NULL) SET @WHERE = @WHERE + '([ItemOrder] = @ItemOrder) AND '
	IF(@ItemDescription IS NOT NULL) SET @WHERE = @WHERE + '([ItemDescription] LIKE @ItemDescription) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ListOfValuesItemID) 
	FROM [OW].[tblListOfValuesItem]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ListOfValuesItemID int, 
		@ListOfValuesID int, 
		@ItemCode varchar(70), 
		@ItemOrder int, 
		@ItemDescription varchar(800), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ListOfValuesItemID, 
		@ListOfValuesID, 
		@ItemCode, 
		@ItemOrder, 
		@ItemDescription, 
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
	WHERE ListOfValuesItemID IN (
		SELECT TOP ' + @SizeString + ' ListOfValuesItemID
			FROM [OW].[tblListOfValuesItem]
			WHERE ListOfValuesItemID NOT IN (
				SELECT TOP ' + @PrevString + ' ListOfValuesItemID 
				FROM [OW].[tblListOfValuesItem]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ListOfValuesItemID], 
		[ListOfValuesID], 
		[ItemCode], 
		[ItemOrder], 
		[ItemDescription], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblListOfValuesItem]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesItemSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesItemSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesItemUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesItemUpdate;
GO

CREATE PROCEDURE [OW].ListOfValuesItemUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesItemID int,
	@ListOfValuesID int,
	@ItemCode varchar(70),
	@ItemOrder int,
	@ItemDescription varchar(800),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblListOfValuesItem]
	SET
		[ListOfValuesID] = @ListOfValuesID,
		[ItemCode] = @ItemCode,
		[ItemOrder] = @ItemOrder,
		[ItemDescription] = @ItemDescription,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ListOfValuesItemID] = @ListOfValuesItemID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesItemUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesItemUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesItemInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesItemInsert;
GO

CREATE PROCEDURE [OW].ListOfValuesItemInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesItemID int = NULL OUTPUT,
	@ListOfValuesID int,
	@ItemCode varchar(70),
	@ItemOrder int,
	@ItemDescription varchar(800),
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
	INTO [OW].[tblListOfValuesItem]
	(
		[ListOfValuesID],
		[ItemCode],
		[ItemOrder],
		[ItemDescription],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ListOfValuesID,
		@ItemCode,
		@ItemOrder,
		@ItemDescription,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ListOfValuesItemID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesItemInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesItemInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ListOfValuesItemDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ListOfValuesItemDelete;
GO

CREATE PROCEDURE [OW].ListOfValuesItemDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ListOfValuesItemID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblListOfValuesItem]
	WHERE
		[ListOfValuesItemID] = @ListOfValuesItemID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ListOfValuesItemDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ListOfValuesItemDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ModuleSelect;
GO

CREATE PROCEDURE [OW].ModuleSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[ModuleID],
		[Description],
		[Active],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblModule]
	WHERE
		(@ModuleID IS NULL OR [ModuleID] = @ModuleID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Active IS NULL OR [Active] = @Active) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ModuleSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ModuleSelectPaging;
GO

CREATE PROCEDURE [OW].ModuleSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ModuleID int = NULL,
	@Description varchar(80) = NULL,
	@Active bit = NULL,
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
	
	IF(@ModuleID IS NOT NULL) SET @WHERE = @WHERE + '([ModuleID] = @ModuleID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '([Active] = @Active) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ModuleID) 
	FROM [OW].[tblModule]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ModuleID int, 
		@Description varchar(80), 
		@Active bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE ModuleID IN (
		SELECT TOP ' + @SizeString + ' ModuleID
			FROM [OW].[tblModule]
			WHERE ModuleID NOT IN (
				SELECT TOP ' + @PrevString + ' ModuleID 
				FROM [OW].[tblModule]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ModuleID], 
		[Description], 
		[Active], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblModule]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ModuleSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ModuleUpdate;
GO

CREATE PROCEDURE [OW].ModuleUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ModuleID int,
	@Description varchar(80),
	@Active bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblModule]
	SET
		[Description] = @Description,
		[Active] = @Active,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ModuleID] = @ModuleID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ModuleUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ModuleInsert;
GO

CREATE PROCEDURE [OW].ModuleInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-03-2006 17:33:47
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
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @_InsertedOn datetime
	SET @_InsertedOn = GETDATE()

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
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ModuleInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ModuleDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ModuleDelete;
GO

CREATE PROCEDURE [OW].ModuleDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ModuleID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblModule]
	WHERE
		[ModuleID] = @ModuleID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ModuleDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ModuleDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OrganizationalUnitSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OrganizationalUnitSelect;
GO

CREATE PROCEDURE [OW].OrganizationalUnitSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[OrganizationalUnitID],
		[GroupID],
		[UserID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblOrganizationalUnit]
	WHERE
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@GroupID IS NULL OR [GroupID] = @GroupID) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OrganizationalUnitSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OrganizationalUnitSelectPaging;
GO

CREATE PROCEDURE [OW].OrganizationalUnitSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@OrganizationalUnitID int = NULL,
	@GroupID int = NULL,
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
	
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@GroupID IS NOT NULL) SET @WHERE = @WHERE + '([GroupID] = @GroupID) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '([UserID] = @UserID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(OrganizationalUnitID) 
	FROM [OW].[tblOrganizationalUnit]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@OrganizationalUnitID int, 
		@GroupID int, 
		@UserID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@OrganizationalUnitID, 
		@GroupID, 
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
	WHERE OrganizationalUnitID IN (
		SELECT TOP ' + @SizeString + ' OrganizationalUnitID
			FROM [OW].[tblOrganizationalUnit]
			WHERE OrganizationalUnitID NOT IN (
				SELECT TOP ' + @PrevString + ' OrganizationalUnitID 
				FROM [OW].[tblOrganizationalUnit]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[OrganizationalUnitID], 
		[GroupID], 
		[UserID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblOrganizationalUnit]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OrganizationalUnitUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OrganizationalUnitUpdate;
GO

CREATE PROCEDURE [OW].OrganizationalUnitUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@OrganizationalUnitID int,
	@GroupID int = NULL,
	@UserID int = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblOrganizationalUnit]
	SET
		[GroupID] = @GroupID,
		[UserID] = @UserID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[OrganizationalUnitID] = @OrganizationalUnitID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OrganizationalUnitInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OrganizationalUnitInsert;
GO

CREATE PROCEDURE [OW].OrganizationalUnitInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@OrganizationalUnitID int = NULL OUTPUT,
	@GroupID int = NULL,
	@UserID int = NULL,
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
	INTO [OW].[tblOrganizationalUnit]
	(
		[GroupID],
		[UserID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@GroupID,
		@UserID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @OrganizationalUnitID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].OrganizationalUnitDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].OrganizationalUnitDelete;
GO

CREATE PROCEDURE [OW].OrganizationalUnitDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@OrganizationalUnitID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblOrganizationalUnit]
	WHERE
		[OrganizationalUnitID] = @OrganizationalUnitID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterSelect;
GO

CREATE PROCEDURE [OW].ParameterSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[ParameterID],
		[Description],
		[ParameterType],
		[Required],
		[NumericValue],
		[AlphaNumericValue],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblParameter]
	WHERE
		(@ParameterID IS NULL OR [ParameterID] = @ParameterID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@ParameterType IS NULL OR [ParameterType] = @ParameterType) AND
		(@Required IS NULL OR [Required] = @Required) AND
		(@NumericValue IS NULL OR [NumericValue] = @NumericValue) AND
		(@AlphaNumericValue IS NULL OR [AlphaNumericValue] LIKE @AlphaNumericValue) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterSelectPaging;
GO

CREATE PROCEDURE [OW].ParameterSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
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
	
	IF(@ParameterID IS NOT NULL) SET @WHERE = @WHERE + '([ParameterID] = @ParameterID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@ParameterType IS NOT NULL) SET @WHERE = @WHERE + '([ParameterType] = @ParameterType) AND '
	IF(@Required IS NOT NULL) SET @WHERE = @WHERE + '([Required] = @Required) AND '
	IF(@NumericValue IS NOT NULL) SET @WHERE = @WHERE + '([NumericValue] = @NumericValue) AND '
	IF(@AlphaNumericValue IS NOT NULL) SET @WHERE = @WHERE + '([AlphaNumericValue] LIKE @AlphaNumericValue) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ParameterID) 
	FROM [OW].[tblParameter]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ParameterID IN (
		SELECT TOP ' + @SizeString + ' ParameterID
			FROM [OW].[tblParameter]
			WHERE ParameterID NOT IN (
				SELECT TOP ' + @PrevString + ' ParameterID 
				FROM [OW].[tblParameter]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ParameterID], 
		[Description], 
		[ParameterType], 
		[Required], 
		[NumericValue], 
		[AlphaNumericValue], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterUpdate;
GO

CREATE PROCEDURE [OW].ParameterUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ParameterID int,
	@Description varchar(80),
	@ParameterType tinyint,
	@Required bit,
	@NumericValue numeric(18,3) = NULL,
	@AlphaNumericValue varchar(255) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblParameter]
	SET
		[Description] = @Description,
		[ParameterType] = @ParameterType,
		[Required] = @Required,
		[NumericValue] = @NumericValue,
		[AlphaNumericValue] = @AlphaNumericValue,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ParameterID] = @ParameterID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterInsert;
GO

CREATE PROCEDURE [OW].ParameterInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ParameterID int,
	@Description varchar(80),
	@ParameterType tinyint,
	@Required bit,
	@NumericValue numeric(18,3) = NULL,
	@AlphaNumericValue varchar(255) = NULL,
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
	INTO [OW].[tblParameter]
	(
		[ParameterID],
		[Description],
		[ParameterType],
		[Required],
		[NumericValue],
		[AlphaNumericValue],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ParameterID,
		@Description,
		@ParameterType,
		@Required,
		@NumericValue,
		@AlphaNumericValue,
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ParameterDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ParameterDelete;
GO

CREATE PROCEDURE [OW].ParameterDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ParameterID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblParameter]
	WHERE
		[ParameterID] = @ParameterID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ParameterDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ParameterDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].PostalCodeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].PostalCodeSelect;
GO

CREATE PROCEDURE [OW].PostalCodeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.2	
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

	SELECT
		[PostalCodeID],
		[Code],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblPostalCode]
	WHERE
		(@PostalCodeID IS NULL OR [PostalCodeID] = @PostalCodeID) AND
		(@Code IS NULL OR [Code] LIKE @Code) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].PostalCodeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].PostalCodeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].PostalCodeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].PostalCodeSelectPaging;
GO

CREATE PROCEDURE [OW].PostalCodeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:17
	--Version: 1.1	
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
	
	IF(@PostalCodeID IS NOT NULL) SET @WHERE = @WHERE + '([PostalCodeID] = @PostalCodeID) AND '
	IF(@Code IS NOT NULL) SET @WHERE = @WHERE + '([Code] LIKE @Code) AND '
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
	SELECT @RowCount = COUNT(PostalCodeID) 
	FROM [OW].[tblPostalCode]
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
		SELECT TOP ' + @SizeString + ' PostalCodeID
			FROM [OW].[tblPostalCode]
			WHERE PostalCodeID NOT IN (
				SELECT TOP ' + @PrevString + ' PostalCodeID 
				FROM [OW].[tblPostalCode]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[PostalCodeID], 
		[Code], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblPostalCode]
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

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].PostalCodeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].PostalCodeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].PostalCodeUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].PostalCodeUpdate;
GO

CREATE PROCEDURE [OW].PostalCodeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@PostalCodeID int,
	@Code varchar(10),
	@Description varchar(100),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblPostalCode]
	SET
		[Code] = @Code,
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[PostalCodeID] = @PostalCodeID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].PostalCodeUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].PostalCodeUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].PostalCodeInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].PostalCodeInsert;
GO

CREATE PROCEDURE [OW].PostalCodeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@PostalCodeID int = NULL OUTPUT,
	@Code varchar(10),
	@Description varchar(100),
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
	INTO [OW].[tblPostalCode]
	(
		[Code],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Code,
		@Description,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @PostalCodeID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].PostalCodeInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].PostalCodeInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].PostalCodeDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].PostalCodeDelete;
GO

CREATE PROCEDURE [OW].PostalCodeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@PostalCodeID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblPostalCode]
	WHERE
		[PostalCodeID] = @PostalCodeID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].PostalCodeDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].PostalCodeDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessSelect;
GO

CREATE PROCEDURE [OW].ProcessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
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

	SELECT
		[ProcessID],
		[FlowID],
		[ProcessNumber],
		[Year],
		[ProcessSubject],
		[PriorityID],
		[ProcessOwnerID],
		[StartDate],
		[EndDate],
		[EstimatedDateToComplete],
		[ProcessStatus],
		[Duration],
		[WorkCalendar],
		[NotifyRetrocession],
		[WorkflowRule],
		[OriginatorID],
		[Adhoc],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcess]
	WHERE
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@ProcessNumber IS NULL OR [ProcessNumber] LIKE @ProcessNumber) AND
		(@Year IS NULL OR [Year] = @Year) AND
		(@ProcessSubject IS NULL OR [ProcessSubject] LIKE @ProcessSubject) AND
		(@PriorityID IS NULL OR [PriorityID] = @PriorityID) AND
		(@ProcessOwnerID IS NULL OR [ProcessOwnerID] = @ProcessOwnerID) AND
		(@StartDate IS NULL OR [StartDate] = @StartDate) AND
		(@EndDate IS NULL OR [EndDate] = @EndDate) AND
		(@EstimatedDateToComplete IS NULL OR [EstimatedDateToComplete] = @EstimatedDateToComplete) AND
		(@ProcessStatus IS NULL OR [ProcessStatus] = @ProcessStatus) AND
		(@Duration IS NULL OR [Duration] = @Duration) AND
		(@WorkCalendar IS NULL OR [WorkCalendar] = @WorkCalendar) AND
		(@NotifyRetrocession IS NULL OR [NotifyRetrocession] = @NotifyRetrocession) AND
		(@WorkflowRule IS NULL OR [WorkflowRule] LIKE @WorkflowRule) AND
		(@OriginatorID IS NULL OR [OriginatorID] = @OriginatorID) AND
		(@Adhoc IS NULL OR [Adhoc] = @Adhoc) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
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
	
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@ProcessNumber IS NOT NULL) SET @WHERE = @WHERE + '([ProcessNumber] LIKE @ProcessNumber) AND '
	IF(@Year IS NOT NULL) SET @WHERE = @WHERE + '([Year] = @Year) AND '
	IF(@ProcessSubject IS NOT NULL) SET @WHERE = @WHERE + '([ProcessSubject] LIKE @ProcessSubject) AND '
	IF(@PriorityID IS NOT NULL) SET @WHERE = @WHERE + '([PriorityID] = @PriorityID) AND '
	IF(@ProcessOwnerID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessOwnerID] = @ProcessOwnerID) AND '
	IF(@StartDate IS NOT NULL) SET @WHERE = @WHERE + '([StartDate] = @StartDate) AND '
	IF(@EndDate IS NOT NULL) SET @WHERE = @WHERE + '([EndDate] = @EndDate) AND '
	IF(@EstimatedDateToComplete IS NOT NULL) SET @WHERE = @WHERE + '([EstimatedDateToComplete] = @EstimatedDateToComplete) AND '
	IF(@ProcessStatus IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStatus] = @ProcessStatus) AND '
	IF(@Duration IS NOT NULL) SET @WHERE = @WHERE + '([Duration] = @Duration) AND '
	IF(@WorkCalendar IS NOT NULL) SET @WHERE = @WHERE + '([WorkCalendar] = @WorkCalendar) AND '
	IF(@NotifyRetrocession IS NOT NULL) SET @WHERE = @WHERE + '([NotifyRetrocession] = @NotifyRetrocession) AND '
	IF(@WorkflowRule IS NOT NULL) SET @WHERE = @WHERE + '([WorkflowRule] LIKE @WorkflowRule) AND '
	IF(@OriginatorID IS NOT NULL) SET @WHERE = @WHERE + '([OriginatorID] = @OriginatorID) AND '
	IF(@Adhoc IS NOT NULL) SET @WHERE = @WHERE + '([Adhoc] = @Adhoc) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessID) 
	FROM [OW].[tblProcess]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ProcessID IN (
		SELECT TOP ' + @SizeString + ' ProcessID
			FROM [OW].[tblProcess]
			WHERE ProcessID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessID 
				FROM [OW].[tblProcess]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessID], 
		[FlowID], 
		[ProcessNumber], 
		[Year], 
		[ProcessSubject], 
		[PriorityID], 
		[ProcessOwnerID], 
		[StartDate], 
		[EndDate], 
		[EstimatedDateToComplete], 
		[ProcessStatus], 
		[Duration], 
		[WorkCalendar], 
		[NotifyRetrocession], 
		[WorkflowRule], 
		[OriginatorID], 
		[Adhoc], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcess]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessUpdate;
GO

CREATE PROCEDURE [OW].ProcessUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessID int,
	@FlowID int,
	@ProcessNumber varchar(50),
	@Year int,
	@ProcessSubject varchar(255),
	@PriorityID int,
	@ProcessOwnerID int,
	@StartDate datetime,
	@EndDate datetime = NULL,
	@EstimatedDateToComplete datetime,
	@ProcessStatus int,
	@Duration int,
	@WorkCalendar bit,
	@NotifyRetrocession bit,
	@WorkflowRule text,
	@OriginatorID int,
	@Adhoc bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcess]
	SET
		[FlowID] = @FlowID,
		[ProcessNumber] = @ProcessNumber,
		[Year] = @Year,
		[ProcessSubject] = @ProcessSubject,
		[PriorityID] = @PriorityID,
		[ProcessOwnerID] = @ProcessOwnerID,
		[StartDate] = @StartDate,
		[EndDate] = @EndDate,
		[EstimatedDateToComplete] = @EstimatedDateToComplete,
		[ProcessStatus] = @ProcessStatus,
		[Duration] = @Duration,
		[WorkCalendar] = @WorkCalendar,
		[NotifyRetrocession] = @NotifyRetrocession,
		[WorkflowRule] = @WorkflowRule,
		[OriginatorID] = @OriginatorID,
		[Adhoc] = @Adhoc,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessID] = @ProcessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessInsert;
GO

CREATE PROCEDURE [OW].ProcessInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessID int = NULL OUTPUT,
	@FlowID int,
	@ProcessNumber varchar(50),
	@Year int,
	@ProcessSubject varchar(255),
	@PriorityID int,
	@ProcessOwnerID int,
	@StartDate datetime,
	@EndDate datetime = NULL,
	@EstimatedDateToComplete datetime,
	@ProcessStatus int,
	@Duration int,
	@WorkCalendar bit,
	@NotifyRetrocession bit,
	@WorkflowRule text,
	@OriginatorID int,
	@Adhoc bit,
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
	INTO [OW].[tblProcess]
	(
		[FlowID],
		[ProcessNumber],
		[Year],
		[ProcessSubject],
		[PriorityID],
		[ProcessOwnerID],
		[StartDate],
		[EndDate],
		[EstimatedDateToComplete],
		[ProcessStatus],
		[Duration],
		[WorkCalendar],
		[NotifyRetrocession],
		[WorkflowRule],
		[OriginatorID],
		[Adhoc],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDelete;
GO

CREATE PROCEDURE [OW].ProcessDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcess]
	WHERE
		[ProcessID] = @ProcessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessSelect;
GO

CREATE PROCEDURE [OW].ProcessAccessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
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

	SELECT
		[ProcessAccessID],
		[FlowID],
		[ProcessID],
		[OrganizationalUnitID],
		[AccessObject],
		[StartProcess],
		[ProcessDataAccess],
		[DynamicFieldAccess],
		[DocumentAccess],
		[DispatchAccess],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessAccess]
	WHERE
		(@ProcessAccessID IS NULL OR [ProcessAccessID] = @ProcessAccessID) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@AccessObject IS NULL OR [AccessObject] = @AccessObject) AND
		(@StartProcess IS NULL OR [StartProcess] = @StartProcess) AND
		(@ProcessDataAccess IS NULL OR [ProcessDataAccess] = @ProcessDataAccess) AND
		(@DynamicFieldAccess IS NULL OR [DynamicFieldAccess] = @DynamicFieldAccess) AND
		(@DocumentAccess IS NULL OR [DocumentAccess] = @DocumentAccess) AND
		(@DispatchAccess IS NULL OR [DispatchAccess] = @DispatchAccess) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessAccessSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
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
	@DispatchAccess tinyint = NULL,
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
	
	IF(@ProcessAccessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessAccessID] = @ProcessAccessID) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@AccessObject IS NOT NULL) SET @WHERE = @WHERE + '([AccessObject] = @AccessObject) AND '
	IF(@StartProcess IS NOT NULL) SET @WHERE = @WHERE + '([StartProcess] = @StartProcess) AND '
	IF(@ProcessDataAccess IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDataAccess] = @ProcessDataAccess) AND '
	IF(@DynamicFieldAccess IS NOT NULL) SET @WHERE = @WHERE + '([DynamicFieldAccess] = @DynamicFieldAccess) AND '
	IF(@DocumentAccess IS NOT NULL) SET @WHERE = @WHERE + '([DocumentAccess] = @DocumentAccess) AND '
	IF(@DispatchAccess IS NOT NULL) SET @WHERE = @WHERE + '([DispatchAccess] = @DispatchAccess) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessAccessID) 
	FROM [OW].[tblProcessAccess]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessAccessID int, 
		@FlowID int, 
		@ProcessID int, 
		@OrganizationalUnitID int, 
		@AccessObject tinyint, 
		@StartProcess tinyint, 
		@ProcessDataAccess tinyint, 
		@DynamicFieldAccess tinyint, 
		@DocumentAccess tinyint, 
		@DispatchAccess tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessAccessID, 
		@FlowID, 
		@ProcessID, 
		@OrganizationalUnitID, 
		@AccessObject, 
		@StartProcess, 
		@ProcessDataAccess, 
		@DynamicFieldAccess, 
		@DocumentAccess, 
		@DispatchAccess, 
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
	WHERE ProcessAccessID IN (
		SELECT TOP ' + @SizeString + ' ProcessAccessID
			FROM [OW].[tblProcessAccess]
			WHERE ProcessAccessID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessAccessID 
				FROM [OW].[tblProcessAccess]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessAccessID], 
		[FlowID], 
		[ProcessID], 
		[OrganizationalUnitID], 
		[AccessObject], 
		[StartProcess], 
		[ProcessDataAccess], 
		[DynamicFieldAccess], 
		[DocumentAccess], 
		[DispatchAccess], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessAccess]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ProcessAccessID int, 
		@FlowID int, 
		@ProcessID int, 
		@OrganizationalUnitID int, 
		@AccessObject tinyint, 
		@StartProcess tinyint, 
		@ProcessDataAccess tinyint, 
		@DynamicFieldAccess tinyint, 
		@DocumentAccess tinyint, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessUpdate;
GO

CREATE PROCEDURE [OW].ProcessAccessUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAccessID int,
	@FlowID int = NULL,
	@ProcessID int = NULL,
	@OrganizationalUnitID int = NULL,
	@AccessObject tinyint,
	@StartProcess tinyint,
	@ProcessDataAccess tinyint,
	@DynamicFieldAccess tinyint,
	@DocumentAccess tinyint,
	@DispatchAccess tinyint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessAccess]
	SET
		[FlowID] = @FlowID,
		[ProcessID] = @ProcessID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[AccessObject] = @AccessObject,
		[StartProcess] = @StartProcess,
		[ProcessDataAccess] = @ProcessDataAccess,
		[DynamicFieldAccess] = @DynamicFieldAccess,
		[DocumentAccess] = @DocumentAccess,
		[DispatchAccess] = @DispatchAccess,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessAccessID] = @ProcessAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessInsert;
GO

CREATE PROCEDURE [OW].ProcessAccessInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAccessID int = NULL OUTPUT,
	@FlowID int = NULL,
	@ProcessID int = NULL,
	@OrganizationalUnitID int = NULL,
	@AccessObject tinyint,
	@StartProcess tinyint,
	@ProcessDataAccess tinyint,
	@DynamicFieldAccess tinyint,
	@DocumentAccess tinyint,
	@DispatchAccess tinyint,
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
	INTO [OW].[tblProcessAccess]
	(
		[FlowID],
		[ProcessID],
		[OrganizationalUnitID],
		[AccessObject],
		[StartProcess],
		[ProcessDataAccess],
		[DynamicFieldAccess],
		[DocumentAccess],
		[DispatchAccess],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@FlowID,
		@ProcessID,
		@OrganizationalUnitID,
		@AccessObject,
		@StartProcess,
		@ProcessDataAccess,
		@DynamicFieldAccess,
		@DocumentAccess,
		@DispatchAccess,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessAccessID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessDelete;
GO

CREATE PROCEDURE [OW].ProcessAccessDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAccessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessAccess]
	WHERE
		[ProcessAccessID] = @ProcessAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAccessDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAccessDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmSelect;
GO

CREATE PROCEDURE [OW].ProcessAlarmSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL,
	@FlowID int = NULL,
	@FlowStageID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@Occurence tinyint = NULL,
	@OccurenceOffset int = NULL,
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

	SELECT
		[ProcessAlarmID],
		[FlowID],
		[FlowStageID],
		[ProcessID],
		[ProcessStageID],
		[Occurence],
		[OccurenceOffset],
		[Message],
		[AlertByEMail],
		[AddresseeExecutant],
		[AddresseeFlowOwner],
		[AddresseeProcessOwner],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessAlarm]
	WHERE
		(@ProcessAlarmID IS NULL OR [ProcessAlarmID] = @ProcessAlarmID) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@FlowStageID IS NULL OR [FlowStageID] = @FlowStageID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@Occurence IS NULL OR [Occurence] = @Occurence) AND
		(@OccurenceOffset IS NULL OR [OccurenceOffset] = @OccurenceOffset) AND
		(@Message IS NULL OR [Message] LIKE @Message) AND
		(@AlertByEMail IS NULL OR [AlertByEMail] = @AlertByEMail) AND
		(@AddresseeExecutant IS NULL OR [AddresseeExecutant] = @AddresseeExecutant) AND
		(@AddresseeFlowOwner IS NULL OR [AddresseeFlowOwner] = @AddresseeFlowOwner) AND
		(@AddresseeProcessOwner IS NULL OR [AddresseeProcessOwner] = @AddresseeProcessOwner) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessAlarmSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL,
	@FlowID int = NULL,
	@FlowStageID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@Occurence tinyint = NULL,
	@OccurenceOffset int = NULL,
	@Message varchar(255) = NULL,
	@AlertByEMail bit = NULL,
	@AddresseeExecutant bit = NULL,
	@AddresseeFlowOwner bit = NULL,
	@AddresseeProcessOwner bit = NULL,
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
	
	IF(@ProcessAlarmID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessAlarmID] = @ProcessAlarmID) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@FlowStageID IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageID] = @FlowStageID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@Occurence IS NOT NULL) SET @WHERE = @WHERE + '([Occurence] = @Occurence) AND '
	IF(@OccurenceOffset IS NOT NULL) SET @WHERE = @WHERE + '([OccurenceOffset] = @OccurenceOffset) AND '
	IF(@Message IS NOT NULL) SET @WHERE = @WHERE + '([Message] LIKE @Message) AND '
	IF(@AlertByEMail IS NOT NULL) SET @WHERE = @WHERE + '([AlertByEMail] = @AlertByEMail) AND '
	IF(@AddresseeExecutant IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeExecutant] = @AddresseeExecutant) AND '
	IF(@AddresseeFlowOwner IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeFlowOwner] = @AddresseeFlowOwner) AND '
	IF(@AddresseeProcessOwner IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeProcessOwner] = @AddresseeProcessOwner) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessAlarmID) 
	FROM [OW].[tblProcessAlarm]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessAlarmID int, 
		@FlowID int, 
		@FlowStageID int, 
		@ProcessID int, 
		@ProcessStageID int, 
		@Occurence tinyint, 
		@OccurenceOffset int, 
		@Message varchar(255), 
		@AlertByEMail bit, 
		@AddresseeExecutant bit, 
		@AddresseeFlowOwner bit, 
		@AddresseeProcessOwner bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessAlarmID, 
		@FlowID, 
		@FlowStageID, 
		@ProcessID, 
		@ProcessStageID, 
		@Occurence, 
		@OccurenceOffset, 
		@Message, 
		@AlertByEMail, 
		@AddresseeExecutant, 
		@AddresseeFlowOwner, 
		@AddresseeProcessOwner, 
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
	WHERE ProcessAlarmID IN (
		SELECT TOP ' + @SizeString + ' ProcessAlarmID
			FROM [OW].[tblProcessAlarm]
			WHERE ProcessAlarmID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessAlarmID 
				FROM [OW].[tblProcessAlarm]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessAlarmID], 
		[FlowID], 
		[FlowStageID], 
		[ProcessID], 
		[ProcessStageID], 
		[Occurence], 
		[OccurenceOffset], 
		[Message], 
		[AlertByEMail], 
		[AddresseeExecutant], 
		[AddresseeFlowOwner], 
		[AddresseeProcessOwner], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessAlarm]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ProcessAlarmID int, 
		@FlowID int, 
		@FlowStageID int, 
		@ProcessID int, 
		@ProcessStageID int, 
		@Occurence tinyint, 
		@OccurenceOffset int, 
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
		@FlowID, 
		@FlowStageID, 
		@ProcessID, 
		@ProcessStageID, 
		@Occurence, 
		@OccurenceOffset, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmUpdate;
GO

CREATE PROCEDURE [OW].ProcessAlarmUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int,
	@FlowID int = NULL,
	@FlowStageID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@Occurence tinyint,
	@OccurenceOffset int,
	@Message varchar(255),
	@AlertByEMail bit,
	@AddresseeExecutant bit,
	@AddresseeFlowOwner bit,
	@AddresseeProcessOwner bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessAlarm]
	SET
		[FlowID] = @FlowID,
		[FlowStageID] = @FlowStageID,
		[ProcessID] = @ProcessID,
		[ProcessStageID] = @ProcessStageID,
		[Occurence] = @Occurence,
		[OccurenceOffset] = @OccurenceOffset,
		[Message] = @Message,
		[AlertByEMail] = @AlertByEMail,
		[AddresseeExecutant] = @AddresseeExecutant,
		[AddresseeFlowOwner] = @AddresseeFlowOwner,
		[AddresseeProcessOwner] = @AddresseeProcessOwner,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessAlarmID] = @ProcessAlarmID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmInsert;
GO

CREATE PROCEDURE [OW].ProcessAlarmInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL OUTPUT,
	@FlowID int = NULL,
	@FlowStageID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@Occurence tinyint,
	@OccurenceOffset int,
	@Message varchar(255),
	@AlertByEMail bit,
	@AddresseeExecutant bit,
	@AddresseeFlowOwner bit,
	@AddresseeProcessOwner bit,
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
	INTO [OW].[tblProcessAlarm]
	(
		[FlowID],
		[FlowStageID],
		[ProcessID],
		[ProcessStageID],
		[Occurence],
		[OccurenceOffset],
		[Message],
		[AlertByEMail],
		[AddresseeExecutant],
		[AddresseeFlowOwner],
		[AddresseeProcessOwner],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@FlowID,
		@FlowStageID,
		@ProcessID,
		@ProcessStageID,
		@Occurence,
		@OccurenceOffset,
		@Message,
		@AlertByEMail,
		@AddresseeExecutant,
		@AddresseeFlowOwner,
		@AddresseeProcessOwner,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessAlarmID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmDelete;
GO

CREATE PROCEDURE [OW].ProcessAlarmDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE
		[ProcessAlarmID] = @ProcessAlarmID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmAddresseeSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmAddresseeSelect;
GO

CREATE PROCEDURE [OW].ProcessAlarmAddresseeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
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

	SELECT
		[ProcessAlarmAddresseeID],
		[ProcessAlarmID],
		[OrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessAlarmAddressee]
	WHERE
		(@ProcessAlarmAddresseeID IS NULL OR [ProcessAlarmAddresseeID] = @ProcessAlarmAddresseeID) AND
		(@ProcessAlarmID IS NULL OR [ProcessAlarmID] = @ProcessAlarmID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmAddresseeSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmAddresseeSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessAlarmAddresseeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmAddresseeID int = NULL,
	@ProcessAlarmID int = NULL,
	@OrganizationalUnitID int = NULL,
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
	
	IF(@ProcessAlarmAddresseeID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessAlarmAddresseeID] = @ProcessAlarmAddresseeID) AND '
	IF(@ProcessAlarmID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessAlarmID] = @ProcessAlarmID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessAlarmAddresseeID) 
	FROM [OW].[tblProcessAlarmAddressee]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessAlarmAddresseeID int, 
		@ProcessAlarmID int, 
		@OrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessAlarmAddresseeID, 
		@ProcessAlarmID, 
		@OrganizationalUnitID, 
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
	WHERE ProcessAlarmAddresseeID IN (
		SELECT TOP ' + @SizeString + ' ProcessAlarmAddresseeID
			FROM [OW].[tblProcessAlarmAddressee]
			WHERE ProcessAlarmAddresseeID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessAlarmAddresseeID 
				FROM [OW].[tblProcessAlarmAddressee]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessAlarmAddresseeID], 
		[ProcessAlarmID], 
		[OrganizationalUnitID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessAlarmAddressee]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmAddresseeUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmAddresseeUpdate;
GO

CREATE PROCEDURE [OW].ProcessAlarmAddresseeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmAddresseeID int,
	@ProcessAlarmID int,
	@OrganizationalUnitID int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessAlarmAddressee]
	SET
		[ProcessAlarmID] = @ProcessAlarmID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessAlarmAddresseeID] = @ProcessAlarmAddresseeID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmAddresseeInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmAddresseeInsert;
GO

CREATE PROCEDURE [OW].ProcessAlarmAddresseeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmAddresseeID int = NULL OUTPUT,
	@ProcessAlarmID int,
	@OrganizationalUnitID int,
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
	INTO [OW].[tblProcessAlarmAddressee]
	(
		[ProcessAlarmID],
		[OrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessAlarmID,
		@OrganizationalUnitID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessAlarmAddresseeID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAlarmAddresseeDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAlarmAddresseeDelete;
GO

CREATE PROCEDURE [OW].ProcessAlarmAddresseeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmAddresseeID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessAlarmAddressee]
	WHERE
		[ProcessAlarmAddresseeID] = @ProcessAlarmAddresseeID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessAlarmAddresseeDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessCounterSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessCounterSelect;
GO

CREATE PROCEDURE [OW].ProcessCounterSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
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

	SELECT
		[ProcessCounterID],
		[Year],
		[Acronym],
		[NextValue],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessCounter]
	WHERE
		(@ProcessCounterID IS NULL OR [ProcessCounterID] = @ProcessCounterID) AND
		(@Year IS NULL OR [Year] = @Year) AND
		(@Acronym IS NULL OR [Acronym] LIKE @Acronym) AND
		(@NextValue IS NULL OR [NextValue] = @NextValue) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessCounterSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessCounterSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessCounterSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessCounterSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessCounterSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessCounterID int = NULL,
	@Year int = NULL,
	@Acronym varchar(50) = NULL,
	@NextValue int = NULL,
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
	
	IF(@ProcessCounterID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessCounterID] = @ProcessCounterID) AND '
	IF(@Year IS NOT NULL) SET @WHERE = @WHERE + '([Year] = @Year) AND '
	IF(@Acronym IS NOT NULL) SET @WHERE = @WHERE + '([Acronym] LIKE @Acronym) AND '
	IF(@NextValue IS NOT NULL) SET @WHERE = @WHERE + '([NextValue] = @NextValue) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessCounterID) 
	FROM [OW].[tblProcessCounter]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessCounterID int, 
		@Year int, 
		@Acronym varchar(50), 
		@NextValue int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessCounterID, 
		@Year, 
		@Acronym, 
		@NextValue, 
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
	WHERE ProcessCounterID IN (
		SELECT TOP ' + @SizeString + ' ProcessCounterID
			FROM [OW].[tblProcessCounter]
			WHERE ProcessCounterID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessCounterID 
				FROM [OW].[tblProcessCounter]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessCounterID], 
		[Year], 
		[Acronym], 
		[NextValue], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessCounter]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessCounterSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessCounterSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessCounterUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessCounterUpdate;
GO

CREATE PROCEDURE [OW].ProcessCounterUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessCounterID int,
	@Year int = NULL,
	@Acronym varchar(50) = NULL,
	@NextValue int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessCounter]
	SET
		[Year] = @Year,
		[Acronym] = @Acronym,
		[NextValue] = @NextValue,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessCounterID] = @ProcessCounterID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessCounterUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessCounterUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessCounterInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessCounterInsert;
GO

CREATE PROCEDURE [OW].ProcessCounterInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessCounterID int = NULL OUTPUT,
	@Year int = NULL,
	@Acronym varchar(50) = NULL,
	@NextValue int,
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
	INTO [OW].[tblProcessCounter]
	(
		[Year],
		[Acronym],
		[NextValue],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Year,
		@Acronym,
		@NextValue,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessCounterID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessCounterInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessCounterInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessCounterDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessCounterDelete;
GO

CREATE PROCEDURE [OW].ProcessCounterDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessCounterID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessCounter]
	WHERE
		[ProcessCounterID] = @ProcessCounterID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessCounterDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessCounterDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelect;
GO

CREATE PROCEDURE [OW].ProcessDocumentSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
	------------------------------------------------------------------------
	@ProcessDocumentID int = NULL,
	@ProcessEventID int = NULL,
	@DocumentID numeric(18,0) = NULL,
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
		[ProcessDocumentID],
		[ProcessEventID],
		[DocumentID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessDocument]
	WHERE
		(@ProcessDocumentID IS NULL OR [ProcessDocumentID] = @ProcessDocumentID) AND
		(@ProcessEventID IS NULL OR [ProcessEventID] = @ProcessEventID) AND
		(@DocumentID IS NULL OR [DocumentID] = @DocumentID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessDocumentSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int = NULL,
	@ProcessEventID int = NULL,
	@DocumentID numeric(18,0) = NULL,
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
	
	IF(@ProcessDocumentID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDocumentID] = @ProcessDocumentID) AND '
	IF(@ProcessEventID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessEventID] = @ProcessEventID) AND '
	IF(@DocumentID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentID] = @DocumentID) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessDocumentID) 
	FROM [OW].[tblProcessDocument]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessDocumentID int, 
		@ProcessEventID int, 
		@DocumentID numeric(18,0), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessDocumentID, 
		@ProcessEventID, 
		@DocumentID, 
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
	WHERE ProcessDocumentID IN (
		SELECT TOP ' + @SizeString + ' ProcessDocumentID
			FROM [OW].[tblProcessDocument]
			WHERE ProcessDocumentID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessDocumentID 
				FROM [OW].[tblProcessDocument]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessDocumentID], 
		[ProcessEventID], 
		[DocumentID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessDocument]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ProcessDocumentID int, 
		@ProcessEventID int, 
		@DocumentID numeric(18,0), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessDocumentID, 
		@ProcessEventID, 
		@DocumentID, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentUpdate;
GO

CREATE PROCEDURE [OW].ProcessDocumentUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int,
	@ProcessEventID int,
	@DocumentID numeric(18,0),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessDocument]
	SET
		[ProcessEventID] = @ProcessEventID,
		[DocumentID] = @DocumentID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessDocumentID] = @ProcessDocumentID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentInsert;
GO

CREATE PROCEDURE [OW].ProcessDocumentInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int = NULL OUTPUT,
	@ProcessEventID int,
	@DocumentID numeric(18,0),
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
	INTO [OW].[tblProcessDocument]
	(
		[ProcessEventID],
		[DocumentID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessEventID,
		@DocumentID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessDocumentID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentDelete;
GO

CREATE PROCEDURE [OW].ProcessDocumentDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessDocument]
	WHERE
		[ProcessDocumentID] = @ProcessDocumentID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentAccessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentAccessSelect;
GO

CREATE PROCEDURE [OW].ProcessDocumentAccessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
	------------------------------------------------------------------------
	@ProcessDocumentAccessID int = NULL,
	@OrganizationalUnitID int = NULL,
	@ProcessDocumentID int = NULL,
	@AccessObject tinyint = NULL,
	@DocumentAccess tinyint = NULL,
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
		[ProcessDocumentAccessID],
		[OrganizationalUnitID],
		[ProcessDocumentID],
		[AccessObject],
		[DocumentAccess],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessDocumentAccess]
	WHERE
		(@ProcessDocumentAccessID IS NULL OR [ProcessDocumentAccessID] = @ProcessDocumentAccessID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@ProcessDocumentID IS NULL OR [ProcessDocumentID] = @ProcessDocumentID) AND
		(@AccessObject IS NULL OR [AccessObject] = @AccessObject) AND
		(@DocumentAccess IS NULL OR [DocumentAccess] = @DocumentAccess) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentAccessSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentAccessSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentAccessSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentAccessSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessDocumentAccessSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentAccessID int = NULL,
	@OrganizationalUnitID int = NULL,
	@ProcessDocumentID int = NULL,
	@AccessObject tinyint = NULL,
	@DocumentAccess tinyint = NULL,
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
	
	IF(@ProcessDocumentAccessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDocumentAccessID] = @ProcessDocumentAccessID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@ProcessDocumentID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDocumentID] = @ProcessDocumentID) AND '
	IF(@AccessObject IS NOT NULL) SET @WHERE = @WHERE + '([AccessObject] = @AccessObject) AND '
	IF(@DocumentAccess IS NOT NULL) SET @WHERE = @WHERE + '([DocumentAccess] = @DocumentAccess) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessDocumentAccessID) 
	FROM [OW].[tblProcessDocumentAccess]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessDocumentAccessID int, 
		@OrganizationalUnitID int, 
		@ProcessDocumentID int, 
		@AccessObject tinyint, 
		@DocumentAccess tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessDocumentAccessID, 
		@OrganizationalUnitID, 
		@ProcessDocumentID, 
		@AccessObject, 
		@DocumentAccess, 
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
	WHERE ProcessDocumentAccessID IN (
		SELECT TOP ' + @SizeString + ' ProcessDocumentAccessID
			FROM [OW].[tblProcessDocumentAccess]
			WHERE ProcessDocumentAccessID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessDocumentAccessID 
				FROM [OW].[tblProcessDocumentAccess]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessDocumentAccessID], 
		[OrganizationalUnitID], 
		[ProcessDocumentID], 
		[AccessObject], 
		[DocumentAccess], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessDocumentAccess]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@ProcessDocumentAccessID int, 
		@OrganizationalUnitID int, 
		@ProcessDocumentID int, 
		@AccessObject tinyint, 
		@DocumentAccess tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@ProcessDocumentAccessID, 
		@OrganizationalUnitID, 
		@ProcessDocumentID, 
		@AccessObject, 
		@DocumentAccess, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentAccessSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentAccessSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentAccessUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentAccessUpdate;
GO

CREATE PROCEDURE [OW].ProcessDocumentAccessUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentAccessID int,
	@OrganizationalUnitID int = NULL,
	@ProcessDocumentID int = NULL,
	@AccessObject tinyint,
	@DocumentAccess tinyint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessDocumentAccess]
	SET
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[ProcessDocumentID] = @ProcessDocumentID,
		[AccessObject] = @AccessObject,
		[DocumentAccess] = @DocumentAccess,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessDocumentAccessID] = @ProcessDocumentAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentAccessUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentAccessUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentAccessInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentAccessInsert;
GO

CREATE PROCEDURE [OW].ProcessDocumentAccessInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentAccessID int = NULL OUTPUT,
	@OrganizationalUnitID int = NULL,
	@ProcessDocumentID int = NULL,
	@AccessObject tinyint,
	@DocumentAccess tinyint,
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
	INTO [OW].[tblProcessDocumentAccess]
	(
		[OrganizationalUnitID],
		[ProcessDocumentID],
		[AccessObject],
		[DocumentAccess],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@OrganizationalUnitID,
		@ProcessDocumentID,
		@AccessObject,
		@DocumentAccess,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessDocumentAccessID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentAccessInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentAccessInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentAccessDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentAccessDelete;
GO

CREATE PROCEDURE [OW].ProcessDocumentAccessDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentAccessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessDocumentAccess]
	WHERE
		[ProcessDocumentAccessID] = @ProcessDocumentAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentAccessDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentAccessDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldSelect;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.2	
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

	SELECT
		[ProcessDynamicFieldID],
		[DynamicFieldID],
		[FlowID],
		[ProcessID],
		[FieldOrder],
		[MultiSelection],
		[Required],
		[Lookup],
		[Address],
		[Method],
		[Field],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessDynamicField]
	WHERE
		(@ProcessDynamicFieldID IS NULL OR [ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND
		(@DynamicFieldID IS NULL OR [DynamicFieldID] = @DynamicFieldID) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@FieldOrder IS NULL OR [FieldOrder] = @FieldOrder) AND
		(@MultiSelection IS NULL OR [MultiSelection] = @MultiSelection) AND
		(@Required IS NULL OR [Required] = @Required) AND
		(@Lookup IS NULL OR [Lookup] = @Lookup) AND
		(@Address IS NULL OR [Address] LIKE @Address) AND
		(@Method IS NULL OR [Method] LIKE @Method) AND
		(@Field IS NULL OR [Field] LIKE @Field) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
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
	
	IF(@ProcessDynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND '
	IF(@DynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([DynamicFieldID] = @DynamicFieldID) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@FieldOrder IS NOT NULL) SET @WHERE = @WHERE + '([FieldOrder] = @FieldOrder) AND '
	IF(@MultiSelection IS NOT NULL) SET @WHERE = @WHERE + '([MultiSelection] = @MultiSelection) AND '
	IF(@Required IS NOT NULL) SET @WHERE = @WHERE + '([Required] = @Required) AND '
	IF(@Lookup IS NOT NULL) SET @WHERE = @WHERE + '([Lookup] = @Lookup) AND '
	IF(@Address IS NOT NULL) SET @WHERE = @WHERE + '([Address] LIKE @Address) AND '
	IF(@Method IS NOT NULL) SET @WHERE = @WHERE + '([Method] LIKE @Method) AND '
	IF(@Field IS NOT NULL) SET @WHERE = @WHERE + '([Field] LIKE @Field) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessDynamicFieldID) 
	FROM [OW].[tblProcessDynamicField]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ProcessDynamicFieldID IN (
		SELECT TOP ' + @SizeString + ' ProcessDynamicFieldID
			FROM [OW].[tblProcessDynamicField]
			WHERE ProcessDynamicFieldID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessDynamicFieldID 
				FROM [OW].[tblProcessDynamicField]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessDynamicFieldID], 
		[DynamicFieldID], 
		[FlowID], 
		[ProcessID], 
		[FieldOrder], 
		[MultiSelection], 
		[Required], 
		[Lookup], 
		[Address], 
		[Method], 
		[Field], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessDynamicField]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldUpdate;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDynamicFieldID int,
	@DynamicFieldID int,
	@FlowID int = NULL,
	@ProcessID int = NULL,
	@FieldOrder smallint,
	@MultiSelection bit,
	@Required bit,
	@Lookup bit,
	@Address varchar(255) = NULL,
	@Method varchar(50) = NULL,
	@Field varchar(50) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessDynamicField]
	SET
		[DynamicFieldID] = @DynamicFieldID,
		[FlowID] = @FlowID,
		[ProcessID] = @ProcessID,
		[FieldOrder] = @FieldOrder,
		[MultiSelection] = @MultiSelection,
		[Required] = @Required,
		[Lookup] = @Lookup,
		[Address] = @Address,
		[Method] = @Method,
		[Field] = @Field,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessDynamicFieldID] = @ProcessDynamicFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldInsert;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDynamicFieldID int = NULL OUTPUT,
	@DynamicFieldID int,
	@FlowID int = NULL,
	@ProcessID int = NULL,
	@FieldOrder smallint,
	@MultiSelection bit,
	@Required bit,
	@Lookup bit,
	@Address varchar(255) = NULL,
	@Method varchar(50) = NULL,
	@Field varchar(50) = NULL,
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
	INTO [OW].[tblProcessDynamicField]
	(
		[DynamicFieldID],
		[FlowID],
		[ProcessID],
		[FieldOrder],
		[MultiSelection],
		[Required],
		[Lookup],
		[Address],
		[Method],
		[Field],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessDynamicFieldID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldDelete;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:18
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDynamicFieldID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessDynamicField]
	WHERE
		[ProcessDynamicFieldID] = @ProcessDynamicFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldValueSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldValueSelect;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldValueSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ProcessDynamicFieldValueID],
		[ProcessDynamicFieldID],
		[AlphaNumericFieldValue],
		[NumericFieldValue],
		[DateTimeFieldValue],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessDynamicFieldValue]
	WHERE
		(@ProcessDynamicFieldValueID IS NULL OR [ProcessDynamicFieldValueID] = @ProcessDynamicFieldValueID) AND
		(@ProcessDynamicFieldID IS NULL OR [ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND
		(@AlphaNumericFieldValue IS NULL OR [AlphaNumericFieldValue] LIKE @AlphaNumericFieldValue) AND
		(@NumericFieldValue IS NULL OR [NumericFieldValue] = @NumericFieldValue) AND
		(@DateTimeFieldValue IS NULL OR [DateTimeFieldValue] = @DateTimeFieldValue) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldValueSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldValueSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldValueSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
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
	
	IF(@ProcessDynamicFieldValueID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDynamicFieldValueID] = @ProcessDynamicFieldValueID) AND '
	IF(@ProcessDynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND '
	IF(@AlphaNumericFieldValue IS NOT NULL) SET @WHERE = @WHERE + '([AlphaNumericFieldValue] LIKE @AlphaNumericFieldValue) AND '
	IF(@NumericFieldValue IS NOT NULL) SET @WHERE = @WHERE + '([NumericFieldValue] = @NumericFieldValue) AND '
	IF(@DateTimeFieldValue IS NOT NULL) SET @WHERE = @WHERE + '([DateTimeFieldValue] = @DateTimeFieldValue) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessDynamicFieldValueID) 
	FROM [OW].[tblProcessDynamicFieldValue]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessDynamicFieldValueID int, 
		@ProcessDynamicFieldID int, 
		@AlphaNumericFieldValue varchar(1024), 
		@NumericFieldValue numeric(18,3), 
		@DateTimeFieldValue datetime, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessDynamicFieldValueID, 
		@ProcessDynamicFieldID, 
		@AlphaNumericFieldValue, 
		@NumericFieldValue, 
		@DateTimeFieldValue, 
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
	WHERE ProcessDynamicFieldValueID IN (
		SELECT TOP ' + @SizeString + ' ProcessDynamicFieldValueID
			FROM [OW].[tblProcessDynamicFieldValue]
			WHERE ProcessDynamicFieldValueID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessDynamicFieldValueID 
				FROM [OW].[tblProcessDynamicFieldValue]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessDynamicFieldValueID], 
		[ProcessDynamicFieldID], 
		[AlphaNumericFieldValue], 
		[NumericFieldValue], 
		[DateTimeFieldValue], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessDynamicFieldValue]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldValueUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldValueUpdate;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldValueUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDynamicFieldValueID int,
	@ProcessDynamicFieldID int,
	@AlphaNumericFieldValue varchar(1024) = NULL,
	@NumericFieldValue numeric(18,3) = NULL,
	@DateTimeFieldValue datetime = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessDynamicFieldValue]
	SET
		[ProcessDynamicFieldID] = @ProcessDynamicFieldID,
		[AlphaNumericFieldValue] = @AlphaNumericFieldValue,
		[NumericFieldValue] = @NumericFieldValue,
		[DateTimeFieldValue] = @DateTimeFieldValue,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessDynamicFieldValueID] = @ProcessDynamicFieldValueID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldValueInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldValueInsert;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldValueInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDynamicFieldValueID int = NULL OUTPUT,
	@ProcessDynamicFieldID int,
	@AlphaNumericFieldValue varchar(1024) = NULL,
	@NumericFieldValue numeric(18,3) = NULL,
	@DateTimeFieldValue datetime = NULL,
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
	INTO [OW].[tblProcessDynamicFieldValue]
	(
		[ProcessDynamicFieldID],
		[AlphaNumericFieldValue],
		[NumericFieldValue],
		[DateTimeFieldValue],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessDynamicFieldID,
		@AlphaNumericFieldValue,
		@NumericFieldValue,
		@DateTimeFieldValue,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessDynamicFieldValueID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDynamicFieldValueDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDynamicFieldValueDelete;
GO

CREATE PROCEDURE [OW].ProcessDynamicFieldValueDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDynamicFieldValueID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessDynamicFieldValue]
	WHERE
		[ProcessDynamicFieldValueID] = @ProcessDynamicFieldValueID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDynamicFieldValueDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventSelect;
GO

CREATE PROCEDURE [OW].ProcessEventSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ProcessEventID],
		[ProcessStageID],
		[ProcessID],
		[RoutingType],
		[ProcessEventStatus],
		[PreviousProcessEventID],
		[NextProcessEventID],
		[CreationDate],
		[ReadDate],
		[EstimatedDateToComplete],
		[OrganizationalUnitID],
		[ExecutionDate],
		[EndDate],
		[WorkflowActionType],
		[WorkflowInfo],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessEvent]
	WHERE
		(@ProcessEventID IS NULL OR [ProcessEventID] = @ProcessEventID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@RoutingType IS NULL OR [RoutingType] = @RoutingType) AND
		(@ProcessEventStatus IS NULL OR [ProcessEventStatus] = @ProcessEventStatus) AND
		(@PreviousProcessEventID IS NULL OR [PreviousProcessEventID] = @PreviousProcessEventID) AND
		(@NextProcessEventID IS NULL OR [NextProcessEventID] = @NextProcessEventID) AND
		(@CreationDate IS NULL OR [CreationDate] = @CreationDate) AND
		(@ReadDate IS NULL OR [ReadDate] = @ReadDate) AND
		(@EstimatedDateToComplete IS NULL OR [EstimatedDateToComplete] = @EstimatedDateToComplete) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@ExecutionDate IS NULL OR [ExecutionDate] = @ExecutionDate) AND
		(@EndDate IS NULL OR [EndDate] = @EndDate) AND
		(@WorkflowActionType IS NULL OR [WorkflowActionType] = @WorkflowActionType) AND
		(@WorkflowInfo IS NULL OR [WorkflowInfo] LIKE @WorkflowInfo) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessEventSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
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
	
	IF(@ProcessEventID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessEventID] = @ProcessEventID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@RoutingType IS NOT NULL) SET @WHERE = @WHERE + '([RoutingType] = @RoutingType) AND '
	IF(@ProcessEventStatus IS NOT NULL) SET @WHERE = @WHERE + '([ProcessEventStatus] = @ProcessEventStatus) AND '
	IF(@PreviousProcessEventID IS NOT NULL) SET @WHERE = @WHERE + '([PreviousProcessEventID] = @PreviousProcessEventID) AND '
	IF(@NextProcessEventID IS NOT NULL) SET @WHERE = @WHERE + '([NextProcessEventID] = @NextProcessEventID) AND '
	IF(@CreationDate IS NOT NULL) SET @WHERE = @WHERE + '([CreationDate] = @CreationDate) AND '
	IF(@ReadDate IS NOT NULL) SET @WHERE = @WHERE + '([ReadDate] = @ReadDate) AND '
	IF(@EstimatedDateToComplete IS NOT NULL) SET @WHERE = @WHERE + '([EstimatedDateToComplete] = @EstimatedDateToComplete) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@ExecutionDate IS NOT NULL) SET @WHERE = @WHERE + '([ExecutionDate] = @ExecutionDate) AND '
	IF(@EndDate IS NOT NULL) SET @WHERE = @WHERE + '([EndDate] = @EndDate) AND '
	IF(@WorkflowActionType IS NOT NULL) SET @WHERE = @WHERE + '([WorkflowActionType] = @WorkflowActionType) AND '
	IF(@WorkflowInfo IS NOT NULL) SET @WHERE = @WHERE + '([WorkflowInfo] LIKE @WorkflowInfo) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessEventID) 
	FROM [OW].[tblProcessEvent]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ProcessEventID IN (
		SELECT TOP ' + @SizeString + ' ProcessEventID
			FROM [OW].[tblProcessEvent]
			WHERE ProcessEventID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessEventID 
				FROM [OW].[tblProcessEvent]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessEventID], 
		[ProcessStageID], 
		[ProcessID], 
		[RoutingType], 
		[ProcessEventStatus], 
		[PreviousProcessEventID], 
		[NextProcessEventID], 
		[CreationDate], 
		[ReadDate], 
		[EstimatedDateToComplete], 
		[OrganizationalUnitID], 
		[ExecutionDate], 
		[EndDate], 
		[WorkflowActionType], 
		[WorkflowInfo], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessEvent]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventUpdate;
GO

CREATE PROCEDURE [OW].ProcessEventUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessEventID int,
	@ProcessStageID int = NULL,
	@ProcessID int,
	@RoutingType tinyint,
	@ProcessEventStatus tinyint,
	@PreviousProcessEventID int = NULL,
	@NextProcessEventID int = NULL,
	@CreationDate datetime,
	@ReadDate datetime = NULL,
	@EstimatedDateToComplete datetime = NULL,
	@OrganizationalUnitID int,
	@ExecutionDate datetime = NULL,
	@EndDate datetime = NULL,
	@WorkflowActionType tinyint,
	@WorkflowInfo varchar(1000) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessEvent]
	SET
		[ProcessStageID] = @ProcessStageID,
		[ProcessID] = @ProcessID,
		[RoutingType] = @RoutingType,
		[ProcessEventStatus] = @ProcessEventStatus,
		[PreviousProcessEventID] = @PreviousProcessEventID,
		[NextProcessEventID] = @NextProcessEventID,
		[CreationDate] = @CreationDate,
		[ReadDate] = @ReadDate,
		[EstimatedDateToComplete] = @EstimatedDateToComplete,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[ExecutionDate] = @ExecutionDate,
		[EndDate] = @EndDate,
		[WorkflowActionType] = @WorkflowActionType,
		[WorkflowInfo] = @WorkflowInfo,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessEventID] = @ProcessEventID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventInsert;
GO

CREATE PROCEDURE [OW].ProcessEventInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessEventID int = NULL OUTPUT,
	@ProcessStageID int = NULL,
	@ProcessID int,
	@RoutingType tinyint,
	@ProcessEventStatus tinyint,
	@PreviousProcessEventID int = NULL,
	@NextProcessEventID int = NULL,
	@CreationDate datetime,
	@ReadDate datetime = NULL,
	@EstimatedDateToComplete datetime = NULL,
	@OrganizationalUnitID int,
	@ExecutionDate datetime = NULL,
	@EndDate datetime = NULL,
	@WorkflowActionType tinyint,
	@WorkflowInfo varchar(1000) = NULL,
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
	INTO [OW].[tblProcessEvent]
	(
		[ProcessStageID],
		[ProcessID],
		[RoutingType],
		[ProcessEventStatus],
		[PreviousProcessEventID],
		[NextProcessEventID],
		[CreationDate],
		[ReadDate],
		[EstimatedDateToComplete],
		[OrganizationalUnitID],
		[ExecutionDate],
		[EndDate],
		[WorkflowActionType],
		[WorkflowInfo],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessEventID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventDelete;
GO

CREATE PROCEDURE [OW].ProcessEventDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessEventID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessEvent]
	WHERE
		[ProcessEventID] = @ProcessEventID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessPrioritySelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessPrioritySelect;
GO

CREATE PROCEDURE [OW].ProcessPrioritySelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ProcessPriorityID],
		[Description],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessPriority]
	WHERE
		(@ProcessPriorityID IS NULL OR [ProcessPriorityID] = @ProcessPriorityID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessPrioritySelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessPrioritySelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessPrioritySelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessPrioritySelectPaging;
GO

CREATE PROCEDURE [OW].ProcessPrioritySelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessPriorityID int = NULL,
	@Description varchar(255) = NULL,
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
	
	IF(@ProcessPriorityID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessPriorityID] = @ProcessPriorityID) AND '
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
	SELECT @RowCount = COUNT(ProcessPriorityID) 
	FROM [OW].[tblProcessPriority]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessPriorityID int, 
		@Description varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessPriorityID, 
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
	WHERE ProcessPriorityID IN (
		SELECT TOP ' + @SizeString + ' ProcessPriorityID
			FROM [OW].[tblProcessPriority]
			WHERE ProcessPriorityID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessPriorityID 
				FROM [OW].[tblProcessPriority]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessPriorityID], 
		[Description], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessPriority]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessPrioritySelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessPrioritySelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessPriorityUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessPriorityUpdate;
GO

CREATE PROCEDURE [OW].ProcessPriorityUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessPriorityID int,
	@Description varchar(255),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessPriority]
	SET
		[Description] = @Description,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessPriorityID] = @ProcessPriorityID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessPriorityUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessPriorityUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessPriorityInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessPriorityInsert;
GO

CREATE PROCEDURE [OW].ProcessPriorityInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessPriorityID int = NULL OUTPUT,
	@Description varchar(255),
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
	INTO [OW].[tblProcessPriority]
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
	SELECT @ProcessPriorityID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessPriorityInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessPriorityInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessPriorityDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessPriorityDelete;
GO

CREATE PROCEDURE [OW].ProcessPriorityDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessPriorityID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessPriority]
	WHERE
		[ProcessPriorityID] = @ProcessPriorityID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessPriorityDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessPriorityDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceSelect;
GO

CREATE PROCEDURE [OW].ProcessReferenceSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ProcessReferenceID],
		[ProcessEventID],
		[ProcessReferedID],
		[ProcessReferenceType],
		[ShareData],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessReference]
	WHERE
		(@ProcessReferenceID IS NULL OR [ProcessReferenceID] = @ProcessReferenceID) AND
		(@ProcessEventID IS NULL OR [ProcessEventID] = @ProcessEventID) AND
		(@ProcessReferedID IS NULL OR [ProcessReferedID] = @ProcessReferedID) AND
		(@ProcessReferenceType IS NULL OR [ProcessReferenceType] = @ProcessReferenceType) AND
		(@ShareData IS NULL OR [ShareData] = @ShareData) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessReferenceSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
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
	
	IF(@ProcessReferenceID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessReferenceID] = @ProcessReferenceID) AND '
	IF(@ProcessEventID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessEventID] = @ProcessEventID) AND '
	IF(@ProcessReferedID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessReferedID] = @ProcessReferedID) AND '
	IF(@ProcessReferenceType IS NOT NULL) SET @WHERE = @WHERE + '([ProcessReferenceType] = @ProcessReferenceType) AND '
	IF(@ShareData IS NOT NULL) SET @WHERE = @WHERE + '([ShareData] = @ShareData) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessReferenceID) 
	FROM [OW].[tblProcessReference]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ProcessReferenceID int, 
		@ProcessEventID int, 
		@ProcessReferedID int, 
		@ProcessReferenceType tinyint, 
		@ShareData bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessReferenceID, 
		@ProcessEventID, 
		@ProcessReferedID, 
		@ProcessReferenceType, 
		@ShareData, 
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
	WHERE ProcessReferenceID IN (
		SELECT TOP ' + @SizeString + ' ProcessReferenceID
			FROM [OW].[tblProcessReference]
			WHERE ProcessReferenceID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessReferenceID 
				FROM [OW].[tblProcessReference]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessReferenceID], 
		[ProcessEventID], 
		[ProcessReferedID], 
		[ProcessReferenceType], 
		[ShareData], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessReference]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceUpdate;
GO

CREATE PROCEDURE [OW].ProcessReferenceUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessReferenceID int,
	@ProcessEventID int,
	@ProcessReferedID int,
	@ProcessReferenceType tinyint,
	@ShareData bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessReference]
	SET
		[ProcessEventID] = @ProcessEventID,
		[ProcessReferedID] = @ProcessReferedID,
		[ProcessReferenceType] = @ProcessReferenceType,
		[ShareData] = @ShareData,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessReferenceID] = @ProcessReferenceID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceInsert;
GO

CREATE PROCEDURE [OW].ProcessReferenceInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessReferenceID int = NULL OUTPUT,
	@ProcessEventID int,
	@ProcessReferedID int,
	@ProcessReferenceType tinyint,
	@ShareData bit,
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
	INTO [OW].[tblProcessReference]
	(
		[ProcessEventID],
		[ProcessReferedID],
		[ProcessReferenceType],
		[ShareData],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessEventID,
		@ProcessReferedID,
		@ProcessReferenceType,
		@ShareData,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessReferenceID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceDelete;
GO

CREATE PROCEDURE [OW].ProcessReferenceDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessReferenceID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessReference]
	WHERE
		[ProcessReferenceID] = @ProcessReferenceID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageSelect;
GO

CREATE PROCEDURE [OW].ProcessStageSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ProcessStageID],
		[ProcessID],
		[Number],
		[Description],
		[Duration],
		[Address],
		[Method],
		[FlowStageType],
		[DocumentTemplateID],
		[OrganizationalUnitID],
		[CanAssociateProcess],
		[Transfer],
		[RequestForComments],
		[AttachmentRequired],
		[HelpAddress],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessStage]
	WHERE
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@Number IS NULL OR [Number] = @Number) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Duration IS NULL OR [Duration] = @Duration) AND
		(@Address IS NULL OR [Address] LIKE @Address) AND
		(@Method IS NULL OR [Method] LIKE @Method) AND
		(@FlowStageType IS NULL OR [FlowStageType] = @FlowStageType) AND
		(@DocumentTemplateID IS NULL OR [DocumentTemplateID] = @DocumentTemplateID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@CanAssociateProcess IS NULL OR [CanAssociateProcess] = @CanAssociateProcess) AND
		(@Transfer IS NULL OR [Transfer] = @Transfer) AND
		(@RequestForComments IS NULL OR [RequestForComments] = @RequestForComments) AND
		(@AttachmentRequired IS NULL OR [AttachmentRequired] = @AttachmentRequired) AND
		(@HelpAddress IS NULL OR [HelpAddress] LIKE @HelpAddress) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessStageSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
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
	@HelpAddress varchar(255) = NULL,
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
	
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@Number IS NOT NULL) SET @WHERE = @WHERE + '([Number] = @Number) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Duration IS NOT NULL) SET @WHERE = @WHERE + '([Duration] = @Duration) AND '
	IF(@Address IS NOT NULL) SET @WHERE = @WHERE + '([Address] LIKE @Address) AND '
	IF(@Method IS NOT NULL) SET @WHERE = @WHERE + '([Method] LIKE @Method) AND '
	IF(@FlowStageType IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageType] = @FlowStageType) AND '
	IF(@DocumentTemplateID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentTemplateID] = @DocumentTemplateID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@CanAssociateProcess IS NOT NULL) SET @WHERE = @WHERE + '([CanAssociateProcess] = @CanAssociateProcess) AND '
	IF(@Transfer IS NOT NULL) SET @WHERE = @WHERE + '([Transfer] = @Transfer) AND '
	IF(@RequestForComments IS NOT NULL) SET @WHERE = @WHERE + '([RequestForComments] = @RequestForComments) AND '
	IF(@AttachmentRequired IS NOT NULL) SET @WHERE = @WHERE + '([AttachmentRequired] = @AttachmentRequired) AND '
	IF(@HelpAddress IS NOT NULL) SET @WHERE = @WHERE + '([HelpAddress] LIKE @HelpAddress) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessStageID) 
	FROM [OW].[tblProcessStage]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@HelpAddress varchar(255), 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
		@HelpAddress, 
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
	WHERE ProcessStageID IN (
		SELECT TOP ' + @SizeString + ' ProcessStageID
			FROM [OW].[tblProcessStage]
			WHERE ProcessStageID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessStageID 
				FROM [OW].[tblProcessStage]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessStageID], 
		[ProcessID], 
		[Number], 
		[Description], 
		[Duration], 
		[Address], 
		[Method], 
		[FlowStageType], 
		[DocumentTemplateID], 
		[OrganizationalUnitID], 
		[CanAssociateProcess], 
		[Transfer], 
		[RequestForComments], 
		[AttachmentRequired], 
		[HelpAddress], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessStage]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageUpdate;
GO

CREATE PROCEDURE [OW].ProcessStageUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageID int,
	@ProcessID int,
	@Number smallint,
	@Description varchar(50),
	@Duration int,
	@Address varchar(255) = NULL,
	@Method varchar(50) = NULL,
	@FlowStageType smallint,
	@DocumentTemplateID int = NULL,
	@OrganizationalUnitID int = NULL,
	@CanAssociateProcess bit,
	@Transfer tinyint,
	@RequestForComments tinyint,
	@AttachmentRequired bit,
	@HelpAddress varchar(255) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessStage]
	SET
		[ProcessID] = @ProcessID,
		[Number] = @Number,
		[Description] = @Description,
		[Duration] = @Duration,
		[Address] = @Address,
		[Method] = @Method,
		[FlowStageType] = @FlowStageType,
		[DocumentTemplateID] = @DocumentTemplateID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[CanAssociateProcess] = @CanAssociateProcess,
		[Transfer] = @Transfer,
		[RequestForComments] = @RequestForComments,
		[AttachmentRequired] = @AttachmentRequired,
		[HelpAddress] = @HelpAddress,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessStageID] = @ProcessStageID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageInsert;
GO

CREATE PROCEDURE [OW].ProcessStageInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageID int = NULL OUTPUT,
	@ProcessID int,
	@Number smallint,
	@Description varchar(50),
	@Duration int,
	@Address varchar(255) = NULL,
	@Method varchar(50) = NULL,
	@FlowStageType smallint,
	@DocumentTemplateID int = NULL,
	@OrganizationalUnitID int = NULL,
	@CanAssociateProcess bit,
	@Transfer tinyint,
	@RequestForComments tinyint,
	@AttachmentRequired bit,
	@HelpAddress varchar(255) = NULL,
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
	INTO [OW].[tblProcessStage]
	(
		[ProcessID],
		[Number],
		[Description],
		[Duration],
		[Address],
		[Method],
		[FlowStageType],
		[DocumentTemplateID],
		[OrganizationalUnitID],
		[CanAssociateProcess],
		[Transfer],
		[RequestForComments],
		[AttachmentRequired],
		[HelpAddress],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
		@HelpAddress,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessStageID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageDelete;
GO

CREATE PROCEDURE [OW].ProcessStageDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessStage]
	WHERE
		[ProcessStageID] = @ProcessStageID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageAccessSelect;
GO

CREATE PROCEDURE [OW].ProcessStageAccessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ProcessStageAccessID],
		[FlowStageID],
		[ProcessStageID],
		[OrganizationalUnitID],
		[AccessObject],
		[DocumentAccess],
		[DispatchAccess],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessStageAccess]
	WHERE
		(@ProcessStageAccessID IS NULL OR [ProcessStageAccessID] = @ProcessStageAccessID) AND
		(@FlowStageID IS NULL OR [FlowStageID] = @FlowStageID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@AccessObject IS NULL OR [AccessObject] = @AccessObject) AND
		(@DocumentAccess IS NULL OR [DocumentAccess] = @DocumentAccess) AND
		(@DispatchAccess IS NULL OR [DispatchAccess] = @DispatchAccess) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageAccessSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessStageAccessSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
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
	
	IF(@ProcessStageAccessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageAccessID] = @ProcessStageAccessID) AND '
	IF(@FlowStageID IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageID] = @FlowStageID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@AccessObject IS NOT NULL) SET @WHERE = @WHERE + '([AccessObject] = @AccessObject) AND '
	IF(@DocumentAccess IS NOT NULL) SET @WHERE = @WHERE + '([DocumentAccess] = @DocumentAccess) AND '
	IF(@DispatchAccess IS NOT NULL) SET @WHERE = @WHERE + '([DispatchAccess] = @DispatchAccess) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessStageAccessID) 
	FROM [OW].[tblProcessStageAccess]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ProcessStageAccessID IN (
		SELECT TOP ' + @SizeString + ' ProcessStageAccessID
			FROM [OW].[tblProcessStageAccess]
			WHERE ProcessStageAccessID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessStageAccessID 
				FROM [OW].[tblProcessStageAccess]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessStageAccessID], 
		[FlowStageID], 
		[ProcessStageID], 
		[OrganizationalUnitID], 
		[AccessObject], 
		[DocumentAccess], 
		[DispatchAccess], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessStageAccess]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageAccessUpdate;
GO

CREATE PROCEDURE [OW].ProcessStageAccessUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageAccessID int,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL,
	@OrganizationalUnitID int = NULL,
	@AccessObject tinyint,
	@DocumentAccess tinyint,
	@DispatchAccess tinyint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessStageAccess]
	SET
		[FlowStageID] = @FlowStageID,
		[ProcessStageID] = @ProcessStageID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[AccessObject] = @AccessObject,
		[DocumentAccess] = @DocumentAccess,
		[DispatchAccess] = @DispatchAccess,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessStageAccessID] = @ProcessStageAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageAccessInsert;
GO

CREATE PROCEDURE [OW].ProcessStageAccessInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageAccessID int = NULL OUTPUT,
	@FlowStageID int = NULL,
	@ProcessStageID int = NULL,
	@OrganizationalUnitID int = NULL,
	@AccessObject tinyint,
	@DocumentAccess tinyint,
	@DispatchAccess tinyint,
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
	INTO [OW].[tblProcessStageAccess]
	(
		[FlowStageID],
		[ProcessStageID],
		[OrganizationalUnitID],
		[AccessObject],
		[DocumentAccess],
		[DispatchAccess],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@FlowStageID,
		@ProcessStageID,
		@OrganizationalUnitID,
		@AccessObject,
		@DocumentAccess,
		@DispatchAccess,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessStageAccessID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageAccessDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageAccessDelete;
GO

CREATE PROCEDURE [OW].ProcessStageAccessDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageAccessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessStageAccess]
	WHERE
		[ProcessStageAccessID] = @ProcessStageAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageAccessDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageAccessDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDynamicFieldSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageDynamicFieldSelect;
GO

CREATE PROCEDURE [OW].ProcessStageDynamicFieldSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-03-2006 20:00:17
	--Version: 1.2	
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

	SELECT
		[ProcessStageDynamicFieldID],
		[ProcessDynamicFieldID],
		[ProcessStageID],
		[FlowStageID],
		[Behavior],
		[CampoParaInteraccaoWS],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessStageDynamicField]
	WHERE
		(@ProcessStageDynamicFieldID IS NULL OR [ProcessStageDynamicFieldID] = @ProcessStageDynamicFieldID) AND
		(@ProcessDynamicFieldID IS NULL OR [ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@FlowStageID IS NULL OR [FlowStageID] = @FlowStageID) AND
		(@Behavior IS NULL OR [Behavior] = @Behavior) AND
		(@CampoParaInteraccaoWS IS NULL OR [CampoParaInteraccaoWS] = @CampoParaInteraccaoWS) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDynamicFieldSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageDynamicFieldSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessStageDynamicFieldSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-03-2006 20:00:17
	--Version: 1.1	
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
	
	IF(@ProcessStageDynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageDynamicFieldID] = @ProcessStageDynamicFieldID) AND '
	IF(@ProcessDynamicFieldID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessDynamicFieldID] = @ProcessDynamicFieldID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@FlowStageID IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageID] = @FlowStageID) AND '
	IF(@Behavior IS NOT NULL) SET @WHERE = @WHERE + '([Behavior] = @Behavior) AND '
	IF(@CampoParaInteraccaoWS IS NOT NULL) SET @WHERE = @WHERE + '([CampoParaInteraccaoWS] = @CampoParaInteraccaoWS) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessStageDynamicFieldID) 
	FROM [OW].[tblProcessStageDynamicField]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ProcessStageDynamicFieldID IN (
		SELECT TOP ' + @SizeString + ' ProcessStageDynamicFieldID
			FROM [OW].[tblProcessStageDynamicField]
			WHERE ProcessStageDynamicFieldID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessStageDynamicFieldID 
				FROM [OW].[tblProcessStageDynamicField]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessStageDynamicFieldID], 
		[ProcessDynamicFieldID], 
		[ProcessStageID], 
		[FlowStageID], 
		[Behavior], 
		[CampoParaInteraccaoWS], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessStageDynamicField]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDynamicFieldUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageDynamicFieldUpdate;
GO

CREATE PROCEDURE [OW].ProcessStageDynamicFieldUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-03-2006 20:00:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageDynamicFieldID int,
	@ProcessDynamicFieldID int,
	@ProcessStageID int = NULL,
	@FlowStageID int = NULL,
	@Behavior tinyint,
	@CampoParaInteraccaoWS smallint = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessStageDynamicField]
	SET
		[ProcessDynamicFieldID] = @ProcessDynamicFieldID,
		[ProcessStageID] = @ProcessStageID,
		[FlowStageID] = @FlowStageID,
		[Behavior] = @Behavior,
		[CampoParaInteraccaoWS] = @CampoParaInteraccaoWS,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessStageDynamicFieldID] = @ProcessStageDynamicFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDynamicFieldInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageDynamicFieldInsert;
GO

CREATE PROCEDURE [OW].ProcessStageDynamicFieldInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-03-2006 20:00:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageDynamicFieldID int = NULL OUTPUT,
	@ProcessDynamicFieldID int,
	@ProcessStageID int = NULL,
	@FlowStageID int = NULL,
	@Behavior tinyint,
	@CampoParaInteraccaoWS smallint = NULL,
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
	INTO [OW].[tblProcessStageDynamicField]
	(
		[ProcessDynamicFieldID],
		[ProcessStageID],
		[FlowStageID],
		[Behavior],
		[CampoParaInteraccaoWS],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessDynamicFieldID,
		@ProcessStageID,
		@FlowStageID,
		@Behavior,
		@CampoParaInteraccaoWS,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessStageDynamicFieldID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageDynamicFieldDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageDynamicFieldDelete;
GO

CREATE PROCEDURE [OW].ProcessStageDynamicFieldDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 01-03-2006 20:00:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessStageDynamicFieldID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessStageDynamicField]
	WHERE
		[ProcessStageDynamicFieldID] = @ProcessStageDynamicFieldID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessStageDynamicFieldDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceSelect;
GO

CREATE PROCEDURE [OW].ResourceSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-03-2006 17:33:49
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
	@LastModifiedOn datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[ResourceID],
		[ModuleID],
		[Description],
		[Active],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblResource]
	WHERE
		(@ResourceID IS NULL OR [ResourceID] = @ResourceID) AND
		(@ModuleID IS NULL OR [ModuleID] = @ModuleID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Active IS NULL OR [Active] = @Active) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceSelectPaging;
GO

CREATE PROCEDURE [OW].ResourceSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-03-2006 17:33:49
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
	
	IF(@ResourceID IS NOT NULL) SET @WHERE = @WHERE + '([ResourceID] = @ResourceID) AND '
	IF(@ModuleID IS NOT NULL) SET @WHERE = @WHERE + '([ModuleID] = @ModuleID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '([Active] = @Active) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ResourceID) 
	FROM [OW].[tblResource]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
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
		SET @WPag = (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField
    END
    ELSE
    BEGIN
        SET @WPag = '
	WHERE ResourceID IN (
		SELECT TOP ' + @SizeString + ' ResourceID
			FROM [OW].[tblResource]
			WHERE ResourceID NOT IN (
				SELECT TOP ' + @PrevString + ' ResourceID 
				FROM [OW].[tblResource]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ResourceID], 
		[ModuleID], 
		[Description], 
		[Active], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblResource]
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceUpdate;
GO

CREATE PROCEDURE [OW].ResourceUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-03-2006 17:33:49
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceID int,
	@ModuleID int,
	@Description varchar(80),
	@Active smallint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblResource]
	SET
		[ModuleID] = @ModuleID,
		[Description] = @Description,
		[Active] = @Active,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ResourceID] = @ResourceID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceInsert;
GO

CREATE PROCEDURE [OW].ResourceInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-03-2006 17:33:49
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceID int,
	@ModuleID int,
	@Description varchar(80),
	@Active smallint,
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
	INTO [OW].[tblResource]
	(
		[ResourceID],
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
		@ResourceID,
		@ModuleID,
		@Description,
		@Active,
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceDelete;
GO

CREATE PROCEDURE [OW].ResourceDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-03-2006 17:33:49
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblResource]
	WHERE
		[ResourceID] = @ResourceID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceAccessSelect;
GO

CREATE PROCEDURE [OW].ResourceAccessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:19
	--Version: 1.2	
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

	SELECT
		[ResourceAccessID],
		[OrganizationalUnitID],
		[ResourceID],
		[AccessType],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblResourceAccess]
	WHERE
		(@ResourceAccessID IS NULL OR [ResourceAccessID] = @ResourceAccessID) AND
		(@OrganizationalUnitID IS NULL OR [OrganizationalUnitID] = @OrganizationalUnitID) AND
		(@ResourceID IS NULL OR [ResourceID] = @ResourceID) AND
		(@AccessType IS NULL OR [AccessType] = @AccessType) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceAccessSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceAccessSelectPaging;
GO

CREATE PROCEDURE [OW].ResourceAccessSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceAccessID int = NULL,
	@OrganizationalUnitID int = NULL,
	@ResourceID int = NULL,
	@AccessType tinyint = NULL,
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
	
	IF(@ResourceAccessID IS NOT NULL) SET @WHERE = @WHERE + '([ResourceAccessID] = @ResourceAccessID) AND '
	IF(@OrganizationalUnitID IS NOT NULL) SET @WHERE = @WHERE + '([OrganizationalUnitID] = @OrganizationalUnitID) AND '
	IF(@ResourceID IS NOT NULL) SET @WHERE = @WHERE + '([ResourceID] = @ResourceID) AND '
	IF(@AccessType IS NOT NULL) SET @WHERE = @WHERE + '([AccessType] = @AccessType) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ResourceAccessID) 
	FROM [OW].[tblResourceAccess]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ResourceAccessID int, 
		@OrganizationalUnitID int, 
		@ResourceID int, 
		@AccessType tinyint, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ResourceAccessID, 
		@OrganizationalUnitID, 
		@ResourceID, 
		@AccessType, 
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
	WHERE ResourceAccessID IN (
		SELECT TOP ' + @SizeString + ' ResourceAccessID
			FROM [OW].[tblResourceAccess]
			WHERE ResourceAccessID NOT IN (
				SELECT TOP ' + @PrevString + ' ResourceAccessID 
				FROM [OW].[tblResourceAccess]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ResourceAccessID], 
		[OrganizationalUnitID], 
		[ResourceID], 
		[AccessType], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblResourceAccess]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceAccessSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceAccessUpdate;
GO

CREATE PROCEDURE [OW].ResourceAccessUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceAccessID int,
	@OrganizationalUnitID int,
	@ResourceID int,
	@AccessType tinyint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblResourceAccess]
	SET
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[ResourceID] = @ResourceID,
		[AccessType] = @AccessType,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ResourceAccessID] = @ResourceAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceAccessUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceAccessInsert;
GO

CREATE PROCEDURE [OW].ResourceAccessInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceAccessID int = NULL OUTPUT,
	@OrganizationalUnitID int,
	@ResourceID int,
	@AccessType tinyint,
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
	INTO [OW].[tblResourceAccess]
	(
		[OrganizationalUnitID],
		[ResourceID],
		[AccessType],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@OrganizationalUnitID,
		@ResourceID,
		@AccessType,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ResourceAccessID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceAccessInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ResourceAccessDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ResourceAccessDelete;
GO

CREATE PROCEDURE [OW].ResourceAccessDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@ResourceAccessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblResourceAccess]
	WHERE
		[ResourceAccessID] = @ResourceAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ResourceAccessDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ResourceAccessDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelect;
GO

CREATE PROCEDURE [OW].UserSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.2	
	------------------------------------------------------------------------
	@userID int = NULL,
	@PrimaryGroupID int = NULL,
	@userDesc varchar(50) = NULL,
	@userMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@MobilePhone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@NotifyByMail bit = NULL,
	@NotifyBySMS bit = NULL,
	@userLogin varchar(50) = NULL,
	@Password varchar(50) = NULL,
	@EntityID numeric(18,0) = NULL,
	@TextSignature varchar(300) = NULL,
	@GroupHead bit = NULL,
	@userActive bit = NULL,
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
	FROM [OW].[tblUser]
	WHERE
		(@userID IS NULL OR [userID] = @userID) AND
		(@PrimaryGroupID IS NULL OR [PrimaryGroupID] = @PrimaryGroupID) AND
		(@userDesc IS NULL OR [userDesc] LIKE @userDesc) AND
		(@userMail IS NULL OR [userMail] LIKE @userMail) AND
		(@Phone IS NULL OR [Phone] LIKE @Phone) AND
		(@MobilePhone IS NULL OR [MobilePhone] LIKE @MobilePhone) AND
		(@Fax IS NULL OR [Fax] LIKE @Fax) AND
		(@NotifyByMail IS NULL OR [NotifyByMail] = @NotifyByMail) AND
		(@NotifyBySMS IS NULL OR [NotifyBySMS] = @NotifyBySMS) AND
		(@userLogin IS NULL OR [userLogin] LIKE @userLogin) AND
		(@Password IS NULL OR [Password] LIKE @Password) AND
		(@EntityID IS NULL OR [EntityID] = @EntityID) AND
		(@TextSignature IS NULL OR [TextSignature] LIKE @TextSignature) AND
		(@GroupHead IS NULL OR [GroupHead] = @GroupHead) AND
		(@userActive IS NULL OR [userActive] = @userActive) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelectPaging;
GO

CREATE PROCEDURE [OW].UserSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@userID int = NULL,
	@PrimaryGroupID int = NULL,
	@userDesc varchar(50) = NULL,
	@userMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@MobilePhone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@NotifyByMail bit = NULL,
	@NotifyBySMS bit = NULL,
	@userLogin varchar(50) = NULL,
	@Password varchar(50) = NULL,
	@EntityID numeric(18,0) = NULL,
	@TextSignature varchar(300) = NULL,
	@GroupHead bit = NULL,
	@userActive bit = NULL,
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
	
	IF(@userID IS NOT NULL) SET @WHERE = @WHERE + '([userID] = @userID) AND '
	IF(@PrimaryGroupID IS NOT NULL) SET @WHERE = @WHERE + '([PrimaryGroupID] = @PrimaryGroupID) AND '
	IF(@userDesc IS NOT NULL) SET @WHERE = @WHERE + '([userDesc] LIKE @userDesc) AND '
	IF(@userMail IS NOT NULL) SET @WHERE = @WHERE + '([userMail] LIKE @userMail) AND '
	IF(@Phone IS NOT NULL) SET @WHERE = @WHERE + '([Phone] LIKE @Phone) AND '
	IF(@MobilePhone IS NOT NULL) SET @WHERE = @WHERE + '([MobilePhone] LIKE @MobilePhone) AND '
	IF(@Fax IS NOT NULL) SET @WHERE = @WHERE + '([Fax] LIKE @Fax) AND '
	IF(@NotifyByMail IS NOT NULL) SET @WHERE = @WHERE + '([NotifyByMail] = @NotifyByMail) AND '
	IF(@NotifyBySMS IS NOT NULL) SET @WHERE = @WHERE + '([NotifyBySMS] = @NotifyBySMS) AND '
	IF(@userLogin IS NOT NULL) SET @WHERE = @WHERE + '([userLogin] LIKE @userLogin) AND '
	IF(@Password IS NOT NULL) SET @WHERE = @WHERE + '([Password] LIKE @Password) AND '
	IF(@EntityID IS NOT NULL) SET @WHERE = @WHERE + '([EntityID] = @EntityID) AND '
	IF(@TextSignature IS NOT NULL) SET @WHERE = @WHERE + '([TextSignature] LIKE @TextSignature) AND '
	IF(@GroupHead IS NOT NULL) SET @WHERE = @WHERE + '([GroupHead] = @GroupHead) AND '
	IF(@userActive IS NOT NULL) SET @WHERE = @WHERE + '([userActive] = @userActive) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(userID) 
	FROM [OW].[tblUser]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@userID int, 
		@PrimaryGroupID int, 
		@userDesc varchar(50), 
		@userMail varchar(50), 
		@Phone varchar(25), 
		@MobilePhone varchar(25), 
		@Fax varchar(25), 
		@NotifyByMail bit, 
		@NotifyBySMS bit, 
		@userLogin varchar(50), 
		@Password varchar(50), 
		@EntityID numeric(18,0), 
		@TextSignature varchar(300), 
		@GroupHead bit, 
		@userActive bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@userID, 
		@PrimaryGroupID, 
		@userDesc, 
		@userMail, 
		@Phone, 
		@MobilePhone, 
		@Fax, 
		@NotifyByMail, 
		@NotifyBySMS, 
		@userLogin, 
		@Password, 
		@EntityID, 
		@TextSignature, 
		@GroupHead, 
		@userActive, 
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
	WHERE userID IN (
		SELECT TOP ' + @SizeString + ' userID
			FROM [OW].[tblUser]
			WHERE userID NOT IN (
				SELECT TOP ' + @PrevString + ' userID 
				FROM [OW].[tblUser]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
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
	FROM [OW].[tblUser]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@userID int, 
		@PrimaryGroupID int, 
		@userDesc varchar(50), 
		@userMail varchar(50), 
		@Phone varchar(25), 
		@MobilePhone varchar(25), 
		@Fax varchar(25), 
		@NotifyByMail bit, 
		@NotifyBySMS bit, 
		@userLogin varchar(50), 
		@Password varchar(50), 
		@EntityID numeric(18,0), 
		@TextSignature varchar(300), 
		@GroupHead bit, 
		@userActive bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime',
		@userID, 
		@PrimaryGroupID, 
		@userDesc, 
		@userMail, 
		@Phone, 
		@MobilePhone, 
		@Fax, 
		@NotifyByMail, 
		@NotifyBySMS, 
		@userLogin, 
		@Password, 
		@EntityID, 
		@TextSignature, 
		@GroupHead, 
		@userActive, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserUpdate;
GO

CREATE PROCEDURE [OW].UserUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@userID int,
	@PrimaryGroupID int = NULL,
	@userDesc varchar(50),
	@userMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@MobilePhone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@NotifyByMail bit,
	@NotifyBySMS bit,
	@userLogin varchar(50),
	@Password varchar(50) = NULL,
	@EntityID numeric(18,0) = NULL,
	@TextSignature varchar(300) = NULL,
	@GroupHead bit,
	@userActive bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblUser]
	SET
		[PrimaryGroupID] = @PrimaryGroupID,
		[userDesc] = @userDesc,
		[userMail] = @userMail,
		[Phone] = @Phone,
		[MobilePhone] = @MobilePhone,
		[Fax] = @Fax,
		[NotifyByMail] = @NotifyByMail,
		[NotifyBySMS] = @NotifyBySMS,
		[userLogin] = @userLogin,
		[Password] = @Password,
		[EntityID] = @EntityID,
		[TextSignature] = @TextSignature,
		[GroupHead] = @GroupHead,
		[userActive] = @userActive,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[userID] = @userID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserInsert;
GO

CREATE PROCEDURE [OW].UserInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@userID int = NULL OUTPUT,
	@PrimaryGroupID int = NULL,
	@userDesc varchar(50),
	@userMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@MobilePhone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@NotifyByMail bit,
	@NotifyBySMS bit,
	@userLogin varchar(50),
	@Password varchar(50) = NULL,
	@EntityID numeric(18,0) = NULL,
	@TextSignature varchar(300) = NULL,
	@GroupHead bit,
	@userActive bit,
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
	INTO [OW].[tblUser]
	(
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
	)
	VALUES
	(
		@PrimaryGroupID,
		@userDesc,
		@userMail,
		@Phone,
		@MobilePhone,
		@Fax,
		@NotifyByMail,
		@NotifyBySMS,
		@userLogin,
		@Password,
		@EntityID,
		@TextSignature,
		@GroupHead,
		@userActive,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @userID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserDelete;
GO

CREATE PROCEDURE [OW].UserDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@userID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblUser]
	WHERE
		[userID] = @userID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserDelete Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodSelect;
GO

CREATE PROCEDURE [OW].WorkingPeriodSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.2	
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

	SELECT
		[WorkingPeriodID],
		[WeekDay],
		[StartHour],
		[StartMinute],
		[FinishHour],
		[FinishMinute],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblWorkingPeriod]
	WHERE
		(@WorkingPeriodID IS NULL OR [WorkingPeriodID] = @WorkingPeriodID) AND
		(@WeekDay IS NULL OR [WeekDay] = @WeekDay) AND
		(@StartHour IS NULL OR [StartHour] = @StartHour) AND
		(@StartMinute IS NULL OR [StartMinute] = @StartMinute) AND
		(@FinishHour IS NULL OR [FinishHour] = @FinishHour) AND
		(@FinishMinute IS NULL OR [FinishMinute] = @FinishMinute) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodSelectPaging;
GO

CREATE PROCEDURE [OW].WorkingPeriodSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
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
	
	IF(@WorkingPeriodID IS NOT NULL) SET @WHERE = @WHERE + '([WorkingPeriodID] = @WorkingPeriodID) AND '
	IF(@WeekDay IS NOT NULL) SET @WHERE = @WHERE + '([WeekDay] = @WeekDay) AND '
	IF(@StartHour IS NOT NULL) SET @WHERE = @WHERE + '([StartHour] = @StartHour) AND '
	IF(@StartMinute IS NOT NULL) SET @WHERE = @WHERE + '([StartMinute] = @StartMinute) AND '
	IF(@FinishHour IS NOT NULL) SET @WHERE = @WHERE + '([FinishHour] = @FinishHour) AND '
	IF(@FinishMinute IS NOT NULL) SET @WHERE = @WHERE + '([FinishMinute] = @FinishMinute) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(WorkingPeriodID) 
	FROM [OW].[tblWorkingPeriod]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
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
	WHERE WorkingPeriodID IN (
		SELECT TOP ' + @SizeString + ' WorkingPeriodID
			FROM [OW].[tblWorkingPeriod]
			WHERE WorkingPeriodID NOT IN (
				SELECT TOP ' + @PrevString + ' WorkingPeriodID 
				FROM [OW].[tblWorkingPeriod]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[WorkingPeriodID], 
		[WeekDay], 
		[StartHour], 
		[StartMinute], 
		[FinishHour], 
		[FinishMinute], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblWorkingPeriod]
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodUpdate;
GO

CREATE PROCEDURE [OW].WorkingPeriodUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@WorkingPeriodID int,
	@WeekDay int,
	@StartHour int,
	@StartMinute int,
	@FinishHour int,
	@FinishMinute int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblWorkingPeriod]
	SET
		[WeekDay] = @WeekDay,
		[StartHour] = @StartHour,
		[StartMinute] = @StartMinute,
		[FinishHour] = @FinishHour,
		[FinishMinute] = @FinishMinute,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[WorkingPeriodID] = @WorkingPeriodID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodInsert;
GO

CREATE PROCEDURE [OW].WorkingPeriodInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@WorkingPeriodID int = NULL OUTPUT,
	@WeekDay int,
	@StartHour int,
	@StartMinute int,
	@FinishHour int,
	@FinishMinute int,
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
	INTO [OW].[tblWorkingPeriod]
	(
		[WeekDay],
		[StartHour],
		[StartMinute],
		[FinishHour],
		[FinishMinute],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@WeekDay,
		@StartHour,
		@StartMinute,
		@FinishHour,
		@FinishMinute,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @WorkingPeriodID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].WorkingPeriodDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].WorkingPeriodDelete;
GO

CREATE PROCEDURE [OW].WorkingPeriodDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 28-02-2006 15:48:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@WorkingPeriodID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblWorkingPeriod]
	WHERE
		[WorkingPeriodID] = @WorkingPeriodID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].WorkingPeriodDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].WorkingPeriodDelete Error on Creation'
GO
