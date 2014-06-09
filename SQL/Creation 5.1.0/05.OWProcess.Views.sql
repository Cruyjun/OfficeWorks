/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2000                    */
/* Created on:     2006-01-12 13:41:48                          */
/*==============================================================*/


/*==============================================================*/
/* View: VACCESSOBJECTTYPE                                      */
/*==============================================================*/
create view OW.VACCESSOBJECTTYPE (AccessObject, ID, Hierarchy, Description) as
SELECT	1, -5, -4, 'Other'
UNION
SELECT	2, -3, -2, 'Originator'
UNION
SELECT	4, -2, -1, 'OriginatorGroup'
UNION
SELECT	8, -1, NULL, 'OriginatorHierarchicSuperiors'
UNION
SELECT	16, -4, -3, 'Intervenient'
go


/*==============================================================*/
/* View: VDYNAMICFIELDTYPE                                      */
/*==============================================================*/
create view OW.VDYNAMICFIELDTYPE (ID, Description) as
SELECT 1, 'Numérico' 
UNION 
SELECT 2, 'Monetário' 
UNION 
SELECT 4, 'Alfanumérico' 
UNION 
SELECT 8, 'Data' 
UNION 
SELECT 16, 'Data/Hora' 
UNION 
SELECT 32, 'Booleano' 
UNION 
SELECT 64, 'Entidade' 
UNION 
SELECT 128, 'Lista de Valores'
go


/*==============================================================*/
/* View: VFLOWSTATUSTYPE                                        */
/*==============================================================*/
create view OW.VFLOWSTATUSTYPE (ID, Description) as
SELECT 1, 'Em Construção' 
UNION 
SELECT 2, 'Em Produção' 
UNION 
SELECT 4, 'Em Aprovação' 
UNION 
SELECT 8, 'Rejeitado'
go


/*==============================================================*/
/* View: VFLOWEX01                                              */
/*==============================================================*/
create view OW.VFLOWEX01 as
SELECT      OW.tblFlow.FlowID, OW.tblFlowDefinition.Description, CONVERT(varchar(8), OW.tblFlow.MajorVersion) 
                      + '.' + CONVERT(varchar(8), OW.tblFlow.MinorVersion) AS Version, COALESCE (OW.tblUser.UserDesc, OW.tblGroups.GroupDesc) 
                      AS FlowOwner, OW.tblFlow.Status, OW.vFlowStatusType.Description AS StatusType, OW.tblFlow.ProcessNumberRule, OW.tblFlow.Adhoc, 
					  OW.tblFlow.Remarks, OW.tblFlow.InsertedBy, OW.tblFlow.InsertedOn, OW.tblFlow.LastModifiedBy, OW.tblFlow.LastModifiedOn
FROM         OW.vFlowStatusType INNER JOIN
                      OW.tblFlow INNER JOIN
                      OW.tblFlowDefinition ON OW.tblFlow.FlowDefinitionID = OW.tblFlowDefinition.FlowDefinitionID INNER JOIN
                      OW.tblOrganizationalUnit ON OW.tblFlow.FlowOwnerID = OW.tblOrganizationalUnit.OrganizationalUnitID ON 
                      OW.vFlowStatusType.ID = OW.tblFlow.Status LEFT OUTER JOIN
                      OW.tblGroups ON OW.tblOrganizationalUnit.GroupID = OW.tblGroups.GroupID LEFT OUTER JOIN
                      OW.tblUser ON OW.tblOrganizationalUnit.UserID = OW.tblUser.UserID
go


/*==============================================================*/
/* View: VLISTOFVALUESTYPE                                      */
/*==============================================================*/
create view OW.VLISTOFVALUESTYPE (ID, Description) as
SELECT 1, 'Personalizada' 
UNION 
SELECT 2, 'Unidades Organizacionais' 
UNION 
SELECT 4, 'Grupos' 
UNION 
SELECT 8, 'Funções' 
UNION 
SELECT 16, 'Utilizadores'
go


/*==============================================================*/
/* View: VWEEKDAY                                               */
/*==============================================================*/
create view OW.VWEEKDAY (ID, Description) as
SELECT 1, 'Domingo' 
UNION 
SELECT 2, 'Segunda-Feira' 
UNION 
SELECT 3, 'Terça-Feira' 
UNION 
SELECT 4, 'Quarta-Feira' 
UNION 
SELECT 5, 'Quinta-Feira'
UNION 
SELECT 6, 'Sexta-Feira' 
UNION 
SELECT 7, 'Sábado'
go


