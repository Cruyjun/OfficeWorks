-- ---------------------------------------------------------------------------------
--
-- UPGRADE DA BASE DE DADOS OfficeWorks DA VERSÃO 5.3.0 PARA A VERSÃO 5.3.1
--
-- ---------------------------------------------------------------------------------




-- ---------------------------------------------------------------------------------
--
-- 1. Outras funcionalidades e correcção de erros
-- 
-- ---------------------------------------------------------------------------------

-- DEFECT 802 - Nas distribuições por difusão estava a aparecer o login em vez da descição
GO


ALTER   PROCEDURE OW.usp_GetElectronicMail
	(
		@MailID numeric(18,0)
	)
AS
	
SELECT tm.MailID, tm.FromUserID, tm.Subject, tm.SendDate, tm.Message, tmd.Origin,tmd.Type,tmd.UserID,
tu.userID AS ToUserID,
(select userDesc from OW.tblUser where userID = tm.FromUserID) as FromUserDesc,
tu.UserMail,
(CASE WHEN tmd.Origin='U' THEN tu.userlogin
	ELSE tmu.eMail END) MailUser,
(CASE WHEN tmd.Origin='U' THEN tu.userdesc
	ELSE tmu.eMail END) ToUserDesc
FROM OW.tblElectronicMail tm 
	INNER JOIN OW.tblElectronicMailDestinations tmd ON (tm.MailID=tmd.MailID)
	LEFT JOIN OW.tblElectronicMailUsers tmu ON (tmd.UserID=tmu.MailUserID)
	LEFT JOIN OW.tblUser tu ON (tmd.UserID=tu.UserID)
WHERE tm.MailID=@MailID 	
ORDER BY tm.MailID

-- Ficheiros do mail
SELECT DocumentName
FROM OW.tblElectronicMailDocuments
WHERE MailID=@MailID
ORDER BY DocumentName


RETURN @@ERROR

GO


-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
-- - ALTERAR A VERSÃO DA BASE DE DADOS
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------
UPDATE OW.tblVersion SET version = '5.3.1' WHERE id= 1
GO


PRINT ''
PRINT 'FIM DA MIGRAÇÃO OfficeWorks 5.3.0 PARA 5.3.1'
PRINT ''
GO