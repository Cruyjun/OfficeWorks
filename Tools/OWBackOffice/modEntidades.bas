Attribute VB_Name = "modEntidades"
Option Explicit

Public Const kTITULO_MSG_ENT = " - Entidades"
Public Const kLOG_FILE_AED = "EntDuplicadas"
Public Const kLOG_FILE_DEI = "EntIdenticas"
Public Const kLOG_FILE_ENR = "EntNaoReferenciadas"
Public Const kLOG_FILE_ACE = "NovoCodigoEnt"
Public Const kLOGFILE_EXT = ".Log"
Public Const kAED = "AED"
Public Const kNUM_LINHAS_LISTVIEW_AED = 15
Public Const kDEI = "DEI"
Public Const kNUM_LINHAS_LISTVIEW_DEI = 6
Public Const kENR = "ENR"
Public Const kNUM_LINHAS_LISTVIEW_ENR = 15
Public Const kACE = "ACE"
Public Const kUPDATE_MANUAL = "M"
Public Const kUPDATE_AUTO = "A"
Public Const kDEL_TODAS = "T"
Public Const kDEL_SELECCIONADAS = "S"
Public Const kENT_PRINCIPAL = "[P]"
Public Const kENT_IDENTICA = "[I]"

Public Const kSIZE_LISTVIEW_COL1 = 300
Public Const kSIZE_LISTVIEW_COL2 = 1000
Public Const kSIZE_LISTVIEW_COL3 = 5920
Public Const kSIZE_LISTVIEW_SCROLL = 240

Public Const kERROR_NONE = 0
Public Const kERROR_INICIAL = -1

Public Const kENTITY_FULLNAME = "(RTRIM(LTRIM(Replace(ISNULL(FirstName,'') + ' ' + ISNULL(MiddleName,'') + ' ' + ISNULL(LastName,''),'  ',' '))) COLLATE SQL_Latin1_General_CP1_CI_AI)"
Public Const kUPDATE_TABLES_ORDER = "- tblRegistry - tblRegistryHist - tblRegistryEntities" & vbNewLine & "- tblDistributionEntities - tblDistributionAutomaticEntities" & vbNewLine & "- tblEntitiesTemp - tblEntities"

Public Const kLOG_SEPARATOR_01 = "************************************************************"
Public Const kLOG_SEPARATOR_02 = "------------------------------------------------------------"

Public Const kMAX_ENT_DELETE = 100
Public Const kMAX_ENT_ON_PAGE = 10000

Public lPageNumber As Long
Public lTotalPages As Long
Public lNumTotalEnt As Long


Public Type sENTITIES_DATA
    lEntId As Long
    sEntName As String
    lEntGroup As Long
End Type

Public Type sENTITIES_DATA_ALL
    sFullName As String
    lID As Long
    sFirstName As String
    sMiddleName As String
    sLastName As String
    sListID As String
    sBI As String
    sNumContribuinte As String
    sAssociateNum As String
    seMail As String
    sJobTitle As String
    sStreet As String
    sPostalCodeID As String
    sCountryID As String
    sPhone As String
    sFax As String
    sMobile As String
    sDistrictID As String
    sEntityID As String
    iActive As Integer
    sCreatedBy As String
    sCreatedDate As String
    sModifiedBy As String
    sModifiedDate As String
    iType As Integer
End Type

Public sEntities() As sENTITIES_DATA
Public stEntityAll As sENTITIES_DATA_ALL
Public lIdxSel() As Long
Public sInfoEntName As String
Public lEntitieUpdAED As Long
Public lEntitieNotUpdAED As Long
Public lEntitieUpdDEI As Long
Public lEntitieNotUpdDEI As Long
Public sLogLine As String
Public sLogFilePathAED As String
Public sLogFilePathDEI As String
Public sLogFilePathENR As String
Public sLogFilePathACE As String


Public Function GetDBVersion() As String
    Dim sSql As String
    Dim sErro As String
    
    On Error GoTo erro
    
    sErro = ""
    GetDBVersion = ""
    ''Get database version
    sSql = ""
    sSql = sSql & "SELECT Version "
    sSql = sSql & "FROM OW.tblVersion "
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    If Not objRs.EOF Then
        GetDBVersion = "" & objRs!Version
    End If
    objRs.Close
    Set objRs = Nothing
    Exit Function

erro:
    sErro = "Não foi possível obter a versão da Base de Dados do OfficeWorks!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Function


Public Function VerifyDBVersionX(sVersion As String) As Boolean
    Dim sMajor As String
    Dim sMinor As String
    Dim sRevision As String
    Dim iPos As Integer
    Dim iTamTotal As Integer
    Dim sVersionAux As String
    Dim sVersionAux1 As String
    
    VerifyDBVersionX = False
    If Trim(sVersion) = "" Then Exit Function
    ''Major
    iPos = InStr(1, sVersion, ".")
    iTamTotal = Len(sVersion)
    sVersionAux = Mid(sVersion, iPos + 1)
    sMajor = Left(sVersion, iTamTotal - Len(sVersionAux) - 1)
    If CInt(sMajor) <> kDB_MAJOR_VERSION Then
        Exit Function
    End If
    ''Minor
    iPos = InStr(1, sVersionAux, ".")
    iTamTotal = Len(sVersionAux)
    sVersionAux1 = Mid(sVersionAux, iPos + 1)
    sMinor = Left(sVersionAux, iTamTotal - Len(sVersionAux1) - 1)
    If CInt(sMinor) <> kDB_MINOR_VERSION Then
        Exit Function
    End If
    ''Revision
    sRevision = sVersionAux1
    If CInt(sRevision) < kDB_REVISION_VERSION Then
        Exit Function
    End If
    VerifyDBVersionX = True
