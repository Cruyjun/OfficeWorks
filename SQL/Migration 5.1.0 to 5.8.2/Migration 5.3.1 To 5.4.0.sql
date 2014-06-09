-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.3.1 PARA A VERSÃO 5.4.0
--
-- ---------------------------------------------------------------------------------

PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.3.1 PARA 5.4.0'
PRINT ''
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
PRINT N'Dropping foreign keys from [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] DROP
CONSTRAINT [FK_tblAlarmQueue_tblProcessAlarm]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] DROP
CONSTRAINT [FK_tblAlert_tblUser],
CONSTRAINT [FK_tblAlert_tblProcess],
CONSTRAINT [FK_tblAlert_tblProcessStage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] DROP
CONSTRAINT [FK_tblRequest_tblRequestMotionType],
CONSTRAINT [FK_tblRequest_tblRequestMotiveConsult1],
CONSTRAINT [FK_tblRequest_tblRequestType],
CONSTRAINT [FK_tblRequest_tblUser],
CONSTRAINT [FK_tblRequest_tblUser1],
CONSTRAINT [FK_tblRequest_tblUser2]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] DROP CONSTRAINT [CK_tblAlarmQueue01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] DROP CONSTRAINT [PK_tblAlarmQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] DROP CONSTRAINT [CK_tblAlert02]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] DROP CONSTRAINT [CK_tblAlert01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] DROP CONSTRAINT [PK_tblAlert]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] DROP CONSTRAINT [CK_tblProcessAlarm02]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] DROP CONSTRAINT [CK_tblProcessAlarm04]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] DROP CONSTRAINT [CK_tblProcessAlarm05]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] DROP CONSTRAINT [CK_tblRequest_Solicitor]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] DROP CONSTRAINT [tblRequest_ck]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] DROP CONSTRAINT [CK_tblRequest_Origin]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] DROP CONSTRAINT [CK_tblRequest_State]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] DROP CONSTRAINT [PK_tblRequest]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblProfiles]'
GO
ALTER TABLE [OW].[tblProfiles] DROP CONSTRAINT [IX_tblProfiles_DescUNIQUE]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLALARMQUEUE01] from [OW].[tblAlarmQueue]'
GO
DROP INDEX [OW].[tblAlarmQueue].[IX_TBLALARMQUEUE01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLALERT01] from [OW].[tblAlert]'
GO
DROP INDEX [OW].[tblAlert].[IX_TBLALERT01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLALERT02] from [OW].[tblAlert]'
GO
DROP INDEX [OW].[tblAlert].[IX_TBLALERT02]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_tblRequest_Number_Year] from [OW].[tblRequest]'
GO
DROP INDEX [OW].[tblRequest].[IX_tblRequest_Number_Year]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[tblRequestAlarm]'
GO
CREATE TABLE [OW].[tblRequestAlarm]
(
[RequestAlarmID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [numeric] (18, 0) NULL,
[Occurence] [tinyint] NOT NULL,
[OccurenceOffset] [int] NOT NULL,
[Message] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AlertByEMail] [bit] NOT NULL,
[AddresseeRequestOwner] [bit] NOT NULL,
[AddresseeLastModifyUser] [bit] NOT NULL,
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblRequestAlarm] on [OW].[tblRequestAlarm]'
GO
ALTER TABLE [OW].[tblRequestAlarm] ADD CONSTRAINT [PK_tblRequestAlarm] PRIMARY KEY CLUSTERED  ([RequestAlarmID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLREQUESTALARM01] on [OW].[tblRequestAlarm]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLREQUESTALARM01] ON [OW].[tblRequestAlarm] ([RequestID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[tblExceptionManagement]'
GO
CREATE TABLE [OW].[tblExceptionManagement]
(
[ExceptionID] [int] NOT NULL,
[Description] [varchar] (80) COLLATE Latin1_General_CI_AS NOT NULL,
[Active] [bit] NOT NULL,
[Message] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AlertByEMail] [bit] NOT NULL,
[AddresseeExecutant] [bit] NOT NULL,
[AddresseeFlowOwner] [bit] NOT NULL,
[AddresseeProcessOwner] [bit] NOT NULL,
[AddresseeBookManager] [bit] NOT NULL,
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblExceptionManagement] on [OW].[tblExceptionManagement]'
GO
ALTER TABLE [OW].[tblExceptionManagement] ADD CONSTRAINT [PK_tblExceptionManagement] PRIMARY KEY CLUSTERED  ([ExceptionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementInsert]'
GO

CREATE PROCEDURE [OW].ExceptionManagementInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionID int,
	@Description varchar(80),
	@Active bit,
	@Message varchar(255),
	@AlertByEMail bit,
	@AddresseeExecutant bit,
	@AddresseeFlowOwner bit,
	@AddresseeProcessOwner bit,
	@AddresseeBookManager bit,
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
	INTO [OW].[tblExceptionManagement]
	(
		[ExceptionID],
		[Description],
		[Active],
		[Message],
		[AlertByEMail],
		[AddresseeExecutant],
		[AddresseeFlowOwner],
		[AddresseeProcessOwner],
		[AddresseeBookManager],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [OW].[tblRequest]'
GO
CREATE TABLE [OW].[tmp_rg_xx_tblRequest]
(
[RequestID] [numeric] (18, 0) NOT NULL IDENTITY(1, 1),
[Number] [numeric] (18, 0) NOT NULL,
[Year] [numeric] (18, 0) NOT NULL,
[RequestDate] [datetime] NOT NULL,
[EntID] [numeric] (18, 0) NULL,
[UserID] [int] NULL,
[RegID] [numeric] (18, 0) NULL,
[SerieID] [numeric] (18, 0) NULL,
[Reference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ReferenceYear] [numeric] (18, 0) NULL,
[Subject] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[MotionID] [numeric] (18, 0) NOT NULL,
[MotiveID] [numeric] (18, 0) NOT NULL,
[RequestTypeID] [numeric] (18, 0) NOT NULL,
[Origin] [int] NOT NULL,
[LimitDate] [datetime] NULL,
[DevolutionDate] [datetime] NULL,
[State] [int] NOT NULL,
[Observation] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[CreatedByID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ModifiedByID] [int] NULL,
[ModifiedDate] [datetime] NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblRequest] ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [OW].[tmp_rg_xx_tblRequest]([RequestID], [Number], [Year], [RequestDate], [EntID], [UserID], [RegID], [SerieID], [Reference], [ReferenceYear], [Subject], [MotionID], [MotiveID], [RequestTypeID], [Origin], [LimitDate], [DevolutionDate], [State], [Observation], [CreatedByID], [CreatedDate], [ModifiedByID], [ModifiedDate]) SELECT [RequestID], [Number], [Year], [RequestDate], [EntID], [UserID], [RegID], [SerieID], [Reference], [ReferenceYear], [Subject], [MotionID], [MotiveID], [RequestTypeID], [Origin], [LimitDate], [DevolutionDate], [State], [Observation], [CreatedByID], [CreatedDate], [ModifiedByID], [ModifiedDate] FROM [OW].[tblRequest]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblRequest] OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [OW].[tblRequest]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_rename N'[OW].[tmp_rg_xx_tblRequest]', N'tblRequest'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblRequest] on [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] ADD CONSTRAINT [PK_tblRequest] PRIMARY KEY CLUSTERED  ([RequestID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_tblRequest_Number_Year] on [OW].[tblRequest]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblRequest_Number_Year] ON [OW].[tblRequest] ([Number], [Year])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[tblExceptionManagementAddressee]'
GO
CREATE TABLE [OW].[tblExceptionManagementAddressee]
(
[ExceptionManagementAddresseeID] [int] NOT NULL IDENTITY(1, 1),
[ExceptionID] [int] NOT NULL,
[OrganizationalUnitID] [int] NOT NULL,
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblExceptionManagementAddressee] on [OW].[tblExceptionManagementAddressee]'
GO
ALTER TABLE [OW].[tblExceptionManagementAddressee] ADD CONSTRAINT [PK_tblExceptionManagementAddressee] PRIMARY KEY CLUSTERED  ([ExceptionManagementAddresseeID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLEXCEPTIONMANAGEMENTADDRESSEE01] on [OW].[tblExceptionManagementAddressee]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLEXCEPTIONMANAGEMENTADDRESSEE01] ON [OW].[tblExceptionManagementAddressee] ([ExceptionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementAddresseeUpdate]'
GO

CREATE PROCEDURE [OW].ExceptionManagementAddresseeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionManagementAddresseeID int,
	@ExceptionID int,
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

	UPDATE [OW].[tblExceptionManagementAddressee]
	SET
		[ExceptionID] = @ExceptionID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ExceptionManagementAddresseeID] = @ExceptionManagementAddresseeID
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
PRINT N'Rebuilding [OW].[tblAlert]'
GO
CREATE TABLE [OW].[tmp_rg_xx_tblAlert]
(
[AlertID] [int] NOT NULL IDENTITY(1, 1),
[Message] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[UserID] [int] NOT NULL,
[AlertType] [tinyint] NULL, -- Change NOT NULL to NULL
[ProcessID] [int] NULL,
[ProcessStageID] [int] NULL,
[RequestID] [numeric] (18, 0) NULL,
[ExceptionID] [int] NULL,
[SendDateTime] [datetime] NOT NULL,
[ReadDateTime] [datetime] NULL,
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblAlert] ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [OW].[tmp_rg_xx_tblAlert]([AlertID], [Message], [UserID], [ProcessID], [ProcessStageID], [SendDateTime], [ReadDateTime], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) SELECT [AlertID], [Message], [UserID], [ProcessID], [ProcessStageID], [SendDateTime], [ReadDateTime], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn] FROM [OW].[tblAlert]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblAlert] OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [OW].[tblAlert]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_rename N'[OW].[tmp_rg_xx_tblAlert]', N'tblAlert'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblAlert] on [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] ADD CONSTRAINT [PK_tblAlert] PRIMARY KEY CLUSTERED  ([AlertID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLALERT01] on [OW].[tblAlert]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLALERT01] ON [OW].[tblAlert] ([UserID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLALERT02] on [OW].[tblAlert]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLALERT02] ON [OW].[tblAlert] ([ProcessID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLALERT03] on [OW].[tblAlert]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLALERT03] ON [OW].[tblAlert] ([RequestID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLALERT04] on [OW].[tblAlert]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLALERT04] ON [OW].[tblAlert] ([ExceptionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- -----------------------------------------------
-- Added default value to AlertType 
-- -----------------------------------------------
UPDATE [OW].[tblAlert] SET AlertType = 1 WHERE AlertType IS NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE OW.tblAlert
	ALTER COLUMN AlertType TINYINT NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
-- -----------------------------------------------
-- End
-- -----------------------------------------------

PRINT N'Altering [OW].[AlertDelete]'
GO

ALTER PROCEDURE [OW].AlertDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-04-2007 18:06:06
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[tblRequestAlarmAddressee]'
GO
CREATE TABLE [OW].[tblRequestAlarmAddressee]
(
[RequestAlarmAddresseeID] [int] NOT NULL IDENTITY(1, 1),
[RequestAlarmID] [int] NOT NULL,
[OrganizationalUnitID] [int] NOT NULL,
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblRequestAlarmAddressee] on [OW].[tblRequestAlarmAddressee]'
GO
ALTER TABLE [OW].[tblRequestAlarmAddressee] ADD CONSTRAINT [PK_tblRequestAlarmAddressee] PRIMARY KEY CLUSTERED  ([RequestAlarmAddresseeID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLREQUESTALARMADDRESSEE01] on [OW].[tblRequestAlarmAddressee]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLREQUESTALARMADDRESSEE01] ON [OW].[tblRequestAlarmAddressee] ([RequestAlarmID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmAddresseeSelect]'
GO

CREATE PROCEDURE [OW].RequestAlarmAddresseeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.2	
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

	SELECT
		[RequestAlarmAddresseeID],
		[RequestAlarmID],
		[OrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblRequestAlarmAddressee]
	WHERE
		(@RequestAlarmAddresseeID IS NULL OR [RequestAlarmAddresseeID] = @RequestAlarmAddresseeID) AND
		(@RequestAlarmID IS NULL OR [RequestAlarmID] = @RequestAlarmID) AND
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmUpdate]'
GO

CREATE PROCEDURE [OW].RequestAlarmUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmID int,
	@RequestID numeric(18,0) = NULL,
	@Occurence tinyint,
	@OccurenceOffset int,
	@Message varchar(255),
	@AlertByEMail bit,
	@AddresseeRequestOwner bit,
	@AddresseeLastModifyUser bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblRequestAlarm]
	SET
		[RequestID] = @RequestID,
		[Occurence] = @Occurence,
		[OccurenceOffset] = @OccurenceOffset,
		[Message] = @Message,
		[AlertByEMail] = @AlertByEMail,
		[AddresseeRequestOwner] = @AddresseeRequestOwner,
		[AddresseeLastModifyUser] = @AddresseeLastModifyUser,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[RequestAlarmID] = @RequestAlarmID
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
PRINT N'Altering [OW].[usp_SetRequest]'
GO

ALTER  PROCEDURE [OW].usp_SetRequest
(
	@RequestID numeric(18,0),
	--@Number numeric(18,0),
	--@Year numeric(18,0),
	--@RequestDate  datetime,
	@EntID numeric(18,0) = NULL,
	@UserID int = NULL,
	@Reference varchar(50) = NULL,
	@ReferenceYear numeric(18,0) = NULL,
	@MotionID numeric(18,0),
	@MotiveID numeric(18,0),
	@RequestTypeID numeric(18,0),
	@Origin int,
	@LimitDate  datetime = NULL,
	@DevolutionDate  datetime = NULL,
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
		--[Number] = @Number,
		--[Year] = @Year,
		--[RequestDate] = @RequestDate,
		[EntID] = @EntID,
		[UserID] = @UserID,
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

		(@UserID IS NULL OR AL.UserID = @UserID) AND
		(@Read IS NULL OR AL.ReadDateTime IS NOT NULL) AND
		(@NotRead IS NULL OR AL.ReadDateTime IS NULL)

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlertSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlertSelectEx01 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [OW].[tblAlarmQueue]'
GO
CREATE TABLE [OW].[tmp_rg_xx_tblAlarmQueue]
(
[AlertQueueID] [int] NOT NULL IDENTITY(1, 1),
[LaunchDateTime] [datetime] NOT NULL,
[ProcessAlarmID] [int] NULL,
[RequestAlarmID] [int] NULL,
[Remarks] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InsertedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblAlarmQueue] ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [OW].[tmp_rg_xx_tblAlarmQueue]([AlertQueueID], [LaunchDateTime], [ProcessAlarmID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) SELECT [AlertQueueID], [LaunchDateTime], [ProcessAlarmID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn] FROM [OW].[tblAlarmQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblAlarmQueue] OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [OW].[tblAlarmQueue]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_rename N'[OW].[tmp_rg_xx_tblAlarmQueue]', N'tblAlarmQueue'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblAlarmQueue] on [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] ADD CONSTRAINT [PK_tblAlarmQueue] PRIMARY KEY CLUSTERED  ([AlertQueueID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLALARMQUEUE01] on [OW].[tblAlarmQueue]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLALARMQUEUE01] ON [OW].[tblAlarmQueue] ([LaunchDateTime])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlarmQueueDelete]'
GO

ALTER PROCEDURE [OW].AlarmQueueDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementSelect]'
GO

