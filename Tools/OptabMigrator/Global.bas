Attribute VB_Name = "Global"
Public Declare Function OAP_RecuperaOpticoEx Lib "ELWOPT.DLL" (ByVal Nome_Ficheiro As String, ByVal Path_Ficheiro As String, ByVal Path_Nome_Ficheiro As String, ByVal flag As Integer) As Integer
Public Declare Function GetFile Lib "ELWOPT.DLL" (ByVal index As Long) As String
Public Declare Function GetFileDO Lib "ELWOPT.DLL" (ByVal index As Long) As String
Public Declare Function GetPathFiles Lib "ELWOPT.DLL" (ByVal Caminho As String) As Integer
Public Declare Function GetPAthFilesCount Lib "ELWOPT.DLL" () As Long


Public Declare Function GetLogicalDriveStrings Lib "kernel32" Alias "GetLogicalDriveStringsA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Declare Function GetDirectoryName Lib "ELWOPT.DLL" (ByVal index As Long) As String
Public Declare Function GetPathDirectory Lib "ELWOPT.DLL" (ByVal Caminho As String) As Integer
Public Declare Function GetDirectoriesCount Lib "ELWOPT.DLL" () As Long

Public Declare Function ELET_logoff Lib "ELWELET.DLL" () As Long
Public Declare Function ELET_unlock Lib "ELWELET.DLL" () As Long
Public Declare Function ELET_logged_on Lib "ELWELET.DLL" () As Long
Public Declare Function ELET_passwd_is_valid Lib "ELWELET.DLL" (ByVal lpPasswd As String) As Long
Public Declare Function ELET_lock Lib "ELWELET.DLL" (ByVal svc As Long, ByVal WMSG_LOCK As Long) As Long
Public Declare Function SERVStart Lib "ELWELET.DLL" (ByVal hMainWdn As Long, ByVal svc As Long, ByVal bServiceManager As Long) As Long
Public Declare Sub SERVStop Lib "ELWELET.DLL" ()
'Public Declare Function ELET_get_db_doc_info Lib "ELWELET.DLL" (ByVal dwKey As Long, ByRef doc As ELWDOCUMENT, ByVal passwd As String) As Long
'Public Declare Function ELET_get_db_doc Lib "ELWELET.DLL" (ByVal dwKey As Long, ByVal Filename As String, ByVal passwd As String, ByVal bWithMessage As Long, ByVal wLoadOptRef As Integer, ByVal lpParam As Long) As Long

Public Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Public Declare Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpPathName As String, ByVal lpPrefixString As String, ByVal uUnique As Long, ByVal lpTempFileName As String) As Long

Public Const FILE_ATTRIBUTE_NORMAL = &H80

Public Declare Function SetFileAttributes Lib "kernel32" Alias "SetFileAttributesA" (ByVal lpFileName As String, ByVal dwFileAttributes As Long) As Long
'Public Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long

'Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
'Public Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long

Public Function StartOfficeWorks() As Long
    Dim ret As Long
    
    StartOfficeWorks = 0
    ret = SERVStart(0, SVC_ARCH, 1)
    ret = ELET_lock(SVC_ARCH, 0)
    If ret <> 0 Then
        ret = ELET_logged_on
        If ret = 0 Then
            ret = ELET_passwd_is_valid("")
            ret = ELET_logged_on()
            If ret <> 0 Then
                StartOfficeWorks = 1
            End If
        End If
    End If
    ret = ELET_unlock
End Function

Public Function StopOfficeWorks() As Long
    Dim ret As Long
    
    StopOfficeWorks = 0
    ret = ELET_lock(SVC_ARCH, 0)
    If ret <> 0 Then
        ret = ELET_logoff
        StopOfficeWorks = 1
    End If
    ret = ELET_unlock
    Call SERVStop
End Function

