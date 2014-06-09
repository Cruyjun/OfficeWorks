--
-- PROVINCIAS DE ANGOLA
-- 

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


DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy=InsertedBy, @InsertedOn=InsertedOn,
@LastModifiedBy=LastModifiedBy, @LastModifiedOn=LastModifiedOn
FROM [OW].[##VariaveisGlobais]


INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Luanda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Cabinda',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Zaire',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Uíge',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Kwanza Norte',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Kwanza Sul',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Benguela',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Namibe',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Kwando-Kubango',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Huambo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Lunda Norte',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Lunda Sul',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Moxico',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Bié',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Malange',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Huila',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Cunene',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

INSERT INTO OW.tblDistrict (CountryID,Description,InsertedBy,InsertedOn,LastModifiedBy,LastModifiedOn)
VALUES (8,'Bengo',@InsertedBy,@InsertedOn,@LastModifiedBy,@LastModifiedOn)

GO
