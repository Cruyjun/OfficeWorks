
SET NOCOUNT ON
GO
SET CONCAT_NULL_YIELDS_NULL OFF
GO

/* Criar user OW se este ainda não existe */
if not exists (select * from master.dbo.syslogins where loginname = N'OW')
BEGIN
	exec sp_addlogin N'OW', N'nicedoc', N'OfficeWorks', N'us_english'
END
GO

if not exists (select * from dbo.sysusers where name = N'OW' and uid < 16382)
BEGIN
	exec sp_grantdbaccess N'OW', N'OW'
	exec sp_addrolemember N'db_owner', N'OW'
END
GO


--
-- Declaração de variáveis globais 
--
if exists (select * from TEMPDB..sysobjects where name = N'##VariaveisGlobais')
BEGIN
	drop table [OW].[##VariaveisGlobais]
END
GO

CREATE TABLE [OW].[##VariaveisGlobais] (
InsertedBy varchar(50),
InsertedOn datetime,
LastModifiedBy varchar(50),
LastModifiedOn datetime
)

INSERT INTO [OW].[##VariaveisGlobais]
(InsertedBy,InsertedOn) VALUES('Administrador OfficeWorks',getdate())

UPDATE  [OW].[##VariaveisGlobais] SET
LastModifiedBy = InsertedBy, LastModifiedOn = InsertedOn

GO






/****** Object:  Table [OW].[tblAccess]    Script Date: 12/4/2003 15:36:29 ******/
CREATE TABLE [OW].[tblAccess] (
	[UserID] [int] NOT NULL ,
	[ObjectParentID] [numeric](18, 0) NOT NULL ,
	[ObjectID] [numeric](18, 0) NOT NULL ,
	[ObjectTypeID] [numeric](18, 0) NOT NULL ,
	[AccessType] [int] NULL ,
	[ObjectType] [smallint] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblAccessReg]    Script Date: 12/4/2003 15:36:30 ******/
CREATE TABLE [OW].[tblAccessReg] (
	[UserID] [int] NOT NULL ,
	[ObjectID] [numeric](18, 0) NOT NULL ,
	[ObjectType] [smallint] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblBooks]    Script Date: 12/4/2003 15:36:30 ******/
CREATE TABLE [OW].[tblBooks] (
	[bookID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[abreviation] [nvarchar] (20)  NULL ,
	[designation] [nvarchar] (100)  NULL ,
	[automatic] [bit] NOT NULL,
	[hierarchical] bit NOT NULL CONSTRAINT DF_tblBooks_hierarchical DEFAULT 0 ,
	[Duplicated] [Bit] NOT NULL CONSTRAINT DF_tblBooks_Duplicated DEFAULT 0 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblFieldsBookDuplicated](
	[DuplicatedID] [numeric] (18)IDENTITY NOT NULL,
	[BookID] [numeric] (18) NOT NULL,
	[FormFieldKEY]  [numeric] (18) NOT NULL
)
GO

/****** Object:  Table [OW].[tblBooksDocumentType]    Script Date: 12/4/2003 15:36:31 ******/
CREATE TABLE [OW].[tblBooksDocumentType] (
	[bookID] [numeric](18, 0) NOT NULL ,
	[documenttypeID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblBooksKeyword]    Script Date: 12/4/2003 15:36:31 ******/
CREATE TABLE [OW].[tblBooksKeyword] (
	[bookID] [numeric](18, 0) NOT NULL ,
	[keywordID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblClassification]    Script Date: 20/02/2006 15:00:00 ******/
CREATE TABLE [OW].[tblClassification] (
	[ClassificationID] [int] IDENTITY (1, 1) NOT NULL ,
	[ParentID] [int] NULL ,
	[Level] [smallint] NOT NULL ,
	[Code] [varchar] (50) NOT NULL ,
	[Description] [varchar] (250) NOT NULL ,
	[Global] [bit] NOT NULL ,
	[Scope] [smallint] NOT NULL ,
	[Remarks] [varchar] (255) NULL ,
	[InsertedBy] [varchar] (50) NOT NULL ,
	[InsertedOn] [datetime] NOT NULL ,
	[LastModifiedBy] [varchar] (50) NOT NULL ,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblClassificationBooks]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblClassificationBooks] (
	[ClassBookID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[ClassID] [int] NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblCountry]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblCountry] (
	[CountryID] [int] IDENTITY (1, 1) NOT NULL ,
	[Code] [char] (2)  NOT NULL ,
	[Description] [varchar] (80)  NOT NULL ,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDateTimes]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblDateTimes] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[Value] [smalldatetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDates]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblDates] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[Value] [smalldatetime] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDispatch]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblDispatch] (
	[dispatchid] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[abreviation] [nvarchar] (20)  NOT NULL ,
	[designation] [nvarchar] (100)  NOT NULL ,
	[global] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDispatchBook]    Script Date: 12/4/2003 15:36:33 ******/
CREATE TABLE [OW].[tblDispatchBook] (
	[bookID] [numeric](18, 0) NOT NULL ,
	[dispatchID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDistribTemp]    Script Date: 12/4/2003 15:36:33 ******/
CREATE TABLE [OW].[tblDistribTemp] (
	[TmpID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[GUID] [nchar] (32)  NULL ,
	[tipo] [numeric](18, 0) NOT NULL ,
	[DistribObs] [nvarchar] (250)  NULL ,
	[radioVia] [varchar] (20)  NULL ,
	[chkFile] [bit] NULL ,
	[distribTypeID] [numeric](18, 0) NULL ,
	[txtEntidadeID] [numeric](18, 0) NULL ,
	[regID] [numeric](18, 0) NULL ,
	[DistribDate] [datetime] NOT NULL ,
	[userID] [numeric](18, 0) NOT NULL ,
	[OLD] [bit] NULL ,
	[state] [tinyint] NULL ,
	[ConnectID] [numeric](18, 0) NULL ,
	[ID] [numeric](18, 0) NULL ,
	[dispatch] [numeric](18, 0) NULL,
	[AutoDistribID] [numeric](18, 0) NULL,
	AddresseeType char(1) NULL,
	AddresseeID numeric (18) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDistributionCode]    Script Date: 12/4/2003 15:36:33 ******/
CREATE TABLE [OW].[tblDistributionCode] (
	[id] [numeric](18, 0) NOT NULL ,
	[description] [nvarchar] (20)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDistributionEntities]    Script Date: 12/4/2003 15:36:34 ******/
CREATE TABLE [OW].[tblDistributionEntities] (
	[DistribID] [numeric](18, 0) NOT NULL ,
	[RegID] [numeric](18, 0) NULL ,
	[EntID] [numeric](18, 0) NOT NULL ,
	[Tmp] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDistributionType]    Script Date: 12/4/2003 15:36:34 ******/
CREATE TABLE [OW].[tblDistributionType] (
	[DistribTypeID] [numeric](18, 0) NOT NULL ,
	[DistribTypeDesc] [varchar] (250)  NULL ,
	[GetDistribCode] [nvarchar] (50)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDistrict]    Script Date: 12/4/2003 15:36:34 ******/
CREATE TABLE [OW].[tblDistrict] (
	[DistrictID] [int] IDENTITY (1, 1) NOT NULL ,
	[CountryID] [int] NOT NULL ,
	[Description] [varchar] (80)  NOT NULL ,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblDocumentType]    Script Date: 12/4/2003 15:36:34 ******/
CREATE TABLE [OW].[tblDocumentType] (
	[doctypeID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[abreviation] [nvarchar] (20)  NULL ,
	[designation] [nvarchar] (100)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntities]    Script Date: 12/4/2003 15:36:35 ******/
CREATE TABLE [OW].[tblEntities] (
	[EntID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[PublicCode] [varchar] (20) NULL ,
	[Name] [varchar] (255) NOT NULL ,
	[FirstName] [varchar] (50)  NULL ,
	[MiddleName] [varchar] (300)  NULL ,
	[LastName] [varchar] (50)  NULL ,
	[ListID] [numeric](18, 0) NULL ,
	[BI] [varchar](30) NULL ,
	[NumContribuinte] [varchar](30) NULL ,
	[AssociateNum] [numeric](18, 0) NULL ,
	[eMail] [varchar] (300)  NULL ,
	[InternetSite] [varchar] (80) NULL ,
	[JobTitle] [varchar] (100)  NULL ,
	[Street] [varchar] (500)  NULL ,
	[PostalCodeID] [int] NULL ,
	[CountryID] [int] NULL ,
	[Phone] [varchar] (20)  NULL ,
	[Fax] [varchar] (20)  NULL ,
	[Mobile] [varchar] (20)  NULL ,
	[DistrictID] [int] NULL ,
	[EntityID] [numeric](18, 0) NULL ,
	[EntityTypeID] [int] NOT NULL ,
	[Active] [bit] NOT NULL ,
	[Type] [tinyint] NOT NULL,
	[BIEmissionDate] smalldatetime NULL,
	[BIArquiveID] [numeric](18, 0) NULL,
	[JobPositionID] [numeric](18, 0) NULL,
	[LocationID] [numeric](18, 0) NULL ,
	[Contact] [varchar] (255) NULL,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL	
 ) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblEntityType]
(
[EntityTypeID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (80) NOT NULL,
[Remarks] [varchar] (255) NULL,
[InsertedBy] [varchar] (50) NOT NULL,
[InsertedOn] [datetime] NOT NULL,
[LastModifiedBy] [varchar] (50) NOT NULL,
[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntityBIArquive]    Script Date: 28-04-2005 15:16:23 ******/
CREATE TABLE [OW].[tblEntityBIArquive] (
	[BIArquiveID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (255)  NOT NULL ,
	[Global] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntityJobPosition]    Script Date: 28-04-2005 15:16:23 ******/
CREATE TABLE [OW].[tblEntityJobPosition] (
	[JobPositionID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (250)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntityListBIArquiveAssociation]    Script Date: 28-04-2005 15:16:24 ******/
CREATE TABLE [OW].[tblEntityListBIArquiveAssociation] (
	[BIArquiveID] [numeric](18, 0) NOT NULL ,
	[ListID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntityLocation]    Script Date: 28-04-2005 15:16:24 ******/
CREATE TABLE [OW].[tblEntityLocation] (
	[LocationID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (250)  NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntitiesTemp]    Script Date: 12/4/2003 15:36:36 ******/
CREATE TABLE [OW].[tblEntitiesTemp] (
	[id] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[guid] [nchar] (32)  NULL ,
	[entityname] [varchar] (400)  NOT NULL ,
	[entitytype] [bit] NOT NULL ,
	[ContactID] [nvarchar] (250)  NULL ,
	[EntID] [varchar] (100)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntityList]    Script Date: 12/4/2003 15:36:37 ******/
CREATE TABLE [OW].[tblEntityList] (
	[ListID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100)  NOT NULL ,
	[global] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblEntityListAccess]    Script Date: 12/4/2003 15:36:37 ******/
CREATE TABLE [OW].[tblEntityListAccess] (
	[ObjectID] [numeric](18, 0) NOT NULL ,
	[ObjectParentID] [numeric](18, 0) NOT NULL ,
	[AccessType] [numeric](18, 0) NOT NULL ,
	[ObjectType] [smallint] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFields]    Script Date: 12/4/2003 15:36:37 ******/
CREATE TABLE [OW].[tblFields] (
	[FieldID] [numeric](18, 0) NOT NULL ,
	[Description] [varchar] (50)  NOT NULL ,
	[TypeID] [numeric](18, 0) NOT NULL ,
	[Size] [int] NOT NULL ,
	[Unique] [bit] NOT NULL ,
	[Empty] [bit] NOT NULL ,
	[Global] [bit] NOT NULL ,
	[Visible] [bit] NOT NULL CONSTRAINT DF_tblFields_Visible DEFAULT 1,
	[Order] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFieldsBookConfig]    Script Date: 12/4/2003 15:36:37 ******/
CREATE TABLE [OW].[tblFieldsBookConfig] (
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[Unique] [bit] NULL ,
	[Empty] [bit] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFieldsBooksPosition]    Script Date: 12/4/2003 15:36:38 ******/
CREATE TABLE [OW].[tblFieldsBooksPosition] (
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[Line] [int] NULL ,
	[Column] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFileManager]    Script Date: 12/4/2003 15:36:38 ******/
CREATE TABLE [OW].[tblFileManager] (
	[FileID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[FileName] [varchar] (300)  NOT NULL ,
	[FilePath] [varchar] (300)  NOT NULL ,
	CreateDate datetime NOT NULL,
	CreateUserID int NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFloats]    Script Date: 12/4/2003 15:36:38 ******/
CREATE TABLE [OW].[tblFloats] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[value] [float] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFormFields]    Script Date: 12/4/2003 15:36:38 ******/
CREATE TABLE [OW].[tblFormFields] (
	[fieldName] [nvarchar] (50)  NULL ,
	[formFieldKEY] [numeric](18, 0) NOT NULL ,
	[DynFldTypeID] [numeric](18, 0) NULL ,
	[Size] [int] NULL ,
	[Unique] [bit] NULL ,
	[Empty] [bit] NULL ,
	[Global] [bit] NULL,
	[Visible] [bit] NOT NULL CONSTRAINT DF_tblFormFields_Visible DEFAULT 1
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFormFieldsBooks]    Script Date: 12/4/2003 15:36:39 ******/
CREATE TABLE [OW].[tblFormFieldsBooks] (
	[bookID] [numeric](18, 0) NOT NULL ,
	[formID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblFormFieldsType]    Script Date: 12/4/2003 15:36:39 ******/
CREATE TABLE [OW].[tblFormFieldsType] (
	[DynFldTypeID] [numeric](18, 0) NOT NULL ,
	[Description] [nvarchar] (50)  NULL ,
	[InternalDescription] [nvarchar] (50)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblGroups]    Script Date: 12/4/2003 15:36:39 ******/
CREATE TABLE [OW].[tblGroups] (
	[GroupID] [int] IDENTITY (1, 1) NOT NULL ,
	[HierarchyID] [int] NULL ,
	[ShortName] [varchar] (10) NOT NULL ,
	[GroupDesc] [varchar] (100)  NOT NULL ,
	[External] [bit] NOT NULL ,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblGroupsUsers]    Script Date: 12/4/2003 15:36:39 ******/
CREATE TABLE [OW].[tblGroupsUsers] (
	[GroupsUserID] [int] NOT NULL IDENTITY(1, 1),
	[UserID] [int] NOT NULL ,	
	[GroupID] [int] NOT NULL ,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblIntegers]    Script Date: 12/4/2003 15:36:40 ******/
CREATE TABLE [OW].[tblIntegers] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[Value] [decimal](38, 0) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblKeywords]    Script Date: 12/4/2003 15:36:40 ******/
CREATE TABLE [OW].[tblKeywords] (
	[keyID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[keyDescription] [nvarchar] (50)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblPostalCode]    Script Date: 12/4/2003 15:36:40 ******/
CREATE TABLE [OW].[tblPostalCode] (
	[PostalCodeID] [int] IDENTITY (1, 1) NOT NULL ,
	[Code] [varchar] (10)  NOT NULL ,
	[Description] [varchar] (100)  NOT NULL ,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblProfiles]    Script Date: 12/4/2003 15:36:40 ******/
CREATE TABLE [OW].[tblProfiles] (
	[Profileid] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[ProfileDesc] [varchar] (100)  NULL ,
	[NumOfDistrib] [numeric](18, 0) NULL ,
	[NumOfStages] [numeric](18, 0) NULL ,
	[NumOfSecundaryEntities] [numeric](18, 0) NULL ,
	[ProfileType] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblProfilesFields]    Script Date: 12/4/2003 15:36:41 ******/
CREATE TABLE [OW].[tblProfilesFields] (
	[ProfileId] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[FormFieldOrder] [numeric](18, 0) NULL ,
	[FieldMaxChars] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistry]    Script Date: 12/4/2003 15:36:41 ******/
CREATE TABLE [OW].[tblRegistry] (
	[regid] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[doctypeid] [numeric](18, 0) NULL ,
	[bookid] [numeric](18, 0) NOT NULL ,
	[year] [numeric](18, 0) NOT NULL ,
	[number] [numeric](18, 0) NOT NULL ,
	[date] [datetime] NOT NULL ,
	[originref] [varchar] (30)  NULL ,
	[origindate] [datetime] NULL ,
	[subject] [nvarchar] (250)  NULL ,
	[observations] [nvarchar] (250)  NULL ,
	[processnumber] [nvarchar] (50)  NULL ,
	[cota] [nvarchar] (50)  NULL ,
	[bloco] [nvarchar] (50)  NULL ,
	[classid] [int] NULL ,
	[userID] [int] NULL ,
	[AntecedenteID] [numeric](18, 0) NULL ,
	[entID] [numeric](18, 0) NULL ,
	[UserModifyID] [int] NULL ,
	[DateModify] [datetime] NULL ,
	[historic] [bit] NOT NULL ,
	[field1] [float] NULL ,
	[field2] [nvarchar] (50)  NULL ,
	[activeDate] [datetime] NULL ,
	[IdIdentityCB] [int] NULL ,
	[Barcode] [uniqueidentifier] NULL ,
	[ProdEntityID] [numeric](18, 0) NULL ,
	[FundoID] [decimal](18, 0) NULL ,
	[SerieID] [decimal](18, 0) NULL ,
	[FisicalID] [int] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistryDistribution]    Script Date: 12/4/2003 15:36:41 ******/
CREATE TABLE [OW].[tblRegistryDistribution] (
	[ID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[RegID] [numeric](18, 0) NULL ,
	[userID] [int] NOT NULL ,
	[DistribDate] [datetime] NOT NULL ,
	[DistribObs] [nvarchar] (250)  NULL ,
	[Tipo] [numeric](18, 0) NOT NULL ,
	[radioVia] [varchar] (20)  NULL ,
	[chkFile] [bit] NULL ,
	[DistribTypeID] [numeric](18, 0) NULL ,
	[txtEntidadeID] [numeric](18, 0) NULL ,
	[state] [tinyint] NULL ,
	[ConnectID] [numeric](18, 0) NULL ,
	[dispatch] [numeric](18, 0) NULL ,
	[AddresseeType] [char](1) NULL,
	[AddresseeID] [numeric] (18) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistryEntities]    Script Date: 12/4/2003 15:36:42 ******/
CREATE TABLE [OW].[tblRegistryEntities] (
	[RegEntID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[RegID] [numeric](18, 0) NULL ,
	[EntID] [numeric](18, 0) NULL ,
	[Type] [char] (1)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistryHist]    Script Date: 12/4/2003 15:36:42 ******/
CREATE TABLE [OW].[tblRegistryHist] (
	[regid] [numeric](18, 0) NOT NULL ,
	[doctypeid] [numeric](18, 0) NULL ,
	[bookid] [numeric](18, 0) NOT NULL ,
	[year] [numeric](18, 0) NOT NULL ,
	[number] [numeric](18, 0) NOT NULL ,
	[date] [datetime] NOT NULL ,
	[originref] [varchar] (30)  NULL ,
	[origindate] [datetime] NULL ,
	[subject] [nvarchar] (250)  NULL ,
	[observations] [nvarchar] (250)  NULL ,
	[processnumber] [nvarchar] (50)  NULL ,
	[cota] [nvarchar] (50)  NULL ,
	[bloco] [nvarchar] (50)  NULL ,
	[classid] [int] NULL ,
	[userID] [int] NULL ,
	[AntecedenteID] [numeric](18, 0) NULL ,
	[entID] [numeric](18, 0) NULL ,
	[UserModifyID] [int] NULL ,
	[DateModify] [datetime] NULL ,
	[historic] [bit] NOT NULL ,
	[field1] [float] NULL ,
	[field2] [nvarchar] (50)  NULL ,
	[activeDate] [datetime] NULL ,
	[IdIdentityCB] [int] NULL ,
	[Barcode] [uniqueidentifier] NULL ,
	[ProdEntityID] [numeric](18, 0) NULL ,
	[FundoID] [decimal](18, 0) NULL ,
	[SerieID] [decimal](18, 0) NULL ,
	[FisicalID] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistryKeywords]    Script Date: 12/4/2003 15:36:42 ******/
CREATE TABLE [OW].[tblRegistryKeywords] (
	[regID] [numeric](18, 0) NOT NULL ,
	[keyID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblStrings]    Script Date: 12/4/2003 15:36:43 ******/
CREATE TABLE [OW].[tblStrings] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[value] [varchar] (500)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblTexts]    Script Date: 12/4/2003 15:36:43 ******/
CREATE TABLE [OW].[tblTexts] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL ,
	[FormFieldKey] [numeric](18, 0) NOT NULL ,
	[Value] [varchar] (4000)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblUser]    Script Date: 12/4/2003 15:36:43 ******/
CREATE TABLE [OW].[tblUser] (
	[userID] [int] IDENTITY (1, 1) NOT NULL ,
	[PrimaryGroupID] int NULL ,
	[userDesc] [varchar] (50)  NOT NULL ,
	[userMail] [varchar] (50)  NULL ,
	[Phone] [varchar] (25) NULL,
	[MobilePhone] [varchar] (25)  NULL,
	[Fax] [varchar] (25)  NULL,
	[NotifyByMail] [bit] NOT NULL,
	[NotifyBySMS] [bit] NOT NULL,
	[userLogin] [varchar] (50)  NOT NULL ,
	[Password] [varchar] (50)  NULL,
	[EntityID] [numeric] (18,0) NULL,
	[TextSignature] [varchar] (300)  NULL ,
	[GroupHead] [bit] NOT NULL,
	[userActive] [bit] NOT NULL ,
	[Remarks] [varchar] (255) NULL,
	[InsertedBy] [varchar] (50) NOT NULL,
	[InsertedOn] [datetime] NOT NULL,
	[LastModifiedBy] [varchar] (50) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblUserPersistence]    Script Date: 12/4/2003 15:36:44 ******/
CREATE TABLE [OW].[tblUserPersistence] (
	[UPID]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[formFieldKEY] [numeric](18, 0) NOT NULL ,
	[UserID] [int] NOT NULL ,
	[fieldValue] [varchar] (4000)  NOT NULL, 
	[fieldValue2] [varchar] (4000)  NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblUserPersistenceConfig]    Script Date: 12/4/2003 15:36:44 ******/
CREATE TABLE [OW].[tblUserPersistenceConfig] (
	[UserID] [int] NOT NULL ,
	[formfieldkey] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblProduct] (
	[ProductID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[ObjectTypeID] [numeric](18, 0) NOT NULL ,
	[ProductName] [varchar] (255) NULL 
) ON [PRIMARY]
GO

/****************************************************************************************************************/
/*  Tables ARchive */ 
/****************************************************************************************************************/
/****** Object:  Table [OW].[tblArchFundo]    Script Date: 23-11-2005 14:06:11 ******/
CREATE TABLE [OW].[tblArchFundo] (
	[FundoID] [decimal](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Level] [smallint] NOT NULL ,
	[ParentID] [decimal](18, 0) NULL ,
	[Code] [varchar] (50)  NOT NULL ,
	[Description] [varchar] (250)  NOT NULL ,
	[Global] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblArchPackageUnit]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblArchPackageUnit] (
	[PackageUnitID] [decimal](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (250)  NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblArchSerie]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblArchSerie] (
	[SerieID] [decimal](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Level] [smallint] NOT NULL ,
	[ParentID] [decimal](18, 0) NULL ,
	[Code] [varchar] (50)  NOT NULL ,
	[Description] [varchar] (250)  NOT NULL ,
	[Global] [bit] NOT NULL ,
	[ActiveYears] [int] NULL ,
	[ActiveMonths] [int] NULL ,
	[ActiveFixed] [bit] NULL ,
	[SemiActiveYears] [int] NULL ,
	[SemiActiveMonths] [int] NULL ,
	[SemiActiveFixed] [bit] NULL ,
	[ReturnMonths] [int] NULL ,
	[ReturnDays] [int] NULL ,
	[ReturnFixed] [bit] NULL ,
	[DestinationID] [decimal](18, 0) NULL ,
	[DestinationFixed] [bit] NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblArchiveParent]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblArchiveParent] (
	[ArchiveParentID] [decimal](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (250)  NOT NULL ,
	[Size] [decimal](18, 0) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblOWArchiveConfig]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblOWArchiveConfig] (
	[ID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[DelevutionDate] [numeric](18, 0) NULL ,
	[Fix] [bit] NULL ,
	[EntityDescription] [varchar] (50)  NULL ,
	[EntityPlace] [varchar] (50)  NULL ,
	[SendingGuide] [varchar] (50)  NULL ,
	[DeletingGuide] [varchar] (50)  NULL ,
	[RequestIn] [varchar] (50)  NULL ,
	[RequestOut] [varchar] (50)  NULL ,
	[DefaultSender] [int] NULL ,
	[DefaultAddressee] [int] NULL ,
	[DefaultSequential] [bit] NULL ,
	[UserID] [int] NULL ,
	[Date] [datetime] NULL 
) ON [PRIMARY]
GO
/****** Object:  Table [OW].[tblRequest]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblRequest] (
	[RequestID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Number] [numeric](18, 0) NOT NULL ,
	[Year] [numeric](18, 0) NOT NULL ,
	[RequestDate] [datetime] NOT NULL ,
	[EntID] [numeric](18, 0) NOT NULL ,
	[RegID] [numeric](18, 0) NULL ,
	[SerieID] [numeric](18, 0) NULL ,
	[Reference] [varchar] (50)  NULL ,
	[ReferenceYear] [numeric](18, 0) NULL ,
	[MotionID] [numeric](18, 0) NOT NULL ,
	[MotiveID] [numeric](18, 0) NOT NULL ,
	[RequestTypeID] [numeric](18, 0) NOT NULL ,
	[Origin] [int] NOT NULL ,
	[LimitDate] [datetime] NULL ,
	[DevolutionDate] [datetime] NULL ,
	[State] [int] NOT NULL ,
	[Observation] [varchar] (500)  NULL ,
	[CreatedByID] [int] NOT NULL ,
	[CreatedDate] [datetime] NOT NULL ,
	[ModifiedByID] [int] NULL ,
	[ModifiedDate] [datetime] NULL ,
	[Subject] [varchar] (250)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRequestDestructionType]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblRequestDestructionType] (
	[DestructionID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100)  NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRequestMotionType]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblRequestMotionType] (
	[MotionID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100)  NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO [OW].[tblRequestMotionType] ([Description]) VALUES('Consulta em Arquivo')
INSERT INTO [OW].[tblRequestMotionType] ([Description]) VALUES('Requisitado para posterior entrega')

GO

/****** Object:  Table [OW].[tblRequestMotiveConsult]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblRequestMotiveConsult] (
	[MotiveID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100)  NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO [OW].[tblRequestMotiveConsult] ([Description]) VALUES('Estudos Universitários')
INSERT INTO [OW].[tblRequestMotiveConsult] ([Description]) VALUES('Investigação')
INSERT INTO [OW].[tblRequestMotiveConsult] ([Description]) VALUES('Lazer')

GO

/****** Object:  Table [OW].[tblRequestType]    Script Date: 23-11-2005 14:06:12 ******/
CREATE TABLE [OW].[tblRequestType] (
	[RequestID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (100)  NOT NULL 
) ON [PRIMARY]
GO

INSERT INTO [OW].[tblRequestType] ([Description]) VALUES('Registo')
INSERT INTO [OW].[tblRequestType] ([Description]) VALUES('Processo')
INSERT INTO [OW].[tblRequestType] ([Description]) VALUES('Livro')
INSERT INTO [OW].[tblRequestType] ([Description]) VALUES('Documento')
INSERT INTO [OW].[tblRequestType] ([Description]) VALUES('Serie')
INSERT INTO [OW].[tblRequestType] ([Description]) VALUES('Unidade de Instalação')

GO

CREATE TABLE [OW].[tblArchClassification]
(
	[ClassificationID] [decimal] (18, 0) NOT NULL IDENTITY(1, 1),
	[Level] [smallint] NOT NULL,
	[ParentID] [decimal] (18, 0) NULL,
	[Code] [varchar] (50)  NOT NULL,
	[Description] [varchar] (250)  NOT NULL,
	[Global] [bit] NOT NULL,
	[Scope] [smallint] NOT NULL
)
GO



CREATE TABLE [OW].[tblArchFields] (
	[IdField] int IDENTITY (1, 1) NOT FOR REPLICATION  NOT NULL ,
	[OriginalName] [varchar] (50)  NOT NULL ,
	[OriginalDesignation] [varchar] (250)  NOT NULL ,
	[OriginalSize] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblArchFieldsVsSpace] (
	[IdSpace] int NOT NULL ,
	[IdField] int NOT NULL ,
	[Name] [varchar] (50)  NOT NULL ,
	[Designation] [varchar] (250)  NOT NULL ,
	[Size] [int] NULL ,
	[Visible] [bit] NOT NULL ,
	[Enabled] [bit] NOT NULL ,
	[Order] [int] NOT NULL ,
	[Html] [varchar] (5000)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblArchFisicalAccessType] (
	[IdFisicalAccessType] int IDENTITY (1, 1) NOT FOR REPLICATION  NOT NULL ,
	[IdParentFAT] int NULL ,
	[IdFisicalType] int NOT NULL ,
	[Order] [int] NOT NULL ,
	[InsertedBy] [varchar] (150)  NOT NULL ,
	[InsertedOn] [datetime] NOT NULL ,
	[LastModifiedBy] [varchar] (150)  NULL ,
	[LastModifiedOn] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblArchFisicalInsert] (
	[IdFisicalInsert] int IDENTITY (1, 1) NOT FOR REPLICATION  NOT NULL ,
	[IdParentFI] int NULL ,
	[IdFisicalAccessType] int NOT NULL ,
	[IdIdentityCB] int NOT NULL ,
	[Barcode]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[Order] [int] NOT NULL ,
	[InsertedBy] [varchar] (150)  NOT NULL ,
	[InsertedOn] [datetime] NOT NULL ,
	[LastModifiedBy] [varchar] (150)  NULL ,
	[LastModifiedOn] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblArchFisicalType] (
	[IdFisicalType] int IDENTITY (1, 1) NOT FOR REPLICATION  NOT NULL ,
	[IdSpace] int NOT NULL ,
	[Abreviation] [varchar] (5)  NOT NULL ,
	[Designation] [varchar] (50)  NOT NULL ,
	[Order] [int] NOT NULL ,
	[InsertedBy] [varchar] (150)  NOT NULL ,
	[InsertedOn] [datetime] NOT NULL ,
	[LastModifiedBy] [varchar] (150)  NULL ,
	[LastModifiedOn] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblArchInsertVsForm] (
	[IdFisicalInsert] int NOT NULL ,
	[IdSpace] int NOT NULL ,
	[IdField] int NOT NULL ,
	[Value] [varchar] (5000)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblArchSpace] (
	[IdSpace] int IDENTITY (1, 1) NOT NULL ,
	[OriginalAbreviation] [varchar] (3)  NOT NULL ,
	[CodeName] [varchar] (50)  NOT NULL ,
	[OriginalDesignation] [varchar] (50)  NOT NULL ,
	[Image] [varchar] (50)  NULL 
) ON [PRIMARY]
GO

CREATE TABLE [OW].[tblIdentityCB] (
	[IdIdentityCB] int IDENTITY (1, 1) NOT NULL ,
	[Designation] [varchar] (50)  NOT NULL 
) ON [PRIMARY]
GO

/****************************************************************************************************************/
/* (END) Tables Archive */ 
/****************************************************************************************************************/

ALTER TABLE [OW].[tblAccess] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblAccess] PRIMARY KEY  CLUSTERED 
	(
		[UserID],
		[ObjectParentID],
		[ObjectID],
		[ObjectTypeID],
		[ObjectType]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblAccessReg] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblAccessReg] PRIMARY KEY  CLUSTERED 
	(
		[UserID],
		[ObjectID],
		[ObjectType]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblBooks] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBooks] PRIMARY KEY  CLUSTERED 
	(
		[bookID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblBooksKeyword] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBooksKeyword] PRIMARY KEY  CLUSTERED 
	(
		[bookID],
		[keywordID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblClassification] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblClassification] PRIMARY KEY  CLUSTERED 
	(
		[ClassificationID]
	)  ON [PRIMARY]
GO
CREATE  INDEX [IX_tblClassification] ON [OW].[tblClassification]([ParentID]) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblClassification] ADD 
	CONSTRAINT [FK_tblClassification_tblClassification] FOREIGN KEY 
	(
		[ParentID]
	) REFERENCES [OW].[tblClassification] (
		[ClassificationID]
	)
GO

ALTER TABLE [OW].[tblClassificationBooks] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblClassificationBooks] PRIMARY KEY  CLUSTERED 
	(
		[ClassBookID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblCountry] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblCountry] PRIMARY KEY  CLUSTERED 
	(
		[CountryID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDateTimes] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDateTimes] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDates] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDates] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDispatch] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDispatch] PRIMARY KEY  CLUSTERED 
	(
		[dispatchid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDispatchBook] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDispatchBooks] PRIMARY KEY  CLUSTERED 
	(
		[bookID],
		[dispatchID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDistributionCode] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDistributionCode] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDistrict] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDistrict] PRIMARY KEY  CLUSTERED 
	(
		[DistrictID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDocumentType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDocumentType] PRIMARY KEY  CLUSTERED 
	(
		[doctypeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityList] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntityList] PRIMARY KEY  CLUSTERED 
	(
		[ListID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityListAccess] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntityListAccess] PRIMARY KEY  CLUSTERED 
	(
		[ObjectID],
		[ObjectParentID],
		[ObjectType]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityBIArquive] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntityBIArquive] PRIMARY KEY  CLUSTERED 
	(
		[BIArquiveID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityJobPosition] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntityJobPosition] PRIMARY KEY  CLUSTERED 
	(
		[JobPositionID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityListBIArquiveAssociation] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntityListBIArquiveAssociation] PRIMARY KEY  CLUSTERED 
	(
		[BIArquiveID],
		[ListID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityLocation] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntityLocation] PRIMARY KEY  CLUSTERED 
	(
		[LocationID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFields] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFields] PRIMARY KEY  CLUSTERED 
	(
		[FieldID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFieldsBookConfig] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFieldsBookConfig] PRIMARY KEY  CLUSTERED 
	(
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFieldsBooksPosition] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFieldsBooksPosition] PRIMARY KEY  CLUSTERED 
	(
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFileManager] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFileManager] PRIMARY KEY  CLUSTERED 
	(
		[FileID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFloats] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFloats] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFormFieldsType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFormFieldsType] PRIMARY KEY  CLUSTERED 
	(
		[DynFldTypeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblGroups] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblGroups] PRIMARY KEY  CLUSTERED 
	(
		[GroupID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblGroupsUsers] ADD 
	CONSTRAINT [PK_tblGroupsUsers] PRIMARY KEY  ([GroupsUserID]) ON [PRIMARY],
	CONSTRAINT [AK_tblGroupsUsers] UNIQUE CLUSTERED ([UserID], [GroupID]) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblIntegers] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblIntegers] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblKeywords] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblKeywords] PRIMARY KEY  CLUSTERED 
	(
		[keyID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblPostalCode] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblPostalCode] PRIMARY KEY  CLUSTERED 
	(
		[PostalCodeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblPostalCode] 
	ADD CONSTRAINT [IX_tblPostalCode01] 
	UNIQUE NONCLUSTERED  ([Code], [Description]) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblProfiles] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblProfiles] PRIMARY KEY  CLUSTERED 
	(
		[Profileid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblProfilesFields] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblProfilesFields] PRIMARY KEY  CLUSTERED 
	(
		[ProfileId],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRegistry] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRegistry] PRIMARY KEY  CLUSTERED 
	(
		[regid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRegistryDistribution] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRegistryDistribution] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRegistryEntities] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRegistryEntities] PRIMARY KEY  CLUSTERED 
	(
		[RegEntID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRegistryHist] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRegistryHist] PRIMARY KEY  CLUSTERED 
	(
		[regid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblStrings] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblStrings] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblTexts] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblTexts] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[BookID],
		[FormFieldKey]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblUser] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblUser] PRIMARY KEY  CLUSTERED 
	(
		[userID]
	)  ON [PRIMARY],
	CONSTRAINT [uniqueLogin] UNIQUE  NONCLUSTERED 
	(
		[userLogin]
	)  ON [PRIMARY]  
