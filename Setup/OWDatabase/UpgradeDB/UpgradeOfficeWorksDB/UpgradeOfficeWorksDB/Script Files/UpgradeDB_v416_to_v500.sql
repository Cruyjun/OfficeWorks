
-- Upgrade OfficeWorks database
-- #DATABASENAME# Database name for runtime text replacement

USE #DATABASENAME#
GO

if exists (select * from dbo.sysobjects where name ='zUpgrade_416_to_500' and xtype='U')
	return

CREATE TABLE [OW].[zUpgrade_416_to_500] (
	[ID] [int] NOT NULL ,
	[Field01] [varchar] (20) NOT NULL
) ON [PRIMARY]
GO

