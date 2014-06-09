VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMain 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   7830
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11910
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   7830
   ScaleWidth      =   11910
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraImage 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   1335
      Left            =   0
      TabIndex        =   74
      Top             =   0
      Width           =   1.18710e5
      Begin VB.Label lblFullVersion 
         BackStyle       =   0  'Transparent
         Caption         =   "lblFullVersion"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   6.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   180
         Left            =   915
         TabIndex        =   75
         Top             =   1080
         Width           =   4815
      End
      Begin VB.Image Image1 
         Height          =   1290
         Left            =   0
         Picture         =   "frmMain.frx":22A2
         Top             =   0
         Width           =   9750
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Fechar"
      Height          =   315
      Left            =   600
      TabIndex        =   8
      Top             =   7200
      Width           =   1335
   End
   Begin VB.Frame fraOpcoesManutencao 
      Caption         =   "Op��es"
      Height          =   5535
      Left            =   120
      TabIndex        =   9
      Top             =   1440
      Width           =   2295
      Begin VB.OptionButton optOption 
         Caption         =   "Alterar C�digo Entidade"
         Height          =   375
         Index           =   4
         Left            =   120
         TabIndex        =   57
         Top             =   2400
         Width           =   2055
      End
      Begin VB.OptionButton optOption 
         Caption         =   "Ent. n�o Referenciadas"
         Height          =   375
         Index           =   3
         Left            =   120
         TabIndex        =   45
         Top             =   1920
         Width           =   2055
      End
      Begin VB.OptionButton optOption 
         Caption         =   "Entidades Id�nticas"
         Height          =   255
         Index           =   2
         Left            =   120
         TabIndex        =   39
         Top             =   1440
         Width           =   2055
      End
      Begin VB.OptionButton optOption 
         Caption         =   "Entidades Duplicadas"
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   1
         Top             =   960
         Width           =   2055
      End
      Begin VB.OptionButton optOption 
         Caption         =   "Servidor Entidades"
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   0
         Top             =   480
         Width           =   2055
      End
   End
   Begin MSComctlLib.ProgressBar pgbProgress 
      Height          =   255
      Left            =   2520
      TabIndex        =   13
      Top             =   7440
      Width           =   9255
      _ExtentX        =   16325
      _ExtentY        =   450
      _Version        =   393216
      Appearance      =   1
      Scrolling       =   1
   End
   Begin VB.Frame fraOption 
      Caption         =   "Liga��o ao Servidor das Entidades"
      Height          =   5535
      Index           =   0
      Left            =   2520
      TabIndex        =   10
      Top             =   1440
      Width           =   9255
      Begin VB.TextBox txtTimeoutCnn 
         Alignment       =   2  'Center
         Height          =   315
         Left            =   1320
         MaxLength       =   4
         TabIndex        =   6
         Top             =   1800
         Width           =   615
      End
      Begin VB.TextBox txtDataBase 
         Height          =   315
         Left            =   1320
         TabIndex        =   3
         Top             =   840
         Width           =   6255
      End
      Begin VB.TextBox txtLogin 
         Height          =   315
         Left            =   1320
         TabIndex        =   4
         Top             =   1320
         Width           =   1455
      End
      Begin VB.TextBox txtPassword 
         Height          =   315
         IMEMode         =   3  'DISABLE
         Left            =   4080
         PasswordChar    =   "*"
         TabIndex        =   5
         Top             =   1320
         Width           =   1335
      End
      Begin VB.TextBox txtServer 
         Height          =   315
         Left            =   1320
         TabIndex        =   2
         Top             =   360
         Width           =   6255
      End
      Begin VB.CommandButton cmdConnectDB 
         Caption         =   "&Ligar"
         Height          =   315
         Left            =   7800
         TabIndex        =   7
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label Label2 
         Caption         =   "segundos"
         Height          =   255
         Left            =   2040
         TabIndex        =   73
         Top             =   1845
         Width           =   735
      End
      Begin VB.Label Label1 
         Caption         =   "Timeout:"
         Height          =   255
         Left            =   240
         TabIndex        =   72
         Top             =   1845
         Width           =   855
      End
      Begin VB.Label Label12 
         Caption         =   "Base Dados:"
         Height          =   255
         Left            =   240
         TabIndex        =   18
         Top             =   885
         Width           =   1215
      End
      Begin VB.Label Label11 
         Caption         =   "Utilizador:"
         Height          =   255
         Left            =   240
         TabIndex        =   17
         Top             =   1365
         Width           =   855
      End
      Begin VB.Label Label10 
         Caption         =   "Password:"
         Height          =   255
         Left            =   3240
         TabIndex        =   16
         Top             =   1365
         Width           =   855
      End
      Begin VB.Label Label9 
         Caption         =   "Servidor:"
         Height          =   255
         Left            =   240
         TabIndex        =   15
         Top             =   405
         Width           =   855
      End
   End
   Begin VB.Frame fraOption 
      Caption         =   "Actualizar Entidades Duplicadas"
      Height          =   5535
      Index           =   1
      Left            =   2520
      TabIndex        =   11
      Top             =   1440
      Width           =   9255
      Begin VB.CommandButton cmdExportarAED 
         Caption         =   "&Exportar"
         Height          =   315
         Left            =   7800
         TabIndex        =   86
         Top             =   4200
         Width           =   1215
      End
      Begin MSComctlLib.ListView lvwAED 
         Height          =   4215
         Left            =   240
         TabIndex        =   43
         Top             =   360
         Width           =   7335
         _ExtentX        =   12938
         _ExtentY        =   7435
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         AllowReorder    =   -1  'True
         Checkboxes      =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.TextBox txtServerAED 
         Height          =   315
         Left            =   7800
         TabIndex        =   27
         Top             =   2400
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.Frame Frame1 
         BorderStyle     =   0  'None
         Height          =   285
         Left            =   240
         TabIndex        =   24
         Top             =   5040
         Width           =   7335
         Begin VB.OptionButton optUpdManualAED 
            Caption         =   "Actualiza��o Manual"
            Height          =   255
            Left            =   0
            TabIndex        =   26
            Top             =   0
            Width           =   2055
         End
         Begin VB.OptionButton optUpdAutoAED 
            Caption         =   "Actualiza��o Automatica"
            Height          =   255
            Left            =   3240
            TabIndex        =   25
            Top             =   0
            Width           =   2055
         End
      End
      Begin VB.CommandButton cmdUpdAED 
         Caption         =   "&Actualizar"
         Height          =   315
         Left            =   7800
         TabIndex        =   23
         Top             =   1320
         Width           =   1215
      End
      Begin VB.CommandButton cmdInfoAED 
         Caption         =   "&Info"
         Height          =   315
         Left            =   7800
         TabIndex        =   22
         Top             =   840
         Width           =   1215
      End
      Begin VB.CommandButton cmdListarAED 
         Caption         =   "&Listar Ents."
         Height          =   315
         Left            =   7800
         TabIndex        =   21
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdLogFileAED 
         Caption         =   "&Ver Log"
         Height          =   315
         Left            =   7800
         TabIndex        =   20
         Top             =   1800
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.Label lblTotalAED 
         Alignment       =   1  'Right Justify
         Caption         =   "lbltotal"
         Height          =   255
         Left            =   240
         TabIndex        =   28
         Top             =   4680
         Width           =   7335
      End
   End
   Begin VB.Frame fraOption 
      Caption         =   "Apagar Entidades n�o Referenciadas"
      Height          =   5535
      Index           =   3
      Left            =   2520
      TabIndex        =   46
      Top             =   1440
      Width           =   9255
      Begin VB.CommandButton cmdExportarENR 
         Caption         =   "&Exportar"
         Height          =   315
         Left            =   7800
         TabIndex        =   88
         Top             =   4200
         Width           =   1215
      End
      Begin VB.CommandButton cmdlogFileENR 
         Caption         =   "&Ver Log"
         Height          =   315
         Left            =   7800
         TabIndex        =   55
         Top             =   1800
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.CommandButton cmdListarENR 
         Caption         =   "&Listar Ents."
         Height          =   315
         Left            =   7800
         TabIndex        =   54
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdInfoENR 
         Caption         =   "&Info"
         Height          =   315
         Left            =   7800
         TabIndex        =   53
         Top             =   840
         Width           =   1215
      End
      Begin VB.CommandButton cmdDelENR 
         Caption         =   "&Apagar"
         Height          =   315
         Left            =   7800
         TabIndex        =   52
         Top             =   1320
         Width           =   1215
      End
      Begin VB.Frame Frame2 
         BorderStyle     =   0  'None
         Height          =   285
         Left            =   240
         TabIndex        =   49
         Top             =   5040
         Width           =   7335
         Begin VB.OptionButton optDelAllENR 
            Caption         =   "Apagar Todas"
            Height          =   255
            Left            =   3240
            TabIndex        =   51
            Top             =   0
            Width           =   2055
         End
         Begin VB.OptionButton optDelSelectENR 
            Caption         =   "Apagar Seleccionadas"
            Height          =   255
            Left            =   0
            TabIndex        =   50
            Top             =   0
            Width           =   2055
         End
      End
      Begin VB.TextBox txtServerENR 
         Height          =   315
         Left            =   7800
         TabIndex        =   48
         Top             =   2400
         Visible         =   0   'False
         Width           =   1215
      End
      Begin MSComctlLib.ListView lvwENR 
         Height          =   4215
         Left            =   240
         TabIndex        =   47
         Top             =   360
         Width           =   7335
         _ExtentX        =   12938
         _ExtentY        =   7435
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         AllowReorder    =   -1  'True
         Checkboxes      =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label lblTotalENR 
         Alignment       =   1  'Right Justify
         Caption         =   "lbltotal"
         Height          =   255
         Left            =   240
         TabIndex        =   56
         Top             =   4680
         Width           =   7335
      End
   End
   Begin VB.Frame fraOption 
      Caption         =   "Altera��o do C�digo da Entidade"
      Height          =   5535
      Index           =   4
      Left            =   2520
      TabIndex        =   58
      Top             =   1440
      Width           =   9255
      Begin VB.CommandButton cmdLogFileACE 
         Caption         =   "&Ver Log"
         Height          =   315
         Left            =   7800
         TabIndex        =   71
         Top             =   2280
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.CommandButton cmdInfoACE 
         Caption         =   "&Info"
         Height          =   315
         Left            =   7800
         TabIndex        =   70
         Top             =   840
         Width           =   1215
      End
      Begin VB.CommandButton cmdClearEnt 
         Caption         =   "&Limpar"
         Height          =   315
         Left            =   7800
         TabIndex        =   68
         Top             =   1800
         Width           =   1215
      End
      Begin VB.TextBox txtNomeEntidade 
         Enabled         =   0   'False
         Height          =   1755
         Left            =   1320
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   64
         Top             =   840
         Width           =   6255
      End
      Begin VB.TextBox txtCodigoEntidade 
         Height          =   315
         Left            =   1320
         MaxLength       =   9
         TabIndex        =   63
         Top             =   360
         Width           =   1215
      End
      Begin VB.TextBox txtServerACE 
         Enabled         =   0   'False
         Height          =   315
         Left            =   7800
         TabIndex        =   62
         Top             =   2760
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.CommandButton cmdSearchEnt 
         Caption         =   "&Pesquisar"
         Height          =   315
         Left            =   7800
         TabIndex        =   61
         Top             =   360
         Width           =   1215
      End
      Begin VB.TextBox txtNovoCodigoEntidade 
         Enabled         =   0   'False
         Height          =   315
         Left            =   4200
         MaxLength       =   9
         TabIndex        =   60
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdModifyEnt 
         Caption         =   "&Alterar"
         Height          =   315
         Left            =   7800
         TabIndex        =   59
         Top             =   1320
         Width           =   1215
      End
      Begin VB.Label Label3 
         Caption         =   "Nome:"
         Height          =   255
         Left            =   240
         TabIndex        =   67
         Top             =   885
         Width           =   855
      End
      Begin VB.Label Label4 
         Caption         =   "C�digo:"
         Height          =   255
         Left            =   240
         TabIndex        =   66
         Top             =   405
         Width           =   855
      End
      Begin VB.Label Label5 
         Caption         =   "Novo C�digo:"
         Height          =   255
         Left            =   3000
         TabIndex        =   65
         Top             =   405
         Width           =   1095
      End
   End
   Begin VB.Frame fraOption 
      Caption         =   "Definir Entidades Id�nticas e Actualizar"
      Height          =   5535
      Index           =   2
      Left            =   2520
      TabIndex        =   29
      Top             =   1440
      Width           =   9255
      Begin VB.TextBox txtFilter 
         Height          =   315
         Left            =   7800
         TabIndex        =   89
         ToolTipText     =   "Filtro"
         Top             =   2280
         Width           =   1215
      End
      Begin VB.CommandButton cmdExportarDEI 
         Caption         =   "&Exportar"
         Height          =   315
         Left            =   7800
         TabIndex        =   87
         Top             =   4920
         Width           =   1215
      End
      Begin VB.CommandButton cmdGoToPage 
         Caption         =   "Ir"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   7080
         TabIndex        =   84
         ToolTipText     =   "Ir para a  P�gina indicada"
         Top             =   2280
         Width           =   495
      End
      Begin VB.TextBox txtGoToPage 
         Alignment       =   2  'Center
         Height          =   285
         Left            =   6360
         MaxLength       =   9
         TabIndex        =   83
         Top             =   2280
         Width           =   615
      End
      Begin VB.CommandButton cmdFirst 
         Caption         =   "|<"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   3360
         TabIndex        =   80
         ToolTipText     =   "Primeira P�gina"
         Top             =   2280
         Width           =   495
      End
      Begin VB.CommandButton cmdPrevious 
         Caption         =   "<<"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   3960
         TabIndex        =   79
         ToolTipText     =   "P�gina Anterior"
         Top             =   2280
         Width           =   495
      End
      Begin VB.CommandButton cmdNext 
         Caption         =   ">>"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   4560
         TabIndex        =   78
         ToolTipText     =   "P�gina Seguinte"
         Top             =   2280
         Width           =   495
      End
      Begin VB.CommandButton cmdLast 
         Caption         =   ">|"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   5160
         TabIndex        =   77
         ToolTipText     =   "Ultima P�gina"
         Top             =   2280
         Width           =   495
      End
      Begin VB.CommandButton cmdInfoDEI 
         Caption         =   "&Info"
         Height          =   315
         Left            =   7800
         TabIndex        =   41
         Top             =   840
         Width           =   1215
      End
      Begin VB.CommandButton cmdDelNodeDEI 
         Caption         =   "&Retirar"
         Height          =   315
         Left            =   7800
         TabIndex        =   38
         Top             =   2760
         Width           =   1215
      End
      Begin VB.CommandButton cmdAddChildDEI 
         Caption         =   "&Identica"
         Height          =   315
         Left            =   7800
         TabIndex        =   37
         Top             =   1800
         Width           =   1215
      End
      Begin VB.CommandButton cmdAddRootDEI 
         Caption         =   "&Principal"
         Height          =   315
         Left            =   7800
         TabIndex        =   36
         Top             =   1320
         Width           =   1215
      End
      Begin MSComctlLib.TreeView trvDEI 
         Height          =   2535
         Left            =   240
         TabIndex        =   35
         Top             =   2760
         Width           =   7335
         _ExtentX        =   12938
         _ExtentY        =   4471
         _Version        =   393217
         Indentation     =   529
         LineStyle       =   1
         Style           =   6
         FullRowSelect   =   -1  'True
         Appearance      =   1
      End
      Begin VB.CommandButton cmdLogFileDEI 
         Caption         =   "&Ver Log"
         Height          =   315
         Left            =   7800
         TabIndex        =   33
         Top             =   3720
         Visible         =   0   'False
         Width           =   1215
      End
      Begin VB.CommandButton cmdListarDEI 
         Caption         =   "&Listar Ents."
         Height          =   315
         Left            =   7800
         TabIndex        =   32
         Top             =   360
         Width           =   1215
      End
      Begin VB.CommandButton cmdUpdDEI 
         Caption         =   "&Actualizar"
         Height          =   315
         Left            =   7800
         TabIndex        =   31
         Top             =   3240
         Width           =   1215
      End
      Begin VB.TextBox txtServerDEI 
         Height          =   315
         Left            =   7800
         TabIndex        =   30
         Top             =   4200
         Visible         =   0   'False
         Width           =   1215
      End
      Begin MSComctlLib.ListView lvwDEI 
         Height          =   1875
         Left            =   240
         TabIndex        =   44
         Top             =   360
         Width           =   7335
         _ExtentX        =   12938
         _ExtentY        =   3307
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         AllowReorder    =   -1  'True
         Checkboxes      =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label Label6 
         Caption         =   "P�g.:"
         Height          =   255
         Left            =   5880
         TabIndex        =   85
         Top             =   2325
         Width           =   495
      End
      Begin VB.Label lblTotalPagesDEILabel 
         Caption         =   "P�gina:"
         Height          =   255
         Left            =   1680
         TabIndex        =   82
         Top             =   2325
         Visible         =   0   'False
         Width           =   615
      End
      Begin VB.Label lblTotalDEILabel 
         Caption         =   "Total:"
         Height          =   255
         Left            =   240
         TabIndex        =   81
         Top             =   2325
         Visible         =   0   'False
         Width           =   495
      End
      Begin VB.Label lblTotalPagesDEI 
         Alignment       =   1  'Right Justify
         Caption         =   "1000/1000"
         Height          =   255
         Left            =   2280
         TabIndex        =   76
         Top             =   2325
         Width           =   855
      End
      Begin VB.Label lblTotalDEI 
         Caption         =   "1000000"
         Height          =   255
         Left            =   720
         TabIndex        =   34
         Top             =   2325
         Width           =   735
      End
   End
   Begin VB.Label lblVersion 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "*"
      ForeColor       =   &H80000011&
      Height          =   135
      Left            =   11800
      TabIndex        =   12
      Top             =   7720
      Width           =   135
   End
   Begin VB.Label lblProgressDEI 
      Caption         =   "lblProgressDEI ..."
      Height          =   255
      Left            =   2520
      TabIndex        =   40
      Top             =   7200
      Width           =   9255
   End
   Begin VB.Label lblProgressAED 
      Caption         =   "lblProgressAED ..."
      Height          =   255
      Left            =   2520
      TabIndex        =   14
      Top             =   7200
      Width           =   9255
   End
   Begin VB.Label lblProgressENR 
      Caption         =   "lblProgressENR ..."
      Height          =   255
      Left            =   2520
      TabIndex        =   42
      Top             =   7200
      Width           =   9255
   End
   Begin VB.Label lblProgressACE 
      Caption         =   "lblProgressACE ..."
      Height          =   255
      Left            =   2520
      TabIndex        =   69
      Top             =   7200
      Width           =   9255
   End
   Begin VB.Label lblProgressSrv 
      Caption         =   "lblProgressSrv ..."
      Height          =   255
      Left            =   2520
      TabIndex        =   19
      Top             =   7200
      Width           =   9255
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub cmdExportarAED_Click()
    Dim sErro As String
        
    cmdListarAED.Enabled = False
    
    ''Exportar lista entidades duplicadas
    lblProgressAED.Caption = "A exportar a lista de entidades duplicadas ..."
    Me.Refresh
    Screen.MousePointer = vbHourglass
    ExportaListEnts kAED
    Screen.MousePointer = vbDefault
    lblProgressAED.Caption = "Exporta��o da lista de entidades duplicadas terminada."
    Me.Refresh
    
    cmdListarAED.Enabled = True