GO


ALTER TABLE [OW].[tblUserPersistence] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblUserPersistence] PRIMARY KEY  CLUSTERED 
	(
		[formFieldKEY],
		[UserID],
		[UPID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblUserPersistenceConfig] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblUserPersistenceConfig] PRIMARY KEY  CLUSTERED 
	(
		[UserID],
		[formfieldkey]
	)  ON [PRIMARY] 
GO

CREATE  CLUSTERED  INDEX [tblDistributionEntities_DIstribID_EntID_tmp] ON [OW].[tblDistributionEntities]([DistribID], [EntID], [Tmp]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

ALTER TABLE [OW].[tblAccess] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblAccess_ObjectType] DEFAULT (1) FOR [ObjectType]
GO

ALTER TABLE [OW].[tblBooks] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblBooks_automatic] DEFAULT (0) FOR [automatic]
GO

ALTER TABLE [OW].[tblBooksDocumentType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblBooksDocumentType] PRIMARY KEY  NONCLUSTERED 
	(
		[bookID],
		[documenttypeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDistribTemp] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblDistribTemp_state] DEFAULT (1) FOR [state],
	CONSTRAINT [PK_tblDistribTemp] PRIMARY KEY  NONCLUSTERED 
	(
		[TmpID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblDistributionType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblDistributionType] PRIMARY KEY  NONCLUSTERED 
	(
		[DistribTypeID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntities] ADD 
	CONSTRAINT [DF_tblEntities_Type] DEFAULT (1) FOR [Type],
	CONSTRAINT [PK_tblEntities] PRIMARY KEY  NONCLUSTERED 
	(
		[EntID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityType] ADD CONSTRAINT [PK_tblEntityType] PRIMARY KEY CLUSTERED  ([EntityTypeID]) ON [PRIMARY]
GO
ALTER TABLE [OW].[tblEntityType] ADD CONSTRAINT [AK_tblEntityType01] UNIQUE NONCLUSTERED  ([Description]) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblEntitiesTemp] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblEntitiesTemp] PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblEntityList] WITH NOCHECK ADD 
	CONSTRAINT [IX_tblEntityList_Description] UNIQUE  NONCLUSTERED 
	(
		[Description]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFormFields] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFormFields] PRIMARY KEY  NONCLUSTERED 
	(
		[formFieldKEY]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblFormFieldsBooks] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblFormFieldsBooks] PRIMARY KEY  NONCLUSTERED 
	(
		[bookID],
		[formID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRegistry] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblRegistry_historic] DEFAULT (0) FOR [historic],
	CONSTRAINT [DF_tblRegistry_IdIdentityCB] DEFAULT (1) FOR [IdIdentityCB],
	CONSTRAINT [DF_tblRegistry_Barcode] DEFAULT (newid()) FOR [Barcode]
