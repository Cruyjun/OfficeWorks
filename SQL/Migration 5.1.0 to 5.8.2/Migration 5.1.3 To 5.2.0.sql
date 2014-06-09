-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.1.3 PARA A VERSÃO 5.2.0
--
-- ---------------------------------------------------------------------------------

/*==============================================================*/
/* Table: tblProcessEventNotification                           */
/*==============================================================*/
create table OW.tblProcessEventNotification (
   ProcessEventNotificationID int                  identity
      constraint CK_tblProcessEventNotification01 check (ProcessEventNotificationID >= 1),
   ProcessEventID       int                  not null,
   UserID               int                  not null,
   NotificationDate     datetime             not null,
   MessageID            varchar(50)          null,
   Status               tinyint              not null
      constraint CK_tblProcessEventNotification02 check (Status in (1,2,4,8)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessEventNotification primary key  (ProcessEventNotificationID)
)
go

/*==============================================================*/
/* Index: IX_TBLPROCESSEVENTNOTIFICATION01                      */
/*==============================================================*/
create   index IX_tblProcessEventNotification01 on OW.tblProcessEventNotification (
ProcessEventID
)
go

alter table OW.tblProcessEventNotification
   add constraint FK_tblProcessEventNotification_tblProcessEvent foreign key (ProcessEventID)
      references OW.tblProcessEvent (ProcessEventID)
go

alter table OW.tblProcessEventNotification
   add constraint FK_tblProcessEventNotification_tblUser foreign key (UserID)
      references OW.tblUser (UserID)
go



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

	SET @DocumentAccess = 1

	DECLARE cursor_cpda CURSOR FOR 
	SELECT 
	OW.tblProcessEvent.ProcessID,
	OW.tblProcessEvent.ProcessStageID
	FROM OW.tblProcessDocument INNER JOIN
	     OW.tblProcessEvent ON OW.tblProcessDocument.ProcessEventID = OW.tblProcessEvent.ProcessEventID
	WHERE OW.tblProcessDocument.DocumentID = @DocumentID
	ORDER BY ProcessStageID
	
	OPEN cursor_cpda
	
	FETCH NEXT FROM cursor_cpda INTO @ProcessID, @ProcessStageID
	
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

		FETCH NEXT FROM cursor_cpda INTO @ProcessID, @ProcessStageID	   
	END
	
	CLOSE cursor_cpda
	DEALLOCATE cursor_cpda

END   

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessDocumentAccess Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessDocumentAccess Error on Creation'
GO











/*==============================================================*/
/* O nome dos campos do registo tem de passar a ser único       */
/*==============================================================*/
create unique index IX_tblFormFields01 on 
OW.tblFormFields (
FieldName
)
GO

/*==============================================================*/
/* Table: tblUserSignature                                      */
/*==============================================================*/

CREATE TABLE [OW].[tblUserSignature] (
   UserSignatureID        int                  identity,
   UserID                 int                  not null,	
   Signature              image                not null,
   SignatureFilename      varchar(250)         not null,
   Remarks                varchar(255)         null,
   InsertedBy             varchar(50)          not null,
   InsertedOn             datetime             not null,
   LastModifiedBy         varchar(50)          not null,
   LastModifiedOn         datetime             not null,
   constraint PK_tblUserSignature primary key  (UserSignatureID)
)
GO



alter table OW.tblUserSignature
   add constraint FK_tblUserSignature_tblUser01 foreign key (UserID)
   references OW.tblUser (UserID) on delete cascade
GO


create unique index IX_tblUserSignature01 on 
OW.tblUserSignature (
UserID
)
GO










IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureSelect;
GO

CREATE PROCEDURE [OW].UserSignatureSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 13:36:10
	--Version: 1.2	
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

	SELECT
		[UserSignatureID],
		[UserID],
		[Signature],
		[SignatureFilename],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblUserSignature]
	WHERE
		(@UserSignatureID IS NULL OR [UserSignatureID] = @UserSignatureID) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@SignatureFilename IS NULL OR [SignatureFilename] LIKE @SignatureFilename) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureUpdate;
GO

CREATE PROCEDURE [OW].UserSignatureUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 13:36:10
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserSignatureID int,
	@UserID int,
	@Signature image = NULL,
	@SignatureFilename varchar(250),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblUserSignature]
	SET
		[UserID] = @UserID,
		[Signature] = @Signature,
		[SignatureFilename] = @SignatureFilename,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[UserSignatureID] = @UserSignatureID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureInsert;
GO

CREATE PROCEDURE [OW].UserSignatureInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 13:36:10
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserSignatureID int = NULL OUTPUT,
	@UserID int,
	@Signature image = NULL,
	@SignatureFilename varchar(250),
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
	INTO [OW].[tblUserSignature]
	(
		[UserID],
		[Signature],
		[SignatureFilename],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@UserID,
		@Signature,
		@SignatureFilename,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @UserSignatureID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureDelete;
GO

CREATE PROCEDURE [OW].UserSignatureDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 13:36:10
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserSignatureID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblUserSignature]
	WHERE
		[UserSignatureID] = @UserSignatureID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureDelete Error on Creation'
GO























/*==============================================================*/
/* Table: tblUserSignatureAccess                                */
/*==============================================================*/
create table OW.tblUserSignatureAccess (
   UserSignatureAccessID int                  identity,
   FromUserID            int                  not null,
   ToUserID              int                  not null,
   Remarks               varchar(255)         null,
   InsertedBy            varchar(50)          not null,
   InsertedOn            datetime             not null,
   LastModifiedBy        varchar(50)          not null,
   LastModifiedOn        datetime             not null,
   constraint PK_tblUserSignatureAccess primary key  (UserSignatureAccessID),
   constraint CK_tblUserSignatureAccess01 check (FromUserID <> ToUserID)
)
go


-- como não é possivel ter mais que um "on delete cascade"
-- é necessário actualizar o procedimento UserDelete para apagar primeiro
-- as referencias do FromUserID antes de apagar o utilizador da tblUser.
alter table OW.tblUserSignatureAccess
   add constraint FK_tblUserSignatureAccess_tblUser01 foreign key (FromUserID)
   references OW.tblUser (UserID) 
GO

alter table OW.tblUserSignatureAccess
   add constraint FK_tblUserSignatureAccess_tblUser02 foreign key (ToUserID)
   references OW.tblUser (UserID) on delete cascade
GO



-- Indice para garantir que não existem acessos em duplicado e para melhorar
-- o select dos acessos que o utilizador 'FromUserID' atribuiu.
create unique index IX_tblUserSignatureAccess01 on 
OW.tblUserSignatureAccess (
FromUserID,
ToUserID
)
GO

-- Indice para melhorar o select dos acessos atribuidos ao utilizador 'ToUserID'.
create index IX_tblUserSignatureAccess02 on 
OW.tblUserSignatureAccess (
ToUserID
)
GO









IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureAccessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureAccessSelect;
GO

CREATE PROCEDURE [OW].UserSignatureAccessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 17:53:41
	--Version: 1.2	
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

	SELECT
		[UserSignatureAccessID],
		[FromUserID],
		[ToUserID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblUserSignatureAccess]
	WHERE
		(@UserSignatureAccessID IS NULL OR [UserSignatureAccessID] = @UserSignatureAccessID) AND
		(@FromUserID IS NULL OR [FromUserID] = @FromUserID) AND
		(@ToUserID IS NULL OR [ToUserID] = @ToUserID) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureAccessSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureAccessSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureAccessUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureAccessUpdate;
GO

CREATE PROCEDURE [OW].UserSignatureAccessUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 17:53:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserSignatureAccessID int,
	@FromUserID int,
	@ToUserID int,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblUserSignatureAccess]
	SET
		[FromUserID] = @FromUserID,
		[ToUserID] = @ToUserID,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[UserSignatureAccessID] = @UserSignatureAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureAccessUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureAccessUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureAccessInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureAccessInsert;
GO