End Function

Public Function VerifyDBVersion(sVersion As String) As Boolean
    Dim sMajor As String
    Dim sMinor As String
    Dim sRevision As String
    Dim iPos As Integer
    Dim iTamTotal As Integer
    Dim sVersionAux As String
    Dim sVersionAux1 As String
    
    VerifyDBVersion = False
    If Trim(sVersion) = "" Then Exit Function
    ''Major
    iPos = InStr(1, sVersion, ".")
    iTamTotal = Len(sVersion)
    sVersionAux = Mid(sVersion, iPos + 1)
    sMajor = Left(sVersion, iTamTotal - Len(sVersionAux) - 1)
    If CInt(sMajor) > kDB_MAJOR_VERSION Then
        Exit Function
    End If
    ''Minor
    iPos = InStr(1, sVersionAux, ".")
    iTamTotal = Len(sVersionAux)
    sVersionAux1 = Mid(sVersionAux, iPos + 1)
    sMinor = Left(sVersionAux, iTamTotal - Len(sVersionAux1) - 1)
    If CInt(sMinor) > kDB_MINOR_VERSION Then
        Exit Function
    End If
    ''Revision
    sRevision = sVersionAux1
    If CInt(sRevision) < kDB_REVISION_VERSION Then
        Exit Function
    End If
    VerifyDBVersion = True
End Function


Public Function IsOfficeWorksUser() As Boolean
    Dim sSql As String
    Dim sErro As String
    
    IsOfficeWorksUser = False
    sErro = ""
    ''Clear user info
    stUserInfo.lOfficeWorksID = -1
    stUserInfo.sOfficeWorksLogin = ""
    stUserInfo.sOfficeWorksDesc = ""
    ''Get user information
    sSql = ""
    sSql = sSql & "SELECT userID,userLogin,userDesc,userActive "
    sSql = sSql & "FROM OW.tblUser "
    sSql = sSql & "WHERE userLogin = '" & sUserLogin & "' "
    sSql = sSql & "AND userActive = 1"
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    If Not objRs.EOF Then
        IsOfficeWorksUser = True
        stUserInfo.lOfficeWorksID = objRs!userID
        stUserInfo.sOfficeWorksLogin = "" & objRs!userLogin
        stUserInfo.sOfficeWorksDesc = "" & objRs!userDesc
    End If
    objRs.Close
    Set objRs = Nothing
    Exit Function

erro:
    sErro = "Não foi possível obter infromação do utilizador no OfficeWorks!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Function


Public Function ConstroiSQLEnts(sTipo As String, bLimitRecords As Boolean, Optional sFilter As String) As String
    Dim sSql As String
    Dim sTopRecords As String
        
    On Error GoTo erroConstroiSQLEnts
    
    Select Case sTipo
    Case kAED
        sTopRecords = IIf(bLimitRecords, "TOP " & kMAX_ENT_ON_PAGE, "")
        sSql = ""
        sSql = sSql & "SELECT " & sTopRecords & " EntId, " & kENTITY_FULLNAME & " AS FullName "
        sSql = sSql & "FROM OW.tblEntities "
        sSql = sSql & "WHERE " & kENTITY_FULLNAME & " in "
        sSql = sSql & "(SELECT " & kENTITY_FULLNAME & " FROM OW.tblEntities GROUP BY " & kENTITY_FULLNAME & " HAVING COUNT(" & kENTITY_FULLNAME & ")>1) "
        sSql = sSql & "ORDER BY " & kENTITY_FULLNAME & " Asc "
    Case kDEI
        sSql = ""
        sSql = sSql & "SELECT * FROM ("
        If ((kMAX_ENT_ON_PAGE * lPageNumber) <= lNumTotalEnt) Then
            sSql = sSql & "SELECT TOP " & kMAX_ENT_ON_PAGE & " * FROM ("
        Else
            sSql = sSql & "SELECT TOP " & lNumTotalEnt - (kMAX_ENT_ON_PAGE * (lPageNumber - 1)) & " * FROM ("
        End If
        sSql = sSql & "SELECT TOP " & (kMAX_ENT_ON_PAGE * lPageNumber) & " EntId, " & kENTITY_FULLNAME & " AS FullName "
        sSql = sSql & "FROM OW.tblEntities "
        
        If (sFilter <> "" And (Left(sDBVersion, 1) = "5")) Then
            sSql = sSql & " WHERE Name like '%" & sFilter & "%'"
        End If

        sSql = sSql & "ORDER BY " & kENTITY_FULLNAME & " Asc "
        sSql = sSql & ") AS T1 ORDER BY FULLNAME DESC "
        sSql = sSql & ") AS T2 ORDER BY FULLNAME ASC "
    Case kENR
        sTopRecords = IIf(bLimitRecords, "TOP " & kMAX_ENT_ON_PAGE, "")
        sSql = ""
        sSql = sSql & "SELECT DISTINCT " & sTopRecords & " EntId, " & kENTITY_FULLNAME & " AS FullName "
        sSql = sSql & "FROM OW.tblentities "
        sSql = sSql & "WHERE EntId NOT IN "
        sSql = sSql & "("
        sSql = sSql & "SELECT distinct EntId FROM OW.tblRegistry WHERE EntId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblRegistryHist WHERE EntId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblRegistryEntities WHERE EntId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblDistributionEntities WHERE EntId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblDistributionAutomaticEntities WHERE EntId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblEntitiesTemp WHERE EntId IS NOT NULL AND ISNUMERIC(EntId) = 1 "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblGroupsEntities WHERE EntId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntId FROM OW.tblGroupsEntities WHERE ObjectId IS NOT NULL "
        sSql = sSql & "UNION "
        sSql = sSql & "SELECT distinct EntityId FROM OW.tblEntities WHERE EntityId IS NOT NULL "
        sSql = sSql & ")"
        sSql = sSql & " ORDER BY " & kENTITY_FULLNAME & " Asc "
    Case Else
    End Select
    
    ConstroiSQLEnts = sSql
    
    Exit Function
    
