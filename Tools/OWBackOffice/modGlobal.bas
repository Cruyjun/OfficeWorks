Attribute VB_Name = "modGlobal"
Option Explicit

Public objCnn As ADODB.Connection
Public objRs As ADODB.Recordset
Public objFS As FileSystemObject
Public oFS As FileSystemObject
Public otsFile As TextStream

Public sServerName As String
Public sDBName As String
Public sLogin As String
Public sPwd As String
Public lTimeout As Long
Public sDBVersion As String


Public Const kHOUR_SEC = 60 ^ 2
Public Const kMIN_SEC = 60
Public Const kTITULO_MSG = "OfficeWorks BackOffice"
Public Const kTITULO_MSGBOX = "OfficeWorks BackOffice"
Public Const kTITULO_MSG_SRV = " - Servidor"
Public Const kCAPTION_CONNECT = "&Ligar"
Public Const kCAPTION_DISCONNECT = "&Desligar"

Public Const kSERVER_OfficeWorks = "(LOCAL)"
Public Const kDATABASE_OfficeWorks = "OW"
Public Const kSQL_USER = "OW"
Public Const kSQL_PWD = "nicedoc"

Public Const kTEXT_PWD = "SQL_USER_PWD"
Public Const kBLANK_PWD = "BLANKPASS"
Public Const kTIMEOUT_CONNECTION = 30

Public Const kDB_VERSION = "5.x.x"
Public Const kDB_MAJOR_VERSION = 5
Public Const kDB_MINOR_VERSION = 8
Public Const kDB_REVISION_VERSION = 0

Public Const kOPT_DEFAULT = -1
Public Const kOPT_SERVER = 0
Public Const kOPT_AED = 1
Public Const kOPT_DEI = 2
Public Const kOPT_ENR = 3
Public Const kOPT_ACE = 4

Public Const kTO_UPPERCASE = "UPPER"
Public Const kTO_LOWERCASE = "LOWER"

'*********** Para Tratamento de Erros ***********************************
Global VBErr As New clsTrataErros
'Erro de Retorno
Global lRetError As Long
'Códigos de Erros
Global Const DivideByZeroError = 11
Global Const kERROR_SQL_N_BADLOGIN = 18456
Global Const kERROR_SQL_N_INVALIDOBJ = 208
Global Const kERROR_SQL_N_INVALIDOBJ2 = 1038
Global Const kERROR_SQL_N_DPK = 2627
Global Const kERROR_SQL_N_INVALIDSQLSERVER = 17
Global Const kERROR_SQL_N_DBNOTEXISTS = 3701
Global Const kERROR_SQL_INVALIDSQLSERVER = -2147467259
Global Const kERROR_SQL_DATABASEINUSE = -2147217803
Global Const kERROR_FILE_PERMISSIONDENIED = 70
Global Const kERROR_FILE_FILEORFOLDEREXIST = 58
Global Const kERROR_FILE_INVALIDCHARS = 52
Global Const kERROR_MAPI_E_NOT_FOUND = -2147221233
Global Const kERROR_MAPI_E_USER_CANCEL = -2147221229
Global Const kERROR_MAPI_INVALID_CONTACTID = -2147024809
Global Const kERROR_MAPI_INVALID_ENTRYID = -2147221241
Global Const kERROR_MAPI_LOGIN_FAILED = -2147221231
'Nomes ou ID's de configurações
Global Const kERRORCFG_CnnWithRollback = "CnnWithRollback"
Global Const kERRORCFG_CnnTestDatabase = "CnnTestDatabase"
Global Const kERRORCFG_CnnInsertDPK = "CnnInsertDPK"
Global Const kERRORCFG_FilePermission = "FilePermission"
Global Const kERRORCFG_ONSQLConnect = "ONSQLConnect"
'************************************************************************


'******** To Call the standard Windows File Open/Save dialog box ********
Type tagOPENFILENAME
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    strFilter As String
    strCustomFilter As String
    nMaxCustFilter As Long
    nFilterIndex As Long
    strFile As String
    nMaxFile As Long
    strFileTitle As String
    nMaxFileTitle As Long
    strInitialDir As String
    strTitle As String
    Flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    strDefExt As String
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type