GO

ALTER TABLE [OW].[tblRegistryDistribution] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblRegistryDistribution_state] DEFAULT (2) FOR [state]
GO

ALTER TABLE [OW].[tblRegistryHist] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblRegistryHist_historic] DEFAULT (1) FOR [historic],
	CONSTRAINT [DF_tblRegistryHist_IdIdentityCB] DEFAULT (1) FOR [IdIdentityCB],
	CONSTRAINT [DF_tblRegistryHist_Barcode] DEFAULT (newid()) FOR [Barcode]
GO

ALTER TABLE [OW].[tblRegistryKeywords] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRegistryKeywords] PRIMARY KEY  NONCLUSTERED 
	(
		[regID],
		[keyID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblUserPersistence] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblUserPersistence_UP] DEFAULT (newid()) FOR [UPID]
GO

ALTER TABLE OW.tblFieldsBookDuplicated ADD 
	CONSTRAINT tblFieldsBookDuplicated_PK  PRIMARY KEY CLUSTERED (DuplicatedID),
	CONSTRAINT FBDP_FK1_BK  FOREIGN KEY (BookID) REFERENCES OW.tblBooks (BookID) ON DELETE CASCADE,
	CONSTRAINT FBDP_FK2_FRF  FOREIGN KEY (FormFieldKEY) REFERENCES OW.tblFormFields (FormFieldKEY) ON DELETE CASCADE,
	CONSTRAINT FBDP_UK1 UNIQUE NONCLUSTERED  (BookID,FormFieldKEY)