erroConstroiSQLEnts:
    MsgBox "Erro ao construir o SQL das entidades!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Err.Clear
End Function


Public Sub GetTotalOfEntities()
    Dim sSql As String
    Dim sErro As String
    
    On Error GoTo erro
    
    sErro = ""
    lNumTotalEnt = 0
    sSql = ""
    sSql = sSql & "SELECT COUNT(EntId) AS TOTALENTS "
    sSql = sSql & "FROM OW.tblEntities"
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    If Not objRs.EOF Then
        lNumTotalEnt = objRs!TOTALENTS
    End If
    objRs.Close
    Set objRs = Nothing
    Exit Sub

erro:
    sErro = "Não foi possível obter o total de Entidades do OfficeWorks!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Sub


Public Sub PreencheListEnts(sTipo As String, oList As ListView, oLabel As Label, sErro As String)
    Dim sSql As String
    Dim li As Long
    Dim lGroup As Long
    Dim sAux As String
    Dim oListItem As ListItem
    Dim iNumLinhasList As Integer
        
    On Error GoTo erroPreencheListEnts
    
    sErro = ""
    Select Case sTipo
    Case kAED
        iNumLinhasList = kNUM_LINHAS_LISTVIEW_AED
    Case kDEI
        iNumLinhasList = kNUM_LINHAS_LISTVIEW_DEI
    Case kENR
        iNumLinhasList = kNUM_LINHAS_LISTVIEW_ENR
    Case Else
    End Select
        
    ''Constroi sql
    sSql = ConstroiSQLEnts(sTipo, False)
    
    DoEvents
    ''Get entities from DB
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    
    DoEvents
    oLabel.Caption = ""
    sAux = ""
    li = 0
    ReDim sEntities(li)
    lGroup = 0
    ''Clear old items
    oList.ListItems.Clear
    ''Para não preencher a lista com mais de 10000 entidades
    While (Not objRs.EOF And li < kMAX_ENT_ON_PAGE)
        ReDim Preserve sEntities(li)
        sEntities(li).lEntId = 0 & objRs!EntID
        sEntities(li).sEntName = "" & objRs!FullName
        If Trim(UCase(ConvertStringToLatin(sAux))) <> Trim(UCase(ConvertStringToLatin(sEntities(li).sEntName))) Then
            lGroup = lGroup + 1
        End If
        sEntities(li).lEntGroup = lGroup
        sAux = sEntities(li).sEntName
        If Not oListItem Is Nothing Then Set oListItem = Nothing
        Set oListItem = oList.ListItems.Add()
        oListItem.SubItems(1) = sEntities(li).lEntId
        oListItem.SubItems(2) = sEntities(li).sEntName
        objRs.MoveNext
        li = li + 1
    Wend
    oLabel.Caption = "Total: " & li & " / " & objRs.RecordCount
    ''Tamanho da coluna nome
    oList.ColumnHeaders(3).Width = kSIZE_LISTVIEW_COL3
    If objRs.RecordCount > iNumLinhasList Then
        oList.ColumnHeaders(3).Width = kSIZE_LISTVIEW_COL3 - kSIZE_LISTVIEW_SCROLL
    End If
    objRs.Close
    Set objRs = Nothing
    Exit Sub
    
erroPreencheListEnts:
    sErro = "Erro ao preencher a lista das entidades!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Sub


Public Sub PreencheListEntsIdenticas(oList As ListView, oLabel As Label, sErro As String, txtFilter As TextBox)
    Dim sSql As String
    Dim li As Long
    Dim lGroup As Long
    Dim sAux As String
    Dim oListItem As ListItem
    Dim iNumLinhasList As Integer
    Dim strFilename As String
        
    On Error GoTo erroPreencheListEntsIdenticas
    
    ''Get total of entities
    GetTotalOfEntities
    oLabel.Caption = lNumTotalEnt
    
    sErro = ""
    iNumLinhasList = kNUM_LINHAS_LISTVIEW_DEI

    ''Constroi sql
    sSql = ConstroiSQLEnts(kDEI, False, txtFilter.Text)

    DoEvents
    ''Get entities from DB
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    
    DoEvents
    oLabel.Caption = ""
    sAux = ""
    li = 0
    ReDim sEntities(li)
    lGroup = 0
    ''Clear old items
    oList.ListItems.Clear
    ''Para não preencher a lista com mais de 10000 entidades
    While (Not objRs.EOF And li < kMAX_ENT_ON_PAGE)
        ReDim Preserve sEntities(li)
        sEntities(li).lEntId = 0 & objRs!EntID
        sEntities(li).sEntName = "" & objRs!FullName
        If Trim(UCase(ConvertStringToLatin(sAux))) <> Trim(UCase(ConvertStringToLatin(sEntities(li).sEntName))) Then
            lGroup = lGroup + 1
        End If
        sEntities(li).lEntGroup = lGroup
        sAux = sEntities(li).sEntName
        If Not oListItem Is Nothing Then Set oListItem = Nothing
        Set oListItem = oList.ListItems.Add()
        oListItem.SubItems(1) = sEntities(li).lEntId
        oListItem.SubItems(2) = sEntities(li).sEntName
        objRs.MoveNext
        li = li + 1
    Wend
    objRs.Close
    Set objRs = Nothing

    ''Tamanho da coluna nome
    oList.ColumnHeaders(3).Width = kSIZE_LISTVIEW_COL3
    If lNumTotalEnt > iNumLinhasList Then
        oList.ColumnHeaders(3).Width = kSIZE_LISTVIEW_COL3 - kSIZE_LISTVIEW_SCROLL
    End If
    Exit Sub
    
