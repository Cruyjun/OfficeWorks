-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.7.1 PARA A VERSÃO 5.7.2
--
-- ---------------------------------------------------------------------------------


PRINT ''
PRINT 'INICIO DA MIGRAÇÃO OfficeWorks 5.7.1 PARA 5.7.2'
PRINT ''
GO


UPDATE OW.tblParameter SET AlphaNumericValue = 'Notificação OfficeWorks' where ParameterID = 1
UPDATE OW.tblParameter SET AlphaNumericValue = 'Foi efectuada uma acção sobre o processo' where ParameterID = 2
UPDATE OW.tblParameter SET AlphaNumericValue = 'Tem uma tarefa pendente no OfficeWorks' where ParameterID = 9
GO


UPDATE OW.tblVersion SET version = '5.7.2' WHERE id= 1
GO

PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.7.1 PARA 5.7.2'
PRINT ''
GO
