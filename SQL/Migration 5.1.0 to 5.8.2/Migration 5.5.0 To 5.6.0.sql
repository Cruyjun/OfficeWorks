-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.5.0 PARA A VERSÃO 5.6.0
--
-- ---------------------------------------------------------------------------------


PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.5.0 PARA 5.6.0'
PRINT ''
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  958 a) - Permitir apagar fichas de registo em lote
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO

CREATE  PROCEDURE OW.RegistryDeleteRegisters
	(
	@RegIDList varchar (8000),
	@UserID int,
	@RowsDeleted int output
	)

AS
	BEGIN
	SET XACT_ABORT ON
	BEGIN TRANSACTION

	DECLARE @Error int

	SET @RowsDeleted = 0

  	DECLARE @RDA TABLE
   	(
	  RegID numeric(18)
	)

	INSERT INTO @RDA
  	SELECT * FROM OW.RegistryDeleteAccess(@RegIDList,@UserID)

	INSERT INTO @RDA
  	SELECT * FROM OW.RegistryHistDeleteAccess(@RegIDList,@UserID)

       	DELETE FROM  OW.tblRegistryDistribution WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblRegistryDistribution.RegID=R.RegID)
	DELETE FROM  OW.tblRegistryEntities WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblRegistryEntities.RegID=R.RegID)
       	DELETE FROM  OW.tblRegistryKeywords WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblRegistryKeywords.RegID=R.RegID) 

	DELETE FROM OW.tblDocument 
	WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments
			WHERE OW.tblDocument.DocumentID = OW.tblRegistryDocuments.DocumentID
			AND EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblRegistryDocuments.RegID = R.RegID )
	)

        	DELETE FROM  OW.tblStrings WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblStrings.RegID=R.RegID) 
       	DELETE FROM  OW.tblTexts WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblTexts.RegID=R.RegID) 
        	DELETE FROM  OW.tblIntegers WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblIntegers.RegID=R.RegID) 
        	DELETE FROM  OW.tblFloats WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblFloats.RegID=R.RegID) 
        	DELETE FROM  OW.tblDates WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblDates.RegID=R.RegID) 
        	DELETE FROM  OW.tblDatetimes WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblDatetimes.RegID=R.RegID)

        	DELETE FROM  OW.tblRegistry WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblRegistry.RegID=R.RegID) 
	SET @RowsDeleted = @@ROWCOUNT

        	DELETE FROM  OW.tblRegistryHist WHERE EXISTS (SELECT 1 FROM @RDA R WHERE OW.tblRegistryHist.RegID=R.RegID)
	SET @RowsDeleted = @RowsDeleted + @@ROWCOUNT

	COMMIT TRANSACTION
	END
GO

CREATE  FUNCTION OW.RegistryDeleteAccess (@RegIDList varchar(8000), @UserID int)
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
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 AND A.AccessType = 7
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

CREATE  FUNCTION OW.RegistryHistDeleteAccess (@RegIDList varchar(8000), @UserID int)
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
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 AND A.AccessType = 7
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

ALTER  FUNCTION OW.RegistryModifyAccess (@RegIDList varchar(8000), @UserID int)
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
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 AND A.AccessType IN (6,7)
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

ALTER    FUNCTION OW.RegistryHistModifyAccess (@RegIDList varchar(8000), @UserID int)
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
					WHERE A.ObjectID=B.BookID AND A.ObjectTypeID=2 AND A.ObjectParentID=1 AND A.AccessType IN (6,7)
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


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect  958 b) - Permitir actualização de acessos de registo em lote
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO


CREATE  PROCEDURE OW.RegistryAddAccessesToRegisters
	(
	@RegIDList varchar (8000),
	@AccessToID varchar (8000),
	@AccessToType varchar (8000),
	@UserID int,
	@RowsUpdated int output
	)

AS
	BEGIN
	SET XACT_ABORT ON
	BEGIN TRANSACTION

	DECLARE @Error int

	SET @RowsUpdated = 0

	-- -----------------------------------------
	-- Registers that user can change access
	-- -----------------------------------------
	DECLARE @RMA TABLE
   	(
	  RegID numeric(18),
	  rownum int IDENTITY (1, 1) Primary key NOT NULL
	)

	INSERT INTO @RMA
  	SELECT * FROM OW.RegistryModifyAccess(@RegIDList,@UserID)

	INSERT INTO @RMA
  	SELECT * FROM OW.RegistryHistModifyAccess(@RegIDList,@UserID)

	declare @RowCnt int
	declare @MaxRows int
	declare @RegistryID numeric(18)

	SET @RowCnt = 1

	SELECT @MaxRows=count(*) from @RMA
	WHILE @RowCnt <= @MaxRows
	BEGIN
		SET @RegistryID = (SELECT RegID from @RMA where rownum = @RowCnt)
	
		-- ----------------------------------------------------------------------------------------------------
		-- Insere acessos para o registo para os que nao existem ainda
		-- ----------------------------------------------------------------------------------------------------
		INSERT OW.tblAccessReg 
			SELECT TAUX.UserID, TAUX.ObjectID, TAUX.ObjectType, TAUX.HierarchicalUserID 
			FROM OW.tblAccessReg  AR 
			RIGHT OUTER JOIN 
			(
				SELECT ATI.Item AS UserID, @RegistryID AS ObjectID, RTRIM(LTRIM(ATT.Item)) AS ObjectType, 0 AS HierarchicalUserID 
				FROM OW.StringToTable(@AccessToID,',') ATI inner join OW.StringToTable(@AccessToType,',') ATT ON ATI.ID = ATT.ID

			) TAUX
			ON (AR.UserID = TAUX.UserID AND AR.ObjectID = TAUX.ObjectID AND AR.ObjectType = TAUX.ObjectType)
			WHERE
				AR.UserID IS NULL

	    SELECT @RowCnt = @RowCnt + 1
	END

  	SET @RowsUpdated = @MaxRows

	COMMIT TRANSACTION
	END
GO

CREATE  PROCEDURE OW.RegistryDelAccessesToRegisters
	(
	@RegIDList varchar (8000),
	@AccessToID varchar (8000),
	@AccessToType varchar (8000),
	@UserID int,
	@RowsUpdated int output
	)
