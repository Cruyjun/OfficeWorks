-- FECHAR TODOS OS PROCESSOS QUE TÊM TODAS AS ETAPAS CONCLUIDAS
UPDATE OW.tblprocess  
SET OW.tblprocess.ProcessStatus = 4, OW.tblprocess.enddate = GETDATE()

WHERE 
	OW.tblprocess.processstatus = 1
AND
	OW.tblprocess.processid NOT IN(

					SELECT DISTINCT AllEvents.processid 
						FROM
						(SELECT * FROM OW.tblprocessevent 
							WHERE
							routingtype in (1,2,32,64,128)
						) AllEvents
						LEFT OUTER JOIN
						(SELECT * FROM OW.tblprocessevent 
							WHERE
							routingtype in (1,2,32,64,128)
							AND
							processeventstatus = 8
						) Eventsend 
						ON (AllEvents.processeventid = Eventsend.processeventid)
					WHERE 
						Eventsend.processeventid IS NULL

					)


