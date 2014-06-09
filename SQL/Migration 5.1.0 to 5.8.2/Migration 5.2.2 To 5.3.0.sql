-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.2.2 PARA A VERSÃO 5.3.0
--
-- CONTROLO DE VERSÕES DE DOCUMENTOS
-- ---------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------
--
-- 1. CRIAÇÃO DOS CAMPOS PARA O ACESSO DE EDITAR DOCUMENTOS NOS PROCESSOS
--
-- ---------------------------------------------------------------------------------

-- Apagar a tabela tblProcessDocumentAccess porque não está a ser usada

-- Adicionar a coluna EditDocuments na tabela tblFlowStage
-- Actualizar os procedimentos

-- Adicionar a coluna EditDocuments na tabela tblProcessStage
-- Actualizar os procedimentos

-- Adicionar a coluna DocumentEditAccess na tabela tblProcessAccess
-- Actualizar os procedimentos

-- Actualizar procedimentos comuns às 3 tabelas: CheckProcessStageAccess, CheckProcessAccess





-- ---------------------------------------------------------------------------------
-- 2. SIMPLIFICAR O PROCEDIMENTO DE MIGRAÇÃO DOS DOCUMENTOS:
--    APAGAR DOCUMENTOS DA tblFileManager QUE NÃO SÃO REFERENCIADOS 
--    E TERMINAR COM A REFERENCIA DA tblElectronicMailDocuments
-- ---------------------------------------------------------------------------------

-- Apagar as linhas da tblFileManager que não estejam a ser referenciadas pelas 4 tabelas:
-- tblProcessDocument, tblDocumentTemplate, tblRegistryDocuments e tblElectronicMailDocuments

-- A tabela tblElectronicMailDocuments deixa de ter a coluna FileID e passa a ter
-- a coluna DocumentName. A coluna FileId apenas está a ser usada para se ir buscar 
-- o nome do documento que foi anexado, o que faz com que o documento tivesse de continuar
-- a existir na tblFileManager mesmo depois de apagado do registo.




-- ---------------------------------------------------------------------------------
--
-- 3. MIGRAR OS DOCUMENTOS DA tblFileManager PARA A tblDocument E tblDocumentVersion 
--    ACTUALIZAR REFERENCIAS E PROCEDIMENTOS
-- ---------------------------------------------------------------------------------


-- Novas tabelas tblDocument e tblDocumentVersion
-- Copiar tblFileManager para tblDocument e tblDocumentVersion
-- Novos procedimentos da tblDocument e tblDocumentVersion


-- Alterar na tabela tblProcessDocument a coluna FileID para DocumentVersionID
-- Replicar os documentos que foram distribuidos para processos.
-- Actualizar os procedimentos
-- Actualizar o procedimento: CheckProcessDocumentAccess
-- Actualizar o procedimento:ProcessDeleteEx01 para não usar a tabela tblProcessDocumentAccess
-- e apagar os documentos da tblDocument e tblDocumentVersion

-- Novos procedimentos

-- Adicionar FK da tblDocumentTemplate para a tblDocument

-- Adicionar FK da tblRegistryDocument para a tblDocument

-- Apagar procedimentos e funções da tblFileManager
-- Apagar a tabela tblFileManager





-- ---------------------------------------------------------------------------------
--
-- 4. Outras funcionalidades e correcção de erros
-- 
-- ---------------------------------------------------------------------------------

-- DEFECT 927 - Mover registos para outro espaço físico

-- DEFECT 916 - Pesquisa Registo > Pesquisar por * nas Palavra-chave

-- DEFECT 919 - Visualizar documentos de registos em historico





PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.2.2 PARA 5.3.0'
PRINT ''
GO

SET NOCOUNT ON 



-- ---------------------------------------------------------------------------------
--
-- 1. CRIAÇÃO DOS CAMPOS PARA O ACESSO DE EDITAR DOCUMENTOS NOS PROCESSOS
--
-- ---------------------------------------------------------------------------------

--
-- A tabela tblProcessDocumentAccess não está a ser usada !
--
DROP PROCEDURE OW.ProcessDocumentAccessInsert
GO
DROP PROCEDURE OW.ProcessDocumentAccessDelete
GO
DROP PROCEDURE OW.ProcessDocumentAccessUpdate
GO
DROP PROCEDURE OW.ProcessDocumentAccessSelect
GO
DROP PROCEDURE OW.ProcessDocumentAccessSelectPaging
GO
DROP TABLE OW.tblProcessDocumentAccess
GO






















--
-- Adicinar coluna de acesso de Editar Documento em tblFlowStage
--


-- Apagar constraints e indices

ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	FK_tblFlowStage_tblDocumentTemplate
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	FK_tblFlowStages_tblFlow
GO


ALTER TABLE OW.tblProcessStageAccess DROP CONSTRAINT 
	FK_tblProcessStageAccess_tblFlowStage
GO
ALTER TABLE OW.tblProcessStageDynamicField DROP CONSTRAINT 
	FK_tblProcessStageDynamicField_tblFlowStage
GO
ALTER TABLE OW.tblProcessAlarm DROP CONSTRAINT 
	FK_tblProcessAlarm_tblFlowStage01
GO
ALTER TABLE OW.tblProcessAlarm DROP CONSTRAINT 
	FK_tblProcessAlarm_tblFlowStage02
GO

ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	PK_tblFlowStage
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	AK_tblFlowStage01
GO

DROP INDEX OW.tblFlowStage.IX_TBLFLOWSTAGE01
GO


ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage01
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage02
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage03
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage04
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage05
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage06
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage07
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage08
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage09
GO
ALTER TABLE OW.tblFlowStage DROP CONSTRAINT 
	CK_tblFlowStage10
GO



-- Renomear a tabela
EXECUTE sp_rename N'OW.tblFlowStage', N'TMP_tblFlowStage', 'OBJECT'
GO


-- Criar nova tabela, constraints e indices

create table OW.tblFlowStage (
   FlowStageID          int                  identity
      constraint CK_tblFlowStage01 check (FlowStageID >= 1),
   FlowID               int                  not null,
   Number               smallint             not null
      constraint CK_tblFlowStage02 check (Number >= 1),
   Description          varchar(50)          not null,
   Duration             int                  not null
      constraint CK_tblFlowStage03 check (Duration >= 0),
   Address              varchar(255)         null,
   Method               varchar(50)          null,
   FlowStageType        smallint             not null
      constraint CK_tblFlowStage04 check (FlowStageType in (1,2,4,8)),
   DocumentTemplateID   int                  null,
   OrganizationalUnitID int                  null,
   CanAssociateProcess  bit                  not null,
   Transfer             tinyint              not null
      constraint CK_tblFlowStage05 check (Transfer in (1,2,4)),
   RequestForComments   tinyint              not null
      constraint CK_tblFlowStage06 check (RequestForComments in (1,2,4)),
   AttachmentRequired   bit                  not null,
   EditDocuments        tinyint              not null
      constraint CK_tblFlowStage11 check (EditDocuments in (1,2,4)),
   HelpAddress          varchar(255)         null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFlowStage primary key  (FlowStageID),
   constraint AK_tblFlowStage01 unique (FlowStageID, FlowID),
   constraint CK_tblFlowStage07 check (FlowStageType = 4 AND DocumentTemplateID IS NOT NULL OR FlowStageType <> 4 AND DocumentTemplateID IS NULL)
)
go


ALTER TABLE [OW].[tblFlowStage] ADD 
	CONSTRAINT [CK_tblFlowStage08] CHECK ([FlowStageType] = 1 and [OrganizationalUnitID] is not null or [FlowStageType] <> 1 and [OrganizationalUnitID] is null)
GO

ALTER TABLE [OW].[tblFlowStage] ADD 
	CONSTRAINT [CK_tblFlowStage09] CHECK ([FlowStageType] in(1, 2) and [Address] is not null or [FlowStageType] not in(1, 2) and [Address] is null)
GO

ALTER TABLE [OW].[tblFlowStage] ADD 
	CONSTRAINT [CK_tblFlowStage10] CHECK ([FlowStageType] = 2 and [Method] is not null or [FlowStageType] <> 2 and [Method] is null)
GO



create unique  index IX_TBLFLOWSTAGE01 on OW.tblFlowStage (
FlowID,
Number
)
go

alter table OW.tblFlowStage
   add constraint FK_tblFlowStage_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
      on delete cascade
go

alter table OW.tblFlowStage
   add constraint FK_tblFlowStage_tblDocumentTemplate foreign key (DocumentTemplateID)
      references OW.tblDocumentTemplate (DocumentTemplateID)
go


-- Copiar dados da tabela antiga para a nova
SET IDENTITY_INSERT OW.tblFlowStage ON
GO
insert into OW.tblFlowStage 
( 
FlowStageID, FlowID, Number, Description, Duration,
Address, Method, FlowStageType, DocumentTemplateID, OrganizationalUnitID,
CanAssociateProcess, Transfer, RequestForComments, AttachmentRequired, EditDocuments,
HelpAddress,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
)
select
FlowStageID, FlowID, Number, Description, Duration,
Address, Method, FlowStageType, DocumentTemplateID, OrganizationalUnitID,
CanAssociateProcess, Transfer, RequestForComments, AttachmentRequired, 1 as EditDocuments,
HelpAddress,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
from OW.TMP_tblFlowStage
GO
SET IDENTITY_INSERT OW.tblFlowStage OFF
GO

-- Apagar a tabela antiga
drop table OW.TMP_tblFlowStage
GO


-- FK para a tblFlowStage
alter table OW.tblProcessStageAccess
   add constraint FK_tblProcessStageAccess_tblFlowStage foreign key (FlowStageID)
      references OW.tblFlowStage (FlowStageID)
go

alter table OW.tblProcessStageDynamicField
   add constraint FK_tblProcessStageDynamicField_tblFlowStage foreign key (FlowStageID)
      references OW.tblFlowStage (FlowStageID)
go

alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblFlowStage01 foreign key (FlowStageID)
      references OW.tblFlowStage (FlowStageID)
go

alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblFlowStage02 foreign key (FlowStageID, FlowID)
      references OW.tblFlowStage (FlowStageID, FlowID)
go


-- Novos procedimentos e funções


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowStageSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowStageSelect;
GO

CREATE PROCEDURE [OW].FlowStageSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 31-10-2006 14:33:33
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
		[EditDocuments],
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
		(@EditDocuments IS NULL OR [EditDocuments] = @EditDocuments) AND
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
	--Updated: 31-10-2006 14:33:33
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
	@EditDocuments tinyint = NULL,
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
	IF(@EditDocuments IS NOT NULL) SET @WHERE = @WHERE + '([EditDocuments] = @EditDocuments) AND '
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
		@EditDocuments tinyint, 
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
		@EditDocuments, 
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
		[EditDocuments], 
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
	--Updated: 31-10-2006 14:33:33
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
	@EditDocuments tinyint,
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
		[EditDocuments] = @EditDocuments,
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
	--Updated: 31-10-2006 14:33:33
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
	@EditDocuments tinyint,
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
		[EditDocuments],
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
		@EditDocuments,
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
	--Updated: 31-10-2006 14:33:33
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




















--
-- Adicinar coluna de acesso de Editar Documento em tblProcessStage
--