CREATE PROCEDURE [OW].UserSignatureAccessInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 17:53:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserSignatureAccessID int = NULL OUTPUT,
	@FromUserID int,
	@ToUserID int,
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
	INTO [OW].[tblUserSignatureAccess]
	(
		[FromUserID],
		[ToUserID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@FromUserID,
		@ToUserID,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @UserSignatureAccessID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureAccessInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureAccessInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureAccessDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureAccessDelete;
GO

CREATE PROCEDURE [OW].UserSignatureAccessDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 09-06-2006 17:53:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@UserSignatureAccessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblUserSignatureAccess]
	WHERE
		[UserSignatureAccessID] = @UserSignatureAccessID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureAccessDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureAccessDelete Error on Creation'
GO












IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSignatureAccessSelectGrantTo') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSignatureAccessSelectGrantTo;
GO

CREATE PROCEDURE OW.UserSignatureAccessSelectGrantTo
(
	------------------------------------------------------------------------
	-- Assinaturas a que o utilizador tem acesso
	--
	--
	------------------------------------------------------------------------
	@ToUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		USA.FromUserID,
		U.UserDesc
	FROM OW.tblUserSignatureAccess USA INNER JOIN OW.tblUser U
		ON USA.FromUserID = U.UserID
	WHERE
		ToUserID = @ToUserID

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSignatureAccessSelectGrantTo Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSignatureAccessSelectGrantTo Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - tblFlowRouting - Criação do campo Absence
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE OW.tblFlowRouting
	DROP CONSTRAINT FK_tblFlowDelegation_tblOrganizationalUnit01
GO
ALTER TABLE OW.tblFlowRouting
	DROP CONSTRAINT FK_tblFlowDelegation_tblOrganizationalUnit02
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE OW.tblFlowRouting
	DROP CONSTRAINT FK_tblFlowDelegation_tblFlow
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE OW.Tmp_tblFlowRouting
	(
	FlowRoutingID int NOT NULL IDENTITY (1, 1),
	OrganizationalUnitID int NOT NULL,
	StartDate datetime NOT NULL,
	EndDate datetime NOT NULL,
	FlowID int NULL,
	ToOrganizationalUnitID int NOT NULL,
	Absence bit NOT NULL,
	Remarks varchar(255) NULL,
	InsertedBy varchar(50) NOT NULL,
	InsertedOn datetime NOT NULL,
	LastModifiedBy varchar(50) NOT NULL,
	LastModifiedOn datetime NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT OW.Tmp_tblFlowRouting ON
GO
IF EXISTS(SELECT * FROM OW.tblFlowRouting)
	 EXEC('INSERT INTO OW.Tmp_tblFlowRouting (FlowRoutingID, OrganizationalUnitID, StartDate, EndDate, FlowID, ToOrganizationalUnitID, Absence, Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn)
		SELECT FlowRoutingID, OrganizationalUnitID, StartDate, EndDate, FlowID, ToOrganizationalUnitID, 0, Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn FROM OW.tblFlowRouting TABLOCKX')
GO
SET IDENTITY_INSERT OW.Tmp_tblFlowRouting OFF
GO
DROP TABLE OW.tblFlowRouting
GO
EXECUTE sp_rename N'OW.Tmp_tblFlowRouting', N'tblFlowRouting', 'OBJECT'
GO
ALTER TABLE OW.tblFlowRouting ADD CONSTRAINT
	PK_tblFlowDelegation PRIMARY KEY CLUSTERED 
	(
	FlowRoutingID
	) ON [PRIMARY]

GO
ALTER TABLE OW.tblFlowRouting WITH NOCHECK ADD CONSTRAINT
	CK_FlowRouting01 CHECK (([FlowRoutingID] >= 1))
GO
ALTER TABLE OW.tblFlowRouting WITH NOCHECK ADD CONSTRAINT
	CK_FlowRouting02 CHECK (([StartDate] <= [EndDate]))
GO
ALTER TABLE OW.tblFlowRouting WITH NOCHECK ADD CONSTRAINT
	FK_tblFlowDelegation_tblFlow FOREIGN KEY
	(
	FlowID
	) REFERENCES OW.tblFlow
	(
	FlowID
	)
GO
ALTER TABLE OW.tblFlowRouting WITH NOCHECK ADD CONSTRAINT
	FK_tblFlowDelegation_tblOrganizationalUnit01 FOREIGN KEY
	(
	OrganizationalUnitID
	) REFERENCES OW.tblOrganizationalUnit
	(
	OrganizationalUnitID
	)
GO
ALTER TABLE OW.tblFlowRouting WITH NOCHECK ADD CONSTRAINT
	FK_tblFlowDelegation_tblOrganizationalUnit02 FOREIGN KEY
	(
	ToOrganizationalUnitID
	) REFERENCES OW.tblOrganizationalUnit
	(
	OrganizationalUnitID
	)
GO
COMMIT




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTER TABLE tblRequest
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

ALTER TABLE [OW].[tblRequest] ALTER COLUMN [EntID] [numeric](18, 0) NULL 
GO
ALTER TABLE [OW].[tblRequest] ADD  [UserID] [int] NULL 
GO
ALTER TABLE [OW].[tblRequest] ADD 	
	CONSTRAINT [FK_tblRequest_tblUser2] FOREIGN KEY
	(
		[UserID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	)
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD 	
	CONSTRAINT [CK_tblRequest_Solicitor] CHECK ([EntID] is not null and [UserID] is null or [EntID] is null and [UserID] is not null)
GO


update OW.tblRequest set OW.tblRequest.Origin = 1 where OW.tblRequest.EntID Is Null
update OW.tblRequest set OW.tblRequest.Origin = 2 where OW.tblRequest.UserID Is Null
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - usp_AddRegistry
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_AddRegistry') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_AddRegistry;
GO

CREATE PROCEDURE OW.usp_AddRegistry
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
        @Field2 nvarchar(50) = Null,
	@YearOut numeric output,
	@NumberOut numeric output
	
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

    SET @YearOut =  @Year
    SET @NumberOut =  @NextNumber

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_AddRegistry Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_AddRegistry Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - usp_GetRequestByID
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_GetRequestByID') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_GetRequestByID;
GO

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
		COALESCE (OW.tblEntities.Name, OW.tblUser.userDesc) AS OriginDescription,
        '<a href=ViewRequest.aspx?RequestId=' + CAST(OW.tblRequest.RequestID AS varchar(5)) + '>' + CAST(OW.tblRequest.[Year] AS varchar(5)) + '/' + CAST(OW.tblRequest.Number AS varchar(5)) + '</a>' AS YearNumber, 
        OW.tblRegistry.[year] AS RegYear,
		OW.tblRegistry.number AS RegNumber, OW.tblRequest.ModifiedDate , OW.tblRequest.Subject
	FROM         
		OW.tblRequest INNER JOIN
        OW.tblRequestMotionType ON OW.tblRequest.MotionID = OW.tblRequestMotionType.MotionID INNER JOIN
        OW.tblRequestMotiveConsult ON OW.tblRequest.MotiveID = OW.tblRequestMotiveConsult.MotiveID INNER JOIN
        OW.tblRequestType ON OW.tblRequest.RequestTypeID = OW.tblRequestType.RequestID LEFT OUTER JOIN
        OW.tblEntities ON OW.tblEntities.EntID = OW.tblRequest.EntID LEFT OUTER JOIN
        OW.tblUser ON OW.tblUser.UserID = OW.tblRequest.UserID LEFT OUTER JOIN
        OW.tblRegistry ON OW.tblRequest.RegID = OW.tblRegistry.regid 
	WHERE 
		OW.tblRequest.RequestID in (SELECT Item FROM OW.StringToTable(@IdsList,','))


	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_GetRequestByID Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_GetRequestByID Error on Creation'
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - usp_NewRequest
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_NewRequest') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_NewRequest;
GO

/****** Object:  Stored Procedure OW.usp_NewRequest    Script Date: 23-11-2005 14:06:13 ******/
CREATE PROCEDURE [OW].usp_NewRequest
(
	@RequestID numeric(18,0) = NULL output,
	@Year numeric(18,0),
	@SerieID numeric(18,0) = NULL,
	@RequestDate varchar(20),
	@EntID numeric(18,0) = NULL,
	@UserID int = NULL,
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
		[Number],[Year], [RequestDate], [EntID], [UserID], [Reference], [ReferenceYear],
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
		GETDATE(),
		@SerieID,
		@RegID
	)

	SET @Err = @@Error

	SELECT @RequestID = SCOPE_IDENTITY()

	RETURN @Err
END


GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_NewRequest Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_NewRequest Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - usp_SetRequest
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_SetRequest') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_SetRequest;
GO


CREATE PROCEDURE [OW].usp_SetRequest
(
	@RequestID numeric(18,0),
	@Number numeric(18,0),
	@Year numeric(18,0),
	@RequestDate varchar(20),
	@EntID numeric(18,0) = NULL,
	@UserID int = NULL,
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


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_SetRequest Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_SetRequest Error on Creation'
GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - RegistrySelectPagingEx02
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
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
		r.[Subject],
		r.[originref]
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



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - fnClassificationSelectByClassificationParentID
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[fnClassificationSelectByClassificationParentID]') and xtype in (N'FN', N'IF', N'TF'))
	DROP FUNCTION [OW].[fnClassificationSelectByClassificationParentID]
GO


CREATE FUNCTION OW.fnClassificationSelectByClassificationParentID
(
	@ClassificationID int
)
RETURNS TABLE
AS
RETURN
(
	-- Obtém todos os IDs das Classificações que pertencem a esta classificação
	--Level 1
	SELECT a1.ClassificationID, a1.ParentID, a1.Level, a1.Code, a1.Description, a1.Global, a1.Scope
	FROM OW.tblClassification a1
	WHERE a1.ParentID = @ClassificationID

	UNION

	--Level 2
	SELECT a2.ClassificationID, a2.ParentID, a2.Level, a2.Code, a2.Description, a2.Global, a2.Scope
	FROM OW.tblClassification a2
	WHERE a2.ParentID IN 
		(SELECT ClassificationID FROM OW.tblClassification a1 WHERE a1.ParentID = @ClassificationID)

	UNION 

	--Level 3
	SELECT a3.ClassificationID, a3.ParentID, a3.Level, a3.Code, a3.Description, a3.Global, a3.Scope
	FROM OW.tblClassification a3
	WHERE a3.ParentID IN 
		(SELECT ClassificationID FROM OW.tblClassification a2 WHERE a2.ParentID IN 
			(SELECT ClassificationID FROM OW.tblClassification a1 WHERE a1.ParentID = @ClassificationID))

	UNION 

	--Level 4
	SELECT a4.ClassificationID, a4.ParentID, a4.Level, a4.Code, a4.Description, a4.Global, a4.Scope
	FROM OW.tblClassification a4
	WHERE a4.ParentID IN 
		(SELECT ClassificationID FROM OW.tblClassification a3 WHERE a3.ParentID IN 
			(SELECT ClassificationID FROM OW.tblClassification a2 WHERE a2.ParentID IN 
				(SELECT ClassificationID FROM OW.tblClassification a1 WHERE a1.ParentID = @ClassificationID)))
)

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].fnClassificationSelectByClassificationParentID Succeeded'
ELSE PRINT 'Function Creation: [OW].fnClassificationSelectByClassificationParentID Error on Creation'
GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationParentID
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[ClassificationSelectByClassificationParentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [OW].[ClassificationSelectByClassificationParentID]
GO

CREATE    PROCEDURE [OW].[ClassificationSelectByClassificationParentID]
(
	@ClassificationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
	SELECT * 
	FROM OW.fnClassificationSelectByClassificationParentID (@ClassificationID)

	SET @Err = @@Error

	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationParentID Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationParentID Error on Creation'
GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationLevel1
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationLevel1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[ClassificationSelectByClassificationLevel1]
GO

CREATE   PROCEDURE [OW].[ClassificationSelectByClassificationLevel1]
(
	@Code1 varchar(50) = NULL,
	@Code2 varchar(50) = NULL,
	@Code3 varchar(50) = NULL,
	@Code4 varchar(50) = NULL,
	@Code5 varchar(50) = NULL,
	@Description varchar(250) = NULL
)
AS
BEGIN
	/* Level = 0 */
	/* If code 1 is filled remove all that is different from this criteria */
	IF LEN(@Code1) > 0
	BEGIN
		/* Initialize value for this level */
		DECLARE @ParentID int
		SET @ParentID = NULL

		/* Create temporary table for classifications */
		CREATE TABLE #ClassificationAux(
			ClassificationID int,
			ParentID int,
			Level smallint,
			Code varchar(50),
			Description varchar(250),
			Global bit,
			Scope smallint)
	
		/* Insert into temporary table classifications with this criteria */	
		INSERT INTO #ClassificationAux
		SELECT ClassificationID, 
			ParentID,
			Level,
			Code,
			Description,
			Global,
			Scope 
		FROM OW.tblClassification
		WHERE Level = 0 AND Code LIKE @Code1
	
		/* Create a cursor for classifications with this criteria */
		DECLARE c1 CURSOR FOR	
			SELECT ClassificationID FROM OW.tblClassification
			WHERE Level = 0 AND Code LIKE @Code1	
		OPEN c1
		FETCH NEXT FROM c1 INTO @ParentID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ParentID IS NOT NULL
			BEGIN
				/* Insert into temporary table child classifications for this classification */
				INSERT INTO #ClassificationAux
				SELECT * FROM OW.fnClassificationSelectByClassificationParentID (@ParentID)
			END
			FETCH NEXT FROM c1 INTO @ParentID
		END
		CLOSE c1
		DEALLOCATE c1
	
		/* If code 2 is filled remove all that is different from this criteria */
		IF LEN(@Code2) > 0 
		BEGIN
			DECLARE @Code2ParentID int
			DECLARE @Code2Query nvarchar(4000)
			DECLARE @Code2NotIn nvarchar(4000)
			DECLARE @Code2NotInChild nvarchar(4000)

			SET @Code2ParentID = NULL
			SET @Code2Query = ''
			SET @Code2NotIn = ''
			SET @Code2NotInChild = ''

			DECLARE c2 CURSOR FOR		
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 1 AND Code LIKE @Code2		
			OPEN c2
			FETCH NEXT FROM c2 INTO @Code2ParentID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @Code2ParentID IS NOT NULL
				BEGIN
					SET @Code2NotIn = @Code2NotIn + CAST(@Code2ParentID AS VARCHAR) + ','
					IF LEN(@Code2NotInChild) > 0 SET @Code2NotInChild = @Code2NotInChild + ' UNION '
					SET @Code2NotInChild = @Code2NotInChild + 'SELECT ClassificationID FROM OW.fnClassificationSelectByClassificationParentID (' + CAST(@Code2ParentID AS VARCHAR) + ')'
				END
				FETCH NEXT FROM c2 INTO @Code2ParentID
			END
			CLOSE c2
			DEALLOCATE c2
			
			SET @Code2Query = 'DELETE #ClassificationAux'
			IF LEN(@Code2NotIn) > 0
			BEGIN
				SET @Code2NotIn = LEFT(@Code2NotIn, LEN(@Code2NotIn)-1)
				SET @Code2Query = @Code2Query + ' WHERE ClassificationID NOT IN (' + @Code2NotIn + ')'
				SET @Code2Query = @Code2Query + ' AND ClassificationID NOT IN (' + @Code2NotInChild + ')'
			END
			EXEC sp_ExecuteSQL @Code2Query
		END
	
		/* If code 3 is filled remove all that is different from this criteria */
		IF LEN(@Code3) > 0 
		BEGIN
			DECLARE @Code3ParentID int
			DECLARE @Code3Query nvarchar(4000)
			DECLARE @Code3NotIn nvarchar(4000)
			DECLARE @Code3NotInChild nvarchar(4000)

			SET @Code3ParentID = NULL
			SET @Code3Query = ''
			SET @Code3NotIn = ''
			SET @Code3NotInChild = ''
			
			DECLARE c3 CURSOR FOR
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 2 AND Code LIKE @Code3
			OPEN c3
			FETCH NEXT FROM c3 INTO @Code3ParentID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @Code3ParentID IS NOT NULL
				BEGIN
					SET @Code3NotIn = @Code3NotIn + CAST(@Code3ParentID AS VARCHAR) + ','
					IF LEN(@Code3NotInChild) > 0 SET @Code3NotInChild = @Code3NotInChild + ' UNION '
					SET @Code3NotInChild = @Code3NotInChild + 'SELECT ClassificationID FROM OW.fnClassificationSelectByClassificationParentID (' + CAST(@Code3ParentID AS VARCHAR) + ')'
				END
				FETCH NEXT FROM c3 INTO @Code3ParentID
			END
			CLOSE c3
			DEALLOCATE c3
			
			SET @Code3Query = 'DELETE #ClassificationAux'
			IF LEN(@Code3NotIn) > 0
			BEGIN
				SET @Code3NotIn = LEFT(@Code3NotIn, LEN(@Code3NotIn)-1)
				SET @Code3Query = @Code3Query + ' WHERE ClassificationID NOT IN (' + @Code3NotIn + ')'
				SET @Code3Query = @Code3Query + ' AND ClassificationID NOT IN (' + @Code3NotInChild + ')'
			END
			EXEC sp_ExecuteSQL @Code3Query
		END
	
		/* If code 4 is filled remove all that is different from this criteria */
		IF LEN(@Code4) > 0 
		BEGIN
			DECLARE @Code4ParentID int
			DECLARE @Code4Query nvarchar(4000)
			DECLARE @Code4NotIn nvarchar(4000)
			DECLARE @Code4NotInChild nvarchar(4000)

			SET @Code4ParentID = NULL
			SET @Code4Query = ''
			SET @Code4NotIn = ''
			SET @Code4NotInChild = ''	

			DECLARE c4 CURSOR FOR		
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 3 AND Code LIKE @Code4		
			OPEN c4
			FETCH NEXT FROM c4 INTO @Code4ParentID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @Code4ParentID IS NOT NULL
				BEGIN
					SET @Code4NotIn = @Code4NotIn + CAST(@Code4ParentID AS VARCHAR) + ','
					IF LEN(@Code4NotInChild) > 0 SET @Code4NotInChild = @Code4NotInChild + ' UNION '
					SET @Code4NotInChild = @Code4NotInChild + 'SELECT ClassificationID FROM OW.fnClassificationSelectByClassificationParentID (' + CAST(@Code4ParentID AS VARCHAR) + ')'
				END
				FETCH NEXT FROM c4 INTO @Code4ParentID
			END
			CLOSE c4
			DEALLOCATE c4
			
			SET @Code4Query = 'DELETE #ClassificationAux'
			IF LEN(@Code4NotIn) > 0
			BEGIN
				SET @Code4NotIn = LEFT(@Code4NotIn, LEN(@Code4NotIn)-1)
				SET @Code4Query = @Code4Query + ' WHERE ClassificationID NOT IN (' + @Code4NotIn + ')'
				SET @Code4Query = @Code4Query + ' AND ClassificationID NOT IN (' + @Code4NotInChild + ')'
			END
			EXEC sp_ExecuteSQL @Code4Query
		END

		/* If code 5 is filled remove all that is different from this criteria */
		IF LEN(@Code5) > 0 
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 4 AND Code LIKE @Code5)
		END
	
		/* If description is filled remove all that is different from this criteria */
		IF LEN(@Description) > 0
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Description LIKE @Description)
		END
		
		/* Return classifications for criteria */	
		SELECT ClassificationID FROM #ClassificationAux

	END

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel1 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel1 Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationLevel2
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[ClassificationSelectByClassificationLevel2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[ClassificationSelectByClassificationLevel2]
GO

CREATE    PROCEDURE [OW].[ClassificationSelectByClassificationLevel2]
(
	@Code2 varchar(50) = NULL,
	@Code3 varchar(50) = NULL,
	@Code4 varchar(50) = NULL,
	@Code5 varchar(50) = NULL,
	@Description varchar(250) = NULL
)
AS
BEGIN
	/* Level = 1 */
	/* If code 2 is filled remove all that is different from this criteria */
	IF LEN(@Code2) > 0
	BEGIN
		/* Initialize value for this level */
		DECLARE @ParentID int
		SET @ParentID = NULL
	
		/* Create temporary table for classifications */
		CREATE TABLE #ClassificationAux(
			ClassificationID int,
			ParentID int,
			Level smallint,
			Code varchar(50),
			Description varchar(250),
			Global bit,
			Scope smallint)
	
		/* Insert into temporary table classifications with this criteria */	
		INSERT INTO #ClassificationAux
		SELECT ClassificationID, 
			ParentID,
			Level,
			Code,
			Description,
			Global,
			Scope 
		FROM OW.tblClassification
		WHERE Level = 1 AND Code LIKE @Code2
	
		/* Create a cursor for classifications with this criteria */
		DECLARE c2 CURSOR FOR	
			SELECT ClassificationID FROM OW.tblClassification
			WHERE Level = 1 AND Code LIKE @Code2	
		OPEN c2
		FETCH NEXT FROM c2 INTO @ParentID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ParentID IS NOT NULL
			BEGIN
				/* Insert into temporary table child classifications for this classification */
				INSERT INTO #ClassificationAux
				SELECT * FROM OW.fnClassificationSelectByClassificationParentID (@ParentID)
			END
			FETCH NEXT FROM c2 INTO @ParentID
		END
		CLOSE c2
		DEALLOCATE c2
	
		/* If code 3 is filled remove all that is different from this criteria */
		IF LEN(@Code3) > 0 
		BEGIN
			DECLARE @Code3ParentID int
			DECLARE @Code3Query nvarchar(4000)
			DECLARE @Code3NotIn nvarchar(4000)
			DECLARE @Code3NotInChild nvarchar(4000)

			SET @Code3ParentID = NULL
			SET @Code3Query = ''
			SET @Code3NotIn = ''
			SET @Code3NotInChild = ''
			
			DECLARE c3 CURSOR FOR
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 2 AND Code LIKE @Code3
			OPEN c3
			FETCH NEXT FROM c3 INTO @Code3ParentID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @Code3ParentID IS NOT NULL
				BEGIN
					SET @Code3NotIn = @Code3NotIn + CAST(@Code3ParentID AS VARCHAR) + ','
					IF LEN(@Code3NotInChild) > 0 SET @Code3NotInChild = @Code3NotInChild + ' UNION '
					SET @Code3NotInChild = @Code3NotInChild + 'SELECT ClassificationID FROM OW.fnClassificationSelectByClassificationParentID (' + CAST(@Code3ParentID AS VARCHAR) + ')'
				END
				FETCH NEXT FROM c3 INTO @Code3ParentID
			END
			CLOSE c3
			DEALLOCATE c3
			
			SET @Code3Query = 'DELETE #ClassificationAux'
			IF LEN(@Code3NotIn) > 0
			BEGIN
				SET @Code3NotIn = LEFT(@Code3NotIn, LEN(@Code3NotIn)-1)
				SET @Code3Query = @Code3Query + ' WHERE ClassificationID NOT IN (' + @Code3NotIn + ')'
				SET @Code3Query = @Code3Query + ' AND ClassificationID NOT IN (' + @Code3NotInChild + ')'
			END
			EXEC sp_ExecuteSQL @Code3Query
		END
	
		/* If code 4 is filled remove all that is different from this criteria */
		IF LEN(@Code4) > 0 
		BEGIN
			DECLARE @Code4ParentID int
			DECLARE @Code4Query nvarchar(4000)
			DECLARE @Code4NotIn nvarchar(4000)
			DECLARE @Code4NotInChild nvarchar(4000)

			SET @Code4ParentID = NULL
			SET @Code4Query = ''
			SET @Code4NotIn = ''
			SET @Code4NotInChild = ''	

			DECLARE c4 CURSOR FOR		
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 3 AND Code LIKE @Code4		
			OPEN c4
			FETCH NEXT FROM c4 INTO @Code4ParentID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @Code4ParentID IS NOT NULL
				BEGIN
					SET @Code4NotIn = @Code4NotIn + CAST(@Code4ParentID AS VARCHAR) + ','
					IF LEN(@Code4NotInChild) > 0 SET @Code4NotInChild = @Code4NotInChild + ' UNION '
					SET @Code4NotInChild = @Code4NotInChild + 'SELECT ClassificationID FROM OW.fnClassificationSelectByClassificationParentID (' + CAST(@Code4ParentID AS VARCHAR) + ')'
				END
				FETCH NEXT FROM c4 INTO @Code4ParentID
			END
			CLOSE c4
			DEALLOCATE c4
			
			SET @Code4Query = 'DELETE #ClassificationAux'
			IF LEN(@Code4NotIn) > 0
			BEGIN
				SET @Code4NotIn = LEFT(@Code4NotIn, LEN(@Code4NotIn)-1)
				SET @Code4Query = @Code4Query + ' WHERE ClassificationID NOT IN (' + @Code4NotIn + ')'
				SET @Code4Query = @Code4Query + ' AND ClassificationID NOT IN (' + @Code4NotInChild + ')'
			END
			EXEC sp_ExecuteSQL @Code4Query
		END

		/* If code 5 is filled remove all that is different from this criteria */
		IF LEN(@Code5) > 0 
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 4 AND Code LIKE @Code5)
		END
	
		/* If description is filled remove all that is different from this criteria */
		IF LEN(@Description) > 0
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Description LIKE @Description)
		END
		
		/* Return classifications for criteria */	
		SELECT ClassificationID FROM #ClassificationAux

	END

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel2 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel2 Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationLevel3
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[ClassificationSelectByClassificationLevel3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[ClassificationSelectByClassificationLevel3]
GO

CREATE     PROCEDURE [OW].[ClassificationSelectByClassificationLevel3]
(
	@Code3 varchar(50) = NULL,
	@Code4 varchar(50) = NULL,
	@Code5 varchar(50) = NULL,
	@Description varchar(250) = NULL
)
AS
BEGIN
	/* Level = 2 */
	/* If code 3 is filled remove all that is different from this criteria */
	IF LEN(@Code3) > 0
	BEGIN
		/* Initialize value for this level */
		DECLARE @ParentID int
		SET @ParentID = NULL
	
		/* Create temporary table for classifications */
		CREATE TABLE #ClassificationAux(
			ClassificationID int,
			ParentID int,
			Level smallint,
			Code varchar(50),
			Description varchar(250),
			Global bit,
			Scope smallint)
	
		/* Insert into temporary table classifications with this criteria */	
		INSERT INTO #ClassificationAux
		SELECT ClassificationID, 
			ParentID,
			Level,
			Code,
			Description,
			Global,
			Scope 
		FROM OW.tblClassification
		WHERE Level = 2 AND Code LIKE @Code3
	
		/* Create a cursor for classifications with this criteria */
		DECLARE c3 CURSOR FOR	
			SELECT ClassificationID FROM OW.tblClassification
			WHERE Level = 2 AND Code LIKE @Code3
		OPEN c3
		FETCH NEXT FROM c3 INTO @ParentID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ParentID IS NOT NULL
			BEGIN
				/* Insert into temporary table child classifications for this classification */
				INSERT INTO #ClassificationAux
				SELECT * FROM OW.fnClassificationSelectByClassificationParentID (@ParentID)
			END
			FETCH NEXT FROM c3 INTO @ParentID
		END
		CLOSE c3
		DEALLOCATE c3

		/* If code 4 is filled remove all that is different from this criteria */
		IF LEN(@Code4) > 0 
		BEGIN
			DECLARE @Code4ParentID int
			DECLARE @Code4Query nvarchar(4000)
			DECLARE @Code4NotIn nvarchar(4000)
			DECLARE @Code4NotInChild nvarchar(4000)

			SET @Code4ParentID = NULL
			SET @Code4Query = ''
			SET @Code4NotIn = ''
			SET @Code4NotInChild = ''	

			DECLARE c4 CURSOR FOR		
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 3 AND Code LIKE @Code4		
			OPEN c4
			FETCH NEXT FROM c4 INTO @Code4ParentID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @Code4ParentID IS NOT NULL
				BEGIN
					SET @Code4NotIn = @Code4NotIn + CAST(@Code4ParentID AS VARCHAR) + ','
					IF LEN(@Code4NotInChild) > 0 SET @Code4NotInChild = @Code4NotInChild + ' UNION '
					SET @Code4NotInChild = @Code4NotInChild + 'SELECT ClassificationID FROM OW.fnClassificationSelectByClassificationParentID (' + CAST(@Code4ParentID AS VARCHAR) + ')'
				END
				FETCH NEXT FROM c4 INTO @Code4ParentID
			END
			CLOSE c4
			DEALLOCATE c4
			
			SET @Code4Query = 'DELETE #ClassificationAux'
			IF LEN(@Code4NotIn) > 0
			BEGIN
				SET @Code4NotIn = LEFT(@Code4NotIn, LEN(@Code4NotIn)-1)
				SET @Code4Query = @Code4Query + ' WHERE ClassificationID NOT IN (' + @Code4NotIn + ')'
				SET @Code4Query = @Code4Query + ' AND ClassificationID NOT IN (' + @Code4NotInChild + ')'
			END
			EXEC sp_ExecuteSQL @Code4Query
		END

		/* If code 5 is filled remove all that is different from this criteria */
		IF LEN(@Code5) > 0 
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 4 AND Code LIKE @Code5)
		END
	
		/* If description is filled remove all that is different from this criteria */
		IF LEN(@Description) > 0
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Description LIKE @Description)
		END
		
		/* Return classifications for criteria */	
		SELECT ClassificationID FROM #ClassificationAux

	END