End Sub

Private Sub cmdExportarDEI_Click()
    Dim sErro As String
        
    cmdListarDEI.Enabled = False
    
    ''Exportar lista entidades identicas
    lblProgressDEI.Caption = "A exportar a lista de entidades id�nticas ..."
    Me.Refresh
    Screen.MousePointer = vbHourglass
    ExportaListEnts kDEI
    Screen.MousePointer = vbDefault
    lblProgressDEI.Caption = "Exporta��o da lista de entidades id�nticas terminada."
    Me.Refresh
    
    cmdListarDEI.Enabled = True

End Sub

Private Sub cmdExportarENR_Click()
    Dim sErro As String
        
    cmdListarENR.Enabled = False
    
    ''Exportar lista entidades nao referenciadas
    lblProgressENR.Caption = "A exportar a lista de entidades n�o referenciadas ..."
    Me.Refresh
    Screen.MousePointer = vbHourglass
    ExportaListEnts kENR
    Screen.MousePointer = vbDefault
    lblProgressENR.Caption = "Exporta��o da lista de entidades n�o referenciadas terminada."
    Me.Refresh
    
    cmdListarENR.Enabled = True

End Sub

''********** Servidor das entidades **********''
''Servidor
Private Sub txtServer_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then cmdConnectDB_Click
    SetValueUpperOrLowerCase KeyAscii, kTO_UPPERCASE
