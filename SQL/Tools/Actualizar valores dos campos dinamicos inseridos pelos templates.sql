
-- Script para actualizar os valores dos campos dinamicos do tipo lista
-- Os valores foram inseridos pelos templates OWOffice na tabela tblStrings 
-- em vez de na tabela tblRegistryLists


-- Verificar valores que foram inseridos na tabela tblStrings pelos templates
-- relativos aos campos dinamicos do tipo lista
SELECT * FROM OW.tblStrings
WHERE FormFieldKey IN 
(SELECT FormFieldKey FROM OW.tblFormFields WHERE DynFldTypeID = 7)


-- Inserir valores na tabela tblRegistryLists
-- que foram inseridos na tabela tblStrings pelos templates
-- relativos aos campos dinamicos do tipo lista que sejam inteiros
-- NOTA: 
--	Verificar primeiro os valores a inserir 
--	Para executar o inserir descomentar a linha

--INSERT INTO OW.tblRegistryLists
SELECT * FROM OW.tblStrings
WHERE FormFieldKey IN 
(SELECT FormFieldKey FROM OW.tblFormFields WHERE DynFldTypeID = 7)
AND CHARINDEX(',',value) = 0


-- Apagar os valores da tabela tblStrings qm que o campo seja do tipo lista
-- NOTA: 
--	Verificar primeiro os valores a apagar
--	Para executar o apagar descomentar as duas linhas

--DELETE OW.tblStrings
--WHERE FormFieldKey IN 
(SELECT FormFieldKey FROM OW.tblFormFields WHERE DynFldTypeID = 7)