END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel3 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel3 Error on Creation'
GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationLevel4
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[ClassificationSelectByClassificationLevel4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[ClassificationSelectByClassificationLevel4]
GO

CREATE     PROCEDURE [OW].[ClassificationSelectByClassificationLevel4]
(
	@Code4 varchar(50) = NULL,
	@Code5 varchar(50) = NULL,
	@Description varchar(250) = NULL
)
AS
BEGIN
	/* Level = 3 */
	/* If code 4 is filled remove all that is different from this criteria */
	IF LEN(@Code4) > 0
	BEGIN
		/* Initialize value for this level */
		DECLARE @ParentID int
		SET @ParentID = NULL
	
		/* Create temporary table for classifications */
		CREATE TABLE #ClassificationAux(
			ClassificationID int,
			ParentID int,
			Level smallint,
			Code varchar(50),
			Description varchar(250),
			Global bit,
			Scope smallint)
	
		/* Insert into temporary table classifications with this criteria */	
		INSERT INTO #ClassificationAux
		SELECT ClassificationID, 
			ParentID,
			Level,
			Code,
			Description,
			Global,
			Scope 
		FROM OW.tblClassification
		WHERE Level = 3 AND Code LIKE @Code4
	
		/* Create a cursor for classifications with this criteria */
		DECLARE c4 CURSOR FOR	
			SELECT ClassificationID FROM OW.tblClassification
			WHERE Level = 3 AND Code LIKE @Code4
		OPEN c4
		FETCH NEXT FROM c4 INTO @ParentID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @ParentID IS NOT NULL
			BEGIN
				/* Insert into temporary table child classifications for this classification */
				INSERT INTO #ClassificationAux
				SELECT * FROM OW.fnClassificationSelectByClassificationParentID (@ParentID)
			END
			FETCH NEXT FROM c4 INTO @ParentID
		END
		CLOSE c4
		DEALLOCATE c4
	
		/* If code 5 is filled remove all that is different from this criteria */
		IF LEN(@Code5) > 0 
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Level = 4 AND Code LIKE @Code5)
		END
	
		/* If description is filled remove all that is different from this criteria */
		IF LEN(@Description) > 0
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Description LIKE @Description)
		END
		
		/* Return classifications for criteria */	
		SELECT ClassificationID FROM #ClassificationAux

	END

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel4 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel4 Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationLevel5
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[ClassificationSelectByClassificationLevel5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[ClassificationSelectByClassificationLevel5]
GO

CREATE PROCEDURE [OW].[ClassificationSelectByClassificationLevel5]
(
	@Code5 varchar(50) = NULL,
	@Description varchar(250) = NULL
)
AS
BEGIN
	/* Level = 4 */
	/* If code 5 is filled remove all that is different from this criteria */
	IF LEN(@Code5) > 0
	BEGIN
		/* Create temporary table for classifications */
		CREATE TABLE #ClassificationAux(
			ClassificationID int,
			ParentID int,
			Level smallint,
			Code varchar(50),
			Description varchar(250),
			Global bit,
			Scope smallint)
	
		/* Insert into temporary table classifications with this criteria */	
		INSERT INTO #ClassificationAux
		SELECT ClassificationID, 
			ParentID,
			Level,
			Code,
			Description,
			Global,
			Scope 
		FROM OW.tblClassification
		WHERE Level = 4 AND Code LIKE @Code5
	
		/* If description is filled remove all that is different from this criteria */
		IF LEN(@Description) > 0
		BEGIN
			DELETE #ClassificationAux
			WHERE ClassificationID NOT IN (
				SELECT ClassificationID FROM #ClassificationAux
				WHERE Description LIKE @Description)
		END
		
		/* Return classifications for criteria */	
		SELECT ClassificationID FROM #ClassificationAux

	END

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel5 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationLevel5 Error on Creation'
GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ClassificationSelectByClassificationValues
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[OW].[ClassificationSelectByClassificationValues]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [OW].[ClassificationSelectByClassificationValues]
GO

