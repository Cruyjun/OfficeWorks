VERSION 5.00
Begin VB.Form frmPasta 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Migrar a Pasta"
   ClientHeight    =   1035
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6270
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1035
   ScaleWidth      =   6270
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancelar 
      Caption         =   "Cancelar"
      Height          =   375
      Left            =   4920
      TabIndex        =   3
      Top             =   600
      Width           =   1215
   End
   Begin VB.CheckBox chkRecursivo 
      Caption         =   "Recursivo"
      Height          =   195
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "Confirmar"
      Height          =   375
      Left            =   4920
      TabIndex        =   1
      Top             =   120
      Width           =   1215
   End
   Begin VB.TextBox txtPath 
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   4575
   End
End
Attribute VB_Name = "frmPasta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancelar_Click()
' Cancela Operação
    
    Unload frmPasta
    
End Sub

Private Sub cmdOK_Click()

    If Dir$(txtPath.Text, vbDirectory) = "" Then
        MsgBox "O directorio não existe e/ou não é um directorio"
    Else
            
        Form1.MigraPasta txtPath.Text, chkRecursivo.Value
        
    End If
    

End Sub

