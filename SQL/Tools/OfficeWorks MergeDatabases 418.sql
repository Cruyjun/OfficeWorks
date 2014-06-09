
--ATENÇÃO: Este script usa uma base dados como ORIGEM 'OW' e como destio 'DGO_OfficeWorks418'


-- APONTAR para a base dados de origem
USE OW


--**************************** PROCEDIMENTOS AUXILIARES À MIGRAÇÃO *************************************************************

--Convert a HEX to a INT
IF (OBJECT_ID('CNV_Hex2Dec')IS NOT NULL)
	DROP FUNCTION CNV_Hex2Dec
GO
CREATE FUNCTION CNV_Hex2Dec(@HEX VARCHAR(15)) RETURNS BIGINT
AS
BEGIN
	DECLARE @RESULT BIGINT, @I TINYINT
	SET @RESULT = 0
	SET @I = 1
	SET @HEX = REVERSE(@HEX)
	WHILE (@I<=LEN(@HEX))
	BEGIN
		SET @RESULT = @RESULT + (CHARINDEX(SUBSTRING(@HEX,@I,1),'0123456789ABCDEF')-1) * POWER(CAST(16 AS BIGINT),(@I-1)) 
		SET @I = @I + 1
	END	
	RETURN @RESULT
END
GO





IF (object_id('CNV_UpdateSourceReferences') IS NOT NULL)
	DROP PROCEDURE CNV_UpdateSourceReferences
GO
CREATE PROCEDURE CNV_UpdateSourceReferences(
	@EntityTable VARCHAR(30), 
	@EntityColumnID VARCHAR(30), 
	@AuxTable VARCHAR(30), 
	@ColumnID VARCHAR(30), 
	@ColumnDescription VARCHAR(400), 
	@SOURCE_DB_OWNER VARCHAR(30), 
	@DESTINATION_DB_OWNER VARCHAR(30),
	@WHERE VARCHAR(400) = NULL
)
AS

	DECLARE @SQL VARCHAR(8000)	
	DECLARE @Column VARCHAR(50)
	
	SET @SQL = ' ALTER TABLE ' + @SOURCE_DB_OWNER + '.' + @EntityTable + ' NOCHECK CONSTRAINT ALL '
	SET @SQL = @SQL + ' UPDATE ' + @SOURCE_DB_OWNER + '.' + @EntityTable + ' SET [' + @EntityColumnID + '] = da.[' + @ColumnID + '] ' 
	SET @SQL = @SQL + ' FROM ' + @SOURCE_DB_OWNER + '.' + @EntityTable + ' se '
	SET @SQL = @SQL + ' INNER JOIN ' + @SOURCE_DB_OWNER + '.' + @AuxTable + ' sa on(se.[' + @EntityColumnID + '] = sa.[' + @ColumnID + '] '
	--Caso exista filtro, substituir o caracter '$' pelo prefixo 'se' ex.: '$.regid' => 'se.regid'
	IF (@WHERE IS NOT NULL)
		SET @SQL = @SQL + ' AND ' + REPLACE(@WHERE,'$','se')
	SET @SQL = @SQL + ') '
	SET @SQL = @SQL + ' INNER JOIN  ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' da on ('
	
	

	DECLARE c1 CURSOR FOR SELECT item FROM OW.stringtotable(@ColumnDescription,',')
	OPEN c1
	FETCH c1 INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = @SQL + '(da.[' + @Column + '] = sa.[' + @Column + '] OR (da.[' + @Column + '] IS NULL AND sa.[' + @Column + '] IS NULL )) AND ' 
		FETCH c1 INTO @Column
	END
	CLOSE c1
	DEALLOCATE c1

	-- Remover o ultimo AND
	SET @SQL = LEFT(@SQL,LEN(@SQL)-4)
	
	SET @SQL = @SQL + ') '

	--Caso exista filtro, substituir o caracter '$' pela tabela '<DB>.<DBUSER>.<TABLE>' ex.: '$.regid' => 'OfficeWorks.OW.tblregistry.regid'
	IF (@WHERE IS NOT NULL)
		SET @SQL = @SQL + ' WHERE ' + REPLACE(@WHERE,'$','se')
	
	PRINT @SQL
	EXEC (@SQL)		
GO



IF (object_id('CNV_MigrateRows') IS NOT NULL)
	DROP PROCEDURE CNV_MigrateRows
GO
CREATE PROCEDURE CNV_MigrateRows(	
	@AuxTable VARCHAR(30), 
	@ColumnID VARCHAR(30), 
	@ColumnDescription VARCHAR(400), 
	@SOURCE_DB_OWNER VARCHAR(30), 
	@DESTINATION_DB_OWNER VARCHAR(30),
	@OFFSET INT = NULL
)
AS
	
	DECLARE @SQL VARCHAR(8000)
	DECLARE @Column VARCHAR(50)
	DECLARE @Columns VARCHAR(4000)
	DECLARE @ENTER VARCHAR(10)
		
	SET @ENTER = char(13) + char(10) 
	
		
	DECLARE c CURSOR FOR SELECT name FROM syscolumns WHERE id = object_id(@SOURCE_DB_OWNER + '.' + @AuxTable)
	SET @Columns = ''
	OPEN c
	FETCH c INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (UPPER(@Column) <> UPPER(@ColumnID))
			SET @Columns = @Columns + '[' + @Column + '],'
		FETCH c INTO @Column
	END
	CLOSE c
	DEALLOCATE c
	
	-- Remover a ultima virgula
	SET @Columns = LEFT(@Columns,LEN(@Columns)-1)
	

	-- Limpar tabela temporaria 
	SET @SQL = ' IF exists(select 0 from sysobjects where id = object_id(''cvntemp'')) drop table cvntemp ' + @ENTER	
	PRINT @SQL
	EXEC (@SQL)


	-- Criar Tabela temporaria com base na estrutura da tabela principal
	SET @SQL = ' select top 0 * into cvntemp from ' + @SOURCE_DB_OWNER + '.' + @AuxTable + @ENTER
	PRINT @SQL
	EXEC (@SQL)


	-- Transformar Coluna de ID em Itentity 
	SET @SQL =  ' alter table cvntemp drop column [' + @ColumnID + ']'  + @ENTER
	SET @SQL =  @SQL + ' alter table cvntemp add [' + @ColumnID + '] int identity ' + @ENTER
	PRINT @SQL
	EXEC (@SQL)


	--Inserir os registos que ñ existem na base dados de destino na tabela temporaria
	SET @SQL = ' insert into cvntemp ('+ @Columns + ') '
	SET @SQL = @SQL + ' select ' + @Columns + '  from ' + @SOURCE_DB_OWNER + '.' + @AuxTable + ' c1 where '
	SET @SQL = @SQL + ' not exists(select 1 from ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' c2 where '

	DECLARE c1 CURSOR FOR SELECT item FROM OW.stringtotable(@ColumnDescription,',')
	OPEN c1
	FETCH c1 INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @SQL = @SQL + 'c1.[' + @Column + '] = c2.[' + @Column + '] AND ' 
		FETCH c1 INTO @Column
	END
	CLOSE c1
	DEALLOCATE c1

	-- Remover o ultimo AND
	SET @SQL = LEFT(@SQL,LEN(@SQL)-4)
	SET @SQL = @SQL + ') ' + @ENTER 

	PRINT @SQL
	EXEC (@SQL)
	

	--Obter o maxid da tabela da destino
	SET @SQL = ' declare @maxid int '
	IF (@OFFSET IS NOT NULL)
		SET @SQL = @SQL + ' set @maxid = ' + CAST(@OFFSET AS VARCHAR(20)) + ' '
	ELSE
		SET @SQL = @SQL + ' set @maxid = ISNULL((select max([' + @ColumnID + ']) from ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + '),0) '
	
	-- Desactivar a coluna IDENTITY se existir
	IF EXISTS (select * from syscolumns where id = object_id(@SOURCE_DB_OWNER + '.' + @AuxTable) and colstat & 1 = 1 )
		SET @SQL = @SQL + 'SET IDENTITY_INSERT  ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' ON '
	--Copiar os registo da tabela temporaria para a base dados de destino com o offset maxid
	SET @SQL = @SQL + ' insert into ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' ([' + @ColumnID + '], ' + @Columns + ') '
	SET @SQL = @SQL + ' select ([' + @ColumnID + '] + @maxid), ' + @Columns + ' from cvntemp '
	
	PRINT @SQL
	EXEC (@SQL)

	--Apagar registos nulls criados pelo sql anterior. Quando o 'select from cvntemp' não devlove nada
	--este insere um registo null no destino isto é um BUG que só acontesse quado executado atravez do
	-- procedimento SP_executesql ou por EXEC...	
	SET @SQL = 'DELETE ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' WHERE '

	DECLARE c2 CURSOR FOR SELECT item FROM OW.stringtotable(@ColumnDescription,',')
	OPEN c2
	FETCH c2 INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @SQL = @SQL + '[' + @Column + ']  IS NULL AND ' 
		FETCH c2 INTO @Column
	END
	CLOSE c2
	DEALLOCATE c2
	

	-- Remover o ultimo AND
	SET @SQL = LEFT(@SQL,LEN(@SQL)-4)

	PRINT @SQL
	EXEC (@SQL)