-- Apagar constraints e indices

ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	FK_tblProcessStage_tblDocumentTemplate
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	FK_tblProcessStage_tblOrganizationalUnit
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	FK_tblProcessStage_tblProcess
GO

ALTER TABLE OW.tblProcessStageAccess DROP CONSTRAINT 
	FK_tblProcessStageAccess_tblProcessStage
GO
ALTER TABLE OW.tblAlert DROP CONSTRAINT 
	FK_tblAlert_tblProcessStage
GO
ALTER TABLE OW.tblProcessAlarm DROP CONSTRAINT
	FK_tblProcessAlarm_tblProcessStage01
GO
ALTER TABLE OW.tblProcessAlarm DROP CONSTRAINT
	FK_tblProcessAlarm_tblProcessStage02
GO
ALTER TABLE OW.tblProcessEvent DROP CONSTRAINT 
	FK_tblProcessEvent_tblProcessStage
GO
ALTER TABLE OW.tblProcessEvent DROP CONSTRAINT 
	FK_tblProcessEvent_tblProcessStage01
GO
ALTER TABLE OW.tblProcessEvent DROP CONSTRAINT
	FK_tblProcessEvent_tblProcessStage02
GO
ALTER TABLE OW.tblProcessStageDynamicField DROP CONSTRAINT 
	FK_tblProcessStageDynamicField_tblProcessStage
GO

ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	PK_tblProcessStage
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	AK_tblProcessStage01
GO



ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage01
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage02
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage03
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage04
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage05
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage06
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage07
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage08
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage09
GO
ALTER TABLE OW.tblProcessStage DROP CONSTRAINT 
	CK_tblProcessStage10
GO



-- Renomear a tabela
EXECUTE sp_rename N'OW.tblProcessStage', N'TMP_tblProcessStage', 'OBJECT'
GO


-- Criar nova tabela, constraints e indices

create table OW.tblProcessStage (
   ProcessStageID       int                  identity
      constraint CK_tblProcessStage01 check (ProcessStageID >= 1),
   ProcessID            int                  not null,
   Number               smallint             not null
      constraint CK_tblProcessStage02 check (Number >= 1),
   Description          varchar(50)          not null,
   Duration             int                  not null
      constraint CK_tblProcessStage03 check (Duration >= 0),
   Address              varchar(255)         null,
   Method               varchar(50)          null,
   FlowStageType        smallint             not null
      constraint CK_tblProcessStage04 check (FlowStageType in (1,2,4,8)),
   DocumentTemplateID   int                  null,
   OrganizationalUnitID int                  null,
   CanAssociateProcess  bit                  not null,
   Transfer             tinyint              not null
      constraint CK_tblProcessStage05 check (Transfer in (1,2,4)),
   RequestForComments   tinyint              not null
      constraint CK_tblProcessStage06 check (RequestForComments in (1,2,4)),
   AttachmentRequired   bit                  not null,
   EditDocuments        tinyint              not null
      constraint CK_tblProcessStage11 check (EditDocuments in (1,2,4)),
   HelpAddress          varchar(255)         null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessStage primary key  (ProcessStageID),
   constraint AK_tblProcessStage01 unique (ProcessStageID, ProcessID),
   constraint CK_tblProcessStage07 check (FlowStageType = 4 AND DocumentTemplateID IS NOT NULL OR FlowStageType <> 4 AND DocumentTemplateID IS NULL)
)
go


ALTER TABLE [OW].[tblProcessStage] ADD 
	CONSTRAINT [CK_tblProcessStage08] CHECK ([FlowStageType] = 1 and [OrganizationalUnitID] is not null or [FlowStageType] <> 1 and [OrganizationalUnitID] is null)
GO

ALTER TABLE [OW].[tblProcessStage] ADD 
	CONSTRAINT [CK_tblProcessStage09] CHECK ([FlowStageType] in(1, 2) and [Address] is not null or [FlowStageType] not in(1, 2) and [Address] is null)
GO

ALTER TABLE [OW].[tblProcessStage] ADD 
	CONSTRAINT [CK_tblProcessStage10] CHECK ([FlowStageType] = 2 and [Method] is not null or [FlowStageType] <> 2 and [Method] is null)
GO


create unique index IX_TBLPROCESSSTAGE01 on OW.tblProcessStage (
ProcessID,
Number
)
go 



alter table OW.tblProcessStage
   add constraint FK_tblProcessStage_tblDocumentTemplate foreign key (DocumentTemplateID)
      references OW.tblDocumentTemplate (DocumentTemplateID)
go


alter table OW.tblProcessStage
   add constraint FK_tblProcessStage_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessStage
   add constraint FK_tblProcessStage_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


-- Copiar dados da tabela antiga para a nova
SET IDENTITY_INSERT OW.tblProcessStage ON
GO
insert into OW.tblProcessStage 
( 
ProcessStageID, ProcessID, Number, Description, Duration,
Address, Method, FlowStageType, DocumentTemplateID, OrganizationalUnitID,
CanAssociateProcess, Transfer, RequestForComments, AttachmentRequired, EditDocuments,
HelpAddress,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
)
select
ProcessStageID, ProcessID, Number, Description, Duration,
Address, Method, FlowStageType, DocumentTemplateID, OrganizationalUnitID,
CanAssociateProcess, Transfer, RequestForComments, AttachmentRequired, 1 as EditDocuments,
HelpAddress,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
from OW.TMP_tblProcessStage
GO
SET IDENTITY_INSERT OW.tblProcessStage OFF
GO

-- Apagar a tabela antiga
drop table OW.TMP_tblProcessStage
GO


-- FK para a tblProcessStage
alter table OW.tblProcessStageAccess
   add constraint FK_tblProcessStageAccess_tblProcessStage foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go
alter table OW.tblProcessStageDynamicField
   add constraint FK_tblProcessStageDynamicField_tblProcessStage foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go
alter table OW.tblAlert
   add constraint FK_tblAlert_tblProcessStage foreign key (ProcessStageID, ProcessID)
      references OW.tblProcessStage (ProcessStageID, ProcessID)
go
alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblProcessStage01 foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go
alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblProcessStage02 foreign key (ProcessStageID, ProcessID)
      references OW.tblProcessStage (ProcessStageID, ProcessID)
go
--ALTER TABLE OW.tblProcessEvent
--   ADD CONSTRAINT FK_tblProcessEvent_tblProcessStage FOREIGN KEY (ProcessStageID)
--      REFERENCES OW.tblProcessStage (ProcessStageID)
--GO
alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcessStage01 foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go
alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcessStage02 foreign key (ProcessStageID, ProcessID)
      references OW.tblProcessStage (ProcessStageID, ProcessID)
go


-- Novos procedimentos e funções

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessStageSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessStageSelect;
GO

CREATE PROCEDURE [OW].ProcessStageSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 31-10-2006 18:31:55
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
		[EditDocuments],
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
		(@EditDocuments IS NULL OR [EditDocuments] = @EditDocuments) AND
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
	--Updated: 31-10-2006 18:31:55
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
	@EditDocuments tinyint = NULL,
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
	IF(@EditDocuments IS NOT NULL) SET @WHERE = @WHERE + '([EditDocuments] = @EditDocuments) AND '
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
		@EditDocuments tinyint, 
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
		@EditDocuments, 
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
		[EditDocuments], 
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
	--Updated: 31-10-2006 18:31:55
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
	@EditDocuments tinyint,
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
		[EditDocuments] = @EditDocuments,
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
	--Updated: 31-10-2006 18:31:55
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
	@EditDocuments tinyint,
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
		[EditDocuments],
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
		@EditDocuments,
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
	--Updated: 31-10-2006 18:31:55
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




























--
-- Adicinar coluna de acesso de Editar Documento no Processo
--


-- Apagar constraints e indices
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	PK_tblProcessAccess
GO

ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	FK_tblProcessAccess_tblFlow
GO

ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	FK_tblProcessAccess_tblOrganizationalUnit
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	FK_tblProcessAccess_tblProcess
GO

DROP INDEX OW.tblProcessAccess.IX_TBLPROCESSACCESS01
GO

ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess01
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess02
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess03
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess04
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess05
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess06
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess07
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess08
GO
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT 
	CK_tblProcessAccess09
GO



-- Renomear a tabela
EXECUTE sp_rename N'OW.tblProcessAccess', N'TMP_tblProcessAccess', 'OBJECT'
GO


-- Criar nova tabela, constraints e indices

