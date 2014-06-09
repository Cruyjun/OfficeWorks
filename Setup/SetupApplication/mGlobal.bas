Attribute VB_Name = "mGlobal"
Option Explicit

Public lRetError As Long
Public sAppPath As String

Public Const kFORM_MAIN_HEIGHT = 4725
Public Const kFORM_MAIN_WIDTH = 8265

Public Const kCOLOR_WHITE = &H80000005
Public Const kCOLOR_GRAY = &HE0E0E0
Public Const kCOLOR_BLACK = &H80000012

Public Const kWAIT = "WAIT"
Public Const kNOWAIT = "NOWAIT"

Public Const kSTARTF_USESHOWWINDOW = &H1
Public Const kWINDOW_HIDE = 0
Public Const kNORMAL_PRIORITY_CLASS = &H20&
Public Const kINFINITE = -1&
Public Const kSYNCHRONIZE = &H100000
Public Const kMAX_PATH = 260
Public Const kBIF_RETURNONLYFSDIRS = 1

''Special folders
Public Const kWINDOWS_FOLDER = 0
Public Const kSYSTEM_FOLDER = 1
Public Const kTEMP_FOLDER = 2

''Program Files Folder
Public Const kPROGRAM_FILES_FOLDER = "\PROGRAM FILES\"

''Menu fixed Images
Public Const kIMAGE_MINIMIZE_APPLICATION = "\IMAGES\ImageMinimizeApplication.gif"
Public Const kIMAGE_EXIT_APPLICATION = "\IMAGES\ImageExitApplication.gif"
Public Const kIMAGE_MENU_SEPARATOR = "\IMAGES\ImageMenuSeparator.gif"
Public Const kIMAGE_SCROLL_UP = "\IMAGES\ImageScrollUp.gif"
Public Const kIMAGE_SCROLL_UP_DISABLED = "\IMAGES\ImageScrollUpDisabled.gif"
Public Const kIMAGE_SCROLL_POSITION = "\IMAGES\ImageScrollPosition.gif"
Public Const kIMAGE_SCROLL_DOWN = "\IMAGES\ImageScrollDown.gif"
Public Const kIMAGE_SCROLL_DOWN_DISABLED = "\IMAGES\ImageScrollDownDisabled.gif"

''Menu configuration File Name
Public Const kMENU_CONFIGURATION_FILE_NAME = "MenuConfiguration.cfg"

''Menu Parameters name
Public Const kMENU_PARAMETER_ICON = "MENUICON"
Public Const kMENU_PARAMETER_MOUSEICON = "MENUMOUSEICON"
Public Const kMENU_PARAMETER_TITLE = "MENUTITLE"
Public Const kMENU_PARAMETER_IMAGEPRODUCT = "IMAGEPRODUCT"
Public Const kMENU_PARAMETER_IMAGECOMPANY = "IMAGECOMPANY"
Public Const kMENU_PARAMETER_COPYRIGHT = "COPYRIGHT"
Public Const kMENU_PARAMETER_MENU_BACKCOLOR = "MENUBACKCOLOR"
Public Const kMENU_PARAMETER_MENU_FORECOLOR = "MENUFORECOLOR"
Public Const kMENU_PARAMETER_PRODUCT_BACKCOLOR = "PRODUCTBACKCOLOR"
Public Const kMENU_PARAMETER_PRODUCT_FORECOLOR = "PRODUCTFORECOLOR"
Public Const kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR = "INFOCOMPANYBACKCOLOR"
Public Const kMENU_PARAMETER_INFOCOMPANY_FORECOLOR = "INFOCOMPANYFORECOLOR"
Public Const kMENU_PARAMETER_OPTION = "OPTION"

''Menu Attribute name
Public Const kMENU_ATTRIBUTE_ICON = "ICON"
Public Const kMENU_ATTRIBUTE_NAME = "NAME"
Public Const kMENU_ATTRIBUTE_DESCRIPTION = "DESCRIPTION"
Public Const kMENU_ATTRIBUTE_PATH = "PATH"

''Product site
Public sProductSite As String

''Company Name
Public sCompanyName As String
Public Const kDEFAULT_COMPANY_NAME = "Magnetik"
''Company site
Public sCompanySite As String
Public Const kDEFAULT_COMPANY_SITE = "http://www.Magnetik.com"