GO


/****************************************************************************************************************/
/* Constraints Archive */ 
/****************************************************************************************************************/


ALTER TABLE [OW].[tblArchFundo] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchFundo] PRIMARY KEY  CLUSTERED 
	(
		[FundoID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchPackageUnit] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchPackageUnit] PRIMARY KEY  CLUSTERED 
	(
		[PackageUnitID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchSerie] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchSerie] PRIMARY KEY  CLUSTERED 
	(
		[SerieID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchiveParent] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchiveParent] PRIMARY KEY  CLUSTERED 
	(
		[ArchiveParentID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblOWArchiveConfig] WITH NOCHECK ADD 
	CONSTRAINT [PK_OWArchiveConfig] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRequest] PRIMARY KEY  CLUSTERED 
	(
		[RequestID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRequestDestructionType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRequestDestructionType] PRIMARY KEY  CLUSTERED 
	(
		[DestructionID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRequestMotionType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRequestMotionType] PRIMARY KEY  CLUSTERED 
	(
		[MotionID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRequestMotiveConsult] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRequestMotiveConsult] PRIMARY KEY  CLUSTERED 
	(
		[MotiveID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRequestType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRequestType] PRIMARY KEY  CLUSTERED 
	(
		[RequestID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchSerie] WITH NOCHECK ADD 
	CONSTRAINT [Code_tblArchSerie] UNIQUE  NONCLUSTERED 
	(
		[Code]
	)  ON [PRIMARY] 
GO
ALTER TABLE [OW].[tblRequest] WITH NOCHECK ADD 
	CONSTRAINT [CK_tblRequest_Origin] CHECK ([Origin] = 2 or [Origin] = 1),
	CONSTRAINT [CK_tblRequest_State] CHECK ([State] = 5 or ([State] = 4 or ([State] = 3 or ([State] = 2 or [State] = 1)))),
	CONSTRAINT [tblRequest_ck] CHECK ([regID] is not null and [serieID] is null or [regid] is null and [serieid] is not null)
GO

ALTER TABLE [OW].[tblRequestMotiveConsult] WITH NOCHECK ADD 
	CONSTRAINT [IX_tblRequestMotiveConsult_Description] UNIQUE  NONCLUSTERED 
	(
		[Description]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblRequestType] WITH NOCHECK ADD 
	CONSTRAINT [IX_tblRequestType_Description] UNIQUE  NONCLUSTERED 
	(
		[Description]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFields] WITH NOCHECK ADD 
	CONSTRAINT [PK_tlbArchFields] PRIMARY KEY  CLUSTERED 
	(
		[IdField]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFieldsVsSpace] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchFieldsVsSpace] PRIMARY KEY  CLUSTERED 
	(
		[IdSpace],
		[IdField]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFisicalAccessType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchFisicalAccesType] PRIMARY KEY  CLUSTERED 
	(
		[IdFisicalAccessType]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFisicalInsert] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchFisicalInsert] PRIMARY KEY  CLUSTERED 
	(
		[IdFisicalInsert]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFisicalType] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchFisicalType] PRIMARY KEY  CLUSTERED 
	(
		[IdFisicalType]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchInsertVsForm] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchInsertVsForm] PRIMARY KEY  CLUSTERED 
	(
		[IdFisicalInsert],
		[IdSpace],
		[IdField]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchSpace] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblArchSpace] PRIMARY KEY  CLUSTERED 
	(
		[IdSpace]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblIdentityCB] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblIdentityCB] PRIMARY KEY  CLUSTERED 
	(
		[IdIdentityCB]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFields] ADD 
	CONSTRAINT [IX_tblArchFields] UNIQUE  NONCLUSTERED 
	(
		[OriginalName],
		[OriginalDesignation]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFieldsVsSpace] ADD 
	CONSTRAINT [DF_tblArchFieldsVsSpace_Visible] DEFAULT (1) FOR [Visible],
	CONSTRAINT [DF_tblArchFieldsVsSpace_Enabled] DEFAULT (1) FOR [Enabled],
	CONSTRAINT [DF_tblArchFieldsVsSpace_Order] DEFAULT (0) FOR [Order]
GO

ALTER TABLE [OW].[tblArchFisicalAccessType] ADD 
	CONSTRAINT [DF_tblArchFisicalAccessType_Order] DEFAULT (0) FOR [Order],
	CONSTRAINT [DF_tblArchFisicalAccessType_InsertedBy] DEFAULT (user_name()) FOR [InsertedBy],
	CONSTRAINT [DF_tblArchFisicalAccessType_InsertedOn] DEFAULT (getdate()) FOR [InsertedOn]
GO

CREATE  INDEX [IX_tblArchFisicalAccessType] ON [OW].[tblArchFisicalAccessType]([IdParentFAT]) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblArchFisicalInsert] ADD 
	CONSTRAINT [DF_tblArchFisicalInsert_IdIdentityCB] DEFAULT (2) FOR [IdIdentityCB],
	CONSTRAINT [DF_tblArchFisicalInsert_Barcode] DEFAULT (newid()) FOR [Barcode],
	CONSTRAINT [DF_tblArchFisicalInsert_Order] DEFAULT (0) FOR [Order],
	CONSTRAINT [DF_tblArchFisicalInsert_InsertedBy] DEFAULT (user_name()) FOR [InsertedBy],
	CONSTRAINT [DF_tblArchFisicalInsert_InsertedOn] DEFAULT (getdate()) FOR [InsertedOn]
GO

 CREATE  INDEX [IX_tblArchFisicalInsert] ON [OW].[tblArchFisicalInsert]([IdParentFI]) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblArchFisicalType] ADD 
	CONSTRAINT [DF_tblArchFisicalType_Order] DEFAULT (0) FOR [Order],
	CONSTRAINT [DF_tblArchFisicalType_InsertedBy] DEFAULT (user_name()) FOR [InsertedBy],
	CONSTRAINT [DF_tblArchFisicalType_InsertedOn] DEFAULT (getdate()) FOR [InsertedOn],
	CONSTRAINT [IX_tblArchFisicalType] UNIQUE  NONCLUSTERED 
	(
		[Abreviation]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchSpace] ADD 
	CONSTRAINT [IX_tblArchSpace] UNIQUE  NONCLUSTERED 
	(
		[OriginalAbreviation]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblArchFieldsVsSpace] ADD 
	CONSTRAINT [FK_tblArchFieldsVsSpace_tblArchSpace] FOREIGN KEY 
	(
		[IdSpace]
	) REFERENCES [OW].[tblArchSpace] (
		[IdSpace]
	),
	CONSTRAINT [FK_tblArchFieldsVsSpace_tlbArchFields] FOREIGN KEY 
	(
		[IdField]
	) REFERENCES [OW].[tblArchFields] (
		[IdField]
	)
GO

ALTER TABLE [OW].[tblArchFisicalAccessType] ADD 
	CONSTRAINT [FK_tblArchFisicalAccessType_tblArchFisicalAccessType] FOREIGN KEY 
	(
		[IdParentFAT]
	) REFERENCES [OW].[tblArchFisicalAccessType] (
		[IdFisicalAccessType]
	),
	CONSTRAINT [FK_tblArchFisicalAccessType_tblArchFisicalType] FOREIGN KEY 
	(
		[IdFisicalType]
	) REFERENCES [OW].[tblArchFisicalType] (
		[IdFisicalType]
	)
GO

ALTER TABLE [OW].[tblArchFisicalInsert] ADD 
	CONSTRAINT [FK_tblArchFisicalInsert_tblArchFisicalAccessType] FOREIGN KEY 
	(
		[IdFisicalAccessType]
	) REFERENCES [OW].[tblArchFisicalAccessType] (
		[IdFisicalAccessType]
	),
	CONSTRAINT [FK_tblArchFisicalInsert_tblArchFisicalInsert] FOREIGN KEY 
	(
		[IdParentFI]
	) REFERENCES [OW].[tblArchFisicalInsert] (
		[IdFisicalInsert]
	),
	CONSTRAINT [FK_tblArchFisicalInsert_tblIdentityCB] FOREIGN KEY 
	(
		[IdIdentityCB]
	) REFERENCES [OW].[tblIdentityCB] (
		[IdIdentityCB]
	)
GO

ALTER TABLE [OW].[tblArchFisicalType] ADD 
	CONSTRAINT [FK_tblArchFisicalType_tblArchSpace] FOREIGN KEY 
	(
		[IdSpace]
	) REFERENCES [OW].[tblArchSpace] (
		[IdSpace]
	)
GO

ALTER TABLE [OW].[tblArchInsertVsForm] ADD 
	CONSTRAINT [CK_tblArchInsertVsForm] CHECK ([IdField] <> 1 and [value] is not null or [IdField] <> 2 and [value] is not null)
GO

ALTER TABLE [OW].[tblArchInsertVsForm] ADD 
	CONSTRAINT [FK_tblArchInsertVsForm_tblArchFieldsVsSpace] FOREIGN KEY 
	(
		[IdSpace],
		[IdField]
	) REFERENCES [OW].[tblArchFieldsVsSpace] (
		[IdSpace],
		[IdField]
	),
	CONSTRAINT [FK_tblArchInsertVsForm_tblArchFisicalInsert] FOREIGN KEY 
	(
		[IdFisicalInsert]
	) REFERENCES [OW].[tblArchFisicalInsert] (
		[IdFisicalInsert]
	) ON DELETE CASCADE 
GO