create table OW.tblProcessAccess (
   ProcessAccessID      int                  identity
      constraint CK_tblProcessAccess01 check (ProcessAccessID >= 1),
   FlowID               int                  null,
   ProcessID            int                  null,
   OrganizationalUnitID int                  null,
   AccessObject         tinyint              not null
      constraint CK_tblProcessAccess02 check (AccessObject in (1,2,4,8,16,32,64)),
   StartProcess         tinyint              not null
      constraint CK_tblProcessAccess03 check (StartProcess in (1,2,4)),
   ProcessDataAccess    tinyint              not null
      constraint CK_tblProcessAccess04 check (ProcessDataAccess in (1,2,4)),
   DynamicFieldAccess   tinyint              not null
      constraint CK_tblProcessAccess05 check (DynamicFieldAccess in (1,2,4)),
   DocumentAccess       tinyint              not null
      constraint CK_tblProcessAccess06 check (DocumentAccess in (1,2,4)),
   DocumentEditAccess   tinyint              not null
      constraint CK_tblProcessAccess10 check (DocumentEditAccess in (1,2,4)),
   DispatchAccess       tinyint              not null
      constraint CK_tblProcessAccess07 check (DispatchAccess in (1,2,4)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessAccess primary key  nonclustered (ProcessAccessID)
)
go

ALTER TABLE [OW].[tblProcessAccess] ADD 
	CONSTRAINT [CK_tblProcessAccess08] CHECK ([FlowID] is not null and [ProcessID] is null or [FlowID] is null and [ProcessID] is not null),
	CONSTRAINT [CK_tblProcessAccess09] CHECK ([AccessObject] <> 1 and [OrganizationalUnitID] is null or [AccessObject] = 1 and [OrganizationalUnitID] is not null)
GO

alter table OW.tblProcessAccess
   add constraint FK_tblProcessAccess_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
      on delete cascade
go


alter table OW.tblProcessAccess
   add constraint FK_tblProcessAccess_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessAccess
   add constraint FK_tblProcessAccess_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go

create unique clustered index IX_TBLPROCESSACCESS01 on OW.tblProcessAccess (
FlowID,
ProcessID,
OrganizationalUnitID,
AccessObject
)
go



-- Copiar dados da tabela antiga para a nova
SET IDENTITY_INSERT OW.tblProcessAccess ON
GO
insert into OW.tblProcessAccess 
( 
ProcessAccessID, FlowID, ProcessID, OrganizationalUnitID, AccessObject,
StartProcess, ProcessDataAccess, DynamicFieldAccess, DocumentAccess, DocumentEditAccess, DispatchAccess,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
)
select
ProcessAccessID, FlowID, ProcessID, OrganizationalUnitID, AccessObject,
StartProcess, ProcessDataAccess, DynamicFieldAccess, DocumentAccess, 1 as DocumentEditAccess, DispatchAccess,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
from OW.TMP_tblProcessAccess
GO
SET IDENTITY_INSERT OW.tblProcessAccess OFF
GO

-- Apagar a tabela antiga
drop table OW.TMP_tblProcessAccess
GO


-- Novos procedimentos e funções
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessAccessSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessAccessSelect;
GO

CREATE PROCEDURE [OW].ProcessAccessSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 23-10-2006 19:01:53
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
		[DocumentEditAccess],
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
		(@DocumentEditAccess IS NULL OR [DocumentEditAccess] = @DocumentEditAccess) AND
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
	--Updated: 23-10-2006 19:01:53
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
	@DocumentEditAccess tinyint = NULL,
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
	IF(@DocumentEditAccess IS NOT NULL) SET @WHERE = @WHERE + '([DocumentEditAccess] = @DocumentEditAccess) AND '
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
		@DocumentEditAccess tinyint, 
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
		@DocumentEditAccess, 
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
		[DocumentEditAccess], 
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
	--Updated: 23-10-2006 19:01:53
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
	@DocumentEditAccess tinyint,
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
		[DocumentEditAccess] = @DocumentEditAccess,
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
	--Updated: 23-10-2006 19:01:53
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
	@DocumentEditAccess tinyint,
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
		[DocumentEditAccess],
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
		@DocumentEditAccess,
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
	--Updated: 23-10-2006 19:01:53
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


















--
-- Procedimentos comuns às 2 tabelas: CheckProcessStageAccess, CheckProcessAccess
--

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
	@DocumentEditAccess tinyint output,
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
	SET @DocumentEditAccess = COALESCE(@DocumentEditAccess, 1)
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
		SET @DocumentEditAccess = 4
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
	OW.tblProcessAccess.DocumentEditAccess,
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
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN
		SELECT 
		@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
		@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
		@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
		@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
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
		@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
		@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
		FROM #ProcessAccess 
		WHERE AccessObject = 2
	END

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Grupo do Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN	
		IF @OriginatorGroup = 1 
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 4
		END
	END
	ELSE RETURN	

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Superior Hierarquico do Originador
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @OriginatorHierarchicSuperiors = 1
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 8
		END	
	END
	ELSE RETURN

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @Intervenient = 1
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 16
		END	
	END
	ELSE RETURN

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Grupo do Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN	
		IF @IntervenientGroup = 1 
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 32
		END
	END
	ELSE RETURN	
		
	-- ----------------------------------------------------------------------------------------------------
	-- Verifica o acesso pelo Superior Hierarquico do Interveniente
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN
		IF @IntervenientHierarchicSuperiors = 1
		BEGIN
			SELECT 
			@ProcessDataAccess = CASE WHEN @ProcessDataAccess = 1 THEN ProcessDataAccess ELSE @ProcessDataAccess END,
			@DynamicFieldAccess = CASE WHEN @DynamicFieldAccess = 1 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END,
			@DocumentAccess = CASE WHEN @DocumentAccess = 1 THEN DocumentAccess ELSE @DocumentAccess END,
			@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
			@DispatchAccess = CASE WHEN @DispatchAccess = 1 THEN DispatchAccess ELSE @DispatchAccess END
			FROM #ProcessAccess 
			WHERE AccessObject = 64
		END	
	END
	ELSE RETURN

	-- ----------------------------------------------------------------------------------------------------
	-- Verificação hierarquica dos grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
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
				@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
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
	IF @ProcessDataAccess = 1 OR @DynamicFieldAccess = 1 OR @DocumentAccess = 1 OR @DocumentEditAccess = 1 OR @DispatchAccess = 1
	BEGIN
		SELECT
		@ProcessDataAccess = CASE @ProcessDataAccess WHEN 1 THEN ProcessDataAccess ELSE CASE ProcessDataAccess WHEN 2 THEN ProcessDataAccess ELSE @ProcessDataAccess END END,
		@DynamicFieldAccess = CASE @DynamicFieldAccess WHEN 1 THEN DynamicFieldAccess ELSE CASE DynamicFieldAccess WHEN 2 THEN DynamicFieldAccess ELSE @DynamicFieldAccess END END,
		@DocumentAccess = CASE @DocumentAccess WHEN 1 THEN DocumentAccess ELSE CASE DocumentAccess WHEN 2 THEN DocumentAccess ELSE @DocumentAccess END END,
		@DocumentEditAccess = CASE WHEN @DocumentEditAccess = 1 THEN DocumentEditAccess ELSE @DocumentEditAccess END,
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
		exec OW.CheckProcessAccess @ProcessID, @UserID, 4, 4, @DocumentAccess output, 4, @DispatchAccess output
	END

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessStageAccess Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessStageAccess Error on Creation'
GO



















-- ---------------------------------------------------------------------------------
-- 2. SIMPLIFICAR O PROCEDIMENTO DE MIGRAÇÃO DOS DOCUMENTOS:
--    APAGAR DOCUMENTOS DA tblFileManager QUE NÃO SÃO REFERENCIADOS 
--    E TERMINAR COM A REFERENCIA DA tblElectronicMailDocuments
-- ---------------------------------------------------------------------------------





-- apagar referencias do registo para documentos que não existem
delete from OW.tblRegistryDocuments
where not exists ( select 1 from OW.tblFileManager
		   where OW.tblFileManager.FileID = OW.tblRegistryDocuments.FileID
)
GO 



-- apagar referencias para documentos que não existem
delete from OW.tblDocumentTemplate
where not exists ( select 1 from OW.tblFileManager
		   where OW.tblFileManager.FileID = OW.tblDocumentTemplate.FileID
)
GO




-- apagar os anexos na mensagem de correio que já não existem como documentos no OfficeWorks
delete from OW.tblElectronicMailDocuments
where not exists ( select 1 from OW.tblFileManager
		   where OW.tblFileManager.FileID = 
			OW.tblElectronicMailDocuments.FileID
)
GO

-- apagar os anexos na mensagem de correio que estão orfãos da tblElectronicMail
delete from OW.tblElectronicMailDocuments
where not exists ( select 1 from OW.tblElectronicMail
		   where OW.tblElectronicMail.MailID = 
			OW.tblElectronicMailDocuments.MailID
)
GO


-- Apagar as linhas da tblFileManager que não estejam a ser referenciadas pelas 4 tabelas:
-- tblProcessDocument, tblDocumentTemplate, tblRegistryDocuments e tblElectronicMailDocuments

delete from OW.tblFileManager
where 
not exists ( select 1 from OW.tblRegistryDocuments RD
	     where OW.tblFileManager.FileID = RD.FileID
	   )
and
not exists ( select 1 from OW.tblElectronicMailDocuments EMD
	     where OW.tblFileManager.FileID = EMD.FileID
	   )
and
not exists ( select 1 from OW.tblProcessDocument PD
	     where OW.tblFileManager.FileID = PD.DocumentID
	   )
and
not exists ( select 1 from OW.tblDocumentTemplate DT
	     where OW.tblFileManager.FileID = DT.FileID
	   )
GO




-- A tabela tblElectronicMailDocuments deixa de ter a coluna FileID e passa a ter
-- a coluna DocumentName. A coluna FileId apenas está a ser usada para se ir buscar 
-- o nome do documento que foi anexado, o que faz com que o documento tivesse de continuar
-- a existir na tblFileManager mesmo depois de apagado do registo.


-- apagar os anexos na mensagem de correio que já não existem como documentos no OfficeWorks
--delete from OW.tblElectronicMailDocuments
--where not exists ( select 1 from OW.tblFileManager
--		   where OW.tblFileManager.FileID = 
--			OW.tblElectronicMailDocuments.FileID
--)
--GO

-- apagar os anexos na mensagem de correio que estão orfãos da tblElectronicMail
--delete from OW.tblElectronicMailDocuments
--where not exists ( select 1 from OW.tblElectronicMail
--		   where OW.tblElectronicMail.MailID = 
--			OW.tblElectronicMailDocuments.MailID
--)
--GO

alter table OW.tblElectronicMailDocuments
	add DocumentName    varchar(300)  null
GO

update OW.tblElectronicMailDocuments set DocumentName = FM.FileName
from OW.tblFileManager FM
inner join OW.tblElectronicMailDocuments
on OW.tblElectronicMailDocuments.FileID = FM.FileID
GO

alter table OW.tblElectronicMailDocuments 
	drop constraint PK_tblElectronicMailDocuments
GO

alter table OW.tblElectronicMailDocuments
	drop column FileID
GO

alter table OW.tblElectronicMailDocuments
	alter column  DocumentName    varchar(300)  not null
GO

alter table OW.tblElectronicMailDocuments
   add constraint FK_tblElectronicMailDocuments_tblElectronicMail foreign key (MailID)
      references OW.tblElectronicMail (MailID) on delete cascade
GO

ALTER TABLE OW.tblElectronicMailDocuments ADD CONSTRAINT
	PK_tblElectronicMailDocuments PRIMARY KEY CLUSTERED 
	(
	MailID, DocumentName
	) ON [PRIMARY]
GO


-- Alterar procedimentos

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_GetElectronicMail') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_GetElectronicMail;
GO

CREATE PROCEDURE OW.usp_GetElectronicMail
	(
		@MailID numeric(18,0)
	)
AS
	
SELECT tm.MailID, tm.FromUserID, tm.Subject, tm.SendDate, tm.Message, tmd.Origin,tmd.Type,tmd.UserID,
tu.userID AS ToUserID,
(select userDesc from OW.tblUser where userID = tm.FromUserID) as FromUserDesc,
tu.UserMail,
(CASE WHEN tmd.Origin='U' THEN tu.userlogin
	ELSE tmu.eMail END) MailUser
FROM OW.tblElectronicMail tm 
	INNER JOIN OW.tblElectronicMailDestinations tmd ON (tm.MailID=tmd.MailID)
	LEFT JOIN OW.tblElectronicMailUsers tmu ON (tmd.UserID=tmu.MailUserID)
	LEFT JOIN OW.tblUser tu ON (tmd.UserID=tu.UserID)
WHERE tm.MailID=@MailID 	
ORDER BY tm.MailID

-- Ficheiros do mail
SELECT DocumentName
FROM OW.tblElectronicMailDocuments
WHERE MailID=@MailID
ORDER BY DocumentName


RETURN @@ERROR
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_GetElectronicMail Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_GetElectronicMail Error on Creation'
GO

















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_NewElectronicMail') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_NewElectronicMail;
GO

CREATE PROCEDURE OW.usp_NewElectronicMail
	(
		@FromUserID numeric(18,0),
		@Subject varchar(500),
		@Message Text,
		@DocumentName Text=null, -- Lista de nomes de documentos separados por pelo caracter '|'
		@DestUserIDTo Text=null,
		@DestUserIDCc Text=null,
		@DestUserMailTo Text=null,
		@DestUserMailCc Text=null,
		@MID numeric(18,0) output
	)
AS
DECLARE @MailID numeric(18,0)
DECLARE @MailUserID numeric(18,0)
DECLARE @ID int
DECLARE @Value varchar(4000)

SET XACT_ABORT ON

BEGIN TRANSACTION

-- ********************** Main Table Data ***********************************
	INSERT INTO OW.tblElectronicMail (FromUserID,Subject,Message)	
	VALUES (@FromUserID,@Subject,@Message)
	SET @MailID=@@IDENTITY

-- ****************************** Files *************************************
IF (@DocumentName is not null)
BEGIN
	
	INSERT OW.tblElectronicMailDocuments 
	Select @MailID, LTRIM(RTRIM(value))  from OW.fnListToTable(@DocumentName, '|')

END
-- ************************** Destinations To***********************************
IF (@DestUserIDTo is not null)
BEGIN

	DECLARE DestUsersIDTo_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserIDTo,',')

	OPEN DestUsersIDTo_cursor
	FETCH NEXT FROM DestUsersIDTo_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (Cast(@Value as numeric(18,0)),@MailID,'U','T')	
		
		FETCH NEXT FROM DestUsersIDTo_cursor INTO @ID,@Value
	END
	CLOSE DestUsersIDTo_cursor
	DEALLOCATE DestUsersIDTo_cursor
