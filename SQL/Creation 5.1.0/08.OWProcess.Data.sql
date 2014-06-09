--
-- Declara��o de vari�veis globais 
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
values( 1, 'Mail: Assunto Notifica��o OWProcess',					 1, 1, NULL, 'Notifica��o do OfficeWorks',					 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 2, 'Mail: Texto Notifica��o OWProcess',						 1, 1, NULL, 'Tem uma tarefa pendente no OfficeWorks',		 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 3, 'Mail: Servidor',										 1, 0, NULL, 'mail.server.int',							 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 4, 'Mail: Remetente',										 1, 1, NULL, 'OWProcess',								 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 5, 'OWService: Intervalo de itera��o do Servi�o (segundos)', 2, 1,    5, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 6, 'OWService: Utilizador Associado',					    16, 1, NULL, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 7, 'UI: N� de registos da lista de navega��o',				 2, 1,   15, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 8, 'Aplica��o: Caminho absoluto',							 1, 1, NULL, 'http://localhost/OfficeWorks/',					 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values( 9, 'Workflow: Mensagem de notifica��o de ac��o',			 1, 1, NULL, 'Foi efectuada uma ac��o sobre o processo', @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblParameter (ParameterID, Description, ParameterType, Required, NumericValue, AlphaNumericValue, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(10, 'OWService: Intervalo em minutos de itera��es em erros',  2, 1,  240, NULL,										 @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)












insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(1, 'Registo',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2, 'Arquivo F�sico',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3, 'Requisi��es',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4, 'Processos',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5, 'Entidades',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(6, 'Pesquisa',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblModule (ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7, 'Configura��o',  1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

























insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2001, 2, 'Arquivo F�sico - Gest�o Espa�os : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2002, 2, 'Arquivo F�sico - Gest�o Espa�os : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2003, 2, 'Arquivo F�sico - Gest�o Espa�os : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2004, 2, 'Arquivo F�sico - Gest�o Espa�os : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2005, 2, 'Arquivo F�sico - Tipo Espa�o : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2006, 2, 'Arquivo F�sico - Tipo Espa�o : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2007, 2, 'Arquivo F�sico - Tipo Espa�o : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2008, 2, 'Arquivo F�sico - Tipo Espa�o : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2009, 2, 'Arquivo F�sico - Associar Espa�o : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2010, 2, 'Arquivo F�sico - Associar Espa�o : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2011, 2, 'Arquivo F�sico - Associar Espa�o : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(2012, 2, 'Arquivo F�sico - Associar Espa�o : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3001, 3, 'Requisi��es : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3002, 3, 'Requisi��es : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3003, 3, 'Requisi��es : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3004, 3, 'Requisi��es : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3005, 3, 'Requisi��es - Tipo Movimento : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3006, 3, 'Requisi��es - Tipo Movimento : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3007, 3, 'Requisi��es - Tipo Movimento : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3008, 3, 'Requisi��es - Tipo Movimento : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3009, 3, 'Requisi��es - Motivo Consulta : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3010, 3, 'Requisi��es - Motivo Consulta : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3011, 3, 'Requisi��es - Motivo Consulta : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3012, 3, 'Requisi��es - Motivo Consulta : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3013, 3, 'Requisi��es - Tipos Requisi��o : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3014, 3, 'Requisi��es - Tipos Requisi��o : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3015, 3, 'Requisi��es - Tipos Requisi��o : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3016, 3, 'Requisi��es - Tipos Requisi��o : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3017, 3, 'Requisi��es - Formas Inutiliza��o : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3018, 3, 'Requisi��es - Formas Inutiliza��o : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3019, 3, 'Requisi��es - Formas Inutiliza��o : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3020, 3, 'Requisi��es - Formas Inutiliza��o : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3021, 3, 'Requisi��es - Configura��o Geral : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3022, 3, 'Requisi��es - Configura��o Geral : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3023, 3, 'Requisi��es - Configura��o Geral : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(3024, 3, 'Requisi��es - Configura��o Geral : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




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
values(4013, 4, 'Processos - Defini��o Fluxos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4014, 4, 'Processos - Defini��o Fluxos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4015, 4, 'Processos - Defini��o Fluxos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(4016, 4, 'Processos - Defini��o Fluxos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



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
values(5009, 5, 'Entidades - C�digos Postais : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5010, 5, 'Entidades - C�digos Postais : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5011, 5, 'Entidades - C�digos Postais : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5012, 5, 'Entidades - C�digos Postais : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



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
values(5021, 5, 'Entidades - Pa�ses : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5022, 5, 'Entidades - Pa�ses : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5023, 5, 'Entidades - Pa�ses : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5024, 5, 'Entidades - Pa�ses : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5025, 5, 'Entidades - Listas : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5026, 5, 'Entidades - Listas : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5027, 5, 'Entidades - Listas : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5028, 5, 'Entidades - Listas : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5029, 5, 'Entidades - Grupos Distribui��o : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5030, 5, 'Entidades - Grupos Distribui��o : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5031, 5, 'Entidades - Grupos Distribui��o : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(5032, 5, 'Entidades - Grupos Distribui��o : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



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
values(7001, 7, 'Configura��o - Utilizadores : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7002, 7, 'Configura��o - Utilizadores : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7003, 7, 'Configura��o - Utilizadores : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7004, 7, 'Configura��o - Utilizadores : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7005, 7, 'Configura��o - Grupos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7006, 7, 'Configura��o - Grupos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7007, 7, 'Configura��o - Grupos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7008, 7, 'Configura��o - Grupos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)


insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7009, 7, 'Configura��o - Unidade Organizacional (Reencaminhamento) : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7010, 7, 'Configura��o - Unidade Organizacional (Reencaminhamento) : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7011, 7, 'Configura��o - Unidade Organizacional (Reencaminhamento) : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7012, 7, 'Configura��o - Unidade Organizacional (Reencaminhamento) : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7013, 7, 'Configura��o - Unidade Organizacional (Acessos) : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7014, 7, 'Configura��o - Unidade Organizacional (Acessos) : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7015, 7, 'Configura��o - Unidade Organizacional (Acessos) : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7016, 7, 'Configura��o - Unidade Organizacional (Acessos) : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7017, 7, 'Configura��o - Organigrama : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)




insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7101, 7, 'Configura��o - M�dulos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7102, 7, 'Configura��o - M�dulos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7103, 7, 'Configura��o - M�dulos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7104, 7, 'Configura��o - M�dulos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7105, 7, 'Configura��o - Recursos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7106, 7, 'Configura��o - Recursos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7107, 7, 'Configura��o - Recursos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7108, 7, 'Configura��o - Recursos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7109, 7, 'Configura��o - Recursos (Acessos) : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7110, 7, 'Configura��o - Recursos (Acessos) : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7111, 7, 'Configura��o - Recursos (Acessos) : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7112, 7, 'Configura��o - Recursos (Acessos) : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7113, 7, 'Configura��o - Contador Processos : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7114, 7, 'Configura��o - Contador Processos : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7115, 7, 'Configura��o - Contador Processos : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7116, 7, 'Configura��o - Contador Processos : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7117, 7, 'Configura��o - Parametros : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7118, 7, 'Configura��o - Parametros : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7119, 7, 'Configura��o - Parametros : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7120, 7, 'Configura��o - Parametros : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7121, 7, 'Configura��o - Defini��es Importa��o : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7122, 7, 'Configura��o - Defini��es Importa��o : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7123, 7, 'Configura��o - Defini��es Importa��o : Modificar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7124, 7, 'Configura��o - Defini��es Importa��o : Remover', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)



insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7125, 7, 'Configura��o - Feriados : Consultar', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)

insert into OW.tblResource (ResourceID, ModuleID, Description, Active, InsertedBy ,InsertedOn ,LastModifiedBy ,LastModifiedOn)
values(7126, 7, 'Configura��o - Feriados : Inserir', 1, @InsertedBy, @InsertedOn, @LastModifiedBy, @LastModifiedOn)






GO

