SET NOCOUNT ON

DECLARE 
@HTMLTableCode table (Code varchar(10), Character char)

DECLARE
@Code varchar(10), @Character char

--
-- Tabela de c�digos dos caracteres acentudos HTML com base na p�gina:
-- http://tlt.psu.edu/suggestions/international/web/codehtml.html
--

-- Acentua��o GRAVE
INSERT INTO @HTMLTableCode values('#192','�')
INSERT INTO @HTMLTableCode values('#200','�')
INSERT INTO @HTMLTableCode values('#204','�')
INSERT INTO @HTMLTableCode values('#210','�')
INSERT INTO @HTMLTableCode values('#217','�')

INSERT INTO @HTMLTableCode values('#224','�')
INSERT INTO @HTMLTableCode values('#232','�')
INSERT INTO @HTMLTableCode values('#236','�')
INSERT INTO @HTMLTableCode values('#242','�')
INSERT INTO @HTMLTableCode values('#249','�')


-- Acentua��o AGUDA
INSERT INTO @HTMLTableCode values('#193','�')
INSERT INTO @HTMLTableCode values('#201','�')
INSERT INTO @HTMLTableCode values('#205','�')
INSERT INTO @HTMLTableCode values('#211','�')
INSERT INTO @HTMLTableCode values('#218','�')
INSERT INTO @HTMLTableCode values('#221','�')

INSERT INTO @HTMLTableCode values('#225','�')
INSERT INTO @HTMLTableCode values('#233','�')
INSERT INTO @HTMLTableCode values('#237','�')
INSERT INTO @HTMLTableCode values('#243','�')
INSERT INTO @HTMLTableCode values('#250','�')
INSERT INTO @HTMLTableCode values('#253','�')


-- Acentua��o CIRCUNFLEXA
INSERT INTO @HTMLTableCode values('#194','�')
INSERT INTO @HTMLTableCode values('#202','�')
INSERT INTO @HTMLTableCode values('#206','�')
INSERT INTO @HTMLTableCode values('#212','�')
INSERT INTO @HTMLTableCode values('#219','�')

INSERT INTO @HTMLTableCode values('#226','�')
INSERT INTO @HTMLTableCode values('#234','�')
INSERT INTO @HTMLTableCode values('#238','�')
INSERT INTO @HTMLTableCode values('#244','�')
INSERT INTO @HTMLTableCode values('#251','�')


-- Acentua��o com TIL
INSERT INTO @HTMLTableCode values('#195','�')
INSERT INTO @HTMLTableCode values('#209','�')
INSERT INTO @HTMLTableCode values('#213','�')

INSERT INTO @HTMLTableCode values('#227','�')
INSERT INTO @HTMLTableCode values('#241','�')
INSERT INTO @HTMLTableCode values('#245','�')


-- Acentua��o TREMA
INSERT INTO @HTMLTableCode values('#196','�')
INSERT INTO @HTMLTableCode values('#203','�')
INSERT INTO @HTMLTableCode values('#207','�')
INSERT INTO @HTMLTableCode values('#214','�')
INSERT INTO @HTMLTableCode values('#220','�')
INSERT INTO @HTMLTableCode values('#159','�')

INSERT INTO @HTMLTableCode values('#228','�')
INSERT INTO @HTMLTableCode values('#235','�')
INSERT INTO @HTMLTableCode values('#239','�')
INSERT INTO @HTMLTableCode values('#246','�')
INSERT INTO @HTMLTableCode values('#252','�')
INSERT INTO @HTMLTableCode values('#255','�')



-- Acentua��o com CEDILHA
INSERT INTO @HTMLTableCode values('#199','�')
INSERT INTO @HTMLTableCode values('#231','�')

-- Outros caracteres
INSERT INTO @HTMLTableCode values('#170','�')
INSERT INTO @HTMLTableCode values('#186','�')

INSERT INTO @HTMLTableCode values('#180','�')
INSERT INTO @HTMLTableCode values('quot','"')


DECLARE table_cursor CURSOR FOR
select  [Code], [Character] 
from @HTMLTableCode



OPEN table_cursor

FETCH NEXT FROM table_cursor
INTO @Code , @Character


WHILE @@FETCH_STATUS = 0
BEGIN

	UPDATE OW.tblProcessEvent
	SET WorkflowInfo = REPLACE (WorkflowInfo, '&'+@Code+';', @Character)

	FETCH NEXT FROM table_cursor
	INTO @Code , @Character
END

CLOSE table_cursor
DEALLOCATE table_cursor
GO