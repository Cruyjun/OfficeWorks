VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsTrataErros"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public WithEvents ErrorOBJ As clsError
Attribute ErrorOBJ.VB_VarHelpID = -1

Private Sub Class_Initialize()
    Set ErrorOBJ = New clsError
    
    'Activar propriedades do objecto 'CheckErrors'
    SetclsErrorProperties
    
    'Parametrizar o erro de vb 'DivideByZeroError'
        'Adicionar erro á colecção de erros do objecto
    ErrorOBJ.AddCod DivideByZeroError, VbType, SinError
        'adicionar Funções para o erro anterior
            'Quando o objecto encontrar o erro numero
            '11 no err.number, este vai fazer disparar
            'o evento 'ErrorEvent' com o Index = 3
    ErrorOBJ.AddFunc DivideByZeroError, TriggerEvent_ErrorEvent, "Vai dispara o evento com o Index = 3", vbInformation, BeforeExec, 3
            'Quando o objecto encontrar o erro numero
            '11 no err.number, este vai fazer disparar
            'o evento 'ErrorEvent' com o Index = 1
    ErrorOBJ.AddFunc DivideByZeroError, TriggerEvent_ErrorEvent, "Vai dispara o evento com o Index = 1", vbInformation, BeforeExec, 1
            'Quando o objecto encontrar o erro numero
            '11 no err.number, este vai mostra uma msg
            '"O Programa vai Fechar." e de seguida
            'feicha o programa.
            'NOTA: quando o objecto está em DebugMode
            'este só mostra uma msg, mas não fecha o
            'programa.
    ErrorOBJ.AddFunc DivideByZeroError, EndProg, "O Programa vai Fechar.", vbExclamation, BeforeExec
    
    'Para o mesmo Erro, criar uma configuração diferente
    'ErrorOBJ.AddCod DivideByZeroError, VbType, SinError, Config_DbyZero_CasoEspecial
    'Nesta configuração o objecto limita-se a mostrar a msg
    '"Erro numero 11 vai Retornar" e a retornar o
    'código de erro.
    'ErrorOBJ.AddFunc DivideByZeroError, ReturnErrorCode, "Erro numero 11 vai Retornar", vbInformation, BeforeExec, , Config_DbyZero_CasoEspecial
    
        
    'ERROS GENÉRICOS *************************************************************
    ErrorOBJ.AddCod kERROR_SQL_N_BADLOGIN, AdoType, SinNative
    ErrorOBJ.AddFunc kERROR_SQL_N_BADLOGIN, ReturnErrorCode, Msg(112, , False), vbCritical, BeforeExec
    
    ErrorOBJ.AddCod kERROR_SQL_N_DPK, AdoType, SinNative
    ErrorOBJ.AddFunc kERROR_SQL_N_DPK, ReturnErrorCode, Msg(111, , False), vbCritical, BeforeExec
    
    ErrorOBJ.AddCod kERROR_SQL_N_INVALIDSQLSERVER, AdoType, SinNative
    ErrorOBJ.AddFunc kERROR_SQL_N_INVALIDSQLSERVER, EndProg, Msg(130, , False), vbCritical, BeforeExec
    
    ErrorOBJ.AddCod kERROR_SQL_INVALIDSQLSERVER, VbType, SinError
    ErrorOBJ.AddFunc kERROR_SQL_INVALIDSQLSERVER, EndProg, Msg(144, , False), vbExclamation, BeforeExec
    
    ErrorOBJ.AddCod kERROR_FILE_PERMISSIONDENIED, VbType, SinError
    ErrorOBJ.AddFunc kERROR_FILE_PERMISSIONDENIED, ReturnErrorCode, Msg(332, , False), vbExclamation, BeforeExec
    
    ErrorOBJ.AddCod kERROR_FILE_FILEORFOLDEREXIST, VbType, SinError
    ErrorOBJ.AddFunc kERROR_FILE_FILEORFOLDEREXIST, ReturnErrorCode, Msg(131, , False), vbExclamation, BeforeExec
    
    ErrorOBJ.AddCod kERROR_FILE_INVALIDCHARS, VbType, SinError
    ErrorOBJ.AddFunc kERROR_FILE_INVALIDCHARS, ReturnErrorCode, Msg(132, , False), vbExclamation, BeforeExec
    
    ErrorOBJ.AddCod kERROR_SQL_DATABASEINUSE, VbType, SinError
    ErrorOBJ.AddFunc kERROR_SQL_DATABASEINUSE, ReturnErrorCode, , , BeforeExec
        
    ErrorOBJ.AddCod kERROR_SQL_N_DBNOTEXISTS, AdoType, SinNative
    ErrorOBJ.AddFunc kERROR_SQL_N_DBNOTEXISTS, ReturnErrorCode, Msg(140, , False), vbExclamation, BeforeExec
    
    ErrorOBJ.AddCod kERROR_MAPI_E_NOT_FOUND, VbType, SinError
    ErrorOBJ.AddFunc kERROR_MAPI_E_NOT_FOUND, ReturnErrorCode
    
    ErrorOBJ.AddCod kERROR_MAPI_INVALID_CONTACTID, VbType, SinError
    ErrorOBJ.AddFunc kERROR_MAPI_INVALID_CONTACTID, ReturnErrorCode
    
    ErrorOBJ.AddCod kERROR_MAPI_E_USER_CANCEL, VbType, SinError
    ErrorOBJ.AddFunc kERROR_MAPI_E_USER_CANCEL, ReturnErrorCode

    ErrorOBJ.AddCod kERROR_MAPI_INVALID_ENTRYID, VbType, SinError
    ErrorOBJ.AddFunc kERROR_MAPI_INVALID_ENTRYID, ReturnErrorCode
    
    ErrorOBJ.AddCod kERROR_MAPI_LOGIN_FAILED, VbType, SinError
    ErrorOBJ.AddFunc kERROR_MAPI_LOGIN_FAILED, ReturnErrorCode, Msg(129, , False), vbExclamation, BeforeExec
    '*****************************************************************************
    
    'ERROS CASOS ESPECIAIS********************************************************
    ErrorOBJ.AddCod kERROR_SQL_N_INVALIDOBJ, AdoType, SinNative, kERRORCFG_CnnTestDatabase
    ErrorOBJ.AddFunc kERROR_SQL_N_INVALIDOBJ, ReturnErrorCode, , , , , kERRORCFG_CnnTestDatabase
    ErrorOBJ.AddCod kERROR_SQL_N_INVALIDOBJ2, AdoType, SinNative, kERRORCFG_CnnTestDatabase
    ErrorOBJ.AddFunc kERROR_SQL_N_INVALIDOBJ2, ReturnErrorCode, , , , , kERRORCFG_CnnTestDatabase
        
    ErrorOBJ.AddCod kERROR_SQL_N_DPK, AdoType, SinNative, kERRORCFG_CnnInsertDPK
    ErrorOBJ.AddFunc kERROR_SQL_N_DPK, ReturnErrorCode, , , , , kERRORCFG_CnnInsertDPK
    
    ErrorOBJ.AddCod kERROR_FILE_PERMISSIONDENIED, VbType, SinError, kERRORCFG_FilePermission
    ErrorOBJ.AddFunc kERROR_FILE_PERMISSIONDENIED, ReturnErrorCode, , , , , kERRORCFG_FilePermission
    
    ErrorOBJ.AddCod kERROR_SQL_N_INVALIDSQLSERVER, AdoType, SinNative, kERRORCFG_ONSQLConnect
    ErrorOBJ.AddFunc kERROR_SQL_N_INVALIDSQLSERVER, ReturnErrorCode, Msg(130, , False), vbCritical, BeforeExec, , kERRORCFG_ONSQLConnect
    '******************************************************************************