GO














IF (object_id('CNV_MigrateRowsAux') IS NOT NULL)
	DROP PROCEDURE CNV_MigrateRowsAux
GO
CREATE PROCEDURE CNV_MigrateRowsAux(	
	@AuxTable VARCHAR(30), 	
	@ColumnDescription VARCHAR(400), 
	@SOURCE_DB_OWNER VARCHAR(30), 
	@DESTINATION_DB_OWNER VARCHAR(30)
)
AS
	
	DECLARE @SQL VARCHAR(8000)
	DECLARE @Column VARCHAR(50)
	DECLARE @Columns VARCHAR(4000)
	DECLARE @ENTER VARCHAR(10)
		
	SET @ENTER = char(13) + char(10) 
	
		
	DECLARE c CURSOR FOR SELECT name FROM syscolumns WHERE id = object_id(@SOURCE_DB_OWNER + '.' + @AuxTable)
	SET @Columns = ''
	OPEN c
	FETCH c INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @Columns = @Columns + '[' + @Column + '],'
		FETCH c INTO @Column
	END
	CLOSE c
	DEALLOCATE c
	
	-- Remover a ultima virgula
	SET @Columns = LEFT(@Columns,LEN(@Columns)-1)

	SET @SQL = ''
	-- Desactivar a coluna IDENTITY se existir
	IF EXISTS (select * from syscolumns where id = object_id(@SOURCE_DB_OWNER + '.' + @AuxTable) and colstat & 1 = 1 )
		SET @SQL = 'SET IDENTITY_INSERT  ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' ON '
	--Inserir os registos que ñ existem na base dados de destino na tabela temporaria
	SET @SQL = @SQL + ' INSERT INTO ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' ('+ @Columns + ') '
	SET @SQL = @SQL + ' SELECT ' + @Columns + '  FROM ' + @SOURCE_DB_OWNER + '.' + @AuxTable + ' c1 WHERE '
	SET @SQL = @SQL + ' NOT EXISTS(SELECT 1 FROM ' + @DESTINATION_DB_OWNER + '.' + @AuxTable + ' c2 WHERE '

	DECLARE c1 CURSOR FOR SELECT item FROM OW.stringtotable(@ColumnDescription,',')
	OPEN c1
	FETCH c1 INTO @Column
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		SET @SQL = @SQL + 'c1.[' + @Column + '] = c2.[' + @Column + '] AND ' 
		FETCH c1 INTO @Column
	END
	CLOSE c1
	DEALLOCATE c1

	-- Remover o ultimo AND
	SET @SQL = LEFT(@SQL,LEN(@SQL)-4)
	SET @SQL = @SQL + ') ' + @ENTER 

	PRINT @SQL
	EXEC (@SQL)
GO


















--******************************* INICIO DA MIGRAÇÃO *************************************************************************











--*********************************  COUNTRY ***********************************************
EXEC CNV_MigrateRows 'tblcountry','countryid','description','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentities','countryid','tblcountry','countryid','description','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblDistrict','countryid','tblcountry','countryid','description','OW.OW','dgo_OfficeWorks418.OW'


--*********************************  POSTAL CODE ***********************************************
EXEC CNV_MigrateRows 'tblpostalcode','postalcodeid','code,description','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentities','postalcodeid','tblpostalcode','postalcodeid','code,description','OW.OW','dgo_OfficeWorks418.OW'


--*********************************  DISTRICT ***********************************************
EXEC CNV_MigrateRows 'tblDistrict','districtid','description','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentities','districtid','tblDistrict','districtid','description','OW.OW','dgo_OfficeWorks418.OW'



--********************************* USERS *******************************************************
--Alerar o dominio na origem de 'DOMAIN' para 'wdgo.pt'
UPDATE OW.OW.tbluser SET userlogin = REPLACE(UPPER(userlogin),'DOMAIN','wdgo.pt')

--Migrar os utilizadores ke não existão no destino
EXEC CNV_MigrateRows 'tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'

--Alterar referências para os utilizadores em todas as tabelas de origem
EXEC CNV_UpdateSourceReferences 'tblentities','Createdby','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentities','Modifiedby','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistry','userid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistry','usermodifyid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblaccess','userid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW', '($.objecttype=1 OR $.objecttype is null)'
EXEC CNV_UpdateSourceReferences 'tblregistryhist','userid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistryhist','usermodifyid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentitylistaccess','objectid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW', '($.objecttype=1)'
EXEC CNV_UpdateSourceReferences 'tblfilemanager','createuserid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblaccessreg','userid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblRegistryDistribution','userid','tbluser','userid','userlogin','OW.OW','dgo_OfficeWorks418.OW'