Declare Function aht_apiGetOpenFileName Lib "comdlg32.dll" _
    Alias "GetOpenFileNameA" (OFN As tagOPENFILENAME) As Boolean

Declare Function aht_apiGetSaveFileName Lib "comdlg32.dll" _
    Alias "GetSaveFileNameA" (OFN As tagOPENFILENAME) As Boolean
Declare Function CommDlgExtendedError Lib "comdlg32.dll" () As Long

Global Const ahtOFN_READONLY = &H1
Global Const ahtOFN_OVERWRITEPROMPT = &H2
Global Const ahtOFN_HIDEREADONLY = &H4
Global Const ahtOFN_NOCHANGEDIR = &H8
Global Const ahtOFN_SHOWHELP = &H10
Global Const ahtOFN_NOVALIDATE = &H100
Global Const ahtOFN_ALLOWMULTISELECT = &H200
Global Const ahtOFN_EXTENSIONDIFFERENT = &H400
Global Const ahtOFN_PATHMUSTEXIST = &H800
Global Const ahtOFN_FILEMUSTEXIST = &H1000
Global Const ahtOFN_CREATEPROMPT = &H2000
Global Const ahtOFN_SHAREAWARE = &H4000
Global Const ahtOFN_NOREADONLYRETURN = &H8000
Global Const ahtOFN_NOTESTFILECREATE = &H10000
Global Const ahtOFN_NONETWORKBUTTON = &H20000
Global Const ahtOFN_NOLONGNAMES = &H40000
' New for Windows 95
Global Const ahtOFN_EXPLORER = &H80000
Global Const ahtOFN_NODEREFERENCELINKS = &H100000
Global Const ahtOFN_LONGNAMES = &H200000
'************************************************************************


''User information
'************************************************************************
Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" _
                (ByVal lpBuffer As String, _
                 nSize As Long) As Long
Declare Function NetApiBufferFree Lib "Netapi32.dll" _
                (ByVal lpBuffer As Long) As Long
Declare Function NetWkstaUserGetInfo Lib "Netapi32.dll" _
                (ByVal reserved As Any, _
                 ByVal Level As Long, _
                 lpBuffer As Any) As Long
Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
                (Destination As Any, _
                Source As Any, _
                ByVal Length As Long)
Declare Function lstrlenW Lib "kernel32" _
                (ByVal lpString As Long) As Long


Global sUserLogin As String
Global stUserInfo As stUserInfoType

Type stUserInfoType
    lOfficeWorksID As Long
    sOfficeWorksLogin As String
    sOfficeWorksDesc As String
End Type

Type gtypWkstUserInfo
   wkui1_username As Long
   wkui1_logon_domain As Long
   wkui1_oth_domains As Long
   wkui1_logon_server As Long
End Type


Type gtypWkstUserInfoStr
   username As String
   logon_domain As String
   oth_domains As String
   logon_server As String
End Type


Public Function BuscaUtenteInfo(sInfoType As String) As gtypWkstUserInfoStr
    Dim UserInfo As gtypWkstUserInfo
    Dim Buffer As Long
    Dim ErroAPI As Long
    
    NetApiBufferFree Buffer
    ErroAPI = NetWkstaUserGetInfo(ByVal 0&, 1&, Buffer)
    CopyMemory UserInfo, ByVal Buffer, Len(UserInfo)
    NetApiBufferFree Buffer
    
    Select Case sInfoType
    Case "USERNAME"
        If ErroAPI <> 0 Then
            BuscaUtenteInfo.username = "-"
        Else
            BuscaUtenteInfo.username = PointerToStringW(UserInfo.wkui1_username)
        End If
    Case "LOGON_DOMAIN"
        If ErroAPI <> 0 Then
            BuscaUtenteInfo.logon_domain = "-"
        Else
            BuscaUtenteInfo.logon_domain = PointerToStringW(UserInfo.wkui1_logon_domain)
        End If
    Case "OTH_DOMAINS"
        If ErroAPI <> 0 Then
            BuscaUtenteInfo.oth_domains = "-"
        Else
            BuscaUtenteInfo.oth_domains = PointerToStringW(UserInfo.wkui1_oth_domains)
        End If
    Case "LOGON_SERVER"
        If ErroAPI <> 0 Then
            BuscaUtenteInfo.logon_server = "-"
        Else
            BuscaUtenteInfo.logon_server = PointerToStringW(UserInfo.wkui1_logon_server)
        End If
    Case Else
        BuscaUtenteInfo.username = "-"
        BuscaUtenteInfo.logon_domain = "-"
        BuscaUtenteInfo.oth_domains = "-"
        BuscaUtenteInfo.logon_server = "-"
    End Select