erroPreencheListEntsIdenticas:
    sErro = "Erro ao preencher a lista das entidades!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Sub


Public Function CheckEntities(oList As ListView, oLabel As Label) As Boolean
    Dim lX As Long
    Dim sEntSel As String
    Dim sEntSelAux As String
    
    CheckEntities = False
    sEntSelAux = "[#$#]"
    For lX = 0 To oList.ListItems.Count - 1
        If oList.ListItems(lX + 1).Checked Then
            sEntSel = oList.ListItems(lX + 1).SubItems(2)
            If Trim(UCase(ConvertStringToLatin(sEntSel))) = Trim(UCase(ConvertStringToLatin(sEntSelAux))) Then
                MsgBox "Já existe essa opção para a entidade '" & sEntSel & "'!", vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
                oLabel.Caption = ""
                Exit Function
            End If
            sEntSelAux = oList.ListItems(lX + 1).SubItems(2)
        End If
    Next
    CheckEntities = True
    oLabel.Caption = ""
End Function


Public Sub ConstroiStringAndUpdate(lEntId As Long, lEntGroup As Long, sEnt As String, oList As ListView)
    Dim lX As Long
    Dim sAux As String
    Dim sErro As String
    Dim lResult As Long
    
    On Error GoTo erroConstroiStringUpdate
    
    DoEvents
    sErro = "Obter ids para o SQL"
    sAux = "("
    For lX = 0 To oList.ListItems.Count - 1
        If sEntities(lX).lEntGroup = lEntGroup Then
            If sEntities(lX).lEntId <> lEntId Then
                sLogLine = sLogLine & "[" & sEntities(lX).lEntId & "]" & " " & sEntities(lX).sEntName
                WriteInLogFile sLogLine
                sAux = sAux & sEntities(lX).lEntId & ","
            End If
        End If
    Next
    sAux = sAux & ")"
    sAux = Replace(sAux, ",)", ")")
    sErro = ""
    If Len(sAux) > 2 Then
        ''Inicio da transação
        objCnn.BeginTrans
        lResult = UpdateEntitiesOnDB(lEntId, sEnt, sAux, lEntitieUpdAED, lEntitieNotUpdAED)
        ''Fim da transação
        If lResult = kERROR_NONE Then
            objCnn.CommitTrans
        Else
            objCnn.RollbackTrans
        End If
    End If
    Exit Sub
    
erroConstroiStringUpdate:
    sLogLine = vbNewLine & "Erro ao obter Ids das entidades duplicadas! (" & sErro & ")" & vbNewLine & "(Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")"
    WriteInLogFile sLogLine
    Err.Clear
End Sub