AS
	BEGIN
	SET XACT_ABORT ON
	BEGIN TRANSACTION

	DECLARE @Error int

	SET @RowsUpdated = 0

	-- -----------------------------------------
	-- Registers that user can change access
	-- -----------------------------------------
	DECLARE @RMA TABLE
   	(
	  RegID numeric(18),
	  rownum int IDENTITY (1, 1) Primary key NOT NULL
	)

	INSERT INTO @RMA
  	SELECT * FROM OW.RegistryModifyAccess(@RegIDList,@UserID)

	INSERT INTO @RMA
  	SELECT * FROM OW.RegistryHistModifyAccess(@RegIDList,@UserID)

	-- -----------------------------------------
	-- Users (UserID, UserType) 
	-- -----------------------------------------
  	DECLARE @USERS TABLE
   	(
	  UserID numeric(18),
	  UserType smallint
	)

	INSERT INTO @USERS(UserID, UserType) 
	SELECT 	CAST (ATI.Item AS numeric(18))  , CAST (RTRIM(LTRIM(ATT.Item))  AS smallint)
	FROM OW.StringToTable(@AccessToID,',') ATI inner join OW.StringToTable(@AccessToType,',') ATT ON ATI.ID = ATT.ID

	-- ----------------------------------------------------------------------------------------------------
	-- Apaga acessos dos registos 
	-- ----------------------------------------------------------------------------------------------------
	DELETE
	FROM  OW.tblAccessReg 
	WHERE
		EXISTS
		(
			SELECT 1 FROM @RMA Rma
			WHERE OW.tblAccessReg.ObjectID = Rma.RegID
		)
		AND
		EXISTS
		(
			SELECT 1 FROM @USERS Users
			WHERE
			OW.tblAccessReg.UserID = Users.UserID and
			OW.tblAccessReg.ObjectType = Users.UserType
		)


  	SET @RowsUpdated = (SELECT COUNT (*) from @RMA)

	COMMIT TRANSACTION
	END
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect 972 - Permitir apagar vários alertas de uma só vez.
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO


CREATE PROCEDURE OW.AlertDeleteEx01
	(
	@AlertIDList varchar (8000),
	@UserID int,
	@RowsDeleted int output
	)

AS
	BEGIN
	SET XACT_ABORT ON
	BEGIN TRANSACTION

	DECLARE @Error int

	SET @RowsDeleted = 0

	DELETE
	FROM [OW].[tblAlert]
	WHERE
		EXISTS
		(
			SELECT 1 FROM OW.StringToTable(@AlertIDList,',') AlertIds
			WHERE [OW].[tblAlert].[AlertID]  = AlertIds.Item
		)
		AND ([OW].[tblAlert].[UserID] = @UserID)

  	SET @RowsDeleted = @@ROWCOUNT

	COMMIT TRANSACTION
	END
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect 960 - Filtro de pesquisa na distribuição por difusão à semelhança do outlook.
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
GO


CREATE   PROCEDURE OW.usp_GetDistributionEMailByUserID
            @usersList text,
            @iHist int
AS

--Obtém os registos, com distribuição por correio electrónico, cujos utilizadores sejam distribuidores ou destinatários
declare @tbAux table (regID numeric)
 
--Activos
if @iHist = 1 or @iHist = 3 
begin
            insert @tbAux
	    select r.regid from OW.tblRegistry r where exists 
            (
                        select d.regId from OW.tblRegistryDistribution d
			where exists
				(
					SELECT 1
					FROM OW.StringToTable(@usersList,',') st
					WHERE st.Item = d.userid
				)
			and d.regId = r.regId and d.tipo = 1
            )
            or exists
            (
                        select d1.regId from OW.tblRegistryDistribution d1 
                        inner join OW.tblElectronicMailDestinations e 
				on e.userId in 
					(
						SELECT st.Item
						FROM OW.StringToTable(@usersList,',') st
					) 
				and e.mailId = d1.connectId
                        where d1.regId = r.regId and d1.tipo = 1
            )
end

--Histórico
if @iHist = 2 or @iHist = 3 

begin
            insert @tbAux
            select rh.regid from OW.tblRegistryHist rh where exists 
            (
                        select d.regId from OW.tblRegistryDistribution d
			where exists
				(
					select 1
					from OW.StringToTable(@usersList,',') st
					where st.Item = d.userid
				)
			and d.regId = rh.regId and d.tipo = 1
            )
            or exists
            (
                        select d1.regId from OW.tblRegistryDistribution d1 
                        inner join OW.tblElectronicMailDestinations e 
				on e.userId in 
					(
						select st.Item
						from OW.StringToTable(@usersList,',') st
					) 
				and e.mailId = d1.connectId
                        where d1.regId = rh.regId and d1.tipo = 1
            )
end

select regID from @tbAux

GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect 961 - Copiar a estrutura de um espaço físico. (Mover tb foi alterado)
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
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

	IF(@IdParentFI IS NULL OR @IdParentFI <= 0)
	BEGIN
	SELECT DISTINCT     
		fi.IdFisicalInsert, 
		fi.IdParentFI, 
		fi.IdFisicalAccessType,
		fat.IdFisicalType, 
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
		fi.InsertedBy, 
		fi.InsertedOn, 
		fi.LastModifiedBy, 
		fi.LastModifiedOn
	FROM         
		OW.tblArchFisicalInsert fi
	INNER JOIN
		OW.tblArchFisicalAccessType fat
	ON 
		fi.IdFisicalAccessType = fat.IdFisicalAccessType
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
	WHERE		
		(@IdFisicalInsert IS NULL OR fi.[IdFisicalInsert] = @IdFisicalInsert) AND
		(fi.[IdParentFI] IS NULL OR fi.[IdParentFI] <= @IdParentFI) AND
		(@IdSpace IS NULL OR s.[IdSpace] = @IdSpace) AND
		(@IdField IS NULL OR fvs.[IdField] = @IdField) AND
		(@InsertedBy IS NULL OR fi.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR fi.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR fi.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR fi.[LastModifiedOn] = @LastModifiedOn)
	ORDER BY Name
	END
	ELSE
	BEGIN
	SELECT DISTINCT     
		fi.IdFisicalInsert, 
		fi.IdParentFI, 
		fi.IdFisicalAccessType,
		fat.IdFisicalType, 
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
		fi.InsertedBy, 
		fi.InsertedOn, 
		fi.LastModifiedBy, 
		fi.LastModifiedOn
	FROM         
		OW.tblArchFisicalInsert fi
	INNER JOIN
		OW.tblArchFisicalAccessType fat
	ON 
		fi.IdFisicalAccessType = fat.IdFisicalAccessType
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
	WHERE		
		(@IdFisicalInsert IS NULL OR fi.[IdFisicalInsert] = @IdFisicalInsert) AND
		(@IdParentFI IS NULL OR fi.[IdParentFI] = @IdParentFI) AND
		(@IdSpace IS NULL OR s.[IdSpace] = @IdSpace) AND
		(@IdField IS NULL OR fvs.[IdField] = @IdField) AND
		(@InsertedBy IS NULL OR fi.[InsertedBy] LIKE @InsertedBy) AND
		(@InsertedOn IS NULL OR fi.[InsertedOn] = @InsertedOn) AND
		(@LastModifiedBy IS NULL OR fi.[LastModifiedBy] LIKE @LastModifiedBy) AND
		(@LastModifiedOn IS NULL OR fi.[LastModifiedOn] = @LastModifiedOn)
	ORDER BY Name
	END

	SET @Err = @@Error
	RETURN @Err
