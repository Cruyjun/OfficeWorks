VERSION 5.00
Begin VB.Form frmInfo 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   5040
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10710
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5040
   ScaleWidth      =   10710
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCloseInfo 
      Caption         =   "&Fechar"
      Height          =   315
      Left            =   4800
      TabIndex        =   15
      Top             =   4440
      Width           =   1095
   End
   Begin VB.Frame fraInfoEnt 
      Caption         =   "Informação da Entidade"
      Height          =   3855
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   10215
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   14
         Left            =   8160
         Locked          =   -1  'True
         TabIndex        =   30
         Top             =   3240
         Visible         =   0   'False
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   13
         Left            =   4920
         Locked          =   -1  'True
         TabIndex        =   29
         Top             =   3240
         Visible         =   0   'False
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   12
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   26
         Top             =   3240
         Visible         =   0   'False
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   11
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   24
         Top             =   2760
         Width           =   8325
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   10
         Left            =   8160
         Locked          =   -1  'True
         TabIndex        =   22
         Top             =   2280
         Width           =   1755
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   9
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   20
         Top             =   2280
         Width           =   5115
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   8
         Left            =   8160
         Locked          =   -1  'True
         TabIndex        =   19
         Top             =   1800
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   7
         Left            =   4920
         Locked          =   -1  'True
         TabIndex        =   16
         Top             =   1800
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   6
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   7
         Top             =   1800
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   5
         Left            =   8160
         Locked          =   -1  'True
         TabIndex        =   6
         Top             =   1320
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   4
         Left            =   4920
         Locked          =   -1  'True
         TabIndex        =   5
         Top             =   1320
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   3
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   4
         Top             =   1320
         Width           =   1725
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   2
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   3
         Top             =   840
         Width           =   8325
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   1
         Left            =   4920
         Locked          =   -1  'True
         TabIndex        =   2
         Top             =   360
         Visible         =   0   'False
         Width           =   4965
      End
      Begin VB.TextBox txtContactInfo 
         Height          =   285
         Index           =   0
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   1
         Top             =   360
         Width           =   1755
      End
      Begin VB.Label Label1 
         Caption         =   "Cargo:"
         Height          =   255
         Index           =   12
         Left            =   7080
         TabIndex        =   31
         Top             =   2280
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Distrito:"
         Height          =   255
         Index           =   11
         Left            =   3720
         TabIndex        =   28
         Top             =   3240
         Visible         =   0   'False
         Width           =   615
      End
      Begin VB.Label Label1 
         Caption         =   "Cod. Postal:"
         Height          =   255
         Index           =   10
         Left            =   240
         TabIndex        =   27
         Top             =   3240
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "País:"
         Height          =   255
         Index           =   9
         Left            =   7080
         TabIndex        =   25
         Top             =   3240
         Visible         =   0   'False
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Morada:"
         Height          =   255
         Index           =   8
         Left            =   240
         TabIndex        =   23
         Top             =   2760
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Email:"
         Height          =   255
         Index           =   7
         Left            =   240
         TabIndex        =   21
         Top             =   2280
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Fax:"
         Height          =   255
         Index           =   6
         Left            =   3720
         TabIndex        =   18
         Top             =   1800
         Width           =   615
      End
      Begin VB.Label Label1 
         Caption         =   "Telefone:"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   17
         Top             =   1800
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Telemóvel:"
         Height          =   255
         Index           =   16
         Left            =   7080
         TabIndex        =   14
         Top             =   1800
         Width           =   975
      End
      Begin VB.Label Label1 
         Caption         =   "Nome Completo:"
         Height          =   255
         Index           =   5
         Left            =   240
         TabIndex        =   13
         Top             =   840
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Ultimo Nome:"
         Height          =   255
         Index           =   4
         Left            =   7080
         TabIndex        =   12
         Top             =   1320
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "Outros Nomes:"
         Height          =   255
         Index           =   3
         Left            =   3720
         TabIndex        =   11
         Top             =   1320
         Width           =   1455
      End
      Begin VB.Label Label1 
         Caption         =   "Primeiro Nome:"
         Height          =   255
         Index           =   2
         Left            =   240
         TabIndex        =   10
         Top             =   1320
         Width           =   1215
      End
      Begin VB.Label Label1 
         Caption         =   "Codigo:"
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   9
         Top             =   360
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "Lista:"
         Height          =   255
         Index           =   23
         Left            =   3720
         TabIndex        =   8
         Top             =   360
         Visible         =   0   'False
         Width           =   975
      End
   End
End
Attribute VB_Name = "frmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCloseInfo_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Me.Icon = frmMain.Icon
    Me.Caption = kTITULO_MSG & kTITULO_MSG_ENT
    'Codigo
    txtContactInfo(0).Text = stEntityAll.lID
    'Lista
    txtContactInfo(1).Text = IIf(stEntityAll.sListID = "NULL", "", stEntityAll.sListID)
    'Nome completo
    txtContactInfo(2).Text = stEntityAll.sFullName
    'Primeiro nome
    txtContactInfo(3).Text = IIf(stEntityAll.sFirstName = "NULL", "", stEntityAll.sFirstName)
    'Outros Nomes
    txtContactInfo(4).Text = IIf(stEntityAll.sMiddleName = "NULL", "", stEntityAll.sMiddleName)
    'Ultimo nome
    txtContactInfo(5).Text = IIf(stEntityAll.sLastName = "NULL", "", stEntityAll.sLastName)
    'Telefone
    txtContactInfo(6).Text = IIf(stEntityAll.sPhone = "NULL", "", stEntityAll.sPhone)
    'Fax
    txtContactInfo(7).Text = IIf(stEntityAll.sFax = "NULL", "", stEntityAll.sFax)
    'Telemovel
    txtContactInfo(8).Text = IIf(stEntityAll.sMobile = "NULL", "", stEntityAll.sMobile)
    'Email
    txtContactInfo(9).Text = IIf(stEntityAll.seMail = "NULL", "", stEntityAll.seMail)
    'Cargo
    txtContactInfo(10).Text = IIf(stEntityAll.sJobTitle = "NULL", "", stEntityAll.sJobTitle)
    'Morada
    txtContactInfo(11).Text = IIf(stEntityAll.sStreet = "NULL", "", stEntityAll.sStreet)
    'Codigo Postal
    txtContactInfo(12).Text = IIf(stEntityAll.sPostalCodeID = "NULL", "", stEntityAll.sPostalCodeID)
    'Distrito
    txtContactInfo(13).Text = IIf(stEntityAll.sDistrictID = "NULL", "", stEntityAll.sDistrictID)
    'País
    txtContactInfo(14).Text = IIf(stEntityAll.sCountryID = "NULL", "", stEntityAll.sCountryID)
End Sub