Public Sub GetEntityFromDB(lEntId As Long, sEntName As String, bEntExist As Boolean, sErro As String)
    Dim sSql As String
    Dim stEntityNew As sENTITIES_DATA_ALL
    
    On Error GoTo erroGetEntityFromDB
    
    sErro = ""
    bEntExist = False
    stEntityAll = stEntityNew
    sSql = ""
    sSql = sSql & "SELECT EntID, FirstName, MiddleName, LastName, "
    sSql = sSql & "ListID, BI, NumContribuinte, AssociateNum, "
    sSql = sSql & "eMail, JobTitle, Street, PostalCodeID, CountryID, "
    sSql = sSql & "Phone, Fax, Mobile, DistrictID, EntityID, Active, "
    
    Dim sDBVersion As String
    sDBVersion = GetDBVersion
    
    If (Left(sDBVersion, 1) = "4") Then
    sSql = sSql & "CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, "
    Else
    sSql = sSql & "InsertedBy, InsertedOn,LastModifiedBy,LastModifiedOn, "
    End If
    sSql = sSql & "Type, " & kENTITY_FULLNAME & " AS FullName "
    sSql = sSql & "FROM OW.tblEntities "
    sSql = sSql & " WHERE EntID = " & lEntId
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    If Not objRs.EOF Then
        bEntExist = True
        sEntName = "" & objRs!FullName
        stEntityNew.sFullName = sEntName
        stEntityNew.lID = objRs!EntID
        stEntityNew.sFirstName = IIf(IsNull(objRs!FirstName), "NULL", objRs!FirstName)
        stEntityNew.sMiddleName = IIf(IsNull(objRs!MiddleName), "NULL", objRs!MiddleName)
        stEntityNew.sLastName = IIf(IsNull(objRs!LastName), "NULL", objRs!LastName)
        stEntityNew.sListID = IIf(IsNull(objRs!ListID), "NULL", objRs!ListID)
        stEntityNew.sBI = IIf(IsNull(objRs!BI), "NULL", objRs!BI)
        stEntityNew.sNumContribuinte = IIf(IsNull(objRs!NumContribuinte), "NULL", objRs!NumContribuinte)
        stEntityNew.sAssociateNum = IIf(IsNull(objRs!AssociateNum), "NULL", objRs!AssociateNum)
        stEntityNew.seMail = IIf(IsNull(objRs!eMail), "NULL", objRs!eMail)
        stEntityNew.sJobTitle = IIf(IsNull(objRs!JobTitle), "NULL", objRs!JobTitle)
        stEntityNew.sStreet = IIf(IsNull(objRs!Street), "NULL", objRs!Street)
        stEntityNew.sPostalCodeID = IIf(IsNull(objRs!PostalCodeID), "NULL", objRs!PostalCodeID)
        stEntityNew.sCountryID = IIf(IsNull(objRs!countryID), "NULL", objRs!countryID)
        stEntityNew.sPhone = IIf(IsNull(objRs!Phone), "NULL", objRs!Phone)
        stEntityNew.sFax = IIf(IsNull(objRs!Fax), "NULL", objRs!Fax)
        stEntityNew.sMobile = IIf(IsNull(objRs!Mobile), "NULL", objRs!Mobile)
        stEntityNew.sDistrictID = IIf(IsNull(objRs!DistrictID), "NULL", objRs!DistrictID)
        stEntityNew.sEntityID = IIf(IsNull(objRs!EntityID), "NULL", objRs!EntityID)
        stEntityNew.iActive = IIf(objRs!Active, 1, 0)
        If (Left(sDBVersion, 1) = "4") Then
        stEntityNew.sCreatedBy = IIf(IsNull(objRs!CreatedBy), "NULL", objRs!CreatedBy)
        stEntityNew.sCreatedDate = IIf(IsNull(objRs!CreatedDate), "NULL", objRs!CreatedDate)
        stEntityNew.sModifiedBy = IIf(IsNull(objRs!ModifiedBy), "NULL", objRs!ModifiedBy)
        stEntityNew.sModifiedDate = IIf(IsNull(objRs!ModifiedDate), "NULL", objRs!ModifiedDate)
        Else
        stEntityNew.sCreatedBy = IIf(IsNull(objRs!InsertedBy), "NULL", objRs!InsertedBy)
        stEntityNew.sCreatedDate = IIf(IsNull(objRs!InsertedOn), "NULL", objRs!InsertedOn)
        stEntityNew.sModifiedBy = IIf(IsNull(objRs!LastModifiedBy), "NULL", objRs!LastModifiedBy)
        stEntityNew.sModifiedDate = IIf(IsNull(objRs!LastModifiedOn), "NULL", objRs!LastModifiedOn)
        End If
        
        stEntityNew.iType = objRs!Type
    End If
    objRs.Close
    Set objRs = Nothing
    stEntityAll = stEntityNew
    Exit Sub
    
erroGetEntityFromDB:
    sErro = "Não foi possível obter a entidade!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Sub


Public Sub VerifyEntityCodeOnDB(lCode As Long, bCodeExist As Boolean, sErro As String)
    Dim sSql As String
    
    On Error GoTo erroVerifyEntityCodeOnDB
    
    sErro = ""
    bCodeExist = False
    sSql = ""
    sSql = sSql & "SELECT EntId, " & kENTITY_FULLNAME & " AS FullName "
    sSql = sSql & "FROM OW.tblEntities "
    sSql = sSql & "WHERE EntID = " & lCode
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    If Not objRs.EOF Then
        bCodeExist = True
        sErro = "O código '" & lCode & "' já existe para a entidade '" & "" & objRs!FullName & "'!"
        MsgBox sErro, vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
    End If
    objRs.Close
    Set objRs = Nothing
    Exit Sub

erroVerifyEntityCodeOnDB:
    sErro = "Não foi possível verificar se o novo código já existe!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Sub


