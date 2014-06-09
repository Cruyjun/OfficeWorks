VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "OptabMigrator"
   ClientHeight    =   4620
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8220
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4620
   ScaleWidth      =   8220
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkNetwork 
      Caption         =   "Parar se encontrar erro na rede"
      Height          =   855
      Left            =   6960
      TabIndex        =   9
      ToolTipText     =   "Para e avisa que ocorreu um erro na rede"
      Top             =   3480
      Width           =   1215
   End
   Begin VB.CheckBox chkDiskNotfound 
      Caption         =   "Parar se disco não encontrado"
      Height          =   675
      Left            =   6960
      TabIndex        =   8
      ToolTipText     =   "Parar e avisar quando não encontrar o disco no servidor"
      Top             =   2880
      Width           =   1215
   End
   Begin VB.DriveListBox cmbDriver 
      Height          =   315
      Left            =   6960
      TabIndex        =   7
      Top             =   2520
      Width           =   1215
   End
   Begin MSComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   315
      Left            =   0
      TabIndex        =   6
      Top             =   4305
      Width           =   8220
      _ExtentX        =   14499
      _ExtentY        =   556
      SimpleText      =   "EEEE"
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   3
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   8821
            MinWidth        =   8821
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   3351
            MinWidth        =   3351
            Text            =   "Convertidos"
            TextSave        =   "Convertidos"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   2822
            MinWidth        =   2822
            Text            =   "Erros"
            TextSave        =   "Erros"
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton cmdMigrarPasta 
      Caption         =   "Migrar Pasta"
      Height          =   375
      Left            =   6960
      TabIndex        =   5
      Tag             =   "Permite especificar um caminho para ser migrado"
      Top             =   2040
      Width           =   1215
   End
   Begin VB.CommandButton cmbLimparLog 
      Caption         =   "Limpar Log"
      Height          =   375
      Left            =   6960
      TabIndex        =   4
      ToolTipText     =   "Apaga o ficheiro de log"
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Ver Log"
      Height          =   375
      Left            =   6960
      TabIndex        =   3
      Tag             =   "Permite visualizar o log de erros ocorridos durante a migração"
      Top             =   1080
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Continuar"
      Height          =   375
      Left            =   6960
      TabIndex        =   2
      ToolTipText     =   "Continua o processo de migração apartir da ultima pasta migrada"
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton cmdLista 
      Caption         =   "Iniciar "
      Height          =   375
      Left            =   6960
      TabIndex        =   1
      ToolTipText     =   "Começa o processo de migração desde a primeira pasta"
      Top             =   120
      Width           =   1215
   End
   Begin MSComctlLib.ListView ListView1 
      Height          =   4335
      Left            =   0
      TabIndex        =   0
      ToolTipText     =   "Lista das pastas migradas "
      Top             =   0
      Width           =   6855
      _ExtentX        =   12091
      _ExtentY        =   7646
      View            =   2
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Option Compare Text
Option Base 0

Const LOG_FILE_NAME As String = "c:\optabMigrator.log"
Const LOG_FILE_NAME_MARKUP As String = "c:\optabMigratorM.log"

Public Sub WriteLogEx(ByVal msg As String, ByVal file_name As String)
 
   Dim oFS As New FileSystemObject
   Dim oTS As TextStream

   Set oTS = oFS.OpenTextFile(file_name, ForAppending, True)
   oTS.WriteLine msg
   oTS.Close

End Sub

Public Sub MigraPasta(ByVal path As String, recursivo As Boolean)
    
    Unload frmPasta
   MigrationMain path, recursivo

End Sub

Private Function ReadLog(ByVal file_name As String) As String
' Faz a leitura do ficheiro de Log e preenche a Lista
      
Dim ret As String
Dim fin As Integer   ' create a variable to refer to the file
Dim itmX As ListItem
Dim i As Integer
   
ListView1.ListItems.Clear
'Dim aline As String

fin = FreeFile

    If Dir$(file_name, vbArchive) <> "" Then
    

    Open file_name For Input As fin   ' open the file for reading
    
    While Not EOF(fin)   ' read until "end of file" of file referred to by fin
        Line Input #fin, ret ' read a line from the file "fin"
         If ret <> "" Then
            Set itmX = ListView1.ListItems.Add(, , ret)
        End If
    Wend ' end while, ie. loop round to the While not eof statement
        
    ReadLog = ret
End If

End Function



