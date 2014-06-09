-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.1.2 PARA A VERSÃO 5.1.3
--
-- ---------------------------------------------------------------------------------
ALTER TABLE OW.tblProcessAccess DROP CONSTRAINT CK_tblProcessAccess02
GO
ALTER TABLE OW.tblProcessAccess ADD CONSTRAINT CK_tblProcessAccess02 check (AccessObject in (1,2,4,8,16,32,64))
GO



ALTER TABLE OW.tblProcessAccess
	DROP CONSTRAINT PK_tblProcessAccess
GO
ALTER TABLE OW.tblProcessAccess ADD CONSTRAINT
	PK_tblProcessAccess PRIMARY KEY NONCLUSTERED 
	(
	ProcessAccessID
	) ON [PRIMARY]
GO

drop index OW.tblProcessAccess.IX_TBLPROCESSACCESS01
GO
create unique clustered index IX_TBLPROCESSACCESS01 on OW.tblProcessAccess 
(
FlowID,
ProcessID,
OrganizationalUnitID,
AccessObject
)
GO

-- -------------------------------------------------------------------------
--
-- Só para ficar igual ao HESE !
--
-- -------------------------------------------------------------------------
drop index OW.tblProcessStage.IX_TBLPROCESSSTAGE01
GO
ALTER TABLE OW.tblProcessEvent WITH NOCHECK ADD CONSTRAINT
	FK_tblProcessEvent_tblProcessStage FOREIGN KEY
	(
	ProcessStageID
	) REFERENCES OW.tblProcessStage
	(
	ProcessStageID
	)
GO
-- -------------------------------------------------------------------------

ALTER TABLE OW.tblProcessStageAccess DROP CONSTRAINT CK_tblProcessStageAccess02
GO
ALTER TABLE OW.tblProcessStageAccess ADD constraint CK_tblProcessStageAccess02 check (AccessObject in (1,2,4,8,16,32,64))
GO


alter view OW.VACCESSOBJECTTYPE (AccessObject, ID, Hierarchy, Description) as
SELECT	1, -5, -4, 'Outros'
UNION
SELECT	2, -3, -2, 'Originador'
UNION
SELECT	4, -2, -1, 'Grupo do Originador'
UNION
SELECT	8, -1, NULL, 'Superior Hierárquico do Originador'
UNION
SELECT	16, -4, -6, 'Interveniente'
UNION
SELECT	32, -6, -7, 'Grupo do Interveniente'
UNION
SELECT	64, -7, NULL, 'Superior Hierárquico do Interveniente'
go


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].CheckProcessStartAccess') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].CheckProcessStartAccess;
GO


CREATE  PROCEDURE [OW].CheckProcessStartAccess
(
	@UserID int,
	@FlowID int,
	@StartProcessAccess tinyint output
)
AS
BEGIN

	DECLARE @HierarchyID int

	SET @StartProcessAccess = COALESCE(@StartProcessAccess, 1)
	
	-- ----------------------------------------------------------------------------------------------------
	-- Acessos definidos para o fluxo 
	-- ----------------------------------------------------------------------------------------------------
	SELECT DISTINCT
		OW.tblProcessAccess.FlowID,    
		OW.tblProcessAccess.OrganizationalUnitID, 
		OW.tblOrganizationalUnit.GroupID, 
		OW.tblOrganizationalUnit.UserID, 
		OW.tblProcessAccess.AccessObject, 
		OW.tblProcessAccess.StartProcess
	INTO #ProcessAccess
	FROM OW.tblProcessAccess, OW.tblOrganizationalUnit
	WHERE OW.tblProcessAccess.FlowID = @FlowID AND
	      OW.tblProcessAccess.OrganizationalUnitID = OW.tblOrganizationalUnit.OrganizationalUnitID
              

	-- ----------------------------------------------------------------------------------------------------
	-- Verifica os acessos do utilizador
	-- ----------------------------------------------------------------------------------------------------
	IF @StartProcessAccess = 1
	BEGIN
		SELECT 
		@StartProcessAccess = CASE WHEN @StartProcessAccess = 1 THEN StartProcess ELSE @StartProcessAccess END
		FROM #ProcessAccess 
		WHERE UserID = @UserID
	END
	ELSE RETURN
	
	-- ----------------------------------------------------------------------------------------------------
	-- Verificação hierarquica dos grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @StartProcessAccess = 1
	BEGIN

		SELECT @HierarchyID = PrimaryGroupID FROM OW.tblUser WHERE UserID = @UserID
	
		WHILE @HierarchyID IS NOT NULL
		BEGIN
			IF @StartProcessAccess = 1
			BEGIN
				SELECT 
				@StartProcessAccess = CASE WHEN @StartProcessAccess = 1 THEN StartProcess ELSE @StartProcessAccess END
				FROM #ProcessAccess 
				WHERE GroupID = @HierarchyID
		
				SELECT @HierarchyID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
			END
			ELSE RETURN
		END 	
	END
	ELSE RETURN		

	-- ----------------------------------------------------------------------------------------------------
	-- Verificação dos restantes grupos
	-- ----------------------------------------------------------------------------------------------------
	IF @StartProcessAccess = 1
	BEGIN
		SELECT
		@StartProcessAccess = CASE @StartProcessAccess WHEN 1 THEN StartProcess ELSE CASE StartProcess WHEN 2 THEN StartProcess ELSE @StartProcessAccess END END
		FROM #ProcessAccess
		WHERE GroupID IN(SELECT GroupID 
				 FROM OW.tblGroupsUsers 
				 WHERE UserID = @UserID)
	END
	ELSE RETURN