''Menu Default Colors
Public Const kMENU_DEFAULT_BACKCOLOR = kCOLOR_WHITE
Public Const kMENU_DEFAULT_FORECOLOR = kCOLOR_BLACK
''Product Default Colors
Public Const kPRODUCT_DEFAULT_BACKCOLOR = kCOLOR_WHITE
Public Const kPRODUCT_DEFAULT_FORECOLOR = kCOLOR_BLACK
''Info Company Default Colors
Public Const kINFOCOMPANY_DEFAULT_BACKCOLOR = kCOLOR_WHITE
Public Const kINFOCOMPANY_DEFAULT_FORECOLOR = kCOLOR_BLACK

''Menu Colors
Public lngMenuBackColor As Long
Public lngMenuForeColor As Long
''Product Colors
Public lngProductBackColor As Long
Public lngProductForeColor As Long
''Info Company Colors
Public lngInfoCompanyBackColor As Long
Public lngInfoCompanyForeColor As Long

''Menu Options
Public intOptionSelected As Integer
Public intOptionsTotalVisible As Integer
Public intOptionPosition As Integer
Public intOptionsTotalPositions As Integer

''Menu Options Indexs
Public Const kOPT_00 = 0
Public Const kOPT_01 = 1
Public Const kOPT_02 = 2
Public Const kOPT_03 = 3
Public Const kOPT_04 = 4
Public Const kOPT_05 = 5
Public Const kOPT_06 = 6
Public Const kOPT_07 = 7
Public Const kOPT_08 = 8
Public Const kOPT_09 = 9
Public Const kOPT_10 = 10
Public Const kOPT_11 = 11
Public Const kOPT_12 = 12
Public Const kOPT_13 = 13
Public Const kOPT_14 = 14

''Menu Total Options
Public Const kOPTIONS_TOTAL = 15

''Menu first options count
Public Const kOPT_FIRST = 1
Public Const kOPT_VISIBLE = 5
Public Const kOPT_LAST = 15

''Menu Options positions
Public Const kOPT_INITIAL_POSITION = 1
Public Const kOPT_LAST_POSITION = 11

''Menu option not avaiable for installation
Public Const kOPT_NOT_AVAIABLE = "Opção não disponível para instalação"

''Menu Options Scroll
Public Const kSCROLL_TOP_INITIAL = 1200
Public Const kSCROLL_TOP_OPTIONS_05 = 0
Public Const kSCROLL_TOP_OPTIONS_06 = 0
Public Const kSCROLL_TOP_OPTIONS_07 = 1200
Public Const kSCROLL_TOP_OPTIONS_08 = 800
Public Const kSCROLL_TOP_OPTIONS_09 = 600
Public Const kSCROLL_TOP_OPTIONS_10 = 480
Public Const kSCROLL_TOP_OPTIONS_11 = 400
Public Const kSCROLL_TOP_OPTIONS_12 = 340
Public Const kSCROLL_TOP_OPTIONS_13 = 300
Public Const kSCROLL_TOP_OPTIONS_14 = 260
Public Const kSCROLL_TOP_OPTIONS_15 = 240

''Menu Options Scroll info
Public Const kSCROLL_INFO_PREVIOUS = "PREVIOUS"
Public Const kSCROLL_INFO_CURRENT = "CURRENT"
Public Const kSCROLL_INFO_NEXT = "NEXT"
Public Const kSCROLL_INFO_CLICK = "Clique para navegar nas opções do menu"

''Menu Options default positions
Public Const kOPT_IMG_INITIAL_POSITION = 1120
Public Const kOPT_IMG_HIDE_POSITION = 4700
Public Const kOPT_IMG_DIFF = 600
Public Const kOPT_LBL_DIFF = 80

''Char constants
Public Const kCHAR_CARDINAL = "#"
Public Const kCHAR_SEMICOMMA = ";"
Public Const kCHAR_SLASH = "\"
Public Const kCHAR_EQUAL = "="
Public Const kCHAR_N = "" & vbNewLine & ""
''Char Slash constants
Public Const kCHAR_SLASH_CARDINAL = "\#"
Public Const kCHAR_SLASH_SEMICOMMA = "\;"
Public Const kCHAR_SLASH_SLASH = "\\"
Public Const kCHAR_SLASH_EQUAL = "\="
Public Const kCHAR_SLASH_N = "\n"
''Char replace constants
Public Const kCHAR_CARDINAL_REPLACE = "@0000@"
Public Const kCHAR_SEMICOMMA_REPLACE = "@1111@"
Public Const kCHAR_SLASH_REPLACE = "@2222@"
Public Const kCHAR_EQUAL_REPLACE = "@3333@"
Public Const kCHAR_N_REPLACE = "@4444@"

