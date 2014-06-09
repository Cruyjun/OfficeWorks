VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "OfficeWorks Serial Key Generator"
   ClientHeight    =   4800
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7350
   Icon            =   "GenerateCode.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4800
   ScaleWidth      =   7350
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtOWFlow 
      Height          =   375
      Left            =   1440
      TabIndex        =   13
      Top             =   2520
      Width           =   2055
   End
   Begin VB.CommandButton btnReverse 
      Caption         =   "Reverse"
      Height          =   495
      Left            =   3240
      TabIndex        =   9
      Top             =   4200
      Width           =   1575
   End
   Begin VB.OptionButton OptionRetail 
      Caption         =   "Versão Definitiva"
      Height          =   255
      Left            =   4920
      TabIndex        =   8
      Top             =   2520
      Value           =   -1  'True
      Width           =   1695
   End
   Begin VB.OptionButton OptionTrial 
      Caption         =   "Versão Piloto"
      Height          =   255
      Left            =   4920
      TabIndex        =   7
      Top             =   2160
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Sair"
      Height          =   495
      Left            =   5640
      TabIndex        =   5
      Top             =   4200
      Width           =   1575
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Gravar no Registo"
      Height          =   495
      Left            =   1680
      TabIndex        =   4
      Top             =   4200
      Width           =   1575
   End
   Begin VB.TextBox TxtCliente 
      Height          =   405
      Left            =   1800
      TabIndex        =   2
      Top             =   1080
      Width           =   5295
   End
   Begin VB.CommandButton CmdGenerate 
      Caption         =   "Gerar Código"
      Height          =   495
      Left            =   120
      TabIndex        =   3
      Top             =   4200
      Width           =   1575
   End
   Begin VB.TextBox TxtLicencas 
      BeginProperty DataFormat 
         Type            =   0
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   2070
         SubFormatType   =   0
      EndProperty
      Height          =   405
      Left            =   1440
      TabIndex        =   1
      Top             =   2040
      Width           =   2055
   End
   Begin VB.TextBox TxtResultado 
      Height          =   405
      HideSelection   =   0   'False
      Left            =   240
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   3480
      Width           =   6855
   End
   Begin VB.Frame Frame1 
      Caption         =   "Licenças"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Index           =   0
      Left            =   120
      TabIndex        =   10
      Top             =   1680
      Width           =   4095
      Begin VB.Label Label4 
         Caption         =   "OWFlow:"
         Height          =   495
         Left            =   240
         TabIndex        =   12
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "Registo:"
         Height          =   255
         Left            =   240
         TabIndex        =   11
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Versão"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1455
      Index           =   1
      Left            =   4320
      TabIndex        =   15
      Top             =   1680
      Width           =   2895
   End
   Begin VB.Frame Frame1 
      Caption         =   "Código Gerado"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   975
      Index           =   2
      Left            =   120
      TabIndex        =   16
      Top             =   3120
      Width           =   7095
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "Serial Key Generator"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1080
      TabIndex        =   14
      Top             =   480
      Width           =   5655
   End
   Begin VB.Image Image2 
      Height          =   720
      Left            =   240
      Picture         =   "GenerateCode.frx":1CCA
      Top             =   120
      Width           =   720
   End
   Begin VB.Image Image1 
      Height          =   345
      Left            =   1080
      Picture         =   "GenerateCode.frx":380C
      Top             =   120
      Width           =   1395
   End
   Begin VB.Label Label2 
      Caption         =   "Nome do Cliente:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   6
      Top             =   1200
      Width           =   1575
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      Height          =   975
      Left            =   0
      Top             =   0
      Width           =   7335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const APP_REG_KEY = "HKLM\Software\OW\"
Private Const NUMBER_OF_USERS_REG_KEY = APP_REG_KEY & "AppID"
Private Const CHECKPARITY = "Magnetik"

'Constantes do tipo de Licença da Aplicação
Const APP_TYPE_TRIAL = 1
Const APP_TYPE_RETAIL = 2


Private Type SYSTEMTIME
  wYear As Integer
  wMonth As Integer
  wDayOfWeek As Integer
  wDay As Integer
  wHour As Integer
  wMinute As Integer
  wSecond As Integer
  wMilliseconds As Integer
End Type

Private Declare Function SetSystemTime Lib "kernel32" (lpSystemTime _
  As SYSTEMTIME) As Long
  
Private Declare Sub GetSystemTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)

Private Sub btnReverse_Click()
On Error GoTo CmdGenerateErr

    If TxtResultado.Text <> "" Then
        
            GetCode
    Else
        MsgBox "Tem de preencher a chave de activação."
    End If