End Sub


Private Sub SetclsErrorProperties()
    'Este parametro tem que ser False quando Gerado
    'o Executavel, para que realmente o EndApplication
    'seja executado.
    'Visto que por Default este está a True a próxima
    'linha escusava de existir.
    'se ñ estiver a True em Debug Time o objecto fecha
    'o VB ao envés do projecto em si.
    ErrorOBJ.SetDebugMode = False
    
    ErrorOBJ.SetProjectType = StandardEXE 'este por default é 'StandardEXE'
    ErrorOBJ.SetLogTO = cLogToFile 'este por default é 'cLogToFile'
    
    
    ErrorOBJ.SetLABELFROMAdo = "Erro (ADO)"
    ErrorOBJ.SetLABELFROMVb = "Erro (Run Time)"
    ErrorOBJ.SetLABELNumber = "Número: "
    ErrorOBJ.SetLABELNative = "Número (Nativo):"
    ErrorOBJ.SetLABELSource = "Origem:"
    ErrorOBJ.SetMSGFatalError = "Ocorreu um erro Fatal. Deseja ver detalhes?"
    ErrorOBJ.SetTitleMsgBox = kTITULO_MSGBOX
    
    'Quando este não é parametrizado o objecto
    'CheckErrors.dll, não cria o log dos Ficheiros.
    'Este ficheiro, quando atinge as 500 linhas, começa
    'a cortar os erros mais antigos, para o ficheiro não
    'seja muito grande.
    ErrorOBJ.SetLogFilePath = oFS.BuildPath(App.Path, "Erros.log")
    
End Sub

'Evento a disparar pelo objecto CheckErrors.dll
Private Sub ErrorOBJ_ErrorEvent(Index As Integer)
    Select Case Index
    Case 1
        MsgBox "Executar um pedaço de código quando o Index é " & Index, vbInformation
    Case 2
        MsgBox "Executar um pedaço de código quando o Index é " & Index, vbInformation
    Case 3
        MsgBox "Executar um pedaço de código quando o Index é " & Index, vbInformation
    Case Else
        MsgBox "Executar um pedaço de código quando o Index é " & Index, vbInformation
    End Select
End Sub