''Empty string
Public Const kCHAR_EMPTY = ""
''Space string
Public Const kCHAR_SPACE = " "
''Comma char
Public Const kCHAR_COMMA = ","

''Find this string on config file to replace with application path (sAppPath)
Public Const kROOT_REPLACE = "$ROOT$"

''Types for structs
Private Type stAttributes
    sName As String
    sValue As String
End Type

Public Type stOPTION
    sIcon As String
    sName As String
    sDescription As String
    sPath As String
End Type

Public Type stMENUCONFIGURATION
    sIcon As String
    sMouseIcon As String
    sTitle As String
    sImageProduct As String
    sImageCompany As String
    sCopyright As String
    lMenuBackColor As Long
    lMenuForeColor As Long
    lProductBackColor As Long
    lProductForeColor As Long
    lInfoCompanyBackColor As Long
    lInfoCompanyForeColor As Long
    sOptions() As stOPTION
End Type

''Struct for menu configuration
Public sMenuConfig As stMENUCONFIGURATION

Type PROCESS_INFORMATION
    hProcess As Long
    hThread As Long
    dwProcessID As Long
    dwThreadID As Long
End Type

Type STARTUPINFO
    cb As Long
    lpReserved As String
    lpDesktop As String
    lpTitle As String
    dwX As Long
    dwY As Long
    dwXSize As Long
    dwYSize As Long
    dwXCountChars As Long
    dwYCountChars As Long
    dwFillAttribute As Long
    dwFlags As Long
    wShowWindow As Integer
    cbReserved2 As Integer
    lpReserved2 As Long
    hStdInput As Long
    hStdOutput As Long
    hStdError As Long
End Type

' Funções da API do Windows
Declare Function OpenProcess Lib "kernel32" _
        (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, _
        ByVal dwProcessID As Long) As Long

Declare Function CreateProcessA Lib "kernel32" _
        (ByVal lpApplicationName As Long, ByVal lpCommandLine As String, _
        ByVal lpProcessAttributes As Long, ByVal lpThreadAttributes As Long, _
        ByVal bInheritHandles As Long, ByVal dwCreationFLAGS As Long, _
        ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As Long, _
        lpStartupInfo As STARTUPINFO, lpProcessInformation As PROCESS_INFORMATION) As Long
                                                