End Sub


Private Sub txtServer_GotFocus()
    SelectTxtValue txtServer
End Sub


''Base de dados
Private Sub txtDataBase_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then cmdConnectDB_Click
    SetValueUpperOrLowerCase KeyAscii, kTO_UPPERCASE
End Sub


Private Sub txtDataBase_GotFocus()
    SelectTxtValue txtDataBase
End Sub


''Login do utilizador para o sql
Private Sub txtLogin_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then cmdConnectDB_Click
End Sub


Private Sub txtLogin_GotFocus()
    SelectTxtValue txtLogin
End Sub


''Password do utilizador para o sql
Private Sub txtPassword_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then cmdConnectDB_Click
End Sub


Private Sub txtPassword_GotFocus()
    SelectTxtValue txtPassword
End Sub


''Timeout da liga��o ao servidor
Private Sub txtTimeoutCnn_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        cmdConnectDB_Click
        Exit Sub
    End If
    ValidateInteger KeyAscii
End Sub


Private Sub txtTimeoutCnn_GotFocus()
    SelectTxtValue txtTimeoutCnn
End Sub


''Efectuar liga��o a BD
Private Sub cmdConnectDB_Click()
    Dim sUserFullInfo As String
        
    ''Estado dos controls para efectuar ou terminar a liga��o
    If cmdConnectDB.Caption = kCAPTION_DISCONNECT Then
        cmdConnectDB.Caption = kCAPTION_CONNECT
        txtServer.Enabled = True
        txtServerAED.Text = ""
        txtServerDEI.Text = ""
        txtServerENR.Text = ""
        txtServerACE.Text = ""
        txtDataBase.Enabled = True
        txtTimeoutCnn.Enabled = True
        lvwAED.ListItems.Clear
        lvwDEI.ListItems.Clear
        lvwENR.ListItems.Clear
        trvDEI.Nodes.Clear
        Set objCnn = Nothing
        TrataFrames kOPT_DEFAULT
        Exit Sub
    End If
    ''Validar servidor
    If Len(Trim(txtServer.Text)) = 0 Then
        MsgBox "Indique o nome do Servidor!", vbExclamation, kTITULO_MSG & kTITULO_MSG_SRV
        Exit Sub
    End If
    ''Validar base de dados
    If Len(Trim(txtDataBase.Text)) = 0 Then
        MsgBox "Indique o nome da Base de Dados!", vbExclamation, kTITULO_MSG & kTITULO_MSG_SRV
        Exit Sub
    End If
    ''Validar utilizador
    If Len(Trim(txtLogin.Text)) = 0 Then
        MsgBox "Indique o Login do utilizador!", vbExclamation, kTITULO_MSG & kTITULO_MSG_SRV
        Exit Sub
    End If
    ''Validar timeout
    If Len(Trim(txtTimeoutCnn.Text)) = 0 Then
        txtTimeoutCnn.Text = kTIMEOUT_CONNECTION
    End If
    ''Dados da liga��o
    sServerName = Trim(txtServer.Text)
    sDBName = Trim(txtDataBase.Text)
    sLogin = Trim(txtLogin.Text)
    sPwd = IIf(txtPassword.Text = kTEXT_PWD, kSQL_PWD, txtPassword.Text)
    lTimeout = CLng(Trim(txtTimeoutCnn.Text))
    lblProgressSrv.Caption = "A ligar ao servidor ..."
    ''Connect to DataBase on Server
    Screen.MousePointer = vbHourglass
    If ConnectToDB Then
        Screen.MousePointer = vbDefault
        cmdConnectDB.Caption = kCAPTION_DISCONNECT
        ''Validar vers�o da base de dados
        Screen.MousePointer = vbHourglass
        sDBVersion = GetDBVersion
        Screen.MousePointer = vbDefault
        If Not VerifyDBVersion(sDBVersion) Then
            MsgBox "A aplica��o n�o � compativel com a vers�o " & sDBVersion & " do OfficeWorks!" & vbNewLine & "A vers�o compativel � a vers�o " & kDB_VERSION & "!" & vbNewLine & vbNewLine & "A aplica��o vai ser encerrada!", vbExclamation, kTITULO_MSG
            End
        End If
        ''Validar se o utilizador pertence ao OfficeWorks
        Screen.MousePointer = vbHourglass
        If Not IsOfficeWorksUser Then
            Screen.MousePointer = vbDefault
            MsgBox "O utilizador '" & sUserLogin & "' n�o � utilizador do OfficeWorks!" & vbNewLine & vbNewLine & "A aplica��o vai ser encerrada!", vbExclamation, kTITULO_MSG
            End
        End If
        Screen.MousePointer = vbDefault
        ''Estado e valor dos controls
        txtServer.Enabled = False
        txtServerAED.Text = sServerName
        txtServerDEI.Text = sServerName
        txtServerENR.Text = sServerName
        txtServerACE.Text = sServerName
        txtDataBase.Enabled = False
        txtTimeoutCnn.Enabled = False
        TrataFrames kOPT_DEFAULT
        lblProgressSrv.Caption = "O utilizador '" & stUserInfo.sOfficeWorksLogin & "' est� ligado ao servidor '" & sServerName & "'"
    Else
        Screen.MousePointer = vbDefault
        lblProgressSrv.Caption = "N�o foi poss�vel efectuar a liga��o ao servidor '" & sServerName & "'"
    End If
End Sub


''********** Entidades Duplicadas **********''
''Listar entidades duplicadas
Private Sub cmdListarAED_Click()
    Dim sErro As String
    
    optUpdManualAED.Enabled = False
    optUpdAutoAED.Enabled = False
    cmdInfoAED.Enabled = False
    cmdUpdAED.Enabled = False
    cmdExportarAED.Enabled = False
    ''Preencher lista entidades duplicadas
    lblProgressAED.Caption = "A preencher a lista de entidades duplicadas ..."
    Me.Refresh
    Screen.MousePointer = vbHourglass
    PreencheListEnts kAED, lvwAED, lblTotalAED, sErro
    Screen.MousePointer = vbDefault
    lblProgressAED.Caption = "Preenchimento da lista de entidades duplicadas terminado."
    Me.Refresh
    ''Validar estado dos botoes
    If lvwAED.ListItems.Count > 0 Then
        optUpdManualAED.Enabled = True
        optUpdAutoAED.Enabled = True
        cmdInfoAED.Enabled = True
        cmdUpdAED.Enabled = True
        cmdExportarAED.Enabled = True
    Else
        If sErro = "" Then lblProgressAED.Caption = "N�o foram encontradas entidades duplicadas!"
    End If
End Sub


''informa��o da entidade
Private Sub cmdInfoAED_Click()
    Screen.MousePointer = vbHourglass
    GetInfo lvwAED.SelectedItem.SubItems(1)
    Screen.MousePointer = vbDefault
End Sub


''Actualizar entidades duplicadas
Private Sub cmdUpdAED_Click()
    If MsgBox("Aten��o! Deseja mesmo efectuar a actualiza��o das entidades duplicadas?", vbQuestion + vbYesNo, kTITULO_MSG & kTITULO_MSG_ENT) = vbNo Then
        Exit Sub
    End If
    cmdUpdAED.Enabled = False
    cmdInfoAED.Enabled = False
    cmdListarAED.Enabled = False
    fraOpcoesManutencao.Enabled = False
    ''Obter ids para actualiza��o
    GetEntitiesIdsForUpdate
    fraOpcoesManutencao.Enabled = True
    cmdListarAED.Enabled = True
End Sub


