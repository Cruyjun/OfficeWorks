select r.regId, r.[year], r.number, r.subject, f.fileId, f.[fileName], f.filePath, f.createDate, f.createUserId 
from OW.tblRegistry r
inner join OW.tblRegistryDocuments d on d.regId = r.regId
inner join OW.tblFileManager f on f.fileId = d.fileId
where f.fileid in 
(select fileid from OW.tblFileManager
group by fileid having count(fileid)>1)
