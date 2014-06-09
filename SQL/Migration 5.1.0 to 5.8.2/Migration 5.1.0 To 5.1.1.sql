-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERS�O 5.1.0 PARA A VERS�O 5.1.1
--
-- ---------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------
-- Altera��o das constraints da tabela tblProcessEvent para implementa��o do reencaminhamento
-- como evento associado ao processo
-- ------------------------------------------------------------------------------------
alter table OW.tblProcessEvent drop constraint CK_tblProcessEvent02

alter table OW.tblProcessEvent
      add constraint CK_tblProcessEvent02 check (RoutingType in (1,2,4,8,16,32,64, 128))

go

alter table OW.tblProcessEvent drop constraint CK_tblProcessEvent04

alter table OW.tblProcessEvent
      add constraint CK_tblProcessEvent04 check (WorkflowActionType in (1,2,4,8,16,32,64,128,129, 130))

go


-- ------------------------------------------------------------------------------------
-- Procedure: ProcessDeleteEx01 (Elimina��o de processo)
-- ------------------------------------------------------------------------------------
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

	/* Elimina��o das Refer�ncias para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessReference]
	WHERE
		[ProcessReferedID] = @ProcessID

	/* Elimina��o das Refer�ncias do processo a eliminar */
	DELETE 
	FROM [OW].[tblProcessReference] 
	WHERE 
		[processEventID] IN 
		(SELECT [processEventID] FROM [OW].[tblProcessEvent]
		WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID)

	/* Elimina��o dos alertas associados ao processo */
	DELETE
	FROM [OW].[tblAlert]
	WHERE
		[ProcessID] = @ProcessID

	/* Elimina��o dos endere�amentos dos alarmes associados ao processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAlarmAddressee]
	WHERE
		[ProcessAlarmID] IN
		(SELECT [ProcessAlarmID] FROM [OW].[tblProcessAlarm]
		WHERE [OW].[tblProcessAlarm].[ProcessID] = @ProcessID)

	/* Elimina��o dos alarmes em queue */
	DELETE
	FROM [OW].[tblAlarmQueue]
	WHERE
		[ProcessAlarmID] IN
		(SELECT [ProcessAlarmID] FROM [OW].[tblProcessAlarm]
		WHERE [OW].[tblProcessAlarm].[ProcessID] = @ProcessID)

	/* Elimina��o dos alarmes para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE
		[ProcessID] = @ProcessID

	/* Elimina��o das Refer�ncias para as etapas do processo a eliminar (Pelo comando anterior, n�o seria necess�rio efectuar) */
	DELETE
	FROM [OW].[tblProcessAlarm]
	WHERE
		[ProcessStageID] IN
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage]
		WHERE [OW].[tblProcessStage].[ProcessID] = @ProcessID)

	/* Elimina��o dos acessos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessAccess]
	WHERE
		[ProcessID] = @ProcessID

	/* Elimina��o dos acessos do documento para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDocumentAccess]
	WHERE
		[ProcessDocumentID] IN
		(SELECT [ProcessDocumentID] FROM [OW].[tblProcessDocument]
		WHERE [OW].[tblProcessDocument].[ProcessEventID] IN
			(SELECT [ProcessEventID] FROM [OW].[tblProcessEvent]
			WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID))
 
	/* Elimina��o dos documentos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDocument]
	WHERE
		[ProcessEventID] IN
		(SELECT [ProcessEventID] FROM [OW].[tblProcessEvent]
		WHERE [OW].[tblProcessEvent].[ProcessID] = @ProcessID)
		
	/* Elimina��o dos campos do template associado aos campos do processo a eliminar */
	DELETE
	FROM [OW].[tblDocumentTemplateField]
	WHERE
		[ProcessDynamicFieldID] IN
		(SELECT [ProcessDynamicFieldID] FROM [OW].[tblProcessDynamicField]
		WHERE [OW].[tblProcessDynamicField].[ProcessID] = @ProcessID)		

	/* Elimina��o dos valores dos campos definidos para o processo a eliminar */
	DELETE
	FROM [OW].[tblProcessDynamicFieldValue]
	WHERE
		[ProcessDynamicFieldID] IN
		(SELECT [ProcessDynamicFieldID] FROM [OW].[tblProcessDynamicField]
		WHERE [OW].[tblProcessDynamicField].[ProcessID] = @ProcessID)

	/* Elimina��o das configura��es dos campos nas etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStageDynamicField]
	WHERE
		[ProcessDynamicFieldID] IN
		(SELECT [ProcessDynamicFieldID] FROM [OW].[tblProcessDynamicField]
		WHERE [OW].[tblProcessDynamicField].[ProcessID] = @ProcessID)

	/* Elimina��o dos campos associados ao processo a eliminar*/
	DELETE
	FROM [OW].[tblProcessDynamicField]
	WHERE
		[ProcessID] = @ProcessID

	/* Elimina��o dos eventos associados ao processo a eliminar */
	DELETE
	FROM [OW].[tblProcessEvent]
	WHERE
		[ProcessID] = @ProcessID


	/* Elimina��o dos eventos das etapas do processo a eliminar (Pelo comando anterior, n�o seria necess�rio efectuar) */
	DELETE
	FROM [OW].[tblProcessEvent]
	WHERE
		[ProcessStageID] IN
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage]
		WHERE [OW].[tblProcessStage].[ProcessID] = @ProcessID)

	/* Elimina��o dos acessos definidos para as etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStageAccess]
	WHERE
		[ProcessStageID] IN
		(SELECT [ProcessStageID] FROM [OW].[tblProcessStage]
		WHERE [OW].[tblProcessStage].[ProcessID] = @ProcessID)

	/* Elimina��o das etapas do processo a eliminar */
	DELETE
	FROM [OW].[tblProcessStage]
	WHERE
		[ProcessID] = @ProcessID
	
	/* Elimina��o do processo */
	DELETE
	FROM [OW].[tblProcess]
	WHERE
		[ProcessID] = @ProcessID
	AND (@LastModifiedOn IS NULL OR [LastModifiedOn] = @LastModifiedOn)
	
	/* Valida se foi encontrado o processo para elimina��o */
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


-- ------------------------------------------------------------------------------------
-- Procedure: usp_SetListAccess (Altera��o dos acessos � lista)
-- ------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_SetListAccess]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_SetListAccess]
GO
 
CREATE  PROCEDURE OW.usp_SetListAccess
(
  @ListID numeric,
  @userIDList text,
  @userTypeList text,
  @userAccessList text
)
AS
 
set XACT_ABORT on
 
begin transaction

DELETE FROM OW.tblEntityListAccess WHERE ObjectParentID = @ListID
 
INSERT INTO OW.tblEntityListAccess (ObjectID, ObjectParentID, AccessType, ObjectType)
SELECT 
 UserID.Item, @ListID ListID, UserAccess.Item, UserType.Item
FROM
 OW.StringToTable(@userIDList, ',') UserID  INNER JOIN
 OW.StringToTable(@userAccessList, ',') UserAccess ON (UserID.ID = UserAccess.ID)INNER JOIN
 OW.StringToTable(@userTypeList, ',') UserType ON (UserID.ID = UserType.ID)
 
commit transaction
 
GO

-- ---------------------------------------------------------------------------------
--
-- Actualizar a vers�o da base de dados
--
-- ---------------------------------------------------------------------------------
update OW.tblVersion Set version='5.1.1' where id=1
GO