--*********************************  ENTITY LIST  ***********************************************
EXEC CNV_MigrateRows 'tblentitylist','listid','description','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentities','listid','tblentitylist','listid','description','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblentitylistaccess','objectparentid','tblentitylist','listid','description','OW.OW','dgo_OfficeWorks418.OW',NULL


--*********************************  ENTITY LIST  ACCESS *****************************************
EXEC CNV_MigrateRowsAux 'tblentitylistaccess','objectid,objectparentid,objecttype','OW.OW','dgo_OfficeWorks418.OW'




--*********************************  ENTITY *****************************************************
DECLARE @Maxid INT
--Guardar o MaxID do destino para poder actualizar o campo EntityID na origem
SET @Maxid = (SELECT MAX(entid) FROM dgo_OfficeWorks418.OW.tblentities)
PRINT @Maxid

-- Desactivar a constraint FK_tblEntities_tblEntities porque os ids da coluna EntityID ainda não estão actualizados
ALTER TABLE dgo_OfficeWorks418.OW.tblentities NOCHECK CONSTRAINT FK_tblEntities_tblEntities
--Migrar as entidades só para obter os ids no destino
EXEC CNV_MigrateRows 'tblentities','entid','firstname,middlename,lastname,listid','OW.OW','dgo_OfficeWorks418.OW'


--Actualizar os IDs da coluna EntityID no destino
UPDATE dgo_OfficeWorks418.OW.tblentities SET EntityID = d1.EntID
	FROM (SELECT * FROM dgo_OfficeWorks418.OW.tblentities) d INNER JOIN OW.OW.tblentities s 
	ON(d.EntityID = s.EntID) INNER JOIN (SELECT * FROM dgo_OfficeWorks418.OW.tblentities) d1 
	ON
	(
		s.firstname = d1.firstname AND
		s.MiddleName = d1.MiddleName AND
		s.LastName = d1.LastName AND
		s.ListID = d1.ListID
	)
WHERE
	dgo_OfficeWorks418.OW.tblentities.EntityID = s.EntID
AND
	dgo_OfficeWorks418.OW.tblentities.Entid>@Maxid


--Voltar a ativar a constraint FK_tblEntities_tblEntities 
ALTER TABLE dgo_OfficeWorks418.OW.tblentities CHECK CONSTRAINT FK_tblEntities_tblEntities

--Alterar Referêcias
EXEC CNV_UpdateSourceReferences 'tblregistry','entid','tblentities','entid','firstname,middlename,lastname,listid','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistryhist','entid','tblentities','entid','firstname,middlename,lastname,listid','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblDistributionEntities','entid','tblentities','entid','firstname,middlename,lastname,listid','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblRegistryEntities','entid','tblentities','entid','firstname,middlename,lastname,listid','OW.OW','dgo_OfficeWorks418.OW'





--*********************************  DOCUMENT TYPE *****************************************************
--Select para verificar as abriviaturas que existem iguais no destino em que as designações diferem
--SELECT * FROM OW.OW.tbldocumenttype s INNER JOIN dgo_OfficeWorks418.OW.tbldocumenttype d ON(s.abreviation = d.abreviation AND s.designation<>d.designation)

--Algumas alterações às abreviaturas edesignações na origem antes da migração
	--Necessário à migração
UPDATE OW.OW.tbldocumenttype SET designation = 'Oficio' WHERE designation = 'Ofício'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'ATM' WHERE abreviation = 'AM'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'RTA' WHERE abreviation = 'REC'
	--A pedido do cliente
UPDATE OW.OW.tbldocumenttype SET abreviation = 'CT' WHERE abreviation = 'CARTA'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'DPL' WHERE abreviation = 'DIPLOM'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'FX' WHERE abreviation = 'FAX'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'GRM' WHERE abreviation = 'GR'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'IN' WHERE abreviation = 'INF'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'RL' WHERE abreviation = 'REL'
UPDATE OW.OW.tbldocumenttype SET abreviation = 'RQ' WHERE abreviation = 'REQUER'


--Migrar tipo de documentos 
EXEC CNV_MigrateRows 'tbldocumenttype','doctypeid','designation','OW.OW','dgo_OfficeWorks418.OW'
--Alterar referencias aos tipos de documentos
EXEC CNV_UpdateSourceReferences 'tblregistry','doctypeid','tbldocumenttype','doctypeid','designation','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistryhist','doctypeid','tbldocumenttype','doctypeid','designation','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblBooksDocumentType','documenttypeid','tbldocumenttype','doctypeid','designation','OW.OW','dgo_OfficeWorks418.OW'






--*********************************  BOOKS  *****************************************************
--Select para verificar as abriviaturas que existem iguais no destino em que as designações diferem
--SELECT * FROM OW.OW.tblbooks s INNER JOIN dgo_OfficeWorks418.OW.tblbooks d ON(s.abreviation = d.abreviation AND s.designation<>d.designation)

--Algumas alterações às abreviaturas na origem antes da migração
UPDATE OW.OW.tblbooks SET abreviation = 'TESTE2' WHERE abreviation = 'TESTE1'

--Migrar 
EXEC CNV_MigrateRows 'tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW'

--Alterar referencias na origem
EXEC CNV_UpdateSourceReferences 'tblregistry','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistryhist','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblaccess','objectid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW','$.objectparentid=1'
EXEC CNV_UpdateSourceReferences 'tblClassificationBooks','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblBooksDocumentType','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblFormFieldsBooks','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblFieldsBooksPosition','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblFieldsBookConfig','bookid','tblbooks','bookID','designation','OW.OW','dgo_OfficeWorks418.OW',NULL




--*********************************  FORMFIELDS *****************************************************
--Migrar 
EXEC CNV_MigrateRows 'tblFormFields','formFieldKEY','fieldname','OW.OW','dgo_OfficeWorks418.OW'
--Alterar referencias na origem
EXEC CNV_UpdateSourceReferences 'tblFieldsBookConfig','formfieldkey','tblFormFields','formFieldKEY','fieldname','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblFieldsBooksPosition','formfieldkey','tblFormFields','formFieldKEY','fieldname','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblFormFieldsBooks','formid','tblFormFields','formFieldKEY','fieldname','OW.OW','dgo_OfficeWorks418.OW',NULL
EXEC CNV_UpdateSourceReferences 'tblProfilesfields','formfieldkey','tblFormFields','formFieldKEY','fieldname','OW.OW','dgo_OfficeWorks418.OW',NULL