/****************************************************************************************************************/
/* (END) Constraints Archive */ 
/****************************************************************************************************************/


 CREATE  INDEX [tblaccess_objectParentID_ObjectTypeID] ON [OW].[tblAccess]([ObjectParentID], [ObjectTypeID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblAccess_UserID] ON [OW].[tblAccess]([UserID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblaccess_objectParentID_ObjectID_ObjecttypeID_Objecttype] ON [OW].[tblAccess]([ObjectParentID], [ObjectID], [ObjectTypeID], [ObjectType]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblAccess_ObjectParentID_ObjectTypeID_ObjectID] ON [OW].[tblAccess]([ObjectParentID], [ObjectTypeID], [ObjectID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblaccess_objectid] ON [OW].[tblAccess]([ObjectID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblaccess_objecttype] ON [OW].[tblAccess]([ObjectType]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblaccess_objecttypeid] ON [OW].[tblAccess]([ObjectTypeID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblAccessReg_ObjectID] ON [OW].[tblAccessReg]([ObjectID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [tblBooks_abreviation] ON [OW].[tblBooks]([abreviation]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [tblDateTimes_RegID] ON [OW].[tblDateTimes]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblDates_RegID] ON [OW].[tblDates]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [tblDispatch_abreviation] ON [OW].[tblDispatch]([abreviation]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [tblDistribTemp_TmpID_Tipo] ON [OW].[tblDistribTemp]([TmpID], [tipo]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tblDistributionEntities] ON [OW].[tblDistributionEntities]([DistribID], [RegID], [EntID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tblDistributionEntities_1] ON [OW].[tblDistributionEntities]([DistribID]) ON [PRIMARY]
GO

 CREATE  INDEX [tblDistributionentities_tmp] ON [OW].[tblDistributionEntities]([Tmp]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblEntities_DistribID] ON [OW].[tblDistributionEntities]([DistribID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tblEntities_BI] ON [OW].[tblEntities]([BI]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tblEntities_NumContribuinte] ON [OW].[tblEntities]([NumContribuinte]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_tblEntities_AssociateNum] ON [OW].[tblEntities]([AssociateNum]) ON [PRIMARY]
GO

 CREATE  INDEX [tblFloats_RegID] ON [OW].[tblFloats]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblGroupsUsers_groupid] ON [OW].[tblGroupsUsers]([GroupID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblIntegers_RegID] ON [OW].[tblIntegers]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [TblReg_Number] ON [OW].[tblRegistry]([number] DESC ) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [TblReg_BookId] ON [OW].[tblRegistry]([bookid]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [TblReg_Year] ON [OW].[tblRegistry]([year]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [tblRegistry_bookid_year_number] ON [OW].[tblRegistry]([bookid], [year], [number]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [tblRegistry_AntecedenteID] ON [OW].[tblRegistry]([AntecedenteID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblregistrydistribution_regid] ON [OW].[tblRegistryDistribution]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [IX_tblRegistryEntities] ON [OW].[tblRegistryEntities]([RegID]) ON [PRIMARY]
GO

 CREATE  INDEX [regHist_Number] ON [OW].[tblRegistryHist]([number] DESC ) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [TblRegHist_Year] ON [OW].[tblRegistryHist]([year]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [TblRegHist_BookID] ON [OW].[tblRegistryHist]([bookid]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [tblRegistryHist_AntecedenteID] ON [OW].[tblRegistryHist]([AntecedenteID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblStrings_RegID] ON [OW].[tblStrings]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblTexts_RegID] ON [OW].[tblTexts]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO


/****************************************************************************************************************/
/* Index Archive */ 
/****************************************************************************************************************/

 CREATE  UNIQUE  INDEX [IX_tblRequest_Number_Year] ON [OW].[tblRequest]([Number], [Year]) ON [PRIMARY]
GO

/****************************************************************************************************************/
/* (END) Index Archive */ 
/****************************************************************************************************************/



ALTER TABLE [OW].[tblBooksDocumentType] ADD 
	CONSTRAINT [FK_tblBooksDocumentType_tblBooks] FOREIGN KEY 
	(
		[bookID]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	),
	CONSTRAINT [FK_tblBooksDocumentType_tblDocumentType] FOREIGN KEY 
	(
		[documenttypeID]
	) REFERENCES [OW].[tblDocumentType] (
		[doctypeID]
	)
GO

ALTER TABLE [OW].[tblBooksKeyword] ADD 
	CONSTRAINT [FK_tblBooksKeyword_tblBooks] FOREIGN KEY 
	(
		[bookID]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	),
	CONSTRAINT [FK_tblBooksKeyword_tblKeywords] FOREIGN KEY 
	(
		[keywordID]
	) REFERENCES [OW].[tblKeywords] (
		[keyID]
	)
GO

ALTER TABLE [OW].[tblClassificationBooks] ADD 
	CONSTRAINT [FK_tblClassificationBooks_tblBooks] FOREIGN KEY 
	(
		[BookID]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	),
	CONSTRAINT [FK_tblClassificationBooks_tblClassification] FOREIGN KEY 
	(
		[ClassID]
	) REFERENCES [OW].[tblClassification] (
		[ClassificationID]
	)
GO

ALTER TABLE [OW].[tblDistribTemp] ADD 
	CONSTRAINT [FK_tblDistribTemp_tblEntities] FOREIGN KEY 
	(
		[txtEntidadeID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	)
GO

ALTER TABLE [OW].[tblDistributionEntities] ADD 
	CONSTRAINT [FK_tblDistributionEntities_tblEntities] FOREIGN KEY 
	(
		[EntID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	)
GO

ALTER TABLE [OW].[tblDistrict] 
	ADD CONSTRAINT [FK_tblDistrict_tblCountry] 
	FOREIGN KEY ([CountryID]) REFERENCES [OW].[tblCountry] ([CountryID])
GO

ALTER TABLE [OW].[tblEntities] ADD
	CONSTRAINT [FK_tblEntities_tblEntityBIArquive] FOREIGN KEY 
	(
		[BIArquiveID]
	) REFERENCES [OW].[tblEntityBIArquive] (
		[BIArquiveID]
	),
	CONSTRAINT [FK_tblEntities_tblEntityJobPosition] FOREIGN KEY 
	(
		[JobPositionID]
	) REFERENCES [OW].[tblEntityJobPosition] (
		[JobPositionID]
	),
	CONSTRAINT [FK_tblEntities_tblEntityLocation] FOREIGN KEY 
	(
		[LocationID]
	) REFERENCES [OW].[tblEntityLocation] (
		[LocationID]
	), 
	CONSTRAINT [FK_tblEntities_tblCountry] FOREIGN KEY 
	(
		[CountryID]
	) REFERENCES [OW].[tblCountry] (
		[CountryID]
	),
	CONSTRAINT [FK_tblEntities_tblDistrict] FOREIGN KEY 
	(
		[DistrictID]
	) REFERENCES [OW].[tblDistrict] (
		[DistrictID]
	),
	CONSTRAINT [FK_tblEntities_tblEntities] FOREIGN KEY 
	(
		[EntityID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	),
	CONSTRAINT [FK_tblEntities_tblEntityList] FOREIGN KEY 
	(
		[ListID]
	) REFERENCES [OW].[tblEntityList] (
		[ListID]
	),
	CONSTRAINT [FK_tblEntities_tblPostalCode] FOREIGN KEY 
	(
		[PostalCodeID]
	) REFERENCES [OW].[tblPostalCode] (
		[PostalCodeID]
	)
GO

ALTER TABLE [OW].[tblEntities] 
	ADD CONSTRAINT [FK_tblEntities_tblEntityType] 
	FOREIGN KEY ([EntityTypeID]) REFERENCES [OW].[tblEntityType] ([EntityTypeID])
GO

ALTER TABLE [OW].[tblFieldsBookConfig] ADD 
	CONSTRAINT [FK_tblFieldsBookConfig_tblBooks] FOREIGN KEY 
	(
		[BookID]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	),
	CONSTRAINT [FK_tblFieldsBookConfig_tblFormFields] FOREIGN KEY 
	(
		[FormFieldKey]
	) REFERENCES [OW].[tblFormFields] (
		[formFieldKEY]
	)
GO

ALTER TABLE [OW].[tblFieldsBooksPosition] ADD 
	CONSTRAINT [FK_tblFieldsBooksPosition_tblBooks] FOREIGN KEY 
	(
		[BookID]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	),
	CONSTRAINT [FK_tblFieldsBooksPosition_tblFormFields] FOREIGN KEY 
	(
		[FormFieldKey]
	) REFERENCES [OW].[tblFormFields] (
		[formFieldKEY]
	)
GO

ALTER TABLE [OW].[tblFormFields] ADD 
	CONSTRAINT [FK_tblFormFields_tblFormFieldsType] FOREIGN KEY 
	(
		[DynFldTypeID]
	) REFERENCES [OW].[tblFormFieldsType] (
		[DynFldTypeID]
	)
GO

ALTER TABLE [OW].[tblFormFieldsBooks] ADD 
	CONSTRAINT [FK_tblFormFieldsBooks_tblBooks] FOREIGN KEY 
	(
		[bookID]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	)
GO

ALTER TABLE [OW].[tblGroups] ADD CONSTRAINT [AK_tblGroups01] UNIQUE NONCLUSTERED  ([ShortName]) ON [PRIMARY]
GO
ALTER TABLE [OW].[tblGroups] ADD CONSTRAINT [AK_tblGroups02] UNIQUE NONCLUSTERED  ([GroupDesc]) ON [PRIMARY]
GO
ALTER TABLE [OW].[tblGroups] ADD CONSTRAINT [FK_tblGroups_tblGroups] FOREIGN KEY ([HierarchyID]) REFERENCES [OW].[tblGroups] ([GroupID])
GO

ALTER TABLE [OW].[tblGroupsUsers] ADD 
	CONSTRAINT [FK_tblGroupsUsers_tblGroups] FOREIGN KEY 
	(
		[GroupID]
	) REFERENCES [OW].[tblGroups] (
		[GroupID]
	),
	CONSTRAINT [FK_tblGroupsUsers_tblUser] FOREIGN KEY 
	(
		[UserID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	)
GO

ALTER TABLE [OW].[tblRegistry] ADD 
	CONSTRAINT [FK_tblRegistry_tblBooks] FOREIGN KEY 
	(
		[bookid]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	),
	CONSTRAINT [FK_tblRegistry_tblClassification] FOREIGN KEY 
	(
		[classid]
	) REFERENCES [OW].[tblClassification] (
		[ClassificationID]
	),
	CONSTRAINT [FK_tblRegistry_tblDocumentType] FOREIGN KEY 
	(
		[doctypeid]
	) REFERENCES [OW].[tblDocumentType] (
		[doctypeID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_tblRegistry_tblUser] FOREIGN KEY 
	(
		[userID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	),
	CONSTRAINT [FK_tblRegistry_tblIdentityCB] FOREIGN KEY 
	(
		[IdIdentityCB]
	) REFERENCES [OW].[tblIdentityCB] (
		[IdIdentityCB]
	),
	CONSTRAINT [FK_tblRegistry_tblEntities2] FOREIGN KEY 
	(
		[ProdEntityID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	),
	CONSTRAINT [FK_tblRegistry_tblArchFundo] FOREIGN KEY 
	(
		[FundoID]
	) REFERENCES [OW].[tblArchFundo] (
		[FundoID]
	),
	CONSTRAINT [FK_tblRegistry_tblArchSerie] FOREIGN KEY 
	(
		[SerieID]
	) REFERENCES [OW].[tblArchSerie] (
		[SerieID]
	),
	CONSTRAINT [FK_tblRegistry_tblArchFisicalInsert] FOREIGN KEY 
	(
		[FisicalId]
	) REFERENCES [OW].[tblArchFisicalInsert] (
		[IdFisicalInsert]
	)
GO

ALTER TABLE [OW].[tblRegistryDistribution] ADD 
	CONSTRAINT [FK_tblRegistryDistribution_tblDistributionType] FOREIGN KEY 
	(
		[DistribTypeID]
	) REFERENCES [OW].[tblDistributionType] (
		[DistribTypeID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_tblRegistryDistribution_tblUser] FOREIGN KEY 
	(
		[userID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	) NOT FOR REPLICATION 
GO

ALTER TABLE [OW].[tblRegistryEntities] ADD 
	CONSTRAINT [FK_tblRegistryEntities_tblEntities] FOREIGN KEY 
	(
		[EntID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	) NOT FOR REPLICATION 
GO

ALTER TABLE [OW].[tblRegistryHist] ADD 
	CONSTRAINT [FK_tblRegistryHist_tblBooks] FOREIGN KEY 
	(
		[bookid]
	) REFERENCES [OW].[tblBooks] (
		[bookID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_tblRegistryHist_tblClassification] FOREIGN KEY 
	(
		[classid]
	) REFERENCES [OW].[tblClassification] (
		[ClassificationID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_tblRegistryHist_tblDocumentType] FOREIGN KEY 
	(
		[doctypeid]
	) REFERENCES [OW].[tblDocumentType] (
		[doctypeID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_tblRegistryHist_tblUser] FOREIGN KEY 
	(
		[userID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	) NOT FOR REPLICATION ,
	CONSTRAINT [FK_tblRegistryHist_tblIdentityCB] FOREIGN KEY 
	(
		[IdIdentityCB]
	) REFERENCES [OW].[tblIdentityCB] (
		[IdIdentityCB]
	),
	CONSTRAINT [FK_tblRegistryHist_tblEntities2] FOREIGN KEY 
	(
		[ProdEntityID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	),
	CONSTRAINT [FK_tblRegistryHist_tblArchFundo] FOREIGN KEY 
	(
		[FundoID]
	) REFERENCES [OW].[tblArchFundo] (
		[FundoID]
	),
	CONSTRAINT [FK_tblRegistryHist_tblArchSerie] FOREIGN KEY 
	(
		[SerieID]
	) REFERENCES [OW].[tblArchSerie] (
		[SerieID]
	),
	CONSTRAINT [FK_tblRegistryHist_tblArchFisicalInsert] FOREIGN KEY 
	(
		[FisicalId]
	) REFERENCES [OW].[tblArchFisicalInsert] (
		[IdFisicalInsert]
	)
GO

ALTER TABLE [OW].[tblRegistryKeywords] ADD 
	CONSTRAINT [FK_tblRegistryKeywords_tblKeywords] FOREIGN KEY 
	(
		[keyID]
	) REFERENCES [OW].[tblKeywords] (
		[keyID]
	)
GO

ALTER TABLE [OW].[tblUser] ADD CONSTRAINT [FK_tblUser_tblEntities] FOREIGN KEY ([EntityID]) REFERENCES [OW].[tblEntities] ([EntID])
GO

ALTER TABLE [OW].[tblUser] ADD CONSTRAINT [FK_tblUser_tblGroups] FOREIGN KEY ([PrimaryGroupID]) REFERENCES [OW].[tblGroups] ([GroupID])
GO

/****************************************************************************************************************/
/* FK Archive */ 
/****************************************************************************************************************/

ALTER TABLE [OW].[tblArchFundo] ADD 
	CONSTRAINT [FK_tblArchFundo_tblArchFundo] FOREIGN KEY 
	(
		[ParentID]
	) REFERENCES [OW].[tblArchFundo] (
		[FundoID]
	)
GO

ALTER TABLE [OW].[tblArchSerie] ADD 
	CONSTRAINT [FK_tblArchSerie_tblArchSerie] FOREIGN KEY 
	(
		[ParentID]
	) REFERENCES [OW].[tblArchSerie] (
		[SerieID]
	)
GO

ALTER TABLE [OW].[tblOWArchiveConfig] ADD 
	CONSTRAINT [FK_tblOWArchiveConfig_tblUser] FOREIGN KEY 
	(
		[UserID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	),
	CONSTRAINT [FK_tblOWArchiveConfig_tblUser1] FOREIGN KEY 
	(
		[DefaultSender]
	) REFERENCES [OW].[tblUser] (
		[userID]
	),
	CONSTRAINT [FK_tblOWArchiveConfig_tblUser2] FOREIGN KEY 
	(
		[DefaultAddressee]
	) REFERENCES [OW].[tblUser] (
		[userID]
	)
GO

ALTER TABLE [OW].[tblArchClassification] ADD 
	CONSTRAINT [PK_tblArchClassification] PRIMARY KEY CLUSTERED  ([ClassificationID])
GO

ALTER TABLE [OW].[tblArchClassification] ADD 
	CONSTRAINT [FK_tblArchClassification_tblArchClassification] FOREIGN KEY 
	(
		[ParentID]
	) REFERENCES [OW].[tblArchClassification] (
		[ClassificationID]
	)
GO

ALTER TABLE [OW].[tblRequest] ADD 
	CONSTRAINT [FK_tblRequest_tblRequestMotionType] FOREIGN KEY 
	(
		[MotionID]
	) REFERENCES [OW].[tblRequestMotionType] (
		[MotionID]
	),
	CONSTRAINT [FK_tblRequest_tblRequestMotiveConsult1] FOREIGN KEY 
	(
		[MotiveID]
	) REFERENCES [OW].[tblRequestMotiveConsult] (
		[MotiveID]
	),
	CONSTRAINT [FK_tblRequest_tblRequestType] FOREIGN KEY 
	(
		[RequestTypeID]
	) REFERENCES [OW].[tblRequestType] (
		[RequestID]
	),
	CONSTRAINT [FK_tblRequest_tblUser] FOREIGN KEY 
	(
		[CreatedByID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	),
	CONSTRAINT [FK_tblRequest_tblUser1] FOREIGN KEY 
	(
		[ModifiedByID]
	) REFERENCES [OW].[tblUser] (
		[userID]
	)
GO

ALTER TABLE [OW].[tblEntityListBIArquiveAssociation] ADD 
	CONSTRAINT [FK_tblEntityListBIArquiveAssociation_tblEntityBIArquive] FOREIGN KEY 
	(
		[BIArquiveID]
	) REFERENCES [OW].[tblEntityBIArquive] (
		[BIArquiveID]
	),
	CONSTRAINT [FK_tblEntityListBIArquiveAssociation_tblEntityList] FOREIGN KEY 
	(
		[ListID]
	) REFERENCES [OW].[tblEntityList] (
		[ListID]
	)
GO


/****************************************************************************************************************/
/* (END) FK Archive */ 
/****************************************************************************************************************/

/* Insert Products */
insert into OW.tblProduct values (5, 'Configuração')
insert into OW.tblProduct values (3, 'Registo/Entidades')

GO


/* Insert Form Fields */ 
--INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
--VALUES('Ano',1,0,1,0,1)
--INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
--VALUES('Número',2,0,1,0,1)
--INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
--VALUES('Data de Registo',3,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Data Documento',4,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Entidade',5,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Classificação',6,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Assunto',7,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Observações',8,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Palavras Chave',9,0,1,0,1)
--INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
--VALUES('Livro',10,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Referência',11,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Cota do Arquivo',12,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Processo',13,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Bloco',14,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Acessos',15,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Antecedentes',16,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Distribuição',17,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Ficheiros',18,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Entidades Secundárias',19,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Tipo Documento',20,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Valor',21,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Moeda',22,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Fundo',23,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Série',24,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('CB da Unidade de Instalação',25,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Localização Física',26,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Entidade Produtora',27,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('Fim da Fase Activa',28,0,1,0,1)
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global],[Visible]) 
VALUES('CB do Registo',29,0,1,0,1)

GO
 
/* Insert Field Types */ 
DELETE FROM [OW].[tblFormFieldsType] 
GO 
INSERT INTO [OW].[tblFormFieldsType]([DynFldTypeID], [Description], [InternalDescription]) 
VALUES(1, 'Texto', 'nvarchar') 
INSERT INTO [OW].[tblFormFieldsType]([DynFldTypeID], [Description], [InternalDescription]) 
VALUES(2, 'Numérico', 'numeric') 
INSERT INTO [OW].[tblFormFieldsType]([DynFldTypeID], [Description], [InternalDescription]) 
VALUES(3, 'Vírgula Flutuante', 'float') 
INSERT INTO [OW].[tblFormFieldsType]([DynFldTypeID], [Description], [InternalDescription]) 
VALUES(4, 'Data', 'smalldatetime') 
INSERT INTO [OW].[tblFormFieldsType]([DynFldTypeID], [Description], [InternalDescription]) 
VALUES(5, 'Data/Hora', 'datetime') 

INSERT INTO OW.tblFormFieldsType (DynFldTypeID,Description,InternalDescription)
VALUES (7,'Lista','List')
GO



/* Insert Distribution Ways*/ 
INSERT INTO [OW].[tblDistributionType]([DistribTypeID], [DistribTypeDesc], [GetDistribCode]) 
VALUES(1,'Correio Normal' ,'CN') 
INSERT INTO [OW].[tblDistributionType]([DistribTypeID], [DistribTypeDesc], [GetDistribCode]) 
VALUES(2,'Correio com A/R' ,'CR') 
INSERT INTO [OW].[tblDistributionType]([DistribTypeID], [DistribTypeDesc], [GetDistribCode]) 
VALUES(3,'Telegrama' ,'TL') 
INSERT INTO [OW].[tblDistributionType]([DistribTypeID], [DistribTypeDesc], [GetDistribCode]) 
VALUES(4, 'Por mão Própria','MP') 

GO 
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('AP','Anexar ao processo',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('APRO','Para Aprovação',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('AR','Arquivar',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('CAB','Para Cabimentar',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('DF','Deferido',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('DP','Despachado',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('ID','Indeferido',1)
INSERT [OW].[tblDispatch] (abreviation,designation,[global]) VALUES('OF','Oficiar',1)

GO
INSERT [OW].[tblDistributionCode] (id,description) VALUES(1,'Correio Electrónico')
INSERT [OW].[tblDistributionCode] (id,description) VALUES(2,'Outras Vias')
INSERT [OW].[tblDistributionCode] (id,description) VALUES(3,'SAP')
INSERT [OW].[tblDistributionCode] (id,description) VALUES(4,'ULTIMUS')
INSERT [OW].[tblDistributionCode] (id,description) VALUES(5,'FLOWAY')

GO


/* Insert Countries */


DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy=InsertedBy, @InsertedOn=InsertedOn,
@LastModifiedBy=LastModifiedBy, @LastModifiedOn=LastModifiedOn
FROM [OW].[##VariaveisGlobais]


SET IDENTITY_INSERT [OW].[tblCountry] ON

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn) 
VALUES (1,'AD','Andorra',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn) 
VALUES (2,'AE','Emiratos Árabes Unidos',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (3,'AF','Afeganistão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (4,'AG','Antigua e Barbuda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (5,'AL','Albania',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (6,'AM','Arménia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (7,'AN','Antilhas Holandesas',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'AO','Angola',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (9,'AQ','Antartica',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (10,'AR','Argentina',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (11,'AT','Austria',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (12,'AU','Austrália',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (13,'AW','Aruba',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (14,'AZ','Azerbaijão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (15,'BA','Bósnia Herzegovina',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (16,'BB','Barbados',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (17,'BD','Bangladesh',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (18,'BE','Bélgica',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (19,'BF','Burkina Faso',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (20,'BG','Bulgária',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (21,'BH','Barein',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (22,'BI','Burundi',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (23,'BJ','Benin',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (24,'BM','Bermudas',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (25,'BN','Brunei',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (26,'BO','Bolivia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (27,'BR','Brasil',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (28,'BS','Bahamas',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (29,'BT','Botão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (30,'BW','Botswana',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (31,'BY','Bielorussia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (32,'BZ','Belize',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (33,'CA','Canadá',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (34,'CD','Congo (Rep Dem)',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (35,'CF','Republica Centro Africana',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (36,'CG','Congo (Rep)',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (37,'CH','Suiça',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (38,'CI','Costa do Marfim',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (39,'CK','Ilha de Cook',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (40,'CL','Chile',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (41,'CM','Camarões',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (42,'CN','China',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (43,'CO','Colômbia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (44,'CR','Costa Rica',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (45,'CU','Cuba',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (46,'CV','Cabo Verde',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (47,'CX','Ilha do Natal',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (48,'CY','Chipre',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (49,'CZ','República Checa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (50,'DE','Alemanha',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (51,'DJ','Djibuti',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (52,'DK','Dinamarca',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (53,'DM','Dominica',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (54,'DO','República Dominicana',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (55,'DZ','Argélia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (56,'EC','Equador',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (57,'EE','Estónia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (58,'EG','Egipto',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (59,'ER','Eritreia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (60,'ES','Espanha',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (61,'ET','Etiópia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (62,'FI','Finlandia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (63,'FJ','Fiji',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (64,'FK','Ilhas Falkland',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (65,'FO','Ilhas Faroé',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (66,'FR','França',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (67,'GA','Gabão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (68,'GB','Reino Unido',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (69,'GD','Granada',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (70,'GE','Georgia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (71,'GF','Guiana Francesa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (72,'GH','Gana',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (73,'GI','Gibraltar',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (74,'GM','Gambia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (75,'GN','Guiné',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (76,'GP','Guadalupe',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (77,'GQ','Guiné Equatorial',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (78,'GR','Grécia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (79,'GT','Guatemala',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (80,'GU','Guam',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (81,'GW','Guiné Bissau',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (82,'GY','Guiana',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (83,'HK','Hong Kong',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (84,'HN','Honduras',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (85,'HR','Croácia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (86,'HT','Haiti',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (87,'HU','Hungria',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (88,'ID','Indonésia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (89,'IE','Irlanda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (90,'IL','Israel',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (91,'IN','India',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (92,'IQ','Iraque',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (93,'IR','Irão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (94,'IS','Islândia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (95,'IT','Itália',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (96,'JM','Jamaica',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (97,'JO','Jordânia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (98,'JP','Japão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (99,'KE','Quénia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (100,'KH','Cambodja',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (101,'KM','Comoro',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (102,'KN','S Kitts e Nevis',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (103,'KP','Coreia do Norte',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (104,'KR','Coreia do Sul',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (105,'KW','Kuwait',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (106,'KY','Ilhas Caimão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (107,'KZ','Kazaquistão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (108,'LA','Laos',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (109,'LB','Líbano',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (110,'LI','Liechtenstein',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (111,'LK','Sri Lanka',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (112,'LR','Libéria',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (113,'LS','Lesoto',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (114,'LT','Lituania',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (115,'LU','Luxemburgo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (116,'LV','Letónia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (117,'LY','Líbia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (118,'MA','Marrocos',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (119,'MC','Mónaco',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (120,'MD','Moldávia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (121,'MG','Madagascar',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (122,'ML','Mali',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (123,'MM','Myanmar',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (124,'MN','Mongólia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (125,'MO','Macau',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (126,'MQ','Martinica',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (127,'MR','Mauritania',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (128,'MS','Montserrat',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (129,'MT','Malta',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (130,'MU','Ilhas Maurícias',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (131,'MV','Maldivas',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (132,'MW','Malawi',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (133,'MX','México',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (134,'MY','Malásia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (135,'MZ','Moçambique',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (136,'NA','Namíbia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (137,'NC','Nova Caledónia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (138,'NG','Nigéria',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (139,'NI','Nicarágua',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (140,'NL','Holanda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (141,'NO','Noruega',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (142,'NP','Nepal',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (143,'NZ','Nova Zelândia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (144,'OM','Oman',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (145,'PA','Panamá',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (146,'PE','Peru',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (147,'PF','Polinésia Francesa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (148,'PG','Papua, Nova Guiné',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (149,'PH','Filipinas',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (150,'PK','Paquistão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (151,'PL','Polónia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (152,'PR','Porto Rico',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (153,'PS','Palestina',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (154,'PT','Portugal',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (155,'PW','Palau',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (156,'PY','Paraguai',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (157,'QA','Qatar',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (158,'RE','Reunião',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (159,'RO','Roménia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (160,'RU','Russia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (161,'RW','Ruanda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (162,'SA','Arábia Saudita',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (163,'SB','Ilhas Salomão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (164,'SC','Seicheles',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (165,'SD','Sudão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (166,'SE','Suécia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (167,'SG','Singapura',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (168,'SI','Eslovénia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (169,'SK','Eslováquia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (170,'SL','Serra Leoa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (171,'SM','São Marino',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (172,'SN','Senegal',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (173,'SO','Somália',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (174,'SR','Suriname',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (175,'ST','São Tomé e Príncipe',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (176,'SV','El Salvador',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (177,'SY','Síria',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (178,'SZ','Suazilandia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (179,'TD','Chade',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (180,'TG','Togo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (181,'TH','Tailandia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (182,'TJ','Tajakistão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (183,'TK','Tokelau',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (184,'TM','Turquemenistão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (185,'TN','Tunísia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (186,'TO','Tonga',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (187,'TP','Timor Leste',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (188,'TR','Turquia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (189,'TT','Trinidad e Tobago',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (190,'TW','Ilha Formosa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (191,'TZ','Tanzania',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (192,'UA','Ucrania',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (193,'UG','Uganda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (194,'US','Estados Unidos da América',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (195,'UY','Uruguai',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (196,'UZ','Uzbequistão',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (197,'VA','Vaticano',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (198,'VE','Venezuela',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (199,'VG','Ilhas Virgens',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (200,'VN','Vietname',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (201,'WS','Samoa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (202,'XC','Ceuta',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (203,'XL','Melilla',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (204,'XM','Macedonia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (205,'YE','Iemen',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (206,'YU','Sérvia e Montenegro',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (207,'ZA','Africa do Sul',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (208,'ZM','Zambia',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblCountry (CountryID,Code,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (209,'ZW','Zimbabue',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

SET IDENTITY_INSERT [OW].[tblCountry] OFF

GO


/* Insert Districts */
DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy=InsertedBy, @InsertedOn=InsertedOn,
@LastModifiedBy=LastModifiedBy, @LastModifiedOn=LastModifiedOn
FROM [OW].[##VariaveisGlobais]


SET IDENTITY_INSERT [OW].[tblDistrict] ON

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (1,154,'Aveiro',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (2,154,'Beja',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (3,154,'Braga',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (4,154,'Bragança',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (5,154,'Castelo Lopes',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (6,154,'Coimbra',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (7,154,'Évora',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,154,'Faro',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (9,154,'Guarda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (10,154,'Ilha da Graciosa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (11,154,'Ilha da Madeira',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (12,154,'Ilha das Flores',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (13,154,'Ilha de Porto Santo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (14,154,'Ilha de Santa Maria',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (15,154,'Ilha de São Jorge',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (16,154,'Ilha de São Miguel',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (17,154,'Ilha do Corvo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (18,154,'Ilha do Faial',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (19,154,'Ilha do Pico',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (20,154,'Ilha Terceira',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (21,154,'Porto',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (22,154,'Lisboa',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (23,154,'Portalegre',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (24,154,'Porto',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (25,154,'Santarém',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (26,154,'Setúbal',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (27,154,'Viana do Castelo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (28,154,'Vila Real',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (29,154,'Viseu',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)
SET IDENTITY_INSERT [OW].[tblDistrict] OFF


GO




/* Insert entity fields */
INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (1,'Código',2,18,1,0,1,10,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (2,'Primeiro Nome',1,50,0,0,1,20,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (3,'Outros Nomes',1,300,0,1,1,21,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (4,'Último Nome',1,50,0,1,1,22,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (5,'Bilhete Identidade',2,18,1,1,1,30,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (6,'Num. Contribuinte',2,18,1,1,1,33,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (7,'Num. Sócio',2,18,1,1,1,40,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (8,'eMail',1,300,0,0,1,50,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (9,'Profissão',1,100,0,0,1,60,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (10,'Morada',1,500,0,0,1,70,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (11,'Código Postal',7,18,0,0,1,71,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (12,'Distrito',7,18,0,0,1,72,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (13,'País',7,18,0,0,1,73,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (14,'Telefone',1,20,0,0,1,80,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (15,'Fax',1,20,0,0,1,81,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (16,'Telemóvel',1,20,0,0,1,82,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (18,'Entidade',1,18,0,0,1,90,1)


INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (21,'Data de Emissão',4,10,0,1,1,31,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (22,'Arquivo',7,18,0,0,1,32,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (23,'Cargo',7,18,0,0,1,61,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global],[order],[Visible])
VALUES (24,'Localidade',7,18,0,0,1,62,1)

GO




/****** Object:  Trigger OW.autoNumber_tblFormFields    Script Date: 12/4/2003 15:36:49 ******/
CREATE TRIGGER [autoNumber_tblFormFields] ON [OW].[tblFormFields] 
INSTEAD OF INSERT 
AS 
BEGIN 
	DECLARE @next_id numeric 
	DECLARE @FieldName nvarchar(50) 
	DECLARE @DynFldTypeID numeric 
	DECLARE @Size numeric 
	DECLARE @Global bit 
	DECLARE @Unique bit 
	DECLARE @Empty bit 
	 
	SELECT @next_id = MAX(FormFieldKey) + 1 FROM OW.tblFormFields 
	 
	IF(@next_id < 30) 
	BEGIN 
		SET @next_id = 30 
	END 
 
	SELECT @FieldName = FieldName, 
		 @DynFldTypeID = DynFldTypeID, 
		 @Size = [Size], 
		 @Global = [Global], 
		 @Unique = [Unique], 
		 @Empty = [Empty] 
	FROM inserted 
	 
	INSERT INTO OW.tblFormFields(FormFieldKey, FieldName, DynFldTypeID, [Size], [Unique], Empty, [Global]) 
	VALUES (@next_id, @FieldName, @DynFldTypeID, @Size, @Unique, @Empty, @Global) 
END 
GO


INSERT INTO OW.tblFields (FieldID,[Description],TypeID,[Size],[Unique],Empty,[Global],Visible, [order]) 
VALUES(0,'Nome',1,400,0,0,1,0,1)
Go
INSERT INTO OW.tblFields (FieldID,[Description],TypeID,[Size],[Unique],Empty,[Global],Visible, [order]) 
VALUES(17,'Lista',1,1,0,0,1,0,0)

GO


/* ***************** Automatic Distributions ****************** */
CREATE TABLE OW.tblDistributionAutomatic
	(
	AutoDistribID numeric(18, 0) NOT NULL IDENTITY (1, 1),
	TypeID numeric(18, 0) NOT NULL,
	FieldValue numeric(18, 0) NOT NULL,
	FieldID numeric(18, 0) NOT NULL,
	WayID varchar(20) NULL,
	SendFiles bit NULL,
	DistribObs nvarchar(250) NULL,
	DistribTypeID numeric(18, 0) NULL,
	DispatchID numeric(18, 0) NULL,
	AddresseeType char(1) NULL,
	AddresseeID numeric (18) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblDistributionAutomatic ADD CONSTRAINT
	PK_Table1_1 PRIMARY KEY CLUSTERED 
	(
	AutoDistribID
	) ON [PRIMARY]

GO


CREATE TABLE OW.tblDistributionAutomaticDestinations 
	(
	UserID numeric(18,0) NOT NULL,
	AutoDistribID numeric(18, 0) NOT NULL,
	Origin char(1) NOT NULL,
	Type char(1) NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE OW.tblDistributionAutomaticDestinations ADD CONSTRAINT
	PK_tblDistributionAutomaticDestinations PRIMARY KEY CLUSTERED 
	(
	UserID,
	AutoDistribID,
	Origin
	) ON [PRIMARY]
GO


ALTER TABLE OW.tblDistributionAutomaticDestinations ADD CONSTRAINT
	FK_tblDistributionAutomaticDestinations_tblDistributionAutomatic FOREIGN KEY
	(
	AutoDistribID
	) REFERENCES OW.tblDistributionAutomatic
	(
	AutoDistribID
	)
GO
ALTER TABLE OW.tblDistribTemp ADD
	AutoDistrib bit NOT NULL CONSTRAINT DF_tblDistribTemp_AutoDistrib DEFAULT 0

GO
ALTER TABLE OW.tblRegistryDistribution ADD
	AutoDistrib bit NOT NULL CONSTRAINT DF_tblRegistryDistribution_AutoDistrib DEFAULT 0
GO

-- Check constraints para Distribuições por Wiremaze.SGP
ALTER TABLE OW.tblDistributionAutomatic ADD 
	CONSTRAINT DA_CH1 CHECK ( AddresseeType in ('U','G') ),
	CONSTRAINT DA_CH2 CHECK ( TypeID <> 7 OR (AddresseeType IS NOT NULL AND AddresseeID IS NOT NULL) )
GO

ALTER TABLE OW.tblRegistryDistribution ADD 
	CONSTRAINT RD_CH1 CHECK ( AddresseeType in ('U','G') ),
	CONSTRAINT RD_CH2 CHECK ( Tipo <> 7 OR (AddresseeType IS NOT NULL AND AddresseeID IS NOT NULL) )
GO

ALTER TABLE OW.tblDistribTemp ADD 
	CONSTRAINT DT_CH1 CHECK ( AddresseeType in ('U','G') ),
	CONSTRAINT DT_CH2 CHECK ( Tipo <> 7 OR (AddresseeType IS NOT NULL AND AddresseeID IS NOT NULL) )
GO

/* **************** Profile Fields ************* */

/* **************** Configuração de campos ************* */
-- Disable the trigger formfields
ALTER TABLE OW.tblFormFields DISABLE TRIGGER autoNumber_tblFormFields
GO

INSERT INTO OW.tblFormFields (fieldName,formFieldKEY,DynFldTypeID,[Size],[Unique],Empty,[Global],Visible)
VALUES ('Ano',1,null,null,0,1,0,0)
GO
INSERT INTO OW.tblFormFields (fieldName, formFieldKEY, DynFldTypeID, [Size],[Unique],Empty,[Global],Visible)
VALUES ('Número',2,null,null,0,1,0,0)
GO
INSERT INTO OW.tblFormFields (fieldName, formFieldKEY, DynFldTypeID, [Size],[Unique],Empty,[Global],Visible)
VALUES ('Data Registo',3,null,null,0,1,0,0)
GO
INSERT INTO OW.tblFormFields (fieldName, formFieldKEY, DynFldTypeID, [Size],[Unique],Empty,[Global],Visible)
VALUES ('Livro',10,null,null,0,1,0,0)
GO
ALTER TABLE OW.tblFormFields ENABLE TRIGGER autoNumber_tblFormFields

/* ******************* TIPOS DOCUMENTO     ************************** */
ALTER TABLE OW.tblDocumentType ALTER COLUMN abreviation NVARCHAR(20) NOT NULL
GO
ALTER TABLE OW.tblDocumentType ALTER COLUMN designation NVARCHAR(100) NOT NULL
GO
ALTER TABLE OW.tblDocumentType ADD
[Global] bit NOT NULL CONSTRAINT DF_tblDocumentType_Global DEFAULT 0

GO
 CREATE  UNIQUE  INDEX [tblDocumentType_abreviation] ON [OW].[tblDocumentType]([abreviation]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

ALTER TABLE OW.tblDocumentType ADD CONSTRAINT
	DT_UK2 UNIQUE NONCLUSTERED 
	(
	designation
	) 

GO

/* ******************* PALAVRAS CHAVE     ************************** */
ALTER TABLE OW.tblKeywords ALTER COLUMN keyDescription NVARCHAR(50) NOT NULL
GO
ALTER TABLE OW.tblKeywords ADD
[Global] bit NOT NULL CONSTRAINT DF_tblKeywords_Global DEFAULT 0

go
 CREATE  UNIQUE  INDEX [tblKeywords_keyDescription] ON [OW].[tblKeywords]([keyDescription]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

/* *********************** FICHEIROS ******************************* */

ALTER TABLE OW.tblFileManager ADD CONSTRAINT
	FK_tblFileManager_tblUser FOREIGN KEY
	(
	CreateUserID
	) REFERENCES OW.tblUser
	(
	UserID
	)
GO

CREATE TABLE [OW].[tblRegistryDocuments] (
	[RegID] [numeric](18, 0) NOT NULL ,
	[FileID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [OW].[tblRegistryDocuments] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblRegistryDocuments] PRIMARY KEY  CLUSTERED 
	(
		[RegID],
		[FileID]
	)  ON [PRIMARY] 
GO




/* ************************ Correio electrónico  **************************** */
CREATE TABLE OW.tblElectronicMailUsers
	(
	MailUserID numeric(18,0) NOT NULL IDENTITY (1, 1),
	eMail varchar(500) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblElectronicMailUsers ADD CONSTRAINT
	PK_tblElectronicMailUsers PRIMARY KEY CLUSTERED 
	(
	MailUserID
	) ON [PRIMARY]
GO
CREATE TABLE OW.tblElectronicMailDestinations
	(
	UserID numeric(18, 0) NOT NULL,
	MailID numeric(18, 0) NOT NULL,
	Origin char(1) NOT NULL,
	Type char(1) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblElectronicMailDestinations ADD CONSTRAINT
	PK_tblElectronicMailDestinations PRIMARY KEY CLUSTERED 
	(
	UserID,
	MailID,
	Origin
	) ON [PRIMARY]
GO
CREATE TABLE OW.tblElectronicMail
	(
	MailID numeric(18, 0) NOT NULL IDENTITY (1, 1),
	FromUserID numeric(18, 0) NOT NULL,
	Subject varchar(500) NOT NULL,
	Message  text NOT NULL,
	SendDate datetime NOT NULL
	)  ON [PRIMARY]
GO
CREATE TABLE OW.tblElectronicMailDocuments
	(
	MailID numeric(18, 0) NOT NULL,
	FileID numeric(18, 0) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblElectronicMailDocuments ADD CONSTRAINT
	PK_tblElectronicMailDocuments PRIMARY KEY CLUSTERED 
	(
	MailID,
	FileID
	) ON [PRIMARY]

GO

ALTER TABLE OW.tblElectronicMail ADD CONSTRAINT
	DF_tblElectronicMail_SendDate DEFAULT (GETDATE()) FOR SendDate
GO
ALTER TABLE OW.tblElectronicMail ADD CONSTRAINT
	PK_tblElectronicMail PRIMARY KEY CLUSTERED 
	(
	MailID
	) ON [PRIMARY]

GO
ALTER TABLE OW.tblElectronicMailDestinations WITH NOCHECK ADD CONSTRAINT
	FK_tblElectronicMailDestinations_tblElectronicMail FOREIGN KEY
	(
	MailID
	) REFERENCES OW.tblElectronicMail
	(
	MailID
	)
GO

ALTER TABLE OW.tblDistributionAutomaticDestinations ADD CONSTRAINT
	FK_tblDistributionAutomaticDestinations_tblElectronicMailUsers FOREIGN KEY
	(
	UserID
	) REFERENCES OW.tblElectronicMailUsers
	(
	MailUserID
	)
GO


/* **************** Acessos Hierárquicos ************* */

ALTER TABLE OW.tblAccessReg ADD
	HierarchicalUserID numeric(18, 0) NOT NULL CONSTRAINT DF_tblAccessReg_HierarchicalUserID DEFAULT 0
GO
ALTER TABLE OW.tblAccessReg
	DROP CONSTRAINT PK_tblAccessReg
GO 
ALTER TABLE OW.tblAccessReg ADD CONSTRAINT
	PK_tblAccessReg PRIMARY KEY CLUSTERED 
	(
	UserID,
	ObjectID,
	ObjectType,
	HierarchicalUserID
	) ON [PRIMARY]

GO




/* **************** Campos Tabelados ******************** */
CREATE TABLE OW.tblListOptionsValues
	(
	ListID numeric(18, 0) NOT NULL IDENTITY (1, 1),
	Description varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblListOptionsValues ADD CONSTRAINT
	PK_tblListOptionsValues PRIMARY KEY CLUSTERED 
	(
	ListID
	) ON [PRIMARY]

GO

ALTER TABLE OW.tblListOptionsValues ADD CONSTRAINT
	IX_tblListOptionsValues UNIQUE NONCLUSTERED 
	(
	Description
	) ON [PRIMARY]
GO

CREATE TABLE OW.tblRegistryLists
	(
	RegID numeric(18, 0) NOT NULL,
	BookID numeric(18, 0) NOT NULL,
	FormFieldKey numeric(18, 0) NOT NULL,
	[Value] numeric(18, 0) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblRegistryLists ADD CONSTRAINT
	PK_tblRegistryLists PRIMARY KEY CLUSTERED 
	(
	RegID,
	BookID,
	FormFieldKey
	) ON [PRIMARY]

GO
ALTER TABLE OW.tblRegistryLists ADD CONSTRAINT
	FK_tblRegistryLists_tblListOptionsValues FOREIGN KEY
	(
	[Value]
	) REFERENCES OW.tblListOptionsValues
	(
	ListID
	)
GO
CREATE TABLE OW.tblListValues
	(
	ListID numeric(18, 0) NOT NULL,
	FormFieldKey numeric(18, 0) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblListValues ADD CONSTRAINT
	PK_tblListValues PRIMARY KEY CLUSTERED 
	(
	ListID,
	FormFieldKey
	) ON [PRIMARY]

GO
ALTER TABLE OW.tblListValues ADD CONSTRAINT
	FK_tblListValues_tblFormFields FOREIGN KEY
	(
	FormFieldKey
	) REFERENCES OW.tblFormFields
	(
	formFieldKEY
	)
GO
ALTER TABLE OW.tblListValues ADD CONSTRAINT
	FK_tblListValues_tblListOptionsValues FOREIGN KEY
	(
	ListID
	) REFERENCES OW.tblListOptionsValues
	(
	ListID
	)
GO
ALTER TABLE OW.tblRegistryLists ADD CONSTRAINT
	FK_tblRegistryLists_tblFormFields FOREIGN KEY
	(
	FormFieldKey
	) REFERENCES OW.tblFormFields
	(
	formFieldKEY
	)
GO
CREATE TABLE OW.tblVersion
	(
	id numeric(18, 0) NOT NULL,
	version varchar(50) NULL
	)  ON [PRIMARY]

GO
ALTER TABLE OW.tblVersion ADD CONSTRAINT
	PK_tblVersion PRIMARY KEY CLUSTERED 
	(
	id
	) ON [PRIMARY]
GO
insert into OW.tblVersion (id,version) VALUES (1,'5.0.0')
GO


ALTER TABLE OW.tblProfiles ALTER COLUMN ProfileDesc varchar(100) NOT NULL
GO

ALTER TABLE OW.tblProfiles ADD CONSTRAINT
	IX_tblProfiles_DescUNIQUE UNIQUE NONCLUSTERED 
	(
	ProfileDesc
	) ON [PRIMARY]

GO

DROP INDEX OW.tblBooks.tblBooks_abreviation
GO
ALTER TABLE OW.tblBooks ALTER COLUMN abreviation nvarchar(20) NOT NULL
ALTER TABLE OW.tblBooks ALTER COLUMN designation nvarchar(100) NOT NULL

GO

ALTER TABLE OW.tblBooks ADD CONSTRAINT
	IX_tblBooks_Designation UNIQUE NONCLUSTERED 
	(
	designation
	) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX tblBooks_abreviation ON OW.tblBooks
	(
	abreviation
	) WITH FILLFACTOR = 90 ON [PRIMARY]
GO




/* **************************************************************************************** */
/* ****************************** Entities Groups ***************************************** */
/* **************************************************************************************** */

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[tblEntitiesGroups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [OW].[tblEntitiesGroups]
GO
-- tblGroupsEntities
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[tblGroupsEntities]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [OW].[tblGroupsEntities]
GO
/****** Object:  Table [OW].[tblEntitiesGroups]    Script Date: 06-08-2004 10:17:49 ******/
/* NOVO */
CREATE TABLE [OW].[tblGroupsEntities] (
	[EntID] [numeric](18, 0) NOT NULL ,
	[ObjectID] [numeric](18, 0) NOT NULL ,
	CONSTRAINT [FK_tblGroupsEntities_tblEntities] FOREIGN KEY 
	(
		[EntID]
	) REFERENCES [OW].[tblEntities] (
		[EntID]
	)
) ON [PRIMARY]
GO







-- ------------------------------------------------------------------
-- dbo.Log -- For Data Application Block
-- ------------------------------------------------------------------
CREATE TABLE [dbo].[Log] (
	[LogID] [int] IDENTITY (1, 1) NOT NULL ,
	[EventID] [int] NULL ,
	[Category] [nvarchar] (64)  NOT NULL ,
	[Priority] [int] NOT NULL ,
	[Severity] [nvarchar] (32)  NOT NULL ,
	[Title] [nvarchar] (256)  NOT NULL ,
	[Timestamp] [datetime] NOT NULL ,
	[MachineName] [nvarchar] (32)  NOT NULL ,
	[AppDomainName] [nvarchar] (2048)  NOT NULL ,
	[ProcessID] [nvarchar] (256)  NOT NULL ,
	[ProcessName] [nvarchar] (2048)  NOT NULL ,
	[ThreadName] [nvarchar] (2048)  NULL ,
	[Win32ThreadId] [nvarchar] (128)  NULL ,
	[Message] [nvarchar] (2048)  NULL ,
	[FormattedMessage] [ntext]  NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



ALTER TABLE [dbo].[Log] WITH NOCHECK ADD 
	CONSTRAINT [PK_Log] PRIMARY KEY  CLUSTERED 
	(
		[LogID]
	)  ON [PRIMARY] 
GO




CREATE TABLE OW.tblDistributionAutomaticEntities
	(
	AutoDistribID numeric(18, 0) NOT NULL,
	EntID numeric(18, 0) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblDistributionAutomaticEntities ADD CONSTRAINT
	PK_tblDistributionAutomaticEntities PRIMARY KEY CLUSTERED 
	(
	AutoDistribID,
	EntID
	) ON [PRIMARY]
GO
ALTER TABLE OW.tblDistributionAutomaticEntities ADD CONSTRAINT
	FK_tblDistributionAutomaticEntities_tblDistributionAutomatic FOREIGN KEY
	(
	AutoDistribID
	) REFERENCES OW.tblDistributionAutomatic
	(
	AutoDistribID
	) NOT FOR REPLICATION
GO
ALTER TABLE OW.tblDistributionAutomaticEntities ADD CONSTRAINT
	FK_tblDistributionAutomaticEntities_tblEntities FOREIGN KEY
	(
	EntID
	) REFERENCES OW.tblEntities
	(
	EntID
	) NOT FOR REPLICATION

GO













-- Configuração do Linked Server para aceder ao Index Server

EXEC sp_addlinkedserver    @server='OfficeWorksIndexServer', @srvproduct='Index Server',
                           @provider='MSIDXS', @datasrc='OfficeWorks'
 
EXEC sp_addlinkedsrvlogin @rmtsrvname=N'OfficeWorksIndexServer', @useself='true', @locallogin=N'OW', @rmtuser=NULL, @rmtpassword=NULL 
-- se @useself='false' podemos passar o user/password remoto (@rmtuser e @rmtpassword).
GO











USE MASTER
GO

if not exists (select * from dbo.sysusers where name = N'OW' and uid < 16382)
BEGIN
	exec sp_grantdbaccess N'OW', N'OW'
END
GO

grant exec on xp_varbintohexstr to OW
GO

-- Mensagens de erro do Database Application block
EXEC sp_addmessage 50001, 16, N'Insert error, rowcount is 0.'
EXEC sp_addmessage 50002, 16, N'Update error, rowcount is 0.'
EXEC sp_addmessage 50003, 16, N'Delete error, rowcount is 0.'
GO

SET NOCOUNT OFF
GO