Public Function InsertEntityOnDB(lEntId As Long, sErro As String) As Long
    Dim sSql As String
    
    On Error GoTo erroInsertEntityOnDB
    
    InsertEntityOnDB = kERROR_INICIAL
    sErro = ""
    sSql = ""
    sSql = sSql & "SET IDENTITY_INSERT OW.tblEntities ON " & vbNewLine
    sSql = sSql & "INSERT INTO OW.tblEntities " & vbNewLine
    sSql = sSql & "("
    sSql = sSql & "EntID,FirstName,MiddleName,LastName,"
    sSql = sSql & "ListID,BI,NumContribuinte,AssociateNum,"
    sSql = sSql & "eMail,JobTitle,Street,PostalCodeID,CountryID,"
    sSql = sSql & "Phone,Fax,Mobile,DistrictID,EntityID,Active,"
    sSql = sSql & "CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Type"
    sSql = sSql & ") " & vbNewLine
    sSql = sSql & "VALUES "
    sSql = sSql & "("
    sSql = sSql & lEntId & ","
    sSql = sSql & IIf(stEntityAll.sFirstName <> "NULL", "'" & stEntityAll.sFirstName & "'", stEntityAll.sFirstName) & ","
    sSql = sSql & IIf(stEntityAll.sMiddleName <> "NULL", "'" & stEntityAll.sMiddleName & "'", stEntityAll.sMiddleName) & ","
    sSql = sSql & IIf(stEntityAll.sLastName <> "NULL", "'" & stEntityAll.sLastName & "'", stEntityAll.sLastName) & ","
    sSql = sSql & stEntityAll.sListID & ","
    sSql = sSql & stEntityAll.sBI & ","
    sSql = sSql & stEntityAll.sNumContribuinte & ","
    sSql = sSql & stEntityAll.sAssociateNum & ","
    sSql = sSql & IIf(stEntityAll.seMail <> "NULL", "'" & stEntityAll.seMail & "'", stEntityAll.seMail) & ","
    sSql = sSql & IIf(stEntityAll.sJobTitle <> "NULL", "'" & stEntityAll.sJobTitle & "'", stEntityAll.sJobTitle) & ","
    sSql = sSql & IIf(stEntityAll.sStreet <> "NULL", "'" & stEntityAll.sStreet & "'", stEntityAll.sStreet) & ","
    sSql = sSql & stEntityAll.sPostalCodeID & ","
    sSql = sSql & stEntityAll.sCountryID & ","
    sSql = sSql & IIf(stEntityAll.sPhone <> "NULL", "'" & stEntityAll.sPhone & "'", stEntityAll.sPhone) & ","
    sSql = sSql & IIf(stEntityAll.sFax <> "NULL", "'" & stEntityAll.sFax & "'", stEntityAll.sFax) & ","
    sSql = sSql & IIf(stEntityAll.sMobile <> "NULL", "'" & stEntityAll.sMobile & "'", stEntityAll.sMobile) & ","
    sSql = sSql & stEntityAll.sDistrictID & ","
    sSql = sSql & stEntityAll.sEntityID & ","
    sSql = sSql & stEntityAll.iActive & ","
    sSql = sSql & stEntityAll.sCreatedBy & ","
    sSql = sSql & IIf(stEntityAll.sCreatedDate <> "NULL", "'" & Format(stEntityAll.sCreatedDate, "yyyy-mm-dd") & "'", stEntityAll.sCreatedDate) & ","
    sSql = sSql & stUserInfo.lOfficeWorksID & ","
    sSql = sSql & "'" & Format(Date, "yyyy-mm-dd") & " " & Format(Time, "hh:mm:ss") & "'" & ","
    sSql = sSql & stEntityAll.iType
    sSql = sSql & ") " & vbNewLine
    sSql = sSql & "SET IDENTITY_INSERT OW.tblEntities OFF "
    objCnn.Execute sSql, , adCmdText
    InsertEntityOnDB = kERROR_NONE
    Exit Function
    
erroInsertEntityOnDB:
    sErro = "Não foi possível inserir a entidade com o código [" & lEntId & "]!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")"
    MsgBox sErro, vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    InsertEntityOnDB = Err.Number
    Err.Clear
End Function


Public Function UpdateEntitiesOnDB(lEntId As Long, sEnt As String, sAux As String, lEntitieUpd As Long, lEntitieNotUpd As Long) As Long
    Dim sSql As String
    Dim sErro As String
    
    On Error GoTo erroUpdateEntitiesOnDB
    
    UpdateEntitiesOnDB = kERROR_INICIAL
    ''Registo
    sErro = "Actualizar tabela 'OW.tblRegistry'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblRegistry SET EntID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Historico
    sErro = "Actualizar tabela 'OW.tblRegistryHist'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblRegistryHist SET EntID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Mais entidades
    sErro = "Actualizar tabela 'OW.tblRegistryEntities'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblRegistryEntities SET EntID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Distribuição
    sErro = "Actualizar tabela 'OW.tblDistributionEntities'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblDistributionEntities SET EntID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Distribuição Automatica
    sErro = "Actualizar tabela 'OW.tblDistributionAutomaticEntities'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblDistributionAutomaticEntities SET EntID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Entidades temporarias
    sErro = "Actualizar tabela 'OW.tblEntitiesTemp'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblEntitiesTemp SET EntID = " & lEntId & ", ContactID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Grupos Entidades (EntID)
    sErro = "Actualizar tabela 'OW.tblGroupsEntities' (EntID)"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblGroupsEntities SET EntID = " & lEntId
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Grupos Entidades (ObjectID)
    sErro = "Actualizar tabela 'OW.tblGroupsEntities' (ObjectID)"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblGroupsEntities SET ObjectID = " & lEntId
    sSql = sSql & " WHERE ObjectID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Campo EntityId na tabela entidades
    sErro = "Actualizar tabela 'OW.tblEntities'"
    sSql = ""
    sSql = sSql & "UPDATE OW.tblEntities SET EntityID = " & lEntId
    sSql = sSql & " WHERE EntityID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Entidades
    sErro = "Apagar entidades da tabela 'OW.tblEntities'"
    sSql = ""
    sSql = sSql & "DELETE OW.tblEntities "
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    ''Entidades duplicadas nos grupos
    UpdateDuplicateEntitiesOnGroupEntities sErro
    ''Actualizar o numero de entidades actualizadas
    lEntitieUpd = lEntitieUpd + 1
    UpdateEntitiesOnDB = kERROR_NONE
    Exit Function
    