CREATE   PROCEDURE [OW].[ClassificationSelectByClassificationValues]
(
	@Code1 varchar(50) = NULL,
	@Code2 varchar(50) = NULL,
	@Code3 varchar(50) = NULL,
	@Code4 varchar(50) = NULL,
	@Code5 varchar(50) = NULL,
	@Description varchar(250) = NULL
)
AS
BEGIN
	
	/* Level 0 */
	IF LEN(@Code1) > 0
	BEGIN
		EXEC OW.ClassificationSelectByClassificationLevel1 @Code1,@Code2,@Code3,@Code4,@Code5,@Description
		RETURN 
	END
	
	/* Level 1 */
	IF LEN(@Code2) > 0
	BEGIN
		EXEC OW.ClassificationSelectByClassificationLevel2 @Code2,@Code3,@Code4,@Code5,@Description
		RETURN 
	END
	
	/* Level 2 */
	IF LEN(@Code3) > 0
	BEGIN
		EXEC OW.ClassificationSelectByClassificationLevel3 @Code3,@Code4,@Code5,@Description
		RETURN
	END
	
	/* Level 3 */
	IF LEN(@Code4) > 0
	BEGIN
		EXEC OW.ClassificationSelectByClassificationLevel4 @Code4,@Code5,@Description
		RETURN
	END
	
	/* Level 4 */
	IF LEN(@Code5) > 0
	BEGIN
		EXEC OW.ClassificationSelectByClassificationLevel5 @Code5,@Description
		RETURN
	END
	
	/* Description */
	IF LEN(@Description) > 0
	BEGIN
		/* Return classifications for criteria */
		SELECT ClassificationID FROM OW.tblClassification WHERE Description LIKE @Description
		RETURN
	END

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationValues Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ClassificationSelectByClassificationValues Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - SetRegistryHierarchySuperiorsAccess
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].SetRegistryHierarchySuperiorsAccess') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].SetRegistryHierarchySuperiorsAccess;
GO


