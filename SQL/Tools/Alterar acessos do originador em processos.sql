-- -----------------------------------------------------------------------------
-- Alteração dos acessos do Originador nos processos de terminados fluxos.
--
--
-- -----------------------------------------------------------------------------


update  OW.tblProcessAccess
set
StartProcess=4 , 
ProcessDataAccess = 4 , 
DynamicFieldAccess = 4 , 
DocumentAccess = 2 ,
DispatchAccess = 2
where
AccessObject=2 -- Originador
and
exists (select 1 from OW.tblProcess P inner join OW.tblFlow F
	on P.FlowID=F.FlowID
	where P.ProcessID = OW.tblProcessAccess.ProcessID
	and F.Code in (
	'GGV/SE', 'VGOV/RM', 'VGOV/AS', 'ADM/LM', 'ADM/PJ',
	'ADM/AL', 'ADM/CK', 'DAD', 'DCF', 'DCC', 'DEE', 'DDE',
	'DGR', 'DJU', 'DMA', 'DMC', 'DPS', 'DRH', 'DSI', 'DSP',
	'DTI', 'GAI', 'GDO', 'MF')
)