erroUpdateEntitiesOnDB:
    lEntitieNotUpd = lEntitieNotUpd + 1
    sLogLine = sLogLine & vbNewLine & "Entidade [" & lEntId & "] '" & sEnt & "'não foi actualizada! (" & sErro & ")" & vbNewLine & "(Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")"
    WriteInLogFile sLogLine
    UpdateEntitiesOnDB = Err.Number
    Err.Clear
End Function


Public Function UpdateDuplicateEntitiesOnGroupEntities(sErro As String) As Long
    Dim sSql As String
    
    ''Apagar tabela temporaria
    sErro = "Entidades Duplicadas nos Grupos (Apagar tabela temporária 'OW.tblGroupsEntitiesDuplicateTemp')"
    sSql = ""
    sSql = sSql & "IF EXISTS (SELECT * FROM SYSOBJECTS WHERE xtype = 'u' AND name = 'tblGroupsEntitiesDuplicateTemp') "
    sSql = sSql & "DROP TABLE OW.tblGroupsEntitiesDuplicateTemp"
    objCnn.Execute sSql, , adCmdText
    ''Inserir linhas na tabela temporária
    sErro = "Entidades Duplicadas nos Grupos (Inserir linhas na tabela temporária 'OW.tblGroupsEntitiesDuplicateTemp')"
    sSql = ""
    sSql = sSql & "SELECT DISTINCT EntID,ObjectID INTO OW.tblGroupsEntitiesDuplicateTemp "
    sSql = sSql & "FROM OW.tblGroupsEntities "
    objCnn.Execute sSql, , adCmdText
    ''Apagar linhas da tabela grupos entidades
    sErro = "Entidades Duplicadas nos Grupos (Apagar linhas da tabela 'OW.tblGroupsEntities')"
    sSql = ""
    sSql = sSql & "DELETE OW.tblGroupsEntities "
    objCnn.Execute sSql, , adCmdText
    ''Inserir linhas da tabela temporária na tabela grupos entidades
    sErro = "Entidades Duplicadas nos Grupos (Inserir linhas da tabela 'OW.tblGroupsEntitiesDuplicateTemp' na tabela 'OW.tblGroupsEntities')"
    sSql = ""
    sSql = sSql & "INSERT INTO OW.tblGroupsEntities (EntID,ObjectID) "
    sSql = sSql & "(SELECT  EntID,ObjectID FROM OW.tblGroupsEntitiesDuplicateTemp)"
    objCnn.Execute sSql, , adCmdText
    ''Apagar tabela temporaria
    sErro = "Entidades Duplicadas nos Grupos (Apagar tabela temporária 'OW.tblGroupsEntitiesDuplicateTemp')"
    sSql = ""
    sSql = sSql & "IF EXISTS (SELECT * FROM SYSOBJECTS WHERE xtype = 'u' AND name = 'tblGroupsEntitiesDuplicateTemp') "
    sSql = sSql & "DROP TABLE OW.tblGroupsEntitiesDuplicateTemp"
    objCnn.Execute sSql, , adCmdText
    ''Apagar linhas da tabela para entidades sem referencia
    sErro = "Entidades Duplicadas nos Grupos (Apagar linhas da tabela 'OW.tblGroupsEntities' sem referencia na tabela 'OW.tblEntities')"
    sSql = ""
    sSql = sSql & "DELETE OW.tblGroupsEntities "
    sSql = sSql & "WHERE NOT EXISTS "
    sSql = sSql & "(SELECT EntID FROM OW.tblEntities WHERE OW.tblEntities.EntID = OW.tblGroupsEntities.ObjectID)"
    objCnn.Execute sSql, , adCmdText
End Function


Public Function DeleteEntitiesOnDB(sAux As String) As Long
    Dim sSql As String
    Dim sErro As String
    
    On Error GoTo erroDeleteEntitiesOnDB
    
    DeleteEntitiesOnDB = kERROR_INICIAL
    sErro = "Apagar entidades da tabela 'OW.tblEntities'"
    sSql = ""
    sSql = sSql & "DELETE OW.tblEntities "
    sSql = sSql & " WHERE EntID IN " & sAux
    objCnn.Execute sSql, , adCmdText
    DeleteEntitiesOnDB = kERROR_NONE
    Exit Function
    
erroDeleteEntitiesOnDB:
    sLogLine = sLogLine & "Não foi possível apagar a as entidades! (" & sErro & ")" & vbNewLine & "(Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")"
    WriteInLogFile sLogLine
    DeleteEntitiesOnDB = Err.Number
    Err.Clear
End Function


Public Sub UpdateEntityCodeOnDB(lEntIdOld As Long, lEntIdNew As Long, sErro As String)
    Dim sSql As String
    Dim lResult As Long
    
    sErro = ""
    ''Inicio da transação
    objCnn.BeginTrans
    ''Inserir novo codigo
    lResult = InsertEntityOnDB(lEntIdNew, sErro)
    If lResult = kERROR_NONE Then
        ''Actualizar codigo antigo para o novo e apagar codigo antigo
        lResult = UpdateEntitiesOnDB(lEntIdNew, "", "(" & lEntIdOld & ")", 0, 0)
        If lResult = kERROR_NONE Then
            ''commit
            objCnn.CommitTrans
            MsgBox "O código da entidade [" & lEntIdOld & "] foi alterado com sucesso!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        End If
    End If
    If lResult <> kERROR_NONE Then
        ''rollback
        objCnn.RollbackTrans
        If sErro = "" Then
            sErro = "Não foi possível alterar o código da entidade [" & lEntIdOld & "]!"
            MsgBox sErro, vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
        Else
            sErro = "Não foi possível alterar o código da entidade [" & lEntIdOld & "]!" & vbNewLine & sErro
        End If
    End If