''Obter ids das entidades duplicadas para actualizar
Private Function GetEntitiesIdsForUpdate() As Boolean
    Dim lX As Long
    Dim lY As Long
    Dim lz As Long
    Dim lQtdEnts As Long
    Dim sTipo As String
    Dim sMsg As String
    Dim sErro As String
    
    DoEvents
    lX = 0
    lz = 0
    ''Manual update
    If optUpdManualAED.Value = True Then
        ''Check entities for update
        lblProgressAED.Caption = "A verificar entidades para actualiza��o ..."
        Screen.MousePointer = vbHourglass
        If Not CheckEntities(lvwAED, lblProgressAED) Then
            cmdUpdAED.Enabled = True
            cmdInfoAED.Enabled = True
            Screen.MousePointer = vbDefault
            Exit Function
        End If
        Screen.MousePointer = vbDefault
        ''Get select entities for update
        lblProgressAED.Caption = "A obter entidades para actualiza��o manual ..."
        Screen.MousePointer = vbHourglass
        GetEntitiesSel lQtdEnts, lvwAED
        Screen.MousePointer = vbDefault
        lblProgressAED.Caption = ""
        sTipo = "manual"
    Else
        ''Automatic update
        If MsgBox("Aten��o! A aplica��o vai escolher uma entidade e eliminar as duplicadas! Deseja continuar?", vbQuestion + vbYesNo, kTITULO_MSG & kTITULO_MSG_ENT) = vbNo Then
            cmdUpdAED.Enabled = True
            cmdInfoAED.Enabled = True
            Screen.MousePointer = vbDefault
            Exit Function
        End If
        ''Get all entities for update
        lblProgressAED.Caption = "A obter entidades para actualiza��o autom�tica ..."
        Screen.MousePointer = vbHourglass
        GetEntitiesAuto lQtdEnts, lvwAED
        Screen.MousePointer = vbDefault
        lblProgressAED.Caption = ""
        sTipo = "autom�tica"
    End If
    If lQtdEnts > 0 Then
        cmdLogFileAED.Visible = False
        ''Update entities
        Screen.MousePointer = vbHourglass
        UpdateEntitiesAED lQtdEnts
        Screen.MousePointer = vbDefault
        MsgBox "Actualizac�o " & sTipo & " concluida!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        cmdLogFileAED.Visible = True
        ''Listar Entidades duplicadas
        cmdListarAED_Click
        ''Limpar Entidades identicas
        Screen.MousePointer = vbHourglass
        lvwDEI.ListItems.Clear
        cmdAddRootDEI.Enabled = False
        cmdAddChildDEI.Enabled = False
        cmdInfoDEI.Enabled = False
        cmdUpdDEI.Enabled = False
        trvDEI.Nodes.Clear
        Screen.MousePointer = vbDefault
        ''Limpar Entidades n�o referenciadas
        Screen.MousePointer = vbHourglass
        lvwENR.ListItems.Clear
        optDelSelectENR.Enabled = False
        optDelAllENR.Enabled = False
        cmdInfoENR.Enabled = False
        cmdDelENR.Enabled = False
        Screen.MousePointer = vbDefault
    Else
        MsgBox "N�o foram encontradas entidades para actualizar!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
    End If
End Function


' Actualiza entidades duplicadas
Private Function UpdateEntitiesAED(lTotal As Long) As Boolean
    Dim lX As Long
    Dim lIdUpd As Long
    Dim lGrp As Long
    Dim sTimeIni
    Dim sLogFileEnt As String
    
    GetLogFileName kAED
    OpenLogFile sLogFilePathAED
    sLogLine = ""
    sLogLine = vbNewLine & "Entidades Duplicadas" & vbNewLine & vbNewLine & vbNewLine
    sTimeIni = CStr(Date) & " " & CStr(Time)
    sLogLine = sLogLine & "Inicio da actualiza��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    WriteInLogFile sLogLine
    pgbProgress.Min = 0
    pgbProgress.Max = lTotal
    sLogLine = sLogLine & "Ordem de actualiza��o das tabelas: " & vbNewLine
    sLogLine = sLogLine & kUPDATE_TABLES_ORDER & vbNewLine & vbNewLine
    sLogLine = sLogLine & "Actualiza��o" & vbNewLine & kLOG_SEPARATOR_02
    WriteInLogFile sLogLine
    pgbProgress.Value = 0
    pgbProgress.Visible = True
    lblProgressAED.Caption = "A actualizar as entidades ..."
    Me.Refresh
    lEntitieUpdAED = 0
    lEntitieNotUpdAED = 0
    For lX = 0 To lTotal - 1
        lIdUpd = sEntities(lIdxSel(lX)).lEntId
        lGrp = sEntities(lIdxSel(lX)).lEntGroup
        lblProgressAED.Caption = "A actualizar a entidade '" & sEntities(lIdxSel(lX)).sEntName & " ' ..."
        sLogLine = sLogLine & IIf(lX = 0, "", vbNewLine) & "Entidade escolhida: " & vbNewLine & "[" & lIdUpd & "]" & " " & sEntities(lIdxSel(lX)).sEntName & vbNewLine
        sLogLine = sLogLine & "Entidades duplicadas: "
        WriteInLogFile sLogLine
        ConstroiStringAndUpdate lIdUpd, lGrp, sEntities(lIdxSel(lX)).sEntName, lvwAED
        pgbProgress.Value = pgbProgress.Value + 1
    Next
    pgbProgress.Value = lTotal
    pgbProgress.Visible = False
    pgbProgress.Value = 0
    lblProgressAED.Caption = ""
    sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Resultados" & vbNewLine & kLOG_SEPARATOR_02
    sLogLine = sLogLine & vbNewLine & "Entidades a actualizar: " & lTotal
    sLogLine = sLogLine & vbNewLine & "Entidades actualizadas: " & lEntitieUpdAED
    sLogLine = sLogLine & vbNewLine & "Entidades n�o actualizadas: " & lEntitieNotUpdAED & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Dura��o da actualiza��o: " & GetOperationTime(CDbl(DateDiff("s", sTimeIni, CStr(Date) & " " & CStr(Time)))) & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Utilizador: " & stUserInfo.sOfficeWorksDesc & " (" & stUserInfo.sOfficeWorksLogin & ")" & vbNewLine & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    sLogLine = sLogLine & "Fim da actualiza��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    WriteInLogFile sLogLine
    CloseLogFile
End Function


''Ver log
Private Sub cmdLogFileAED_Click()
    ViewLogFile sLogFilePathAED
End Sub


''********** Entidades Identicas **********''
''Set default for pagination
Private Sub SetDefaultsForPageNavigation()
    ''Total entities
    lNumTotalEnt = 0
    lblTotalDEILabel.Visible = False
    lblTotalDEI.Visible = False
    lblTotalDEI.Caption = ""
    ''Total pages
    lPageNumber = 1
    lblTotalPagesDEILabel.Visible = False
    lblTotalPagesDEI.Visible = False
    lblTotalPagesDEI.Caption = ""
    ''Navigation buttons
    cmdFirst.Enabled = False
    cmdNext.Enabled = False
    cmdPrevious.Enabled = False
    cmdLast.Enabled = False
    txtGoToPage.Text = ""
    txtGoToPage.Enabled = False
    cmdGoToPage.Enabled = False
End Sub


''listar entidades identicas
Private Sub cmdListarDEI_Click()
    Dim sErro As String
    
    Me.Refresh
    cmdAddRootDEI.Enabled = False
    cmdAddChildDEI.Enabled = False
    cmdInfoDEI.Enabled = False
    cmdUpdDEI.Enabled = False
    cmdExportarDEI.Enabled = False
    ''Limpar treeview
    Screen.MousePointer = vbHourglass
    trvDEI.Nodes.Clear
    Screen.MousePointer = vbDefault
    ''Defaults for page navigation
    SetDefaultsForPageNavigation
    ''Preencher lista entidades identicas
    ActualizaListaEntidadesIdenticas
    cmdExportarDEI.Enabled = True
End Sub


Private Sub cmdFirst_Click()
    ''Get entities
    lPageNumber = 1
    ActualizaListaEntidadesIdenticas
End Sub


Private Sub cmdPrevious_Click()
    ''Get entities
    lPageNumber = lPageNumber - 1
    ActualizaListaEntidadesIdenticas
End Sub


Private Sub cmdNext_Click()
    ''Get entities
    lPageNumber = lPageNumber + 1
    ActualizaListaEntidadesIdenticas
End Sub


Private Sub cmdLast_Click()
    ''Get entities
    lPageNumber = lTotalPages
    ActualizaListaEntidadesIdenticas
End Sub


Private Sub cmdGoToPage_Click()
    If Not IsNumeric(Trim(txtGoToPage.Text)) Then
        MsgBox "N�mero da p�gina inv�lido!", vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    GoToPageNumber CLng(Trim(txtGoToPage.Text))
End Sub


Private Sub txtGoToPage_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then cmdGoToPage_Click
    If KeyAscii < 48 Or KeyAscii > 57 Then KeyAscii = 0
End Sub


Private Sub txtGoToPage_Change()
    cmdGoToPage.ToolTipText = "Ir para a p�gina " & Trim(txtGoToPage.Text)
End Sub


Private Sub GoToPageNumber(lPage As Long)
    ''Validate page number
    If lPage < 1 Then
        MsgBox "N�mero da p�gina tem de ser superior a zero!", vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    If lPage > lTotalPages Then
        MsgBox "N�mero da p�gina tem de ser inferior ou igual a " & lTotalPages & "!", vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    ''Get entities
    lPageNumber = lPage
    ActualizaListaEntidadesIdenticas
End Sub


Private Sub cmdInfoDEI_Click()
    Screen.MousePointer = vbHourglass
    GetInfo lvwDEI.SelectedItem.SubItems(1)
    Screen.MousePointer = vbDefault
End Sub


Private Sub ActualizaListaEntidadesIdenticas()
    Dim sErro As String
    
    ''Preencher lista entidades identicas
    lblProgressDEI.Caption = "A preencher a lista de entidades id�nticas ..."
    Screen.MousePointer = vbHourglass
    PreencheListEntsIdenticas lvwDEI, lblTotalDEI, sErro, txtFilter
    Screen.MousePointer = vbDefault
    lblProgressDEI.Caption = "Preenchimento da lista de entidades id�nticas terminado."
    ''Validar estado dos botoes
    If lvwDEI.ListItems.Count > 0 Then
        cmdInfoDEI.Enabled = True
    Else
        If sErro = "" Then lblProgressDEI.Caption = "N�o foram encontradas entidades id�nticas!"
    End If
    Me.Refresh
    GetNumberOfPages lPageNumber, lNumTotalEnt