END


-- Hand writen eMail
IF (@DestUserMailTo is not null)
BEGIN

	DECLARE DestUsersMailTo_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserMailTo,',')

	OPEN DestUsersMailTo_cursor
	FETCH NEXT FROM DestUsersMailTo_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		IF NOT EXISTS (SELECT MailUserID FROM OW.tblElectronicMailUsers 
					WHERE eMail=CAST(@Value AS VARCHAR(500)))
			BEGIN
				INSERT INTO OW.tblElectronicMailUsers (eMail)
				VALUES (CAST(@Value AS VARCHAR(500)))
				SET @MailUserID=@@IDENTITY		
			END
		ELSE
			BEGIN
				SELECT @MailUserID=MailUserID FROM OW.tblElectronicMailUsers 
					WHERE eMail=CAST(@Value AS VARCHAR(500))
			END

		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (@MailUserID,@MailID,'M','T')	
		FETCH NEXT FROM DestUsersMailTo_cursor INTO @ID,@Value
	END
	CLOSE DestUsersMailTo_cursor
	DEALLOCATE DestUsersMailTo_cursor
END
-- ************************** Destinations Cc ***********************************
IF (@DestUserIDCc is not null)
BEGIN
	DECLARE DestUsersIDCc_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserIDCc,',')

	OPEN DestUsersIDCc_cursor
	FETCH NEXT FROM DestUsersIDCc_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (Cast(@Value as numeric(18,0)),@MailID,'U','C')	
		
		FETCH NEXT FROM DestUsersIDCc_cursor INTO @ID,@Value
	END
	CLOSE DestUsersIDCc_cursor
	DEALLOCATE DestUsersIDCc_cursor
END

-- Hand writen eMail
-- @DestUserMail Text
IF (@DestUserMailCc is not null)
BEGIN
	DECLARE DestUsersMailCc_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@DestUserMailCc,',')

	OPEN DestUsersMailCc_cursor
	FETCH NEXT FROM DestUsersMailCc_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
			IF NOT EXISTS (SELECT MailUserID FROM OW.tblElectronicMailUsers 
					WHERE eMail=CAST(@Value AS VARCHAR(500)))
		BEGIN
			INSERT INTO OW.tblElectronicMailUsers (eMail)
			VALUES (CAST(@Value AS VARCHAR(500)))
			SET @MailUserID=@@IDENTITY		
		END
		ELSE
		BEGIN
			SELECT @MailUserID=MailUserID FROM OW.tblElectronicMailUsers 
				WHERE eMail=CAST(@Value AS VARCHAR(500))
		END
		
		INSERT INTO OW.tblElectronicMailDestinations (UserID,MailID, Origin,Type)
		VALUES (@MailUserID,@MailID,'M','C')	
		FETCH NEXT FROM DestUsersMailCc_cursor INTO @ID,@Value
	END
	CLOSE DestUsersMailCc_cursor
	DEALLOCATE DestUsersMailCc_cursor
END
SET @MID=@MailID
COMMIT TRANSACTION
RETURN @@ERROR
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_NewElectronicMail Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_NewElectronicMail Error on Creation'
GO













-- ---------------------------------------------------------------------------------
--
-- 3. MIGRAR OS DOCUMENTOS DA tblFileManager PARA A tblDocument E tblDocumentVersion 
--    ACTUALIZAR REFERENCIAS E PROCEDIMENTOS
-- ---------------------------------------------------------------------------------



/*==============================================================*/
/* Table: tblDocument                                           */
/*==============================================================*/
create table OW.tblDocument (
   DocumentID           int                  identity,
   Name                 varchar(300)         not null
      constraint CK_tblDocument01 check (Name <> ''),
   LastDocumentVersionID int                 null,
   CheckOutByUserID     int                  null,
   CheckOutURL          varchar(300)         null,
   FinalVersion         bit                  not null
      constraint DF_tblDocument_FinalVersion default 0,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblDocument primary key  (DocumentID)
)
go

-- Se o documento estiver na versão final então não pode ser feito Check-out (CheckOutByUserID e CheckOutURL estão vazios)
ALTER TABLE OW.tblDocument ADD 
	CONSTRAINT CK_tblDocument02 CHECK (FinalVersion=0 or (CheckOutByUserID is null and CheckOutURL is null) )
GO

-- Se CheckOutURL estiver preenchido então CheckOutByUserID tem de estar preenchido
ALTER TABLE OW.tblDocument ADD 
	CONSTRAINT CK_tblDocument03 CHECK (CheckOutURL is null or CheckOutByUserID is not null) 
GO

alter table OW.tblDocument
   add constraint FK_tblDocument_tblUser foreign key (CheckOutByUserID)
      references OW.tblUser (UserID)
GO

create index IX_TBLDOCUMENT01 on OW.tblDocument (
CheckOutByUserID
)
go

create index IX_TBLDOCUMENT02 on OW.tblDocument (
LastDocumentVersionID
)
go


/*==============================================================*/
/* Table: tblDocumentVersion                                    */
/* Guarda todas as versões incluindo a última                   */
/*==============================================================*/
create table OW.tblDocumentVersion (
   DocumentVersionID    int                  identity,
   DocumentID           int                  not null,
   VersionNumber        tinyint              not null
      constraint CK_tblDocumentVersion01 check (VersionNumber >= 1),
   Pathname             varchar(300)         not null
      constraint CK_tblDocumentVersion02 check (Pathname <> ''),
   Size                 int                  null -- NULL because of old files !
      constraint CK_tblDocumentVersion03 check (Size > 0),
   UserID               int                  not null,
   Comment              varchar(300)         null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblDocumentVersion primary key  (DocumentVersionID)
)
go

create unique  index IX_TBLDOCUMENTVERSION01 on OW.tblDocumentVersion (
DocumentID,
VersionNumber
)
go

alter table OW.tblDocumentVersion
   add constraint FK_tblDocumentVersion_tblDocument foreign key (DocumentID)
      references OW.tblDocument (DocumentID) on delete cascade
GO

alter table OW.tblDocumentVersion
   add constraint FK_tblDocumentVersion_tblUser foreign key (UserID)
      references OW.tblUser (UserID)
GO

create index IX_TBLDOCUMENTVERSION02 on OW.tblDocumentVersion (
UserID
)
go


alter table OW.tblDocument
   add constraint FK_tblDocument_tblDocumentVersion foreign key (LastDocumentVersionID)
      references OW.tblDocumentVersion (DocumentVersionID)
GO



















--
-- Converter tblFileManager para tblDocument e tblDocumentVersion
--

update OW.tblFileManager set Filename='sem titulo' where Filename=''
GO

SET IDENTITY_INSERT OW.tblDocument ON
GO
insert into OW.tblDocument 
( 
DocumentID, Name, LastDocumentVersionID, 
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
)
select
FileID, FileName, NULL,
Remarks, UserLogin, CreateDate, UserLogin, CreateDate
from OW.tblFileManager inner join OW.tblUser on (CreateUserID=UserID)
GO

SET IDENTITY_INSERT OW.tblDocument OFF
GO






SET IDENTITY_INSERT OW.tblDocumentVersion ON
GO

insert into OW.tblDocumentVersion 
( 
DocumentVersionID, DocumentID, VersionNumber, Pathname, UserID,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
)
select
FileID, FileID, 1, FilePath, CreateUserID,
Remarks, UserLogin, CreateDate, UserLogin, CreateDate
from OW.tblFileManager inner join OW.tblUser on (CreateUserID=UserID)
GO

SET IDENTITY_INSERT OW.tblDocumentVersion OFF
GO

-- Actualizar os apontadores para a última versão do documento
update OW.tblDocument set LastDocumentVersionID = DocumentID
GO







  












-- Adicionar novos procedimentos
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentSelect;
GO

CREATE PROCEDURE [OW].DocumentSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-01-2007 15:08:42
	--Version: 1.2	
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

	SELECT
		[DocumentID],
		[Name],
		[LastDocumentVersionID],
		[CheckOutByUserID],
		[CheckOutURL],
		[FinalVersion],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDocument]
	WHERE
		(@DocumentID IS NULL OR [DocumentID] = @DocumentID) AND
		(@Name IS NULL OR [Name] LIKE @Name) AND
		(@LastDocumentVersionID IS NULL OR [LastDocumentVersionID] = @LastDocumentVersionID) AND
		(@CheckOutByUserID IS NULL OR [CheckOutByUserID] = @CheckOutByUserID) AND
		(@CheckOutURL IS NULL OR [CheckOutURL] LIKE @CheckOutURL) AND
		(@FinalVersion IS NULL OR [FinalVersion] = @FinalVersion) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentUpdate;
GO

CREATE PROCEDURE [OW].DocumentUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-01-2007 15:08:43
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentID int,
	@Name varchar(300),
	@LastDocumentVersionID int = NULL,
	@CheckOutByUserID int = NULL,
	@CheckOutURL varchar(300) = NULL,
	@FinalVersion bit,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblDocument]
	SET
		[Name] = @Name,
		[LastDocumentVersionID] = @LastDocumentVersionID,
		[CheckOutByUserID] = @CheckOutByUserID,
		[CheckOutURL] = @CheckOutURL,
		[FinalVersion] = @FinalVersion,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[DocumentID] = @DocumentID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentInsert;
GO

CREATE PROCEDURE [OW].DocumentInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-01-2007 15:08:43
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentID int = NULL OUTPUT,
	@Name varchar(300),
	@LastDocumentVersionID int = NULL,
	@CheckOutByUserID int = NULL,
	@CheckOutURL varchar(300) = NULL,
	@FinalVersion bit,
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
	INTO [OW].[tblDocument]
	(
		[Name],
		[LastDocumentVersionID],
		[CheckOutByUserID],
		[CheckOutURL],
		[FinalVersion],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@Name,
		@LastDocumentVersionID,
		@CheckOutByUserID,
		@CheckOutURL,
		@FinalVersion,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @DocumentID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentDelete;
GO

CREATE PROCEDURE [OW].DocumentDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 10-01-2007 15:08:43
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblDocument]
	WHERE
		[DocumentID] = @DocumentID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentDelete Error on Creation'
GO






















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentVersionSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentVersionSelect;
GO