CREATE PROCEDURE [OW].ExceptionManagementSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.2	
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

	SELECT
		[ExceptionID],
		[Description],
		[Active],
		[Message],
		[AlertByEMail],
		[AddresseeExecutant],
		[AddresseeFlowOwner],
		[AddresseeProcessOwner],
		[AddresseeBookManager],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblExceptionManagement]
	WHERE
		(@ExceptionID IS NULL OR [ExceptionID] = @ExceptionID) AND
		(@Description IS NULL OR [Description] LIKE @Description) AND
		(@Active IS NULL OR [Active] = @Active) AND
		(@Message IS NULL OR [Message] LIKE @Message) AND
		(@AlertByEMail IS NULL OR [AlertByEMail] = @AlertByEMail) AND
		(@AddresseeExecutant IS NULL OR [AddresseeExecutant] = @AddresseeExecutant) AND
		(@AddresseeFlowOwner IS NULL OR [AddresseeFlowOwner] = @AddresseeFlowOwner) AND
		(@AddresseeProcessOwner IS NULL OR [AddresseeProcessOwner] = @AddresseeProcessOwner) AND
		(@AddresseeBookManager IS NULL OR [AddresseeBookManager] = @AddresseeBookManager) AND
		(@Remarks IS NULL OR [Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmDelete]'
GO

CREATE PROCEDURE [OW].RequestAlarmDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequestAlarm]
	WHERE
		[RequestAlarmID] = @RequestAlarmID
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
PRINT N'Creating [OW].[RequestAlarmInsert]'
GO

CREATE PROCEDURE [OW].RequestAlarmInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmID int = NULL OUTPUT,
	@RequestID numeric(18,0) = NULL,
	@Occurence tinyint,
	@OccurenceOffset int,
	@Message varchar(255),
	@AlertByEMail bit,
	@AddresseeRequestOwner bit,
	@AddresseeLastModifyUser bit,
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
	INTO [OW].[tblRequestAlarm]
	(
		[RequestID],
		[Occurence],
		[OccurenceOffset],
		[Message],
		[AlertByEMail],
		[AddresseeRequestOwner],
		[AddresseeLastModifyUser],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@RequestID,
		@Occurence,
		@OccurenceOffset,
		@Message,
		@AlertByEMail,
		@AddresseeRequestOwner,
		@AddresseeLastModifyUser,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @RequestAlarmID = SCOPE_IDENTITY()
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
PRINT N'Altering [OW].[AlertSelect]'
GO

ALTER PROCEDURE [OW].AlertSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-04-2007 18:06:06
	--Version: 1.2	
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

	SELECT
		[AlertID],
		[Message],
		[UserID],
		[AlertType],
		[ProcessID],
		[ProcessStageID],
		[RequestID],
		[ExceptionID],
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
		(@AlertType IS NULL OR [AlertType] = @AlertType) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@RequestID IS NULL OR [RequestID] = @RequestID) AND
		(@ExceptionID IS NULL OR [ExceptionID] = @ExceptionID) AND
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmAddresseeInsert]'
GO

CREATE PROCEDURE [OW].RequestAlarmAddresseeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmAddresseeID int = NULL OUTPUT,
	@RequestAlarmID int,
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
	INTO [OW].[tblRequestAlarmAddressee]
	(
		[RequestAlarmID],
		[OrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@RequestAlarmID,
		@OrganizationalUnitID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @RequestAlarmAddresseeID = SCOPE_IDENTITY()
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
PRINT N'Creating [OW].[ExceptionManagementUpdate]'
GO

CREATE PROCEDURE [OW].ExceptionManagementUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionID int,
	@Description varchar(80),
	@Active bit,
	@Message varchar(255),
	@AlertByEMail bit,
	@AddresseeExecutant bit,
	@AddresseeFlowOwner bit,
	@AddresseeProcessOwner bit,
	@AddresseeBookManager bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblExceptionManagement]
	SET
		[Description] = @Description,
		[Active] = @Active,
		[Message] = @Message,
		[AlertByEMail] = @AlertByEMail,
		[AddresseeExecutant] = @AddresseeExecutant,
		[AddresseeFlowOwner] = @AddresseeFlowOwner,
		[AddresseeProcessOwner] = @AddresseeProcessOwner,
		[AddresseeBookManager] = @AddresseeBookManager,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ExceptionID] = @ExceptionID
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
PRINT N'Altering [OW].[AlarmQueueSelectEx01]'
GO


ALTER  PROCEDURE [OW].AlarmQueueSelectEx01
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
		AQ.[RequestAlarmID],
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlertUpdate]'
GO

ALTER PROCEDURE [OW].AlertUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-04-2007 18:06:06
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertID int,
	@Message varchar(1000),
	@UserID int,
	@AlertType tinyint,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@RequestID numeric(18,0) = NULL,
	@ExceptionID int = NULL,
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
		[AlertType] = @AlertType,
		[ProcessID] = @ProcessID,
		[ProcessStageID] = @ProcessStageID,
		[RequestID] = @RequestID,
		[ExceptionID] = @ExceptionID,
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementAddresseeSelect]'
GO

