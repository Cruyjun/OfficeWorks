VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H8000000E&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   4695
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   8235
   ControlBox      =   0   'False
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4695
   ScaleWidth      =   8235
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame fraProductInfo 
      BackColor       =   &H8000000E&
      BorderStyle     =   0  'None
      Height          =   840
      Left            =   0
      TabIndex        =   20
      Top             =   0
      Width           =   8240
      Begin VB.Image imgExitApplication 
         Height          =   255
         Left            =   7890
         Picture         =   "frmMain.frx":0442
         Stretch         =   -1  'True
         Top             =   60
         Width           =   285
      End
      Begin VB.Label lblVersionMenu 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Versão"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   4785
         MouseIcon       =   "frmMain.frx":07D0
         TabIndex        =   21
         Top             =   600
         Visible         =   0   'False
         Width           =   3345
      End
      Begin VB.Image imgMinimizeApplication 
         Height          =   255
         Left            =   7515
         Picture         =   "frmMain.frx":0ADA
         Stretch         =   -1  'True
         Top             =   60
         Width           =   285
      End
      Begin VB.Image imgProduct 
         Height          =   855
         Left            =   0
         Top             =   0
         Width           =   4800
      End
   End
   Begin VB.Frame fraCompanyInfo 
      BackColor       =   &H8000000E&
      BorderStyle     =   0  'None
      Height          =   520
      Left            =   0
      TabIndex        =   18
      Top             =   4200
      Width           =   8240
      Begin VB.Label lblCopyrightMenu 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Copyright"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   3000
         MouseIcon       =   "frmMain.frx":0E58
         TabIndex        =   19
         Top             =   135
         Width           =   5160
      End
      Begin VB.Image imgCompany 
         Height          =   450
         Left            =   80
         Picture         =   "frmMain.frx":1162
         Stretch         =   -1  'True
         Top             =   30
         Width           =   1800
      End
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   14
      Left            =   120
      Stretch         =   -1  'True
      Top             =   8130
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   13
      Left            =   120
      Stretch         =   -1  'True
      Top             =   7740
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   12
      Left            =   120
      Stretch         =   -1  'True
      Top             =   7365
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   11
      Left            =   120
      Stretch         =   -1  'True
      Top             =   6990
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   10
      Left            =   120
      Stretch         =   -1  'True
      Top             =   6615
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   9
      Left            =   120
      Stretch         =   -1  'True
      Top             =   6240
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   8
      Left            =   120
      Stretch         =   -1  'True
      Top             =   5850
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   7
      Left            =   120
      Stretch         =   -1  'True
      Top             =   5460
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   6
      Left            =   120
      Stretch         =   -1  'True
      Top             =   5070
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   5
      Left            =   120
      Stretch         =   -1  'True
      Top             =   4700
      Width           =   360
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 06"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   5
      Left            =   620
      TabIndex        =   8
      Top             =   4800
      Width           =   3795
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   4
      Left            =   120
      Stretch         =   -1  'True
      Top             =   3520
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   3
      Left            =   120
      Stretch         =   -1  'True
      Top             =   2920
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   2
      Left            =   120
      Stretch         =   -1  'True
      Top             =   2320
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   1
      Left            =   120
      Stretch         =   -1  'True
      Top             =   1720
      Width           =   360
   End
   Begin VB.Image imgOptionIcon 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   360
      Index           =   0
      Left            =   120
      Stretch         =   -1  'True
      Top             =   1120
      Width           =   360
   End
   Begin VB.Image imgScrollDown 
      Height          =   255
      Left            =   4600
      Picture         =   "frmMain.frx":1B88
      Stretch         =   -1  'True
      Top             =   3600
      Width           =   285
   End
   Begin VB.Image imgScrollUp 
      Height          =   255
      Left            =   4600
      Picture         =   "frmMain.frx":1F0A
      Stretch         =   -1  'True
      Top             =   1200
      Width           =   285
   End
   Begin VB.Image imgScrollPosition 
      Height          =   255
      Left            =   4600
      Picture         =   "frmMain.frx":228A
      Stretch         =   -1  'True
      Top             =   2400
      Width           =   285
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 02"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   1
      Left            =   615
      TabIndex        =   7
      Top             =   1800
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 03"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   2
      Left            =   620
      TabIndex        =   6
      Top             =   2400
      Width           =   3800
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 04"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   3
      Left            =   620
      TabIndex        =   5
      Top             =   3000
      Width           =   3800
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 05"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   4
      Left            =   620
      TabIndex        =   4
      Top             =   3600
      Width           =   3800
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 01"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   0
      Left            =   620
      TabIndex        =   3
      Top             =   1200
      Width           =   3800
   End
   Begin VB.Label lblOptionsVisible 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Opções: 1 a 5 de 15"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   5280
      MouseIcon       =   "frmMain.frx":2601
      TabIndex        =   2
      Top             =   3680
      Visible         =   0   'False
      Width           =   2595
   End
   Begin VB.Label lblOptionsDesc 
      BackStyle       =   0  'Transparent
      Caption         =   "strDesc"
      Height          =   1995
      Left            =   5280
      TabIndex        =   1
      Top             =   1200
      Width           =   2595
      WordWrap        =   -1  'True
   End
   Begin VB.Label lblAppVersion 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "*"
      Height          =   120
      Left            =   8140
      TabIndex        =   0
      Top             =   4100
      Width           =   120
   End
   Begin VB.Image imgTopSeparator 
      Height          =   105
      Left            =   0
      Picture         =   "frmMain.frx":290B
      Stretch         =   -1  'True
      Top             =   840
      Width           =   8240
   End
   Begin VB.Image imgBottomSeparator 
      Height          =   105
      Left            =   0
      Picture         =   "frmMain.frx":2B4A
      Stretch         =   -1  'True
      Top             =   4100
      Width           =   8240
   End
   Begin VB.Image imgScrollUpDisabled 
      Height          =   255
      Left            =   4600
      Picture         =   "frmMain.frx":2D89
      Stretch         =   -1  'True
      Top             =   1200
      Width           =   285
   End
   Begin VB.Image imgScrollDownDisabled 
      Height          =   255
      Left            =   4600
      Picture         =   "frmMain.frx":3110
      Stretch         =   -1  'True
      Top             =   3600
      Width           =   285
   End
   Begin VB.Line lnScrollLine 
      BorderColor     =   &H00808080&
      BorderStyle     =   3  'Dot
      Index           =   1
      X1              =   4760
      X2              =   4760
      Y1              =   1440
      Y2              =   3620
   End
   Begin VB.Line lnScrollLine 
      BorderColor     =   &H00808080&
      BorderStyle     =   3  'Dot
      Index           =   0
      X1              =   4720
      X2              =   4720
      Y1              =   1440
      Y2              =   3620
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 14"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   14
      Left            =   620
      TabIndex        =   17
      Top             =   7815
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 15"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   13
      Left            =   620
      TabIndex        =   16
      Top             =   8190
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 11"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   12
      Left            =   620
      TabIndex        =   15
      Top             =   6660
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 10"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   11
      Left            =   620
      TabIndex        =   14
      Top             =   6270
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 12"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   10
      Left            =   620
      TabIndex        =   13
      Top             =   7050
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 13"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   9
      Left            =   620
      TabIndex        =   12
      Top             =   7440
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 09"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   8
      Left            =   620
      TabIndex        =   11
      Top             =   5910
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 08"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   7
      Left            =   620
      TabIndex        =   10
      Top             =   5520
      Width           =   3795
   End
   Begin VB.Label lblOptionName 
      BackStyle       =   0  'Transparent
      Caption         =   "Option Name 07"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   415
      Index           =   6
      Left            =   620
      TabIndex        =   9
      Top             =   5160
      Width           =   3795
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim sInitialCaption As String