Private Sub cmbLimparLog_Click()
' Apaga o ficheiro de log

    If Dir$(LOG_FILE_NAME, vbArchive) <> "" Then ' Verifica se o ficheiro de log existe
        Kill LOG_FILE_NAME
    End If
    
End Sub
Private Sub exceptionlog(ByVal errnum As Long, ByVal opticaldisk As String, ByVal filename As String)
' trata das messagens de erro vindas do C++
' e as coloca no em um ficheiro de log

Dim msgErro As String

    Select Case errnum
        Case 324
            msgErro = errnum & " O Disco nao se encontra no servidor .: " & opticaldisk & " File:" & filename
        Case 305
            msgErro = errnum & " O disco errado está na Drive."
        Case Else
            msgErro = "Erro: " & errnum & " Disco: " & opticaldisk & "  File:" & filename
    End Select
    
    WriteLogEx msgErro, LOG_FILE_NAME

End Sub

Private Sub cmdLista_Click()
' btn iniciar...
    
    
    MigrationMain (Mid(cmbDriver, 1, 2))

End Sub

Public Sub WriteListView(ByVal str As String)
' Adiciona os itens a listview.
' Nao deixa a listview ter mais de 100 intes, nao é necessário.

    Dim itmX As ListItem

    If ListView1.ListItems.Count > 100 Then
        ListView1.ListItems.Remove (1)
    End If
    
    Set itmX = ListView1.ListItems.Add(, , str)
    

End Sub


Private Sub cmdMigrarPasta_Click()
' Abre uma janela para escrever a pasta a ser migrada
    frmPasta.Show vbModal
End Sub

Private Sub Command1_Click()
'Continuar
   
    MigrationMain ListView1.ListItems.Item(ListView1.ListItems.Count).Text, True
    
 End Sub

Private Sub Command2_Click()
' Ver Log

    If Dir$(LOG_FILE_NAME, vbArchive) <> "" Then ' Verifica se o ficheiro de log existe
        Shell "notepad.exe " & LOG_FILE_NAME, vbNormalFocus
    Else
        MsgBox "Não existe ficheiro de log"
    End If
    
End Sub


Private Sub Form_Load()

    
   ListView1.ListItems.Clear
   ListView1.ColumnHeaders.Clear
   
   ListView1.Enabled = True
   ListView1.Checkboxes = False
   ListView1.View = lvwReport

   ListView1.ColumnHeaders.Add , , "Pasta", 3000, 0
  
   ReadLog (LOG_FILE_NAME_MARKUP)
   
   StartOfficeWorks
      
End Sub

' Verify if character is visible
' returns false if character is not visible
Public Function IsValidCharacter(ByVal InChar As String) As Boolean
Dim x As Long

    Select Case InChar
        Case vbCrLf
            IsValidCharacter = False
        Case vbTab
            IsValidCharacter = False
        Case vbCr
            IsValidCharacter = False
        Case vbLf
            IsValidCharacter = False
        Case Else
            For x = 0 To 31
                If Asc(InChar) = Asc(Chr(x)) Then
                    IsValidCharacter = False
                    Exit Function
                End If
            Next x
    
            For x = 127 To 255
                If Asc(InChar) = Asc(Chr(x)) Then
                    IsValidCharacter = False
                    Exit Function
                End If
            Next x
    End Select

    IsValidCharacter = True
End Function


Public Function TrimALL(ByVal TextIN As String) As String
' Remove todos os caracteres nao visiveis no VB
           
    TrimALL = TextIN
    Dim i As Long
        
    For i = 1 To Len(TrimALL)
        If Not IsValidCharacter(Mid(TrimALL, i, 1)) Then
            TrimALL = Left(TrimALL, i - 1)
            Exit For
        End If
    Next
 
    TrimALL = Trim(TrimALL)
    
End Function




Private Sub Form_Unload(Cancel As Integer)
    Call StopOfficeWorks
End Sub






Public Sub MigrationMain(ByVal dirs As String, Optional flagrecursivo As Boolean = True)
Dim ret  As Integer
Dim FilesCount As Long
Dim opticaldisk As String

