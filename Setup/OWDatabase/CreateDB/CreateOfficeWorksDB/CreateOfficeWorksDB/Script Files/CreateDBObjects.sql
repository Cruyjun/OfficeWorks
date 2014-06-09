
-- Create database objects
-- #DATABASENAME# Database name for runtime text replacement

USE #DATABASENAME#
GO

SET NOCOUNT ON
GO
SET CONCAT_NULL_YIELDS_NULL OFF
GO

/* Criar user OW se este ainda não existe */
if not exists (select * from master.dbo.syslogins where loginname = N'OW')
BEGIN
	exec sp_addlogin N'OW', N'nicedoc', N'OW', N'us_english'
END
GO

if not exists (select * from dbo.sysusers where name = N'OW' and uid < 16382)
BEGIN
	exec sp_grantdbaccess N'OW', N'OW'
	exec sp_addrolemember N'db_owner', N'OW'
END
GO


/****** Object:  Table [OW].[tblAccess]    Script Date: 12/4/2003 15:36:29 ******/
CREATE TABLE [OW].[tblAccess] (
	[UserID] [numeric](18, 0) NOT NULL ,
	[ObjectParentID] [numeric](18, 0) NOT NULL ,
	[ObjectID] [numeric](18, 0) NOT NULL ,
	[ObjectTypeID] [numeric](18, 0) NOT NULL ,
	[AccessType] [int] NULL ,
	[ObjectType] [smallint] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblAccessReg]    Script Date: 12/4/2003 15:36:30 ******/
CREATE TABLE [OW].[tblAccessReg] (
	[UserID] [numeric](18, 0) NOT NULL ,
	[ObjectID] [numeric](18, 0) NOT NULL ,
	[ObjectType] [smallint] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblAlarm]    Script Date: 12/4/2003 15:36:30 ******/
CREATE TABLE [OW].[tblAlarm] (
	[AlarmId] [numeric](18, 0) NOT NULL ,
	[AlarmDateTime] [datetime] NOT NULL ,
	[AlarmPrioricity] [nvarchar] (20) NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblAlarmAssociation]    Script Date: 12/4/2003 15:36:30 ******/
CREATE TABLE [OW].[tblAlarmAssociation] (
	[AssociationID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[AlarmID] [numeric](18, 0) NOT NULL ,
	[ObjectID] [numeric](18, 0) NOT NULL ,
	[ObjectRowID] [numeric](18, 0) NOT NULL ,
	[Activated] [bit] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblBooks]    Script Date: 12/4/2003 15:36:30 ******/
CREATE TABLE [OW].[tblBooks] (
	[bookID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[abreviation] [nvarchar] (20)  NULL ,
	[designation] [nvarchar] (100)  NULL ,
	[automatic] [bit] NOT NULL 
) ON [PRIMARY]
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

/****** Object:  Table [OW].[tblClassification]    Script Date: 12/4/2003 15:36:31 ******/
CREATE TABLE [OW].[tblClassification] (
	[classID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[level1] [nvarchar] (50)  NULL ,
	[level2] [nvarchar] (50)  NULL ,
	[level3] [nvarchar] (50)  NULL ,
	[level4] [nvarchar] (50)  NULL ,
	[level5] [nvarchar] (50)  NULL ,
	[level1desig] [nvarchar] (100)  NULL ,
	[level2desig] [nvarchar] (100)  NULL ,
	[level3desig] [nvarchar] (100)  NULL ,
	[level4desig] [nvarchar] (100)  NULL ,
	[level5desig] [nvarchar] (100)  NULL ,
	[Tipo] [varchar] (50)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblClassificationBooks]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblClassificationBooks] (
	[ClassBookID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[ClassID] [numeric](18, 0) NOT NULL ,
	[BookID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblCountry]    Script Date: 12/4/2003 15:36:32 ******/
CREATE TABLE [OW].[tblCountry] (
	[CountryID] [numeric](18, 0) NOT NULL ,
	[Code] [varchar] (50)  NOT NULL ,
	[Description] [varchar] (300)  NOT NULL 
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
	[AutoDistribID] [numeric](18, 0) NULL
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
	[DistrictID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[CountryID] [numeric](18, 0) NOT NULL ,
	[Description] [varchar] (300)  NOT NULL 
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
	[FirstName] [varchar] (50)  NULL ,
	[MiddleName] [varchar] (300)  NULL ,
	[LastName] [varchar] (50)  NULL ,
	[ListID] [numeric](18, 0) NULL ,
	[BI] [numeric](18, 0) NULL ,
	[NumContribuinte] [numeric](18, 0) NULL ,
	[AssociateNum] [numeric](18, 0) NULL ,
	[eMail] [varchar] (300)  NULL ,
	[JobTitle] [varchar] (100)  NULL ,
	[Street] [varchar] (500)  NULL ,
	[PostalCodeID] [numeric](18, 0) NULL ,
	[CountryID] [numeric](18, 0) NULL ,
	[Phone] [varchar] (20)  NULL ,
	[Fax] [varchar] (20)  NULL ,
	[Mobile] [varchar] (20)  NULL ,
	[DistrictID] [numeric](18, 0) NULL ,
	[EntityID] [numeric](18, 0) NULL ,
	[Active] [bit] NOT NULL ,
	[CreatedBy] [numeric](18, 0) NULL ,
	[CreatedDate] [datetime] NULL ,
	[ModifiedBy] [numeric](18, 0) NULL ,
	[ModifiedDate] [datetime] NULL,
	[Type] [tinyint] NOT NULL 
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
	[Global] [bit] NOT NULL 
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
	[RegID] [numeric](18, 0) NOT NULL ,
	[FileName] [varchar] (300)  NOT NULL ,
	[FilePath] [varchar] (300)  NOT NULL 
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
	[Global] [bit] NULL 
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
	[GroupID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[GroupDesc] [varchar] (50)  NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblGroupsUsers]    Script Date: 12/4/2003 15:36:39 ******/
CREATE TABLE [OW].[tblGroupsUsers] (
	[GroupID] [numeric](18, 0) NOT NULL ,
	[UserID] [numeric](18, 0) NOT NULL 
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
	[PostalCodeID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[Code] [varchar] (10)  NOT NULL ,
	[Description] [varchar] (100)  NOT NULL 
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
	[classid] [numeric](18, 0) NULL ,
	[userID] [numeric](18, 0) NULL ,
	[AntecedenteID] [numeric](18, 0) NULL ,
	[entID] [numeric](18, 0) NULL ,
	[UserModifyID] [numeric](18, 0) NULL ,
	[DateModify] [datetime] NULL ,
	[historic] [bit] NOT NULL ,
	[field1] [float] NULL ,
	[field2] [nvarchar] (50)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistryDistribution]    Script Date: 12/4/2003 15:36:41 ******/
CREATE TABLE [OW].[tblRegistryDistribution] (
	[ID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[RegID] [numeric](18, 0) NULL ,
	[userID] [numeric](18, 0) NOT NULL ,
	[DistribDate] [datetime] NOT NULL ,
	[DistribObs] [nvarchar] (250)  NULL ,
	[Tipo] [numeric](18, 0) NOT NULL ,
	[radioVia] [varchar] (20)  NULL ,
	[chkFile] [bit] NULL ,
	[DistribTypeID] [numeric](18, 0) NULL ,
	[txtEntidadeID] [numeric](18, 0) NULL ,
	[state] [tinyint] NULL ,
	[ConnectID] [numeric](18, 0) NULL ,
	[dispatch] [numeric](18, 0) NULL 
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
	[classid] [numeric](18, 0) NULL ,
	[userID] [numeric](18, 0) NULL ,
	[AntecedenteID] [numeric](18, 0) NULL ,
	[entID] [numeric](18, 0) NULL ,
	[UserModifyID] [numeric](18, 0) NULL ,
	[DateModify] [datetime] NULL ,
	[historic] [bit] NOT NULL ,
	[field1] [float] NULL ,
	[field2] [nvarchar] (50)  NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblRegistryKeywords]    Script Date: 12/4/2003 15:36:42 ******/
CREATE TABLE [OW].[tblRegistryKeywords] (
	[regID] [numeric](18, 0) NOT NULL ,
	[keyID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblState]    Script Date: 12/4/2003 15:36:43 ******/
CREATE TABLE [OW].[tblState] (
	[StateID] [numeric](18, 0) NOT NULL ,
	[StateDesc] [varchar] (50)  NULL 
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
	[userID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[userLogin] [varchar] (900)  NOT NULL ,
	[userDesc] [varchar] (300)  NOT NULL ,
	[userMail] [varchar] (200)  NULL ,
	[userActive] [bit] NULL,
	[TextSignature] [varchar] (300)  NULL
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblUserPersistence]    Script Date: 12/4/2003 15:36:44 ******/
CREATE TABLE [OW].[tblUserPersistence] (
	[UPID]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[formFieldKEY] [numeric](18, 0) NOT NULL ,
	[UserID] [numeric](18, 0) NOT NULL ,
	[fieldValue] [varchar] (4000)  NOT NULL, 
	[fieldValue2] [varchar] (4000)  NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblUserPersistenceConfig]    Script Date: 12/4/2003 15:36:44 ******/
CREATE TABLE [OW].[tblUserPersistenceConfig] (
	[UserID] [numeric](18, 0) NOT NULL ,
	[formfieldkey] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [OW].[tblOWWorkFlowDistribution]    Script Date: 12/4/2003 15:36:44 ******/
CREATE TABLE [OW].[tblOWWorkFlowDistribution] (
	[OWWorkFlowDistributionID] [numeric](18, 0) NOT NULL ,
	[FromAddrID] [numeric](18, 0) NOT NULL ,
	[StageNumber] [numeric](18, 0) NOT NULL ,
	[SendDate] [datetime] NULL ,
	[ExpireDate] [datetime] NULL ,
	[ReadDate] [datetime] NULL ,
	[Subject] [varchar] (255)  NULL ,
	[Body] [text]  NULL ,
	[Importance] [char] (1)  NULL ,
	[Classification] [char] (1)  NULL ,
	[State] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [OW].[tblProduct] (
	[ProductID] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[ObjectTypeID] [numeric](18, 0) NOT NULL ,
	[ProductName] [varchar] (255) NULL 
) ON [PRIMARY]
GO

insert into OW.tblProduct values (5, 'Configuração')
insert into OW.tblProduct values (3, 'Registo/Entidades')
insert into OW.tblProduct values (4, 'Correio Circular')
insert into OW.tblProduct values (6, 'WorkFlow')


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
		[classID]
	)  ON [PRIMARY] 
GO
CREATE UNIQUE NONCLUSTERED INDEX IX_tblClassification_Levels ON OW.tblClassification
 (
 level1,
 level2,
 level3,
 level4,
 level5
 ) ON [PRIMARY]
GO


Go

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
	CONSTRAINT [PK_tblDistricts] PRIMARY KEY  CLUSTERED 
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

ALTER TABLE [OW].[tblGroupsUsers] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblGroupsUsers] PRIMARY KEY  CLUSTERED 
	(
		[GroupID],
		[UserID]
	)  ON [PRIMARY] 
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

ALTER TABLE [OW].[tblState] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblState] PRIMARY KEY  CLUSTERED 
	(
		[StateID]
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

ALTER TABLE [OW].[tblAlarm] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblAlarm] PRIMARY KEY  NONCLUSTERED 
	(
		[AlarmId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [OW].[tblAlarmAssociation] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblAlarmAssociation] PRIMARY KEY  NONCLUSTERED 
	(
		[AssociationID],
		[AlarmID],
		[ObjectID],
		[ObjectRowID]
	)  ON [PRIMARY] 
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
	CONSTRAINT [DF_tblRegistry_historic] DEFAULT (0) FOR [historic]
GO

ALTER TABLE [OW].[tblRegistryDistribution] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblRegistryDistribution_state] DEFAULT (2) FOR [state]
GO

ALTER TABLE [OW].[tblRegistryHist] WITH NOCHECK ADD 
	CONSTRAINT [DF_tblRegistryHist_historic] DEFAULT (1) FOR [historic]
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

ALTER TABLE [OW].[tblOWWorkFlowDistribution] WITH NOCHECK ADD 
	CONSTRAINT [PK_tblOWWorkFlowDistribution] PRIMARY KEY  NONCLUSTERED 
	(
		[OWWorkFlowDistributionID],
		[FromAddrID],
		[StageNumber]
	)  ON [PRIMARY] 
GO

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

 CREATE  INDEX [tblFileManager_REGID] ON [OW].[tblFileManager]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblFloats_RegID] ON [OW].[tblFloats]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblGroupsUsers_userid] ON [OW].[tblGroupsUsers]([UserID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblGroupsUsers_groupid] ON [OW].[tblGroupsUsers]([GroupID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

 CREATE  INDEX [tblIntegers_RegID] ON [OW].[tblIntegers]([RegID]) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO


 CREATE  INDEX [tblPostalCode_Code] ON [OW].[tblPostalCode]([Code]) ON [PRIMARY]
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

ALTER TABLE [OW].[tblAlarmAssociation] ADD 
	CONSTRAINT [FK_tblAlarmAssociation_tblAlarm] FOREIGN KEY 
	(
		[AlarmID]
	) REFERENCES [OW].[tblAlarm] (
		[AlarmId]
	)
GO

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
		[classID]
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

ALTER TABLE [OW].[tblEntities] ADD 
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
	),
	CONSTRAINT [FK_tblEntities_tblUser] FOREIGN KEY 
	(
		[CreatedBy]
	) REFERENCES [OW].[tblUser] (
		[userID]
	),
	CONSTRAINT [FK_tblEntities_tblUser1] FOREIGN KEY 
	(
		[ModifiedBy]
	) REFERENCES [OW].[tblUser] (
		[userID]
	)
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
		[classID]
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
		[classID]
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
	) NOT FOR REPLICATION 
GO

ALTER TABLE [OW].[tblRegistryKeywords] ADD 
	CONSTRAINT [FK_tblRegistryKeywords_tblKeywords] FOREIGN KEY 
	(
		[keyID]
	) REFERENCES [OW].[tblKeywords] (
		[keyID]
	)
GO

/* Insert States */ 
INSERT INTO [OW].[tblState]([StateID], [StateDesc]) 
VALUES (0,'Iniciado') 
INSERT INTO [OW].[tblState]([StateID], [StateDesc]) 
VALUES (1,'Suspendido') 
INSERT INTO [OW].[tblState]([StateID], [StateDesc]) 
VALUES (2,'Indeferido') 
INSERT INTO [OW].[tblState]([StateID], [StateDesc]) 
VALUES (3,'Despachado') 
INSERT INTO [OW].[tblState]([StateID], [StateDesc]) 
VALUES (4,'Delegado') 
INSERT INTO [OW].[tblState]([StateID], [StateDesc]) 
VALUES (5,'Em Espera')


GO 

/* Insert Form Fields */ 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Data Documento', 4, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Entidade', 5, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Classificação', 6, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Assunto', 7, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Observações', 8, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Palavras Chave', 9, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Referência', 11, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Cota do Arquivo', 12, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Processo', 13, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Bloco', 14, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Acessos', 15, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Antecedentes', 16, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Distribuição', 17, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Ficheiros', 18, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Entidades Secundárias', 19, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Tipo Documento', 20, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Valor', 21, 0, 1, 0) 
INSERT INTO [OW].[tblFormFields]([fieldName], [formFieldKEY], [Unique], [Empty], [Global]) 
VALUES('Moeda', 22, 0, 1, 0) 

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

/* Insert Districts */
SET IDENTITY_INSERT [OW].[tblDistrict] ON

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (1,1,'Aveiro')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (2,1,'Beja')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (3,1,'Braga')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (4,1,'Bragança')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (5,1,'Castelo Lopes')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (6,1,'Coimbra')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (7,1,'Évora')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (8,1,'Faro')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (9,1,'Guarda')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (10,1,'Ilha da Graciosa')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (11,1,'Ilha da Madeira')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (12,1,'Ilha das Flores')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (13,1,'Ilha de Porto Santo')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (14,1,'Ilha de Santa Maria')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (15,1,'Ilha de São Jorge')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (16,1,'Ilha de São Miguel')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (17,1,'Ilha do Corvo')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (18,1,'Ilha do Faial')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (19,1,'Ilha do Pico')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (20,1,'Ilha Terceira')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (21,1,'Porto')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (22,1,'Lisboa')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (23,1,'Portalegre')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (24,1,'Porto')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (25,1,'Santarém')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (26,1,'Setúbal')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (27,1,'Viana do Castelo')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (28,1,'Vila Real')

INSERT INTO OW.tblDistrict (DistrictID,CountryID,Description)
VALUES (29,1,'Viseu')
SET IDENTITY_INSERT [OW].[tblDistrict] OFF


GO

/* Insert Countries */

INSERT INTO OW.tblCountry (CountryID,Code,Description) 
VALUES (1,'AD','Andorra')

INSERT INTO OW.tblCountry (CountryID,Code,Description) 
VALUES (2,'AE','Emiratos Árabes Unidos')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (3,'AF','Afeganistão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (4,'AG','Antigua e Barbuda')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (5,'AL','Albania')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (6,'AM','Arménia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (7,'AN','Antilhas Holandesas')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (8,'AO','Angola')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (9,'AQ','Antartica')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (10,'AR','Argentina')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (11,'AT','Austria')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (12,'AU','Austrália')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (13,'AW','Aruba')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (14,'AZ','Azerbaijão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (15,'BA','Bósnia Herzegovina')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (16,'BB','Barbados')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (17,'BD','Bangladesh')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (18,'BE','Bélgica')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (19,'BF','Burkina Faso')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (20,'BG','Bulgária')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (21,'BH','Barein')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (22,'BI','Burundi')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (23,'BJ','Benin')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (24,'BM','Bermudas')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (25,'BN','Brunei')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (26,'BO','Bolivia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (27,'BR','Brasil')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (28,'BS','Bahamas')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (29,'BT','Botão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (30,'BW','Botswana')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (31,'BY','Bielorussia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (32,'BZ','Belize')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (33,'CA','Canadá')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (34,'CD','Congo (Rep Dem)')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (35,'CF','Republica Centro Africana')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (36,'CG','Congo (Rep)')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (37,'CH','Suiça')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (38,'CI','Costa do Marfim')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (39,'CK','Ilha de Cook')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (40,'CL','Chile')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (41,'CM','Camarões')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (42,'CN','China')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (43,'CO','Colômbia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (44,'CR','Costa Rica')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (45,'CU','Cuba')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (46,'CV','Cabo Verde')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (47,'CX','Ilha do Natal')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (48,'CY','Chipre')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (49,'CZ','República Checa')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (50,'DE','Alemanha')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (51,'DJ','Djibuti')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (52,'DK','Dinamarca')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (53,'DM','Dominica')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (54,'DO','República Dominicana')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (55,'DZ','Argélia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (56,'EC','Equador')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (57,'EE','Estónia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (58,'EG','Egipto')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (59,'ER','Eritreia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (60,'ES','Espanha')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (61,'ET','Etiópia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (62,'FI','Finlandia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (63,'FJ','Fiji')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (64,'FK','Ilhas Falkland')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (65,'FO','Ilhas Faroé')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (66,'FR','França')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (67,'GA','Gabão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (68,'GB','Reino Unido')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (69,'GD','Granada')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (70,'GE','Georgia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (71,'GF','Guiana Francesa')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (72,'GH','Gana')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (73,'GI','Gibraltar')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (74,'GM','Gambia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (75,'GN','Guiné')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (76,'GP','Guadalupe')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (77,'GQ','Guiné Equatorial')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (78,'GR','Grécia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (79,'GT','Guatemala')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (80,'GU','Guam')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (81,'GW','Guiné Bissau')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (82,'GY','Guiana')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (83,'HK','Hong Kong')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (84,'HN','Honduras')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (85,'HR','Croácia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (86,'HT','Haiti')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (87,'HU','Hungria')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (88,'ID','Indonésia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (89,'IE','Irlanda')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (90,'IL','Israel')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (91,'IN','India')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (92,'IQ','Iraque')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (93,'IR','Irão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (94,'IS','Islândia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (95,'IT','Itália')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (96,'JM','Jamaica')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (97,'JO','Jordânia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (98,'JP','Japão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (99,'KE','Quénia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (100,'KH','Cambodja')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (101,'KM','Comoro')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (102,'KN','S Kitts e Nevis')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (103,'KP','Coreia do Norte')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (104,'KR','Coreia do Sul')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (105,'KW','Kuwait')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (106,'KY','Ilhas Caimão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (107,'KZ','Kazaquistão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (108,'LA','Laos')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (109,'LB','Líbano')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (110,'LI','Liechtenstein')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (111,'LK','Sri Lanka')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (112,'LR','Libéria')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (113,'LS','Lesoto')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (114,'LT','Lituania')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (115,'LU','Luxemburgo')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (116,'LV','Letónia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (117,'LY','Líbia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (118,'MA','Marrocos')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (119,'MC','Mónaco')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (120,'MD','Moldávia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (121,'MG','Madagascar')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (122,'ML','Mali')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (123,'MM','Myanmar')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (124,'MN','Mongólia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (125,'MO','Macau')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (126,'MQ','Martinica')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (127,'MR','Mauritania')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (128,'MS','Montserrat')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (129,'MT','Malta')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (130,'MU','Ilhas Maurícias')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (131,'MV','Maldivas')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (132,'MW','Malawi')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (133,'MX','México')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (134,'MY','Malásia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (135,'MZ','Moçambique')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (136,'NA','Namíbia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (137,'NC','Nova Caledónia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (138,'NG','Nigéria')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (139,'NI','Nicarágua')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (140,'NL','Holanda')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (141,'NO','Noruega')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (142,'NP','Nepal')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (143,'NZ','Nova Zelândia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (144,'OM','Oman')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (145,'PA','Panamá')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (146,'PE','Peru')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (147,'PF','Polinésia Francesa')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (148,'PG','Papua, Nova Guiné')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (149,'PH','Filipinas')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (150,'PK','Paquistão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (151,'PL','Polónia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (152,'PR','Porto Rico')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (153,'PS','Palestina')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (154,'PT','Portugal')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (155,'PW','Palau')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (156,'PY','Paraguai')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (157,'QA','Qatar')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (158,'RE','Reunião')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (159,'RO','Roménia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (160,'RU','Russia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (161,'RW','Ruanda')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (162,'SA','Arábia Saudita')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (163,'SB','Ilhas Salomão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (164,'SC','Seicheles')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (165,'SD','Sudão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (166,'SE','Suécia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (167,'SG','Singapura')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (168,'SI','Eslovénia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (169,'SK','Eslováquia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (170,'SL','Serra Leoa')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (171,'SM','São Marino')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (172,'SN','Senegal')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (173,'SO','Somália')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (174,'SR','Suriname')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (175,'ST','São Tomé e Príncipe')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (176,'SV','El Salvador')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (177,'SY','Síria')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (178,'SZ','Suazilandia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (179,'TD','Chade')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (180,'TG','Togo')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (181,'TH','Tailandia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (182,'TJ','Tajakistão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (183,'TK','Tokelau')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (184,'TM','Turquemenistão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (185,'TN','Tunísia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (186,'TO','Tonga')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (187,'TP','Timor Leste')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (188,'TR','Turquia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (189,'TT','Trinidad e Tobago')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (190,'TW','Ilha Formosa')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (191,'TZ','Tanzania')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (192,'UA','Ucrania')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (193,'UG','Uganda')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (194,'US','Estados Unidos da América')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (195,'UY','Uruguai')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (196,'UZ','Uzbequistão')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (197,'VA','Vaticano')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (198,'VE','Venezuela')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (199,'VG','Ilhas Virgens')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (200,'VN','Vietname')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (201,'WS','Samoa')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (202,'XC','Ceuta')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (203,'XL','Melilla')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (204,'XM','Macedonia')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (205,'YE','Iemen')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (206,'YU','Sérvia e Montenegro')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (207,'ZA','Africa do Sul')

INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (208,'ZM','Zambia')


INSERT INTO OW.tblCountry (CountryID,Code,Description)
VALUES (209,'ZW','Zimbabue')


GO

/* Insert entity fields */
INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (1,'Código',2,18,1,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (2,'Primeiro Nome',1,50,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (3,'Outros Nomes',1,300,0,1,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (4,'Último Nome',1,50,0,1,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (5,'Bilhete Identidade',2,18,1,1,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (6,'Num. Contribuinte',2,18,1,1,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (7,'Num. Sócio',2,18,1,1,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (8,'eMail',1,300,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (9,'Profissão',1,100,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (10,'Morada',1,500,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (11,'Código Postal',7,18,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (12,'Distrito',7,18,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (13,'País',7,18,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (14,'Telefone',1,20,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (15,'Fax',1,20,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (16,'Telemóvel',1,20,0,0,1)

INSERT INTO OW.tblFields (FieldID,Description,TypeID,[Size],[Unique],Empty,[Global])
VALUES (18,'Entidade',1,18,0,0,1)

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
ALTER TABLE OW.tblFields ADD
	Visible bit NOT NULL CONSTRAINT DF_tblFields_Visible DEFAULT 1
Go

INSERT INTO OW.tblFields (FieldID,[Description],TypeID,[Size],[Unique],Empty,[Global],Visible) 
VALUES(0,'Nome',1,400,0,0,1,0)
Go
INSERT INTO OW.tblFields (FieldID,[Description],TypeID,[Size],[Unique],Empty,[Global],Visible) 
VALUES(17,'Lista',1,1,0,0,1,0)

GO

/* ***************** MAINTENANCE SCRIPT ******************************* */
/* This script ensures that all existing records in tblFieldsBookConfig */
/* AND also existing as GLOBAL in tblFormFields will be DELETED         */
delete OW.tblFieldsBookConfig where exists
(select 1 from OW.tblFormFields fields where OW.tblFieldsBookConfig.FormFieldKey = fields.FormFieldKey and fields.Global = 1)


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
	DispatchID numeric(18, 0) NULL
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
	UserID numeric(18, 0) NOT NULL,
	AutoDistribID numeric(18, 0) NOT NULL,
	Origin char(1) NOT NULL,
	Type char(1) NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE OW.tblDistributionAutomaticDestinations ADD CONSTRAINT
	PK_Table1_2 PRIMARY KEY CLUSTERED 
	(
	UserID,
	AutoDistribID,
	Origin
	) ON [PRIMARY]
GO

ALTER TABLE OW.tblDistributionAutomaticDestinations ADD CONSTRAINT
	FK_tblDistributionAutomaticDestinations_tblUser FOREIGN KEY
	(
	UserID
	) REFERENCES OW.tblUser
	(
	userID
	)
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

/* **************** Profile Fields ************* */

/* **************** Configuração de campos ************* */
-- Disable the trigger formfields
ALTER TABLE OW.tblFormFields DISABLE TRIGGER autoNumber_tblFormFields
GO

ALTER TABLE OW.tblFormFields ADD
	Visible bit NOT NULL CONSTRAINT DF_tblFormFields_Visible DEFAULT 1
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
ALTER TABLE OW.tblFileManager ALTER COLUMN FileName VARCHAR(300) NOT NULL
GO
ALTER TABLE OW.tblFileManager ALTER COLUMN FilePath VARCHAR(300) NOT NULL
GO
ALTER TABLE OW.tblFileManager ADD
	CreateDate datetime NULL,
	CreateUserID numeric(18, 0) NULL
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

/* **************** Copiar associação de ficheiros ao registo ************* */
INSERT INTO OW.tblRegistryDocuments (FileID, RegID)
SELECT FileID,RegID From OW.tblFileManager
GO

DROP INDEX OW.tblFileManager.tblFileManager_REGID
GO
ALTER TABLE OW.tblFileManager DROP COLUMN RegID
GO

/* ************************* Utilizadores *********************************** */
UPDATE OW.tblUser SET userActive=1 where userActive IS NULL

/* ************************ Correio electrónico  **************************** */
CREATE TABLE OW.tblElectronicMailUsers
	(
	MailUserID numeric(18, 0) NOT NULL IDENTITY (1, 1),
	eMail varchar(500) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE OW.tblElectronicMailUsers ADD CONSTRAINT
	PK_Table1 PRIMARY KEY CLUSTERED 
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
ALTER TABLE OW.tblBooks ADD
	hierarchical bit NOT NULL CONSTRAINT DF_tblBooks_hierarchical DEFAULT 0
GO
ALTER TABLE OW.tblUser ADD
	PrimaryGroupID numeric(18, 0) NULL

GO

/* **************** Fix other entities ************* */
UPDATE OW.tblRegistryEntities SET [Type]=1 where [Type]='O'
GO
UPDATE OW.tblRegistryEntities SET [Type]=0 where [Type]<>'O'

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
insert into OW.tblVersion (id,version) VALUES (1,'4.1.4')
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

ALTER TABLE OW.tblPostalCode ADD CONSTRAINT
	IX_tblPostalCode_Code_Description UNIQUE NONCLUSTERED 
	(
	Code,
	Description
	) ON [PRIMARY]
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
/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_SetEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_SetEntitiesGroups]
GO
/* NOVO */
GO
CREATE PROCEDURE [OW].[usp_SetEntitiesGroups]
(
	@EntID numeric(18,0),
	@FirstName varchar(50),
	@ListID numeric (18,0)
)
AS
	SET NOCOUNT ON
	
	UPDATE [OW].[tblEntities]
	SET
		[OW].[tblEntities].[FirstName] = @FirstName,
		[OW].[tblEntities].[ListID] = @ListID
	WHERE 
		[OW].[tblEntities].[EntID] = @EntID

	RETURN @@Error

GO

-- Remover usp_GetEntitiesGroups
/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_GetEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_GetEntitiesGroups]
GO

-- Criar usp_GetEntitiesGroups
GO
/* NOVO */
CREATE   PROCEDURE OW.usp_GetEntitiesGroups

	AS
	
	SELECT
	     	OW.tblEntities.EntID, 
		OW.tblEntities.FirstName, 
		OW.tblEntities.Type,
		OW.tblEntityList.Description,
		OW.tblEntities.ListID
	FROM    
		OW.tblEntities INNER JOIN
                OW.tblEntityList ON 
		OW.tblEntities.ListID = OW.tblEntityList.ListID
	WHERE
		OW.tblEntities.Type = 2
	ORDER BY 
		OW.tblEntities.FirstName
	
	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0
GO

/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_DeleteEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_DeleteEntitiesGroups]
GO

/* NOVO */
if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_DelEntitiesGroups]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_DelEntitiesGroups]
GO

/* NOVO */
CREATE PROCEDURE [OW].[usp_DelEntitiesGroups]
(
	@EntID numeric(18,0)
)
AS
	SET NOCOUNT ON

	DELETE 
	FROM   [OW].[tblEntities]
	WHERE  
		[OW].[tblEntities].[EntID] = @EntID

	RETURN @@Error

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_GetGroupsEntities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_GetGroupsEntities]
GO

CREATE PROCEDURE OW.usp_GetGroupsEntities
(
	@ENTID numeric(18,0)=null,
	@Description varchar(50)=null
)

AS

IF ( @ENTID is null and @Description is null)
BEGIN
		SELECT ENTID, FIRSTNAME, TYPE 
		FROM OW.tblentities
		where type=2
END
ELSE
BEGIN 
	IF (@ENTID is not null and @Description is null)
	BEGIN
		SELECT ENTID, FIRSTNAME, TYPE 
		FROM OW.tblentities 
		WHERE EXISTS (SELECT 1 
					  FROM OW.tblGroupsEntities tge
					  WHERE tge.EntID = @ENTID AND
							tge.ObjectID=OW.tblentities.EntID) 
	END
	ELSE
	BEGIN
		IF (@ENTID is null and @Description is not null)
		BEGIN
				SELECT ENTID, FIRSTNAME, TYPE 
				FROM OW.tblentities 
				WHERE FirstName like @Description
				AND type=2 
		END
		ELSE
		BEGIN  -- Both are not null
			SELECT ENTID, FIRSTNAME, TYPE 
			FROM OW.tblentities 
			WHERE (FirstName like @Description
				AND type=2) OR
			EXISTS (SELECT 1 
					FROM OW.tblGroupsEntities tge
					WHERE tge.EntID = @ENTID AND
					tge.ObjectID=OW.tblentities.EntID) 		
		END
	END
END

RETURN @@ERROR

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_DelGroupsEntities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_DelGroupsEntities]
GO


CREATE PROCEDURE OW.usp_DelGroupsEntities
	(
		@EntID numeric,
		@ObjectId as numeric
	)
AS


	SET XACT_ABORT ON

	BEGIN TRANSACTION
		
		DELETE FROM [OW].[tblGroupsEntities]
		WHERE 
			EntID = @EntID
			AND ObjectId = @ObjectId
		
				
	COMMIT TRANSACTION
	RETURN 0


GO


if exists (select * from dbo.sysobjects where id = object_id(N'[OW].[usp_NewGroupsEntities]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [OW].[usp_NewGroupsEntities]
GO

CREATE PROCEDURE OW.usp_NewGroupsEntities
	(
		@EntID numeric,
		@list as ntext
	)
AS


	SET XACT_ABORT ON

	BEGIN TRANSACTION

		IF @list is not null
		BEGIN
			INSERT OW.tblGroupsEntities (EntID,ObjectID)
			SELECT @EntID,ObjectID FROM
			(SELECT cast (value as numeric) As ObjectID
			FROM OW.fnListToTable(@list,',') ) as tObjectIDs
			WHERE not exists (SELECT 1 FROM OW.tblGroupsEntities as tge WHERE 
			tge.EntID=@EntID AND 
		  	tge.ObjectID = tObjectIDs.ObjectID )
		END
		
	COMMIT TRANSACTION
	RETURN 0

/*******************************************************************************************************************/
GO


CREATE PROCEDURE OW.SetContactField
	(
		@Desc varchar(50),
		@ID numeric
	)
AS
	SET NOCOUNT ON 
	UPDATE OW.tblFields SET Description=@Desc
	WHERE FieldID=@ID
	return @@ERROR
GO



/* **************************************************************************************** */
/*                                    Webservice                                            */
/* **************************************************************************************** */


CREATE PROCEDURE OW.usp_SetEntity
 
@firstName varchar(50),
@middleName varchar(300) = '',
@lastName varchar(50) = '',
@eMail varchar(300),
@listId int,
@active int = 1,
@type int = 1
 
AS
 
declare @result int 
declare @EntID numeric
set @result = 0
 
 
 
select @result = count(*) from OW.tblEntities where eMail = @eMail
 
if (@result = 0)
begin
 
 insert into OW.tblEntities (FirstName, MiddleName, LastName, eMail, ListID, Active, Type) values (@firstName, @middleName, @lastName, @eMail, @listId, @active, @type)
 SET @EntID = @@identity
end
else
begin
 
 SELECT @EntID=EntID FROM OW.tblEntities WHERE eMail = @eMail and active <> 1
 
 IF (@EntID>0 )
 BEGIN
   UPDATE OW.tblEntities  SET active=1
   WHERE eMail = @eMail and active <> 1
 END
 ELSE
 BEGIN
  select @EntID=EntID from OW.tblEntities where eMail = @eMail and active=1
 END
END
 
 SELECT @EntID As EntID
 return @@error
GO





CREATE PROCEDURE OW.usp_AddFileToRegistry
    (
        @RegID numeric,
        @FileName varchar(300),
        @FilePath varchar(300),
        @UserID numeric(18,0)
    )
AS

    SET NOCOUNT ON

SET XACT_ABORT ON
BEGIN TRANSACTION
    DECLARE @TempPath varchar(15)
    DECLARE @FileExtension int
    DECLARE @TempNumber int

    DECLARE @NextNumber numeric(18,0)
    
INSERT INTO OW.tblFileManager (FileName,FilePath,CreateDate,CreateUserID) 
	VALUES (@FileName,' ',GetDate(),@UserID)    
    
    SET @NextNumber=@@IDENTITY
                
    SET @FileExtension = LEN(@FileName)
    SET @TempNumber = @NextNumber
    SET @TempPath = ''

    WHILE (@TempNumber > 0)
    BEGIN
        SET @TempPath = @TempPath + (
        CASE (@TempNumber % 16)
            WHEN 0 THEN '0'
            WHEN 1 THEN '1'
            WHEN 2 THEN '2'
            WHEN 3 THEN '3'
            WHEN 4 THEN '4'
            WHEN 5 THEN '5'
            WHEN 6 THEN '6'
            WHEN 7 THEN '7'
            WHEN 8 THEN '8'
            WHEN 9 THEN '9'
            WHEN 10 THEN 'A'
            WHEN 11 THEN 'B'
            WHEN 12 THEN 'C'
            WHEN 13 THEN 'D'
            WHEN 14 THEN 'E'
            WHEN 15 THEN 'F'
        END)
        SET @TempNumber = @TempNumber / 16
    END
    SET @TempPath = '00000000' + REVERSE(@TempPath)
    SET @TempPath = SUBSTRING(@TempPath, LEN(@TempPath) - 7, LEN(@TempPath))
    SET @TempPath = '\' + SUBSTRING(@TempPath, 1, 2) + '\' + SUBSTRING(@TempPath, 3, 2) + '\' + SUBSTRING(@TempPath, 5, 2) + '\' + SUBSTRING(@TempPath, 7, 2)

    SET @FilePath = @FilePath + @TempPath

    WHILE (@FileExtension > 0)
    BEGIN
        IF SUBSTRING(@FileName, @FileExtension, 1) = '.'
        BEGIN
            SET @FilePath = @FilePath + SUBSTRING(@FileName, @FileExtension, (LEN(@FileName) + 1) - @FileExtension)
            BREAK
        END
        SET @FileExtension = @FileExtension - 1
    END


	-- Update file path	
	UPDATE  OW.tblFileManager SET FilePath=@FilePath
	WHERE FileID=@NextNumber
	
	-- Set registry association
INSERT INTO OW.tblRegistryDocuments (RegID,FileID) VALUES
(@RegID,@NextNumber)	
	
/*
    INSERT INTO OW.tblFileManager ([FileID], [RegID], [FileName], [FilePath])
    VALUES (@NextNumber, @RegID, @FileName, @FilePath)
*/    
    IF @@ERROR = 0
        SELECT @NextNumber AS RegFileID
    ELSE
        SELECT 0 AS RegFileID
COMMIT TRANSACTION
GO

/****** Object:  Stored Procedure OW.usp_GetEntityID    Script Date: 28-07-2004 18:18:03 ******/
GO

CREATE PROCEDURE OW.usp_GetEntityID
    (
        @Name varchar(200) = Null,
        @ContactID nvarchar(250) = Null
    )
AS
SET NOCOUNT ON

SET CONCAT_NULL_YIELDS_NULL OFF

SELECT EntID FROM OW.tblEntities 
WHERE (RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' ')))) LIKE @NAME

RETURN @@ERROR


GO





/****** Object:  Stored Procedure OW.usp_GetDocTypeID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDocTypeID
    (
        @abreviation nvarchar(20) = Null,
        @designation nvarchar(100) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @DocTypeID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(300)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT DocTypeID FROM OW.tblDocumentType'

    IF LEN(@abreviation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'abreviation like ''' + @abreviation + ''''
        END

    IF LEN(@designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'designation like ''' + @designation + ''''
        END

    EXEC sp_ExecuteSQL @Query


GO


/****** Object:  Stored Procedure OW.usp_GetBookID    Script Date: 12/4/2003 15:36:46 ******/
CREATE PROCEDURE OW.usp_GetBookID
    (
        @abreviation nvarchar(20)  = Null,
        @designation nvarchar(100)  = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @BookID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(300)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT BookID FROM OW.tblBooks'

    IF LEN(@abreviation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'abreviation like ''' + @abreviation + ''''
        END

    IF LEN(@designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'designation like ''' + @designation + ''''
        END

    EXEC sp_ExecuteSQL @Query

GO

/****** Object:  Stored Procedure OW.usp_GetClassificationID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetClassificationID
    (
        @Level1 nvarchar(50) = Null,
        @Level2 nvarchar(50) = Null,
        @Level3 nvarchar(50) = Null,
        @Level4 nvarchar(50) = Null,
        @Level5 nvarchar(50) = Null,
        @Level1Designation nvarchar(100) = Null,
        @Level2Designation nvarchar(100) = Null,
        @Level3Designation nvarchar(100) = Null,
        @Level4Designation nvarchar(100) = Null,
        @Level5Designation nvarchar(100) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @ClassificationID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(1000)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT ClassID FROM OW.tblClassification'

    IF LEN(@Level1) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level1 like ''' + @Level1 + ''''
        END
    ELSE
        IF @Level1 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level1 is NULL'
            END

    IF LEN(@Level2) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level2 like ''' + @Level2 + ''''
        END
    ELSE
        IF @Level2 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level2 is NULL'
            END

    IF LEN(@Level3) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level3 like ''' + @Level3 + ''''
        END
    ELSE
        IF @Level3 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level3 is NULL'
            END

    IF LEN(@Level4) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level4 like ''' + @Level4 + ''''
        END
    ELSE
        IF @Level4 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level4 is NULL'
            END

    IF LEN(@Level5) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level5 like ''' + @Level5 + ''''
        END
    ELSE
        IF @Level5 IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level5 is NULL'
            END

    IF LEN(@Level1Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level1Desig like ''' + @Level1Designation + ''''
        END
    ELSE
        IF @Level1Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level1Desig is NULL'
            END

    IF LEN(@Level2Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level2Desig like ''' + @Level2Designation + ''''
        END
    ELSE
        IF @Level2Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level2Desig is NULL'
            END

    IF LEN(@Level3Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level3Desig like ''' + @Level3Designation + ''''
        END
    ELSE
        IF @Level3Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level3Desig is NULL'
            END

    IF LEN(@Level4Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level4Desig like ''' + @Level4Designation + ''''
        END
    ELSE
        IF @Level4Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level4Desig is NULL'
            END

    IF LEN(@Level5Designation) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'Level5Desig like ''' + @Level5Designation + ''''
        END
    ELSE
        IF @Level5Designation IS NULL
            BEGIN
                IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
                SET @NumberOfParameters = @NumberOfParameters + 1
                IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
                SET @Query = @Query + 'Level5Desig is NULL'
            END

    EXEC sp_ExecuteSQL @Query

GO

/****** Object:  Stored Procedure OW.usp_GetUserID    Script Date: 28-07-2004 18:18:04 ******/
GO

CREATE PROCEDURE OW.usp_GetUserID
    (
        @UserLogin varchar(900) = Null,
        @UserDesc varchar(300) = Null,
        @UserMail varchar(200) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @UserID numeric
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(700)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT UserID FROM OW.tblUser'

    IF LEN(@userLogin) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'userLogin like ''' + @userLogin + ''''
        END

    IF LEN(@userDesc) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'userDesc like ''' + @userDesc + ''''
        END

    IF LEN(@userMail) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'userMail like ''' + @userMail + ''''
        END

    EXEC sp_ExecuteSQL @Query

GO

/****** Object:  Stored Procedure OW.usp_InsertFullRegistry    Script Date: 28-07-2004 18:18:04 ******/
GO

CREATE PROCEDURE OW.usp_InsertFullRegistry
    (
        @DocTypeAbreviation nvarchar(20),
        @DocTypeDesignation nvarchar(100),
        @BookAbreviation nvarchar(20),
        @BookDesignation nvarchar(100),
        @Year numeric,
        @Number numeric,
        @Date datetime,
        @OriginRef varchar(30),
        @OriginDate datetime,
        @Subject nvarchar(250),
        @Observations nvarchar(250),
        @ProcessNumber nvarchar(50),
        @Cota nvarchar(50),
        @Bloco nvarchar(50),
        @Level1 nvarchar(50),
        @Level2 nvarchar(50),
        @Level3 nvarchar(50),
        @Level4 nvarchar(50),
        @Level5 nvarchar(50),
        @Level1Designation nvarchar(100),
        @Level2Designation nvarchar(100),
        @Level3Designation nvarchar(100),
        @Level4Designation nvarchar(100),
        @Level5Designation nvarchar(100),
        @UserLogin varchar(900),
        @UserDesc varchar(300),
        @UserMail varchar(200),
        @AntecedenteID numeric = NULL,
        @EntityName varchar(200),
        @EntityContactID nvarchar(250),
        @UserModifyLogin varchar(900),
        @UserModifyDesc varchar(300),
        @UserModifyMail varchar(200),
        @DateModify datetime = NULL,
        @Historic bit = 0,
        @Field1 float,
        @Field2 nvarchar(50)	
    )
AS
    SET NOCOUNT ON
    DECLARE @DocTypeID numeric
    DECLARE @BookID numeric
    DECLARE @ClassificationID numeric
    DECLARE @UserID numeric
    DECLARE @EntityID numeric
    DECLARE @UserModifyID numeric



    EXEC @DocTypeID = OW.usp_GetDocTypeID @DocTypeAbreviation, @DocTypeDesignation
    if(@@ERROR <> 0) return(1)
    EXEC @BookID = OW.usp_GetBookID @BookAbreviation, @BookDesignation
    if(@@ERROR <> 0) return(1)
    EXEC @ClassificationID = OW.usp_GetClassificationID @Level1, @Level2, @Level3, @Level4, @Level5, @Level1Designation, @Level2Designation, @Level3Designation, @Level4Designation, @Level5Designation
    if(@@ERROR <> 0) return(1)
    EXEC @UserID = OW.usp_GetUserID @UserLogin, @UserDesc, @UserMail
    if(@@ERROR <> 0) return(1)
    EXEC @EntityID = OW.usp_GetEntityID @EntityName, @EntityContactID
    if(@@ERROR <> 0) return(1)
    EXEC @UserModifyID = OW.usp_GetUserID @UserModifyLogin, @UserModifyDesc, @UserModifyMail
    if(@@ERROR <> 0) return(1)





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






/* *********************************************************************************************/
/*                              OWFLOW TABLES                                                  */
/* *********************************************************************************************/

SET CONCAT_NULL_YIELDS_NULL OFF
GO



/**************************************************************\
*
*  TABLES
*
\**************************************************************/

create table OW.tblNonWorkingDays
(
	ID numeric (18) IDENTITY NOT NULL,
	Day numeric(5) NOT NULL
)
GO

insert into OW.tblNonWorkingDays values(1) -- Domingo
insert into OW.tblNonWorkingDays values(7) -- Sábado
GO



create table OW.tblNonWorkingHours
(
	ID numeric (18) IDENTITY NOT NULL,
	StartHour datetime NOT NULL,
	FinishHour datetime NOT NULL
)
GO

-- O periodo de inatividade é definido num intervalo fechado [hora inicial .. hora final]
-- por isso a hora final não deve ser 09:00:00 mas sim 08:59:59.
insert into OW.tblNonWorkingHours values('1999-01-01 00:00:00','1999-01-01 08:59:59') -- Madrugada
insert into OW.tblNonWorkingHours values('1999-01-01 12:00:00','1999-01-01 12:59:59') -- Almoço
insert into OW.tblNonWorkingHours values('1999-01-01 18:00:00','1999-01-01 23:59:59') -- Noite
GO



CREATE TABLE OW.tblFlow (
	FlowID numeric (18) IDENTITY NOT NULL,
	Code varchar (10) NOT NULL,
	Name varchar (50) NOT NULL,
	State char NOT NULL,
	DurationDays numeric(6),
	DurationHours numeric(8,2),
	WorkCalendar numeric(1) NOT NULL,
	OriginatorAccess numeric(1) NOT NULL 
)
GO


CREATE TABLE OW.tblFlowStages (
	FlowStageID numeric (18) IDENTITY NOT NULL,
	FlowID numeric (18) NOT NULL,
	Number numeric (3) NOT NULL,
	Name varchar (50) NOT NULL,
	DurationDays numeric(3),
	DurationHours numeric(5,2),
	ExecutantType char NOT NULL,
	ExecutantTypeUserID numeric (18),
	ExecutantTypeGroupID numeric (18)
)
GO

CREATE TABLE OW.tblFlowAlarms (
	FlowAlarmID numeric (18) IDENTITY NOT NULL,
	FlowID numeric (18) NOT NULL,
	Occurence numeric (2) NOT NULL,
	OccurenceOffsetDays numeric (4) NOT NULL,
	OccurenceOffsetHours numeric (6,2) NOT NULL,
	FlowStageID numeric (18),
	Message varchar (100) NOT NULL,
	AlertByEMail numeric(1) NOT NULL,
	AddresseeExecutant numeric (1) NOT NULL
)
GO

CREATE TABLE OW.tblFlowAlarmAddressees (
	FlowAlarmAddresseeID numeric (18) IDENTITY NOT NULL,
	FlowAlarmID numeric (18) NOT NULL,
	AddresseeType char(1) NOT NULL,
	UserID numeric (18),
	GroupID numeric (18)
)
GO

CREATE TABLE OW.tblFlowUserAccesses (
	FlowID numeric (18) NOT NULL,
	UserID numeric (18) NOT NULL
)
GO

CREATE TABLE OW.tblFlowGroupAccesses (
	FlowID numeric (18) NOT NULL,
	GroupID numeric (18) NOT NULL
)
GO

CREATE TABLE OW.tblProcess (
	ProcessID numeric (18) IDENTITY NOT NULL,
	Code varchar (10) NOT NULL,
	Number numeric (9) NOT NULL,
	Year numeric (4) NOT NULL,
	Name varchar (50) NOT NULL,
	State numeric (1) NOT NULL,
	DurationDays numeric(6),
	DurationHours numeric(8,2),
	WorkCalendar numeric(1) NOT NULL,
	StartDate datetime NOT NULL,
	LimitDate datetime,
	FinishDate datetime,
	WorkCompleted numeric(3) NOT NULL,
	OriginatorAccess numeric(1) NOT NULL 
)
GO


CREATE TABLE OW.tblProcessStages (
	ProcessStageID numeric (18) IDENTITY NOT NULL,
	ProcessID numeric (18) NOT NULL,
	Number numeric (3) NOT NULL,
	Name varchar (50) NOT NULL,
	ExecutantType char NOT NULL,
	ExecutantTypeUserID numeric (18),
	ExecutantTypeGroupID numeric (18),
	ExecutantID numeric (18),
	DurationDays numeric(3),
	DurationHours numeric(5,2),
	StartDate datetime,
	ReadDate datetime,
	LimitDate datetime,
	FinishDate datetime,
	Notes text
)
GO

CREATE TABLE OW.tblProcessDocuments (
	ProcessDocumentID numeric (18) IDENTITY NOT NULL,
	ProcessID numeric (18) NOT NULL,
	FileID numeric (18) NOT NULL,
	ProcessStageID numeric (18),
	AssociationDate datetime NOT NULL,
	AssociationUserID numeric (18) NOT NULL
)
GO


CREATE TABLE OW.tblProcessAlarms (
	ProcessAlarmID numeric (18) IDENTITY NOT NULL,
	ProcessID numeric (18) NOT NULL,
	Occurence numeric (2) NOT NULL,
	OccurenceOffsetDays numeric (4) NOT NULL,
	OccurenceOffsetHours numeric (6,2) NOT NULL,
	ProcessStageID numeric (18),
	Message varchar (100) NOT NULL,
	AlertByEMail numeric (1) NOT NULL,
	AddresseeExecutant numeric (1) NOT NULL
)
GO

CREATE TABLE OW.tblProcessAlarmAddressees (
	ProcessAlarmAddresseeID numeric (18) IDENTITY NOT NULL,
	ProcessAlarmID numeric (18) NOT NULL,
	AddresseeType char(1) NOT NULL,
	UserID numeric (18),
	GroupID numeric (18)
)
GO

CREATE TABLE OW.tblProcessUserAccesses (
	ProcessID numeric (18) NOT NULL,
	UserID numeric (18) NOT NULL
)
GO

CREATE TABLE OW.tblProcessGroupAccesses (
	ProcessID numeric (18) NOT NULL,
	GroupID numeric (18) NOT NULL
)
GO



CREATE TABLE OW.tblAlarms (
	AlarmID numeric (18) IDENTITY NOT NULL,
	AlarmDateTime datetime NOT NULL,
	ProcessAlarmID numeric (18) NOT NULL
)
GO



CREATE TABLE OW.tblAlerts (
	AlertID numeric (18) IDENTITY NOT NULL,
	Message varchar (100) NOT NULL,
	UserID numeric (18) NOT NULL,
	ProcessID numeric (18) NOT NULL,
	SendDate datetime NOT NULL,
	ReadDate datetime
)
GO

/**************************************************************\
*
*  CONSTRAINTS
*
\**************************************************************/

ALTER TABLE OW.tblNonWorkingDays ADD 
	CONSTRAINT NWD_PK  PRIMARY KEY CLUSTERED (ID),
	CONSTRAINT NWD_UK1 UNIQUE      NONCLUSTERED  (Day)
GO

ALTER TABLE OW.tblNonWorkingDays ADD 
	CONSTRAINT NWD_CH1 CHECK ( Day between 1 and 7)
GO

ALTER TABLE OW.tblNonWorkingHours ADD 
	CONSTRAINT NWH_PK  PRIMARY KEY CLUSTERED (ID),
	CONSTRAINT NWH_UK1 UNIQUE      NONCLUSTERED  (StartHour,FinishHour)
GO

ALTER TABLE OW.tblNonWorkingHours ADD 
	CONSTRAINT NWH_CH1 CHECK (year(StartHour)=1999 and month(StartHour)=1 and day(StartHour)=1),
	CONSTRAINT NWH_CH2 CHECK (year(FinishHour)=1999 and month(FinishHour)=1 and day(FinishHour)=1)
GO

ALTER TABLE OW.tblFlow ADD 
	CONSTRAINT FL_PK  PRIMARY KEY CLUSTERED     (FlowID),
	CONSTRAINT FL_UK1 UNIQUE      NONCLUSTERED  (Code)
GO

ALTER TABLE OW.tblFlow ADD 
	CONSTRAINT FL_CH1 CHECK ( State in ('C','P') ),
	CONSTRAINT FL_CH2 CHECK ( ( DurationDays is null or DurationHours is not null ) and 
								( DurationHours is null or DurationDays is not null )),
	CONSTRAINT FL_CH3 CHECK ( DurationDays>=0 and DurationHours>=0 ),
	CONSTRAINT FL_CH4 CHECK ( WorkCalendar in (1,2) ),
	CONSTRAINT FL_CH5 CHECK ( OriginatorAccess in (0,1) ),
	CONSTRAINT FL_CH6 CHECK ( Code not like '% %' AND Code <> 'ADHOC' ),
	CONSTRAINT FL_CH7 CHECK ( Code <> '' ),
	CONSTRAINT FL_CH8 CHECK ( Name <> '' )
GO

ALTER TABLE OW.tblFlowStages ADD 
	CONSTRAINT FLST_PK  PRIMARY KEY CLUSTERED     (FlowStageID),
	CONSTRAINT FLST_UK1 UNIQUE      NONCLUSTERED  (FlowID, Number)
GO

ALTER TABLE OW.tblFlowStages ADD 
	CONSTRAINT FLST_CH1 CHECK ( Number > 0 ),
	CONSTRAINT FLST_CH2 CHECK ( ( DurationDays is null or DurationHours is not null ) and 
								( DurationHours is null or DurationDays is not null )),
	CONSTRAINT FLST_CH3 CHECK ( DurationDays>=0 and DurationHours>=0 ),
	CONSTRAINT FLST_CH4 CHECK ( ExecutantType in ('U','G') ),
	CONSTRAINT FLST_CH5 CHECK ( ExecutantType <> 'U' OR ExecutantTypeUserID IS NOT NULL ),
	CONSTRAINT FLST_CH6 CHECK ( ExecutantType <> 'G' OR ExecutantTypeGroupID IS NOT NULL ),
	CONSTRAINT FLST_CH7 CHECK ( Name <> '' )
GO

ALTER TABLE OW.tblFlowStages ADD 
	CONSTRAINT FLST_FK1_FL FOREIGN KEY (FlowID) REFERENCES OW.tblFlow (FlowID) ON DELETE CASCADE,
	CONSTRAINT FLST_FK2_U  FOREIGN KEY (ExecutantTypeUserID) REFERENCES OW.tblUser (UserID),
	CONSTRAINT FLST_FK3_G  FOREIGN KEY (ExecutantTypeGroupID) REFERENCES OW.tblGroups (GroupID)
GO

ALTER TABLE OW.tblFlowAlarms ADD 
	CONSTRAINT FLAL_PK  PRIMARY KEY CLUSTERED     (FlowAlarmID)
GO

ALTER TABLE OW.tblFlowAlarms ADD 
	CONSTRAINT FLAL_CH1 CHECK ( Occurence in (1,2,3,4,5,6,7) ),
	CONSTRAINT FLAL_CH2 CHECK ( OccurenceOffsetDays >=0 and OccurenceOffsetHours >=0 ),
	CONSTRAINT FLAL_CH3 CHECK ( Occurence not in (1,2,3,7) OR FlowStageID IS NOT NULL ),
	CONSTRAINT FLAL_CH4 CHECK ( AlertByEMail in (0,1) ),
	CONSTRAINT FLAL_CH5 CHECK ( AddresseeExecutant in (0,1) ),
	CONSTRAINT FLAL_CH6 CHECK ( Message <> '')
GO

ALTER TABLE OW.tblFlowAlarms ADD 
	CONSTRAINT FLAL_FK1_FL    FOREIGN KEY (FlowID) REFERENCES OW.tblFlow (FlowID) ON DELETE CASCADE,
	CONSTRAINT FLAL_FK2_FLST  FOREIGN KEY (FlowStageID) REFERENCES OW.tblFlowStages (FlowStageID)
GO

ALTER TABLE OW.tblFlowAlarmAddressees ADD 
	CONSTRAINT FLAA_PK  PRIMARY KEY CLUSTERED     (FlowAlarmAddresseeID)
GO

ALTER TABLE OW.tblFlowAlarmAddressees ADD 
	CONSTRAINT FLAA_CH1 CHECK ( AddresseeType in ('U','G') ),
	CONSTRAINT FLAA_CH2 CHECK ( AddresseeType <> 'U' OR UserID IS NOT NULL ),
	CONSTRAINT FLAA_CH3 CHECK ( AddresseeType <> 'G' OR GroupID IS NOT NULL )
GO

ALTER TABLE OW.tblFlowAlarmAddressees ADD 
	CONSTRAINT FLAA_FK1_FLAL  FOREIGN KEY (FlowAlarmID) REFERENCES OW.tblFlowAlarms (FlowAlarmID) ON DELETE CASCADE,
	CONSTRAINT FLAA_FK2_U     FOREIGN KEY (UserID) REFERENCES OW.tblUser (UserID),
	CONSTRAINT FLAA_FK3_G     FOREIGN KEY (GroupID) REFERENCES OW.tblGroups (GroupID)
GO

ALTER TABLE OW.tblFlowUserAccesses ADD 
	CONSTRAINT FLUA_PK  PRIMARY KEY CLUSTERED (FlowID, UserID)
GO

ALTER TABLE OW.tblFlowUserAccesses ADD 
	CONSTRAINT FLUA_FK1_FL FOREIGN KEY (FlowID) REFERENCES OW.tblFlow (FlowID) ON DELETE CASCADE,
	CONSTRAINT FLUA_FK2_U  FOREIGN KEY (UserID) REFERENCES OW.tblUser (UserID)
GO

ALTER TABLE OW.tblFlowGroupAccesses ADD 
	CONSTRAINT FLGA_PK  PRIMARY KEY CLUSTERED (FlowID, GroupID)
GO

ALTER TABLE OW.tblFlowGroupAccesses ADD 
	CONSTRAINT FLGA_FK1_FL FOREIGN KEY (FlowID) REFERENCES OW.tblFlow (FlowID) ON DELETE CASCADE,
	CONSTRAINT FLGA_FK2_G  FOREIGN KEY (GroupID) REFERENCES OW.tblGroups (GroupID)
GO









ALTER TABLE OW.tblProcess ADD 
	CONSTRAINT PR_PK  PRIMARY KEY CLUSTERED     (ProcessID),
	CONSTRAINT PR_UK1 UNIQUE      NONCLUSTERED  (Code, Year, Number)
GO

ALTER TABLE OW.tblProcess ADD 
	CONSTRAINT PR_CH1 CHECK ( State in (1,2,3,4) ),
	CONSTRAINT PR_CH2 CHECK ( Number > 0 and Year >0 ),
	CONSTRAINT PR_CH3 CHECK ( ( DurationDays is null or DurationHours is not null ) and 
								( DurationHours is null or DurationDays is not null )),
	CONSTRAINT PR_CH4 CHECK ( DurationDays>=0 and DurationHours>=0 ),
	CONSTRAINT PR_CH5 CHECK ( WorkCalendar in (1,2) ),
	CONSTRAINT PR_CH6 CHECK ( OriginatorAccess in (0,1) ),
	CONSTRAINT PR_CH7 CHECK ( LimitDate >= StartDate ),
	CONSTRAINT PR_CH8 CHECK ( FinishDate >= StartDate ),
	CONSTRAINT PR_CH9 CHECK ( State <> 4 OR FinishDate IS NOT NULL ),
	CONSTRAINT PR_CH10 CHECK ( WorkCompleted >= 0 AND WorkCompleted <= 100 ),
	CONSTRAINT PR_CH11 CHECK ( Code <> '' ),
	CONSTRAINT PR_CH12 CHECK ( Name <> '' )
GO












ALTER TABLE OW.tblProcessStages ADD 
	CONSTRAINT PRST_PK  PRIMARY KEY CLUSTERED     (ProcessStageID),
	CONSTRAINT PRST_UK1 UNIQUE      NONCLUSTERED  (ProcessID, Number)
GO

ALTER TABLE OW.tblProcessStages ADD 
	CONSTRAINT PRST_CH1 CHECK ( Number > 0 ),
	CONSTRAINT PRST_CH2 CHECK ( ( DurationDays is null or DurationHours is not null ) and 
								( DurationHours is null or DurationDays is not null )),
	CONSTRAINT PRST_CH3 CHECK ( DurationDays>=0 and DurationHours>=0),
	CONSTRAINT PRST_CH4 CHECK ( LimitDate >= StartDate ),
	CONSTRAINT PRST_CH5 CHECK ( ReadDate >= StartDate ),
	CONSTRAINT PRST_CH6 CHECK ( FinishDate >= ReadDate ),
	CONSTRAINT PRST_CH7 CHECK ( ExecutantType in ('U','G') ),
	CONSTRAINT PRST_CH8 CHECK ( ExecutantType <> 'U' OR ExecutantTypeUserID IS NOT NULL ),
	CONSTRAINT PRST_CH9 CHECK ( ExecutantType <> 'G' OR ExecutantTypeGroupID IS NOT NULL ),
	CONSTRAINT PRST_CH10 CHECK ( Name <> '' )
GO

ALTER TABLE OW.tblProcessStages ADD 
	CONSTRAINT PRST_FK1_PR FOREIGN KEY (ProcessID) REFERENCES OW.tblProcess (ProcessID)  ON DELETE CASCADE,
	CONSTRAINT PRST_FK2_U  FOREIGN KEY (ExecutantTypeUserID) REFERENCES OW.tblUser (UserID),
	CONSTRAINT PRST_FK3_G  FOREIGN KEY (ExecutantTypeGroupID) REFERENCES OW.tblGroups (GroupID),
	CONSTRAINT PRST_FK4_U  FOREIGN KEY (ExecutantID) REFERENCES OW.tblUser (UserID)
GO










ALTER TABLE OW.tblProcessDocuments ADD 
	CONSTRAINT PRDOC_PK  PRIMARY KEY CLUSTERED     (ProcessDocumentID),
	CONSTRAINT PRDOC_UK1 UNIQUE      NONCLUSTERED  (ProcessID, ProcessStageID, FileID )
GO

ALTER TABLE OW.tblProcessDocuments ADD 
	CONSTRAINT PRDOC_FK1_PR    FOREIGN KEY (ProcessID) REFERENCES OW.tblProcess (ProcessID)  ON DELETE CASCADE,
	CONSTRAINT PRDOC_FK2_FM    FOREIGN KEY (FileID) REFERENCES OW.tblFileManager (FileID),
	CONSTRAINT PRDOC_FK3_PRST  FOREIGN KEY (ProcessStageID) REFERENCES OW.tblProcessStages (ProcessStageID),
	CONSTRAINT PRDOC_FK4_U     FOREIGN KEY (AssociationUserID) REFERENCES OW.tblUser (UserID)
GO


















ALTER TABLE OW.tblProcessAlarms ADD 
	CONSTRAINT PRAL_PK  PRIMARY KEY CLUSTERED     (ProcessAlarmID)
GO

ALTER TABLE OW.tblProcessAlarms ADD 
	CONSTRAINT PRAL_CH1 CHECK ( Occurence in (1,2,3,4,5,6,7) ),
	CONSTRAINT PRAL_CH2 CHECK ( OccurenceOffsetDays >=0 and OccurenceOffsetHours >=0 ),
	CONSTRAINT PRAL_CH3 CHECK ( Occurence not in (1,2,3,7) OR ProcessStageID IS NOT NULL ),
	CONSTRAINT PRAL_CH4 CHECK ( AlertByEMail in (0,1) ),
	CONSTRAINT PRAL_CH5 CHECK ( AddresseeExecutant in (0,1) ),
	CONSTRAINT PRAL_CH6 CHECK ( Message <> '')
GO

ALTER TABLE OW.tblProcessAlarms ADD 
	CONSTRAINT PRAL_FK1_PR    FOREIGN KEY (ProcessID) REFERENCES OW.tblProcess (ProcessID)  ON DELETE CASCADE,
	CONSTRAINT PRAL_FK2_PRST  FOREIGN KEY (ProcessStageID) REFERENCES OW.tblProcessStages (ProcessStageID)
GO









ALTER TABLE OW.tblProcessAlarmAddressees ADD 
	CONSTRAINT PRAA_PK  PRIMARY KEY CLUSTERED     (ProcessAlarmAddresseeID)
GO

ALTER TABLE OW.tblProcessAlarmAddressees ADD 
	CONSTRAINT PRAA_CH1 CHECK ( AddresseeType in ('U','G') ),
	CONSTRAINT PRAA_CH2 CHECK ( AddresseeType <> 'U' OR UserID IS NOT NULL ),
	CONSTRAINT PRAA_CH3 CHECK ( AddresseeType <> 'G' OR GroupID IS NOT NULL )
GO

ALTER TABLE OW.tblProcessAlarmAddressees ADD 
	CONSTRAINT PRAA_FK1_FLAL  FOREIGN KEY (ProcessAlarmID) REFERENCES OW.tblProcessAlarms (ProcessAlarmID) ON DELETE CASCADE,
	CONSTRAINT PRAA_FK2_U     FOREIGN KEY (UserID) REFERENCES OW.tblUser (UserID),
	CONSTRAINT PRAA_FK3_G     FOREIGN KEY (GroupID) REFERENCES OW.tblGroups (GroupID)
GO












ALTER TABLE OW.tblProcessUserAccesses ADD 
	CONSTRAINT PRUA_PK  PRIMARY KEY CLUSTERED (ProcessID, UserID)
GO

ALTER TABLE OW.tblProcessUserAccesses ADD 
	CONSTRAINT PRUA_FK1_PR FOREIGN KEY (ProcessID) REFERENCES OW.tblProcess (ProcessID)  ON DELETE CASCADE,
	CONSTRAINT PRUA_FK2_U  FOREIGN KEY (UserID) REFERENCES OW.tblUser (UserID)
GO










ALTER TABLE OW.tblProcessGroupAccesses ADD 
	CONSTRAINT PRGA_PK  PRIMARY KEY CLUSTERED (ProcessID, GroupID)
GO

ALTER TABLE OW.tblProcessGroupAccesses ADD 
	CONSTRAINT PRGA_FK1_PR FOREIGN KEY (ProcessID) REFERENCES OW.tblProcess (ProcessID)  ON DELETE CASCADE,
	CONSTRAINT PRGA_FK2_G  FOREIGN KEY (GroupID) REFERENCES OW.tblGroups (GroupID)
GO








ALTER TABLE OW.tblAlarms ADD 
	CONSTRAINT ALM_PK  PRIMARY KEY NONCLUSTERED (AlarmID),
	CONSTRAINT ALM_UK1 UNIQUE      NONCLUSTERED (ProcessAlarmID)
GO


ALTER TABLE OW.tblAlarms ADD 
	CONSTRAINT ALM_FK1_PRAL  FOREIGN KEY (ProcessAlarmID) REFERENCES OW.tblProcessAlarms (ProcessAlarmID)  ON DELETE CASCADE
GO








ALTER TABLE OW.tblAlerts ADD 
	CONSTRAINT ALT_PK  PRIMARY KEY CLUSTERED (AlertID)
GO

ALTER TABLE OW.tblAlerts ADD 
	CONSTRAINT ALT_CH1 CHECK ( ReadDate > SendDate ),
	CONSTRAINT ALT_CH2 CHECK ( Message <> '')
GO

ALTER TABLE OW.tblAlerts ADD 
	CONSTRAINT ALT_FK1_U   FOREIGN KEY (UserID) REFERENCES OW.tblUser (UserID),
	CONSTRAINT ALT_FK2_PR  FOREIGN KEY (ProcessID) REFERENCES OW.tblProcess (ProcessID)  ON DELETE CASCADE
GO


/**************************************************************\
*
*  INDEXS
*
\**************************************************************/
CREATE  INDEX FL_IDX1 ON OW.tblFlow (Code) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX FLST_FK2_U_IDX2 ON OW.tblFlowStages (ExecutantTypeUserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX FLST_FK3_G_IDX3 ON OW.tblFlowStages (ExecutantTypeGroupID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX FLAL_FK1_FL_IDX1 ON OW.tblFlowAlarms (FlowID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX FLAL_FK2_FLST_IDX2  ON OW.tblFlowAlarms (FlowStageID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX FLAA_FK1_FLAL_IDX1 ON OW.tblFlowAlarmAddressees (FlowAlarmID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX FLAA_FK2_U_IDX2 ON OW.tblFlowAlarmAddressees (UserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX FLAA_FK3_G_IDX3 ON OW.tblFlowAlarmAddressees (GroupID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX FLUA_FK2_U_IDX2 ON OW.tblFlowUserAccesses (UserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX FLGA_FK2_G_IDX2 ON OW.tblFlowGroupAccesses (GroupID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX PRST_FK2_U_IDX2 ON OW.tblProcessStages (ExecutantTypeUserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRST_FK3_G_IDX3 ON OW.tblProcessStages (ExecutantTypeGroupID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRST_FK4_U_IDX4 ON OW.tblProcessStages (ExecutantID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
--CREATE  INDEX PRST_IDX5 ON OW.tblProcessStages (StartDate) WITH  FILLFACTOR = 80 ON [PRIMARY]
--GO
--CREATE  INDEX PRST_IDX6 ON OW.tblProcessStages (FinishDate) WITH  FILLFACTOR = 80 ON [PRIMARY]
--GO

CREATE  INDEX PRDOC_FK2_FM_IDX2 ON OW.tblProcessDocuments (FileID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRDOC_FK3_PRST_IDX3 ON OW.tblProcessDocuments (ProcessStageID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRDOC_FK4_U_IDX4 ON OW.tblProcessDocuments (AssociationUserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX PRAL_FK1_PR_IDX1 ON OW.tblProcessAlarms (ProcessID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRAL_FK2_PRST_IDX2 ON OW.tblProcessAlarms (ProcessStageID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX PRAA_FK1_FLAL_IDX1 ON OW.tblProcessAlarmAddressees (ProcessAlarmID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRAA_FK2_U_IDX2 ON OW.tblProcessAlarmAddressees (UserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX PRAA_FK3_G_IDX3 ON OW.tblProcessAlarmAddressees (GroupID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX PRUA_FK2_U_IDX2 ON OW.tblProcessUserAccesses (UserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO

CREATE  INDEX PRGA_FK2_G_IDX2 ON OW.tblProcessGroupAccesses (GroupID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO


CREATE  INDEX ALT_FK1_U_IDX1 ON OW.tblAlerts (UserID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO
CREATE  INDEX ALT_FK2_PR_IDX2 ON OW.tblAlerts (ProcessID) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO


CREATE CLUSTERED INDEX ALM_IDX1 ON OW.tblAlarms (AlarmDateTime) WITH  FILLFACTOR = 80 ON [PRIMARY]
GO


















/***********************************************************************************************/
/*                                      Registry SPS                                           */
/***********************************************************************************************/

go


/****** Object:  User Defined Function OW.usp_GetFieldOrderByProfileID  ******/
GO
CREATE PROCEDURE OW.usp_GetFieldOrderByProfileID
	(
		@FormFieldKey numeric,
		@ProfileId numeric
	)
AS
	

	select FormFieldOrder from OW.tblProfilesFields 
	where ProfileId = @ProfileId
	and FormFieldKey = @FormFieldKey




	RETURN @@ERROR
	
GO


go

CREATE PROCEDURE OW.usp_DeleteApplicationAccess
(
	@objectParentID numeric(18),
	@userID numeric(18) = 0
)
AS
	if @userID > 0 
	begin
		DELETE FROM OW.tblAccess
		WHERE userID = @userID
		AND objectTypeID = 1 --Constante TYPE_PRODUCT=1
		AND objectParentID = @objectParentID
	end 
	else
	begin
		DELETE FROM OW.tblAccess
		WHERE objectTypeID = 1 --Constante TYPE_PRODUCT=1
		AND objectParentID = @objectParentID
	end			

	RETURN @@ERROR


GO


CREATE PROCEDURE OW.GetContactNameByID
	(
		@ID numeric
	)
AS
-- Used By: GetContactNameByID in C#
SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF
	
SELECT RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) As [Name]
FROM OW.tblEntities 
WHERE  EntID=@ID
	
RETURN @@ERROR
go

CREATE PROCEDURE OW.usp_SetApplicationAccess
(
	@userID numeric,
	@objectID numeric,
	@objectParentID numeric
)
AS

	insert into OW.tblAccess (UserID, objectParentID, objectID, objectTypeID, AccessType, objectType)
	values (@userID, @objectParentID, @objectID, 1, null, 1)


	RETURN @@ERROR

go


CREATE PROCEDURE OW.usp_GetUsersAndRolesByProduct
	(
		@Product numeric(18,0),
		@Active bit = null
	)
AS

IF @Active is null
BEGIN
	SELECT cast(a.userID as varchar) + '|' + cast(a.ObjectID as varchar) as userID, u.userDesc + ' ['  + 
	case 
		when a.ObjectID = 2 then 'Utilizador' 
		when a.ObjectID = 7 then 'Gestor' 

	end + ']' as userDesc,
	u.userActive as userActive
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID 
	ORDER BY  u.userDesc
END
ELSE
BEGIN
	SELECT cast(a.userID as varchar) + '|' + cast(a.ObjectID as varchar) as userID, u.userDesc + ' ['  + 
	case 
		when a.ObjectID = 2 then 'Utilizador' 
		when a.ObjectID = 7 then 'Gestor' 

	end + ']' as userDesc,
	u.userActive as userActive
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID
	AND u.userActive=@Active
	ORDER BY  u.userDesc

END

RETURN @@ERROR
GO


CREATE PROCEDURE OW.usp_GetUsersInactiveByProduct

	(
	@Product numeric(18)
	)

AS

	SELECT u.userID, u.userLogin, u.userDesc, u.userMail, u.userActive
	FROM OW.tbluser u
	--where u.userActive = 1
	where not exists (
		select 1 from OW.tblAccess a
		where a.userID = u.userID
		and a.ObjectParentID= @Product 
		And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	)
	ORDER BY  u.userDesc
	
	
	RETURN @@ERROR
GO



/****** Object:  User Defined Function OW.fnDateValidator    Script Date: 28-07-2004 18:18:06 ******/
GO

-- select OW.fnDateValidator(getdate(), '1979-05-02', null)

CREATE FUNCTION OW.fnDateValidator
(
	@todayDate_i datetime,
	@startDate_i datetime,
	@endDate_i datetime

)
RETURNS INT
AS
BEGIN
	
	--if (@todayDate_i is null) return 1
	
	DECLARE @ret int
	DECLARE @date datetime
	DECLARE @eDate datetime
	DECLARE @sDate datetime

	SET @date = @todayDate_i

	if (@endDate_i is null) SET @eDate = @date
	else SET @eDate = @endDate_i

	if (@startDate_i is null) SET @sDate = @date
	else SET @sDate = @startDate_i

	if ( @eDate >= @date and @sDate <= @date)
		SET @ret=1
	else
		SET  @ret=0
	if (DATEDIFF(day,@date,@eDate)=0) and (DATEDIFF(day,@date,@sDate)=0)
		SET @ret=1
	RETURN @ret
END 

GO


/****** Object:  User Defined Function OW.fnListToTable    Script Date: 28-07-2004 18:18:06 ******/
GO


CREATE FUNCTION OW.fnListToTable
                    (@list      ntext,
                     @delimiter nchar(1) = N',')
         RETURNS @tbl TABLE (listpos int IDENTITY(1, 1) NOT NULL,
                             value     varchar(4000)) AS

   BEGIN
      DECLARE @pos      int,
              @textpos  int,
              @chunklen smallint,
              @tmpstr   nvarchar(4000),
              @leftover nvarchar(4000),
              @tmpval   nvarchar(4000)
              
      SET @textpos = 1
      SET @leftover = ''
      
      WHILE @textpos <= datalength(@list) / 2
      BEGIN
         SET @chunklen = 4000 - datalength(@leftover) / 2
         SET @tmpstr = @leftover + substring(@list, @textpos, @chunklen)
        
         SET @textpos = @textpos + @chunklen

         SET @pos = charindex(@delimiter, @tmpstr)

         WHILE @pos > 0
         BEGIN
            SET @tmpval = ltrim(rtrim(left(@tmpstr, @pos - 1)))
            INSERT @tbl (value) VALUES(@tmpval)
            SET @tmpstr = substring(@tmpstr, @pos + 1, len(@tmpstr))
            SET @pos = charindex(@delimiter, @tmpstr)
         END

         SET @leftover = @tmpstr
      END

      INSERT @tbl(value) VALUES (ltrim(rtrim(@leftover)))
   RETURN
   END

GO

/****** Object:  User Defined Function OW.fnUsersLoginToTable    Script Date: 28-07-2004 18:18:06 ******/
GO

CREATE FUNCTION OW.fnUsersLoginToTable(@list text)
      RETURNS @tbl TABLE (listpos int NOT NULL, value  varchar(4000)  NOT NULL) 
      AS
   BEGIN

	declare @id int
	declare @value varchar(4000)

	declare userLogin_cursor cursor 
	for select  *  from OW.fnListToTable(@list, ',')

	open userLogin_cursor
	fetch next from userLogin_cursor into @id, @value

	while @@fetch_status = 0
	begin
		insert @tbl select userID, userLogin from OW.tblUser where OW.tblUser.userLogin like @value
		fetch next from userLogin_cursor into @id, @value
	end	

	close userLogin_cursor
	deallocate userLogin_cursor

      RETURN
   END

GO


/****** Object:  View OW.GetAllActiveAlarms    Script Date: 28-07-2004 18:18:00 ******/
GO

CREATE VIEW OW.GetAllActiveAlarms
AS
SELECT OW.tblUser.userDesc, OW.tblOWWorkFlowDistribution.Subject, 
    OW.tblAlarm.AlarmDateTime
FROM OW.tblAlarmAssociation INNER JOIN
    OW.tblAlarm ON 
    OW.tblAlarmAssociation.AlarmID = OW.tblAlarm.AlarmId
     INNER JOIN
    OW.tblUser INNER JOIN
    OW.tblOWWorkFlowDistribution ON 
    OW.tblUser.userID = OW.tblOWWorkFlowDistribution.FromAddrID ON 
    OW.tblAlarmAssociation.ObjectRowID = OW.tblOWWorkFlowDistribution.OWWorkFlowDistributionID
WHERE (OW.tblAlarmAssociation.Activated = 0)

GO

/****** Object:  Stored Procedure OW.sp_deleteTemp    Script Date: 12/4/2003 15:36:45 ******/

CREATE PROCEDURE OW.sp_deleteTemp
AS
Delete from tblDistribTemp Where datediff(day,distribDate,getdate()) > 3 





GO





/****** Object:  Stored Procedure OW.usp_AddDistribution    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddDistribution    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddDistribution
    (
        @RegID numeric = Null,
        @UserID numeric,
        @DistribDate datetime = Null,
        @DistribObs nvarchar(250) = Null,
        @Tipo numeric = Null,
        @RadioVia varchar(2) = Null,
        @ChkFile bit = Null,
        @DistribTypeID numeric = Null,
        @State tinyint = Null
    )
AS
    SET NOCOUNT ON
    SET DATEFORMAT dmy

    IF @DistribDate IS NULL
        SET @DistribDate = GETDATE()

    INSERT INTO OW.tblRegistryDistribution ([RegID], [UserID], [DistribDate], [DistribObs], [Tipo], [RadioVia], [ChkFile], [DistribTypeID], [txtEntidadeID], [State], [ConnectID], [Dispatch])
    VALUES (@RegID, @UserID, @DistribDate, @DistribObs, @Tipo, @RadioVia, @ChkFile, @DistribTypeID, NULL, @State, NULL, NULL)
    IF @@ERROR = 0
        SELECT @@IDENTITY AS DistribID
    ELSE
        SELECT 0 AS DistribID





GO



/****** Object:  Stored Procedure OW.usp_AddEntityToDistribution    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddEntityToDistribution    Script Date: 12/4/2003 15:36:45 ******/
CREATE PROCEDURE OW.usp_AddEntityToDistribution
    (
        @DistribID numeric,
        @RegID numeric,
        @EntID numeric
    )
AS

	PRINT 'OW.usp_AddEntityToDistribution'
	PRINT         @DistribID
	PRINT         @RegID 
	PRINT         @EntID 
	

    SET NOCOUNT ON
    INSERT INTO OW.tblDistributionEntities ([DistribID], [RegID], [EntID], [Tmp])
    VALUES (@DistribID, @RegID, @EntID, 0)
    IF @@ERROR = 0
        SELECT 1 AS DistribEntID
    ELSE
        SELECT 0 AS DistribEntID





GO



/****** Object:  Stored Procedure OW.usp_AddEntityToRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddEntityToRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddEntityToRegistry
    (
        @RegID numeric,
        @EntID numeric,
        @Type char(1) = '0'
    )
AS

    /*	OLD VERSION 
    *
    *	SET NOCOUNT ON
    *
    * INSERT INTO OW.tblRegistryEntities ([RegID], [EntID], [Type])
    * VALUES (@RegID, @EntID, @Type) */

  SET NOCOUNT ON
INSERT INTO OW.tblRegistryEntities ([RegID], [Type], [EntID])
Select @RegID, @Type, EntID from 
	(
	SELECT ObjectID as EntID FROM OW.tblGroupsEntities where EntID = @ENTID
		UNION
	SELECT EntID FROM OW.tblEntities where EntID = @ENTID and TYPE<>2 -- /*type<>2 because type 2 is Groups*/
	) as tEntID 
		/* WHERE EXISTS (SELECT ENTiD FROM OW.tblRegistryEntities WHERE NOT EXISTS
		(	SELECT ObjectID as EntID FROM OW.tblGroupsEntities where EntID = @ENTID
				UNION
			SELECT EntID FROM OW.tblEntities where EntID = @ENTID and TYPE=@Type
		) AND REGID = @REGID) */

/*    IF @@ERROR = 0 */
        SELECT @@IDENTITY AS RegEntID
/*    ELSE 
        SELECT 0 AS RegEntID */


GO


/****** Object:  Stored Procedure OW.usp_AddFieldToRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddFieldToRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddFieldToRegistry
    (
        @RegID numeric,
        @BookID numeric,
        @FormFieldKey numeric,
        @DynFldTypeID numeric,
        @Value varchar(4000) 
    )
AS

    SET NOCOUNT ON
    SET DATEFORMAT dmy

    IF @DynFldTypeID = 1 AND LEN(@Value) > 500
        BEGIN
            INSERT INTO OW.tblTexts ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, @Value)
        END
    IF @DynFldTypeID = 1 AND LEN(@Value) <= 500
        BEGIN
            INSERT INTO OW.tblStrings ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(varchar(500), @Value))
        END
    IF @DynFldTypeID = 2
        BEGIN
            INSERT INTO OW.tblIntegers ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(decimal(38,0), @Value))
        END
    IF @DynFldTypeID = 3
        BEGIN
            INSERT INTO OW.tblFloats ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(float, @Value))
        END
    IF @DynFldTypeID = 4
        BEGIN
            INSERT INTO OW.tblDates ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(smalldatetime, @Value))
        END
    IF @DynFldTypeID = 5
        BEGIN
            INSERT INTO OW.tblDateTimes ([RegID], [BookID], [FormFieldKey], [Value])
            VALUES (@RegID, @BookID, @FormFieldKey, CONVERT(smalldatetime, @Value))
        END
    IF @@ERROR = 0
        SELECT 1 AS RegFieldID
    ELSE
        SELECT 0 AS RegFieldID





GO



/****** Object:  Stored Procedure OW.usp_AddKeywordToRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddKeywordToRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddKeywordToRegistry
    (
        @RegID numeric,
        @KeyID numeric
    )
AS

    SET NOCOUNT ON
    INSERT INTO OW.tblRegistryKeywords ([RegID], [KeyID])
    VALUES (@RegID, @KeyID)
    IF @@ERROR = 0
        SELECT 1 AS RegKeyID
    ELSE
        SELECT 0 AS RegKeyID





GO


/****** Object:  Stored Procedure OW.usp_AddListOptionsValues    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_AddListOptionsValues
(
		@Description varchar(100) = NULL
)

AS
	Insert InTo OW.tblListOptionsValues values (@Description)
	
	
	RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_AddRegistry    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_AddRegistry    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_AddRegistry
    (
        @DocTypeID numeric = Null,
        @BookID numeric,
        @Year numeric = Null,
        @Number numeric = Null,
        @Date datetime = Null,
        @OriginRef varchar(30) = Null,
        @OriginDate datetime = Null,
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
        @DateModify datetime = Null,
        @Historic bit = 0,
        @Field1 float = Null,
        @Field2 nvarchar(50) = Null	
    )
AS
    SET NOCOUNT ON
    SET DATEFORMAT dmy

    DECLARE @automatic bit
    DECLARE @NextNumber numeric

    IF @Date IS NULL
        SET @Date = GETDATE()

    IF @Year = 0 OR @Year IS NULL
        SET @Year = YEAR(GETDATE())

    SELECT @automatic = automatic FROM OW.tblBooks
    WHERE BookID = @BookID
/*
    -- Verifica livros sem acessos definidos
    AND(BookID NOT IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                       WHERE ObjectTypeID=2 AND ObjectParentID=1)
    -- Verifica se o utilizador tem acesso
    OR BookID IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                  WHERE userID = @UserID
                  AND ObjectType=1
                  AND ObjectTypeID=2
                  AND ObjectParentID=1
                  AND AccessType > 3)
    )
*/
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





GO




/****** Object:  Stored Procedure OW.usp_CheckUserBookAccess    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_CheckUserBookAccess    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_CheckUserBookAccess
    (
        @BookID numeric,
        @UserID numeric
    )
AS

    SET NOCOUNT ON
    SELECT BookID FROM OW.tblBooks
    WHERE BookID = @BookID
    -- Verifica livros sem acessos definidos
    AND(BookID NOT IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                       WHERE ObjectTypeID = 2 AND ObjectParentID = 1)
        -- Verifica se o utilizador tem acesso
        OR BookID IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                      WHERE (UserID = @UserID
                             AND ObjectType = 1
                             AND ObjectTypeID = 2
                             AND ObjectParentID = 1
                             AND AccessType > 3)
                      -- Verifica se o grupo tem acesso
                      OR (UserID IN (SELECT DISTINCT GroupID FROM OW.tblGroupsUsers WHERE UserID = @UserID)
                          AND ObjectType = 2
                          AND ObjectTypeID = 2
                          AND ObjectParentID = 1)
                      AND (BookID NOT IN (SELECT DISTINCT ObjectID FROM OW.tblAccess
                                          WHERE ObjectTypeID = 2
                                          AND ObjectParentID = 1 
                                          AND ObjectType = 1
                                          AND userid= @UserID))
                      AND AccessType > 3))





GO


/****** Object:  Stored Procedure OW.usp_CreateClassification    Script Date: 28-07-2004 18:18:01 ******/
GO







/****** Object:  Stored Procedure OW.usp_CreateClassification    Script Date: 12/4/2003 15:36:45 ******/


CREATE    PROCEDURE OW.usp_CreateClassification
	(
		@Level1 VARCHAR(50),
		@Level2 VARCHAR(50),
		@Level3 VARCHAR(50),
		@Level4 VARCHAR(50),
		@Level5 VARCHAR(50),
		@Level1Desig VARCHAR(100),
		@Level2Desig VARCHAR(100),
		@Level3Desig VARCHAR(100),
		@Level4Desig VARCHAR(100),
		@Level5Desig VARCHAR(100),
		@Tipo VARCHAR(50),
		@Books VARCHAR(4000)
	)
AS
	DECLARE @currLevel NUMERIC
	

	DECLARE @BookID VARCHAR(10), 
			@Pos NUMERIC,
			@ClassID NUMERIC

	BEGIN TRANSACTION
			
	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1) = 0
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Tipo)
		VALUES (@Level1, @Level1Desig, @Tipo)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
		
		--PRINT 'Tipo = ' + @Tipo
		--apagar primeiro os livros associados e colocar os novos...
		IF @Tipo = 'Private'
		BEGIN
			SET @Books = LTRIM(RTRIM(@Books))+ ','
			SET @Pos = CHARINDEX(',', @Books, 1)
			
			SELECT @ClassID = @@IDENTITY
			
			IF REPLACE(@Books, ',', '') <> ''
			BEGIN
				WHILE @Pos > 0
				BEGIN
					SET @BookID = LTRIM(RTRIM(LEFT(@Books, @Pos - 1)))
					IF @Books <> ''
					BEGIN
						--Print BookID
						INSERT INTO OW.tblClassificationBooks (ClassID, BookID)
						VALUES (@ClassID, CAST(@BookID as NUMERIC))

						IF @@ERROR <> 0
						BEGIN
							ROLLBACK TRANSACTION
							RETURN @@ERROR
						END

					END
					SET @Books = RIGHT(@Books, LEN(@Books) - @Pos)
					SET @Pos = CHARINDEX(',', @Books, 1)
				END
			END	
		END
	END

	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2) = 0 AND @Level2 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END

	END
		
	
	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2 AND Level3 = @Level3) = 0 AND @Level3 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig, Level3, Level3Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig, @Level3, @Level3Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2 AND Level3 = @Level3 AND Level4 = @Level4) = 0 AND @Level4 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig, Level3, Level3Desig, Level4, Level4Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig, @Level3, @Level3Desig, @Level4, @Level4Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END

	IF (SELECT COUNT(*) FROM OW.tblClassification 
		WHERE Level1 = @Level1 AND Level2 = @Level2 AND Level3 = @Level3 AND Level4 = @Level4 AND Level5 = @Level5) = 0 AND @Level5 IS NOT NULL
	BEGIN 
		INSERT INTO OW.tblClassification (Level1, Level1Desig, Level2, Level2Desig, Level3, Level3Desig, Level4, Level4Desig, Level5, Level5Desig)
		VALUES (@Level1, @Level1Desig, @Level2, @Level2Desig, @Level3, @Level3Desig, @Level4, @Level4Desig, @Level5, @Level5Desig)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END 

	COMMIT TRANSACTION
		
	RETURN @@ERROR





GO





/****** Object:  Stored Procedure OW.usp_DelListOptionsValues    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_DelListOptionsValues 
	(
		@ID numeric
	)
AS
	
	DELETE FROM tblListOptionsValues WHERE ListID = @ID
	
	RETURN @@ERROR	



GO



/****** Object:  Stored Procedure OW.usp_DeleteAutomaticDistribution    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteAutomaticDistribution    Script Date: 12/4/2003 15:36:45 ******/
CREATE PROCEDURE OW.usp_DeleteAutomaticDistribution
	(
		@tmpID numeric
	)
AS
SET XACT_ABORT ON

BEGIN TRANSACTION
	DELETE FROM OW.tblDistributionAutomaticEntities WHERE AutoDistribID = @tmpID
	DELETE FROM OW.tblDistributionAutomatic WHERE AutoDistribID = @tmpID
COMMIT TRANSACTION

RETURN @@ERROR




GO
/*********************** OW.usp_GetDistributionAutomaticEntities ******************************/
GO
CREATE PROCEDURE OW.usp_GetDistributionAutomaticEntities
	(
		@DistribID numeric
	)

AS
	
SELECT 
	b.entid, 
	RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) as name, 
	c.entid as contactid
FROM 
	OW.tblDistributionAutomatic a
	LEFT JOIN OW.tblDistributionAutomaticEntities b ON a.[AutoDistribid]=b.AutoDistribId
	LEFT JOIN OW.tblEntities c ON (b.EntID = c.EntID)
WHERE 
	a.[AutoDistribID]=@DistribID
	
	
RETURN @@ERROR
GO


/****** Object:  Stored Procedure OW.usp_DeleteBook    Script Date: 7/5/2004 15:36:46 ******/


CREATE PROCEDURE OW.usp_DeleteBook
	(
		@bookid numeric
	)
AS

	SET XACT_ABORT ON

	BEGIN TRANSACTION

	DELETE FROM tblFieldsBooksPosition WHERE BookID = @BookID

	DELETE FROM tblClassificationBooks WHERE BookID = @BookID
 
	DELETE FROM tblBooksDocumentType WHERE BookID = @BookID

	DELETE FROM tblBooksKeyword WHERE BookID =  @BookID

	DELETE FROM tblFormfieldsBooks WHERE BookID =  @BookID

	DELETE FROM tblFieldsBookConfig WHERE BookID =  @BookID

	DELETE FROM tblBooks WHERE BookID =  @BookID
	
	COMMIT TRANSACTION
	RETURN 0


GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDispatch    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDispatch    Script Date: 15/4/2004 15:36:46 ******/

/*** DELETES A DOCUMENT TYPE  FROM A BOOK***/

CREATE PROCEDURE OW.usp_DeleteBookDispatch
	(
		@bookid numeric
	)
AS
	DELETE 
	FROM
		OW.tblDispatchBook
	WHERE
		bookid=@bookid
	
	
RETURN @@ERROR	
	


GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDocumentType    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteBookDocumentType    Script Date: 15/4/2004 15:36:46 ******/

/*** DELETES THE  DOCUMENT TYPES OF A BOOK***/

CREATE PROCEDURE OW.usp_DeleteBookDocumentType
	(
		@bookid numeric
	)
AS
	DELETE 
	FROM
		OW.tblBooksDocumentType
	WHERE
		bookid=@bookid
	
	
RETURN @@ERROR	
	


GO



/****** Object:  Stored Procedure OW.usp_DeleteBookKeyword    Script Date: 28-07-2004 18:18:01 ******/
GO


/****** Object:  Stored Procedure OW.usp_DeleteBookKeyword    Script Date: 6/4/2004 15:36:46 ******/

/*** DELETES A KEYWORD FROM A BOOK***/

CREATE PROCEDURE OW.usp_DeleteBookKeyword
	(
		@bookid numeric
	)
AS
	DELETE 
	FROM
		OW.tblBooksKeyword
	WHERE
		bookid=@bookid
	
	
RETURN @@ERROR	
	


GO



/****** Object:  Stored Procedure OW.usp_DeleteClassification    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteClassification    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_DeleteClassification
(
	@ClassID Numeric
)
AS
	DECLARE @Level1 varchar(50),
		    @Level2 varchar(50),
		    @Level3 varchar(50),
		    @Level4 varchar(50),
		    @Level5 varchar(50)
	
	DECLARE @currLevel numeric
	
	SELECT  @Level1 = Level1, @Level2 = Level2, @Level3 = Level3, @Level4 = Level4, @Level5 = Level5
		FROM OW.tblClassification 
		WHERE ClassID = @ClassID
	
	IF @Level2 IS NULL --level1
	BEGIN
		SET @currLevel = 1
	END
	ELSE
	BEGIN
		IF @Level3 IS NULL --level2
		BEGIN
			SET @currLevel = 2
		END
		ELSE
		BEGIN
			IF @Level4 IS NULL --level3
			BEGIN
				SET @currLevel = 3
			END
			ELSE
			BEGIN
				IF @Level5 IS NULL --level4
				BEGIN
					SET @currLevel = 4
				END
				ELSE --level5
				BEGIN
					SET @currLevel = 5	
				END
			END
		END
	END

	BEGIN TRANSACTION
	
	IF @currLevel = 1
	BEGIN
		DELETE FROM OW.tblClassificationBooks 
		WHERE ClassID = @ClassID
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
		
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 2
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 3
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	
		AND Level3 = @Level3

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 4
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	
		AND Level3 = @Level3	
		AND Level4 = @Level4	

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @currLevel = 5
	BEGIN
		DELETE FROM OW.tblClassification
		WHERE Level1 = @Level1
		AND Level2 = @Level2	
		AND Level3 = @Level3	
		AND Level4 = @Level4	
		AND Level5 = @Level5

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END
	END
	
	IF @@ERROR = 0
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION
		
	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_DeleteDispatch    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDispatch    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_DeleteDispatch
	(
		@dispatchID numeric
	)
AS
	DELETE FROM OW.tblDispatch WHERE dispatchID = @dispatchID

	IF (@@ERROR <> 0)
		RETURN 1
	ELSE 
	RETURN 0



GO



/****** Object:  Stored Procedure OW.usp_DeleteDispatchFromBook    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDispatchFromBook    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_DeleteDispatchFromBook
	(
		@dispatchid numeric,	
		@bookid numeric
	)

AS

DELETE

FROM
	OW.tblDispatchBook
WHERE
	OW.tblDispatchBook.dispatchid = @dispatchid
AND	
	OW.tblDispatchBook.bookid = @bookid


IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0



GO



/****** Object:  Stored Procedure OW.usp_DeleteDistributionTemp    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDistributionTemp    Script Date: 12/4/2003 15:36:45 ******/



CREATE PROCEDURE OW.usp_DeleteDistributionTemp
	(
		@tmpID numeric
	)
AS
	DELETE FROM OW.tblDistribTemp WHERE tmpID = @tmpID

	IF (@@ERROR <> 0)
		RETURN 1
	ELSE 
	RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_DeleteDistributionTempEntity    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteDistributionTempEntity    Script Date: 12/4/2003 15:36:45 ******/


CREATE PROCEDURE OW.usp_DeleteDistributionTempEntity
	(
		@tmpid NUMERIC,
		@entid NUMERIC
	)
AS
	DELETE 
	
	FROM OW.tblDistributionEntities

	WHERE (distribID = @tmpID) AND (entID = @entid) AND (tmp=1)

	RETURN @@Error



GO



/********************************* usp_GetBookFields ************************************/
GO
CREATE  PROCEDURE OW.usp_GetBookFields
    (
        @bookID numeric
    )
AS

    SELECT ff.formfieldKey, ff.fieldname, ff.DynFldTypeID 
    FROM OW.tblFormFields ff LEFT OUTER JOIN OW.tblFieldsBookConfig fbc 
	ON(ff.formfieldKey = fbc.formfieldKey)
    WHERE ff.global=1 OR (ff.visible=0) OR fbc.bookid = @bookID

    RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_DeleteDocumentType   Script Date: 12/4/2004 15:36:46 ******/
GO
/*** DELETES A DOCUMENT TYPE ***/

CREATE PROCEDURE OW.usp_DeleteDocumentType
	(
		@doctypeID numeric	
	)

AS
		BEGIN TRANSACTION
		
		/*** DELETES THE ASSOCIATION WITH ANY BOOK ***/
		DELETE
			OW.tblBooksDocumentType
		WHERE 
			OW.tblBooksDocumentType.documenttypeid = @doctypeid
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			
		
		/*** DELETES THE KEYWORD ***/			
		DELETE 
			OW.tblDocumentType
		WHERE 
			OW.tblDocumentType.doctypeid = @doctypeid
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			

		IF @@ERROR = 0
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION
				
RETURN @@ERROR	

GO
/****** Object:  Stored Procedure OW.usp_DeleteKeyword    Script Date: 6/4/2004 15:36:46 ******/

/*** DELETES A KEYWORD ***/

CREATE PROCEDURE OW.usp_DeleteKeyword
	(
		@keyID numeric	
	)

AS
		BEGIN TRANSACTION
		
		/*** DELETES THE ASSOCIATION WITH ANY BOOK ***/
		DELETE
			OW.tblBooksKeyword
		WHERE 
			OW.tblBooksKeyword.keywordID = @keyID 
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			
		
		/*** DELETES THE KEYWORD ***/			
		DELETE 
			OW.tblKeywords
		WHERE 
			OW.tblKeywords.keyID = @keyID 
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			

		IF @@ERROR = 0
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION
				
RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_DeleteList    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteList    Script Date: 12/4/2003 15:36:46 ******/


CREATE PROCEDURE OW.usp_DeleteList
	(
		@ListID numeric
	)
AS
	DELETE OW.tblEntityList
	WHERE ListID=@ListID
	RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_DeletePostalCode    Script Date: 28-07-2004 18:18:01 ******/
GO



CREATE PROCEDURE OW.usp_DeletePostalCode
	(
		@PostalCodeID numeric
	)
AS
	SET NOCOUNT ON 
	DELETE OW.tblPostalCode 
	WHERE PostalCodeID=@PostalCodeID
	RETURN @@ERROR


GO

/****** Object:  Stored Procedure OW.usp_DeleteProfile   Script Date: 22/4/2004 15:36:46 ******/

/*** DELETES A PROFILE ***/

CREATE PROCEDURE OW.usp_DeleteProfile
	(
		@profileid numeric	
	)

AS
		/*** DELETES THE KEYWORD ***/			
		DELETE 
			OW.tblProfiles
		WHERE 
			OW.tblProfiles.profileid = @profileid
		
		/*** CHECKS FOR ERROR ***/
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		END			
				
RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_DeleteUserPersistence    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteUserPersistence    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_DeleteUserPersistence

	(
		@UserID numeric,
		@formFieldKEY numeric
	)
AS
	DELETE FROM OW.tblUserPersistence
	WHERE UserID=@UserID AND formFieldKEY=@formFieldKEY
			
	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_DeleteUserPersistenceAll    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_DeleteUserPersistenceAll    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_DeleteUserPersistenceAll

	(@UserID numeric)
AS
	DELETE FROM OW.tblUserPersistence
	WHERE UserID=@UserID
			
	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_GetAllClassification    Script Date: 28-07-2004 18:18:01 ******/
GO



/****** Object:  Stored Procedure OW.usp_GetAllClassification    Script Date: 12/4/2003 15:36:46 ******/
CREATE  PROCEDURE OW.usp_GetAllClassification
(
	@ClassCode1 varchar(50),
	@ClassCode2 varchar(50),
	@ClassCode3 varchar(50),
	@ClassCode4 varchar(50),
	@ClassCode5 varchar(50),
	@ClassDesc1 varchar(100),
	@ClassDesc2 varchar(100),
	@ClassDesc3 varchar(100),
	@ClassDesc4 varchar(100),
	@ClassDesc5 varchar(100),
	@SearchLevel numeric	
)

AS

	DECLARE @Select NVARCHAR(1500)
	DECLARE @Where NVARCHAR(1000)
	DECLARE @From NVARCHAR(500)
	DECLARE @strSQL NVARCHAR(3000)
	DECLARE @OrderBy NVARCHAR(200)

	
	SET @Select = ' SELECT ClassID, Tipo=CASE WHEN Tipo IS NULL THEN '''' ELSE Tipo END, '
	SET @Where = ' WHERE '
	SET @From = ''
	

	--first level (always exist)
	SET @Select = @Select + ' ''Level1'' = CASE WHEN Level1 IS NULL THEN ''-'' WHEN LTRIM(Level1) = '''' THEN ''-'' ELSE Level1 END, ''level1Desig'' = CASE WHEN level1Desig IS NULL THEN ''-'' WHEN LTRIM(level1Desig)='''' THEN ''-'' ELSE level1Desig END, '
	IF @ClassDesc1 = '' AND @ClassCode1 <> ''
	BEGIN
		SET @Where = @Where + ' Level1 LIKE ''' + @ClassCode1 + ''' AND '
	END
	ELSE IF @ClassDesc1 <> ''
	BEGIN
		SET @Where = @Where + ' Level1Desig LIKE ''' +  @ClassDesc1 + ''' AND '
	END
	SET @OrderBy = ' ORDER BY Level1, Level1Desig '
	
	--second level
	IF @SearchLevel >= 2
	BEGIN
		SET @Select = @Select + ' ''Level2'' = CASE WHEN Level2 IS NULL THEN ''-'' WHEN LTRIM(Level2) = '''' THEN ''-'' ELSE Level2 END, ''level2Desig'' = CASE WHEN level2Desig IS NULL THEN ''-'' WHEN LTRIM(level2Desig)='''' THEN ''-'' ELSE level2Desig END, '
		--SET @Select = @Select + ' Level2 , level2Desig, '
		IF @ClassDesc2 = '' AND @ClassCode2 <> ''
		BEGIN
			SET @Where = @Where + ' Level2 LIKE ''' + @ClassCode2 + ''' AND '
		END
		ELSE IF @ClassDesc2 <> ''
		BEGIN
			SET @Where = @Where + ' Level2Desig LIKE ''' +  @ClassDesc2 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level2, Level2Desig '
	END	
	
	--third level
	IF @SearchLevel >= 3
	BEGIN
		SET @Select = @Select + ' ''Level3'' = CASE WHEN Level3 IS NULL THEN ''-'' WHEN LTRIM(Level3) = '''' THEN ''-'' ELSE Level3 END, ''level3Desig'' = CASE WHEN level3Desig IS NULL THEN ''-'' WHEN LTRIM(level3Desig)='''' THEN ''-'' ELSE level3Desig END, '
		--SET @Select = @Select + ' Level3 , level3Desig, '
		IF @ClassDesc3 = '' AND @ClassCode3 <> ''
		BEGIN
			SET @Where = @Where + ' Level3 LIKE ''' + @ClassCode3 + ''' AND '
		END
		ELSE IF @ClassDesc3 <> ''
		BEGIN
			SET @Where = @Where + ' Level3Desig LIKE ''' +  @ClassDesc3 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level3, Level3Desig '
	END	
	
	--fourth level
	IF @SearchLevel >= 4
	BEGIN
		SET @Select = @Select + ' ''Level4'' = CASE WHEN Level4 IS NULL THEN ''-'' WHEN LTRIM(Level4) = '''' THEN ''-'' ELSE Level4 END, ''level4Desig'' = CASE WHEN level4Desig IS NULL THEN ''-'' WHEN LTRIM(level4Desig)='''' THEN ''-'' ELSE level4Desig END, '
		--SET @Select = @Select + ' Level4 , level4Desig, '
		IF @ClassDesc4 = '' AND @ClassCode4 <> ''
		BEGIN
			SET @Where = @Where + ' Level4 LIKE ''' + @ClassCode4 + ''' AND '
		END
		ELSE IF @ClassDesc4 <> ''
		BEGIN
			SET @Where = @Where + ' Level4Desig LIKE ''' + @ClassDesc4 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level4, Level4Desig '
	END	
	
	--fourth level
	IF @SearchLevel = 5
	BEGIN
		SET @Select = @Select + ' ''Level5'' = CASE WHEN Level5 IS NULL THEN ''-'' WHEN LTRIM(Level5) = '''' THEN ''-'' ELSE Level5 END, ''level5Desig'' = CASE WHEN level5Desig IS NULL THEN ''-'' WHEN LTRIM(level5Desig)='''' THEN ''-'' ELSE level5Desig END, '
		--SET @Select = @Select + ' Level5 , level5Desig, '
		IF @ClassDesc5 = '' AND @ClassCode5 <> ''
		BEGIN
			SET @Where = @Where + ' Level5 LIKE ''' + @ClassCode5 + ''' AND '
		END
		ELSE IF @ClassDesc5 <> ''
		BEGIN
			SET @Where = @Where + ' Level5Desig LIKE ''' + @ClassDesc5 + ''' AND '
		END
		SET @OrderBy = ' ORDER BY Level5, Level5Desig '
	END	
	
	--retirar a virgula e o espaço e adicionar um espaço
	SET @Select = SUBSTRING(@Select, 1, LEN(@SELECT) - 1) + ' '
			
	IF @SearchLevel = 1
		SET @Where = @Where + ' Level2 IS NULL '
	ELSE IF @SearchLevel = 2
		SET @Where = @Where + ' Level3 IS NULL AND Level2 IS NOT NULL '
	ELSE IF @SearchLevel = 3
		SET @Where = @Where + ' Level4 IS NULL AND Level3 IS NOT NULL '
	ELSE IF @SearchLevel = 4
		SET @Where = @Where + ' Level5 IS NULL AND Level4 IS NOT NULL '
	ELSE IF @SearchLevel = 5
		SET @Where = @Where + ' Level5 IS NOT NULL '
	

	--SET @OrderBy = ' ORDER BY Level1, Level2, Level3, Level4, Level5 '
	-- PSilva Fetter --

	--define the from tables
	SET @From  = ' FROM OW.tblClassification '
	
	SET @strSQL = @Select + @From + @Where + @OrderBy
	
	--print @strSQL
	
	exec sp_executeSQL @strSQL
	
	Return @@ERROR


GO


/****** Object:  Stored Procedure OW.usp_GetBook    Script Date: 28-07-2004 18:18:01 ******/
GO



CREATE PROCEDURE OW.usp_GetBook
	(
		@id numeric
	)
	AS
	
	SELECT
		*
	FROM
		OW.tblBooks 
	WHERE 
		OW.tblBooks.bookid=@id
	
	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0


GO



/****** Object:  Stored Procedure OW.usp_GetBookDispatch    Script Date: 28-07-2004 18:18:01 ******/
GO





/****** Object:  Stored Procedure OW.usp_GetBookDispatch    Script Date: 19/4/2004 15:36:46 ******/

/*** GETS A KEYWORD FROM A BOOK***/

CREATE   PROCEDURE OW.usp_GetBookDispatch
	(
		@bookID  numeric
		--,@mode numeric    /* 0 - DISPATCHES IN THE BOOK INCLUDING GLOBAL ONES, 1 - DOCUMENT TYPES NOT IN THE BOOK  */
	)
AS

	SELECT     
		OW.tblDispatch.*, OW.tblDispatchBook.bookID
	FROM    
		OW.tblDispatch LEFT OUTER JOIN
		OW.tblDispatchBook ON OW.tblDispatch.dispatchid = OW.tblDispatchBook.dispatchID 
		AND OW.tblDispatchBook.bookID = @bookID 
	Where 
		Global = 0

	/*if (@mode=0)
		-- GETS DISPATCHES IN THE BOOK INCLUDING GLOBAL  DISPATCHES 
		BEGIN
			SELECT 
				OW.tblDispatch.*
			FROM
				OW.tblDispatch
			WHERE 
				EXISTS (SELECT 1 FROM  OW.tblDispatchBook tbk WHERE tbk.DispatchId = OW.tblDispatch.DispatchID AND	tbk.bookID = @bookID ) 
				OR global=1
		END

	if (@mode=1)
		-- GETS DISPATCHES NOT IN THE BOOK. DOES NOT INCLUDE GLOBAL  DISPATCHES 
		BEGIN
			SELECT 
				OW.tblDispatch.*
			FROM
				OW.tblDispatch
			WHERE 
				NOT EXISTS (SELECT 1 FROM  OW.tblDispatchBook tbk WHERE tbk.DispatchId = OW.tblDispatch.DispatchID AND	tbk.bookID = @bookID ) 
			AND global=0
		END*/

Return @@ERROR
GO
/****** Object:  Stored Procedure OW.usp_GetDocumentTypes    Script Date: 6/4/2004 15:36:46 ******/
CREATE PROCEDURE OW.usp_GetBookDocumentTypes
	(
		@bookID numeric,
		@Global bit = null
	)
AS
IF (@Global is null)
-- ALL DOCUMENTE TYPES
BEGIN
	SELECT  doctypeID, 
		abreviation, 
		designation, 
		[Global]
	FROM  OW.tblDocumentType
	WHERE [Global]=1 OR
	EXISTS (SELECT 1 
		FROM OW.tblBooksDocumentType  tbd
		WHERE tbd.documenttypeID= OW.tblDocumentType.doctypeID AND bookid=@bookID) 
	ORDER BY OW.tblDocumentType.designation
END
ELSE
BEGIN
-- BY PARAM GLOBAL
	SELECT  OW.tblDocumentType.doctypeID, 
		OW.tblDocumentType.abreviation, 
		OW.tblDocumentType.designation, 
        	OW.tblDocumentType.[Global], 
		OW.tblBooksDocumentType.bookID
	FROM    OW.tblDocumentType LEFT OUTER JOIN
        	OW.tblBooksDocumentType ON OW.tblDocumentType.doctypeID = OW.tblBooksDocumentType.documenttypeID AND 
	        OW.tblBooksDocumentType.bookID = @bookID
	WHERE OW.tblDocumentType.[Global] = @Global
	ORDER BY OW.tblDocumentType.designation
END
Return @@ERROR
GO	





GO



/****** Object:  Stored Procedure OW.usp_GetBookFieldName    Script Date: 28-07-2004 18:18:01 ******/
GO




/****** Object:  Stored Procedure OW.usp_GetBookFieldName    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_GetBookFieldName
(
    @formFieldKEY as numeric(18,0)
)
AS
    SELECT fieldName FROM OW.tblFormFields 
    WHERE formFieldKEY = @formFieldKEY

    RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetBookHierarchicalById    Script Date: 28-07-2004 18:18:01 ******/
GO


CREATE PROCEDURE OW.usp_GetBookHierarchicalById

	@bookID numeric

AS

select hierarchical from OW.tblBooks where bookID = @bookID


GO

/****** Object:  Stored Procedure OW.usp_GetBookKeywords    Script Date: 28-07-2004 18:18:02 ******/
GO

/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 6/4/2004 15:36:46 ******/
CREATE PROCEDURE OW.usp_GetBookKeywords
	(
		@bookID numeric,
		@Global bit=null
	)
AS
IF (@Global is null)
BEGIN
	SELECT keyID,
		keyDescription,
		[Global]
	FROM OW.tblKeywords 
	WHERE [Global]=1 OR
		EXISTS (SELECT 1 
				FROM OW.tblBooksKeyword tbk
				WHERE tbk.keywordID = OW.tblKeywords.keyID AND bookid=@bookID)		
	ORDER BY keyDescription
END
ELSE
BEGIN
	SELECT     
		OW.tblBooksKeyword.bookID, 
		OW.tblKeywords.keyID, 
		OW.tblKeywords.keyDescription, 
		OW.tblKeywords.[Global]
	FROM    
		OW.tblKeywords LEFT OUTER JOIN
			OW.tblBooksKeyword ON OW.tblKeywords.keyID = OW.tblBooksKeyword.keywordID 
		AND OW.tblBooksKeyword.bookID = @bookID
	WHERE    (OW.tblKeywords.[Global] = @global)
	ORDER BY keyDescription
END
		
Return @@ERROR
GO




/****** Object:  Stored Procedure OW.usp_GetBooks    Script Date: 12/4/2003 15:36:46 ******/

CREATE PROCEDURE OW.usp_GetBooks
( @login VARCHAR(900) = null,
  @role  NUMERIC = null,
  @abreviation VARCHAR(20) = null,
  @designation VARCHAR(100) = null
)
AS

DECLARE @USERID NUMERIC
SET @USERID = (SELECT userID FROM OW.tblUser WHERE userLogin=@login)

IF (@abreviation is not null AND @designation is not null) /*** GETS INFO NO A GIVEN BOOK ***/
	SELECT
		*
	FROM
		OW.tblBooks
	WHERE
		@abreviation = abreviation AND  @designation=designation
	ORDER BY abreviation,designation
	
ELSE
	IF (@login is null or @role is null)
	BEGIN
		SELECT	*
		FROM OW.tblBooks 
		ORDER BY abreviation,designation
	END
	ELSE 
	BEGIN
		SELECT	*
		FROM OW.tblBooks
		WHERE EXISTS 
		(SELECT 1 FROM OW.tblAccess WHERE BookID=ObjectID AND userid = @USERID
					AND ObjectParentID=1
					AND ObjectTypeID=2
					AND AccessType>=@role
					AND ObjectType=1
					OR 
						(BookID IN (SELECT DISTINCT ObjectID 
								FROM OW.tblAccess 
								WHERE ObjectTypeID=2
								AND ObjectParentID=1
								AND ObjectType=2 
								AND userid=@USERID)
						)
					OR BookID NOT IN (SELECT DISTINCT ObjectID 
								FROM  OW.tblAccess 
								WHERE ObjectTypeID=2 
								AND ObjectParentID=1)
		)


			ORDER BY abreviation,designation
	END

Return @@ERROR


GO


/****** Object:  Stored Procedure OW.usp_GetBooksClassifications    Script Date: 12/4/2003 15:36:46 ******/
GO

CREATE PROCEDURE OW.usp_GetBooksClassifications
	(
		@ClassID NUMERIC
	)
AS
	SELECT * , 1 'Exists'
FROM OW.tblBooks
WHERE BOOKID IN 
	(SELECT BOOKID
	FROM OW.tblClassificationBooks 
	WHERE ClassID = @ClassID)
UNION
SELECT * , 0
FROM OW.tblBooks
WHERE BOOKID NOT IN 
	(SELECT BOOKID
	FROM OW.tblClassificationBooks 
	WHERE ClassID = @ClassID)

	RETURN @@Error





GO



/****** Object:  Stored Procedure OW.usp_GetChildClassifications    Script Date: 28-07-2004 18:18:02 ******/
GO




/****** Object:  Stored Procedure OW.usp_GetChildClassifications    Script Date: 12/4/2003 15:36:46 ******/



CREATE PROCEDURE OW.usp_GetChildClassifications
	(
		@ClassID numeric
	)

AS
	DECLARE @Level1 varchar(50)
	DECLARE @Level2 varchar(50)
	DECLARE @Level3 varchar(50)
	DECLARE @Level4 varchar(50)
	DECLARE @Level5 varchar(50)
	DECLARE @CurrentLevel numeric
	
	SELECT @Level1 = Level1,
	@Level2 = Level2,
	@Level3 = Level3,
	@Level4 = Level4,
	@Level5 = Level5
	FROM OW.tblClassification
	WHERE ClassID = @ClassID
	ORDER BY Level1, Level2, Level3, Level4, Level5

	IF (@Level2 IS NULL)
	BEGIN
		SET @CurrentLevel = 1
	END
	ELSE
	BEGIN
		IF (@Level3 IS NULL)
		BEGIN
			SET @CurrentLevel = 2
		END
		ELSE
		BEGIN
			IF (@Level4 IS NULL)
			BEGIN
				SET @CurrentLevel = 3
			END
			ELSE
			BEGIN
				IF (@Level5 IS NULL)
				BEGIN
					SET @CurrentLevel = 4
				END
				ELSE
				BEGIN
					SET @CurrentLevel = 5
				END
			END
		END
	END
	
	IF (@CurrentLevel = 1)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 IS NOT NULL
		AND Level3 IS NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
		
	END
	IF (@CurrentLevel = 2)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 = @Level2 
		AND Level3 IS NOT NULL
		AND Level4 IS NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
	END
	IF (@CurrentLevel = 3)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 = @Level2 
		AND Level3 = @Level3 
		AND Level4 IS NOT NULL
		AND Level5 IS NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
	END
	IF (@CurrentLevel = 4)
	BEGIN
		SELECT * 
		FROM OW.tblClassification 
		WHERE Level1 = @Level1 
		AND Level2 = @Level2 
		AND Level3 = @Level3 
		AND Level4 = @Level4 
		AND Level5 IS NOT NULL
		ORDER BY Level1, Level2, Level3, Level4, Level5
	END
	IF (@CurrentLevel = 5)
	BEGIN
		SELECT * FROM OW.tblClassification Where ClassID = -1 ORDER BY Level1, Level2, Level3, Level4, Level5
	END

	--print cast(@CurrentLevel as varchar)
	RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetCircMailShort    Script Date: 28-07-2004 18:18:02 ******/
GO




CREATE PROCEDURE OW.usp_GetCircMailShort
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	/* SET NOCOUNT ON */
	select distinct subject, OWWorkFlowDistributionID
	from OW.tblOWWorkFlowDistribution wkf 
	order by Subject ASC
	RETURN 




GO




/****** Object:  Stored Procedure dbo.usp_GetCircMailShort    Script Date: 12/4/2003 15:36:46 ******/

CREATE PROCEDURE dbo.usp_GetCircMailShort
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS

/* SET NOCOUNT ON */
select distinct subject, OWWorkFlowDistributionID
from OW.tblOWWorkFlowDistribution wkf 
order by Subject ASC
RETURN 

GO


/****** Object:  Stored Procedure OW.usp_GetClassification    Script Date: 12/4/2003 15:36:46 ******/
GO
CREATE    PROCEDURE OW.usp_GetClassification
 
 (
  @ClassCode1 varchar(50),
  @ClassCode2 varchar(50),
  @ClassCode3 varchar(50),
  @ClassCode4 varchar(50),
  @ClassCode5 varchar(50),
  @ClassDesc1 varchar(100),
  @ClassDesc2 varchar(100),
  @ClassDesc3 varchar(100),
  @ClassDesc4 varchar(100),
  @ClassDesc5 varchar(100),
  @BookID numeric,
  @SearchLevel numeric 
 )
 
AS
 
 DECLARE @Select NVARCHAR(1500)
 DECLARE @Where NVARCHAR(1000)
 DECLARE @From NVARCHAR(500)
 DECLARE @strSQL NVARCHAR(3000)
 DECLARE @OrderBy NVARCHAR(200)
 
 SET @Select = ' SELECT ClassID, Tipo=CASE WHEN Tipo IS NULL THEN '''' ELSE Tipo END, '
 SET @Where = ' WHERE '
 SET @From = ''
 
 
 --first level (always exist)
 SET @Select = @Select + ' ''Level1'' = CASE WHEN Level1 IS NULL THEN ''-'' WHEN LTRIM(Level1) = '''' THEN ''-'' ELSE Level1 END, ''level1Desig'' = CASE WHEN level1Desig IS NULL THEN ''-'' WHEN LTRIM(level1Desig)='''' THEN ''-'' ELSE level1Desig END,'
 
 IF @ClassCode1 <> ''
 BEGIN
  SET @Where = @Where + ' Level1 LIKE ''' + @ClassCode1 + ''' AND '
 END
 
 IF @ClassDesc1 <> ''
 BEGIN
  SET @Where = @Where + ' Level1Desig LIKE ''' +  @ClassDesc1 + ''' AND '
 END
 
 SET @OrderBy = ' ORDER BY Level1, Level1Desig '
 
 --second level
 IF @SearchLevel >= 2
 BEGIN
  SET @Select = @Select + ' ''Level2'' = CASE WHEN Level2 IS NULL THEN ''-'' WHEN LTRIM(Level2) = '''' THEN ''-'' ELSE Level2 END, ''level2Desig'' = CASE WHEN level2Desig IS NULL THEN ''-'' WHEN LTRIM(level2Desig)='''' THEN ''-'' ELSE level2Desig END, '
  --SET @Select = @Select + ' Level2 , level2Desig, '
  IF  @ClassCode2 <> ''
  BEGIN
   SET @Where = @Where + ' Level2 LIKE ''' + @ClassCode2 + ''' AND '
  END
  IF @ClassDesc2 <> ''
  BEGIN
   SET @Where = @Where + ' Level2Desig LIKE ''' +  @ClassDesc2 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level2, Level2Desig '
 END 
 
 --third level
 IF @SearchLevel >= 3
 BEGIN
  SET @Select = @Select + ' ''Level3'' = CASE WHEN Level3 IS NULL THEN ''-'' WHEN LTRIM(Level3) = '''' THEN ''-'' ELSE Level3 END, ''level3Desig'' = CASE WHEN level3Desig IS NULL THEN ''-'' WHEN LTRIM(level3Desig)='''' THEN ''-'' ELSE level3Desig END, '
  --SET @Select = @Select + ' Level3 , level3Desig, '
  IF @ClassCode3 <> ''
  BEGIN
   SET @Where = @Where + ' Level3 LIKE ''' + @ClassCode3 + ''' AND '
  END
  IF @ClassDesc3 <> ''
  BEGIN
   SET @Where = @Where + ' Level3Desig LIKE ''' +  @ClassDesc3 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level3, Level3Desig '
 END 
 
 --fourth level
 IF @SearchLevel >= 4
 BEGIN
  SET @Select = @Select + ' ''Level4'' = CASE WHEN Level4 IS NULL THEN ''-'' WHEN LTRIM(Level4) = '''' THEN ''-'' ELSE Level4 END, ''level4Desig'' = CASE WHEN level4Desig IS NULL THEN ''-'' WHEN LTRIM(level4Desig)='''' THEN ''-'' ELSE level4Desig END, '
  --SET @Select = @Select + ' Level4 , level4Desig, '
  IF @ClassCode4 <> ''
  BEGIN
   SET @Where = @Where + ' Level4 LIKE ''' + @ClassCode4 + ''' AND '
  END
  IF @ClassDesc4 <> ''
  BEGIN
   SET @Where = @Where + ' Level4Desig LIKE ''' + @ClassDesc4 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level4, Level4Desig '
 END 
 
 --fourth level
 IF @SearchLevel = 5
 BEGIN
  SET @Select = @Select + ' ''Level5'' = CASE WHEN Level5 IS NULL THEN ''-'' WHEN LTRIM(Level5) = '''' THEN ''-'' ELSE Level5 END, ''level5Desig'' = CASE WHEN level5Desig IS NULL THEN ''-'' WHEN LTRIM(level5Desig)='''' THEN ''-'' ELSE level5Desig END, '
  --SET @Select = @Select + ' Level5 , level5Desig, '
  IF @ClassCode5 <> ''
  BEGIN
   SET @Where = @Where + ' Level5 LIKE ''' + @ClassCode5 + ''' AND '
  END
  IF @ClassDesc5 <> ''
  BEGIN
   SET @Where = @Where + ' Level5Desig LIKE ''' + @ClassDesc5 + ''' AND '
  END
  SET @OrderBy = ' ORDER BY Level5, Level5Desig '
 END 
 
 --retirar a virgula e o espaço e adicionar um espaço
 SET @Select = SUBSTRING(@Select, 1, LEN(@SELECT) - 1) + ' '
   
 IF @SearchLevel = 1
  SET @Where = @Where + ' Level2 IS NULL '
 ELSE IF @SearchLevel = 2
  SET @Where = @Where + ' Level3 IS NULL AND Level2 IS NOT NULL '
 ELSE IF @SearchLevel = 3
  SET @Where = @Where + ' Level4 IS NULL AND Level3 IS NOT NULL '
 ELSE IF @SearchLevel = 4
  SET @Where = @Where + ' Level5 IS NULL AND Level4 IS NOT NULL '
 ELSE IF @SearchLevel = 5
  SET @Where = @Where + ' Level5 IS NOT NULL '
 
 --only select global classifications and classifications of that book
 IF @BookID > 0
 BEGIN
  --SET @Where = @Where + ' AND (ClassID IN (SELECT ClassID FROM OW.tblClassificationBooks WHERE BookID=' + Convert(nvarchar,@BookID) + ') OR Tipo like ''Global'' OR Tipo IS NULL) '
 
  -- Acessos
  SET @Where = @Where + ' AND  (level1 IN (   '
  SET @Where = @Where + ' SELECT level1 '
  SET @Where = @Where + ' FROM OW.tblClassification '
  SET @Where = @Where + ' WHERE ClassID IN (SELECT ClassID '
  SET @Where = @Where + ' FROM OW.tblClassificationBooks '
  SET @Where = @Where + '  WHERE BookID=' + Convert(nvarchar,@BookID)   + ')'       
  SET @Where = @Where + ' OR tipo=''Global'' ))'
 END
 
 ELSE
  SET @OrderBy = ' ORDER BY Level1, Level2, Level3, Level4, Level5 '
 
 --define the from tables
 SET @From  = ' FROM OW.tblClassification '
 
 SET @strSQL = @Select + @From + @Where + @OrderBy
 
 print @strSQL
 print @OrderBy
 exec sp_executeSQL @strSQL
 
 Return @@ERROR







GO



/****** Object:  Stored Procedure OW.usp_GetClassificationAdmin    Script Date: 12/4/2003 15:36:46 ******/
GO


CREATE PROCEDURE OW.usp_GetClassificationAdmin

AS
	SELECT ClassID, Level1, Level2, Level3, Level4, Level5,
		'Designation' =
		CASE 
			WHEN Level5 IS NOT NULL THEN Level5Desig
			WHEN Level4 IS NOT NULL THEN Level4Desig
			WHEN Level3 IS NOT NULL THEN Level3Desig
			WHEN Level2 IS NOT NULL THEN Level2Desig
			ELSE Level1Desig
		END,
		Tipo
		FROM OW.tblClassification
		ORDER BY Level1, Level2, Level3, Level4, Level5
			
	RETURN @@Error





GO


/****** Object:  Stored Procedure OW.usp_GetClassificationByCode    Script Date: 12/4/2003 15:36:46 ******/
GO

CREATE PROCEDURE OW.usp_GetClassificationByCode

	(
		@ActLevel NUMERIC, /* Actual level used for the search */
		@BookID NUMERIC, /* ID of the book where the classification should be associated */
		@Level1 NVARCHAR(50), /* Level1 code */
		@Level2 NVARCHAR(50), /* Level2 code */
		@Level3 NVARCHAR(50), /* Level3 code */
		@Level4 NVARCHAR(50), /* Level4 code */
		@Level5 NVARCHAR(50), /* Level5 code */
		@ClassID NUMERIC OUTPUT, /* Return classification ID */
		@Description NVARCHAR(100) OUTPUT /* Return classification description */
	)

AS
	DECLARE @Params NVARCHAR(200)
	DECLARE @Query NVARCHAR(1000)
	DECLARE @RetVal INT
	
	IF @BookID = 0
		IF (SELECT count(*) FROM  tblClassification 
				INNER JOIN tblClassificationBooks 
				ON tblClassificationBooks.ClassID = tblClassification.ClassID 
			WHERE Level1= @Level1 AND Level2 IS NULL  
				AND (tblClassification.Tipo LIKE 'Global' OR tblClassification.Tipo IS NULL)) = 0
	
				SET @RetVal = 1
	ELSE
	BEGIN
		IF(SELECT count(*) FROM tblClassification 
				INNER JOIN tblClassificationBooks 
				ON tblClassificationBooks.ClassID = tblClassification.ClassID 
			WHERE Level1= @Level1 AND Level2 IS NULL  
				AND tblClassificationBooks.bookID = @BookID) = 0	
		BEGIN
			SET @RetVal = 1
		END
	END

	SET @Query = ' SELECT @CID = ClassID, @Desc = Description FROM tblClassification ' 	 

	IF @ActLevel = 1 
	BEGIN
		SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 IS NULL '
	END
	ELSE
	BEGIN
		IF @ActLevel = 2 
		BEGIN
			SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 IS NULL '
		END
		ELSE
		BEGIN
			IF @ActLevel = 3 
			BEGIN
				SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 LIKE ''' + @Level3 + ''' AND Level4 IS NULL '
			END
			ELSE
			BEGIN
				IF @ActLevel = 4 
				BEGIN
					SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 LIKE ''' + @Level3 + ''' AND Level4 LIKE ''' + @Level4 + ''' AND Level5 IS NULL '
				END
				ELSE
				BEGIN
					IF @ActLevel = 5 
					BEGIN
						SET @Query = @Query + ' WHERE Level1 LIKE ''' + @Level1 + ''' AND Level2 LIKE ''' + @Level2 + ''' AND Level3 LIKE ''' + @Level3 + ''' AND Level4 LIKE ''' + @Level4 + ''' AND Level5 LIKE ''' + @Level5 + ''' '
					END --level5 
				END --level4 (else)
			END --level3 (else)
		END -- level2 (else)
	END --level1 (else)

	SET @Params = '@CID NUMERIC OUTPUT, @Desc NVARCHAR(100) OUTPUT'

	EXEC sp_ExecuteSQL @Query,
					@Params,
					@CID = @ClassID output, 
					@Desc = @Description output;
	
	IF @RetVal <> 0
	BEGIN
		Return @RetVal
	END
	ELSE
		Return @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetClassificationByID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetClassificationByID
	(
		@ClassID numeric	
	)
AS
	SELECT ClassID, Level1, Level2, Level3, Level4, Level5,
			Level1Desig, Level2Desig, Level3Desig, Level4Desig, Level5Desig, Tipo
	FROM OW.tblClassification
	WHERE ClassID = @ClassID
	
	RETURN @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_GetClassificationInfo    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetClassificationInfo
    (
        @BookID numeric
    )
AS

SELECT level1, level2, level3, level4, level5, 'Designation' =
CASE 
    WHEN Level5 IS NOT NULL THEN Level5Desig
    WHEN Level4 IS NOT NULL THEN Level4Desig
    WHEN Level3 IS NOT NULL THEN Level3Desig
    WHEN Level2 IS NOT NULL THEN Level2Desig
    ELSE Level1Desig
END
FROM OW.tblClassification
WHERE (level1 IN (SELECT level1 
				  FROM OW.tblClassification 
				  WHERE ClassID IN (SELECT ClassID 
									FROM OW.tblClassificationBooks 
									WHERE BookID=@BookID)
				  OR tipo='Global'))
ORDER BY level1, level2, level3, level4, level5





GO


/****** Object:  Stored Procedure OW.usp_GetContact    Script Date: 28-07-2004 18:18:02 ******/
GO




/****** Object:  Stored Procedure OW.usp_GetContact    Script Date: 12/4/2003 15:36:46 ******/


CREATE PROCEDURE OW.usp_GetContact
	(@EntID numeric=null,
	@FirstName varchar(50)=null, 
	@MiddleName varchar(300)=null,
	@LastName varchar(50)=null, 
	@ListID numeric=null,
	@BI numeric=null, 
	@NumContribuinte numeric=null, 
	@AssociateNum numeric=null,
	@eMail varchar(300)=null,
	@JobTitle varchar(100)=null, 
	@Street  varchar(500)=null,
	@PostalCodeID numeric=null,	
	@CountryID numeric=null,
	@Phone  varchar(20)=null, 
	@Fax  varchar(20)=null, 
	@Mobile  varchar(20)=null,
	@DistrictID numeric=null,
	@Full bit=0,
	@NAME varchar(400)=null,
	@EntityID numeric=null,
	@user varchar(900),
	@Access numeric,
	@Active bit=null
	)

AS

SET CONCAT_NULL_YIELDS_NULL OFF

IF @FULL=1
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, tblEntities.ListID,
		BI, NumContribuinte, AssociateNum,eMail,JobTitle, Street,
		tblPostalCode.PostalCodeID,tblPostalCode.Code As PostalCode, 
		tblPostalCode.Description As PostalCodeDesc, 
		tblCountry.CountryID, tblCountry.Description As CountryDesc, Phone, Fax, Mobile, 
		tblDistrict.DistrictID, tblDistrict.Description As DistrictDesc,
		tblEntityList.Description As ContactListDescription, EntityID,Active, 
		tblUser.UserDesc As CreatedBy, CreatedDate,tblUserMod.UserDesc As ModifiedBy, ModifiedDate
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)
		 LEFT JOIN OW.tblPostalCode tblPostalCode ON (tblEntities.PostalCodeID=tblPostalCode.PostalCodeID)
		 LEFT JOIN OW.tblCountry tblCountry ON (tblEntities.CountryID=tblCountry.CountryID)
		 LEFT JOIN OW.tblDistrict tblDistrict ON (tblEntities.DistrictID=tblDistrict.DistrictID)
		 LEFT JOIN OW.tblUser tblUser ON (tblUser.UserID=tblEntities.CreatedBy)
		 LEFT JOIN OW.tblUser tblUserMod ON (tblUserMod.UserID=tblEntities.ModifiedBy)
	WHERE (EntID = @EntID or @EntID is null)
	AND (FirstName  LIKE @FirstName OR @FirstName is null)
	AND (MiddleName LIKE @MiddleName OR @MiddleName is null)
	AND (LastName LIKE @LastName OR @LastName is null)
	AND (tblEntities.ListID = @ListID OR @ListID is null)
	AND (BI=@BI OR @BI is null)
	AND (NumContribuinte=@NumContribuinte OR @NumContribuinte is null)
	AND (AssociateNum=@AssociateNum OR @AssociateNum is null)
	AND (eMail LIKE @eMail OR @eMail is null)
	AND (JobTitle LIKE @JobTitle OR @JobTitle is null)
	AND (Street LIKE @Street OR @Street is null)
	AND (tblEntities.PostalCodeID=@PostalCodeID OR @PostalCodeID is null)
	AND (tblEntities.CountryID=@CountryID OR @CountryID is null)
	AND (Phone LIKE @Phone OR @Phone is null)
	AND (Fax LIKE @Fax OR @Fax is null)
	AND (Mobile LIKE @Mobile OR @Mobile is null)
	AND (tblEntities.DistrictID=@DistrictID OR @DistrictID is null)
	AND (EntityID=@EntityID OR @EntityID is null)
	AND ((RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' ')))) LIKE @NAME OR @NAME is null)
	AND (Active=@Active OR @Active is null)
	AND (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR tblEntities.ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID IN (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
			AND ObjectID >= @Access -- ROLE
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
						) 
			)
       )		
END
ELSE
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, Active,
		tblEntityList.Description As ContactListDescription
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)
	WHERE (EntID = @EntID or @EntID is null)
	AND (FirstName  LIKE @FirstName OR @FirstName is null)
	AND (MiddleName LIKE @MiddleName OR @MiddleName is null)
	AND (LastName LIKE @LastName OR @LastName is null)
	AND (tblEntities.ListID = @ListID OR @ListID is null)
	AND (BI=@BI OR @BI is null)
	AND (NumContribuinte=@NumContribuinte OR @NumContribuinte is null)
	AND (AssociateNum=@AssociateNum OR @AssociateNum is null)
	AND (eMail LIKE @eMail OR @eMail is null)
	AND (JobTitle LIKE @JobTitle OR @JobTitle is null)
	AND (Street LIKE @Street OR @Street is null)
	AND (PostalCodeID=@PostalCodeID OR @PostalCodeID is null)
	AND (CountryID=@CountryID OR @CountryID is null)
	AND (Phone LIKE @Phone OR @Phone is null)
	AND (Fax LIKE @Fax OR @Fax is null)
	AND (Mobile LIKE @Mobile OR @Mobile is null)
	AND (DistrictID=@DistrictID OR @DistrictID is null)
	AND (EntityID=@EntityID OR @EntityID is null)
	AND (RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) LIKE @NAME OR @NAME is null)
	AND (Active=@Active OR @Active is null)
    AND (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID    
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR tblEntities.ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
				OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID IN (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
			AND ObjectID >= @Access -- ROLE
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
						) 
			)
		)	
END
	RETURN @@ERROR


GO


/****** Object:  Stored Procedure OW.usp_GetContactByID    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactByID
	(
		@ID text,
		@Access numeric,
		@user varchar(900),
		@ReturnEntity bit
	)
AS
	SET NOCOUNT ON
	SET CONCAT_NULL_YIELDS_NULL OFF
	
IF (@ReturnEntity=0)
BEGIN
SELECT RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) As [Name], 
		EntID,FirstName, MiddleName,LastName, tblEntities.ListID,
		BI, NumContribuinte, AssociateNum,eMail,JobTitle, Street,
		tblPostalCode.PostalCodeID,tblPostalCode.Code As PostalCode, 
		tblPostalCode.Description As PostalCodeDesc, 
		tblCountry.CountryID, tblCountry.Description As CountryDesc, Phone, Fax, Mobile, 
		tblDistrict.DistrictID, tblDistrict.Description As DistrictDesc,
		tblEntityList.Description As ContactListDescription, EntityID,Active, 
		tblUser.UserDesc As CreatedBy, CreatedDate,tblUserMod.UserDesc As ModifiedBy, ModifiedDate
FROM OW.tblEntities tblEntities
INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
LEFT JOIN OW.tblPostalCode tblPostalCode ON (tblEntities.PostalCodeID=tblPostalCode.PostalCodeID)
LEFT JOIN OW.tblCountry tblCountry ON (tblEntities.CountryID=tblCountry.CountryID)
LEFT JOIN OW.tblDistrict tblDistrict ON (tblEntities.DistrictID=tblDistrict.DistrictID)
LEFT JOIN OW.tblUser tblUser ON (tblUser.UserID=tblEntities.CreatedBy)
LEFT JOIN OW.tblUser tblUserMod ON (tblUserMod.UserID=tblEntities.ModifiedBy)
WHERE  EXISTS (SELECT 1 FROM OW.fnListToTable(@ID,',') WHERE value=EntID)
AND tblEntities.Active=1 
AND  (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID
			 FROM OW.tblEntityListAccess
			 WHERE objectID IN (SELECT userID
					FROM OW.tbluser
					WHERE userLogin LIKE @user
					AND useractive=1)
			 AND ObjectType=1
			 AND AccessType >= @Access
			)
OR tblEntities.ListID IN (SELECT ObjectParentID
			  FROM OW.tblEntityListAccess
			  WHERE objectID IN (SELECT DISTINCT GroupID
					 FROM OW.tblGroupsUsers
					 WHERE  userID IN (SELECT UserID
							   FROM OW.tblUser
							   WHERE UserLogin LIKE @user
							   AND useractive=1)
					)
			 AND ObjectType=2
			 AND AccessType >= @Access)		
OR ([global]=1
 	AND EXISTS (SELECT ObjectID
		FROM OW.tblAccess
		WHERE userID IN (SELECT UserID
				FROM OW.tblUser
				WHERE UserLogin LIKE @user
				AND useractive=1)
			AND ObjectID >= @Access -- ROLE=2
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY				
		)
	)
) 	
ORDER BY tblEntities.EntID
END
ELSE
BEGIN
SELECT RTRIM(LTRIM(Replace(tblEntities.FirstName + ' ' + tblEntities.MiddleName + ' ' + tblEntities.LastName,'  ',' '))) As [Name], 
		tblEntities.EntID,tblEntities.FirstName, tblEntities.MiddleName,tblEntities.LastName, tblEntities.ListID,
		tblEntities.BI, tblEntities.NumContribuinte, tblEntities.AssociateNum,tblEntities.eMail,
		tblEntities.JobTitle, tblEntities.Street,
		tblPostalCode.PostalCodeID,tblPostalCode.Code As PostalCode, 
		tblPostalCode.Description As PostalCodeDesc, 
		tblCountry.CountryID, tblCountry.Description As CountryDesc, tblEntities.Phone, tblEntities.Fax, 
		tblEntities.Mobile, tblDistrict.DistrictID, tblDistrict.Description As DistrictDesc,
		tblEntityList.Description As ContactListDescription, tblEntities.EntityID,tblEntities.Active, 
		RTRIM(LTRIM(Replace(tEnt.FirstName + ' ' + tEnt.MiddleName + ' ' + tEnt.LastName,'  ',' '))) As [EntityName], 
		tblUser.UserDesc As CreatedBy, tblEntities.CreatedDate,tblUserMod.UserDesc As ModifiedBy, tblEntities.ModifiedDate
FROM OW.tblEntities tblEntities
INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
LEFT JOIN OW.tblEntities as tEnt ON (tblEntities.EntityID=tEnt.EntID)	
LEFT JOIN OW.tblPostalCode tblPostalCode ON (tblEntities.PostalCodeID=tblPostalCode.PostalCodeID)
LEFT JOIN OW.tblCountry tblCountry ON (tblEntities.CountryID=tblCountry.CountryID)
LEFT JOIN OW.tblDistrict tblDistrict ON (tblEntities.DistrictID=tblDistrict.DistrictID)
LEFT JOIN OW.tblUser tblUser ON (tblUser.UserID=tblEntities.CreatedBy)
LEFT JOIN OW.tblUser tblUserMod ON (tblUserMod.UserID=tblEntities.ModifiedBy)
WHERE  EXISTS (SELECT 1 FROM OW.fnListToTable(@ID,',') WHERE value=tblEntities.EntID)
AND tblEntities.Active=1 
AND  (tblEntities.ListID IN (SELECT DISTINCT ObjectParentID
			 FROM OW.tblEntityListAccess
			 WHERE objectID IN (SELECT userID
					FROM OW.tbluser
					WHERE userLogin LIKE @user
					AND useractive=1)
			 AND ObjectType=1
			 AND AccessType >= @Access
			)
OR tblEntities.ListID IN (SELECT ObjectParentID
			  FROM OW.tblEntityListAccess
			  WHERE objectID IN (SELECT DISTINCT GroupID
					 FROM OW.tblGroupsUsers
					 WHERE  userID IN (SELECT UserID
							   FROM OW.tblUser
							   WHERE UserLogin LIKE @user
							   AND useractive=1)
					)
			 AND ObjectType=2
			 AND AccessType >= @Access)		
OR ([global]=1
 	AND EXISTS (SELECT ObjectID
		FROM OW.tblAccess
		WHERE userID IN (SELECT UserID
				FROM OW.tblUser
				WHERE UserLogin LIKE @user
				AND useractive=1)
			AND ObjectID >= @Access -- ROLE
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY				
		)
	)
) 	
ORDER BY tblEntities.EntID
END	
	
RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_GetContactFields    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactFields
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	SELECT FieldID, Description,TypeID, [Size],[Unique], Empty,[GLobal]
	FROM OW.tblFields
	WHERE visible=1
	RETURN @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_GetContactListRole    Script Date: 28-07-2004 18:18:02 ******/
GO




CREATE PROCEDURE OW.usp_GetContactListRole
	(
		@user varchar(900),
		@ID numeric
	)
AS
	IF ((SELECT [global] FROM OW.tblEntityList WHERE ListID=@ID) =1) 
	BEGIN
		SELECT ObjectID As Role
		FROM OW.tblAccess 
		WHERE userID IN (SELECT DISTINCT UserID 
				FROM OW.tblUser 
				WHERE UserLogin LIKE @user
				AND useractive=1)
			AND ObjectTypeID=1 -- TYPE_PRODUCT
			AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
	END
	ELSE
	BEGIN
		SELECT TOP 1 AccessType As Role
		FROM OW.tblEntityListAccess
		WHERE (objectID IN (SELECT DISTINCT userID 
				   FROM OW.tbluser 
				   WHERE userLogin LIKE @user
				   AND useractive=1)
			AND ObjectType=1
			AND ObjectParentID=@ID)
		OR 
		 (objectID IN (SELECT DISTINCT GroupID 
				 FROM OW.tblGroupsUsers 
				 WHERE  userID IN (SELECT DISTINCT UserID 
						   FROM OW.tblUser 
						   WHERE UserLogin LIKE @user
						   AND useractive=1)
				)
		 AND ObjectParentID=@ID
		 AND ObjectType=2)
		ORDER BY ObjectType ASC


	END
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetContactLists    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactLists
	(
		@ListID numeric=null,
		@Global bit=null,
		@user varchar(900)=null,
		@Access numeric=null
	)
AS
IF (@user is null)
BEGIN
	IF (@ListID is null AND @Global is NULL)
	BEGIN
		SELECT ListID, Description, [global] 
		FROM OW.tblEntityList
		ORDER BY Description
	END
	ELSE 
		IF (@ListID is not null AND @Global is NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			ORDER BY Description	
		END
	ELSE 
		IF (@ListID is null AND @Global is not NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE ([global]=@Global)
			ORDER BY Description	
		END
	ELSE -- (@ListID!=null AND @Global!=NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			AND ([global]=@Global)
			ORDER BY Description	
		END
END
ELSE -- @all=0
BEGIN
IF (@ListID is null AND @Global is NULL)
	BEGIN
		SELECT ListID, Description, [global]
		FROM OW.tblEntityList
		WHERE (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
				OR ([global]=1
					AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  
		ORDER BY Description
	END
	ELSE 
		IF (@ListID is not null AND @Global is NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			AND (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  

		ORDER BY Description	
		END
	ELSE 
		IF (@ListID is null AND @Global is not NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE ([global]=@Global)
			AND (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access

						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  
		
			ORDER BY Description	
		END
	ELSE -- (@ListID!=null AND @Global!=NULL)
		BEGIN
			SELECT ListID, Description, [global] 
			FROM OW.tblEntityList
			WHERE (ListID=@ListID)
			AND ([global]=@Global)
			AND (ListID IN (SELECT DISTINCT ObjectParentID
						 FROM OW.tblEntityListAccess
						 WHERE objectID IN (SELECT userID 
											FROM OW.tbluser 
											WHERE userLogin LIKE @user
											AND useractive=1)
						 AND ObjectType=1 
						 AND AccessType >= @Access
						 )
		OR ListID IN (SELECT ObjectParentID
					  FROM OW.tblEntityListAccess
					  WHERE objectID IN (SELECT DISTINCT GroupID 
										 FROM OW.tblGroupsUsers 
										 WHERE  userID IN (SELECT UserID 
														   FROM OW.tblUser 
														   WHERE UserLogin LIKE @user
														   AND useractive=1)
										)
					  AND ObjectType=2
					  AND AccessType >= @Access)
		OR ([global]=1
			AND EXISTS (SELECT ObjectID
						FROM OW.tblAccess 
						WHERE userID = (SELECT UserID 
										FROM OW.tblUser 
										WHERE UserLogin LIKE @user
										AND useractive=1)
						AND ObjectID >= @Access -- ROLE
						AND ObjectTypeID=1 -- TYPE_PRODUCT
						AND ObjectParentID=3 -- OBJ_PRODUCT_REGISTRY
								) 
					)
		)						  
		
			ORDER BY Description	
		END
END	
	RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetContactProfilesFields    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetContactProfilesFields
	(
		@profileID numeric,
		@mode numeric    /* 0 - FIELDS IN PROFILE, 1 - FIELDS NOT IN PROFILE  */
	)
AS
	if (@mode=0)
		/* GETS FIELDS IN THE PROFILE */
		BEGIN
			SELECT 
				OW.tblFields.FieldID, 
				OW.tblFields.Description,
				OW.tblProfilesFields.fieldmaxchars
			FROM
				OW.tblFields, OW.tblProfilesFields
			WHERE 
				OW.tblProfilesFields.formfieldKey = OW.tblFields.FieldID AND 
				OW.tblProfilesFields.profileid = @profileID
			ORDER BY FormFieldOrder
		END

	if (@mode=1)
		/* GETS FIELDS NOT IN THE PROFILE */
		BEGIN
			SELECT 
				OW.tblFields.FieldID, 
				OW.tblFields.Description
			FROM
				OW.tblFields
			WHERE 
				NOT EXISTS  (SELECT 1 
							 FROM  OW.tblProfilesFields tbk 
							 WHERE tbk.formfieldKey = OW.tblFields.FieldID 
							 AND tbk.profileID = @profileID) 
			ORDER BY Description
		END

Return @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_GetContactsDuplicated    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetContactsDuplicated
	(
		@BI numeric=null, 
		@NumContribuinte numeric=null, 
		@AssociateNum numeric=null,
		@CountryID numeric,
		@ID numeric=null
	)
AS
IF @ID is null
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, Active,		
		tblEntityList.Description As ContactListDescription
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
	WHERE ((BI=@BI AND @BI is not null) OR
		  (NumContribuinte=@NumContribuinte AND @NumContribuinte is not null) OR
		  (AssociateNum=@AssociateNum AND @AssociateNum is not null)) AND 
		  CountryID=@CountryID
END
ELSE
BEGIN
	SELECT EntID, FirstName, MiddleName,LastName, Active,		
		tblEntityList.Description As ContactListDescription
	FROM OW.tblEntities tblEntities INNER JOIN OW.tblEntityList tblEntityList ON (tblEntities.ListID=tblEntityList.ListID)	
	WHERE ((BI=@BI AND @BI is not null) OR
		  (NumContribuinte=@NumContribuinte AND @NumContribuinte is not null) OR
		  (AssociateNum=@AssociateNum AND @AssociateNum is not null)) AND 
		  CountryID=@CountryID AND
		  EntID <> @ID

END
	return @@ERROR




GO

/****** Object:  Stored Procedure OW.usp_GetCountry    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetCountry
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	/* SET NOCOUNT ON */
	SELECT CountryID, Code, Description 
	FROM OW.tblCountry
	ORDER BY Description
	RETURN @@ERROR




GO

/****** Object:  Stored Procedure OW.usp_GetDescriptionListOptionsValues    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDescriptionListOptionsValues
	(
		@ListID numeric
	)

AS
Select Description from OW.tblListOptionsValues where ListID = @ListID
	
	/* SET NOCOUNT ON */
	RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_GetDispatch    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatch
	(
		@abreviation nvarchar(20)
	)
AS
	IF  (@abreviation = '')
		SELECT
			*
		FROM
			OW.tblDispatch
	ELSE
		SELECT
			*
		FROM
			OW.tblDispatch
		WHERE
			abreviation=@abreviation
	
	IF (@@ERROR <> 0)
		Return 1
	ELSE
		Return 0



GO


/****** Object:  Stored Procedure OW.usp_GetDispatchFromID    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDispatchFromID
	(
		@id numeric
	)
AS

SELECT
*
FROM
OW.tblDispatch
WHERE
@id=dispatchid

IF (@@ERROR <> 0)
    Return 1
ELSE
    Return 0





GO

/****** Object:  Stored Procedure OW.usp_GetDispatchFull    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatchFull
AS

SELECT
*
FROM
OW.tblDispatch

IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0





GO

/****** Object:  Stored Procedure OW.usp_GetDispatchNotInBook    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatchNotInBook
	(
	@bookid numeric
	)

AS

select 	OW.tblDispatch.*
from 	OW.tblDispatch
where	OW.tblDispatch.dispatchid NOT IN
	(select OW.tbldispatchbook.dispatchid 
	 from OW.tbldispatchbook
	 where OW.tblDispatchBook.bookid = @bookid) and OW.tblDispatch.global  = '0'
ORDER BY
	OW.tblDispatch.abreviation


IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0



GO

/****** Object:  Stored Procedure OW.usp_GetDispatchbyBook    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDispatchbyBook
	(
	@bookid numeric
	)

AS

(SELECT
	OW.tblDispatch.dispatchid, 
	OW.tblDispatch.abreviation,
	OW.tblDispatch.designation,
	OW.tblDispatch.[global]
FROM
	OW.tblDispatch
WHERE
	OW.tblDispatch.global ='1'

UNION 

SELECT
	OW.tblDispatch.dispatchid, 
	OW.tblDispatch.abreviation,
	OW.tblDispatch.designation,
	OW.tblDispatch.[global]
FROM
	OW.tblDispatchBook,
	OW.tblDispatch
WHERE
	OW.tblDispatchBook.dispatchid = OW.tblDispatch.dispatchid
AND	
	OW.tblDispatchBook.bookid = @bookid AND OW.tblDispatch.[global] ='0')
ORDER BY
	OW.tblDispatch.abreviation

IF (@@ERROR <> 0)
	Return 1
ELSE
	Return 0



GO

/****** Object:  Stored Procedure OW.usp_GetDistribRelat    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistribRelat
    (
        @UserID numeric,
        @OWWorkFlowDistributionID numeric
    )
AS

    SET NOCOUNT ON
    SELECT OWWorkFlowDistributionID, Subject, usr.userDesc, st.StateDesc, wkf.StageNumber, ReadDate, SendDate,
        SUBSTRING(Body,
        CASE
            WHEN PATINDEX('%<BODY>%', body) = 0 THEN 1
            ELSE PATINDEX('%<BODY>%', body) + len('<BODY>')
            END,
        CASE
            WHEN PATINDEX('%<BODY>%', body) = 0 THEN DATALENGTH(body)
            WHEN PATINDEX('%<BR><font face%', body) = 0 then PATINDEX('%</BODY>%', body) - PATINDEX('%<BODY>%', body) + len('<BODY>')
            ELSE (PATINDEX('%<BR><font%', body) - Len('<BR><fon')) - PATINDEX('%<BODY>%', body) + len('<BODY>')
            END) AS Message
    FROM OW.tblOWWorkFlowDistribution wkf 
    INNER JOIN OW.tblUser usr ON (wkf.FromAddrID = usr.UserID)
    INNER JOIN OW.tblState st ON (wkf.State = st.StateID)
    WHERE wkf.OWWorkFlowDistributionID = @OWWorkFlowDistributionID
    ORDER BY OWWorkFlowDistributionID, StageNumber ASC





GO

/****** Object:  Stored Procedure OW.usp_GetDistribTypeID    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistribTypeID
    (
        @DistribTypeCode nvarchar(50)  = Null,
        @DistribTypeDesc varchar(250)  = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(400)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT DistribTypeID FROM OW.tblDistributionType'

    IF LEN(@DistribTypeCode) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'GetDistribCode like ''' + @DistribTypeCode + ''''
        END

    IF LEN(@DistribTypeDesc) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'DistribTypeDesc like ''' + @DistribTypeDesc + ''''
        END

    EXEC sp_ExecuteSQL @Query





GO


/****** Object:  Stored Procedure OW.usp_GetDistribution    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistribution
	(
		@RegID numeric
	)

AS

	SET DATEFORMAT dmy;

	SELECT
		a.[ID] as distribID,
		a.regID,
		convert(varchar,a.distribdate,105) as distribdate,
		a.userid,
		c.userdesc,
		a.distribtypeID,
		b.distribtypedesc,
		a.tipo,
		a.radiovia,
		a.state,
		a.connectid,
		a.chkfile,
		a.distribObs,
		a.dispatch
	FROM
		OW.tblRegistryDistribution a 
		LEFT JOIN OW.tblDistributionType b ON  (a.DistribTypeID=b.DistribTypeID) 
		LEFT JOIN  OW.tblUser c ON (a.UserID=c.UserID)
	WHERE 
		a.RegID=@RegID 
	ORDER BY 
		a.[ID] 
	

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN 1
			
	RETURN 0





GO

/****** Object:  Stored Procedure OW.usp_GetDistributionOWFlowIntervenientsById    Script Date: 28-07-2004 18:18:02 ******/
GO


CREATE PROCEDURE OW.usp_GetDistributionOWFlowIntervenientsById

	@owflowIdsList text 

AS

select RegID from OW.tblRegistryDistribution rdis where exists
(select 1 from OW.fnListToTable(@owflowIdsList,',') 
where value = rdis.ConnectID
AND Tipo=6)

GO


Go

/****** Object:  Stored Procedure OW.usp_GetDistributionCircularMailByUserID    Script Date: 28-07-2004 18:18:02 ******/
GO


CREATE PROCEDURE OW.usp_GetDistributionCircularMailByUserID

	@usersList text = null,
	@subject varchar(255) = null,
	@startDate datetime = null,
	@endDate datetime = null,
	@requestedPage int = 1,
	@recordsPerPage int = 20,
	@activePage int output,
	@totalRecords int output,
	@totalPages int output
	
AS

set dateformat dmy

declare @variableDeclaration varchar(8000)
set @variableDeclaration = 
' set dateformat dmy '

	if (@usersList is not null)
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @usersList varchar(8000) set @usersList = ''' + cast(@usersList as varchar) + ''''
		end
	else
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @usersList varchar(8000) set @usersList = null '
		end

	if (@subject is not null)
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @subject varchar(255)
			set @subject = ''' + @subject + ''' '
		end

	if (@startDate is not null)
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @startDate datetime
			set @startDate = ''' + cast(@startDate as varchar(10)) + ''' '
		end
	else
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @startDate datetime
			set @startDate = null '
		end

	if (@endDate is not null)
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @endDate datetime
			set @endDate = ''' + cast(@endDate as varchar(10)) + ''' '
		end
	else
		begin
			set @variableDeclaration = @variableDeclaration + 
			' declare @endDate datetime
			set @endDate = null '
		end

select @activePage = 0 
select @totalRecords = 0 
select @totalPages = 0 

declare @recordsToFetchString varchar(20)
declare @recordsPerPageString varchar(20)

declare @query varchar(8000)

	if (@usersList is not null)

		begin

			set @recordsToFetchString = cast(@recordsPerPage * @requestedPage as varchar)
			set @recordsPerPageString = cast(@recordsPerPage as varchar)

			set @query = 
			' select * from

			(select top ' + @recordsPerPageString + ' * from

			(select top ' + @recordsToFetchString + ' 
			cast(OWWorkFlowDistributionID as varchar) + ''/'' + cast(year(SendDate) as varchar(4)) as CircularNumber,
			(select u.userLogin from OW.tblUser u where u.userID = wd.FromAddrID) as UserLogin,
			wd.SendDate,
			wd.Subject,
			wd.OWWorkFlowDistributionID,
			wd.StageNumber
			from OW.tblOWWorkFlowDistribution wd with (nolock) 
			where ((wd.ReadDate is not null and wd.StageNumber <> 0) or (wd.SendDate is not null and wd.StageNumber = 0)) '

				if (@subject is not null and @subject != '')
					begin
						set @query = @query + ' and wd.Subject like @subject '
					end

			set @query = @query + 
			' and OW.fnDateValidator(wd.SendDate, @startDate, @endDate) = 1 and exists
			(select 1 from OW.tblUser usr where wd.FromAddrID = usr.userID and exists
			(select 1 from OW.fnUsersLoginToTable(@usersList) where value = usr.userLogin))
			order by wd.OWWorkFlowDistributionID) as t1

			order by t1.OWWorkFlowDistributionID desc) as t2

			order by t2.OWWorkFlowDistributionID'

			exec(@variableDeclaration + @query)

		end

	else

		begin

			select @activePage = 0

				if (@subject is not null and @subject != '')
					begin
						select @totalRecords = count(OWWorkFlowDistributionID)
								from OW.tblOWWorkFlowDistribution wd with (nolock)
								where ((wd.ReadDate is not null and wd.StageNumber <> 0) or (wd.SendDate is not null and wd.StageNumber = 0)) 
								and wd.Subject like @subject 
								and OW.fnDateValidator(wd.SendDate, @startDate, @endDate) = 1 
					end
				else
					begin
						select @totalRecords = count(OWWorkFlowDistributionID)
								from OW.tblOWWorkFlowDistribution wd with (nolock)
								where ((wd.ReadDate is not null and wd.StageNumber <> 0) or (wd.SendDate is not null and wd.StageNumber = 0)) 
								and OW.fnDateValidator(wd.SendDate, @startDate, @endDate) = 1 
					end

			select @totalPages = @totalRecords / @recordsPerPage
			
			if (@totalRecords % @recordsPerPage != 2)
				begin
					select @totalPages = @totalPages + 1
				end

			set @recordsToFetchString = cast(@recordsPerPage * @requestedPage as varchar)
			set @recordsPerPageString = cast(@recordsPerPage as varchar)




			set @query = 
			' select * from

			(select top ' + @recordsPerPageString + ' * from 

			(select top ' + @recordsToFetchString + ' 
			cast(OWWorkFlowDistributionID as varchar) + ''/'' + cast(year(SendDate) as varchar(4)) as CircularNumber,
			(select u.userLogin from OW.tblUser u where u.userID = wd.FromAddrID) as UserLogin,
			wd.SendDate,
			wd.Subject,
			wd.OWWorkFlowDistributionID,
			wd.StageNumber
			from OW.tblOWWorkFlowDistribution wd with (nolock)
			where ((wd.ReadDate is not null and wd.StageNumber <> 0) or (wd.SendDate is not null and wd.StageNumber = 0)) '

				if (@subject is not null and @subject != '')
					begin
						set @query = @query + ' and wd.Subject like @subject '
					end

			set @query = @query + ' and OW.fnDateValidator(wd.SendDate, @startDate, @endDate) = 1
			order by wd.OWWorkFlowDistributionID) as t1

			order by t1.OWWorkFlowDistributionID desc) as t2

			order by t2.OWWorkFlowDistributionID'

			exec(@variableDeclaration + @query)

		end

GO

/****** Object:  Stored Procedure OW.usp_GetDistributionEMailByLogin    Script Date: 28-07-2004 18:18:02 ******/
GO


CREATE PROCEDURE OW.usp_GetDistributionEMailByLogin

 

            @usersList text,

            @iHist int

AS

 

--Obtém os Id's dos utilizadores e grava-os numa tabela temporária

declare @tbl table (uid int)

insert @tbl

select userID from OW.tblUser usr where exists 

(select value from OW.fnUsersLoginToTable(@usersList) where value = usr.userLogin)

 

 

--Obtém os registos, com distribuição por correio electrónico, cujos utilizadores sejam distribuidores ou destinatários

declare @tbAux table (regID numeric)

 

 

--Activos

if @iHist = 1 or @iHist = 3 

begin

            insert @tbAux

            select regid from OW.tblRegistry r where exists 

            (

                        select regId from OW.tblRegistryDistribution d 

                        where d.userId in (select uid from @tbl) and d.regId = r.regId and d.tipo = 1

            )

            or exists

            (

                        select regId from OW.tblRegistryDistribution d1 

                        inner join OW.tblElectronicMailDestinations e on e.userId in (select uid from @tbl) and e.mailId = d1.connectId

                        where d1.regId = r.regId and d1.tipo = 1

            )

end

 

--Histórico

if @iHist = 2 or @iHist = 3 

begin

            insert @tbAux

            select regid from OW.tblRegistryHist r where exists 

            (

                        select regId from OW.tblRegistryDistribution d 

                        where d.userId in (select uid from @tbl) and d.regId = r.regId and d.tipo = 1

            )

            or exists

            (

                        select regId from OW.tblRegistryDistribution d1 

                        inner join OW.tblElectronicMailDestinations e on e.userId in (select uid from @tbl) and e.mailId = d1.connectId

                        where d1.regId = r.regId and d1.tipo = 1

            )

end

 

select regID from @tbAux

GO


/****** Object:  Stored Procedure OW.usp_GetDistributionEntities    Script Date: 28-07-2004 18:18:02 ******/
GO





CREATE PROCEDURE OW.usp_GetDistributionEntities
	(
		@DistribID	numeric
	)

AS
	
SET CONCAT_NULL_YIELDS_NULL OFF

SELECT 
	b.entid, 
	RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) as name, 
	c.entid as contactid
FROM 
	OW.tblRegistryDistribution a
	LEFT JOIN OW.tblDistributionEntities b ON a.[id]=b.distribid
	LEFT JOIN OW.tblEntities c ON (b.EntID = c.EntID)
WHERE 
	a.[id]=@DistribID
	
RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_GetDistributionFromID    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionFromID
	(
		@ID numeric
	)

AS

	SELECT
		a.[ID],
		a.regID,
		a.userid,
		c.userdesc,
		a.distribtypeID,
		b.distribtypedesc,
		a.tipo,
		a.radiovia,
		a.distribobs,
		a.distribdate,
		a.state,
		a.connectid,
		a.chkfile
	FROM
		OW.tblRegistryDistribution a 
		LEFT JOIN OW.tblDistributionType b ON  (a.DistribTypeID=b.DistribTypeID) 
		LEFT JOIN  OW.tblUser c ON (a.UserID=c.UserID)
	WHERE 
		a.[ID]=@ID 
	
	IF (@@ERROR <> 0) 
		RETURN 1	
	ELSE		
		RETURN 0

GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTemp    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistributionTemp
	(
		@GUID nchar(32) 
	)

AS

	SET DATEFORMAT dmy;

	SELECT
		a.tmpid as distribID,
		a.regID,
		convert(varchar,a.distribdate,105) as distribdate,
		a.userid,
		c.userdesc,
		a.distribtypeID,
		b.distribtypedesc,
		a.tipo,
		a.radiovia,
		a.state,
		a.connectid,
		a.chkfile,
		a.distribObs,
		a.tmpid,
		a.old,
		a.guid,
		a.dispatch
	FROM
		OW.tblDistribTemp a 
		LEFT JOIN OW.tblDistributionType b ON  (a.DistribTypeID=b.DistribTypeID) 
		LEFT JOIN  OW.tblUser c ON (a.UserID=c.UserID)
	WHERE 
		a.GUID=@GUID
	ORDER BY 
		a.DistribDate 
	
	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN 1
	ELSE		
		RETURN 0





GO


/****** Object:  Stored Procedure OW.usp_GetDistributionTempCount    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionTempCount
	(
		@GUID nchar(32),
		@COUNT numeric OUTPUT 
	)

AS

	SELECT
		 @COUNT = count(*)
	FROM
		OW.tblDistribTemp a 
	WHERE 
		a.GUID=@GUID
	
	-- Save any nonzero @@ERROR value.
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTempEntities    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionTempEntities
	(
		@TmpID	numeric
	)

AS
	
SET CONCAT_NULL_YIELDS_NULL OFF	

SELECT 
	b.entid, 
	RTRIM(LTRIM(Replace(FirstName + ' ' + MiddleName + ' ' + LastName,'  ',' '))) as name, 
	c.entid as contactid
FROM 
	OW.tblDistribTemp a
	LEFT JOIN OW.tblDistributionEntities b ON a.tmpid=b.distribid
	LEFT JOIN OW.tblEntities c ON (b.EntID = c.EntID)
WHERE 
	a.tmpid=@TmpID and tmp=1

-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.

RETURN @@ERROR 	



GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTypeDescription    Script Date: 28-07-2004 18:18:02 ******/
GO
CREATE PROCEDURE OW.usp_GetDistributionTypeDescription
	(
		@TypeID as numeric
	)

AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0
	
	SELECT 
		*
	FROM 
		tblDistributionType
	WHERE
		DistribTypeID = @TypeID
		
	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN





GO

/****** Object:  Stored Procedure OW.usp_GetDistributionTypes    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistributionTypes

AS
	SELECT 
		distribtypeid, distribtypedesc
	FROM
		OW.tblDistributionType

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
		RETURN 1
	ELSE
		RETURN 0





GO

/****** Object:  Stored Procedure OW.usp_GetDistrict    Script Date: 28-07-2004 18:18:02 ******/
GO

CREATE PROCEDURE OW.usp_GetDistrict
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	SELECT DistrictID, Description
	FROM OW.tblDistrict
	ORDER BY Description
	RETURN @@ERROR
GO

/****** Object:  Stored Procedure OW.usp_GetDocumentType    Script Date: 28-07-2004 18:18:03 ******/
GO

/*** GETS A DOCUMENT TYPE ***/
CREATE  PROCEDURE OW.usp_GetDocumentType

	(
		@doctypeID numeric=null,
		@abreviation varchar(20)=null,
		@designation varchar(100)=null,
		@global bit=null
	)

AS
	
	SELECT 
		td.doctypeID,td.abreviation,td.designation,td.global
	FROM 
		OW.tblDocumentType td
	WHERE (doctypeID=@doctypeID or @doctypeID is null) 
	AND (abreviation=@abreviation or @abreviation is null)
	AND (designation=@designation or @designation is null)
	AND (global=@global or @global is null)
	ORDER BY abreviation
		
Return @@ERROR


GO

/****** Object:  Stored Procedure OW.usp_GetBooks    Script Date: 12/4/2003 15:36:46 ******/

ALTER   PROCEDURE OW.usp_GetBooks
( @login VARCHAR(30) = null,
  @role  NUMERIC = null,
  @abreviation VARCHAR(20) = null,
  @designation VARCHAR(100) = null
)
AS

IF (@abreviation is not null AND @designation is not null) /*** GETS INFO NO A GIVEN BOOK ***/
	SELECT
		*
	FROM
		OW.tblBooks
	WHERE
		@abreviation = abreviation AND  @designation=designation
	ORDER BY abreviation,designation
	
ELSE
	IF (@login is null or @role is null)
	BEGIN
		SELECT	*
		FROM OW.tblBooks 
		ORDER BY abreviation,designation
	END
	ELSE 
	BEGIN
		SELECT	*
		FROM OW.tblBooks tblBooks 
		WHERE EXISTS (SELECT  1
					FROM OW.tblAccess 
					WHERE bookid=ObjectID
					AND userid =(SELECT userID 
								FROM OW.tblUser
								WHERE userLogin=@login)
					AND ObjectParentID=1
					AND ObjectTypeID=2
					AND AccessType>=@role
					AND ObjectType=1)
			ORDER BY abreviation,designation
	END

Return @@ERROR
GO


/****** Object:  Stored Procedure OW.usp_GetElectronicMail    Script Date: 28-07-2004 18:18:03 ******/
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
SELECT tf.FileID,tf.FileName,tf.FilePath
FROM OW.tblFileManager tf
WHERE EXISTS (SELECT 1 FROM OW.tblElectronicMailDocuments tmd
			  WHERE tmd.MailID=@MailID
			  AND tmd.FileID=tf.FileID
			  )

RETURN @@ERROR
	

GO


/****** Object:  Stored Procedure OW.usp_GetFieldIDAndType    Script Date: 28-07-2004 18:18:03 ******/
GO

CREATE PROCEDURE OW.usp_GetFieldIDAndType
    (
        @fieldName nvarchar(50) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(150)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT formFieldKEY, DynFldTypeID FROM OW.tblFormFields'

    IF LEN(@fieldName) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'fieldName like ''' + @fieldName + ''''
        END

    EXEC sp_ExecuteSQL @Query





GO

/****** Object:  Stored Procedure dbo.usp_GetFieldsType    Script Date: 28-07-2004 18:18:03 ******/
GO
CREATE PROCEDURE dbo.usp_GetFieldsType
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS


select 
	*
from 
	OW.tblFormFieldsType
order by description ASC
RETURN 

GO

/****** Object:  Stored Procedure OW.usp_GetFile    Script Date: 28-07-2004 18:18:03 ******/
GO
CREATE PROCEDURE OW.usp_GetFile
	(
		@FileID numeric(18,0)
	)
AS

	SELECT tfm.FileID, tfm.FileName, tfm.FilePath 
	FROM OW.tblFileManager tfm
	WHERE tfm.FileID=@FileID

RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_GetFormFields    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetFormFields
(
	@All bit=null
)
AS
	IF ( @All = 1 )
		SELECT 
			f.* , t.[description]
		FROM 
			OW.tblformfields f 
		LEFT JOIN OW.tblformfieldstype t  
			on (f.dynfldTypeID=t.dynfldTypeID) 
		ORDER BY f.fieldName
	ELSE
		SELECT 
			f.* , t.[description]
		FROM 
			OW.tblformfields f 
		LEFT JOIN OW.tblformfieldstype t  
			on (f.dynfldTypeID=t.dynfldTypeID) 
		WHERE
			Visible=1

		ORDER BY f.fieldName	
		
RETURN @@ERROR

GO



/****** Object:  Stored Procedure OW.usp_GetFormFieldsTypes    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE PROCEDURE OW.usp_GetFormFieldsTypes
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS


select 
	*
from 
	OW.tblFormFieldsType
order by description ASC
RETURN 


GO



/****** Object:  Stored Procedure OW.usp_GetGroups    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetGroups
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	SELECT * 
	FROM OW.tblgroups 
	ORDER BY GroupDesc
	RETURN @@ERROR
	


GO



/****** Object:  Stored Procedure OW.usp_GetKeywordID    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetKeywordID
    (
        @keyDescription nvarchar(50) = Null
    )
AS

    SET NOCOUNT ON
    DECLARE @NumberOfParameters numeric
    DECLARE @Query nvarchar(150)

    SET @NumberOfParameters = 0
    SET @Query = 'SELECT keyID FROM OW.tblKeywords'

    IF LEN(@keyDescription) > 0
        BEGIN
            IF @NumberOfParameters = 0 SET @Query = @Query + ' WHERE '
            SET @NumberOfParameters = @NumberOfParameters + 1
            IF @NumberOfParameters > 1 SET @Query = @Query + ' AND '
            SET @Query = @Query + 'keyDescription like ''' + @keyDescription + ''''
        END

    EXEC sp_ExecuteSQL @Query





GO



/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 28-07-2004 18:18:03 ******/
GO



/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 6/4/2004 15:36:46 ******/

/*** GETS A KEYWORD ***/

CREATE PROCEDURE OW.usp_GetKeywords
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
IF (@designation is not null) SET @sSQLWhere=@sSQLWhere + ' keyDescription=''' + @designation + ''' AND '
IF (@global is not null) SET  @sSQLWhere=@sSQLWhere + ' [Global]=' + CAST(@global as VARCHAR) + ' AND '
print @sSQLWhere
-- Remove last AND
IF LEN(@sSQLWhere)>0
BEGIN
SET @sSQLWhere = LEFT(@sSQLWhere,LEN(@sSQLWhere)-3)
SET @sSQLWhere = ' WHERE ' +  @sSQLWhere 
END


SET  @sSQLOrderBY= ' ORDER BY	keyDescription'

EXEC (@sSQL + @sSQLWhere + @sSQLOrderBY)
Return @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_GetKeywordsByID    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetKeywordsByID
	(
		@keyID text
	)
AS

	
SELECT keyID,keyDescription,[Global] 
FROM OW.tblKeywords
WHERE EXISTS (SELECT 1 FROM OW.fnListToTable(@keyID,',') WHERE value=keyID)

RETURN @@ERROR


GO



/****** Object:  Stored Procedure OW.usp_GetListOptionsValues    Script Date: 28-07-2004 18:18:03 ******/
GO






CREATE     PROCEDURE OW.usp_GetListOptionsValues

	(
		@like varchar(100) = null
	)

AS

Declare @strQuery varchar(8000)

set @strQuery = 'Select ListID, Description from OW.tblListOptionsValues '

	if @like is null
	BEGIN
		PRINT '== Null'
		Select ListID, Description from OW.tblListOptionsValues 
		Order by Description
	END
	ELSE
	BEGIN
		Print '<> Null'
		Select ListID, Description from OW.tblListOptionsValues
		Where Description Like @Like 
		Order by Description
	END
	

	/* SET NOCOUNT ON */
	RETURN @@ERROR






GO


/****** Object:  Stored Procedure OW.usp_GetListUsersAndGroups    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetListUsersAndGroups

	(
		@ObjectParentID numeric,
		@userActive bit=1
	)

AS	
	SELECT userID, userDesc AS Description, 1 As ObjectType, AccessType
	FROM OW.tblUser tu INNER JOIN OW.tblEntityListAccess ta ON (tu.userID=ta.ObjectID)
	WHERE (userActive=@userActive)
	AND (ObjectParentID=@ObjectParentID and ObjectType=1)
	UNION 
	SELECT GroupID AS userID, GroupDesc AS Description, 2 AS ObjectType, AccessType
	FROM OW.tblGroups tg INNER JOIN OW.tblEntityListAccess ta ON (tg.GroupID=ta.ObjectID)
	WHERE ObjectParentID=@ObjectParentID and ObjectType=2
	ORDER BY 2 
		
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetListValues    Script Date: 28-07-2004 18:18:03 ******/
GO







CREATE     PROCEDURE OW.usp_GetListValues
(
		@id numeric
)
	AS
	SELECT DISTINCT 
		OW.tblListOptionsValues.Description, 
		OW.tblListValues.FormFieldKey, 
		OW.tblListOptionsValues.ListID
	FROM    
		OW.tblListOptionsValues LEFT OUTER JOIN
                OW.tblListValues ON OW.tblListOptionsValues.ListID = OW.tblListValues.ListID 
		AND OW.tblListValues.FormFieldKey = @ID	
	ORDER BY OW.tblListOptionsValues.[Description]
	
	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0





GO


/****** Object:  Stored Procedure OW.usp_GetListValuesbyID    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE  PROCEDURE OW.usp_GetListValuesbyID  

(
		@id numeric,
		@like varchar(100) = null
)
AS


Declare @strQuery varchar(8000)


	if @like is null
	BEGIN

		SELECT OW.tblListValues.ListID, OW.tblListValues.FormFieldKey, OW.tblListOptionsValues.Description
		FROM   OW.tblListValues INNER JOIN
	               OW.tblListOptionsValues ON OW.tblListValues.ListID = OW.tblListOptionsValues.ListID
		WHERE OW.tblListValues.FormFieldKey = @id
		Order by OW.tblListOptionsValues.Description
	END
	ELSE
	BEGIN

		SELECT OW.tblListValues.ListID, OW.tblListValues.FormFieldKey, OW.tblListOptionsValues.Description
		FROM   OW.tblListValues INNER JOIN
	               OW.tblListOptionsValues ON OW.tblListValues.ListID = OW.tblListOptionsValues.ListID
		WHERE OW.tblListValues.FormFieldKey = @id
		And OW.tblListOptionsValues.Description Like @Like 	
		Order by OW.tblListOptionsValues.Description
	END




	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0

		


GO



/****** Object:  Stored Procedure OW.usp_GetLists    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE PROCEDURE OW.usp_GetLists
	AS
	
	SELECT
		*
	FROM
		OW.tblFormFields 
	WHERE 
		DYNFLDTYPEID = 7
	ORDER BY 
		 FieldName

	IF (@@ERROR <> 0)
	    Return 1
	ELSE
	    Return 0

GO



/****** Object:  Stored Procedure OW.usp_GetMailHEADER    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetMailHEADER
(
        @OWWorkFlowDistributionID numeric,
        @OfficeWorksUser varchar(255)
)
AS
	SET NOCOUNT ON
SELECT r.subject,
	b.designation, 	 
	r.year, 
	r.number,
	c.level1,
	c.level2,
	c.level3,
	c.level4,
	c.level5,
	c.level1desig,
	c.level2desig,
	c.level3desig,
	c.level4desig,
	c.level5desig
FROM OW.tblRegistry r 
	LEFT OUTER JOIN OW.tblBooks b ON (r.bookid=b.bookid) 
	LEFT OUTER JOIN OW.tblClassification c ON (r.classid=c.classid) 
WHERE EXISTS(SELECT regid FROM OW.tblRegistryDistribution d 
		LEFT OUTER JOIN OW.tblOWWorkFlowDistribution wkf ON (d.connectid=wkf.OWWorkFlowDistributionID)		
		WHERE d.connectid=@OWWorkFlowDistributionID 
		AND d.regid=r.regid)
UNION
SELECT r.subject,
	b.designation, 	 
	r.year, 
	r.number,
	c.level1,
	c.level2,
	c.level3,
	c.level4,
	c.level5,
	c.level1desig,
	c.level2desig,
	c.level3desig,
	c.level4desig,
	c.level5desig
FROM OW.tblRegistryHist r 
	LEFT OUTER JOIN OW.tblBooks b ON (r.bookid=b.bookid) 
	LEFT OUTER JOIN OW.tblClassification c ON (r.classid=c.classid) 
WHERE EXISTS(SELECT regid FROM OW.tblRegistryDistribution d 
		LEFT OUTER JOIN OW.tblOWWorkFlowDistribution wkf ON (d.connectid=wkf.OWWorkFlowDistributionID)		
		WHERE d.connectid=@OWWorkFlowDistributionID 
		AND d.regid=r.regid)	
	
	RETURN @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_GetMailStagesBodyHTML    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetMailStagesBodyHTML
(
        @OWWorkFlowDistributionID numeric,
        @OfficeWorksUser varchar(255)
)
AS
	SET NOCOUNT ON
	Select wkf.StageNumber,
	SUBSTRING(wkf.body,
            CASE
                WHEN PATINDEX('%<BODY>%', wkf.body) = 0 THEN 1
                ELSE PATINDEX('%<BODY>%', wkf.body) + len('<BODY>')
                END,
            CASE
                WHEN PATINDEX('%<BODY>%', wkf.body) = 0 THEN DATALENGTH(wkf.body)
                WHEN PATINDEX('%<BR><font face%', wkf.body) = 0 then PATINDEX('%</BODY>%', wkf.body) - PATINDEX('%<BODY>%', wkf.body) + len('<BODY>')
                ELSE (PATINDEX('%<BR><font%', wkf.body) - Len('<BR><fon')) - PATINDEX('%<BODY>%', wkf.body) + len('<BODY>')
                END) AS Message,
	wkf.senddate,
	usr.textsignature
FROM OW.tblOWWorkFlowDistribution wkf LEFT OUTER JOIN OW.tblUser usr ON (wkf.FromAddrID = usr.UserID)
WHERE
wkf.OWWorkFlowDistributionid=@OWWorkFlowDistributionID
ORDER BY wkf.StageNumber ASC	
	RETURN @@ERROR 



GO



/****** Object:  Stored Procedure OW.usp_GetMailStagesHTML    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetMailStagesHTML
    (
        @OWWorkFlowDistributionID numeric
    )
AS

    SET NOCOUNT ON
    IF @OWWorkFlowDistributionID = -1
        SELECT OWWorkFlowDistributionID, Subject, usr.userDesc as UserDesc, st.StateDesc as StateDesc, wkf.StageNumber as StageNumber, ReadDate, SendDate,
            SUBSTRING(Body,
            CASE
                WHEN PATINDEX('%<BODY>%', body) = 0 THEN 1
                ELSE PATINDEX('%<BODY>%', body) + len('<BODY>')
                END,
            CASE
                WHEN PATINDEX('%<BODY>%', body) = 0 THEN DATALENGTH(body)
                WHEN PATINDEX('%<BR><font face%', body) = 0 then PATINDEX('%</BODY>%', body) - PATINDEX('%<BODY>%', body) + len('<BODY>')
                ELSE (PATINDEX('%<BR><font%', body) - Len('<BR><fon')) - PATINDEX('%<BODY>%', body) + len('<BODY>')
                END) AS Message
        FROM OW.tblOWWorkFlowDistribution wkf 
        INNER JOIN OW.tblUser usr ON (wkf.FromAddrID = usr.UserID)
        INNER JOIN OW.tblState st ON (wkf.State = st.StateID)
        ORDER BY OWWorkFlowDistributionID, StageNumber ASC
    ELSE
        SELECT OWWorkFlowDistributionID, Subject, usr.userDesc as UserDesc, st.StateDesc as StateDesc, wkf.StageNumber as StageNumber, ReadDate, SendDate,
            SUBSTRING(Body,
            CASE
                WHEN PATINDEX('%<BODY>%', body) = 0 THEN 1
                ELSE PATINDEX('%<BODY>%', body) + len('<BODY>')
                END,
            CASE
                WHEN PATINDEX('%<BODY>%', body) = 0 THEN DATALENGTH(body)
                WHEN PATINDEX('%<BR><font face%', body) = 0 then PATINDEX('%</BODY>%', body) - PATINDEX('%<BODY>%', body) + len('<BODY>')
                ELSE (PATINDEX('%<BR><font%', body) - Len('<BR><fon')) - PATINDEX('%<BODY>%', body) + len('<BODY>')
                END) AS Message
        FROM OW.tblOWWorkFlowDistribution wkf 
        INNER JOIN OW.tblUser usr ON (wkf.FromAddrID = usr.UserID)
        INNER JOIN OW.tblState st ON (wkf.State = st.StateID)
        WHERE wkf.OWWorkFlowDistributionID = @OWWorkFlowDistributionID
        ORDER BY OWWorkFlowDistributionID, StageNumber ASC





GO



/****** Object:  Stored Procedure OW.usp_GetMailStagesHTML1    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetMailStagesHTML1
(
        @OWWorkFlowDistributionID numeric,
        @OfficeWorksUser varchar(255)
)
AS
	SET NOCOUNT ON
	SELECT OWWorkFlowDistributionID, Subject, usr.userDesc as UserDesc, st.StateDesc as StateDesc, wkf.StageNumber as StageNumber, ReadDate, SendDate,
        SUBSTRING(Body,
        CASE
            WHEN PATINDEX('%<BODY>%', body) = 0 THEN 1
            ELSE PATINDEX('%<BODY>%', body) + len('<BODY>')
            END,
        CASE
            WHEN PATINDEX('%<BODY>%', body) = 0 THEN DATALENGTH(body)
            WHEN PATINDEX('%<BR><font face%', body) = 0 then PATINDEX('%</BODY>%', body) - PATINDEX('%<BODY>%', body) + len('<BODY>')
            ELSE (PATINDEX('%<BR><font%', body) - Len('<BR><fon')) - PATINDEX('%<BODY>%', body) + len('<BODY>')
            END) AS Message
    FROM OW.tblOWWorkFlowDistribution wkf 
    INNER JOIN OW.tblUser usr ON (wkf.FromAddrID = usr.UserID)
    INNER JOIN OW.tblState st ON (wkf.State = st.StateID)
    WHERE wkf.OWWorkFlowDistributionID = @OWWorkFlowDistributionID	
    ORDER BY OWWorkFlowDistributionID, StageNumber ASC	
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetNonListUsersAndGroups    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetNonListUsersAndGroups

	(
		@ObjectParentID numeric,
		@userActive bit=1
	)

AS
	SELECT userID, userDesc AS Description, 1 As ObjectType
	FROM OW.tblUser 
	WHERE (userActive=@userActive)
	AND (userID NOT IN (SELECT ObjectID 
						FROM OW.tblEntityListAccess 
						WHERE ObjectParentID=@ObjectParentID and ObjectType=1))
	UNION 
	SELECT GroupID AS userID, GroupDesc AS Description, 2 AS ObjectType
	FROM OW.tblGroups 
	WHERE (GroupID NOT IN (SELECT ObjectID 
						FROM OW.tblEntityListAccess 
						WHERE ObjectParentID=@ObjectParentID and ObjectType=2))
	ORDER BY 2 
	RETURN @@ERROR




GO



/****** Object:  Stored Procedure OW.usp_GetOtherWays    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetOtherWays
	(
		@code nvarchar(50)		
	)
AS

	SELECT 
		*
	FROM
		OW.tblDistributionType
	WHERE
		@code=GetDistribCode

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
		RETURN 1
	ELSE
		RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_GetOtherWaysFull    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetOtherWaysFull
AS

	SELECT 
		*
	FROM
		OW.tblDistributionType

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
		RETURN 1
	ELSE
		RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_GetPostalCode    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetPostalCode
	(
		@ID numeric=null,
		@Code varchar(10)=null,
		@Desc varchar(100)=null
	)
AS
	SET NOCOUNT ON 
		
	IF (@ID is not null) AND (@Code is null) AND (@Desc is null)
		BEGIN
			SELECT PostalCodeID,Code,Description
			FROM OW.tblPostalCode
			WHERE PostalCodeID=@ID 
		END
	ELSE
	BEGIN 
		IF (@ID is null) AND (@Code is null) AND (@Desc is null)
			BEGIN
				SELECT PostalCodeID,Code,Description
				FROM OW.tblPostalCode
				ORDER BY Code
			END
		ELSE 
			BEGIN
				SELECT PostalCodeID,Code,Description
				FROM OW.tblPostalCode
				WHERE (PostalCodeID=@ID OR @ID is null)
				AND   (Code=@Code OR @Code is null)
				AND   (Description=@Desc OR @Desc is null)
				ORDER BY Code
			END
	END
		
	RETURN @@ERROR






GO


CREATE PROCEDURE OW.usp_GetProfiles

	@profileID numeric,
	@profileType varchar(20)

AS

if (@profileID is null and @profileType is null)

	begin
		SELECT * FROM OW.tblProfiles ORDER BY ProfileDesc 
	end

else

	begin

			declare @whereCondition varchar(255)
			set @whereCondition = ''
			
			if (@profileID is not null)
			begin
				set @whereCondition = @whereCondition + ' ProfileID = ' + cast(@profileID as varchar)
			end

			if (@profileType is not null)
			begin
				
					if (@whereCondition != '')
						begin
							set @whereCondition = @whereCondition + ' AND '
						end
						
					set @whereCondition = @whereCondition + ' ProfileType IN( ' + cast(@profileType as varchar) +')'

			end
			
			if (@whereCondition != '')
				begin
					exec('SELECT * FROM OW.tblProfiles WHERE ' + @whereCondition + ' ORDER BY ProfileDesc')
				end
			else
				begin
					SELECT * FROM OW.tblProfiles ORDER BY ProfileDesc
				end

	end


GO


/****** Object:  Stored Procedure OW.usp_GetProfilesFields    Script Date: 28-07-2004 18:18:03 ******/
GO






/****** Object:  Stored Procedure OW.usp_GetKeywords    Script Date: 6/4/2004 15:36:46 ******/

/*** GETS A KEYWORD FROM A BOOK***/

CREATE    PROCEDURE OW.usp_GetProfilesFields
	(
	@profileID numeric
	)
AS
-- @mode numeric    /* 0 - FIELDS IN PROFILE, 1 - FIELDS NOT IN PROFILE  */
SELECT 
	OW.tblProfilesFields.ProfileId, 
	OW.tblFormFields.FormFieldKey, 
	OW.tblProfilesFields.FormFieldOrder, 
        OW.tblProfilesFields.FieldMaxChars, 
	OW.tblFormFields.fieldName
FROM    
	OW.tblFormFields LEFT OUTER JOIN
        OW.tblProfilesFields ON OW.tblFormFields.formFieldKEY = OW.tblProfilesFields.FormFieldKey AND 
        OW.tblProfilesFields.ProfileId = @profileID 
	order by OW.tblProfilesFields.formFieldOrder

Return @@ERROR
	






GO


/****** Object:  Stored Procedure OW.usp_GetRegIDFromCircMailID    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetRegIDFromCircMailID
	(@MailID numeric)
AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0
	
	SELECT 
		regid 
	FROM 
		OW.tblRegistryDistribution
	WHERE 
		ConnectID=@MailID
	
	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN 		





GO



/****** Object:  Stored Procedure OW.usp_GetRegistry    Script Date: 28-07-2004 18:18:03 ******/
GO




CREATE PROCEDURE OW.usp_GetRegistry
	(
		@regID numeric
	)
AS

	SELECT
		*, OW.tblBooks.abreviation, OW.tblBooks.designation
	FROM
		OW.tblRegistry,  OW.tblBooks
	Where 
		OW.tblRegistry.regID = @regid AND  OW.tblRegistry.bookid = OW.tblBooks.bookid  

	IF (@@ERROR <> 0)
		Return 1
	ELSE
		Return 0



GO


/****** Object:  Stored Procedure OW.usp_GetRegistryFiles    Script Date: 28-07-2004 18:18:03 ******/
GO


CREATE PROCEDURE OW.usp_GetRegistryFiles
	(
		@RegID numeric(18,0),
		@FileID numeric(18,0)=null		
	)
AS

IF @FileID is null 
	BEGIN
		SELECT tfm.FileID, tfm.FileName, tfm.FilePath 
		FROM OW.tblFileManager tfm
		WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments trd 
					WHERE trd.FileID=tfm.FileID
					AND trd.RegiD=@RegID)
	END
ELSE
	BEGIN
		SELECT tfm.FileID, tfm.FileName, tfm.FilePath 
		FROM OW.tblFileManager tfm
		WHERE EXISTS (SELECT 1 FROM OW.tblRegistryDocuments trd 
					WHERE trd.FileID=tfm.FileID
					AND trd.RegiD=@RegID
					AND trd.FileID=@FileID)

	END	
	RETURN @@ERROR	


GO



/****** Object:  Stored Procedure OW.usp_GetStandbyMailCirc    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetStandbyMailCirc
	(@Full bit)

AS
	/* SET NOCOUNT ON */
IF @Full = 0
BEGIN
select distinct OWWorkFlowDistributionID,Subject
from OW.tblOWWorkFlowDistribution wkf 
inner join OW.tblUser usr ON (wkf.FromAddrID=usr.userid)
inner join OW.tblState st ON (wkf.State=st.StateID)
where wkf.OWWorkFlowDistributionID IN ( 
	select distinct wkf2.OWWorkFlowDistributionID
	from OW.tblOWWorkFlowDistribution wkf2
	where  wkf2.Body IS NULL 
		and wkf2.State= 5 -- Em Espera
		and wkf2.OWWorkFlowDistributionID NOT IN (select wkf3.OWWorkFlowDistributionID
				     from OW.tblOWWorkFlowDistribution wkf3
				     where wkf3.state=2 -- Indeferido
				    )
)
order by Subject
END
ELSE
BEGIN
select OWWorkFlowDistributionID,Subject,usr.userDesc,st.StateDesc,wkf.StageNumber,SendDate,
substring(body,
		 PATINDEX('%<BODY>%', body)+len('<BODY>'),
	CASE
		WHEN PATINDEX('%<BODY>%', body)=0 THEN '0'
		WHEN PATINDEX('%<HR><BR><font face%', body)=0 then
			PATINDEX('%</BODY>%', body)-PATINDEX('%<BODY>%', body)+len('<BODY>')
		ELSE
		     (PATINDEX('%<HR><BR><font%', body)-Len('<HR><BR><fon'))-PATINDEX('%<BODY>%', body)+len('<BODY>')
	End) as Message
from OW.tblOWWorkFlowDistribution wkf 
inner join OW.tblUser usr ON (wkf.FromAddrID=usr.userid)
inner join OW.tblState st ON (wkf.State=st.StateID)
where wkf.OWWorkFlowDistributionID IN ( 


select distinct wkf2.OWWorkFlowDistributionID
from OW.tblOWWorkFlowDistribution wkf2
where  wkf2.Body IS NULL 
	and wkf2.State= 5 -- Em Espera
	and wkf2.OWWorkFlowDistributionID NOT IN (select wkf3.OWWorkFlowDistributionID
				     from OW.tblOWWorkFlowDistribution wkf3
				     where wkf3.state=2 -- Indeferido
				    )
)
order by OWWorkFlowDistributionID,StageNumber ASC

END
	RETURN





GO



/****** Object:  Stored Procedure OW.usp_GetStandbyMailCircShort    Script Date: 28-07-2004 18:18:03 ******/
GO





CREATE PROCEDURE OW.usp_GetStandbyMailCircShort
	(@Full bit,
	@userid numeric)

AS
	/* SET NOCOUNT ON */
IF @Full = 0
BEGIN
select OWWorkFlowDistributionID,Subject
from OW.tblOWWorkFlowDistribution wkf 
inner join OW.tblUser usr ON (wkf.FromAddrID=usr.userid)
inner join OW.tblState st ON (wkf.State=st.StateID)
where wkf.OWWorkFlowDistributionID IN ( 
	select distinct wkf2.OWWorkFlowDistributionID
	from OW.tblOWWorkFlowDistribution wkf2
	where  wkf2.Body IS NULL 
		and wkf2.State= 5 -- Em Espera
		and wkf2.OWWorkFlowDistributionID NOT IN (select wkf3.OWWorkFlowDistributionID
				     from OW.tblOWWorkFlowDistribution wkf3
				     where wkf3.state=2 -- Indeferido
				    )
)
order by Subject
END
ELSE
BEGIN
select OWWorkFlowDistributionID,Subject,usr.userDesc,st.StateDesc,wkf.StageNumber,SendDate,
substring(body,
	CASE
		WHEN PATINDEX('%<BODY>%', body)=0 THEN 1
		ELSE PATINDEX('%<BODY>%', body)+len('<BODY>')
		END,
	CASE
		WHEN PATINDEX('%<BODY>%', body)=0 THEN DATALENGTH(body)
		WHEN PATINDEX('%<BR><font face%', body)=0 then
			PATINDEX('%</BODY>%', body)-PATINDEX('%<BODY>%', body)+len('<BODY>')
		ELSE
		     (PATINDEX('%<BR><font%', body)-Len('<BR><fon'))-PATINDEX('%<BODY>%', body)+len('<BODY>')
	End) as Message
from OW.tblOWWorkFlowDistribution wkf 
inner join OW.tblUser usr ON (wkf.FromAddrID=usr.userid)
inner join OW.tblState st ON (wkf.State=st.StateID)
where wkf.OWWorkFlowDistributionID IN ( 


select distinct wkf2.OWWorkFlowDistributionID
from OW.tblOWWorkFlowDistribution wkf2
where  wkf2.Body IS NULL 
	and wkf2.State= 5 -- Em Espera
	and wkf2.OWWorkFlowDistributionID NOT IN (select wkf3.OWWorkFlowDistributionID
				     from OW.tblOWWorkFlowDistribution wkf3
				     where wkf3.state=2 -- Indeferido
				    )
)
and @userid IN (select wkf4.FromAddrID
		       from OW.tblOWWorkFlowDistribution wkf4
		       where wkf4.OWWorkFlowDistributionID=wkf.OWWorkFlowDistributionID)
order by OWWorkFlowDistributionID,StageNumber ASC

END

	RETURN





GO



/****** Object:  Stored Procedure OW.usp_GetTempEntities    Script Date: 28-07-2004 18:18:03 ******/
GO



/****** Object:  Stored Procedure OW.usp_GetTempEntities    Script Date: 3/17/2004 5:28:47 PM ******/




CREATE PROCEDURE OW.usp_GetTempEntities
	(
		@GUID	nvarchar(250),
		@EntityName nvarchar(250),
		@EntityType bit,
        @EntityContactID nvarchar(250)
	)
AS
	 If @EntityContactID = ''
	 BEGIN
		 If @EntityName = ''
			BEGIN
				SELECT EntID,entityName, entityType, ContactID FROM  tblEntitiesTemp WHERE Guid Like @GUID
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RETURN @@ERROR
				END
			END
		ELSE
			BEGIN			
				 SELECT EntID,entityName, entityType, ContactID FROM  tblEntitiesTemp WHERE Guid Like @GUID  AND entityName=@EntityName AND EntityType=@EntityType
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RETURN @@ERROR
				END
			END
	END
	ELSE
		BEGIN
			 SELECT EntID,entityName, entityType, ContactID FROM tblEntitiesTemp WHERE Guid Like @GUID AND ContactID Like @EntityContactID AND EntityType=@EntityType
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
		END
	
	COMMIT TRANSACTION
	RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_GetTextSign    Script Date: 28-07-2004 18:18:03 ******/
GO



CREATE PROCEDURE OW.usp_GetTextSign
	(
		@login varchar(900)
	)
AS
	SET NOCOUNT ON 
	
	SELECT TextSignature
	FROM OW.tblUser
	WHERE userlogin =@login 
	return @@ERROR	



GO

CREATE PROCEDURE OW.usp_GetUserInfo
AS
    SELECT userLogin, userDesc, userMail, userActive FROM OW.tblUser
    ORDER BY userLogin





GO



/****** Object:  Stored Procedure OW.usp_GetUserPersistence    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_GetUserPersistence
	(
		@UserID numeric
	)
AS
	/* SET NOCOUNT ON */
	SELECT
		 formFieldKEY,fieldValue, 
		formFieldKEY,fieldValue2 
	FROM 
		OW.tblUserPersistence
	WHERE 
		UserID=@UserID

	RETURN @@ERROR



GO



/****** Object:  Stored Procedure OW.usp_GetUserPersistenceConfigOthers    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_GetUserPersistenceConfigOthers
(@UserID numeric)
AS

	SELECT formFieldKEY
	FROM OW.tblUserPersistenceConfig
	WHERE (formFieldKEY=1 OR formFieldKEY=2 OR formFieldKEY=3 OR formFieldKEY=10)
	AND UserID=@UserID

	RETURN @@ERROR





GO


/****** Object:  Stored Procedure OW.usp_GetUserPersistenceKeep    Script Date: 28-07-2004 18:18:04 ******/
GO

CREATE PROCEDURE OW.usp_GetUserPersistenceKeep
	(@UserID numeric)
AS
	SELECT a.formFieldKEY, f.FieldName
	FROM OW.tblUserPersistenceConfig a LEFT JOIN OW.tblFormFields f ON 
		(a.formFieldKEY=f.formFieldKEY)
	WHERE  a.UserID=@UserID

	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_GetUserPersistenceNotKeep    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_GetUserPersistenceNotKeep
	(@UserID numeric)
AS
	SELECT formFieldKEY, FieldName
	FROM OW.tblFormFields
	WHERE formFieldKEY NOT IN (SELECT formFieldKEY 
							   FROM OW.tblUserPersistenceConfig
							   WHERE UserID=@UserID)
	RETURN @@ERROR

GO






/****** Object:  Stored Procedure OW.usp_GetUserRoles    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_GetUserRoles
	(
		@UserID numeric(18)
	)
AS

	SELECT UserID, ObjectParentID, ObjectID, ObjectTypeID
	FROM OW.tblaccess a
	WHERE UserID = @UserID
	And ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	ORDER BY ObjectParentID

	RETURN @@ERROR


GO

/*********************** PROCEDURE OW.usp_GetUsersByGroup **************************/ 
GO
CREATE   PROCEDURE OW.usp_GetUsersByGroup (
	@GroupID as numeric
)
AS

SELECT     OW.tblGroupsUsers.GroupID, OW.tblUser.*
FROM       OW.tblGroupsUsers RIGHT OUTER JOIN
           OW.tblUser ON 
	   OW.tblGroupsUsers.UserID = OW.tblUser.userID AND 
	   OW.tblGroupsUsers.GroupID = @GroupID 
	   ORDER BY OW.tblUser.userDesc

GO



/****** Object:  Stored Procedure OW.usp_GetUsersById    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_GetUsersById

	@usersList text

AS

select * from OW.tblUser usr where exists 
(select 1 from OW.fnListToTable(@usersList, ',') list where usr.userID = list.value)

GO


/****** Object:  Stored Procedure OW.usp_GetUsersByProduct    Script Date: 28-07-2004 18:18:04 ******/
GO
CREATE PROCEDURE OW.usp_GetUsersByProduct
	(
		@Product numeric(18,0),
		@Active bit = null
	)
AS

IF @Active is null
BEGIN
	SELECT a.ObjectID as Role, a.userID, u.userLogin, u.userDesc, u.userMail 
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID 
	ORDER BY  u.userDesc
END
ELSE
BEGIN
	SELECT a.ObjectID as Role, a.userID, u.userLogin, u.userDesc, u.userMail 
	FROM OW.tblaccess a, OW.tbluser u 
	WHERE a.ObjectParentID=@Product 
	And a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
	AND u.userID=a.UserID
	AND u.userActive=@Active
	ORDER BY  u.userDesc

END

RETURN @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_GetUsersPrimaryGroup    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_GetUsersPrimaryGroup

	@mode bit

AS

	if (@mode = 1) /***Users with a primary group assigned ***/

		begin
			SELECT 
				usr.userid,
				usr.userdesc,
				grp.GroupID,
				grp.Groupdesc,
				(select distinct 1 from OW.tblAccessReg reg where reg.HierarchicalUserID = usr.UserID) as HasHierarchicalAccess
			FROM
				OW.tblUser usr, 
				OW.tblGroups grp
			WHERE 
				usr.PrimaryGroupID IS NOT NULL  
				AND usr.PrimaryGroupID = grp.GroupID
 		end

	ELSE /***Users that do NOT have a primary group assigned ***/

		begin
			
			SELECT 
				usr.userid,
				usr.userdesc,
				grp.GroupID,
				grp.Groupdesc,
				(select distinct 1 from OW.tblAccessReg reg where reg.HierarchicalUserID = usr.UserID) as HasHierarchicalAccess
			FROM
				OW.tblUser usr, 
				OW.tblGroups grp
			WHERE 
				usr.PrimaryGroupID IS NOT NULL  
		end
	
Return @@ERROR

GO





/****** Object:  Stored Procedure OW.usp_MailCircFull    Script Date: 28-07-2004 18:18:04 ******/
GO



CREATE PROCEDURE OW.usp_MailCircFull
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
	/* SET NOCOUNT ON */

select OWWorkFlowDistributionID,Subject,usr.userDesc,st.StateDesc,wkf.StageNumber,SendDate,
substring(body,
		 PATINDEX('%<BODY>%', body)+len('<BODY>'),

	CASE
		WHEN PATINDEX('%<BODY>%', body)=0 THEN '0'
		WHEN PATINDEX('%<HR><BR><font face%', body)=0 then
			PATINDEX('%</BODY>%', body)-PATINDEX('%<BODY>%', body)+len('<BODY>')
		ELSE
		     (PATINDEX('%<HR><BR><font%', body)-Len('<HR><BR><fon'))-PATINDEX('%<BODY>%', body)+len('<BODY>')
	End) as Body
from OW.tblOWWorkFlowDistribution wkf 
inner join OW.tblUser usr ON (wkf.FromAddrID=usr.userid)
inner join OW.tblState st ON (wkf.State=st.StateID)
order by OWWorkFlowDistributionID,StageNumber ASC

	RETURN 





GO



/****** Object:  Stored Procedure OW.usp_ModifyClassification    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_ModifyClassification
	(
		@ClassID numeric,
		@LevelCode varchar(50),
		@LevelDesc varchar(100),
		@Tipo varchar(50),
		@Level numeric,
		@Books varchar(4000)
	)
AS
	DECLARE @strSQL varchar(250)
	DECLARE @CustomError bit			
	DECLARE @Pos NUMERIC
	DECLARE @BookID varchar(10)

	
	SET @CustomError = 0
	
	BEGIN TRANSACTION
	
	IF @Level = 1
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level1 = @LevelCode AND ClassID <> @ClassID AND Level2 IS NULL) = 0
		BEGIN
			--fazer o update
			UPDATE OW.tblClassification 
			SET Level1Desig = @LevelDesc,
			Level1 = @LevelCode
			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
			UPDATE OW.tblClassification
			SET	Tipo = @Tipo
			WHERE ClassID = @ClassID

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
			--apagar os livros associados
			DELETE FROM OW.tblClassificationBooks WHERE ClassID = @ClassID
			
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @@ERROR
			END
			--inserir novamente os livros apenas se for 'private'
			IF @Tipo = 'Private'
			BEGIN
				SET @Books = LTRIM(RTRIM(@Books))+ ','
				SET @Pos = CHARINDEX(',', @Books, 1)
				
				IF REPLACE(@Books, ',', '') <> ''
				BEGIN
					WHILE @Pos > 0
					BEGIN
						SET @BookID = LTRIM(RTRIM(LEFT(@Books, @Pos - 1)))
						IF @Books <> ''
						BEGIN
							--Print BookID
							INSERT INTO OW.tblClassificationBooks (ClassID, BookID)
							VALUES (@ClassID, CAST(@BookID as NUMERIC))

							IF @@ERROR <> 0
							BEGIN
								ROLLBACK TRANSACTION
								RETURN @@ERROR
							END
						END
						SET @Books = RIGHT(@Books, LEN(@Books) - @Pos)
						SET @Pos = CHARINDEX(',', @Books, 1)
					END
				END	
			END
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END
	END
	
	IF @Level = 2
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level2 = @LevelCode AND ClassID <> @ClassID AND Level3 IS NULL
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level2Desig = @LevelDesc,
			Level2 = @LevelCode
			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END
	END
	IF @Level = 3
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level3 = @LevelCode AND ClassID <> @ClassID AND Level4 IS NULL
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level3Desig = @LevelDesc,
			Level3 = @LevelCode
			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)
		END
		ELSE
		BEGIN
			print 'entrou no 3'
			SET @CustomError = 1
		END	
	END
	IF @Level = 4
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level4 = @LevelCode AND ClassID <> @ClassID AND Level5 IS NULL
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level4Desig = @LevelDesc,
			Level4 = @LevelCode

			WHERE Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level4 = (SELECT Level4 FROM OW.tblClassification WHERE ClassID = @ClassID)
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END	
	END
	IF @Level = 5
	BEGIN
		IF (SELECT Count(*) FROM OW.tblClassification 
			WHERE Level5 = @LevelCode AND ClassID <> @ClassID
			AND Level1 = (SELECT Level1 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level2 = (SELECT Level2 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level3 = (SELECT Level3 FROM OW.tblClassification WHERE ClassID = @ClassID)
			AND Level4 = (SELECT Level4 FROM OW.tblClassification WHERE ClassID = @ClassID)) = 0
		BEGIN
			-- fazer o update
			UPDATE OW.tblClassification 
			SET Level5Desig = @LevelDesc,
			Level5 = @LevelCode
			WHERE ClassID = @ClassID
		END
		ELSE
		BEGIN
			SET @CustomError = 1
		END	
	END

	IF @CustomError = 0
	BEGIN
		IF @@ERROR = 0
		BEGIN
			COMMIT TRANSACTION
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION
		END
		RETURN @@ERROR
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Já existe classificação com esse código.', 11, 1)
	END


GO

/****** Object:  Stored Procedure OW.usp_MoveDistributionsToTable    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_MoveDistributionsToTable

	(
		@REGID numeric,
		@GUID varchar(32)
	)

AS
	BEGIN TRANSACTION

	-- DELETES THE EXISTING DISTRIBUTIONS FROM THE DISTRIBUTION TABLE
	DELETE FROM OW.tblRegistryDistribution WHERE RegID= @regID 

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END

	-- TRANSFER THE TEMPORARY DISTRIBUTIONS TO THE DISTRIBUTION TABLE
	INSERT INTO 
		OW.tblRegistryDistribution (regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, state, ConnectID) 
	SELECT 
		regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, state, ConnectID
	FROM 
		OW.tblDistribTemp
	WHERE GUID=@GUID

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	-- DELETES THE EXISTING TEMPORARY DISTRIBUTIONS FROM THE TEMPORARY DISTRIBUTION TABLE
	DELETE FROM OW.tblDistribTemp WHERE GUID= @GUID 

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 3
	END

	/*-- Create temporary entities
	INSERT INTO  
		OW.tblDistributionEntities (DistribID, EntID, Tmp)
	SELECT  
		d.tmpid as DistribID,e.EntID, 1 As Tmp
	FROM 
		OW.tblDistribTemp d INNER JOIN OW.tblDistributionEntities e ON (d.id=e.DistribID)
	WHERE 
		e.DistribID IN (SELECT ID FROM OW.tblRegistryDistribution WHERE regid=@REGID )

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END*/

	--COMMIT TRANSACTION
	COMMIT TRANSACTION
	RETURN 0





GO



/****** Object:  Stored Procedure OW.usp_MoveDistributionsToTemp    Script Date: 28-07-2004 18:18:04 ******/
GO





CREATE PROCEDURE OW.usp_MoveDistributionsToTemp
	(
		@REGID numeric,
		@GUID varchar(32)
	)
AS
    --  Is there any distribution?
    IF (	SELECT 
				COUNT(*) As Tot 
			FROM 
				OW.tblRegistryDistribution 
			WHERE 
				RegID= @regID ) >0 
		BEGIN	

			BEGIN TRANSACTION

			-- Transfer distributions to temporary table	
			INSERT INTO 
				OW.tblDistribTemp	(ID,OLD,GUID,regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, txtEntidadeID, state, ConnectID, Dispatch) 
			SELECT 
				ID,1 as OLD, @GUID as GUID, regid,UserID, DistribDate, DistribObs, Tipo, radioVia, chkFile, DistribTypeID, txtEntidadeID, state, ConnectID, Dispatch
			FROM 
				OW.tblRegistryDistribution 
			WHERE RegID= @regID
			
			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RETURN 1
			END

			/*-- Create temporary entities
			INSERT INTO  
				OW.tblDistributionEntities (DistribID, EntID, Tmp)
			SELECT  
				d.tmpid as DistribID,e.EntID, 1 As Tmp
			FROM 
				OW.tblDistribTemp d INNER JOIN OW.tblDistributionEntities e ON (d.id=e.DistribID)
			WHERE 
				e.DistribID IN (SELECT ID FROM OW.tblRegistryDistribution WHERE regid=@REGID )*/

			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RETURN 2
			END

			--COMMIT TRANSACTION
			COMMIT TRANSACTION
			RETURN 0
		END
	ELSE
		RETURN 0





GO
/*** INSERTS A NEWBOOK***/

CREATE  PROCEDURE OW.usp_NewBook

	(
		@Abreviation varchar(50) = NULL,
		@Designation varchar(100) = NULL,
		@Automatic bit = 1,
		@hierarchical bit = 1,
		@BookID int output
	)

AS
	INSERT INTO
		OW.tblBooks (Abreviation,Designation, Automatic, hierarchical) 
	VALUES
		(@Abreviation, @Designation, @Automatic, @hierarchical) 
	
	SET @BookID = @@IDENTITY

RETURN @@ERROR	

GO

CREATE PROCEDURE OW.usp_NewContact

	(@FirstName varchar(50)='', 
	@MiddleName varchar(300)='',
	@LastName varchar(50)='', 
	@ListID numeric=null,
	@BI numeric=null, 
	@NumContribuinte numeric=null, 
	@AssociateNum numeric=null,
	@eMail varchar(300)='',
	@JobTitle varchar(100)='', 
	@Street  varchar(500)='',
	@PostalCodeID numeric=null,	
	@CountryID numeric=null,
	@Phone  varchar(20)='', 
	@Fax  varchar(20)='', 
	@Mobile  varchar(20)='',
	@DistrictID numeric=null,
	@EntityID numeric = null,
	@User varchar(900),
	@EntID NUMERIC OUTPUT, /* Return new contact ID */
	@type tinyint=1
	)

AS

DECLARE @UID numeric

SELECT @UID=userid from OW.tblUser where upper(userLogin)=upper(@User)

	INSERT INTO OW.tblEntities (FirstName, MiddleName,LastName, ListID,
									 BI, NumContribuinte, AssociateNum,eMail,JobTitle, Street,
									 PostalCodeID, CountryID, Phone, Fax, Mobile, DistrictID,EntityID,active, CreatedBy,CreatedDate,type)
	VALUES (ltrim(rtrim(@FirstName)), ltrim(rtrim(@MiddleName)),ltrim(rtrim(@LastName)), 
			@ListID, @BI, @NumContribuinte, @AssociateNum, ltrim(rtrim(@eMail)), 
			ltrim(rtrim(@JobTitle)), ltrim(rtrim(@Street)), @PostalCodeID, @CountryID, 
			ltrim(rtrim(@Phone)), ltrim(rtrim(@Fax)), ltrim(rtrim(@Mobile)),
			@DistrictID,@EntityID,1,@UID,getdate(),@type)
	IF (@@ERROR <> 0)
		return @@ERROR
	
	SET @EntID=@@IDENTITY
	
	RETURN @@ERROR

GO


/****** Object:  Stored Procedure OW.usp_NewContactList    Script Date: 28-07-2004 18:18:04 ******/
GO




CREATE PROCEDURE OW.usp_NewContactList
	(
	 @Desc varchar(100),
	 @global bit
	 )
AS
	INSERT INTO OW.tblEntityList (Description,global)
	VALUES (@Desc,@global)
	RETURN @@ERROR
	 

GO

CREATE PROCEDURE OW.usp_GetDistributionAutomatic

	@fieldID numeric=null,
	@fieldValue numeric=null

AS

SELECT 
AutoDistribID as DistribID,
TypeID as Tipo,
FieldID,
FieldValue,
WayID as radioVia,
SendFiles as chkFile,
DistribObs,
DistribTypeID,
DispatchID as dispatch,
getdate() as DistribDate,
'' as UserDesc,
1 as State
FROM OW.tblDistributionAutomatic
WHERE (FieldID = @fieldID OR @fieldID is null) AND
(FieldValue = @fieldValue OR @fieldValue is null)


GO

CREATE PROCEDURE OW.usp_GetDistributionAutomaticReport
As 
SET CONCAT_NULL_YIELDS_NULL OFF

SELECT 
CASE WHEN fieldID=10 THEN 'Livro'
WHEN fieldID=20 THEN 'Tipo Documento' 
WHEN fieldID=6 THEN 'Classificação' 
END as Campo,
CASE WHEN fieldID=10 THEN tb.designation
WHEN fieldID=20 THEN  tdt.designation
WHEN fieldID=6 THEN  tc.level1 + ' ' + tc.level2 + ' ' +  tc.level3 + ' ' +  tc.level4 + ' ' +  tc.level5
END as Designação,
COUNT(*) as Quantidade,
CASE WHEN TypeID='1' then 'Correio Electónico'
WHEN TypeID='2' then 'Outras Vias'
WHEN TypeID='3' then 'SAP'
WHEN TypeID='4' then 'ULTIMUS'
WHEN TypeID='5' then 'WorkFlow'
WHEN TypeID='6' then 'WorkFlow'
END as Tipo
FROM OW.tblDistributionAutomatic LEFT JOIN OW.tblbooks tb ON (fieldValue=bookid AND fieldID=10)
LEFT JOIN OW.tblDocumentType tdt ON (fieldValue=doctypeid AND fieldID=20)
LEFT JOIN OW.tblClassification tc ON (classid=fieldValue AND fieldID=6)
GROUP BY FieldID,fieldValue,tb.designation,tdt.designation,tc.level1,tc.level2,tc.level3,tc.level4,tc.level5,TypeID
HAVING fieldValue > 0
ORDER BY Campo,Designação

RETURN @@ERROR
GO



GO
/****** Object:  Stored Procedure OW.usp_NewDistributionAutomaticToTemporary    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_NewDistributionAutomaticToTemporary

	@bookID numeric = null,
	@classificationID numeric = null,
	@documentTypeID numeric = null,
	@guid nchar(32),
	@userID numeric

AS


DECLARE @DISTRIBUTION_OTHER_WAYS NUMERIC
SET @DISTRIBUTION_OTHER_WAYS = 2

SET XACT_ABORT ON

BEGIN TRANSACTION

INSERT INTO OW.tblDistribTemp 
(GUID, Tipo, DistribObs, radioVia, chkFile, DistribTypeID, 
regID, DistribDate, UserID, OLD, State, ConnectID, ID, dispatch, AutoDistrib,AutoDistribID)

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
AutoDistribID
FROM OW.tblDistributionAutomatic
WHERE ((FieldValue = @bookID and FieldID = 10) or 
	(FieldValue = @classificationID and FieldID = 6) or 
	(FieldValue = @documentTypeID and FieldID = 20))


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



/****** Object:  Stored Procedure OW.usp_NewDocumentType    Script Date: 28-07-2004 18:18:04 ******/
GO


/****** Object:  Stored Procedure OW.usp_NewDocumentType   Script Date: 12/4/2004 16:36:46 ******/

/*** INSERTS A NEW DOCUMENT TYPE ***/

CREATE PROCEDURE OW.usp_NewDocumentType

	(
		@abreviation varchar(50) = NULL,
		@designation varchar(50) = NULL,
		@global bit = 1
	)

AS
	INSERT INTO
		OW.tblDocumentType	 (abreviation, designation, [global])
	VALUES
		(@abreviation, @designation,  @global )
	

RETURN @@ERROR

GO



/****** Object:  Stored Procedure OW.usp_NewElectronicMail    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_NewElectronicMail
	(
		@FromUserID numeric(18,0),
		@Subject varchar(500),
		@Message Text,
		@FileID Text=null,
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
IF (@FileID is not null)
BEGIN
	DECLARE FilesID_cursor CURSOR
	FOR SELECT * FROM OW.fnlisttotable(@FileID,',')

	OPEN FilesID_cursor
	FETCH NEXT FROM FilesID_cursor INTO @ID,@Value

	WHILE @@FETCH_STATUS=0
	BEGIN
		
		INSERT INTO OW.tblElectronicMailDocuments (MailID, FileID)
		VALUES (@MailID,Cast(@Value as numeric(18,0)))	
		FETCH NEXT FROM FilesID_cursor INTO @ID,@Value
	END
	CLOSE FilesID_cursor
	DEALLOCATE FilesID_cursor
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



/****** Object:  Stored Procedure OW.usp_NewFile    Script Date: 28-07-2004 18:18:04 ******/
GO


CREATE PROCEDURE OW.usp_NewFile
	(
		@Name varchar(300),		
		@FileServer as varchar(4000),
		@UserID numeric(18,0),
		@Extension varchar(10)=null
	)
AS
DECLARE @FileID numeric(18,0)
DECLARE @lFileID bigint
DECLARE @hexstring varchar(20)
DECLARE @vb varbinary(10)
DECLARE @strPathName as varchar(500)

BEGIN TRANSACTION

	INSERT INTO OW.tblFileManager (FileName,FilePath,CreateDate,CreateUserID) 
	VALUES (@Name,' ',GetDate(),@UserID)

SET @FileID=@@IDENTITY

SELECT @lFileID=CAST(@FileID as bigint)
SELECT @vb=CAST(@lFileID as varbinary)
EXEC master.dbo.xp_varbintohexstr @vb, @hexstring OUT

SET @hexstring=SUBSTRING(@hexstring,LEN(@hexstring)-7,LEN(@hexstring))
SET @strPathName=SUBSTRING(@hexstring,1,2) + '\'
SET @strPathName= @strPathName + SUBSTRING(@hexstring,3,2) + '\'
SET @strPathName= @strPathName + SUBSTRING(@hexstring,5,2) + '\'
SET @strPathName= @strPathName + SUBSTRING(@hexstring,7,2) 

IF (@Extension IS NULL)
BEGIN
	UPDATE  OW.tblFileManager SET FilePath=@FileServer + '\' + @strPathName
	WHERE FileID=@FileID
	
	SELECT @FileServer + '\' + @strPathName  As PathName, @FileID as FileID
END
ELSE
BEGIN
	UPDATE  OW.tblFileManager SET FilePath=@FileServer + '\' + @strPathName + @Extension
	WHERE FileID=@FileID
	SELECT @FileServer + '\' + @strPathName + @Extension As PathName, @FileID as FileID
END


COMMIT TRANSACTION

	RETURN @@ERROR
	

GO



/****** Object:  Stored Procedure OW.usp_NewKeyword    Script Date: 28-07-2004 18:18:04 ******/
GO


/****** Object:  Stored Procedure OW.usp_NewKeyword   Script Date: 6/4/2004 16:36:46 ******/

/*** INSERTS A NEW KEYWORD ***/

CREATE PROCEDURE OW.usp_NewKeyword

	(
		@designation varchar(50) = NULL,
		@global bit = 1
	)

AS
	INSERT INTO
		OW.tblKeywords	 (keydescription, [global])
	VALUES
		(@designation,  @global )
	

RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_NewListValues    Script Date: 28-07-2004 18:18:04 ******/
GO



CREATE  PROCEDURE OW.usp_NewListValues
	(
		@FormFieldKey numeric,
		@list as ntext
	)
AS

	SET XACT_ABORT ON

	BEGIN TRANSACTION

		DELETE FROM OW.tblListValues  WHERE FormFieldKey = @FormFieldKey
		IF @list is not null
		BEGIN
			INSERT OW.tblListValues Select cast(value as numeric), @FormFieldKey from OW.fnListToTable(@list, ',')
		END
		
	COMMIT TRANSACTION
	RETURN 0


GO



/****** Object:  Stored Procedure OW.usp_NewPostalCode    Script Date: 28-07-2004 18:18:04 ******/
GO



CREATE PROCEDURE OW.usp_NewPostalCode
	(
		@Code varchar(10),
		@Desc varchar(100)
	)
AS
	SET NOCOUNT ON 
	
	INSERT OW.tblpostalcode (code, Description)
	VALUES (@Code,@Desc)
	return @@ERROR
	


GO



/*** INSERTS A NEW Profile ***/

CREATE PROCEDURE OW.usp_NewProfile

	(
		@profiledesc varchar(100) = NULL,
		@NumOfDistrib numeric = 0 , 
		@NumOfStages numeric = 0 , 
		@NumOfSecundaryEntities numeric = 0 , 
		@profileType numeric = 1 
	)
AS
	INSERT INTO
		OW.tblProfiles	 (profiledesc, NumOfDistrib, NumOfStages, NumOfSecundaryEntities, profileType)
	VALUES
		(@profiledesc, @NumOfDistrib, @NumOfStages, @NumOfSecundaryEntities, @profileType)
	

RETURN @@ERROR	

GO



/****** Object:  Stored Procedure OW.usp_SetBook    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATED A  Book ***/

CREATE PROCEDURE OW.usp_SetBook
	(
		@bookID numeric,
		@Abreviation varchar(20) = NULL,
		@Designation varchar(100) = NULL,
		@Automatic bit = 0,
		@hierarchical bit = 0
	)

AS
	UPDATE 
		OW.tblBooks
	SET
		Abreviation=@Abreviation, Designation=@Designation, Automatic=@Automatic, hierarchical=@hierarchical 
	WHERE
		bookID=@bookID
	
	
	RETURN @@ERROR	


GO


/****** Object:  Stored Procedure OW.usp_SetBookDocumentType    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATES A DOCUMENT TYPE OF A BOOK***/

CREATE PROCEDURE OW.usp_SetBookDocumentType
	(
		@doctypeID numeric,
		@bookid numeric
	)

AS
	/** ADDS THE DOCUMENT TYPE TH THE GIVEN BOOK **/
	INSERT INTO
		OW.tblBooksDocumentType (documentTypeID,bookid) 
	VALUES 
		(@doctypeID , @bookid)
	

	RETURN @@ERROR	


GO


/****** Object:  Stored Procedure OW.usp_SetBookKeyword    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATES A  KEYWORD OF A BOOK***/
GO
CREATE PROCEDURE OW.usp_SetBookKeyword
	(
		@keyID numeric,
		@bookid numeric
	)

AS
	/** ADDS THE KEYWORD TH THE GIVEN BOOK **/
	INSERT INTO
		OW.tblBooksKeyword (keywordID,bookid) 
	VALUES 
		(@keyid,@bookid)
	

	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetContact    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetContact
	(@EntID numeric,
	@FirstName varchar(50)='', 
	@MiddleName varchar(300)='',
	@LastName varchar(50)='', 
	@ListID numeric=null,
	@BI numeric=null, 
	@NumContribuinte numeric=null, 
	@AssociateNum numeric=null,
	@eMail varchar(300)='',
	@JobTitle varchar(100)='', 
	@Street  varchar(500)='',
	@PostalCodeID numeric=null,	
	@CountryID numeric=null,
	@Phone  varchar(20)='', 
	@Fax  varchar(20)='', 
	@Mobile  varchar(20)='',
	@DistrictID numeric=null,
	@EntityID numeric=null,
	@User varchar(900),
	@Active bit=1
	)

AS

DECLARE @UID numeric

SELECT @UID=userid from OW.tblUser where upper(userLogin)=upper(@User)

	UPDATE OW.tblEntities 
	SET FirstName=ltrim(rtrim(@FirstName)), 
		MiddleName=ltrim(rtrim(@MiddleName)),LastName=ltrim(rtrim(@LastName)), 
		ListID=@ListID, BI=@BI, NumContribuinte=@NumContribuinte, 
		AssociateNum=@AssociateNum,eMail=ltrim(rtrim(@eMail)),
		JobTitle=ltrim(rtrim(@JobTitle)), 
		Street=ltrim(rtrim(@Street)),PostalCodeID=@PostalCodeID, CountryID=@CountryID, 
		Phone=ltrim(rtrim(@Phone)), Fax=ltrim(rtrim(@Fax)), Mobile=ltrim(rtrim(@Mobile)), 
		DistrictID=@DistrictID, EntityID=@EntityID,
		active=@Active, ModifiedBy=@UID, ModifiedDate=getdate()
	WHERE EntID=@EntID

	RETURN @@ERROR





GO



/****** Object:  Stored Procedure OW.usp_SetContactState    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetContactState
	(
		@EntID numeric,
		@State bit
	)
AS
	UPDATE OW.tblEntities
	SET Active=@State
	WHERE EntID=@EntID
	RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_SetDispatch    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetDispatch
	(
		@abreviation nvarchar(20),
		@designation nvarchar(100),
		@global bit
	)
AS
 
	INSERT INTO tblDispatch
		 (abreviation, designation, [global]) 
	VALUES 
		(@abreviation, @designation, @global)
    
	RETURN



GO

/****** Object:  Stored Procedure OW.usp_SetDispatchBook    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetDispatchBook
	(
		@bookID numeric,
		@dispatchID numeric
	)
AS
 
	INSERT INTO tblDispatchBook
		 (bookID, dispatchID) 
	VALUES 
		(@bookID, @dispatchID)
    
	RETURN



GO

/*************************** OW.usp_SetDistributionAutomaticEntity ****************************/
CREATE PROCEDURE OW.usp_SetDistributionAutomaticEntity

	(	
		@AutoDistribID numeric,
		@entID numeric
	)

AS			
	if (select count(*) from OW.tblDistributionAutomaticEntities where AutoDistribID = @AutoDistribID and EntID = @entID) = 0 
	BEGIN
		INSERT INTO tblDistributionAutomaticEntities (AutoDistribID, EntID) VALUES (@AutoDistribID,@entID)
	END

	RETURN @@ERROR
GO

/****** Object:  Stored Procedure OW.usp_SetDistributionAutomatic    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetDistributionAutomatic
(
	@fieldID	numeric,
	@fieldValue	numeric,
	@typeID		numeric,
	@distribTypeID	numeric = null,
	@dispatchID	numeric = null,	
	@wayID		varchar(2),
	@sendFiles	bit = null,
	@distribObs	nvarchar(250) = '',
	@EntIds text = null
)
AS

	DECLARE @DISTRIBUTION_ELECTRONIC_MAIL  	numeric
	DECLARE @DISTRIBUTION_OTHER_WAYS 	numeric
	DECLARE @DISTRIBUTION_SAP 		numeric
	DECLARE @DISTRIBUTION_ULTIMUS 		numeric
	DECLARE @DISTRIBUTION_WORKFLOW		numeric
	
	DECLARE @ENTITYNAME 	NVARCHAR(100)
	DECLARE @ENTITYID 	NUMERIC
	DECLARE @DistribID 	NUMERIC
	DECLARE @Pos 		NUMERIC
	
	DECLARE @AutomaticDistribID NUMERIC
	DECLARE @Value varchar(4000)
	
	SET @DISTRIBUTION_ELECTRONIC_MAIL = 1
	SET @DISTRIBUTION_OTHER_WAYS = 2
	SET @DISTRIBUTION_SAP = 3
	SET @DISTRIBUTION_ULTIMUS = 4
	SET @DISTRIBUTION_WORKFLOW = 6

	BEGIN TRANSACTION
	
	/* ELECTRONIC MAIL */ 
	IF (@TypeID = @DISTRIBUTION_ELECTRONIC_MAIL )  OR (@TypeID = @DISTRIBUTION_WORKFLOW)
	BEGIN
		INSERT INTO tblDistributionAutomatic
			(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs)
		VALUES 
			(@typeID, @fieldID, @fieldValue, null, null, @wayID, @sendFiles, @distribObs)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	/* OTHER WAYS */ 
	ELSE IF (@TypeID = @DISTRIBUTION_OTHER_WAYS) 
		BEGIN
			/* INSERTS THE CURRENT DISTRIBUTION */
			INSERT INTO tblDistributionAutomatic
				(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs)
			VALUES 
				(@typeID, @fieldID, @fieldValue, @distribTypeID, @dispatchID, null, null, @distribObs)
		
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 2
		END
	END
	/* SAP AND ULTIMUS */ 
	ELSE IF (@DistribTypeID = @DISTRIBUTION_SAP OR @DistribTypeID = @DISTRIBUTION_ULTIMUS ) 
	BEGIN
		INSERT INTO tblDistributionAutomatic
			(TypeID, FieldID, FieldValue, DistribTypeID, DispatchID, WayID, SendFiles, DistribObs)
		VALUES 
			(@typeID, @fieldID, @fieldValue, null, null, @wayID, @sendFiles, @distribObs)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 3
		END
	END

	SET @AutomaticDistribID = @@IDENTITY

	/* OTHER WAYS */ 
	IF (@TypeID = @DISTRIBUTION_OTHER_WAYS AND (@EntIds is not null)) 
	BEGIN
			
		DECLARE EntsID_cursor CURSOR
		FOR SELECT value FROM OW.fnlisttotable(@EntIds,',')
	
		OPEN EntsID_cursor
		FETCH NEXT FROM EntsID_cursor INTO @Value
	
		WHILE @@FETCH_STATUS=0
		BEGIN
			
			/* INSERTS THE AUTOMATIC DISTRIBUTION OTHER WAYS ENTITIES */
			INSERT INTO OW.tblDistributionAutomaticEntities
				(AutoDistribID,EntID)
			VALUES 
				(@AutomaticDistribID, CAST(@Value AS numeric))
		
			IF (@@ERROR <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RETURN 2
			END

			FETCH NEXT FROM EntsID_cursor INTO @Value
		END
		CLOSE EntsID_cursor
		DEALLOCATE EntsID_cursor			
	END
	
	SELECT @AutomaticDistribID AS TMPID
	-- COMMIT TRANSACTION
	COMMIT TRANSACTION

	RETURN 0
GO

/****** Object:  Stored Procedure OW.usp_SetDistributionState    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetDistributionState

	(
		@ID numeric,
		@state numeric
	)

AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		tblRegistryDistribution
    SET 
		state = @state
	WHERE 
		ID = @ID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN 		




GO

/****** Object:  Stored Procedure dbo.usp_SetDistributionState    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE dbo.usp_SetDistributionState

	(
		@ID numeric,
		@state numeric
	)

AS
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		tblRegistryDistribution
    SET 
		state = @state
	WHERE 
		ID = @ID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0) 
		-- Returns 0 if neither SELECT statement had an error; otherwise, returns the last error.
		RETURN @ErrorSave	
	ELSE		
		RETURN 		





GO

/****** Object:  Stored Procedure OW.usp_SetDistributionTemp    Script Date: 28-07-2004 18:18:05 ******/
GO


CREATE PROCEDURE OW.usp_SetDistributionTemp
		(
		@GUID				nvarchar(250),
		@UserID			numeric,
		@RegID			numeric,
		@TypeID			numeric,		
		@DistribTypeID			numeric,
		@RadioVia			nvarchar(250),
		@ChkFile			numeric,
		@Obs				nvarchar(250),
		@Entities			nvarchar(1000),
		@Dispatch			numeric
		)

AS
	DECLARE @DISTRIBUTION_ELECTRONIC_MAIL  	numeric
	DECLARE @DISTRIBUTION_OTHER_WAYS 				numeric
	DECLARE @DISTRIBUTION_SAP 									numeric
	DECLARE @DISTRIBUTION_ULTIMUS 						numeric
	DECLARE @DISTRIBUTION_WORKFLOW					numeric
	
	DECLARE @ENTITYNAME 	NVARCHAR(100)
	DECLARE @ENTITYID 		NUMERIC
	DECLARE @DistribID 		NUMERIC
	DECLARE @Pos 		NUMERIC
	
	SET @DISTRIBUTION_ELECTRONIC_MAIL = 1
	SET @DISTRIBUTION_OTHER_WAYS = 2
	SET @DISTRIBUTION_SAP = 3
	SET @DISTRIBUTION_ULTIMUS = 4
	SET @DISTRIBUTION_WORKFLOW = 6

	BEGIN TRANSACTION
	
	/* ELECTRONIC MAIL */ 
	IF (@TypeID = @DISTRIBUTION_ELECTRONIC_MAIL )  OR (@TypeID = @DISTRIBUTION_WORKFLOW)
	BEGIN
		INSERT INTO tblDistribTemp
			(GUID,	tipo, radioVia, chkFile, DistribDate, UserID, OLD, state, DistribObs, ConnectID, RegID)
		VALUES 
			(@GUID,  @TypeID, @RadioVia, @ChkFile, getdate(), @UserID, 0, 1, @Obs, 0, @RegID)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	END

	/* OTHER WAYS */ 
	ELSE IF (@TypeID = @DISTRIBUTION_OTHER_WAYS) 
		BEGIN
			/* INSERTS THE CURRENT DISTRIBUTION */
			INSERT INTO tblDistribTemp
				(GUID, Tipo, DistribTypeID, DistribDate, UserID, OLD, state, DistribObs, RegID, Dispatch)
			VALUES
				(@GUID, @TypeID, @DistribTypeID, getdate(), @UserID, 0, 1, @Obs, @RegID, @Dispatch)
		
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 2
		END
	END
	/* SAP AND ULTIMUS */ 
	ELSE IF (@DistribTypeID = @DISTRIBUTION_SAP OR @DistribTypeID = @DISTRIBUTION_ULTIMUS ) 
	BEGIN
		INSERT INTO tblDistribTemp
			(GUID, Tipo, DistribDate, UserID, OLD, state, RegID)
		VALUES
			 (@GUID, @TypeID, getdate(), @UserID, 0, 2, @RegID)

		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 3
		END
	END

	SELECT @@IDENTITY AS TMPID

	-- COMMIT TRANSACTION
	COMMIT TRANSACTION

	RETURN 0




GO

/****** Object:  Stored Procedure OW.usp_SetDistributionTempGUID    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetDistributionTempGUID
	(
	@OldGUID nvarchar(32),
	@NewGUID nvarchar(32)
	)
AS
	UPDATE OW.tblDistribTemp 
	SET GUID=@NewGUID
	WHERE GUID=@OldGUID
			
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_SetDistributionType    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetDistributionType
	(
		@DistribTypeID numeric,
		@DistribTypeDesc nvarchar(250),
		@DistribTypeCode nvarchar(50)
	)
AS
 
	INSERT INTO OW.tblDistributionType
		 (DistribTypeID,DistribTypeDesc,GetDistribCode) 
	VALUES 
		(@DistribTypeID, @DistribTypeDesc, @DistribTypeCode)
    
	RETURN 




GO

/****** Object:  Stored Procedure dbo.usp_SetDistributionType    Script Date: 28-07-2004 18:18:05 ******/
CREATE PROCEDURE dbo.usp_SetDistributionType
	(
		@DistribTypeID numeric,
		@DistribTypeDesc nvarchar(250),
		@DistribTypeCode nvarchar(50)
	)
AS
 
	INSERT INTO tblDistributionType
		 (DistribTypeID,DistribTypeDesc,GetDistribCode) 
	VALUES 
		(@DistribTypeID, @DistribTypeDesc, @DistribTypeCode)
    
	RETURN @@ERROR


GO

/****** Object:  Stored Procedure OW.usp_SetDocumentType    Script Date: 28-07-2004 18:18:05 ******/
GO



/****** Object:  Stored Procedure OW.usp_SetDocumentType  Script Date: 12/4/2004 16:36:46 ******/

/*** UPDATED A  DOCUMENT TYPE ***/

CREATE PROCEDURE OW.usp_SetDocumentType
	(
		@doctypeID numeric,
		@abreviation varchar(50),
		@designation varchar(50),
		@global bit=1
	)

AS
	UPDATE 
		OW.tblDocumentType
	SET
		abreviation=@abreviation, designation=@designation, [global]=@global
	WHERE
		doctypeID=@doctypeid
	
	
	RETURN @@ERROR	


GO


/****** Object:  Stored Procedure OW.usp_SetEntityDistribution    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetEntityDistribution

	(	
		@distribID numeric,
		@entID numeric
	)

AS			
	if (select count(*) from tblDistributionEntities where DistribID = @distribID and EntID = @entID and Tmp = 1) = 0 begin

		INSERT INTO tblDistributionEntities  (DistribID, EntID, Tmp) VALUES (@distribID,@entID, 1)
	end

	IF @@ERROR <> 0
			RETURN 1
	ELSE
		 RETURN 0
GO









GO

/****** Object:  Stored Procedure OW.usp_SetEntityTemp    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetEntityTemp

	(	
		@GUID nvarchar(250),
		@EntityName nvarchar(250),
		@EntityType bit,
		@EntityContactID nvarchar(250),
		@EntityCode numeric
	)

AS
			
	INSERT INTO tblEntitiesTemp (guid, EntityName, EntityType, ContactID, EntID) VALUES (@GUID, @EntityName, @EntityType, @EntityContactID, @EntityCode)

	IF @@ERROR <> 0
			RETURN 1
	ELSE
		 RETURN 0
GO

/****** Object:  Stored Procedure OW.usp_SetHierarchicalAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetHierarchicalAccess

	@regID numeric,
	@objectID numeric,
	@objectType numeric

AS

set XACT_ABORT on

declare @bookID numeric
select @bookID = BookID from OW.tblBooks books where exists
(select 1 from OW.tblRegistry registry 
where books.BookID = registry.BookID 
and registry.regID = @regID
and books.hierarchical = 1)

-- If the Book has Hierarchical Accesses active
if (@bookID is not null)
	begin

		begin transaction

		if (@objectType = 1)
			begin

				declare @groupID numeric
				select @groupID = PrimaryGroupID from OW.tblUser where userID = @objectID

				if (@groupID is not null)
					begin
						delete from OW.tblAccessReg where UserID = @groupID and ObjectID = @regID and ObjectType = 2
						insert into OW.tblAccessReg (UserID, ObjectID, ObjectType, HierarchicalUserID) 
						values (@groupID, @regID, 2, @objectID)
					end

			end

		else

			begin

				if (@objectType = 2)
					begin

						delete from OW.tblAccessReg where UserID = @groupID and ObjectID = @regID and ObjectType = 2
						insert into OW.tblAccessReg (UserID, ObjectID, ObjectType, HierarchicalUserID) 
						values (@groupID, @regID, 2, 0)

					end

			end

		commit transaction

end

GO

/****** Object:  Stored Procedure OW.usp_SetKeyword    Script Date: 28-07-2004 18:18:05 ******/
GO

/*** UPDATED A  KEYWORD ***/
GO
CREATE PROCEDURE OW.usp_SetKeyword
	(
		@keyID numeric,
		@designation varchar(50),
		@global bit=1
	)

AS
	UPDATE 
		OW.tblKeywords
	SET
		keydescription=@designation, [global]=@global
	WHERE
		keyID=@keyid
	
	
	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetList    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetList

	(
	 @ListID numeric,
	 @Desc varchar(100),
	 @global bit
	 )

AS
	UPDATE OW.tblEntityList SET Description=@Desc,global=@global
	WHERE  ListID=@ListID
	return @@ERROR
	RETURN




GO

/****** Object:  Stored Procedure OW.usp_SetListAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetListAccess
	(
		@List numeric,
		@Access text
	)
AS
DECLARE @RET_VAL numeric
SET @RET_VAL = 0 -- No ERROR

DECLARE @pos int,
@textpos  int,
@chunklen smallint,
@str      nvarchar(4000),
@tmpstr   nvarchar(4000),
@leftover nvarchar(4000),
@posInsert int,
@posInsertOld int,
@v1 numeric,
@v2 numeric,
@v3 numeric

-- Start Transaction
BEGIN TRANSACTION SetListAccessTRANS
	
-- Delete old list access

DELETE FROM OW.tblEntityListAccess
WHERE ObjectParentID=@List

	IF (@@ERROR <> 0) 
	BEGIN
		SET @RET_VAL=@@ERROR
		GOTO OnError
	END

      SET @textpos = 1
      SET @leftover = ''
      WHILE @textpos <= datalength(@Access) / 2
      BEGIN
         SET @chunklen = 4000 - datalength(@leftover) / 2
         SET @tmpstr = ltrim(@leftover + substring(@Access, @textpos, @chunklen))
         SET @textpos = @textpos + @chunklen

         SET @pos = charindex(',', @tmpstr)
         WHILE @pos > 0
         BEGIN
            SET @str = substring(@tmpstr, 1, @pos - 1)
	    -- split to get values
	    SET @posInsertOld=charindex('|', @str)
	    SET @v1 = convert(numeric,substring(@str, 1, @posInsertOld - 1))
	    SET @posInsertOld=@posInsertOld+1
	    SET @posInsert=charindex('|', @str,@posInsertOld)
	    SET @v2 = convert(numeric,substring(@str, @posInsertOld, (@posInsert - @posInsertOld)))
	    SET @posInsert=@posInsert+1
	    SET @v3 = convert(numeric,substring(@str, @posInsert, len(@str)))
	    
	    INSERT INTO OW.tblEntityListAccess (ObjectID, ObjectParentID,AccessType, ObjectType )
	    VALUES (@v1,@List,@v3,@v2)
		IF (@@ERROR <> 0) 
		BEGIN
			SET @RET_VAL=@@ERROR
			GOTO OnError
		END
            SET @tmpstr = ltrim(substring(@tmpstr, @pos + 1, len(@tmpstr)))
            SET @pos = charindex(',', @tmpstr)
         END

         SET @leftover = @tmpstr
      END

      IF ltrim(rtrim(@leftover)) <> ''
      BEGIN
         --INSERT @tbl (number) VALUES(convert(int, @leftover))
	    -- split to get values
	    SET @posInsertOld=charindex('|', @leftover)
	    SET @v1 = convert(numeric,substring(@leftover, 1, @posInsertOld - 1))
	    SET @posInsertOld=@posInsertOld+1
	    SET @posInsert=charindex('|', @leftover,@posInsertOld)
	    SET @v2 = convert(numeric,substring(@leftover, @posInsertOld, (@posInsert - @posInsertOld)))
	    SET @posInsert=@posInsert+1
	    SET @v3 = convert(numeric,substring(@leftover, @posInsert, len(@leftover)))
	    
	    INSERT INTO OW.tblEntityListAccess (ObjectID, ObjectParentID,AccessType, ObjectType )
	    VALUES (@v1,@List,@v3,@v2)
		IF (@@ERROR <> 0) 
		BEGIN
			SET @RET_VAL=@@ERROR
			GOTO OnError
		END

      END

COMMIT TRANSACTION SetListAccessTRANS
goto OnExit
	
OnError:
-- rollback
ROLLBACK TRANSACTION SetListAccessTRANS

OnExit:
RETURN @RET_VAL





GO

/****** Object:  Stored Procedure OW.usp_SetListOptionsValues    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetListOptionsValues
(
		@ID numeric,
		@Description varchar(50) = NULL
		
	)

AS
	UPDATE 
		OW.tblListOptionsValues
	SET
		Description=@Description
	WHERE
		ListID=@ID
	
	
	RETURN @@ERROR	



GO

/****** Object:  Stored Procedure OW.usp_SetMoreEnitiesTempGUID    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetMoreEnitiesTempGUID
	(
	@OldGUID nvarchar(32),
	@NewGUID nvarchar(32)
	)
AS
	UPDATE OW.tblEntitiesTemp 
	SET guid=@NewGUID
	WHERE guid=@OldGUID
		
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_SetMoreEntitiesTempGUID    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetMoreEntitiesTempGUID
	(
	@OldGUID nvarchar(32),
	@NewGUID nvarchar(32)
	)
AS
	UPDATE 
		OW.tblEntitiesTemp 
	SET 
		guid=@NewGUID
	WHERE 
		guid=@OldGUID
		
	
	IF (@@ERROR <> 0)
	BEGIN
		RETURN @@ERROR
	END
	
	RETURN 0





GO

/****** Object:  Stored Procedure OW.usp_SetPostalCode    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetPostalCode
	(
		@Code varchar(10),
		@Desc varchar(100),
		@ID numeric
	)
AS
	SET NOCOUNT ON 
	UPDATE OW.tblPostalCode SET Code=@Code, Description=@Desc
	WHERE PostalCodeID=@ID
	return @@ERROR
	


GO



/****** Object:  Stored Procedure OW.usp_SetProfile    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetProfile
	(
		@profileID numeric,
		@profiledesc varchar(100) = NULL,
		@NumOfDistrib numeric = 0 , 
		@NumOfStages numeric = 0 , 
		@NumOfSecundaryEntities numeric = 0 , 
		@profileType numeric = 1
	)

AS
	UPDATE 
		OW.tblProfiles
	SET
		profiledesc=@profiledesc, NumOfDistrib=@NumOfDistrib, NumOfStages=@NumOfStages, NumOfSecundaryEntities=@NumOfSecundaryEntities, profileType=@profileType
	WHERE
		profileID=@profileID
	
	
	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetProfilesField    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetProfilesField
	(
		@ProfileID numeric, 
		@FormfieldKey numeric, 
		@FormfieldOrder numeric, 
		@FieldMaxChars numeric  
	)

AS
	/** ADDS THE FIELD TO THE GIVEN PROFILE **/
	INSERT INTO
		OW.tblProfilesFields (ProfileID, FormfieldKey, FormfieldOrder, FieldMaxChars) 
	VALUES 
		(@ProfileID, @formfieldkey, @FormfieldOrder, @FieldMaxChars) 
	

	RETURN @@ERROR	


GO

/****** Object:  Stored Procedure OW.usp_SetRegistryAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetRegistryAccess

	@regID numeric,
	@userIDList text,
	@userTypeList text,
	@hierarchicalUserIDList text

AS

set XACT_ABORT on

begin transaction

declare @tmp table (RowID numeric, UserID numeric, ObjectID numeric, ObjectType smallint, HierarchicalUserID numeric)

insert @tmp (RowID, UserID) select listpos, value from OW.fnListToTable(@userIDList, ',')
update @tmp set ObjectType = value from OW.fnListToTable(@userTypeList, ',') where RowID = listpos
update @tmp set HierarchicalUserID = value from OW.fnListToTable(@hierarchicalUserIDList, ',') where RowID = listpos
update @tmp set ObjectID = @regID

delete from OW.tblAccessReg where ObjectID = @regID
insert OW.tblAccessReg select UserID, ObjectID, ObjectType, HierarchicalUserID from @tmp

commit transaction

GO

/****** Object:  Stored Procedure OW.usp_SetRegistryHierarchicalAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetRegistryHierarchicalAccess

	@userID numeric,
	@groupID numeric

AS

update OW.tblAccessReg set UserID = @groupID where HierarchicalUserID = @userID


GO

/****** Object:  Stored Procedure OW.usp_SetRegistryIntegration    Script Date: 28-07-2004 18:18:05 ******/
GO

/* Set the integration with the registry  AND sets the state to sucssess
	RECEIVES   :	connectid -> Mail ID, distribID -> Distribution ID
	RETURNS    :
*/
GO
CREATE PROCEDURE OW.usp_SetRegistryIntegration

	(
		@distribID numeric,
		@connectID numeric
	)

AS
	UPDATE 
		OW.tblRegistryDistribution
	SET
		OW.tblRegistryDistribution.connectid = @connectID
	WHERE
		OW.tblRegistryDistribution.ID = @distribID
	RETURN 


GO

/****** Object:  Stored Procedure OW.usp_SetRegistryRestrictAccess    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetRegistryRestrictAccess

	@newUserID numeric

AS

set xact_abort on

begin transaction

-- Change Hierarchical Access to Restrict
declare cursorAccessReg cursor 
for select * from OW.tblAccessReg where hierarchicalUserID=@newUserID

declare @userID numeric
declare @objectID numeric
declare @objectType smallint
declare @hierarchicalUserID numeric 

open cursorAccessReg
fetch next from cursorAccessReg into @userID, @objectID, @objectType, @hierarchicalUserID  

while @@fetch_status = 0
begin
	-- Is Restrict Access already defined?
	if ((select count(*) from OW.tblAccessReg where UserID = @userID and ObjectID = @objectID and ObjectType = @objectType and hierarchicalUserID = 0) > 0)
	begin
		-- Delete Hierarchical Access
		delete from OW.tblAccessReg where UserID = @userID and ObjectID = @objectID 
		and ObjectType = @objectType and hierarchicalUserID = @hierarchicalUserID
	end
	else
	begin
		-- Convert to Restrict Access
		update OW.tblAccessReg set hierarchicalUserID = 0 
		where UserID = @userID and ObjectID = @objectID 
		and ObjectType = @objectType and hierarchicalUserID = @hierarchicalUserID
	end

	fetch next from cursorAccessReg into @userID, @objectID, @objectType, @hierarchicalUserID
end

close cursorAccessReg
deallocate cursorAccessReg

commit transaction

GO

/****** Object:  Stored Procedure OW.usp_SetTextSignature    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_SetTextSignature
	(
		@Login varchar(900),
		@TextSignature varchar(300)
	)
AS
	SET NOCOUNT ON 
	UPDATE OW.tbluser
	SET TextSignature=@TextSignature
	WHERE userlogin=@Login
	return @@ERROR




GO

/****** Object:  Stored Procedure OW.usp_SetUserPersistence    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetUserPersistence

	(
		@UserID numeric,
		@formFieldKEY numeric,
		@fieldValue varchar(4000),
		@fieldValue2 varchar(4000)
	)
AS
	
	INSERT INTO OW.tblUserPersistence (
		UserID,
		formFieldKEY,
		fieldValue, 
		fieldValue2) 
	VALUES (
		@UserID,
		@formFieldKEY,
		@fieldValue,
		@fieldValue2)
		
	RETURN @@ERROR



GO

/****** Object:  Stored Procedure OW.usp_SetUserPersistenceAdmin    Script Date: 28-07-2004 18:18:05 ******/
GO

CREATE PROCEDURE OW.usp_SetUserPersistenceAdmin

	(
		@UserID numeric,
		@formFieldKEY numeric
	)
AS
	BEGIN TRANSACTION
	
	DELETE FROM OW.tblUserPersistenceConfig
	WHERE UserID=@UserID
	
	IF @@ERROR<>0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END
	
	INSERT INTO OW.tblUserPersistenceConfig (UserID,formFieldKEY)
	VALUES (@UserID,@formFieldKEY) 

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN 1
		END
	ELSE
		BEGIN
			COMMIT TRANSACTION
		END
		
	RETURN @@ERROR





GO

/****** Object:  Stored Procedure OW.usp_SetUserPrimaryGroup    Script Date: 28-07-2004 18:18:05 ******/
GO
/*** SETS A USER PRIMARY GROUP ***/
GO
CREATE PROCEDURE OW.usp_SetUserPrimaryGroup
	(
		@userID numeric,
		@groupID numeric
	)
AS
 
	UPDATE 
		OW.tblUser
	SET 
		PrimaryGroupID = @groupID
	WHERE 
		userID = @userID
    
	RETURN @@ERROR



GO


/****** Object:  Stored Procedure OW.usp_UpdateDispatch    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_UpdateDispatch
	(
		@DispatchID	numeric,
		@abreviation	nvarchar(20),
		@designation	nvarchar(100),
		@global bit
	)

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDispatch
	SET 
		abreviation=@abreviation, designation=@designation, [global]=@global
	WHERE
		dispatchID=@dispatchID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave



GO

/****** Object:  Stored Procedure OW.usp_UpdateEMailDistribution    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_UpdateEMailDistribution

	(
		@TmpID numeric,
		@Obs nvarchar(250)	
	)

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistribTemp
	SET 
		distribobs = @Obs 
	WHERE
		tmpID=@TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave





GO

/****** Object:  Stored Procedure OW.usp_UpdateEMailDistributionAutomatic    Script Date: 28-07-2004 18:18:05 ******/
GO
CREATE PROCEDURE OW.usp_UpdateEMailDistributionAutomatic

	@TmpID numeric,
	@Obs nvarchar(250)	

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistributionAutomatic
	SET 
		distribobs = @Obs 
	WHERE
		AutoDistribID = @TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave
GO
/****** Object:  Stored Procedure OW.usp_UpdateOWDistribution    Script Date: 28-07-2004 18:18:06 ******/
GO
CREATE PROCEDURE OW.usp_UpdateOWDistribution
	(
		@TmpID				numeric,
		@Obs					nvarchar(250)	,
		@DistribTypeID	numeric,
		@Dispatch			numeric
	)

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistribTemp
	SET 
		distribobs = @Obs, DistribTypeID= @DistribTypeID,  Dispatch=@Dispatch
	WHERE
		tmpID=@TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave





GO

/************************ OW.usp_DeleteDistributionAutomaticEntity **********************************/
CREATE PROCEDURE OW.usp_DeleteDistributionAutomaticEntity
	(
		@AutoDistribID NUMERIC,
		@entid NUMERIC
	)
AS
	DELETE 	FROM OW.tblDistributionAutomaticEntities
	WHERE (AutoDistribID = @AutoDistribID) AND (entID = @entid)

	RETURN @@Error
GO


/****** Object:  Stored Procedure OW.usp_UpdateOWDistributionAutomatic    Script Date: 28-07-2004 18:18:06 ******/
GO

CREATE PROCEDURE OW.usp_UpdateOWDistributionAutomatic
	
	@TmpID			numeric,
	@Obs			nvarchar(250),
	@DistribTypeID	numeric,
	@Dispatch		numeric

AS
	
	-- Declare and initialize a variable to hold @@ERROR.
	DECLARE @ErrorSave INT
	SET @ErrorSave = 0

	UPDATE 
		OW.tblDistributionAutomatic
	SET 
		DistribObs = @Obs, 
		DistribTypeID = @DistribTypeID, 
		DispatchID = @Dispatch
	WHERE
		AutoDistribID = @TmpID

	-- Save any nonzero @@ERROR value.
	IF (@@ERROR <> 0)
	SET @ErrorSave = @@ERROR

	-- Returns 0 if neither SELECT statement had
	-- an error; otherwise, returns the last error.

	RETURN @ErrorSave

GO

/****** Object:  Stored Procedure OW.usp_OWAgent    Script Date: 28-07-2004 18:18:06 ******/
GO

CREATE PROCEDURE OW.usp_OWAgent
AS
SET NOCOUNT ON
-- Disable Alarms
DECLARE  @WKFID NUMERIC
DECLARE @WKF_State INT
DECLARE @CursorVar CURSOR
DECLARE @AssociationID NUMERIC

-- Get WORKFLOW STATE --
-- Get all active alarms information
SET @CursorVar = CURSOR SCROLL DYNAMIC
FOR
SELECT a.AssociationID, a.ObjectRowID
FROM OW.tblAlarmAssociation a
WHERE a.Activated=1

OPEN @CursorVar

-- ******************** 1ST pass start **************************
FETCH NEXT FROM @CursorVar INTO @AssociationID,@WKFID

-- If state is 2 then WKF is Indeferido ...
Set @WKF_State = (SELECT  TOP 1 w.state
		  FROM OW.tblOWWorkFlowDistribution w 
		  WHERE w.Body is NOT NULL AND w.StageNumber <> 5 AND w.OWWorkFlowDistributionid = @WKFID
		  ORDER BY w.OWWorkFlowDistributionid,w.StageNumber DESC)

-- If WKF is Indeferred
IF @WKF_State = 2 
    BEGIN
	-- print "Terminado: " + CAST (@AssociationID AS VARCHAR) + " - " + CAST (@WKFID AS VARCHAR) + " - " + CAST(@WKF_State AS VARCHAR)
	-- Disable Alarm
        UPDATE OW.tblAlarmAssociation 
	SET  Activated=0
	WHERE AssociationID = @AssociationID
    END
ELSE
    BEGIN

	-- If state not 2 the get wkf state
	Set @WKF_State = (SELECT  TOP 1 w.state
 			FROM OW.tblOWWorkFlowDistribution w 
			WHERE w.OWWorkFlowDistributionid = @WKFID 
			ORDER BY w.OWWorkFlowDistributionid,w.StageNumber DESC)

--	print "GLOBAL: " + CAST (@WKFID AS VARCHAR) + " - " + CAST(@WKF_State AS VARCHAR)

	-- If WKF has ended
	IF @WKF_State <> 5
	BEGIN
		-- print "Terminado: " + CAST (@AssociationID AS VARCHAR) + " - " + CAST (@WKFID AS VARCHAR) + " - " + CAST(@WKF_State AS VARCHAR)
		-- Disable Alarm
        	UPDATE OW.tblAlarmAssociation 
		SET  Activated=0
		WHERE AssociationID = @AssociationID

	END
    END
-- ******************** 1ST pass end **************************



WHILE @@FETCH_STATUS = 0
BEGIN
-- ******************** 2 pass start **************************
FETCH NEXT FROM @CursorVar INTO @AssociationID,@WKFID

-- If state is 2 then WKF is Indeferido ...
Set @WKF_State = (SELECT  TOP 1 w.state
		  FROM OW.tblOWWorkFlowDistribution w 
		  WHERE w.Body is NOT NULL AND w.StageNumber <> 5 AND w.OWWorkFlowDistributionid = @WKFID
		  ORDER BY w.OWWorkFlowDistributionid,w.StageNumber DESC)

-- If WKF is Indeferred
IF @WKF_State = 2 
    BEGIN
	-- print "Terminado: " + CAST (@AssociationID AS VARCHAR) + " - " + CAST (@WKFID AS VARCHAR) + " - " + CAST(@WKF_State AS VARCHAR)
	-- Disable Alarm
        UPDATE OW.tblAlarmAssociation 
	SET  Activated=0
	WHERE AssociationID = @AssociationID
    END
ELSE
    BEGIN

	-- If state not 2 the get wkf state
	Set @WKF_State = (SELECT  TOP 1 w.state
 			FROM OW.tblOWWorkFlowDistribution w 
			WHERE w.OWWorkFlowDistributionid = @WKFID 
			ORDER BY w.OWWorkFlowDistributionid,w.StageNumber DESC)

--	print "GLOBAL: " + CAST (@WKFID AS VARCHAR) + " - " + CAST(@WKF_State AS VARCHAR)

	-- If WKF has ended
	IF @WKF_State <> 5
	BEGIN
		-- print "Terminado: " + CAST (@AssociationID AS VARCHAR) + " - " + CAST (@WKFID AS VARCHAR) + " - " + CAST(@WKF_State AS VARCHAR)
		-- Disable Alarm
        	UPDATE OW.tblAlarmAssociation 
		SET  Activated=0
		WHERE AssociationID = @AssociationID

	END
    END-- ******************** 2 pass end **************************


END

CLOSE @CursorVar
DEALLOCATE @CursorVar

-- GET WORKFLOW STATE END --


-- Get all flows to send an alarm. State 5 is waiting...

DECLARE @expiredate  VARCHAR
DECLARE @username  VARCHAR(900)
DECLARE @userdesc  VARCHAR(300)
DECLARE @usermail VARCHAR(200)
DECLARE @Subject VARCHAR(255)
DECLARE @MessageTO VARCHAR(8000)

-- Create cursor for active alarms
SET @CursorVar = CURSOR SCROLL DYNAMIC
FOR
SELECT DISTINCT al.AlarmDateTime AS expiredate,u.userid,u.userdesc,u.usermail,w.Subject
FROM ((OW.tblAlarmAssociation a INNER JOIN OW.tblAlarm al 
	ON (a.AlarmID=al.AlarmID))INNER JOIN 
     OW.tblOWWorkFlowDistribution w ON (ObjectRowID=w.OWWorkFlowDistributionID)) INNER JOIN 
     OW.tblUser u ON (u.userid=w.FromAddrID)
WHERE al.AlarmDateTime < GetDate() And a.Activated=1

OPEN @CursorVar

-- Send mail
FETCH NEXT FROM @CursorVar INTO @expiredate,@username,@userdesc,@usermail, @Subject

SELECT @MessageTO = 'ATENÇÃO: Tem o processo ' + @Subject + ' por despachar.'
--print @usermail + @MessageTO

EXEC master..xp_startmail
EXEC master..xp_sendmail
    @recipients = @usermail, @subject = "Workflow Distribuição", @message = @MessageTO
EXEC master..xp_stopmail

WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM @CursorVar INTO @expiredate,@username,@userdesc,@usermail,@Subject

    SELECT @MessageTO = 'ATENÇÃO: Tem o processo ' + @Subject + ' por despachar.'
--print @usermail + @MessageTO

    EXEC master..xp_startmail
    EXEC master..xp_sendmail
        @recipients = @usermail, @subject = "Workflow Distribuição", @message = @MessageTO
    EXEC master..xp_stopmail
END

CLOSE @CursorVar
DEALLOCATE @CursorVar

SET NOCOUNT OFF


GO


CREATE    PROCEDURE OW.usp_GetProfilesFieldsByProfileId
	(
	@profileID numeric
	)
AS
SELECT 
	OW.tblProfilesFields.ProfileId, 
	OW.tblFields.FieldId as FormFieldKey, 
	OW.tblProfilesFields.FormFieldOrder, 
        OW.tblProfilesFields.FieldMaxChars, 
	OW.tblFields.Description As fieldName
FROM    
	OW.tblFields LEFT OUTER JOIN
        OW.tblProfilesFields ON OW.tblFields.FieldId = OW.tblProfilesFields.FormFieldKey AND 
        OW.tblProfilesFields.ProfileId = @profileID 
	order by OW.tblProfilesFields.formFieldOrder

Return @@ERROR

GO

/* Users */
Create PROCEDURE OW.usp_GetUser
(
	@userID numeric(18,0) = NULL,
	@userLogin varchar(900) = NULL,
	@userDesc varchar(300) = NULL,
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL)
AS

IF (@userID is not null)
BEGIN
	SELECT *
	FROM OW.tblUser
	WHERE userID = @userID
	ORDER BY userLogin
END
ELSE
BEGIN
	SELECT *
	FROM OW.tblUser
	WHERE (LOWER(userlogin) = LOWER(@UserLogin) OR @UserLogin is null)
	AND (LOWER(userDesc) = LOWER(@userDesc) OR @userDesc is null)
	AND (LOWER(userMail) = LOWER(@userMail) OR @userMail is null)
	AND (userActive = @userActive OR @userActive is null)
	AND (LOWER(TextSignature) = LOWER(@TextSignature) OR @TextSignature is null)
	AND (PrimaryGroupID = @PrimaryGroupID OR @PrimaryGroupID is null)
	ORDER BY userLogin
END	
RETURN @@ERROR



GO

CREATE PROCEDURE OW.usp_GetProduct
AS
	select ObjectTypeID, productName from OW.tblProduct order by productId
	
	RETURN @@ERROR
GO


CREATE PROCEDURE OW.usp_NewUser
(
	@userID numeric(18,0) = NULL output,
	@userLogin varchar(900),
	@userDesc varchar(300),
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL
)
AS
	INSERT
	INTO OW.tblUser
	(
		[userLogin],
		[userDesc],
		[userMail],
		[userActive],
		[TextSignature],
		[PrimaryGroupID]
	)
	VALUES
	(
		@userLogin,
		@userDesc,
		@userMail,
		@userActive,
		@TextSignature,
		@PrimaryGroupID
	)
	

	SELECT @userID = SCOPE_IDENTITY()

	RETURN @@ERROR

GO


CREATE PROCEDURE OW.usp_DeleteUser
	(
		@userID numeric
	)
AS
	DELETE FROM OW.tblUser
	WHERE userID = @userID
	RETURN @@ERROR
GO


CREATE PROCEDURE OW.usp_SetUser
(
	@userID numeric(18,0),
	@userLogin varchar(900) = null,
	@userDesc varchar(300) = null,
	@userMail varchar(200) = NULL,
	@userActive bit = NULL,
	@TextSignature varchar(300) = NULL,
	@PrimaryGroupID numeric(18,0) = NULL
)
AS
	UPDATE OW.tblUser
	SET
		userLogin = case when @userLogin is null then userLogin else @userLogin end,
		userDesc = case when @userDesc is null then userDesc else @userDesc end,
		userMail = case when @userMail is null then userMail else @userMail end,
		userActive = case when @userActive is null then userActive else @userActive end,
		TextSignature = case when @TextSignature is null then TextSignature else @TextSignature end,
		PrimaryGroupID = case when @PrimaryGroupID is null then PrimaryGroupID else @PrimaryGroupID end
	WHERE
		userID = @userID
	

	RETURN @@ERROR

GO



/*******************************************************************************************/
/*                              OWFLow SPs                                                 */
/*******************************************************************************************/
/**************************************************************\
*
*  FUNCTIONS
*
\**************************************************************/


CREATE FUNCTION OW.fnGetDNU(@DINI datetime,@DFIM datetime) RETURNS INT
AS
BEGIN
	DECLARE @DNUteis INT
	--se o periodo só tiver 1 semana
	IF ((SELECT datediff(ww,@DINI,@DFIM))=0)
		SET @DNUteis=(SELECT count(*) FROM OW.tblNonWorkingDays WHERE day <=datepart(dw,@DFIM) and day >=datepart(dw,@DINI))

	--se o periodo só tiver 2 semanas
	IF ((SELECT datediff(ww,@DINI,@DFIM))=1)
	BEGIN
		--Primeira semana
		SET @DNUteis=(SELECT count(*) FROM OW.tblNonWorkingDays WHERE day >=datepart(dw,@DINI))
		--Ultima semana
		SET @DNUteis= @DNUteis + (SELECT count(*) FROM OW.tblNonWorkingDays WHERE day <=datepart(dw,@DFIM))
	END
	--se o periodo só tiver mais de 2 semanas
	IF ((SELECT datediff(ww,@DINI,@DFIM))>1)
	BEGIN
		--Primeira semana
		SET @DNUteis=(SELECT count(*) FROM OW.tblNonWorkingDays WHERE day >=datepart(dw,@DINI))
		--Ultima semana
		SET @DNUteis= @DNUteis + (SELECT count(*) FROM OW.tblNonWorkingDays WHERE day <=datepart(dw,@DFIM))
		--Semanas entremedias= p+u+ (ndnuPorSemana* (di-df))
		SET @DNUteis=@DNUteis + ((SELECT count(*) FROM OW.tblNonWorkingDays) * ((SELECT datediff(ww,@DINI,@DFIM)-1)))
	END
	RETURN @DNUteis
END
GO

CREATE FUNCTION OW.fnGetHourMin(@DT datetime) RETURNS datetime
AS
BEGIN	
	RETURN CAST('1999-01-01 ' + CAST(datepart(hh,@DT) as VARCHAR(2)) + ':'  + CAST(datepart(mi,@DT) as VARCHAR(2)) + ':'  + CAST(datepart(ss,@DT) as VARCHAR(2)) as datetime)
END
GO


















CREATE FUNCTION OW.fnGetMNU(@DINI datetime,@DFIM datetime) RETURNS INT
AS
BEGIN
	DECLARE @MNUteis INT
	DECLARE @DU INT
	DECLARE @DNU INT
	SET @MNUteis=0

	--se o periodo só for 1 dia
	IF ((SELECT datediff(dd,@DINI,@DFIM))=0)
	BEGIN
		--se o dia em questão for um dia util
		IF (OW.fnIsDNU(@DINI)=0)
		BEGIN
			--n de minutos ñ uteis de um periodo até 1 dia
			SET @MNUteis=(SELECT ISNULL(sum(hm),0) FROM
				(SELECT (DATEDIFF(mi,OW.fnGetHourMin(@DINI),FinishHour)+1) hm FROM OW.tblNonWorkingHours WHERE 
				OW.fnGetHourMin(@DINI) BETWEEN StartHour AND FinishHour
				AND
				(OW.fnGetHourMin(@DINI)<StartHour OR OW.fnGetHourMin(@DFIM)>FinishHour)
				UNION ALL
				SELECT DATEDIFF(mi,StartHour,OW.fnGetHourMin(@DFIM)) hm FROM OW.tblNonWorkingHours WHERE 
				OW.fnGetHourMin(@DFIM) BETWEEN StartHour AND FinishHour
				AND
				(OW.fnGetHourMin(@DINI)<StartHour OR OW.fnGetHourMin(@DFIM)>FinishHour)
				UNION ALL
				SELECT (DATEDIFF(mi,StartHour,FinishHour)+1) hm FROM OW.tblNonWorkingHours WHERE 
				(OW.fnGetHourMin(@DINI) <=StartHour AND OW.fnGetHourMin(@DFIM) >=FinishHour)
				UNION ALL
				SELECT DATEDIFF(mi,@DINI,@DFIM) hm FROM OW.tblNonWorkingHours WHERE 
				(OW.fnGetHourMin(@DINI) >=StartHour AND OW.fnGetHourMin(@DFIM) <=FinishHour)) AS xx)
		END
		ELSE
			SET @MNUteis=datediff(mi,@DINI,@DFIM) --total de minutos de um periodo num dia (dia ñ util)

	END

	--se o periodo só for 2 dias
	IF ((SELECT datediff(dd,@DINI,@DFIM))=1)
	BEGIN
		--n de minutos ñ uteis no primeiro dia
		IF (OW.fnIsDNU(@DINI)=0)--se o dia em questão for um dia util
		BEGIN

			SET @MNUteis=(SELECT ISNULL(sum(hm),0) FROM
			(SELECT (DATEDIFF(mi,OW.fnGetHourMin(@DINI),FinishHour)+1) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI) BETWEEN StartHour AND FinishHour
			UNION
			SELECT (DATEDIFF(mi,StartHour,FinishHour)+1) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI)<StartHour) as xx)
		END
		ELSE
			SET @MNUteis=datediff(mi,OW.fnGetHourMin(@DINI),'1999-01-02 00:00:00') --total de minutos de @DINI até ao fim do dia (dia ñ util)

		--n de minutos ñ uteis no ultimo dia
		IF (OW.fnIsDNU(@DFIM)=0)--se o dia em questão for um dia util
		BEGIN			
			SET @MNUteis=@MNUteis + (SELECT ISNULL(sum(hm),0) FROM
						(SELECT DATEDIFF(mi,StartHour,OW.fnGetHourMin(@DFIM)) hm FROM OW.tblNonWorkingHours WHERE 
						OW.fnGetHourMin(@DFIM) BETWEEN StartHour AND FinishHour
						UNION
						SELECT (DATEDIFF(mi,StartHour,FinishHour)+1) hm  FROM OW.tblNonWorkingHours WHERE 
						OW.fnGetHourMin(@DFIM)>FinishHour) AS xx)
		END
		ELSE
			SET @MNUteis=datediff(mi,'1999-01-01 00:00:00',OW.fnGetHourMin(@DFIM)) --total de minutos de @DFIM até ao inicio do dia (dia ñ util)
			
	END
	--se o periodo for mais de 2 dias
	IF ((SELECT datediff(dd,@DINI,@DFIM))>1)
	BEGIN
		--n de minutos ñ uteis no primeiro dia
		IF (OW.fnIsDNU(@DINI)=0)--se o dia em questão for um dia util
		BEGIN

			SET @MNUteis=(SELECT ISNULL(sum(hm),0) FROM
			(SELECT (DATEDIFF(mi,OW.fnGetHourMin(@DINI),FinishHour)+1) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI) BETWEEN StartHour AND FinishHour
			UNION
			SELECT (DATEDIFF(mi,StartHour,FinishHour)+1) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI)<StartHour) as xx)
		END
		ELSE
			SET @MNUteis=datediff(mi,OW.fnGetHourMin(@DINI),'1999-01-02 00:00:00') --total de minutos de @DINI até ao fim do dia (dia ñ util)

		--n de minutos ñ uteis no ultimo dia
		IF (OW.fnIsDNU(@DFIM)=0)--se o dia em questão for um dia util
		BEGIN			
			SET @MNUteis=@MNUteis + (SELECT ISNULL(sum(hm),0) FROM
						(SELECT DATEDIFF(mi,StartHour,OW.fnGetHourMin(@DFIM)) hm FROM OW.tblNonWorkingHours WHERE 
						OW.fnGetHourMin(@DFIM) BETWEEN StartHour AND FinishHour
						UNION
						SELECT (DATEDIFF(mi,StartHour,FinishHour)+1) hm  FROM OW.tblNonWorkingHours WHERE 
						OW.fnGetHourMin(@DFIM)>FinishHour) AS xx)
		END
		ELSE
			SET @MNUteis=datediff(mi,'1999-01-01 00:00:00',OW.fnGetHourMin(@DFIM)) --total de minutos de @DFIM até ao inicio do dia (dia ñ util)



		--n de minutos ñ uteis num dia completo * o nº de dias completos
		SET @DINI=dateadd(dd,1,@DINI)
		SET @DFIM=dateadd(dd,-1,@DFIM)
		IF (datediff(dd,@DINI,@DFIM)=0)
		BEGIN
			IF (OW.fnIsDNU(@DFIM)=0)--se o dia em questão for um dia util		
				SET @MNUteis = @MNUteis + (SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours)
			ELSE
				SET @MNUteis = @MNUteis + 1440 --total de minutos de um dia (dia ñ util)
		END
		ELSE
		BEGIN	
			SET @DNU=OW.fnGetDNU(@DINI,@DFIM)
			SET @DU=datediff(dd,@DINI,@DFIM)-@DNU+1
			SET @MNUteis = @MNUteis + @DU*(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours)
			SET @MNUteis = @MNUteis + @DNU*1440 --total de minutos de um dia (dia ñ util)			
		END
	END
	RETURN @MNUteis
END
GO

























/*TOTAL DE PERIODOS EM MINUTOS, DE MINUTOS ñ UTEIS EM KE O TEMPO interfer***********************/
CREATE FUNCTION OW.fnGetTotalPMNU(@DINI datetime,@DFIM datetime) RETURNS int
AS
BEGIN
	DECLARE @MNUteis int
	DECLARE @DU INT
	DECLARE @DNU INT
	SET @MNUteis=0

	--se o periodo só for 1 dia
	IF ((SELECT datediff(dd,@DINI,@DFIM))=0)
	BEGIN
		--se o dia em questão for um dia util
		IF (OW.fnIsDNU(@DINI)=0)
		BEGIN
			--n de minutos ñ uteis de um periodo até 1 dia
			SET @MNUteis=(SELECT ISNULL(sum(hm),0) FROM
				(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours WHERE 
				OW.fnGetHourMin(@DINI) BETWEEN StartHour AND FinishHour
				AND
				(OW.fnGetHourMin(@DINI)<StartHour OR OW.fnGetHourMin(@DFIM)>FinishHour)
				UNION ALL
				SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours WHERE 
				OW.fnGetHourMin(@DFIM) BETWEEN StartHour AND FinishHour
				AND
				(OW.fnGetHourMin(@DINI)<StartHour OR OW.fnGetHourMin(@DFIM)>FinishHour)
				UNION ALL
				SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours WHERE 
				(OW.fnGetHourMin(@DINI) <=StartHour AND OW.fnGetHourMin(@DFIM) >=FinishHour)
				UNION ALL
				SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours WHERE 
				(OW.fnGetHourMin(@DINI) >=StartHour AND OW.fnGetHourMin(@DFIM) <=FinishHour)) AS xx)
		END
		ELSE
			SET @MNUteis=1440 --total de minutos de um dia (dia ñ util)

		
	END

	--se o periodo só for 2 dias
	IF ((SELECT datediff(dd,@DINI,@DFIM))=1)
	BEGIN
		--n de minutos ñ uteis no primeiro dia			
		IF (OW.fnIsDNU(@DINI)=0)--se o dia em questão for um dia util
		BEGIN
			SET @MNUteis=(SELECT ISNULL(sum(hm),0) FROM
			(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI) BETWEEN StartHour AND FinishHour
			UNION
			SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI)<StartHour) as xx)
		END
		ELSE
			SET @MNUteis=1440 --total de minutos de um dia (dia ñ util)
		--n de minutos ñ uteis no ultimo dia
		IF (OW.fnIsDNU(@DFIM)=0)--se o dia em questão for um dia util
		BEGIN
			SET @MNUteis=@MNUteis + (SELECT ISNULL(sum(hm),0) FROM
						(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours WHERE 
						OW.fnGetHourMin(@DFIM) BETWEEN StartHour AND FinishHour
						UNION
						SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm  FROM OW.tblNonWorkingHours WHERE 		
								OW.fnGetHourMin(@DFIM)>FinishHour) AS xx)
		END
		ELSE
			SET @MNUteis= @MNUteis + 1440 --total de minutos de um dia (dia ñ util)
	END
	--se o periodo for mais de 2 dias
	IF ((SELECT datediff(dd,@DINI,@DFIM))>1)
	BEGIN
		--n de minutos ñ uteis no primeiro dia			
		IF (OW.fnIsDNU(@DINI)=0)--se o dia em questão for um dia util
		BEGIN
			SET @MNUteis=(SELECT ISNULL(sum(hm),0) FROM
			(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI) BETWEEN StartHour AND FinishHour
			UNION
			SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm  FROM OW.tblNonWorkingHours WHERE 
			OW.fnGetHourMin(@DINI)<StartHour) as xx)
		END
		ELSE
			SET @MNUteis=1440 --total de minutos de um dia (dia ñ util)
		--n de minutos ñ uteis no ultimo dia
		IF (OW.fnIsDNU(@DFIM)=0)--se o dia em questão for um dia util
		BEGIN
			SET @MNUteis=@MNUteis + (SELECT ISNULL(sum(hm),0) FROM
						(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours WHERE 
						OW.fnGetHourMin(@DFIM) BETWEEN StartHour AND FinishHour
						UNION
						SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm  FROM OW.tblNonWorkingHours WHERE 
								OW.fnGetHourMin(@DFIM)>FinishHour) AS xx)
		END
		ELSE
			SET @MNUteis= @MNUteis + 1440 --total de minutos de um dia (dia ñ util)
		

		--n de minutos ñ uteis num dia completo * o nº de dias completos
		SET @DINI=dateadd(dd,1,@DINI)
		SET @DFIM=dateadd(dd,-1,@DFIM)
		IF (datediff(dd,@DINI,@DFIM)=0)
		BEGIN
			IF (OW.fnIsDNU(@DFIM)=0)--se o dia em questão for um dia util		
				SET @MNUteis = @MNUteis + (SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours)
			ELSE
				SET @MNUteis = @MNUteis + 1440 --total de minutos de um dia (dia ñ util)
		END
		ELSE
		BEGIN	
			SET @DNU=OW.fnGetDNU(@DINI,@DFIM)
			SET @DU=datediff(dd,@DINI,@DFIM)-@DNU+1
			SET @MNUteis = @MNUteis + @DU*(SELECT sum(DATEDIFF(mi,StartHour,FinishHour))+count(*) hm FROM OW.tblNonWorkingHours)
			SET @MNUteis = @MNUteis + @DNU*1440 --total de minutos de um dia (dia ñ util)			
		END				
	END
	RETURN @MNUteis
END
GO










CREATE FUNCTION OW.fnIsDNU(@DT datetime) RETURNS bit
AS 
BEGIN 
	IF (EXISTS(SELECT * FROM OW.tblNonWorkingDays WHERE day=datepart(dw,@DT)))
		RETURN 1	
	RETURN 0
END
GO











CREATE FUNCTION OW.fnGetNextHU(@DT datetime) RETURNS datetime
AS
BEGIN
	DECLARE @DTAUX datetime
	DECLARE @INC INT
	SET @INC=0
	--Loop no máximo 2X para o caso da próxima hora util ser no dia seguinte
	WHILE @INC<=1
	BEGIN
		SET @INC=@INC+1
		SET @DTAUX=(SELECT FinishHour FROM OW.tblNonWorkingHours WHERE OW.fnGetHourMin(@DT) BETWEEN StartHour AND FinishHour)
		IF (@DTAUX IS NULL)		
			SET @DTAUX=@DT
		ELSE	
		BEGIN			
			SET @DTAUX = CAST((CAST(DATEPART(yyyy,@DT) AS varchar(4)) + '-' + CAST(DATEPART(mm,@DT) AS varchar(2)) + '-' + CAST(DATEPART(dd,@DT)AS varchar(2)) + ' ' + CAST(DATEPART(hh,@DTAUX)AS varchar(2))+ ':' + CAST(DATEPART(mi,@DTAUX)AS varchar(2)) + ':' + CAST(DATEPART(ss,@DTAUX)AS varchar(2)) + '.' + CAST(DATEPART(ms,@DTAUX)AS varchar(3))) AS datetime)			
			SET @DTAUX =DATEADD(ss,1,@DTAUX)
		END
		IF (DATEDIFF(dd,@DT,@DTAUX)=0)	
			SET @INC=@INC+1
		ELSE
			SET @DT=@DTAUX
	END	

	--se hora util seguinte for num dia ñ util busca próximo dia util
	SET @INC=0
	WHILE (@INC<7)
	BEGIN
		IF EXISTS(SELECT * FROM OW.tblNonWorkingDays WHERE day = datepart(dw,@DTAUX))
			SET @DTAUX=DATEADD(dd,1,@DTAUX)
		ELSE
			SET @INC=7
		SET @INC=@INC+1
	END
	RETURN @DTAUX
END
GO











CREATE FUNCTION OW.fnGetPrevHU(@DT datetime) RETURNS datetime
AS
BEGIN
	DECLARE @DTAUX datetime
	DECLARE @INC INT
	SET @INC=0
	SET @DT = DATEADD(ss,-1,@DT)
	--Loop no máximo 2X para o caso a anterior hora util ser no dia anterior
	WHILE @INC<=1
	BEGIN
		SET @INC=@INC+1
		SET @DTAUX=(SELECT top 1 StartHour FROM OW.tblNonWorkingHours WHERE OW.fnGetHourMin(@DT) = FinishHour)
		IF (@DTAUX IS NULL)		
			SET @DTAUX=@DT
		ELSE	
		BEGIN				
			SET @DTAUX = CAST((CAST(DATEPART(yyyy,@DT) AS varchar(4)) + '-' + CAST(DATEPART(mm,@DT) AS varchar(2)) + '-' + CAST(DATEPART(dd,@DT)AS varchar(2)) + ' ' + CAST(DATEPART(hh,@DTAUX)AS varchar(2))+ ':' + CAST(DATEPART(mi,@DTAUX)AS varchar(2)) + ':' + CAST(DATEPART(ss,@DTAUX)AS varchar(2)) + '.' + CAST(DATEPART(ms,@DTAUX)AS varchar(3))) AS datetime)			
			SET @DTAUX =DATEADD(ss,-1,@DTAUX)
		END
		IF (DATEDIFF(dd,@DTAUX,@DT)=0)	
			SET @INC=@INC+1
		ELSE
			SET @DT=@DTAUX
	END	
	SET @DTAUX =DATEADD(ss,1,@DTAUX)

	--se hora util anterior for num dia ñ util busca o dia util anterior
	SET @INC=0
	WHILE (@INC<7)
	BEGIN
		IF EXISTS(SELECT * FROM OW.tblNonWorkingDays WHERE day = datepart(dw,@DTAUX))
			SET @DTAUX=DATEADD(dd,-1,@DTAUX)
		ELSE
			SET @INC=7
		SET @INC=@INC+1
	END
	RETURN @DTAUX
END
GO


















CREATE FUNCTION OW.fnGetFinalDate(@ISDNORMAL BIT,@DINI datetime,@PZDIAS numeric(6),@PZHORAS DECIMAL(8,2)) RETURNS datetime
AS
BEGIN
	DECLARE @DFIM datetime
	DECLARE @PZMIN numeric(13)
	
	--Validar Input
	IF (@PZDIAS IS NULL AND @PZHORAS IS NULL) RETURN NULL
	IF (@PZDIAS+@PZHORAS=0) RETURN @DINI
	--@PZHORAS >> Numero total em minutos
	SET @PZMIN=(CAST(@PZHORAS AS BIGINT)*60)+((@PZHORAS-CAST(@PZHORAS AS BIGINT))*60)
	--Verificar tipo de data final pretendida
	IF(@ISDNORMAL=1)
	BEGIN
		SET @DFIM=DATEADD(dd,@PZDIAS,@DINI)
		SET @DFIM=DATEADD(mi,@PZMIN,@DFIM)
		RETURN @DFIM
	END
	--Procurar dia util final
	SET @DFIM = @DINI 
	WHILE ((DATEDIFF(dd,@DINI,@DFIM)- OW.fnGetDNU(@DINI,@DFIM))<@PZDIAS)
		SET @DFIM=DATEADD(dd,(@PZDIAS+OW.fnGetDNU(@DINI,@DFIM)),@DINI)
	/*******************************************/	
	--se hora fim for hora ñ util, busca próxima hora util
	SET @DFIM=OW.fnGetNextHU(@DFIM)	
	SET @DINI = @DFIM
	--Procurar Hora/Min util final
	WHILE ((DATEDIFF(mi,@DINI,@DFIM) - OW.fnGetTotalPMNU(@DINI,@DFIM))<@PZMIN)
	BEGIN
		SET @DFIM=DATEADD(mi,(@PZMIN+OW.fnGetTotalPMNU(@DINI,@DFIM)),@DINI)
		--se hora fim for hora ñ util, busca próxima hora util
		SET @DFIM=OW.fnGetNextHU(@DFIM)
	END
	/********************************************/
	--Afinar data final: se a 'hora final' for igual a hora inicial de um horario
	--a 'hora final' passa para a hora final do horario anterior
	SET @DFIM=OW.fnGetPrevHU(@DFIM)
	RETURN @DFIM
END
GO


















--*************************************************************
--     
-- Name: GetWorkingHoursByDay 
-- Description:
-- Gets the number of working hours on one day.
-- 
--
-- Input:
-- WorkCalendar - 1 For a 7 days by week, 24 hours by day calendar.
--                2 For a user defined working calendar.
-- Output:
--
-- Returns:
-- Number of working hours on one day.
-- 
--*************************************************************
CREATE FUNCTION OW.GetWorkingHoursByDay(@WorkCalendar numeric(1))
RETURNS NUMERIC(4,2)
AS
BEGIN

DECLARE @HU_PORDIA numeric(4,2)

IF @WorkCalendar = 2
	SET @HU_PORDIA =
	(SELECT (24 - sum(CAST(
	(CAST(	datediff(mi,StartHour,FinishHour)+1 AS float(4,2)     )
		/
		60) AS numeric(4,2)
	))) from OW.tblNonWorkingHours)
ELSE
	SET @HU_PORDIA = 24

RETURN  @HU_PORDIA
END
GO





--*************************************************************
--     
-- Name: usp_GetDuration 
-- Description:
-- Calculates the duration between two dates.
-- 
--
-- Inputs:
-- 	@ISDNORMAL - 1 for Normal Days, 0 for Working Days
--	@StartDate - Stage StartDate
--	@LimitDate - Stage LimitDate. LimitDate must be greater than StartDate.
-- 
-- Outputs:
-- @DurationDays - Duration in days
-- @DurationHours - Duration in hours
--
-- Returns:
-- 0 if no errors
-- -1 if invalid parameters
-- 
--*************************************************************
CREATE PROCEDURE OW.usp_GetDuration

	(
	@ISDNORMAL bit,
	@StartDate datetime,
	@LimitDate datetime,
	@DurationDays numeric(3) OUTPUT,
	@DurationHours numeric(5,2) OUTPUT
	)

AS
	DECLARE @Duration INT -- Duration in minutes
	DECLARE @DurationNormal INT, @DurationNonUseful INT
	DECLARE @WorkingHoursByDay numeric(4,2)
	
	-- We can not calculate the duration if we don't have two dates
	IF @StartDate IS NULL OR @LimitDate IS NULL
	BEGIN
		SET @DurationDays = NULL
		SET @DurationHours = NULL
		RETURN 0
	END
	
	-- Invalid parameters
	IF @StartDate > @LimitDate
		RETURN -1
	
	-- Calculate Duration in minutes
	IF @ISDNORMAL = 1
		SET @Duration = datediff (mi, @StartDate, @LimitDate)
	ELSE
	BEGIN
		SET @DurationNormal = datediff (mi, @StartDate, @LimitDate)
		SET @DurationNonUseful = OW.fnGetMNU(@StartDate, @LimitDate)
		SET @Duration = @DurationNormal - @DurationNonUseful
	END

	-- Convert Duration in minutes to Duration in Days and Hours
	
	-- -- Get the number of working hours on one day
	SET @WorkingHoursByDay = OW.GetWorkingHoursByDay(case @ISDNORMAL when 1 then 1 when 0 then 2 end)
	
	-- -- Get the number of days (1 day = 24 hours * 60 min = 1440 min )
	SET @DurationDays = FLOOR(@Duration / (@WorkingHoursByDay * 60))
	-- -- Cut the number of days and get the remain time (less than 1 day)
	SET @Duration = @Duration - (@DurationDays * (@WorkingHoursByDay * 60) )
	
	-- -- Get the number of hours (1 hour = 60 min; 75 min = 1,25 hour)
	SET @DurationHours = ROUND((cast ( @Duration as decimal(5,2) ) / 60) , 2)

	RETURN 0
GO




























--*************************************************************
--     
-- Name: StringToTable 
-- Description:
-- Converts all items of a string delimited by a character into 
-- table rows.
--
-- Inputs:
-- String - string to convert in format {item [<delimiter> item] }.
-- Delimiter - character that delimit each item
--
-- Returns:
-- A table with a row for each item found between 
-- the delimiter specified
-- 
-- Example:
-- select * from Split('20,31,14,abc',',')
-- ID Item
-- 1  20
-- 2  31
-- 3  14
-- 4  abc
--*************************************************************

CREATE FUNCTION OW.StringToTable (@String varchar(8000), @Delimiter char(1))
RETURNS @Results TABLE (ID numeric(18) IDENTITY, Item varchar(8000))
AS

BEGIN

    DECLARE @Index INT
    DECLARE @Item varchar(8000)
   

    IF @String IS NULL OR LEN(@String)=0
	RETURN

    -- Set @Index to a value differente of zero to go inside the loop for the first time
    SELECT @Index = -1

    WHILE @Index !=0
    BEGIN	

        -- Get the Index of the first occurence of the Delimiter
        SELECT @Index = CHARINDEX(@Delimiter, @String )

        -- Get the Item until Delimiter
        IF @Index !=0
        	SELECT @Item = LEFT(@String ,@Index - 1)
        ELSE
        	SELECT @Item = @String  -- Last time

        -- Put the Item into the results set
        INSERT INTO @Results(Item) VALUES(@Item )

        -- Remove the Item from the String
        SELECT @String = RIGHT(@String ,LEN(@String ) - @Index )

        -- Break the loop if no more Items
        IF LEN(@String ) = 0 BREAK

    END
    RETURN
END
GO
























































/**************************************************************\
*
*  PROCEDURES
*
\**************************************************************/


/* ********************** FLOW ********************************/

CREATE PROCEDURE OW.usp_NewFlow

	(
	@Code varchar(10), 
	@Name varchar(50),
	@FlowID numeric(18) OUTPUT /* Return new FlowID */
	)

AS
	DECLARE @Error int

	INSERT INTO OW.tblFlow (Code, Name, State, DurationDays, DurationHours, WorkCalendar, OriginatorAccess)
	VALUES (ltrim(rtrim(@Code)), ltrim(rtrim(@Name)),'C', NULL, NULL, 2, 1)
	
	SET @Error = @@ERROR
	IF @Error <> 0  RETURN @Error
	
	SET @FlowID=@@IDENTITY
	
	RETURN @@ERROR

GO






























CREATE PROCEDURE OW.usp_SetFlow

	(
	@FlowID numeric(18),
	@Code varchar(10), 
	@Name varchar(50),
	@State char(1),
	@WorkCalendar numeric(2),
	@OriginatorAccess numeric(1)
	)

AS
	DECLARE @NumberOfStages numeric(3)
	DECLARE @OldState char(1)
	
	-- Trancar o fluxo por causa da concorrência ! andre
	
	-- If Flow State change from UnderConstruction to Production
	-- check if the flow have at least two stages.
	SELECT @OldState=State FROM OW.tblFlow WHERE FlowID=@FlowID
	
	IF @OldState='C' AND @State='P'
	BEGIN
		SELECT @NumberOfStages=Count(*) FROM OW.tblFlowStages WHERE FlowID=@FlowID
		IF @NumberOfStages < 2
			RETURN -1 -- Can not change flow state because it haven't at least 2 stages
	END
	
	UPDATE OW.tblFlow 
	SET Code=@Code, Name=@Name, State=@State, WorkCalendar=@WorkCalendar, OriginatorAccess=@OriginatorAccess
	WHERE FlowID=@FlowID
	
	
	RETURN @@ERROR

GO








CREATE PROCEDURE OW.usp_DeleteFlow

	(
	@FlowID numeric(18)
	)

AS


	DELETE OW.tblFlow WHERE FlowID=@FlowID
	
	
	RETURN @@ERROR

GO








CREATE PROCEDURE OW.usp_GetFlow

	(
	@FlowID numeric(18)
	)

AS


	SELECT Code, Name, State, DurationDays, DurationHours, WorkCalendar, OriginatorAccess
	FROM OW.tblFlow
	WHERE FlowID=@FlowID
	
	
	RETURN @@ERROR

GO













CREATE PROCEDURE OW.usp_GetFlows

	(
	@State char(1)=NULL
	)

AS

	IF @State IS NULL
		SELECT FlowID, Code, Name, State, DurationDays, DurationHours, WorkCalendar, OriginatorAccess
		FROM OW.tblFlow
		ORDER BY Code
	ELSE
		SELECT FlowID, Code, Name, State, DurationDays, DurationHours, WorkCalendar, OriginatorAccess
		FROM OW.tblFlow
		WHERE State=@State
		ORDER BY Code	
	
	RETURN @@ERROR

GO

























CREATE PROCEDURE OW.usp_SetFlowDuration

	(
	@FlowID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @StagesWithoutDuration numeric(3)
	DECLARE	@DurationDays numeric(6)
	DECLARE @DurationHours numeric(8,2)


	-- Este procedimento tem de correr dentro de um lock ao fluxo
	-- caso contrário a contagem da duração pode errar
	-- andre.
	
	
	
	-- Get the number of Stages without duration
	
	SELECT @StagesWithoutDuration=Count(*) 
	FROM OW.tblFlowStages 
	WHERE FlowID=@FlowID AND DurationDays IS NULL  -- is not necessary ... (DurationDays IS NULL OR DurationHours IS NULL)
	
	
	-- Calculate Flow Duration
	
	IF @StagesWithoutDuration > 0
	BEGIN
		SET @DurationDays = NULL
		SET @DurationHours = NULL
	END
	ELSE
	BEGIN
		SELECT @DurationDays=sum(DurationDays), @DurationHours=sum(DurationHours)
		FROM OW.tblFlowStages WHERE FlowID=@FlowID
		-- If the Flow don't have stages, sum returns NULL
	END
	
	
	-- Set Flow Duration
	 
	UPDATE OW.tblFlow
	SET DurationDays=@DurationDays,	DurationHours=@DurationHours
	WHERE FlowID=@FlowID
	
	SET @Error = @@ERROR
	IF @Error <> 0  RETURN @Error
	
	RETURN 0

GO





























/* ********************** FLOWSTAGES ********************************/

CREATE PROCEDURE OW.usp_NewFlowStage

	(
	@FlowID numeric(18), 
	@Name varchar(50),
	@DurationDays numeric(3),
	@DurationHours numeric(5,2),
	@ExecutantType char(1),
	@ExecutantID numeric(18),
	@FlowStageID numeric(18) OUTPUT   /* Return new FlowStageID */
	)

AS
	DECLARE @Error int
	DECLARE @NewNumber numeric(3)


	-- O que acontece em casos de concorrência?
	-- Ambos os processos podem obter o mesmo Number e por isso vai dar erro
	-- ao inserir a segunda etapa.
	-- Solução: implementar o lock. andre



	BEGIN TRANSACTION

	-- Get the Number of next Stage 

	SELECT @NewNumber=MAX(Number)+1 FROM OW.tblFlowStages WHERE FlowID=@FlowID

	IF @NewNumber IS NULL    -- If the Flow do not have stages
		SET @NewNumber=1

	-- Insert FlowStage

	IF @ExecutantType='U'
		INSERT INTO OW.tblFlowStages (FlowID, Number, Name, DurationDays, DurationHours, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID)
		VALUES (@FlowID, @NewNumber, ltrim(rtrim(@Name)), @DurationDays, @DurationHours, @ExecutantType, @ExecutantID, NULL)
	ELSE
		INSERT INTO OW.tblFlowStages (FlowID, Number, Name, DurationDays, DurationHours, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID)
		VALUES (@FlowID, @NewNumber, ltrim(rtrim(@Name)), @DurationDays, @DurationHours, @ExecutantType, NULL, @ExecutantID)
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	SET @FlowStageID=@@IDENTITY


	-- Update Flow Duration
	
	EXECUTE @Error = OW.usp_SetFlowDuration @FlowID

	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

	COMMIT TRANSACTION
	
	RETURN 0

GO

































CREATE PROCEDURE OW.usp_SetFlowStage

	(
	@FlowStageID numeric(18), 
	@Name varchar(50),
	@DurationDays numeric(3),
	@DurationHours numeric(5,2),
	@ExecutantType char(1),
	@ExecutantID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @FlowID numeric(18)
	
	BEGIN TRANSACTION
	
	-- Update Flow Stage
	
	IF @ExecutantType='U'
		UPDATE OW.tblFlowStages
		SET Name=@Name, DurationDays=@DurationDays, DurationHours=@DurationHours,
		ExecutantType=@ExecutantType,	ExecutantTypeUserID=@ExecutantID, ExecutantTypeGroupID=NULL 
		WHERE FlowStageID=@FlowStageID
	ELSE
		UPDATE OW.tblFlowStages
		SET Name=@Name, DurationDays=@DurationDays, DurationHours=@DurationHours,
		ExecutantType=@ExecutantType, ExecutantTypeUserID=NULL, ExecutantTypeGroupID=@ExecutantID 
		WHERE FlowStageID=@FlowStageID

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Update Flow Duration
	
	SELECT @FlowID=FlowID FROM OW.tblFlowStages WHERE FlowStageID=@FlowStageID
	
	EXECUTE @Error = OW.usp_SetFlowDuration @FlowID

	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	COMMIT TRANSACTION
	
	RETURN 0

GO























-- Concorrência: implementar um lock. andre

CREATE PROCEDURE OW.usp_MoveBackwardFlowStage

	(
	@FlowStageID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @FlowID numeric(18)
	DECLARE @Number numeric(3)


	BEGIN TRANSACTION

	-- Get FlowId and Stage Number

	SELECT @FlowID=FlowID, @Number=Number
	FROM  OW.tblFlowStages
	WHERE FlowStageID=@FlowStageID

	-- If the Stage no longer exists then do nothing.
	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 0
	END

	-- If the Stage is the first then it can not move back
	IF @Number=1
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 0
	END


	-- Change the Stage Number to permit the forward movement of the 
	-- previous stage.

	UPDATE OW.tblFlowStages
	SET Number=999
	WHERE FlowStageID=@FlowStageID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	


	-- Move forward the previous stage

	UPDATE OW.tblFlowStages
	SET Number=Number+1
	WHERE FlowID=@FlowID and Number=@Number-1

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	


	-- Move backward the Stage 

	UPDATE OW.tblFlowStages
	SET Number=@Number-1
	WHERE FlowStageID=@FlowStageID

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	COMMIT TRANSACTION
	RETURN 0

GO



































-- Concorrência: implementar um lock. andre

CREATE PROCEDURE OW.usp_MoveForwardFlowStage

	(
	@FlowStageID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @FlowID numeric(18)
	DECLARE @Number numeric(3)
	DECLARE @MaxNumber numeric(3)


	BEGIN TRANSACTION

	-- Get FlowId and Stage Number

	SELECT @FlowID=FlowID, @Number=Number
	FROM  OW.tblFlowStages
	WHERE FlowStageID=@FlowStageID

	-- If the Stage no longer exists then do nothing.
	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 0
	END

	-- Get Max Stage Number

	SELECT @MaxNumber=Max(Number)
	FROM  OW.tblFlowStages
	WHERE FlowID=@FlowID

	-- If the Flow do not have stages.
	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 0
	END

	-- If the Stage is the last then it can not forward
	IF @Number=@MaxNumber
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 0
	END


	-- Change the Stage Number to permit the backward movement of the 
	-- next stage.

	UPDATE OW.tblFlowStages
	SET Number=999
	WHERE FlowStageID=@FlowStageID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	


	-- Move backward the next stage

	UPDATE OW.tblFlowStages
	SET Number=Number-1
	WHERE FlowID=@FlowID and Number=@Number+1

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	


	-- Move forward the Stage 

	UPDATE OW.tblFlowStages
	SET Number=@Number+1
	WHERE FlowStageID=@FlowStageID

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	COMMIT TRANSACTION
	RETURN 0

GO
































-- Concorrência: implementar um lock. andre
-- Se alguém criar uma etapa ao mesmo tempo, depois do último update
-- fica um buraco no meio.

CREATE PROCEDURE OW.usp_DeleteFlowStage

	(
	@FlowStageID numeric(18)
	)

AS

	DECLARE @Error int
	DECLARE @FlowID numeric(18)
	DECLARE @Number numeric(3)
	DECLARE @NumberOfStages numeric(3)


	BEGIN TRANSACTION


	-- Get FlowId and Stage Number

	SELECT @FlowID=FlowID, @Number=Number
	FROM  OW.tblFlowStages
	WHERE FlowStageID=@FlowStageID


	-- Delete all alarms of Stage (because FlowStageID don't have "on delete cascade")

	DELETE OW.tblFlowAlarms WHERE FlowStageID=@FlowStageID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	

	-- Delete the Stage

	DELETE OW.tblFlowStages WHERE FlowStageID=@FlowStageID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Move the next Stages one step backward

	UPDATE OW.tblFlowStages 
	SET Number=Number-1
	WHERE FlowID=@FlowID and Number>@Number

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

 	
 	-- Update Flow Duration
	
	EXECUTE @Error = OW.usp_SetFlowDuration @FlowID

	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- If the number of stages is less than two, then Set Flow State to UnderConstruction
	
	SELECT @NumberOfStages=Count(*) FROM OW.tblFlowStages WHERE FlowID=@FlowID
	
	IF @NumberOfStages < 2
	BEGIN
		UPDATE OW.tblFlow SET State='C' WHERE FlowID=@FlowID
		
		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END
		
	
	COMMIT TRANSACTION
	RETURN 0

GO



























CREATE PROCEDURE OW.usp_GetFlowStage

	(
	@FlowStageID numeric(18)
	)

AS


	SELECT Number, Name, DurationDays, DurationHours, ExecutantType, 
	       case when (ExecutantType='U') then ExecutantTypeUserID else ExecutantTypeGroupID end as ExecutantID, 
	       case when (ExecutantType='U') then UserDesc else GroupDesc end as ExecutantName       
	FROM OW.tblFlowStages LEFT JOIN OW.tblUser 
	     ON OW.tblFlowStages.ExecutantTypeUserID=OW.tblUser.UserID
	     LEFT JOIN OW.tblGroups
	     ON OW.tblFlowStages.ExecutantTypeGroupID=OW.tblGroups.GroupID
	WHERE FlowStageID=@FlowStageID


	
	RETURN @@ERROR

GO


































CREATE PROCEDURE OW.usp_GetFlowStages

	(
	@FlowID numeric(18)
	)

AS
	
	
	SELECT FlowStageID, Number, Name, DurationDays, DurationHours, ExecutantType, 
	       case when (ExecutantType='U') then ExecutantTypeUserID else ExecutantTypeGroupID end as ExecutantID, 
	       case when (ExecutantType='U') then UserDesc else GroupDesc end as ExecutantName       
	FROM OW.tblFlowStages LEFT JOIN OW.tblUser 
	     ON OW.tblFlowStages.ExecutantTypeUserID=OW.tblUser.UserID
	     LEFT JOIN OW.tblGroups
	     ON OW.tblFlowStages.ExecutantTypeGroupID=OW.tblGroups.GroupID
	WHERE FlowID=@FlowID
	ORDER BY Number
	
	RETURN @@ERROR

GO





























/* ********************** FLOWALARMS ********************************/

CREATE PROCEDURE OW.usp_NewFlowAlarm

	(
	@FlowID numeric (18),
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@FlowStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric (1),
	@AddresseeExecutant numeric (1),
	@AddresseeTypeList varchar (8000),
	@AddresseeIDList varchar (8000),
	@FlowAlarmID numeric (18) OUTPUT   /* Return new FlowAlarmID */
	)

AS

	DECLARE @Error int

	BEGIN TRANSACTION

	-- Insert FlowAlarm data

	INSERT INTO OW.tblFlowAlarms (FlowID , Occurence , OccurenceOffsetDays, OccurenceOffsetHours  , FlowStageID , Message , AlertByEMail , AddresseeExecutant )
	VALUES (@FlowID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours , @FlowStageID , ltrim(rtrim(@Message)) , @AlertByEMail , @AddresseeExecutant )

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

	
	SET @FlowAlarmID=@@IDENTITY
	

	-- Insert Addresses

	IF LEN (@AddresseeIDList) > 0
	BEGIN
		INSERT INTO OW.tblFlowAlarmAddressees (FlowAlarmID , AddresseeType , UserID, GroupID )
		SELECT @FlowAlarmID, A.Item, 
		case when (A.Item='U') then B.Item else NULL end,
		case when (A.Item='G') then B.Item else NULL end
		FROM OW.StringToTable(@AddresseeTypeList,',') A INNER JOIN OW.StringToTable(@AddresseeIDList,',')B
		ON (A.ID=B.ID)

		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END



	COMMIT TRANSACTION
	RETURN 0

GO

































CREATE PROCEDURE OW.usp_SetFlowAlarm

	(
	@FlowAlarmID numeric(18), 
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@FlowStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric (1),
	@AddresseeExecutant numeric (1),
	@AddresseeTypeList varchar(8000),
	@AddresseeIDList varchar(8000)
	)

AS
	DECLARE @Error int
	
	BEGIN TRANSACTION

	-- Update alarm table

	UPDATE OW.tblFlowAlarms
	SET Occurence=@Occurence , OccurenceOffsetDays=@OccurenceOffsetDays , OccurenceOffsetHours=@OccurenceOffsetHours,
	FlowStageID=@FlowStageID , Message=@Message , AlertByEMail=@AlertByEMail , AddresseeExecutant=@AddresseeExecutant 
	WHERE FlowAlarmID=@FlowAlarmID 
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Delete old Addressees

	DELETE FROM OW.tblFlowAlarmAddressees WHERE FlowAlarmID=@FlowAlarmID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Insert new Addressees

	IF LEN (@AddresseeIDList) > 0
	BEGIN
		INSERT INTO OW.tblFlowAlarmAddressees (FlowAlarmID , AddresseeType , UserID, GroupID )
		SELECT @FlowAlarmID, A.Item, 
		case when (A.Item='U') then B.Item else NULL end,
		case when (A.Item='G') then B.Item else NULL end
		FROM OW.StringToTable(@AddresseeTypeList,',') A INNER JOIN OW.StringToTable(@AddresseeIDList,',')B
		ON (A.ID=B.ID)

		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END


	COMMIT TRANSACTION
	RETURN 0

GO



































CREATE PROCEDURE OW.usp_DeleteFlowAlarm

	(
	@FlowAlarmID numeric(18)
	)

AS


	DELETE OW.tblFlowAlarms WHERE FlowAlarmID=@FlowAlarmID
	
	
	RETURN @@ERROR

GO



























CREATE PROCEDURE OW.usp_GetFlowAlarm

	(
	@FlowAlarmID numeric(18)
	)

AS

		
	SELECT FLAL.FlowAlarmID, FLAL.Occurence , FLAL.OccurenceOffsetDays , FLAL.OccurenceOffsetHours,
	       FLAL.Message , FLST.FlowStageID , FLST.Number , FLST.Name , 
	       FLAL.AlertByEMail , FLAL.AddresseeExecutant
	FROM OW.tblFlowAlarms FLAL LEFT JOIN OW.tblFlowStages FLST
	     ON FLAL.FlowStageID=FLST.FLowStageID
	WHERE FLAL.FlowAlarmID=@FlowAlarmID

	
	RETURN @@ERROR

GO





























CREATE PROCEDURE OW.usp_GetFlowAlarmAddressees

	(
	@FlowAlarmID numeric(18)
	)

AS

	
	
	SELECT FLAA.FlowAlarmID, FLAA.AddresseeType , 
		case when (AddresseeType='U') then FLAA.UserID else FLAA.GroupID end as AddresseeID,
		case when (AddresseeType='U') then U.UserDesc else G.GroupDesc end as AddresseeName
	FROM OW.tblFlowAlarmAddressees FLAA 
		LEFT JOIN OW.tblUser U ON FLAA.UserID=U.UserID
		LEFT JOIN OW.tblGroups G ON FLAA.GroupID=G.GroupID
	WHERE FLAA.FlowAlarmID=@FlowAlarmID

	
	RETURN @@ERROR

GO








































CREATE PROCEDURE OW.usp_GetFlowAlarms

	(
	@FlowID numeric(18)
	)

AS

		
	SELECT FLAL.FlowAlarmID, FLAL.Occurence , FLAL.OccurenceOffsetDays , FLAL.OccurenceOffsetHours,
		FLAL.Message , FLAL.AlertByEMail , FLAL.AddresseeExecutant
	FROM OW.tblFlowAlarms FLAL 
	WHERE FLAL.FlowID=@FlowID and FLAL.FlowStageID IS NULL
	ORDER BY FLAL.FlowAlarmID
	
	
	RETURN @@ERROR

GO




























CREATE PROCEDURE OW.usp_GetFlowStageAlarms

	(
	@FlowStageID numeric(18)
	)

AS

	
	SELECT FLAL.FlowAlarmID, FLAL.Occurence , FLAL.OccurenceOffsetDays , FLAL.OccurenceOffsetHours,
		FLAL.Message , FLAL.AlertByEMail , FLAL.AddresseeExecutant
	FROM OW.tblFlowAlarms FLAL 
	WHERE FLAL.FlowStageID=@FlowStageID
	ORDER BY FLAL.FlowAlarmID
	
	
	RETURN @@ERROR

GO



































/* ********************** FLOWACCESSES ********************************/


CREATE PROCEDURE OW.usp_GetUsersAndGroupsWithFlowAccess

	(
	@FlowID numeric(18)
	)

AS

	-- Only active users WITH access on Flow and with access to WorkFlow Application

	SELECT U.UserID ID, 'U' Type, U.UserDesc Name
	FROM OW.tblUser U 
	WHERE U.UserActive=1 
	AND EXISTS (SELECT 1 FROM OW.tblFlowUserAccesses FLUA
			WHERE U.UserID=FLUA.UserID AND FLUA.FlowID=@FlowID)
	AND EXISTS (SELECT 1 FROM OW.tblAccess ACC
			WHERE U.UserID=ACC.UserID 
			AND ACC.ObjectParentID=6 AND ACC.ObjectTypeID=1)
	
	UNION

	SELECT G.GroupID ID, 'G' Type, G.GroupDesc Name
	FROM OW.tblGroups G  
	WHERE EXISTS (SELECT 1 FROM OW.tblFlowGroupAccesses FLGA
			WHERE G.GroupID=FLGA.GroupID AND FLGA.FlowID=@FlowID)
	ORDER BY Name
	

	RETURN @@ERROR

GO






































CREATE PROCEDURE OW.usp_GetUsersAndGroupsWithoutFlowAccess

	(
	@FlowID numeric(18)
	)

AS

	-- Only active users WITHOUT access on Flow and with access to WorkFlow Application

	SELECT U.UserID ID, 'U' Type, U.UserDesc Name
	FROM OW.tblUser U 
	WHERE U.UserActive=1 
	AND NOT EXISTS (SELECT 1 FROM OW.tblFlowUserAccesses FLUA
			WHERE U.UserID=FLUA.UserID AND FLUA.FlowID=@FlowID)
	AND EXISTS (SELECT 1 FROM OW.tblAccess ACC
			WHERE U.UserID=ACC.UserID 
			AND ACC.ObjectParentID=6 AND ACC.ObjectTypeID=1)

	UNION

	SELECT G.GroupID ID, 'G' Type, G.GroupDesc Name
	FROM OW.tblGroups G  
	WHERE  NOT EXISTS (SELECT 1 FROM OW.tblFlowGroupAccesses FLGA
		WHERE G.GroupID=FLGA.GroupID AND FLGA.FlowID=@FlowID)
	ORDER BY Name
	
	
	RETURN @@ERROR

GO






























CREATE PROCEDURE OW.usp_GrantFlowAccess

	(
	@FlowID numeric (18),
	@IDList varchar (8000),
	@TypeList varchar (8000)
	)

AS
	DECLARE @Error int
	
	BEGIN TRANSACTION
		
	-- Delete Users that lose access

	DELETE FROM OW.tblFlowUserAccesses
	WHERE FlowID=@FlowID
	AND NOT EXISTS (SELECT 1 FROM OW.StringToTable(@TypeList,',') A INNER JOIN OW.StringToTable(@IDList,',') B
					ON (A.ID=B.ID)
					WHERE A.Item='U' AND OW.tblFlowUserAccesses.UserID=B.Item)
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Insert Users that win access

	INSERT INTO OW.tblFlowUserAccesses (FlowID, UserID)
	SELECT @FlowID, B.Item
	FROM OW.StringToTable(@TypeList,',') A INNER JOIN OW.StringToTable(@IDList,',') B
		ON (A.ID=B.ID)
	WHERE A.Item='U'
	AND NOT EXISTS (SELECT 1 FROM OW.tblFlowUserAccesses FLUA
					WHERE FLUA.FlowID=@FlowID AND FLUA.UserID=B.Item)

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END



	-- Delete Groups that lose access

	DELETE FROM OW.tblFlowGroupAccesses
	WHERE FlowID=@FlowID
	AND NOT EXISTS (SELECT 1 FROM OW.StringToTable(@TypeList,',') A INNER JOIN OW.StringToTable(@IDList,',') B
					ON (A.ID=B.ID)
					WHERE A.Item='G' AND OW.tblFlowGroupAccesses.GroupID=B.Item)
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Insert Groups that win access

	INSERT INTO OW.tblFlowGroupAccesses (FlowID, GroupID)
	SELECT @FlowID, B.Item
	FROM OW.StringToTable(@TypeList,',') A INNER JOIN OW.StringToTable(@IDList,',') B
		ON (A.ID=B.ID)
	WHERE A.Item='G'
	AND NOT EXISTS (SELECT 1 FROM OW.tblFlowGroupAccesses FLGA
					WHERE FLGA.FlowID=@FlowID AND FLGA.GroupID=B.Item)

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	COMMIT TRANSACTION
	RETURN 0

GO






























/* ********************** PROCESS ********************************/

CREATE PROCEDURE OW.usp_GetUserFlows

	(
	@UserID numeric(18)
	)

AS

	SELECT FlowID, Code, Name, State, DurationDays, DurationHours, WorkCalendar, OriginatorAccess
	FROM OW.tblFlow FL
	WHERE State='P'
	AND EXISTS (SELECT 1 FROM OW.tblFlowStages FLST
			WHERE FL.FlowID=FLST.FlowID
			AND FLST.Number=1
			AND 
			(
			(FLST.ExecutantType='U' AND FLST.ExecutantTypeUserID=@UserID)
			OR
			(FLST.ExecutantType='G' AND EXISTS (SELECT 1 FROM OW.tblGroupsUsers GU
								WHERE FLST.ExecutantTypeGroupID=GU.GroupID
								AND GU.UserID=@UserID))
			)
	)
	ORDER BY FL.Code
	
	RETURN @@ERROR

GO
































--*************************************************************
--     
-- Name: GetNewProcessNumber 
-- Description:
-- Returns a Number for a new process.
-- 
--
-- Inputs:
-- Code - Flow Code for processes based on a flow, or "ADHOC"
--        for processes not based on a flow.
-- Year - Year of the process.
--
-- Returns:
-- New Process Number 
-- 
-- 
--*************************************************************

CREATE FUNCTION OW.GetNewProcessNumber ( 
	@Code varchar(10),
	@Year numeric(4)
)
RETURNS numeric(9)
AS

BEGIN
	DECLARE @Number numeric(9)

	SELECT @Number=Max(Number)+1 FROM OW.tblProcess WITH (TABLOCKX)
	WHERE Code=@Code AND Year=@Year
	
	IF @Number IS NULL -- If no process found for this code and year ...
		SET @Number=1  -- this is the first process
	
	RETURN @Number		
END
GO





























CREATE PROCEDURE OW.usp_GetDate
	(	
	@Date char(19) OUTPUT /* Returns date and time in format yyyy-mm-dd hh:mm:ss*/
	)
AS
	SET @Date=convert(char(19),getdate(),120)

	RETURN @@ERROR
GO




























CREATE PROCEDURE OW.usp_SetProcessWorkCompleted

	(
	@ProcessID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @WorkCalendar numeric(1)
	DECLARE @WorkCompleted numeric(3)
	DECLARE @NumberOfStagesCompleted numeric(3), @NumberOfStages numeric(3)
	DECLARE @DurationDaysCompleted numeric(6), @DurationHoursCompleted numeric(8,2)
	DECLARE @DurationDays numeric(6), @DurationHours numeric(8,2)
	DECLARE @DurationCompleted numeric(8,2), @Duration numeric(10,2)
	DECLARE @WorkingHoursByDay numeric(4,2) -- max: 24,00
	
	-- Calculate WorkCompleted percentage
	
	SELECT @DurationDays=DurationDays, @DurationHours=DurationHours, @WorkCalendar=WorkCalendar
	FROM OW.tblProcess WHERE ProcessID=@ProcessID

	IF @DurationDays IS NULL AND @DurationHours IS NULL
	BEGIN
		-- Processes with NO duration estimative
		SELECT @NumberOfStages=count(*) FROM OW.tblProcessStages WHERE ProcessID=@ProcessID
		SELECT @NumberOfStagesCompleted=count(*) FROM OW.tblProcessStages WHERE ProcessID=@ProcessID
		AND StartDate IS NOT NULL AND FinishDate IS NOT NULL
		
		SET @WorkCompleted = @NumberOfStagesCompleted * 100 / @NumberOfStages
	END
	ELSE
	BEGIN
		-- Processes with duration estimative
		SELECT @DurationDaysCompleted=sum(DurationDays), @DurationHoursCompleted=sum(DurationHours)
		FROM OW.tblProcessStages WHERE ProcessID=@ProcessID
		AND StartDate IS NOT NULL AND FinishDate IS NOT NULL
		
		-- Get Number of Daily Working Hours.
		SET @WorkingHoursByDay = OW.GetWorkingHoursByDay(@WorkCalendar)
		
		SET @DurationCompleted = @DurationDaysCompleted * @WorkingHoursByDay + @DurationHoursCompleted
		SET @Duration = @DurationDays * @WorkingHoursByDay + @DurationHours
		SET @WorkCompleted = ROUND (@DurationCompleted * 100 / @Duration, 0 , 1 )
	END
	
		
	-- Update WorkCompleted
	
	UPDATE OW.tblProcess
	SET WorkCompleted=@WorkCompleted
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
GO



























CREATE PROCEDURE OW.usp_NewProcess

	(
	@Code varchar (10),
	@Number numeric (9),
	@Year numeric (4),
	@Name varchar (50),
	@DurationDays numeric(6),
	@DurationHours numeric(8,2),
	@WorkCalendar numeric(1),
	@StartDate datetime,
	@OriginatorAccess numeric(1), 
	@ProcessID numeric(18) OUTPUT /* Return new ProcessID */
	)

AS

	SET DATEFORMAT ymd

	INSERT INTO OW.tblProcess (Code, Number, Year, Name, State, DurationDays, DurationHours, WorkCalendar, StartDate, LimitDate, WorkCompleted, OriginatorAccess)
	VALUES (@Code, @Number, @Year, ltrim(rtrim(@Name)), 1, @DurationDays, @DurationHours, @WorkCalendar, @StartDate, OW.fnGetFinalDate(case @WorkCalendar when 1 then 1 when 2 then 0 end, @StartDate, @DurationDays, @DurationHours), 0, @OriginatorAccess)	
	SET @ProcessID=@@IDENTITY
	
	RETURN @@ERROR
GO
	
	
	
	
	
	
	
	
	
	
	
	
	
	
CREATE PROCEDURE OW.usp_StartProcessStage

	(
	@ProcessID numeric(18),
	@StageNumber numeric(3)
	)

AS
	DECLARE @Error int
	DECLARE @WorkCalendar numeric(1)
	DECLARE @StartDate datetime
	
	
	SELECT @WorkCalendar=WorkCalendar, @StartDate=StartDate
	FROM OW.tblProcess WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
	-- If the stage is not the first one
	-- the Start Date is equal the Finish Date of the previous stage
	IF @StageNumber<>1
	BEGIN
		SELECT @StartDate=FinishDate
		FROM OW.tblProcessStage
		WHERE ProcessID=@ProcessID and Number=@StageNumber-1
		
		SET @Error = @@ERROR
		IF @Error <> 0 RETURN @Error
	END
		
	
	UPDATE OW.tblProcessStages
	SET ExecutantID=ExecutantTypeUserID, StartDate=@StartDate,
	LimitDate=OW.fnGetFinalDate(case @WorkCalendar when 1 then 1 when 2 then 0 end, @StartDate, DurationDays, DurationHours)
	WHERE ProcessID=@ProcessID AND Number=@StageNumber
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
GO























CREATE PROCEDURE OW.usp_MarkProcessStageAsReaded

	(
	@ProcessID numeric(18),
	@StageNumber numeric(3)
	)

AS
	DECLARE @Error int
	DECLARE @ReadDate datetime
	
	-- If the stage is the first one
	-- the Read Date is equal the Start Date of the Process
	IF @StageNumber=1
	BEGIN
		SELECT @ReadDate=StartDate
		FROM OW.tblProcess
		WHERE ProcessID=@ProcessID
		
		SET @Error = @@ERROR
		IF @Error <> 0 RETURN @Error
	END
	ELSE 
		SET @ReadDate=getdate()
		
	
	UPDATE OW.tblProcessStages
	SET ReadDate=@ReadDate
	WHERE ProcessID=@ProcessID AND Number=@StageNumber
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
GO























	
-- Check if process is active
-- and user is participant
-- and if user is originator, he must have access

CREATE FUNCTION OW.CanAttachDocuments
	(
	@UserID numeric(18), 
	@ProcessID numeric(18)
	)
RETURNS bit
AS

BEGIN

	DECLARE @CanAttach bit
	
	SET @CanAttach = 0 -- False
	
	SELECT @CanAttach=1 FROM OW.tblProcess PR
	WHERE  
	PR.ProcessID=@ProcessID 
	AND
	PR.State=1 -- Process is Active
	AND
	exists (SELECT 1 FROM OW.tblProcessStages PRST
			WHERE PR.ProcessID=PRST.ProcessID
			AND	PRST.ExecutantID=@UserID) -- The user was or is executant
	AND
	(
	PR.OriginatorAccess=1 -- if user is originator, he must have access 
	or
	exists (select 1 from OW.tblProcessStages PRST
				where PR.ProcessID=PRST.ProcessID
				and PRST.Number=1 and PRST.ExecutantID<>@UserID
			)
	)
 
	
	RETURN @CanAttach
END
GO
























CREATE PROCEDURE OW.usp_SaveProcess

	(
	@ProcessID numeric (18), 
	@ProcessStageID numeric (18),
	@UserID numeric (18),
	@StageNotes text,
	@DocumentOperationList varchar (8000),
	@DocumentIDList varchar (8000),
	@DocumentAssociationList varchar (8000)
	)

AS
	DECLARE @Error int
	
	-- Verificar concorrência desta operação. andre
	
	IF @ProcessStageID IS NOT NULL
	BEGIN
		-- Check if process is active and the stage is yet current
		DECLARE @CanDispatch bit
		
		SET @CanDispatch=OW.CanDispatchStage(@ProcessStageID)
		
		IF @CanDispatch = 0 RETURN -2  -- Process is not active or the the stage is not the current
	END
	ELSE
	BEGIN
		-- Check if user can attatch documents to process 
		DECLARE @CanAttach bit
		
		SET @CanAttach=OW.CanAttachDocuments(@UserID, @ProcessID)
		
		IF @CanAttach = 0 RETURN -2  -- User can not attatch documents to process	
	END
		
	
	-- Update Stage Notes if ProcessStageID passed
	
	IF @ProcessStageID IS NOT NULL
	BEGIN
		UPDATE OW.tblProcessStages
		SET Notes=@StageNotes
		WHERE ProcessStageID=@ProcessStageID
		
		SET @Error = @@ERROR
		IF @Error <> 0 RETURN @Error
	END
	

	-- Delete Documents removed by user.

	DELETE FROM OW.tblProcessDocuments
	WHERE ProcessID=@ProcessID -- only to guarantee that user don't remove documents from other processes. It's not necessary. Only by security!
	AND EXISTS (SELECT 1 FROM OW.StringToTable(@DocumentOperationList,',') A INNER JOIN OW.StringToTable(@DocumentIDList,',') B
					ON (A.ID=B.ID)
					WHERE A.Item='D' AND OW.tblProcessDocuments.ProcessDocumentID=B.Item)
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
	
	-- Insert Documents added by user

	INSERT INTO OW.tblProcessDocuments (ProcessID, FileID, ProcessStageID, AssociationDate, AssociationUserID)
	SELECT @ProcessID, B.Item, case when (C.Item='S') then @ProcessStageID else NULL end, getdate(), @UserID
	FROM OW.StringToTable(@DocumentOperationList,',') A 
	INNER JOIN OW.StringToTable(@DocumentIDList,',') B ON (A.ID=B.ID)
	INNER JOIN OW.StringToTable(@DocumentAssociationList,',') C ON (B.ID=C.ID)
	WHERE A.Item='I'

	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error

	RETURN 0

GO
























CREATE PROCEDURE OW.usp_SuspendProcess

	(
	@ProcessID numeric (18), 
	@UserID numeric (18),
	@Notes varchar (100)
	)

AS
	DECLARE @Error int
	DECLARE @IsActive bit
	
	-- Ter em atenção a concorrência, quando dois postos tentam
	-- suspender o processo. Introduzir um lock! andre
	
	BEGIN TRANSACTION
	
	-- Check if process is active
	
	SET @IsActive = 0
	
	SELECT @IsActive = 1 FROM OW.tblProcess
	WHERE ProcessID=@ProcessID AND State=1
	
	IF @IsActive = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2  -- Process is not active
	END
		
	-- Suspend the process
	
	UPDATE OW.tblProcess
	SET State=2
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Falta escrever o log no tblProcessAudits. andre.

	COMMIT TRANSACTION
	RETURN 0

GO
























CREATE PROCEDURE OW.usp_ResumeProcess

	(
	@ProcessID numeric (18), 
	@UserID numeric (18)
	)

AS
	DECLARE @Error int
	DECLARE @IsSuspended bit
	
	
	
	-- Ter em atenção a concorrência, quando dois postos tentam
	-- reactivar o processo. Introduzir um lock! andre
	
	BEGIN TRANSACTION
	
	-- Check if process is suspended
	
	SET @IsSuspended = 0
	
	SELECT @IsSuspended = 1 FROM OW.tblProcess
	WHERE ProcessID=@ProcessID AND State=2
	
	IF @IsSuspended = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2  -- Process is not suspended
	END
		
	-- Resume the process
	
	UPDATE OW.tblProcess
	SET State=1
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	

	COMMIT TRANSACTION
	RETURN 0

GO




























CREATE PROCEDURE OW.usp_DeleteProcess

	(
	@ProcessID numeric (18), 
	@UserID numeric (18)
	)

AS
	DECLARE @Error int
	DECLARE @IsAnnulled bit
	
	
	BEGIN TRANSACTION
	
	-- Check if process is annulled
	
	SET @IsAnnulled = 0
	
	SELECT @IsAnnulled = 1 FROM OW.tblProcess
	WHERE ProcessID=@ProcessID AND State=3
	
	IF @IsAnnulled = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2  -- Process is not annulled
	END
		
	-- Delete the process
	
	DELETE FROM OW.tblProcess
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Registar o log. andre

	COMMIT TRANSACTION
	RETURN 0

GO


























CREATE PROCEDURE OW.usp_GetProcess

	(
	@ProcessID numeric(18)
	)

AS

	SELECT ProcessID, Code, Number, Year, Name, State, DurationDays, DurationHours, WorkCalendar, StartDate, LimitDate, FinishDate, WorkCompleted, OriginatorAccess
	FROM OW.tblProcess 
	WHERE ProcessID=@ProcessID
	
	RETURN @@ERROR

GO
























CREATE PROCEDURE OW.usp_GetProcessesByID

	(
	@IdsList varchar(8000)
	)

AS

	SELECT PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.Name, PR.State, PR.StartDate, PR.LimitDate, PR.FinishDate, PR.WorkCompleted
	FROM OW.tblProcess PR
	WHERE PR.ProcessID in (SELECT Item FROM OW.StringToTable(@IdsList,','))
	ORDER BY PR.StartDate DESC
	
	RETURN @@ERROR
GO


























CREATE PROCEDURE OW.usp_GetProcessSecondExecutant

	(
	@ProcessID numeric(18)
	)

AS

	SELECT 
		case when (ExecutantID is not null ) then ExecutantID 
		when (ExecutantID is null and ExecutantType='U') then ExecutantTypeUserID
		else ExecutantTypeGroupID end as ID,
		case when (ExecutantID is not null ) then 'U' 
		when (ExecutantID is null and ExecutantType='U') then 'U' 
		else 'G' end as Type
	FROM OW.tblProcessStages PRST 
	WHERE ProcessID=@ProcessID AND PRST.Number=2
	
	RETURN @@ERROR

GO
































CREATE PROCEDURE OW.usp_GetUserProcessesToDispatch

	(
	@UserID numeric(18),
	@PageNumber numeric(18) OUTPUT,
	@PageSize INT,
	@TotalRegs INT OUTPUT /* Return RowCount */
	)

AS
	DECLARE @QUERY VARCHAR(1000)

	SELECT @TotalRegs=COUNT(*)
	FROM OW.tblProcess PR INNER JOIN OW.tblProcessStages PRST
	ON (PR.ProcessID=PRST.ProcessID)
	WHERE PR.State in (1,2) -- Only Active or Suspended Processes
	AND PRST.ExecutantID=@UserID -- user is executant
	AND PRST.StartDate is not null AND PRST.FinishDate is null -- of current stage


	/************************ Page Calculations ****************************/
	DECLARE  @GetNRegs numeric(18)
	DECLARE  @NPages numeric(18)

	SET @GetNRegs=0
	--Get Number of pages
	SET @NPages=@TotalRegs/@PageSize; 
	--Number of pages + 1 a uncomplete page if exists
	IF (@TotalRegs%@PageSize<>0) SET @NPages=@NPages+1
	--if the request page > lastpage then give the last page
	IF (@PageNumber>@NPages) SET @PageNumber=@NPages
	--if the request page < firstpage then give the first page
	IF (@PageNumber<1)SET @PageNumber=1
	--if the request page == lastpage and lastpage is a uncomplete page then get just the last regs 
	IF (@PageNumber=@NPages AND @TotalRegs%@PageSize<>0)
		SET @GetNRegs=(@TotalRegs%@PageSize)
	ELSE
		SET @GetNRegs=@PageSize
	/************************ ***************** ****************************/

	SET @QUERY = 'SELECT * FROM(SELECT TOP ' + CAST(@GetNRegs AS VARCHAR(20)) + ' * FROM (
	SELECT TOP ' +  CAST((@PageNumber * @PageSize) AS  VARCHAR(20)) + ' PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.State, PR.WorkCompleted,PRST.Name, PRST.StartDate, PRST.LimitDate, PRST.ReadDate 
	FROM OW.tblProcess PR INNER JOIN OW.tblProcessStages PRST ON (PR.ProcessID=PRST.ProcessID) 
	WHERE PR.State in (1,2) AND PRST.ExecutantID=' + CAST(@UserID AS VARCHAR(18)) + ' 
	AND PRST.StartDate is not null AND PRST.FinishDate is null ORDER BY PRST.StartDate DESC
	) AS TB1 ORDER BY StartDate ASC) AS TB2 ORDER BY StartDate DESC'

	EXECUTE (@QUERY)
	RETURN @@ERROR
GO





















CREATE PROCEDURE OW.usp_GetUserProcessesDispatched

	(
	@UserID numeric(18),
	@PageNumber numeric(18) OUTPUT,
	@PageSize INT,
	@TotalRegs INT OUTPUT /* Return RowCount */
	)

AS
	DECLARE @QUERY VARCHAR(1000)

	SELECT @TotalRegs=COUNT(*)
	FROM OW.tblProcess PR 
	WHERE PR.State in (1,2) -- Only Active or Suspended Processes
	AND exists (select 1 from OW.tblProcessStages PRST2 
			where PR.ProcessID=PRST2.ProcessID
			and PRST2.ExecutantID=@UserID -- the user dispatched at least one stage
			and PRST2.StartDate is not null and PRST2.FinishDate is not null)


	/************************ Page Calculations ****************************/
	DECLARE  @GetNRegs numeric(18)
	DECLARE  @NPages numeric(18)

	SET @GetNRegs=0
	--Get Number of pages
	SET @NPages=@TotalRegs/@PageSize; 
	--Number of pages + 1 a uncomplete page if exists
	IF (@TotalRegs%@PageSize<>0) SET @NPages=@NPages+1
	--if the request page > lastpage then give the last page
	IF (@PageNumber>@NPages) SET @PageNumber=@NPages
	--if the request page < firstpage then give the first page
	IF (@PageNumber<1)SET @PageNumber=1
	--if the request page == lastpage and lastpage is a uncomplete page then get just the last regs 
	IF (@PageNumber=@NPages AND @TotalRegs%@PageSize<>0)
		SET @GetNRegs=(@TotalRegs%@PageSize)
	ELSE
		SET @GetNRegs=@PageSize
	/************************ ***************** ****************************/


	SET @QUERY = 'SELECT * FROM(SELECT TOP ' + CAST(@GetNRegs AS VARCHAR(20)) + ' * FROM (
	SELECT TOP ' +  CAST((@PageNumber * @PageSize) AS  VARCHAR(20)) + ' PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.Name, PR.State,
	PR.StartDate, PR.LimitDate, PR.WorkCompleted
	FROM OW.tblProcess PR 
	WHERE PR.State in (1,2) -- Only Active or Suspended Processes
	AND exists (select 1 from OW.tblProcessStages PRST2 
			where PR.ProcessID=PRST2.ProcessID
			and PRST2.ExecutantID=' + CAST(@UserID AS VARCHAR(18)) + ' -- the user dispatched at least one stage
			and PRST2.StartDate is not null and PRST2.FinishDate is not null)
	ORDER BY PR.StartDate DESC
	) AS TB1 ORDER BY StartDate ASC) AS TB2 ORDER BY StartDate DESC'

	EXECUTE (@QUERY)	
	RETURN @@ERROR

GO


























CREATE PROCEDURE OW.usp_GetUserProcessesExpired

	(
	@UserID numeric(18),
	@PageNumber numeric(18) OUTPUT,
	@PageSize INT,
	@TotalRegs INT OUTPUT /* Return RowCount */
	)

AS
	DECLARE @QUERY VARCHAR(1000)

	SELECT @TotalRegs=COUNT(*)
	FROM OW.tblProcess PR 
	WHERE PR.State in (1,2)-- Only Active or Suspended Processes
	AND getdate() > PR.LimitDate -- Expired processes
	AND exists (select 1 from OW.tblProcessStages PRST2 
			where PR.ProcessID=PRST2.ProcessID
			and PRST2.ExecutantID=@UserID -- User was or is executant
	)


	/************************ Page Calculations ****************************/
	DECLARE  @GetNRegs numeric(18)
	DECLARE  @NPages numeric(18)

	SET @GetNRegs=0
	--Get Number of pages
	SET @NPages=@TotalRegs/@PageSize; 
	--Number of pages + 1 a uncomplete page if exists
	IF (@TotalRegs%@PageSize<>0) SET @NPages=@NPages+1
	--if the request page > lastpage then give the last page
	IF (@PageNumber>@NPages) SET @PageNumber=@NPages
	--if the request page < firstpage then give the first page
	IF (@PageNumber<1)SET @PageNumber=1
	--if the request page == lastpage and lastpage is a uncomplete page then get just the last regs 
	IF (@PageNumber=@NPages AND @TotalRegs%@PageSize<>0)
		SET @GetNRegs=(@TotalRegs%@PageSize)
	ELSE
		SET @GetNRegs=@PageSize
	/************************ ***************** ****************************/

	
	SET @QUERY = 'SELECT * FROM(SELECT TOP ' + CAST(@GetNRegs AS VARCHAR(20)) + ' * FROM (
	SELECT TOP ' +  CAST((@PageNumber * @PageSize) AS  VARCHAR(20)) + ' PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.Name, PR.State, PR.StartDate, PR.LimitDate, PR.WorkCompleted
	FROM OW.tblProcess PR 
	WHERE PR.State in (1,2)-- Only Active or Suspended Processes
	AND getdate() > PR.LimitDate -- Expired processes
	AND exists (select 1 from OW.tblProcessStages PRST2 
			where PR.ProcessID=PRST2.ProcessID
			and PRST2.ExecutantID=' + CAST(@UserID AS VARCHAR(18)) + '-- User was or is executant
	)
	ORDER BY PR.LimitDate DESC
	) AS TB1 ORDER BY LimitDate ASC) AS TB2 ORDER BY LimitDate DESC'
	
	EXECUTE (@QUERY)
	RETURN @@ERROR

GO

























CREATE PROCEDURE OW.usp_GetUserProcessesToAccept

	(
	@UserID numeric(18),
	@PageNumber numeric(18) OUTPUT,
	@PageSize INT,
	@TotalRegs INT OUTPUT /* Return RowCount */
	)

AS
	DECLARE @QUERY VARCHAR(1000)
	
	SELECT @TotalRegs=COUNT(*)
	FROM OW.tblProcess PR INNER JOIN OW.tblProcessStages PRST
	ON (PR.ProcessID=PRST.ProcessID)INNER JOIN OW.tblGroups G
	ON (PRST.ExecutantTypeGroupID=G.GroupID)
	WHERE PR.State in (1,2) -- Only Active or Suspended Processes
	AND PRST.StartDate is not null AND PRST.FinishDate is null -- to get the GroupName of current stage
	AND PRST.ExecutantID is null -- the stage is not accepted yet
	AND exists (select 1 from OW.tblGroupsUsers GU
			where PRST.ExecutantTypeGroupID=GU.GroupID
			and GU.UserID=@UserID) -- User belongs to the executant group

	/************************ Page Calculations ****************************/
	DECLARE  @GetNRegs numeric(18)
	DECLARE  @NPages numeric(18)

	SET @GetNRegs=0
	--Get Number of pages
	SET @NPages=@TotalRegs/@PageSize; 
	--Number of pages + 1 a uncomplete page if exists
	IF (@TotalRegs%@PageSize<>0) SET @NPages=@NPages+1
	--if the request page > lastpage then give the last page
	IF (@PageNumber>@NPages) SET @PageNumber=@NPages
	--if the request page < firstpage then give the first page
	IF (@PageNumber<1)SET @PageNumber=1
	--if the request page == lastpage and lastpage is a uncomplete page then get just the last regs 
	IF (@PageNumber=@NPages AND @TotalRegs%@PageSize<>0)
		SET @GetNRegs=(@TotalRegs%@PageSize)
	ELSE
		SET @GetNRegs=@PageSize
	/************************ ***************** ****************************/


	SET @QUERY = 'SELECT * FROM(SELECT TOP ' + CAST(@GetNRegs AS VARCHAR(20)) + ' * FROM (
	SELECT TOP ' +  CAST((@PageNumber * @PageSize) AS  VARCHAR(20)) + ' PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.State, PR.WorkCompleted,
	PRST.ProcessStageID, PRST.Name, PRST.StartDate, PRST.LimitDate, G.GroupDesc
	FROM OW.tblProcess PR INNER JOIN OW.tblProcessStages PRST
	ON (PR.ProcessID=PRST.ProcessID)INNER JOIN OW.tblGroups G
	ON (PRST.ExecutantTypeGroupID=G.GroupID)
	WHERE PR.State in (1,2) -- Only Active or Suspended Processes
	AND PRST.StartDate is not null AND PRST.FinishDate is null -- to get the GroupName of current stage
	AND PRST.ExecutantID is null -- the stage is not accepted yet
	AND exists (select 1 from OW.tblGroupsUsers GU
			where PRST.ExecutantTypeGroupID=GU.GroupID
			and GU.UserID=' + CAST(@UserID AS VARCHAR(18)) + ') -- User belongs to the executant group
	ORDER BY PRST.StartDate DESC
	) AS TB1 ORDER BY StartDate ASC) AS TB2 ORDER BY StartDate DESC'

	EXECUTE (@QUERY)
	RETURN @@ERROR

GO



























CREATE PROCEDURE OW.usp_GetUserProcessesEnded

	(
	@UserID numeric(18),
	@PageNumber numeric(18) OUTPUT,
	@PageSize INT,
	@TotalRegs INT OUTPUT /* Return RowCount */
	)

AS
	DECLARE @QUERY VARCHAR(1000)

	SELECT @TotalRegs=COUNT(*)
	FROM OW.tblProcess PR 
	WHERE PR.State=4 -- Only Ended Processes
	AND exists (select 1 from OW.tblProcessStages PRST 
			where PR.ProcessID=PRST.ProcessID
			and PRST.ExecutantID=@UserID -- the user dispatched at least one stage
			)


	/************************ Page Calculations ****************************/
	DECLARE  @GetNRegs numeric(18)
	DECLARE  @NPages numeric(18)

	SET @GetNRegs=0
	--Get Number of pages
	SET @NPages=@TotalRegs/@PageSize; 
	--Number of pages + 1 a uncomplete page if exists
	IF (@TotalRegs%@PageSize<>0) SET @NPages=@NPages+1
	--if the request page > lastpage then give the last page
	IF (@PageNumber>@NPages) SET @PageNumber=@NPages
	--if the request page < firstpage then give the first page
	IF (@PageNumber<1)SET @PageNumber=1
	--if the request page == lastpage and lastpage is a uncomplete page then get just the last regs 
	IF (@PageNumber=@NPages AND @TotalRegs%@PageSize<>0)
		SET @GetNRegs=(@TotalRegs%@PageSize)
	ELSE
		SET @GetNRegs=@PageSize
	/************************ ***************** ****************************/


	SET @QUERY = 'SELECT * FROM(SELECT TOP ' + CAST(@GetNRegs AS VARCHAR(20)) + ' * FROM (
	SELECT TOP ' +  CAST((@PageNumber * @PageSize) AS  VARCHAR(20)) + ' PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.Name, PR.State,
	PR.StartDate, PR.LimitDate, PR.FinishDate, PR.WorkCompleted
	FROM OW.tblProcess PR 
	WHERE PR.State=4 -- Only Ended Processes
	AND exists (select 1 from OW.tblProcessStages PRST 
			where PR.ProcessID=PRST.ProcessID
			and PRST.ExecutantID=' + CAST(@UserID AS VARCHAR(18)) + ' -- the user dispatched at least one stage
			)
	ORDER BY PR.FinishDate DESC
	) AS TB1 ORDER BY FinishDate ASC) AS TB2 ORDER BY FinishDate DESC'

	EXECUTE (@QUERY)
	RETURN @@ERROR

GO

























/* ********************** PROCESS STAGES ********************************/

CREATE PROCEDURE OW.usp_NewProcessStage

	(
	@ProcessID numeric (18),
	@Number numeric (3),
	@Name varchar (50),
	@ExecutantType char,
	@ExecutantTypeUserID numeric (18),
	@ExecutantTypeGroupID numeric (18),
	@DurationDays numeric(3),
	@DurationHours numeric(5,2),
	@ProcessStageID numeric(18) OUTPUT /* Return new ProcessStageID */
	)

AS
	DECLARE @Error int
	DECLARE @ProcessDurationDays numeric(6),
	@ProcessDurationHours numeric(8,2)
	
	-- Insert Process Stage
	INSERT INTO OW.tblProcessStages (ProcessID, Number, Name, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID, DurationDays, DurationHours)
	VALUES (@ProcessID, @Number, ltrim(rtrim(@Name)), @ExecutantType, @ExecutantTypeUserID, @ExecutantTypeGroupID, @DurationDays, @DurationHours)
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
	SET @ProcessStageID=@@IDENTITY
	
	
	-- Calculate new Process Duration ( sum returns NULL if exists a stage with a NULL duration )
	SELECT @ProcessDurationDays=sum(DurationDays), @ProcessDurationHours=sum(DurationHours)
	FROM OW.tblProcessStages WHERE ProcessID=@ProcessID
	AND NOT EXISTS (SELECT 1 FROM OW.tblProcessStages 
					WHERE ProcessID=@ProcessID
					AND DurationDays IS NULL AND DurationHours IS NULL)
	
	-- Update Process Duration
	UPDATE OW.tblProcess
	SET DurationDays=@ProcessDurationDays, DurationHours=@ProcessDurationHours
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
	RETURN 0
GO



















CREATE PROCEDURE OW.usp_GetProcessStages

	(
	@ProcessID numeric(18)
	)

AS
	
	
	SELECT ProcessStageID, Number, Name,
		ExecutantTypeGroupID,
		ExecutantID, 
		case when (ExecutantID is not null ) then U2.UserDesc 
		when (ExecutantID is null and ExecutantType='U') then U1.UserDesc 
		else G.GroupDesc end as ExecutantName,
		DurationDays, DurationHours,
		StartDate, ReadDate, LimitDate, FinishDate, Notes
	FROM OW.tblProcessStages PRST 
		LEFT JOIN OW.tblUser U1
	    ON PRST.ExecutantTypeUserID=U1.UserID
	    LEFT JOIN OW.tblUser U2
	    ON PRST.ExecutantID=U2.UserID
	    LEFT JOIN OW.tblGroups G
	    ON PRST.ExecutantTypeGroupID=G.GroupID
	WHERE ProcessID=@ProcessID
	ORDER BY Number
	
	RETURN @@ERROR

GO























CREATE PROCEDURE OW.usp_GetProcessStage

	(
	@ProcessStageID numeric(18)
	)

AS
	
	
	SELECT ProcessStageID, Number, Name,
		ExecutantID, 
		case when (ExecutantID is not null ) then U2.UserDesc 
		when (ExecutantID is null and ExecutantType='U') then U1.UserDesc 
		else G.GroupDesc end as ExecutantName,
		DurationDays, DurationHours,
		StartDate, ReadDate, LimitDate, FinishDate, Notes
	FROM OW.tblProcessStages PRST 
		LEFT JOIN OW.tblUser U1
	    ON PRST.ExecutantTypeUserID=U1.UserID
	    LEFT JOIN OW.tblUser U2
	    ON PRST.ExecutantID=U2.UserID
	    LEFT JOIN OW.tblGroups G
	    ON PRST.ExecutantTypeGroupID=G.GroupID
	WHERE ProcessStageID=@ProcessStageID
	ORDER BY Number
	
	RETURN @@ERROR

GO

























CREATE PROCEDURE OW.usp_AcceptProcessStage

	(
	@ProcessStageID numeric (18),
	@UserID numeric (18)
	)

AS

	
	-- Ter em atenção a concorrência, quando dois utilizadores tentam
	-- aceitar a mesma etapa. Introduzir um lock! andre

	
	-- Check if user can accept the stage
	DECLARE @CanAccept bit
	
	SET @CanAccept=OW.CanAcceptStage(@ProcessStageID, @UserID)
	
	IF @CanAccept = 0 RETURN -2  -- User can not accept the stage
	
		
	-- Attribute the stage to the user.

	UPDATE OW.tblProcessStages
	SET ExecutantID=@UserID, ReadDate=getdate()
	WHERE ProcessStageID=@ProcessStageID


	RETURN @@ERROR

GO


























/* ********************** PROCESS DOCUMENTS ********************************/

CREATE PROCEDURE OW.usp_GetProcessDocuments

	(
	@ProcessID numeric(18)
	)

AS
	
	
	SELECT PRDOC.ProcessDocumentID, PRDOC.ProcessID, PRDOC.ProcessStageID, 
	FM.FileID, FM.FileName, PRDOC.AssociationDate, PRDOC.AssociationUserID, U.UserDesc,
	PRST.Number as StageNumber
	FROM OW.tblProcessDocuments PRDOC 
	INNER JOIN OW.tblFileManager FM ON PRDOC.FileID=FM.FileID 
	INNER JOIN OW.tblUser U ON PRDOC.AssociationUserID=U.UserID
	LEFT JOIN OW.tblProcessStages PRST ON PRDOC.ProcessStageID=PRST.ProcessStageID
	WHERE PRDOC.ProcessID=@ProcessID
	ORDER BY PRDOC.AssociationDate
	
	RETURN @@ERROR

GO






















-- Checks if User have access to Read a Process Document.
-- @FileID returns zero if User do not have access to document 
-- or if the document do not exists.


CREATE PROCEDURE OW.usp_GetProcessDocumentFileID

	(
	@ProcessDocumentID numeric(18),
	@UserID numeric(18),
	@FileID numeric(18) OUTPUT
	)

AS
	DECLARE @WorkFlowManager bit

	SET @FileID = 0
	SET @WorkFlowManager = 0

	/* Verificar se o utilizador é Gestor do workflow */
	SELECT @WorkFlowManager=1 FROM OW.tblAccess
	WHERE UserID=@UserID
	AND ObjectTypeID=1
	AND ObjectParentID=6 /* Workflow*/
	AND ObjectID=7 /* Gestor */

	IF @WorkFlowManager=1
	BEGIN
		SELECT @FileID=PRDOC.FileID
		FROM OW.tblProcessDocuments PRDOC
		WHERE PRDOC.ProcessDocumentID=@ProcessDocumentID
		
		IF @FileID IS NULL
			SET @FileID=0
	
		RETURN 0
	END
	

	SELECT @FileID=PRDOC.FileID
	FROM OW.tblProcessDocuments PRDOC
	INNER JOIN OW.tblProcess PR ON (PRDOC.ProcessID=PR.ProcessID)
	WHERE PRDOC.ProcessDocumentID=@ProcessDocumentID
	/* Se originador não tiver acesso
		então o utilizador não pode ser originador, isto é,
		O Originador tem acesso ou então o utilizador não é o Originador */
	AND
	(
	PR.OriginatorAccess=1 
	or
	exists (select 1 from OW.tblProcessStages PRST
				where PR.ProcessID=PRST.ProcessID
				and PRST.Number=1 and PRST.ExecutantID<>@UserID
			)
	)
	AND
	(   /* O utilizador foi ou é executante */
		exists(select 1 from OW.tblProcessStages PRST
			where PR.ProcessID=PRST.ProcessID
			and PRST.ExecutantID=@UserID
			)
		or
		/* O utilizador tem acesso de Consulta */
		exists ( select 1 from OW.tblProcessUserAccesses PRUA
				where PR.ProcessID=PRUA.ProcessID
				and PRUA.UserID=@UserID
			)
		or
		/* O utilizador pertencente a um grupo com acesso de Consulta */
		exists ( select 1 from OW.tblProcessGroupAccesses PRGA,
							OW.tblGroupsUsers GU
				where PR.ProcessID=PRGA.ProcessID
				and PRGA.GroupID=GU.GroupID
				and GU.UserID=@UserID
			)
	)



	IF @FileID IS NULL 
		SET @FileID=0
	
	RETURN @@ERROR

GO


























/* ********************** ALARMS ********************************/


CREATE PROCEDURE OW.usp_NewAlarm

	(
	@AlarmDateTime datetime, 
	@ProcessAlarmID numeric(18),
	@AlarmID numeric(18) OUTPUT /* Return new AlarmID */
	)

AS
	DECLARE @Error INT

	-- IF @AlarmDateTime IS NULL RETURN -1 -- Invalid Parameters
	
	INSERT INTO OW.tblAlarms (AlarmDateTime, ProcessAlarmID)
	VALUES (@AlarmDateTime, @ProcessAlarmID)
	
	SET @Error = @@ERROR
	IF @Error <> 0  RETURN @Error
	
	SET @AlarmID=@@IDENTITY
	
	RETURN @@ERROR

GO





























CREATE PROCEDURE OW.usp_DeleteAlarm

	(
	@AlarmID numeric(18)
	)

AS

	DELETE FROM OW.tblAlarms
	WHERE AlarmID=@AlarmID
			
	RETURN @@ERROR

GO
























/* ********************** PROCESS ALARMS ********************************/

CREATE PROCEDURE OW.usp_NewProcessAlarm

	(
	@ProcessID numeric (18),
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@ProcessStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric (1),
	@AddresseeExecutant numeric (1),
	@AddresseeTypeList varchar (8000),
	@AddresseeIDList varchar (8000),
	@ProcessAlarmID numeric (18) OUTPUT   /* Return new ProcessAlarmID */
	)

AS
	DECLARE @Error int
	
	-- Insert ProcessAlarm data

	INSERT INTO OW.tblProcessAlarms (ProcessID , Occurence , OccurenceOffsetDays, OccurenceOffsetHours  , ProcessStageID , Message , AlertByEMail , AddresseeExecutant )
	VALUES (@ProcessID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours , @ProcessStageID , ltrim(rtrim(@Message)) , @AlertByEMail , @AddresseeExecutant )

	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error

	
	SET @ProcessAlarmID=@@IDENTITY
	

	-- Insert Addresses

	IF LEN (@AddresseeIDList) > 0
	BEGIN
		INSERT INTO OW.tblProcessAlarmAddressees (ProcessAlarmID , AddresseeType , UserID, GroupID )
		SELECT @ProcessAlarmID, A.Item, 
		case when (A.Item='U') then B.Item else NULL end,
		case when (A.Item='G') then B.Item else NULL end
		FROM OW.StringToTable(@AddresseeTypeList,',') A INNER JOIN OW.StringToTable(@AddresseeIDList,',')B
		ON (A.ID=B.ID)

		SET @Error = @@ERROR
		IF @Error <> 0 RETURN @Error
	END


	RETURN 0

GO























CREATE PROCEDURE OW.usp_DeleteProcessAlarm

	(
	@ProcessAlarmID numeric(18)
	)

AS


	DELETE OW.tblProcessAlarms WHERE ProcessAlarmID=@ProcessAlarmID
	
	
	RETURN @@ERROR

GO




































CREATE PROCEDURE OW.usp_GetProcessAlarms

	(
	@ProcessID numeric(18)
	)

AS

		
	SELECT PRAL.ProcessAlarmID, PRAL.Occurence , PRAL.OccurenceOffsetDays , PRAL.OccurenceOffsetHours,
		PRAL.Message , PRAL.AlertByEMail , PRAL.AddresseeExecutant
	FROM OW.tblProcessAlarms PRAL 
	WHERE PRAL.ProcessID=@ProcessID and PRAL.ProcessStageID IS NULL
	ORDER BY PRAL.ProcessAlarmID
	
	
	RETURN @@ERROR

GO


























CREATE PROCEDURE OW.usp_GetProcessStageAlarms

	(
	@ProcessStageID numeric(18)
	)

AS

		
	SELECT PRAL.ProcessAlarmID, PRAL.Occurence , PRAL.OccurenceOffsetDays , PRAL.OccurenceOffsetHours,
		PRAL.Message , PRAL.AlertByEMail , PRAL.AddresseeExecutant
	FROM OW.tblProcessAlarms PRAL 
	WHERE PRAL.ProcessStageID=@ProcessStageID
	ORDER BY PRAL.ProcessAlarmID
	
	
	RETURN @@ERROR

GO





















CREATE PROCEDURE OW.usp_GetProcessAlarm

	(
	@ProcessAlarmID numeric(18)
	)

AS

		
	SELECT PRAL.ProcessAlarmID, PRAL.Occurence , PRAL.OccurenceOffsetDays , PRAL.OccurenceOffsetHours,
		PRAL.ProcessStageID, PRAL.Message , PRAL.AlertByEMail , PRAL.AddresseeExecutant
	FROM OW.tblProcessAlarms PRAL 
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID
	
	
	RETURN @@ERROR

GO


























CREATE PROCEDURE OW.usp_GetProcessAlarmsToTrigger


AS

	-- Get at most 1000 Alarms because the select duration was very high
	-- and crashs the windows service !
	SELECT TOP 1000 ALM.AlarmID, PRAL.ProcessAlarmID, PRAL.ProcessID, PR.Code, PR.Number, PR.Year, PR.Name,
	PRAL.Occurence , PRAL.OccurenceOffsetDays , PRAL.OccurenceOffsetHours,
	PRAL.ProcessStageID, PRAL.Message , PRAL.AlertByEMail , PRAL.AddresseeExecutant
	FROM OW.tblAlarms ALM 
	INNER JOIN OW.tblProcessAlarms PRAL ON (ALM.ProcessAlarmID=PRAL.ProcessAlarmID)
	INNER JOIN OW.tblProcess PR ON (PRAL.ProcessID=PR.ProcessID)
	WHERE ALM.AlarmDateTime <= getdate()
	ORDER BY ALM.AlarmDateTime
	
	
	RETURN @@ERROR

GO

























CREATE PROCEDURE OW.usp_GetProcessAlarmAddressees

	(
	@ProcessAlarmID numeric(18)
	)

AS

	
	
	SELECT PRAA.ProcessAlarmID, PRAA.AddresseeType , 
		case when (PRAA.AddresseeType='U') then PRAA.UserID else PRAA.GroupID end as AddresseeID,
		case when (PRAA.AddresseeType='U') then U.UserDesc else G.GroupDesc end as AddresseeName
	FROM OW.tblProcessAlarmAddressees PRAA 
		LEFT JOIN OW.tblUser U ON (PRAA.UserID=U.UserID)
		LEFT JOIN OW.tblGroups G ON (PRAA.GroupID=G.GroupID)
	WHERE PRAA.ProcessAlarmID=@ProcessAlarmID

	
	RETURN @@ERROR

GO





















-- Returns all Users Addressees Email of a ProcessAlarm
-- If email did not exists returns user login.
-- The "Select ... Union ..." statment guarantees that now duplicated emails
-- are returned.
CREATE PROCEDURE OW.usp_GetProcessAlarmUsersAddressees

	(
	@ProcessAlarmID numeric(18)
	)

AS
	-- ALTERAR os selects para usar exists !!! andre
	
	
	-- User Executant of current stage, if stage is assigned to a user
	SELECT U.UserMail
	FROM OW.tblProcessAlarms PRAL
		INNER JOIN OW.tblProcessStages PRST ON (PRAL.ProcessID=PRST.ProcessID)
		INNER JOIN OW.tblUser U ON (PRST.ExecutantID=U.UserID)
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID 
	AND PRAL.AddresseeExecutant=1
	AND PRST.StartDate IS NOT NULL AND PRST.FinishDate IS NULL
	AND U.UserMail IS NOT NULL AND U.UserMail<>''
	UNION
	-- Users that belongs to Executant Group of current stage, 
	-- if stage is not yet attributed to a user
	SELECT U.UserMail
	FROM OW.tblProcessAlarms PRAL
		INNER JOIN OW.tblProcessStages PRST ON (PRAL.ProcessID=PRST.ProcessID)
		INNER JOIN OW.tblGroupsUsers GU ON (PRST.ExecutantTypeGroupID=GU.GroupID)
		INNER JOIN OW.tblUser U ON (GU.UserID=U.UserID)
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID 
	AND PRAL.AddresseeExecutant=1
	AND PRST.StartDate IS NOT NULL AND PRST.FinishDate IS NULL
	AND PRST.ExecutantID IS NULL
	AND U.UserMail IS NOT NULL AND U.UserMail<>''  
	UNION
	-- Users addressees
	SELECT U.UserMail
	FROM OW.tblProcessAlarmAddressees PRAA 
		INNER JOIN OW.tblUser U ON (PRAA.UserID=U.UserID)
	WHERE PRAA.ProcessAlarmID=@ProcessAlarmID
	AND U.UserMail IS NOT NULL AND U.UserMail<>''
	UNION
	-- Users that belongs to groups addressees
	SELECT U.UserMail
	FROM OW.tblProcessAlarmAddressees PRAA 
		INNER JOIN OW.tblGroupsUsers GU ON (PRAA.GroupID=GU.GroupID)
		INNER JOIN OW.tblUser U ON (GU.UserID=U.UserID)
	WHERE PRAA.ProcessAlarmID=@ProcessAlarmID
	AND U.UserMail IS NOT NULL AND U.UserMail<>''
	
	RETURN @@ERROR

GO





















--*************************************************************
--     
-- Name: GetProcessAlarmDateTime 
-- Description:
-- Calculates the alarm datetime for process or stage alarm.
-- 
--
-- Inputs:
-- 	@Occurence - One of {1,2,3,4,5,6,7}
--	@OccurenceOffsetDays 
--	@OccurenceOffsetHours 
--	@StartDate - Stage StartDate. Only for @Occurence=7
--	@LimitDate - Process or Stage LimitDate
-- 
--
-- Returns:
-- Alarm datetime.
-- Returns NULL if a invalid parameter was passed.
-- 
--*************************************************************

CREATE FUNCTION OW.GetProcessAlarmDateTime
	(
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@StartDate datetime,
	@LimitDate datetime
	)
RETURNS datetime
AS

BEGIN

	DECLARE @ProcessAlarmDateTime datetime
	
	SET @ProcessAlarmDateTime=NULL
	
	-- Before LimitDate of Stage or Process
	IF @Occurence in (1, 4) 
		SET @ProcessAlarmDateTime = @LimitDate - (@OccurenceOffsetDays + @OccurenceOffsetHours/24)
		
	-- On the LimitDate of Stage or Process
	ELSE IF @Occurence in (2, 5) 
		SET @ProcessAlarmDateTime = @LimitDate

	-- After LimitDate of Stage or Process
	ELSE IF @Occurence in (3, 6) 
		SET @ProcessAlarmDateTime = @LimitDate + (@OccurenceOffsetDays + @OccurenceOffsetHours/24)

	-- When Stage is not accept for n time
	ELSE IF @Occurence = 7 
		SET @ProcessAlarmDateTime = @StartDate + (@OccurenceOffsetDays + @OccurenceOffsetHours/24)

	
	RETURN @ProcessAlarmDateTime
END
GO

























-- Activa um alarme especifico, passando @ProcessAlarmID e restantes parametros a null.
-- É utilizado sempre que se adiciona/altera um alarme durante o processo.
--
-- Activa todos os alarmes do processo, passando @ProcessID e restantes parametros a null.
-- É utilizado quando o processo é criado. Não são activados alarmes de etapas.
-- 
-- Activa todos os alarmes de uma etapa, passando @ProcessStageID e restantes parametros a null.
-- É utilizado quando se inicializa a primeira etapa e se transita para a etapa seguinte.
CREATE PROCEDURE OW.usp_ActivateProcessAlarms

	(
	@ProcessAlarmID numeric(18),
	@ProcessID numeric(18),
	@ProcessStageID numeric(18)
	)

AS
	DECLARE @lProcessAlarmID numeric (18), 
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@StartDate datetime,
	@LimitDate datetime
	DECLARE @ProcessAlarmDateTime datetime
	DECLARE @AlarmID numeric(18)
	DECLARE @Error int

	-- Select the ProcessAlarms
	IF @ProcessAlarmID IS NOT NULL
		DECLARE Cursor_ProcessAlarms CURSOR FOR
		SELECT PRAL.ProcessAlarmID, PRAL.Occurence, PRAL.OccurenceOffsetDays, PRAL.OccurenceOffsetHours, case when (PRAL.ProcessStageID IS NULL) then NULL else PRST.StartDate end as StartDate, case when (PRAL.ProcessStageID IS NULL) then PR.LimitDate else PRST.LimitDate end as LimitDate
		FROM OW.tblProcessAlarms PRAL
			INNER JOIN OW.tblProcess PR ON (PRAL.ProcessID=PR.ProcessID)
			LEFT JOIN OW.tblProcessStages PRST ON (PRAL.ProcessStageID=PRST.ProcessStageID)
		WHERE PRAL.ProcessAlarmID=@ProcessAlarmID
	ELSE IF @ProcessID IS NOT NULL
		DECLARE Cursor_ProcessAlarms CURSOR FOR
		SELECT PRAL.ProcessAlarmID, PRAL.Occurence, PRAL.OccurenceOffsetDays, PRAL.OccurenceOffsetHours, NULL as StartDate, PR.LimitDate
		FROM OW.tblProcessAlarms PRAL
			INNER JOIN OW.tblProcess PR ON (PRAL.ProcessID=PR.ProcessID)
		WHERE PRAL.ProcessID=@ProcessID
		AND PRAL.ProcessStageID IS NULL
		AND NOT EXISTS(SELECT ProcessAlarmID FROM OW.tblAlarms ALM WHERE ALM.ProcessAlarmID=PRAL.ProcessAlarmID)
	ELSE IF @ProcessStageID IS NOT NULL
		DECLARE Cursor_ProcessAlarms CURSOR FOR
		SELECT PRAL.ProcessAlarmID, PRAL.Occurence, PRAL.OccurenceOffsetDays, PRAL.OccurenceOffsetHours, PRST.StartDate, PRST.LimitDate
		FROM OW.tblProcessAlarms PRAL
			INNER JOIN OW.tblProcessStages PRST ON (PRAL.ProcessStageID=PRST.ProcessStageID)
		WHERE PRAL.ProcessStageID=@ProcessStageID
	ELSE 
		RETURN -1 -- No parameters
	
	OPEN Cursor_ProcessAlarms
	
	-- Get the first ProcessAlarm
	FETCH NEXT FROM Cursor_ProcessAlarms
	INTO @lProcessAlarmID, @Occurence, @OccurenceOffsetDays, @OccurenceOffsetHours, @StartDate, @LimitDate 
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		-- Activate ProcessAlarm
		SET @ProcessAlarmDateTime = OW.GetProcessAlarmDateTime(@Occurence, @OccurenceOffsetDays, @OccurenceOffsetHours, @StartDate, @LimitDate)
		
		IF @ProcessAlarmDateTime IS NOT NULL
		BEGIN
			EXECUTE @Error=OW.usp_NewAlarm @ProcessAlarmDateTime, @lProcessAlarmID, @AlarmID
			IF @Error<>0 RETURN @Error
		END
		
		-- Get next ProcessAlarm
		FETCH NEXT FROM Cursor_ProcessAlarms
		INTO @lProcessAlarmID, @Occurence, @OccurenceOffsetDays, @OccurenceOffsetHours, @StartDate, @LimitDate
	END
	
	CLOSE Cursor_ProcessAlarms
	DEALLOCATE Cursor_ProcessAlarms
	
	
	RETURN @@ERROR

GO



























-- Desactiva um alarme especifico, passando @ProcessAlarmID e restantes parametros a null.
-- É utilizado sempre que se altera um alarme durante o processo.
--
-- Desactiva todos os alarmes do processo, passando @ProcessID e restantes parametros a null.
-- É utilizado quando o processo termina. Não são desactivados os alarmes de etapas.
-- 
-- Desactiva todos os alarmes de uma etapa, passando @ProcessStageID e restantes parametros a null.
-- É utilizado quando se termina uma etapa.
CREATE PROCEDURE OW.usp_DeactivateProcessAlarm

	(
	@ProcessAlarmID numeric(18),
	@ProcessID numeric(18),
	@ProcessStageID numeric(18)
	)

AS

	IF @ProcessAlarmID IS NOT NULL
	
		DELETE FROM OW.tblAlarms
		WHERE ProcessAlarmID=@ProcessAlarmID
		
	ELSE IF @ProcessID IS NOT NULL
	
		DELETE FROM OW.tblAlarms
		WHERE EXISTS (SELECT 1 FROM OW.tblProcessAlarms
						WHERE OW.tblAlarms.ProcessAlarmID=OW.tblProcessAlarms.ProcessAlarmID
						AND OW.tblProcessAlarms.ProcessID=@ProcessID
						AND OW.tblProcessAlarms.ProcessStageID IS NULL)
		
	ELSE IF @ProcessStageID IS NOT NULL
	
		DELETE FROM OW.tblAlarms
		WHERE EXISTS (SELECT 1 FROM OW.tblProcessAlarms
						WHERE OW.tblAlarms.ProcessAlarmID=OW.tblProcessAlarms.ProcessAlarmID
						AND OW.tblProcessAlarms.ProcessStageID=@ProcessStageID)
		
	ELSE 
		RETURN -1 -- No parameters
			
	RETURN @@ERROR

GO

























CREATE PROCEDURE OW.usp_AddProcessAlarm

	(
	@ProcessID numeric (18),
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@ProcessStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric (1),
	@AddresseeExecutant numeric (1),
	@AddresseeTypeList varchar (8000),
	@AddresseeIDList varchar (8000),
	@ProcessAlarmID numeric (18) OUTPUT   /* Return new ProcessAlarmID */
	)

AS
	DECLARE @Error int
	DECLARE @CurrentStageID numeric(18)


	BEGIN TRANSACTION
	
	-- Insert ProcessAlarm data

	EXECUTE @Error = OW.usp_NewProcessAlarm @ProcessID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours , @ProcessStageID , @Message , @AlertByEMail ,
	@AddresseeExecutant, @AddresseeTypeList, @AddresseeIDList, @ProcessAlarmID OUTPUT
 
	IF @Error<>0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

	-- Activate ProcessAlarm if it is a alarm of process or a alarm of the current stage.
	IF @ProcessStageID IS NULL -- it is a process alarm
	BEGIN
		EXECUTE @Error=OW.usp_ActivateProcessAlarms @ProcessAlarmID, NULL, NULL
		IF @Error<>0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END 
	ELSE
	BEGIN 
		SET @CurrentStageID = 0
		SELECT @CurrentStageID=ProcessStageID
		FROM OW.tblProcessStages
		WHERE ProcessID=@ProcessID
		AND StartDate IS NOT NULL AND FinishDate IS NULL

		IF @ProcessStageID=@CurrentStageID -- it is a alarm of the current stage
		BEGIN
			EXECUTE @Error=OW.usp_ActivateProcessAlarms @ProcessAlarmID, NULL, NULL
			IF @Error<>0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN @Error
			END
		END 
		
	END

	COMMIT TRANSACTION
	RETURN 0

GO


























CREATE PROCEDURE OW.usp_SetProcessAlarm

	(
	@ProcessAlarmID numeric(18), 
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@ProcessStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric (1),
	@AddresseeExecutant numeric (1),
	@AddresseeTypeList varchar(8000),
	@AddresseeIDList varchar(8000)
	)

AS
	DECLARE @Error int

	
	-- Atenção à concorrência. Outro Gestor pode estar a alterar o alarme! andre
	
	BEGIN TRANSACTION

	-- Update alarm table

	UPDATE OW.tblProcessAlarms
	SET Occurence=@Occurence , OccurenceOffsetDays=@OccurenceOffsetDays , OccurenceOffsetHours=@OccurenceOffsetHours,
	ProcessStageID=@ProcessStageID , Message=@Message , AlertByEMail=@AlertByEMail , AddresseeExecutant=@AddresseeExecutant 
	WHERE ProcessAlarmID=@ProcessAlarmID 
	
	SET @Error=@@ERROR
	IF @Error<>0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Delete old Addressees

	DELETE FROM OW.tblProcessAlarmAddressees WHERE ProcessAlarmID=@ProcessAlarmID
	
	SET @Error=@@ERROR
	IF @Error<>0 
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END


	-- Insert new Addressees

	IF LEN (@AddresseeIDList) > 0
	BEGIN
		INSERT INTO OW.tblProcessAlarmAddressees (ProcessAlarmID , AddresseeType , UserID, GroupID )
		SELECT @ProcessAlarmID, A.Item, 
		case when (A.Item='U') then B.Item else NULL end,
		case when (A.Item='G') then B.Item else NULL end
		FROM OW.StringToTable(@AddresseeTypeList,',') A INNER JOIN OW.StringToTable(@AddresseeIDList,',')B
		ON (A.ID=B.ID)

		SET @Error=@@ERROR
		IF @Error<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END

	
	-- Deactivate old alarm
	EXECUTE @Error=OW.usp_DeactivateProcessAlarm @ProcessAlarmID, NULL, NULL
	IF @Error<>0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
				
	-- Activate new alarm
	EXECUTE @Error=OW.usp_ActivateProcessAlarms @ProcessAlarmID, NULL, NULL
	IF @Error<>0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

	
	COMMIT TRANSACTION
	RETURN 0

GO


























/* ********************** PROCESS ACCESSES ********************************/


CREATE PROCEDURE OW.usp_GetUsersAndGroupsWithProcessAccess

	(
	@ProcessID numeric(18)
	)

AS

	-- Only active users WITH access on Process and with access to WorkFlow Application

	SELECT U.UserID ID, 'U' Type, U.UserDesc Name
	FROM OW.tblUser U 
	WHERE U.UserActive=1 
	AND EXISTS (SELECT 1 FROM OW.tblProcessUserAccesses PRUA
			WHERE U.UserID=PRUA.UserID AND PRUA.ProcessID=@ProcessID)
	AND EXISTS (SELECT 1 FROM OW.tblAccess ACC
			WHERE U.UserID=ACC.UserID 
			AND ACC.ObjectParentID=6 AND ACC.ObjectTypeID=1)
	
	UNION

	SELECT G.GroupID ID, 'G' Type, G.GroupDesc Name
	FROM OW.tblGroups G  
	WHERE EXISTS (SELECT 1 FROM OW.tblProcessGroupAccesses PRGA
			WHERE G.GroupID=PRGA.GroupID AND PRGA.ProcessID=@ProcessID)
	ORDER BY Name
	

	RETURN @@ERROR

GO






































CREATE PROCEDURE OW.usp_GetUsersAndGroupsWithoutProcessAccess

	(
	@ProcessID numeric(18)
	)

AS

	-- Only active users WITHOUT access on Process and with access to WorkFlow Application

	SELECT U.UserID ID, 'U' Type, U.UserDesc Name
	FROM OW.tblUser U 
	WHERE U.UserActive=1 
	AND NOT EXISTS (SELECT 1 FROM OW.tblProcessUserAccesses PRUA
			WHERE U.UserID=PRUA.UserID AND PRUA.ProcessID=@ProcessID)
	AND EXISTS (SELECT 1 FROM OW.tblAccess ACC
			WHERE U.UserID=ACC.UserID 
			AND ACC.ObjectParentID=6 AND ACC.ObjectTypeID=1)

	UNION

	SELECT G.GroupID ID, 'G' Type, G.GroupDesc Name
	FROM OW.tblGroups G  
	WHERE  NOT EXISTS (SELECT 1 FROM OW.tblProcessGroupAccesses PRGA
		WHERE G.GroupID=PRGA.GroupID AND PRGA.ProcessID=@ProcessID)
	ORDER BY Name
	
	
	RETURN @@ERROR

GO




























-- Para IDs com 4 algarismos, podem ser atribuidos acessos
-- até 2000 utilizadores! A alternativa é alterar a função para 
-- receber Text em vez de varchar(4000). andre

CREATE PROCEDURE OW.usp_GrantProcessAccess

	(
	@ProcessID numeric (18),
	@IDList varchar (8000),  -- List of (UserId/GroupID) delimiter by comma
	@TypeList varchar (8000) -- List of Type (U/G) delimited by comma
	)

AS
	DECLARE @Error int
	DECLARE @IDTable TABLE (ID numeric(18), Item varchar(8000))
	DECLARE @TypeTable TABLE (ID numeric(18), Item varchar(8000))
	
	-- Convert Lists to Tables
	insert into @IDTable (ID, Item) select * from  OW.StringToTable(@IDList,',')
	insert into @TypeTable (ID, Item) select * from  OW.StringToTable(@TypeList,',')

		
	-- Delete Users that lose access

	DELETE FROM OW.tblProcessUserAccesses
	WHERE ProcessID=@ProcessID
	AND NOT EXISTS (SELECT 1 FROM @TypeTable A INNER JOIN @IDTable B
					ON (A.ID=B.ID)
					WHERE A.Item='U' AND OW.tblProcessUserAccesses.UserID=B.Item)
	
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error


	-- Insert Users that win access

	INSERT INTO OW.tblProcessUserAccesses (ProcessID, UserID)
	SELECT @ProcessID, B.Item
	FROM @TypeTable A INNER JOIN @IDTable B
		ON (A.ID=B.ID)
	WHERE A.Item='U'
	AND NOT EXISTS (SELECT 1 FROM OW.tblProcessUserAccesses PRUA
					WHERE PRUA.ProcessID=@ProcessID AND PRUA.UserID=B.Item)

	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	

	-- Delete Groups that lose access

	DELETE FROM OW.tblProcessGroupAccesses
	WHERE ProcessID=@ProcessID
	AND NOT EXISTS (SELECT 1 FROM @TypeTable A INNER JOIN @IDTable B
					ON (A.ID=B.ID)
					WHERE A.Item='G' AND OW.tblProcessGroupAccesses.GroupID=B.Item)
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error


	-- Insert Groups that win access

	INSERT INTO OW.tblProcessGroupAccesses (ProcessID, GroupID)
	SELECT @ProcessID, B.Item
	FROM @TypeTable A INNER JOIN @IDTable B
		ON (A.ID=B.ID)
	WHERE A.Item='G'
	AND NOT EXISTS (SELECT 1 FROM OW.tblProcessGroupAccesses PRGA
					WHERE PRGA.ProcessID=@ProcessID AND PRGA.GroupID=B.Item)

	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error


	RETURN 0

GO




























-- Gets Users/Groups Name by ID
-- Used in Create AdHoc Process
CREATE PROCEDURE OW.usp_GetUsersAndGroupsByID

	(
	@IDList varchar (8000),  -- List of (UserId/GroupID) delimiter by comma
	@TypeList varchar (8000) -- List of Type (U/G) delimited by comma
	)

AS


	SELECT U.UserID ID, 'U' Type, U.UserDesc Name
	FROM OW.tblUser U 
	WHERE 
	EXISTS (SELECT 1 FROM OW.StringToTable(@TypeList,',') A 
			INNER JOIN OW.StringToTable(@IDList,',') B
			ON (A.ID=B.ID)
			WHERE A.Item='U' AND U.UserID=B.Item)

	UNION

	SELECT G.GroupID ID, 'G' Type, G.GroupDesc Name
	FROM OW.tblGroups G
	WHERE  
	EXISTS (SELECT 1 FROM OW.StringToTable(@TypeList,',') A 
			INNER JOIN OW.StringToTable(@IDList,',') B
			ON (A.ID=B.ID)
			WHERE A.Item='G' AND G.GroupID=B.Item)
			
	ORDER BY Name
	

	RETURN @@ERROR
	

GO












--*************************************************************
--     
-- Name: IsUserParticipantInProcess 
-- Description:
-- Verifies if a User participates in a Process.
-- 
--
-- Inputs:
-- UserID - User identifier
-- ProcessID - Process identifier
--
-- Returns:
-- 1 - (TRUE) if user participates in the process
-- 0 - (FALSE)if user do not participates in the process.
-- 
--*************************************************************

CREATE FUNCTION OW.IsUserParticipantInProcess
	(
	@UserID numeric(18), 
	@ProcessID numeric(18)
	)
RETURNS bit
AS

BEGIN

	DECLARE @NumberOfStages numeric(3)
	DECLARE @IsParticipant bit
	
	-- Get the number of stages where user participates
	SELECT @NumberOfStages=count(*) FROM OW.tblProcessStages PRST
	WHERE  
	PRST.ProcessID=@ProcessID 
	AND 
	PRST.ExecutantID=@UserID -- The user was or is executant 
	
	IF @NumberOfStages > 0
		SET @IsParticipant=1 -- TRUE
	ELSE
		SET @IsParticipant=0 -- FALSE

	RETURN @IsParticipant
END
GO




























/* ********************** ALERTS ********************************/


CREATE PROCEDURE OW.usp_SendAlerts

	(
	@ProcessAlarmID numeric(18)
	)

AS
	
	DECLARE @SendDate datetime
	
	SET @SendDate=getdate()
	
	INSERT INTO OW.tblAlerts (Message, UserID, ProcessID, SendDate)
	-- User Executant of current stage, if stage is attributed
	SELECT PRAL.Message, PRST.ExecutantID, PRAL.ProcessID, @SendDate
	FROM OW.tblProcessAlarms PRAL
		INNER JOIN OW.tblProcessStages PRST ON (PRAL.ProcessID=PRST.ProcessID)
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID 
	AND PRAL.AddresseeExecutant=1
	AND PRST.StartDate IS NOT NULL AND PRST.FinishDate IS NULL
	AND PRST.ExecutantID IS NOT NULL
	UNION
	-- Users that belongs to Executant Group of current stage, 
	-- if stage is not yet attributed to a user
	SELECT PRAL.Message, PRST.ExecutantID, PRAL.ProcessID, @SendDate
	FROM OW.tblProcessAlarms PRAL
		INNER JOIN OW.tblProcessStages PRST ON (PRAL.ProcessID=PRST.ProcessID)
		INNER JOIN OW.tblGroupsUsers GU ON (PRST.ExecutantTypeGroupID=GU.GroupID)
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID 
	AND PRAL.AddresseeExecutant=1
	AND PRST.StartDate IS NOT NULL AND PRST.FinishDate IS NULL
	AND PRST.ExecutantID IS NULL 
	UNION
	-- Users addressees
	SELECT PRAL.Message, PRAA.UserID, PRAL.ProcessID, @SendDate
	FROM OW.tblProcessAlarms PRAL
		INNER JOIN OW.tblProcessAlarmAddressees PRAA ON (PRAL.ProcessAlarmID=PRAA.ProcessAlarmID)
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID
	AND PRAA.AddresseeType='U'
	UNION
	-- Users that belongs to groups addressees
	SELECT PRAL.Message, GU.UserID, PRAL.ProcessID, @SendDate
	FROM OW.tblProcessAlarms PRAL
		INNER JOIN OW.tblProcessAlarmAddressees PRAA ON (PRAL.ProcessAlarmID=PRAA.ProcessAlarmID) 
		INNER JOIN OW.tblGroupsUsers GU ON (PRAA.GroupID=GU.GroupID)
	WHERE PRAL.ProcessAlarmID=@ProcessAlarmID
	AND PRAA.AddresseeType='G'
	
	RETURN @@ERROR

GO


























CREATE PROCEDURE OW.usp_GetUserAlerts

	(
	@UserID numeric(18),
	@PageNumber numeric(18) OUTPUT,
	@PageSize INT,
	@TotalRegs INT OUTPUT /* Return RowCount */
	)

AS
	DECLARE @QUERY VARCHAR(1000)

	SELECT @TotalRegs=COUNT(*)	
	FROM OW.tblAlerts ALT INNER JOIN OW.tblProcess PR
	ON (ALT.ProcessID=PR.ProcessID)
	WHERE ALT.UserID=@UserID

	/************************ Page Calculations ****************************/
	DECLARE  @GetNRegs numeric(18)
	DECLARE  @NPages numeric(18)

	SET @GetNRegs=0
	--Get Number of pages
	SET @NPages=@TotalRegs/@PageSize; 
	--Number of pages + 1 a uncomplete page if exists
	IF (@TotalRegs%@PageSize<>0) SET @NPages=@NPages+1
	--if the request page > lastpage then give the last page
	IF (@PageNumber>@NPages) SET @PageNumber=@NPages
	--if the request page < firstpage then give the first page
	IF (@PageNumber<1)SET @PageNumber=1
	--if the request page == lastpage and lastpage is a uncomplete page then get just the last regs 
	IF (@PageNumber=@NPages AND @TotalRegs%@PageSize<>0)
		SET @GetNRegs=(@TotalRegs%@PageSize)
	ELSE
		SET @GetNRegs=@PageSize
	/************************ ***************** ****************************/

	SET @QUERY = 'SELECT * FROM(SELECT TOP ' + CAST(@GetNRegs AS VARCHAR(20)) + ' * FROM (
	SELECT TOP ' +  CAST((@PageNumber * @PageSize) AS  VARCHAR(20)) + ' ALT.AlertID, ALT.Message, ALT.SendDate, ALT.ReadDate, 
	PR.Code, PR.Number, PR.Year, PR.Name
	FROM OW.tblAlerts ALT INNER JOIN OW.tblProcess PR
	ON (ALT.ProcessID=PR.ProcessID)
	WHERE ALT.UserID=' + CAST(@UserID AS VARCHAR(18)) + '
	ORDER BY ALT.AlertID DESC -- Is the same as order by SendDate DESC
	) AS TB1 ORDER BY AlertID ASC) AS TB2 ORDER BY AlertID DESC'			

	EXECUTE (@QUERY)
	RETURN @@ERROR
GO






























CREATE PROCEDURE OW.usp_GetAlert

	(
	@AlertID numeric(18)
	)

AS

	SELECT ALT.AlertID, ALT.Message, ALT.SendDate, ALT.ReadDate, 
	PR.ProcessID, PR.Code, PR.Number, PR.Year, PR.Name
	FROM OW.tblAlerts ALT INNER JOIN OW.tblProcess PR
	ON (ALT.ProcessID=PR.ProcessID)
	WHERE ALT.AlertID=@AlertID
			
	RETURN @@ERROR

GO























CREATE PROCEDURE OW.usp_MarkAlertAsReaded

	(
	@AlertID numeric(18)
	)

AS

	UPDATE OW.tblAlerts
	SET ReadDate=getdate()
	WHERE AlertID=@AlertID AND ReadDate IS NULL
			
	RETURN @@ERROR

GO


























CREATE PROCEDURE OW.usp_DeleteAlert

	(
	@AlertID numeric(18)
	)

AS

	DELETE FROM OW.tblAlerts
	WHERE AlertID=@AlertID
			
	RETURN @@ERROR

GO





















/* ************ COMPLEX PROCEDURES THAT REFERENCES OTHER SMALL PROCEDURES  ****************/
/* To avoid the message "Cannot add rows to sysdepends for the current stored procedure because it depends on the missing object 'OW.usp_ActivateProcessAlarms'. The stored procedure will still be created. */

CREATE PROCEDURE OW.usp_AnnulProcess

	(
	@ProcessID numeric (18), 
	@UserID numeric (18)
	)

AS
	DECLARE @Error int
	DECLARE @IsActiveOrSuspended bit
	
	-- Ter em atenção a concorrência, quando dois postos tentam
	-- anular o processo. Introduzir um lock! andre
	
	BEGIN TRANSACTION
	
	-- Check if process is active or suspended
	
	SET @IsActiveOrSuspended = 0
	
	SELECT @IsActiveOrSuspended = 1 FROM OW.tblProcess
	WHERE ProcessID=@ProcessID AND (State=1 OR State=2)
	
	IF @IsActiveOrSuspended = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2  -- Process is not active, neither suspended
	END
	
	
	-- Deactivate alarms of Current Stage
	DECLARE @ProcessStageID numeric(18)
	
	SELECT @ProcessStageID=ProcessStageID FROM OW.tblProcessStages
	WHERE StartDate IS NOT NULL AND FinishDate IS NULL
	
	EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, NULL, @ProcessStageID
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Deactivate alarms of Process
	EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, @ProcessID, NULL
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
			
	-- Annul the process
	UPDATE OW.tblProcess
	SET State=3
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Registar o log. andre

	COMMIT TRANSACTION
	RETURN 0

GO













-- Check if the stage is the current stage and the process is active

CREATE FUNCTION OW.CanDispatchStage
	(
	@ProcessStageID numeric (18)
	)
RETURNS bit
AS

BEGIN

	DECLARE @CanDispatch bit
	
	SET @CanDispatch=0
	
	SELECT @CanDispatch = 1 FROM OW.tblProcessStages PRST
	WHERE PRST.ProcessStageID=@ProcessStageID
	AND PRST.StartDate IS NOT NULL AND PRST.FinishDate IS NULL
	AND EXISTS (SELECT 1 FROM OW.tblProcess PR
				WHERE PRST.ProcessID=PR.ProcessID
				AND PR.State=1)

	RETURN @CanDispatch
END
GO























	
-- Check if :
-- the stage is the current stage 
-- and the process is active or suspended,
-- and the stage is not yet accepted by other user 
-- and the user belongs to the executant group.

CREATE FUNCTION OW.CanAcceptStage
	(
	@ProcessStageID numeric (18),
	@UserID numeric(18)
	)
RETURNS bit
AS

BEGIN

	DECLARE @CanAccept bit
	
	SET @CanAccept=0
	
	SELECT @CanAccept = 1 FROM OW.tblProcessStages PRST
	WHERE PRST.ProcessStageID=@ProcessStageID
	AND PRST.StartDate IS NOT NULL AND PRST.FinishDate IS NULL
	AND PRST.ExecutantID IS NULL
	AND EXISTS (SELECT 1 FROM OW.tblProcess PR
				WHERE PRST.ProcessID=PR.ProcessID
				AND (PR.State=1 OR PR.State=2))
	AND EXISTS (SELECT 1 FROM OW.tblGroupsUsers GU
				WHERE GU.GroupID=PRST.ExecutantTypeGroupID
				AND GU.UserID=@UserID)

	RETURN @CanAccept
END
GO



























CREATE PROCEDURE OW.usp_TerminateProcess

	(
	@ProcessStageID numeric (18)
	)

AS
	DECLARE @Error int
	DECLARE @TerminateDate datetime
	DECLARE @ProcessID numeric(18)
	
	-- Ter em atenção a concorrência, quando dois postos tentam
	-- terminar o processo. Introduzir um lock! andre
	
	BEGIN TRANSACTION
	
	-- Check if process is active and the stage is yet current
	DECLARE @CanDispatch bit
	
	SET @CanDispatch=OW.CanDispatchStage(@ProcessStageID)
	
	IF @CanDispatch = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2  -- Process is not active or the the stage is not the current
	END
	
	
	-- Save FinishDate on the current stage.
	
	SET @TerminateDate=getdate()

	UPDATE OW.tblProcessStages
	SET FinishDate=@TerminateDate
	WHERE ProcessStageID=@ProcessStageID

	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Deactivate alarms of Current Stage

	EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, NULL, @ProcessStageID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

		
	-- Get ProcessID
	
	SELECT @ProcessID=ProcessID
	FROM OW.tblProcessStages
	WHERE ProcessStageID=@ProcessStageID
	
	-- Deactivate alarms of Process
	
	EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, @ProcessID, NULL
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Update WorkCompleted
	
	EXECUTE @Error=OW.usp_SetProcessWorkCompleted @ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Terminate the process
	
	UPDATE OW.tblProcess
	SET FinishDate=@TerminateDate, State=4
	WHERE ProcessID=@ProcessID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	

	COMMIT TRANSACTION
	RETURN 0

GO



























CREATE PROCEDURE OW.usp_TransitProcessStage

	(
	@ProcessStageID numeric (18),
	@TransitionDate datetime=NULL -- Only for Delegation
	)

AS
	DECLARE @Error int
	DECLARE @ProcessID numeric(18)
	DECLARE @StageNumber numeric(3)
	
	-- Ter em atenção a concorrência, quando dois postos tentam
	-- transitar a mesma etapa. Introduzir um lock!
	-- andre
	
	-- Check if process is active and the stage is yet current
	DECLARE @CanDispatch bit
	
	SET @CanDispatch=OW.CanDispatchStage(@ProcessStageID)
	
	IF @CanDispatch = 0 RETURN -2  -- Process is not active or the the stage is not the current
	
	
	
	IF @TransitionDate IS NULL
		SET @TransitionDate=getdate()
	
	-- Save FinishDate on the current stage.
	UPDATE OW.tblProcessStages
	SET FinishDate=@TransitionDate
	WHERE ProcessStageID=@ProcessStageID

	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error
	
	
	-- Get current stage number to know the next stage number
	SELECT @ProcessID=ProcessID, @StageNumber=Number 
	FROM OW.tblProcessStages
	WHERE ProcessStageID=@ProcessStageID


	-- Set next stage as current stage
	-- (fill ExecutantID, StartDate, LimitDate)
	DECLARE @WorkCalendar numeric(1)
	DECLARE @RowCount int
	
	SELECT @WorkCalendar=WorkCalendar FROM OW.tblProcess WHERE ProcessID=@ProcessID
		
	UPDATE OW.tblProcessStages
	SET ExecutantID=ExecutantTypeUserID, StartDate=@TransitionDate,
	LimitDate=OW.fnGetFinalDate(case @WorkCalendar when 1 then 1 when 2 then 0 end, @TransitionDate, DurationDays, DurationHours)
	WHERE ProcessID=@ProcessID AND Number=@StageNumber+1
	
	SET @RowCount = @@ROWCOUNT
	
	SET @Error = @@ERROR
	IF @Error <> 0 RETURN @Error



	IF @RowCount = 0  -- If next stage not exists
	BEGIN
		
		-- Deactivate alarms of Previous Stage
		EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, NULL, @ProcessStageID
		IF @Error<>0 RETURN @Error
		
		-- Deactivate alarms of Process
		EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, @ProcessID, NULL
		IF @Error<>0 RETURN @Error
		
		-- Terminate the process
		UPDATE OW.tblProcess
		SET FinishDate=@TransitionDate, State=4
		WHERE ProcessID=@ProcessID
		
		SET @Error = @@ERROR
		IF @Error <> 0 RETURN @Error
	END
	ELSE
	BEGIN
	
		-- Deactivate alarms of Previous Stage
		EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, NULL, @ProcessStageID
		IF @Error<>0 RETURN @Error
				
		-- Activate Alarms of Next Stage
		DECLARE @NextProcessStageID numeric(18)
		SELECT @NextProcessStageID=ProcessStageID FROM OW.tblProcessStages	WHERE ProcessID=@ProcessID and Number=@StageNumber+1
		EXECUTE @Error=OW.usp_ActivateProcessAlarms NULL, NULL, @NextProcessStageID
		IF @Error <> 0 RETURN @Error
		
	END
	
	-- Update WorkCompleted
	EXECUTE @Error=OW.usp_SetProcessWorkCompleted @ProcessID
	IF @Error <> 0 RETURN @Error
	
	RETURN 0

GO





























CREATE PROCEDURE OW.usp_CreateProcess

	(
	@FlowID numeric(18), 
	@ProcessName varchar(50),
	@UserID numeric(18),
	@Notes text = NULL,
	@FileIDList varchar(8000) = NULL,
	@Transit bit = 0,
	@ProcessID numeric(18) OUTPUT /* Return new ProcessID */
	)

AS
	DECLARE @Error int
	DECLARE @TmpStages TABLE (FlowID numeric(18), FlowStageID numeric(18), StageNumber numeric(3), ProcessID numeric(18), ProcessStageID numeric(18) )
	DECLARE @StartDate datetime
	DECLARE @Year numeric(4)
	DECLARE @Number numeric(9)
	DECLARE @FirstProcessStageID numeric(18)
	
	
	BEGIN TRANSACTION

	-- Falta garantir que esta operação não é executada em paralelo
	-- com outras que alterem as verificações iniciais! andre
	
	-- Check if the flow still under production,
	-- the user belongs to first stage group or is first stage executant.	
	DECLARE @CanCreateProcess bit
	
	SET @CanCreateProcess = 0
	
	SELECT @CanCreateProcess = 1 FROM OW.tblFlow FL
	WHERE FlowID=@FlowID AND State='P'
	AND EXISTS (SELECT 1 FROM OW.tblFlowStages FLST
			WHERE FL.FlowID=FLST.FlowID
			AND FLST.Number=1
			AND 
			(
			(FLST.ExecutantType='U' AND FLST.ExecutantTypeUserID=@UserID)
			OR
			(FLST.ExecutantType='G' AND EXISTS (SELECT 1 FROM OW.tblGroupsUsers GU
								WHERE FLST.ExecutantTypeGroupID=GU.GroupID
								AND GU.UserID=@UserID))
			)
	)
	
	IF @CanCreateProcess = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2 -- The user can not yet create a process based in this flow !
	END	
	
	
	SET @StartDate=getdate()
	SET @Year=year(@StartDate)
	
	-- Get Process Number
	SET @Number=OW.GetNewProcessNumber((select Code from OW.tblFlow where FlowID=@FlowID),@Year)
	
		
	-- Copy Flow
	INSERT INTO OW.tblProcess (Code, Number, Year, Name, State, DurationDays, DurationHours, WorkCalendar, StartDate, LimitDate,  WorkCompleted, OriginatorAccess)
	SELECT Code, @Number, @Year, ltrim(rtrim(@ProcessName)), 1, DurationDays, DurationHours, WorkCalendar, @StartDate, OW.fnGetFinalDate(case WorkCalendar when 1 then 1 when 2 then 0 end, @StartDate, DurationDays, DurationHours), 0, OriginatorAccess
	FROM OW.tblFlow
	WHERE FlowID=@FlowID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	SET @ProcessID=@@IDENTITY
	
	
	-- Copy FlowStages 
	
	INSERT INTO OW.tblProcessStages (ProcessID, Number, Name, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID, DurationDays, DurationHours)
	SELECT @ProcessID, Number, Name, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID, DurationDays, DurationHours
	FROM OW.tblFlowStages
	WHERE FlowID=@FlowID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- For the First Stage:

	DECLARE @WorkCalendar numeric(1)
	
	SELECT @WorkCalendar=WorkCalendar FROM OW.tblProcess WHERE ProcessID=@ProcessID
	
	SELECT @FirstProcessStageID=ProcessStageID FROM OW.tblProcessStages WHERE ProcessID=@ProcessID and Number=1
	
	-- -- Start Stage, attribute Stage to User and save Notes
	
	UPDATE OW.tblProcessStages 
	SET ExecutantID=@UserID, 
	StartDate=@StartDate, ReadDate=@StartDate, LimitDate=OW.fnGetFinalDate(case @WorkCalendar when 1 then 1 when 2 then 0 end, @StartDate, DurationDays, DurationHours),
	Notes=@Notes
	WHERE ProcessStageID=@FirstProcessStageID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- -- Insert First Stage Documents
	
	IF (@FileIDList IS NOT NULL AND @FileIDList <> '')
	BEGIN
		
		INSERT INTO OW.tblProcessDocuments (ProcessID, FileID, ProcessStageID, AssociationDate, AssociationUserID)
		SELECT @ProcessID, F.Item, @FirstProcessStageID, @StartDate, @UserID
		FROM OW.StringToTable(@FileIDList,',') F 
		
		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END
	
	
	
	-- Copy FlowAlarms 
	
	-- For each FlowAlarm:
	-- -- Insert ProcessAlarm and Get ProcessAlarmID
	-- -- Insert ProcessAlarmAddressees	
	
	-- Create a temporary table with FlowStage and ProcessStage IDs relation.
	insert into @TmpStages (FlowID , FlowStageID , StageNumber , ProcessID , ProcessStageID  )
	select FlowID, FlowStageID, FLST.Number, ProcessID, ProcessStageID
	from OW.tblFlowStages FLST INNER JOIN OW.tblProcessStages PRST
	on ( FLST.FlowID=@FlowID and PRST.ProcessID=@ProcessID and FLST.Number=PRST.Number )
	
	
	DECLARE @FlowAlarmID numeric (18), 
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@FlowStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric(1), 
	@AddresseeExecutant numeric (1),
	@ProcessStageID numeric (18),
	@ProcessAlarmID numeric(18)
	
	DECLARE Cursor_FlowAlarms CURSOR FOR
	SELECT FlowAlarmID, Occurence , OccurenceOffsetDays, OccurenceOffsetHours  , FlowStageID , Message , AlertByEMail , AddresseeExecutant
	FROM OW.tblFlowAlarms
	WHERE FlowID=@FlowID
	
	OPEN Cursor_FlowAlarms
	
	-- Get the first FlowAlarm
	FETCH NEXT FROM Cursor_FlowAlarms
	INTO @FlowAlarmID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours  , @FlowStageID , @Message , @AlertByEMail , @AddresseeExecutant
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- -- Get ProcessStageID
		IF @FlowStageID IS NOT NULL
			select @ProcessStageID=ProcessStageID from @TmpStages where FlowStageID=@FlowStageID
		ELSE
			SET @ProcessStageID = NULL
		
		-- -- Insert ProcessAlarm and get ProcessAlarmID
		INSERT INTO OW.tblProcessAlarms (ProcessID , Occurence , OccurenceOffsetDays, OccurenceOffsetHours  , ProcessStageID , Message , AlertByEMail , AddresseeExecutant )
		VALUES(@ProcessID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours  , @ProcessStageID , @Message , @AlertByEMail , @AddresseeExecutant) 
		
		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
		
		SET @ProcessAlarmID=@@IDENTITY
		
		-- -- Insert ProcessAlarmAddressees
		
		INSERT INTO OW.tblProcessAlarmAddressees (ProcessAlarmID , AddresseeType , UserID , GroupID )
		SELECT @ProcessAlarmID, AddresseeType , UserID , GroupID
		FROM OW.tblFlowAlarmAddressees FLAA
		WHERE FLAA.FlowAlarmID=@FlowAlarmID
	
		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
		
		-- Get next FlowAlarm
		FETCH NEXT FROM Cursor_FlowAlarms
		INTO @FlowAlarmID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours  , @FlowStageID , @Message , @AlertByEMail , @AddresseeExecutant
	END
	
	CLOSE Cursor_FlowAlarms
	DEALLOCATE Cursor_FlowAlarms

	
	-- Activate Process Alarms
	EXECUTE @Error=OW.usp_ActivateProcessAlarms NULL, @ProcessID, NULL
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Activate First ProcessStage Alarms
	EXECUTE @Error=OW.usp_ActivateProcessAlarms NULL, NULL, @FirstProcessStageID
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	-- Copy FlowUserAccesses	
	
	INSERT INTO OW.tblProcessUserAccesses (ProcessID, UserID)
	SELECT @ProcessID, UserID
	FROM OW.tblFlowUserAccesses
	WHERE FlowID=@FlowID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Copy FlowGroupAccesses
	
	INSERT INTO OW.tblProcessGroupAccesses (ProcessID, GroupID)
	SELECT @ProcessID, GroupID
	FROM OW.tblFlowGroupAccesses
	WHERE FlowID=@FlowID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	IF @Transit = 1 
	BEGIN
		-- Transit First Process Stage
		EXECUTE @Error = OW.usp_TransitProcessStage @FirstProcessStageID
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
	END
		
	COMMIT TRANSACTION
	RETURN 0

GO
















CREATE PROCEDURE OW.usp_SetProcessDuration

	(
	@ProcessID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @DurationDays numeric(6)
	DECLARE @DurationHours numeric(8,2)
	DECLARE @WorkCalendar numeric(1)
	DECLARE @StartDate datetime
	
	-- Deve-se garantir que quando está a ser recalculado o prazo,
	-- não estão a ser adicionadas etapas através de concorrência ! andre
	
	-- Calculate new Process Duration ( sum returns NULL if exists a stage with a NULL duration )
	SELECT @DurationDays=sum(DurationDays), @DurationHours=sum(DurationHours)
	FROM OW.tblProcessStages WHERE ProcessID=@ProcessID
	AND NOT EXISTS (SELECT 1 FROM OW.tblProcessStages 
					WHERE ProcessID=@ProcessID
					AND DurationDays IS NULL AND DurationHours IS NULL)
	
	-- Update Process Duration and LimitDate
	SELECT @WorkCalendar=WorkCalendar, @StartDate=StartDate FROM OW.tblProcess
	WHERE ProcessID=@ProcessID
	
	UPDATE OW.tblProcess
	SET DurationDays=@DurationDays,	DurationHours=@DurationHours,
	LimitDate=OW.fnGetFinalDate(case @WorkCalendar when 1 then 1 when 2 then 0 end, @StartDate, @DurationDays, @DurationHours)
	WHERE ProcessID=@ProcessID

	SET @Error = @@ERROR
	IF @Error <> 0	RETURN @Error

	-- Update Process alarms that already exists
	
	-- Deactivate existing process alarms
	EXECUTE @Error=OW.usp_DeactivateProcessAlarm NULL, @ProcessID, NULL
	SET @Error = @@ERROR
	IF @Error <> 0	RETURN @Error
				
	-- Re-Activate existing process alarms
	EXECUTE @Error=OW.usp_ActivateProcessAlarms NULL, @ProcessID, NULL
	SET @Error = @@ERROR
	IF @Error <> 0	RETURN @Error

	RETURN 0
GO































CREATE PROCEDURE OW.usp_AddFlowToProcess

	(
	@ProcessID numeric(18),
	@LastProcessStageID numeric(18),
	@FlowID numeric(18)
	)

AS
	DECLARE @Error int
	DECLARE @TmpStages TABLE (FlowID numeric(18), FlowStageID numeric(18), StageNumber numeric(3), ProcessID numeric(18), ProcessStageID numeric(18) )
	DECLARE @NumberOffset numeric(3)
	DECLARE @LastProcessStageID_DB numeric(18)
	
	
	BEGIN TRANSACTION

	-- Falta garantir que esta operação não é executada em paralelo
	-- com outras que alterem as verificações iniciais! andre
	
	-- Check if the flow still under production	
	DECLARE @UnderProduction bit
	SET @UnderProduction = 0
	
	SELECT @UnderProduction = 1 FROM OW.tblFlow
	WHERE FlowID=@FlowID AND State='P'
	
	IF @UnderProduction = 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2 -- The flow in not in production
	END


	--Get Last Stage number (offset)
	SELECT @NumberOffset=MAX(Number) FROM OW.tblProcessStages PRST WHERE PRST.ProcessID=@ProcessID

	--Get Last Stage ID
	SELECT @LastProcessStageID_DB=PRST.ProcessStageID FROM OW.tblProcessStages PRST 
		WHERE PRST.ProcessID=@ProcessID AND PRST.Number=@NumberOffset

	-- Check if it is realy the last stage
	IF (@LastProcessStageID	<> @LastProcessStageID_DB)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2 -- The stage is no longer the last stage
	END
	
	-- Copy FlowStages 
	
	INSERT INTO OW.tblProcessStages (ProcessID, Number, Name, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID, DurationDays, DurationHours)
	SELECT @ProcessID, Number+@NumberOffset, Name, ExecutantType, ExecutantTypeUserID, ExecutantTypeGroupID, DurationDays, DurationHours
	FROM OW.tblFlowStages
	WHERE FlowID=@FlowID
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Recalculate Process Duration and LimitDate
	
	EXECUTE @Error=OW.usp_SetProcessDuration @ProcessID
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Copy FlowAlarms 
	
	-- For each FlowAlarm:
	-- -- Insert ProcessAlarm and Get ProcessAlarmID
	-- -- Insert ProcessAlarmAddressees	
	
	-- Create a temporary table with FlowStage and ProcessStage IDs relation.
	insert into @TmpStages (FlowID , FlowStageID , StageNumber , ProcessID , ProcessStageID  )
	select FlowID, FlowStageID, FLST.Number+@NumberOffset, ProcessID, ProcessStageID
	from OW.tblFlowStages FLST INNER JOIN OW.tblProcessStages PRST
	on ( FLST.FlowID=@FlowID and PRST.ProcessID=@ProcessID and (FLST.Number+@NumberOffset)=PRST.Number )
	
	
	DECLARE @FlowAlarmID numeric (18), 
	@Occurence numeric (2),
	@OccurenceOffsetDays numeric (4),
	@OccurenceOffsetHours numeric (6,2),
	@FlowStageID numeric (18),
	@Message varchar (100),
	@AlertByEMail numeric(1), 
	@AddresseeExecutant numeric (1),
	@ProcessStageID numeric (18),
	@ProcessAlarmID numeric(18)
	
	DECLARE Cursor_FlowAlarms CURSOR FOR
	SELECT FlowAlarmID, Occurence , OccurenceOffsetDays, OccurenceOffsetHours  , FlowStageID , Message , AlertByEMail , AddresseeExecutant
	FROM OW.tblFlowAlarms
	WHERE FlowID=@FlowID
	
	OPEN Cursor_FlowAlarms
	
	-- Get the first FlowAlarm
	FETCH NEXT FROM Cursor_FlowAlarms
	INTO @FlowAlarmID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours  , @FlowStageID , @Message , @AlertByEMail , @AddresseeExecutant
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- -- Get ProcessStageID
		IF @FlowStageID IS NOT NULL
			select @ProcessStageID=ProcessStageID from @TmpStages where FlowStageID=@FlowStageID
		ELSE
			SET @ProcessStageID = NULL
		
		-- -- Insert ProcessAlarm and get ProcessAlarmID
		INSERT INTO OW.tblProcessAlarms (ProcessID , Occurence , OccurenceOffsetDays, OccurenceOffsetHours  , ProcessStageID , Message , AlertByEMail , AddresseeExecutant )
		VALUES(@ProcessID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours  , @ProcessStageID , @Message , @AlertByEMail , @AddresseeExecutant) 
		
		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
		
		SET @ProcessAlarmID=@@IDENTITY
		
		-- -- Insert ProcessAlarmAddressees
		
		INSERT INTO OW.tblProcessAlarmAddressees (ProcessAlarmID , AddresseeType , UserID , GroupID )
		SELECT @ProcessAlarmID, AddresseeType , UserID , GroupID
		FROM OW.tblFlowAlarmAddressees FLAA
		WHERE FLAA.FlowAlarmID=@FlowAlarmID
	
		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END
		
		-- Activate Process Alarms
		EXECUTE @Error=OW.usp_ActivateProcessAlarms @ProcessAlarmID, NULL, NULL
		IF @Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN @Error
		END

		-- Get next FlowAlarm
		FETCH NEXT FROM Cursor_FlowAlarms
		INTO @FlowAlarmID, @Occurence , @OccurenceOffsetDays, @OccurenceOffsetHours  , @FlowStageID , @Message , @AlertByEMail , @AddresseeExecutant
	END
	
	CLOSE Cursor_FlowAlarms
	DEALLOCATE Cursor_FlowAlarms

	

	
	-- Copy FlowUserAccesses	
	
	INSERT INTO OW.tblProcessUserAccesses (ProcessID, UserID)
	SELECT @ProcessID, UserID
	FROM OW.tblFlowUserAccesses FUA
	WHERE FUA.FlowID=@FlowID
	AND NOT EXISTS(SELECT UserID FROM OW.tblProcessUserAccesses FUA1
				WHERE ProcessID=@ProcessID AND FUA1.UserID=FUA.UserID)
	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	-- Copy FlowGroupAccesses
	
	INSERT INTO OW.tblProcessGroupAccesses (ProcessID, GroupID)
	SELECT @ProcessID, GroupID
	FROM OW.tblFlowGroupAccesses PGA
	WHERE PGA.FlowID=@FlowID
	AND NOT EXISTS(SELECT GroupID FROM OW.tblProcessGroupAccesses PGA1
				WHERE ProcessID=@ProcessID AND PGA1.GroupID=PGA.GroupID)

	
	SET @Error = @@ERROR
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
	
	
	--Transit Process Stage
	exec @Error = OW.usp_TransitProcessStage @LastProcessStageID_DB
	IF @Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END

		
	COMMIT TRANSACTION
	RETURN 0
GO
























CREATE PROCEDURE OW.usp_DelegateProcessStage

	(
	@ProcessStageID numeric(18),
	@ToUserID numeric(18),
	@Validation bit
	)

AS
	DECLARE @Error int
	DECLARE @WorkCalendar numeric(1)
	DECLARE @ProcessID numeric(18),
	@Number numeric(3),
	@Name varchar(50),
	@FromUserID numeric(18),
	@DurationDays numeric(3),
	@DurationHours numeric(5,2),
	@Startdate datetime,
	@LimitDate datetime
	DECLARE @DelegationDate datetime
	DECLARE @IsNormal bit
	DECLARE @NewNumber numeric(3),
	@NewDurationDays numeric(3),
	@NewDurationHours numeric(5,2),
	@NewProcessStageID numeric(18)
	DECLARE @OldDurationDays numeric(3),
	@OldDurationHours numeric(5,2)
	
	-- Ter em atenção a concorrência com outras operações em paralelo.
	-- Introduzir um lock! andre
	
	-- Get stage data
	SELECT @ProcessID=ProcessID, @Number=Number, @Name=Name, @FromUserID=ExecutantID,
	@DurationDays=DurationDays, @DurationHours=DurationHours, @Startdate=StartDate, @LimitDate=LimitDate 
	FROM OW.tblProcessStages
	WHERE ProcessStageID=@ProcessStageID
	
	SELECT @WorkCalendar=WorkCalendar
	FROM OW.tblProcess
	WHERE ProcessID=@ProcessID
	
	-- Get "space" after stage to add new stages, pushing next stages forward.
	-- Add 1 stage if without validation, and 2 stages if with validation.
	UPDATE OW.tblProcessStages
	SET Number=Number+case @Validation when 0 then 1 when 1 then 2 end
	WHERE ProcessID=@ProcessID and Number>@Number
	

	-- Add new stage(s)
	SET @DelegationDate=getdate()
	
	-- -- Get new stage duration
	IF @LimitDate IS NOT NULL
	BEGIN
		IF @DelegationDate < @LimitDate
		BEGIN
			-- Get the remain time
			
			IF @WorkCalendar = 2 -- Defined Calendar
				SET @IsNormal=0 -- Useful time
			ELSE
				SET @IsNormal=1 -- Normal time
			
			-- Old stage duration
			EXECUTE @Error = OW.usp_GetDuration @IsNormal, @Startdate, @DelegationDate, @OldDurationDays OUTPUT, @OldDurationHours OUTPUT
			IF @Error <> 0 RETURN @Error
			
			-- New stage duration
			EXECUTE @Error = OW.usp_GetDuration @IsNormal, @DelegationDate, @LimitDate, @NewDurationDays OUTPUT, @NewDurationHours OUTPUT
			IF @Error <> 0 RETURN @Error
		END
		ELSE
		BEGIN
			-- No time remain if delegation was made after @LimitDate
			SET @NewDurationDays = 0
			SET @NewDurationHours = 0
			SET @OldDurationDays = NULL
			SET @OldDurationHours = NULL
		END
	END
	ELSE
	BEGIN
		SET @NewDurationDays = NULL
		SET @NewDurationHours = NULL
		SET @OldDurationDays = NULL
		SET @OldDurationHours = NULL
	END
	
	-- -- Update Old Stage duration
	IF @OldDurationDays IS NOT NULL
	BEGIN
		UPDATE OW.tblProcessStages
		SET	DurationDays=@OldDurationDays, DurationHours=@OldDurationHours, LimitDate=@DelegationDate 
		WHERE ProcessStageID=@ProcessStageID
		
		SET @Error = @@ERROR
		IF @Error <> 0 RETURN @Error
	END	
	
	-- -- Insert new stage
	SET @NewNumber = @Number+1
	EXECUTE @Error = OW.usp_NewProcessStage @ProcessID, @NewNumber, @Name,
										'U', @ToUserID, NULL,
										@NewDurationDays, @NewDurationHours, @NewProcessStageID OUTPUT 
	
	IF @Error <> 0 RETURN @Error
	
	-- -- Insert the second stage for delegator's validation
	IF @Validation = 1
	BEGIN
		SET @NewNumber = @Number+2
		EXECUTE @Error = OW.usp_NewProcessStage @ProcessID, @NewNumber, @Name,
										'U', @FromUserID, NULL,
										0, 0, @NewProcessStageID OUTPUT 
		IF @Error <> 0 RETURN @Error
	END
	
	-- Transit process to next stage
	EXECUTE @Error = OW.usp_TransitProcessStage @ProcessStageID, @DelegationDate
	
	IF @Error <> 0 RETURN @Error
	
	RETURN 0

GO






























/* ********************** GENERIC ACCESSES  ********************************/

CREATE PROCEDURE OW.usp_GetUsersAndGroupsByProduct
	(
		@Product numeric(18,0), 
		@Type char
	)
AS

	IF (UPPER(@Type)='A')--ALL Users and Groups
	BEGIN
		SELECT a.userID ID, u.userLogin LOGIN, u.userDesc name, 'U' Type
		FROM OW.tblaccess a INNER JOIN OW.tbluser u ON(u.userID=a.UserID)
		WHERE 
		(
			a.ObjectParentID=@Product-- Get only the request product 
			OR
			a.ObjectParentID>(CASE @Product WHEN 0 THEN @Product ELSE 1000 END)--Get all if @Product=0
		)
		AND a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
		UNION
		SELECT g.GroupID ID, '' LOGIN, g.GroupDesc name, 'G' Type
		FROM OW.tblgroups g
		ORDER BY type desc,name
		RETURN @@ERROR
	END


	IF (UPPER(@Type)='U')--Users
	BEGIN
		SELECT DISTINCT a.userID ID, u.userLogin LOGIN, u.userDesc name, 'U' Type
		FROM OW.tblaccess a INNER JOIN OW.tbluser u ON(u.userID=a.UserID)
		WHERE 
		(
			a.ObjectParentID=@Product-- Get only the request product 
			OR
			a.ObjectParentID>(CASE @Product WHEN 0 THEN @Product ELSE 1000 END)--Get all if @Product=0
		)
		AND a.ObjectTypeID = 1 -- GENERIC_VALUES.TYPE_PRODUCT 
		ORDER BY type desc,name
		RETURN @@ERROR
	END

	IF (UPPER(@Type)='G')--Groups
	BEGIN		
		SELECT g.GroupID ID, '' LOGIN, g.GroupDesc name, 'G' Type
		FROM OW.tblgroups g
		ORDER BY type desc,name
		RETURN @@ERROR
	END
	
	RETURN @@ERROR
GO
























CREATE FUNCTION OW.UserBelongsToGroup
	(
	@UserID numeric(18), 
	@GroupID numeric(18)
	)
RETURNS bit
AS

BEGIN

	DECLARE @Belongs bit
	
	SET @Belongs=0
	
	SELECT @Belongs = 1 FROM OW.tblGroupsUsers GU
	WHERE GU.GroupID=@GroupID
	AND GU.UserID=@UserID

	RETURN @Belongs
END
GO









-- Checks if User have access to Read a Process Document.
-- @FileAccess returns zero if User do not have access to document 
-- or if the document do not exists.
-- @FileAccess returns @FileID if User have access to document.

CREATE PROCEDURE OW.usp_GetProcessFileAccess

	(
	@FileID numeric(18),
	@UserID numeric(18),
	@FileAccess numeric(18)	OUTPUT
	)

AS

	SET @FileAccess = 0

	/* Verificar se o utilizador é Gestor do workflow */
	SELECT @FileAccess=1 FROM OW.tblAccess
	WHERE UserID=@UserID
	AND ObjectTypeID=1
	AND ObjectParentID=6 /* Workflow*/
	AND ObjectID=7 /* Gestor */
	
	IF @FileAccess=1
	BEGIN
		SET @FileAccess=@FileID
		RETURN 0
	END


	/* Se o utilizador não é gestor então verificar se tem acesso à etapa */
	SELECT @FileAccess=1
	FROM OW.tblProcessDocuments PRDOC
	INNER JOIN OW.tblProcess PR ON (PRDOC.ProcessID=PR.ProcessID)
	WHERE PRDOC.FileID=@FileID
	/* Se originador não tiver acesso
		então o utilizador não pode ser originador, isto é,
		O Originador tem acesso ou então o utilizador não é o Originador */
	AND
	(
	PR.OriginatorAccess=1 
	or
	exists (select 1 from OW.tblProcessStages PRST
				where PR.ProcessID=PRST.ProcessID
				and PRST.Number=1 and PRST.ExecutantID<>@UserID
			)
	)
	AND
	(   /* O utilizador foi ou é executante */
		exists(select 1 from OW.tblProcessStages PRST
			where PR.ProcessID=PRST.ProcessID
			and PRST.ExecutantID=@UserID
			)
		or
		/* O utilizador tem acesso de Consulta */
		exists ( select 1 from OW.tblProcessUserAccesses PRUA
				where PR.ProcessID=PRUA.ProcessID
				and PRUA.UserID=@UserID
			)
		or
		/* O utilizador pertencente a um grupo com acesso de Consulta */
		exists ( select 1 from OW.tblProcessGroupAccesses PRGA,
							OW.tblGroupsUsers GU
				where PR.ProcessID=PRGA.ProcessID
				and PRGA.GroupID=GU.GroupID
				and GU.UserID=@UserID
			)
	)


	IF @FileAccess=1
		SET @FileAccess=@FileID
		
	RETURN @@ERROR

GO

/*******************************************************************************************/
/*                              END OF OWFLow SPs                                          */
/*******************************************************************************************/
use master


if not exists (select * from dbo.sysusers where name = N'OW' and uid < 16382)
BEGIN
	exec sp_grantdbaccess N'OW', N'OW'

END
	grant exec on xp_varbintohexstr to OW
GO
GO
SET NOCOUNT OFF
GO