End Sub


''Adicionar entidade principal
Private Sub cmdAddRootDEI_Click()
    Dim nodX As Node
    Dim lIdxLst As Long
    Dim sTextLst As String
    Dim sNodeKey As String
     
    On Error GoTo erro
    
    lblProgressDEI.Caption = "A verificar entidades para adicionar ..."
    If Not CheckEntities(lvwDEI, lblProgressDEI) Then Exit Sub
    sNodeKey = "K" & lvwDEI.SelectedItem.SubItems(1)
    sTextLst = kENT_PRINCIPAL & " [" & lvwDEI.SelectedItem.SubItems(1) & "] " & lvwDEI.SelectedItem.SubItems(2)
    Set nodX = trvDEI.Nodes.Add(, , sNodeKey, sTextLst)
    nodX.Selected = True
    cmdUpdDEI.Enabled = True
    Exit Sub

erro:
    If Err.Number = 35602 Then
        MsgBox "Entidade j� adicionada anteriormente!", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Else
        MsgBox "Erro ao adicionar a entidade!" & vbNewLine & "(Erro n�: " & Err.Number & " - Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    End If
    Err.Clear
End Sub


''Adicionar entidade identica
Private Sub cmdAddChildDEI_Click()
    Dim nodX As Node
    Dim lIdxLst As Long
    Dim sTextLst As String
    Dim sNodeKey As String
    Dim sNodeRel As String
    Dim lNodesCount As Long
    Dim lNodesSel As Long
    Dim lX As Long
     
    On Error GoTo erro
    
    lNodesSel = 0
    lNodesCount = trvDEI.Nodes.Count
    For lX = 1 To lNodesCount
        If trvDEI.Nodes.Item(lX).Selected Then
            If Left(trvDEI.Nodes.Item(lX).Text, 3) = kENT_PRINCIPAL Then
                lNodesSel = 1
                Exit For
            End If
        End If
    Next
    If lNodesSel = 0 Then
        MsgBox "Seleccione uma entidade principal " & kENT_PRINCIPAL & "!", vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    sNodeRel = trvDEI.SelectedItem.Key
    sNodeKey = "K" & lvwDEI.SelectedItem.SubItems(1)
    sTextLst = kENT_IDENTICA & " [" & lvwDEI.SelectedItem.SubItems(1) & "] " & lvwDEI.SelectedItem.SubItems(2)
    Set nodX = trvDEI.Nodes.Add(sNodeRel, tvwChild, sNodeKey, sTextLst)
    nodX.EnsureVisible
    cmdUpdDEI.Enabled = True
    Exit Sub

erro:
    If Err.Number = 35602 Then
        MsgBox "Entidade j� adicionada anteriormente!", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    Else
        MsgBox "Erro ao adicionar a entidade!" & vbNewLine & "(Erro n�: " & Err.Number & " - Desc.: " & Err.Description & ")", vbCritical, kTITULO_MSG & kTITULO_MSG_ENT
    End If
    Err.Clear
End Sub


''Retirar entidade principal ou identica da treeview
Private Sub cmdDelNodeDEI_Click()
    Dim lNodesCount As Long
    Dim lNodesSel As Long
    Dim lX As Long
    
    cmdDelNodeDEI.Enabled = False
    cmdUpdDEI.Enabled = False
    lNodesSel = 0
    lNodesCount = trvDEI.Nodes.Count
    If lNodesCount = 0 Then
        MsgBox "N�o existem entidades para retirar!", vbInformation, kTITULO_MSG & kTITULO_MSG_SRV
    Else
        For lX = 1 To lNodesCount
            If trvDEI.Nodes.Item(lX).Selected Then
                trvDEI.Nodes.Remove trvDEI.Nodes.Item(lX).Index
                If trvDEI.Nodes.Count > 0 Then cmdUpdDEI.Enabled = True
                Exit Sub
            End If
        Next
        MsgBox "Seleccione uma entidade a retirar!", vbInformation, kTITULO_MSG & kTITULO_MSG_SRV
    End If
End Sub


''Check entidade na lista
Private Sub lvwDEI_ItemCheck(ByVal Item As MSComctlLib.ListItem)
    ValidaAddButtonsDEI
End Sub


''Click na lista
Private Sub lvwDEI_Click()
    ValidaAddButtonsDEI
End Sub


''Click na treeview
Private Sub trvDEI_NodeClick(ByVal Node As MSComctlLib.Node)
    cmdDelNodeDEI.Enabled = True
End Sub


''Validar estado dos botoes
Private Sub ValidaAddButtonsDEI()
    If lvwDEI.SelectedItem.Checked = True Then
        cmdAddChildDEI.Enabled = False
        cmdAddRootDEI.Enabled = True
    Else
        cmdAddRootDEI.Enabled = False
        If trvDEI.Nodes.Count > 0 Then cmdAddChildDEI.Enabled = True
    End If
    cmdDelNodeDEI.Enabled = False
End Sub


' Iniciar actualiza��o de entidades identicas
Private Sub cmdUpdDEI_Click()
    Dim lQtd As Long
    Dim sErro As String
    
    If MsgBox("Aten��o! Deseja mesmo efectuar a actualiza��o das entidades id�nticas?", vbQuestion + vbYesNo, kTITULO_MSG & kTITULO_MSG_ENT) = vbNo Then
        Exit Sub
    End If
    cmdUpdDEI.Enabled = False
    cmdInfoDEI.Enabled = False
    cmdListarDEI.Enabled = False
    fraOpcoesManutencao.Enabled = False
    If trvDEI.Nodes.Count > 0 Then
        ''Get entity ids for update on DB
        cmdLogFileDEI.Visible = False
        Screen.MousePointer = vbHourglass
        UpdateEntitiesDEI
        Screen.MousePointer = vbDefault
        MsgBox "Actualizac�o concluida!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        cmdLogFileDEI.Visible = True
        ''Listar Entidades identicas
        cmdListarDEI_Click
        ''Limpar Entidades duplicadas
        Screen.MousePointer = vbHourglass
        lvwAED.ListItems.Clear
        optUpdManualAED.Enabled = False
        optUpdAutoAED.Enabled = False
        cmdInfoAED.Enabled = False
        cmdUpdAED.Enabled = False
        Screen.MousePointer = vbDefault
        ''Limpar Entidades n�o referenciadas
        Screen.MousePointer = vbHourglass
        lvwENR.ListItems.Clear
        optDelSelectENR.Enabled = False
        optDelAllENR.Enabled = False
        cmdInfoENR.Enabled = False
        cmdDelENR.Enabled = False
        Screen.MousePointer = vbDefault
    Else
        MsgBox "N�o existem entidades para actualizar!", vbInformation, kTITULO_MSG & kTITULO_MSG_SRV
    End If
    fraOpcoesManutencao.Enabled = True
    cmdListarDEI.Enabled = True
End Sub


'Actualiza��o de Entidades Identicas
Private Sub UpdateEntitiesDEI()
    Dim lX As Long
    Dim lY As Long
    Dim lnode As Long
    Dim lEntIdP As Long
    Dim sEntIdsD As String
    Dim lNodeChildren As Long
    Dim sTimeIni
    Dim sLogFileEnt As String
    Dim lResult As Long
    Dim lTotal As Long
    
    GetLogFileName kDEI
    OpenLogFile sLogFilePathDEI
    sLogLine = ""
    sLogLine = vbNewLine & "Entidades id�nticas" & vbNewLine & vbNewLine & vbNewLine
    sTimeIni = CStr(Date) & " " & CStr(Time)
    sLogLine = sLogLine & "Inicio da actualiza��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    WriteInLogFile sLogLine
    pgbProgress.Min = 0
    pgbProgress.Max = trvDEI.Nodes.Count
    sLogLine = sLogLine & "Ordem de actualiza��o das tabelas: " & vbNewLine
    sLogLine = sLogLine & kUPDATE_TABLES_ORDER & vbNewLine & vbNewLine
    sLogLine = sLogLine & "Actualiza��o" & vbNewLine & kLOG_SEPARATOR_02
    WriteInLogFile sLogLine
    pgbProgress.Value = 0
    pgbProgress.Visible = True
    lblProgressDEI.Caption = "A actualizar as entidades ..."
    Me.Refresh
    lEntitieUpdDEI = 0
    lEntitieNotUpdDEI = 0
    lnode = 0
    lTotal = 0
    For lX = 1 To trvDEI.Nodes.Count
        DoEvents
        lblProgressDEI.Caption = "A actualizar a entidade '" & trvDEI.Nodes(lX).Text & " ' ..."
        lNodeChildren = trvDEI.Nodes(lX).Children
        If lNodeChildren > 0 Then
            lEntIdP = Replace(trvDEI.Nodes(lX).Key, "K", "")
            sLogLine = sLogLine & IIf(lX = 1, "", vbNewLine) & "Entidade escolhida: " & vbNewLine & "[" & lEntIdP & "]" & " " & trvDEI.Nodes(lX).Text & vbNewLine
            sLogLine = sLogLine & "Entidades id�nticas: "
            WriteInLogFile sLogLine
            sEntIdsD = "("
            lnode = lX + lNodeChildren
            For lY = (lX + 1) To lnode
                sLogLine = sLogLine & "[" & Replace(trvDEI.Nodes(lY).Key, "K", "") & "]" & " " & trvDEI.Nodes(lY).Text
                WriteInLogFile sLogLine
                sEntIdsD = sEntIdsD & Replace(trvDEI.Nodes(lY).Key, "K", "") & ","
            Next
            sEntIdsD = sEntIdsD & ")"
            sEntIdsD = Replace(sEntIdsD, ",)", ")")
            If Len(sEntIdsD) > 2 Then
                ''Inicio da transa��o
                objCnn.BeginTrans
                lResult = UpdateEntitiesOnDB(lEntIdP, trvDEI.Nodes(lX).Text, sEntIdsD, lEntitieUpdDEI, lEntitieNotUpdDEI)
                ''Fim da transa��o
                If lResult = kERROR_NONE Then
                    objCnn.CommitTrans
                Else
                    objCnn.RollbackTrans
                End If
            End If
            lX = lnode
            ''Contar quantas entidades s�o actualizadas
            lTotal = lTotal + 1
        End If
        pgbProgress.Value = lX
    Next
    pgbProgress.Value = trvDEI.Nodes.Count
    pgbProgress.Visible = False
    pgbProgress.Value = 0
    lblProgressDEI.Caption = ""
    sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Resultados" & vbNewLine & kLOG_SEPARATOR_02
    sLogLine = sLogLine & vbNewLine & "Entidades a actualizar: " & lTotal
    sLogLine = sLogLine & vbNewLine & "Entidades actualizadas: " & lEntitieUpdDEI
    sLogLine = sLogLine & vbNewLine & "Entidades n�o actualizadas: " & lEntitieNotUpdDEI & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Dura��o da actualiza��o: " & GetOperationTime(CDbl(DateDiff("s", sTimeIni, CStr(Date) & " " & CStr(Time)))) & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Utilizador: " & stUserInfo.sOfficeWorksDesc & " (" & stUserInfo.sOfficeWorksLogin & ")" & vbNewLine & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    sLogLine = sLogLine & "Fim da actualiza��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    WriteInLogFile sLogLine
    CloseLogFile
