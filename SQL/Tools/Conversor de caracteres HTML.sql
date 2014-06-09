SET NOCOUNT ON

DECLARE 
@HTMLTableCode table (Code varchar(10), Character char)

DECLARE
@Code varchar(10), @Character char

--
-- Tabela de códigos dos caracteres acentudos HTML com base na página:
-- http://tlt.psu.edu/suggestions/international/web/codehtml.html
--

-- Acentuação GRAVE
INSERT INTO @HTMLTableCode values('#192','À')
INSERT INTO @HTMLTableCode values('#200','È')
INSERT INTO @HTMLTableCode values('#204','Ì')
INSERT INTO @HTMLTableCode values('#210','Ò')
INSERT INTO @HTMLTableCode values('#217','Ù')

INSERT INTO @HTMLTableCode values('#224','à')
INSERT INTO @HTMLTableCode values('#232','è')
INSERT INTO @HTMLTableCode values('#236','ì')
INSERT INTO @HTMLTableCode values('#242','ò')
INSERT INTO @HTMLTableCode values('#249','ù')


-- Acentuação AGUDA
INSERT INTO @HTMLTableCode values('#193','Á')
INSERT INTO @HTMLTableCode values('#201','É')
INSERT INTO @HTMLTableCode values('#205','Í')
INSERT INTO @HTMLTableCode values('#211','Ó')
INSERT INTO @HTMLTableCode values('#218','Ú')
INSERT INTO @HTMLTableCode values('#221','Ý')

INSERT INTO @HTMLTableCode values('#225','á')
INSERT INTO @HTMLTableCode values('#233','é')
INSERT INTO @HTMLTableCode values('#237','í')
INSERT INTO @HTMLTableCode values('#243','ó')
INSERT INTO @HTMLTableCode values('#250','ú')
INSERT INTO @HTMLTableCode values('#253','ý')


-- Acentuação CIRCUNFLEXA
INSERT INTO @HTMLTableCode values('#194','Â')
INSERT INTO @HTMLTableCode values('#202','Ê')
INSERT INTO @HTMLTableCode values('#206','Î')
INSERT INTO @HTMLTableCode values('#212','Ô')
INSERT INTO @HTMLTableCode values('#219','Û')

INSERT INTO @HTMLTableCode values('#226','â')
INSERT INTO @HTMLTableCode values('#234','ê')
INSERT INTO @HTMLTableCode values('#238','î')
INSERT INTO @HTMLTableCode values('#244','ô')
INSERT INTO @HTMLTableCode values('#251','û')


-- Acentuação com TIL
INSERT INTO @HTMLTableCode values('#195','Ã')
INSERT INTO @HTMLTableCode values('#209','Ñ')
INSERT INTO @HTMLTableCode values('#213','Õ')

INSERT INTO @HTMLTableCode values('#227','ã')
INSERT INTO @HTMLTableCode values('#241','ñ')
INSERT INTO @HTMLTableCode values('#245','õ')


-- Acentuação TREMA
INSERT INTO @HTMLTableCode values('#196','Ä')
INSERT INTO @HTMLTableCode values('#203','É')
INSERT INTO @HTMLTableCode values('#207','Í')
INSERT INTO @HTMLTableCode values('#214','Ó')
INSERT INTO @HTMLTableCode values('#220','Ú')
INSERT INTO @HTMLTableCode values('#159','Ý')

INSERT INTO @HTMLTableCode values('#228','ä')
INSERT INTO @HTMLTableCode values('#235','ë')
INSERT INTO @HTMLTableCode values('#239','ï')
INSERT INTO @HTMLTableCode values('#246','ö')
INSERT INTO @HTMLTableCode values('#252','ü')
INSERT INTO @HTMLTableCode values('#255','ÿ')



-- Acentuação com CEDILHA
INSERT INTO @HTMLTableCode values('#199','Ç')
INSERT INTO @HTMLTableCode values('#231','ç')

-- Outros caracteres
INSERT INTO @HTMLTableCode values('#170','ª')
INSERT INTO @HTMLTableCode values('#186','º')

INSERT INTO @HTMLTableCode values('#180','´')
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