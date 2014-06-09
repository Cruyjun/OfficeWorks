

-- -------------------------------------------------------------------------------
-- Atribuir aos processos associados o identificador da primeira etapa do processo
-- -------------------------------------------------------------------------------
DECLARE @ProcessID int
DECLARE @ProcessEventID int
DECLARE @ProcessEventID_PR int

-- -------------------------------------------------------------------------------
-- Obter os eventos que nao teem etapa associada 
-- -------------------------------------------------------------------------------
DECLARE c CURSOR FOR

SELECT pe.ProcessEventID, pe.ProcessID
FROM OW.tblProcessEvent pe INNER JOIN OW.tblProcessReference pr
ON pe.ProcessEventID = pr.ProcessEventID
WHERE pe.ProcessStageID IS NULL

OPEN c
FETCH NEXT FROM c INTO @ProcessEventID_PR, @ProcessID
WHILE @@FETCH_STATUS = 0
BEGIN

	-- -------------------------------------------------------------------------------
	-- Obter o primeiro evento associado a uma etapa de cada processo
	-- -------------------------------------------------------------------------------
	SELECT TOP 1 @ProcessEventID = ProcessEventID
	FROM OW.tblProcessEvent pe1
	WHERE pe1.ProcessID = @ProcessID AND pe1.ProcessStageID IS NOT NULL
	ORDER BY pe1.CreationDate, pe1.ProcessEventID ASC
	
	IF @ProcessEventID IS NOT NULL
	BEGIN

		-- -------------------------------------------------------------------------------
		-- Actualizar evento na tabela de referencias 
		-- -------------------------------------------------------------------------------
		UPDATE OW.tblProcessReference
		SET ProcessEventID = @ProcessEventID
		WHERE ProcessEventID = @ProcessEventID_PR

	END

   	FETCH NEXT FROM c INTO @ProcessEventID_PR, @ProcessID

END
CLOSE c
DEALLOCATE c


-- -------------------------------------------------------------------------------
-- Apagar os eventos que ja nao estao associados
-- -------------------------------------------------------------------------------
DELETE OW.tblProcessEvent
WHERE ProcessEventID NOT IN
(
	SELECT pe3.ProcessEventID
	FROM OW.tblProcessEvent pe3 INNER JOIN OW.tblProcessReference pr3
	ON pe3.ProcessEventID = pr3.ProcessEventID 
)
AND RoutingType = 16 AND ProcessStageID IS NULL