CREATE  PROCEDURE [OW].SetRegistryHierarchySuperiorsAccess
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
	DECLARE @HasHierarchyGroupAccess tinyint
	DECLARE @HasHierarchySuperiorsAccess tinyint
	
	SET @HierarchyIDs = ''
	SET @RegistryExists = 0
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
		-- Dados do grupo hierarquico do utilizador
		-- ----------------------------------------------------------------------------------------------------
		SELECT @PrimaryGroupID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
		-- ----------------------------------------------------------------------------------------------------
		-- Verifica se existem acessos definidos para o grupo do interveniente e para os superiores hierarquicos para o processo
		-- ----------------------------------------------------------------------------------------------------
		IF @ProcessID IS NOT NULL
		BEGIN
	
			SELECT @HasHierarchyGroupAccess = 1 FROM OW.tblProcessAccess WHERE ProcessID = @ProcessID AND AccessObject = 32 AND ProcessDataAccess = 4
	
			SELECT @HasHierarchySuperiorsAccess = 1 FROM OW.tblProcessAccess WHERE ProcessID = @ProcessID AND AccessObject = 64 AND ProcessDataAccess = 4
	
		END	
	
		-- ----------------------------------------------------------------------------------------------------
		-- Dados dos grupos hierarquicos do grupo primario do utilizador
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
		-- Se não tem acesso definido pelo grupo hierarquico nao adiciona o grupo qd existe processo
		-- ----------------------------------------------------------------------------------------------------
		IF @ProcessID IS NOT NULL AND @HasHierarchyGroupAccess = 0
			SET @PrimaryGroupID = NULL
	
		-- ----------------------------------------------------------------------------------------------------
		-- Insere acessos para o registo para os que nao existem ainda
		-- ----------------------------------------------------------------------------------------------------
		INSERT OW.tblAccessReg 
			SELECT TAUX.UserID, TAUX.ObjectID, TAUX.ObjectType, TAUX.HierarchicalUserID FROM OW.tblAccessReg  AR RIGHT OUTER JOIN 
				(SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
				WHERE UserID = @UserID
				UNION
				SELECT GroupID AS UserID, @RegistryID AS ObjectID, 2 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblGroups 
				WHERE GroupID = @PrimaryGroupID
				UNION
				SELECT UserID AS UserID, @RegistryID AS ObjectID, 1 AS ObjectType, 0 AS HierarchicalUserID FROM OW.tblUser 
				WHERE PrimaryGroupID IN (SELECT st.Item FROM OW.StringToTable(@HierarchyIDs,',') st) AND GroupHead = 1) TAUX
				ON (AR.UserID = TAUX.UserID AND AR.ObjectID=TAUX.ObjectID AND AR.ObjectType =TAUX.ObjectType)
			WHERE
				AR.UserID IS NULL
			

	END