End Sub


''Ver log
Private Sub cmdLogFileDEI_Click()
    ViewLogFile sLogFilePathDEI
End Sub


''********** Entidades N�o Referenciadas **********''
''Listar entidades n�o referenciadas
Private Sub cmdListarENR_Click()
    Dim sErro As String
    
    optDelSelectENR.Enabled = False
    optDelAllENR.Enabled = False
    cmdInfoENR.Enabled = False
    cmdDelENR.Enabled = False
    cmdExportarENR.Enabled = False
    ''Preencher lista entidades n�o referenciadas
    lblProgressENR.Caption = "A preencher a lista de entidades n�o referenciadas ..."
    Screen.MousePointer = vbHourglass
    PreencheListEnts kENR, lvwENR, lblTotalENR, sErro
    Screen.MousePointer = vbDefault
    lblProgressENR.Caption = "Preenchimento da lista de entidades n�o referenciadas terminado."
    ''Validar estado dos botoes
    If lvwENR.ListItems.Count > 0 Then
        optDelSelectENR.Enabled = True
        optDelAllENR.Enabled = True
        cmdInfoENR.Enabled = True
        cmdDelENR.Enabled = True
        cmdExportarENR.Enabled = True
    Else
        If sErro = "" Then lblProgressENR.Caption = "N�o foram encontradas entidades n�o referenciadas!"
    End If
End Sub


''ver informa��o da entidade
Private Sub cmdInfoENR_Click()
    Screen.MousePointer = vbHourglass
    GetInfo lvwENR.SelectedItem.SubItems(1)
    Screen.MousePointer = vbDefault
End Sub


''Apagar entidades n�o referenciadas
Private Sub cmdDelENR_Click()
    If MsgBox("Aten��o! Deseja mesmo apagar as entidades n�o referenciadas?", vbQuestion + vbYesNo, kTITULO_MSG & kTITULO_MSG_ENT) = vbNo Then
        Exit Sub
    End If
    cmdDelENR.Enabled = False
    cmdInfoENR.Enabled = False
    cmdListarENR.Enabled = False
    fraOpcoesManutencao.Enabled = False
    ''Get entity ids for delete on DB
    GetEntitiesIdsForDelete
    fraOpcoesManutencao.Enabled = True
    cmdListarENR.Enabled = True
End Sub


''Obter ids das entidades n�o referenciadas para apagar
Private Function GetEntitiesIdsForDelete() As Boolean
    Dim lX As Long
    Dim lY As Long
    Dim lz As Long
    Dim lQtdEnts As Long
    Dim sTipo As String
    Dim sMsg As String
    Dim sErro As String
    
    lX = 0
    lz = 0
    ''Apagar seleccionadas
    If optDelSelectENR.Value = True Then
        ''Get select entities for delete
        lblProgressENR.Caption = "A obter entidades para apagar (seleccionadas)..."
        Screen.MousePointer = vbHourglass
        GetEntitiesSel lQtdEnts, lvwENR
        Screen.MousePointer = vbDefault
        lblProgressENR.Caption = ""
        sTipo = "seleccionadas"
    Else
        ''Apagar todas
        If MsgBox("Aten��o! A aplica��o vai apagar todas as entidades n�o referenciadas! Deseja continuar?", vbQuestion + vbYesNo, kTITULO_MSG & kTITULO_MSG_ENT) = vbNo Then
            Exit Function
        End If
        ''Get all entities for delete
        lblProgressENR.Caption = "A obter entidades para apagar (todas) ..."
        Screen.MousePointer = vbHourglass
        GetEntitiesAll lQtdEnts, lvwENR
        Screen.MousePointer = vbDefault
        lblProgressENR.Caption = ""
        sTipo = "todas"
    End If
    If lQtdEnts > 0 Then
        cmdlogFileENR.Visible = False
        ''Delete entities
        Screen.MousePointer = vbHourglass
        DeleteEntitiesENR lQtdEnts, kMAX_ENT_DELETE
        Screen.MousePointer = vbDefault
        MsgBox "Elimina��o das entidades " & sTipo & " concluida!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        cmdlogFileENR.Visible = True
        ''Listar Entidades n�o referenciadas
        cmdListarENR_Click
        ''Limpar Entidades duplicadas
        Screen.MousePointer = vbHourglass
        lvwAED.ListItems.Clear
        optUpdManualAED.Enabled = False
        optUpdAutoAED.Enabled = False
        cmdInfoAED.Enabled = False
        cmdUpdAED.Enabled = False
        Screen.MousePointer = vbDefault
        ''Limpar Entidades identicas
        Screen.MousePointer = vbHourglass
        lvwDEI.ListItems.Clear
        cmdAddRootDEI.Enabled = False
        cmdAddChildDEI.Enabled = False
        cmdInfoDEI.Enabled = False
        cmdUpdDEI.Enabled = False
        trvDEI.Nodes.Clear
        Screen.MousePointer = vbDefault
    Else
        MsgBox "N�o foram encontradas entidades para apagar!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
    End If
End Function


' Apaga entidades n�o referenciadas
Private Function DeleteEntitiesENR(lTotal As Long, lMaxEntDel As Long) As Boolean
    Dim lX As Long
    Dim lIdDel As Long
    Dim sTimeIni
    Dim sEntIdsDel As String
    Dim lResult As Long
    Dim lIni As Long
    Dim lFim As Long
    
    GetLogFileName kENR
    OpenLogFile sLogFilePathENR
    sLogLine = ""
    sLogLine = vbNewLine & "Entidades n�o Referenciadas" & vbNewLine & vbNewLine & vbNewLine
    sTimeIni = CStr(Date) & " " & CStr(Time)
    sLogLine = sLogLine & "Inicio da elimina��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    WriteInLogFile sLogLine
    pgbProgress.Min = 0
    pgbProgress.Max = lTotal
    sLogLine = sLogLine & "Elimina��o" & vbNewLine & kLOG_SEPARATOR_02
    WriteInLogFile sLogLine
    pgbProgress.Value = 0
    pgbProgress.Visible = True
    lblProgressENR.Caption = "Obter IDs para o SQL ..."
    Me.Refresh
    sLogLine = sLogLine & vbNewLine & "Entidades a apagar: " & lTotal
    sLogLine = sLogLine & vbNewLine & "Elimina��o de entidades em grupos de: " & lMaxEntDel & vbNewLine
    ''Apagar em grupos de x entidades default 100
    lIni = 0
    lFim = lMaxEntDel - 1
    If lTotal < lMaxEntDel Then lFim = lTotal - 1
    While lFim < lTotal
        sLogLine = sLogLine & vbNewLine & "Entidades:" & vbNewLine
        sEntIdsDel = "("
        For lX = lIni To lFim
            lIdDel = sEntities(lIdxSel(lX)).lEntId
            sEntIdsDel = sEntIdsDel & lIdDel & ","
            sLogLine = sLogLine & "[" & lIdDel & "]" & " " & sEntities(lIdxSel(lX)).sEntName
            WriteInLogFile sLogLine
            pgbProgress.Value = pgbProgress.Value + 1
        Next
        sEntIdsDel = sEntIdsDel & ")"
        sEntIdsDel = Replace(sEntIdsDel, ",)", ")")
        sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
        sLogLine = sLogLine & vbNewLine & "Resultados" & vbNewLine & kLOG_SEPARATOR_02
        WriteInLogFile sLogLine
        If Len(sEntIdsDel) > 2 Then
            lblProgressENR.Caption = "A apagar as entidades ..."
            ''Delete from DB
            lResult = DeleteEntitiesOnDB(sEntIdsDel)
            If lResult = kERROR_NONE Then
                sLogLine = sLogLine & "Entidades apagadas: " & lFim + 1 & "/" & lTotal & vbNewLine
            Else
                sLogLine = sLogLine & "Entidades apagadas: 0" & vbNewLine
            End If
        End If
        lIni = lFim + 1
        If lIni = lTotal Then
            lFim = lTotal
        Else
            lFim = lFim + lMaxEntDel
            If lFim > lTotal Then lFim = lTotal - 1
        End If
    Wend
    pgbProgress.Value = lTotal
    pgbProgress.Visible = False
    pgbProgress.Value = 0
    lblProgressENR.Caption = ""
    sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Dura��o da elimina��o: " & GetOperationTime(CDbl(DateDiff("s", sTimeIni, CStr(Date) & " " & CStr(Time)))) & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Utilizador: " & stUserInfo.sOfficeWorksDesc & " (" & stUserInfo.sOfficeWorksLogin & ")" & vbNewLine & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    sLogLine = sLogLine & "Fim da elimina��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    WriteInLogFile sLogLine
    CloseLogFile
