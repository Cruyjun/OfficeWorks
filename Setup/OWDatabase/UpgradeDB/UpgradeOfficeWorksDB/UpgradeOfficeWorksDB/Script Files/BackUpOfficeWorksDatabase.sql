
-- Create database backup
-- #DATABASENAME# Database name for runtime text replacement
-- #DATABASEBACKUPPATH# Database backup directory for runtime text replacement

IF NOT EXISTS ( SELECT 1 FROM master.dbo.sysdatabases WHERE name = '#DATABASENAME#')
	RAISERROR ('A Base de Dados do OfficeWorks não existe',16,1)
ELSE
	IF NOT EXISTS (SELECT 1 FROM master.dbo.sysdevices WHERE name = 'OfficeWorksDB_BACKUP')
		EXEC sp_addumpdevice 'disk', 'OfficeWorksDB_BACKUP', '#DATABASEBACKUPPATH#\OfficeWorksDB_BACKUP.dat'
	
	BACKUP DATABASE #DATABASENAME# TO OfficeWorksDB_BACKUP WITH FORMAT,INIT