Declare Function WaitForSingleObject Lib "kernel32" _
        (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long

Declare Function CloseHandle Lib "kernel32" (hObject As Long) As Boolean
        

''Execute an aplication
Function ShellApp(ByVal frm As Form, ByVal ShellCmd As String, Optional sWait As String = kWAIT) As Boolean
    Dim rTaskID As Double
    
    On Error GoTo Error
    
    ShellApp = False
    rTaskID = Shell(ShellCmd, vbNormalFocus)
    If rTaskID <> 0 Then
        If sWait = kWAIT Then WaitForTermination frm, rTaskID
        ShellApp = True
    End If
    Exit Function
    
Error:
    Err.Clear
End Function


''Wait for an aplication started by menu ended
Private Sub WaitForTermination(ByVal frm As Form, ByVal TaskId As Double)
    Dim iTaskHandle As Long
    Dim lResult As Long
    Dim sCaptionAux As String
    
    iTaskHandle = OpenProcess(kSYNCHRONIZE, 0, TaskId)
    If iTaskHandle <> 0 Then
        sCaptionAux = frm.Caption
        frm.WindowState = vbMinimized
        If sCaptionAux = "" Then frm.Caption = sMenuConfig.sTitle
        lResult = WaitForSingleObject(iTaskHandle, kINFINITE)
        CloseHandle (iTaskHandle)
        frm.Caption = sCaptionAux
        frm.WindowState = vbNormal
    End If
End Sub


Sub Main()
    sAppPath = UCase(IIf(Right(App.Path, 1) = "\", Left(App.Path, Len(App.Path) - 1), App.Path))
    intOptionPosition = kOPT_INITIAL_POSITION
    LoadMenuConfiguration
    frmMain.Show
End Sub


''Show message to user
Public Sub ShowMessageToUser(sMsg As String, sMsgError As String, vbType As VbMsgBoxStyle)
    Dim oFs As FileSystemObject
    Dim sMenuTitle As String
    
    Set oFs = New FileSystemObject
    ''Message title
    sMenuTitle = sMenuConfig.sTitle
    If sMenuTitle = "" Then sMenuTitle = "Configuração do Menu"
    frmMessage.lblMessageTitle.Caption = sMenuTitle
    frmMessage.lblMessageTitle.ForeColor = lngMenuForeColor
    ''Message text
    frmMessage.lblMessage.Caption = sMsg
    frmMessage.lblMessage.ToolTipText = sMsg
    frmMessage.lblMessage.ForeColor = lngMenuForeColor
    ''Message error text
    frmMessage.lblMessageError.Caption = "Erro: " & sMsgError
    frmMessage.lblMessageError.ToolTipText = "Erro: " & sMsgError
    frmMessage.lblMessageError.Visible = False
    frmMessage.lblMessageError.ForeColor = lngMenuForeColor
    ''Message Images
    frmMessage.imgMessageNone.Visible = False
    frmMessage.imgMessageInformation.Visible = False
    frmMessage.imgMessageQuestion.Visible = False
    frmMessage.imgMessageExclamation.Visible = False
    frmMessage.imgMessageCritical.Visible = False
    Select Case vbType
        Case vbInformation
            frmMessage.imgMessageInformation.Visible = True
        Case vbQuestion
            frmMessage.imgMessageQuestion.Visible = True
        Case vbExclamation
            frmMessage.imgMessageExclamation.Visible = True
        Case vbCritical
            frmMessage.imgMessageCritical.Visible = True
        Case Else
            frmMessage.imgMessageNone.Visible = True
    End Select
    ''Exit Image
    If oFs.FileExists(sAppPath & kIMAGE_EXIT_APPLICATION) Then frmMessage.imgExitMessage.Picture = LoadPicture(sAppPath & kIMAGE_EXIT_APPLICATION)
    Set oFs = Nothing
    ''Show form
    frmMessage.BackColor = lngMenuBackColor
    frmMessage.Show vbModal
End Sub


''read file with menu configurations
Private Function ReadMenuConfigurationFile() As String
    Dim oTs As TextStream
    Dim oFs As FileSystemObject
    Dim sConfigFile As String
    Dim sFileText As String
    
    On Error GoTo Erro
    
    sFileText = ""
    Set oFs = New FileSystemObject
    sConfigFile = oFs.BuildPath(sAppPath, kMENU_CONFIGURATION_FILE_NAME)
    ''Verify if file exists
    If Not oFs.FileExists(sConfigFile) Then
        ShowMessageToUser "O Ficheiro de configuração '" & kMENU_CONFIGURATION_FILE_NAME & "' não existe na pasta do executável!", "", vbCritical
        End
    End If
    ''Open file for read
    Set oTs = oFs.OpenTextFile(sConfigFile, ForReading)
    ''Read file
    sFileText = oTs.ReadAll()
    ReadMenuConfigurationFile = sFileText
    ''Clear objects
    Set oTs = Nothing
    Set oFs = Nothing
    Exit Function
    
Erro:
    ShowMessageToUser "Não foi possível ler o ficheiro de configuração '" & kMENU_CONFIGURATION_FILE_NAME & "'!", "", vbCritical
    ReadMenuConfigurationFile = ""
    Set oTs = Nothing
    Set oFs = Nothing
    Err.Clear
End Function


''Get configuration from file
Private Sub LoadMenuConfiguration()
    Dim sFileText As String
    Dim vFileText As Variant
    Dim asFileText() As String
    Dim asAttributes() As stAttributes
    Dim sParamName As String
    Dim iX As Integer
    
    ''Set default colors
    sMenuConfig.lMenuBackColor = -1
    lngMenuBackColor = kMENU_DEFAULT_BACKCOLOR
    sMenuConfig.lMenuForeColor = -1
    lngMenuForeColor = kMENU_DEFAULT_FORECOLOR
    sMenuConfig.lProductBackColor = -1
    lngProductBackColor = kPRODUCT_DEFAULT_BACKCOLOR
    sMenuConfig.lProductForeColor = -1
    lngProductForeColor = kPRODUCT_DEFAULT_FORECOLOR
    sMenuConfig.lInfoCompanyBackColor = -1
    lngInfoCompanyBackColor = kINFOCOMPANY_DEFAULT_BACKCOLOR
    sMenuConfig.lInfoCompanyForeColor = -1
    lngInfoCompanyForeColor = kINFOCOMPANY_DEFAULT_FORECOLOR
    ReDim sMenuConfig.sOptions(0)
    ''Read config file
    sFileText = ReadMenuConfigurationFile
    ''Replace special caracters
    sFileText = ReplaceSpecialCharacters(sFileText)
    ''Get parameters (Parameter separator #)
    asFileText = Split(sFileText, "#")
    ''For each parameter get atributes
    For Each vFileText In asFileText
        ''if attribute not empty
        If Len(Trim(vFileText)) > 0 Then
            ''Get number of attribute values
            If GetAttribute(CStr(vFileText), sParamName, asAttributes) > 0 Then
                For iX = 0 To UBound(asAttributes) - 1
                    ''Set attribute values for struct
                    SetAttributeValueToStruct sParamName, asAttributes(iX).sName, asAttributes(iX).sValue
                Next iX
                ''redim options
                ReDimMenuOptions sParamName, UBound(sMenuConfig.sOptions) + 1
            End If
        End If
    Next
    ''Set total options and total of positions
    intOptionsTotalVisible = UBound(sMenuConfig.sOptions)
    intOptionsTotalVisible = IIf(intOptionsTotalVisible < kOPT_LAST, intOptionsTotalVisible, kOPT_LAST)
    intOptionsTotalPositions = SetNumberOfPositions(intOptionsTotalVisible)
End Sub


''Set number of options on configuration
Private Sub ReDimMenuOptions(sParamName As String, iIdx As Integer)
    Select Case UCase(sParamName)
    Case kMENU_PARAMETER_ICON
    Case kMENU_PARAMETER_MOUSEICON
    Case kMENU_PARAMETER_TITLE
    Case kMENU_PARAMETER_IMAGEPRODUCT
    Case kMENU_PARAMETER_IMAGECOMPANY
    Case kMENU_PARAMETER_COPYRIGHT
    Case kMENU_PARAMETER_MENU_BACKCOLOR
    Case kMENU_PARAMETER_MENU_FORECOLOR
    Case kMENU_PARAMETER_PRODUCT_BACKCOLOR
    Case kMENU_PARAMETER_PRODUCT_FORECOLOR
    Case kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR
    Case kMENU_PARAMETER_INFOCOMPANY_FORECOLOR
    Case kMENU_PARAMETER_OPTION
        ReDim Preserve sMenuConfig.sOptions(iIdx)
    Case Else
    End Select
End Sub


''Set attribute value for struct
Private Sub SetAttributeValueToStruct(sParamName As String, sAttributeName As String, sAttributeValue As String)
    Select Case UCase(sAttributeName)
    Case kMENU_ATTRIBUTE_ICON
        Select Case UCase(sParamName)
        Case kMENU_PARAMETER_ICON
            sMenuConfig.sIcon = Replace(UCase(UnScapeAttributes(sAttributeValue)), kROOT_REPLACE, sAppPath)
        Case kMENU_PARAMETER_MOUSEICON
            sMenuConfig.sMouseIcon = Replace(UCase(UnScapeAttributes(sAttributeValue)), kROOT_REPLACE, sAppPath)
        Case kMENU_PARAMETER_TITLE
        Case kMENU_PARAMETER_IMAGEPRODUCT
        Case kMENU_PARAMETER_IMAGECOMPANY
        Case kMENU_PARAMETER_COPYRIGHT
        Case kMENU_PARAMETER_MENU_BACKCOLOR
        Case kMENU_PARAMETER_MENU_FORECOLOR
        Case kMENU_PARAMETER_PRODUCT_BACKCOLOR
        Case kMENU_PARAMETER_PRODUCT_FORECOLOR
        Case kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR
        Case kMENU_PARAMETER_INFOCOMPANY_FORECOLOR
        Case kMENU_PARAMETER_OPTION
            sMenuConfig.sOptions(UBound(sMenuConfig.sOptions)).sIcon = Replace(UCase(UnScapeAttributes(sAttributeValue)), kROOT_REPLACE, sAppPath)
        Case Else
        End Select
    Case kMENU_ATTRIBUTE_NAME
        Select Case UCase(sParamName)
        Case kMENU_PARAMETER_ICON
        Case kMENU_PARAMETER_MOUSEICON
        Case kMENU_PARAMETER_TITLE
            sMenuConfig.sTitle = UnScapeAttributes(sAttributeValue)
        Case kMENU_PARAMETER_IMAGEPRODUCT
        Case kMENU_PARAMETER_IMAGECOMPANY
            sCompanyName = UnScapeAttributes(sAttributeValue)
        Case kMENU_PARAMETER_COPYRIGHT
        Case kMENU_PARAMETER_MENU_FORECOLOR
        Case kMENU_PARAMETER_MENU_BACKCOLOR
        Case kMENU_PARAMETER_PRODUCT_BACKCOLOR
        Case kMENU_PARAMETER_PRODUCT_FORECOLOR
        Case kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR
        Case kMENU_PARAMETER_INFOCOMPANY_FORECOLOR
        Case kMENU_PARAMETER_OPTION
            sMenuConfig.sOptions(UBound(sMenuConfig.sOptions)).sName = UnScapeAttributes(sAttributeValue)
        Case Else
        End Select
    Case kMENU_ATTRIBUTE_DESCRIPTION
        Select Case UCase(sParamName)
        Case kMENU_PARAMETER_ICON
        Case kMENU_PARAMETER_MOUSEICON
        Case kMENU_PARAMETER_TITLE
        Case kMENU_PARAMETER_IMAGEPRODUCT
            sProductSite = UnScapeAttributes(sAttributeValue)
        Case kMENU_PARAMETER_IMAGECOMPANY
            sCompanySite = UnScapeAttributes(sAttributeValue)
        Case kMENU_PARAMETER_COPYRIGHT
            sMenuConfig.sCopyright = UnScapeAttributes(sAttributeValue)
        Case kMENU_PARAMETER_MENU_BACKCOLOR
            sMenuConfig.lMenuBackColor = ConvertColorValueToLong(kMENU_PARAMETER_MENU_BACKCOLOR, UnScapeAttributes(sAttributeValue))
        Case kMENU_PARAMETER_MENU_FORECOLOR
            sMenuConfig.lMenuForeColor = ConvertColorValueToLong(kMENU_PARAMETER_MENU_FORECOLOR, UnScapeAttributes(sAttributeValue))
        Case kMENU_PARAMETER_PRODUCT_BACKCOLOR
            sMenuConfig.lProductBackColor = ConvertColorValueToLong(kMENU_PARAMETER_PRODUCT_BACKCOLOR, UnScapeAttributes(sAttributeValue))
        Case kMENU_PARAMETER_PRODUCT_FORECOLOR
            sMenuConfig.lProductForeColor = ConvertColorValueToLong(kMENU_PARAMETER_PRODUCT_FORECOLOR, UnScapeAttributes(sAttributeValue))
        Case kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR
            sMenuConfig.lInfoCompanyBackColor = ConvertColorValueToLong(kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR, UnScapeAttributes(sAttributeValue))
        Case kMENU_PARAMETER_INFOCOMPANY_FORECOLOR
            sMenuConfig.lInfoCompanyForeColor = ConvertColorValueToLong(kMENU_PARAMETER_INFOCOMPANY_FORECOLOR, UnScapeAttributes(sAttributeValue))
        Case kMENU_PARAMETER_OPTION
            sMenuConfig.sOptions(UBound(sMenuConfig.sOptions)).sDescription = UnScapeAttributes(sAttributeValue)
        Case Else
        End Select
    Case kMENU_ATTRIBUTE_PATH
        Select Case UCase(sParamName)
        Case kMENU_PARAMETER_ICON
        Case kMENU_PARAMETER_MOUSEICON
        Case kMENU_PARAMETER_TITLE
        Case kMENU_PARAMETER_IMAGEPRODUCT
            sMenuConfig.sImageProduct = Replace(UCase(UnScapeAttributes(sAttributeValue)), kROOT_REPLACE, sAppPath)
        Case kMENU_PARAMETER_IMAGECOMPANY
            sMenuConfig.sImageCompany = Replace(UCase(UnScapeAttributes(sAttributeValue)), kROOT_REPLACE, sAppPath)
        Case kMENU_PARAMETER_COPYRIGHT
        Case kMENU_PARAMETER_MENU_BACKCOLOR
        Case kMENU_PARAMETER_MENU_FORECOLOR
        Case kMENU_PARAMETER_PRODUCT_BACKCOLOR
        Case kMENU_PARAMETER_PRODUCT_FORECOLOR
        Case kMENU_PARAMETER_INFOCOMPANY_BACKCOLOR
        Case kMENU_PARAMETER_INFOCOMPANY_FORECOLOR
        Case kMENU_PARAMETER_OPTION
            sMenuConfig.sOptions(UBound(sMenuConfig.sOptions)).sPath = Replace(UCase(UnScapeAttributes(sAttributeValue)), kROOT_REPLACE, sAppPath)
        Case Else
        End Select
    End Select
End Sub


''Get attribute value from configuration
Private Function GetAttribute(sParam As String, sParamName As String, asAttributes() As stAttributes) As Integer
    Dim asParamValues() As String
    Dim asParamName() As String
    Dim vParam As Variant
    
    ''If parameter is empty exit
    If Len(Trim(sParam)) = 0 Then Exit Function
    ''Fill paarmeter values
    asParamValues = Split(sParam, kCHAR_SEMICOMMA)
    ReDim asAttributes(0)
    For Each vParam In asParamValues
        If Len(Trim(vParam)) > 0 Then
            ''Verify if param name have value
            asParamName = Split(vParam, kCHAR_EQUAL)
            If UBound(asParamName) = 0 Then
                sParamName = Replace(asParamName(0), kCHAR_CARDINAL, kCHAR_EMPTY)
            Else
                asAttributes(UBound(asAttributes)).sName = Split(vParam, kCHAR_EQUAL)(0)
                asAttributes(UBound(asAttributes)).sValue = Split(vParam, kCHAR_EQUAL)(1)
                ReDim Preserve asAttributes(UBound(asAttributes) + 1)
            End If
        End If
    Next
    GetAttribute = UBound(asAttributes)
End Function


''Replace special characters on string
Private Function ReplaceSpecialCharacters(sValue As String) As String
    sValue = Replace(sValue, kCHAR_SLASH_CARDINAL, kCHAR_CARDINAL_REPLACE)
    sValue = Replace(sValue, vbNewLine, kCHAR_EMPTY)
    sValue = Replace(sValue, kCHAR_SLASH_SEMICOMMA, kCHAR_SEMICOMMA_REPLACE)
    sValue = Replace(sValue, kCHAR_SLASH_SLASH, kCHAR_SLASH_REPLACE)
    sValue = Replace(sValue, kCHAR_SLASH_EQUAL, kCHAR_EQUAL_REPLACE)
    sValue = Replace(sValue, kCHAR_SLASH_N, kCHAR_N_REPLACE)
    ReplaceSpecialCharacters = sValue
End Function


''Unscape attributes values
Private Function UnScapeAttributes(sValue As String) As String
    sValue = Replace(sValue, kCHAR_SEMICOMMA_REPLACE, kCHAR_SEMICOMMA)
    sValue = Replace(sValue, kCHAR_CARDINAL, kCHAR_EMPTY)
    sValue = Replace(sValue, kCHAR_CARDINAL_REPLACE, kCHAR_CARDINAL)
    sValue = Replace(sValue, kCHAR_SLASH_REPLACE, kCHAR_SLASH)
    sValue = Replace(sValue, kCHAR_EQUAL_REPLACE, kCHAR_EQUAL)
    sValue = Replace(sValue, vbNewLine, kCHAR_EMPTY)
    sValue = Replace(sValue, kCHAR_N_REPLACE, kCHAR_N)
    UnScapeAttributes = Trim(sValue)
End Function


''Set number of positions for options
Private Function SetNumberOfPositions(iTotal As Integer) As Integer
    Dim iNumPositions As Integer
    
    iNumPositions = 0
    Select Case iTotal
    Case Is <= 5
        iNumPositions = 1
    Case 6
        iNumPositions = 2
    Case 7
        iNumPositions = 3
    Case 8
        iNumPositions = 4
    Case 9
        iNumPositions = 5
    Case 10
        iNumPositions = 6
    Case 11
        iNumPositions = 7
    Case 12
        iNumPositions = 8
    Case 13
        iNumPositions = 9
    Case 14
        iNumPositions = 10
    Case 15
        iNumPositions = 11
    Case Else
    End Select
    SetNumberOfPositions = iNumPositions
End Function


''get color value from configuration
Private Function ConvertColorValueToLong(sParam As String, sValue As String) As Long
    Dim iRedValue As Integer
    Dim iGreenValue As Integer
    Dim iBlueValue As Integer
    Dim arrRGBColors() As String
    
    On Error GoTo Erro
    
    iRedValue = -1
    iGreenValue = -1
    iBlueValue = -1
    ConvertColorValueToLong = -1
    ''If no value use default
    If sValue = "" Then Exit Function
    arrRGBColors = Split(sValue, kCHAR_COMMA)
    If UBound(arrRGBColors) >= 0 Then iRedValue = IIf(arrRGBColors(0) < 0 Or arrRGBColors(0) > 255, -1, arrRGBColors(0))
    If UBound(arrRGBColors) >= 1 Then iGreenValue = IIf(arrRGBColors(1) < 0 Or arrRGBColors(1) > 255, -1, arrRGBColors(1))
    If UBound(arrRGBColors) >= 2 Then iBlueValue = IIf(arrRGBColors(2) < 0 Or arrRGBColors(2) > 255, -1, arrRGBColors(2))
    ConvertColorValueToLong = RGB(iRedValue, iGreenValue, iBlueValue)
    Exit Function

Erro:
    ConvertColorValueToLong = -1
    ShowMessageToUser "Não foi possível atribuir as cores." & vbNewLine & _
        "(" & sParam & " - Valores entre 0,0,0 e 255,255,255)", Err.Description, vbExclamation
    Err.Clear
End Function


''Get back and fore colors for menu
Public Sub GetMenuConfigColors()
    ''Menu BackColor
    lngMenuBackColor = sMenuConfig.lMenuBackColor
    ''Menu ForeColor
    lngMenuForeColor = sMenuConfig.lMenuForeColor
    If lngMenuBackColor < 0 Or lngMenuForeColor < 0 Then
        lngMenuBackColor = kMENU_DEFAULT_BACKCOLOR
        lngMenuForeColor = kMENU_DEFAULT_FORECOLOR
    End If
    ''Product BackColor
    lngProductBackColor = sMenuConfig.lProductBackColor
    ''Product ForeColor
    lngProductForeColor = sMenuConfig.lProductForeColor
    If lngProductBackColor < 0 Or lngProductForeColor < 0 Then
        lngProductBackColor = kPRODUCT_DEFAULT_BACKCOLOR
        lngProductForeColor = kPRODUCT_DEFAULT_FORECOLOR
    End If
    ''Info company BackColor
    lngInfoCompanyBackColor = sMenuConfig.lInfoCompanyBackColor
    ''Info company ForeColor
    lngInfoCompanyForeColor = sMenuConfig.lInfoCompanyForeColor
    If lngInfoCompanyBackColor < 0 Or lngInfoCompanyForeColor < 0 Then
        lngInfoCompanyBackColor = kINFOCOMPANY_DEFAULT_BACKCOLOR
        lngInfoCompanyForeColor = kINFOCOMPANY_DEFAULT_FORECOLOR
    End If
End Sub


''Get application from program files
Public Function GetApplicationLocation(sApplicationName As String, sApplicationExe As String) As String
    Dim oFs As FileSystemObject
    Dim sProgramFilesPath As String
    Dim sAppLocation As String
    
    On Error GoTo Erro
    
    GetApplicationLocation = ""
    Set oFs = New FileSystemObject
    ''Get program files directory
    sProgramFilesPath = oFs.GetDriveName(oFs.GetSpecialFolder(kSYSTEM_FOLDER)) & kPROGRAM_FILES_FOLDER
    ''Set application exe path
    sAppLocation = oFs.BuildPath(sProgramFilesPath & sApplicationName, sApplicationExe)
    ''if application exists set application location
    If oFs.FileExists(sAppLocation) Then GetApplicationLocation = sAppLocation
    Set oFs = Nothing
    Exit Function
    
Erro:
    ShowMessageToUser "Não foi possível obter a localização da aplicação '" & sApplicationExe & "'!", Err.Description, vbCritical
    Set oFs = Nothing
    Err.Clear
End Function


''Open site by URL
Public Sub OpenSiteByUrl(sUrl As String)
    Dim objIE As Object
    
    On Error GoTo Erro
    
    Set objIE = CreateObject("InternetExplorer.Application")
    objIE.Visible = 1
    objIE.Navigate sUrl
    Set objIE = Nothing
    Exit Sub
    
Erro:
    ShowMessageToUser "Não foi possível visualizar o site " & sUrl & "", Err.Description, vbCritical
    Set objIE = Nothing
    Err.Clear
End Sub