End Function


''Ver log
Private Sub cmdlogFileENR_Click()
    ViewLogFile sLogFilePathENR
End Sub


''********** Alterar Codigo Entidade  **********''
''Codigo da entidade
Private Sub txtCodigoEntidade_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then cmdSearchEnt_Click
    ValidateInteger KeyAscii
End Sub


''Novo Codigo da entidade
Private Sub txtNovoCodigoEntidade_KeyPress(KeyAscii As Integer)
    ValidateInteger KeyAscii
End Sub


''Pesquisar dados da entidade
Private Sub cmdSearchEnt_Click()
    Dim lCode As Long
    
    If Len(Trim(txtCodigoEntidade.Text)) = 0 Then
        MsgBox "Indique o c�digo da entidade!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    lCode = 0 & CLng(Trim(txtCodigoEntidade.Text))
    If lCode = 0 Then
        MsgBox "O c�digo da entidade tem de ser superior a zero!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    txtNomeEntidade.Text = GetEntityByCode(lCode)
    If Len(txtNomeEntidade.Text) > 0 Then
        txtCodigoEntidade.Enabled = False
        txtNovoCodigoEntidade.Enabled = True
        cmdSearchEnt.Enabled = False
        cmdInfoACE.Enabled = True
        cmdModifyEnt.Enabled = True
    End If
End Sub


''Obter dados da entidade
Private Function GetEntityByCode(lCode As Long) As String
    Dim sName As String
    Dim bExist As Boolean
    Dim sErro As String
    
    sName = ""
    bExist = False
    sErro = ""
    lblProgressACE.Caption = "A pesquisar a entidade ..."
    Screen.MousePointer = vbHourglass
    GetEntityFromDB lCode, sName, bExist, sErro
    Screen.MousePointer = vbDefault
    lblProgressACE.Caption = ""
    If Not bExist And sErro = "" Then
        MsgBox "N�o foi encontrada a entidade com o c�digo '" & lCode & "'!", vbExclamation, kTITULO_MSG & kTITULO_MSG_ENT
    End If
    GetEntityByCode = sName
End Function


''Informa��o da entidade
Private Sub cmdInfoACE_Click()
    Screen.MousePointer = vbHourglass
    GetInfo CLng(txtCodigoEntidade.Text)
    Screen.MousePointer = vbDefault
End Sub


''Limpar campos da altera��o do c�digo
Private Sub cmdClearEnt_Click()
    txtCodigoEntidade.Text = ""
    txtCodigoEntidade.Enabled = True
    txtNomeEntidade.Text = ""
    txtNovoCodigoEntidade.Text = ""
    txtNovoCodigoEntidade.Enabled = False
    lblProgressACE.Caption = ""
    cmdInfoACE.Enabled = False
    cmdModifyEnt.Enabled = False
    cmdSearchEnt.Enabled = True
End Sub


''Alterar codigo da entidade
Private Sub cmdModifyEnt_Click()
    Dim lCodeOld As Long
    Dim lCodeNew As Long
    Dim sName As String
    Dim sErro As String
    
    If MsgBox("Aten��o! Deseja mesmo efectuar a altera��o do c�digo da entidade?", vbQuestion + vbYesNo, kTITULO_MSG & kTITULO_MSG_ENT) = vbNo Then
        Exit Sub
    End If
    If Len(Trim(txtNovoCodigoEntidade.Text)) = 0 Then
        MsgBox "Indique o novo c�digo para a entidade!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    lCodeOld = 0 & CLng(Trim(txtCodigoEntidade.Text))
    lCodeNew = 0 & CLng(Trim(txtNovoCodigoEntidade.Text))
    sName = Trim(txtNomeEntidade.Text)
    If lCodeNew = 0 Then
        MsgBox "O novo c�digo da entidade tem de ser superior a zero!", vbInformation, kTITULO_MSG & kTITULO_MSG_ENT
        Exit Sub
    End If
    cmdLogFileACE.Visible = False
    Screen.MousePointer = vbHourglass
    SetEntityNewCode lCodeOld, lCodeNew, sName
    Screen.MousePointer = vbDefault
    cmdLogFileACE.Visible = True
End Sub


''alterar codigo para o novo
Private Sub SetEntityNewCode(lCodeOld As Long, lCodeNew As Long, sEntName As String)
    Dim sErro As String
    Dim bExist As Boolean
    Dim sLogFileEnt As String
    Dim sTimeIni As String
    
    GetLogFileName kACE
    OpenLogFile sLogFilePathACE
    sLogLine = ""
    sLogLine = vbNewLine & "C�digo da Entidade" & vbNewLine & vbNewLine & vbNewLine
    sTimeIni = CStr(Date) & " " & CStr(Time)
    sLogLine = sLogLine & "Inicio da altera��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    WriteInLogFile sLogLine
    sLogLine = sLogLine & "Altera��o" & vbNewLine & kLOG_SEPARATOR_02
    sLogLine = sLogLine & vbNewLine & "C�digo antigo: [" & lCodeOld & "]"
    sLogLine = sLogLine & vbNewLine & "C�digo novo: [" & lCodeNew & "]" & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_02
    WriteInLogFile sLogLine
    lblProgressACE.Caption = "A verificar se o novo c�digo da entidade j� existe ..."
    Me.Refresh
    sErro = ""
    VerifyEntityCodeOnDB lCodeNew, bExist, sErro
    lblProgressACE.Caption = ""
    sLogLine = sLogLine & vbNewLine & "Resultados" & vbNewLine & kLOG_SEPARATOR_02
    sLogLine = sLogLine & vbNewLine & "Entidade a alterar: [" & lCodeOld & "] '" & sEntName & "'"
    If bExist Then
        sLogLine = sLogLine & vbNewLine & sErro & vbNewLine
    Else
        If Not bExist And sErro = "" Then
            UpdateEntityCodeOnDB lCodeOld, lCodeNew, sErro
            If sErro = "" Then
                txtCodigoEntidade.Text = lCodeNew
                txtNovoCodigoEntidade.Text = ""
                sLogLine = sLogLine & vbNewLine & "O c�digo da entidade foi alterado com sucesso" & vbNewLine
            Else
                sLogLine = sLogLine & vbNewLine & sErro & vbNewLine
            End If
        Else
            sLogLine = sLogLine & vbNewLine & sErro & vbNewLine
        End If
    End If
    sLogLine = sLogLine & kLOG_SEPARATOR_02 & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Dura��o da altera��o: " & GetOperationTime(CDbl(DateDiff("s", sTimeIni, CStr(Date) & " " & CStr(Time)))) & vbNewLine
    sLogLine = sLogLine & vbNewLine & "Utilizador: " & stUserInfo.sOfficeWorksDesc & " (" & stUserInfo.sOfficeWorksLogin & ")" & vbNewLine & vbNewLine
    sLogLine = sLogLine & kLOG_SEPARATOR_01 & vbNewLine
    sLogLine = sLogLine & "Fim da altera��o: " & Format(Date, "dd-mm-yyyy") & " �s " & Format(Time, "hh:mm:ss") & vbNewLine
    WriteInLogFile sLogLine
    CloseLogFile
End Sub


''Ver log
Private Sub cmdLogFileACE_Click()
    ViewLogFile sLogFilePathACE
End Sub


''********** Geral **********''
''Load do form
Private Sub Form_Load()
    Dim sAppVersion As String
    
    Me.Caption = kTITULO_MSG
    sAppVersion = "Vers�o " & App.Major & "." & App.Minor & "." & App.Revision
    lblVersion.ToolTipText = sAppVersion
    lblFullVersion.Caption = sAppVersion & " " & App.LegalCopyright & " (Vers�o OfficeWorks " & kDB_VERSION & ")"
    lblFullVersion.Visible = False
    ''Valores default para a liga��o ao servidor
    txtServer.Text = kSERVER_OfficeWorks
    txtServerAED.Enabled = False
    txtServerDEI.Enabled = False
    txtServerENR.Enabled = False
    txtDataBase.Text = kDATABASE_OfficeWorks
    txtLogin.Text = kSQL_USER
    txtLogin.Enabled = True
    txtPassword.Text = kTEXT_PWD
    txtPassword.Enabled = True
    txtTimeoutCnn.Text = kTIMEOUT_CONNECTION
    ''Barra de progresso
    pgbProgress.Value = 0
    pgbProgress.Visible = False
    ''Colocar valores default
    TrataFrames kOPT_DEFAULT
    optOption(kOPT_SERVER).Value = True
    ''Obter informa��o do utilizador
    GetUserInfo
End Sub