--*********************************  PROFILES *****************************************************
--Migrar 
EXEC CNV_MigrateRows 'tblProfiles','profileid','profiledesc','OW.OW','dgo_OfficeWorks418.OW'
--Alterar referencias na origem
EXEC CNV_UpdateSourceReferences 'tblProfilesfields','profileid','tblProfiles','profileid','profiledesc','OW.OW','dgo_OfficeWorks418.OW',NULL



--*********************************  PROFILESFIELDS *****************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblProfilesfields','profileid,formfieldkey','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  FIELDS BOOKCONFIG *****************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblFieldsBookConfig','bookid,formfieldkey','OW.OW','dgo_OfficeWorks418.OW'


--*********************************  FIELDS BOOKSPOSITION *****************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblFieldsBooksPosition','bookid,formfieldkey','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  FORMFIELDS BOOKS *****************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblFormFieldsBooks','bookid,formid','OW.OW','dgo_OfficeWorks418.OW'




--*********************************  BOOKS DOCUMENT TYPE  *****************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblBooksDocumentType','bookid,documenttypeid','OW.OW','dgo_OfficeWorks418.OW'


--*********************************  ACCESS  *************************************************************
--Apagar Lixo da tabela antes de migrar
DELETE OW.OW.tblaccess WHERE userid < 1
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblaccess','UserID,ObjectParentID,ObjectID,ObjectTypeID,ObjectType','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  CLASSIFICATION  *****************************************************
--Migrar 
EXEC CNV_MigrateRows 'tblClassification','classID','level1,level2,level3,level4,level5','OW.OW','dgo_OfficeWorks418.OW'
--Alterar referencias na origem
EXEC CNV_UpdateSourceReferences 'tblregistry','classID','tblClassification','classID','level1,level2,level3,level4,level5','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblregistryhist','classID','tblClassification','classID','level1,level2,level3,level4,level5','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblClassificationBooks','classID','tblClassification','classID','level1,level2,level3,level4,level5','OW.OW','dgo_OfficeWorks418.OW',NULL



--*********************************  CLASSIFICATION  BOOKS *****************************************************
--Migrar
EXEC CNV_MigrateRows 'tblclassificationbooks','classbookID','classid,bookid','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  REGISTRY  *****************************************************
--Apagar registos repetidos no historico (bookid,year,number)
DELETE OW.OW.tblregistryhist WHERE regid =(
SELECT MIN(regid) FROM OW.OW.tblregistryhist h1
WHERE EXISTS (
	SELECT bookid,year,number FROM OW.OW.tblregistryhist h2
	WHERE 
		h1.bookid = h2.bookid 
		and h1.year = h2.year 
		and h1.number = h2.number
	GROUP BY bookid,year,number HAVING COUNT(*)>1
))

--Adicionar todos os registos do historico para o registo
SET IDENTITY_INSERT OW.OW.tblregistry ON
INSERT INTO OW.OW.tblregistry (regid, doctypeid,bookid,[year],number,[date],originref,origindate,subject,observations,processnumber,cota,bloco,classid,userID,AntecedenteID,entID,UserModifyID,DateModify,historic,field1,field2)
SELECT * FROM OW.OW.tblregistryhist
GO
SET IDENTITY_INSERT OW.OW.tblregistry OFF
GO
DECLARE @Maxid INT
--Guardar o MaxID do destino para poder actualizar o campo AntecedenteID na origem 
--(ATENÇÃO: MAX(REGID) tanto pode existir na tabela 'tblregister' como na tabela 'tblregisterhist')
SET @Maxid = (SELECT MAX(MX) FROM(
			SELECT MAX(regid) MX FROM dgo_OfficeWorks418.OW.tblregistry
			UNION
			SELECT MAX(regid) MX FROM dgo_OfficeWorks418.OW.tblregistryhist) as REG)
PRINT @Maxid



--Migrar
EXEC CNV_MigrateRows 'tblRegistry','regID','doctypeid,bookid,year,number','OW.OW','dgo_OfficeWorks418.OW',@Maxid



--Actualizar os IDs da coluna AntecedenteID no destino
UPDATE dgo_OfficeWorks418.OW.tblregistry SET AntecedenteID = d1.RegID
	FROM (SELECT * FROM dgo_OfficeWorks418.OW.tblregistry) d  INNER JOIN OW.OW.tblregistry s
	ON (d.AntecedenteID = s.RegID) INNER JOIN (SELECT * FROM dgo_OfficeWorks418.OW.tblregistry) d1 
	ON (
		s.bookid = d1.bookid AND
		s.year = d1.year AND
		s.number = d1.number
	)
WHERE  
	dgo_OfficeWorks418.OW.tblregistry.AntecedenteID = s.RegID



--Existe no destino um campo global chamado 'SERVIÇO(Qual o serviço que está a fazer o registo)' que é obrigatório
--vamos definir este campo para o valor default 'DL11 - 11ªDelegação' para todos os registos migrados
DECLARE @OptionID INT
DECLARE @FieldID INT
SET  @OptionID = (SELECT listid FROM dgo_OfficeWorks418.OW.tbllistoptionsvalues WHERE description = 'DL11 - 11ªDelegação')
SET  @FieldID = (SELECT formfieldkey FROM dgo_OfficeWorks418.OW.tblformfields WHERE fieldname = 'SERVIÇO(Qual o serviço que está a fazer o registo)')
INSERT INTO dgo_OfficeWorks418.OW.tblregistrylists (Regid, BookID, FormFieldKey, Value)
SELECT R.Regid, R.Bookid, @FieldID, @OptionID FROM dgo_OfficeWorks418.OW.tblregistry R LEFT OUTER JOIN dgo_OfficeWorks418.OW.tblregistrylists RL
	ON (R.RegID = RL.RegID)
WHERE RL.RegID IS NULL
AND R.RegID > @Maxid





--Alterar referencias na origem*******************************************
EXEC CNV_UpdateSourceReferences 'tblAccessReg','objectid','tblRegistry','regID','doctypeid,bookid,year,number','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblRegistryDocuments','regid','tblRegistry','regID','doctypeid,bookid,year,number','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblDistributionEntities','regid','tblRegistry','regID','doctypeid,bookid,year,number','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblRegistryEntities','regid','tblRegistry','regID','doctypeid,bookid,year,number','OW.OW','dgo_OfficeWorks418.OW'
EXEC CNV_UpdateSourceReferences 'tblRegistryDistribution','regid','tblRegistry','regID','doctypeid,bookid,year,number','OW.OW','dgo_OfficeWorks418.OW'




--Voltar a colocar os registos que têm o campo historic = 1 na tabela tblregisterhist (NA BD DESTINO)
INSERT INTO dgo_OfficeWorks418.OW.tblregistryhist (regid, doctypeid,bookid,[year],number,[date],originref,origindate,subject,observations,processnumber,cota,bloco,classid,userID,AntecedenteID,entID,UserModifyID,DateModify,historic,field1,field2)
SELECT * FROM dgo_OfficeWorks418.OW.tblregistry WHERE historic = 1

