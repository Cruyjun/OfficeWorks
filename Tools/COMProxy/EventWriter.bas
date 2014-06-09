Attribute VB_Name = "EventWriter"
Option Explicit

Public Enum enmLogType
    LogSuccess = 0&
    LogError = 1&
    LogWarning = 2&
    LogInfo = 4&
    LogAuditSuccess = 8&
    LogAuditFailure = 10&
End Enum
      
Public Enum enmErrLevel
   lInfo = &H60000000
   lWarning = &HA0000000
   lError = &HE0000000
End Enum

Public Declare Function RegisterEventSource _
   Lib "advapi32" Alias "RegisterEventSourceA" _
   (ByVal lpUNCServerName As String, _
    ByVal lpSourceName As String) As Long

Public Declare Function DeregisterEventSource _
   Lib "advapi32" _
   (ByVal hEventLog As Long) As Long

Public Declare Function ReportEvent _
   Lib "advapi32" Alias "ReportEventA" _
   (ByVal hEventLog As Long, _
    ByVal wType As Long, _
    ByVal wCategory As Long, _
    ByVal dwEventID As Long, _
    ByVal lpUserSid As Long, _
    ByVal wNumStrings As Long, _
    ByVal dwDataSize As Long, _
    lpStrings As Any, _
    lpRawData As Any) As Long
    
    
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
   hpvDest As Any, hpvSource As Any, _
   ByVal cbCopy As Long)
   
Public Declare Function GlobalAlloc Lib "kernel32" ( _
    ByVal wFlags As Long, _
    ByVal dwBytes As Long) As Long
    
Public Declare Function GlobalFree Lib "kernel32" ( _
    ByVal hMem As Long) As Long

Public Function LogErrorToEventViewer(ByVal sErrMsg As String, _
                                      ByVal eEventType As enmLogType, _
                                      ByVal sSourceName As String) As Boolean
On Error GoTo ExitSub
    Dim lEventLogHwnd As Long
    Dim LogType As enmLogType
    Dim lEventID As Long
    Dim lCategory As Long
    Dim sServerName As String
    Dim lRet As Long
    Dim stringSize As Long 'string size
    Dim hMsgs As Long 'ponteiro para a zona de memória onde vai ficar a string

    LogErrorToEventViewer = True
    
    lCategory = 0
    sServerName = vbNullString
            
    If eEventType = vbLogEventTypeError Then
        LogType = LogError
        lEventID = 3& Or enmErrLevel.lError
    ElseIf eEventType = vbLogEventTypeInformation Then
        LogType = LogInfo
        lEventID = 1& Or enmErrLevel.lInfo
    ElseIf eEventType = vbLogEventTypeWarning Then
        LogType = LogWarning
        lEventID = 2& Or enmErrLevel.lWarning
    End If
    
    If sSourceName = "" Then sSourceName = "OWApi"
    lEventLogHwnd = RegisterEventSource(lpUNCServerName:=sServerName, _
                                        lpSourceName:=sSourceName)
    
    If lEventLogHwnd = 0 Then
        LogErrorToEventViewer = False
        Exit Function
    End If
    
    'mostrar a mensagem de erro duas linhas a baixo
    sErrMsg = vbCrLf & vbCrLf & sErrMsg
    
    ' + 1 porque é a string e o caracter de finalização da string
    stringSize = Len(sErrMsg) + 1
    'alocar espaço de memória com o ponteiro hMsgs
    hMsgs = GlobalAlloc(&H40, stringSize)
    'copiar para a zona de memória a string
    CopyMemory ByVal hMsgs, ByVal sErrMsg, stringSize
    
    'gravar no log  passando o ponteiro hMsgs
    lRet = ReportEvent(hEventLog:=lEventLogHwnd, _
                       wType:=LogType, _
                       wCategory:=lCategory, _
                       dwEventID:=lEventID, _
                       lpUserSid:=0, _
                       wNumStrings:=1, _
                       dwDataSize:=0, _
                       lpStrings:=hMsgs, _
                       lpRawData:=0)
                       
    If lRet = False Then
        LogErrorToEventViewer = False
    End If
    
    
    DeregisterEventSource lEventLogHwnd
ExitSub:
    'libertar o espaço de memória passando o ponteiro
    Call GlobalFree(hMsgs)

End Function