End Function


Private Function PointerToStringW(lpStringW As Long) As String
   Dim Buffer() As Byte
   Dim nLen As Long
   
   If lpStringW Then
      nLen = lstrlenW(lpStringW) * 2
      If nLen Then
        ReDim Buffer(0 To (nLen - 1)) As Byte
        CopyMemory Buffer(0), ByVal lpStringW, nLen
        PointerToStringW = Buffer
        Exit Function
      End If
   End If
   PointerToStringW = "-"
End Function


Public Function ConnectToDB() As Boolean
    Dim sConnString As String
    
    On Error GoTo erroConnectToDB
        
    ConnectToDB = False
    ''Open connection on server
    Set objCnn = New ADODB.Connection
    sConnString = ""
    sConnString = sConnString & "SERVER=" & sServerName & ";"
    sConnString = sConnString & "DRIVER=SQL Server;"
    sConnString = sConnString & "DATABASE=" & sDBName & ";"
    sConnString = sConnString & "UID=" & sLogin & ";"
    sConnString = sConnString & "PWD=" & sPwd & ";"
    objCnn.ConnectionTimeout = lTimeout
    objCnn.CommandTimeout = lTimeout
    objCnn.ConnectionString = sConnString
    objCnn.Open
    ConnectToDB = True
    Exit Function
    
erroConnectToDB:
    MsgBox "Erro na ligação ao Servidor!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_SRV
    Err.Clear
End Function


Sub CloseRs(oRs As ADODB.Recordset)
    If oRs.State = ADODB.ObjectStateEnum.adStateOpen Then oRs.Close
End Sub


Sub CloseCnn(oCnn As ADODB.Connection)
    On Error GoTo Err
    If Not oCnn Is Nothing Then If oCnn.State = ADODB.ObjectStateEnum.adStateOpen Then oCnn.Close
    Exit Sub

Err:
MsgBox "Não é possível terminar a ligação à base de dados: " & Err.Description
Err.Clear
End Sub