CREATE PROCEDURE [OW].DocumentVersionSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 06-11-2006 18:17:20
	--Version: 1.2	
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

	SELECT
		[DocumentVersionID],
		[DocumentID],
		[VersionNumber],
		[Pathname],
		[Size],
		[UserID],
		[Comment],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDocumentVersion]
	WHERE
		(@DocumentVersionID IS NULL OR [DocumentVersionID] = @DocumentVersionID) AND
		(@DocumentID IS NULL OR [DocumentID] = @DocumentID) AND
		(@VersionNumber IS NULL OR [VersionNumber] = @VersionNumber) AND
		(@Pathname IS NULL OR [Pathname] LIKE @Pathname) AND
		(@Size IS NULL OR [Size] = @Size) AND
		(@UserID IS NULL OR [UserID] = @UserID) AND
		(@Comment IS NULL OR [Comment] LIKE @Comment) AND
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentVersionSelect Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentVersionSelect Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentVersionUpdate') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentVersionUpdate;
GO

CREATE PROCEDURE [OW].DocumentVersionUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 06-11-2006 18:17:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentVersionID int,
	@DocumentID int,
	@VersionNumber tinyint,
	@Pathname varchar(300),
	@Size int = NULL,
	@UserID int,
	@Comment varchar(300) = NULL,
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	UPDATE [OW].[tblDocumentVersion]
	SET
		[DocumentID] = @DocumentID,
		[VersionNumber] = @VersionNumber,
		[Pathname] = @Pathname,
		[Size] = @Size,
		[UserID] = @UserID,
		[Comment] = @Comment,
		[Remarks] = @Remarks,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[DocumentVersionID] = @DocumentVersionID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentVersionUpdate Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentVersionUpdate Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentVersionInsert') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentVersionInsert;
GO

CREATE PROCEDURE [OW].DocumentVersionInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 06-11-2006 18:17:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentVersionID int = NULL OUTPUT,
	@DocumentID int,
	@VersionNumber tinyint,
	@Pathname varchar(300),
	@Size int = NULL,
	@UserID int,
	@Comment varchar(300) = NULL,
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
	INTO [OW].[tblDocumentVersion]
	(
		[DocumentID],
		[VersionNumber],
		[Pathname],
		[Size],
		[UserID],
		[Comment],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@DocumentID,
		@VersionNumber,
		@Pathname,
		@Size,
		@UserID,
		@Comment,
		@Remarks,
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn),
		@InsertedBy,
		ISNULL(@InsertedOn, @_InsertedOn)
	)	
	SELECT @DocumentVersionID = SCOPE_IDENTITY()
	SELECT @Err = @@Error, @RowCount = @@ROWCOUNT
	IF(@RowCount = 0)	
	BEGIN	
	        RAISERROR(50001,16,1)                       	
	END 	
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentVersionInsert Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentVersionInsert Error on Creation'
GO

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentVersionDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentVersionDelete;
GO

CREATE PROCEDURE [OW].DocumentVersionDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 06-11-2006 18:17:20
	--Version: 1.1	
	------------------------------------------------------------------------
	@DocumentVersionID int = NULL,
	@LastModifiedOn datetime = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @RowCount int
	DECLARE @Err int

	DELETE
	FROM [OW].[tblDocumentVersion]
	WHERE
		[DocumentVersionID] = @DocumentVersionID
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
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentVersionDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentVersionDelete Error on Creation'
GO






IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].DocumentVersionSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].DocumentVersionSelectEx01;
GO

CREATE PROCEDURE [OW].DocumentVersionSelectEx01
(
	------------------------------------------------------------------------
	-- Obter a última versão do documento
	------------------------------------------------------------------------

	@DocumentID int

)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT
		[DocumentVersionID],
		[DocumentID],
		[VersionNumber],
		[Pathname],
		[Size],
		[UserID],
		[Comment],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblDocumentVersion]
	WHERE
		[DocumentID] = @DocumentID
		AND
		VersionNumber = (select max(VersionNumber) from [OW].[tblDocumentVersion]
				 where [DocumentID] = @DocumentID)
		
		
	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].DocumentVersionSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].DocumentVersionSelectEx01 Error on Creation'
GO












--
-- Alterar coluna DocumentID para DocumentVersionID na tblProcessDocument
--


-- Apagar constraints e indices
alter table OW.tblProcessDocument drop constraint PK_tblProcessDocument
GO
alter table OW.tblProcessDocument drop constraint CK_tblProcessDocument01
GO
alter table OW.tblProcessDocument drop constraint FK_tblProcessDocument_tblProcessEvent
GO
alter table OW.tblProcessDocument drop constraint FK_tblProcessDocument_tblFileManager
GO
drop index OW.tblProcessDocument.IX_TBLPROCESSDOCUMENT01
GO


-- Renomear a tabela
EXECUTE sp_rename N'OW.tblProcessDocument', N'TMP_tblProcessDocument', 'OBJECT'
GO


-- Criar nova tabela, constraints e indices

create table OW.tblProcessDocument (
   ProcessDocumentID    int                  identity
      constraint CK_tblProcessDocument01 check (ProcessDocumentID >= 1),
   ProcessEventID       int                  not null,
   DocumentVersionID    int                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessDocument primary key  (ProcessDocumentID)
)
go

alter table OW.tblProcessDocument
   add constraint FK_tblProcessDocument_tblDocumentVersion foreign key (DocumentVersionID)
      references OW.tblDocumentVersion (DocumentVersionID)
GO

alter table OW.tblProcessDocument
   add constraint FK_tblProcessDocument_tblProcessEvent foreign key (ProcessEventID)
      references OW.tblProcessEvent (ProcessEventID)
go

create unique  index IX_TBLPROCESSDOCUMENT01 on OW.tblProcessDocument (
ProcessEventID,
DocumentVersionID
)
go



-- Copiar dados da tabela antiga para a nova
SET IDENTITY_INSERT OW.tblProcessDocument ON
GO
insert into OW.tblProcessDocument 
( 
ProcessDocumentID, ProcessEventID, DocumentVersionID, 
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
)
select
ProcessDocumentID, ProcessEventID, DocumentID,
Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
from OW.TMP_tblProcessDocument
GO
SET IDENTITY_INSERT OW.tblProcessDocument OFF
GO

-- Apagar a tabela antiga
drop table OW.TMP_tblProcessDocument
GO

















-- Replicar os documentos que foram distribuidos para processos.
-- Quando é feita uma distribuição o documento que vai para o processo 
-- é uma referencia para o mesmo que está no Registo. 
-- A partir de agora o documento passa a ser uma cópia, por isso terão identificadores
-- diferentes.
SET XACT_ABORT ON

DECLARE @ProcessDocumentID int
DECLARE @DocumentID int

DECLARE @NewDocumentID int
DECLARE @NewDocumentVersionID int

-- Obter todos os documentos comuns
DECLARE cursor_pd CURSOR FOR 
SELECT 	PD.ProcessDocumentID, D.DocumentID --, RD.RegID
FROM    OW.tblProcessDocument PD 
	INNER JOIN OW.tblDocumentVersion DV
	ON PD.DocumentVersionID = DV.DocumentVersionID 
	INNER JOIN OW.tblDocument D
	ON DV.DocumentVersionID = D.LastDocumentVersionID 
	INNER JOIN OW.tblRegistryDocuments RD 
	ON D.DocumentID = RD.FileID

	
OPEN cursor_pd
	
FETCH NEXT FROM cursor_pd INTO @ProcessDocumentID, @DocumentID
	
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @NewDocumentID = NULL
	SET @NewDocumentVersionID = NULL

	BEGIN TRANSACTION
	
	-- Duplicar tblDocument
	insert into OW.tblDocument 
	( 
	Name, LastDocumentVersionID, CheckOutByUserID, FinalVersion,
	Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
	)
	select
	Name, LastDocumentVersionID, CheckOutByUserID, FinalVersion,
	Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
	from OW.tblDocument
	where DocumentID = @DocumentID

	SELECT @NewDocumentID = SCOPE_IDENTITY()


	-- Duplicar tblDocumentVersion
	insert into OW.tblDocumentVersion 
	( 
	DocumentID, VersionNumber, Pathname, Size, UserID, Comment,
	Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
	)
	select
	@NewDocumentID, VersionNumber, Pathname, Size, UserID, Comment,
	Remarks, InsertedBy, InsertedOn, LastModifiedBy, LastModifiedOn
	from OW.tblDocumentVersion
	where DocumentVersionID=@DocumentID

	SELECT @NewDocumentVersionID = SCOPE_IDENTITY()
	

	-- Actualizar tblDocument.LastDocumentVersionID = NewDocumentVersionID
	update OW.tblDocument set LastDocumentVersionID = @NewDocumentVersionID
	where DocumentID = @NewDocumentID

	-- Actualizar tblProcessDocument.DocumentVersionID = NewDocumentVersionID
	update OW.tblProcessDocument set DocumentVersionID = @NewDocumentVersionID
	where ProcessDocumentID = @ProcessDocumentID

	COMMIT TRANSACTION

	FETCH NEXT FROM cursor_pd INTO  @ProcessDocumentID, @DocumentID   
END
	
CLOSE cursor_pd
DEALLOCATE cursor_pd
GO


















-- Novos procedimentos e funções

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelect') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelect;
GO

CREATE PROCEDURE [OW].ProcessDocumentSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 25-10-2006 12:09:07
	--Version: 1.2	
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

	SELECT
		[ProcessDocumentID],
		[ProcessEventID],
		[DocumentVersionID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblProcessDocument]
	WHERE
		(@ProcessDocumentID IS NULL OR [ProcessDocumentID] = @ProcessDocumentID) AND
		(@ProcessEventID IS NULL OR [ProcessEventID] = @ProcessEventID) AND
		(@DocumentVersionID IS NULL OR [DocumentVersionID] = @DocumentVersionID) AND
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
	--Updated: 25-10-2006 12:09:07
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int = NULL,
	@ProcessEventID int = NULL,
	@DocumentVersionID int = NULL,
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
	IF(@DocumentVersionID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentVersionID] = @DocumentVersionID) AND '
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
		@DocumentVersionID int, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
		@ProcessDocumentID, 
		@ProcessEventID, 
		@DocumentVersionID, 
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
		[DocumentVersionID], 
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
	--Updated: 25-10-2006 12:09:07
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int,
	@ProcessEventID int,
	@DocumentVersionID int,
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
		[DocumentVersionID] = @DocumentVersionID,
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
	--Updated: 25-10-2006 12:09:07
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessDocumentID int = NULL OUTPUT,
	@ProcessEventID int,
	@DocumentVersionID int,
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
		[DocumentVersionID],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@ProcessEventID,
		@DocumentVersionID,
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
	--Updated: 25-10-2006 12:09:07
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



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelectEx01;
GO


CREATE  PROCEDURE [OW].ProcessDocumentSelectEx01
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
		PE.OrganizationalUnitID
	FROM OW.tblProcessEvent PE 
	INNER JOIN OW.tblProcessDocument PD ON PD.ProcessEventID = PE.ProcessEventID
	INNER JOIN OW.tblDocument D ON PD.DocumentVersionID = D.LastDocumentVersionID
	WHERE PE.ProcessID = @ProcessID

	SET @Err = @@Error
	RETURN @Err
END


GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx01 Error on Creation'
GO





IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelectEx02;
GO

