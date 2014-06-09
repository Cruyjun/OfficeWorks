VERSION 5.00
Begin VB.Form frmMessage 
   BackColor       =   &H00E0E0E0&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   1965
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   4785
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   MouseIcon       =   "frmMessage.frx":0000
   ScaleHeight     =   1965
   ScaleWidth      =   4785
   StartUpPosition =   2  'CenterScreen
   Begin VB.Image imgExitMessage 
      Height          =   255
      Left            =   4450
      Picture         =   "frmMessage.frx":030A
      Stretch         =   -1  'True
      ToolTipText     =   "Fechar"
      Top             =   40
      Width           =   285
   End
   Begin VB.Label lblMessage 
      BackStyle       =   0  'Transparent
      Caption         =   "Message"
      Height          =   1200
      Left            =   900
      TabIndex        =   1
      Top             =   640
      Width           =   3450
      WordWrap        =   -1  'True
   End
   Begin VB.Label lblMessageTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Title"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   4000
   End
   Begin VB.Label lblMessageError 
      BackStyle       =   0  'Transparent
      Caption         =   "Error Message"
      Height          =   1200
      Left            =   900
      TabIndex        =   2
      Top             =   640
      Visible         =   0   'False
      Width           =   3450
      WordWrap        =   -1  'True
   End
   Begin VB.Image imgMessageNone 
      Height          =   510
      Left            =   240
      Picture         =   "frmMessage.frx":0698
      Top             =   600
      Width           =   510
   End
   Begin VB.Image imgMessageInformation 
      Height          =   510
      Left            =   240
      Picture         =   "frmMessage.frx":0A00
      Top             =   600
      Width           =   510
   End
   Begin VB.Image imgMessageQuestion 
      Height          =   510
      Left            =   240
      Picture         =   "frmMessage.frx":0E13
      Top             =   600
      Width           =   510
   End
   Begin VB.Image imgMessageExclamation 
      Height          =   510
      Left            =   240
      Picture         =   "frmMessage.frx":1233
      ToolTipText     =   "Click para ver detalhe do erro"
      Top             =   600
      Width           =   510
   End
   Begin VB.Image imgMessageCritical 
      Height          =   510
      Left            =   240
      Picture         =   "frmMessage.frx":163F
      ToolTipText     =   "Click para ver detalhe do erro"
      Top             =   600
      Width           =   510
   End
End
Attribute VB_Name = "frmMessage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbDefault
End Sub


Private Sub imgMessageCritical_Click()
    lblMessage.Visible = Not lblMessage.Visible
    lblMessageError.Visible = Not lblMessageError.Visible
    If lblMessage.Visible Then
        imgMessageCritical.ToolTipText = "Click para ver detalhe do erro"
    Else
        imgMessageCritical.ToolTipText = "Click para esconder detalhe do erro"
    End If
End Sub


Private Sub imgMessageCritical_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbCustom
End Sub


Private Sub imgMessageExclamation_Click()
    lblMessage.Visible = Not lblMessage.Visible
    lblMessageError.Visible = Not lblMessageError.Visible
    If lblMessage.Visible Then
        imgMessageExclamation.ToolTipText = "Click para ver detalhe do erro"
    Else
        imgMessageExclamation.ToolTipText = "Click para esconder detalhe do erro"
    End If
End Sub


Private Sub imgMessageExclamation_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbCustom
End Sub


Private Sub imgExitMessage_Click()
    CloseForm
End Sub


Private Sub CloseForm()
    Unload Me
End Sub


Private Sub imgExitMessage_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbCustom
End Sub


Private Sub lblMessage_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbDefault
End Sub


Private Sub lblMessageError_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbDefault
End Sub


Private Sub lblMessageTitle_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MousePointer = vbDefault
End Sub