Dim sub_dir As String ' Directory name found
Dim PathDir As String ' Complete path of directory
Dim i As Integer
Dim k As Long
Dim filename As String
Dim num As Long
Dim numErro As Long
Dim running As Boolean
Dim aDirs() As String

    ' Read directories from dir_name.
    ReDim aDirs(0) As String
    sub_dir = Dir$(dirs & "\*", vbDirectory)
    ' This array is used. Dir$ cannont be used in recursive functions. After it returns
    If flagrecursivo = True Then
        While sub_dir <> ""
            If (GetAttr(dirs & "\" & sub_dir) And vbDirectory) And _
               sub_dir <> "." And sub_dir <> ".." Then
               ReDim Preserve aDirs(UBound(aDirs) + 1) As String
               aDirs(UBound(aDirs)) = sub_dir
            End If
            sub_dir = Dir$()
        Wend
    End If
              
    k = 2
    If UBound(aDirs) > 1 Then
        sub_dir = aDirs(1)
    Else
        ' Se mão existem mais sub-directorias => terminou
        sub_dir = ""
        If Dir(dirs & "\optab.dat") <> "" Then
            ' This directory has a optab.dat file
            sub_dir = dirs
            
        End If
    End If
        
    ' Para cada subdirectoria, chamar o metodo recursivamente
    Do While sub_dir <> ""
    
        DoEvents
        If sub_dir = dirs Then
            PathDir = dirs
        Else
            PathDir = dirs & "\" & sub_dir
        End If
        StatusBar1.Panels(1).Text = PathDir
        ' If is an directoty
        If flagrecursivo = True And (GetAttr(PathDir) And vbDirectory) And _
        sub_dir <> "." And sub_dir <> ".." Then
        
            If Dir(PathDir & "\optab.dat") <> "" Then
                ' This directory has a optab.dat file
                num = 0
                ret = GetPathFiles(PathDir & "\*.*")
                FilesCount = GetPAthFilesCount()
                FilesCount = FilesCount - 1
                
                'WriteLogEx PathDir, LOG_FILE_NAME_MARKUP
                DoEvents
                Dim iError As Integer
                iError = 0
                
                'WriteLogEx "FilesCount==" & FilesCount, LOG_FILE_NAME
                
                For i = 0 To FilesCount
                    filename = TrimALL(GetFile(i))
                                        
                    DoEvents
                    If Dir(PathDir & "\" & filename) = "" Then
                        StatusBar1.Panels(1).Text = PathDir & "\" & filename
                        ret = OAP_RecuperaOpticoEx(filename, PathDir, PathDir & "\" & filename, 1)
                        DoEvents
                        If ret > 0 Then
                            ' Disco nao se encontra no servidor erro 324
                            If ret = 324 And chkDiskNotfound.Value Then
                                opticaldisk = TrimALL(GetFileDO(i))
                                If (UCase(opticaldisk) = "LOURES13") Or (UCase(opticaldisk) = "LOURES14") Then
                                    exceptionlog ret, opticaldisk, PathDir & "\" & filename
                                Else
                                    MsgBox "O disco [ " & opticaldisk & " ] não se encontra no servidor."
                                End If
                            End If
                            
                            ' Falhou a comunicação com o servidor, Sleep
                            If ret >= 400 And ret <= 409 Then
                                If chkNetwork.Value Then
                                    MsgBox "Ocorreu algum erro na rede"
                                Else
                                    StatusBar1.Panels(1).Text = "Erro na Rede estabelecer conexão novamente...."
                                    Sleep (10000)
                                End If
                            End If
                                                               
                            iError = iError + 1
                            If iError = 3 Then
                                iError = 0
                                numErro = numErro + 1
                                exceptionlog ret, opticaldisk, PathDir & "\" & filename
                                StatusBar1.Panels(1).Text = PathDir & "\" & filename & " ERROR "
                            Else
                                i = i - 1
                            End If
                            
                        Else
                            num = num + 1
                        End If
                        DoEvents
                        StatusBar1.Panels(3).Text = "Erros " & numErro
                        StatusBar1.Panels(2).Text = "Convertidos " & num & "/" & FilesCount
                    Else
                        DoEvents
                        StatusBar1.Panels(1).Text = PathDir & "\" & filename & " exists"
                    End If
                 Next
            Else ' Goto Next directory
                DoEvents
                MigrationMain PathDir, flagrecursivo
            End If
        Else ' It is not a directory
                    
        End If
        ' Get next directory or file
        'sub_dir = Dir$ '(, vbDirectory)
        If k > UBound(aDirs) Then
            sub_dir = ""
        Else
            sub_dir = aDirs(k)
        End If
        DoEvents
        k = k + 1
    Loop
    Dim S As String
    S = ""
End Sub


