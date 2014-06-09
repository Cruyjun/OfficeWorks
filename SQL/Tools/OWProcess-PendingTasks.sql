-- ----------------------------------------------------------------------------
-- - Query: Tarefas Pendentes
-- -
-- - Colunas: N� Processo
-- - Colunas: Fluxo - Descri��o do fluxo
-- - Colunas: Etapa - Descri��o da etapa
-- - Colunas: Tipo de Unidade Organizacional - Utilizador ou Grupo
-- - Colunas: Unidade Organizacional - Descri��o do utilizador ou grupo
-- - Colunas: Data de In�cio do Processo
-- - Colunas: Data Estimada para conclus�o do processo
-- - Colunas: Data de cria��o da tarefa
-- - Colunas: Data estimada para conclus�o da tarefa
-- - Colunas: Tipo de Etapa - Formul�rio (Manual), Gera��o de Documento, Servi�o Web, Envio de Mail (Autom�ticas)
-- - Colunas: Estado da tarefa
-- ----------------------------------------------------------------------------
SELECT 
ProcessNumber "N� Processo", 
d.Description "Fluxo", 
s.Description "Etapa",
CASE WHEN o.UserID IS NOT NULL THEN 'Utilizador' ELSE 'Grupo' END "Tipo Unidade Organizacional",
COALESCE(u.userDesc, g.GroupDesc) "Unidade Organizacional",
p.StartDate "Data de In�cio do Processo", 
p.EstimatedDateToComplete "Data Prevista Conclus�o Processo", 
e.CreationDate "Data de Cria��o da Tarefa", 
e.EstimatedDateToComplete "Data Prevista Conclus�o Tarefa",
CASE s.FlowStageType WHEN 1 THEN 'Formul�rio' WHEN 2 THEN 'Servi�o Web' WHEN 4 THEN 'Gera��o de documento' WHEN 8 THEN 'Envio de mail"' ELSE 'Indefinido' END "Tipo de Tarefa",
CASE ProcessStatus WHEN 1 THEN 'Activo' WHEN 2 THEN 'Cancelado' WHEN 4 THEN 'Completo' ELSE 'Indefinido' END "Estado Processo",
CASE e.ProcessEventStatus WHEN 1 THEN 'Novo' WHEN 2 THEN 'Activo' WHEN 4 THEN 'Cancelado' WHEN 8 THEN 'Terminado' WHEN 16 THEN 'Aguarda fluxo' WHEN 32 THEN 'Aguarda parecer' ELSE 'Indefinido' END "Estado da Tarefa"
FROM         OW.tblProcessEvent e INNER JOIN
                      OW.tblProcess p ON e.ProcessID = p.ProcessID INNER JOIN
                      OW.tblProcessStage s ON e.ProcessStageID = s.ProcessStageID INNER JOIN
                      OW.tblFlow f ON p.FlowID = f.FlowID INNER JOIN
                      OW.tblFlowDefinition d ON f.FlowDefinitionID = d.FlowDefinitionID INNER JOIN
                      OW.tblOrganizationalUnit o ON e.OrganizationalUnitID = o.OrganizationalUnitID LEFT OUTER JOIN
                      OW.tblGroups g ON o.GroupID = g.GroupID LEFT OUTER JOIN
                      OW.tblUser u ON o.UserID = u.userID