--Apagar os registos que foram copiados para o historico
DELETE dgo_OfficeWorks418.OW.tblregistry WHERE historic = 1






--*********************************  DISTRIBUTION ENTITIES  *****************************************************
--Migrar 
EXEC CNV_MigrateRows 'tblDistributionEntities','distribid','regid,entid','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  REGISTRY ENTITIES  *****************************************************
--Migrar 
EXEC CNV_MigrateRows 'tblRegistryEntities','regentid','regid,entid','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  ACCESSREG  *****************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblAccessReg','userid,objectid','OW.OW','dgo_OfficeWorks418.OW'



--*********************************  DISPATCH  *****************************************************
--Migrar
EXEC CNV_MigrateRows 'tblDispatch','dispatchid','abreviation','OW.OW','dgo_OfficeWorks418.OW'


--*********************************  DISTRIBUTIONTYPE  *****************************************************
--Algumas alterações na origem antes da migração
UPDATE OW.OW.tblDistributionType SET getdistribcode = 'FX' WHERE getdistribcode = 'FAX'
UPDATE OW.OW.tblDistributionType SET getdistribcode = 'CX', distribtypedesc = 'Correio Expresso' WHERE getdistribcode = 'EXM'
UPDATE OW.OW.tblDistributionType SET getdistribcode = 'CT', distribtypedesc = 'Carta' WHERE getdistribcode = 'CORNOR'
UPDATE OW.OW.tblDistributionType SET getdistribcode = 'MP', distribtypedesc = 'Mão Propria' WHERE getdistribcode = 'PMP'


--Migrar
EXEC CNV_MigrateRows 'tblDistributionType','distribtypeid','getdistribcode','OW.OW','dgo_OfficeWorks418.OW'

--Alterar referencias na origem*******************************************
EXEC CNV_UpdateSourceReferences 'tblRegistryDistribution','distribtypeid','tblDistributionType','distribtypeid','getdistribcode','OW.OW','dgo_OfficeWorks418.OW'



--********************************* REGISTRY DISTRIBUTION **************************************************************
--Migrar
EXEC CNV_MigrateRows 'tblRegistryDistribution','id','regid,userid,distribdate','OW.OW','dgo_OfficeWorks418.OW'




--********************************* FILE MANAGER **************************************************************


--Fazer um shift  no 2º nivel de directorias para o numero maximo + 1 do 2º nivel existente no destino
DECLARE @root VARCHAR(50)
declare @newroot VARCHAR(50)
SET @root = 'c:\OfficeWorks\fs\'
SET @newroot = 'o:\Program Files\Magnetik\FS\'


UPDATE OW.OW.tblFileManager 
	SET filepath = @newroot + 
			substring(filepath,LEN(@root)+1,2) + '\' + 
			'06' + '\' + 
			substring(filepath,LEN(@root)+1+3+3,2) + '\' +
			substring(filepath,LEN(@root)+1+3+3+3,2)
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) = '00'
UPDATE OW.OW.tblFileManager 
	SET filepath = @newroot + 
			substring(filepath,LEN(@root)+1,2) + '\' + 
			'07' + '\' + 
			substring(filepath,LEN(@root)+1+3+3,2) + '\' +
			substring(filepath,LEN(@root)+1+3+3+3,2)
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) = '01'
UPDATE OW.OW.tblFileManager 
	SET filepath = @newroot + 
			substring(filepath,LEN(@root)+1,2) + '\' + 
			'08' + '\' + 
			substring(filepath,LEN(@root)+1+3+3,2) + '\' +
			substring(filepath,LEN(@root)+1+3+3+3,2)
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) = '02'
UPDATE OW.OW.tblFileManager 
	SET filepath = @newroot + 
			substring(filepath,LEN(@root)+1,2) + '\' + 
			'09' + '\' + 
			substring(filepath,LEN(@root)+1+3+3,2) + '\' +
			substring(filepath,LEN(@root)+1+3+3+3,2)
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) = '03'
UPDATE OW.tblFileManager 
	SET filepath = @newroot + 
			substring(filepath,LEN(@root)+1,2) + '\' + 
			'10' + '\' + 
			substring(filepath,LEN(@root)+1+3+3,2) + '\' +
			substring(filepath,LEN(@root)+1+3+3+3,2)
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) = '04'
UPDATE OW.OW.tblFileManager 
	SET filepath = @newroot + 
			substring(filepath,LEN(@root)+1,2) + '\' + 
			'11' + '\' + 
			substring(filepath,LEN(@root)+1+3+3,2) + '\' +
			substring(filepath,LEN(@root)+1+3+3+3,2)
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) = '05'
GO


--Copiar tabla tblfilemanager para uma tabela temporaria sem identity para poder fazer o update da coluna fileid
IF (OBJECT_ID('tblFileManagerTMP') IS NOT NULL)
	DROP TABLE tblFileManagerTMP
SELECT CAST(fileid AS INT) fileid, filename,filepath, createdate, createuserid 
	INTO tblFileManagerTMP
FROM OW.OW.tblfilemanager

--Alterar o FileID na tabela temporaria para um indice equivalente ao filepath
DECLARE @root VARCHAR(50)
SET @root = 'o:\Program Files\Magnetik\FS\'
UPDATE tblFileManagerTMP 
	SET fileid = 	dbo.CNV_Hex2Dec(substring(filepath,LEN(@root)+1,2) + 
			substring(filepath,LEN(@root)+1+3,2) + 
			substring(filepath,LEN(@root)+1+3+3,2) +
			substring(filepath,LEN(@root)+1+3+3+3,2))
	WHERE 
		substring(filepath,LEN(@root)+1+3,2) IN ('06','07','08','09','10','11')
GO

--Migrar
SET IDENTITY_INSERT dgo_OfficeWorks418.OW.tblFileManager ON
INSERT INTO dgo_OfficeWorks418.OW.tblFileManager (fileid, filename, filepath, createdate, createuserid)
	SELECT * FROM tblFileManagerTMP

--Alterar referencias na origem*******************************************
EXEC CNV_UpdateSourceReferences 'tblRegistryDocuments','fileid','tblfilemanager','fileid','filepath','OW.OW','dgo_OfficeWorks418.OW'





--***************************************   REGISTERDOCUMENTS ************************************************
--Migrar (AUX)
EXEC CNV_MigrateRowsAux 'tblRegistryDocuments','regid,fileid','OW.OW','dgo_OfficeWorks418.OW'









--******************************* FIM DA MIGRAÇÃO *************************************************************************









































