-- ----------------------------------------------------------------------------
-- - Query: Tarefas Pendentes
-- -
-- - Colunas: Nº Processo
-- - Colunas: Fluxo - Descrição do fluxo
-- - Colunas: Etapa - Descrição da etapa
-- - Colunas: Tipo de Unidade Organizacional - Utilizador ou Grupo
-- - Colunas: Unidade Organizacional - Descrição do utilizador ou grupo
-- - Colunas: Data de Início do Processo
-- - Colunas: Data Estimada para conclusão do processo
-- - Colunas: Data de criação da tarefa
-- - Colunas: Data estimada para conclusão da tarefa
-- - Colunas: Tipo de Etapa - Formulário (Manual), Geração de Documento, Serviço Web, Envio de Mail (Automáticas)
-- - Colunas: Estado da tarefa
-- ----------------------------------------------------------------------------
SELECT 
ProcessNumber "Nº Processo", 
d.Description "Fluxo", 
s.Description "Etapa",
CASE WHEN o.UserID IS NOT NULL THEN 'Utilizador' ELSE 'Grupo' END "Tipo Unidade Organizacional",
COALESCE(u.userDesc, g.GroupDesc) "Unidade Organizacional",
p.StartDate "Data de Início do Processo", 
p.EstimatedDateToComplete "Data Prevista Conclusão Processo", 
e.CreationDate "Data de Criação da Tarefa", 
e.EstimatedDateToComplete "Data Prevista Conclusão Tarefa",
CASE s.FlowStageType WHEN 1 THEN 'Formulário' WHEN 2 THEN 'Serviço Web' WHEN 4 THEN 'Geração de documento' WHEN 8 THEN 'Envio de mail"' ELSE 'Indefinido' END "Tipo de Tarefa",
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