END

GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - FlowRoutingSelect
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingSelect;
GO

CREATE PROCEDURE [OW].FlowRoutingSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-06-2006 11:59:28
	--Version: 1.2	
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

	SELECT
		[FlowRoutingID],
		[OrganizationalUnitID],
		[StartDate],
		[EndDate],
		[FlowID],
		[ToOrganizationalUnitID],
		[Absence],
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
		(@Absence IS NULL OR [Absence] = @Absence) AND
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

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - FlowRoutingSelectPaging
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingSelectPaging;
GO

CREATE PROCEDURE [OW].FlowRoutingSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-06-2006 11:59:28
	--Version: 1.1	
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
	IF(@Absence IS NOT NULL) SET @WHERE = @WHERE + '([Absence] = @Absence) AND '
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
		@Absence bit, 
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
		@Absence, 
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
		[Absence], 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowRoutingSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowRoutingSelectPaging Error on Creation'
GO

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - FlowRoutingSelectUpdate
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingUpdate;
GO

CREATE PROCEDURE [OW].FlowRoutingUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-06-2006 11:59:28
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowRoutingID int,
	@OrganizationalUnitID int,
	@StartDate datetime,
	@EndDate datetime,
	@FlowID int = NULL,
	@ToOrganizationalUnitID int,
	@Absence bit,
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
		[Absence] = @Absence,
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


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - FlowRoutingInsert
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingInsert;
GO

CREATE PROCEDURE [OW].FlowRoutingInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-06-2006 11:59:28
	--Version: 1.1	
	------------------------------------------------------------------------
	@FlowRoutingID int = NULL OUTPUT,
	@OrganizationalUnitID int,
	@StartDate datetime,
	@EndDate datetime,
	@FlowID int = NULL,
	@ToOrganizationalUnitID int,
	@Absence bit,
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
		[Absence],
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
		@Absence,
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

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - FlowRoutingDelete
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowRoutingDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowRoutingDelete;
GO

CREATE PROCEDURE [OW].FlowRoutingDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-06-2006 11:59:28
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





IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventNotificationSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventNotificationSelect;
GO

CREATE PROCEDURE [OW].ProcessEventNotificationSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-07-2006 12:16:41
	--Version: 1.2	
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

	SELECT
		[ProcessEventNotificationID],
		[ProcessEventID],
		[UserID],
		[NotificationDate],
		[MessageID],
		[Status],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessEventNotification]
	WHERE
		(@ProcessEventNotificationID IS NULL OR [ProcessEventNotificationID] = @ProcessEventNotificationID) AND
		(@ProcessEventID IS NULL OR [ProcessEventID] = @ProcessEventID) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@NotificationDate IS NULL OR [NotificationDate] = @NotificationDate) AND
		(@MessageID IS NULL OR [MessageID] LIKE @MessageID) AND
		(@Status IS NULL OR [Status] = @Status) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventNotificationSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventNotificationSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventNotificationSelectPaging') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventNotificationSelectPaging;
GO

