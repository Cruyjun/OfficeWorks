
-- Create database 
-- #DATABASENAME# Database name for runtime text replacement
-- #DATABASEPATH# Database backup directory for runtime text replacement

CREATE DATABASE #DATABASENAME#
ON (NAME = '#DATABASENAME#_Data',
	FILENAME = '#DATABASEPATH#\#DATABASENAME#_Data.mdf',
	SIZE = 7,
	FILEGROWTH = 10%)
LOG ON (NAME = '#DATABASENAME#_Log',
		FILENAME = '#DATABASEPATH#\#DATABASENAME#_Log.ldf',
		SIZE = 23,
		FILEGROWTH = 10%)