''tratamento das frames para as op��es
Private Sub TrataFrames(opt As Integer)
    Select Case opt
    Case kOPT_DEFAULT
        ''Servidor
        lblProgressSrv.Caption = ""
        ''Actualizar Entidades Duplicadas
        InicializaListView lvwAED
        optUpdManualAED.Value = True
        optUpdManualAED.Enabled = False
        optUpdAutoAED.Enabled = False
        cmdInfoAED.Enabled = False
        cmdUpdAED.Enabled = False
        cmdExportarAED.Enabled = False
        lblTotalAED.Caption = ""
        lblProgressAED.Caption = ""
        lblProgressAED.Visible = False
        ''Definir Entidades Identicas
        InicializaListView lvwDEI
        cmdAddRootDEI.Enabled = False
        cmdAddChildDEI.Enabled = False
        cmdDelNodeDEI.Enabled = False
        cmdInfoDEI.Enabled = False
        cmdUpdDEI.Enabled = False
        cmdExportarDEI.Enabled = False
        SetDefaultsForPageNavigation
        lblProgressDEI.Caption = ""
        lblProgressDEI.Visible = False
        ''Entidades n�o referenciadas
        InicializaListView lvwENR
        optDelSelectENR.Value = True
        optDelSelectENR.Enabled = False
        optDelAllENR.Enabled = False
        cmdInfoENR.Enabled = False
        cmdDelENR.Enabled = False
        cmdExportarENR.Enabled = False
        lblTotalENR.Caption = ""
        lblProgressENR.Caption = ""
        lblProgressENR.Visible = False
        ''Alterar codigo Entidade
        lblProgressACE.Caption = ""
        lblProgressACE.Visible = False
        cmdInfoACE.Enabled = False
        cmdModifyEnt.Enabled = False
        cmdClearEnt.Enabled = False
    Case kOPT_SERVER
        lblProgressAED.Visible = False
        lblProgressDEI.Visible = False
        lblProgressENR.Visible = False
        lblProgressACE.Visible = False
        lblProgressSrv.Visible = True
    Case kOPT_AED
        lblProgressSrv.Visible = False
        lblProgressDEI.Visible = False
        lblProgressENR.Visible = False
        lblProgressACE.Visible = False
        lblProgressAED.Visible = True
        If Len(Trim(txtServerAED.Text)) = 0 Then
            cmdListarAED.Enabled = False
            lvwAED.Enabled = False
        Else
            cmdListarAED.Enabled = True
            lvwAED.Enabled = True
        End If
    Case kOPT_DEI
        lblProgressSrv.Visible = False
        lblProgressAED.Visible = False
        lblProgressENR.Visible = False
        lblProgressACE.Visible = False
        lblProgressDEI.Visible = True
        If Len(Trim(txtServerDEI.Text)) = 0 Then
            cmdListarDEI.Enabled = False
            lvwDEI.Enabled = False
            trvDEI.Enabled = False
            cmdUpdDEI.Enabled = False
        Else
            cmdListarDEI.Enabled = True
            lvwDEI.Enabled = True
            trvDEI.Enabled = True
        End If
    Case kOPT_ENR
        lblProgressSrv.Visible = False
        lblProgressAED.Visible = False
        lblProgressDEI.Visible = False
        lblProgressACE.Visible = False
        lblProgressENR.Visible = True
        If Len(Trim(txtServerENR.Text)) = 0 Then
            cmdListarENR.Enabled = False
            lvwENR.Enabled = False
        Else
            cmdListarENR.Enabled = True
            lvwENR.Enabled = True
        End If
    Case kOPT_ACE
        lblProgressSrv.Visible = False
        lblProgressAED.Visible = False
        lblProgressDEI.Visible = False
        lblProgressENR.Visible = False
        lblProgressACE.Visible = True
        If Len(Trim(txtServerACE.Text)) = 0 Then
            cmdSearchEnt.Enabled = False
            cmdClearEnt.Enabled = False
        Else
            cmdSearchEnt.Enabled = True
            cmdClearEnt.Enabled = True
        End If
    Case Else
    End Select
End Sub


''Click nas op��es
Private Sub optOption_Click(Index As Integer)
    Dim lX As Long
    
    For lX = 0 To optOption.UBound
        fraOption(lX).Visible = False
    Next
    TrataFrames Index
    fraOption(Index).Visible = True
End Sub


''Obter informa��o do utilizador
Private Sub GetUserInfo()
    Dim sNTDomain As String
    Dim sNTServer As String
    Dim NomeAux As String * 50
    Dim sDomainAux As String
    On Error GoTo erro

    sNTDomain = BuscaUtenteInfo("LOGON_DOMAIN").logon_domain
    sNTServer = BuscaUtenteInfo("LOGON_SERVER").logon_server
    GetUserName NomeAux, 50
    If sNTDomain <> "-" Then
        sUserLogin = sNTDomain & "\" & Left$(NomeAux, InStr(NomeAux, Chr(0)) - 1)
    End If
    If sNTDomain = "-" And sNTServer <> "-" Then
        sUserLogin = sNTServer & "\" & Left$(NomeAux, InStr(NomeAux, Chr(0)) - 1)
    End If
    If sNTDomain = "-" And sNTServer = "-" Then
        sUserLogin = Left$(NomeAux, InStr(NomeAux, Chr(0)) - 1)
    End If
    Exit Sub

erro:
    MsgBox "N�o foi poss�vel obter a informa��o do utilizador!", vbCritical, kTITULO_MSG
    Err.Clear
End Sub


''Seleccionar o valar de unm control
Private Sub SelectTxtValue(oTxt As TextBox)
    oTxt.SelStart = 0
    oTxt.SelLength = Len(oTxt.Text)
End Sub


''Colocar caracteres em maiusculas ou minusculas
Private Sub SetValueUpperOrLowerCase(iKey As Integer, sType As String)
    Select Case sType
    Case kTO_UPPERCASE
        iKey = Asc(UCase(Chr(iKey)))
    Case kTO_LOWERCASE
        iKey = Asc(LCase(Chr(iKey)))
    Case Else
    End Select
End Sub


''Validar valores inteiros
Private Sub ValidateInteger(iKey As Integer)
    If iKey = 8 Then Exit Sub
    If iKey < 48 Or iKey > 57 Then iKey = 0
End Sub


''Inicializar as list views
Private Sub InicializaListView(oList As ListView)
    oList.ColumnHeaders.Clear
    oList.ColumnHeaders.Add , , "", kSIZE_LISTVIEW_COL1
    oList.ColumnHeaders.Add , , "C�digo", kSIZE_LISTVIEW_COL2
    oList.ColumnHeaders.Add , , "Nome", kSIZE_LISTVIEW_COL3
End Sub


''Obter ids seleccionados na lista
Private Sub GetEntitiesSel(lQtd As Long, oList As ListView)
    Dim lX As Long
        
    lQtd = 0
    ReDim lIdxSel(lQtd)
    For lX = 0 To oList.ListItems.Count - 1
        If oList.ListItems(lX + 1).Checked Then
            ReDim Preserve lIdxSel(lQtd)
            lIdxSel(lQtd) = lX
            lQtd = lQtd + 1
        End If
    Next
End Sub


''Obter ids da lista seleccionando o primeiro de cada grupo
Private Sub GetEntitiesAuto(lQtd As Long, oList As ListView)
    Dim lX As Long
    Dim lGrp As Long
    
    lQtd = 0
    lGrp = -1
    ReDim lIdxSel(lQtd)
    For lX = 0 To oList.ListItems.Count - 1
        If lGrp <> sEntities(lX).lEntGroup Then
            ReDim Preserve lIdxSel(lQtd)
            lIdxSel(lQtd) = lX
            lQtd = lQtd + 1
        End If
        lGrp = sEntities(lX).lEntGroup
    Next
End Sub


''Obter todos os ids da lista
Private Sub GetEntitiesAll(lQtd As Long, oList As ListView)
    Dim lX As Long
    
    lQtd = 0
    ReDim lIdxSel(lQtd)
    For lX = 0 To oList.ListItems.Count - 1
        ReDim Preserve lIdxSel(lQtd)
        lIdxSel(lQtd) = lX
        lQtd = lQtd + 1
    Next
End Sub


''Obter informa��o da entidade
Private Sub GetInfo(lEntId As Long)
    Dim sName As String
    Dim bExist As Boolean
    Dim sErro As String
    
    Screen.MousePointer = vbHourglass
    GetEntityFromDB lEntId, sName, bExist, sErro
    Screen.MousePointer = vbDefault
    If bExist Then frmInfo.Show vbModal
End Sub


''Unload do form
Private Sub Form_Unload(Cancel As Integer)
    CloseCnn objCnn
    Set otsFile = Nothing
    Set objFS = Nothing
    Set objRs = Nothing
    Set objCnn = Nothing
End Sub


Private Function GetNumberOfPages(lPage As Long, lTotal As Long)
    Dim lMod As Long
    Dim lInt As Long
    
    If (lTotal > 0) Then
        lblTotalDEILabel.Visible = True
        lblTotalDEI.Visible = True
        lMod = lTotal Mod kMAX_ENT_ON_PAGE
        lTotalPages = IIf(lMod = 0, Int(lTotal / kMAX_ENT_ON_PAGE), Int(lTotal / kMAX_ENT_ON_PAGE) + 1)
        lblTotalPagesDEI.Caption = lPage & " / " & lTotalPages
        lblTotalPagesDEILabel.Visible = True
        lblTotalPagesDEI.Visible = True
        ValidatePageNavigation lPage, lTotalPages
    End If
End Function


Private Sub ValidatePageNavigation(lPage As Long, lPages As Long)
    If lPages > 1 Then
        ''Ir para a pagina x
        txtGoToPage.Enabled = True
        cmdGoToPage.Enabled = True
        ''Primeira pagina
        If lPage = 1 Then
            cmdFirst.Enabled = False
            cmdPrevious.Enabled = False
            cmdNext.Enabled = True
            cmdLast.Enabled = True
            Exit Sub
        End If
        ''Paginas intermedias
        If lPage > 1 And lPage < lPages Then
            cmdFirst.Enabled = True
            cmdPrevious.Enabled = True
            cmdNext.Enabled = True
            cmdLast.Enabled = True
            Exit Sub
        End If
        ''Ultima pagina
        If lPage = lPages Then
            cmdFirst.Enabled = True
            cmdPrevious.Enabled = True
            cmdNext.Enabled = False
            cmdLast.Enabled = False
            Exit Sub
        End If
    End If
End Sub


''Mostrar a vers�o completa
Private Sub lblVersion_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblFullVersion.Visible = True
End Sub


''Esconder a vers�o completa
Private Sub lblVersion_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblFullVersion.Visible = False
End Sub


''Terminar aplica��o
Private Sub cmdClose_Click()
    End
End Sub