CREATE PROCEDURE [OW].ProcessEventNotificationSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-07-2006 12:16:41
	--Version: 1.1	
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
	
	IF(@ProcessEventNotificationID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessEventNotificationID] = @ProcessEventNotificationID) AND '
	IF(@ProcessEventID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessEventID] = @ProcessEventID) AND '
	IF(@UserID IS NOT NULL) SET @WHERE = @WHERE + '([UserID] = @UserID) AND '
	IF(@NotificationDate IS NOT NULL) SET @WHERE = @WHERE + '([NotificationDate] = @NotificationDate) AND '
	IF(@MessageID IS NOT NULL) SET @WHERE = @WHERE + '([MessageID] LIKE @MessageID) AND '
	IF(@Status IS NOT NULL) SET @WHERE = @WHERE + '([Status] = @Status) AND '
	IF(@Remarks IS NOT NULL) SET @WHERE = @WHERE + '([Remarks] LIKE @Remarks) AND '
	IF(@InsertedBy IS NOT NULL) SET @WHERE = @WHERE + '([InsertedBy] LIKE @InsertedBy) AND '
	IF(@InsertedOn IS NOT NULL) SET @WHERE = @WHERE + '([InsertedOn] = @InsertedOn) AND '
	IF(@LastModifiedBy IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedBy] LIKE @LastModifiedBy) AND '
	IF(@LastModifiedOn IS NOT NULL) SET @WHERE = @WHERE + '([LastModifiedOn] = @LastModifiedOn) AND '	
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	DECLARE @SELECT nvarchar(4000)
	
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(ProcessEventNotificationID) 
	FROM [OW].[tblProcessEventNotification]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
	WHERE ProcessEventNotificationID IN (
		SELECT TOP ' + @SizeString + ' ProcessEventNotificationID
			FROM [OW].[tblProcessEventNotification]
			WHERE ProcessEventNotificationID NOT IN (
				SELECT TOP ' + @PrevString + ' ProcessEventNotificationID 
				FROM [OW].[tblProcessEventNotification]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[ProcessEventNotificationID], 
		[ProcessEventID], 
		[UserID], 
		[NotificationDate], 
		[MessageID], 
		[Status], 
		[Remarks], 
		[InsertedBy], 
		[InsertedOn], 
		[LastModifiedBy], 
		[LastModifiedOn]
	FROM [OW].[tblProcessEventNotification]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventNotificationSelectPaging Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventNotificationSelectPaging Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventNotificationUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventNotificationUpdate;
GO

CREATE PROCEDURE [OW].ProcessEventNotificationUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-07-2006 12:16:41
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessEventNotificationID int,
	@ProcessEventID int,
	@UserID int,
	@NotificationDate datetime,
	@MessageID varchar(50) = NULL,
	@Status tinyint,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblProcessEventNotification]
	SET
		[ProcessEventID] = @ProcessEventID,
		[UserID] = @UserID,
		[NotificationDate] = @NotificationDate,
		[MessageID] = @MessageID,
		[Status] = @Status,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[ProcessEventNotificationID] = @ProcessEventNotificationID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventNotificationUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventNotificationUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventNotificationInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventNotificationInsert;
GO

CREATE PROCEDURE [OW].ProcessEventNotificationInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-07-2006 12:16:41
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessEventNotificationID int = NULL OUTPUT,
	@ProcessEventID int,
	@UserID int,
	@NotificationDate datetime,
	@MessageID varchar(50) = NULL,
	@Status tinyint,
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
	INTO [OW].[tblProcessEventNotification]
	(
		[ProcessEventID],
		[UserID],
		[NotificationDate],
		[MessageID],
		[Status],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessEventID,
		@UserID,
		@NotificationDate,
		@MessageID,
		@Status,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @ProcessEventNotificationID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventNotificationInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventNotificationInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessEventNotificationDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessEventNotificationDelete;
GO

CREATE PROCEDURE [OW].ProcessEventNotificationDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 27-07-2006 12:16:41
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessEventNotificationID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblProcessEventNotification]
	WHERE
		[ProcessEventNotificationID] = @ProcessEventNotificationID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessEventNotificationDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessEventNotificationDelete Error on Creation'
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ProcessDeleteEx01
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDeleteEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDeleteEx01;
GO


CREATE PROCEDURE [OW].ProcessDeleteEx01
(
	@ProcessID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	/* Eliminação das Referências para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessReference]
	WHERE
		[ProcessReferedID] = @ProcessID

	/* Eliminação das Referências do processo a eliminar */
	DELETE 
	FROM [OW].[tblProcessReference] 
	WHERE 
		[processEventID] IN 
		(SELECT [processEventID] FROM [OW].[tblProcessEvent]
		WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID)

	/* Eliminação dos alertas associados ao processo */
	DELETE
	FROM [OW].[tblAlert]
	WHERE
		[ProcessID] = @ProcessID

	/* Eliminação dos endereçamentos dos alarmes associados ao processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAlarmAddressee]
	WHERE
		[ProcessAlarmID] IN
		(SELECT [ProcessAlarmID] FROM [OW].[tblProcessAlarm]
		WHERE [OW].[tblProcessAlarm].[ProcessID] = @ProcessID)

	/* Eliminação dos alarmes em queue */
	DELETE
	FROM [OW].[tblAlarmQueue]
	WHERE
		[ProcessAlarmID] IN
		(SELECT [ProcessAlarmID] FROM [OW].[tblProcessAlarm]
		WHERE [OW].[tblProcessAlarm].[ProcessID] = @ProcessID)

	/* Eliminação dos alarmes para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE
		[ProcessID] = @ProcessID

	/* Eliminação das Referências para as etapas do processo a eliminar (Pelo comando anterior, não seria necessário efectuar) */
	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE
		[ProcessStageID] IN
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage]
		WHERE [OW].[tblProcessStage].[ProcessID] = @ProcessID)

	/* Eliminação dos acessos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAccess]
	WHERE
		[ProcessID] = @ProcessID

	/* Eliminação dos acessos do documento para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDocumentAccess]
	WHERE
		[ProcessDocumentID] IN
		(SELECT [ProcessDocumentID] FROM [OW].[tblProcessDocument]
		WHERE [OW].[tblProcessDocument].[ProcessEventID] IN
			(SELECT [ProcessEventID] FROM [OW].[tblProcessEvent]
			WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID))
 
	/* Eliminação dos documentos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDocument]
	WHERE
		[ProcessEventID] IN
		(SELECT [ProcessEventID] FROM [OW].[tblProcessEvent]
		WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID)
		
	/* Eliminação das notificações para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessEventNotification]
	WHERE
		[ProcessEventID] IN
		(SELECT [ProcessEventID] FROM [OW].[tblProcessEvent]
		WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID)		
		
	/* Eliminação dos campos do template associado aos campos do processo a eliminar */
	DELETE
	FROM [OW].[tblDocumentTemplateField]
	WHERE
		[ProcessDynamicFieldID] IN
		(SELECT [ProcessDynamicFieldID] FROM [OW].[tblProcessDynamicField]
		WHERE [OW].[tblProcessDynamicField].[ProcessID] = @ProcessID)		

	/* Eliminação dos valores dos campos definidos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDynamicFieldValue]
	WHERE
		[ProcessDynamicFieldID] IN
		(SELECT [ProcessDynamicFieldID] FROM [OW].[tblProcessDynamicField]
		WHERE [OW].[tblProcessDynamicField].[ProcessID] = @ProcessID)

	/* Eliminação das configurações dos campos nas etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStageDynamicField]
	WHERE
		[ProcessDynamicFieldID] IN
		(SELECT [ProcessDynamicFieldID] FROM [OW].[tblProcessDynamicField]
		WHERE [OW].[tblProcessDynamicField].[ProcessID] = @ProcessID)

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


	/* Eliminação dos eventos das etapas do processo a eliminar (Pelo comando anterior, não seria necessário efectuar) */
	DELETE
	FROM [OW].[tblProcessEvent]
	WHERE
		[ProcessStageID] IN
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage]
		WHERE [OW].[tblProcessStage].[ProcessID] = @ProcessID)

	/* Eliminação dos acessos definidos para as etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStageAccess]
	WHERE
		[ProcessStageID] IN
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage]
		WHERE [OW].[tblProcessStage].[ProcessID] = @ProcessID)

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
	RETURN @Err
END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDeleteEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDeleteEx01 Error on Creation'
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Actualização das tabelas de acessos
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckIsIntervenientHierarchicSuperiors') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckIsIntervenientHierarchicSuperiors;
GO

CREATE  PROCEDURE [OW].CheckIsIntervenientHierarchicSuperiors
(
	@UserID int,
	@ProcessID int,
	@IsIntervenientHierarchicSuperiors tinyint output
)
AS
BEGIN

	DECLARE @HierarchyID int
	DECLARE @HierarchicSuperiorsID int

	SET @IsIntervenientHierarchicSuperiors = COALESCE(@IsIntervenientHierarchicSuperiors, 0)

	DECLARE cursor_ciihs CURSOR FOR

	SELECT DISTINCT 
		CASE WHEN OW.tblOrganizationalUnit.UserID IS NOT NULL THEN OW.tblUser.PrimaryGroupID ELSE OW.tblGroups.HierarchyID END AS HierarchyID
	FROM 
		OW.tblProcess INNER JOIN 
		OW.tblProcessEvent ON OW.tblProcess.ProcessID = OW.tblProcessEvent.ProcessID INNER JOIN
		OW.tblOrganizationalUnit ON OW.tblProcessEvent.OrganizationalUnitID = OW.tblOrganizationalUnit.OrganizationalUnitID LEFT OUTER JOIN 
		OW.tblUser ON OW.tblUser.UserID = OW.tblOrganizationalUnit.UserID LEFT OUTER JOIN 
		OW.tblGroups ON OW.tblGroups.GroupID = OW.tblorganizationalUnit.GroupID
	WHERE 
		OW.tblProcess.ProcessID = @ProcessID

	OPEN cursor_ciihs
	FETCH NEXT FROM cursor_ciihs INTO @HierarchyID
	WHILE @@FETCH_STATUS = 0
	BEGIN
			
		IF @IsIntervenientHierarchicSuperiors = 0
		BEGIN
			SELECT @HierarchicSuperiorsID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
			
			IF EXISTS(SELECT 1 FROM OW.tblUser WHERE PrimaryGroupID = @HierarchicSuperiorsID AND UserID = @UserID)	
			BEGIN
				SET @IsIntervenientHierarchicSuperiors = 1	
				CLOSE cursor_ciihs
				DEALLOCATE cursor_ciihs
				RETURN
			END

		END
	   	FETCH NEXT FROM cursor_ciihs INTO @HierarchyID
	END
	CLOSE cursor_ciihs
	DEALLOCATE cursor_ciihs

	RETURN

END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckIsIntervenientHierarchicSuperiors Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckIsIntervenientHierarchicSuperiors Error on Creation'
GO






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

	declare @ProcessOwnerID int
	declare @HierarchyID int

	declare @PrimaryGroupID int
	declare @GroupHead int

	declare @OriginatorID int
	declare @OriginatorGroupHierarchyID int
	declare @IntervenientGroupHierarchyID int

	declare @Originator bit
	declare @OriginatorGroup bit
	declare @OriginatorHierarchicSuperiors bit
	declare @Intervenient bit
	declare @IntervenientGroup bit
	declare @IntervenientHierarchicSuperiors bit

	SET @ProcessDataAccess = COALESCE(@ProcessDataAccess, 1)
	SET @DynamicFieldAccess = COALESCE(@DynamicFieldAccess, 1)
	SET @DocumentAccess = COALESCE(@DocumentAccess, 1)
	SET @DispatchAccess = COALESCE(@DispatchAccess, 1)
	
	-- ----------------------------------------------------------------------------------------------------
	-- Dados do grupo hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT @PrimaryGroupID = PrimaryGroupID, @GroupHead = GroupHead FROM OW.tblUser WHERE UserID = @UserID

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
		p.OriginatorID, 
		u1.PrimaryGroupID, 
		gu.GroupID, 
		ou.UserID,
		u2.PrimaryGroupID AS UserPrimaryGroupID
	INTO #Process
	FROM 
		OW.tblProcess p INNER JOIN 
		OW.tblUser u1 ON p.OriginatorID = u1.UserID INNER JOIN 
		OW.tblProcessEvent pe ON p.ProcessID = pe.ProcessID INNER JOIN 
		OW.tblOrganizationalUnit ou ON pe.OrganizationalUnitID = ou.OrganizationalUnitID LEFT OUTER JOIN 
		OW.tblGroups g ON u1.PrimaryGroupID = g.GroupID LEFT OUTER JOIN 
		OW.tblGroupsUsers gu ON u1.UserID = gu.UserID LEFT OUTER JOIN 
		OW.tblUser u2 ON ou.UserID = u2.UserID
	WHERE 
		p.ProcessID = @ProcessID AND 
		ou.UserID IS NOT NULL

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
	IF EXISTS(SELECT 1 FROM #Process WHERE PrimaryGroupID = @PrimaryGroupID AND PrimaryGroupID IS NOT NULL)
		SET @OriginatorGroup = 1	
	ELSE
		SET @OriginatorGroup = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é Superior Hierarquico do originador
	-- ----------------------------------------------------------------------------------------------------
	SET @OriginatorHierarchicSuperiors = 0

	IF @GroupHead = 1
	BEGIN	
		SELECT @OriginatorGroupHierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @PrimaryGroupID
		
		WHILE @OriginatorGroupHierarchyID IS NOT NULL
		BEGIN
			IF @OriginatorHierarchicSuperiors = 0
			BEGIN
				IF EXISTS(SELECT 1 FROM OW.tblUser WHERE PrimaryGroupID = @OriginatorGroupHierarchyID AND UserID = @UserID)	
					SET @OriginatorHierarchicSuperiors = 1	
				ELSE	
					SET @OriginatorHierarchicSuperiors = 0
		
				SELECT @OriginatorGroupHierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @OriginatorGroupHierarchyID
			END
		END 	
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE UserID = @UserID)
		SET @Intervenient = 1	
	ELSE
		SET @Intervenient = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é o grupo do interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE UserPrimaryGroupID = @PrimaryGroupID AND UserPrimaryGroupID IS NOT NULL)
		SET @IntervenientGroup = 1	
	ELSE
		SET @IntervenientGroup = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é Superior Hierarquico do interveniente
	-- ----------------------------------------------------------------------------------------------------
	SET @IntervenientHierarchicSuperiors = 0
	
 	IF @GroupHead = 1
		EXEC OW.CheckIsIntervenientHierarchicSuperiors @UserID, @ProcessID, @IntervenientHierarchicSuperiors output

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
	-- Verifica o acesso pelo Grupo do Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN	
		IF @IntervenientGroup = 1 
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 32
		END
	END
	ELSE RETURN	
		
	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Superior Hierarquico do Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @IntervenientHierarchicSuperiors = 1
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 64
		END	
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
		@ProcessDataAccess = CASE @ProcessDataAccess WHEN 1 THEN ProcessDataAccess ELSE CASE ProcessDataAccess WHEN 2 THEN ProcessDataAccess ELSE @ProcessDataAccess END END,
		@DynamicFieldAccess = CASE @DynamicFieldAccess WHEN 1 THEN DynamicFieldAccess ELSE CASE DynamicFieldAccess WHEN 2 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END END,
		@DocumentAccess = CASE @DocumentAccess WHEN 1 THEN DocumentAccess ELSE CASE DocumentAccess WHEN 2 THEN DocumentAccess ELSE @DocumentAccess END END,
		@DispatchAccess = CASE @DispatchAccess WHEN 1 THEN DispatchAccess ELSE CASE DispatchAccess WHEN 2 THEN DispatchAccess ELSE @DispatchAccess END END		
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

CREATE  PROCEDURE [OW].CheckProcessStageAccess
(
	@ProcessStageID int,
	@UserID int,
	@DocumentAccess tinyint output,
	@DispatchAccess tinyint output
)
AS
BEGIN

	declare @ProcessID int
	declare @ProcessOwnerID int
	declare @HierarchyID int
	declare @PrimaryGroupID int
	declare @GroupHead int


	declare @OriginatorID int
	declare @OriginatorGroupHierarchyID int
	declare @IntervenientGroupHierarchyID int

	declare @Originator bit
	declare @OriginatorGroup bit
	declare @OriginatorHierarchicSuperiors bit
	declare @Intervenient bit
	declare @IntervenientGroup bit
	declare @IntervenientHierarchicSuperiors bit

	SET @DocumentAccess = COALESCE(@DocumentAccess, 1)
	SET @DispatchAccess = COALESCE(@DispatchAccess, 1)

	-- ----------------------------------------------------------------------------------------------------
	-- Identificador do Processo
	-- ----------------------------------------------------------------------------------------------------
	SELECT @ProcessID = ProcessID FROM OW.tblProcessStage WHERE ProcessStageID = @ProcessStageID

	-- ----------------------------------------------------------------------------------------------------
	-- Dados do grupo hierarquico do utilizador
	-- ----------------------------------------------------------------------------------------------------
	SELECT @PrimaryGroupID = PrimaryGroupID, @GroupHead = GroupHead FROM OW.tblUser WHERE UserID = @UserID

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
		p.OriginatorID, 
		u1.PrimaryGroupID, 
		gu.GroupID, 
		ou.UserID,
		u2.PrimaryGroupID AS UserPrimaryGroupID
	INTO #Process
	FROM 
		OW.tblProcess p INNER JOIN 
		OW.tblUser u1 ON p.OriginatorID = u1.UserID INNER JOIN 
		OW.tblProcessEvent pe ON p.ProcessID = pe.ProcessID INNER JOIN 
		OW.tblOrganizationalUnit ou ON pe.OrganizationalUnitID = ou.OrganizationalUnitID LEFT OUTER JOIN 
		OW.tblGroups g ON u1.PrimaryGroupID = g.GroupID LEFT OUTER JOIN 
		OW.tblGroupsUsers gu ON u1.UserID = gu.UserID LEFT OUTER JOIN 
		OW.tblUser u2 ON ou.UserID = u2.UserID
	WHERE 
		p.ProcessID = @ProcessID AND 
		ou.UserID IS NOT NULL

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
	IF EXISTS(SELECT 1 FROM #Process WHERE PrimaryGroupID = @PrimaryGroupID AND PrimaryGroupID IS NOT NULL)
		SET @OriginatorGroup = 1	
	ELSE
		SET @OriginatorGroup = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é Superior Hierarquico do originador
	-- ----------------------------------------------------------------------------------------------------
	SET @OriginatorHierarchicSuperiors = 0

	IF @GroupHead = 1
	BEGIN
		SELECT @OriginatorGroupHierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @PrimaryGroupID
		
		WHILE @OriginatorGroupHierarchyID IS NOT NULL
		BEGIN
			IF @OriginatorHierarchicSuperiors = 0
			BEGIN
				IF EXISTS(SELECT 1 FROM OW.tblUser WHERE PrimaryGroupID = @OriginatorGroupHierarchyID AND UserID = @UserID)	
					SET @OriginatorHierarchicSuperiors = 1	
				ELSE	
					SET @OriginatorHierarchicSuperiors = 0
		
				SELECT @OriginatorGroupHierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @OriginatorGroupHierarchyID
			END
		END 	
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE UserID = @UserID)
		SET @Intervenient = 1	
	ELSE
		SET @Intervenient = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é o grupo do interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF EXISTS(SELECT 1 FROM #Process WHERE UserPrimaryGroupID = @PrimaryGroupID AND UserPrimaryGroupID IS NOT NULL)
		SET @IntervenientGroup = 1	
	ELSE
		SET @IntervenientGroup = 0

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica se é Superior Hierarquico do interveniente
	-- ----------------------------------------------------------------------------------------------------
	SET @IntervenientHierarchicSuperiors = 0

	IF @GroupHead = 1
		EXEC OW.CheckIsIntervenientHierarchicSuperiors @UserID, @ProcessID, @IntervenientHierarchicSuperiors output	

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
	-- Verifica o acesso pelo Grupo do Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN	
		IF @IntervenientGroup = 1 
		BEGIN
			SELECT 
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessStageAccess 
			WHERE AccessObject = 32
		END
	END
	ELSE RETURN			
		
	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Superior Hierarquico do Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @DocumentAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @IntervenientHierarchicSuperiors = 1
		BEGIN
			SELECT 
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessStageAccess 
			WHERE AccessObject = 64
		END	
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
		@DocumentAccess = CASE @DocumentAccess WHEN 1 THEN DocumentAccess ELSE CASE DocumentAccess WHEN 2 THEN DocumentAccess ELSE @DocumentAccess END END,
		@DispatchAccess = CASE @DispatchAccess WHEN 1 THEN DispatchAccess ELSE CASE DispatchAccess WHEN 2 THEN DispatchAccess ELSE @DispatchAccess END END		
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



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTER TABLE tblParameter
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

ALTER TABLE [OW].[tblParameter]
	DROP CONSTRAINT [CK_tblParameter01]
GO
ALTER TABLE [OW].[tblParameter] ADD CONSTRAINT [CK_tblParameter01] CHECK ([ParameterID] >= 1 and [ParameterID] <= 14)
GO


DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy='Administrador OfficeWorks', @InsertedOn=getdate(), @LastModifiedBy='Administrador OfficeWorks', @LastModifiedOn=getdate()

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(11, 'Segurança: Login do utilizador com privilégios de administração no WebServer',  1, 0,  NULL, NULL, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(12, 'Segurança: Password do utilizador com privilégios de administração no WebServer',  4, 0,  NULL, NULL, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(13, 'Segurança: Login do utilizador com privilégios de escrita no FileServer',  1, 0,  NULL, NULL, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(14, 'Segurança: Password do utilizador com privilégios de escrita no FileServer',  4, 0,  NULL, NULL, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
GO







--
-- FECHAR TODOS OS PROCESSOS QUE TÊM TODAS AS ETAPAS CONCLUIDAS
--
UPDATE OW.tblprocess  
SET OW.tblprocess.ProcessStatus = 4, OW.tblprocess.enddate = GETDATE()

WHERE 
	OW.tblprocess.processstatus = 1
AND
	OW.tblprocess.processid NOT IN(

					SELECT DISTINCT AllEvents.processid 
						FROM
						(SELECT * FROM OW.tblprocessevent 
							WHERE
							routingtype in (1,2,32,64,128)
						) AllEvents
						LEFT OUTER JOIN
						(SELECT * FROM OW.tblprocessevent 
							WHERE
							routingtype in (1,2,32,64,128)
							AND
							processeventstatus = 8
						) Eventsend 
						ON (AllEvents.processeventid = Eventsend.processeventid)
					WHERE 
						Eventsend.processeventid IS NULL

					)
GO



-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.2.0' WHERE id= 1