END
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

	SELECT DISTINCT     
		fi.IdFisicalInsert, 
		fi.IdParentFI, 
		fi.IdFisicalAccessType,
		fat.IdFisicalType, 
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
		OW.tblArchFisicalAccessType fat
	ON 
		fi.IdFisicalAccessType = fat.IdFisicalAccessType
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

ALTER      PROCEDURE [OW].ArchFisicalInsertSelectEx03
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
		fat.IdFisicalType, 
		s.IdSpace, 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 1) AS 'Abreviation', 
		(SELECT [Value] FROM OW.tblArchInsertVsForm WHERE IdFisicalInsert = fi.IdFisicalInsert AND IdSpace = s.IdSpace AND IdField = 2) AS 'Name', 
		s.CodeName
	FROM         
		OW.tblArchFisicalInsert fi
		INNER JOIN OW.tblArchFisicalAccessType fat ON fi.IdFisicalAccessType = fat.IdFisicalAccessType
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
PRINT N'Creating [OW].[GetArchFisicalAccessTypeChilds]'
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE  FUNCTION [OW].[GetArchFisicalAccessTypeChilds](@IncludeParent bit, @IdFisicalAccessType int, @Nivel int, @ParentType varchar (1000))
RETURNS @retFindReports TABLE (IdFisicalAccessType int, IdParentFAT int, IdFisicalType int, Nivel int, ParentType varchar (1000))
AS  
BEGIN 
	DECLARE @SubNivel int
	DECLARE @ParentTypeAux varchar (1000)

	IF (@IncludeParent=1) 
	BEGIN
		INSERT INTO @retFindReports
		SELECT IdFisicalAccessType, IdParentFAT, IdFisicalType, @Nivel as Nivel, IdFisicalType as ParentType
		FROM OW.tblArchFisicalAccessType 
		WHERE IdFisicalAccessType=@IdFisicalAccessType

		SELECT @ParentType = IdFisicalType
		FROM OW.tblArchFisicalAccessType 
		WHERE IdFisicalAccessType=@IdFisicalAccessType
 	END

	DECLARE @Report_ID int, @Report_IdParentFAT int, @Report_IdFisicalType int, @Report_ParentTypeAux varchar (1000)

	DECLARE RetrieveReports CURSOR STATIC LOCAL FOR
	SELECT IdFisicalAccessType, IdParentFAT, IdFisicalType, IdFisicalType
	FROM OW.tblArchFisicalAccessType 
	WHERE IdParentFAT=@IdFisicalAccessType
	ORDER BY IdFisicalAccessType

	SET @SubNivel = @Nivel + 1
	
	OPEN RetrieveReports

	FETCH NEXT FROM RetrieveReports
	INTO @Report_ID, @Report_IdParentFAT, @Report_IdFisicalType, @Report_ParentTypeAux

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		SET @ParentTypeAux = @ParentType + @Report_ParentTypeAux 

		-- Nó Pai
		INSERT INTO @retFindReports
		VALUES(@Report_ID, @Report_IdParentFAT, @Report_IdFisicalType, @SubNivel, @ParentTypeAux)
		
		-- Nós filho
		INSERT INTO @retFindReports
		SELECT * FROM [OW].[GetArchFisicalAccessTypeChilds](0, @Report_ID, @SubNivel, @ParentTypeAux)
  
		FETCH NEXT FROM RetrieveReports
		INTO @Report_ID, @Report_IdParentFAT, @Report_IdFisicalType, @Report_ParentTypeAux
	END
	
	CLOSE RetrieveReports
	DEALLOCATE RetrieveReports

	RETURN
END
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[GetArchFisicalInsertChilds]'
GO

CREATE    FUNCTION [OW].[GetArchFisicalInsertChilds](@IncludeParent bit, @IdFisicalInsert int, @Nivel int, @ParentType varchar (1000), @RowCount int)
RETURNS @retFindReports TABLE (IdFisicalInsert int, IdFisicalAccessType int, IdParentFI int, IdFisicalType int, Nivel int, ParentType varchar (1000), RowNumber int)
AS  
BEGIN 
	
	DECLARE @SubNivel int
	DECLARE @ParentTypeAux varchar (1000)
	DECLARE @RowNumber int
	DECLARE @ChildsCount int

	IF (@IncludeParent=1) 
	BEGIN
		INSERT INTO @retFindReports
		SELECT fi.IdFisicalInsert, fi.IdFisicalAccessType, fi.IdParentFI, fat.IdFisicalType, @Nivel as Nivel, fat.IdFisicalType as ParentType, @RowCount+1
		FROM OW.tblArchFisicalInsert fi 
			INNER JOIN OW.tblArchFisicalAccessType fat ON fi.IdFisicalAccessType = fat.IdFisicalAccessType
		WHERE fi.IdFisicalInsert=@IdFisicalInsert

		SET @RowCount = @RowCount + 1

		SELECT @ParentType = fat.IdFisicalType
		FROM OW.tblArchFisicalInsert fi 
			INNER JOIN OW.tblArchFisicalAccessType fat ON fi.IdFisicalAccessType = fat.IdFisicalAccessType
		WHERE fi.IdFisicalInsert=@IdFisicalInsert
 	END

	DECLARE @Report_ID int, @Report_IdFisicalAccessType int, @Report_IdParentFI int, @Report_IdFisicalType int, @Report_ParentTypeAux varchar (1000)

	SET @SubNivel = @Nivel + 1
	SET @RowNumber = @RowCount

	DECLARE RetrieveReports CURSOR STATIC LOCAL FOR
	SELECT fi.IdFisicalInsert, fi.IdFisicalAccessType, fi.IdParentFI, fat.IdFisicalType, fat.IdFisicalType
	FROM OW.tblArchFisicalInsert fi 
		INNER JOIN OW.tblArchFisicalAccessType fat ON fi.IdFisicalAccessType = fat.IdFisicalAccessType
	WHERE fi.IdParentFI=@IdFisicalInsert
	ORDER BY fi.IdFisicalInsert

	SELECT @ChildsCount = COUNT(*) 
	FROM OW.tblArchFisicalInsert fi 
		INNER JOIN OW.tblArchFisicalAccessType fat ON fi.IdFisicalAccessType = fat.IdFisicalAccessType
	WHERE fi.IdParentFI=@IdFisicalInsert
	
	SET @RowCount = @RowCount + @ChildsCount
	
	OPEN RetrieveReports

	FETCH NEXT FROM RetrieveReports
	INTO @Report_ID, @Report_IdFisicalAccessType, @Report_IdParentFI, @Report_IdFisicalType, @Report_ParentTypeAux

	WHILE (@@FETCH_STATUS = 0) 
	BEGIN

		SET @RowNumber = @RowNumber + 1		
		SET @ParentTypeAux = @ParentType + @Report_ParentTypeAux

		-- Nó Pai
		INSERT INTO @retFindReports
		VALUES(@Report_ID, @Report_IdFisicalAccessType, @Report_IdParentFI, @Report_IdFisicalType, @SubNivel, @ParentTypeAux, @RowNumber)
		
		-- Nós filho
		INSERT INTO @retFindReports
		SELECT * FROM [OW].[GetArchFisicalInsertChilds](0, @Report_ID, @SubNivel, @ParentTypeAux, @RowCount)
 
		-- Somar o nº de netos 
		SET @RowCount = @RowCount + @@ROWCOUNT
  
		FETCH NEXT FROM RetrieveReports
		INTO @Report_ID, @Report_IdFisicalAccessType, @Report_IdParentFI, @Report_IdFisicalType, @Report_ParentTypeAux
	END
	
	CLOSE RetrieveReports
	DEALLOCATE RetrieveReports

	RETURN
