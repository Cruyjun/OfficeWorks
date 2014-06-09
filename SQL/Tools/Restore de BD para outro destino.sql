-- Return logical and physical file names of backup


RESTORE FILELISTONLY 
   FROM DISK = 'C:\OfficeWorks\Databases\eProcess_BNA_PROD_backup_20060224.bak'

-- eProcessData	F:\MSSQL\Data\eProcessData_BNA.MDF	D	PRIMARY	104857600	35184372080640
-- eProcessLog	F:\MSSQL\Data\eProcessLog_BNA.LDF	L	NULL	5242880	35184372080640

RESTORE FILELISTONLY 
   FROM DISK = 'C:\OfficeWorks\Databases\ow27022006.bak'

-- OW_Data	f:\MSSQL\data\OW_Data.MDF	D	PRIMARY	104857600	35184372080640
-- OW_Log	f:\MSSQL\data\OW_Log.LDF	L	NULL	161349632	35184372080640


-- Restore eProcess backup with diferente database name and file names
RESTORE DATABASE eProcess 
   FROM DISK = 'C:\OfficeWorks\Databases\eProcess_BNA_PROD_backup_20060224.bak'
   WITH MOVE 'eProcessData' TO 'C:\OfficeWorks\Databases\eProcess_Data.MDF',
   MOVE 'eProcessLog' TO 'C:\OfficeWorks\Databases\eProcess_Log.LDF'
GO


-- Restore OfficeWorks backup with diferente database name and file names


RESTORE DATABASE OW 
   FROM DISK = 'C:\OfficeWorks\Databases\ow27022006.bak'
   WITH MOVE 'OW_Data' TO 'C:\OfficeWorks\Databases\OW_Data.MDF',
   MOVE 'OW_Log' TO 'C:\OfficeWorks\Databases\OW_Log.LDF'
GO





USE OfficeWorks00_004
exec sp_change_users_login   'UPDATE_ONE', 'OW', 'OW'
GO




RESTORE FILELISTONLY 
   FROM DISK = 'C:\OfficeWorks\BACKUP\0. OfficeWorks419 HESE com collation alterada.bak'

-- OfficeWorks_Data	C:\OfficeWorks\Databases\OfficeWorks_Data.mdf	D	PRIMARY	25034752	35184372080640
-- OfficeWorks_Log	C:\OfficeWorks\Databases\OfficeWorks_Log.ldf	L	NULL	24903680	35184372080640



RESTORE DATABASE OfficeWorks 
   FROM DISK = 'C:\OfficeWorks\BACKUP\0. OfficeWorks419 HESE com collation alterada.bak'
   WITH MOVE 'OfficeWorks_Data' TO 'C:\OfficeWorks\Databases\OfficeWorks_Data.MDF',
   MOVE 'OfficeWorks_Log' TO 'C:\OfficeWorks\Databases\OfficeWorks_Log.LDF'
GO














USE OW
GO

UPDATE OW.tblFileManager
SET FilePath = REPLACE (FilePath, 'f:\OfficeWorks\fs', 'C:\OfficeWorks\FileSystem')
GO



USE eProcess
GO

UPDATE EP.ePR_CFGPARAM
SET PAR_VLPARAME='C:\OfficeWorks\eProcessFileSystem' -- Pasta no HESE: 'C:\Inetpub\wwwroot\eProcess\Temp'
WHERE PAR_CDPARAME='PAR00003'
GO

