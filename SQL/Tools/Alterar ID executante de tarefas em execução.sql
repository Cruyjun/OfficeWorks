

-- Alterar o OrganizationalUnitID do executante de uma tarefa em execução
-- ORGANIZATIONALUNITID_OLD -> ID a alterar
-- @ORGANIZATIONALUNITID_NEW -> Novo ID

DECLARE @ORGANIZATIONALUNITID_OLD int
DECLARE @ORGANIZATIONALUNITID_NEW int

SET @ORGANIZATIONALUNITID_OLD = 0
SET @ORGANIZATIONALUNITID_NEW = 0


UPDATE 
	OW.tblProcessEvent
SET 
	OrganizationalUnitID = @ORGANIZATIONALUNITID_NEW
WHERE 
	ProcessEventID IN 
	(
		SELECT 
			pe.[ProcessEventID] 
		FROM 
			OW.tblProcess p , 
			OW.tblFlow f , 
			OW.tblFlowDefinition fd , 
			OW.tblProcessStage ps , 
			(
				OW.tblProcessEvent pe  
				LEFT OUTER JOIN 
					(SELECT ProcessEventID, OrganizationalUnitID 
					FROM OW.tblProcessEvent) prevpe 
					ON ((prevpe.ProcessEventID = pe.PreviousProcessEventID))  
				LEFT OUTER JOIN 
					(SELECT ou.OrganizationalUnitID, (CASE WHEN ou.UserID IS NULL THEN gr.GroupDesc ELSE ur.UserDesc END) ToDescription 
					FROM (OW.tblOrganizationalUnit ou LEFT OUTER JOIN  OW.tblGroups gr ON (ou.GroupID = gr.GroupID)) LEFT OUTER JOIN OW.tblUser ur ON (ou.UserID = ur.UserID)) peou 
					ON (pe.OrganizationalUnitID = peou.OrganizationalUnitID)
			)  
			LEFT OUTER JOIN 
				(SELECT ou.OrganizationalUnitID, (CASE WHEN ou.UserID IS NULL THEN gr.GroupDesc ELSE ur.UserDesc END) FromDescription 
				FROM (OW.tblOrganizationalUnit ou LEFT OUTER JOIN  OW.tblGroups gr ON (ou.GroupID = gr.GroupID)) LEFT OUTER JOIN OW.tblUser ur ON (ou.UserID = ur.UserID)) prevpeou 
				ON (prevpe.OrganizationalUnitID = prevpeou.OrganizationalUnitID) 
		WHERE 
			p.FlowID = f.FlowID  AND 
			f.FlowDefinitionID = fd.FlowDefinitionID  AND 
			p.ProcessID = pe.ProcessID  AND 
			ps.ProcessStageID = pe.ProcessStageID AND 
			(p.[ProcessStatus] IN (1,8)) AND 
			(ps.[FlowStageType] = 1) AND 
			(pe.[ProcessEventStatus] IN (1,2,64)) AND 
			(pe.[OrganizationalUnitID] = @ORGANIZATIONALUNITID_OLD) 
	)