Exit Sub
CmdGenerateErr:
    MsgBox "Erro ao efecutar reverse da chave " & Err.Description
End Sub

Private Sub CmdGenerate_Click()
On Error GoTo CmdGenerateErr

    If txtOWFlow.Text <> "" And TxtCliente.Text <> "" And TxtLicencas.Text <> "" Then
        If Len(TxtCliente.Text) > 3 Then
            If IsNumeric(TxtLicencas.Text) Then
                GeraCodigo
            Else
                MsgBox "O Número de Licenças tem de ser valor numérico."
            End If
        Else
            MsgBox "O Nome do Cliente tem de ter mais de 3 caracteres."
        End If
    Else
        MsgBox "Tem de preencher o número de Licenças " & vbCrLf & "e o nome da Empresa."
    End If
Exit Sub
CmdGenerateErr:
    MsgBox "Erro ao Criar a chave" & Err.Description
End Sub

Private Sub CmdSave_Click()
On Error GoTo CmdSaveErr
    Dim objWSH
    Set objWSH = CreateObject("WScript.Shell")
    
    If TxtResultado.Text = "" Then
        MsgBox ("Não existe nenhuma chave gerada!")
    Else
        objWSH.RegWrite NUMBER_OF_USERS_REG_KEY, TxtResultado.Text
    End If
Exit Sub
CmdSaveErr:
    MsgBox "Erro ao Gravar a chave" & Err.Description
End Sub


Private Sub GetCode()
Dim strCode As String
Dim aCode() As String
Dim strParidade As String
Dim sCompany As String
Dim sCompanyTemp As String
Dim i As Long
Dim sUsers As String
Dim sVerify As String
Dim code0 As String
Dim code1 As String


strCode = TxtResultado.Text
aCode = Split(strCode, "-")

strParidade = Mid(aCode(1), Len(aCode(1)) - 3, 1)
If Left(strCode, 1) = strParidade Then
    If CDbl(Left(strCode, 1)) = APP_TYPE_TRIAL Then
        'é uma licença do tipo trial
        'VerifyLicenseDate()
        MsgBox "é uma licença do tipo trial. Não implementado o reverse :))"
    Else
        'é uma licença definitiva
            'o primeiro código é os users XOR com empresa
            'o segundo código é os users XOR com o segundo código
            'o terceiro código é a empresa
            
            ' Obter o cliente
            For i = Len(aCode(2)) To 1 Step -1
                sCompanyTemp = sCompanyTemp & Mid(aCode(2), i, 1)
            Next

            For i = 1 To Len(sCompanyTemp) Step 2
                sCompany = sCompany & Chr(CInt("&H" & Mid(sCompanyTemp, i, 2)))
            Next

            TxtCliente.Text = sCompany
            'retirar o lixo....
            'o code0 começa no 2 porque o caracter 1 é de validação se é versão piloto ou não...
            'os últimos 3 caracteres de cada código são LIXO
            'o Code1 tem os ultimos 3 caracteres de lixo e o 4º a contar do fim é também a validação se é versão piloto ou não...
            code0 = Mid(aCode(0), 2, Len(aCode(0)) - 4)
            code1 = Mid(aCode(1), 1, Len(aCode(1)) - 4)

            'obter primeiro os Users
            sUsers = EncryptDecrypt(code0, sCompany)

            'obter também os users no sVerify
            sVerify = EncryptDecrypt(code1, code0)

            If sVerify = sUsers Then
                'a chave está certa
                TxtLicencas.Text = sUsers
            Else
                'a chave está errada...tem de se enviar uma msg em como a aplicação está mal instalada
                MsgBox "Chave Inválida"
            End If
        
            ' ***************************************************************************
            ' ************************* OWFlow ******************************************
            ' ***************************************************************************
            'retirar o lixo....
            'o code0 começa no 2 porque o caracter 1 é de validação se é versão piloto ou não...
            'os últimos 3 caracteres de cada código são LIXO
            'o Code1 tem os ultimos 3 caracteres de lixo e o 4º a contar do fim é também a validação se é versão piloto ou não...
            code0 = Mid(aCode(3), 2, Len(aCode(3)) - 4)
            code1 = Mid(aCode(4), 1, Len(aCode(4)) - 4)

            'obter primeiro os Users do OWFlow
            sUsers = EncryptDecrypt(code0, sCompany)

            'obter também os users do OWFlow no sVerify
            sVerify = EncryptDecrypt(code1, code0)

            If sVerify = sUsers Then
                'a chave está certa
                txtOWFlow.Text = sUsers
            Else
                'a chave está errada...tem de se enviar uma msg em como a aplicação está mal instalada
                MsgBox "Chave Inválida"
            End If
        
        
        
    End If
