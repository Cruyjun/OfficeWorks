-- ---------------------------------------------------------------------------------------
-- Este script apenas é executado na criação de uma base de dados nova.
-- Não deve ser executado em situações de migração de dados.
--
-- Antes de executar o script substituir  
-- o Login: 'domain\username' e a Descrição: 'Administrador OfficeWorks'
-- 
-- ---------------------------------------------------------------------------------------

--
-- Declaração de variáveis globais 
--
if exists (select * from TEMPDB..sysobjects where name = N'##VariaveisGlobais')
BEGIN
	drop table [OW].[##VariaveisGlobais]
END
GO

CREATE TABLE [OW].[##VariaveisGlobais] (
InsertedBy varchar(50),
InsertedOn datetime,
LastModifiedBy varchar(50),
LastModifiedOn datetime
)

INSERT INTO [OW].[##VariaveisGlobais]
(InsertedBy,InsertedOn) VALUES('Administrador OfficeWorks',getdate())

UPDATE  [OW].[##VariaveisGlobais] SET
LastModifiedBy = InsertedBy, LastModifiedOn = InsertedOn

GO





DECLARE @InsertedBy varchar(50)
DECLARE @InsertedOn datetime
DECLARE @LastModifiedBy varchar(50)
DECLARE @LastModifiedOn datetime

SELECT @InsertedBy=InsertedBy, @InsertedOn=InsertedOn,
@LastModifiedBy=LastModifiedBy, @LastModifiedOn=LastModifiedOn
FROM [OW].[##VariaveisGlobais]







--
-- Criar o utilizador que vai ser administrador
--

SET IDENTITY_INSERT OW.tblUser ON

insert into OW.tblUser (
UserID,
PrimaryGroupID,
UserDesc,
UserMail,
Phone,
MobilePhone,
Fax,
NotifyByMail,
NotifyBySMS,
UserLogin,
Password,
EntityID,
TextSignature,
GroupHead,
UserActive,
Remarks,
InsertedBy, InsertedOn ,
LastModifiedBy, LastModifiedOn 
)
values (
1, 
NULL,
'Administrador OfficeWorks', -- Descrição: Substituir antes de executar !
NULL,
NULL,
NULL,
NULL,
0,
0,
'domain\username', -- Login: Substituir antes de executar !
NULL,
NULL,
NULL,
0,
1,
NULL,
@InsertedBy, @InsertedOn ,
@LastModifiedBy, @LastModifiedOn 
)

SET IDENTITY_INSERT OW.tblUser OFF




SET IDENTITY_INSERT OW.tblOrganizationalUnit ON

insert into OW.tblOrganizationalUnit (OrganizationalUnitID,UserID, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn )
values( 1, 1, @InsertedBy, @InsertedOn , @LastModifiedBy, @LastModifiedOn )


SET IDENTITY_INSERT OW.tblOrganizationalUnit OFF

--
-- Dar acessos de administração ao utilizador
--

-- Dar acesso de administração para poder aceder ao registo
EXEC OW.usp_SetApplicationAccess 1, 7, 5 -- UserID, Administration, Application

-- Dar acesso de administração para poder aceder ao OWProcess e restantes recursos
insert into OW.tblResourceAccess ( OrganizationalUnitID, ResourceID, AccessType, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn )
select 1, ResourceID, 4, @InsertedBy, @InsertedOn , @LastModifiedBy, @LastModifiedOn 
from OW.tblResource
















--
-- Criar o Fluxo ADHOC
--
SET IDENTITY_INSERT OW.tblFlowDefinition ON

insert into OW.tblFlowDefinition 
( FlowDefinitionID, Description, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 1, 'Fluxo Adhoc', @InsertedBy, @InsertedOn , @LastModifiedBy, @LastModifiedOn ) 

SET IDENTITY_INSERT OW.tblFlowDefinition OFF




SET IDENTITY_INSERT OW.tblFlow ON

insert into OW.tblFlow ( 
FlowID,
Code,
Status,
FlowOwnerID,
FlowDefinitionID,
MajorVersion,
MinorVersion,
Duration,
WorkCalendar,
ProcessNumberRule,
NotifyRetrocession,
WorkflowRule,
Adhoc,
InsertedBy ,InsertedOn , LastModifiedBy ,LastModifiedOn
)
values(
1,
'ADHOC',
2, -- Produção
1, -- FlowOwnerID
1, -- FlowDefinitionID
1, -- MajorVersion
0, -- MinorVersion
0, -- Duration
0, -- WorkCalendar
'<?xml version="1.0" encoding="UTF-8" ?>
<processNumberRule>
<acronymItem>ADHOC</acronymItem>
<staticItem>-</staticItem>
<yearItem>1</yearItem>
<staticItem>/</staticItem>
<counterItem justify=''6''>3</counterItem>
</processNumberRule>',
0, -- NotifyRetrocession
'', -- WorkflowRule
1, -- Adhoc
@InsertedBy, @InsertedOn , @LastModifiedBy, @LastModifiedOn
)

SET IDENTITY_INSERT OW.tblFlow OFF



GO