Private Sub Form_Load()
    sInitialCaption = Me.Caption
    lblVersionMenu.Visible = False
    lblVersionMenu.Caption = "Versão " & App.Major & "." & App.Minor & "." & App.Revision & " - " & App.Comments
    ''Set configurations for menu
    SetConfigurationValues
End Sub


Private Sub SetConfigurationValues()
    Dim sExit As String
    Dim sMinimize As String
    Dim sCopyright As String
    
    ''Exit button
    sExit = "Sair da aplicação"
    If sMenuConfig.sTitle <> "" Then sExit = sExit & " de " & sMenuConfig.sTitle
    imgExitApplication.ToolTipText = sExit
    ''Minimize button
    sMinimize = "Minimizar a aplicação"
    If sMenuConfig.sTitle <> "" Then sMinimize = sMinimize & " de " & sMenuConfig.sTitle
    imgMinimizeApplication.ToolTipText = sMinimize
    ''Copyright
    lblCopyrightMenu.Caption = sMenuConfig.sCopyright
    ''Load Menu images
    SetMenuImages
    ''Get back and fore colors from configuration
    GetMenuConfigColors
    ''Set back and fore colors
    SetMenuBackForeColors
    ''Hide all options icon images
    HideAllInstallOptions
    ''Set Options icons
    SetInstallOptionsIcons
    ''Set options names
    SetInstallOptionsNames
    ''Initialize scrool
    SetInitialScrollOptions