Else
    MsgBox "Chave inválida"
End If
End Sub


'*****************************************************************************
'Estrutura da string 32 caracteres
'
'  --> 1UUUUUUUUULLL-***********1LLL-EEEEEEEEEE
'
'L - Lixo
'U - Users (comprimento variável)
'1 - Temporária/Definitiva --> 1/2
'* - Paridade Users  (comprimento variável)
'E - Nome da empresa  (comprimento variável)
'
'*****************************************************************************
Private Sub GeraCodigo()
On Error GoTo GeraCodigoErr
Dim sUsers As String
    Dim sChaveDays As String
    Dim sChaveLicences As String
    Dim i As Integer
    Dim sUsersEncryp As String
    Dim txtClienteHex As String
    Dim lpSystemTime As SYSTEMTIME
    
    'Dim txtClienteHex2 As String
    Dim txtClienteHex3 As String
    Dim sLixo As String
    Dim sLixo2 As String
    Dim LicenceType As String
    
    ' Codifica as licenças do registo
    sUsers = TxtLicencas.Text
    sChaveLicences = EncryptDecrypt(sUsers, TxtCliente.Text)
    sUsersEncryp = EncryptDecrypt(sUsers, sChaveLicences)
            
    ' Codifica o cliente
    For i = 1 To Len(TxtCliente.Text)
        txtClienteHex = txtClienteHex & Hex(Asc(Mid(TxtCliente.Text, i, 1)))
    Next
    For i = Len(txtClienteHex) To 1 Step -1
         txtClienteHex3 = txtClienteHex3 & Mid(txtClienteHex, i, 1)
    Next
    
    sLixo = ""
    Do While Len(sLixo) < 3
        GetSystemTime lpSystemTime
        sLixo = Left(lpSystemTime.wMilliseconds, 3)
    Loop
    
    sLixo2 = ""
    'multiplica-se por 7....para gerar de uma forma simples números diferentes
    Do While Len(sLixo2) < 3
        GetSystemTime lpSystemTime
        sLixo2 = Left(lpSystemTime.wMilliseconds * 7, 3)
    Loop
    
    If OptionRetail = True Then
        LicenceType = "2"
    ElseIf OptionTrial = True Then
        LicenceType = "1"
    End If
        
    TxtResultado.Text = LicenceType & sChaveLicences & sLixo & "-" & sUsersEncryp & LicenceType & sLixo2 & "-" & txtClienteHex3
    ' **********************************************************************************
    ' *                               Licenças OWFlow                                  *
    ' **********************************************************************************
    ' Codifica as licenças do OWFLow
    sUsers = txtOWFlow.Text
    sChaveLicences = EncryptDecrypt(sUsers, TxtCliente.Text)
    sUsersEncryp = EncryptDecrypt(sUsers, sChaveLicences)
    
    TxtResultado.Text = TxtResultado.Text & "-" & LicenceType & sChaveLicences & sLixo & "-" & sUsersEncryp & LicenceType & sLixo2
    Exit Sub
    
GeraCodigoErr:
 MsgBox "Erro a gerar o código" & " - " & Err.Description
End Sub

Private Sub Command1_Click()
    Unload Me
End Sub







Private Sub TxtLicencas_KeyPress(KeyAscii As Integer)
    'MsgBox KeyAscii
    If (KeyAscii < 48 Or KeyAscii > 57) And (KeyAscii <> 8 And KeyAscii <> 13) Then
        KeyAscii = 0
    End If
    
    If KeyAscii = 13 Then CmdGenerate_Click
    
End Sub

Private Function EncryptDecrypt(inString As String, inKey As String) As String
On Error GoTo erro
    Dim a As Long
    Dim i As Long
    Dim strTemp As String
    Dim inKeyTemp As String
    'passar a inKey para um numerico
    'como são pelo menos 6 caracteres dá pelo menos 12 numéricos
    For i = 1 To Len(inKey)
        inKeyTemp = inKeyTemp & Asc(Mid(inKey, i, 1))
    Next
    
    'só usamos os primeiros 8
    If Len(inKeyTemp) > 8 Then
        inKeyTemp = Mid(inKeyTemp, 1, 8)
    End If
    
    strTemp = inString Xor inKeyTemp
    
    EncryptDecrypt = strTemp
    Exit Function
erro:
    MsgBox Err.Description
End Function

Private Sub txtOWFlow_KeyPress(KeyAscii As Integer)
'MsgBox KeyAscii
    If (KeyAscii < 48 Or KeyAscii > 57) And (KeyAscii <> 8 And KeyAscii <> 13) Then
        KeyAscii = 0
    End If
    
    If KeyAscii = 13 Then CmdGenerate_Click
End Sub
