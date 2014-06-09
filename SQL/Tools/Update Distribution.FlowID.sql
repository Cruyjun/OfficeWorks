
-- -----------------------------------------------------------------------------
-- Actualização dos ids dos fluxos dos processos asssociados às distribuições
-- Usado na CMPorto
-- -----------------------------------------------------------------------------

UPDATE OW.tblRegistryDistribution 
SET OW.tblRegistryDistribution.RadioVia = p.FlowID
	FROM OW.tblRegistryDistribution rd 
	INNER JOIN OW.tblProcess p ON rd.ConnectID = p.ProcessID
WHERE rd.Tipo = 6 and rd.RadioVia IS NULL
and rd.ConnectID > 0
		
GO