CREATE  PROCEDURE [OW].ProcessDocumentSelectEx02
(
	------------------------------------------------------------------------
	-- Devolve todas as versões de um documento
	------------------------------------------------------------------------
	@DocumentID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT 
		PD.ProcessDocumentID,
		PD.ProcessEventID,
		PD.DocumentVersionID
	FROM OW.tblProcessDocument PD INNER JOIN OW.tblDocumentVersion DV
	ON PD.DocumentVersionID = DV.DocumentVersionID
	WHERE DV.DocumentID = @DocumentID
	ORDER BY DV.VersionNumber DESC

	SET @Err = @@Error
	RETURN @Err
END


GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx02 Error on Creation'
GO








IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelectEx03') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelectEx03;
GO


CREATE  PROCEDURE [OW].ProcessDocumentSelectEx03
(
	------------------------------------------------------------------------
	-- Devolve a ultima versão de um documento
	------------------------------------------------------------------------
	@DocumentID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


	SELECT 
		PD.ProcessDocumentID,
		PD.ProcessEventID,
		PD.DocumentVersionID
	FROM OW.tblProcessDocument PD INNER JOIN OW.tblDocument D 
	ON PD.DocumentVersionID = D.LastDocumentVersionID
	WHERE D.DocumentID = @DocumentID

	SET @Err = @@Error
	RETURN @Err
END


GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx03 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx03 Error on Creation'
GO









IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentSelectEx04') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentSelectEx04;
GO


CREATE    PROCEDURE [OW].ProcessDocumentSelectEx04
(
	------------------------------------------------------------------------
	-- Devolve os documentos em edição para um utilizador
	------------------------------------------------------------------------
	@UserID int
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
		PE.OrganizationalUnitID
	FROM OW.tblProcessEvent PE 
	INNER JOIN OW.tblProcessDocument PD ON PD.ProcessEventID = PE.ProcessEventID
	INNER JOIN OW.tblDocument D ON PD.DocumentVersionID = D.LastDocumentVersionID
	WHERE D.CheckOutByUserID = @UserID
	ORDER BY D.NAME


	SET @Err = @@Error
	RETURN @Err
END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx04 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentSelectEx04 Error on Creation'
GO




-- Actualizar o procedimento: CheckProcessDocumentAccess

IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckProcessDocumentAccess') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckProcessDocumentAccess;
GO

CREATE PROCEDURE [OW].CheckProcessDocumentAccess
(
	@DocumentVersionID int,
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
	WHERE OW.tblProcessDocument.DocumentVersionID = @DocumentVersionID
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
			exec OW.CheckProcessAccess @ProcessID, @UserID, 4, 4, @DocumentAccess output, 4, 4

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


















-- Actualizar o procedimento:ProcessDeleteEx01 para não usar a tabela tblProcessDocumentAccess
-- e apagar os documentos da tblDocument e tblDocumentVersion

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
	WHERE
		EXISTS
		(
		SELECT 1 FROM [OW].[tblProcessEvent] PE
		WHERE
		[OW].[tblProcessDocument].ProcessEventID = PE.ProcessEventID
		AND 
		PE.[ProcessID] = @ProcessID
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

	COMMIT TRANSACTION 	
	RETURN @Err
END
GO


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDeleteEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDeleteEx01 Error on Creation'
GO


















-- Novos procedimentos e funções

--DROP FUNCTION OW.CheckDocumentCheckOut
--GO
GO

-- 
-- Verifies if exists any check-out documents at process stage
-- 0 - not exists
-- 1 - exists
CREATE FUNCTION OW.CheckDocumentCheckOut(@ProcessEventID int)
RETURNS bit
AS

BEGIN
	DECLARE @Exists bit
	
	SET @Exists = 0

	SELECT @Exists = 1 FROM OW.tblProcessDocument PD
	WHERE PD.ProcessEventID = @ProcessEventID
	and 
	exists (select 1 from OW.tblDocumentVersion DV
		where PD.DocumentVersionID = DV.DocumentVersionID
		and
		exists (select 1 from OW.tblDocument D
			where DV.DocumentVersionID = D.LastDocumentVersionID
			and D.CheckOutByUserID is not null
		)  
	)


	RETURN @Exists
END
GO


-- Display the status of Function creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].CheckDocumentCheckOut Succeeded'
ELSE PRINT 'Function Creation: [OW].CheckDocumentCheckOut Error on Creation'
GO
















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentUndoCheckOut') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentUndoCheckOut;
GO

-- Undo Check-out all check-out documents in process
CREATE PROCEDURE [OW].ProcessDocumentUndoCheckOut
(
	@ProcessID int
)
AS
BEGIN

	UPDATE OW.tblDocument
	SET CheckOutByUserID = NULL
	WHERE
	exists (select 1 from OW.tblDocumentVersion DV
		where OW.tblDocument.DocumentID = DV.DocumentID
		and
		exists (select 1 from OW.tblProcessDocument PD
			where DV.DocumentVersionID = PD.DocumentVersionID
			and
			exists (select 1 from OW.tblProcessEvent PE
				where PD.ProcessEventID = PE.ProcessEventID
				and PE.ProcessID = @ProcessID
			)
		)
	)
	and  
	CheckOutByUserID is not null

END   

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentUndoCheckOut Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentUndoCheckOut Error on Creation'
GO











IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessDocumentDeleteEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessDocumentDeleteEx01;
GO

CREATE PROCEDURE [OW].ProcessDocumentDeleteEx01
(
------------------------------------------------------------------------
-- Apagar versão: (@DeleteAllVersions=0)
-- Apaga uma versão de um documento e a referencia no processo.
-- No caso de se apagar a última versão o apontador tblDocument.LastDocumentVersionID
-- é actualizado para a versão anterior.
-- Se a versão for a única é apagado também o documento.
--
-- Apagar documento: (@DeleteAllVersions=1)
-- Apaga um documento e todas as referencias das várias versões no processo.
------------------------------------------------------------------------
@ProcessDocumentID int,
@DeleteAllVersions bit
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @NumberOfVersions int
DECLARE @DocumentID int
DECLARE @DocumentVersionID int


SET XACT_ABORT ON

BEGIN TRANSACTION

-- Obter o DocumentID e DocumentVersionID
select @DocumentID = DocumentID, @DocumentVersionID = DocumentVersionID
from OW.tblDocumentVersion DV
where 
exists (select 1 from OW.tblProcessDocument PD
	where DV.DocumentVersionID = PD.DocumentVersionID
	and PD.ProcessDocumentID = @ProcessDocumentID
)

	
IF (@DeleteAllVersions = 0)
-- Delete Process Document Version
BEGIN
	
	-- Apagar a referencia para a versão do documento
	delete from OW.tblProcessDocument
	where ProcessDocumentID = @ProcessDocumentID

	-- Contar o número de versões do documento
	select @NumberOfVersions = Count(*) from OW.tblDocumentVersion DV
	where DV.DocumentID = @DocumentID

	IF (@NumberOfVersions = 1)	
	-- Se for a única versão então apagar o documento e a versão
	BEGIN
			
	        delete from OW.tblDocument where DocumentID = @DocumentID                       	
	END 

	ELSE

	BEGIN
	-- caso contrário, se não for a única versão

		-- Se for a última versão então colocar o apontador
		-- tblDocument.LastDocumentVersionID para a versão anterior
		update OW.tblDocument 
		set LastDocumentVersionID =   ( select max(DV.DocumentVersionID) 
						from OW.tblDocumentVersion DV 
						where DV.DocumentID = @DocumentID
						and DV.DocumentVersionID <> @DocumentVersionID
						)
		where DocumentID = @DocumentID
		and LastDocumentVersionID = @DocumentVersionID

		-- Apagar a versão do documento
		delete from OW.tblDocumentVersion where DocumentVersionID = @DocumentVersionID
	END
		
END

ELSE

-- Delete Process Document (All document versions)
BEGIN

	-- Apagar as referencias para todas as versões do documento
	delete from OW.tblProcessDocument
	where
 	exists (select 1 from OW.tblDocumentVersion DV
		where OW.tblProcessDocument.DocumentVersionID = DV.DocumentVersionID 
		and DV.DocumentID = @DocumentID
	)

	-- Apagar o documento e todas as versões
	delete from OW.tblDocument where DocumentID = @DocumentID

END

COMMIT TRANSACTION

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessDocumentDeleteEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessDocumentDeleteEx01 Error on Creation'
GO




















-- Adicionar FK da tblDocumentTemplate para a tblDocument
--delete from OW.tblDocumentTemplate
--where not exists (select 1 from OW.tblDocument D
--			where FileID = D.DocumentID)
--GO
-- é apagado antes de se apagarem os ficheiros na tblFileManager
-- para não ficarem ficheiros orfãos.

alter table OW.tblDocumentTemplate
   add constraint FK_tblDocumentTemplate_tblDocument foreign key (FileID)
      references OW.tblDocument (DocumentID)
GO





-- Adicionar FK na tblRegistry 

-- apagar referencias para documentos que não existem
--delete from OW.tblRegistryDocuments
--where not exists (select 1 from OW.tblDocument D
--			where OW.tblRegistryDocuments.FileID = D.DocumentID)
--GO 
-- é apagado antes de se apagarem os ficheiros na tblFileManager
-- para não ficarem ficheiros orfãos.

-- apagar referencias para registos e registos em histórico que não existem
delete from OW.tblRegistryDocuments
where not exists (select 1 from OW.tblRegistry R
			where OW.tblRegistryDocuments.RegID = R.RegID)
and not exists (select 1 from OW.tblRegistryHist RH
			where OW.tblRegistryDocuments.RegID = RH.RegID)
GO

-- adicionar nova coluna
alter table OW.tblRegistryDocuments
   add DocumentID int null
GO

-- copiar os dados de FileID para DocumentID
update OW.tblRegistryDocuments set DocumentID = FileID
GO

-- adicionar constraint NOT NULL
alter table OW.tblRegistryDocuments
	alter column  DocumentID int not null
GO

-- apagar chave primária
alter table OW.tblRegistryDocuments 
	drop constraint PK_tblRegistryDocuments
GO

-- apagar coluna antiga
alter table OW.tblRegistryDocuments
	drop column FileID
GO

-- Esta constraint não pode existir porque quando se passa um registo para
-- histórico a linha é apagada da tabela tblRegistry e dá um erro porque existem 
-- referencias de documentos para essa linha. As linhas da tblRegistryDocuments não
-- são apagadas.
--
-- adicionar chaves estrangeiras
--alter table OW.tblRegistryDocuments
--   add constraint FK_tblRegistryDocuments_tblRegistry foreign key (RegID)
--      references OW.tblRegistry (RegID)
--GO

alter table OW.tblRegistryDocuments
   add constraint FK_tblRegistryDocuments_tblDocument foreign key (DocumentID)
      references OW.tblDocument (DocumentID)
GO

-- adicionar chave primária
ALTER TABLE [OW].[tblRegistryDocuments]  
	ADD CONSTRAINT [PK_tblRegistryDocuments] PRIMARY KEY  CLUSTERED 
	(
		[RegID], [DocumentID]
	)  ON [PRIMARY] 
GO



























IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_GetRegistryFiles') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_GetRegistryFiles;
GO

CREATE PROCEDURE OW.usp_GetRegistryFiles
	(
		@RegID numeric(18,0),
		@DocumentID int = null		
	)
AS

IF @DocumentID is null 
	BEGIN
		SELECT D.DocumentID as FileID, D.Name as FileName, DV.Pathname as FilePath
		FROM OW.tblDocument D INNER JOIN OW.tblDocumentVersion DV 
		ON (D.LastDocumentVersionID = DV.DocumentVersionID)
		WHERE EXISTS (
			SELECT 1 FROM OW.tblRegistryDocuments trd
			WHERE trd.RegiD=@RegID
			AND trd.DocumentID=D.DocumentID
		)
	END
ELSE
	BEGIN
		SELECT D.DocumentID as FileID, D.Name as FileName, DV.Pathname as FilePath
		FROM OW.tblDocument D INNER JOIN OW.tblDocumentVersion DV 
		ON (D.LastDocumentVersionID = DV.DocumentVersionID)
		WHERE EXISTS (
			SELECT 1 FROM OW.tblRegistryDocuments trd
			WHERE trd.RegiD=@RegID
			AND trd.DocumentID=@DocumentID
		)

	END	
RETURN @@ERROR	

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_GetRegistryFiles Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_GetRegistryFiles Error on Creation'
GO


















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_AddFileToRegistry') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_AddFileToRegistry;
GO

CREATE PROCEDURE OW.usp_AddFileToRegistry
(
    @RegID numeric,
    @DocumentIDList varchar (8000)
)
AS
BEGIN

INSERT INTO OW.tblRegistryDocuments (RegID, DocumentID)
SELECT @RegID, DocumentIDList.Item
FROM OW.StringToTable(@DocumentIDList,',') DocumentIDList
	

END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_AddFileToRegistry Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_AddFileToRegistry Error on Creation'
GO




















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistryDocumentsDelete') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistryDocumentsDelete;
GO

CREATE PROCEDURE OW.RegistryDocumentsDelete
(
	@RegID numeric(18,0)	
)
AS
BEGIN

SET XACT_ABORT ON

BEGIN TRANSACTION

select DocumentID 
into #DocumentsToDelete
from OW.tblRegistryDocuments where RegID = @RegID

delete from OW.tblRegistryDocuments where RegID = @RegID

delete from OW.tblDocument
where exists (select 1 from #DocumentsToDelete
		where OW.tblDocument.DocumentID = #DocumentsToDelete.DocumentID 
)

COMMIT TRANSACTION
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistryDocumentsDelete Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistryDocumentsDelete Error on Creation'
GO
























IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].usp_GetDocumentReferences') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].usp_GetDocumentReferences;
GO

CREATE PROCEDURE OW.usp_GetDocumentReferences

	(
	@DocumentID numeric(18)
	)

AS

	SELECT 1 AS RefType, R.RegID AS RefID, (B.Abreviation + '-' + CAST(R.Year AS varchar(4)) + '/' + CAST(R.Number AS varchar(18)) + ' ' + R.Subject) AS Reference , R.Date
	FROM OW.tblRegistry R INNER JOIN OW.tblBooks B ON R.BookID=B.BookID
	WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments RD
				WHERE R.RegID=RD.RegID AND RD.DocumentID=@DocumentID)
	UNION
	SELECT 2 AS RefType, P.ProcessID AS RefID, (P.ProcessNumber + ' ' + P.ProcessSubject) AS Reference , P.StartDate
	FROM OW.tblProcess P
	WHERE EXISTS (SELECT 1 FROM OW.tblProcessEvent PE
			WHERE P.ProcessID=PE.ProcessID
			AND EXISTS (SELECT 1 FROM OW.tblProcessDocument PD
				WHERE PE.ProcessEventID=PD.ProcessEventID 
				AND EXISTS (SELECT 1 FROM OW.tblDocumentVersion DV
					WHERE PD.DocumentVersionID=DV.DocumentVersionID
				 	AND DV.DocumentID=@DocumentID
					)
				)
			)
	ORDER BY Date DESC

	
	RETURN @@ERROR
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].usp_GetDocumentReferences Succeeded'
ELSE PRINT 'Procedure Creation: [OW].usp_GetDocumentReferences Error on Creation'
GO

















DROP FUNCTION OW.CheckRegistryDocumentAccess
GO

CREATE FUNCTION OW.CheckRegistryDocumentAccess
	(
	@UserID int,
	@DocumentID int
	)
RETURNS bit
AS

BEGIN

	DECLARE @HaveAccess bit
	
	SET @HaveAccess = 0


	SELECT @HaveAccess = 1 FROM OW.tblRegistryDocuments RD 
	WHERE RD.DocumentID=@DocumentID
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
					FROM OW.tblAccess A
					WHERE  A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 
				) 
				OR 
				EXISTS 
				( 
					SELECT 1 
					FROM  OW.tblAccess A
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 
					AND 
					( 
						( A.ObjectType=1 AND A.UserID = @UserID ) 
						OR 
						( A.ObjectType=2 AND EXISTS( SELECT 1 
									   FROM  OW.tblGroupsUsers GU
									   WHERE A.UserID=GU.GroupID AND GU.UserID = @UserID
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

-- Display the status of Function creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].CheckRegistryDocumentAccess Succeeded'
ELSE PRINT 'Function Creation: [OW].CheckRegistryDocumentAccess Error on Creation'
GO















GO

CREATE FUNCTION OW.GetDocumentSource(@DocumentID int)
RETURNS int
AS

BEGIN
	DECLARE @Exists bit
	
	SET @Exists = 0

	-- Registry Document
	SELECT @Exists = 1 FROM OW.tblRegistryDocuments 
	WHERE DocumentID=@DocumentID

	IF (@Exists=1) RETURN 1
	

	-- Process Document
	SELECT @Exists = 1 FROM OW.tblProcessDocument PD
	WHERE exists (select 1 from OW.tblDocumentVersion DV
			where PD.DocumentVersionID = DV.DocumentVersionID
			and DV.DocumentID=@DocumentID
			)

	IF (@Exists=1) RETURN 2


	-- Process Document Template
	SELECT @Exists = 1 FROM OW.tblDocumentTemplate 
	WHERE FileID=@DocumentID

	IF (@Exists=1) RETURN 3

	RETURN 0
END
GO


-- Display the status of Function creation
IF (@@Error = 0) PRINT 'Function Creation: [OW].GetDocumentSource Succeeded'
ELSE PRINT 'Function Creation: [OW].GetDocumentSource Error on Creation'
GO

















DROP  VIEW OW.VREGISTRYEX01
GO

/*==============================================================*/
/* View: VREGISTRYEX01 */
/* - Para o HESE (esta view deve ser optimizada futuramente)*/
/*==============================================================*/
CREATE  VIEW OW.VREGISTRYEX01 AS
	--tblRegistry
	SELECT     		
		r.regid, 
		r.FisicalID, 
		'R' As 'Table',
		b.abreviation, 
		CAST(r.[year] AS varchar(4)) + '/' + CAST(r.number AS varchar(10)) As 'Number',
		r.subject, 
		CONVERT(varchar(10), r.[date], 101) As 'Date',
		rd.DocumentID
	FROM    
		OW.tblRegistry r
	INNER JOIN
		OW.tblBooks b
	ON 
		r.bookid = b.bookID 
	LEFT JOIN
		OW.tblRegistryDocuments rd
	ON r.regid = rd.RegID
UNION
	--tblRegistryHist
	SELECT     		
		r.regid, 
		r.FisicalID, 
		'H' As 'Table',
		b.abreviation, 
		CAST(r.[year] AS varchar(4)) + '/' + CAST(r.number AS varchar(10)) As 'Number', 
		r.subject, 
		CONVERT(varchar(10), r.[date], 101) As 'Date',		
		rd.DocumentID
	FROM    
		OW.tblRegistryHist r
	INNER JOIN
		OW.tblBooks b
	ON 
		r.bookid = b.bookID 
	LEFT JOIN
		OW.tblRegistryDocuments rd
	ON r.regid = rd.RegID

GO

















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectEx01;
GO

CREATE   PROCEDURE [OW].RegistrySelectEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 08-02-2006 11:48:38
	--Version: 1.0	
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

	SELECT
		[regid],
		[FisicalID],
		[Table],
		[abreviation],
		[Number],
		[subject],
		[date],
		[DocumentID]
	FROM [OW].[VREGISTRYEX01]
	WHERE
		(@regid IS NULL OR [regid] = @regid) AND
		(@FisicalID IS NULL OR [FisicalID] = @FisicalID) AND
		(@Table IS NULL OR [Table] LIKE @Table) AND
		(@abreviation IS NULL OR [abreviation] LIKE @abreviation) AND
		(@Number IS NULL OR [Number] LIKE @Number) AND
		(@subject IS NULL OR [subject] LIKE @subject) AND
		(@date IS NULL OR [date] = @date) AND
		(@DocumentID IS NULL OR [DocumentID] = @DocumentID)

	SET @Err = @@Error
	RETURN @Err
END

GO
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectEx01 Error on Creation'
GO

















IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].RegistrySelectPagingEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].RegistrySelectPagingEx01;
GO

CREATE   PROCEDURE [OW].RegistrySelectPagingEx01
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 08-02-2006 11:48:42
	--Version: 1.1	
	------------------------------------------------------------------------
	@regid numeric(18,0) = NULL,
	@FisicalID int = NULL,
	@Table varchar(1) = NULL,
	@abreviation nvarchar(20) = NULL,
	@Number varchar(15) = NULL,
	@subject nvarchar(250) = NULL,
	@date datetime = NULL,
	@DocumentID int = NULL,
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
	
	IF(@regid IS NOT NULL) SET @WHERE = @WHERE + '([regid] = @regid) AND '
	IF(@FisicalID IS NOT NULL) SET @WHERE = @WHERE + '([FisicalID] = @FisicalID) AND '
	IF(@Table IS NOT NULL) SET @WHERE = @WHERE + '([Table] LIKE @Table) AND '
	IF(@abreviation IS NOT NULL) SET @WHERE = @WHERE + '([abreviation] LIKE @abreviation) AND '
	IF(@Number IS NOT NULL) SET @WHERE = @WHERE + '([Number] LIKE @Number) AND '
	IF(@subject IS NOT NULL) SET @WHERE = @WHERE + '([subject] LIKE @subject) AND '
	IF(@date IS NOT NULL) SET @WHERE = @WHERE + '([date] = @date) AND '
	IF(@DocumentID IS NOT NULL) SET @WHERE = @WHERE + '([DocumentID] = @DocumentID) AND '
	
	SET @WHERE = (CASE WHEN LEN(@WHERE) > 0 THEN LEFT(@WHERE, LEN(@WHERE) - 4) END)
	
	
	DECLARE @SELECT nvarchar(4000)
	
	-- Select all Rows by one indexed key
	SET @SELECT = '
	SELECT @RowCount = COUNT(regid) 
	FROM [OW].[VREGISTRYEX01]
	' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END)
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT,
		N'@regid numeric(18,0), 
		@FisicalID int, 
		@Table varchar(1), 
		@abreviation nvarchar(20), 
		@Number varchar(15), 
		@subject nvarchar(250), 
		@date datetime, 
		@DocumentID int,
		@RowCount bigint OUTPUT',
		@regid, 
		@FisicalID, 
		@Table, 
		@abreviation, 
		@Number, 
		@subject, 
		@date, 
		@DocumentID,
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
	WHERE regid IN (
		SELECT TOP ' + @SizeString + ' regid
			FROM [OW].[VREGISTRYEX01]
			WHERE regid NOT IN (
				SELECT TOP ' + @PrevString + ' regid 
				FROM [OW].[VREGISTRYEX01]
				' + (CASE WHEN LEN(@WHERE) > 0 THEN 'WHERE ' + @WHERE ELSE '' END) + @SortField + '
		)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField + '
	)' + (CASE WHEN LEN(@WHERE) > 0 THEN ' AND ' + @WHERE ELSE '' END) + @SortField
	END
	
	SET @SELECT = '
	SELECT
		[regid], 
		[FisicalID], 
		[Table], 
		[abreviation], 
		[Number], 
		[subject], 
		[date], 
		[DocumentID]
	FROM [OW].[VREGISTRYEX01]
	' + @WPag
	IF(LEN(RTRIM(@SELECT)) >= 4000) 
	BEGIN
		RAISERROR('Len of SELECT is > 4000, procedure not EXECUTE.',16,1)
		RETURN
	END
	--PRINT @SELECT
	EXEC sp_executesql @SELECT, 
		N'@regid numeric(18,0), 
		@FisicalID int, 
		@Table varchar(1), 
		@abreviation nvarchar(20), 
		@Number varchar(15), 
		@subject nvarchar(250), 
		@date datetime, 
		@DocumentID int',
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
-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].RegistrySelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].RegistrySelectPagingEx01 Error on Creation'
GO




