CREATE PROCEDURE [OW].ExceptionManagementAddresseeSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.2	
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

	SELECT
		[ExceptionManagementAddresseeID],
		[ExceptionID],
		[OrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblExceptionManagementAddressee]
	WHERE
		(@ExceptionManagementAddresseeID IS NULL OR [ExceptionManagementAddresseeID] = @ExceptionManagementAddresseeID) AND
		(@ExceptionID IS NULL OR [ExceptionID] = @ExceptionID) AND
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmSelectEx02]'
GO



CREATE   PROCEDURE [OW].RequestAlarmSelectEx02
(
	------------------------------------------------------------------------
	--Updated: 21-03-2007 17:23:00
	--Version: 1.2	
	------------------------------------------------------------------------
	@RequestAlarmID int = NULL
)AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[RequestAlarmID],
		[RequestID],
		[Occurence],
		[OccurenceOffset],
		[Message],
		[AlertByEMail],
		[AddresseeRequestOwner],
		[AddresseeLastModifyUser],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblRequestAlarm]
	WHERE
		(@RequestAlarmID IS NULL OR [RequestAlarmID] = @RequestAlarmID) AND
		[RequestID] IS NULL

	SET @Err = @@Error
	RETURN @Err
END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlarmQueueInsert]'
GO

ALTER PROCEDURE [OW].AlarmQueueInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL OUTPUT,
	@LaunchDateTime datetime,
	@ProcessAlarmID int = NULL,
	@RequestAlarmID int = NULL,
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
		[RequestAlarmID],
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
		@RequestAlarmID,
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlarmQueueSelect]'
GO

ALTER PROCEDURE [OW].AlarmQueueSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.2	
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

	SELECT
		[AlertQueueID],
		[LaunchDateTime],
		[ProcessAlarmID],
		[RequestAlarmID],
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
		(@RequestAlarmID IS NULL OR [RequestAlarmID] = @RequestAlarmID) AND
		(@Remarks IS NULL OR [Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[usp_NewRequest]'
GO


ALTER   PROCEDURE [OW].usp_NewRequest
(
	@RequestID numeric(18,0) = NULL output,
	@Year numeric(18,0),
	@SerieID numeric(18,0) = NULL,
	@RequestDate  datetime,
	@EntID numeric(18,0) = NULL,
	@UserID int = NULL,
	@RegID numeric(18,0) = NULL,
	@Reference varchar(50) = NULL,
	@ReferenceYear numeric(18,0) = NULL,
	@MotionID numeric(18,0),
	@MotiveID numeric(18,0),
	@RequestTypeID numeric(18,0),
	@Origin int,
	@LimitDate  datetime = NULL,
	@DevolutionDate  datetime = NULL,
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
	DECLARE @CREATEDATE datetime

	SET @NUM = (SELECT ISNULL(MAX(NUMBER),0) + 1  FROM [OW].[tblRequest] WHERE [YEAR] = @Year)
	SET @CREATEDATE = GETDATE()

	INSERT
	INTO [OW].[tblRequest]
	(
		[Number],[Year], [RequestDate], [EntID], [UserID], [Reference], [ReferenceYear],
		[MotionID], [MotiveID], [RequestTypeID], [Origin], [LimitDate],
		[DevolutionDate], [State], [Observation], [Subject], 
		[CreatedByID],[CreatedDate], [ModifiedByID],[ModifiedDate],
		[SerieID], [RegId]
	)
	VALUES
	(
		@Num,
		@Year,
		@RequestDate,
		@EntID,
		@UserID,
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
		@CREATEDATE,
		@CreatedByID,
		@CREATEDATE,
		@SerieID,
		@RegID
	)

	SET @Err = @@Error

	SELECT @RequestID = SCOPE_IDENTITY()

	RETURN @Err
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlertInsert]'
GO

ALTER PROCEDURE [OW].AlertInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-04-2007 18:06:06
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertID int = NULL OUTPUT,
	@Message varchar(1000),
	@UserID int,
	@AlertType tinyint,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@RequestID numeric(18,0) = NULL,
	@ExceptionID int = NULL,
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
		[AlertType],
		[ProcessID],
		[ProcessStageID],
		[RequestID],
		[ExceptionID],
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
		@AlertType,
		@ProcessID,
		@ProcessStageID,
		@RequestID,
		@ExceptionID,
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlarmQueueUpdate]'
GO

ALTER PROCEDURE [OW].AlarmQueueUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int,
	@LaunchDateTime datetime,
	@ProcessAlarmID int = NULL,
	@RequestAlarmID int = NULL,
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
		[RequestAlarmID] = @RequestAlarmID,
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementDelete]'
GO

CREATE PROCEDURE [OW].ExceptionManagementDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblExceptionManagement]
	WHERE
		[ExceptionID] = @ExceptionID
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
PRINT N'Creating [OW].[ExceptionManagementAddresseeInsert]'
GO

