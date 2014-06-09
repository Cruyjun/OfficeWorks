
-- Restore Database
-- #DATABASENAME# Database name for runtime text replacement

USE master
GO
-- Kill all connectios to OfficeWorks Database
IF (EXISTS(select spid from sysprocesses p inner join sysdatabases d on (p.dbid=d.dbid) where d.name='#DATABASENAME#'))
BEGIN
	DECLARE c CURSOR FOR select spid from sysprocesses p inner join sysdatabases d on (p.dbid=d.dbid) where d.name='#DATABASENAME#'
	DECLARE @spid SMALLINT
	OPEN c
	FETCH c INTO @spid
	WHILE (@@FETCH_STATUS=0)
	BEGIN
		EXECUTE ('KILL ' + @spid)
		FETCH c INTO @spid
	END
	CLOSE c
	DEALLOCATE c
END
-- Restore OfficeWorks Database from device OfficeWorksDB_BACKUP
RESTORE DATABASE #DATABASENAME# FROM OfficeWorksDB_BACKUP WITH REPLACE
-- Drop device
EXEC sp_dropdevice OfficeWorksDB_BACKUP