Public Sub GetLogFileName(sType As String)
    Dim sLogFolder As String
    Dim sName As String

    On Error GoTo erroGetLogFileName
    
    sLogFolder = "LOGS_" & Replace(CStr(Format(Date, "yyyy-mm-dd")), "-", "")
    sName = Replace(CStr(Format(Time, "hh:mm:ss")), ":", "")
    
    Set objFS = New FileSystemObject
    Select Case sType
    Case kAED
        sLogFilePathAED = objFS.BuildPath(App.Path & "\" & sLogFolder, kLOG_FILE_AED & sName & kLOGFILE_EXT)
    Case kDEI
        sLogFilePathDEI = objFS.BuildPath(App.Path & "\" & sLogFolder, kLOG_FILE_DEI & sName & kLOGFILE_EXT)
    Case kENR
        sLogFilePathENR = objFS.BuildPath(App.Path & "\" & sLogFolder, kLOG_FILE_ENR & sName & kLOGFILE_EXT)
    Case kACE
        sLogFilePathACE = objFS.BuildPath(App.Path & "\" & sLogFolder, kLOG_FILE_ACE & sName & kLOGFILE_EXT)
    Case Else
    End Select
    Set objFS = Nothing
    Exit Sub
    
erroGetLogFileName:
    MsgBox "Erro ao obter caminho do ficheiro de log!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG
    Err.Clear
    Set objFS = Nothing
End Sub


Public Sub ViewLogFile(sLog As String)
    
    On Error GoTo erroViewLogFile
    
    ''View log file
    Shell "Notepad.exe " & sLog, vbNormalFocus
    Exit Sub
    
erroViewLogFile:
    MsgBox "Erro ao abrir ficheiro de log '" & sLog & "'!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG
    Err.Clear
End Sub


Public Sub OpenLogFile(sLog As String)
    Dim sFolderName As String

    On Error GoTo erroOpenLogFile
    
    Set objFS = New FileSystemObject
    ''Create log file
    sFolderName = objFS.GetParentFolderName(sLog)
    If Not objFS.FolderExists(sFolderName) Then
        objFS.CreateFolder sFolderName
    End If
    Set otsFile = objFS.OpenTextFile(sLog, ForWriting, True)
    Set objFS = Nothing
    Exit Sub
    
erroOpenLogFile:
    MsgBox "Erro na criação do ficheiro de log!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG
    Err.Clear
    Set otsFile = Nothing
    Set objFS = Nothing
End Sub


Public Sub WriteInLogFile(sLine As String)
    
    On Error GoTo erroWriteInLogFile
    
    If otsFile Is Nothing Then Exit Sub
    otsFile.WriteLine sLine
    sLine = ""
    Exit Sub
    
erroWriteInLogFile:
    Err.Clear
End Sub


Public Sub CloseLogFile()
       
    On Error GoTo erroCloseLogFile
    
    If otsFile Is Nothing Then Exit Sub
    otsFile.Close
    Set otsFile = Nothing
    Exit Sub
    
erroCloseLogFile:
    MsgBox "Erro a fechar o ficheiro de log!" & vbNewLine & " (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG
    Err.Clear
    Set otsFile = Nothing
End Sub


Public Function GetOperationTime(dTimeSec As Double) As String
    Dim dHour As Double
    Dim dMin As Double
    Dim dSec As Double
    
    On Error GoTo erroGetOperationTime
    
    GetOperationTime = ""
    ''Get hours
    dHour = Fix(IIf(dTimeSec < kHOUR_SEC, 0, dTimeSec / kHOUR_SEC))
    ''Get minutes
    dMin = Fix(IIf((dTimeSec Mod kHOUR_SEC) > (kMIN_SEC - 1), (dTimeSec Mod kHOUR_SEC) / kMIN_SEC, 0))
    ''Get seconds
    dSec = Fix(IIf((dTimeSec Mod kHOUR_SEC) Mod kMIN_SEC = 0, 0, (dTimeSec Mod kHOUR_SEC) Mod kMIN_SEC))
    GetOperationTime = IIf(Len(dHour) < 3, Right("00" & dHour, 2), dHour) & " h " & Right("00" & dMin, 2) & " min " & Right("00" & dSec, 2) & " seg"
    Exit Function

erroGetOperationTime:
    GetOperationTime = " Tempo indeterminado! (Erro nº: " & Err.Number & "  Desc.: " & Err.Description & ")"
    Err.Clear
End Function


Public Function ConvertStringToLatin(sValue As String)
    Dim sValueAux As String
            
    sValueAux = ""
    sValueAux = sValue
    ''Replace characters
    sValueAux = Replace(sValueAux, "º", "")
    sValueAux = Replace(sValueAux, "À", "A")
    sValueAux = Replace(sValueAux, "Á", "A")
    sValueAux = Replace(sValueAux, "Â", "A")
    sValueAux = Replace(sValueAux, "Ã", "A")
    sValueAux = Replace(sValueAux, "Ä", "A")
    sValueAux = Replace(sValueAux, "Ç", "C")
    sValueAux = Replace(sValueAux, "È", "E")
    sValueAux = Replace(sValueAux, "É", "E")
    sValueAux = Replace(sValueAux, "Ê", "E")
    sValueAux = Replace(sValueAux, "Ë", "E")
    sValueAux = Replace(sValueAux, "Ì", "I")
    sValueAux = Replace(sValueAux, "Í", "I")
    sValueAux = Replace(sValueAux, "Î", "I")
    sValueAux = Replace(sValueAux, "Ï", "I")
    sValueAux = Replace(sValueAux, "Ò", "O")
    sValueAux = Replace(sValueAux, "Ó", "O")
    sValueAux = Replace(sValueAux, "Ô", "O")
    sValueAux = Replace(sValueAux, "Õ", "O")
    sValueAux = Replace(sValueAux, "Ö", "O")
    sValueAux = Replace(sValueAux, "Ù", "U")
    sValueAux = Replace(sValueAux, "Ú", "U")
    sValueAux = Replace(sValueAux, "Û", "U")
    sValueAux = Replace(sValueAux, "Ü", "Ü")
    sValueAux = Replace(sValueAux, "à", "a")
    sValueAux = Replace(sValueAux, "á", "a")
    sValueAux = Replace(sValueAux, "â", "a")
    sValueAux = Replace(sValueAux, "ã", "a")
    sValueAux = Replace(sValueAux, "ä", "a")
    sValueAux = Replace(sValueAux, "ç", "c")
    sValueAux = Replace(sValueAux, "è", "e")
    sValueAux = Replace(sValueAux, "é", "e")
    sValueAux = Replace(sValueAux, "ê", "e")
    sValueAux = Replace(sValueAux, "ë", "e")
    sValueAux = Replace(sValueAux, "ì", "i")
    sValueAux = Replace(sValueAux, "í", "i")
    sValueAux = Replace(sValueAux, "î", "i")
    sValueAux = Replace(sValueAux, "ï", "i")
    sValueAux = Replace(sValueAux, "ò", "o")
    sValueAux = Replace(sValueAux, "ó", "o")
    sValueAux = Replace(sValueAux, "ô", "o")
    sValueAux = Replace(sValueAux, "õ", "o")
    sValueAux = Replace(sValueAux, "ö", "o")
    sValueAux = Replace(sValueAux, "ù", "u")
    sValueAux = Replace(sValueAux, "ú", "u")
    sValueAux = Replace(sValueAux, "û", "u")
    sValueAux = Replace(sValueAux, "ü", "u")
    ''Return converted value
    ConvertStringToLatin = sValueAux
End Function


Function Msg(lMsgID, Optional sTextAux As String = "", Optional bShowMsgBox As Boolean = True) As String
    Dim sMsg As String
    Dim kButtons As VbMsgBoxStyle
    
    kButtons = vbInformation

    Select Case lMsgID
    'MSG's Erro (1-100)
    Case 1
        sMsg = ""
    Case 2
        sMsg = ""
    Case 3
        sMsg = ""
    Case 4
        sMsg = ""
    Case 5
        sMsg = ""
    
    'MSG's de Confirmação/Aviso (101-200)
    Case 101
        sMsg = "A preparar para exportar ..."
    Case 102
        sMsg = "A estabelecer ligação com o " & sTextAux & " ..."
    Case 103
        sMsg = "A fechar ligação ..."
    Case 104
        sMsg = "Não existem referênciados contactos na base dados para para a exportação!"
        kButtons = vbExclamation
    Case 105
        sMsg = "Exportação de contactos concluída. Verifique o ficheiro de log."
    Case 106
        sMsg = "Deseja perder as alterações?"
    Case 107
        sMsg = ""
    Case 108
        sMsg = ""
    Case 109
        sMsg = ""
    Case 110
        sMsg = "Os dados obrigatórios não estão preenchidos!"
    Case 111
        sMsg = "Tentativa de duplicar dados existentes! " & sTextAux
    Case 112
        sMsg = "Senha ou Utilizador incorrecto."
    Case 113
        sMsg = ""
    Case 114
        sMsg = ""
    Case 115
        sMsg = ""
    Case 116
        sMsg = ""
    Case 117
        sMsg = ""
    Case 118
        sMsg = ""
    Case 119
        sMsg = "O valor do campo '" & sTextAux & "' contém caracteres inválidos!"
    Case 120
        sMsg = ""
    Case 121
        sMsg = ""
    Case 122
        sMsg = "Pasta não existente!"
        kButtons = vbExclamation
    Case 123
        sMsg = ""
    Case 124
        sMsg = "Não foi possível actualizar " & sTextAux & "!"
        kButtons = vbExclamation
    Case 125
        sMsg = "Não foram encontrados elementos!"
    Case 126
        sMsg = ""
    Case 127
        sMsg = ""
    Case 128
        sMsg = ""
    Case 129
        sMsg = "Não foi possível aceder ao Servidor de Exchange!"
    Case 130
        sMsg = "Não foi possível aceder ao Servidor de SQLServer!"
        kButtons = vbExclamation
    Case 131
        sMsg = "Pasta ou ficheiro já existente!"
        kButtons = vbExclamation
    Case 132
        sMsg = "Caminho inválido!"
        kButtons = vbExclamation
    Case 133
        sMsg = ""
    Case 134
        sMsg = ""
    Case 135
        sMsg = ""
    Case 136
        sMsg = ""
    Case 137
        sMsg = ""
    Case 138
        sMsg = ""
    Case 139
        sMsg = ""
    Case 140
        sMsg = ""
    Case 141
        sMsg = ""
    Case 142
        sMsg = ""
    Case 143
        sMsg = "O componente de SQLServer 'Client Connectivity' não está instalado!"
    Case 144
        sMsg = "Não foi possível aceder ao Servidor de SQLServer ou componente de SQLServer 'Client Connectivity' inexistente!"
        
        
    'MSG's de Log (301-500)
    Case 301
        sMsg = ""
    Case 302
        sMsg = ""
    Case 303
        sMsg = ""
    Case 304
        sMsg = ""
    Case 305
        sMsg = ""
    Case 306
        sMsg = ""
    Case 307
        sMsg = ""
    Case 308
        sMsg = ""
    Case 309
        sMsg = ""
    Case 310
        sMsg = ""
    Case 311
        sMsg = ""
    Case 312
        sMsg = ""
    Case 313
        sMsg = ""
    Case 314
        sMsg = ""
    Case 315
        sMsg = ""
    Case 316
        sMsg = ""
    Case 317
        sMsg = ""
    Case 318
        sMsg = ""
    Case 319
        sMsg = ""
    Case 320
        sMsg = ""
    Case 321
        sMsg = ""
    Case 322
        sMsg = ""
    Case 323
        sMsg = ""
    Case 324
        sMsg = ""
    Case 325
        sMsg = ""
    Case 326
        sMsg = ""
    Case 327
        sMsg = ""
    Case 328
        sMsg = ""
    Case 329
        sMsg = "A pasta '" & sTextAux & "' não existe!"
    Case 330
        sMsg = "O ficheiro '" & sTextAux & "' não existe!"
    Case 331
        sMsg = "O disco '" & sTextAux & "' não tem espaço suficiente para concluir a operação!"
    Case 332
        sMsg = "Sem permissões para concluir a operação!"
'    Case 333
'        sMsg = ""
        
        
    Case Else
        sMsg = "Mensagem desconhecida (#" & lMsgID & ") - '" & sTextAux & "'"
    End Select
    
    If bShowMsgBox Then MsgBox sMsg, kButtons, kTITULO_MSGBOX
    Msg = sMsg
End Function


' This is the entry point you'll use to call the common
' file open/save dialog. The parameters are listed
' below, and all are optional.
'
' In:
' Flags: one or more of the ahtOFN_* constants, OR'd together.
' InitialDir: the directory in which to first look
' Filter: a set of file filters, set up by calling
' AddFilterItem. See examples.
' FilterIndex: 1-based integer indicating which filter
' set to use, by default (1 if unspecified)
' DefaultExt: Extension to use if the user doesn't enter one.
' Only useful on file saves.
' FileName: Default value for the file name text box.
' DialogTitle: Title for the dialog.
' hWnd: parent window handle
' OpenFile: Boolean(True=Open File/False=Save As)
' Out:
' Return Value: Either Null or the selected filename
Function ahtCommonFileOpenSave( _
            Optional ByRef Flags As Variant, _
            Optional ByVal InitialDir As Variant, _
            Optional ByVal Filter As Variant, _
            Optional ByVal FilterIndex As Variant, _
            Optional ByVal DefaultExt As Variant, _
            Optional ByVal FileName As Variant, _
            Optional ByVal DialogTitle As Variant, _
            Optional ByVal hwnd As Variant, _
            Optional ByVal OpenFile As Variant) As Variant

Dim OFN As tagOPENFILENAME
Dim strFilename As String
Dim strFileTitle As String
Dim fResult As Boolean
    ' Give the dialog a caption title.
    If IsMissing(InitialDir) Then InitialDir = CurDir
    If IsMissing(Filter) Then Filter = ""
    If IsMissing(FilterIndex) Then FilterIndex = 1
    If IsMissing(Flags) Then Flags = 0&
    If IsMissing(DefaultExt) Then DefaultExt = ""
    If IsMissing(FileName) Then FileName = ""
    If IsMissing(DialogTitle) Then DialogTitle = ""
    If IsMissing(hwnd) Then hwnd = Application.hwnd
    If IsMissing(OpenFile) Then OpenFile = True
    ' Allocate string space for the returned strings.
    strFilename = Left(FileName & String(256, 0), 256)
    strFileTitle = String(256, 0)
    ' Set up the data structure before you call the function
    With OFN
        .lStructSize = Len(OFN)
        .hwndOwner = hwnd
        .strFilter = Filter
        .nFilterIndex = FilterIndex
        .strFile = strFilename
        .nMaxFile = Len(strFilename)
        .strFileTitle = strFileTitle
        .nMaxFileTitle = Len(strFileTitle)
        .strTitle = DialogTitle
        .Flags = Flags
        .strDefExt = DefaultExt
        .strInitialDir = InitialDir
        .hInstance = 0
        '.strCustomFilter = ""
        '.nMaxCustFilter = 0
        .lpfnHook = 0
        'New for NT 4.0
        .strCustomFilter = String(255, 0)
        .nMaxCustFilter = 255
    End With
    ' This will pass the desired data structure to the
    ' Windows API, which will in turn it uses to display
    ' the Open/Save As Dialog.
    If OpenFile Then
        fResult = aht_apiGetOpenFileName(OFN)
    Else
        fResult = aht_apiGetSaveFileName(OFN)
    End If

    ' The function call filled in the strFileTitle member
    ' of the structure. You'll have to write special code
    ' to retrieve that if you're interested.
    If fResult Then
        ' You might care to check the Flags member of the
        ' structure to get information about the chosen file.
        ' In this example, if you bothered to pass in a
        ' value for Flags, we'll fill it in with the outgoing
        ' Flags value.
        If Not IsMissing(Flags) Then Flags = OFN.Flags
        ahtCommonFileOpenSave = TrimNull(OFN.strFile)
    Else
        ahtCommonFileOpenSave = vbNullString
    End If
End Function

Function ahtAddFilterItem(strFilter As String, _
    strDescription As String, Optional varItem As Variant) As String
' Tack a new chunk onto the file filter.
' That is, take the old value, stick onto it the description,
' (like "Databases"), a null character, the skeleton
' (like "*.mdb;*.mda") and a final null character.
    If IsMissing(varItem) Then varItem = "*.*"
    ahtAddFilterItem = strFilter & _
                strDescription & vbNullChar & _
                varItem & vbNullChar
End Function

Private Function TrimNull(ByVal strItem As String) As String
Dim intPos As Integer
    intPos = InStr(strItem, vbNullChar)
    If intPos > 0 Then
        TrimNull = Left(strItem, intPos - 1)
    Else
        TrimNull = strItem
    End If
End Function

