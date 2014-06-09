-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.1.1 PARA A VERSÃO 5.1.2
--
-- ---------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM SYSOBJECTS WHERE ID = OBJECT_ID('[OW].UserSelectEx03') AND sysstat & 0xf = 4)
    DROP PROCEDURE [OW].UserSelectEx03;
GO

CREATE  PROCEDURE [OW].UserSelectEx03
(
	------------------------------------------------------------------------
	--Updated: 11-05-2006 16:32:23
	--Version: 1.2	
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
			u.UserLogin,
			u.UserActive
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
			u.UserLogin,
			u.UserActive
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
	--Updated: 10-05-2006 12:30:00
	--Version: 1.2	
	------------------------------------------------------------------------
	@UserID int = NULL,
	@UserDesc varchar(100) = NULL,
	@UserMail varchar(50) = NULL,
	@Phone varchar(25) = NULL,
	@Fax varchar(25) = NULL,
	@UserLogin varchar(50) = NULL,
	@PrimaryGroupID int = NULL,
	@GroupID int = NULL,
	@UserActive bit = NULL,
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
	IF(@UserActive IS NOT NULL) SET @WHERE = @WHERE + '(Users.[UserActive] = @UserActive) AND '
	
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
		@UserActive bit,
		@RowCount bigint OUTPUT',
		@UserID, 
		@UserDesc, 
		@UserMail, 
		@Phone, 
		@Fax,
		@UserLogin,
		@PrimaryGroupID,
		@GroupID,
		@UserActive,
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
		Users.[UserLogin],
		Users.[UserActive]
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
		@GroupID int,
		@UserActive bit',
		@UserID, 
		@UserDesc, 
		@UserMail, 
		@Phone, 
		@Fax,
		@UserLogin,
		@PrimaryGroupID,
		@GroupID,
		@UserActive

	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].UserSelectPagingEx01 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].UserSelectPagingEx01 Error on Creation'
GO








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
	@UserActive bit
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
			u.UserDesc AS Description
		FROM OW.tblOrganizationalUnit ou	
			INNER JOIN OW.tblUser u
			ON ou.UserID=u.UserID'

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
				g.GroupDesc AS Description
			FROM OW.tblOrganizationalUnit ou	
				INNER JOIN OW.tblGroups g
				ON ou.GroupID=g.GroupID'

		if (@Description is not null) set @sql = @sql + ' WHERE g.GroupDesc like @Description'
	end

	set @sql = @sql + ' ORDER BY Description'

	exec sp_executesql @sql, 
		N'@Description varchar(255), 
		@UserActive bit', 
		@Description, 
		@UserActive
		
	SET @Err = @@Error
	RETURN @Err
END

GO

-- Display the status of Proc creation
IF (@@Error = 0) PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Succeeded'
ELSE PRINT 'Procedure Creation: [OW].OrganizationalUnitSelectEx02 Error on Creation'

GO
