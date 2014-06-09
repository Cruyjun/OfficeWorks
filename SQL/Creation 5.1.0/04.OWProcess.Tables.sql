/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2000                    */
/* Created on:     2006-04-04 3:54:08                           */
/*==============================================================*/


/*==============================================================*/
/* Table: tblAlarmQueue                                         */
/*==============================================================*/
create table OW.tblAlarmQueue (
   AlertQueueID         int                  identity
      constraint CK_tblAlarmQueue01 check (AlertQueueID >= 1),
   LaunchDateTime       datetime             not null,
   ProcessAlarmID       int                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblAlarmQueue primary key  (AlertQueueID)
)
go


/*==============================================================*/
/* Index: IX_TBLALARMQUEUE01                                    */
/*==============================================================*/
create   index IX_TBLALARMQUEUE01 on OW.tblAlarmQueue (
LaunchDateTime
)
go


/*==============================================================*/
/* Table: tblAlert                                              */
/*==============================================================*/
create table OW.tblAlert (
   AlertID              int                  identity
      constraint CK_tblAlert01 check (AlertID >= 1),
   Message              varchar(100)         not null,
   UserID               int                  not null,
   ProcessID            int                  null,
   ProcessStageID       int                  null,
   SendDateTime         datetime             not null,
   ReadDateTime         datetime             null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblAlert primary key  (AlertID)
)
go


alter table [OW].[tblAlert]
   add constraint CK_tblAlert02 check 
   (ProcessID is null and ProcessStageID is null or ProcessID is not null)
go
/*==============================================================*/
/* Index: IX_TBLALERT01                                         */
/*==============================================================*/
create   index IX_TBLALERT01 on OW.tblAlert (
UserID
)
go


/*==============================================================*/
/* Index: IX_TBLALERT02                                         */
/*==============================================================*/
create   index IX_TBLALERT02 on OW.tblAlert (
ProcessID
)
go


/*==============================================================*/
/* Table: tblOWNotifyAgentRegister                                 */
/*==============================================================*/
create table OW.tblOWNotifyAgentRegister (
   OWNotifyAgentRegisterID int                  identity
      constraint CK_tblOWNotifyAgentRegister01 check (OWNotifyAgentRegisterID >= 1),
   UserID               int                  not null,
   Host                 varchar(50)          not null,
   Protocol             varchar(20)          not null,
   Port                 int                  not null,
   Uri                  varchar(50)          not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblOWNotifyAgentRegister primary key  (OWNotifyAgentRegisterID),
   constraint AK_tblOWNotifyAgentRegister01 unique (Host)
)
go


/*==============================================================*/
/* Index: IX_TBLOWNotifyAgentREGISTER01                            */
/*==============================================================*/
create   index IX_TBLOWNotifyAgentREGISTER01 on OW.tblOWNotifyAgentRegister (
UserID
)
go


/*==============================================================*/
/* Table: tblDocumentTemplate                                   */
/*==============================================================*/
create table OW.tblDocumentTemplate (
   DocumentTemplateID   int                  identity,
   DocumentCode         varchar(20)          not null,
   Description          varchar(255)         not null,
   FileID               int                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblDocumentTemplate primary key  (DocumentTemplateID),
   constraint IX_tblDocumentTemplate01 unique (DocumentCode),
   constraint IX_tblDocumentTemplate02 unique (Description)
)
go


/*==============================================================*/
/* Table: tblDocumentTemplateField                              */
/*==============================================================*/
create table OW.tblDocumentTemplateField (
   DocumentTemplateFieldID int                  identity,
   DocumentTemplateID   int                  not null,
   ProcessDynamicFieldID int                  not null
      constraint CKC_PROCESSDYNAMICFIE_TBLDOCUM check (ProcessDynamicFieldID >= 1),
   BookmarkName         varchar(255)         not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblDocumentTemplateField primary key  (DocumentTemplateFieldID)
)
go


/*==============================================================*/
/* Index: IX_TBLDOCUMENTTEMPLATEFIELD01                         */
/*==============================================================*/
create unique  index IX_TBLDOCUMENTTEMPLATEFIELD01 on OW.tblDocumentTemplateField (
DocumentTemplateID,
ProcessDynamicFieldID
)
go


/*==============================================================*/
/* Table: tblDynamicField                                       */
/*==============================================================*/
create table OW.tblDynamicField (
   DynamicFieldID       int                  identity
      constraint CK_tblDynamicField01 check (DynamicFieldID >= 1),
   Description          varchar(80)          not null,
   DynamicFieldTypeID   int                  not null
      constraint CK_tblDynamicField02 check (DynamicFieldTypeID in (1,2,4,8,16,32,64,128)),
   ListOfValuesID       int                  null,
   "Precision"          int                  not null
      constraint CK_tblDynamicField03 check ("Precision" between 0 and 1024),
   Scale                int                  not null
      constraint CK_tblDynamicField04 check (Scale between 0 and 8),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblDynamicField primary key  (DynamicFieldID),
   constraint IX_tblDynamicField01 unique (Description),
   constraint CK_tblDynamicField05 check ([DynamicFieldTypeID] = 128 and [ListOfValuesID] is not null or [DynamicFieldTypeID] <> 128 and [ListOfValuesID] is null)
)
go


