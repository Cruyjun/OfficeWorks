-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERS�O 5.8.0 PARA A VERS�O 5.8.1
--
-- ---------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------
-- -- ALTERAR A VERSAO DA BASE DE DADOS
-- ---------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.8.1' WHERE id=1
GO

-- ---------------------------------------------------------------------------------
--
-- FIM DO UPGRADE DA BASE DE DADOS OfficeWorks DA VERS�O 5.8.0 PARA A VERS�O 5.8.1
--
-- ---------------------------------------------------------------------------------