-- Alterar o link FileDownloadEx.aspx?OPERATION=BYFILEID 
-- na mensagem da distribuição por email
update OW.tblElectronicMail
set message = replace(
	cast(message as varchar(8000)),
	'FileDownloadEx.aspx?OPERATION=BYFILEID&FILEID',
	'FileDownloadEx.aspx?OPERATION=BYDOCUMENTID&DOCUMENTID')
GO






-- Apagar procedimentos e funções da tblFileManager

drop procedure OW.usp_NewFile
GO
drop procedure OW.usp_GetFile
GO



-- Apagar a tabela que deixa de existir

drop table OW.tblFileManager
GO


















-- ---------------------------------------------------------------------------------
--
-- 4. Outras funcionalidades e correcção de erros
-- 
-- ---------------------------------------------------------------------------------

-- DEFECT 927 - Mover registos para outro espaço físico
GO

CREATE  FUNCTION OW.RegistryModifyAccess (@RegIDList varchar(8000), @UserID int)
RETURNS @Results TABLE (RegID numeric(18))
AS

BEGIN

	INSERT INTO @Results(RegID) 
	SELECT R.RegID
		FROM OW.tblRegistry R 
		WHERE 
		R.RegID IN (SELECT STT.Item FROM OW.StringToTable(@RegIDList,',') STT) AND
		EXISTS 
		(
			SELECT 1 
			FROM OW.tblBooks B 
			WHERE R.BookID=B.BookID 
			AND 
			( 
				EXISTS 
				( 
					SELECT 1 
					FROM  OW.tblAccess A
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 AND AccessType IN (6,7)
					AND 
					( 
						( A.ObjectType=1 AND A.UserID = @UserID ) 
						OR 
						( A.ObjectType=2 AND EXISTS( SELECT 1 
									   FROM  OW.tblGroupsUsers GU
									   WHERE A.UserID=GU.GroupID AND GU.UserID = @UserID
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


 	RETURN
END
GO









CREATE    FUNCTION OW.RegistryHistModifyAccess (@RegIDList varchar(8000), @UserID int)
RETURNS @Results TABLE (RegID numeric(18))
AS

BEGIN

	INSERT INTO @Results(RegID) 
	SELECT R.RegID
		FROM OW.tblRegistryHist R 
		WHERE 
		R.RegID IN (SELECT STT.Item FROM OW.StringToTable(@RegIDList,',') STT) AND
		EXISTS 
		(
			SELECT 1 
			FROM OW.tblBooks B 
			WHERE R.BookID=B.BookID 
			AND 
			( 
				EXISTS 
				( 
					SELECT 1 
					FROM  OW.tblAccess A
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 AND AccessType IN (6,7)
					AND 
					( 
						( A.ObjectType=1 AND A.UserID = @UserID ) 
						OR 
						( A.ObjectType=2 AND EXISTS( SELECT 1 
									   FROM  OW.tblGroupsUsers GU
									   WHERE A.UserID=GU.GroupID AND GU.UserID = @UserID
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


 	RETURN
END
GO








ALTER  PROCEDURE OW.RegistryUpdateFisicalSpace
	(
	@RegIDList varchar (8000),
	@FisicalID int,
	@UserID int,
	@RowsUpdated int output
	)

AS
	DECLARE @Error int

	SET @RowsUpdated = 0
		
	UPDATE OW.tblRegistry
	SET FisicalID = @FisicalID,
	UserModifyID = @UserID,
	DateModify = GETDATE()
	WHERE 
	EXISTS (SELECT 1 FROM OW.RegistryModifyAccess(@RegIDList,@UserID) RMA
		WHERE  OW.tblRegistry.RegID=RMA.RegID)
	
	SET @RowsUpdated = @@ROWCOUNT

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		RETURN @Error
	END


	UPDATE OW.tblRegistryHist
	SET FisicalID = @FisicalID,
	UserModifyID = @UserID,
	DateModify = GETDATE()
	WHERE 
	EXISTS (SELECT 1 FROM OW.RegistryHistModifyAccess(@RegIDList,@UserID) RMA
		WHERE  OW.tblRegistryHist.RegID=RMA.RegID)
	
	SET @RowsUpdated = @RowsUpdated + @@ROWCOUNT

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		RETURN @Error
	END


	RETURN 0

GO





-- DEFECT 916 - Pesquisa Registo > Pesquisar por * nas Palavra-chave
GO

ALTER  PROCEDURE OW.usp_GetKeywords
	(
		@keyID numeric=null,
		@designation varchar(50)=null,
		@global bit=null
	)
AS

DECLARE @sSQL varchar(8000)
DECLARE @sSQLWhere varchar(8000)
DECLARE @sSQLOrderBY varchar(4000)

SET @sSQLWhere=''

SET @sSQL='SELECT keyID,keyDescription,[Global] FROM OW.tblKeywords'

IF (@keyID is not null) SET  @sSQLWhere = ' keyID=' + CAST(@keyID as VARCHAR)+ ' AND '
IF (@designation is not null) SET @sSQLWhere=@sSQLWhere + ' keyDescription like ''' + @designation + ''' AND '
IF (@global is not null) SET  @sSQLWhere=@sSQLWhere + ' [Global]=' + CAST(@global as VARCHAR) + ' AND '
print @sSQLWhere
-- Remove last AND
IF LEN(@sSQLWhere)>0
BEGIN
SET @sSQLWhere = LEFT(@sSQLWhere,LEN(@sSQLWhere)-3)
SET @sSQLWhere = ' WHERE ' +  @sSQLWhere 
END


SET  @sSQLOrderBY= ' ORDER BY keyDescription'

EXEC (@sSQL + @sSQLWhere + @sSQLOrderBY)
Return @@ERROR
GO



-- DEFECT 919 - Visualizar documentos de registos em historico
GO


CREATE    FUNCTION OW.CheckRegistryAccess
	(
	@UserID int,
	@RegID decimal (18,0)
	)
RETURNS bit
AS

BEGIN

	DECLARE @HaveAccess bit
	
	SET @HaveAccess = 0


	SELECT @HaveAccess = 1 
	FROM OW.tblRegistry R 
	WHERE R.RegID = @RegID
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
				FROM OW.tblAccess A
				WHERE  A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 
			) 
			OR 
			EXISTS 
			( 
				SELECT 1 
				FROM  OW.tblAccess A
				WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 
				AND 
				( 
					( A.ObjectType=1 AND A.UserID = @UserID ) 
					OR 
					( A.ObjectType=2 AND EXISTS( SELECT 1 
								   FROM  OW.tblGroupsUsers GU
								   WHERE A.UserID=GU.GroupID AND GU.UserID = @UserID
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


	RETURN @HaveAccess
END
GO


CREATE     FUNCTION OW.CheckRegistryHistAccess
	(
	@UserID int,
	@RegID decimal (18,0)
	)
RETURNS bit
AS

BEGIN

	DECLARE @HaveAccess bit
	
	SET @HaveAccess = 0


	SELECT @HaveAccess = 1 
	FROM OW.tblRegistryHist RH 
	WHERE RH.RegID = @RegID
	AND 
	EXISTS 
	(
		SELECT 1 
		FROM OW.tblBooks B 
		WHERE RH.BookID=B.BookID 
		AND 
		( 
			NOT EXISTS 
			( 
				SELECT 1 
				FROM OW.tblAccess A
				WHERE  A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 
			) 
			OR 
			EXISTS 
			( 
				SELECT 1 
				FROM  OW.tblAccess A
				WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 
				AND 
				( 
					( A.ObjectType=1 AND A.UserID = @UserID ) 
					OR 
					( A.ObjectType=2 AND EXISTS( SELECT 1 
								   FROM  OW.tblGroupsUsers GU
								   WHERE A.UserID=GU.GroupID AND GU.UserID = @UserID
								) 
					) 
				) 
			) 
		) 
	) 
	AND 
	( 
		NOT EXISTS ( SELECT 1 FROM  OW.tblAccessReg AC Where AC.ObjectID=RH.RegID) 
		OR 
		EXISTS 
		( 
			SELECT 1 FROM   OW.tblAccessReg AC 
			WHERE 
			( 
				AC.ObjectID=RH.RegID 
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


	RETURN @HaveAccess
END
GO


ALTER    FUNCTION OW.CheckRegistryDocumentAccess
	(
	@UserID int,
	@DocumentID int
	)
RETURNS bit
AS

BEGIN
	
	DECLARE @HaveAccess bit
	DECLARE @IsRegistry bit
	DECLARE @RegistryID decimal (18,2)
	
	SET @HaveAccess = 0
	SET @IsRegistry = 0
	SET @RegistryID = 0

	-- Get Registry ID  from Registry Documents by Document ID
	SELECT @RegistryID = RegID FROM OW.tblRegistryDocuments RD 
	WHERE RD.DocumentID = @DocumentID	

	-- IF Registry exists
	IF @RegistryID <> 0
	BEGIN
		-- Verify if is in registry or in registry history
		SELECT @IsRegistry = 1 FROM OW.tblRegistry R 
		WHERE R.RegID = @RegistryID
	
		IF @IsRegistry = 1
			SELECT @HaveAccess = OW.CheckRegistryAccess(@UserID, @RegistryID)
		ELSE
			SELECT @HaveAccess = OW.CheckRegistryHistAccess(@UserID, @RegistryID)
	
	END

	RETURN @HaveAccess

END
GO

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.3.0' WHERE id= 1
GO


PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.2.2 PARA 5.3.0'
PRINT ''
GO