/*==============================================================*/
/* Table: tblFlow                                               */
/*==============================================================*/
create table OW.tblFlow (
   FlowID               int                  identity
      constraint CK_tblFlow01 check (FlowID >= 1),
   Code                 varchar(10)          not null,
   Status               tinyint              not null
      constraint CK_tblFlow02 check (Status in (1,2,4,8)),
   FlowOwnerID          int                  not null,
   FlowDefinitionID     int                  null,
   MajorVersion         int                  not null
      constraint CK_tblFlow03 check (MajorVersion >= 0),
   MinorVersion         int                  not null
      constraint CK_tblFlow04 check (MinorVersion >= 0),
   Duration             int                  not null
      constraint CK_tblFlow05 check (Duration >= 0),
   WorkCalendar         bit                  not null,
   ProcessNumberRule    varchar(1024)        null,
   HelpAddress          varchar(255)         null,
   NotifyRetrocession   bit                  not null,
   WorkflowRule         text                 not null,
   Adhoc                bit                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFlow primary key  (FlowID),
   constraint AK_tblFlow01 unique (Code)
)
go


/*==============================================================*/
/* Table: tblFlowDefinition                                     */
/*==============================================================*/
create table OW.tblFlowDefinition (
   FlowDefinitionID     int                  identity,
   Description          varchar(80)          not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFlowDefinition primary key  (FlowDefinitionID)
)
go


/*==============================================================*/
/* Index: IX_TBLFLOWDEFINITION01                                */
/*==============================================================*/
create unique  index IX_TBLFLOWDEFINITION01 on OW.tblFlowDefinition (
Description
)
go


/*==============================================================*/
/* Table: tblFlowMailConnector                                  */
/*==============================================================*/
create table OW.tblFlowMailConnector (
   MailConnectorID      int                  identity
      constraint CK_tblFlowMailConnector01 check (MailConnectorID >= 1),
   Folder               varchar(255)         not null,
   FlowID               int                  not null,
   FromAddress          varchar(50)          null,
   AttachMail           bit                  null,
   AttachFiles          bit                  null,
   CompleteStage        bit                  null,
   Active               bit                  null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFlowMailConnector primary key  (MailConnectorID)
)
go


/*==============================================================*/
/* Index: IX_TBLFLOWMAILCONNECTOR01                             */
/*==============================================================*/
create unique  index IX_TBLFLOWMAILCONNECTOR01 on OW.tblFlowMailConnector (
Folder,
FlowID,
FromAddress
)
go


/*==============================================================*/
/* Table: tblFlowPreBuiltStage                                  */
/*==============================================================*/
create table OW.tblFlowPreBuiltStage (
   FlowPreBuiltStageID  int                  identity
      constraint CK_FlowPreBuiltStage01 check (FlowPreBuiltStageID >= 1),
   Description          varchar(80)          not null,
   FlowStageType        smallint             not null
      constraint CK_FlowPreBuiltStage02 check (FlowStageType in (1,2)),
   Address              varchar(255)         null,
   Method               varchar(80)          null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_FlowPreBuiltStage primary key  (FlowPreBuiltStageID)
)
go


/*==============================================================*/
/* Index: IX_FLOWPREBUILTSTAGE01                                */
/*==============================================================*/
create unique  index IX_FLOWPREBUILTSTAGE01 on OW.tblFlowPreBuiltStage (
Description
)
go


/*==============================================================*/
/* Table: tblFlowRouting                                        */
/*==============================================================*/
create table OW.tblFlowRouting (
   FlowRoutingID        int                  identity
      constraint CK_FlowRouting01 check (FlowRoutingID >= 1),
   OrganizationalUnitID int                  not null,
   StartDate            datetime             not null,
   EndDate              datetime             not null,
   FlowID               int                  null,
   ToOrganizationalUnitID int                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFlowDelegation primary key  (FlowRoutingID),
   constraint CK_FlowRouting02 check ([StartDate] <= [EndDate])
)
go


/*==============================================================*/
/* Table: tblFlowStage                                          */
/*==============================================================*/
create table OW.tblFlowStage (
   FlowStageID          int                  identity
      constraint CK_tblFlowStage01 check (FlowStageID >= 1),
   FlowID               int                  not null,
   Number               smallint             not null
      constraint CK_tblFlowStage02 check (Number >= 1),
   Description          varchar(50)          not null,
   Duration             int                  not null
      constraint CK_tblFlowStage03 check (Duration >= 0),
   Address              varchar(255)         null,
   Method               varchar(50)          null,
   FlowStageType        smallint             not null
      constraint CK_tblFlowStage04 check (FlowStageType in (1,2,4,8)),
   DocumentTemplateID   int                  null,
   OrganizationalUnitID int                  null,
   CanAssociateProcess  bit                  not null,
   Transfer             tinyint              not null
      constraint CK_tblFlowStage05 check (Transfer in (1,2,4)),
   RequestForComments   tinyint              not null
      constraint CK_tblFlowStage06 check (RequestForComments in (1,2,4)),
   AttachmentRequired   bit                  not null,
   HelpAddress          varchar(255)         null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblFlowStage primary key  (FlowStageID),
   constraint AK_tblFlowStage01 unique (FlowStageID, FlowID),
   constraint CK_tblFlowStage07 check (FlowStageType = 4 AND DocumentTemplateID IS NOT NULL OR FlowStageType <> 4 AND DocumentTemplateID IS NULL)
)
go


ALTER TABLE [OW].[tblFlowStage] ADD 
	CONSTRAINT [CK_tblFlowStage08] CHECK ([FlowStageType] = 1 and [OrganizationalUnitID] is not null or [FlowStageType] <> 1 and [OrganizationalUnitID] is null)
GO

ALTER TABLE [OW].[tblFlowStage] ADD 
	CONSTRAINT [CK_tblFlowStage09] CHECK ([FlowStageType] in(1, 2) and [Address] is not null or [FlowStageType] not in(1, 2) and [Address] is null)
GO

ALTER TABLE [OW].[tblFlowStage] ADD 
	CONSTRAINT [CK_tblFlowStage10] CHECK ([FlowStageType] = 2 and [Method] is not null or [FlowStageType] <> 2 and [Method] is null)
