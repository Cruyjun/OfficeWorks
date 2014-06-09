-- --------------------------------------------------------------------------
--
-- Apagar referencias inválidas na tabela tblGroupsUsers
--
-- --------------------------------------------------------------------------


-- Apagar referencias para utilizadores que não existem

DELETE FROM [OW].[tblGroupsUsers] WHERE USERID NOT IN (SELECT UserID FROM [OW].[tblUser])
GO

-- Apagar referencias para grupos que não existem

DELETE FROM [OW].[tblGroupsUsers] WHERE GROUPID NOT IN (SELECT GROUPID FROM [OW].[tblGroups])
GO


-- Apagar linhas duplicadas

DELETE FROM OW.tblGroupsUsers
WHERE     exists (

		select * from 
                          (SELECT     UserID, GroupID
                            FROM          OW.tblGroupsUsers
                            GROUP BY UserID, GroupID
                            HAVING      (COUNT(*) > 1) ) as Duplicated
	where OW.tblGroupsUsers.UserID=Duplicated.UserID
	and OW.tblGroupsUsers.GroupID=Duplicated.GroupID
)
GO





































-- --------------------------------------------------------------------------
--
-- Listar Códigos Postais repetidos
--
-- --------------------------------------------------------------------------
SELECT     *
FROM    OW.tblPostalCode CP1
WHERE     exists (

		select * from 
                          (SELECT     Code, Description
                            FROM          OW.tblPostalCode
                            GROUP BY Code, Description
                            HAVING      (COUNT(*) > 1) ) as Duplicated
		where CP1.Code=Duplicated.Code
		and CP1.Description=Duplicated.Description
)
order by CP1.Code,CP1.Description
GO



-- --------------------------------------------------------------------------
--
-- Corrigir Códigos Postais repetidos
--
-- --------------------------------------------------------------------------
UPDATE OW.tblPostalCode
SET Description=Description+CAST(PostalCodeID as varchar(18))
WHERE     exists (

		select * from 
                          (SELECT     Code, Description
                            FROM          OW.tblPostalCode
                            GROUP BY Code, Description
                            HAVING      (COUNT(*) > 1) ) as Duplicated
		where OW.tblPostalCode.Code=Duplicated.Code
		and OW.tblPostalCode.Description=Duplicated.Description
)
GO



































-- --------------------------------------------------------------------------
--
-- Listar Registos repetidos
--
-- --------------------------------------------------------------------------


SELECT     *
FROM    OW.tblRegistry REG1
WHERE     exists (
	select * from 
		(select [bookid], [year], [number]
		from [OW].[tblRegistry]
		group by  [bookid], [year], [number]
		having count(*) >1
		) as Duplicated
	where REG1.bookid = Duplicated.bookid 
	and REG1.year = Duplicated.year 
	and REG1.number = Duplicated.number 
)
order by REG1.bookid, REG1.year, REG1.number



-- --------------------------------------------------------------------------
--
-- Corrigir Registos repetidos AINDA NÃO ESTÁ FEITO !!!
-- (passar os ultimos registos repetidos para o fim: 
-- SET Number=max(Number)+1
-- WHERE RegID=max(RegID) com o mesmo bookid, year e number)
-- --------------------------------------------------------------------------

select max(number) from OW.tblRegistry
where bookid=2 and year=2002

UPDATE OW.tblRegistry 
SET Number= ...
WHERE     exists (
	select * from 
		(select [bookid], [year], [number]
		from [OW].[tblRegistry]
		group by  [bookid], [year], [number]
		having count(*) >1
		) as Duplicated
	where OW.tblRegistry.bookid = Duplicated.bookid 
	and OW.tblRegistry.year = Duplicated.year 
	and OW.tblRegistry.number = Duplicated.number 
)





