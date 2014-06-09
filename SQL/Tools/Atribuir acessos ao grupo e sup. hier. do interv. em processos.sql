

DECLARE
@DataConversao datetime,
@UserConversao varchar(50)


SELECT 
@DataConversao=getdate(),
@UserConversao='OfficeWorks Administrator'




--Acessos ao Grupo do Interveniente
INSERT INTO OW.tblProcessAccess 
( 
	FlowID,
	ProcessID,
	OrganizationalUnitID,
	AccessObject,
	StartProcess,
	ProcessDataAccess,
	DynamicFieldAccess,
	DocumentAccess,
	DispatchAccess,
	InsertedBy,InsertedOn, 
	LastModifiedBy,LastModifiedOn
)
SELECT
	NULL,
	P.ProcessID,
	NULL,
	32, -- Grupo do Interveniente
	1, -- StartProcess Not Set
	ISNULL(FA.ProcessDataAccess,1),
	ISNULL(FA.DynamicFieldAccess,1),
	ISNULL(FA.DocumentAccess,1),
	ISNULL(FA.DispatchAccess,1),
	@UserConversao,@DataConversao, 
	@UserConversao,@DataConversao
FROM 
	OW.tblProcess P INNER JOIN OW.tblFlow F ON (P.FlowID=F.FlowID)
	INNER JOIN (SELECT PA.FlowID,
			PA.ProcessDataAccess,
			PA.DynamicFieldAccess,
			PA.DocumentAccess,
			PA.DispatchAccess 
			FROM OW.tblProcessAccess PA 
			WHERE PA.FlowID IS NOT NULL PA.AccessObject=32) FA ON (F.FlowID=FA.FlowID)
WHERE 
	NOT EXISTS(SELECT 1 FROM OW.tblProcessAccess PA1
	            WHERE PA1.ProcessID=P.ProcessID AND PA1.AccessObject=32)




--Acessos ao Superior Hierarquico do Interveniente
INSERT INTO OW.tblProcessAccess 
( 
	FlowID,
	ProcessID,
	OrganizationalUnitID,
	AccessObject,
	StartProcess,
	ProcessDataAccess,
	DynamicFieldAccess,
	DocumentAccess,
	DispatchAccess,
	InsertedBy,InsertedOn, 
	LastModifiedBy,LastModifiedOn
)
SELECT
	NULL,
	P.ProcessID,
	NULL,
	64, -- Superior Hierarquico do Interveniente
	1, -- StartProcess Not Set
	ISNULL(FA.ProcessDataAccess,1),
	ISNULL(FA.DynamicFieldAccess,1),
	ISNULL(FA.DocumentAccess,1),
	ISNULL(FA.DispatchAccess,1),
	@UserConversao,@DataConversao, 
	@UserConversao,@DataConversao
FROM 
	OW.tblProcess P INNER JOIN OW.tblFlow F ON (P.FlowID=F.FlowID)
	INNER JOIN (SELECT PA.FlowID,
			PA.ProcessDataAccess,
			PA.DynamicFieldAccess,
			PA.DocumentAccess,
			PA.DispatchAccess 
			FROM OW.tblProcessAccess PA 
			WHERE PA.FlowID IS NOT NULL PA.AccessObject=64) FA ON (F.FlowID=FA.FlowID)
WHERE 
	NOT EXISTS(SELECT 1 FROM OW.tblProcessAccess PA1
	            WHERE PA1.ProcessID=P.ProcessID AND PA1.AccessObject=64)


GO