-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.2.0 PARA A VERSÃO 5.2.1
--
-- ---------------------------------------------------------------------------------


-- Defect 887
ALTER PROCEDURE OW.usp_GetBookFieldsNotForDuplicated
(
	@BookID NUMERIC(18)
)
AS
	SELECT FRF.* FROM OW.tblFormFields FRF LEFT OUTER JOIN OW.tblFieldsBookConfig FBC
			ON (FRF.formFieldKEY = FBC.formFieldKEY)
	WHERE
		(FBC.BookID = @BookID OR FRF.Global = 1 OR FRF.visible = 0)
	AND
		NOT EXISTS(SELECT 1 FROM OW.tblFieldsBookDuplicated FBD
				WHERE 
					FBD.BookID = @BookID
				AND 
					(FBD.formFieldKEY = FRF.formFieldKEY)
			  )
	AND 
		FRF.formFieldKEY NOT IN (10,15,17,18,25,29)
	ORDER BY FRF.fieldName
GO




-- Feature 681
/*==============================================================*/
/* Table: tblFavoriteOrgUnit                                    */
/*==============================================================*/
create table OW.tblFavoriteOrgUnit  (
   FavoriteOrgUnitID	int                  identity,
   UserID               int                  not null,
   OrganizationalUnitID	int		     not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFavoriteOrgUnit primary key  (FavoriteOrgUnitID)
)
go



alter table OW.tblFavoriteOrgUnit
   add constraint FK_tblFavoriteOrgUnit_tblUser foreign key (UserID)
      references OW.tblUser (UserID)on delete cascade
go

alter table OW.tblFavoriteOrgUnit
   add constraint FK_tblFavoriteOrgUnit_tbOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)on delete cascade
go

create unique index IX_tblFavoriteOrgUnit01 on 
OW.tblFavoriteOrgUnit (
UserID,
OrganizationalUnitID
)
go


























-- Get Organizational Unit for selection using Type and Description
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[OrganizationalUnitSelectEx02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[OrganizationalUnitSelectEx02]
GO

CREATE PROCEDURE [OW].OrganizationalUnitSelectEx02
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
	
	@Type int, 
	@Description varchar(255), 
	@UserActive bit,
	@UserID int,
	@OnlyFavorites bit
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

		if (@Description is not null) set @sql = @sql + ' WHERE g.GroupDesc like @Description'
	end

	set @sql = @sql + ' ORDER BY Favorite Desc, Description'

	exec sp_executesql @sql, 
		N'@Description varchar(255), 
		@UserActive bit,
		@UserID int', 
		@Description, 
		@UserActive,
		@UserID
		
		
		
	SET @Err = @@Error
	RETURN @Err
END


-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Error on Creation'

GO
















CREATE PROCEDURE OW.FavoriteOrgUnitUpdateEx01

	(
	@UserID numeric (18),
	@OrganizationalUnitIDList varchar (8000),
	@Remarks varchar(255) = NULL,
	@LastModifiedBy varchar(50),
	@LastModifiedOn datetime = NULL
	)

AS
	DECLARE @Error int
	
	BEGIN TRANSACTION
		
	-- Delete user's OrganizationalUnits that will not be favorites

	DELETE FROM OW.tblFavoriteOrgUnit
	WHERE UserID=@UserID
	AND NOT EXISTS (SELECT 1 FROM OW.StringToTable(@OrganizationalUnitIDList,',') A
			WHERE  OW.tblFavoriteOrgUnit.OrganizationalUnitID=A.Item)
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Insert user's OrganizationalUnits that will be new favorites

	INSERT INTO OW.tblFavoriteOrgUnit (
		UserID,
   		OrganizationalUnitID,
   		Remarks,
   		InsertedBy,
   		InsertedOn,
   		LastModifiedBy,
   		LastModifiedOn 
	)
	SELECT @UserID, A.Item, NULL, @LastModifiedBy, ISNULL(@LastModifiedOn, GETDATE()), @LastModifiedBy, ISNULL(@LastModifiedOn, GETDATE())
	FROM OW.StringToTable(@OrganizationalUnitIDList,',') A
	WHERE 
	NOT EXISTS (SELECT 1 FROM OW.tblFavoriteOrgUnit FOU
			WHERE FOU.UserID=@UserID AND FOU.OrganizationalUnitID=A.Item)

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END



	COMMIT TRANSACTION
	RETURN 0

GO


















ALTER   PROCEDURE [OW].ArchFisicalInsertSelectEx01
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





























CREATE PROCEDURE OW.RegistryUpdateFisicalSpace
	(
	@RegIDList varchar (8000),
	@FisicalID int,
	@UserID int
	)

AS
	DECLARE @Error int
	
		
	UPDATE OW.tblRegistry
	SET FisicalID = @FisicalID,
	UserModifyID = @UserID,
	DateModify = GETDATE()
	WHERE 
	EXISTS (SELECT 1 FROM OW.StringToTable(@RegIDList,',') A
		WHERE  OW.tblRegistry.RegID=A.Item)
	
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
	EXISTS (SELECT 1 FROM OW.StringToTable(@RegIDList,',') A
		WHERE  OW.tblRegistryHist.RegID=A.Item)
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		RETURN @Error
	END



	RETURN 0

GO




-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.2.1' WHERE id= 1
GO