CREATE PROCEDURE [OW].ExceptionManagementAddresseeInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionManagementAddresseeID int = NULL OUTPUT,
	@ExceptionID int,
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
	INTO [OW].[tblExceptionManagementAddressee]
	(
		[ExceptionID],
		[OrganizationalUnitID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ExceptionID,
		@OrganizationalUnitID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ExceptionManagementAddresseeID = SCOPE_IDENTITY()
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
PRINT N'Creating [OW].[RequestAlarmAddresseeUpdate]'
GO

CREATE PROCEDURE [OW].RequestAlarmAddresseeUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmAddresseeID int,
	@RequestAlarmID int,
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

	UPDATE [OW].[tblRequestAlarmAddressee]
	SET
		[RequestAlarmID] = @RequestAlarmID,
		[OrganizationalUnitID] = @OrganizationalUnitID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[RequestAlarmAddresseeID] = @RequestAlarmAddresseeID
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
PRINT N'Creating [OW].[RequestAlarmSelect]'
GO

CREATE PROCEDURE [OW].RequestAlarmSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.2	
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

	SELECT
		[RequestAlarmID],
		[RequestID],
		[Occurence],
		[OccurenceOffset],
		[Message],
		[AlertByEMail],
		[AddresseeRequestOwner],
		[AddresseeLastModifyUser],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblRequestAlarm]
	WHERE
		(@RequestAlarmID IS NULL OR [RequestAlarmID] = @RequestAlarmID) AND
		(@RequestID IS NULL OR [RequestID] = @RequestID) AND
		(@Occurence IS NULL OR [Occurence] = @Occurence) AND
		(@OccurenceOffset IS NULL OR [OccurenceOffset] = @OccurenceOffset) AND
		(@Message IS NULL OR [Message] LIKE @Message) AND
		(@AlertByEMail IS NULL OR [AlertByEMail] = @AlertByEMail) AND
		(@AddresseeRequestOwner IS NULL OR [AddresseeRequestOwner] = @AddresseeRequestOwner) AND
		(@AddresseeLastModifyUser IS NULL OR [AddresseeLastModifyUser] = @AddresseeLastModifyUser) AND
		(@Remarks IS NULL OR [Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR [InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR [InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR [LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)

	SET @Err = @@Error
	RETURN @Err
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmAddresseeDelete]'
GO

CREATE PROCEDURE [OW].RequestAlarmAddresseeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmAddresseeID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblRequestAlarmAddressee]
	WHERE
		[RequestAlarmAddresseeID] = @RequestAlarmAddresseeID
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
PRINT N'Creating [OW].[ExceptionManagementAddresseeDelete]'
GO

CREATE PROCEDURE [OW].ExceptionManagementAddresseeDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionManagementAddresseeID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblExceptionManagementAddressee]
	WHERE
		[ExceptionManagementAddresseeID] = @ExceptionManagementAddresseeID
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
PRINT N'Creating [OW].[AlarmQueueDeleteEx02]'
GO


CREATE  PROCEDURE [OW].AlarmQueueDeleteEx02
(
	------------------------------------------------------------------------	
	--Updated: 21-03-2007 19:00:00
	--Version: 1.0	
	------------------------------------------------------------------------
	@RequestAlarmID int = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblAlarmQueue]
	WHERE
		[RequestAlarmID] = @RequestAlarmID

	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50003,16,1)                       	
	END 	
	RETURN @Err
END
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueDeleteEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueDeleteEx02 Error on Creation'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmSelectEx01]'
GO

CREATE PROCEDURE [OW].RequestAlarmSelectEx01
(
	------------------------------------------------------------------------	
	--Updated: 21-03-2007 19:00:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@LaunchDateTime datetime = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1000
		RA.[RequestAlarmID],
		RA.[RequestID],
		RA.[Occurence],
		RA.[OccurenceOffset],
		RA.[Message],
		RA.[AlertByEMail],
		RA.[AddresseeRequestOwner],
		RA.[AddresseeLastModifyUser],
		RA.[Remarks],
		RA.[InsertedBy],
		RA.[InsertedOn],
		RA.[LastModifiedBy],
		RA.[LastModifiedOn]
	FROM [OW].[tblRequestAlarm] RA INNER JOIN [OW].[tblAlarmQueue] AQ
		ON (RA.RequestAlarmID = AQ.RequestAlarmID)
	WHERE
		(@LaunchDateTime IS NULL OR AQ.[LaunchDateTime] <= @LaunchDateTime)

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RequestAlarmSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RequestAlarmSelectEx01 Error on Creation'

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[UserSelectEx02]'
GO



ALTER    PROCEDURE [OW].UserSelectEx02
(
	------------------------------------------------------------------------	
	--Updated: 07-05-2007 19:00:00
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
				OW.tblProcessAlarmAddressee AA 
				INNER JOIN OW.tblOrganizationalUnit OU ON (AA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])			
			WHERE 
				AA.[ProcessAlarmID] = @ProcessAlarmID AND
				OU.[UserID] = USR.[UserID]		
			---------------------------------------------------------------------------------------			
			
			UNION

			-- GROUP USERS Addressee
			SELECT GU.[UserID] FROM 			
				(OW.tblProcessAlarmAddressee AA 
				INNER JOIN OW.tblOrganizationalUnit OU ON (AA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])) 			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				AA.[ProcessAlarmID] = @ProcessAlarmID AND
				GU.[UserID] = USR.[UserID] 
			---------------------------------------------------------------------------------------				

			UNION
			
			-- USERS Executant ---------------------------------------------------------------
			SELECT OU.[UserID] FROM			
				OW.tblProcessEvent PE 
				INNER JOIN OW.tblOrganizationalUnit OU ON (PE.[OrganizationalUnitID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeExecutant = 1 AND
				PE.[ProcessID] = @ProcessID AND 
				(@ProcessStageID IS NULL OR PE.[ProcessStageID] = @ProcessStageID) AND
				PE.[ProcessEventStatus] IN (1,2) AND --(New,Active)
				OU.[UserID] = USR.[UserID]			
			---------------------------------------------------------------------------------------				

			UNION

			-- GROUP USERS Executant ---------------------------------------------------------------------------------------				
			SELECT GU.[UserID] FROM			
				(OW.tblProcessEvent PE 
				INNER JOIN OW.tblOrganizationalUnit OU ON (PE.[OrganizationalUnitID] = OU.[OrganizationalUnitID]))			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeExecutant = 1 AND
				PE.[ProcessID] = @ProcessID AND
				(@ProcessStageID IS NULL OR PE.[ProcessStageID] = @ProcessStageID) AND
				PE.[ProcessEventStatus] IN (1,2) AND --(New,Active)
				GU.[UserID] = USR.[UserID]
			---------------------------------------------------------------------------------------				
			
			UNION
			
			-- USERS FLOW OWNER ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM			
				OW.tblFlow FL 
				INNER JOIN OW.tblOrganizationalUnit OU ON (FL.[FlowOwnerID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeFlowOwner = 1 AND
				FL.[FlowID] = @ProcessFlowID AND
				OU.[UserID] = USR.[UserID]			
			---------------------------------------------------------------------------------------				

			UNION

			-- GROUP USERS FLOW OWNER ---------------------------------------------------------------------------------------				
			SELECT GU.[UserID] FROM 			
				(OW.tblFlow FL 
				INNER JOIN OW.tblOrganizationalUnit OU ON (FL.[FlowOwnerID] = OU.[OrganizationalUnitID])) 			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeFlowOwner = 1 AND
				FL.[FlowID] = @ProcessFlowID AND
				GU.[UserID] = USR.[UserID]
			---------------------------------------------------------------------------------------						

			UNION
			
			-- USERS PROCESS OWNER ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM 			
				OW.tblProcess PR 
				INNER JOIN OW.tblOrganizationalUnit OU ON (PR.[ProcessOwnerID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeProcessOwner = 1 AND
				PR.[ProcessID] = @ProcessID AND
				OU.[UserID] = USR.[UserID]			
			---------------------------------------------------------------------------------------				

			UNION

			-- GROUP USERS PROCESS OWNER ---------------------------------------------------------------------------------------				
			SELECT GU.[UserID] FROM 			
				(OW.tblProcess PR 
				INNER JOIN OW.tblOrganizationalUnit OU ON (PR.[ProcessOwnerID] = OU.[OrganizationalUnitID]))			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeProcessOwner = 1 AND
				PR.[ProcessID] = @ProcessID AND
				GU.[UserID] = USR.[UserID]
			---------------------------------------------------------------------------------------				

		)--ENDEXISTS

	SET @Err = @@Error
	RETURN @Err

END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectEx02 Error on Creation'




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[UserSelectEx04]'
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE  PROCEDURE [OW].UserSelectEx04
(
	------------------------------------------------------------------------	
	--Updated: 07-05-2007 19:00:00
	--Version: 1.0	
	--Description: Select all Alarm Destination Users
	------------------------------------------------------------------------
	@RequestAlarmID int = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @RequestID INT
	DECLARE @AddresseeRequestOwner BIT
	DECLARE @AddresseeLastModifyUser BIT
	
	-- Get Vars -------------------------------------------------
	SELECT 
		@RequestID = RequestID, 
		@AddresseeRequestOwner = AddresseeRequestOwner,
		@AddresseeLastModifyUser = AddresseeLastModifyUser
	FROM OW.tblRequestAlarm	
	WHERE 	
		RequestAlarmID = @RequestAlarmID
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
			SELECT OU.[UserID] 
			FROM 
				OW.tblRequestAlarmAddressee AA 
				INNER JOIN OW.tblOrganizationalUnit OU ON (AA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])			
			WHERE 
				AA.[RequestAlarmID] = @RequestAlarmID AND
				OU.[UserID] = USR.[UserID]		
			---------------------------------------------------------------------------------------			

			UNION
			
			-- GROUP USERS Addressee ---------------------------------------------------------------
			SELECT GU.[UserID] 
			FROM 			
				(OW.tblRequestAlarmAddressee AA 
				INNER JOIN OW.tblOrganizationalUnit OU ON (AA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])) 
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				AA.[RequestAlarmID] = @RequestAlarmID AND
				GU.[UserID] = USR.[UserID]
			--------------------------------------------------------------------------------------- 
			
			UNION
			
			-- REQUEST OWNER Only if is User (Origin = 1) ----------------------------------------------------------
			SELECT RQ.[UserID] 
			FROM			
				OW.tblRequest RQ 
			WHERE 
				@AddresseeRequestOwner = 1 AND
				RQ.RequestID = @RequestID AND
				RQ.Origin = 1 AND
				RQ.[UserID] = USR.[UserID]
			---------------------------------------------------------------------------------------					
			
			UNION
			
			-- REQUEST LAST MODIFY USER ---------------------------------------------------------------
			SELECT RQ.[ModifiedByID] 
			FROM			
				OW.tblRequest RQ 
			WHERE 
				@AddresseeLastModifyUser = 1 AND
				RQ.RequestID = @RequestID  AND
				RQ.[ModifiedByID] = USR.[UserID]
			---------------------------------------------------------------------------------------
		
		)--ENDEXISTS

	SET @Err = @@Error
	RETURN @Err

END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[UserSelectEx05]'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [OW].UserSelectEx05
(
	------------------------------------------------------------------------	
	--Updated: 07-05-2007 19:00:00
	--Version: 1.0
	--Description: Select all Alert Destination Users for Exceptions
	------------------------------------------------------------------------
	@ExceptionID int = NULL,
	@FlowID INT = NULL,
	@ProcessID INT = NULL,
	@RegistryID numeric (18, 0) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int
	DECLARE @AddresseeFlowOwner BIT
	DECLARE @AddresseeProcessOwner BIT
	DECLARE @AddresseeBookManager BIT
	
	DECLARE @BookID numeric (18, 0)
	SET @BookID = NULL
	
	-- Get Vars -------------------------------------------------
	SELECT 
		@AddresseeFlowOwner = AddresseeFlowOwner,
		@AddresseeProcessOwner = AddresseeProcessOwner,
		@AddresseeBookManager = AddresseeBookManager
	FROM OW.tblExceptionManagement	
	WHERE 	
		ExceptionID = @ExceptionID
	
	IF @RegistryID IS NOT NULL
	BEGIN
		SELECT 
			@BookID = BookID
		FROM OW.tblRegistry
		WHERE 
			RegID = @RegistryID
	END
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
				OW.tblExceptionManagementAddressee EMA 
				INNER JOIN OW.tblOrganizationalUnit OU ON (EMA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])			
			WHERE 
				EMA.[ExceptionID] = @ExceptionID AND
				OU.[UserID] = USR.[UserID]		
			--------------------------------------------------------------------------------------- 
			
			UNION

			-- GROUP USERS Addressee ---------------------------------------------------------------------
			SELECT GU.[UserID] FROM 			
				(OW.tblExceptionManagementAddressee EMA 
				INNER JOIN OW.tblOrganizationalUnit OU ON (EMA.[OrganizationalUnitID] = OU.[OrganizationalUnitID])) 
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				EMA.[ExceptionID] = @ExceptionID AND
				GU.[UserID] = USR.[UserID] 
			--------------------------------------------------------------------------------------- 
			
			UNION
						
			-- USERS FLOW OWNER ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM			
				OW.tblFlow FL 
				INNER JOIN OW.tblOrganizationalUnit OU ON (FL.[FlowOwnerID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeFlowOwner = 1 AND
				FL.[FlowID] = @FlowID AND
				OU.[UserID] = USR.[UserID]			
			--------------------------------------------------------------------------------------- 			
			
			UNION

			-- GROUP USERS FLOW OWNER
			SELECT GU.[UserID] FROM 			
				(OW.tblFlow FL 
				INNER JOIN OW.tblOrganizationalUnit OU ON (FL.[FlowOwnerID] = OU.[OrganizationalUnitID])) 			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeFlowOwner = 1 AND
				FL.[FlowID] = @FlowID AND
				GU.[UserID] = USR.[UserID]
			--------------------------------------------------------------------------------------- 
			
			UNION
			
			-- USERS PROCESS OWNER ---------------------------------------------------------------------
			SELECT OU.[UserID] FROM 			
				OW.tblProcess PR 
				INNER JOIN OW.tblOrganizationalUnit OU ON (PR.[ProcessOwnerID] = OU.[OrganizationalUnitID])			
			WHERE 
				@AddresseeProcessOwner = 1 AND
				PR.[ProcessID] = @ProcessID AND
				OU.[UserID] = USR.[UserID]			
			--------------------------------------------------------------------------------------- 

			UNION

			-- GROUP USERS PROCESS OWNER ---------------------------------------------------------------------
			SELECT GU.[UserID] FROM 			
				(OW.tblProcess PR 
				INNER JOIN OW.tblOrganizationalUnit OU ON (PR.[ProcessOwnerID] = OU.[OrganizationalUnitID]))			
				INNER JOIN OW.tblGroupsUsers GU ON (GU.[GroupID] = OU.[GROUPID])			
			WHERE 
				@AddresseeProcessOwner = 1 AND
				PR.[ProcessID] = @ProcessID AND
				GU.[UserID] = USR.[UserID]
			--------------------------------------------------------------------------------------- 

			UNION
			
			-- USERS BOOK MANAGER ---------------------------------------------------------------------
			SELECT A.[UserID] 
			FROM			
				OW.tblAccess A 
			WHERE 
				@AddresseeBookManager = 1 AND
				A.ObjectID = @BookID AND
				A.ObjectTypeID = 2 AND
				A.ObjectParentID = 1 AND
				A.AccessType = 7 AND
				A.ObjectType = 1 AND
				A.[UserID] = USR.[UserID]
			--------------------------------------------------------------------------------------- 

			UNION

			-- GROUP USERS BOOK MANAGER ---------------------------------------------------------------------
			SELECT GU.[UserID] FROM 			
				(OW.tblAccess A 
				INNER JOIN OW.tblGroupsUsers GU ON (A.UserID = GU.GroupID AND A.ObjectType = 2))
			WHERE 
				@AddresseeBookManager = 1 AND
				A.ObjectID = @BookID AND
				A.ObjectTypeID = 2 AND
				A.ObjectParentID = 1 AND
				A.AccessType = 7 AND
				A.ObjectType = 2 AND
				GU.[UserID] = USR.[UserID]
			--------------------------------------------------------------------------------------- 
						
		)--ENDEXISTS

	SET @Err = @@Error
	RETURN @Err

END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectEx05 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectEx05 Error on Creation'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[fnFisicalInsertById]'
GO
SET ANSI_NULLS OFF
GO


ALTER    FUNCTION OW.fnFisicalInsertById(@IdFisicalInsert int)
RETURNS @Result TABLE (IdFisicalInsert int, Expanded bit, Selected bit, ChildOrder int)
AS
BEGIN 
	DECLARE @_Id int, @_IdParent int, @_ChildOrder int
	
	DECLARE cTOC CURSOR FOR
		SELECT IdFisicalInsert
		FROM [OW].[tblArchFisicalInsert]
		WHERE IdFisicalInsert = @IdFisicalInsert
	FOR READ ONLY
	
	OPEN cTOC
	
	FETCH NEXT FROM cTOC
	INTO @_Id
	
	SET @_ChildOrder = 0

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	   SET @_IdParent = @_Id
	   SET @_ChildOrder = @_ChildOrder + 1
	   INSERT INTO @Result VALUES(@_IdParent, 0, 1, @_ChildOrder)
	   WHILE (@_IdParent > 1)
	   BEGIN
		SELECT @_IdParent = IdParentFI
		FROM [OW].[tblArchFisicalInsert]
		WHERE IdFisicalInsert = @_IdParent
		
		SET @_ChildOrder = @_ChildOrder + 1
		INSERT INTO @Result VALUES(@_IdParent, 1, 0, @_ChildOrder)
	   END
	   FETCH NEXT FROM cTOC
	   INTO @_Id
	END
	
	CLOSE cTOC
	DEALLOCATE cTOC	
	RETURN
END






GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ArchFisicalInsertSelectEx02]'
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


ALTER     PROCEDURE [OW].ArchFisicalInsertSelectEx02
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
		fi.LastModifiedOn,
		fn.ChildOrder
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
	ORDER BY 
		fn.ChildOrder DESC

	SET @Err = @@Error
	RETURN @Err
END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ArchFisicalInsertSelectEx03]'
GO




















CREATE     PROCEDURE [OW].ArchFisicalInsertSelectEx03
(
	@IdFisicalInsert int = NULL,
	@IdParentFI int = NULL,
	@IdSpace int = NULL
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
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS 'Abreviation', 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS 'Name', 
		s.CodeName
	FROM         
		OW.tblArchFisicalInsert fi
		INNER JOIN OW.tblArchInsertVsForm ivf ON  fi.IdFisicalInsert = ivf.IdFisicalInsert 
		INNER JOIN OW.tblArchFieldsVsSpace fvs ON ivf.IdSpace = fvs.IdSpace AND ivf.IdField = fvs.IdField 
		INNER JOIN OW.tblArchSpace s ON fvs.IdSpace = s.IdSpace
	WHERE		
		(@IdFisicalInsert IS NULL OR fi.[IdFisicalInsert] = @IdFisicalInsert) AND
		(@IdParentFI IS NULL OR fi.[IdParentFI] = @IdParentFI) AND
		(@IdSpace IS NULL OR s.[IdSpace] = @IdSpace)

	SET @Err = @@Error
	RETURN @Err
END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[AlarmQueueSelectEx02]'
GO


CREATE  PROCEDURE [OW].AlarmQueueSelectEx02
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

	SELECT
		AQ.[AlertQueueID],
		AQ.[LaunchDateTime],
		AQ.[ProcessAlarmID],
		AQ.[RequestAlarmID],
		AQ.[Remarks],
		AQ.[InsertedBy],
		AQ.[InsertedOn],
		AQ.[LastModifiedBy],
		AQ.[LastModifiedOn]
	FROM [OW].[tblAlarmQueue] AQ INNER JOIN [OW].[tblRequestAlarm] RA 
		ON (AQ.RequestAlarmID = RA.RequestAlarmID)
	WHERE
		(@AlertQueueID IS NULL OR AQ.[AlertQueueID] = @AlertQueueID) AND
		(@LaunchDateTime IS NULL OR AQ.[LaunchDateTime] <= @LaunchDateTime) AND
		(@RequestAlarmID IS NULL OR AQ.[RequestAlarmID] = @RequestAlarmID) AND
		(@Remarks IS NULL OR AQ.[Remarks] LIKE @Remarks) AND
		(@InsertedBy IS NULL OR AQ.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR AQ.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR AQ.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR AQ.[LastModifiedOn] = @LastModifiedOn) AND
		(@RequestID IS NULL OR RA.[RequestID] = @RequestID)

	SET @Err = @@Error
	RETURN @Err
END

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].AlarmQueueSelectEx02 Error on Creation'


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[usp_NewDistributionAutomaticToTemporary]'
GO

ALTER  PROCEDURE OW.usp_NewDistributionAutomaticToTemporary

	@bookID numeric = null,
	@classificationID numeric = null,
	@documentTypeID numeric = null,
	@guid nchar(32),
	@userID numeric

AS


DECLARE @DISTRIBUTION_OTHER_WAYS NUMERIC
SET @DISTRIBUTION_OTHER_WAYS = 2

DECLARE @SQLCommand nvarchar(2000)
SET @SQLCommand = ''

DECLARE @WhereClause nvarchar(1000)
SET @WhereClause = ''

DECLARE @DISTRIBUTION_EXISTS NUMERIC
SET @DISTRIBUTION_EXISTS = 0

DECLARE @DISTRIBUTION_LEVEL NUMERIC
SET @DISTRIBUTION_LEVEL = 0


--Verify number of parameters
IF @bookID IS NOT NULL
	SET @DISTRIBUTION_LEVEL = @DISTRIBUTION_LEVEL + 1

IF @classificationID IS NOT NULL
	SET @DISTRIBUTION_LEVEL = @DISTRIBUTION_LEVEL + 1

IF @documentTypeID IS NOT NULL
	SET @DISTRIBUTION_LEVEL = @DISTRIBUTION_LEVEL + 1


SET XACT_ABORT ON

BEGIN TRANSACTION


/********************* BEGIN LEVEL 1 *********************/
IF @DISTRIBUTION_LEVEL = 1
BEGIN

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

END
/********************* END LEVEL 1 *********************/


/********************* BEGIN LEVEL 2 *********************/
IF @DISTRIBUTION_LEVEL = 2
BEGIN

	/***************** BEGIN Verify Level 2 (book and classification) ***********************/
	-- Get distributions for book and classification
	IF @bookID IS NOT NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NULL
	BEGIN
	
		-- Verify if exists distribution for book and classification
		SELECT @DISTRIBUTION_EXISTS = 1 
		FROM OW.tblDistributionAutomatic
		WHERE 
			FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL

		-- if exists distribution set where clause else verify next level
		IF @DISTRIBUTION_EXISTS = 1
		BEGIN -- BEGIN SET WhereClause Level 2
	
			SET @WhereClause = '
				(FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL)'
	
		END -- END SET WhereClause Level 2
		ELSE
		BEGIN -- BEGIN Verify Level 1

			-- Verify if exists distribution for book or classification
			SELECT @DISTRIBUTION_EXISTS = 1 
			FROM OW.tblDistributionAutomatic
			WHERE 
				(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
				(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL)
			
			-- if exists distribution set where clause else do nothing				
			IF @DISTRIBUTION_EXISTS = 1
			BEGIN -- BEGIN SET WhereClause Level 1
				
				SET @WhereClause = '
					(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
					(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL)'

			END -- END SET WhereClause Level 1

		END -- END Verify Level 1

	END
	/***************** END Verify Level 2 (book and classification) ***********************/

	
	/***************** BEGIN Verify Level 2 (book and documenttype) ***********************/
	-- Get distributions for book and documenttype
	IF @bookID IS NOT NULL AND @classificationID IS NULL AND @documentTypeID IS NOT NULL
	BEGIN -- BEGIN Verify Level 2 (book and documenttype)
	
		-- Verify if exists distribution for book and documenttype
		SELECT @DISTRIBUTION_EXISTS = 1 
		FROM OW.tblDistributionAutomatic
		WHERE 
			FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID

		-- if exists distribution set where clause else verify next level
		IF @DISTRIBUTION_EXISTS = 1
		BEGIN -- BEGIN SET WhereClause Level 2
	
			SET @WhereClause = '
				(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)'
	
		END -- END SET WhereClause Level 2
		ELSE
		BEGIN -- BEGIN Verify Level 1

			-- Verify if exists distribution for book or documenttype
			SELECT @DISTRIBUTION_EXISTS = 1 
			FROM OW.tblDistributionAutomatic
			WHERE 
				(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
				(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)
			
			-- if exists distribution set where clause else do nothing				
			IF @DISTRIBUTION_EXISTS = 1
			BEGIN -- BEGIN SET WhereClause Level 1

				SET @WhereClause = '
					(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
					(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)'

			END -- END SET WhereClause Level 1

		END -- END Verify Level 1

	END
	/***************** END Verify Level 2 (book and documenttype) ***********************/
	

	/***************** BEGIN Verify Level 2 (classification and documenttype) ***********************/
	-- Get distributions for classification and documenttype
	IF @bookID IS NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NOT NULL
	BEGIN -- BEGIN Verify Level 2 (classification and documenttype)
	
		-- Verify if exists distribution for classification and documenttype
		SELECT @DISTRIBUTION_EXISTS = 1 
		FROM OW.tblDistributionAutomatic
		WHERE 
			FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID

		-- if exists distribution set where clause else verify next level
		IF @DISTRIBUTION_EXISTS = 1
		BEGIN -- BEGIN SET WhereClause Level 2
	
			SET @WhereClause = '
				(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID)'
	
		END -- END SET WhereClause Level 2
		ELSE
		BEGIN -- BEGIN Verify Level 1

			-- Verify if exists distribution for classification or documenttype
			SELECT @DISTRIBUTION_EXISTS = 1 
			FROM OW.tblDistributionAutomatic
			WHERE 
				(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
				(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)
			
			-- if exists distribution set where clause else do nothing				
			IF @DISTRIBUTION_EXISTS = 1
			BEGIN -- BEGIN SET WhereClause Level 1

				SET @WhereClause = '
					(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
					(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)'

			END -- END SET WhereClause Level 1

		END -- END Verify Level 1

	END
	/***************** END Verify Level 2 (classification and documenttype) ***********************/

END
/********************* END LEVEL 2 *********************/


/********************* BEGIN LEVEL 3 *********************/
IF @DISTRIBUTION_LEVEL = 3
BEGIN

	-- Get distributions for book and classification and documenttype
	IF @bookID IS NOT NULL AND @classificationID IS NOT NULL AND @documentTypeID IS NOT NULL
	BEGIN -- BEGIN Verify Level 3
	
		-- Verify if exists distribution for book and classification and doctype 
		SELECT @DISTRIBUTION_EXISTS = 1 
		FROM OW.tblDistributionAutomatic
		WHERE 
			FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID
	
		-- if exists distribution set where clause else verify next level
		IF @DISTRIBUTION_EXISTS = 1
		BEGIN -- BEGIN SET WhereClause Level 3
	
			SET @WhereClause = '
				(FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID)'
	
		END -- END SET WhereClause Level 3
		ELSE
		BEGIN -- BEGIN Verify Level 2
	
			-- Verify if exists distribution for book and classification or book and doctype or classification and doctype
			SELECT @DISTRIBUTION_EXISTS = 1 
			FROM OW.tblDistributionAutomatic
			WHERE 
				(FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
				(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID) OR
				(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID)
	
			-- if exists distribution set where clause else verify next level
			IF @DISTRIBUTION_EXISTS = 1
			BEGIN -- BEGIN SET WhereClause Level 2
	
				SET @WhereClause = '
					(FieldBookID = @bookID AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
					(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID) OR
					(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID = @documentTypeID)'
	
			END -- END SET WhereClause Level 2
			ELSE
			BEGIN -- BEGIN Verify Level 1
	
				-- Verify if exists distribution for book or classification or doctype
				SELECT @DISTRIBUTION_EXISTS = 1 
				FROM OW.tblDistributionAutomatic
				WHERE 
					(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
					(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
					(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)
				
				-- if exists distribution set where clause else do nothing				
				IF @DISTRIBUTION_EXISTS = 1
				BEGIN -- BEGIN SET WhereClause Level 1
					SET @WhereClause = '
						(FieldBookID = @bookID AND FieldClassID IS NULL AND FieldDocTypeID IS NULL) OR
						(FieldBookID IS NULL AND FieldClassID = @classificationID AND FieldDocTypeID IS NULL) OR
						(FieldBookID IS NULL AND FieldClassID IS NULL AND FieldDocTypeID = @documentTypeID)'
				END -- END SET WhereClause Level 1
	
			END -- END Verify Level 1
	
		END -- BEGIN Verify Level 2
	
	END -- BEGIN Verify Level 3
	
END
/********************* END LEVEL 3 *********************/


-- Buils query string
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


--If WhereClause exists execute command
IF @WhereClause <> ''
BEGIN

	SET @SQLCommand = @SQLCommand + @WhereClause
	EXEC sp_ExecuteSQL @SQLCommand, 
		N'@bookID numeric, @classificationID numeric, @documentTypeID numeric, @guid nchar(32), @userID numeric',
		@bookID, @classificationID, @documentTypeID, @guid, @userID

END


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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping [OW].[SetRegistryHierarchySuperiorsAccess]'
GO
DROP PROCEDURE [OW].[SetRegistryHierarchySuperiorsAccess]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ArchFisicalInsertUpdateEx01]'
GO



CREATE  PROCEDURE [OW].ArchFisicalInsertUpdateEx01
(
	------------------------------------------------------------------------
	--Updated: 27-01-2006 11:02:37
	--Version: 1.1	
	------------------------------------------------------------------------
	@IdFisicalInsert int,
	@IdParentFI int,
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[SetRegistryHierarchyAccessForIntervening]'
GO




CREATE           PROCEDURE [OW].SetRegistryHierarchyAccessForIntervening
(
	@RegistryID int,
	@ProcessID int,
	@UserID int
)
AS
BEGIN

	DECLARE @PrimaryGroupID int	
	DECLARE @HierarchyID int
	DECLARE @HierarchyIDs varchar(4000)
	DECLARE @RegistryExists tinyint
	DECLARE @HasAccess tinyint
	DECLARE @HasHierarchyGroupAccess tinyint
	DECLARE @HasHierarchySuperiorsAccess tinyint

	SET @HierarchyIDs = ''
	SET @RegistryExists = 0
	SET @HasAccess = 0
	SET @HasHierarchyGroupAccess = 0
	SET @HasHierarchySuperiorsAccess = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se o registo existe na tabela registo e se tem acessos hierarquicos definidos pelo livro
	-- ----------------------------------------------------------------------------------------------------
	SELECT @RegistryExists = 1 
	FROM OW.tblRegistry r INNER JOIN OW.tblBooks b ON r.BookID = b.BookID
	WHERE r.RegID = @RegistryID AND b.Hierarchical = 1
	
	-- ----------------------------------------------------------------------------------------------------
	-- Se nao existe na tabela registo verifica no historico
	-- ----------------------------------------------------------------------------------------------------
	IF @RegistryExists = 0
	BEGIN
		SELECT @RegistryExists = 1 
		FROM OW.tblRegistryHist r INNER JOIN OW.tblBooks b ON r.BookID = b.BookID
		WHERE r.RegID = @RegistryID AND b.Hierarchical = 1
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Se o registo existe e tem acesso hierarquico definido
	-- ----------------------------------------------------------------------------------------------------
	IF @RegistryExists = 1
	BEGIN
	
		-- ----------------------------------------------------------------------------------------------------
		-- Dados do grupo hierarquico do Interveniente
		-- ----------------------------------------------------------------------------------------------------
		SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
		-- ----------------------------------------------------------------------------------------------------
		-- Verifica se existem acessos definidos no processo
		-- para o grupo hierarquico do interveniente e para os superiores hierarquicos
		-- ----------------------------------------------------------------------------------------------------
		IF @PrimaryGroupID IS NOT NULL AND @ProcessID IS NOT NULL
		BEGIN
	
			SELECT @HasAccess = 1 FROM OW.tblProcessAccess WHERE ProcessID = @ProcessID AND AccessObject = 16 AND ProcessDataAccess = 4				
			
			SELECT @HasHierarchyGroupAccess = 1 FROM OW.tblProcessAccess WHERE ProcessID = @ProcessID AND AccessObject = 32 AND ProcessDataAccess = 4
	
			SELECT @HasHierarchySuperiorsAccess = 1 FROM OW.tblProcessAccess WHERE ProcessID = @ProcessID AND AccessObject = 64 AND ProcessDataAccess = 4
	
		END	
	
		-- ----------------------------------------------------------------------------------------------------
		-- Dados dos grupos hierarquicos do grupo primario do Interveniente
		-- ----------------------------------------------------------------------------------------------------
		IF @PrimaryGroupID IS NOT NULL AND @HasHierarchySuperiorsAccess = 1
		BEGIN	
	
			SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @PrimaryGroupID
		
			WHILE @HierarchyID IS NOT NULL
			BEGIN
	
				SET @HierarchyIDs = @HierarchyIDs + CAST(@HierarchyID AS varchar) + ','
	
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
	
			END 	
	
		END

		-- ----------------------------------------------------------------------------------------------------
		-- Insere acessos para o registo para os que nao existem ainda
		-- ----------------------------------------------------------------------------------------------------
		INSERT OW.tblAccessReg 
			SELECT TAUX.UserID, TAUX.ObjectID, TAUX.ObjectType, TAUX.HierarchicalUserID 
			FROM OW.tblAccessReg  AR 
			RIGHT OUTER JOIN 
				(
					-- Interveniente
					SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
					WHERE UserID = @UserID AND @HasAccess = 1
					UNION
					-- Utilizadores que dependem hierarquicamente do grupo hierarquico do Interveniente
					SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
					WHERE PrimaryGroupID = @PrimaryGroupID AND @HasHierarchyGroupAccess = 1
					UNION
					-- Superior hierarquico do Interveniente						
					SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
					WHERE PrimaryGroupID IN (SELECT st.Item FROM OW.StringToTable(@HierarchyIDs,',') st) AND GroupHead = 1 AND @HasHierarchySuperiorsAccess = 1
				) TAUX
			ON (AR.UserID = TAUX.UserID AND AR.ObjectID = TAUX.ObjectID AND AR.ObjectType = TAUX.ObjectType)
			WHERE
				AR.UserID IS NULL
	
	END

END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[SetRegistryHierarchyAccessForOriginator]'
GO




CREATE           PROCEDURE [OW].SetRegistryHierarchyAccessForOriginator
(
	@RegistryID int,
	@UserID int
)
AS
BEGIN

	DECLARE @PrimaryGroupID int	
	DECLARE @HierarchyID int
	DECLARE @HierarchyIDs varchar(4000)
	DECLARE @RegistryExists tinyint
	
	SET @HierarchyIDs = ''
	SET @RegistryExists = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se o registo existe na tabela registo e se tem acessos hierarquicos definidos pelo livro
	-- ----------------------------------------------------------------------------------------------------
	SELECT @RegistryExists = 1 
	FROM OW.tblRegistry r INNER JOIN OW.tblBooks b ON r.BookID = b.BookID
	WHERE r.RegID = @RegistryID AND b.Hierarchical = 1
	
	-- ----------------------------------------------------------------------------------------------------
	-- Se nao existe na tabela registo verifica no historico
	-- ----------------------------------------------------------------------------------------------------
	IF @RegistryExists = 0
	BEGIN
		SELECT @RegistryExists = 1 
		FROM OW.tblRegistryHist r INNER JOIN OW.tblBooks b ON r.BookID = b.BookID
		WHERE r.RegID = @RegistryID AND b.Hierarchical = 1
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Se o registo existe e tem acesso hierarquico definido
	-- ----------------------------------------------------------------------------------------------------
	IF @RegistryExists = 1
	BEGIN
	
		-- ----------------------------------------------------------------------------------------------------
		-- Dados do grupo hierarquico do Originador
		-- ----------------------------------------------------------------------------------------------------
		SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
		-- ----------------------------------------------------------------------------------------------------
		-- Dados dos grupos hierarquicos do grupo primario do Originador
		-- ----------------------------------------------------------------------------------------------------
		IF @PrimaryGroupID IS NOT NULL
		BEGIN	
	
			SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @PrimaryGroupID
		
			WHILE @HierarchyID IS NOT NULL
			BEGIN
	
				SET @HierarchyIDs = @HierarchyIDs + CAST(@HierarchyID AS varchar) + ','
	
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
	
			END 	

		END
	
		-- ----------------------------------------------------------------------------------------------------
		-- Insere acessos para o registo para os que nao existem ainda
		-- ----------------------------------------------------------------------------------------------------
		INSERT OW.tblAccessReg 
			SELECT TAUX.UserID, TAUX.ObjectID, TAUX.ObjectType, TAUX.HierarchicalUserID 
			FROM OW.tblAccessReg  AR 
			RIGHT OUTER JOIN 
				(
					-- Originador
					SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
					WHERE UserID = @UserID
					UNION
					-- Utilizadores que dependem hierarquicamente do grupo hierarquico do Originador
					SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
					WHERE PrimaryGroupID = @PrimaryGroupID
					UNION
					-- Superiores hierarquicos do Originador						
					SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
					WHERE PrimaryGroupID IN (SELECT st.Item FROM OW.StringToTable(@HierarchyIDs,',') st) AND GroupHead = 1
				) TAUX
			ON (AR.UserID = TAUX.UserID AND AR.ObjectID = TAUX.ObjectID AND AR.ObjectType = TAUX.ObjectType)
			WHERE
				AR.UserID IS NULL

	
	END

END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlarmQueueSelectPaging]'
GO

ALTER PROCEDURE [OW].AlarmQueueSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@AlertQueueID int = NULL,
	@LaunchDateTime datetime = NULL,
	@ProcessAlarmID int = NULL,
	@RequestAlarmID int = NULL,
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
	IF(@RequestAlarmID IS NOT NULL) SET @WHERE = @WHERE + '([RequestAlarmID] = @RequestAlarmID) AND '
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
		@RequestAlarmID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@AlertQueueID, 
		@LaunchDateTime, 
		@ProcessAlarmID, 
		@RequestAlarmID, 
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
		[RequestAlarmID], 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[AlertSelectPaging]'
GO

ALTER PROCEDURE [OW].AlertSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 02-04-2007 18:06:06
	--Version: 1.1	
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
	IF(@AlertType IS NOT NULL) SET @WHERE = @WHERE + '([AlertType] = @AlertType) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@RequestID IS NOT NULL) SET @WHERE = @WHERE + '([RequestID] = @RequestID) AND '
	IF(@ExceptionID IS NOT NULL) SET @WHERE = @WHERE + '([ExceptionID] = @ExceptionID) AND '
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
		[AlertType], 
		[ProcessID], 
		[ProcessStageID], 
		[RequestID], 
		[ExceptionID], 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementAddresseeSelectPaging]'
GO

CREATE PROCEDURE [OW].ExceptionManagementAddresseeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@ExceptionManagementAddresseeID int = NULL,
	@ExceptionID int = NULL,
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
	
	IF(@ExceptionManagementAddresseeID IS NOT NULL) SET @WHERE = @WHERE + '([ExceptionManagementAddresseeID] = @ExceptionManagementAddresseeID) AND '
	IF(@ExceptionID IS NOT NULL) SET @WHERE = @WHERE + '([ExceptionID] = @ExceptionID) AND '
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
	SELECT @RowCount = COUNT(ExceptionManagementAddresseeID) 
	FROM [OW].[tblExceptionManagementAddressee]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@ExceptionManagementAddresseeID int, 
		@ExceptionID int, 
		@OrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ExceptionManagementAddresseeID, 
		@ExceptionID, 
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
	WHERE ExceptionManagementAddresseeID IN (
		SELECT TOP ' + @SizeString + ' ExceptionManagementAddresseeID
			FROM [OW].[tblExceptionManagementAddressee]
			WHERE ExceptionManagementAddresseeID NOT IN (
				SELECT TOP ' + @PrevString + ' ExceptionManagementAddresseeID 
				FROM [OW].[tblExceptionManagementAddressee]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ExceptionManagementAddresseeID], 
		[ExceptionID], 
		[OrganizationalUnitID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblExceptionManagementAddressee]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ExceptionManagementSelectPaging]'
GO

CREATE PROCEDURE [OW].ExceptionManagementSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
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
	
	IF(@ExceptionID IS NOT NULL) SET @WHERE = @WHERE + '([ExceptionID] = @ExceptionID) AND '
	IF(@Description IS NOT NULL) SET @WHERE = @WHERE + '([Description] LIKE @Description) AND '
	IF(@Active IS NOT NULL) SET @WHERE = @WHERE + '([Active] = @Active) AND '
	IF(@Message IS NOT NULL) SET @WHERE = @WHERE + '([Message] LIKE @Message) AND '
	IF(@AlertByEMail IS NOT NULL) SET @WHERE = @WHERE + '([AlertByEMail] = @AlertByEMail) AND '
	IF(@AddresseeExecutant IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeExecutant] = @AddresseeExecutant) AND '
	IF(@AddresseeFlowOwner IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeFlowOwner] = @AddresseeFlowOwner) AND '
	IF(@AddresseeProcessOwner IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeProcessOwner] = @AddresseeProcessOwner) AND '
	IF(@AddresseeBookManager IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeBookManager] = @AddresseeBookManager) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ExceptionID) 
	FROM [OW].[tblExceptionManagement]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ExceptionID IN (
		SELECT TOP ' + @SizeString + ' ExceptionID
			FROM [OW].[tblExceptionManagement]
			WHERE ExceptionID NOT IN (
				SELECT TOP ' + @PrevString + ' ExceptionID 
				FROM [OW].[tblExceptionManagement]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ExceptionID], 
		[Description], 
		[Active], 
		[Message], 
		[AlertByEMail], 
		[AddresseeExecutant], 
		[AddresseeFlowOwner], 
		[AddresseeProcessOwner], 
		[AddresseeBookManager], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblExceptionManagement]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmAddresseeSelectPaging]'
GO

CREATE PROCEDURE [OW].RequestAlarmAddresseeSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
	------------------------------------------------------------------------
	@RequestAlarmAddresseeID int = NULL,
	@RequestAlarmID int = NULL,
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
	
	IF(@RequestAlarmAddresseeID IS NOT NULL) SET @WHERE = @WHERE + '([RequestAlarmAddresseeID] = @RequestAlarmAddresseeID) AND '
	IF(@RequestAlarmID IS NOT NULL) SET @WHERE = @WHERE + '([RequestAlarmID] = @RequestAlarmID) AND '
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
	SELECT @RowCount = COUNT(RequestAlarmAddresseeID) 
	FROM [OW].[tblRequestAlarmAddressee]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@RequestAlarmAddresseeID int, 
		@RequestAlarmID int, 
		@OrganizationalUnitID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@RequestAlarmAddresseeID, 
		@RequestAlarmID, 
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
	WHERE RequestAlarmAddresseeID IN (
		SELECT TOP ' + @SizeString + ' RequestAlarmAddresseeID
			FROM [OW].[tblRequestAlarmAddressee]
			WHERE RequestAlarmAddresseeID NOT IN (
				SELECT TOP ' + @PrevString + ' RequestAlarmAddresseeID 
				FROM [OW].[tblRequestAlarmAddressee]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[RequestAlarmAddresseeID], 
		[RequestAlarmID], 
		[OrganizationalUnitID], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblRequestAlarmAddressee]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RequestAlarmSelectPaging]'
GO

CREATE PROCEDURE [OW].RequestAlarmSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 21-03-2007 17:23:00
	--Version: 1.1	
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
	
	IF(@RequestAlarmID IS NOT NULL) SET @WHERE = @WHERE + '([RequestAlarmID] = @RequestAlarmID) AND '
	IF(@RequestID IS NOT NULL) SET @WHERE = @WHERE + '([RequestID] = @RequestID) AND '
	IF(@Occurence IS NOT NULL) SET @WHERE = @WHERE + '([Occurence] = @Occurence) AND '
	IF(@OccurenceOffset IS NOT NULL) SET @WHERE = @WHERE + '([OccurenceOffset] = @OccurenceOffset) AND '
	IF(@Message IS NOT NULL) SET @WHERE = @WHERE + '([Message] LIKE @Message) AND '
	IF(@AlertByEMail IS NOT NULL) SET @WHERE = @WHERE + '([AlertByEMail] = @AlertByEMail) AND '
	IF(@AddresseeRequestOwner IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeRequestOwner] = @AddresseeRequestOwner) AND '
	IF(@AddresseeLastModifyUser IS NOT NULL) SET @WHERE = @WHERE + '([AddresseeLastModifyUser] = @AddresseeLastModifyUser) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(RequestAlarmID) 
	FROM [OW].[tblRequestAlarm]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE RequestAlarmID IN (
		SELECT TOP ' + @SizeString + ' RequestAlarmID
			FROM [OW].[tblRequestAlarm]
			WHERE RequestAlarmID NOT IN (
				SELECT TOP ' + @PrevString + ' RequestAlarmID 
				FROM [OW].[tblRequestAlarm]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[RequestAlarmID], 
		[RequestID], 
		[Occurence], 
		[OccurenceOffset], 
		[Message], 
		[AlertByEMail], 
		[AddresseeRequestOwner], 
		[AddresseeLastModifyUser], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblRequestAlarm]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] WITH NOCHECK ADD CONSTRAINT [CK_tblAlert02] CHECK (([AlertType] = 1 and (([ProcessID] is not null or [ProcessStageID] is null) and [RequestID] is null and [ExceptionID] is null) or [AlertType] = 2 and ([RequestID] is not null and [ProcessID] is null and [ProcessStageID] is null and [ExceptionID] is null) or [AlertType] = 4 and ([ExceptionID] is not null and [ProcessID] is null and [ProcessStageID] is null and [RequestID] is null)))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblAlert] WITH NOCHECK ADD CONSTRAINT [CK_tblAlert01] CHECK (([AlertID] >= 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblAlert] WITH NOCHECK ADD CONSTRAINT [CK_tblAlert03] CHECK (([AlertType] = 4 or ([AlertType] = 2 or [AlertType] = 1)))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD CONSTRAINT [CK_tblRequest_Solicitor] CHECK (([EntID] is not null and [UserID] is null or [EntID] is null and [UserID] is not null))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD CONSTRAINT [tblRequest_ck] CHECK (([regID] is not null and [serieID] is null or [regid] is null and [serieid] is not null))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD CONSTRAINT [CK_tblRequest_Origin] CHECK (([Origin] = 2 or [Origin] = 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD CONSTRAINT [CK_tblRequest_State] CHECK (([State] = 5 or ([State] = 4 or ([State] = 3 or ([State] = 2 or [State] = 1)))))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblExceptionManagement]'
GO
ALTER TABLE [OW].[tblExceptionManagement] WITH NOCHECK ADD CONSTRAINT [CK_tblExceptionManagement01] CHECK (([ExceptionID] >= 1 and [ExceptionID] <= 5))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] ADD CONSTRAINT [CK_tblAlarmQueue02] CHECK (([ProcessAlarmID] is not null and [RequestAlarmID] is null or [ProcessAlarmID] is null and [RequestAlarmID] is not null))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblAlarmQueue] ADD CONSTRAINT [CK_tblAlarmQueue01] CHECK (([AlertQueueID] >= 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm02] CHECK (([Occurence] = 8 or ([Occurence] = 4 or ([Occurence] = 2 or [Occurence] = 1))))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm04] CHECK (([FlowID] is not null or [FlowStageID] is null))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm05] CHECK (([ProcessID] is not null or [ProcessStageID] is null))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblExceptionManagementAddressee]'
GO
ALTER TABLE [OW].[tblExceptionManagementAddressee] ADD CONSTRAINT [CK_tblExceptionManagementAddressee01] CHECK (([ExceptionManagementAddresseeID] >= 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblRequestAlarm]'
GO
ALTER TABLE [OW].[tblRequestAlarm] ADD CONSTRAINT [CK_tblRequestAlarm01] CHECK (([RequestAlarmID] >= 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblRequestAlarm] ADD CONSTRAINT [CK_tblRequestAlarm02] CHECK (([Occurence] = 4 or ([Occurence] = 2 or [Occurence] = 1)))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblRequestAlarmAddressee]'
GO
ALTER TABLE [OW].[tblRequestAlarmAddressee] ADD CONSTRAINT [CK_tblRequestAlarmAddressee01] CHECK (([RequestAlarmAddresseeID] >= 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblProfiles]'
GO
ALTER TABLE [OW].[tblProfiles] ADD CONSTRAINT [IX_tblProfiles_DescUNIQUE] UNIQUE NONCLUSTERED  ([ProfileDesc], [ProfileType])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblAlert]'
GO
ALTER TABLE [OW].[tblAlert] WITH NOCHECK ADD
CONSTRAINT [FK_tblAlert_tblUser] FOREIGN KEY ([UserID]) REFERENCES [OW].[tblUser] ([userID]),
CONSTRAINT [FK_tblAlert_tblProcess] FOREIGN KEY ([ProcessID]) REFERENCES [OW].[tblProcess] ([ProcessID]),
CONSTRAINT [FK_tblAlert_tblProcessStage] FOREIGN KEY ([ProcessStageID], [ProcessID]) REFERENCES [OW].[tblProcessStage] ([ProcessStageID], [ProcessID]),
CONSTRAINT [FK_tblAlert_tblRequest] FOREIGN KEY ([RequestID]) REFERENCES [OW].[tblRequest] ([RequestID]),
CONSTRAINT [FK_tblAlert_tblExceptionManagement] FOREIGN KEY ([ExceptionID]) REFERENCES [OW].[tblExceptionManagement] ([ExceptionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblExceptionManagementAddressee]'
GO
ALTER TABLE [OW].[tblExceptionManagementAddressee] WITH NOCHECK ADD
CONSTRAINT [FK_tblExceptionManagementAddressee_tblExceptionManagement] FOREIGN KEY ([ExceptionID]) REFERENCES [OW].[tblExceptionManagement] ([ExceptionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] ADD
CONSTRAINT [FK_tblAlarmQueue_tblProcessAlarm] FOREIGN KEY ([ProcessAlarmID]) REFERENCES [OW].[tblProcessAlarm] ([ProcessAlarmID]),
CONSTRAINT [FK_tblAlarmQueue_tblRequestAlarm] FOREIGN KEY ([RequestAlarmID]) REFERENCES [OW].[tblRequestAlarm] ([RequestAlarmID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblRequestAlarm]'
GO
ALTER TABLE [OW].[tblRequestAlarm] ADD
CONSTRAINT [FK_tblRequestAlarm_tblRequest] FOREIGN KEY ([RequestID]) REFERENCES [OW].[tblRequest] ([RequestID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblRequest]'
GO
ALTER TABLE [OW].[tblRequest] ADD
CONSTRAINT [FK_tblRequest_tblUser2] FOREIGN KEY ([UserID]) REFERENCES [OW].[tblUser] ([userID]),
CONSTRAINT [FK_tblRequest_tblRequestMotionType] FOREIGN KEY ([MotionID]) REFERENCES [OW].[tblRequestMotionType] ([MotionID]),
CONSTRAINT [FK_tblRequest_tblRequestMotiveConsult1] FOREIGN KEY ([MotiveID]) REFERENCES [OW].[tblRequestMotiveConsult] ([MotiveID]),
CONSTRAINT [FK_tblRequest_tblRequestType] FOREIGN KEY ([RequestTypeID]) REFERENCES [OW].[tblRequestType] ([RequestID]),
CONSTRAINT [FK_tblRequest_tblUser] FOREIGN KEY ([CreatedByID]) REFERENCES [OW].[tblUser] ([userID]),
CONSTRAINT [FK_tblRequest_tblUser1] FOREIGN KEY ([ModifiedByID]) REFERENCES [OW].[tblUser] ([userID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblRequestAlarmAddressee]'
GO
ALTER TABLE [OW].[tblRequestAlarmAddressee] ADD
CONSTRAINT [FK_tblRequestAlarmAddressee_tblRequestAlarm] FOREIGN KEY ([RequestAlarmID]) REFERENCES [OW].[tblRequestAlarm] ([RequestAlarmID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RegistryDocumentsInsert]'
GO

CREATE    PROCEDURE OW.RegistryDocumentsInsert
(
	@RegID numeric(18,0),
	@DocumentIDsList varchar(8000)
)
AS
BEGIN

	insert into OW.tblRegistryDocuments (RegID, DocumentID)
	select @RegID, stt.Item from OW.StringToTable(@DocumentIDsList,',') stt

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[RegistryDocumentsUpdate]'
GO
CREATE    PROCEDURE OW.RegistryDocumentsUpdate
(
	@RegID numeric(18,0),
	@DocumentIDsList varchar(8000)
)
AS
BEGIN

	SET XACT_ABORT ON
	
	BEGIN TRANSACTION
	
	select DocumentID 
	into #DocumentsToDelete
	from OW.tblRegistryDocuments
	where RegID = @RegID
	and not exists ( select 1 from OW.StringToTable(@DocumentIDsList,',') stt
				where OW.tblRegistryDocuments.DocumentID = stt.Item
	)
	
	delete from OW.tblRegistryDocuments 
	where RegID = @RegID
	and not exists ( select 1 from OW.StringToTable(@DocumentIDsList,',') stt
				where OW.tblRegistryDocuments.DocumentID = stt.Item
	)
	
	delete from OW.tblDocument
	where exists (select 1 from #DocumentsToDelete
			where OW.tblDocument.DocumentID = #DocumentsToDelete.DocumentID 
	)
	
	insert into OW.tblRegistryDocuments (RegID, DocumentID)
	select @RegID, stt.Item from OW.StringToTable(@DocumentIDsList,',') stt
		where not exists ( select 1 from OW.tblRegistryDocuments
					where RegID = @RegID 
					and stt.Item = OW.tblRegistryDocuments.DocumentID
	)
	
	COMMIT TRANSACTION

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO


IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database updated succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO




-- -----------------------------------------------
-- Add data to tblExceptionManagement
-- -----------------------------------------------

INSERT INTO [OW].[tblExceptionManagement] ([ExceptionID], [Description], [Active], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [AddresseeBookManager],	[Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn])
VALUES	(1,'Etapas automáticas: Envio de mail',	0, 'Não foi possível enviar email numa etapa do processo.' + CHAR(13) + CHAR(10) + 'O processo não transita para a etapa seguinte enquanto o problema não for resolvido.', 0, 0, 0, 0, 0, NULL, 'Administrador OfficeWorks', getDate(), 'Administrador OfficeWorks', getDate())
INSERT INTO [OW].[tblExceptionManagement] ([ExceptionID], [Description], [Active], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [AddresseeBookManager],	[Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn])
VALUES	(2,'Etapas automáticas: Geração de documentos',	0, 'Não foi possível gerar o documento word.' + CHAR(13) + CHAR(10) + 'O processo não transita para a etapa seguinte enquanto o problema não for resolvido.', 0, 0, 0, 0, 0, NULL, 'Administrador OfficeWorks', getDate(), 'Administrador OfficeWorks', getDate())
INSERT INTO [OW].[tblExceptionManagement] ([ExceptionID], [Description], [Active], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [AddresseeBookManager],	[Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn])
VALUES	(3,'Etapas automáticas: Execução de serviços Web', 0, 'Não foi possível executar o serviço Web.' + CHAR(13) + CHAR(10) + 'O processo não transita para a etapa seguinte enquanto o problema não for resolvido.', 0, 0, 0, 0, 0, NULL, 'Administrador OfficeWorks', getDate(), 'Administrador OfficeWorks', getDate())
INSERT INTO [OW].[tblExceptionManagement] ([ExceptionID], [Description], [Active], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [AddresseeBookManager],	[Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn])
VALUES	(4,'Distribuição: Por processo', 0, 'Não foi possível efectuar a distribuição por processo.', 0, 0, 0, 0, 0, NULL, 'Administrador OfficeWorks', getDate(), 'Administrador OfficeWorks', getDate())
INSERT INTO [OW].[tblExceptionManagement] ([ExceptionID], [Description], [Active], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [AddresseeBookManager],	[Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn])
VALUES	(5,'Distribuição: Por correio electrónico', 0, 'Não foi possível efectuar a distribuição por correio electrónico.', 0, 0, 0, 0, 0, NULL, 'Administrador OfficeWorks', getDate(), 'Administrador OfficeWorks', getDate())
GO

-- -----------------------------------------------
-- End data to tblExceptionManagement
-- -----------------------------------------------


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.4.0' WHERE id= 1
GO


PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.3.1 PARA 5.4.0'
PRINT ''
GO