/*
DECLARE c CURSOR FOR SELECT top 80  name FROM sysobjects where xtype='u' and uid = 5 order by name desc
DECLARE @Table VARCHAR(50)
DECLARE @SQL VARCHAR(8000)

SET @SQL = ''
OPEN c
FETCH c INTO @Table
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SQL = @SQL + 'SELECT ''' + @Table + ''' TableName, COUNT(*) xxx FROM OW.OW.' + @Table + CHAR(13) + CHAR(10) + ' UNION '
	FETCH c INTO @Table
END
CLOSE c
DEALLOCATE c
SET  @SQL = LEFT(@SQL, LEN(@SQL)-7)
PRINT @SQL
EXEC (@SQL)

SELECT 'tblOWWorkFlowDistribution' TableName, COUNT(*) xxx FROM OW.OW.tblOWWorkFlowDistribution
 UNION SELECT 'tblVersion' TableName, COUNT(*) xxx FROM OW.OW.tblVersion
 UNION SELECT 'tblUserPersistenceConfig' TableName, COUNT(*) xxx FROM OW.OW.tblUserPersistenceConfig
 UNION SELECT 'tblUserPersistence' TableName, COUNT(*) xxx FROM OW.OW.tblUserPersistence
 UNION SELECT 'tblUser' TableName, COUNT(*) xxx FROM OW.OW.tblUser
 UNION SELECT 'tblTexts' TableName, COUNT(*) xxx FROM OW.OW.tblTexts
 UNION SELECT 'tblStrings' TableName, COUNT(*) xxx FROM OW.OW.tblStrings
 UNION SELECT 'tblState' TableName, COUNT(*) xxx FROM OW.OW.tblState
 UNION SELECT 'tblRegistryLists' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryLists
 UNION SELECT 'tblRegistryKeywords' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryKeywords
 UNION SELECT 'tblRegistryHist' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryHist
 UNION SELECT 'tblRegistryEntities' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryEntities
 UNION SELECT 'tblRegistryDocuments' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryDocuments
 UNION SELECT 'tblRegistryDistribution' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryDistribution
 UNION SELECT 'tblRegistry' TableName, COUNT(*) xxx FROM OW.OW.tblRegistry
 UNION SELECT 'tblProfilesFields' TableName, COUNT(*) xxx FROM OW.OW.tblProfilesFields
 UNION SELECT 'tblProfiles' TableName, COUNT(*) xxx FROM OW.OW.tblProfiles
 UNION SELECT 'tblProduct' TableName, COUNT(*) xxx FROM OW.OW.tblProduct
 UNION SELECT 'tblProcessUserAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblProcessUserAccesses
 UNION SELECT 'tblProcessStages' TableName, COUNT(*) xxx FROM OW.OW.tblProcessStages
 UNION SELECT 'tblProcessGroupAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblProcessGroupAccesses
 UNION SELECT 'tblProcessDocuments' TableName, COUNT(*) xxx FROM OW.OW.tblProcessDocuments
 UNION SELECT 'tblProcessAlarms' TableName, COUNT(*) xxx FROM OW.OW.tblProcessAlarms
 UNION SELECT 'tblProcessAlarmAddressees' TableName, COUNT(*) xxx FROM OW.OW.tblProcessAlarmAddressees
 UNION SELECT 'tblProcess' TableName, COUNT(*) xxx FROM OW.OW.tblProcess
 UNION SELECT 'tblPostalCodeTMP' TableName, COUNT(*) xxx FROM OW.OW.tblPostalCodeTMP
 UNION SELECT 'tblPostalCode' TableName, COUNT(*) xxx FROM OW.OW.tblPostalCode
 UNION SELECT 'tblNonWorkingHours' TableName, COUNT(*) xxx FROM OW.OW.tblNonWorkingHours
 UNION SELECT 'tblNonWorkingDays' TableName, COUNT(*) xxx FROM OW.OW.tblNonWorkingDays
 UNION SELECT 'tblListValues' TableName, COUNT(*) xxx FROM OW.OW.tblListValues
 UNION SELECT 'tblListOptionsValues' TableName, COUNT(*) xxx FROM OW.OW.tblListOptionsValues
 UNION SELECT 'tblKeywords' TableName, COUNT(*) xxx FROM OW.OW.tblKeywords
 UNION SELECT 'tblIntegers' TableName, COUNT(*) xxx FROM OW.OW.tblIntegers
 UNION SELECT 'tblGroupsUsers' TableName, COUNT(*) xxx FROM OW.OW.tblGroupsUsers
 UNION SELECT 'tblGroupsEntities' TableName, COUNT(*) xxx FROM OW.OW.tblGroupsEntities
 UNION SELECT 'tblGroups' TableName, COUNT(*) xxx FROM OW.OW.tblGroups
 UNION SELECT 'tblFormFieldsType' TableName, COUNT(*) xxx FROM OW.OW.tblFormFieldsType
 UNION SELECT 'tblFormFieldsBooks' TableName, COUNT(*) xxx FROM OW.OW.tblFormFieldsBooks
 UNION SELECT 'tblFormFields' TableName, COUNT(*) xxx FROM OW.OW.tblFormFields
 UNION SELECT 'tblFlowUserAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblFlowUserAccesses
 UNION SELECT 'tblFlowStages' TableName, COUNT(*) xxx FROM OW.OW.tblFlowStages
 UNION SELECT 'tblFlowGroupAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblFlowGroupAccesses
 UNION SELECT 'tblFlowAlarms' TableName, COUNT(*) xxx FROM OW.OW.tblFlowAlarms
 UNION SELECT 'tblFlowAlarmAddressees' TableName, COUNT(*) xxx FROM OW.OW.tblFlowAlarmAddressees
 UNION SELECT 'tblFlow' TableName, COUNT(*) xxx FROM OW.OW.tblFlow
 UNION SELECT 'tblFloats' TableName, COUNT(*) xxx FROM OW.OW.tblFloats
 UNION SELECT 'tblFileManager' TableName, COUNT(*) xxx FROM OW.OW.tblFileManager
 UNION SELECT 'tblFieldsBooksPosition' TableName, COUNT(*) xxx FROM OW.OW.tblFieldsBooksPosition
 UNION SELECT 'tblFieldsBookConfig' TableName, COUNT(*) xxx FROM OW.OW.tblFieldsBookConfig
 UNION SELECT 'tblFields' TableName, COUNT(*) xxx FROM OW.OW.tblFields
 UNION SELECT 'tblEntityListAccess' TableName, COUNT(*) xxx FROM OW.OW.tblEntityListAccess
 UNION SELECT 'tblEntityList' TableName, COUNT(*) xxx FROM OW.OW.tblEntityList
 UNION SELECT 'tblEntitiesTMP' TableName, COUNT(*) xxx FROM OW.OW.tblEntitiesTMP
 UNION SELECT 'tblEntitiesTemp' TableName, COUNT(*) xxx FROM OW.OW.tblEntitiesTemp
 UNION SELECT 'tblEntities' TableName, COUNT(*) xxx FROM OW.OW.tblEntities
 UNION SELECT 'tblElectronicMailUsers' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMailUsers
 UNION SELECT 'tblElectronicMailDocuments' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMailDocuments
 UNION SELECT 'tblElectronicMailDestinations' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMailDestinations
 UNION SELECT 'tblElectronicMail' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMail
 UNION SELECT 'tblDocumentType' TableName, COUNT(*) xxx FROM OW.OW.tblDocumentType
 UNION SELECT 'tblDistrictTMP' TableName, COUNT(*) xxx FROM OW.OW.tblDistrictTMP
 UNION SELECT 'tblDistrict' TableName, COUNT(*) xxx FROM OW.OW.tblDistrict
 UNION SELECT 'tblDistributionType' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionType
 UNION SELECT 'tblDistributionEntities' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionEntities
 UNION SELECT 'tblDistributionCode' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionCode
 UNION SELECT 'tblDistributionAutomaticEntities' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionAutomaticEntities
 UNION SELECT 'tblDistributionAutomaticDestinations' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionAutomaticDestinations
 UNION SELECT 'tblDistributionAutomatic' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionAutomatic
 UNION SELECT 'tblDistribTemp' TableName, COUNT(*) xxx FROM OW.OW.tblDistribTemp
 UNION SELECT 'tblDispatchBook' TableName, COUNT(*) xxx FROM OW.OW.tblDispatchBook
 UNION SELECT 'tblDispatch' TableName, COUNT(*) xxx FROM OW.OW.tblDispatch
 UNION SELECT 'tblDateTimes' TableName, COUNT(*) xxx FROM OW.OW.tblDateTimes
 UNION SELECT 'tblDates' TableName, COUNT(*) xxx FROM OW.OW.tblDates
 UNION SELECT 'tblCountryTMP' TableName, COUNT(*) xxx FROM OW.OW.tblCountryTMP
 UNION SELECT 'tblCountry' TableName, COUNT(*) xxx FROM OW.OW.tblCountry
 UNION SELECT 'tblClassificationBooks' TableName, COUNT(*) xxx FROM OW.OW.tblClassificationBooks
 UNION SELECT 'tblClassification' TableName, COUNT(*) xxx FROM OW.OW.tblClassification
 UNION SELECT 'tblBooksKeyword' TableName, COUNT(*) xxx FROM OW.OW.tblBooksKeyword
 UNION SELECT 'tblBooksDocumentType' TableName, COUNT(*) xxx FROM OW.OW.tblBooksDocumentType
 UNION SELECT 'tblBooks' TableName, COUNT(*) xxx FROM OW.OW.tblBooks
 UNION SELECT 'IDlistaCodigoTMP' TableName, COUNT(*) xxx FROM OW.OW.IDlistaCodigoTMP
 UNION SELECT 'tblAccess' TableName, COUNT(*) xxx FROM OW.OW.tblAccess
 UNION SELECT 'tblAccessReg' TableName, COUNT(*) xxx FROM OW.OW.tblAccessReg
 UNION SELECT 'tblAlarm' TableName, COUNT(*) xxx FROM OW.OW.tblAlarm
 UNION SELECT 'tblAlarmAssociation' TableName, COUNT(*) xxx FROM OW.OW.tblAlarmAssociation
 UNION SELECT 'tblAlarms' TableName, COUNT(*) xxx FROM OW.OW.tblAlarms
 UNION SELECT 'tblAlerts' TableName, COUNT(*) xxx FROM OW.OW.tblAlerts
 UNION SELECT 'tblBooks' TableName, COUNT(*) xxx FROM OW.OW.tblBooks
 UNION SELECT 'tblBooksDocumentType' TableName, COUNT(*) xxx FROM OW.OW.tblBooksDocumentType
 UNION SELECT 'tblBooksKeyword' TableName, COUNT(*) xxx FROM OW.OW.tblBooksKeyword
 UNION SELECT 'tblClassification' TableName, COUNT(*) xxx FROM OW.OW.tblClassification
 UNION SELECT 'tblClassificationBooks' TableName, COUNT(*) xxx FROM OW.OW.tblClassificationBooks
 UNION SELECT 'tblCountry' TableName, COUNT(*) xxx FROM OW.OW.tblCountry
 UNION SELECT 'tblCountryTMP' TableName, COUNT(*) xxx FROM OW.OW.tblCountryTMP
 UNION SELECT 'tblDates' TableName, COUNT(*) xxx FROM OW.OW.tblDates
 UNION SELECT 'tblDateTimes' TableName, COUNT(*) xxx FROM OW.OW.tblDateTimes
 UNION SELECT 'tblDispatch' TableName, COUNT(*) xxx FROM OW.OW.tblDispatch
 UNION SELECT 'tblDispatchBook' TableName, COUNT(*) xxx FROM OW.OW.tblDispatchBook
 UNION SELECT 'tblDistribTemp' TableName, COUNT(*) xxx FROM OW.OW.tblDistribTemp
 UNION SELECT 'tblDistributionAutomatic' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionAutomatic
 UNION SELECT 'tblDistributionAutomaticDestinations' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionAutomaticDestinations
 UNION SELECT 'tblDistributionAutomaticEntities' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionAutomaticEntities
 UNION SELECT 'tblDistributionCode' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionCode
 UNION SELECT 'tblDistributionEntities' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionEntities
 UNION SELECT 'tblDistributionType' TableName, COUNT(*) xxx FROM OW.OW.tblDistributionType
 UNION SELECT 'tblDistrict' TableName, COUNT(*) xxx FROM OW.OW.tblDistrict
 UNION SELECT 'tblDistrictTMP' TableName, COUNT(*) xxx FROM OW.OW.tblDistrictTMP
 UNION SELECT 'tblDocumentType' TableName, COUNT(*) xxx FROM OW.OW.tblDocumentType
 UNION SELECT 'tblElectronicMail' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMail
 UNION SELECT 'tblElectronicMailDestinations' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMailDestinations
 UNION SELECT 'tblElectronicMailDocuments' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMailDocuments
 UNION SELECT 'tblElectronicMailUsers' TableName, COUNT(*) xxx FROM OW.OW.tblElectronicMailUsers
 UNION SELECT 'tblEntities' TableName, COUNT(*) xxx FROM OW.OW.tblEntities
 UNION SELECT 'tblEntitiesTemp' TableName, COUNT(*) xxx FROM OW.OW.tblEntitiesTemp
 UNION SELECT 'tblEntitiesTMP' TableName, COUNT(*) xxx FROM OW.OW.tblEntitiesTMP
 UNION SELECT 'tblEntityList' TableName, COUNT(*) xxx FROM OW.OW.tblEntityList
 UNION SELECT 'tblEntityListAccess' TableName, COUNT(*) xxx FROM OW.OW.tblEntityListAccess
 UNION SELECT 'tblFields' TableName, COUNT(*) xxx FROM OW.OW.tblFields
 UNION SELECT 'tblFieldsBookConfig' TableName, COUNT(*) xxx FROM OW.OW.tblFieldsBookConfig
 UNION SELECT 'tblFieldsBooksPosition' TableName, COUNT(*) xxx FROM OW.OW.tblFieldsBooksPosition
 UNION SELECT 'tblFileManager' TableName, COUNT(*) xxx FROM OW.OW.tblFileManager
 UNION SELECT 'tblFloats' TableName, COUNT(*) xxx FROM OW.OW.tblFloats
 UNION SELECT 'tblFlow' TableName, COUNT(*) xxx FROM OW.OW.tblFlow
 UNION SELECT 'tblFlowAlarmAddressees' TableName, COUNT(*) xxx FROM OW.OW.tblFlowAlarmAddressees
 UNION SELECT 'tblFlowAlarms' TableName, COUNT(*) xxx FROM OW.OW.tblFlowAlarms
 UNION SELECT 'tblFlowGroupAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblFlowGroupAccesses
 UNION SELECT 'tblFlowStages' TableName, COUNT(*) xxx FROM OW.OW.tblFlowStages
 UNION SELECT 'tblFlowUserAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblFlowUserAccesses
 UNION SELECT 'tblFormFields' TableName, COUNT(*) xxx FROM OW.OW.tblFormFields
 UNION SELECT 'tblFormFieldsBooks' TableName, COUNT(*) xxx FROM OW.OW.tblFormFieldsBooks
 UNION SELECT 'tblFormFieldsType' TableName, COUNT(*) xxx FROM OW.OW.tblFormFieldsType
 UNION SELECT 'tblGroups' TableName, COUNT(*) xxx FROM OW.OW.tblGroups
 UNION SELECT 'tblGroupsEntities' TableName, COUNT(*) xxx FROM OW.OW.tblGroupsEntities
 UNION SELECT 'tblGroupsUsers' TableName, COUNT(*) xxx FROM OW.OW.tblGroupsUsers
 UNION SELECT 'tblIntegers' TableName, COUNT(*) xxx FROM OW.OW.tblIntegers
 UNION SELECT 'tblKeywords' TableName, COUNT(*) xxx FROM OW.OW.tblKeywords
 UNION SELECT 'tblListOptionsValues' TableName, COUNT(*) xxx FROM OW.OW.tblListOptionsValues
 UNION SELECT 'tblListValues' TableName, COUNT(*) xxx FROM OW.OW.tblListValues
 UNION SELECT 'tblNonWorkingDays' TableName, COUNT(*) xxx FROM OW.OW.tblNonWorkingDays
 UNION SELECT 'tblNonWorkingHours' TableName, COUNT(*) xxx FROM OW.OW.tblNonWorkingHours
 UNION SELECT 'tblPostalCode' TableName, COUNT(*) xxx FROM OW.OW.tblPostalCode
 UNION SELECT 'tblPostalCodeTMP' TableName, COUNT(*) xxx FROM OW.OW.tblPostalCodeTMP
 UNION SELECT 'tblProcess' TableName, COUNT(*) xxx FROM OW.OW.tblProcess
 UNION SELECT 'tblProcessAlarmAddressees' TableName, COUNT(*) xxx FROM OW.OW.tblProcessAlarmAddressees
 UNION SELECT 'tblProcessAlarms' TableName, COUNT(*) xxx FROM OW.OW.tblProcessAlarms
 UNION SELECT 'tblProcessDocuments' TableName, COUNT(*) xxx FROM OW.OW.tblProcessDocuments
 UNION SELECT 'tblProcessGroupAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblProcessGroupAccesses
 UNION SELECT 'tblProcessStages' TableName, COUNT(*) xxx FROM OW.OW.tblProcessStages
 UNION SELECT 'tblProcessUserAccesses' TableName, COUNT(*) xxx FROM OW.OW.tblProcessUserAccesses
 UNION SELECT 'tblProduct' TableName, COUNT(*) xxx FROM OW.OW.tblProduct
 UNION SELECT 'tblProfiles' TableName, COUNT(*) xxx FROM OW.OW.tblProfiles
 UNION SELECT 'tblProfilesFields' TableName, COUNT(*) xxx FROM OW.OW.tblProfilesFields
 UNION SELECT 'tblRegistry' TableName, COUNT(*) xxx FROM OW.OW.tblRegistry
 UNION SELECT 'tblRegistryDistribution' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryDistribution
 UNION SELECT 'tblRegistryDocuments' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryDocuments
 UNION SELECT 'tblRegistryEntities' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryEntities
 UNION SELECT 'tblRegistryHist' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryHist
 UNION SELECT 'tblRegistryKeywords' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryKeywords
 UNION SELECT 'tblRegistryLists' TableName, COUNT(*) xxx FROM OW.OW.tblRegistryLists
 UNION SELECT 'tblState' TableName, COUNT(*) xxx FROM OW.OW.tblState
order by xxx






-- ****************** Relatório de conversão ******************************************************************************

tblOWWorkFlowDistribution		3 (?????)



tblRegistryDistribution	56816(OK)
tblRegistryEntities	3(OK)
tblAccessReg		1(OK)
tblDistributionEntities	14 (OK)
tblRegistryDocuments	121363 (OK)
tblRegistryHist		115375(OK)
tblRegistry		20667(OK)
tblDistributionType	5 (OK) 
tblFileManager		120979(OK)
tblDispatch		5(OK)
tblProfiles		6(OK)
tblProfilesFields	16(OK)
tblEntityListAccess	4(OK)
tblDocumentType		14(OK)
tblFieldsBookConfig	2(OK)
tblClassificationBooks	19(OK)
tblBooksDocumentType	109(OK)
tblFormFieldsBooks	169(OK)
tblFieldsBooksPosition	413(OK)
tblEntityList		2(OK)
tblDistrict		38(OK)
tblBooks		48(OK)
tblUser			115(OK)
tblCountry		254(OK)
tblAccess		670(OK)
tblEntities		4828(OK)
tblPostalCode		8441(OK)
tblClassification	22435(OK)
tblFormFields		22(OK) ( Tabela apenas com os campos fixos ) NOTA: Migrado na mesma


tblDistributionCode	5 ( Tabela fixa )
tblFields		19( Tabela fixa )
tblVersion		1( Ñ Aplicavel)
tblNonWorkingDays	2( Usar a tabela de destino )
tblNonWorkingHours	3( Usar a tabela de destino )
tblProduct		4( Tabela fixa )
tblFormFieldsType	6( Tabela fixa )
tblState		6( Tabela fixa )
tblUserPersistence	16( Ñ Aplicavel )
tblPostalCodeTMP	4147(AUX)
IDlistaCodigoTMP	4382(AUX)
tblEntitiesTMP		4382(AUX)
tblCountryTMP		209(AUX)
tblDistrictTMP		29(AUX)
tblDistribTemp		3(AUX)


*/
