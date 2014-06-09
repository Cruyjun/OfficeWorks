USE master
GO
CREATE DATABASE OfficeWorks
ON 
( NAME = 'OfficeWorks_Data',
   FILENAME = 'C:\OfficeWorks\OfficeWorks_Data.mdf',
   SIZE = 10MB,
   MAXSIZE = UNLIMITED, 
   FILEGROWTH = 10% )
LOG ON
( NAME = 'OfficeWorks_Log',
   FILENAME = 'C:\OfficeWorks\OfficeWorks_Log.ldf',
   SIZE = 5MB,
   MAXSIZE = UNLIMITED,
   FILEGROWTH = 10% )
COLLATE Latin1_General_CI_AS
--COLLATE SQL_Latin1_General_CP1_CI_AS
GO

