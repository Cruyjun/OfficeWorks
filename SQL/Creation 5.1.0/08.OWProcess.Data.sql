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


SET IDENTITY_INSERT [OW].[tblProcessPriority] ON

insert into OW.tblProcessPriority  (ProcessPriorityID, Description, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn )
values(1, 'Baixa', @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
insert into OW.tblProcessPriority  (ProcessPriorityID, Description, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn )
values(2, 'Normal', @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)
insert into OW.tblProcessPriority  (ProcessPriorityID, Description, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn )
values(3, 'Alta', @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

SET IDENTITY_INSERT [OW].[tblProcessPriority] OFF







insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 1, 'Mail: Assunto Notificação OWProcess',					 1, 1, NULL, 'Notificação do OfficeWorks',					 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 2, 'Mail: Texto Notificação OWProcess',						 1, 1, NULL, 'Tem uma tarefa pendente no OfficeWorks',		 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 3, 'Mail: Servidor',										 1, 0, NULL, 'mail.server.int',							 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 4, 'Mail: Remetente',										 1, 1, NULL, 'OWProcess',								 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 5, 'OWService: Intervalo de iteração do Serviço (segundos)', 2, 1,    5, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 6, 'OWService: Utilizador Associado',					    16, 1, NULL, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 7, 'UI: Nº de registos da lista de navegação',				 2, 1,   15, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 8, 'Aplicação: Caminho absoluto',							 1, 1, NULL, 'http://localhost/OfficeWorks/',					 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 9, 'Workflow: Mensagem de notificação de acção',			 1, 1, NULL, 'Foi efectuada uma acção sobre o processo', @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(10, 'OWService: Intervalo em minutos de iterações em erros',  2, 1,  240, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)












insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(1, 'Registo',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2, 'Arquivo Físico',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3, 'Requisições',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4, 'Processos',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5, 'Entidades',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(6, 'Pesquisa',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7, 'Configuração',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

























insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2001, 2, 'Arquivo Físico - Gestão Espaços : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2002, 2, 'Arquivo Físico - Gestão Espaços : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2003, 2, 'Arquivo Físico - Gestão Espaços : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2004, 2, 'Arquivo Físico - Gestão Espaços : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2005, 2, 'Arquivo Físico - Tipo Espaço : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2006, 2, 'Arquivo Físico - Tipo Espaço : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2007, 2, 'Arquivo Físico - Tipo Espaço : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2008, 2, 'Arquivo Físico - Tipo Espaço : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2009, 2, 'Arquivo Físico - Associar Espaço : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2010, 2, 'Arquivo Físico - Associar Espaço : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2011, 2, 'Arquivo Físico - Associar Espaço : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2012, 2, 'Arquivo Físico - Associar Espaço : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3001, 3, 'Requisições : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3002, 3, 'Requisições : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3003, 3, 'Requisições : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3004, 3, 'Requisições : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3005, 3, 'Requisições - Tipo Movimento : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3006, 3, 'Requisições - Tipo Movimento : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3007, 3, 'Requisições - Tipo Movimento : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3008, 3, 'Requisições - Tipo Movimento : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3009, 3, 'Requisições - Motivo Consulta : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3010, 3, 'Requisições - Motivo Consulta : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3011, 3, 'Requisições - Motivo Consulta : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3012, 3, 'Requisições - Motivo Consulta : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3013, 3, 'Requisições - Tipos Requisição : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3014, 3, 'Requisições - Tipos Requisição : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3015, 3, 'Requisições - Tipos Requisição : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3016, 3, 'Requisições - Tipos Requisição : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3017, 3, 'Requisições - Formas Inutilização : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3018, 3, 'Requisições - Formas Inutilização : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3019, 3, 'Requisições - Formas Inutilização : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3020, 3, 'Requisições - Formas Inutilização : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3021, 3, 'Requisições - Configuração Geral : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3022, 3, 'Requisições - Configuração Geral : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3023, 3, 'Requisições - Configuração Geral : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3024, 3, 'Requisições - Configuração Geral : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4001, 4, 'Processos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4002, 4, 'Processos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4003, 4, 'Processos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4004, 4, 'Processos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4005, 4, 'Processos - Fluxos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4006, 4, 'Processos - Fluxos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4007, 4, 'Processos - Fluxos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4008, 4, 'Processos - Fluxos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4009, 4, 'Processos - Alarmes Fluxos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4010, 4, 'Processos - Alarmes Fluxos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4011, 4, 'Processos - Alarmes Fluxos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4012, 4, 'Processos - Alarmes Fluxos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4013, 4, 'Processos - Definição Fluxos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4014, 4, 'Processos - Definição Fluxos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4015, 4, 'Processos - Definição Fluxos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4016, 4, 'Processos - Definição Fluxos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4017, 4, 'Processos - Campos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4018, 4, 'Processos - Campos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4019, 4, 'Processos - Campos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4020, 4, 'Processos - Campos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4021, 4, 'Processos - Lista Valores : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4022, 4, 'Processos - Lista Valores : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4023, 4, 'Processos - Lista Valores : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4024, 4, 'Processos - Lista Valores : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4025, 4, 'Processos - Periodo Actividade : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4026, 4, 'Processos - Periodo Actividade : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4027, 4, 'Processos - Periodo Actividade : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4028, 4, 'Processos - Periodo Actividade : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4029, 4, 'Processos - Templates Documentos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4030, 4, 'Processos - Templates Documentos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4031, 4, 'Processos - Templates Documentos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4032, 4, 'Processos - Templates Documentos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4033, 4, 'Processos - Tarefas Pre-Definidas : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4034, 4, 'Processos - Tarefas Pre-Definidas : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4035, 4, 'Processos - Tarefas Pre-Definidas : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4036, 4, 'Processos - Tarefas Pre-Definidas : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4037, 4, 'Processos - Acessos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4038, 4, 'Processos - Acessos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4039, 4, 'Processos - Acessos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4040, 4, 'Processos - Acessos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5001, 5, 'Entidades : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5002, 5, 'Entidades : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5003, 5, 'Entidades : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5004, 5, 'Entidades : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5005, 5, 'Entidades - Tipos Entidade : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5006, 5, 'Entidades - Tipos Entidade : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5007, 5, 'Entidades - Tipos Entidade : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5008, 5, 'Entidades - Tipos Entidade : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5009, 5, 'Entidades - Códigos Postais : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5010, 5, 'Entidades - Códigos Postais : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5011, 5, 'Entidades - Códigos Postais : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5012, 5, 'Entidades - Códigos Postais : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5013, 5, 'Entidades - Localidades : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5014, 5, 'Entidades - Localidades : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5015, 5, 'Entidades - Localidades : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5016, 5, 'Entidades - Localidades : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5017, 5, 'Entidades - Distritos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5018, 5, 'Entidades - Distritos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5019, 5, 'Entidades - Distritos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5020, 5, 'Entidades - Distritos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5021, 5, 'Entidades - Países : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5022, 5, 'Entidades - Países : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5023, 5, 'Entidades - Países : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5024, 5, 'Entidades - Países : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5025, 5, 'Entidades - Listas : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5026, 5, 'Entidades - Listas : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5027, 5, 'Entidades - Listas : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5028, 5, 'Entidades - Listas : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5029, 5, 'Entidades - Grupos Distribuição : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5030, 5, 'Entidades - Grupos Distribuição : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5031, 5, 'Entidades - Grupos Distribuição : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5032, 5, 'Entidades - Grupos Distribuição : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5033, 5, 'Entidades - Perfis : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5034, 5, 'Entidades - Perfis : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5035, 5, 'Entidades - Perfis : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5036, 5, 'Entidades - Perfis : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5037, 5, 'Entidades - Arquivo : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5038, 5, 'Entidades - Arquivo : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5039, 5, 'Entidades - Arquivo : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5040, 5, 'Entidades - Arquivo : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5041, 5, 'Entidades - Cargo : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5042, 5, 'Entidades - Cargo : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5043, 5, 'Entidades - Cargo : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5044, 5, 'Entidades - Cargo : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(6001, 6, 'Pesquisa - Documentos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7001, 7, 'Configuração - Utilizadores : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7002, 7, 'Configuração - Utilizadores : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7003, 7, 'Configuração - Utilizadores : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7004, 7, 'Configuração - Utilizadores : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7005, 7, 'Configuração - Grupos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7006, 7, 'Configuração - Grupos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7007, 7, 'Configuração - Grupos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7008, 7, 'Configuração - Grupos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)


insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7009, 7, 'Configuração - Unidade Organizacional (Reencaminhamento) : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7010, 7, 'Configuração - Unidade Organizacional (Reencaminhamento) : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7011, 7, 'Configuração - Unidade Organizacional (Reencaminhamento) : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7012, 7, 'Configuração - Unidade Organizacional (Reencaminhamento) : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7013, 7, 'Configuração - Unidade Organizacional (Acessos) : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7014, 7, 'Configuração - Unidade Organizacional (Acessos) : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7015, 7, 'Configuração - Unidade Organizacional (Acessos) : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7016, 7, 'Configuração - Unidade Organizacional (Acessos) : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7017, 7, 'Configuração - Organigrama : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7101, 7, 'Configuração - Módulos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7102, 7, 'Configuração - Módulos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7103, 7, 'Configuração - Módulos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7104, 7, 'Configuração - Módulos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7105, 7, 'Configuração - Recursos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7106, 7, 'Configuração - Recursos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7107, 7, 'Configuração - Recursos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7108, 7, 'Configuração - Recursos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7109, 7, 'Configuração - Recursos (Acessos) : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7110, 7, 'Configuração - Recursos (Acessos) : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7111, 7, 'Configuração - Recursos (Acessos) : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7112, 7, 'Configuração - Recursos (Acessos) : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7113, 7, 'Configuração - Contador Processos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7114, 7, 'Configuração - Contador Processos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7115, 7, 'Configuração - Contador Processos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7116, 7, 'Configuração - Contador Processos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7117, 7, 'Configuração - Parametros : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7118, 7, 'Configuração - Parametros : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7119, 7, 'Configuração - Parametros : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7120, 7, 'Configuração - Parametros : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7121, 7, 'Configuração - Definições Importação : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7122, 7, 'Configuração - Definições Importação : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7123, 7, 'Configuração - Definições Importação : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7124, 7, 'Configuração - Definições Importação : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7125, 7, 'Configuração - Feriados : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7126, 7, 'Configuração - Feriados : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)






GO