END
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ArchFisicalInsertCheckCompatibility]'
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       PROCEDURE [OW].[ArchFisicalInsertCheckCompatibility]
(
	@IdFisicalInsertOrigin int,
	@IdFisicalAccessTypeDestination int,
	@ReturnOK int output
)
AS
BEGIN

	DECLARE @Error int

	SET @ReturnOK = 0

	IF @IdFisicalInsertOrigin IS NOT NULL AND @IdFisicalAccessTypeDestination IS NOT NULL
	BEGIN

		SELECT @ReturnOK = COUNT(*) FROM 
		(
			--Origem
			SELECT DISTINCT IdFisicalType, Nivel, ParentType 
			FROM [OW].[GetArchFisicalInsertChilds] (1,@IdFisicalInsertOrigin,1,'',0)
		) t1
		LEFT OUTER JOIN
		(
			--Destino
			SELECT DISTINCT IdFisicalType, Nivel, ParentType
			FROM [OW].[GetArchFisicalAccessTypeChilds] (0,@IdFisicalAccessTypeDestination,0,'')
		) t2
		ON (t1.IdFisicalType = t2.IdFisicalType AND t1.Nivel = t2.Nivel AND t1.ParentType = t2.ParentType)
		WHERE t2.Nivel IS NULL

		IF @ReturnOK > 0 SET @ReturnOK = 0 ELSE SET @ReturnOK = 1
	END


	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		RETURN @Error
	END

	RETURN 0
END
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ArchFisicalInsertInsertEx01]'
GO