GO


/*==============================================================*/
/* Index: IX_TBLFLOWSTAGE01                                     */
/*==============================================================*/
create unique  index IX_TBLFLOWSTAGE01 on OW.tblFlowStage (
FlowID,
Number
)
go


/*==============================================================*/
/* Table: tblHoliday                                            */
/*==============================================================*/
create table OW.tblHoliday (
   HolidayID            int                  identity
      constraint CK_tblHoliday01 check (HolidayID >= 1),
   HolidayDate          datetime             not null
      constraint CK_tblHoliday02 check ((DATEPART(hh, HolidayDate) = 0 AND DATEPART(mi, HolidayDate) = 0 AND DATEPART(ss, HolidayDate) = 0 AND DATEPART(ms, HolidayDate) = 0)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblHoliday primary key  (HolidayID),
   constraint AK_tblHoliday01 unique (HolidayDate)
)
go


/*==============================================================*/
/* Table: tblListOfValues                                       */
/*==============================================================*/
create table OW.tblListOfValues (
   ListOfValuesID       int                  identity
      constraint CK_tblListOfValues01 check (ListOfValuesID >= 1),
   Description          varchar(50)          not null,
   Type                 tinyint              not null
      constraint CK_tblListOfValues02 check (Type in (1,2,4,8,16)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblListOfValues primary key  (ListOfValuesID),
   constraint IX_tblListOfValues01 unique (Description)
)
go


/*==============================================================*/
/* Table: tblListOfValuesItem                                   */
/*==============================================================*/
create table OW.tblListOfValuesItem (
   ListOfValuesItemID   int                  identity
      constraint CK_tblListOfValuesItem01 check (ListOfValuesItemID >= 1),
   ListOfValuesID       int                  not null,
   ItemCode             varchar(70)          not null,
   ItemOrder            int                  not null,
   ItemDescription      varchar(800)         not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblListOfValuesItem primary key  (ListOfValuesItemID),
   constraint IX_tblListOfValuesItem01 unique (ListOfValuesID, ItemCode),
   constraint IX_tblListOfValuesItem02 unique (ListOfValuesID, ItemDescription),
   constraint IX_tblListOfValuesItem03 unique (ListOfValuesID, ItemOrder)
)
go


/*==============================================================*/
/* Table: tblModule                                             */
/*==============================================================*/
create table OW.tblModule (
   ModuleID             int                  not null
      constraint CK_tblModule01 check (ModuleID >= 1),
   Description          varchar(80)          not null,
   Active               bit                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblModule primary key  (ModuleID),
   constraint IX_tblModule01 unique (Description)
)
go


/*==============================================================*/
/* Table: tblOrganizationalUnit                                 */
/*==============================================================*/
create table OW.tblOrganizationalUnit (
   OrganizationalUnitID int                  identity
      constraint CK_tblOrganizationalUnit01 check (OrganizationalUnitID >= 1),
   GroupID              int                  null,
   UserID               int                  null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_OrganizationalUnit primary key  (OrganizationalUnitID),
   constraint CK_tblOrganizationalUnit02 check (((GroupID IS NOT NULL AND UserID IS NULL) OR (GroupID IS NULL AND UserID IS NOT NULL)))
)
go


/*==============================================================*/
/* Index: IX_TBLORGANIZATIONALUNIT01                            */
/*==============================================================*/
create unique  index IX_TBLORGANIZATIONALUNIT01 on OW.tblOrganizationalUnit (
UserID,
GroupID
)
go


/*==============================================================*/
/* Table: tblParameter                                          */
/*==============================================================*/
create table OW.tblParameter (
   ParameterID          int                  not null
      constraint CK_tblParameter01 check (ParameterID between 1 and 10),
   Description          varchar(80)          not null,
   ParameterType        tinyint              not null
      constraint CK_tblParameter02 check (ParameterType in (1,2,4,8,16)),
   Required             bit                  not null,
   NumericValue         numeric(18,3)        null,
   AlphaNumericValue    varchar(255)         null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblParameter primary key  (ParameterID)
)
go


/*==============================================================*/
/* Table: tblProcess                                            */
/*==============================================================*/
create table OW.tblProcess (
   ProcessID            int                  identity
      constraint CK_tblProcess01 check (ProcessID >= 1),
   FlowID               int                  not null,
   ProcessNumber        varchar(50)          not null,
   Year                 int                  not null,
   ProcessSubject       varchar(255)         not null,
   PriorityID           int                  not null,
   ProcessOwnerID       int                  not null,
   StartDate            datetime             not null,
   EndDate              datetime             null,
   EstimatedDateToComplete datetime             not null,
   ProcessStatus        int                  not null
      constraint CK_tblProcess02 check (ProcessStatus in (1,2,4,8)),
   Duration             int                  not null
      constraint CK_tblProcess03 check (Duration >= 0),
   WorkCalendar         bit                  not null,
   NotifyRetrocession   bit                  not null,
   WorkflowRule         text                 not null,
   OriginatorID         int                  not null,
   Adhoc                bit                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcess primary key  (ProcessID),
   constraint AK_tblProcess01 unique (ProcessNumber)
)
go


/*==============================================================*/
/* Table: tblProcessAccess                                      */
/*==============================================================*/
create table OW.tblProcessAccess (
   ProcessAccessID      int                  identity
      constraint CK_tblProcessAccess01 check (ProcessAccessID >= 1),
   FlowID               int                  null,
   ProcessID            int                  null,
   OrganizationalUnitID int                  null,
   AccessObject         tinyint              not null
      constraint CK_tblProcessAccess02 check (AccessObject in (1,2,4,8,16)),
   StartProcess         tinyint              not null
      constraint CK_tblProcessAccess03 check (StartProcess in (1,2,4)),
   ProcessDataAccess    tinyint              not null
      constraint CK_tblProcessAccess04 check (ProcessDataAccess in (1,2,4)),
   DynamicFieldAccess   tinyint              not null
      constraint CK_tblProcessAccess05 check (DynamicFieldAccess in (1,2,4)),
   DocumentAccess       tinyint              not null
      constraint CK_tblProcessAccess06 check (DocumentAccess in (1,2,4)),
   DispatchAccess       tinyint              not null
      constraint CK_tblProcessAccess07 check (DispatchAccess in (1,2,4)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessAccess primary key  (ProcessAccessID)
)
go


ALTER TABLE [OW].[tblProcessAccess] ADD 
	CONSTRAINT [CK_tblProcessAccess08] CHECK ([FlowID] is not null and [ProcessID] is null or [FlowID] is null and [ProcessID] is not null),
	CONSTRAINT [CK_tblProcessAccess09] CHECK ([AccessObject] <> 1 and [OrganizationalUnitID] is null or [AccessObject] = 1 and [OrganizationalUnitID] is not null)
GO

/*==============================================================*/
/* Index: IX_TBLPROCESSACCESS01                                 */
/*==============================================================*/
create unique  index IX_TBLPROCESSACCESS01 on OW.tblProcessAccess (
FlowID,
ProcessID,
OrganizationalUnitID,
AccessObject
)
go


/*==============================================================*/
/* Table: tblProcessAlarm                                       */
/*==============================================================*/
create table OW.tblProcessAlarm (
   ProcessAlarmID       int                  identity
      constraint CK_tblProcessAlarm01 check (ProcessAlarmID >= 1),
   FlowID               int                  null,
   FlowStageID          int                  null,
   ProcessID            int                  null,
   ProcessStageID       int                  null,
   Occurence            tinyint              not null
      constraint CK_tblProcessAlarm02 check (Occurence in (1,2,4)),
   OccurenceOffset      int                  not null,
   Message              varchar(255)         not null,
   AlertByEMail         bit                  not null,
   AddresseeExecutant   bit                  not null,
   AddresseeFlowOwner   bit                  not null,
   AddresseeProcessOwner bit                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessAlarm primary key  (ProcessAlarmID)
)
go


alter table [OW].[tblProcessAlarm]
   add constraint CK_tblProcessAlarm03 check 
   (FlowID is not null and ProcessID is null or FlowID is null and ProcessID is not null)
    
go

alter table [OW].[tblProcessAlarm]
   add constraint CK_tblProcessAlarm04 check 
   (FlowStageID is not null and FlowID is not null or FlowStageID is null)
    
go

alter table [OW].[tblProcessAlarm]
   add constraint CK_tblProcessAlarm05 check 
   (ProcessStageID is not null and ProcessID is not null or ProcessStageID is null)
    
go



/*==============================================================*/
/* Index: IX_TBLPROCESSALARM01                                  */
/*==============================================================*/
create   index IX_TBLPROCESSALARM01 on OW.tblProcessAlarm (
FlowID
)
go


/*==============================================================*/
/* Index: IX_TBLPROCESSALARM02                                  */
/*==============================================================*/
create   index IX_TBLPROCESSALARM02 on OW.tblProcessAlarm (
FlowStageID
)
go


/*==============================================================*/
/* Index: IX_TBLPROCESSALARM03                                  */
/*==============================================================*/
create   index IX_TBLPROCESSALARM03 on OW.tblProcessAlarm (
ProcessID
)
go


/*==============================================================*/
/* Index: IX_TBLPROCESSALARM04                                  */
/*==============================================================*/
create   index IX_TBLPROCESSALARM04 on OW.tblProcessAlarm (
ProcessStageID
)
go


/*==============================================================*/
/* Table: tblProcessAlarmAddressee                              */
/*==============================================================*/
create table OW.tblProcessAlarmAddressee (
   ProcessAlarmAddresseeID int                  identity
      constraint CK_tblProcessAlarmAddressee01 check (ProcessAlarmAddresseeID >= 1),
   ProcessAlarmID       int                  not null,
   OrganizationalUnitID int                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessAlarmAddressees primary key  (ProcessAlarmAddresseeID)
)
go


/*==============================================================*/
/* Index: IX_TBLPROCESSALARMADDRESSEES01                        */
/*==============================================================*/
create   index IX_TBLPROCESSALARMADDRESSEES01 on OW.tblProcessAlarmAddressee (
ProcessAlarmID
)
go


/*==============================================================*/
/* Table: tblProcessCounter                                     */
/*==============================================================*/
create table OW.tblProcessCounter (
   ProcessCounterID     int                  identity
      constraint CK_tblProcessCounter01 check (ProcessCounterID >= 1),
   Year                 int                  null
      constraint CK_tblProcessCounter02 check (Year is null or (Year between 1000 and 9999 )),
   Acronym              varchar(50)          null,
   NextValue            int                  not null
      constraint CK_tblProcessCounter03 check (NextValue >= 1),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessCounter primary key  (ProcessCounterID)
)
go


/*==============================================================*/
/* Index: IX_TBLPROCESSCOUNTER01                                */
/*==============================================================*/
create unique  index IX_TBLPROCESSCOUNTER01 on OW.tblProcessCounter (
Year,
Acronym
)
go


/*==============================================================*/
/* Table: tblProcessDocument                                    */
/*==============================================================*/
create table OW.tblProcessDocument (
   ProcessDocumentID    int                  identity
      constraint CK_tblProcessDocument01 check (ProcessDocumentID >= 1),
   ProcessEventID       int                  not null,
   DocumentID           numeric(18,0)        not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessDocument primary key  (ProcessDocumentID)
)
go


alter table OW.tblProcessDocument
   add constraint FK_tblProcessDocument_tblFileManager foreign key (DocumentID)
      references OW.tblFileManager (FileID)
/*==============================================================*/
/* Index: IX_TBLPROCESSDOCUMENT01                               */
/*==============================================================*/
create unique  index IX_TBLPROCESSDOCUMENT01 on OW.tblProcessDocument (
ProcessEventID,
DocumentID
)
go


/*==============================================================*/
/* Table: tblProcessDocumentAccess                              */
/*==============================================================*/
create table OW.tblProcessDocumentAccess (
   ProcessDocumentAccessID int                  identity
      constraint CK_tblProcessDocumentAccess01 check (ProcessDocumentAccessID >= 1),
   OrganizationalUnitID int                  null,
   ProcessDocumentID    int                  null,
   AccessObject         tinyint              not null
      constraint CK_tblProcessDocumentAccess02 check (AccessObject in (1,2,4,8,16)),
   DocumentAccess       tinyint              not null
      constraint CK_tblProcessDocumentAccess03 check (DocumentAccess in (1,2,4)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessDocumentAccess primary key  (ProcessDocumentAccessID)
)
go


ALTER TABLE [OW].[tblProcessDocumentAccess] ADD 
	CONSTRAINT [CK_tblProcessDocumentAccess04] CHECK ([AccessObject] <> 0 and [OrganizationalUnitID] is null or [AccessObject] = 0 and [OrganizationalUnitID] is not null)
GO

/*==============================================================*/
/* Index: IX_TBLPROCESSDOCUMENTACCESS01                         */
/*==============================================================*/
create unique  index IX_TBLPROCESSDOCUMENTACCESS01 on OW.tblProcessDocumentAccess (
ProcessDocumentID,
OrganizationalUnitID,
AccessObject
)
go


/*==============================================================*/
/* Table: tblProcessDynamicField                                */
/*==============================================================*/
create table OW.tblProcessDynamicField (
   ProcessDynamicFieldID int                  identity
      constraint CK_tblProcessDynamicField01 check (ProcessDynamicFieldID >= 1),
   DynamicFieldID       int                  not null,
   FlowID               int                  null,
   ProcessID            int                  null,
   FieldOrder           smallint             not null
      constraint CK_tblProcessDynamicField02 check (FieldOrder >= 1),
   MultiSelection       bit                  not null,
   Required             bit                  not null,
   Lookup               bit                  not null,
   Address              varchar(255)         null,
   Method               varchar(50)          null,
   Field                varchar(50)          null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessDynamicField primary key  (ProcessDynamicFieldID)
)
go


ALTER TABLE [OW].[tblProcessDynamicField] ADD 
	CONSTRAINT [CK_tblProcessDynamicField03] CHECK ([FlowID] is not null and [ProcessID] is null or [FlowID] is null and [ProcessID] is not null)
GO
/*==============================================================*/
/* Index: IX_TBLDYNAMICFIELDSETVALUEITEM01                      */
/*==============================================================*/
create unique  index IX_TBLDYNAMICFIELDSETVALUEITEM01 on OW.tblProcessDynamicField (
DynamicFieldID,
FlowID,
ProcessID,
FieldOrder
)
go


/*==============================================================*/
/* Table: tblProcessDynamicFieldValue                           */
/*==============================================================*/
create table OW.tblProcessDynamicFieldValue (
   ProcessDynamicFieldValueID int                  identity
      constraint CK_tblProcessDynamicFieldValue01 check (ProcessDynamicFieldValueID >= 1),
   ProcessDynamicFieldID int                  not null,
   AlphaNumericFieldValue varchar(1024)        null,
   NumericFieldValue    numeric(18,3)        null,
   DateTimeFieldValue   datetime             null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessDynamicFieldValue primary key  (ProcessDynamicFieldValueID),
   constraint CK_tblProcessDynamicFieldValue02 check ((([AlphaNumericFieldValue] IS NOT NULL AND [NumericFieldValue] IS NULL AND [DateTimeFieldValue] IS NULL) OR ([AlphaNumericFieldValue] IS NULL AND [NumericFieldValue] IS NOT NULL AND [DateTimeFieldValue] IS NULL) OR ([AlphaNumericFieldValue] IS NULL AND [NumericFieldValue] IS NULL AND [DateTimeFieldValue] IS NOT NULL)))
)
go


/*==============================================================*/
/* Table: tblProcessEvent                                       */
/*==============================================================*/
create table OW.tblProcessEvent (
   ProcessEventID       int                  identity
      constraint CK_tblProcessEvent01 check (ProcessEventID >= 1),
   ProcessStageID       int                  null,
   ProcessID            int                  not null,
   RoutingType          tinyint              not null
      constraint CK_tblProcessEvent02 check (RoutingType in (1,2,4,8,16,32,64)),
   ProcessEventStatus   tinyint              not null
      constraint CK_tblProcessEvent03 check (ProcessEventStatus in (1,2,4,8,16,32,64)),
   PreviousProcessEventID int                  null,
   NextProcessEventID   int                  null,
   CreationDate         datetime             not null,
   ReadDate             datetime             null,
   EstimatedDateToComplete datetime             null,
   OrganizationalUnitID int                  not null,
   ExecutionDate        datetime             null,
   EndDate              datetime             null,
   WorkflowActionType   tinyint              not null
      constraint CK_tblProcessEvent04 check (WorkflowActionType in (1,2,4,8,16,32,64,128,129)),
   WorkflowInfo         varchar(1000)        null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_TBLPROCESSEVENT primary key  (ProcessEventID)
)
go


/*==============================================================*/
/* Table: tblProcessPriority                                    */
/*==============================================================*/
create table OW.tblProcessPriority (
   ProcessPriorityID    int                  identity
      constraint CK_tblProcessPriority01 check (ProcessPriorityID >= 1),
   Description          varchar(255)         not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessPriority primary key  (ProcessPriorityID),
   constraint IX_tblProcessPriority01 unique (Description)
)
go


/*==============================================================*/
/* Table: tblProcessReference                                   */
/*==============================================================*/
create table OW.tblProcessReference (
   ProcessReferenceID   int                  identity
      constraint CK_ProcessReference01 check (ProcessReferenceID >= 1),
   ProcessEventID       int                  not null,
   ProcessReferedID     int                  not null,
   ProcessReferenceType tinyint              not null,
   ShareData            bit                  not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessReference primary key  (ProcessReferenceID)
)
go


/*==============================================================*/
/* Table: tblProcessStage                                       */
/*==============================================================*/
create table OW.tblProcessStage (
   ProcessStageID       int                  identity
      constraint CK_tblProcessStage01 check (ProcessStageID >= 1),
   ProcessID            int                  not null,
   Number               smallint             not null
      constraint CK_tblProcessStage02 check (Number >= 1),
   Description          varchar(50)          not null,
   Duration             int                  not null
      constraint CK_tblProcessStage03 check (Duration >= 0),
   Address              varchar(255)         null,
   Method               varchar(50)          null,
   FlowStageType        smallint             not null
      constraint CK_tblProcessStage04 check (FlowStageType in (1,2,4,8)),
   DocumentTemplateID   int                  null,
   OrganizationalUnitID int                  null,
   CanAssociateProcess  bit                  not null,
   Transfer             tinyint              not null
      constraint CK_tblProcessStage05 check (Transfer in (1,2,4)),
   RequestForComments   tinyint              not null
      constraint CK_tblProcessStage06 check (RequestForComments in (1,2,4)),
   AttachmentRequired   bit                  not null,
   HelpAddress          varchar(255)         null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessStage primary key  (ProcessStageID),
   constraint AK_tblProcessStage01 unique (ProcessStageID, ProcessID),
   constraint CK_tblProcessStage07 check (FlowStageType = 4 AND DocumentTemplateID IS NOT NULL OR FlowStageType <> 4 AND DocumentTemplateID IS NULL)
)
go


ALTER TABLE [OW].[tblProcessStage] ADD 
	CONSTRAINT [CK_tblProcessStage08] CHECK ([FlowStageType] = 1 and [OrganizationalUnitID] is not null or [FlowStageType] <> 1 and [OrganizationalUnitID] is null)
GO

ALTER TABLE [OW].[tblProcessStage] ADD 
	CONSTRAINT [CK_tblProcessStage09] CHECK ([FlowStageType] in(1, 2) and [Address] is not null or [FlowStageType] not in(1, 2) and [Address] is null)
GO

ALTER TABLE [OW].[tblProcessStage] ADD 
	CONSTRAINT [CK_tblProcessStage10] CHECK ([FlowStageType] = 2 and [Method] is not null or [FlowStageType] <> 2 and [Method] is null)
GO

/*==============================================================*/
/* Index: IX_TBLPROCESSSTAGE01                                  */
/*==============================================================*/
create unique  index IX_TBLPROCESSSTAGE01 on OW.tblProcessStage (
ProcessID,
Number
)
go


/*==============================================================*/
/* Table: tblProcessStageAccess                                 */
/*==============================================================*/
create table OW.tblProcessStageAccess (
   ProcessStageAccessID int                  identity
      constraint CK_tblProcessStageAccess01 check (ProcessStageAccessID >= 1),
   FlowStageID          int                  null,
   ProcessStageID       int                  null,
   OrganizationalUnitID int                  null,
   AccessObject         tinyint              not null
      constraint CK_tblProcessStageAccess02 check (AccessObject in (1,2,4,8,16)),
   DocumentAccess       tinyint              not null
      constraint CK_tblProcessStageAccess03 check (DocumentAccess in (1,2,4)),
   DispatchAccess       tinyint              not null
      constraint CK_tblProcessStageAccess04 check (DispatchAccess in (1,2,4)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_TBLPROCESSSTAGEACCESS primary key  (ProcessStageAccessID)
)
go


ALTER TABLE [OW].[tblProcessStageAccess] ADD 
	CONSTRAINT [CK_tblProcessStageAccess05] CHECK ([FlowStageID] is not null and [ProcessStageID] is null or [FlowStageID] is null and [ProcessStageID] is not null),
	CONSTRAINT [CK_tblProcessStageAccess06] CHECK ([AccessObject] <> 1 and [OrganizationalUnitID] is null or [AccessObject] = 1 and [OrganizationalUnitID] is not null)
GO

/*==============================================================*/
/* Table: tblProcessStageDynamicField                           */
/*==============================================================*/
create table OW.tblProcessStageDynamicField (
   ProcessStageDynamicFieldID int                  identity
      constraint CK_tblFlowStagesDynamicField01 check (ProcessStageDynamicFieldID >= 1),
   ProcessDynamicFieldID int                  not null,
   ProcessStageID       int                  null,
   FlowStageID          int                  null,
   Behavior             tinyint              not null
      constraint CK_tblFlowStagesDynamicField02 check (Behavior in (1,2,4)),
   CampoParaInteraccaoWS smallint             null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblProcessStageDynamicField primary key  (ProcessStageDynamicFieldID)
)
go


ALTER TABLE [OW].[tblProcessStageDynamicField] ADD 
	CONSTRAINT [CK_tblProcessStageDynamicField03] CHECK ([FlowStageID] is not null and [ProcessStageID] is null or [FlowStageID] is null and [ProcessStageID] is not null)
GO
/*==============================================================*/
/* Index: IX_TBLPROCESSSTAGEDYNAMICFIELD01                      */
/*==============================================================*/
create unique  index IX_TBLPROCESSSTAGEDYNAMICFIELD01 on OW.tblProcessStageDynamicField (
ProcessDynamicFieldID,
ProcessStageID,
FlowStageID
)
go


/*==============================================================*/
/* Table: tblResource                                           */
/*==============================================================*/
create table OW.tblResource (
   ResourceID           int                  not null
      constraint CK_tblResource01 check (ResourceID >= 1),
   ModuleID             int                  not null,
   Description          varchar(80)          not null,
   Active               smallint             not null,
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblResource primary key  (ResourceID)
)
go


/*==============================================================*/
/* Index: IX_TBLRESOURCE01                                      */
/*==============================================================*/
create unique  index IX_TBLRESOURCE01 on OW.tblResource (
Description
)
go


/*==============================================================*/
/* Table: tblResourceAccess                                     */
/*==============================================================*/
create table OW.tblResourceAccess (
   ResourceAccessID     int                  identity
      constraint CK_tblResourceAccess01 check (ResourceAccessID >= 1),
   OrganizationalUnitID int                  not null,
   ResourceID           int                  not null,
   AccessType           tinyint              not null
      constraint CK_tblResourceAccess02 check (AccessType in (1,2,4)),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblResourceAccess primary key  (ResourceAccessID)
)
go


/*==============================================================*/
/* Index: IX_TBLRESOURCEACCESS01                                */
/*==============================================================*/
create unique  index IX_TBLRESOURCEACCESS01 on OW.tblResourceAccess (
ResourceID,
OrganizationalUnitID
)
go


/*==============================================================*/
/* Table: tblWorkingPeriod                                      */
/*==============================================================*/
create table OW.tblWorkingPeriod (
   WorkingPeriodID      int                  identity
      constraint CK_tblWorkingPeriod01 check (WorkingPeriodID >= 1),
   WeekDay              int                  not null
      constraint CK_tblWorkingPeriod02 check (WeekDay between 1 and 7),
   StartHour            int                  not null
      constraint CK_tblWorkingPeriod03 check (StartHour between 0 and 23),
   StartMinute          int                  not null
      constraint CK_tblWorkingPeriod04 check (StartMinute between 0 and 59),
   FinishHour           int                  not null
      constraint CK_tblWorkingPeriod05 check (FinishHour between 0 and 23),
   FinishMinute         int                  not null
      constraint CK_tblWorkingPeriod06 check (FinishMinute between 0 and 59),
   Remarks              varchar(255)         null,
   InsertedBy           varchar(50)          not null,
   InsertedOn           datetime             not null,
   LastModifiedBy       varchar(50)          not null,
   LastModifiedOn       datetime             not null,
   constraint PK_tblWorkingPeriod primary key  (WorkingPeriodID),
   constraint IX_tblWorkingPeriod01 unique (WeekDay, StartHour, StartMinute)
)
go


alter table OW.tblAlarmQueue
   add constraint FK_tblAlarmQueue_tblProcessAlarm foreign key (ProcessAlarmID)
      references OW.tblProcessAlarm (ProcessAlarmID)
go


alter table OW.tblAlert
   add constraint FK_tblAlert_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblAlert
   add constraint FK_tblAlert_tblProcessStage foreign key (ProcessStageID, ProcessID)
      references OW.tblProcessStage (ProcessStageID, ProcessID)
go


alter table OW.tblAlert
   add constraint FK_tblAlert_tblUser foreign key (UserID)
      references OW.tblUser (UserID)
go


alter table OW.tblDocumentTemplateField
   add constraint FK_tblDocumentTemplateField_tblDocumentTemplate foreign key (DocumentTemplateID)
      references OW.tblDocumentTemplate (DocumentTemplateID)
go


alter table OW.tblDocumentTemplateField
   add constraint FK_tblDocumentTemplateField_tblProcessDynamicField foreign key (ProcessDynamicFieldID)
      references OW.tblProcessDynamicField (ProcessDynamicFieldID)
go


alter table OW.tblDynamicField
   add constraint FK_tblDynamicField_tblListOfValues foreign key (ListOfValuesID)
      references OW.tblListOfValues (ListOfValuesID)
go


alter table OW.tblFlow
   add constraint FK_tblFlow_tblFlowDefinition foreign key (FlowDefinitionID)
      references OW.tblFlowDefinition (FlowDefinitionID)
go


alter table OW.tblFlow
   add constraint FK_tblFlow_tblOrganizationalUnit foreign key (FlowOwnerID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblFlowMailConnector
   add constraint FK_tblMailConnector_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
go


alter table OW.tblFlowRouting
   add constraint FK_tblFlowDelegation_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
go


alter table OW.tblFlowRouting
   add constraint FK_tblFlowDelegation_tblOrganizationalUnit01 foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblFlowRouting
   add constraint FK_tblFlowDelegation_tblOrganizationalUnit02 foreign key (ToOrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblFlowStage
   add constraint FK_tblFlowStages_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
      on delete cascade
go


alter table OW.tblFlowStage
   add constraint FK_tblFlowStage_tblDocumentTemplate foreign key (DocumentTemplateID)
      references OW.tblDocumentTemplate (DocumentTemplateID)
go


alter table OW.tblListOfValuesItem
   add constraint FK_tblListOfValuesItem_tblListOfValues foreign key (ListOfValuesID)
      references OW.tblListOfValues (ListOfValuesID)
go


alter table OW.tblOrganizationalUnit
   add constraint FK_tblOrganizationalUnit_tblGroups foreign key (GroupID)
      references OW.tblGroups (GroupID)
go


alter table OW.tblOrganizationalUnit
   add constraint FK_tblOrganizationalUnit_tblUser foreign key (UserID)
      references OW.tblUser (UserID)
go


alter table OW.tblProcess
   add constraint FK_tblProcess_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
go


alter table OW.tblProcess
   add constraint FK_tblProcess_tblOrganizationalUnit foreign key (ProcessOwnerID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcess
   add constraint FK_tblProcess_tblProcessPriority foreign key (PriorityID)
      references OW.tblProcessPriority (ProcessPriorityID)
go


alter table OW.tblProcess
   add constraint FK_tblProcess_tblUser foreign key (OriginatorID)
      references OW.tblUser (UserID)
go


alter table OW.tblProcessAccess
   add constraint FK_tblProcessAccess_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
      on delete cascade
go


alter table OW.tblProcessAccess
   add constraint FK_tblProcessAccess_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessAccess
   add constraint FK_tblProcessAccess_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
go


alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblFlowStage01 foreign key (FlowStageID)
      references OW.tblFlowStage (FlowStageID)
go


alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblFlowStage02 foreign key (FlowStageID, FlowID)
      references OW.tblFlowStage (FlowStageID, FlowID)
go


alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblProcessStage01 foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go


alter table OW.tblProcessAlarm
   add constraint FK_tblProcessAlarm_tblProcessStage02 foreign key (ProcessStageID, ProcessID)
      references OW.tblProcessStage (ProcessStageID, ProcessID)
go


alter table OW.tblProcessAlarmAddressee
   add constraint FK_tblProcessAlarmAddressee_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessAlarmAddressee
   add constraint FK_tblProcessAlarmAddressee_tblProcessAlarm foreign key (ProcessAlarmID)
      references OW.tblProcessAlarm (ProcessAlarmID)
go


alter table OW.tblProcessDocument
   add constraint FK_tblProcessDocument_tblProcessEvent foreign key (ProcessEventID)
      references OW.tblProcessEvent (ProcessEventID)
go


alter table OW.tblProcessDocumentAccess
   add constraint FK_tblProcessDocumentAccess_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessDocumentAccess
   add constraint FK_tblProcessDocumentAccess_tblProcessDocument foreign key (ProcessDocumentID)
      references OW.tblProcessDocument (ProcessDocumentID)
go


alter table OW.tblProcessDynamicField
   add constraint FK_tblProcessDynamicField_tblDynamicField foreign key (DynamicFieldID)
      references OW.tblDynamicField (DynamicFieldID)
go


alter table OW.tblProcessDynamicField
   add constraint FK_tblProcessDynamicField_tblFlow foreign key (FlowID)
      references OW.tblFlow (FlowID)
go


alter table OW.tblProcessDynamicField
   add constraint FK_tblProcessDynamicField_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblProcessDynamicFieldValue
   add constraint FK_tblProcessDynamicFieldValue_tblProcessDynamicField foreign key (ProcessDynamicFieldID)
      references OW.tblProcessDynamicField (ProcessDynamicFieldID)
go


alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcessEvent_Next foreign key (NextProcessEventID)
      references OW.tblProcessEvent (ProcessEventID)
go


alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcessEvent_Previous foreign key (PreviousProcessEventID)
      references OW.tblProcessEvent (ProcessEventID)
go


alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcessStage01 foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go


alter table OW.tblProcessEvent
   add constraint FK_tblProcessEvent_tblProcessStage02 foreign key (ProcessStageID, ProcessID)
      references OW.tblProcessStage (ProcessStageID, ProcessID)
go


alter table OW.tblProcessReference
   add constraint FK_tblProcessReference_tblProcess foreign key (ProcessReferedID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblProcessReference
   add constraint FK_tblProcessReference_tblProcessEvent foreign key (ProcessEventID)
      references OW.tblProcessEvent (ProcessEventID)
go


alter table OW.tblProcessStage
   add constraint FK_tblProcessStage_tblDocumentTemplate foreign key (DocumentTemplateID)
      references OW.tblDocumentTemplate (DocumentTemplateID)
go


alter table OW.tblProcessStage
   add constraint FK_tblProcessStage_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblProcessStage
   add constraint FK_tblProcessStage_tblProcess foreign key (ProcessID)
      references OW.tblProcess (ProcessID)
go


alter table OW.tblProcessStageAccess
   add constraint FK_tblProcessStageAccess_tblFlowStage foreign key (FlowStageID)
      references OW.tblFlowStage (FlowStageID)
go


alter table OW.tblProcessStageAccess
   add constraint FK_tblProcessStageAccess_tblProcessStage foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go


alter table OW.tblProcessStageDynamicField
   add constraint FK_tblProcessStageDynamicField_tblFlowStage foreign key (FlowStageID)
      references OW.tblFlowStage (FlowStageID)
go


alter table OW.tblProcessStageDynamicField
   add constraint FK_tblProcessStageDynamicField_tblProcessDynamicField foreign key (ProcessDynamicFieldID)
      references OW.tblProcessDynamicField (ProcessDynamicFieldID)
go


alter table OW.tblProcessStageDynamicField
   add constraint FK_tblProcessStageDynamicField_tblProcessStage foreign key (ProcessStageID)
      references OW.tblProcessStage (ProcessStageID)
go


alter table OW.tblResource
   add constraint FK_tblResource_tblModule foreign key (ModuleID)
      references OW.tblModule (ModuleID)
go


alter table OW.tblResourceAccess
   add constraint FK_tblResourceAccess_tblOrganizationalUnit foreign key (OrganizationalUnitID)
      references OW.tblOrganizationalUnit (OrganizationalUnitID)
go


alter table OW.tblResourceAccess
   add constraint FK_tblResourceAccess_tblResource foreign key (ResourceID)
      references OW.tblResource (ResourceID)
go