END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].CheckProcessStartAccess Succeeded'
ELSE PRINT 'Procedure Creation: [OW].CheckProcessStartAccess Error on Creation'
GO



IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelectEx01') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowSelectEx01;
GO

CREATE   PROCEDURE [OW].FlowSelectEx01
(
	@UserID int = NULL,
	@AutomaticProcessNumberOnly bit = NULL
)
AS
BEGIN

	DECLARE @FlowID int
	DECLARE @StartProcessAccess tinyint
	
	SELECT FlowID INTO #Flows 
	FROM OW.tblFlow 
	WHERE (@AutomaticProcessNumberOnly IS NULL OR ProcessNumberRule IS NOT NULL) AND Status = 2

	
	IF @UserID IS NOT NULL
	BEGIN

		DECLARE c CURSOR FOR
		SELECT FlowID FROM OW.tblFlow WHERE (@AutomaticProcessNumberOnly IS NULL OR ProcessNumberRule IS NOT NULL) AND Status = 2
		OPEN c
		FETCH NEXT FROM c INTO @FlowID
		WHILE @@FETCH_STATUS = 0
		BEGIN
	
			SET @StartProcessAccess = 1
	
			EXEC OW.CheckProcessStartAccess @UserID, @FlowID, @StartProcessAccess output
	
			IF @StartProcessAccess <> 4 
			BEGIN
				DELETE FROM #Flows WHERE FlowID = @FlowID		
			END
	
		   	FETCH NEXT FROM c INTO @FlowID
		END
		CLOSE c
		DEALLOCATE c

	END

	-- Return flow info
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
	WHERE FlowID IN (SELECT FlowID FROM #Flows)
	ORDER BY Description, Version ASC


END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].FlowSelectEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].FlowSelectEx01 Error on Creation'
GO


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].FlowSelectPagingEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].FlowSelectPagingEx02;
GO



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

	DECLARE c CURSOR FOR

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

	OPEN c
	FETCH NEXT FROM c INTO @HierarchyID
	WHILE @@FETCH_STATUS = 0
	BEGIN
			
		IF @IsIntervenientHierarchicSuperiors = 0
		BEGIN
			SELECT @HierarchicSuperiorsID = HierarchyID FROM OW.tblGroups WHERE GroupID = @HierarchyID
			
			IF EXISTS(SELECT 1 FROM OW.tblUser WHERE PrimaryGroupID = @HierarchicSuperiorsID AND UserID = @UserID)	
			BEGIN
				SET @IsIntervenientHierarchicSuperiors = 1	
				CLOSE c
				DEALLOCATE c
				RETURN
			END
		END
	   	FETCH NEXT FROM c INTO @HierarchyID
	END
	CLOSE c
	DEALLOCATE c

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
	IF EXISTS(SELECT 1 FROM #Process WHERE PrimaryGroupID = @PrimaryGroupID)
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
	IF EXISTS(SELECT 1 FROM #Process WHERE PrimaryGroupID = @PrimaryGroupID)
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


IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].ProcessReferenceSelectEx02') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].ProcessReferenceSelectEx02;
GO

CREATE   PROCEDURE [OW].ProcessReferenceSelectEx02
(
	------------------------------------------------------------------------
	--Updated: 23-04-2006 16:17:24
	--Version: 1.0
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
		(pr.[ProcessReferedID] = @ProcessID)

	SET @Err = @@Error
	RETURN @Err
END
GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].ProcessReferenceSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].ProcessReferenceSelectEx02 Error on Creation'
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[ClassificationSelectByClassificationParentID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[ClassificationSelectByClassificationParentID]
GO

CREATE    PROCEDURE [OW].[ClassificationSelectByClassificationParentID]
(
	@ClassificationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int	
	
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


	SET @Err = @@Error

	RETURN @Err
END
GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.1.3' WHERE id= 1