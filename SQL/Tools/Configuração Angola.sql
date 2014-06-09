SET NOCOUNT ON

UPDATE OW.tblResource
SET Description = REPLACE (Description, 'Distrito', 'Província')

GO