CREATE  PROCEDURE [OW].ArchFisicalInsertInsertEx01
(
	@IdFisicalInsertOrigin int,
	@IdParentFIDestination int,
	@IdFisicalAccessTypeDestination int,
	@InsertedBy varchar(150),
	@Result int output
)
AS
BEGIN

	SET XACT_ABORT ON
	BEGIN TRANSACTION

	SET NOCOUNT ON

	SET @Result = -1

	-- Lock table tblArchFisicalInsert
	SELECT 1 FROM [OW].[tblArchFisicalInsert] WITH (XLOCK, HOLDLOCK)

	SET @Result = 1 

	-- Check compatibility
	DECLARE @IsCompatible INT
	SET @IsCompatible = 0
	EXEC [OW].[ArchFisicalInsertCheckCompatibility] @IdFisicalInsertOrigin, @IdFisicalAccessTypeDestination, @IsCompatible output

	-- Space rules not allow
	IF @IsCompatible = 0
	BEGIN
		COMMIT TRANSACTION
		RETURN @Result
	END

	SET @Result = 2 

	-- Get max fisical insert ID
	DECLARE @_IdFisicalInsertMax int
	SELECT @_IdFisicalInsertMax = Max(IdFisicalInsert) FROM [OW].[tblArchFisicalInsert]

	-- Get fisical insert spaces to copy
	SELECT t1.IdFisicalInsert, t1.IdParentFI, t1.Nivel, t1.RowNumber, t2.IdFisicalAccessType 
	INTO #ArchFisicalInsertChilds
	FROM [OW].[GetArchFisicalInsertChilds] (1,@IdFisicalInsertOrigin,1,'',0) t1
	INNER JOIN [OW].[GetArchFisicalAccessTypeChilds] (0,@IdFisicalAccessTypeDestination,0,'') t2 
	ON (t1.IdFisicalType = t2.IdFisicalType AND t1.Nivel = t2.Nivel AND t1.ParentType = t2.ParentType)

	SET IDENTITY_INSERT OW.tblArchFisicalInsert ON

	--Insert parent
	INSERT
	INTO [OW].[tblArchFisicalInsert]
	(
		[IdFisicalInsert],
		[IdParentFI],
		[IdFisicalAccessType],
		[IdIdentityCB],
		[Barcode],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	SELECT 
		@_IdFisicalInsertMax + t1.RowNumber,
		@IdParentFIDestination,
		t1.IdFisicalAccessType,
		2,
		NEWID(),
		0,
		@InsertedBy,
		GETDATE(),
		@InsertedBy,
		GETDATE()
	FROM #ArchFisicalInsertChilds t1
	WHERE t1.Nivel = 1

	--Insert childs
	INSERT
	INTO [OW].[tblArchFisicalInsert]
	(
		[IdFisicalInsert],
		[IdParentFI],
		[IdFisicalAccessType],
		[IdIdentityCB],
		[Barcode],
		[Order],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	SELECT 
		@_IdFisicalInsertMax + t1.RowNumber,
		@_IdFisicalInsertMax + t2.RowNumber,
		t1.IdFisicalAccessType,
		2,
		NEWID(),
		0,
		@InsertedBy,
		GETDATE(),
		@InsertedBy,
		GETDATE()
	FROM #ArchFisicalInsertChilds t1
	INNER JOIN #ArchFisicalInsertChilds t2
	ON (t1.IdParentFI = t2.IdFisicalInsert)

	SET IDENTITY_INSERT OW.tblArchFisicalInsert OFF

	SET @Result = 3 

	--Insert fisical insert fields values
	DECLARE @IdFieldAux int
	SET @IdFieldAux = 1

	WHILE @IdFieldAux < 11
	BEGIN
		INSERT
		INTO [OW].[tblArchInsertVsForm]
		(
			[IdFisicalInsert],
			[IdSpace],
			[IdField],
			[Value]
		)
		SELECT 
		@_IdFisicalInsertMax + t1.RowNumber,
		t2.IdSpace,
		@IdFieldAux,
		t2.Value
		FROM #ArchFisicalInsertChilds t1
		INNER JOIN [OW].[tblArchInsertVsForm] t2
		ON (t1.IdFisicalInsert = t2.IdFisicalInsert AND t2.IdField = @IdFieldAux)
	
		SET @IdFieldAux = @IdFieldAux + 1
	END

	SET @Result = 0 
	
	COMMIT TRANSACTION

	RETURN @Result
END
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [OW].[ArchFisicalInsertUpdateRules]'
GO

CREATE       PROCEDURE [OW].[ArchFisicalInsertUpdateRules]
(
	@IdFisicalInsertOrigin int,
	@IdFisicalAccessTypeDestination int,
	@LastModifiedBy varchar(150) = NULL,
	@RowsUpdated int output
)
AS
BEGIN
	
	DECLARE @Error int
	
	SET @RowsUpdated = 0

	IF @IdFisicalInsertOrigin IS NOT NULL AND @IdFisicalAccessTypeDestination IS NOT NULL
	BEGIN
		UPDATE [OW].[tblArchFisicalInsert] 
		SET 
			[OW].[tblArchFisicalInsert].IdFisicalAccessType = t2.IdFisicalAccessType,
			[OW].[tblArchFisicalInsert].[LastModifiedBy] = @LastModifiedBy,
			[OW].[tblArchFisicalInsert].[LastModifiedOn] = GETDATE()
		FROM [OW].[GetArchFisicalInsertChilds] (1,@IdFisicalInsertOrigin,1,'',0) t1
			INNER JOIN [OW].[GetArchFisicalAccessTypeChilds] (0,@IdFisicalAccessTypeDestination,0,'') t2 
			ON (t1.IdFisicalType = t2.IdFisicalType AND t1.Nivel = t2.Nivel AND t1.ParentType = t2.ParentType)
		WHERE  [OW].[tblArchFisicalInsert].IdFisicalInsert=t1.IdFisicalInsert 
		AND [OW].[tblArchFisicalInsert].IdFisicalAccessType <> t2.IdFisicalAccessType
		
		SET @RowsUpdated = @@RowCount
	END

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		RETURN @Error
	END

  	RETURN 0
END
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ArchFisicalInsertUpdateEx01]'
GO

ALTER   PROCEDURE [OW].ArchFisicalInsertUpdateEx01
(
	@IdFisicalInsertOrigin int,
	@IdParentFIDestination int,
	@IdFisicalAccessTypeDestination int,
	@LastModifiedBy varchar(150) = NULL,
	@Result int output
)
AS
BEGIN
	SET XACT_ABORT ON
	BEGIN TRANSACTION

	SET NOCOUNT ON

	SET @Result = -1

	-- Lock table tblArchFisicalInsert
	SELECT 1 FROM [OW].[tblArchFisicalInsert] WITH (XLOCK, HOLDLOCK)

	SET @Result = 1 

	-- Check compatibility
	DECLARE @IsCompatible INT
	SET @IsCompatible = 0
	EXEC [OW].[ArchFisicalInsertCheckCompatibility] @IdFisicalInsertOrigin, @IdFisicalAccessTypeDestination, @IsCompatible output

	-- Space rules not allow
	IF @IsCompatible = 0 
	BEGIN
		COMMIT TRANSACTION
		RETURN @Result
	END

	SET @Result = 2 

	-- Update Parent
	UPDATE [OW].[tblArchFisicalInsert]
	SET
		[IdParentFI] = @IdParentFIDestination,
		[LastModifiedBy] = @LastModifiedBy,
		[LastModifiedOn] = GETDATE()
	WHERE
		[IdFisicalInsert] = @IdFisicalInsertOrigin

	SET @Result = 3

	-- Update child rules
	EXEC [OW].[ArchFisicalInsertUpdateRules] @IdFisicalInsertOrigin, @IdFisicalAccessTypeDestination, @LastModifiedBy, 0

	SET @Result = 0 
	
	COMMIT TRANSACTION

	RETURN @Result
END
GO

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database updated succeeded for Defect 961'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed for Defect 961'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - Defect 966 - Na distribuição e no despacho em processo  não mostrar
-- - 		  grupos que são usados para atribuir acessos.
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
PRINT N'Dropping foreign keys from [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] DROP
CONSTRAINT [FK_tblGroups_tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblGroupsUsers]'
GO
ALTER TABLE [OW].[tblGroupsUsers] DROP
CONSTRAINT [FK_tblGroupsUsers_tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblOrganizationalUnit]'
GO
ALTER TABLE [OW].[tblOrganizationalUnit] DROP
CONSTRAINT [FK_tblOrganizationalUnit_tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblUser]'
GO
ALTER TABLE [OW].[tblUser] DROP
CONSTRAINT [FK_tblUser_tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] DROP CONSTRAINT [PK_tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] DROP CONSTRAINT [AK_tblGroups02]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] DROP CONSTRAINT [AK_tblGroups01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [OW].[tblGroups]'
GO
CREATE TABLE [OW].[tmp_rg_xx_tblGroups]
(
[GroupID] [int] NOT NULL IDENTITY(1, 1),
[GroupDesc] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ShortName] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[External] [bit] NOT NULL,
[HierarchyID] [int] NULL,
[Visible] [bit] NULL,
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
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblGroups] ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [OW].[tmp_rg_xx_tblGroups]([GroupID], [GroupDesc], [ShortName], [External], [HierarchyID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) SELECT [GroupID], [GroupDesc], [ShortName], [External], [HierarchyID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn] FROM [OW].[tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblGroups] OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [OW].[tblGroups]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_rename N'[OW].[tmp_rg_xx_tblGroups]', N'tblGroups'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblGroups] on [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] ADD CONSTRAINT [PK_tblGroups] PRIMARY KEY CLUSTERED  ([GroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[GroupsUpdate]'
GO

ALTER PROCEDURE [OW].GroupsUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-12-2007 17:34:07
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int,
	@GroupDesc varchar(100),
	@ShortName varchar(10),
	@External bit,
	@HierarchyID int = NULL,
	@Visible bit = NULL,
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
		[GroupDesc] = @GroupDesc,
		[ShortName] = @ShortName,
		[External] = @External,
		[HierarchyID] = @HierarchyID,
		[Visible] = @Visible,
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

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[GroupsInsert]'
GO

ALTER PROCEDURE [OW].GroupsInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-12-2007 17:34:07
	--Version: 1.1	
	------------------------------------------------------------------------
	@GroupID int = NULL OUTPUT,
	@GroupDesc varchar(100),
	@ShortName varchar(10),
	@External bit,
	@HierarchyID int = NULL,
	@Visible bit = NULL,
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
		[GroupDesc],
		[ShortName],
		[External],
		[HierarchyID],
		[Visible],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	)
	VALUES
	(
		@GroupDesc,
		@ShortName,
		@External,
		@HierarchyID,
		@Visible,
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

IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[GroupsDelete]'
GO

ALTER PROCEDURE [OW].GroupsDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-12-2007 17:34:07
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[GroupsSelect]'
GO

ALTER PROCEDURE [OW].GroupsSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-12-2007 17:34:07
	--Version: 1.2	
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

	SELECT
		[GroupID],
		[GroupDesc],
		[ShortName],
		[External],
		[HierarchyID],
		[Visible],
		[Remarks],
		[InsertedBy],
		[InsertedOn],
		[LastModifiedBy],
		[LastModifiedOn]
	FROM [OW].[tblGroups]
	WHERE
		(@GroupID IS NULL OR [GroupID] = @GroupID) AND
		(@GroupDesc IS NULL OR [GroupDesc] LIKE @GroupDesc) AND
		(@ShortName IS NULL OR [ShortName] LIKE @ShortName) AND
		(@External IS NULL OR [External] = @External) AND
		(@HierarchyID IS NULL OR [HierarchyID] = @HierarchyID) AND
		(@Visible IS NULL OR [Visible] = @Visible) AND
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
PRINT N'Altering [OW].[GroupsSelectPaging]'
GO

ALTER PROCEDURE [OW].GroupsSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 20-12-2007 17:34:07
	--Version: 1.1	
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
	IF(@GroupDesc IS NOT NULL) SET @WHERE = @WHERE + '([GroupDesc] LIKE @GroupDesc) AND '
	IF(@ShortName IS NOT NULL) SET @WHERE = @WHERE + '([ShortName] LIKE @ShortName) AND '
	IF(@External IS NOT NULL) SET @WHERE = @WHERE + '([External] = @External) AND '
	IF(@HierarchyID IS NOT NULL) SET @WHERE = @WHERE + '([HierarchyID] = @HierarchyID) AND '
	IF(@Visible IS NOT NULL) SET @WHERE = @WHERE + '([Visible] = @Visible) AND '
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
		@GroupDesc varchar(100), 
		@ShortName varchar(10), 
		@External bit, 
		@HierarchyID int, 
		@Visible bit, 
		@Remarks varchar(255), 
		@InsertedBy varchar(50), 
		@InsertedOn datetime, 
		@LastModifiedBy varchar(50), 
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
		[GroupDesc], 
		[ShortName], 
		[External], 
		[HierarchyID], 
		[Visible], 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[OrganizationalUnitSelectEx02]'
GO

ALTER PROCEDURE [OW].OrganizationalUnitSelectEx02
(
	------------------------------------------------------------------------
	--Created On: 22-03-2006 14:19:00
	--Created By: ricardo da Gerreiro
	--Version   : 1.0	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	--Modified On: 09-05-2006 16:35:00
	--Modified By: paulo silvado
	--Version   : 1.1
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	--Modified On: 21-12-2007 09:00:00
	--Modified By: marco Fernandes
	--Version   : 1.2
	------------------------------------------------------------------------
	
	@Type int, 
	@Description varchar(255), 
	@UserActive bit,
	@UserID int,
	@OnlyFavorites bit,
	@VisibleGroups bit = null
)
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
			u.UserDesc AS Description,
			case when fu.FavoriteOrgUnitID is not null then 1 else 0 end AS Favorite
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON ou.UserID=u.UserID'
		
		if (@OnlyFavorites = 1)
			set @sql = @sql + ' INNER JOIN'
		else
			set @sql = @sql + ' LEFT OUTER JOIN'

		set @sql = @sql +
			' OW.tblFavoriteOrgUnit fu
			ON fu.OrganizationalUnitID=ou.OrganizationalUnitID
			and fu.UserID=@UserID'

		if (@Description is not null and @UserActive is not null) set @sql = @sql + ' WHERE u.userDesc like @Description AND u.userActive = @UserActive'
		if (@Description is not null and @UserActive is null) set @sql = @sql + ' WHERE u.userDesc like @Description'		
		if (@Description is null and @UserActive is not null) set @sql = @sql + ' WHERE u.userActive = @UserActive'

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
				g.GroupDesc AS Description,
				case when fu.FavoriteOrgUnitID is not null then 1 else 0 end AS Favorite
			FROM OW.tblOrganizationalUnit ou	
				INNER JOIN OW.tblGroups g
				ON ou.GroupID=g.GroupID'

		if (@OnlyFavorites = 1)
			set @sql = @sql + ' INNER JOIN'
		else
			set @sql = @sql + ' LEFT OUTER JOIN'

		set @sql = @sql +
			' OW.tblFavoriteOrgUnit fu
			ON fu.OrganizationalUnitID=ou.OrganizationalUnitID
			and fu.UserID=@UserID'

		if (@Description is not null) 
		begin
			set @sql = @sql + ' WHERE g.GroupDesc like @Description'
			if (@VisibleGroups is not null) 
				set @sql = @sql + '  AND g.Visible=@VisibleGroups'
		end
		else
			if (@VisibleGroups is not null) 
				 set @sql = @sql + ' WHERE g.Visible=@VisibleGroups'

	end

	set @sql = @sql + ' ORDER BY Favorite Desc, Description'

	exec sp_executesql @sql, 
		N'@Description varchar(255), 
		@UserActive bit,
		@UserID int, 
		@VisibleGroups bit',
		@Description, 
		@UserActive,
		@UserID,
		@VisibleGroups
		
		
		
	SET @Err = @@Error
	RETURN @Err
END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Error on Creation'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] ADD CONSTRAINT [AK_tblGroups02] UNIQUE NONCLUSTERED  ([GroupDesc])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblGroups] ADD CONSTRAINT [AK_tblGroups01] UNIQUE NONCLUSTERED  ([ShortName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblGroups]'
GO
ALTER TABLE [OW].[tblGroups] ADD
CONSTRAINT [FK_tblGroups_tblGroups] FOREIGN KEY ([HierarchyID]) REFERENCES [OW].[tblGroups] ([GroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblGroupsUsers]'
GO
ALTER TABLE [OW].[tblGroupsUsers] ADD
CONSTRAINT [FK_tblGroupsUsers_tblGroups] FOREIGN KEY ([GroupID]) REFERENCES [OW].[tblGroups] ([GroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblOrganizationalUnit]'
GO
ALTER TABLE [OW].[tblOrganizationalUnit] ADD
CONSTRAINT [FK_tblOrganizationalUnit_tblGroups] FOREIGN KEY ([GroupID]) REFERENCES [OW].[tblGroups] ([GroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblUser]'
GO
ALTER TABLE [OW].[tblUser] ADD
CONSTRAINT [FK_tblUser_tblGroups] FOREIGN KEY ([PrimaryGroupID]) REFERENCES [OW].[tblGroups] ([GroupID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- -----------------------------------------------
-- Added default values to AlarmType 
-- -----------------------------------------------

UPDATE [OW].[tblGroups] SET Visible = 1 WHERE Visible IS NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblGroups] 
	ALTER COLUMN Visible BIT NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
-- -----------------------------------------------
-- End
-- -----------------------------------------------


IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database updated succeeded for Defect 966'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed for Defect 966'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- Defect 959 - Alarmes sem prazo Alarmes sem prazo (pedido pelo Vice-Governador); 
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
PRINT N'Dropping foreign keys from [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] DROP
CONSTRAINT [FK_tblAlarmQueue_tblProcessAlarm]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblProcessAlarmAddressee]'
GO
ALTER TABLE [OW].[tblProcessAlarmAddressee] DROP
CONSTRAINT [FK_tblProcessAlarmAddressee_tblProcessAlarm]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping foreign keys from [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] DROP
CONSTRAINT [FK_tblProcessAlarm_tblFlow],
CONSTRAINT [FK_tblProcessAlarm_tblFlowStage02],
CONSTRAINT [FK_tblProcessAlarm_tblFlowStage01],
CONSTRAINT [FK_tblProcessAlarm_tblProcess],
CONSTRAINT [FK_tblProcessAlarm_tblProcessStage02],
CONSTRAINT [FK_tblProcessAlarm_tblProcessStage01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping constraints from [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] DROP CONSTRAINT [CK_tblProcessAlarm03]
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
PRINT N'Dropping constraints from [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] DROP CONSTRAINT [CK_tblProcessAlarm01]
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
ALTER TABLE [OW].[tblProcessAlarm] DROP CONSTRAINT [PK_tblProcessAlarm]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLPROCESSALARM01] from [OW].[tblProcessAlarm]'
GO
DROP INDEX [OW].[tblProcessAlarm].[IX_TBLPROCESSALARM01]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLPROCESSALARM02] from [OW].[tblProcessAlarm]'
GO
DROP INDEX [OW].[tblProcessAlarm].[IX_TBLPROCESSALARM02]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLPROCESSALARM03] from [OW].[tblProcessAlarm]'
GO
DROP INDEX [OW].[tblProcessAlarm].[IX_TBLPROCESSALARM03]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Dropping index [IX_TBLPROCESSALARM04] from [OW].[tblProcessAlarm]'
GO
DROP INDEX [OW].[tblProcessAlarm].[IX_TBLPROCESSALARM04]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Rebuilding [OW].[tblProcessAlarm]'
GO
CREATE TABLE [OW].[tmp_rg_xx_tblProcessAlarm]
(
[ProcessAlarmID] [int] NOT NULL IDENTITY(1, 1),
[AlarmType] [tinyint] NULL,
[FlowID] [int] NULL,
[FlowStageID] [int] NULL,
[ProcessID] [int] NULL,
[ProcessStageID] [int] NULL,
[Occurence] [tinyint] NULL,
[OccurenceOffset] [int] NULL,
[AlarmDatetime] [datetime] NULL,
[Message] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AlertByEMail] [bit] NOT NULL,
[AddresseeExecutant] [bit] NOT NULL,
[AddresseeFlowOwner] [bit] NOT NULL,
[AddresseeProcessOwner] [bit] NOT NULL,
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
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblProcessAlarm] ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
INSERT INTO [OW].[tmp_rg_xx_tblProcessAlarm]([ProcessAlarmID], [FlowID], [FlowStageID], [ProcessID], [ProcessStageID], [Occurence], [OccurenceOffset], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) SELECT [ProcessAlarmID], [FlowID], [FlowStageID], [ProcessID], [ProcessStageID], [Occurence], [OccurenceOffset], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn] FROM [OW].[tblProcessAlarm]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
SET IDENTITY_INSERT [OW].[tmp_rg_xx_tblProcessAlarm] OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
DROP TABLE [OW].[tblProcessAlarm]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
sp_rename N'[OW].[tmp_rg_xx_tblProcessAlarm]', N'tblProcessAlarm'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_tblProcessAlarm] on [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [PK_tblProcessAlarm] PRIMARY KEY CLUSTERED  ([ProcessAlarmID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLPROCESSALARM01] on [OW].[tblProcessAlarm]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLPROCESSALARM01] ON [OW].[tblProcessAlarm] ([FlowID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLPROCESSALARM02] on [OW].[tblProcessAlarm]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLPROCESSALARM02] ON [OW].[tblProcessAlarm] ([FlowStageID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLPROCESSALARM03] on [OW].[tblProcessAlarm]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLPROCESSALARM03] ON [OW].[tblProcessAlarm] ([ProcessID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_TBLPROCESSALARM04] on [OW].[tblProcessAlarm]'
GO
CREATE NONCLUSTERED INDEX [IX_TBLPROCESSALARM04] ON [OW].[tblProcessAlarm] ([ProcessStageID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD
CONSTRAINT [FK_tblProcessAlarm_tblFlow] FOREIGN KEY ([FlowID]) REFERENCES [OW].[tblFlow] ([FlowID]),
CONSTRAINT [FK_tblProcessAlarm_tblFlowStage01] FOREIGN KEY ([FlowStageID]) REFERENCES [OW].[tblFlowStage] ([FlowStageID]),
CONSTRAINT [FK_tblProcessAlarm_tblFlowStage02] FOREIGN KEY ([FlowStageID], [FlowID]) REFERENCES [OW].[tblFlowStage] ([FlowStageID], [FlowID]),
CONSTRAINT [FK_tblProcessAlarm_tblProcess] FOREIGN KEY ([ProcessID]) REFERENCES [OW].[tblProcess] ([ProcessID]),
CONSTRAINT [FK_tblProcessAlarm_tblProcessStage01] FOREIGN KEY ([ProcessStageID]) REFERENCES [OW].[tblProcessStage] ([ProcessStageID]),
CONSTRAINT [FK_tblProcessAlarm_tblProcessStage02] FOREIGN KEY ([ProcessStageID], [ProcessID]) REFERENCES [OW].[tblProcessStage] ([ProcessStageID], [ProcessID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmSelect]'
GO

ALTER PROCEDURE [OW].ProcessAlarmSelect
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-12-2007 17:47:17
	--Version: 1.2	
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

	SELECT
		[ProcessAlarmID],
		[AlarmType],
		[FlowID],
		[FlowStageID],
		[ProcessID],
		[ProcessStageID],
		[Occurence],
		[OccurenceOffset],
		[AlarmDatetime],
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
		(@AlarmType IS NULL OR [AlarmType] = @AlarmType) AND
		(@FlowID IS NULL OR [FlowID] = @FlowID) AND
		(@FlowStageID IS NULL OR [FlowStageID] = @FlowStageID) AND
		(@ProcessID IS NULL OR [ProcessID] = @ProcessID) AND
		(@ProcessStageID IS NULL OR [ProcessStageID] = @ProcessStageID) AND
		(@Occurence IS NULL OR [Occurence] = @Occurence) AND
		(@OccurenceOffset IS NULL OR [OccurenceOffset] = @OccurenceOffset) AND
		(@AlarmDatetime IS NULL OR [AlarmDatetime] = @AlarmDatetime) AND
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmInsert]'
GO

ALTER PROCEDURE [OW].ProcessAlarmInsert
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-12-2007 17:47:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int = NULL OUTPUT,
	@AlarmType tinyint = NULL,
	@FlowID int = NULL,
	@FlowStageID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@Occurence tinyint = NULL,
	@OccurenceOffset int = NULL,
	@AlarmDatetime datetime = NULL,
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
		[AlarmType],
		[FlowID],
		[FlowStageID],
		[ProcessID],
		[ProcessStageID],
		[Occurence],
		[OccurenceOffset],
		[AlarmDatetime],
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmSelectEx01]'
GO

ALTER PROCEDURE [OW].ProcessAlarmSelectEx01
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
		PA.[AlarmType],
		PA.[FlowID],
		PA.[FlowStageID],
		PA.[ProcessID],
		PA.[ProcessStageID],
		PA.[AlarmDatetime],
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmDelete]'
GO

ALTER PROCEDURE [OW].ProcessAlarmDelete
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-12-2007 17:47:17
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmUpdate]'
GO

ALTER PROCEDURE [OW].ProcessAlarmUpdate
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-12-2007 17:47:17
	--Version: 1.1	
	------------------------------------------------------------------------
	@ProcessAlarmID int,
	@AlarmType tinyint = NULL,
	@FlowID int = NULL,
	@FlowStageID int = NULL,
	@ProcessID int = NULL,
	@ProcessStageID int = NULL,
	@Occurence tinyint = NULL,
	@OccurenceOffset int = NULL,
	@AlarmDatetime datetime = NULL,
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
		[AlarmType] = @AlarmType,
		[FlowID] = @FlowID,
		[FlowStageID] = @FlowStageID,
		[ProcessID] = @ProcessID,
		[ProcessStageID] = @ProcessStageID,
		[Occurence] = @Occurence,
		[OccurenceOffset] = @OccurenceOffset,
		[AlarmDatetime] = @AlarmDatetime,
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [OW].[ProcessAlarmSelectPaging]'
GO

ALTER PROCEDURE [OW].ProcessAlarmSelectPaging
(
	------------------------------------------------------------------------
	--This is created by MyGeneration program 'DO NOT CHANGE THIS PROCEDURE'
	--Updated: 17-12-2007 17:47:17
	--Version: 1.1	
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
	IF(@AlarmType IS NOT NULL) SET @WHERE = @WHERE + '([AlarmType] = @AlarmType) AND '
	IF(@FlowID IS NOT NULL) SET @WHERE = @WHERE + '([FlowID] = @FlowID) AND '
	IF(@FlowStageID IS NOT NULL) SET @WHERE = @WHERE + '([FlowStageID] = @FlowStageID) AND '
	IF(@ProcessID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessID] = @ProcessID) AND '
	IF(@ProcessStageID IS NOT NULL) SET @WHERE = @WHERE + '([ProcessStageID] = @ProcessStageID) AND '
	IF(@Occurence IS NOT NULL) SET @WHERE = @WHERE + '([Occurence] = @Occurence) AND '
	IF(@OccurenceOffset IS NOT NULL) SET @WHERE = @WHERE + '([OccurenceOffset] = @OccurenceOffset) AND '
	IF(@AlarmDatetime IS NOT NULL) SET @WHERE = @WHERE + '([AlarmDatetime] = @AlarmDatetime) AND '
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
		@LastModifiedOn datetime,
		@RowCount bigint OUTPUT',
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
		[AlarmType], 
		[FlowID], 
		[FlowStageID], 
		[ProcessID], 
		[ProcessStageID], 
		[Occurence], 
		[OccurenceOffset], 
		[AlarmDatetime], 
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding constraints to [OW].[tblProcessAlarm]'
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm02] CHECK (([Occurence] = 8 or ([Occurence] = 4 or ([Occurence] = 2 or [Occurence] = 1)) or [Occurence] is null and [AlarmType] = 4))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm03] CHECK (([FlowID] is not null and [ProcessID] is null or [FlowID] is null and [ProcessID] is not null))
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
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm06] CHECK (([AlarmType] = 4 and [AlarmDatetime] is not null or [AlarmType] = 2 or [AlarmType] = 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE [OW].[tblProcessAlarm] ADD CONSTRAINT [CK_tblProcessAlarm01] CHECK (([ProcessAlarmID] >= 1))
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblAlarmQueue]'
GO
ALTER TABLE [OW].[tblAlarmQueue] ADD
CONSTRAINT [FK_tblAlarmQueue_tblProcessAlarm] FOREIGN KEY ([ProcessAlarmID]) REFERENCES [OW].[tblProcessAlarm] ([ProcessAlarmID]) ON DELETE CASCADE
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Adding foreign keys to [OW].[tblProcessAlarmAddressee]'
GO
ALTER TABLE [OW].[tblProcessAlarmAddressee] ADD
CONSTRAINT [FK_tblProcessAlarmAddressee_tblProcessAlarm] FOREIGN KEY ([ProcessAlarmID]) REFERENCES [OW].[tblProcessAlarm] ([ProcessAlarmID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO

-- -----------------------------------------------
-- Added default values to AlarmType 
-- -----------------------------------------------
UPDATE [OW].[tblProcessAlarm] SET AlarmType = 1 WHERE AlarmType IS NULL AND (ProcessStageID IS NULL AND FlowStageID IS NULL)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
UPDATE [OW].[tblProcessAlarm] SET AlarmType = 2 WHERE AlarmType IS NULL AND (ProcessStageID IS NOT NULL OR FlowStageID IS NOT NULL)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
ALTER TABLE OW.tblProcessAlarm
	ALTER COLUMN AlarmType TINYINT NOT NULL
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
-- -----------------------------------------------
-- End
-- -----------------------------------------------

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database updated succeeded for Defect 959'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed for Defect 959'
GO
DROP TABLE #tmpErrors
GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.6.0' WHERE id= 1
GO

PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.5.0 PARA 5.6.0'
PRINT ''
GO



