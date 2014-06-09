/*
    Ferramenta para migração de dados entre versões de OfficeWorks
*/

declare @originDB varchar(50)

set @OriginDB = 'OfficeWorks00_002'

use OfficeWorks00_003

set identity_insert tblGroups on

exec('INSERT INTO [OW].[tblGroups]([GroupID], [HierarchyID], [ShortName], [GroupDesc], [External], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblGroups')

set identity_insert tblGroups off


set identity_insert tblUser on

exec('INSERT INTO [OW].[tblUser]([userID], [PrimaryGroupID], [userDesc], [userMail], [Phone], [MobilePhone], [Fax], [NotifyByMail], [NotifyBySMS], [userLogin], [Password], [EntityID], [TextSignature], [GroupHead], [userActive], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblUser')

set identity_insert tblUser off


set identity_insert tblGroupsUsers on

exec('INSERT INTO [OW].[tblGroupsUsers]([GroupsUserID], [UserID], [GroupID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblGroupsUsers')

set identity_insert tblGroupsUsers off


set identity_insert tblOrganizationalUnit on

exec('INSERT INTO [OW].[tblOrganizationalUnit]([OrganizationalUnitID], [GroupID], [UserID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblOrganizationalUnit')

set identity_insert tblOrganizationalUnit off


exec('INSERT INTO [OW].[tblParameter]([ParameterID], [Description], [ParameterType], [Required], [NumericValue], [AlphaNumericValue], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblParameter')


set identity_insert tblModule on

exec('INSERT INTO [OW].[tblModule]([ModuleID], [Description], [Active], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblModule')

set identity_insert tblModule off


set identity_insert tblResource on

exec('INSERT INTO [OW].[tblResource]([ResourceID], [Code], [ModuleID], [Description], [Active], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblResource')

set identity_insert tblResource off


set identity_insert tblResourceAccess on

exec('INSERT INTO [OW].[tblResourceAccess]([ResourceAccessID], [OrganizationalUnitID], [ResourceID], [AccessType], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblResourceAccess')

set identity_insert tblResourceAccess off


set identity_insert tblListOfValues on

exec('INSERT INTO [OW].[tblListOfValues]([ListOfValuesID], [Description], [Type], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblListOfValues')

set identity_insert tblListOfValues off


set identity_insert tblListOfValuesItem on

exec('INSERT INTO [OW].[tblListOfValuesItem]([ListOfValuesItemID], [ListOfValuesID], [ItemCode], [ItemOrder], [ItemDescription], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblListOfValuesItem')

set identity_insert tblListOfValuesItem off


set identity_insert tblDynamicField on

exec('INSERT INTO [OW].[tblDynamicField]([DynamicFieldID], [Description], [DynamicFieldTypeID], [ListOfValuesID], [Precision], [Scale], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblDynamicField')

set identity_insert tblDynamicField off


set identity_insert tblDocumentTemplate on

exec('INSERT INTO [OW].[tblDocumentTemplate]([DocumentTemplateID], [DocumentCode], [Description], [FileID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblDocumentTemplate')

set identity_insert tblDocumentTemplate off


set identity_insert tblFlowDefinition on

exec('INSERT INTO [OW].[tblFlowDefinition]([FlowDefinitionID], [Description], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblFlowDefinition')

set identity_insert tblFlowDefinition off


set identity_insert tblFlow on

exec('INSERT INTO [OW].[tblFlow]([FlowID], [Code], [Status], [FlowOwnerID], [FlowDefinitionID], [MajorVersion], [MinorVersion], [Duration], [WorkCalendar], [ProcessNumberRule], [HelpAddress], [NotifyRetrocession], [WorkflowRule], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblFlow')

set identity_insert tblFlow off


set identity_insert tblFlowStage on

exec('INSERT INTO [OW].[tblFlowStage]([FlowStageID], [FlowID], [Number], [Description], [Duration], [Address], [Method], [FlowStageType], [DocumentTemplateID], [OrganizationalUnitID], [CanAssociateProcess], [Transfer], [RequestForComments], [AttachmentRequired], [HelpAddress], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblFlowStage')

set identity_insert tblFlowStage off


set identity_insert tblProcessAlarm on

exec('INSERT INTO [OW].[tblProcessAlarm]([ProcessAlarmID], [FlowID], [FlowStageID], [ProcessID], [ProcessStageID], [Occurence], [OccurenceOffset], [Message], [AlertByEMail], [AddresseeExecutant], [AddresseeFlowOwner], [AddresseeProcessOwner], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblProcessAlarm')

set identity_insert tblProcessAlarm off


set identity_insert tblProcessAlarmAddressee on

exec('INSERT INTO [OW].[tblProcessAlarmAddressee]([ProcessAlarmAddresseeID], [ProcessAlarmID], [OrganizationalUnitID], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblProcessAlarmAddressee')

set identity_insert tblProcessAlarmAddressee off


set identity_insert tblProcessDynamicField on

exec('INSERT INTO [OW].[tblProcessDynamicField]([ProcessDynamicFieldID], [DynamicFieldID], [FlowID], [ProcessID], [FieldOrder], [MultiSelection], [Required], [Lookup], [Address], [Method], [Field], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblProcessDynamicField')

set identity_insert tblProcessDynamicField off


set identity_insert tblProcessStageDynamicField on

exec('INSERT INTO [OW].[tblProcessStageDynamicField]([ProcessStageDynamicFieldID], [ProcessDynamicFieldID], [ProcessStageID], [FlowStageID], [Behavior], [CampoParaInteraccaoWS], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblProcessStageDynamicField')

set identity_insert tblProcessStageDynamicField off


set identity_insert tblEntityType on

exec('INSERT INTO [OW].[tblEntityType]([EntityTypeID], [Description], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblEntityType')

set identity_insert tblEntityType off


set identity_insert tblEntities on

exec('INSERT INTO [OW].[tblEntities]([EntID], [PublicCode], [Name], [FirstName], [MiddleName], [LastName], [ListID], [BI], [NumContribuinte], [AssociateNum], [eMail], [InternetSite], [JobTitle], [Street], [PostalCodeID], [CountryID], [Phone], [Fax], [Mobile], [DistrictID], [EntityID], [EntityTypeID], [Active], [Type], [BIEmissionDate], [BIArquiveID], [JobPositionID], [LocationID], [Contact], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblEntities')

set identity_insert tblEntities off


set identity_insert tblProcessPriority on

exec('INSERT INTO [OW].[tblProcessPriority]([ProcessPriorityID], [Description], [Remarks], [InsertedBy], [InsertedOn], [LastModifiedBy], [LastModifiedOn]) select * from ' + @OriginDB + '..tblProcessPriority')

set identity_insert tblProcessPriority off

go