End Sub


Public Sub ExportaListEnts(sTipo As String)
    Dim sErro As String
    Dim sSql As String
    Dim strFilename As String
    Dim exportError As Long
        
    On Error GoTo erroExportaListEnts
    
    sErro = ""
    Select Case sTipo
    Case kAED
        strFilename = "exportAED"
    Case kDEI
        strFilename = "exportDEI_Page_" & lPageNumber
    Case kENR
        strFilename = "exportENR"
    Case Else
    End Select
        
    ''Constroi sql
    sSql = ConstroiSQLEnts(sTipo, True)
    
    DoEvents
    ''Get entities from DB
    Set objRs = New ADODB.Recordset
    objRs.CursorType = adOpenStatic
    objRs.Open sSql, objCnn
    
    ''Exportar para excel
    exportError = ExportToExcel(objRs, strFilename)
    ''O Excel nao existe
    If exportError = 429 Then
        MsgBox "Não foi possível encontrar a aplicação Excel. O ficheiro será guardado no formato CSV."
        ''Exportar para CSV
        ExportToCSV objRs, strFilename
    End If
    
    objRs.Close
    Set objRs = Nothing
    Exit Sub
    
erroExportaListEnts:
    sErro = "Erro ao exportar a lista das entidades!"
    MsgBox sErro & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Set objRs = Nothing
    Err.Clear
End Sub


Public Function ExportToExcel(ByRef recordsetX As ADODB.Recordset, Optional strDefaultFilename As String) As Integer
    Dim i, j As Integer
    Dim sFieldName As String
    Dim strFilter As String
    Dim strFilename As String
    Dim createExcel As New Excel.Application
    Dim Wbook As Excel.Workbook
    Dim Wsheet As Excel.Worksheet
    
    On Error GoTo Err:
    
    strFilter = ahtAddFilterItem(strFilter, "Excel Files (*.xls)", "*.xls")
    strFilename = ahtCommonFileOpenSave(OpenFile:=False, Filter:=strFilter, Flags:=ahtOFN_OVERWRITEPROMPT Or ahtOFN_READONLY)
    
    If (strFilename = "") Then
        Exit Function
    End If
    
    i = 0
    j = 0
    Set Wbook = createExcel.Workbooks.Add
    Set Wsheet = Wbook.Worksheets.Add
    
    sFieldName = ""
    For i = 0 To recordsetX.Fields.Count - 1
        sFieldName = recordsetX.Fields(i).Name
        sFieldName = IIf(UCase(sFieldName) = "ENTID", "Código", IIf(UCase(sFieldName) = "FULLNAME", "Nome", sFieldName))
        Wsheet.Cells(1, i + 1).Value = sFieldName
    Next i
    
    If (recordsetX.RecordCount > 0) Then
        recordsetX.MoveFirst
         For i = 0 To recordsetX.RecordCount - 1
                For j = 0 To recordsetX.Fields.Count - 1
                        Wsheet.Cells(i + 2, j + 1).Value = recordsetX(j).Value
                Next j
        recordsetX.MoveNext
        Next i
    End If
    
    Application.DisplayAlerts = False
    Wbook.SaveAs strFilename
    Application.DisplayAlerts = True
    Wbook.Close True
    
    Set createExcel = Nothing
    Set Wbook = Nothing
    Set Wsheet = Nothing
    Set Wbook = createExcel.Workbooks.Open(strFilename)
    
    createExcel.Visible = True
    
    ExportToExcel = 0
    
    Exit Function

Err:
    ExportToExcel = Err.Number
    Select Case Err.Number
        Case 32755
            MsgBox "Press Cancel button"
        Case 1004
            MsgBox "File already open. OverWrite canceled."
            Wbook.Close False
        Case 429
        Case Else
             MsgBox Err.Number & " " & Err.Description
    End Select
 End Function
 
 
Public Function ExportToCSV(rsData As ADODB.Recordset, Optional strDefaultFilename As String, Optional showColumnNames As Boolean = True, Optional nullStr As String = "") As Integer
    Dim k As Long
    Dim sFieldName As String
    Dim csvData As String
    
    On Error GoTo Err:
    
    If showColumnNames Then
        For k = 0 To rsData.Fields.Count - 1
            sFieldName = rsData.Fields(k).Name
            sFieldName = IIf(UCase(sFieldName) = "ENTID", "Código", IIf(UCase(sFieldName) = "FULLNAME", "Nome", sFieldName))
            csvData = csvData & ",""" & sFieldName & """"
        Next k
        csvData = Mid(csvData, 2) & vbNewLine
    End If
    
    csvData = csvData & """" & rsData.GetString(adClipString, -1, """,""", """" & vbNewLine & """", nullStr)
    csvData = Left(csvData, Len(csvData) - 3)
    
    If (strDefaultFilename = "") Then
       strDefaultFilename = "exportResult"
    End If
    
    Open strDefaultFilename & ".csv" For Output As #1: Close #1
    Open strDefaultFilename & ".csv" For Binary Access Write As #1
    Put #1, , csvData
    Close #1
    
    ExportToCSV = 0
    
    Exit Function

Err:
    ExportToCSV = Err.Number
    MsgBox Err.Number & " " & Err.Description
End Function