End Sub


Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbDefault
End Sub


Private Sub Form_Resize()
    If Me.WindowState = vbMinimized Then
        If sInitialCaption = "" Then Me.Caption = sMenuConfig.sTitle
    Else
        Me.Height = kFORM_MAIN_HEIGHT
        Me.Width = kFORM_MAIN_WIDTH
        Me.Caption = sInitialCaption
    End If
End Sub


Private Sub imgCompany_Click()
    If sCompanySite <> "" Then OpenSiteByUrl sCompanySite
End Sub


Private Sub imgCompany_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If sCompanySite <> "" Then SetMousePointer vbCustom
End Sub


''Options *********************************
Private Sub imgOptionIcon_Click(Index As Integer)
    lblOptionName_Click Index
End Sub


Private Sub imgOptionIcon_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    If sMenuConfig.sOptions(Index).sPath <> "" Then
        SetMousePointer vbCustom
        lblOptionName(Index).FontUnderline = True
        lblOptionsDesc.Caption = sMenuConfig.sOptions(Index).sDescription
    Else
        lblOptionsDesc.Caption = sMenuConfig.sOptions(Index).sDescription
        lblOptionsDesc.Caption = lblOptionsDesc.Caption & vbNewLine & vbNewLine & kOPT_NOT_AVAIABLE
    End If
End Sub


Private Sub imgProduct_Click()
    If sProductSite <> "" Then OpenSiteByUrl sProductSite
End Sub


Private Sub lblOptionName_Click(Index As Integer)
    Select Case Index
    Case 0
        intOptionSelected = kOPT_00
        lblOptionsDesc.Caption = sMenuConfig.sOptions(0).sDescription
    Case 1
        intOptionSelected = kOPT_01
        lblOptionsDesc.Caption = sMenuConfig.sOptions(1).sDescription
    Case 2
        intOptionSelected = kOPT_02
        lblOptionsDesc.Caption = sMenuConfig.sOptions(2).sDescription
    Case 3
        intOptionSelected = kOPT_03
        lblOptionsDesc.Caption = sMenuConfig.sOptions(3).sDescription
    Case 4
        intOptionSelected = kOPT_04
        lblOptionsDesc.Caption = sMenuConfig.sOptions(4).sDescription
    Case 5
        intOptionSelected = kOPT_05
        lblOptionsDesc.Caption = sMenuConfig.sOptions(5).sDescription
    Case 6
        intOptionSelected = kOPT_06
        lblOptionsDesc.Caption = sMenuConfig.sOptions(6).sDescription
    Case 7
        intOptionSelected = kOPT_07
        lblOptionsDesc.Caption = sMenuConfig.sOptions(7).sDescription
    Case 8
        intOptionSelected = kOPT_08
        lblOptionsDesc.Caption = sMenuConfig.sOptions(8).sDescription
    Case 9
        intOptionSelected = kOPT_09
        lblOptionsDesc.Caption = sMenuConfig.sOptions(9).sDescription
    Case 10
        intOptionSelected = kOPT_10
        lblOptionsDesc.Caption = sMenuConfig.sOptions(10).sDescription
    Case 11
        intOptionSelected = kOPT_11
        lblOptionsDesc.Caption = sMenuConfig.sOptions(11).sDescription
    Case 12
        intOptionSelected = kOPT_12
        lblOptionsDesc.Caption = sMenuConfig.sOptions(12).sDescription
    Case 13
        intOptionSelected = kOPT_13
        lblOptionsDesc.Caption = sMenuConfig.sOptions(13).sDescription
    Case 14
        intOptionSelected = kOPT_14
        lblOptionsDesc.Caption = sMenuConfig.sOptions(14).sDescription
    Case Else
        intOptionSelected = -1
        lblOptionsDesc.Caption = ""
    End Select
    ExecuteOptionSelected
End Sub


Private Sub lblOptionName_MouseMove(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    If sMenuConfig.sOptions(Index).sPath <> "" Then
        SetMousePointer vbCustom
        lblOptionName(Index).FontUnderline = True
        lblOptionsDesc.Caption = sMenuConfig.sOptions(Index).sDescription
    Else
        lblOptionsDesc.Caption = sMenuConfig.sOptions(Index).sDescription
        lblOptionsDesc.Caption = lblOptionsDesc.Caption & vbNewLine & vbNewLine & kOPT_NOT_AVAIABLE
    End If
End Sub


Private Sub imgScrollUp_Click()
    If intOptionPosition <= kOPT_INITIAL_POSITION Then Exit Sub
    ''Move options to Up
    intOptionPosition = intOptionPosition - 1
    SetOptionsPosition intOptionPosition
End Sub


Private Sub imgScrollUp_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbCustom
    lblOptionsDesc.Caption = kSCROLL_INFO_CLICK
End Sub


Private Sub imgScrollUpDisabled_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbDefault
End Sub


Private Sub imgScrollDown_Click()
    If intOptionPosition = intOptionsTotalPositions Then Exit Sub
    If intOptionPosition >= kOPT_LAST_POSITION Then Exit Sub
    ''Move options to down
    intOptionPosition = intOptionPosition + 1
    SetOptionsPosition intOptionPosition
End Sub


Private Sub imgScrollDown_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbCustom
    lblOptionsDesc.Caption = kSCROLL_INFO_CLICK
End Sub


Private Sub imgScrollDownDisabled_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbDefault
End Sub


Private Sub lblOptionsDesc_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbDefault
End Sub


Private Sub imgProduct_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If sProductSite <> "" Then SetMousePointer vbCustom
End Sub


Private Sub fraCompanyInfo_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbDefault
End Sub


Private Sub lblAppVersion_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblVersionMenu.Visible = True
End Sub


Private Sub lblAppVersion_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    lblVersionMenu.Visible = False
End Sub


Private Sub imgMinimizeApplication_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbCustom
End Sub


Private Sub imgMinimizeApplication_Click()
    Me.WindowState = vbMinimized
End Sub


Private Sub imgExitApplication_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    SetMousePointer vbCustom
End Sub


Private Sub imgExitApplication_Click()
    End
End Sub


''Functions *********************************
''Set mouse pointer on mousemove
Private Sub SetMousePointer(mpConstant As MousePointerConstants)
    MousePointer = mpConstant
    If mpConstant = vbDefault Then
        lblOptionsDesc.Caption = ""
        SetOptionsNameFontUnderline False
    End If
End Sub


''Set fon bolt to options names
Private Sub SetOptionsNameFontUnderline(bValue As Boolean)
    Dim iX As Integer

    For iX = 0 To lblOptionName.UBound
        lblOptionName(iX).FontUnderline = bValue
    Next
End Sub


''Set back and fore colors for menu
Private Sub SetMenuBackForeColors()
    Dim iX As Integer
    
    ''Form
    Me.BackColor = lngMenuBackColor
    lblVersionMenu.ForeColor = lngMenuForeColor
    ''Options
    For iX = 0 To lblOptionName.UBound
        lblOptionName(iX).ForeColor = lngMenuForeColor
    Next
    lblOptionsDesc.ForeColor = lngMenuForeColor
    ''Product
    fraProductInfo.BackColor = lngProductBackColor
    lblVersionMenu.ForeColor = lngProductForeColor
    ''Info Company
    fraCompanyInfo.BackColor = lngInfoCompanyBackColor
    lblCopyrightMenu.ForeColor = lngInfoCompanyForeColor
End Sub


''Set images for menu
Private Sub SetMenuImages()
    Dim sImageFile As String
    Dim oFs As FileSystemObject

    Set oFs = New FileSystemObject
    ''Menu Icon
    sImageFile = sMenuConfig.sIcon
    If oFs.FileExists(sImageFile) Then Me.Icon = LoadPicture(sImageFile)
    ''Menu Mouse Icon
    sImageFile = sMenuConfig.sMouseIcon
    If oFs.FileExists(sImageFile) Then Me.MouseIcon = LoadPicture(sImageFile)
    ''Image for product
    sImageFile = sMenuConfig.sImageProduct
    If oFs.FileExists(sImageFile) Then imgProduct.Picture = LoadPicture(sImageFile)
    imgProduct.ToolTipText = sProductSite
    ''Image of Company
    sImageFile = sMenuConfig.sImageCompany
    If oFs.FileExists(sImageFile) Then imgCompany.Picture = LoadPicture(sImageFile)
    imgCompany.ToolTipText = sCompanySite
    Set oFs = Nothing
    ''Load images not in config file
    LoadFixedImagesForMenu
End Sub


''Load the rest of images on menu if file not exists stay with default
Private Sub LoadFixedImagesForMenu()
    Dim sImageFile As String
    Dim oFs As FileSystemObject
    
    Set oFs = New FileSystemObject
    ''Minimize Application
    sImageFile = sAppPath & kIMAGE_MINIMIZE_APPLICATION
    If oFs.FileExists(sImageFile) Then imgMinimizeApplication.Picture = LoadPicture(sImageFile)
    ''Exit Application
    sImageFile = sAppPath & kIMAGE_EXIT_APPLICATION
    If oFs.FileExists(sImageFile) Then imgExitApplication.Picture = LoadPicture(sImageFile)
    ''Menu separators
    sImageFile = sAppPath & kIMAGE_MENU_SEPARATOR
    If oFs.FileExists(sImageFile) Then
        imgTopSeparator.Picture = LoadPicture(sImageFile)
        imgBottomSeparator.Picture = LoadPicture(sImageFile)
    End If
    ''Scroll up
    sImageFile = sAppPath & kIMAGE_SCROLL_UP
    If oFs.FileExists(sImageFile) Then imgScrollUp.Picture = LoadPicture(sImageFile)
    ''Scroll up disabled
    sImageFile = sAppPath & kIMAGE_SCROLL_UP_DISABLED
    If oFs.FileExists(sImageFile) Then imgScrollUpDisabled.Picture = LoadPicture(sImageFile)
    ''Scroll position
    sImageFile = sAppPath & kIMAGE_SCROLL_POSITION
    If oFs.FileExists(sImageFile) Then imgScrollPosition.Picture = LoadPicture(sImageFile)
    ''Scroll down
    sImageFile = sAppPath & kIMAGE_SCROLL_DOWN
    If oFs.FileExists(sImageFile) Then imgScrollDown.Picture = LoadPicture(sImageFile)
    ''Scroll down disabled
    sImageFile = sAppPath & kIMAGE_SCROLL_DOWN_DISABLED
    If oFs.FileExists(sImageFile) Then imgScrollDownDisabled.Picture = LoadPicture(sImageFile)
    Set oFs = Nothing
End Sub


''Clear all install options
Private Sub HideAllInstallOptions()
    Dim iX As Integer
    
    ''Image option icon
    For iX = 0 To imgOptionIcon.UBound
        imgOptionIcon(iX).BorderStyle = 0
        imgOptionIcon(iX).Visible = False
    Next
    ''Option name
    For iX = 0 To lblOptionName.UBound
        lblOptionName(iX).Caption = ""
        lblOptionName(iX).Visible = False
    Next
End Sub


''Set Options icons and show them
Private Sub SetInstallOptionsIcons()
    Dim iX As Integer
    Dim sIconFile As String
    Dim oFs As FileSystemObject

    Set oFs = New FileSystemObject
    ''Option Icon
    For iX = 0 To intOptionsTotalVisible - 1
        sIconFile = sMenuConfig.sOptions(iX).sIcon
        If oFs.FileExists(sIconFile) Then
            imgOptionIcon(iX).Picture = LoadPicture(sIconFile)
            imgOptionIcon(iX).Visible = True
        End If
    Next
    Set oFs = Nothing
End Sub


''Fill options names with config values
Private Sub SetInstallOptionsNames()
    Dim iX As Integer
    
    lblOptionsDesc.Caption = ""
    SetOptionsNameFontUnderline False
    ''Set options from config file
    For iX = 0 To intOptionsTotalVisible - 1
        lblOptionName(iX).Caption = sMenuConfig.sOptions(iX).sName
        lblOptionName(iX).Visible = True
    Next
End Sub


''Set initial values for scroll
Private Sub SetInitialScrollOptions()
    lnScrollLine(0).BorderColor = lngMenuForeColor
    lnScrollLine(1).BorderColor = lngMenuForeColor
    If intOptionsTotalVisible <= kOPT_VISIBLE Then
        imgScrollUp.Visible = False
        imgScrollUpDisabled.Visible = False
        lnScrollLine(0).Visible = False
        lnScrollLine(1).Visible = False
        imgScrollPosition.Visible = False
        imgScrollDown.Visible = False
        imgScrollDownDisabled.Visible = False
        lblOptionsVisible.Visible = False
    Else
        imgScrollUp.Visible = False
        imgScrollUpDisabled.Visible = True
        imgScrollUpDisabled.ToolTipText = SetScrollInfo(kSCROLL_INFO_CURRENT)
        lnScrollLine(0).Visible = True
        lnScrollLine(1).Visible = True
        imgScrollPosition.Visible = False
        imgScrollDown.Visible = True
        imgScrollDown.ToolTipText = SetScrollInfo(kSCROLL_INFO_NEXT)
        imgScrollDownDisabled.Visible = False
        lblOptionsVisible.Visible = False
    End If
End Sub


''Execute option selected
Private Sub ExecuteOptionSelected()
    Dim bRet As Boolean
    Dim sExeFilePath As String
    Dim sExeWait As String

    On Error GoTo ErroExecuteOptionSelected
    
    bRet = False
    Select Case intOptionSelected
    Case kOPT_00
        sExeFilePath = sMenuConfig.sOptions(kOPT_00).sPath
        sExeWait = kWAIT
    Case kOPT_01
        sExeFilePath = sMenuConfig.sOptions(kOPT_01).sPath
        sExeWait = kWAIT
    Case kOPT_02
        sExeFilePath = sMenuConfig.sOptions(kOPT_02).sPath
        sExeWait = kWAIT
    Case kOPT_03
        sExeFilePath = sMenuConfig.sOptions(kOPT_03).sPath
        sExeWait = kWAIT
    Case kOPT_04
        sExeFilePath = sMenuConfig.sOptions(kOPT_04).sPath
        sExeWait = kWAIT
    Case kOPT_05
        sExeFilePath = sMenuConfig.sOptions(kOPT_05).sPath
        sExeWait = kWAIT
    Case kOPT_06
        sExeFilePath = sMenuConfig.sOptions(kOPT_06).sPath
        sExeWait = kWAIT
    Case kOPT_07
        sExeFilePath = sMenuConfig.sOptions(kOPT_07).sPath
        sExeWait = kWAIT
    Case kOPT_08
        sExeFilePath = sMenuConfig.sOptions(kOPT_08).sPath
        sExeWait = kWAIT
    Case kOPT_09
        sExeFilePath = sMenuConfig.sOptions(kOPT_09).sPath
        sExeWait = kWAIT
    Case kOPT_10
        sExeFilePath = sMenuConfig.sOptions(kOPT_10).sPath
        sExeWait = kWAIT
    Case kOPT_11
        sExeFilePath = sMenuConfig.sOptions(kOPT_11).sPath
        sExeWait = kWAIT
    Case kOPT_12
        sExeFilePath = sMenuConfig.sOptions(kOPT_12).sPath
        sExeWait = kWAIT
    Case kOPT_13
        sExeFilePath = sMenuConfig.sOptions(kOPT_13).sPath
        sExeWait = kWAIT
    Case kOPT_14
        sExeFilePath = sMenuConfig.sOptions(kOPT_14).sPath
        sExeWait = kWAIT
    Case Else
        ShowMessageToUser "Não foi seleccionada uma opção para executar!", "", vbInformation
        Exit Sub
    End Select
    ''Lanch selected aplication
    If sExeFilePath <> "" Then
        bRet = ShellApp(Me, sExeFilePath, sExeWait)
        If Not bRet Then ShowMessageToUser "Não foi possível executar a opção seleccionada!", "Erro ao executar o ficheiro '" & sExeFilePath & "'", vbExclamation
    End If
    Exit Sub

ErroExecuteOptionSelected:
    ShowMessageToUser "Não foi possível executar a opção seleccionada!", Err.Description, vbCritical
    Err.Clear
End Sub


''Set initial position for options
Private Sub SetOptionsInitialPosition()
    Dim iX As Integer
    Dim intNextPosition As Integer
    
    intNextPosition = kOPT_IMG_INITIAL_POSITION
    ''Index begins at zero
    For iX = kOPT_FIRST - 1 To kOPT_VISIBLE - 1
        imgOptionIcon(iX).Top = intNextPosition
        lblOptionName(iX).Top = intNextPosition + kOPT_LBL_DIFF
        intNextPosition = intNextPosition + kOPT_IMG_DIFF
    Next
    For iX = kOPT_VISIBLE To kOPT_LAST - 1
        imgOptionIcon(iX).Top = kOPT_IMG_HIDE_POSITION
        lblOptionName(iX).Top = kOPT_IMG_HIDE_POSITION + kOPT_LBL_DIFF
    Next
End Sub


''Hide options
Private Sub SetOptionsHidePosition(intIni As Integer, intEnd As Integer)
    Dim iX As Integer
    
    For iX = intIni - 1 To intEnd - 1
        imgOptionIcon(iX).Top = kOPT_IMG_HIDE_POSITION
        lblOptionName(iX).Top = kOPT_IMG_HIDE_POSITION + kOPT_LBL_DIFF
    Next
End Sub


''Set positions for visible options
Private Sub SetOptionsPosition(intPosition As Integer)
    ''Hide all Positions
    SetOptionsHidePosition kOPT_FIRST, kOPT_LAST
    ''Set visible options
    If intPosition = kOPT_INITIAL_POSITION Then
        SetOptionsInitialPosition
    Else
        SetOptionsValues intPosition
    End If
    SetScrollOptions intOptionPosition
End Sub


''Set values for visible options
Private Sub SetOptionsValues(iPosition As Integer)
    Dim iX As Integer
    Dim intNextPosition As Integer
    Dim intIndexPosition As Integer
    
    ''Initialize positions
    intIndexPosition = iPosition - 1
    intNextPosition = kOPT_IMG_INITIAL_POSITION
    ''Hide previous position
    SetOptionsHidePosition intIndexPosition, intIndexPosition
    For iX = intIndexPosition To intIndexPosition - 1 + kOPT_VISIBLE
        imgOptionIcon(iX).Top = intNextPosition
        lblOptionName(iX).Top = intNextPosition + kOPT_LBL_DIFF
        intNextPosition = intNextPosition + kOPT_IMG_DIFF
    Next
End Sub


''Set scroll value for position
Private Sub SetScrollOptions(iPosition As Integer)
    Dim iLastPos As Integer
    Dim iTopPos As Integer
    
    Select Case intOptionsTotalVisible
    Case Is <= 5
        Exit Sub
    Case 6
        iTopPos = kSCROLL_TOP_OPTIONS_06
    Case 7
        iTopPos = kSCROLL_TOP_OPTIONS_07
    Case 8
        iTopPos = kSCROLL_TOP_OPTIONS_08
    Case 9
        iTopPos = kSCROLL_TOP_OPTIONS_09
    Case 10
        iTopPos = kSCROLL_TOP_OPTIONS_10
    Case 11
        iTopPos = kSCROLL_TOP_OPTIONS_11
    Case 12
        iTopPos = kSCROLL_TOP_OPTIONS_12
    Case 13
        iTopPos = kSCROLL_TOP_OPTIONS_13
    Case 14
        iTopPos = kSCROLL_TOP_OPTIONS_14
    Case 15
        iTopPos = kSCROLL_TOP_OPTIONS_15
    End Select
    iLastPos = kOPT_INITIAL_POSITION + intOptionsTotalVisible - kOPT_VISIBLE
    SetScrollValues iPosition, kOPT_INITIAL_POSITION, iLastPos, iTopPos
End Sub


''Set scroll values for selected position
Private Sub SetScrollValues(iPosition As Integer, iFirst As Integer, iLast As Integer, iTop As Integer)
    Select Case iPosition
    Case iFirst
        imgScrollUp.Visible = False
        imgScrollUpDisabled.Visible = True
        imgScrollUpDisabled.ToolTipText = SetScrollInfo(kSCROLL_INFO_CURRENT)
        imgScrollPosition.Visible = False
        imgScrollDown.ToolTipText = SetScrollInfo(kSCROLL_INFO_NEXT)
        If iTop = 0 Then
            imgScrollDown.Visible = True
            imgScrollDownDisabled.Visible = False
        End If
    Case iLast
        If iTop = 0 Then
            imgScrollUp.Visible = True
            imgScrollUpDisabled.Visible = False
        End If
        imgScrollUp.ToolTipText = SetScrollInfo(kSCROLL_INFO_PREVIOUS)
        imgScrollPosition.Visible = False
        imgScrollDown.Visible = False
        imgScrollDownDisabled.Visible = True
        imgScrollDownDisabled.ToolTipText = SetScrollInfo(kSCROLL_INFO_CURRENT)
    Case Else
        If iTop > 0 Then
            SetScrollPosition iPosition, iTop
            imgScrollUp.ToolTipText = SetScrollInfo(kSCROLL_INFO_PREVIOUS)
            imgScrollPosition.ToolTipText = SetScrollInfo(kSCROLL_INFO_CURRENT)
            imgScrollDown.ToolTipText = SetScrollInfo(kSCROLL_INFO_NEXT)
        End If
    End Select
End Sub


''Set scroll position
Private Sub SetScrollPosition(iPosition As Integer, iTop As Integer)
    imgScrollUp.Visible = True
    imgScrollUpDisabled.Visible = False
    imgScrollPosition.Top = kSCROLL_TOP_INITIAL + ((iPosition - 1) * iTop)
    imgScrollPosition.Visible = True
    imgScrollDown.Visible = True
    imgScrollDownDisabled.Visible = False
End Sub


''Set sroll information for selected position
Private Function SetScrollInfo(sInfoType As String) As String
    Dim iFrom As Integer
    Dim iTo As Integer
    Dim sInfo As String
    
    sInfo = ""
    Select Case UCase(sInfoType)
    Case kSCROLL_INFO_PREVIOUS
        iFrom = intOptionPosition - 1
        iTo = iFrom - 1 + kOPT_VISIBLE
    Case kSCROLL_INFO_CURRENT
        iFrom = intOptionPosition
        iTo = iFrom - 1 + kOPT_VISIBLE
    Case kSCROLL_INFO_NEXT
        iFrom = intOptionPosition + 1
        iTo = iFrom - 1 + kOPT_VISIBLE
    Case Else
    End Select
    iFrom = IIf(iFrom > kOPT_FIRST, iFrom, kOPT_FIRST)
    iTo = IIf(iTo < intOptionsTotalVisible, iTo, intOptionsTotalVisible)
    sInfo = "Opções: " & iFrom & " a " & iTo & " de " & intOptionsTotalVisible
    ''Set label for current options Info
    If UCase(sInfoType) = kSCROLL_INFO_CURRENT Then lblOptionsVisible.Caption = sInfo
    SetScrollInfo = sInfo
End Function

